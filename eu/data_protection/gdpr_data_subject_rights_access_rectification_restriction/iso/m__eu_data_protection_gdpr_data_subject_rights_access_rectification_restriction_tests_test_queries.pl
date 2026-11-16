% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_queries, [gdpr_data_subject_rights_access_rectification_restriction_profile_keys/1, gdpr_data_subject_rights_access_rectification_restriction_what_if/4, gdpr_data_subject_rights_access_rectification_restriction_compliance_check/2, gdpr_data_subject_rights_access_rectification_restriction_justification/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_fixtures, [gdpr_data_subject_rights_access_rectification_restriction_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_keys(ProfileKeys),
    ProfileKeys == [request_type, objection_ground_claimed, request_received_on, extension_claimed, controller_demonstrates_unable_to_identify_data_subject, identity_confirmed, personal_data_inaccurate, consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, accuracy_contested_by_data_subject, data_subject_opposes_erasure, data_required_by_data_subject_for_legal_claims, verification_of_overriding_grounds_pending, personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means, processing_based_on_art6_1_e_or_f, processing_for_direct_marketing, processing_for_research_or_statistics_pursuant_to_art89_1, data_subject_gave_explicit_consent, decision_based_on_special_categories, special_category_condition_and_safeguards_met_for_decision, personal_data_disclosed_to_recipients, data_subject_asks_who_the_recipients_are, extension_necessary_for_complexity_and_number, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, personal_data_incomplete_in_light_of_purposes, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed, processing_necessary_for_freedom_of_expression_and_information, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives, processing_necessary_for_legal_claims, controller_no_longer_needs_data_for_processing_purposes, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects, decision_necessary_for_contract_with_data_subject, recipient_notification_impossible_or_disproportionate_effort, legislative_restriction_applies_to_the_right, erasure_required_by_union_or_member_state_law, processing_required_by_union_or_member_state_law, decision_authorised_by_union_or_member_state_law, public_holidays].
test(compliance_check_must_comply) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_plain, Profile),
    findall(Outcome, gdpr_data_subject_rights_access_rectification_restriction_compliance_check(Profile, Outcome), Outcomes),
    Outcomes == [controller_must_comply].
test(compliance_check_need_not_comply) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_unfounded, Profile),
    gdpr_data_subject_rights_access_rectification_restriction_compliance_check(Profile, controller_need_not_comply).
test(compliance_check_suspended) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_identity_suspended, Profile),
    gdpr_data_subject_rights_access_rectification_restriction_compliance_check(Profile, suspended_pending_identity).
test(compliance_check_undetermined) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(restriction_verification_unknown, Profile),
    gdpr_data_subject_rights_access_rectification_restriction_compliance_check(Profile, undetermined).
test(compliance_check_legal_review) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_unfounded_unsure, Profile),
    gdpr_data_subject_rights_access_rectification_restriction_compliance_check(Profile, legal_review_required).
test(compliance_check_input_problems) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(profile_with_unknown_key, Profile),
    gdpr_data_subject_rights_access_rectification_restriction_compliance_check(Profile, input_problems_found).
test(justification_carries_cite_provenance_per_item) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_plain, Profile),
    gdpr_data_subject_rights_access_rectification_restriction_justification(Profile, Items),
    Items == [item(right_engaged, met, cite(eu_reg_2016_679_art_15_1)), item(art12_5_manifestly_unfounded_or_excessive, unmet, cite(eu_reg_2016_679_art_12_5)), item(art12_2_unable_to_identify, unmet, cite(eu_reg_2016_679_art_12_2)), item(art23_legislative_restriction, unmet, cite(eu_reg_2016_679_art_23_1)), item(art12_6_identity_not_confirmed, unmet, cite(eu_reg_2016_679_art_12_6))].
test(justification_shows_the_met_exception) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_unfounded, Profile),
    gdpr_data_subject_rights_access_rectification_restriction_justification(Profile, [_, item(art12_5_manifestly_unfounded_or_excessive, met, cite(eu_reg_2016_679_art_12_5))|_]).
test(what_if_overrides_an_existing_key) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_not_unfounded, Profile),
    gdpr_data_subject_rights_access_rectification_restriction_what_if(Profile, request_manifestly_unfounded_or_excessive, true, need_not_comply).
test(what_if_adds_a_missing_key) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(rectification_not_engaged, Profile),
    gdpr_data_subject_rights_access_rectification_restriction_what_if(Profile, personal_data_inaccurate, true, must_comply).
test(what_if_yields_one_answer) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_plain, Profile),
    findall(Comply, gdpr_data_subject_rights_access_rectification_restriction_what_if(Profile, identity_confirmed, false, Comply), Answers),
    Answers == [must_comply].

test(compliance_check_is_not_the_wrong_outcome, fail) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_plain, Profile),
    gdpr_data_subject_rights_access_rectification_restriction_compliance_check(Profile, controller_need_not_comply).
test(what_if_flips_the_answer, fail) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_plain, Profile),
    gdpr_data_subject_rights_access_rectification_restriction_what_if(Profile, request_manifestly_unfounded_or_excessive, true, must_comply).

cp_test_names([profile_keys_are_the_contract_keys, compliance_check_must_comply, compliance_check_need_not_comply, compliance_check_suspended, compliance_check_undetermined, compliance_check_legal_review, compliance_check_input_problems, justification_carries_cite_provenance_per_item, justification_shows_the_met_exception, what_if_overrides_an_existing_key, what_if_adds_a_missing_key, what_if_yields_one_answer]).
cp_test_fail_names([compliance_check_is_not_the_wrong_outcome, what_if_flips_the_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
