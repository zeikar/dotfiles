---
name: korean-polish
description: >-
  This skill should be used when Korean text the user will post or send
  under their own name needs checking or polishing so it reads as written
  by a person: a reply to a comment, a post, a description, a message, a
  doc. Triggers include "교정해줘", "다듬어줘", "윤문", "자연스럽게", "AI가 쓴
  것 같아?", "이 답글 어때?", "이렇게 올릴까?", and the user pasting a Korean
  draft to post. Not for Claude's own chat replies to the user.
---

# Korean polish

Check and polish Korean text the user will put out under their own name.
The rules are in `rules.md` next to this file; read it first. If the
project has its own Korean wording rules (its AGENTS.md or CLAUDE.md names
them, e.g. `docs/korean.md`), read those too; where they differ, the
project wins.

1. **Whose draft, what kind.** Note who wrote it (the user, or Claude
   earlier in the conversation) and what it is (a reply, a post, a
   description, a message, a doc). For a reply, read what it answers.
2. **Facts.** Check each factual statement against the project's sources
   if it has them. For one they don't cover, check what you can (compute
   it from the sources' numbers) and say how you checked it (computed,
   from memory); the user decides whether it stays.
3. **Edit lightly.** Change only what a rule, a fact, or a likely misreading
   calls for, and keep the writer's voice: polish their draft, don't
   rewrite it in yours. Content you'd add (a fact, an example, a familiar
   name) is a suggestion in the report, not an edit. If nothing needs
   changing, say so.
4. **Fresh eyes on Claude's drafts.** Whoever wrote a text judges badly
   whether it reads as generated. When Claude wrote the draft, spawn a
   general-purpose agent with only the text, what it answers, and the rule
   files (no conversation), and ask which lines read as machine-written and
   why. Keep what holds up against the rules. When the user wrote the
   draft, you are the fresh eyes.
5. **Report, in Korean.** The text in a quote block, ready to paste; then
   each change with its reason, one line each; then suggestions; then each
   fact the sources don't cover, with how it was checked. Nothing else.
6. **Grow the rules.** Learn the user's voice only from text they wrote
   themselves, never from Claude's drafts. When the user rewrites wording
   or states a preference, add it, dated, with the before and after, and tell them
   where it went: a rule about one project (its register, its sources)
   goes in that project's rules; anything else goes in `rules.md` (check
   `survey.md` first, which may already have its evidence). This
   skill lives in the dotfiles repo
   (`~/Developer/Projects/dotfiles/claude/.claude/skills/korean-polish/`);
   edit it there.
