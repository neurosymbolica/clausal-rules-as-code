% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_nis2_supervision_fines, [decide_nis2_supervision_fines/2, nis2_supervision_fines_status/2, nis2_supervision_fines_checklist/2, nis2_supervision_fines_decision_resolvable/1, nis2_supervision_fines_status_values/1, fine_ceiling_floor/3, minimum_powers/2, escalation_powers_exercisable/3, fine_barred_by_gdpr_fine/3, data_protection_authority_information/2, exercisable/0, fine_barred/0, fine_not_barred/0, no_union_minimum/0, fixed_amount/0, turnover_percentage/0, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, minimum_national_maximum/2, power/3, not_exercisable/1, inform_gdpr_supervisory_authorities/1, inform_supervisory_authority_in_own_member_state/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2, clausal_is_list/1]).
:- use_module(library(clpz)).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2, eval_requirements/4]).
:- use_module(m__eu_nis2_supervision_fines_kernel, [nis2_supervision_fines_input_problems/2, nis2_supervision_fines_relied_pairs/3]).
:- use_module(m__eu_nis2_supervision_fines_citations, [implements/1]).

nis2_supervision_fines_status_values([eligible, ineligible, indeterminate, invalid_profile]).

article_21_or_23(art_21).
article_21_or_23(art_23).

important_power(supervision, on_site_inspections_and_off_site_ex_post_supervision, cite(eu_dir_2022_2555_art_33_2_a)).
important_power(supervision, targeted_security_audits, cite(eu_dir_2022_2555_art_33_2_b)).
important_power(supervision, security_scans, cite(eu_dir_2022_2555_art_33_2_c)).
important_power(supervision, information_requests, cite(eu_dir_2022_2555_art_33_2_d)).
important_power(supervision, data_access_requests, cite(eu_dir_2022_2555_art_33_2_e)).
important_power(supervision, implementation_evidence_requests, cite(eu_dir_2022_2555_art_33_2_f)).
important_power(enforcement, warnings, cite(eu_dir_2022_2555_art_33_4_a)).
important_power(enforcement, binding_instructions_or_remedy_orders, cite(eu_dir_2022_2555_art_33_4_b)).
important_power(enforcement, cease_and_desist_orders, cite(eu_dir_2022_2555_art_33_4_c)).
important_power(enforcement, compliance_orders, cite(eu_dir_2022_2555_art_33_4_d)).
important_power(enforcement, inform_affected_persons_orders, cite(eu_dir_2022_2555_art_33_4_e)).
important_power(enforcement, audit_recommendation_orders, cite(eu_dir_2022_2555_art_33_4_f)).
important_power(enforcement, publication_orders, cite(eu_dir_2022_2555_art_33_4_g)).
important_power(enforcement, administrative_fine, cite(eu_dir_2022_2555_art_33_4_h)).

essential_power(supervision, on_site_inspections_and_off_site_supervision, cite(eu_dir_2022_2555_art_32_2_a)).
essential_power(supervision, regular_and_targeted_security_audits, cite(eu_dir_2022_2555_art_32_2_b)).
essential_power(supervision, ad_hoc_audits, cite(eu_dir_2022_2555_art_32_2_c)).
essential_power(supervision, security_scans, cite(eu_dir_2022_2555_art_32_2_d)).
essential_power(supervision, information_requests, cite(eu_dir_2022_2555_art_32_2_e)).
essential_power(supervision, data_access_requests, cite(eu_dir_2022_2555_art_32_2_f)).
essential_power(supervision, implementation_evidence_requests, cite(eu_dir_2022_2555_art_32_2_g)).
essential_power(enforcement, warnings, cite(eu_dir_2022_2555_art_32_4_a)).
essential_power(enforcement, binding_instructions_or_remedy_orders, cite(eu_dir_2022_2555_art_32_4_b)).
essential_power(enforcement, cease_and_desist_orders, cite(eu_dir_2022_2555_art_32_4_c)).
essential_power(enforcement, compliance_orders, cite(eu_dir_2022_2555_art_32_4_d)).
essential_power(enforcement, inform_affected_persons_orders, cite(eu_dir_2022_2555_art_32_4_e)).
essential_power(enforcement, audit_recommendation_orders, cite(eu_dir_2022_2555_art_32_4_f)).
essential_power(enforcement, monitoring_officer, cite(eu_dir_2022_2555_art_32_4_g)).
essential_power(enforcement, publication_orders, cite(eu_dir_2022_2555_art_32_4_h)).
essential_power(enforcement, administrative_fine, cite(eu_dir_2022_2555_art_32_4_i)).

essential_escalation_power(escalation, suspend_certification_or_authorisation, cite(eu_dir_2022_2555_art_32_5_a)).
essential_escalation_power(escalation, request_temporary_management_ban, cite(eu_dir_2022_2555_art_32_5_b)).

