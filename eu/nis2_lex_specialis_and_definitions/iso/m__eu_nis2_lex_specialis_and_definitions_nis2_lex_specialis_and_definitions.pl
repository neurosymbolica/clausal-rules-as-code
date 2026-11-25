% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_lex_specialis_and_definitions_nis2_lex_specialis_and_definitions, [nis2_risk_management_provisions_status/3, nis2_incident_notification_provisions_status/3, decide_nis2_lex_specialis_and_definitions/2, nis2_lex_specialis_and_definitions_status/2, nis2_lex_specialis_and_definitions_checklist/2, nis2_lex_specialis_and_definitions_decision_resolvable/1, nis2_lex_specialis_and_definitions_status_values/1, nis2_provisions_disapplied/0, nis2_provisions_apply/0, out_of_scope/0, essential_entity/0, important_entity/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_kernel, [nis2_lex_specialis_and_definitions_input_problems/2]).
:- use_module(m__eu_nis2_lex_specialis_and_definitions_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).

nis2_provisions_disapplied.

nis2_provisions_apply.

out_of_scope.

essential_entity.

important_entity.

nis2_lex_specialis_and_definitions_status_values([nis2_provisions_disapplied, nis2_provisions_apply, out_of_scope]).

designated_class(essential_entity, cite(eu_reg_2022_2554_art_1_2)).
designated_class(important_entity, cite(eu_reg_2022_2554_art_1_2)).

group_citations(risk_management, [cite(eu_dir_2022_2555_art_4_1), cite(eu_dir_2022_2555_art_4_2), cite(eu_dir_2022_2555_art_4_2_a), cite(eu_reg_2022_2554_art_1_2)]).
group_citations(incident_notification, [cite(eu_dir_2022_2555_art_4_1), cite(eu_dir_2022_2555_art_4_2), cite(eu_dir_2022_2555_art_4_2_b), cite(eu_reg_2022_2554_art_1_2)]).

referral_row(risk_management_equivalence_unclear, open_textured, nis2_risk_management_provisions_status, dora_risk_management_measures_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_a), [entity_class, dora_risk_management_measures_at_least_equivalent_in_effect]).
referral_row(immediate_access_to_incident_notifications_unclear, open_textured, nis2_incident_notification_provisions_status, dora_gives_immediate_access_to_incident_notifications, cite(eu_dir_2022_2555_art_4_2_b), [entity_class, dora_gives_immediate_access_to_incident_notifications, dora_incident_notification_requirements_at_least_equivalent_in_effect]).
referral_row(incident_notification_equivalence_unclear, open_textured, nis2_incident_notification_provisions_status, dora_incident_notification_requirements_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_b), [entity_class, dora_gives_immediate_access_to_incident_notifications, dora_incident_notification_requirements_at_least_equivalent_in_effect]).

key_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
key_state(Profile, ProfileKey, Value) :-
    profile_get(Profile, ProfileKey, Value).

present_pairs(_, [], []).
present_pairs(Profile, [ProfileKey|Keys], [ProfileKey - Value|Pairs]) :-
    profile_get(Profile, ProfileKey, Value),
    present_pairs(Profile, Keys, Pairs).
present_pairs(Profile, [ProfileKey|Keys], Pairs) :-
    profile_lacks(Profile, ProfileKey),
    present_pairs(Profile, Keys, Pairs).

referral(Situation, Profile, open_textured(Input, Citation), [inputs_relied_on(Pairs)]) :-
    referral_row(Situation, open_textured, _Query, Input, Citation, Inputs),
    present_pairs(Profile, Inputs, Pairs).

nis2_risk_management_provisions_status(Profile, Result, Citations) :-
    nis2_lex_specialis_and_definitions_input_problems(Profile, Problems),
    risk_management_answer(Problems, Profile, Result, Citations).

risk_management_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
risk_management_answer([], Profile, Result, Citations) :-
    key_state(Profile, entity_class, ClassState),
    risk_management_by_class(ClassState, Profile, Result, Citations).

