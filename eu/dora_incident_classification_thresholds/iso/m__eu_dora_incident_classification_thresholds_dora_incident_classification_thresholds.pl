% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_incident_classification_thresholds_dora_incident_classification_thresholds, [dora_incident_threshold_status/4, dora_final_report_timeliness/5, decide_dora_incident_classification_thresholds/2, dora_incident_classification_thresholds_status/2, dora_incident_classification_thresholds_checklist/2, dora_incident_classification_thresholds_decision_resolvable/1, dora_incident_classification_thresholds_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(deadline_lib, [month_last_day/3]).
:- use_module(m__eu_dora_incident_classification_thresholds_kernel, [dora_incident_classification_thresholds_input_problems/2]).
:- use_module(m__eu_dora_incident_classification_thresholds_citations, [implements/1]).

dora_incident_classification_thresholds_status_values([met, not_met]).

condition_order([critical_services_affected, data_losses_malicious_access_threshold_met, clients_financial_counterparts_and_transactions_threshold_met, reputational_impact_threshold_met, duration_and_service_downtime_threshold_met, geographical_spread_threshold_met, data_losses_impact_threshold_met, economic_impact_threshold_met]).

condition_keys(critical_services_affected, [affects_ict_services_supporting_critical_or_important_functions, affects_authorised_registered_or_supervised_financial_services, successful_malicious_unauthorised_access]).
condition_keys(data_losses_malicious_access_threshold_met, [successful_malicious_unauthorised_access, access_may_result_in_data_losses]).
condition_keys(clients_financial_counterparts_and_transactions_threshold_met, [affected_clients, clients_using_affected_service, affected_financial_counterparts, financial_counterparts_of_affected_service, affected_transactions_number, affected_transactions_amount, reference_period_transactions_number, reference_period_transactions_amount, reference_period_days, relevant_clients_or_financial_counterparts_affected]).
condition_keys(reputational_impact_threshold_met, [incident_reflected_in_media, repetitive_complaints_from_different_clients_or_counterparts, regulatory_requirements_likely_not_met, material_loss_of_clients_or_counterparts_likely]).
condition_keys(duration_and_service_downtime_threshold_met, [incident_duration_seconds, critical_or_important_function_service_downtime_seconds]).
condition_keys(geographical_spread_threshold_met, [member_states_with_impact]).
condition_keys(data_losses_impact_threshold_met, [data_impact_adverse_to_business_objectives_or_regulatory_requirements, data_availability_impact, data_authenticity_impact, data_integrity_impact, data_confidentiality_impact]).
condition_keys(economic_impact_threshold_met, [expropriated_funds_and_assets_cents, replacement_and_relocation_costs_cents, staff_costs_cents, contractual_non_compliance_fees_cents, redress_and_compensation_costs_cents, forgone_revenue_losses_cents, communication_costs_cents, advisory_costs_cents, costs_and_losses_likely_to_exceed_threshold]).

condition_citations(critical_services_affected, [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_8_1), cite(eu_reg_2024_1772_art_6)]).
condition_citations(data_losses_malicious_access_threshold_met, [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_5_b)]).
condition_citations(clients_financial_counterparts_and_transactions_threshold_met, [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_1), cite(eu_reg_2024_1772_art_1)]).
condition_citations(reputational_impact_threshold_met, [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_2), cite(eu_reg_2024_1772_art_2)]).
condition_citations(duration_and_service_downtime_threshold_met, [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_3), cite(eu_reg_2024_1772_art_3)]).
condition_citations(geographical_spread_threshold_met, [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_4), cite(eu_reg_2024_1772_art_4)]).
condition_citations(data_losses_impact_threshold_met, [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_5_a), cite(eu_reg_2024_1772_art_5)]).
condition_citations(economic_impact_threshold_met, [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_6), cite(eu_reg_2024_1772_art_7)]).

referral_citation(critical_services_affected, cite(eu_reg_2024_1772_art_6)).
referral_citation(data_losses_malicious_access_threshold_met, cite(eu_reg_2024_1772_art_9_5_b)).
referral_citation(clients_financial_counterparts_and_transactions_threshold_met, cite(eu_reg_2024_1772_art_9_1)).
referral_citation(reputational_impact_threshold_met, cite(eu_reg_2024_1772_art_9_2)).
referral_citation(data_losses_impact_threshold_met, cite(eu_reg_2024_1772_art_9_5_a)).
referral_citation(economic_impact_threshold_met, cite(eu_reg_2024_1772_art_9_6)).

