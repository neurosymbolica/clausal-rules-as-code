% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_automated_decision_making_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_automated_decision_making_queries, [uk_automated_decision_making_profile_keys/1, uk_automated_decision_making_what_if/4, unsure/0, meaningful_human_involvement_in_the_decision/0]).
:- use_module(m__uk_uk_automated_decision_making_kernel, [uk_automated_decision_making_input_problems/2]).
:- use_module(m__uk_uk_automated_decision_making_uk_automated_decision_making, [uk_automated_decision_restriction/3, compare_uk_eu_automated_decision/5, uk_automated_decision_making_checklist/2]).
:- use_module(m__uk_uk_automated_decision_making_fixtures, [uk_automated_decision_making_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    uk_automated_decision_making_profile_keys(ProfileKeys),
    ProfileKeys == [decision_based_entirely_or_partly_on_personal_data, meaningful_human_involvement_in_the_decision, decision_produces_a_legal_effect_for_the_data_subject, decision_has_a_similarly_significant_effect_for_the_data_subject, processing_for_the_decision_relies_on_article_6_1_ea, decision_based_entirely_or_partly_on_special_category_data, decision_based_entirely_on_processing_with_explicit_consent, uk_article_9_2_g_applies, decision_necessary_for_a_contract_with_the_data_subject, decision_required_or_authorised_by_law, decision_authorised_by_union_or_member_state_law_laying_down_suitable_measures, decision_based_on_explicit_consent, article_9_2_a_applies, eu_article_9_2_g_applies, suitable_measures_for_special_category_data_in_place, safeguards_provide_information_about_decisions, safeguards_enable_representations, safeguards_enable_human_intervention, safeguards_enable_contesting].
test(root_exports_are_callable) :-
    unsure,
    meaningful_human_involvement_in_the_decision.
test(input_problems_re_exported_by_the_query_layer) :-
    findall(Problems, uk_automated_decision_making_input_problems([attribute(colour, true), attribute(colour, false)], Problems), AllProblems),
    AllProblems == [[unknown_key(colour)]].
test(status_determination_has_one_answer) :-
    uk_automated_decision_making_profile_for(special_category_with_explicit_consent_permitted, Profile),
    findall(Result, uk_automated_decision_restriction(Profile, Result, _), Results),
    Results == [decision_permitted].
test(comparison_sets_the_two_answers_side_by_side) :-
    uk_automated_decision_making_profile_for(special_category_contract_without_point_g_prohibited, Profile),
    findall(UkResult - EuResult - Difference, compare_uk_eu_automated_decision(Profile, UkResult, EuResult, Difference, _), Answers),
    Answers == [decision_prohibited - decision_permitted - differs].
test(checklist_carries_a_citation_per_ground) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    uk_automated_decision_making_checklist(Profile, Items),
    Items == [item(article_22a_significant_decision, significant_decision_based_solely_on_automated_processing, cite(uk_gdpr_art_22a_1)), item(article_22b_restriction, decision_permitted, cite(uk_gdpr_art_22b_1)), item(article_22c_safeguards, required_safeguards_in_place, cite(uk_gdpr_art_22c_1)), item(eu_article_22_restriction, decision_permitted, cite(eu_reg_2016_679_art_22_1))].
test(what_if_human_involvement_disengages_the_restrictions) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    findall(Status, uk_automated_decision_making_what_if(Profile, meaningful_human_involvement_in_the_decision, true, Status), Statuses),
    Statuses == [restrictions_not_engaged].
test(what_if_reliance_on_article_6_1_ea_prohibits) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    uk_automated_decision_making_what_if(Profile, processing_for_the_decision_relies_on_article_6_1_ea, true, Status),
    Status == decision_prohibited.

cp_test_names([profile_keys_are_the_contract_keys, root_exports_are_callable, input_problems_re_exported_by_the_query_layer, status_determination_has_one_answer, comparison_sets_the_two_answers_side_by_side, checklist_carries_a_citation_per_ground, what_if_human_involvement_disengages_the_restrictions, what_if_reliance_on_article_6_1_ea_prohibits]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
