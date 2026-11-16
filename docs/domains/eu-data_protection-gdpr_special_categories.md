# Regulation (EU) 2016/679 (GDPR) Art 9(1)-(4) and Art 10: is the proposed processing barred by the Art 9(1) prohibition on special categories of personal data (unless the ...

`eu/data_protection/gdpr_special_categories`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 247/247 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Regulation (EU) 2016/679 (GDPR) Art 9(1)-(4) and Art 10: is the proposed processing barred by the Art 9(1) prohibition on special categories of personal data (unless the one exception claimed under Art 9(2)(a)-(j) applies, with the Art 9(3) professional-secrecy condition for point (h) and the Art 9(4) Member State further conditions for genetic, biometric and health data), or by the Art 10 limits on personal data relating to criminal convictions and offences (official authority, or authorisation by Union or Member State law with appropriate safeguards; no comprehensive register outside official authority)? eligible means only that Art 9 and Art 10 do not bar the processing. Open-textured terms are the user's judgements and the existence of Union or Member State law is an attested outside fact; both are referred, never invented. Out of scope: the Art 6 lawful basis (sibling eu/data-protection/gdpr-art6-lawfulness), the Art 7 consent conditions and withdrawal, the Art 89(1) safeguards (a judgement here), the content of national law, and Arts 5, 22(4), 35 and 37.

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02016R0679 | 2016-05-04 | 2026-09-05 | `c44dc232a4ef4465...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `88c485a8b578dd16...` |
| CELEX 02016R0679 | 2016-05-04 | 2026-10-29 | `ae93f2062ee1c17d...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_special_categories){ .md-button }

## Provisions deferred, and what follows

??? info "definitions_not_applied"

    **Why:** Art 4 is pinned whole because the smallest document element that contains Art 4(11), (13), (14) and (15) is the article. Points (1)-(10), (12) and (16)-(26) define terms (personal data, processing, controller, third party, personal data breach, main establishment, supervisory authority, ...) that no limb reads: the profile states the facts in those terms already.

    **Consequence for a user:** whether the data is 'personal data' (Art 4(1)) and who the controller is are not tested. The caller must establish both itself before relying on any answer.

??? info "art6_lawful_basis"

    **Why:** Art 9 prohibits special-category processing and Art 10 limits offence-data processing in addition to the Art 6 lawful basis; the sibling eu/data-protection/gdpr-art6-lawfulness owns that determination.

    **Consequence for a user:** eligible here does not mean lawful. The caller must still establish an Art 6(1) lawful basis itself (for example with the sibling Article 6 order), and Art 10 reaches only processing based on Article 6(1).

??? info "art_89_safeguards_for_research"

    **Why:** Art 9(2)(j) requires processing 'in accordance with Article 89(1)'; Art 89 is not pinned, so compliance is the judgement accordance_with_article_89_1.

    **Consequence for a user:** For an Art 9(2)(j) claim the answer takes accordance_with_article_89_1 as the caller's judgement; the caller must check the Art 89(1) safeguards itself before judging it true. No effect on any other claim.

??? info "member_state_law_content"

    **Why:** The existence of the law is an outside fact (attested; fetcher none); its content and the conditions it sets are not formalized here.

    **Consequence for a user:** The caller must find the Union or Member State law itself and attest whether it exists for this processing, and must check the conditions that law sets; an eligible answer does not say they are met, and an attested Art 9(4) condition refers instead of being checked.

??? info "genetic_and_biometric_definitions_stated_by_user"

    **Why:** Open question Q8: genetic data (Art 4(13)) and biometric data (Art 4(14)) are crisp flags (genetic_data_present, biometric_data_present) that the user states from the definitions; the definitions are not decomposed into their elements and no limb tests them.

    **Consequence for a user:** The caller must apply the Art 4(13) and Art 4(14) definitions itself when setting genetic_data_present and biometric_data_present; the answer takes those flags as given.

