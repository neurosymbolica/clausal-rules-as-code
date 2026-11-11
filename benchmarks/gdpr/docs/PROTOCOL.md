# GDPR-30 evaluation protocol — release 2.0

6 November 2026. This is a prospective pilot protocol, not a registered study or a report of model performance. The corpus is synthetic and provisional. Independent GDPR legal validation, qualified outcome reviewers, an independent analyst, genuine GDPR Prolog modules, and real model/product outputs remain pending unless separately evidenced. No test fixture is an empirical legal result.

## Changes from the development draft

Before any real model/product evaluation, this release restores the original intended endpoint and rubric and makes the controlled experiment executable. The development draft incorrectly used a two-sided rubric-score contrast, four scoring dimensions plus checklist coverage, and a one-call versus two-call primary comparison. Those choices are superseded as follows; they must not be silently combined with release 2 results.

| Element | Release 2 prespecification |
| --- | --- |
| Primary outcome | Human binary legal correctness, with a severe-error veto |
| Primary contrast | Matched `llm_prolog` versus `llm_control`, for each registered exact model/version |
| Primary hypothesis | H0: p_Prolog ≤ p_control; H1: p_Prolog > p_control |
| Primary test | One-sided exact McNemar/conditional binomial, alpha 0.05, repeat 0 only |
| Primary statistical unit | One case; 20 focused + 10 complex = 30 cases |
| Secondary rubric | Exactly five dimensions, each 0–2: legal decision, conditions, exceptions, legal basis, uncertainty |
| Required-point checklist | Retained with evidence, reported separately; not a rubric dimension |
| Repetitions | Prespecified robustness observations, never additional independent cases |
| Mechanism comparison | Shared extracted facts and identical final response prompt for control/Python/Prolog, differing only in the engine-evidence slot |

Any later revision to outcome definitions, corpus, source bundle, subgroup tags, model family, repeats, or test direction must be dated and justified before inspecting corresponding results. Do not describe this file as a preregistration in an external registry.

## Population, corpus and legal scope

The intended task population is bounded EU GDPR case analysis for private organizations. The frozen pilot contains exactly F01–F20 and C01–C10: 20 focused tasks with one question each and 10 complex tasks with five linked subquestions each. There are 70 question ratings but only 30 primary case observations. A complex task passes primary accuracy only when all five subquestions pass. Cases receive equal weight. Complexity is a designed category, not randomly assigned; rule families recur across cases and can create dependence beyond the case clusters.

All organizations and scenarios are synthetic. Case narratives, questions, provisional reference reasoning and this handoff are in English. The shared authoritative source text is English GDPR legislation. Relevant articles are preselected for all model conditions, which supplies a common retrieval advantage. National opening clauses, sectoral laws, ePrivacy/employment law, authority lists, changing adequacy decisions and case law are not comprehensively represented. Case-level scope and missing facts must remain visible. The pilot cannot establish performance across the whole GDPR or all legal practice.

The provisional reference is a review aid, not validated gold. Before a claim-bearing study, two qualified GDPR lawyers/reviewers independent of case and rule authorship must check facts, applicability, citations, exceptions, conclusions and acceptable alternatives. Record actual people, qualifications, independence, conflicts, dates and changes. Resolve differences, freeze the corrected corpus, and retain its hashes. Development cases are not an unseen holdout. A subsequent generalization study needs separately held-out, independently validated cases; the present scope remains 30 tasks.

## Conditions and controlled comparability

1. **`llm_text`**: a simpler, one-call deployment baseline with the common case and legal sources. The additional extraction structure and calls differ from the controlled pipeline. Its comparison is an end-to-end deployment comparison.
2. **`llm_control`**: model fact extraction followed by response synthesis without a symbolic engine result.
3. **`llm_python`**: the same extracted facts and synthesis prompt, with Python rule evidence in the delimited evidence slot.
4. **`llm_prolog`**: the same extracted facts and synthesis prompt, with genuine reviewed Prolog rule evidence in that slot.
5. **`python_rules`**: deterministic rule evaluation with supplied normalized facts. It is a diagnostic oracle for rule behavior, with an information advantage over NLP conditions.
6. **`prolog_oracle`**: genuine Prolog rules with supplied normalized facts. “Oracle” describes the input mode, not established legal truth.
7. **Harvey, Legora, Noxtua**: separate human-operated black-box product comparisons, using the reproducible exchange bundle. Record real product/version/date/operator/access, prompts, sources and actual answer evidence. Product tools and models are not assumed equivalent to the controlled open pipeline.

