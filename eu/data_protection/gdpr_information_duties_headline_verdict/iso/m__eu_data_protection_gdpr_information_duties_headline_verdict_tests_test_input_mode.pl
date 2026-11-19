% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_kernel, [gdpr_information_duties_headline_verdict_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [information_duty_verdict/3, information_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_exemption, [information_duty_exemption/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_fixtures, [gdpr_information_duties_headline_verdict_profile_for/2]).

test(article_13_timely_bound_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(article_13_complete_on_obtaining_day, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_13_1)]).
test(article_13_late_bound_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(article_13_complete_one_day_after_obtaining, Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_13_1)]).
test(article_14_last_day_bound_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(article_14_on_last_day_of_month, Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_1)]).
test(article_14_day_after_bound_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(article_14_day_after_last_day_of_month, Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
test(article_14_law_exemption_bound) :-
    gdpr_information_duties_headline_verdict_profile_for(article_14_source_missing_law_attested_true, Profile),
    information_duty_exemption(Profile, law_lays_down_obtaining_or_disclosure).
test(article_13_exemption_bound_none) :-
    gdpr_information_duties_headline_verdict_profile_for(article_13_complete_on_obtaining_day, Profile),
    information_duty_exemption(Profile, none).
test(route_unknown_exemption_bound) :-
    gdpr_information_duties_headline_verdict_profile_for(route_not_supplied, Profile),
    information_duty_exemption(Profile, indeterminate([personal_data_collected_from_data_subject])).
test(a_bare_pair_is_not_a_profile) :-
    gdpr_information_duties_headline_verdict_input_problems([recipients_exist - true], [wrong_type(profile)]).
test(a_yes_atom_is_not_a_crisp_flag) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(transfer_intended, yes)], [wrong_type(transfer_intended)]).
test(a_judgement_outside_its_values_is_wrong_type) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(provided_within_reasonable_period, maybe)], [wrong_type(provided_within_reasonable_period)]).
test(a_non_leap_february_29_is_wrong_type) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(provision_date, date(2026, 2, 29))], [wrong_type(provision_date)]).
test(a_leap_february_29_is_a_date) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(provision_date, date(2028, 2, 29))], []).
test(a_float_day_is_wrong_type) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(obtaining_date, date(2026, 1, 1.0))], [wrong_type(obtaining_date)]).
test(a_holiday_list_with_a_bad_date_is_wrong_type) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(public_holidays, attested([date(2026, 13, 1)], attestation(by, at, reason, none)))], [wrong_type(public_holidays)]).
test(duplicate_key_with_equal_values_is_one_problem) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(recipients_exist, true), attribute(recipients_exist, true)], [duplicate_key(recipients_exist)]).
test(a_repeated_unknown_key_is_named_once) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(colour, red), attribute(shape, round), attribute(colour, blue)], [unknown_key(colour), unknown_key(shape)]).
test(an_item_of_the_other_route_is_accepted) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(personal_data_collected_from_data_subject, true), attribute(items_provided, [categories_of_personal_data])], []).
test(other_purpose_information_may_be_in_further_items) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(further_processing_items_provided, [other_purpose_information])], []).
test(every_relation_refuses_input_problems) :-
    gdpr_information_duties_headline_verdict_profile_for(input_problems_mix, Profile),
    information_duty_verdict(Profile, input_problems([duplicate_key(items_provided), wrong_type(obtaining_date), unknown_key(colour)]), []),
    information_duty_exemption(Profile, input_problems([duplicate_key(items_provided), wrong_type(obtaining_date), unknown_key(colour)])),
    information_outside_facts(Profile, input_problems([duplicate_key(items_provided), wrong_type(obtaining_date), unknown_key(colour)])).

test(article_13_timely_bound_ineligible_rejected, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(article_13_complete_on_obtaining_day, Profile),
    information_duty_verdict(Profile, ineligible, _).
test(article_13_late_bound_eligible_rejected, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(article_13_complete_one_day_after_obtaining, Profile),
    information_duty_verdict(Profile, eligible, _).
test(article_14_law_exemption_bound_none_rejected, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(article_14_source_missing_law_attested_true, Profile),
    information_duty_exemption(Profile, none).
test(a_refused_profile_gets_no_verdict, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(input_problems_mix, Profile),
    information_duty_verdict(Profile, ineligible, _).

cp_test_names([article_13_timely_bound_eligible, article_13_late_bound_ineligible, article_14_last_day_bound_eligible, article_14_day_after_bound_ineligible, article_14_law_exemption_bound, article_13_exemption_bound_none, route_unknown_exemption_bound, a_bare_pair_is_not_a_profile, a_yes_atom_is_not_a_crisp_flag, a_judgement_outside_its_values_is_wrong_type, a_non_leap_february_29_is_wrong_type, a_leap_february_29_is_a_date, a_float_day_is_wrong_type, a_holiday_list_with_a_bad_date_is_wrong_type, duplicate_key_with_equal_values_is_one_problem, a_repeated_unknown_key_is_named_once, an_item_of_the_other_route_is_accepted, other_purpose_information_may_be_in_further_items, every_relation_refuses_input_problems]).
cp_test_fail_names([article_13_timely_bound_ineligible_rejected, article_13_late_bound_eligible_rejected, article_14_law_exemption_bound_none_rejected, a_refused_profile_gets_no_verdict]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
