% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_gdpr_chapter_v_extras, [second_subparagraph_duty/5, foreign_judgment_or_decision_recognition/4, onward_transfer_condition/4, decide_gdpr_chapter_v_extras/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_fixtures, [gdpr_chapter_v_extras_subject/1, gdpr_chapter_v_extras_profile_for/2, gdpr_chapter_v_extras_assess/2]).

fixture_attested(Value, attested(Value, attestation(host_user, host_timestamp, fixture_statement, none))).

expected_status(controller_all_duties_met, no_condition_breached).
expected_status(controller_data_subject_not_told_interests, condition_breached).
expected_status(controller_supervisory_authority_not_informed, condition_breached).
expected_status(controller_safeguards_not_documented, condition_breached).
expected_status(processor_documentation_met, no_condition_breached).
expected_status(processor_documentation_pending, more_input_needed).
expected_status(no_second_subparagraph_transfer_stated, no_condition_breached).
expected_status(second_subparagraph_unstated, more_input_needed).
expected_status(party_role_unstated, more_input_needed).
expected_status(foreign_judgment_with_agreement, no_condition_breached).
expected_status(foreign_judgment_without_agreement, condition_breached).
expected_status(foreign_judgment_agreement_unstated, more_input_needed).
expected_status(onward_transfer_with_basis, no_condition_breached).
expected_status(onward_transfer_without_basis, condition_breached).
expected_status(onward_transfer_basis_unstated, more_input_needed).
expected_status(malformed_bare_boolean_outside_fact, input_problems([wrong_type(transfer_is_onward_transfer)])).

subject_status(Subject, Status) :-
    gdpr_chapter_v_extras_subject(Subject),
    gdpr_chapter_v_extras_assess(Subject, gdpr_chapter_v_extras_verdict(Status, _)).

test(every_subject_reads_out_its_expected_status) :-
    findall(Subject - Status, subject_status(Subject, Status), Actual),
    findall(Subject - Status, expected_status(Subject, Status), Expected),
    Actual == Expected.
test(the_verdict_carries_every_citation_once) :-
    gdpr_chapter_v_extras_profile_for(controller_all_duties_met, Profile),
    findall(Verdict, decide_gdpr_chapter_v_extras(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_chapter_v_extras_verdict(no_condition_breached, [cite(eu_reg_2016_679_art_44), cite(eu_reg_2016_679_art_48), cite(eu_reg_2016_679_art_49_1_second_subpara), cite(eu_reg_2016_679_art_49_6)])].
test(a_met_duty_reads_out_whole) :-
    gdpr_chapter_v_extras_profile_for(controller_all_duties_met, Profile),
    fixture_attested(true, TransferStatement),
    findall(Result - Basis - Citations, second_subparagraph_duty(Profile, inform_data_subject, Result, Basis, Citations), Answers),
    Answers == [duty_met - [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, TransferStatement)] - [cite(eu_reg_2016_679_art_49_1_second_subpara)]].
test(the_first_absent_documentation_key_reads_out) :-
    gdpr_chapter_v_extras_profile_for(processor_documentation_pending, Profile),
    findall(Result - Basis - Citations, second_subparagraph_duty(Profile, document_assessment_and_safeguards, Result, Basis, Citations), Answers),
    Answers == [indeterminate([suitable_safeguards_documented_in_records]) - [] - []].
test(party_role_reads_out_as_missing) :-
    gdpr_chapter_v_extras_profile_for(party_role_unstated, Profile),
    findall(Result - Basis - Citations, second_subparagraph_duty(Profile, inform_supervisory_authority, Result, Basis, Citations), Answers),
    Answers == [indeterminate([party_role]) - [] - []].
test(the_documentation_duty_does_not_wait_for_party_role) :-
    gdpr_chapter_v_extras_profile_for(party_role_unstated, Profile),
    findall(Result, second_subparagraph_duty(Profile, document_assessment_and_safeguards, Result, _, _), Answers),
    Answers == [duty_met].
test(no_second_subparagraph_transfer_reads_out_whole) :-
    gdpr_chapter_v_extras_profile_for(no_second_subparagraph_transfer_stated, Profile),
    fixture_attested(false, TransferStatement),
    findall(Result - Basis - Citations, second_subparagraph_duty(Profile, document_assessment_and_safeguards, Result, Basis, Citations), Answers),
    Answers == [no_second_subparagraph_transfer - [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, TransferStatement)] - [cite(eu_reg_2016_679_art_49_6)]].
