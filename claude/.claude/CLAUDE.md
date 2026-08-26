# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

Before implementing:
- Read project instruction files (CLAUDE.md / AGENTS.md / linked docs) before touching code. Don't reinvent existing conventions.
- State assumptions explicitly. Ask before anything risky (behavior, security, data loss, public API); for low-risk calls, note the assumption and proceed.
- If multiple meaningful interpretations exist, present them; for low-risk choices, state the chosen interpretation and proceed.
- If a simpler approach exists, say so. Push back when warranted.
- If something important is unclear, stop. Name what's confusing. Ask.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked.
- No abstractions for single-use code.
- No "flexibility" or "configurability" that wasn't requested.
- No speculative error handling; do handle realistic I/O, network, input, and parsing failures.
- Don't silently swallow errors (empty catch / `except: pass`).
- Comment *why*, not *what*. No narrating self-evident code.
- One responsibility per file/function. Split when a unit does two unrelated things.
- If you write 200 lines and it could be 50, rewrite it.

Ask yourself: "Would a senior engineer say this is overcomplicated?" If yes, simplify.

## 3. Surgical Changes

**Touch only what you must. Clean up only your own mess.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused.
- Don't remove pre-existing dead code unless asked.

Surgical means minimal scope, not append-only. If your change duplicates what an
existing path already does, change that path or extract the shared piece - don't
ship a second one beside it, because the next fix lands on one and not the other.
When you can't do that inside the task's scope, say so rather than forking the
behavior. For prose - docs and comments - see §6.

The test: Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

For multi-step tasks, state a brief plan:
```
1. [Step] → verify: [check]
2. [Step] → verify: [check]
3. [Step] → verify: [check]
```

Strong success criteria let you loop independently. Weak criteria ("make it work") require constant clarification.

## 5. Efficient Search

**Never scan broad filesystem roots. Narrow scope first.**

- No `find` / `grep` over `$HOME`, `/`, or other huge unscoped roots.
  Bad: `find /Users/zeikar -path '*sdk/testsuite*' -name '*.go'`
- Locate the relevant subtree first (list one level, follow the path), then search inside it.
- Prefer the harness's own search tools (Grep/Glob), or `rg` if present, over
  recursive `find` - pinned to the project or module dir. (`fd` is not installed
  on this machine, and `rg` may exist only inside Claude Code.)
- If a wide search is truly unavoidable, bound it (`-maxdepth`, a known root) and say why.

## 6. Edit In Place, Don't Accrete

**When new information changes what a text says, revise that text. Don't append beside it.**

Scope: prose - docs, code comments, and instruction files like this one. For the
same reflex in code, see §3; revising code carries risks prose does not.

Adding feels safe and touching existing lines feels risky - repeated over many
sessions, that bias produces docs that say the same thing twice, contradict
themselves a paragraph apart, and file new facts under the nearest heading.

Before adding text next to existing text:
- Does your addition contradict, narrow, or date what's above? Fix that claim
  instead of qualifying it from below.
- Does it belong here, or is this just where you were reading? If it fits no
  existing section, give it its own.
- Does it supersede anything? Delete that - dead qualifiers, stale
  "now"/"currently" framing, sentences the revision already covers. Correct a
  wrong comment; never add a second one explaining why the first is outdated.

Diffs hide this: two copies of a rule twenty lines apart each look fine in their
own hunk. Re-read the whole section you touched, not just your diff.

This does not override §3 - it fires only where your change and the existing text
overlap. Hard-won text (a documented failure mode, a warning added after a real
bug) gets its placement fixed, not its content, unless you can show it is wrong.

The test: if a reader has to read both the old text and yours to get one answer,
you appended where you should have edited.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, documents that stop growing a second copy of the same rule, and clarifying questions come before implementation rather than after mistakes.
