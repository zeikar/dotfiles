#!/usr/bin/env bash
# Claude Code status line — multi-line rich layout.
#   Line 1: model·effort · dir · git branch/status · worktree · PR · cost · duration
#   Line 2: context bar+% · rate limits (5h/7d + reset)
#   Line 3: Codex rate limits (5h/7d + reset) · reset credits — once fetched
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

# Seconds since a file was last modified; very large if it doesn't exist.
file_age() {
  local m
  m=$(stat -f %m "$1" 2>/dev/null || stat -c %Y "$1" 2>/dev/null || echo 0)
  printf '%s' $(( $(date +%s) - m ))
}

# ============================ LINE 1: identity ============================
line1="${CYAN}${B}${MODEL}${R}"
[ -n "$EFFORT" ] && line1+="${DIM}·${EFFORT}${R}"
line1+="  📁 ${DIR##*/}"

# --- git (cached per-session to survive frequent refreshes) ---
CACHE="${TMPDIR:-/tmp}/cc-statusline-git-${SESSION}"
if [ "$(file_age "$CACHE")" -gt 3 ]; then
  if git -C "$DIR" rev-parse --git-dir >/dev/null 2>&1; then
    b=$(git -C "$DIR" branch --show-current 2>/dev/null)
    # Detached HEAD (rebase, bisect) has no branch name; show the short SHA.
    [ -z "$b" ] && b=$(git -C "$DIR" rev-parse --short HEAD 2>/dev/null)
    s=$(git -C "$DIR" diff --cached  --numstat 2>/dev/null | grep -c .)
    m=$(git -C "$DIR" diff          --numstat 2>/dev/null | grep -c .)
    u=$(git -C "$DIR" ls-files --others --exclude-standard 2>/dev/null | grep -c .)
    # 0x1f-separated, like the jq pass at the top: a tab IFS would shift the
    # counts left into BRANCH whenever the branch field is empty.
    printf '%s\037%s\037%s\037%s\n' "$b" "$s" "$m" "$u" > "$CACHE"
  else
    printf '\037\037\037\n' > "$CACHE"
  fi
fi
IFS=$'\037' read -r BRANCH STAGED MODIFIED UNTRACKED < "$CACHE"

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

# Rate-limit gauge: critical at 80%, reset shown as a countdown.
rate_gauge() { # $1=label $2=pct $3=reset_epoch $4=color
  local p; p=$(printf '%.0f' "$2")
  printf '%s' "${DIM}$1${R} $(bar_color "$p" "$4" 80)$(make_bar "$p" "$BAR_W")${R} ${p}%"
  [ -n "$3" ] && printf '%s' " ${DIM}⟳$(fmt_dur $(($3 - now)))${R}"
}

# 5-hour (magenta) and 7-day (blue) rate limits — Pro/Max only
[ -n "$R5" ] && line2+="${GAP}$(rate_gauge 5h "$R5" "$R5RESET" "$MAGENTA")"
[ -n "$R7" ] && line2+="${GAP}$(rate_gauge 7d "$R7" "$R7RESET" "$BLUE")"

# ======================= LINE 3: Codex usage =======================
# Read live from `codex app-server` (account/rateLimits/read, the same call
# Orca makes). It costs ~1s over the network, so it runs in the background at
# most every 2 minutes and this line renders from the cached result.
CX_CACHE="${TMPDIR:-/tmp}/cc-statusline-codex"
CX_TTL=120

# Prints "5h% 5h_reset 7d% 7d_reset reset_credits", or nothing. Fields are
# 0x1f-separated for the same reason as the jq pass at the top: `primary`
# can be null, and a tab IFS would shift the 7d numbers into the 5h slots.
codex_fetch() {
  local out; out=$(mktemp) || return
  # app-server exits on stdin EOF, so hold stdin open until the reply lands.
  # macOS has no `timeout`. `codex` is a Node wrapper that forwards TERM (not
  # ALRM) to the native server, so perl sends TERM once the alarm fires.
  # shellcheck disable=SC2094 # polling the reply file is the point
  { printf '%s\n' \
      '{"jsonrpc":"2.0","id":0,"method":"initialize","params":{"clientInfo":{"name":"statusline","version":"0"}}}' \
      '{"jsonrpc":"2.0","method":"initialized"}' \
      '{"jsonrpc":"2.0","id":1,"method":"account/rateLimits/read"}'
    for _ in $(seq 40); do grep -q '"id":1,' "$out" && break; sleep 0.5; done
  } | perl -e 'defined($p = fork) or die; exec @ARGV unless $p;
               $SIG{ALRM} = sub { kill TERM => $p }; alarm 25; waitpid $p, 0' \
      codex -c approval_policy=never -s read-only -a never app-server >"$out" 2>/dev/null
  jq -r 'select(.id == 1 and .result != null) | .result
    | (.rateLimitsByLimitId.codex // .rateLimits) as $l
    | select($l.primary != null or $l.secondary != null)
    | [ ($l.primary.usedPercent // ""),   ($l.primary.resetsAt // ""),
        ($l.secondary.usedPercent // ""), ($l.secondary.resetsAt // ""),
        (.rateLimitResetCredits.availableCount // 0) ]
    | map(tostring) | join("")' "$out" 2>/dev/null
  rm -f "$out"
}

if [ "$(file_age "$CX_CACHE")" -ge "$CX_TTL" ] && command -v codex >/dev/null; then
  CX_LOCK="$CX_CACHE.lock"
  [ "$(file_age "$CX_LOCK")" -gt 60 ] && rmdir "$CX_LOCK" 2>/dev/null
  if mkdir "$CX_LOCK" 2>/dev/null; then
    # On failure keep the last result but touch it, so an offline machine
    # retries every CX_TTL rather than on every refresh.
    # The temp name is unique because a lock broken as stale (e.g. across
    # sleep) can leave two fetches racing to the same rename.
    ( row=$(codex_fetch)
      if [ -n "$row" ] && tmp=$(mktemp "$CX_CACHE.XXXXXX"); then
        printf '%s\037%s\n' "$(date +%s)" "$row" > "$tmp" && mv "$tmp" "$CX_CACHE"
      else
        touch "$CX_CACHE"
      fi
      rmdir "$CX_LOCK" ) </dev/null >/dev/null 2>&1 &
  fi
fi

line3=""
if [ -s "$CX_CACHE" ]; then
  IFS=$'\037' read -r CXAT CX5 CX5RESET CX7 CX7RESET CXCREDITS < "$CX_CACHE"
  line3="${DIM}codex${R}"
  [ -n "$CX5" ] && line3+="${GAP}$(rate_gauge 5h "$CX5" "$CX5RESET" "$MAGENTA")"
  [ -n "$CX7" ] && line3+="${GAP}$(rate_gauge 7d "$CX7" "$CX7RESET" "$BLUE")"
  [ "${CXCREDITS:-0}" -gt 0 ] && line3+="${GAP}${YELLOW}↺${CXCREDITS}${R}"
  # Fetches keep failing (offline, signed out): say how old these numbers are.
  [ $((now - CXAT)) -gt 600 ] && line3+="  ${DIM}$(fmt_dur $((now - CXAT))) ago${R}"
fi

printf '%b\n%b\n' "$line1" "$line2"
if [ -n "$line3" ]; then printf '%b\n' "$line3"; fi
