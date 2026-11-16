% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_information_route, [information_route/2, information_route_status/2, information_route_status_values/1, information_items_owed/2, information_items_missing/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_further_processing_information_verdict, [further_processing_information_verdict/3, further_processing_information_verdict_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_queries, [gdpr_information_duties_items_and_further_processing_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_fixtures, [gdpr_information_duties_items_and_further_processing_profile_for/2]).

test(the_route_atoms_are_real) :-
    information_route_status_values(StatusValues),
    member(art13, StatusValues),
    member(art14, StatusValues).
test(the_further_verdict_atoms_are_real) :-
    further_processing_information_verdict_status_values(StatusValues),
    member(eligible, StatusValues),
    member(ineligible, StatusValues),
    member(not_applicable, StatusValues).
test(the_collected_profile_is_art13) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    information_route_status(Profile, art13).
test(flipping_the_flag_flips_the_route) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    gdpr_information_duties_items_and_further_processing_what_if(Profile, personal_data_collected_from_data_subject, false, art14).
test(art13_owes_the_statutory_requirement) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    information_items_owed(Profile, Owed),
    member(owed_item(statutory_or_contractual_requirement, cite(eu_reg_2016_679_art_13_2_e)), Owed).
test(art14_owes_the_source_of_the_data) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_complete, Profile),
    information_items_owed(Profile, Owed),
    member(owed_item(source_of_personal_data, cite(eu_reg_2016_679_art_14_2_f)), Owed).
test(a_complete_notice_misses_nothing) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    information_items_missing(Profile, [no_item_missing]).
test(the_near_miss_names_the_requirement) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_missing_requirement, Profile),
    information_items_missing(Profile, [missing_item(statutory_or_contractual_requirement, _)]).
test(already_having_the_item_removes_it_from_the_missing_list) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_categories_already_known, Profile),
    information_items_missing(Profile, [no_item_missing]).
test(information_the_day_before_is_eligible) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_in_time, Profile),
    further_processing_information_verdict(Profile, eligible, _).
test(information_the_same_day_is_ineligible) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_same_day, Profile),
    further_processing_information_verdict(Profile, ineligible, _).
test(a_missing_paragraph_2_item_is_ineligible) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_item_missing, Profile),
    further_processing_information_verdict(Profile, ineligible, _).
test(no_further_processing_is_not_applicable) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_not_intended, Profile),
    further_processing_information_verdict(Profile, not_applicable, []).
test(the_art14_route_cites_art14_4) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_further_in_time, Profile),
    further_processing_information_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_4)]).
test(dropping_the_start_date_makes_the_verdict_open) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_without_start_date, Profile),
    further_processing_information_verdict(Profile, indeterminate([further_processing_start_date]), []).

test(the_collected_profile_is_not_art14, fail) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    information_route_status(Profile, art14).
test(art14_does_not_owe_the_statutory_requirement, fail) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_complete, Profile),
    information_items_owed(Profile, Owed),
    member(owed_item(statutory_or_contractual_requirement, _), Owed).
test(art13_does_not_owe_the_source_of_the_data, fail) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    information_items_owed(Profile, Owed),
    member(owed_item(source_of_personal_data, _), Owed).
test(a_notice_without_the_requirement_misses_it, fail) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_missing_requirement, Profile),
    information_items_missing(Profile, [no_item_missing]).
test(without_the_already_has_statement_the_item_is_missing, fail) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_categories_missing, Profile),
    information_items_missing(Profile, [no_item_missing]).
test(information_the_same_day_is_not_eligible, fail) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_same_day, Profile),
    further_processing_information_verdict(Profile, eligible, _).
test(a_missing_paragraph_2_item_is_not_eligible, fail) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_item_missing, Profile),
    further_processing_information_verdict(Profile, eligible, _).
test(no_further_processing_is_not_ineligible, fail) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_not_intended, Profile),
    further_processing_information_verdict(Profile, ineligible, _).
test(the_art14_route_does_not_cite_art13_3, fail) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_further_in_time, Profile),
    further_processing_information_verdict(Profile, _, [cite(eu_reg_2016_679_art_13_3)]).

cp_test_names([the_route_atoms_are_real, the_further_verdict_atoms_are_real, the_collected_profile_is_art13, flipping_the_flag_flips_the_route, art13_owes_the_statutory_requirement, art14_owes_the_source_of_the_data, a_complete_notice_misses_nothing, the_near_miss_names_the_requirement, already_having_the_item_removes_it_from_the_missing_list, information_the_day_before_is_eligible, information_the_same_day_is_ineligible, a_missing_paragraph_2_item_is_ineligible, no_further_processing_is_not_applicable, the_art14_route_cites_art14_4, dropping_the_start_date_makes_the_verdict_open]).
cp_test_fail_names([the_collected_profile_is_not_art14, art14_does_not_owe_the_statutory_requirement, art13_does_not_owe_the_source_of_the_data, a_notice_without_the_requirement_misses_it, without_the_already_has_statement_the_item_is_missing, information_the_same_day_is_not_eligible, a_missing_paragraph_2_item_is_not_eligible, no_further_processing_is_not_ineligible, the_art14_route_does_not_cite_art13_3]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
