% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_serious_incident_reporting, [decide_serious_incident_reporting/2, serious_incident_reporting_status/2, serious_incident_reporting_checklist/2, serious_incident_reporting_decision_resolvable/1, serious_incident_reporting_status_values/1]).
:- use_module(m__eu_ai_act_serious_incident_reporting_fixtures, [serious_incident_reporting_subject/1, serious_incident_reporting_profile_for/2, serious_incident_reporting_assess/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_queries, [serious_incident_report_duty/4, serious_incident_report_timeliness/5, serious_incident_reporting_what_if/4, provenance/2, report_due/4, indeterminate/1, needs_legal_review/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(m__eu_ai_act_serious_incident_reporting_kernel, [serious_incident_reporting_input_problems/2]).

expected_follow_up([perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system]).

assessed(Subject, Status, Citations) :-
    findall(AnswerStatus - AnswerCitations, serious_incident_reporting_assess(Subject, serious_incident_reporting_verdict(AnswerStatus, AnswerCitations)), Results),
    Results = [Status - Citations].

same_citations(Citations, ExpectedCitations) :-
    sort(Citations, SortedCitations),
    sort(ExpectedCitations, SortedCitations).

has_one_answer(Subject) :-
    findall(Result, serious_incident_reporting_assess(Subject, Result), Results),
    length(Results, 1).

vocabulary_citation(cite(CitationKey)) :-
    member(CitationKey, [eu_reg_2024_1689_art_3_49, eu_reg_2024_1689_art_3_49_c, eu_reg_2024_1689_art_3_61, eu_reg_2024_1689_art_73_1, eu_reg_2024_1689_art_73_2, eu_reg_2024_1689_art_73_3, eu_reg_2024_1689_art_73_4, eu_reg_2024_1689_art_73_6, eu_reg_2024_1689_art_73_9, eu_reg_2024_1689_art_73_10, eu_reg_2024_1689_art_111_2, eu_reg_2024_1689_art_113_c, eu_reg_2024_1689_art_113_c_i, eu_reg_2024_1689_art_113_c_ii]).

subject_citations_in_vocabulary(Subject) :-
    assessed(Subject, _, Citations),
    maplist(vocabulary_citation, Citations).

test(before_annex_iii_application_date_is_not_applicable) :-
    assessed(before_annex_iii_application_date, not_applicable_on_date, Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i)]).
test(on_annex_iii_application_date_the_report_is_due_in_ten_days) :-
    expected_follow_up(FollowUp),
    assessed(on_annex_iii_application_date, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2027, 12, 12), FollowUp), Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(annex_i_before_its_application_date_is_not_applicable) :-
    assessed(annex_i_before_application_date, not_applicable_on_date, Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_ii)]).
test(annex_i_on_its_application_date_reports_in_two_days) :-
    expected_follow_up(FollowUp),
    assessed(annex_i_on_application_date, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 2, date(2028, 8, 4), FollowUp), Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_3), cite(eu_reg_2024_1689_art_73_6)]).
test(a_system_that_is_not_high_risk_has_no_duty) :-
    assessed(not_high_risk_system, not_a_high_risk_ai_system, [cite(eu_reg_2024_1689_art_73_1)]).
test(a_missing_classification_is_named) :-
    assessed(classification_missing, indeterminate([high_risk_classification]), []).
test(early_unchanged_public_system_before_2030_is_not_covered) :-
    assessed(early_unchanged_public_day_before_2030, not_covered_placed_before_application_date, [cite(eu_reg_2024_1689_art_111_2)]).
test(early_unchanged_public_system_on_2030_is_covered) :-
    expected_follow_up(FollowUp),
    assessed(early_unchanged_public_on_2030, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2030, 8, 12), FollowUp), Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(an_early_system_with_a_significant_change_is_covered) :-
    expected_follow_up(FollowUp),
    assessed(early_significantly_changed, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2029, 3, 11), FollowUp), _).
test(a_missing_placement_is_named) :-
    assessed(placement_missing, indeterminate([placed_before_chapter_iii_application_date]), []).
test(two_days_reach_a_leap_day) :-
    expected_follow_up(FollowUp),
    assessed(leap_day_critical_infrastructure, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 2, date(2028, 2, 29), FollowUp), Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_3), cite(eu_reg_2024_1689_art_73_6)]).
