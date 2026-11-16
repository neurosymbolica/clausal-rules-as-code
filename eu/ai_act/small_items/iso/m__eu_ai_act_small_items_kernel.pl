% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_small_items_kernel, [small_items_input_problems/2, small_items_assessment_date_t/2, small_items_date_before_t/3, small_items_step_zero_problems/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(error), [must_be/2]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).

small_items_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [bias_processing_capacity, strictly_necessary_for_bias_detection_and_correction_under_article_10_2_f_and_g, strictly_necessary_for_bias_detection_and_correction_of_biases_affecting_health_safety_or_fundamental_rights, appropriate_safeguards_for_fundamental_rights_and_freedoms, bias_detection_cannot_be_effectively_fulfilled_by_processing_other_data, technical_limitations_on_reuse_and_state_of_the_art_security_and_privacy_preserving_measures, measures_securing_and_protecting_the_data_with_strict_access_controls_and_documentation, data_not_transmitted_transferred_or_otherwise_accessed_by_other_parties, data_deleted_once_bias_corrected_or_retention_period_ended, records_of_processing_include_the_reasons_for_the_processing, sandbox_processing_of_data_collected_for_other_purposes_solely_for_developing_training_and_testing, developed_for_safeguarding_substantial_public_interest, public_interest_area, data_necessary_for_chapter_iii_section_2_requirements_and_non_personal_data_not_effective, effective_monitoring_and_response_mechanisms, functionally_separate_isolated_and_protected_environment_under_provider_control, data_shared_only_as_article_59_allows, processing_leads_to_no_measures_or_decisions_affecting_data_subjects_or_their_rights, appropriate_technical_and_organisational_measures, data_deleted_at_end_of_participation_or_retention_period, processing_logs_kept_for_the_duration_of_participation, description_of_process_and_rationale_kept_in_technical_documentation, project_summary_published_on_competent_authority_website, for_law_enforcement_purposes_under_law_enforcement_authority_control, based_on_specific_union_or_national_law, testing_route, member_state_has_adopted_a_real_world_testing_framework, testing_plan_drawn_up_and_submitted_to_the_market_surveillance_authority, approval_status, national_law_provides_for_tacit_approval, testing_registered_as_article_60_4_c_requires, established_in_the_union_or_legal_representative_established_in_the_union, third_country_transfers_only_with_appropriate_and_applicable_safeguards, testing_duration, extension_notified_in_advance_with_explanation, testing_no_longer_than_necessary_to_achieve_its_objectives, vulnerable_subjects_appropriately_protected, testing_in_cooperation_with_deployers, deployers_informed_instructed_and_agreement_concluded, informed_consent_given_in_accordance_with_article_61, law_enforcement_testing_where_seeking_consent_would_prevent_the_test, no_negative_effect_on_subjects_and_data_deleted_after_the_test, effectively_overseen_by_suitably_qualified_persons, outputs_can_be_effectively_reversed_and_disregarded, consent_freely_given, consent_obtained_before_participation, information_concise_clear_relevant_and_understandable, informed_of_nature_objectives_and_possible_inconvenience, informed_of_conditions_and_expected_duration, informed_of_rights_and_guarantees_including_refusal_and_withdrawal, informed_of_arrangements_for_reversal_or_disregarding, informed_of_identification_number_and_contact_details, consent_dated_and_documented, copy_given_to_the_subject_or_legal_representative, is_an_sme_including_a_start_up, has_partner_or_linked_enterprises, affected_person_subject_to_a_deployer_decision_based_on_the_system_output, system_is_a_high_risk_ai_system_listed_in_annex_iii, system_listed_under_point_2_of_annex_iii, decision_produces_legal_effects_or_similarly_significantly_affects_the_person, person_considers_an_adverse_impact_on_health_safety_or_fundamental_rights, union_or_national_law_provides_an_exception_or_restriction, right_otherwise_provided_for_under_union_law],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(bias_processing_capacity, enum([provider_of_a_high_risk_system, other_provider_or_deployer])).
key_type(strictly_necessary_for_bias_detection_and_correction_under_article_10_2_f_and_g, judgement).
key_type(strictly_necessary_for_bias_detection_and_correction_of_biases_affecting_health_safety_or_fundamental_rights, judgement).
key_type(appropriate_safeguards_for_fundamental_rights_and_freedoms, judgement).
key_type(bias_detection_cannot_be_effectively_fulfilled_by_processing_other_data, judgement).
key_type(technical_limitations_on_reuse_and_state_of_the_art_security_and_privacy_preserving_measures, judgement).
key_type(measures_securing_and_protecting_the_data_with_strict_access_controls_and_documentation, judgement).
key_type(data_not_transmitted_transferred_or_otherwise_accessed_by_other_parties, boolean).
key_type(data_deleted_once_bias_corrected_or_retention_period_ended, boolean).
key_type(records_of_processing_include_the_reasons_for_the_processing, boolean).
key_type(sandbox_processing_of_data_collected_for_other_purposes_solely_for_developing_training_and_testing, boolean).
key_type(developed_for_safeguarding_substantial_public_interest, judgement).
key_type(public_interest_area, enum([public_safety_and_public_health, environment, energy_sustainability, transport_and_critical_infrastructure, public_administration_and_public_services, none_of_the_listed_areas])).
key_type(data_necessary_for_chapter_iii_section_2_requirements_and_non_personal_data_not_effective, judgement).
key_type(effective_monitoring_and_response_mechanisms, judgement).
key_type(functionally_separate_isolated_and_protected_environment_under_provider_control, boolean).
key_type(data_shared_only_as_article_59_allows, boolean).
key_type(processing_leads_to_no_measures_or_decisions_affecting_data_subjects_or_their_rights, boolean).
key_type(appropriate_technical_and_organisational_measures, judgement).
key_type(data_deleted_at_end_of_participation_or_retention_period, boolean).
key_type(processing_logs_kept_for_the_duration_of_participation, boolean).
key_type(description_of_process_and_rationale_kept_in_technical_documentation, boolean).
key_type(project_summary_published_on_competent_authority_website, boolean).
key_type(for_law_enforcement_purposes_under_law_enforcement_authority_control, boolean).
key_type(based_on_specific_union_or_national_law, boolean).
key_type(testing_route, enum([annex_iii, annex_i_section_a, annex_i_section_b])).
key_type(member_state_has_adopted_a_real_world_testing_framework, boolean).
key_type(testing_plan_drawn_up_and_submitted_to_the_market_surveillance_authority, boolean).
key_type(approval_status, enum([approved, no_answer_within_30_days, not_approved])).
key_type(national_law_provides_for_tacit_approval, boolean).
key_type(testing_registered_as_article_60_4_c_requires, boolean).
key_type(established_in_the_union_or_legal_representative_established_in_the_union, boolean).
key_type(third_country_transfers_only_with_appropriate_and_applicable_safeguards, judgement).
key_type(testing_duration, enum([up_to_six_months, extended_up_to_twelve_months, longer])).
key_type(extension_notified_in_advance_with_explanation, boolean).
key_type(testing_no_longer_than_necessary_to_achieve_its_objectives, judgement).
key_type(vulnerable_subjects_appropriately_protected, judgement).
key_type(testing_in_cooperation_with_deployers, boolean).
key_type(deployers_informed_instructed_and_agreement_concluded, boolean).
key_type(informed_consent_given_in_accordance_with_article_61, boolean).
key_type(law_enforcement_testing_where_seeking_consent_would_prevent_the_test, boolean).
key_type(no_negative_effect_on_subjects_and_data_deleted_after_the_test, boolean).
key_type(effectively_overseen_by_suitably_qualified_persons, judgement).
key_type(outputs_can_be_effectively_reversed_and_disregarded, judgement).
key_type(consent_freely_given, judgement).
key_type(consent_obtained_before_participation, boolean).
key_type(information_concise_clear_relevant_and_understandable, judgement).
key_type(informed_of_nature_objectives_and_possible_inconvenience, boolean).
key_type(informed_of_conditions_and_expected_duration, boolean).
key_type(informed_of_rights_and_guarantees_including_refusal_and_withdrawal, boolean).
key_type(informed_of_arrangements_for_reversal_or_disregarding, boolean).
key_type(informed_of_identification_number_and_contact_details, boolean).
key_type(consent_dated_and_documented, boolean).
key_type(copy_given_to_the_subject_or_legal_representative, boolean).
key_type(is_an_sme_including_a_start_up, boolean).
key_type(has_partner_or_linked_enterprises, boolean).
key_type(affected_person_subject_to_a_deployer_decision_based_on_the_system_output, boolean).
key_type(system_is_a_high_risk_ai_system_listed_in_annex_iii, boolean).
key_type(system_listed_under_point_2_of_annex_iii, boolean).
key_type(decision_produces_legal_effects_or_similarly_significantly_affects_the_person, judgement).
key_type(person_considers_an_adverse_impact_on_health_safety_or_fundamental_rights, boolean).
key_type(union_or_national_law_provides_an_exception_or_restriction, boolean).
key_type(right_otherwise_provided_for_under_union_law, boolean).

