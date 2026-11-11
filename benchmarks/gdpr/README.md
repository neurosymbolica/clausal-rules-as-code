# GDPR Legal-AI Benchmark — English handoff, release 2.0

[Consolidated handoff status for Mike — 11 November 2026](docs/STATUS_FOR_MIKE.md): delivered package, executed tests, interpretation limits and next steps.

**Exactly 30 tasks: 20 focused GDPR cases and 10 realistic company cases with five subquestions each (70 subquestions).** The full concept, business analysis, evaluation protocol, readable cases and provisional reference answers are included. This is an executable research package, not a completed empirical study.

Start with [PROJECT_CONCEPT](docs/PROJECT_CONCEPT.md), then [BUSINESS_CASE](docs/BUSINESS_CASE.md). [HANDOFF](docs/HANDOFF.md) maps every deliverable and outstanding evidence gate. [PROJECT_TREE](docs/PROJECT_TREE.txt) lists the complete delivered repository. Everything in the authored handoff is English; source files preserve their original format.

## What is delivered

| File | Content |
| --- | --- |
| [Project concept](docs/PROJECT_CONCEPT.md) | Complete rationale, research design, model/product selection, hypotheses and decision framework |
| [Business analysis](docs/BUSINESS_CASE.md) | Buyer, workflow, alternatives, commercial hypotheses, cost model, discovery and pilot design |
| [Cases](docs/CASES.md) | All 30 complete case narratives, 70 questions, scope, missing facts and subgroup rationale |
| [Reference answers](docs/REFERENCE_ANSWERS.md) | All 70 full provisional conclusions, reasoning, legal bases, required points, alternatives and pitfalls |
| [Structured cases](data/cases.jsonl) and [gold](data/gold.provisional.jsonl) | Machine-readable inputs and separate provisional labels; independent review pending |
| [Protocol](docs/PROTOCOL.md) | Human correctness, severe-error veto, five-dimension rubric, blindness, H0/H1–H5, statistics and error categories |
| [Evaluation matrix](reports/evaluation-matrix.csv) | 870 registered cells: 29 conditions × the same 30 cases; readiness and actual execution distinguished |
| [Study registration draft](config/study.json) | Six model slots, three products, primary comparison, proposed thresholds and unassigned roles |
| [Adapters](docs/ADAPTERS.md) and [data contract](docs/DATA_CONTRACT.md) | Interfaces, provider constraints, provenance and controlled inputs |
| [Economic example](config/economics.example.json) | Explicit illustrative assumptions; never reported as observed demand or savings |
| [Verification](reports/VERIFICATION.md) | Actual local checks and remaining limits |
| [Law provenance](sources/law-manifest.json), [upstream inspection](sources/upstream-check.json), [market evidence](sources/market-evidence.json) | Pinned legal text, public Prolog inspection and primary vendor sources |

## Provisional demo integration addendum — 9 November 2026

The [demo adapter and mapping](docs/DEMO_INTEGRATION.md) now have [recorded live integration results](reports/demo-integration-2026-11-09/README.md). The separate [coverage matrix](reports/demo-integration-2026-11-09/coverage.csv) covers all 70 questions and marks eight as partially mapped. Sixteen requests cover eight strict-source and eight explicitly assumed-no-authority-decision variants: the strict variant has eight missing-fact responses; the sensitivity variant has four explicit duty outputs, three held-out responses and one duty not returned. These are provisional remote diagnostics, excluded from the formal study arms and legal accuracy scores. The frozen dataset and gold remain unchanged.

## Exploratory four-model boundary-case pilot

[Read the six-case comparison](reports/edge-pilot-2026-11-09/README.md): OpenAI Sol/Astra and Claude Opus/Sonnet, with legislation alone, additional RIS decisions, or actual demo outputs. Twelve CLI calls returned 144 answer objects; one output failed strict question-ID validation. Provisional assistant ratings concern rule-output augmentation only; they do not compare Mike’s whole system against the models. A subsequent [direct six-case agent check](reports/system-access-2026-11-09/README.md) reached the chat endpoint, but all six GDPR narratives were rejected as out of scope. End-to-end legal accuracy remains unevaluated. This separate supplied-fact study does not alter the formal six-arm protocol, frozen GDPR-30 data or independent-review gates. The experiment documents all limitations and original outputs.

