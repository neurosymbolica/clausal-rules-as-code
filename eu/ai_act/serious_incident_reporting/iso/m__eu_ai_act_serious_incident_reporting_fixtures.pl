% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_serious_incident_reporting_fixtures, [serious_incident_reporting_subject/1, serious_incident_reporting_profile_for/2, serious_incident_reporting_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_serious_incident_reporting_queries, [serious_incident_report_duty/4, serious_incident_report_timeliness/5]).

base_profile(annex_iii_death, [attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, false), attribute(harm_to_health, death_of_a_person), attribute(critical_infrastructure_disruption, false), attribute(fundamental_rights_obligations_infringed, false), attribute(serious_harm_to_property_or_environment, false), attribute(widespread_infringement, false)]).
base_profile(annex_iii_serious_harm, [attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, false), attribute(harm_to_health, serious_harm_to_health_without_death), attribute(critical_infrastructure_disruption, false), attribute(fundamental_rights_obligations_infringed, false), attribute(serious_harm_to_property_or_environment, false), attribute(widespread_infringement, false)]).
base_profile(annex_iii_no_harm, [attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, false), attribute(harm_to_health, no_death_or_serious_harm_to_health), attribute(critical_infrastructure_disruption, false), attribute(fundamental_rights_obligations_infringed, false), attribute(serious_harm_to_property_or_environment, false), attribute(widespread_infringement, false)]).
base_profile(annex_iii_infrastructure, [attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, false), attribute(harm_to_health, no_death_or_serious_harm_to_health), attribute(critical_infrastructure_disruption, true), attribute(fundamental_rights_obligations_infringed, false), attribute(serious_harm_to_property_or_environment, false), attribute(widespread_infringement, false)]).
base_profile(annex_i_infrastructure, [attribute(high_risk_classification, annex_i_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(harm_to_health, no_death_or_serious_harm_to_health), attribute(critical_infrastructure_disruption, true), attribute(fundamental_rights_obligations_infringed, false), attribute(serious_harm_to_property_or_environment, false), attribute(widespread_infringement, false)]).

with_value(BaseProfile, ProfileKey, NewValue, Profile) :-
    without_attribute(BaseProfile, ProfileKey, Remaining),
    append(Remaining, [attribute(ProfileKey, NewValue)], Profile).

without_attribute([], _, []).
without_attribute([attribute(ElementKey, ElementValue)|Elements], ProfileKey, [attribute(ElementKey, ElementValue)|Remaining]) :-
    ElementKey \== ProfileKey,
    without_attribute(Elements, ProfileKey, Remaining).
without_attribute([attribute(ElementKey, _)|Elements], ProfileKey, Remaining) :-
    ElementKey == ProfileKey,
    without_attribute(Elements, ProfileKey, Remaining).

fixture_case(before_annex_iii_application_date, Profile, duty(date(2027, 12, 1))) :-
    base_profile(annex_iii_death, Profile).
fixture_case(on_annex_iii_application_date, Profile, duty(date(2027, 12, 2))) :-
    base_profile(annex_iii_death, Profile).
fixture_case(annex_i_before_application_date, Profile, duty(date(2028, 8, 1))) :-
    base_profile(annex_i_infrastructure, Profile).
fixture_case(annex_i_on_application_date, Profile, duty(date(2028, 8, 2))) :-
    base_profile(annex_i_infrastructure, Profile).
fixture_case(not_high_risk_system, [attribute(high_risk_classification, not_high_risk)], duty(date(2028, 1, 10))).
fixture_case(classification_missing, [], duty(date(2028, 1, 10))).
fixture_case(early_unchanged_public_day_before_2030, Profile, duty(date(2030, 8, 1))) :-
    early_unchanged_public_profile(Profile).
fixture_case(early_unchanged_public_on_2030, Profile, duty(date(2030, 8, 2))) :-
    early_unchanged_public_profile(Profile).
fixture_case(early_significantly_changed, Profile, duty(date(2029, 3, 1))) :-
    base_profile(annex_iii_death, BaseProfile),
    with_value(BaseProfile, placed_before_chapter_iii_application_date, true, PlacedProfile),
    with_value(PlacedProfile, significant_change_in_design_since_that_date, true, Profile).
fixture_case(placement_missing, [attribute(high_risk_classification, annex_iii_high_risk)], duty(date(2028, 1, 10))).
fixture_case(leap_day_critical_infrastructure, Profile, duty(date(2028, 2, 27))) :-
    base_profile(annex_iii_infrastructure, Profile).
fixture_case(year_crossing_general_limit, Profile, duty(date(2027, 12, 20))) :-
    base_profile(annex_iii_serious_harm, Profile).
fixture_case(no_qualifying_harm, Profile, duty(date(2028, 1, 10))) :-
    base_profile(annex_iii_no_harm, Profile).
fixture_case(harm_to_property, Profile, duty(date(2028, 1, 10))) :-
    base_profile(annex_iii_no_harm, BaseProfile),
    with_value(BaseProfile, serious_harm_to_property_or_environment, true, Profile).
fixture_case(device_without_point_c, [attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, true), attribute(harm_to_health, death_of_a_person), attribute(fundamental_rights_obligations_infringed, false)], duty(date(2028, 1, 10))).
fixture_case(device_with_point_c, [attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, true), attribute(harm_to_health, no_death_or_serious_harm_to_health), attribute(critical_infrastructure_disruption, false), attribute(fundamental_rights_obligations_infringed, true), attribute(widespread_infringement, false)], duty(date(2028, 1, 10))).
fixture_case(equivalent_obligations_without_point_c, [attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, true), attribute(harm_to_health, death_of_a_person), attribute(fundamental_rights_obligations_infringed, false)], duty(date(2028, 1, 10))).
fixture_case(equivalent_obligations_with_point_c, [attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(provider_subject_to_equivalent_union_reporting_obligations, true), attribute(harm_to_health, death_of_a_person), attribute(critical_infrastructure_disruption, false), attribute(fundamental_rights_obligations_infringed, true), attribute(widespread_infringement, false)], duty(date(2028, 1, 10))).
fixture_case(report_on_last_day_made_immediately, Profile, timeliness(date(2028, 1, 1), date(2028, 1, 11))) :-
    immediacy_profile(true, Profile).
