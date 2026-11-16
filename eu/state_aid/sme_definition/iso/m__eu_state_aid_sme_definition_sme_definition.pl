% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_state_aid_sme_definition_sme_definition, [size_class/4, sme_status/4, at_least_medium/4, period_size_class/4, relationship_type/4, decide_sme_definition/2, sme_definition_status/2, sme_definition_checklist/2, sme_definition_decision_resolvable/1, sme_definition_status_values/1, micro_enterprise/0, small_enterprise/0, medium_sized_enterprise/0, large_enterprise/0, not_sme_public_control/0, not_an_enterprise/0, sme/0, not_sme/0, at_least_medium/0, below_medium/0, linked_enterprise/0, partner_enterprise/0, neither_partner_nor_linked/0, partner_enterprise_data/4, linked_enterprise_data/3, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(library(reif), [(=)/3]).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(library(clpz)).
:- use_module(library(reif), [if_/3, memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_state_aid_sme_definition_kernel, [sme_definition_input_problems/2]).
:- use_module(m__eu_state_aid_sme_definition_citations, [implements/1]).

citation_role(enterprise_definition, cite(eu_rec_2003_361_annex_art_1_t1), cite(eu_reg_651_2014_annex_i_art_1_t1)).
citation_role(sme_ceilings, cite(eu_rec_2003_361_annex_art_2_1), cite(eu_reg_651_2014_annex_i_art_2_1)).
citation_role(small_ceilings, cite(eu_rec_2003_361_annex_art_2_2), cite(eu_reg_651_2014_annex_i_art_2_2)).
citation_role(micro_ceilings, cite(eu_rec_2003_361_annex_art_2_3), cite(eu_reg_651_2014_annex_i_art_2_3)).
citation_role(autonomous_definition, cite(eu_rec_2003_361_annex_art_3_1), cite(eu_reg_651_2014_annex_i_art_3_1)).
citation_role(partner_definition, cite(eu_rec_2003_361_annex_art_3_2), cite(eu_reg_651_2014_annex_i_art_3_2)).
citation_role(investor_exception, cite(eu_rec_2003_361_annex_art_3_t3), cite(eu_reg_651_2014_annex_i_art_3_t1)).
citation_role(investor_point_a, cite(eu_rec_2003_361_annex_art_3_t4), cite(eu_reg_651_2014_annex_i_art_3_2_a)).
citation_role(investor_point_b, cite(eu_rec_2003_361_annex_art_3_t5), cite(eu_reg_651_2014_annex_i_art_3_2_b)).
citation_role(investor_point_c, cite(eu_rec_2003_361_annex_art_3_t6), cite(eu_reg_651_2014_annex_i_art_3_2_c)).
citation_role(investor_point_d, cite(eu_rec_2003_361_annex_art_3_t7), cite(eu_reg_651_2014_annex_i_art_3_2_d)).
citation_role(linked_definition, cite(eu_rec_2003_361_annex_art_3_3), cite(eu_reg_651_2014_annex_i_art_3_3)).
citation_role(linked_point_a, cite(eu_rec_2003_361_annex_art_3_t9), cite(eu_reg_651_2014_annex_i_art_3_3_a)).
citation_role(linked_point_b, cite(eu_rec_2003_361_annex_art_3_t10), cite(eu_reg_651_2014_annex_i_art_3_3_b)).
citation_role(linked_point_c, cite(eu_rec_2003_361_annex_art_3_t11), cite(eu_reg_651_2014_annex_i_art_3_3_c)).
citation_role(linked_point_d, cite(eu_rec_2003_361_annex_art_3_t12), cite(eu_reg_651_2014_annex_i_art_3_3_d)).
citation_role(presumption, cite(eu_rec_2003_361_annex_art_3_t13), cite(eu_reg_651_2014_annex_i_art_3_t2)).
citation_role(natural_persons, cite(eu_rec_2003_361_annex_art_3_t15), cite(eu_reg_651_2014_annex_i_art_3_t4)).
citation_role(adjacent_market, cite(eu_rec_2003_361_annex_art_3_t16), cite(eu_reg_651_2014_annex_i_art_3_t5)).
citation_role(public_bodies, cite(eu_rec_2003_361_annex_art_3_4), cite(eu_reg_651_2014_annex_i_art_3_4)).
citation_role(reference_period, cite(eu_rec_2003_361_annex_art_4_1), cite(eu_reg_651_2014_annex_i_art_4_1)).
citation_role(two_periods, cite(eu_rec_2003_361_annex_art_4_2), cite(eu_reg_651_2014_annex_i_art_4_2)).
citation_role(new_enterprise_estimate, cite(eu_rec_2003_361_annex_art_4_3), cite(eu_reg_651_2014_annex_i_art_4_3)).
citation_role(staff_headcount, cite(eu_rec_2003_361_annex_art_5), cite(eu_reg_651_2014_annex_i_art_5)).
citation_role(autonomous_data, cite(eu_rec_2003_361_annex_art_6_1), cite(eu_reg_651_2014_annex_i_art_6_1)).
citation_role(related_data, cite(eu_rec_2003_361_annex_art_6_2), cite(eu_reg_651_2014_annex_i_art_6_2)).
citation_role(partner_aggregation, cite(eu_rec_2003_361_annex_art_6_t3), cite(eu_reg_651_2014_annex_i_art_6_t1)).
citation_role(linked_aggregation, cite(eu_rec_2003_361_annex_art_6_t4), cite(eu_reg_651_2014_annex_i_art_6_t2)).

text_cite(recommendation_2003_361_annex, Cite, _, Cite).
text_cite(gber_annex_i, _, Cite, Cite).

role_cite(Text, Role, Cite) :-
    citation_role(Role, RecommendationCite, RegulationCite),
    text_cite(Text, RecommendationCite, RegulationCite, Cite).

roles_cites(Text, Roles, Citations) :-
    maplist(role_cite(Text), Roles, CiteList),
    sort(CiteList, Citations).

referral_role(is_enterprise, enterprise_definition).
referral_role(dominant_influence_by_contract_or_articles, linked_point_c).
referral_role(same_or_adjacent_market, natural_persons).

class_rank(micro_enterprise, 1).
class_rank(small_enterprise, 2).
class_rank(medium_sized_enterprise, 3).
class_rank(large_enterprise, 4).

class_unit(micro_enterprise, micro_ceilings).
class_unit(small_enterprise, small_ceilings).
class_unit(medium_sized_enterprise, sme_ceilings).
class_unit(large_enterprise, sme_ceilings).

top_band(4).

listed_investor(public_investment_corporation_or_venture_capital_company).
listed_investor(business_angel).
listed_investor(university_or_non_profit_research_centre).
listed_investor(institutional_investor).
listed_investor(autonomous_local_authority).

investor_point(public_investment_corporation_or_venture_capital_company, investor_point_a).
investor_point(business_angel, investor_point_a).
investor_point(university_or_non_profit_research_centre, investor_point_b).
investor_point(institutional_investor, investor_point_c).
investor_point(autonomous_local_authority, investor_point_d).

query_name(period_size_class).
query_name(size_class).
query_name(sme_status).
query_name(at_least_medium).
query_name(relationship_type).

query_keys(period_size_class, [own_staff_annual_work_units_hundredths, own_annual_turnover_cents, own_annual_balance_sheet_total_cents, partner_enterprises, linked_enterprises]).
query_keys(size_class, [is_enterprise, public_bodies_control_25_percent_or_more, accounting_basis, own_staff_annual_work_units_hundredths, own_annual_turnover_cents, own_annual_balance_sheet_total_cents, partner_enterprises, linked_enterprises, previous_period_size_class, size_class_held]).
query_keys(sme_status, [is_enterprise, public_bodies_control_25_percent_or_more, accounting_basis, own_staff_annual_work_units_hundredths, own_annual_turnover_cents, own_annual_balance_sheet_total_cents, partner_enterprises, linked_enterprises, previous_period_size_class, size_class_held]).
query_keys(at_least_medium, [is_enterprise, accounting_basis, own_staff_annual_work_units_hundredths, own_annual_turnover_cents, own_annual_balance_sheet_total_cents, partner_enterprises, linked_enterprises, previous_period_size_class, size_class_held]).
query_keys(relationship_type, [majority_of_voting_rights, right_to_appoint_or_remove_majority_of_board, dominant_influence_by_contract_or_articles, majority_of_voting_rights_by_shareholder_agreement, relationship_only_through_natural_persons, same_or_adjacent_market, holding_basis_points, investor_category, investor_involved_in_management, business_angels_total_investment_cents, local_authority_annual_budget_cents, local_authority_inhabitants]).

query_figures(period_size_class, true).
query_figures(size_class, true).
query_figures(sme_status, true).
query_figures(at_least_medium, true).
query_figures(relationship_type, false).

key_kind(is_enterprise, judgement).
key_kind(public_bodies_control_25_percent_or_more, boolean).
key_kind(accounting_basis, enumeration([approved_accounts, bona_fide_estimate])).
key_kind(own_staff_annual_work_units_hundredths, figure).
key_kind(own_annual_turnover_cents, figure).
key_kind(own_annual_balance_sheet_total_cents, figure).
key_kind(partner_enterprises, figure).
key_kind(linked_enterprises, figure).
key_kind(previous_period_size_class, enumeration([micro_enterprise, small_enterprise, medium_sized_enterprise, large_enterprise, no_previous_period])).
key_kind(size_class_held, enumeration([micro_enterprise, small_enterprise, medium_sized_enterprise, large_enterprise])).
key_kind(majority_of_voting_rights, boolean).
key_kind(right_to_appoint_or_remove_majority_of_board, boolean).
key_kind(dominant_influence_by_contract_or_articles, judgement).
key_kind(majority_of_voting_rights_by_shareholder_agreement, boolean).
key_kind(relationship_only_through_natural_persons, boolean).
key_kind(same_or_adjacent_market, judgement).
key_kind(holding_basis_points, threshold(Threshold)) :-
    implements(eu_rec_2003_361_annex_art_3_2),
    Threshold #= 2500.
key_kind(investor_category, enumeration([not_a_listed_investor, public_investment_corporation_or_venture_capital_company, business_angel, university_or_non_profit_research_centre, institutional_investor, autonomous_local_authority])).
key_kind(investor_involved_in_management, boolean).
key_kind(business_angels_total_investment_cents, threshold(Threshold)) :-
    implements(eu_rec_2003_361_annex_art_3_t4),
    Threshold #= 125000000.
key_kind(local_authority_annual_budget_cents, threshold(Threshold)) :-
    implements(eu_rec_2003_361_annex_art_3_t7),
    Threshold #= 1000000000.
key_kind(local_authority_inhabitants, threshold(Threshold)) :-
    implements(eu_rec_2003_361_annex_art_3_t7),
    Threshold #= 5000.

adds_to(own_staff_annual_work_units_hundredths, staff_sum).
adds_to(own_annual_turnover_cents, turnover_sum).
adds_to(own_annual_balance_sheet_total_cents, balance_sum).
adds_to(partner_enterprises, staff_sum).
adds_to(partner_enterprises, turnover_sum).
adds_to(partner_enterprises, balance_sum).
adds_to(linked_enterprises, staff_sum).
adds_to(linked_enterprises, turnover_sum).
adds_to(linked_enterprises, balance_sum).

owned_slots(Key, Slots) :-
    key_kind(Key, figure),
    findall(Sum, adds_to(Key, Sum), Slots).
owned_slots(Key, [Key]) :-
    key_kind(Key, Kind),
    Kind \== figure.

key_reading(Profile, Key, present(Value)) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).
key_reading(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

absent_t(absent, true).
absent_t(present(_), false).

list_open_t(absent, true).
list_open_t(present(_), false).

key_open_t(Profile, Key, Truth) :-
    key_reading(Profile, Key, Reading),
    memberd_t(Key, [partner_enterprises, linked_enterprises], IsListKey),
    reading_open_t(IsListKey, Reading, Truth).

reading_open_t(true, Reading, Truth) :-
    list_open_t(Reading, Truth).
reading_open_t(false, Reading, Truth) :-
    absent_t(Reading, Truth).

figure_amount(Argument, Argument) :-
    integer(Argument).
figure_amount(Argument, 0) :-
    atom(Argument).

reading_is_t(absent, _, false).
reading_is_t(present(Value), Wanted, true) :-
    Value == Wanted.
reading_is_t(present(Value), Wanted, false) :-
    Value \== Wanted.

truth_conjunction(true, Truth, Truth).
truth_conjunction(false, _, false).

truth_disjunction(true, _, true).
truth_disjunction(false, Truth, Truth).

truth_not(true, false).
truth_not(false, true).

staff_band(Sum, 1) :-
    implements(eu_rec_2003_361_annex_art_2_3),
    Sum #< 10000 * 1000.
staff_band(Sum, 2) :-
    implements(eu_rec_2003_361_annex_art_2_2),
    Sum #>= 10000 * 1000,
    Sum #< 10000 * 5000.
staff_band(Sum, 3) :-
    implements(eu_rec_2003_361_annex_art_2_1),
    Sum #>= 10000 * 5000,
    Sum #< 10000 * 25000.
staff_band(Sum, 4) :-
    implements(eu_rec_2003_361_annex_art_2_1),
    Sum #>= 10000 * 25000.

turnover_band(Sum, 1) :-
    implements(eu_rec_2003_361_annex_art_2_3),
    Sum #=< 10000 * 200000000.
turnover_band(Sum, 2) :-
    implements(eu_rec_2003_361_annex_art_2_2),
    Sum #> 10000 * 200000000,
    Sum #=< 10000 * 1000000000.
turnover_band(Sum, 3) :-
    implements(eu_rec_2003_361_annex_art_2_1),
    Sum #> 10000 * 1000000000,
    Sum #=< 10000 * 5000000000.
turnover_band(Sum, 4) :-
    implements(eu_rec_2003_361_annex_art_2_1),
    Sum #> 10000 * 5000000000.

balance_band(Sum, 1) :-
    implements(eu_rec_2003_361_annex_art_2_3),
    Sum #=< 10000 * 200000000.
balance_band(Sum, 2) :-
    implements(eu_rec_2003_361_annex_art_2_2),
    Sum #> 10000 * 200000000,
    Sum #=< 10000 * 1000000000.
balance_band(Sum, 3) :-
    implements(eu_rec_2003_361_annex_art_2_1),
    Sum #> 10000 * 1000000000,
    Sum #=< 10000 * 4300000000.
balance_band(Sum, 4) :-
    implements(eu_rec_2003_361_annex_art_2_1),
    Sum #> 10000 * 4300000000.

own_part(absent, 0).
own_part(present(Value), Part) :-
    implements(eu_rec_2003_361_annex_art_6_1),
    Part #= 10000 * Value.

partner_parts(absent, 0, 0, 0).
partner_parts(present(Items), Staff, Turnover, Balance) :-
    foldl(add_partner, Items, 0 - 0 - 0, Staff - Turnover - Balance).

add_partner(partner_enterprise_data(Share, Staff, Turnover, Balance), StaffIn - TurnoverIn - BalanceIn, StaffOut - TurnoverOut - BalanceOut) :-
    implements(eu_rec_2003_361_annex_art_6_t3),
    figure_amount(Share, ShareAmount),
    figure_amount(Staff, StaffAmount),
    figure_amount(Turnover, TurnoverAmount),
    figure_amount(Balance, BalanceAmount),
    StaffOut #= StaffIn + ShareAmount * StaffAmount,
    TurnoverOut #= TurnoverIn + ShareAmount * TurnoverAmount,
    BalanceOut #= BalanceIn + ShareAmount * BalanceAmount.

linked_parts(absent, 0, 0, 0).
linked_parts(present(Items), Staff, Turnover, Balance) :-
    foldl(add_linked, Items, 0 - 0 - 0, Staff - Turnover - Balance).

add_linked(linked_enterprise_data(Staff, Turnover, Balance), StaffIn - TurnoverIn - BalanceIn, StaffOut - TurnoverOut - BalanceOut) :-
    implements(eu_rec_2003_361_annex_art_6_t4),
    figure_amount(Staff, StaffAmount),
    figure_amount(Turnover, TurnoverAmount),
    figure_amount(Balance, BalanceAmount),
    StaffOut #= StaffIn + 10000 * StaffAmount,
    TurnoverOut #= TurnoverIn + 10000 * TurnoverAmount,
    BalanceOut #= BalanceIn + 10000 * BalanceAmount.

band_domain(true, LowBand, Domain) :-
    top_band(Top),
    numlist(LowBand, Top, Domain).
band_domain(false, LowBand, [LowBand]).

query_space(Query, Profile, Space) :-
    query_keys(Query, Keys),
    plain_slots(Keys, Profile, PlainSlots),
    query_figures(Query, ReadsFigures),
    figure_slots(ReadsFigures, Profile, FigureSlots),
    append(PlainSlots, FigureSlots, Space).

plain_slots([], _, []).
plain_slots([Key|Keys], Profile, Slots) :-
    key_slots(Profile, Key, KeySlots),
    plain_slots(Keys, Profile, LaterSlots),
    append(KeySlots, LaterSlots, Slots).

key_slots(_, Key, []) :-
    key_kind(Key, figure).
key_slots(Profile, Key, [Key - Domain]) :-
    key_kind(Key, Kind),
    key_reading(Profile, Key, Reading),
    kind_domain(Kind, Reading, Domain).

kind_domain(judgement, Reading, Domain) :-
    judgement_domain(Reading, Domain).
kind_domain(boolean, absent, [true, false]).
kind_domain(boolean, present(Value), [Value]).
kind_domain(enumeration(Values), absent, Values).
kind_domain(enumeration(_), present(Value), [Value]).
kind_domain(threshold(Threshold), Reading, Domain) :-
    threshold_domain(Reading, Threshold, Domain).

judgement_domain(absent, [true, false]).
judgement_domain(present(unsure), [true, false]).
judgement_domain(present(true), [true]).
judgement_domain(present(false), [false]).

threshold_domain(absent, _, [below, at_or_above]).
threshold_domain(present(Value), Threshold, [below]) :-
    Value #< Threshold.
threshold_domain(present(Value), Threshold, [at_or_above]) :-
    Value #>= Threshold.

figure_slots(false, _, []).
figure_slots(true, Profile, [staff_sum - StaffDomain, turnover_sum - TurnoverDomain, balance_sum - BalanceDomain]) :-
    key_reading(Profile, own_staff_annual_work_units_hundredths, OwnStaffReading),
    key_reading(Profile, own_annual_turnover_cents, OwnTurnoverReading),
    key_reading(Profile, own_annual_balance_sheet_total_cents, OwnBalanceReading),
    key_reading(Profile, partner_enterprises, PartnerReading),
    key_reading(Profile, linked_enterprises, LinkedReading),
    own_part(OwnStaffReading, OwnStaffPart),
    own_part(OwnTurnoverReading, OwnTurnoverPart),
    own_part(OwnBalanceReading, OwnBalancePart),
    partner_parts(PartnerReading, PartnerStaff, PartnerTurnover, PartnerBalance),
    linked_parts(LinkedReading, LinkedStaff, LinkedTurnover, LinkedBalance),
    StaffLow #= OwnStaffPart + PartnerStaff + LinkedStaff,
    TurnoverLow #= OwnTurnoverPart + PartnerTurnover + LinkedTurnover,
    BalanceLow #= OwnBalancePart + PartnerBalance + LinkedBalance,
    staff_band(StaffLow, StaffLowBand),
    turnover_band(TurnoverLow, TurnoverLowBand),
    balance_band(BalanceLow, BalanceLowBand),
    absent_t(OwnStaffReading, OwnStaffAbsent),
    absent_t(OwnTurnoverReading, OwnTurnoverAbsent),
    absent_t(OwnBalanceReading, OwnBalanceAbsent),
    list_open_t(PartnerReading, PartnerOpen),
    list_open_t(LinkedReading, LinkedOpen),
    truth_disjunction(PartnerOpen, LinkedOpen, ListOpen),
    truth_disjunction(OwnStaffAbsent, ListOpen, StaffFree),
    truth_disjunction(OwnTurnoverAbsent, ListOpen, TurnoverFree),
    truth_disjunction(OwnBalanceAbsent, ListOpen, BalanceFree),
    band_domain(StaffFree, StaffLowBand, StaffDomain),
    band_domain(TurnoverFree, TurnoverLowBand, TurnoverDomain),
    band_domain(BalanceFree, BalanceLowBand, BalanceDomain).

slot_lookup(_, [], not_found).
slot_lookup(SlotName, [Entry - Value|_], found(Value)) :-
    Entry == SlotName.
slot_lookup(SlotName, [Entry - _|Entries], Found) :-
    Entry \== SlotName,
    slot_lookup(SlotName, Entries, Found).

slot_value(SlotName, Space, ChosenIn, ChosenOut, Value) :-
    slot_lookup(SlotName, ChosenIn, Found),
    found_value(Found, SlotName, Space, ChosenIn, ChosenOut, Value).

found_value(found(Value), _, _, Chosen, Chosen, Value).
found_value(not_found, SlotName, Space, ChosenIn, ChosenOut, Value) :-
    slot_lookup(SlotName, Space, found(Domain)),
    domain_choice(Domain, SlotName, ChosenIn, ChosenOut, Value).

domain_choice([Value], _, Chosen, Chosen, Value).
domain_choice([First, Second|Others], SlotName, ChosenIn, [SlotName - Value|ChosenIn], Value) :-
    member(Value, [First, Second|Others]).

answer(period_size_class, Space, ChosenIn, ChosenOut, Class) :-
    period_class(Space, ChosenIn, ChosenOut, Class).
answer(size_class, Space, ChosenIn, ChosenOut, Result) :-
    size_answer(Space, ChosenIn, ChosenOut, Result).
answer(sme_status, Space, ChosenIn, ChosenOut, Result) :-
    size_answer(Space, ChosenIn, ChosenOut, SizeResult),
    sme_of(SizeResult, Result).
answer(at_least_medium, Space, ChosenIn, ChosenOut, Result) :-
    slot_value(is_enterprise, Space, ChosenIn, Chosen1, IsEnterprise),
    medium_route(IsEnterprise, Space, Chosen1, ChosenOut, Result).
answer(relationship_type, Space, ChosenIn, ChosenOut, Result) :-
    related(Space, ChosenIn, Chosen1, Related),
    related_route(Related, Space, Chosen1, ChosenOut, Result).

period_class(Space, ChosenIn, ChosenOut, Class) :-
    implements(eu_rec_2003_361_annex_art_2_1),
    slot_value(staff_sum, Space, ChosenIn, Chosen1, StaffBand),
    staff_route(StaffBand, Space, Chosen1, ChosenOut, Rank),
    class_rank(Class, Rank).

staff_route(StaffBand, _, Chosen, Chosen, Rank) :-
    top_band(Rank),
    StaffBand #= Rank.
staff_route(StaffBand, Space, ChosenIn, ChosenOut, Rank) :-
    top_band(Top),
    StaffBand #< Top,
    slot_value(turnover_sum, Space, ChosenIn, Chosen1, TurnoverBand),
    turnover_route(StaffBand, TurnoverBand, Space, Chosen1, ChosenOut, Rank).

turnover_route(StaffBand, TurnoverBand, _, Chosen, Chosen, StaffBand) :-
    TurnoverBand #=< StaffBand.
turnover_route(StaffBand, TurnoverBand, Space, ChosenIn, ChosenOut, Rank) :-
    TurnoverBand #> StaffBand,
    slot_value(balance_sum, Space, ChosenIn, ChosenOut, BalanceBand),
    FinancialBand #= min(TurnoverBand, BalanceBand),
    Rank #= max(StaffBand, FinancialBand).

status_class(Space, ChosenIn, ChosenOut, Class) :-
    period_class(Space, ChosenIn, Chosen1, Latest),
    slot_value(accounting_basis, Space, Chosen1, Chosen2, Basis),
    basis_route(Basis, Latest, Space, Chosen2, ChosenOut, Class).

basis_route(bona_fide_estimate, Latest, _, Chosen, Chosen, Latest) :-
    implements(eu_rec_2003_361_annex_art_4_3).
basis_route(approved_accounts, Latest, Space, ChosenIn, ChosenOut, Class) :-
    implements(eu_rec_2003_361_annex_art_4_1),
    slot_value(previous_period_size_class, Space, ChosenIn, Chosen1, Previous),
    previous_route(Previous, Latest, Space, Chosen1, ChosenOut, Class).

previous_route(no_previous_period, Latest, _, Chosen, Chosen, Latest).
previous_route(Previous, Latest, _, Chosen, Chosen, Latest) :-
    class_rank(Previous, PreviousRank),
    class_rank(Latest, LatestRank),
    PreviousRank #= LatestRank.
previous_route(Previous, Latest, Space, ChosenIn, ChosenOut, Class) :-
    implements(eu_rec_2003_361_annex_art_4_2),
    class_rank(Previous, PreviousRank),
    class_rank(Latest, LatestRank),
    PreviousRank #\= LatestRank,
    slot_value(size_class_held, Space, ChosenIn, ChosenOut, Held),
    class_rank(Held, HeldRank),
    two_period_rank(LatestRank, PreviousRank, HeldRank, ClassRank),
    class_rank(Class, ClassRank).

two_period_rank(LatestRank, _, HeldRank, HeldRank) :-
    implements(eu_rec_2003_361_annex_art_4_2),
    LatestRank #= HeldRank.
two_period_rank(LatestRank, PreviousRank, HeldRank, ClassRank) :-
    implements(eu_rec_2003_361_annex_art_4_2),
    LatestRank #> HeldRank,
    PreviousRank #> HeldRank,
    ClassRank #= min(LatestRank, PreviousRank).
two_period_rank(LatestRank, PreviousRank, HeldRank, ClassRank) :-
    implements(eu_rec_2003_361_annex_art_4_2),
    LatestRank #< HeldRank,
    PreviousRank #< HeldRank,
    ClassRank #= max(LatestRank, PreviousRank).
two_period_rank(LatestRank, PreviousRank, HeldRank, HeldRank) :-
    implements(eu_rec_2003_361_annex_art_4_2),
    LatestRank #> HeldRank,
    PreviousRank #=< HeldRank.
two_period_rank(LatestRank, PreviousRank, HeldRank, HeldRank) :-
    implements(eu_rec_2003_361_annex_art_4_2),
    LatestRank #< HeldRank,
    PreviousRank #>= HeldRank.

size_answer(Space, ChosenIn, ChosenOut, Result) :-
    slot_value(is_enterprise, Space, ChosenIn, Chosen1, IsEnterprise),
    enterprise_route(IsEnterprise, Space, Chosen1, ChosenOut, Result).

enterprise_route(false, _, Chosen, Chosen, not_an_enterprise) :-
    implements(eu_rec_2003_361_annex_art_1_t1).
enterprise_route(true, Space, ChosenIn, ChosenOut, Result) :-
    implements(eu_rec_2003_361_annex_art_3_4),
    slot_value(public_bodies_control_25_percent_or_more, Space, ChosenIn, Chosen1, PublicControl),
    public_route(PublicControl, Space, Chosen1, ChosenOut, Result).

public_route(true, _, Chosen, Chosen, not_sme_public_control).
public_route(false, Space, ChosenIn, ChosenOut, Class) :-
    status_class(Space, ChosenIn, ChosenOut, Class).

sme_of(not_an_enterprise, not_an_enterprise).
sme_of(not_sme_public_control, not_sme) :-
    implements(eu_rec_2003_361_annex_art_3_4).
sme_of(large_enterprise, not_sme) :-
    implements(eu_rec_2003_361_annex_art_2_1).
sme_of(micro_enterprise, sme) :-
    implements(eu_rec_2003_361_annex_art_2_1).
sme_of(small_enterprise, sme) :-
    implements(eu_rec_2003_361_annex_art_2_1).
sme_of(medium_sized_enterprise, sme) :-
    implements(eu_rec_2003_361_annex_art_2_1).

medium_route(false, _, Chosen, Chosen, not_an_enterprise) :-
    implements(eu_rec_2003_361_annex_art_1_t1).
medium_route(true, Space, ChosenIn, ChosenOut, Result) :-
    status_class(Space, ChosenIn, ChosenOut, Class),
    class_rank(Class, Rank),
    medium_result(Rank, Result).

medium_result(Rank, at_least_medium) :-
    implements(eu_rec_2003_361_annex_art_2_1),
    class_rank(medium_sized_enterprise, MediumRank),
    Rank #>= MediumRank.
medium_result(Rank, below_medium) :-
    implements(eu_rec_2003_361_annex_art_2_2),
    class_rank(medium_sized_enterprise, MediumRank),
    Rank #< MediumRank.

related(Space, ChosenIn, ChosenOut, Related) :-
    implements(eu_rec_2003_361_annex_art_3_t9),
    implements(eu_rec_2003_361_annex_art_3_t14),
    implements(eu_reg_651_2014_annex_i_art_3_t3),
    slot_value(majority_of_voting_rights, Space, ChosenIn, Chosen1, Majority),
    majority_route(Majority, Space, Chosen1, ChosenOut, Related).

majority_route(true, _, Chosen, Chosen, true).
majority_route(false, Space, ChosenIn, ChosenOut, Related) :-
    implements(eu_rec_2003_361_annex_art_3_t10),
    slot_value(right_to_appoint_or_remove_majority_of_board, Space, ChosenIn, Chosen1, Board),
    board_route(Board, Space, Chosen1, ChosenOut, Related).

board_route(true, _, Chosen, Chosen, true).
board_route(false, Space, ChosenIn, ChosenOut, Related) :-
    implements(eu_rec_2003_361_annex_art_3_t12),
    slot_value(majority_of_voting_rights_by_shareholder_agreement, Space, ChosenIn, Chosen1, Agreement),
    agreement_route(Agreement, Space, Chosen1, ChosenOut, Related).

agreement_route(true, _, Chosen, Chosen, true).
agreement_route(false, Space, ChosenIn, ChosenOut, Related) :-
    implements(eu_rec_2003_361_annex_art_3_t11),
    slot_value(dominant_influence_by_contract_or_articles, Space, ChosenIn, Chosen1, Dominant),
    dominant_route(Dominant, Space, Chosen1, ChosenOut, Related).

dominant_route(false, _, Chosen, Chosen, false).
dominant_route(true, Space, ChosenIn, ChosenOut, Related) :-
    implements(eu_rec_2003_361_annex_art_3_t13),
    slot_value(investor_category, Space, ChosenIn, Chosen1, Category),
    presumption_route(Category, Space, Chosen1, ChosenOut, Related).

presumption_route(not_a_listed_investor, _, Chosen, Chosen, true).
presumption_route(Category, Space, ChosenIn, ChosenOut, Involved) :-
    implements(eu_rec_2003_361_annex_art_3_t13),
    listed_investor(Category),
    slot_value(investor_involved_in_management, Space, ChosenIn, ChosenOut, Involved).

related_route(true, Space, ChosenIn, ChosenOut, Result) :-
    implements(eu_rec_2003_361_annex_art_3_3),
    slot_value(relationship_only_through_natural_persons, Space, ChosenIn, Chosen1, OnlyNatural),
    natural_route(OnlyNatural, Space, Chosen1, ChosenOut, Result).
related_route(false, Space, ChosenIn, ChosenOut, Result) :-
    unlinked_route(Space, ChosenIn, ChosenOut, Result).

natural_route(false, _, Chosen, Chosen, linked_enterprise).
natural_route(true, Space, ChosenIn, ChosenOut, Result) :-
    implements(eu_rec_2003_361_annex_art_3_t15),
    slot_value(same_or_adjacent_market, Space, ChosenIn, Chosen1, Market),
    market_route(Market, Space, Chosen1, ChosenOut, Result).

market_route(true, _, Chosen, Chosen, linked_enterprise) :-
    implements(eu_rec_2003_361_annex_art_3_t16).
market_route(false, Space, ChosenIn, ChosenOut, Result) :-
    unlinked_route(Space, ChosenIn, ChosenOut, Result).

unlinked_route(Space, ChosenIn, ChosenOut, Result) :-
    implements(eu_rec_2003_361_annex_art_3_2),
    slot_value(holding_basis_points, Space, ChosenIn, Chosen1, Holding),
    holding_route(Holding, Space, Chosen1, ChosenOut, Result).

holding_route(below, _, Chosen, Chosen, neither_partner_nor_linked) :-
    implements(eu_rec_2003_361_annex_art_3_1).
holding_route(at_or_above, Space, ChosenIn, ChosenOut, Result) :-
    implements(eu_rec_2003_361_annex_art_3_t3),
    slot_value(investor_category, Space, ChosenIn, Chosen1, Category),
    investor_route(Category, Space, Chosen1, ChosenOut, Result).

investor_route(not_a_listed_investor, _, Chosen, Chosen, partner_enterprise) :-
    implements(eu_rec_2003_361_annex_art_3_2).
investor_route(public_investment_corporation_or_venture_capital_company, _, Chosen, Chosen, neither_partner_nor_linked) :-
    implements(eu_rec_2003_361_annex_art_3_t4).
investor_route(university_or_non_profit_research_centre, _, Chosen, Chosen, neither_partner_nor_linked) :-
    implements(eu_rec_2003_361_annex_art_3_t5).
investor_route(institutional_investor, _, Chosen, Chosen, neither_partner_nor_linked) :-
    implements(eu_rec_2003_361_annex_art_3_t6).
investor_route(business_angel, Space, ChosenIn, ChosenOut, Result) :-
    implements(eu_rec_2003_361_annex_art_3_t4),
    slot_value(business_angels_total_investment_cents, Space, ChosenIn, ChosenOut, Investment),
    limit_result(Investment, Result).
investor_route(autonomous_local_authority, Space, ChosenIn, ChosenOut, Result) :-
    implements(eu_rec_2003_361_annex_art_3_t7),
    slot_value(local_authority_annual_budget_cents, Space, ChosenIn, Chosen1, Budget),
    budget_route(Budget, Space, Chosen1, ChosenOut, Result).

budget_route(at_or_above, _, Chosen, Chosen, partner_enterprise).
budget_route(below, Space, ChosenIn, ChosenOut, Result) :-
    implements(eu_rec_2003_361_annex_art_3_t7),
    slot_value(local_authority_inhabitants, Space, ChosenIn, ChosenOut, Inhabitants),
    limit_result(Inhabitants, Result).

limit_result(below, neither_partner_nor_linked).
limit_result(at_or_above, partner_enterprise).

query_paths(Query, Space, Paths) :-
    findall(Chosen - Result, answer(Query, Space, [], Chosen, Result), Paths).

path_results(Paths, Distinct) :-
    pairs_values(Paths, Results),
    sort(Results, Distinct).

can_change_t(Query, Space, Paths, OwnedSlots, Truth) :-
    seeds_change_t(Paths, Query, Space, OwnedSlots, Truth).

seeds_change_t([], _, _, _, false).
seeds_change_t([Chosen - Result|Paths], Query, Space, OwnedSlots, Truth) :-
    if_(seed_changes_t(Query, Space, OwnedSlots, Chosen, Result), Truth = true, seeds_change_t(Paths, Query, Space, OwnedSlots, Truth)).

seed_changes_t(Query, Space, OwnedSlots, Chosen, Result, Truth) :-
    drop_slots(Chosen, OwnedSlots, Forced),
    findall(Other, answer(Query, Space, Forced, _, Other), Others),
    sort(Others, Distinct),
    differs_t(Distinct, Result, Truth).

differs_t([], _, false).
differs_t([Only], Result, false) :-
    Only == Result.
differs_t([Only], Result, true) :-
    Only \== Result.
differs_t([_, _|_], _, true).

drop_slots([], _, []).
drop_slots([SlotName - Value|Entries], Dropped, Kept) :-
    memberd_t(SlotName, Dropped, IsDropped),
    keep_entry(IsDropped, SlotName - Value, LaterKept, Kept),
    drop_slots(Entries, Dropped, LaterKept).

keep_entry(true, _, Kept, Kept).
keep_entry(false, Entry, Kept, [Entry|Kept]).

keys_holding(_, [], []).
keys_holding(Test, [Key|Keys], Kept) :-
    call(Test, Key, Truth),
    keep_key(Truth, Key, LaterKept, Kept),
    keys_holding(Test, Keys, LaterKept).

keep_key(true, Key, Kept, [Key|Kept]).
keep_key(false, _, Kept, Kept).

candidate_t(Query, Profile, Space, Paths, Key, Truth) :-
    key_open_t(Profile, Key, Open),
    candidate_from(Open, Query, Space, Paths, Key, Truth).

candidate_from(false, _, _, _, _, false).
candidate_from(true, Query, Space, Paths, Key, Truth) :-
    owned_slots(Key, OwnedSlots),
    can_change_t(Query, Space, Paths, OwnedSlots, Truth).

unsure_changer_t(Query, Profile, Space, Paths, Key, Truth) :-
    key_kind(Key, Kind),
    key_reading(Profile, Key, Reading),
    unsure_judgement_t(Kind, Reading, Unsure),
    unsure_changes(Unsure, Query, Space, Paths, Key, Truth).

unsure_judgement_t(judgement, present(Value), true) :-
    Value == unsure.
unsure_judgement_t(judgement, present(Value), false) :-
    Value \== unsure.
unsure_judgement_t(judgement, absent, false).
unsure_judgement_t(Kind, _, false) :-
    Kind \== judgement.

unsure_changes(false, _, _, _, _, false).
unsure_changes(true, Query, Space, Paths, Key, Truth) :-
    can_change_t(Query, Space, Paths, [Key], Truth).

choose_ungated([], [First|_], _, First).
choose_ungated([Key|Keys], Candidates, Context, Named) :-
    if_(gated_t(Key, Candidates, Context), choose_ungated(Keys, Candidates, Context, Named), Named = Key).

gated_t(Key, Candidates, Context, Truth) :-
    gated_over(Candidates, Key, Context, Truth).

gated_over([], _, _, false).
gated_over([Other|Others], Key, Context, Truth) :-
    if_(Other = Key, gated_over(Others, Key, Context, Truth), if_(gates_t(Key, Other, Context), Truth = true, gated_over(Others, Key, Context, Truth))).

gates_t(Key, Other, Context, Truth) :-
    behind_t(Key, Other, Context, KeyBehind),
    gates_from(KeyBehind, Key, Other, Context, Truth).

gates_from(false, _, _, _, false).
gates_from(true, Key, Other, Context, Truth) :-
    behind_t(Other, Key, Context, OtherBehind),
    truth_not(OtherBehind, Truth).

behind_t(Key, Other, Context, Truth) :-
    Context = context(Query, _, Space),
    gating_restrictions(Other, Context, Restrictions),
    owned_slots(Key, OwnedSlots),
    behind_over(Restrictions, OwnedSlots, Query, Space, Truth).

behind_over([], _, _, _, false).
behind_over([Restriction|Restrictions], OwnedSlots, Query, Space, Truth) :-
    if_(fixed_under_t(Restriction, OwnedSlots, Query, Space), Truth = true, behind_over(Restrictions, OwnedSlots, Query, Space, Truth)).

fixed_under_t(Restriction, OwnedSlots, Query, Space, Truth) :-
    restrict_space(Space, Restriction, Restricted),
    query_paths(Query, Restricted, Paths),
    can_change_t(Query, Restricted, Paths, OwnedSlots, Changes),
    truth_not(Changes, Truth).

gating_restrictions(Other, context(_, _, Space), Restrictions) :-
    key_kind(Other, Kind),
    Kind \== figure,
    slot_lookup(Other, Space, found(Domain)),
    findall([Other - [Value]], member(Value, Domain), Restrictions).
gating_restrictions(Other, context(Query, Profile, Space), Restrictions) :-
    key_kind(Other, figure),
    owned_slots(Other, Sums),
    query_keys(Query, Keys),
    sum_options(Sums, Other, Keys, Profile, Space, OptionLists),
    options_product(OptionLists, Restrictions).

sum_options([], _, _, _, _, []).
sum_options([Sum|Sums], Other, Keys, Profile, Space, [Options|LaterOptions]) :-
    sharers_t(Keys, Other, Sum, Profile, Shared),
    slot_lookup(Sum, Space, found(Domain)),
    shared_options(Shared, Sum, Domain, Options),
    sum_options(Sums, Other, Keys, Profile, Space, LaterOptions).

shared_options(true, Sum, _, [Sum - [Top]]) :-
    top_band(Top).
shared_options(false, Sum, Domain, Options) :-
    findall(Sum - [Band], member(Band, Domain), Options).

options_product([], [[]]).
options_product([Options|LaterOptions], Product) :-
    options_product(LaterOptions, LaterProduct),
    findall([Option|Later], (member(Option, Options), member(Later, LaterProduct)), Product).

sharers_t([], _, _, _, false).
sharers_t([Key|Keys], Other, Sum, Profile, Truth) :-
    sharer_t(Key, Other, Sum, Profile, KeyShares),
    sharers_rest(KeyShares, Keys, Other, Sum, Profile, Truth).

sharers_rest(true, _, _, _, _, true).
sharers_rest(false, Keys, Other, Sum, Profile, Truth) :-
    sharers_t(Keys, Other, Sum, Profile, Truth).

sharer_t(Key, Other, _, _, false) :-
    Key == Other.
sharer_t(Key, Other, Sum, Profile, Truth) :-
    Key \== Other,
    findall(Added, adds_to(Key, Added), AddedSums),
    memberd_t(Sum, AddedSums, Adds),
    key_open_t(Profile, Key, Open),
    truth_conjunction(Adds, Open, Truth).

restrict_space(Space, Restriction, Restricted) :-
    maplist(restrict_slot(Restriction), Space, Restricted).

restrict_slot(Restriction, SlotName - Domain, SlotName - NewDomain) :-
    slot_lookup(SlotName, Restriction, Found),
    restricted_domain(Found, Domain, NewDomain).

restricted_domain(not_found, Domain, Domain).
restricted_domain(found(NewDomain), _, NewDomain).

list_state(absent, absent).
list_state(present([]), empty).
list_state(present([_|_]), filled).

article_six_roles(empty, empty, [autonomous_data]).
article_six_roles(absent, absent, []).
article_six_roles(absent, empty, []).
article_six_roles(empty, absent, []).
article_six_roles(filled, absent, [related_data, partner_aggregation]).
article_six_roles(filled, empty, [related_data, partner_aggregation]).
article_six_roles(absent, filled, [related_data, linked_aggregation]).
article_six_roles(empty, filled, [related_data, linked_aggregation]).
article_six_roles(filled, filled, [related_data, partner_aggregation, linked_aggregation]).

figure_roles(Profile, [staff_headcount|ArticleSixRoles]) :-
    implements(eu_rec_2003_361_annex_art_6_2),
    key_reading(Profile, partner_enterprises, PartnerReading),
    key_reading(Profile, linked_enterprises, LinkedReading),
    list_state(PartnerReading, PartnerState),
    list_state(LinkedReading, LinkedState),
    article_six_roles(PartnerState, LinkedState, ArticleSixRoles).

period_roles(Profile, Roles) :-
    figure_roles(Profile, FigureRoles),
    key_reading(Profile, accounting_basis, BasisReading),
    key_reading(Profile, previous_period_size_class, PreviousReading),
    accounting_roles(BasisReading, PreviousReading, AccountingRoles),
    append(FigureRoles, AccountingRoles, Roles).

accounting_roles(absent, _, []).
accounting_roles(present(bona_fide_estimate), _, [new_enterprise_estimate]).
accounting_roles(present(approved_accounts), absent, [reference_period]).
accounting_roles(present(approved_accounts), present(no_previous_period), [reference_period]).
accounting_roles(present(approved_accounts), present(Previous), [reference_period, two_periods]) :-
    class_rank(Previous, _).

settled_roles(period_size_class, Profile, Class, [Unit|FigureRoles]) :-
    class_unit(Class, Unit),
    figure_roles(Profile, FigureRoles).
settled_roles(size_class, _, not_an_enterprise, [enterprise_definition]).
settled_roles(size_class, _, not_sme_public_control, [public_bodies]).
settled_roles(size_class, Profile, Class, [Unit|PeriodRoles]) :-
    class_unit(Class, Unit),
    period_roles(Profile, PeriodRoles).
settled_roles(sme_status, _, not_an_enterprise, [enterprise_definition]).
settled_roles(sme_status, Profile, not_sme, Roles) :-
    key_reading(Profile, public_bodies_control_25_percent_or_more, PublicReading),
    reading_is_t(PublicReading, true, PublicControl),
    not_sme_roles(PublicControl, Profile, Roles).
settled_roles(sme_status, Profile, sme, [sme_ceilings|PeriodRoles]) :-
    period_roles(Profile, PeriodRoles).
settled_roles(at_least_medium, _, not_an_enterprise, [enterprise_definition]).
settled_roles(at_least_medium, Profile, at_least_medium, [sme_ceilings|PeriodRoles]) :-
    period_roles(Profile, PeriodRoles).
settled_roles(at_least_medium, Profile, below_medium, [small_ceilings|PeriodRoles]) :-
    period_roles(Profile, PeriodRoles).
settled_roles(relationship_type, Profile, Result, Roles) :-
    result_roles(Result, Profile, ResultRoles),
    shared_relationship_roles(Profile, SharedRoles),
    append(ResultRoles, SharedRoles, Roles).

not_sme_roles(true, _, [public_bodies]).
not_sme_roles(false, Profile, [sme_ceilings|PeriodRoles]) :-
    period_roles(Profile, PeriodRoles).

result_roles(linked_enterprise, Profile, [linked_definition|PointRoles]) :-
    linked_point_roles(Profile, PointRoles).
result_roles(partner_enterprise, _, [partner_definition]).
result_roles(neither_partner_nor_linked, Profile, [autonomous_definition|ExceptionRoles]) :-
    exception_roles(Profile, ExceptionRoles).

conditional_roles(true, Roles, Roles).
conditional_roles(false, _, []).

linked_point_roles(Profile, Roles) :-
    key_reading(Profile, majority_of_voting_rights, MajorityReading),
    key_reading(Profile, right_to_appoint_or_remove_majority_of_board, BoardReading),
    key_reading(Profile, dominant_influence_by_contract_or_articles, DominantReading),
    key_reading(Profile, majority_of_voting_rights_by_shareholder_agreement, AgreementReading),
    key_reading(Profile, investor_category, CategoryReading),
    key_reading(Profile, investor_involved_in_management, InvolvedReading),
    reading_is_t(MajorityReading, true, PointA),
    reading_is_t(BoardReading, true, PointB),
    reading_is_t(DominantReading, true, Dominant),
    reading_is_t(CategoryReading, not_a_listed_investor, Unlisted),
    reading_is_t(InvolvedReading, true, Involved),
    truth_disjunction(Unlisted, Involved, PointCCounts),
    truth_conjunction(Dominant, PointCCounts, PointC),
    reading_is_t(AgreementReading, true, PointD),
    conditional_roles(PointA, [linked_point_a], RolesA),
    conditional_roles(PointB, [linked_point_b], RolesB),
    conditional_roles(PointC, [linked_point_c], RolesC),
    conditional_roles(PointD, [linked_point_d], RolesD),
    append([RolesA, RolesB, RolesC, RolesD], Roles).

category_listed_t(absent, false).
category_listed_t(present(not_a_listed_investor), false).
category_listed_t(present(Category), true) :-
    listed_investor(Category).

holding_reached_t(absent, false).
holding_reached_t(present(Holding), true) :-
    implements(eu_rec_2003_361_annex_art_3_2),
    Holding #>= 2500.
holding_reached_t(present(Holding), false) :-
    implements(eu_rec_2003_361_annex_art_3_2),
    Holding #< 2500.

exception_roles(Profile, Roles) :-
    key_reading(Profile, holding_basis_points, HoldingReading),
    key_reading(Profile, investor_category, CategoryReading),
    holding_reached_t(HoldingReading, Reached),
    category_listed_t(CategoryReading, Listed),
    truth_conjunction(Reached, Listed, Excepted),
    excepted_roles(Excepted, CategoryReading, Roles).

excepted_roles(false, _, []).
excepted_roles(true, present(Category), [investor_exception, Point]) :-
    investor_point(Category, Point).

shared_relationship_roles(Profile, Roles) :-
    key_reading(Profile, dominant_influence_by_contract_or_articles, DominantReading),
    key_reading(Profile, investor_category, CategoryReading),
    key_reading(Profile, investor_involved_in_management, InvolvedReading),
    key_reading(Profile, relationship_only_through_natural_persons, NaturalReading),
    reading_is_t(DominantReading, true, Dominant),
    category_listed_t(CategoryReading, Listed),
    reading_is_t(InvolvedReading, false, NotInvolved),
    truth_conjunction(Listed, NotInvolved, Presumed),
    truth_conjunction(Dominant, Presumed, PresumptionApplies),
    reading_is_t(NaturalReading, true, ThroughNaturalPersons),
    conditional_roles(PresumptionApplies, [presumption], PresumptionRoles),
    conditional_roles(ThroughNaturalPersons, [natural_persons, adjacent_market], NaturalRoles),
    append(PresumptionRoles, NaturalRoles, Roles).

judgement_pairs([], _, []).
judgement_pairs([Key|Keys], Profile, Pairs) :-
    key_kind(Key, Kind),
    key_reading(Profile, Key, Reading),
    pair_of(Kind, Key, Reading, Pair),
    judgement_pairs(Keys, Profile, LaterPairs),
    append(Pair, LaterPairs, Pairs).

pair_of(judgement, Key, present(Value), [Key - Value]).
pair_of(judgement, _, absent, []).
pair_of(Kind, _, _, []) :-
    Kind \== judgement.

known_text_t(Text, false) :-
    var(Text).
known_text_t(Text, Truth) :-
    nonvar(Text),
    memberd_t(Text, [recommendation_2003_361_annex, gber_annex_i], Truth).

text_problems(true, []).
text_problems(false, [wrong_type(text)]).

query_result(Query, Text, Profile, Result, Citations) :-
    known_text_t(Text, TextKnown),
    text_problems(TextKnown, TextProblems),
    sme_definition_input_problems(Profile, ProfileProblems),
    append(TextProblems, ProfileProblems, Problems),
    problems_route(Problems, Query, Text, Profile, Result, Citations).

problems_route([Problem|Problems], _, _, _, input_problems([Problem|Problems]), []).
problems_route([], Query, Text, Profile, Result, Citations) :-
    judged_result(Query, Text, Profile, Result, Citations).

judged_result(Query, Text, Profile, Result, Citations) :-
    query_space(Query, Profile, Space),
    query_paths(Query, Space, Paths),
    path_results(Paths, Distinct),
    distinct_route(Distinct, Query, Text, Profile, Space, Paths, Result, Citations).

distinct_route([Settled], Query, Text, Profile, _, _, Settled, Citations) :-
    settled_roles(Query, Profile, Settled, Roles),
    roles_cites(Text, Roles, Citations).
distinct_route([_, _|_], Query, Text, Profile, Space, Paths, Result, []) :-
    query_keys(Query, Keys),
    keys_holding(candidate_t(Query, Profile, Space, Paths), Keys, Candidates),
    candidates_route(Candidates, Query, Text, Profile, Space, Paths, Keys, Result).

candidates_route([First|Others], Query, _, Profile, Space, _, _, indeterminate([Named])) :-
    choose_ungated([First|Others], [First|Others], context(Query, Profile, Space), Named).
candidates_route([], Query, Text, Profile, Space, Paths, Keys, needs_legal_review(open_textured(Judgement, Citation), [inputs_relied_on(Pairs)])) :-
    keys_holding(unsure_changer_t(Query, Profile, Space, Paths), Keys, [Judgement|_]),
    referral_role(Judgement, Role),
    role_cite(Text, Role, Citation),
    judgement_pairs(Keys, Profile, Pairs).

period_size_class(Text, Profile, Result, Citations) :-
    query_result(period_size_class, Text, Profile, Result, Citations).

size_class(Text, Profile, Result, Citations) :-
    query_result(size_class, Text, Profile, Result, Citations).

sme_status(Text, Profile, Result, Citations) :-
    query_result(sme_status, Text, Profile, Result, Citations).

at_least_medium(Text, Profile, Result, Citations) :-
    query_result(at_least_medium, Text, Profile, Result, Citations).

relationship_type(Text, Profile, Result, Citations) :-
    query_result(relationship_type, Text, Profile, Result, Citations).

decide_sme_definition(query(Query, Text, Profile), sme_definition_verdict(Result, Citations)) :-
    query_name(Query),
    query_result(Query, Text, Profile, Result, Citations).

sme_definition_status(Request, Status) :-
    decide_sme_definition(Request, sme_definition_verdict(Status, _)).

sme_definition_checklist(Request, [item(determination, Result, Citations)|ProvisionItems]) :-
    decide_sme_definition(Request, sme_definition_verdict(Result, Citations)),
    maplist(provision_item, Citations, ProvisionItems).

provision_item(cite(Key), item(Key, met, cite(Key))).

sme_definition_decision_resolvable(Request) :-
    decide_sme_definition(Request, _).

sme_definition_status_values([micro_enterprise, small_enterprise, medium_sized_enterprise, large_enterprise, not_sme_public_control, not_an_enterprise, sme, not_sme, at_least_medium, below_medium, linked_enterprise, partner_enterprise, neither_partner_nor_linked]).

micro_enterprise.

small_enterprise.

medium_sized_enterprise.

large_enterprise.

not_sme_public_control.

not_an_enterprise.

sme.

not_sme.

at_least_medium.

below_medium.

linked_enterprise.

partner_enterprise.

neither_partner_nor_linked.

partner_enterprise_data(Share, Staff, Turnover, Balance) :-
    integer(Share),
    integer(Staff),
    integer(Turnover),
    integer(Balance).

linked_enterprise_data(Staff, Turnover, Balance) :-
    integer(Staff),
    integer(Turnover),
    integer(Balance).

indeterminate(MissingKeys) :-
    is_list(MissingKeys).

needs_legal_review(Reason, Context) :-
    compound(Reason),
    is_list(Context).

open_textured(Judgement, Citation) :-
    atom(Judgement),
    compound(Citation).

inputs_relied_on(Pairs) :-
    is_list(Pairs).

provenance(Clause, Citations) :-
    atom(Clause),
    is_list(Citations).

input_problems(Problems) :-
    is_list(Problems).

unknown_key(Key) :-
    ground(Key).

wrong_type(Key) :-
    atom(Key).

duplicate_key(Key) :-
    atom(Key).

autonomous_micro_profile([attribute(own_staff_annual_work_units_hundredths, 500), attribute(own_annual_turnover_cents, 100000000), attribute(own_annual_balance_sheet_total_cents, 100000000), attribute(partner_enterprises, []), attribute(linked_enterprises, [])]).

small_held_profile([attribute(is_enterprise, true), attribute(public_bodies_control_25_percent_or_more, false), attribute(accounting_basis, approved_accounts), attribute(own_staff_annual_work_units_hundredths, 2000), attribute(own_annual_turnover_cents, 500000000), attribute(own_annual_balance_sheet_total_cents, 500000000), attribute(partner_enterprises, []), attribute(linked_enterprises, []), attribute(previous_period_size_class, micro_enterprise)]).

test(an_autonomous_micro_period_class) :-
    autonomous_micro_profile(Profile),
    period_size_class(recommendation_2003_361_annex, Profile, Result, Citations),
    Result == micro_enterprise,
    sort([cite(eu_rec_2003_361_annex_art_2_3), cite(eu_rec_2003_361_annex_art_5), cite(eu_rec_2003_361_annex_art_6_1)], Expected),
    Citations == Expected.
test(an_autonomous_micro_period_class_under_gber) :-
    autonomous_micro_profile(Profile),
    period_size_class(gber_annex_i, Profile, micro_enterprise, Citations),
    sort([cite(eu_reg_651_2014_annex_i_art_2_3), cite(eu_reg_651_2014_annex_i_art_5), cite(eu_reg_651_2014_annex_i_art_6_1)], Expected),
    Citations == Expected.
test(an_absent_linked_list_is_named) :-
    period_size_class(recommendation_2003_361_annex, [attribute(own_staff_annual_work_units_hundredths, 500), attribute(own_annual_turnover_cents, 100000000), attribute(own_annual_balance_sheet_total_cents, 100000000), attribute(partner_enterprises, [])], Result, Citations),
    Result == indeterminate([linked_enterprises]),
    Citations == [].
test(a_named_linked_argument_is_not_an_input_problem) :-
    period_size_class(recommendation_2003_361_annex, [attribute(linked_enterprises, [linked_enterprise_data(staff, turnover, balance)])], Result, Citations),
    Result = indeterminate([_]),
    Citations == [].
test(a_present_list_with_named_arguments_is_never_named) :-
    period_size_class(recommendation_2003_361_annex, [attribute(linked_enterprises, [linked_enterprise_data(staff, turnover, balance)])], Result, []),
    Result == indeterminate([own_staff_annual_work_units_hundredths]).
test(a_named_linked_argument_adds_zero) :-
    period_size_class(recommendation_2003_361_annex, [attribute(own_staff_annual_work_units_hundredths, 500), attribute(own_annual_turnover_cents, 100000000), attribute(own_annual_balance_sheet_total_cents, 100000000), attribute(partner_enterprises, []), attribute(linked_enterprises, [linked_enterprise_data(staff, 0, 0)])], Result, Citations),
    Result == micro_enterprise,
    sort([cite(eu_rec_2003_361_annex_art_2_3), cite(eu_rec_2003_361_annex_art_5), cite(eu_rec_2003_361_annex_art_6_2), cite(eu_rec_2003_361_annex_art_6_t4)], Expected),
    Citations == Expected.
test(not_an_enterprise_whatever_else) :-
    size_class(recommendation_2003_361_annex, [attribute(is_enterprise, false)], Result, Citations),
    Result == not_an_enterprise,
    Citations == [cite(eu_rec_2003_361_annex_art_1_t1)].
test(an_absent_held_class_is_named) :-
    small_held_profile(Profile),
    size_class(recommendation_2003_361_annex, Profile, Result, []),
    Result == indeterminate([size_class_held]).
test(a_held_micro_class_is_kept) :-
    small_held_profile(BaseProfile),
    append(BaseProfile, [attribute(size_class_held, micro_enterprise)], Profile),
    size_class(recommendation_2003_361_annex, Profile, Result, Citations),
    Result == micro_enterprise,
    sort([cite(eu_rec_2003_361_annex_art_2_3), cite(eu_rec_2003_361_annex_art_5), cite(eu_rec_2003_361_annex_art_6_1), cite(eu_rec_2003_361_annex_art_4_1), cite(eu_rec_2003_361_annex_art_4_2)], Expected),
    Citations == Expected.
test(a_bona_fide_estimate_above_the_ceilings_is_not_sme) :-
    sme_status(recommendation_2003_361_annex, [attribute(is_enterprise, true), attribute(public_bodies_control_25_percent_or_more, false), attribute(own_staff_annual_work_units_hundredths, 30000), attribute(accounting_basis, bona_fide_estimate)], Result, Citations),
    Result == not_sme,
    sort([cite(eu_rec_2003_361_annex_art_2_1), cite(eu_rec_2003_361_annex_art_5), cite(eu_rec_2003_361_annex_art_4_3)], Expected),
    Citations == Expected.
test(a_majority_of_voting_rights_links) :-
    relationship_type(recommendation_2003_361_annex, [attribute(majority_of_voting_rights, true), attribute(relationship_only_through_natural_persons, false)], Result, Citations),
    Result == linked_enterprise,
    sort([cite(eu_rec_2003_361_annex_art_3_3), cite(eu_rec_2003_361_annex_art_3_t9)], Expected),
    Citations == Expected.
test(an_unsure_dominant_influence_is_referred) :-
    relationship_type(gber_annex_i, [attribute(majority_of_voting_rights, false), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(majority_of_voting_rights_by_shareholder_agreement, false), attribute(relationship_only_through_natural_persons, false), attribute(dominant_influence_by_contract_or_articles, unsure), attribute(holding_basis_points, 3000), attribute(investor_category, not_a_listed_investor)], Result, Citations),
    Result == needs_legal_review(open_textured(dominant_influence_by_contract_or_articles, cite(eu_reg_651_2014_annex_i_art_3_3_c)), [inputs_relied_on([dominant_influence_by_contract_or_articles - unsure])]),
    Citations == [].
test(an_absent_holding_is_named_before_the_referral) :-
    relationship_type(recommendation_2003_361_annex, [attribute(majority_of_voting_rights, false), attribute(right_to_appoint_or_remove_majority_of_board, false), attribute(majority_of_voting_rights_by_shareholder_agreement, false), attribute(relationship_only_through_natural_persons, false), attribute(dominant_influence_by_contract_or_articles, unsure), attribute(investor_category, not_a_listed_investor)], Result, []),
    Result == indeterminate([holding_basis_points]).
test(a_partner_item_of_two_arguments_is_an_input_problem) :-
    period_size_class(recommendation_2003_361_annex, [attribute(partner_enterprises, [partner_enterprise_data(2500, 100)])], Result, Citations),
    Result == input_problems([wrong_type(partner_enterprises)]),
    Citations == [].
test(a_wrong_text_is_an_input_problem) :-
    size_class(directive_unknown, [], Result, Citations),
    Result == input_problems([wrong_type(text)]),
    Citations == [].

test(an_autonomous_micro_is_not_small, fail) :-
    autonomous_micro_profile(Profile),
    period_size_class(recommendation_2003_361_annex, Profile, small_enterprise, _).
