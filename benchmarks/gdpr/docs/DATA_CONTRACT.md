# Data and result contracts — release 2.0

Data files use UTF-8 JSONL: one JSON object per nonempty line. Run and product manifests use `schema_version: 2`; the trusted Prolog bridge protocol remains `schema_version: 1`. The release contains **exactly 30 tasks**, IDs `F01`–`F20` and `C01`–`C10`. Each focused task has one question and each complex task has exactly five, for **70 subquestions**. Repetitions and system conditions do not increase the number of independent tasks.

## Cases and supplied facts

Each case has these fields:

| Field | Meaning |
| --- | --- |
| `id`, `kind`, `title`, `scenario` | Stable task identity, `focused` or `complex`, English title and full narrative |
| `questions` | Ordered question objects containing `id`, `prompt`, `rule`, `facts` and optional `evaluation_tags` |
| `law_articles` | Nonempty list of relevant complete GDPR article numbers, 1–99 |
| `scope.included`, `scope.excluded` | Expressly included and excluded issues |
| `missing_facts` | Case-level description of open information |
| `provenance` | Synthetic authorship, date and recorded revision information |

A question's decision refers to the proposition expressly asked in its `prompt`. A full reasoned answer is required even when its decision code is yes or no. The reusable `rule` identifier and typed fact fields are documented in [RULE_INPUTS.md](../data/RULE_INPUTS.md). Unknown values are `null`, never an inferred false. Outcome labels do not belong in facts.

The facts supplied with the cases are synthetic normalisations for `python_rules` and `prolog_oracle`; they are not independently reviewed extraction gold. Some represent explicit legal assumptions in the scenario. They must not be substituted for model-extracted facts in the matched LLM conditions. Those conditions receive the fact-field schema with null values and the field definitions, then derive their values from the public narrative. fact_schema.py validates types, enums, dates and finite numbers independently of whether the supplied oracle value is null. The plain-text baseline and exported product prompts receive the narrative, scope and questions, without normalised facts or reference answers.

Question tags `exception_boundary` and `missing_information` identify exploratory subgroup membership. They are frozen before inference and cannot be chosen from successful outputs. Several tagged questions from one complex case remain correlated observations; they do not create additional independent tasks.

## Provisional reference answers

A gold row has `case_id`, `status: "provisional"`, `independent_review`, `answers` and provenance. In this release `independent_review` remains pending with no assigned reviewer or review date. The loader supports provisional reference rows; a future change of reference status requires a documented release and corresponding workflow update, not a silent edit.

Every reference answer identifies `question_id` and `decision`, plus `conclusion`, `reasoning`, `legal_basis`, `required_points`, `acceptable_alternatives`, `missing_facts`, `actions` and `pitfalls`. Legal-basis entries carry `article`, `paragraph`, `point` and `url`; paragraph or point may be an empty string for an article-wide reference. Referenced articles must occur in the case's shared law context.

These references guide review but are not independently established legal truth. Agreement with them cannot substitute for legal evaluation. Reviewers may record reasoned disagreements and acceptable alternatives. Reference content never enters model inference; its hash is retained to connect a later evaluation with the version used.

## Structured predictions and raw product answers

Model and engine predictions must follow this shape:

```json
{
  "answers": [
    {
      "question_id": "q1",
      "decision": "unknown",
      "reasoning": "Explain the legal issue and the decisive missing fact.",
      "citations": ["GDPR Art. 6(1)(b)"],
      "missing_facts": ["Describe a material missing fact."],
      "actions": ["Describe an appropriate next step."]
    }
  ]
}
```

This example illustrates the schema; it is not a reference answer. `decision` is one of `yes`, `no`, `conditional`, `unknown` or `not_applicable`. Conditional means a stated condition or balancing exercise; unknown means a decisive fact is missing. There must be exactly one answer for every question, no duplicates or omissions. Reasoning must be a nonempty string; citations, missing facts and actions are lists of strings. The validator retains only defined answer fields.

Human-operated product imports instead preserve `{"text":"the unedited full product answer"}`. A prediction cannot mix free text and structured answers in the blind-review contract. The importer does not invent structured labels. Automatic decision-match scoring is unavailable for a raw product answer, but reviewers can assess each case question against it.

## Run records and provenance

A model/engine run writes `schedule.json`, `cases.snapshot.jsonl`, `predictions.jsonl` and `manifest.json` into a new directory. Existing output directories are not overwritten. The seed randomises case/repetition blocks and arm order. One model configuration is used per run; the matched conditions must run together to share extraction.

Each prediction row identifies `record_id`, `case_id`, `repeat`, `arm`, `provider`, `model`, `model_slot` where relevant, `status`, case/law/configuration hashes, calls, costs and timing. Successful rows include `prediction`; unavailable rows include a reason. Matched rows preserve `extracted_questions`, `extraction_sha256` and `engine_result` when available. A final answer call records `final_prompt_sha256` and its actual request text. The manifest records the case snapshot, source manifest, public configuration, code-file hashes, field-definition hash, gold-file hash and `gold_used_for_inference: false`.

