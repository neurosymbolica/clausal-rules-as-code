% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_request_basis, [decide_request_basis/2, request_basis_status/2, decide_data_subject_request/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_access_rectification_restriction_fixtures, [gdpr_data_subject_rights_access_rectification_restriction_profile_for/2, gdpr_data_subject_rights_access_rectification_restriction_assess/2]).

test(the_baseline_profile_yields_exactly_one_status) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_plain, Profile),
    findall(Status, request_basis_status(Profile, Status), Statuses),
    Statuses == [art15_1].
test(the_baseline_profile_yields_exactly_one_verdict) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_plain, Profile),
    findall(Verdict, decide_data_subject_request(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_data_subject_request_verdict(must_comply, art15_1, none, [], [cite(eu_reg_2016_679_art_15_1)])].
test(the_verdict_carries_a_citation) :-
    gdpr_data_subject_rights_access_rectification_restriction_profile_for(access_plain, Profile),
    decide_request_basis(Profile, request_basis_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(manifestly_unfounded_relief_carries_the_fee_condition) :-
    gdpr_data_subject_rights_access_rectification_restriction_assess(access_unfounded, gdpr_data_subject_request_verdict(need_not_comply, art15_1, art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], [cite(eu_reg_2016_679_art_12_5), cite(eu_reg_2016_679_art_15_1)])).
test(unable_to_identify_relief) :-
    gdpr_data_subject_rights_access_rectification_restriction_assess(access_unable_to_identify, gdpr_data_subject_request_verdict(need_not_comply, art15_1, art12_2_unable_to_identify, [], [cite(eu_reg_2016_679_art_12_2), cite(eu_reg_2016_679_art_15_1)])).
test(legislative_restriction_relief) :-
    gdpr_data_subject_rights_access_rectification_restriction_assess(access_restricted_by_law, gdpr_data_subject_request_verdict(need_not_comply, art15_1, art23_legislative_restriction, [], [cite(eu_reg_2016_679_art_15_1), cite(eu_reg_2016_679_art_23_1)])).
test(identity_suspension_is_a_non_final_status) :-
    gdpr_data_subject_rights_access_rectification_restriction_assess(access_identity_suspended, gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), none, none, [], [])).
test(identity_unconfirmed_and_unknown_names_the_missing_key) :-
    gdpr_data_subject_rights_access_rectification_restriction_assess(access_identity_unknown, gdpr_data_subject_request_verdict(indeterminate([identity_confirmed]), none, none, [], [])).
test(unsure_judgement_is_handed_to_the_user) :-
    gdpr_data_subject_rights_access_rectification_restriction_assess(access_unfounded_unsure, gdpr_data_subject_request_verdict(needs_legal_review(open_textured(request_manifestly_unfounded_or_excessive, cite(eu_reg_2016_679_art_12_5)), [inputs_relied_on([request_type - access, request_manifestly_unfounded_or_excessive - unsure])]), none, none, [], [])).
test(rectification_inaccurate_basis) :-
    gdpr_data_subject_rights_access_rectification_restriction_assess(rectification_inaccurate, gdpr_data_subject_request_verdict(must_comply, art16_inaccurate_data, none, [], [cite(eu_reg_2016_679_art_16)])).
test(rectification_incomplete_basis) :-
    gdpr_data_subject_rights_access_rectification_restriction_assess(rectification_incomplete, gdpr_data_subject_request_verdict(must_comply, art16_incomplete_data, none, [], [cite(eu_reg_2016_679_art_16)])).
test(rectification_not_engaged_cites_the_article_alone) :-
    gdpr_data_subject_rights_access_rectification_restriction_assess(rectification_not_engaged, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [cite(eu_reg_2016_679_art_16)])).
test(restriction_point_a) :-
    gdpr_data_subject_rights_access_rectification_restriction_assess(restriction_accuracy_contested, gdpr_data_subject_request_verdict(must_comply, art18_1_a, none, [], [cite(eu_reg_2016_679_art_18_1), cite(eu_reg_2016_679_art_18_1_a)])).
test(restriction_point_b) :-
    gdpr_data_subject_rights_access_rectification_restriction_assess(restriction_unlawful_opposed, gdpr_data_subject_request_verdict(must_comply, art18_1_b, none, [], [cite(eu_reg_2016_679_art_18_1), cite(eu_reg_2016_679_art_18_1_b)])).
test(restriction_point_d) :-
    gdpr_data_subject_rights_access_rectification_restriction_assess(restriction_objection_pending, gdpr_data_subject_request_verdict(must_comply, art18_1_d, none, [], [cite(eu_reg_2016_679_art_18_1), cite(eu_reg_2016_679_art_18_1_d)])).
test(restriction_not_engaged) :-
    gdpr_data_subject_rights_access_rectification_restriction_assess(restriction_not_engaged, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [cite(eu_reg_2016_679_art_18_1)])).
test(restriction_verification_unknown) :-
    gdpr_data_subject_rights_access_rectification_restriction_assess(restriction_verification_unknown, gdpr_data_subject_request_verdict(indeterminate([verification_of_overriding_grounds_pending]), none, none, [], [])).
test(a_type_outside_this_order_is_not_decided_here) :-
    decide_data_subject_request([attribute(request_type, erasure)], gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [])).

cp_test_names([the_baseline_profile_yields_exactly_one_status, the_baseline_profile_yields_exactly_one_verdict, the_verdict_carries_a_citation, manifestly_unfounded_relief_carries_the_fee_condition, unable_to_identify_relief, legislative_restriction_relief, identity_suspension_is_a_non_final_status, identity_unconfirmed_and_unknown_names_the_missing_key, unsure_judgement_is_handed_to_the_user, rectification_inaccurate_basis, rectification_incomplete_basis, rectification_not_engaged_cites_the_article_alone, restriction_point_a, restriction_point_b, restriction_point_d, restriction_not_engaged, restriction_verification_unknown, a_type_outside_this_order_is_not_decided_here]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