escalation_condition(not_public_administration, public_administration_entity, entity_is_public_administration, false, cite(eu_dir_2022_2555_art_32_5)).
escalation_condition(earlier_measures_ineffective, measures_not_ineffective, earlier_measures_ineffective, true, cite(eu_dir_2022_2555_art_32_5)).
escalation_condition(deadline_set, no_deadline_set, deadline_set_for_necessary_action, true, cite(eu_dir_2022_2555_art_32_5)).
escalation_condition(action_not_taken_within_deadline, action_taken_within_deadline, required_action_taken_within_deadline, false, cite(eu_dir_2022_2555_art_32_5)).

gdpr_bar_condition(infringement_may_entail_notifiable_personal_data_breach, cite(eu_dir_2022_2555_art_35_1)).
gdpr_bar_condition(gdpr_fine_imposed_under_art_58_2_i, cite(eu_dir_2022_2555_art_35_2)).
gdpr_bar_condition(gdpr_fine_for_same_conduct, cite(eu_dir_2022_2555_art_35_2)).

information_duty_condition(infringement_may_entail_notifiable_personal_data_breach, cite(eu_dir_2022_2555_art_35_1)).
information_duty_condition(authority_became_aware_in_supervision_or_enforcement, cite(eu_dir_2022_2555_art_35_1)).

exercisable.

fine_barred.

fine_not_barred.

no_union_minimum.

fixed_amount.

turnover_percentage.

indeterminate(MissingKeys) :-
    clausal_is_list(MissingKeys).

needs_legal_review(Reason, Context) :-
    compound(Reason),
    clausal_is_list(Context).

open_textured(InputKey, cite(CitationKey)) :-
    atom(InputKey),
    atom(CitationKey).

inputs_relied_on(ReliedPairs) :-
    clausal_is_list(ReliedPairs).

provenance(DecidingClause, Citations) :-
    nonvar(DecidingClause),
    clausal_is_list(Citations).

input_problems(Problems) :-
    clausal_is_list(Problems).

unknown_key(ProfileKey) :-
    atom(ProfileKey).

wrong_type(ProfileKey) :-
    atom(ProfileKey).

duplicate_key(ProfileKey) :-
    atom(ProfileKey).

minimum_national_maximum(AmountEur, Basis) :-
    integer(AmountEur),
    ceiling_basis(Basis).

ceiling_basis(fixed_amount).
ceiling_basis(turnover_percentage).

power(Kind, Measure, cite(CitationKey)) :-
    power_kind(Kind),
    atom(Measure),
    atom(CitationKey).

power_kind(supervision).
power_kind(enforcement).
power_kind(escalation).

not_exercisable(Reason) :-
    escalation_reason(Reason).

escalation_reason(important_entity).
escalation_reason(public_administration_entity).
escalation_reason(measures_not_ineffective).
escalation_reason(no_deadline_set).
escalation_reason(action_taken_within_deadline).

inform_gdpr_supervisory_authorities(cite(CitationKey)) :-
    atom(CitationKey).

inform_supervisory_authority_in_own_member_state(cite(CitationKey)) :-
    atom(CitationKey).

key_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
key_state(Profile, ProfileKey, present(GivenValue)) :-
    profile_get(Profile, ProfileKey, GivenValue).

condition_outcome(ProfileKey, absent, _, absent(ProfileKey)).
condition_outcome(ProfileKey, present(unsure), _, unsure(ProfileKey)).
condition_outcome(_, present(HoldingValue), HoldingValue, holds).
condition_outcome(_, present(GivenValue), HoldingValue, fails) :-
    opposite_truth(HoldingValue, GivenValue).

opposite_truth(true, false).
opposite_truth(false, true).

first_failure([], no_failure).
first_failure([condition(ConditionName, fails)|_], failure(ConditionName)).
first_failure([condition(_, Outcome)|Conditions], Failure) :-
    outcome_other_than_fails(Outcome),
    first_failure(Conditions, Failure).

outcome_other_than_fails(holds).
outcome_other_than_fails(absent(_)).
outcome_other_than_fails(unsure(_)).

first_absent([], no_absent_key).
first_absent([condition(_, absent(ProfileKey))|_], absent_key(ProfileKey)).
first_absent([condition(_, Outcome)|Conditions], Absence) :-
    outcome_present(Outcome),
    first_absent(Conditions, Absence).

outcome_present(holds).
outcome_present(fails).
outcome_present(unsure(_)).

first_unsure([], no_unsure_key).
first_unsure([condition(_, unsure(ProfileKey))|_], unsure_key(ProfileKey)).
first_unsure([condition(_, Outcome)|Conditions], Unsure) :-
    outcome_decided(Outcome),
    first_unsure(Conditions, Unsure).

outcome_decided(holds).
outcome_decided(fails).
outcome_decided(absent(_)).

