% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_scope_and_entity_types_queries, [dora_scope_and_entity_types_profile_keys/1, dora_scope_and_entity_types_what_if/4, out_of_scope/0, financial_entity/0, dora_entity_type/0, aifm_under_article_3_2_of_directive_2011_61/0, undertaking_under_article_4_of_directive_2009_138/0, iorp_pension_scheme_members_total/0, exempted_under_articles_2_and_3_of_directive_2014_65/0, financial_entity_is_microenterprise/0, financial_entity_is_small_or_medium_sized_enterprise/0, post_office_giro_institution_under_article_2_5_3_of_directive_2013_36/0, exempted_from_dora_scope_by_member_state/0, credit_institution/0, institution_exempted_pursuant_to_directive_2013_36/0, payment_institution/0, exempted_payment_institution/0, account_information_service_provider/0, electronic_money_institution/0, exempted_electronic_money_institution/0, investment_firm/0, crypto_asset_service_provider/0, issuer_of_asset_referenced_tokens/0, central_securities_depository/0, central_counterparty/0, trading_venue/0, trade_repository/0, manager_of_alternative_investment_funds/0, management_company/0, data_reporting_service_provider/0, insurance_undertaking/0, reinsurance_undertaking/0, insurance_intermediary/0, reinsurance_intermediary/0, ancillary_insurance_intermediary/0, institution_for_occupational_retirement_provision/0, credit_rating_agency/0, administrator_of_critical_benchmarks/0, crowdfunding_service_provider/0, securitisation_repository/0, ict_third_party_service_provider/0, none_of_the_listed_types/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_scope_and_entity_types_kernel, [dora_scope_and_entity_types_input_problems/2]).
:- use_module(m__eu_dora_scope_and_entity_types_dora_scope_and_entity_types, [dora_scope_and_entity_types_status/2]).

dora_scope_and_entity_types_profile_keys([dora_entity_type, aifm_under_article_3_2_of_directive_2011_61, undertaking_under_article_4_of_directive_2009_138, iorp_pension_scheme_members_total, exempted_under_articles_2_and_3_of_directive_2014_65, financial_entity_is_microenterprise, financial_entity_is_small_or_medium_sized_enterprise, post_office_giro_institution_under_article_2_5_3_of_directive_2013_36, exempted_from_dora_scope_by_member_state]).

dora_scope_and_entity_types_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    dora_scope_and_entity_types_input_problems(Profile, Problems),
    what_if_from_problems(Problems, Profile, OverriddenKey, NewValue, NewStatus).

what_if_from_problems([wrong_type(profile)], Profile, _, _, NewStatus) :-
    dora_scope_and_entity_types_status(Profile, NewStatus).
what_if_from_problems(Problems, Profile, OverriddenKey, NewValue, NewStatus) :-
    dif(Problems, [wrong_type(profile)]),
    attributes_without_key(Profile, OverriddenKey, KeptAttributes),
    append(KeptAttributes, [attribute(OverriddenKey, NewValue)], Hypothesis),
    dora_scope_and_entity_types_status(Hypothesis, NewStatus).

attributes_without_key([], _, []).
attributes_without_key([attribute(ElementKey, ElementValue)|Elements], OverriddenKey, [attribute(ElementKey, ElementValue)|KeptAttributes]) :-
    ElementKey \== OverriddenKey,
    attributes_without_key(Elements, OverriddenKey, KeptAttributes).
attributes_without_key([attribute(ElementKey, _)|Elements], OverriddenKey, KeptAttributes) :-
    ElementKey == OverriddenKey,
    attributes_without_key(Elements, OverriddenKey, KeptAttributes).

out_of_scope.

financial_entity.

dora_entity_type.

aifm_under_article_3_2_of_directive_2011_61.

undertaking_under_article_4_of_directive_2009_138.

iorp_pension_scheme_members_total.

exempted_under_articles_2_and_3_of_directive_2014_65.

financial_entity_is_microenterprise.

financial_entity_is_small_or_medium_sized_enterprise.

post_office_giro_institution_under_article_2_5_3_of_directive_2013_36.

exempted_from_dora_scope_by_member_state.

credit_institution.

institution_exempted_pursuant_to_directive_2013_36.

payment_institution.

exempted_payment_institution.

account_information_service_provider.

electronic_money_institution.

exempted_electronic_money_institution.

investment_firm.

crypto_asset_service_provider.

issuer_of_asset_referenced_tokens.

central_securities_depository.

central_counterparty.

trading_venue.

trade_repository.

manager_of_alternative_investment_funds.

management_company.

data_reporting_service_provider.

insurance_undertaking.

reinsurance_undertaking.

insurance_intermediary.

reinsurance_intermediary.

ancillary_insurance_intermediary.

institution_for_occupational_retirement_provision.

credit_rating_agency.

administrator_of_critical_benchmarks.

crowdfunding_service_provider.

securitisation_repository.

ict_third_party_service_provider.

none_of_the_listed_types.

test(what_if_supplies_the_missing_giro_fact) :-
    findall(NewStatus, dora_scope_and_entity_types_what_if([attribute(dora_entity_type, credit_institution)], post_office_giro_institution_under_article_2_5_3_of_directive_2013_36, true, NewStatus), Statuses),
    Statuses == [out_of_scope].
test(what_if_replaces_a_present_value) :-
    findall(NewStatus, dora_scope_and_entity_types_what_if([attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, 16)], iorp_pension_scheme_members_total, 15, NewStatus), Statuses),
    Statuses == [out_of_scope].
test(what_if_on_a_non_list_keeps_the_input_problem) :-
    findall(NewStatus, dora_scope_and_entity_types_what_if(not_an_attribute_list, dora_entity_type, trading_venue, NewStatus), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].
test(profile_keys_are_the_nine_contract_keys) :-
    dora_scope_and_entity_types_profile_keys(ContractKeys),
    length(ContractKeys, 9).
test(root_atoms_are_served) :-
    out_of_scope,
    financial_entity,
    dora_entity_type,
    none_of_the_listed_types,
    ict_third_party_service_provider.
