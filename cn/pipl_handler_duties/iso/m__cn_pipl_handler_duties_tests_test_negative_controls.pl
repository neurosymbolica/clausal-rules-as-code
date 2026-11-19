% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_handler_duties_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__cn_pipl_handler_duties_pipl_handler_duties, [duty_status/4, pipl_handler_duties_status/2, pipl_handler_duties_status_values/1]).
:- use_module(m__cn_pipl_handler_duties_fixtures, [pipl_handler_duties_profile_for/2]).

answer(Subject, Duty, Result) :-
    pipl_handler_duties_profile_for(Subject, Profile),
    duty_status(Duty, Profile, Result, _).

facade(Subject, Status) :-
    pipl_handler_duties_profile_for(Subject, Profile),
    pipl_handler_duties_status(Profile, Status).

test(art_74_day_of_entry_into_force_is_owed) :-
    answer(day_of_entry_into_force, compliance_measures, required).
test(art_74_day_before_is_not_in_force) :-
    answer(day_before_entry_into_force, compliance_measures, not_in_force).
test(art_74_months_compare_as_numbers) :-
    answer(september_before_entry_into_force, compliance_measures, not_in_force).
test(pinned_text_unamended_is_owed) :-
    answer(handler_only, compliance_audit, required).
test(pinned_text_amended_is_not_applicable) :-
    answer(amended_text, compliance_audit, pinned_text_not_applicable).
test(handler_owes_the_audit) :-
    answer(handler_only, compliance_audit, required).
test(non_handler_owes_no_audit) :-
    answer(not_a_handler, compliance_audit, not_required).
test(unsure_handler_is_referred_not_owed) :-
    answer(handler_unsure, compliance_measures, needs_legal_review(open_textured(decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1)), _)).
test(art_52_quantity_reached_owes_contact_details) :-
    answer(officer_quantity_reached, officer_contact_details, required).
test(art_52_quantity_not_reached_owes_none) :-
    answer(officer_quantity_not_reached, officer_contact_details, not_required).
test(art_53_offshore_owes_a_representative) :-
    answer(offshore_services_handler, china_representative, required).
test(art_53_onshore_owes_none) :-
    answer(onshore_services_handler, china_representative, not_required).
test(art_3_2_other_case_owes_a_representative) :-
    answer(offshore_other_case, china_representative, required).
test(art_3_2_no_case_owes_none) :-
    answer(offshore_no_case, china_representative, not_required).
test(art_55_automated_decisions_need_an_assessment) :-
    answer(automated_decision_handler, impact_assessment, required_in_advance).
test(art_55_no_occasion_needs_none) :-
    answer(no_assessment_occasion, impact_assessment, not_required).
test(art_56_2_retention_owed_with_an_occasion) :-
    answer(automated_decision_handler, assessment_record_retention, required_for_at_least_three_years).
test(art_56_2_retention_not_owed_without_one) :-
    answer(no_assessment_occasion, assessment_record_retention, not_required).
test(art_57_1_incident_needs_immediate_remedies) :-
    answer(incident_harm_not_avoided, breach_remedial_measures, required_immediately).
test(art_57_1_incident_needs_department_notice) :-
    answer(incident_harm_not_avoided, breach_notice_to_department, required).
test(art_57_1_no_incident_needs_no_remedies) :-
    answer(no_incident, breach_remedial_measures, not_required).
test(art_57_2_harm_not_avoided_requires_notice) :-
    answer(incident_harm_not_avoided, breach_notice_to_individuals, required).
test(art_57_2_harm_avoided_permits_omission) :-
    answer(incident_harm_avoided, breach_notice_to_individuals, notice_may_be_omitted).
test(art_57_2_department_requirement_requires_notice) :-
    answer(incident_department_required, breach_notice_to_individuals, required).
test(art_58_important_platform_owes_obligations) :-
    answer(important_platform, large_platform_obligations, required).
test(art_58_ordinary_platform_owes_none) :-
    answer(ordinary_platform, large_platform_obligations, not_required).
test(art_58_unsure_platform_is_referred) :-
    answer(platform_unsure, large_platform_obligations, needs_legal_review(open_textured(important_platform_handler, cite(cn_pipl_art_58_p1)), _)).
test(art_59_entrusted_party_owes_safeguards) :-
    answer(entrusted_party, entrusted_party_safeguards, required).
test(art_59_not_entrusted_owes_none) :-
    answer(no_duties_at_all, entrusted_party_safeguards, not_required).
test(input_unknown_key_gives_problems) :-
    answer(unknown_key_profile, compliance_audit, input_problems([unknown_key(colour)])).
test(input_repeated_key_gives_problems) :-
    answer(repeated_key, compliance_audit, input_problems([duplicate_key(decides_purposes_and_means)])).
test(the_status_table_has_a_near_miss_atom) :-
    pipl_handler_duties_status_values(StatusValues),
    StatusValues = [_, _|_].
test(facade_entrusted_party_has_duties_owed) :-
    facade(entrusted_party, duties_owed).
test(facade_no_duties_at_all_has_none) :-
    facade(no_duties_at_all, no_duties_owed).
