# Release 2 integration contracts

## Ownership
Dataset worker: data/cases.jsonl, data/gold.provisional.jsonl, data/RULE_INPUTS.md, docs/CASES.md, gdpr_bench/rules.py (English prose only), tests/test_dataset.py.
Concept worker: docs/PROJECT_CONCEPT.md, docs/BUSINESS_CASE.md, sources/market-evidence.json. No code/config changes.
Evaluation worker: gdpr_bench/evaluation.py, gdpr_bench/statistics.py, new gdpr_bench/analysis.py, tests/test_evaluation.py, tests/test_analysis.py, docs/PROTOCOL.md. No CLI/runner/data changes.
Parent: runner/providers/product import/export/economics/CLI/matrix/config/prompts, all other docs, freeze/package/reports.

## Stable data and outputs
Case IDs F01..F20,C01..C10 and question IDs stay unchanged. Keep facts/types/decisions/legal citations semantically identical, translated prose English. Optional question evaluation_tags: exception_boundary, missing_information. Tags are frozen before future inference, never derived from a result.
Prediction structured format remains {answers:[{question_id,decision,reasoning,citations,missing_facts,actions}]}. Product responses may instead be {text: "verbatim product answer"}; automatic decision-match score is null for free text, human scoring remains possible. Blind export must canonicalize both formats without identity metadata.
Run rows retain record_id,case_id,repeat,arm,provider,model,status,prediction,case_sha256,law_sha256,cost_usd. `cost_usd` means standalone-attributed inference cost; `billed_cost_usd` means actual additional request cost in the shared-extraction execution. Reused extraction calls carry reused=true and same call_id; manifest actual_api_calls/total_cost_usd deduplicate charges. Input, source, configuration and prompt hashes must survive import.
Six arms: llm_text, llm_control, llm_python, llm_prolog, python_rules, prolog_oracle. Products use arm=product:<name>. Shared extraction group: llm_control,llm_python,llm_prolog only; use same extracted question facts (never oracle facts), same final SYSTEM, same final prompt template with only a clearly delimited engine-evidence slot differing. Strict causal claim limited to this controlled pipeline; match Python and Prolog rule coverage before any engine-specific conclusion.

## Human review API
Keep blind_export(run_dir, reviewer_dir, key_file, gold), import_reviews(review_file,key_file,reviewer), diagnostic_scores(run_dir,gold), summarize_scores(rows).
Ratings per q: scores {legal_decision,conditions,exceptions,legal_basis,uncertainty}: 0/1/2; legally_correct: bool; severe_error: bool; required_points existing checklist with evidence; errors+comment. Severe error vetoes legally_correct. Imported row metric=human_accuracy, score=1 only if ALL subquestions legally correct and none severe; rubric_score=mean(sum five dims/10); severe_error=any; questions retain correctness/score/rubric/errors and question_id. No auto-assigned human correctness. Require ratings complete. Pending templates never become results.
Raw product text accepted in blind_export; do not invent structured decisions from it. Metadata outside private key not shown to raters.
Adjudication API: adjudication_export(first_scores,second_scores,output_path) writes an explicit disagreement checklist; finalize_adjudication(first_scores,second_scores,adjudication_file,roles_file) validates actual human decisions and declarations. No automatically assigned human labels. Agreement descriptive + Cohen kappa for binary task decisions where feasible.

## Statistics/analysis API
Preserve existing compare_scores(rows,a,b,failure_policy='exclude',seed=17) for secondary paired scores. Add primary_accuracy_compare(rows,a,b,primary_repeat=0): one case-level binary observation per arm/case; same repeat0; one-sided exact McNemar/binomial test H1 b>a; n, wins/losses, p, accuracy delta, paired bootstrap CI; missing/blocked/unreviewed excluded and counted; failure-policy sensitivity separately. Reject mismatched metrics, duplicate records, corrupt provenance.
Add analysis.hypotheses_report(rows,cases,control='llm_control',treatment='llm_prolog',python_arm='llm_python',primary_repeat=0): H1 primary; H2 difference in treatment effect complex vs focused with descriptive/appropriate test; H3 paired severe-error reduction; H4 treatment vs Python; exception_boundary and missing_information subgroup accuracy using question tags (no pseudoreplication); missing outputs => not_evaluable. H5 parent economics module. User targets emitted with observed values and pass/fail/not_evaluable, avoid p0 inventions. If no human rows result is not_evaluable rather than wrong automatic metric.

## Product exchange
Parent writes product-export bundles with model-style common case and law prompts, questionnaire/metadata and statuses not_run. Product-import requires exact export hashes/version, actual raw answers, timestamp/product version/operator/source-control declarations; immutable new run dir. Free-text predictions supported, no automatic semantic judging.