condition_point(critical_services_affected, article_6_point_a, [judgement(affects_ict_services_supporting_critical_or_important_functions)], cite(eu_reg_2024_1772_art_6)).
condition_point(critical_services_affected, article_6_point_b, [judgement(affects_authorised_registered_or_supervised_financial_services)], cite(eu_reg_2024_1772_art_6)).
condition_point(critical_services_affected, article_6_point_c, [judgement(successful_malicious_unauthorised_access)], cite(eu_reg_2024_1772_art_6)).
condition_point(data_losses_malicious_access_threshold_met, article_9_5_point_b, [judgement(successful_malicious_unauthorised_access), judgement(access_may_result_in_data_losses)], cite(eu_reg_2024_1772_art_9_5_b)).
condition_point(clients_financial_counterparts_and_transactions_threshold_met, article_9_1_point_a, [ratio(affected_clients, clients_using_affected_service, clients_share)], cite(eu_reg_2024_1772_art_9_1)).
condition_point(clients_financial_counterparts_and_transactions_threshold_met, article_9_1_point_b, [limit(affected_clients)], cite(eu_reg_2024_1772_art_9_1)).
condition_point(clients_financial_counterparts_and_transactions_threshold_met, article_9_1_point_c, [ratio(affected_financial_counterparts, financial_counterparts_of_affected_service, counterparts_share)], cite(eu_reg_2024_1772_art_9_1)).
condition_point(clients_financial_counterparts_and_transactions_threshold_met, article_9_1_point_d, [ratio_days(affected_transactions_number, reference_period_transactions_number, reference_period_days, transactions_share)], cite(eu_reg_2024_1772_art_9_1)).
condition_point(clients_financial_counterparts_and_transactions_threshold_met, article_9_1_point_e, [ratio_days(affected_transactions_amount, reference_period_transactions_amount, reference_period_days, transactions_share)], cite(eu_reg_2024_1772_art_9_1)).
condition_point(clients_financial_counterparts_and_transactions_threshold_met, article_9_1_point_f, [judgement(relevant_clients_or_financial_counterparts_affected)], cite(eu_reg_2024_1772_art_9_1)).
condition_point(reputational_impact_threshold_met, article_2_1_point_a, [judgement(incident_reflected_in_media)], cite(eu_reg_2024_1772_art_9_2)).
condition_point(reputational_impact_threshold_met, article_2_1_point_b, [judgement(repetitive_complaints_from_different_clients_or_counterparts)], cite(eu_reg_2024_1772_art_9_2)).
condition_point(reputational_impact_threshold_met, article_2_1_point_c, [judgement(regulatory_requirements_likely_not_met)], cite(eu_reg_2024_1772_art_9_2)).
condition_point(reputational_impact_threshold_met, article_2_1_point_d, [judgement(material_loss_of_clients_or_counterparts_likely)], cite(eu_reg_2024_1772_art_9_2)).
condition_point(duration_and_service_downtime_threshold_met, article_9_3_point_a, [limit(incident_duration_seconds)], cite(eu_reg_2024_1772_art_9_3)).
condition_point(duration_and_service_downtime_threshold_met, article_9_3_point_b, [limit(critical_or_important_function_service_downtime_seconds)], cite(eu_reg_2024_1772_art_9_3)).
condition_point(geographical_spread_threshold_met, article_9_4, [limit(member_states_with_impact)], cite(eu_reg_2024_1772_art_9_4)).
condition_point(data_losses_impact_threshold_met, article_9_5_point_a, [judgement(data_impact_adverse_to_business_objectives_or_regulatory_requirements), any_of([data_availability_impact, data_authenticity_impact, data_integrity_impact, data_confidentiality_impact])], cite(eu_reg_2024_1772_art_9_5_a)).
condition_point(economic_impact_threshold_met, article_9_6_amounts, [sum([expropriated_funds_and_assets_cents, replacement_and_relocation_costs_cents, staff_costs_cents, contractual_non_compliance_fees_cents, redress_and_compensation_costs_cents, forgone_revenue_losses_cents, communication_costs_cents, advisory_costs_cents])], cite(eu_reg_2024_1772_art_9_6)).
condition_point(economic_impact_threshold_met, article_9_6_likely, [judgement(costs_and_losses_likely_to_exceed_threshold)], cite(eu_reg_2024_1772_art_9_6)).

limit_floor(affected_clients, Floor, cite(eu_reg_2024_1772_art_9_1)) :-
    implements(eu_reg_2024_1772_art_9_1),
    Floor #= 100000 + 1.
limit_floor(incident_duration_seconds, Floor, cite(eu_reg_2024_1772_art_9_3)) :-
    implements(eu_reg_2024_1772_art_9_3),
    Floor #= 86400 + 1.
limit_floor(critical_or_important_function_service_downtime_seconds, Floor, cite(eu_reg_2024_1772_art_9_3)) :-
    implements(eu_reg_2024_1772_art_9_3),
    Floor #= 7200 + 1.
limit_floor(member_states_with_impact, Floor, cite(eu_reg_2024_1772_art_9_4)) :-
    implements(eu_reg_2024_1772_art_9_4),
    Floor #= 2.

ratio_percent(clients_share, Percent, cite(eu_reg_2024_1772_art_9_1)) :-
    implements(eu_reg_2024_1772_art_9_1),
    Percent #= 10.
ratio_percent(counterparts_share, Percent, cite(eu_reg_2024_1772_art_9_1)) :-
    implements(eu_reg_2024_1772_art_9_1),
    Percent #= 30.
ratio_percent(transactions_share, Percent, cite(eu_reg_2024_1772_art_9_1)) :-
    implements(eu_reg_2024_1772_art_9_1),
    Percent #= 10.

economic_limit(Limit, cite(eu_reg_2024_1772_art_9_6)) :-
    implements(eu_reg_2024_1772_art_9_6),
    Limit #= 10000000.

final_report_month_citations([cite(eu_reg_2025_301_art_5_1_c)]).

final_report_extension_citations([cite(eu_reg_2025_301_art_5_1_c), cite(eu_reg_2025_301_art_5_4), cite(eu_reg_2025_301_art_5_5), cite(eu_reg_2025_301_art_5_6)]).

dora_incident_threshold_status(Profile, Threshold, Status, Citations) :-
    dora_incident_classification_thresholds_input_problems(Profile, ProfileProblems),
    threshold_argument_problems(Threshold, ArgumentProblems),
    append(ProfileProblems, ArgumentProblems, Problems),
    threshold_answer(Problems, Profile, Threshold, Status, Citations).

