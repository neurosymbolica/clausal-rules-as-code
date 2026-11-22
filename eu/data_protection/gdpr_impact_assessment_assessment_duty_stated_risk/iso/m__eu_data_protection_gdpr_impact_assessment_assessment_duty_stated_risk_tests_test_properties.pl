% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_gdpr_impact_assessment_assessment_duty_stated_risk, [decide_gdpr_impact_assessment_assessment_duty_stated_risk/2, decide_impact_assessment_duty/2, impact_assessment_officer_advice/2]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_fixtures, [gdpr_impact_assessment_assessment_duty_stated_risk_subject/1, gdpr_impact_assessment_assessment_duty_stated_risk_profile_for/2]).

all_subjects(Subjects) :-
    findall(Subject, gdpr_impact_assessment_assessment_duty_stated_risk_subject(Subject), Subjects).

one_entry_a_verdict(Subject) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(Subject, Profile),
    findall(Verdict, decide_impact_assessment_duty(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

one_entry_o_verdict(Subject) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(Subject, Profile),
    findall(Verdict, impact_assessment_officer_advice(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

one_facade_verdict(Subject) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(Subject, Profile),
    findall(Verdict, decide_gdpr_impact_assessment_assessment_duty_stated_risk(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

verdict_shape(required, [_], _, Context, [_|_]) :-
    last(Context, inputs_relied_on(_)).
verdict_shape(not_required, [_], [], Context, [_|_]) :-
    last(Context, inputs_relied_on(_)).
verdict_shape(indeterminate([_]), [], [], [], []).
verdict_shape(needs_legal_review(_, _), [], [], [], []).
verdict_shape(input_problems([_|_]), [], [], [], []).

entry_a_well_shaped(Subject) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(Subject, Profile),
    decide_impact_assessment_duty(Profile, impact_assessment_verdict(Status, Bases, MissingContents, Context, Citations, RoutesReliedOn)),
    RoutesReliedOn == [],
    verdict_shape(Status, Bases, MissingContents, Context, Citations).

officer_shape(met, [cite(eu_reg_2016_679_art_35_2)]).
officer_shape(not_met, [cite(eu_reg_2016_679_art_35_2)]).
officer_shape(not_applicable, [cite(eu_reg_2016_679_art_35_2)]).
officer_shape(indeterminate([_]), []).
officer_shape(input_problems([_|_]), []).

entry_o_well_shaped(Subject) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(Subject, Profile),
    impact_assessment_officer_advice(Profile, officer_advice_verdict(Status, Citations)),
    officer_shape(Status, Citations).

unread_extra_keys([attribute(highly_personal_data_processed, true), attribute(datasets_matched_or_combined, unsure), attribute(vulnerable_data_subjects, true), attribute(processing_prevents_exercise_of_right_or_service, false), attribute(uses_new_technologies, true), attribute(mitigating_measures_taken, false), attribute(processing_for_public_interest_task, true), attribute(assessment_indicates_high_risk_absent_mitigation, true), attribute(measures_reduce_residual_risk_below_high, unsure), attribute(member_state_requires_prior_authorisation, attested(false, attestation(host, at_time, reason, none))), attribute(route_approvals, approvals(viewer(account), []))]).

unread_keys_change_nothing(Subject) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(Subject, Profile),
    unread_extra_keys(Extra),
    append(Profile, Extra, Extended),
    decide_impact_assessment_duty(Profile, DutyVerdict),
    decide_impact_assessment_duty(Extended, DutyVerdict),
    impact_assessment_officer_advice(Profile, OfficerVerdict),
    impact_assessment_officer_advice(Extended, OfficerVerdict).

test(totality_and_determinism_of_entry_a) :-
    all_subjects(Subjects),
    Subjects = [_|_],
    maplist(one_entry_a_verdict, Subjects).
test(totality_and_determinism_of_entry_o) :-
    all_subjects(Subjects),
    maplist(one_entry_o_verdict, Subjects).
test(totality_and_determinism_of_the_facade) :-
    all_subjects(Subjects),
    maplist(one_facade_verdict, Subjects).
test(every_entry_a_verdict_is_well_shaped) :-
    all_subjects(Subjects),
    maplist(entry_a_well_shaped, Subjects).
test(every_entry_o_verdict_is_well_shaped) :-
    all_subjects(Subjects),
    maplist(entry_o_well_shaped, Subjects).
test(keys_no_step_reads_change_no_answer) :-
    all_subjects(Subjects),
    maplist(unread_keys_change_nothing, Subjects).
test(a_final_status_with_its_citation_is_well_shaped) :-
    verdict_shape(required, [art35_1_high_risk], [], [inputs_relied_on([])], [cite(eu_reg_2016_679_art_35_1)]).

test(a_final_status_without_citations_is_not_well_shaped, fail) :-
    verdict_shape(required, [art35_1_high_risk], [], [inputs_relied_on([])], []).

cp_test_names([totality_and_determinism_of_entry_a, totality_and_determinism_of_entry_o, totality_and_determinism_of_the_facade, every_entry_a_verdict_is_well_shaped, every_entry_o_verdict_is_well_shaped, keys_no_step_reads_change_no_answer, a_final_status_with_its_citation_is_well_shaped]).
cp_test_fail_names([a_final_status_without_citations_is_not_well_shaped]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
