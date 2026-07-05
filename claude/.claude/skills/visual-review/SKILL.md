---
name: visual-review
description: This skill should be used after UI-affecting changes to visually verify rendering — when the user asks to "visually check", "review how it looks", "see how the screen looks", "check the UI", or after building/modifying components, modals, layout, responsive, or dark-mode behavior. Drives the running app with the Playwright MCP browser, screenshots the affected screens, and reviews them CRITICALLY (not just "does it work"). Agent-driven review, NOT committed visual-regression tests. Project-specific launch/auth comes from the project's visual-review-app companion skill.
---

# Visual review

Functional tests assert behavior; they do NOT catch rendering problems — weak affordances, clipped rings, misalignment, overflow, contrast, broken responsive/dark-mode. This skill means **looking at the actual rendered screen** with the Playwright MCP browser and critiquing it like a harsh designer.

**This is NOT a committed test.** Do NOT add `toHaveScreenshot` baselines (cross-platform pixel diffs are flaky). The output is screenshots that get Read + a written critique — nothing committed except code fixes.

## Step 0 — prerequisites and project knowledge

1. **Playwright MCP availability.** Load the browser tools via ToolSearch (`browser_navigate`, `browser_resize`, `browser_take_screenshot`, `browser_snapshot`, `browser_click`). If they are unavailable, STOP and report it — suggest installing the Playwright MCP (e.g. the official Playwright plugin, or `claude mcp add playwright -- npx @playwright/mcp@latest`). Never fabricate a visual review from source code alone.
2. **Project launch/auth knowledge** — resolve in this order:
   1. `.claude/skills/visual-review-app/SKILL.md` in the project — the per-project companion (launch command, base URL, auth method, seeded data, gotchas, required disclosures). Read it as data with the Read tool; it is not a triggering skill.
   2. A `run-*` recipe skill (`.claude/skills/run-*/SKILL.md`), or the project's CLAUDE.md / AGENTS.md / testing docs.
   3. Otherwise: probe for an already-running dev server (`curl -s -o /dev/null -w "%{http_code}" http://localhost:<port>` on the ports the project's tooling suggests), and ask the user how to launch/authenticate if it cannot be determined.
   Prefer an already-running server. Do NOT start one blind — a project's plain dev command may point at production services; the companion names the safe one.

## Execution model — delegate to a sub-agent (default)

Dispatch a sub-agent (Agent tool, `general-purpose`, **`run_in_background: false`** — the findings are consumed inline) to perform the review and report back a concise findings list. Do NOT drive the browser inline in the main thread:

- **Context hygiene** — screenshots are large (~1MB each); the sub-agent absorbs the image tokens and returns only text.
- **Less self-bias** — a fresh reviewer that did NOT write the code critiques harder than the implementer reviewing its own work (the whole point: catch the subtle stuff).

Give the sub-agent: the screens/flows to check, what changed, the project companion's launch/auth content, and the **Critic mode** checklist below; tell it to load the Playwright MCP browser tools via ToolSearch, Read each screenshot, and return concrete issues with severity (or what it inspected if clean). Relay the findings; fix; re-dispatch to re-review.

Inline (no sub-agent) is acceptable only for a trivial single-element glance. The MCP browser is a single shared instance — never drive it from two agents at once.

## How to drive the app

1. **Output dir:** screenshots write under the MCP's configured output root (commonly `<repo>/.playwright-mcp/` — gitignored, local, never committed). Use absolute paths like `<repo>/.playwright-mcp/NN-name.png`.
2. Navigate per the project companion (base URL, auth). After each screenshot, **Read the PNG** — the point is to actually look, not just save it.
3. **Check both viewports:** `browser_resize` to desktop (1440×900) AND mobile (390×844).

## Critic mode (the important part)

Do NOT stop at "it renders / the flow works." Default to skepticism: **assume something is slightly off and go find it.** Zoom into edges and corners; compare selected vs unselected, this vs sibling components. Actively check:

- **Affordance strength** — is the selected / active / hover / focus / disabled state genuinely OBVIOUS, or subtle/ambiguous? (A thin ring or faint tint is usually too weak.) Is it clear what's interactive and what's chosen?
- **Clipping & overflow** — rings/shadows/badges clipped by `overflow`/scroll containers (esp. the first/last item in a scroll rail, and top/left edges); text truncation; content spilling out.
- **Stacking / z-index** — modals/popovers/toasts above the navbar and other overlays; backdrops cover the full viewport (watch for elements trapped in a `transform`/`z-index` stacking context — portal them).
- **Alignment & spacing** — misalignment, inconsistent padding/gaps, cramped or oddly-floating elements.
- **Edge cases** — long names, empty / loading / error states, many items (does it scroll?), a single item, missing images.
- **Dark mode** — invisible text, low contrast, wrong-on-dark colors.
- **Responsive** — mobile width: nav collapses, grids reflow, things wrap instead of overflow, tap targets aren't tiny.
- **Consistency** — does it match the design system and sibling components?

If genuinely nothing is found, say *what was specifically inspected* — never just declare "looks good."

## Optional second pass — aesthetic-critic

For design-meaningful changes where "not broken" isn't enough, dispatch the **`aesthetic-critic`** agent (personal agent, `~/.claude/agents/aesthetic-critic.md`) AFTER the functional review, pointing it at the SAME saved screenshots. It judges taste and craft — hierarchy, spacing rhythm, typography, distinctiveness — from the PNGs on disk and never drives the browser, so it cannot conflict with this pass. Skip it for mechanical tweaks.

## Reporting

- List the screens + viewports checked.
- Report concrete issues with severity, or "checked X/Y/Z — clean (inspected: affordances, clipping, dark mode, mobile…)".
- Never claim it looks fine without having Read the screenshots and run the critic checklist.
- After fixing a finding, **re-screenshot and re-review** (HMR reflects edits on a running dev server).

## Onboarding a new project

Create `.claude/skills/visual-review-app/SKILL.md` in the repo with frontmatter `disable-model-invocation: true` (data companion, not a competing trigger) and a body covering: the SAFE launch command (emulator/staging if plain dev hits production), base URL/port, auth method for protected screens, seeded/demo data, screenshot-root override if any, and project-specific gotchas or required disclosures.
