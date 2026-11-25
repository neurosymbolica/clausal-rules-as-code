% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_policies_and_risk_management_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_dora_rts_policies_and_risk_management, [decide_dora_rts_policies_and_risk_management/2, dora_rts_policies_and_risk_management_status/2, dora_rts_policies_and_risk_management_checklist/2, rts_policies_and_risk_management_duties_required/3, rts_policies_and_risk_management_duties_complete/3, rts_policies_and_risk_management_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_fixtures, [dora_rts_policies_and_risk_management_profile_for/2]).

fixed_citation_list([cite(eu_reg_2024_1774_art_1), cite(eu_reg_2024_1774_art_2_1), cite(eu_reg_2024_1774_art_2_2), cite(eu_reg_2024_1774_art_3)]).

duty_order([risk_profile_and_complexity_consideration, embedding_of_security_policies, network_security, intrusion_and_data_misuse_safeguards, data_availability_authenticity_integrity_and_confidentiality, accurate_and_prompt_data_transmission, alignment_to_information_security_objectives, indication_of_approval_date, implementation_and_exception_indicators, staff_security_responsibilities, consequences_of_non_compliance, documentation_list, segregation_of_duties, leading_practices_and_standards, roles_for_security_policies, review_of_security_policies, material_changes, ict_risk_management_policies_and_procedures, risk_tolerance_approval, risk_assessment_procedure_and_methodology, risk_treatment_procedure, residual_risk_provisions, risk_monitoring_provisions, strategy_change_process, monitoring_of_treatment_effectiveness, assessment_of_risk_tolerance_attainment, assessment_of_corrective_actions]).

required_answers(Subject, Answers) :-
    dora_rts_policies_and_risk_management_profile_for(Subject, Profile),
    findall(Result - Citations, rts_policies_and_risk_management_duties_required(Profile, Result, Citations), Answers).

complete_answers(Subject, Answers) :-
    dora_rts_policies_and_risk_management_profile_for(Subject, Profile),
    findall(Result - Citations, rts_policies_and_risk_management_duties_complete(Profile, Result, Citations), Answers).

outstanding_answers(Subject, Answers) :-
    dora_rts_policies_and_risk_management_profile_for(Subject, Profile),
    findall(Result - Citations, rts_policies_and_risk_management_duties_outstanding(Profile, Result, Citations), Answers).

test(required_lists_all_twenty_seven_duties_in_duty_order) :-
    required_answers(all_duties_performed, Answers),
    duty_order(Duties),
    fixed_citation_list(Citations),
    Answers == [required(Duties) - Citations].
test(required_reads_no_judgement) :-
    required_answers(one_duty_not_performed, Answers),
    duty_order(Duties),
    fixed_citation_list(Citations),
    Answers == [required(Duties) - Citations].
test(required_for_an_article_16_1_entity) :-
    required_answers(simplified_framework_entity_with_duties_performed, Answers),
    Answers == [simplified_framework_entity - [cite(eu_reg_2022_2554_art_16_1)]].
test(required_asks_the_gate) :-
    required_answers(gate_unanswered, Answers),
    Answers == [indeterminate([financial_entity_is_article_16_1_entity]) - []].
test(required_never_refers) :-
    required_answers(duty_judgement_unsure, [required(_) - _]).
test(complete_once_with_the_fixed_citations) :-
    complete_answers(all_duties_performed, Answers),
    fixed_citation_list(Citations),
    Answers == [complete - Citations].
test(incomplete_once_with_the_fixed_citations) :-
    complete_answers(one_duty_not_performed, Answers),
    fixed_citation_list(Citations),
    Answers == [incomplete - Citations].
test(incomplete_for_a_second_paragraph_duty) :-
    complete_answers(second_paragraph_duty_not_performed, Answers),
    fixed_citation_list(Citations),
    Answers == [incomplete - Citations].
test(complete_false_before_absent) :-
    complete_answers(duty_not_performed_and_another_unanswered, Answers),
    fixed_citation_list(Citations),
    Answers == [incomplete - Citations].
test(complete_names_the_absent_duty_key) :-
    complete_answers(duty_unanswered, Answers),
    Answers == [indeterminate([security_policies_contain_safeguards_against_intrusions_and_data_misuse]) - []].