fine_ceiling_floor(Profile, Ceiling, Citations) :-
    nis2_supervision_fines_input_problems(Profile, Problems),
    fine_ceiling_checked(Problems, Profile, Ceiling, Citations).

fine_ceiling_checked([FirstProblem|MoreProblems], _, input_problems([FirstProblem|MoreProblems]), []).
fine_ceiling_checked([], Profile, Ceiling, Citations) :-
    key_state(Profile, infringed_provision, ProvisionState),
    fine_ceiling_provision(ProvisionState, Profile, Ceiling, Citations).

fine_ceiling_provision(absent, _, indeterminate([infringed_provision]), []).
fine_ceiling_provision(present(other), _, no_union_minimum, [cite(eu_dir_2022_2555_art_34_4), cite(eu_dir_2022_2555_art_34_5)]) :-
    implements(eu_dir_2022_2555_art_34_4).
fine_ceiling_provision(present(Provision), Profile, Ceiling, Citations) :-
    implements(eu_dir_2022_2555_art_34_4),
    article_21_or_23(Provision),
    key_state(Profile, entity_class, ClassState),
    key_state(Profile, worldwide_annual_turnover_eur, TurnoverState),
    fine_ceiling_inputs(ClassState, TurnoverState, Ceiling, Citations).

fine_ceiling_inputs(absent, _, indeterminate([entity_class]), []).
fine_ceiling_inputs(present(_), absent, indeterminate([worldwide_annual_turnover_eur]), []).
fine_ceiling_inputs(present(EntityClass), present(TurnoverEur), minimum_national_maximum(AmountEur, Basis), Citations) :-
    fine_floor_amount(EntityClass, TurnoverEur, AmountEur, Basis, Citations).

fine_floor_amount(essential, TurnoverEur, AmountEur, Basis, [cite(eu_dir_2022_2555_art_34_4)]) :-
    implements(eu_dir_2022_2555_art_34_4),
    FixedEur #= 10000000,
    ShareAmountEur #= (TurnoverEur * 20 + 1000 - 1) // 1000,
    whichever_is_higher(FixedEur, ShareAmountEur, AmountEur, Basis).
fine_floor_amount(important, TurnoverEur, AmountEur, Basis, [cite(eu_dir_2022_2555_art_34_5)]) :-
    implements(eu_dir_2022_2555_art_34_5),
    FixedEur #= 7000000,
    ShareAmountEur #= (TurnoverEur * 14 + 1000 - 1) // 1000,
    whichever_is_higher(FixedEur, ShareAmountEur, AmountEur, Basis).

whichever_is_higher(FixedEur, ShareAmountEur, FixedEur, fixed_amount) :-
    FixedEur #>= ShareAmountEur.
whichever_is_higher(FixedEur, ShareAmountEur, ShareAmountEur, turnover_percentage) :-
    FixedEur #< ShareAmountEur.

minimum_powers(Profile, Powers) :-
    nis2_supervision_fines_input_problems(Profile, Problems),
    minimum_powers_checked(Problems, Profile, Powers).

minimum_powers_checked([FirstProblem|MoreProblems], _, input_problems([FirstProblem|MoreProblems])).
minimum_powers_checked([], Profile, Powers) :-
    key_state(Profile, entity_class, ClassState),
    minimum_powers_class(ClassState, Profile, Powers).

minimum_powers_class(absent, _, indeterminate([entity_class])).
minimum_powers_class(present(important), _, Powers) :-
    implements(eu_dir_2022_2555_art_33_2),
    implements(eu_dir_2022_2555_art_33_4),
    findall(power(Kind, Measure, Citation), important_power(Kind, Measure, Citation), Powers).
minimum_powers_class(present(essential), Profile, Powers) :-
    key_state(Profile, entity_is_public_administration, AdministrationState),
    essential_powers(AdministrationState, Powers).

essential_powers(absent, indeterminate([entity_is_public_administration])).
essential_powers(present(true), Powers) :-
    implements(eu_dir_2022_2555_art_32_5),
    implements(eu_dir_2022_2555_art_32_2),
    implements(eu_dir_2022_2555_art_32_4),
    findall(power(Kind, Measure, Citation), essential_power(Kind, Measure, Citation), Powers).
essential_powers(present(false), Powers) :-
    implements(eu_dir_2022_2555_art_32_5),
    implements(eu_dir_2022_2555_art_32_2),
    implements(eu_dir_2022_2555_art_32_4),
    findall(power(Kind, Measure, Citation), essential_power(Kind, Measure, Citation), BasePowers),
    findall(power(Kind, Measure, Citation), essential_escalation_power(Kind, Measure, Citation), EscalationPowers),
    append(BasePowers, EscalationPowers, Powers).

escalation_powers_exercisable(Profile, Result, Citations) :-
    nis2_supervision_fines_input_problems(Profile, Problems),
    escalation_checked(Problems, Profile, Result, Citations).

