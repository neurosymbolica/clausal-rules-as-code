% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_incident_management_process_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_dora_ict_incident_management_process_kernel, [dora_ict_incident_management_process_input_problems/2]).
:- use_module(m__eu_dora_ict_incident_management_process_citations, [citation/2, implements/1]).

test(the_kernel_input_check_accepts_an_empty_profile) :-
    dora_ict_incident_management_process_input_problems([], []).
test(the_kernel_input_check_accepts_a_false_judgement) :-
    dora_ict_incident_management_process_input_problems([attribute(incident_response_procedures_established, false)], []).
test(the_kernel_input_check_names_a_wrong_value) :-
    dora_ict_incident_management_process_input_problems([attribute(incident_response_procedures_established, maybe)], [wrong_type(incident_response_procedures_established)]).
test(the_kernel_input_check_refuses_a_non_list_profile) :-
    dora_ict_incident_management_process_input_problems(not_a_list, [wrong_type(profile)]).
test(complete_and_incomplete_are_distinct) :-
    dif(complete, incomplete).
test(none_outstanding_and_complete_are_distinct) :-
    dif(none_outstanding, complete).
test(none_outstanding_and_incomplete_are_distinct) :-
    dif(none_outstanding, incomplete).
test(the_judgement_values_are_distinct) :-
    dif(true, false),
    dif(true, unsure),
    dif(false, unsure).
test(the_required_result_builds_and_destructures) :-
    Result = required([incident_management_process, recording_of_incidents_and_significant_cyber_threats, monitoring_handling_and_follow_up_procedures, early_warning_indicators, identification_and_classification_procedures, incident_roles_and_responsibilities, communication_and_escalation_plans, reporting_to_senior_management_and_management_body, incident_response_procedures, classification_of_significant_cyber_threats]),
    Result = required(Duties),
    length(Duties, 10),
    Duties = [FirstDuty|_],
    FirstDuty == incident_management_process,
    last(Duties, LastDuty),
    LastDuty == classification_of_significant_cyber_threats.
test(the_outstanding_result_builds_and_destructures) :-
    Result = outstanding([early_warning_indicators, incident_response_procedures]),
    Result = outstanding(Duties),
    Duties == [early_warning_indicators, incident_response_procedures].
test(the_indeterminate_status_holds_one_bare_key) :-
    Status = indeterminate([early_warning_indicators_put_in_place]),
    Status = indeterminate(MissingKeys),
    MissingKeys = [MissingKey],
    atom(MissingKey),
    MissingKey == early_warning_indicators_put_in_place.
test(the_referral_status_builds_and_destructures) :-
    Status = needs_legal_review(open_textured(early_warning_indicators_put_in_place, cite(eu_reg_2022_2554_art_17_3_a)), [inputs_relied_on([early_warning_indicators_put_in_place - unsure])]),
    Status = needs_legal_review(Reason, Context),
    Reason = open_textured(JudgementKey, cite(CitationKey)),
    JudgementKey == early_warning_indicators_put_in_place,
    citation(CitationKey, _Record),
    Context = [inputs_relied_on(Pairs)],
    Pairs == [early_warning_indicators_put_in_place - unsure].
test(the_input_problems_status_builds_and_destructures) :-
    Status = input_problems([duplicate_key(incident_response_procedures_established), unknown_key(colour)]),
    Status = input_problems(Problems),
    Problems = [FirstProblem, SecondProblem],
    FirstProblem = duplicate_key(DuplicatedKey),
    DuplicatedKey == incident_response_procedures_established,
    SecondProblem = unknown_key(UnknownKey),
    UnknownKey == colour.
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = dora_ict_incident_management_process_verdict(complete, [cite(eu_reg_2022_2554_art_17_1), cite(eu_reg_2022_2554_art_17_2), cite(eu_reg_2022_2554_art_17_3), cite(eu_reg_2022_2554_art_18_2)]),
    Verdict = dora_ict_incident_management_process_verdict(Status, Citations),
    Status == complete,
    length(Citations, 4).
test(the_article_17_1_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_17_1, _Record).
test(the_fixed_citations_are_recorded) :-
    implements(eu_reg_2022_2554_art_17_1),
    implements(eu_reg_2022_2554_art_17_2),
    implements(eu_reg_2022_2554_art_17_3),
    implements(eu_reg_2022_2554_art_18_2).
test(the_point_citations_are_recorded) :-
    implements(eu_reg_2022_2554_art_17_3_a),
    implements(eu_reg_2022_2554_art_17_3_b),
    implements(eu_reg_2022_2554_art_17_3_c),
    implements(eu_reg_2022_2554_art_17_3_d),
    implements(eu_reg_2022_2554_art_17_3_e),
    implements(eu_reg_2022_2554_art_17_3_f).

test(the_kernel_input_check_does_not_accept_a_wrong_value, fail) :-
    dora_ict_incident_management_process_input_problems([attribute(incident_response_procedures_established, maybe)], []).
test(a_shortened_citation_is_not_recorded, fail) :-
    citation(dora_art_17_1, _Record).

cp_test_names([the_kernel_input_check_accepts_an_empty_profile, the_kernel_input_check_accepts_a_false_judgement, the_kernel_input_check_names_a_wrong_value, the_kernel_input_check_refuses_a_non_list_profile, complete_and_incomplete_are_distinct, none_outstanding_and_complete_are_distinct, none_outstanding_and_incomplete_are_distinct, the_judgement_values_are_distinct, the_required_result_builds_and_destructures, the_outstanding_result_builds_and_destructures, the_indeterminate_status_holds_one_bare_key, the_referral_status_builds_and_destructures, the_input_problems_status_builds_and_destructures, the_verdict_term_carries_status_and_citations, the_article_17_1_citation_is_recorded, the_fixed_citations_are_recorded, the_point_citations_are_recorded]).
cp_test_fail_names([the_kernel_input_check_does_not_accept_a_wrong_value, a_shortened_citation_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
