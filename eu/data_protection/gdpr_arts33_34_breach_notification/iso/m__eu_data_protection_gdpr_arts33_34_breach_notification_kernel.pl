% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_arts33_34_breach_notification_kernel, [gdpr_arts33_34_breach_notification_input_problems/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).

gdpr_arts33_34_breach_notification_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk, delay_justified_by_reasons, party_role, notification_made_without_undue_delay, notification_accompanied_by_reasons_for_delay, supervisory_authority_decision_on_communication, appropriate_protection_measures_applied_to_affected_data, subsequent_measures_ensure_high_risk_no_longer_likely, communication_would_involve_disproportionate_effort, notification_describes_nature_of_breach, notification_gives_categories_and_approximate_numbers, categories_and_approximate_numbers_possible, notification_gives_contact_point, notification_describes_likely_consequences, notification_describes_measures_taken_or_proposed, notification_describes_mitigation_measures, mitigation_measures_appropriate, information_not_possible_to_provide_at_the_same_time, communication_made_without_undue_delay, communication_describes_nature_in_clear_and_plain_language, communication_gives_contact_point, communication_describes_likely_consequences, communication_describes_measures_taken_or_proposed, communication_describes_mitigation_measures],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    contradictory_problems(Profile, ContradictoryProblems),
    append(UnknownKeyProblems, ContradictoryProblems, LaterProblems),
    key_problems(Keys, Profile, LaterProblems, Problems).

key_type(breach_unlikely_to_result_in_risk, judgement).
key_type(breach_likely_to_result_in_high_risk, judgement).
key_type(delay_justified_by_reasons, judgement).
key_type(party_role, enum([controller, processor])).
key_type(notification_made_without_undue_delay, judgement).
key_type(notification_accompanied_by_reasons_for_delay, boolean).
key_type(supervisory_authority_decision_on_communication, enum([no_decision, required_communication, decided_point_a_condition_met, decided_point_b_condition_met, decided_point_c_condition_met])).
key_type(appropriate_protection_measures_applied_to_affected_data, judgement).
key_type(subsequent_measures_ensure_high_risk_no_longer_likely, judgement).
key_type(communication_would_involve_disproportionate_effort, judgement).
key_type(notification_describes_nature_of_breach, boolean).
key_type(notification_gives_categories_and_approximate_numbers, boolean).
key_type(categories_and_approximate_numbers_possible, judgement).
key_type(notification_gives_contact_point, boolean).
key_type(notification_describes_likely_consequences, boolean).
key_type(notification_describes_measures_taken_or_proposed, boolean).
key_type(notification_describes_mitigation_measures, boolean).
key_type(mitigation_measures_appropriate, judgement).
key_type(information_not_possible_to_provide_at_the_same_time, judgement).
key_type(communication_made_without_undue_delay, judgement).
key_type(communication_describes_nature_in_clear_and_plain_language, judgement).
key_type(communication_gives_contact_point, boolean).
key_type(communication_describes_likely_consequences, boolean).
key_type(communication_describes_measures_taken_or_proposed, boolean).
key_type(communication_describes_mitigation_measures, boolean).

attribute_list_t(Term, false) :-
    var(Term).
attribute_list_t(Term, true) :-
    Term == [].
attribute_list_t(Term, T) :-
    nonvar(Term),
    Term = [Element|Elements],
    attribute_t(Element, ElementIsAttribute),
    attribute_list_t(Elements, ElementsAreAttributes),
    truth_and(ElementIsAttribute, ElementsAreAttributes, T).
attribute_list_t(Term, false) :-
    nonvar(Term),
    Term \== [],
    Term \= [_|_].

attribute_t(Element, false) :-
    var(Element).
attribute_t(Element, T) :-
    nonvar(Element),
    Element = attribute(Key, _),
    term_variables(Key, Variables),
    no_variables_t(Variables, T).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

no_variables_t([], true).
no_variables_t([_|_], false).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    memberd_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

name_unknown_key(true, _, Known, Elements, Problems) :-
    unknown_keys(Elements, Known, Problems).
name_unknown_key(false, Key, Known, Elements, [unknown_key(Key)|Problems]) :-
    unknown_keys(Elements, [Key|Known], Problems).

key_problems([], _, Problems, Problems).
key_problems([Key|Keys], Profile, LaterProblems, Problems) :-
    key_type(Key, Type),
    key_occurrences(Profile, Key, Occurrences),
    key_problems(Keys, Profile, LaterProblems, KeyProblems),
    name_key_problem(Occurrences, Key, Type, Profile, KeyProblems, Problems).

key_occurrences([], _, none).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey == Key,
    key_occurrences(Elements, Key, RestOccurrences),
    one_more_occurrence(RestOccurrences, Occurrences).
key_occurrences([attribute(ElementKey, _)|Elements], Key, Occurrences) :-
    ElementKey \== Key,
    key_occurrences(Elements, Key, Occurrences).

one_more_occurrence(none, one).
one_more_occurrence(one, many).
one_more_occurrence(many, many).

name_key_problem(none, _, _, _, Problems, Problems).
name_key_problem(many, Key, _, _, Problems, [duplicate_key(Key)|Problems]).
name_key_problem(one, Key, Type, Profile, KeyProblems, Problems) :-
    values_in_type_t(Profile, Key, Type, InType),
    name_wrong_type(InType, Key, KeyProblems, Problems).

