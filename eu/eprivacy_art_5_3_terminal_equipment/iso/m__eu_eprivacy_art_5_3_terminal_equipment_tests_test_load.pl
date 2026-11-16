% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_art_5_3_terminal_equipment_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_kernel, [eprivacy_art_5_3_terminal_equipment_input_problems/2, eprivacy_art_5_3_terminal_equipment_contract_keys/1]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_citations, [citation/2, implements/1]).

test(the_final_verdict_atoms_are_distinct) :-
    dif(permitted, not_permitted),
    dif(permitted, not_applicable),
    dif(not_permitted, not_applicable).
test(the_statuses_are_compound_and_distinct_from_the_final_atoms) :-
    Missing = indeterminate([storage_or_access_in_terminal_equipment]),
    Referral = needs_legal_review(open_textured(user_consent_given, cite(eu_dir_2002_58_art_2_f)), [inputs_relied_on([user_consent_given - unsure])]),
    Refusal = input_problems([wrong_type(profile)]),
    dif(Missing, permitted),
    dif(Referral, not_permitted),
    dif(Refusal, not_applicable),
    dif(Missing, Referral),
    dif(Missing, Refusal),
    dif(Referral, Refusal).
test(the_final_verdict_term_carries_status_and_citations) :-
    Verdict = eprivacy_art_5_3_terminal_equipment_verdict(permitted, [cite(eu_dir_2002_58_art_5_3)]),
    Verdict = eprivacy_art_5_3_terminal_equipment_verdict(Status, Citations),
    Status == permitted,
    Citations == [cite(eu_dir_2002_58_art_5_3)].
test(the_referral_term_destructures) :-
    Verdict = eprivacy_art_5_3_terminal_equipment_verdict(needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on([storage_or_access_in_terminal_equipment - unsure])]), []),
    Verdict = eprivacy_art_5_3_terminal_equipment_verdict(needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]), Citations),
    Key == storage_or_access_in_terminal_equipment,
    CitationKey == eu_dir_2002_58_art_5_3_s1,
    Pairs == [storage_or_access_in_terminal_equipment - unsure],
    Citations == [].
test(the_primary_citation_is_recorded) :-
    citation(eu_dir_2002_58_art_5_3, _Record).
test(every_result_citation_is_recorded) :-
    citation(eu_dir_2002_58_art_5_3_s1, _FirstSentence),
    citation(eu_dir_2002_58_art_5_3_s2, _SecondSentence),
    citation(eu_dir_2002_58_art_2_f, _Consent).
test(the_marker_resolves_for_a_recorded_key) :-
    implements(eu_dir_2002_58_art_2_a).
test(the_contract_has_six_keys) :-
    eprivacy_art_5_3_terminal_equipment_contract_keys(Keys),
    length(Keys, 6).
test(a_well_formed_profile_has_no_problem) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([attribute(storage_or_access_in_terminal_equipment, true), attribute(user_consent_given, unsure)], Problems),
    Problems == [].
test(a_non_list_profile_is_not_an_attribute_list) :-
    eprivacy_art_5_3_terminal_equipment_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].

test(the_bare_atom_indeterminate_is_not_the_status_term, fail) :-
    indeterminate = indeterminate([storage_or_access_in_terminal_equipment]).
test(the_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_todo_primary_source).

cp_test_names([the_final_verdict_atoms_are_distinct, the_statuses_are_compound_and_distinct_from_the_final_atoms, the_final_verdict_term_carries_status_and_citations, the_referral_term_destructures, the_primary_citation_is_recorded, every_result_citation_is_recorded, the_marker_resolves_for_a_recorded_key, the_contract_has_six_keys, a_well_formed_profile_has_no_problem, a_non_list_profile_is_not_an_attribute_list]).
cp_test_fail_names([the_bare_atom_indeterminate_is_not_the_status_term, the_marker_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
