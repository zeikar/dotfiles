# My macOS Dotfiles

Minimal macOS dotfiles managed with GNU Stow.

## What is tracked

- `claude/` for Claude Code global configuration (`CLAUDE.md`, `settings.json`, `statusline.sh`, `skills/`, `agents/`)
- `codex/` for Codex CLI configuration (`AGENTS.md` → symlink to `CLAUDE.md`)
- `zsh/` for shell configuration
- `Brewfile` for package reproducibility
- `macos-defaults.sh` for common macOS preferences

Machine-specific secrets stay outside the repo:

- `~/.zshrc.local`

## Prerequisites

Required:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install stow
```

Optional but recommended:

```bash
brew bundle --file Brewfile

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

The shell config is defensive now, so missing optional tools will not break shell startup.

## Install

```bash
./install.sh
source ~/.zshrc
```

What `install.sh` does:

- stows tracked packages into `$HOME`
- detects recursive conflicts before linking
- backs up replaced files to `~/.dotfiles-backups/<timestamp>/`
- creates `~/.zshrc.local` when missing

## Restore packages

Install packages from the tracked Homebrew bundle:

```bash
brew bundle --file Brewfile
```

## Apply macOS preferences

Review the script first, then run it manually if you want those defaults:

```bash
chmod +x macos-defaults.sh
./macos-defaults.sh
```

## Local-only files

Example `~/.zshrc.local`:

```bash
export GITHUB_TOKEN="your_token_here"
export OPENAI_API_KEY="your_key_here"
```

## Claude Code + orca IDE

`claude/.claude/settings.json` carries agent-hooks for the [orca IDE](https://www.onorca.dev/),
which is installed separately (not by this repo). Each hook is guarded with `-f/-r/-x`, so it
no-ops on machines where orca is absent.

Installing or launching orca can replace the `~/.claude/settings.json` stow symlink with a real
file (re-injecting its hooks). To restore the symlink:

```bash
rm ~/.claude/settings.json                 # if orca left a real file here
git checkout claude/.claude/settings.json  # if it dirtied the tracked file
stow --restow --target="$HOME" claude      # relink into $HOME
```

## Claude Code status line

`claude/.claude/statusline.sh` is a custom [status line](https://code.claude.com/docs/en/statusline)
registered under `statusLine` in `settings.json`. It reads the JSON session data Claude Code
pipes on stdin and prints two rows:

- **Line 1** — model · reasoning effort, directory, git branch with staged/modified/untracked
  counts, worktree, open PR + review state, session cost and elapsed time
- **Line 2** — three equal-width gauges: context window, 5-hour and 7-day rate limits. Each has
  its own hue (context, 5h, 7d) and turns red past its critical threshold; the 5h gauge shows a
  reset countdown, the 7d gauge its reset date

Rate-limit gauges appear only for Pro/Max accounts after the first API response; git and cost
segments degrade gracefully outside a repo or early in a session. `refreshInterval` keeps the
gauges live while background subagents run.

## Structure

```text
dotfiles/
├── Brewfile
├── CLAUDE.md          # editing notes for coding agents working on this repo
├── LICENSE
├── claude/
│   └── .claude/
│       ├── CLAUDE.md
│       ├── settings.json
│       ├── statusline.sh        # custom 2-line status line (context + rate-limit gauges)
│       ├── agents/
│       │   └── aesthetic-critic.md   # taste/craft critique of already-captured UI screenshots
│       └── skills/
│           ├── hyper-autopilot/      # fire-and-forget autonomous-loop runner over hyperclaude's hyper-auto (scheduled/immediate; local, non-GitHub)
│           ├── codex-image/          # codex image_generation skill (single/batch/parallel)
│           └── visual-review/        # Playwright MCP rendering critique (reads per-repo visual-review-app companion)
├── codex/
│   └── .codex/
│       └── AGENTS.md -> ../../claude/.claude/CLAUDE.md
├── install.sh
├── macos-defaults.sh
├── zsh/
│   ├── .zshrc
│   └── .zshrc.local.example
└── README.md
```
