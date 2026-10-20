:- module(m__eu_procurement_directive_2014_24_art4_thresholds, [art4_threshold/4, current_art4_threshold/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(deadline_lib, [date_before/2, date_after/2, date_on_or_before/2, date_on_or_after/2]).

art4_threshold_amount(works, central_government_authority, date(2016, 1, 1), date(2018, 1, 1), 5225000).
art4_threshold_amount(works, sub_central_contracting_authority, date(2016, 1, 1), date(2018, 1, 1), 5225000).
art4_threshold_amount(works, body_governed_by_public_law, date(2016, 1, 1), date(2018, 1, 1), 5225000).
art4_threshold_amount(supplies, central_government_authority, date(2016, 1, 1), date(2018, 1, 1), 135000).
art4_threshold_amount(services, central_government_authority, date(2016, 1, 1), date(2018, 1, 1), 135000).
art4_threshold_amount(supplies, sub_central_contracting_authority, date(2016, 1, 1), date(2018, 1, 1), 209000).
art4_threshold_amount(supplies, body_governed_by_public_law, date(2016, 1, 1), date(2018, 1, 1), 209000).
art4_threshold_amount(services, sub_central_contracting_authority, date(2016, 1, 1), date(2018, 1, 1), 209000).
art4_threshold_amount(services, body_governed_by_public_law, date(2016, 1, 1), date(2018, 1, 1), 209000).
art4_threshold_amount(social_and_other_specific_services, central_government_authority, date(2016, 1, 1), date(2018, 1, 1), 750000).
art4_threshold_amount(social_and_other_specific_services, sub_central_contracting_authority, date(2016, 1, 1), date(2018, 1, 1), 750000).
art4_threshold_amount(social_and_other_specific_services, body_governed_by_public_law, date(2016, 1, 1), date(2018, 1, 1), 750000).
art4_threshold_amount(works, central_government_authority, date(2018, 1, 1), date(2020, 1, 1), 5548000).
art4_threshold_amount(works, sub_central_contracting_authority, date(2018, 1, 1), date(2020, 1, 1), 5548000).
art4_threshold_amount(works, body_governed_by_public_law, date(2018, 1, 1), date(2020, 1, 1), 5548000).
art4_threshold_amount(supplies, central_government_authority, date(2018, 1, 1), date(2020, 1, 1), 144000).
art4_threshold_amount(services, central_government_authority, date(2018, 1, 1), date(2020, 1, 1), 144000).
art4_threshold_amount(supplies, sub_central_contracting_authority, date(2018, 1, 1), date(2020, 1, 1), 221000).
art4_threshold_amount(supplies, body_governed_by_public_law, date(2018, 1, 1), date(2020, 1, 1), 221000).
art4_threshold_amount(services, sub_central_contracting_authority, date(2018, 1, 1), date(2020, 1, 1), 221000).
art4_threshold_amount(services, body_governed_by_public_law, date(2018, 1, 1), date(2020, 1, 1), 221000).
art4_threshold_amount(social_and_other_specific_services, central_government_authority, date(2018, 1, 1), date(2020, 1, 1), 750000).
art4_threshold_amount(social_and_other_specific_services, sub_central_contracting_authority, date(2018, 1, 1), date(2020, 1, 1), 750000).
art4_threshold_amount(social_and_other_specific_services, body_governed_by_public_law, date(2018, 1, 1), date(2020, 1, 1), 750000).
art4_threshold_amount(works, central_government_authority, date(2020, 1, 1), date(2022, 1, 1), 5350000).
art4_threshold_amount(works, sub_central_contracting_authority, date(2020, 1, 1), date(2022, 1, 1), 5350000).
art4_threshold_amount(works, body_governed_by_public_law, date(2020, 1, 1), date(2022, 1, 1), 5350000).
art4_threshold_amount(supplies, central_government_authority, date(2020, 1, 1), date(2022, 1, 1), 139000).
art4_threshold_amount(services, central_government_authority, date(2020, 1, 1), date(2022, 1, 1), 139000).
art4_threshold_amount(supplies, sub_central_contracting_authority, date(2020, 1, 1), date(2022, 1, 1), 214000).
art4_threshold_amount(supplies, body_governed_by_public_law, date(2020, 1, 1), date(2022, 1, 1), 214000).
art4_threshold_amount(services, sub_central_contracting_authority, date(2020, 1, 1), date(2022, 1, 1), 214000).
art4_threshold_amount(services, body_governed_by_public_law, date(2020, 1, 1), date(2022, 1, 1), 214000).
art4_threshold_amount(social_and_other_specific_services, central_government_authority, date(2020, 1, 1), date(2022, 1, 1), 750000).
art4_threshold_amount(social_and_other_specific_services, sub_central_contracting_authority, date(2020, 1, 1), date(2022, 1, 1), 750000).
art4_threshold_amount(social_and_other_specific_services, body_governed_by_public_law, date(2020, 1, 1), date(2022, 1, 1), 750000).
art4_threshold_amount(works, central_government_authority, date(2022, 1, 1), date(2024, 1, 1), 5382000).
art4_threshold_amount(works, sub_central_contracting_authority, date(2022, 1, 1), date(2024, 1, 1), 5382000).
art4_threshold_amount(works, body_governed_by_public_law, date(2022, 1, 1), date(2024, 1, 1), 5382000).
art4_threshold_amount(supplies, central_government_authority, date(2022, 1, 1), date(2024, 1, 1), 140000).
art4_threshold_amount(services, central_government_authority, date(2022, 1, 1), date(2024, 1, 1), 140000).
art4_threshold_amount(supplies, sub_central_contracting_authority, date(2022, 1, 1), date(2024, 1, 1), 215000).
art4_threshold_amount(services, sub_central_contracting_authority, date(2022, 1, 1), date(2024, 1, 1), 215000).
art4_threshold_amount(supplies, body_governed_by_public_law, date(2022, 1, 1), date(2024, 1, 1), 215000).
art4_threshold_amount(services, body_governed_by_public_law, date(2022, 1, 1), date(2024, 1, 1), 215000).
art4_threshold_amount(social_and_other_specific_services, central_government_authority, date(2022, 1, 1), date(2024, 1, 1), 750000).
art4_threshold_amount(social_and_other_specific_services, sub_central_contracting_authority, date(2022, 1, 1), date(2024, 1, 1), 750000).
art4_threshold_amount(social_and_other_specific_services, body_governed_by_public_law, date(2022, 1, 1), date(2024, 1, 1), 750000).
art4_threshold_amount(works, central_government_authority, date(2024, 1, 1), date(2026, 1, 1), 5538000).
art4_threshold_amount(works, sub_central_contracting_authority, date(2024, 1, 1), date(2026, 1, 1), 5538000).
art4_threshold_amount(works, body_governed_by_public_law, date(2024, 1, 1), date(2026, 1, 1), 5538000).
art4_threshold_amount(supplies, central_government_authority, date(2024, 1, 1), date(2026, 1, 1), 143000).
art4_threshold_amount(services, central_government_authority, date(2024, 1, 1), date(2026, 1, 1), 143000).
art4_threshold_amount(supplies, sub_central_contracting_authority, date(2024, 1, 1), date(2026, 1, 1), 221000).
art4_threshold_amount(services, sub_central_contracting_authority, date(2024, 1, 1), date(2026, 1, 1), 221000).
art4_threshold_amount(supplies, body_governed_by_public_law, date(2024, 1, 1), date(2026, 1, 1), 221000).
art4_threshold_amount(services, body_governed_by_public_law, date(2024, 1, 1), date(2026, 1, 1), 221000).
art4_threshold_amount(social_and_other_specific_services, central_government_authority, date(2024, 1, 1), date(2026, 1, 1), 750000).
art4_threshold_amount(social_and_other_specific_services, sub_central_contracting_authority, date(2024, 1, 1), date(2026, 1, 1), 750000).
art4_threshold_amount(social_and_other_specific_services, body_governed_by_public_law, date(2024, 1, 1), date(2026, 1, 1), 750000).
art4_threshold_amount(works, central_government_authority, date(2026, 1, 1), date(2028, 1, 1), 5404000).
art4_threshold_amount(works, sub_central_contracting_authority, date(2026, 1, 1), date(2028, 1, 1), 5404000).
art4_threshold_amount(works, body_governed_by_public_law, date(2026, 1, 1), date(2028, 1, 1), 5404000).
art4_threshold_amount(supplies, central_government_authority, date(2026, 1, 1), date(2028, 1, 1), 140000).
art4_threshold_amount(services, central_government_authority, date(2026, 1, 1), date(2028, 1, 1), 140000).
art4_threshold_amount(supplies, sub_central_contracting_authority, date(2026, 1, 1), date(2028, 1, 1), 216000).
art4_threshold_amount(services, sub_central_contracting_authority, date(2026, 1, 1), date(2028, 1, 1), 216000).
art4_threshold_amount(supplies, body_governed_by_public_law, date(2026, 1, 1), date(2028, 1, 1), 216000).
art4_threshold_amount(services, body_governed_by_public_law, date(2026, 1, 1), date(2028, 1, 1), 216000).
art4_threshold_amount(social_and_other_specific_services, central_government_authority, date(2026, 1, 1), date(2028, 1, 1), 750000).
art4_threshold_amount(social_and_other_specific_services, sub_central_contracting_authority, date(2026, 1, 1), date(2028, 1, 1), 750000).
art4_threshold_amount(social_and_other_specific_services, body_governed_by_public_law, date(2026, 1, 1), date(2028, 1, 1), 750000).

art4_threshold_value(Kind, Authority, PeriodStart, PeriodEnd, Cents) :-
    art4_threshold_amount(Kind, Authority, PeriodStart, PeriodEnd, Euro),
    Cents #= Euro * 100.

art4_threshold(ContractType, ContractingAuthorityType, AsOfDate, ThresholdEurCents) :-
    art4_threshold_value(ContractType, ContractingAuthorityType, PeriodStart, PeriodEnd, ThresholdEurCents),
    date_on_or_after(AsOfDate, PeriodStart),
    date_before(AsOfDate, PeriodEnd).

current_art4_threshold(ContractType, ContractingAuthorityType, ThresholdEurCents) :-
    art4_threshold(ContractType, ContractingAuthorityType, date(2026, 7, 24), ThresholdEurCents).