| Status | Meaning |
| --- | --- |
| `ok` | Execution produced an output that satisfies its structural contract; this says nothing about legal correctness |
| `blocked` | A prerequisite or permitted execution route was unavailable, or the budget guard prevented execution |
| `failed` | An attempted execution or response failed its transport, engine or schema contract |
| `not_run` | Product template/matrix state before execution; product import preserves it as a blocked run row with a reason |

The six engine/model arms are `llm_text`, `llm_control`, `llm_python`, `llm_prolog`, `python_rules`, `prolog_oracle`. Product arms are `product:harvey`, `product:legora`, `product:noxtua`. With six model slots, four LLM arms, two oracle arms and three products, the full registration contains 29 candidate/condition combinations and 870 task cells. Readiness, execution status and human correctness are distinct. A configured cell is not an executed result; the matrix does not fabricate a human score from execution success.

`engine_scope_alignment` records approved Python/Prolog equivalence evidence only when the review metadata and relevant source/dataset hashes match; otherwise it remains pending. Engine availability alone is not proof of equivalent legal coverage. H4 must respect that boundary.

`cost_usd` is standalone-attributed inference cost. `billed_cost_usd` is additional request cost for that row in the shared-extraction run. A reused extraction retains its `call_id` and marks `reused=true`. Manifest totals count that request once. Unknown billing stays `null`; a known zero means no charged request under the recorded accounting semantics. Neither value includes the complete business cost. See [ADAPTERS.md](ADAPTERS.md) and [BUSINESS_CASE.md](BUSINESS_CASE.md).

Product exports retain prompt hashes, case hashes and law hashes. Completed captures record the actual version or `not_disclosed`, operator, timezone-aware timestamp, session, settings, submitted prompt and source-control declaration. `controlled_inputs` verifies the supplied prompt bytes, not hidden product retrieval. Product imports retain the raw response hash, export/capture hashes and `independent_capture_authenticity: "not_verified"`. Failed captures preserve attempted-response text and supplied cost/timing/metadata without a successful prediction. Original capture bytes are retained in capture.source.jsonl. Product evidence is operator-reported and no requests are executed by the importer.

## Human review and analysis

Blind export supplies the public case, canonical response and provisional reference under a random `blind_id`. The private identity mapping is stored outside the reviewer directory. Only the `ratings` section may be edited. Every exported answer must be rated; incomplete templates are not valid review imports. Two independent qualified GDPR reviewers work separately, a third adjudicator resolves differences, and an independent analyst handles the report. These roles start unassigned; a reviewer identifier is not proof of qualifications or independence.

Each question rating contains explicit Boolean `legally_correct` and `severe_error`; `required_points` with an unchanged point text, Boolean `met` and nonempty evidence; `scores` for exactly `legal_decision`, `conditions`, `exceptions`, `legal_basis`, `uncertainty`; and `errors` plus `comment`. Each rubric dimension is integer 0, 1 or 2. Required-point coverage is a separate diagnostic, not a sixth dimension.

An imported human row uses `metric: "human_accuracy"`. Its primary task `score` is 1 only when **all** subquestions are legally correct and none has a severe error, otherwise 0. A severe error vetoes a reviewer's positive correctness flag. Secondary `rubric_score` is the mean of question rubric totals divided by ten; `severe_error` is true if any subquestion contains one. Question details, evidence and source hashes remain attached. Blocked, failed or unreviewed records are not silently converted to human zero scores.

Automatic structured decision comparison uses `metric: "provisional_decision_match"` and is secondary only. It is not interchangeable with `human_accuracy`. The primary comparison uses one paired binary task outcome per condition at `repeat=0`. Repeated outputs, multiple reviewers and the five questions within a complex task are not additional independent cases. Adjudication exports list differences for a human decision; they do not automatically approve a final label. The full statistical rules, disagreement procedure and hypothesis definitions are in [PROTOCOL.md](PROTOCOL.md).

## Freeze and limits

The dataset, reference answers, field definitions, question tags, source corpus, prompts, configuration and rule versions belong to the reproducibility record. Changes require an explicit updated freeze and a new run. The [law manifest](../sources/law-manifest.json) identifies an officially supplied consolidated text and its machine extraction; neither the extraction nor this benchmark replaces the authentic Official Journal. The current 30 tasks are exposed synthetic materials, not a hidden independent validation set.

## Saved analysis evidence

Study and analysis CLI outputs retain score-file hashes and the corpus hash; the study also records its exact registration input and file hash. Economic reports retain all input assumptions, evidence references, quality-review declaration and an input digest. Decision reports link the exact analysis and economics hashes. A positive decision requires the full mandatory target set, finalized review evidence and measured H5, never a partial subset of passed targets. These checks establish internal consistency, not independent authentication of human declarations.
