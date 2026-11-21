% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_high_risk_requirements_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_high_risk_requirements_high_risk_requirements, [high_risk_requirement_status/5, documentation_element_status/4, high_risk_requirements_status_values/1]).
:- use_module(m__eu_ai_act_high_risk_requirements_fixtures, [high_risk_requirements_subject/1, high_risk_requirements_profile_for/2, high_risk_requirements_assess/2]).

requirements([risk_management_system, data_and_data_governance, technical_documentation, record_keeping, minimum_logging_capabilities_for_point_1_a_systems, transparency_and_instructions_for_use, human_oversight, separate_verification_by_at_least_two_natural_persons, accuracy_robustness_and_cybersecurity]).

elements([annex_iv_point_1_a, annex_iv_point_1_b, annex_iv_point_1_c, annex_iv_point_1_d, annex_iv_point_1_e, annex_iv_point_1_f, annex_iv_point_1_g, annex_iv_point_1_h, annex_iv_point_2_a, annex_iv_point_2_b, annex_iv_point_2_c, annex_iv_point_2_d, annex_iv_point_2_e, annex_iv_point_2_f, annex_iv_point_2_g, annex_iv_point_2_h, annex_iv_point_3, annex_iv_point_4, annex_iv_point_5, annex_iv_point_6, annex_iv_point_7, annex_iv_point_8, annex_iv_point_9, article_11_2_information_under_annex_i_section_a_legislation, article_13_3_point_a, article_13_3_point_b_i, article_13_3_point_b_ii, article_13_3_point_b_iii, article_13_3_point_b_iv, article_13_3_point_b_v, article_13_3_point_b_vi, article_13_3_point_b_vii, article_13_3_point_c, article_13_3_point_d, article_13_3_point_e, article_13_3_point_f, article_15_3_levels_of_accuracy_and_accuracy_metrics]).

unconditional_elements([annex_iv_point_1_a, annex_iv_point_1_c, annex_iv_point_1_h, annex_iv_point_2_b, annex_iv_point_5, annex_iv_point_9, article_13_3_point_a, article_13_3_point_d, article_15_3_levels_of_accuracy_and_accuracy_metrics]).

boundary_days([date(2027, 12, 1), date(2027, 12, 2), date(2028, 8, 1), date(2028, 8, 2), date(2030, 8, 1), date(2030, 8, 2), date(2030, 12, 30), date(2030, 12, 31)]).

citation_vocabulary([eu_reg_2024_1689_art_8_1, eu_reg_2024_1689_art_9_1, eu_reg_2024_1689_art_10_1, eu_reg_2024_1689_art_11_1, eu_reg_2024_1689_art_12_1, eu_reg_2024_1689_art_12_3, eu_reg_2024_1689_art_13_1, eu_reg_2024_1689_art_13_2, eu_reg_2024_1689_art_14_1, eu_reg_2024_1689_art_14_5, eu_reg_2024_1689_art_15_1, eu_reg_2024_1689_art_113_c, eu_reg_2024_1689_art_113_c_i, eu_reg_2024_1689_art_113_c_ii, eu_reg_2024_1689_art_111_1, eu_reg_2024_1689_art_111_2, eu_reg_2024_1689_art_10_6, eu_reg_2024_1689_annex_iv_1_a, eu_reg_2024_1689_annex_iv_1_b, eu_reg_2024_1689_annex_iv_1_c, eu_reg_2024_1689_annex_iv_1_d, eu_reg_2024_1689_annex_iv_1_e, eu_reg_2024_1689_annex_iv_1_f, eu_reg_2024_1689_annex_iv_1_g, eu_reg_2024_1689_annex_iv_1_h, eu_reg_2024_1689_annex_iv_2_a, eu_reg_2024_1689_annex_iv_2_b, eu_reg_2024_1689_annex_iv_2_c, eu_reg_2024_1689_annex_iv_2_d, eu_reg_2024_1689_annex_iv_2_e, eu_reg_2024_1689_annex_iv_2_f, eu_reg_2024_1689_annex_iv_2_g, eu_reg_2024_1689_annex_iv_2_h, eu_reg_2024_1689_annex_iv_3, eu_reg_2024_1689_annex_iv_4, eu_reg_2024_1689_annex_iv_5, eu_reg_2024_1689_annex_iv_6, eu_reg_2024_1689_annex_iv_7, eu_reg_2024_1689_annex_iv_8, eu_reg_2024_1689_annex_iv_9, eu_reg_2024_1689_art_11_2, eu_reg_2024_1689_art_13_3, eu_reg_2024_1689_art_13_3_a, eu_reg_2024_1689_art_13_3_b_i, eu_reg_2024_1689_art_13_3_b_ii, eu_reg_2024_1689_art_13_3_b_iii, eu_reg_2024_1689_art_13_3_b_iv, eu_reg_2024_1689_art_13_3_b_v, eu_reg_2024_1689_art_13_3_b_vi, eu_reg_2024_1689_art_13_3_b_vii, eu_reg_2024_1689_art_13_3_c, eu_reg_2024_1689_art_13_3_d, eu_reg_2024_1689_art_13_3_e, eu_reg_2024_1689_art_13_3_f, eu_reg_2024_1689_art_15_3]).

all_subjects(Subjects) :-
    findall(Subject, high_risk_requirements_subject(Subject), Found),
    sort(Found, Subjects).

