# Whether the contract or other legal act between a controller and a processor meets Article 28 of Regulation (EU) 2016/679, as a checklist: sufficient guarantees (Art ...

`eu/data_protection/gdpr_processor_contract`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 201/201 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Whether the contract or other legal act between a controller and a processor meets Article 28 of Regulation (EU) 2016/679, as a checklist: sufficient guarantees (Art 28(1)); binding, Union or Member State law and writing (Art 28(3), (9)); the seven content elements and the eight stipulations (a) to (h) of Art 28(3) plus the notice of an infringing instruction (second subparagraph); and, when another processor is engaged, the conditions of Art 28(2) and (4). The role gates (Art 4(8) processor, Art 28(10) processor that becomes a controller) are evaluated first. Out of scope and deferred: Art 29 conduct, the Art 28(4) liability sentence, Art 28(5) codes and certification as a limb, the content of standard clauses (Art 28(6) to (8), recorded only as the outside fact standard_clauses_adopted), Art 6 lawfulness and Chapter V transfers.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `c44dc232a4ef4465...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `81578e59d21e63a7...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `5d796679e4129e33...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_processor_contract){ .md-button }

## Provisions deferred, and what follows

??? info "art_28_5_code_of_conduct_and_certification"

    **Why:** Art 28(5) says adherence to an approved code of conduct (Art 40) or certification (Art 42) MAY be used as an element to demonstrate sufficient guarantees. It informs the judgement processor_provides_sufficient_guarantees and is not a condition: no crisp test is invented. Quoted to tie reading (7).

    **Consequence for a user:** The answer does not weigh a code of conduct or a certification: the caller must take Art 28(5) into account itself when setting processor_provides_sufficient_guarantees.

??? info "standard_clause_content"

    **Why:** Whether the contract adopts such clauses is the outside fact standard_clauses_adopted (attested; fetcher none); the content of the clauses, their annexes and the effect of adopting them on Art 28(3) are not formalized (Q1, RULED 2026-11-01: adoption does not replace the checklist).

    **Consequence for a user:** Adopting standard clauses does not settle the checklist: the caller must set each stipulation flag from the signed document, annexes included, and check the content of the clauses itself.

??? info "art_28_10_consequences"

    **Why:** When processor_determines_purposes_and_means is true the party is a controller for that processing (Art 28(10)); whether it is a joint controller (Art 26) and the liability and penalty consequences (Arts 82, 83, 84, to which Art 28(10) is expressly without prejudice) are not pinned and not formalized. The answer is needs_legal_review(deferred_provision(...)).

    **Consequence for a user:** When the answer refers because the processor determines the purposes and means, the caller must work out its position as a controller, any joint control under Art 26 and liability and penalties under Arts 82 to 84 itself.

