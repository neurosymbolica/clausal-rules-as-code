% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_handler_duties_pipl_handler_duties, [decide_pipl_handler_duties/2, pipl_handler_duties_status/2, pipl_handler_duties_checklist/2, pipl_handler_duties_decision_resolvable/1, pipl_handler_duties_status_values/1, duty_status/4, duty_contents/2, required/0, required_in_advance/0, required_immediately/0, required_for_at_least_three_years/0, notice_may_be_omitted/0, not_required/0, not_in_force/0, pinned_text_not_applicable/0, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, content_item/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1, min_list/2]).
:- use_module(m__cn_pipl_handler_duties_kernel, [pipl_handler_duties_input_problems/2]).
:- use_module(m__cn_pipl_handler_duties_citations, [implements/1, duty_primary_citation/2]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(library(reif), [memberd_t/3]).

required.

required_in_advance.

required_immediately.

required_for_at_least_three_years.

notice_may_be_omitted.

not_required.

not_in_force.

pinned_text_not_applicable.

indeterminate(MissingKeys) :-
    clausal_is_list(MissingKeys).

needs_legal_review(Reason, Context) :-
    compound(Reason),
    clausal_is_list(Context).

open_textured(Input, cite(Key)) :-
    atom(Input),
    atom(Key).

inputs_relied_on(Pairs) :-
    clausal_is_list(Pairs).

provenance(Clause, Citations) :-
    atom(Clause),
    clausal_is_list(Citations).

content_item(Name, Citation) :-
    content_row(_, Name, Citation).

input_problems(Problems) :-
    clausal_is_list(Problems).

unknown_key(Key) :-
    term_variables(Key, _Variables).

wrong_type(Key) :-
    atom(Key).

duplicate_key(Key) :-
    atom(Key).

entry_into_force_day(2021, 11, 1, cite(cn_pipl_art_74_p1)).

pipl_handler_duties_status_values([duties_owed, duties_pending, no_duties_owed, not_in_force, pinned_text_not_applicable]).

duty_roster([compliance_measures, protection_officer, officer_contact_details, china_representative, compliance_audit, impact_assessment, assessment_record_retention, breach_remedial_measures, breach_notice_to_department, breach_notice_to_individuals, large_platform_obligations, entrusted_party_safeguards]).

duty_group(compliance_measures, handler_only).
duty_group(compliance_audit, handler_only).
duty_group(protection_officer, handler_and_condition).
duty_group(officer_contact_details, handler_and_condition).
duty_group(breach_remedial_measures, handler_and_condition).
duty_group(breach_notice_to_department, handler_and_condition).
duty_group(large_platform_obligations, handler_and_judgement).
duty_group(china_representative, representative).
duty_group(impact_assessment, assessment).
duty_group(assessment_record_retention, assessment).
duty_group(breach_notice_to_individuals, individual_notice).
duty_group(entrusted_party_safeguards, entrustment).

handler_steps(handler_only, 6, 7, handler_for_handler_duties).
handler_steps(handler_and_condition, 7, 9, handler_for_handler_duties).
handler_steps(handler_and_judgement, 7, 9, handler_for_large_platform).
handler_steps(representative, 9, 15, handler_for_representative).
handler_steps(assessment, 7, 15, handler_for_impact_assessment).
handler_steps(individual_notice, 7, 13, handler_for_individual_notice).

duty_condition(protection_officer, reaches_officer_quantity).
duty_condition(officer_contact_details, reaches_officer_quantity).
duty_condition(breach_remedial_measures, incident_occurred_or_possible).
duty_condition(breach_notice_to_department, incident_occurred_or_possible).
duty_condition(breach_notice_to_individuals, incident_occurred_or_possible).
duty_condition(large_platform_obligations, important_platform_handler).

representative_case(offers_products_or_services_to_individuals_in_china, cite(cn_pipl_art_3_p2_i1)).
representative_case(analyses_or_evaluates_individuals_in_china, cite(cn_pipl_art_3_p2_i2)).
representative_case(other_case_prescribed_by_law, cite(cn_pipl_art_3_p2_i3)).

assessment_occasion(processes_sensitive_personal_information, 8, crisp, cite(cn_pipl_art_55_p1_i1)).
assessment_occasion(uses_automated_decision_making, 9, crisp, cite(cn_pipl_art_55_p1_i2)).
assessment_occasion(entrusts_processing, 10, crisp, cite(cn_pipl_art_55_p1_i3)).
assessment_occasion(provides_to_another_handler, 11, crisp, cite(cn_pipl_art_55_p1_i3)).
assessment_occasion(makes_personal_information_public, 12, crisp, cite(cn_pipl_art_55_p1_i3)).
assessment_occasion(provides_outside_china, 13, crisp, cite(cn_pipl_art_55_p1_i4)).
assessment_occasion(other_significant_impact_processing, 14, judgement, cite(cn_pipl_art_55_p1_i5)).

final_citations(compliance_measures, not_required, [cite(cn_pipl_art_51_p1), cite(cn_pipl_art_73_p1_i1)]).
final_citations(compliance_measures, required, [cite(cn_pipl_art_51_p1), cite(cn_pipl_art_73_p1_i1)]).
final_citations(protection_officer, not_required, [cite(cn_pipl_art_52_p1), cite(cn_pipl_art_73_p1_i1)]).
final_citations(protection_officer, required, [cite(cn_pipl_art_52_p1), cite(cn_pipl_art_73_p1_i1)]).
final_citations(officer_contact_details, not_required, [cite(cn_pipl_art_52_p1), cite(cn_pipl_art_52_p2), cite(cn_pipl_art_73_p1_i1)]).
final_citations(officer_contact_details, required, [cite(cn_pipl_art_52_p1), cite(cn_pipl_art_52_p2), cite(cn_pipl_art_73_p1_i1)]).
final_citations(china_representative, not_required, [cite(cn_pipl_art_53_p1), cite(cn_pipl_art_3_p2), cite(cn_pipl_art_3_p2_i1), cite(cn_pipl_art_3_p2_i2), cite(cn_pipl_art_3_p2_i3), cite(cn_pipl_art_73_p1_i1)]).
final_citations(china_representative, required, [cite(cn_pipl_art_53_p1), cite(cn_pipl_art_3_p2), cite(cn_pipl_art_3_p2_i1), cite(cn_pipl_art_3_p2_i2), cite(cn_pipl_art_3_p2_i3), cite(cn_pipl_art_73_p1_i1)]).
final_citations(compliance_audit, not_required, [cite(cn_pipl_art_54_p1), cite(cn_pipl_art_73_p1_i1)]).
final_citations(compliance_audit, required, [cite(cn_pipl_art_54_p1), cite(cn_pipl_art_73_p1_i1)]).
final_citations(impact_assessment, not_required, [cite(cn_pipl_art_55_p1), cite(cn_pipl_art_55_p1_i1), cite(cn_pipl_art_55_p1_i2), cite(cn_pipl_art_55_p1_i3), cite(cn_pipl_art_55_p1_i4), cite(cn_pipl_art_55_p1_i5), cite(cn_pipl_art_73_p1_i1), cite(cn_pipl_art_73_p1_i2)]).
final_citations(impact_assessment, required_in_advance, [cite(cn_pipl_art_55_p1), cite(cn_pipl_art_55_p1_i1), cite(cn_pipl_art_55_p1_i2), cite(cn_pipl_art_55_p1_i3), cite(cn_pipl_art_55_p1_i4), cite(cn_pipl_art_55_p1_i5), cite(cn_pipl_art_56_p1), cite(cn_pipl_art_73_p1_i1), cite(cn_pipl_art_73_p1_i2)]).
final_citations(assessment_record_retention, not_required, [cite(cn_pipl_art_55_p1), cite(cn_pipl_art_55_p1_i1), cite(cn_pipl_art_55_p1_i2), cite(cn_pipl_art_55_p1_i3), cite(cn_pipl_art_55_p1_i4), cite(cn_pipl_art_55_p1_i5), cite(cn_pipl_art_73_p1_i1), cite(cn_pipl_art_73_p1_i2)]).
final_citations(assessment_record_retention, required_for_at_least_three_years, [cite(cn_pipl_art_56_p2), cite(cn_pipl_art_55_p1), cite(cn_pipl_art_55_p1_i1), cite(cn_pipl_art_55_p1_i2), cite(cn_pipl_art_55_p1_i3), cite(cn_pipl_art_55_p1_i4), cite(cn_pipl_art_55_p1_i5), cite(cn_pipl_art_73_p1_i1), cite(cn_pipl_art_73_p1_i2)]).
final_citations(breach_remedial_measures, not_required, [cite(cn_pipl_art_57_p1), cite(cn_pipl_art_73_p1_i1)]).
final_citations(breach_remedial_measures, required_immediately, [cite(cn_pipl_art_57_p1), cite(cn_pipl_art_73_p1_i1)]).
final_citations(breach_notice_to_department, not_required, [cite(cn_pipl_art_57_p1), cite(cn_pipl_art_73_p1_i1)]).
final_citations(breach_notice_to_department, required, [cite(cn_pipl_art_57_p1), cite(cn_pipl_art_73_p1_i1)]).
final_citations(breach_notice_to_individuals, not_required, [cite(cn_pipl_art_57_p1), cite(cn_pipl_art_57_p2), cite(cn_pipl_art_73_p1_i1)]).
final_citations(breach_notice_to_individuals, required, [cite(cn_pipl_art_57_p1), cite(cn_pipl_art_57_p2), cite(cn_pipl_art_73_p1_i1)]).
final_citations(breach_notice_to_individuals, notice_may_be_omitted, [cite(cn_pipl_art_57_p1), cite(cn_pipl_art_57_p2), cite(cn_pipl_art_73_p1_i1)]).
final_citations(large_platform_obligations, not_required, [cite(cn_pipl_art_58_p1), cite(cn_pipl_art_73_p1_i1)]).
final_citations(large_platform_obligations, required, [cite(cn_pipl_art_58_p1), cite(cn_pipl_art_73_p1_i1)]).
final_citations(entrusted_party_safeguards, not_required, [cite(cn_pipl_art_59_p1)]).
final_citations(entrusted_party_safeguards, required, [cite(cn_pipl_art_59_p1)]).

referral_row(handler_for_handler_duties, decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1), [decides_purposes_and_means]).
referral_row(handler_for_representative, decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1), [decides_purposes_and_means, offers_products_or_services_to_individuals_in_china, analyses_or_evaluates_individuals_in_china]).
referral_row(products_or_services_purpose, offers_products_or_services_to_individuals_in_china, cite(cn_pipl_art_3_p2_i1), [decides_purposes_and_means, offers_products_or_services_to_individuals_in_china, analyses_or_evaluates_individuals_in_china]).
referral_row(analysis_or_evaluation, analyses_or_evaluates_individuals_in_china, cite(cn_pipl_art_3_p2_i2), [decides_purposes_and_means, offers_products_or_services_to_individuals_in_china, analyses_or_evaluates_individuals_in_china]).
referral_row(handler_for_impact_assessment, decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1), [decides_purposes_and_means, other_significant_impact_processing]).
referral_row(other_significant_impact, other_significant_impact_processing, cite(cn_pipl_art_55_p1_i5), [decides_purposes_and_means, other_significant_impact_processing]).
referral_row(handler_for_individual_notice, decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1), [decides_purposes_and_means, harm_effectively_avoided]).
referral_row(harm_effectively_avoided, harm_effectively_avoided, cite(cn_pipl_art_57_p2), [decides_purposes_and_means, harm_effectively_avoided]).
referral_row(handler_for_large_platform, decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1), [decides_purposes_and_means, important_platform_handler]).
referral_row(important_platform, important_platform_handler, cite(cn_pipl_art_58_p1), [decides_purposes_and_means, important_platform_handler]).

