% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [information_duty_verdict/3, information_outside_facts/2, decide_information_duty_verdict/2, information_duty_verdict_status/2, information_duty_verdict_checklist/2, information_duty_verdict_decision_resolvable/1, information_duty_verdict_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [tfilter/3]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_kernel, [gdpr_information_duties_headline_verdict_input_problems/2, contract_keys/1, key_status/3, attested_status/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_exemption, [decide_information_duty_exemption/2]).

information_duty_verdict_status_values([eligible, ineligible]).

judgement_keys([automated_decision_making_under_article_22, provided_within_reasonable_period, provision_impossible_or_disproportionate_effort, paragraph_2_information_relevant_to_further_processing]).

route_item(art13, controller_identity_and_contact_details, cite(eu_reg_2016_679_art_13_1_a), unconditional, paragraph_1).
route_item(art13, data_protection_officer_contact_details, cite(eu_reg_2016_679_art_13_1_b), condition(data_protection_officer_designated), paragraph_1).
route_item(art13, purposes_and_legal_basis, cite(eu_reg_2016_679_art_13_1_c), unconditional, paragraph_1).
route_item(art13, legitimate_interests, cite(eu_reg_2016_679_art_13_1_d), condition(processing_based_on_legitimate_interests), paragraph_1).
route_item(art13, recipients_or_categories_of_recipients, cite(eu_reg_2016_679_art_13_1_e), condition(recipients_exist), paragraph_1).
route_item(art13, third_country_transfer_information, cite(eu_reg_2016_679_art_13_1_f), condition(transfer_intended), paragraph_1).
route_item(art13, storage_period_or_criteria, cite(eu_reg_2016_679_art_13_2_a), unconditional, paragraph_2).
route_item(art13, data_subject_rights, cite(eu_reg_2016_679_art_13_2_b), unconditional, paragraph_2).
route_item(art13, right_to_withdraw_consent, cite(eu_reg_2016_679_art_13_2_c), condition(processing_based_on_consent), paragraph_2).
route_item(art13, right_to_lodge_complaint, cite(eu_reg_2016_679_art_13_2_d), unconditional, paragraph_2).
route_item(art13, statutory_or_contractual_requirement, cite(eu_reg_2016_679_art_13_2_e), unconditional, paragraph_2).
route_item(art13, automated_decision_making_information, cite(eu_reg_2016_679_art_13_2_f), condition(automated_decision_making_under_article_22), paragraph_2).
route_item(art14, controller_identity_and_contact_details, cite(eu_reg_2016_679_art_14_1_a), unconditional, paragraph_1).
route_item(art14, data_protection_officer_contact_details, cite(eu_reg_2016_679_art_14_1_b), condition(data_protection_officer_designated), paragraph_1).
route_item(art14, purposes_and_legal_basis, cite(eu_reg_2016_679_art_14_1_c), unconditional, paragraph_1).
route_item(art14, legitimate_interests, cite(eu_reg_2016_679_art_14_2_b), condition(processing_based_on_legitimate_interests), paragraph_2).
route_item(art14, recipients_or_categories_of_recipients, cite(eu_reg_2016_679_art_14_1_e), condition(recipients_exist), paragraph_1).
route_item(art14, third_country_transfer_information, cite(eu_reg_2016_679_art_14_1_f), condition(transfer_intended), paragraph_1).
route_item(art14, categories_of_personal_data, cite(eu_reg_2016_679_art_14_1_d), unconditional, paragraph_1).
route_item(art14, storage_period_or_criteria, cite(eu_reg_2016_679_art_14_2_a), unconditional, paragraph_2).
route_item(art14, data_subject_rights, cite(eu_reg_2016_679_art_14_2_c), unconditional, paragraph_2).
route_item(art14, right_to_withdraw_consent, cite(eu_reg_2016_679_art_14_2_d), condition(processing_based_on_consent), paragraph_2).
route_item(art14, right_to_lodge_complaint, cite(eu_reg_2016_679_art_14_2_e), unconditional, paragraph_2).
route_item(art14, source_of_personal_data, cite(eu_reg_2016_679_art_14_2_f), unconditional, paragraph_2).
route_item(art14, automated_decision_making_information, cite(eu_reg_2016_679_art_14_2_g), condition(automated_decision_making_under_article_22), paragraph_2).

basis_citation(art14_3_a, cite(eu_reg_2016_679_art_14_3_a)).
basis_citation(art14_3_b, cite(eu_reg_2016_679_art_14_3_b)).
basis_citation(art14_3_c, cite(eu_reg_2016_679_art_14_3_c)).

checklist_citation(art13, items_missing, cite(eu_reg_2016_679_art_13_1)).
checklist_citation(art13, timing, cite(eu_reg_2016_679_art_13_1)).
checklist_citation(art13, further_processing, cite(eu_reg_2016_679_art_13_3)).
checklist_citation(art14, items_missing, cite(eu_reg_2016_679_art_14_1)).
checklist_citation(art14, timing, cite(eu_reg_2016_679_art_14_3)).
checklist_citation(art14, further_processing, cite(eu_reg_2016_679_art_14_4)).

information_duty_verdict(Profile, Verdict, Citations) :-
    decide_information_duty_verdict(Profile, information_duty_verdict_result(Verdict, Citations)).

information_outside_facts(Profile, OutsideFacts) :-
    gdpr_information_duties_headline_verdict_input_problems(Profile, Problems),
    outside_facts_checked(Problems, Profile, OutsideFacts).

outside_facts_checked([Problem|Problems], _, input_problems([Problem|Problems])).
outside_facts_checked([], Profile, [LawFact, SecrecyFact, HolidayFact]) :-
    outside_fact_entry(Profile, obtaining_or_disclosure_laid_down_by_law, LawFact),
    outside_fact_entry(Profile, professional_secrecy_obligation_by_law, SecrecyFact),
    outside_fact_entry(Profile, public_holidays, HolidayFact).

outside_fact_entry(Profile, FactKey, Entry) :-
    key_status(Profile, FactKey, Status),
    outside_fact_from(Status, FactKey, Entry).

outside_fact_from(value(AttestedTerm), FactKey, outside_fact(FactKey, AttestedTerm)).
outside_fact_from(unknown(_), FactKey, outside_fact(FactKey, absent)).

decide_information_duty_verdict(Profile, Result) :-
    gdpr_information_duties_headline_verdict_input_problems(Profile, Problems),
    verdict_checked(Problems, Profile, Result).

verdict_checked([Problem|Problems], _, information_duty_verdict_result(input_problems([Problem|Problems]), [])).
verdict_checked([], Profile, Result) :-
    key_status(Profile, personal_data_collected_from_data_subject, RouteStatus),
    verdict_by_route(RouteStatus, Profile, Result).

verdict_by_route(value(true), Profile, Result) :-
    implements(eu_reg_2016_679_art_13_1),
    base_for(Profile, art13, BaseStatus),
    article_13_headline(BaseStatus, Profile, Result).
verdict_by_route(value(false), Profile, Result) :-
    implements(eu_reg_2016_679_art_14_1),
    base_for(Profile, art14, BaseStatus),
    article_14_headline(BaseStatus, Profile, Result).
verdict_by_route(unknown(RouteKeys), Profile, information_duty_verdict_result(indeterminate(MissingKeys), [])) :-
    implements(eu_reg_2016_679_art_14_1),
    base_for(Profile, art13, ThirteenBase),
    base_for(Profile, art14, FourteenBase),
    route_unknown_keys(ThirteenBase, FourteenBase, RouteKeys, MissingKeys).

route_unknown_keys(base(ThirteenOutcome, _, ThirteenAbsent, _, _), base(FourteenOutcome, _, FourteenAbsent, _, _), RouteKeys, MissingKeys) :-
    outcome_pair(ThirteenOutcome, FourteenOutcome, PairKind),
    keys_for_pair(PairKind, ThirteenAbsent, FourteenAbsent, RouteKeys, MissingKeys).

outcome_pair(unmet, unmet, both_unmet).
outcome_pair(unmet, met, otherwise).
outcome_pair(unmet, open, otherwise).
outcome_pair(met, _, otherwise).
outcome_pair(open, _, otherwise).

keys_for_pair(both_unmet, _, _, RouteKeys, RouteKeys).
keys_for_pair(otherwise, ThirteenAbsent, FourteenAbsent, RouteKeys, MissingKeys) :-
    tfilter(in_set_t(FourteenAbsent), ThirteenAbsent, CommonKeys),
    append(RouteKeys, CommonKeys, AllKeys),
    contract_order(AllKeys, MissingKeys).

article_13_headline(base(met, Citations, _, _, _), _, information_duty_verdict_result(eligible, [cite(eu_reg_2016_679_art_13_1)|Citations])) :-
    implements(eu_reg_2016_679_art_13_1).
article_13_headline(base(unmet, Citations, _, _, _), _, information_duty_verdict_result(ineligible, Citations)) :-
    implements(eu_reg_2016_679_art_13_1).
article_13_headline(base(open, _, Absent, Unsure, Read), Profile, Result) :-
    implements(eu_reg_2016_679_art_13_1),
    stage_four(Absent, [], Unsure, Read, Profile, Result).

article_14_headline(base(met, Citations, _, _, _), _, information_duty_verdict_result(eligible, [cite(eu_reg_2016_679_art_14_1)|Citations])) :-
    implements(eu_reg_2016_679_art_14_1).
article_14_headline(base(unmet, Citations, _, _, _), Profile, Result) :-
    implements(eu_reg_2016_679_art_14_5),
    exemption_class_for(Profile, ExemptionClass, ExemptionCitations),
    stage_three(ExemptionClass, ExemptionCitations, Citations, Result).
article_14_headline(base(open, _, Absent, Unsure, Read), Profile, Result) :-
    implements(eu_reg_2016_679_art_14_5),
    exemption_class_for(Profile, ExemptionClass, ExemptionCitations),
    open_stage(ExemptionClass, ExemptionCitations, Absent, Unsure, Read, Profile, Result).

exemption_class_for(Profile, ExemptionClass, ExemptionCitations) :-
    decide_information_duty_exemption(Profile, information_duty_exemption_result(Exemption, ExemptionCitations)),
    exemption_class(Exemption, ExemptionClass).

exemption_class(none, none).
exemption_class(impossible_or_disproportionate_effort, exempt).
exemption_class(law_lays_down_obtaining_or_disclosure, exempt).
exemption_class(professional_secrecy_obligation, exempt).
exemption_class(indeterminate(MissingKeys), missing_keys(MissingKeys)).
exemption_class(needs_legal_review(Reason, Context), review(Reason, Context)).

stage_three(exempt, ExemptionCitations, _, information_duty_verdict_result(eligible, ExemptionCitations)).
stage_three(none, _, Citations, information_duty_verdict_result(ineligible, Citations)).
stage_three(missing_keys(MissingKeys), _, _, information_duty_verdict_result(indeterminate(MissingKeys), [])).
stage_three(review(Reason, Context), _, _, information_duty_verdict_result(needs_legal_review(Reason, Context), [])).

open_stage(exempt, ExemptionCitations, _, _, _, _, information_duty_verdict_result(eligible, ExemptionCitations)).
open_stage(none, _, Absent, Unsure, Read, Profile, Result) :-
    stage_four(Absent, [], Unsure, Read, Profile, Result).
open_stage(missing_keys(MissingKeys), _, Absent, Unsure, Read, Profile, Result) :-
    stage_four(Absent, MissingKeys, Unsure, Read, Profile, Result).
open_stage(review(_, _), _, Absent, Unsure, Read, Profile, Result) :-
    stage_four(Absent, [], Unsure, Read, Profile, Result).

stage_four(BaseAbsent, ExemptionKeys, Unsure, Read, Profile, Result) :-
    append(BaseAbsent, ExemptionKeys, AllKeys),
    contract_order(AllKeys, MissingKeys),
    stage_four_keys(MissingKeys, Unsure, Read, Profile, Result).

stage_four_keys([FirstKey|OtherKeys], _, _, _, information_duty_verdict_result(indeterminate([FirstKey|OtherKeys]), [])).
stage_four_keys([], Unsure, Read, Profile, information_duty_verdict_result(needs_legal_review(open_textured(JudgementKey, Citation), [inputs_relied_on(Pairs)]), [])) :-
    first_referral(Unsure, JudgementKey, Citation),
    judgement_pairs(Profile, Read, Pairs).

first_referral(Unsure, JudgementKey, Citation) :-
    findall(ReferralKey, member(referral(ReferralKey, _), Unsure), ReferralKeys),
    contract_order(ReferralKeys, [JudgementKey|_]),
    sort(Unsure, UniqueReferrals),
    member(referral(JudgementKey, Citation), UniqueReferrals).

judgement_pairs(Profile, Read, Pairs) :-
    judgement_keys(JudgementKeys),
    tfilter(in_set_t(Read), JudgementKeys, ReadJudgements),
    pairs_present(ReadJudgements, Profile, Pairs).

pairs_present([], _, []).
pairs_present([JudgementKey|Rest], Profile, Pairs) :-
    key_status(Profile, JudgementKey, Status),
    pairs_present(Rest, Profile, RestPairs),
    add_pair(Status, JudgementKey, RestPairs, Pairs).

add_pair(value(Value), JudgementKey, RestPairs, [JudgementKey - Value|RestPairs]).
add_pair(unknown(_), _, RestPairs, RestPairs).

base_for(Profile, Route, BaseStatus) :-
    items_missing_component(Profile, Route, ItemsComponent),
    timing_component(Profile, Route, TimingComponent),
    further_processing_component(Profile, Route, FurtherComponent),
    combine_base(ItemsComponent, TimingComponent, FurtherComponent, BaseStatus).

combine_base(component(ItemsOutcome, ItemsCitations, ItemsAbsent, ItemsUnsure, ItemsRead), component(TimingOutcome, TimingCitations, TimingAbsent, TimingUnsure, TimingRead), component(FurtherOutcome, FurtherCitations, FurtherAbsent, FurtherUnsure, FurtherRead), base(Outcome, Citations, Absent, Unsure, Read)) :-
    conjunction_outcome(ItemsOutcome, TimingOutcome, FirstOutcome),
    conjunction_outcome(FirstOutcome, FurtherOutcome, Outcome),
    open_part(ItemsOutcome, ItemsAbsent, ItemsOpenAbsent),
    open_part(TimingOutcome, TimingAbsent, TimingOpenAbsent),
    open_part(FurtherOutcome, FurtherAbsent, FurtherOpenAbsent),
    append([ItemsOpenAbsent, TimingOpenAbsent, FurtherOpenAbsent], Absent),
    open_part(ItemsOutcome, ItemsUnsure, ItemsOpenUnsure),
    open_part(TimingOutcome, TimingUnsure, TimingOpenUnsure),
    open_part(FurtherOutcome, FurtherUnsure, FurtherOpenUnsure),
    append([ItemsOpenUnsure, TimingOpenUnsure, FurtherOpenUnsure], Unsure),
    append([ItemsRead, TimingRead, FurtherRead], Read),
    unmet_part(ItemsOutcome, ItemsCitations, ItemsUnmetCitations),
    unmet_part(TimingOutcome, TimingCitations, TimingUnmetCitations),
    unmet_part(FurtherOutcome, FurtherCitations, FurtherUnmetCitations),
    append([ItemsUnmetCitations, TimingUnmetCitations, FurtherUnmetCitations], UnmetCitations),
    base_citations(Outcome, UnmetCitations, FurtherCitations, Citations).

conjunction_outcome(unmet, _, unmet).
conjunction_outcome(met, Outcome, Outcome).
conjunction_outcome(open, unmet, unmet).
conjunction_outcome(open, met, open).
conjunction_outcome(open, open, open).

open_part(open, Values, Values).
open_part(met, _, []).
open_part(unmet, _, []).

unmet_part(unmet, Values, Values).
unmet_part(met, _, []).
unmet_part(open, _, []).

base_citations(unmet, UnmetCitations, _, UnmetCitations).
base_citations(met, _, FurtherCitations, FurtherCitations).
base_citations(open, _, _, []).

items_missing_component(Profile, art13, Component) :-
    implements(eu_reg_2016_679_art_13_1),
    items_missing_for(Profile, art13, Component).
items_missing_component(Profile, art14, Component) :-
    implements(eu_reg_2016_679_art_14_1),
    items_missing_for(Profile, art14, Component).

items_missing_for(Profile, Route, Component) :-
    implements(eu_reg_2016_679_art_4_1),
    implements(eu_reg_2016_679_art_4_7),
    key_status(Profile, items_provided, ProvidedStatus),
    key_status(Profile, items_data_subject_already_has, AlreadyStatus),
    findall(row(ItemName, Citation, Condition), route_item(Route, ItemName, Citation, Condition, _), ItemRows),
    maplist(initial_item_outcome(Profile, ProvidedStatus, AlreadyStatus), ItemRows, Outcomes),
    outcomes_component(Outcomes, Component).

initial_item_outcome(Profile, ProvidedStatus, AlreadyStatus, row(ItemName, Citation, Condition), Outcome) :-
    implements(eu_reg_2016_679_art_13_4),
    implements(eu_reg_2016_679_art_14_5_a),
    item_coverage(ItemName, ProvidedStatus, AlreadyStatus, Coverage),
    condition_owed(Profile, Condition, Owed),
    item_outcome(Coverage, Owed, Citation, Condition, Outcome).

item_coverage(ItemName, ProvidedStatus, AlreadyStatus, Coverage) :-
    list_holding(ProvidedStatus, ItemName, ProvidedHolding),
    list_holding(AlreadyStatus, ItemName, AlreadyHolding),
    coverage_of(ProvidedHolding, AlreadyHolding, Coverage).

list_holding(value(ItemList), ItemName, Holding) :-
    memberd_t(ItemName, ItemList, Truth),
    holding_of(Truth, Holding).
list_holding(unknown(AbsentKeys), _, unknown(AbsentKeys)).

holding_of(true, held).
holding_of(false, not_held).

coverage_of(held, _, covered).
coverage_of(not_held, held, covered).
coverage_of(unknown(_), held, covered).
coverage_of(not_held, not_held, uncovered).
coverage_of(not_held, unknown(AbsentKeys), open(AbsentKeys)).
coverage_of(unknown(AbsentKeys), not_held, open(AbsentKeys)).
coverage_of(unknown(FirstKeys), unknown(SecondKeys), open(AbsentKeys)) :-
    append(FirstKeys, SecondKeys, AbsentKeys).

condition_owed(_, unconditional, owed).
condition_owed(Profile, condition(ConditionKey), Owed) :-
    implements(eu_reg_2016_679_art_4_9),
    implements(eu_reg_2016_679_art_4_4),
    key_status(Profile, ConditionKey, Status),
    owed_from_status(Status, ConditionKey, Owed).

owed_from_status(value(true), _, owed).
owed_from_status(value(false), _, not_owed).
owed_from_status(value(unsure), ConditionKey, unsure(ConditionKey)).
owed_from_status(unknown(AbsentKeys), _, absent(AbsentKeys)).

item_outcome(covered, _, _, _, outcome(nothing, [])).
item_outcome(uncovered, Owed, Citation, Condition, outcome(Kind, Read)) :-
    condition_keys(Condition, Read),
    uncovered_kind(Owed, Citation, Kind).
item_outcome(open(AbsentKeys), Owed, Citation, Condition, outcome(Kind, Read)) :-
    condition_keys(Condition, Read),
    open_coverage_kind(Owed, AbsentKeys, Citation, Kind).

uncovered_kind(owed, Citation, missing(Citation)).
uncovered_kind(not_owed, _, nothing).
uncovered_kind(unsure(ConditionKey), Citation, open([], [referral(ConditionKey, Citation)])).
uncovered_kind(absent(AbsentKeys), _, open(AbsentKeys, [])).

open_coverage_kind(owed, AbsentKeys, _, open(AbsentKeys, [])).
open_coverage_kind(not_owed, _, _, nothing).
open_coverage_kind(unsure(ConditionKey), AbsentKeys, Citation, open(AbsentKeys, [referral(ConditionKey, Citation)])).
open_coverage_kind(absent(ConditionAbsent), AbsentKeys, _, open(AllKeys, [])) :-
    append(AbsentKeys, ConditionAbsent, AllKeys).

condition_keys(unconditional, []).
condition_keys(condition(ConditionKey), [ConditionKey]).

outcomes_component(Outcomes, component(Outcome, MissingCitations, Absent, Unsure, Read)) :-
    findall(Citation, member(outcome(missing(Citation), _), Outcomes), MissingCitations),
    findall(open_item, member(outcome(open(_, _), _), Outcomes), OpenMarkers),
    findall(AbsentKey, (member(outcome(open(OpenAbsent, _), _), Outcomes), member(AbsentKey, OpenAbsent)), Absent),
    findall(Referral, (member(outcome(open(_, OpenUnsure), _), Outcomes), member(Referral, OpenUnsure)), Unsure),
    findall(ReadKey, (member(outcome(_, ItemRead), Outcomes), member(ReadKey, ItemRead)), Read),
    outcome_from(MissingCitations, OpenMarkers, Outcome).

outcome_from([_|_], _, unmet).
outcome_from([], [_|_], open).
outcome_from([], [], met).

timing_component(Profile, art13, Component) :-
    implements(eu_reg_2016_679_art_13_1),
    key_status(Profile, obtaining_date, ObtainingStatus),
    key_status(Profile, provision_date, ProvisionStatus),
    article_13_timing(ObtainingStatus, ProvisionStatus, Component).
timing_component(Profile, art14, Component) :-
    implements(eu_reg_2016_679_art_14_3),
    key_status(Profile, obtaining_date, ObtainingStatus),
    key_status(Profile, provision_date, ProvisionStatus),
    attested_status(Profile, public_holidays, HolidayStatus),
    holiday_list(HolidayStatus, Holidays),
    article_14_timing(ObtainingStatus, ProvisionStatus, Holidays, Profile, Component).

holiday_list(absent, []).
holiday_list(value(Holidays), Holidays).

article_13_timing(value(ObtainingDate), value(ProvisionDate), Component) :-
    date_order(ProvisionDate, ObtainingDate, Order),
    article_13_timing_order(Order, Component).
article_13_timing(unknown(ObtainingKeys), value(_), component(open, [], ObtainingKeys, [], [])).
article_13_timing(value(_), unknown(ProvisionKeys), component(open, [], ProvisionKeys, [], [])).
article_13_timing(unknown(ObtainingKeys), unknown(ProvisionKeys), component(open, [], AbsentKeys, [], [])) :-
    append(ObtainingKeys, ProvisionKeys, AbsentKeys).

article_13_timing_order(<, component(met, [], [], [], [])) :-
    implements(eu_reg_2016_679_art_13_1).
article_13_timing_order(=, component(met, [], [], [], [])) :-
    implements(eu_reg_2016_679_art_13_1).
article_13_timing_order(>, component(unmet, [cite(eu_reg_2016_679_art_13_1)], [], [], [])) :-
    implements(eu_reg_2016_679_art_13_1).

article_14_timing(value(ObtainingDate), value(ProvisionDate), Holidays, Profile, Component) :-
    limb_a_date(ObtainingDate, Holidays, LimbADate),
    later_limbs(Profile, LaterCandidates, LimbAbsent),
    article_14_settled(LimbAbsent, ProvisionDate, LimbADate, LaterCandidates, Profile, Component).
article_14_timing(unknown(ObtainingKeys), value(_), _, Profile, Component) :-
    article_14_absent_dates(ObtainingKeys, Profile, Component).
article_14_timing(value(_), unknown(ProvisionKeys), _, Profile, Component) :-
    article_14_absent_dates(ProvisionKeys, Profile, Component).
article_14_timing(unknown(ObtainingKeys), unknown(ProvisionKeys), _, Profile, Component) :-
    append(ObtainingKeys, ProvisionKeys, DateKeys),
    article_14_absent_dates(DateKeys, Profile, Component).

article_14_absent_dates(DateKeys, Profile, component(open, [], AbsentKeys, [], [])) :-
    later_limbs(Profile, _, LimbAbsent),
    append(DateKeys, LimbAbsent, AbsentKeys).

article_14_settled([], ProvisionDate, LimbADate, LaterCandidates, Profile, Component) :-
    earliest_deadline([limb(art14_3_a, LimbADate)|LaterCandidates], limb(Basis, DeadlineDate)),
    date_order(ProvisionDate, DeadlineDate, Order),
    article_14_against_deadline(Order, Basis, Profile, Component).
article_14_settled([AbsentKey|AbsentKeys], ProvisionDate, LimbADate, _, _, Component) :-
    date_order(ProvisionDate, LimbADate, Order),
    article_14_against_limb_a_only(Order, [AbsentKey|AbsentKeys], Component).

article_14_against_limb_a_only(>, _, component(unmet, [cite(eu_reg_2016_679_art_14_3_a)], [], [], [])) :-
    implements(eu_reg_2016_679_art_14_3_a).
article_14_against_limb_a_only(<, AbsentKeys, component(open, [], AbsentKeys, [], [])).
article_14_against_limb_a_only(=, AbsentKeys, component(open, [], AbsentKeys, [], [])).

article_14_against_deadline(>, Basis, _, component(unmet, [Citation], [], [], [])) :-
    implements(eu_reg_2016_679_art_14_3),
    basis_citation(Basis, Citation).
article_14_against_deadline(<, _, Profile, Component) :-
    implements(eu_reg_2016_679_art_14_3_a),
    key_status(Profile, provided_within_reasonable_period, Status),
    reasonable_period(Status, Component).
article_14_against_deadline(=, _, Profile, Component) :-
    implements(eu_reg_2016_679_art_14_3_a),
    key_status(Profile, provided_within_reasonable_period, Status),
    reasonable_period(Status, Component).

reasonable_period(value(true), component(met, [], [], [], [provided_within_reasonable_period])) :-
    implements(eu_reg_2016_679_art_14_3_a).
reasonable_period(value(false), component(unmet, [cite(eu_reg_2016_679_art_14_3_a)], [], [], [provided_within_reasonable_period])) :-
    implements(eu_reg_2016_679_art_14_3_a).
reasonable_period(value(unsure), component(open, [], [], [referral(provided_within_reasonable_period, cite(eu_reg_2016_679_art_14_3_a))], [provided_within_reasonable_period])) :-
    implements(eu_reg_2016_679_art_14_3_a).
reasonable_period(unknown(AbsentKeys), component(open, [], AbsentKeys, [], [])) :-
    implements(eu_reg_2016_679_art_14_3_a).

later_limbs(Profile, Candidates, AbsentKeys) :-
    key_status(Profile, data_used_for_communication_with_data_subject, CommunicationStatus),
    limb_candidate(CommunicationStatus, Profile, first_communication_date, art14_3_b, CommunicationCandidates, CommunicationAbsent),
    key_status(Profile, disclosure_to_another_recipient_envisaged, DisclosureStatus),
    limb_candidate(DisclosureStatus, Profile, first_disclosure_date, art14_3_c, DisclosureCandidates, DisclosureAbsent),
    append(CommunicationCandidates, DisclosureCandidates, Candidates),
    append(CommunicationAbsent, DisclosureAbsent, AbsentKeys).

limb_candidate(value(true), Profile, DateKey, Basis, Candidates, AbsentKeys) :-
    implements(eu_reg_2016_679_art_14_3),
    key_status(Profile, DateKey, DateStatus),
    limb_date_candidate(DateStatus, Basis, Candidates, AbsentKeys).
limb_candidate(value(false), _, _, _, [], []) :-
    implements(eu_reg_2016_679_art_14_3).
limb_candidate(unknown(AbsentKeys), _, _, _, [], AbsentKeys).

limb_date_candidate(value(EventDate), Basis, [limb(Basis, EventDate)], []).
limb_date_candidate(unknown(AbsentKeys), _, [], AbsentKeys).

earliest_deadline([FirstLimb|OtherLimbs], BestLimb) :-
    implements(eu_reg_2016_679_art_14_3),
    earliest_from(OtherLimbs, FirstLimb, BestLimb).

earliest_from([], BestLimb, BestLimb).
earliest_from([limb(Basis, LimbDate)|OtherLimbs], limb(CurrentBasis, CurrentDate), BestLimb) :-
    date_order(LimbDate, CurrentDate, Order),
    keep_earlier(Order, limb(Basis, LimbDate), limb(CurrentBasis, CurrentDate), NextLimb),
    earliest_from(OtherLimbs, NextLimb, BestLimb).

keep_earlier(<, NewLimb, _, NewLimb).
keep_earlier(=, _, CurrentLimb, CurrentLimb).
keep_earlier(>, _, CurrentLimb, CurrentLimb).

limb_a_date(date(YearNumber, Month, DayNumber), Holidays, DeadlineDate) :-
    implements(eu_reg_1971_1182_art_3),
    implements(eu_reg_1971_1182_art_3_2_c),
    implements(eu_reg_1971_1182_art_3_1),
    following_month(Month, NextMonth, YearIncrement),
    NextYear is YearNumber + YearIncrement,
    month_length(NextYear, NextMonth, MonthLength),
    capped_day(DayNumber, MonthLength, CappedDay),
    shift_to_working_day(date(NextYear, NextMonth, CappedDay), Holidays, DeadlineDate).

capped_day(DayNumber, MonthLength, CappedDay) :-
    compare(Order, DayNumber, MonthLength),
    cap_by_order(Order, DayNumber, MonthLength, CappedDay).

cap_by_order(<, DayNumber, _, DayNumber).
cap_by_order(=, DayNumber, _, DayNumber).
cap_by_order(>, _, MonthLength, MonthLength).

shift_to_working_day(CalendarDate, Holidays, FinalDate) :-
    implements(eu_reg_1971_1182_art_3_4),
    day_kind(CalendarDate, Holidays, Kind),
    shift_by_kind(Kind, CalendarDate, Holidays, FinalDate).

shift_by_kind(working_day, CalendarDate, _, CalendarDate).
shift_by_kind(non_working_day, CalendarDate, Holidays, FinalDate) :-
    next_calendar_day(CalendarDate, NextDate),
    shift_to_working_day(NextDate, Holidays, FinalDate).

day_kind(CalendarDate, Holidays, Kind) :-
    implements(eu_reg_1971_1182_art_2_2),
    weekday_number(CalendarDate, Weekday),
    weekday_class(Weekday, WeekdayClass),
    memberd_t(CalendarDate, Holidays, IsHoliday),
    kind_of_day(WeekdayClass, IsHoliday, Kind).

kind_of_day(weekend, _, non_working_day).
kind_of_day(weekday, true, non_working_day).
kind_of_day(weekday, false, working_day).

weekday_number(date(YearNumber, Month, DayNumber), Weekday) :-
    month_weekday_offset(Month, Offset, YearShift),
    ShiftedYear is YearNumber - YearShift,
    Total is ShiftedYear + ShiftedYear // 4 - ShiftedYear // 100 + ShiftedYear // 400 + Offset + DayNumber,
    Weekday is Total mod 7.

month_weekday_offset(1, 0, 1).
month_weekday_offset(2, 3, 1).
month_weekday_offset(3, 2, 0).
month_weekday_offset(4, 5, 0).
month_weekday_offset(5, 0, 0).
month_weekday_offset(6, 3, 0).
month_weekday_offset(7, 5, 0).
month_weekday_offset(8, 1, 0).
month_weekday_offset(9, 4, 0).
month_weekday_offset(10, 6, 0).
month_weekday_offset(11, 2, 0).
month_weekday_offset(12, 4, 0).

weekday_class(0, weekend).
weekday_class(1, weekday).
weekday_class(2, weekday).
weekday_class(3, weekday).
weekday_class(4, weekday).
weekday_class(5, weekday).
weekday_class(6, weekend).

next_calendar_day(date(YearNumber, Month, DayNumber), NextDate) :-
    month_length(YearNumber, Month, MonthLength),
    compare(Order, DayNumber, MonthLength),
    next_day_by_order(Order, YearNumber, Month, DayNumber, NextDate).

next_day_by_order(<, YearNumber, Month, DayNumber, date(YearNumber, Month, NextDay)) :-
    NextDay is DayNumber + 1.
next_day_by_order(=, YearNumber, Month, _, date(NextYear, NextMonth, 1)) :-
    following_month(Month, NextMonth, YearIncrement),
    NextYear is YearNumber + YearIncrement.

following_month(1, 2, 0).
following_month(2, 3, 0).
following_month(3, 4, 0).
following_month(4, 5, 0).
following_month(5, 6, 0).
following_month(6, 7, 0).
following_month(7, 8, 0).
following_month(8, 9, 0).
following_month(9, 10, 0).
following_month(10, 11, 0).
following_month(11, 12, 0).
following_month(12, 1, 1).

month_length(_, 1, 31).
month_length(YearNumber, 2, MonthLength) :-
    leap_year(YearNumber, IsLeapYear),
    february_length(IsLeapYear, MonthLength).
month_length(_, 3, 31).
month_length(_, 4, 30).
month_length(_, 5, 31).
month_length(_, 6, 30).
month_length(_, 7, 31).
month_length(_, 8, 31).
month_length(_, 9, 30).
month_length(_, 10, 31).
month_length(_, 11, 30).
month_length(_, 12, 31).

february_length(true, 29).
february_length(false, 28).

leap_year(YearNumber, IsLeapYear) :-
    FourYearRemainder is YearNumber mod 4,
    CenturyRemainder is YearNumber mod 100,
    FourCenturyRemainder is YearNumber mod 400,
    gregorian_leap_year(FourYearRemainder, CenturyRemainder, FourCenturyRemainder, IsLeapYear).

gregorian_leap_year(_, _, 0, true).
gregorian_leap_year(0, CenturyRemainder, _, true) :-
    CenturyRemainder =\= 0.
gregorian_leap_year(_, 0, FourCenturyRemainder, false) :-
    FourCenturyRemainder =\= 0.
gregorian_leap_year(FourYearRemainder, _, _, false) :-
    FourYearRemainder =\= 0.

date_order(date(FirstYear, FirstMonth, FirstDay), date(SecondYear, SecondMonth, SecondDay), Order) :-
    compare(YearOrder, FirstYear, SecondYear),
    compare(MonthOrder, FirstMonth, SecondMonth),
    compare(DayOrder, FirstDay, SecondDay),
    lexical_order(YearOrder, MonthOrder, DayOrder, Order).

lexical_order(<, _, _, <).
lexical_order(>, _, _, >).
lexical_order(=, <, _, <).
lexical_order(=, >, _, >).
lexical_order(=, =, Order, Order).

further_processing_component(Profile, Route, Component) :-
    key_status(Profile, further_processing_for_another_purpose_intended, IntentStatus),
    further_processing_by_intent(IntentStatus, Profile, Route, Component).

further_processing_by_intent(unknown(AbsentKeys), _, _, component(open, [], AbsentKeys, [], [])).
further_processing_by_intent(value(false), _, _, component(met, [], [], [], [])).
further_processing_by_intent(value(true), Profile, Route, Component) :-
    further_processing_intended(Profile, Route, Component).

further_processing_intended(Profile, art13, Component) :-
    implements(eu_reg_2016_679_art_13_3),
    implements(eu_reg_2016_679_art_13_2),
    further_processing_for(Profile, art13, cite(eu_reg_2016_679_art_13_3), Component).
further_processing_intended(Profile, art14, Component) :-
    implements(eu_reg_2016_679_art_14_4),
    implements(eu_reg_2016_679_art_14_2),
    further_processing_for(Profile, art14, cite(eu_reg_2016_679_art_14_4), Component).

further_processing_for(Profile, Route, FurtherCitation, component(Outcome, Citations, Absent, Unsure, [paragraph_2_information_relevant_to_further_processing|Read])) :-
    key_status(Profile, further_processing_start_date, StartStatus),
    key_status(Profile, further_processing_information_date, InformationStatus),
    prior_outcome(StartStatus, InformationStatus, PriorOutcome),
    key_status(Profile, further_processing_items_provided, FurtherProvidedStatus),
    key_status(Profile, items_data_subject_already_has, AlreadyStatus),
    key_status(Profile, paragraph_2_information_relevant_to_further_processing, RelevanceStatus),
    item_coverage(other_purpose_information, FurtherProvidedStatus, AlreadyStatus, OtherCoverage),
    item_outcome(OtherCoverage, owed, FurtherCitation, unconditional, OtherOutcome),
    findall(row(ItemName, ItemCitation, Condition), route_item(Route, ItemName, ItemCitation, Condition, paragraph_2), ItemRows),
    maplist(paragraph_2_item_outcome(Profile, FurtherProvidedStatus, AlreadyStatus, RelevanceStatus, FurtherCitation), ItemRows, ParagraphTwoOutcomes),
    outcomes_component([PriorOutcome, OtherOutcome|ParagraphTwoOutcomes], component(Outcome, _, Absent, Unsure, Read)),
    further_citations(Outcome, FurtherCitation, Citations).

prior_outcome(value(StartDate), value(InformationDate), outcome(Kind, [])) :-
    implements(eu_reg_2016_679_art_13_3),
    date_order(InformationDate, StartDate, Order),
    prior_kind(Order, Kind).
prior_outcome(unknown(StartKeys), value(_), outcome(open(StartKeys, []), [])).
prior_outcome(value(_), unknown(InformationKeys), outcome(open(InformationKeys, []), [])).
prior_outcome(unknown(StartKeys), unknown(InformationKeys), outcome(open(AbsentKeys, []), [])) :-
    append(StartKeys, InformationKeys, AbsentKeys).

prior_kind(<, nothing).
prior_kind(=, missing(not_prior)).
prior_kind(>, missing(not_prior)).

paragraph_2_item_outcome(Profile, FurtherProvidedStatus, AlreadyStatus, RelevanceStatus, FurtherCitation, row(ItemName, ItemCitation, Condition), Outcome) :-
    implements(eu_reg_2016_679_art_13_4),
    item_coverage(ItemName, FurtherProvidedStatus, AlreadyStatus, Coverage),
    condition_owed(Profile, Condition, Owed),
    item_outcome(Coverage, Owed, ItemCitation, Condition, outcome(Kind, Read)),
    relevance_outcome(RelevanceStatus, FurtherCitation, Kind, Read, Outcome).

relevance_outcome(value(true), _, Kind, Read, outcome(Kind, Read)).
relevance_outcome(value(false), _, _, _, outcome(nothing, [])).
relevance_outcome(value(unsure), FurtherCitation, Kind, Read, outcome(UnsureKind, Read)) :-
    unsure_relevance_kind(Kind, FurtherCitation, UnsureKind).
relevance_outcome(unknown(RelevanceKeys), _, Kind, Read, outcome(AbsentKind, Read)) :-
    absent_relevance_kind(Kind, RelevanceKeys, AbsentKind).

unsure_relevance_kind(nothing, _, nothing).
unsure_relevance_kind(missing(_), FurtherCitation, open([], [referral(paragraph_2_information_relevant_to_further_processing, FurtherCitation)])).
unsure_relevance_kind(open(AbsentKeys, Unsure), FurtherCitation, open(AbsentKeys, [referral(paragraph_2_information_relevant_to_further_processing, FurtherCitation)|Unsure])).

absent_relevance_kind(nothing, _, nothing).
absent_relevance_kind(missing(_), RelevanceKeys, open(RelevanceKeys, [])).
absent_relevance_kind(open(AbsentKeys, Unsure), RelevanceKeys, open(AllKeys, Unsure)) :-
    append(RelevanceKeys, AbsentKeys, AllKeys).

further_citations(met, FurtherCitation, [FurtherCitation]).
further_citations(unmet, FurtherCitation, [FurtherCitation]).
further_citations(open, _, []).

contract_order(Keys, OrderedKeys) :-
    contract_keys(ContractKeys),
    tfilter(in_set_t(Keys), ContractKeys, OrderedKeys).

in_set_t(KeySet, Element, Truth) :-
    memberd_t(Element, KeySet, Truth).

information_duty_verdict_status(Profile, Status) :-
    decide_information_duty_verdict(Profile, information_duty_verdict_result(Status, _Citations)).

information_duty_verdict_checklist(Profile, Items) :-
    gdpr_information_duties_headline_verdict_input_problems(Profile, Problems),
    checklist_checked(Problems, Profile, Items).

checklist_checked([Problem|Problems], _, [item(information_duty, unmet(input_problems([Problem|Problems])), cite(eu_reg_2016_679_art_13_1))]).
checklist_checked([], Profile, Items) :-
    key_status(Profile, personal_data_collected_from_data_subject, RouteStatus),
    checklist_by_route(RouteStatus, Profile, Items).

checklist_by_route(unknown(RouteKeys), _, [item(items_missing, unknown(RouteKeys), ItemsCitation), item(timing, unknown(RouteKeys), TimingCitation), item(further_processing, unknown(RouteKeys), FurtherCitation)]) :-
    checklist_citation(art13, items_missing, ItemsCitation),
    checklist_citation(art13, timing, TimingCitation),
    checklist_citation(art13, further_processing, FurtherCitation).
checklist_by_route(value(true), Profile, Items) :-
    component_rows(Profile, art13, Items).
checklist_by_route(value(false), Profile, Items) :-
    component_rows(Profile, art14, Items).

component_rows(Profile, Route, [item(items_missing, ItemsStatus, ItemsCitation), item(timing, TimingStatus, TimingCitation), item(further_processing, FurtherStatus, FurtherCitation)]) :-
    items_missing_component(Profile, Route, ItemsComponent),
    timing_component(Profile, Route, TimingComponent),
    further_processing_component(Profile, Route, FurtherComponent),
    row_status(ItemsComponent, ItemsStatus),
    row_status(TimingComponent, TimingStatus),
    row_status(FurtherComponent, FurtherStatus),
    checklist_citation(Route, items_missing, ItemsCitation),
    checklist_citation(Route, timing, TimingCitation),
    checklist_citation(Route, further_processing, FurtherCitation).

row_status(component(met, _, _, _, _), met).
row_status(component(unmet, Citations, _, _, _), unmet(Citations)).
row_status(component(open, _, Absent, Unsure, _), unknown(OrderedKeys)) :-
    findall(ReferralKey, member(referral(ReferralKey, _), Unsure), ReferralKeys),
    append(Absent, ReferralKeys, AllKeys),
    contract_order(AllKeys, OrderedKeys).

information_duty_verdict_decision_resolvable(Profile) :-
    decide_information_duty_verdict(Profile, _Result).

article_13_complete_items([controller_identity_and_contact_details, purposes_and_legal_basis, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint, statutory_or_contractual_requirement]).

article_13_profile(ItemsProvided, Decision, ProvisionDate, [attribute(personal_data_collected_from_data_subject, true), attribute(items_provided, ItemsProvided), attribute(items_data_subject_already_has, []), attribute(data_protection_officer_designated, false), attribute(processing_based_on_legitimate_interests, false), attribute(recipients_exist, false), attribute(transfer_intended, false), attribute(processing_based_on_consent, false), attribute(automated_decision_making_under_article_22, Decision), attribute(obtaining_date, date(2026, 3, 2)), attribute(provision_date, ProvisionDate), attribute(further_processing_for_another_purpose_intended, false)]).

article_13_further_profile(InformationDate, [attribute(personal_data_collected_from_data_subject, true), attribute(items_provided, [controller_identity_and_contact_details, purposes_and_legal_basis, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint, statutory_or_contractual_requirement]), attribute(items_data_subject_already_has, []), attribute(data_protection_officer_designated, false), attribute(processing_based_on_legitimate_interests, false), attribute(recipients_exist, false), attribute(transfer_intended, false), attribute(processing_based_on_consent, false), attribute(automated_decision_making_under_article_22, false), attribute(obtaining_date, date(2026, 3, 2)), attribute(provision_date, date(2026, 3, 2)), attribute(further_processing_for_another_purpose_intended, true), attribute(further_processing_start_date, date(2026, 4, 10)), attribute(further_processing_information_date, InformationDate), attribute(further_processing_items_provided, [other_purpose_information]), attribute(paragraph_2_information_relevant_to_further_processing, false)]).

article_14_profile(ProvisionDate, ExtraAttributes, Profile) :-
    append([attribute(personal_data_collected_from_data_subject, false), attribute(items_provided, [controller_identity_and_contact_details, purposes_and_legal_basis, categories_of_personal_data, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint, source_of_personal_data]), attribute(items_data_subject_already_has, []), attribute(data_protection_officer_designated, false), attribute(processing_based_on_legitimate_interests, false), attribute(recipients_exist, false), attribute(transfer_intended, false), attribute(processing_based_on_consent, false), attribute(automated_decision_making_under_article_22, false), attribute(obtaining_date, date(2026, 1, 15)), attribute(provision_date, ProvisionDate), attribute(further_processing_for_another_purpose_intended, false), attribute(provision_impossible_or_disproportionate_effort, false)], ExtraAttributes, Profile).

test(one_month_from_a_sunday_moves_to_monday) :-
    limb_a_date(date(2026, 1, 15), [], date(2026, 2, 16)).
test(one_month_from_january_31_caps_and_shifts) :-
    limb_a_date(date(2026, 1, 31), [], date(2026, 3, 2)).
test(one_month_in_a_leap_year) :-
    limb_a_date(date(2028, 1, 31), [], date(2028, 2, 29)).
test(one_month_caps_to_april_30) :-
    limb_a_date(date(2026, 3, 31), [], date(2026, 4, 30)).
test(an_attested_holiday_shifts_once_more) :-
    limb_a_date(date(2026, 12, 31), [date(2027, 2, 1)], date(2027, 2, 2)).
test(article_13_complete_is_eligible) :-
    article_13_complete_items(Items),
    article_13_profile(Items, false, date(2026, 3, 2), Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_13_1)]).
