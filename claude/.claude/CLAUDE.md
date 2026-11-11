@~/.codex/AGENTS.md

## 6. Delegate What Pays

**Hand off what a sub-agent does better than you - not everything, not nothing.**

Hand off:
- Work whose intermediate output is large and whose result is small - screenshots,
  long logs, full test runs, reading many files to answer one question.
- Review: before reporting a code change done, spawn a fresh general-purpose
  agent to critique the diff, including any README/docs the diff makes stale.
  Skip only for a typo, a comment, or a single config value. When fixes from
  the review change behavior (not just wording), have the same reviewer
  (SendMessage), not a new one, re-check them for new problems - it already
  knows its findings. Stop when it returns clean or nits only; after 2
  re-checks, stop fixing and report what's still open to the user. hyper-*
  loops already review - don't add a second pass there. If you are a
  sub-agent, don't spawn a reviewer either - the review runs once, in the
  main session.
- UI design: when the change makes visual decisions - a new screen or section,
  or reshaping an existing one's layout, hierarchy, or color - generate 1-2
  mockups with codex-image first, then build with frontend-design using them as
  reference, not spec; when you recommend departing from the mockup, say so and
  why. Skip when the look is already decided and you're only
  adjusting within it (spacing, a label, reusing an existing component).

A reviewer needs no special agent type - general-purpose is enough. Give it a
fresh agent so it doesn't inherit your reasoning; fork when the work needs what you
already know, so there's nothing to brief. Keep it yourself only when the steps
depend tightly on each other.

Most sub-agents run on your model unless you set `model`. On the built-in types
(general-purpose, claude, Explore, Plan) set it: haiku when the agent only
fetches raw material (a command's output, a definition, lines from a log),
sonnet when it has to sift or conclude (many files, a long log or a test run
down to one answer), opus when it judges (review, critique, planning). Leave
it unset when the work needs your own reasoning level or the pick would be
above your own model. Custom and plugin agents keep the model their definition
sets - don't override it.
