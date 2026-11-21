# The maximum administrative fines of Article 64 of Regulation (EU) 2024/2847 (the Cyber Resilience Act), with the date from which Article 64 applies (Article 71(2)) and ...

`eu/cra_administrative_fines`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 224/224 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

The maximum administrative fines of Article 64 of Regulation (EU) 2024/2847 (the Cyber Resilience Act), with the date from which Article 64 applies (Article 71(2)) and the open-source software steward derogation of Art 64(10)(b). One query, administrative_fine_maximum/4, answers for one infringement, named by the provision infringed, at the date of the infringement: which tier of Art 64(2), (3) or (4) applies and the maximum fine in euro cents (the higher of the fixed amount and, for an undertaking, the percentage of its total worldwide annual turnover; the fixed amount at a tie; the half cent of 2,5 percent dropped); or that Article 64 does not yet apply (before 11 December 2027), does not list the provision, or does not apply to an open-source software steward (middle and lowest tiers only, on the printed reading of 'paragraphs 3 to 9'). Undertaking and steward status are the caller's tri-state judgements (unsure refers to a lawyer). Out of scope: the fine itself (Art 64(5)), whether the offender is within the Regulation's scope or bound by the provision, whether the provision was infringed, national application (Art 64(6) to (9)), and the relation to other fining regimes. Every ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32024R2847 | as pinned | 2026-11-14 | `f8b2836b0b1ae35a...` |
| CELEX 32024R2847 | as pinned | 2026-11-16 | `2bb9a2b2903ececd...` |
| CELEX 32024R2847 | as pinned | 2026-11-14 | `30840275fab12de3...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/cra_administrative_fines){ .md-button }

## Provisions deferred, and what follows

??? info "amount_of_the_fine_in_each_case"

    **Why:** Art 64(5) lists what is taken into account when the amount of a fine is decided in each individual case (nature, gravity and duration; earlier fines for a similar infringement; size and market share). The order gives the maximum only (reading (1)); the amount within it is the authority's weighing of all relevant circumstances, with no rule this order could compute.

    **Consequence for a user:** No answer gives a fine; every final answer is a maximum.

??? info "fines_on_public_bodies"

    **Why:** Art 64(7) leaves to each Member State whether and to what extent fines may be imposed on public authorities and public bodies (reading (11), open question (Q8)).

    **Consequence for a user:** The order gives the Union maximum even for a public body; whether any fine applies to it is for national rules.

??? info "derogation_lead_words"

    **Why:** The lead words of Art 64(10) ('By way of derogation from paragraphs 3 to 9, the administrative fines referred to in those paragraphs shall not apply to the following:') are read in reading (7): they limit point (b) to the middle and lowest tiers, which THE LIMBS formalise through step (F4); no citation key names this unit. Whether 'paragraphs 3 to 9' is a slip for 'paragraphs 2 to 9' is open question (Q1).

    **Consequence for a user:** For a provision of the highest tier the steward judgement is not read and no derogation applies.

??? info "micro_and_small_enterprise_early_warning_derogation"

    **Why:** Art 64(10)(a) exempts manufacturers that qualify as microenterprises or small enterprises with regard to a failure to meet the deadline of Article 14(2), point (a), or Article 14(4), point (a). On the literal reading of the lead words (reading (7)) it decides no answer, because those deadlines are obligations of Article 14, fined under paragraph 2, which the derogation does not name; the order has no key for it.

    **Consequence for a user:** A micro or small manufacturer that missed the 24-hour early-warning deadline gets the highest-tier maximum, not an exemption, on this reading (open question (Q1)).

??? info "steward_definitions_read_as_the_callers_judgement"

    **Why:** Art 3(14) defines open-source software steward and Art 3(48) free and open-source software. They are quoted for reading (8); whether the offender is a steward is the caller's judgement offender_is_open_source_software_steward, true, false or unsure.

    **Consequence for a user:** The order does not test the definition; the caller states the judgement.