test(fifteen_days_cross_the_year) :-
    expected_follow_up(FollowUp),
    assessed(year_crossing_general_limit, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 15, date(2028, 1, 4), FollowUp), Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_2), cite(eu_reg_2024_1689_art_73_6)]).
test(awareness_on_a_leap_day_counts_ten_days) :-
    expected_follow_up(FollowUp),
    assessed(awareness_on_leap_day, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2028, 3, 10), FollowUp), _).
test(no_qualifying_harm_is_not_a_serious_incident) :-
    assessed(no_qualifying_harm, not_a_serious_incident, [cite(eu_reg_2024_1689_art_3_49)]).
test(harm_to_property_is_a_serious_incident) :-
    expected_follow_up(FollowUp),
    assessed(harm_to_property, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 15, date(2028, 1, 25), FollowUp), Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_2), cite(eu_reg_2024_1689_art_73_6)]).
test(a_device_without_point_c_is_not_reportable) :-
    assessed(device_without_point_c, not_a_reportable_incident, Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_10), cite(eu_reg_2024_1689_art_3_49_c)]).
test(a_device_with_point_c_reports_to_the_national_authority) :-
    expected_follow_up(FollowUp),
    assessed(device_with_point_c, report_due(national_competent_authority_chosen_by_member_state_where_incident_occurred, 15, date(2028, 1, 25), FollowUp), Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_2), cite(eu_reg_2024_1689_art_73_6), cite(eu_reg_2024_1689_art_73_10)]).
test(equivalent_obligations_without_point_c_are_not_reportable) :-
    assessed(equivalent_obligations_without_point_c, not_a_reportable_incident, Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_9), cite(eu_reg_2024_1689_art_3_49_c)]).
test(equivalent_obligations_with_point_c_are_reported) :-
    expected_follow_up(FollowUp),
    assessed(equivalent_obligations_with_point_c, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2028, 1, 20), FollowUp), Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(a_report_on_the_last_day_made_immediately_is_in_time) :-
    assessed(report_on_last_day_made_immediately, report_in_time, Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(a_report_the_day_after_the_last_day_is_late) :-
    assessed(report_day_after_last_day, report_after_time_limit, Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(a_report_on_the_last_day_not_made_immediately) :-
    assessed(report_on_last_day_not_immediate, report_not_immediate, _).
test(a_missing_immediacy_is_named) :-
    assessed(report_immediacy_missing, indeterminate([report_made_immediately]), []).
test(an_unsure_immediacy_goes_to_a_lawyer) :-
    assessed(report_immediacy_unsure, needs_legal_review(open_textured(report_made_immediately, cite(eu_reg_2024_1689_art_73_2)), [inputs_relied_on([provider_subject_to_equivalent_union_reporting_obligations - false, widespread_infringement - false, report_made_immediately - unsure])]), []).
test(a_late_report_with_unsure_immediacy_is_late) :-
    assessed(late_report_immediacy_unsure, report_after_time_limit, _).
test(a_report_before_awareness_is_judged_in_time) :-
    assessed(report_before_awareness, report_in_time, _).
test(timeliness_passes_a_no_duty_answer_through) :-
    assessed(timeliness_not_high_risk, not_a_high_risk_ai_system, [cite(eu_reg_2024_1689_art_73_1)]).
test(an_unsure_widespread_infringement_that_does_not_matter_is_settled) :-
    expected_follow_up(FollowUp),
    assessed(widespread_unsure_with_critical_infrastructure, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 2, date(2028, 1, 12), FollowUp), Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_3), cite(eu_reg_2024_1689_art_73_6)]).
test(a_missing_fact_is_named_before_a_referral) :-
    assessed(widespread_unsure_health_missing, indeterminate([harm_to_health]), []).
test(an_unsure_widespread_infringement_that_turns_the_limit_is_referred) :-
    assessed(widespread_unsure_turns_the_limit, needs_legal_review(open_textured(widespread_infringement, cite(eu_reg_2024_1689_art_3_61)), [inputs_relied_on([widespread_infringement - unsure])]), []).
