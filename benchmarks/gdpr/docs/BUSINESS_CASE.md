# Business case: a reviewed GDPR decision-support component

**Desk analysis completed 6 November 2026. Commercial validation pending.**

There is a plausible reason to test a narrow GDPR decision-support workflow, but no evidence yet for a commercially successful Prolog product. Public sources establish that legal AI vendors already offer research, document workflows and security controls. GDPR creates structured obligations that can sometimes be checked against explicit facts. Neither observation proves that a buyer needs another system, that Prolog improves decisions, or that willingness to pay exceeds the cost of delivery.

The recommended next commercial hypothesis is **a reviewed obligation checker for privacy specialists handling recurring data-subject requests**, initially covering intake completeness, applicable response steps, deadlines and explicitly modelled exceptions. It would produce a reviewable draft and a record of the facts and rules used. A qualified professional would remain responsible for the legal decision and any communication. External DPO services and established in-house privacy teams are candidate buyers, not identified customers. A breach-notification assistant is a plausible later workflow, but its urgency, disputed facts and severe consequences make it a more demanding first deployment.

This recommendation follows from the fit between bounded obligations and auditable inputs, not from completed market interviews. The [project concept](PROJECT_CONCEPT.md) describes the fixed 30-task, 70-subquestion GDPR study that can test the technical assumptions. It cannot estimate the size of the market or validate a purchase decision. The [source register](../sources/market-evidence.json) separates official legal material, vendor assertions, research findings and unresolved commercial questions.

## What the evidence currently supports

