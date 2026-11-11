# Research evaluation packages

## GDPR-30: concept and evaluation suite

**Current consolidated status (11 November 2026):** [What has been delivered, what actually ran, and what is still needed from Mike](gdpr/docs/STATUS_FOR_MIKE.md).

**New exploratory evidence (9 November 2026):** [Six boundary cases × four models × three conditions](gdpr/reports/edge-pilot-2026-11-09/README.md). Twelve actual model calls tested supplied rule-output augmentation, not Mike’s own end-to-end agent. A [direct six-case agent check](gdpr/reports/system-access-2026-11-09/README.md) subsequently returned six GDPR scope rejections; whole-system legal accuracy remains unevaluated. Original answers, provisional ratings, coverage and reproducible analysis included. The ZIP below remains the earlier frozen handoff snapshot and does not include this later pilot.


[Start with the full English handoff](gdpr/README.md). The package contains exactly 30 synthetic GDPR tasks (20 focused and 10 complex, 70 subquestions), provisional reference answers, the concept and business analysis, six experimental arms, model/product adapters, independent legal review workflows, statistical analysis and full-cost scenarios.

- [Full concept](gdpr/docs/PROJECT_CONCEPT.md) and [business analysis](gdpr/docs/BUSINESS_CASE.md)
- [Cases](gdpr/docs/CASES.md), [provisional reference answers](gdpr/docs/REFERENCE_ANSWERS.md), [protocol](gdpr/docs/PROTOCOL.md)
- [Evaluation matrix](gdpr/reports/evaluation-matrix.csv), [complete package tree](gdpr/docs/PROJECT_TREE.txt), [verification](gdpr/reports/VERIFICATION.md)
- [Downloadable ZIP](artifacts/gdpr-legal-ai-handoff-en-2026-11-09.zip), [SHA-256](artifacts/gdpr-legal-ai-handoff-en-2026-11-09.zip.sha256), [fresh-extraction verification](artifacts/gdpr-legal-ai-handoff-en-2026-11-09.zip.verification.json)

Run locally from `benchmarks/gdpr` using Python 3.11 or newer. No third-party Python dependency is required. The default run executes the Python diagnostic baseline and honestly records unavailable model and Prolog conditions.

This is a research handoff for discussion, not an accepted production domain or a completed study. The public upstream snapshot did not establish usable GDPR Prolog modules; no substitute rules are presented as upstream work. Genuine GDPR Prolog conditions remain blocked. Legal gold review, real model/product outcomes and measured commercial validation remain pending. No existing domain formalizations are changed.

The included PRIVATE-review-key.json maps only the clearly labelled local Python demonstration. It is not a credential or a key to any completed human review. Future blinded reviewers must receive only their newly generated reviewer bundle; this full collaborator package is not itself a blinded review packet.

## Provisional demo integration — 9 November 2026

[Adapter and mapping](gdpr/docs/DEMO_INTEGRATION.md) · [live results and adoption check](gdpr/reports/demo-integration-2026-11-09/README.md) · [70-row coverage matrix](gdpr/reports/demo-integration-2026-11-09/coverage.csv). Eight questions were tested in strict and conditional variants. Formal Prolog study conditions remain blocked; these remote diagnostics do not establish independent legal accuracy. The dated 6 November archive remains the original handoff; the download above includes the integration addendum.