test(an_unsure_significant_change_of_an_early_system_is_referred) :-
    assessed(significant_change_unsure_placed_early, needs_legal_review(open_textured(significant_change_in_design_since_that_date, cite(eu_reg_2024_1689_art_111_2)), [inputs_relied_on([significant_change_in_design_since_that_date - unsure, provider_subject_to_equivalent_union_reporting_obligations - false, widespread_infringement - false])]), []).
test(an_unsure_significant_change_of_a_late_system_does_not_matter) :-
    expected_follow_up(FollowUp),
    assessed(significant_change_unsure_placed_late, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2029, 3, 11), FollowUp), _).
test(an_unsure_equivalence_without_point_c_is_referred) :-
    assessed(equivalence_unsure_without_point_c, needs_legal_review(open_textured(provider_subject_to_equivalent_union_reporting_obligations, cite(eu_reg_2024_1689_art_73_9)), [inputs_relied_on([provider_subject_to_equivalent_union_reporting_obligations - unsure, widespread_infringement - false])]), []).
test(an_unsure_equivalence_with_point_c_does_not_matter) :-
    expected_follow_up(FollowUp),
    assessed(equivalence_unsure_with_point_c, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2028, 1, 20), FollowUp), Citations),
    same_citations(Citations, [cite(eu_reg_2024_1689_art_73_1), cite(eu_reg_2024_1689_art_73_4), cite(eu_reg_2024_1689_art_73_6)]).
test(the_provenance_constructor_marks_a_deciding_clause) :-
    provenance(limit_route, [cite(eu_reg_2024_1689_art_73_3)]).
test(a_referral_context_may_end_with_provenance) :-
    Context = [inputs_relied_on([widespread_infringement - unsure]), provenance(limit_route, [cite(eu_reg_2024_1689_art_3_61)])],
    last(Context, provenance(DecidingClause, ClauseCitations)),
    provenance(DecidingClause, ClauseCitations),
    DecidingClause == limit_route.
test(the_report_due_constructor_holds_for_a_contract_term) :-
    report_due(national_competent_authority_chosen_by_member_state_where_incident_occurred, 15, date(2028, 1, 25), [perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system]).
test(the_indeterminate_constructor_holds_for_a_contract_key) :-
    indeterminate([report_made_immediately]).
test(the_needs_legal_review_constructor_holds_for_a_referral) :-
    needs_legal_review(open_textured(significant_change_in_design_since_that_date, cite(eu_reg_2024_1689_art_111_2)), [inputs_relied_on([significant_change_in_design_since_that_date - unsure])]).
test(the_input_problems_constructor_holds_for_problem_terms) :-
    input_problems([duplicate_key(high_risk_classification), wrong_type(report_date), unknown_key(colour)]).
test(the_unknown_key_constructor_holds_for_a_key_outside_the_contract) :-
    unknown_key(colour).
test(the_wrong_type_constructor_holds_for_a_date_argument) :-
    wrong_type(awareness_date).
test(the_wrong_type_constructor_holds_for_a_contract_key) :-
    wrong_type(harm_to_health).
test(the_duplicate_key_constructor_holds_for_a_contract_key) :-
    duplicate_key(high_risk_classification).
test(a_duplicate_key_is_an_input_problem) :-
    assessed(duplicate_classification, input_problems([duplicate_key(high_risk_classification)]), []).
test(an_unknown_key_is_an_input_problem) :-
    assessed(unknown_key_present, input_problems([unknown_key(colour)]), []).
test(a_crisp_key_given_unsure_is_wrong_type) :-
    assessed(crisp_key_given_unsure, input_problems([wrong_type(critical_infrastructure_disruption)]), []).
test(an_awareness_date_that_is_not_a_date_is_wrong_type) :-
    assessed(awareness_date_not_a_date, input_problems([wrong_type(awareness_date)]), []).
test(profile_problems_come_before_date_problems) :-
    assessed(profile_and_date_problems, input_problems([wrong_type(critical_infrastructure_disruption), wrong_type(awareness_date)]), []).
test(a_report_date_that_is_not_a_date_is_wrong_type) :-
    assessed(report_date_not_a_date, input_problems([wrong_type(report_date)]), []).
