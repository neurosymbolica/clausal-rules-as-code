# The financial entity's own duties for the management of ICT third-party risk under Regulation (EU) 2022/2554 (DORA), for ONE contractual arrangement on the use of ICT ...

`eu/dora_ict_third_party_entity_duties`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 198/198 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

The financial entity's own duties for the management of ICT third-party risk under Regulation (EU) 2022/2554 (DORA), for ONE contractual arrangement on the use of ICT services: the assessments before entering into the arrangement (Art 28(4)(a)-(e)), the provider's information security standards (Art 28(5)), the exercise of access, inspection and audit rights (Art 28(6)), the exit strategies and plans for ICT services supporting critical or important functions (Art 28(8)), the preliminary assessment of ICT concentration risk and the considerations on subcontracting, insolvency, data recovery and third countries (Art 29(1), (2)); and, at entity level, who must adopt a strategy on ICT third-party risk (Art 28(2), first sentence). Four queries: which duties apply (entity_duties_required), whether all are performed (entity_duties_complete), which are outstanding (entity_duties_outstanding), and whether the strategy is required (ict_third_party_strategy_required). The open-textured judgements (each duty performed, critical or important function, high technical complexity) are the caller's; unsure is referred to a lawyer as needs_legal_review. Out of scope: whether the entity is a ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32022R2554 | as pinned | 2026-11-16 | `a2cb18429ced35b7...` |
| CELEX 32022R2554 | as pinned | 2026-11-16 | `0a18e3677eac14c3...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/dora_ict_third_party_entity_duties){ .md-button }

## Provisions deferred, and what follows

??? info "general_principles"

    **Why:** Art 28(1) requires financial entities to manage ICT third-party risk within their ICT risk management framework, to remain fully responsible for their obligations (point (a)) and to apply the principle of proportionality (point (b)). It is quoted for reading (9) (proportionality removes no duty); it states principles with no condition and no output this order computes.

    **Consequence for a user:** No answer turns on it; proportionality removes no duty in this order (open question (Q9)).

??? info "strategy_content_basis_and_review"

    **Why:** Art 28(2), first sentence, who must adopt and regularly review a strategy on ICT third-party risk (every financial entity other than the entities of Article 16(1), first subparagraph, and microenterprises), is formalised by ict_third_party_strategy_required (reading (10)). Not formalised: the multi-vendor strategy of Article 6(9) the strategy takes into account, the policy on the use of ICT services supporting critical or important functions it includes, its application on an individual, sub-consolidated and consolidated basis (second sentence), and the regular review by the management body of the risks of arrangements on critical or important functions (third sentence). The content of the policy is specified by Delegated Regulation (EU) 2024/1773, which is named and not formalised.

    **Consequence for a user:** strategy_required says only that the entity must adopt the strategy; it says nothing about the strategy's content, its basis of application, the management body's review or whether the entity has a strategy.

??? info "register_of_information"

    **Why:** Art 28(3) requires a register of information on all contractual arrangements on the use of ICT services, yearly reporting, the register on request and timely information on planned arrangements for critical or important functions. The templates are in Implementing Regulation (EU) 2024/2956, which is named and not formalised.

    **Consequence for a user:** The order does not check the register, the reporting or the notice of a planned arrangement (reading (12)).

??? info "termination_circumstances"

    **Why:** Art 28(7) lists the circumstances in which contractual arrangements must be capable of termination. It is a requirement on the contract, formalised in the order on the key contractual provisions of Art 28(7) and Article 30 (eu/dora-ict-third-party-contract-provisions); here it is named only because the second sentence of Art 28(8) refers to it.

    **Consequence for a user:** complete and none_outstanding say nothing about the termination rights in the contract (reading (14)).

