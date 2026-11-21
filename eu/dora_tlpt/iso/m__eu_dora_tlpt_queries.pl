% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_tlpt_queries, [dora_tlpt_profile_keys/1, dora_tlpt_what_if/4, not_listed_for_tlpt/0, excluded_from_tlpt/1, listed_for_tlpt/1, no_tlpt_duty/1, tlpt_required/1, indeterminate/1, input_problems/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_tlpt_kernel, [dora_tlpt_input_problems/2]).
:- use_module(m__eu_dora_tlpt_dora_tlpt, [tlpt_identification_basis/3, tlpt_duty/3, dora_tlpt_status/2]).

dora_tlpt_profile_keys([financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, dora_entity_type, credit_institution_is_or_is_part_of_g_sii_or_o_sii, payment_transactions_total_value_eur_first_preceding_calendar_year, payment_transactions_total_value_eur_second_preceding_calendar_year, outstanding_electronic_money_eur_first_preceding_calendar_year, outstanding_electronic_money_eur_second_preceding_calendar_year, trading_venue_has_electronic_trading_system, trading_venue_has_highest_national_turnover_share_in_both_preceding_years, trading_venue_union_turnover_share_exceeds_5_percent_in_both_preceding_years, insurance_undertaking_activities, gross_written_premium_eur, technical_provisions_eur, total_assets_share_of_member_state_insurance_sector_basis_points, identified_by_tlpt_authority_as_required_to_perform_tlpt, tlpt_frequency_changed_by_competent_authority]).

not_listed_for_tlpt.

excluded_from_tlpt(article_16_1_entity).
excluded_from_tlpt(microenterprise).

listed_for_tlpt(point_a).
listed_for_tlpt(point_b).
listed_for_tlpt(point_c).
listed_for_tlpt(point_d).
listed_for_tlpt(point_e).
listed_for_tlpt(point_f).
listed_for_tlpt(point_g).

no_tlpt_duty(article_16_1_entity).
no_tlpt_duty(microenterprise).
no_tlpt_duty(not_identified).

tlpt_required(at_least_every_three_years).
tlpt_required(frequency_set_by_competent_authority).

indeterminate([MissingKey]) :-
    dora_tlpt_profile_keys(ProfileKeys),
    member(MissingKey, ProfileKeys).

input_problems([Problem|Problems]) :-
    maplist(problem_term, [Problem|Problems]).

problem_term(duplicate_key(_)).
problem_term(wrong_type(_)).
problem_term(unknown_key(_)).

duplicate_key(ContractKey) :-
    dora_tlpt_profile_keys(ProfileKeys),
    member(ContractKey, ProfileKeys).

dora_tlpt_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    profile_with_override(Profile, OverriddenKey, NewValue, Hypothesis),
    dora_tlpt_status(Hypothesis, NewStatus).

profile_with_override(Profile, _, _, Profile) :-
    var(Profile).
profile_with_override(Profile, OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]) :-
    Profile == [].
profile_with_override(Profile, OverriddenKey, NewValue, Hypothesis) :-
    nonvar(Profile),
    Profile = [Element|Elements],
    element_kept(Element, OverriddenKey, KeptElements),
    profile_with_override(Elements, OverriddenKey, NewValue, RemainingElements),
    append(KeptElements, RemainingElements, Hypothesis).
profile_with_override(Profile, _, _, Profile) :-
    nonvar(Profile),
    Profile \== [],
    Profile \= [_|_].

element_kept(Element, _, [Element]) :-
    var(Element).
element_kept(Element, OverriddenKey, []) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey == OverriddenKey.
element_kept(Element, OverriddenKey, [Element]) :-
    nonvar(Element),
    Element = attribute(ElementKey, _),
    ElementKey \== OverriddenKey.
element_kept(Element, _, [Element]) :-
    nonvar(Element),
    Element \= attribute(_, _).

test(the_profile_keys_are_the_seventeen_contract_keys) :-
    dora_tlpt_profile_keys(ProfileKeys),
    length(ProfileKeys, 17).
test(the_what_if_replaces_the_frequency_fact) :-
    dora_tlpt_what_if([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, true), attribute(tlpt_frequency_changed_by_competent_authority, false)], tlpt_frequency_changed_by_competent_authority, true, tlpt_required(frequency_set_by_competent_authority)).
test(the_what_if_adds_an_absent_key) :-
    dora_tlpt_what_if([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false)], identified_by_tlpt_authority_as_required_to_perform_tlpt, false, no_tlpt_duty(not_identified)).
test(the_what_if_of_a_carve_out) :-
    dora_tlpt_what_if([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, true), attribute(tlpt_frequency_changed_by_competent_authority, false)], financial_entity_is_article_16_1_entity, true, no_tlpt_duty(article_16_1_entity)).
test(the_what_if_yields_one_solution) :-
    findall(NewStatus, dora_tlpt_what_if([attribute(financial_entity_is_article_16_1_entity, false)], financial_entity_is_microenterprise, true, NewStatus), Statuses),
    Statuses == [no_tlpt_duty(microenterprise)].
test(the_what_if_on_a_non_list_keeps_the_input_problem) :-
    dora_tlpt_what_if(not_a_profile, financial_entity_is_microenterprise, true, input_problems([wrong_type(profile)])).
test(the_reexported_identification_query_answers) :-
    tlpt_identification_basis([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, central_securities_depository)], listed_for_tlpt(point_d), [cite(eu_reg_2025_1190_art_2_2), cite(eu_reg_2025_1190_art_2_2_d)]).
test(the_reexported_duty_query_answers) :-
    tlpt_duty([attribute(financial_entity_is_article_16_1_entity, true)], no_tlpt_duty(article_16_1_entity), [cite(eu_reg_2022_2554_art_26_1)]).
test(the_reexported_input_check_answers) :-
    dora_tlpt_input_problems([attribute(colour_of_logo, blue)], [unknown_key(colour_of_logo)]).
test(the_points_constructor_names_seven_points) :-
    findall(Point, listed_for_tlpt(Point), Points),
    Points == [point_a, point_b, point_c, point_d, point_e, point_f, point_g].
test(the_not_listed_constructor_holds) :-
    not_listed_for_tlpt.
test(the_duty_grounds_are_three) :-
    findall(Ground, no_tlpt_duty(Ground), Grounds),
    Grounds == [article_16_1_entity, microenterprise, not_identified].
test(the_exclusion_grounds_are_the_two_carve_outs) :-
    findall(Ground, excluded_from_tlpt(Ground), Grounds),
    Grounds == [article_16_1_entity, microenterprise].
test(the_frequencies_are_two) :-
    findall(Frequency, tlpt_required(Frequency), Frequencies),
    Frequencies == [at_least_every_three_years, frequency_set_by_competent_authority].
test(an_indeterminate_names_one_contract_key) :-
    indeterminate([dora_entity_type]).
test(an_input_problems_list_holds_problem_terms) :-
    input_problems([duplicate_key(dora_entity_type), unknown_key(colour_of_logo)]).

test(the_what_if_never_duplicates_the_key, fail) :-
    dora_tlpt_what_if([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(identified_by_tlpt_authority_as_required_to_perform_tlpt, true), attribute(tlpt_frequency_changed_by_competent_authority, false)], tlpt_frequency_changed_by_competent_authority, true, input_problems(_)).
test(an_indeterminate_never_names_two_keys, fail) :-
    indeterminate([dora_entity_type, financial_entity_is_microenterprise]).
test(an_empty_input_problems_list_is_no_status, fail) :-
    input_problems([]).