test(a_well_formed_profile_has_no_problem) :-
    serious_incident_reporting_profile_for(on_annex_iii_application_date, Profile),
    serious_incident_reporting_input_problems(Profile, []).
test(a_partial_list_is_wrong_type_profile) :-
    findall(Problems, serious_incident_reporting_input_problems([attribute(harm_to_health, death_of_a_person)|_Tail], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_number_key_is_an_unknown_key) :-
    serious_incident_reporting_input_problems([attribute(1, true)], [unknown_key(1)]).
test(an_unbound_key_is_an_unknown_key) :-
    serious_incident_reporting_input_problems([attribute(GivenKey, true)], Problems),
    Problems = [unknown_key(NamedKey)],
    NamedKey == GivenKey.
test(a_value_outside_its_type_is_wrong_type) :-
    serious_incident_reporting_input_problems([attribute(harm_to_health, maybe)], [wrong_type(harm_to_health)]).
test(the_contract_queries_refuse_a_bad_profile) :-
    serious_incident_report_duty([attribute(widespread_infringement, maybe)], date(2028, 1, 10), input_problems([wrong_type(widespread_infringement)]), []),
    serious_incident_report_timeliness([attribute(widespread_infringement, maybe)], date(2028, 1, 10), date(2028, 1, 11), input_problems([wrong_type(widespread_infringement)]), []).
test(what_if_a_harm_to_property_makes_the_report_due) :-
    serious_incident_reporting_profile_for(no_qualifying_harm, Profile),
    expected_follow_up(FollowUp),
    serious_incident_reporting_what_if(duty_query(Profile, date(2028, 1, 10)), serious_harm_to_property_or_environment, true, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 15, date(2028, 1, 25), FollowUp)).
test(what_if_a_bad_value_is_an_input_problem) :-
    serious_incident_reporting_profile_for(no_qualifying_harm, Profile),
    serious_incident_reporting_what_if(duty_query(Profile, date(2028, 1, 10)), harm_to_health, maybe, input_problems([wrong_type(harm_to_health)])).
test(the_facade_decides_a_fixture_profile) :-
    serious_incident_reporting_profile_for(on_annex_iii_application_date, Profile),
    decide_serious_incident_reporting(duty_query(Profile, date(2027, 12, 2)), serious_incident_reporting_verdict(report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 10, date(2027, 12, 12), _), _)).
test(the_facade_status_of_a_no_harm_profile) :-
    serious_incident_reporting_profile_for(no_qualifying_harm, Profile),
    serious_incident_reporting_status(duty_query(Profile, date(2028, 1, 10)), not_a_serious_incident).
test(the_checklist_is_not_empty_and_ends_on_the_report) :-
    serious_incident_reporting_profile_for(on_annex_iii_application_date, Profile),
    serious_incident_reporting_checklist(duty_query(Profile, date(2027, 12, 2)), [FirstItem|OtherItems]),
    last([FirstItem|OtherItems], item(report, met, _)).
test(the_checklist_names_the_deciding_ground) :-
    serious_incident_reporting_profile_for(no_qualifying_harm, Profile),
    serious_incident_reporting_checklist(duty_query(Profile, date(2028, 1, 10)), Items),
    last(Items, item(serious_incident, unmet(not_a_serious_incident), _)).
test(a_fixture_decision_is_resolvable) :-
    serious_incident_reporting_profile_for(harm_to_property, Profile),
    serious_incident_reporting_decision_resolvable(duty_query(Profile, date(2028, 1, 10))).
test(final_answers_are_in_the_status_vocabulary) :-
    serious_incident_reporting_status_values(StatusValues),
    assessed(on_annex_iii_application_date, DueStatus, _),
    functor(DueStatus, DueName, _),
    member(DueName, StatusValues),
    assessed(no_qualifying_harm, NoDutyStatus, _),
    member(NoDutyStatus, StatusValues).
test(every_subject_has_exactly_one_answer) :-
    findall(Subject, serious_incident_reporting_subject(Subject), SubjectList),
    SubjectList = [_|_],
    maplist(has_one_answer, SubjectList).
