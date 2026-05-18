#!/usr/bin/env bash
# codex_imagegen_batch.sh
#
# Generate N images with Codex CLI's image_generation tool, running up to
# MAX_PARALLEL `codex exec` jobs concurrently and proceeding in sequential
# batches once that many are in flight.
#
# Usage:
#   codex_imagegen_batch.sh <work_dir> "<prompt>::<out.png>" ["<prompt>::<out.png>" ...]
#
# Outputs land in <work_dir>/. Per-job codex transcripts and stdout are kept
# in <work_dir>/.codex-imagegen-logs/.

set -u -o pipefail

readonly MAX_PARALLEL=5

die() { echo "[error] $*" >&2; exit 1; }

usage() {
  cat >&2 <<'EOF'
Usage: codex_imagegen_batch.sh <work_dir> "<prompt>::<out.png>" [more...]

Each item is "<prompt>::<output_filename>". Output filenames must be unique.
Up to 5 jobs run at once; the rest follow in batches of 5.

Example:
  codex_imagegen_batch.sh ./out \
    "a red apple on white::apple.png" \
    "a blue ceramic mug::mug.png"
EOF
  exit 1
}

[ $# -ge 2 ] || usage

work_dir=$1; shift
[ -d "$work_dir" ] || die "work_dir not found: $work_dir"
work_dir=$(cd "$work_dir" && pwd)

log_dir="$work_dir/.codex-imagegen-logs"
mkdir -p "$log_dir"

command -v codex >/dev/null 2>&1 || die "codex CLI not found in PATH"
codex login status >/dev/null 2>&1 || die "codex not logged in — run: codex login"

# Parse "<prompt>::<output>" items, rejecting malformed or duplicate outputs.
prompts=() outputs=()
for item in "$@"; do
  case "$item" in
    *"::"*) ;;
    *) die "item missing '::' separator: $item" ;;
  esac
  prompt=${item%%::*}
  output=${item#*::}
  [ -n "$prompt" ] && [ -n "$output" ] || die "empty prompt or output: $item"
  for seen in ${outputs[@]+"${outputs[@]}"}; do
    [ "$seen" = "$output" ] && die "duplicate output filename: $output"
  done
  prompts+=("$prompt")
  outputs+=("$output")
done

total=${#prompts[@]}
echo "[info] work_dir:    $work_dir"
echo "[info] total jobs:  $total"
echo "[info] parallelism: up to $MAX_PARALLEL per batch"
echo

# One image. codex is told to save into work_dir (we run with --cd "$work_dir").
run_one() {
  local idx=$1 prompt=$2 output=$3
  local tag; tag=$(printf '%03d' "$idx")

  codex exec \
    --sandbox workspace-write \
    --skip-git-repo-check \
    --cd "$work_dir" \
    -o "$log_dir/$tag.md" \
    "Use the image generation tool to create an image of '$prompt'. Save it to ./$output. Reply with only the file path on one line." \
    >"$log_dir/$tag.stdout" 2>&1
  local rc=$?

  if [ $rc -eq 0 ] && [ -s "$work_dir/$output" ]; then
    echo "  [ok]   #$idx  $output  ($(wc -c <"$work_dir/$output" | tr -d ' ') bytes)"
    return 0
  fi
  echo "  [fail] #$idx  $output  (rc=$rc) — see $log_dir/$tag.stdout"
  return 1
}

overall_start=$(date +%s)
batch_no=1
i=0
while [ $i -lt $total ]; do
  end=$(( i + MAX_PARALLEL ))
  [ $end -gt $total ] && end=$total

  echo "=== batch $batch_no — jobs $(( i + 1 ))..$end ==="
  batch_start=$(date +%s)

  pids=()
  for (( j = i; j < end; j++ )); do
    run_one "$(( j + 1 ))" "${prompts[$j]}" "${outputs[$j]}" &
    pids+=($!)
  done

  failed=0
  for pid in "${pids[@]}"; do
    wait "$pid" || failed=$(( failed + 1 ))
  done

  echo "    elapsed $(( $(date +%s) - batch_start ))s, failed $failed"
  echo

  i=$end
  batch_no=$(( batch_no + 1 ))
done

echo "[done] total $(( $(date +%s) - overall_start ))s"
echo "[done] outputs: $work_dir"
echo "[done] logs:    $log_dir"
