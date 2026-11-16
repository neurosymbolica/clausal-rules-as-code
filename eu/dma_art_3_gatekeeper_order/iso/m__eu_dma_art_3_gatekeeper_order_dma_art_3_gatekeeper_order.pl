% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_3_gatekeeper_order_dma_art_3_gatekeeper_order, [impact_threshold_status/3, gateway_threshold_status/3, entrenchment_threshold_status/3, presumption_status/3, designation_requirements_status/4, gatekeeper_status/4, decide_dma_art_3_gatekeeper_order/2, dma_art_3_gatekeeper_order_status/2, dma_art_3_gatekeeper_order_checklist/2, dma_art_3_gatekeeper_order_decision_resolvable/1, dma_art_3_gatekeeper_order_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_dma_art_3_gatekeeper_order_kernel, [dma_art_3_gatekeeper_order_input_problems/2, dma_art_3_gatekeeper_order_outside_fact/3, dma_art_3_gatekeeper_order_merge_citations/3]).
:- use_module(m__eu_dma_art_3_gatekeeper_order_citations, [implements/1]).

statutory_threshold(union_turnover, Threshold) :-
    implements(eu_reg_2022_1925_art_3_2_a),
    Threshold #= 7500000000.
statutory_threshold(market_capitalisation, Threshold) :-
    implements(eu_reg_2022_1925_art_3_2_a),
    Threshold #= 75000000000.
statutory_threshold(member_states, Threshold) :-
    implements(eu_reg_2022_1925_art_3_2_a),
    Threshold #= 3.
statutory_threshold(monthly_active_end_users, Threshold) :-
    implements(eu_reg_2022_1925_art_3_2_b),
    Threshold #= 45000000.
statutory_threshold(yearly_active_business_users, Threshold) :-
    implements(eu_reg_2022_1925_art_3_2_b),
    Threshold #= 10000.

figure_threshold(market_capitalisation_eur_most_recent_financial_year, market_capitalisation, cite(eu_reg_2022_1925_art_3_2_a)).
figure_threshold(member_states_where_core_platform_service_provided, member_states, cite(eu_reg_2022_1925_art_3_2_a)).
figure_threshold(union_turnover_eur_most_recent_financial_year, union_turnover, cite(eu_reg_2022_1925_art_3_2_a)).
figure_threshold(union_turnover_eur_second_most_recent_financial_year, union_turnover, cite(eu_reg_2022_1925_art_3_2_a)).
figure_threshold(union_turnover_eur_third_most_recent_financial_year, union_turnover, cite(eu_reg_2022_1925_art_3_2_a)).
figure_threshold(monthly_active_end_users_most_recent_financial_year, monthly_active_end_users, cite(eu_reg_2022_1925_art_3_2_b)).
figure_threshold(monthly_active_end_users_second_most_recent_financial_year, monthly_active_end_users, cite(eu_reg_2022_1925_art_3_2_c)).
figure_threshold(monthly_active_end_users_third_most_recent_financial_year, monthly_active_end_users, cite(eu_reg_2022_1925_art_3_2_c)).
figure_threshold(yearly_active_business_users_most_recent_financial_year, yearly_active_business_users, cite(eu_reg_2022_1925_art_3_2_b)).
figure_threshold(yearly_active_business_users_second_most_recent_financial_year, yearly_active_business_users, cite(eu_reg_2022_1925_art_3_2_c)).
figure_threshold(yearly_active_business_users_third_most_recent_financial_year, yearly_active_business_users, cite(eu_reg_2022_1925_art_3_2_c)).

judgement_citation(significant_impact_on_internal_market, cite(eu_reg_2022_1925_art_3_1_a)).
judgement_citation(core_platform_service_is_important_gateway, cite(eu_reg_2022_1925_art_3_1_b)).
judgement_citation(entrenched_and_durable_position, cite(eu_reg_2022_1925_art_3_1_c)).

dma_art_3_gatekeeper_order_status_values([requirements_presumed_met, requirements_met, requirements_not_met]).

figure_state(Profile, FigureKey, FigureState) :-
    figure_threshold(FigureKey, ThresholdName, _Citation),
    statutory_threshold(ThresholdName, Threshold),
    figure_against(Profile, FigureKey, Threshold, FigureState).

figure_against(Profile, FigureKey, _Threshold, absent) :-
    profile_lacks(Profile, FigureKey).
figure_against(Profile, FigureKey, Threshold, below) :-
    profile_get(Profile, FigureKey, Figure),
    Figure #< Threshold.
