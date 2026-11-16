% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_serious_incident_reporting_queries, [serious_incident_reporting_profile_keys/1, serious_incident_reporting_what_if/4, serious_incident_report_duty/4, serious_incident_report_timeliness/5]).
:- use_module(m__eu_ai_act_serious_incident_reporting_serious_incident_reporting, [serious_incident_reporting_status/2]).
:- use_module(m__eu_ai_act_serious_incident_reporting_fixtures, [serious_incident_reporting_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    serious_incident_reporting_profile_keys(ProfileKeys),
    ProfileKeys == [high_risk_classification, placed_before_chapter_iii_application_date, significant_change_in_design_since_that_date, intended_to_be_used_by_public_authorities, medical_device_or_safety_component_of_one, provider_subject_to_equivalent_union_reporting_obligations, harm_to_health, critical_infrastructure_disruption, fundamental_rights_obligations_infringed, serious_harm_to_property_or_environment, widespread_infringement, report_made_immediately].
test(status_query_gives_the_status) :-
    serious_incident_reporting_profile_for(device_without_point_c, Profile),
    serious_incident_reporting_status(duty_query(Profile, date(2028, 1, 10)), not_a_reportable_incident).
test(the_duty_names_recipient_period_last_day_and_follow_up) :-
    serious_incident_reporting_profile_for(device_with_point_c, Profile),
    findall(Duty, serious_incident_report_duty(Profile, date(2028, 1, 10), Duty, _), Duties),
    Duties == [report_due(national_competent_authority_chosen_by_member_state_where_incident_occurred, 15, date(2028, 1, 25), [perform_necessary_investigations_without_delay, risk_assessment_of_the_incident, corrective_action, cooperate_with_competent_authorities, inform_authorities_before_altering_the_system])].
test(the_deadline_query_judges_the_last_day_and_the_day_after) :-
    serious_incident_reporting_profile_for(report_on_last_day_made_immediately, Profile),
    serious_incident_report_timeliness(Profile, date(2028, 1, 1), date(2028, 1, 11), report_in_time, _),
    serious_incident_report_timeliness(Profile, date(2028, 1, 1), date(2028, 1, 12), report_after_time_limit, _).
test(the_deadline_query_answers_exactly_once) :-
    serious_incident_reporting_profile_for(report_on_last_day_made_immediately, Profile),
    findall(Verdict, serious_incident_report_timeliness(Profile, date(2028, 1, 1), date(2028, 1, 11), Verdict, _), Verdicts),
    Verdicts == [report_in_time].
test(what_if_a_property_harm_makes_the_incident_serious) :-
    serious_incident_reporting_profile_for(no_qualifying_harm, Profile),
    serious_incident_reporting_what_if(duty_query(Profile, date(2028, 1, 10)), serious_harm_to_property_or_environment, true, report_due(market_surveillance_authority_of_member_state_where_incident_occurred, 15, date(2028, 1, 25), _)).
test(what_if_a_death_shortens_the_limit) :-
    serious_incident_reporting_profile_for(harm_to_property, Profile),
    serious_incident_reporting_what_if(duty_query(Profile, date(2028, 1, 10)), harm_to_health, death_of_a_person, report_due(_, 10, date(2028, 1, 20), _)).
test(what_if_answers_exactly_once) :-
    serious_incident_reporting_profile_for(no_qualifying_harm, Profile),
    findall(Status, serious_incident_reporting_what_if(duty_query(Profile, date(2028, 1, 10)), critical_infrastructure_disruption, true, Status), Statuses),
    length(Statuses, 1).
test(what_if_the_report_was_made_immediately) :-
    serious_incident_reporting_profile_for(report_immediacy_missing, Profile),
    serious_incident_reporting_what_if(timeliness_query(Profile, date(2028, 1, 1), date(2028, 1, 11)), report_made_immediately, true, report_in_time).
test(what_if_the_immediacy_is_unsure) :-
    serious_incident_reporting_profile_for(report_immediacy_missing, Profile),
    serious_incident_reporting_what_if(timeliness_query(Profile, date(2028, 1, 1), date(2028, 1, 11)), report_made_immediately, unsure, needs_legal_review(open_textured(report_made_immediately, cite(eu_reg_2024_1689_art_73_2)), [inputs_relied_on([provider_subject_to_equivalent_union_reporting_obligations - false, widespread_infringement - false, report_made_immediately - unsure])])).
test(what_if_a_value_outside_its_type_is_an_input_problem) :-
    serious_incident_reporting_profile_for(no_qualifying_harm, Profile),
    serious_incident_reporting_what_if(duty_query(Profile, date(2028, 1, 10)), harm_to_health, maybe, input_problems([wrong_type(harm_to_health)])).

test(what_if_a_report_is_not_due_it_is_not_late, fail) :-
    serious_incident_reporting_profile_for(report_on_last_day_made_immediately, Profile),
    serious_incident_reporting_what_if(timeliness_query(Profile, date(2028, 1, 1), date(2028, 1, 12)), high_risk_classification, not_high_risk, report_after_time_limit).

cp_test_names([profile_keys_are_the_contract_keys, status_query_gives_the_status, the_duty_names_recipient_period_last_day_and_follow_up, the_deadline_query_judges_the_last_day_and_the_day_after, the_deadline_query_answers_exactly_once, what_if_a_property_harm_makes_the_incident_serious, what_if_a_death_shortens_the_limit, what_if_answers_exactly_once, what_if_the_report_was_made_immediately, what_if_the_immediacy_is_unsure, what_if_a_value_outside_its_type_is_an_input_problem]).
cp_test_fail_names([what_if_a_report_is_not_due_it_is_not_late]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
