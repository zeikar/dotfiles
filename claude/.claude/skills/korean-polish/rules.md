# Korean wording rules

For Korean the user puts out under their own name. A project can add its
own rules on top (the `korean-polish` skill says where to find them). To
change a rule, follow that skill's step 6.

Where the rules came from: `survey.md` (Korean humanizer and 윤문 rule
sets, and what wasn't adopted) and `corrections.md` (the user's
corrections). Neither is needed to apply them.

## All text

| Rule | Instead of | Write |
|---|---|---|
| 번역투 | ~를 통해, ~에 의해, ~에 있어, 가지고 있다 | the plain particle or verb |
| 번역투 | ~되어지다, 쓰여진 (double passive) | ~되다, 쓰인 |
| 번역투 | 거의 정확히 X와 같다 | X와 거의 같다 |
| 번역투 | ~할 때 meaning "each time" or "while" | ~마다, ~동안 |
| 번역투 | an English passive kept as is: 0과 1로만 쓰이는 수 | 0과 1로만 이루어진 수 |
| Plain verbs | 검토를 진행했어요, 이 달의 경우 | 검토했어요, 이 달은 |
| No surplus 들 | 과학자들이 연구들을 | 과학자들이 연구를 |
| Say what 그 points to | 그 힘, 이것, 그 효과 when two things could be meant | the thing's name: 밀물, 썰물을 만드는 힘은 |
| Same ending 3+ times | 파일을 읽어요. 형식을 확인해요. 저장해요. | 파일을 읽고 형식을 확인한 다음 저장해요 |
| No stock phrases | 결론적으로, 종합하면, 주목할 만해요, 단순한 X를 넘어, "이유는 간단해요", a moral at the end | cut it |

- **Polite throughout:** no 반말 or -다 (해라체) slipping into polite text.
  Prose (docs, descriptions, scripts) keeps one register; replies mix
  해요체 and 합니다 freely (Replies).
- **Don't vary endings for variety:** -죠, -네요, -거든요 each carry a
  meaning (-네요 noticing something, -거든요 a reason the reader didn't
  know).
- **Keep precision:** a hedge the facts need stays ("약", "~할 수 있어요"),
  and so do technical terms. Never turn a hedge into a flat claim.
- **The user's length, when Claude writes.** Claude's drafts run about
  twice the user's own; cut toward theirs. Their usual length is a
  ceiling, not a target: cut asides the point doesn't need (a plan put on
  hold, an algorithm detail, a breakdown of counts).
- **"A가 아니라 B" once,** where it corrects a real misconception. Used
  for rhythm, it reads as generated.

## Typed text

Posts, comments, descriptions, messages: text that should read as typed by
a person. Sounding human comes from cutting, not from decoration.

- **Keyboard marks only.** No middle dot: a list line starts with "- ",
  and "밀물·썰물" becomes "밀물, 썰물". No em dash (—) or curly quotes
  (“ ”). Math symbols a text needs (≈, √, ÷) stay.
- **Don't decorate to sound casual.** Don't add ㅋㅋ, emoji, 반말, or
  typos; in a pasted draft, suggest cutting ones already there. No
  markdown where the site shows it raw: YouTube shows ** and # as typed.
- **Leave a pasted draft's typing alone.** A comma with no space after it
  ("밀물,썰물"), a greeting without "!", a line break between thoughts,
  fillers like 일단, 그냥, 좀 stay. Fix real misspellings only.
- **Only the numbers the point stands on.** "태양은 달보다 2700만 배
  무거워도 390배나 멀어서" → "태양은 달보다 멀어서".
- **Name the thing people know.** "밀물, 썰물(사리, 조금)" lands faster than
  the mechanism alone. In a pasted draft, suggest it rather than adding it.
- **No requests to the reader in -다 prose.** In a 해라체 post, "알려 주면
  고맙겠다" reads as 반말; state it instead: "버그 제보는 이슈로 받고 있다".
- **Not too tidy.** Paragraphs that all run claim then reason, each opened
  by 그런데, 그래서, 대신; bold labels; colon headings; lists of three. Loosen
  the one that stands out instead of rewriting for rhythm.

## Replies

- **Answer what was asked, first.** One short acknowledgment of a real
  question is fine ("좋은 질문이에요"); then the answer. Don't restate the
  question, stack praise, or close like a chatbot ("더 궁금한 점 있으면
  언제든…", "도움이 되셨길 바라요", "이해되셨나요?").
- **Mix 해요체 and 합니다 as the user does,** in plain statements too, not
  only set phrases (감사합니다, 확인했습니다). Don't even them out to 해요체
  or flag the mix as machine-written: a reply all in 해요체 reads like a
  blog post.
- **Build on other repliers.** Credit what another reply got right ("윗
  답글 말씀처럼") and add to it, instead of correcting them bluntly.