figure_against(Profile, FigureKey, Threshold, reaches) :-
    profile_get(Profile, FigureKey, Figure),
    Figure #>= Threshold.

keyed_states([], _, []).
keyed_states([FigureKey|FigureKeys], Profile, [FigureKey - FigureState|LaterPairs]) :-
    figure_state(Profile, FigureKey, FigureState),
    keyed_states(FigureKeys, Profile, LaterPairs).

first_key_in_state([FoundKey - WantedState|_], WantedState, FoundKey).
first_key_in_state([_ - OtherState|LaterPairs], WantedState, FoundKey) :-
    dif(OtherState, WantedState),
    first_key_in_state(LaterPairs, WantedState, FoundKey).

threshold_outcome(Pairs, not_met) :-
    pairs_values(Pairs, States),
    memberd_t(below, States, true).
threshold_outcome(Pairs, met) :-
    pairs_values(Pairs, States),
    memberd_t(below, States, false),
    memberd_t(absent, States, false).
threshold_outcome(Pairs, missing(FoundKey)) :-
    pairs_values(Pairs, States),
    memberd_t(below, States, false),
    memberd_t(absent, States, true),
    first_key_in_state(Pairs, absent, FoundKey).

truth_conjunction(true, Truth, Truth).
truth_conjunction(false, _, false).

impact_threshold_status(Profile, input_problems([Problem|Problems]), []) :-
    dma_art_3_gatekeeper_order_input_problems(Profile, [Problem|Problems]).
impact_threshold_status(Profile, Result, Citations) :-
    dma_art_3_gatekeeper_order_input_problems(Profile, []),
    impact_answer(Profile, Result, Citations).

gateway_threshold_status(Profile, input_problems([Problem|Problems]), []) :-
    dma_art_3_gatekeeper_order_input_problems(Profile, [Problem|Problems]).
gateway_threshold_status(Profile, Result, Citations) :-
    dma_art_3_gatekeeper_order_input_problems(Profile, []),
    gateway_answer(Profile, Result, Citations).

entrenchment_threshold_status(Profile, input_problems([Problem|Problems]), []) :-
    dma_art_3_gatekeeper_order_input_problems(Profile, [Problem|Problems]).
entrenchment_threshold_status(Profile, Result, Citations) :-
    dma_art_3_gatekeeper_order_input_problems(Profile, []),
    entrenchment_answer(Profile, Result, Citations).

presumption_status(Profile, input_problems([Problem|Problems]), []) :-
    dma_art_3_gatekeeper_order_input_problems(Profile, [Problem|Problems]).
presumption_status(Profile, Result, Citations) :-
    dma_art_3_gatekeeper_order_input_problems(Profile, []),
    presumption_answer(Profile, Result, Citations).

designation_requirements_status(Profile, input_problems([Problem|Problems]), [], []) :-
    dma_art_3_gatekeeper_order_input_problems(Profile, [Problem|Problems]).
designation_requirements_status(Profile, Result, Basis, Citations) :-
    dma_art_3_gatekeeper_order_input_problems(Profile, []),
    designation_answer(Profile, Result, Basis, Citations).

gatekeeper_status(Profile, input_problems([Problem|Problems]), [], []) :-
    dma_art_3_gatekeeper_order_input_problems(Profile, [Problem|Problems]).
gatekeeper_status(Profile, Result, Basis, Citations) :-
    dma_art_3_gatekeeper_order_input_problems(Profile, []),
    gatekeeper_answer(Profile, Result, Basis, Citations).

impact_answer(Profile, Result, Citations) :-
    implements(eu_reg_2022_1925_art_3_2_a),
    figure_state(Profile, member_states_where_core_platform_service_provided, MemberStates),
    figure_state(Profile, market_capitalisation_eur_most_recent_financial_year, Market),
    keyed_states([union_turnover_eur_most_recent_financial_year, union_turnover_eur_second_most_recent_financial_year, union_turnover_eur_third_most_recent_financial_year], Profile, TurnoverPairs),
    pairs_values(TurnoverPairs, TurnoverStates),
    turnover_branch(TurnoverStates, TurnoverBranch),
    market_branch(Market, MarketBranch),
    financial_condition(TurnoverBranch, MarketBranch, Financial),
    impact_outcome(MemberStates, Financial, impact_context(Market, TurnoverBranch, MarketBranch, TurnoverPairs), Result, Citations).

