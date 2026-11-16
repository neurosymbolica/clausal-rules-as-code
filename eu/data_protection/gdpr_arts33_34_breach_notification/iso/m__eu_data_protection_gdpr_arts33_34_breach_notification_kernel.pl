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
    contradictory_combinations(Combinations),
    contradiction_problems(Combinations, Profile, ContradictionProblems),
    append(UnknownKeyProblems, ContradictionProblems, LaterProblems),
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

contradictory_combinations([contradictory_combination(breach_unlikely_to_result_in_risk, true, breach_likely_to_result_in_high_risk, true), contradictory_combination(delay_justified_by_reasons, true, notification_accompanied_by_reasons_for_delay, false)]).

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

contradiction_problems([], _, []).
contradiction_problems([contradictory_combination(FirstKey, FirstValue, SecondKey, SecondValue)|Combinations], Profile, Problems) :-
    sole_value_is_t(Profile, FirstKey, FirstValue, FirstHolds),
    sole_value_is_t(Profile, SecondKey, SecondValue, SecondHolds),
    truth_and(FirstHolds, SecondHolds, BothHold),
    contradiction_problems(Combinations, Profile, LaterProblems),
    name_contradiction(BothHold, FirstKey, SecondKey, LaterProblems, Problems).

name_contradiction(true, FirstKey, SecondKey, Problems, [contradictory_inputs([FirstKey, SecondKey])|Problems]).
name_contradiction(false, _, _, Problems, Problems).

sole_value_is_t(Profile, Key, Wanted, Truth) :-
    key_occurrences(Profile, Key, Occurrences),
    occurrence_value_is_t(Occurrences, Profile, Key, Wanted, Truth).

occurrence_value_is_t(none, _, _, _, false).
occurrence_value_is_t(many, _, _, _, false).
occurrence_value_is_t(one, Profile, Key, Wanted, Truth) :-
    sole_key_value(Profile, Key, Value),
    value_is_t(Value, Wanted, Truth).

sole_key_value([attribute(ElementKey, Value)|_], Key, Value) :-
    ElementKey == Key.
sole_key_value([attribute(ElementKey, _)|Elements], Key, Value) :-
    ElementKey \== Key,
    sole_key_value(Elements, Key, Value).

value_is_t(Value, Wanted, true) :-
    Value == Wanted.
value_is_t(Value, Wanted, false) :-
    Value \== Wanted.

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

test(an_empty_profile_has_no_problem) :-
    gdpr_arts33_34_breach_notification_input_problems([], []).
test(a_well_formed_profile_has_no_problem) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(breach_unlikely_to_result_in_risk, unsure), attribute(party_role, controller)], []).
test(a_non_list_is_wrong_type_profile) :-
    gdpr_arts33_34_breach_notification_input_problems(profile, [wrong_type(profile)]).
test(a_non_attribute_element_is_wrong_type_profile) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(party_role, controller), party_role], [wrong_type(profile)]).
test(a_duplicate_with_equal_values_is_only_duplicate) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(party_role, controller), attribute(party_role, controller)], [duplicate_key(party_role)]).
test(a_mistyped_value_is_wrong_type) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(notification_accompanied_by_reasons_for_delay, unsure)], [wrong_type(notification_accompanied_by_reasons_for_delay)]).
test(a_repeated_unknown_key_is_named_once) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(colour, red), attribute(colour, blue)], [unknown_key(colour)]).
test(the_risk_pair_is_contradictory) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, true)], [contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])]).
test(the_reasons_pair_is_contradictory) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(notification_accompanied_by_reasons_for_delay, false), attribute(delay_justified_by_reasons, true)], [contradictory_inputs([delay_justified_by_reasons, notification_accompanied_by_reasons_for_delay])]).
test(an_unsure_high_risk_is_not_contradictory) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, unsure)], []).
test(a_duplicated_pair_key_is_not_contradictory) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, true)], [duplicate_key(breach_unlikely_to_result_in_risk)]).
test(problems_come_in_contract_then_unknown_then_contradiction_order) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(colour, red), attribute(breach_unlikely_to_result_in_risk, true), attribute(breach_likely_to_result_in_high_risk, true), attribute(party_role, auditor)], [wrong_type(party_role), unknown_key(colour), contradictory_inputs([breach_unlikely_to_result_in_risk, breach_likely_to_result_in_high_risk])]).
test(the_check_has_exactly_one_answer) :-
    findall(Problems, gdpr_arts33_34_breach_notification_input_problems([attribute(delay_justified_by_reasons, true), attribute(notification_accompanied_by_reasons_for_delay, false)], Problems), Answers),
    length(Answers, 1).

test(a_consistent_reasons_pair_is_not_refused, fail) :-
    gdpr_arts33_34_breach_notification_input_problems([attribute(delay_justified_by_reasons, true), attribute(notification_accompanied_by_reasons_for_delay, true)], [_|_]).
