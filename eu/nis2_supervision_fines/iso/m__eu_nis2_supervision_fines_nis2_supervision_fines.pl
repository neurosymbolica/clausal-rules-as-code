% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_nis2_supervision_fines, [fine_ceiling_floor/3, minimum_powers/2, escalation_powers_exercisable/3, fine_barred_by_gdpr_fine/3, data_protection_authority_information/2, exercisable/0, fine_barred/0, fine_not_barred/0, no_union_minimum/0, fixed_amount/0, turnover_percentage/0, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, minimum_national_maximum/2, power/3, not_exercisable/1, inform_gdpr_supervisory_authorities/1, inform_supervisory_authority_in_own_member_state/1, decide_nis2_supervision_fines/2, nis2_supervision_fines_status/2, nis2_supervision_fines_checklist/2, nis2_supervision_fines_decision_resolvable/1, nis2_supervision_fines_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2, is_list/1]).
:- use_module(library(clpz)).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_nis2_supervision_fines_kernel, [nis2_supervision_fines_input_problems/2, nis2_supervision_fines_pairs/3, nis2_supervision_fines_missing_in_order/3]).
:- use_module(m__eu_nis2_supervision_fines_citations, [implements/1]).

fine_floor_citation(essential, cite(eu_dir_2022_2555_art_34_4)).
fine_floor_citation(important, cite(eu_dir_2022_2555_art_34_5)).

infringement_with_union_floor(art_21, cite(eu_dir_2022_2555_art_34_4)).
infringement_with_union_floor(art_23, cite(eu_dir_2022_2555_art_34_4)).

nis2_supervision_fines_status_values([eligible, ineligible]).

listed_power(important, supervision, on_site_inspections_and_off_site_ex_post_supervision, cite(eu_dir_2022_2555_art_33_2_a)).
listed_power(important, supervision, targeted_security_audits, cite(eu_dir_2022_2555_art_33_2_b)).
listed_power(important, supervision, security_scans, cite(eu_dir_2022_2555_art_33_2_c)).
listed_power(important, supervision, information_requests, cite(eu_dir_2022_2555_art_33_2_d)).
listed_power(important, supervision, data_access_requests, cite(eu_dir_2022_2555_art_33_2_e)).
listed_power(important, supervision, implementation_evidence_requests, cite(eu_dir_2022_2555_art_33_2_f)).
listed_power(important, enforcement, warnings, cite(eu_dir_2022_2555_art_33_4_a)).
listed_power(important, enforcement, binding_instructions_or_remedy_orders, cite(eu_dir_2022_2555_art_33_4_b)).
listed_power(important, enforcement, cease_and_desist_orders, cite(eu_dir_2022_2555_art_33_4_c)).
listed_power(important, enforcement, compliance_orders, cite(eu_dir_2022_2555_art_33_4_d)).
listed_power(important, enforcement, inform_affected_persons_orders, cite(eu_dir_2022_2555_art_33_4_e)).
listed_power(important, enforcement, audit_recommendation_orders, cite(eu_dir_2022_2555_art_33_4_f)).
listed_power(important, enforcement, publication_orders, cite(eu_dir_2022_2555_art_33_4_g)).
listed_power(important, enforcement, administrative_fine, cite(eu_dir_2022_2555_art_33_4_h)).
listed_power(essential, supervision, on_site_inspections_and_off_site_supervision, cite(eu_dir_2022_2555_art_32_2_a)).
listed_power(essential, supervision, regular_and_targeted_security_audits, cite(eu_dir_2022_2555_art_32_2_b)).
listed_power(essential, supervision, ad_hoc_audits, cite(eu_dir_2022_2555_art_32_2_c)).
listed_power(essential, supervision, security_scans, cite(eu_dir_2022_2555_art_32_2_d)).
listed_power(essential, supervision, information_requests, cite(eu_dir_2022_2555_art_32_2_e)).
listed_power(essential, supervision, data_access_requests, cite(eu_dir_2022_2555_art_32_2_f)).
listed_power(essential, supervision, implementation_evidence_requests, cite(eu_dir_2022_2555_art_32_2_g)).
listed_power(essential, enforcement, warnings, cite(eu_dir_2022_2555_art_32_4_a)).
listed_power(essential, enforcement, binding_instructions_or_remedy_orders, cite(eu_dir_2022_2555_art_32_4_b)).
listed_power(essential, enforcement, cease_and_desist_orders, cite(eu_dir_2022_2555_art_32_4_c)).
listed_power(essential, enforcement, compliance_orders, cite(eu_dir_2022_2555_art_32_4_d)).
listed_power(essential, enforcement, inform_affected_persons_orders, cite(eu_dir_2022_2555_art_32_4_e)).
listed_power(essential, enforcement, audit_recommendation_orders, cite(eu_dir_2022_2555_art_32_4_f)).
listed_power(essential, enforcement, monitoring_officer, cite(eu_dir_2022_2555_art_32_4_g)).
listed_power(essential, enforcement, publication_orders, cite(eu_dir_2022_2555_art_32_4_h)).
listed_power(essential, enforcement, administrative_fine, cite(eu_dir_2022_2555_art_32_4_i)).

