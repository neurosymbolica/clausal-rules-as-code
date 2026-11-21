% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_queries, [gdpr_common_definitions_data_and_processing_profile_keys/1, gdpr_common_definitions_data_and_processing_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_kernel, [gdpr_common_definitions_data_and_processing_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_common_definitions_data_and_processing_gdpr_common_definitions_data_and_processing, [gdpr_common_definitions_data_and_processing_status/2]).

gdpr_common_definitions_data_and_processing_profile_keys([information_relates_to_natural_person, natural_person_identified, natural_person_identifiable, operation_performed_on_the_data, stored_data_marked_to_limit_future_processing, processing_automated, evaluates_personal_aspects_of_natural_person, attribution_needs_additional_information, additional_information_kept_separately, measures_prevent_attribution, structured_set_accessible_by_specific_criteria, data_disclosed_to_receiving_body, receiving_body_public_authority_in_particular_inquiry, receiving_body_is_data_subject, receiving_body_is_controller_or_processor, receiving_body_authorised_under_direct_authority, indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action, breach_of_security, breach_led_to_listed_outcome, service_is_information_society_service, organisation_governed_by_public_international_law, body_set_up_by_agreement_between_countries]).

gdpr_common_definitions_data_and_processing_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    gdpr_common_definitions_data_and_processing_input_problems(Profile, Problems),
    what_if_given_problems(Problems, Profile, OverriddenKey, NewValue, NewStatus).

what_if_given_problems([_|_], Profile, _, _, NewStatus) :-
    gdpr_common_definitions_data_and_processing_status(Profile, NewStatus).
what_if_given_problems([], Profile, OverriddenKey, NewValue, NewStatus) :-
    replace_attribute(Profile, OverriddenKey, NewValue, Hypothesis),
    gdpr_common_definitions_data_and_processing_status(Hypothesis, NewStatus).

replace_attribute([], Key, Value, [attribute(Key, Value)]).
replace_attribute([attribute(ItemKey, ItemValue)|Items], Key, Value, [attribute(ItemKey, ItemValue)|Remaining]) :-
    ItemKey \== Key,
    replace_attribute(Items, Key, Value, Remaining).
replace_attribute([attribute(ItemKey, _)|Items], Key, Value, Remaining) :-
    ItemKey == Key,
    replace_attribute(Items, Key, Value, Remaining).

test(what_if_identified_makes_personal_data_met) :-
    gdpr_common_definitions_data_and_processing_what_if([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, false)], natural_person_identified, true, classification(DefinitionRows)),
    member(definition(personal_data, definition_answer(met, none, [cite(eu_reg_2016_679_art_4_1)])), DefinitionRows).
test(what_if_unidentified_stays_open) :-
    gdpr_common_definitions_data_and_processing_what_if([attribute(information_relates_to_natural_person, true), attribute(natural_person_identified, true)], natural_person_identified, false, classification(DefinitionRows)),
    member(definition(personal_data, definition_answer(indeterminate([natural_person_identifiable]), none, [cite(eu_reg_2016_679_art_4_1)])), DefinitionRows).
test(what_if_with_a_wrong_value_is_an_input_problem) :-
    gdpr_common_definitions_data_and_processing_what_if([], natural_person_identified, unsure, NewStatus),
    NewStatus == input_problems([wrong_type(natural_person_identified)]).
test(what_if_on_a_bad_profile_keeps_its_problems) :-
    gdpr_common_definitions_data_and_processing_what_if(nothing, natural_person_identified, true, NewStatus),
    NewStatus == input_problems([wrong_type(profile)]).
test(what_if_gives_exactly_one_answer) :-
    findall(NewStatus, gdpr_common_definitions_data_and_processing_what_if([attribute(processing_automated, false)], processing_automated, true, NewStatus), Answers),
    length(Answers, 1).
test(the_key_schema_has_twenty_six_keys) :-
    gdpr_common_definitions_data_and_processing_profile_keys(ProfileKeys),
    length(ProfileKeys, 26).
