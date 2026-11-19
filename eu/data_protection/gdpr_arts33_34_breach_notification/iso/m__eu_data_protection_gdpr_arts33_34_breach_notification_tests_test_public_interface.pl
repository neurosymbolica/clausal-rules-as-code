% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [decide_breach_notification_verdict/2, breach_notification_verdict_status/2, breach_notification_verdict_checklist/2, breach_notification_verdict_decision_resolvable/1, breach_notification_verdict_status_values/1, breach_notification_verdict/4, notification_obligation/2, authority_notification_deadline/3, authority_notification_period_end/3, authority_notification_content_check/2, data_subject_communication_check/2, provenance/2, duplicate_key/1, no_communication_required/1]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_queries, [gdpr_arts33_34_breach_notification_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_fixtures, [gdpr_arts33_34_breach_notification_subject/1, gdpr_arts33_34_breach_notification_profile_for/2, gdpr_arts33_34_breach_notification_assess/2]).

expected_verdict(timely_notification_eligible, eligible).
expected_verdict(timely_notification_unduly_delayed, notification_requirement_not_met(without_undue_delay)).
expected_verdict(seventy_two_hours_in_time, eligible).
expected_verdict(seventy_three_hours_without_reasons, notification_requirement_not_met(reasons_for_delay)).
expected_verdict(seventy_three_hours_with_justified_reasons, eligible).
expected_verdict(seventy_three_hours_with_unjustified_reasons, needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - 73, breach_unlikely_to_result_in_risk - false, delay_justified_by_reasons - false])])).
expected_verdict(unlikely_risk_ineligible, ineligible).
expected_verdict(likely_risk_eligible, eligible).
expected_verdict(unlikely_risk_ineligible_after_the_period, ineligible).
expected_verdict(unsure_risk_referred, needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure])])).
expected_verdict(unsure_risk_missing_undue_delay, indeterminate([notification_made_without_undue_delay])).
expected_verdict(missing_risk_judgement, indeterminate([breach_unlikely_to_result_in_risk])).
expected_verdict(consistent_risk_inputs, ineligible).
expected_verdict(contradictory_risk_inputs, input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])])).
expected_verdict(zero_hours_elapsed, eligible).
expected_verdict(negative_hours_elapsed, input_problems([wrong_type(hours_elapsed)])).
expected_verdict(public_communication_substitute, eligible).
expected_verdict(direct_communication_owed, eligible).
expected_verdict(processor_notifies_controller, eligible).
expected_verdict(authority_required_communication, ineligible).
expected_verdict(authority_no_decision_unlikely_risk, ineligible).

verdict_near_miss(timely_notification_eligible, timely_notification_unduly_delayed).
verdict_near_miss(seventy_two_hours_in_time, seventy_three_hours_without_reasons).
verdict_near_miss(seventy_three_hours_with_justified_reasons, seventy_three_hours_with_unjustified_reasons).
verdict_near_miss(unlikely_risk_ineligible, likely_risk_eligible).
verdict_near_miss(unsure_risk_referred, unsure_risk_missing_undue_delay).
verdict_near_miss(likely_risk_eligible, missing_risk_judgement).
verdict_near_miss(consistent_risk_inputs, contradictory_risk_inputs).
verdict_near_miss(zero_hours_elapsed, negative_hours_elapsed).
verdict_near_miss(unlikely_risk_ineligible_after_the_period, seventy_three_hours_without_reasons).

subject_has_expected_verdict(Subject) :-
    expected_verdict(Subject, Expected),
    gdpr_arts33_34_breach_notification_profile_for(Subject, Request),
    findall(Status, breach_notification_verdict_status(Request, Status), Statuses),
    Statuses == [Expected].

subject_has_a_cited_checklist(Subject) :-
    gdpr_arts33_34_breach_notification_profile_for(Subject, Request),
    breach_notification_verdict_checklist(Request, [FirstItem|OtherItems]),
    maplist(cited_item, [FirstItem|OtherItems]).

cited_item(item(_, _, cite(eu_reg_2016_679_art_33_1))).

