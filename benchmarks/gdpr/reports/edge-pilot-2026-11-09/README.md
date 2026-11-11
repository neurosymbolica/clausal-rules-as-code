# Six GDPR boundary cases: supplied rule-output augmentation

**Scope correction (9 November 2026): this is an LLM augmentation experiment, not Mike's end-to-end system versus standalone models.** A subsequent [direct agent access check](../system-access-2026-11-09/README.md) submitted all six narratives: the agent was reachable but rejected every GDPR case as out of scope. Its substantive legal quality remains unevaluated.

**Finding limited to this augmentation experiment: supplying the observed demo outputs did not demonstrate reliable improvement in the tested LLM answers.** In the provisional assistant assessment, adding the demo output changes one of 48 paired model-question scores upward and leaves 47 unchanged. Most answers were already strong with legislation alone. Limited demo coverage, a ceiling effect, one run per condition and subjective grading prevent a causal or general performance claim.

This is a separate exploratory extension, not a replacement or expansion of the frozen GDPR-30 dataset. Six new synthetic cases × two questions × four models × three conditions produced **12 actual CLI model calls and 144 answer objects**. Eleven calls passed the strict question-ID schema; one returned a mislabelled question that is explicitly aligned for content review below. No successful inference was rerun and no substitute model was used.

## Conditions and results

All models received identical case narratives, legislation, normalized facts and encoding limitations. Conditions are **parallel**, not cumulative:

1. `law`: frozen GDPR Articles 4, 9, 28, 32, 33, 34, 37, 38 and 83, plus Austrian DSG sections 5 and 30.
2. `ris`: the same material plus two complete Austrian DSB decisions retrieved through RIS MCP.
3. `mike`: the same common material plus the actually returned demo outputs. No additional RIS decisions.

Providing the same factual encoding to every condition controls for operator fact preparation. It makes this a test of supplied evidence at answer synthesis, not autonomous fact extraction or tool selection. The shared factual encoding and coverage notes provide substantial scaffolding; they may create a ceiling and hide benefits that arise earlier in an end-to-end workflow. National statutory text is common to all arms even though it was obtained through RIS; only the additional decisions distinguish the RIS condition.

| Requested model | Law | Law + RIS | Law + Mike | Mike − law |
|---|---:|---:|---:|---:|
| `gpt-6.1-sol` | 24/24 | 24/24 | 24/24 | 0 |
| `gpt-6-astra` | 24/24 | 24/24 | 24/24 | 0 |
| `claude-opus-5-5` | 23/24 | 22/24 | 23/24 | 0 |
| `claude-sonnet-5-5` | 22/24* | 23/24 | 23/24 | +1* |
| **Descriptive total** | **93/96** | **93/96** | **94/96** | **+1/96** |

These are **provisional, unblinded assistant quality ratings**, not independently validated legal accuracy percentages. Each answer receives 0 (materially wrong/unsafe), 1 (correct core conclusion with a material reasoning/completeness problem), or 2 (core conclusion and material critical points addressed). The rubric was frozen before inference. Every deduction has an exact excerpt and explanation in [assessment.json](assessment.json); minor ancillary omissions are not automatically penalised. A score of 24/24 does not certify every ancillary claim or establish a cross-provider model winner.

*Sonnet's law output used `E04.b` for the unique group-B banner answer instead of `E04.q2`. We retain the strict schema failure and unchanged original response. Content review manually aligns that one answer, with a recorded post-run deviation. Sonnet also labels E02.q2 `no` in law and RIS while its reasoning says notification is required; the compound question asks whether notification is required **or** waiting is permitted, so wording may contribute. Full semantic assessment and raw label agreement are reported separately. Its E05.q1 label remains conditional despite recommending designation. Raw label matches after explicit ID alignment are 12/12 throughout for both OpenAI models and Opus; Sonnet has 10/12, 10/12 and 11/12.

**Sensitivity:** Excluding the entire schema-invalid Sonnet-law run and its paired treatments leaves the three other models at **71/72 with law, 70/72 with RIS and 71/72 with Mike**: no Mike gain. The sole favourable quality change is also sensitive to judgement about a notification action's wording. Treating that distinction as immaterial removes the observed quality gain. This reinforces the cautious conclusion.

## Cases and the observed tool coverage

Full narratives and questions are in [CASES.md](CASES.md) and [cases.json](cases.json).

| Case | Boundary tested | Actual demo response |
|---|---|---|
| E01 | Encrypted psychiatric backup, stolen vault credentials, unknown key access | Missing risk fact; no duty decision |
| E02 | Friday suspicion versus Monday confirmed awareness; processor/controller roles | Held out; timing is not represented in this book |
| E03 | Plaintext HIV reports publicly exposed; downloads unknown; link removed | Held out |
| E04 | Reachable group A; disproportionate contact effort for B; ineffective banner not ruled out | A held out; B returns authority notification, documentation and public/similar communication |
| E05 | Austrian hospital GmbH; unclear public mandate; DPO and fine exemption | No mapped rule; no request fabricated |
| E06 | Same-incident risk flags contradict verified psychiatric disclosure and blackmail | Explicit input-problem response rejecting the contradictory flags |

Six live requests produced one missing-fact response, three held-out responses, one duty answer and one contradiction rejection. The three non-held-out responses had their effective inputs checked against the submitted values. Protected cases were not bypassed. The banner's actual effectiveness is not represented in the schema, so the group-B output is **not** a certification of the proposed banner. None of these outputs is a complete company-case opinion. Remote source revision and legal review are unknown.

