% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_policies_and_risk_management_dora_rts_policies_and_risk_management, [rts_policies_and_risk_management_duties_required/3, rts_policies_and_risk_management_duties_complete/3, rts_policies_and_risk_management_duties_outstanding/3, decide_dora_rts_policies_and_risk_management/2, dora_rts_policies_and_risk_management_status/2, dora_rts_policies_and_risk_management_checklist/2, dora_rts_policies_and_risk_management_decision_resolvable/1, dora_rts_policies_and_risk_management_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [tfilter/3, (=)/3]).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_kernel, [dora_rts_policies_and_risk_management_input_problems/2]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(library(reif), [if_/3]).

dora_rts_policies_and_risk_management_status_values([complete, incomplete, simplified_framework_entity]).

fixed_citations([cite(eu_reg_2024_1774_art_1), cite(eu_reg_2024_1774_art_2_1), cite(eu_reg_2024_1774_art_2_2), cite(eu_reg_2024_1774_art_3)]).

duty(risk_profile_and_complexity_consideration, size_risk_profile_and_complexity_taken_into_account, cite(eu_reg_2024_1774_art_1)).
duty(embedding_of_security_policies, ict_security_policies_embedded_in_ict_risk_management_framework, cite(eu_reg_2024_1774_art_2_1)).
duty(network_security, security_policies_ensure_security_of_networks, cite(eu_reg_2024_1774_art_2_1_a)).
duty(intrusion_and_data_misuse_safeguards, security_policies_contain_safeguards_against_intrusions_and_data_misuse, cite(eu_reg_2024_1774_art_2_1_b)).
duty(data_availability_authenticity_integrity_and_confidentiality, security_policies_preserve_availability_authenticity_integrity_and_confidentiality_of_data, cite(eu_reg_2024_1774_art_2_1_c)).
duty(accurate_and_prompt_data_transmission, security_policies_guarantee_accurate_and_prompt_data_transmission, cite(eu_reg_2024_1774_art_2_1_d)).
duty(alignment_to_information_security_objectives, security_policies_aligned_to_information_security_objectives, cite(eu_reg_2024_1774_art_2_2_a)).
duty(indication_of_approval_date, security_policies_indicate_date_of_management_body_approval, cite(eu_reg_2024_1774_art_2_2_b)).
duty(implementation_and_exception_indicators, security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, cite(eu_reg_2024_1774_art_2_2_c)).
duty(staff_security_responsibilities, security_policies_specify_staff_responsibilities_for_ict_security, cite(eu_reg_2024_1774_art_2_2_d)).
duty(consequences_of_non_compliance, security_policies_specify_consequences_of_staff_non_compliance, cite(eu_reg_2024_1774_art_2_2_e)).
duty(documentation_list, security_policies_list_documentation_to_be_maintained, cite(eu_reg_2024_1774_art_2_2_f)).
duty(segregation_of_duties, security_policies_specify_segregation_of_duties_arrangements, cite(eu_reg_2024_1774_art_2_2_g)).
duty(leading_practices_and_standards, security_policies_consider_leading_practices_and_standards, cite(eu_reg_2024_1774_art_2_2_h)).
duty(roles_for_security_policies, security_policies_identify_roles_for_development_implementation_and_maintenance, cite(eu_reg_2024_1774_art_2_2_i)).
duty(review_of_security_policies, security_policies_reviewed_in_accordance_with_article_6_5, cite(eu_reg_2024_1774_art_2_2_j)).
duty(material_changes, security_policies_take_material_changes_into_account, cite(eu_reg_2024_1774_art_2_2_k)).
duty(ict_risk_management_policies_and_procedures, ict_risk_management_policies_and_procedures_developed_documented_and_implemented, cite(eu_reg_2024_1774_art_3)).
duty(risk_tolerance_approval, risk_management_policies_indicate_approval_of_risk_tolerance_level, cite(eu_reg_2024_1774_art_3_a)).
duty(risk_assessment_procedure_and_methodology, risk_management_policies_contain_risk_assessment_procedure_and_methodology, cite(eu_reg_2024_1774_art_3_b)).
duty(risk_treatment_procedure, risk_management_policies_contain_risk_treatment_procedure, cite(eu_reg_2024_1774_art_3_c)).
duty(residual_risk_provisions, risk_management_policies_contain_residual_risk_provisions, cite(eu_reg_2024_1774_art_3_d)).
duty(risk_monitoring_provisions, risk_management_policies_contain_risk_monitoring_provisions, cite(eu_reg_2024_1774_art_3_e)).
duty(strategy_change_process, risk_management_policies_contain_process_for_strategy_changes, cite(eu_reg_2024_1774_art_3_f)).
duty(monitoring_of_treatment_effectiveness, risk_treatment_procedure_ensures_monitoring_of_treatment_effectiveness, cite(eu_reg_2024_1774_art_3_a_run2)).
duty(assessment_of_risk_tolerance_attainment, risk_treatment_procedure_ensures_assessment_of_risk_tolerance_attainment, cite(eu_reg_2024_1774_art_3_b_run2)).
duty(assessment_of_corrective_actions, risk_treatment_procedure_ensures_assessment_of_corrective_actions, cite(eu_reg_2024_1774_art_3_c_run2)).