attribute_list_t(Term, false) :-
    var(Term).
attribute_list_t(Term, true) :-
    Term == [].
attribute_list_t(Term, T) :-
    nonvar(Term),
    Term = [Element|Elements],
    attribute_t(Element, ElementIsAttribute),
    attribute_list_t(Elements, ElementsAreAttributes),
    truth_and(ElementIsAttribute, ElementsAreAttributes, T).
attribute_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

attribute_t(Element, false) :-
    var(Element).
attribute_t(Element, true) :-
    nonvar(Element),
    Element = attribute(_, _).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

identical_member_t(_, [], false).
identical_member_t(Term, [Item|_], true) :-
    Term == Item.
identical_member_t(Term, [Item|Items], T) :-
    Term \== Item,
    identical_member_t(Term, Items, T).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    identical_member_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

name_unknown_key(true, _, Known, Elements, Problems) :-
    unknown_keys(Elements, Known, Problems).
name_unknown_key(false, Key, Known, Elements, [unknown_key(Key)|Problems]) :-
    unknown_keys(Elements, [Key|Known], Problems).

key_problems([], _, Problems, Problems).
key_problems([Key|Keys], Profile, LaterProblems, Problems) :-
    key_type(Key, Type),
    key_occurrences(Profile, Key, Occurrences),
    key_problems(Keys, Profile, LaterProblems, KeyProblems),
    name_key_problem(Occurrences, Key, Type, Profile, KeyProblems, Problems).

