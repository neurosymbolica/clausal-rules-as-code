% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [administrative_fine_maximum/3, gdpr_administrative_fine_maximum_status/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_fixtures, [gdpr_administrative_fine_maximum_profile_for/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_kernel, [gdpr_administrative_fine_maximum_input_problems/2]).

test(lower_percentage_with_the_verdict_bound) :-
    gdpr_administrative_fine_maximum_profile_for(lower_percentage_basis, Profile),
    administrative_fine_maximum(Profile, fine_maximum(lower_maximum_tier, percentage_of_turnover, 2000000000), [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a)]).
test(lower_tie_with_the_verdict_bound) :-
    gdpr_administrative_fine_maximum_profile_for(lower_tie_at_fixed, Profile),
    administrative_fine_maximum(Profile, fine_maximum(lower_maximum_tier, fixed_amount, 1000000000), [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a)]).
test(higher_fixed_with_the_verdict_bound) :-
    gdpr_administrative_fine_maximum_profile_for(higher_fixed_basis, Profile),
    administrative_fine_maximum(Profile, fine_maximum(higher_maximum_tier, fixed_amount, 2000000000), [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_a)]).
test(non_undertaking_with_the_verdict_bound) :-
    gdpr_administrative_fine_maximum_profile_for(higher_non_undertaking_ignores_turnover, Profile),
    administrative_fine_maximum(Profile, fine_maximum(higher_maximum_tier, fixed_amount_for_non_undertaking, 2000000000), _).
test(certification_body_cites_both_points) :-
    gdpr_administrative_fine_maximum_profile_for(certification_body_article_42, Profile),
    administrative_fine_maximum(Profile, fine_maximum(lower_maximum_tier, fixed_amount, 1000000000), [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_4_a), cite(eu_reg_2016_679_art_83_4_b)]).
test(order_non_compliance_cites_paragraph_six) :-
    gdpr_administrative_fine_maximum_profile_for(order_non_compliance, Profile),
    administrative_fine_maximum(Profile, fine_maximum(higher_maximum_tier, fixed_amount, 2000000000), [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6), cite(eu_reg_2016_679_art_83_5_e)]).
test(combined_cites_art_83_3_last) :-
    gdpr_administrative_fine_maximum_profile_for(combined_gravest_is_higher, Profile),
    administrative_fine_maximum(Profile, fine_maximum(higher_maximum_tier, percentage_of_turnover, 4000000000), [cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_5_a), cite(eu_reg_2016_679_art_83_3)]).
test(separate_maxima_with_the_verdict_bound) :-
    gdpr_administrative_fine_maximum_profile_for(separate_not_linked, Profile),
    administrative_fine_maximum(Profile, separate_fine_maxima([infringement_maximum(article_32, lower_maximum_tier, percentage_of_turnover, 2000000000), infringement_maximum(article_5, higher_maximum_tier, percentage_of_turnover, 4000000000)]), [cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_4_a), cite(eu_reg_2016_679_art_83_5_a)]).
test(unsure_undertaking_with_the_verdict_bound) :-
    gdpr_administrative_fine_maximum_profile_for(unsure_undertaking, Profile),
    administrative_fine_maximum(Profile, needs_legal_review(open_textured(infringer_is_undertaking, cite(eu_reg_2016_679_art_83_4)), [inputs_relied_on([infringer_is_undertaking - unsure])]), []).
test(unlisted_provision_with_the_verdict_bound) :-
    gdpr_administrative_fine_maximum_profile_for(unlisted_provision, Profile),
    administrative_fine_maximum(Profile, needs_legal_review(not_governed_here([cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6)]), [inputs_relied_on([infringed_provisions - [article_24]])]), []).
test(missing_turnover_with_the_verdict_bound) :-
    gdpr_administrative_fine_maximum_profile_for(missing_turnover, Profile),
    administrative_fine_maximum(Profile, indeterminate([total_worldwide_annual_turnover_in_euros]), []).
test(missing_everything_names_three_keys) :-
    gdpr_administrative_fine_maximum_profile_for(missing_everything, Profile),
    administrative_fine_maximum(Profile, indeterminate([infringed_provisions, infringer_is_undertaking, total_worldwide_annual_turnover_in_euros]), []).
test(input_problem_with_the_verdict_bound) :-
    gdpr_administrative_fine_maximum_profile_for(input_negative_turnover, Profile),
    administrative_fine_maximum(Profile, input_problems([wrong_type(total_worldwide_annual_turnover_in_euros)]), []).
