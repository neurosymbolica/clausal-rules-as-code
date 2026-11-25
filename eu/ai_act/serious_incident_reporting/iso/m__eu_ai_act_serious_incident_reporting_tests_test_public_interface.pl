% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(clausal_hof, [exclude/3]).
:- use_module(m__eu_ai_act_serious_incident_reporting_serious_incident_reporting, [serious_incident_report_duty/4, serious_incident_report_timeliness/5, decide_serious_incident_reporting/2, serious_incident_reporting_status/2, serious_incident_reporting_checklist/2, serious_incident_reporting_decision_resolvable/1, serious_incident_reporting_status_values/1]).
:- use_module(m__eu_ai_act_serious_incident_reporting_fixtures, [serious_incident_reporting_subject/1, serious_incident_reporting_profile_for/2, serious_incident_reporting_assess/2]).

follow_up_list([perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system]).

expected_verdict(Subject, Status, Citations) :-
    findall(Verdict, serious_incident_reporting_assess(Subject, Verdict), Verdicts),
    Verdicts = [serious_incident_reporting_verdict(GotStatus, GotCitations)],
    GotStatus = Status,
    clausal_msort(GotCitations, SortedGot),
    clausal_msort(Citations, SortedExpected),
    SortedGot == SortedExpected.

expected_report(Subject, Recipient, Days, LastDay, Citations) :-
    follow_up_list(FollowUp),
    expected_verdict(Subject, report_due(Recipient, Days, LastDay, FollowUp), Citations).

single_answer(Subject) :-
    findall(Verdict, serious_incident_reporting_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

has_checklist(Subject) :-
    serious_incident_reporting_profile_for(Subject, Case),
    serious_incident_reporting_checklist(Case, [_|_]).

is_resolvable(Subject) :-
    serious_incident_reporting_profile_for(Subject, Case),
    serious_incident_reporting_decision_resolvable(Case).

contract_profile([attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, false), attribute(harm_to_health, death_of_a_person), attribute(critical_infrastructure_disruption, false), attribute(fundamental_rights_obligations_infringed, false), attribute(serious_harm_to_property_or_environment, false), attribute(widespread_infringement, false)]).

contract_profile_with(Extra, Profile) :-
    contract_profile(Base),
    append(Base, Extra, Profile).

contract_profile_without(Key, Profile) :-
    contract_profile(Base),
    exclude(attribute_with_key(Key), Base, Profile).

attribute_with_key(Key, attribute(ElementKey, _)) :-
    ElementKey == Key.

duty_answer(Profile, AwarenessDate, Duty, Citations) :-
    findall(GotDuty - GotCitations, serious_incident_report_duty(Profile, AwarenessDate, GotDuty, GotCitations), [OnlyDuty - OnlyCitations]),
    OnlyDuty = Duty,
    clausal_msort(OnlyCitations, SortedGot),
    clausal_msort(Citations, SortedExpected),
    SortedGot == SortedExpected.

timeliness_answer(Profile, AwarenessDate, ReportDate, Verdict, Citations) :-
    findall(GotVerdict - GotCitations, serious_incident_report_timeliness(Profile, AwarenessDate, ReportDate, GotVerdict, GotCitations), [OnlyVerdict - OnlyCitations]),
    OnlyVerdict = Verdict,
    clausal_msort(OnlyCitations, SortedGot),
    clausal_msort(Citations, SortedExpected),
    SortedGot == SortedExpected.

optional_provenance([]).
optional_provenance([provenance(_, _)]).

test(duty_report_due_directly) :-
    contract_profile(Profile),
    follow_up_list(FollowUp),
    duty_answer(Profile, date(2028, 1, 10), report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2028, 1, 20), FollowUp), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(duty_not_applicable_on_date_directly) :-
    duty_answer([], date(2027, 12, 1), not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i)]).
test(duty_not_a_high_risk_ai_system_directly) :-
    duty_answer([attribute(high_risk_classification, not_high_risk)], date(2028, 1, 10), not_a_high_risk_ai_system, [cite(eu_reg_2024_1689_art_73_1)]).
test(duty_not_covered_directly) :-
    duty_answer([attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, true), attribute(significant_change_in_design_since_that_date, false)], date(2029, 1, 1), not_covered_placed_before_application_date, [cite(eu_reg_2024_1689_art_111_2)]).