key_occurrences([], _, none).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey == Key,
    key_occurrences(Elements, Key, RestOccurrences),
    one_more_occurrence(RestOccurrences, Occurrences).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey \== Key,
    key_occurrences(Elements, Key, Occurrences).

one_more_occurrence(none, one).
one_more_occurrence(one, many).
one_more_occurrence(many, many).

name_key_problem(none, _, _, _, Problems, Problems).
name_key_problem(many, Key, _, _, Problems, [duplicate_key(Key)|Problems]).
name_key_problem(one, Key, Type, Profile, KeyProblems, Problems) :-
    values_in_type_t(Profile, Key, Type, InType),
    name_wrong_type(InType, Key, KeyProblems, Problems).

name_wrong_type(true, _, Problems, Problems).
name_wrong_type(false, Key, Problems, [wrong_type(Key)|Problems]).

values_in_type_t([], _, _, true).
values_in_type_t([attribute(ElementKey, Value)|Elements], Key, Type, T) :-
    ElementKey == Key,
    value_in_type_t(Type, Value, ValueInType),
    values_in_type_t(Elements, Key, Type, RestInType),
    truth_and(ValueInType, RestInType, T).
values_in_type_t([attribute(ElementKey, _)|Elements], Key, Type, T) :-
    ElementKey \== Key,
    values_in_type_t(Elements, Key, Type, T).

value_in_type_t(Type, Value, T) :-
    term_variables(Value, Variables),
    ground_value_in_type_t(Variables, Type, Value, T).

ground_value_in_type_t([_|_], _, _, false).
ground_value_in_type_t([], Type, Value, T) :-
    in_type_t(Type, Value, T).

in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).

small_items_assessment_date_t(Date, false) :-
    var(Date).
small_items_assessment_date_t(Date, false) :-
    nonvar(Date),
    Date \= date(_, _, _).
small_items_assessment_date_t(Date, Truth) :-
    nonvar(Date),
    Date = date(Year, Month, Day),
    integer_t(Year, YearIsInteger),
    integer_t(Month, MonthIsInteger),
    integer_t(Day, DayIsInteger),
    truth_and(YearIsInteger, MonthIsInteger, YearAndMonthAreIntegers),
    truth_and(YearAndMonthAreIntegers, DayIsInteger, AllAreIntegers),
    calendar_day_t(AllAreIntegers, Year, Month, Day, Truth).

