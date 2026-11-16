# SIGNATURE - eu/data_protection/gdpr_data_subject_rights_articles_20_to_22_decision_and_exception

Predicate prefix: gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_. The package has one determination slice, request_exception.clausal, over kernel, citations, parameters, queries, fixtures and the facade. Every public query is total and deterministic: it yields exactly ONE solution per profile. No imported figure is re-declared.

## Verdict STATUS atoms (replace the scaffold placeholders required, permitted, not_applicable)

Verdict term: gdpr_data_subject_request_verdict(COMPLY, BASIS, EXCEPTION, CONDITIONS, CITATIONS).

- COMPLY: must_comply | need_not_comply | indeterminate(MissingKeys) | needs_legal_review(Reason, Context) | suspended(art12_6_identity_not_confirmed) | input_problems(Problems). The bare atom indeterminate is never written.
- Reason: open_textured(InputKey, cite(CitationKey)) | cross_reference_unresolved(cite(Citation), cite(Target)). Context: [inputs_relied_on(Pairs)] optionally followed by provenance(Clause, Citations).
- BASIS: art20_1 | art21_1 | art21_2 | art21_6 | art22_1 | none.
- EXCEPTION: art20_3_public_task | art20_4_rights_of_others | art21_1_compelling_legitimate_grounds | art21_1_legal_claims | art21_6_public_interest_task | art22_2_a | art22_2_b | art22_2_c | art12_5_manifestly_unfounded_or_excessive | art12_2_unable_to_identify | art23_legislative_restriction | none.
- CONDITIONS: [] | [reasonable_fee_may_be_charged] | [human_intervention, express_point_of_view, contest_decision].
- Checklist item status: met | unmet(Reason) | unknown(Keys). Every item carries cite(...).
- Result constructors, exported and never called as queries: indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, suspended/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, attested/2, attestation/4, url/2, document/2.

## Profile keys (exactly 54; PROFILE is an attribute list read only with profile_get/3)

- Atom keys (2): request_type (access, rectification, erasure, restriction, portability, objection, automated_decision; required) and objection_ground_claimed (art21_1, art21_2 or art21_6; read only for objection, then required). Only portability, objection and automated_decision are decided here.
- Date key (1): request_received_on, a date(Year, Month, Day) term. It is accepted by the input check and ignored.
- Crisp flags (25), each true or false: extension_claimed, controller_demonstrates_unable_to_identify_data_subject, identity_confirmed, personal_data_inaccurate, consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, accuracy_contested_by_data_subject, data_subject_opposes_erasure, data_required_by_data_subject_for_legal_claims, verification_of_overriding_grounds_pending, personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means, processing_based_on_art6_1_e_or_f, processing_for_direct_marketing, processing_for_research_or_statistics_pursuant_to_art89_1, data_subject_gave_explicit_consent, decision_based_on_special_categories, special_category_condition_and_safeguards_met_for_decision, personal_data_disclosed_to_recipients, data_subject_asks_who_the_recipients_are.
- Judgements (21), each true, false or unsure: extension_necessary_for_complexity_and_number, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, personal_data_incomplete_in_light_of_purposes, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed, processing_necessary_for_freedom_of_expression_and_information, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives, processing_necessary_for_legal_claims, controller_no_longer_needs_data_for_processing_purposes, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects, decision_necessary_for_contract_with_data_subject, recipient_notification_impossible_or_disproportionate_effort.
- Outside facts (5), each attested(true or false, attestation(By, At, Reason, Evidence)): erasure_required_by_union_or_member_state_law, processing_required_by_union_or_member_state_law, decision_authorised_by_union_or_member_state_law, legislative_restriction_applies_to_the_right, and public_holidays (a list of date(Year, Month, Day) terms, ignored here). Absent means UNMET for the blocking facts, and an absent outside fact is never named in MissingKeys.
- Defeater keys (absent counts as unmet): the exception keys, extension_claimed, controller_demonstrates_unable_to_identify_data_subject, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, data_subject_asks_who_the_recipients_are, decision_based_on_special_categories.

## Citation-key atoms (one per load-bearing article; reasoning-only provisions are excluded)