escalation_power(escalation, suspend_certification_or_authorisation, cite(eu_dir_2022_2555_art_32_5_a)).
escalation_power(escalation, request_temporary_management_ban, cite(eu_dir_2022_2555_art_32_5_b)).

escalation_condition(not_public_administration_entity, entity_is_public_administration, true, public_administration_entity).
escalation_condition(earlier_measures_found_ineffective, earlier_measures_ineffective, false, measures_not_ineffective).
escalation_condition(deadline_set, deadline_set_for_necessary_action, false, no_deadline_set).
escalation_condition(action_not_taken_within_deadline, required_action_taken_within_deadline, true, action_taken_within_deadline).

data_protection_fine_bar_condition(infringement_may_entail_notifiable_personal_data_breach, false, no_notifiable_personal_data_breach).
data_protection_fine_bar_condition(gdpr_fine_imposed_under_art_58_2_i, false, no_data_protection_fine_imposed).
data_protection_fine_bar_condition(gdpr_fine_for_same_conduct, false, not_same_conduct).

data_protection_fine_bar_referral(infringement_may_entail_notifiable_personal_data_breach, cite(eu_dir_2022_2555_art_35_1)).
data_protection_fine_bar_referral(gdpr_fine_for_same_conduct, cite(eu_dir_2022_2555_art_35_2)).

information_condition(infringement_may_entail_notifiable_personal_data_breach, false, no_notifiable_personal_data_breach).
information_condition(authority_became_aware_in_supervision_or_enforcement, false, not_aware_in_supervision_or_enforcement).

exercisable.

fine_barred.

fine_not_barred.

no_union_minimum.

fixed_amount.

turnover_percentage.

indeterminate([_|_]).

needs_legal_review(open_textured(_, cite(_)), [_|_]).

open_textured(_, cite(_)).

inputs_relied_on(Pairs) :-
    is_list(Pairs).

provenance(_, Citations) :-
    is_list(Citations).

input_problems([_|_]).

unknown_key(Key) :-
    atom(Key).

wrong_type(Key) :-
    atom(Key).

duplicate_key(Key) :-
    atom(Key).

minimum_national_maximum(AmountEur, fixed_amount) :-
    integer(AmountEur).
minimum_national_maximum(AmountEur, turnover_percentage) :-
    integer(AmountEur).

power(supervision, Measure, cite(Key)) :-
    atom(Measure),
    atom(Key).
power(enforcement, Measure, cite(Key)) :-
    atom(Measure),
    atom(Key).
power(escalation, Measure, cite(Key)) :-
    atom(Measure),
    atom(Key).

not_exercisable(important_entity).
not_exercisable(public_administration_entity).
not_exercisable(measures_not_ineffective).
not_exercisable(no_deadline_set).
not_exercisable(action_taken_within_deadline).

inform_gdpr_supervisory_authorities(cite(_)).

inform_supervisory_authority_in_own_member_state(cite(_)).

key_state(Profile, Key, present(Value)) :-
    profile_get(Profile, Key, Value).
key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).

condition_states(Profile, Conditions, States) :-
    maplist(condition_state_of(Profile), Conditions, States).

