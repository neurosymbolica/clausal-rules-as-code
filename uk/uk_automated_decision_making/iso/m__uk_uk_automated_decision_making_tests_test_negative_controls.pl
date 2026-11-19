% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_automated_decision_making_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_automated_decision_making_uk_automated_decision_making, [uk_significant_automated_decision/3, uk_automated_decision_restriction/3, uk_automated_decision_safeguards/3, eu_automated_decision/3, compare_uk_eu_automated_decision/5, uk_automated_decision_making_status_values/1]).
:- use_module(m__uk_uk_automated_decision_making_kernel, [uk_automated_decision_making_input_problems/2]).
:- use_module(m__uk_uk_automated_decision_making_fixtures, [uk_automated_decision_making_profile_for/2]).

with_value([], _, _, []).
with_value([attribute(Key, _)|Attributes], Key, Value, [attribute(Key, Value)|NewAttributes]) :-
    with_value(Attributes, Key, Value, NewAttributes).
with_value([attribute(Other, OldValue)|Attributes], Key, Value, [attribute(Other, OldValue)|NewAttributes]) :-
    dif(Other, Key),
    with_value(Attributes, Key, Value, NewAttributes).

near_miss(Subject, Key, Value, NearMiss) :-
    uk_automated_decision_making_profile_for(Subject, Profile),
    with_value(Profile, Key, Value, NearMiss).

test(the_status_table_has_a_near_miss_atom) :-
    uk_automated_decision_making_status_values(StatusValues),
    StatusValues == [restrictions_not_engaged, decision_permitted, decision_prohibited].
test(solely_automated_is_significant) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    uk_significant_automated_decision(Profile, significant_decision_based_solely_on_automated_processing, _).
test(human_involvement_near_miss_is_not_significant) :-
    near_miss(ordinary_decision_permitted_with_safeguards_in_place, meaningful_human_involvement_in_the_decision, true, NearMiss),
    uk_significant_automated_decision(NearMiss, not_a_significant_decision_based_solely_on_automated_processing, _).
test(similar_effect_alone_is_significant) :-
    uk_automated_decision_making_profile_for(decision_with_similarly_significant_effect_only, Profile),
    uk_significant_automated_decision(Profile, significant_decision_based_solely_on_automated_processing, _).
test(no_effect_near_miss_is_not_significant) :-
    near_miss(decision_with_similarly_significant_effect_only, decision_has_a_similarly_significant_effect_for_the_data_subject, false, NearMiss),
    uk_significant_automated_decision(NearMiss, not_a_significant_decision_based_solely_on_automated_processing, _).
test(no_recognised_legitimate_interest_is_permitted) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    uk_automated_decision_restriction(Profile, decision_permitted, _).
test(recognised_legitimate_interest_near_miss_is_prohibited) :-
    near_miss(ordinary_decision_permitted_with_safeguards_in_place, processing_for_the_decision_relies_on_article_6_1_ea, true, NearMiss),
    uk_automated_decision_restriction(NearMiss, decision_prohibited, _).
test(special_category_without_condition_is_prohibited) :-
    uk_automated_decision_making_profile_for(special_category_without_condition_prohibited, Profile),
    uk_automated_decision_restriction(Profile, decision_prohibited, _).
test(explicit_consent_near_miss_is_permitted) :-
    near_miss(special_category_without_condition_prohibited, decision_based_entirely_on_processing_with_explicit_consent, true, NearMiss),
    uk_automated_decision_restriction(NearMiss, decision_permitted, _).
test(contract_and_point_g_is_permitted) :-
    uk_automated_decision_making_profile_for(special_category_contract_and_point_g_permitted, Profile),
    uk_automated_decision_restriction(Profile, decision_permitted, _).
test(point_g_near_miss_is_prohibited) :-
    near_miss(special_category_contract_and_point_g_permitted, uk_article_9_2_g_applies, false, NearMiss),
    uk_automated_decision_restriction(NearMiss, decision_prohibited, _).
test(no_contract_and_no_law_near_miss_is_prohibited) :-
    near_miss(special_category_contract_and_point_g_permitted, decision_necessary_for_a_contract_with_the_data_subject, false, NearMiss),
    uk_automated_decision_restriction(NearMiss, decision_prohibited, _).
test(authorised_by_law_alternative_is_permitted) :-
    near_miss(special_category_contract_and_point_g_permitted, decision_necessary_for_a_contract_with_the_data_subject, false, WithoutContract),
    with_value(WithoutContract, decision_required_or_authorised_by_law, true, NearMiss),
    uk_automated_decision_restriction(NearMiss, decision_permitted, _).
test(human_involved_is_not_engaged) :-
    uk_automated_decision_making_profile_for(human_involved_decision, Profile),
    uk_automated_decision_restriction(Profile, restrictions_not_engaged, _).
