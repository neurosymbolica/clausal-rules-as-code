# Swiss law in force (drafter's reading, not a lawyer's). The right of access of the Swiss Federal Act on Data Protection (DSG, SR 235.1, Stand 7 July 2025) Arts 25(1), ...

`ch/swiss_fadp_s3_right_of_access`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 272/272 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Swiss law in force (drafter's reading, not a lawyer's). The right of access of the Swiss Federal Act on Data Protection (DSG, SR 235.1, Stand 7 July 2025) Arts 25(1), 25(6), 25(7), 26 and 27, with the form of the request, the time limit and the costs set by the Data Protection Ordinance (DSV, SR 235.11, Stand 1 December 2025) Arts 16(1), 16(3), 18(1), 18(3) and 19. Decided here: whether a request is in the required form and, if so, whether the controller must give access or may refuse, restrict or defer it (swiss_access_request_answer/3); whether access is free of charge or a cost contribution may be requested (swiss_access_cost_contribution/3); the last day of the 30-day time limit from receipt (swiss_access_deadline/3) and after a cost notice (swiss_access_deadline_after_cost_notice/3); for comparison, the last day of the one-month period of EU GDPR Art 12(3) counted under Regulation (EEC, Euratom) No 1182/71 Art 3 by analogy (eu_access_response_deadline/3), and the comparison of the two (compare_swiss_eu_access_deadline/5). Open-textured judgements are stated by the caller; an unsure one that matters goes to a lawyer (needs_legal_review). Out of scope: the content of the ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `92d1a62cc2ded398...` |
| CELEX 31971R1182 | as pinned | 2026-11-05 | `55a56126f24456ad...` |
| ch-fadp-sr-235-1 | as pinned | 2026-11-14 | `b56cba82fa4757eb...` |
| ch-fadp-sr-235-1 | as pinned | 2026-11-14 | `fcc33f980e60b2fd...` |
| ch-fadp-sr-235-1 | as pinned | 2026-11-14 | `714d5328781cdf82...` |
| ch-fadp-ord-sr-235-11 | as pinned | 2026-11-14 | `abdfc0d08eeaf632...` |
| ch-fadp-ord-sr-235-11 | as pinned | 2026-11-14 | `80472e09f36d275c...` |
| ch-fadp-ord-sr-235-11 | as pinned | 2026-11-14 | `9d8bdb59634bd97d...` |
| ch-fadp-ord-sr-235-11 | as pinned | 2026-11-14 | `045ca7ee9636c158...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/ch/swiss_fadp_s3_right_of_access){ .md-button }

## Provisions deferred, and what follows

??? info "swiss_content_of_the_information"

    **Why:** DSG Art 25(2) says what the data subject receives: the information needed to assert their rights and for transparent processing, and in every case the seven items of letters a to g (identity and contact details of the controller, the data processed, the purpose, the retention period or its criteria, the available information on the origin, where applicable an automated individual decision and its logic, where applicable the recipients and the information under Art 19(4)). The order says whether access must be given, not what it must contain.

    **Consequence for a user:** No answer says whether an answer to a request contains what it must.

??? info "swiss_health_data_through_health_professional"

    **Why:** DSG Art 25(3) lets personal data concerning health be communicated to the data subject, with their consent, through a health professional they designate: a way of giving access, not whether it is owed.

    **Consequence for a user:** No answer says how health data are to be communicated.

??? info "swiss_who_answers_processor_and_joint_controllers"

    **Why:** DSG Art 25(4) keeps the controller obliged to give access where a processor processes the data; DSV Art 17(1) lets the data subject assert the right with each of several joint controllers, and Art 17(2) has the processor support the controller unless it answers on the controller's behalf. The order answers for the controller to whom the request is made (reading (2)).

    **Consequence for a user:** No answer says which of several controllers, or whether a processor, must answer; the caller asks the order for the controller it names.

??? info "swiss_no_waiver_in_advance"

    **Why:** DSG Art 25(5) says no one may waive the right of access in advance. The order reads no waiver key, so a waiver given in advance cannot change any answer, which is what the paragraph requires.

    **Consequence for a user:** A caller must not treat a waiver given in advance as a ground to refuse access; the order has no key for one.

??? info "swiss_form_of_the_answer_and_identification"

    **Why:** DSV Art 16(2) sets the form of the answer (in writing or in the form in which the data exist; inspection on site by agreement; orally with the data subject's agreement); Art 16(4) requires an understandable form; Art 16(5) requires the controller to take appropriate measures to identify the data subject, who must cooperate. The order reads the form of the request only (reading (3)) and assumes the identification does not stand in the way (reading (2)).

    **Consequence for a user:** No answer says whether an answer has the right form, or what follows if the data subject cannot be identified or does not cooperate.

??? info "swiss_later_period_announced"

    **Why:** DSV Art 18(2): where the information cannot be given within 30 days, the controller must inform the data subject and tell them within what period it will be given. The text gives that period no number, so the order computes no date for it (reading (8)).

    **Consequence for a user:** No answer gives the later period or checks the information about it; the dates computed are those of the 30-day limit.

??? info "eu_article_12_paragraphs_not_compared"

    **Why:** GDPR Art 12(1) (form of information and communications), Art 12(2) (facilitating the exercise of the rights), Art 12(7) and (8) (icons) are pinned with the Article 12 extract; this order's EU limb compares only the one-month period of Art 12(3).

    **Consequence for a user:** No EU answer on these paragraphs.

??? info "eu_article_12_3_extension_and_electronic_means"

    **Why:** The first sentence of GDPR Art 12(3) (the one-month period) is read by eu_access_response_deadline/3 (reading (10)); its second and third sentences (extension by two further months, and the notice of it) and its last sentence (electronic means) are not read by this order.

    **Consequence for a user:** No EU answer gives the extended period or checks the notice of extension or the means of delivery.

