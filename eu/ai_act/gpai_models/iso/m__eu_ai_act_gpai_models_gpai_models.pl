% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_gpai_models_gpai_models, [decide_gpai_models/2, gpai_models_status/2, gpai_models_checklist/2, gpai_models_decision_resolvable/1, gpai_models_status_values/1, systemic_risk_classification_status/4, systemic_risk_notification_status/5, provider_obligation_status/5, documentation_elements/3, not_applicable_on_date/0, not_a_general_purpose_ai_model/0, general_purpose_ai_model_with_systemic_risk/0, general_purpose_ai_model_without_systemic_risk/0, no_notification_duty/0, notification_after_the_time_limit/0, notification_within_the_time_limit/0, obligation_does_not_apply/0, compliance_required_by_2_august_2027/0, obligation_applies/0, intended_tasks_and_type_and_nature_of_ai_systems_for_integration/0, acceptable_use_policies/0, date_of_release_and_methods_of_distribution/0, architecture_and_number_of_parameters/0, modality_and_format_of_inputs_and_outputs/0, licence/0, technical_means_required_for_integration/0, design_specifications_of_the_model_and_training_process/0, detailed_information_on_training_testing_and_validation_data/0, computational_resources_used_for_training/0, known_or_estimated_energy_consumption/0, evaluation_strategies_and_results/0, adversarial_testing_and_model_adaptation_measures/0, system_architecture/0, interaction_with_hardware_or_software_outside_the_model/0, versions_of_relevant_software/0, modality_format_and_maximum_size_of_inputs_and_outputs/0, information_on_training_testing_and_validation_data/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(library(clpz)).
:- use_module(clausal_datetime, [timedelta/3, date_add/3]).
:- use_module(clausal_dates, [days_between/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(deadline_lib, [month_last_day/3]).
:- use_module(m__eu_ai_act_gpai_models_kernel, [gpai_models_input_problems/2]).
:- use_module(m__eu_ai_act_gpai_models_citations, [implements/1]).

statutory_figure(systemic_risk_presumption_threshold_floating_point_operations, cite(eu_reg_2024_1689_art_51_2)).
statutory_figure(notification_period_days, cite(eu_reg_2024_1689_art_52_1)).

application_date(chapter_five, date(2025, 8, 2), cite(eu_reg_2024_1689_art_113_b)).
application_date(transition_end, date(2027, 8, 2), cite(eu_reg_2024_1689_art_111_3)).

gpai_models_status_values([not_applicable_on_date, not_a_general_purpose_ai_model, general_purpose_ai_model_with_systemic_risk, general_purpose_ai_model_without_systemic_risk, no_notification_duty, notification_after_the_time_limit, notification_within_the_time_limit, obligation_does_not_apply, compliance_required_by_2_august_2027, obligation_applies]).

not_applicable_on_date.

not_a_general_purpose_ai_model.

general_purpose_ai_model_with_systemic_risk.

general_purpose_ai_model_without_systemic_risk.

no_notification_duty.

notification_after_the_time_limit.

notification_within_the_time_limit.

obligation_does_not_apply.

compliance_required_by_2_august_2027.

obligation_applies.

intended_tasks_and_type_and_nature_of_ai_systems_for_integration.

acceptable_use_policies.

date_of_release_and_methods_of_distribution.

architecture_and_number_of_parameters.

modality_and_format_of_inputs_and_outputs.

licence.

technical_means_required_for_integration.

design_specifications_of_the_model_and_training_process.

detailed_information_on_training_testing_and_validation_data.

computational_resources_used_for_training.

known_or_estimated_energy_consumption.

evaluation_strategies_and_results.

adversarial_testing_and_model_adaptation_measures.

system_architecture.

interaction_with_hardware_or_software_outside_the_model.

versions_of_relevant_software.

modality_format_and_maximum_size_of_inputs_and_outputs.

information_on_training_testing_and_validation_data.

key_kind(general_purpose_ai_model, judgement).
key_kind(used_for_research_development_or_prototyping_before_being_placed_on_the_market, crisp).
key_kind(cumulative_training_computation_in_floating_point_operations, integer).
key_kind(high_impact_capabilities, judgement).
key_kind(designated_by_a_commission_decision_as_a_model_with_systemic_risk, crisp).
key_kind(commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, crisp).
key_kind(released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution, judgement).
key_kind(parameters_weights_architecture_and_usage_information_made_publicly_available, crisp).
key_kind(provider_established_in_a_third_country, crisp).
key_kind(placed_on_the_market_before_2_august_2025, crisp).

query_keys(systemic_risk_classification_status, [general_purpose_ai_model, used_for_research_development_or_prototyping_before_being_placed_on_the_market, cumulative_training_computation_in_floating_point_operations, high_impact_capabilities, designated_by_a_commission_decision_as_a_model_with_systemic_risk, commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks]).
query_keys(systemic_risk_notification_status, [general_purpose_ai_model, cumulative_training_computation_in_floating_point_operations, high_impact_capabilities, placed_on_the_market_before_2_august_2025]).
query_keys(provider_obligation_status, [general_purpose_ai_model, used_for_research_development_or_prototyping_before_being_placed_on_the_market, cumulative_training_computation_in_floating_point_operations, high_impact_capabilities, designated_by_a_commission_decision_as_a_model_with_systemic_risk, commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution, parameters_weights_architecture_and_usage_information_made_publicly_available, provider_established_in_a_third_country, placed_on_the_market_before_2_august_2025]).

key_citation(general_purpose_ai_model, cite(eu_reg_2024_1689_art_3_63)).
key_citation(used_for_research_development_or_prototyping_before_being_placed_on_the_market, cite(eu_reg_2024_1689_art_3_63)).
key_citation(cumulative_training_computation_in_floating_point_operations, cite(eu_reg_2024_1689_art_51_2)).
key_citation(high_impact_capabilities, cite(eu_reg_2024_1689_art_51_1_a)).
key_citation(designated_by_a_commission_decision_as_a_model_with_systemic_risk, cite(eu_reg_2024_1689_art_51_1_b)).
key_citation(commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, cite(eu_reg_2024_1689_art_52_2)).
key_citation(released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution, cite(eu_reg_2024_1689_art_53_2)).
key_citation(parameters_weights_architecture_and_usage_information_made_publicly_available, cite(eu_reg_2024_1689_art_53_2)).
key_citation(provider_established_in_a_third_country, cite(eu_reg_2024_1689_art_54_1)).
key_citation(placed_on_the_market_before_2_august_2025, cite(eu_reg_2024_1689_art_111_3)).

referral_row(systemic_risk_classification_status, general_purpose_ai_model, cite(eu_reg_2024_1689_art_3_63)).
referral_row(systemic_risk_classification_status, high_impact_capabilities, cite(eu_reg_2024_1689_art_51_1_a)).
referral_row(systemic_risk_notification_status, general_purpose_ai_model, cite(eu_reg_2024_1689_art_3_63)).
referral_row(systemic_risk_notification_status, high_impact_capabilities, cite(eu_reg_2024_1689_art_51_1_a)).
referral_row(provider_obligation_status, general_purpose_ai_model, cite(eu_reg_2024_1689_art_3_63)).
referral_row(provider_obligation_status, high_impact_capabilities, cite(eu_reg_2024_1689_art_51_1_a)).
referral_row(provider_obligation_status, released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution, cite(eu_reg_2024_1689_art_53_2)).

obligation_row(technical_documentation, open_source_exception, [cite(eu_reg_2024_1689_art_53_1), cite(eu_reg_2024_1689_art_53_1_a)], [cite(eu_reg_2024_1689_art_53_1), cite(eu_reg_2024_1689_art_53_1_a), cite(eu_reg_2024_1689_art_53_2)]).
obligation_row(information_for_downstream_providers, open_source_exception, [cite(eu_reg_2024_1689_art_53_1), cite(eu_reg_2024_1689_art_53_1_b), cite(eu_reg_2024_1689_art_53_1_b_i), cite(eu_reg_2024_1689_art_53_1_b_ii)], [cite(eu_reg_2024_1689_art_53_1), cite(eu_reg_2024_1689_art_53_1_b), cite(eu_reg_2024_1689_art_53_2)]).
obligation_row(copyright_policy, no_exception, [cite(eu_reg_2024_1689_art_53_1), cite(eu_reg_2024_1689_art_53_1_c)], []).
obligation_row(training_content_summary, no_exception, [cite(eu_reg_2024_1689_art_53_1), cite(eu_reg_2024_1689_art_53_1_d)], []).
obligation_row(cooperation_with_authorities, no_exception, [cite(eu_reg_2024_1689_art_53_3)], []).
obligation_row(authorised_representative, representative_exception, [cite(eu_reg_2024_1689_art_54_1), cite(eu_reg_2024_1689_art_54_2)], [cite(eu_reg_2024_1689_art_54_1), cite(eu_reg_2024_1689_art_54_6)]).
obligation_row(model_evaluation, systemic_risk_only, [cite(eu_reg_2024_1689_art_55_1), cite(eu_reg_2024_1689_art_55_1_a)], [cite(eu_reg_2024_1689_art_55_1), cite(eu_reg_2024_1689_art_55_1_a), cite(eu_reg_2024_1689_art_51_1)]).
obligation_row(systemic_risk_assessment_and_mitigation, systemic_risk_only, [cite(eu_reg_2024_1689_art_55_1), cite(eu_reg_2024_1689_art_55_1_b)], [cite(eu_reg_2024_1689_art_55_1), cite(eu_reg_2024_1689_art_55_1_b), cite(eu_reg_2024_1689_art_51_1)]).
obligation_row(serious_incident_reporting, systemic_risk_only, [cite(eu_reg_2024_1689_art_55_1), cite(eu_reg_2024_1689_art_55_1_c)], [cite(eu_reg_2024_1689_art_55_1), cite(eu_reg_2024_1689_art_55_1_c), cite(eu_reg_2024_1689_art_51_1)]).
obligation_row(cybersecurity_protection, systemic_risk_only, [cite(eu_reg_2024_1689_art_55_1), cite(eu_reg_2024_1689_art_55_1_d)], [cite(eu_reg_2024_1689_art_55_1), cite(eu_reg_2024_1689_art_55_1_d), cite(eu_reg_2024_1689_art_51_1)]).

annex_xi_row(technical_documentation, [intended_tasks_and_type_and_nature_of_ai_systems_for_integration, acceptable_use_policies, date_of_release_and_methods_of_distribution, architecture_and_number_of_parameters, modality_and_format_of_inputs_and_outputs, licence, technical_means_required_for_integration, design_specifications_of_the_model_and_training_process, detailed_information_on_training_testing_and_validation_data, computational_resources_used_for_training, known_or_estimated_energy_consumption], [cite(eu_reg_2024_1689_annex_xi), cite(eu_reg_2024_1689_annex_xi_section_1), cite(eu_reg_2024_1689_annex_xi_section_1_1), cite(eu_reg_2024_1689_annex_xi_section_1_1_a), cite(eu_reg_2024_1689_annex_xi_section_1_1_b), cite(eu_reg_2024_1689_annex_xi_section_1_1_c), cite(eu_reg_2024_1689_annex_xi_section_1_1_d), cite(eu_reg_2024_1689_annex_xi_section_1_1_e), cite(eu_reg_2024_1689_annex_xi_section_1_1_f), cite(eu_reg_2024_1689_annex_xi_section_1_2), cite(eu_reg_2024_1689_annex_xi_section_1_2_a), cite(eu_reg_2024_1689_annex_xi_section_1_2_b), cite(eu_reg_2024_1689_annex_xi_section_1_2_c), cite(eu_reg_2024_1689_annex_xi_section_1_2_d), cite(eu_reg_2024_1689_annex_xi_section_1_2_e)]).
annex_xi_row(additional_technical_documentation_for_models_with_systemic_risk, [evaluation_strategies_and_results, adversarial_testing_and_model_adaptation_measures, system_architecture], [cite(eu_reg_2024_1689_annex_xi), cite(eu_reg_2024_1689_annex_xi_section_2), cite(eu_reg_2024_1689_annex_xi_section_2_1), cite(eu_reg_2024_1689_annex_xi_section_2_2), cite(eu_reg_2024_1689_annex_xi_section_2_3)]).

annex_xii_row(information_for_downstream_providers, [intended_tasks_and_type_and_nature_of_ai_systems_for_integration, acceptable_use_policies, date_of_release_and_methods_of_distribution, interaction_with_hardware_or_software_outside_the_model, versions_of_relevant_software, architecture_and_number_of_parameters, modality_and_format_of_inputs_and_outputs, licence, technical_means_required_for_integration, modality_format_and_maximum_size_of_inputs_and_outputs, information_on_training_testing_and_validation_data], [cite(eu_reg_2024_1689_annex_xii), cite(eu_reg_2024_1689_annex_xii_1), cite(eu_reg_2024_1689_annex_xii_1_a), cite(eu_reg_2024_1689_annex_xii_1_b), cite(eu_reg_2024_1689_annex_xii_1_c), cite(eu_reg_2024_1689_annex_xii_1_d), cite(eu_reg_2024_1689_annex_xii_1_e), cite(eu_reg_2024_1689_annex_xii_1_f), cite(eu_reg_2024_1689_annex_xii_1_g), cite(eu_reg_2024_1689_annex_xii_1_h), cite(eu_reg_2024_1689_annex_xii_2), cite(eu_reg_2024_1689_annex_xii_2_a), cite(eu_reg_2024_1689_annex_xii_2_b), cite(eu_reg_2024_1689_annex_xii_2_c)]).

known_document_row(technical_documentation).
known_document_row(additional_technical_documentation_for_models_with_systemic_risk).
known_document_row(information_for_downstream_providers).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

truth_or(true, _, true).
truth_or(false, Truth, Truth).

truth_not(true, false).
truth_not(false, true).

holds_t(Goal, Truth) :-
    findall(found, call(Goal), Found),
    found_truth(Found, Truth).

found_truth([], false).
found_truth([_|_], true).

valid_date_t(Term, Truth) :-
    holds_t(real_calendar_day(Term), Truth).

real_calendar_day(Term) :-
    nonvar(Term),
    Term = date(Year, Month, Day),
    integer(Year),
    integer(Month),
    integer(Day),
    Year >= 1,
    Year =< 9999,
    Month >= 1,
    Month =< 12,
    Day >= 1,
    month_last_day(Year, Month, LastDay),
    Day =< LastDay.

before_t(First, Second, Truth) :-
    days_between(Second, First, Difference),
    positive_t(Difference, Truth).

after_t(First, Second, Truth) :-
    before_t(Second, First, Truth).

positive_t(Difference, true) :-
    Difference #> 0.
positive_t(Difference, false) :-
    Difference #< 1.

chapter_five_start(Date) :-
    implements(eu_reg_2024_1689_art_113_b),
    application_date(chapter_five, Date, _).

transition_end(Date) :-
    implements(eu_reg_2024_1689_art_111_3),
    application_date(transition_end, Date, _).

start_day(Trigger, Start) :-
    implements(eu_reg_2024_1689_art_113_b),
    chapter_five_start(Applies),
    before_t(Trigger, Applies, Early),
    start_choice(Early, Trigger, Applies, Start).

start_choice(true, _, Applies, Applies).
start_choice(false, Trigger, _, Trigger).

two_week_day(Trigger, LastDay) :-
    implements(eu_reg_2024_1689_art_52_1),
    start_day(Trigger, Start),
    PeriodDays #= 14,
    timedelta(PeriodDays, 0, NotificationPeriod),
    date_add(Start, NotificationPeriod, LastDay).

general_purpose_ai_model_t(true, false, true) :-
    implements(eu_reg_2024_1689_art_3_63).
general_purpose_ai_model_t(true, true, false) :-
    implements(eu_reg_2024_1689_art_3_63).
general_purpose_ai_model_t(false, _, false) :-
    implements(eu_reg_2024_1689_art_3_63).

above_threshold_t(Computation, true) :-
    implements(eu_reg_2024_1689_art_51_2),
    Computation #> 10000000000000000000000000.
above_threshold_t(Computation, false) :-
    implements(eu_reg_2024_1689_art_51_2),
    Computation #< 10000000000000000000000001.

high_impact_t(Computation, HighImpact, Truth) :-
    implements(eu_reg_2024_1689_art_51_1_a),
    above_threshold_t(Computation, Above),
    truth_or(Above, HighImpact, Truth).

arguments_leave_classification_t(Accepted, Truth) :-
    implements(eu_reg_2024_1689_art_52_3),
    truth_not(Accepted, Truth).

designation_t(Designated, Designated) :-
    implements(eu_reg_2024_1689_art_52_4).

systemic_risk_t(Computation, HighImpact, Designated, Accepted, Truth) :-
    implements(eu_reg_2024_1689_art_51_1),
    high_impact_t(Computation, HighImpact, PointA),
    arguments_leave_classification_t(Accepted, Standing),
    truth_and(PointA, Standing, ByPointA),
    designation_t(Designated, ByPointB),
    truth_or(ByPointB, ByPointA, Truth).

open_source_t(Licence, Public, Truth) :-
    implements(eu_reg_2024_1689_art_53_2),
    truth_and(Licence, Public, Truth).

established_in_union_t(ThirdCountry, InUnion) :-
    implements(eu_reg_2024_1689_art_54_1),
    truth_not(ThirdCountry, InUnion).

exception_t(open_source_exception, SystemicRisk, OpenSource, _, Truth) :-
    implements(eu_reg_2024_1689_art_53_2),
    truth_not(SystemicRisk, NoSystemicRisk),
    truth_and(OpenSource, NoSystemicRisk, Truth).
exception_t(no_exception, _, _, _, false) :-
    implements(eu_reg_2024_1689_art_53_1).
exception_t(representative_exception, SystemicRisk, OpenSource, ThirdCountry, Truth) :-
    implements(eu_reg_2024_1689_art_54_6),
    truth_not(SystemicRisk, NoSystemicRisk),
    truth_and(OpenSource, NoSystemicRisk, OpenSourceRelief),
    established_in_union_t(ThirdCountry, InUnion),
    truth_or(OpenSourceRelief, InUnion, Truth).
exception_t(systemic_risk_only, SystemicRisk, _, _, Truth) :-
    implements(eu_reg_2024_1689_art_55_1),
    truth_not(SystemicRisk, Truth).

late_t(AfterTwoWeeks, AfterTransition, Placed, Late) :-
    implements(eu_reg_2024_1689_art_111_3),
    truth_not(Placed, NotPlaced),
    truth_or(NotPlaced, AfterTransition, OutsideTransition),
    truth_and(AfterTwoWeeks, OutsideTransition, Late).

classification_answer(true, _, answer(not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_b)])) :-
    implements(eu_reg_2024_1689_art_113_b).
classification_answer(false, [Model, Research, Computation, HighImpact, Designated, Accepted], Answer) :-
    implements(eu_reg_2024_1689_art_3_63),
    general_purpose_ai_model_t(Model, Research, IsModel),
    classification_of_model(IsModel, Computation, HighImpact, Designated, Accepted, Answer).

classification_of_model(false, _, _, _, _, answer(not_a_general_purpose_ai_model, [cite(eu_reg_2024_1689_art_3_63)])) :-
    implements(eu_reg_2024_1689_art_3_63).
classification_of_model(true, Computation, HighImpact, Designated, Accepted, Answer) :-
    implements(eu_reg_2024_1689_art_51_1),
    systemic_risk_t(Computation, HighImpact, Designated, Accepted, SystemicRisk),
    classification_of_risk(SystemicRisk, Answer).

classification_of_risk(true, answer(general_purpose_ai_model_with_systemic_risk, [cite(eu_reg_2024_1689_art_51_1), cite(eu_reg_2024_1689_art_51_1_a), cite(eu_reg_2024_1689_art_51_1_b), cite(eu_reg_2024_1689_art_51_2), cite(eu_reg_2024_1689_art_52_3), cite(eu_reg_2024_1689_art_52_4)])) :-
    implements(eu_reg_2024_1689_art_51_1).
classification_of_risk(false, answer(general_purpose_ai_model_without_systemic_risk, [cite(eu_reg_2024_1689_art_51_1), cite(eu_reg_2024_1689_art_51_1_a), cite(eu_reg_2024_1689_art_51_1_b), cite(eu_reg_2024_1689_art_51_2), cite(eu_reg_2024_1689_art_52_2)])) :-
    implements(eu_reg_2024_1689_art_52_2).

notification_answer(_, _, [false, _, _, _], answer(not_a_general_purpose_ai_model, [cite(eu_reg_2024_1689_art_3_63)])) :-
    implements(eu_reg_2024_1689_art_3_63).
notification_answer(AfterTwoWeeks, AfterTransition, [true, Computation, HighImpact, Placed], Answer) :-
    implements(eu_reg_2024_1689_art_52_1),
    high_impact_t(Computation, HighImpact, Duty),
    notification_of_duty(Duty, AfterTwoWeeks, AfterTransition, Placed, Answer).

notification_of_duty(false, _, _, _, answer(no_notification_duty, [cite(eu_reg_2024_1689_art_51_1_a), cite(eu_reg_2024_1689_art_51_2), cite(eu_reg_2024_1689_art_52_1)])) :-
    implements(eu_reg_2024_1689_art_52_1).
notification_of_duty(true, AfterTwoWeeks, AfterTransition, Placed, Answer) :-
    implements(eu_reg_2024_1689_art_52_1),
    late_t(AfterTwoWeeks, AfterTransition, Placed, Late),
    notification_timing(Late, Answer).

notification_timing(true, answer(notification_after_the_time_limit, [cite(eu_reg_2024_1689_art_52_1), cite(eu_reg_2024_1689_art_111_3), cite(eu_reg_2024_1689_art_113_b)])) :-
    implements(eu_reg_2024_1689_art_52_1).
notification_timing(false, answer(notification_within_the_time_limit, [cite(eu_reg_2024_1689_art_52_1), cite(eu_reg_2024_1689_art_111_3), cite(eu_reg_2024_1689_art_113_b)])) :-
    implements(eu_reg_2024_1689_art_52_1).

obligation_answer(_, true, _, _, answer(not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_b)])) :-
    implements(eu_reg_2024_1689_art_113_b).