test(complete_refers_the_unsure_duty_with_every_present_pair) :-
    complete_answers(duty_judgement_unsure, Answers),
    Answers = [needs_legal_review(open_textured(security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, cite(eu_reg_2024_1774_art_2_2_c)), [inputs_relied_on(Pairs)]) - []],
    length(Pairs, 28),
    Pairs = [financial_entity_is_article_16_1_entity - false, size_risk_profile_and_complexity_taken_into_account - true|_],
    member(security_policies_contain_indicators_and_measures_for_implementation_and_exceptions - unsure, Pairs).
test(complete_input_problems) :-
    complete_answers(unknown_key_present, Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(none_outstanding_once_with_the_fixed_citations) :-
    outstanding_answers(all_duties_performed, Answers),
    fixed_citation_list(Citations),
    Answers == [none_outstanding - Citations].
test(outstanding_cites_the_failing_duty) :-
    outstanding_answers(one_duty_not_performed, Answers),
    Answers == [outstanding([network_security]) - [cite(eu_reg_2024_1774_art_2_1_a)]].
test(outstanding_cites_the_second_run_key) :-
    outstanding_answers(second_paragraph_duty_not_performed, Answers),
    Answers == [outstanding([monitoring_of_treatment_effectiveness]) - [cite(eu_reg_2024_1774_art_3_a_run2)]].
test(outstanding_asks_the_absent_key_despite_a_failing_duty) :-
    outstanding_answers(duty_not_performed_and_another_unanswered, Answers),
    Answers == [indeterminate([size_risk_profile_and_complexity_taken_into_account]) - []].
test(outstanding_for_an_article_16_1_entity) :-
    outstanding_answers(simplified_framework_entity_with_duties_performed, Answers),
    Answers == [simplified_framework_entity - [cite(eu_reg_2022_2554_art_16_1)]].
test(the_baseline_profile_yields_exactly_one_status) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    findall(Status, dora_rts_policies_and_risk_management_status(Profile, Status), Statuses),
    Statuses == [complete].
test(the_verdict_carries_a_citation) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    decide_dora_rts_policies_and_risk_management(Profile, dora_rts_policies_and_risk_management_verdict(complete, [_FirstCitation|_OtherCitations])).
test(the_checklist_has_one_cited_row_per_duty_in_order) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    findall(Items, dora_rts_policies_and_risk_management_checklist(Profile, Items), [Items]),
    length(Items, 27),
    Items = [item(risk_profile_and_complexity_consideration, met, cite(eu_reg_2024_1774_art_1))|_],
    last(Items, item(assessment_of_corrective_actions, met, cite(eu_reg_2024_1774_art_3_c_run2))).
test(the_checklist_marks_an_unsure_duty_unknown) :-
    dora_rts_policies_and_risk_management_profile_for(duty_judgement_unsure, Profile),
    dora_rts_policies_and_risk_management_checklist(Profile, Items),
    member(item(implementation_and_exception_indicators, unknown([security_policies_contain_indicators_and_measures_for_implementation_and_exceptions]), cite(eu_reg_2024_1774_art_2_2_c)), Items).
test(the_checklist_of_an_article_16_1_entity_is_the_gate_row) :-
    dora_rts_policies_and_risk_management_profile_for(simplified_framework_entity_with_duties_performed, Profile),
    findall(Items, dora_rts_policies_and_risk_management_checklist(Profile, Items), Answers),
    Answers == [[item(simplified_framework_entity, met, cite(eu_reg_2022_2554_art_16_1))]].
test(the_checklist_of_a_bad_profile_is_empty) :-
    dora_rts_policies_and_risk_management_profile_for(unknown_key_present, Profile),
    findall(Items, dora_rts_policies_and_risk_management_checklist(Profile, Items), Answers),
    Answers == [[]].

cp_test_names([required_lists_all_twenty_seven_duties_in_duty_order, required_reads_no_judgement, required_for_an_article_16_1_entity, required_asks_the_gate, required_never_refers, complete_once_with_the_fixed_citations, incomplete_once_with_the_fixed_citations, incomplete_for_a_second_paragraph_duty, complete_false_before_absent, complete_names_the_absent_duty_key, complete_refers_the_unsure_duty_with_every_present_pair, complete_input_problems, none_outstanding_once_with_the_fixed_citations, outstanding_cites_the_failing_duty, outstanding_cites_the_second_run_key, outstanding_asks_the_absent_key_despite_a_failing_duty, outstanding_for_an_article_16_1_entity, the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, the_checklist_has_one_cited_row_per_duty_in_order, the_checklist_marks_an_unsure_duty_unknown, the_checklist_of_an_article_16_1_entity_is_the_gate_row, the_checklist_of_a_bad_profile_is_empty]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
