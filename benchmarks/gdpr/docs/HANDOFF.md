# Handoff to Mike — GDPR Legal-AI concept and evaluation suite

This release implements the complete research concept and the evaluation machinery in English. It does not claim that the study has been conducted or that market demand has been validated. The scope is exclusively the EU GDPR: 30 top-level tasks, 20 focused and 10 complex, with 70 subquestions. Procurement material and the earlier proposed 60/300-case inventory are outside this release.

## Reading order

1. PROJECT_CONCEPT.md is the full concept narrative, including the research question and experimental design.
2. BUSINESS_CASE.md is the desk-based business analysis and customer-validation plan, with sourced competitor facts and labelled assumptions.
3. PROTOCOL.md specifies who evaluates, what correctness means and how H1–H5 and the proposed success thresholds are assessed.
4. CASES.md contains every complete case; REFERENCE_ANSWERS.md contains all 70 complete provisional answers.
5. ../README.md gives reproducible commands; ADAPTERS.md and DATA_CONTRACT.md specify interfaces.
6. ../reports/VERIFICATION.md and the machine-readable reports distinguish actual local checks from unperformed experiments.

## Requirements mapped to concrete deliverables

| Requirement | Implementation / artifact | Evidence state |
| --- | --- | --- |
| Entire concept, not only a benchmark skeleton | PROJECT_CONCEPT.md | Authored research proposal |
| Business use case, competitors, commercial decision | BUSINESS_CASE.md; ../sources/market-evidence.json | Desk research and explicit hypotheses; no interviews or sales inferred |
| Exactly 20 focused + 10 complex GDPR cases | ../data/cases.jsonl; CASES.md | All 30 written; 70 subquestions |
| Correct answers, legal bases, scope and missing facts | ../data/gold.provisional.jsonl; REFERENCE_ANSWERS.md | Full provisional gold; independent review pending |
| Same law text for all model conditions | ../sources; ../gdpr_bench/law.py and prompts.py | Frozen complete relevant articles and per-case hashes |
| Same-model matched comparison | ../gdpr_bench/runner.py | Shared extraction; final prompt differs by engine evidence |
| LLM + Python comparator | llm_python condition | Actual bounded Python engine on model-extracted facts |
| LLM + Prolog and supplied-fact oracle | ../gdpr_bench/prolog.py; ../config/prolog.example.json | Reviewed local interface implemented; formal runs blocked; separate provisional remote demo diagnostics now available |
| OpenAI, Opus, Sonnet, Gemini, Qwen, DeepSeek | ../gdpr_bench/providers.py; ../config/models.example.json | Configurable adapters; no live account/model performance claim |
| Harvey, Legora, Noxtua comparison | ../gdpr_bench/products.py | Genuine manual response export/import; no access or answers claimed |
| Complete evaluation matrix | ../reports/evaluation-matrix.csv | 29 registered conditions × 30 = 870 cells, not 870 independent cases |
| Binary legal correctness and severe-error veto | ../gdpr_bench/evaluation.py | Human input required; automatic label match remains secondary |
| Five dimensions, error taxonomy and blinded review | PROTOCOL.md; generated reviewer INSTRUCTIONS and roles | Templates and validated import; roles unassigned |
| Two reviewers, third adjudicator, separate analyst | Review import, agreement and adjudication CLI | Actual declarations and resolutions required; no synthetic reviews |
| H1/H2/H3/H4, subgroup tests and multiplicity | ../gdpr_bench/statistics.py, analysis.py, study.py | Executable; no evaluable human results yet |
| H5, full costs, sensitivity, break-even and decision | ../gdpr_bench/economics.py; ../config/economics.example.json | Calculator and illustrative scenario; observed H5 unavailable |
| CLI, dependencies, tests, reproducible package | ../README.md; ../requirements.txt; ../tests; ../scripts | Local execution and archive verification reported separately |

## Who does what next

Two actual qualified GDPR lawyers independently review the provisional references and responses. A third qualified reviewer resolves disagreements. A separate independent analyst manages the private identity key, preserves pre-adjudication agreement and runs the registered analysis. These are roles to assign, not people already recruited. Names, qualifications, conflicts and acceptance must be recorded before final claims. Software records these declarations; it cannot certify professional qualifications.

The technical owner pins accessible model IDs, account settings and prices, then uses one matched run per model. Model/product access, actual vendor answers, legal review and commercial measurements are not supplied by this ZIP. A Prolog owner must provide actual GDPR rule modules and bridge artifacts with source revision, hashes, coverage, legal review and Python-equivalence mapping before Prolog conditions can execute. Public upstream inspection did not establish such modules.

Business ownership must run discovery and a paid or explicitly committed pilot, record volumes and time saved, and validate willingness to pay and deployment obligations. The illustrative economic scenario is not evidence of demand. The current decision remains inconclusive; this package makes the remaining tests concrete and executable.

## Review and sharing boundaries

The full handoff is for a collaborator managing the project. It includes the private identity mapping for the local baseline demonstration, clearly separate from the reviewer folder. Give blinded evaluators only their dedicated reviewer bundle. Do not send the full repository to a reviewer while claiming they are blind to condition identities.

No external LLM or commercial product responses were generated for this release. No completed legal review, customer interview, sales commitment or reviewed GDPR Prolog benchmark result is included. Technical test fixtures are marked as fixtures and kept in tests. None of the included reports assert superiority or a validated business case.

## 9 November integration addendum

The [demo integration](DEMO_INTEGRATION.md) adds an adapter, a 70-row partial-coverage matrix and sixteen genuine remote observations for eight breach subquestions. [The result report](../reports/demo-integration-2026-11-09/README.md) distinguishes missing facts, held-out protection, explicit duty outputs and a duty not returned. These observations are not reviewed oracle results or complete company-case answers. The original dataset, references, main evaluation matrix and study gates remain unchanged.