obligation_answer(Obligation, false, BeforeEnd, [Model, Research, Computation, HighImpact, Designated, Accepted, Licence, Public, ThirdCountry, Placed], Answer) :-
    implements(eu_reg_2024_1689_art_3_63),
    general_purpose_ai_model_t(Model, Research, IsModel),
    obligation_of_model(IsModel, Obligation, BeforeEnd, model_facts(Computation, HighImpact, Designated, Accepted, Licence, Public, ThirdCountry, Placed), Answer).

obligation_of_model(false, _, _, _, answer(not_a_general_purpose_ai_model, [cite(eu_reg_2024_1689_art_3_63)])) :-
    implements(eu_reg_2024_1689_art_3_63).
obligation_of_model(true, Obligation, BeforeEnd, model_facts(Computation, HighImpact, Designated, Accepted, Licence, Public, ThirdCountry, Placed), Answer) :-
    implements(eu_reg_2024_1689_art_53_1),
    systemic_risk_t(Computation, HighImpact, Designated, Accepted, SystemicRisk),
    open_source_t(Licence, Public, OpenSource),
    obligation_row(Obligation, Kind, Applying, NotApplying),
    exception_t(Kind, SystemicRisk, OpenSource, ThirdCountry, Exception),
    obligation_by_exception(Exception, BeforeEnd, Placed, Applying, NotApplying, Answer).

