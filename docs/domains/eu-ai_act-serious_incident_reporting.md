# For one incident or malfunctioning of an AI system whose provider (or someone acting for it) asks, under Regulation (EU) 2024/1689 as consolidated on 27 July 2026 ...

`eu/ai_act/serious_incident_reporting`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 247/247 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

For one incident or malfunctioning of an AI system whose provider (or someone acting for it) asks, under Regulation (EU) 2024/1689 as consolidated on 27 July 2026 (amended by Regulation (EU) 2026/1744): whether the report of a serious incident under Art 73(1) is due (Art 3(49) and (61), Art 73(1) to (4), (9) and (10), Art 75(1a), Art 111(2), Art 113 third paragraph point (c)), to which recipient (the market surveillance authority, the national competent authority of Art 73(10), or the AI Office), within 2, 10 or 15 calendar days of awareness and by which last day, with the follow-up duties of Art 73(6) listed; and whether a first report made on a given day was in time (Art 73(2) to (5)). Open-textured judgements (significant change in design, use by public authorities, equivalent Union reporting obligations, widespread infringement, immediacy) are handed to the caller or a lawyer. Out of scope: classification as high-risk (Art 6, Annexes I and III), whether Art 75(1) applies (attested outside fact), the severity rule of Art 73(2) second subparagraph, the content of reports and follow-up, the authorities' side of Art 73(7), (8) and (11), Art 111(1) and the period rules of ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02024R1689 | 2026-07-27 | 2026-11-12 | `ca245cb516a1feb2...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-12 | `88125bdf6e61ce18...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-23 | `b560407e26b9241b...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-12 | `4e9d975c73fd231d...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-12 | `3299e42e8e44be0d...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-23 | `f925700bb4f224fd...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-23 | `ddd7acf963620b1d...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/ai_act/serious_incident_reporting){ .md-button }

## Provisions deferred, and what follows

??? info "severity_of_the_serious_incident"

    **Why:** The second subparagraph of Art 73(2) ('The period for the reporting referred to in the first subparagraph shall take account of the severity of the serious incident') sits in the same unit as the 15-day limit, which the order reads; it gives no measure of severity and no shorter period, so it is not formalised.

    **Consequence for a user:** The answers give the outer limit only; for a severe incident the caller must consider whether a shorter period is required.

??? info "content_of_reports_and_follow_up"

    **Why:** Art 73(5) allows an incomplete initial report followed by a complete report, and Art 73(6) lists the follow-up duties (investigations without delay, risk assessment, corrective action, cooperation, no altering investigation before informing the authorities). The order reads REPORT_DATE as the day of the first report and lists the five follow-up duties in the answer; it does not check the content of a report, whether a complete report followed, or how the follow-up duties are met.

    **Consequence for a user:** The answers do not say whether a report or its follow-up was adequate; the caller must check the content itself.

??? info "ai_office_competence_and_transmission"

    **Why:** Art 75(1) (which AI systems are under the exclusive competence of the AI Office, points (a) and (b) with the exceptions (i) to (iv), and the second subparagraph on providers and deployers) is quoted for what the outside fact system_under_the_exclusive_competence_of_the_ai_office means; this order does not test it, the caller attests the fact. The third sentence of Art 75(1a) (the AI Office transmits the relevant information to the market surveillance authority of the Member State where the provider or its legal representative is situated) binds the AI Office and is not formalised.

    **Consequence for a user:** The answers take the exclusive competence of the AI Office as attested (absent reads as not under it); they do not say whether Art 75(1) applies, nor what the AI Office does with a report.

??? info "harm_points_of_article_3_49"

    **Why:** Points (a), (b) and (d) of Art 3(49) are read through the caller's classification in the keys harm_to_health, critical_infrastructure_disruption and serious_harm_to_property_or_environment (open question Q6); whether the harm was serious, the disruption serious and irreversible, and whether the incident directly or indirectly led to it, are not decided here, and the order's citation vocabulary gives these points no key that an answer returns.

    **Consequence for a user:** The caller classifies each harm itself; the answers take the classification as given.

??? info "points_of_article_3_61"

    **Why:** Points (a), (a)(i) to (iii) and (b) of Art 3(61) count Member States, but whether an act has harmed or is likely to harm the collective interests of individuals is open-textured, so no crisp test is built (reading (6)); widespread_infringement is a judgement of the caller, referred under Art 3(61) when unsure.

    **Consequence for a user:** The caller judges whether there is a widespread infringement; the answers take the judgement as given or refer it to a lawyer.