Within each model/case/repeat, `llm_control`, `llm_python` and `llm_prolog` share the same model-extracted facts. They use the same exact model, article bytes, extraction schema, synthesis SYSTEM prompt and final prompt template; only the clearly delimited engine-evidence slot differs. The model never receives provisional gold, its conclusions or supplied normalized fact values. Record extraction, case, law, configuration and prompt provenance. Different shared-extraction hashes invalidate a matched controlled comparison. Source/model/corpus mismatches and duplicate case/repeat/arm records are rejected.

This design isolates access to the supplied engine evidence within the controlled pipeline, conditional on its other matched components. It does not demonstrate that Prolog as a programming language is superior to an equally specified Python implementation. H4 requires a documented review of equivalent Python/Prolog rule coverage for the exact rule code and corpus. Runtime alignment evidence must be approved, identify a real reviewer/date, and match each case hash; without it the raw comparison is descriptive and the engine inference is `not_evaluable`.

Real GDPR Prolog modules and their review provenance are mandatory. Missing modules block every Prolog condition before paid calls. A toy, stub, echoed answer or Python fallback is not a Prolog result. Unavailable model configurations and products stay in the evaluation matrix as blocked/not run; absence is not a legal error. Hosted/self-hosted OpenAI-compatible Qwen and DeepSeek are configured explicitly, alongside OpenAI, Anthropic Opus and Sonnet, and Gemini. Do not silently drop an unavailable registered model or select a favorable version after seeing outcomes.

## Primary human accuracy and secondary rubric

Every subquestion receives explicit human `legally_correct: true/false` and `severe_error: true/false`. A severe error is a material legal mistake capable of leading to unlawful processing, loss of a right, a missed mandatory duty, or materially unsafe legal advice. Record the legal reason, supporting answer evidence and error category. The effective question correctness is `legally_correct AND NOT severe_error`. The record retains both the reviewer's initial correctness answer and the effective vetoed answer.

A case receives primary `score = 1` only if every subquestion is effectively correct; otherwise `score = 0`. Any severe subquestion makes the case severe and incorrect. A correct decision code alone is insufficient if its reasoning materially misapplies the law. Appropriate conditional or unknown conclusions can be correct when facts are missing. Missing review data are unknown, not zeros, and are not inferred from perfect rubric points.

Each subquestion also receives exactly these five secondary dimensions:

| Dimension/key | 0 | 1 | 2 |
| --- | --- | --- | --- |
| Legal decision / `legal_decision` | Wrong or absent conclusion | Partly correct or insufficiently qualified | Correct, appropriately qualified conclusion |
| Conditions / `conditions` | Relevant legal conditions absent or misapplied | Incomplete application | Relevant conditions correctly applied to the facts |
| Exceptions / `exceptions` | Material exception missed or wrongly invoked | Incomplete exception analysis | Relevant exceptions correctly addressed, including justified absence |
| Legal basis / `legal_basis` | Wrong or absent legal basis | Partly accurate/incomplete basis | Correct applicable basis and supporting references |
| Uncertainty / `uncertainty` | Missing facts ignored or certainty invented | Incomplete handling of uncertainty | Missing information handled appropriately, or justified definiteness |

Question rubric score is the five-dimension sum divided by 10. Case rubric score is the mean of its question rubric scores. Required reference points each retain a boolean `met` and a short evidence note. Coverage is descriptive and does not change the five-dimension score. No fixed rubric threshold automatically determines human legal correctness.

Other secondary diagnostics include provisional structured decision-code matching, question error categories, severe-error occurrence, conditional/unknown responses, availability, tokens, cost and elapsed time. A raw product answer is kept verbatim as free text; its automated decision-match score is null. It remains fully human-reviewable. There is no automatic semantic judge or implicit LLM judge. An optional future LLM judge would need separately disclosed validation and would remain secondary.

## Independent review, blinding and adjudication