threshold_answer([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
threshold_answer([], Profile, Threshold, Status, Citations) :-
    condition_states(Profile, Threshold, States),
    condition_status(Threshold, States, Overall),
    overall_answer(Overall, Threshold, States, Status, Citations).

threshold_argument_problems(Threshold, [wrong_type(threshold)]) :-
    var(Threshold).
threshold_argument_problems(Threshold, Problems) :-
    nonvar(Threshold),
    condition_order(Conditions),
    memberd_t(Threshold, Conditions, Known),
    known_threshold_problems(Known, Problems).

known_threshold_problems(true, []).
known_threshold_problems(false, [wrong_type(threshold)]).

overall_answer(met, Condition, _, met, Citations) :-
    implements(eu_reg_2022_2554_art_18_1),
    condition_citations(Condition, Citations).
overall_answer(closed, Condition, _, not_met, Citations) :-
    implements(eu_reg_2022_2554_art_18_1),
    condition_citations(Condition, Citations).
overall_answer(open, Condition, States, Status, []) :-
    open_keys(Condition, States, absent, Candidates),
    open_answer(Candidates, Condition, States, Status).

open_answer([First|Others], Condition, States, indeterminate([Named])) :-
    first_unblocked([First|Others], [First|Others], Condition, States, Named).
open_answer([], Condition, States, needs_legal_review(open_textured(Unsure, Citation), [inputs_relied_on(Pairs)])) :-
    open_keys(Condition, States, unsure, [Unsure|_]),
    referral_citation(Condition, Citation),
    present_pairs(States, Pairs).

condition_states(Profile, Condition, States) :-
    condition_keys(Condition, KeyList),
    maplist(key_entry(Profile), KeyList, States).

key_entry(Profile, KeyName, KeyName - absent) :-
    profile_lacks(Profile, KeyName).
key_entry(Profile, KeyName, KeyName - given(Value)) :-
    profile_has(Profile, KeyName),
    profile_get(Profile, KeyName, Value).

state_of(States, KeyName, State) :-
    member(KeyName - State, States).

present_pairs([], []).
present_pairs([_ - absent|Remaining], Pairs) :-
    present_pairs(Remaining, Pairs).
present_pairs([KeyName - given(Value)|Remaining], [KeyName - Value|Pairs]) :-
    present_pairs(Remaining, Pairs).

condition_status(Condition, States, Status) :-
    implements(eu_reg_2022_2554_art_18_1),
    findall(Parts, condition_point(Condition, _, Parts, _), PointList),
    maplist(point_status(States), PointList, PointStatuses),
    foldl(any_step, PointStatuses, closed, Status).

point_status(States, Parts, Status) :-
    implements(eu_reg_2022_2554_art_18_1),
    maplist(part_status(States), Parts, PartStatuses),
    foldl(all_step, PartStatuses, met, Status).

any_step(Element, Accumulated, Combined) :-
    any_combine(Accumulated, Element, Combined).

all_step(Element, Accumulated, Combined) :-
    all_combine(Accumulated, Element, Combined).

any_combine(met, _, met).
any_combine(closed, met, met).
any_combine(closed, closed, closed).
any_combine(closed, open, open).
any_combine(open, met, met).
any_combine(open, closed, open).
any_combine(open, open, open).

all_combine(closed, _, closed).
all_combine(met, Element, Element).
all_combine(open, met, open).
all_combine(open, closed, closed).
all_combine(open, open, open).

part_status(States, judgement(KeyName), Status) :-
    implements(eu_reg_2022_2554_art_18_1),
    judgement_key_status(States, KeyName, Status).
part_status(States, any_of(KeyList), Status) :-
    implements(eu_reg_2024_1772_art_9_5_a),
    maplist(judgement_key_status(States), KeyList, KeyStatuses),
    foldl(any_step, KeyStatuses, closed, Status).
part_status(States, limit(KeyName), Status) :-
    implements(eu_reg_2022_2554_art_18_1),
    limit_floor(KeyName, Floor, _),
    state_of(States, KeyName, State),
    limit_state_status(State, Floor, Status).
part_status(States, ratio(AffectedKey, TotalKey, ShareName), Status) :-
    implements(eu_reg_2024_1772_art_9_1),
    ratio_percent(ShareName, Percent, _),
    state_of(States, AffectedKey, AffectedState),
    state_of(States, TotalKey, TotalState),
    ratio_state_status(AffectedState, TotalState, given(1), Percent, Status).
part_status(States, ratio_days(AffectedKey, TotalKey, DaysKey, ShareName), Status) :-
    implements(eu_reg_2024_1772_art_9_1),
    ratio_percent(ShareName, Percent, _),
    state_of(States, AffectedKey, AffectedState),
    state_of(States, TotalKey, TotalState),
    state_of(States, DaysKey, DaysState),
    ratio_state_status(AffectedState, TotalState, DaysState, Percent, Status).
part_status(States, sum(KeyList), Status) :-
    implements(eu_reg_2024_1772_art_7),
    maplist(state_of(States), KeyList, KeyStates),
    sum_given(KeyStates, 0, Total, 0, AbsentCount),
    economic_limit(Limit, _),
    sum_state_status(Total, AbsentCount, Limit, Status).

judgement_key_status(States, KeyName, Status) :-
    state_of(States, KeyName, State),
    judgement_state_status(State, Status).

judgement_state_status(given(true), met).
judgement_state_status(given(false), closed).
judgement_state_status(given(unsure), open).
judgement_state_status(absent, open).

limit_state_status(absent, _, open).
limit_state_status(given(Value), Floor, met) :-
    Value #>= Floor.
limit_state_status(given(Value), Floor, closed) :-
    Value #< Floor.

ratio_state_status(given(0), _, _, _, closed).
ratio_state_status(absent, _, given(0), _, closed).
ratio_state_status(absent, _, absent, _, open).
ratio_state_status(absent, _, given(Days), _, open) :-
    Days #> 0.
ratio_state_status(given(Affected), _, given(0), _, closed) :-
    Affected #> 0.
ratio_state_status(given(Affected), _, absent, _, open) :-
    Affected #> 0.
ratio_state_status(given(Affected), absent, given(Days), _, open) :-
    Affected #> 0,
    Days #> 0.
ratio_state_status(given(Affected), given(Total), given(Days), Percent, met) :-
    Affected #> 0,
    Days #> 0,
    Affected * 100 * Days #> Total * Percent.
ratio_state_status(given(Affected), given(Total), given(Days), Percent, closed) :-
    Affected #> 0,
    Days #> 0,
    Affected * 100 * Days #=< Total * Percent.

sum_given([], Total, Total, Count, Count).
sum_given([given(Value)|Remaining], Running, Total, CountSoFar, Count) :-
    Next #= Running + Value,
    sum_given(Remaining, Next, Total, CountSoFar, Count).
sum_given([absent|Remaining], Running, Total, CountSoFar, Count) :-
    NextCount #= CountSoFar + 1,
    sum_given(Remaining, Running, Total, NextCount, Count).

sum_state_status(Total, _, Limit, met) :-
    Total #> Limit.
sum_state_status(Total, AbsentCount, Limit, closed) :-
    Total #=< Limit,
    AbsentCount #= 0.
sum_state_status(Total, AbsentCount, Limit, open) :-
    Total #=< Limit,
    AbsentCount #> 0.

part_keys(judgement(KeyName), [KeyName]).
part_keys(any_of(KeyList), KeyList).
part_keys(limit(KeyName), [KeyName]).
part_keys(ratio(AffectedKey, TotalKey, _), [AffectedKey, TotalKey]).
part_keys(ratio_days(AffectedKey, TotalKey, DaysKey, _), [AffectedKey, TotalKey, DaysKey]).
part_keys(sum(KeyList), KeyList).

part_kind(judgement(_), judgement).
part_kind(any_of(_), judgement).
part_kind(limit(_), count).
part_kind(ratio(_, _, _), count).
part_kind(ratio_days(_, _, _, _), count).
part_kind(sum(_), count).

open_keys(Condition, States, Wanted, KeyList) :-
    findall(KeyName, open_part_key(Condition, States, Wanted, KeyName), RawKeys),
    condition_keys(Condition, OrderedKeys),
    keep_listed(OrderedKeys, RawKeys, KeyList).

open_part_key(Condition, States, Wanted, KeyName) :-
    condition_point(Condition, _, Parts, _),
    point_status(States, Parts, open),
    member(PartTerm, Parts),
    part_status(States, PartTerm, open),
    part_keys(PartTerm, PartKeys),
    member(KeyName, PartKeys),
    state_of(States, KeyName, State),
    state_kind(State, Wanted).

state_kind(absent, absent).
state_kind(given(Value), unsure) :-
    Value == unsure.
state_kind(given(Value), known) :-
    Value \== unsure.

keep_listed([], _, []).
keep_listed([KeyName|KeyList], RawKeys, Kept) :-
    memberd_t(KeyName, RawKeys, Truth),
    keep_step(Truth, KeyName, KeyList, RawKeys, Kept).

keep_step(true, KeyName, KeyList, RawKeys, [KeyName|Kept]) :-
    keep_listed(KeyList, RawKeys, Kept).
keep_step(false, _, KeyList, RawKeys, Kept) :-
    keep_listed(KeyList, RawKeys, Kept).

can_change_t(Condition, States, KeyName, Truth) :-
    condition_status(Condition, States, Overall),
    changeable_keys(Overall, Condition, States, KeyList),
    memberd_t(KeyName, KeyList, Truth).

changeable_keys(met, _, _, []).
changeable_keys(closed, _, _, []).
changeable_keys(open, Condition, States, KeyList) :-
    open_keys(Condition, States, absent, KeyList).

set_state(States, KeyName, Value, NewStates) :-
    maplist(replace_entry(KeyName, Value), States, NewStates).

replace_entry(KeyName, Value, EntryKey - _, EntryKey - given(Value)) :-
    EntryKey == KeyName.
replace_entry(KeyName, _, EntryKey - State, EntryKey - State) :-
    EntryKey \== KeyName.

behind_t(Condition, States, Behind, Ahead, Truth) :-
    key_values(Condition, States, Behind, BehindValues),
    changes_for_all_t(BehindValues, Condition, States, Behind, Ahead, FirstTruth),
    key_values(Condition, States, Ahead, AheadValues),
    silenced_by_some_t(AheadValues, Condition, States, Ahead, Behind, SecondTruth),
    both_true(FirstTruth, SecondTruth, Truth).

both_true(true, Truth, Truth).
both_true(false, _, false).

changes_for_all_t([], _, _, _, _, true).
changes_for_all_t([Value|Values], Condition, States, Setter, Watched, Truth) :-
    set_state(States, Setter, Value, NewStates),
    can_change_t(Condition, NewStates, Watched, StillChanges),
    changes_rest(StillChanges, Values, Condition, States, Setter, Watched, Truth).

changes_rest(false, _, _, _, _, _, false).
changes_rest(true, Values, Condition, States, Setter, Watched, Truth) :-
    changes_for_all_t(Values, Condition, States, Setter, Watched, Truth).

silenced_by_some_t([], _, _, _, _, false).
silenced_by_some_t([Value|Values], Condition, States, Setter, Watched, Truth) :-
    set_state(States, Setter, Value, NewStates),
    can_change_t(Condition, NewStates, Watched, StillChanges),
    silenced_rest(StillChanges, Values, Condition, States, Setter, Watched, Truth).

silenced_rest(false, _, _, _, _, _, true).
silenced_rest(true, Values, Condition, States, Setter, Watched, Truth) :-
    silenced_by_some_t(Values, Condition, States, Setter, Watched, Truth).

key_values(Condition, States, KeyName, Values) :-
    key_kind(Condition, KeyName, KindName),
    kind_values(KindName, States, Values).

kind_values(judgement, _, [true, false, unsure]).
kind_values(count, States, [0, 1, LargeValue]) :-
    given_integer_total(States, 0, Total),
    LargeValue #= 100 * (Total + 1) * (Total + 1) + 100000000.

given_integer_total([], Total, Total).
given_integer_total([_ - absent|Remaining], Running, Total) :-
    given_integer_total(Remaining, Running, Total).
given_integer_total([_ - given(Value)|Remaining], Running, Total) :-
    integer(Value),
    Next #= Running + Value,
    given_integer_total(Remaining, Next, Total).
given_integer_total([_ - given(Value)|Remaining], Running, Total) :-
    atom(Value),
    given_integer_total(Remaining, Running, Total).

key_kind(Condition, KeyName, KindName) :-
    findall(PartKind, key_part_kind(Condition, KeyName, PartKind), Kinds),
    sort(Kinds, [KindName]).

key_part_kind(Condition, KeyName, PartKind) :-
    condition_point(Condition, _, Parts, _),
    member(PartTerm, Parts),
    part_keys(PartTerm, PartKeys),
    member(KeyName, PartKeys),
    part_kind(PartTerm, PartKind).

first_unblocked([], [Fallback|_], _, _, Fallback).
first_unblocked([KeyName|KeyList], Candidates, Condition, States, Named) :-
    blocked_t(KeyName, Candidates, Condition, States, Blocked),
    first_step(Blocked, KeyName, KeyList, Candidates, Condition, States, Named).

first_step(false, KeyName, _, _, _, _, KeyName).
first_step(true, _, KeyList, Candidates, Condition, States, Named) :-
    first_unblocked(KeyList, Candidates, Condition, States, Named).

blocked_t(_, [], _, _, false).
blocked_t(KeyName, [Other|Others], Condition, States, Truth) :-
    KeyName == Other,
    blocked_t(KeyName, Others, Condition, States, Truth).
blocked_t(KeyName, [Other|Others], Condition, States, Truth) :-
    KeyName \== Other,
    behind_t(Condition, States, KeyName, Other, IsBehind),
    blocked_rest(IsBehind, KeyName, Others, Condition, States, Truth).

blocked_rest(true, _, _, _, _, true).
blocked_rest(false, KeyName, Others, Condition, States, Truth) :-
    blocked_t(KeyName, Others, Condition, States, Truth).

dora_final_report_timeliness(Profile, LatestIntermediateDate, FinalDate, Result, Citations) :-
    dora_incident_classification_thresholds_input_problems(Profile, ProfileProblems),
    date_argument_problems(latest_intermediate_date, LatestIntermediateDate, LatestProblems),
    date_argument_problems(final_date, FinalDate, FinalProblems),
    append(LatestProblems, FinalProblems, ArgumentProblems),
    append(ProfileProblems, ArgumentProblems, Problems),
    timeliness_answer(Problems, Profile, LatestIntermediateDate, FinalDate, Result, Citations).

timeliness_answer([Problem|Problems], _, _, _, input_problems([Problem|Problems]), []).
timeliness_answer([], Profile, LatestIntermediateDate, FinalDate, Result, Citations) :-
    final_report_due(LatestIntermediateDate, DueDate),
    day_number(DueDate, DueNumber),
    day_number(FinalDate, FinalNumber),
    month_answer(FinalNumber, DueNumber, Profile, Result, Citations).

final_report_due(date(YearNumber, Month, DayNumber), date(DueYear, DueMonth, DueDay)) :-
    implements(eu_reg_2025_301_art_5_1_c),
    MonthIndex #= YearNumber * 12 + Month - 1 + 1,
    DueYear #= MonthIndex // 12,
    DueMonth #= MonthIndex - DueYear * 12 + 1,
    month_last_day(DueYear, DueMonth, LastDay),
    DueDay #= min(DayNumber, LastDay).

day_number(date(YearNumber, Month, DayNumber), Ordinal) :-
    Ordinal #= YearNumber * 10000 + Month * 100 + DayNumber.

month_answer(FinalNumber, DueNumber, _, on_time, Citations) :-
    implements(eu_reg_2025_301_art_5_1_c),
    FinalNumber #=< DueNumber,
    final_report_month_citations(Citations).
month_answer(FinalNumber, DueNumber, Profile, Result, Citations) :-
    implements(eu_reg_2025_301_art_5_1_c),
    FinalNumber #> DueNumber,
    weekend_answer(Profile, Result, Citations).

weekend_answer(Profile, indeterminate([final_report_weekend_extension]), []) :-
    profile_lacks(Profile, final_report_weekend_extension).
weekend_answer(Profile, Result, Citations) :-
    implements(eu_reg_2025_301_art_5_4),
    profile_has(Profile, final_report_weekend_extension),
    profile_get(Profile, final_report_weekend_extension, Value),
    extension_result(Value, Result),
    final_report_extension_citations(Citations).

extension_result(true, on_time).
extension_result(false, late(month_limit)).

date_argument_problems(ArgumentName, Term, Problems) :-
    valid_date_t(Term, Valid),
    date_validity_problems(Valid, ArgumentName, Problems).

date_validity_problems(true, _, []).
date_validity_problems(false, ArgumentName, [wrong_type(ArgumentName)]).

valid_date_t(Term, false) :-
    term_variables(Term, [_|_]).
valid_date_t(Term, Truth) :-
    term_variables(Term, []),
    ground_date_t(Term, Truth).

ground_date_t(Term, false) :-
    Term \= date(_, _, _).
ground_date_t(Term, Truth) :-
    Term = date(YearNumber, Month, DayNumber),
    date_part_integer_t(YearNumber, YearInteger),
    date_part_integer_t(Month, MonthInteger),
    date_part_integer_t(DayNumber, DayInteger),
    memberd_t(false, [YearInteger, MonthInteger, DayInteger], HasFalse),
    date_parts_step(HasFalse, YearNumber, Month, DayNumber, Truth).

date_part_integer_t(Value, true) :-
    integer(Value).
date_part_integer_t(Value, false) :-
    float(Value).
date_part_integer_t(Value, false) :-
    atom(Value).
date_part_integer_t(Value, false) :-
    compound(Value).

date_parts_step(true, _, _, _, false).
date_parts_step(false, YearNumber, Month, DayNumber, Truth) :-
    calendar_day_t(YearNumber, Month, DayNumber, Truth).

calendar_day_t(YearNumber, _, _, false) :-
    YearNumber < 1.
calendar_day_t(YearNumber, _, _, false) :-
    YearNumber > 9999.
calendar_day_t(YearNumber, Month, _, false) :-
    YearNumber >= 1,
    YearNumber =< 9999,
    Month < 1.
calendar_day_t(YearNumber, Month, _, false) :-
    YearNumber >= 1,
    YearNumber =< 9999,
    Month > 12.
calendar_day_t(YearNumber, Month, DayNumber, Truth) :-
    YearNumber >= 1,
    YearNumber =< 9999,
    Month >= 1,
    Month =< 12,
    month_last_day(YearNumber, Month, LastDay),
    day_in_month_t(DayNumber, LastDay, Truth).

day_in_month_t(DayNumber, _, false) :-
    DayNumber < 1.
day_in_month_t(DayNumber, LastDay, false) :-
    DayNumber > LastDay.
day_in_month_t(DayNumber, LastDay, true) :-
    DayNumber >= 1,
    DayNumber =< LastDay.

decide_dora_incident_classification_thresholds(Request, dora_incident_classification_thresholds_verdict(Status, Citations)) :-
    nonvar(Request),
    Request = threshold_query(Profile, Threshold),
    dora_incident_threshold_status(Profile, Threshold, Status, Citations).
decide_dora_incident_classification_thresholds(Request, dora_incident_classification_thresholds_verdict(Result, Citations)) :-
    nonvar(Request),
    Request = final_report_query(Profile, LatestIntermediateDate, FinalDate),
    dora_final_report_timeliness(Profile, LatestIntermediateDate, FinalDate, Result, Citations).

dora_incident_classification_thresholds_status(Request, Status) :-
    decide_dora_incident_classification_thresholds(Request, dora_incident_classification_thresholds_verdict(Status, _Citations)).

dora_incident_classification_thresholds_checklist(Profile, Items) :-
    condition_order(Conditions),
    maplist(condition_item(Profile), Conditions, Items).

condition_item(Profile, Condition, item(Condition, Status, Citations)) :-
    dora_incident_threshold_status(Profile, Condition, Status, Citations).

dora_incident_classification_thresholds_decision_resolvable(Request) :-
    decide_dora_incident_classification_thresholds(Request, _Verdict).

test(critical_services_met_by_one_point) :-
    dora_incident_threshold_status([attribute(affects_authorised_registered_or_supervised_financial_services, true)], critical_services_affected, Status, Citations),
    Status == met,
    Citations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_8_1), cite(eu_reg_2024_1772_art_6)].