test(article_13_complete_has_one_answer) :-
    article_13_complete_items(Items),
    article_13_profile(Items, false, date(2026, 3, 2), Profile),
    findall(Verdict - Citations, information_duty_verdict(Profile, Verdict, Citations), Answers),
    length(Answers, 1).
test(article_13_missing_item_is_ineligible) :-
    article_13_profile([controller_identity_and_contact_details, purposes_and_legal_basis, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint], false, date(2026, 3, 2), Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_13_2_e)]).
test(article_13_late_is_ineligible) :-
    article_13_complete_items(Items),
    article_13_profile(Items, false, date(2026, 3, 3), Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_13_1)]).
test(article_13_unsure_automated_decision_refers) :-
    article_13_complete_items(Items),
    article_13_profile(Items, unsure, date(2026, 3, 2), Profile),
    information_duty_verdict(Profile, needs_legal_review(open_textured(automated_decision_making_under_article_22, cite(eu_reg_2016_679_art_13_2_f)), [inputs_relied_on([automated_decision_making_under_article_22 - unsure])]), []).
test(further_processing_same_day_is_not_prior) :-
    article_13_further_profile(date(2026, 4, 10), Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_13_3)]).
test(further_processing_day_before_is_eligible) :-
    article_13_further_profile(date(2026, 4, 9), Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_13_1), cite(eu_reg_2016_679_art_13_3)]).
