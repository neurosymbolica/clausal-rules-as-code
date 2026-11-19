% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_notice_consent_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_notice_consent_dpdp_notice_consent, [consent_ground/3, legitimate_use_ground/3, consent_notice/3, withdrawal_effect/3, consent_manager_status/3, provision_lists/2, decide_dpdp_notice_consent/2, dpdp_notice_consent_checklist/2]).
:- use_module(m__ind_dpdp_notice_consent_fixtures, [dpdp_notice_consent_profile_for/2]).

consent_answers(Subject, Answers) :-
    dpdp_notice_consent_profile_for(Subject, Profile),
    findall(Result - Citations, consent_ground(Profile, Result, Citations), Answers).

legitimate_answers(Subject, Answers) :-
    dpdp_notice_consent_profile_for(Subject, Profile),
    findall(Result - Citations, legitimate_use_ground(Profile, Result, Citations), Answers).

notice_answers(Subject, Answers) :-
    dpdp_notice_consent_profile_for(Subject, Profile),
    findall(Result - Citations, consent_notice(Profile, Result, Citations), Answers).

withdrawal_answers(Subject, Answers) :-
    dpdp_notice_consent_profile_for(Subject, Profile),
    findall(Result - Citations, withdrawal_effect(Profile, Result, Citations), Answers).

manager_answers(Subject, Answers) :-
    dpdp_notice_consent_profile_for(Subject, Profile),
    findall(Result - Citations, consent_manager_status(Profile, Result, Citations), Answers).

test(consent_lawful_reads_out_once) :-
    consent_answers(consent_lawful, Answers),
    Answers == [lawful_on_consent - [cite(in_dpdp_act_2023_s_4_1), cite(in_dpdp_act_2023_s_4_1_a), cite(in_dpdp_act_2023_s_6_1)]].
test(consent_withdrawn_reads_out_not_lawful) :-
    consent_answers(consent_withdrawn, Answers),
    Answers == [not_lawful_on_consent - [cite(in_dpdp_act_2023_s_4_1), cite(in_dpdp_act_2023_s_4_1_a), cite(in_dpdp_act_2023_s_4_2), cite(in_dpdp_act_2023_s_6_1), cite(in_dpdp_act_2023_s_6_4)]].
test(consent_sections_not_in_force_reads_out) :-
    consent_answers(consent_sections_not_in_force, Answers),
    Answers == [not_in_force - [cite(in_dpdp_act_2023_s_4_1)]].
test(consent_in_force_absent_reads_out) :-
    consent_answers(consent_in_force_absent, Answers),
    Answers == [indeterminate([sections_4_to_7_in_force]) - []].
test(consent_withdrawal_absent_reads_out) :-
    consent_answers(consent_withdrawal_absent, Answers),
    Answers == [indeterminate([consent_withdrawn]) - []].
test(consent_purpose_unsure_reads_out) :-
    consent_answers(consent_purpose_unsure, Answers),
    Answers == [needs_legal_review(open_textured(lawful_purpose, cite(in_dpdp_act_2023_s_4_2)), [inputs_relied_on([lawful_purpose - unsure, consent_meets_section_6_1 - true])]) - []].
test(consent_section_6_1_unsure_reads_out) :-
    consent_answers(consent_section_6_1_unsure, Answers),
    Answers == [needs_legal_review(open_textured(consent_meets_section_6_1, cite(in_dpdp_act_2023_s_6_1)), [inputs_relied_on([lawful_purpose - true, consent_meets_section_6_1 - unsure])]) - []].
test(consent_duplicate_key_reads_out) :-
    consent_answers(consent_duplicate_key, Answers),
    Answers == [input_problems([duplicate_key(consent_given)]) - []].
