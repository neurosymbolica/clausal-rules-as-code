% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_request_basis, [request_basis_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_request_exception, [request_exception_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_fixtures, [gdpr_data_subject_rights_erasure_assess/2]).

comply_of(Subject, Comply) :-
    gdpr_data_subject_rights_erasure_assess(Subject, gdpr_data_subject_request_verdict(Comply, _, _, _, _)).

basis_of(Subject, Basis) :-
    gdpr_data_subject_rights_erasure_assess(Subject, gdpr_data_subject_request_verdict(_, Basis, _, _, _)).

exception_of(Subject, Exception) :-
    gdpr_data_subject_rights_erasure_assess(Subject, gdpr_data_subject_request_verdict(_, _, Exception, _, _)).

conditions_of(Subject, Conditions) :-
    gdpr_data_subject_rights_erasure_assess(Subject, gdpr_data_subject_request_verdict(_, _, _, Conditions, _)).

test(the_bases_are_real_basis_atoms) :-
    request_basis_status_values(BasisValues),
    member(art17_1_a, BasisValues),
    member(art17_1_b, BasisValues),
    member(art17_1_c, BasisValues),
    member(art17_1_d, BasisValues),
    member(art17_1_e, BasisValues).
test(the_exceptions_are_real_exception_atoms) :-
    request_exception_status_values(ExceptionValues),
    member(art17_3_a, ExceptionValues),
    member(art17_3_b, ExceptionValues),
    member(art17_3_d, ExceptionValues),
    member(art17_3_e, ExceptionValues),
    member(art12_5_manifestly_unfounded_or_excessive, ExceptionValues),
    member(art12_2_unable_to_identify, ExceptionValues),
    member(art23_legislative_restriction, ExceptionValues).
test(no_longer_necessary_must_comply) :-
    comply_of(must_comply_no_longer_necessary, must_comply).
test(without_request_type_is_indeterminate_on_it) :-
    comply_of(request_type_absent, indeterminate([request_type])).
test(no_ground_need_not_comply) :-
    gdpr_data_subject_rights_erasure_assess(need_not_comply_no_ground, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [cite(eu_reg_2016_679_art_17_1)])).
test(an_attested_erasure_law_engages_point_e) :-
    basis_of(must_comply_erasure_law_attested, art17_1_e).
test(an_unattested_erasure_law_refers) :-
    comply_of(needs_legal_review_erasure_law_unattested, needs_legal_review(cross_reference_unresolved(_, _), _)).
test(consent_withdrawn_engages_point_b) :-
    basis_of(must_comply_consent_withdrawn, art17_1_b).
test(another_legal_ground_need_not_comply) :-
    comply_of(need_not_comply_other_legal_ground, need_not_comply).
test(a_marketing_objection_engages_point_c) :-
    basis_of(must_comply_marketing_objection, art17_1_c).
test(overriding_grounds_need_not_comply) :-
    comply_of(need_not_comply_overriding_grounds, need_not_comply).
test(unlawful_processing_engages_point_d) :-
    basis_of(must_comply_unlawful_processing, art17_1_d).
test(unsure_unlawfulness_refers_open_textured) :-
    comply_of(needs_legal_review_unlawful_processing_unsure, needs_legal_review(open_textured(personal_data_unlawfully_processed, cite(eu_reg_2016_679_art_17_1_d)), _)).
test(freedom_of_expression_relieves) :-
    exception_of(need_not_comply_freedom_of_expression, art17_3_a).
test(freedom_of_expression_ruled_out_must_comply) :-
    comply_of(must_comply_freedom_of_expression_ruled_out, must_comply).
test(processing_required_by_law_relieves) :-
    exception_of(need_not_comply_processing_required_by_law, art17_3_b).
test(processing_obligation_attested_false_must_comply) :-
    comply_of(must_comply_processing_obligation_attested_false, must_comply).
