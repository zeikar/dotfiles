# What Claude Code writes into this repo

`~/.claude/settings.json` and `~/.claude/skills` are stow links into this repo, so
some Claude Code actions show up here as diffs. What to do with each:

## `"model"` in settings.json

`/model` writes the chosen model into `claude/.claude/settings.json`. The model is
deliberately unpinned (6e7ba48): drop that key rather than commit it, even when the
same diff also carries orca's hook rewrite, which you do commit.

## Plugin commands run from `~`

For a session in `~`, the *project* settings file is `~/.claude/settings.json`, the
same repo file as user settings. So `claude plugin install/uninstall -s project` run
from `~` edits its `enabledPlugins`: uninstalling a project-scope copy drops the line
and disables the user-scope copy with it. Install and uninstall at user scope; if a
project-scope command already ran, restore `enabledPlugins` from git.

## claude.ai skill sync: `skills/synced/`, `skills/.trash/`

Since Claude Code 2.1.277, a terminal session signed in with a claude.ai account
downloads that account's skills into `~/.claude/skills/synced/<org>_<account>/`,
re-syncs about every 10 minutes, and moves removed skills to `~/.claude/skills/.trash/`.
Both are gitignored: an account-specific cache, and `docx`/`pdf`/`pptx`/`xlsx` in it are
proprietary-licensed.

- `docx`, `pdf`, `pptx` and `xlsx` always sync; the rest follow the skill toggles in
  claude.ai settings.
- Don't delete files in `synced/` by hand; the next sync brings them back.
- To opt out, set `"syncClaudeAiSkills": false`: in `settings.json` it applies to every
  machine using these dotfiles; in a workspace's `.claude/settings.local.json`, only there.
