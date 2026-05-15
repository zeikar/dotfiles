# CLAUDE.md

Dotfiles repo, GNU Stow managed. Human docs: see README.md.

## Editing notes for agents

- `~/.claude/CLAUDE.md` is a **symlink** into this repo. Edit the real
  target `claude/.claude/CLAUDE.md`, never the `$HOME` path (write fails).
- `codex/.codex/AGENTS.md` symlinks to the **same** `claude/.claude/CLAUDE.md`.
  One edit changes both Claude and Codex — intended; don't "fix" it.
- Stow-managed: edit files inside the repo, not the linked copies in `$HOME`.
- Don't track machine-local/secret files (`~/.zshrc.local`, auth tokens).