condition_state_of(Profile, condition(Key, FailingValue, Reason), State) :-
    key_state(Profile, Key, KeyState),
    condition_state(KeyState, Key, FailingValue, Reason, State).

condition_state(absent, Key, _, _, missing(Key)).
condition_state(present(FailingValue), _, FailingValue, Reason, fails(Reason)).
condition_state(present(unsure), Key, _, _, open(Key)).
condition_state(present(Value), _, FailingValue, _, holds) :-
    dif(Value, FailingValue),
    dif(Value, unsure).

resolve_conditions(States, failure(Reason)) :-
    first_failure(States, failure(Reason)).
resolve_conditions(States, Outcome) :-
    first_failure(States, none),
    findall(Key, member(missing(Key), States), MissingKeys),
    missing_outcome(MissingKeys, States, Outcome).

first_failure([], none).
first_failure([fails(Reason)|_], failure(Reason)).
first_failure([State|States], Result) :-
    non_failing(State),
    first_failure(States, Result).

non_failing(holds).
non_failing(missing(_)).
non_failing(open(_)).

missing_outcome([MissingKey|MissingKeys], _, missing([MissingKey|MissingKeys])).
missing_outcome([], States, Outcome) :-
    findall(Key, member(open(Key), States), OpenKeys),
    open_outcome(OpenKeys, Outcome).

open_outcome([Key|_], open(Key)).
open_outcome([], all_hold).

fine_ceiling_floor(Profile, input_problems([Problem|Problems]), []) :-
    nis2_supervision_fines_input_problems(Profile, [Problem|Problems]).
fine_ceiling_floor(Profile, Ceiling, Citations) :-
    nis2_supervision_fines_input_problems(Profile, []),
    key_state(Profile, infringed_provision, ProvisionState),
    ceiling_by_provision(ProvisionState, Profile, Ceiling, Citations).

ceiling_by_provision(absent, _, indeterminate([infringed_provision]), []).
ceiling_by_provision(present(other), _, no_union_minimum, [cite(eu_dir_2022_2555_art_34_4), cite(eu_dir_2022_2555_art_34_5)]) :-
    implements(eu_dir_2022_2555_art_34_4),
    implements(eu_dir_2022_2555_art_34_5).
ceiling_by_provision(present(Provision), Profile, Ceiling, Citations) :-
    implements(eu_dir_2022_2555_art_34_4),
    implements(eu_dir_2022_2555_art_34_5),
    infringement_with_union_floor(Provision, _),
    nis2_supervision_fines_missing_in_order(Profile, [entity_class, worldwide_annual_turnover_eur], MissingKeys),
    ceiling_for_missing(MissingKeys, Profile, Ceiling, Citations).

ceiling_for_missing([MissingKey|MissingKeys], _, indeterminate([MissingKey|MissingKeys]), []).
ceiling_for_missing([], Profile, minimum_national_maximum(AmountEur, Basis), [Citation]) :-
    profile_get(Profile, entity_class, EntityClass),
    profile_get(Profile, worldwide_annual_turnover_eur, TurnoverEur),
    fine_floor_citation(EntityClass, Citation),
    fine_floor_amounts(EntityClass, TurnoverEur, FixedEur, PercentageAmountEur),
    least_maximum(EntityClass, FixedEur, PercentageAmountEur, AmountEur, Basis).

fine_floor_amounts(essential, TurnoverEur, FixedEur, PercentageAmountEur) :-
    implements(eu_dir_2022_2555_art_34_4),
    FixedEur #= 10000000,
    PercentageAmountEur #= (TurnoverEur * 2 + 100 - 1) // 100.
fine_floor_amounts(important, TurnoverEur, FixedEur, PercentageAmountEur) :-
    implements(eu_dir_2022_2555_art_34_5),
    FixedEur #= 7000000,
    PercentageAmountEur #= (TurnoverEur * 14 + 1000 - 1) // 1000.

least_maximum(essential, FixedEur, PercentageAmountEur, FixedEur, fixed_amount) :-
    implements(eu_dir_2022_2555_art_34_4),
    FixedEur #>= PercentageAmountEur.
least_maximum(essential, FixedEur, PercentageAmountEur, PercentageAmountEur, turnover_percentage) :-
    implements(eu_dir_2022_2555_art_34_4),
    FixedEur #< PercentageAmountEur.
