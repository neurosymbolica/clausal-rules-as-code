% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_resilience_testing_programme_dora_resilience_testing_programme, [resilience_testing_duties_required/3, resilience_testing_duties_complete/3, resilience_testing_duties_outstanding/3, decide_dora_resilience_testing_programme/2, dora_resilience_testing_programme_status/2, dora_resilience_testing_programme_checklist/2, dora_resilience_testing_programme_decision_resolvable/1, dora_resilience_testing_programme_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys_values/3]).
:- use_module(m__eu_dora_resilience_testing_programme_kernel, [dora_resilience_testing_programme_input_problems/2, present_pairs/2]).
:- use_module(m__eu_dora_resilience_testing_programme_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).

duty_row(1, resilience_testing_programme, cite(eu_reg_2022_2554_art_24_1), resilience_testing_programme_established_maintained_and_reviewed, always).
duty_row(2, range_of_assessments_and_tests, cite(eu_reg_2022_2554_art_24_2), programme_includes_range_of_assessments_and_tests, always).
duty_row(3, risk_based_testing_approach, cite(eu_reg_2022_2554_art_24_3), programme_conducted_on_risk_based_approach, always).
duty_row(4, independent_testers, cite(eu_reg_2022_2554_art_24_4), tests_undertaken_by_independent_parties, always).
duty_row(5, internal_tester_resources_and_conflicts_of_interest, cite(eu_reg_2022_2554_art_24_4), internal_tester_resourced_and_conflicts_of_interest_avoided, internal_tester).
duty_row(6, issue_prioritisation_classification_and_remedy, cite(eu_reg_2022_2554_art_24_5), procedures_to_prioritise_classify_and_remedy_issues_established, always).
duty_row(7, internal_validation_methodologies, cite(eu_reg_2022_2554_art_24_5), internal_validation_methodologies_established, always).
duty_row(8, yearly_testing_of_critical_ict_systems, cite(eu_reg_2022_2554_art_24_6), critical_ict_systems_tested_at_least_yearly, always).
duty_row(9, execution_of_appropriate_tests, cite(eu_reg_2022_2554_art_25_1), programme_provides_for_appropriate_tests, always).
duty_row(10, vulnerability_assessments_before_deployment, cite(eu_reg_2022_2554_art_25_2), vulnerability_assessments_performed_before_deployment, central_type).
duty_row(11, microenterprise_risk_based_planned_testing, cite(eu_reg_2022_2554_art_25_3), microenterprise_tests_risk_based_and_planned, microenterprise).

checked_citations([cite(eu_reg_2022_2554_art_24_1), cite(eu_reg_2022_2554_art_24_2), cite(eu_reg_2022_2554_art_24_3), cite(eu_reg_2022_2554_art_24_4), cite(eu_reg_2022_2554_art_24_5), cite(eu_reg_2022_2554_art_24_6), cite(eu_reg_2022_2554_art_25_1), cite(eu_reg_2022_2554_art_25_2), cite(eu_reg_2022_2554_art_25_3)]).

dora_resilience_testing_programme_status_values([complete, incomplete, indeterminate(_), needs_legal_review(_, _), input_problems(_)]).