test(duty_not_a_serious_incident_directly) :-
    contract_profile_without(harm_to_health, Without),
    append(Without, [attribute(harm_to_health, no_death_or_serious_harm_to_health)], Profile),
    duty_answer(Profile, date(2028, 1, 10), not_a_serious_incident, [cite(eu_reg_2024_1689_art_3_49)]).
test(duty_not_a_reportable_incident_directly) :-
    contract_profile_without(provider_subject_to_equivalent_union_reporting_obligations, Without),
    append(Without, [attribute(provider_subject_to_equivalent_union_reporting_obligations, true)], Profile),
    duty_answer(Profile, date(2028, 1, 10), not_a_reportable_incident, [cite(eu_reg_2024_1689_art_73_9), cite(eu_reg_2024_1689_art_3_49_c)]).
test(duty_indeterminate_directly) :-
    duty_answer([], date(2028, 1, 10), indeterminate([high_risk_classification]), []).
test(duty_needs_legal_review_directly) :-
    duty_answer([attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, false), attribute(harm_to_health, serious_harm_to_health_without_death), attribute(critical_infrastructure_disruption, false), attribute(widespread_infringement, unsure)], date(2028, 1, 10), needs_legal_review(open_textured(widespread_infringement, cite(eu_reg_2024_1689_art_3_61)), [inputs_relied_on([provider_subject_to_equivalent_union_reporting_obligations - false, widespread_infringement - unsure])]), []).
test(duty_referral_context_needs_no_provenance) :-
    serious_incident_report_duty([attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, false), attribute(harm_to_health, serious_harm_to_health_without_death), attribute(critical_infrastructure_disruption, false), attribute(widespread_infringement, unsure)], date(2028, 1, 10), needs_legal_review(_, Context), []),
    Context = [inputs_relied_on(_)|Trailing],
    optional_provenance(Trailing).
test(duty_input_problems_directly) :-
    duty_answer(foo, date(2028, 1, 10), input_problems([wrong_type(profile)]), []).
test(timeliness_report_in_time_directly) :-
    contract_profile_with([attribute(report_made_immediately, true)], Profile),
    timeliness_answer(Profile, date(2028, 1, 10), date(2028, 1, 20), report_in_time, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(timeliness_report_after_time_limit_directly) :-
    contract_profile_with([attribute(report_made_immediately, true)], Profile),
    timeliness_answer(Profile, date(2028, 1, 10), date(2028, 1, 21), report_after_time_limit, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(timeliness_report_not_immediate_directly) :-
    contract_profile_with([attribute(report_made_immediately, false)], Profile),
    timeliness_answer(Profile, date(2028, 1, 10), date(2028, 1, 15), report_not_immediate, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(timeliness_passes_a_no_duty_answer_through_directly) :-
    contract_profile_with([attribute(report_made_immediately, true)], Profile),
    timeliness_answer(Profile, date(2027, 12, 1), date(2027, 12, 3), not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i)]).
test(timeliness_indeterminate_directly) :-
    contract_profile(Profile),
    timeliness_answer(Profile, date(2028, 1, 10), date(2028, 1, 15), indeterminate([report_made_immediately]), []).
test(timeliness_needs_legal_review_directly) :-
    contract_profile_with([attribute(report_made_immediately, unsure)], Profile),
    timeliness_answer(Profile, date(2028, 1, 10), date(2028, 1, 15), needs_legal_review(open_textured(report_made_immediately, cite(eu_reg_2024_1689_art_73_2)), [inputs_relied_on([provider_subject_to_equivalent_union_reporting_obligations - false, widespread_infringement - false, report_made_immediately - unsure])]), []).
test(timeliness_input_problems_directly) :-
    contract_profile_with([attribute(report_made_immediately, true)], Profile),
    timeliness_answer(Profile, date(2028, 1, 10), date(2028, 13, 1), input_problems([wrong_type(report_date)]), []).
test(every_subject_has_exactly_one_answer) :-
    findall(Subject, serious_incident_reporting_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(single_answer, Subjects).
test(every_subject_has_a_checklist) :-
    findall(Subject, serious_incident_reporting_subject(Subject), Subjects),
    maplist(has_checklist, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, serious_incident_reporting_subject(Subject), Subjects),
    maplist(is_resolvable, Subjects).
test(awareness_before_first_application_date_is_not_applicable) :-
    expected_verdict(awareness_before_first_application_date, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i)]).
