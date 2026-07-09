---
name: hyper-autopilot
description: This skill should be used when the user asks to "autopilot", "autopilot now", "kick off autopilot immediately", "start work in N hours", "work on it while I'm asleep", "trigger in a few hours", "set up autopilot for later", or makes any "leave it running" / "fire-and-forget" request over the local hyperclaude loop (distinct from GitHub-native octoperator autopilot). Runs a fire-and-forget autonomous workflow that loops the hyperclaude cycle (hyper-auto → plan-loop → implement-loop) → ff merge → push → next task, until context exhausts or a stop condition fires. Two delivery modes — (a) **scheduled** wakes up N hours/minutes from now via `CronCreate`; (b) **immediate** starts right now in this session, no cron. Requires the hyperclaude plugin installed (it drives `/hyperclaude:hyper-auto`).
---

# Hyper-autopilot — autonomous-loop runner (scheduled or immediate)

Thin driver over the **hyperclaude plugin**. Assemble a per-round loop prompt — `/hyperclaude:hyper-auto` → ff-merge to main → push → pick next task → repeat — and fire it now or on a schedule. `hyper-auto` owns the plan→implement chaining and its between-phase safety stop; autopilot only adds scheduling + merge/push/next-task orchestration on top.

- **Prerequisite:** if hyperclaude is not installed there is nothing to drive — STOP and say so. Never hand-roll the plan/implement steps.
- **Single round only** (no auto-pickup of the next task): skip this skill, run `/hyperclaude:hyper-auto` directly. Autopilot's value is the multi-round loop.
- **Remote/cloud execution:** use `/schedule` (RemoteTrigger), not this.

## Modes

- **Immediate** — "now" / "right away" / no time given: start executing the assembled prompt inline this session.
- **Scheduled** — "in N hours" / "tomorrow 8am" / "at 03:00": fire once via `CronCreate`. The session must stay **alive and idle** until then (closing the terminal kills it; locking the laptop is fine).

Ambiguous phrasing → ask which, don't guess.

## Procedure

1. **Inputs.** Round-1 task (one paragraph — `hyper-auto` expands it). Optional: follow-up candidates, extra constraints.

2. **(Scheduled only) Resolve time + build cron.** Read live time (`date -u +%Y-%m-%dT%H:%M:%SZ`, `date +%Y-%m-%d`) — never a stale conversation anchor. Parse the user's "when" against it and echo the resolved local time back ("fires: 2026-05-21 04:00 KST") to catch a misparse. Build a one-shot local-tz 5-field cron `M H DoM Mon DoW`, `recurring: false`, off-minute (:07/:13/:22) unless an exact time was given.

3. **Precheck push.** `git remote -v`, `gh auth status`. If the remote is unset or auth is broken, surface it before dispatching. If `main` is protected / PR-required so a direct push is blocked, surface that too — default delivery is ff-merge + `push origin main`; switch to PR-based only if the user confirms.

4. **Assemble + confirm.** Fill the template below: `{{round1}}` verbatim; `{{candidates}}` = the user's list or, if none, the backlog fallback noted under the template; include `{{extra}}` only if the user gave extra constraints. Show the full assembled prompt (scheduled: also the firing time + cron) and get an explicit "go" — this commits and pushes, so never auto-fire.

5. **Dispatch.**
   - **Scheduled** → `CronCreate({ cron, recurring: false, durable: false, prompt })`. Echo the job id (for `CronDelete`), the local firing time, and the "session must stay alive & idle" caveat.
   - **Immediate** → do NOT call `CronCreate`. Treat the assembled prompt as the active directive and start Round 1 now by invoking `/hyperclaude:hyper-auto`. Keep the assembled rules in scope verbatim — do not paraphrase them away.

## Loop prompt template (substitute in step 4)

```
[Auto trigger — start autonomous workflow]

## Round 1 task
{{round1}}

## Per-round 3 steps
1. **/hyperclaude:hyper-auto** — chain `hyper-plan-loop` → `hyper-implement-loop` for this round's task. It stops between phases on plan-loop cap-reached or terminal revise-regression; treat that as a round failure (see Stop conditions).
2. **Fast-forward merge to main** — if on a work branch, checkout main then `git merge --ff-only`.
3. **git push origin main** — no force push, no `--no-verify`; on hook failure, fix the root cause and create a new commit.

After step 3 → autonomously pick the next task and start the next round.

## Next-task candidates (priority order)
{{candidates}}

## Stop conditions
- Context limit near → finish the current round and stop.
- Any step needs a destructive git op (force push / hard reset / branch -D) → stop and report.
- Push fails (remote rejection, auth) → stop and report.
- `hyper-auto` ends non-clean for either inner loop (plan-loop cap-reached / terminal revise-regression, or implement-loop with open Blocker/Major) → stop. Don't start the next round; don't retry the same task.

## Rules
- Respect the project's CLAUDE.md / AGENTS.md invariants, comment policy, and code style.
- Honor the project's existing quality gates (tests, lint/typecheck, coverage thresholds from its CLAUDE.md / CI). Never lower or skip a gate to make a round pass.
- End each round: append a one-line summary to `.hyperclaude/autonomous-log.md` (create if missing).
- Start each round: read the most recent `.hyperclaude/` artifacts (plans/, code-reviews/, plan-reviews/) for context.
- Skip visual verification (Playwright/manual) in autonomous mode — if the plan calls for it, note as unverified risk and proceed.
```

**Substitution notes.** `{{candidates}}` fallback when the user gives none: *"After Round 1 pick the next task autonomously from the project's own backlog — README roadmap / TODO, open items in CLAUDE.md/AGENTS.md — and the most recent `.hyperclaude/plans/` artifacts. If nothing is obviously next, end and report."* If `{{extra}}` is empty, drop that section entirely (no trailing blank header).
