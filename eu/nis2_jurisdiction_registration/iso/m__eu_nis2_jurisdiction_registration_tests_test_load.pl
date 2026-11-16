% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_jurisdiction_registration_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_jurisdiction_registration_kernel, [nis2_jurisdiction_registration_input_problems/2]).
:- use_module(m__eu_nis2_jurisdiction_registration_citations, [citation/2, implements/1]).

test(an_empty_profile_has_no_problem) :-
    nis2_jurisdiction_registration_input_problems([], []).
test(a_well_formed_profile_has_no_problem) :-
    nis2_jurisdiction_registration_input_problems([attribute(entity_category, general_entity), attribute(established_in_union, true)], []).
test(an_unknown_key_is_named) :-
    nis2_jurisdiction_registration_input_problems([attribute(not_a_contract_key, true)], [unknown_key(not_a_contract_key)]).
test(a_crisp_key_given_unsure_is_a_wrong_type) :-
    nis2_jurisdiction_registration_input_problems([attribute(established_in_union, unsure)], [wrong_type(established_in_union)]).
test(a_judgement_key_may_be_unsure) :-
    nis2_jurisdiction_registration_input_problems([attribute(decisions_predominantly_taken_in_one_union_member_state, unsure)], []).
test(a_repeated_key_is_a_duplicate) :-
    nis2_jurisdiction_registration_input_problems([attribute(established_in_union, true), attribute(established_in_union, true)], [duplicate_key(established_in_union)]).
test(a_non_list_is_not_a_profile) :-
    nis2_jurisdiction_registration_input_problems(not_a_list, [wrong_type(profile)]).
test(the_verdict_atoms_are_distinct) :-
    dif(eligible, ineligible).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = nis2_jurisdiction_registration_verdict(eligible, [cite(eu_dir_2022_2555_art_26_1)]),
    Verdict = nis2_jurisdiction_registration_verdict(Status, Citations),
    Status == eligible,
    Citations == [cite(eu_dir_2022_2555_art_26_1)].
test(the_review_status_builds_and_destructures) :-
    Status = needs_legal_review(open_textured(decisions_predominantly_taken_in_one_union_member_state, cite(eu_dir_2022_2555_art_26_2)), [inputs_relied_on([decisions_predominantly_taken_in_one_union_member_state - unsure])]),
    Status = needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]),
    Key == decisions_predominantly_taken_in_one_union_member_state,
    Citation == cite(eu_dir_2022_2555_art_26_2),
    Pairs == [decisions_predominantly_taken_in_one_union_member_state - unsure].
test(the_missing_key_status_builds_and_destructures) :-
    Status = indeterminate([entity_category]),
    Status = indeterminate(MissingKeys),
    MissingKeys == [entity_category].
test(the_list_terms_build_and_destructure) :-
    Item = item(entity_name, cite(eu_dir_2022_2555_art_27_2_a)),
    Item = item(Name, ItemCitation),
    Name == entity_name,
    ItemCitation == cite(eu_dir_2022_2555_art_27_2_a),
    Limit = limit(registry_information, months_after_change(3), cite(eu_dir_2022_2555_art_27_3)),
    Limit = limit(Regime, months_after_change(Months), LimitCitation),
    Regime == registry_information,
    Months == 3,
    LimitCitation == cite(eu_dir_2022_2555_art_27_3).
test(a_real_citation_record_resolves) :-
    citation(eu_dir_2022_2555_art_26_1, _Record).
test(a_recorded_key_is_implemented) :-
    implements(eu_dir_2022_2555_art_26_2).

test(a_well_formed_profile_is_not_refused, fail) :-
    nis2_jurisdiction_registration_input_problems([attribute(entity_category, general_entity)], [_|_]).
test(an_unrecorded_key_is_not_implemented, fail) :-
    implements(eu_todo_primary_source).

cp_test_names([an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, an_unknown_key_is_named, a_crisp_key_given_unsure_is_a_wrong_type, a_judgement_key_may_be_unsure, a_repeated_key_is_a_duplicate, a_non_list_is_not_a_profile, the_verdict_atoms_are_distinct, the_verdict_term_carries_status_and_citations, the_review_status_builds_and_destructures, the_missing_key_status_builds_and_destructures, the_list_terms_build_and_destructure, a_real_citation_record_resolves, a_recorded_key_is_implemented]).
cp_test_fail_names([a_well_formed_profile_is_not_refused, an_unrecorded_key_is_not_implemented]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
