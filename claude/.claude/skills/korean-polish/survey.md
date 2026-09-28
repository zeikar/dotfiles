# Survey of Korean polishing rule sets (2026-09-28)

What `rules.md`'s undated rules were picked from. The survey was done by a research
agent (web search and fetch) for polishing YouTube comment replies in
해요체. Read this before adding a rule: a candidate may already be here,
with its evidence or its problems.

## Sources

| Tag | Source | What it is | Rating |
|---|---|---|---|
| BH | github.com/blader/humanizer | English skill, 26 patterns from Wikipedia's "Signs of AI writing" | Worth borrowing: structure, chatbot residue, #26 wrong reader context |
| HK | github.com/simkoon/humanizer-ko | Korean port of BH v3: 25 patterns with evidence grades and exceptions, minimal edits, a list of facts that must survive | Worth borrowing; best balanced |
| KZ | github.com/jaewooongyun/koreanizer | BH fork, 35 patterns, plus "not a tell" and "human traits to keep" lists | Worth borrowing: the not-a-tell list |
| INA | github.com/epoko77-ai/im-not-ai (`ai-tell-taxonomy.md`) | 85 patterns, categories A–J, severity S1–S3, checked against corpora; some rules weakened when data disagreed | Worth borrowing; most rigorous, heavy |
| DS | github.com/DaleSeo/korean-skills (humanizer) | 40 patterns with KatFishNet statistics | Meh: good 번역투 examples, some harmful rules |
| YM | github.com/amondnet/yoonmoon | Register guide, XDAC summary, proofreading tables | Worth borrowing |
| KO | github.com/ChaeHyunIM/skills (`korean-output`, `SOUL.md`) | Output style rules plus one real person's casual-polite voice | Worth borrowing; closest to comment replies |
| KS | github.com/NomaDamas/k-skill | Humanizer derived from INA; slang skill says slang "자연스럽게 적게" | Meh |
| XDAC | ACL 2025 paper, via 국민일보 (kmib.co.kr, arcid=1750668896) and YM | AI vs. human Korean news comments, 2.3M samples | Worth borrowing; the only empirical source on comments |
| JS | 김정선 『내 문장이 그렇게 이상한가요?』, via brunch.co.kr/@gyaree/162 and @meteozerg/105 | Second-hand rule lists | Worth borrowing |
| BLOG | ohmynews A0003264627, brunch.co.kr/@maven/527, itsallim.blogspot | Lists of tells, overlapping the above | Meh |
| MSG | namu.wiki 마침표, clien 17561226, brunch.co.kr/@rayng/331 | Messenger punctuation habits | Anecdotal |

Not accessed:
- The Medium summary of JS returned 403.
- No online text of 이오덕's rules was found, only a note that he criticized ~에 있어서.
- The LobeHub and aradotso mirrors were not read.

A 2026-09-27 survey for the tangent project (im-not-ai, patina,
im-ai-copyeditor) found that automatic checks misfire on spoken scripts:
they strip breathing commas and "A가 아니라 B".

## Catalog