test(awareness_on_first_application_date_gives_a_ten_day_report) :-
    expected_report(awareness_on_first_application_date, market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2027, 12, 12), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(annex_i_before_its_date_is_not_applicable) :-
    expected_verdict(annex_i_awareness_before_application_date, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_ii)]).
test(annex_i_on_its_date_gives_a_report) :-
    expected_report(annex_i_awareness_on_application_date, market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2028, 8, 12), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(a_system_not_high_risk_has_no_duty) :-
    expected_verdict(system_not_high_risk, not_a_high_risk_ai_system, [cite(eu_reg_2024_1689_art_73_1)]).
test(the_status_projection_gives_the_atom) :-
    serious_incident_reporting_profile_for(system_not_high_risk, Case),
    serious_incident_reporting_status(Case, not_a_high_risk_ai_system).
test(the_final_atom_is_in_the_status_values) :-
    serious_incident_reporting_status_values(Values),
    member(not_a_high_risk_ai_system, Values).
test(an_absent_classification_is_named) :-
    expected_verdict(classification_absent, indeterminate([high_risk_classification]), []).
test(an_early_unchanged_system_is_not_covered) :-
    expected_verdict(placed_early_without_significant_change, not_covered_placed_before_application_date, [cite(eu_reg_2024_1689_art_111_2)]).
test(an_early_changed_system_is_covered) :-
    expected_report(placed_early_with_significant_change, market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2029, 1, 11), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(a_public_authority_system_is_covered_from_the_compliance_date) :-
    expected_report(public_authority_system_on_compliance_date, market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2030, 8, 12), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(a_public_authority_system_the_day_before_is_not_covered) :-
    expected_verdict(public_authority_system_before_compliance_date, not_covered_placed_before_application_date, [cite(eu_reg_2024_1689_art_111_2)]).
test(an_unsure_public_authority_use_is_referred) :-
    expected_verdict(public_authority_use_unsure, needs_legal_review(open_textured(intended_to_be_used_by_public_authorities, cite(eu_reg_2024_1689_art_111_2)), [inputs_relied_on([significant_change_in_design_since_that_date - false, intended_to_be_used_by_public_authorities - unsure, provider_subject_to_equivalent_union_reporting_obligations - false, widespread_infringement - false])]), []).
test(a_confirmed_public_authority_use_gives_a_report) :-
    expected_report(public_authority_use_confirmed, market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2031, 1, 11), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(an_absent_placement_is_named) :-
    expected_verdict(placement_absent, indeterminate([placed_before_chapter_iii_application_date]), []).
test(an_absent_device_status_is_named) :-
    expected_verdict(device_status_absent, indeterminate([medical_device_or_safety_component_of_one]), []).
test(absent_equivalent_obligations_matter_without_point_c) :-
    expected_verdict(equivalent_obligations_absent_without_fundamental_rights, indeterminate([provider_subject_to_equivalent_union_reporting_obligations]), []).
test(absent_equivalent_obligations_do_not_matter_with_point_c) :-
    expected_report(equivalent_obligations_absent_with_fundamental_rights, market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2028, 1, 20), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(equivalent_obligations_without_point_c_are_not_reportable) :-
    expected_verdict(equivalent_obligations_without_fundamental_rights, not_a_reportable_incident, [cite(eu_reg_2024_1689_art_73_9), cite(eu_reg_2024_1689_art_3_49_c)]).
test(equivalent_obligations_with_point_c_are_reported) :-
    expected_report(equivalent_obligations_with_fundamental_rights, market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2028, 1, 20), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(a_device_without_point_c_is_not_reportable) :-
    expected_verdict(device_without_fundamental_rights, not_a_reportable_incident, [cite(eu_reg_2024_1689_art_73_10), cite(eu_reg_2024_1689_art_3_49_c)]).
test(a_device_with_point_c_reports_to_the_national_authority) :-
    expected_report(device_with_fundamental_rights, national_competent_authority_chosen_by_member_state_where_incident_occurred, 10, date(2028, 1, 20), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6), cite(eu_reg_2024_1689_art_73_10)]).
