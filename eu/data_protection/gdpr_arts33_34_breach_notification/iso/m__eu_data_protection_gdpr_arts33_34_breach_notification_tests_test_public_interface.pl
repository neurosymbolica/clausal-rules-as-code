% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_breach_notification_verdict, [decide_breach_notification_verdict/2, breach_notification_verdict_status/2, breach_notification_verdict_checklist/2, breach_notification_verdict_decision_resolvable/1, breach_notification_verdict_status_values/1, breach_notification_verdict/4, notification_obligation/2, authority_notification_deadline/3, authority_notification_period_end/3, authority_notification_content_check/2, data_subject_communication_check/2, no_notification_required/1, provenance/2, duplicate_key/1]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_queries, [gdpr_arts33_34_breach_notification_profile_keys/1, gdpr_arts33_34_breach_notification_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_arts33_34_breach_notification_fixtures, [gdpr_arts33_34_breach_notification_subject/1, gdpr_arts33_34_breach_notification_profile_for/2, gdpr_arts33_34_breach_notification_assess/2]).

test(timely_at_the_period_end_is_eligible) :-
    gdpr_arts33_34_breach_notification_assess(timely_at_the_period_end, Result),
    Result == breach_notification_verdict_verdict(eligible, [cite(eu_reg_2016_679_art_33_1)]).
test(one_hour_past_without_reasons_is_not_met) :-
    gdpr_arts33_34_breach_notification_assess(late_one_hour_past_without_reasons, Result),
    Result == breach_notification_verdict_verdict(notification_requirement_not_met(reasons_for_delay), [cite(eu_reg_2016_679_art_33_1)]).
test(an_unlikely_risk_is_ineligible) :-
    gdpr_arts33_34_breach_notification_assess(unlikely_risk_notified_late, Result),
    Result == breach_notification_verdict_verdict(ineligible, [cite(eu_reg_2016_679_art_33_1)]).
test(justified_reasons_make_a_late_notification_eligible) :-
    gdpr_arts33_34_breach_notification_assess(risk_notified_late_with_justified_reasons, Result),
    Result == breach_notification_verdict_verdict(eligible, [cite(eu_reg_2016_679_art_33_1)]).
test(unjustified_reasons_refer) :-
    gdpr_arts33_34_breach_notification_assess(late_with_unjustified_reasons, Result),
    Result == breach_notification_verdict_verdict(needs_legal_review(open_textured(delay_justified_by_reasons, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([hours_elapsed - 100, breach_unlikely_to_result_in_risk - false, delay_justified_by_reasons - false])]), []).
test(inside_the_period_without_undue_delay_is_eligible) :-
    gdpr_arts33_34_breach_notification_assess(notified_inside_the_period_without_undue_delay, Result),
    Result == breach_notification_verdict_verdict(eligible, [cite(eu_reg_2016_679_art_33_1)]).
test(inside_the_period_with_undue_delay_is_not_met) :-
    gdpr_arts33_34_breach_notification_assess(notified_inside_the_period_with_undue_delay, Result),
    Result == breach_notification_verdict_verdict(notification_requirement_not_met(without_undue_delay), [cite(eu_reg_2016_679_art_33_1)]).
test(a_missing_risk_judgement_is_indeterminate) :-
    gdpr_arts33_34_breach_notification_assess(risk_judgement_missing, Result),
    Result == breach_notification_verdict_verdict(indeterminate([breach_unlikely_to_result_in_risk]), []).
test(an_unsure_risk_judgement_refers) :-
    gdpr_arts33_34_breach_notification_assess(risk_judgement_unsure, Result),
    Result == breach_notification_verdict_verdict(needs_legal_review(open_textured(breach_unlikely_to_result_in_risk, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([breach_unlikely_to_result_in_risk - unsure])]), []).
test(a_negative_hours_elapsed_is_an_input_problem) :-
    gdpr_arts33_34_breach_notification_assess(negative_hours_elapsed, Result),
    Result == breach_notification_verdict_verdict(input_problems([wrong_type(hours_elapsed)]), []).
test(contradictory_risk_judgements_are_refused) :-
    gdpr_arts33_34_breach_notification_assess(contradictory_risk_judgements, Result),
    Result == breach_notification_verdict_verdict(input_problems([contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])]), []).
test(every_subject_has_exactly_one_verdict) :-
    findall(Subject, gdpr_arts33_34_breach_notification_subject(Subject), Subjects),
    length(Subjects, 11),
    findall(Subject - Result, (member(Subject, Subjects), gdpr_arts33_34_breach_notification_assess(Subject, Result)), Answers),
    length(Answers, 11).
