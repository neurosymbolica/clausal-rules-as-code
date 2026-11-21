% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_kernel, [gdpr_chapter_v_extras_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_gdpr_chapter_v_extras, [second_subparagraph_duty/5, foreign_judgment_or_decision_recognition/4, onward_transfer_condition/4, gdpr_chapter_v_extras_status/2]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_fixtures, [gdpr_chapter_v_extras_profile_for/2]).

test(bound_duty_met_with_basis_and_citations) :-
    gdpr_chapter_v_extras_profile_for(supervisory_authority_informed, Profile),
    second_subparagraph_duty(Profile, inform_supervisory_authority, duty_met, [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none)))], [cite(eu_reg_2016_679_art_49_1_second_subpara)]).
test(bound_processor_answer) :-
    gdpr_chapter_v_extras_profile_for(processor_asks_about_informing, Profile),
    second_subparagraph_duty(Profile, inform_data_subject, not_a_processor_duty, [], [cite(eu_reg_2016_679_art_49_1_second_subpara)]).
test(bound_documentation_duty_met_for_a_processor) :-
    gdpr_chapter_v_extras_profile_for(records_complete_for_processor, Profile),
    second_subparagraph_duty(Profile, document_assessment_and_safeguards, duty_met, [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none)))], [cite(eu_reg_2016_679_art_49_6)]).
test(bound_no_second_subparagraph_transfer) :-
    gdpr_chapter_v_extras_profile_for(transfer_not_under_second_subparagraph, Profile),
    second_subparagraph_duty(Profile, inform_supervisory_authority, no_second_subparagraph_transfer, [outside_fact(transfer_relies_on_article_49_1_second_subparagraph, attested(false, attestation(by, at, reason, none)))], [cite(eu_reg_2016_679_art_49_1_second_subpara)]).
test(bound_indeterminate_names_one_key) :-
    gdpr_chapter_v_extras_profile_for(records_safeguards_unstated, Profile),
    second_subparagraph_duty(Profile, document_assessment_and_safeguards, indeterminate([suitable_safeguards_documented_in_records]), [], []).
test(bound_article_48_not_barred) :-
    gdpr_chapter_v_extras_profile_for(judgment_with_international_agreement, Profile),
    foreign_judgment_or_decision_recognition(Profile, not_barred_by_article_48, [outside_fact(third_country_judgment_or_decision_requires_transfer, attested(true, attestation(by, at, reason, none))), outside_fact(international_agreement_basis_for_judgment_or_decision, attested(true, attestation(by, at, reason, none)))], [cite(eu_reg_2016_679_art_48)]).
test(bound_onward_referral) :-
    gdpr_chapter_v_extras_profile_for(onward_transfer_basis_unstated, Profile),
    onward_transfer_condition(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_44), cite(onward_transfer_chapter_v_basis_statement)), [resolution(cite(onward_transfer_chapter_v_basis_statement), not_attempted), inputs_relied_on([onward_transfer_has_chapter_v_basis - absent])]), [], []).
test(bound_status_on_the_baseline) :-
    gdpr_chapter_v_extras_profile_for(todo_baseline_subject, Profile),
    gdpr_chapter_v_extras_status(Profile, onward_transfer_may_take_place).
test(bound_input_check_well_formed_profile) :-
    gdpr_chapter_v_extras_input_problems([attribute(transfer_relies_on_article_49_1_second_subparagraph, attested(true, attestation(by, at, reason, none))), attribute(party_role, controller), attribute(supervisory_authority_informed_of_transfer, true)], []).
test(input_check_read_out_for_a_ground_profile) :-
    gdpr_chapter_v_extras_input_problems([attribute(party_role, recipient), attribute(colour, blue)], Problems),
    Problems == [wrong_type(party_role), unknown_key(colour)].
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems(_UnboundProfile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_not_an_attribute_list) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(party_role, controller)|_Rest], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_pair_element_is_not_an_attribute) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(party_role, controller), party_role - controller], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_value_is_wrong_type) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(party_role, _UnboundValue)], Problems), Answers),
    Answers == [[wrong_type(party_role)]].
test(a_number_key_is_an_unknown_key) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(42, true)], Problems), Answers),
    Answers == [[unknown_key(42)]].
