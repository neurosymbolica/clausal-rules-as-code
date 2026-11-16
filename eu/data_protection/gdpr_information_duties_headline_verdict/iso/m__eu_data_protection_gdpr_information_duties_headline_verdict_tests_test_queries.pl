% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_queries, [gdpr_information_duties_headline_verdict_profile_keys/1, gdpr_information_duties_headline_verdict_what_if/4, gdpr_information_duties_headline_verdict_compliance_check/3, gdpr_information_duties_headline_verdict_obligations/2, gdpr_information_duties_headline_verdict_deadline/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_kernel, [gdpr_information_duties_headline_verdict_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [information_duty_verdict/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_fixtures, [gdpr_information_duties_headline_verdict_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_information_duties_headline_verdict_profile_keys(ProfileKeys),
    ProfileKeys == [personal_data_collected_from_data_subject, items_provided, items_data_subject_already_has, data_protection_officer_designated, processing_based_on_legitimate_interests, recipients_exist, transfer_intended, processing_based_on_consent, automated_decision_making_under_article_22, obtaining_date, provision_date, data_used_for_communication_with_data_subject, first_communication_date, disclosure_to_another_recipient_envisaged, first_disclosure_date, provided_within_reasonable_period, provision_impossible_or_disproportionate_effort, protective_measures_taken, obtaining_or_disclosure_laid_down_by_law, professional_secrecy_obligation_by_law, further_processing_for_another_purpose_intended, further_processing_start_date, further_processing_information_date, further_processing_items_provided, paragraph_2_information_relevant_to_further_processing, public_holidays].
test(profile_keys_are_twenty_six) :-
    gdpr_information_duties_headline_verdict_profile_keys(ProfileKeys),
    length(ProfileKeys, 26).
test(input_check_is_re_exported) :-
    gdpr_information_duties_headline_verdict_input_problems([attribute(no_such_key, true)], [unknown_key(no_such_key)]).
test(what_if_late_provision_flips_to_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    gdpr_information_duties_headline_verdict_what_if(Profile, provision_date, date(2026, 3, 3), Status),
    Status == ineligible.
test(what_if_unchanged_value_keeps_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    gdpr_information_duties_headline_verdict_what_if(Profile, provision_date, date(2026, 3, 2), Status),
    Status == eligible.
test(what_if_has_exactly_one_answer) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    findall(Status, gdpr_information_duties_headline_verdict_what_if(Profile, provision_date, date(2026, 3, 3), Status), Statuses),
    Statuses == [ineligible].
test(what_if_unsure_judgement_is_referred) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    gdpr_information_duties_headline_verdict_what_if(Profile, automated_decision_making_under_article_22, unsure, Status),
    Status == needs_legal_review(open_textured(automated_decision_making_under_article_22, cite(eu_reg_2016_679_art_13_2_f)), [inputs_relied_on([automated_decision_making_under_article_22 - unsure])]).
test(what_if_route_switch_changes_the_route) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    gdpr_information_duties_headline_verdict_what_if(Profile, personal_data_collected_from_data_subject, false, Status),
    Status == indeterminate([provision_impossible_or_disproportionate_effort]).
test(what_if_overrides_an_absent_key) :-
    gdpr_information_duties_headline_verdict_what_if([], personal_data_collected_from_data_subject, true, Status),
    Status == indeterminate([items_provided, items_data_subject_already_has, obtaining_date, provision_date, further_processing_for_another_purpose_intended]).
test(compliance_permitted_when_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    gdpr_information_duties_headline_verdict_compliance_check(Profile, proceed_with_processing, compliance(permitted, [cite(eu_reg_2016_679_art_13_1)])).
test(compliance_prohibited_when_ineligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_one_day_late, Profile),
    gdpr_information_duties_headline_verdict_compliance_check(Profile, proceed_with_processing, compliance(prohibited, [cite(eu_reg_2016_679_art_13_1)])).
test(compliance_passes_through_input_problems) :-
    gdpr_information_duties_headline_verdict_profile_for(input_unknown_key, Profile),
    gdpr_information_duties_headline_verdict_compliance_check(Profile, proceed_with_processing, input_problems([unknown_key(no_such_key)])).
test(compliance_passes_through_indeterminate) :-
    gdpr_information_duties_headline_verdict_compliance_check([], proceed_with_processing, indeterminate([personal_data_collected_from_data_subject|_])).
test(compliance_passes_through_referral) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_unsure_automated_decision, Profile),
    gdpr_information_duties_headline_verdict_compliance_check(Profile, proceed_with_processing, needs_legal_review(open_textured(automated_decision_making_under_article_22, _), _)).
test(compliance_has_exactly_one_answer) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_one_day_late, Profile),
    findall(Result, gdpr_information_duties_headline_verdict_compliance_check(Profile, proceed_with_processing, Result), Results),
    length(Results, 1).
test(obligations_none_when_eligible) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_on_time, Profile),
    gdpr_information_duties_headline_verdict_obligations(Profile, obligations([])).
test(obligations_name_the_missing_item) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_missing_statutory_item, Profile),
    gdpr_information_duties_headline_verdict_obligations(Profile, obligations([cite(eu_reg_2016_679_art_13_2_e)])).
test(obligations_name_the_timing_provision) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_communication_limb_late, Profile),
    gdpr_information_duties_headline_verdict_obligations(Profile, obligations([cite(eu_reg_2016_679_art_14_3_b)])).
test(obligations_pass_through_input_problems) :-
    gdpr_information_duties_headline_verdict_profile_for(input_wrong_type, Profile),
    gdpr_information_duties_headline_verdict_obligations(Profile, input_problems([wrong_type(items_provided)])).
test(deadline_satisfied_when_in_time) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_on_time_at_boundary, Profile),
    gdpr_information_duties_headline_verdict_deadline(Profile, deadline(satisfied, [])).
test(deadline_missed_names_the_limb) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_one_day_late, Profile),
    gdpr_information_duties_headline_verdict_deadline(Profile, deadline(missed, [cite(eu_reg_2016_679_art_14_3_a)])).
