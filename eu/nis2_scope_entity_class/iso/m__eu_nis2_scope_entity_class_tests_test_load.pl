% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_scope_entity_class_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_scope_entity_class_kernel, [nis2_scope_entity_class_input_problems/2]).
:- use_module(m__eu_nis2_scope_entity_class_citations, [citation/2, implements/1]).

test(the_verdict_atoms_are_distinct) :-
    dif(eligible, ineligible).
test(the_result_atoms_are_distinct) :-
    dif(in_scope, out_of_scope),
    dif(essential_entity, important_entity).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = nis2_scope_entity_class_verdict(eligible, [cite(eu_dir_2022_2555_art_2_1)]),
    Verdict = nis2_scope_entity_class_verdict(Status, Citations),
    Status == eligible,
    Citations == [cite(eu_dir_2022_2555_art_2_1)].
test(the_indeterminate_status_destructures) :-
    Status = indeterminate([staff_headcount]),
    Status = indeterminate(MissingKeys),
    MissingKeys == [staff_headcount].
test(the_needs_legal_review_status_destructures) :-
    Status = needs_legal_review(open_textured(annex_i_type, cite(eu_dir_2022_2555_art_2_1)), [inputs_relied_on([annex_i_type - unsure])]),
    Status = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == annex_i_type,
    CitationKey == eu_dir_2022_2555_art_2_1,
    Pairs == [annex_i_type - unsure].
test(a_real_citation_record_resolves) :-
    citation(eu_dir_2022_2555_art_2_1, _Record).
test(a_class_citation_record_resolves) :-
    citation(eu_dir_2022_2555_art_3_2, _Record).
test(the_provenance_marker_accepts_a_recorded_key) :-
    implements(eu_dir_2022_2555_art_2_4).
test(an_empty_profile_has_no_input_problem) :-
    nis2_scope_entity_class_input_problems([], []).
test(a_well_formed_profile_has_no_input_problem) :-
    nis2_scope_entity_class_input_problems([attribute(staff_headcount, 10), attribute(tld_name_registry, false)], []).
test(an_unknown_key_is_named) :-
    nis2_scope_entity_class_input_problems([attribute(shoe_size, 42)], [unknown_key(shoe_size)]).
test(a_non_list_profile_is_wrong_type) :-
    nis2_scope_entity_class_input_problems(not_a_profile, [wrong_type(profile)]).

test(the_provenance_marker_refuses_an_unrecorded_key, fail) :-
    implements(eu_dir_2022_2555_art_9_9).
test(a_wrong_typed_value_is_named_and_a_well_formed_one_is_not, fail) :-
    nis2_scope_entity_class_input_problems([attribute(staff_headcount, -1)], []).

cp_test_names([the_verdict_atoms_are_distinct, the_result_atoms_are_distinct, the_verdict_term_carries_status_and_citations, the_indeterminate_status_destructures, the_needs_legal_review_status_destructures, a_real_citation_record_resolves, a_class_citation_record_resolves, the_provenance_marker_accepts_a_recorded_key, an_empty_profile_has_no_input_problem, a_well_formed_profile_has_no_input_problem, an_unknown_key_is_named, a_non_list_profile_is_wrong_type]).
cp_test_fail_names([the_provenance_marker_refuses_an_unrecorded_key, a_wrong_typed_value_is_named_and_a_well_formed_one_is_not]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
