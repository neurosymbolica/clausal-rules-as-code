% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_request_basis, [decide_request_basis/2, request_basis_status/2, decide_data_subject_request/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_automated_decision_fixtures, [gdpr_data_subject_rights_automated_decision_profile_for/2]).

verdict_of(Subject, Verdict) :-
    gdpr_data_subject_rights_automated_decision_profile_for(Subject, Profile),
    decide_data_subject_request(Profile, Verdict).

sole_verdict(Subject, Expected) :-
    findall(Verdict, verdict_of(Subject, Verdict), Verdicts),
    Verdicts == [Expected].

test(the_baseline_profile_yields_exactly_one_status) :-
    gdpr_data_subject_rights_automated_decision_profile_for(baseline_must_comply, Profile),
    findall(Status, request_basis_status(Profile, Status), Statuses),
    Statuses == [art22_1].
test(the_verdict_carries_a_citation) :-
    gdpr_data_subject_rights_automated_decision_profile_for(baseline_must_comply, Profile),
    decide_request_basis(Profile, request_basis_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(must_comply_baseline) :-
    sole_verdict(baseline_must_comply, gdpr_data_subject_request_verdict(must_comply, art22_1, none, [], [cite(eu_reg_2016_679_art_22_1)])).
test(not_engaged) :-
    sole_verdict(not_solely_automated, gdpr_data_subject_request_verdict(need_not_comply, none, none, [], [cite(eu_reg_2016_679_art_22_1)])).
test(contract_exception) :-
    sole_verdict(contract_exception, gdpr_data_subject_request_verdict(need_not_comply, art22_1, art22_2_a, [human_intervention, express_point_of_view, contest_decision], [cite(eu_reg_2016_679_art_22_1), cite(eu_reg_2016_679_art_22_2), cite(eu_reg_2016_679_art_22_2_a), cite(eu_reg_2016_679_art_22_3)])).
test(law_authorised_exception) :-
    sole_verdict(law_authorised_exception, gdpr_data_subject_request_verdict(need_not_comply, art22_1, art22_2_b, [], [cite(eu_reg_2016_679_art_22_1), cite(eu_reg_2016_679_art_22_2), cite(eu_reg_2016_679_art_22_2_b)])).
test(explicit_consent_exception) :-
    sole_verdict(explicit_consent_exception, gdpr_data_subject_request_verdict(need_not_comply, art22_1, art22_2_c, [human_intervention, express_point_of_view, contest_decision], [cite(eu_reg_2016_679_art_22_1), cite(eu_reg_2016_679_art_22_2), cite(eu_reg_2016_679_art_22_2_c), cite(eu_reg_2016_679_art_22_3)])).
test(manifestly_excessive_exception) :-
    sole_verdict(manifestly_excessive_fee, gdpr_data_subject_request_verdict(need_not_comply, art22_1, art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged], [cite(eu_reg_2016_679_art_12_5), cite(eu_reg_2016_679_art_22_1)])).
test(unable_to_identify_exception) :-
    sole_verdict(unable_to_identify, gdpr_data_subject_request_verdict(need_not_comply, art22_1, art12_2_unable_to_identify, [], [cite(eu_reg_2016_679_art_12_2), cite(eu_reg_2016_679_art_22_1)])).
test(legislative_restriction_exception) :-
    sole_verdict(legislative_restriction, gdpr_data_subject_request_verdict(need_not_comply, art22_1, art23_legislative_restriction, [], [cite(eu_reg_2016_679_art_22_1), cite(eu_reg_2016_679_art_23_1)])).
test(suspended_status) :-
    sole_verdict(identity_suspended, gdpr_data_subject_request_verdict(suspended(art12_6_identity_not_confirmed), none, none, [], [])).
test(missing_identity_confirmation_is_indeterminate) :-
    sole_verdict(identity_confirmation_missing, gdpr_data_subject_request_verdict(indeterminate([identity_confirmed]), none, none, [], [])).
test(solely_unsure_is_referred) :-
    sole_verdict(solely_unsure_referral, gdpr_data_subject_request_verdict(needs_legal_review(open_textured(decision_based_solely_on_automated_processing, cite(eu_reg_2016_679_art_22_1)), [inputs_relied_on([request_type - automated_decision, decision_based_solely_on_automated_processing - unsure, decision_produces_legal_or_similarly_significant_effects - true])]), none, none, [], [])).
test(manifestly_unsure_is_referred) :-
    sole_verdict(manifestly_unsure_referral, gdpr_data_subject_request_verdict(needs_legal_review(open_textured(request_manifestly_unfounded_or_excessive, cite(eu_reg_2016_679_art_12_5)), [inputs_relied_on([request_type - automated_decision, request_manifestly_unfounded_or_excessive - unsure])]), none, none, [], [])).
test(missing_judgement_is_indeterminate) :-
    sole_verdict(solely_missing_indeterminate, gdpr_data_subject_request_verdict(indeterminate([decision_based_solely_on_automated_processing]), none, none, [], [])).
test(input_problems_unknown_key) :-
    sole_verdict(unknown_key_input_problem, gdpr_data_subject_request_verdict(input_problems([unknown_key(bogus_key)]), none, none, [], [])).
test(input_problems_wrong_type) :-
    sole_verdict(wrong_type_input_problem, gdpr_data_subject_request_verdict(input_problems([wrong_type(decision_based_solely_on_automated_processing)]), none, none, [], [])).

cp_test_names([the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, must_comply_baseline, not_engaged, contract_exception, law_authorised_exception, explicit_consent_exception, manifestly_excessive_exception, unable_to_identify_exception, legislative_restriction_exception, suspended_status, missing_identity_confirmation_is_indeterminate, solely_unsure_is_referred, manifestly_unsure_is_referred, missing_judgement_is_indeterminate, input_problems_unknown_key, input_problems_wrong_type]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
