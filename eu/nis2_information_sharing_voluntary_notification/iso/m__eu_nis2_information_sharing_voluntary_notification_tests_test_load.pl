% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_information_sharing_voluntary_notification_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_kernel, [nis2_information_sharing_voluntary_notification_input_problems/2]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_citations, [citation/2, implements/1]).

test(the_indeterminate_term_carries_its_missing_keys) :-
    Result = indeterminate([entity_class, event_kind]),
    Result = indeterminate(MissingKeys),
    MissingKeys == [entity_class, event_kind].
test(the_needs_legal_review_term_carries_reason_and_context) :-
    Result = needs_legal_review(open_textured(arrangement_is_a_cybersecurity_information_sharing_arrangement, cite(eu_dir_2022_2555_art_29_2)), [inputs_relied_on([arrangement_is_a_cybersecurity_information_sharing_arrangement - unsure])]),
    Result = needs_legal_review(open_textured(InputName, cite(CitationName)), [inputs_relied_on(Pairs)]),
    InputName == arrangement_is_a_cybersecurity_information_sharing_arrangement,
    CitationName == eu_dir_2022_2555_art_29_2,
    Pairs == [arrangement_is_a_cybersecurity_information_sharing_arrangement - unsure].
test(the_input_problems_term_carries_its_problems) :-
    Result = input_problems([wrong_type(entity_class), unknown_key(colour)]),
    Result = input_problems(Problems),
    Problems == [wrong_type(entity_class), unknown_key(colour)].
test(the_voluntary_notification_atoms_are_distinct) :-
    dif(voluntary_notification_possible, voluntary_notification_not_possible).
test(the_information_exchange_atoms_are_distinct) :-
    dif(information_exchange_permitted, information_exchange_not_permitted).
test(the_arrangement_notification_atoms_are_distinct) :-
    dif(must_notify_on_entering, must_notify_on_withdrawal_taking_effect),
    dif(must_notify_on_entering, no_notification_duty),
    dif(must_notify_on_withdrawal_taking_effect, no_notification_duty).
test(an_empty_profile_has_no_problem) :-
    nis2_information_sharing_voluntary_notification_input_problems([], []).
test(a_well_formed_profile_has_no_problem) :-
    nis2_information_sharing_voluntary_notification_input_problems([attribute(entity_class, out_of_scope), attribute(event_kind, near_miss), attribute(arrangement_is_a_cybersecurity_information_sharing_arrangement, unsure)], []).
test(a_well_formed_profile_has_exactly_one_answer) :-
    findall(Problems, nis2_information_sharing_voluntary_notification_input_problems([attribute(entity_class, essential_entity)], Problems), Answers),
    Answers == [[]].
test(a_value_outside_its_type_is_wrong_type) :-
    nis2_information_sharing_voluntary_notification_input_problems([attribute(entity_class, banana)], [wrong_type(entity_class)]).
test(a_key_outside_the_contract_is_unknown) :-
    nis2_information_sharing_voluntary_notification_input_problems([attribute(colour, red), attribute(colour, blue)], [unknown_key(colour)]).
test(a_repeated_key_is_a_duplicate_and_not_wrong_type) :-
    nis2_information_sharing_voluntary_notification_input_problems([attribute(event_kind, banana), attribute(event_kind, incident)], [duplicate_key(event_kind)]).
test(problems_come_in_contract_order_then_unknown_keys) :-
    nis2_information_sharing_voluntary_notification_input_problems([attribute(colour, red), attribute(sharing_enhances_the_level_of_cybersecurity, maybe), attribute(entity_class, banana)], [wrong_type(entity_class), wrong_type(sharing_enhances_the_level_of_cybersecurity), unknown_key(colour)]).
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    nis2_information_sharing_voluntary_notification_input_problems(not_a_list, [wrong_type(profile)]).
test(a_list_with_a_stray_element_is_wrong_type_profile) :-
    nis2_information_sharing_voluntary_notification_input_problems([attribute(entity_class, out_of_scope), stray], [wrong_type(profile)]).
test(the_art_30_1_a_citation_is_recorded) :-
    citation(eu_dir_2022_2555_art_30_1_a, _Record).
test(the_art_29_4_citation_is_recorded) :-
    citation(eu_dir_2022_2555_art_29_4, _Record).
test(every_returned_citation_key_implements) :-
    implements(eu_dir_2022_2555_art_29_1),
    implements(eu_dir_2022_2555_art_29_1_a),
    implements(eu_dir_2022_2555_art_29_1_b),
    implements(eu_dir_2022_2555_art_29_2),
    implements(eu_dir_2022_2555_art_29_4),
    implements(eu_dir_2022_2555_art_30_1_a),
    implements(eu_dir_2022_2555_art_30_1_b).

test(a_well_formed_profile_is_not_wrong_type_profile, fail) :-
    nis2_information_sharing_voluntary_notification_input_problems([attribute(entity_class, out_of_scope)], [wrong_type(profile)]).
test(a_shortened_citation_key_is_not_recorded, fail) :-
    citation(art_30_1_a, _Record).

cp_test_names([the_indeterminate_term_carries_its_missing_keys, the_needs_legal_review_term_carries_reason_and_context, the_input_problems_term_carries_its_problems, the_voluntary_notification_atoms_are_distinct, the_information_exchange_atoms_are_distinct, the_arrangement_notification_atoms_are_distinct, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_well_formed_profile_has_exactly_one_answer, a_value_outside_its_type_is_wrong_type, a_key_outside_the_contract_is_unknown, a_repeated_key_is_a_duplicate_and_not_wrong_type, problems_come_in_contract_order_then_unknown_keys, a_term_that_is_not_an_attribute_list_is_wrong_type_profile, a_list_with_a_stray_element_is_wrong_type_profile, the_art_30_1_a_citation_is_recorded, the_art_29_4_citation_is_recorded, every_returned_citation_key_implements]).
cp_test_fail_names([a_well_formed_profile_is_not_wrong_type_profile, a_shortened_citation_key_is_not_recorded]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
