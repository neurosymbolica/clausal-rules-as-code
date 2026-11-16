% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_transparency_art50_kernel, [transparency_art50_input_problems/2, transparency_art50_calendar_day_t/2, transparency_art50_item_state/3, transparency_art50_test_outcome/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(deadline_lib, [month_last_day/3]).

transparency_art50_input_problems(Profile, Problems) :-
    attribute_list_t(Profile, IsAttributeList),
    profile_problems(IsAttributeList, Profile, Problems).

profile_problems(false, _, [wrong_type(profile)]).
profile_problems(true, Profile, Problems) :-
    Keys = [intended_to_interact_directly_with_natural_persons, interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person, generates_synthetic_audio_image_video_or_text_content, performs_an_assistive_function_for_standard_editing, does_not_substantially_alter_the_input_data_or_its_semantics, emotion_recognition_or_biometric_categorisation_system, permitted_by_law_to_detect_prevent_or_investigate_criminal_offences, generates_or_manipulates_deep_fake_image_audio_or_video_content, generates_or_manipulates_text_published_to_inform_the_public_on_matters_of_public_interest, used_in_a_personal_non_professional_activity, authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences, available_for_the_public_to_report_a_criminal_offence, content_underwent_human_review_or_editorial_control, natural_or_legal_person_holds_editorial_responsibility, ai_system, part_of_an_evidently_artistic_creative_satirical_fictional_or_analogous_work, placed_on_the_market_before_2_august_2026, required_information_given, disclosure_of_existence_appropriate_and_does_not_hamper_the_work, information_timing, provided_in_a_clear_and_distinguishable_manner, conforms_to_the_applicable_accessibility_requirements, outputs_marked_machine_readable_and_detectable_as_artificially_generated],
    unknown_keys(Profile, Keys, UnknownKeyProblems),
    key_problems(Keys, Profile, UnknownKeyProblems, Problems).

key_type(intended_to_interact_directly_with_natural_persons, boolean).
key_type(interaction_obvious_to_a_reasonably_well_informed_observant_and_circumspect_person, judgement).
key_type(generates_synthetic_audio_image_video_or_text_content, boolean).
key_type(performs_an_assistive_function_for_standard_editing, judgement).
key_type(does_not_substantially_alter_the_input_data_or_its_semantics, judgement).
key_type(emotion_recognition_or_biometric_categorisation_system, judgement).
key_type(permitted_by_law_to_detect_prevent_or_investigate_criminal_offences, boolean).
key_type(generates_or_manipulates_deep_fake_image_audio_or_video_content, judgement).
key_type(generates_or_manipulates_text_published_to_inform_the_public_on_matters_of_public_interest, judgement).
key_type(used_in_a_personal_non_professional_activity, boolean).
key_type(authorised_by_law_to_detect_prevent_investigate_or_prosecute_criminal_offences, boolean).
key_type(available_for_the_public_to_report_a_criminal_offence, boolean).
key_type(content_underwent_human_review_or_editorial_control, boolean).
key_type(natural_or_legal_person_holds_editorial_responsibility, boolean).
key_type(ai_system, judgement).
key_type(part_of_an_evidently_artistic_creative_satirical_fictional_or_analogous_work, judgement).
key_type(placed_on_the_market_before_2_august_2026, boolean).
key_type(required_information_given, boolean).
key_type(disclosure_of_existence_appropriate_and_does_not_hamper_the_work, judgement).
key_type(information_timing, enum([at_or_before_first_interaction_or_exposure, after_first_interaction_or_exposure])).
key_type(provided_in_a_clear_and_distinguishable_manner, judgement).
key_type(conforms_to_the_applicable_accessibility_requirements, judgement).
key_type(outputs_marked_machine_readable_and_detectable_as_artificially_generated, judgement).

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
attribute_t(Element, true) :-
    nonvar(Element),
    Element = attribute(_, _).
attribute_t(Element, false) :-
    nonvar(Element),
    Element \= attribute(_, _).

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

transparency_art50_calendar_day_t(Date, Truth) :-
    term_variables(Date, Variables),
    ground_calendar_day_t(Variables, Date, Truth).

ground_calendar_day_t([_|_], _, false).
ground_calendar_day_t([], Date, Truth) :-
    date_shape_t(Date, Truth).

date_shape_t(Date, Truth) :-
    Date = date(YearNumber, MonthNumber, DayNumber),
    year_t(YearNumber, YearTruth),
    year_month_day_t(YearTruth, YearNumber, MonthNumber, DayNumber, Truth).
date_shape_t(Date, false) :-
    Date \= date(_, _, _).

year_t(YearNumber, Truth) :-
    numlist(1, 9999, Years),
    memberd_t(YearNumber, Years, Truth).

year_month_day_t(false, _, _, _, false).
year_month_day_t(true, YearNumber, MonthNumber, DayNumber, Truth) :-
    numlist(1, 12, Months),
    memberd_t(MonthNumber, Months, MonthTruth),
    month_day_t(MonthTruth, YearNumber, MonthNumber, DayNumber, Truth).

month_day_t(false, _, _, _, false).
month_day_t(true, YearNumber, MonthNumber, DayNumber, Truth) :-
    month_last_day(YearNumber, MonthNumber, LastDay),
    numlist(1, LastDay, Days),
    memberd_t(DayNumber, Days, Truth).

transparency_art50_item_state(Profile, condition(Key, _), undetermined(Key)) :-
    profile_lacks(Profile, Key).
transparency_art50_item_state(Profile, condition(Key, Wanted), State) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value),
    value_state(Value, Wanted, State).
