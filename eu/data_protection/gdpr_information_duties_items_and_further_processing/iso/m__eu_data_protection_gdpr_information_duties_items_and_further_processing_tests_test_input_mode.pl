% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_information_route, [information_route/2, information_items_owed/2, information_items_missing/2, information_route_status/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_further_processing_information_verdict, [further_processing_information_verdict/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_fixtures, [gdpr_information_duties_items_and_further_processing_profile_for/2]).

test(status_holds_with_the_verdict_bound) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    information_route_status(Profile, art13).
test(art14_route_with_the_answer_bound) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_complete, Profile),
    information_route(Profile, art14).
test(nothing_missing_with_the_answer_bound) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    information_items_missing(Profile, [no_item_missing]).
test(the_missing_requirement_with_the_answer_bound) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_missing_requirement, Profile),
    information_items_missing(Profile, [missing_item(statutory_or_contractual_requirement, cite(eu_reg_2016_679_art_13_2_e))]).
test(the_categories_are_missing_on_art14) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_categories_missing, Profile),
    information_items_missing(Profile, [missing_item(categories_of_personal_data, cite(eu_reg_2016_679_art_14_1_d))]).
test(already_known_categories_are_not_missing) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_categories_already_known, Profile),
    information_items_missing(Profile, [no_item_missing]).
test(the_first_owed_item_is_the_identity) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    information_items_owed(Profile, [owed_item(controller_identity_and_contact_details, cite(eu_reg_2016_679_art_13_1_a))|_]).
test(an_unsure_automated_judgement_is_referred) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_automated_unsure, Profile),
    information_items_owed(Profile, needs_legal_review(open_textured(automated_decision_making_under_article_22, cite(eu_reg_2016_679_art_13_2_f)), _)).
test(the_same_day_further_processing_is_ineligible) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_same_day, Profile),
    further_processing_information_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_13_3)]).
test(the_in_time_further_processing_is_eligible) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_in_time, Profile),
    further_processing_information_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_13_3)]).
test(not_intended_is_not_applicable) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_not_intended, Profile),
    further_processing_information_verdict(Profile, not_applicable, []).
test(an_empty_profile_names_the_absent_key) :-
    information_route([], indeterminate([personal_data_collected_from_data_subject])).
test(an_unknown_key_is_an_input_problem) :-
    information_route([attribute(bogus_key, true)], input_problems([unknown_key(bogus_key)])).
test(a_wrong_typed_flag_is_an_input_problem) :-
    information_items_owed([attribute(recipients_exist, unsure)], input_problems([wrong_type(recipients_exist)])).
test(a_duplicate_key_is_an_input_problem) :-
    information_route([attribute(recipients_exist, true), attribute(recipients_exist, false)], input_problems([duplicate_key(recipients_exist)])).
test(a_non_list_profile_is_an_input_problem) :-
    further_processing_information_verdict(not_a_profile, input_problems([wrong_type(profile)]), []).

test(the_wrong_bound_status_is_rejected, fail) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    information_route_status(Profile, art14).

cp_test_names([status_holds_with_the_verdict_bound, art14_route_with_the_answer_bound, nothing_missing_with_the_answer_bound, the_missing_requirement_with_the_answer_bound, the_categories_are_missing_on_art14, already_known_categories_are_not_missing, the_first_owed_item_is_the_identity, an_unsure_automated_judgement_is_referred, the_same_day_further_processing_is_ineligible, the_in_time_further_processing_is_eligible, not_intended_is_not_applicable, an_empty_profile_names_the_absent_key, an_unknown_key_is_an_input_problem, a_wrong_typed_flag_is_an_input_problem, a_duplicate_key_is_an_input_problem, a_non_list_profile_is_an_input_problem]).
cp_test_fail_names([the_wrong_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
