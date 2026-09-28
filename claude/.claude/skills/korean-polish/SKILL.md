---
name: korean-polish
description: >-
  This skill should be used when writing, checking, or polishing Korean
  that goes out under the user's name, so it reads as written by a person:
  a comment, a reply, a blog post, a description, a message, a doc.
  Triggers include "답글 써줘", "댓글 달아줘", "블로그 글 써줘", "교정해줘",
  "다듬어줘", "윤문", "자연스럽게", "AI가 쓴 것 같아?", "이 답글 어때?",
  "이렇게 올릴까?", and the user pasting a Korean draft to post. Not for
  Claude's own chat replies to the user.
---

# Korean polish

Write, check, and polish Korean the user will put out under their own
name. The rules are in `rules.md` next to this file; read it first. If the
project has its own Korean wording rules (its AGENTS.md or CLAUDE.md names
them, e.g. `docs/korean.md`), read those too; where they differ, the
project wins.

1. **What kind.** Note what the text is (a comment, a reply, a blog post,
   a description, a message, a doc). For a reply, read what it answers.
2. **Facts.** Check each factual statement against the project's sources
   if it has them. For one they don't cover, check what you can (compute
   it from the sources' numbers) and say how you checked it (computed,
   from memory); the user decides whether it stays.
3. **Write, or edit lightly.** Writing the text, or revising text Claude
   wrote in this conversation, apply the rules freely. Given a pasted
   draft (anything the user supplies, whoever wrote it; it stays a pasted
   draft after you polish it), change only what a rule, a fact, or a
   likely misreading calls for, and keep its voice: polish it, don't
   rewrite it in yours. Content you'd add to a pasted draft (a fact, an
   example, a familiar name) is a suggestion in the report, not an edit.
   If nothing needs changing, say so.
4. **Fresh eyes on Claude's text.** Whoever wrote a text judges badly
   whether it reads as generated. When Claude wrote the text in this
   conversation, spawn a general-purpose agent with only the text, what it
   answers, `rules.md`, and the project's rules (no conversation, no
   `survey.md`), and ask which lines read as machine-written and why. Keep
   what holds up against the rules. For a pasted draft, you are the fresh
   eyes.
5. **Report, in Korean.** The text in a quote block, ready to paste (if it
   went into a file, name the file instead); then each change with its
   reason, one line each (for text Claude wrote, what the fresh-eyes pass
   changed); then suggestions; then each fact the sources don't cover,
   with how it was checked. Nothing else.
6. **Grow the rules.** Learn only from the user's explicit corrections:
   they rewrite or reject Claude's wording, or state a preference. Never
   learn from a pasted draft; it may come from another AI. Record each
   correction with its before and after, marked "(the user …)" like the
   existing ones, no date. If a rule already covers it, add the example to
   that rule instead of writing a new one. Tell the user where it went: a rule about one project (its register, its
   sources) goes in that project's rules; anything else goes in `rules.md`
   (check `survey.md` first, which may already have its evidence). This
   skill lives in the dotfiles repo
   (`~/Developer/Projects/dotfiles/claude/.claude/skills/korean-polish/`);
   edit it there.
