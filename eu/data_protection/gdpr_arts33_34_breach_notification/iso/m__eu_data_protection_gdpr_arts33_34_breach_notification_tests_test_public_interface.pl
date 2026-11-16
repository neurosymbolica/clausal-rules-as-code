% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [breach_notification_verdict/4, notification_obligation/2, authority_notification_deadline/3, authority_notification_period_end/3, authority_notification_content_check/2, data_subject_communication_check/2, decide_breach_notification_verdict/2, breach_notification_verdict_status/2, breach_notification_verdict_checklist/2, breach_notification_verdict_decision_resolvable/1, breach_notification_verdict_status_values/1, provenance/2, duplicate_key/1]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_queries, [gdpr_arts33_34_breach_notification_profile_keys/1, gdpr_arts33_34_breach_notification_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_fixtures, [gdpr_arts33_34_breach_notification_subject/1, gdpr_arts33_34_breach_notification_profile_for/2, gdpr_arts33_34_breach_notification_assess/2]).

expected_verdict(timely_notification_eligible, eligible, [cite(eu_reg_2016_679_art_33_1)]).
expected_verdict(one_hour_late_without_reasons, notification_requirement_not_met(reasons_for_delay), [cite(eu_reg_2016_679_art_33_1)]).
expected_verdict(inside_period_unduly_delayed, notification_requirement_not_met(without_undue_delay), [cite(eu_reg_2016_679_art_33_1)]).
expected_verdict(unlikely_risk_ineligible, ineligible, [cite(eu_reg_2016_679_art_33_1)]).
expected_verdict(risk_not_unlikely_control, eligible, [cite(eu_reg_2016_679_art_33_1)]).
expected_verdict(late_with_justified_reasons_eligible, eligible, [cite(eu_reg_2016_679_art_33_1)]).
expected_verdict(late_with_unjustified_reasons_referral, needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - 73, breach_unlikely_to_result_in_risk - false, delay_justified_by_reasons - false])]), []).
expected_verdict(risk_judgement_missing, indeterminate([breach_unlikely_to_result_in_risk]), []).
expected_verdict(risk_judgement_stated_control, eligible, [cite(eu_reg_2016_679_art_33_1)]).
expected_verdict(unsure_risk_referral, needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure])]), []).
expected_verdict(contradictory_risk_inputs, input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])]), []).
expected_verdict(consistent_risk_inputs_control, ineligible, [cite(eu_reg_2016_679_art_33_1)]).
expected_verdict(negative_hours_input_problem, input_problems([wrong_type(hours_elapsed)]), []).
expected_verdict(zero_hours_eligible, eligible, [cite(eu_reg_2016_679_art_33_1)]).

near_miss(timely_notification_eligible, one_hour_late_without_reasons).
near_miss(timely_notification_eligible, inside_period_unduly_delayed).
near_miss(unlikely_risk_ineligible, risk_not_unlikely_control).
near_miss(late_with_justified_reasons_eligible, late_with_unjustified_reasons_referral).
near_miss(risk_judgement_missing, risk_judgement_stated_control).
near_miss(unsure_risk_referral, risk_judgement_stated_control).
near_miss(contradictory_risk_inputs, consistent_risk_inputs_control).
near_miss(negative_hours_input_problem, zero_hours_eligible).

resolves_as_expected(Subject) :-
    expected_verdict(Subject, Verdict, Citations),
    findall(Result, gdpr_arts33_34_breach_notification_assess(Subject, Result), Results),
    Results == [breach_notification_verdict(Verdict, Citations)].

has_a_checklist(Subject) :-
    gdpr_arts33_34_breach_notification_profile_for(Subject, Request),
    breach_notification_verdict_checklist(Request, [_|_]).

is_resolvable(Subject) :-
    gdpr_arts33_34_breach_notification_profile_for(Subject, Request),
    breach_notification_verdict_decision_resolvable(Request).

control_differs(Positive - Control) :-
    gdpr_arts33_34_breach_notification_assess(Positive, breach_notification_verdict(PositiveVerdict, _)),
    gdpr_arts33_34_breach_notification_assess(Control, breach_notification_verdict(ControlVerdict, _)),
    dif(PositiveVerdict, ControlVerdict).

test(every_subject_resolves_to_its_expected_verdict) :-
    findall(Subject, gdpr_arts33_34_breach_notification_subject(Subject), Subjects),
    length(Subjects, 14),
    maplist(resolves_as_expected, Subjects).