turnover_branch(TurnoverStates, fails) :-
    implements(eu_reg_2022_1925_art_3_2_a),
    memberd_t(below, TurnoverStates, true).
turnover_branch(TurnoverStates, open) :-
    implements(eu_reg_2022_1925_art_3_2_a),
    memberd_t(below, TurnoverStates, false),
    memberd_t(absent, TurnoverStates, true).
turnover_branch(TurnoverStates, holds) :-
    implements(eu_reg_2022_1925_art_3_2_a),
    memberd_t(below, TurnoverStates, false),
    memberd_t(absent, TurnoverStates, false).

market_branch(below, fails).
market_branch(reaches, holds).
market_branch(absent, open).

financial_condition(holds, holds, holds).
financial_condition(holds, fails, holds).
financial_condition(holds, open, holds).
financial_condition(fails, holds, holds).
financial_condition(open, holds, holds).
financial_condition(fails, fails, fails).
financial_condition(fails, open, open).
financial_condition(open, fails, open).
financial_condition(open, open, open).

impact_outcome(below, _, _, impact_threshold_not_met, [cite(eu_reg_2022_1925_art_3_2_a)]) :-
    implements(eu_reg_2022_1925_art_3_2_a).
impact_outcome(absent, fails, _, impact_threshold_not_met, [cite(eu_reg_2022_1925_art_3_2_a)]) :-
    implements(eu_reg_2022_1925_art_3_2_a).
impact_outcome(reaches, fails, _, impact_threshold_not_met, [cite(eu_reg_2022_1925_art_3_2_a)]) :-
    implements(eu_reg_2022_1925_art_3_2_a).
impact_outcome(reaches, holds, _, impact_threshold_met, [cite(eu_reg_2022_1925_art_3_2_a)]) :-
    implements(eu_reg_2022_1925_art_3_2_a).
impact_outcome(absent, holds, Context, indeterminate([FoundKey]), []) :-
    impact_first_key(absent, Context, FoundKey).
impact_outcome(absent, open, Context, indeterminate([FoundKey]), []) :-
    impact_first_key(absent, Context, FoundKey).
impact_outcome(reaches, open, Context, indeterminate([FoundKey]), []) :-
    impact_first_key(reaches, Context, FoundKey).

impact_first_key(MemberStates, impact_context(Market, TurnoverBranch, MarketBranch, TurnoverPairs), FoundKey) :-
    implements(eu_reg_2022_1925_art_3_2_a),
    market_can_change(TurnoverBranch, MarketCanChange),
    turnover_can_change(TurnoverBranch, MarketBranch, TurnoverCanChange),
    turnover_candidates(TurnoverPairs, TurnoverCanChange, TurnoverCandidates),
    first_open_candidate([candidate(market_capitalisation_eur_most_recent_financial_year, Market, MarketCanChange), candidate(member_states_where_core_platform_service_provided, MemberStates, true)|TurnoverCandidates], FoundKey).

market_can_change(holds, false).
market_can_change(fails, true).
market_can_change(open, true).

turnover_can_change(fails, _, false).
turnover_can_change(holds, holds, false).
turnover_can_change(open, holds, false).
turnover_can_change(holds, fails, true).
turnover_can_change(holds, open, true).
turnover_can_change(open, fails, true).
turnover_can_change(open, open, true).

turnover_candidates([], _, []).
turnover_candidates([FigureKey - FigureState|LaterPairs], CanChange, [candidate(FigureKey, FigureState, CanChange)|LaterCandidates]) :-
    turnover_candidates(LaterPairs, CanChange, LaterCandidates).

first_open_candidate([candidate(FoundKey, absent, true)|_], FoundKey).
first_open_candidate([candidate(_, FigureState, CanChange)|LaterCandidates], FoundKey) :-
    candidate_skipped(FigureState, CanChange),
    first_open_candidate(LaterCandidates, FoundKey).

candidate_skipped(below, _).
candidate_skipped(reaches, _).
candidate_skipped(absent, false).

gateway_answer(Profile, Result, Citations) :-
    implements(eu_reg_2022_1925_art_3_2_b),
    keyed_states([monthly_active_end_users_most_recent_financial_year, yearly_active_business_users_most_recent_financial_year], Profile, Pairs),
    threshold_outcome(Pairs, Outcome),
    gateway_result(Outcome, Result, Citations).

