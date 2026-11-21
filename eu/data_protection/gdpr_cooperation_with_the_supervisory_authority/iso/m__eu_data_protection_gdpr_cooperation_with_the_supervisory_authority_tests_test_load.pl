% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_kernel, [gdpr_cooperation_with_the_supervisory_authority_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_citations, [citation/2, implements/1]).

test(the_result_atoms_are_distinct) :-
    dif(cooperation_not_required, cooperation_met),
    dif(cooperation_not_required, cooperation_not_met),
    dif(cooperation_met, cooperation_not_met).
test(the_judgement_value_unsure_is_not_a_boolean) :-
    dif(unsure, true),
    dif(unsure, false).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = gdpr_cooperation_with_the_supervisory_authority_verdict(cooperation_met, [cite(eu_reg_2016_679_art_31)]),
    Verdict = gdpr_cooperation_with_the_supervisory_authority_verdict(Status, Citations),
    Status == cooperation_met,
    Citations == [cite(eu_reg_2016_679_art_31)].
test(the_indeterminate_term_names_one_key) :-
    Result = indeterminate([authority_request_made]),
    Result = indeterminate([Key]),
    Key == authority_request_made.
test(the_cross_reference_referral_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - true, cooperation_given - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), Resolution), inputs_relied_on(Pairs)]),
    Citation == eu_reg_2016_679_art_31,
    Target == cooperation_statement,
    Resolution == not_attempted,
    Pairs == [request_is_in_performance_of_authority_tasks - true, cooperation_given - absent].
test(the_open_textured_referral_destructures) :-
    Result = needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])]),
    Result = needs_legal_review(open_textured(Input, cite(Citation)), [inputs_relied_on(Pairs)]),
    Input == request_is_in_performance_of_authority_tasks,
    Citation == eu_reg_2016_679_art_31,
    Pairs == [request_is_in_performance_of_authority_tasks - unsure].
test(the_outside_fact_basis_copies_the_attestation) :-
    Attested = attested(true, attestation(host, '2026-11-12T10:00:00Z', statement_received, none)),
    Basis = [outside_fact(cooperation_given, Attested)],
    Basis = [outside_fact(Key, Copied)],
    Key == cooperation_given,
    Copied == Attested.
test(the_article_31_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_31, _Record).
test(the_cooperation_statement_target_is_recorded) :-
    citation(cooperation_statement, _Record).
test(implements_holds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_31).
test(a_well_formed_profile_has_no_problem) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems([attribute(acts_as_controller, true), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, unsure), attribute(cooperation_given, attested(false, attestation(host, '2026-11-12T10:00:00Z', statement_received, none)))], Problems),
    Problems == [].
test(an_empty_profile_has_no_problem) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems([], Problems),
    Problems == [].
test(a_crisp_key_given_unsure_is_wrong_type) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems([attribute(authority_request_made, unsure)], Problems),
    Problems == [wrong_type(authority_request_made)].
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(a_repeated_key_is_a_duplicate) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems([attribute(acts_as_processor, true), attribute(acts_as_processor, true)], Problems),
    Problems == [duplicate_key(acts_as_processor)].
test(a_key_outside_the_contract_is_unknown) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems([attribute(acts_as_joint_controller, true)], Problems),
    Problems == [unknown_key(acts_as_joint_controller)].

test(implements_fails_for_an_unrecorded_key, fail) :-
    implements(eu_reg_2016_679_art_99).
test(a_crisp_key_given_unsure_is_not_well_formed, fail) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems([attribute(authority_request_made, unsure)], []).
test(a_term_that_is_not_a_list_is_not_well_formed, fail) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems(not_a_profile, []).

cp_test_names([the_result_atoms_are_distinct, the_judgement_value_unsure_is_not_a_boolean, the_verdict_term_carries_status_and_citations, the_indeterminate_term_names_one_key, the_cross_reference_referral_destructures, the_open_textured_referral_destructures, the_outside_fact_basis_copies_the_attestation, the_article_31_citation_is_recorded, the_cooperation_statement_target_is_recorded, implements_holds_for_a_recorded_key, a_well_formed_profile_has_no_problem, an_empty_profile_has_no_problem, a_crisp_key_given_unsure_is_wrong_type, a_term_that_is_not_a_list_is_wrong_type_profile, a_repeated_key_is_a_duplicate, a_key_outside_the_contract_is_unknown]).
cp_test_fail_names([implements_fails_for_an_unrecorded_key, a_crisp_key_given_unsure_is_not_well_formed, a_term_that_is_not_a_list_is_not_well_formed]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
