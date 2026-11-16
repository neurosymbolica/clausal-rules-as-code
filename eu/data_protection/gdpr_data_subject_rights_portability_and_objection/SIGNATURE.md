# SIGNATURE — eu/data_protection/gdpr_data_subject_rights_portability_and_objection

Predicate prefix: gdpr_data_subject_rights_portability_and_objection_. Shape family: deontic. Layout: kernel -> citations -> parameters -> request_basis -> queries -> fixtures -> package facade.

Public surface: decide_data_subject_request/2 gives the whole verdict. request_basis/2 gives the BASIS field. The input check gives the problems. The scaffold facade names are kept as thin delegates over the same single-solution pipeline. All profile reads use profile_get/3 from formalize_lib by atom key, presence first, then value. Every query is total and deterministic: exactly ONE solution per profile.

## Verdict STATUS atoms (replace scaffold placeholders required / permitted / not_applicable)

Verdict term: gdpr_data_subject_request_verdict(COMPLY, BASIS, EXCEPTION, CONDITIONS, CITATIONS).

- COMPLY: must_comply | need_not_comply | indeterminate(MISSING_KEYS) | needs_legal_review(REASON, CONTEXT) | suspended(art12_6_identity_not_confirmed) | input_problems(PROBLEMS). The bare atom indeterminate is never written.
- REASON: open_textured(INPUT, cite(KEY)). CONTEXT: [inputs_relied_on(PAIRS)], optionally with a trailing provenance(CLAUSE, CITATIONS).
- BASIS: art20_1 | art21_1 | art21_2 | art21_6 | none.
- EXCEPTION: art20_3_public_task | art20_4_rights_of_others | art21_1_compelling_legitimate_grounds | art21_1_legal_claims | art21_6_public_interest_task | art12_5_manifestly_unfounded_or_excessive | art12_2_unable_to_identify | art23_legislative_restriction | none.
- CONDITIONS: [reasonable_fee_may_be_charged] | [].
- Constructors (exported, never queried): gdpr_data_subject_request_verdict/5, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, suspended/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, attested/2, attestation/4, url/2, document/2.
- Checklist item statuses (formalize_lib vocabulary): met, unmet(Reason), unknown(Keys).

## Profile keys (exactly 54; atoms; dates as date(Year, Month, Day))

ATOM keys:
- request_type: access | rectification | erasure | restriction | portability | objection | automated_decision. Required. Only portability and objection are decided here.
- objection_ground_claimed: art21_1 | art21_2 | art21_6. Read only for objection, then required.

DATE key (read by no kept query, checked by the input check):
- request_received_on: ground date(Year, Month, Day), a real calendar day.

CRISP flags (25; atoms true or false):
- extension_claimed
- controller_demonstrates_unable_to_identify_data_subject
- identity_confirmed
- personal_data_inaccurate
- consent_is_the_basis_of_processing
- consent_withdrawn
- other_legal_ground_for_processing_exists
- objection_under_art21_1_made
- objection_under_art21_2_made
- collected_in_relation_to_information_society_services_offer
- accuracy_contested_by_data_subject
- data_subject_opposes_erasure
- data_required_by_data_subject_for_legal_claims
- verification_of_overriding_grounds_pending
- personal_data_provided_by_data_subject
- processing_based_on_consent_or_contract
- processing_carried_out_by_automated_means
- processing_based_on_art6_1_e_or_f
- processing_for_direct_marketing
- processing_for_research_or_statistics_pursuant_to_art89_1
- data_subject_gave_explicit_consent
- decision_based_on_special_categories
- special_category_condition_and_safeguards_met_for_decision
- personal_data_disclosed_to_recipients
- data_subject_asks_who_the_recipients_are