test(every_subject_has_an_expected_verdict) :-
    findall(Subject, gdpr_arts33_34_breach_notification_subject(Subject), Subjects),
    findall(Subject, expected_verdict(Subject, _, _), ExpectedSubjects),
    msort(Subjects, SortedSubjects),
    msort(ExpectedSubjects, SortedExpectedSubjects),
    SortedSubjects == SortedExpectedSubjects.
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, gdpr_arts33_34_breach_notification_subject(Subject), Subjects),
    maplist(has_a_checklist, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, gdpr_arts33_34_breach_notification_subject(Subject), Subjects),
    maplist(is_resolvable, Subjects).
test(every_near_miss_control_gets_a_different_verdict) :-
    findall(Positive - Control, near_miss(Positive, Control), Pairs),
    Pairs = [_|_],
    maplist(control_differs, Pairs).
test(timely_notification_is_eligible) :-
    gdpr_arts33_34_breach_notification_assess(timely_notification_eligible, breach_notification_verdict(eligible, [cite(eu_reg_2016_679_art_33_1)])).
test(one_hour_late_without_reasons_is_not_met) :-
    gdpr_arts33_34_breach_notification_assess(one_hour_late_without_reasons, breach_notification_verdict(notification_requirement_not_met(reasons_for_delay), [cite(eu_reg_2016_679_art_33_1)])).
test(late_with_unjustified_reasons_refers) :-
    breach_notification_verdict_status(case([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_accompanied_by_reasons_for_delay, true), attribute(delay_justified_by_reasons, false)], 73), needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), _)).
test(unlikely_risk_is_ineligible_whatever_the_hours) :-
    gdpr_arts33_34_breach_notification_assess(unlikely_risk_ineligible, breach_notification_verdict(ineligible, [cite(eu_reg_2016_679_art_33_1)])).
test(the_final_atoms_are_in_the_vocabulary) :-
    breach_notification_verdict_status_values(StatusValues),
    gdpr_arts33_34_breach_notification_assess(timely_notification_eligible, breach_notification_verdict(EligibleStatus, _)),
    gdpr_arts33_34_breach_notification_assess(unlikely_risk_ineligible, breach_notification_verdict(IneligibleStatus, _)),
    member(EligibleStatus, StatusValues),
    member(IneligibleStatus, StatusValues).
test(the_decision_term_carries_the_verdict) :-
    gdpr_arts33_34_breach_notification_profile_for(zero_hours_eligible, Request),
    decide_breach_notification_verdict(Request, breach_notification_verdict(eligible, [cite(eu_reg_2016_679_art_33_1)])).
test(the_timely_checklist_is_met_throughout) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_notification_eligible, Request),
    breach_notification_verdict_checklist(Request, [item(notification_duty_arises, met, cite(eu_reg_2016_679_art_33_1)), item(notification_within_72_hours, met, cite(eu_reg_2016_679_art_33_1))]).
test(the_late_checklist_marks_the_period_unmet) :-
    gdpr_arts33_34_breach_notification_profile_for(one_hour_late_without_reasons, Request),
    breach_notification_verdict_checklist(Request, [item(notification_duty_arises, met, cite(eu_reg_2016_679_art_33_1)), item(notification_within_72_hours, unmet(notification_after_72_hours), cite(eu_reg_2016_679_art_33_1))]).
test(the_verdict_has_one_solution_at_the_boundary) :-
    findall(Verdict - Citations, breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 72, Verdict, Citations), Answers),
    Answers == [eligible - [cite(eu_reg_2016_679_art_33_1)]].
test(a_fractional_hours_elapsed_is_an_input_problem) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false)], 72.5, input_problems([wrong_type(hours_elapsed)]), []).
test(profile_problems_come_before_argument_problems) :-
    breach_notification_verdict(not_a_profile, -1, input_problems([wrong_type(profile), wrong_type(hours_elapsed)]), []).
test(a_duplicated_key_refuses_the_verdict) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_unlikely_to_result_in_risk, false)], 10, input_problems([duplicate_key(breach_unlikely_to_result_in_risk)]), []).
test(what_if_the_notification_were_unduly_delayed) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_notification_eligible, Request),
    gdpr_arts33_34_breach_notification_what_if(Request, notification_made_without_undue_delay, false, notification_requirement_not_met(without_undue_delay)).
test(what_if_one_more_hour_had_begun) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_notification_eligible, Request),
    gdpr_arts33_34_breach_notification_what_if(Request, hours_elapsed, 73, indeterminate([notification_accompanied_by_reasons_for_delay])).