obligation_by_exception(true, _, _, _, NotApplying, answer(obligation_does_not_apply, NotApplying)) :-
    implements(eu_reg_2024_1689_art_53_2).
obligation_by_exception(false, BeforeEnd, Placed, Applying, _, Answer) :-
    implements(eu_reg_2024_1689_art_111_3),
    truth_and(Placed, BeforeEnd, Transitional),
    obligation_by_transition(Transitional, Applying, Answer).

obligation_by_transition(true, Applying, answer(compliance_required_by_2_august_2027, [cite(eu_reg_2024_1689_art_111_3)|Applying])) :-
    implements(eu_reg_2024_1689_art_111_3).
obligation_by_transition(false, Applying, answer(obligation_applies, Applying)) :-
    implements(eu_reg_2024_1689_art_53_1).

profile_slots(Profile, Keys, Slots) :-
    maplist(key_slot(Profile), Keys, Slots).

key_slot(Profile, Key, Slot) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value),
    present_slot(Key, Value, Slot).
key_slot(Profile, Key, slot(Key, absent, Candidates)) :-
    profile_lacks(Profile, Key),
    key_kind(Key, Kind),
    absent_candidates(Kind, Candidates).

present_slot(Key, unsure, slot(Key, unsure, [true, false])).
present_slot(Key, Value, slot(Key, given, [Value])) :-
    dif(Value, unsure).

