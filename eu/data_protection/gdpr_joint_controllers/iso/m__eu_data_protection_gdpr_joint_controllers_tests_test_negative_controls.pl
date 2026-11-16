% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_joint_controllers_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_gdpr_joint_controllers, [gdpr_joint_controllers_status/2, gdpr_joint_controllers_status_values/1, rights_against_each_joint_controller/3, liability_for_the_entire_damage/4, recourse_after_full_compensation/4]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_fixtures, [gdpr_joint_controllers_profile_for/2]).

attested_statement(Truth, attested(Truth, attestation(registry_host, moment, stated_reason, none))).

absent_referral(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_4), cite(responsibility_under_article_82_statement)), [resolution(cite(responsibility_under_article_82_statement), not_attempted), inputs_relied_on([responsible_under_article_82_2_and_3 - absent])])).

test(status_table_spells_every_status) :-
    gdpr_joint_controllers_status_values(StatusValues),
    member(eligible, StatusValues),
    member(ineligible, StatusValues),
    member(unresolved, StatusValues),
    member(referred_for_legal_review, StatusValues),
    member(malformed_input, StatusValues).
test(a1_joint_false_is_not_joint_controllers) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, false)], not_joint_controllers, [cite(eu_reg_2016_679_art_26_3)]).
test(a4_joint_true_is_exercisable) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, true)], rights_exercisable_against_this_controller, [cite(eu_reg_2016_679_art_26_3), cite(eu_reg_2016_679_art_28_10)]).
test(a2_joint_absent_is_asked_for) :-
    rights_against_each_joint_controller([], indeterminate([controllers_jointly_determine_purposes_and_means]), []).
test(a3_joint_unsure_goes_to_a_lawyer) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, unsure)], needs_legal_review(open_textured(controllers_jointly_determine_purposes_and_means, cite(eu_reg_2016_679_art_26_3)), [inputs_relied_on([controllers_jointly_determine_purposes_and_means - unsure])]), []).
test(b1_stated_false_is_not_responsible) :-
    attested_statement(false, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b])], not_responsible_for_the_damage, [outside_fact(responsible_under_article_82_2_and_3, Attested)], [cite(eu_reg_2016_679_art_82_4)]).
test(b1_near_miss_stated_true_is_liable) :-
    attested_statement(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b])], liable_for_the_entire_damage, _, _).
test(b2_statement_absent_is_referred_before_the_list) :-
    absent_referral(Referral),
    liability_for_the_entire_damage([attribute(other_responsible_parties, [])], Referral, [], []).
test(b2_statement_absent_with_list_absent_is_referred) :-
    absent_referral(Referral),
    liability_for_the_entire_damage([], Referral, [], []).
test(b3_parties_absent_are_asked_for) :-
    attested_statement(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested)], indeterminate([other_responsible_parties]), [], []).
test(b4_alone_is_no_other_responsible_party) :-
    attested_statement(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [])], no_other_responsible_party, [outside_fact(responsible_under_article_82_2_and_3, Attested)], [cite(eu_reg_2016_679_art_82_4)]).
test(b5_another_party_is_the_entire_damage) :-
    attested_statement(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b])], liable_for_the_entire_damage, [outside_fact(responsible_under_article_82_2_and_3, Attested)], [cite(eu_reg_2016_679_art_82_4)]).
test(c1_stated_false_is_not_entitled) :-
    attested_statement(false, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, unsure)], not_entitled_to_claim_back, [outside_fact(responsible_under_article_82_2_and_3, Attested)], [cite(eu_reg_2016_679_art_82_5)]).
test(c1_near_miss_stated_true_goes_to_a_lawyer) :-
    attested_statement(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, unsure)], needs_legal_review(open_textured(full_compensation_paid, cite(eu_reg_2016_679_art_82_5)), _), [], []).
test(c2_empty_list_is_not_entitled_whatever_the_statement) :-
    recourse_after_full_compensation([attribute(other_responsible_parties, []), attribute(full_compensation_paid, unsure)], not_entitled_to_claim_back, [], [cite(eu_reg_2016_679_art_82_5)]).
test(c2_near_miss_listed_party_is_referred) :-
    absent_referral(Referral),
    recourse_after_full_compensation([attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, unsure)], Referral, [], []).
test(c3_payment_false_is_not_entitled_whatever_else) :-
    recourse_after_full_compensation([attribute(full_compensation_paid, false)], not_entitled_to_claim_back, [], [cite(eu_reg_2016_679_art_82_5)]).
