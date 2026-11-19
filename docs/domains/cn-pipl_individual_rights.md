# The rights of individuals in the processing of personal information under Chapter IV of the Personal Information Protection Law of the PRC (2021 adoption text, ...

`cn/pipl_individual_rights`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 199/199 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

The rights of individuals in the processing of personal information under Chapter IV of the Personal Information Protection Law of the PRC (2021 adoption text, formalised from the Chinese), Articles 44 to 50: the right to restrict or refuse processing (Art 44), to consult and copy (Art 45(1) and (2)), transfer (Art 45(3)), correction and supplementing (Art 46), deletion (Art 47), explanation of the processing rules (Art 48), the near relatives of a deceased person (Art 49), and the handler's request mechanism, the reasons for a refusal and the individual's court action (Art 50). Nine queries, each about one request by one individual (or near relative) to one personal information handler, each answering on its own. Not decided here (caller statements or out of scope): territorial scope (Art 3) and whether the respondent is a handler (Art 73 item (1)); whether the pinned text is in force on the reference day (Art 74, later amendments not established); Articles 18(1) and 35; the national cyberspace department's transfer conditions; other laws and administrative regulations; the Civil Code's near relatives; the cross-border Articles 38 to 43; Articles 13 to 18, 25, 26, 33 to 37, 39 ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| cn-pipl-2021 | as pinned | 2026-11-13T01:31:57+00:00 | `6b553f6bf6a8f0a0...` |
| cn-pipl-2021 | as pinned | 2026-11-13T01:31:57+00:00 | `cac7a4eb94b36a0f...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/cn/pipl_individual_rights){ .md-button }

## Provisions deferred, and what follows

??? info "entry_into_force"

    **Why:** Article 74 prints the date the Law takes effect, 1 November 2021; reading (2) uses it to say what the caller's key pinned_text_in_force_on_reference_day means, and no limb cites it (a false value can also come from an amendment). Substantive words, so recorded as debt.

    **Consequence for a user:** The caller states through pinned_text_in_force_on_reference_day whether the pinned text is in force on the reference day.

??? info "pipl_articles_18_1_and_35"

    **Why:** Whether the case is one of Article 18(1) or Article 35 is a crisp caller statement (article_18_1_case, article_35_case; reading (5), Q5).

    **Consequence for a user:** The answers rely on the caller's statement.

??? info "cyberspace_department_transfer_conditions"

    **Why:** Whether the conditions are met is a crisp caller statement (cyberspace_department_transfer_conditions_met; reading (5), Q6).

    **Consequence for a user:** The answers rely on the caller's statement; the order states no condition.

??? info "other_laws_and_administrative_regulations"

    **Why:** Whether such a law provides otherwise, prescribes another deletion case or sets an unexpired retention period is a crisp caller statement (laws_or_regulations_provide_otherwise, other_deletion_case_prescribed_by_law, legal_retention_period_unexpired; readings (4), (7)).

    **Consequence for a user:** The answers rely on the caller's statements.

??? info "near_relatives_civil_code"

    **Why:** Whether the requester is a near relative is a crisp caller statement (requester_is_near_relative; reading (8), Q10).

    **Consequence for a user:** The answers rely on the caller's statement.

??? info "pipl_articles_outside_the_pin"

    **Why:** None of these is read by a limb of this order; any point that turns on one of them is outside the order (SCOPE).

    **Consequence for a user:** The answers say nothing on those articles.

??? info "later_amendments"

    **Why:** Whether a later amendment changed the pinned articles is not established (Q1).

    **Consequence for a user:** The caller states it through pinned_text_in_force_on_reference_day.

