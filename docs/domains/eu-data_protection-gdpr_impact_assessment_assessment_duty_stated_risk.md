# GDPR Article 35, split order of 2026-11-03 as amended 2026-11-18. Entry A (decide_impact_assessment_duty/2) decides whether a data protection impact assessment is ...

`eu/data_protection/gdpr_impact_assessment_assessment_duty_stated_risk`

!!! warning "Disclaimer"
    These rules are drafted readings derived from the cited statutes. They were generated and tested by automated processes. They are not legal advice and have not been validated by a lawyer. Where a domain lists open questions or alternative readings, they are listed in that domain. The statute text prevails: the code is subsidiary to the statutes.

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 209/209 | none (no provision-tracking ledger) | pass | pass | pass |

## Scope

GDPR Article 35, split order of 2026-11-03 as amended 2026-11-18. Entry A (decide_impact_assessment_duty/2) decides whether a data protection impact assessment is required (Art 35(1) on the user's stated high-risk judgement, the always-required cases of Art 35(3)(a)-(c), the supervisory authority lists of Art 35(4) and (5) as attested outside facts, and the Art 35(10) legal-basis exemption, which outranks every trigger) and, when it is required, which Art 35(7)(a)-(d) minimum contents are missing. Entry O (impact_assessment_officer_advice/2) decides whether a controller that carried out an assessment and has designated a data protection officer sought that officer's advice (Art 35(2)). Open-textured judgements are the user's and an unsure one is referred to a lawyer; an absent Member State decision under Art 35(10) is referred as an unresolved cross-reference. Out of scope: prior consultation (Art 36), the proof routes, assessment bases and status queries of the sibling split orders, whether an officer had to be designated (Art 37), the competent authority (Arts 55, 56), the content of national lists or laws, and Art 35(8), (9) and (11).

## Sources

The statute text is not reproduced here. Read it at National data protection authority pages (CNIL, Data Protection Commission Ireland, Datenschutzkonferenz):

| Instrument | Link | Last read |
|---|---|---|
| 02016R0679-20160504.ENG.fmx4 | <http://publications.europa.eu/resource/celex/02016R0679-20160504.ENG.fmx4> | 2026-09-05 |
| 20181017_ah_DSK_DSFA_Muss-Liste_Version_1.1_Deutsch.pdf | <https://www.datenschutzkonferenz-online.de/media/ah/20181017_ah_DSK_DSFA_Muss-Liste_Version_1.1_Deutsch.pdf> | 2026-11-07 |
| Data-Protection-Impact-Assessment.pdf | <https://www.dataprotection.ie/sites/default/files/uploads/2018-11/Data-Protection-Impact-Assessment.pdf> | 2026-11-07 |
| liste-traitements-aipd-non-requise.pdf | <https://www.cnil.fr/sites/default/files/atoms/files/liste-traitements-aipd-non-requise.pdf> | 2026-11-07 |
| liste-traitements-aipd-requise.pdf | <https://www.cnil.fr/sites/default/files/atoms/files/liste-traitements-aipd-requise.pdf> | 2026-11-07 |

[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/data_protection/gdpr_impact_assessment_assessment_duty_stated_risk){ .md-button }

## Provisions deferred, and what follows

??? info "definitions_not_applied"

    **Why:** Art 4 is pinned whole because the smallest document element that contains Art 4(4) is the article. Only point (4), profiling, is read (it explains the flag automated_evaluation_including_profiling). The other points define terms (personal data, processing, controller, processor, consent, personal data breach, ...) that no limb reads: the profile states the facts in those terms already.

    **Consequence for a user:** whether the data is personal data and who the controller is are not tested. The caller must establish both itself (Art 4(1) and Art 4(7)) before relying on any answer.

??? info "art6_lawful_basis"

    **Why:** Art 35(10) refers to [quotation omitted] [quotation omitted]); whether the processing rests on those points is the crisp flag lawful_basis_is_legal_obligation_or_public_task, determined by the sibling eu/data-protection/gdpr-art6-lawfulness.

    **Consequence for a user:** The order takes lawful_basis_is_legal_obligation_or_public_task as stated; the caller must establish under Art 6(1)(c) or (e) itself (for example with the sibling Article 6 order) whether the processing rests on those points, because the flag decides whether the Art 35(10) exemption can apply.

??? info "special_categories_and_criminal_data_meaning"

    **Why:** Art 35(3)(b) refers to them; whether the data is of those kinds is the crisp flags special_category_data_processed and criminal_offence_data_processed (sibling eu/data-protection/gdpr-special-categories).

    **Consequence for a user:** The order takes special_category_data_processed and criminal_offence_data_processed as stated; the caller must decide under Art 9(1) and Art 10 itself whether the data is of those kinds, collapsing any judgement of the sibling special-categories order to true or false first.

??? info "member_state_and_authority_law_content"

    **Why:** The existence of the list or law as it applies to this processing is an outside fact (attested; fetcher none); its content is not formalized here.

    **Consequence for a user:** The caller must find the supervisory authority list or the Union or Member State law itself and attest whether it applies to this processing; the answer copies the attestation and never checks the content of the list or law.

??? info "profiling_definition_read_through_the_flag"

    **Why:** Art 4(4) defines profiling; the order uses it for reasoning only and never cites it in a verdict (reading (11)). No limb tests the definition: whether the evaluation is automated processing including profiling is the crisp flag automated_evaluation_including_profiling, stated by the caller in the sense of Art 4(4).

    **Consequence for a user:** The answers do not check whether the processing meets the Art 4(4) definition of profiling; the caller must apply Art 4(4) itself before setting automated_evaluation_including_profiling.

