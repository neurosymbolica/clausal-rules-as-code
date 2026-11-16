% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_kernel, [gdpr_compensation_and_liability_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_citations, [citation/2, implements/1]).

test(the_result_atoms_are_distinct) :-
    dif(right_not_established, not_liable_for_damage),
    dif(right_not_established, exempt_from_liability),
    dif(right_not_established, liable_for_damage),
    dif(not_liable_for_damage, exempt_from_liability),
    dif(not_liable_for_damage, liable_for_damage),
    dif(exempt_from_liability, liable_for_damage).
test(the_party_role_atoms_are_distinct) :-
    dif(controller, processor).
test(the_judgement_values_are_distinct) :-
    dif(true, unsure),
    dif(false, unsure),
    dif(true, false).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = gdpr_compensation_and_liability_verdict(liable_for_damage, [cite(eu_reg_2016_679_art_82_1), cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]),
    Verdict = gdpr_compensation_and_liability_verdict(Status, Citations),
    Status == liable_for_damage,
    Citations == [cite(eu_reg_2016_679_art_82_1), cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)].
test(the_indeterminate_term_names_one_key) :-
    Result = indeterminate([damage_suffered]),
    Result = indeterminate([MissingKey]),
    MissingKey == damage_suffered.
test(the_open_textured_referral_destructures) :-
    Result = needs_legal_review(open_textured(damage_suffered, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on([damage_suffered - unsure, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - true])]),
    Result = needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)]),
    Input == damage_suffered,
    Citation == cite(eu_reg_2016_679_art_82_1),
    Pairs == [damage_suffered - unsure, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - true].
test(the_cross_reference_referral_destructures) :-
    Result = needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), [resolution(cite(non_responsibility_statement), not_attempted), inputs_relied_on([damage_suffered - true, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - true, not_in_any_way_responsible_for_the_event - absent])]),
    Result = needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, Status), inputs_relied_on(Pairs)]),
    Citation == cite(eu_reg_2016_679_art_82_3),
    Target == cite(non_responsibility_statement),
    Status == not_attempted,
    last(Pairs, LastPair),
    LastPair == not_in_any_way_responsible_for_the_event - absent.
test(the_outside_fact_basis_destructures) :-
    Attested = attested(false, attestation(host_user, at_time, reason_given, none)),
    Basis = [outside_fact(not_in_any_way_responsible_for_the_event, Attested)],
    Basis = [outside_fact(Key, Copied)],
    Key == not_in_any_way_responsible_for_the_event,
    Copied == Attested.
test(the_right_to_compensation_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_82_1, _Record).
test(the_liability_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_82_2, _Record).
test(the_exemption_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_82_3, _Record).
test(the_cross_reference_target_is_recorded) :-
    citation(non_responsibility_statement, _Record).
test(the_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_82_1).
test(an_empty_profile_has_no_problem) :-
    gdpr_compensation_and_liability_input_problems([], Problems),
    Problems == [].
test(a_well_formed_profile_has_no_problem) :-
    gdpr_compensation_and_liability_input_problems([attribute(party_role, controller), attribute(involved_in_the_processing, true), attribute(damage_suffered, unsure)], Problems),
    Problems == [].
test(a_wrong_party_role_is_wrong_type) :-
    gdpr_compensation_and_liability_input_problems([attribute(party_role, both)], Problems),
    Problems == [wrong_type(party_role)].
test(a_key_outside_the_contract_is_unknown) :-
    gdpr_compensation_and_liability_input_problems([attribute(colour, red)], Problems),
    Problems == [unknown_key(colour)].
test(a_non_list_profile_is_wrong_type) :-
    gdpr_compensation_and_liability_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].

test(the_marker_fails_for_a_shortened_key, fail) :-
    implements(art_82_1).
test(a_wrong_party_role_is_not_accepted, fail) :-
    gdpr_compensation_and_liability_input_problems([attribute(party_role, both)], []).

cp_test_names([the_result_atoms_are_distinct, the_party_role_atoms_are_distinct, the_judgement_values_are_distinct, the_verdict_term_carries_status_and_citations, the_indeterminate_term_names_one_key, the_open_textured_referral_destructures, the_cross_reference_referral_destructures, the_outside_fact_basis_destructures, the_right_to_compensation_citation_is_recorded, the_liability_citation_is_recorded, the_exemption_citation_is_recorded, the_cross_reference_target_is_recorded, the_marker_holds_for_a_recorded_key, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_wrong_party_role_is_wrong_type, a_key_outside_the_contract_is_unknown, a_non_list_profile_is_wrong_type]).
cp_test_fail_names([the_marker_fails_for_a_shortened_key, a_wrong_party_role_is_not_accepted]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
