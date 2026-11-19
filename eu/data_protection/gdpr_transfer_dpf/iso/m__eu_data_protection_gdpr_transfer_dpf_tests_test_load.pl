% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_dpf_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_kernel, [gdpr_transfer_dpf_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_citations, [citation/2, implements/1]).

test(the_result_atoms_are_distinct) :-
    dif(covered_by_data_privacy_framework_adequacy, not_covered_by_data_privacy_framework_adequacy).
test(the_result_atoms_are_atoms) :-
    atom(covered_by_data_privacy_framework_adequacy),
    atom(not_covered_by_data_privacy_framework_adequacy).
test(the_verdict_term_carries_result_and_citations) :-
    Verdict = gdpr_transfer_dpf_verdict(covered_by_data_privacy_framework_adequacy, [cite(eu_dec_2023_1795_art_1), cite(eu_reg_2016_679_art_45_1)]),
    Verdict = gdpr_transfer_dpf_verdict(Result, Citations),
    Result == covered_by_data_privacy_framework_adequacy,
    Citations == [cite(eu_dec_2023_1795_art_1), cite(eu_reg_2016_679_art_45_1)].
test(the_absent_referral_builds_and_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_dec_2023_1795_art_1), cite(data_privacy_framework_list_entry_statement)), [resolution(cite(data_privacy_framework_list_entry_statement), not_attempted), inputs_relied_on([recipient_on_data_privacy_framework_list - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(ResolvedTarget), Status), inputs_relied_on(Pairs)]),
    Citation == eu_dec_2023_1795_art_1,
    Target == data_privacy_framework_list_entry_statement,
    ResolvedTarget == Target,
    Status == not_attempted,
    Pairs == [recipient_on_data_privacy_framework_list - absent].
test(indeterminate_names_one_key) :-
    Result = indeterminate([transfer_from_union]),
    Result = indeterminate(MissingKeys),
    MissingKeys == [transfer_from_union].
test(the_basis_item_keeps_the_attested_term_whole) :-
    Attested = attested(false, attestation(by, at, reason, none)),
    Item = outside_fact(certification_covers_transferred_data, Attested),
    Item = outside_fact(Key, attested(Value, attestation(_, _, _, Evidence))),
    Key == certification_covers_transferred_data,
    Value == false,
    Evidence == none.
test(the_operative_citation_resolves) :-
    citation(eu_dec_2023_1795_art_1, _Record).
test(the_effect_citation_resolves) :-
    citation(eu_reg_2016_679_art_45_1, _Record).
test(each_referral_target_resolves) :-
    citation(data_privacy_framework_decision_in_force_statement, _DecisionRecord),
    citation(data_privacy_framework_list_entry_statement, _ListRecord),
    citation(data_privacy_framework_certification_coverage_statement, _CoverageRecord).
test(the_marker_holds_for_a_recorded_key) :-
    implements(eu_dec_2023_1795_art_1).
test(the_input_check_accepts_an_empty_profile) :-
    gdpr_transfer_dpf_input_problems([], []).
test(the_input_check_names_an_unknown_key) :-
    gdpr_transfer_dpf_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(the_input_check_refuses_a_non_list) :-
    gdpr_transfer_dpf_input_problems(not_a_profile, [wrong_type(profile)]).

test(a_result_atom_does_not_unify_with_the_other, fail) :-
    covered_by_data_privacy_framework_adequacy = not_covered_by_data_privacy_framework_adequacy.
test(the_bare_atom_indeterminate_is_not_the_status, fail) :-
    indeterminate = indeterminate([transfer_from_union]).
test(the_placeholder_citation_is_gone, fail) :-
    citation(eu_todo_primary_source, _Record).

cp_test_names([the_result_atoms_are_distinct, the_result_atoms_are_atoms, the_verdict_term_carries_result_and_citations, the_absent_referral_builds_and_destructures, indeterminate_names_one_key, the_basis_item_keeps_the_attested_term_whole, the_operative_citation_resolves, the_effect_citation_resolves, each_referral_target_resolves, the_marker_holds_for_a_recorded_key, the_input_check_accepts_an_empty_profile, the_input_check_names_an_unknown_key, the_input_check_refuses_a_non_list]).
cp_test_fail_names([a_result_atom_does_not_unify_with_the_other, the_bare_atom_indeterminate_is_not_the_status, the_placeholder_citation_is_gone]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
