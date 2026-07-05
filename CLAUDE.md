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
- Don't track machine-local/secret files (`~/.zshrc.local`, auth tokens).