integer_t(Value, Truth) :-
    catch(integer_confirmed(Value, Truth), _, Truth = false).

integer_confirmed(Value, true) :-
    must_be(integer, Value).

calendar_day_t(false, _, _, _, false).
calendar_day_t(true, Year, Month, Day, Truth) :-
    month_in_range_t(Month, MonthIsValid),
    day_in_month_t(MonthIsValid, Year, Month, Day, Truth).

month_in_range_t(Month, Truth) :-
    MonthInRange #<==> Month #>= 1 #/\ Month #=< 12,
    binary_truth(MonthInRange, Truth).

day_in_month_t(false, _, _, _, false).
day_in_month_t(true, Year, Month, Day, Truth) :-
    calendar_month_length(Year, Month, LastDay),
    DayInRange #<==> Day #>= 1 #/\ Day #=< LastDay,
    binary_truth(DayInRange, Truth).

calendar_month_length(Year, 2, LastDay) :-
    LeapYear #<==> Year mod 4 #= 0 #/\ Year mod 100 #\= 0 #\/ Year mod 400 #= 0,
    LastDay #= 28 + LeapYear.
calendar_month_length(_, Month, LastDay) :-
    fixed_month_length(Month, LastDay).

fixed_month_length(1, 31).
fixed_month_length(3, 31).
fixed_month_length(4, 30).
fixed_month_length(5, 31).
fixed_month_length(6, 30).
fixed_month_length(7, 31).
fixed_month_length(8, 31).
fixed_month_length(9, 30).
fixed_month_length(10, 31).
fixed_month_length(11, 30).
fixed_month_length(12, 31).

binary_truth(1, true).
binary_truth(0, false).

small_items_date_before_t(Date, BoundDate, Truth) :-
    day_key(Date, DayKey),
    day_key(BoundDate, BoundDayKey),
    IsBefore #<==> DayKey #< BoundDayKey,
    binary_truth(IsBefore, Truth).

day_key(date(Year, Month, Day), DayKey) :-
    DayKey #= Year * 10000 + Month * 100 + Day.

small_items_step_zero_problems(Profile, Date, Problems) :-
    small_items_input_problems(Profile, ProfileProblems),
    small_items_assessment_date_t(Date, DateIsValid),
    add_date_problem(DateIsValid, ProfileProblems, Problems).

add_date_problem(true, Problems, Problems).
add_date_problem(false, ProfileProblems, Problems) :-
    append(ProfileProblems, [wrong_type(assessment_date)], Problems).

test(an_empty_profile_has_no_problem) :-
    small_items_input_problems([], Problems),
    Problems == [].
test(an_unbound_profile_is_wrong_type) :-
    small_items_input_problems(_, Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_key_is_unknown_as_given) :-
    small_items_input_problems([attribute(Key, true)], Problems),
    Problems == [unknown_key(Key)].
test(a_repeated_key_is_a_duplicate_only) :-
    small_items_input_problems([attribute(consent_freely_given, maybe), attribute(consent_freely_given, true)], Problems),
    Problems == [duplicate_key(consent_freely_given)].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    small_items_input_problems([attribute(consent_dated_and_documented, unsure)], Problems),
    Problems == [wrong_type(consent_dated_and_documented)].
test(a_real_day_is_valid) :-
    small_items_assessment_date_t(date(2026, 8, 2), true).
test(a_leap_day_is_valid) :-
    small_items_assessment_date_t(date(2028, 2, 29), true).
test(a_non_leap_twenty_ninth_february_is_invalid) :-
    small_items_assessment_date_t(date(2026, 2, 29), false).
test(thirtieth_february_is_invalid) :-
    small_items_assessment_date_t(date(2026, 2, 30), false).
test(an_unbound_date_is_invalid) :-
    small_items_assessment_date_t(_, false).
test(the_day_before_is_before) :-
    small_items_date_before_t(date(2026, 7, 26), date(2026, 7, 27), true).
test(the_day_itself_is_not_before) :-
    small_items_date_before_t(date(2026, 7, 27), date(2026, 7, 27), false).
test(step_zero_puts_the_date_last) :-
    small_items_step_zero_problems([attribute(unheard_of, true)], date(2026, 2, 30), Problems),
    Problems == [unknown_key(unheard_of), wrong_type(assessment_date)].
