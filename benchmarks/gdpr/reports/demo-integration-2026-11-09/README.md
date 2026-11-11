# Provisional demo integration results — 9 November 2026

Eight original breach subquestions were submitted to the authorized live demo in two variants (16 recorded POSTs). All 16 responses were received and handled; the exposed form schema matched before and after. This verifies an integration route, not legal accuracy, model performance or full company-case coverage. No LLM was called. The deployed rule source and version are not independently verified.

| Original question | Strict source facts | Explicit assumption: no authority decision | Provisional target label | Interpretation |
| --- | --- | --- | --- | --- |
| F14.q1 | Missing authority-decision fact | Held out by demo | yes | No verdict available; no workaround attempted |
| F15.q1 | Missing authority-decision fact | no: communication not required | no | Duty projection agrees; encryption/risk mapping still requires legal review |
| C02.q2 | Missing authority-decision fact | Held out by demo | yes | No verdict available |
| C02.q3 | Missing authority-decision fact | Held out by demo | yes | Same incident inputs as q2; no independent extra case |
| C09.q4 | Missing authority-decision fact | no: authority notification not required | no | Explicit authority duty returned |
| C09.q5 | Missing authority-decision fact | Communication duty not returned | no | No communication label inferred from the authority exemption |
| C10.q3 | Missing authority-decision fact | yes: notify authority | yes | Duty only; exact 72-hour deadline and priority of actions untested |
| C10.q4 | Missing authority-decision fact | no to individual contact; public/similar communication required | no | The substitute communication duty is preserved |

All eight strict runs are indeterminate because the combined query asks for `supervisory_authority_decision_on_communication`, absent from the original cases. In the additional conditional scenario there are **four explicit target-duty outputs, three held-out responses, and one missing target duty**. The four available duty labels match the provisional references; this is not “4/4 legal accuracy” or “8/8 passed”. The references and mappings remain unreviewed, full explanations/actions were not evaluated, selection is non-random, and some subquestions share inputs. No hypothesis test or primary benchmark score is computed.

## Evidence

- [Manifest](manifest.json): source/output hashes, run timestamps, counts, schema evidence and limits.
- [Observations](observations.jsonl): exact mapped inputs, field provenance, assumptions, live response fields, response-body hashes and timing. The demo template's recorded answer is excluded.
- [Comparisons](comparisons.jsonl): post-run target-label comparisons; unavailable labels and full-answer correctness stay null.
- [Coverage](coverage.csv): all 70 source subquestions, eight partial mappings, zero full-answer coverage. The registered 870-cell experiment matrix is unchanged.
- [Adoption check](upstream-adoption.json): PR and public default-branch evidence, separate from claims about private code.

The retained run followed three small contract-discovery POSTs and two earlier 16-request engineering passes. The first pass exposed two unsupported response shapes: a held-out notice, and an authority-only duty list. The parser was corrected and regression-tested; the original requests were not altered to evade held-out protection. The second pass was audited before the effective-input check and malformed-HTTP handling were strengthened; its 13 echoed input sets were separately confirmed to match. The retained run repeats the same inputs with those checks active. Earlier passes are not independent study samples. No provider credentials, Tailscale invite or private network address are in this package.

The full original cases and gold remain unchanged, including C10's provisional wording about the exact 72-hour point. This integration did not validate that timing interpretation; the open calendar/delay questions still require legal review.

## Has Mike incorporated our work?

At the read on 9 November 2026, PR #1 was open, draft and unmerged, with no comments/reviews returned. The public default branch was still `7d036b5e5625bc1a5ae3fd79c0e2d2d77e13f976`, the same base as our original submission, with no GDPR or benchmark paths in its complete tree. Our handoff has therefore not been integrated into that public main branch.

The private demo documents its own Clausify-generated rule packages and validation. We have not inspected its source or deployment history. Similar evaluation concepts, dates or vocabulary do not prove copying, inspiration or incorporation. **Adoption in private work is unknown, not established and not ruled out.**

## Technical verification

137 local tests passed on Python 3.11 and Python 3.15; the logs are [Python 3.11](tests-python311.txt) and [Python 3.15](tests-python315.txt). The frozen source validation passed. A separate AI code review found HTTP parsing-error handling and effective-input checking gaps; regression tests demonstrated both and passed after correction. Targeted reviewer verification found no unresolved issues. This does not constitute legal review.
