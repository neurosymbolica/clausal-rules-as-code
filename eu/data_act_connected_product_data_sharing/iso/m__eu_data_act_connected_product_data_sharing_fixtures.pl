% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_act_connected_product_data_sharing_fixtures, [data_act_connected_product_data_sharing_subject/1, data_act_connected_product_data_sharing_profile_for/2, data_act_connected_product_data_sharing_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_act_connected_product_data_sharing_data_act_connected_product_data_sharing, [decide_data_act_connected_product_data_sharing/2]).

data_act_connected_product_data_sharing_subject(thermostat_access_due).
data_act_connected_product_data_sharing_subject(thermostat_directly_accessible).
data_act_connected_product_data_sharing_subject(thermostat_security_restriction).
data_act_connected_product_data_sharing_subject(wearable_other_person_data_without_basis).
data_act_connected_product_data_sharing_subject(wearable_other_person_data_with_basis).
data_act_connected_product_data_sharing_subject(tractor_trade_secret_measures_breached).
data_act_connected_product_data_sharing_subject(tractor_trade_secret_measures_kept).
data_act_connected_product_data_sharing_subject(tractor_exceptional_refusal).
data_act_connected_product_data_sharing_subject(access_requester_absent).
data_act_connected_product_data_sharing_subject(access_data_holder_unsure).
data_act_connected_product_data_sharing_subject(not_connected_product_only).
data_act_connected_product_data_sharing_subject(small_enterprise_exempt).
data_act_connected_product_data_sharing_subject(small_enterprise_not_exempt).
data_act_connected_product_data_sharing_subject(design_duty_met_complete).
data_act_connected_product_data_sharing_subject(design_default_access_missing).
data_act_connected_product_data_sharing_subject(placed_before_september_2026).
data_act_connected_product_data_sharing_subject(purchase_information_given).
data_act_connected_product_data_sharing_subject(related_service_information_given).
data_act_connected_product_data_sharing_subject(related_service_information_withheld).
data_act_connected_product_data_sharing_subject(information_kind_absent).
data_act_connected_product_data_sharing_subject(sharing_due_clean).
data_act_connected_product_data_sharing_subject(gatekeeper_recipient).
data_act_connected_product_data_sharing_subject(prototype_testing_not_permitted).
data_act_connected_product_data_sharing_subject(prototype_testing_permitted).
data_act_connected_product_data_sharing_subject(sharing_other_person_data_without_basis).
data_act_connected_product_data_sharing_subject(sharing_trade_secret_not_strictly_necessary).
data_act_connected_product_data_sharing_subject(sharing_trade_secret_measures_breached).
data_act_connected_product_data_sharing_subject(sharing_exceptional_refusal).
data_act_connected_product_data_sharing_subject(input_unknown_key).
data_act_connected_product_data_sharing_subject(input_duplicate_key).
data_act_connected_product_data_sharing_subject(input_unsure_boolean).
data_act_connected_product_data_sharing_subject(input_attested_value).
data_act_connected_product_data_sharing_subject(input_not_a_list).

access_base_profile([attribute(connected_product_or_related_service, true), attribute(small_enterprise_exemption_applies, false), attribute(requester_is_user, true), attribute(addressee_is_data_holder, true), attribute(requested_data_readily_available, true), attribute(data_directly_accessible_by_user, false), attribute(security_restriction_agreed_applies, false), attribute(other_persons_personal_data_requested, false), attribute(gdpr_conditions_for_making_available_met, true), attribute(requested_data_identified_as_trade_secrets, false), attribute(trade_secret_measures_agreed_and_kept, true), attribute(exceptional_trade_secret_refusal_invoked, false)]).

sharing_base_profile([attribute(connected_product_or_related_service, true), attribute(small_enterprise_exemption_applies, false), attribute(request_by_or_on_behalf_of_user, true), attribute(addressee_is_data_holder, true), attribute(requested_data_readily_available, true), attribute(testing_data_not_yet_on_market, false), attribute(third_party_use_contractually_permitted, false), attribute(third_party_is_designated_gatekeeper, false), attribute(other_persons_personal_data_requested, false), attribute(gdpr_conditions_for_making_available_met, true), attribute(requested_data_identified_as_trade_secrets, false), attribute(trade_secret_disclosure_strictly_necessary, true), attribute(trade_secret_measures_agreed_and_kept, true), attribute(exceptional_trade_secret_refusal_invoked, false)]).

