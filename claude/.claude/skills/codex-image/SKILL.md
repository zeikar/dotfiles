---
name: codex-image
description: "Generate images via Codex CLI's built-in `image_generation` tool (`codex exec`), single or many in parallel. Use when the user wants images from codex, or batch/parallel image generation."
---

# Codex Image Generation

Drive Codex CLI's built-in `image_generation` tool non-interactively with `codex exec`. The point of this skill is throughput: each `codex exec` is an isolated session, so running several in the background gives near-true parallelism without touching an API key.

## Preflight

```bash
codex --version                                # recent build
codex login status                             # expect "Logged in using ChatGPT"
codex features list | grep image_generation    # the tool must be enabled
```

If not logged in, ask the user to run `codex login` once before proceeding. If `image_generation` is absent, the tool is disabled — surface that rather than retrying blindly.

## Single image

```bash
codex exec \
  --sandbox workspace-write \
  --skip-git-repo-check \
  -c project_doc_max_bytes=0 \
  -c model_reasoning_effort=low \
  --cd <work_dir> \
  -o /tmp/codex-img.md \
  "Use the image generation tool to create an image of '<prompt>'. Save it to ./<output>.png. Reply with only the file path on one line."
```

The two `-c` overrides are what keep a job from paying for work it does not do:

- **`project_doc_max_bytes=0`** — codex walks up from `--cd` and injects the enclosing repo's `AGENTS.md` and `README.md` as project context. A `work_dir` inside a repo therefore ships that repo's instructions with every image. Measured on one real run: 19,277 tokens for a single drawing, most of it a README the image tool never sees. Harmless when `work_dir` is a scratch dir outside any repo — which is what the rest of this skill assumes — and expensive the moment it is not.
- **`model_reasoning_effort=low`** — the model's whole job is to call `image_generation` with the prompt; reasoning depth buys nothing. `low` is the default these models ship with, so this only undoes a global `~/.codex/config.toml` that raised it.

Resolution is chosen by the model from the prompt and is not reliably forceable, so this tool is a poor fit when an exact size is required. Expect on the order of a minute or two per image, with wide variance.

## Many images in parallel

Fire one `codex exec` per image as separate **backgrounded Bash tool calls in the same turn**, each writing a distinct output filename. Because the jobs are independent sessions, the OpenAI side processes them concurrently; completion arrives via background-job notifications, so do not `sleep`-poll.

The practical ceiling is ~5 concurrent — beyond that the plan's request limits queue the extras and per-job latency climbs, so you stop gaining wall-clock. For more than ~5, run sequential batches of 5 (see the helper). Always verify before assuming numbers; measure on the actual plan if it matters.

## Helper script — `scripts/codex_imagegen_batch.sh`

Generates an arbitrary number of images in sequential batches of up to 5 concurrent jobs.

```bash
scripts/codex_imagegen_batch.sh <work_dir> \
  "a red apple on white::apple.png" \
  "a blue ceramic mug::mug.png" \
  "a potted green plant::plant.png"
```

- Each argument is `<prompt>::<output_filename>`; filenames must be unique (same path = last writer wins).
- Output PNGs land in `<work_dir>/`; per-job codex transcripts go to `<work_dir>/.codex-imagegen-logs/`.
- The script validates inputs, checks `codex` is present and logged in, and exits non-zero with a clear message otherwise.

## Verify results

codex sometimes leaves a file in `~/.codex/generated_images/<session>/` instead of the work dir, or a job fails and writes nothing.

```bash
ls -la <work_dir>/*.png
file <work_dir>/*.png        # confirm "PNG image data", not 0-byte/empty
```

Retry only the failed jobs. If a file exists only under `~/.codex/generated_images/`, strengthen the "Save it to ./<file>" instruction in the prompt.

## Cost and plan notes

- Each call is a full independent codex session: token use scales with N, and the ChatGPT plan's message/rate limit is consumed per job.
- **You cannot check remaining quota before a run.** `codex login status` reports authentication only — byte-identical output before and after the limit is hit. Quota shows up only when a job is refused: `codex exec` exits non-zero and its log carries `You've hit your usage limit` plus a reset time. On a heavy run, fire ONE job and read it before firing the rest.
- Sessions persist under `~/.codex/sessions/`; add `--ephemeral` for one-off or sensitive prompts.

## Anti-patterns

- `--ask-for-approval` with `codex exec` — non-interactive, errors out immediately.
- Foreground sequential runs when parallel was wanted — defeats the entire purpose; background the jobs.
- `sleep` polling for completion — background notifications already arrive.
- Reusing one output filename across parallel jobs — only the last survives.
- Omitting `--skip-git-repo-check` outside a git repo — codex stalls on workspace validation.

## Troubleshooting

| Symptom | Likely cause / action |
|---|---|
| 0-byte or missing PNG | Job's tool call failed — retry just that job |
| Everything slow / serialized | Plan rate limit or network. `codex login status` will not show this — run one job and read its log |
| "image generation tool not available" | Feature disabled — check `codex features list`, optionally `--enable image_generation` |
| File only in `~/.codex/generated_images/` | codex didn't copy it — make the "Save to ./<file>" instruction explicit |
| Inconsistent resolution | Expected — codex picks size from the prompt; not suitable when an exact size is required |
