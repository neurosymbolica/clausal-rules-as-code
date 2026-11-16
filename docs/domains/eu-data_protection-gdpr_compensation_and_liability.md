# For ONE claim against ONE party (the caller, stated to be EITHER the controller OR the processor of the processing in question), whether that party is liable to ...

`eu/data_protection/gdpr_compensation_and_liability`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 207/207 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

For ONE claim against ONE party (the caller, stated to be EITHER the controller OR the processor of the processing in question), whether that party is liable to compensate damage under Article 82(1) to (3) of Regulation (EU) 2016/679 (GDPR): the three conditions of Art 82(1) (damage, an infringement, the damage resulting from it) are the caller's tri-state judgements and are never decided here; Art 82(2) is read as the controller limb (involvement in the processing) and the processor limb (a breach of processor obligations or acting outside or contrary to lawful instructions), both crisp statements of the caller; the Art 82(3) exemption is an attested outside fact that the order copies and never assesses. Answers are right_not_established, not_liable_for_damage, exempt_from_liability or liable_for_damage, or a non-final indeterminate([KEY]), needs_legal_review (open_textured or cross_reference_unresolved) or input_problems. Out of scope: the amount of compensation, joint liability for the entire damage and recourse (Art 82(4) and (5), deferred), the competent court (Art 82(6) and Art 79, deferred or excluded), fines (Arts 83 and 84), who is a controller or processor (Art 4(7), ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-11-12 | `1c7185b3977928ee...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_compensation_and_liability){ .md-button }

## Provisions deferred, and what follows

??? info "joint_liability_for_the_entire_damage"

    **Why:** Art 82(4) makes each controller or processor involved in the same processing liable for the entire damage where they are responsible under paragraphs 2 and 3. The order answers for ONE party; it does not model several parties or the entire-damage rule (Q6).

    **Consequence for a user:** liable_for_damage never says that the caller is liable for the entire damage or only for a part of it.

??? info "recourse_between_those_involved"

    **Why:** Art 82(5) entitles a party that has paid full compensation to claim back from the others the part corresponding to their part of responsibility. It is a claim between parties after payment and no limb of this order reads it.

    **Consequence for a user:** The answers never say whether or how much a party may claim back.