design_base_profile([attribute(connected_product_or_related_service, true), attribute(small_enterprise_exemption_applies, false), attribute(placed_on_market_after_12_september_2026, true), attribute(data_accessible_by_default_as_required, true), attribute(directly_accessible_where_relevant_and_feasible, true)]).

information_base_profile([attribute(connected_product_or_related_service, true), attribute(small_enterprise_exemption_applies, false), attribute(pre_contract_contract_kind, purchase_rent_or_lease_of_connected_product), attribute(required_information_provided_before_contract, true)]).

replaced([], _, _, []).
replaced([attribute(ElementKey, _OldValue)|Elements], Key, NewValue, [attribute(ElementKey, NewValue)|Edited]) :-
    ElementKey == Key,
    replaced(Elements, Key, NewValue, Edited).
replaced([attribute(ElementKey, Value)|Elements], Key, NewValue, [attribute(ElementKey, Value)|Edited]) :-
    ElementKey \== Key,
    replaced(Elements, Key, NewValue, Edited).

removed([], _, []).
removed([attribute(ElementKey, _OldValue)|Elements], Key, Remaining) :-
    ElementKey == Key,
    removed(Elements, Key, Remaining).
removed([attribute(ElementKey, Value)|Elements], Key, [attribute(ElementKey, Value)|Remaining]) :-
    ElementKey \== Key,
    removed(Elements, Key, Remaining).

data_act_connected_product_data_sharing_profile_for(thermostat_access_due, Profile) :-
    access_base_profile(Profile).
data_act_connected_product_data_sharing_profile_for(thermostat_directly_accessible, Profile) :-
    access_base_profile(BaseProfile),
    replaced(BaseProfile, data_directly_accessible_by_user, true, Profile).
data_act_connected_product_data_sharing_profile_for(thermostat_security_restriction, Profile) :-
    access_base_profile(BaseProfile),
    replaced(BaseProfile, security_restriction_agreed_applies, true, Profile).
data_act_connected_product_data_sharing_profile_for(wearable_other_person_data_without_basis, Profile) :-
    access_base_profile(BaseProfile),
    replaced(BaseProfile, other_persons_personal_data_requested, true, PersonalProfile),
    replaced(PersonalProfile, gdpr_conditions_for_making_available_met, false, Profile).
data_act_connected_product_data_sharing_profile_for(wearable_other_person_data_with_basis, Profile) :-
    access_base_profile(BaseProfile),
    replaced(BaseProfile, other_persons_personal_data_requested, true, Profile).
data_act_connected_product_data_sharing_profile_for(tractor_trade_secret_measures_breached, Profile) :-
    access_base_profile(BaseProfile),
    replaced(BaseProfile, requested_data_identified_as_trade_secrets, true, SecretProfile),
    replaced(SecretProfile, trade_secret_measures_agreed_and_kept, false, Profile).
data_act_connected_product_data_sharing_profile_for(tractor_trade_secret_measures_kept, Profile) :-
    access_base_profile(BaseProfile),
    replaced(BaseProfile, requested_data_identified_as_trade_secrets, true, Profile).
data_act_connected_product_data_sharing_profile_for(tractor_exceptional_refusal, Profile) :-
    access_base_profile(BaseProfile),
    replaced(BaseProfile, requested_data_identified_as_trade_secrets, true, SecretProfile),
    replaced(SecretProfile, exceptional_trade_secret_refusal_invoked, true, Profile).
data_act_connected_product_data_sharing_profile_for(access_requester_absent, Profile) :-
    access_base_profile(BaseProfile),
    removed(BaseProfile, requester_is_user, Profile).
data_act_connected_product_data_sharing_profile_for(access_data_holder_unsure, Profile) :-
    access_base_profile(BaseProfile),
    replaced(BaseProfile, addressee_is_data_holder, unsure, Profile).
data_act_connected_product_data_sharing_profile_for(not_connected_product_only, [attribute(connected_product_or_related_service, false)]).
data_act_connected_product_data_sharing_profile_for(small_enterprise_exempt, [attribute(connected_product_or_related_service, true), attribute(small_enterprise_exemption_applies, true)]).
data_act_connected_product_data_sharing_profile_for(small_enterprise_not_exempt, [attribute(connected_product_or_related_service, true), attribute(small_enterprise_exemption_applies, false)]).
data_act_connected_product_data_sharing_profile_for(design_duty_met_complete, Profile) :-
    design_base_profile(Profile).
