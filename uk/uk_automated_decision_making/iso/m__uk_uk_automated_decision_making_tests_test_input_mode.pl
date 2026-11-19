% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_automated_decision_making_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_automated_decision_making_uk_automated_decision_making, [uk_significant_automated_decision/3, uk_automated_decision_restriction/3, uk_automated_decision_safeguards/3, eu_automated_decision/3, compare_uk_eu_automated_decision/5, uk_automated_decision_making_status/2]).
:- use_module(m__uk_uk_automated_decision_making_kernel, [uk_automated_decision_making_input_problems/2]).
:- use_module(m__uk_uk_automated_decision_making_fixtures, [uk_automated_decision_making_profile_for/2]).

uk_article_22b_citations([cite(uk_gdpr_art_22b_1), cite(uk_gdpr_art_22b_2), cite(uk_gdpr_art_22b_3), cite(uk_gdpr_art_22b_3_a), cite(uk_gdpr_art_22b_3_a_i), cite(uk_gdpr_art_22b_3_a_ii), cite(uk_gdpr_art_22b_3_b), cite(uk_gdpr_art_22b_4)]).

test(significance_holds_with_the_verdict_bound) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    uk_automated_decision_restriction(Profile, decision_permitted, _),
    uk_significant_automated_decision(Profile, significant_decision_based_solely_on_automated_processing, _).
test(human_involvement_bound_not_significant) :-
    uk_automated_decision_making_profile_for(human_involved_decision, Profile),
    uk_significant_automated_decision(Profile, not_a_significant_decision_based_solely_on_automated_processing, _).
test(restriction_permitted_bound) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    uk_article_22b_citations(Citations),
    uk_automated_decision_restriction(Profile, decision_permitted, Citations).
test(legitimate_interest_bound_prohibited) :-
    uk_automated_decision_making_profile_for(recognised_legitimate_interest_prohibited, Profile),
    uk_automated_decision_restriction(Profile, decision_prohibited, _).
test(human_involvement_bound_not_engaged) :-
    uk_automated_decision_making_profile_for(human_involved_decision, Profile),
    uk_automated_decision_restriction(Profile, restrictions_not_engaged, _).
test(safeguards_in_place_bound) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    uk_automated_decision_safeguards(Profile, required_safeguards_in_place, _).
test(safeguards_not_in_place_bound) :-
    uk_automated_decision_making_profile_for(ordinary_decision_missing_contesting_safeguard, Profile),
    uk_automated_decision_safeguards(Profile, required_safeguards_not_in_place, _).
test(european_prohibited_bound) :-
    uk_automated_decision_making_profile_for(decision_without_european_exception, Profile),
    eu_automated_decision(Profile, decision_prohibited, _).
test(comparison_bound_in_every_position) :-
    uk_automated_decision_making_profile_for(recognised_legitimate_interest_prohibited, Profile),
    uk_article_22b_citations(Citations),
    compare_uk_eu_automated_decision(Profile, decision_prohibited, decision_permitted, differs, Citations).
test(referral_bound_as_the_status) :-
    uk_automated_decision_making_profile_for(unsure_human_involvement_referred, Profile),
    uk_automated_decision_making_status(Profile, needs_legal_review(open_textured(meaningful_human_involvement_in_the_decision, cite(uk_gdpr_art_22a_1_a)), [inputs_relied_on(_)])).
test(a_well_formed_profile_has_no_problem_bound) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    uk_automated_decision_making_input_problems(Profile, []).
test(badly_formed_profile_problems_bound) :-
    uk_automated_decision_making_profile_for(badly_formed_profile, Profile),
    uk_automated_decision_making_input_problems(Profile, [wrong_type(meaningful_human_involvement_in_the_decision), unknown_key(colour)]).
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    uk_automated_decision_making_input_problems(not_a_profile, [wrong_type(profile)]).
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, uk_automated_decision_making_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_holding_a_non_attribute_is_wrong_type_profile) :-
    uk_automated_decision_making_input_problems([attribute(meaningful_human_involvement_in_the_decision, true), stray], [wrong_type(profile)]).
test(an_unbound_value_is_wrong_type_of_its_key) :-
    findall(Problems, uk_automated_decision_making_input_problems([attribute(meaningful_human_involvement_in_the_decision, _)], Problems), Answers),
    Answers == [[wrong_type(meaningful_human_involvement_in_the_decision)]].
test(unsure_on_a_crisp_key_is_wrong_type) :-
    uk_automated_decision_making_input_problems([attribute(decision_based_entirely_or_partly_on_personal_data, unsure)], [wrong_type(decision_based_entirely_or_partly_on_personal_data)]).
test(a_number_key_is_named_as_given) :-
    uk_automated_decision_making_input_problems([attribute(7, true)], [unknown_key(7)]).
test(a_duplicate_key_is_named_once) :-
    uk_automated_decision_making_profile_for(duplicated_key_profile, Profile),
    uk_automated_decision_making_input_problems(Profile, [duplicate_key(meaningful_human_involvement_in_the_decision)]).

test(significance_rejects_the_wrong_bound_verdict, fail) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    uk_significant_automated_decision(Profile, not_a_significant_decision_based_solely_on_automated_processing, _).
test(restriction_permitted_rejects_prohibited, fail) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    uk_automated_decision_restriction(Profile, decision_prohibited, _).
test(legitimate_interest_rejects_permitted, fail) :-
    uk_automated_decision_making_profile_for(recognised_legitimate_interest_prohibited, Profile),
    uk_automated_decision_restriction(Profile, decision_permitted, _).
test(safeguards_in_place_rejects_not_in_place, fail) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    uk_automated_decision_safeguards(Profile, required_safeguards_not_in_place, _).
test(european_prohibited_rejects_permitted, fail) :-
    uk_automated_decision_making_profile_for(decision_without_european_exception, Profile),
    eu_automated_decision(Profile, decision_permitted, _).
test(comparison_rejects_same_for_a_difference, fail) :-
    uk_automated_decision_making_profile_for(recognised_legitimate_interest_prohibited, Profile),
    compare_uk_eu_automated_decision(Profile, _, _, same, _).
test(badly_formed_profile_is_not_problem_free, fail) :-
    uk_automated_decision_making_profile_for(badly_formed_profile, Profile),
    uk_automated_decision_making_input_problems(Profile, []).

cp_test_names([significance_holds_with_the_verdict_bound, human_involvement_bound_not_significant, restriction_permitted_bound, legitimate_interest_bound_prohibited, human_involvement_bound_not_engaged, safeguards_in_place_bound, safeguards_not_in_place_bound, european_prohibited_bound, comparison_bound_in_every_position, referral_bound_as_the_status, a_well_formed_profile_has_no_problem_bound, badly_formed_profile_problems_bound, a_term_that_is_not_a_list_is_wrong_type_profile, an_unbound_profile_is_wrong_type_profile, a_list_holding_a_non_attribute_is_wrong_type_profile, an_unbound_value_is_wrong_type_of_its_key, unsure_on_a_crisp_key_is_wrong_type, a_number_key_is_named_as_given, a_duplicate_key_is_named_once]).
cp_test_fail_names([significance_rejects_the_wrong_bound_verdict, restriction_permitted_rejects_prohibited, legitimate_interest_rejects_permitted, safeguards_in_place_rejects_not_in_place, european_prohibited_rejects_permitted, comparison_rejects_same_for_a_difference, badly_formed_profile_is_not_problem_free]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