test(c3_near_miss_payment_true_is_referred) :-
    absent_referral(Referral),
    recourse_after_full_compensation([attribute(full_compensation_paid, true)], Referral, [], []).
test(c4_statement_absent_is_referred) :-
    absent_referral(Referral),
    recourse_after_full_compensation([attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, true)], Referral, [], []).
test(c4_near_miss_statement_true_is_entitled) :-
    attested_statement(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, true)], entitled_to_claim_back([controller_b]), [outside_fact(responsible_under_article_82_2_and_3, Attested)], [cite(eu_reg_2016_679_art_82_5)]).
test(c5_parties_named_before_unsure_payment) :-
    attested_statement(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(full_compensation_paid, unsure)], indeterminate([other_responsible_parties]), [], []).
test(c6_payment_absent_is_asked_for) :-
    attested_statement(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b])], indeterminate([full_compensation_paid]), [], []).
test(c7_payment_unsure_goes_to_a_lawyer) :-
    attested_statement(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, unsure)], needs_legal_review(open_textured(full_compensation_paid, cite(eu_reg_2016_679_art_82_5)), [inputs_relied_on([full_compensation_paid - unsure])]), [], []).
test(c7_near_miss_payment_false_is_not_entitled) :-
    attested_statement(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, false)], not_entitled_to_claim_back, [], [cite(eu_reg_2016_679_art_82_5)]).
test(c8_entitled_fixture) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    recourse_after_full_compensation(Profile, entitled_to_claim_back([controller_b, processor_c]), _, _).
test(step0_bare_statement_is_an_input_problem) :-
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, true), attribute(other_responsible_parties, [controller_b])], input_problems([wrong_type(responsible_under_article_82_2_and_3)]), [], []).
test(facade_entitled_is_eligible) :-
    gdpr_joint_controllers_profile_for(joint_processor_entitled_to_claim_back, Profile),
    gdpr_joint_controllers_status(Profile, eligible).
test(facade_partial_payment_is_ineligible) :-
    gdpr_joint_controllers_profile_for(partial_payment_near_miss, Profile),
    gdpr_joint_controllers_status(Profile, ineligible).
test(facade_statement_absent_no_other_party_is_ineligible) :-
    gdpr_joint_controllers_profile_for(statement_absent_no_other_party, Profile),
    gdpr_joint_controllers_status(Profile, ineligible).

test(a1_near_miss_joint_true_is_not_not_joint_controllers, fail) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, true)], not_joint_controllers, _).
test(a4_near_miss_joint_false_is_not_exercisable, fail) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, false)], rights_exercisable_against_this_controller, _).
test(a2_near_miss_joint_unsure_is_not_asked_for, fail) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, unsure)], indeterminate(_), _).
test(a3_near_miss_joint_absent_is_not_referred, fail) :-
    rights_against_each_joint_controller([], needs_legal_review(_, _), _).
test(b1_near_miss_stated_true_is_not_not_responsible, fail) :-
    attested_statement(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b])], not_responsible_for_the_damage, _, _).
test(b2_near_miss_statement_absent_is_not_alone, fail) :-
    liability_for_the_entire_damage([attribute(other_responsible_parties, [])], no_other_responsible_party, _, _).
test(b2_near_miss_statement_absent_list_absent_is_not_asked_for, fail) :-
    liability_for_the_entire_damage([], indeterminate(_), _, _).
test(b3_near_miss_list_given_is_not_asked_for, fail) :-
    attested_statement(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [])], indeterminate(_), _, _).
test(b4_near_miss_another_party_is_not_alone, fail) :-
    attested_statement(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b])], no_other_responsible_party, _, _).
test(b5_near_miss_alone_is_not_the_entire_damage, fail) :-
    attested_statement(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [])], liable_for_the_entire_damage, _, _).
test(c1_near_miss_stated_true_is_not_not_entitled, fail) :-
    attested_statement(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, unsure)], not_entitled_to_claim_back, _, _).
test(c2_near_miss_listed_party_is_not_not_entitled, fail) :-
    recourse_after_full_compensation([attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, unsure)], not_entitled_to_claim_back, _, _).
test(c3_near_miss_payment_true_is_not_not_entitled, fail) :-
    recourse_after_full_compensation([attribute(full_compensation_paid, true)], not_entitled_to_claim_back, _, _).
test(c4_near_miss_statement_true_is_not_referred, fail) :-
    attested_statement(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, true)], needs_legal_review(_, _), _, _).
