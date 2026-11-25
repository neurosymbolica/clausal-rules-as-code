% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_codes_and_certification_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_gdpr_codes_and_certification, [certification_status/5, code_monitoring_status/3, accreditation_status/6, decide_gdpr_codes_and_certification/2, gdpr_codes_and_certification_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_fixtures, [gdpr_codes_and_certification_profile_for/2]).

certification_results(Subject, IssuedOn, CheckDate, Results) :-
    gdpr_codes_and_certification_profile_for(Subject, Profile),
    findall(Result - Citations, certification_status(Profile, IssuedOn, CheckDate, Result, Citations), Results).

certification_answers(Subject, IssuedOn, CheckDate, Answers) :-
    gdpr_codes_and_certification_profile_for(Subject, Profile),
    findall(Result, certification_status(Profile, IssuedOn, CheckDate, Result, _), Answers).

code_answers(Subject, Answers) :-
    gdpr_codes_and_certification_profile_for(Subject, Profile),
    findall(Result - Citations, code_monitoring_status(Profile, Result, Citations), Answers).

accreditation_answers(Subject, Body, AccreditedOn, CheckDate, Answers) :-
    gdpr_codes_and_certification_profile_for(Subject, Profile),
    findall(Result, accreditation_status(Profile, Body, AccreditedOn, CheckDate, Result, _), Answers).

met_item(item(_, met, cite(_))).

test(certification_last_day_reads_out_within) :-
    certification_answers(certification_on_last_day_of_period, date(2020, 1, 15), date(2023, 1, 15), Answers),
    Answers == [certification_result(within_maximum_period, not_relied_on_for_transfers)].
test(certification_day_after_last_day_reads_out_ended) :-
    certification_answers(certification_day_after_last_day_of_period, date(2020, 1, 15), date(2023, 1, 16), Answers),
    Answers == [certification_result(maximum_period_ended, not_relied_on_for_transfers)].
test(certification_leap_start_last_day_is_the_twenty_eighth) :-
    certification_answers(certification_leap_day_start_on_last_day, date(2024, 2, 29), date(2027, 2, 28), Answers),
    Answers == [certification_result(within_maximum_period, not_relied_on_for_transfers)].
test(certification_leap_start_first_of_march_has_ended) :-
    certification_answers(certification_leap_day_start_day_after_last_day, date(2024, 2, 29), date(2027, 3, 1), Answers),
    Answers == [certification_result(maximum_period_ended, not_relied_on_for_transfers)].
test(certification_issue_day_reads_out_within) :-
    certification_answers(certification_checked_on_issue_day, date(2024, 2, 29), date(2024, 2, 29), Answers),
    Answers == [certification_result(within_maximum_period, not_relied_on_for_transfers)].
test(certification_day_before_issue_reads_out_not_yet_issued) :-
    certification_answers(certification_checked_before_issue_day, date(2024, 2, 29), date(2024, 2, 28), Answers),
    Answers == [certification_result(not_yet_issued, not_relied_on_for_transfers)].
test(certification_final_answer_cites_its_five_provisions) :-
    certification_results(certification_for_transfers_conditions_met, date(2024, 1, 15), date(2026, 6, 1), Results),
    Results = [certification_result(within_maximum_period, transfer_conditions_met) - Citations],
    sort(Citations, Sorted),
    sort([cite(eu_reg_2016_679_art_42_2), cite(eu_reg_2016_679_art_42_4), cite(eu_reg_2016_679_art_42_5), cite(eu_reg_2016_679_art_42_7), cite(eu_reg_2016_679_art_43_1)], Sorted).
test(certification_referral_reads_out_its_pairs) :-
    certification_results(certification_requirements_unsure, date(2024, 1, 15), date(2026, 6, 1), Results),
    Results == [needs_legal_review(open_textured(certification_requirements_not_met, cite(eu_reg_2016_679_art_42_7)), [inputs_relied_on([certification_issuer - competent_supervisory_authority, certification_criteria_approved - true, certification_withdrawn - false, certification_requirements_not_met - unsure, certification_holder_not_subject_to_regulation - false])]) - []].
test(certification_missing_key_beats_the_referral) :-
    certification_results(certification_requirements_unsure_holder_absent, date(2024, 1, 15), date(2026, 6, 1), Results),
    Results == [indeterminate([certification_holder_not_subject_to_regulation]) - []].
test(certification_input_problem_reads_out_alone) :-
    certification_results(input_issue_date_not_a_real_day, date(2023, 2, 29), date(2024, 1, 1), Results),
    Results == [input_problems([wrong_type(issued_on)]) - []].
