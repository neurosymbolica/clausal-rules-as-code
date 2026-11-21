% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_queries, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_keys/1, gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_what_if/4, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, suspended/1, input_problems/1, attested/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_kernel, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [request_decision/2, request_exception/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_request_exception, [request_exception_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_fixtures, [gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for/2]).

subject_profile(Subject, Profile) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_for(Subject, Profile).

what_if(Subject, OverriddenKey, NewValue, NewComply) :-
    subject_profile(Subject, Profile),
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_what_if(Profile, OverriddenKey, NewValue, NewComply).

test(profile_keys_are_the_contract_keys) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_keys(ProfileKeys),
    ProfileKeys == [request_type, objection_ground_claimed, request_received_on, extension_claimed, controller_demonstrates_unable_to_identify_data_subject, identity_confirmed, personal_data_inaccurate, consent_is_the_basis_of_processing, consent_withdrawn, other_legal_ground_for_processing_exists, objection_under_art21_1_made, objection_under_art21_2_made, collected_in_relation_to_information_society_services_offer, accuracy_contested_by_data_subject, data_subject_opposes_erasure, data_required_by_data_subject_for_legal_claims, verification_of_overriding_grounds_pending, personal_data_provided_by_data_subject, processing_based_on_consent_or_contract, processing_carried_out_by_automated_means, processing_based_on_art6_1_e_or_f, processing_for_direct_marketing, processing_for_research_or_statistics_pursuant_to_art89_1, data_subject_gave_explicit_consent, decision_based_on_special_categories, special_category_condition_and_safeguards_met_for_decision, personal_data_disclosed_to_recipients, data_subject_asks_who_the_recipients_are, extension_necessary_for_complexity_and_number, reasonable_doubts_about_identity, request_manifestly_unfounded_or_excessive, personal_data_incomplete_in_light_of_purposes, data_no_longer_necessary_for_purposes, overriding_legitimate_grounds_exist, personal_data_unlawfully_processed, processing_necessary_for_freedom_of_expression_and_information, processing_necessary_for_public_task_or_official_authority, processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i, processing_for_archiving_research_or_statistics_in_accordance_with_art89_1, erasure_would_render_impossible_or_seriously_impair_processing_objectives, processing_necessary_for_legal_claims, controller_no_longer_needs_data_for_processing_purposes, transmission_would_adversely_affect_rights_and_freedoms_of_others, objection_grounds_relate_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds, decision_based_solely_on_automated_processing, decision_produces_legal_or_similarly_significant_effects, decision_necessary_for_contract_with_data_subject, recipient_notification_impossible_or_disproportionate_effort, legislative_restriction_applies_to_the_right, erasure_required_by_union_or_member_state_law, processing_required_by_union_or_member_state_law, decision_authorised_by_union_or_member_state_law, public_holidays].
test(there_are_fifty_four_profile_keys) :-
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_profile_keys(ProfileKeys),
    length(ProfileKeys, 54).
test(compliance_check_answers_once) :-
    subject_profile(portability_engaged_must_comply, Profile),
    findall(Comply, request_decision(Profile, Comply), Answers),
    Answers == [must_comply].
test(exception_field_answers_once) :-
    subject_profile(portability_public_task_relieves, Profile),
    findall(Exception, request_exception(Profile, Exception), Answers),
    Answers == [art20_3_public_task].
test(input_check_is_empty_for_a_good_profile) :-
    subject_profile(portability_engaged_must_comply, Profile),
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems(Profile, []).
test(input_check_lists_the_problems) :-
    subject_profile(duplicate_and_unknown_keys, Profile),
    gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_input_problems(Profile, [duplicate_key(request_type), unknown_key(colour)]).
test(what_if_a_public_task_relieves) :-
    what_if(portability_engaged_must_comply, processing_necessary_for_public_task_or_official_authority, true, need_not_comply).
test(what_if_replaces_an_existing_key_without_a_duplicate) :-
    what_if(portability_public_task_relieves, processing_necessary_for_public_task_or_official_authority, false, must_comply).
test(what_if_breaking_a_conjunct_disengages) :-
    what_if(portability_engaged_must_comply, processing_carried_out_by_automated_means, false, need_not_comply).
test(what_if_an_unsure_judgement_refers) :-
    what_if(portability_engaged_must_comply, transmission_would_adversely_affect_rights_and_freedoms_of_others, unsure, needs_legal_review(open_textured(transmission_would_adversely_affect_rights_and_freedoms_of_others, cite(eu_reg_2016_679_art_20_4)), _)).
test(what_if_a_bad_value_is_an_input_problem) :-
    what_if(portability_engaged_must_comply, processing_carried_out_by_automated_means, unsure, input_problems([wrong_type(processing_carried_out_by_automated_means)])).
test(what_if_answers_once) :-
    subject_profile(portability_engaged_must_comply, Profile),
    findall(Comply, gdpr_data_subject_rights_articles_20_to_22_decision_and_exception_what_if(Profile, request_manifestly_unfounded_or_excessive, true, Comply), Answers),
    Answers == [need_not_comply].
test(checklist_names_the_met_exception_with_its_citation) :-
    subject_profile(objection_article_21_1_legal_claims, Profile),
    request_exception_checklist(Profile, ChecklistItems),
    member(item(exception(objection(art21_1), art21_1_legal_claims), met, cite(eu_reg_2016_679_art_21_1)), ChecklistItems).
test(checklist_marks_the_open_limb_unknown) :-
    subject_profile(automated_decision_special_category_safeguards_missing, Profile),
    request_exception_checklist(Profile, ChecklistItems),
    member(item(exception(automated_decision, art22_2_c), unknown([special_category_condition_and_safeguards_met_for_decision]), cite(eu_reg_2016_679_art_22_2_c)), ChecklistItems).
test(indeterminate_recognises_a_non_empty_list) :-
    indeterminate([request_type]).
test(needs_legal_review_recognises_a_referral) :-
    needs_legal_review(open_textured(request_manifestly_unfounded_or_excessive, cite(eu_reg_2016_679_art_12_5)), [inputs_relied_on([request_type - portability])]).
test(open_textured_recognises_a_cite_term) :-
    open_textured(reasonable_doubts_about_identity, cite(eu_reg_2016_679_art_12_6)).
test(inputs_relied_on_recognises_pairs) :-
    inputs_relied_on([request_type - portability]).
test(suspended_recognises_the_art12_6_reason) :-
    suspended(art12_6_identity_not_confirmed).
test(input_problems_recognises_a_problem_list) :-
    input_problems([unknown_key(colour)]).
test(attested_recognises_an_attestation) :-
    attested(true, attestation(by, at, reason, none)).

test(what_if_without_change_keeps_the_answer, fail) :-
    what_if(portability_engaged_must_comply, processing_carried_out_by_automated_means, true, need_not_comply).
test(indeterminate_rejects_the_empty_list, fail) :-
    indeterminate([]).
test(open_textured_rejects_a_bare_key, fail) :-
    open_textured(reasonable_doubts_about_identity, eu_reg_2016_679_art_12_6).
test(suspended_rejects_another_reason, fail) :-
    suspended(identity_not_confirmed).
test(input_problems_rejects_the_empty_list, fail) :-
    input_problems([]).
test(attested_rejects_a_bare_value, fail) :-
    attested(true, none).

cp_test_names([profile_keys_are_the_contract_keys, there_are_fifty_four_profile_keys, compliance_check_answers_once, exception_field_answers_once, input_check_is_empty_for_a_good_profile, input_check_lists_the_problems, what_if_a_public_task_relieves, what_if_replaces_an_existing_key_without_a_duplicate, what_if_breaking_a_conjunct_disengages, what_if_an_unsure_judgement_refers, what_if_a_bad_value_is_an_input_problem, what_if_answers_once, checklist_names_the_met_exception_with_its_citation, checklist_marks_the_open_limb_unknown, indeterminate_recognises_a_non_empty_list, needs_legal_review_recognises_a_referral, open_textured_recognises_a_cite_term, inputs_relied_on_recognises_pairs, suspended_recognises_the_art12_6_reason, input_problems_recognises_a_problem_list, attested_recognises_an_attestation]).
cp_test_fail_names([what_if_without_change_keeps_the_answer, indeterminate_rejects_the_empty_list, open_textured_rejects_a_bare_key, suspended_rejects_another_reason, input_problems_rejects_the_empty_list, attested_rejects_a_bare_value]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