least_maximum(important, FixedEur, PercentageAmountEur, FixedEur, fixed_amount) :-
    implements(eu_dir_2022_2555_art_34_5),
    FixedEur #>= PercentageAmountEur.
least_maximum(important, FixedEur, PercentageAmountEur, PercentageAmountEur, turnover_percentage) :-
    implements(eu_dir_2022_2555_art_34_5),
    FixedEur #< PercentageAmountEur.

minimum_powers(Profile, input_problems([Problem|Problems])) :-
    nis2_supervision_fines_input_problems(Profile, [Problem|Problems]).
minimum_powers(Profile, Powers) :-
    nis2_supervision_fines_input_problems(Profile, []),
    key_state(Profile, entity_class, ClassState),
    powers_by_class(ClassState, Profile, Powers).

powers_by_class(absent, _, indeterminate([entity_class])).
powers_by_class(present(important), _, Powers) :-
    implements(eu_dir_2022_2555_art_33_2_a),
    implements(eu_dir_2022_2555_art_33_4_a),
    findall(power(Kind, Measure, Citation), listed_power(important, Kind, Measure, Citation), Powers).
powers_by_class(present(essential), Profile, Powers) :-
    implements(eu_dir_2022_2555_art_32_2_a),
    implements(eu_dir_2022_2555_art_32_4_a),
    key_state(Profile, entity_is_public_administration, AdministrationState),
    essential_powers(AdministrationState, Powers).

essential_powers(absent, indeterminate([entity_is_public_administration])).
essential_powers(present(true), Powers) :-
    implements(eu_dir_2022_2555_art_32_5),
    findall(power(Kind, Measure, Citation), listed_power(essential, Kind, Measure, Citation), Powers).
essential_powers(present(false), Powers) :-
    implements(eu_dir_2022_2555_art_32_5),
    findall(power(Kind, Measure, Citation), listed_power(essential, Kind, Measure, Citation), ListedPowers),
    findall(power(Kind, Measure, Citation), escalation_power(Kind, Measure, Citation), EscalationPowers),
    append(ListedPowers, EscalationPowers, Powers).

escalation_powers_exercisable(Profile, input_problems([Problem|Problems]), []) :-
    nis2_supervision_fines_input_problems(Profile, [Problem|Problems]).
escalation_powers_exercisable(Profile, Result, Citations) :-
    nis2_supervision_fines_input_problems(Profile, []),
    key_state(Profile, entity_class, ClassState),
    escalation_by_class(ClassState, Profile, Result, Citations).

escalation_by_class(absent, _, indeterminate([entity_class]), []).
escalation_by_class(present(important), _, not_exercisable(important_entity), [cite(eu_dir_2022_2555_art_32_5)]) :-
    implements(eu_dir_2022_2555_art_32_5).
escalation_by_class(present(essential), Profile, Result, Citations) :-
    implements(eu_dir_2022_2555_art_32_5),
    escalation_conditions(Conditions),
    condition_states(Profile, Conditions, States),
    resolve_conditions(States, Outcome),
    escalation_outcome(Outcome, Profile, Result, Citations).

escalation_conditions(Conditions) :-
    findall(condition(Key, FailingValue, Reason), escalation_condition(_, Key, FailingValue, Reason), Conditions).

escalation_outcome(failure(Reason), _, not_exercisable(Reason), [cite(eu_dir_2022_2555_art_32_5)]) :-
    implements(eu_dir_2022_2555_art_32_5).
escalation_outcome(missing(MissingKeys), _, indeterminate(MissingKeys), []).
escalation_outcome(open(Key), Profile, needs_legal_review(open_textured(Key, cite(eu_dir_2022_2555_art_32_5)), [inputs_relied_on(Pairs)]), []) :-
    nis2_supervision_fines_pairs(Profile, [earlier_measures_ineffective], Pairs).
escalation_outcome(all_hold, _, exercisable, [cite(eu_dir_2022_2555_art_32_5)]) :-
    implements(eu_dir_2022_2555_art_32_5).

