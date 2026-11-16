% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_joint_controllers_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_gdpr_joint_controllers, [decide_gdpr_joint_controllers/2, gdpr_joint_controllers_status/2, gdpr_joint_controllers_checklist/2, rights_against_each_joint_controller/3, liability_for_the_entire_damage/4, recourse_after_full_compensation/4]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_fixtures, [gdpr_joint_controllers_profile_for/2]).

fixture_statement(Subject, Attested) :-
    gdpr_joint_controllers_profile_for(Subject, Profile),
    member(attribute(responsible_under_article_82_2_and_3, Attested), Profile).

rights_answers(Subject, Answers) :-
    gdpr_joint_controllers_profile_for(Subject, Profile),
    findall(Result - Citations, rights_against_each_joint_controller(Profile, Result, Citations), Answers).

liability_answers(Subject, Answers) :-
    gdpr_joint_controllers_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, liability_for_the_entire_damage(Profile, Result, Basis, Citations), Answers).

recourse_answers(Subject, Answers) :-
    gdpr_joint_controllers_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, recourse_after_full_compensation(Profile, Result, Basis, Citations), Answers).

absent_referral(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_4), cite(responsibility_under_article_82_statement)), [resolution(cite(responsibility_under_article_82_statement), not_attempted), inputs_relied_on([responsible_under_article_82_2_and_3 - absent])])).

test(entitled_rights) :-
    rights_answers(joint_processor_entitled_to_claim_back, Answers),
    Answers == [rights_exercisable_against_this_controller - [cite(eu_reg_2016_679_art_26_3), cite(eu_reg_2016_679_art_28_10)]].
test(entitled_liability) :-
    fixture_statement(joint_processor_entitled_to_claim_back, Attested),
    liability_answers(joint_processor_entitled_to_claim_back, Answers),
    Answers == [liable_for_the_entire_damage - [outside_fact(responsible_under_article_82_2_and_3, Attested)] - [cite(eu_reg_2016_679_art_82_4)]].
test(entitled_recourse) :-
    fixture_statement(joint_processor_entitled_to_claim_back, Attested),
    recourse_answers(joint_processor_entitled_to_claim_back, Answers),
    Answers == [entitled_to_claim_back([controller_b, processor_c]) - [outside_fact(responsible_under_article_82_2_and_3, Attested)] - [cite(eu_reg_2016_679_art_82_5)]].
test(partial_payment_recourse) :-
    recourse_answers(partial_payment_near_miss, Answers),
    Answers == [not_entitled_to_claim_back - [] - [cite(eu_reg_2016_679_art_82_5)]].
test(sole_party_liability) :-
    fixture_statement(sole_responsible_party_near_miss, Attested),
    liability_answers(sole_responsible_party_near_miss, Answers),
    Answers == [no_other_responsible_party - [outside_fact(responsible_under_article_82_2_and_3, Attested)] - [cite(eu_reg_2016_679_art_82_4)]].
test(sole_party_recourse) :-
    recourse_answers(sole_responsible_party_near_miss, Answers),
    Answers == [not_entitled_to_claim_back - [] - [cite(eu_reg_2016_679_art_82_5)]].
test(not_responsible_liability) :-
    fixture_statement(not_responsible_near_miss, Attested),
    liability_answers(not_responsible_near_miss, Answers),
    Answers == [not_responsible_for_the_damage - [outside_fact(responsible_under_article_82_2_and_3, Attested)] - [cite(eu_reg_2016_679_art_82_4)]].
test(not_responsible_recourse) :-
    fixture_statement(not_responsible_near_miss, Attested),
    recourse_answers(not_responsible_near_miss, Answers),
    Answers == [not_entitled_to_claim_back - [outside_fact(responsible_under_article_82_2_and_3, Attested)] - [cite(eu_reg_2016_679_art_82_5)]].
test(unsure_rights) :-
    rights_answers(payment_judgement_unsure, Answers),
    Answers == [needs_legal_review(open_textured(controllers_jointly_determine_purposes_and_means, cite(eu_reg_2016_679_art_26_3)), [inputs_relied_on([controllers_jointly_determine_purposes_and_means - unsure])]) - []].
test(unsure_recourse) :-
    recourse_answers(payment_judgement_unsure, Answers),
    Answers == [needs_legal_review(open_textured(full_compensation_paid, cite(eu_reg_2016_679_art_82_5)), [inputs_relied_on([full_compensation_paid - unsure])]) - [] - []].
test(not_yet_stated_rights) :-
    rights_answers(payment_not_yet_stated, Answers),
    Answers == [not_joint_controllers - [cite(eu_reg_2016_679_art_26_3)]].
test(not_yet_stated_recourse) :-
    recourse_answers(payment_not_yet_stated, Answers),
    Answers == [indeterminate([full_compensation_paid]) - [] - []].
