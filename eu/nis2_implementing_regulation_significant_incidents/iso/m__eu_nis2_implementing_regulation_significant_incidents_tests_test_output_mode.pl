% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_implementing_regulation_significant_incidents_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_nis2_implementing_regulation_significant_incidents, [significant_incident_criteria/3, decide_nis2_implementing_regulation_significant_incidents/2, nis2_implementing_regulation_significant_incidents_checklist/2]).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_fixtures, [nis2_implementing_regulation_significant_incidents_subject/1, nis2_implementing_regulation_significant_incidents_profile_for/2]).

expected_citations(significant, [cite(eu_reg_2024_2690_art_3_1)]).
expected_citations(not_significant, [cite(eu_reg_2024_2690_art_3_1), cite(eu_reg_2024_2690_art_3_2)]).
expected_citations(indeterminate(_), []).
expected_citations(needs_legal_review(_, _), []).
expected_citations(input_problems(_), []).

expected_result(scheduled_maintenance_with_loss, not_significant).
expected_result(loss_above_floor_not_scheduled, significant).
expected_result(loss_above_floor_scheduled_absent, indeterminate([scheduled_interruption_or_maintenance])).
expected_result(all_criteria_closed_dns, not_significant).
expected_result(trade_secret_exfiltration_true, significant).
expected_result(loss_equal_floor_turnover_large, not_significant).
expected_result(loss_one_cent_above_floor_turnover_large, significant).
expected_result(loss_above_five_percent_of_small_turnover, significant).
expected_result(loss_at_five_percent_of_small_turnover, not_significant).
expected_result(loss_below_floor_turnover_absent, indeterminate([annual_turnover_preceding_financial_year_euro_cents])).
expected_result(recurring_twice_same_cause_collective_loss, significant).
expected_result(recurring_once_same_cause_collective_loss, not_significant).
expected_result(dns_outage_exactly_thirty_minutes, not_significant).
expected_result(dns_outage_thirty_minutes_one_second, significant).
expected_result(dns_misconfiguration_exception_applies, not_significant).
expected_result(dns_misconfiguration_one_percent_exceeded, significant).
expected_result(dns_misconfiguration_thousand_names, significant).
expected_result(dns_misconfiguration_nine_hundred_ninety_nine_names, not_significant).
expected_result(tld_any_complete_unavailability, significant).
expected_result(tld_no_complete_unavailability, not_significant).
expected_result(cloud_limited_availability_users_total_absent, indeterminate([service_users_in_union])).
expected_result(cloud_limited_availability_above_five_percent, significant).
expected_result(cloud_limited_availability_at_five_percent, not_significant).
expected_result(cloud_limited_availability_exactly_one_hour, not_significant).
expected_result(cloud_limited_availability_over_one_million, significant).
expected_result(cloud_limited_availability_one_million_large_base, not_significant).
expected_result(data_centre_physical_access, significant).
expected_result(data_centre_no_physical_access, not_significant).
expected_result(marketplace_complete_unavailability_over_one_million, significant).
expected_result(marketplace_complete_unavailability_one_million_large_base, not_significant).
expected_result(trust_unavailable_twenty_minutes, not_significant).
expected_result(trust_unavailable_twenty_minutes_one_second, significant).
expected_result(trust_weekly_unavailability_one_hour, not_significant).
expected_result(trust_weekly_unavailability_one_hour_one_second, significant).
expected_result(trust_limited_availability_over_two_hundred_thousand, significant).
expected_result(trust_limited_availability_two_hundred_thousand_large_base, not_significant).
expected_result(trust_data_compromise_over_one_hundred_users, significant).
expected_result(trust_data_compromise_one_hundred_users_large_base, not_significant).
expected_result(entity_type_absent_all_types_closed, not_significant).
expected_result(entity_type_absent_open, indeterminate([relevant_entity_type])).
expected_result(death_unsure_decisive, needs_legal_review(open_textured(death_of_natural_person, cite(eu_reg_2024_2690_art_3_1_c)), [inputs_relied_on([trade_secret_exfiltration - false, death_of_natural_person - unsure, considerable_damage_to_natural_person_health - false, suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption - false, data_compromised - false])])).
expected_result(death_unsure_count_absent, indeterminate([recurring_incidents_within_six_months])).
expected_result(data_compromised_unsure_tld, needs_legal_review(open_textured(data_compromised, cite(eu_reg_2024_2690_art_3_1_g)), [inputs_relied_on([trade_secret_exfiltration - false, death_of_natural_person - false, considerable_damage_to_natural_person_health - false, suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption - false, data_compromised - unsure])])).
expected_result(unsure_irrelevant_loss_met, significant).
expected_result(wrong_type_float_loss, input_problems([wrong_type(direct_financial_loss_euro_cents)])).
expected_result(duplicate_and_unknown_keys, input_problems([duplicate_key(scheduled_interruption_or_maintenance), unknown_key(colour)])).
expected_result(profile_not_attribute_list, input_problems([wrong_type(profile)])).

