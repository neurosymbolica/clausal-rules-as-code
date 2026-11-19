% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_security_retention_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_security_retention_dpdp_security_retention, [security_safeguards_duty/3, accuracy_duty/3, erasure_duty/3, third_schedule_deemed_no_longer_served/3, dpdp_security_retention_status/2, dpdp_security_retention_status_values/1]).
:- use_module(m__ind_dpdp_security_retention_fixtures, [dpdp_security_retention_profile_for/2]).

test(the_status_table_has_a_near_miss_atom) :-
    dpdp_security_retention_status_values(StatusValues),
    StatusValues = [_, _|_].
test(security_rule_6_route_positive) :-
    dpdp_security_retention_profile_for(safeguards_on_commencement_day, Profile),
    security_safeguards_duty(Profile, required_with_rule_6_minimum, _).
test(security_rule_6_route_near_miss_answer) :-
    dpdp_security_retention_profile_for(safeguards_day_before_commencement, Profile),
    security_safeguards_duty(Profile, required_minimum_not_prescribed, _).
test(security_not_required_route_positive) :-
    dpdp_security_retention_profile_for(processor_not_fiduciary, Profile),
    security_safeguards_duty(Profile, not_required, _).
test(security_not_required_route_near_miss_answer) :-
    dpdp_security_retention_profile_for(processor_now_fiduciary, Profile),
    security_safeguards_duty(Profile, required_with_rule_6_minimum, _).
test(security_not_in_force_route_positive) :-
    dpdp_security_retention_profile_for(nothing_in_force, Profile),
    security_safeguards_duty(Profile, not_in_force, _).
test(security_not_in_force_route_near_miss_answer) :-
    dpdp_security_retention_profile_for(safeguards_only_in_force, Profile),
    security_safeguards_duty(Profile, required_with_rule_6_minimum, _).
test(security_referral_route_positive) :-
    dpdp_security_retention_profile_for(fiduciary_unsure_with_day, Profile),
    security_safeguards_duty(Profile, needs_legal_review(open_textured(acts_as_data_fiduciary, cite(in_dpdp_act_2023_s_2_i)), _), []).
test(security_referral_route_near_miss_answer) :-
    dpdp_security_retention_profile_for(fiduciary_unsure_without_day, Profile),
    security_safeguards_duty(Profile, indeterminate([assessment_date]), []).
test(accuracy_required_route_positive) :-
    dpdp_security_retention_profile_for(accuracy_decision_use, Profile),
    accuracy_duty(Profile, required, _).
test(accuracy_required_route_near_miss_answer) :-
    dpdp_security_retention_profile_for(accuracy_neither_likely, Profile),
    accuracy_duty(Profile, not_required, _).
test(accuracy_not_in_force_route_positive) :-
    accuracy_duty([attribute(section_8_3_in_force, false), attribute(acts_as_data_fiduciary, true), attribute(likely_used_for_decision_affecting_data_principal, true)], not_in_force, [cite(in_dpdp_act_2023_s_8_3)]).
test(erasure_other_law_route_positive) :-
    dpdp_security_retention_profile_for(bank_account_closed, Profile),
    erasure_duty(Profile, retain_as_required_by_other_law, _).
test(erasure_other_law_route_near_miss_answer) :-
    dpdp_security_retention_profile_for(bank_no_other_law, Profile),
    erasure_duty(Profile, not_yet_required, _).
test(erasure_not_yet_route_positive) :-
    dpdp_security_retention_profile_for(bank_no_other_law, Profile),
    erasure_duty(Profile, not_yet_required, [cite(in_dpdp_act_2023_s_8_7_a)]).