escalation_checked([FirstProblem|MoreProblems], _, input_problems([FirstProblem|MoreProblems]), []).
escalation_checked([], Profile, Result, Citations) :-
    key_state(Profile, entity_class, ClassState),
    escalation_class(ClassState, Profile, Result, Citations).

escalation_class(present(important), _, not_exercisable(important_entity), [cite(eu_dir_2022_2555_art_32_5)]) :-
    implements(eu_dir_2022_2555_art_32_5).
escalation_class(present(essential), Profile, Result, Citations) :-
    escalation_conditions(Profile, class_known, Result, Citations).
escalation_class(absent, Profile, Result, Citations) :-
    escalation_conditions(Profile, class_absent, Result, Citations).

escalation_condition_outcome(Profile, Reason, Outcome) :-
    implements(eu_dir_2022_2555_art_32_5),
    escalation_condition(_, Reason, ProfileKey, HoldingValue, _),
    key_state(Profile, ProfileKey, KeyState),
    condition_outcome(ProfileKey, KeyState, HoldingValue, Outcome).

escalation_conditions(Profile, ClassFlag, Result, Citations) :-
    findall(condition(Reason, Outcome), escalation_condition_outcome(Profile, Reason, Outcome), Outcomes),
    first_failure(Outcomes, Failure),
    escalation_outcome(Failure, ClassFlag, Outcomes, Profile, Result, Citations).

escalation_outcome(failure(Reason), _, _, _, not_exercisable(Reason), [cite(eu_dir_2022_2555_art_32_5)]) :-
    implements(eu_dir_2022_2555_art_32_5).
escalation_outcome(no_failure, class_absent, _, _, indeterminate([entity_class]), []).
escalation_outcome(no_failure, class_known, Outcomes, Profile, Result, Citations) :-
    first_absent(Outcomes, Absence),
    escalation_open(Absence, Outcomes, Profile, Result, Citations).

escalation_open(absent_key(ProfileKey), _, _, indeterminate([ProfileKey]), []).
escalation_open(no_absent_key, Outcomes, Profile, Result, Citations) :-
    first_unsure(Outcomes, Unsure),
    escalation_settled(Unsure, Profile, Result, Citations).

escalation_settled(unsure_key(ProfileKey), Profile, needs_legal_review(open_textured(ProfileKey, cite(eu_dir_2022_2555_art_32_5)), [inputs_relied_on(ReliedPairs)]), []) :-
    implements(eu_dir_2022_2555_art_32_5),
    nis2_supervision_fines_relied_pairs(Profile, [earlier_measures_ineffective], ReliedPairs).
escalation_settled(no_unsure_key, _, exercisable, [cite(eu_dir_2022_2555_art_32_5)]) :-
    implements(eu_dir_2022_2555_art_32_5).

fine_barred_by_gdpr_fine(Profile, Result, Citations) :-
    nis2_supervision_fines_input_problems(Profile, Problems),
    gdpr_bar_checked(Problems, Profile, Result, Citations).

gdpr_bar_checked([FirstProblem|MoreProblems], _, input_problems([FirstProblem|MoreProblems]), []).
gdpr_bar_checked([], Profile, Result, Citations) :-
    findall(condition(ProfileKey, Outcome), gdpr_bar_outcome(Profile, ProfileKey, Outcome), Outcomes),
    first_failure(Outcomes, Failure),
    key_state(Profile, infringed_provision, ProvisionState),
    gdpr_bar_after_conditions(Failure, ProvisionState, Outcomes, Profile, Result, Citations).

gdpr_bar_outcome(Profile, ProfileKey, Outcome) :-
    implements(eu_dir_2022_2555_art_35_2),
    gdpr_bar_condition(ProfileKey, _),
    key_state(Profile, ProfileKey, KeyState),
    condition_outcome(ProfileKey, KeyState, true, Outcome).

gdpr_bar_after_conditions(failure(_), _, _, _, fine_not_barred, [cite(eu_dir_2022_2555_art_35_2)]) :-
    implements(eu_dir_2022_2555_art_35_2).
gdpr_bar_after_conditions(no_failure, present(other), _, _, fine_not_barred, [cite(eu_dir_2022_2555_art_35_2)]) :-
    implements(eu_dir_2022_2555_art_35_2).
gdpr_bar_after_conditions(no_failure, absent, _, _, indeterminate([infringed_provision]), []).
gdpr_bar_after_conditions(no_failure, present(Provision), Outcomes, Profile, Result, Citations) :-
    implements(eu_dir_2022_2555_art_35_1),
    article_21_or_23(Provision),
    first_absent(Outcomes, Absence),
    gdpr_bar_open(Absence, Outcomes, Profile, Result, Citations).

