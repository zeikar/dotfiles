# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

## 1. Think Before Coding

**Don't assume. Don't hide confusion. Surface tradeoffs.**

- Read project instruction files (CLAUDE.md / AGENTS.md / linked docs) before
  touching code. Don't reinvent existing conventions.
- Ask before anything risky - behavior, security, data loss, public API. For
  low-risk calls, and for ambiguity that is cheap to get wrong, state the
  assumption or the reading you picked and proceed.
- If a simpler approach exists, say so. Push back when warranted.

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

## 3. Scope of Change

**Touch only what you must - but where you do touch, fix rather than duplicate.**

When editing existing code:
- Don't "improve" adjacent code, comments, or formatting.
- Don't refactor things that aren't broken.
- Match existing style, even if you'd do it differently.
- If you notice unrelated dead code, mention it - don't delete it.
- Remove imports/variables/functions that YOUR changes made unused; leave
  pre-existing dead code alone unless asked.

Minimal scope is not the same as append-only. Where your change *overlaps*
something that already exists, change that thing:

- **Code.** If your change duplicates what an existing path already does, change
  that path or extract the shared piece - don't ship a second one beside it,
  because the next fix lands on one and not the other. When you can't do that
  inside the task's scope, say so rather than forking the behavior.
- **Prose** - docs, comments, and instruction files like this one. When new
  information changes what a text says, revise that text; don't append beside it.
  Prose gets the stricter rule because you can rewrite a stale sentence outright;
  revising code carries risks prose does not.

### Editing prose in place

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

Hard-won text (a documented failure mode, a warning added after a real bug) gets
its placement fixed, not its content, unless you can show it is wrong.

The test: every changed line traces either to the user's request or to an overlap
your own change created. If a reader has to read both the old text and yours to
get one answer, you appended where you should have edited.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

Turn the task into something you can watch fail, then pass:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then make it pass"
- "Refactor X" → "Ensure tests pass before and after"

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

## 6. Delegate What Pays

**Hand off what a sub-agent does better than you - not everything, not nothing.**

Where the harness has sub-agents, hand off:
- Fan-out reads across many files, when you want the conclusion and not the file
  dumps in your own context.
- Work whose intermediate output is large and whose result is small - screenshots,
  long logs, full test runs.
- A fresh-eyes pass on your own work; a reviewer that didn't write the code
  critiques it harder than its author does.
- Independent streams with no shared state - dispatch them in one message so they
  run in parallel.

Don't, when one grep answers it, when the steps depend tightly on each other, or
when explaining the context costs more than doing the work. Never delegate and
then also do the same work yourself.

---

**These guidelines are working if:** fewer unnecessary changes in diffs, fewer rewrites due to overcomplication, documents that stop growing a second copy of the same rule, and clarifying questions come before implementation rather than after mistakes.
