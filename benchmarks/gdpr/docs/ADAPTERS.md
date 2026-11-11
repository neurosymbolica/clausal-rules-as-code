# Adapters, provenance and execution limits — release 2.0

This document describes the implemented interfaces. A supported adapter is not evidence of account access, current model compatibility, legal accuracy or a completed run. Exact model IDs and rates in [the example configuration](../config/models.example.json) are deliberately unset. The [project concept](PROJECT_CONCEPT.md) explains the research design; the [data contract](DATA_CONTRACT.md) defines the records.

## Model providers and configuration

The six candidate slots are `openai`, `anthropic_opus`, `anthropic_sonnet`, `gemini`, `qwen` and `deepseek`. Opus and Sonnet use separate configurations even though both use the Anthropic transport. Qwen and DeepSeek use the `openai_compatible` provider; this does not assert that every endpoint or model in either family implements the required contract.

| Provider / slots | Implemented request and response route | Supported configuration |
| --- | --- | --- |
| OpenAI / `openai` | `https://api.openai.com/v1/chat/completions`; message text, finish reason and usage | Exact `model`, `max_completion_tokens`, optional temperature and `reasoning_effort`; JSON object mode by default |
| Anthropic / `anthropic_opus`, `anthropic_sonnet` | `https://api.anthropic.com/v1/messages`; text blocks, stop reason and usage | Exact `model`, `max_tokens`, optional temperature; configurable API header version, default `2023-06-01` |
| Gemini / `gemini` | `https://generativelanguage.googleapis.com/v1beta/models/{model}:generateContent`; candidate text and usage metadata | Exact `model`, `maxOutputTokens`, JSON response MIME type, optional temperature |
| OpenAI-compatible / `qwen`, `deepseek` | `{base_url}/chat/completions`; Chat Completions-style text and usage | Exact `model`, `token_limit_field` (`max_tokens` or `max_completion_tokens`), `json_mode`, optional temperature and allowlisted request options |

For compatible endpoints, allowed request options are `reasoning_effort`, `thinking`, `chat_template_kwargs`, `top_p`, `top_k` and `presence_penalty`. Passing an option through the adapter does not prove the selected server understands it. Native Anthropic and Gemini adapters currently require an empty `request_options`; model-specific thinking controls are not silently implemented. Models requiring a different API, payload or response format need a documented and tested adapter change before inclusion. OpenAI's public catalogue includes additional API routes; this package specifically implements Chat Completions.

Hosted endpoints must use HTTPS and contain no embedded credentials, query or fragment. HTTP is allowed only for loopback hosts `localhost`, `127.0.0.1` or `::1`. The Qwen example points to `http://127.0.0.1:8000/v1`; this is a configuration example, not an installed or running model server. The DeepSeek example points to `https://api.deepseek.com`. A hosted Qwen route or local DeepSeek server can use the same compatible interface after verification. Record the exact checkpoint, licence, quantisation, serving software and hardware separately when evaluating self-hosted operation.