data_act_connected_product_data_sharing_profile_for(design_default_access_missing, Profile) :-
    design_base_profile(BaseProfile),
    replaced(BaseProfile, data_accessible_by_default_as_required, false, Profile).
data_act_connected_product_data_sharing_profile_for(placed_before_september_2026, Profile) :-
    design_base_profile(BaseProfile),
    replaced(BaseProfile, placed_on_market_after_12_september_2026, false, Profile).
data_act_connected_product_data_sharing_profile_for(purchase_information_given, Profile) :-
    information_base_profile(Profile).
data_act_connected_product_data_sharing_profile_for(related_service_information_given, Profile) :-
    information_base_profile(BaseProfile),
    replaced(BaseProfile, pre_contract_contract_kind, provision_of_related_service, Profile).
data_act_connected_product_data_sharing_profile_for(related_service_information_withheld, Profile) :-
    information_base_profile(BaseProfile),
    replaced(BaseProfile, pre_contract_contract_kind, provision_of_related_service, ServiceProfile),
    replaced(ServiceProfile, required_information_provided_before_contract, false, Profile).
data_act_connected_product_data_sharing_profile_for(information_kind_absent, Profile) :-
    information_base_profile(BaseProfile),
    removed(BaseProfile, pre_contract_contract_kind, KindlessProfile),
    replaced(KindlessProfile, required_information_provided_before_contract, unsure, Profile).
data_act_connected_product_data_sharing_profile_for(sharing_due_clean, Profile) :-
    sharing_base_profile(Profile).
data_act_connected_product_data_sharing_profile_for(gatekeeper_recipient, Profile) :-
    sharing_base_profile(BaseProfile),
    replaced(BaseProfile, third_party_is_designated_gatekeeper, true, Profile).
data_act_connected_product_data_sharing_profile_for(prototype_testing_not_permitted, Profile) :-
    sharing_base_profile(BaseProfile),
    replaced(BaseProfile, testing_data_not_yet_on_market, true, Profile).
data_act_connected_product_data_sharing_profile_for(prototype_testing_permitted, Profile) :-
    sharing_base_profile(BaseProfile),
    replaced(BaseProfile, testing_data_not_yet_on_market, true, TestingProfile),
    replaced(TestingProfile, third_party_use_contractually_permitted, true, Profile).
data_act_connected_product_data_sharing_profile_for(sharing_other_person_data_without_basis, Profile) :-
    sharing_base_profile(BaseProfile),
    replaced(BaseProfile, other_persons_personal_data_requested, true, PersonalProfile),
    replaced(PersonalProfile, gdpr_conditions_for_making_available_met, false, Profile).
data_act_connected_product_data_sharing_profile_for(sharing_trade_secret_not_strictly_necessary, Profile) :-
    sharing_base_profile(BaseProfile),
    replaced(BaseProfile, requested_data_identified_as_trade_secrets, true, SecretProfile),
    replaced(SecretProfile, trade_secret_disclosure_strictly_necessary, false, Profile).
data_act_connected_product_data_sharing_profile_for(sharing_trade_secret_measures_breached, Profile) :-
    sharing_base_profile(BaseProfile),
    replaced(BaseProfile, requested_data_identified_as_trade_secrets, true, SecretProfile),
    replaced(SecretProfile, trade_secret_measures_agreed_and_kept, false, Profile).
data_act_connected_product_data_sharing_profile_for(sharing_exceptional_refusal, Profile) :-
    sharing_base_profile(BaseProfile),
    replaced(BaseProfile, requested_data_identified_as_trade_secrets, true, SecretProfile),
    replaced(SecretProfile, exceptional_trade_secret_refusal_invoked, true, Profile).
data_act_connected_product_data_sharing_profile_for(input_unknown_key, [attribute(colour, red)]).
data_act_connected_product_data_sharing_profile_for(input_duplicate_key, [attribute(requester_is_user, true), attribute(requester_is_user, false)]).
data_act_connected_product_data_sharing_profile_for(input_unsure_boolean, [attribute(other_persons_personal_data_requested, unsure)]).
data_act_connected_product_data_sharing_profile_for(input_attested_value, [attribute(requester_is_user, attested(true))]).
data_act_connected_product_data_sharing_profile_for(input_not_a_list, not_an_attribute_list).

data_act_connected_product_data_sharing_assess(Subject, Result) :-
    data_act_connected_product_data_sharing_profile_for(Subject, Profile),
    decide_data_act_connected_product_data_sharing(Profile, Result).
