# Regulation (EU) 2016/679 (GDPR), three entry points over one attribute-list profile. ENTRY 1: whether a controller (Art 30(1)) or a processor (Art 30(2)), or both, owes ...

`eu/data_protection/gdpr_records_and_officer`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 200/200 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2016/679 (GDPR), three entry points over one attribute-list profile. ENTRY 1: whether a controller (Art 30(1)) or a processor (Art 30(2)), or both, owes a record of processing activities for ONE processing activity, given the Art 30(5) exemption below 250 persons employed and its four triggers (a risk, not occasional, special categories, criminal offence data), and which content items of Art 30(1)(a)-(g) and Art 30(2)(a)-(d) the record lacks. ENTRY 2: whether a data protection officer must be designated under the three limbs of Art 37(1) or because Union or Member State law requires it (Art 37(4), an attested outside fact), and which of the Art 39(1) tasks the officer's mandate lacks. ENTRY 3: whether the position of the officer meets one duty of Art 38(1), (2), (3) or (6), each read from an attested outside fact or, for the conflict of interests, the user's judgement. Open-textured terms (risk, occasional, core activity, large scale, where possible, conflict of interests) are the user's judgements and an unsure one is referred to a lawyer; whether an entity is a public authority or body and the content of national law are outside facts. Out of scope: the ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `c44dc232a4ef4465...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `be94a9b44f8186dd...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `6503fa23a111b142...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `7da4f49d8c83a3f8...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `221151c87a3c2008...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_records_and_officer){ .md-button }

## Provisions deferred, and what follows

??? info "art4_7_8_18_definitions_as_context"

    **Why:** Points (7), (8) and (18) are quoted as the context of the two role flags acts_as_controller and acts_as_processor (Art 4(7), (8); open question Q5) and of the words 'an enterprise or an organisation' of Art 30(5) (Art 4(18)), which are read as covering every caller (open question Q28); the order has no enterprise flag. Whether the caller is a controller, a processor or both is stated by the user through the two role flags, not derived.

    **Consequence for a user:** The answers take the two role flags as given: the caller must decide under Art 4(7) and (8) itself whether it is a controller, a processor or both, and is taken to be an enterprise or an organisation within Art 30(5) without being asked.

??? info "art38_5_officer_secrecy_under_union_or_member_state_law"

    **Why:** Art 38(5): the officer is bound by secrecy or confidentiality concerning the performance of the tasks, in accordance with Union or Member State law. The content of the secrecy duty is the law of the Union or of the Member State, which this order does not formalize.

    **Consequence for a user:** The answers do not say whether the officer is bound by secrecy or what it covers: the caller must read the applicable Union or Member State law itself.

??? info "art30_1_c_two_descriptions"

    **Why:** Item (c) asks for a description of the categories of data subjects AND of the categories of personal data; the profile carries one flag for both (open question Q12).

    **Consequence for a user:** One flag stands for both descriptions: the caller must set it false when either the categories of data subjects or the categories of personal data are missing from the record.

??? info "national_designation_rules"

    **Why:** The existence of such a law is the outside fact union_or_member_state_law_requires_data_protection_officer; its content (for example a headcount threshold for persons constantly processing personal data) is not formalized.

    **Consequence for a user:** The order takes the attested answer to union_or_member_state_law_requires_data_protection_officer as given; whoever attests it must read the national law, including any threshold such as a headcount, and decide whether it requires an officer for this controller or processor.