Keys come only from the process environment: `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `GEMINI_API_KEY` or `GOOGLE_API_KEY`. Compatible endpoints can use an explicitly named `*_API_KEY` variable; the examples use `QWEN_API_KEY` and `DEEPSEEK_API_KEY`. A loopback server may omit a key. Credentials are sent in headers, and redirects are refused. The package does not load a key file or `.env` automatically. Public run configuration includes the environment-variable **name**, never its value.

The transport uses the Python standard library, a 90-second request timeout and no automatic retry. It does not enable provider browsing, external tools or file connectors. It sends the prompt text supplied by the runner. Prompts and raw response bodies are retained locally; authorization headers are not. The bundled cases are synthetic. A deployment involving other data needs its own documented data-flow and service assessment.

A completed HTTP request is not necessarily a valid benchmark answer. Truncation, refusal, an unexpected finish reason, invalid JSON or a response that fails the schema is unsuccessful. Provider-side model identity and raw usage remain part of the evidence. Known returned model revisions are preserved; a change within a controlled pipeline fails that record, and different known revisions cannot be pooled in a matched study cohort. Missing returned version identifiers remain unknown. Non-finite JSON numbers are rejected before persistence; invalid model JSON retains the paid call evidence. Mock fixtures test transport behaviour; they do not establish live compatibility or legal performance.

## Matched extraction and engine evidence

The runnable arms are `llm_text`, `llm_control`, `llm_python`, `llm_prolog`, `python_rules` and `prolog_oracle`.

`llm_text` receives the public case and relevant full statutory articles and makes one answer call. The three matched conditions share one model extraction for each case/repetition within a run. The extraction prompt contains the narrative, law, question IDs, rule identifiers, documented field definitions and a fact template whose values are all `null`. It does **not** supply the case's normalised oracle values or the reference answers. Extraction must preserve question IDs, rule names and fact keys; known input types are checked and missing values remain `null`.

The runner reuses that extraction for `llm_control`, `llm_python` and `llm_prolog`. Their final `SYSTEM`, case, law and extracted-fact blocks are identical. Only the delimited `ENGINE EVIDENCE` slot differs: no engine prediction in the control, Python output in the Python condition, and a genuine Prolog result in the Prolog condition. The common instruction asks the model to assess engine evidence against the narrative and legislation. Engine evidence may be wrong; the final answer is still evaluated end to end.

`python_rules` and `prolog_oracle` receive the supplied normalised facts directly. They are diagnostic oracle-style conditions, not natural-language competitors. The Python baseline is authored within this project and is not independent legal validation. The gold file is hashed for provenance but its labels are not read into inference prompts.

The exact extraction is shared only inside one run for a given model and case/repetition. Separate invocations do not automatically share it. For a matched comparison, run the matched arms together. Record `extraction_sha256`, final prompt hash, source and case hashes, configuration hash and code versions. A later review cannot repair unmatched inputs merely by giving the runs similar names.

## Usage, billed cost and attributable cost

OpenAI-style prompt usage already includes cached input; completion usage already includes reasoning where the provider reports it that way. Anthropic's uncached, cache-read and cache-write input counts are added to total input. Gemini candidate and thought tokens are added to output cost, while thought text is excluded from the answer. Raw counters are retained. Compatible servers must be checked for the same semantics; format similarity is not proof of identical billing.

Prices are explicit USD amounts per million tokens, with separate input, output, cache-read and cache-write categories. The configuration requires a price source, `checked_at`, `valid_until`, and all four nonnegative rate fields before live requests. Zero is appropriate only for a genuinely uncharged category. The optional `max_input_tokens_at_price` bounds the configured tier. Missing or contradictory usage yields an unknown cost, not a fabricated zero.

The local preflight reservation uses prompt UTF-8 bytes plus 4,096 overhead tokens, the largest configured input/cache rate, and the output-token limit. It is a conservative estimate, not a provider-enforced spend cap or an authoritative tokenizer. Live mode requires an explicit positive budget. If an attempted request has unknown billing, subsequent paid requests are blocked. Provider account limits remain separate from this local guard.

Each call has a `call_id`; copies of a shared extraction keep that ID and mark `reused=true`. Row `cost_usd` attributes the full extraction plus synthesis cost to that arm as a standalone deployment alternative. Row `billed_cost_usd` counts only requests first executed for that row. Manifest `actual_api_calls`, token totals and `total_cost_usd` count shared calls once. Do not sum attributed row costs to reconstruct the experiment bill. `known_cost_usd` remains available if one charge is unknown; `total_cost_usd` then remains `null`.

Row wall-clock latency includes its actual execution, so reused extraction reduces the observed time for subsequent arms. `attributed_api_latency_seconds` includes the shared extraction time for standalone comparison. Hosting, licences, formalisation, maintenance and human review are outside token accounting and belong in the [economic analysis](BUSINESS_CASE.md).

Official interface references retained from the interface review are [OpenAI Chat Completions](https://developers.openai.com/api/reference/resources/chat/subresources/completions/methods/create), [Anthropic Messages](https://platform.claude.com/docs/en/api/messages), and [Gemini GenerateContent](https://ai.google.dev/api/generate-content?hl=en). Pricing references are [OpenAI](https://developers.openai.com/api/docs/pricing), [Anthropic](https://platform.claude.com/docs/en/about-claude/pricing), [Gemini](https://ai.google.dev/gemini-api/docs/pricing), and [DeepSeek](https://api-docs.deepseek.com/quick_start/pricing/). The dated [market evidence register](../sources/market-evidence.json) documents the separate public-source research. No historic rates are adopted automatically.

## Genuine Prolog bridge

[The Prolog manifest example](../config/prolog.example.json) is intentionally incomplete. No GDPR Prolog rulebase is bundled. Both Prolog arms remain blocked until the operator supplies actual reviewed modules and a trusted local bridge.

The manifest declares `legal_regime: "GDPR"`, `source_url`, `source_revision` and `engine`. Its `independent_review` must name a reviewer and review date with status `approved`. `artifacts` maps actual files to SHA-256 hashes, including at least one `.pl` or `.clausal` file. `supported_rules` must cover every subquestion of a task. `command` is an argument list beginning with an existing absolute executable path. The bridge is a trusted operator-supplied program; the runner does not construct shell commands or Prolog code from model output.

The operator must include every rule-bearing bridge/module dependency in the artifact record. The adapter verifies declared files, not the completeness of the dependency list or the authenticity and legal competence of a named reviewer. It does not isolate the bridge from the operator's computer. Execution uses the manifest directory and a 30-second timeout.

The bridge receives one JSON object on standard input:

```json
{"schema_version":1,"case_id":"F01","mode":"oracle","questions":[{"id":"q1","rule":"territorial_scope","facts":{"eu_establishment_context":true,"offers_to_people_in_eu":false,"monitors_behaviour_in_eu":false}}]}
```

`mode: "model_extraction"` uses only extracted facts from the matched pipeline. Successful standard output is an object containing `status: "ok"`, a `prediction` matching [the response contract](DATA_CONTRACT.md), and optionally `trace`. Lack of coverage should return `status: "blocked"`. Nonzero exit, timeout, malformed JSON or an incomplete answer is a failure. A bridge must map this contract to the real engine's predicates; no fictional predicate API is assumed.

Legal approval of a Prolog module and equivalence to the Python baseline are separate questions. `python_equivalence_review` records an approved reviewer/date, the Python rule-file hash, case-dataset hash and scope mapping. The runner marks `engine_scope_alignment` pending unless review metadata and the relevant hashes match. H4 requires reviewed equivalence before an engine-specific claim; mere executability is insufficient. Scope mapping must explain legal conditions, exceptions, unsupported cases and unknown-value semantics. These declarations are evidence pointers, not an independently authenticated certification.

The recorded upstream inspection concerns the public [clausal-rules-as-code repository](https://github.com/neurosymbolica/clausal-rules-as-code). [Its inspection record](../sources/upstream-check.json) preserves the inspected revision and evidence. A filename or comment mentioning GDPR does not activate a module. Private or unpublished work was not inspected; no upstream rule program was executed or copied into this package.

## Exploratory remote demo adapter

[DEMO_INTEGRATION.md](DEMO_INTEGRATION.md) documents the separate `demo-run` and `demo-coverage` commands, observed web-form interface, supplied-fact mappings and live evidence. This path creates exploratory observations only and does not satisfy or bypass the reviewed Prolog contract above.

## Legal-product exchange

Harvey, Legora and Noxtua use manual product-export/product-import bundles. Official APIs may exist; this release neither assumes access nor implements a private undocumented endpoint. Harvey's [API permissions](https://developers.harvey.ai/api-reference/authentication) and Legora's [order-form-dependent APIs](https://legora.com/legal/security-measures) illustrate the distinction.

An export creates full common prompts, a hashed manifest and response templates marked `not_run`. The operator uses an actual permitted account, a fresh session per task and captures the unedited answer. Completed captures require operator, product version/build or explicit `not_disclosed`, timestamp with timezone, session ID, feature settings, submitted prompt and source-control declaration. Optional evidence references point to retained exports/screenshots without secret links. Unknown timing or incremental cost stays `null`; licences are accounted for separately.

`controlled_inputs` means the submitted full prompt matches the export hash. It does **not** establish that the product ignored internal sources or retrieval. `uncontrolled_inputs` preserves the actual submitted prompt when the product cannot receive the standard input unchanged. Both remain black-box product comparisons, not causal tests of Prolog. The importer checks the full exported task set and hashes, fixes repetition zero, preserves `blocked`/`failed` cases, and maps unrun entries to blocked records with reasons. Failed attempts retain any supplied response text, capture metadata, timing and cost without gaining a successful prediction. The original capture file and export manifest are copied into the imported run for audit. It verifies consistency, not independent authenticity of operator reports.

Imported predictions are `{"text":"verbatim answer"}`. They can receive human review but are not silently converted to structured decision labels or scored semantically by the importer. A product import executes no API requests. New run directories are immutable outputs; no successful-looking answers are generated for unavailable products.

## Source corpus and legal version

The corpus comes from the EU Publications Office/CELLAR, CELEX `02016R0679-20160504`. The source XML records consolidation/last-modification metadata `20180523`, including its recorded corrigenda. It is an officially supplied consolidated documentation text; the authentic Official Journal versions determine legal authority. The machine extraction is an evaluation working copy.

[The law manifest](../sources/law-manifest.json) records the source URL, fetch time, Formex metadata and hashes of the XML, article JSON and article text. `LawCorpus` checks these hashes. All 99 complete English articles are available; each case selects its declared full articles in numerical order. The identical selected text is supplied across the model conditions. The original XML includes recitals, but recitals are not silently injected into prompts. There are no implicit network source updates during a run. A source change requires legal review and a new recorded release/freeze.
