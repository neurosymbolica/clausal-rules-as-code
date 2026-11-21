# Who must carry out advanced testing by means of threat-led penetration testing (TLPT) under Regulation (EU) 2022/2554 (DORA), and how often: Article 26(1) and Article ...

`eu/dora_tlpt`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 291/291 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

Who must carry out advanced testing by means of threat-led penetration testing (TLPT) under Regulation (EU) 2022/2554 (DORA), and how often: Article 26(1) and Article 26(8), third subparagraph, points (a) to (c), of the Regulation, and Article 2(1) and (2) of Commission Delegated Regulation (EU) 2025/1190 (the TLPT RTS). For one financial entity, tlpt_identification_basis answers whether a carve-out of Art 26(1) (an Article 16(1) entity, a microenterprise) excludes it from TLPT and otherwise whether it falls within a point (a) to (g) of Article 2(2) of the TLPT RTS (listed_for_tlpt, which is not the duty: the authority shall require TLPT unless its assessment shows it is not justified); tlpt_duty answers whether the entity, once identified by the authority, must carry out TLPT at least every three years or at the frequency the competent authority has set. Out of scope: the requirements for the test and the testers (Art 26(2) to (8), first and second subparagraphs, Article 27, Articles 7 and 15 of the TLPT RTS; order eu/dora-tlpt-testers-and-tests), the steps of the testing process (Articles 4 to 6 and 8 to 13 of the TLPT RTS; order eu/dora-tlpt-process), the authority's own ...

## Pinned sources

| Document | Version | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 32022R2554 | as pinned | 2026-11-20 | `853da4994d0f0cee...` |
| CELEX 32022R2554 | as pinned | 2026-11-20 | `a61231aed964682d...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `b2241f7e6c4bd94b...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `343a5ca69430aed9...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `c1ac8b462e5c21ee...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `248f2dfd1b38d1e3...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `29f9745d9c612592...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `fcb169e79c0ca974...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `a22ecab349adf1ab...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `b0bfe6cb4210d517...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `3d86c7f5528f94c9...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `b425ac4e530ce5a0...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `41bd924df74d36ae...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `f4db9cdc2b66544c...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `9c416e7dcfd039bc...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `b52409d601addf66...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `e8c89595af773876...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `408fe51f04337bed...` |
| CELEX 32025R1190 | as pinned | 2026-11-20 | `1178012272aa0603...` |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/dora_tlpt){ .md-button }

## Provisions deferred, and what follows

??? info "article_26_8_testers"

    **Why:** Art 26(8), third subparagraph (the competent authorities identify the financial entities required to perform TLPT), with its points (a) to (c), is formalised (readings (2), (11), (13)). Not formalised here: the first subparagraph (financial entities contract testers in accordance with Article 27, and contract external testers every three tests where they use internal testers) and the second subparagraph (significant credit institutions use only external testers). They are requirements for the testers, left to the order eu/dora-tlpt-testers-and-tests.

    **Consequence for a user:** The answers say nothing on who may test; tlpt_required does not check the testers.

??? info "rts_article_2_3_groups"

    **Why:** Art 2(3) of the TLPT RTS: where several financial entities of a group sharing ICT systems, or using the same ICT intra-group service provider, meet the criteria of Art 2(2), the TLPT authorities decide whether TLPT on an individual basis is relevant, consulting the authority of the parent undertaking. A decision of the authorities (reading (12)).

    **Consequence for a user:** listed_for_tlpt is given for each entity of such a group that meets a point; the authorities' decision reaches tlpt_duty only through identified_by_tlpt_authority_as_required_to_perform_tlpt (open question (Q11)).

??? info "rts_entry_into_force"

    **Why:** Article 17 of the TLPT RTS: entry into force on the twentieth day following publication. The publication date is not in the pinned text; the order reads no date (reading (16)).

    **Consequence for a user:** The answers take the TLPT RTS as in force (open question (Q17)).

??? info "article_26_8_assessment_points"

    **Why:** Art 26(8), third subparagraph, points (a) to (c): the impact-related factors, the financial stability concerns and the ICT risk profile on which the competent authority bases its identification. They are the authority's assessment, for which no key stands (reading (11), open question (Q12)); no citation key of the order names these points separately, and they are cited through cite(eu_reg_2022_2554_art_26_8).

    **Consequence for a user:** The assessment reaches tlpt_duty only through the caller's fact identified_by_tlpt_authority_as_required_to_perform_tlpt.

??? info "rts_article_2_1_assessment_criteria"

    **Why:** Art 2(1) of the TLPT RTS, points (a) and (b) with their sub-points and the points for the purposes of points (a)(i) and (a)(v): the criteria of the TLPT authority's assessment of impact, systemic character and ICT risk profile. They are the authority's assessment, for which no key stands (reading (11), open questions (Q10), (Q12)); they are cited through cite(eu_reg_2025_1190_art_2_1), which no citation key of the order splits by point.

    **Consequence for a user:** not_listed_for_tlpt does not mean that the entity need not carry out TLPT; the authority may still identify it on its assessment.

