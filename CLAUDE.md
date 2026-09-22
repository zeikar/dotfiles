# CLAUDE.md

Dotfiles repo, GNU Stow managed. Human docs: see README.md.

## Editing notes for agents

- `~/.claude/CLAUDE.md` is a **symlink** into this repo. Edit the real
  target `claude/.claude/CLAUDE.md`, never the `$HOME` path (write fails).
- `codex/.codex/AGENTS.md` is a **separate file**: `claude/.claude/CLAUDE.md`
  minus §6 "Delegate What Pays" (later sections renumbered). When editing any
  other section, mirror the change by hand in both. §6 stays out because Codex
  reads it as the explicit request its defaults require before spawning sub-agents.
- Stow-managed: edit files inside the repo, not the linked copies in `$HOME`.
- Skills live in `claude/.claude/skills/<name>/`, agents in
  `claude/.claude/agents/<name>.md`. Stow linked both as *whole-dir* symlinks
  (`~/.claude/skills` and `~/.claude/agents` point at this repo) — intended.
  Consequence: anything Claude Code or a skill installer writes into those dirs
  lands inside this repo as an untracked file; review it, then commit or delete.
  (Shape depends on the target: Stow folds per-subdir instead when the `$HOME`
  dir already exists as a real dir.)
- `claude/.claude/settings.json` carries orca IDE agent-hooks. orca rewrites them
  through the stow symlink on every launch, so a large unrequested diff there is
  expected — commit it rather than trimming it back.
- Claude Code itself also writes into this repo (`/model`, `claude plugin` run
  from `~`, claude.ai skill sync). Read `docs/claude-code.md` before running
  `claude plugin` from `~` or committing a diff Claude Code made.
- Don't track machine-local/secret files (`~/.zshrc.local`, auth tokens).