test(every_subject_is_registered_once) :-
    findall(Subject, serious_incident_reporting_subject(Subject), SubjectList),
    sort(SubjectList, SortedSubjects),
    length(SubjectList, SubjectCount),
    length(SortedSubjects, SubjectCount).
test(every_citation_is_in_the_vocabulary) :-
    findall(Subject, serious_incident_reporting_subject(Subject), SubjectList),
    maplist(subject_citations_in_vocabulary, SubjectList).

test(before_annex_iii_application_date_owes_no_report, fail) :-
    assessed(before_annex_iii_application_date, report_due(_, _, _, _), _).
test(on_annex_iii_application_date_is_not_inapplicable, fail) :-
    assessed(on_annex_iii_application_date, not_applicable_on_date, _).
test(annex_i_on_its_application_date_is_not_inapplicable, fail) :-
    assessed(annex_i_on_application_date, not_applicable_on_date, _).
test(a_system_that_is_not_high_risk_owes_no_report, fail) :-
    assessed(not_high_risk_system, report_due(_, _, _, _), _).
test(early_unchanged_public_system_before_2030_owes_no_report, fail) :-
    assessed(early_unchanged_public_day_before_2030, report_due(_, _, _, _), _).
test(early_unchanged_public_system_on_2030_is_not_excluded, fail) :-
    assessed(early_unchanged_public_on_2030, not_covered_placed_before_application_date, _).
test(two_days_do_not_end_on_the_first_of_march, fail) :-
    assessed(leap_day_critical_infrastructure, report_due(_, _, date(2028, 3, 1), _), _).
test(serious_harm_without_death_is_not_ten_days, fail) :-
    assessed(year_crossing_general_limit, report_due(_, 10, _, _), _).
test(no_qualifying_harm_owes_no_report, fail) :-
    assessed(no_qualifying_harm, report_due(_, _, _, _), _).
test(harm_to_property_is_not_excluded, fail) :-
    assessed(harm_to_property, not_a_serious_incident, _).
test(a_device_without_point_c_owes_no_report, fail) :-
    assessed(device_without_point_c, report_due(_, _, _, _), _).
test(a_device_with_point_c_does_not_report_to_market_surveillance, fail) :-
    assessed(device_with_point_c, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, _, _, _), _).
test(equivalent_obligations_with_point_c_are_not_excluded, fail) :-
    assessed(equivalent_obligations_with_point_c, not_a_reportable_incident, _).
test(a_report_on_the_last_day_is_not_late, fail) :-
    assessed(report_on_last_day_made_immediately, report_after_time_limit, _).
test(a_report_the_day_after_the_last_day_is_not_in_time, fail) :-
    assessed(report_day_after_last_day, report_in_time, _).
test(a_missing_fact_case_is_not_referred, fail) :-
    assessed(widespread_unsure_health_missing, needs_legal_review(_, _), _).
test(the_report_due_constructor_refuses_another_recipient, fail) :-
    report_due(the_commission, 15, date(2028, 1, 25), [perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system]).
test(the_indeterminate_constructor_refuses_another_key, fail) :-
    indeterminate([colour]).
test(the_needs_legal_review_constructor_refuses_a_wrong_citation, fail) :-
    needs_legal_review(open_textured(widespread_infringement, cite(eu_reg_2024_1689_art_73_1)), [inputs_relied_on([widespread_infringement - unsure])]).
test(the_input_problems_constructor_refuses_an_empty_list, fail) :-
    input_problems([]).
test(the_unknown_key_constructor_refuses_a_contract_key, fail) :-
    unknown_key(harm_to_health).
test(the_wrong_type_constructor_refuses_another_term, fail) :-
    wrong_type(colour).
test(the_duplicate_key_constructor_refuses_another_key, fail) :-
    duplicate_key(colour).