All roles begin **unassigned**: first qualified GDPR reviewer, second independent qualified GDPR reviewer, third independent qualified GDPR adjudicator, and independent analyst. `roles.json` in the review bundle makes this explicit. Before final inference record each actual identity, qualifications, acceptance date, relationship to authorship and conflicts. A reviewer identifier supplied to a command does not certify qualification or independence.

The two reviewers independently complete separate copies of the identical blind export before seeing each other's ratings. The export supplies a randomized blind ID/order, public case, canonical answer, provisional reference and blank ratings. Model, provider, condition, original record ID, operational metadata, cost and tool trace stay in a private mapping outside the reviewer directory. Free-text product answers remain verbatim; the export cannot remove self-identification in an answer without changing evidence. Writing style and content can also reveal condition, so suspected unblinding must be recorded.

The bundle also includes `legislation/gdpr-articles.txt` and `legislation/law-manifest.json`, copied after `LawCorpus` verifies the pinned source hashes. Each real case item identifies its relevant article numbers. Reviewers should consult these exact full articles when assessing the answer and provisional reference. Source-file verification is distinct from verifying each run's supplied law bytes; the release CLI checks run provenance separately. Synthetic test fixtures with placeholder law hashes are not evidence of real run-law matching.

Only rating fields may change. Import checks the immutable case/response/reference hash, the complete blind-ID set, question coverage, exact dimension keys and 0/1/2 values, explicit correctness/severity booleans, unchanged required-point wording, and evidence. Pending templates cannot produce results. Imported independent reviews retain their provenance and `review_status = independent_review`. They are not silently promoted to final consensus.

Before joining scores, report descriptive task-level binary agreement and Cohen's kappa where its denominator is nonzero. Constant marginals yield an undefined/null kappa, never an invented perfect reliability estimate. Agreement rows pair by source-prediction hash and original record ID; duplicates are rejected. These statistics are descriptive, especially when repeated responses appear in the review set.

`adjudication_export` identifies disagreements in human decisions, severity, dimensions, checklist decisions and error labels. Different prose in otherwise agreeing evidence notes is not by itself a rating disagreement. It creates an unresolved checklist with an unassigned adjudicator and null resolutions. No score is averaged into consensus; no label is automatically approved. A third qualified reviewer documents a reasoned resolution of each substantive disagreement. Agreement cases also require documented human sign-off. Preserve both original reviews, the resolution evidence and the final outcome file. The independent analyst must use one finalized label per response for the claim-bearing analysis; unresolved independent-review files support only explicitly labelled preliminary estimates. Do not concatenate two raters and count their ratings as extra cases.

### Actual finalization files and API

`finalize_adjudication(first_scores, second_scores, adjudication_file, roles_file)` returns final score rows only after validating actual human declarations and decisions. It does not write over the original reviews. For each of `reviewer_1`, `reviewer_2` and `third_adjudicator`, replace its null role assignment with this object, completed by the actual person:

```json
{
  "id": null,
  "qualifications": null,
  "independent_of_authorship": null,
  "conflicts": null,
  "accepted_at": null
}
```

IDs must match the two independent review files. Qualifications and conflict declarations must be nonempty text; an explicit declaration of no conflicts is acceptable. Acceptance is an ISO date/time. Independence from authorship must be expressly declared true. The third person must have a different ID and also expressly declare `independent_of_reviewers: true`. These are recorded declarations, not independently verified professional credentials. The independent analyst remains unassigned until a real person accepts that separate role.

The adjudication export retains immutable review-set hashes and original rating evidence. Its editable completion fields start as follows; this is deliberately **not** a completed sign-off:

```json
{
  "status": "pending_adjudication",
  "adjudicator": null,
  "qualifications": null,
  "independent_of_reviewers_and_authorship": null,
  "signed_at": null
}
```

An actual third reviewer fills the ID, matching qualification declaration, explicit independence declaration and ISO sign-off date/time, and changes status to `completed` only after review. For every exported disagreement, fill its existing `resolution`, `rationale` and `resolved_at` fields. Resolution is exactly one of:

- `{"choice":"first"}`: explicitly adopt the first reviewer's complete response rating.
- `{"choice":"second"}`: explicitly adopt the second reviewer's complete response rating.
- `{"choice":"custom","ratings":[...]}`: supply complete actual third-reviewer question ratings in the original blind-import format, including all five `scores`, correctness/severity booleans, unchanged required points with evidence, errors and comment. This supports resolving separate questions differently without silently averaging them.