content_row(compliance_measures, internal_management_rules_and_operating_procedures, cite(cn_pipl_art_51_p1_i1)).
content_row(compliance_measures, classified_management_of_personal_information, cite(cn_pipl_art_51_p1_i2)).
content_row(compliance_measures, encryption_and_de_identification_security_measures, cite(cn_pipl_art_51_p1_i3)).
content_row(compliance_measures, operating_permissions_and_staff_security_training, cite(cn_pipl_art_51_p1_i4)).
content_row(compliance_measures, security_incident_emergency_plan, cite(cn_pipl_art_51_p1_i5)).
content_row(compliance_measures, other_measures_prescribed_by_law, cite(cn_pipl_art_51_p1_i6)).
content_row(impact_assessment, lawfulness_legitimacy_and_necessity_of_purpose_and_method, cite(cn_pipl_art_56_p1_i1)).
content_row(impact_assessment, impact_on_rights_and_security_risks, cite(cn_pipl_art_56_p1_i2)).
content_row(impact_assessment, lawfulness_effectiveness_and_proportionality_of_protection_measures, cite(cn_pipl_art_56_p1_i3)).
content_row(breach_notice, categories_causes_and_possible_harm, cite(cn_pipl_art_57_p1_i1)).
content_row(breach_notice, remedial_measures_and_steps_individuals_can_take, cite(cn_pipl_art_57_p1_i2)).
content_row(breach_notice, handler_contact_details, cite(cn_pipl_art_57_p1_i3)).
content_row(large_platform_obligations, compliance_system_and_independent_supervisory_body, cite(cn_pipl_art_58_p1_i1)).
content_row(large_platform_obligations, platform_rules_for_providers_on_the_platform, cite(cn_pipl_art_58_p1_i2)).
content_row(large_platform_obligations, stop_services_to_providers_in_serious_violation, cite(cn_pipl_art_58_p1_i3)).
content_row(large_platform_obligations, regular_social_responsibility_report, cite(cn_pipl_art_58_p1_i4)).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, Value) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