test(a_device_under_the_ai_office_reports_to_it) :-
    expected_report(device_under_ai_office, ai_office, 10, date(2028, 1, 20), [cite(eu_reg_2024_1689_art_75_1a), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6), cite(eu_reg_2024_1689_art_73_10)]).
test(a_device_attested_outside_the_ai_office_reports_nationally) :-
    expected_report(device_not_under_ai_office, national_competent_authority_chosen_by_member_state_where_incident_occurred, 10, date(2028, 1, 20), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6), cite(eu_reg_2024_1689_art_73_10)]).
test(no_listed_harm_is_not_a_serious_incident) :-
    expected_verdict(no_listed_harm, not_a_serious_incident, [cite(eu_reg_2024_1689_art_3_49)]).
test(property_harm_alone_gives_fifteen_days) :-
    expected_report(property_harm_only, market_surveillance_authority_of_member_state_where_incident_occurred, 15, date(2028, 1, 25), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_2), cite(eu_reg_2024_1689_art_73_6)]).
test(an_absent_critical_infrastructure_key_is_named_first) :-
    expected_verdict(critical_infrastructure_absent_without_other_harm, indeterminate([critical_infrastructure_disruption]), []).
test(critical_infrastructure_gives_two_days_across_the_leap_day) :-
    expected_report(critical_infrastructure_disrupted_in_leap_year, market_surveillance_authority_of_member_state_where_incident_occurred, 2, date(2028, 3, 1), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_3), cite(eu_reg_2024_1689_art_73_6)]).
test(a_death_without_disruption_gives_ten_days_across_the_leap_day) :-
    expected_report(death_in_leap_year, market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2028, 3, 9), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(a_widespread_infringement_gives_two_days) :-
    expected_report(widespread_infringement_with_health_harm, market_surveillance_authority_of_member_state_where_incident_occurred, 2, date(2027, 12, 22), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_3), cite(eu_reg_2024_1689_art_73_6)]).
test(health_harm_without_widespread_infringement_gives_fifteen_days) :-
    expected_report(health_harm_without_widespread_infringement, market_surveillance_authority_of_member_state_where_incident_occurred, 15, date(2028, 1, 4), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_2), cite(eu_reg_2024_1689_art_73_6)]).
test(an_unsure_widespread_infringement_is_referred) :-
    expected_verdict(widespread_infringement_unsure, needs_legal_review(open_textured(widespread_infringement, cite(eu_reg_2024_1689_art_3_61)), [inputs_relied_on([provider_subject_to_equivalent_union_reporting_obligations - false, widespread_infringement - unsure])]), []).
test(an_absent_widespread_infringement_is_named) :-
    expected_verdict(widespread_infringement_absent, indeterminate([widespread_infringement]), []).