Each dispute requires a substantive rationale and ISO resolution date/time. Keep original ratings, blind IDs, agreement metadata and review hashes unchanged. Even a file with zero disagreements requires explicit third-reviewer sign-off. Missing qualifications, reused identities, inconsistent provenance, unresolved disputes, incomplete custom ratings and altered evidence are rejected. The finalizer recomputes primary accuracy, the severe-error veto and secondary rubric from the actual chosen/completed ratings. Final rows contain `review_status: "adjudicated"` and `review_evidence` with both reviewer IDs, the distinct adjudicator, declarations, decision/rationale and source/adjudication/role hashes. Unavailable responses remain null. Numerical analysis records whether this finalization evidence exists; target pass/fail requires it. No real assignments or approvals are supplied by this release.

## H1: primary paired binary test

For each registered exact model/version, use repeat **0**, fixed before inference. Let p_control and p_Prolog be task-level legal-accuracy probabilities under this pilot's scope.

- H0: p_Prolog ≤ p_control.
- H1: p_Prolog > p_control.
- Alpha = 0.05, one-sided. No post-result choice of test direction or repeat.
- Unit: one matched case, at most 30; no question or repeat pseudoreplication.

Count `wins_b` (control incorrect, Prolog correct) and `losses_b` (control correct, Prolog incorrect). Conditional on their sum d, the null boundary uses X ~ Binomial(d, 0.5); report P(X ≥ wins_b). This is the one-sided exact McNemar test. With no discordant pairs p = 1. With no eligible human pairs the result is `not_evaluable` and p is null. The test does not require a large-sample chi-squared approximation.

Report both accuracies, the paired difference Prolog minus control, counts of concordant/discordant cases, and a 95% percentile interval from 20,000 seeded resamples of whole case pairs. This two-sided uncertainty interval is separate from the one-sided test and need not imply the same threshold decision. Small-sample percentile intervals can be degenerate (for example every observed difference equals 1); they are not evidence of certainty about all future legal cases. Inferential interpretation also assumes independent case pairs despite recurrent rule families.

Retain the whole registered model family. Apply Holm adjustment to the family of primary per-model p values; report both raw and adjusted values and every unavailable comparison. The study-level report must not substitute a smaller favorable model family. Product and single-call deployment comparisons remain separately identified. The proposed gain against the best single-call baseline is a separate descriptive benchmark; do not conflate it with the controlled causal contrast.

## H2–H5 and prespecified subgroups

**H2, complexity:** estimate the treatment effect separately for 20 focused and 10 complex cases, and the complex-minus-focused difference of case-level treatment effects. The exploratory two-sided test permutes complexity labels on entire paired case differences, exactly when at most 100,000 allocations exist, otherwise with 20,000 seeded draws and a plus-one correction. It assumes exchangeability of treatment effects across complexity groups under the null. Complexity and legal content were not randomized; this assumption can fail. Bootstrap whole cases within each complexity stratum for the interaction interval. Require at least two eligible cases in each stratum for uncertainty analysis. Treat estimates as exploratory evidence about this corpus, not a causal effect of adding complexity.

**H3, severe errors:** a case has a severe error if any subquestion has one. On matched human-rated cases at repeat 0, report both case severe-error rates, absolute reduction, and relative reduction `(control_rate - Prolog_rate) / control_rate`. The relative reduction is undefined when the control rate is zero. Use the one-sided exact paired binary test on freedom from severe errors; H1 is fewer severe errors with Prolog. The paired case bootstrap interval concerns the absolute reduction. Missing severity ratings remain unknown. Never replace them with measured zeros.

**H4, Python versus Prolog:** report the same repeat-0 binary paired contrast with `llm_python` as comparator. The direction is Prolog greater than Python, as an exploratory secondary contrast, not an equivalence or noninferiority claim. A lack of significance does not establish equivalence. Without approved scope-equivalence evidence matching rule code/corpus/case hashes, H4 is `not_evaluable` for an engine conclusion; the raw observed contrast stays visible as descriptive evidence.

