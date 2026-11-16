% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_implementing_regulation_significant_incidents_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_nis2_implementing_regulation_significant_incidents, [significant_incident_criteria/3, decide_nis2_implementing_regulation_significant_incidents/2, nis2_implementing_regulation_significant_incidents_status/2, nis2_implementing_regulation_significant_incidents_checklist/2, nis2_implementing_regulation_significant_incidents_decision_resolvable/1, nis2_implementing_regulation_significant_incidents_status_values/1]).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_kernel, [provenance/2]).
:- use_module(m__eu_nis2_implementing_regulation_significant_incidents_fixtures, [nis2_implementing_regulation_significant_incidents_subject/1, nis2_implementing_regulation_significant_incidents_profile_for/2, nis2_implementing_regulation_significant_incidents_assess/2]).

expected_status(scheduled_maintenance_with_loss, not_significant).
expected_status(loss_above_floor_not_scheduled, significant).
expected_status(loss_above_floor_scheduled_absent, indeterminate([scheduled_interruption_or_maintenance])).
expected_status(all_criteria_closed_dns, not_significant).
expected_status(trade_secret_exfiltration_true, significant).
expected_status(loss_equal_floor_turnover_large, not_significant).
expected_status(loss_one_cent_above_floor_turnover_large, significant).
expected_status(loss_above_five_percent_of_small_turnover, significant).
expected_status(loss_at_five_percent_of_small_turnover, not_significant).
expected_status(loss_below_floor_turnover_absent, indeterminate([annual_turnover_preceding_financial_year_euro_cents])).
expected_status(recurring_twice_same_cause_collective_loss, significant).
expected_status(recurring_once_same_cause_collective_loss, not_significant).
expected_status(dns_outage_exactly_thirty_minutes, not_significant).
expected_status(dns_outage_thirty_minutes_one_second, significant).
expected_status(dns_misconfiguration_exception_applies, not_significant).
expected_status(dns_misconfiguration_one_percent_exceeded, significant).
expected_status(dns_misconfiguration_thousand_names, significant).
expected_status(dns_misconfiguration_nine_hundred_ninety_nine_names, not_significant).
expected_status(tld_any_complete_unavailability, significant).
expected_status(tld_no_complete_unavailability, not_significant).
expected_status(cloud_limited_availability_users_total_absent, indeterminate([service_users_in_union])).
expected_status(cloud_limited_availability_above_five_percent, significant).
expected_status(cloud_limited_availability_at_five_percent, not_significant).
expected_status(cloud_limited_availability_exactly_one_hour, not_significant).
expected_status(cloud_limited_availability_over_one_million, significant).
expected_status(cloud_limited_availability_one_million_large_base, not_significant).
expected_status(data_centre_physical_access, significant).
expected_status(data_centre_no_physical_access, not_significant).
expected_status(marketplace_complete_unavailability_over_one_million, significant).
expected_status(marketplace_complete_unavailability_one_million_large_base, not_significant).
expected_status(trust_unavailable_twenty_minutes, not_significant).
expected_status(trust_unavailable_twenty_minutes_one_second, significant).
expected_status(trust_weekly_unavailability_one_hour, not_significant).
expected_status(trust_weekly_unavailability_one_hour_one_second, significant).
expected_status(trust_limited_availability_over_two_hundred_thousand, significant).
expected_status(trust_limited_availability_two_hundred_thousand_large_base, not_significant).
expected_status(trust_data_compromise_over_one_hundred_users, significant).
expected_status(trust_data_compromise_one_hundred_users_large_base, not_significant).
expected_status(entity_type_absent_all_types_closed, not_significant).
expected_status(entity_type_absent_open, indeterminate([relevant_entity_type])).
expected_status(death_unsure_decisive, needs_legal_review(open_textured(death_of_natural_person, cite(eu_reg_2024_2690_art_3_1_c)), [inputs_relied_on([trade_secret_exfiltration - false, death_of_natural_person - unsure, considerable_damage_to_natural_person_health - false, suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption - false, data_compromised - false])])).
expected_status(death_unsure_count_absent, indeterminate([recurring_incidents_within_six_months])).
expected_status(data_compromised_unsure_tld, needs_legal_review(open_textured(data_compromised, cite(eu_reg_2024_2690_art_3_1_g)), [inputs_relied_on([trade_secret_exfiltration - false, death_of_natural_person - false, considerable_damage_to_natural_person_health - false, suspectedly_malicious_unauthorised_access_capable_of_severe_operational_disruption - false, data_compromised - unsure])])).
expected_status(unsure_irrelevant_loss_met, significant).
expected_status(wrong_type_float_loss, input_problems([wrong_type(direct_financial_loss_euro_cents)])).
expected_status(duplicate_and_unknown_keys, input_problems([duplicate_key(scheduled_interruption_or_maintenance), unknown_key(colour)])).
expected_status(profile_not_attribute_list, input_problems([wrong_type(profile)])).

