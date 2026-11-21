# Three determinations under the Digital Personal Data Protection Act 2023 and the Digital Personal Data Protection Rules 2025, each asked about ONE processing activity of ...

`ind/dpdp_research_state_processing`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 196/196 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Three determinations under the Digital Personal Data Protection Act 2023 and the Digital Personal Data Protection Rules 2025, each asked about ONE processing activity of personal data on ONE reference day and each answered on its own: (a) research_exemption -- whether the Act does not apply to the processing under s 17(2)(b) read with rule 16 and Second Schedule items (a), (c), (d), (e), (f) and (h) (exempt_from_act, not_exempt, not_in_force); (b) state_processing_standards -- whether processing by the State or an instrumentality for a use under s 7(b) follows the Second Schedule standards rule 5(1) requires (follows_second_schedule, does_not_follow_second_schedule, not_applicable, not_in_force); (c) state_processing_disapplied_provisions -- which of s 8(7), s 12(2) and s 12(3) s 17(4) disapplies for processing by the State or an instrumentality. Rules 5 and 16 are read as in force from 13 May 2027 (calculated from rule 1(4)); the commencement of s 7 and s 17 is stated by the caller. Open-textured judgements (research purpose, s 7(b) use, the seven open-textured standards, State or instrumentality, decision affecting the Data Principal) are stated by the caller and referred to a ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| in-dpdp-act-2023-meity-pdf | as pinned | 2026-11-13T01:30:42+00:00 | `129cc61020383c64...` |
| in-dpdp-rules-2025-meity-pdf | as pinned | 2026-11-13T01:33:08+00:00 | `5f329709043da4ea...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/ind/dpdp_research_state_processing){ .md-button }

## Provisions deferred, and what follows

??? info "heading_of_rule_5"

    **Why:** The heading of rule 5 (processing of personal data for provision or issue of subsidy, benefit, service, certificate, licence or permit by State and its instrumentalities) is cited by no limb; reading (11) relies on it to read processing 'under this rule' as processing by the State or an instrumentality for a use under s 7(b) (Q5).

    **Consequence for a user:** state_processing_standards gives not_applicable when processing_for_section_7_b_use is false; under the wider reading of Q5 some of those answers would read the standards instead.

??? info "other_certain_legitimate_uses"

    **Why:** The lead-in words of s 7 and its clauses (a) and (c) to (i), with the Explanation to clause (h) (which names the Disaster Management Act 2005, not pinned: see that instrument), are the other certain legitimate uses; they are read by the sibling order on this Act, notice and consent (ind/dpdp-notice-consent), not here. Only s 7(b), which rule 5 governs, is read (reading (11)).

    **Consequence for a user:** state_processing_standards reads no use other than s 7(b): processing on another ground gives not_applicable when the caller says processing_for_section_7_b_use is false.

??? info "branches_of_section_7_b"

    **Why:** The two branches of s 7(b) (earlier consent; data in a notified State database) are read inside the judgement processing_for_section_7_b_use (reading (11), Q5).

    **Consequence for a user:** The answers never say which branch of s 7(b) applied.

??? info "other_exemptions_of_section_17_1"

    **Why:** s 17(1) disapplies Chapter II (except s 8(1) and (5)), Chapter III and s 16 in six cases (legal claims; courts and regulators; offences; foreign Data Principals under a contract; schemes of arrangement; defaulters' financial information), with an Explanation that takes two terms from the Insolvency and Bankruptcy Code 2016 (not pinned: see that instrument) and an Illustration. Not formalised here by the law agent's scope (asia-privacy-law, 2026-11-16); a later order if wanted (reading (18), Q11).

    **Consequence for a user:** not_exempt and the other answers never say whether s 17(1) exempts the processing.

??? info "exemptions_by_notification"

    **Why:** s 17(2)(a), s 17(3) with its Explanation and s 17(5) each turn on a Central Government notification, none of which is pinned or has been seen: see the notification (reading (18), Q11).

    **Consequence for a user:** not_exempt and the other answers never say whether a notified exemption applies.

??? info "meanings_in_rule_5_2"

    **Why:** Rule 5(2) says what a subsidy, benefit, service, certificate, licence or permit provided or issued 'under law', 'under policy' or 'using public funds' means in rule 5 and the Second Schedule; these are read inside the judgement processing_for_section_7_b_use (reading (11), Q5).

    **Consequence for a user:** The answers never say under which of the three a benefit was provided or issued.