test(obligation_reading_six_example) :-
    findall(Obligation, notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, false), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, false), attribute(communication_would_involve_disproportionate_effort, true)], Obligation), Obligations),
    Obligations == [[notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_3_c))]].
test(obligation_without_disproportionate_effort_communicates) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, false), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, false), attribute(communication_would_involve_disproportionate_effort, false)], [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), communicate_to_data_subject(cite(eu_reg_2016_679_art_34_1))]).
test(obligation_protection_measures_exempt) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, true)], [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), no_communication_required(cite(eu_reg_2016_679_art_34_3_a))]).
test(obligation_authority_requires_communication) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true), attribute(supervisory_authority_decision_on_communication, required_communication)], [no_notification_required(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), communicate_to_data_subject(cite(eu_reg_2016_679_art_34_4))]).
test(obligation_authority_decided_a_condition) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(supervisory_authority_decision_on_communication, decided_point_a_condition_met)], [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), no_communication_required(cite(eu_reg_2016_679_art_34_4))]).
test(obligation_of_the_processor) :-
    notification_obligation([attribute(party_role, processor)], [notify_controller(cite(eu_reg_2016_679_art_33_2))]).
test(obligation_without_party_role) :-
    notification_obligation([attribute(breach_unlikely_to_result_in_risk, false)], indeterminate([party_role])).
test(obligation_unsure_risk_refers) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, unsure), attribute(breach_likely_to_result_in_high_risk, false), attribute(supervisory_authority_decision_on_communication, no_decision)], needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure])])).
test(obligation_refuses_contradictory_inputs) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, true)], input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])])).
test(deadline_crosses_a_month_end) :-
    authority_notification_deadline(date(2025, 10, 31), date(2025, 11, 3), 72).
test(deadline_on_a_saturday_is_not_shifted) :-
    authority_notification_deadline(date(2025, 11, 5), date(2025, 11, 8), 72).
test(deadline_crosses_a_leap_day) :-
    authority_notification_deadline(date(2032, 2, 27), date(2032, 3, 1), 72).
test(deadline_refuses_a_day_that_does_not_exist) :-
    authority_notification_deadline(date(2025, 2, 30), input_problems([wrong_type(awareness_date)]), 72).
test(deadline_has_one_solution) :-
    findall(Hours, authority_notification_deadline(date(2032, 2, 26), _, Hours), HoursList),
    HoursList == [72].
test(period_ends_at_the_hour_after_awareness) :-
    authority_notification_period_end(date(2025, 10, 31), 10, period_end(date(2025, 11, 3), 11)).
test(period_ends_at_the_end_of_the_day) :-
    authority_notification_period_end(date(2025, 12, 30), 23, period_end(date(2026, 1, 2), 24)).
test(period_end_refuses_hour_twenty_four) :-
    authority_notification_period_end(date(2025, 12, 30), 24, input_problems([wrong_type(awareness_hour)])).
test(notification_content_missing_nature_is_not_met) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, false), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, false)], requirements_not_met([nature_of_breach])).
test(notification_content_may_follow_in_phases) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, false), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, true)], information_to_follow_in_phases([nature_of_breach])).
test(notification_content_unsure_phases_refers) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, false), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, unsure)], needs_legal_review(open_textured(information_not_possible_to_provide_at_the_same_time, cite(eu_reg_2016_679_art_33_4)), [inputs_relied_on([information_not_possible_to_provide_at_the_same_time - unsure])])).
test(notification_content_all_met) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true)], all_requirements_met).
test(communication_all_met) :-
    data_subject_communication_check([attribute(communication_made_without_undue_delay, true), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], all_requirements_met).
test(communication_unsure_delay_refers) :-
    data_subject_communication_check([attribute(communication_made_without_undue_delay, unsure), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], needs_legal_review(open_textured(communication_made_without_undue_delay, cite(eu_reg_2016_679_art_34_1)), [inputs_relied_on([communication_made_without_undue_delay - unsure])])).
test(communication_missing_contact_point_is_not_met) :-
    data_subject_communication_check([attribute(communication_made_without_undue_delay, true), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, false), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], requirements_not_met([contact_point])).
test(the_input_check_accepts_an_empty_profile) :-
    gdpr_arts33_34_breach_notification_input_problems([], []).