test(critical_services_not_met_when_all_false) :-
    Profile = [attribute(affects_ict_services_supporting_critical_or_important_functions, false), attribute(affects_authorised_registered_or_supervised_financial_services, false), attribute(successful_malicious_unauthorised_access, false)],
    dora_incident_threshold_status(Profile, critical_services_affected, not_met, _).
test(critical_services_names_first_absent_key) :-
    dora_incident_threshold_status([], critical_services_affected, Status, Citations),
    Status == indeterminate([affects_ict_services_supporting_critical_or_important_functions]),
    Citations == [].
test(critical_services_refers_unsure_judgement_with_pairs_in_root_order) :-
    Profile = [attribute(successful_malicious_unauthorised_access, false), attribute(affects_authorised_registered_or_supervised_financial_services, false), attribute(affects_ict_services_supporting_critical_or_important_functions, unsure)],
    dora_incident_threshold_status(Profile, critical_services_affected, Status, Citations),
    Status == needs_legal_review(open_textured(affects_ict_services_supporting_critical_or_important_functions, cite(eu_reg_2024_1772_art_6)), [inputs_relied_on([affects_ict_services_supporting_critical_or_important_functions - unsure, affects_authorised_registered_or_supervised_financial_services - false, successful_malicious_unauthorised_access - false])]),
    Citations == [].
