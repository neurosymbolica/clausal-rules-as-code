# Regulation (EU) 2016/679 (GDPR), consolidated text 02016R0679-20160504, no date argument. Two bounded questions. (1) lawful_basis_status/4: whether one processing, ...

`eu/data_protection/gdpr_art6_lawful_basis`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 247/247 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2016/679 (GDPR), consolidated text 02016R0679-20160504, no date argument. Two bounded questions. (1) lawful_basis_status/4: whether one processing, described by one attribute-list profile, has a lawful basis under Art 6(1), and which of points (a) to (f) holds: point (a) read as the host's attested statement that consent was given with its conditions met (Art 7 is decided by the order gdpr-consent-conditions); points (b) to (e) as caller judgements of necessity; points (c) and (e) also need the attested statement that the basis is laid down by Union or Member State law (Art 6(3) first sentence); point (f) needs the caller's judgement of the legitimate interest and of the balance, and is barred for a public authority in its tasks (Art 6(1) last subparagraph). basis_claimed restricts the question to one point. (2) purpose_compatibility/4: the Art 6(4) compatibility test for processing for a new purpose, with the five factors of points (a) to (e) as optional crisp keys and the weighing left to the caller's judgement. Open-textured judgements are stated by the caller and an unsure one goes to a lawyer (needs_legal_review). Out of scope: compliance with the Regulation ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `c44dc232a4ef4465...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `9ff4f05a60ab2f27...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `eaef725422c7172d...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-11-14 | `b10e27dd93652da7...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-11-14 | `88c485a8b578dd16...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_art6_lawful_basis){ .md-button }

## Provisions deferred, and what follows

??? info "art_4_other_definitions"

    **Why:** Art 4 is pinned whole because the smallest document element that contains Art 4(11) is the article. The other points define terms (personal data, processing, controller, third party, ...) that no step reads: the profile states the facts in those terms already.

    **Consequence for a user:** Whether the data are personal data, and who is the controller or a third party, are not tested; the caller establishes them before relying on an answer.

??? info "art_4_11_consent_definition"

    **Why:** The definition of consent (freely given, specific, informed and unambiguous indication of the data subject's wishes) is carried by the attested statement consent_given_and_conditions_met; this order does not test it (reading (3), Q8).

    **Consequence for a user:** An eligible answer on point (a) rests on the host's statement that there is a consent; the order does not check that it is one.

??? info "art_6_3_rest_of_paragraph"

    **Why:** Only the first sentence of Art 6(3) (the basis of points (c) and (e) shall be laid down by Union law or by Member State law to which the controller is subject) is read, as the outside facts legal_obligation_laid_down_by_law and public_interest_task_laid_down_by_law (reading (5)). The other sentences (the purpose determined in the legal basis or necessary for the task; the specific provisions the legal basis may contain; the law meeting an objective of public interest and being proportionate to the legitimate aim pursued) are not checked (Q2).

    **Consequence for a user:** An eligible answer on point (c) or (e) does not say that the law meets the other requirements of Art 6(3).

??? info "art_6_3_a_b_which_law"

    **Why:** Art 6(3)(a) (Union law) and (b) (Member State law to which the controller is subject) are the two laws the outside facts of reading (5) name together; the order does not ask which of them lays the basis down.

    **Consequence for a user:** No answer says whether the basis is laid down by Union law or by Member State law.

??? info "art_6_4_first_words_route_keys"

    **Why:** Art 6(4) first words: the two routes (based on the data subject's consent; based on a Union or Member State law which constitutes a necessary and proportionate measure to safeguard the objectives of Art 23(1)) have no keys of their own; new_purpose_processing carries them (Q13, Q18). The route keys can change an answer, so absent cannot read as today; a later amendment.

    **Consequence for a user:** The caller states the routes only through new_purpose_processing; no answer reads a route separately.

??? info "art_8_child_consent_information_society_services"

    **Why:** Art 8 sets the conditions of a child's consent in relation to information society services offered directly to a child (an age of 16, or a lower age not below 13 set by Member State law; consent given or authorised by the holder of parental responsibility; reasonable efforts to verify; no effect on contract law). It is pinned only so that it can be deferred: the order does not decide the age of a data subject and does not check Art 8 (Q9, Q10).

    **Consequence for a user:** An eligible answer on point (a) does not check Art 8; where the processing concerns information society services offered directly to a child, the caller checks Art 8 before relying on it.

??? info "art_9_special_categories"

    **Why:** Art 9 (the prohibition of processing of special categories of personal data and its exceptions) is pinned only so that it can be deferred: the order does not decide it; the outside fact special_category is only flagged on an eligible answer (reading (8), Q11).

    **Consequence for a user:** An eligible answer does not say that the processing of special categories is permitted; the caller checks Art 9 separately.