key_is_false(Profile, Key) :-
    key_state(Profile, Key, false).

key_not_true(Profile, Key) :-
    key_state(Profile, Key, State),
    dif(State, true).

key_not_false(Profile, Key) :-
    key_state(Profile, Key, State),
    dif(State, false).

relied_pairs(_, [], []).
relied_pairs(Profile, [Key|Keys], Pairs) :-
    key_state(Profile, Key, State),
    relied_pair(State, Key, LaterPairs, Pairs),
    relied_pairs(Profile, Keys, LaterPairs).

relied_pair(absent, _, LaterPairs, LaterPairs).
relied_pair(Value, Key, LaterPairs, [Key - Value|LaterPairs]) :-
    dif(Value, absent).

referral(Situation, Profile, needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)])) :-
    referral_row(Situation, Input, Citation, Inputs),
    relied_pairs(Profile, Inputs, Pairs).

representative_case_keys(Keys) :-
    findall(Key, representative_case(Key, _), Keys).

assessment_occasion_keys(Keys) :-
    findall(Key, assessment_occasion(Key, _, _, _), Keys).

crisp_assessment_occasion_keys(Keys) :-
    findall(Key, assessment_occasion(Key, _, crisp, _), Keys).

handler_duty(Duty) :-
    duty_group(Duty, Group),
    dif(Group, entrustment).