test(an_unbound_key_is_an_unknown_key_as_given) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(_UnboundKey, true)], Problems), Answers),
    Answers = [[unknown_key(ReportedKey)]],
    var(ReportedKey).
test(an_unbound_evidence_is_wrong_type) :-
    findall(Result, onward_transfer_condition([attribute(transfer_is_onward_transfer, attested(true, attestation(by, at, reason, _UnboundEvidence)))], Result, _, _), Results),
    Results == [input_problems([wrong_type(transfer_is_onward_transfer)])].
test(a_three_argument_attestation_is_wrong_type) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(transfer_is_onward_transfer, attested(true, attestation(by, at, none)))], Problems), Answers),
    Answers == [[wrong_type(transfer_is_onward_transfer)]].
test(an_attested_crisp_key_is_wrong_type) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(supervisory_authority_informed_of_transfer, attested(true, attestation(by, at, reason, none)))], Problems), Answers),
    Answers == [[wrong_type(supervisory_authority_informed_of_transfer)]].
test(document_evidence_is_accepted) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(transfer_is_onward_transfer, attested(true, attestation(by, at, reason, document(upload, digest))))], Problems), Answers),
    Answers == [[]].
test(duplicate_key_reads_no_value) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(party_role, controller), attribute(party_role, banana)], Problems), Answers),
    Answers == [[duplicate_key(party_role)]].
test(problems_follow_contract_order_then_unknown_keys) :-
    findall(Problems, gdpr_chapter_v_extras_input_problems([attribute(extra_key, 1), attribute(onward_transfer_has_chapter_v_basis, true), attribute(party_role, banana), attribute(extra_key, 2)], Problems), Answers),
    Answers == [[wrong_type(party_role), wrong_type(onward_transfer_has_chapter_v_basis), unknown_key(extra_key)]].
test(an_unbound_duty_is_wrong_type) :-
    findall(Result - Basis - Citations, second_subparagraph_duty([], _UnboundDuty, Result, Basis, Citations), Answers),
    Answers == [input_problems([wrong_type(duty)]) - [] - []].
test(a_bad_profile_and_a_bad_duty_are_both_named) :-
    findall(Result, second_subparagraph_duty(not_a_list, inform_everyone, Result, _, _), Results),
    Results == [input_problems([wrong_type(profile), wrong_type(duty)])].

test(bound_duty_not_met_is_rejected_for_a_met_duty, fail) :-
    gdpr_chapter_v_extras_profile_for(supervisory_authority_informed, Profile),
    second_subparagraph_duty(Profile, inform_supervisory_authority, duty_not_met, _, _).
test(bound_article_48_not_barred_is_rejected_without_agreement, fail) :-
    gdpr_chapter_v_extras_profile_for(judgment_without_international_agreement, Profile),
    foreign_judgment_or_decision_recognition(Profile, not_barred_by_article_48, _, _).
test(bound_other_status_is_rejected_on_the_baseline, fail) :-
    gdpr_chapter_v_extras_profile_for(todo_baseline_subject, Profile),
    gdpr_chapter_v_extras_status(Profile, onward_transfer_may_not_take_place).

cp_test_names([bound_duty_met_with_basis_and_citations, bound_processor_answer, bound_documentation_duty_met_for_a_processor, bound_no_second_subparagraph_transfer, bound_indeterminate_names_one_key, bound_article_48_not_barred, bound_onward_referral, bound_status_on_the_baseline, bound_input_check_well_formed_profile, input_check_read_out_for_a_ground_profile, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, a_pair_element_is_not_an_attribute, an_unbound_value_is_wrong_type, a_number_key_is_an_unknown_key, an_unbound_key_is_an_unknown_key_as_given, an_unbound_evidence_is_wrong_type, a_three_argument_attestation_is_wrong_type, an_attested_crisp_key_is_wrong_type, document_evidence_is_accepted, duplicate_key_reads_no_value, problems_follow_contract_order_then_unknown_keys, an_unbound_duty_is_wrong_type, a_bad_profile_and_a_bad_duty_are_both_named]).
cp_test_fail_names([bound_duty_not_met_is_rejected_for_a_met_duty, bound_article_48_not_barred_is_rejected_without_agreement, bound_other_status_is_rejected_on_the_baseline]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