answer_matches(Subject) :-
    expected_result(Subject, ExpectedResult),
    expected_citations(ExpectedResult, ExpectedCitations),
    nis2_implementing_regulation_significant_incidents_profile_for(Subject, Profile),
    findall(Result - Citations, significant_incident_criteria(Profile, Result, Citations), Answers),
    Answers == [ExpectedResult - ExpectedCitations].

test(every_registered_subject_has_an_expected_answer) :-
    findall(Subject, nis2_implementing_regulation_significant_incidents_subject(Subject), RegisteredSubjects),
    sort(RegisteredSubjects, RegisteredSet),
    findall(Subject, expected_result(Subject, _), TableSubjects),
    sort(TableSubjects, TableSet),
    TableSet == RegisteredSet.
test(every_subject_yields_its_expected_answer_exactly_once) :-
    findall(Subject, expected_result(Subject, _), TableSubjects),
    findall(Subject, answer_matches(Subject), MatchingSubjects),
    MatchingSubjects == TableSubjects.
test(the_verdict_term_carries_the_fixed_citation) :-
    nis2_implementing_regulation_significant_incidents_profile_for(loss_one_cent_above_floor_turnover_large, Profile),
    findall(Verdict, decide_nis2_implementing_regulation_significant_incidents(Profile, Verdict), Verdicts),
    Verdicts == [nis2_implementing_regulation_significant_incidents_verdict(significant, [cite(eu_reg_2024_2690_art_3_1)])].
test(the_not_significant_verdict_cites_both_paragraphs) :-
    nis2_implementing_regulation_significant_incidents_profile_for(loss_equal_floor_turnover_large, Profile),
    findall(Verdict, decide_nis2_implementing_regulation_significant_incidents(Profile, Verdict), Verdicts),
    Verdicts == [nis2_implementing_regulation_significant_incidents_verdict(not_significant, [cite(eu_reg_2024_2690_art_3_1), cite(eu_reg_2024_2690_art_3_2)])].
test(the_checklist_has_one_cited_row_per_ground) :-
    nis2_implementing_regulation_significant_incidents_profile_for(all_criteria_closed_dns, Profile),
    findall(Items, nis2_implementing_regulation_significant_incidents_checklist(Profile, Items), [Checklist]),
    length(Checklist, 8),
    Checklist = [item(scheduled_interruption_or_maintenance, met, cite(eu_reg_2024_2690_art_3_2))|_].
test(the_checklist_reports_input_problems_alone) :-
    nis2_implementing_regulation_significant_incidents_profile_for(profile_not_attribute_list, Profile),
    findall(Items, nis2_implementing_regulation_significant_incidents_checklist(Profile, Items), Checklists),
    Checklists == [[item(input_check, unmet([wrong_type(profile)]), cite(eu_reg_2024_2690_art_3_1))]].

cp_test_names([every_registered_subject_has_an_expected_answer, every_subject_yields_its_expected_answer_exactly_once, the_verdict_term_carries_the_fixed_citation, the_not_significant_verdict_cites_both_paragraphs, the_checklist_has_one_cited_row_per_ground, the_checklist_reports_input_problems_alone]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