test(malicious_access_met_when_both_true) :-
    Profile = [attribute(successful_malicious_unauthorised_access, true), attribute(access_may_result_in_data_losses, true)],
    dora_incident_threshold_status(Profile, data_losses_malicious_access_threshold_met, met, _).
test(malicious_access_not_met_when_one_false) :-
    Profile = [attribute(access_may_result_in_data_losses, false)],
    dora_incident_threshold_status(Profile, data_losses_malicious_access_threshold_met, not_met, _).
test(data_losses_impact_names_adverse_judgement_first) :-
    dora_incident_threshold_status([], data_losses_impact_threshold_met, Status, _),
    Status == indeterminate([data_impact_adverse_to_business_objectives_or_regulatory_requirements]).
test(data_losses_impact_names_absent_key_before_referral) :-
    Profile = [attribute(data_impact_adverse_to_business_objectives_or_regulatory_requirements, unsure), attribute(data_availability_impact, unsure)],
    dora_incident_threshold_status(Profile, data_losses_impact_threshold_met, Status, _),
    Status == indeterminate([data_authenticity_impact]).
test(data_losses_impact_met) :-
    Profile = [attribute(data_impact_adverse_to_business_objectives_or_regulatory_requirements, true), attribute(data_integrity_impact, true)],
    dora_incident_threshold_status(Profile, data_losses_impact_threshold_met, met, _).
