% SPDX-License-Identifier: EUPL-1.2
:- module(m__sg_data_protection_pdpa_data_breach_notification_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_queries, [pdpa_data_breach_notification_profile_keys/1, pdpa_data_breach_notification_what_if/4, notifiable/0, not_notifiable/0, n_a/0, no_significant_harm/0, additional_item/3, content_item/2, duplicate_key/1, indeterminate/1, needs_legal_review/2, pdpa_breach/5, provenance/2, unknown_key/1]).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_kernel, [pdpa_data_breach_notification_input_problems/2]).
:- use_module(m__sg_data_protection_pdpa_data_breach_notification_fixtures, [pdpa_data_breach_notification_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    pdpa_data_breach_notification_profile_keys(ProfileKeys),
    ProfileKeys == [breach_occurred_date, within_organisation_only, breach_kinds, is_data_breach, breached_data, publicly_available_or_lawfully_disclosed, assessed_likely_significant_harm, affected_individuals_count, assessed_likely_significant_scale, prohibited_by_law_enforcement_agency, prohibited_by_commission_direction, commission_waiver_granted, remedial_action_renders_harm_unlikely, prior_technological_measure_renders_harm_unlikely, assessment_date, caller_role, reason_to_believe_breach_occurred, personal_data_in_possession_or_control, notified_by_data_intermediary].
test(what_if_raising_the_count_flips_to_notifiable) :-
    pdpa_data_breach_notification_profile_for(affected_count_below_prescribed_number, Profile),
    pdpa_data_breach_notification_what_if(Profile, affected_individuals_count, 500, notifiable).
test(what_if_gives_exactly_one_answer) :-
    pdpa_data_breach_notification_profile_for(affected_count_below_prescribed_number, Profile),
    findall(Status, pdpa_data_breach_notification_what_if(Profile, affected_individuals_count, 500, Status), Statuses),
    Statuses == [notifiable].
test(what_if_within_the_organisation_only_flips_to_not_notifiable) :-
    pdpa_data_breach_notification_profile_for(account_pair_breach, Profile),
    pdpa_data_breach_notification_what_if(Profile, within_organisation_only, true, not_notifiable).
test(what_if_an_earlier_breach_date_flips_to_not_applicable) :-
    pdpa_data_breach_notification_profile_for(account_pair_breach, Profile),
    pdpa_data_breach_notification_what_if(Profile, breach_occurred_date, date(2021, 1, 31), not_applicable).
test(what_if_with_a_value_outside_its_type_is_an_input_problem) :-
    pdpa_data_breach_notification_profile_for(account_pair_breach, Profile),
    pdpa_data_breach_notification_what_if(Profile, is_data_breach, maybe, Status),
    Status == input_problems([wrong_type(is_data_breach)]).
test(the_reexported_input_check_names_a_duplicate) :-
    pdpa_data_breach_notification_profile_for(duplicate_key_profile, Profile),
    pdpa_data_breach_notification_input_problems(Profile, Problems),
    Problems == [duplicate_key(is_data_breach)].
test(the_reexported_input_check_accepts_a_fixture) :-
    pdpa_data_breach_notification_profile_for(full_notifiable_with_deadline, Profile),
    pdpa_data_breach_notification_input_problems(Profile, Problems),
    Problems == [].
test(the_result_atoms_are_served) :-
    notifiable,
    not_notifiable,
    n_a,
    no_significant_harm.
test(the_indeterminate_recogniser_holds_for_a_contract_key) :-
    indeterminate([breach_occurred_date]).
test(the_referral_recogniser_holds_for_a_judgement_key) :-
    needs_legal_review(open_textured(assessed_likely_significant_harm, cite(sg_pdpa_2012_s26b_1_a)), [inputs_relied_on([assessed_likely_significant_harm - unsure])]).
test(the_provenance_recogniser_holds_for_a_contract_key) :-
    provenance(breach_occurred_date, cite(sg_pdpa_2012_s26c_1)).
test(the_content_item_recogniser_reads_out_its_citation_directly) :-
    content_item(how_breach_occurred, Citation),
    Citation == cite(sg_pdpa_2012_s64_2021_reg_5_1_c).
test(the_additional_item_recogniser_reads_out_its_condition_directly) :-
    additional_item(late_notification_reasons_and_evidence, Condition, Citation),
    Condition == notified_after_period,
    Citation == cite(sg_pdpa_2012_s64_2021_reg_5_2).
test(the_unknown_key_recogniser_holds_for_a_foreign_key) :-
    unknown_key(colour).
test(the_duplicate_key_recogniser_holds_for_a_contract_key) :-
    duplicate_key(caller_role).
test(the_combined_answer_recogniser_holds_for_a_notifiable_answer) :-
    pdpa_breach(notifiable, [significant_harm, significant_scale], date(2026, 1, 5), required, [cite(sg_pdpa_2012_s26d_1), cite(sg_pdpa_2012_s26d_2)]).
test(the_indeterminate_recogniser_answers_once) :-
    findall(found, indeterminate([breach_occurred_date]), Answers),
    Answers == [found].
test(the_referral_recogniser_answers_once) :-
    findall(found, needs_legal_review(open_textured(assessed_likely_significant_harm, cite(sg_pdpa_2012_s26b_1_a)), [inputs_relied_on([assessed_likely_significant_harm - unsure])]), Answers),
    Answers == [found].
test(the_provenance_recogniser_answers_once) :-
    findall(found, provenance(breach_occurred_date, cite(sg_pdpa_2012_s26c_1)), Answers),
    Answers == [found].
test(the_content_item_recogniser_answers_once) :-
    findall(found, content_item(how_breach_occurred, cite(sg_pdpa_2012_s64_2021_reg_5_1_c)), Answers),
    Answers == [found].
test(the_additional_item_recogniser_answers_once) :-
    findall(found, additional_item(grounds_for_not_notifying_affected_individuals, affected_individuals_not_to_be_notified, cite(sg_pdpa_2012_s64_2021_reg_5_3)), Answers),
    Answers == [found].
test(the_unknown_key_recogniser_answers_once) :-
    findall(found, unknown_key(colour), Answers),
    Answers == [found].
test(the_duplicate_key_recogniser_answers_once) :-
    findall(found, duplicate_key(caller_role), Answers),
    Answers == [found].
test(the_combined_answer_recogniser_answers_once) :-
    findall(found, pdpa_breach(notifiable, [significant_harm, significant_scale], date(2026, 1, 5), required, [cite(sg_pdpa_2012_s26d_1), cite(sg_pdpa_2012_s26d_2)]), Answers),
    Answers == [found].
test(the_combined_answer_recogniser_answers_once_for_n_a) :-
    findall(found, pdpa_breach(not_notifiable, [], n_a, n_a, [cite(sg_pdpa_2012_s26b_4)]), Answers),
    Answers == [found].

test(what_if_raising_the_count_is_not_not_notifiable, fail) :-
    pdpa_data_breach_notification_profile_for(affected_count_below_prescribed_number, Profile),
    pdpa_data_breach_notification_what_if(Profile, affected_individuals_count, 500, not_notifiable).
test(the_indeterminate_recogniser_refuses_a_foreign_key, fail) :-
    indeterminate([colour]).
test(the_referral_recogniser_refuses_a_crisp_key, fail) :-
    needs_legal_review(open_textured(commission_waiver_granted, cite(sg_pdpa_2012_s26d_7)), [inputs_relied_on([])]).
test(the_provenance_recogniser_refuses_a_foreign_key, fail) :-
    provenance(colour, cite(sg_pdpa_2012_s26c_1)).
test(the_content_item_recogniser_refuses_a_wrong_citation, fail) :-
    content_item(how_breach_occurred, cite(sg_pdpa_2012_s64_2021_reg_5_1_d)).
test(the_additional_item_recogniser_refuses_a_wrong_condition, fail) :-
    additional_item(grounds_for_not_notifying_affected_individuals, notified_after_period, cite(sg_pdpa_2012_s64_2021_reg_5_3)).
test(the_unknown_key_recogniser_refuses_a_contract_key, fail) :-
    unknown_key(caller_role).
test(the_duplicate_key_recogniser_refuses_a_foreign_key, fail) :-
    duplicate_key(colour).
test(the_combined_answer_recogniser_refuses_a_foreign_ground, fail) :-
    pdpa_breach(notifiable, [significant_risk], n_a, n_a, []).

cp_test_names([profile_keys_are_the_contract_keys, what_if_raising_the_count_flips_to_notifiable, what_if_gives_exactly_one_answer, what_if_within_the_organisation_only_flips_to_not_notifiable, what_if_an_earlier_breach_date_flips_to_not_applicable, what_if_with_a_value_outside_its_type_is_an_input_problem, the_reexported_input_check_names_a_duplicate, the_reexported_input_check_accepts_a_fixture, the_result_atoms_are_served, the_indeterminate_recogniser_holds_for_a_contract_key, the_referral_recogniser_holds_for_a_judgement_key, the_provenance_recogniser_holds_for_a_contract_key, the_content_item_recogniser_reads_out_its_citation_directly, the_additional_item_recogniser_reads_out_its_condition_directly, the_unknown_key_recogniser_holds_for_a_foreign_key, the_duplicate_key_recogniser_holds_for_a_contract_key, the_combined_answer_recogniser_holds_for_a_notifiable_answer, the_indeterminate_recogniser_answers_once, the_referral_recogniser_answers_once, the_provenance_recogniser_answers_once, the_content_item_recogniser_answers_once, the_additional_item_recogniser_answers_once, the_unknown_key_recogniser_answers_once, the_duplicate_key_recogniser_answers_once, the_combined_answer_recogniser_answers_once, the_combined_answer_recogniser_answers_once_for_n_a]).
cp_test_fail_names([what_if_raising_the_count_is_not_not_notifiable, the_indeterminate_recogniser_refuses_a_foreign_key, the_referral_recogniser_refuses_a_crisp_key, the_provenance_recogniser_refuses_a_foreign_key, the_content_item_recogniser_refuses_a_wrong_citation, the_additional_item_recogniser_refuses_a_wrong_condition, the_unknown_key_recogniser_refuses_a_contract_key, the_duplicate_key_recogniser_refuses_a_foreign_key, the_combined_answer_recogniser_refuses_a_foreign_ground]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