gdpr_bar_open(absent_key(ProfileKey), _, _, indeterminate([ProfileKey]), []).
gdpr_bar_open(no_absent_key, Outcomes, Profile, Result, Citations) :-
    first_unsure(Outcomes, Unsure),
    gdpr_bar_settled(Unsure, Profile, Result, Citations).

gdpr_bar_settled(unsure_key(ProfileKey), Profile, needs_legal_review(open_textured(ProfileKey, Citation), [inputs_relied_on(ReliedPairs)]), []) :-
    implements(eu_dir_2022_2555_art_35_2),
    gdpr_bar_condition(ProfileKey, Citation),
    nis2_supervision_fines_relied_pairs(Profile, [infringement_may_entail_notifiable_personal_data_breach, gdpr_fine_for_same_conduct], ReliedPairs).
gdpr_bar_settled(no_unsure_key, _, fine_barred, [cite(eu_dir_2022_2555_art_35_2)]) :-
    implements(eu_dir_2022_2555_art_35_2).

data_protection_authority_information(Profile, DutyList) :-
    nis2_supervision_fines_input_problems(Profile, Problems),
    information_duty_checked(Problems, Profile, DutyList).

information_duty_checked([FirstProblem|MoreProblems], _, input_problems([FirstProblem|MoreProblems])).
information_duty_checked([], Profile, DutyList) :-
    findall(condition(ProfileKey, Outcome), information_duty_outcome(Profile, ProfileKey, Outcome), Outcomes),
    first_failure(Outcomes, Failure),
    key_state(Profile, infringed_provision, ProvisionState),
    information_duty_after_conditions(Failure, ProvisionState, Outcomes, Profile, DutyList).

information_duty_outcome(Profile, ProfileKey, Outcome) :-
    implements(eu_dir_2022_2555_art_35_1),
    information_duty_condition(ProfileKey, _),
    key_state(Profile, ProfileKey, KeyState),
    condition_outcome(ProfileKey, KeyState, true, Outcome).

information_duty_after_conditions(failure(_), _, _, _, []) :-
    implements(eu_dir_2022_2555_art_35_1).
information_duty_after_conditions(no_failure, present(other), _, _, []) :-
    implements(eu_dir_2022_2555_art_35_1).
information_duty_after_conditions(no_failure, absent, _, _, indeterminate([infringed_provision])).
information_duty_after_conditions(no_failure, present(Provision), Outcomes, Profile, DutyList) :-
    implements(eu_dir_2022_2555_art_35_1),
    article_21_or_23(Provision),
    first_absent(Outcomes, Absence),
    information_duty_open(Absence, Outcomes, Profile, DutyList).

information_duty_open(absent_key(ProfileKey), _, _, indeterminate([ProfileKey])).
information_duty_open(no_absent_key, Outcomes, Profile, DutyList) :-
    first_unsure(Outcomes, Unsure),
    key_state(Profile, data_protection_authority_in_other_member_state, OtherStateState),
    information_duty_settled(Unsure, OtherStateState, Profile, DutyList).

information_duty_settled(_, absent, _, indeterminate([data_protection_authority_in_other_member_state])).
information_duty_settled(unsure_key(ProfileKey), present(_), Profile, needs_legal_review(open_textured(ProfileKey, cite(eu_dir_2022_2555_art_35_1)), [inputs_relied_on(ReliedPairs)])) :-
    implements(eu_dir_2022_2555_art_35_1),
    nis2_supervision_fines_relied_pairs(Profile, [infringement_may_entail_notifiable_personal_data_breach], ReliedPairs).
information_duty_settled(no_unsure_key, present(false), _, [inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1))]) :-
    implements(eu_dir_2022_2555_art_35_1).
information_duty_settled(no_unsure_key, present(true), _, [inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1)), inform_supervisory_authority_in_own_member_state(cite(eu_dir_2022_2555_art_35_3))]) :-
    implements(eu_dir_2022_2555_art_35_3).

decide_nis2_supervision_fines(Profile, nis2_supervision_fines_verdict(eligible, Citations)) :-
    escalation_powers_exercisable(Profile, exercisable, Citations).
decide_nis2_supervision_fines(Profile, nis2_supervision_fines_verdict(ineligible, Citations)) :-
    escalation_powers_exercisable(Profile, not_exercisable(_), Citations).
decide_nis2_supervision_fines(Profile, nis2_supervision_fines_verdict(indeterminate, [cite(eu_dir_2022_2555_art_32_5)])) :-
    escalation_powers_exercisable(Profile, indeterminate(_), _).
decide_nis2_supervision_fines(Profile, nis2_supervision_fines_verdict(indeterminate, [cite(eu_dir_2022_2555_art_32_5)])) :-
    escalation_powers_exercisable(Profile, needs_legal_review(_, _), _).