test(consent_unknown_key_reads_out) :-
    consent_answers(consent_unknown_key, Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(legitimate_use_employment_cites_clause_i) :-
    legitimate_answers(legitimate_use_employment, Answers),
    Answers == [lawful_on_legitimate_use - [cite(in_dpdp_act_2023_s_4_1_b), cite(in_dpdp_act_2023_s_7), cite(in_dpdp_act_2023_s_7_i)]].
test(legitimate_use_conditions_unmet_cites_section_7_whole) :-
    legitimate_answers(legitimate_use_conditions_unmet, Answers),
    Answers == [not_lawful_on_legitimate_use - [cite(in_dpdp_act_2023_s_4_1), cite(in_dpdp_act_2023_s_4_1_b), cite(in_dpdp_act_2023_s_4_2), cite(in_dpdp_act_2023_s_7)]].
test(legitimate_use_conditions_unsure_reads_out) :-
    legitimate_answers(legitimate_use_conditions_unsure, Answers),
    Answers == [needs_legal_review(open_textured(legitimate_use_conditions_met, cite(in_dpdp_act_2023_s_7)), [inputs_relied_on([lawful_purpose - true, legitimate_use_conditions_met - unsure])]) - []].
test(notice_request_the_day_before_rule_3) :-
    notice_answers(notice_request_before_rule_3, Answers),
    Answers == [notice_with_request_required_before_rule_3 - [cite(in_dpdp_act_2023_s_5_1), cite(in_dpdp_act_2023_s_5_3), cite(in_dpdp_rules_2025_r_1_4)]].
test(notice_request_on_the_rule_3_day) :-
    notice_answers(notice_request_on_rule_3_day, Answers),
    Answers == [notice_with_request_required - [cite(in_dpdp_act_2023_s_5_1), cite(in_dpdp_act_2023_s_5_3), cite(in_dpdp_rules_2025_r_3)]].
test(notice_earlier_consent_the_day_before_rule_3) :-
    notice_answers(notice_earlier_consent_before_rule_3, Answers),
    Answers == [notice_for_earlier_consent_required_before_rule_3 - [cite(in_dpdp_act_2023_s_5_2), cite(in_dpdp_act_2023_s_5_2_a), cite(in_dpdp_act_2023_s_5_3), cite(in_dpdp_rules_2025_r_1_4)]].
test(notice_earlier_consent_on_the_rule_3_day) :-
    notice_answers(notice_earlier_consent_on_rule_3_day, Answers),
    Answers == [notice_for_earlier_consent_required - [cite(in_dpdp_act_2023_s_5_2), cite(in_dpdp_act_2023_s_5_2_a), cite(in_dpdp_act_2023_s_5_3), cite(in_dpdp_rules_2025_r_3)]].
test(notice_processor_reads_out_not_required) :-
    notice_answers(notice_processor, Answers),
    Answers == [not_required - [cite(in_dpdp_act_2023_s_2_i), cite(in_dpdp_act_2023_s_5_1), cite(in_dpdp_act_2023_s_5_2_a)]].
test(notice_fiduciary_unsure_reads_out) :-
    notice_answers(notice_fiduciary_unsure, Answers),
    Answers == [needs_legal_review(open_textured(acts_as_data_fiduciary, cite(in_dpdp_act_2023_s_2_i)), [inputs_relied_on([acts_as_data_fiduciary - unsure])]) - []].
test(notice_on_a_consent_profile_names_the_fiduciary_key) :-
    notice_answers(consent_lawful, Answers),
    Answers == [indeterminate([acts_as_data_fiduciary]) - []].
test(withdrawal_cease_reads_out) :-
    withdrawal_answers(withdrawal_cease, Answers),
    Answers == [cease_processing_required - [cite(in_dpdp_act_2023_s_6_4), cite(in_dpdp_act_2023_s_6_5), cite(in_dpdp_act_2023_s_6_6)]].
test(withdrawal_may_continue_reads_out) :-
    withdrawal_answers(withdrawal_may_continue, Answers),
    Answers == [processing_may_continue_without_consent - [cite(in_dpdp_act_2023_s_6_6)]].
test(withdrawal_not_withdrawn_reads_out) :-
    withdrawal_answers(withdrawal_not_withdrawn, Answers),
    Answers == [not_required - [cite(in_dpdp_act_2023_s_2_i), cite(in_dpdp_act_2023_s_6_4), cite(in_dpdp_act_2023_s_6_6)]].
test(withdrawal_law_unsure_reads_out) :-
    withdrawal_answers(withdrawal_law_unsure, Answers),
    Answers == [needs_legal_review(open_textured(processing_required_or_authorised_by_law, cite(in_dpdp_act_2023_s_6_6)), [inputs_relied_on([acts_as_data_fiduciary - true, processing_required_or_authorised_by_law - unsure])]) - []].
test(manager_registered_reads_out) :-
    manager_answers(manager_registered, Answers),
    Answers == [may_act_as_consent_manager - [cite(in_dpdp_act_2023_s_2_g), cite(in_dpdp_act_2023_s_6_7), cite(in_dpdp_act_2023_s_6_8), cite(in_dpdp_act_2023_s_6_9), cite(in_dpdp_rules_2025_r_4_2_a), cite(in_dpdp_rules_2025_r_4_3)]].
test(manager_unregistered_reads_out) :-
    manager_answers(manager_unregistered, Answers),
    Answers == [may_not_act_as_consent_manager - [cite(in_dpdp_act_2023_s_2_g), cite(in_dpdp_act_2023_s_6_9), cite(in_dpdp_rules_2025_r_4_5_a)]].
test(manager_section_not_in_force_reads_out) :-
    manager_answers(manager_section_not_in_force, Answers),
    Answers == [not_in_force - [cite(in_dpdp_act_2023_s_6_9)]].
test(manager_on_a_consent_profile_names_its_own_in_force_key) :-
    manager_answers(consent_lawful, Answers),
    Answers == [indeterminate([section_6_9_in_force]) - []].
test(provision_lists_enumerates_the_eight_topics_in_order) :-
    findall(Topic, provision_lists(Topic, _), Topics),
    Topics == [notice_with_request, notice_for_earlier_consent, rule_3_notice, consent_request, legitimate_uses, state_use_standards, consent_manager_conditions, consent_manager_obligations].
test(provision_lists_lengths) :-
    findall(Topic - Length, (provision_lists(Topic, ItemList), length(ItemList, Length)), Lengths),
    Lengths == [notice_with_request - 4, notice_for_earlier_consent - 4, rule_3_notice - 7, consent_request - 3, legitimate_uses - 9, state_use_standards - 11, consent_manager_conditions - 10, consent_manager_obligations - 22].
test(notice_with_request_list_reads_out_whole) :-
    findall(ItemList, provision_lists(notice_with_request, ItemList), Answers),
    Answers == [[content_item(personal_data_and_proposed_purpose, cite(in_dpdp_act_2023_s_5_1_i)), content_item(manner_to_withdraw_consent_and_seek_grievance_redressal, cite(in_dpdp_act_2023_s_5_1_ii)), content_item(manner_to_complain_to_board, cite(in_dpdp_act_2023_s_5_1_iii)), content_item(option_of_english_or_eighth_schedule_language, cite(in_dpdp_act_2023_s_5_3))]].
test(consent_request_list_reads_out_whole) :-
    provision_lists(consent_request, ItemList),
    ItemList == [content_item(request_in_clear_and_plain_language, cite(in_dpdp_act_2023_s_6_3)), content_item(option_of_english_or_eighth_schedule_language, cite(in_dpdp_act_2023_s_6_3)), content_item(contact_of_data_protection_officer_or_authorised_person, cite(in_dpdp_act_2023_s_6_3))].
test(the_shared_safeguard_atom_carries_each_list_citation) :-
    provision_lists(state_use_standards, StandardItems),
    provision_lists(consent_manager_obligations, ObligationItems),
    member(content_item(reasonable_security_safeguards, cite(in_dpdp_rules_2025_sch_2_f)), StandardItems),
    member(content_item(reasonable_security_safeguards, cite(in_dpdp_rules_2025_sch_1_partb_7)), ObligationItems).
test(the_verdict_reads_out_with_its_citations) :-
    dpdp_notice_consent_profile_for(consent_lawful, Profile),
    findall(Verdict, decide_dpdp_notice_consent(Profile, Verdict), Verdicts),
    Verdicts == [dpdp_notice_consent_verdict(eligible, [cite(in_dpdp_act_2023_s_4_1), cite(in_dpdp_act_2023_s_4_1_a), cite(in_dpdp_act_2023_s_6_1)])].
test(the_checklist_marks_the_withdrawal_unmet) :-
    dpdp_notice_consent_profile_for(consent_withdrawn, Profile),
    dpdp_notice_consent_checklist(Profile, Items),
    member(item(consent_not_withdrawn, unmet(consent_withdrawn), cite(in_dpdp_act_2023_s_6_4)), Items).
test(the_checklist_marks_an_unsure_judgement_unknown) :-
    dpdp_notice_consent_profile_for(consent_purpose_unsure, Profile),
    dpdp_notice_consent_checklist(Profile, Items),
    member(item(lawful_purpose, unknown([lawful_purpose]), cite(in_dpdp_act_2023_s_4_2)), Items).

cp_test_names([consent_lawful_reads_out_once, consent_withdrawn_reads_out_not_lawful, consent_sections_not_in_force_reads_out, consent_in_force_absent_reads_out, consent_withdrawal_absent_reads_out, consent_purpose_unsure_reads_out, consent_section_6_1_unsure_reads_out, consent_duplicate_key_reads_out, consent_unknown_key_reads_out, legitimate_use_employment_cites_clause_i, legitimate_use_conditions_unmet_cites_section_7_whole, legitimate_use_conditions_unsure_reads_out, notice_request_the_day_before_rule_3, notice_request_on_the_rule_3_day, notice_earlier_consent_the_day_before_rule_3, notice_earlier_consent_on_the_rule_3_day, notice_processor_reads_out_not_required, notice_fiduciary_unsure_reads_out, notice_on_a_consent_profile_names_the_fiduciary_key, withdrawal_cease_reads_out, withdrawal_may_continue_reads_out, withdrawal_not_withdrawn_reads_out, withdrawal_law_unsure_reads_out, manager_registered_reads_out, manager_unregistered_reads_out, manager_section_not_in_force_reads_out, manager_on_a_consent_profile_names_its_own_in_force_key, provision_lists_enumerates_the_eight_topics_in_order, provision_lists_lengths, notice_with_request_list_reads_out_whole, consent_request_list_reads_out_whole, the_shared_safeguard_atom_carries_each_list_citation, the_verdict_reads_out_with_its_citations, the_checklist_marks_the_withdrawal_unmet, the_checklist_marks_an_unsure_judgement_unknown]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