fine_barred_by_gdpr_fine(Profile, input_problems([Problem|Problems]), []) :-
    nis2_supervision_fines_input_problems(Profile, [Problem|Problems]).
fine_barred_by_gdpr_fine(Profile, Result, Citations) :-
    nis2_supervision_fines_input_problems(Profile, []),
    key_state(Profile, infringed_provision, ProvisionState),
    fine_bar_by_provision(ProvisionState, Profile, Result, Citations).

fine_bar_by_provision(absent, _, indeterminate([infringed_provision]), []).
fine_bar_by_provision(present(other), _, fine_not_barred, [cite(eu_dir_2022_2555_art_35_2)]) :-
    implements(eu_dir_2022_2555_art_35_2).
fine_bar_by_provision(present(Provision), Profile, Result, Citations) :-
    implements(eu_dir_2022_2555_art_35_2),
    infringement_with_union_floor(Provision, _),
    findall(condition(Key, FailingValue, Reason), data_protection_fine_bar_condition(Key, FailingValue, Reason), Conditions),
    condition_states(Profile, Conditions, States),
    resolve_conditions(States, Outcome),
    fine_bar_outcome(Outcome, Profile, Result, Citations).

fine_bar_outcome(failure(_), _, fine_not_barred, [cite(eu_dir_2022_2555_art_35_2)]) :-
    implements(eu_dir_2022_2555_art_35_2).
fine_bar_outcome(missing(MissingKeys), _, indeterminate(MissingKeys), []).
fine_bar_outcome(open(Key), Profile, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), []) :-
    data_protection_fine_bar_referral(Key, Citation),
    nis2_supervision_fines_pairs(Profile, [infringement_may_entail_notifiable_personal_data_breach, gdpr_fine_for_same_conduct], Pairs).
fine_bar_outcome(all_hold, _, fine_barred, [cite(eu_dir_2022_2555_art_35_2)]) :-
    implements(eu_dir_2022_2555_art_35_2).

data_protection_authority_information(Profile, input_problems([Problem|Problems])) :-
    nis2_supervision_fines_input_problems(Profile, [Problem|Problems]).
data_protection_authority_information(Profile, Duty) :-
    nis2_supervision_fines_input_problems(Profile, []),
    key_state(Profile, infringed_provision, ProvisionState),
    information_by_provision(ProvisionState, Profile, Duty).

information_by_provision(absent, _, indeterminate([infringed_provision])).
information_by_provision(present(other), _, []) :-
    implements(eu_dir_2022_2555_art_35_1).
information_by_provision(present(Provision), Profile, Duty) :-
    implements(eu_dir_2022_2555_art_35_1),
    infringement_with_union_floor(Provision, _),
    findall(condition(Key, FailingValue, Reason), information_condition(Key, FailingValue, Reason), Conditions),
    condition_states(Profile, Conditions, States),
    resolve_conditions(States, Outcome),
    information_outcome(Outcome, Profile, Duty).

information_outcome(failure(_), _, []) :-
    implements(eu_dir_2022_2555_art_35_1).
information_outcome(missing(MissingKeys), _, indeterminate(MissingKeys)).
information_outcome(open(Key), Profile, needs_legal_review(open_textured(Key, cite(eu_dir_2022_2555_art_35_1)), [inputs_relied_on(Pairs)])) :-
    nis2_supervision_fines_pairs(Profile, [infringement_may_entail_notifiable_personal_data_breach], Pairs).
information_outcome(all_hold, Profile, Duty) :-
    implements(eu_dir_2022_2555_art_35_3),
    key_state(Profile, data_protection_authority_in_other_member_state, LocationState),
    duty_by_location(LocationState, Duty).

duty_by_location(absent, indeterminate([data_protection_authority_in_other_member_state])).
duty_by_location(present(false), [inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1))]) :-
    implements(eu_dir_2022_2555_art_35_1).
duty_by_location(present(true), [inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1)), inform_supervisory_authority_in_own_member_state(cite(eu_dir_2022_2555_art_35_3))]) :-
    implements(eu_dir_2022_2555_art_35_1),
    implements(eu_dir_2022_2555_art_35_3).