decide_nis2_supervision_fines(Profile, nis2_supervision_fines_verdict(invalid_profile, [])) :-
    escalation_powers_exercisable(Profile, input_problems(_), _).

nis2_supervision_fines_status(Profile, Status) :-
    decide_nis2_supervision_fines(Profile, nis2_supervision_fines_verdict(Status, _Citations)).

escalation_checklist_ids([essential_entity, not_public_administration, earlier_measures_ineffective, deadline_set, action_not_taken_within_deadline]).

nis2_supervision_fines_checklist(Profile, Items) :-
    nis2_supervision_fines_input_problems(Profile, Problems),
    checklist_checked(Problems, Profile, Items).

checklist_checked([FirstProblem|MoreProblems], _, [item(input_check, unmet(input_problems([FirstProblem|MoreProblems])), cite(eu_dir_2022_2555_art_32_5))]).
checklist_checked([], Profile, Items) :-
    escalation_checklist_ids(RequirementIds),
    eval_requirements(RequirementIds, Profile, escalation_requirement, Items).

escalation_requirement(essential_entity, Profile, Status, cite(eu_dir_2022_2555_art_32_5)) :-
    implements(eu_dir_2022_2555_art_32_5),
    key_state(Profile, entity_class, ClassState),
    class_requirement_status(ClassState, Status).
escalation_requirement(RequirementId, Profile, Status, Citation) :-
    implements(eu_dir_2022_2555_art_32_5),
    escalation_condition(RequirementId, Reason, ProfileKey, HoldingValue, Citation),
    key_state(Profile, ProfileKey, KeyState),
    condition_outcome(ProfileKey, KeyState, HoldingValue, Outcome),
    outcome_status(Outcome, Reason, Status).

class_requirement_status(absent, unknown([entity_class])).
class_requirement_status(present(essential), met).
class_requirement_status(present(important), unmet(important_entity)).

outcome_status(holds, _, met).
outcome_status(fails, Reason, unmet(Reason)).
outcome_status(absent(ProfileKey), _, unknown([ProfileKey])).
outcome_status(unsure(ProfileKey), _, unknown([ProfileKey])).

nis2_supervision_fines_decision_resolvable(Profile) :-
    decide_nis2_supervision_fines(Profile, _Verdict).

test(essential_turnover_share_above_the_fixed_amount) :-
    fine_ceiling_floor([attribute(infringed_provision, art_21), attribute(entity_class, essential), attribute(worldwide_annual_turnover_eur, 1000000000)], minimum_national_maximum(20000000, turnover_percentage), [cite(eu_dir_2022_2555_art_34_4)]).
test(essential_tie_gives_the_fixed_amount) :-
    fine_ceiling_floor([attribute(infringed_provision, art_23), attribute(entity_class, essential), attribute(worldwide_annual_turnover_eur, 500000000)], minimum_national_maximum(10000000, fixed_amount), [cite(eu_dir_2022_2555_art_34_4)]).
test(important_share_is_rounded_up) :-
    fine_ceiling_floor([attribute(infringed_provision, art_21), attribute(entity_class, important), attribute(worldwide_annual_turnover_eur, 1000000001)], minimum_national_maximum(14000001, turnover_percentage), [cite(eu_dir_2022_2555_art_34_5)]).
test(important_zero_turnover_gives_the_fixed_amount) :-
    fine_ceiling_floor([attribute(infringed_provision, art_21), attribute(entity_class, important), attribute(worldwide_annual_turnover_eur, 0)], minimum_national_maximum(7000000, fixed_amount), [cite(eu_dir_2022_2555_art_34_5)]).
test(other_provision_has_no_union_minimum) :-
    findall(Ceiling - Citations, fine_ceiling_floor([attribute(infringed_provision, other)], Ceiling, Citations), Answers),
    Answers == [no_union_minimum - [cite(eu_dir_2022_2555_art_34_4), cite(eu_dir_2022_2555_art_34_5)]].
test(absent_provision_is_named_first) :-
    fine_ceiling_floor([attribute(entity_class, essential)], indeterminate([infringed_provision]), []).
test(absent_class_is_named_before_turnover) :-
    fine_ceiling_floor([attribute(infringed_provision, art_23)], indeterminate([entity_class]), []).
test(absent_turnover_is_named) :-
    fine_ceiling_floor([attribute(infringed_provision, art_23), attribute(entity_class, important)], indeterminate([worldwide_annual_turnover_eur]), []).
test(bad_input_gives_input_problems) :-
    fine_ceiling_floor([attribute(entity_class, big)], input_problems([wrong_type(entity_class)]), []).
test(important_powers_are_fourteen_in_order) :-
    findall(Powers, minimum_powers([attribute(entity_class, important)], Powers), [Powers]),
    length(Powers, 14),
    Powers = [power(supervision, on_site_inspections_and_off_site_ex_post_supervision, cite(eu_dir_2022_2555_art_33_2_a))|_],
    last(Powers, power(enforcement, administrative_fine, cite(eu_dir_2022_2555_art_33_4_h))).