cp_test_names([before_annex_iii_application_date_is_not_applicable, on_annex_iii_application_date_the_report_is_due_in_ten_days, annex_i_before_its_application_date_is_not_applicable, annex_i_on_its_application_date_reports_in_two_days, a_system_that_is_not_high_risk_has_no_duty, a_missing_classification_is_named, early_unchanged_public_system_before_2030_is_not_covered, early_unchanged_public_system_on_2030_is_covered, an_early_system_with_a_significant_change_is_covered, a_missing_placement_is_named, two_days_reach_a_leap_day, fifteen_days_cross_the_year, awareness_on_a_leap_day_counts_ten_days, no_qualifying_harm_is_not_a_serious_incident, harm_to_property_is_a_serious_incident, a_device_without_point_c_is_not_reportable, a_device_with_point_c_reports_to_the_national_authority, equivalent_obligations_without_point_c_are_not_reportable, equivalent_obligations_with_point_c_are_reported, a_report_on_the_last_day_made_immediately_is_in_time, a_report_the_day_after_the_last_day_is_late, a_report_on_the_last_day_not_made_immediately, a_missing_immediacy_is_named, an_unsure_immediacy_goes_to_a_lawyer, a_late_report_with_unsure_immediacy_is_late, a_report_before_awareness_is_judged_in_time, timeliness_passes_a_no_duty_answer_through, an_unsure_widespread_infringement_that_does_not_matter_is_settled, a_missing_fact_is_named_before_a_referral, an_unsure_widespread_infringement_that_turns_the_limit_is_referred, an_unsure_significant_change_of_an_early_system_is_referred, an_unsure_significant_change_of_a_late_system_does_not_matter, an_unsure_equivalence_without_point_c_is_referred, an_unsure_equivalence_with_point_c_does_not_matter, the_provenance_constructor_marks_a_deciding_clause, a_referral_context_may_end_with_provenance, the_report_due_constructor_holds_for_a_contract_term, the_indeterminate_constructor_holds_for_a_contract_key, the_needs_legal_review_constructor_holds_for_a_referral, the_input_problems_constructor_holds_for_problem_terms, the_unknown_key_constructor_holds_for_a_key_outside_the_contract, the_wrong_type_constructor_holds_for_a_date_argument, the_wrong_type_constructor_holds_for_a_contract_key, the_duplicate_key_constructor_holds_for_a_contract_key, a_duplicate_key_is_an_input_problem, an_unknown_key_is_an_input_problem, a_crisp_key_given_unsure_is_wrong_type, an_awareness_date_that_is_not_a_date_is_wrong_type, profile_problems_come_before_date_problems, a_report_date_that_is_not_a_date_is_wrong_type, a_well_formed_profile_has_no_problem, a_partial_list_is_wrong_type_profile, a_number_key_is_an_unknown_key, an_unbound_key_is_an_unknown_key, a_value_outside_its_type_is_wrong_type, the_contract_queries_refuse_a_bad_profile, what_if_a_harm_to_property_makes_the_report_due, what_if_a_bad_value_is_an_input_problem, the_facade_decides_a_fixture_profile, the_facade_status_of_a_no_harm_profile, the_checklist_is_not_empty_and_ends_on_the_report, the_checklist_names_the_deciding_ground, a_fixture_decision_is_resolvable, final_answers_are_in_the_status_vocabulary, every_subject_has_exactly_one_answer, every_subject_is_registered_once, every_citation_is_in_the_vocabulary]).
cp_test_fail_names([before_annex_iii_application_date_owes_no_report, on_annex_iii_application_date_is_not_inapplicable, annex_i_on_its_application_date_is_not_inapplicable, a_system_that_is_not_high_risk_owes_no_report, early_unchanged_public_system_before_2030_owes_no_report, early_unchanged_public_system_on_2030_is_not_excluded, two_days_do_not_end_on_the_first_of_march, serious_harm_without_death_is_not_ten_days, no_qualifying_harm_owes_no_report, harm_to_property_is_not_excluded, a_device_without_point_c_owes_no_report, a_device_with_point_c_does_not_report_to_market_surveillance, equivalent_obligations_with_point_c_are_not_excluded, a_report_on_the_last_day_is_not_late, a_report_the_day_after_the_last_day_is_not_in_time, a_missing_fact_case_is_not_referred, the_report_due_constructor_refuses_another_recipient, the_indeterminate_constructor_refuses_another_key, the_needs_legal_review_constructor_refuses_a_wrong_citation, the_input_problems_constructor_refuses_an_empty_list, the_unknown_key_constructor_refuses_a_contract_key, the_wrong_type_constructor_refuses_another_term, the_duplicate_key_constructor_refuses_another_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
