## 1. Think Before Coding

**Don't hide confusion. Surface tradeoffs.**

- Read the docs a project instruction file links to before touching code -
  only `@` imports load automatically. Don't reinvent existing conventions.
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
- Where your change overlaps something that already exists - a code path doing
  the same job, a doc sentence it makes stale - update that thing rather than
  adding a second copy beside it.

## 3. Goal-Driven Execution

**Define success criteria. Loop until verified.**

For a bug, reproduce it first - with a failing test where one fits - and watch the
fix make it pass. Otherwise run whatever proves the change works before calling it
done. Done includes docs: if the change touched anything documented - API, CLI
flags, config, setup steps, architecture - grep README and docs/ for it and fix
what went stale.

## 4. Efficient Search

**Never scan broad filesystem roots. Narrow scope first.**

- No `find` / `grep` over `$HOME`, `/`, or other huge unscoped roots.
  Bad: `find /Users/zeikar -path '*sdk/testsuite*' -name '*.go'`
- Locate the relevant subtree first (list one level, follow the path), then search inside it.
- If a wide search is truly unavoidable, bound it (`-maxdepth`, a known root) and say why.

## 5. This Machine

macOS with a BSD userland, so GNU-only tools are missing - no `fd`, no
`sed -i` without a suffix argument. `timeout` exists (BSD, /usr/bin).
