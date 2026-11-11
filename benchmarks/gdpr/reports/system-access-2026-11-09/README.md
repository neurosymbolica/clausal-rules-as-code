# Direct system access: six GDPR narratives

**The conversational agent is reachable, but all six GDPR cases receive an out-of-scope response. No substantive GDPR system-versus-model comparison was possible.** This is an observed coverage/integration limitation, not a legal-accuracy defeat or evidence that an undisclosed deployment lacks GDPR support.

## Correction to the previous experiment

The [earlier four-model pilot](../edge-pilot-2026-11-09/README.md) tested **LLMs supplied with rule-engine outputs**, compared with those same LLMs supplied with legislation or RIS decisions. It did **not** evaluate Mike's own end-to-end agent against standalone models. Its limited supplement effect must not be described as the performance of Mike's whole system. Original scores, inputs and frozen protocol remain unchanged.

## What is actually exposed

Checked live on 9 November 2026, approximately 14:39 UTC, at the already-authorized private demo origin (not published):

| Surface | Observed purpose | Evidence |
| --- | --- | --- |
| `/demo/` | Conversational legal reasoning agent. The page says an LLM translates natural language into logic queries, then a symbolic engine answers. Advertised chat scope: five Singapore-law areas. | [Page text](demo.txt) |
| `/demo/api/send` | Real chat form endpoint discovered in the served frontend JavaScript; accepts a `message` with session and CSRF protection. | [Six original requests/responses](observations/) |
| `/demo/books/` | GDPR structured-fact test books. Their explanation says no LLM writes answers, reasons or citations; AI was used upstream to draft the formal rules. | [Explanation](demo-books-how.txt) |
| `/demo/query-types/` | Worked engine examples, including EU examples and an advanced GDPR Article 6 example. This broader gallery is not evidence of GDPR support in the free-text chat. | [Gallery text](demo-query-types.txt) |
| `/demo/api/examples` | Examples returned by the chat interface; Singapore-law domains. | [Returned example catalogue](demo-api-examples.txt) |

The shared JavaScript also contains LLM prose/gallery controls. Their presence does not establish that these six free-text GDPR narratives can reach a GDPR-capable agent. No undocumented endpoint guessing, protected-case bypass or access-control changes were used. The deployed model ID, whether an LLM actually executed during each rejection, tokens, costs and rule revision are not exposed by these responses and remain unknown.

## Direct submissions and observations

Each case was submitted once, sequentially, through the actual chat endpoint in a **fresh cookie session**. We sent the exact title, narrative and two questions from the previous six-case dataset, prefixed with a request to apply EU GDPR and Austrian DSG where relevant. No operator-normalized facts, rule outputs, gold answers or RIS material were sent. Every request and full wire response is preserved. The wire response includes the echoed user text; it is not an assistant answer.

| Case | HTTP | Assistant response category | Answered subquestions | Legal quality score |
| --- | --- | --- | --- | --- |
| E01: encrypted backup / uncertain keys | 200 | Out of scope | 0/2 | null |
| E02: suspicion versus awareness | 200 | Out of scope | 0/2 | null |
| E03: public HIV reports / deletion | 200 | Out of scope | 0/2 | null |
| E04: groups A/B / communication banner | 200 | Out of scope | 0/2 | null |
| E05: Austrian hospital / DPO and fines | 200 | Out of scope | 0/2 | null |
| E06: conflicting risk flags / blackmail | 200 | Out of scope | 0/2 | null |

All six return the same assistant statement:

> I can only answer questions covered by these formalized rulebases. Try one:

It is followed by five Singapore-law suggestions and `(case none)`. This is a successful HTTP exchange with an explicit scope rejection, not a server failure, hidden correct answer or zero-point legal opinion. Useful GDPR answer coverage is **0/6 cases (0/12 questions)** on this reachable chat configuration. Legal accuracy is **not evaluable**. No paired accuracy test, superiority ranking or p-value is calculated.

The previous standalone model results remain available, but those models received statutory texts, normalized facts and a batch of six cases. These direct probes supplied raw narratives individually to a service with its own sources. Consequently, even a substantive response would require a clearly specified matched rerun before a controlled head-to-head claim. We did not spend additional model calls to compare against six scope rejections.

## What Mike needs to enable

To complete the requested direct comparison, we need a GDPR-enabled natural-language entry point (or confirmation of how to select GDPR on this deployment), covering these synthetic cases, with model/rule version and supported scope identified. If the agent asks clarification questions, answers must come only from the frozen narrative; unknowns stay unknown. Then rerun all systems under a matched narrative-only protocol, with a separate matched-source condition if the service permits it. Use independent legal review for the resulting answers.

This report is the completed access/coverage check; the substantive end-to-end GDPR comparison remains **blocked: GDPR routing is not exposed by the tested agent**. Nothing here establishes that Mike has no such system elsewhere.

## Evidence and verification

- [Request/response manifest](observations/manifest.json): UTC timestamps, status, latency and SHA-256 hashes; no cookies, CSRF tokens or private origin.
- [Discovery manifest](discovery.json): fetched relative routes, HTTP status and raw-page hashes; text extracts omit session metadata.
- [Outcome records](outcomes.json): explicit null accuracy and coverage classification.
- [Collector](probe.py): archived recipe; requires an authorized origin in `GDPR_DEMO_BASE_URL` and a new output directory. Live execution submits synthetic cases and may consume provider quota.
- `python3 verify.py` checks narrative preservation, response hashes, exact rejection and missing case state for all six observations. It makes no network calls.

This addition changes documentation and adds evidence only. The core 30-task/70-question benchmark, provisional gold, previous immutable model outputs and formal Prolog gates remain unchanged. The earlier ZIP does not contain this addition.