absent_candidates(judgement, [true, false]).
absent_candidates(crisp, [true, false]).
absent_candidates(integer, [0, Above]) :-
    implements(eu_reg_2024_1689_art_51_2),
    Above #= 10000000000000000000000000 + 1.

completion(Slots, Values) :-
    maplist(slot_value, Slots, Values).

slot_value(slot(_, _, Candidates), Value) :-
    member(Value, Candidates).

replace_at(0, [_|Tail], Value, [Value|Tail]).
replace_at(Index, [Head|Tail], Value, [Head|NewTail]) :-
    Index #> 0,
    Previous #= Index - 1,
    replace_at(Previous, Tail, Value, NewTail).

status_rule(Query, Slots, Ladder, Result, Citations) :-
    findall(Answer, (completion(Slots, Values), call(Ladder, Values, Answer)), Answers),
    sort(Answers, Distinct),
    settle(Distinct, Query, Slots, Ladder, Result, Citations).

settle([answer(Result, Citations)], _, _, _, Result, Citations).
settle([_, _|_], Query, Slots, Ladder, Result, []) :-
    unsettled_result(Query, Slots, Ladder, Result).

unsettled_result(Query, Slots, Ladder, Result) :-
    findall(Index - Witnesses, (nth0(Index, Slots, slot(_, absent, _)), witnesses(Slots, Ladder, Index, Witnesses), Witnesses = [_|_]), Mattering),
    unsettled_choice(Mattering, Query, Slots, Ladder, Result).