test(erasure_not_yet_route_near_miss_answer) :-
    erasure_duty([attribute(section_8_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(retention_necessary_for_compliance_with_law, false), attribute(consent_withdrawn, true), attribute(specified_purpose_no_longer_served, false), attribute(assessment_date, date(2026, 12, 1)), attribute(data_made_available_to_data_processor, false)], erase, _).
test(erasure_hold_route_positive) :-
    dpdp_security_retention_profile_for(electronic_book_on_last_retention_day, Profile),
    erasure_duty(Profile, retain_until_minimum_retention_period_end, _).
test(erasure_hold_route_near_miss_answer) :-
    dpdp_security_retention_profile_for(cloud_processor_day_after_retention, Profile),
    erasure_duty(Profile, erase_and_cause_data_processor_to_erase, _).
test(erasure_processor_route_positive) :-
    dpdp_security_retention_profile_for(cloud_processor_day_after_retention, Profile),
    erasure_duty(Profile, erase_and_cause_data_processor_to_erase, [cite(in_dpdp_act_2023_s_8_7_a), cite(in_dpdp_act_2023_s_8_7_b)]).
test(erasure_processor_route_near_miss_answer) :-
    dpdp_security_retention_profile_for(marketplace_after_sale, Profile),
    erasure_duty(Profile, erase, [cite(in_dpdp_act_2023_s_8_7_a)]).
test(erasure_not_required_route_positive) :-
    dpdp_security_retention_profile_for(processor_not_fiduciary, Profile),
    erasure_duty(Profile, not_required, _).
test(erasure_not_required_route_near_miss_answer) :-
    dpdp_security_retention_profile_for(processor_now_fiduciary, Profile),
    erasure_duty(Profile, indeterminate([retention_necessary_for_compliance_with_law]), []).
test(deemed_route_positive) :-
    dpdp_security_retention_profile_for(social_media_day_after_period_end, Profile),
    third_schedule_deemed_no_longer_served(Profile, deemed_no_longer_served, _).
test(deemed_route_near_miss_answer) :-
    dpdp_security_retention_profile_for(social_media_on_period_end, Profile),
    third_schedule_deemed_no_longer_served(Profile, not_yet_deemed, _).
test(deemed_floor_route_positive) :-
    dpdp_security_retention_profile_for(e_commerce_on_deeming_floor, Profile),
    third_schedule_deemed_no_longer_served(Profile, not_yet_deemed, _).
test(deemed_floor_route_near_miss_answer) :-
    dpdp_security_retention_profile_for(e_commerce_day_after_deeming_floor, Profile),
    third_schedule_deemed_no_longer_served(Profile, indeterminate([last_approached_date]), []).
test(gaming_threshold_route_positive) :-
    dpdp_security_retention_profile_for(gaming_below_threshold, Profile),
    third_schedule_deemed_no_longer_served(Profile, not_listed, _).
test(gaming_threshold_route_near_miss_answer) :-
    dpdp_security_retention_profile_for(gaming_at_threshold, Profile),
    third_schedule_deemed_no_longer_served(Profile, deemed_no_longer_served, _).
test(e_commerce_threshold_route_positive) :-
    dpdp_security_retention_profile_for(e_commerce_below_threshold, Profile),
    third_schedule_deemed_no_longer_served(Profile, not_listed, _).
test(excepted_purpose_route_positive) :-
    third_schedule_deemed_no_longer_served([attribute(section_8_8_in_force, true), attribute(assessment_date, date(2030, 6, 2)), attribute(third_schedule_class, online_gaming_intermediary), attribute(registered_users_in_india, 5000000), attribute(third_schedule_purpose_excepted, true), attribute(last_approached_date, date(2027, 6, 1))], not_listed, [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3)]).
test(deemed_not_in_force_route_positive) :-
    dpdp_security_retention_profile_for(nothing_in_force, Profile),
    third_schedule_deemed_no_longer_served(Profile, not_in_force, _).
test(deemed_not_in_force_route_near_miss_answer) :-
    dpdp_security_retention_profile_for(processor_not_fiduciary, Profile),
    third_schedule_deemed_no_longer_served(Profile, not_listed, _).
test(facade_rejected_route_positive) :-
    dpdp_security_retention_profile_for(malformed_profile, Profile),
    dpdp_security_retention_status(Profile, profile_rejected).
test(facade_rejected_route_near_miss_answer) :-
    dpdp_security_retention_profile_for(empty_profile, Profile),
    dpdp_security_retention_status(Profile, section_8_duty_undetermined).
test(facade_owed_route_positive) :-
    dpdp_security_retention_profile_for(safeguards_only_in_force, Profile),
    dpdp_security_retention_status(Profile, section_8_duty_owed).
test(facade_owed_route_near_miss_answer) :-
    dpdp_security_retention_profile_for(nothing_in_force, Profile),
    dpdp_security_retention_status(Profile, no_section_8_duty_owed).

