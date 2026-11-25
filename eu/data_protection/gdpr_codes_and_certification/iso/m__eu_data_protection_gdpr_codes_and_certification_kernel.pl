% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_codes_and_certification_kernel, [gdpr_codes_and_certification_input_problems/2, calendar_date_t/2, calendar_year_t/2, date_triple_order/7, crisp_step/5, judgement_step/5, enumeration_step/5, all_step/4, walk_ladder/3, combine_parts/3, combine_one/2, relied_pairs/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(error), [must_be/2]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(deadline_lib, [month_last_day/3]).

gdpr_codes_and_certification_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [certification_issuer, certification_body_accredited, certification_criteria_approved, supervisory_authority_informed_before_issue_or_renewal, certification_withdrawn, certification_requirements_not_met, certification_holder_not_subject_to_regulation, certification_holder_binding_commitments_made, processing_by_public_authority_or_body, code_prepared_by_body_representing_controllers_or_processors, code_approved_by_competent_supervisory_authority, code_contains_monitoring_mechanisms, monitoring_body_accredited, code_adhered_to_by_party_not_subject_to_regulation, code_has_general_validity, code_adherent_binding_commitments_made, monitoring_body_accreditation_revoked, monitoring_body_independence_and_expertise_demonstrated, monitoring_body_eligibility_monitoring_and_review_procedures_established, monitoring_body_complaint_procedures_and_structures_established, monitoring_body_no_conflict_of_interests_demonstrated, monitoring_body_actions_infringe_regulation, certification_body_accreditation_revoked, certification_body_accrediting_entity, certification_body_independence_and_expertise_demonstrated, certification_body_undertook_to_respect_approved_criteria, certification_body_issuing_review_and_withdrawal_procedures_established, certification_body_complaint_procedures_and_structures_established, certification_body_no_conflict_of_interests_demonstrated, certification_body_actions_infringe_regulation],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(certification_issuer, issuer).
key_type(certification_body_accredited, boolean).
key_type(certification_criteria_approved, boolean).
key_type(supervisory_authority_informed_before_issue_or_renewal, boolean).
key_type(certification_withdrawn, boolean).
key_type(certification_requirements_not_met, judgement).
key_type(certification_holder_not_subject_to_regulation, boolean).
key_type(certification_holder_binding_commitments_made, boolean).
key_type(processing_by_public_authority_or_body, boolean).
key_type(code_prepared_by_body_representing_controllers_or_processors, judgement).
key_type(code_approved_by_competent_supervisory_authority, boolean).
key_type(code_contains_monitoring_mechanisms, boolean).
key_type(monitoring_body_accredited, boolean).
key_type(code_adhered_to_by_party_not_subject_to_regulation, boolean).
key_type(code_has_general_validity, boolean).
key_type(code_adherent_binding_commitments_made, boolean).
key_type(monitoring_body_accreditation_revoked, boolean).
key_type(monitoring_body_independence_and_expertise_demonstrated, judgement).
key_type(monitoring_body_eligibility_monitoring_and_review_procedures_established, boolean).
key_type(monitoring_body_complaint_procedures_and_structures_established, boolean).
key_type(monitoring_body_no_conflict_of_interests_demonstrated, judgement).
key_type(monitoring_body_actions_infringe_regulation, judgement).
key_type(certification_body_accreditation_revoked, boolean).
key_type(certification_body_accrediting_entity, accrediting_entity).
key_type(certification_body_independence_and_expertise_demonstrated, judgement).
key_type(certification_body_undertook_to_respect_approved_criteria, boolean).
key_type(certification_body_issuing_review_and_withdrawal_procedures_established, boolean).
key_type(certification_body_complaint_procedures_and_structures_established, boolean).
key_type(certification_body_no_conflict_of_interests_demonstrated, judgement).
key_type(certification_body_actions_infringe_regulation, judgement).

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
    attribute_key_t(Key, T).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

attribute_key_t(Key, true) :-
    var(Key).
attribute_key_t(Key, true) :-
    nonvar(Key),
    ground(Key).
attribute_key_t(Key, false) :-
    nonvar(Key),
    term_variables(Key, [_|_]).

unknown_keys([], _, []).
unknown_keys([attribute(Key, _)|Elements], Known, Problems) :-
    known_t(Key, Known, IsKnown),
    name_unknown_key(IsKnown, Key, Known, Elements, Problems).

known_t(_, [], false).
known_t(Key, [Known|_], true) :-
    Known == Key.
known_t(Key, [Known|Knowns], T) :-
    Known \== Key,
    known_t(Key, Knowns, T).

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

in_type_t(issuer, Value, T) :-
    in_type_t(enum([certification_body, competent_supervisory_authority, other_issuer]), Value, T).
in_type_t(judgement, Value, T) :-
    in_type_t(one_of([boolean, enum([unsure])]), Value, T).
in_type_t(accrediting_entity, Value, T) :-
    in_type_t(enum([competent_supervisory_authority, national_accreditation_body, both_named_entities, other_entity]), Value, T).
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

calendar_date_t(Date, false) :-
    var(Date).
calendar_date_t(Date, Truth) :-
    nonvar(Date),
    Date = date(Year, Month, Day),
    integer_t(Year, YearIsInteger),
    integer_t(Month, MonthIsInteger),
    integer_t(Day, DayIsInteger),
    truth_and(YearIsInteger, MonthIsInteger, YearAndMonthAreIntegers),
    truth_and(YearAndMonthAreIntegers, DayIsInteger, AllAreIntegers),
    date_integers_t(AllAreIntegers, Year, Month, Day, Truth).
calendar_date_t(Date, false) :-
    nonvar(Date),
    Date \= date(_, _, _).

integer_t(Value, Truth) :-
    catch(integer_truth(Value, Truth), _, Truth = false).

integer_truth(Value, true) :-
    must_be(integer, Value).

date_integers_t(false, _, _, _, false).
date_integers_t(true, Year, Month, Day, Truth) :-
    calendar_year_t(Year, YearInCalendar),
    month_t(Month, MonthInYear),
    year_and_month_t(YearInCalendar, MonthInYear, Year, Month, Day, Truth).

calendar_year_t(Year, true) :-
    Year #>= 1,
    Year #< 10000.
calendar_year_t(Year, false) :-
    Year #< 1.
calendar_year_t(Year, false) :-
    Year #> 9999.

month_t(Month, true) :-
    Month #>= 1,
    Month #< 13.
month_t(Month, false) :-
    Month #< 1.
month_t(Month, false) :-
    Month #> 12.

year_and_month_t(false, _, _, _, _, false).
year_and_month_t(true, false, _, _, _, false).
year_and_month_t(true, true, Year, Month, Day, Truth) :-
    month_last_day(Year, Month, LastDay),
    day_t(Day, LastDay, Truth).

day_t(Day, LastDay, true) :-
    Day #>= 1,
    Day #=< LastDay.
day_t(Day, _, false) :-
    Day #< 1.
day_t(Day, LastDay, false) :-
    Day #> LastDay.

date_triple_order(YearOne, MonthOne, DayOne, YearTwo, MonthTwo, DayTwo, Order) :-
    compare(YearOrder, YearOne, YearTwo),
    month_order(YearOrder, MonthOne, DayOne, MonthTwo, DayTwo, Order).

month_order(<, _, _, _, _, <).
month_order(>, _, _, _, _, >).
month_order(=, MonthOne, DayOne, MonthTwo, DayTwo, Order) :-
    compare(MonthOrder, MonthOne, MonthTwo),
    day_order(MonthOrder, DayOne, DayTwo, Order).

day_order(<, _, _, <).
day_order(>, _, _, >).
day_order(=, DayOne, DayTwo, Order) :-
    compare(Order, DayOne, DayTwo).

crisp_step(Profile, Key, _, _, open_by_absence(Key)) :-
    profile_lacks(Profile, Key).
crisp_step(Profile, Key, DecidingValue, DecidingAtom, Outcome) :-
    profile_get(Profile, Key, Value),
    crisp_value_outcome(Value, DecidingValue, DecidingAtom, Outcome).

crisp_value_outcome(Value, Value, DecidingAtom, decides(DecidingAtom)).
crisp_value_outcome(Value, DecidingValue, _, passed) :-
    dif(Value, DecidingValue).

enumeration_step(Profile, Key, DecidingValue, DecidingAtom, Outcome) :-
    crisp_step(Profile, Key, DecidingValue, DecidingAtom, Outcome).

judgement_step(Profile, Key, _, _, open_by_absence(Key)) :-
    profile_lacks(Profile, Key).
judgement_step(Profile, Key, DecidingValue, DecidingAtom, Outcome) :-
    profile_get(Profile, Key, Value),
    judgement_value_outcome(Value, DecidingValue, DecidingAtom, Key, Outcome).

judgement_value_outcome(unsure, _, _, Key, open_by_judgement(Key)).
judgement_value_outcome(Value, Value, DecidingAtom, _, decides(DecidingAtom)) :-
    dif(Value, unsure).
judgement_value_outcome(Value, DecidingValue, _, _, passed) :-
    dif(Value, unsure),
    dif(Value, DecidingValue).

all_step(Profile, Keys, DecidingAtom, Outcome) :-
    maplist(key_class(Profile), Keys, Classes),
    first_with_class(Classes, refuted, Refuted),
    first_with_class(Classes, missing, Missing),
    first_with_class(Classes, open, Open),
    all_outcome(Refuted, Missing, Open, DecidingAtom, Outcome).

key_class(Profile, Key, Key - missing) :-
    profile_lacks(Profile, Key).
key_class(Profile, Key, Key - Class) :-
    profile_get(Profile, Key, Value),
    value_class(Value, Class).

value_class(true, held).
value_class(false, refuted).
value_class(unsure, open).

first_with_class([], _, none_found).
first_with_class([Key - Class|_], Class, found(Key)).
first_with_class([_ - Other|Classes], Class, Found) :-
    dif(Other, Class),
    first_with_class(Classes, Class, Found).

all_outcome(found(_), _, _, DecidingAtom, decides(DecidingAtom)).
all_outcome(none_found, found(Key), _, _, open_by_absence(Key)).
all_outcome(none_found, none_found, found(Key), _, open_by_judgement(Key)).
all_outcome(none_found, none_found, none_found, _, passed).

walk_ladder(Outcomes, Final, PartAnswer) :-
    walk_ladder_remembering(Outcomes, nothing_remembered, Final, PartAnswer).

walk_ladder_remembering([], nothing_remembered, Final, answer(Final)).
walk_ladder_remembering([], remembered(Key), _, judgement(Key)).
walk_ladder_remembering([passed|Outcomes], Remembered, Final, PartAnswer) :-
    walk_ladder_remembering(Outcomes, Remembered, Final, PartAnswer).
walk_ladder_remembering([decides(Atom)|_], nothing_remembered, _, answer(Atom)).
walk_ladder_remembering([decides(_)|_], remembered(Key), _, judgement(Key)).
walk_ladder_remembering([open_by_absence(Key)|_], _, _, absence(Key)).
walk_ladder_remembering([open_by_judgement(Key)|Outcomes], nothing_remembered, Final, PartAnswer) :-
    walk_ladder_remembering(Outcomes, remembered(Key), Final, PartAnswer).
walk_ladder_remembering([open_by_judgement(_)|Outcomes], remembered(Key), Final, PartAnswer) :-
    walk_ladder_remembering(Outcomes, remembered(Key), Final, PartAnswer).

combine_parts(absence(Key), _, absence(Key)).
combine_parts(answer(_), absence(Key), absence(Key)).
combine_parts(judgement(_), absence(Key), absence(Key)).
combine_parts(judgement(Key), answer(_), judgement(Key)).
combine_parts(judgement(Key), judgement(_), judgement(Key)).
combine_parts(answer(_), judgement(Key), judgement(Key)).
combine_parts(answer(AnswerOne), answer(AnswerTwo), answers(AnswerOne, AnswerTwo)).

combine_one(absence(Key), absence(Key)).
combine_one(judgement(Key), judgement(Key)).
combine_one(answer(Answer), answer(Answer)).

relied_pairs(_, [], []).
relied_pairs(Profile, [Key|Keys], Pairs) :-
    profile_lacks(Profile, Key),
    relied_pairs(Profile, Keys, Pairs).
relied_pairs(Profile, [Key|Keys], [Key - Value|Pairs]) :-
    profile_get(Profile, Key, Value),
    relied_pairs(Profile, Keys, Pairs).

test(first_decision_wins) :-
    walk_ladder([passed, decides(first_ground), decides(second_ground)], final_answer, answer(first_ground)).
test(every_step_passed_gives_the_final) :-
    walk_ladder([passed, passed], final_answer, answer(final_answer)).
test(absence_after_judgement_is_named) :-
    walk_ladder([open_by_judgement(first_key), open_by_absence(second_key)], final_answer, absence(second_key)).
test(judgement_before_decision_is_referred) :-
    walk_ladder([open_by_judgement(first_key), decides(first_ground)], final_answer, judgement(first_key)).
test(absence_in_second_part_before_judgement_in_first) :-
    combine_parts(judgement(first_key), absence(second_key), absence(second_key)).
test(two_answers_combine) :-
    combine_parts(answer(first_ground), answer(second_ground), answers(first_ground, second_ground)).
test(leap_day_is_a_real_day) :-
    calendar_date_t(date(2024, 2, 29), true).
test(century_year_leap_day_is_not_a_real_day) :-
    calendar_date_t(date(1900, 2, 29), false).
test(an_unbound_date_is_not_a_date) :-
    calendar_date_t(_, false).
test(a_year_beyond_the_calendar_is_not_a_date) :-
    calendar_date_t(date(10000, 1, 1), false).
test(an_atom_day_is_not_a_date) :-
    calendar_date_t(date(2024, 1, first), false).
test(triples_compare_by_year_first) :-
    date_triple_order(2024, 12, 31, 2025, 1, 1, <).
test(equal_triples_compare_equal) :-
    date_triple_order(2027, 2, 28, 2027, 2, 28, =).
test(a_compound_key_with_a_variable_is_not_a_profile) :-
    gdpr_codes_and_certification_input_problems([attribute(wrapped(_), true)], [wrong_type(profile)]).
test(an_unbound_profile_is_not_a_profile) :-
    gdpr_codes_and_certification_input_problems(_, [wrong_type(profile)]).
test(an_attested_value_is_wrong_type) :-
    gdpr_codes_and_certification_input_problems([attribute(certification_withdrawn, attested(true))], [wrong_type(certification_withdrawn)]).

test(judgement_before_decision_is_not_answered, fail) :-
    walk_ladder([open_by_judgement(first_key), decides(first_ground)], final_answer, answer(_)).