unsettled_choice([], Query, Slots, Ladder, Result) :-
    referral_result(Query, Slots, Ladder, Result).
unsettled_choice([First|Rest], _, Slots, _, indeterminate([Key])) :-
    first_free([First|Rest], [First|Rest], Index),
    nth0(Index, Slots, slot(Key, _, _)).

witnesses(Slots, Ladder, Index, Witnesses) :-
    nth0(Index, Slots, slot(Key, State, [First, Second])),
    replace_at(Index, Slots, slot(Key, State, [First]), FixedSlots),
    findall(Base, (completion(FixedSlots, Base), replace_at(Index, Base, Second, Partner), call(Ladder, Base, BaseAnswer), call(Ladder, Partner, PartnerAnswer), dif(BaseAnswer, PartnerAnswer)), Witnesses).

first_free([Index - Witnesses|Rest], Mattering, Chosen) :-
    behind_any_t(Index, Witnesses, Mattering, Behind),
    first_free_choice(Behind, Index, Rest, Mattering, Chosen).

first_free_choice(false, Index, _, _, Index).
first_free_choice(true, _, Rest, Mattering, Chosen) :-
    first_free(Rest, Mattering, Chosen).

behind_any_t(_, _, [], false).
behind_any_t(Index, Witnesses, [Other - OtherWitnesses|Others], Behind) :-
    behind_t(Index, Witnesses, Other, OtherWitnesses, PairBehind),
    behind_any_rest(PairBehind, Index, Witnesses, Others, Behind).

behind_any_rest(true, _, _, _, true).
behind_any_rest(false, Index, Witnesses, Others, Behind) :-
    behind_any_t(Index, Witnesses, Others, Behind).

behind_t(Index, _, Other, _, false) :-
    Index #= Other.
behind_t(Index, Witnesses, Other, OtherWitnesses, Behind) :-
    dif(Index, Other),
    values_at(Other, Witnesses, OtherValues),
    values_at(Index, OtherWitnesses, IndexValues),
    length(OtherValues, OtherCount),
    length(IndexValues, IndexCount),
    behind_counts_t(OtherCount, IndexCount, Behind).

behind_counts_t(1, 2, true).
behind_counts_t(OtherCount, _, false) :-
    dif(OtherCount, 1).
behind_counts_t(1, IndexCount, false) :-
    dif(IndexCount, 2).

values_at(Index, Witnesses, Values) :-
    findall(Value, (member(Witness, Witnesses), nth0(Index, Witness, Value)), Found),
    sort(Found, Values).

referral_result(Query, Slots, Ladder, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)])) :-
    findall(Index, nth0(Index, Slots, slot(_, unsure, _)), UnsureIndexes),
    first_mattering(UnsureIndexes, Slots, Ladder, Chosen),
    nth0(Chosen, Slots, slot(Key, _, _)),
    referral_row(Query, Key, Citation),
    findall(Pair, (member(Slot, Slots), judgement_pair(Slot, Pair)), Pairs).

first_mattering([Index|Indexes], Slots, Ladder, Chosen) :-
    witnesses(Slots, Ladder, Index, Witnesses),
    mattering_choice(Witnesses, Index, Indexes, Slots, Ladder, Chosen).

mattering_choice([_|_], Index, _, _, _, Index).
mattering_choice([], _, Indexes, Slots, Ladder, Chosen) :-
    first_mattering(Indexes, Slots, Ladder, Chosen).

judgement_pair(slot(Key, given, [Value]), Key - Value) :-
    key_kind(Key, judgement).
judgement_pair(slot(Key, unsure, _), Key - unsure).

date_problems(true, _, []).
date_problems(false, Name, [wrong_type(Name)]).

notification_problem(_, false, _, _, [wrong_type(notification_date)]).
notification_problem(false, true, _, _, []).
notification_problem(true, true, Trigger, Notification, Problems) :-
    before_t(Notification, Trigger, Early),
    early_notification(Early, Problems).

early_notification(true, [wrong_type(notification_date)]).
early_notification(false, []).

known_obligation(Obligation) :-
    atom(Obligation),
    obligation_row(Obligation, _, _, _).

obligation_problems(true, []).
obligation_problems(false, [wrong_type(obligation)]).

known_document(Document) :-
    atom(Document),
    known_document_row(Document).

systemic_risk_classification_status(Profile, AssessmentDate, Result, Citations) :-
    gpai_models_input_problems(Profile, ProfileProblems),
    valid_date_t(AssessmentDate, DateValid),
    date_problems(DateValid, assessment_date, DateProblems),
    append(ProfileProblems, DateProblems, Problems),
    classification_status(Problems, Profile, AssessmentDate, Result, Citations).

classification_status([], Profile, AssessmentDate, Result, Citations) :-
    query_keys(systemic_risk_classification_status, Keys),
    profile_slots(Profile, Keys, Slots),
    chapter_five_start(Applies),
    before_t(AssessmentDate, Applies, Early),
    status_rule(systemic_risk_classification_status, Slots, classification_answer(Early), Result, Citations).
classification_status([Problem|Problems], _, _, input_problems([Problem|Problems]), []).

systemic_risk_notification_status(Profile, TriggerDate, NotificationDate, Result, Citations) :-
    gpai_models_input_problems(Profile, ProfileProblems),
    valid_date_t(TriggerDate, TriggerValid),
    valid_date_t(NotificationDate, NotificationValid),
    date_problems(TriggerValid, trigger_date, TriggerProblems),
    notification_problem(TriggerValid, NotificationValid, TriggerDate, NotificationDate, NotificationProblems),
    append(TriggerProblems, NotificationProblems, ArgumentProblems),
    append(ProfileProblems, ArgumentProblems, Problems),
    notification_status(Problems, Profile, TriggerDate, NotificationDate, Result, Citations).

