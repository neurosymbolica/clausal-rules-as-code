% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_kernel, [gdpr_cooperation_with_the_supervisory_authority_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_citations, [citation/2, implements/1]).

test(the_article_31_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_31, _Record).
test(the_article_31_record_has_label_ref_and_verbatim) :-
    citation(eu_reg_2016_679_art_31, [label - _Label, ref - _Reference, verbatim - Verbatim]),
    Verbatim == 'The controller and the processor and, where applicable, their representatives, shall cooperate, on request, with the supervisory authority in the performance of its tasks.'.
test(the_cooperation_statement_target_is_recorded) :-
    citation(cooperation_statement, _Record).
test(the_marker_succeeds_for_the_recorded_key) :-
    implements(eu_reg_2016_679_art_31).
test(the_verdict_atoms_are_distinct) :-
    dif(cooperation_not_required, cooperation_met),
    dif(cooperation_not_required, cooperation_not_met),
    dif(cooperation_met, cooperation_not_met).
test(the_judgement_value_unsure_is_not_a_boolean) :-
    dif(unsure, true),
    dif(unsure, false).
test(the_indeterminate_result_names_one_key) :-
    Result = indeterminate([authority_request_made]),
    Result = indeterminate([Key]),
    Key == authority_request_made.
test(the_cross_reference_referral_builds_and_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks - true, cooperation_given - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, Status), inputs_relied_on(Pairs)]),
    Citation == cite(eu_reg_2016_679_art_31),
    Target == cite(cooperation_statement),
    Status == not_attempted,
    Pairs == [request_is_in_performance_of_authority_tasks - true, cooperation_given - absent].
test(the_open_textured_referral_builds_and_destructures) :-
    Result = needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks - unsure])]),
    Result = needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)]),
    Input == request_is_in_performance_of_authority_tasks,
    Citation == cite(eu_reg_2016_679_art_31),
    Pairs == [request_is_in_performance_of_authority_tasks - unsure].
test(the_final_basis_copies_the_attested_fact) :-
    Attested = attested(true, attestation(host_user, host_time, reply_sent, url(address, retrieved))),
    Basis = [outside_fact(cooperation_given, Attested)],
    Basis = [outside_fact(Key, attested(Value, attestation(_By, _At, _Reason, Evidence)))],
    Key == cooperation_given,
    Value == true,
    Evidence == url(address, retrieved).
test(the_input_problems_result_builds_and_destructures) :-
    Result = input_problems([wrong_type(acts_as_controller), unknown_key(colour)]),
    Result = input_problems([First|Rest]),
    First == wrong_type(acts_as_controller),
    Rest == [unknown_key(colour)].
test(a_well_formed_profile_has_no_problem) :-
    findall(Problems, gdpr_cooperation_with_the_supervisory_authority_input_problems([attribute(acts_as_controller, true), attribute(acts_as_processor, false), attribute(acts_as_representative_of_controller_or_processor, false), attribute(authority_request_made, true), attribute(request_is_in_performance_of_authority_tasks, unsure), attribute(cooperation_given, attested(true, attestation(by, at, reason, none)))], Problems), Answers),
    Answers == [[]].
test(an_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_cooperation_with_the_supervisory_authority_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_term_that_is_not_a_list_is_the_wrong_type) :-
    findall(Problems, gdpr_cooperation_with_the_supervisory_authority_input_problems(profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_the_wrong_type) :-
    findall(Problems, gdpr_cooperation_with_the_supervisory_authority_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_crisp_key_given_unsure_is_the_wrong_type) :-
    findall(Problems, gdpr_cooperation_with_the_supervisory_authority_input_problems([attribute(acts_as_controller, unsure)], Problems), Answers),
    Answers == [[wrong_type(acts_as_controller)]].
test(a_wrong_attested_value_is_the_wrong_type) :-
    findall(Problems, gdpr_cooperation_with_the_supervisory_authority_input_problems([attribute(cooperation_given, attested(maybe, attestation(by, at, reason, none)))], Problems), Answers),
    Answers == [[wrong_type(cooperation_given)]].
test(a_repeated_key_is_a_duplicate_only) :-
    findall(Problems, gdpr_cooperation_with_the_supervisory_authority_input_problems([attribute(authority_request_made, true), attribute(authority_request_made, maybe)], Problems), Answers),
    Answers == [[duplicate_key(authority_request_made)]].
test(contract_problems_come_before_unknown_keys) :-
    findall(Problems, gdpr_cooperation_with_the_supervisory_authority_input_problems([attribute(colour, red), attribute(acts_as_processor, maybe), attribute(colour, blue)], Problems), Answers),
    Answers == [[wrong_type(acts_as_processor), unknown_key(colour)]].
test(a_well_formed_profile_is_accepted) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems([attribute(authority_request_made, false)], []).

test(the_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_reg_2016_679_article_31).
test(the_placeholder_citation_is_gone, fail) :-
    citation(eu_todo_primary_source, _Record).
test(a_well_formed_profile_is_not_refused, fail) :-
    gdpr_cooperation_with_the_supervisory_authority_input_problems([attribute(authority_request_made, false)], [_Problem|_Problems]).

cp_test_names([the_article_31_citation_is_recorded, the_article_31_record_has_label_ref_and_verbatim, the_cooperation_statement_target_is_recorded, the_marker_succeeds_for_the_recorded_key, the_verdict_atoms_are_distinct, the_judgement_value_unsure_is_not_a_boolean, the_indeterminate_result_names_one_key, the_cross_reference_referral_builds_and_destructures, the_open_textured_referral_builds_and_destructures, the_final_basis_copies_the_attested_fact, the_input_problems_result_builds_and_destructures, a_well_formed_profile_has_no_problem, an_empty_profile_has_no_problem, a_term_that_is_not_a_list_is_the_wrong_type, an_unbound_profile_is_the_wrong_type, a_crisp_key_given_unsure_is_the_wrong_type, a_wrong_attested_value_is_the_wrong_type, a_repeated_key_is_a_duplicate_only, contract_problems_come_before_unknown_keys, a_well_formed_profile_is_accepted]).
cp_test_fail_names([the_marker_fails_for_an_unrecorded_key, the_placeholder_citation_is_gone, a_well_formed_profile_is_not_refused]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