JUDGEMENT inputs (21; true, false or unsure):
- extension_necessary_for_complexity_and_number
- reasonable_doubts_about_identity
- request_manifestly_unfounded_or_excessive
- personal_data_incomplete_in_light_of_purposes
- data_no_longer_necessary_for_purposes
- overriding_legitimate_grounds_exist
- personal_data_unlawfully_processed
- processing_necessary_for_freedom_of_expression_and_information
- processing_necessary_for_public_task_or_official_authority
- processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i
- processing_for_archiving_research_or_statistics_in_accordance_with_art89_1
- erasure_would_render_impossible_or_seriously_impair_processing_objectives
- processing_necessary_for_legal_claims
- controller_no_longer_needs_data_for_processing_purposes
- transmission_would_adversely_affect_rights_and_freedoms_of_others
- objection_grounds_relate_to_particular_situation
- controller_demonstrates_compelling_legitimate_grounds
- decision_based_solely_on_automated_processing
- decision_produces_legal_or_similarly_significant_effects
- decision_necessary_for_contract_with_data_subject
- recipient_notification_impossible_or_disproportionate_effort

OUTSIDE FACTS (5; each attested(VALUE, attestation(BY, AT, REASON, EVIDENCE))):
- erasure_required_by_union_or_member_state_law (read by no kept query)
- processing_required_by_union_or_member_state_law (read by no kept query)
- decision_authorised_by_union_or_member_state_law (read by no kept query)
- legislative_restriction_applies_to_the_right (BLOCKING; absent is UNMET)
- public_holidays (value is a list of ground date terms; read by no kept query)

Defeater keys (only a present true counts): controller_demonstrates_unable_to_identify_data_subject, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, every exception key (processing_necessary_for_public_task_or_official_authority, transmission_would_adversely_affect_rights_and_freedoms_of_others, controller_demonstrates_compelling_legitimate_grounds, processing_necessary_for_legal_claims), extension_claimed, data_subject_asks_who_the_recipients_are, decision_based_on_special_categories. All other keys read by a limb are REQUIRED (absent means indeterminate).

## Citation-key atoms (citation_vocabulary, in this order; never shortened)

cite(art_12_2), cite(art_12_5), cite(art_12_6), cite(art_20_1), cite(art_20_3), cite(art_20_4), cite(art_21_1), cite(art_21_2), cite(art_21_3), cite(art_21_6), cite(art_23_1).

Used only in referral REASONs: art_12_6 (row identity_doubts_reasonable). Referrals table, to be confirmed against the scaffold's referrals block:
- reasonable_doubts_about_identity -> art_12_6
- request_manifestly_unfounded_or_excessive -> art_12_5
- processing_necessary_for_public_task_or_official_authority -> art_20_3 (portability) / art_21_6 (objection art21_6)
- transmission_would_adversely_affect_rights_and_freedoms_of_others -> art_20_4
- objection_grounds_relate_to_particular_situation -> art_21_1 (art21_1) / art_21_6 (art21_6)
- controller_demonstrates_compelling_legitimate_grounds -> art_21_1
- processing_necessary_for_legal_claims -> art_21_1

CITATIONS mapping: right art_20_1 for portability; objection art_21_1, or art_21_2 together with art_21_3, or art_21_6 by objection_ground_claimed. With BASIS none the article-level cite is given alone. Exceptions add: art20_3_public_task -> art_20_3; art20_4_rights_of_others -> art_20_4; art21_1_compelling_legitimate_grounds and art21_1_legal_claims -> art_21_1; art21_6_public_interest_task -> art_21_6; art12_5 -> art_12_5; art12_2 -> art_12_2; art23_legislative_restriction -> art_23_1.

## Public predicates

- decide_data_subject_request(Profile, Verdict): the whole verdict, one solution per profile. Arts 12(2), 12(5), 12(6), 20(1), 20(3), 20(4), 21(1), 21(2), 21(3), 21(6), 23(1).
- request_basis(Profile, Basis): the BASIS field (none for every non-final COMPLY). Arts 20(1), 21.
- gdpr_data_subject_rights_portability_and_objection_input_problems(Profile, Problems): input check. Gives [] for a well-formed profile. Otherwise it gives duplicate_key, wrong_type or unknown_key, in contract order and then by first occurrence. A non-list profile gives [wrong_type(profile)].
- decide_request_basis(Profile, Verdict): scaffold facade, delegates to decide_data_subject_request/2.
- request_basis_status(Profile, Comply): scaffold facade, the COMPLY field only.
- request_basis_checklist(Profile, Checklist): query type #7 justification. Items item(Id, Status, cite(Key)) for engagement, each exception, the suspension and the input check. Met items carry cite too.
- compliance_check_request_basis(Profile, Action, Verdict): query type #13 compliance_check. Is the proposed controller action (comply or refuse_to_act) allowed in the current state? Built on kit.compliance_lib compliance_check/7. The duty norm fires on must_comply and the permission norm on need_not_comply, with deny-overrides and a CWA-parameterised combining world.
- gdpr_data_subject_rights_portability_and_objection_what_if(Profile, Key, Value, Verdict): override one key and re-decide, via query_combinators what_if/5.
- fixtures: fixture/2 profiles, one per route (input problem, absent type, not engaged, each exception, suspension, indeterminate, referral, must_comply).

