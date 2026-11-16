% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_deployer_duties_fria_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_deployer_duties_fria_kernel, [deployer_duties_fria_input_problems/2]).
:- use_module(m__eu_ai_act_deployer_duties_fria_citations, [citation/2, implements/1, citation_vocabulary/1]).

test(the_verdict_term_carries_result_and_citations) :-
    Verdict = deployer_duties_fria_verdict(obligation_applies, [cite(eu_reg_2024_1689_art_26_6)]),
    Verdict = deployer_duties_fria_verdict(Result, Citations),
    Result == obligation_applies,
    Citations == [cite(eu_reg_2024_1689_art_26_6)].
test(a_not_final_verdict_carries_no_citations) :-
    Verdict = deployer_duties_fria_verdict(indeterminate([deployer_of_the_system]), []),
    Verdict = deployer_duties_fria_verdict(indeterminate([MissingKey]), Citations),
    MissingKey == deployer_of_the_system,
    Citations == [].
test(the_referral_term_destructures) :-
    Status = needs_legal_review(open_textured(body_governed_by_public_law, cite(eu_reg_2024_1689_art_27_1)), [inputs_relied_on([body_governed_by_public_law - unsure])]),
    Status = needs_legal_review(open_textured(Judgement, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Judgement == body_governed_by_public_law,
    CitationKey == eu_reg_2024_1689_art_27_1,
    Pairs == [body_governed_by_public_law - unsure].
test(the_assessment_date_is_a_date_term) :-
    AssessmentDate = date(2027, 12, 2),
    AssessmentDate = date(Year, Month, Day),
    Year == 2027,
    Month == 12,
    Day == 2.
test(the_obligation_status_atoms_are_distinct) :-
    Atoms = [not_applicable_on_date, not_a_deployer, not_a_high_risk_ai_system, obligation_does_not_apply, information_under_article_13_of_directive_2016_680, compliance_required_by_31_december_2030, existing_system_without_significant_changes_not_covered, compliance_required_by_2_august_2030, obligation_applies],
    sort(Atoms, Sorted),
    length(Atoms, Count),
    length(Sorted, Count).
test(the_retention_status_atoms_are_distinct) :-
    Atoms = [not_applicable_on_date, not_a_deployer, not_a_high_risk_ai_system, obligation_does_not_apply, compliance_required_by_31_december_2030, existing_system_without_significant_changes_not_covered, compliance_required_by_2_august_2030, period_set_by_other_union_or_national_law, retention_period_of_at_least_six_months, retention_period_shorter_than_six_months],
    sort(Atoms, Sorted),
    length(Atoms, Count),
    length(Sorted, Count).
test(applies_and_does_not_apply_differ) :-
    dif(obligation_applies, obligation_does_not_apply).
test(the_two_retention_answers_differ) :-
    dif(retention_period_of_at_least_six_months, retention_period_shorter_than_six_months).
test(the_log_retention_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_26_6, Record),
    Record = [label - _, ref - Reference, verbatim - _],
    Reference == '02024R1689-20260727#parag_026.006'.
test(the_deployer_definition_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_3_4, _).
test(the_vocabulary_has_twelve_returnable_keys) :-
    findall(Key, citation_vocabulary(Key), Keys),
    length(Keys, 12),
    maplist(implements, Keys).
test(the_empty_profile_has_no_problem) :-
    findall(Problems, deployer_duties_fria_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(deployer_of_the_system, true), attribute(system_is_a_high_risk_ai_system_listed_in_annex_iii, false), attribute(body_governed_by_public_law, unsure)],
    findall(Problems, deployer_duties_fria_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    findall(Problems, deployer_duties_fria_input_problems([attribute(deployer_of_the_system, unsure)], Problems), Answers),
    Answers == [[wrong_type(deployer_of_the_system)]].
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, deployer_duties_fria_input_problems([attribute(deployer_is_an_employer, _)], Problems), Answers),
    Answers == [[wrong_type(deployer_is_an_employer)]].
test(a_duplicate_key_is_named_once_and_not_wrong_type) :-
    Profile = [attribute(deployer_of_the_system, true), attribute(deployer_of_the_system, maybe)],
    findall(Problems, deployer_duties_fria_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(deployer_of_the_system)]].
test(contract_problems_come_before_unknown_keys) :-
    Profile = [attribute(colour, red), attribute(deployer_of_the_system, yes), attribute(colour, blue)],
    findall(Problems, deployer_duties_fria_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(deployer_of_the_system), unknown_key(colour)]].
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    findall(Problems, deployer_duties_fria_input_problems(not_a_list, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, deployer_duties_fria_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_stray_element_is_wrong_type_profile) :-
    findall(Problems, deployer_duties_fria_input_problems([attribute(deployer_of_the_system, true), stray], Problems), Answers),
    Answers == [[wrong_type(profile)]].

test(a_misspelt_marker_fails, fail) :-
    implements(eu_reg_2024_1689_article_26_6).
test(a_well_formed_profile_has_a_problem_list_that_is_empty, fail) :-
    deployer_duties_fria_input_problems([attribute(deployer_of_the_system, true)], [_|_]).

cp_test_names([the_verdict_term_carries_result_and_citations, a_not_final_verdict_carries_no_citations, the_referral_term_destructures, the_assessment_date_is_a_date_term, the_obligation_status_atoms_are_distinct, the_retention_status_atoms_are_distinct, applies_and_does_not_apply_differ, the_two_retention_answers_differ, the_log_retention_citation_is_recorded, the_deployer_definition_citation_is_recorded, the_vocabulary_has_twelve_returnable_keys, the_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_crisp_key_given_unsure_is_wrong_type, an_unbound_value_is_wrong_type, a_duplicate_key_is_named_once_and_not_wrong_type, contract_problems_come_before_unknown_keys, a_term_that_is_not_a_list_is_wrong_type_profile, an_unbound_profile_is_wrong_type_profile, a_list_with_a_stray_element_is_wrong_type_profile]).
cp_test_fail_names([a_misspelt_marker_fails, a_well_formed_profile_has_a_problem_list_that_is_empty]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