test(facade_unstated_entrustment_is_pending) :-
    facade(not_a_handler, duties_pending).

test(art_74_day_before_is_not_owed, fail) :-
    answer(day_before_entry_into_force, compliance_measures, required).
test(art_74_day_of_entry_into_force_is_not_not_in_force, fail) :-
    answer(day_of_entry_into_force, compliance_measures, not_in_force).
test(pinned_text_amended_is_not_owed, fail) :-
    answer(amended_text, compliance_audit, required).
test(non_handler_audit_is_not_required, fail) :-
    answer(not_a_handler, compliance_audit, required).
test(unsure_handler_is_not_owed, fail) :-
    answer(handler_unsure, compliance_measures, required).
test(art_52_quantity_not_reached_is_not_owed, fail) :-
    answer(officer_quantity_not_reached, protection_officer, required).
test(art_53_onshore_is_not_owed, fail) :-
    answer(onshore_services_handler, china_representative, required).
test(art_3_2_no_case_is_not_owed, fail) :-
    answer(offshore_no_case, china_representative, required).
test(art_55_no_occasion_is_not_required_in_advance, fail) :-
    answer(no_assessment_occasion, impact_assessment, required_in_advance).
test(art_56_2_retention_without_occasion_is_not_owed, fail) :-
    answer(no_assessment_occasion, assessment_record_retention, required_for_at_least_three_years).
test(art_57_1_no_incident_is_not_required_immediately, fail) :-
    answer(no_incident, breach_remedial_measures, required_immediately).
test(art_57_1_no_incident_needs_no_department_notice, fail) :-
    answer(no_incident, breach_notice_to_department, required).
test(art_57_2_harm_avoided_does_not_require_notice, fail) :-
    answer(incident_harm_avoided, breach_notice_to_individuals, required).
test(art_57_2_department_requirement_is_not_omission, fail) :-
    answer(incident_department_required, breach_notice_to_individuals, notice_may_be_omitted).
test(art_58_ordinary_platform_is_not_owed, fail) :-
    answer(ordinary_platform, large_platform_obligations, required).
test(art_58_unsure_platform_is_not_owed, fail) :-
    answer(platform_unsure, large_platform_obligations, required).
test(art_59_not_entrusted_is_not_owed, fail) :-
    answer(no_duties_at_all, entrusted_party_safeguards, required).
test(input_unknown_key_gives_no_final_answer, fail) :-
    answer(unknown_key_profile, compliance_audit, required).
test(facade_no_duties_at_all_is_not_owed, fail) :-
    facade(no_duties_at_all, duties_owed).
test(facade_unstated_entrustment_is_not_no_duties, fail) :-
    facade(not_a_handler, no_duties_owed).

cp_test_names([art_74_day_of_entry_into_force_is_owed, art_74_day_before_is_not_in_force, art_74_months_compare_as_numbers, pinned_text_unamended_is_owed, pinned_text_amended_is_not_applicable, handler_owes_the_audit, non_handler_owes_no_audit, unsure_handler_is_referred_not_owed, art_52_quantity_reached_owes_contact_details, art_52_quantity_not_reached_owes_none, art_53_offshore_owes_a_representative, art_53_onshore_owes_none, art_3_2_other_case_owes_a_representative, art_3_2_no_case_owes_none, art_55_automated_decisions_need_an_assessment, art_55_no_occasion_needs_none, art_56_2_retention_owed_with_an_occasion, art_56_2_retention_not_owed_without_one, art_57_1_incident_needs_immediate_remedies, art_57_1_incident_needs_department_notice, art_57_1_no_incident_needs_no_remedies, art_57_2_harm_not_avoided_requires_notice, art_57_2_harm_avoided_permits_omission, art_57_2_department_requirement_requires_notice, art_58_important_platform_owes_obligations, art_58_ordinary_platform_owes_none, art_58_unsure_platform_is_referred, art_59_entrusted_party_owes_safeguards, art_59_not_entrusted_owes_none, input_unknown_key_gives_problems, input_repeated_key_gives_problems, the_status_table_has_a_near_miss_atom, facade_entrusted_party_has_duties_owed, facade_no_duties_at_all_has_none, facade_unstated_entrustment_is_pending]).
cp_test_fail_names([art_74_day_before_is_not_owed, art_74_day_of_entry_into_force_is_not_not_in_force, pinned_text_amended_is_not_owed, non_handler_audit_is_not_required, unsure_handler_is_not_owed, art_52_quantity_not_reached_is_not_owed, art_53_onshore_is_not_owed, art_3_2_no_case_is_not_owed, art_55_no_occasion_is_not_required_in_advance, art_56_2_retention_without_occasion_is_not_owed, art_57_1_no_incident_is_not_required_immediately, art_57_1_no_incident_needs_no_department_notice, art_57_2_harm_avoided_does_not_require_notice, art_57_2_department_requirement_is_not_omission, art_58_ordinary_platform_is_not_owed, art_58_unsure_platform_is_not_owed, art_59_not_entrusted_is_not_owed, input_unknown_key_gives_no_final_answer, facade_no_duties_at_all_is_not_owed, facade_unstated_entrustment_is_not_no_duties]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
