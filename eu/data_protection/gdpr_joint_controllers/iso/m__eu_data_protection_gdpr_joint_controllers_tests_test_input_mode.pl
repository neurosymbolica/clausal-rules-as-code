% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_joint_controllers_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_gdpr_joint_controllers, [gdpr_joint_controllers_status/2, rights_against_each_joint_controller/3, liability_for_the_entire_damage/4, recourse_after_full_compensation/4]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_kernel, [gdpr_joint_controllers_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_joint_controllers_fixtures, [gdpr_joint_controllers_profile_for/2]).

stated(Value, attested(Value, attestation(host_service, attested_moment, stated_reason, none))).

test(eligible_holds_bound_for_a_full_payment) :-
    gdpr_joint_controllers_profile_for(claim_back_after_full_payment, Profile),
    gdpr_joint_controllers_status(Profile, eligible).
test(ineligible_holds_bound_for_a_partial_payment) :-
    gdpr_joint_controllers_profile_for(claim_back_after_partial_payment, Profile),
    gdpr_joint_controllers_status(Profile, ineligible).
test(indeterminate_holds_bound_for_an_unsure_payment) :-
    gdpr_joint_controllers_profile_for(claim_back_payment_unsure, Profile),
    gdpr_joint_controllers_status(Profile, indeterminate).
test(indeterminate_holds_bound_for_an_absent_statement) :-
    gdpr_joint_controllers_profile_for(responsibility_statement_absent, Profile),
    gdpr_joint_controllers_status(Profile, indeterminate).
test(indeterminate_holds_bound_for_a_duplicate_key) :-
    gdpr_joint_controllers_profile_for(duplicate_payment_key, Profile),
    gdpr_joint_controllers_status(Profile, indeterminate).
test(rights_exercisable_holds_bound) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, true)], rights_exercisable_against_this_controller, [cite(eu_reg_2016_679_art_26_3), cite(eu_reg_2016_679_art_28_10)]).
test(liable_for_the_entire_damage_holds_bound) :-
    stated(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_alpha])], liable_for_the_entire_damage, [outside_fact(responsible_under_article_82_2_and_3, Attested)], [cite(eu_reg_2016_679_art_82_4)]).
test(entitled_to_claim_back_holds_bound_with_the_parties_as_given) :-
    stated(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [processor_beta, controller_alpha]), attribute(full_compensation_paid, true)], entitled_to_claim_back([processor_beta, controller_alpha]), [outside_fact(responsible_under_article_82_2_and_3, Attested)], [cite(eu_reg_2016_679_art_82_5)]).
test(a_well_formed_profile_has_no_problem) :-
    stated(true, Attested),
    gdpr_joint_controllers_input_problems([attribute(controllers_jointly_determine_purposes_and_means, unsure), attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, []), attribute(full_compensation_paid, false)], []).
test(the_empty_profile_has_no_problem) :-
    gdpr_joint_controllers_input_problems([], []).
test(a_stray_element_makes_the_profile_not_an_attribute_list) :-
    gdpr_joint_controllers_input_problems([attribute(full_compensation_paid, true), stray_element], Problems),
    Problems == [wrong_type(profile)].
test(a_non_list_profile_is_not_an_attribute_list) :-
    gdpr_joint_controllers_input_problems(not_a_profile, [wrong_type(profile)]).
test(a_compound_key_is_an_unknown_key_as_given) :-
    gdpr_joint_controllers_input_problems([attribute(key_of(stray), true)], Problems),
    Problems == [unknown_key(key_of(stray))].
test(a_number_key_is_an_unknown_key) :-
    gdpr_joint_controllers_input_problems([attribute(42, true)], [unknown_key(42)]).
test(a_judgement_given_an_attested_term_is_a_wrong_type) :-
    stated(true, Attested),
    gdpr_joint_controllers_input_problems([attribute(controllers_jointly_determine_purposes_and_means, Attested)], [wrong_type(controllers_jointly_determine_purposes_and_means)]).
test(a_bare_true_outside_fact_is_a_wrong_type) :-
    gdpr_joint_controllers_input_problems([attribute(responsible_under_article_82_2_and_3, true)], [wrong_type(responsible_under_article_82_2_and_3)]).
test(an_attested_unsure_is_a_wrong_type) :-
    gdpr_joint_controllers_input_problems([attribute(responsible_under_article_82_2_and_3, attested(unsure, attestation(host_service, attested_moment, stated_reason, none)))], [wrong_type(responsible_under_article_82_2_and_3)]).
test(an_attestation_with_three_arguments_is_a_wrong_type) :-
    gdpr_joint_controllers_input_problems([attribute(responsible_under_article_82_2_and_3, attested(true, attestation(host_service, attested_moment, none)))], [wrong_type(responsible_under_article_82_2_and_3)]).
test(document_evidence_is_well_formed) :-
    gdpr_joint_controllers_input_problems([attribute(responsible_under_article_82_2_and_3, attested(false, attestation(host_service, attested_moment, stated_reason, document(upload_identifier, content_hash))))], []).
test(a_number_in_the_parties_list_is_a_wrong_type) :-
    gdpr_joint_controllers_input_problems([attribute(other_responsible_parties, [controller_alpha, 7])], [wrong_type(other_responsible_parties)]).
test(a_compound_in_the_parties_list_is_a_wrong_type) :-
    gdpr_joint_controllers_input_problems([attribute(other_responsible_parties, [controller(alpha)])], [wrong_type(other_responsible_parties)]).