well_formed_subjects(Subjects) :-
    findall(Subject, (high_risk_requirements_subject(Subject), dif(Subject, malformed_classification_value)), Found),
    sort(Found, Subjects).

one_verdict(Subject) :-
    findall(Verdict, high_risk_requirements_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

grid(Grid) :-
    requirements(Requirements),
    boundary_days(Days),
    findall(Requirement - Day, (member(Requirement, Requirements), member(Day, Days)), Grid).

one_status(Profile, Requirement - Day) :-
    findall(Result - Citations, high_risk_requirement_status(Profile, Requirement, Day, Result, Citations), Answers),
    length(Answers, 1).

one_element_answer(Profile, Element) :-
    findall(Result - Citations, documentation_element_status(Profile, Element, Result, Citations), Answers),
    length(Answers, 1).

answer_shape(Result, Citations) :-
    atom(Result),
    high_risk_requirements_status_values(Values),
    member(Result, Values),
    citations_in_vocabulary(Citations),
    Citations = [_|_].
answer_shape(indeterminate([Key]), []) :-
    atom(Key).
answer_shape(needs_legal_review(open_textured(Judgement, cite(Key)), [inputs_relied_on(_)]), []) :-
    atom(Judgement),
    atom(Key).
answer_shape(input_problems([_|_]), []).

citations_in_vocabulary(Citations) :-
    citation_vocabulary(Keys),
    maplist(citation_in_vocabulary(Keys), Citations).

citation_in_vocabulary(Keys, cite(Key)) :-
    member(Key, Keys).

grid_answer_shaped(Profile, Requirement - Day) :-
    high_risk_requirement_status(Profile, Requirement, Day, Result, Citations),
    answer_shape(Result, Citations).

subject_answer_shaped(Subject) :-
    high_risk_requirements_assess(Subject, high_risk_requirements_verdict(Result, Citations)),
    answer_shape(Result, Citations).

not_yet_applicable(Day, Subject) :-
    high_risk_requirements_profile_for(Subject, Profile),
    requirements(Requirements),
    maplist(not_yet_applicable_requirement(Profile, Day), Requirements).

not_yet_applicable_requirement(Profile, Day, Requirement) :-
    high_risk_requirement_status(Profile, Requirement, Day, not_applicable_on_date, _).

applies_citing_article_8(Profile, Day, Requirement) :-
    high_risk_requirement_status(Profile, Requirement, Day, _, Citations),
    member(cite(eu_reg_2024_1689_art_8_1), Citations).

same_element_answer(ProfileOne, ProfileTwo, Element) :-
    documentation_element_status(ProfileOne, Element, Result, CitationsOne),
    documentation_element_status(ProfileTwo, Element, Result, CitationsTwo),
    sort(CitationsOne, Sorted),
    sort(CitationsTwo, Sorted).

test(totality_every_subject_classifies) :-
    all_subjects(Subjects),
    findall(Subject, (member(Subject, Subjects), high_risk_requirements_assess(Subject, _)), Classified),
    sort(Classified, ClassifiedSet),
    ClassifiedSet == Subjects.
test(determinism_every_subject_has_one_verdict) :-
    all_subjects(Subjects),
    maplist(one_verdict, Subjects).
test(determinism_over_the_requirement_and_day_grid) :-
    high_risk_requirements_profile_for(annex_iii_on_application_date, Profile),
    grid(Grid),
    maplist(one_status(Profile), Grid).
test(determinism_over_the_grid_for_an_annex_x_component) :-
    high_risk_requirements_profile_for(annex_x_component_on_deadline, Profile),
    grid(Grid),
    maplist(one_status(Profile), Grid).
test(determinism_over_every_element_with_a_full_profile) :-
    high_risk_requirements_profile_for(annex_iii_on_application_date, Profile),
    elements(Elements),
    maplist(one_element_answer(Profile), Elements).
test(determinism_over_every_element_with_an_empty_profile) :-
    elements(Elements),
    maplist(one_element_answer([]), Elements).
test(every_subject_answer_has_a_closed_shape) :-
    all_subjects(Subjects),
    maplist(subject_answer_shaped, Subjects).
test(every_grid_answer_has_a_closed_shape) :-
    high_risk_requirements_profile_for(public_authority_system_on_deadline, Profile),
    grid(Grid),
    maplist(grid_answer_shaped(Profile), Grid).
test(before_2_december_2027_nothing_applies_whatever_the_system) :-
    well_formed_subjects(Subjects),
    maplist(not_yet_applicable(date(2027, 12, 1)), Subjects).
test(every_requirement_that_applies_cites_article_8_1) :-
    high_risk_requirements_profile_for(point_one_a_system_logging, Profile),
    requirements(Requirements),
    maplist(applies_citing_article_8(Profile, date(2028, 1, 1)), Requirements).
test(an_unconditional_element_ignores_the_profile) :-
    high_risk_requirements_profile_for(component_photographs_not_a_component, Profile),
    unconditional_elements(Elements),
    maplist(same_element_answer([], Profile), Elements).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_one_verdict, determinism_over_the_requirement_and_day_grid, determinism_over_the_grid_for_an_annex_x_component, determinism_over_every_element_with_a_full_profile, determinism_over_every_element_with_an_empty_profile, every_subject_answer_has_a_closed_shape, every_grid_answer_has_a_closed_shape, before_2_december_2027_nothing_applies_whatever_the_system, every_requirement_that_applies_cites_article_8_1, an_unconditional_element_ignores_the_profile]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
