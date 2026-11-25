% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_policies_and_risk_management_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_policies_and_risk_management_queries, [dora_rts_policies_and_risk_management_profile_keys/1, dora_rts_policies_and_risk_management_what_if/4, dora_rts_policies_and_risk_management_compliance_check/4]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_kernel, [dora_rts_policies_and_risk_management_input_problems/2]).
:- use_module(m__eu_dora_rts_policies_and_risk_management_fixtures, [dora_rts_policies_and_risk_management_profile_for/2]).

check_answers(Subject, Action, Answers) :-
    dora_rts_policies_and_risk_management_profile_for(Subject, Profile),
    findall(Verdict - Citations, dora_rts_policies_and_risk_management_compliance_check(Profile, Action, Verdict, Citations), Answers).

test(profile_keys_are_the_contract_keys) :-
    dora_rts_policies_and_risk_management_profile_keys(ProfileKeys),
    ProfileKeys == [financial_entity_is_article_16_1_entity, size_risk_profile_and_complexity_taken_into_account, ict_security_policies_embedded_in_ict_risk_management_framework, security_policies_ensure_security_of_networks, security_policies_contain_safeguards_against_intrusions_and_data_misuse, security_policies_preserve_availability_authenticity_integrity_and_confidentiality_of_data, security_policies_guarantee_accurate_and_prompt_data_transmission, security_policies_aligned_to_information_security_objectives, security_policies_indicate_date_of_management_body_approval, security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, security_policies_specify_staff_responsibilities_for_ict_security, security_policies_specify_consequences_of_staff_non_compliance, security_policies_list_documentation_to_be_maintained, security_policies_specify_segregation_of_duties_arrangements, security_policies_consider_leading_practices_and_standards, security_policies_identify_roles_for_development_implementation_and_maintenance, security_policies_reviewed_in_accordance_with_article_6_5, security_policies_take_material_changes_into_account, ict_risk_management_policies_and_procedures_developed_documented_and_implemented, risk_management_policies_indicate_approval_of_risk_tolerance_level, risk_management_policies_contain_risk_assessment_procedure_and_methodology, risk_management_policies_contain_risk_treatment_procedure, risk_management_policies_contain_residual_risk_provisions, risk_management_policies_contain_risk_monitoring_provisions, risk_management_policies_contain_process_for_strategy_changes, risk_treatment_procedure_ensures_monitoring_of_treatment_effectiveness, risk_treatment_procedure_ensures_assessment_of_risk_tolerance_attainment, risk_treatment_procedure_ensures_assessment_of_corrective_actions].
test(the_reexported_input_check_names_an_unknown_key) :-
    dora_rts_policies_and_risk_management_profile_for(unknown_key_present, Profile),
    dora_rts_policies_and_risk_management_input_problems(Profile, [unknown_key(colour)]).
test(the_reexported_input_check_passes_a_clean_profile) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    dora_rts_policies_and_risk_management_input_problems(Profile, []).
test(what_if_an_unanswered_duty_is_performed) :-
    dora_rts_policies_and_risk_management_profile_for(duty_unanswered, Profile),
    dora_rts_policies_and_risk_management_what_if(Profile, security_policies_contain_safeguards_against_intrusions_and_data_misuse, true, complete).
test(what_if_an_unanswered_duty_is_not_performed) :-
    dora_rts_policies_and_risk_management_profile_for(duty_unanswered, Profile),
    dora_rts_policies_and_risk_management_what_if(Profile, security_policies_contain_safeguards_against_intrusions_and_data_misuse, false, incomplete).
test(what_if_the_entity_is_an_article_16_1_entity) :-
    dora_rts_policies_and_risk_management_profile_for(gate_unanswered, Profile),
    dora_rts_policies_and_risk_management_what_if(Profile, financial_entity_is_article_16_1_entity, true, simplified_framework_entity).
test(certify_all_is_permitted_when_complete) :-
    check_answers(all_duties_performed, certify_all_duties, Answers),
    Answers == [permitted - [cite(eu_reg_2024_1774_art_1), cite(eu_reg_2024_1774_art_2_1), cite(eu_reg_2024_1774_art_2_2), cite(eu_reg_2024_1774_art_3)]].
test(certify_all_is_prohibited_when_incomplete) :-
    check_answers(one_duty_not_performed, certify_all_duties, Answers),
    Answers == [prohibited - [cite(eu_reg_2024_1774_art_1), cite(eu_reg_2024_1774_art_2_1), cite(eu_reg_2024_1774_art_2_2), cite(eu_reg_2024_1774_art_3)]].
