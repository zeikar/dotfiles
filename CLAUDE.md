# CLAUDE.md

Dotfiles repo, GNU Stow managed. Human docs: see README.md.

## Editing notes for agents

- `~/.claude/CLAUDE.md` is a **symlink** into this repo. Edit the real
  target `claude/.claude/CLAUDE.md`, never the `$HOME` path (write fails).
- `codex/.codex/AGENTS.md` symlinks to the **same** `claude/.claude/CLAUDE.md`.
  One edit changes both Claude and Codex — intended; don't "fix" it.
- Stow-managed: edit files inside the repo, not the linked copies in `$HOME`.
- Skills live in `claude/.claude/skills/<name>/`. Because `~/.claude/skills/`
  already exists as a real dir (Claude Code and skill installers create it),
  Stow folds each skill *subdir* into its own symlink — coexists fine. Caveat:
  on a fresh machine where `~/.claude/skills/` does not yet exist, run Claude
  Code once before `install.sh` so Stow links per-skill, not the whole dir.
- Agents live in `claude/.claude/agents/<name>.md`. Unlike skills,
  `~/.claude/agents` did not pre-exist, so Stow linked the *whole dir* as one
  symlink — intended. Consequence: anything Claude Code writes into
  `~/.claude/agents/` lands inside this repo as an untracked file; review it,
  then commit or delete.
- `claude/.claude/settings.json` carries orca IDE agent-hooks (guarded `-f/-r/-x`,
  so they no-op without orca). orca rewrites them on every launch, writing
  *through* the stow symlink, so the tracked file picks up a large diff — commit
  it. The hook command is orca's generated output, not hand-written, so trimming
  it back only reproduces the same diff next launch. orca also drops a
  `settings.json.bak` beside the config; `*.bak` is gitignored. Older orca
  releases replaced the `~/.claude/settings.json` symlink with a real file
  instead; if that returns, `rm ~/.claude/settings.json` then
  `stow --restow --target="$HOME" claude`.
- orca writes agent-hook configs for every CLI it supports, installed or not
  (`~/.grok`, `~/.hermes`, `~/.openclaude`, …). They belong to orca, not here —
  don't track them.
- Don't track machine-local/secret files (`~/.zshrc.local`, auth tokens).