Not exported: response_deadline/3, request_response_deadline/2, request_outside_facts/2.

## Slice: request_basis.clausal

Statutory VALUE facts owned (all local to this file, no shared constants file):
- Request types in scope: [portability, objection].
- Engagement table: portability -> {personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means}, BASIS art20_1. objection/art21_1 -> {processing_based_on_art6_1_e_or_f, objection_grounds_relate_to_particular_situation}, BASIS art21_1. objection/art21_2 -> {processing_for_direct_marketing}, BASIS art21_2. objection/art21_6 -> {processing_for_research_or_statistics_pursuant_to_art89_1, objection_grounds_relate_to_particular_situation}, BASIS art21_6.
- Exception table in test order: portability [art20_3_public_task, art20_4_rights_of_others]. objection/art21_1 [art21_1_compelling_legitimate_grounds, art21_1_legal_claims]. objection/art21_2 []. objection/art21_6 [art21_6_public_interest_task]. Common, appended for every type: art12_5, art12_2, art23_legislative_restriction.
- Suspension: SUSP = reasonable_doubts_about_identity AND NOT identity_confirmed.
- Condition table: art12_5 -> [reasonable_fee_may_be_charged]; every other exception -> [].
- No numeric threshold or period lives here (the Art 12(3) periods are deferred).

Rules (each an independent requirement(RequirementId, Profile, Status, Citation), each check with three mutually exclusive clauses met / unmet / unknown, no cut):
- engagement_art20_1, engagement_art21_1, engagement_art21_2, engagement_art21_6.
- exception_art20_3, exception_art20_4, exception_art21_1_compelling, exception_art21_1_legal_claims, exception_art21_6_public_task, exception_art12_5, exception_art12_2, exception_art23 (outside fact attested true is MET, false or absent is UNMET).
- suspension_art12_6.
- Defeaters are guarded once/1 goals reading present-and-true only, cut-free.

Verdict atoms: as in the STATUS section. Decision steps (0), (i)-(v) in the order of the notes. Each step is its own clause with a guard that excludes the earlier steps, and the verdict is folded into the clause head (one clause per disjoint route).

SHARED with other slices (kernel.clausal): none beyond the result constructors and the contract key lists (the 54 keys by group, in root_exports order). Only one determination slice exists. The tri-state engine is imported from formalize_lib, not redefined.

## Planned reuse (manifest uses:)

- formalize_lib: profile_get/3, profile_has/2, profile_lacks/2, check_tri/4, check_tri_neg/4, check_true/4, check_false/4, and_status/2, or_status/2, missing_keys/3, assess/6, eval_requirements/4, decide_labeled/3, not_defeated/3, memberd/2, not_member/2. Requirement closure: requirement/4 (RequirementId first).
- kit.compliance_lib: compliance_check/7, nm/2, resolve_modality/3, fired_norms/3, collect_ctd/4, for query #13.
- kit.query_combinators: what_if/5 for the what_if/4 facade, diff_checklists/3 for the checklist diff.
- kit.deadline_lib: month_last_day/3 only, to validate that date(Y, M, D) and public_holidays entries are real calendar days in the input check. No deadline arithmetic.
- validate_props: run_props/1, prop_totality/3, prop_determinism/3, prop_citation_complete/3, prop_missing_key_coverage/3 for the seven test modes.
- Not used: currency_vocab, vat_category, country, rolling_window, date_time (no dates are computed).
