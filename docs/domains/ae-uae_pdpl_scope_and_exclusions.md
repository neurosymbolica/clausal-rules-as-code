# Whether Federal Decree by Law No. (45) of 2021 Concerning the Protection of Personal Data (UAE PDPL) applies to ONE processing of personal data on ONE day, ...

`ae/uae_pdpl_scope_and_exclusions`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 191/191 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Whether Federal Decree by Law No. (45) of 2021 Concerning the Protection of Personal Data (UAE PDPL) applies to ONE processing of personal data on ONE day, processing_date (a date, year 1 to 9999, both ends): pdpl_applies reads Art 2(1) (three ways: a data subject residing or having a place of business in the State; a controller or processor residing in the State; one residing outside the State processing data of data subjects inside it) and Art 2(2) (seven exclusions, each a caller judgement), with the Art 1 definitions of Personal Data and Processing (a caller judgement) and Art 31 (in force as of 2 January 2022, that day included); pdpl_in_force reads Art 31 only. An unsure judgement is handed to a lawyer (needs_legal_review, open_textured); a missing key is named first. Out of scope and NAMED GAPS: Art 3 (Bureau exemption), Art 28 (Executive Regulations, not known to be issued), Art 29 (regularisation period), Art 30 (repeals); Arts 4 to 27 are left to other orders; the free-zone regimes (DIFC, ADGM) and the health, banking and credit legislation of Art 2(2)(e) to (g) are not read. The English translation is read; the Arabic text, which prevails, is not.

## Sources

The statute text is not reproduced here. Read it at UAE Legislation portal (uaelegislation.gov.ae):

| Instrument | Link | Last read |
|---|---|---|
| download | <https://uaelegislation.gov.ae/en/legislations/1972/download> | 2026-11-25 |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/ae/uae_pdpl_scope_and_exclusions){ .md-button }

## Provisions deferred, and what follows

??? info "definitions_relied_on_by_readings"

    **Why:** Art 1 State, Office, Data, Sensitive Personal Data, Data Subject, Establishment, Controller and Processor are quoted because readings (5), (6), (8), (10), (11) and (14) rely on them; no limb cites them: the caller's keys carry the facts they define.

    **Consequence for a user:** None for a caller: the keys of Art 2(1) and Art 2(2) carry them; reading (8) and Q1 name the government-owned company point of Establishment.

??? info "bureau_power_of_exemption"

    **Why:** Art 3 lets the Bureau [quotation omitted] [quotation omitted] [quotation omitted]'. The Executive Regulations are not known to be issued and no Bureau decision or list is known, so 'a large volume' has no stated measure and whether an exemption was granted is unknown. A NAMED GAP, not formalised: no query reads it (reading (13), Q12); see the Executive Regulations.

    **Consequence for a user:** applies and in_force never say whether the Bureau has exempted an establishment from part or all of the requirements.

??? info "executive_regulations"

    **Why:** Art 28 requires the Council of Ministers to issue the Executive Regulations within six months of the date the Decree-Law is promulgated. They are not known to be issued (a MISSING FACT); no rule of this order rests on them. A NAMED GAP: see the Executive Regulations (reading (13), Q12).

    **Consequence for a user:** No answer says whether the Executive Regulations are issued.

??? info "regularisation_period"

    **Why:** Art 29 gives controllers and processors no more than six months from the issue of the Executive Regulations to regularise their status, which the Council of Ministers may extend for another similar period. As the Executive Regulations are not known to be issued, the period cannot be dated. A NAMED GAP, not formalised: see the Executive Regulations (reading (13), Q12).

    **Consequence for a user:** in_force and applies never say whether the regularisation period has begun or ended.