test(clients_every_key_absent_names_affected_clients) :-
    dora_incident_threshold_status([], clients_financial_counterparts_and_transactions_threshold_met, Status, _),
    Status == indeterminate([affected_clients]).
test(clients_point_f_named_when_affected_clients_zero) :-
    dora_incident_threshold_status([attribute(affected_clients, 0)], clients_financial_counterparts_and_transactions_threshold_met, Status, _),
    Status == indeterminate([relevant_clients_or_financial_counterparts_affected]).
test(clients_days_named_before_transaction_figures) :-
    Profile = [attribute(affected_clients, 0), attribute(relevant_clients_or_financial_counterparts_affected, false), attribute(affected_financial_counterparts, 0)],
    dora_incident_threshold_status(Profile, clients_financial_counterparts_and_transactions_threshold_met, Status, _),
    Status == indeterminate([reference_period_days]).
test(clients_limit_met) :-
    dora_incident_threshold_status([attribute(affected_clients, 100001)], clients_financial_counterparts_and_transactions_threshold_met, met, Citations),
    Citations == [cite(eu_reg_2022_2554_art_18_1), cite(eu_reg_2024_1772_art_9_1), cite(eu_reg_2024_1772_art_1)].
test(clients_ratio_above_ten_percent_met) :-
    Profile = [attribute(affected_clients, 11), attribute(clients_using_affected_service, 100)],
    dora_incident_threshold_status(Profile, clients_financial_counterparts_and_transactions_threshold_met, met, _).