gateway_result(not_met, gateway_threshold_not_met, [cite(eu_reg_2022_1925_art_3_2_b)]).
gateway_result(met, gateway_threshold_met, [cite(eu_reg_2022_1925_art_3_2_b)]).
gateway_result(missing(FoundKey), indeterminate([FoundKey]), []).

entrenchment_answer(Profile, Result, Citations) :-
    implements(eu_reg_2022_1925_art_3_2_c),
    keyed_states([monthly_active_end_users_most_recent_financial_year, monthly_active_end_users_second_most_recent_financial_year, monthly_active_end_users_third_most_recent_financial_year, yearly_active_business_users_most_recent_financial_year, yearly_active_business_users_second_most_recent_financial_year, yearly_active_business_users_third_most_recent_financial_year], Profile, Pairs),
    threshold_outcome(Pairs, Outcome),
    entrenchment_result(Outcome, Result, Citations).

entrenchment_result(not_met, entrenchment_threshold_not_met, [cite(eu_reg_2022_1925_art_3_2_c), cite(eu_reg_2022_1925_art_3_2_b)]).
entrenchment_result(met, entrenchment_threshold_met, [cite(eu_reg_2022_1925_art_3_2_c), cite(eu_reg_2022_1925_art_3_2_b)]).
entrenchment_result(missing(FoundKey), indeterminate([FoundKey]), []).

outcome_kind(impact_threshold_met, met).
outcome_kind(impact_threshold_not_met, not_met).
outcome_kind(gateway_threshold_met, met).
outcome_kind(gateway_threshold_not_met, not_met).
outcome_kind(entrenchment_threshold_met, met).
outcome_kind(entrenchment_threshold_not_met, not_met).
outcome_kind(gatekeeper_presumed, met).
outcome_kind(gatekeeper_not_presumed, not_met).
outcome_kind(indeterminate(_), open).

presumption_answer(Profile, Result, Citations) :-
    implements(eu_reg_2022_1925_art_3_2),
    impact_answer(Profile, ImpactResult, ImpactCitations),
    gateway_answer(Profile, GatewayResult, GatewayCitations),
    entrenchment_answer(Profile, EntrenchmentResult, EntrenchmentCitations),
    outcome_kind(ImpactResult, ImpactKind),
    outcome_kind(GatewayResult, GatewayKind),
    outcome_kind(EntrenchmentResult, EntrenchmentKind),
    memberd_t(not_met, [ImpactKind, GatewayKind, EntrenchmentKind], AnyNotMet),
    presumption_outcome(AnyNotMet, [ImpactKind - ImpactCitations, GatewayKind - GatewayCitations, EntrenchmentKind - EntrenchmentCitations], ImpactResult, EntrenchmentResult, Result, Citations).

presumption_outcome(true, Parts, _, _, gatekeeper_not_presumed, Citations) :-
    implements(eu_reg_2022_1925_art_3_2),
    not_met_citations(Parts, Citations).
presumption_outcome(false, [open - _|_], ImpactResult, _, ImpactResult, []).
presumption_outcome(false, [met - _, _, open - _], _, EntrenchmentResult, EntrenchmentResult, []).
presumption_outcome(false, [met - _, met - _, met - _], _, _, gatekeeper_presumed, [cite(eu_reg_2022_1925_art_3_2_a), cite(eu_reg_2022_1925_art_3_2_b), cite(eu_reg_2022_1925_art_3_2_c)]) :-
    implements(eu_reg_2022_1925_art_3_2).

not_met_citations([], []).
not_met_citations([OutcomeKind - PointCitations|LaterParts], Citations) :-
    not_met_citations(LaterParts, LaterCitations),
    kind_contribution(OutcomeKind, PointCitations, Contribution),
    dma_art_3_gatekeeper_order_merge_citations(Contribution, LaterCitations, Citations).

kind_contribution(not_met, PointCitations, PointCitations).
kind_contribution(met, _, []).
kind_contribution(open, _, []).

profile_state(Profile, ContractKey, absent) :-
    profile_lacks(Profile, ContractKey).
profile_state(Profile, ContractKey, Value) :-
    profile_get(Profile, ContractKey, Value).

judgement_pairs(Profile, [significant_impact_on_internal_market - ImpactJudgement, core_platform_service_is_important_gateway - GatewayJudgement, entrenched_and_durable_position - PositionJudgement]) :-
    profile_state(Profile, significant_impact_on_internal_market, ImpactJudgement),
    profile_state(Profile, core_platform_service_is_important_gateway, GatewayJudgement),
    profile_state(Profile, entrenched_and_durable_position, PositionJudgement).