reference_day_state(Profile, State) :-
    implements(cn_pipl_art_74_p1),
    profile_get(Profile, reference_date, date(ReferenceYear, ReferenceMonth, ReferenceDayNumber)),
    entry_into_force_day(EntryYear, EntryMonth, EntryDayNumber, cite(cn_pipl_art_74_p1)),
    calendar_order(ReferenceYear, ReferenceMonth, ReferenceDayNumber, EntryYear, EntryMonth, EntryDayNumber, Order),
    order_state(Order, State).

calendar_order(Year, Month, DayNumber, OtherYear, OtherMonth, OtherDayNumber, Order) :-
    compare(YearOrder, Year, OtherYear),
    month_order(YearOrder, Month, DayNumber, OtherMonth, OtherDayNumber, Order).

month_order(<, _, _, _, _, <).
month_order(>, _, _, _, _, >).
month_order(=, Month, DayNumber, OtherMonth, OtherDayNumber, Order) :-
    compare(MonthOrder, Month, OtherMonth),
    day_order(MonthOrder, DayNumber, OtherDayNumber, Order).

day_order(<, _, _, <).
day_order(>, _, _, >).
day_order(=, DayNumber, OtherDayNumber, Order) :-
    compare(Order, DayNumber, OtherDayNumber).

order_state(<, before_entry_into_force).
order_state(=, from_entry_into_force).
order_state(>, from_entry_into_force).

duty_status(Duty, Profile, Result, Citations) :-
    pipl_handler_duties_input_problems(Profile, Problems),
    checked_duty_status(Problems, Duty, Profile, Result, Citations).

