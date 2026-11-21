% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_kernel, [gdpr_art36_3_consultation_request_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_citations, [citation/2, implements/1]).

test(the_verdict_term_carries_status_and_citations) :-
    Verdict = gdpr_art36_3_consultation_request_verdict(consultation_request_complete, [cite(eu_reg_2016_679_art_36_3)]),
    Verdict = gdpr_art36_3_consultation_request_verdict(Status, Citations),
    Status == consultation_request_complete,
    Citations == [cite(eu_reg_2016_679_art_36_3)].
test(the_result_atoms_are_distinct) :-
    dif(consultation_request_complete, consultation_request_incomplete),
    dif(consultation_request_complete, not_governed_by_article_36_3),
    dif(consultation_request_incomplete, not_governed_by_article_36_3).
test(the_item_atoms_are_distinct) :-
    Items = [respective_responsibilities, purposes_and_means, measures_and_safeguards, data_protection_officer_contact_details, data_protection_impact_assessment, other_requested_information],
    sort(Items, Sorted),
    length(Sorted, Count),
    Count == 6.
test(the_indeterminate_status_destructures) :-
    Result = indeterminate([purposes_and_means_provided]),
    Result = indeterminate([Key]),
    Key == purposes_and_means_provided.
test(the_absent_referral_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_3_a), cite(controller_and_processor_roles_statement)), [resolution(cite(controller_and_processor_roles_statement), not_attempted), inputs_relied_on([joint_controllers_or_processors_involved - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), Resolution), inputs_relied_on(Pairs)]),
    Citation == eu_reg_2016_679_art_36_3_a,
    Target == controller_and_processor_roles_statement,
    Resolution == not_attempted,
    Pairs == [joint_controllers_or_processors_involved - absent].
test(the_outside_fact_basis_destructures) :-
    Attested = attested(true, attestation(host, moment, reason, none)),
    Basis = [outside_fact(joint_controllers_or_processors_involved, Attested)],
    Basis = [outside_fact(Key, attested(Value, attestation(_, _, _, Evidence)))],
    Key == joint_controllers_or_processors_involved,
    Value == true,
    Evidence == none.
test(the_primary_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_36_3, _Record).
test(the_referral_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_36_3_a, _Record).
test(the_referral_target_is_recorded) :-
    citation(controller_and_processor_roles_statement, _Record).
test(the_provenance_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_36_3_f).
test(the_input_check_loads_and_accepts_an_empty_profile) :-
    gdpr_art36_3_consultation_request_input_problems([], Problems),
    Problems == [].
test(the_input_check_refuses_a_non_list) :-
    gdpr_art36_3_consultation_request_input_problems(profile, Problems),
    Problems == [wrong_type(profile)].
test(the_input_check_names_an_unknown_key) :-
    gdpr_art36_3_consultation_request_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].

test(the_provenance_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_todo_primary_source).

cp_test_names([the_verdict_term_carries_status_and_citations, the_result_atoms_are_distinct, the_item_atoms_are_distinct, the_indeterminate_status_destructures, the_absent_referral_destructures, the_outside_fact_basis_destructures, the_primary_citation_is_recorded, the_referral_citation_is_recorded, the_referral_target_is_recorded, the_provenance_marker_holds_for_a_recorded_key, the_input_check_loads_and_accepts_an_empty_profile, the_input_check_refuses_a_non_list, the_input_check_names_an_unknown_key]).
cp_test_fail_names([the_provenance_marker_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
