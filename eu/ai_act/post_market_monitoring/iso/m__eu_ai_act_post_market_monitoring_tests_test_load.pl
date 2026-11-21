% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_post_market_monitoring_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_post_market_monitoring_kernel, [post_market_monitoring_input_problems/2]).
:- use_module(m__eu_ai_act_post_market_monitoring_citations, [citation/2, implements/1]).

test(the_verdict_term_carries_status_and_citations) :-
    Verdict = post_market_monitoring_verdict(duty_applies, [cite(eu_reg_2024_1689_art_72_1), cite(eu_reg_2024_1689_art_72_3)]),
    Verdict = post_market_monitoring_verdict(Status, Citations),
    Status == duty_applies,
    Citations == [cite(eu_reg_2024_1689_art_72_1), cite(eu_reg_2024_1689_art_72_3)].
test(the_indeterminate_status_holds_one_bare_key) :-
    Result = indeterminate([provider_of_the_system]),
    Result = indeterminate([MissingKey]),
    MissingKey == provider_of_the_system.
test(the_referral_status_destructures) :-
    Result = needs_legal_review(open_textured(integration_achieves_an_equivalent_level_of_protection, cite(eu_reg_2024_1689_art_72_4)), [inputs_relied_on([integration_achieves_an_equivalent_level_of_protection - unsure])]),
    Result = needs_legal_review(open_textured(Judgement, cite(Citation)), [inputs_relied_on(Pairs)]),
    Judgement == integration_achieves_an_equivalent_level_of_protection,
    Citation == eu_reg_2024_1689_art_72_4,
    Pairs == [integration_achieves_an_equivalent_level_of_protection - unsure].
test(the_input_problems_status_destructures) :-
    Result = input_problems([unknown_key(colour), wrong_type(assessment_date)]),
    Result = input_problems(Problems),
    Problems == [unknown_key(colour), wrong_type(assessment_date)].
test(the_assessment_date_term_destructures) :-
    AssessmentDate = date(2027, 12, 2),
    AssessmentDate = date(Year, Month, Day),
    Year == 2027,
    Month == 12,
    Day == 2.
test(the_duty_atoms_are_distinct) :-
    Atoms = [not_applicable_on_date, not_a_provider, not_a_high_risk_ai_system, compliance_required_by_31_december_2030, existing_system_without_significant_changes_not_covered, compliance_required_by_2_august_2030, duty_applies],
    sort(Atoms, Sorted),
    length(Atoms, Count),
    length(Sorted, Count),
    dif(duty_applies, not_applicable_on_date),
    dif(compliance_required_by_31_december_2030, compliance_required_by_2_august_2030).
test(the_integration_atoms_are_distinct) :-
    Atoms = [not_a_provider, not_a_high_risk_ai_system, integration_not_available, integration_available],
    sort(Atoms, Sorted),
    length(Atoms, Count),
    length(Sorted, Count),
    dif(integration_available, integration_not_available).
test(the_primary_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_72_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(every_result_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_72_3, _),
    citation(eu_reg_2024_1689_art_72_4, _),
    citation(eu_reg_2024_1689_art_111_1, _),
    citation(eu_reg_2024_1689_art_111_2, _),
    citation(eu_reg_2024_1689_art_113_c, _),
    citation(eu_reg_2024_1689_art_113_c_i, _),
    citation(eu_reg_2024_1689_art_113_c_ii, _).
test(the_provenance_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2024_1689_art_3_25).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, post_market_monitoring_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    post_market_monitoring_input_problems([attribute(provider_of_the_system, true), attribute(intended_to_be_used_by_public_authorities, unsure)], Problems),
    Problems == [].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    post_market_monitoring_input_problems([attribute(provider_of_the_system, unsure)], Problems),
    Problems == [wrong_type(provider_of_the_system)].
test(a_repeated_key_is_a_duplicate_only) :-
    post_market_monitoring_input_problems([attribute(provider_of_the_system, true), attribute(provider_of_the_system, maybe)], Problems),
    Problems == [duplicate_key(provider_of_the_system)].
test(contract_problems_come_before_unknown_keys) :-
    post_market_monitoring_input_problems([attribute(colour, blue), attribute(provider_of_the_system, maybe), attribute(colour, red)], Problems),
    Problems == [wrong_type(provider_of_the_system), unknown_key(colour)].
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    post_market_monitoring_input_problems([provider_of_the_system - true], Problems),
    Problems == [wrong_type(profile)].

test(the_provenance_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_reg_2024_1689_art_72).
test(a_crisp_key_given_unsure_has_a_problem, fail) :-
    post_market_monitoring_input_problems([attribute(provider_of_the_system, unsure)], []).

cp_test_names([the_verdict_term_carries_status_and_citations, the_indeterminate_status_holds_one_bare_key, the_referral_status_destructures, the_input_problems_status_destructures, the_assessment_date_term_destructures, the_duty_atoms_are_distinct, the_integration_atoms_are_distinct, the_primary_citation_is_recorded, every_result_citation_is_recorded, the_provenance_marker_holds_for_a_recorded_key, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_crisp_key_given_unsure_is_wrong_type, a_repeated_key_is_a_duplicate_only, contract_problems_come_before_unknown_keys, a_term_that_is_not_an_attribute_list_is_wrong_type_profile]).
cp_test_fail_names([the_provenance_marker_fails_for_an_unrecorded_key, a_crisp_key_given_unsure_has_a_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
