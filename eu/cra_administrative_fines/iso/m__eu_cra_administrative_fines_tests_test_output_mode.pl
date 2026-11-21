% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_administrative_fines_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_administrative_fines_cra_administrative_fines, [administrative_fine_maximum/4, cra_administrative_fines_checklist/2]).
:- use_module(m__eu_cra_administrative_fines_fixtures, [cra_administrative_fines_assess/2, cra_administrative_fines_profile_for/2]).

fixture_answers(Subject, Answers) :-
    findall(Verdict - Citations, cra_administrative_fines_assess(Subject, cra_administrative_fines_verdict(Verdict, Citations)), Answers).

test(the_day_before_application) :-
    fixture_answers(day_before_application_highest_tier, Answers),
    Answers == [not_yet_applicable - [cite(eu_reg_2024_2847_art_71_2)]].
test(the_application_day) :-
    fixture_answers(application_day_highest_tier, Answers),
    Answers = [fine_maximum(highest_maximum_tier, fixed_amount_for_non_undertaking, CapInEuroCents) - [cite(eu_reg_2024_2847_art_64_2)]],
    CapInEuroCents =:= 1500000000.
test(an_earlier_chapter_iv_date_is_still_too_early) :-
    fixture_answers(earlier_obligation_date_middle_tier, Answers),
    Answers == [not_yet_applicable - [cite(eu_reg_2024_2847_art_71_2)]].
test(the_application_day_middle_tier) :-
    fixture_answers(application_day_middle_tier, Answers),
    Answers = [fine_maximum(middle_maximum_tier, fixed_amount_for_non_undertaking, CapInEuroCents) - [cite(eu_reg_2024_2847_art_64_3)]],
    CapInEuroCents =:= 1000000000.
test(the_provision_absent) :-
    fixture_answers(provision_absent, Answers),
    Answers == [indeterminate([infringed_provision]) - []].
test(the_unlisted_provision) :-
    fixture_answers(unlisted_provision, Answers),
    Answers == [not_listed_in_article_64 - [cite(eu_reg_2024_2847_art_64_1), cite(eu_reg_2024_2847_art_64_2), cite(eu_reg_2024_2847_art_64_3), cite(eu_reg_2024_2847_art_64_4)]].
test(the_steward_in_the_lowest_tier) :-
    fixture_answers(steward_lowest_tier, Answers),
    Answers == [fine_excluded(open_source_software_steward) - [cite(eu_reg_2024_2847_art_64_10_b)]].
test(the_non_steward_in_the_lowest_tier) :-
    fixture_answers(non_steward_lowest_tier, Answers),
    Answers = [fine_maximum(lowest_maximum_tier, fixed_amount_for_non_undertaking, CapInEuroCents) - [cite(eu_reg_2024_2847_art_64_4)]],
    CapInEuroCents =:= 500000000.
test(the_steward_absent_in_the_middle_tier) :-
    fixture_answers(steward_absent_middle_tier, Answers),
    Answers == [indeterminate([offender_is_open_source_software_steward]) - []].
test(the_steward_absent_in_the_highest_tier_is_not_asked) :-
    fixture_answers(steward_absent_highest_tier, Answers),
    Answers = [fine_maximum(highest_maximum_tier, fixed_amount, CapInEuroCents) - [cite(eu_reg_2024_2847_art_64_2)]],
    CapInEuroCents =:= 1500000000.
test(the_undertaking_absent) :-
    fixture_answers(undertaking_absent_middle_tier, Answers),
    Answers == [indeterminate([offender_is_undertaking]) - []].
test(the_turnover_absent_for_an_unsure_undertaking) :-
    fixture_answers(turnover_absent_unsure_undertaking, Answers),
    Answers == [indeterminate([total_worldwide_annual_turnover_in_euros]) - []].
test(the_unsure_steward_and_undertaking) :-
    fixture_answers(unsure_steward_and_undertaking_referral, Answers),
    Answers == [needs_legal_review(open_textured(offender_is_open_source_software_steward, cite(eu_reg_2024_2847_art_64_10_b)), [inputs_relied_on([offender_is_open_source_software_steward - unsure, offender_is_undertaking - unsure])]) - []].
test(the_unsure_undertaking_in_the_lowest_tier) :-
    fixture_answers(unsure_undertaking_lowest_tier, Answers),
    Answers == [needs_legal_review(open_textured(offender_is_undertaking, cite(eu_reg_2024_2847_art_64_4)), [inputs_relied_on([offender_is_open_source_software_steward - false, offender_is_undertaking - unsure])]) - []].
test(one_euro_below_the_highest_tie) :-
    fixture_answers(highest_tier_one_euro_below_tie, Answers),
    Answers = [fine_maximum(highest_maximum_tier, fixed_amount, CapInEuroCents) - [cite(eu_reg_2024_2847_art_64_2)]],
    CapInEuroCents =:= 1500000000.
test(two_euros_above_the_highest_tie) :-
    fixture_answers(highest_tier_two_euros_above_tie, Answers),
    Answers = [fine_maximum(highest_maximum_tier, percentage_of_turnover, CapInEuroCents) - [cite(eu_reg_2024_2847_art_64_2)]],
    CapInEuroCents =:= 1500000005.