test(clients_exactly_ten_percent_not_met) :-
    Profile = [attribute(affected_clients, 10), attribute(clients_using_affected_service, 100), attribute(affected_financial_counterparts, 0), attribute(affected_transactions_number, 0), attribute(affected_transactions_amount, 0), attribute(relevant_clients_or_financial_counterparts_affected, false)],
    dora_incident_threshold_status(Profile, clients_financial_counterparts_and_transactions_threshold_met, not_met, _).
test(clients_zero_days_close_transaction_points) :-
    Profile = [attribute(affected_clients, 0), attribute(affected_financial_counterparts, 0), attribute(reference_period_days, 0), attribute(relevant_clients_or_financial_counterparts_affected, false)],
    dora_incident_threshold_status(Profile, clients_financial_counterparts_and_transactions_threshold_met, not_met, _).
test(clients_daily_average_met) :-
    Profile = [attribute(affected_clients, 0), attribute(affected_financial_counterparts, 0), attribute(relevant_clients_or_financial_counterparts_affected, false), attribute(affected_transactions_number, 11), attribute(reference_period_transactions_number, 3000), attribute(reference_period_days, 30)],
    dora_incident_threshold_status(Profile, clients_financial_counterparts_and_transactions_threshold_met, met, _).
test(reputational_one_criterion_met) :-
    dora_incident_threshold_status([attribute(incident_reflected_in_media, true)], reputational_impact_threshold_met, met, _).
test(duration_longer_than_a_day_met) :-
    dora_incident_threshold_status([attribute(incident_duration_seconds, 86401)], duration_and_service_downtime_threshold_met, met, _).
test(duration_at_the_limits_not_met) :-
    Profile = [attribute(incident_duration_seconds, 86400), attribute(critical_or_important_function_service_downtime_seconds, 7200)],
    dora_incident_threshold_status(Profile, duration_and_service_downtime_threshold_met, not_met, _).
test(duration_names_absent_downtime) :-
    dora_incident_threshold_status([attribute(incident_duration_seconds, 100)], duration_and_service_downtime_threshold_met, Status, _),
    Status == indeterminate([critical_or_important_function_service_downtime_seconds]).