near_miss(loss_above_floor_not_scheduled, scheduled_maintenance_with_loss).
near_miss(trade_secret_exfiltration_true, all_criteria_closed_dns).
near_miss(loss_one_cent_above_floor_turnover_large, loss_equal_floor_turnover_large).
near_miss(loss_above_five_percent_of_small_turnover, loss_at_five_percent_of_small_turnover).
near_miss(recurring_twice_same_cause_collective_loss, recurring_once_same_cause_collective_loss).
near_miss(dns_outage_thirty_minutes_one_second, dns_outage_exactly_thirty_minutes).
near_miss(dns_misconfiguration_one_percent_exceeded, dns_misconfiguration_exception_applies).
near_miss(dns_misconfiguration_thousand_names, dns_misconfiguration_nine_hundred_ninety_nine_names).
near_miss(tld_any_complete_unavailability, tld_no_complete_unavailability).
near_miss(cloud_limited_availability_above_five_percent, cloud_limited_availability_at_five_percent).
near_miss(cloud_limited_availability_above_five_percent, cloud_limited_availability_exactly_one_hour).
near_miss(cloud_limited_availability_over_one_million, cloud_limited_availability_one_million_large_base).
near_miss(data_centre_physical_access, data_centre_no_physical_access).
near_miss(marketplace_complete_unavailability_over_one_million, marketplace_complete_unavailability_one_million_large_base).
near_miss(trust_unavailable_twenty_minutes_one_second, trust_unavailable_twenty_minutes).
near_miss(trust_weekly_unavailability_one_hour_one_second, trust_weekly_unavailability_one_hour).
near_miss(trust_limited_availability_over_two_hundred_thousand, trust_limited_availability_two_hundred_thousand_large_base).
near_miss(trust_data_compromise_over_one_hundred_users, trust_data_compromise_one_hundred_users_large_base).
near_miss(entity_type_absent_open, entity_type_absent_all_types_closed).

result_citations(significant, [cite(eu_reg_2024_2690_art_3_1)]).
result_citations(not_significant, [cite(eu_reg_2024_2690_art_3_1), cite(eu_reg_2024_2690_art_3_2)]).
result_citations(indeterminate(_), []).
result_citations(needs_legal_review(_, _), []).
result_citations(input_problems(_), []).

subject_status(Subject, Status) :-
    nis2_implementing_regulation_significant_incidents_assess(Subject, nis2_implementing_regulation_significant_incidents_verdict(Status, _Citations)).

subject_matches_expected(Subject) :-
    expected_status(Subject, Expected),
    subject_status(Subject, Status),
    Status == Expected.

