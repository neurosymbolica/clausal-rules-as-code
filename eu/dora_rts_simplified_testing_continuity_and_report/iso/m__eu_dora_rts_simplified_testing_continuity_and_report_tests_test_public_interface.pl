% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_simplified_testing_continuity_and_report_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2, clausal_is_list/1]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_dora_rts_simplified_testing_continuity_and_report, [simplified_testing_continuity_and_report_duties_required/3, simplified_testing_continuity_and_report_duties_complete/3, simplified_testing_continuity_and_report_duties_outstanding/3, decide_dora_rts_simplified_testing_continuity_and_report/2, dora_rts_simplified_testing_continuity_and_report_status/2, dora_rts_simplified_testing_continuity_and_report_checklist/2, dora_rts_simplified_testing_continuity_and_report_decision_resolvable/1, dora_rts_simplified_testing_continuity_and_report_status_values/1]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_kernel, [dora_rts_simplified_testing_continuity_and_report_input_problems/2]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_fixtures, [dora_rts_simplified_testing_continuity_and_report_subject/1, dora_rts_simplified_testing_continuity_and_report_profile_for/2, dora_rts_simplified_testing_continuity_and_report_assess/2]).
:- use_module(m__eu_dora_rts_simplified_testing_continuity_and_report_queries, [dora_rts_simplified_testing_continuity_and_report_what_if/4]).

expected_status(all_performed_without_request, complete).
expected_status(one_testing_duty_not_performed_without_request, incomplete).
expected_status(all_performed_with_request_for_both_reasons, complete).
expected_status(incident_list_missing_with_request_for_both_reasons, incomplete).
expected_status(conclusions_missing_without_request, complete).
expected_status(conclusions_missing_with_request, incomplete).
expected_status(conclusions_missing_request_unanswered, indeterminate).
expected_status(evidence_missing_without_supervisory_instructions, complete).
expected_status(evidence_missing_with_supervisory_instructions, incomplete).
expected_status(backup_procedures_unsure_without_request, needs_legal_review).
expected_status(backup_procedures_unsure_with_testing_plan_not_performed, incomplete).
expected_status(not_an_article_16_1_entity, not_article_16_1_entity).
expected_status(gate_unanswered, indeterminate).
expected_status(microenterprise_key_given, input_problems).
expected_status(request_given_as_unsure, input_problems).
expected_status(gate_given_twice, input_problems).

near_miss(all_performed_without_request, one_testing_duty_not_performed_without_request).
near_miss(all_performed_with_request_for_both_reasons, incident_list_missing_with_request_for_both_reasons).
near_miss(conclusions_missing_without_request, conclusions_missing_with_request).
near_miss(conclusions_missing_without_request, conclusions_missing_request_unanswered).
near_miss(evidence_missing_without_supervisory_instructions, evidence_missing_with_supervisory_instructions).
near_miss(backup_procedures_unsure_without_request, backup_procedures_unsure_with_testing_plan_not_performed).
near_miss(all_performed_without_request, not_an_article_16_1_entity).
near_miss(all_performed_without_request, gate_unanswered).
near_miss(all_performed_without_request, microenterprise_key_given).
near_miss(all_performed_without_request, request_given_as_unsure).
near_miss(all_performed_without_request, gate_given_twice).

subject_status(Subject, Status) :-
    dora_rts_simplified_testing_continuity_and_report_assess(Subject, dora_rts_simplified_testing_continuity_and_report_verdict(Result, _)),
    functor(Result, Status, _).

subject_profile(Subject, Profile) :-
    dora_rts_simplified_testing_continuity_and_report_profile_for(Subject, Profile).

all_subjects(Subjects) :-
    findall(Subject, dora_rts_simplified_testing_continuity_and_report_subject(Subject), Subjects).

matches_expected(Subject) :-
    expected_status(Subject, Status),
    subject_status(Subject, Status),
    subject_profile(Subject, Profile),
    dora_rts_simplified_testing_continuity_and_report_status(Profile, Status).