designation_answer(Profile, Result, Basis, Citations) :-
    implements(eu_reg_2022_1925_art_3_1),
    presumption_answer(Profile, Presumption, _PresumptionCitations),
    designation_outcome(Presumption, Profile, Result, Basis, Citations).

designation_outcome(indeterminate(MissingKeys), Profile, Result, Basis, Citations) :-
    implements(eu_reg_2022_1925_art_3_5),
    profile_state(Profile, rebuttal_arguments_presented, Presented),
    dma_art_3_gatekeeper_order_outside_fact(Profile, rebuttal_accepted_by_commission, Accepted),
    judgement_pairs(Profile, Pairs),
    pairs_values(Pairs, States),
    memberd_t(false, States, AnyFalse),
    accepted_rebuttal_shown(Presented, Accepted, Shown),
    truth_conjunction(Shown, AnyFalse, BothRoutesFail),
    unsettled_outcome(BothRoutesFail, MissingKeys, Result, Basis, Citations).
designation_outcome(gatekeeper_presumed, Profile, Result, Basis, Citations) :-
    implements(eu_reg_2022_1925_art_3_5),
    profile_state(Profile, rebuttal_arguments_presented, Presented),
    dma_art_3_gatekeeper_order_outside_fact(Profile, rebuttal_accepted_by_commission, Accepted),
    presumed_outcome(Presented, Accepted, Result, Basis, Citations).
designation_outcome(gatekeeper_not_presumed, Profile, Result, Basis, Citations) :-
    implements(eu_reg_2022_1925_art_3_1),
    judgement_pairs(Profile, Pairs),
    pairs_values(Pairs, States),
    memberd_t(false, States, AnyFalse),
    memberd_t(absent, States, AnyAbsent),
    memberd_t(unsure, States, AnyUnsure),
    judgement_outcome(AnyFalse, AnyAbsent, AnyUnsure, Pairs, Result, Basis, Citations).

accepted_rebuttal_shown(true, attested_true(_), true).
accepted_rebuttal_shown(true, attested_false(_), false).
accepted_rebuttal_shown(true, absent, false).
accepted_rebuttal_shown(false, _, false).
accepted_rebuttal_shown(absent, _, false).

unsettled_outcome(true, _, requirements_not_met, [], [cite(eu_reg_2022_1925_art_3_1)]) :-
    implements(eu_reg_2022_1925_art_3_1).
unsettled_outcome(false, MissingKeys, indeterminate(MissingKeys), [], []).

presumed_outcome(false, _, requirements_presumed_met, [], [cite(eu_reg_2022_1925_art_3_1), cite(eu_reg_2022_1925_art_3_2)]) :-
    implements(eu_reg_2022_1925_art_3_2).
presumed_outcome(absent, attested_false(_), requirements_presumed_met, [], [cite(eu_reg_2022_1925_art_3_1), cite(eu_reg_2022_1925_art_3_2)]) :-
    implements(eu_reg_2022_1925_art_3_2).
presumed_outcome(absent, absent, indeterminate([rebuttal_arguments_presented]), [], []).
presumed_outcome(absent, attested_true(_), indeterminate([rebuttal_arguments_presented]), [], []).
presumed_outcome(true, attested_false(Attested), requirements_presumed_met, [outside_fact(rebuttal_accepted_by_commission, Attested)], [cite(eu_reg_2022_1925_art_3_1), cite(eu_reg_2022_1925_art_3_2), cite(eu_reg_2022_1925_art_3_5)]) :-
    implements(eu_reg_2022_1925_art_3_5).
presumed_outcome(true, attested_true(Attested), requirements_not_met, [outside_fact(rebuttal_accepted_by_commission, Attested)], [cite(eu_reg_2022_1925_art_3_1), cite(eu_reg_2022_1925_art_3_2), cite(eu_reg_2022_1925_art_3_5)]) :-
    implements(eu_reg_2022_1925_art_3_5).
presumed_outcome(true, absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_3_5), cite(commission_rebuttal_conclusion)), [resolution(cite(commission_rebuttal_conclusion), not_attempted), inputs_relied_on([rebuttal_accepted_by_commission - absent])]), [], []) :-
    implements(eu_reg_2022_1925_art_3_5).

judgement_outcome(true, _, _, _, requirements_not_met, [], [cite(eu_reg_2022_1925_art_3_1), cite(eu_reg_2022_1925_art_3_2)]) :-
    implements(eu_reg_2022_1925_art_3_1).