transparency_art50_item_state(Profile, not_both(KeyOne, ValueOne, KeyTwo, ValueTwo), State) :-
    transparency_art50_item_state(Profile, condition(KeyOne, ValueOne), StateOne),
    transparency_art50_item_state(Profile, condition(KeyTwo, ValueTwo), StateTwo),
    not_both_state(StateOne, StateTwo, State).

value_state(Value, Wanted, holds) :-
    Value == Wanted.
value_state(Value, Wanted, fails) :-
    Value \== Wanted.

not_both_state(holds, holds, fails).
not_both_state(fails, _, holds).
not_both_state(holds, fails, holds).
not_both_state(undetermined(_), fails, holds).
not_both_state(holds, undetermined(KeyTwo), undetermined(KeyTwo)).
not_both_state(undetermined(KeyOne), holds, undetermined(KeyOne)).
not_both_state(undetermined(KeyOne), undetermined(_), undetermined(KeyOne)).

transparency_art50_test_outcome(Profile, Items, Outcome) :-
    maplist(transparency_art50_item_state(Profile), Items, States),
    states_outcome(States, Outcome).

states_outcome([], test_met).
states_outcome([State|States], Outcome) :-
    states_outcome(States, LaterOutcome),
    combine_outcome(State, LaterOutcome, Outcome).

combine_outcome(fails, _, test_failed).
combine_outcome(holds, LaterOutcome, LaterOutcome).
combine_outcome(undetermined(_), test_failed, test_failed).
combine_outcome(undetermined(Key), test_open(_), test_open(Key)).
combine_outcome(undetermined(Key), test_met, test_open(Key)).

test(a_well_formed_profile_has_no_problem) :-
    transparency_art50_input_problems([attribute(ai_system, unsure)], []).
test(a_crisp_key_given_unsure_is_a_wrong_type) :-
    transparency_art50_input_problems([attribute(required_information_given, unsure)], [wrong_type(required_information_given)]).
test(a_real_day_is_a_calendar_day) :-
    transparency_art50_calendar_day_t(date(2028, 2, 29), true).
test(an_atom_is_not_a_calendar_day) :-
    transparency_art50_calendar_day_t(today, false).
test(an_unbound_date_is_not_a_calendar_day) :-
    transparency_art50_calendar_day_t(_, false).
test(a_calendar_day_has_one_answer) :-
    findall(Truth, transparency_art50_calendar_day_t(date(2026, 8, 2), Truth), Truths),
    Truths == [true].
test(a_failing_item_fails_the_test_after_an_open_one) :-
    transparency_art50_test_outcome([attribute(second_fact, false)], [condition(first_fact, true), condition(second_fact, true)], test_failed).
test(the_first_absent_key_is_named) :-
    findall(Outcome, transparency_art50_test_outcome([attribute(first_fact, true)], [condition(first_fact, true), condition(second_fact, true), condition(third_fact, true)], Outcome), Outcomes),
    Outcomes == [test_open(second_fact)].
test(every_item_holding_meets_the_test) :-
    transparency_art50_test_outcome([attribute(first_fact, true)], [condition(first_fact, true)], test_met).
test(not_both_with_both_holding_fails) :-
    transparency_art50_test_outcome([attribute(first_fact, true), attribute(second_fact, false)], [not_both(first_fact, true, second_fact, false)], test_failed).
test(not_both_names_the_first_key_first) :-
    transparency_art50_test_outcome([], [not_both(first_fact, true, second_fact, false)], test_open(first_fact)).
test(not_both_holds_on_the_second_key_alone) :-
    transparency_art50_test_outcome([attribute(second_fact, true)], [not_both(first_fact, true, second_fact, false)], test_met).

test(an_open_test_is_not_met, fail) :-
    transparency_art50_test_outcome([], [condition(first_fact, true)], test_met).