answers_once(Subject) :-
    subject_profile(Subject, Profile),
    findall(Result - Citations, simplified_testing_continuity_and_report_duties_complete(Profile, Result, Citations), CompleteAnswers),
    length(CompleteAnswers, 1),
    findall(Result - Citations, simplified_testing_continuity_and_report_duties_required(Profile, Result, Citations), RequiredAnswers),
    length(RequiredAnswers, 1),
    findall(Result - Citations, simplified_testing_continuity_and_report_duties_outstanding(Profile, Result, Citations), OutstandingAnswers),
    length(OutstandingAnswers, 1),
    findall(Problems, dora_rts_simplified_testing_continuity_and_report_input_problems(Profile, Problems), ProblemAnswers),
    length(ProblemAnswers, 1).

checklist_non_empty(Subject) :-
    subject_profile(Subject, Profile),
    dora_rts_simplified_testing_continuity_and_report_decision_resolvable(Profile),
    dora_rts_simplified_testing_continuity_and_report_checklist(Profile, [_|_]).

citation_shape(complete, [_|_]).
citation_shape(incomplete, [_|_]).
citation_shape(not_article_16_1_entity, [_|_]).
citation_shape(indeterminate, []).
citation_shape(needs_legal_review, []).
citation_shape(input_problems, []).

citations_well_shaped(Subject) :-
    dora_rts_simplified_testing_continuity_and_report_assess(Subject, dora_rts_simplified_testing_continuity_and_report_verdict(Result, Citations)),
    functor(Result, Status, _),
    citation_shape(Status, Citations).

control_differs(Positive - Control) :-
    subject_status(Positive, PositiveStatus),
    subject_status(Control, ControlStatus),
    dif(PositiveStatus, ControlStatus).

status_is_known(Subject) :-
    subject_status(Subject, Status),
    dora_rts_simplified_testing_continuity_and_report_status_values(StatusValues),
    member(Status, StatusValues).

referral_context_well_shaped([inputs_relied_on(Pairs)]) :-
    clausal_is_list(Pairs).
referral_context_well_shaped([inputs_relied_on(Pairs), provenance(Clause, Citations)]) :-
    clausal_is_list(Pairs),
    atom(Clause),
    clausal_is_list(Citations).

referral_context(Context) :-
    dora_rts_simplified_testing_continuity_and_report_assess(backup_procedures_unsure_without_request, dora_rts_simplified_testing_continuity_and_report_verdict(needs_legal_review(open_textured(_, _), Context), [])).

test(every_subject_resolves_to_its_expected_status) :-
    all_subjects(Subjects),
    length(Subjects, 16),
    maplist(matches_expected, Subjects).
test(every_status_is_a_declared_status_value) :-
    all_subjects(Subjects),
    maplist(status_is_known, Subjects).
test(every_subject_answers_each_query_once) :-
    all_subjects(Subjects),
    maplist(answers_once, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    all_subjects(Subjects),
    maplist(checklist_non_empty, Subjects).
test(final_answers_cite_and_statuses_do_not) :-
    all_subjects(Subjects),
    maplist(citations_well_shaped, Subjects).
test(every_near_miss_control_gets_another_status) :-
    findall(Positive - Control, near_miss(Positive, Control), Pairs),
    length(Pairs, 11),
    maplist(control_differs, Pairs).
test(all_performed_without_request_is_complete) :-
    subject_status(all_performed_without_request, complete).
test(one_testing_duty_not_performed_is_incomplete) :-
    subject_status(one_testing_duty_not_performed_without_request, incomplete).
test(all_performed_with_request_is_complete) :-
    subject_status(all_performed_with_request_for_both_reasons, complete).
test(incident_list_missing_is_incomplete) :-
    subject_status(incident_list_missing_with_request_for_both_reasons, incomplete).
test(conclusions_missing_without_request_is_complete) :-
    subject_status(conclusions_missing_without_request, complete).
test(conclusions_missing_with_request_is_incomplete) :-
    subject_status(conclusions_missing_with_request, incomplete).
test(conclusions_missing_request_unanswered_names_the_request) :-
    dora_rts_simplified_testing_continuity_and_report_assess(conclusions_missing_request_unanswered, dora_rts_simplified_testing_continuity_and_report_verdict(indeterminate([authority_requested_framework_review_report]), [])).
test(evidence_missing_without_supervisory_instructions_is_complete) :-
    subject_status(evidence_missing_without_supervisory_instructions, complete).
test(evidence_missing_with_supervisory_instructions_is_incomplete) :-
    subject_status(evidence_missing_with_supervisory_instructions, incomplete).
test(unsure_backup_procedures_are_referred) :-
    dora_rts_simplified_testing_continuity_and_report_assess(backup_procedures_unsure_without_request, dora_rts_simplified_testing_continuity_and_report_verdict(needs_legal_review(open_textured(continuity_plans_identify_backup_procedures_scope_and_frequency, cite(eu_reg_2024_1774_art_39_2)), [inputs_relied_on(Pairs)]), [])),
    length(Pairs, 25),
    Pairs = [financial_entity_is_article_16_1_entity - true, authority_requested_framework_review_report - false|_].
test(a_false_duty_decides_before_an_unsure_one) :-
    subject_status(backup_procedures_unsure_with_testing_plan_not_performed, incomplete).
test(a_false_gate_is_not_an_article_16_1_entity) :-
    dora_rts_simplified_testing_continuity_and_report_assess(not_an_article_16_1_entity, dora_rts_simplified_testing_continuity_and_report_verdict(not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)])).
