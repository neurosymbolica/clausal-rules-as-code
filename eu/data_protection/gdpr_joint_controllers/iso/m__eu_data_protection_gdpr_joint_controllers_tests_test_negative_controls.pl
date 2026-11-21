% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_joint_controllers_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_gdpr_joint_controllers, [gdpr_joint_controllers_status/2, gdpr_joint_controllers_status_values/1, rights_against_each_joint_controller/3, liability_for_the_entire_damage/4, recourse_after_full_compensation/4]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_fixtures, [gdpr_joint_controllers_profile_for/2]).

stated(Value, attested(Value, attestation(host_service, attested_moment, stated_reason, none))).

test(the_status_table_has_a_near_miss_atom) :-
    gdpr_joint_controllers_status_values(StatusValues),
    StatusValues = [_, _|_].
test(the_status_table_names_the_three_verdicts) :-
    gdpr_joint_controllers_status_values([eligible, ineligible, indeterminate]).
test(a4_positive_joint_controller_reached) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, true)], rights_exercisable_against_this_controller, _).
test(a1_positive_non_joint_controller_not_reached) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, false)], not_joint_controllers, _).
test(a3_positive_unsure_goes_to_a_lawyer) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, unsure)], needs_legal_review(open_textured(controllers_jointly_determine_purposes_and_means, cite(eu_reg_2016_679_art_26_3)), _), []).
test(a2_positive_absent_judgement_asked_for) :-
    rights_against_each_joint_controller([], indeterminate([controllers_jointly_determine_purposes_and_means]), []).
test(b5_positive_another_responsible_party) :-
    stated(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_alpha])], liable_for_the_entire_damage, _, _).
test(b4_positive_no_other_responsible_party) :-
    stated(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [])], no_other_responsible_party, _, _).
test(b1_positive_not_responsible_with_others) :-
    stated(false, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_alpha])], not_responsible_for_the_damage, _, _).
test(b2_positive_absent_statement_referred) :-
    liability_for_the_entire_damage([], needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_4), cite(responsibility_under_article_82_statement)), _), [], []).
test(b3_positive_list_named_once_responsible) :-
    stated(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested)], indeterminate([other_responsible_parties]), [], []).
test(c8_positive_full_payment_gives_a_claim_back) :-
    gdpr_joint_controllers_profile_for(claim_back_after_full_payment, Profile),
    recourse_after_full_compensation(Profile, entitled_to_claim_back([processor_beta, controller_alpha]), _, _).
test(c3_positive_partial_payment_gives_none) :-
    gdpr_joint_controllers_profile_for(claim_back_after_partial_payment, Profile),
    recourse_after_full_compensation(Profile, not_entitled_to_claim_back, [], [cite(eu_reg_2016_679_art_82_5)]).
test(c2_positive_sole_responsible_party_gives_none) :-
    gdpr_joint_controllers_profile_for(sole_responsible_party, Profile),
    recourse_after_full_compensation(Profile, not_entitled_to_claim_back, [], _).
test(c1_positive_party_not_responsible_gives_none) :-
    gdpr_joint_controllers_profile_for(party_not_responsible, Profile),
    recourse_after_full_compensation(Profile, not_entitled_to_claim_back, [outside_fact(responsible_under_article_82_2_and_3, attested(false, _))], _).
test(c4_positive_absent_statement_referred) :-
    gdpr_joint_controllers_profile_for(responsibility_statement_absent, Profile),
    recourse_after_full_compensation(Profile, needs_legal_review(cross_reference_unresolved(_, _), _), [], []).
test(c5_positive_parties_not_stated_asked_for) :-
    gdpr_joint_controllers_profile_for(other_parties_not_stated, Profile),
    recourse_after_full_compensation(Profile, indeterminate([other_responsible_parties]), [], []).
test(c6_positive_payment_not_stated_asked_for) :-
    gdpr_joint_controllers_profile_for(claim_back_payment_not_stated, Profile),
    recourse_after_full_compensation(Profile, indeterminate([full_compensation_paid]), [], []).
test(c7_positive_unsure_payment_goes_to_a_lawyer) :-
    gdpr_joint_controllers_profile_for(claim_back_payment_unsure, Profile),
    recourse_after_full_compensation(Profile, needs_legal_review(open_textured(full_compensation_paid, cite(eu_reg_2016_679_art_82_5)), _), [], []).
test(step_zero_positive_arrangement_key_is_refused) :-
    gdpr_joint_controllers_profile_for(arrangement_key_supplied, Profile),
    rights_against_each_joint_controller(Profile, input_problems([unknown_key(arrangement_terms)]), []).
test(step_zero_positive_duplicate_key_is_indeterminate) :-
    gdpr_joint_controllers_profile_for(duplicate_payment_key, Profile),
    gdpr_joint_controllers_status(Profile, indeterminate).

test(a1_near_miss_non_joint_controller_gets_no_rights_answer, fail) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, false)], rights_exercisable_against_this_controller, _).
test(a3_near_miss_unsure_is_not_decided_positive, fail) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, unsure)], rights_exercisable_against_this_controller, _).
test(a3_near_miss_unsure_is_not_decided_negative, fail) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, unsure)], not_joint_controllers, _).
test(a2_near_miss_absent_judgement_not_referred, fail) :-
    rights_against_each_joint_controller([], needs_legal_review(_, _), _).
