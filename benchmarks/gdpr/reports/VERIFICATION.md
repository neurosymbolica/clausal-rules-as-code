# Verification record — English release 2.0

Date: 6 November 2026. This records technical execution, not a completed legal or commercial study.

| Check | Observed result |
| --- | --- |
| Python 3.11 test discovery | 119 tests passed; full output in tests-python311.txt |
| Python 3.15 test discovery | 119 tests passed; full output in tests-python315.txt |
| Local CLI workflows | All 12 returned their expected exit codes; local-workflows.json |
| Dataset and frozen sources | 30 tasks, 20 focused, 10 complex, 70 subquestions; 99 GDPR articles; hashes valid |
| Structured citations | All 293 cited article/paragraph/point locations exist in the pinned official XML |
| All six arms, one local repeat | 180 scheduled records: 30 ok, 150 blocked, 0 failed |
| Real provider calls and recorded API cost | 0 calls; USD 0.00 |
| Registered evaluation matrix | 870 cells: 29 conditions × 30 tasks; 30 executed Python rows; 0 human scores |
| Human study analysis | not_evaluable; no fabricated p-values or human correctness results |
| Economic example | Scenario calculated; H5 not_evaluable because inputs are illustrative |
| Current combined decision | inconclusive; business_case_proven=false |
| Compilation and whitespace | Python modules compile; git diff --check clean |
| Independent code review | Reported material findings resolved and relevant paths rechecked; not an independent legal review |

The regression tests cover exact corpus and citation structure, English content, nullable typed facts, missing facts, calendar deadlines, severe-error veto, blinded import, actual adjudication requirements, shared extraction, no oracle input leakage, paired case-level statistics, repeat handling, Holm adjustment, model-version consistency, source integrity, provider normalization, budgets and unknown costs, non-finite response rejection, blocked Prolog, failed product capture evidence, complete decision gates, and economic break-even arithmetic. Synthetic fixture calls and ratings are confined to tests; they are not benchmark results.

## Archive verification

The delivered ZIP has a sibling SHA-256 file and a sibling `.verification.json` record. That record identifies the exact archive hash, checks its complete file manifest, extracts it into a fresh temporary directory, runs the test suite and 13 additional CLI workflows, and verifies 30 ok / 150 blocked records, zero external calls, a 870-cell matrix, unavailable human results and an inconclusive decision. The archive verification result is external to the ZIP so that it can identify the final bytes without a self-referential hash.

Reproduce with `python3 scripts/verify_package.py /path/to/archive.zip --report /new/path/verification.json`. The verifier refuses an existing report path.

## Evidence that remains absent

All reference answers remain provisional. Independent GDPR gold review, two actual response reviewers, third-person adjudication and independent statistical analysis have not occurred. Model IDs/prices and account access remain to configure. No real OpenAI, Anthropic, Gemini, Qwen, DeepSeek, Harvey, Legora or Noxtua answer has been evaluated. No genuine GDPR Prolog module is bundled or activated. Customer interviews, commitments, actual review-time savings and measured unit economics are absent. The desk-based business analysis and the executable measurement design are delivered; their empirical conclusions remain open.

The Python baseline's decision-code matches with provisional gold are internal consistency diagnostics. Shared authorship and case construction prevent treating them as independent accuracy evidence. Thirty purposively selected synthetic cases cannot establish general legal reliability or market superiority.

## Integration addendum — 9 November 2026

The suite now passes **137 tests on Python 3.11 and 3.15**, including 18 new adapter tests. See [the retained integration logs and report](demo-integration-2026-11-09/README.md). The 30/20/10 inventory, 70 subquestions, frozen gold/law hashes and formal Prolog gates remain unchanged. A separate AI code reviewer checked the implementation, identified two material issues (HTTP exception handling and effective-input verification), and confirmed their fixes through targeted offline tests and inspection of the retained evidence. This is software review, not legal validation.

The final live run records 16 demo POSTs: eight missing-fact responses in strict mode; four explicit target-duty outputs, three held-out notices and one missing target duty under an expressly labelled no-authority-decision assumption. Thirteen effective-input echoes matched the submitted facts; the three held-out replies intentionally provide none. No LLM inference ran. Source/module identity and legal correctness are unverified. The full results retain their limitations and hashes; they are excluded from formal study scoring.

The updated 9 November ZIP is checked by `scripts/verify_package.py`, now with **16 checks**, including coverage generation and refusal of remote execution without the explicit live flag. Its sibling verification file names the final ZIP hash. The original 6 November archive and its historical 14-step verification remain dated artifacts.