notification_status([], Profile, TriggerDate, NotificationDate, Result, Citations) :-
    query_keys(systemic_risk_notification_status, Keys),
    profile_slots(Profile, Keys, Slots),
    two_week_day(TriggerDate, LastDay),
    after_t(NotificationDate, LastDay, AfterTwoWeeks),
    transition_end(End),
    after_t(NotificationDate, End, AfterTransition),
    status_rule(systemic_risk_notification_status, Slots, notification_answer(AfterTwoWeeks, AfterTransition), Result, Citations).
notification_status([Problem|Problems], _, _, _, input_problems([Problem|Problems]), []).

provider_obligation_status(Profile, Obligation, AssessmentDate, Result, Citations) :-
    gpai_models_input_problems(Profile, ProfileProblems),
    holds_t(known_obligation(Obligation), ObligationKnown),
    obligation_problems(ObligationKnown, ObligationProblems),
    valid_date_t(AssessmentDate, DateValid),
    date_problems(DateValid, assessment_date, DateProblems),
    append(ObligationProblems, DateProblems, ArgumentProblems),
    append(ProfileProblems, ArgumentProblems, Problems),
    obligation_status(Problems, Profile, Obligation, AssessmentDate, Result, Citations).

obligation_status([], Profile, Obligation, AssessmentDate, Result, Citations) :-
    query_keys(provider_obligation_status, Keys),
    profile_slots(Profile, Keys, Slots),
    chapter_five_start(Applies),
    before_t(AssessmentDate, Applies, Early),
    transition_end(End),
    before_t(AssessmentDate, End, BeforeEnd),
    status_rule(provider_obligation_status, Slots, obligation_answer(Obligation, Early, BeforeEnd), Result, Citations).
obligation_status([Problem|Problems], _, _, _, input_problems([Problem|Problems]), []).

documentation_elements(Document, Elements, Citations) :-
    holds_t(known_document(Document), Known),
    document_answer(Known, Document, Elements, Citations).

document_answer(true, Document, Elements, Citations) :-
    implements(eu_reg_2024_1689_annex_xi),
    annex_xi_row(Document, Elements, Citations).
document_answer(true, Document, Elements, Citations) :-
    implements(eu_reg_2024_1689_annex_xii),
    annex_xii_row(Document, Elements, Citations).
document_answer(false, _, input_problems([wrong_type(document)]), []).

decide_gpai_models(systemic_risk_classification(Profile, AssessmentDate), gpai_models_verdict(Result, Citations)) :-
    systemic_risk_classification_status(Profile, AssessmentDate, Result, Citations).
decide_gpai_models(systemic_risk_notification(Profile, TriggerDate, NotificationDate), gpai_models_verdict(Result, Citations)) :-
    systemic_risk_notification_status(Profile, TriggerDate, NotificationDate, Result, Citations).
decide_gpai_models(provider_obligation(Profile, Obligation, AssessmentDate), gpai_models_verdict(Result, Citations)) :-
    provider_obligation_status(Profile, Obligation, AssessmentDate, Result, Citations).
decide_gpai_models(documentation(Document), gpai_models_verdict(Elements, Citations)) :-
    documentation_elements(Document, Elements, Citations).

gpai_models_status(Request, Status) :-
    decide_gpai_models(Request, gpai_models_verdict(Status, _Citations)).

gpai_models_checklist(Request, [item(verdict, Status, Citations)|KeyItems]) :-
    decide_gpai_models(Request, gpai_models_verdict(Status, Citations)),
    request_items(Request, KeyItems).

request_items(systemic_risk_classification(Profile, _), Items) :-
    profile_items_for(systemic_risk_classification_status, Profile, Items).
request_items(systemic_risk_notification(Profile, _, _), Items) :-
    profile_items_for(systemic_risk_notification_status, Profile, Items).
request_items(provider_obligation(Profile, _, _), Items) :-
    profile_items_for(provider_obligation_status, Profile, Items).
request_items(documentation(_), []).

profile_items_for(Query, Profile, Items) :-
    gpai_models_input_problems(Profile, Problems),
    profile_items(Problems, Query, Profile, Items).

profile_items([], Query, Profile, Items) :-
    query_keys(Query, Keys),
    maplist(key_item(Profile), Keys, Items).
profile_items([_|_], _, _, []).

key_item(Profile, Key, item(Key, Status, Citation)) :-
    key_citation(Key, Citation),
    key_slot(Profile, Key, Slot),
    slot_item_status(Slot, Status).

slot_item_status(slot(_, given, [Value]), value(Value)).
slot_item_status(slot(_, unsure, _), value(unsure)).
slot_item_status(slot(Key, absent, _), unknown([Key])).

gpai_models_decision_resolvable(Request) :-
    decide_gpai_models(Request, _Verdict).

