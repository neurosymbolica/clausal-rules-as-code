# Private demo integration — provisional, 9 November 2026

The adapter connects the existing eight breach subquestions to the demo's live `notification_obligation` query. It sends supplied synthetic facts, not natural-language prompts. This is an integration diagnostic: no LLM extraction or answer synthesis ran, and the remote outputs are not reviewed legal truth. The original 30 tasks, 70 questions, provisional gold, 870-cell study matrix and formal Prolog review gates remain unchanged.

## What is implemented

`gdpr_bench/demo.py` implements mapping, transport, response parsing, duty projection and a separate report format. `demo-coverage` generates a matrix with one row for every original subquestion. Eight rows are partially mapped; the other 62 have no mapping in this adapter. This does not assert that Mike's engine lacks their capabilities. No complete company case or complete answer, including all reasoning and next steps, is covered.

`demo-run` loads a non-held-out example page to obtain its form schema and an in-memory CSRF session. It submits fresh facts to the same `/demo/api/books/run` route used by the page. The selected example ID `NOT-2569` supplies the interface context only: none of its default facts or recorded answers are copied or scored. The POST contains `book`, `case`, `query`, `facts` and `arguments`. This is an observed web-form interface, not a promised or versioned public API.

The transport rejects redirects, applies a timeout and response-size limit, and validates submitted values against the observed form. HTTP is allowed only for loopback and Tailscale's shared address range; other origins require HTTPS. Credentials embedded in URLs are rejected. The configured origin, cookies and CSRF token are excluded from report files. Use only the intended authorized demo origin; this adapter is not a general service-discovery tool.

The returned S-expression is parsed as data, never executed. The live `raw` duty list is interpreted through an explicit allowlist. The demo's nested `expected` record belongs to its original example and is discarded. A held-out notice is preserved without changing inputs or using another route to reveal an answer. A missing duty is `not_returned`, not an inferred exemption. Unknown response shapes fail closed and retain their response hash when received. Every non-held-out response must echo exactly the submitted effective facts, without duplicates; mismatched or missing input fails before any decision is projected. Malformed or truncated HTTP responses produce recorded failures rather than an empty abandoned run.

## Fact mapping and scope

| Our source | Demo input | Interpretation / limit |
| --- | --- | --- |
| Confirmed `personal_data_breach` | Book precondition | Required true; false or unknown is rejected rather than silently assumed |
| Case narrative | `party_role=controller` | Controller-role interpretation for these five cases; independently unreviewed |
| `risk_assessment=unlikely/risk/high` | `breach_unlikely_to_result_in_risk`; `breach_likely_to_result_in_high_risk` | Respective pairs true/false, false/false, false/true; unknown is omitted |
| `data_unintelligible` | `appropriate_protection_measures_applied_to_affected_data` | Narrow interpretation of the Article 34(3)(a) scenario; not equivalence of all possible protective measures |
| `later_measures_avert_high_risk` | `subsequent_measures_ensure_high_risk_no_longer_likely` | Supplied assessment, not a judgement made by this adapter |
| `individual_contact_disproportionate` | `communication_would_involve_disproportionate_effort` | Public/equally effective substitute must remain visible when returned |
| `hours_since_awareness` | Not submitted to this duty query | No deadline, feasibility, justified-delay or calendar-rule evaluation |
| Authority decision on communication | Absent in source | Omitted in strict runs; `no_decision` only in the expressly labelled sensitivity scenario |

For C02, C09 and C10 the remote query combines both duties, so mapping may also use a sibling breach question's facts about the same incident. Each mapped field records its source question. Conflicting known values are rejected, and unknown values are omitted rather than converted to false. These are supplied-fact diagnostics, not evidence of an LLM's ability to extract facts.

F15 supplies high disclosure risk and effective encryption separately. Translating that into the demo's risk/protection inputs is provisional; it does not determine whether a lawyer would assess residual risk differently. The full response also contains an authority-notification duty outside F15's question; that auxiliary duty is not scored as part of F15.

Two variants are retained per question:

- `strict_source`: uses only mapped source information. No authority decision is silently invented.
- `assume_no_authority_decision`: expressly assumes no Article 34(4) decision. It is a conditional sensitivity scenario, not an amendment to the original case.

## Reproduce

From `benchmarks/gdpr`, with Python 3.11 or later and network access to the authorized demo:

```sh
python3 -m gdpr_bench demo-coverage --out runs/demo-coverage.csv
# Set GDPR_DEMO_BASE_URL locally to the authorized origin (scheme, host, port).
# Do not put the invitation URL, credentials or network address in a commit.
python3 -m gdpr_bench demo-run --live \
  --include-no-order-sensitivity --out runs/demo-integration
```

The origin is read from `GDPR_DEMO_BASE_URL`, or the variable named by `--base-url-env`. No `.env` file is loaded automatically. Without `--live` there are no requests. Existing output directories are refused. Eight POSTs run in strict mode, or sixteen with the sensitivity variant; requests are sequential and never automatically retried. Form metadata is fetched before and after the run. Exit 0 means the requests were handled and the observed form schema stayed stable; it does not mean that eight answers were available or legally correct. Exit 3 records transport/contract failures; exit 2 indicates invalid configuration.

The output consists of `observations.jsonl`, `comparisons.jsonl`, `coverage.csv` and `manifest.json`. These are deliberately not `predictions.jsonl` benchmark records. They cannot activate `llm_prolog` or `prolog_oracle`. Gold is read only after the requests, for a limited duty-label comparison; full-answer correctness stays null. The manifest records input/output and code hashes, time, HTTP-result counts, missing/withheld decisions and schema stability. It cannot verify a remote rule commit because the demo exposes no verified rule-source revision through this interface. Engine timing is server-reported; round-trip time includes transport and is not human time saved. Demo hosting cost is unknown; no external model tokens or model fees were incurred by this adapter.

## Observed results and next integration step

See [the live report](../reports/demo-integration-2026-11-09/README.md), [all 70 coverage rows](../reports/demo-integration-2026-11-09/coverage.csv) and [machine-readable observations](../reports/demo-integration-2026-11-09/observations.jsonl).

For a controlled study, agree a versioned interface or obtain the actual rule package with revision and hashes, split authority and data-subject projections so one unresolved duty need not conceal the other, review the fact mapping and deadline semantics, and complete the existing legal-review gates. Keep Mike's hidden test cases hidden. Our eight exposed synthetic questions are integration material, not a fresh hidden validation set. The paired LLM comparison and business measurements still require actual model runs, reviewers and measured work time/costs.

Implementation approach: extend the existing standard-library package with an isolated remote diagnostic, rather than weakening the reviewed local Prolog contract or re-creating Mike's rules. The user approved implementation, live testing and updating PR #1 on 9 November 2026. Tests cover mapping, missing facts, response parsing, public substitution, held-out handling, HTTP session/CSRF, failure records and unchanged benchmark separation. This engineering review is not independent legal review.