test(code_monitored_and_relied_on_reads_out_once) :-
    code_answers(code_monitored_and_relied_on_for_transfers, Answers),
    Answers = [code_result(monitoring_by_accredited_body(Duties), transfer_conditions_met) - Citations],
    Duties == [take_appropriate_action_on_infringement, inform_supervisory_authority_of_actions_and_reasons],
    sort(Citations, Sorted),
    sort([cite(eu_reg_2016_679_art_40_2), cite(eu_reg_2016_679_art_40_3), cite(eu_reg_2016_679_art_40_4), cite(eu_reg_2016_679_art_40_5), cite(eu_reg_2016_679_art_40_9), cite(eu_reg_2016_679_art_41_1), cite(eu_reg_2016_679_art_41_4), cite(eu_reg_2016_679_art_41_6)], Sorted).
test(code_referral_reads_out_every_present_pair) :-
    code_answers(code_preparer_unsure, Answers),
    Answers == [needs_legal_review(open_textured(code_prepared_by_body_representing_controllers_or_processors, cite(eu_reg_2016_679_art_40_2)), [inputs_relied_on([processing_by_public_authority_or_body - false, code_prepared_by_body_representing_controllers_or_processors - unsure, code_approved_by_competent_supervisory_authority - true, code_contains_monitoring_mechanisms - true, monitoring_body_accredited - true, code_adhered_to_by_party_not_subject_to_regulation - true, code_has_general_validity - true, code_adherent_binding_commitments_made - true])]) - []].
test(code_absence_in_the_transfer_part_beats_the_monitoring_referral) :-
    code_answers(code_preparer_unsure_general_validity_absent, Answers),
    Answers == [indeterminate([code_has_general_validity]) - []].
test(code_public_authority_still_names_the_transfer_key) :-
    code_answers(code_public_authority_adherence_absent, Answers),
    Answers == [indeterminate([code_adhered_to_by_party_not_subject_to_regulation]) - []].
test(monitoring_body_accreditation_day_reads_out_met) :-
    accreditation_answers(monitoring_body_checked_on_accreditation_day, monitoring_body, date(2020, 1, 1), date(2020, 1, 1), Answers),
    Answers == [accreditation_conditions_met].
test(monitoring_body_day_before_reads_out_not_yet) :-
    accreditation_answers(monitoring_body_checked_before_accreditation_day, monitoring_body, date(2020, 1, 1), date(2019, 12, 31), Answers),
    Answers == [not_yet_accredited].
test(monitoring_body_citations_are_its_seven) :-
    gdpr_codes_and_certification_profile_for(monitoring_body_conditions_met, Profile),
    findall(Citations, accreditation_status(Profile, monitoring_body, date(2020, 1, 1), date(2030, 1, 1), accreditation_conditions_met, Citations), [Citations]),
    sort(Citations, Sorted),
    sort([cite(eu_reg_2016_679_art_41_1), cite(eu_reg_2016_679_art_41_2), cite(eu_reg_2016_679_art_41_2_a), cite(eu_reg_2016_679_art_41_2_b), cite(eu_reg_2016_679_art_41_2_c), cite(eu_reg_2016_679_art_41_2_d), cite(eu_reg_2016_679_art_41_5)], Sorted).
test(monitoring_body_referral_reads_out_its_pairs) :-
    gdpr_codes_and_certification_profile_for(monitoring_body_infringement_unsure, Profile),
    findall(Result - Citations, accreditation_status(Profile, monitoring_body, date(2020, 1, 1), date(2030, 1, 1), Result, Citations), Results),
    Results == [needs_legal_review(open_textured(monitoring_body_actions_infringe_regulation, cite(eu_reg_2016_679_art_41_5)), [inputs_relied_on([monitoring_body_accreditation_revoked - false, monitoring_body_independence_and_expertise_demonstrated - true, monitoring_body_eligibility_monitoring_and_review_procedures_established - true, monitoring_body_complaint_procedures_and_structures_established - true, monitoring_body_no_conflict_of_interests_demonstrated - true, monitoring_body_actions_infringe_regulation - unsure])]) - []].
test(monitoring_body_first_unsure_condition_is_referred) :-
    accreditation_answers(monitoring_body_independence_unsure, monitoring_body, date(2020, 1, 1), date(2030, 1, 1), Answers),
    Answers = [needs_legal_review(open_textured(monitoring_body_independence_and_expertise_demonstrated, cite(eu_reg_2016_679_art_41_2_a)), [inputs_relied_on(_)])].
test(certification_body_last_day_reads_out_met) :-
    accreditation_answers(certification_body_on_last_day_of_period, certification_body, date(2020, 1, 1), date(2025, 1, 1), Answers),
    Answers == [accreditation_conditions_met].
test(certification_body_day_after_reads_out_ended) :-
    accreditation_answers(certification_body_day_after_last_day_of_period, certification_body, date(2020, 1, 1), date(2025, 1, 2), Answers),
    Answers == [maximum_period_ended].