fixture_profile(open_small_model, [attribute(general_purpose_ai_model, true), attribute(used_for_research_development_or_prototyping_before_being_placed_on_the_market, false), attribute(cumulative_training_computation_in_floating_point_operations, 0), attribute(high_impact_capabilities, false), attribute(designated_by_a_commission_decision_as_a_model_with_systemic_risk, false), attribute(commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, false), attribute(released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution, true), attribute(parameters_weights_architecture_and_usage_information_made_publicly_available, true), attribute(provider_established_in_a_third_country, false), attribute(placed_on_the_market_before_2_august_2025, false)]).
fixture_profile(legacy_small_model, [attribute(general_purpose_ai_model, true), attribute(used_for_research_development_or_prototyping_before_being_placed_on_the_market, false), attribute(cumulative_training_computation_in_floating_point_operations, 0), attribute(high_impact_capabilities, false), attribute(designated_by_a_commission_decision_as_a_model_with_systemic_risk, false), attribute(commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, false), attribute(released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution, false), attribute(parameters_weights_architecture_and_usage_information_made_publicly_available, false), attribute(provider_established_in_a_third_country, true), attribute(placed_on_the_market_before_2_august_2025, true)]).
fixture_profile(large_model, [attribute(general_purpose_ai_model, true), attribute(used_for_research_development_or_prototyping_before_being_placed_on_the_market, false), attribute(cumulative_training_computation_in_floating_point_operations, 10000000000000000000000001), attribute(high_impact_capabilities, false), attribute(designated_by_a_commission_decision_as_a_model_with_systemic_risk, false), attribute(commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, false), attribute(released_under_a_free_and_open_source_licence_allowing_access_usage_modification_and_distribution, true), attribute(parameters_weights_architecture_and_usage_information_made_publicly_available, true), attribute(provider_established_in_a_third_country, true), attribute(placed_on_the_market_before_2_august_2025, false)]).
fixture_profile(threshold_model, [attribute(general_purpose_ai_model, true), attribute(used_for_research_development_or_prototyping_before_being_placed_on_the_market, false), attribute(cumulative_training_computation_in_floating_point_operations, 10000000000000000000000000), attribute(high_impact_capabilities, false), attribute(designated_by_a_commission_decision_as_a_model_with_systemic_risk, false), attribute(commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, false)]).
fixture_profile(accepted_large_model, [attribute(general_purpose_ai_model, true), attribute(used_for_research_development_or_prototyping_before_being_placed_on_the_market, false), attribute(cumulative_training_computation_in_floating_point_operations, 10000000000000000000000001), attribute(high_impact_capabilities, false), attribute(designated_by_a_commission_decision_as_a_model_with_systemic_risk, false), attribute(commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, true)]).
fixture_profile(designated_accepted_model, [attribute(general_purpose_ai_model, true), attribute(used_for_research_development_or_prototyping_before_being_placed_on_the_market, false), attribute(cumulative_training_computation_in_floating_point_operations, 0), attribute(high_impact_capabilities, false), attribute(designated_by_a_commission_decision_as_a_model_with_systemic_risk, true), attribute(commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, true)]).
fixture_profile(unsure_model, [attribute(general_purpose_ai_model, unsure), attribute(used_for_research_development_or_prototyping_before_being_placed_on_the_market, false), attribute(cumulative_training_computation_in_floating_point_operations, 0), attribute(high_impact_capabilities, false), attribute(designated_by_a_commission_decision_as_a_model_with_systemic_risk, false), attribute(commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, false)]).
fixture_profile(unsure_model_without_research_key, [attribute(general_purpose_ai_model, unsure), attribute(cumulative_training_computation_in_floating_point_operations, 0), attribute(high_impact_capabilities, false), attribute(designated_by_a_commission_decision_as_a_model_with_systemic_risk, false), attribute(commission_accepted_the_providers_arguments_that_the_model_presents_no_systemic_risks, false)]).
fixture_profile(research_model, [attribute(general_purpose_ai_model, true), attribute(used_for_research_development_or_prototyping_before_being_placed_on_the_market, true)]).
fixture_profile(notifying_large_model, [attribute(general_purpose_ai_model, true), attribute(cumulative_training_computation_in_floating_point_operations, 10000000000000000000000001), attribute(high_impact_capabilities, false), attribute(placed_on_the_market_before_2_august_2025, false)]).
fixture_profile(notifying_legacy_model, [attribute(general_purpose_ai_model, true), attribute(cumulative_training_computation_in_floating_point_operations, 10000000000000000000000001), attribute(high_impact_capabilities, false), attribute(placed_on_the_market_before_2_august_2025, true)]).
fixture_profile(notifying_small_model, [attribute(general_purpose_ai_model, true), attribute(cumulative_training_computation_in_floating_point_operations, 0), attribute(high_impact_capabilities, false), attribute(placed_on_the_market_before_2_august_2025, false)]).

test(classification_before_application_is_not_applicable) :-
    findall(Result - Citations, systemic_risk_classification_status([], date(2025, 8, 1), Result, Citations), Answers),
    Answers == [not_applicable_on_date - [cite(eu_reg_2024_1689_art_113_b)]].
test(classification_on_application_day_asks_for_the_model_key) :-
    findall(Result - Citations, systemic_risk_classification_status([], date(2025, 8, 2), Result, Citations), Answers),
    Answers == [indeterminate([general_purpose_ai_model]) - []].
test(classification_above_threshold_has_systemic_risk) :-
    fixture_profile(large_model, Profile),
    findall(Result - Citations, systemic_risk_classification_status(Profile, date(2026, 1, 15), Result, Citations), Answers),
    Answers == [general_purpose_ai_model_with_systemic_risk - [cite(eu_reg_2024_1689_art_51_1), cite(eu_reg_2024_1689_art_51_1_a), cite(eu_reg_2024_1689_art_51_1_b), cite(eu_reg_2024_1689_art_51_2), cite(eu_reg_2024_1689_art_52_3), cite(eu_reg_2024_1689_art_52_4)]].
test(classification_at_exact_threshold_has_no_systemic_risk) :-
    fixture_profile(threshold_model, Profile),
    systemic_risk_classification_status(Profile, date(2026, 1, 15), general_purpose_ai_model_without_systemic_risk, _).
test(classification_accepted_arguments_remove_point_a) :-
    fixture_profile(accepted_large_model, Profile),
    systemic_risk_classification_status(Profile, date(2026, 1, 15), general_purpose_ai_model_without_systemic_risk, _).
test(classification_designation_wins_over_arguments) :-
    fixture_profile(designated_accepted_model, Profile),
    systemic_risk_classification_status(Profile, date(2026, 1, 15), general_purpose_ai_model_with_systemic_risk, _).
test(classification_research_model_is_not_a_model) :-
    fixture_profile(research_model, Profile),
    systemic_risk_classification_status(Profile, date(2026, 1, 15), not_a_general_purpose_ai_model, [cite(eu_reg_2024_1689_art_3_63)]).
test(classification_unsure_model_goes_to_a_lawyer) :-
    fixture_profile(unsure_model, Profile),
    systemic_risk_classification_status(Profile, date(2026, 1, 15), Result, []),
    Result == needs_legal_review(open_textured(general_purpose_ai_model, cite(eu_reg_2024_1689_art_3_63)), [inputs_relied_on([general_purpose_ai_model - unsure, high_impact_capabilities - false])]).
test(classification_missing_key_comes_before_referral) :-
    fixture_profile(unsure_model_without_research_key, Profile),
    systemic_risk_classification_status(Profile, date(2026, 1, 15), indeterminate([used_for_research_development_or_prototyping_before_being_placed_on_the_market]), []).
test(classification_bad_date_is_an_input_problem) :-
    systemic_risk_classification_status([], tomorrow, input_problems([wrong_type(assessment_date)]), []).
test(notification_on_the_two_week_day_is_within) :-
    fixture_profile(notifying_large_model, Profile),
    findall(Result, systemic_risk_notification_status(Profile, date(2026, 3, 1), date(2026, 3, 15), Result, _), Results),
    Results == [notification_within_the_time_limit].
test(notification_the_day_after_is_late) :-
    fixture_profile(notifying_large_model, Profile),
    systemic_risk_notification_status(Profile, date(2026, 3, 1), date(2026, 3, 16), notification_after_the_time_limit, _).
test(notification_period_starts_on_application_day) :-
    fixture_profile(notifying_large_model, Profile),
    systemic_risk_notification_status(Profile, date(2025, 7, 1), date(2025, 8, 16), notification_within_the_time_limit, _).
