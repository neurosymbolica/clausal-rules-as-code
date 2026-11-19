% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_automated_decision_making_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_automated_decision_making_uk_automated_decision_making, [decide_uk_automated_decision_making/2, uk_significant_automated_decision/3, uk_automated_decision_restriction/3, uk_automated_decision_safeguards/3, eu_automated_decision/3, compare_uk_eu_automated_decision/5]).
:- use_module(m__uk_uk_automated_decision_making_kernel, [uk_automated_decision_making_input_problems/2]).
:- use_module(m__uk_uk_automated_decision_making_fixtures, [uk_automated_decision_making_profile_for/2]).

uk_article_22a_citations([cite(uk_gdpr_art_22a_1), cite(uk_gdpr_art_22a_1_a), cite(uk_gdpr_art_22a_1_b), cite(uk_gdpr_art_22a_1_b_i), cite(uk_gdpr_art_22a_1_b_ii), cite(uk_gdpr_art_22a_2)]).

uk_article_22b_citations([cite(uk_gdpr_art_22b_1), cite(uk_gdpr_art_22b_2), cite(uk_gdpr_art_22b_3), cite(uk_gdpr_art_22b_3_a), cite(uk_gdpr_art_22b_3_a_i), cite(uk_gdpr_art_22b_3_a_ii), cite(uk_gdpr_art_22b_3_b), cite(uk_gdpr_art_22b_4)]).

uk_required_safeguards_citations([cite(uk_gdpr_art_22c_1), cite(uk_gdpr_art_22c_1_a), cite(uk_gdpr_art_22c_1_b), cite(uk_gdpr_art_22c_2), cite(uk_gdpr_art_22c_2_a), cite(uk_gdpr_art_22c_2_b), cite(uk_gdpr_art_22c_2_c), cite(uk_gdpr_art_22c_2_d)]).

uk_safeguards_not_required_citations([cite(uk_gdpr_art_22a_1), cite(uk_gdpr_art_22a_1_a), cite(uk_gdpr_art_22a_1_b), cite(uk_gdpr_art_22a_1_b_i), cite(uk_gdpr_art_22a_1_b_ii), cite(uk_gdpr_art_22a_2), cite(uk_gdpr_art_22c_1), cite(uk_gdpr_art_22c_1_a), cite(uk_gdpr_art_22c_1_b)]).

european_engaged_citations([cite(eu_reg_2016_679_art_22_1), cite(eu_reg_2016_679_art_22_2), cite(eu_reg_2016_679_art_22_2_a), cite(eu_reg_2016_679_art_22_2_b), cite(eu_reg_2016_679_art_22_2_c), cite(eu_reg_2016_679_art_22_4)]).

significance_answers(Subject, Answers) :-
    uk_automated_decision_making_profile_for(Subject, Profile),
    findall(Result - Citations, uk_significant_automated_decision(Profile, Result, Citations), Answers).

restriction_answers(Subject, Answers) :-
    uk_automated_decision_making_profile_for(Subject, Profile),
    findall(Result - Citations, uk_automated_decision_restriction(Profile, Result, Citations), Answers).

safeguards_answers(Subject, Answers) :-
    uk_automated_decision_making_profile_for(Subject, Profile),
    findall(Result - Citations, uk_automated_decision_safeguards(Profile, Result, Citations), Answers).

european_answers(Subject, Answers) :-
    uk_automated_decision_making_profile_for(Subject, Profile),
    findall(Result - Citations, eu_automated_decision(Profile, Result, Citations), Answers).

comparison_answers(Subject, Answers) :-
    uk_automated_decision_making_profile_for(Subject, Profile),
    findall(UkResult - EuResult - Difference - ChangedBy, compare_uk_eu_automated_decision(Profile, UkResult, EuResult, Difference, ChangedBy), Answers).

test(ordinary_significance) :-
    significance_answers(ordinary_decision_permitted_with_safeguards_in_place, Answers),
    uk_article_22a_citations(Citations),
    Answers == [significant_decision_based_solely_on_automated_processing - Citations].
test(ordinary_restriction) :-
    restriction_answers(ordinary_decision_permitted_with_safeguards_in_place, Answers),
    uk_article_22b_citations(Citations),
    Answers == [decision_permitted - Citations].
test(ordinary_safeguards) :-
    safeguards_answers(ordinary_decision_permitted_with_safeguards_in_place, Answers),
    uk_required_safeguards_citations(Citations),
    Answers == [required_safeguards_in_place - Citations].
test(ordinary_european) :-
    european_answers(ordinary_decision_permitted_with_safeguards_in_place, Answers),
    european_engaged_citations(Citations),
    Answers == [decision_permitted - Citations].
test(ordinary_comparison) :-
    comparison_answers(ordinary_decision_permitted_with_safeguards_in_place, Answers),
    Answers == [decision_permitted - decision_permitted - same - []].
test(ordinary_facade_verdict) :-
    uk_automated_decision_making_profile_for(ordinary_decision_permitted_with_safeguards_in_place, Profile),
    findall(Verdict, decide_uk_automated_decision_making(Profile, Verdict), Verdicts),
    uk_article_22b_citations(Citations),
    Verdicts == [uk_automated_decision_making_verdict(decision_permitted, Citations)].
test(human_involved_restriction_not_engaged) :-
    restriction_answers(human_involved_decision, Answers),
    uk_article_22a_citations(Citations),
    Answers == [restrictions_not_engaged - Citations].
test(human_involved_european_not_engaged) :-
    european_answers(human_involved_decision, Answers),
    Answers == [restrictions_not_engaged - [cite(eu_reg_2016_679_art_22_1)]].