test(a_public_task_relieves_with_the_basis_open) :-
    gdpr_data_subject_rights_erasure_assess(need_not_comply_public_task_with_basis_open, gdpr_data_subject_request_verdict(need_not_comply, none, art17_3_b, [], _)).
test(no_public_task_is_indeterminate) :-
    comply_of(indeterminate_every_missing_key, indeterminate([_|_])).
test(archiving_with_impairment_relieves) :-
    exception_of(need_not_comply_archiving_impairment, art17_3_d).
test(archiving_without_impairment_must_comply) :-
    comply_of(must_comply_archiving_without_impairment, must_comply).
test(legal_claims_relieve) :-
    exception_of(need_not_comply_legal_claims, art17_3_e).
test(unsure_legal_claims_refer) :-
    comply_of(needs_legal_review_legal_claims_unsure, needs_legal_review(open_textured(processing_necessary_for_legal_claims, cite(eu_reg_2016_679_art_17_3_e)), _)).
test(a_manifestly_unfounded_request_relieves_with_the_fee) :-
    exception_of(need_not_comply_manifestly_unfounded_with_fee, art12_5_manifestly_unfounded_or_excessive),
    conditions_of(need_not_comply_manifestly_unfounded_with_fee, [reasonable_fee_may_be_charged]).
test(a_request_not_manifestly_unfounded_must_comply) :-
    comply_of(must_comply_request_not_manifestly_unfounded, must_comply).
test(unable_to_identify_relieves) :-
    exception_of(need_not_comply_unable_to_identify, art12_2_unable_to_identify).
test(able_to_identify_must_comply) :-
    comply_of(must_comply_controller_able_to_identify, must_comply).
test(an_attested_restriction_relieves) :-
    exception_of(need_not_comply_legislative_restriction_attested, art23_legislative_restriction).
test(a_restriction_attested_false_must_comply) :-
    comply_of(must_comply_legislative_restriction_attested_false, must_comply).
test(an_unconfirmed_identity_suspends) :-
    comply_of(suspended_identity_not_confirmed, suspended(art12_6_identity_not_confirmed)).
test(a_confirmed_identity_must_comply) :-
    comply_of(must_comply_identity_confirmed, must_comply).
test(an_absent_confirmation_is_indeterminate) :-
    comply_of(indeterminate_identity_confirmed_absent, indeterminate([identity_confirmed])).
test(a_wrong_boolean_is_an_input_problem) :-
    comply_of(input_problems_wrong_boolean_value, input_problems([wrong_type(consent_withdrawn)])).
test(a_valid_boolean_must_comply) :-
    comply_of(must_comply_with_valid_boolean, must_comply).
test(a_duplicate_and_an_unknown_key_are_named) :-
    comply_of(input_problems_duplicate_and_unknown, input_problems([duplicate_key(data_no_longer_necessary_for_purposes), unknown_key(colour)])).

test(without_request_type_not_must_comply, fail) :-
    comply_of(request_type_absent, must_comply).
test(an_attested_erasure_law_is_not_need_not_comply, fail) :-
    comply_of(must_comply_erasure_law_attested, need_not_comply).
test(an_attested_false_erasure_law_does_not_refer, fail) :-
    comply_of(need_not_comply_no_ground, needs_legal_review(_, _)).
test(another_legal_ground_is_not_must_comply, fail) :-
    comply_of(need_not_comply_other_legal_ground, must_comply).
test(overriding_grounds_are_not_must_comply, fail) :-
    comply_of(need_not_comply_overriding_grounds, must_comply).
test(unsure_unlawfulness_is_not_must_comply, fail) :-
    comply_of(needs_legal_review_unlawful_processing_unsure, must_comply).
test(freedom_of_expression_ruled_out_does_not_relieve, fail) :-
    exception_of(must_comply_freedom_of_expression_ruled_out, art17_3_a).
