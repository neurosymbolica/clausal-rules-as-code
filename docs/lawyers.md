# Lawyers in the loop

Executable rules are only as good as the legal reading behind them. This work assumes that
qualified lawyers decide what the law means, and that the program's job is to make every
reading it relies on explicit, testable and easy to review.

## What a lawyer reviews, and where to find it

| Question for the reviewer | Where it is answered |
|---|---|
| What question does the domain answer, and for whom? | `manifest.yaml`, `scope` |
| Which version of the text was used? | `sources/*.meta.yaml` |
| Which provisions are formalized, and by which rule? | the side-by-side report, `provisions.yaml` |
| Which provisions were left out, why, and what follows from that for a user? | `manifest.yaml`, `deferred_set` and `excluded_set`; the report |
| Where the text admits more than one reading, which was chosen? | `manifest.yaml`, `operative_readings` |
| What must the user supply, and what happens if they do not? | `SIGNATURE.md`, `profile_keys.yaml` |
| Does the domain answer the worked cases correctly? | `tests/` |

## Judgement stays with people

- **Facts and evaluations are inputs.** Whether a state of urgency is "duly substantiated" or
  criteria are "objective and non-discriminatory" is supplied by the user; the domain applies
  the consequence the law attaches to it.
- **Choices are recorded, not hidden.** An operative reading names the alternatives considered
  and says which one is the more conservative.
- **Gaps are declared.** A deferred provision carries the consequence of the gap in plain words,
  for example that a caller who applies another article wrongly will get a wrong count with
  nothing here able to detect it.
- **Refusal over guesswork.** When input is missing or malformed the domain says it cannot
  decide.

## Where a legal review fits in the method

A reviewer's correction becomes a change to a rule or a record, a new test that pins the
corrected answer, and, where the reading changes, an updated operative reading. The checks then
confirm that nothing else moved. Review therefore leaves a trace that the next reviewer can
inspect.