test(an_absent_gate_is_named) :-
    dora_rts_simplified_testing_continuity_and_report_assess(gate_unanswered, dora_rts_simplified_testing_continuity_and_report_verdict(indeterminate([financial_entity_is_article_16_1_entity]), [])).
test(the_microenterprise_key_is_unknown) :-
    dora_rts_simplified_testing_continuity_and_report_assess(microenterprise_key_given, dora_rts_simplified_testing_continuity_and_report_verdict(input_problems([unknown_key(financial_entity_is_microenterprise)]), [])).
test(an_unsure_request_is_wrong_type) :-
    dora_rts_simplified_testing_continuity_and_report_assess(request_given_as_unsure, dora_rts_simplified_testing_continuity_and_report_verdict(input_problems([wrong_type(authority_requested_framework_review_report)]), [])).
test(a_gate_given_twice_is_a_duplicate) :-
    subject_profile(gate_given_twice, Profile),
    dora_rts_simplified_testing_continuity_and_report_input_problems(Profile, [duplicate_key(financial_entity_is_article_16_1_entity)]).
test(the_well_formed_subject_has_no_problem) :-
    subject_profile(all_performed_without_request, Profile),
    dora_rts_simplified_testing_continuity_and_report_input_problems(Profile, []).
test(the_referral_context_is_well_shaped) :-
    referral_context(Context),
    referral_context_well_shaped(Context).
test(a_context_with_a_provenance_item_is_well_shaped) :-
    referral_context([inputs_relied_on(Pairs)]),
    referral_context_well_shaped([inputs_relied_on(Pairs), provenance(complete_referral, [cite(eu_reg_2024_1774_art_39_2)])]).
test(incomplete_cites_the_fixed_fourteen) :-
    subject_profile(one_testing_duty_not_performed_without_request, Profile),
    simplified_testing_continuity_and_report_duties_complete(Profile, incomplete, Citations),
    length(Citations, 14).
test(required_without_request_lists_twenty_three) :-
    subject_profile(all_performed_without_request, Profile),
    simplified_testing_continuity_and_report_duties_required(Profile, required(Duties), Citations),
    length(Duties, 23),
    Duties = [ict_security_testing_plan|_],
    last(Duties, continuity_test_results_and_deficiencies),
    length(Citations, 12).
test(required_with_request_for_both_reasons_lists_thirty_eight) :-
    subject_profile(all_performed_with_request_for_both_reasons, Profile),
    simplified_testing_continuity_and_report_duties_required(Profile, required(Duties), Citations),
    length(Duties, 38),
    last(Duties, report_overall_conclusions),
    length(Citations, 14).
test(outstanding_names_the_incident_list) :-
    subject_profile(incident_list_missing_with_request_for_both_reasons, Profile),
    simplified_testing_continuity_and_report_duties_outstanding(Profile, outstanding([report_incidents_and_root_cause_analysis]), [cite(eu_reg_2024_1774_art_41_2)]).
test(outstanding_names_the_evidence_of_instructions) :-
    subject_profile(evidence_missing_with_supervisory_instructions, Profile),
    simplified_testing_continuity_and_report_duties_outstanding(Profile, outstanding([report_evidence_of_supervisory_instructions]), [cite(eu_reg_2024_1774_art_41_2)]).
test(outstanding_without_supervisory_instructions_is_none) :-
    subject_profile(evidence_missing_without_supervisory_instructions, Profile),
    simplified_testing_continuity_and_report_duties_outstanding(Profile, none_outstanding, Citations),
    length(Citations, 14).
