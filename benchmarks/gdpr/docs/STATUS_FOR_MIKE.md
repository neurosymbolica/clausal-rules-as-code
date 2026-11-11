# Handoff status for Mike — 11 November 2026

**The research package and exploratory pilot evidence are delivered in this PR. The central comparison of Mike's complete GDPR system against standalone LLMs is still pending.** This status consolidates the recorded runs of 9 November; it does not claim a new live service test on 11 November. The PR is a draft for collaboration, not a completed study or merge-ready legal validation.

## Delivered package

- Exactly 30 synthetic GDPR tasks: 20 focused cases and 10 company cases, comprising 70 subquestions. Full narratives, provisional reference answers, legal bases, missing facts and scope limits are included.
- Executable CLI framework, configurable model adapters, Python diagnostic baseline, genuine-Prolog adapter interface, usage/cost records, statistical analysis and independent-review workflow.
- A planned 870-cell evaluation matrix. This is an experiment design, **not 870 completed evaluations**.
- Project concept, business analysis, commercial hypotheses and illustrative full-cost scenarios. Customer demand, willingness to pay, time savings and actual unit economics remain unvalidated.
- The recorded software verification includes 137 passing tests. These validate software behaviour, not legal correctness. This documentation update does not rerun or change the benchmark implementation.

## What actually ran

| Workstream | Executed scope | Observed result and interpretation |
| --- | --- | --- |
| Core local baseline | 30 Python diagnostic records; 150 other requested records blocked | Confirms local execution and honest missing-dependency reporting. Not a completed six-arm study. |
| Initial remote GDPR rule integration | Eight breach subquestions in two variants: 16 requests | Strict inputs: eight missing-fact responses. With the explicit additional assumption of no authority decision: four target-duty outputs, three protected held-out responses, one target duty absent. The four available duty labels agree with provisional references; not a legal-accuracy pass rate. |
| Separate rule probes for the six-case pilot | Six additional requests to the GDPR books interface | One missing-fact response, three held-out responses, one duty output, one contradictory-input rejection. E05 has no mapped rule and was not submitted to the books endpoint. |
| Four-model augmentation pilot | Sol, Astra, Opus, Sonnet; six cases / twelve questions; legislation alone, plus RIS decisions, or plus actual rule outputs | Twelve CLI calls produced 144 answer objects. Eleven calls passed strict question-ID validation. No reliable quality gain from supplying the observed rule outputs was demonstrated. This evaluates augmentation, **not Mike's complete agent**. |
| Direct conversational-agent check | Six complete GDPR case narratives submitted individually in fresh sessions | All six requests returned HTTP 200 with explicit out-of-scope responses; zero substantive GDPR answers. Legal quality is not evaluable. This is an access/coverage finding, not evidence that the models beat a GDPR-enabled system. |
| Other-domain discovery | Chat domains and example gallery inspected | Additional EU examples identified. No systematic comparative evaluation of those domains has been completed. |

The six exploratory scenarios concern: encrypted psychiatric backups with uncertain key exposure; suspicion versus established breach awareness; public HIV reports and link deletion; communication duties for differently reachable groups; an Austrian hospital's DPO/fine status; and contradictory risk flags despite verified disclosure and blackmail. They are a separate extension, not additional core GDPR-30 tasks.

## What we can and cannot conclude

The reachable GDPR books demonstrate structured rule execution and useful input validation. The partial adapter maps eight of the core 70 questions; it supplies no complete company-case answer. This is a statement about our implemented mapping, not the full possible coverage of every remote package.

In the augmentation pilot, provisional assistant scores total 93/96 for legislation, 93/96 with RIS, and 94/96 with demo outputs. The one-point difference is confined to Sonnet and disappears when the schema-invalid baseline run and its paired treatments are excluded. Small scope, a ceiling effect, shared fact scaffolding, single runs and subjective unblinded grading preclude a robust benefit claim.

The reachable conversational agent advertises five Singapore-law domains. Its GDPR rejections do not establish that Mike lacks a GDPR-capable agent elsewhere. Conversely, broader engine examples in the gallery do not establish that those rules are connected to this chat. Its model identity and whether an LLM executed during each rejection remain unverified.

**We have not completed an independent blind legal review or a controlled end-to-end head-to-head comparison.** The earlier model calls received legislation and normalized facts; the direct service probes used individual raw narratives. Their outputs must not be ranked as if the conditions were matched. All reference answers and assistant quality ratings remain provisional.

## Required next steps

1. **Mike: identify or enable the GDPR natural-language route.** Supply the entry point, any domain-selection procedure, supported scope, and model/rule versions for these synthetic cases. The latest recorded access check is from 9 November.
2. **Agree a matched direct-comparison protocol.** Run the same narratives and questions across Mike's complete system and standalone models; disclose source availability and clarification policy. Keep an equal-source condition separate where feasible. Do not bypass protected benchmark inputs.
3. **Appoint independent legal reviewers.** Review the references, freeze the rubric, assess identity-masked answers and adjudicate disagreements before making legal-accuracy claims.
4. **Execute the broader study.** Extend to the registered 30 cases and planned conditions with repeatability, paired case-level statistics and measured costs. Genuine local `llm_prolog` and `prolog_oracle` conditions remain blocked until a sourced, reviewed package/interface is available.
5. **Validate the business case separately.** Obtain user/customer evidence, measured review-time savings and complete operating costs. Technical agreement alone does not validate demand or economics.

## Evidence index

- [Concept](PROJECT_CONCEPT.md), [business analysis](BUSINESS_CASE.md), [30 cases](CASES.md), [70 provisional answers](REFERENCE_ANSWERS.md), [protocol](PROTOCOL.md)
- [Core evaluation matrix](../reports/evaluation-matrix.csv)
- [Initial integration: 16 requests and coverage](../reports/demo-integration-2026-11-09/README.md)
- [Four-model pilot: original answers, ratings, RIS and rule evidence](../reports/edge-pilot-2026-11-09/README.md)
- [Direct agent: six original requests and scope rejections](../reports/system-access-2026-11-09/README.md)

The repository files contain the later pilots and this status. The dated ZIP is an earlier frozen handoff and does not include these subsequent additions. Publishing in the PR does not imply Mike has reviewed, adopted or merged the work.