test(geographical_two_member_states_met) :-
    dora_incident_threshold_status([attribute(member_states_with_impact, 2)], geographical_spread_threshold_met, met, _).
test(geographical_one_member_state_not_met) :-
    dora_incident_threshold_status([attribute(member_states_with_impact, 1)], geographical_spread_threshold_met, not_met, _).
test(economic_single_amount_met) :-
    dora_incident_threshold_status([attribute(staff_costs_cents, 10000001)], economic_impact_threshold_met, met, _).
test(economic_names_first_amount) :-
    dora_incident_threshold_status([], economic_impact_threshold_met, Status, _),
    Status == indeterminate([expropriated_funds_and_assets_cents]).
test(economic_exactly_at_threshold_not_met) :-
    Profile = [attribute(expropriated_funds_and_assets_cents, 0), attribute(replacement_and_relocation_costs_cents, 0), attribute(staff_costs_cents, 0), attribute(contractual_non_compliance_fees_cents, 0), attribute(redress_and_compensation_costs_cents, 0), attribute(forgone_revenue_losses_cents, 0), attribute(communication_costs_cents, 0), attribute(advisory_costs_cents, 10000000), attribute(costs_and_losses_likely_to_exceed_threshold, false)],
    dora_incident_threshold_status(Profile, economic_impact_threshold_met, not_met, _).
test(economic_refers_likely_judgement) :-
    Profile = [attribute(expropriated_funds_and_assets_cents, 0), attribute(replacement_and_relocation_costs_cents, 0), attribute(staff_costs_cents, 0), attribute(contractual_non_compliance_fees_cents, 0), attribute(redress_and_compensation_costs_cents, 0), attribute(forgone_revenue_losses_cents, 0), attribute(communication_costs_cents, 0), attribute(advisory_costs_cents, 10000000), attribute(costs_and_losses_likely_to_exceed_threshold, unsure)],
    dora_incident_threshold_status(Profile, economic_impact_threshold_met, Status, []),
    Status == needs_legal_review(open_textured(costs_and_losses_likely_to_exceed_threshold, cite(eu_reg_2024_1772_art_9_6)), [inputs_relied_on([expropriated_funds_and_assets_cents - 0, replacement_and_relocation_costs_cents - 0, staff_costs_cents - 0, contractual_non_compliance_fees_cents - 0, redress_and_compensation_costs_cents - 0, forgone_revenue_losses_cents - 0, communication_costs_cents - 0, advisory_costs_cents - 10000000, costs_and_losses_likely_to_exceed_threshold - unsure])]).
test(wrong_threshold_is_an_input_problem) :-
    dora_incident_threshold_status([], major_incident, Status, []),
    Status == input_problems([wrong_type(threshold)]).
test(unknown_key_is_an_input_problem) :-
    dora_incident_threshold_status([attribute(colour, blue)], geographical_spread_threshold_met, Status, []),
    Status == input_problems([unknown_key(colour)]).
test(threshold_query_has_exactly_one_solution) :-
    findall(Status, dora_incident_threshold_status([attribute(affected_clients, 0)], clients_financial_counterparts_and_transactions_threshold_met, Status, _), Statuses),
    length(Statuses, 1).
test(final_report_on_the_last_day_of_february) :-
    dora_final_report_timeliness([], date(2025, 1, 31), date(2025, 2, 28), Result, Citations),
    Result == on_time,
    Citations == [cite(eu_reg_2025_301_art_5_1_c)].
test(final_report_leap_year_due_date) :-
    dora_final_report_timeliness([], date(2024, 1, 31), date(2024, 2, 29), on_time, _).
test(final_report_after_due_needs_weekend_key) :-
    dora_final_report_timeliness([], date(2025, 1, 31), date(2025, 3, 1), Result, []),
    Result == indeterminate([final_report_weekend_extension]).
test(final_report_late_without_extension) :-
    dora_final_report_timeliness([attribute(final_report_weekend_extension, false)], date(2025, 1, 31), date(2025, 3, 1), Result, Citations),
    Result == late(month_limit),
    Citations == [cite(eu_reg_2025_301_art_5_1_c), cite(eu_reg_2025_301_art_5_4), cite(eu_reg_2025_301_art_5_5), cite(eu_reg_2025_301_art_5_6)].
test(final_report_on_time_with_extension) :-
    dora_final_report_timeliness([attribute(final_report_weekend_extension, true)], date(2025, 12, 15), date(2026, 1, 16), on_time, _).
test(final_report_invalid_dates_are_input_problems) :-
    FloatYear is float(2024),
    dora_final_report_timeliness([], date(2025, 2, 29), date(FloatYear, 1, 1), Result, []),
    Result == input_problems([wrong_type(latest_intermediate_date), wrong_type(final_date)]).
test(checklist_has_one_row_per_condition) :-
    dora_incident_classification_thresholds_checklist([], Items),
    length(Items, 8).
test(facade_decides_a_threshold_query) :-
    decide_dora_incident_classification_thresholds(threshold_query([attribute(member_states_with_impact, 3)], geographical_spread_threshold_met), dora_incident_classification_thresholds_verdict(met, _)).

test(critical_services_met_is_not_not_met, fail) :-
    dora_incident_threshold_status([attribute(affects_authorised_registered_or_supervised_financial_services, true)], critical_services_affected, not_met, _).
test(final_report_late_is_not_on_time, fail) :-
    dora_final_report_timeliness([attribute(final_report_weekend_extension, false)], date(2025, 1, 31), date(2025, 3, 1), on_time, _).