test(article_14_after_limb_a_is_late_whatever_the_absent_flags) :-
    article_14_profile(date(2026, 2, 17), [], Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
test(article_14_on_the_last_day_is_eligible) :-
    article_14_profile(date(2026, 2, 16), [attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, true)], Profile),
    information_duty_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_1)]).
test(article_14_first_communication_binds) :-
    article_14_profile(date(2026, 1, 25), [attribute(data_used_for_communication_with_data_subject, true), attribute(first_communication_date, date(2026, 1, 20)), attribute(disclosure_to_another_recipient_envisaged, false)], Profile),
    information_duty_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_14_3_b)]).
test(article_14_unsure_reasonable_period_refers) :-
    article_14_profile(date(2026, 2, 16), [attribute(data_used_for_communication_with_data_subject, false), attribute(disclosure_to_another_recipient_envisaged, false), attribute(provided_within_reasonable_period, unsure)], Profile),
    information_duty_verdict(Profile, needs_legal_review(open_textured(provided_within_reasonable_period, cite(eu_reg_2016_679_art_14_3_a)), [inputs_relied_on([automated_decision_making_under_article_22 - false, provided_within_reasonable_period - unsure])]), []).
test(article_14_exemption_settles_an_unmet_base) :-
    information_duty_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(items_provided, []), attribute(items_data_subject_already_has, []), attribute(provision_impossible_or_disproportionate_effort, true), attribute(protective_measures_taken, true)], eligible, [cite(eu_reg_2016_679_art_14_5_b)]).