subject_has_one_answer(Subject) :-
    findall(Verdict, nis2_implementing_regulation_significant_incidents_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

subject_citations_fixed(Subject) :-
    nis2_implementing_regulation_significant_incidents_assess(Subject, nis2_implementing_regulation_significant_incidents_verdict(Status, Citations)),
    result_citations(Status, ExpectedCitations),
    Citations == ExpectedCitations.

subject_checklist_non_empty(Subject) :-
    nis2_implementing_regulation_significant_incidents_profile_for(Subject, Profile),
    nis2_implementing_regulation_significant_incidents_checklist(Profile, [_FirstItem|_OtherItems]).

subject_resolvable(Subject) :-
    nis2_implementing_regulation_significant_incidents_profile_for(Subject, Profile),
    nis2_implementing_regulation_significant_incidents_decision_resolvable(Profile).

subject_status_projection_agrees(Subject) :-
    nis2_implementing_regulation_significant_incidents_profile_for(Subject, Profile),
    nis2_implementing_regulation_significant_incidents_status(Profile, Status),
    expected_status(Subject, Expected),
    Status == Expected.

subject_criteria_agrees(Subject) :-
    nis2_implementing_regulation_significant_incidents_profile_for(Subject, Profile),
    findall(Result - Citations, significant_incident_criteria(Profile, Result, Citations), Answers),
    expected_status(Subject, Expected),
    result_citations(Expected, ExpectedCitations),
    Answers == [Expected - ExpectedCitations].

criteria_for_subject(Subject, Result, Citations) :-
    nis2_implementing_regulation_significant_incidents_profile_for(Subject, Profile),
    significant_incident_criteria(Profile, Result, Citations).

near_miss_differs(Positive - Control) :-
    subject_status(Positive, PositiveStatus),
    subject_status(Control, ControlStatus),
    PositiveStatus \== ControlStatus.

all_subjects(Subjects) :-
    findall(Subject, nis2_implementing_regulation_significant_incidents_subject(Subject), Subjects).

test(every_subject_has_an_expected_result_and_no_more) :-
    all_subjects(Subjects),
    findall(Subject, expected_status(Subject, _), ExpectedSubjects),
    msort(Subjects, SortedSubjects),
    msort(ExpectedSubjects, SortedExpected),
    SortedSubjects == SortedExpected.
test(every_subject_resolves_to_its_expected_result) :-
    all_subjects(Subjects),
    maplist(subject_matches_expected, Subjects).
test(every_subject_has_exactly_one_answer) :-
    all_subjects(Subjects),
    maplist(subject_has_one_answer, Subjects).
test(every_subject_carries_the_fixed_citations_of_its_result) :-
    all_subjects(Subjects),
    maplist(subject_citations_fixed, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    all_subjects(Subjects),
    maplist(subject_checklist_non_empty, Subjects).
test(every_subject_is_resolvable) :-
    all_subjects(Subjects),
    maplist(subject_resolvable, Subjects).
test(status_projection_agrees_with_the_verdict) :-
    all_subjects(Subjects),
    maplist(subject_status_projection_agrees, Subjects).
test(significant_incident_criteria_agrees_on_every_subject) :-
    all_subjects(Subjects),
    maplist(subject_criteria_agrees, Subjects).
test(every_near_miss_control_gets_a_different_result) :-
    findall(Positive - Control, near_miss(Positive, Control), Pairs),
    maplist(near_miss_differs, Pairs).
test(the_final_result_vocabulary) :-
    nis2_implementing_regulation_significant_incidents_status_values(StatusValues),
    StatusValues == [significant, not_significant].
test(significant_incident_criteria_gives_significant) :-
    criteria_for_subject(loss_above_floor_not_scheduled, Result, Citations),
    Result == significant,
    Citations == [cite(eu_reg_2024_2690_art_3_1)].
test(significant_incident_criteria_gives_not_significant_when_scheduled) :-
    criteria_for_subject(scheduled_maintenance_with_loss, Result, Citations),
    Result == not_significant,
    Citations == [cite(eu_reg_2024_2690_art_3_1), cite(eu_reg_2024_2690_art_3_2)].
test(significant_incident_criteria_gives_not_significant_when_all_closed) :-
    criteria_for_subject(all_criteria_closed_dns, Result, Citations),
    Result == not_significant,
    Citations == [cite(eu_reg_2024_2690_art_3_1), cite(eu_reg_2024_2690_art_3_2)].
test(significant_incident_criteria_gives_indeterminate) :-
    criteria_for_subject(loss_above_floor_scheduled_absent, Result, Citations),
    Result == indeterminate([scheduled_interruption_or_maintenance]),
    Citations == [].
test(significant_incident_criteria_gives_needs_legal_review) :-
    criteria_for_subject(death_unsure_decisive, Result, Citations),
    expected_status(death_unsure_decisive, Expected),
    Result == Expected,
    Citations == [].
test(significant_incident_criteria_gives_input_problems) :-
    criteria_for_subject(duplicate_and_unknown_keys, Result, Citations),
    Result == input_problems([duplicate_key(scheduled_interruption_or_maintenance), unknown_key(colour)]),
    Citations == [].
test(significant_incident_criteria_on_an_empty_profile_asks_for_the_scheduled_key) :-
    findall(Result - Citations, significant_incident_criteria([], Result, Citations), Answers),
    Answers == [indeterminate([scheduled_interruption_or_maintenance]) - []].
test(significant_incident_criteria_on_an_unbound_profile) :-
    findall(Result - Citations, significant_incident_criteria(_Unbound, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(provenance_is_a_result_constructor) :-
    provenance(eu_reg_2024_2690_art_3_1, pinned_unit_text).
test(provenance_may_trail_a_legal_review_context) :-
    Context = [inputs_relied_on([death_of_natural_person - unsure]), provenance(eu_reg_2024_2690_art_3_1_c, author_reading)],
    Context = [inputs_relied_on(_Pairs), provenance(Source, Detail)],
    provenance(Source, Detail),
    Source == eu_reg_2024_2690_art_3_1_c.
test(scheduled_maintenance_is_not_significant) :-
    subject_status(scheduled_maintenance_with_loss, Status),
    Status == not_significant.
test(loss_above_floor_not_scheduled_is_significant) :-
    subject_status(loss_above_floor_not_scheduled, Status),
    Status == significant.
test(met_criterion_without_scheduled_key_asks_for_it) :-
    subject_status(loss_above_floor_scheduled_absent, Status),
    Status == indeterminate([scheduled_interruption_or_maintenance]).
test(loss_at_the_floor_is_not_significant) :-
    subject_status(loss_equal_floor_turnover_large, Status),
    Status == not_significant.
test(loss_one_cent_above_the_floor_is_significant) :-
    subject_status(loss_one_cent_above_floor_turnover_large, Status),
    Status == significant.
test(loss_above_five_percent_of_turnover_is_significant) :-
    subject_status(loss_above_five_percent_of_small_turnover, Status),
    Status == significant.
test(loss_at_five_percent_of_turnover_is_not_significant) :-
    subject_status(loss_at_five_percent_of_small_turnover, Status),
    Status == not_significant.
test(loss_below_floor_names_the_turnover) :-
    subject_status(loss_below_floor_turnover_absent, Status),
    Status == indeterminate([annual_turnover_preceding_financial_year_euro_cents]).
test(recurring_twice_is_significant) :-
    subject_status(recurring_twice_same_cause_collective_loss, Status),
    Status == significant.
test(recurring_once_is_not_significant) :-
    subject_status(recurring_once_same_cause_collective_loss, Status),
    Status == not_significant.
test(dns_outage_of_thirty_minutes_is_not_significant) :-
    subject_status(dns_outage_exactly_thirty_minutes, Status),
    Status == not_significant.
test(dns_outage_one_second_longer_is_significant) :-
    subject_status(dns_outage_thirty_minutes_one_second, Status),
    Status == significant.
test(dns_misconfiguration_exception_gives_not_significant) :-
    subject_status(dns_misconfiguration_exception_applies, Status),
    Status == not_significant.
test(dns_misconfiguration_above_one_percent_is_significant) :-
    subject_status(dns_misconfiguration_one_percent_exceeded, Status),
    Status == significant.
test(dns_misconfiguration_of_a_thousand_names_is_significant) :-
    subject_status(dns_misconfiguration_thousand_names, Status),
    Status == significant.
test(dns_misconfiguration_of_nine_hundred_ninety_nine_names_is_not_significant) :-
    subject_status(dns_misconfiguration_nine_hundred_ninety_nine_names, Status),
    Status == not_significant.
test(tld_any_complete_unavailability_is_significant) :-
    subject_status(tld_any_complete_unavailability, Status),
    Status == significant.
test(tld_no_complete_unavailability_is_not_significant) :-
    subject_status(tld_no_complete_unavailability, Status),
    Status == not_significant.
test(cloud_user_total_absent_is_named) :-
    subject_status(cloud_limited_availability_users_total_absent, Status),
    Status == indeterminate([service_users_in_union]).
test(cloud_above_five_percent_is_significant) :-
    subject_status(cloud_limited_availability_above_five_percent, Status),
    Status == significant.
test(cloud_at_five_percent_is_not_significant) :-
    subject_status(cloud_limited_availability_at_five_percent, Status),
    Status == not_significant.
test(cloud_exactly_one_hour_is_not_significant) :-
    subject_status(cloud_limited_availability_exactly_one_hour, Status),
    Status == not_significant.
test(cloud_over_one_million_users_is_significant) :-
    subject_status(cloud_limited_availability_over_one_million, Status),
    Status == significant.
test(cloud_one_million_users_of_a_large_base_is_not_significant) :-
    subject_status(cloud_limited_availability_one_million_large_base, Status),
    Status == not_significant.
test(data_centre_physical_access_is_significant) :-
    subject_status(data_centre_physical_access, Status),
    Status == significant.
test(data_centre_without_physical_access_is_not_significant) :-
    subject_status(data_centre_no_physical_access, Status),
    Status == not_significant.
test(marketplace_over_one_million_users_is_significant) :-
    subject_status(marketplace_complete_unavailability_over_one_million, Status),
    Status == significant.
test(marketplace_one_million_users_of_a_large_base_is_not_significant) :-
    subject_status(marketplace_complete_unavailability_one_million_large_base, Status),
    Status == not_significant.
test(trust_twenty_minutes_is_not_significant) :-
    subject_status(trust_unavailable_twenty_minutes, Status),
    Status == not_significant.
test(trust_twenty_minutes_one_second_is_significant) :-
    subject_status(trust_unavailable_twenty_minutes_one_second, Status),
    Status == significant.
test(trust_weekly_one_hour_is_not_significant) :-
    subject_status(trust_weekly_unavailability_one_hour, Status),
    Status == not_significant.
test(trust_weekly_one_hour_one_second_is_significant) :-
    subject_status(trust_weekly_unavailability_one_hour_one_second, Status),
    Status == significant.
test(trust_limited_availability_over_two_hundred_thousand_is_significant) :-
    subject_status(trust_limited_availability_over_two_hundred_thousand, Status),
    Status == significant.
test(trust_limited_availability_two_hundred_thousand_is_not_significant) :-
    subject_status(trust_limited_availability_two_hundred_thousand_large_base, Status),
    Status == not_significant.
test(trust_data_compromise_over_one_hundred_users_is_significant) :-
    subject_status(trust_data_compromise_over_one_hundred_users, Status),
    Status == significant.
test(trust_data_compromise_one_hundred_users_is_not_significant) :-
    subject_status(trust_data_compromise_one_hundred_users_large_base, Status),
    Status == not_significant.
test(entity_type_absent_all_closed_is_not_significant) :-
    subject_status(entity_type_absent_all_types_closed, Status),
    Status == not_significant.
test(entity_type_absent_open_names_the_type) :-
    subject_status(entity_type_absent_open, Status),
    Status == indeterminate([relevant_entity_type]).
test(decisive_unsure_death_goes_to_a_lawyer) :-
    subject_status(death_unsure_decisive, Status),
    Status = needs_legal_review(open_textured(Key, Citation), _Context),
    Key == death_of_natural_person,
    Citation == cite(eu_reg_2024_2690_art_3_1_c).
test(unsure_death_with_count_absent_names_the_count) :-
    subject_status(death_unsure_count_absent, Status),
    Status == indeterminate([recurring_incidents_within_six_months]).
test(unsure_data_compromise_is_referred_under_point_g) :-
    subject_status(data_compromised_unsure_tld, Status),
    Status = needs_legal_review(open_textured(Key, Citation), _Context),
    Key == data_compromised,
    Citation == cite(eu_reg_2024_2690_art_3_1_g).
test(unsure_judgement_that_does_not_turn_is_final) :-
    subject_status(unsure_irrelevant_loss_met, Status),
    Status == significant.
test(float_loss_is_a_wrong_type) :-
    subject_status(wrong_type_float_loss, Status),
    Status == input_problems([wrong_type(direct_financial_loss_euro_cents)]).
test(duplicate_then_unknown_keys) :-
    subject_status(duplicate_and_unknown_keys, Status),
    Status == input_problems([duplicate_key(scheduled_interruption_or_maintenance), unknown_key(colour)]).
test(a_pair_list_is_not_an_attribute_list) :-
    subject_status(profile_not_attribute_list, Status),
    Status == input_problems([wrong_type(profile)]).
test(an_unbound_profile_is_a_wrong_type_profile) :-
    findall(Status, nis2_implementing_regulation_significant_incidents_status(_Unbound, Status), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].

test(significant_incident_criteria_significant_is_not_not_significant, fail) :-
    criteria_for_subject(loss_above_floor_not_scheduled, not_significant, _).
test(significant_incident_criteria_scheduled_is_never_significant, fail) :-
    criteria_for_subject(scheduled_maintenance_with_loss, significant, _).
test(significant_incident_criteria_indeterminate_is_not_final, fail) :-
    criteria_for_subject(loss_above_floor_scheduled_absent, significant, _).
test(significant_incident_criteria_legal_review_is_not_final, fail) :-
    criteria_for_subject(death_unsure_decisive, not_significant, _).
test(significant_incident_criteria_input_problems_are_not_final, fail) :-
    criteria_for_subject(duplicate_and_unknown_keys, not_significant, _).
test(scheduled_maintenance_is_never_significant, fail) :-
    subject_status(scheduled_maintenance_with_loss, significant).
test(loss_above_floor_not_scheduled_is_not_not_significant, fail) :-
    subject_status(loss_above_floor_not_scheduled, not_significant).
test(met_criterion_without_scheduled_key_is_not_final, fail) :-
    subject_status(loss_above_floor_scheduled_absent, significant).
test(loss_at_the_floor_is_not_significant_only, fail) :-
    subject_status(loss_equal_floor_turnover_large, significant).
test(loss_at_five_percent_of_turnover_is_never_significant, fail) :-
    subject_status(loss_at_five_percent_of_small_turnover, significant).
test(recurring_once_is_never_significant, fail) :-
    subject_status(recurring_once_same_cause_collective_loss, significant).
test(dns_outage_of_thirty_minutes_is_never_significant, fail) :-
    subject_status(dns_outage_exactly_thirty_minutes, significant).
test(dns_misconfiguration_exception_is_never_significant, fail) :-
    subject_status(dns_misconfiguration_exception_applies, significant).
test(tld_no_complete_unavailability_is_never_significant, fail) :-
    subject_status(tld_no_complete_unavailability, significant).
test(cloud_exactly_one_hour_is_never_significant, fail) :-
    subject_status(cloud_limited_availability_exactly_one_hour, significant).
test(trust_twenty_minutes_is_never_significant, fail) :-
    subject_status(trust_unavailable_twenty_minutes, significant).
test(decisive_unsure_death_is_not_final, fail) :-
    subject_status(death_unsure_decisive, significant).
test(float_loss_gets_no_final_answer, fail) :-
    subject_status(wrong_type_float_loss, significant).

cp_test_names([every_subject_has_an_expected_result_and_no_more, every_subject_resolves_to_its_expected_result, every_subject_has_exactly_one_answer, every_subject_carries_the_fixed_citations_of_its_result, every_subject_has_a_non_empty_checklist, every_subject_is_resolvable, status_projection_agrees_with_the_verdict, significant_incident_criteria_agrees_on_every_subject, every_near_miss_control_gets_a_different_result, the_final_result_vocabulary, significant_incident_criteria_gives_significant, significant_incident_criteria_gives_not_significant_when_scheduled, significant_incident_criteria_gives_not_significant_when_all_closed, significant_incident_criteria_gives_indeterminate, significant_incident_criteria_gives_needs_legal_review, significant_incident_criteria_gives_input_problems, significant_incident_criteria_on_an_empty_profile_asks_for_the_scheduled_key, significant_incident_criteria_on_an_unbound_profile, provenance_is_a_result_constructor, provenance_may_trail_a_legal_review_context, scheduled_maintenance_is_not_significant, loss_above_floor_not_scheduled_is_significant, met_criterion_without_scheduled_key_asks_for_it, loss_at_the_floor_is_not_significant, loss_one_cent_above_the_floor_is_significant, loss_above_five_percent_of_turnover_is_significant, loss_at_five_percent_of_turnover_is_not_significant, loss_below_floor_names_the_turnover, recurring_twice_is_significant, recurring_once_is_not_significant, dns_outage_of_thirty_minutes_is_not_significant, dns_outage_one_second_longer_is_significant, dns_misconfiguration_exception_gives_not_significant, dns_misconfiguration_above_one_percent_is_significant, dns_misconfiguration_of_a_thousand_names_is_significant, dns_misconfiguration_of_nine_hundred_ninety_nine_names_is_not_significant, tld_any_complete_unavailability_is_significant, tld_no_complete_unavailability_is_not_significant, cloud_user_total_absent_is_named, cloud_above_five_percent_is_significant, cloud_at_five_percent_is_not_significant, cloud_exactly_one_hour_is_not_significant, cloud_over_one_million_users_is_significant, cloud_one_million_users_of_a_large_base_is_not_significant, data_centre_physical_access_is_significant, data_centre_without_physical_access_is_not_significant, marketplace_over_one_million_users_is_significant, marketplace_one_million_users_of_a_large_base_is_not_significant, trust_twenty_minutes_is_not_significant, trust_twenty_minutes_one_second_is_significant, trust_weekly_one_hour_is_not_significant, trust_weekly_one_hour_one_second_is_significant, trust_limited_availability_over_two_hundred_thousand_is_significant, trust_limited_availability_two_hundred_thousand_is_not_significant, trust_data_compromise_over_one_hundred_users_is_significant, trust_data_compromise_one_hundred_users_is_not_significant, entity_type_absent_all_closed_is_not_significant, entity_type_absent_open_names_the_type, decisive_unsure_death_goes_to_a_lawyer, unsure_death_with_count_absent_names_the_count, unsure_data_compromise_is_referred_under_point_g, unsure_judgement_that_does_not_turn_is_final, float_loss_is_a_wrong_type, duplicate_then_unknown_keys, a_pair_list_is_not_an_attribute_list, an_unbound_profile_is_a_wrong_type_profile]).
cp_test_fail_names([significant_incident_criteria_significant_is_not_not_significant, significant_incident_criteria_scheduled_is_never_significant, significant_incident_criteria_indeterminate_is_not_final, significant_incident_criteria_legal_review_is_not_final, significant_incident_criteria_input_problems_are_not_final, scheduled_maintenance_is_never_significant, loss_above_floor_not_scheduled_is_not_not_significant, met_criterion_without_scheduled_key_is_not_final, loss_at_the_floor_is_not_significant_only, loss_at_five_percent_of_turnover_is_never_significant, recurring_once_is_never_significant, dns_outage_of_thirty_minutes_is_never_significant, dns_misconfiguration_exception_is_never_significant, tld_no_complete_unavailability_is_never_significant, cloud_exactly_one_hour_is_never_significant, trust_twenty_minutes_is_never_significant, decisive_unsure_death_is_not_final, float_loss_gets_no_final_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
