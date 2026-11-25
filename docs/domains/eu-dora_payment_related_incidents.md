# Article 23 of Regulation (EU) 2022/2554 (DORA), read with Article 2(1), points (a) to (d), Article 3, points (9), (11), (32) and (35) to (39), Article 18(3), point (a), ...

`eu/dora_payment_related_incidents`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 193/193 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Article 23 of Regulation (EU) 2022/2554 (DORA), read with Article 2(1), points (a) to (d), Article 3, points (9), (11), (32) and (35) to (39), Article 18(3), point (a), and Article 19(1), first, third and sixth subparagraphs. For one incident of one financial entity it decides (1) payment_related_incident_status: whether Article 23 reaches the entity, whether the incident is an operational or security payment-related incident, and whether it is a major one subject to the reporting obligation of Article 19(1); and (2) payment_related_incident_report_recipients: for a major incident, to whom the entity reports (the relevant competent authority, or the national competent authority designated under Directive 2013/36/EU for a significant credit institution, and the Directive (EU) 2022/2555 authorities or CSIRTs where the Member State has so determined). Whether the incident is payment-related and whether it is major are the caller's judgements; unsure is referred to a lawyer as open_textured. Out of scope: the reports, time limits and client information (sibling order dora-incident-reporting), the content of reports, what the authorities do with them, the classification criteria and ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32022R2554 | as pinned | 2026-11-23 | `88328cd00a7a11d6...` |
| CELEX 32022R2554 | as pinned | 2026-11-23 | `f05d65fd5046b721...` |
| CELEX 32022R2554 | as pinned | 2026-11-23 | `a82f28eba1475086...` |
| CELEX 32022R2554 | as pinned | 2026-11-23 | `17750ac2d9114467...` |
| CELEX 32022R2554 | as pinned | 2026-11-23 | `e0bd7e607b91fc90...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/dora_payment_related_incidents){ .md-button }

## Provisions deferred, and what follows

??? info "entity_terms_of_article_2_1"

    **Why:** Art 2(1), lead words and points (a) to (d), are quoted and relied on for the reach of Article 23 (reading (2)); they set the scope of the Regulation, which this order does not formalise.

    **Consequence for a user:** The order reads them only to fix which values of dora_entity_type Article 23 reaches; it does not say whether an entity is within the scope of the Regulation.

??? info "scope_limits_of_article_2"

    **Why:** Art 2(2) to (4) (financial entities collectively, the entities to which the Regulation does not apply, and the Member State option to exclude) decide the scope of the Regulation, which this order presupposes (reading (8)).

    **Consequence for a user:** An entity outside the scope of the Regulation gets the same answers as one inside it.

??? info "entity_definitions_read"

    **Why:** Art 3, points (32) and (35) to (39), are quoted and relied on for the reach of Article 23 (reading (2)). Each defines its term by reference to another Union act, which is not pinned here; whether an entity meets the definition is the caller's classification, stated in dora_entity_type.

    **Consequence for a user:** The order takes the kind of entity as given; it does not test the definition in the act referred to.

??? info "classification_criteria"

    **Why:** Art 18(1) and (2) set the criteria by which financial entities classify ICT-related incidents and cyber threats. This order does not classify: whether the incident is major is the caller's judgement payment_related_incident_is_major (reading (4)).

    **Consequence for a user:** The answers take the classification as given.

??? info "materiality_thresholds_and_mandate_of_article_18_3_a"

    **Why:** PARTLY FORMALISED. Art 18(3), point (a), is read for its words that major operational or security payment-related incidents are 'subject to the reporting obligation laid down in Article 19(1)' (reading (5)). Not formalised: the criteria and materiality thresholds the regulatory technical standards are to specify.

    **Consequence for a user:** The order computes no threshold; payment_related_incident_is_major carries the result.

??? info "authority_templates_and_content_words_of_article_19_1"

    **Why:** PARTLY FORMALISED. Art 19(1) is read for the reporting obligation (reading (5)) and for the recipients of its first, third and sixth subparagraphs (reading (6)). Not formalised: the single competent authority a Member State designates where several supervise, the transmission to the ECB by the national competent authority, the templates, the alternative means, and the fifth subparagraph on the information the reports must include (reading (7)).

    **Consequence for a user:** payment_related_incident_report_recipients names the recipients; it does not say what a report contains or which single authority is designated.

??? info "reports_time_limits_and_client_information"

    **Why:** Art 19(3) and (4) (the information of clients, and the initial notification, intermediate report and final report) are answered for a major ICT-related incident by the order dora-incident-reporting; this order does not repeat them (reading (5)).

    **Consequence for a user:** A caller with the answer chapter_requirements_and_article_19_reporting_apply asks that order's queries about the incident.

??? info "voluntary_notification_and_outsourcing"

    **Why:** Art 19(2) lets financial entities notify significant cyber threats on a voluntary basis; Art 19(5) lets them outsource the reporting and keeps them fully responsible. Neither changes an answer of this order (reading (7)).

    **Consequence for a user:** None for these answers.