test(the_status_values_name_the_two_bare_verdicts) :-
    breach_notification_verdict_status_values(Values),
    Values == [eligible, ineligible].
test(the_status_is_the_verdict_alone) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_at_the_period_end, Profile),
    breach_notification_verdict_status(case(Profile, 72), Status),
    Status == eligible.
test(the_checklist_is_cited_and_met) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_at_the_period_end, Profile),
    breach_notification_verdict_decision_resolvable(case(Profile, 72)),
    breach_notification_verdict_checklist(case(Profile, 72), Items),
    Items == [item(article_33_1_notification, met, cite(eu_reg_2016_679_art_33_1))].
test(the_near_miss_checklist_is_unmet) :-
    gdpr_arts33_34_breach_notification_profile_for(late_one_hour_past_without_reasons, Profile),
    breach_notification_verdict_checklist(case(Profile, 73), Items),
    Items == [item(article_33_1_notification, unmet(reasons_for_delay), cite(eu_reg_2016_679_art_33_1))].
test(the_decision_wraps_the_verdict) :-
    gdpr_arts33_34_breach_notification_profile_for(notified_inside_the_period_with_undue_delay, Profile),
    decide_breach_notification_verdict(case(Profile, 10), Decision),
    Decision == breach_notification_verdict_verdict(notification_requirement_not_met(without_undue_delay), [cite(eu_reg_2016_679_art_33_1)]).
test(what_if_one_hour_later_needs_the_reasons) :-
    gdpr_arts33_34_breach_notification_profile_for(notified_inside_the_period_without_undue_delay, Profile),
    gdpr_arts33_34_breach_notification_what_if(case(Profile, 72), hours_elapsed, 73, Status),
    Status == indeterminate([notification_accompanied_by_reasons_for_delay]).
test(what_if_the_risk_is_unlikely) :-
    gdpr_arts33_34_breach_notification_profile_for(notified_inside_the_period_without_undue_delay, Profile),
    gdpr_arts33_34_breach_notification_what_if(case(Profile, 10), breach_unlikely_to_result_in_risk, true, Status),
    Status == ineligible.
test(seventy_two_hours_is_in_time) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 72, Verdict, _),
    Verdict == eligible.
test(seventy_three_hours_is_late) :-
    breach_notification_verdict([attribute(breach_unlikely_to_result_in_risk, false), attribute(notification_made_without_undue_delay, true)], 73, Verdict, Citations),
    Verdict == indeterminate([notification_accompanied_by_reasons_for_delay]),
    Citations == [].
test(a_non_integer_hours_elapsed_is_an_input_problem) :-
    breach_notification_verdict([], late, Verdict, Citations),
    Verdict == input_problems([wrong_type(hours_elapsed)]),
    Citations == [].
test(a_processor_notifies_the_controller) :-
    notification_obligation([attribute(party_role, processor)], Obligation),
    Obligation == [notify_controller(cite(eu_reg_2016_679_art_33_2))].
test(an_absent_role_is_not_guessed) :-
    notification_obligation([attribute(breach_unlikely_to_result_in_risk, false)], Obligation),
    Obligation == indeterminate([party_role]).
test(a_high_risk_controller_communicates_with_the_default_shown) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(appropriate_protection_measures_applied_to_affected_data, false), attribute(subsequent_measures_ensure_high_risk_no_longer_likely, false), attribute(communication_would_involve_disproportionate_effort, false)], Obligation),
    Obligation == [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), communicate_to_data_subject(cite(eu_reg_2016_679_art_34_1)), inputs_relied_on([supervisory_authority_decision_on_communication - no_decision])].
test(a_stated_no_decision_is_not_shown) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, false), attribute(supervisory_authority_decision_on_communication, no_decision)], Obligation),
    Obligation == [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), no_communication_required(cite(eu_reg_2016_679_art_34_1))].
test(encryption_relieves_the_communication) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false), attribute(breach_likely_to_result_in_high_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision), attribute(appropriate_protection_measures_applied_to_affected_data, true)], Obligation),
    Obligation == [notify_supervisory_authority(cite(eu_reg_2016_679_art_33_1)), document_breach(cite(eu_reg_2016_679_art_33_5)), no_communication_required(cite(eu_reg_2016_679_art_34_3_a))].
