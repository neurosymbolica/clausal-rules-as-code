# Whether, on an assessment day, one of five duties of the deployer of an AI system applies under Regulation (EU) 2024/1689 (Artificial Intelligence Act), consolidated ...

`eu/ai_act/deployer_duties_fria`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 207/207 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Whether, on an assessment day, one of five duties of the deployer of an AI system applies under Regulation (EU) 2024/1689 (Artificial Intelligence Act), consolidated text 02024R1689-20260727: keeping the automatically generated logs (Art 26(6)), informing the workers' representatives and the affected workers (Art 26(7)), informing the natural persons subject to decisions (Art 26(11), with the Directive (EU) 2016/680 Art 13 rule for law enforcement), performing a fundamental rights impact assessment (Art 27(1), (2)) and notifying its results (Art 27(3)); and whether a proposed log retention period of whole months meets the six-month minimum of Art 26(6). The dates of Art 113, third paragraph, point (c), and the transitional rules of Art 111(1) and (2) are applied; the role of deployer (Art 3(4)) and the high-risk classification are the caller's facts. Out of scope: the scope of the Regulation (Art 2), the classification itself (Art 6, Annexes I and III), the content of the assessment, the manner and timing of the information, which logs are kept and whether the period is appropriate to the intended purpose, and the other duties of Art 26 (deferred and excluded sets). Open-textured ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `767b1280db92ed1d...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `3de76398209303f5...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `4a070b868ab2d57a...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `99fe3ff42a0a7603...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `e8ccf4aff93ac521...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-15 | `3299e42e8e44be0d...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/ai_act/deployer_duties_fria){ .md-button }

## Provisions deferred, and what follows

??? info "log_period_appropriate_to_the_intended_purpose_and_financial_institutions"

    **Why:** Art 26(6) asks for 'a period appropriate to the intended purpose of the high-risk AI system, of at least six months'; the order checks only the minimum of six months, not whether the period is appropriate (an open word), nor which logs are under the deployer's control; and its second sentence (deployers that are financial institutions maintain the logs as part of the documentation kept under Union financial services law) is not formalised (reading (5), reading (6), Q14).

    **Consequence for a user:** An answer retention_period_of_at_least_six_months does not say that the period is appropriate to the intended purpose, nor how a financial institution keeps the logs.

??? info "rules_and_timing_of_the_information_of_workers"

    **Why:** Art 26(7): the second sentence (the information is given, where applicable, under the rules and procedures of Union and national law and practice on information of workers and their representatives) and the check that the information came before the system was put into service or used are not formalised (reading (7), Q19).

    **Consequence for a user:** An answer obligation_applies does not say how the information is given or whether it was given in time.

??? info "manner_of_informing_natural_persons"

    **Why:** Art 26(11): how and when the natural persons are informed is not formalised; the order says whether the obligation applies (reading (8)).

    **Consequence for a user:** An answer obligation_applies does not say how or when the persons are to be informed.

??? info "content_and_timing_of_the_impact_assessment"

    **Why:** Art 27(1), second sentence ('For that purpose, deployers shall perform an assessment consisting of:'), and the words 'that the use of such system may produce'; Art 27(2), second and third sentences (reliance on earlier assessments in similar cases; the update when an element has changed): not formalised. The order reads who must perform the assessment and that it is due before the first use (reading (9)).

    **Consequence for a user:** An answer obligation_applies does not say what the assessment must hold, whether an earlier assessment may be relied on, or when it must be updated.

??? info "template_with_the_notification"

    **Why:** Art 27(3): the notification is made by 'submitting the filled-out template referred to in paragraph 5'; the order says whether the notification duty applies, not what is submitted or when (reading (10)).

    **Consequence for a user:** An answer obligation_applies does not say what the notification holds or when it is due.

??? info "appropriate_measures_oversight_input_data_monitoring_and_cooperation"

    **Why:** Art 26(1) (appropriate technical and organisational measures to use the system in accordance with the instructions for use), Art 26(2) (human oversight by persons with the necessary competence, training and authority), Art 26(4) (input data relevant and sufficiently representative), Art 26(5) (monitoring, informing the provider, suspending use, serious incidents) and Art 26(12) (cooperation with the competent authorities) are other duties of the deployer, turning on open words ('appropriate', 'necessary', 'sufficiently representative', 'reason to consider'); this order does not answer for them.

    **Consequence for a user:** The caller does not learn from this order whether those duties apply or are met.

??? info "registration_duty_of_public_deployers"

    **Why:** Art 26(8): deployers that are public authorities or Union institutions, bodies, offices or agencies comply with the registration obligations of Art 49 and do not use a system not registered in the EU database of Art 71; Arts 49 and 71 are not pinned here, and this order does not answer for that duty.

    **Consequence for a user:** The caller checks the registration duty under the rules on registration.

??? info "data_protection_impact_assessment_duty"

    **Why:** Art 26(9): where applicable, deployers use the information provided under Art 13 to comply with their duty to carry out a data protection impact assessment under Art 35 of Regulation (EU) 2016/679 or Art 27 of Directive (EU) 2016/680; that duty arises under those acts, which are not pinned here.

    **Consequence for a user:** The caller checks the data protection impact assessment under the data protection rules.

??? info "post_remote_biometric_identification"

    **Why:** Art 26(10) (authorisation of the use of post-remote biometric identification in a targeted search, its limits, documentation and annual reports) is a separate set of duties; this order does not answer for it.

    **Consequence for a user:** The caller does not learn from this order whether those duties apply or are met.

??? info "evaluation_of_large_scale_it_systems"

    **Why:** Art 111(1), second sentence (the requirements are taken into account in the evaluation of each large-scale IT system and where its legal acts are replaced or amended) binds those who evaluate the systems; the order reads the first sentence only (reading (11)).

    **Consequence for a user:** None for a deployer's answer.