fixture_case(report_day_after_last_day, Profile, timeliness(date(2028, 1, 1), date(2028, 1, 12))) :-
    immediacy_profile(true, Profile).
fixture_case(report_on_last_day_not_immediate, Profile, timeliness(date(2028, 1, 1), date(2028, 1, 11))) :-
    immediacy_profile(false, Profile).
fixture_case(report_immediacy_missing, Profile, timeliness(date(2028, 1, 1), date(2028, 1, 11))) :-
    base_profile(annex_iii_death, Profile).
fixture_case(report_immediacy_unsure, Profile, timeliness(date(2028, 1, 1), date(2028, 1, 11))) :-
    immediacy_profile(unsure, Profile).
fixture_case(late_report_immediacy_unsure, Profile, timeliness(date(2028, 1, 1), date(2028, 1, 12))) :-
    immediacy_profile(unsure, Profile).
fixture_case(report_before_awareness, Profile, timeliness(date(2028, 1, 1), date(2027, 12, 30))) :-
    immediacy_profile(true, Profile).
fixture_case(timeliness_not_high_risk, [attribute(high_risk_classification, not_high_risk), attribute(report_made_immediately, true)], timeliness(date(2028, 1, 10), date(2028, 1, 11))).
fixture_case(widespread_unsure_with_critical_infrastructure, Profile, duty(date(2028, 1, 10))) :-
    base_profile(annex_iii_infrastructure, BaseProfile),
    with_value(BaseProfile, widespread_infringement, unsure, Profile).