key_value(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
key_value(Profile, ProfileKey, Value) :-
    profile_has(Profile, ProfileKey),
    profile_get(Profile, ProfileKey, Value).

tester_condition(true, on) :-
    implements(eu_reg_2022_2554_art_24_4).
tester_condition(false, off) :-
    implements(eu_reg_2022_2554_art_24_4).
tester_condition(absent, unknown) :-
    implements(eu_reg_2022_2554_art_24_4).

type_condition(absent, unknown) :-
    implements(eu_reg_2022_2554_art_25_2).
type_condition(central_securities_depository, on) :-
    implements(eu_reg_2022_2554_art_25_2).
type_condition(central_counterparty, on) :-
    implements(eu_reg_2022_2554_art_25_2).
type_condition(EntityType, off) :-
    implements(eu_reg_2022_2554_art_25_2),
    dif(EntityType, absent),
    dif(EntityType, central_securities_depository),
    dif(EntityType, central_counterparty).

branch_applicability(always) :-
    implements(eu_reg_2022_2554_art_24_1).
branch_applicability(internal_tester) :-
    implements(eu_reg_2022_2554_art_24_4).
branch_applicability(central_type) :-
    implements(eu_reg_2022_2554_art_25_2).

duty_condition(always, _, _, on) :-
    implements(eu_reg_2022_2554_art_24_1).
duty_condition(internal_tester, TesterCondition, _, TesterCondition) :-
    implements(eu_reg_2022_2554_art_24_4).
duty_condition(central_type, _, TypeCondition, TypeCondition) :-
    implements(eu_reg_2022_2554_art_25_2).

conditional_status(true, on, passes).
conditional_status(false, on, fails).
conditional_status(unsure, on, open).
conditional_status(absent, on, open).
conditional_status(true, off, passes).
conditional_status(false, off, passes).
conditional_status(unsure, off, passes).
conditional_status(absent, off, passes).
conditional_status(true, unknown, passes).
conditional_status(false, unknown, open).
conditional_status(unsure, unknown, open).
conditional_status(absent, unknown, open).

status_meet(fails, fails, fails).
status_meet(fails, passes, fails).
status_meet(fails, open, fails).
status_meet(passes, fails, fails).
status_meet(open, fails, fails).
status_meet(passes, passes, passes).
status_meet(passes, open, open).
status_meet(open, passes, open).
status_meet(open, open, open).

entry_status(entry(_, _, _, DutyValue, Condition), Status) :-
    conditional_status(DutyValue, Condition, Status).

branch_status(Entries, Branch) :-
    maplist(entry_status, Entries, Statuses),
    foldl(status_meet, Statuses, passes, Branch).

fact_key_role(false, strong).
fact_key_role(unsure, weak).
fact_key_role(absent, weak).
fact_key_role(true, inert).

fact_kind(absent, DependentValue, KeyKind) :-
    fact_key_role(DependentValue, KeyKind).
fact_kind(Value, _, inert) :-
    dif(Value, absent).

condition_role(on, strong).
condition_role(unknown, weak).
condition_role(off, inert).

unsure_role(on, referable).
unsure_role(unknown, referable).
unsure_role(off, inert).

duty_kind(absent, Condition, KeyKind) :-
    condition_role(Condition, KeyKind).
duty_kind(unsure, Condition, KeyKind) :-
    unsure_role(Condition, KeyKind).
duty_kind(true, _, inert).
duty_kind(false, _, inert).

entry_kind(entry(_, _, ProfileKey, DutyValue, Condition), ProfileKey - KeyKind) :-
    duty_kind(DutyValue, Condition, KeyKind).

keys_of_kind(KindPairs, KeyKind, ProfileKeys) :-
    findall(ProfileKey, member(ProfileKey - KeyKind, KindPairs), ProfileKeys).

absent_kind(strong).
absent_kind(weak).

absent_keys(KindPairs, ProfileKeys) :-
    findall(ProfileKey, (member(ProfileKey - KeyKind, KindPairs), absent_kind(KeyKind)), ProfileKeys).

branch_entries(Profile, TesterCondition, TypeCondition, Entries) :-
    findall(entry(DutyAtom, Citation, ProfileKey, DutyValue, Condition), (duty_row(_, DutyAtom, Citation, ProfileKey, Applicability), branch_applicability(Applicability), key_value(Profile, ProfileKey, DutyValue), duty_condition(Applicability, TesterCondition, TypeCondition, Condition)), Entries).

profile_reading(Profile, Micro, MicroDuty, Entries, Branch, KindPairs) :-
    key_value(Profile, financial_entity_is_microenterprise, Micro),
    key_value(Profile, microenterprise_tests_risk_based_and_planned, MicroDuty),
    key_value(Profile, dora_entity_type, EntityType),
    key_value(Profile, tests_undertaken_by_internal_tester, TesterValue),
    key_value(Profile, internal_tester_resourced_and_conflicts_of_interest_avoided, InternalTesterDuty),
    key_value(Profile, vulnerability_assessments_performed_before_deployment, VulnerabilityDuty),
    tester_condition(TesterValue, TesterCondition),
    type_condition(EntityType, TypeCondition),
    branch_entries(Profile, TesterCondition, TypeCondition, Entries),
    branch_status(Entries, Branch),
    fact_kind(EntityType, VulnerabilityDuty, TypeKind),
    fact_kind(TesterValue, InternalTesterDuty, TesterKind),
    maplist(entry_kind, Entries, DutyKinds),
    KindPairs = [dora_entity_type - TypeKind, tests_undertaken_by_internal_tester - TesterKind|DutyKinds].

outcome_answer(settled(Answer), _, Answer, Citations) :-
    checked_citations(Citations).
outcome_answer(listed(Answer, Citations), _, Answer, Citations).
outcome_answer(missing(ProfileKey), _, indeterminate([ProfileKey]), []).
outcome_answer(refer(ProfileKey), Profile, needs_legal_review(open_textured(ProfileKey, Citation), [inputs_relied_on(Pairs)]), []) :-
    duty_row(_, _, Citation, ProfileKey, _),
    present_pairs(Profile, Pairs).

resilience_testing_duties_required(Profile, Result, Citations) :-
    dora_resilience_testing_programme_input_problems(Profile, Problems),
    required_answer(Problems, Profile, Result, Citations).

required_answer([FirstProblem|LaterProblems], _, input_problems([FirstProblem|LaterProblems]), []).
required_answer([], Profile, Result, Citations) :-
    key_value(Profile, financial_entity_is_microenterprise, Micro),
    key_value(Profile, dora_entity_type, EntityType),
    key_value(Profile, tests_undertaken_by_internal_tester, TesterValue),
    required_outcome(Micro, EntityType, TesterValue, Outcome),
    outcome_answer(Outcome, Profile, Result, Citations).

required_outcome(absent, _, _, missing(financial_entity_is_microenterprise)) :-
    implements(eu_reg_2022_2554_art_24_1).
required_outcome(true, _, _, listed(required([microenterprise_risk_based_planned_testing]), [cite(eu_reg_2022_2554_art_25_3)])) :-
    implements(eu_reg_2022_2554_art_25_3).
required_outcome(false, absent, _, missing(dora_entity_type)) :-
    implements(eu_reg_2022_2554_art_25_2).
required_outcome(false, EntityType, absent, missing(tests_undertaken_by_internal_tester)) :-
    implements(eu_reg_2022_2554_art_24_4),
    dif(EntityType, absent).
required_outcome(false, EntityType, TesterValue, listed(required(Duties), Citations)) :-
    implements(eu_reg_2022_2554_art_24_1),
    dif(EntityType, absent),
    dif(TesterValue, absent),
    tester_condition(TesterValue, TesterCondition),
    type_condition(EntityType, TypeCondition),
    required_duties(TesterCondition, TypeCondition, Duties, Citations).

required_duties(TesterCondition, TypeCondition, Duties, Citations) :-
    findall(DutyAtom - Citation, (duty_row(_, DutyAtom, Citation, _, Applicability), branch_applicability(Applicability), duty_condition(Applicability, TesterCondition, TypeCondition, on)), Pairs),
    pairs_keys_values(Pairs, Duties, CitationList),
    sort(CitationList, Citations).

resilience_testing_duties_complete(Profile, Result, Citations) :-
    dora_resilience_testing_programme_input_problems(Profile, Problems),
    complete_answer(Problems, Profile, Result, Citations).

complete_answer([FirstProblem|LaterProblems], _, input_problems([FirstProblem|LaterProblems]), []).
complete_answer([], Profile, Result, Citations) :-
    profile_reading(Profile, Micro, MicroDuty, _, Branch, KindPairs),
    complete_outcome(Micro, MicroDuty, Branch, KindPairs, Outcome),
    outcome_answer(Outcome, Profile, Result, Citations).

complete_outcome(true, MicroDuty, _, _, Outcome) :-
    implements(eu_reg_2022_2554_art_25_3),
    micro_complete(MicroDuty, Outcome).
complete_outcome(false, _, fails, _, settled(incomplete)) :-
    implements(eu_reg_2022_2554_art_24_1).
complete_outcome(false, _, passes, _, settled(complete)) :-
    implements(eu_reg_2022_2554_art_24_1).
complete_outcome(false, _, open, KindPairs, Outcome) :-
    implements(eu_reg_2022_2554_art_24_1),
    keys_of_kind(KindPairs, strong, StrongKeys),
    keys_of_kind(KindPairs, weak, WeakKeys),
    keys_of_kind(KindPairs, referable, ReferableKeys),
    pick_complete(StrongKeys, WeakKeys, ReferableKeys, Outcome).
complete_outcome(absent, MicroDuty, Branch, _, Outcome) :-
    implements(eu_reg_2022_2554_art_24_1),
    absent_micro_complete(MicroDuty, Branch, Outcome).

micro_complete(true, settled(complete)).
micro_complete(false, settled(incomplete)).
micro_complete(absent, missing(microenterprise_tests_risk_based_and_planned)).
micro_complete(unsure, refer(microenterprise_tests_risk_based_and_planned)).

absent_micro_complete(false, fails, settled(incomplete)).
absent_micro_complete(false, passes, missing(financial_entity_is_microenterprise)).
absent_micro_complete(false, open, missing(financial_entity_is_microenterprise)).
absent_micro_complete(true, passes, settled(complete)).
absent_micro_complete(true, fails, missing(financial_entity_is_microenterprise)).
absent_micro_complete(true, open, missing(financial_entity_is_microenterprise)).
absent_micro_complete(unsure, _, missing(financial_entity_is_microenterprise)).
absent_micro_complete(absent, _, missing(financial_entity_is_microenterprise)).

pick_complete([FirstKey|_], _, _, missing(FirstKey)).
pick_complete([], [FirstKey|_], _, missing(FirstKey)).
pick_complete([], [], [FirstKey|_], refer(FirstKey)).

resilience_testing_duties_outstanding(Profile, Result, Citations) :-
    dora_resilience_testing_programme_input_problems(Profile, Problems),
    outstanding_answer(Problems, Profile, Result, Citations).

outstanding_answer([FirstProblem|LaterProblems], _, input_problems([FirstProblem|LaterProblems]), []).
outstanding_answer([], Profile, Result, Citations) :-
    profile_reading(Profile, Micro, MicroDuty, Entries, Branch, KindPairs),
    outstanding_outcome(Micro, MicroDuty, Branch, KindPairs, Entries, Outcome),
    outcome_answer(Outcome, Profile, Result, Citations).

outstanding_outcome(absent, MicroDuty, Branch, _, _, Outcome) :-
    implements(eu_reg_2022_2554_art_24_1),
    absent_micro_outstanding(MicroDuty, Branch, Outcome).
outstanding_outcome(true, MicroDuty, _, _, _, Outcome) :-
    implements(eu_reg_2022_2554_art_25_3),
    micro_outstanding(MicroDuty, Outcome).
outstanding_outcome(false, _, _, KindPairs, Entries, Outcome) :-
    implements(eu_reg_2022_2554_art_24_1),
    absent_keys(KindPairs, AbsentKeys),
    keys_of_kind(KindPairs, referable, ReferableKeys),
    pick_outstanding(AbsentKeys, ReferableKeys, Entries, Outcome).

absent_micro_outstanding(true, passes, settled(none_outstanding)).
absent_micro_outstanding(true, fails, missing(financial_entity_is_microenterprise)).
absent_micro_outstanding(true, open, missing(financial_entity_is_microenterprise)).
absent_micro_outstanding(false, _, missing(financial_entity_is_microenterprise)).
absent_micro_outstanding(unsure, _, missing(financial_entity_is_microenterprise)).
absent_micro_outstanding(absent, _, missing(financial_entity_is_microenterprise)).

micro_outstanding(true, settled(none_outstanding)).
micro_outstanding(false, listed(outstanding([microenterprise_risk_based_planned_testing]), [cite(eu_reg_2022_2554_art_25_3)])).
micro_outstanding(absent, missing(microenterprise_tests_risk_based_and_planned)).
micro_outstanding(unsure, refer(microenterprise_tests_risk_based_and_planned)).

pick_outstanding([FirstKey|_], _, _, missing(FirstKey)).
pick_outstanding([], [FirstKey|_], _, refer(FirstKey)).
pick_outstanding([], [], Entries, Outcome) :-
    outstanding_list(Entries, Duties, Citations),
    final_outstanding(Duties, Citations, Outcome).

outstanding_list(Entries, Duties, Citations) :-
    findall(DutyAtom - Citation, member(entry(DutyAtom, Citation, _, false, on), Entries), Pairs),
    pairs_keys_values(Pairs, Duties, CitationList),
    sort(CitationList, Citations).

final_outstanding([], _, settled(none_outstanding)).
final_outstanding([FirstDuty|LaterDuties], Citations, listed(outstanding([FirstDuty|LaterDuties]), Citations)).

decide_dora_resilience_testing_programme(Profile, dora_resilience_testing_programme_verdict(Status, Citations)) :-
    resilience_testing_duties_complete(Profile, Status, Citations).

dora_resilience_testing_programme_status(Profile, Status) :-
    decide_dora_resilience_testing_programme(Profile, dora_resilience_testing_programme_verdict(Status, _)).

dora_resilience_testing_programme_decision_resolvable(Profile) :-
    decide_dora_resilience_testing_programme(Profile, _).

dora_resilience_testing_programme_checklist(Profile, Items) :-
    dora_resilience_testing_programme_input_problems(Profile, Problems),
    checklist_items(Problems, Profile, Items).

checklist_items([_|_], _, []).
checklist_items([], Profile, Items) :-
    key_value(Profile, financial_entity_is_microenterprise, Micro),
    key_value(Profile, dora_entity_type, EntityType),
    key_value(Profile, tests_undertaken_by_internal_tester, TesterValue),
    tester_condition(TesterValue, TesterCondition),
    type_condition(EntityType, TypeCondition),
    findall(item(DutyAtom, Status, Citation), (duty_row(_, DutyAtom, Citation, ProfileKey, Applicability), key_value(Profile, ProfileKey, DutyValue), effective_condition(Micro, Applicability, TesterCondition, TypeCondition, Effective), checklist_status(DutyValue, Effective, ProfileKey, Status)), Items).

effective_condition(Micro, microenterprise, _, _, Effective) :-
    implements(eu_reg_2022_2554_art_25_3),
    micro_condition(Micro, Effective).
effective_condition(Micro, Applicability, TesterCondition, TypeCondition, Effective) :-
    implements(eu_reg_2022_2554_art_24_1),
    branch_applicability(Applicability),
    duty_condition(Applicability, TesterCondition, TypeCondition, Own),
    gated_condition(Micro, Own, Effective).

micro_condition(true, on).
micro_condition(false, off).
micro_condition(absent, unknown).

gated_condition(false, Own, Own).
gated_condition(true, _, off).
gated_condition(absent, off, off).
gated_condition(absent, on, unknown).
gated_condition(absent, unknown, unknown).

checklist_status(_, off, _, inapplicable).
checklist_status(true, on, _, met).
checklist_status(false, on, ProfileKey, unmet(ProfileKey)).
checklist_status(unsure, on, ProfileKey, unknown([ProfileKey])).
checklist_status(absent, on, ProfileKey, unknown([ProfileKey])).
checklist_status(true, unknown, _, met).
checklist_status(false, unknown, ProfileKey, unknown([ProfileKey])).
checklist_status(unsure, unknown, ProfileKey, unknown([ProfileKey])).
checklist_status(absent, unknown, ProfileKey, unknown([ProfileKey])).

pair_attribute(ProfileKey - Value, attribute(ProfileKey, Value)).

test_profile(Pairs, Profile) :-
    maplist(pair_attribute, Pairs, Profile).

always_true_pairs([resilience_testing_programme_established_maintained_and_reviewed - true, programme_includes_range_of_assessments_and_tests - true, programme_conducted_on_risk_based_approach - true, tests_undertaken_by_independent_parties - true, procedures_to_prioritise_classify_and_remedy_issues_established - true, internal_validation_methodologies_established - true, critical_ict_systems_tested_at_least_yearly - true, programme_provides_for_appropriate_tests - true]).

passing_branch_profile(Profile) :-
    always_true_pairs(AlwaysPairs),
    append([financial_entity_is_microenterprise - false, dora_entity_type - credit_institution, tests_undertaken_by_internal_tester - false], AlwaysPairs, Pairs),
    test_profile(Pairs, Profile).

test(a_microenterprise_has_one_duty) :-
    test_profile([financial_entity_is_microenterprise - true], Profile),
    findall(Result - Citations, resilience_testing_duties_required(Profile, Result, Citations), Answers),
    Answers == [required([microenterprise_risk_based_planned_testing]) - [cite(eu_reg_2022_2554_art_25_3)]].
test(a_central_counterparty_with_an_internal_tester_has_ten_duties) :-
    test_profile([financial_entity_is_microenterprise - false, dora_entity_type - central_counterparty, tests_undertaken_by_internal_tester - true], Profile),
    resilience_testing_duties_required(Profile, required(Duties), Citations),
    Duties == [resilience_testing_programme, range_of_assessments_and_tests, risk_based_testing_approach, independent_testers, internal_tester_resources_and_conflicts_of_interest, issue_prioritisation_classification_and_remedy, internal_validation_methodologies, yearly_testing_of_critical_ict_systems, execution_of_appropriate_tests, vulnerability_assessments_before_deployment],
    length(Citations, 8).
test(a_credit_institution_without_internal_tester_has_eight_duties) :-
    test_profile([financial_entity_is_microenterprise - false, dora_entity_type - credit_institution, tests_undertaken_by_internal_tester - false], Profile),
    resilience_testing_duties_required(Profile, required(Duties), Citations),
    length(Duties, 8),
    length(Citations, 7).
test(required_asks_the_size_question_first) :-
    resilience_testing_duties_required([], Result, Citations),
    Result == indeterminate([financial_entity_is_microenterprise]),
    Citations == [].
test(required_asks_the_type_before_the_tester) :-
    test_profile([financial_entity_is_microenterprise - false], Profile),
    resilience_testing_duties_required(Profile, indeterminate([dora_entity_type]), []).
test(a_passing_branch_is_complete) :-
    passing_branch_profile(Profile),
    findall(Result - Citations, resilience_testing_duties_complete(Profile, Result, Citations), Answers),
    checked_citations(Checked),
    Answers == [complete - Checked].
test(one_false_duty_is_incomplete_whatever_is_absent) :-
    test_profile([financial_entity_is_microenterprise - false, tests_undertaken_by_independent_parties - false], Profile),
    resilience_testing_duties_complete(Profile, incomplete, Citations),
    length(Citations, 9).
test(an_absent_size_key_with_both_routes_passing_is_complete) :-
    always_true_pairs(AlwaysPairs),
    append([dora_entity_type - credit_institution, tests_undertaken_by_internal_tester - false, microenterprise_tests_risk_based_and_planned - true], AlwaysPairs, Pairs),
    test_profile(Pairs, Profile),
    resilience_testing_duties_complete(Profile, complete, _).
test(an_absent_tester_is_named_before_the_internal_tester_duty) :-
    always_true_pairs(AlwaysPairs),
    append([financial_entity_is_microenterprise - false, dora_entity_type - credit_institution], AlwaysPairs, Pairs),
    test_profile(Pairs, Profile),
    resilience_testing_duties_complete(Profile, indeterminate([tests_undertaken_by_internal_tester]), []).
test(a_strong_key_is_named_before_a_weak_one_in_complete) :-
    test_profile([financial_entity_is_microenterprise - false, tests_undertaken_by_internal_tester - false, resilience_testing_programme_established_maintained_and_reviewed - true, programme_includes_range_of_assessments_and_tests - true, programme_conducted_on_risk_based_approach - true, tests_undertaken_by_independent_parties - true, procedures_to_prioritise_classify_and_remedy_issues_established - true, internal_validation_methodologies_established - true, critical_ict_systems_tested_at_least_yearly - true], Profile),
    resilience_testing_duties_complete(Profile, Result, []),
    Result == indeterminate([programme_provides_for_appropriate_tests]).
test(outstanding_names_the_first_absent_key_in_order) :-
    test_profile([financial_entity_is_microenterprise - false, tests_undertaken_by_internal_tester - false, resilience_testing_programme_established_maintained_and_reviewed - true, programme_includes_range_of_assessments_and_tests - true, programme_conducted_on_risk_based_approach - true, tests_undertaken_by_independent_parties - true, procedures_to_prioritise_classify_and_remedy_issues_established - true, internal_validation_methodologies_established - true, critical_ict_systems_tested_at_least_yearly - true], Profile),
    resilience_testing_duties_outstanding(Profile, Result, []),
    Result == indeterminate([dora_entity_type]).
test(outstanding_lists_the_false_duty) :-
    test_profile([financial_entity_is_microenterprise - false, dora_entity_type - credit_institution, tests_undertaken_by_internal_tester - false, resilience_testing_programme_established_maintained_and_reviewed - true, programme_includes_range_of_assessments_and_tests - true, programme_conducted_on_risk_based_approach - true, tests_undertaken_by_independent_parties - false, procedures_to_prioritise_classify_and_remedy_issues_established - true, internal_validation_methodologies_established - true, critical_ict_systems_tested_at_least_yearly - true, programme_provides_for_appropriate_tests - true], Profile),
    findall(Result - Citations, resilience_testing_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [outstanding([independent_testers]) - [cite(eu_reg_2022_2554_art_24_4)]].
test(outstanding_refers_an_unsure_duty) :-
    test_profile([financial_entity_is_microenterprise - false, dora_entity_type - credit_institution, tests_undertaken_by_internal_tester - false, resilience_testing_programme_established_maintained_and_reviewed - true, programme_includes_range_of_assessments_and_tests - true, programme_conducted_on_risk_based_approach - unsure, tests_undertaken_by_independent_parties - true, procedures_to_prioritise_classify_and_remedy_issues_established - true, internal_validation_methodologies_established - true, critical_ict_systems_tested_at_least_yearly - true, programme_provides_for_appropriate_tests - true], Profile),
    resilience_testing_duties_outstanding(Profile, needs_legal_review(Reason, [inputs_relied_on(Pairs)]), []),
    Reason == open_textured(programme_conducted_on_risk_based_approach, cite(eu_reg_2022_2554_art_24_3)),
    Pairs = [financial_entity_is_microenterprise - false|_],
    length(Pairs, 11).
test(a_passing_branch_has_none_outstanding) :-
    passing_branch_profile(Profile),
    resilience_testing_duties_outstanding(Profile, none_outstanding, Citations),
    length(Citations, 9).
test(a_microenterprise_with_its_duty_false_has_it_outstanding) :-
    test_profile([financial_entity_is_microenterprise - true, microenterprise_tests_risk_based_and_planned - false], Profile),
    resilience_testing_duties_outstanding(Profile, outstanding([microenterprise_risk_based_planned_testing]), [cite(eu_reg_2022_2554_art_25_3)]).
test(an_unknown_key_is_an_input_problem) :-
    test_profile([colour - red], Profile),
    resilience_testing_duties_complete(Profile, Result, Citations),
    Result == input_problems([unknown_key(colour)]),
    Citations == [].
test(the_checklist_has_one_row_per_duty) :-
    passing_branch_profile(Profile),
    dora_resilience_testing_programme_checklist(Profile, Items),
    length(Items, 11),
    member(item(microenterprise_risk_based_planned_testing, inapplicable, cite(eu_reg_2022_2554_art_25_3)), Items),
    member(item(independent_testers, met, cite(eu_reg_2022_2554_art_24_4)), Items).
test(the_status_projection) :-
    passing_branch_profile(Profile),
    dora_resilience_testing_programme_status(Profile, complete).

test(a_passing_branch_is_not_incomplete, fail) :-
    passing_branch_profile(Profile),
    resilience_testing_duties_complete(Profile, incomplete, _).
test(one_false_duty_is_not_complete, fail) :-
    test_profile([financial_entity_is_microenterprise - false, tests_undertaken_by_independent_parties - false], Profile),
    resilience_testing_duties_complete(Profile, complete, _).