key_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
key_state(Profile, ProfileKey, Value) :-
    profile_get(Profile, ProfileKey, Value).

contract_keys([financial_entity_is_article_16_1_entity|DutyKeys]) :-
    findall(ProfileKey, duty(_, ProfileKey, _), DutyKeys).

present_pairs([], _, []).
present_pairs([ProfileKey|ContractKeys], Profile, Pairs) :-
    profile_lacks(Profile, ProfileKey),
    present_pairs(ContractKeys, Profile, Pairs).
present_pairs([ProfileKey|ContractKeys], Profile, [ProfileKey - Value|LaterPairs]) :-
    profile_get(Profile, ProfileKey, Value),
    present_pairs(ContractKeys, Profile, LaterPairs).

relied_on_context(Profile, [inputs_relied_on(Pairs)]) :-
    contract_keys(ContractKeys),
    present_pairs(ContractKeys, Profile, Pairs).

duty_rows(Profile, DutyRows) :-
    findall(row(DutyAtom, ProfileKey, Citation, State), (duty(DutyAtom, ProfileKey, Citation), key_state(Profile, ProfileKey, State)), DutyRows).

first_state([], _, none).
first_state([row(DutyAtom, ProfileKey, Citation, Target)|_], Target, found(DutyAtom, ProfileKey, Citation)).
first_state([row(_, _, _, State)|DutyRows], Target, Found) :-
    dif(State, Target),
    first_state(DutyRows, Target, Found).

gate_state(Profile, GateValue) :-
    key_state(Profile, financial_entity_is_article_16_1_entity, GateValue).

failing_duties(DutyRows, FailingDuties) :-
    implements(eu_reg_2024_1774_art_3),
    findall(DutyAtom, member(row(DutyAtom, _, _, false), DutyRows), FailingDuties).

failing_citations(DutyRows, FailingCitations) :-
    implements(eu_reg_2024_1774_art_3),
    findall(Citation, member(row(_, _, Citation, false), DutyRows), FailingCitations).

rts_policies_and_risk_management_duties_required(Profile, input_problems([Problem|Problems]), []) :-
    dora_rts_policies_and_risk_management_input_problems(Profile, [Problem|Problems]).
rts_policies_and_risk_management_duties_required(Profile, Result, Citations) :-
    dora_rts_policies_and_risk_management_input_problems(Profile, []),
    gate_state(Profile, GateValue),
    required_after_gate(GateValue, Result, Citations).