test(processing_obligation_attested_false_does_not_relieve, fail) :-
    exception_of(must_comply_processing_obligation_attested_false, art17_3_b).
test(no_public_task_is_not_need_not_comply, fail) :-
    comply_of(indeterminate_every_missing_key, need_not_comply).
test(archiving_without_impairment_does_not_relieve, fail) :-
    exception_of(must_comply_archiving_without_impairment, art17_3_d).
test(unsure_legal_claims_do_not_relieve, fail) :-
    exception_of(needs_legal_review_legal_claims_unsure, art17_3_e).
test(a_request_not_manifestly_unfounded_does_not_relieve, fail) :-
    exception_of(must_comply_request_not_manifestly_unfounded, art12_5_manifestly_unfounded_or_excessive).
test(another_relief_carries_no_fee, fail) :-
    conditions_of(need_not_comply_freedom_of_expression, [reasonable_fee_may_be_charged]).
test(able_to_identify_does_not_relieve, fail) :-
    exception_of(must_comply_controller_able_to_identify, art12_2_unable_to_identify).
test(a_restriction_attested_false_does_not_relieve, fail) :-
    exception_of(must_comply_legislative_restriction_attested_false, art23_legislative_restriction).
test(a_confirmed_identity_does_not_suspend, fail) :-
    comply_of(must_comply_identity_confirmed, suspended(_)).
test(a_given_confirmation_is_not_indeterminate, fail) :-
    comply_of(must_comply_identity_confirmed, indeterminate(_)).
test(a_valid_boolean_is_not_an_input_problem, fail) :-
    comply_of(must_comply_with_valid_boolean, input_problems(_)).

cp_test_names([the_bases_are_real_basis_atoms, the_exceptions_are_real_exception_atoms, no_longer_necessary_must_comply, without_request_type_is_indeterminate_on_it, no_ground_need_not_comply, an_attested_erasure_law_engages_point_e, an_unattested_erasure_law_refers, consent_withdrawn_engages_point_b, another_legal_ground_need_not_comply, a_marketing_objection_engages_point_c, overriding_grounds_need_not_comply, unlawful_processing_engages_point_d, unsure_unlawfulness_refers_open_textured, freedom_of_expression_relieves, freedom_of_expression_ruled_out_must_comply, processing_required_by_law_relieves, processing_obligation_attested_false_must_comply, a_public_task_relieves_with_the_basis_open, no_public_task_is_indeterminate, archiving_with_impairment_relieves, archiving_without_impairment_must_comply, legal_claims_relieve, unsure_legal_claims_refer, a_manifestly_unfounded_request_relieves_with_the_fee, a_request_not_manifestly_unfounded_must_comply, unable_to_identify_relieves, able_to_identify_must_comply, an_attested_restriction_relieves, a_restriction_attested_false_must_comply, an_unconfirmed_identity_suspends, a_confirmed_identity_must_comply, an_absent_confirmation_is_indeterminate, a_wrong_boolean_is_an_input_problem, a_valid_boolean_must_comply, a_duplicate_and_an_unknown_key_are_named]).
cp_test_fail_names([without_request_type_not_must_comply, an_attested_erasure_law_is_not_need_not_comply, an_attested_false_erasure_law_does_not_refer, another_legal_ground_is_not_must_comply, overriding_grounds_are_not_must_comply, unsure_unlawfulness_is_not_must_comply, freedom_of_expression_ruled_out_does_not_relieve, processing_obligation_attested_false_does_not_relieve, no_public_task_is_not_need_not_comply, archiving_without_impairment_does_not_relieve, unsure_legal_claims_do_not_relieve, a_request_not_manifestly_unfounded_does_not_relieve, another_relief_carries_no_fee, able_to_identify_does_not_relieve, a_restriction_attested_false_does_not_relieve, a_confirmed_identity_does_not_suspend, a_given_confirmation_is_not_indeterminate, a_valid_boolean_is_not_an_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