decide_nis2_supervision_fines(Profile, nis2_supervision_fines_verdict(Status, Citations)) :-
    escalation_powers_exercisable(Profile, Result, Citations),
    facade_status(Result, Status).

facade_status(exercisable, eligible).
facade_status(not_exercisable(_), ineligible).
facade_status(indeterminate(MissingKeys), indeterminate(MissingKeys)).
facade_status(needs_legal_review(Reason, Context), needs_legal_review(Reason, Context)).
facade_status(input_problems(Problems), input_problems(Problems)).

nis2_supervision_fines_status(Profile, Status) :-
    decide_nis2_supervision_fines(Profile, nis2_supervision_fines_verdict(Status, _Citations)).

nis2_supervision_fines_checklist(Profile, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_dir_2022_2555_art_32_5))]) :-
    nis2_supervision_fines_input_problems(Profile, [Problem|Problems]).
nis2_supervision_fines_checklist(Profile, [EntityItem|ConditionItems]) :-
    nis2_supervision_fines_input_problems(Profile, []),
    key_state(Profile, entity_class, ClassState),
    entity_class_item(ClassState, EntityItem),
    escalation_conditions(Conditions),
    findall(ItemId, escalation_condition(ItemId, _, _, _), ItemIds),
    condition_states(Profile, Conditions, States),
    maplist(condition_item, ItemIds, States, ConditionItems).

entity_class_item(absent, item(essential_entity, unknown([entity_class]), cite(eu_dir_2022_2555_art_32_5))).
entity_class_item(present(essential), item(essential_entity, met, cite(eu_dir_2022_2555_art_32_5))) :-
    implements(eu_dir_2022_2555_art_32_5).
entity_class_item(present(important), item(essential_entity, unmet(important_entity), cite(eu_dir_2022_2555_art_32_5))) :-
    implements(eu_dir_2022_2555_art_32_5).

condition_item(ItemId, holds, item(ItemId, met, cite(eu_dir_2022_2555_art_32_5))).
condition_item(ItemId, fails(Reason), item(ItemId, unmet(Reason), cite(eu_dir_2022_2555_art_32_5))).
condition_item(ItemId, missing(Key), item(ItemId, unknown([Key]), cite(eu_dir_2022_2555_art_32_5))).
condition_item(ItemId, open(Key), item(ItemId, unknown([Key]), cite(eu_dir_2022_2555_art_32_5))).

nis2_supervision_fines_decision_resolvable(Profile) :-
    decide_nis2_supervision_fines(Profile, _Verdict).

test(essential_zero_turnover_gives_the_fixed_floor) :-
    findall(Ceiling - Citations, fine_ceiling_floor([attribute(entity_class, essential), attribute(infringed_provision, art_21), attribute(worldwide_annual_turnover_eur, 0)], Ceiling, Citations), Answers),
    Answers == [minimum_national_maximum(10000000, fixed_amount) - [cite(eu_dir_2022_2555_art_34_4)]].
test(essential_tie_takes_the_fixed_basis) :-
    fine_ceiling_floor([attribute(entity_class, essential), attribute(infringed_provision, art_23), attribute(worldwide_annual_turnover_eur, 500000000)], minimum_national_maximum(10000000, fixed_amount), [cite(eu_dir_2022_2555_art_34_4)]).
test(essential_percentage_rounds_up) :-
    fine_ceiling_floor([attribute(entity_class, essential), attribute(infringed_provision, art_21), attribute(worldwide_annual_turnover_eur, 500000001)], minimum_national_maximum(10000001, turnover_percentage), [cite(eu_dir_2022_2555_art_34_4)]).
test(important_percentage_above_fixed) :-
    fine_ceiling_floor([attribute(entity_class, important), attribute(infringed_provision, art_21), attribute(worldwide_annual_turnover_eur, 1000000000)], minimum_national_maximum(14000000, turnover_percentage), [cite(eu_dir_2022_2555_art_34_5)]).
test(important_tie_takes_the_fixed_basis) :-
    fine_ceiling_floor([attribute(entity_class, important), attribute(infringed_provision, art_21), attribute(worldwide_annual_turnover_eur, 500000000)], minimum_national_maximum(7000000, fixed_amount), [cite(eu_dir_2022_2555_art_34_5)]).