subject_is_resolvable_once(Subject) :-
    gdpr_arts33_34_breach_notification_profile_for(Subject, Request),
    breach_notification_verdict_decision_resolvable(Request),
    findall(Result, gdpr_arts33_34_breach_notification_assess(Subject, Result), Results),
    length(Results, 1).

near_miss_differs(Positive - Control) :-
    gdpr_arts33_34_breach_notification_profile_for(Positive, PositiveRequest),
    breach_notification_verdict_status(PositiveRequest, PositiveStatus),
    gdpr_arts33_34_breach_notification_profile_for(Control, ControlRequest),
    breach_notification_verdict_status(ControlRequest, ControlStatus),
    dif(PositiveStatus, ControlStatus).

fixture_profile(Subject, Profile) :-
    gdpr_arts33_34_breach_notification_profile_for(Subject, breach_notification_request(Profile, _)).

test(every_subject_resolves_to_its_expected_verdict) :-
    findall(Subject, gdpr_arts33_34_breach_notification_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(subject_has_expected_verdict, Subjects).
test(every_expectation_names_a_registered_subject) :-
    findall(Subject, gdpr_arts33_34_breach_notification_subject(Subject), Subjects),
    findall(Subject, expected_verdict(Subject, _), ExpectedSubjects),
    clausal_msort(Subjects, SortedSubjects),
    clausal_msort(ExpectedSubjects, SortedExpected),
    SortedSubjects == SortedExpected.
test(every_subject_has_a_non_empty_cited_checklist) :-
    findall(Subject, gdpr_arts33_34_breach_notification_subject(Subject), Subjects),
    maplist(subject_has_a_cited_checklist, Subjects).
test(every_subject_resolves_exactly_once) :-
    findall(Subject, gdpr_arts33_34_breach_notification_subject(Subject), Subjects),
    maplist(subject_is_resolvable_once, Subjects).
test(every_near_miss_control_gets_a_different_verdict) :-
    findall(Positive - Control, verdict_near_miss(Positive, Control), Pairs),
    Pairs = [_|_],
    maplist(near_miss_differs, Pairs).
test(timely_notification_is_eligible) :-
    gdpr_arts33_34_breach_notification_assess(timely_notification_eligible, breach_notification_verdict_verdict(eligible, [cite(eu_reg_2016_679_art_33_1)])).
test(unduly_delayed_notification_is_not_met) :-
    gdpr_arts33_34_breach_notification_assess(timely_notification_unduly_delayed, breach_notification_verdict_verdict(notification_requirement_not_met(without_undue_delay), [cite(eu_reg_2016_679_art_33_1)])).
test(the_72nd_hour_is_eligible) :-
    fixture_profile(seventy_two_hours_in_time, Profile),
    breach_notification_verdict(Profile, 72, eligible, [cite(eu_reg_2016_679_art_33_1)]).
test(the_73rd_hour_without_reasons_is_not_met) :-
    fixture_profile(seventy_three_hours_without_reasons, Profile),
    breach_notification_verdict(Profile, 73, notification_requirement_not_met(reasons_for_delay), [cite(eu_reg_2016_679_art_33_1)]).
test(justified_reasons_after_the_period_are_eligible) :-
    gdpr_arts33_34_breach_notification_assess(seventy_three_hours_with_justified_reasons, breach_notification_verdict_verdict(eligible, [cite(eu_reg_2016_679_art_33_1)])).
test(unjustified_reasons_refer_with_the_timing_context) :-
    gdpr_arts33_34_breach_notification_assess(seventy_three_hours_with_unjustified_reasons, breach_notification_verdict_verdict(Status, Citations)),
    Status == needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - 73, breach_unlikely_to_result_in_risk - false, delay_justified_by_reasons - false])]),
    Citations == [].
test(unlikely_risk_is_ineligible) :-
    gdpr_arts33_34_breach_notification_assess(unlikely_risk_ineligible, breach_notification_verdict_verdict(ineligible, [cite(eu_reg_2016_679_art_33_1)])).
test(likely_risk_is_eligible) :-
    gdpr_arts33_34_breach_notification_assess(likely_risk_eligible, breach_notification_verdict_verdict(eligible, _)).
