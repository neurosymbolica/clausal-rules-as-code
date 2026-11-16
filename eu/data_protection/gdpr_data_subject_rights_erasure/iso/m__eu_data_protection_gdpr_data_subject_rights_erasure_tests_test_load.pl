% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_kernel, [gdpr_data_subject_rights_erasure_input_problems/2, gdpr_data_subject_rights_erasure_request_type_route/2, gdpr_data_subject_rights_erasure_first_met/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_citations, [citation/2, implements/1, gdpr_data_subject_rights_erasure_citations_in_order/2]).

test(the_verdict_term_builds_and_destructures) :-
    Verdict = gdpr_data_subject_request_verdict(must_comply, art17_1_a, none, [], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a)]),
    Verdict = gdpr_data_subject_request_verdict(Comply, Basis, Exception, Conditions, Citations),
    Comply == must_comply,
    Basis == art17_1_a,
    Exception == none,
    Conditions == [],
    Citations == [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a)].
test(the_fee_condition_rides_on_the_verdict) :-
    Verdict = gdpr_data_subject_request_verdict(need_not_comply, art17_1_d, art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], [cite(eu_reg_2016_679_art_12_5)]),
    Verdict = gdpr_data_subject_request_verdict(need_not_comply, _, art12_5_manifestly_unfounded_or_excessive, Conditions, _),
    Conditions == [reasonable_fee_may_be_charged].
test(the_referral_term_builds_and_destructures) :-
    Comply = needs_legal_review(open_textured(data_no_longer_necessary_for_purposes, cite(eu_reg_2016_679_art_17_1_a)), [inputs_relied_on([request_type - erasure, data_no_longer_necessary_for_purposes - unsure])]),
    Comply = needs_legal_review(open_textured(Input, cite(Key)), [inputs_relied_on(Pairs)]),
    Input == data_no_longer_necessary_for_purposes,
    Key == eu_reg_2016_679_art_17_1_a,
    Pairs == [request_type - erasure, data_no_longer_necessary_for_purposes - unsure].
test(the_indeterminate_compound_carries_its_keys) :-
    Comply = indeterminate([consent_withdrawn]),
    Comply = indeterminate(MissingKeys),
    MissingKeys == [consent_withdrawn].
test(the_comply_atoms_are_distinct) :-
    dif(must_comply, need_not_comply).
test(the_basis_atoms_are_distinct) :-
    dif(art17_1_a, art17_1_b),
    dif(art17_1_e, none).
test(the_exception_atoms_are_distinct) :-
    dif(art17_3_b, art23_legislative_restriction),
    dif(art12_5_manifestly_unfounded_or_excessive, art12_2_unable_to_identify).
test(the_erasure_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_17_1, _Record).
test(the_exception_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_17_3_e, _Record).
test(a_recorded_key_is_implemented) :-
    implements(eu_reg_2016_679_art_23_1).
test(citations_come_in_vocabulary_order) :-
    gdpr_data_subject_rights_erasure_citations_in_order([eu_reg_2016_679_art_17_1_a, eu_reg_2016_679_art_17_1], [cite(eu_reg_2016_679_art_17_1), cite(eu_reg_2016_679_art_17_1_a)]).
test(an_empty_profile_has_no_input_problem) :-
    gdpr_data_subject_rights_erasure_input_problems([], []).
test(a_well_formed_profile_has_no_input_problem) :-
    gdpr_data_subject_rights_erasure_input_problems([attribute(request_type, erasure), attribute(consent_withdrawn, true), attribute(data_no_longer_necessary_for_purposes, unsure)], []).
test(a_term_that_is_not_an_attribute_list_is_wrong_type) :-
    gdpr_data_subject_rights_erasure_input_problems(not_a_profile, [wrong_type(profile)]).
test(an_unknown_key_is_named) :-
    gdpr_data_subject_rights_erasure_input_problems([attribute(favourite_colour, blue)], [unknown_key(favourite_colour)]).
test(a_value_outside_its_type_is_named) :-
    gdpr_data_subject_rights_erasure_input_problems([attribute(request_type, maybe)], [wrong_type(request_type)]).
test(a_repeated_key_is_a_duplicate) :-
    gdpr_data_subject_rights_erasure_input_problems([attribute(request_type, erasure), attribute(request_type, erasure)], [duplicate_key(request_type)]).
test(the_erasure_type_is_in_this_order) :-
    gdpr_data_subject_rights_erasure_request_type_route([attribute(request_type, erasure)], in_order).
test(an_absent_type_is_absent) :-
    gdpr_data_subject_rights_erasure_request_type_route([], absent).
test(the_first_met_exception_is_named_once) :-
    findall(Exception, gdpr_data_subject_rights_erasure_first_met([art17_3_a - unmet, art17_3_b - met, art12_5_manifestly_unfounded_or_excessive - met], Exception), Exceptions),
    Exceptions == [art17_3_b].

test(the_bare_indeterminate_atom_is_not_the_compound, fail) :-
    indeterminate = indeterminate(_).
test(the_comply_atoms_do_not_unify, fail) :-
    must_comply = need_not_comply.
test(an_invented_key_is_not_recorded, fail) :-
    citation(eu_todo_primary_source, _Record).
test(a_repeated_key_is_not_wrong_type, fail) :-
    gdpr_data_subject_rights_erasure_input_problems([attribute(request_type, maybe), attribute(request_type, erasure)], [wrong_type(request_type)]).
test(an_absent_type_is_not_in_this_order, fail) :-
    gdpr_data_subject_rights_erasure_request_type_route([], in_order).

cp_test_names([the_verdict_term_builds_and_destructures, the_fee_condition_rides_on_the_verdict, the_referral_term_builds_and_destructures, the_indeterminate_compound_carries_its_keys, the_comply_atoms_are_distinct, the_basis_atoms_are_distinct, the_exception_atoms_are_distinct, the_erasure_citation_is_recorded, the_exception_citation_is_recorded, a_recorded_key_is_implemented, citations_come_in_vocabulary_order, an_empty_profile_has_no_input_problem, a_well_formed_profile_has_no_input_problem, a_term_that_is_not_an_attribute_list_is_wrong_type, an_unknown_key_is_named, a_value_outside_its_type_is_named, a_repeated_key_is_a_duplicate, the_erasure_type_is_in_this_order, an_absent_type_is_absent, the_first_met_exception_is_named_once]).
cp_test_fail_names([the_bare_indeterminate_atom_is_not_the_compound, the_comply_atoms_do_not_unify, an_invented_key_is_not_recorded, a_repeated_key_is_not_wrong_type, an_absent_type_is_not_in_this_order]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