eu_gdpr_article_12_2, eu_gdpr_article_12_5, eu_gdpr_article_12_6, eu_gdpr_article_20_1, eu_gdpr_article_20_3, eu_gdpr_article_20_4, eu_gdpr_article_21_1, eu_gdpr_article_21_2, eu_gdpr_article_21_3, eu_gdpr_article_21_6, eu_gdpr_article_22_1, eu_gdpr_article_22_2, eu_gdpr_article_22_3, eu_gdpr_article_22_4, eu_gdpr_article_23_1.

CITATIONS per verdict follow the order's verdict-and-citations mapping, which the authoring phase must copy from the order text. Art 4, Art 6(1), Art 9(2), Art 11(2), Art 12(1) and Art 89(1) never appear.

## Public predicates (`name(Args): description + citation`)

- request_decision(Profile, Comply): the COMPLY field of the verdict. This is the compliance_check (#13) query. It follows the decision order of the order text. Arts 12(2), 12(5), 12(6), 20, 21, 22, 23(1).
- request_exception(Profile, Exception): the EXCEPTION field, or none for every non-final COMPLY. Arts 12(2), 12(5), 20(3), 20(4), 21(1), 21(6), 22(2), 23(1).
- gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems(Profile, Problems): the input check. It gives [] or the duplicate_key, wrong_type and unknown_key problems in contract order. Input contract G1.
- decide_request_exception(Profile, Verdict): the facade. It builds the full gdpr_data_subject_request_verdict/5 term. It is not the unexported decide_data_subject_request/2. Arts 12 to 23.
- request_exception_status(Profile, Comply): the facade status, equal to request_decision/2.
- request_exception_checklist(Profile, Checklist): the justification (#7) query. It gives item(Id, Status, cite(Citation)) rows for the engagement, the suspension and each exception in the order tested, met items included. Arts 12 to 23.
- gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_what_if(Profile, Key, Value, Result): overrides one key and re-decides, with the key validated against the 54-key schema. Based on the same articles.
- fixtures: a set of named profiles, one per verdict atom, per exception and per input problem. They are used by the seven test modes.

Not exported: decide_data_subject_request/2, response_deadline/3, request_response_deadline/2, request_outside_facts/2. The PERIOD and the decision are computed internally where a kept query depends on them.

## Slice: request_exception.clausal

- Statutory VALUE facts owned: none are numeric. The one-month and two-month periods of Art 12(3) and 12(4) are deferred with the unexported deadline relations. The owned tables are the engagement table (request_type and ground to BASIS and limbs), the exception table (request_type to ordered exceptions and defeater keys) and the condition table (Art 22(3) safeguards, reasonable_fee_may_be_charged). They live in this file.
- Rules and requirements (checklist ids): engagement_art20_1, engagement_art21_1, engagement_art21_2, engagement_art21_6, engagement_art22_1, suspension_art12_6, and the exceptions art20_3_public_task, art20_4_rights_of_others, art21_1_compelling_legitimate_grounds, art21_1_legal_claims, art21_6_public_interest_task, art22_2_a, art22_2_b, art22_2_c (each gated by the Art 22(4) bar), art12_5_manifestly_unfounded_or_excessive, art12_2_unable_to_identify, art23_legislative_restriction. Each requirement has three mutually exclusive clauses (met, unmet, unknown) with no cut. Defeaters use guarded once/1. The ground verdict outputs are folded into the clause head, one clause per disjoint route.
- Verdict atoms: those of the STATUS section above.
- Shared with another slice: nothing. Only the shared floor (the attribute and tri-state helpers, the result constructors and the cite/1 wrapper) stays in kernel.clausal.

## Planned reuse (manifest uses:)

- formalize_lib: profile_get/3, profile_has/2, profile_lacks/2, profile_keys/2, check_tri/4, check_tri_neg/4, check_true/4, check_false/4, and_status/2, or_status/2, missing_keys/3, all_present/2, assess/6 (the requirement predicate is passed as a closure called requirement(Id, Profile, Status, Citation)), not_defeated/3, memberd/2, not_member/2.
- validate_props: run_props/1, prop_totality/3, prop_determinism/3, prop_citation_complete/3, prop_missing_key_coverage/3, prop_boundary_coverage/2.
- kit.query_combinators: what_if/5 and diff_checklists/3 for the what_if and checklist-diff tests.
- library(datetime): used only to validate that request_received_on is a real calendar date. No date arithmetic.
- Not used, and why: kit.compliance_lib (the decision is a fixed cascade, not a modality lattice), kit.deadline_lib (the deadline relations are not exported), country, currency_vocab, vat_category, rolling_window (not relevant here).
