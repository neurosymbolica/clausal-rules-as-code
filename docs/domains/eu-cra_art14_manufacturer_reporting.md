# Reporting obligations of manufacturers under Article 14(1) to (6) of Regulation (EU) 2024/2847 (Cyber Resilience Act), with the Article 3 definitions that Article 14 ...

`eu/cra_art14_manufacturer_reporting`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 200/200 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Reporting obligations of manufacturers under Article 14(1) to (6) of Regulation (EU) 2024/2847 (Cyber Resilience Act), with the Article 3 definitions that Article 14 uses (read as the caller's classification) and the date of application of Article 14 in Article 71(2) (11 September 2026). Decided here: whether an incident having an impact on the security of a product with digital elements is severe (Art 14(5), either limb); which reporting steps are due, with their limits, for an actively exploited vulnerability (Art 14(2)) or a severe incident (Art 14(4)), with the intermediate report on request (Art 14(6)); and whether an early warning or a notification was submitted within its 24-hour or 72-hour limit (a partial hour rounded up) and without undue delay. Out of scope (deferred or excluded sets): who is a manufacturer and which product or event is covered, product scope and transitional provisions, the recipient CSIRT and the single reporting platform (Art 14(7), Art 16), the content of each report and the clause on information already provided, informing users (Art 14(8)), the Commission's acts (Art 14(9) and (10)), computing the end of the 14-day and one-month calendar periods, ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32024R2847 | as pinned | 2026-11-14 | `f8b2836b0b1ae35a...` |
| CELEX 32024R2847 | as pinned | 2026-11-14 | `0bae8ac96b4da5ad...` |
| CELEX 32024R2847 | as pinned | 2026-11-14 | `30840275fab12de3...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/cra_art14_manufacturer_reporting){ .md-button }

## Provisions deferred, and what follows

??? info "definitions_read_as_the_callers_classification"

    **Why:** Art 3(1) and (13) define product with digital elements and manufacturer; Art 3(40), (42), (43) and (44) define vulnerability, actively exploited vulnerability, incident and incident having an impact on the security of the product. They are quoted for readings (1) and (2); whether the asker is a manufacturer of such a product and whether the event is one of the two EVENT atoms is the caller's classification, with no key.

    **Consequence for a user:** The answers presuppose a manufacturer of a product with digital elements and an event of the kind EVENT names; the caller checks the definitions first.

??? info "recipient_and_channel"

    **Why:** Art 14(7) says that the notifications go via the single reporting platform through the electronic notification end-point of the CSIRT designated as coordinator of the Member State of the manufacturer's main establishment in the Union (where cybersecurity decisions are predominantly taken, else the establishment with the highest number of employees), and, with no main establishment in the Union, of the Member State fixed by the order in points (a) to (d) (authorised representative, importer, distributor, users); Art 3(15), (16), (17) and (51) define the persons and the CSIRT it names. Which end-point the manufacturer must use is not formalised (reading (13)).

    **Consequence for a user:** No answer says to which CSIRT or through which end-point the steps are submitted.

??? info "recipients_and_platform_words_of_paragraphs_1_and_3"

    **Why:** Art 14(1) and (3) are read for the duty they state (the manufacturer notifies an actively exploited vulnerability, or a severe incident having an impact on the security of the product, that it becomes aware of); their words 'simultaneously to the CSIRT designated as coordinator, in accordance with paragraph 7 of this Article, and to ENISA' and 'via the single reporting platform established pursuant to Article 16' are not formalised (reading (13)).

    **Consequence for a user:** No answer says whether the notification went to both recipients or through the platform.

??? info "content_of_the_steps_and_unless_already_provided"

    **Why:** Points (a) to (c) of Art 14(2) and (4) are read for the step, its limit and its 'without undue delay'. What each step must indicate or provide (Member States where the product is made available, whether unlawful or malicious acts are suspected, general information, corrective or mitigating measures, how sensitive the information is) and the words 'unless the relevant information has already been provided' in points (b) and (c) are not formalised (readings (4) and (10); open question (Q4)).

    **Consequence for a user:** A listed notification or final report may in law not be needed where the relevant information has already been provided; the caller decides that. No answer checks the content of a report.

??? info "content_of_the_final_reports"

    **Why:** Points (c)(i) to (iii) of Art 14(2) and (4) list what the final report must include at least. The content of a report is not formalised.

    **Consequence for a user:** No answer checks what a final report contains.

??? info "informing_users"

    **Why:** Art 14(8) requires the manufacturer, after becoming aware, to inform the impacted users (and where appropriate all users) of the vulnerability or incident and, where necessary, of risk mitigation and corrective measures, and lets the coordinator CSIRTs inform users where the manufacturer fails to do so in a timely manner. It sets no hour limit and is not formalised.

    **Consequence for a user:** No answer says whether or when users must be informed.

??? info "other_application_dates"

    **Why:** Art 71(2) is read for its sentence 'Article 14 shall apply from 11 September 2026' (reading (11)); its dates for the rest of the Regulation (11 December 2027) and for Chapter IV (11 June 2026) are not formalised (open question (Q12)).

    **Consequence for a user:** No answer says from when any other Article applies.

