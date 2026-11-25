% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_conformity_marking_registration_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_conformity_marking_registration_kernel, [conformity_marking_registration_input_problems/2, real_calendar_day_t/2]).
:- use_module(m__eu_ai_act_conformity_marking_registration_citations, [citation/2, implements/1]).

test(the_input_check_accepts_an_empty_profile) :-
    conformity_marking_registration_input_problems([], []).
test(the_input_check_accepts_a_well_typed_profile) :-
    conformity_marking_registration_input_problems([attribute(annex_iii_point, annex_iii_point_1), attribute(provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, false), attribute(intended_to_be_used_by_public_authorities, unsure)], []).
test(the_input_check_names_a_wrong_type) :-
    conformity_marking_registration_input_problems([attribute(covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, unsure)], [wrong_type(covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i)]).
test(the_input_check_names_an_unknown_key) :-
    conformity_marking_registration_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(the_input_check_names_a_duplicate_key_only) :-
    conformity_marking_registration_input_problems([attribute(substantial_modification, true), attribute(substantial_modification, sometimes)], [duplicate_key(substantial_modification)]).
test(the_input_check_refuses_a_term_that_is_not_an_attribute_list) :-
    conformity_marking_registration_input_problems([colour], [wrong_type(profile)]).
test(the_input_check_has_exactly_one_answer) :-
    findall(Problems, conformity_marking_registration_input_problems([attribute(annex_iii_point, annex_iii_point_9)], Problems), Answers),
    Answers == [[wrong_type(annex_iii_point)]].
test(the_first_application_day_is_a_real_day) :-
    real_calendar_day_t(date(2027, 12, 2), true).
test(a_leap_day_of_2028_is_a_real_day) :-
    real_calendar_day_t(date(2028, 2, 29), true).
test(a_leap_day_of_2038_is_not_a_real_day) :-
    real_calendar_day_t(date(2038, 2, 29), false).
test(the_calendar_check_has_exactly_one_answer) :-
    findall(Truth, real_calendar_day_t(date(2030, 8, 2), Truth), Answers),
    Answers == [true].
test(the_indeterminate_term_carries_one_key) :-
    Result = indeterminate([annex_iii_point]),
    Result = indeterminate([MissingKey]),
    MissingKey == annex_iii_point.
test(the_referral_term_carries_its_reason_and_pairs) :-
    Result = needs_legal_review(open_textured(substantial_modification, cite(eu_reg_2024_1689_art_3_23)), [inputs_relied_on([substantial_modification - unsure])]),
    Result = needs_legal_review(open_textured(Input, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Input == substantial_modification,
    CitationKey == eu_reg_2024_1689_art_3_23,
    Pairs == [substantial_modification - unsure].
test(the_input_problems_term_carries_its_list) :-
    Result = input_problems([wrong_type(assessment_date)]),
    Result = input_problems(Problems),
    Problems == [wrong_type(assessment_date)].
test(the_checklist_row_carries_query_result_and_citations) :-
    Row = item(conformity_assessment_procedure, internal_control_under_annex_vi, [cite(eu_reg_2024_1689_art_43_2), cite(eu_reg_2024_1689_annex_vi)]),
    Row = item(QueryIdentifier, Result, Citations),
    QueryIdentifier == conformity_assessment_procedure,
    Result == internal_control_under_annex_vi,
    Citations == [cite(eu_reg_2024_1689_art_43_2), cite(eu_reg_2024_1689_annex_vi)].
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = conformity_marking_registration_verdict(not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_c_i)]),
    Verdict = conformity_marking_registration_verdict(Status, Citations),
    Status == not_applicable_on_date,
    Citations == [cite(eu_reg_2024_1689_art_113_c_i)].
test(the_procedure_atoms_are_distinct) :-
    dif(internal_control_under_annex_vi, notified_body_procedure_under_annex_vii),
    dif(choice_of_internal_control_under_annex_vi_or_notified_body_procedure_under_annex_vii, choice_of_annex_vi_or_annex_vii_with_annex_vii_for_the_restricted_part),
    dif(procedure_of_the_union_harmonisation_legislation_with_the_option_without_a_third_party, procedure_of_the_union_harmonisation_legislation_with_third_party_assessment).
test(the_transition_atoms_are_distinct) :-
    dif(compliance_required_by_31_december_2030, compliance_required_by_2_august_2030),
    dif(not_applicable_on_date, not_applicable_to_a_system_placed_before_the_application_day).
test(the_registration_atoms_are_distinct) :-
    dif(registration_in_the_eu_database, registration_in_the_secure_non_public_section_of_the_eu_database),
    dif(registration_in_the_eu_database, registration_at_national_level),
    dif(no_registration_duty, registration_at_national_level).
test(the_keeping_atoms_are_distinct) :-
    dif(declaration_to_be_kept, keeping_period_ended).
test(the_annex_vi_procedure_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_43_2, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_first_application_day_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_113_c_i, _).
test(the_keeping_period_citation_is_implemented) :-
    implements(eu_reg_2024_1689_art_47_1).

test(a_well_typed_profile_has_no_problem_list_that_is_not_empty, fail) :-
    conformity_marking_registration_input_problems([attribute(provided_digitally, true)], [_|_]).
test(two_equal_atoms_are_not_distinct, fail) :-
    dif(marking_element_required, marking_element_required).
test(a_shortened_citation_key_is_not_recorded, fail) :-
    citation(art_43_2, _).

cp_test_names([the_input_check_accepts_an_empty_profile, the_input_check_accepts_a_well_typed_profile, the_input_check_names_a_wrong_type, the_input_check_names_an_unknown_key, the_input_check_names_a_duplicate_key_only, the_input_check_refuses_a_term_that_is_not_an_attribute_list, the_input_check_has_exactly_one_answer, the_first_application_day_is_a_real_day, a_leap_day_of_2028_is_a_real_day, a_leap_day_of_2038_is_not_a_real_day, the_calendar_check_has_exactly_one_answer, the_indeterminate_term_carries_one_key, the_referral_term_carries_its_reason_and_pairs, the_input_problems_term_carries_its_list, the_checklist_row_carries_query_result_and_citations, the_verdict_term_carries_status_and_citations, the_procedure_atoms_are_distinct, the_transition_atoms_are_distinct, the_registration_atoms_are_distinct, the_keeping_atoms_are_distinct, the_annex_vi_procedure_citation_is_recorded, the_first_application_day_citation_is_recorded, the_keeping_period_citation_is_implemented]).
cp_test_fail_names([a_well_typed_profile_has_no_problem_list_that_is_not_empty, two_equal_atoms_are_not_distinct, a_shortened_citation_key_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
