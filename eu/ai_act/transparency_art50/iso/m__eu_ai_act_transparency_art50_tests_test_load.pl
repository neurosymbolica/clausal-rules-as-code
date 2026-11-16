% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_transparency_art50_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_transparency_art50_kernel, [transparency_art50_input_problems/2, transparency_art50_calendar_day_t/2, transparency_art50_item_state/3, transparency_art50_test_outcome/3]).
:- use_module(m__eu_ai_act_transparency_art50_citations, [citation/2, implements/1, citation_vocabulary/1]).

test(the_verdict_term_carries_result_and_citations) :-
    Verdict = transparency_art50_verdict(duty_applies, [cite(eu_reg_2024_1689_art_50_1)]),
    Verdict = transparency_art50_verdict(Result, Citations),
    Result == duty_applies,
    Citations == [cite(eu_reg_2024_1689_art_50_1)].
test(the_not_final_term_carries_one_key_and_no_citation) :-
    Verdict = transparency_art50_verdict(indeterminate([ai_system]), []),
    Verdict = transparency_art50_verdict(indeterminate([MissingKey]), Citations),
    MissingKey == ai_system,
    Citations == [].
test(the_referral_term_destructures) :-
    Result = needs_legal_review(open_textured(ai_system, cite(eu_reg_2024_1689_art_3_1)), [inputs_relied_on([ai_system - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == ai_system,
    CitationKey == eu_reg_2024_1689_art_3_1,
    Pairs == [ai_system - unsure].
test(the_status_atoms_are_distinct) :-
    Atoms = [duty_applies, limited_disclosure_applies, duty_does_not_apply, not_applicable_on_date, not_an_ai_system, in_transitional_period, compliant, not_compliant],
    sort(Atoms, Sorted),
    length(Sorted, 8).
test(duty_applies_is_not_duty_does_not_apply) :-
    dif(duty_applies, duty_does_not_apply).
test(compliant_is_not_not_compliant) :-
    dif(compliant, not_compliant).
test(the_duty_atoms_are_distinct) :-
    Duties = [interaction_information, machine_readable_marking, emotion_recognition_or_biometric_categorisation_information, deep_fake_disclosure, public_interest_text_disclosure],
    sort(Duties, Sorted),
    length(Sorted, 5).
test(the_date_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_113, _Record).
test(the_interaction_citation_is_recorded) :-
    citation(eu_reg_2024_1689_art_50_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(every_vocabulary_key_resolves) :-
    findall(Key, citation_vocabulary(Key), Keys),
    length(Keys, 9),
    maplist(implements, Keys).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, transparency_art50_input_problems([], Problems), Answers),
    Answers == [[]].
test(an_unknown_key_is_named) :-
    transparency_art50_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(a_repeated_key_is_a_duplicate) :-
    transparency_art50_input_problems([attribute(ai_system, true), attribute(ai_system, true)], [duplicate_key(ai_system)]).
test(a_non_list_profile_is_a_wrong_type) :-
    transparency_art50_input_problems(profile, [wrong_type(profile)]).
test(the_first_day_of_application_is_a_calendar_day) :-
    transparency_art50_calendar_day_t(date(2026, 8, 2), true).
test(an_impossible_day_is_not_a_calendar_day) :-
    transparency_art50_calendar_day_t(date(2026, 2, 30), false).
test(a_present_condition_holds) :-
    transparency_art50_item_state([attribute(ai_system, true)], condition(ai_system, true), holds).
test(an_absent_condition_is_undetermined) :-
    transparency_art50_item_state([], condition(ai_system, true), undetermined(ai_system)).
test(a_met_test_is_met) :-
    transparency_art50_test_outcome([attribute(intended_to_interact_directly_with_natural_persons, true)], [condition(intended_to_interact_directly_with_natural_persons, true)], test_met).
test(a_failed_test_is_failed) :-
    transparency_art50_test_outcome([attribute(intended_to_interact_directly_with_natural_persons, false)], [condition(intended_to_interact_directly_with_natural_persons, true)], test_failed).

test(a_shortened_citation_is_not_recorded, fail) :-
    citation(art_50_1, _Record).
test(an_unknown_key_is_not_accepted, fail) :-
    transparency_art50_input_problems([attribute(colour, red)], []).
test(a_failed_test_is_not_met, fail) :-
    transparency_art50_test_outcome([attribute(intended_to_interact_directly_with_natural_persons, false)], [condition(intended_to_interact_directly_with_natural_persons, true)], test_met).

cp_test_names([the_verdict_term_carries_result_and_citations, the_not_final_term_carries_one_key_and_no_citation, the_referral_term_destructures, the_status_atoms_are_distinct, duty_applies_is_not_duty_does_not_apply, compliant_is_not_not_compliant, the_duty_atoms_are_distinct, the_date_citation_is_recorded, the_interaction_citation_is_recorded, every_vocabulary_key_resolves, an_empty_profile_has_no_problem, an_unknown_key_is_named, a_repeated_key_is_a_duplicate, a_non_list_profile_is_a_wrong_type, the_first_day_of_application_is_a_calendar_day, an_impossible_day_is_not_a_calendar_day, a_present_condition_holds, an_absent_condition_is_undetermined, a_met_test_is_met, a_failed_test_is_failed]).
cp_test_fail_names([a_shortened_citation_is_not_recorded, an_unknown_key_is_not_accepted, a_failed_test_is_not_met]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
