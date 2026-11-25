% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_codes_and_certification_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_fixtures, [gdpr_codes_and_certification_assess/2]).

verdict_of(Subject, Result) :-
    gdpr_codes_and_certification_assess(Subject, gdpr_codes_and_certification_verdict(Result, _Citations)).

test(last_day_is_within_the_period) :-
    verdict_of(certification_on_last_day_of_period, certification_result(within_maximum_period, _)).
test(day_after_last_day_has_ended) :-
    verdict_of(certification_day_after_last_day_of_period, certification_result(maximum_period_ended, _)).
test(leap_start_last_day_is_within) :-
    verdict_of(certification_leap_day_start_on_last_day, certification_result(within_maximum_period, _)).
test(leap_start_first_of_march_has_ended) :-
    verdict_of(certification_leap_day_start_day_after_last_day, certification_result(maximum_period_ended, _)).
test(issue_day_is_issued) :-
    verdict_of(certification_checked_on_issue_day, certification_result(within_maximum_period, _)).
test(day_before_issue_is_not_yet_issued) :-
    verdict_of(certification_checked_before_issue_day, certification_result(not_yet_issued, _)).
test(authority_issuer_is_competent) :-
    verdict_of(certification_in_force, certification_result(within_maximum_period, _)).
test(other_issuer_is_not_competent) :-
    verdict_of(certification_by_other_issuer, certification_result(not_issued_by_competent_issuer, _)).
test(accredited_body_that_informed_is_within) :-
    verdict_of(certification_by_accredited_body_that_informed, certification_result(within_maximum_period, _)).
test(unaccredited_body_is_not_competent) :-
    verdict_of(certification_by_unaccredited_body, certification_result(not_issued_by_competent_issuer, _)).
test(body_accreditation_absent_is_named) :-
    verdict_of(certification_body_accreditation_absent, indeterminate([certification_body_accredited])).
test(issuer_absent_is_named) :-
    verdict_of(certification_issuer_absent, indeterminate([certification_issuer])).
test(body_that_did_not_inform_is_named) :-
    verdict_of(certification_body_did_not_inform, certification_result(issued_without_informing_supervisory_authority, _)).
test(unapproved_criteria_is_named) :-
    verdict_of(certification_criteria_not_approved, certification_result(criteria_not_approved, _)).
test(withdrawn_is_withdrawn) :-
    verdict_of(certification_withdrawn, certification_result(withdrawn, _)).
test(criteria_no_longer_met_requires_withdrawal) :-
    verdict_of(certification_requirements_no_longer_met, certification_result(withdrawal_required, _)).
test(unsure_requirements_are_referred) :-
    verdict_of(certification_requirements_unsure, needs_legal_review(open_textured(certification_requirements_not_met, cite(eu_reg_2016_679_art_42_7)), _)).
test(unsure_requirements_with_holder_absent_name_the_holder) :-
    verdict_of(certification_requirements_unsure_holder_absent, indeterminate([certification_holder_not_subject_to_regulation])).
test(certification_transfer_conditions_met) :-
    verdict_of(certification_for_transfers_conditions_met, certification_result(_, transfer_conditions_met)).
test(without_commitments_transfer_conditions_not_met) :-
    verdict_of(certification_for_transfers_without_commitments, certification_result(_, transfer_conditions_not_met)).
test(absent_commitments_are_named) :-
    verdict_of(certification_for_transfers_commitments_absent, indeterminate([certification_holder_binding_commitments_made])).
test(a_certification_not_relied_on_for_transfers) :-
    verdict_of(certification_in_force, certification_result(_, not_relied_on_for_transfers)).
test(the_transfer_part_is_answered_beside_withdrawn) :-
    verdict_of(certification_withdrawn_transfer_conditions_met, certification_result(withdrawn, transfer_conditions_met)).
test(code_monitored_by_an_accredited_body) :-
    verdict_of(code_monitored_and_relied_on_for_transfers, code_result(monitoring_by_accredited_body(_), _)).
test(public_authority_code_article_41_not_applicable) :-
    verdict_of(code_for_public_authority_processing, code_result(article_41_not_applicable, not_relied_on_for_transfers)).
test(code_not_prepared_by_representative_body_is_named) :-
    verdict_of(code_not_prepared_by_representative_body, code_result(not_a_code_under_article_40_2, transfer_conditions_met)).
test(unapproved_code_is_named_in_both_parts) :-
    verdict_of(code_not_approved, code_result(code_not_approved, transfer_conditions_not_met)).
test(code_without_mechanisms_is_named) :-
    verdict_of(code_without_monitoring_mechanisms, code_result(monitoring_mechanisms_missing, _)).
