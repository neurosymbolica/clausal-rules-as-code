% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_policies_and_risk_management_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_dora_rts_policies_and_risk_management, [decide_dora_rts_policies_and_risk_management/2, dora_rts_policies_and_risk_management_status/2, dora_rts_policies_and_risk_management_checklist/2, dora_rts_policies_and_risk_management_decision_resolvable/1, dora_rts_policies_and_risk_management_status_values/1, rts_policies_and_risk_management_duties_required/3, rts_policies_and_risk_management_duties_complete/3, rts_policies_and_risk_management_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_fixtures, [dora_rts_policies_and_risk_management_subject/1, dora_rts_policies_and_risk_management_profile_for/2, dora_rts_policies_and_risk_management_assess/2]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_kernel, [dora_rts_policies_and_risk_management_input_problems/2]).

fixed_citations([cite(eu_reg_2024_1774_art_1), cite(eu_reg_2024_1774_art_2_1), cite(eu_reg_2024_1774_art_2_2), cite(eu_reg_2024_1774_art_3)]).

required_answers(Subject, Answers) :-
    dora_rts_policies_and_risk_management_profile_for(Subject, Profile),
    findall(Result - Citations, rts_policies_and_risk_management_duties_required(Profile, Result, Citations), Answers).

complete_answers(Subject, Answers) :-
    dora_rts_policies_and_risk_management_profile_for(Subject, Profile),
    findall(Result - Citations, rts_policies_and_risk_management_duties_complete(Profile, Result, Citations), Answers).

outstanding_answers(Subject, Answers) :-
    dora_rts_policies_and_risk_management_profile_for(Subject, Profile),
    findall(Result - Citations, rts_policies_and_risk_management_duties_outstanding(Profile, Result, Citations), Answers).