test(notification_legacy_model_in_time_until_transition_end) :-
    fixture_profile(notifying_legacy_model, Profile),
    systemic_risk_notification_status(Profile, date(2026, 3, 1), date(2027, 8, 2), notification_within_the_time_limit, _).
test(notification_legacy_model_late_after_transition_end) :-
    fixture_profile(notifying_legacy_model, Profile),
    systemic_risk_notification_status(Profile, date(2026, 3, 1), date(2027, 8, 3), notification_after_the_time_limit, _).
test(notification_small_model_has_no_duty) :-
    fixture_profile(notifying_small_model, Profile),
    systemic_risk_notification_status(Profile, date(2026, 3, 1), date(2026, 3, 2), no_notification_duty, [cite(eu_reg_2024_1689_art_51_1_a), cite(eu_reg_2024_1689_art_51_2), cite(eu_reg_2024_1689_art_52_1)]).
test(notification_before_trigger_is_an_input_problem) :-
    findall(Result - Citations, systemic_risk_notification_status([], date(2026, 3, 1), date(2026, 2, 1), Result, Citations), Answers),
    Answers == [input_problems([wrong_type(notification_date)]) - []].
test(notification_bad_trigger_is_an_input_problem) :-
    systemic_risk_notification_status([], yesterday, date(2026, 1, 1), input_problems([wrong_type(trigger_date)]), []).
test(open_source_relieves_technical_documentation) :-
    fixture_profile(open_small_model, Profile),
    findall(Result - Citations, provider_obligation_status(Profile, technical_documentation, date(2026, 1, 15), Result, Citations), Answers),
    Answers == [obligation_does_not_apply - [cite(eu_reg_2024_1689_art_53_1), cite(eu_reg_2024_1689_art_53_1_a), cite(eu_reg_2024_1689_art_53_2)]].
test(open_source_does_not_relieve_copyright_policy) :-
    fixture_profile(open_small_model, Profile),
    provider_obligation_status(Profile, copyright_policy, date(2026, 1, 15), obligation_applies, [cite(eu_reg_2024_1689_art_53_1), cite(eu_reg_2024_1689_art_53_1_c)]).
test(legacy_model_has_until_transition_end) :-
    fixture_profile(legacy_small_model, Profile),
    provider_obligation_status(Profile, copyright_policy, date(2026, 1, 15), compliance_required_by_2_august_2027, [cite(eu_reg_2024_1689_art_111_3), cite(eu_reg_2024_1689_art_53_1), cite(eu_reg_2024_1689_art_53_1_c)]).
test(legacy_model_obligation_applies_on_transition_end) :-
    fixture_profile(legacy_small_model, Profile),
    provider_obligation_status(Profile, copyright_policy, date(2027, 8, 2), obligation_applies, _).
test(systemic_risk_removes_the_open_source_exception) :-
    fixture_profile(large_model, Profile),
    provider_obligation_status(Profile, technical_documentation, date(2026, 1, 15), obligation_applies, _).
test(model_evaluation_applies_with_systemic_risk) :-
    fixture_profile(large_model, Profile),
    provider_obligation_status(Profile, model_evaluation, date(2026, 1, 15), obligation_applies, [cite(eu_reg_2024_1689_art_55_1), cite(eu_reg_2024_1689_art_55_1_a)]).
test(model_evaluation_does_not_apply_without_systemic_risk) :-
    fixture_profile(open_small_model, Profile),
    provider_obligation_status(Profile, model_evaluation, date(2026, 1, 15), obligation_does_not_apply, _).
test(union_provider_needs_no_representative) :-
    fixture_profile(open_small_model, Profile),
    provider_obligation_status(Profile, authorised_representative, date(2026, 1, 15), obligation_does_not_apply, [cite(eu_reg_2024_1689_art_54_1), cite(eu_reg_2024_1689_art_54_6)]).
test(third_country_provider_of_systemic_model_needs_representative) :-
    fixture_profile(large_model, Profile),
    provider_obligation_status(Profile, authorised_representative, date(2026, 1, 15), obligation_applies, _).
test(obligation_missing_placed_key_is_named) :-
    provider_obligation_status([attribute(general_purpose_ai_model, true), attribute(used_for_research_development_or_prototyping_before_being_placed_on_the_market, false)], copyright_policy, date(2026, 1, 15), indeterminate([placed_on_the_market_before_2_august_2025]), []).
test(obligation_unknown_atom_is_an_input_problem) :-
    provider_obligation_status([], swimming, date(2026, 1, 15), input_problems([wrong_type(obligation)]), []).
test(obligation_bad_profile_is_an_input_problem) :-
    provider_obligation_status(not_a_list, copyright_policy, date(2026, 1, 15), input_problems([wrong_type(profile)]), []).
test(additional_documentation_lists_section_two) :-
    findall(Elements, documentation_elements(additional_technical_documentation_for_models_with_systemic_risk, Elements, _), Answers),
    Answers == [[evaluation_strategies_and_results, adversarial_testing_and_model_adaptation_measures, system_architecture]].
test(downstream_information_ends_with_its_data_element) :-
    documentation_elements(information_for_downstream_providers, Elements, _),
    last(Elements, information_on_training_testing_and_validation_data).
test(unknown_document_is_an_input_problem) :-
    documentation_elements(report, input_problems([wrong_type(document)]), []).
test(unbound_document_is_an_input_problem) :-
    findall(Elements - Citations, documentation_elements(_, Elements, Citations), Answers),
    Answers == [input_problems([wrong_type(document)]) - []].
test(facade_projects_the_status) :-
    fixture_profile(large_model, Profile),
    gpai_models_status(systemic_risk_classification(Profile, date(2026, 1, 15)), general_purpose_ai_model_with_systemic_risk).
test(checklist_carries_the_verdict_row) :-
    fixture_profile(threshold_model, Profile),
    gpai_models_checklist(systemic_risk_classification(Profile, date(2026, 1, 15)), [item(verdict, general_purpose_ai_model_without_systemic_risk, _)|_]).

test(classification_at_exact_threshold_is_not_systemic, fail) :-
    fixture_profile(threshold_model, Profile),
    systemic_risk_classification_status(Profile, date(2026, 1, 15), general_purpose_ai_model_with_systemic_risk, _).
test(notification_the_day_after_is_not_within, fail) :-
    fixture_profile(notifying_large_model, Profile),
    systemic_risk_notification_status(Profile, date(2026, 3, 1), date(2026, 3, 16), notification_within_the_time_limit, _).