test(unlikely_risk_is_ineligible_after_the_period) :-
    gdpr_arts33_34_breach_notification_assess(unlikely_risk_ineligible_after_the_period, breach_notification_verdict_verdict(ineligible, [cite(eu_reg_2016_679_art_33_1)])).
test(an_unsure_risk_refers_without_citations) :-
    gdpr_arts33_34_breach_notification_assess(unsure_risk_referred, breach_notification_verdict_verdict(Status, Citations)),
    Status == needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure])]),
    Citations == [].
test(an_unsure_risk_beside_an_absent_timing_key_names_it) :-
    gdpr_arts33_34_breach_notification_assess(unsure_risk_missing_undue_delay, breach_notification_verdict_verdict(indeterminate([notification_made_without_undue_delay]), [])).
test(an_absent_risk_judgement_is_indeterminate) :-
    gdpr_arts33_34_breach_notification_assess(missing_risk_judgement, breach_notification_verdict_verdict(indeterminate([breach_unlikely_to_result_in_risk]), [])).
test(consistent_risk_inputs_are_ineligible) :-
    gdpr_arts33_34_breach_notification_assess(consistent_risk_inputs, breach_notification_verdict_verdict(ineligible, _)).
test(contradictory_risk_inputs_are_refused) :-
    gdpr_arts33_34_breach_notification_assess(contradictory_risk_inputs, breach_notification_verdict_verdict(input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])]), [])).
test(zero_hours_elapsed_is_eligible) :-
    gdpr_arts33_34_breach_notification_assess(zero_hours_elapsed, breach_notification_verdict_verdict(eligible, _)).
test(negative_hours_elapsed_is_an_input_problem) :-
    gdpr_arts33_34_breach_notification_assess(negative_hours_elapsed, breach_notification_verdict_verdict(input_problems([wrong_type(hours_elapsed)]), [])).
test(final_statuses_are_in_the_status_vocabulary) :-
    breach_notification_verdict_status_values(StatusValues),
    gdpr_arts33_34_breach_notification_profile_for(likely_risk_eligible, EligibleRequest),
    breach_notification_verdict_status(EligibleRequest, EligibleStatus),
    member(EligibleStatus, StatusValues),
    gdpr_arts33_34_breach_notification_profile_for(unlikely_risk_ineligible, IneligibleRequest),
    breach_notification_verdict_status(IneligibleRequest, IneligibleStatus),
    member(IneligibleStatus, StatusValues).
test(decide_wraps_the_verdict_and_its_citations) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_notification_eligible, Request),
    decide_breach_notification_verdict(Request, breach_notification_verdict_verdict(eligible, [cite(eu_reg_2016_679_art_33_1)])).
test(the_timely_checklist_is_all_met) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_notification_eligible, Request),
    breach_notification_verdict_checklist(Request, Items),
    Items == [item(notification_duty_arises, met, cite(eu_reg_2016_679_art_33_1)), item(notified_within_the_period, met, cite(eu_reg_2016_679_art_33_1)), item(timing_requirement_met, met, cite(eu_reg_2016_679_art_33_1))].
test(the_late_checklist_marks_the_period_unmet) :-
    gdpr_arts33_34_breach_notification_profile_for(seventy_three_hours_without_reasons, Request),
    breach_notification_verdict_checklist(Request, [_, item(notified_within_the_period, unmet(notified_after_the_period), cite(eu_reg_2016_679_art_33_1)), item(timing_requirement_met, unmet(reasons_for_delay), cite(eu_reg_2016_679_art_33_1))]).
test(the_order_example_owes_the_public_communication) :-
    fixture_profile(public_communication_substitute, Profile),
    findall(Obligation, notification_obligation(Profile, Obligation), Obligations),
    Obligations == [[notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), public_communication_or_similar_measure(cite(eu_reg_2016_679_art_34_3_c))]].
test(without_disproportionate_effort_the_communication_is_owed) :-
    fixture_profile(direct_communication_owed, Profile),
    notification_obligation(Profile, Obligation),
    Obligation == [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), communicate_to_data_subject(cite(eu_reg_2016_679_art_34_1))].