## What improved, what did not

- **One tentative improvement:** Sonnet's law action plan made both authority/patient notices contingent on vault compromise. In its Mike answer it instead treats logs as an input, not a precondition for action. RIS also avoids that wording. This is a one-off wording difference, not evidence that the tool caused the improvement.
- **A persistent error:** Opus states in all three conditions that the banner reaches at most the 20% who used the portal historically. Past usage does not establish an upper bound on future actual reach. The correct conclusion that effectiveness is unproven survives, but neither supplement removes the unsupported quantitative inference.
- **Useful tool behaviour without measured answer gain:** The demo rejects the E06 contradictory inputs. Every model already detected that contradiction in the law condition. The supplemented answers accurately describe the rejection and still require urgent action on the narrative facts.
- **No inappropriate deference observed:** With Mike's output, models do not treat the group-B public-communication result as approval of this banner, and they do not treat held-out replies as substantive legal answers.
- **RIS is not uniformly beneficial:** It adds relevant judicial/authority context but does not improve total points here. The Opus RIS action plan's log-confirmation framing raises a separate completeness concern; its deduction is expressly judgement-sensitive.

## Statistical interpretation

H0/H1 and scoring were recorded in [PROTOCOL.md](PROTOCOL.md) before inference. There are six scenario clusters; 48 model-question pairs are not 48 independent samples. Case-level deltas average paired score changes across models. For Mike, one case has a positive mean delta of 0.25 points and five tie. The exact two-sided sign test on nonzero case deltas has **n=1, p=1.0**. RIS has no nonzero case-level net deltas, so its sign test is undefined. These exploratory tests provide no evidence for superiority and do not demonstrate equivalence or absence of benefit.

All six cases are in one batch per model/condition, there are no independent repeats, and condition order is fixed. Provider CLI harnesses differ and medium effort does not equal matched compute. Unknown backend revisions, model stochasticity, supplied interpretations, selected sources and an involved unblinded rater further limit inference. Exact statutory deadline computation under Regulation1182/71 remains outside the validated scoring: questions assess awareness and no-waiting duties, not a certified hour-level deadline. National fine applicability needs a current full legal analysis, not a mechanical reading of the selected statute alone.

## Provenance, usage and reproducibility

- OpenAI used the existing ChatGPT-authenticated Codex CLI; Anthropic used the existing subscription-authenticated Claude Code CLI, requesting the exact Opus/Sonnet IDs shown above. Claude reported those same IDs in model usage. No account identifiers or credentials are published.
- Shell/web/MCP/agent tools were disabled in inference. Models received frozen supplements; they did not query Mike or RIS themselves. CLI command/config differences are retained in [run_models.py](run_models.py). Inference ran in empty temporary directories, without the gold or project files.
- RIS source texts, IDs, status and timestamped MCP responses are in [sources/](sources/). Two documents were additionally rechecked using the now-connected native RIS MCP. Consolidated statutes are labelled informational; authority decisions retain their own context. RIS MCP is a third-party bridge to official RIS data.
- Original answers, parsed answers where schema-valid, usage, latency, requested models and hashes are in [runs/](runs/). Original CLI streams remain local because they can contain machine/account/session metadata. No private demo network address, cookies, CSRF token or access invitation is included.
- Claude emitted estimated API-equivalent costs totalling **USD 1.503374** across six calls. These are provider estimates, **not a subscription invoice or actual incremental charge**. Actual invoiced costs are null for all calls; no OpenAI dollar estimate is fabricated. Full token counters, including cache creation/read tokens, are retained. Timing is single-call elapsed time, not a speed benchmark.
- [manifest.json](manifest.json) records all twelve calls; [freeze.json](freeze.json) pins cases, provisional gold, protocol, common law, supplemental sources and executed runner. [demo-observations.json](demo-observations.json) retains parsed responses, input checks and response hashes, excluding the demo template's stored expected answer.
- Run `python3 analyse.py` in this folder to recompute the assessment tables from the recorded rating decisions and immutable answers. Run `python3 verify.py` for artifact verification. Neither command makes model/API calls.
- The collection/inference scripts are archived execution recipes. They refuse existing output directories. For a new experiment, prepare a fresh sibling experiment directory with the frozen input files; do not overwrite this report or call `prepare.py` over these cases. The demo collector requires `GDPR_DEMO_BASE_URL` in the environment. Live model scripts use authenticated CLIs and can consume account quota.
- [review-packet.jsonl](review-packet.jsonl) masks model identities for a future reviewer. The key remains local. Conditions may be inferred from citations, and named answers/results are public: reviewers should not consult them before review. No independent blinded review has occurred.

## Validation and handoff

The core 137-test suite passed after collection setup. Artifact validation checks twelve process completions, original-answer hashes, prompt/freeze hashes, 144 raw answer objects, the single explicitly recorded ID deviation, native RIS provenance, demo effective-input checks, scoring arithmetic and unchanged core dataset counts. No genuine local reviewed Prolog package has been added: formal `llm_prolog`/`prolog_oracle` gates remain blocked.

For Mike, the next useful collaboration is a versioned evaluation endpoint that can answer our own synthetic inputs without bypassing protected benchmark cases, separate duty outputs, coverage for unknowns/time/public-body status, and independent legal review. Until then, present the observed input validation as a useful capability, **not a demonstrated improvement in general legal-answer accuracy**.