## Run locally

Python 3.11 or newer; no third-party packages, account or internet connection is required for the local baseline, evaluation tools or tests. In the extracted `gdpr-benchmark` folder:

```sh
python3 -m gdpr_bench validate
python3 -m unittest discover -s tests -v
python3 -m gdpr_bench run --out runs/python --arms python_rules
python3 -m gdpr_bench score runs/python --out runs/python-diagnostics.jsonl
python3 -m gdpr_bench run --out runs/all
```

The final command currently exits **3** with 30 successful Python baseline records and 150 blocked records. Exit 0 means all requested conditions executed; 2 means invalid input; 3 means the run was recorded but includes blocked/failed conditions. Existing outputs are never silently overwritten. Use a fresh directory for another run.

## Conditions and models

| Arm | Input and role |
| --- | --- |
| `llm_text` | Single-pass LLM with narrative and frozen relevant GDPR articles; practical deployment baseline |
| `llm_control` | Shared LLM fact extraction, then answer synthesis without engine evidence; primary matched control |
| `llm_python` | The same extracted facts and final prompt, with the Python engine's evidence |
| `llm_prolog` | The same extracted facts and final prompt, with a genuine reviewed Prolog engine's evidence; currently blocked |
| `python_rules` | Supplied normalized facts, bounded Python rules; rule diagnostic, not an NLP or independent legal oracle |
| `prolog_oracle` | Supplied normalized facts and genuine reviewed Prolog rules; currently blocked |

The matched trio shares one extraction per case/repeat in a single run. Only engine evidence changes at synthesis. Prepared facts, gold answers and analysis tags never enter LLM prompts. The supplied Python rules and provisional gold share authorship, so decision matches are internal consistency checks, not measured legal accuracy.

The six slots are `openai`, `anthropic_opus`, `anthropic_sonnet`, `gemini`, `qwen`, `deepseek`. Copy `config/models.example.json` to `config/models.local.json` and set exact accessible model IDs/revisions, parameters and dated prices. Null values deliberately block execution. Compatible Qwen/local and DeepSeek endpoints use the OpenAI-compatible adapter; model weights, serving stack and account access are not bundled.

Keys are read only from process environment: `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `GEMINI_API_KEY`/`GOOGLE_API_KEY`, or configured `QWEN_API_KEY`/`DEEPSEEK_API_KEY`. No `.env` is loaded automatically. Never put credentials in model configuration or reports.

```sh
python3 -m gdpr_bench doctor --models config/models.local.json
python3 -m gdpr_bench run --out runs/openai-pilot \
  --models config/models.local.json --slot openai --cases F01 C01 \
  --arms llm_text llm_control llm_python llm_prolog --live --budget-usd 5
```

Live execution requires `--live`, configured prices and a budget. Actual provider token counters, raw responses, prompts, elapsed time and costs are preserved. Unknown costs stay null and stop further paid calls. No automatic paid retries. Attributed strategy cost includes extraction for each arm; actual billed run cost counts the shared extraction once. Hosting and human review belong in the separate full-cost analysis. Local reservations are not a guarantee of the provider's eventual invoice.

The inspected public `neurosymbolica/clausal-rules-as-code` snapshot has no usable published GDPR modules. `sources/upstream-check.json` records the exact commit, tree and search scope. No GDPR Prolog rules or fabricated engine responses are bundled. Configure a real bridge only with sourced artifacts, hashes, coverage and independent review. H4 additionally requires approved Python/Prolog scope-equivalence evidence.

## Legal products: a separate experiment

Harvey, Legora and Noxtua are product candidates, not assumed accessible APIs. Their native capabilities or retrieval may differ from the controlled experiment. The export/import workflow records actual operator, version, settings, exact submitted prompt, source control, timestamp and captured text.

```sh
python3 -m gdpr_bench product-export --product harvey --out runs/harvey-packet
# With actual access, submit prompts and fill the packet's responses.jsonl truthfully.
python3 -m gdpr_bench product-import runs/harvey-packet \
  runs/harvey-packet/responses.jsonl --out runs/harvey-import