judgement_outcome(false, true, _, Pairs, indeterminate([FoundKey]), [], []) :-
    first_key_in_state(Pairs, absent, FoundKey).
judgement_outcome(false, false, true, Pairs, needs_legal_review(open_textured(FoundKey, Citation), [inputs_relied_on(Pairs)]), [], []) :-
    implements(eu_reg_2022_1925_art_3_1),
    first_key_in_state(Pairs, unsure, FoundKey),
    judgement_citation(FoundKey, Citation).
judgement_outcome(false, false, false, _, requirements_met, [], [cite(eu_reg_2022_1925_art_3_1_a), cite(eu_reg_2022_1925_art_3_1_b), cite(eu_reg_2022_1925_art_3_1_c)]) :-
    implements(eu_reg_2022_1925_art_3_1).

gatekeeper_answer(Profile, Result, Basis, Citations) :-
    implements(eu_reg_2022_1925_art_3_9),
    dma_art_3_gatekeeper_order_outside_fact(Profile, designated_as_gatekeeper_for_core_platform_service, Designation),
    designation_decision_outcome(Designation, Result, Basis, Citations).

designation_decision_outcome(attested_true(Attested), designated_gatekeeper, [outside_fact(designated_as_gatekeeper_for_core_platform_service, Attested)], [cite(eu_reg_2022_1925_art_3_9)]) :-
    implements(eu_reg_2022_1925_art_3_9).
designation_decision_outcome(attested_false(Attested), not_designated_gatekeeper, [outside_fact(designated_as_gatekeeper_for_core_platform_service, Attested)], [cite(eu_reg_2022_1925_art_3_9)]) :-
    implements(eu_reg_2022_1925_art_3_9).
designation_decision_outcome(absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_3_9), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent])]), [], []) :-
    implements(eu_reg_2022_1925_art_3_9).

decide_dma_art_3_gatekeeper_order(Profile, dma_art_3_gatekeeper_order_verdict(Status, Citations)) :-
    designation_requirements_status(Profile, Status, _Basis, Citations).

dma_art_3_gatekeeper_order_status(Profile, Status) :-
    decide_dma_art_3_gatekeeper_order(Profile, dma_art_3_gatekeeper_order_verdict(Status, _Citations)).

dma_art_3_gatekeeper_order_checklist(Profile, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_reg_2022_1925_art_3_1))]) :-
    dma_art_3_gatekeeper_order_input_problems(Profile, [Problem|Problems]).
dma_art_3_gatekeeper_order_checklist(Profile, Items) :-
    dma_art_3_gatekeeper_order_input_problems(Profile, []),
    checklist_rows([impact_threshold, gateway_threshold, entrenchment_threshold, presumption, significant_impact_on_internal_market, core_platform_service_is_important_gateway, entrenched_and_durable_position], Profile, Items).

checklist_rows([], _, []).
checklist_rows([RequirementId|RequirementIds], Profile, [item(RequirementId, ItemStatus, Citation)|LaterItems]) :-
    checklist_requirement(RequirementId, Profile, ItemStatus, Citation),
    checklist_rows(RequirementIds, Profile, LaterItems).

checklist_requirement(impact_threshold, Profile, ItemStatus, cite(eu_reg_2022_1925_art_3_2_a)) :-
    implements(eu_reg_2022_1925_art_3_2_a),
    impact_answer(Profile, Result, _Citations),
    outcome_item_status(Result, ItemStatus).
checklist_requirement(gateway_threshold, Profile, ItemStatus, cite(eu_reg_2022_1925_art_3_2_b)) :-
    implements(eu_reg_2022_1925_art_3_2_b),
    gateway_answer(Profile, Result, _Citations),
    outcome_item_status(Result, ItemStatus).
checklist_requirement(entrenchment_threshold, Profile, ItemStatus, cite(eu_reg_2022_1925_art_3_2_c)) :-
    implements(eu_reg_2022_1925_art_3_2_c),
    entrenchment_answer(Profile, Result, _Citations),
    outcome_item_status(Result, ItemStatus).
checklist_requirement(presumption, Profile, ItemStatus, cite(eu_reg_2022_1925_art_3_2)) :-
    implements(eu_reg_2022_1925_art_3_2),
    presumption_answer(Profile, Result, _Citations),
    outcome_item_status(Result, ItemStatus).