The GDPR provides an identifiable legal substrate. Article 12 sets procedural requirements for responding to data-subject requests; Articles 15–22 contain rights whose conditions and exceptions must be assessed. Articles 33 and 34 distinguish breach notification duties. These structures make obligation checking worth investigating, while leaving substantial legal judgment outside a simple rule system. The source is the [official GDPR text](https://eur-lex.europa.eu/legal-content/EN/TXT/?uri=CELEX:32016R0679), rather than a claim about how frequently organisations struggle with it.

The EDPB's [final Guidelines 9/2022](https://www.edpb.europa.eu/documents/guideline/guidelines-92022-on-personal-data-breach-notification-under-gdpr_en) and its [full guidance](https://www.edpb.europa.eu/system/files/documents/2023-04/edpb_guidelines_202209_personal_data_breach_notification_v2.0_en.pdf) provide relevant interpretation for a future breach workflow. Their existence is evidence that operational interpretation matters; it is not proof of demand for this product. The current controlled benchmark supplies its frozen statutory articles, not an unrecorded expanded guidance corpus.

Independent research has demonstrated the need to measure legal AI outputs rather than rely on vendor accuracy claims. [Magesh and colleagues' preregistered study](https://law.stanford.edu/publications/hallucination-free-assessing-the-reliability-of-leading-ai-legal-research-tools/) evaluated particular legal research products and found remaining errors despite retrieval. Its tested systems, versions and largely US legal research tasks differ from this project. It does **not** provide current GDPR accuracy figures for Harvey, Legora, Noxtua or the proposed hybrid system.

No customer conversations, observations of a buyer's work, price quotations, signed pilots, independent security assessments or paid evaluation calls were conducted for this analysis. Public marketing pages do not fill those gaps. Financial figures below are illustrative assumptions, not quotations or forecasts.

## The competitive alternatives

The relevant buying decision is how to complete a privacy workflow reliably at an acceptable total cost. “Prolog versus a language model” is only one part of that decision.

| Alternative | Publicly documented capability or working hypothesis | Implication for the proposed product |
| --- | --- | --- |
| Existing lawyer/DPO process with templates, spreadsheets and checklists | A workflow hypothesis to observe in discovery; no customer baseline has been measured | May already be sufficient and cheaper at low volume. The product must beat actual review effort, not an invented inefficient baseline. |
| General LLM with supplied sources and professional review | Official APIs support configurable model use; legal quality on this workload is unknown | Fast to deploy and improve. It is the closest inexpensive substitute and must receive strong prompts and the same sources. |
| Ordinary Python rules or a decision table with a form | The package has a bounded Python baseline; production quality and maintainability are unproven | May deliver the same checks with less operational complexity. A language-specific advantage must be earned. |
| Harvey | Its [support materials](https://help.harvey.ai/) describe Assistant, document storage/review, workflows and legal sources; its [developer documentation](https://developers.harvey.ai/api-reference/authentication) describes workspace-dependent API permissions | A complete product competitor with integration capabilities. The project has no confirmed account, usable API entitlement, price or source-isolation test. |
| Legora | Its [research page](https://legora.com/product/legal-research) describes legal sources and an ontology; its [technical measures](https://legora.com/legal/security-measures) describe web/desktop access and APIs where agreed | Existing source-backed and structured legal research weakens a generic “more explainable legal AI” positioning. Entitlements, source restrictions and price remain unverified. |
| Noxtua | Its [user guide](https://academy.noxtua.com/posts/getting-started) describes research, document review, drafting and source references; jurisdiction-specific providers are part of access | Relevant European legal-product alternative. Actual edition, jurisdictional content, model route, source controls and price require verification. |
| A custom workflow inside an incumbent product | Proposed integration route; no partnership or entitlement exists | Could avoid building another full workspace. Commercial and technical feasibility remain open. |

The conclusion is narrow: citations, document upload and a privacy claim are not sufficient differentiation. The defensible hypothesis is a **reviewed and maintained decision specification for a defined workflow**, with missing-fact handling, traceable exceptions and measured reduction in verification work. Even that may be reproducible by Python or an incumbent vendor. Potential defensibility would come from validated coverage, trusted maintenance and workflow fit; none has yet been demonstrated.

Product privacy statements must be read at deployment level. Harvey [states](https://www.harvey.ai/security) that it offers regional processing choices and does not train underlying models on customer inputs, outputs or documents. Legora [states](https://legora.com/security) that it does not train on customer data and offers retention and other enterprise controls. These statements have not been audited by this project, and neither is a conclusion that a particular customer deployment complies with GDPR or professional confidentiality rules.

Noxtua's [security description](https://www.noxtua.com/security) distinguishes Minerva, which uses external closed-source frontier models, from Athena, which offers hosting of the whole system on European-controlled infrastructure. It also distinguishes model-provider zero retention from conversation history stored by Noxtua. The project's evaluation must record the actual route; “European” must not be treated as one invariant architecture or as a guarantee about all processing.

The same discipline applies to direct model APIs. OpenAI's [data-control documentation](https://developers.openai.com/api/docs/guides/your-data) separates default non-training from retention and endpoint-specific state. Anthropic's [commercial data policy](https://privacy.claude.com/en/articles/7996868-is-my-data-used-for-model-training) distinguishes default handling from voluntarily supplied feedback. Google's [Gemini API terms](https://aistudio.google.com/docs/terms) distinguish service and regional treatments, including an EEA/Swiss/UK qualification; a blanket statement that all free use trains models would be inaccurate. Self-hosting Qwen or DeepSeek changes the infrastructure responsibility rather than eliminating it. Exact licences, logs, backups, hosting, support access and deployment controls still need review.

Public model and pricing pages are available, including [OpenAI pricing](https://developers.openai.com/api/docs/pricing), [Anthropic model information](https://platform.claude.com/docs/en/models/overview) and [DeepSeek models and prices](https://api-docs.deepseek.com/quick_start/pricing/). They do not establish this project's entitlement, negotiated rate, taxes, region, cached-token treatment or billing mode. Runnable configurations therefore retain unknown values until a specific configuration is verified and frozen. No “cheapest model” ranking is justified by list rates alone.

## Buyer, user and workflow hypotheses

The proposed economic buyer is the person responsible for a privacy-service budget or legal operations budget: for example, a partner leading an external DPO practice or a head of privacy in an organisation with recurring requests. The daily user may be a privacy analyst, paralegal or DPO. The approving professional may be a different person. Security and IT staff influence whether the system can be used, while the person whose data is involved is affected by its output but is not the purchasing customer.

For an external DPO practice, the hypothesised value is consistent preparation across several client matters and less repetitive senior review. Matter separation and organisation-specific rules may increase setup cost and reduce reusable volume. For an in-house team, the hypothesised value is faster intake and a clearer review record; integration with existing identity checks, case tracking and retention policies may dominate the cost. A small firm handling infrequent requests may gain too little to justify onboarding. None of these segment assumptions has been confirmed.

The proposed workflow begins with a request or internal intake note. The system extracts only necessary facts, displays their source locations and asks for missing facts that change the decision. The professional confirms the material facts, such as the received date, request scope and relevant retention circumstances. A versioned rule set identifies supported obligations, exceptions and unresolved conditions. The language model turns that result into a proposed action list and explanation with sources. The reviewer corrects or approves it, and the approved decision, overrides and rule version are retained in the existing case record. Actual communication or deletion is a separately authorised action.

This workflow depends on confirmation of legally evaluative inputs. “Necessary”, “disproportionate”, “high risk” and “large scale” cannot become trustworthy facts merely because an extraction schema has a Boolean field for them. The system must distinguish a reported fact, a model inference and a professional's legal assessment. If gathering or confirming inputs costs more time than the checks save, the commercial hypothesis fails even if the engine is perfectly consistent.

## Strong and weak use cases

| Workflow | Fit for reviewed rules | Principal limitation and decision |
| --- | --- | --- |
| Rights-request intake, deadline prompts and obligation checklist | Relatively strong when dates, role and request type are verified | Calendar semantics, extensions, identity issues and exceptions need reviewed interpretation. Recommended initial discovery niche. |
| Processor/subprocessor approval and required-information checks | Relatively strong for an explicit contractual and statutory checklist | Negotiated terms and role classification need separate review. Potential adjacent niche after coverage validation. |
| Breach-response completeness and notification decision support | Potentially strong for separating duties, documenting missing facts and testing an agreed risk assessment | Awareness time and risk assessment are often uncertain. High consequence and urgency make autonomous decisions unsuitable as the first product promise. |
| DPIA/DPO screening | Useful for explicit triggers and an escalation path | Scale, systematic monitoring and legal context can be disputed. Screening is not a completed DPIA or conclusive appointment advice. |
| Consent and special-category-data checks | Useful for making cumulative conditions and alternatives visible | Real voluntariness, purpose and legal bases may require context absent from the intake. |
| Legitimate-interest balancing, proportionality and novel factual disputes | Weak as an automatic decision engine | Rules can structure an assessment but cannot establish contested facts or resolve open legal judgment. |
| International transfer legality | Weak without a maintained, jurisdiction-specific source set and deployment facts | A country label or EU hosting location alone does not establish the relevant transfer analysis. |
| Open-ended research, negotiation, litigation strategy or novel precedent | Poor initial fit | Retrieval, interpretation and professional judgment dominate; formalising a small rule subset offers limited coverage. |
| Drafting style and general summaries | Little engine-specific value | A strong model or incumbent product is the appropriate baseline. |

The benchmark deliberately spans more topics than the recommended first workflow, so it can reveal both strengths and limits. A profitable niche does not require winning every topic. It does require a prespecified, reproducible effect in the claimed niche, without presenting a favourable post-hoc slice as a validated product.

## Value, pricing and the complete cost model

The value hypothesis is less time spent checking routine conditions, fewer avoidable escalations and a review record that is easier to inspect. A rule trace is valuable only if it is legally sound and reduces verification work; a long trace that must be independently reconstructed can add cost. Saved minutes are capacity, not automatically cash. Cash savings require an observable reduction in paid work or a credible use of freed capacity. Error avoidance may matter, but it must be estimated separately and must not use the GDPR maximum fine as an average loss.

A plausible pricing structure is a one-off setup and validation fee plus an annual fee for a defined workflow, maintenance and a bounded usage allowance. An alternative is a price per **reviewed workflow item**, where the unit and included human work are clear. This is a pricing hypothesis, not a quoted offer or evidence of willingness to pay. Seat pricing may be poorly aligned if only a few specialists handle all eligible work; usage pricing may be unwelcome if it discourages checking. Discovery must establish the budget owner and preferred unit.

For workflow alternative \(j\), define annual eligible volume \(N\), one-time formalisation cost \(U_{f,j}\), integration cost \(U_{i,j}\), initial legal validation cost \(U_{l,j}\), and planning amortisation period \(A_j>0\). This is an operational planning allocation, not an accounting-policy recommendation. Annual fixed cost is:

\[
F_j=\frac{U_{f,j}+U_{i,j}+U_{l,j}}{A_j}
 +L_j+H_j+M_j+R_j,
\]

where \(L\) is annual licence cost, \(H\) fixed hosting, \(M\) engineering and legal maintenance, and \(R\) other fixed human review/assurance costs. Recurring legal maintenance belongs in \(M\); the same hours must not also be counted in \(R\).

Let variable cost per attempted case be:

\[
v_j=c_{API,j}+c_{hosting,j}
 +t_{handling,j}w_{handling,j}
 +t_{review,j}w_{review,j}
 +c_{rework,j}.
\]

Times are in hours and rates are fully loaded hourly costs. The executable calculator combines handling and review into one human-time input; use their total minutes and a correctly weighted rate, preserving the component assumptions in the evidence. \(c_{API}\) includes all extraction and synthesis calls, charged cache/reasoning/tool usage and attributable failed attempts. Self-hosted operation uses its actual hardware or service costs rather than invented zero-cost tokens. Optional expected residual error cost is \(e_j=\sum_k P(\text{error type }k)\times \text{loss}_k\), with overlapping events handled to avoid double counting. Report operating cost first, then the separately labelled risk scenario \(TCO_j+Ne_j\). The calculator accepts one explicit probability/loss pair per alternative; a multi-category estimate needs a documented aggregate. Unknown loss probabilities are not measurements.

Annual cost and cost per correctly handled case are:

\[
TCO_j(N)=F_j+Nv_j,\qquad
CPC_j(N)=\frac{TCO_j(N)}{Nq_j},
\]

where \(q_j\) is the measured probability of a correctly handled item **at the same workflow stage** for every alternative. A raw-model accuracy cannot be combined with a fully reviewed human workflow as if the outcomes were comparable. The denominator is undefined for zero volume or zero/unknown correctness. The benchmark's correctness estimates also need a justified mapping to the actual mix of incoming work.

For baseline \(B\) and proposed workflow \(P\), annual cash saving is \(TCO_B-TCO_P\), and saving per correctly handled case is \(CPC_B-CPC_P\). If \(v_B>v_P\), the equal-volume cash break-even is:

\[
N^*_{cash}=\frac{F_P-F_B}{v_B-v_P}.
\]

The break-even for a lower cost per correct case is:

\[
N^*_{correct}=
\frac{F_P/q_P-F_B/q_B}{v_B/q_B-v_P/q_P}.
\]

These expressions require valid positive correctness inputs and an appropriate denominator. If the proposed workflow has both higher fixed and variable cost, there is no positive cash break-even. If it is cheaper from the outset, there need not be a positive threshold. Negative ratios must not be presented as useful adoption volumes. For first-year cash planning, charge the full upfront spend instead of amortising it; show this separately from the steady-state comparison.

### Worked illustration — no observed or vendor prices

The following numbers are deliberately hypothetical and match [the illustrative calculator configuration](../config/economics.example.json). They are not measured benchmark results. They use one planning currency, USD, assume no error-loss benefit and exclude recoverable taxes. Any non-USD cost would require a dated exchange-rate assumption before combination. These annual operating volumes are economic scenarios, not changes to the 30-task benchmark.

Assume an existing workflow has USD 1,200 annual licence cost, 30 minutes of human handling and review at USD 60 per hour, and 90% correctness at the defined assessment stage. Assume the proposed workflow requires 80 formalisation hours at USD 100, USD 2,000 integration and USD 2,000 initial legal validation, allocated over two years. Add USD 1,200 annual licences, USD 800 hosting and 40 maintenance hours at USD 100. This gives USD 12,000 annual fixed cost. The licence values are invented planning inputs, not quotations for a named vendor.

Assume its variable cost is USD 19: USD 1 API cost and 18 minutes of combined handling and review at USD 60 per hour. Fixed hosting already covers infrastructure in this illustration; no extra variable hosting or rework is assumed. Proposed correctness is assumed to be 95%. These human costs, the zero-rework assumption and both correctness rates must be replaced by observations.

| Illustrative annual eligible volume | Baseline annual cost | Proposed annual cost | Annual cash saving |
| --- | ---: | ---: | ---: |
| 300 | USD 10,200 | USD 17,700 | **−USD 7,500** |
| 1,200 | USD 37,200 | USD 34,800 | **USD 2,400** |
| 3,000 | USD 91,200 | USD 69,000 | **USD 22,200** |

At 1,200 items, the assumed cost per correct case is USD 34.44 for the baseline and USD 30.53 for the proposed workflow, a USD 3.92 difference. Cash break-even is approximately 982 items per year; quality-adjusted break-even is approximately 848. These figures do not demonstrate demand for that volume. In the first year, charging all USD 12,000 upfront instead of its USD 6,000 annual allocation raises the proposed cash cost to USD 40,800 at 1,200 items, so first-year cash saving becomes **−USD 3,600**. The first-year calculation is an additional cash-planning view; the current calculator reports the annual allocation.

The example also puts a ceiling on pricing. Before any additional supplier fee, the steady-state cash benefit at 1,200 items is only USD 2,400 annually. A hypothetical buyer requiring half that saving to remain would have at most USD 1,200 available for an additional annual fee under these assumptions. That is not a recommended market price; it shows how easily implementation costs or a sales margin can erase the apparent case. A fee already included in licences or setup must not be deducted again.

### Sensitivity and what must be measured

At 1,200 items, adding five minutes of review at USD 60 per hour adds USD 5 per item and turns the USD 2,400 steady-state saving into a USD 3,600 loss. Doubling the illustrative USD 1 API charge adds USD 1,200 annually. Increasing annual fixed cost by USD 6,000 similarly turns the central scenario negative. If the proposed system's assumed correctness falls to 85%, its cost per correct case rises to about USD 34.12, leaving only USD 0.33 advantage; at 84% it is about USD 34.52 and loses that advantage. These are sensitivity calculations, not model forecasts.

The decisive measurements are therefore eligible volume, actual end-to-end human effort, coverage, correctness after the chosen review stage, reusable formalisation effort and update frequency. Measure queue time separately from active labour, and record setup effort even when a founder supplies it without an invoice. The economic report should include low/base/high volume and review-time scenarios, bounds on correctness, model-price changes, legal update effort, hardware utilisation and first-year cash. A case that is positive only after assigning a large speculative avoided-loss value is not validated by operating savings.

## Discovery and a bounded pilot

A proposed first discovery round would interview privacy-service leaders, working privacy analysts and at least one in-house budget owner across several organisations. This is a plan, not completed research or a list of committed participants. Its purpose is to disprove weak assumptions early, especially insufficient volume, an adequate existing checklist or excessive input-confirmation effort.

The interview should start with the person's most recent actual request, not with a sales pitch:

1. Walk through the last relevant matter from receipt to closure. Which records show the steps and time spent?
2. How many comparable matters were handled in the last quarter, and what fraction had unusual facts or required escalation?
3. Which facts were missing at intake, who obtained them, and what delayed a decision?
4. Which checks were repeated, and which required judgment that a checklist could not resolve?
5. Where did corrections, missed steps or unnecessary escalation occur? What evidence exists, rather than a general impression?
6. Which templates, case tools, legal databases and AI products are already used and paid for? What is satisfactory about them?
7. Who reviews the draft, how long does that review take, and what would make a rule trace easier or harder to trust?
8. What data, integration and contract requirements would prevent a trial? Can the workflow be tested with synthetic material first?
9. Who controls the budget, what competing improvement would this displace, and what measurable result would justify paying?
10. After seeing a bounded demonstration, would the organisation commit staff time, a named owner and a defined pilot budget? What would cause it to stop?

Interview notes should separate reported estimates, directly observed records and interpretation. Interest in a demonstration is weak evidence. A concrete commitment with time, ownership and a budget is stronger, though still not recurring demand. No interviews or messages are authorised or sent merely by including this guide.

The first technical and usability pilot can use the **same fixed 30 tasks**. Freeze them after legal review, assign the two independent GDPR reviewers and adjudicator, configure the models and obtain the genuine reviewed Prolog module. Run the matched arms and accessible products according to the protocol. A separate timed workflow exercise may ask representative users to review those existing materials using their current process and the proposed workflow, with counterbalanced order and recorded corrections. Reuse and familiarity effects must be reported; this exercise is not an independent new accuracy benchmark.

Before any live customer matter, a separately agreed pilot must define the permitted data, accountable reviewer, deployment, integration, output actions, incident handling and stopping criteria. No automatic expansion of the 30-task benchmark is included here. A proposed four-to-six-week workflow trial would measure active handling and review time, task completion, overrides, missed material facts, coverage and user willingness to continue at a stated price. Duration is a planning suggestion, not a commitment or an already scheduled activity.

## Evidence gates, risks and commercial decision

| Gate or risk | Evidence required to proceed | Current state and consequence |
| --- | --- | --- |
| Legal specification is incomplete or mistaken | Independent review of the 70 reference answers, rule coverage, exceptions and unknown semantics | Pending; no validated gold or production legal engine |
| Prolog adds no value over Python | Matched H4 comparison and measured maintenance effort if lifecycle value is claimed | Pending; language-specific differentiation is unproven |
| Apparent improvement comes from extra prompting | Shared extraction and synthesis controls; complete matrix with missing cells | Controlled design specified; no inference results |
| Oracle success hides extraction errors | End-to-end fact and synthesis error analysis, not just rule agreement | Pending; perfect supplied inputs do not establish usable advice |
| Buyer has too little eligible work | Observed volume and measured current handling cost | Unknown; low-volume buyers may be a poor fit |
| Human review removes the saving | Timed workflow evidence including corrections and rework | Unknown; central economic sensitivity |
| Security or integration prevents use | Actual contract, access, data-flow and deployment review for the chosen service | Unverified; vendor statements alone are insufficient |
| Rules become stale or vendor models change | Named maintenance owner, version freeze, change monitoring and revalidation effort | No operating service or maintenance commitment established |
| Sources or outputs cannot be controlled/exported | Tested product procedure, permission and reproducibility metadata | Product access and source-control capability unverified |
| Interest does not convert to payment | A named buyer, bounded funded pilot and explicit renewal decision | No customer evidence or willingness-to-pay evidence |

The near-term recommendation is **Go for bounded technical evaluation and customer discovery, not a positive commercial investment conclusion**. A niche pilot becomes justified if reviewed end-to-end results meet the proposed quality gates, a buyer has enough eligible volume, and time savings survive full costs without speculative loss avoidance. If benefits exist only for cheaper models, test that cost configuration. If Python performs equally well, choose the implementation with the better evidenced lifecycle cost. If benefits occur only with perfect inputs, fix fact confirmation before pursuing deployment. If a strong general model or an existing legal product already meets the workflow need at lower total cost, the correct outcome is no-go or integration with that alternative.

This analysis is complete as a desk-based assessment: it identifies a plausible niche, credible substitutes, testable buyer assumptions, a full economic model and specific reasons the proposal may fail. **Technical superiority, positive customer economics and market demand remain unproven. Commercial validation is pending.**
