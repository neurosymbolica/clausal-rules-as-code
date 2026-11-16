# For one incident or malfunctioning of an AI system whose provider (or the caller acting for it) is the provider of a system placed on the Union market: whether the ...

`eu/ai_act/serious_incident_reporting`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 262/262 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

For one incident or malfunctioning of an AI system whose provider (or the caller acting for it) is the provider of a system placed on the Union market: whether the provider must report it as a serious incident under Article 73 of Regulation (EU) 2024/1689 (Artificial Intelligence Act, consolidated text 02024R1689-20260727 as amended by Regulation (EU) 2026/1744), to which authority (Art 73(1) and (10)), by which last calendar day (2, 10 or 15 days after awareness, Art 73(2) to (4)), with the follow-up duties of Art 73(6) listed; and whether a first report made on a given day was in time. Decided here are the dates of application read from Art 113 third paragraph point (c)(i) and (ii), the systems already on the market of Art 111(2), the definition of serious incident of Art 3(49), the point (c) limitation of Art 73(9) and (10), and the widespread infringement of Art 3(61) as a judgement. Out of scope and handed to the caller or a lawyer: high-risk classification under Art 6 and the Annexes, whether the event is an incident of a provider's system placed on the market, open-textured judgements (significant change in design, equivalent Union reporting obligations, widespread ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02024R1689 | 2026-07-27 | 2026-11-12 | `ca245cb516a1feb2...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-12 | `88125bdf6e61ce18...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-12 | `4e9d975c73fd231d...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-12 | `3299e42e8e44be0d...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/ai_act/serious_incident_reporting){ .md-button }

## Provisions deferred, and what follows

??? info "severity_of_the_serious_incident"

    **Why:** The second subparagraph of Art 73(2) ('The period for the reporting referred to in the first subparagraph shall take account of the severity of the serious incident') sits in the same unit as the 15-day limit, which the order reads; it gives no measure of severity and no shorter period, so it is not formalised.

    **Consequence for a user:** The answers give the outer limit only; for a severe incident the caller must consider whether a shorter period is required.

??? info "content_of_reports_and_follow_up"

    **Why:** Art 73(5) allows an incomplete initial report followed by a complete report, and Art 73(6) lists the follow-up duties (investigations without delay, risk assessment, corrective action, cooperation, no altering investigation before informing the authorities). The order reads REPORT_DATE as the day of the first report and lists the five follow-up duties in the answer; it does not check the content of a report, whether a complete report followed, or how the follow-up duties are met.

    **Consequence for a user:** The answers do not say whether a report or its follow-up was adequate; the caller must check the content itself.

??? info "entry_into_force_and_general_date_of_application"

    **Why:** The first and second paragraphs of Art 113 (entry into force on the twentieth day following publication; application from 2 August 2026, the date of Chapter IX) decide no answer under reading (2): the duty of Art 73 is read as binding a provider only from the date of application of Chapter III for its class, Art 113 third paragraph point (c)(i) and (ii), which is formalised (open question Q1).

    **Consequence for a user:** An awareness date from 2 August 2026 to 1 December 2027 is answered not_applicable_on_date; a caller who holds that the duty runs from 2 August 2026 must apply Art 73 to such an incident itself.

??? info "points_a_b_and_d_of_the_serious_incident_definition"

    **Why:** Points (a), (b) and (d) of Art 3(49) are read only as the caller's classification given in the keys harm_to_health, critical_infrastructure_disruption and serious_harm_to_property_or_environment (open question Q6); the order defines neither serious harm, nor a serious and irreversible disruption, nor directly or indirectly leading to it. The answers cite the lead of point (49) and point (49)(c), never points (a), (b) or (d).

    **Consequence for a user:** The caller classifies each harm itself; the answers take that classification as given.

??? info "limbs_of_the_widespread_infringement_definition"

    **Why:** Whether there is a widespread infringement is the judgement widespread_infringement (reading (6)): the limbs count Member States, but whether an act has harmed or is likely to harm the collective interests of individuals is open-textured, so no crisp test is built; an unsure value goes to a lawyer under the referral row that cites Art 3(61).

    **Consequence for a user:** The caller judges the limbs of Art 3(61) itself and gives true, false or unsure.