test(article_14_unsure_exemption_refers_at_stage_three) :-
    information_duty_verdict([attribute(personal_data_collected_from_data_subject, false), attribute(items_provided, []), attribute(items_data_subject_already_has, []), attribute(provision_impossible_or_disproportionate_effort, unsure), attribute(protective_measures_taken, true)], needs_legal_review(open_textured(provision_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)), [inputs_relied_on([provision_impossible_or_disproportionate_effort - unsure])]), []).
test(article_14_open_base_lists_every_absent_key) :-
    information_duty_verdict([attribute(personal_data_collected_from_data_subject, false)], indeterminate([items_provided, items_data_subject_already_has, data_protection_officer_designated, processing_based_on_legitimate_interests, recipients_exist, transfer_intended, processing_based_on_consent, automated_decision_making_under_article_22, obtaining_date, provision_date, data_used_for_communication_with_data_subject, disclosure_to_another_recipient_envisaged, provision_impossible_or_disproportionate_effort, protective_measures_taken, further_processing_for_another_purpose_intended]), []).
test(route_unknown_names_the_keys_of_both_routes) :-
    information_duty_verdict([], indeterminate([personal_data_collected_from_data_subject, items_provided, items_data_subject_already_has, data_protection_officer_designated, processing_based_on_legitimate_interests, recipients_exist, transfer_intended, processing_based_on_consent, automated_decision_making_under_article_22, obtaining_date, provision_date, further_processing_for_another_purpose_intended]), []).
