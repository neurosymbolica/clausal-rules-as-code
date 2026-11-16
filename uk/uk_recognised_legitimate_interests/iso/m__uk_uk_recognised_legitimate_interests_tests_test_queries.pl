% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_recognised_legitimate_interests_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_recognised_legitimate_interests_queries, [uk_recognised_legitimate_interests_profile_keys/1, uk_recognised_legitimate_interests_what_if/4]).
:- use_module(m__uk_uk_recognised_legitimate_interests_kernel, [uk_recognised_legitimate_interests_input_problems/2]).
:- use_module(m__uk_uk_recognised_legitimate_interests_uk_recognised_legitimate_interests, [recognised_legitimate_interest/3, compare_uk_eu_legitimate_interest_basis/5, uk_recognised_legitimate_interests_checklist/2]).
:- use_module(m__uk_uk_recognised_legitimate_interests_fixtures, [uk_recognised_legitimate_interests_profile_for/2]).

item_has_citation(item(_RequirementId, _Status, cite(Key))) :-
    atom(Key).

test(profile_keys_are_the_contract_keys) :-
    uk_recognised_legitimate_interests_profile_keys(ProfileKeys),
    ProfileKeys == [processing_by_a_public_authority_in_the_performance_of_its_tasks, processing_necessary_for_a_disclosure_in_response_to_a_request, request_states_need_for_article_6_1_e_processing_with_article_6_3_basis, processing_necessary_for_national_security_public_security_or_defence, event_is_an_emergency_within_part_2_of_the_civil_contingencies_act_2004, processing_necessary_for_responding_to_the_emergency, processing_necessary_for_detecting_investigating_or_preventing_crime_or_apprehending_or_prosecuting_offenders, processing_necessary_for_safeguarding_an_individual, individual_aged_under_18, controller_has_reasonable_cause_to_suspect_the_individual_is_at_risk, legitimate_interest_pursued_by_the_controller_or_a_third_party, processing_necessary_for_that_legitimate_interest, interests_overridden_by_data_subject_interests_or_fundamental_rights, basis_relied_on, objection_on_grounds_relating_to_particular_situation, controller_demonstrates_compelling_legitimate_grounds_that_override, processing_for_establishment_exercise_or_defence_of_legal_claims].
test(profile_keys_all_pass_the_input_check_with_a_type_value) :-
    uk_recognised_legitimate_interests_input_problems([attribute(processing_by_a_public_authority_in_the_performance_of_its_tasks, false), attribute(basis_relied_on, other_basis)], Problems),
    Problems == [].
test(status_determination_one_answer) :-
    uk_recognised_legitimate_interests_profile_for(crime_condition_met, Profile),
    findall(Result, recognised_legitimate_interest(Profile, Result, _Citations), Results),
    Results == [recognised_legitimate_interest_applies].
test(what_if_crime_condition_met_needs_the_bar) :-
    uk_recognised_legitimate_interests_profile_for(all_conditions_fail, Profile),
    findall(Status, uk_recognised_legitimate_interests_what_if(Profile, processing_necessary_for_detecting_investigating_or_preventing_crime_or_apprehending_or_prosecuting_offenders, true, Status), Statuses),
    Statuses == [indeterminate([processing_by_a_public_authority_in_the_performance_of_its_tasks])].
test(what_if_security_fails_names_the_first_open_condition_key) :-
    uk_recognised_legitimate_interests_profile_for(security_condition_met, Profile),
    findall(Status, uk_recognised_legitimate_interests_what_if(Profile, processing_necessary_for_national_security_public_security_or_defence, false, Status), Statuses),
    Statuses == [indeterminate([processing_necessary_for_a_disclosure_in_response_to_a_request])].
