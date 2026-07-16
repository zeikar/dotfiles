#!/usr/bin/env bash
# Claude Code status line — 2-line rich layout.
#   Line 1: model·effort · dir · git branch/status · worktree · PR
#   Line 2: context bar+% · rate limits (5h/7d + reset) · cost · duration
# Data arrives as JSON on stdin; see https://code.claude.com/docs/en/statusline
# Managed via Stow in dotfiles; symlinked to ~/.claude/statusline.sh.

input=$(cat)

# --- Extract every field in one jq pass ---
# Join with the unit-separator control char (0x1f). A non-whitespace IFS
# preserves empty fields (a whitespace IFS like tab collapses adjacent ones).
IFS=$'\037' read -r \
  MODEL EFFORT DIR WORKTREE SESSION PCT \
  R5 R5RESET R7 R7RESET COST DURMS PRNUM PRSTATE \
  < <(printf '%s' "$input" | jq -r '
    [ (.model.display_name // "?"),
      (.effort.level // ""),
      (.workspace.current_dir // "."),
      (.workspace.git_worktree // ""),
      (.session_id // "nosession"),
      (.context_window.used_percentage // 0 | floor),
      (.rate_limits.five_hour.used_percentage  // ""),
      (.rate_limits.five_hour.resets_at        // ""),
      (.rate_limits.seven_day.used_percentage  // ""),
      (.rate_limits.seven_day.resets_at        // ""),
      (.cost.total_cost_usd // 0),
      (.cost.total_duration_ms // 0),
      (.pr.number // ""),
      (.pr.review_state // "")
    ] | map(tostring) | join("")')

# --- Colors ---
R=$'\033[0m'; DIM=$'\033[2m'; B=$'\033[1m'
GREEN=$'\033[32m'; YELLOW=$'\033[33m'; RED=$'\033[31m'
CYAN=$'\033[36m'; BLUE=$'\033[34m'; MAGENTA=$'\033[35m'

# Drop trailing optional segments (cost/duration/PR-state) on narrow terminals.
COLS=${COLUMNS:-120}
WIDE=1; [ "$COLS" -lt 80 ] && WIDE=0

# Build a usage bar of the given width from a percentage.
make_bar() { # $1=pct $2=width
  local pct=$1 w=$2 fill rest t b=""
  fill=$((pct * w / 100)); [ "$fill" -gt "$w" ] && fill=$w; [ "$fill" -lt 0 ] && fill=0
  rest=$((w - fill))
  [ "$fill" -gt 0 ] && printf -v t "%${fill}s" && b="${t// /█}"
  [ "$rest" -gt 0 ] && printf -v t "%${rest}s" && b+="${t// /░}"
  printf '%s' "$b"
}

# Each bar keeps its own hue for at-a-glance distinction, but flips to red
# once it crosses its critical threshold.
bar_color() { # $1=pct $2=base_color $3=crit_at
  [ "$1" -ge "$3" ] && { printf '%s' "$RED"; return; }
  printf '%s' "$2"
}

# Compact duration from seconds: 3d2h / 2h5m / 5m / 40s.
fmt_dur() {
  local s=$1 d h m
  [ "$s" -le 0 ] && { printf 'now'; return; }
  d=$((s/86400)); h=$(((s%86400)/3600)); m=$(((s%3600)/60))
  if   [ "$d" -gt 0 ]; then printf '%dd%dh' "$d" "$h"
  elif [ "$h" -gt 0 ]; then printf '%dh%dm' "$h" "$m"
  elif [ "$m" -gt 0 ]; then printf '%dm' "$m"
  else printf '%ds' "$s"; fi
}

# Calendar date (month/day) from an epoch — BSD date, GNU fallback.
fmt_date() {
  date -r "$1" '+%-m/%-d' 2>/dev/null || date -d "@$1" '+%-m/%-d' 2>/dev/null
}

# ============================ LINE 1: identity ============================
line1="${CYAN}${B}${MODEL}${R}"
[ -n "$EFFORT" ] && line1+="${DIM}·${EFFORT}${R}"
line1+="  📁 ${DIR##*/}"

# --- git (cached per-session to survive frequent refreshes) ---
CACHE="${TMPDIR:-/tmp}/cc-statusline-git-${SESSION}"
cache_stale() {
  [ ! -f "$CACHE" ] || \
  [ "$(( $(date +%s) - $(stat -f %m "$CACHE" 2>/dev/null || stat -c %Y "$CACHE" 2>/dev/null || echo 0) ))" -gt 3 ]
}
if cache_stale; then
  if git -C "$DIR" rev-parse --git-dir >/dev/null 2>&1; then
    b=$(git -C "$DIR" branch --show-current 2>/dev/null)
    s=$(git -C "$DIR" diff --cached  --numstat 2>/dev/null | grep -c .)
    m=$(git -C "$DIR" diff          --numstat 2>/dev/null | grep -c .)
    u=$(git -C "$DIR" ls-files --others --exclude-standard 2>/dev/null | grep -c .)
    printf '%s\t%s\t%s\t%s\n' "$b" "$s" "$m" "$u" > "$CACHE"
  else
    printf '\t\t\t\n' > "$CACHE"
  fi
fi
IFS=$'\t' read -r BRANCH STAGED MODIFIED UNTRACKED < "$CACHE"

if [ -n "$BRANCH" ]; then
  line1+="  🌿 ${BRANCH}"
  gs=""
  [ "${STAGED:-0}"    -gt 0 ] && gs+=" ${GREEN}+${STAGED}${R}"
  [ "${MODIFIED:-0}"  -gt 0 ] && gs+=" ${YELLOW}~${MODIFIED}${R}"
  [ "${UNTRACKED:-0}" -gt 0 ] && gs+=" ${DIM}?${UNTRACKED}${R}"
  line1+="$gs"
fi
[ -n "$WORKTREE" ] && line1+="  ${MAGENTA}🌳 ${WORKTREE}${R}"

if [ -n "$PRNUM" ]; then
  line1+="  ${BLUE}🔀 #${PRNUM}${R}"
  if [ "$WIDE" = 1 ] && [ -n "$PRSTATE" ]; then
    case "$PRSTATE" in
      approved)          line1+=" ${GREEN}${PRSTATE}${R}";;
      changes_requested) line1+=" ${RED}${PRSTATE}${R}";;
      *)                 line1+=" ${DIM}${PRSTATE}${R}";;
    esac
  fi
fi

# cost / duration live at the tail of line 1 (wide terminals only)
if [ "$WIDE" = 1 ]; then
  line1+="  💰 ${YELLOW}$(printf '$%.2f' "${COST:-0}")${R} ${DIM}· $(fmt_dur $((DURMS/1000)))${R}"
fi

# ======================= LINE 2: usage gauges =======================
# Uniform "label bar %" gauges, each its own hue (ctx=cyan, 5h=magenta,
# 7d=blue); a gauge turns red past its critical threshold. Spaced, not
# dot-separated, for a calmer line.
now=$(date +%s)
GAP="   "    # 3 spaces between gauges
BAR_W=10     # shared bar width so all gauges line up

# context (cyan; critical at 90%)
PCT=${PCT%%.*}; [ -z "$PCT" ] && PCT=0
line2="${DIM}ctx${R} $(bar_color "$PCT" "$CYAN" 90)$(make_bar "$PCT" "$BAR_W")${R} ${PCT}%"

# 5-hour rate limit (magenta; critical at 80%; reset as countdown) — Pro/Max only
if [ -n "$R5" ]; then
  p=$(printf '%.0f' "$R5")
  seg="${DIM}5h${R} $(bar_color "$p" "$MAGENTA" 80)$(make_bar "$p" "$BAR_W")${R} ${p}%"
  [ -n "$R5RESET" ] && seg+=" ${DIM}⟳$(fmt_dur $((R5RESET-now)))${R}"
  line2+="${GAP}${seg}"
fi

# 7-day rate limit (blue; critical at 80%; reset as calendar date)
if [ -n "$R7" ]; then
  p=$(printf '%.0f' "$R7")
  seg="${DIM}7d${R} $(bar_color "$p" "$BLUE" 80)$(make_bar "$p" "$BAR_W")${R} ${p}%"
  [ -n "$R7RESET" ] && seg+=" ${DIM}⟳$(fmt_date "$R7RESET")${R}"
  line2+="${GAP}${seg}"
fi

printf '%b\n%b\n' "$line1" "$line2"
