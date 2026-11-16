# Regulation (EU) 2024/1689 (Artificial Intelligence Act), consolidated text 02024R1689-20260727 (as amended by Regulation (EU) 2026/1744), for AI systems only. Decided ...

`eu/ai_act/scope_and_roles`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 267/267 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2024/1689 (Artificial Intelligence Act), consolidated text 02024R1689-20260727 (as amended by Regulation (EU) 2026/1744), for AI systems only. Decided here: whether the Regulation applies to one actor, in one capacity, for one AI system (Art 2(1) to (4), (6), (8), (10), (12)); whether the actor holds a role defined in Art 3(3) to (8) (provider, deployer, authorised representative, importer, distributor, operator); whether an actor other than the initial provider is considered the provider of a high-risk AI system under Art 25(1) or (3); what Art 25(2) does to the initial provider; whether Art 25(4) requires a written supplier agreement; each dated by Art 113, third paragraph, points (a) and (c). Out of scope (deferred or excluded): general-purpose AI models, the text of Arts 2 and 3 before 27 July 2026, classification as high-risk (Art 6), the provider obligations of Art 16, the content of the duty to cooperate and of the written agreement, delegated acts under Art 2(13). Open-textured judgements (AI system, placing on the market, putting into service, substantial modification, clearly specified and the like) are the caller's, and an unsure one that matters goes to ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02024R1689 | 2026-07-27 | 2026-11-14 | `316834a8e34276c2...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-14 | `3de76398209303f5...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-14 | `6ee993d132baa77a...` |
| CELEX 02024R1689 | 2026-07-27 | 2026-11-14 | `3299e42e8e44be0d...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/ai_act/scope_and_roles){ .md-button }

## Provisions deferred, and what follows

??? info "general_purpose_ai_models"

    **Why:** The words on general-purpose AI models and AI models in Art 2(1)(a) ('or placing on the market general-purpose AI models'), Art 2(6) and (8) ('or AI models') and Art 3(3), (5), (9) and (10) belong with the rules on general-purpose AI models (Chapter V), which are not pinned here; this order formalises AI systems only. The second sentence of Art 2(8) ('Such activities shall be conducted in accordance with applicable Union law') adds no rule this order applies.

    **Consequence for a user:** A provider, authorised representative or activity concerning only a general-purpose AI model or an AI model gets no answer from this order; the caller uses the rules on general-purpose AI models.

??? info "articles_57_to_59_for_section_b_products"

    **Why:** The second sentence of Art 2(2) ('Articles 57, 58 and 59 shall apply only in so far as the requirements for high-risk AI systems under this Regulation have been integrated in that Union harmonisation legislation') turns on the content of other Union law, which is not pinned.

    **Consequence for a user:** The answer only_listed_provisions_apply names Art 6(1), Art 60a and Arts 102 to 112; it does not say whether Arts 57 to 59 apply in part.

??? info "areas_outside_union_law_and_national_security_competences"

    **Why:** The first sentence of Art 2(3) (no application to areas outside the scope of Union law; the competences of the Member States concerning national security are not affected) states the limits of Union law and gives no test on a system; the second and third sentences are formalised.

    **Consequence for a user:** None for these answers beyond the military, defence and national security key.

??? info "intended_purpose_definition_applied_by_the_caller"

    **Why:** Art 3(12) (intended purpose) is quoted because the key on modifying the intended purpose uses it; the caller applies it when it gives the key. The order does not formalise it.

    **Consequence for a user:** The answers rest on the caller's application of this definition in the key it gives.

??? info "contractual_allocation_of_obligations"

    **Why:** Art 25(1)(a) is 'without prejudice to contractual arrangements stipulating that the obligations are otherwise allocated'; the order reads these words as not changing who is considered to be the provider, and does not check such arrangements (Q9).

    **Consequence for a user:** An answer considered_provider does not say how a contract allocates the provider's obligations between the parties; the caller checks it.

??? info "content_of_the_duty_to_cooperate"

    **Why:** The second subparagraph of Art 25(2) and its points (a) to (c) say what the initial provider's cooperation includes (information, technical access, technical documentation, known limitations and failure modes, targeted technical access); the order answers that the duty applies, not whether it was met.

    **Consequence for a user:** The answer no_longer_provider_must_cooperate does not say what was made available or whether the cooperation was enough.

??? info "content_of_the_agreement_and_voluntary_model_terms"

    **Why:** Art 25(4) also says what the written agreement specifies ('based on the generally acknowledged state of the art') and lets the AI Office develop and recommend voluntary model terms; the order answers whether an agreement is required, not its content, and the model terms bind no party.

    **Consequence for a user:** The answer written_agreement_required does not say what the agreement must contain.

