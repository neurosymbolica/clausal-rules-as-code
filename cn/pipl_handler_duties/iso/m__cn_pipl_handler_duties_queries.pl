% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_handler_duties_queries, [pipl_handler_duties_profile_keys/1, pipl_handler_duties_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__cn_pipl_handler_duties_kernel, [pipl_handler_duties_input_problems/2]).
:- use_module(m__cn_pipl_handler_duties_pipl_handler_duties, [pipl_handler_duties_status/2]).

pipl_handler_duties_profile_keys([reference_date, pinned_articles_unamended_on_reference_date, decides_purposes_and_means, processes_on_entrustment, reaches_officer_quantity, handler_located_outside_china, personal_information_of_individuals_in_china, offers_products_or_services_to_individuals_in_china, analyses_or_evaluates_individuals_in_china, other_case_prescribed_by_law, processes_sensitive_personal_information, uses_automated_decision_making, entrusts_processing, provides_to_another_handler, makes_personal_information_public, provides_outside_china, other_significant_impact_processing, incident_occurred_or_possible, harm_effectively_avoided, department_required_individual_notice, important_platform_handler]).

pipl_handler_duties_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    pipl_handler_duties_input_problems(Profile, Problems),
    hypothesis_profile(Problems, Profile, OverriddenKey, NewValue, Hypothesis),
    pipl_handler_duties_status(Hypothesis, NewStatus).

hypothesis_profile([wrong_type(profile)], Profile, _, _, Profile).
hypothesis_profile(Problems, Profile, OverriddenKey, NewValue, Hypothesis) :-
    dif(Problems, [wrong_type(profile)]),
    attributes_without_key(Profile, OverriddenKey, KeptAttributes),
    append(KeptAttributes, [attribute(OverriddenKey, NewValue)], Hypothesis).

attributes_without_key([], _, []).
attributes_without_key([attribute(ElementKey, _ElementValue)|Elements], Key, KeptAttributes) :-
    ElementKey == Key,
    attributes_without_key(Elements, Key, KeptAttributes).
attributes_without_key([attribute(ElementKey, ElementValue)|Elements], Key, [attribute(ElementKey, ElementValue)|KeptAttributes]) :-
    ElementKey \== Key,
    attributes_without_key(Elements, Key, KeptAttributes).

test(the_schema_has_twenty_one_keys) :-
    pipl_handler_duties_profile_keys(Keys),
    length(Keys, 21).
test(setting_entrustment_turns_no_duties_into_duties_owed) :-
    pipl_handler_duties_what_if([attribute(reference_date, date(2024, 1, 1)), attribute(pinned_articles_unamended_on_reference_date, true), attribute(decides_purposes_and_means, false), attribute(processes_on_entrustment, false)], processes_on_entrustment, true, duties_owed).
test(the_unchanged_profile_owes_no_duties) :-
    pipl_handler_duties_status([attribute(reference_date, date(2024, 1, 1)), attribute(pinned_articles_unamended_on_reference_date, true), attribute(decides_purposes_and_means, false), attribute(processes_on_entrustment, false)], no_duties_owed).
test(the_override_replaces_rather_than_duplicates) :-
    findall(Status, pipl_handler_duties_what_if([attribute(reference_date, date(2020, 1, 1))], reference_date, date(2024, 1, 1), Status), Statuses),
    Statuses == [duties_pending].
test(the_override_removes_a_duplicated_key) :-
    findall(Status, pipl_handler_duties_what_if([attribute(reference_date, date(2024, 1, 1)), attribute(pinned_articles_unamended_on_reference_date, true), attribute(decides_purposes_and_means, true), attribute(decides_purposes_and_means, false)], decides_purposes_and_means, true, Status), Statuses),
    Statuses == [duties_owed].
test(a_non_list_profile_keeps_its_problem) :-
    pipl_handler_duties_what_if(stray, reference_date, date(2024, 1, 1), input_problems([wrong_type(profile)])).