test(outstanding_asks_for_the_unanswered_request) :-
    subject_profile(conclusions_missing_request_unanswered, Profile),
    simplified_testing_continuity_and_report_duties_outstanding(Profile, indeterminate([authority_requested_framework_review_report]), []).
test(the_checklist_cites_every_item) :-
    subject_profile(all_performed_with_request_for_both_reasons, Profile),
    dora_rts_simplified_testing_continuity_and_report_checklist(Profile, Items),
    length(Items, 39),
    Items = [item(article_16_1_entity, met, [cite(eu_reg_2022_2554_art_16_1)])|_].
test(what_if_a_duty_turns_false_it_is_incomplete) :-
    subject_profile(all_performed_without_request, Profile),
    dora_rts_simplified_testing_continuity_and_report_what_if(Profile, continuity_plans_consider_alternative_options, false, incomplete).
test(what_if_a_duty_stays_true_it_is_complete) :-
    subject_profile(all_performed_without_request, Profile),
    dora_rts_simplified_testing_continuity_and_report_what_if(Profile, continuity_plans_consider_alternative_options, true, complete).
test(what_if_the_request_is_made_conclusions_matter) :-
    subject_profile(conclusions_missing_without_request, Profile),
    dora_rts_simplified_testing_continuity_and_report_what_if(Profile, authority_requested_framework_review_report, true, incomplete).

test(one_testing_duty_not_performed_is_not_complete, fail) :-
    subject_status(one_testing_duty_not_performed_without_request, complete).
test(conclusions_missing_without_request_is_not_incomplete, fail) :-
    subject_status(conclusions_missing_without_request, incomplete).
test(unsure_backup_procedures_are_not_complete, fail) :-
    subject_status(backup_procedures_unsure_without_request, complete).
test(the_referral_carries_no_provenance_item, fail) :-
    referral_context([_, provenance(_, _)]).
test(a_provenance_item_alone_is_not_a_context, fail) :-
    referral_context_well_shaped([provenance(complete_referral, [])]).
test(outstanding_with_an_unanswered_request_is_not_none, fail) :-
    subject_profile(conclusions_missing_request_unanswered, Profile),
    simplified_testing_continuity_and_report_duties_outstanding(Profile, none_outstanding, _).

cp_test_names([every_subject_resolves_to_its_expected_status, every_status_is_a_declared_status_value, every_subject_answers_each_query_once, every_subject_has_a_non_empty_checklist, final_answers_cite_and_statuses_do_not, every_near_miss_control_gets_another_status, all_performed_without_request_is_complete, one_testing_duty_not_performed_is_incomplete, all_performed_with_request_is_complete, incident_list_missing_is_incomplete, conclusions_missing_without_request_is_complete, conclusions_missing_with_request_is_incomplete, conclusions_missing_request_unanswered_names_the_request, evidence_missing_without_supervisory_instructions_is_complete, evidence_missing_with_supervisory_instructions_is_incomplete, unsure_backup_procedures_are_referred, a_false_duty_decides_before_an_unsure_one, a_false_gate_is_not_an_article_16_1_entity, an_absent_gate_is_named, the_microenterprise_key_is_unknown, an_unsure_request_is_wrong_type, a_gate_given_twice_is_a_duplicate, the_well_formed_subject_has_no_problem, the_referral_context_is_well_shaped, a_context_with_a_provenance_item_is_well_shaped, incomplete_cites_the_fixed_fourteen, required_without_request_lists_twenty_three, required_with_request_for_both_reasons_lists_thirty_eight, outstanding_names_the_incident_list, outstanding_names_the_evidence_of_instructions, outstanding_without_supervisory_instructions_is_none, outstanding_asks_for_the_unanswered_request, the_checklist_cites_every_item, what_if_a_duty_turns_false_it_is_incomplete, what_if_a_duty_stays_true_it_is_complete, what_if_the_request_is_made_conclusions_matter]).
cp_test_fail_names([one_testing_duty_not_performed_is_not_complete, conclusions_missing_without_request_is_not_incomplete, unsure_backup_procedures_are_not_complete, the_referral_carries_no_provenance_item, a_provenance_item_alone_is_not_a_context, outstanding_with_an_unanswered_request_is_not_none]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
