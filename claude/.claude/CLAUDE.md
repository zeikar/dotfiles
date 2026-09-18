# CLAUDE.md

Behavioral guidelines to reduce common LLM coding mistakes. Merge with project-specific instructions as needed.

## 1. Think Before Coding

**Don't hide confusion. Surface tradeoffs.**

- Read AGENTS.md and the docs that project instruction files link to before
  touching code. Don't reinvent existing conventions.
- Ask before changing behavior, security, or a public API in ways the request
  didn't spell out.
- If a simpler approach exists, say so. Push back when warranted.

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features or configurability beyond what was asked, and no abstractions for
  single-use code.
- No speculative error handling; do handle realistic I/O, network, input, and parsing failures.
- Don't silently swallow errors (empty catch / `except: pass`).
- Comment *why*, not *what*. No narrating self-evident code.

## 3. Scope of Change

**Touch only what you must - but where you do touch, fix rather than duplicate.**

Don't "improve" or refactor adjacent code that isn't broken. Where your change
overlaps something that already exists - a code path doing the same job, a doc
sentence it makes stale - update that thing rather than adding a second copy
beside it.

## 4. Goal-Driven Execution

**Define success criteria. Loop until verified.**

For a bug, reproduce it first - with a failing test where one fits - and watch the
fix make it pass. Otherwise run whatever proves the change works before calling it
done.

## 5. Efficient Search

**Never scan broad filesystem roots. Narrow scope first.**

- No `find` / `grep` over `$HOME`, `/`, or other huge unscoped roots.
  Bad: `find /Users/zeikar -path '*sdk/testsuite*' -name '*.go'`
- Locate the relevant subtree first (list one level, follow the path), then search inside it.
- `fd` is not installed on this machine.
- If a wide search is truly unavoidable, bound it (`-maxdepth`, a known root) and say why.

## 6. Delegate What Pays

**Hand off what a sub-agent does better than you - not everything, not nothing.**

Hand off:
- Work whose intermediate output is large and whose result is small - screenshots,
  long logs, full test runs.
- A fresh-eyes pass on your own work; a reviewer that didn't write the code
  critiques it harder than its author does.

No specialized agent type needed - general-purpose works. Give a reviewer a fresh
agent so it doesn't inherit your reasoning; fork when the work needs what you
already know, so there's nothing to brief. Keep it yourself only when the steps
depend tightly on each other.