test(other_infringement_has_no_union_minimum) :-
    findall(Ceiling, fine_ceiling_floor([attribute(infringed_provision, other)], Ceiling, _), Answers),
    Answers == [no_union_minimum].
test(absent_provision_is_indeterminate) :-
    fine_ceiling_floor([attribute(entity_class, essential)], indeterminate([infringed_provision]), []).
test(absent_class_and_turnover_are_named_in_order) :-
    fine_ceiling_floor([attribute(infringed_provision, art_21)], indeterminate([entity_class, worldwide_annual_turnover_eur]), []).
test(input_problems_come_first) :-
    fine_ceiling_floor([attribute(entity_class, banana), attribute(infringed_provision, other)], input_problems([wrong_type(entity_class)]), []).
test(important_has_fourteen_powers_once) :-
    findall(Powers, minimum_powers([attribute(entity_class, important)], Powers), [Powers]),
    length(Powers, 14),
    Powers = [power(supervision, on_site_inspections_and_off_site_ex_post_supervision, cite(eu_dir_2022_2555_art_33_2_a))|_].
test(essential_not_public_administration_has_eighteen_powers) :-
    findall(Powers, minimum_powers([attribute(entity_class, essential), attribute(entity_is_public_administration, false)], Powers), [Powers]),
    length(Powers, 18),
    last(Powers, power(escalation, request_temporary_management_ban, cite(eu_dir_2022_2555_art_32_5_b))).
test(essential_public_administration_has_sixteen_powers) :-
    minimum_powers([attribute(entity_class, essential), attribute(entity_is_public_administration, true)], Powers),
    length(Powers, 16),
    last(Powers, power(enforcement, administrative_fine, cite(eu_dir_2022_2555_art_32_4_i))).
test(essential_needs_the_public_administration_key) :-
    minimum_powers([attribute(entity_class, essential)], indeterminate([entity_is_public_administration])).
test(powers_need_the_entity_class) :-
    minimum_powers([], indeterminate([entity_class])).
test(escalation_all_conditions_hold) :-
    findall(Result - Citations, escalation_powers_exercisable([attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)], Result, Citations), Answers),
    Answers == [exercisable - [cite(eu_dir_2022_2555_art_32_5)]].
test(escalation_important_entity) :-
    escalation_powers_exercisable([attribute(entity_class, important)], not_exercisable(important_entity), [cite(eu_dir_2022_2555_art_32_5)]).
test(escalation_public_administration_settles_before_missing_keys) :-
    escalation_powers_exercisable([attribute(entity_class, essential), attribute(entity_is_public_administration, true)], not_exercisable(public_administration_entity), [cite(eu_dir_2022_2555_art_32_5)]).
test(escalation_action_taken_within_deadline) :-
    escalation_powers_exercisable([attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, true)], not_exercisable(action_taken_within_deadline), _).
test(escalation_missing_key_before_unsure) :-
    escalation_powers_exercisable([attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, unsure)], indeterminate([deadline_set_for_necessary_action, required_action_taken_within_deadline]), []).
test(escalation_unsure_refers) :-
    escalation_powers_exercisable([attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, unsure), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)], needs_legal_review(open_textured(earlier_measures_ineffective, cite(eu_dir_2022_2555_art_32_5)), [inputs_relied_on([earlier_measures_ineffective - unsure])]), []).
test(fine_barred_when_all_hold) :-
    findall(Result - Citations, fine_barred_by_gdpr_fine([attribute(infringed_provision, art_21), attribute(infringement_may_entail_notifiable_personal_data_breach, true), attribute(gdpr_fine_imposed_under_art_58_2_i, true), attribute(gdpr_fine_for_same_conduct, true)], Result, Citations), Answers),
    Answers == [fine_barred - [cite(eu_dir_2022_2555_art_35_2)]].
test(a_false_condition_settles_not_barred) :-
    fine_barred_by_gdpr_fine([attribute(infringed_provision, art_23), attribute(infringement_may_entail_notifiable_personal_data_breach, unsure), attribute(gdpr_fine_imposed_under_art_58_2_i, false)], fine_not_barred, [cite(eu_dir_2022_2555_art_35_2)]).