risk_management_by_class(absent, _, indeterminate([entity_class]), []).
risk_management_by_class(out_of_scope, _, out_of_scope, Citations) :-
    implements(eu_dir_2022_2555_art_4_1),
    group_citations(risk_management, Citations).
risk_management_by_class(Class, Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_1_2),
    designated_class(Class, _),
    key_state(Profile, dora_risk_management_measures_at_least_equivalent_in_effect, JudgementState),
    risk_management_by_judgement(JudgementState, Profile, Result, Citations).

risk_management_by_judgement(true, _, nis2_provisions_disapplied, Citations) :-
    implements(eu_dir_2022_2555_art_4_2_a),
    group_citations(risk_management, Citations).
risk_management_by_judgement(false, _, nis2_provisions_apply, Citations) :-
    implements(eu_dir_2022_2555_art_4_2_a),
    group_citations(risk_management, Citations).
risk_management_by_judgement(absent, _, indeterminate([dora_risk_management_measures_at_least_equivalent_in_effect]), []).
risk_management_by_judgement(unsure, Profile, needs_legal_review(Reason, Context), []) :-
    implements(eu_dir_2022_2555_art_4_2_a),
    referral(risk_management_equivalence_unclear, Profile, Reason, Context).

nis2_incident_notification_provisions_status(Profile, Result, Citations) :-
    nis2_lex_specialis_and_definitions_input_problems(Profile, Problems),
    incident_notification_answer(Problems, Profile, Result, Citations).

incident_notification_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
incident_notification_answer([], Profile, Result, Citations) :-
    key_state(Profile, entity_class, ClassState),
    incident_notification_by_class(ClassState, Profile, Result, Citations).

incident_notification_by_class(absent, _, indeterminate([entity_class]), []).
incident_notification_by_class(out_of_scope, _, out_of_scope, Citations) :-
    implements(eu_dir_2022_2555_art_4_1),
    group_citations(incident_notification, Citations).
incident_notification_by_class(Class, Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_1_2),
    designated_class(Class, _),
    key_state(Profile, dora_gives_immediate_access_to_incident_notifications, AccessState),
    key_state(Profile, dora_incident_notification_requirements_at_least_equivalent_in_effect, EquivalenceState),
    incident_notification_by_judgements(AccessState, EquivalenceState, Profile, Result, Citations).

not_false_state(true).
not_false_state(unsure).
not_false_state(absent).

answered_not_false_state(true).
answered_not_false_state(unsure).

incident_notification_by_judgements(false, _, _, nis2_provisions_apply, Citations) :-
    implements(eu_dir_2022_2555_art_4_2_b),
    group_citations(incident_notification, Citations).
incident_notification_by_judgements(AccessState, false, _, nis2_provisions_apply, Citations) :-
    implements(eu_dir_2022_2555_art_4_2_b),
    not_false_state(AccessState),
    group_citations(incident_notification, Citations).
incident_notification_by_judgements(absent, EquivalenceState, _, indeterminate([dora_gives_immediate_access_to_incident_notifications]), []) :-
    not_false_state(EquivalenceState).
incident_notification_by_judgements(AccessState, absent, _, indeterminate([dora_incident_notification_requirements_at_least_equivalent_in_effect]), []) :-
    answered_not_false_state(AccessState).
incident_notification_by_judgements(unsure, EquivalenceState, Profile, needs_legal_review(Reason, Context), []) :-
    implements(eu_dir_2022_2555_art_4_2_b),
    answered_not_false_state(EquivalenceState),
    referral(immediate_access_to_incident_notifications_unclear, Profile, Reason, Context).
incident_notification_by_judgements(true, unsure, Profile, needs_legal_review(Reason, Context), []) :-
    implements(eu_dir_2022_2555_art_4_2_b),
    referral(incident_notification_equivalence_unclear, Profile, Reason, Context).
incident_notification_by_judgements(true, true, _, nis2_provisions_disapplied, Citations) :-
    implements(eu_dir_2022_2555_art_4_2_b),
    group_citations(incident_notification, Citations).

