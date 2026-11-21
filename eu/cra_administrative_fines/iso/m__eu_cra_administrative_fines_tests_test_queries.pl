% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_administrative_fines_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_administrative_fines_queries, [cra_administrative_fines_profile_keys/1, cra_administrative_fines_what_if/4]).
:- use_module(m__eu_cra_administrative_fines_kernel, [cra_administrative_fines_input_problems/2]).
:- use_module(m__eu_cra_administrative_fines_cra_administrative_fines, [administrative_fine_maximum/4, cra_administrative_fines_status/2, cra_administrative_fines_checklist/2]).

test(profile_keys_are_the_contract_keys) :-
    cra_administrative_fines_profile_keys(ProfileKeys),
    ProfileKeys == [infringed_provision, offender_is_open_source_software_steward, offender_is_undertaking, total_worldwide_annual_turnover_in_euros].
test(the_input_check_gives_one_answer) :-
    findall(Problems, cra_administrative_fines_input_problems([attribute(infringed_provision, article_99), attribute(colour, red)], Problems), AllProblems),
    AllProblems == [[wrong_type(infringed_provision), unknown_key(colour)]].
test(the_status_query_gives_one_status) :-
    findall(Status, cra_administrative_fines_status(infringement([attribute(infringed_provision, other_provision)], date(2028, 1, 1)), Status), Statuses),
    Statuses == [not_listed_in_article_64].
test(the_calculation_gives_the_middle_tier_percentage) :-
    findall(Verdict - Citations, administrative_fine_maximum([attribute(infringed_provision, article_30_paragraphs_1_to_4), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 750000000)], date(2028, 3, 1), Verdict, Citations), Answers),
    Answers = [fine_maximum(middle_maximum_tier, percentage_of_turnover, CapInEuroCents) - [cite(eu_reg_2024_2847_art_64_3)]],
    CapInEuroCents =:= 1500000000.
test(the_checklist_cites_every_ground_of_a_final_answer) :-
    cra_administrative_fines_checklist(infringement([attribute(infringed_provision, article_49), attribute(offender_is_open_source_software_steward, false), attribute(offender_is_undertaking, false)], date(2028, 1, 1)), Items),
    member(item(date_of_application, met, [cite(eu_reg_2024_2847_art_71_2)]), Items),
    member(item(tier_of_infringed_provision, value(middle_maximum_tier), [cite(eu_reg_2024_2847_art_64_3)]), Items),
    member(item(open_source_software_steward_derogation, met, [cite(eu_reg_2024_2847_art_64_10_b)]), Items),
    member(item(administrative_fine_maximum, value(fine_maximum(middle_maximum_tier, fixed_amount_for_non_undertaking, _)), [cite(eu_reg_2024_2847_art_64_3)]), Items).
test(what_if_the_date_moves_before_application) :-
    findall(Status, cra_administrative_fines_what_if(infringement([attribute(infringed_provision, article_13), attribute(offender_is_undertaking, false)], date(2028, 1, 1)), infringement_date, date(2027, 12, 10), Status), Statuses),
    Statuses == [not_yet_applicable].
test(what_if_the_provision_becomes_unlisted) :-
    findall(Status, cra_administrative_fines_what_if(infringement([attribute(infringed_provision, article_13), attribute(offender_is_undertaking, false)], date(2028, 1, 1)), infringed_provision, other_provision, Status), Statuses),
    Statuses == [not_listed_in_article_64].
test(what_if_the_steward_becomes_true_in_the_highest_tier_changes_nothing) :-
    cra_administrative_fines_what_if(infringement([attribute(infringed_provision, article_13), attribute(offender_is_undertaking, false)], date(2028, 1, 1)), offender_is_open_source_software_steward, true, fine_maximum(highest_maximum_tier, fixed_amount_for_non_undertaking, CapInEuroCents)),
    CapInEuroCents =:= 1500000000.
test(what_if_the_turnover_becomes_a_float) :-
    cra_administrative_fines_what_if(infringement([attribute(infringed_provision, article_13), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1)], date(2028, 1, 1)), total_worldwide_annual_turnover_in_euros, 1.0, input_problems([wrong_type(total_worldwide_annual_turnover_in_euros)])).
test(what_if_keeps_a_malformed_profile_malformed) :-
    findall(Status, cra_administrative_fines_what_if(infringement([colour], date(2028, 1, 1)), infringed_provision, article_13, Status), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].
test(what_if_the_date_becomes_invalid) :-
    cra_administrative_fines_what_if(infringement([], date(2028, 1, 1)), infringement_date, date(2027, 2, 29), input_problems([wrong_type(infringement_date)])).

test(what_if_the_steward_becomes_true_in_the_highest_tier_is_no_exclusion, fail) :-
    cra_administrative_fines_what_if(infringement([attribute(infringed_provision, article_13), attribute(offender_is_undertaking, false)], date(2028, 1, 1)), offender_is_open_source_software_steward, true, fine_excluded(_)).

cp_test_names([profile_keys_are_the_contract_keys, the_input_check_gives_one_answer, the_status_query_gives_one_status, the_calculation_gives_the_middle_tier_percentage, the_checklist_cites_every_ground_of_a_final_answer, what_if_the_date_moves_before_application, what_if_the_provision_becomes_unlisted, what_if_the_steward_becomes_true_in_the_highest_tier_changes_nothing, what_if_the_turnover_becomes_a_float, what_if_keeps_a_malformed_profile_malformed, what_if_the_date_becomes_invalid]).
cp_test_fail_names([what_if_the_steward_becomes_true_in_the_highest_tier_is_no_exclusion]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
