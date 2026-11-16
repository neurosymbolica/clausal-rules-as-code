% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_serious_incident_reporting, [decide_serious_incident_reporting/2, serious_incident_reporting_status/2, serious_incident_reporting_checklist/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_fixtures, [serious_incident_reporting_profile_for/2, serious_incident_reporting_assess/2]).

sole_answer(Subject, Status, Citations) :-
    findall(FoundStatus - FoundCitations, serious_incident_reporting_assess(Subject, serious_incident_reporting_verdict(FoundStatus, FoundCitations)), Answers),
    Answers = [Status - Citations].

same_citations(FoundCitations, ExpectedCitations) :-
    msort(FoundCitations, SortedCitations),
    msort(ExpectedCitations, SortedCitations).

follow_up_list([perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system]).

test(the_day_before_2_december_2027_is_not_applicable) :-
    sole_answer(before_annex_iii_application_date, Status, Citations),
    Status == not_applicable_on_date,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i)]).
test(on_2_december_2027_a_death_gives_ten_days) :-
    sole_answer(on_annex_iii_application_date, Status, Citations),
    follow_up_list(FollowUpDuties),
    Status == report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2027, 12, 12), FollowUpDuties),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(annex_i_the_day_before_2_august_2028_is_not_applicable) :-
    sole_answer(annex_i_before_application_date, Status, Citations),
    Status == not_applicable_on_date,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_ii)]).
test(annex_i_on_2_august_2028_critical_infrastructure_gives_two_days) :-
    sole_answer(annex_i_on_application_date, Status, Citations),
    Status = report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 2, date(2028, 8, 4), _),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_3), cite(eu_reg_2024_1689_art_73_6)]).
test(a_system_that_is_not_high_risk_has_no_duty) :-
    sole_answer(not_high_risk_system, not_a_high_risk_ai_system, [cite(eu_reg_2024_1689_art_73_1)]).
test(a_missing_classification_is_named) :-
    sole_answer(classification_missing, indeterminate([high_risk_classification]), []).
test(an_early_unchanged_system_before_2_august_2030_is_not_covered) :-
    sole_answer(early_unchanged_public_day_before_2030, not_covered_placed_before_application_date, [cite(eu_reg_2024_1689_art_111_2)]).
test(an_early_public_authority_system_on_2_august_2030_is_covered) :-
    sole_answer(early_unchanged_public_on_2030, report_due(_, 10, date(2030, 8, 12), _), _).
test(a_significant_change_covers_an_early_system) :-
    sole_answer(early_significantly_changed, report_due(_, 10, date(2029, 3, 11), _), _).
test(a_missing_placement_is_named) :-
    sole_answer(placement_missing, indeterminate([placed_before_chapter_iii_application_date]), []).
test(two_days_reach_a_leap_day) :-
    sole_answer(leap_day_critical_infrastructure, report_due(_, 2, date(2028, 2, 29), _), _).
test(fifteen_days_cross_the_year) :-
    sole_answer(year_crossing_general_limit, Status, Citations),
    Status = report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 15, date(2028, 1, 4), _),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_2), cite(eu_reg_2024_1689_art_73_6)]).
test(ten_days_from_a_leap_day) :-
    sole_answer(awareness_on_leap_day, report_due(_, 10, date(2028, 3, 10), _), _).
test(no_qualifying_harm_is_not_a_serious_incident) :-
    sole_answer(no_qualifying_harm, not_a_serious_incident, [cite(eu_reg_2024_1689_art_3_49)]).
test(harm_to_property_gives_fifteen_days) :-
    sole_answer(harm_to_property, report_due(_, 15, date(2028, 1, 25), _), _).
test(a_device_without_point_c_is_not_reportable) :-
    sole_answer(device_without_point_c, Status, Citations),
    Status == not_a_reportable_incident,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_10), cite(eu_reg_2024_1689_art_3_49_c)]).
test(a_device_with_point_c_goes_to_the_national_authority) :-
    sole_answer(device_with_point_c, Status, Citations),
    Status = report_due(national_competent_authority_chosen_by_member_state_where_incident_occurred, 15, date(2028, 1, 25), _),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_2), cite(eu_reg_2024_1689_art_73_6), cite(eu_reg_2024_1689_art_73_10)]).
test(equivalent_obligations_without_point_c_are_not_reportable) :-
    sole_answer(equivalent_obligations_without_point_c, Status, Citations),
    Status == not_a_reportable_incident,
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_9), cite(eu_reg_2024_1689_art_3_49_c)]).
test(equivalent_obligations_with_point_c_keep_the_death_limit) :-
    sole_answer(equivalent_obligations_with_point_c, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2028, 1, 20), _), _).
test(a_report_on_the_last_day_made_immediately_is_in_time) :-
    sole_answer(report_on_last_day_made_immediately, report_in_time, [_|_]).
test(a_report_the_day_after_the_last_day_is_late) :-
    sole_answer(report_day_after_last_day, report_after_time_limit, [_|_]).
