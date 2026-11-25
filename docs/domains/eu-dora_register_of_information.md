# The register-of-information duties of ONE financial entity under Regulation (EU) 2022/2554 (DORA) Article 28(3) and Commission Implementing Regulation (EU) 2024/2956 ...

`eu/dora_register_of_information`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 171/171 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

The register-of-information duties of ONE financial entity under Regulation (EU) 2022/2554 (DORA) Article 28(3) and Commission Implementing Regulation (EU) 2024/2956 (the ITS) Articles 2 to 6: which of the thirty-four duties apply to it and at which levels (register_of_information_duties_required/3), whether it has performed all of them (register_of_information_duties_complete/3), and which are outstanding (register_of_information_duties_outstanding/3). Each duty applies always or on one crisp trigger the caller states; its performance is the caller's judgement (true, false or unsure), an unsure judgement that decides being referred as needs_legal_review. Out of scope: whether the entity is a financial entity within the scope of DORA (presupposed; the DORA order on scope and entity types), the content of each template (Annexes I to IV of the ITS), the rest of Article 28 (deferred, formalised where it is in the DORA orders on the financial entity's ICT third-party duties and on the key contractual provisions) and the permissive ITS Art 5(2). Every reading is the drafter's, not a lawyer's.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32022R2554 | as pinned | 2026-11-16 | `a2cb18429ced35b7...` |
| CELEX 32024R2956 | as pinned | 2026-11-20 | `8263638b6f5772ed...` |
| CELEX 32024R2956 | as pinned | 2026-11-20 | `670b30654620506e...` |
| CELEX 32024R2956 | as pinned | 2026-11-20 | `6b0aa056dcc1ea01...` |
| CELEX 32024R2956 | as pinned | 2026-11-20 | `cc6e60fbedb10b17...` |
| CELEX 32024R2956 | as pinned | 2026-11-20 | `eb52fc85b75d3a43...` |
| CELEX 32024R2956 | as pinned | 2026-11-20 | `add3cffdfc652fc3...` |
| CELEX 32024R2956 | as pinned | 2026-11-20 | `18bc11370cb80e87...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/dora_register_of_information){ .md-button }

## Provisions deferred, and what follows

??? info "general_principles"

    **Why:** Art 28(1) requires financial entities to manage ICT third-party risk within their ICT risk management framework, to remain fully responsible for their obligations (point (a)) and to apply the principle of proportionality (point (b)). It is quoted for reading (3) only: proportionality is read as removing no duty.

    **Consequence for a user:** No answer turns on it; proportionality removes no duty in this order (open question (Q3)).

??? info "strategy_on_ict_third_party_risk"

    **Why:** Art 28(2) requires a strategy on ICT third-party risk with a policy on ICT services supporting critical or important functions, reviewed by the management body; the entities of Article 16(1), first subparagraph, and microenterprises are excepted. It is quoted for reading (2) only: its exceptions are not read into Art 28(3).

    **Consequence for a user:** The order does not say whether the entity needs or has a strategy.

??? info "entity_duties_before_and_during_arrangements"

    **Why:** Art 28(4) lists the assessments before entering into an arrangement, Art 28(5) limits arrangements to providers that comply with appropriate information security standards, and Art 28(6) governs how access, inspection and audit rights are exercised (reading (21)).

    **Consequence for a user:** complete and none_outstanding say nothing about these duties (open question (Q19)).

??? info "termination_circumstances"

    **Why:** Art 28(7) lists the circumstances in which contractual arrangements must be capable of termination; it is a requirement on the contract (reading (21)).

    **Consequence for a user:** complete and none_outstanding say nothing about the termination rights (open question (Q19)).

??? info "exit_strategies_and_plans"

    **Why:** Art 28(8) requires exit strategies and plans for ICT services supporting critical or important functions (reading (21)).

    **Consequence for a user:** complete and none_outstanding say nothing about the exit strategies (open question (Q19)).

??? info "definitions"

    **Why:** ITS Article 1 defines the direct ICT third-party service provider, the ICT service supply chain and the rank. The definitions are read as the meaning of the words of the duties and carry no key of their own (reading (16)).

    **Consequence for a user:** The order does not check that a provider meets a definition; the caller judges it (open question (Q16)).

??? info "data_quality_principles_points"

    **Why:** ITS Art 3(4), points (a) to (f), list the six principles of data quality (accuracy, completeness, consistency, integrity, uniformity, validity). They are read with Art 3(3), first sentence, as one set of qualities and one duty, data_quality, formalised through the paragraph key eu_reg_2024_2956_art_3_4 (reading (13)); no point carries a key of its own.

    **Consequence for a user:** No answer turns on a single principle; whether the template information meets all six is the caller's one judgement (open question (Q13)).