test(code_without_accredited_body_is_named) :-
    verdict_of(code_without_accredited_monitoring_body, code_result(no_accredited_monitoring_body, _)).
test(code_transfer_conditions_met) :-
    verdict_of(code_monitored_and_relied_on_for_transfers, code_result(_, transfer_conditions_met)).
test(code_without_general_validity_transfer_conditions_not_met) :-
    verdict_of(code_without_general_validity, code_result(_, transfer_conditions_not_met)).
test(code_not_relied_on_for_transfers) :-
    verdict_of(code_not_relied_on_for_transfers, code_result(_, not_relied_on_for_transfers)).
test(unsure_preparer_is_referred) :-
    verdict_of(code_preparer_unsure, needs_legal_review(open_textured(code_prepared_by_body_representing_controllers_or_processors, cite(eu_reg_2016_679_art_40_2)), _)).
test(unsure_preparer_with_approval_absent_names_the_approval) :-
    verdict_of(code_preparer_unsure_approval_absent, indeterminate([code_approved_by_competent_supervisory_authority])).
test(monitoring_body_conditions_met) :-
    verdict_of(monitoring_body_conditions_met, accreditation_conditions_met).
test(monitoring_body_before_accreditation_is_not_yet_accredited) :-
    verdict_of(monitoring_body_checked_before_accreditation_day, not_yet_accredited).
test(monitoring_body_revoked_is_revoked) :-
    verdict_of(monitoring_body_accreditation_revoked, accreditation_revoked).
test(monitoring_body_missing_complaint_procedures_conditions_not_met) :-
    verdict_of(monitoring_body_complaint_procedures_missing, accreditation_conditions_not_met).
test(monitoring_body_infringing_actions_require_revocation) :-
    verdict_of(monitoring_body_actions_infringe, revocation_required).
test(monitoring_body_unsure_independence_is_referred) :-
    verdict_of(monitoring_body_independence_unsure, needs_legal_review(open_textured(monitoring_body_independence_and_expertise_demonstrated, cite(eu_reg_2016_679_art_41_2_a)), _)).
test(monitoring_body_unsure_with_a_false_condition_is_not_met) :-
    verdict_of(monitoring_body_independence_unsure_conflict_refuted, accreditation_conditions_not_met).
test(monitoring_body_unsure_infringement_is_referred) :-
    verdict_of(monitoring_body_infringement_unsure, needs_legal_review(open_textured(monitoring_body_actions_infringe_regulation, cite(eu_reg_2016_679_art_41_5)), _)).
test(certification_body_conditions_met) :-
    verdict_of(certification_body_conditions_met, accreditation_conditions_met).
test(certification_body_last_day_is_met) :-
    verdict_of(certification_body_on_last_day_of_period, accreditation_conditions_met).
test(certification_body_day_after_has_ended) :-
    verdict_of(certification_body_day_after_last_day_of_period, maximum_period_ended).
test(certification_body_leap_start_last_day_is_met) :-
    verdict_of(certification_body_leap_day_start_on_last_day, accreditation_conditions_met).
test(certification_body_leap_start_first_of_march_has_ended) :-
    verdict_of(certification_body_leap_day_start_day_after_last_day, maximum_period_ended).
test(certification_body_before_accreditation_is_not_yet_accredited) :-
    verdict_of(certification_body_checked_before_accreditation_day, not_yet_accredited).
test(certification_body_accredited_by_both_is_met) :-
    verdict_of(certification_body_accredited_by_both_entities, accreditation_conditions_met).
test(certification_body_accredited_by_other_entity_is_named) :-
    verdict_of(certification_body_accredited_by_other_entity, not_accredited_by_entity_named_in_article_43_1).
test(certification_body_revoked_is_revoked) :-
    verdict_of(certification_body_accreditation_revoked, accreditation_revoked).
test(certification_body_missing_undertaking_conditions_not_met) :-
    verdict_of(certification_body_criteria_undertaking_missing, accreditation_conditions_not_met).
test(certification_body_infringing_actions_require_revocation) :-
    verdict_of(certification_body_actions_infringe, revocation_required).
test(certification_body_unsure_conflict_is_referred) :-
    verdict_of(certification_body_conflict_unsure, needs_legal_review(open_textured(certification_body_no_conflict_of_interests_demonstrated, cite(eu_reg_2016_679_art_43_2_e)), _)).
test(duplicate_and_unknown_keys_are_input_problems) :-
    verdict_of(input_duplicate_and_unknown, input_problems([duplicate_key(certification_withdrawn), unknown_key(colour)])).