required_after_gate(true, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).
required_after_gate(absent, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
required_after_gate(false, required(Duties), Citations) :-
    implements(eu_reg_2024_1774_art_1),
    findall(DutyAtom, duty(DutyAtom, _, _), Duties),
    fixed_citations(Citations).

rts_policies_and_risk_management_duties_complete(Profile, input_problems([Problem|Problems]), []) :-
    dora_rts_policies_and_risk_management_input_problems(Profile, [Problem|Problems]).
rts_policies_and_risk_management_duties_complete(Profile, Result, Citations) :-
    dora_rts_policies_and_risk_management_input_problems(Profile, []),
    gate_state(Profile, GateValue),
    complete_after_gate(GateValue, Profile, Result, Citations).

complete_after_gate(true, _, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).
complete_after_gate(absent, _, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
complete_after_gate(false, Profile, Result, Citations) :-
    implements(eu_reg_2024_1774_art_3),
    duty_rows(Profile, DutyRows),
    first_state(DutyRows, false, FirstFalse),
    first_state(DutyRows, absent, FirstAbsent),
    first_state(DutyRows, unsure, FirstUnsure),
    complete_answer(FirstFalse, FirstAbsent, FirstUnsure, Profile, Result, Citations).

complete_answer(found(_, _, _), _, _, _, incomplete, Citations) :-
    implements(eu_reg_2024_1774_art_3),
    fixed_citations(Citations).
complete_answer(none, found(_, ProfileKey, _), _, _, indeterminate([ProfileKey]), []) :-
    implements(eu_reg_2024_1774_art_3).
complete_answer(none, none, found(_, ProfileKey, Citation), Profile, needs_legal_review(open_textured(ProfileKey, Citation), Context), []) :-
    implements(eu_reg_2024_1774_art_3),
    relied_on_context(Profile, Context).
complete_answer(none, none, none, _, complete, Citations) :-
    implements(eu_reg_2024_1774_art_3),
    fixed_citations(Citations).

rts_policies_and_risk_management_duties_outstanding(Profile, input_problems([Problem|Problems]), []) :-
    dora_rts_policies_and_risk_management_input_problems(Profile, [Problem|Problems]).
rts_policies_and_risk_management_duties_outstanding(Profile, Result, Citations) :-
    dora_rts_policies_and_risk_management_input_problems(Profile, []),
    gate_state(Profile, GateValue),
    outstanding_after_gate(GateValue, Profile, Result, Citations).

outstanding_after_gate(true, _, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).
outstanding_after_gate(absent, _, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
outstanding_after_gate(false, Profile, Result, Citations) :-
    implements(eu_reg_2024_1774_art_3),
    duty_rows(Profile, DutyRows),
    first_state(DutyRows, absent, FirstAbsent),
    first_state(DutyRows, unsure, FirstUnsure),
    failing_duties(DutyRows, FailingDuties),
    outstanding_answer(FirstAbsent, FirstUnsure, FailingDuties, Profile, DutyRows, Result, Citations).

outstanding_answer(found(_, ProfileKey, _), _, _, _, _, indeterminate([ProfileKey]), []) :-
    implements(eu_reg_2024_1774_art_3).
outstanding_answer(none, found(_, ProfileKey, Citation), _, Profile, _, needs_legal_review(open_textured(ProfileKey, Citation), Context), []) :-
    implements(eu_reg_2024_1774_art_3),
    relied_on_context(Profile, Context).
outstanding_answer(none, none, [], _, _, none_outstanding, Citations) :-
    implements(eu_reg_2024_1774_art_3),
    fixed_citations(Citations).
outstanding_answer(none, none, [FirstDuty|LaterDuties], _, DutyRows, outstanding([FirstDuty|LaterDuties]), Citations) :-
    implements(eu_reg_2024_1774_art_3),
    failing_citations(DutyRows, Citations).

decide_dora_rts_policies_and_risk_management(Profile, dora_rts_policies_and_risk_management_verdict(Result, Citations)) :-
    rts_policies_and_risk_management_duties_complete(Profile, Result, Citations).

dora_rts_policies_and_risk_management_status(Profile, Status) :-
    decide_dora_rts_policies_and_risk_management(Profile, dora_rts_policies_and_risk_management_verdict(Status, _Citations)).

dora_rts_policies_and_risk_management_checklist(Profile, []) :-
    dora_rts_policies_and_risk_management_input_problems(Profile, [_|_]).
dora_rts_policies_and_risk_management_checklist(Profile, Items) :-
    dora_rts_policies_and_risk_management_input_problems(Profile, []),
    gate_state(Profile, GateValue),
    checklist_after_gate(GateValue, Profile, Items).

checklist_after_gate(true, _, [item(simplified_framework_entity, met, cite(eu_reg_2022_2554_art_16_1))]) :-
    implements(eu_reg_2022_2554_art_16_1).
checklist_after_gate(absent, _, [item(simplified_framework_entity, unknown([financial_entity_is_article_16_1_entity]), cite(eu_reg_2022_2554_art_16_1))]) :-
    implements(eu_reg_2022_2554_art_16_1).
checklist_after_gate(false, Profile, Items) :-
    implements(eu_reg_2024_1774_art_3),
    duty_rows(Profile, DutyRows),
    maplist(duty_item, DutyRows, Items).

duty_item(row(DutyAtom, _, Citation, true), item(DutyAtom, met, Citation)).
duty_item(row(DutyAtom, _, Citation, false), item(DutyAtom, unmet(not_performed), Citation)).
duty_item(row(DutyAtom, ProfileKey, Citation, unsure), item(DutyAtom, unknown([ProfileKey]), Citation)).
duty_item(row(DutyAtom, ProfileKey, Citation, absent), item(DutyAtom, unknown([ProfileKey]), Citation)).

dora_rts_policies_and_risk_management_decision_resolvable(Profile) :-
    decide_dora_rts_policies_and_risk_management(Profile, _Verdict).

all_true_profile([attribute(financial_entity_is_article_16_1_entity, false)|DutyAttributes]) :-
    findall(attribute(ProfileKey, true), duty(_, ProfileKey, _), DutyAttributes).

with_value(Profile, ProfileKey, Value, NewProfile) :-
    maplist(replaced_attribute(ProfileKey, Value), Profile, NewProfile).

replaced_attribute(ProfileKey, Value, attribute(OtherKey, OldValue), attribute(OtherKey, NewValue)) :-
    if_(OtherKey = ProfileKey, NewValue = Value, NewValue = OldValue).

without_key(Profile, ProfileKey, NewProfile) :-
    tfilter(attribute_kept_t(ProfileKey), Profile, NewProfile).

attribute_kept_t(ProfileKey, attribute(OtherKey, _), Truth) :-
    if_(OtherKey = ProfileKey, Truth = false, Truth = true).

test(twenty_seven_duties) :-
    findall(DutyAtom, duty(DutyAtom, _, _), Duties),
    length(Duties, 27).
test(required_lists_every_duty_in_order) :-
    all_true_profile(Profile),
    findall(Result - Citations, rts_policies_and_risk_management_duties_required(Profile, Result, Citations), Answers),
    Answers = [required(Duties) - Citations],
    length(Duties, 27),
    Duties = [risk_profile_and_complexity_consideration, embedding_of_security_policies|_],
    last(Duties, assessment_of_corrective_actions),
    fixed_citations(Citations).
test(gate_true_is_simplified_framework_entity) :-
    all_true_profile(Profile),
    with_value(Profile, financial_entity_is_article_16_1_entity, true, GateProfile),
    findall(Result - Citations, rts_policies_and_risk_management_duties_complete(GateProfile, Result, Citations), Answers),
    Answers == [simplified_framework_entity - [cite(eu_reg_2022_2554_art_16_1)]].
test(gate_absent_is_asked_first) :-
    findall(Result - Citations, rts_policies_and_risk_management_duties_outstanding([attribute(security_policies_ensure_security_of_networks, false)], Result, Citations), Answers),
    Answers == [indeterminate([financial_entity_is_article_16_1_entity]) - []].
test(every_duty_true_is_complete_once) :-
    all_true_profile(Profile),
    findall(Result - Citations, rts_policies_and_risk_management_duties_complete(Profile, Result, Citations), Answers),
    Answers == [complete - [cite(eu_reg_2024_1774_art_1), cite(eu_reg_2024_1774_art_2_1), cite(eu_reg_2024_1774_art_2_2), cite(eu_reg_2024_1774_art_3)]].
test(every_duty_true_is_none_outstanding) :-
    all_true_profile(Profile),
    findall(Result, rts_policies_and_risk_management_duties_outstanding(Profile, Result, _), Answers),
    Answers == [none_outstanding].
test(a_false_duty_decides_complete_before_an_absent_key) :-
    all_true_profile(Profile),
    without_key(Profile, size_risk_profile_and_complexity_taken_into_account, ShortProfile),
    with_value(ShortProfile, security_policies_ensure_security_of_networks, false, FailingProfile),
    findall(Result, rts_policies_and_risk_management_duties_complete(FailingProfile, Result, _), Answers),
    Answers == [incomplete].
test(outstanding_asks_the_absent_key_despite_a_false_duty) :-
    all_true_profile(Profile),
    without_key(Profile, size_risk_profile_and_complexity_taken_into_account, ShortProfile),
    with_value(ShortProfile, security_policies_ensure_security_of_networks, false, FailingProfile),
    findall(Result - Citations, rts_policies_and_risk_management_duties_outstanding(FailingProfile, Result, Citations), Answers),
    Answers == [indeterminate([size_risk_profile_and_complexity_taken_into_account]) - []].
test(absent_key_named_before_unsure) :-
    all_true_profile(Profile),
    with_value(Profile, size_risk_profile_and_complexity_taken_into_account, unsure, UnsureProfile),
    without_key(UnsureProfile, risk_management_policies_contain_risk_treatment_procedure, ShortProfile),
    rts_policies_and_risk_management_duties_complete(ShortProfile, indeterminate([risk_management_policies_contain_risk_treatment_procedure]), []).
test(unsure_duty_goes_to_a_lawyer_with_every_present_pair) :-
    all_true_profile(Profile),
    with_value(Profile, size_risk_profile_and_complexity_taken_into_account, unsure, UnsureProfile),
    findall(Result - Citations, rts_policies_and_risk_management_duties_complete(UnsureProfile, Result, Citations), Answers),
    Answers = [needs_legal_review(open_textured(size_risk_profile_and_complexity_taken_into_account, cite(eu_reg_2024_1774_art_1)), [inputs_relied_on(Pairs)]) - []],
    length(Pairs, 28),
    Pairs = [financial_entity_is_article_16_1_entity - false, size_risk_profile_and_complexity_taken_into_account - unsure|_].
test(outstanding_lists_failing_duties_with_their_own_citations) :-
    all_true_profile(Profile),
    with_value(Profile, security_policies_ensure_security_of_networks, false, FirstProfile),
    with_value(FirstProfile, risk_treatment_procedure_ensures_assessment_of_corrective_actions, false, SecondProfile),
    findall(Result - Citations, rts_policies_and_risk_management_duties_outstanding(SecondProfile, Result, Citations), Answers),
    Answers == [outstanding([network_security, assessment_of_corrective_actions]) - [cite(eu_reg_2024_1774_art_2_1_a), cite(eu_reg_2024_1774_art_3_c_run2)]].
test(input_problems_come_first) :-
    findall(Result - Citations, rts_policies_and_risk_management_duties_required([attribute(colour, 3)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(checklist_has_a_cited_row_per_duty) :-
    all_true_profile(Profile),
    with_value(Profile, security_policies_ensure_security_of_networks, false, FailingProfile),
    dora_rts_policies_and_risk_management_checklist(FailingProfile, Items),
    length(Items, 27),
    member(item(network_security, unmet(not_performed), cite(eu_reg_2024_1774_art_2_1_a)), Items),
    member(item(risk_profile_and_complexity_consideration, met, cite(eu_reg_2024_1774_art_1)), Items).
test(verdict_projects_the_complete_query) :-
    all_true_profile(Profile),
    dora_rts_policies_and_risk_management_status(Profile, complete).

test(gate_true_is_not_complete, fail) :-
    all_true_profile(Profile),
    with_value(Profile, financial_entity_is_article_16_1_entity, true, GateProfile),
    rts_policies_and_risk_management_duties_complete(GateProfile, complete, _).
test(unsure_duty_is_not_complete, fail) :-
    all_true_profile(Profile),
    with_value(Profile, size_risk_profile_and_complexity_taken_into_account, unsure, UnsureProfile),
    rts_policies_and_risk_management_duties_complete(UnsureProfile, complete, _).
test(input_problems_are_not_a_final_answer, fail) :-
    rts_policies_and_risk_management_duties_complete([attribute(financial_entity_is_article_16_1_entity, unsure)], complete, _).
