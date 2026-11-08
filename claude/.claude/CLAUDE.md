@~/.codex/AGENTS.md

## 6. Delegate What Pays

**Hand off what a sub-agent does better than you - not everything, not nothing.**

Hand off:
- Work whose intermediate output is large and whose result is small - screenshots,
  long logs, full test runs, reading many files to answer one question.
- Review: before reporting a code change done, spawn a fresh general-purpose
  agent to critique the diff. Skip only for a typo, a comment, or a single
  config value. hyper-* loops already review - don't add a second pass there.
- UI design: when the change makes visual decisions - a new screen or section,
  or reshaping an existing one's layout, hierarchy, or color - generate 1-2
  mockups with codex-image first, then build with frontend-design using them as
  reference, not spec. Skip when the look is already decided and you're only
  adjusting within it (spacing, a label, reusing an existing component).

A reviewer needs no special agent type - general-purpose is enough. Give it a
fresh agent so it doesn't inherit your reasoning; fork when the work needs what you
already know, so there's nothing to brief. Keep it yourself only when the steps
depend tightly on each other.