test(fine_bar_missing_keys_before_unsure) :-
    fine_barred_by_gdpr_fine([attribute(infringed_provision, art_21), attribute(infringement_may_entail_notifiable_personal_data_breach, unsure)], indeterminate([gdpr_fine_imposed_under_art_58_2_i, gdpr_fine_for_same_conduct]), []).
test(fine_bar_same_conduct_unsure_refers) :-
    fine_barred_by_gdpr_fine([attribute(infringed_provision, art_21), attribute(infringement_may_entail_notifiable_personal_data_breach, true), attribute(gdpr_fine_imposed_under_art_58_2_i, true), attribute(gdpr_fine_for_same_conduct, unsure)], needs_legal_review(open_textured(gdpr_fine_for_same_conduct, cite(eu_dir_2022_2555_art_35_2)), [inputs_relied_on([infringement_may_entail_notifiable_personal_data_breach - true, gdpr_fine_for_same_conduct - unsure])]), []).
test(fine_bar_other_infringement_not_barred) :-
    fine_barred_by_gdpr_fine([attribute(infringed_provision, other)], fine_not_barred, [cite(eu_dir_2022_2555_art_35_2)]).
test(information_duty_in_own_member_state_only) :-
    findall(Duty, data_protection_authority_information([attribute(infringed_provision, art_21), attribute(infringement_may_entail_notifiable_personal_data_breach, true), attribute(authority_became_aware_in_supervision_or_enforcement, true), attribute(data_protection_authority_in_other_member_state, false)], Duty), Answers),
    Answers == [[inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1))]].
test(information_duty_with_other_member_state) :-
    data_protection_authority_information([attribute(infringed_provision, art_23), attribute(infringement_may_entail_notifiable_personal_data_breach, true), attribute(authority_became_aware_in_supervision_or_enforcement, true), attribute(data_protection_authority_in_other_member_state, true)], [inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1)), inform_supervisory_authority_in_own_member_state(cite(eu_dir_2022_2555_art_35_3))]).
test(information_no_duty_when_not_aware) :-
    data_protection_authority_information([attribute(infringed_provision, art_21), attribute(authority_became_aware_in_supervision_or_enforcement, false)], []).
test(information_unsure_breach_refers) :-
    data_protection_authority_information([attribute(infringed_provision, art_21), attribute(infringement_may_entail_notifiable_personal_data_breach, unsure), attribute(authority_became_aware_in_supervision_or_enforcement, true)], needs_legal_review(open_textured(infringement_may_entail_notifiable_personal_data_breach, cite(eu_dir_2022_2555_art_35_1)), [inputs_relied_on([infringement_may_entail_notifiable_personal_data_breach - unsure])])).
test(information_location_key_needed) :-
    data_protection_authority_information([attribute(infringed_provision, art_21), attribute(infringement_may_entail_notifiable_personal_data_breach, true), attribute(authority_became_aware_in_supervision_or_enforcement, true)], indeterminate([data_protection_authority_in_other_member_state])).
test(information_input_problems) :-
    data_protection_authority_information(not_a_profile, input_problems([wrong_type(profile)])).
test(facade_eligible_with_cited_checklist) :-
    Profile = [attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)],
    decide_nis2_supervision_fines(Profile, nis2_supervision_fines_verdict(eligible, [cite(eu_dir_2022_2555_art_32_5)])),
    nis2_supervision_fines_checklist(Profile, Items),
    length(Items, 5),
    member(item(deadline_set, met, cite(eu_dir_2022_2555_art_32_5)), Items).
test(facade_ineligible_for_important) :-
    nis2_supervision_fines_status([attribute(entity_class, important)], ineligible).

test(important_tie_is_not_turnover_percentage, fail) :-
    fine_ceiling_floor([attribute(entity_class, important), attribute(infringed_provision, art_21), attribute(worldwide_annual_turnover_eur, 500000000)], minimum_national_maximum(_, turnover_percentage), _).
test(escalation_unsure_is_not_exercisable, fail) :-
    escalation_powers_exercisable([attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, unsure), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)], exercisable, _).
test(facade_important_is_not_eligible, fail) :-
    nis2_supervision_fines_status([attribute(entity_class, important)], eligible).