test(parties_unknown_rights) :-
    rights_answers(other_parties_not_yet_known, Answers),
    Answers == [indeterminate([controllers_jointly_determine_purposes_and_means]) - []].
test(parties_unknown_liability) :-
    liability_answers(other_parties_not_yet_known, Answers),
    Answers == [indeterminate([other_responsible_parties]) - [] - []].
test(parties_unknown_recourse) :-
    recourse_answers(other_parties_not_yet_known, Answers),
    Answers == [indeterminate([other_responsible_parties]) - [] - []].
test(statement_absent_liability) :-
    absent_referral(Referral),
    liability_answers(statement_absent_referred, Answers),
    Answers == [Referral - [] - []].
test(statement_absent_recourse) :-
    absent_referral(Referral),
    recourse_answers(statement_absent_referred, Answers),
    Answers == [Referral - [] - []].
test(statement_absent_alone_liability) :-
    absent_referral(Referral),
    liability_answers(statement_absent_no_other_party, Answers),
    Answers == [Referral - [] - []].
test(statement_absent_alone_recourse) :-
    recourse_answers(statement_absent_no_other_party, Answers),
    Answers == [not_entitled_to_claim_back - [] - [cite(eu_reg_2016_679_art_82_5)]].
test(bare_statement_every_query) :-
    rights_answers(malformed_bare_statement, RightsAnswers),
    liability_answers(malformed_bare_statement, LiabilityAnswers),
    recourse_answers(malformed_bare_statement, RecourseAnswers),
    RightsAnswers == [input_problems([wrong_type(responsible_under_article_82_2_and_3)]) - []],
    LiabilityAnswers == [input_problems([wrong_type(responsible_under_article_82_2_and_3)]) - [] - []],
    RecourseAnswers == [input_problems([wrong_type(responsible_under_article_82_2_and_3)]) - [] - []].
test(party_identifier_problem) :-
    recourse_answers(malformed_party_identifier, Answers),
    Answers == [input_problems([wrong_type(other_responsible_parties)]) - [] - []].
test(duplicate_payment_problem) :-
    liability_answers(malformed_duplicate_payment, Answers),
    Answers == [input_problems([duplicate_key(full_compensation_paid), unknown_key(arrangement_names_contact_point)]) - [] - []].
test(facade_verdict_carries_the_citation) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    findall(Verdict, decide_gdpr_joint_controllers(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_joint_controllers_verdict(eligible, [cite(eu_reg_2016_679_art_82_5)])].
test(facade_referred_verdict_has_no_citation) :-
    gdpr_joint_controllers_profile_for(statement_absent_referred, Profile),
    findall(Verdict, decide_gdpr_joint_controllers(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_joint_controllers_verdict(referred_for_legal_review, [])].
test(facade_status_enumerates_one) :-
    gdpr_joint_controllers_profile_for(sole_responsible_party_near_miss, Profile),
    findall(Status, gdpr_joint_controllers_status(Profile, Status), Statuses),
    Statuses == [ineligible].
test(checklist_all_met_for_entitled) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    gdpr_joint_controllers_checklist(Profile, Items),
    length(Items, 3),
    member(item(caller_responsible_for_the_damage, met, cite(eu_reg_2016_679_art_82_4)), Items),
    member(item(other_responsible_party_listed, met, cite(eu_reg_2016_679_art_82_4)), Items),
    member(item(full_compensation_paid, met, cite(eu_reg_2016_679_art_82_5)), Items).
test(checklist_partial_payment_unmet) :-
    gdpr_joint_controllers_profile_for(partial_payment_near_miss, Profile),
    gdpr_joint_controllers_checklist(Profile, Items),
    member(item(full_compensation_paid, unmet(full_compensation_not_paid), cite(eu_reg_2016_679_art_82_5)), Items).
test(checklist_malformed_single_row) :-
    gdpr_joint_controllers_profile_for(malformed_bare_statement, Profile),
    findall(Items, gdpr_joint_controllers_checklist(Profile, Items), Checklists),
    Checklists == [[item(input_check, unmet(input_problems([wrong_type(responsible_under_article_82_2_and_3)])), cite(eu_reg_2016_679_art_82_5))]].

cp_test_names([entitled_rights, entitled_liability, entitled_recourse, partial_payment_recourse, sole_party_liability, sole_party_recourse, not_responsible_liability, not_responsible_recourse, unsure_rights, unsure_recourse, not_yet_stated_rights, not_yet_stated_recourse, parties_unknown_rights, parties_unknown_liability, parties_unknown_recourse, statement_absent_liability, statement_absent_recourse, statement_absent_alone_liability, statement_absent_alone_recourse, bare_statement_every_query, party_identifier_problem, duplicate_payment_problem, facade_verdict_carries_the_citation, facade_referred_verdict_has_no_citation, facade_status_enumerates_one, checklist_all_met_for_entitled, checklist_partial_payment_unmet, checklist_malformed_single_row]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