name_wrong_type(true, _, Problems, Problems).
name_wrong_type(false, Key, Problems, [wrong_type(Key)|Problems]).

values_in_type_t([], _, _, true).
values_in_type_t([attribute(ElementKey, Value)|Elements], Key, Type, T) :-
    ElementKey == Key,
    value_in_type_t(Type, Value, ValueInType),
    values_in_type_t(Elements, Key, Type, RestInType),
    truth_and(ValueInType, RestInType, T).
values_in_type_t([attribute(ElementKey, _)|Elements], Key, Type, T) :-
    ElementKey \== Key,
    values_in_type_t(Elements, Key, Type, T).

value_in_type_t(Type, Value, T) :-
    term_variables(Value, Variables),
    ground_value_in_type_t(Variables, Type, Value, T).

ground_value_in_type_t([_|_], _, _, false).
ground_value_in_type_t([], Type, Value, T) :-
    in_type_t(Type, Value, T).

in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(boolean, Value, T) :-
    memberd_t(Value, [true, false], T).
in_type_t(enum(Values), Value, T) :-
    memberd_t(Value, Values, T).
in_type_t(one_of(Types), Value, T) :-
    in_some_type_t(Types, Value, T).

truth_and(true, T, T).
truth_and(false, _, false).

in_some_type_t([], _, false).
in_some_type_t([Type|Types], Value, T) :-
    in_type_t(Type, Value, InType),
    in_some_type_t(Types, Value, InAnother),
    truth_or(InType, InAnother, T).

truth_or(true, _, true).
truth_or(false, T, T).

contradictory_problems(Profile, Problems) :-
    pair_problems(Profile, breach_unlikely_to_result_in_risk, true, breach_likely_to_result_in_high_risk, true, FirstProblems),
    pair_problems(Profile, delay_justified_by_reasons, true, notification_accompanied_by_reasons_for_delay, false, SecondProblems),
    append(FirstProblems, SecondProblems, Problems).

pair_problems(Profile, FirstKey, FirstValue, SecondKey, SecondValue, Problems) :-
    single_value_t(Profile, FirstKey, FirstValue, FirstHolds),
    single_value_t(Profile, SecondKey, SecondValue, SecondHolds),
    truth_and(FirstHolds, SecondHolds, BothHold),
    name_contradiction(BothHold, [FirstKey, SecondKey], Problems).

single_value_t(Profile, Key, Wanted, T) :-
    key_occurrences(Profile, Key, Occurrences),
    occurrence_value_t(Occurrences, Profile, Key, Wanted, T).

occurrence_value_t(none, _, _, _, false).
occurrence_value_t(many, _, _, _, false).
occurrence_value_t(one, Profile, Key, Wanted, T) :-
    values_in_type_t(Profile, Key, enum([Wanted]), T).

name_contradiction(true, Keys, [contradictory_inputs(Keys)]).
name_contradiction(false, _, []).

test(an_empty_profile_has_no_problem) :-
    gdpr_arts33_34_breach_notification_input_problems([], []).
test(a_well_formed_profile_has_no_problem) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(breach_unlikely_to_result_in_risk, false), attribute(party_role, controller), attribute(notification_made_without_undue_delay, unsure)], []).
test(a_non_list_is_wrong_type_profile) :-
    gdpr_arts33_34_breach_notification_input_problems(controller, [wrong_type(profile)]).
test(a_list_with_a_non_attribute_is_wrong_type_profile) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(party_role, controller), party_role], [wrong_type(profile)]).
test(an_enumeration_value_outside_its_atoms_is_wrong_type) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(party_role, auditor)], [wrong_type(party_role)]).
test(unsure_is_not_a_crisp_value) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(notification_gives_contact_point, unsure)], [wrong_type(notification_gives_contact_point)]).
test(a_repeated_key_is_one_duplicate_key) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(party_role, controller), attribute(party_role, nobody)], [duplicate_key(party_role)]).
test(an_unknown_key_is_named_once) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(breach_colour, red), attribute(party_role, controller), attribute(breach_colour, blue)], [unknown_key(breach_colour)]).
test(the_risk_pair_is_contradictory) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(breach_likely_to_result_in_high_risk, true), attribute(breach_unlikely_to_result_in_risk, true)], [contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])]).
test(the_reasons_pair_is_contradictory) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(delay_justified_by_reasons, true), attribute(notification_accompanied_by_reasons_for_delay, false)], [contradictory_inputs([delay_justified_by_reasons, notification_accompanied_by_reasons_for_delay])]).
test(an_unsure_judgement_is_not_contradictory) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(breach_unlikely_to_result_in_risk, unsure), attribute(breach_likely_to_result_in_high_risk, true)], []).
test(a_duplicated_key_does_not_form_a_contradictory_pair) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, true)], [duplicate_key(breach_unlikely_to_result_in_risk)]).
test(problems_come_in_contract_then_unknown_then_contradiction_order) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(breach_colour, red), attribute(breach_unlikely_to_result_in_risk, true), attribute(party_role, auditor), attribute(breach_likely_to_result_in_high_risk, true)], [wrong_type(party_role), unknown_key(breach_colour), contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])]).
test(the_check_has_exactly_one_answer) :-
    findall(Problems, gdpr_arts33_34_breach_notification_input_problems([attribute(party_role, processor)], Problems), Answers),
    Answers == [[]].
