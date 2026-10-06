# Korean wording rules

For Korean the user puts out under their own name. A project can add its
own rules on top (the `korean-polish` skill says where to find them). To
add a rule, follow that skill's step 6.

Most rules come from a survey of Korean humanizer and 윤문 rule sets
(humanizer-ko, im-not-ai, koreanizer, the reply voice in ChaeHyunIM/skills
`SOUL.md`, and the XDAC study of AI-written Korean comments), kept where
they fit and put in our words; the rest come from the user's corrections.
`survey.md` has the sources, the full catalog, and what wasn't adopted and
why.

## All text

- **No 번역투:** not ~를 통해, ~에 의해, ~에 있어, 가지고 있다, ~되어지다;
  not "거의 정확히 X와 같다" (say "X와 거의 같다"); not ~할 때 meaning
  "each time" or "while" (say ~마다, ~동안).
- **Say what 그 points to.** "그 힘", "이것", "그 효과" name their thing
  when two could be meant: after the Sun's tides and gravity, "그 힘이
  달의 절반" reads as the Sun's pull, so say "밀물, 썰물을 만드는 힘은".
- **Plain verbs:** "검토를 진행했어요" → "검토했어요", "이 달의 경우" →
  "이 달은". No surplus 들 ("과학자들이 연구들을" → "과학자들이 연구를").
- **Polite throughout:** no 반말 or -다 (해라체) slipping into polite text.
  Prose (docs, descriptions, scripts) keeps one register; replies may mix
  in 합니다 (Replies).
- **Three or more short sentences with the same ending:** join them with
  connective endings ("파일을 읽어요. 형식을 확인해요. 저장해요." →
  "파일을 읽고 형식을 확인한 다음 저장해요").
  Don't swap in -죠, -네요, -거든요 for variety: each carries a meaning
  (-네요 noticing something, -거든요 a reason the reader didn't know).
- **Keep precision:** a hedge the facts need stays ("약", "~할 수 있어요"),
  and so do technical terms. Never turn a hedge into a flat claim to sound
  sure.
- **No stock phrases:** 결론적으로, 종합하면, 주목할 만해요, 단순한 X를
  넘어; a question answered with "이유는 간단해요"; a moral tacked on at
  the end.
- **The user's length, when Claude writes.** Claude's drafts run about
  twice the user's own (their leetcode notes: 11.6 sentences drafted vs.
  5.9 written); cut toward theirs. Their usual length is a ceiling, not a
  target: cut asides the point doesn't need, like a plan put on hold, an
  algorithm detail, or a breakdown of counts (the user found a
  4,141-character blog post long though it sat mid-range for their blog,
  and approved cutting it to 3,454).
- **"A가 아니라 B" once,** where it corrects a real misconception. Used
  for rhythm, it reads as generated.

## Typed text

Posts, comments, descriptions, messages: text that should read as typed by
a person. Sounding human comes from cutting, not from decoration.

- **Keyboard marks only.** No middle dot: a list line starts with "- ",
  and "밀물·썰물" becomes "밀물, 썰물" (the user: people don't type ·). No
  em dash (—) or curly quotes (“ ”). Math symbols a text needs (≈, √, ÷)
  stay.
- **Don't decorate to sound casual.** Don't add ㅋㅋ, emoji, 반말, or
  typos; in a pasted draft, suggest cutting ones already there (the user
  passed on a YouTube reply with ㅋㅋ and 😅 and posted a calm 해요체 one). No markdown where the site shows it raw:
  YouTube shows ** and # as typed.
- **Leave the draft's typing alone.** In a pasted draft, a comma with no
  space after it ("밀물,썰물"), a greeting without "!", a line break
  between thoughts, fillers like 일단, 그냥, 좀 stay (the user kept
  "밀물,썰물" over a suggested space; drafted leetcode notes lost the
  fillers). Fix real misspellings only.
- **Only the numbers the point stands on.** "태양은 달보다 2700만 배
  무거워도 390배나 멀어서" became "태양은 달보다 멀어서", while 절반쯤,
  1.8ms, and 500억 년 stayed (the user's cut).
- **Name the thing people know.** "밀물, 썰물(사리, 조금)" lands faster than
  the mechanism alone (the user's addition). In a pasted draft, suggest it
  rather than adding it.
- **Not too tidy.** Paragraphs that all run claim then reason, each opened
  by 그런데, 그래서, 대신; bold labels; colon headings; lists of three. Loosen
  the one that stands out instead of rewriting for rhythm.

## Replies

- **Answer what was asked, first.** One short acknowledgment of a real
  question is fine (the user opened with "좋은 질문이에요"); then the
  answer. Don't restate the question, stack praise, or close like a
  chatbot ("더 궁금한 점 있으면 언제든…", "도움이 되셨길 바라요",
  "이해되셨나요?").
- **합니다 where people use it.** The explanation runs in 해요체, but
  people typing mix in 합니다 for set phrases: 감사합니다, 좋은 질문입니다,
  맞습니다, 확인했습니다. Keep them; don't even them out to 해요체, and don't
  alternate for rhythm either (the user: "내가 직접 입력할땐 이렇게
  섞일거 같음").
- **Build on other repliers.** Credit what another reply got right ("윗
  답글 말씀처럼") and add to it, instead of correcting them bluntly.