test(an_empty_list_in_the_parties_list_is_a_wrong_type) :-
    gdpr_joint_controllers_input_problems([attribute(other_responsible_parties, [[]])], [wrong_type(other_responsible_parties)]).
test(a_bare_atom_parties_value_is_a_wrong_type) :-
    gdpr_joint_controllers_input_problems([attribute(other_responsible_parties, controller_alpha)], [wrong_type(other_responsible_parties)]).
test(a_repeated_party_is_not_a_problem) :-
    gdpr_joint_controllers_input_problems([attribute(other_responsible_parties, [controller_alpha, controller_alpha])], []).
test(a_duplicate_key_is_named_once_whatever_its_values) :-
    gdpr_joint_controllers_input_problems([attribute(full_compensation_paid, true), attribute(full_compensation_paid, banana), attribute(full_compensation_paid, true)], [duplicate_key(full_compensation_paid)]).
test(problems_follow_the_contract_order_then_unknown_keys) :-
    gdpr_joint_controllers_input_problems([attribute(stray_key, true), attribute(full_compensation_paid, maybe), attribute(controllers_jointly_determine_purposes_and_means, yes), attribute(stray_key, false)], Problems),
    Problems == [wrong_type(controllers_jointly_determine_purposes_and_means), wrong_type(full_compensation_paid), unknown_key(stray_key)].
test(the_input_check_yields_exactly_one_solution_for_an_unbound_profile) :-
    findall(Problems, gdpr_joint_controllers_input_problems(_Profile, Problems), Answers),
    length(Answers, 1).
test(a_malformed_profile_gives_input_problems_in_every_query) :-
    rights_against_each_joint_controller(not_a_profile, input_problems([wrong_type(profile)]), []),
    liability_for_the_entire_damage(not_a_profile, input_problems([wrong_type(profile)]), [], []),
    recourse_after_full_compensation(not_a_profile, input_problems([wrong_type(profile)]), [], []).

test(ineligible_is_rejected_bound_for_a_full_payment, fail) :-
    gdpr_joint_controllers_profile_for(claim_back_after_full_payment, Profile),
    gdpr_joint_controllers_status(Profile, ineligible).
test(indeterminate_is_rejected_bound_for_a_full_payment, fail) :-
    gdpr_joint_controllers_profile_for(claim_back_after_full_payment, Profile),
    gdpr_joint_controllers_status(Profile, indeterminate).
test(eligible_is_rejected_bound_for_a_partial_payment, fail) :-
    gdpr_joint_controllers_profile_for(claim_back_after_partial_payment, Profile),
    gdpr_joint_controllers_status(Profile, eligible).
test(not_joint_controllers_is_rejected_bound_for_a_joint_controller, fail) :-
    rights_against_each_joint_controller([attribute(controllers_jointly_determine_purposes_and_means, true)], not_joint_controllers, _).
test(no_other_responsible_party_is_rejected_bound_with_another_party, fail) :-
    stated(true, Attested),
    liability_for_the_entire_damage([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [controller_alpha])], no_other_responsible_party, _, _).
test(entitled_to_claim_back_is_rejected_bound_with_reordered_parties, fail) :-
    stated(true, Attested),
    recourse_after_full_compensation([attribute(responsible_under_article_82_2_and_3, Attested), attribute(other_responsible_parties, [processor_beta, controller_alpha]), attribute(full_compensation_paid, true)], entitled_to_claim_back([controller_alpha, processor_beta]), _, _).

cp_test_names([eligible_holds_bound_for_a_full_payment, ineligible_holds_bound_for_a_partial_payment, indeterminate_holds_bound_for_an_unsure_payment, indeterminate_holds_bound_for_an_absent_statement, indeterminate_holds_bound_for_a_duplicate_key, rights_exercisable_holds_bound, liable_for_the_entire_damage_holds_bound, entitled_to_claim_back_holds_bound_with_the_parties_as_given, a_well_formed_profile_has_no_problem, the_empty_profile_has_no_problem, a_stray_element_makes_the_profile_not_an_attribute_list, a_non_list_profile_is_not_an_attribute_list, a_compound_key_is_an_unknown_key_as_given, a_number_key_is_an_unknown_key, a_judgement_given_an_attested_term_is_a_wrong_type, a_bare_true_outside_fact_is_a_wrong_type, an_attested_unsure_is_a_wrong_type, an_attestation_with_three_arguments_is_a_wrong_type, document_evidence_is_well_formed, a_number_in_the_parties_list_is_a_wrong_type, a_compound_in_the_parties_list_is_a_wrong_type, an_empty_list_in_the_parties_list_is_a_wrong_type, a_bare_atom_parties_value_is_a_wrong_type, a_repeated_party_is_not_a_problem, a_duplicate_key_is_named_once_whatever_its_values, problems_follow_the_contract_order_then_unknown_keys, the_input_check_yields_exactly_one_solution_for_an_unbound_profile, a_malformed_profile_gives_input_problems_in_every_query]).
cp_test_fail_names([ineligible_is_rejected_bound_for_a_full_payment, indeterminate_is_rejected_bound_for_a_full_payment, eligible_is_rejected_bound_for_a_partial_payment, not_joint_controllers_is_rejected_bound_for_a_joint_controller, no_other_responsible_party_is_rejected_bound_with_another_party, entitled_to_claim_back_is_rejected_bound_with_reordered_parties]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