test(essential_private_powers_include_escalation) :-
    minimum_powers([attribute(entity_class, essential), attribute(entity_is_public_administration, false)], Powers),
    length(Powers, 18),
    last(Powers, power(escalation, request_temporary_management_ban, cite(eu_dir_2022_2555_art_32_5_b))).
test(essential_public_administration_powers_exclude_escalation) :-
    minimum_powers([attribute(entity_class, essential), attribute(entity_is_public_administration, true)], Powers),
    length(Powers, 16),
    last(Powers, power(enforcement, administrative_fine, cite(eu_dir_2022_2555_art_32_4_i))).
test(essential_needs_public_administration_key) :-
    minimum_powers([attribute(entity_class, essential)], indeterminate([entity_is_public_administration])).
test(powers_need_entity_class) :-
    minimum_powers([], indeterminate([entity_class])).
test(important_entity_has_no_escalation) :-
    escalation_powers_exercisable([attribute(entity_class, important)], not_exercisable(important_entity), [cite(eu_dir_2022_2555_art_32_5)]).
test(all_conditions_met_is_exercisable) :-
    findall(Result, escalation_powers_exercisable([attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)], Result, _), Results),
    Results == [exercisable].
test(failing_condition_settles_before_absent_class) :-
    escalation_powers_exercisable([attribute(deadline_set_for_necessary_action, false)], not_exercisable(no_deadline_set), [cite(eu_dir_2022_2555_art_32_5)]).
test(failing_condition_settles_before_absent_earlier_condition) :-
    escalation_powers_exercisable([attribute(entity_class, essential), attribute(earlier_measures_ineffective, false)], not_exercisable(measures_not_ineffective), _).
test(absent_class_named_when_no_condition_fails) :-
    escalation_powers_exercisable([attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)], indeterminate([entity_class]), []).
test(absent_condition_named_before_unsure_judgement) :-
    escalation_powers_exercisable([attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, unsure), attribute(required_action_taken_within_deadline, false)], indeterminate([deadline_set_for_necessary_action]), []).
test(unsure_ineffectiveness_goes_to_a_lawyer) :-
    escalation_powers_exercisable([attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, unsure), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)], needs_legal_review(open_textured(earlier_measures_ineffective, cite(eu_dir_2022_2555_art_32_5)), [inputs_relied_on([earlier_measures_ineffective - unsure])]), []).
test(false_condition_settles_before_absent_provision) :-
    fine_barred_by_gdpr_fine([attribute(gdpr_fine_imposed_under_art_58_2_i, false)], fine_not_barred, [cite(eu_dir_2022_2555_art_35_2)]).
test(all_conditions_true_bar_the_fine) :-
    findall(Result, fine_barred_by_gdpr_fine([attribute(infringed_provision, art_21), attribute(infringement_may_entail_notifiable_personal_data_breach, true), attribute(gdpr_fine_imposed_under_art_58_2_i, true), attribute(gdpr_fine_for_same_conduct, true)], Result, _), Results),
    Results == [fine_barred].
test(other_provision_is_not_barred) :-
    fine_barred_by_gdpr_fine([attribute(infringed_provision, other)], fine_not_barred, [cite(eu_dir_2022_2555_art_35_2)]).
test(absent_provision_named_before_condition_keys) :-
    fine_barred_by_gdpr_fine([attribute(gdpr_fine_for_same_conduct, unsure)], indeterminate([infringed_provision]), []).
test(absent_condition_named_before_unsure_breach) :-
    fine_barred_by_gdpr_fine([attribute(infringed_provision, art_23), attribute(infringement_may_entail_notifiable_personal_data_breach, unsure), attribute(gdpr_fine_imposed_under_art_58_2_i, true)], indeterminate([gdpr_fine_for_same_conduct]), []).
test(unsure_same_conduct_goes_to_a_lawyer) :-
    fine_barred_by_gdpr_fine([attribute(infringed_provision, art_21), attribute(infringement_may_entail_notifiable_personal_data_breach, true), attribute(gdpr_fine_imposed_under_art_58_2_i, true), attribute(gdpr_fine_for_same_conduct, unsure)], needs_legal_review(open_textured(gdpr_fine_for_same_conduct, cite(eu_dir_2022_2555_art_35_2)), [inputs_relied_on([infringement_may_entail_notifiable_personal_data_breach - true, gdpr_fine_for_same_conduct - unsure])]), []).
test(unsure_breach_cites_article_35_1) :-
    fine_barred_by_gdpr_fine([attribute(infringed_provision, art_21), attribute(infringement_may_entail_notifiable_personal_data_breach, unsure), attribute(gdpr_fine_imposed_under_art_58_2_i, true), attribute(gdpr_fine_for_same_conduct, unsure)], needs_legal_review(open_textured(infringement_may_entail_notifiable_personal_data_breach, cite(eu_dir_2022_2555_art_35_1)), _), []).