test(all_four_measures_are_in_place) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    uk_automated_decision_safeguards(Profile, required_safeguards_in_place, _).
test(missing_contesting_near_miss_is_not_in_place) :-
    uk_automated_decision_making_profile_for(ordinary_decision_missing_contesting_safeguard, Profile),
    uk_automated_decision_safeguards(Profile, required_safeguards_not_in_place, _).
test(missing_information_near_miss_is_not_in_place) :-
    near_miss(ordinary_decision_permitted_with_safeguards_in_place, safeguards_provide_information_about_decisions, false, NearMiss),
    uk_automated_decision_safeguards(NearMiss, required_safeguards_not_in_place, _).
test(no_personal_data_near_miss_is_not_required) :-
    uk_automated_decision_making_profile_for(ordinary_decision_without_personal_data, Profile),
    uk_automated_decision_safeguards(Profile, safeguards_not_required, _).
test(european_without_exception_is_prohibited) :-
    uk_automated_decision_making_profile_for(decision_without_european_exception, Profile),
    eu_automated_decision(Profile, decision_prohibited, _).
test(european_explicit_consent_near_miss_is_permitted) :-
    near_miss(decision_without_european_exception, decision_based_on_explicit_consent, true, NearMiss),
    eu_automated_decision(NearMiss, decision_permitted, _).
test(european_authorised_by_law_near_miss_is_permitted) :-
    near_miss(decision_without_european_exception, decision_authorised_by_union_or_member_state_law_laying_down_suitable_measures, true, NearMiss),
    eu_automated_decision(NearMiss, decision_permitted, _).
test(european_point_g_and_measures_is_permitted) :-
    uk_automated_decision_making_profile_for(special_category_contract_and_point_g_permitted, Profile),
    eu_automated_decision(Profile, decision_permitted, _).
test(european_suitable_measures_near_miss_is_prohibited) :-
    near_miss(special_category_contract_and_point_g_permitted, suitable_measures_for_special_category_data_in_place, false, NearMiss),
    eu_automated_decision(NearMiss, decision_prohibited, _).
test(european_point_g_near_miss_is_prohibited) :-
    near_miss(special_category_contract_and_point_g_permitted, eu_article_9_2_g_applies, false, NearMiss),
    eu_automated_decision(NearMiss, decision_prohibited, _).
test(european_point_a_alternative_is_permitted) :-
    near_miss(special_category_contract_and_point_g_permitted, eu_article_9_2_g_applies, false, WithoutPointG),
    with_value(WithoutPointG, article_9_2_a_applies, true, NearMiss),
    eu_automated_decision(NearMiss, decision_permitted, _).
test(ordinary_comparison_is_same) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    compare_uk_eu_automated_decision(Profile, decision_permitted, decision_permitted, same, []).
test(contract_near_miss_comparison_differs) :-
    near_miss(ordinary_decision_permitted_with_safeguards_in_place, decision_necessary_for_a_contract_with_the_data_subject, false, NearMiss),
    compare_uk_eu_automated_decision(NearMiss, decision_permitted, decision_prohibited, differs, [_|_]).
test(unsure_involvement_is_referred) :-
    uk_automated_decision_making_profile_for(unsure_human_involvement_referred, Profile),
    uk_significant_automated_decision(Profile, needs_legal_review(open_textured(meaningful_human_involvement_in_the_decision, cite(uk_gdpr_art_22a_1_a)), _), []).
test(unsure_involvement_without_effect_is_settled) :-
    uk_automated_decision_making_profile_for(unsure_human_involvement_without_effect, Profile),
    uk_significant_automated_decision(Profile, not_a_significant_decision_based_solely_on_automated_processing, _).
test(missing_effect_keys_are_indeterminate) :-
    uk_automated_decision_making_profile_for(partial_profile_missing_effect_keys, Profile),
    uk_significant_automated_decision(Profile, indeterminate([decision_produces_a_legal_effect_for_the_data_subject]), []).
test(legal_effect_near_miss_is_settled) :-
    uk_automated_decision_making_profile_for(partial_profile_with_legal_effect, Profile),
    uk_significant_automated_decision(Profile, significant_decision_based_solely_on_automated_processing, _).
test(badly_formed_profile_has_problems) :-
    uk_automated_decision_making_profile_for(badly_formed_profile, Profile),
    uk_automated_decision_restriction(Profile, input_problems([_|_]), []).
test(well_formed_near_miss_has_no_problem) :-
    uk_automated_decision_making_input_problems([attribute(meaningful_human_involvement_in_the_decision, true)], []).

test(human_involvement_near_miss_is_not_solely_automated, fail) :-
    near_miss(ordinary_decision_permitted_with_safeguards_in_place, meaningful_human_involvement_in_the_decision, true, NearMiss),
    uk_significant_automated_decision(NearMiss, significant_decision_based_solely_on_automated_processing, _).
test(no_effect_near_miss_is_not_engaged_not_permitted, fail) :-
    near_miss(decision_with_similarly_significant_effect_only, decision_has_a_similarly_significant_effect_for_the_data_subject, false, NearMiss),
    uk_automated_decision_restriction(NearMiss, decision_permitted, _).