**번역투**
- ~에 대해 → object particle: "미래에 대해 분석합니다" → "미래를 분석합니다" [DS, KZ, KO]. INA found that untranslated human text uses it 3× more than AI does, so it edits only when there are 3 or more in a paragraph.
- ~를 통해 → 로 or 해서: "설문을 통해 찾는다" → "설문을 보고 찾는다" [KZ, DS]. INA downgraded this rule: untranslated Korean uses it 2× more than translated text.
- ~에 있어서 → 에서 [KZ, INA A-3 S1, KO].
- 가지고 있다: "경쟁력을 가지고 있다" → "경쟁력이 강하다" [INA A-7, DS, KZ].
- Double passive: "나뉘어진" → "나뉜" [JS, HK, INA A-8].
- ~에 의해: "AI에 의해 생성된" → "AI가 만든". Exception: "파일이 삭제되었습니다" is fine [INA A-9, HK #9].
- Stacked particles: "긴장으로부터의 해방" → "긴장에서 벗어남". A plain ~의 is not 번역투 [INA A-19, JS].
- Surplus 들: "사용자들이 기능들을" → "사용자가 기능을" [DS, JS].
- Pronouns: "그것은 팀원들의 노력 덕분입니다" → "팀원들의 노력 덕분이죠" [DS, KO]. INA changes a pronoun only when nothing in the previous two sentences could be its referent, or when exactly one thing could.
- Abstract subject with a catch-all verb: "금융위기는…변화를 가져왔다" → "금융위기로…바뀌었다" [INA A-15].
- "단순한 X를 넘어 Y": 0 in INA's human corpus vs. 12 in AI text [INA A-21, HK #1].
- "~은 명확하다" → just say it [INA A-22]. "더 이상 ~않다" → "이제 ~않다" [INA A-24].
- 로부터 → 에게; "놀라기 시작했다" → "놀랐다"; "마실 수 있는 것" → "마실 것"; "그 어떤" → "어떤" [JS].

**Nominalization**
- "검토를 진행했습니다" → "검토했습니다" [HK #11, KO, DS].
- "역할은 파일을 읽는 것입니다" → "파일을 읽습니다" [HK #12].
- "사회적 현상" → "사회 현상" [JS].
- "이 기능의 경우 사용성의 측면에 있어" → "이 기능은" [HK #10].
- "해당 문제는 해당 팀이" → "이 문제는 팀에서" [DS, KO].

**Stock phrases and inflated meaning**
- 결론적으로, 종합하면, 시사하는 바가 크다, 주목할 만하다, 중요한 것은 X다, 지평을 열다 [INA D-1/D-2/D-8/A-23, KZ #7, BLOG].
- Hype words such as 혁신적 and 압도적 [DS #38, HK #7]. INA grades the evidence for this rule as weak.
- Answering its own question: "왜 느릴까요? 이유는 간단합니다" → "요청마다 파일을 다시 읽어서 느립니다" [HK #4, BLOG].
- A moral at the end, like "앞으로도 끊임없는 노력으로…" → delete it [HK #24, OhMyNews].
- Aphorisms ("대칭은 신뢰의 언어다") [KZ #32]. Answering objections nobody raised ("오해하지 마세요") [KZ #34, BH #5].
- "전문가들은…": don't just delete it and state the claim as fact; mark that it needs a source [HK #6].

**Structure**
- Forced lists of three [BH #6, HK #17, KZ #10].
- Not-X-but-Y [BH #1, KZ #9]. Keep it when the contrast corrects something real ("삭제가 아니라 보관입니다") [HK].
- Announcing what comes next ("지금부터 살펴보겠습니다") [HK #2, BH #4].
- Bold-label lists [KZ #16, BH #19]; colon headings [INA C-10, DS #7].
- Cycling through synonyms for the same thing [HK #18, KO].
- INA keeps 첫째/둘째 lists by default [C-1].

**Punctuation and formatting**
- A comma after a connective ending: "발전하지만," → "발전하지만". Humans 4.10% vs. AI 19.83% [INA C-11, DS #3, HK #22, KZ #14].
- Em dash [BH #8, KZ #14, INA J-3].
- Decorative emoji: "🚀 **새 기능:** CSV 저장을 지원합니다!" → "CSV 저장을 지원합니다." [HK #20, INA C-5].
- Scare quotes and curly quotes; 「」 are fine [KZ #19].

**Rhythm and endings**
- The same ending over and over ("읽습니다. 검사합니다. 중단합니다.") → merge with connective endings [HK #15, KZ #11].
- Nothing but short sentences [INA E-4, KZ #31].
- Mixed speech levels: "선택하세요. 저장하면 된다" → "됩니다" [HK #16, YM, INA E-7].
- Stacked hedges: "발생할 가능성이 있을 수도 있습니다" → "발생할 수 있습니다" [HK #19]. Stacked honorifics: "하실 수 있으실 것 같습니다" → "하실 수 있습니다" [KO].
- No "~것 같아요" on facts you're sure of [KO, SOUL].

**Chatbot leftovers in replies**
- "좋은 질문입니다! … 더 도와드릴까요?" → just the content [HK #23, KZ #20/#22, BH #22]. HK's exception: a real closing, or an offer that fits the conversation, stays.
- Lead with the answer; don't restate the reader's problem [BH #26].
- Never ask "이해되셨나요?" [KO].

**Casual comment register (해요체)**
- Default to "해요 / 될까요? / 봐주세요"; a crisper "수정했습니다" for announcements [SOUL].
- Short reactions like "네네", "아하", "그러네요" are fine when natural, but not in front of every sentence [SOUL].
- `!` and `~` brighten a line; ㅋㅋ, ㅎㅎ, ㅠ lightly show friendliness or embarrassment; stay calm when the reader has a real problem [SOUL]. Examples: "네네 확인했습니다! 그럼 이걸로 진행할게요~", "오오 축하드립니다!!! 오늘 맛있는 거 드세요~~".
- "아마" or "같아요" only on guesses [SOUL].
- What marks AI-written comments [XDAC]:
  - Almost never a line break: 0.001% of AI comments vs. 10.2% of human ones.
  - Few doubled spaces.
  - Few repeated characters: 11.6% vs. 51.7%.
  - Uniform length and a neutral tone.
  - Only standard emoji, where humans use ㅋ, ㅠ, ·, ♡, ★.
  - Formal phrasing ("~것 같다", "~에 대해").
- A sentence-final period reads as stiff in chat [MSG, anecdotal].
- Vocabulary should match the register ("상기 사항을 숙지" doesn't belong in casual text); keep -시- consistent [YM].
- Don't introduce typos, 반말, or emoji the writer didn't use [HK, SOUL].

## Conflicts and overreach

1. **Turning hedges into assertions** (DS #33 "자동화할 수 있다" → "자동화한다", DS #40). INA, KO, and HK #19 forbid it. After INA applied a similar rewrite to 55 eye-clinic posts, 40 had to be rolled back. Keep every hedge in science writing.
2. **Mixing 합니다 and 해요 for rhythm.** DS #24 recommends it; HK, YM, and INA E-7 forbid mixed levels. KZ says a mix alone isn't a tell, and SOUL mixes 합니다 set phrases into 해요 replies. The user confirmed that their own typing mixes like this (see `rules.md` → Replies).
3. **Planting spacing errors** (DS #8/#9). HK and SOUL reject it; it's wrong for anyone posting publicly.
4. **Emoji and ㅋㅋ point opposite ways by genre.** In prose, decoration reads as AI (INA C-5); in short comments, its absence does (XDAC). The user's call for their own replies: no decoration (see `rules.md` → Typed text).
5. **Short sentences.** KO and DS #4 favor splitting; INA E-4 and KZ #31 call a run of short sentences an AI signature. HK says don't shorten across the board.
6. **Em dashes.** KZ bans them, yet lists "기자와 편집자도 쓴다" among non-tells. INA keeps dashes the writer typed.
7. **Colons.** DS #7 limits them to times and ratios, which looks overzealous (the researcher recalled, unchecked, that the official rules allow one after a heading).
8. **Scientific precision.** Several rules can flatten it:
   - Breaking up ~적 terms (INA F-5, DS #39).
   - Stripping degree adverbs (INA F-1; it exempts casual speech).
   - The abstract-subject rule (KO exempts a tool or result as a natural subject).
   - Removing "명확하다" (INA A-22 keeps it at the end of a real argument).
9. **DS contradicts itself.** Its #21 rewrite adds "왜냐고요?", which is HK #4's self-Q&A tell. It also reports KatFishNet's detector AUC as if it were the accuracy of each rule.

## Not adopted yet

- **The connective comma** (humans 4% vs. AI 20%). It is the strongest measured tell, but the user's own posted reply has two ("멀어서,", "걸려서,"), so it isn't a rule for their voice. Revisit if it shows up in Claude's drafts.
- **"좋은 질문입니다" as a chatbot opener.** The user opened a real reply with "좋은 질문이에요", so `rules.md` allows one short acknowledgment.
- **The middle dot.** No source treats it as an AI tell, and XDAC counts · among human symbols. It is banned as the user's own habit, not as a tell.