test(no_awareness_means_no_duty) :-
    data_protection_authority_information([attribute(authority_became_aware_in_supervision_or_enforcement, false)], []).
test(other_provision_means_no_duty) :-
    data_protection_authority_information([attribute(infringed_provision, other)], []).
test(duty_in_own_member_state_only) :-
    data_protection_authority_information([attribute(infringed_provision, art_21), attribute(infringement_may_entail_notifiable_personal_data_breach, true), attribute(authority_became_aware_in_supervision_or_enforcement, true), attribute(data_protection_authority_in_other_member_state, false)], [inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1))]).
test(duty_lists_both_when_authority_elsewhere) :-
    findall(DutyList, data_protection_authority_information([attribute(infringed_provision, art_23), attribute(infringement_may_entail_notifiable_personal_data_breach, true), attribute(authority_became_aware_in_supervision_or_enforcement, true), attribute(data_protection_authority_in_other_member_state, true)], DutyList), Answers),
    Answers == [[inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1)), inform_supervisory_authority_in_own_member_state(cite(eu_dir_2022_2555_art_35_3))]].
test(other_member_state_named_before_referral) :-
    data_protection_authority_information([attribute(infringed_provision, art_21), attribute(infringement_may_entail_notifiable_personal_data_breach, unsure), attribute(authority_became_aware_in_supervision_or_enforcement, true)], indeterminate([data_protection_authority_in_other_member_state])).
test(unsure_breach_goes_to_a_lawyer_for_the_duty) :-
    data_protection_authority_information([attribute(infringed_provision, art_21), attribute(infringement_may_entail_notifiable_personal_data_breach, unsure), attribute(authority_became_aware_in_supervision_or_enforcement, true), attribute(data_protection_authority_in_other_member_state, false)], needs_legal_review(open_textured(infringement_may_entail_notifiable_personal_data_breach, cite(eu_dir_2022_2555_art_35_1)), [inputs_relied_on([infringement_may_entail_notifiable_personal_data_breach - unsure])])).
test(absent_breach_named_before_awareness) :-
    data_protection_authority_information([attribute(infringed_provision, art_21)], indeterminate([infringement_may_entail_notifiable_personal_data_breach])).
test(facade_eligible_when_exercisable) :-
    decide_nis2_supervision_fines([attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)], nis2_supervision_fines_verdict(eligible, [cite(eu_dir_2022_2555_art_32_5)])).
test(facade_ineligible_for_important_entity) :-
    nis2_supervision_fines_status([attribute(entity_class, important)], ineligible).
test(facade_invalid_profile) :-
    findall(Status, nis2_supervision_fines_status(not_a_list, Status), Statuses),
    Statuses == [invalid_profile].
test(checklist_rows_all_met) :-
    nis2_supervision_fines_checklist([attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, true), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)], Items),
    Items == [item(essential_entity, met, cite(eu_dir_2022_2555_art_32_5)), item(not_public_administration, met, cite(eu_dir_2022_2555_art_32_5)), item(earlier_measures_ineffective, met, cite(eu_dir_2022_2555_art_32_5)), item(deadline_set, met, cite(eu_dir_2022_2555_art_32_5)), item(action_not_taken_within_deadline, met, cite(eu_dir_2022_2555_art_32_5))].
test(checklist_marks_unsure_as_unknown) :-
    nis2_supervision_fines_checklist([attribute(entity_class, essential), attribute(earlier_measures_ineffective, unsure)], Items),
    member(item(earlier_measures_ineffective, unknown([earlier_measures_ineffective]), cite(eu_dir_2022_2555_art_32_5)), Items).
test(constructors_recognise_their_shapes) :-
    power(escalation, request_temporary_management_ban, cite(eu_dir_2022_2555_art_32_5_b)),
    not_exercisable(no_deadline_set),
    minimum_national_maximum(7000000, fixed_amount).

test(essential_tie_is_not_turnover_percentage, fail) :-
    fine_ceiling_floor([attribute(infringed_provision, art_23), attribute(entity_class, essential), attribute(worldwide_annual_turnover_eur, 500000000)], minimum_national_maximum(_, turnover_percentage), _).
test(unsure_ineffectiveness_is_not_exercisable_outright, fail) :-
    escalation_powers_exercisable([attribute(entity_class, essential), attribute(entity_is_public_administration, false), attribute(earlier_measures_ineffective, unsure), attribute(deadline_set_for_necessary_action, true), attribute(required_action_taken_within_deadline, false)], exercisable, _).
test(facade_important_entity_is_not_eligible, fail) :-
    nis2_supervision_fines_status([attribute(entity_class, important)], eligible).
