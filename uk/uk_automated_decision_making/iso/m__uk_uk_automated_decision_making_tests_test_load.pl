% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_automated_decision_making_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_automated_decision_making_kernel, [uk_automated_decision_making_input_problems/2]).
:- use_module(m__uk_uk_automated_decision_making_citations, [citation/2, implements/1]).

test(an_empty_profile_has_exactly_one_answer_with_no_problem) :-
    findall(Problems, uk_automated_decision_making_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    uk_automated_decision_making_input_problems([attribute(decision_based_entirely_or_partly_on_personal_data, true), attribute(meaningful_human_involvement_in_the_decision, unsure), attribute(decision_produces_a_legal_effect_for_the_data_subject, false), attribute(safeguards_enable_contesting, true)], Problems),
    Problems == [].
test(a_term_that_is_not_a_list_is_a_wrong_type_profile) :-
    findall(Problems, uk_automated_decision_making_input_problems(not_a_profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_a_wrong_type_profile) :-
    findall(Problems, uk_automated_decision_making_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_holding_a_non_attribute_is_a_wrong_type_profile) :-
    uk_automated_decision_making_input_problems([attribute(decision_based_entirely_or_partly_on_personal_data, true), stray_element], Problems),
    Problems == [wrong_type(profile)].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    uk_automated_decision_making_input_problems([attribute(processing_for_the_decision_relies_on_article_6_1_ea, unsure)], Problems),
    Problems == [wrong_type(processing_for_the_decision_relies_on_article_6_1_ea)].
test(a_judgement_key_given_unsure_is_well_typed) :-
    uk_automated_decision_making_input_problems([attribute(uk_article_9_2_g_applies, unsure)], Problems),
    Problems == [].
test(contract_problems_come_before_unknown_keys) :-
    uk_automated_decision_making_input_problems([attribute(unrelated_key, true), attribute(meaningful_human_involvement_in_the_decision, maybe)], Problems),
    Problems == [wrong_type(meaningful_human_involvement_in_the_decision), unknown_key(unrelated_key)].
test(a_repeated_key_is_a_duplicate_and_never_also_wrong_type) :-
    uk_automated_decision_making_input_problems([attribute(decision_based_on_explicit_consent, true), attribute(decision_based_on_explicit_consent, nonsense)], Problems),
    Problems == [duplicate_key(decision_based_on_explicit_consent)].
test(a_repeated_unknown_key_is_named_once) :-
    uk_automated_decision_making_input_problems([attribute(unrelated_key, true), attribute(unrelated_key, false)], Problems),
    Problems == [unknown_key(unrelated_key)].
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, uk_automated_decision_making_input_problems([attribute(safeguards_enable_representations, _)], Problems), Answers),
    Answers == [[wrong_type(safeguards_enable_representations)]].
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = uk_automated_decision_making_verdict(decision_permitted, [cite(uk_gdpr_art_22b_4)]),
    Verdict = uk_automated_decision_making_verdict(Status, Citations),
    Status == decision_permitted,
    Citations == [cite(uk_gdpr_art_22b_4)].
test(the_indeterminate_status_names_one_bare_key) :-
    Status = indeterminate([meaningful_human_involvement_in_the_decision]),
    Status = indeterminate([Key]),
    Key == meaningful_human_involvement_in_the_decision.
test(the_referral_status_carries_reason_and_context) :-
    Status = needs_legal_review(open_textured(uk_article_9_2_g_applies, cite(uk_gdpr_art_22b_3_b)), [inputs_relied_on([uk_article_9_2_g_applies - unsure])]),
    Status = needs_legal_review(open_textured(Input, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Input == uk_article_9_2_g_applies,
    CitationKey == uk_gdpr_art_22b_3_b,
    Pairs == [uk_article_9_2_g_applies - unsure].
test(the_input_problems_status_wraps_the_problem_list) :-
    Status = input_problems([unknown_key(unrelated_key)]),
    Status = input_problems([unknown_key(Key)]),
    Key == unrelated_key.
test(the_significance_atoms_are_distinct) :-
    dif(significant_decision_based_solely_on_automated_processing, not_a_significant_decision_based_solely_on_automated_processing).
test(the_restriction_atoms_are_distinct) :-
    dif(restrictions_not_engaged, decision_permitted),
    dif(restrictions_not_engaged, decision_prohibited),
    dif(decision_permitted, decision_prohibited).
test(the_safeguard_atoms_are_distinct) :-
    dif(safeguards_not_required, required_safeguards_in_place),
    dif(safeguards_not_required, required_safeguards_not_in_place),
    dif(required_safeguards_in_place, required_safeguards_not_in_place).
test(the_difference_atoms_are_distinct) :-
    dif(same, differs).
test(the_article_22b_4_citation_is_recorded) :-
    citation(uk_gdpr_art_22b_4, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_eu_article_22_1_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_22_1, _).
test(the_article_22c_2_d_citation_is_recorded) :-
    citation(uk_gdpr_art_22c_2_d, _).
test(the_marker_holds_for_a_recorded_key) :-
    implements(uk_gdpr_art_22a_1_a).

test(a_well_formed_profile_is_not_reported_as_a_problem, fail) :-
    uk_automated_decision_making_input_problems([attribute(decision_based_entirely_or_partly_on_special_category_data, false)], [_|_]).
test(permitted_is_not_prohibited, fail) :-
    decision_permitted = decision_prohibited.
test(the_marker_fails_for_an_unrecorded_key, fail) :-
    implements(uk_gdpr_art_22z_9).
test(the_placeholder_citation_is_gone, fail) :-
    citation(uk_todo_primary_source, _).

cp_test_names([an_empty_profile_has_exactly_one_answer_with_no_problem, a_well_formed_profile_has_no_problem, a_term_that_is_not_a_list_is_a_wrong_type_profile, an_unbound_profile_is_a_wrong_type_profile, a_list_holding_a_non_attribute_is_a_wrong_type_profile, a_crisp_key_given_unsure_is_wrong_type, a_judgement_key_given_unsure_is_well_typed, contract_problems_come_before_unknown_keys, a_repeated_key_is_a_duplicate_and_never_also_wrong_type, a_repeated_unknown_key_is_named_once, an_unbound_value_is_wrong_type, the_verdict_term_carries_status_and_citations, the_indeterminate_status_names_one_bare_key, the_referral_status_carries_reason_and_context, the_input_problems_status_wraps_the_problem_list, the_significance_atoms_are_distinct, the_restriction_atoms_are_distinct, the_safeguard_atoms_are_distinct, the_difference_atoms_are_distinct, the_article_22b_4_citation_is_recorded, the_eu_article_22_1_citation_is_recorded, the_article_22c_2_d_citation_is_recorded, the_marker_holds_for_a_recorded_key]).
cp_test_fail_names([a_well_formed_profile_is_not_reported_as_a_problem, permitted_is_not_prohibited, the_marker_fails_for_an_unrecorded_key, the_placeholder_citation_is_gone]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