test(the_processor_notifies_the_controller_only) :-
    fixture_profile(processor_notifies_controller, Profile),
    notification_obligation(Profile, Obligation),
    Obligation == [notify_controller(cite(eu_reg_2016_679_art_33_2))].
test(the_authority_requirement_governs_the_article_34_term) :-
    fixture_profile(authority_required_communication, Profile),
    notification_obligation(Profile, Obligation),
    Obligation == [no_notification_required(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), communicate_to_data_subject(cite(eu_reg_2016_679_art_34_4))].
test(no_decision_with_unlikely_risk_owes_documentation_only) :-
    fixture_profile(authority_no_decision_unlikely_risk, Profile),
    notification_obligation(Profile, Obligation),
    Obligation == [no_notification_required(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5))].
test(an_absent_party_role_is_indeterminate) :-
    fixture_profile(timely_notification_eligible, Profile),
    notification_obligation(Profile, indeterminate([party_role])).
test(a_contradictory_profile_is_refused_by_the_obligation) :-
    fixture_profile(contradictory_risk_inputs, Profile),
    notification_obligation(Profile, input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])])).
test(a_true_point_a_gives_no_communication_required) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, true)], Obligation),
    Obligation == [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), no_communication_required(cite(eu_reg_2016_679_art_34_3_a))],
    Obligation = [_, _, no_communication_required(Citation)],
    no_communication_required(Citation).
test(a_decided_point_b_gives_no_communication_required_under_34_4) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(supervisory_authority_decision_on_communication, decided_point_b_condition_met)], Obligation),
    Obligation == [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), no_communication_required(cite(eu_reg_2016_679_art_34_4))],
    no_communication_required(cite(eu_reg_2016_679_art_34_4)).
test(the_deadline_crosses_a_month_end) :-
    findall(Deadline - Hours, authority_notification_deadline(date(2025, 10, 31), Deadline, Hours), Answers),
    Answers = [date(Year, Month, Day) - Hours],
    Year == 2025,
    Month == 11,
    Day == 3,
    Hours == 72.
test(the_deadline_reaches_and_passes_a_leap_day) :-
    authority_notification_deadline(date(2032, 2, 26), date(LeapYear, LeapMonth, LeapDay), _),
    LeapYear == 2032,
    LeapMonth == 2,
    LeapDay == 29,
    authority_notification_deadline(date(2032, 2, 27), date(NextYear, NextMonth, NextDay), _),
    NextYear == 2032,
    NextMonth == 3,
    NextDay == 1.
test(the_deadline_crosses_a_year_end) :-
    authority_notification_deadline(date(2025, 12, 30), date(Year, Month, Day), _),
    Year == 2026,
    Month == 1,
    Day == 2.
test(a_day_that_does_not_exist_is_wrong_type) :-
    authority_notification_deadline(date(2031, 2, 29), Deadline, Hours),
    Deadline == input_problems([wrong_type(awareness_date)]),
    Hours == 72.
test(the_period_ends_at_the_next_full_hour) :-
    authority_notification_period_end(date(2025, 10, 31), 10, PeriodEnd),
    PeriodEnd = period_end(date(Year, Month, Day), EndHour),
    Year == 2025,
    Month == 11,
    Day == 3,
    EndHour == 11.
test(awareness_in_hour_23_ends_at_the_end_of_the_day) :-
    authority_notification_period_end(date(2025, 12, 30), 23, period_end(date(Year, Month, Day), EndHour)),
    Year == 2026,
    Month == 1,
    Day == 2,
    EndHour == 24.
test(awareness_in_hour_0_ends_at_one) :-
    authority_notification_period_end(date(2026, 3, 28), 0, period_end(_, EndHour)),
    EndHour == 1.
test(hour_24_is_wrong_type) :-
    authority_notification_period_end(date(2026, 3, 28), 24, PeriodEnd),
    PeriodEnd == input_problems([wrong_type(awareness_hour)]).
test(a_complete_notification_meets_every_requirement) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, true), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true)], all_requirements_met).
test(a_notification_without_contact_point_is_not_met) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, false), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, false)], Result),
    Result == requirements_not_met([contact_point]).