test(a_report_not_made_immediately_is_not_immediate) :-
    sole_answer(report_on_last_day_not_immediate, report_not_immediate, [_|_]).
test(a_missing_immediacy_is_named) :-
    sole_answer(report_immediacy_missing, indeterminate([report_made_immediately]), []).
test(an_unsure_immediacy_goes_to_a_lawyer) :-
    sole_answer(report_immediacy_unsure, needs_legal_review(open_textured(report_made_immediately, cite(eu_reg_2024_1689_art_73_2)), [inputs_relied_on([provider_subject_to_equivalent_union_reporting_obligations - false, widespread_infringement - false, report_made_immediately - unsure])]), []).
test(a_late_report_is_late_whatever_the_immediacy) :-
    sole_answer(late_report_immediacy_unsure, report_after_time_limit, [_|_]).
test(a_report_before_awareness_is_in_time) :-
    sole_answer(report_before_awareness, report_in_time, [_|_]).
test(timeliness_passes_a_no_duty_atom_through) :-
    sole_answer(timeliness_not_high_risk, not_a_high_risk_ai_system, [cite(eu_reg_2024_1689_art_73_1)]).
test(an_unsure_judgement_beside_a_missing_fact_names_the_fact) :-
    sole_answer(widespread_unsure_health_missing, indeterminate([harm_to_health]), []).
test(an_unsure_significant_change_goes_to_a_lawyer) :-
    sole_answer(significant_change_unsure_placed_early, needs_legal_review(open_textured(significant_change_in_design_since_that_date, cite(eu_reg_2024_1689_art_111_2)), [inputs_relied_on([significant_change_in_design_since_that_date - unsure, provider_subject_to_equivalent_union_reporting_obligations - false, widespread_infringement - false])]), []).
test(an_unsure_equivalence_goes_to_a_lawyer) :-
    sole_answer(equivalence_unsure_without_point_c, needs_legal_review(open_textured(provider_subject_to_equivalent_union_reporting_obligations, cite(eu_reg_2024_1689_art_73_9)), _), []).
test(input_problems_list_profile_then_date) :-
    sole_answer(profile_and_date_problems, input_problems([wrong_type(critical_infrastructure_disruption), wrong_type(awareness_date)]), []).
test(a_report_date_that_is_not_a_date_is_wrong_type) :-
    sole_answer(report_date_not_a_date, input_problems([wrong_type(report_date)]), []).
test(the_slice_status_reads_out_once) :-
    serious_incident_reporting_profile_for(no_qualifying_harm, Profile),
    findall(Status, serious_incident_reporting_status(duty_query(Profile, date(2028, 1, 10)), Status), Statuses),
    Statuses == [not_a_serious_incident].
test(the_slice_verdict_carries_a_citation) :-
    serious_incident_reporting_profile_for(no_qualifying_harm, Profile),
    decide_serious_incident_reporting(duty_query(Profile, date(2028, 1, 10)), serious_incident_reporting_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(the_checklist_ends_with_the_deciding_ground) :-
    serious_incident_reporting_profile_for(device_without_point_c, Profile),
    serious_incident_reporting_checklist(duty_query(Profile, date(2028, 1, 10)), Items),
    last(Items, item(serious_incident, unmet(not_a_reportable_incident), _)).

cp_test_names([the_day_before_2_december_2027_is_not_applicable, on_2_december_2027_a_death_gives_ten_days, annex_i_the_day_before_2_august_2028_is_not_applicable, annex_i_on_2_august_2028_critical_infrastructure_gives_two_days, a_system_that_is_not_high_risk_has_no_duty, a_missing_classification_is_named, an_early_unchanged_system_before_2_august_2030_is_not_covered, an_early_public_authority_system_on_2_august_2030_is_covered, a_significant_change_covers_an_early_system, a_missing_placement_is_named, two_days_reach_a_leap_day, fifteen_days_cross_the_year, ten_days_from_a_leap_day, no_qualifying_harm_is_not_a_serious_incident, harm_to_property_gives_fifteen_days, a_device_without_point_c_is_not_reportable, a_device_with_point_c_goes_to_the_national_authority, equivalent_obligations_without_point_c_are_not_reportable, equivalent_obligations_with_point_c_keep_the_death_limit, a_report_on_the_last_day_made_immediately_is_in_time, a_report_the_day_after_the_last_day_is_late, a_report_not_made_immediately_is_not_immediate, a_missing_immediacy_is_named, an_unsure_immediacy_goes_to_a_lawyer, a_late_report_is_late_whatever_the_immediacy, a_report_before_awareness_is_in_time, timeliness_passes_a_no_duty_atom_through, an_unsure_judgement_beside_a_missing_fact_names_the_fact, an_unsure_significant_change_goes_to_a_lawyer, an_unsure_equivalence_goes_to_a_lawyer, input_problems_list_profile_then_date, a_report_date_that_is_not_a_date_is_wrong_type, the_slice_status_reads_out_once, the_slice_verdict_carries_a_citation, the_checklist_ends_with_the_deciding_ground]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