test(deadline_missed_on_art13) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_one_day_late, Profile),
    gdpr_information_duties_headline_verdict_deadline(Profile, deadline(missed, [cite(eu_reg_2016_679_art_13_1)])).
test(deadline_not_missed_when_only_an_item_is_missing) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_missing_statutory_item, Profile),
    gdpr_information_duties_headline_verdict_deadline(Profile, deadline(not_missed, [])).
test(deadline_agrees_with_the_headline) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_month_end_late, Profile),
    information_duty_verdict(Profile, ineligible, _),
    gdpr_information_duties_headline_verdict_deadline(Profile, deadline(missed, [cite(eu_reg_2016_679_art_14_3_a)])).

test(compliance_not_permitted_when_ineligible, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art13_one_day_late, Profile),
    gdpr_information_duties_headline_verdict_compliance_check(Profile, proceed_with_processing, compliance(permitted, _)).
test(deadline_in_time_is_not_missed, fail) :-
    gdpr_information_duties_headline_verdict_profile_for(art14_on_time_at_boundary, Profile),
    gdpr_information_duties_headline_verdict_deadline(Profile, deadline(missed, _)).

cp_test_names([profile_keys_are_the_contract_keys, profile_keys_are_twenty_six, input_check_is_re_exported, what_if_late_provision_flips_to_ineligible, what_if_unchanged_value_keeps_eligible, what_if_has_exactly_one_answer, what_if_unsure_judgement_is_referred, what_if_route_switch_changes_the_route, what_if_overrides_an_absent_key, compliance_permitted_when_eligible, compliance_prohibited_when_ineligible, compliance_passes_through_input_problems, compliance_passes_through_indeterminate, compliance_passes_through_referral, compliance_has_exactly_one_answer, obligations_none_when_eligible, obligations_name_the_missing_item, obligations_name_the_timing_provision, obligations_pass_through_input_problems, deadline_satisfied_when_in_time, deadline_missed_names_the_limb, deadline_missed_on_art13, deadline_not_missed_when_only_an_item_is_missing, deadline_agrees_with_the_headline]).
cp_test_fail_names([compliance_not_permitted_when_ineligible, deadline_in_time_is_not_missed]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