test(a_missing_contact_point_may_follow_in_phases) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, false), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, true)], Result),
    Result == information_to_follow_in_phases([contact_point]).
test(a_complete_communication_meets_every_requirement) :-
    data_subject_communication_check([attribute(communication_made_without_undue_delay, true), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], all_requirements_met).
test(a_communication_without_contact_point_is_not_met) :-
    data_subject_communication_check([attribute(communication_made_without_undue_delay, true), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, false), attribute(communication_describes_likely_consequences, true), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], Result),
    Result == requirements_not_met([contact_point]).
test(a_fixture_profile_has_no_input_problem) :-
    fixture_profile(public_communication_substitute, Profile),
    gdpr_arts33_34_breach_notification_input_problems(Profile, []).
test(the_contradictory_fixture_has_its_input_problem) :-
    fixture_profile(contradictory_risk_inputs, Profile),
    gdpr_arts33_34_breach_notification_input_problems(Profile, Problems),
    Problems == [contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])].
test(a_repeated_key_is_a_duplicate_key_problem) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(party_role, controller), attribute(party_role, controller)], Problems),
    Problems == [duplicate_key(party_role)],
    Problems = [duplicate_key(Key)],
    duplicate_key(Key).
test(a_duplicate_key_refuses_the_obligation) :-
    notification_obligation([attribute(party_role, controller), attribute(party_role, processor)], Obligation),
    Obligation == input_problems([duplicate_key(party_role)]).
test(the_provenance_constructor_holds_a_clause_and_its_citations) :-
    provenance(risk_route, [cite(eu_reg_2016_679_art_33_1)]).
test(what_if_one_hour_later_crosses_the_boundary) :-
    gdpr_arts33_34_breach_notification_profile_for(seventy_two_hours_in_time, Request),
    gdpr_arts33_34_breach_notification_what_if(Request, hours_elapsed, 73, Status),
    Status == notification_requirement_not_met(reasons_for_delay).
test(what_if_a_likely_risk_flips_ineligible_to_eligible) :-
    gdpr_arts33_34_breach_notification_profile_for(unlikely_risk_ineligible, Request),
    gdpr_arts33_34_breach_notification_what_if(Request, breach_unlikely_to_result_in_risk, false, Status),
    Status == eligible.

test(unduly_delayed_notification_is_not_eligible, fail) :-
    gdpr_arts33_34_breach_notification_assess(timely_notification_unduly_delayed, breach_notification_verdict_verdict(eligible, _)).
test(the_73rd_hour_without_reasons_is_not_eligible, fail) :-
    fixture_profile(seventy_three_hours_without_reasons, Profile),
    breach_notification_verdict(Profile, 73, eligible, _).
test(unjustified_reasons_are_never_ineligible, fail) :-
    gdpr_arts33_34_breach_notification_assess(seventy_three_hours_with_unjustified_reasons, breach_notification_verdict_verdict(ineligible, _)).
test(unlikely_risk_is_not_eligible, fail) :-
    gdpr_arts33_34_breach_notification_assess(unlikely_risk_ineligible, breach_notification_verdict_verdict(eligible, _)).
test(likely_risk_is_not_ineligible, fail) :-
    gdpr_arts33_34_breach_notification_assess(likely_risk_eligible, breach_notification_verdict_verdict(ineligible, _)).
test(contradictory_risk_inputs_are_not_ineligible, fail) :-
    gdpr_arts33_34_breach_notification_assess(contradictory_risk_inputs, breach_notification_verdict_verdict(ineligible, _)).
test(negative_hours_elapsed_is_not_eligible, fail) :-
    gdpr_arts33_34_breach_notification_assess(negative_hours_elapsed, breach_notification_verdict_verdict(eligible, _)).
test(without_disproportionate_effort_no_public_communication, fail) :-
    fixture_profile(direct_communication_owed, Profile),
    notification_obligation(Profile, Obligation),
    member(public_communication_or_similar_measure(_), Obligation).
test(no_communication_required_needs_a_cite_term, fail) :-
    no_communication_required(eu_reg_2016_679_art_34_4).