test(the_middle_tie) :-
    fixture_answers(middle_tier_tie, Answers),
    Answers = [fine_maximum(middle_maximum_tier, fixed_amount, CapInEuroCents) - [cite(eu_reg_2024_2847_art_64_3)]],
    CapInEuroCents =:= 1000000000.
test(one_euro_above_the_middle_tie) :-
    fixture_answers(middle_tier_one_euro_above_tie, Answers),
    Answers = [fine_maximum(middle_maximum_tier, percentage_of_turnover, CapInEuroCents) - [cite(eu_reg_2024_2847_art_64_3)]],
    CapInEuroCents =:= 1000000002.
test(the_lowest_tie) :-
    fixture_answers(lowest_tier_tie, Answers),
    Answers = [fine_maximum(lowest_maximum_tier, fixed_amount, CapInEuroCents) - [cite(eu_reg_2024_2847_art_64_4)]],
    CapInEuroCents =:= 500000000.
test(one_euro_above_the_lowest_tie) :-
    fixture_answers(lowest_tier_one_euro_above_tie, Answers),
    Answers = [fine_maximum(lowest_maximum_tier, percentage_of_turnover, CapInEuroCents) - [cite(eu_reg_2024_2847_art_64_4)]],
    CapInEuroCents =:= 500000001.
test(the_leap_day_2028_is_read) :-
    fixture_answers(leap_day_2028, Answers),
    Answers == [not_listed_in_article_64 - [cite(eu_reg_2024_2847_art_64_1), cite(eu_reg_2024_2847_art_64_2), cite(eu_reg_2024_2847_art_64_3), cite(eu_reg_2024_2847_art_64_4)]].
test(the_negative_turnover) :-
    fixture_answers(negative_turnover, Answers),
    Answers == [input_problems([wrong_type(total_worldwide_annual_turnover_in_euros)]) - []].
test(the_duplicate_key) :-
    fixture_answers(duplicate_undertaking_key, Answers),
    Answers == [input_problems([duplicate_key(offender_is_undertaking)]) - []].
test(the_unknown_key) :-
    fixture_answers(unknown_profile_key, Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(neither_a_profile_nor_a_date) :-
    fixture_answers(not_a_profile_nor_a_date, Answers),
    Answers == [input_problems([wrong_type(profile), wrong_type(infringement_date)]) - []].
test(the_calculation_reads_the_cap_out) :-
    findall(CapInEuroCents, administrative_fine_maximum([attribute(infringed_provision, article_13), attribute(offender_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1000000000)], date(2030, 6, 1), fine_maximum(_, _, CapInEuroCents), _), Caps),
    Caps = [OnlyCap],
    OnlyCap =:= 2500000000.
test(the_checklist_of_the_highest_tier) :-
    cra_administrative_fines_profile_for(steward_absent_highest_tier, Request),
    findall(Items, cra_administrative_fines_checklist(Request, Items), AllItems),
    AllItems = [[item(well_formed_input, met, []), item(date_of_application, met, [cite(eu_reg_2024_2847_art_71_2)]), item(tier_of_infringed_provision, value(highest_maximum_tier), [cite(eu_reg_2024_2847_art_64_2)]), item(open_source_software_steward_derogation, inapplicable, [cite(eu_reg_2024_2847_art_64_10_b)]), item(administrative_fine_maximum, value(fine_maximum(highest_maximum_tier, fixed_amount, CapInEuroCents)), [cite(eu_reg_2024_2847_art_64_2)])]],
    CapInEuroCents =:= 1500000000.
test(the_checklist_of_a_too_early_date) :-
    cra_administrative_fines_profile_for(day_before_application_highest_tier, Request),
    cra_administrative_fines_checklist(Request, Items),
    member(item(date_of_application, unmet(not_yet_applicable), [cite(eu_reg_2024_2847_art_71_2)]), Items),
    member(item(administrative_fine_maximum, value(not_yet_applicable), [cite(eu_reg_2024_2847_art_71_2)]), Items).

cp_test_names([the_day_before_application, the_application_day, an_earlier_chapter_iv_date_is_still_too_early, the_application_day_middle_tier, the_provision_absent, the_unlisted_provision, the_steward_in_the_lowest_tier, the_non_steward_in_the_lowest_tier, the_steward_absent_in_the_middle_tier, the_steward_absent_in_the_highest_tier_is_not_asked, the_undertaking_absent, the_turnover_absent_for_an_unsure_undertaking, the_unsure_steward_and_undertaking, the_unsure_undertaking_in_the_lowest_tier, one_euro_below_the_highest_tie, two_euros_above_the_highest_tie, the_middle_tie, one_euro_above_the_middle_tie, the_lowest_tie, one_euro_above_the_lowest_tie, the_leap_day_2028_is_read, the_negative_turnover, the_duplicate_key, the_unknown_key, neither_a_profile_nor_a_date, the_calculation_reads_the_cap_out, the_checklist_of_the_highest_tier, the_checklist_of_a_too_early_date]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