checklist_requirement(significant_impact_on_internal_market, Profile, ItemStatus, cite(eu_reg_2022_1925_art_3_1_a)) :-
    implements(eu_reg_2022_1925_art_3_1_a),
    profile_state(Profile, significant_impact_on_internal_market, Judgement),
    judgement_item_status(significant_impact_on_internal_market, Judgement, ItemStatus).
checklist_requirement(core_platform_service_is_important_gateway, Profile, ItemStatus, cite(eu_reg_2022_1925_art_3_1_b)) :-
    implements(eu_reg_2022_1925_art_3_1_b),
    profile_state(Profile, core_platform_service_is_important_gateway, Judgement),
    judgement_item_status(core_platform_service_is_important_gateway, Judgement, ItemStatus).
checklist_requirement(entrenched_and_durable_position, Profile, ItemStatus, cite(eu_reg_2022_1925_art_3_1_c)) :-
    implements(eu_reg_2022_1925_art_3_1_c),
    profile_state(Profile, entrenched_and_durable_position, Judgement),
    judgement_item_status(entrenched_and_durable_position, Judgement, ItemStatus).

outcome_item_status(Result, ItemStatus) :-
    outcome_kind(Result, OutcomeKind),
    kind_item_status(OutcomeKind, Result, ItemStatus).

kind_item_status(met, _, met).
kind_item_status(not_met, Result, unmet(Result)).
kind_item_status(open, indeterminate(MissingKeys), unknown(MissingKeys)).

judgement_item_status(_, true, met).
judgement_item_status(_, false, unmet(judged_false)).
judgement_item_status(JudgementKey, unsure, unknown([JudgementKey])).
judgement_item_status(JudgementKey, absent, unknown([JudgementKey])).

dma_art_3_gatekeeper_order_decision_resolvable(Profile) :-
    decide_dma_art_3_gatekeeper_order(Profile, _Verdict).

thresholds_met_profile([attribute(market_capitalisation_eur_most_recent_financial_year, 80000000000), attribute(member_states_where_core_platform_service_provided, 5), attribute(union_turnover_eur_most_recent_financial_year, 8000000000), attribute(union_turnover_eur_second_most_recent_financial_year, 8000000000), attribute(union_turnover_eur_third_most_recent_financial_year, 8000000000), attribute(monthly_active_end_users_most_recent_financial_year, 50000000), attribute(monthly_active_end_users_second_most_recent_financial_year, 50000000), attribute(monthly_active_end_users_third_most_recent_financial_year, 50000000), attribute(yearly_active_business_users_most_recent_financial_year, 20000), attribute(yearly_active_business_users_second_most_recent_financial_year, 20000), attribute(yearly_active_business_users_third_most_recent_financial_year, 20000)]).

test(impact_met_exactly_at_the_thresholds) :-
    findall(Result - Citations, impact_threshold_status([attribute(market_capitalisation_eur_most_recent_financial_year, 75000000000), attribute(member_states_where_core_platform_service_provided, 3)], Result, Citations), Answers),
    Answers == [impact_threshold_met - [cite(eu_reg_2022_1925_art_3_2_a)]].
test(impact_two_member_states_is_not_met) :-
    findall(Result, impact_threshold_status([attribute(member_states_where_core_platform_service_provided, 2)], Result, _), Answers),
    Answers == [impact_threshold_not_met].
test(impact_empty_profile_names_the_market_figure) :-
    findall(Result - Citations, impact_threshold_status([], Result, Citations), Answers),
    Answers == [indeterminate([market_capitalisation_eur_most_recent_financial_year]) - []].
test(impact_turnover_holds_skips_the_market_figure) :-
    findall(Result, impact_threshold_status([attribute(union_turnover_eur_most_recent_financial_year, 7500000000), attribute(union_turnover_eur_second_most_recent_financial_year, 7500000000), attribute(union_turnover_eur_third_most_recent_financial_year, 7500000000)], Result, _), Answers),
    Answers == [indeterminate([member_states_where_core_platform_service_provided])].
test(impact_market_below_names_the_first_turnover_year) :-
    findall(Result, impact_threshold_status([attribute(market_capitalisation_eur_most_recent_financial_year, 1), attribute(member_states_where_core_platform_service_provided, 4)], Result, _), Answers),
    Answers == [indeterminate([union_turnover_eur_most_recent_financial_year])].
test(gateway_empty_names_end_users) :-
    findall(Result, gateway_threshold_status([], Result, _), Answers),
    Answers == [indeterminate([monthly_active_end_users_most_recent_financial_year])].
