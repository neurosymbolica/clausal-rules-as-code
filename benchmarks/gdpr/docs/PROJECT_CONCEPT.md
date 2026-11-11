# Does formal legal reasoning improve GDPR advice?

**Project concept for Mike — 6 November 2026 — release 2.0**

This project asks whether combining a strong language model with a reviewed GDPR rule system produces better legal answers than the same model working from the same legal sources without that rule system, and whether any improvement is worth its full cost. Prolog is a candidate technology whose contribution must be measured. The project does not assume that formal reasoning guarantees correct legal advice, that a particular model is best, or that there is already a commercially viable product.

The study contains **exactly 30 GDPR tasks: 20 focused tasks and 10 complex business cases with five subquestions each, giving 70 subquestions in total**. These are synthetic evaluation materials, not client matters. Their reference answers are provisional until independent GDPR specialists review them. The accompanying software supports controlled model comparisons, rule diagnostics, human review, product answer import and economic analysis. Availability of a software path is different from evidence that a model, product or legal rule module has actually been tested.

The immediate decision is whether there is a credible, bounded reason to continue this research and, separately, whether a specific workflow deserves a customer pilot. There are no real model or product results, independent gold labels, customer interviews or demonstrated savings in this release. The [business analysis](BUSINESS_CASE.md) develops the commercial argument and its evidence gaps; the [evaluation protocol](PROTOCOL.md) defines the operational procedure. Public-source findings are recorded in [the evidence register](../sources/market-evidence.json).

## 1. Model and competitor selection

The comparison must include strong alternatives. The model candidates are an accessible OpenAI GPT-6-family configuration, Anthropic Claude Opus **and** Claude Sonnet, Google Gemini Pro, and Qwen and DeepSeek alternatives through compatible hosted or self-hosted deployments. Opus is an explicit high-end comparator; Sonnet provides a separate performance-and-cost comparison. Qwen and DeepSeek test whether formal rules can make a less expensive or locally operated configuration useful. An open-weight model is not automatically inexpensive to operate: hardware, utilisation, deployment work and support belong in its cost assessment.

| Candidate | Role in the study | What must be established before a run |
| --- | --- | --- |
| OpenAI, GPT-6 family | Strong general-model comparator and proposed primary model family | Account-accessible exact model ID, supported endpoint, reasoning settings, price and retention configuration |
| Anthropic Claude Opus | High-end comparison from a second model family | Exact version, API entitlement, thinking settings, token accounting and price |
| Anthropic Claude Sonnet | Separate efficiency comparison | Exact version and the same configuration evidence required for Opus |
| Google Gemini Pro | Independent model family | Exact accessible stable or preview version, service route, billing treatment and configuration |
| Qwen | Hosted or self-hosted alternative | Exact weights or endpoint, licence, quantisation, serving stack, hardware and measured cost |
| DeepSeek | Hosted or self-hosted alternative | Exact weights or endpoint, licence, reasoning mode, alias resolution and measured cost |
| Harvey, Legora, Noxtua | Complete legal-product comparisons | Actual account entitlement, product configuration, source controls, export permission, version evidence and price |
| LLM with reviewed Prolog rules | Investigated architecture | Genuine GDPR module, provenance, reviewed coverage, runtime and trace output |
| LLM with Python rules | Engine control | Equivalent legal coverage and input semantics to the Prolog condition |