test(an_absent_high_risk_judgement_is_named) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, false)], Obligation),
    Obligation == indeterminate([breach_likely_to_result_in_high_risk]).
test(an_obligation_is_one_list) :-
    findall(Obligation, notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true)], Obligation), Obligations),
    length(Obligations, 1).
test(an_unlikely_risk_needs_no_notification) :-
    notification_obligation([attribute(party_role, controller), attribute(breach_unlikely_to_result_in_risk, true), attribute(supervisory_authority_decision_on_communication, no_decision)], Obligation),
    Obligation = [First|_],
    First == no_notification_required(cite(eu_reg_2016_679_art_33_1)),
    no_notification_required(cite(eu_reg_2016_679_art_33_1)).
test(the_no_notification_constructor_holds) :-
    no_notification_required(cite(eu_reg_2016_679_art_33_1)).
test(the_provenance_constructor_holds) :-
    provenance(article_33_1_risk_threshold, [cite(eu_reg_2016_679_art_33_1)]).
test(the_duplicate_key_constructor_holds) :-
    duplicate_key(party_role).
test(a_repeated_key_is_a_duplicate_key) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(party_role, controller), attribute(party_role, controller)], Problems),
    Problems == [duplicate_key(party_role)],
    Problems = [duplicate_key(Key)],
    duplicate_key(Key).
test(the_deadline_crosses_a_month_end) :-
    authority_notification_deadline(date(2025, 10, 31), Deadline, Hours),
    Deadline = date(2025, 11, 3),
    Hours =:= 72.
test(the_deadline_reaches_the_leap_day) :-
    authority_notification_deadline(date(2032, 2, 26), Deadline, _),
    Deadline = date(2032, 2, 29).
test(the_deadline_passes_the_leap_day) :-
    authority_notification_deadline(date(2032, 2, 27), Deadline, _),
    Deadline = date(2032, 3, 1).
test(the_last_day_of_the_range_is_answered) :-
    authority_notification_deadline(date(9999, 12, 28), Deadline, _),
    Deadline = date(9999, 12, 31).
test(one_day_past_the_range_is_wrong_type) :-
    authority_notification_deadline(date(9999, 12, 29), Deadline, Hours),
    Deadline == input_problems([wrong_type(awareness_date)]),
    Hours =:= 72.
test(the_period_ends_at_the_next_full_hour) :-
    authority_notification_period_end(date(2025, 10, 31), 10, PeriodEnd),
    PeriodEnd = period_end(date(2025, 11, 3), EndHour),
    EndHour =:= 11.
test(the_period_ends_at_the_end_of_the_day_across_the_year) :-
    authority_notification_period_end(date(2025, 12, 30), 23, PeriodEnd),
    PeriodEnd = period_end(date(2026, 1, 2), EndHour),
    EndHour =:= 24.
test(hour_twenty_four_is_wrong_type) :-
    authority_notification_period_end(date(2025, 12, 30), 24, PeriodEnd),
    PeriodEnd == input_problems([wrong_type(awareness_hour)]).
test(a_notification_missing_a_contact_point_is_not_met) :-
    authority_notification_content_check([attribute(notification_describes_nature_of_breach, true), attribute(notification_gives_categories_and_approximate_numbers, true), attribute(notification_gives_contact_point, false), attribute(notification_describes_likely_consequences, true), attribute(notification_describes_measures_taken_or_proposed, true), attribute(notification_describes_mitigation_measures, true), attribute(information_not_possible_to_provide_at_the_same_time, false)], Result),
    Result == requirements_not_met([contact_point]).
test(a_communication_missing_the_consequences_is_not_met) :-
    data_subject_communication_check([attribute(communication_made_without_undue_delay, true), attribute(communication_describes_nature_in_clear_and_plain_language, true), attribute(communication_gives_contact_point, true), attribute(communication_describes_likely_consequences, false), attribute(communication_describes_measures_taken_or_proposed, true), attribute(communication_describes_mitigation_measures, true)], Result),
    Result == requirements_not_met([likely_consequences]).
test(the_input_check_names_an_unknown_key) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(a_fixture_profile_has_no_problem) :-
    gdpr_arts33_34_breach_notification_profile_for(timely_at_the_period_end, Profile),
    gdpr_arts33_34_breach_notification_input_problems(Profile, Problems),
    Problems == [].
test(the_schema_has_twenty_five_keys) :-
    gdpr_arts33_34_breach_notification_profile_keys(Keys),
    length(Keys, 25).