**Exception/boundary subgroup:** membership comes only from frozen question `evaluation_tags: ["exception_boundary"]`, never from whether a model failed. Use human effective question correctness. Average eligible tagged questions within each case and then give cases equal weight. The analysis reports both question counts and case clusters; it does not treat five related questions as five independent observations.

**Missing-information subgroup:** membership comes only from the frozen `missing_information` question tag. Correct handling requires both human effective question correctness and full credit (2) on the uncertainty dimension. This operational definition is fixed before inference and stricter than merely outputting the word “unknown.” Report the same within-case-then-between-case aggregation, missing coverage and uncertainty. No tags or incomplete human judgments mean `not_evaluable`, not inferred membership or scores.

Subgroup uncertainty uses case-pair bootstrap and exploratory two-sided paired sign-flip testing. Exact sign flipping is used through 18 nonzero case differences, otherwise 20,000 seeded Monte Carlo draws with plus-one correction. The test requires sign exchangeability/symmetry under its null; equality of means alone is insufficient. At least two case clusters are required. Report H2, H3, H4 and both subgroups together; do not select only significant findings. They are exploratory, outside the primary model-family confirmatory claim.

**H5, economics:** the separate economics module combines observed human accuracy with API, licence, formalization, integration, legal review, maintenance, hosting and human-handling costs. Explicit optional error-risk assumptions must remain distinguishable from observations. Include sensitivity and break-even. Missing costs, access or human outcomes make the relevant result unavailable. Inference billing counts a shared extraction call once, while standalone-attributed arm cost includes the extraction required by that deployment. Do not equate those two cost measures.

## Proposed decision targets and missing data

These are proposed decision criteria, not validated performance facts:

| Criterion | Proposed threshold |
| --- | --- |
| End-to-end accuracy gain | At least 5 percentage points; distinguish controlled and best single-call baseline contrasts |
| Severe-error reduction | At least 30% relative reduction, requiring a nonzero measured baseline |
| Exception/boundary improvement | At least 10 percentage points on the prespecified subgroup |
| Correct missing-information handling | At least 95% on the prespecified subgroup |
| Primary significance | One-sided p < 0.05, with registered model-family adjustment before a family claim |
| Economic value | Positive savings per correctly handled case with full costs |

`hypotheses_report` emits observed values plus pass/fail/not_evaluable. Pass/fail for these performance targets requires all planned 30 cases, complete relevant subgroup/severity review and explicit two-reviewer/adjudicator finalization evidence; partial or independent-review estimates remain visible without a final pass. Passing a numeric threshold is not market validation, proof of general superiority or a standalone Go decision. Access, independent analysis, matched scope and full economics are separate requirements.

Primary complete-case analysis uses only valid human outcomes for the same case and prespecified repeat in both arms. Availability counts distinguish failed, blocked, missing and unreviewed records. An unknown substantive answer is not the same thing as unknown review status. Both arms missing a case must also be visible through planned-versus-observed coverage. Complete-case selection may bias the estimate; report its limitations.

Technical `failed` records receive zero only in the separately labelled operational sensitivity analysis. Missing keys/modules, budget blockers, unavailable products, absent answers and unreviewed answers are never imputed as legal failures. Primary human results remain unchanged by that sensitivity. Repeats after 0 can be analysed as robustness by aggregating matched repeats within case; the existing two-sided secondary paired-score analysis preserves the case as the resampling unit. It cannot replace the primary test or rescue a nonsignificant repeat by choosing another.

## Error categories and audit trail

`wrong_legal_basis`, `wrong_scope`, `wrong_role`, `missed_exception`, `wrong_threshold`, `wrong_deadline`, `unsupported_fact`, `missed_missing_fact`, `overconfident_conclusion`, `missing_action`, `incomplete_answer`, `invalid_citation`, `inconsistent_reasoning`, `formalization_error`, `tool_misuse`, `other`.

Several categories may apply to one question. Technical failures and coverage blockers are separate operational statuses. Unrated errors are unknown, not measured zeros. Preserve exact inputs/outputs, source snapshots, registered model slots and versions, prompt/configuration/extraction hashes, independent ratings and adjudication evidence. Report all deviations from the frozen plan. Without eligible human outcomes, H1–H4 and their targets are `not_evaluable`; automated provisional-gold diagnostics must never be relabelled as human evidence.
