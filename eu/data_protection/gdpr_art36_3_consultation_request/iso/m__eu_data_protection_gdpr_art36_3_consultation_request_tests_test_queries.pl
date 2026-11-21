% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_queries, [gdpr_art36_3_consultation_request_profile_keys/1, gdpr_art36_3_consultation_request_what_if/4, consultation_request_complete/0, not_governed_by_article_36_3/0]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_kernel, [gdpr_art36_3_consultation_request_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_gdpr_art36_3_consultation_request, [consultation_request_status/4, missing_consultation_request_items/4, gdpr_art36_3_consultation_request_status/2, gdpr_art36_3_consultation_request_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_fixtures, [gdpr_art36_3_consultation_request_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_art36_3_consultation_request_profile_keys(ProfileKeys),
    ProfileKeys == [consultation_under_article_36_1, joint_controllers_or_processors_involved, respective_responsibilities_provided, purposes_and_means_provided, measures_and_safeguards_provided, data_protection_officer_designated, data_protection_officer_contact_details_provided, impact_assessment_provided, other_information_requested_by_supervisory_authority, requested_other_information_provided].
test(the_input_check_is_reexported) :-
    gdpr_art36_3_consultation_request_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(the_result_atoms_are_served) :-
    consultation_request_complete,
    not_governed_by_article_36_3.
test(compliance_check_answers_once) :-
    gdpr_art36_3_consultation_request_profile_for(complete_joint_controllers, Profile),
    findall(Result, consultation_request_status(Profile, Result, _, _), Results),
    Results == [consultation_request_complete].
test(enumeration_lists_every_missing_item_in_order) :-
    missing_consultation_request_items([attribute(consultation_under_article_36_1, true), attribute(respective_responsibilities_provided, true), attribute(purposes_and_means_provided, false), attribute(measures_and_safeguards_provided, false), attribute(data_protection_officer_designated, false), attribute(impact_assessment_provided, false), attribute(other_information_requested_by_supervisory_authority, false)], Items, _, _),
    Items == [purposes_and_means, measures_and_safeguards, data_protection_impact_assessment].
test(justification_carries_a_cite_per_point) :-
    gdpr_art36_3_consultation_request_profile_for(complete_joint_controllers, Profile),
    gdpr_art36_3_consultation_request_checklist(Profile, Items),
    findall(Citation, member(item(_, _, Citation), Items), Citations),
    Citations == [cite(eu_reg_2016_679_art_36_3_a), cite(eu_reg_2016_679_art_36_3_b), cite(eu_reg_2016_679_art_36_3_c), cite(eu_reg_2016_679_art_36_3_d), cite(eu_reg_2016_679_art_36_3_e), cite(eu_reg_2016_679_art_36_3_f)].
test(status_projection_matches_the_full_query) :-
    gdpr_art36_3_consultation_request_profile_for(incomplete_missing_assessment, Profile),
    gdpr_art36_3_consultation_request_status(Profile, Status),
    consultation_request_status(Profile, Status, _, _),
    Status == consultation_request_incomplete.
test(what_if_stating_the_responsibilities_completes_the_request) :-
    gdpr_art36_3_consultation_request_profile_for(joint_controllers_responsibilities_missing, Profile),
    findall(Status, gdpr_art36_3_consultation_request_what_if(Profile, respective_responsibilities_provided, true, Status), Statuses),
    Statuses == [consultation_request_complete].
test(what_if_no_officer_is_designated_completes_the_request) :-
    gdpr_art36_3_consultation_request_profile_for(officer_contact_details_missing, Profile),
    gdpr_art36_3_consultation_request_what_if(Profile, data_protection_officer_designated, false, Status),
    Status == consultation_request_complete.
test(what_if_the_footing_is_article_36_1_governs_the_request) :-
    gdpr_art36_3_consultation_request_profile_for(member_state_law_consultation, Profile),
    gdpr_art36_3_consultation_request_what_if(Profile, consultation_under_article_36_1, true, Status),
    Status == consultation_request_complete.
test(what_if_attesting_the_roles_resolves_the_referral) :-
    gdpr_art36_3_consultation_request_profile_for(roles_unattested_referral, Profile),
    gdpr_art36_3_consultation_request_what_if(Profile, joint_controllers_or_processors_involved, attested(true, attestation(privacy_counsel, attestation_moment, role_review, none)), Status),
    Status == consultation_request_incomplete.
test(what_if_does_not_change_the_original_answer) :-
    gdpr_art36_3_consultation_request_profile_for(joint_controllers_responsibilities_missing, Profile),
    gdpr_art36_3_consultation_request_what_if(Profile, respective_responsibilities_provided, true, _),
    gdpr_art36_3_consultation_request_status(Profile, consultation_request_incomplete).
test(what_if_with_a_wrong_value_is_an_input_problem) :-
    gdpr_art36_3_consultation_request_profile_for(complete_joint_controllers, Profile),
    gdpr_art36_3_consultation_request_what_if(Profile, impact_assessment_provided, unsure, Status),
    Status == input_problems([wrong_type(impact_assessment_provided)]).

cp_test_names([profile_keys_are_the_contract_keys, the_input_check_is_reexported, the_result_atoms_are_served, compliance_check_answers_once, enumeration_lists_every_missing_item_in_order, justification_carries_a_cite_per_point, status_projection_matches_the_full_query, what_if_stating_the_responsibilities_completes_the_request, what_if_no_officer_is_designated_completes_the_request, what_if_the_footing_is_article_36_1_governs_the_request, what_if_attesting_the_roles_resolves_the_referral, what_if_does_not_change_the_original_answer, what_if_with_a_wrong_value_is_an_input_problem]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