test(timely_at_the_period_end_is_not_late, fail) :-
    gdpr_arts33_34_breach_notification_assess(timely_at_the_period_end, breach_notification_verdict_verdict(notification_requirement_not_met(_), _)).
test(one_hour_past_without_reasons_is_not_eligible, fail) :-
    gdpr_arts33_34_breach_notification_assess(late_one_hour_past_without_reasons, breach_notification_verdict_verdict(eligible, _)).
test(an_unlikely_risk_is_not_eligible, fail) :-
    gdpr_arts33_34_breach_notification_assess(unlikely_risk_notified_late, breach_notification_verdict_verdict(eligible, _)).
test(justified_reasons_are_not_ineligible, fail) :-
    gdpr_arts33_34_breach_notification_assess(risk_notified_late_with_justified_reasons, breach_notification_verdict_verdict(ineligible, _)).
test(unjustified_reasons_are_never_ineligible, fail) :-
    gdpr_arts33_34_breach_notification_assess(late_with_unjustified_reasons, breach_notification_verdict_verdict(ineligible, _)).
test(inside_the_period_with_undue_delay_is_not_ineligible, fail) :-
    gdpr_arts33_34_breach_notification_assess(notified_inside_the_period_with_undue_delay, breach_notification_verdict_verdict(ineligible, _)).
test(an_unsure_risk_judgement_is_not_indeterminate, fail) :-
    gdpr_arts33_34_breach_notification_assess(risk_judgement_unsure, breach_notification_verdict_verdict(indeterminate(_), _)).
test(the_no_notification_constructor_needs_a_citation, fail) :-
    no_notification_required(eu_reg_2016_679_art_33_1).
test(the_provenance_constructor_needs_a_list, fail) :-
    provenance(article_33_1_risk_threshold, cite(eu_reg_2016_679_art_33_1)).
test(the_duplicate_key_constructor_needs_an_atom, fail) :-
    duplicate_key(key(party_role)).

cp_test_names([timely_at_the_period_end_is_eligible, one_hour_past_without_reasons_is_not_met, an_unlikely_risk_is_ineligible, justified_reasons_make_a_late_notification_eligible, unjustified_reasons_refer, inside_the_period_without_undue_delay_is_eligible, inside_the_period_with_undue_delay_is_not_met, a_missing_risk_judgement_is_indeterminate, an_unsure_risk_judgement_refers, a_negative_hours_elapsed_is_an_input_problem, contradictory_risk_judgements_are_refused, every_subject_has_exactly_one_verdict, the_status_values_name_the_two_bare_verdicts, the_status_is_the_verdict_alone, the_checklist_is_cited_and_met, the_near_miss_checklist_is_unmet, the_decision_wraps_the_verdict, what_if_one_hour_later_needs_the_reasons, what_if_the_risk_is_unlikely, seventy_two_hours_is_in_time, seventy_three_hours_is_late, a_non_integer_hours_elapsed_is_an_input_problem, a_processor_notifies_the_controller, an_absent_role_is_not_guessed, a_high_risk_controller_communicates_with_the_default_shown, a_stated_no_decision_is_not_shown, encryption_relieves_the_communication, an_absent_high_risk_judgement_is_named, an_obligation_is_one_list, an_unlikely_risk_needs_no_notification, the_no_notification_constructor_holds, the_provenance_constructor_holds, the_duplicate_key_constructor_holds, a_repeated_key_is_a_duplicate_key, the_deadline_crosses_a_month_end, the_deadline_reaches_the_leap_day, the_deadline_passes_the_leap_day, the_last_day_of_the_range_is_answered, one_day_past_the_range_is_wrong_type, the_period_ends_at_the_next_full_hour, the_period_ends_at_the_end_of_the_day_across_the_year, hour_twenty_four_is_wrong_type, a_notification_missing_a_contact_point_is_not_met, a_communication_missing_the_consequences_is_not_met, the_input_check_names_an_unknown_key, a_fixture_profile_has_no_problem, the_schema_has_twenty_five_keys]).
cp_test_fail_names([timely_at_the_period_end_is_not_late, one_hour_past_without_reasons_is_not_eligible, an_unlikely_risk_is_not_eligible, justified_reasons_are_not_ineligible, unjustified_reasons_are_never_ineligible, inside_the_period_with_undue_delay_is_not_ineligible, an_unsure_risk_judgement_is_not_indeterminate, the_no_notification_constructor_needs_a_citation, the_provenance_constructor_needs_a_list, the_duplicate_key_constructor_needs_an_atom]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