test(an_attested_value_is_wrong_type) :-
    verdict_of(input_attested_value, input_problems([wrong_type(certification_withdrawn)])).
test(a_crisp_key_unsure_is_wrong_type) :-
    verdict_of(input_crisp_key_unsure, input_problems([wrong_type(certification_withdrawn)])).
test(a_judgement_key_unsure_profile_names_its_first_key) :-
    verdict_of(input_judgement_key_unsure, indeterminate([processing_by_public_authority_or_body])).
test(bad_body_and_dates_are_input_problems) :-
    verdict_of(input_bad_body_and_dates, input_problems([wrong_type(body), wrong_type(accredited_on), wrong_type(check_date)])).
test(a_real_leap_day_accreditation_is_not_an_input_problem) :-
    verdict_of(monitoring_body_accredited_on_leap_day, accreditation_conditions_met).

test(day_after_last_day_is_not_within, fail) :-
    verdict_of(certification_day_after_last_day_of_period, certification_result(within_maximum_period, _)).
test(leap_start_first_of_march_is_not_within, fail) :-
    verdict_of(certification_leap_day_start_day_after_last_day, certification_result(within_maximum_period, _)).
test(issue_day_is_not_not_yet_issued, fail) :-
    verdict_of(certification_checked_on_issue_day, certification_result(not_yet_issued, _)).
test(other_issuer_is_not_within, fail) :-
    verdict_of(certification_by_other_issuer, certification_result(within_maximum_period, _)).
test(unaccredited_body_is_not_within, fail) :-
    verdict_of(certification_by_unaccredited_body, certification_result(within_maximum_period, _)).
test(body_that_did_not_inform_is_not_within, fail) :-
    verdict_of(certification_body_did_not_inform, certification_result(within_maximum_period, _)).
test(unapproved_criteria_is_not_within, fail) :-
    verdict_of(certification_criteria_not_approved, certification_result(within_maximum_period, _)).
test(withdrawn_is_not_withdrawal_required, fail) :-
    verdict_of(certification_withdrawn, certification_result(withdrawal_required, _)).
test(criteria_no_longer_met_is_not_withdrawn, fail) :-
    verdict_of(certification_requirements_no_longer_met, certification_result(withdrawn, _)).
test(unsure_requirements_with_holder_absent_are_not_referred, fail) :-
    verdict_of(certification_requirements_unsure_holder_absent, needs_legal_review(_, _)).
test(without_commitments_transfer_conditions_are_not_met, fail) :-
    verdict_of(certification_for_transfers_without_commitments, certification_result(_, transfer_conditions_met)).
test(public_authority_code_is_not_monitored_under_article_41, fail) :-
    verdict_of(code_for_public_authority_processing, code_result(monitoring_by_accredited_body(_), _)).
test(code_not_prepared_by_representative_body_is_not_monitored, fail) :-
    verdict_of(code_not_prepared_by_representative_body, code_result(monitoring_by_accredited_body(_), _)).
test(unapproved_code_is_not_monitored, fail) :-
    verdict_of(code_not_approved, code_result(monitoring_by_accredited_body(_), _)).
test(code_without_mechanisms_is_not_monitored, fail) :-
    verdict_of(code_without_monitoring_mechanisms, code_result(monitoring_by_accredited_body(_), _)).
test(code_without_accredited_body_is_not_monitored, fail) :-
    verdict_of(code_without_accredited_monitoring_body, code_result(monitoring_by_accredited_body(_), _)).
test(code_without_general_validity_does_not_meet_them, fail) :-
    verdict_of(code_without_general_validity, code_result(_, transfer_conditions_met)).
test(unsure_preparer_with_approval_absent_is_not_referred, fail) :-
    verdict_of(code_preparer_unsure_approval_absent, needs_legal_review(_, _)).
test(monitoring_body_before_accreditation_is_not_met, fail) :-
    verdict_of(monitoring_body_checked_before_accreditation_day, accreditation_conditions_met).
test(monitoring_body_revoked_is_not_met, fail) :-
    verdict_of(monitoring_body_accreditation_revoked, accreditation_conditions_met).
test(monitoring_body_missing_complaint_procedures_is_not_met, fail) :-
    verdict_of(monitoring_body_complaint_procedures_missing, accreditation_conditions_met).
test(monitoring_body_infringing_actions_are_not_revocation_free, fail) :-
    verdict_of(monitoring_body_actions_infringe, accreditation_conditions_met).
test(monitoring_body_unsure_with_a_false_condition_is_not_referred, fail) :-
    verdict_of(monitoring_body_independence_unsure_conflict_refuted, needs_legal_review(_, _)).