Official provider documentation supports these candidate families and deployment routes, but cannot establish what this project can access. OpenAI documents its [model catalogue](https://developers.openai.com/api/docs/models); Anthropic separately lists [Opus and Sonnet](https://platform.claude.com/docs/en/models/overview); Google describes [Gemini Pro](https://deepmind.google/models/gemini/pro/). The Qwen team's [Qwen3 release](https://qwenlm.github.io/blog/qwen3/) and the [DeepSeek-R1 repository](https://github.com/deepseek-ai/DeepSeek-R1) demonstrate particular open-weight releases, not the licence or suitability of every later checkpoint. The [DeepSeek API documentation](https://api-docs.deepseek.com/quick_start/pricing/) also illustrates why an API alias cannot be treated as an immutable model version.

The final model selection, prices and runtime settings will be frozen **before viewing evaluation answers**. Public list prices are source material for that freeze, not configured project prices. An inaccessible candidate remains a visible blocked or not-run entry. Replacing a candidate after seeing results would require an explicit protocol amendment; selecting the most favourable completed comparison is not a valid primary analysis.

Harvey, Legora and Noxtua are products with retrieval, interfaces, workflows and deployment arrangements, rather than interchangeable base models. Harvey documents [legal knowledge sources](https://help.harvey.ai/topics/knowledge-sources); Legora describes [research using legal sources and an ontology](https://legora.com/product/legal-research); Noxtua documents [research, document review and drafting](https://academy.noxtua.com/posts/getting-started). These are vendor descriptions, not independently verified accuracy findings. Their inclusion prevents the research from treating a bare model as the only alternative available to a legal team.

## 2. Scientific hypotheses and the claim each experiment can support

The primary outcome is **binary legal correctness of the complete task**, determined by human reviewers. A complex task is correct only if all five subquestions are legally correct and none contains a severe error. The primary comparison uses the same model in the matched control and Prolog conditions, on the prespecified first repetition, numbered `repeat=0`.

Let \(p_P\) be task accuracy for `llm_prolog` and \(p_C\) accuracy for `llm_control`. The directional primary hypotheses are:

\[
H_0:p_P\leq p_C,\qquad H_1:p_P>p_C.
\]

This is a test of whether enabling a reviewed engine improves the controlled pipeline. It does not by itself establish that Prolog is the best implementation language, that every GDPR workflow benefits, or that the result generalises to other legal systems.

Four further hypotheses address why an improvement might occur and whether it matters. They remain exploratory in this 30-task study, unless a future protocol explicitly defines a larger confirmatory family before any relevant outcomes are examined.

| Hypothesis | Null and directional alternative | Intended analysis and limitation |
| --- | --- | --- |
| **H2 — Complexity** | H0: the Prolog advantage is no larger for complex tasks; H2: it is larger | Compare the treatment-minus-control effect in the ten complex tasks with that in the twenty focused tasks; report uncertainty and task-clustered subquestion diagnostics. Five-question all-correct scoring makes complex tasks harder by construction, so this is not a pure measure of intrinsic reasoning complexity. |
| **H3 — Severe errors** | H0: Prolog does not lower the severe-error rate; H3: it lowers it | Compare paired task-level severe-error indicators and show counts, absolute change and relative reduction. Relative reduction is undefined when the control has no severe errors. |
| **H4 — Engine control** | H0: Prolog is no more accurate than the matched Python engine; H4: it is more accurate | Compare `llm_prolog` with `llm_python` only after legal coverage, exception handling and unknown-value semantics have been matched. Equal accuracy may still leave a maintainability question, which requires separate work-time evidence. |
| **H5 — Economics** | H0: the proposed system offers no positive saving per correctly handled case; H5: it offers a positive saving | Combine reviewed correctness, observed handling time and full costs. Show assumptions, uncertainty and sensitivity; a speculative error-loss allowance cannot substitute for measured savings. |

A one-sided exact paired McNemar test, equivalently a binomial test on discordant pairs, evaluates H1. The report includes both discordant counts, the accuracy difference, a paired confidence interval and the actual number of eligible pairs. Repeated runs assess robustness; they do not create additional independent cases. The 70 subquestions are nested within 30 tasks and must not be presented as 70 independent observations.

One model configuration must be designated as primary before the runs. Results for all other planned model families remain visible. Any additional confirmatory family needs a prespecified multiplicity correction such as Holm adjustment; exploratory comparisons are labelled accordingly. Missing, blocked and unreviewed cells have no legal-accuracy value and no invented p-value. Execution failures are reported separately, with an explicitly labelled sensitivity analysis that treats eligible failed executions as unsuccessful where the protocol permits.

## 3. Proposed success criteria

The following thresholds are proposed decision criteria, not established scientific or commercial facts. They combine a material accuracy gain, safeguards on error types and evidence of economic value.

| Criterion | Proposed target | Interpretation |
| --- | --- | --- |
| End-to-end task accuracy | At least **+5 percentage points** against the best comparable non-Prolog LLM configuration | Report the matched causal comparison and the strongest eligible deployment alternative separately; do not choose the primary comparator after results are known. |
| Severe legal errors | At least **30% relative reduction** | Always show absolute counts and uncertainty; a zero-error control makes this ratio unavailable. |
| Exceptions and boundary cases | At least **+10 percentage points** | Use question tags frozen before inference, with task-level clustering and the denominator disclosed. |
| Missing information | At least **95% correct handling** | Correctness means the appropriate qualified decision or abstention and identification of material missing facts, not indiscriminate refusal. |
| Primary statistical test | One-sided **p < .05** | Applies to the prespecified binary paired comparison, alongside effect size and uncertainty. |
| Economics | **Positive saving per correctly handled case** | Includes formalisation, integration, maintenance and human review; must survive plausible sensitivity assumptions. |

Thirty tasks provide a bounded pilot, not a precise estimate of small effects. With all 30 pairs present, one net additional correct task changes accuracy by about 3.33 percentage points. A five-point target therefore cannot be interpreted as a finely measured effect in this sample. Subgroup denominators are smaller still. Meeting a point-estimate threshold does not establish that the population effect exceeds it; failing to achieve significance does not establish equivalence. The report must show this uncertainty rather than turn every result into a simple pass or fail.

A statistically significant but small improvement may not justify a new operational layer. Conversely, avoiding a small number of severe errors may matter substantially, but its monetary value cannot be inferred from statutory maximum fines. Both quality and cost evidence are needed for the commercial decision.

## 4. Independent legal evaluation

Two independent lawyers with relevant **GDPR expertise** will first review the reference answers and then assess system outputs independently under a frozen rubric. A third qualified lawyer will adjudicate disagreements with a written reason. An independent analyst will produce the statistical report. **All these roles remain unassigned** until real people accept them; a template is not an appointment and a provisional reference is not an expert-approved gold standard.

The reviewers need the case, question, relevant legal materials and reference reasoning, including acceptable alternatives and unresolved facts. System identity, provider, arm, cost and run metadata are removed from the review bundle and retained in a separate mapping. Stylistic clues may still weaken blinding, so blinding is a documented procedure rather than a guarantee. Case authors and rule authors should disclose their involvement and should not be the sole arbiters of the system they developed.

Each subanswer receives five scores from zero to two:

| Dimension | What the reviewer assesses |
| --- | --- |
| Legal decision | Whether the conclusion answers the actual question correctly |
| Application of conditions | Whether the material prerequisites are applied to the facts |
| Exceptions | Whether relevant exceptions and limitations are handled |
| Legal bases | Whether the authorities are accurate and support the conclusion |
| Uncertainty | Whether missing information and defensible alternatives are treated appropriately |

The ten-point total is diagnostic. Reviewers also make the separate binary legal-correctness judgment and record severe errors. **A severe legal error vetoes correctness regardless of the prose or rubric total.** The task-level primary outcome then requires every subanswer to be correct. The report includes reviewer agreement and Cohen's kappa where calculable, adjudication reasons, and the individual error patterns. The two ratings on one answer are not two independent test observations.

Automated comparison is useful for decision codes and other genuinely unambiguous outputs, but cannot establish that an explanation is legally correct. In particular, agreement between the supplied Python rules and provisional labels is an internal consistency check: both were created within this project. An LLM-as-a-judge may eventually flag suspicious answers for inspection, but is not the final authority and has not been run as an independent legal evaluator here.

## 5. Three complementary experiments and the oracle diagnosis

### Experiment A: the controlled technology comparison

For each model, task and repetition, one extraction step produces structured facts from the **case narrative**. The same extracted facts are reused by `llm_control`, `llm_python` and `llm_prolog`. All three receive the same relevant complete GDPR articles, extraction schema, final system instruction and answer template. Only the clearly delimited engine-evidence slot differs. No supplied oracle facts or provisional gold answers enter these model conditions.

| Arm | Input and behaviour | Purpose |
| --- | --- | --- |
| `llm_text` | Case narrative and frozen relevant articles; one model answer | Simple deployment baseline, including its lower orchestration cost |
| `llm_control` | Shared model-extracted facts, original case and articles; no engine evidence | Matched control for the effect of adding engine evidence |
| `llm_python` | The same extraction and synthesis with Python-engine evidence | Tests whether ordinary rules deliver the same benefit |
| `llm_prolog` | The same extraction and synthesis with reviewed Prolog-engine evidence | Tests the contribution of the proposed formal engine |
| `python_rules` | Supplied normalised facts sent directly to the Python rules | Diagnostic oracle-style baseline without natural-language extraction |
| `prolog_oracle` | Supplied normalised facts sent directly to genuine reviewed GDPR Prolog rules | Diagnostic test of rule behaviour under idealised input |

The extraction control matters: comparing a multi-stage Prolog pipeline only with a one-call LLM would confound formal reasoning with additional prompting, structured intermediate facts and extra computation. `llm_text` is retained because a buyer may still prefer that simpler deployment. The causal claim belongs to the three matched conditions, and remains limited to the complete engine-assisted pipeline tested.

The Python and Prolog rule coverage must also match before H4 is interpretable. A broader legal specification can outperform a narrower one without showing an advantage of its implementation language. Both engines must identify unsupported inputs and preserve unknown facts. A missing fact must not silently become false through a closed-world assumption. Rule revisions, statutory versions, source hashes and interface versions are frozen together.

Genuine reviewed GDPR Prolog modules are a prerequisite for either Prolog arm. The package does not create substitute Prolog rules and label them as Mike's work. Missing modules leave both Prolog arms blocked. The supplied normalised inputs already resolve some legally evaluative issues through explicit assumptions; oracle agreement therefore cannot establish reliable fact-finding or independent legal correctness.

The oracle comparison diagnoses failure. If `prolog_oracle` fails on reviewed structured inputs, examine the formalisation, coverage, input contract and reference answer. If it succeeds but `llm_prolog` fails, trace the extracted facts, engine invocation and final explanation. A correct engine result can still be distorted by the answer-generating model. If only oracle performance is strong, the next work is extraction and integration, not a claim of end-to-end superiority. A claim of “100% accuracy” must identify its dataset, input assumptions and review status and cannot be generalised from a perfect internal consistency score.

### Experiment B: comparison with real products

Harvey, Legora and Noxtua receive the same tasks through their genuinely available product interfaces. The release uses human-operated export/import bundles with verbatim answers and reproducibility metadata. This is a practical evaluation route, not a claim that the vendors lack APIs: Harvey publishes [API authentication and entitlement documentation](https://developers.harvey.ai/api-reference/authentication), and Legora describes [APIs subject to an agreed order form](https://legora.com/legal/security-measures).

The operator records product edition, visible version or release evidence, date, region, mode, enabled sources, uploaded source files, prompt text, interactions, elapsed time, failures and export evidence. An undisclosed internal model version remains undisclosed. If sources cannot be restricted to the frozen material, the result is explicitly a realistic product comparison. Uploading the same statute does not prove that a product ignored its own retrieval system or other knowledge. No product API, account access or price is assumed.

These product results can show how the tested configurations perform on this benchmark. They cannot identify Prolog as the cause of a difference between products. The [research by Magesh and colleagues](https://law.stanford.edu/publications/hallucination-free-assessing-the-reliability-of-leading-ai-legal-research-tools/) supports the need for empirical assessment of legal research systems; its older systems and different legal tasks do not establish current Harvey, Legora or Noxtua performance.

### Experiment C: economic comparison

The economic analysis compares complete workflows, including the existing human process, a general LLM with review, a Python-rule solution, the Prolog solution and any tested legal product. It includes API charges, licences, hosting, formalisation, integration, initial legal validation, maintenance, human handling, review and rework. Optional error-risk assumptions are shown separately from observed operating costs. A shared extraction call is charged once in the experiment bill, while each deployment alternative receives its own attributable extraction cost when estimating standalone operation.

The principal outputs are annual total cost, cost per correctly handled case, cash and quality-adjusted break-even, and sensitivity to volume, correctness and review time. Unknown cost or correctness inputs remain unknown. The [business analysis](BUSINESS_CASE.md) supplies the formula, an explicitly illustrative example and the customer evidence required to replace its assumptions.

## 6. The fixed GDPR benchmark and its limits

The twenty focused tasks cover territorial scope, legal bases, consent and withdrawal, special-category data, access and other data-subject rights, joint controllers, processors, security, breach notification, impact assessments, DPO requirements, international transfers, automated decisions and the statutory fine framework. The ten complex tasks combine such issues within coherent organisational scenarios. Exceptions, thresholds, deadlines, missing information and interactions between obligations are present within these tasks; they are not additional cases.

The study is grounded in the [GDPR text supplied through official EU sources](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32016R0679), with source provenance in the package. Relevant full articles are identical across model arms. The current input bundle does not silently expand to national law, case law or regulator guidance. Those sources may be necessary in a real workflow, which is one reason this benchmark cannot certify operational legal compliance. Any source expansion would require explicit review and a new freeze before comparison.

All 30 tasks currently exist as exposed synthetic materials. They must not be called a hidden or independently authored test set. Experts may review and correct this same fixed set before the final freeze, with a change record and a new version. Results from cases used to tune prompts or rules must be labelled development results. A later genuinely hidden study would require separate authorisation and fresh independent materials; this release neither adds tasks nor promises a larger benchmark.

Freezing case text, provisional or reviewed references, question tags, sources, prompts, model configuration and rule versions makes a run interpretable. It does not remove correlated topics, author influence, benchmark contamination or the gap between synthetic facts and real intake documents. Those limits belong in any communication of the findings.

## 7. Decision after the benchmark

The decision has two stages: first establish whether a technical benefit exists under the stated conditions, then test whether a reachable buyer benefits from adopting it. The second stage cannot be replaced by a favourable benchmark result.

| Observed evidence | Decision |
| --- | --- |
| Material, statistically supported gain against strong matched LLMs, fewer severe errors and robust positive economics | **Conditional Go** to a bounded customer pilot; a commercial launch still needs customer and deployment evidence |
| Improvement only with smaller or cheaper models | Assess whether lower model cost survives hosting, integration and review costs; pursue only a demonstrated cost advantage |
| Improvement confined to a reproducible complex or exception-heavy workflow | **Niche Go** for that defined workflow, with claims restricted to its coverage |
| Matched Python rules achieve equivalent quality | No specific Prolog advantage demonstrated; choose the simpler or cheaper maintainable implementation unless measured lifecycle evidence favours Prolog |
| Strong oracle results but weak end-to-end results | Improve extraction, unknown handling and answer synthesis before further product claims |
| No material benefit after fair controls and adequate review | **No-Go** for the proposed Prolog-specific business thesis |
| Wide uncertainty, few eligible pairs or unresolved reviewer disagreement | **Inconclusive**; report the limitation and seek approval for any subsequent study rather than declare success or silently increase scope |
| Missing reviewed Prolog modules, approved references, reviewer appointments or model access | **Not evaluable** for the affected comparison; preserve the blocker in the matrix |
| Technical gain but no buyer willingness, sufficient volume or positive full-cost case | **Commercial No-Go or redesign**, even if the research result is interesting |

The strongest current commercial hypothesis is a reviewed GDPR obligation-checking component inside an existing privacy workflow, where explicit inputs, exceptions and missing facts can be audited. It is not yet a validated market position. The work completed here makes that hypothesis testable and the proposed experiment reviewable. **Desk analysis is complete; technical evaluation and commercial validation remain pending.**