test(security_rule_6_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(safeguards_day_before_commencement, Profile),
    security_safeguards_duty(Profile, required_with_rule_6_minimum, _).
test(security_not_required_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(processor_now_fiduciary, Profile),
    security_safeguards_duty(Profile, not_required, _).
test(security_not_in_force_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(safeguards_only_in_force, Profile),
    security_safeguards_duty(Profile, not_in_force, _).
test(security_referral_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(fiduciary_unsure_without_day, Profile),
    security_safeguards_duty(Profile, needs_legal_review(_, _), _).
test(accuracy_required_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(accuracy_neither_likely, Profile),
    accuracy_duty(Profile, required, _).
test(accuracy_not_in_force_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(accuracy_decision_use, Profile),
    accuracy_duty(Profile, not_in_force, _).
test(erasure_other_law_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(bank_no_other_law, Profile),
    erasure_duty(Profile, retain_as_required_by_other_law, _).
test(erasure_not_yet_route_near_miss, fail) :-
    erasure_duty([attribute(section_8_7_in_force, true), attribute(acts_as_data_fiduciary, true), attribute(retention_necessary_for_compliance_with_law, false), attribute(consent_withdrawn, true), attribute(specified_purpose_no_longer_served, false), attribute(assessment_date, date(2026, 12, 1)), attribute(data_made_available_to_data_processor, false)], not_yet_required, _).
test(erasure_hold_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(cloud_processor_day_after_retention, Profile),
    erasure_duty(Profile, retain_until_minimum_retention_period_end, _).
test(erasure_processor_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(marketplace_after_sale, Profile),
    erasure_duty(Profile, erase_and_cause_data_processor_to_erase, _).
test(erasure_not_required_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(processor_now_fiduciary, Profile),
    erasure_duty(Profile, not_required, _).
test(deemed_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(social_media_on_period_end, Profile),
    third_schedule_deemed_no_longer_served(Profile, deemed_no_longer_served, _).
test(deemed_floor_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(e_commerce_day_after_deeming_floor, Profile),
    third_schedule_deemed_no_longer_served(Profile, not_yet_deemed, _).
test(gaming_threshold_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(gaming_at_threshold, Profile),
    third_schedule_deemed_no_longer_served(Profile, not_listed, _).
test(e_commerce_threshold_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(e_commerce_day_after_deeming_floor, Profile),
    third_schedule_deemed_no_longer_served(Profile, not_listed, _).
test(excepted_purpose_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(gaming_at_threshold, Profile),
    third_schedule_deemed_no_longer_served(Profile, not_listed, [cite(in_dpdp_rules_2025_r_8_1), cite(in_dpdp_rules_2025_sch_3)]).
test(deemed_not_in_force_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(processor_not_fiduciary, Profile),
    third_schedule_deemed_no_longer_served(Profile, not_in_force, _).
test(facade_rejected_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(empty_profile, Profile),
    dpdp_security_retention_status(Profile, profile_rejected).
test(facade_owed_route_near_miss, fail) :-
    dpdp_security_retention_profile_for(nothing_in_force, Profile),
    dpdp_security_retention_status(Profile, section_8_duty_owed).

cp_test_names([the_status_table_has_a_near_miss_atom, security_rule_6_route_positive, security_rule_6_route_near_miss_answer, security_not_required_route_positive, security_not_required_route_near_miss_answer, security_not_in_force_route_positive, security_not_in_force_route_near_miss_answer, security_referral_route_positive, security_referral_route_near_miss_answer, accuracy_required_route_positive, accuracy_required_route_near_miss_answer, accuracy_not_in_force_route_positive, erasure_other_law_route_positive, erasure_other_law_route_near_miss_answer, erasure_not_yet_route_positive, erasure_not_yet_route_near_miss_answer, erasure_hold_route_positive, erasure_hold_route_near_miss_answer, erasure_processor_route_positive, erasure_processor_route_near_miss_answer, erasure_not_required_route_positive, erasure_not_required_route_near_miss_answer, deemed_route_positive, deemed_route_near_miss_answer, deemed_floor_route_positive, deemed_floor_route_near_miss_answer, gaming_threshold_route_positive, gaming_threshold_route_near_miss_answer, e_commerce_threshold_route_positive, excepted_purpose_route_positive, deemed_not_in_force_route_positive, deemed_not_in_force_route_near_miss_answer, facade_rejected_route_positive, facade_rejected_route_near_miss_answer, facade_owed_route_positive, facade_owed_route_near_miss_answer]).
cp_test_fail_names([security_rule_6_route_near_miss, security_not_required_route_near_miss, security_not_in_force_route_near_miss, security_referral_route_near_miss, accuracy_required_route_near_miss, accuracy_not_in_force_route_near_miss, erasure_other_law_route_near_miss, erasure_not_yet_route_near_miss, erasure_hold_route_near_miss, erasure_processor_route_near_miss, erasure_not_required_route_near_miss, deemed_route_near_miss, deemed_floor_route_near_miss, gaming_threshold_route_near_miss, e_commerce_threshold_route_near_miss, excepted_purpose_route_near_miss, deemed_not_in_force_route_near_miss, facade_rejected_route_near_miss, facade_owed_route_near_miss]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