test(certification_body_leap_start_last_day_is_the_twenty_eighth) :-
    accreditation_answers(certification_body_leap_day_start_on_last_day, certification_body, date(2020, 2, 29), date(2025, 2, 28), Answers),
    Answers == [accreditation_conditions_met].
test(certification_body_leap_start_first_of_march_has_ended) :-
    accreditation_answers(certification_body_leap_day_start_day_after_last_day, certification_body, date(2020, 2, 29), date(2025, 3, 1), Answers),
    Answers == [maximum_period_ended].
test(certification_body_period_beyond_the_calendar_raises_nothing) :-
    accreditation_answers(certification_body_period_beyond_calendar, certification_body, date(9998, 1, 1), date(9999, 12, 31), Answers),
    Answers == [accreditation_conditions_met].
test(certification_body_citations_are_its_eleven) :-
    gdpr_codes_and_certification_profile_for(certification_body_conditions_met, Profile),
    findall(Citations, accreditation_status(Profile, certification_body, date(2020, 1, 1), date(2024, 6, 1), accreditation_conditions_met, Citations), [Citations]),
    sort(Citations, Sorted),
    sort([cite(eu_reg_2016_679_art_43_1), cite(eu_reg_2016_679_art_43_1_a), cite(eu_reg_2016_679_art_43_1_b), cite(eu_reg_2016_679_art_43_2), cite(eu_reg_2016_679_art_43_2_a), cite(eu_reg_2016_679_art_43_2_b), cite(eu_reg_2016_679_art_43_2_c), cite(eu_reg_2016_679_art_43_2_d), cite(eu_reg_2016_679_art_43_2_e), cite(eu_reg_2016_679_art_43_4), cite(eu_reg_2016_679_art_43_7)], Sorted).
test(certification_body_referral_reads_out_its_pairs) :-
    gdpr_codes_and_certification_profile_for(certification_body_conflict_unsure, Profile),
    findall(Result - Citations, accreditation_status(Profile, certification_body, date(2020, 1, 1), date(2024, 6, 1), Result, Citations), Results),
    Results == [needs_legal_review(open_textured(certification_body_no_conflict_of_interests_demonstrated, cite(eu_reg_2016_679_art_43_2_e)), [inputs_relied_on([certification_body_accreditation_revoked - false, certification_body_accrediting_entity - national_accreditation_body, certification_body_independence_and_expertise_demonstrated - true, certification_body_undertook_to_respect_approved_criteria - true, certification_body_issuing_review_and_withdrawal_procedures_established - true, certification_body_complaint_procedures_and_structures_established - true, certification_body_no_conflict_of_interests_demonstrated - unsure, certification_body_actions_infringe_regulation - false])]) - []].
test(the_verdict_carries_a_citation) :-
    gdpr_codes_and_certification_profile_for(code_monitored_and_relied_on_for_transfers, Profile),
    findall(Verdict, decide_gdpr_codes_and_certification(Profile, Verdict), [gdpr_codes_and_certification_verdict(_Status, [_FirstCitation|_OtherCitations])]).
test(the_checklist_reads_out_one_met_item_per_step) :-
    gdpr_codes_and_certification_profile_for(code_monitored_and_relied_on_for_transfers, Profile),
    findall(Items, gdpr_codes_and_certification_checklist(Profile, Items), [Items]),
    length(Items, 7),
    maplist(met_item, Items).

cp_test_names([certification_last_day_reads_out_within, certification_day_after_last_day_reads_out_ended, certification_leap_start_last_day_is_the_twenty_eighth, certification_leap_start_first_of_march_has_ended, certification_issue_day_reads_out_within, certification_day_before_issue_reads_out_not_yet_issued, certification_final_answer_cites_its_five_provisions, certification_referral_reads_out_its_pairs, certification_missing_key_beats_the_referral, certification_input_problem_reads_out_alone, code_monitored_and_relied_on_reads_out_once, code_referral_reads_out_every_present_pair, code_absence_in_the_transfer_part_beats_the_monitoring_referral, code_public_authority_still_names_the_transfer_key, monitoring_body_accreditation_day_reads_out_met, monitoring_body_day_before_reads_out_not_yet, monitoring_body_citations_are_its_seven, monitoring_body_referral_reads_out_its_pairs, monitoring_body_first_unsure_condition_is_referred, certification_body_last_day_reads_out_met, certification_body_day_after_reads_out_ended, certification_body_leap_start_last_day_is_the_twenty_eighth, certification_body_leap_start_first_of_march_has_ended, certification_body_period_beyond_the_calendar_raises_nothing, certification_body_citations_are_its_eleven, certification_body_referral_reads_out_its_pairs, the_verdict_carries_a_citation, the_checklist_reads_out_one_met_item_per_step]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