test(what_if_replaces_every_attribute_of_the_key) :-
    findall(Status, uk_recognised_legitimate_interests_what_if([attribute(processing_by_a_public_authority_in_the_performance_of_its_tasks, true), attribute(processing_by_a_public_authority_in_the_performance_of_its_tasks, unsure), attribute(processing_necessary_for_national_security_public_security_or_defence, true)], processing_by_a_public_authority_in_the_performance_of_its_tasks, false, Status), Statuses),
    Statuses == [recognised_legitimate_interest_applies].
test(what_if_wrong_value_gives_input_problems) :-
    uk_recognised_legitimate_interests_profile_for(security_condition_met, Profile),
    uk_recognised_legitimate_interests_what_if(Profile, individual_aged_under_18, unsure, input_problems([wrong_type(individual_aged_under_18)])).
test(comparison_names_the_uk_provisions_that_differ) :-
    uk_recognised_legitimate_interests_profile_for(uk_differs_from_eu, Profile),
    findall(ChangedBy, compare_uk_eu_legitimate_interest_basis(Profile, _UkResult, _EuResult, differs, ChangedBy), Answers),
    Answers = [ChangedBy],
    sort(ChangedBy, ChangedSet),
    sort([cite(uk_gdpr_art_6_1_ea), cite(uk_gdpr_art_6_5), cite(uk_gdpr_annex_1_para_5)], ExpectedSet),
    ChangedSet == ExpectedSet.
test(checklist_every_item_carries_a_citation) :-
    uk_recognised_legitimate_interests_profile_for(security_condition_met, Profile),
    uk_recognised_legitimate_interests_checklist(Profile, Items),
    length(Items, 6),
    maplist(item_has_citation, Items).
test(checklist_marks_the_met_condition_and_the_bar) :-
    uk_recognised_legitimate_interests_profile_for(security_condition_met, Profile),
    uk_recognised_legitimate_interests_checklist(Profile, Items),
    Items = [item(public_authority_bar, met, cite(uk_gdpr_art_6_1))|_],
    member(item(security_condition, met, cite(uk_gdpr_annex_1_para_2)), Items).
test(checklist_bar_unmet_for_a_public_authority) :-
    uk_recognised_legitimate_interests_profile_for(public_authority_bar, Profile),
    uk_recognised_legitimate_interests_checklist(Profile, [item(public_authority_bar, unmet(processing_by_a_public_authority_in_the_performance_of_its_tasks), cite(uk_gdpr_art_6_1))|_]).
test(checklist_reports_input_problems) :-
    uk_recognised_legitimate_interests_profile_for(crisp_key_wrong_type, Profile),
    uk_recognised_legitimate_interests_checklist(Profile, [item(input_check, unmet(input_problems([wrong_type(individual_aged_under_18)])), cite(uk_gdpr_art_6_1))]).

test(what_if_needs_a_list_profile, fail) :-
    uk_recognised_legitimate_interests_what_if(not_a_list, individual_aged_under_18, true, _Status).
test(comparison_never_cites_the_eu_side_in_changed_by, fail) :-
    uk_recognised_legitimate_interests_profile_for(uk_differs_from_eu, Profile),
    compare_uk_eu_legitimate_interest_basis(Profile, _UkResult, _EuResult, _Difference, ChangedBy),
    member(cite(eu_reg_2016_679_art_6_1_f), ChangedBy).

cp_test_names([profile_keys_are_the_contract_keys, profile_keys_all_pass_the_input_check_with_a_type_value, status_determination_one_answer, what_if_crime_condition_met_needs_the_bar, what_if_security_fails_names_the_first_open_condition_key, what_if_replaces_every_attribute_of_the_key, what_if_wrong_value_gives_input_problems, comparison_names_the_uk_provisions_that_differ, checklist_every_item_carries_a_citation, checklist_marks_the_met_condition_and_the_bar, checklist_bar_unmet_for_a_public_authority, checklist_reports_input_problems]).
cp_test_fail_names([what_if_needs_a_list_profile, comparison_never_cites_the_eu_side_in_changed_by]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