fixture_case(widespread_unsure_health_missing, [attribute(high_risk_classification, annex_iii_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(critical_infrastructure_disruption, false), attribute(fundamental_rights_obligations_infringed, true), attribute(widespread_infringement, unsure)], duty(date(2028, 1, 10))).
fixture_case(widespread_unsure_turns_the_limit, [attribute(high_risk_classification, annex_i_high_risk), attribute(placed_before_chapter_iii_application_date, false), attribute(medical_device_or_safety_component_of_one, false), attribute(harm_to_health, serious_harm_to_health_without_death), attribute(critical_infrastructure_disruption, false), attribute(fundamental_rights_obligations_infringed, false), attribute(serious_harm_to_property_or_environment, false), attribute(widespread_infringement, unsure)], duty(date(2028, 9, 1))).
fixture_case(significant_change_unsure_placed_early, Profile, duty(date(2029, 3, 1))) :-
    base_profile(annex_iii_death, BaseProfile),
    with_value(BaseProfile, placed_before_chapter_iii_application_date, true, PlacedProfile),
    with_value(PlacedProfile, significant_change_in_design_since_that_date, unsure, Profile).
fixture_case(significant_change_unsure_placed_late, Profile, duty(date(2029, 3, 1))) :-
    base_profile(annex_iii_death, BaseProfile),
    with_value(BaseProfile, significant_change_in_design_since_that_date, unsure, Profile).
fixture_case(equivalence_unsure_without_point_c, Profile, duty(date(2028, 1, 10))) :-
    equivalence_unsure_profile(Profile).
fixture_case(equivalence_unsure_with_point_c, Profile, duty(date(2028, 1, 10))) :-
    equivalence_unsure_profile(BaseProfile),
    with_value(BaseProfile, fundamental_rights_obligations_infringed, true, Profile).
fixture_case(duplicate_classification, [attribute(high_risk_classification, annex_iii_high_risk), attribute(high_risk_classification, annex_iii_high_risk)], duty(date(2028, 1, 10))).
fixture_case(unknown_key_present, [attribute(high_risk_classification, not_high_risk), attribute(colour, red)], duty(date(2028, 1, 10))).
fixture_case(crisp_key_given_unsure, [attribute(critical_infrastructure_disruption, unsure)], duty(date(2028, 1, 10))).
fixture_case(awareness_date_not_a_date, Profile, duty(the_tenth_of_january)) :-
    base_profile(annex_iii_death, Profile).
fixture_case(awareness_on_leap_day, Profile, duty(date(2028, 2, 29))) :-
    base_profile(annex_iii_death, Profile).
fixture_case(profile_and_date_problems, [attribute(critical_infrastructure_disruption, unsure)], duty(the_tenth_of_january)).
fixture_case(report_date_not_a_date, Profile, timeliness(date(2028, 1, 1), the_eleventh_of_january)) :-
    immediacy_profile(true, Profile).

early_unchanged_public_profile(Profile) :-
    base_profile(annex_iii_death, BaseProfile),
    with_value(BaseProfile, placed_before_chapter_iii_application_date, true, PlacedProfile),
    with_value(PlacedProfile, significant_change_in_design_since_that_date, false, UnchangedProfile),
    with_value(UnchangedProfile, intended_to_be_used_by_public_authorities, true, Profile).

immediacy_profile(MadeImmediately, Profile) :-
    base_profile(annex_iii_death, BaseProfile),
    with_value(BaseProfile, report_made_immediately, MadeImmediately, Profile).

equivalence_unsure_profile(Profile) :-
    base_profile(annex_iii_death, BaseProfile),
    with_value(BaseProfile, provider_subject_to_equivalent_union_reporting_obligations, unsure, Profile).

serious_incident_reporting_subject(Subject) :-
    fixture_case(Subject, _, _).

serious_incident_reporting_profile_for(Subject, Profile) :-
    fixture_case(Subject, Profile, _).

serious_incident_reporting_assess(Subject, serious_incident_reporting_verdict(Status, Citations)) :-
    fixture_case(Subject, Profile, FixtureQuery),
    fixture_answer(FixtureQuery, Profile, Status, Citations).

fixture_answer(duty(AwarenessDate), Profile, Status, Citations) :-
    serious_incident_report_duty(Profile, AwarenessDate, Status, Citations).
fixture_answer(timeliness(AwarenessDate, ReportDate), Profile, Status, Citations) :-
    serious_incident_report_timeliness(Profile, AwarenessDate, ReportDate, Status, Citations).
