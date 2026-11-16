% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_kernel, [gdpr_data_subject_rights_portability_and_objection_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_portability_and_objection_citations, [citation/2, implements/1]).

test(the_comply_atoms_are_distinct) :-
    dif(must_comply, need_not_comply).
test(the_basis_atoms_are_distinct) :-
    dif(art20_1, art21_1),
    dif(art21_1, art21_2),
    dif(art21_2, art21_6),
    dif(art21_6, none).
test(the_verdict_term_builds_and_destructures) :-
    Verdict = gdpr_data_subject_request_verdict(must_comply, art20_1, none, [], [cite(eu_reg_2016_679_art_20_1)]),
    Verdict = gdpr_data_subject_request_verdict(Comply, Basis, Exception, Conditions, Citations),
    Comply == must_comply,
    Basis == art20_1,
    Exception == none,
    Conditions == [],
    Citations == [cite(eu_reg_2016_679_art_20_1)].
test(the_conditional_verdict_carries_its_condition) :-
    Verdict = gdpr_data_subject_request_verdict(need_not_comply, art21_1, art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], []),
    Verdict = gdpr_data_subject_request_verdict(_, _, _, Conditions, _),
    Conditions == [reasonable_fee_may_be_charged].
test(the_compound_statuses_build) :-
    Missing = indeterminate([request_type]),
    Missing = indeterminate(Keys),
    Keys == [request_type],
    Suspended = suspended(art12_6_identity_not_confirmed),
    Suspended = suspended(Reason),
    Reason == art12_6_identity_not_confirmed.
test(the_legal_review_status_builds) :-
    Review = needs_legal_review(open_textured(transmission_would_adversely_affect_rights_and_freedoms_of_others, cite(eu_reg_2016_679_art_20_4)), [inputs_relied_on([request_type - portability])]),
    Review = needs_legal_review(open_textured(Input, cite(Key)), [inputs_relied_on(Pairs)]),
    Input == transmission_would_adversely_affect_rights_and_freedoms_of_others,
    Key == eu_reg_2016_679_art_20_4,
    Pairs == [request_type - portability].
test(a_real_citation_record_resolves) :-
    citation(eu_reg_2016_679_art_20_1, Record),
    Record = [label - _, ref - _, verbatim - _].
test(implements_succeeds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_21_2).
test(the_kernel_input_check_accepts_an_empty_profile) :-
    gdpr_data_subject_rights_portability_and_objection_input_problems([], []).
test(the_kernel_input_check_accepts_a_well_formed_profile) :-
    gdpr_data_subject_rights_portability_and_objection_input_problems([attribute(request_type, portability), attribute(processing_carried_out_by_automated_means, true)], []).
test(the_kernel_input_check_names_an_unknown_key) :-
    gdpr_data_subject_rights_portability_and_objection_input_problems([attribute(bogus_key, true)], [unknown_key(bogus_key)]).
test(the_kernel_input_check_names_a_wrong_type) :-
    gdpr_data_subject_rights_portability_and_objection_input_problems([attribute(request_type, nonsense)], [wrong_type(request_type)]).
test(the_kernel_input_check_names_a_duplicate_key) :-
    gdpr_data_subject_rights_portability_and_objection_input_problems([attribute(request_type, portability), attribute(request_type, objection)], [duplicate_key(request_type)]).
test(a_non_list_profile_is_wrong_type_profile) :-
    gdpr_data_subject_rights_portability_and_objection_input_problems(not_a_list, [wrong_type(profile)]).

test(an_unrecorded_citation_does_not_resolve, fail) :-
    citation(eu_reg_2016_679_art_99_9, _).

cp_test_names([the_comply_atoms_are_distinct, the_basis_atoms_are_distinct, the_verdict_term_builds_and_destructures, the_conditional_verdict_carries_its_condition, the_compound_statuses_build, the_legal_review_status_builds, a_real_citation_record_resolves, implements_succeeds_for_a_recorded_key, the_kernel_input_check_accepts_an_empty_profile, the_kernel_input_check_accepts_a_well_formed_profile, the_kernel_input_check_names_an_unknown_key, the_kernel_input_check_names_a_wrong_type, the_kernel_input_check_names_a_duplicate_key, a_non_list_profile_is_wrong_type_profile]).
cp_test_fail_names([an_unrecorded_citation_does_not_resolve]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