test(a_false_point_c_is_not_no_communication_required, fail) :-
    fixture_profile(direct_communication_owed, Profile),
    notification_obligation(Profile, Obligation),
    member(no_communication_required(_), Obligation).
test(duplicate_key_needs_an_atom_key, fail) :-
    duplicate_key([party_role]).
test(a_single_key_is_not_a_duplicate_key, fail) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(party_role, controller)], [duplicate_key(_)|_]).
test(the_provenance_constructor_refuses_a_non_list_of_citations, fail) :-
    provenance(risk_route, cite(eu_reg_2016_679_art_33_1)).
test(no_answer_of_this_order_carries_provenance, fail) :-
    gdpr_arts33_34_breach_notification_assess(unsure_risk_referred, breach_notification_verdict_verdict(needs_legal_review(_, Context), _)),
    member(provenance(_, _), Context).

cp_test_names([every_subject_resolves_to_its_expected_verdict, every_expectation_names_a_registered_subject, every_subject_has_a_non_empty_cited_checklist, every_subject_resolves_exactly_once, every_near_miss_control_gets_a_different_verdict, timely_notification_is_eligible, unduly_delayed_notification_is_not_met, the_72nd_hour_is_eligible, the_73rd_hour_without_reasons_is_not_met, justified_reasons_after_the_period_are_eligible, unjustified_reasons_refer_with_the_timing_context, unlikely_risk_is_ineligible, likely_risk_is_eligible, unlikely_risk_is_ineligible_after_the_period, an_unsure_risk_refers_without_citations, an_unsure_risk_beside_an_absent_timing_key_names_it, an_absent_risk_judgement_is_indeterminate, consistent_risk_inputs_are_ineligible, contradictory_risk_inputs_are_refused, zero_hours_elapsed_is_eligible, negative_hours_elapsed_is_an_input_problem, final_statuses_are_in_the_status_vocabulary, decide_wraps_the_verdict_and_its_citations, the_timely_checklist_is_all_met, the_late_checklist_marks_the_period_unmet, the_order_example_owes_the_public_communication, without_disproportionate_effort_the_communication_is_owed, the_processor_notifies_the_controller_only, the_authority_requirement_governs_the_article_34_term, no_decision_with_unlikely_risk_owes_documentation_only, an_absent_party_role_is_indeterminate, a_contradictory_profile_is_refused_by_the_obligation, a_true_point_a_gives_no_communication_required, a_decided_point_b_gives_no_communication_required_under_34_4, the_deadline_crosses_a_month_end, the_deadline_reaches_and_passes_a_leap_day, the_deadline_crosses_a_year_end, a_day_that_does_not_exist_is_wrong_type, the_period_ends_at_the_next_full_hour, awareness_in_hour_23_ends_at_the_end_of_the_day, awareness_in_hour_0_ends_at_one, hour_24_is_wrong_type, a_complete_notification_meets_every_requirement, a_notification_without_contact_point_is_not_met, a_missing_contact_point_may_follow_in_phases, a_complete_communication_meets_every_requirement, a_communication_without_contact_point_is_not_met, a_fixture_profile_has_no_input_problem, the_contradictory_fixture_has_its_input_problem, a_repeated_key_is_a_duplicate_key_problem, a_duplicate_key_refuses_the_obligation, the_provenance_constructor_holds_a_clause_and_its_citations, what_if_one_hour_later_crosses_the_boundary, what_if_a_likely_risk_flips_ineligible_to_eligible]).
cp_test_fail_names([unduly_delayed_notification_is_not_eligible, the_73rd_hour_without_reasons_is_not_eligible, unjustified_reasons_are_never_ineligible, unlikely_risk_is_not_eligible, likely_risk_is_not_ineligible, contradictory_risk_inputs_are_not_ineligible, negative_hours_elapsed_is_not_eligible, without_disproportionate_effort_no_public_communication, no_communication_required_needs_a_cite_term, a_false_point_c_is_not_no_communication_required, duplicate_key_needs_an_atom_key, a_single_key_is_not_a_duplicate_key, the_provenance_constructor_refuses_a_non_list_of_citations, no_answer_of_this_order_carries_provenance]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