test(human_involved_safeguards_not_required) :-
    safeguards_answers(human_involved_decision, Answers),
    uk_safeguards_not_required_citations(Citations),
    Answers == [safeguards_not_required - Citations].
test(without_personal_data_safeguards_not_required) :-
    safeguards_answers(ordinary_decision_without_personal_data, Answers),
    uk_safeguards_not_required_citations(Citations),
    Answers == [safeguards_not_required - Citations].
test(missing_contesting_safeguard_not_in_place) :-
    safeguards_answers(ordinary_decision_missing_contesting_safeguard, Answers),
    uk_required_safeguards_citations(Citations),
    Answers == [required_safeguards_not_in_place - Citations].
test(legitimate_interest_comparison_differs) :-
    comparison_answers(recognised_legitimate_interest_prohibited, Answers),
    uk_article_22b_citations(Citations),
    Answers == [decision_prohibited - decision_permitted - differs - Citations].
test(special_category_explicit_consent_comparison_differs) :-
    comparison_answers(special_category_with_explicit_consent_permitted, Answers),
    uk_article_22b_citations(Citations),
    Answers == [decision_permitted - decision_prohibited - differs - Citations].
test(special_category_without_condition_comparison_same) :-
    comparison_answers(special_category_without_condition_prohibited, Answers),
    Answers == [decision_prohibited - decision_prohibited - same - []].
test(without_european_exception_comparison_differs) :-
    comparison_answers(decision_without_european_exception, Answers),
    uk_article_22b_citations(Citations),
    Answers == [decision_permitted - decision_prohibited - differs - Citations].
test(missing_effect_keys_name_the_legal_effect) :-
    significance_answers(partial_profile_missing_effect_keys, Answers),
    Answers == [indeterminate([decision_produces_a_legal_effect_for_the_data_subject]) - []].
test(unsure_involvement_is_referred_with_its_pairs) :-
    significance_answers(unsure_human_involvement_referred, Answers),
    Answers == [needs_legal_review(open_textured(meaningful_human_involvement_in_the_decision, cite(uk_gdpr_art_22a_1_a)), [inputs_relied_on([meaningful_human_involvement_in_the_decision - unsure, decision_produces_a_legal_effect_for_the_data_subject - true, decision_has_a_similarly_significant_effect_for_the_data_subject - false])]) - []].
test(difference_settled_while_both_sides_are_referred) :-
    comparison_answers(unsure_human_involvement_referred, Answers),
    Answers == [needs_legal_review(open_textured(meaningful_human_involvement_in_the_decision, cite(uk_gdpr_art_22a_1_a)), [inputs_relied_on([meaningful_human_involvement_in_the_decision - unsure, decision_produces_a_legal_effect_for_the_data_subject - true, decision_has_a_similarly_significant_effect_for_the_data_subject - false, processing_for_the_decision_relies_on_article_6_1_ea - false, decision_based_entirely_or_partly_on_special_category_data - false, decision_based_entirely_on_processing_with_explicit_consent - false, uk_article_9_2_g_applies - false, decision_necessary_for_a_contract_with_the_data_subject - true, decision_required_or_authorised_by_law - false])]) - needs_legal_review(open_textured(meaningful_human_involvement_in_the_decision, cite(eu_reg_2016_679_art_22_1)), [inputs_relied_on([meaningful_human_involvement_in_the_decision - unsure, decision_produces_a_legal_effect_for_the_data_subject - true, decision_has_a_similarly_significant_effect_for_the_data_subject - false, decision_based_entirely_or_partly_on_special_category_data - false, decision_necessary_for_a_contract_with_the_data_subject - true, decision_authorised_by_union_or_member_state_law_laying_down_suitable_measures - false, decision_based_on_explicit_consent - false, article_9_2_a_applies - false, eu_article_9_2_g_applies - false, suitable_measures_for_special_category_data_in_place - false])]) - same - []].
test(badly_formed_restriction_gives_input_problems) :-
    restriction_answers(badly_formed_profile, Answers),
    Answers == [input_problems([wrong_type(meaningful_human_involvement_in_the_decision), unknown_key(colour)]) - []].
test(badly_formed_comparison_gives_input_problems_everywhere) :-
    comparison_answers(badly_formed_profile, Answers),
    Problems = input_problems([wrong_type(meaningful_human_involvement_in_the_decision), unknown_key(colour)]),
    Answers == [Problems - Problems - Problems - []].
test(duplicated_key_problems_read_out) :-
    uk_automated_decision_making_profile_for(duplicated_key_profile, Profile),
    findall(Problems, uk_automated_decision_making_input_problems(Profile, Problems), AllProblems),
    AllProblems == [[duplicate_key(meaningful_human_involvement_in_the_decision)]].

cp_test_names([ordinary_significance, ordinary_restriction, ordinary_safeguards, ordinary_european, ordinary_comparison, ordinary_facade_verdict, human_involved_restriction_not_engaged, human_involved_european_not_engaged, human_involved_safeguards_not_required, without_personal_data_safeguards_not_required, missing_contesting_safeguard_not_in_place, legitimate_interest_comparison_differs, special_category_explicit_consent_comparison_differs, special_category_without_condition_comparison_same, without_european_exception_comparison_differs, missing_effect_keys_name_the_legal_effect, unsure_involvement_is_referred_with_its_pairs, difference_settled_while_both_sides_are_referred, badly_formed_restriction_gives_input_problems, badly_formed_comparison_gives_input_problems_everywhere, duplicated_key_problems_read_out]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