test(certify_all_is_prohibited_for_an_article_16_1_entity) :-
    check_answers(simplified_framework_entity_with_duties_performed, certify_all_duties, Answers),
    Answers == [prohibited - [cite(eu_reg_2022_2554_art_16_1)]].
test(certify_all_asks_an_absent_duty) :-
    check_answers(duty_unanswered, certify_all_duties, Answers),
    Answers == [indeterminate([security_policies_contain_safeguards_against_intrusions_and_data_misuse]) - []].
test(certify_all_refers_an_unsure_duty) :-
    check_answers(duty_judgement_unsure, certify_all_duties, [needs_legal_review(open_textured(security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, cite(eu_reg_2024_1774_art_2_2_c)), [inputs_relied_on(_Pairs)]) - []]).
test(certify_all_reports_input_problems) :-
    check_answers(unknown_key_present, certify_all_duties, Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(certify_a_performed_duty) :-
    check_answers(all_duties_performed, certify_duty(monitoring_of_treatment_effectiveness), Answers),
    Answers == [permitted - [cite(eu_reg_2024_1774_art_3_a_run2)]].
test(certify_a_duty_not_performed) :-
    check_answers(second_paragraph_duty_not_performed, certify_duty(monitoring_of_treatment_effectiveness), Answers),
    Answers == [prohibited - [cite(eu_reg_2024_1774_art_3_a_run2)]].
test(certify_another_duty_beside_a_failing_one) :-
    check_answers(second_paragraph_duty_not_performed, certify_duty(network_security), Answers),
    Answers == [permitted - [cite(eu_reg_2024_1774_art_2_1_a)]].
test(certify_an_unanswered_duty) :-
    check_answers(duty_unanswered, certify_duty(intrusion_and_data_misuse_safeguards), Answers),
    Answers == [indeterminate([security_policies_contain_safeguards_against_intrusions_and_data_misuse]) - []].
test(certify_an_unsure_duty) :-
    check_answers(duty_judgement_unsure, certify_duty(implementation_and_exception_indicators), Answers),
    Answers = [needs_legal_review(open_textured(security_policies_contain_indicators_and_measures_for_implementation_and_exceptions, cite(eu_reg_2024_1774_art_2_2_c)), [inputs_relied_on(Pairs)]) - []],
    length(Pairs, 28).
test(certify_a_duty_with_the_gate_absent) :-
    check_answers(gate_unanswered, certify_duty(network_security), Answers),
    Answers == [indeterminate([financial_entity_is_article_16_1_entity]) - []].
test(certify_a_duty_for_an_article_16_1_entity) :-
    check_answers(simplified_framework_entity_with_duties_performed, certify_duty(network_security), Answers),
    Answers == [prohibited - [cite(eu_reg_2022_2554_art_16_1)]].
test(certify_a_duty_with_input_problems) :-
    check_answers(unknown_key_present, certify_duty(network_security), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].

test(what_if_not_performed_is_not_complete, fail) :-
    dora_rts_policies_and_risk_management_profile_for(duty_unanswered, Profile),
    dora_rts_policies_and_risk_management_what_if(Profile, security_policies_contain_safeguards_against_intrusions_and_data_misuse, false, complete).
test(certify_all_is_not_permitted_when_incomplete, fail) :-
    dora_rts_policies_and_risk_management_profile_for(one_duty_not_performed, Profile),
    dora_rts_policies_and_risk_management_compliance_check(Profile, certify_all_duties, permitted, _Citations).
test(certify_an_unknown_duty_has_no_answer, fail) :-
    dora_rts_policies_and_risk_management_profile_for(all_duties_performed, Profile),
    dora_rts_policies_and_risk_management_compliance_check(Profile, certify_duty(colour), _Verdict, _Citations).

cp_test_names([profile_keys_are_the_contract_keys, the_reexported_input_check_names_an_unknown_key, the_reexported_input_check_passes_a_clean_profile, what_if_an_unanswered_duty_is_performed, what_if_an_unanswered_duty_is_not_performed, what_if_the_entity_is_an_article_16_1_entity, certify_all_is_permitted_when_complete, certify_all_is_prohibited_when_incomplete, certify_all_is_prohibited_for_an_article_16_1_entity, certify_all_asks_an_absent_duty, certify_all_refers_an_unsure_duty, certify_all_reports_input_problems, certify_a_performed_duty, certify_a_duty_not_performed, certify_another_duty_beside_a_failing_one, certify_an_unanswered_duty, certify_an_unsure_duty, certify_a_duty_with_the_gate_absent, certify_a_duty_for_an_article_16_1_entity, certify_a_duty_with_input_problems]).
cp_test_fail_names([what_if_not_performed_is_not_complete, certify_all_is_not_permitted_when_incomplete, certify_an_unknown_duty_has_no_answer]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