test(the_second_subparagraph_referral_reads_out_whole) :-
    gdpr_chapter_v_extras_profile_for(second_subparagraph_unstated, Profile),
    findall(Result - Basis - Citations, second_subparagraph_duty(Profile, inform_data_subject, Result, Basis, Citations), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_49_1_second_subpara), cite(second_subparagraph_transfer_statement)), [resolution(cite(second_subparagraph_transfer_statement), not_attempted), inputs_relied_on([transfer_relies_on_article_49_1_second_subparagraph - absent])]) - [] - []].
test(the_judgment_referral_reads_out_whole) :-
    findall(Result - Basis - Citations, foreign_judgment_or_decision_recognition([], Result, Basis, Citations), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_48), cite(foreign_judgment_requires_transfer_statement)), [resolution(cite(foreign_judgment_requires_transfer_statement), not_attempted), inputs_relied_on([third_country_judgment_or_decision_requires_transfer - absent])]) - [] - []].
test(the_agreement_referral_reads_out_whole) :-
    gdpr_chapter_v_extras_profile_for(foreign_judgment_agreement_unstated, Profile),
    findall(Result - Basis - Citations, foreign_judgment_or_decision_recognition(Profile, Result, Basis, Citations), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_48), cite(international_agreement_basis_statement)), [resolution(cite(international_agreement_basis_statement), not_attempted), inputs_relied_on([international_agreement_basis_for_judgment_or_decision - absent])]) - [] - []].
test(not_barred_reads_out_with_both_facts) :-
    gdpr_chapter_v_extras_profile_for(foreign_judgment_with_agreement, Profile),
    fixture_attested(true, Statement),
    findall(Result - Basis - Citations, foreign_judgment_or_decision_recognition(Profile, Result, Basis, Citations), Answers),
    Answers == [not_barred_by_article_48 - [outside_fact(third_country_judgment_or_decision_requires_transfer, Statement), outside_fact(international_agreement_basis_for_judgment_or_decision, Statement)] - [cite(eu_reg_2016_679_art_48)]].
test(the_onward_statement_referral_reads_out_whole) :-
    findall(Result - Basis - Citations, onward_transfer_condition([], Result, Basis, Citations), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_44), cite(onward_transfer_statement)), [resolution(cite(onward_transfer_statement), not_attempted), inputs_relied_on([transfer_is_onward_transfer - absent])]) - [] - []].
test(the_onward_basis_referral_reads_out_whole) :-
    gdpr_chapter_v_extras_profile_for(onward_transfer_basis_unstated, Profile),
    findall(Result - Basis - Citations, onward_transfer_condition(Profile, Result, Basis, Citations), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_44), cite(onward_transfer_chapter_v_basis_statement)), [resolution(cite(onward_transfer_chapter_v_basis_statement), not_attempted), inputs_relied_on([onward_transfer_has_chapter_v_basis - absent])]) - [] - []].
test(not_an_onward_transfer_reads_out_whole) :-
    gdpr_chapter_v_extras_profile_for(controller_all_duties_met, Profile),
    fixture_attested(false, Statement),
    findall(Result - Basis - Citations, onward_transfer_condition(Profile, Result, Basis, Citations), Answers),
    Answers == [not_an_onward_transfer - [outside_fact(transfer_is_onward_transfer, Statement)] - [cite(eu_reg_2016_679_art_44)]].

cp_test_names([every_subject_reads_out_its_expected_status, the_verdict_carries_every_citation_once, a_met_duty_reads_out_whole, the_first_absent_documentation_key_reads_out, party_role_reads_out_as_missing, the_documentation_duty_does_not_wait_for_party_role, no_second_subparagraph_transfer_reads_out_whole, the_second_subparagraph_referral_reads_out_whole, the_judgment_referral_reads_out_whole, the_agreement_referral_reads_out_whole, not_barred_reads_out_with_both_facts, the_onward_statement_referral_reads_out_whole, the_onward_basis_referral_reads_out_whole, not_an_onward_transfer_reads_out_whole]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