decide_nis2_lex_specialis_and_definitions(Profile, nis2_lex_specialis_and_definitions_verdict(nis2_groups(RiskResult, NotificationResult), Citations)) :-
    nis2_risk_management_provisions_status(Profile, RiskResult, RiskCitations),
    nis2_incident_notification_provisions_status(Profile, NotificationResult, NotificationCitations),
    append(RiskCitations, NotificationCitations, AllCitations),
    sort(AllCitations, Citations).

nis2_lex_specialis_and_definitions_status(Profile, Status) :-
    decide_nis2_lex_specialis_and_definitions(Profile, nis2_lex_specialis_and_definitions_verdict(Status, _Citations)).

nis2_lex_specialis_and_definitions_checklist(Profile, [item(risk_management_provisions, RiskResult, RiskCitations), item(incident_notification_provisions, NotificationResult, NotificationCitations)]) :-
    nis2_risk_management_provisions_status(Profile, RiskResult, _),
    nis2_incident_notification_provisions_status(Profile, NotificationResult, _),
    group_citations(risk_management, RiskCitations),
    group_citations(incident_notification, NotificationCitations).

nis2_lex_specialis_and_definitions_decision_resolvable(Profile) :-
    decide_nis2_lex_specialis_and_definitions(Profile, _Verdict).

test(risk_essential_true_is_disapplied) :-
    findall(Result - Citations, nis2_risk_management_provisions_status([attribute(entity_class, essential_entity), attribute(dora_risk_management_measures_at_least_equivalent_in_effect, true)], Result, Citations), Answers),
    Answers == [nis2_provisions_disapplied - [cite(eu_dir_2022_2555_art_4_1), cite(eu_dir_2022_2555_art_4_2), cite(eu_dir_2022_2555_art_4_2_a), cite(eu_reg_2022_2554_art_1_2)]].
test(risk_important_false_applies) :-
    findall(Result, nis2_risk_management_provisions_status([attribute(entity_class, important_entity), attribute(dora_risk_management_measures_at_least_equivalent_in_effect, false)], Result, _), Results),
    Results == [nis2_provisions_apply].
test(risk_class_absent_named_first) :-
    findall(Result - Citations, nis2_risk_management_provisions_status([attribute(dora_risk_management_measures_at_least_equivalent_in_effect, unsure)], Result, Citations), Answers),
    Answers == [indeterminate([entity_class]) - []].
test(risk_out_of_scope_decides_alone) :-
    findall(Result, nis2_risk_management_provisions_status([attribute(entity_class, out_of_scope), attribute(dora_risk_management_measures_at_least_equivalent_in_effect, unsure)], Result, _), Results),
    Results == [out_of_scope].
test(risk_judgement_absent) :-
    findall(Result, nis2_risk_management_provisions_status([attribute(entity_class, essential_entity)], Result, _), Results),
    Results == [indeterminate([dora_risk_management_measures_at_least_equivalent_in_effect])].
test(risk_unsure_is_referred) :-
    findall(Result - Citations, nis2_risk_management_provisions_status([attribute(entity_class, essential_entity), attribute(dora_gives_immediate_access_to_incident_notifications, true), attribute(dora_risk_management_measures_at_least_equivalent_in_effect, unsure)], Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(dora_risk_management_measures_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_a)), [inputs_relied_on([entity_class - essential_entity, dora_risk_management_measures_at_least_equivalent_in_effect - unsure])]) - []].
test(incident_both_true_is_disapplied) :-
    findall(Result - Citations, nis2_incident_notification_provisions_status([attribute(entity_class, important_entity), attribute(dora_gives_immediate_access_to_incident_notifications, true), attribute(dora_incident_notification_requirements_at_least_equivalent_in_effect, true)], Result, Citations), Answers),
    Answers == [nis2_provisions_disapplied - [cite(eu_dir_2022_2555_art_4_1), cite(eu_dir_2022_2555_art_4_2), cite(eu_dir_2022_2555_art_4_2_b), cite(eu_reg_2022_2554_art_1_2)]].
test(incident_one_false_decides_alone) :-
    findall(Result, nis2_incident_notification_provisions_status([attribute(entity_class, essential_entity), attribute(dora_incident_notification_requirements_at_least_equivalent_in_effect, false)], Result, _), Results),
    Results == [nis2_provisions_apply].