test(the_input_check_refuses_the_reasons_pair) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(delay_justified_by_reasons, true), attribute(notification_accompanied_by_reasons_for_delay, false)], [contradictory_inputs([delay_justified_by_reasons, notification_accompanied_by_reasons_for_delay])]).
test(the_input_check_names_an_unknown_key) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(the_input_check_names_a_duplicate_key_once) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(party_role, controller), attribute(party_role, processor)], [duplicate_key(party_role)]).
test(the_schema_lists_the_twenty_five_keys) :-
    gdpr_arts33_34_breach_notification_profile_keys(Keys),
    length(Keys, 25).
test(duplicate_key_builds_over_a_key_atom) :-
    duplicate_key(party_role).
test(provenance_builds_over_a_clause_and_citations) :-
    provenance(risk_verdict, [cite(eu_reg_2016_679_art_33_1)]).

test(timely_notification_is_not_ineligible, fail) :-
    gdpr_arts33_34_breach_notification_assess(timely_notification_eligible, breach_notification_verdict(ineligible, _)).
test(one_hour_late_without_reasons_is_not_eligible, fail) :-
    gdpr_arts33_34_breach_notification_assess(one_hour_late_without_reasons, breach_notification_verdict(eligible, _)).
test(late_is_never_ineligible, fail) :-
    gdpr_arts33_34_breach_notification_assess(late_with_unjustified_reasons_referral, breach_notification_verdict(ineligible, _)).
test(unlikely_risk_is_not_eligible, fail) :-
    gdpr_arts33_34_breach_notification_assess(unlikely_risk_ineligible, breach_notification_verdict(eligible, _)).
test(obligation_is_never_empty, fail) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision)], []).
test(duplicate_key_refuses_an_unbound_key, fail) :-
    duplicate_key(_).
test(provenance_refuses_an_unbound_clause, fail) :-
    provenance(_, [cite(eu_reg_2016_679_art_33_1)]).
test(provenance_refuses_citations_that_are_not_a_list, fail) :-
    provenance(risk_verdict, cite(eu_reg_2016_679_art_33_1)).

cp_test_names([every_subject_resolves_to_its_expected_verdict, every_subject_has_an_expected_verdict, every_subject_has_a_non_empty_checklist, every_subject_is_resolvable, every_near_miss_control_gets_a_different_verdict, timely_notification_is_eligible, one_hour_late_without_reasons_is_not_met, late_with_unjustified_reasons_refers, unlikely_risk_is_ineligible_whatever_the_hours, the_final_atoms_are_in_the_vocabulary, the_decision_term_carries_the_verdict, the_timely_checklist_is_met_throughout, the_late_checklist_marks_the_period_unmet, the_verdict_has_one_solution_at_the_boundary, a_fractional_hours_elapsed_is_an_input_problem, profile_problems_come_before_argument_problems, a_duplicated_key_refuses_the_verdict, what_if_the_notification_were_unduly_delayed, what_if_one_more_hour_had_begun, obligation_reading_six_example, obligation_without_disproportionate_effort_communicates, obligation_protection_measures_exempt, obligation_authority_requires_communication, obligation_authority_decided_a_condition, obligation_of_the_processor, obligation_without_party_role, obligation_unsure_risk_refers, obligation_refuses_contradictory_inputs, deadline_crosses_a_month_end, deadline_on_a_saturday_is_not_shifted, deadline_crosses_a_leap_day, deadline_refuses_a_day_that_does_not_exist, deadline_has_one_solution, period_ends_at_the_hour_after_awareness, period_ends_at_the_end_of_the_day, period_end_refuses_hour_twenty_four, notification_content_missing_nature_is_not_met, notification_content_may_follow_in_phases, notification_content_unsure_phases_refers, notification_content_all_met, communication_all_met, communication_unsure_delay_refers, communication_missing_contact_point_is_not_met, the_input_check_accepts_an_empty_profile, the_input_check_refuses_the_reasons_pair, the_input_check_names_an_unknown_key, the_input_check_names_a_duplicate_key_once, the_schema_lists_the_twenty_five_keys, duplicate_key_builds_over_a_key_atom, provenance_builds_over_a_clause_and_citations]).
cp_test_fail_names([timely_notification_is_not_ineligible, one_hour_late_without_reasons_is_not_eligible, late_is_never_ineligible, unlikely_risk_is_not_eligible, obligation_is_never_empty, duplicate_key_refuses_an_unbound_key, provenance_refuses_an_unbound_clause, provenance_refuses_citations_that_are_not_a_list]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