test(c5_near_miss_parties_given_is_not_asked_for, fail) :-
    attested_statement(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, unsure)], indeterminate(_), _, _).
test(c6_near_miss_payment_true_is_not_asked_for, fail) :-
    attested_statement(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, true)], indeterminate(_), _, _).
test(c7_near_miss_payment_false_is_not_referred, fail) :-
    attested_statement(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b]), attribute(full_compensation_paid, false)], needs_legal_review(_, _), _, _).
test(c8_near_miss_partial_payment_is_not_entitled, fail) :-
    gdpr_joint_controllers_profile_for(partial_payment_near_miss, Profile),
    recourse_after_full_compensation(Profile, entitled_to_claim_back(_), _, _).
test(c8_near_miss_sole_party_is_not_entitled, fail) :-
    gdpr_joint_controllers_profile_for(sole_responsible_party_near_miss, Profile),
    recourse_after_full_compensation(Profile, entitled_to_claim_back(_), _, _).
test(c8_near_miss_not_responsible_is_not_entitled, fail) :-
    gdpr_joint_controllers_profile_for(not_responsible_near_miss, Profile),
    recourse_after_full_compensation(Profile, entitled_to_claim_back(_), _, _).
test(step0_near_miss_attested_statement_is_no_input_problem, fail) :-
    attested_statement(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_b])], input_problems(_), _, _).
test(facade_partial_payment_is_not_eligible, fail) :-
    gdpr_joint_controllers_profile_for(partial_payment_near_miss, Profile),
    gdpr_joint_controllers_status(Profile, eligible).
test(facade_statement_absent_referred_is_not_ineligible, fail) :-
    gdpr_joint_controllers_profile_for(statement_absent_referred, Profile),
    gdpr_joint_controllers_status(Profile, ineligible).

cp_test_names([status_table_spells_every_status, a1_joint_false_is_not_joint_controllers, a4_joint_true_is_exercisable, a2_joint_absent_is_asked_for, a3_joint_unsure_goes_to_a_lawyer, b1_stated_false_is_not_responsible, b1_near_miss_stated_true_is_liable, b2_statement_absent_is_referred_before_the_list, b2_statement_absent_with_list_absent_is_referred, b3_parties_absent_are_asked_for, b4_alone_is_no_other_responsible_party, b5_another_party_is_the_entire_damage, c1_stated_false_is_not_entitled, c1_near_miss_stated_true_goes_to_a_lawyer, c2_empty_list_is_not_entitled_whatever_the_statement, c2_near_miss_listed_party_is_referred, c3_payment_false_is_not_entitled_whatever_else, c3_near_miss_payment_true_is_referred, c4_statement_absent_is_referred, c4_near_miss_statement_true_is_entitled, c5_parties_named_before_unsure_payment, c6_payment_absent_is_asked_for, c7_payment_unsure_goes_to_a_lawyer, c7_near_miss_payment_false_is_not_entitled, c8_entitled_fixture, step0_bare_statement_is_an_input_problem, facade_entitled_is_eligible, facade_partial_payment_is_ineligible, facade_statement_absent_no_other_party_is_ineligible]).
cp_test_fail_names([a1_near_miss_joint_true_is_not_not_joint_controllers, a4_near_miss_joint_false_is_not_exercisable, a2_near_miss_joint_unsure_is_not_asked_for, a3_near_miss_joint_absent_is_not_referred, b1_near_miss_stated_true_is_not_not_responsible, b2_near_miss_statement_absent_is_not_alone, b2_near_miss_statement_absent_list_absent_is_not_asked_for, b3_near_miss_list_given_is_not_asked_for, b4_near_miss_another_party_is_not_alone, b5_near_miss_alone_is_not_the_entire_damage, c1_near_miss_stated_true_is_not_not_entitled, c2_near_miss_listed_party_is_not_not_entitled, c3_near_miss_payment_true_is_not_not_entitled, c4_near_miss_statement_true_is_not_referred, c5_near_miss_parties_given_is_not_asked_for, c6_near_miss_payment_true_is_not_asked_for, c7_near_miss_payment_false_is_not_referred, c8_near_miss_partial_payment_is_not_entitled, c8_near_miss_sole_party_is_not_entitled, c8_near_miss_not_responsible_is_not_entitled, step0_near_miss_attested_statement_is_no_input_problem, facade_partial_payment_is_not_eligible, facade_statement_absent_referred_is_not_ineligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