test(input_problems_come_first) :-
    information_duty_verdict([attribute(colour, red)], input_problems([unknown_key(colour)]), []).
test(not_a_profile_is_an_input_problem) :-
    information_duty_verdict(foo, input_problems([wrong_type(profile)]), []).
test(outside_facts_report_absent_and_attested) :-
    information_outside_facts([attribute(public_holidays, attested([], attestation(by, at, reason, none)))], [outside_fact(obtaining_or_disclosure_laid_down_by_law, absent), outside_fact(professional_secrecy_obligation_by_law, absent), outside_fact(public_holidays, attested([], attestation(by, at, reason, none)))]).
test(outside_facts_with_input_problems) :-
    information_outside_facts(foo, input_problems([wrong_type(profile)])).
test(status_projection) :-
    article_13_complete_items(Items),
    article_13_profile(Items, false, date(2026, 3, 3), Profile),
    information_duty_verdict_status(Profile, ineligible).
test(checklist_has_three_rows) :-
    article_13_complete_items(Items),
    article_13_profile(Items, false, date(2026, 3, 2), Profile),
    information_duty_verdict_checklist(Profile, [item(items_missing, met, cite(eu_reg_2016_679_art_13_1)), item(timing, met, cite(eu_reg_2016_679_art_13_1)), item(further_processing, met, cite(eu_reg_2016_679_art_13_3))]).
test(every_profile_resolves) :-
    information_duty_verdict_decision_resolvable([]).

test(article_13_complete_is_not_ineligible, fail) :-
    article_13_complete_items(Items),
    article_13_profile(Items, false, date(2026, 3, 2), Profile),
    information_duty_verdict(Profile, ineligible, _).
