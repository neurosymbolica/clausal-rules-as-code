# Directive (EU) 2022/2555 (NIS 2) Art 2(1) to (4), (7), (9) and (10) and Art 3(1) and (2), with the size ceilings of Article 2 of the Annex to Commission Recommendation ...

`eu/nis2_scope_entity_class`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 242/242 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Directive (EU) 2022/2555 (NIS 2) Art 2(1) to (4), (7), (9) and (10) and Art 3(1) and (2), with the size ceilings of Article 2 of the Annex to Commission Recommendation 2003/361/EC to which Art 2(1) refers. Decided here, from a profile of caller-stated facts and judgements: the size category of the entity (size_class/3), whether the Directive applies to it (scope_decision/3) and whether it is an essential or an important entity (entity_class/3). An absent fact that can change the answer is named (indeterminate, one key); an unsure judgement that decides is referred to a lawyer (needs_legal_review). Out of scope: whether an activity is of an Annex I or II type (a caller judgement), the SME aggregation rules of Arts 3 to 6 of the Annex to the Recommendation, the national definitions of public administration, the identification of critical entities under Directive (EU) 2022/2557, Member State extensions and exemptions under Art 2(5) and (8), whether national law applies the Directive (country orders), and jurisdiction and registration (sibling order).

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32022L2555 | as pinned | 2026-11-11 | `1af42930e907ee39...` |
| CELEX 32022L2555 | as pinned | 2026-11-11 | `5a7a1cd80dd108cc...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/nis2_scope_entity_class){ .md-button }

## Provisions deferred, and what follows

??? info "member_state_extensions_and_exemptions"

    **Why:** Art 2(5) (a Member State may apply the Directive to public administration entities at local level and to education institutions) and Art 2(8) (a Member State may exempt specific entities in the areas of national security, public security, defence or law enforcement from Articles 21 and 23, and in some cases from Articles 3 and 27) are decisions of national law; whether a Member State made them is a fact for the country orders.

    **Consequence for a user:** The answers apply the Directive's own rules; they do not say whether a Member State extended the scope to local public administration or education institutions, or exempted an entity.

??? info "annex_types"

    **Why:** Annex I (sectors of high criticality) and Annex II (other critical sectors) list the types of entity to which the Directive applies. This order takes whether the entity is of a type in Annex I or II as the two judgement keys annex_i_type and annex_ii_type; the Annex lists are formalisable (as sector and type enumerations) but no pinnable text yet: tools/pin_statute.py cannot cut this text (--annex is not implemented for xhtml; the Recommendation fails 404 through the celex route); the tool is to be extended; the debt is replaced by a pin, keys and bound units when it does.

    **Consequence for a user:** The answers do not say which activities are of an Annex type; the caller judges that itself.

??? info "sme_ceilings_pin"

    **Why:** Art 2 of the Annex to Recommendation 2003/361/EC (the staff and financial ceilings of the size categories) is read in this order from the raw pin quoted in sources, and no citation key names it; no pinnable text yet: tools/pin_statute.py cannot cut this text (--annex is not implemented for xhtml; the Recommendation fails 404 through the celex route); the tool is to be extended; the debt is replaced by a pin, keys and bound units when it does.

    **Consequence for a user:** The size answers cite the Directive Art 2(1) that refers to the Recommendation, not the Recommendation itself.