test(certification_body_day_after_is_not_met, fail) :-
    verdict_of(certification_body_day_after_last_day_of_period, accreditation_conditions_met).
test(certification_body_accredited_by_other_entity_is_not_met, fail) :-
    verdict_of(certification_body_accredited_by_other_entity, accreditation_conditions_met).
test(certification_body_missing_undertaking_is_not_met, fail) :-
    verdict_of(certification_body_criteria_undertaking_missing, accreditation_conditions_met).
test(certification_body_infringing_actions_are_not_met, fail) :-
    verdict_of(certification_body_actions_infringe, accreditation_conditions_met).
test(a_judgement_key_unsure_is_not_an_input_problem, fail) :-
    verdict_of(input_judgement_key_unsure, input_problems(_)).

cp_test_names([last_day_is_within_the_period, day_after_last_day_has_ended, leap_start_last_day_is_within, leap_start_first_of_march_has_ended, issue_day_is_issued, day_before_issue_is_not_yet_issued, authority_issuer_is_competent, other_issuer_is_not_competent, accredited_body_that_informed_is_within, unaccredited_body_is_not_competent, body_accreditation_absent_is_named, issuer_absent_is_named, body_that_did_not_inform_is_named, unapproved_criteria_is_named, withdrawn_is_withdrawn, criteria_no_longer_met_requires_withdrawal, unsure_requirements_are_referred, unsure_requirements_with_holder_absent_name_the_holder, certification_transfer_conditions_met, without_commitments_transfer_conditions_not_met, absent_commitments_are_named, a_certification_not_relied_on_for_transfers, the_transfer_part_is_answered_beside_withdrawn, code_monitored_by_an_accredited_body, public_authority_code_article_41_not_applicable, code_not_prepared_by_representative_body_is_named, unapproved_code_is_named_in_both_parts, code_without_mechanisms_is_named, code_without_accredited_body_is_named, code_transfer_conditions_met, code_without_general_validity_transfer_conditions_not_met, code_not_relied_on_for_transfers, unsure_preparer_is_referred, unsure_preparer_with_approval_absent_names_the_approval, monitoring_body_conditions_met, monitoring_body_before_accreditation_is_not_yet_accredited, monitoring_body_revoked_is_revoked, monitoring_body_missing_complaint_procedures_conditions_not_met, monitoring_body_infringing_actions_require_revocation, monitoring_body_unsure_independence_is_referred, monitoring_body_unsure_with_a_false_condition_is_not_met, monitoring_body_unsure_infringement_is_referred, certification_body_conditions_met, certification_body_last_day_is_met, certification_body_day_after_has_ended, certification_body_leap_start_last_day_is_met, certification_body_leap_start_first_of_march_has_ended, certification_body_before_accreditation_is_not_yet_accredited, certification_body_accredited_by_both_is_met, certification_body_accredited_by_other_entity_is_named, certification_body_revoked_is_revoked, certification_body_missing_undertaking_conditions_not_met, certification_body_infringing_actions_require_revocation, certification_body_unsure_conflict_is_referred, duplicate_and_unknown_keys_are_input_problems, an_attested_value_is_wrong_type, a_crisp_key_unsure_is_wrong_type, a_judgement_key_unsure_profile_names_its_first_key, bad_body_and_dates_are_input_problems, a_real_leap_day_accreditation_is_not_an_input_problem]).
cp_test_fail_names([day_after_last_day_is_not_within, leap_start_first_of_march_is_not_within, issue_day_is_not_not_yet_issued, other_issuer_is_not_within, unaccredited_body_is_not_within, body_that_did_not_inform_is_not_within, unapproved_criteria_is_not_within, withdrawn_is_not_withdrawal_required, criteria_no_longer_met_is_not_withdrawn, unsure_requirements_with_holder_absent_are_not_referred, without_commitments_transfer_conditions_are_not_met, public_authority_code_is_not_monitored_under_article_41, code_not_prepared_by_representative_body_is_not_monitored, unapproved_code_is_not_monitored, code_without_mechanisms_is_not_monitored, code_without_accredited_body_is_not_monitored, code_without_general_validity_does_not_meet_them, unsure_preparer_with_approval_absent_is_not_referred, monitoring_body_before_accreditation_is_not_met, monitoring_body_revoked_is_not_met, monitoring_body_missing_complaint_procedures_is_not_met, monitoring_body_infringing_actions_are_not_revocation_free, monitoring_body_unsure_with_a_false_condition_is_not_referred, certification_body_day_after_is_not_met, certification_body_accredited_by_other_entity_is_not_met, certification_body_missing_undertaking_is_not_met, certification_body_infringing_actions_are_not_met, a_judgement_key_unsure_is_not_an_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