answers_once(Subject) :-
    required_answers(Subject, RequiredAnswers),
    length(RequiredAnswers, 1),
    complete_answers(Subject, CompleteAnswers),
    length(CompleteAnswers, 1),
    outstanding_answers(Subject, OutstandingAnswers),
    length(OutstandingAnswers, 1),
    dora_rts_policies_and_risk_management_profile_for(Subject, Profile),
    findall(Problems, dora_rts_policies_and_risk_management_input_problems(Profile, Problems), ProblemAnswers),
    length(ProblemAnswers, 1),
    findall(Verdict, dora_rts_policies_and_risk_management_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

cited(cite(_)).

referral_context_shape([inputs_relied_on(_)]).
referral_context_shape([inputs_relied_on(_), provenance(_, _)]).

test(nine_subjects_are_registered) :-
    findall(Subject, dora_rts_policies_and_risk_management_subject(Subject), Subjects),
    length(Subjects, 9).
test(every_query_answers_once_for_every_subject) :-
    findall(Subject, dora_rts_policies_and_risk_management_subject(Subject), Subjects),
    maplist(answers_once, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, dora_rts_policies_and_risk_management_subject(Subject), Subjects),
    maplist(subject_resolvable, Subjects).
test(all_duties_performed_is_complete) :-
    complete_answers(all_duties_performed, Answers),
    fixed_citations(Citations),
    Answers == [complete - Citations].
test(all_duties_performed_verdict_is_complete) :-
    dora_rts_policies_and_risk_management_assess(all_duties_performed, dora_rts_policies_and_risk_management_verdict(complete, Citations)),
    fixed_citations(Citations).
test(all_duties_performed_is_a_final_status) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    dora_rts_policies_and_risk_management_status(Profile, Status),
    dora_rts_policies_and_risk_management_status_values(StatusValues),
    member(Status, StatusValues),
    Status == complete.
test(all_duties_performed_none_outstanding) :-
    outstanding_answers(all_duties_performed, Answers),
    fixed_citations(Citations),
    Answers == [none_outstanding - Citations].
test(all_duties_performed_requires_every_duty_in_order) :-
    required_answers(all_duties_performed, Answers),
    Answers = [required(Duties) - Citations],
    fixed_citations(Citations),
    length(Duties, 27),
    Duties = [risk_profile_and_complexity_consideration, embedding_of_security_policies, network_security|_],
    last(Duties, assessment_of_corrective_actions),
    nth1(24, Duties, strategy_change_process),
    nth1(25, Duties, monitoring_of_treatment_effectiveness).
test(all_duties_performed_has_no_input_problem) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    dora_rts_policies_and_risk_management_input_problems(Profile, []).
test(one_duty_not_performed_is_incomplete) :-
    complete_answers(one_duty_not_performed, Answers),
    fixed_citations(Citations),
    Answers == [incomplete - Citations].
test(one_duty_not_performed_is_outstanding_with_its_own_citation) :-
    outstanding_answers(one_duty_not_performed, Answers),
    Answers == [outstanding([network_security]) - [cite(eu_reg_2024_1774_art_2_1_a)]].
test(an_article_16_1_entity_is_simplified_framework_entity) :-
    complete_answers(simplified_framework_entity_with_duties_performed, CompleteAnswers),
    CompleteAnswers == [simplified_framework_entity - [cite(eu_reg_2022_2554_art_16_1)]],
    required_answers(simplified_framework_entity_with_duties_performed, RequiredAnswers),
    RequiredAnswers == [simplified_framework_entity - [cite(eu_reg_2022_2554_art_16_1)]],
    outstanding_answers(simplified_framework_entity_with_duties_performed, OutstandingAnswers),
    OutstandingAnswers == [simplified_framework_entity - [cite(eu_reg_2022_2554_art_16_1)]].
test(the_unanswered_gate_is_asked_first) :-
    complete_answers(gate_unanswered, CompleteAnswers),
    CompleteAnswers == [indeterminate([financial_entity_is_article_16_1_entity]) - []],
    required_answers(gate_unanswered, RequiredAnswers),
    RequiredAnswers == [indeterminate([financial_entity_is_article_16_1_entity]) - []],
    outstanding_answers(gate_unanswered, OutstandingAnswers),
    OutstandingAnswers == [indeterminate([financial_entity_is_article_16_1_entity]) - []].
test(the_unanswered_gate_status_is_indeterminate) :-
    dora_rts_policies_and_risk_management_profile_for(gate_unanswered, Profile),
    dora_rts_policies_and_risk_management_status(Profile, indeterminate([financial_entity_is_article_16_1_entity])).
test(an_unanswered_duty_is_named) :-
    complete_answers(duty_unanswered, Answers),
    Answers == [indeterminate([security_policies_contain_safeguards_against_intrusions_and_data_misuse]) - []],
    outstanding_answers(duty_unanswered, OutstandingAnswers),
    OutstandingAnswers == [indeterminate([security_policies_contain_safeguards_against_intrusions_and_data_misuse]) - []].
test(an_unanswered_duty_still_lists_every_required_duty) :-
    required_answers(duty_unanswered, [required(Duties) - _]),
    length(Duties, 27).
test(an_unsure_judgement_goes_to_a_lawyer) :-
    complete_answers(duty_judgement_unsure, Answers),
    Answers = [needs_legal_review(open_textured(security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, cite(eu_reg_2024_1774_art_2_2_c)), [inputs_relied_on(Pairs)]) - []],
    length(Pairs, 28),
    Pairs = [financial_entity_is_article_16_1_entity - false|_],
    member(security_policies_contain_indicators_and_measures_for_implementation_and_exceptions - unsure, Pairs).
test(an_unsure_judgement_goes_to_a_lawyer_in_outstanding) :-
    outstanding_answers(duty_judgement_unsure, Answers),
    Answers = [needs_legal_review(open_textured(security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, cite(eu_reg_2024_1774_art_2_2_c)), [inputs_relied_on(Pairs)]) - []],
    length(Pairs, 28).
test(the_referral_context_has_the_contract_shape) :-
    complete_answers(duty_judgement_unsure, [needs_legal_review(_, CompleteContext) - []]),
    referral_context_shape(CompleteContext),
    outstanding_answers(duty_judgement_unsure, [needs_legal_review(_, OutstandingContext) - []]),
    referral_context_shape(OutstandingContext).
test(a_context_with_one_provenance_item_has_the_contract_shape) :-
    complete_answers(duty_judgement_unsure, [needs_legal_review(_, [inputs_relied_on(Pairs)|_]) - []]),
    referral_context_shape([inputs_relied_on(Pairs), provenance(complete_answer, [cite(eu_reg_2024_1774_art_2_2_c)])]).
test(a_second_paragraph_duty_not_performed_is_incomplete) :-
    complete_answers(second_paragraph_duty_not_performed, Answers),
    fixed_citations(Citations),
    Answers == [incomplete - Citations].
test(a_second_paragraph_duty_is_outstanding_with_its_run2_citation) :-
    outstanding_answers(second_paragraph_duty_not_performed, Answers),
    Answers == [outstanding([monitoring_of_treatment_effectiveness]) - [cite(eu_reg_2024_1774_art_3_a_run2)]].
test(a_failing_duty_decides_complete_before_the_unanswered_key) :-
    complete_answers(duty_not_performed_and_another_unanswered, Answers),
    fixed_citations(Citations),
    Answers == [incomplete - Citations].
test(outstanding_asks_the_unanswered_key_despite_the_failing_duty) :-
    outstanding_answers(duty_not_performed_and_another_unanswered, Answers),
    Answers == [indeterminate([size_risk_profile_and_complexity_taken_into_account]) - []].
test(an_unknown_key_is_an_input_problem) :-
    dora_rts_policies_and_risk_management_profile_for(unknown_key_present, Profile),
    dora_rts_policies_and_risk_management_input_problems(Profile, [unknown_key(colour)]),
    complete_answers(unknown_key_present, CompleteAnswers),
    CompleteAnswers == [input_problems([unknown_key(colour)]) - []],
    required_answers(unknown_key_present, RequiredAnswers),
    RequiredAnswers == [input_problems([unknown_key(colour)]) - []],
    outstanding_answers(unknown_key_present, OutstandingAnswers),
    OutstandingAnswers == [input_problems([unknown_key(colour)]) - []].
test(an_unknown_key_profile_has_no_checklist_rows) :-
    dora_rts_policies_and_risk_management_profile_for(unknown_key_present, Profile),
    dora_rts_policies_and_risk_management_checklist(Profile, []).
test(every_judgeable_subject_has_a_checklist) :-
    findall(Subject, (dora_rts_policies_and_risk_management_subject(Subject), dora_rts_policies_and_risk_management_profile_for(Subject, Profile), dora_rts_policies_and_risk_management_checklist(Profile, [_|_])), WithRows),
    length(WithRows, 8).
test(every_checklist_row_is_cited) :-
    findall(Citation, (dora_rts_policies_and_risk_management_subject(Subject), dora_rts_policies_and_risk_management_profile_for(Subject, Profile), dora_rts_policies_and_risk_management_checklist(Profile, Items), member(item(_, _, Citation), Items)), Citations),
    Citations = [_|_],
    maplist(cited, Citations).
test(the_checklist_marks_the_failing_duty) :-
    dora_rts_policies_and_risk_management_profile_for(one_duty_not_performed, Profile),
    dora_rts_policies_and_risk_management_checklist(Profile, Items),
    length(Items, 27),
    member(item(network_security, unmet(not_performed), cite(eu_reg_2024_1774_art_2_1_a)), Items),
    member(item(risk_profile_and_complexity_consideration, met, cite(eu_reg_2024_1774_art_1)), Items).
test(the_checklist_of_a_performed_profile_is_all_met) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    dora_rts_policies_and_risk_management_checklist(Profile, Items),
    length(Items, 27),
    maplist(met_item, Items).

subject_resolvable(Subject) :-
    dora_rts_policies_and_risk_management_profile_for(Subject, Profile),
    dora_rts_policies_and_risk_management_decision_resolvable(Profile).

test(all_duties_performed_is_not_incomplete, fail) :-
    dora_rts_policies_and_risk_management_assess(all_duties_performed, dora_rts_policies_and_risk_management_verdict(incomplete, _)).
test(one_duty_not_performed_is_not_complete, fail) :-
    dora_rts_policies_and_risk_management_assess(one_duty_not_performed, dora_rts_policies_and_risk_management_verdict(complete, _)).
test(an_article_16_1_entity_is_not_complete, fail) :-
    dora_rts_policies_and_risk_management_assess(simplified_framework_entity_with_duties_performed, dora_rts_policies_and_risk_management_verdict(complete, _)).
test(the_unanswered_gate_is_not_complete, fail) :-
    dora_rts_policies_and_risk_management_assess(gate_unanswered, dora_rts_policies_and_risk_management_verdict(complete, _)).
test(an_unanswered_duty_is_not_complete, fail) :-
    dora_rts_policies_and_risk_management_assess(duty_unanswered, dora_rts_policies_and_risk_management_verdict(complete, _)).
test(an_unsure_judgement_is_not_complete, fail) :-
    dora_rts_policies_and_risk_management_assess(duty_judgement_unsure, dora_rts_policies_and_risk_management_verdict(complete, _)).
test(a_context_with_two_provenance_items_is_not_the_contract_shape, fail) :-
    referral_context_shape([inputs_relied_on([]), provenance(complete_answer, []), provenance(outstanding_answer, [])]).
test(a_provenance_item_alone_is_not_the_contract_shape, fail) :-
    referral_context_shape([provenance(complete_answer, [cite(eu_reg_2024_1774_art_2_2_c)])]).
test(a_second_paragraph_duty_not_performed_is_not_none_outstanding, fail) :-
    dora_rts_policies_and_risk_management_profile_for(second_paragraph_duty_not_performed, Profile),
    rts_policies_and_risk_management_duties_outstanding(Profile, none_outstanding, _).
test(an_unknown_key_profile_is_not_complete, fail) :-
    dora_rts_policies_and_risk_management_assess(unknown_key_present, dora_rts_policies_and_risk_management_verdict(complete, _)).
test(the_checklist_of_a_performed_profile_has_no_unmet_row, fail) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    dora_rts_policies_and_risk_management_checklist(Profile, Items),
    member(item(_, unmet(_), _), Items).

met_item(item(_, met, cite(_))).

cp_test_names([nine_subjects_are_registered, every_query_answers_once_for_every_subject, every_subject_is_resolvable, all_duties_performed_is_complete, all_duties_performed_verdict_is_complete, all_duties_performed_is_a_final_status, all_duties_performed_none_outstanding, all_duties_performed_requires_every_duty_in_order, all_duties_performed_has_no_input_problem, one_duty_not_performed_is_incomplete, one_duty_not_performed_is_outstanding_with_its_own_citation, an_article_16_1_entity_is_simplified_framework_entity, the_unanswered_gate_is_asked_first, the_unanswered_gate_status_is_indeterminate, an_unanswered_duty_is_named, an_unanswered_duty_still_lists_every_required_duty, an_unsure_judgement_goes_to_a_lawyer, an_unsure_judgement_goes_to_a_lawyer_in_outstanding, the_referral_context_has_the_contract_shape, a_context_with_one_provenance_item_has_the_contract_shape, a_second_paragraph_duty_not_performed_is_incomplete, a_second_paragraph_duty_is_outstanding_with_its_run2_citation, a_failing_duty_decides_complete_before_the_unanswered_key, outstanding_asks_the_unanswered_key_despite_the_failing_duty, an_unknown_key_is_an_input_problem, an_unknown_key_profile_has_no_checklist_rows, every_judgeable_subject_has_a_checklist, every_checklist_row_is_cited, the_checklist_marks_the_failing_duty, the_checklist_of_a_performed_profile_is_all_met]).
cp_test_fail_names([all_duties_performed_is_not_incomplete, one_duty_not_performed_is_not_complete, an_article_16_1_entity_is_not_complete, the_unanswered_gate_is_not_complete, an_unanswered_duty_is_not_complete, an_unsure_judgement_is_not_complete, a_context_with_two_provenance_items_is_not_the_contract_shape, a_provenance_item_alone_is_not_the_contract_shape, a_second_paragraph_duty_not_performed_is_not_none_outstanding, an_unknown_key_profile_is_not_complete, the_checklist_of_a_performed_profile_has_no_unmet_row]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