test(incident_access_false_beside_unsure_applies) :-
    findall(Result, nis2_incident_notification_provisions_status([attribute(entity_class, essential_entity), attribute(dora_gives_immediate_access_to_incident_notifications, false), attribute(dora_incident_notification_requirements_at_least_equivalent_in_effect, unsure)], Result, _), Results),
    Results == [nis2_provisions_apply].
test(incident_both_absent_names_access) :-
    findall(Result, nis2_incident_notification_provisions_status([attribute(entity_class, essential_entity)], Result, _), Results),
    Results == [indeterminate([dora_gives_immediate_access_to_incident_notifications])].
test(incident_absent_named_before_unsure) :-
    findall(Result, nis2_incident_notification_provisions_status([attribute(entity_class, essential_entity), attribute(dora_gives_immediate_access_to_incident_notifications, unsure)], Result, _), Results),
    Results == [indeterminate([dora_incident_notification_requirements_at_least_equivalent_in_effect])].
test(incident_second_unsure_is_referred) :-
    findall(Result, nis2_incident_notification_provisions_status([attribute(entity_class, essential_entity), attribute(dora_gives_immediate_access_to_incident_notifications, true), attribute(dora_incident_notification_requirements_at_least_equivalent_in_effect, unsure)], Result, _), Results),
    Results == [needs_legal_review(open_textured(dora_incident_notification_requirements_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_b)), [inputs_relied_on([entity_class - essential_entity, dora_gives_immediate_access_to_incident_notifications - true, dora_incident_notification_requirements_at_least_equivalent_in_effect - unsure])])].
test(incident_first_unsure_is_referred) :-
    findall(Result, nis2_incident_notification_provisions_status([attribute(entity_class, important_entity), attribute(dora_gives_immediate_access_to_incident_notifications, unsure), attribute(dora_incident_notification_requirements_at_least_equivalent_in_effect, unsure)], Result, _), Results),
    Results == [needs_legal_review(open_textured(dora_gives_immediate_access_to_incident_notifications, cite(eu_dir_2022_2555_art_4_2_b)), [inputs_relied_on([entity_class - important_entity, dora_gives_immediate_access_to_incident_notifications - unsure, dora_incident_notification_requirements_at_least_equivalent_in_effect - unsure])])].
test(incident_out_of_scope) :-
    findall(Result, nis2_incident_notification_provisions_status([attribute(entity_class, out_of_scope)], Result, _), Results),
    Results == [out_of_scope].
test(unknown_key_is_an_input_problem) :-
    findall(Result - Citations, nis2_risk_management_provisions_status([attribute(entity_class, essential_entity), attribute(colour, blue)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(wrong_value_is_an_input_problem) :-
    findall(Result, nis2_incident_notification_provisions_status([attribute(entity_class, large)], Result, _), Results),
    Results == [input_problems([wrong_type(entity_class)])].
test(not_a_profile_is_an_input_problem) :-
    findall(Result, nis2_incident_notification_provisions_status(not_a_list, Result, _), Results),
    Results == [input_problems([wrong_type(profile)])].
test(facade_verdict_unions_citations) :-
    findall(Status, nis2_lex_specialis_and_definitions_status([attribute(entity_class, essential_entity), attribute(dora_risk_management_measures_at_least_equivalent_in_effect, true), attribute(dora_gives_immediate_access_to_incident_notifications, false)], Status), Statuses),
    Statuses == [nis2_groups(nis2_provisions_disapplied, nis2_provisions_apply)].
test(checklist_has_one_row_per_group) :-
    nis2_lex_specialis_and_definitions_checklist([attribute(entity_class, out_of_scope)], Items),
    Items = [item(risk_management_provisions, out_of_scope, [_|_]), item(incident_notification_provisions, out_of_scope, [_|_])].

test(risk_essential_true_is_not_apply, fail) :-
    nis2_risk_management_provisions_status([attribute(entity_class, essential_entity), attribute(dora_risk_management_measures_at_least_equivalent_in_effect, true)], nis2_provisions_apply, _).