test(gateway_below_end_users_is_not_met) :-
    findall(Result, gateway_threshold_status([attribute(monthly_active_end_users_most_recent_financial_year, 44999999)], Result, _), Answers),
    Answers == [gateway_threshold_not_met].
test(entrenchment_third_year_below_is_not_met) :-
    findall(Result - Citations, entrenchment_threshold_status([attribute(monthly_active_end_users_third_most_recent_financial_year, 10)], Result, Citations), Answers),
    Answers == [entrenchment_threshold_not_met - [cite(eu_reg_2022_1925_art_3_2_c), cite(eu_reg_2022_1925_art_3_2_b)]].
test(presumption_applies) :-
    thresholds_met_profile(Profile),
    findall(Result, presumption_status(Profile, Result, _), Answers),
    Answers == [gatekeeper_presumed].
test(presumption_not_presumed_merges_citations) :-
    findall(Result - Citations, presumption_status([attribute(member_states_where_core_platform_service_provided, 2), attribute(yearly_active_business_users_most_recent_financial_year, 9999)], Result, Citations), Answers),
    Answers == [gatekeeper_not_presumed - [cite(eu_reg_2022_1925_art_3_2_a), cite(eu_reg_2022_1925_art_3_2_b), cite(eu_reg_2022_1925_art_3_2_c)]].
test(requirements_presumed_met_without_arguments) :-
    thresholds_met_profile(Base),
    append(Base, [attribute(rebuttal_arguments_presented, false)], Profile),
    findall(Result - Basis, designation_requirements_status(Profile, Result, Basis, _), Answers),
    Answers == [requirements_presumed_met - []].
test(accepted_rebuttal_is_not_met_with_basis) :-
    thresholds_met_profile(Base),
    append(Base, [attribute(rebuttal_arguments_presented, true), attribute(rebuttal_accepted_by_commission, attested(true, attestation(host, at, reason, none)))], Profile),
    findall(Result - Basis, designation_requirements_status(Profile, Result, Basis, _), Answers),
    Answers == [requirements_not_met - [outside_fact(rebuttal_accepted_by_commission, attested(true, attestation(host, at, reason, none)))]].
test(rebuttal_conclusion_not_shown_is_referred) :-
    thresholds_met_profile(Base),
    append(Base, [attribute(rebuttal_arguments_presented, true)], Profile),
    designation_requirements_status(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_3_5), cite(commission_rebuttal_conclusion)), _), [], []).
test(unsure_gateway_judgement_is_referred) :-
    findall(Result, designation_requirements_status([attribute(member_states_where_core_platform_service_provided, 1), attribute(significant_impact_on_internal_market, true), attribute(core_platform_service_is_important_gateway, unsure), attribute(entrenched_and_durable_position, true)], Result, _, _), Answers),
    Answers == [needs_legal_review(open_textured(core_platform_service_is_important_gateway, cite(eu_reg_2022_1925_art_3_1_b)), [inputs_relied_on([significant_impact_on_internal_market - true, core_platform_service_is_important_gateway - unsure, entrenched_and_durable_position - true])])].
test(accepted_rebuttal_and_false_judgement_settle_early) :-
    findall(Result - Basis - Citations, designation_requirements_status([attribute(rebuttal_arguments_presented, true), attribute(rebuttal_accepted_by_commission, attested(true, attestation(host, at, reason, none))), attribute(entrenched_and_durable_position, false)], Result, Basis, Citations), Answers),
    Answers == [requirements_not_met - [] - [cite(eu_reg_2022_1925_art_3_1)]].
test(designation_not_shown_is_referred) :-
    findall(Result, gatekeeper_status([], Result, _, _), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_3_9), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent])])].
test(designation_attested_true) :-
    gatekeeper_status([attribute(designated_as_gatekeeper_for_core_platform_service, attested(true, attestation(host, at, reason, none)))], designated_gatekeeper, [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, attestation(host, at, reason, none)))], [cite(eu_reg_2022_1925_art_3_9)]).
test(input_problems_answer_every_query) :-
    findall(Result - Citations, impact_threshold_status([attribute(colour, red)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(checklist_has_seven_cited_rows) :-
    thresholds_met_profile(Profile),
    dma_art_3_gatekeeper_order_checklist(Profile, Items),
    length(Items, 7).

test(impact_two_member_states_is_not_met_never_met, fail) :-
    impact_threshold_status([attribute(member_states_where_core_platform_service_provided, 2)], impact_threshold_met, _).
