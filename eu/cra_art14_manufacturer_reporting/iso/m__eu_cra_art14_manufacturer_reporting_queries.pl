% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_cra_art14_manufacturer_reporting_queries, [cra_art14_manufacturer_reporting_profile_keys/1, cra_art14_manufacturer_reporting_what_if/4]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_cra_art14_manufacturer_reporting_kernel, [cra_art14_manufacturer_reporting_input_problems/2]).
:- use_module(m__eu_cra_art14_manufacturer_reporting_cra_art14_manufacturer_reporting, [cra_art14_manufacturer_reporting_status/2]).

cra_art14_manufacturer_reporting_profile_keys([affects_protection_of_sensitive_or_important_data_or_functions, leads_to_malicious_code_in_product_or_user_systems, early_warning_without_undue_delay, notification_without_undue_delay]).

cra_art14_manufacturer_reporting_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    attributes_without_key(Profile, OverriddenKey, OtherAttributes),
    append(OtherAttributes, [attribute(OverriddenKey, NewValue)], Hypothesis),
    cra_art14_manufacturer_reporting_status(Hypothesis, NewStatus).

attributes_without_key([], _OverriddenKey, []).
attributes_without_key([attribute(AttributeKey, _AttributeValue)|Attributes], OverriddenKey, Kept) :-
    AttributeKey == OverriddenKey,
    attributes_without_key(Attributes, OverriddenKey, Kept).
attributes_without_key([attribute(AttributeKey, AttributeValue)|Attributes], OverriddenKey, [attribute(AttributeKey, AttributeValue)|Kept]) :-
    AttributeKey \== OverriddenKey,
    attributes_without_key(Attributes, OverriddenKey, Kept).

test(what_if_turns_not_severe_into_severe) :-
    cra_art14_manufacturer_reporting_what_if([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], affects_protection_of_sensitive_or_important_data_or_functions, true, severe).
test(what_if_unchanged_value_keeps_not_severe) :-
    cra_art14_manufacturer_reporting_what_if([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], affects_protection_of_sensitive_or_important_data_or_functions, false, not_severe).
test(what_if_replaces_a_duplicated_key) :-
    cra_art14_manufacturer_reporting_what_if([attribute(affects_protection_of_sensitive_or_important_data_or_functions, true), attribute(affects_protection_of_sensitive_or_important_data_or_functions, true)], affects_protection_of_sensitive_or_important_data_or_functions, false, indeterminate([leads_to_malicious_code_in_product_or_user_systems])).
test(what_if_unsure_limb_refers) :-
    cra_art14_manufacturer_reporting_what_if([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false), attribute(leads_to_malicious_code_in_product_or_user_systems, false)], leads_to_malicious_code_in_product_or_user_systems, unsure, needs_legal_review(open_textured(leads_to_malicious_code_in_product_or_user_systems, cite(eu_reg_2024_2847_art_14_5_b)), [inputs_relied_on([affects_protection_of_sensitive_or_important_data_or_functions - false, leads_to_malicious_code_in_product_or_user_systems - unsure])])).
test(what_if_yields_one_answer) :-
    findall(NewStatus, cra_art14_manufacturer_reporting_what_if([], leads_to_malicious_code_in_product_or_user_systems, true, NewStatus), Answers),
    Answers == [severe].
test(profile_keys_are_the_four_contract_keys) :-
    cra_art14_manufacturer_reporting_profile_keys(ProfileKeys),
    length(ProfileKeys, 4).

test(what_if_does_not_create_a_duplicate_key, fail) :-
    cra_art14_manufacturer_reporting_what_if([attribute(affects_protection_of_sensitive_or_important_data_or_functions, false)], affects_protection_of_sensitive_or_important_data_or_functions, true, input_problems(_Problems)).
