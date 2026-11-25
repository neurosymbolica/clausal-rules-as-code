% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_incident_classification_thresholds_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_incident_classification_thresholds_dora_incident_classification_thresholds, [dora_incident_threshold_status/4, dora_final_report_timeliness/5, decide_dora_incident_classification_thresholds/2, dora_incident_classification_thresholds_checklist/2]).
:- use_module(m__eu_dora_incident_classification_thresholds_fixtures, [dora_incident_classification_thresholds_profile_for/2]).

test(a_met_threshold_reads_out_its_fixed_citations) :-
    dora_incident_classification_thresholds_profile_for(economic_one_cent_over_limit, Profile),
    findall(Status - Citations, dora_incident_threshold_status(Profile, economic_impact_threshold_met, Status, Citations), Answers),
    Answers = [met - CitationList],
    sort(CitationList, CitationSet),
    sort([cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_6), cite(eu_reg_2024_1772_art_7)], CitationSet).
test(not_met_reads_out_the_same_citations_as_met) :-
    dora_incident_classification_thresholds_profile_for(economic_exactly_at_limit, Profile),
    dora_incident_threshold_status(Profile, economic_impact_threshold_met, Status, CitationList),
    Status == not_met,
    sort(CitationList, CitationSet),
    sort([cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_6), cite(eu_reg_2024_1772_art_7)], CitationSet).
test(the_verdict_carries_a_citation) :-
    dora_incident_classification_thresholds_profile_for(duration_over_twenty_four_hours, Profile),
    decide_dora_incident_classification_thresholds(threshold_query(Profile, duration_and_service_downtime_threshold_met), dora_incident_classification_thresholds_verdict(met, [_FirstCitation|_OtherCitations])).
test(the_empty_profile_checklist_names_one_key_per_condition) :-
    findall(Items, dora_incident_classification_thresholds_checklist([], Items), [ChecklistItems]),
    ChecklistItems == [item(critical_services_affected, indeterminate([affects_ict_services_supporting_critical_or_important_functions]), []), item(data_losses_malicious_access_threshold_met, indeterminate([successful_malicious_unauthorised_access]), []), item(clients_financial_counterparts_and_transactions_threshold_met, indeterminate([affected_clients]), []), item(reputational_impact_threshold_met, indeterminate([incident_reflected_in_media]), []), item(duration_and_service_downtime_threshold_met, indeterminate([incident_duration_seconds]), []), item(geographical_spread_threshold_met, indeterminate([member_states_with_impact]), []), item(data_losses_impact_threshold_met, indeterminate([data_impact_adverse_to_business_objectives_or_regulatory_requirements]), []), item(economic_impact_threshold_met, indeterminate([expropriated_funds_and_assets_cents]), [])].
test(every_condition_reads_out_one_status) :-
    Conditions = [critical_services_affected, data_losses_malicious_access_threshold_met, clients_financial_counterparts_and_transactions_threshold_met, reputational_impact_threshold_met, duration_and_service_downtime_threshold_met, geographical_spread_threshold_met, data_losses_impact_threshold_met, economic_impact_threshold_met],
    findall(Condition - Status, (member(Condition, Conditions), dora_incident_threshold_status([attribute(member_states_with_impact, 3)], Condition, Status, _Citations)), Answers),
    length(Answers, 8).
test(the_referral_reads_out_pairs_in_root_order) :-
    dora_incident_classification_thresholds_profile_for(data_impact_adverse_referred, Profile),
    findall(Status, dora_incident_threshold_status(Profile, data_losses_impact_threshold_met, Status, []), Statuses),
    Statuses == [needs_legal_review(open_textured(data_impact_adverse_to_business_objectives_or_regulatory_requirements, cite(eu_reg_2024_1772_art_9_5_a)), [inputs_relied_on([data_impact_adverse_to_business_objectives_or_regulatory_requirements - unsure, data_availability_impact - true, data_authenticity_impact - false, data_integrity_impact - false, data_confidentiality_impact - false])])].
test(the_final_report_reads_out_one_result) :-
    findall(Result - Citations, dora_final_report_timeliness([attribute(final_report_weekend_extension, true)], date(2025, 5, 31), date(2025, 7, 1), Result, Citations), Answers),
    Answers = [on_time - CitationList],
    sort(CitationList, CitationSet),
    sort([cite(eu_reg_2025_301_art_5_1_c), cite(eu_reg_2025_301_art_5_4), cite(eu_reg_2025_301_art_5_5), cite(eu_reg_2025_301_art_5_6)], CitationSet).
test(december_rolls_over_to_january) :-
    findall(Result, dora_final_report_timeliness([], date(2025, 12, 31), date(2026, 1, 31), Result, _Citations), Results),
    Results == [on_time].
test(the_day_after_due_reads_out_the_missing_key) :-
    findall(Result, dora_final_report_timeliness([], date(2025, 12, 15), date(2026, 1, 16), Result, []), Results),
    Results == [indeterminate([final_report_weekend_extension])].

cp_test_names([a_met_threshold_reads_out_its_fixed_citations, not_met_reads_out_the_same_citations_as_met, the_verdict_carries_a_citation, the_empty_profile_checklist_names_one_key_per_condition, every_condition_reads_out_one_status, the_referral_reads_out_pairs_in_root_order, the_final_report_reads_out_one_result, december_rolls_over_to_january, the_day_after_due_reads_out_the_missing_key]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