test(recognised_legitimate_interest_near_miss_is_not_permitted, fail) :-
    near_miss(ordinary_decision_permitted_with_safeguards_in_place, processing_for_the_decision_relies_on_article_6_1_ea, true, NearMiss),
    uk_automated_decision_restriction(NearMiss, decision_permitted, _).
test(special_category_without_condition_is_not_permitted, fail) :-
    uk_automated_decision_making_profile_for(special_category_without_condition_prohibited, Profile),
    uk_automated_decision_restriction(Profile, decision_permitted, _).
test(point_g_near_miss_is_not_permitted, fail) :-
    near_miss(special_category_contract_and_point_g_permitted, uk_article_9_2_g_applies, false, NearMiss),
    uk_automated_decision_restriction(NearMiss, decision_permitted, _).
test(human_involved_is_not_permitted, fail) :-
    uk_automated_decision_making_profile_for(human_involved_decision, Profile),
    uk_automated_decision_restriction(Profile, decision_permitted, _).
test(missing_contesting_is_not_in_place_only, fail) :-
    uk_automated_decision_making_profile_for(ordinary_decision_missing_contesting_safeguard, Profile),
    uk_automated_decision_safeguards(Profile, required_safeguards_in_place, _).
test(no_personal_data_is_not_required_in_place, fail) :-
    uk_automated_decision_making_profile_for(ordinary_decision_without_personal_data, Profile),
    uk_automated_decision_safeguards(Profile, required_safeguards_in_place, _).
test(european_without_exception_is_not_permitted, fail) :-
    uk_automated_decision_making_profile_for(decision_without_european_exception, Profile),
    eu_automated_decision(Profile, decision_permitted, _).
test(european_suitable_measures_near_miss_is_not_permitted, fail) :-
    near_miss(special_category_contract_and_point_g_permitted, suitable_measures_for_special_category_data_in_place, false, NearMiss),
    eu_automated_decision(NearMiss, decision_permitted, _).
test(ordinary_comparison_does_not_differ, fail) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    compare_uk_eu_automated_decision(Profile, _, _, differs, _).
test(unsure_involvement_without_effect_is_not_referred, fail) :-
    uk_automated_decision_making_profile_for(unsure_human_involvement_without_effect, Profile),
    uk_significant_automated_decision(Profile, needs_legal_review(_, _), _).
test(legal_effect_near_miss_is_not_indeterminate, fail) :-
    uk_automated_decision_making_profile_for(partial_profile_with_legal_effect, Profile),
    uk_significant_automated_decision(Profile, indeterminate(_), _).
test(badly_formed_profile_gets_no_verdict, fail) :-
    uk_automated_decision_making_profile_for(badly_formed_profile, Profile),
    uk_automated_decision_restriction(Profile, restrictions_not_engaged, _).

cp_test_names([the_status_table_has_a_near_miss_atom, solely_automated_is_significant, human_involvement_near_miss_is_not_significant, similar_effect_alone_is_significant, no_effect_near_miss_is_not_significant, no_recognised_legitimate_interest_is_permitted, recognised_legitimate_interest_near_miss_is_prohibited, special_category_without_condition_is_prohibited, explicit_consent_near_miss_is_permitted, contract_and_point_g_is_permitted, point_g_near_miss_is_prohibited, no_contract_and_no_law_near_miss_is_prohibited, authorised_by_law_alternative_is_permitted, human_involved_is_not_engaged, all_four_measures_are_in_place, missing_contesting_near_miss_is_not_in_place, missing_information_near_miss_is_not_in_place, no_personal_data_near_miss_is_not_required, european_without_exception_is_prohibited, european_explicit_consent_near_miss_is_permitted, european_authorised_by_law_near_miss_is_permitted, european_point_g_and_measures_is_permitted, european_suitable_measures_near_miss_is_prohibited, european_point_g_near_miss_is_prohibited, european_point_a_alternative_is_permitted, ordinary_comparison_is_same, contract_near_miss_comparison_differs, unsure_involvement_is_referred, unsure_involvement_without_effect_is_settled, missing_effect_keys_are_indeterminate, legal_effect_near_miss_is_settled, badly_formed_profile_has_problems, well_formed_near_miss_has_no_problem]).
cp_test_fail_names([human_involvement_near_miss_is_not_solely_automated, no_effect_near_miss_is_not_engaged_not_permitted, recognised_legitimate_interest_near_miss_is_not_permitted, special_category_without_condition_is_not_permitted, point_g_near_miss_is_not_permitted, human_involved_is_not_permitted, missing_contesting_is_not_in_place_only, no_personal_data_is_not_required_in_place, european_without_exception_is_not_permitted, european_suitable_measures_near_miss_is_not_permitted, ordinary_comparison_does_not_differ, unsure_involvement_without_effect_is_not_referred, legal_effect_near_miss_is_not_indeterminate, badly_formed_profile_gets_no_verdict]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