test(status_with_the_status_bound) :-
    gdpr_administrative_fine_maximum_profile_for(lower_tie_at_fixed, Profile),
    gdpr_administrative_fine_maximum_status(Profile, fine_maximum).
test(a_well_formed_profile_has_no_problem) :-
    gdpr_administrative_fine_maximum_profile_for(lower_percentage_basis, Profile),
    gdpr_administrative_fine_maximum_input_problems(Profile, []).
test(an_empty_profile_has_no_problem) :-
    gdpr_administrative_fine_maximum_input_problems([], []).
test(a_non_list_is_not_a_profile) :-
    gdpr_administrative_fine_maximum_input_problems(not_a_list, [wrong_type(profile)]).
test(a_float_turnover_is_wrong_type) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(total_worldwide_annual_turnover_in_euros, 1.5)], [wrong_type(total_worldwide_annual_turnover_in_euros)]).
test(an_empty_provision_list_is_wrong_type) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(infringed_provisions, [])], [wrong_type(infringed_provisions)]).
test(a_non_atom_provision_is_wrong_type) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(infringed_provisions, [5])], [wrong_type(infringed_provisions)]).
test(an_unlisted_atom_is_not_an_input_problem) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(infringed_provisions, [article_24])], []).
test(a_bad_judgement_is_wrong_type) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(infringer_is_undertaking, maybe)], [wrong_type(infringer_is_undertaking)]).
test(a_wrong_type_comes_before_an_unknown_key) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(zz_key, 1), attribute(infringer_is_undertaking, maybe)], [wrong_type(infringer_is_undertaking), unknown_key(zz_key)]).
test(unknown_keys_are_named_once_in_first_occurrence_order) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(zeta, 1), attribute(alpha, 2), attribute(zeta, 3)], [unknown_key(zeta), unknown_key(alpha)]).
test(a_duplicate_key_is_not_also_wrong_type) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(infringer_is_undertaking, maybe), attribute(infringer_is_undertaking, true)], [duplicate_key(infringer_is_undertaking)]).
test(an_input_problem_comes_before_everything_else) :-
    administrative_fine_maximum([attribute(infringed_provisions, [article_5]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, 1.5)], input_problems([wrong_type(total_worldwide_annual_turnover_in_euros)]), []).

test(a_wrong_bound_cap_is_rejected, fail) :-
    gdpr_administrative_fine_maximum_profile_for(lower_percentage_basis, Profile),
    administrative_fine_maximum(Profile, fine_maximum(lower_maximum_tier, percentage_of_turnover, 1000000000), _).
test(status_wrongly_bound_is_rejected, fail) :-
    gdpr_administrative_fine_maximum_profile_for(lower_tie_at_fixed, Profile),
    gdpr_administrative_fine_maximum_status(Profile, separate_fine_maxima).
test(a_duplicate_key_with_a_wrong_type_is_not_a_clean_profile, fail) :-
    gdpr_administrative_fine_maximum_input_problems([attribute(infringer_is_undertaking, maybe), attribute(infringer_is_undertaking, true)], []).

cp_test_names([lower_percentage_with_the_verdict_bound, lower_tie_with_the_verdict_bound, higher_fixed_with_the_verdict_bound, non_undertaking_with_the_verdict_bound, certification_body_cites_both_points, order_non_compliance_cites_paragraph_six, combined_cites_art_83_3_last, separate_maxima_with_the_verdict_bound, unsure_undertaking_with_the_verdict_bound, unlisted_provision_with_the_verdict_bound, missing_turnover_with_the_verdict_bound, missing_everything_names_three_keys, input_problem_with_the_verdict_bound, status_with_the_status_bound, a_well_formed_profile_has_no_problem, an_empty_profile_has_no_problem, a_non_list_is_not_a_profile, a_float_turnover_is_wrong_type, an_empty_provision_list_is_wrong_type, a_non_atom_provision_is_wrong_type, an_unlisted_atom_is_not_an_input_problem, a_bad_judgement_is_wrong_type, a_wrong_type_comes_before_an_unknown_key, unknown_keys_are_named_once_in_first_occurrence_order, a_duplicate_key_is_not_also_wrong_type, an_input_problem_comes_before_everything_else]).
cp_test_fail_names([a_wrong_bound_cap_is_rejected, status_wrongly_bound_is_rejected, a_duplicate_key_with_a_wrong_type_is_not_a_clean_profile]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
