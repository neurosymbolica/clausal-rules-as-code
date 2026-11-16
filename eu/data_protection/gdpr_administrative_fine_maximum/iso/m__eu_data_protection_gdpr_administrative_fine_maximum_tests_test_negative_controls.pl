% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [administrative_fine_maximum/3, gdpr_administrative_fine_maximum_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_fixtures, [gdpr_administrative_fine_maximum_profile_for/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_queries, [gdpr_administrative_fine_maximum_what_if/4]).

verdict_of(Subject, Verdict) :-
    gdpr_administrative_fine_maximum_profile_for(Subject, Profile),
    administrative_fine_maximum(Profile, Verdict, _).

flipped(Subject, Key, Value, Verdict) :-
    gdpr_administrative_fine_maximum_profile_for(Subject, Profile),
    gdpr_administrative_fine_maximum_what_if(Profile, Key, Value, Verdict).

test(the_near_miss_verdicts_are_real_verdict_atoms) :-
    gdpr_administrative_fine_maximum_status_values(StatusValues),
    member(fine_maximum, StatusValues),
    member(separate_fine_maxima, StatusValues),
    member(indeterminate, StatusValues),
    member(needs_legal_review, StatusValues),
    member(input_problems, StatusValues).
test(lower_tie_is_the_fixed_amount) :-
    verdict_of(lower_tie_at_fixed, fine_maximum(lower_maximum_tier, fixed_amount, 1000000000)).
test(lower_one_euro_above_is_the_percentage) :-
    verdict_of(lower_one_euro_above_tie, fine_maximum(lower_maximum_tier, percentage_of_turnover, 1000000002)).
test(higher_tie_is_the_fixed_amount) :-
    verdict_of(higher_tie_at_fixed, fine_maximum(higher_maximum_tier, fixed_amount, 2000000000)).
test(higher_one_euro_above_is_the_percentage) :-
    verdict_of(higher_one_euro_above_tie, fine_maximum(higher_maximum_tier, percentage_of_turnover, 2000000004)).
test(article_32_is_the_lower_tier) :-
    verdict_of(lower_tie_at_fixed, fine_maximum(lower_maximum_tier, _, _)).
test(article_6_at_the_same_turnover_is_the_higher_tier) :-
    flipped(lower_tie_at_fixed, infringed_provisions, [article_6], fine_maximum(higher_maximum_tier, fixed_amount, 2000000000)).
test(a_non_undertaking_gets_the_fixed_amount_alone) :-
    verdict_of(higher_non_undertaking_ignores_turnover, fine_maximum(higher_maximum_tier, fixed_amount_for_non_undertaking, 2000000000)).
test(the_same_infringer_as_an_undertaking_gets_the_percentage) :-
    flipped(higher_non_undertaking_ignores_turnover, infringer_is_undertaking, true, fine_maximum(higher_maximum_tier, percentage_of_turnover, 3999999999996)).
test(linked_and_negligent_gives_the_gravest_maximum) :-
    verdict_of(combined_gravest_is_higher, fine_maximum(higher_maximum_tier, percentage_of_turnover, 4000000000)).
test(not_linked_gives_separate_maxima) :-
    flipped(combined_gravest_is_higher, infringements_concern_same_or_linked_processing_operations, false, separate_fine_maxima([infringement_maximum(article_32, lower_maximum_tier, percentage_of_turnover, 2000000000), infringement_maximum(article_5, higher_maximum_tier, percentage_of_turnover, 4000000000)])).
test(not_negligent_gives_separate_maxima) :-
    flipped(combined_gravest_is_higher, infringements_intentional_or_negligent, false, separate_fine_maxima([_, _])).
test(separate_made_linked_and_negligent_is_a_single_maximum) :-
    flipped(separate_not_linked, infringements_concern_same_or_linked_processing_operations, true, fine_maximum(higher_maximum_tier, percentage_of_turnover, 4000000000)).
test(one_provision_needs_no_art_83_3_key) :-
    verdict_of(lower_non_undertaking, fine_maximum(lower_maximum_tier, _, _)).
test(two_provisions_without_art_83_3_keys_are_indeterminate) :-
    verdict_of(missing_art_83_3_keys, indeterminate([infringements_concern_same_or_linked_processing_operations, infringements_intentional_or_negligent])).
test(unsure_undertaking_refers) :-
    verdict_of(unsure_undertaking, needs_legal_review(open_textured(infringer_is_undertaking, cite(eu_reg_2016_679_art_83_4)), _)).
test(a_settled_undertaking_gives_a_final_answer) :-
    flipped(unsure_undertaking, infringer_is_undertaking, true, fine_maximum(higher_maximum_tier, fixed_amount, 2000000000)).
test(unsure_art_83_3_key_refers) :-
    verdict_of(unsure_first_art_83_3_key, needs_legal_review(open_textured(infringements_concern_same_or_linked_processing_operations, cite(eu_reg_2016_679_art_83_3)), _)).
test(a_settled_art_83_3_key_gives_a_final_answer) :-
    flipped(unsure_first_art_83_3_key, infringements_concern_same_or_linked_processing_operations, true, fine_maximum(higher_maximum_tier, fixed_amount, 2000000000)).
test(a_false_key_settles_separate_without_the_unsure_one_referring) :-
    verdict_of(separate_one_unsure_one_false, separate_fine_maxima([_, _])).
test(missing_turnover_is_indeterminate) :-
    verdict_of(missing_turnover, indeterminate([total_worldwide_annual_turnover_in_euros])).
test(supplying_the_turnover_gives_a_final_answer) :-
    flipped(missing_turnover, total_worldwide_annual_turnover_in_euros, 1000, fine_maximum(higher_maximum_tier, fixed_amount, 2000000000)).
test(a_non_undertaking_needs_no_turnover) :-
    verdict_of(lower_non_undertaking, fine_maximum(lower_maximum_tier, fixed_amount_for_non_undertaking, 1000000000)).
test(an_unlisted_provision_is_not_governed_here) :-
    verdict_of(unlisted_provision, needs_legal_review(not_governed_here(_), _)).
test(a_listed_provision_gets_a_final_answer) :-
    flipped(unlisted_provision, infringed_provisions, [article_5], fine_maximum(higher_maximum_tier, fixed_amount, 2000000000)).
test(one_unlisted_among_listed_is_not_governed_here) :-
    verdict_of(unlisted_with_duplicates, needs_legal_review(not_governed_here(_), _)).
test(a_negative_turnover_is_an_input_problem) :-
    verdict_of(input_negative_turnover, input_problems([wrong_type(total_worldwide_annual_turnover_in_euros)])).
test(a_zero_turnover_is_well_formed) :-
    flipped(input_negative_turnover, total_worldwide_annual_turnover_in_euros, 0, fine_maximum(higher_maximum_tier, fixed_amount, 2000000000)).
test(a_duplicate_key_is_an_input_problem) :-
    verdict_of(input_duplicate_key, input_problems([duplicate_key(infringer_is_undertaking)])).
test(article_42_is_the_lower_tier_whoever_the_actor_is) :-
    verdict_of(certification_body_article_42, fine_maximum(lower_maximum_tier, fixed_amount, 1000000000)).

test(lower_tie_is_not_the_percentage, fail) :-
    verdict_of(lower_tie_at_fixed, fine_maximum(_, percentage_of_turnover, _)).
test(lower_one_euro_above_is_not_the_fixed_amount, fail) :-
    verdict_of(lower_one_euro_above_tie, fine_maximum(_, fixed_amount, _)).
test(higher_tie_is_not_the_percentage, fail) :-
    verdict_of(higher_tie_at_fixed, fine_maximum(_, percentage_of_turnover, _)).
test(article_32_is_not_the_higher_tier, fail) :-
    verdict_of(lower_tie_at_fixed, fine_maximum(higher_maximum_tier, _, _)).
test(a_non_undertaking_never_gets_the_percentage, fail) :-
    verdict_of(higher_non_undertaking_ignores_turnover, fine_maximum(_, percentage_of_turnover, _)).
test(not_linked_is_not_a_single_maximum, fail) :-
    flipped(combined_gravest_is_higher, infringements_concern_same_or_linked_processing_operations, false, fine_maximum(_, _, _)).
test(combined_is_not_separate, fail) :-
    verdict_of(combined_gravest_is_higher, separate_fine_maxima(_)).
test(two_provisions_without_art_83_3_keys_are_not_final, fail) :-
    verdict_of(missing_art_83_3_keys, fine_maximum(_, _, _)).
test(unsure_undertaking_is_not_final, fail) :-
    verdict_of(unsure_undertaking, fine_maximum(_, _, _)).
test(a_false_key_is_not_a_referral, fail) :-
    verdict_of(separate_one_unsure_one_false, needs_legal_review(_, _)).
test(missing_turnover_is_not_final, fail) :-
    verdict_of(missing_turnover, fine_maximum(_, _, _)).
test(an_unlisted_provision_has_no_maximum, fail) :-
    verdict_of(unlisted_provision, fine_maximum(_, _, _)).
test(a_negative_turnover_is_not_final, fail) :-
    verdict_of(input_negative_turnover, fine_maximum(_, _, _)).
test(a_duplicate_key_is_not_final, fail) :-
    verdict_of(input_duplicate_key, fine_maximum(_, _, _)).
test(article_42_is_not_the_higher_tier, fail) :-
    verdict_of(certification_body_article_42, fine_maximum(higher_maximum_tier, _, _)).

cp_test_names([the_near_miss_verdicts_are_real_verdict_atoms, lower_tie_is_the_fixed_amount, lower_one_euro_above_is_the_percentage, higher_tie_is_the_fixed_amount, higher_one_euro_above_is_the_percentage, article_32_is_the_lower_tier, article_6_at_the_same_turnover_is_the_higher_tier, a_non_undertaking_gets_the_fixed_amount_alone, the_same_infringer_as_an_undertaking_gets_the_percentage, linked_and_negligent_gives_the_gravest_maximum, not_linked_gives_separate_maxima, not_negligent_gives_separate_maxima, separate_made_linked_and_negligent_is_a_single_maximum, one_provision_needs_no_art_83_3_key, two_provisions_without_art_83_3_keys_are_indeterminate, unsure_undertaking_refers, a_settled_undertaking_gives_a_final_answer, unsure_art_83_3_key_refers, a_settled_art_83_3_key_gives_a_final_answer, a_false_key_settles_separate_without_the_unsure_one_referring, missing_turnover_is_indeterminate, supplying_the_turnover_gives_a_final_answer, a_non_undertaking_needs_no_turnover, an_unlisted_provision_is_not_governed_here, a_listed_provision_gets_a_final_answer, one_unlisted_among_listed_is_not_governed_here, a_negative_turnover_is_an_input_problem, a_zero_turnover_is_well_formed, a_duplicate_key_is_an_input_problem, article_42_is_the_lower_tier_whoever_the_actor_is]).
cp_test_fail_names([lower_tie_is_not_the_percentage, lower_one_euro_above_is_not_the_fixed_amount, higher_tie_is_not_the_percentage, article_32_is_not_the_higher_tier, a_non_undertaking_never_gets_the_percentage, not_linked_is_not_a_single_maximum, combined_is_not_separate, two_provisions_without_art_83_3_keys_are_not_final, unsure_undertaking_is_not_final, a_false_key_is_not_a_referral, missing_turnover_is_not_final, an_unlisted_provision_has_no_maximum, a_negative_turnover_is_not_final, a_duplicate_key_is_not_final, article_42_is_not_the_higher_tier]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