```

Untouched templates import as blocked, never invented answers. Repeat for `legora` and `noxtua`. Free-text answers receive human review; no automatic judge manufactures semantic scores. Product results are reported separately and cannot identify a Prolog causal effect.

## Who evaluates and where the answers are

The full provisional answer key is in `docs/REFERENCE_ANSWERS.md` and `data/gold.provisional.jsonl`. **No independent lawyer has approved it.** Two qualified independent GDPR reviewers must review the reference material and independently score blinded responses. A third qualified adjudicator resolves disagreements; a separate independent analyst conducts the analysis. Actual names, qualifications, conflicts and acceptance remain unassigned. AI-authored drafts and Python checks do not fill these roles.

```sh
python3 -m gdpr_bench gold-review-template --out runs/gold-review.jsonl
python3 -m gdpr_bench blind runs/python \
  --out runs/reviewers --key runs/PRIVATE-mapping.json
```

Give reviewers only the reviewer bundle, not the private mapping or full handoff containing identities. Each reviewer independently edits a separate copy of `items.jsonl`, changing only `ratings`. Record the real role declarations in `roles.json`. Style/self-identification can still compromise blinding; record suspected unblinding.

```sh
python3 -m gdpr_bench review-import runs/reviewer-a.jsonl \
  --key runs/PRIVATE-mapping.json --reviewer reviewer-a --out runs/scores-a.jsonl
python3 -m gdpr_bench review-import runs/reviewer-b.jsonl \
  --key runs/PRIVATE-mapping.json --reviewer reviewer-b --out runs/scores-b.jsonl
python3 -m gdpr_bench agreement runs/scores-a.jsonl runs/scores-b.jsonl --out runs/agreement.json
python3 -m gdpr_bench adjudication-export runs/scores-a.jsonl runs/scores-b.jsonl --out runs/adjudication.json
# The third reviewer completes actual resolutions and signoff; roles contain real declarations.
python3 -m gdpr_bench adjudication-finalize runs/scores-a.jsonl runs/scores-b.jsonl \
  --adjudication runs/adjudication.json --roles runs/reviewers/roles.json --out runs/final-scores.jsonl
python3 -m gdpr_bench analyse --scores runs/final-scores.jsonl --out runs/model-analysis.json
python3 -m gdpr_bench study-analyse --scores runs/final-scores.jsonl --out runs/study-analysis.json
```

Supply one final score set per run/model to `study-analyse`; never pool two raters as independent cases. The primary unit is a complete case (30), not a subquestion (70) or repeat. A severe error vetoes correctness. Five 0/1/2 dimensions provide secondary detail. Repeat zero is primary; later repeats are robustness checks. Missing/unreviewed/blocked evidence remains unavailable. The multi-model report preserves matched comparisons, adjusts the registered model family and separately tests the proposed descriptive gain over the best complete single-pass model. Without actual human labels, the result is `not_evaluable`.

## Economics, decision and complete matrix

```sh
python3 -m gdpr_bench economics --out runs/economics.json
python3 -m gdpr_bench decision --analysis runs/study-analysis.json \
  --economics runs/economics.json --out runs/decision.json
python3 -m gdpr_bench matrix --runs runs/all --out runs/matrix.csv
```

The supplied economics are an explicitly illustrative scenario, including formalization, integration, maintenance, hosting, licensing, API use, human review and rework. H5 needs measured evidence and independent quality review. A technical pass is permission to test a customer pilot, not proof of demand. The present handoff decision is **inconclusive** because legal reviews, actual model/product outcomes, a GDPR Prolog engine and measured business evidence are absent.

## Reproduce, update and package

```sh
python3 scripts/check_upstream.py /tmp/gdpr-upstream-new.json
python3 scripts/fetch_law.py /tmp/gdpr-source-new
python3 scripts/package.py --out /tmp/gdpr-handoff.zip
python3 scripts/verify_package.py /tmp/gdpr-handoff.zip --report /tmp/gdpr-package-verification.json
```

The 99 English GDPR articles are included with the original official XML, source metadata and hashes. Each case supplies the same complete selected articles in every arm. Changing the corpus, legal text or study registration requires a deliberate new freeze/release and documented review, not silent editing of past results. The ZIP allowlist excludes local model settings, secrets, caches, Git history and worker scratch files. The source folder runs directly; no wheel installation is required.