test(b4_near_miss_alone_is_not_liable_for_the_entire_damage, fail) :-
    stated(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [])], liable_for_the_entire_damage, _, _).
test(b1_near_miss_not_responsible_is_not_liable_for_the_entire_damage, fail) :-
    stated(false, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_alpha])], liable_for_the_entire_damage, _, _).
test(b2_near_miss_absent_statement_does_not_name_the_list, fail) :-
    liability_for_the_entire_damage([], indeterminate(_), _, _).
test(b3_near_miss_responsible_without_list_is_not_alone, fail) :-
    stated(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested)], no_other_responsible_party, _, _).
test(c3_near_miss_partial_payment_gives_no_claim_back, fail) :-
    gdpr_joint_controllers_profile_for(claim_back_after_partial_payment, Profile),
    recourse_after_full_compensation(Profile, entitled_to_claim_back(_), _, _).
test(c2_near_miss_sole_responsible_party_gives_no_claim_back, fail) :-
    gdpr_joint_controllers_profile_for(sole_responsible_party, Profile),
    recourse_after_full_compensation(Profile, entitled_to_claim_back(_), _, _).
test(c1_near_miss_party_not_responsible_gives_no_claim_back, fail) :-
    gdpr_joint_controllers_profile_for(party_not_responsible, Profile),
    recourse_after_full_compensation(Profile, entitled_to_claim_back(_), _, _).
test(c4_near_miss_absent_statement_gives_no_claim_back, fail) :-
    gdpr_joint_controllers_profile_for(responsibility_statement_absent, Profile),
    recourse_after_full_compensation(Profile, entitled_to_claim_back(_), _, _).
test(c5_near_miss_parties_not_stated_gives_no_claim_back, fail) :-
    gdpr_joint_controllers_profile_for(other_parties_not_stated, Profile),
    recourse_after_full_compensation(Profile, entitled_to_claim_back(_), _, _).
test(c6_near_miss_payment_not_stated_gives_no_claim_back, fail) :-
    gdpr_joint_controllers_profile_for(claim_back_payment_not_stated, Profile),
    recourse_after_full_compensation(Profile, entitled_to_claim_back(_), _, _).
test(c7_near_miss_unsure_payment_is_not_refused, fail) :-
    gdpr_joint_controllers_profile_for(claim_back_payment_unsure, Profile),
    recourse_after_full_compensation(Profile, not_entitled_to_claim_back, _, _).
test(step_zero_near_miss_arrangement_key_gets_no_rights_answer, fail) :-
    gdpr_joint_controllers_profile_for(arrangement_key_supplied, Profile),
    rights_against_each_joint_controller(Profile, rights_exercisable_against_this_controller, _).
test(step_zero_near_miss_duplicate_key_is_not_eligible, fail) :-
    gdpr_joint_controllers_profile_for(duplicate_payment_key, Profile),
    gdpr_joint_controllers_status(Profile, eligible).

cp_test_names([the_status_table_has_a_near_miss_atom, the_status_table_names_the_three_verdicts, a4_positive_joint_controller_reached, a1_positive_non_joint_controller_not_reached, a3_positive_unsure_goes_to_a_lawyer, a2_positive_absent_judgement_asked_for, b5_positive_another_responsible_party, b4_positive_no_other_responsible_party, b1_positive_not_responsible_with_others, b2_positive_absent_statement_referred, b3_positive_list_named_once_responsible, c8_positive_full_payment_gives_a_claim_back, c3_positive_partial_payment_gives_none, c2_positive_sole_responsible_party_gives_none, c1_positive_party_not_responsible_gives_none, c4_positive_absent_statement_referred, c5_positive_parties_not_stated_asked_for, c6_positive_payment_not_stated_asked_for, c7_positive_unsure_payment_goes_to_a_lawyer, step_zero_positive_arrangement_key_is_refused, step_zero_positive_duplicate_key_is_indeterminate]).
cp_test_fail_names([a1_near_miss_non_joint_controller_gets_no_rights_answer, a3_near_miss_unsure_is_not_decided_positive, a3_near_miss_unsure_is_not_decided_negative, a2_near_miss_absent_judgement_not_referred, b4_near_miss_alone_is_not_liable_for_the_entire_damage, b1_near_miss_not_responsible_is_not_liable_for_the_entire_damage, b2_near_miss_absent_statement_does_not_name_the_list, b3_near_miss_responsible_without_list_is_not_alone, c3_near_miss_partial_payment_gives_no_claim_back, c2_near_miss_sole_responsible_party_gives_no_claim_back, c1_near_miss_party_not_responsible_gives_no_claim_back, c4_near_miss_absent_statement_gives_no_claim_back, c5_near_miss_parties_not_stated_gives_no_claim_back, c6_near_miss_payment_not_stated_gives_no_claim_back, c7_near_miss_unsure_payment_is_not_refused, step_zero_near_miss_arrangement_key_gets_no_rights_answer, step_zero_near_miss_duplicate_key_is_not_eligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