checked_duty_status([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
checked_duty_status([], Duty, Profile, Result, Citations) :-
    findall(Step, duty_step(Duty, Profile, Step, _, _), Steps),
    min_list(Steps, FirstStep),
    duty_step(Duty, Profile, FirstStep, Result, Citations).

duty_step(_, Profile, 1, not_in_force, [cite(cn_pipl_art_74_p1)]) :-
    implements(cn_pipl_art_74_p1),
    reference_day_state(Profile, before_entry_into_force).
duty_step(_, Profile, 2, indeterminate([reference_date]), []) :-
    implements(cn_pipl_art_74_p1),
    key_state(Profile, reference_date, absent).
duty_step(_, Profile, 3, indeterminate([pinned_articles_unamended_on_reference_date]), []) :-
    implements(cn_pipl_art_74_p1),
    key_state(Profile, pinned_articles_unamended_on_reference_date, absent).
duty_step(_, Profile, 4, pinned_text_not_applicable, []) :-
    implements(cn_pipl_art_74_p1),
    key_state(Profile, pinned_articles_unamended_on_reference_date, false).
duty_step(Duty, Profile, 5, not_required, Citations) :-
    implements(cn_pipl_art_73_p1_i1),
    handler_duty(Duty),
    key_state(Profile, decides_purposes_and_means, false),
    final_citations(Duty, not_required, Citations).
duty_step(Duty, Profile, AbsentStep, indeterminate([decides_purposes_and_means]), []) :-
    implements(cn_pipl_art_73_p1_i1),
    duty_group(Duty, Group),
    handler_steps(Group, AbsentStep, _, _),
    key_state(Profile, decides_purposes_and_means, absent).
duty_step(Duty, Profile, UnsureStep, Result, []) :-
    implements(cn_pipl_art_73_p1_i1),
    duty_group(Duty, Group),
    handler_steps(Group, _, UnsureStep, Situation),
    key_state(Profile, decides_purposes_and_means, unsure),
    referral(Situation, Profile, Result).
duty_step(Duty, Profile, 6, not_required, Citations) :-
    implements(cn_pipl_art_52_p1),
    duty_condition(Duty, reaches_officer_quantity),
    key_state(Profile, reaches_officer_quantity, false),
    final_citations(Duty, not_required, Citations).
duty_step(Duty, Profile, 8, indeterminate([reaches_officer_quantity]), []) :-
    implements(cn_pipl_art_52_p1),
    duty_condition(Duty, reaches_officer_quantity),
    key_state(Profile, reaches_officer_quantity, absent).
duty_step(Duty, Profile, 6, not_required, Citations) :-
    implements(cn_pipl_art_57_p1),
    duty_condition(Duty, incident_occurred_or_possible),
    key_state(Profile, incident_occurred_or_possible, false),
    final_citations(Duty, not_required, Citations).
duty_step(Duty, Profile, 8, indeterminate([incident_occurred_or_possible]), []) :-
    implements(cn_pipl_art_57_p1),
    duty_condition(Duty, incident_occurred_or_possible),
    key_state(Profile, incident_occurred_or_possible, absent).
duty_step(Duty, Profile, 6, not_required, Citations) :-
    implements(cn_pipl_art_58_p1),
    duty_condition(Duty, important_platform_handler),
    key_state(Profile, important_platform_handler, false),
    final_citations(Duty, not_required, Citations).
duty_step(Duty, Profile, 8, indeterminate([important_platform_handler]), []) :-
    implements(cn_pipl_art_58_p1),
    duty_condition(Duty, important_platform_handler),
    key_state(Profile, important_platform_handler, absent).
duty_step(compliance_measures, _Profile, 8, required, Citations) :-
    implements(cn_pipl_art_51_p1),
    final_citations(compliance_measures, required, Citations).
duty_step(compliance_audit, _Profile, 8, required, Citations) :-
    implements(cn_pipl_art_54_p1),
    final_citations(compliance_audit, required, Citations).
duty_step(protection_officer, _Profile, 10, required, Citations) :-
    implements(cn_pipl_art_52_p1),
    final_citations(protection_officer, required, Citations).
duty_step(officer_contact_details, _Profile, 10, required, Citations) :-
    implements(cn_pipl_art_52_p2),
    final_citations(officer_contact_details, required, Citations).
duty_step(breach_remedial_measures, _Profile, 10, required_immediately, Citations) :-
    implements(cn_pipl_art_57_p1),
    final_citations(breach_remedial_measures, required_immediately, Citations).
duty_step(breach_notice_to_department, _Profile, 10, required, Citations) :-
    implements(cn_pipl_art_57_p1),
    final_citations(breach_notice_to_department, required, Citations).
duty_step(large_platform_obligations, Profile, 10, Result, []) :-
    implements(cn_pipl_art_58_p1),
    key_state(Profile, important_platform_handler, unsure),
    referral(important_platform, Profile, Result).
duty_step(large_platform_obligations, _Profile, 11, required, Citations) :-
    implements(cn_pipl_art_58_p1),
    final_citations(large_platform_obligations, required, Citations).
duty_step(china_representative, Profile, 6, not_required, Citations) :-
    implements(cn_pipl_art_53_p1),
    key_state(Profile, handler_located_outside_china, false),
    final_citations(china_representative, not_required, Citations).
duty_step(china_representative, Profile, 7, not_required, Citations) :-
    implements(cn_pipl_art_3_p2),
    key_state(Profile, personal_information_of_individuals_in_china, false),
    final_citations(china_representative, not_required, Citations).
duty_step(china_representative, Profile, 8, not_required, Citations) :-
    implements(cn_pipl_art_3_p2),
    representative_case_keys(CaseKeys),
    maplist(key_is_false(Profile), CaseKeys),
    final_citations(china_representative, not_required, Citations).
duty_step(china_representative, Profile, 10, indeterminate([handler_located_outside_china]), []) :-
    implements(cn_pipl_art_53_p1),
    key_state(Profile, handler_located_outside_china, absent).
duty_step(china_representative, Profile, 11, indeterminate([personal_information_of_individuals_in_china]), []) :-
    implements(cn_pipl_art_3_p2),
    key_state(Profile, personal_information_of_individuals_in_china, absent).
duty_step(china_representative, Profile, 12, indeterminate([offers_products_or_services_to_individuals_in_china]), []) :-
    implements(cn_pipl_art_3_p2_i1),
    key_state(Profile, offers_products_or_services_to_individuals_in_china, absent),
    key_not_true(Profile, analyses_or_evaluates_individuals_in_china),
    key_not_true(Profile, other_case_prescribed_by_law).
duty_step(china_representative, Profile, 13, indeterminate([analyses_or_evaluates_individuals_in_china]), []) :-
    implements(cn_pipl_art_3_p2_i2),
    key_state(Profile, analyses_or_evaluates_individuals_in_china, absent),
    key_not_true(Profile, offers_products_or_services_to_individuals_in_china),
    key_not_true(Profile, other_case_prescribed_by_law).
duty_step(china_representative, Profile, 14, indeterminate([other_case_prescribed_by_law]), []) :-
    implements(cn_pipl_art_3_p2_i3),
    key_state(Profile, other_case_prescribed_by_law, absent),
    key_not_true(Profile, offers_products_or_services_to_individuals_in_china),
    key_not_true(Profile, analyses_or_evaluates_individuals_in_china).
duty_step(china_representative, Profile, 16, Result, []) :-
    implements(cn_pipl_art_3_p2_i1),
    key_state(Profile, offers_products_or_services_to_individuals_in_china, unsure),
    key_not_true(Profile, analyses_or_evaluates_individuals_in_china),
    key_is_false(Profile, other_case_prescribed_by_law),
    referral(products_or_services_purpose, Profile, Result).
duty_step(china_representative, Profile, 17, Result, []) :-
    implements(cn_pipl_art_3_p2_i2),
    key_state(Profile, analyses_or_evaluates_individuals_in_china, unsure),
    key_is_false(Profile, offers_products_or_services_to_individuals_in_china),
    key_is_false(Profile, other_case_prescribed_by_law),
    referral(analysis_or_evaluation, Profile, Result).
duty_step(china_representative, _Profile, 18, required, Citations) :-
    implements(cn_pipl_art_53_p1),
    final_citations(china_representative, required, Citations).
duty_step(Duty, Profile, 6, not_required, Citations) :-
    implements(cn_pipl_art_55_p1),
    duty_group(Duty, assessment),
    assessment_occasion_keys(OccasionKeys),
    maplist(key_is_false(Profile), OccasionKeys),
    final_citations(Duty, not_required, Citations).
duty_step(Duty, Profile, Step, indeterminate([Key]), []) :-
    implements(cn_pipl_art_55_p1),
    duty_group(Duty, assessment),
    assessment_occasion(Key, Step, _, _),
    key_state(Profile, Key, absent),
    assessment_occasion_keys(OccasionKeys),
    maplist(key_not_true(Profile), OccasionKeys).
duty_step(Duty, Profile, 16, Result, []) :-
    implements(cn_pipl_art_55_p1_i5),
    duty_group(Duty, assessment),
    key_state(Profile, other_significant_impact_processing, unsure),
    crisp_assessment_occasion_keys(CrispKeys),
    maplist(key_is_false(Profile), CrispKeys),
    referral(other_significant_impact, Profile, Result).
duty_step(impact_assessment, _Profile, 17, required_in_advance, Citations) :-
    implements(cn_pipl_art_55_p1),
    final_citations(impact_assessment, required_in_advance, Citations).
duty_step(assessment_record_retention, _Profile, 17, required_for_at_least_three_years, Citations) :-
    implements(cn_pipl_art_56_p2),
    final_citations(assessment_record_retention, required_for_at_least_three_years, Citations).
duty_step(breach_notice_to_individuals, Profile, 9, required, Citations) :-
    implements(cn_pipl_art_57_p2),
    key_state(Profile, decides_purposes_and_means, true),
    key_state(Profile, department_required_individual_notice, true),
    final_citations(breach_notice_to_individuals, required, Citations).
duty_step(breach_notice_to_individuals, Profile, 10, required, Citations) :-
    implements(cn_pipl_art_57_p2),
    key_state(Profile, decides_purposes_and_means, true),
    key_state(Profile, harm_effectively_avoided, false),
    final_citations(breach_notice_to_individuals, required, Citations).
duty_step(breach_notice_to_individuals, Profile, 11, indeterminate([harm_effectively_avoided]), []) :-
    implements(cn_pipl_art_57_p2),
    key_state(Profile, harm_effectively_avoided, absent),
    key_not_true(Profile, department_required_individual_notice).
duty_step(breach_notice_to_individuals, Profile, 12, indeterminate([department_required_individual_notice]), []) :-
    implements(cn_pipl_art_57_p2),
    key_state(Profile, department_required_individual_notice, absent),
    key_not_false(Profile, harm_effectively_avoided).
duty_step(breach_notice_to_individuals, Profile, 14, Result, []) :-
    implements(cn_pipl_art_57_p2),
    key_state(Profile, harm_effectively_avoided, unsure),
    referral(harm_effectively_avoided, Profile, Result).
duty_step(breach_notice_to_individuals, _Profile, 15, notice_may_be_omitted, Citations) :-
    implements(cn_pipl_art_57_p2),
    final_citations(breach_notice_to_individuals, notice_may_be_omitted, Citations).
duty_step(entrusted_party_safeguards, Profile, 5, not_required, Citations) :-
    implements(cn_pipl_art_59_p1),
    key_state(Profile, processes_on_entrustment, false),
    final_citations(entrusted_party_safeguards, not_required, Citations).
duty_step(entrusted_party_safeguards, Profile, 6, indeterminate([processes_on_entrustment]), []) :-
    implements(cn_pipl_art_59_p1),
    key_state(Profile, processes_on_entrustment, absent).
duty_step(entrusted_party_safeguards, _Profile, 7, required, Citations) :-
    implements(cn_pipl_art_59_p1),
    final_citations(entrusted_party_safeguards, required, Citations).

duty_contents(compliance_measures, Items) :-
    implements(cn_pipl_art_51_p1),
    topic_items(compliance_measures, Items).
duty_contents(impact_assessment, Items) :-
    implements(cn_pipl_art_56_p1),
    topic_items(impact_assessment, Items).
duty_contents(breach_notice, Items) :-
    implements(cn_pipl_art_57_p1),
    topic_items(breach_notice, Items).
duty_contents(large_platform_obligations, Items) :-
    implements(cn_pipl_art_58_p1),
    topic_items(large_platform_obligations, Items).

topic_items(Topic, Items) :-
    findall(content_item(Name, Citation), content_row(Topic, Name, Citation), Items).

pipl_handler_duties_checklist(Profile, Checklist) :-
    decide_pipl_handler_duties(Profile, pipl_handler_duties_verdict(_Status, Checklist)).

duty_checklist(Profile, Checklist) :-
    duty_roster(Duties),
    maplist(duty_item(Profile), Duties, Checklist).

duty_item(Profile, Duty, item(Duty, Result, Citation)) :-
    duty_primary_citation(Duty, Citation),
    duty_status(Duty, Profile, Result, _Citations).

result_class(required, owed).
result_class(required_in_advance, owed).
result_class(required_immediately, owed).
result_class(required_for_at_least_three_years, owed).
result_class(not_required, not_owed).
result_class(notice_may_be_omitted, not_owed).
result_class(not_in_force, not_in_force).
result_class(pinned_text_not_applicable, pinned_text_not_applicable).
result_class(indeterminate(_), pending).
result_class(needs_legal_review(_, _), pending).

checklist_classes(Checklist, Classes) :-
    findall(Class, checklist_class(Checklist, Class), FoundClasses),
    sort(FoundClasses, Classes).

checklist_class(Checklist, Class) :-
    member(item(_, Result, _), Checklist),
    result_class(Result, Class).

decide_pipl_handler_duties(Profile, pipl_handler_duties_verdict(input_problems([Problem|Problems]), [])) :-
    pipl_handler_duties_input_problems(Profile, [Problem|Problems]).
decide_pipl_handler_duties(Profile, pipl_handler_duties_verdict(Status, Checklist)) :-
    pipl_handler_duties_input_problems(Profile, []),
    duty_checklist(Profile, Checklist),
    checklist_classes(Checklist, Classes),
    classes_status(Classes, Status).

classes_status(Classes, not_in_force) :-
    memberd_t(not_in_force, Classes, true).
classes_status(Classes, pinned_text_not_applicable) :-
    memberd_t(not_in_force, Classes, false),
    memberd_t(pinned_text_not_applicable, Classes, true).
classes_status(Classes, duties_owed) :-
    memberd_t(not_in_force, Classes, false),
    memberd_t(pinned_text_not_applicable, Classes, false),
    memberd_t(owed, Classes, true).
classes_status(Classes, duties_pending) :-
    memberd_t(not_in_force, Classes, false),
    memberd_t(pinned_text_not_applicable, Classes, false),
    memberd_t(owed, Classes, false),
    memberd_t(pending, Classes, true).
classes_status(Classes, no_duties_owed) :-
    memberd_t(not_in_force, Classes, false),
    memberd_t(pinned_text_not_applicable, Classes, false),
    memberd_t(owed, Classes, false),
    memberd_t(pending, Classes, false).

pipl_handler_duties_status(Profile, Status) :-
    decide_pipl_handler_duties(Profile, pipl_handler_duties_verdict(Status, _Checklist)).

pipl_handler_duties_decision_resolvable(Profile) :-
    decide_pipl_handler_duties(Profile, _Verdict).

base_profile(Extra, Profile) :-
    append([attribute(reference_date, date(2024, 1, 1)), attribute(pinned_articles_unamended_on_reference_date, true)], Extra, Profile).

test(the_day_before_entry_into_force_is_not_in_force) :-
    duty_status(compliance_measures, [attribute(reference_date, date(2021, 10, 31))], not_in_force, [cite(cn_pipl_art_74_p1)]).
test(the_day_of_entry_into_force_is_in_force) :-
    duty_status(compliance_measures, [attribute(reference_date, date(2021, 11, 1))], indeterminate([pinned_articles_unamended_on_reference_date]), []).
test(an_empty_profile_asks_for_the_reference_date) :-
    duty_status(entrusted_party_safeguards, [], indeterminate([reference_date]), []).
test(an_amended_text_is_not_applicable) :-
    duty_status(compliance_audit, [attribute(reference_date, date(2024, 1, 1)), attribute(pinned_articles_unamended_on_reference_date, false)], pinned_text_not_applicable, []).
test(an_unknown_key_is_an_input_problem) :-
    duty_status(compliance_audit, [attribute(colour, red)], input_problems([unknown_key(colour)]), []).
test(a_handler_owes_compliance_measures) :-
    base_profile([attribute(decides_purposes_and_means, true)], Profile),
    duty_status(compliance_measures, Profile, required, [cite(cn_pipl_art_51_p1), cite(cn_pipl_art_73_p1_i1)]).
test(an_unsure_handler_is_referred) :-
    base_profile([attribute(decides_purposes_and_means, unsure)], Profile),
    duty_status(compliance_measures, Profile, needs_legal_review(open_textured(decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1)), [inputs_relied_on([decides_purposes_and_means - unsure])]), []).
test(quantity_false_settles_the_officer_before_the_handler_is_named) :-
    base_profile([attribute(reaches_officer_quantity, false)], Profile),
    duty_status(protection_officer, Profile, not_required, [cite(cn_pipl_art_52_p1), cite(cn_pipl_art_73_p1_i1)]).
test(an_absent_quantity_is_named_before_an_unsure_handler_is_referred) :-
    base_profile([attribute(decides_purposes_and_means, unsure)], Profile),
    duty_status(officer_contact_details, Profile, indeterminate([reaches_officer_quantity]), []).
test(a_handler_inside_china_owes_no_representative) :-
    base_profile([attribute(handler_located_outside_china, false)], Profile),
    duty_status(china_representative, Profile, not_required, _).
test(an_offshore_handler_offering_services_owes_a_representative) :-
    base_profile([attribute(decides_purposes_and_means, true), attribute(handler_located_outside_china, true), attribute(personal_information_of_individuals_in_china, true), attribute(offers_products_or_services_to_individuals_in_china, true)], Profile),
    duty_status(china_representative, Profile, required, _).
test(an_unsure_products_purpose_is_referred_with_its_pairs) :-
    base_profile([attribute(decides_purposes_and_means, true), attribute(handler_located_outside_china, true), attribute(personal_information_of_individuals_in_china, true), attribute(offers_products_or_services_to_individuals_in_china, unsure), attribute(analyses_or_evaluates_individuals_in_china, false), attribute(other_case_prescribed_by_law, false)], Profile),
    duty_status(china_representative, Profile, needs_legal_review(open_textured(offers_products_or_services_to_individuals_in_china, cite(cn_pipl_art_3_p2_i1)), [inputs_relied_on([decides_purposes_and_means - true, offers_products_or_services_to_individuals_in_china - unsure, analyses_or_evaluates_individuals_in_china - false])]), []).
test(sensitive_information_needs_an_assessment_in_advance) :-
    base_profile([attribute(decides_purposes_and_means, true), attribute(processes_sensitive_personal_information, true)], Profile),
    duty_status(impact_assessment, Profile, required_in_advance, Citations),
    length(Citations, 9).
test(the_first_absent_occasion_is_named) :-
    base_profile([attribute(decides_purposes_and_means, true)], Profile),
    duty_status(assessment_record_retention, Profile, indeterminate([processes_sensitive_personal_information]), []).
test(an_unsure_significant_impact_is_referred) :-
    base_profile([attribute(decides_purposes_and_means, true), attribute(processes_sensitive_personal_information, false), attribute(uses_automated_decision_making, false), attribute(entrusts_processing, false), attribute(provides_to_another_handler, false), attribute(makes_personal_information_public, false), attribute(provides_outside_china, false), attribute(other_significant_impact_processing, unsure)], Profile),
    duty_status(impact_assessment, Profile, needs_legal_review(open_textured(other_significant_impact_processing, cite(cn_pipl_art_55_p1_i5)), [inputs_relied_on([decides_purposes_and_means - true, other_significant_impact_processing - unsure])]), []).
test(a_department_requirement_governs) :-
    base_profile([attribute(decides_purposes_and_means, true), attribute(incident_occurred_or_possible, true), attribute(harm_effectively_avoided, true), attribute(department_required_individual_notice, true)], Profile),
    findall(Result - Citations, duty_status(breach_notice_to_individuals, Profile, Result, Citations), Answers),
    Answers == [required - [cite(cn_pipl_art_57_p1), cite(cn_pipl_art_57_p2), cite(cn_pipl_art_73_p1_i1)]].
test(avoided_harm_without_requirement_permits_omission) :-
    base_profile([attribute(decides_purposes_and_means, true), attribute(incident_occurred_or_possible, true), attribute(harm_effectively_avoided, true), attribute(department_required_individual_notice, false)], Profile),
    duty_status(breach_notice_to_individuals, Profile, notice_may_be_omitted, _).
test(harm_is_named_before_the_department_requirement) :-
    base_profile([attribute(decides_purposes_and_means, true), attribute(incident_occurred_or_possible, true)], Profile),
    duty_status(breach_notice_to_individuals, Profile, indeterminate([harm_effectively_avoided]), []).
test(an_incident_needs_remedial_measures_immediately) :-
    base_profile([attribute(decides_purposes_and_means, true), attribute(incident_occurred_or_possible, true)], Profile),
    duty_status(breach_remedial_measures, Profile, required_immediately, _).
test(an_unsure_platform_is_referred) :-
    base_profile([attribute(decides_purposes_and_means, true), attribute(important_platform_handler, unsure)], Profile),
    duty_status(large_platform_obligations, Profile, needs_legal_review(open_textured(important_platform_handler, cite(cn_pipl_art_58_p1)), [inputs_relied_on([decides_purposes_and_means - true, important_platform_handler - unsure])]), []).
test(an_entrusted_party_owes_safeguards_without_the_handler_key) :-
    base_profile([attribute(processes_on_entrustment, true)], Profile),
    duty_status(entrusted_party_safeguards, Profile, required, [cite(cn_pipl_art_59_p1)]).
test(the_breach_notice_contents_are_one_list) :-
    findall(Items, duty_contents(breach_notice, Items), Answers),
    length(Answers, 1),
    duty_contents(breach_notice, [content_item(categories_causes_and_possible_harm, cite(cn_pipl_art_57_p1_i1)), content_item(remedial_measures_and_steps_individuals_can_take, cite(cn_pipl_art_57_p1_i2)), content_item(handler_contact_details, cite(cn_pipl_art_57_p1_i3))]).
test(the_compliance_measures_are_six) :-
    duty_contents(compliance_measures, Items),
    length(Items, 6).
test(a_handler_has_duties_owed) :-
    base_profile([attribute(decides_purposes_and_means, true)], Profile),
    decide_pipl_handler_duties(Profile, pipl_handler_duties_verdict(duties_owed, Checklist)),
    length(Checklist, 12).
test(a_bad_profile_gets_its_problems_in_the_verdict) :-
    decide_pipl_handler_duties([attribute(colour, red)], pipl_handler_duties_verdict(input_problems([unknown_key(colour)]), [])).
test(an_early_day_is_not_in_force_for_the_facade) :-
    pipl_handler_duties_status([attribute(reference_date, date(2020, 1, 1))], not_in_force).

test(the_day_of_entry_into_force_is_not_not_in_force, fail) :-
    duty_status(compliance_measures, [attribute(reference_date, date(2021, 11, 1))], not_in_force, _).
test(avoided_harm_without_requirement_is_not_required_notice, fail) :-
    base_profile([attribute(decides_purposes_and_means, true), attribute(incident_occurred_or_possible, true), attribute(harm_effectively_avoided, true), attribute(department_required_individual_notice, false)], Profile),
    duty_status(breach_notice_to_individuals, Profile, required, _).