test(a_report_on_the_last_day_made_immediately_is_in_time) :-
    expected_verdict(report_on_last_day_made_immediately, report_in_time, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(a_report_the_day_after_is_late) :-
    expected_verdict(report_day_after_last_day, report_after_time_limit, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(a_report_in_time_but_not_immediate) :-
    expected_verdict(report_in_time_not_immediate, report_not_immediate, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(an_absent_immediacy_is_named) :-
    expected_verdict(report_immediacy_absent, indeterminate([report_made_immediately]), []).
test(timeliness_passes_a_no_duty_answer_through) :-
    expected_verdict(report_before_first_application_date, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i)]).
test(an_unsure_immediacy_is_referred) :-
    expected_verdict(report_immediacy_unsure, needs_legal_review(open_textured(report_made_immediately, cite(eu_reg_2024_1689_art_73_2)), [inputs_relied_on([provider_subject_to_equivalent_union_reporting_obligations - false, widespread_infringement - false, report_made_immediately - unsure])]), []).
test(a_late_report_is_late_whatever_the_immediacy) :-
    expected_verdict(late_report_immediacy_unsure, report_after_time_limit, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(a_day_that_does_not_exist_is_wrong_type) :-
    expected_verdict(awareness_date_not_a_calendar_day, input_problems([wrong_type(awareness_date)]), []).
test(a_leap_day_is_a_real_day) :-
    expected_report(awareness_on_leap_day, market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2028, 3, 10), [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(a_repeated_key_is_a_duplicate) :-
    expected_verdict(duplicate_harm_key, input_problems([duplicate_key(harm_to_health)]), []).
test(a_profile_that_is_not_a_list_is_wrong_type) :-
    expected_verdict(profile_not_a_list, input_problems([wrong_type(profile)]), []).
test(a_key_outside_the_contract_is_unknown) :-
    expected_verdict(unknown_profile_key, input_problems([unknown_key(colour)]), []).
test(a_report_date_that_does_not_exist_is_wrong_type) :-
    expected_verdict(report_date_not_a_calendar_day, input_problems([wrong_type(report_date)]), []).
test(the_facade_decides_a_direct_request) :-
    decide_serious_incident_reporting(duty([], date(2027, 1, 1)), serious_incident_reporting_verdict(not_applicable_on_date, [_|_])).

test(duty_on_the_first_date_is_not_not_applicable, fail) :-
    contract_profile(Profile),
    serious_incident_report_duty(Profile, date(2027, 12, 2), not_applicable_on_date, _).
test(timeliness_on_the_last_day_is_not_late, fail) :-
    contract_profile_with([attribute(report_made_immediately, true)], Profile),
    serious_incident_report_timeliness(Profile, date(2028, 1, 10), date(2028, 1, 20), report_after_time_limit, _).
test(awareness_on_first_application_date_is_applicable, fail) :-
    serious_incident_reporting_assess(awareness_on_first_application_date, serious_incident_reporting_verdict(not_applicable_on_date, _)).
test(annex_i_on_its_date_is_applicable, fail) :-
    serious_incident_reporting_assess(annex_i_awareness_on_application_date, serious_incident_reporting_verdict(not_applicable_on_date, _)).
test(an_absent_classification_is_not_a_high_risk_answer, fail) :-
    serious_incident_reporting_assess(classification_absent, serious_incident_reporting_verdict(not_a_high_risk_ai_system, _)).
test(an_early_changed_system_is_not_excluded, fail) :-
    serious_incident_reporting_assess(placed_early_with_significant_change, serious_incident_reporting_verdict(not_covered_placed_before_application_date, _)).
test(a_public_authority_system_the_day_before_has_no_report, fail) :-
    serious_incident_reporting_assess(public_authority_system_before_compliance_date, serious_incident_reporting_verdict(report_due(_, _, _, _), _)).
test(a_confirmed_public_authority_use_is_not_referred, fail) :-
    serious_incident_reporting_assess(public_authority_use_confirmed, serious_incident_reporting_verdict(needs_legal_review(_, _), _)).
test(absent_equivalent_obligations_with_point_c_are_not_named, fail) :-
    serious_incident_reporting_assess(equivalent_obligations_absent_with_fundamental_rights, serious_incident_reporting_verdict(indeterminate(_), _)).
test(equivalent_obligations_with_point_c_are_not_unreportable, fail) :-
    serious_incident_reporting_assess(equivalent_obligations_with_fundamental_rights, serious_incident_reporting_verdict(not_a_reportable_incident, _)).
test(a_device_with_point_c_is_not_unreportable, fail) :-
    serious_incident_reporting_assess(device_with_fundamental_rights, serious_incident_reporting_verdict(not_a_reportable_incident, _)).
test(a_device_attested_outside_the_ai_office_does_not_report_to_it, fail) :-
    serious_incident_reporting_assess(device_not_under_ai_office, serious_incident_reporting_verdict(report_due(ai_office, _, _, _), _)).
test(property_harm_alone_is_a_serious_incident, fail) :-
    serious_incident_reporting_assess(property_harm_only, serious_incident_reporting_verdict(not_a_serious_incident, _)).
test(a_death_without_disruption_is_not_two_days, fail) :-
    serious_incident_reporting_assess(death_in_leap_year, serious_incident_reporting_verdict(report_due(_, 2, _, _), _)).
test(health_harm_without_widespread_infringement_is_not_two_days, fail) :-
    serious_incident_reporting_assess(health_harm_without_widespread_infringement, serious_incident_reporting_verdict(report_due(_, 2, _, _), _)).
test(a_report_the_day_after_is_not_in_time, fail) :-
    serious_incident_reporting_assess(report_day_after_last_day, serious_incident_reporting_verdict(report_in_time, _)).
test(a_report_on_the_last_day_is_not_late, fail) :-
    serious_incident_reporting_assess(report_on_last_day_made_immediately, serious_incident_reporting_verdict(report_after_time_limit, _)).
test(a_leap_day_is_not_an_input_problem, fail) :-
    serious_incident_reporting_assess(awareness_on_leap_day, serious_incident_reporting_verdict(input_problems(_), _)).

cp_test_names([duty_report_due_directly, duty_not_applicable_on_date_directly, duty_not_a_high_risk_ai_system_directly, duty_not_covered_directly, duty_not_a_serious_incident_directly, duty_not_a_reportable_incident_directly, duty_indeterminate_directly, duty_needs_legal_review_directly, duty_referral_context_needs_no_provenance, duty_input_problems_directly, timeliness_report_in_time_directly, timeliness_report_after_time_limit_directly, timeliness_report_not_immediate_directly, timeliness_passes_a_no_duty_answer_through_directly, timeliness_indeterminate_directly, timeliness_needs_legal_review_directly, timeliness_input_problems_directly, every_subject_has_exactly_one_answer, every_subject_has_a_checklist, every_subject_is_resolvable, awareness_before_first_application_date_is_not_applicable, awareness_on_first_application_date_gives_a_ten_day_report, annex_i_before_its_date_is_not_applicable, annex_i_on_its_date_gives_a_report, a_system_not_high_risk_has_no_duty, the_status_projection_gives_the_atom, the_final_atom_is_in_the_status_values, an_absent_classification_is_named, an_early_unchanged_system_is_not_covered, an_early_changed_system_is_covered, a_public_authority_system_is_covered_from_the_compliance_date, a_public_authority_system_the_day_before_is_not_covered, an_unsure_public_authority_use_is_referred, a_confirmed_public_authority_use_gives_a_report, an_absent_placement_is_named, an_absent_device_status_is_named, absent_equivalent_obligations_matter_without_point_c, absent_equivalent_obligations_do_not_matter_with_point_c, equivalent_obligations_without_point_c_are_not_reportable, equivalent_obligations_with_point_c_are_reported, a_device_without_point_c_is_not_reportable, a_device_with_point_c_reports_to_the_national_authority, a_device_under_the_ai_office_reports_to_it, a_device_attested_outside_the_ai_office_reports_nationally, no_listed_harm_is_not_a_serious_incident, property_harm_alone_gives_fifteen_days, an_absent_critical_infrastructure_key_is_named_first, critical_infrastructure_gives_two_days_across_the_leap_day, a_death_without_disruption_gives_ten_days_across_the_leap_day, a_widespread_infringement_gives_two_days, health_harm_without_widespread_infringement_gives_fifteen_days, an_unsure_widespread_infringement_is_referred, an_absent_widespread_infringement_is_named, a_report_on_the_last_day_made_immediately_is_in_time, a_report_the_day_after_is_late, a_report_in_time_but_not_immediate, an_absent_immediacy_is_named, timeliness_passes_a_no_duty_answer_through, an_unsure_immediacy_is_referred, a_late_report_is_late_whatever_the_immediacy, a_day_that_does_not_exist_is_wrong_type, a_leap_day_is_a_real_day, a_repeated_key_is_a_duplicate, a_profile_that_is_not_a_list_is_wrong_type, a_key_outside_the_contract_is_unknown, a_report_date_that_does_not_exist_is_wrong_type, the_facade_decides_a_direct_request]).
cp_test_fail_names([duty_on_the_first_date_is_not_not_applicable, timeliness_on_the_last_day_is_not_late, awareness_on_first_application_date_is_applicable, annex_i_on_its_date_is_applicable, an_absent_classification_is_not_a_high_risk_answer, an_early_changed_system_is_not_excluded, a_public_authority_system_the_day_before_has_no_report, a_confirmed_public_authority_use_is_not_referred, absent_equivalent_obligations_with_point_c_are_not_named, equivalent_obligations_with_point_c_are_not_unreportable, a_device_with_point_c_is_not_unreportable, a_device_attested_outside_the_ai_office_does_not_report_to_it, property_harm_alone_is_a_serious_incident, a_death_without_disruption_is_not_two_days, health_harm_without_widespread_infringement_is_not_two_days, a_report_the_day_after_is_not_in_time, a_report_on_the_last_day_is_not_late, a_leap_day_is_not_an_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
