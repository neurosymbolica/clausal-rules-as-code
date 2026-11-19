% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [administrative_fine_maximum/3, gdpr_administrative_fine_maximum_status/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_kernel, [gdpr_administrative_fine_maximum_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_fixtures, [gdpr_administrative_fine_maximum_profile_for/2]).

test(lower_tie_holds_with_the_verdict_bound) :-
    gdpr_administrative_fine_maximum_profile_for(lower_tier_turnover_at_tie, Profile),
    administrative_fine_maximum(Profile, fine_maximum(lower_maximum_tier, fixed_amount, CapInEuroCents), [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a)]),
    CapInEuroCents =:= 1000000000.
test(higher_above_tie_holds_with_the_verdict_bound) :-
    gdpr_administrative_fine_maximum_profile_for(higher_tier_turnover_just_above_tie, Profile),
    administrative_fine_maximum(Profile, fine_maximum(higher_maximum_tier, percentage_of_turnover, CapInEuroCents), [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_b)]),
    CapInEuroCents =:= 2000000004.
test(separate_holds_with_the_status_bound) :-
    gdpr_administrative_fine_maximum_profile_for(separate_not_intentional_or_negligent, Profile),
    gdpr_administrative_fine_maximum_status(Profile, separate_fine_maxima_determined).
test(missing_key_holds_with_the_verdict_bound) :-
    gdpr_administrative_fine_maximum_profile_for(missing_turnover_unsure_undertaking, Profile),
    administrative_fine_maximum(Profile, indeterminate([total_worldwide_annual_turnover_in_euros]), []).
test(referral_holds_with_the_verdict_bound) :-
    gdpr_administrative_fine_maximum_profile_for(unlisted_provision, Profile),
    administrative_fine_maximum(Profile, needs_legal_review(not_governed_here([cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6)]), [inputs_relied_on([infringed_provisions - [article_24]])]), []).
test(input_problems_hold_with_the_verdict_bound) :-
    gdpr_administrative_fine_maximum_profile_for(negative_turnover_rejected, Profile),
    administrative_fine_maximum(Profile, input_problems([wrong_type(total_worldwide_annual_turnover_in_euros)]), []).
test(an_integer_profile_is_wrong_type) :-
    administrative_fine_maximum(42, Verdict, Citations),
    Verdict == input_problems([wrong_type(profile)]),
    Citations == [].
test(a_list_of_pairs_is_not_an_attribute_list) :-
    administrative_fine_maximum([infringer_is_undertaking - true], Verdict, _),
    Verdict == input_problems([wrong_type(profile)]).
test(a_list_judgement_value_is_wrong_type) :-
    administrative_fine_maximum([attribute(infringer_is_undertaking, [true])], Verdict, _),
    Verdict == input_problems([wrong_type(infringer_is_undertaking)]).
test(a_float_turnover_is_wrong_type) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_8]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1.5)], Verdict, _),
    Verdict == input_problems([wrong_type(total_worldwide_annual_turnover_in_euros)]).
test(an_atom_turnover_is_wrong_type) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(total_worldwide_annual_turnover_in_euros, plenty)], Problems),
    Problems == [wrong_type(total_worldwide_annual_turnover_in_euros)].
test(an_empty_provision_list_is_wrong_type) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(infringed_provisions, [])], Problems),
    Problems == [wrong_type(infringed_provisions)].
test(a_number_among_the_provisions_is_wrong_type) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(infringed_provisions, [article_5, 12])], Problems),
    Problems == [wrong_type(infringed_provisions)].
test(a_bare_provision_atom_is_not_a_list) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(infringed_provisions, article_5)], Problems),
    Problems == [wrong_type(infringed_provisions)].
test(an_unlisted_atom_is_not_an_input_problem) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(infringed_provisions, [article_24])], Problems),
    Problems == [].
test(a_key_the_answer_does_not_read_is_still_checked) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_8]), attribute(infringer_is_undertaking, false), attribute(infringements_intentional_or_negligent, maybe)], Verdict, _),
    Verdict == input_problems([wrong_type(infringements_intentional_or_negligent)]).
test(a_repeated_key_is_a_duplicate_and_its_values_are_not_read) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(total_worldwide_annual_turnover_in_euros, -5), attribute(total_worldwide_annual_turnover_in_euros, -5)], Problems),
    Problems == [duplicate_key(total_worldwide_annual_turnover_in_euros)].
test(problems_come_in_contract_order_then_unknown_keys) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(zebra, 1), attribute(infringements_intentional_or_negligent, 7), attribute(infringed_provisions, []), attribute(zebra, 2)], Problems),
    Problems == [wrong_type(infringed_provisions), wrong_type(infringements_intentional_or_negligent), unknown_key(zebra)].
test(absence_is_not_a_problem) :-
    gdpr_administrative_fine_maximum_input_problems([], Problems),
    Problems == [].
test(attribute_order_does_not_change_the_answer) :-
    administrative_fine_maximum([attribute(total_worldwide_annual_turnover_in_euros, 500000001), attribute(infringer_is_undertaking, true), attribute(infringed_provisions, [article_30])], fine_maximum(MaximumTier, Basis, CapInEuroCents), _),
    MaximumTier == lower_maximum_tier,
    Basis == percentage_of_turnover,
    CapInEuroCents =:= 1000000002.
test(the_input_check_answers_exactly_once) :-
    findall(Problems, gdpr_administrative_fine_maximum_input_problems([attribute(colour, red), attribute(infringer_is_undertaking, maybe)], Problems), Answers),
    Answers == [[wrong_type(infringer_is_undertaking), unknown_key(colour)]].

test(lower_tie_rejects_a_bound_percentage_basis, fail) :-
    gdpr_administrative_fine_maximum_profile_for(lower_tier_turnover_at_tie, Profile),
    administrative_fine_maximum(Profile, fine_maximum(_, percentage_of_turnover, _), _).
test(separate_rejects_a_bound_single_maximum, fail) :-
    gdpr_administrative_fine_maximum_profile_for(separate_not_intentional_or_negligent, Profile),
    gdpr_administrative_fine_maximum_status(Profile, fine_maximum_determined).
test(a_rejected_profile_has_no_maximum, fail) :-
    gdpr_administrative_fine_maximum_profile_for(negative_turnover_rejected, Profile),
    administrative_fine_maximum(Profile, fine_maximum(_, _, _), _).

cp_test_names([lower_tie_holds_with_the_verdict_bound, higher_above_tie_holds_with_the_verdict_bound, separate_holds_with_the_status_bound, missing_key_holds_with_the_verdict_bound, referral_holds_with_the_verdict_bound, input_problems_hold_with_the_verdict_bound, an_integer_profile_is_wrong_type, a_list_of_pairs_is_not_an_attribute_list, a_list_judgement_value_is_wrong_type, a_float_turnover_is_wrong_type, an_atom_turnover_is_wrong_type, an_empty_provision_list_is_wrong_type, a_number_among_the_provisions_is_wrong_type, a_bare_provision_atom_is_not_a_list, an_unlisted_atom_is_not_an_input_problem, a_key_the_answer_does_not_read_is_still_checked, a_repeated_key_is_a_duplicate_and_its_values_are_not_read, problems_come_in_contract_order_then_unknown_keys, absence_is_not_a_problem, attribute_order_does_not_change_the_answer, the_input_check_answers_exactly_once]).
cp_test_fail_names([lower_tie_rejects_a_bound_percentage_basis, separate_rejects_a_bound_single_maximum, a_rejected_profile_has_no_maximum]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
