% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_gdpr_impact_assessment_assessment_duty_stated_risk, [gdpr_impact_assessment_assessment_duty_stated_risk_status/2, gdpr_impact_assessment_assessment_duty_stated_risk_status_values/1, decide_impact_assessment_duty/2, impact_assessment_officer_advice/2]).
:- use_module(m__eu_data_protection_gdpr_impact_assessment_assessment_duty_stated_risk_fixtures, [gdpr_impact_assessment_assessment_duty_stated_risk_profile_for/2]).

route_status(Subject, Status) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(Subject, Profile),
    gdpr_impact_assessment_assessment_duty_stated_risk_status(Profile, Status).

route_basis(Subject, Basis) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(Subject, Profile),
    decide_impact_assessment_duty(Profile, impact_assessment_verdict(_, [Basis], _, _, _, _)).

officer_route(Subject, Status) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(Subject, Profile),
    impact_assessment_officer_advice(Profile, officer_advice_verdict(Status, _)).

test(the_status_table_holds_both_final_atoms) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_status_values([required, not_required]).
test(profiling_with_legal_effects_is_required) :-
    route_status(profiling_with_legal_effects_complete, required),
    route_basis(profiling_with_legal_effects_complete, art35_3_a_profiling_with_significant_decisions).
test(profiling_without_legal_effects_is_not_required) :-
    route_status(profiling_without_legal_effects, not_required).
test(large_scale_health_data_is_required) :-
    route_status(large_scale_health_data_no_assessment, required),
    route_basis(large_scale_health_data_no_assessment, art35_3_b_large_scale_sensitive_data).
test(small_scale_health_data_is_not_required) :-
    route_status(small_scale_health_data, not_required).
test(systematic_public_monitoring_is_required) :-
    route_status(public_area_monitoring_missing_measures, required),
    route_basis(public_area_monitoring_missing_measures, art35_3_c_public_area_monitoring).
test(unsystematic_public_monitoring_is_not_required) :-
    route_status(public_area_monitoring_not_systematic, not_required).
test(the_national_list_requires_it) :-
    route_status(national_list_item_de_dsk, required),
    route_basis(national_list_item_de_dsk, art35_4_national_list).
test(off_the_national_list_is_not_required) :-
    route_status(national_list_attested_false, not_required).
test(stated_high_risk_is_required) :-
    route_status(stated_high_risk, required),
    route_basis(stated_high_risk, art35_1_high_risk).
test(no_stated_high_risk_is_not_required) :-
    route_status(high_risk_not_stated, not_required),
    route_basis(high_risk_not_stated, no_requirement_triggered).
test(the_exemption_list_removes_the_high_risk_path) :-
    route_status(exempt_list_fr_cnil, not_required),
    route_basis(exempt_list_fr_cnil, art35_5_national_list_exemption).
test(off_the_exemption_list_the_high_risk_path_stands) :-
    route_status(exempt_list_attested_false, required).
test(the_general_assessment_exemption_applies) :-
    route_status(general_assessment_exemption, not_required),
    route_basis(general_assessment_exemption, art35_10_general_assessment_exemption).
test(a_member_state_requirement_restores_the_duty) :-
    route_status(member_state_requires_assessment_anyway, required),
    route_basis(member_state_requires_assessment_anyway, art35_3_a_profiling_with_significant_decisions).
test(an_absent_member_state_decision_is_referred) :-
    route_status(member_state_decision_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_35_10), cite(member_state_decision_requiring_impact_assessment_before_processing)), _)).
test(a_refused_member_state_decision_settles_the_exemption) :-
    route_status(member_state_decision_refused, not_required).
test(a_missing_profiling_flag_is_indeterminate) :-
    route_status(missing_profiling_flag, indeterminate([automated_evaluation_including_profiling])).
test(a_supplied_profiling_flag_is_required) :-
    route_status(profiling_flag_supplied, required).
test(an_unsure_large_scale_is_referred) :-
    route_status(large_scale_unsure, needs_legal_review(open_textured(processing_on_large_scale, cite(eu_reg_2016_679_art_35_3_b)), _)).
test(a_stated_large_scale_is_required) :-
    route_status(large_scale_stated, required).
test(an_unknown_legitimate_interest_is_named) :-
    route_status(legitimate_interest_unknown, indeterminate([legitimate_interest_pursued])).
test(no_legitimate_interest_is_required_and_complete) :-
    gdpr_impact_assessment_assessment_duty_stated_risk_profile_for(legitimate_interest_not_pursued, Profile),
    decide_impact_assessment_duty(Profile, impact_assessment_verdict(required, [art35_4_national_list], [], _, [cite(eu_reg_2016_679_art_35_4)], [])).
test(a_duplicate_and_unknown_key_are_input_problems) :-
    route_status(duplicate_and_unknown_keys, input_problems([duplicate_key(processing_on_large_scale), unknown_key(colour)])).
test(the_well_formed_control_is_decided) :-
    route_status(well_formed_control, not_required).
test(officer_advice_sought_is_met) :-
    officer_route(officer_advice_sought, met).
test(officer_not_consulted_is_not_met) :-
    officer_route(officer_not_consulted, not_met).
test(no_officer_designated_is_not_applicable) :-
    officer_route(no_officer_designated, not_applicable).
test(a_designated_officer_with_unknown_advice_names_the_advice) :-
    officer_route(officer_designated_advice_unknown, indeterminate([data_protection_officer_advice_sought])).
test(a_silent_officer_profile_names_the_carried_out_key) :-
    officer_route(officer_both_absent, indeterminate([impact_assessment_carried_out])).
test(no_assessment_carried_out_is_not_applicable) :-
    officer_route(no_assessment_carried_out, not_applicable).

test(profiling_without_legal_effects_is_not_required_only, fail) :-
    route_status(profiling_without_legal_effects, required).
test(small_scale_health_data_is_never_required, fail) :-
    route_status(small_scale_health_data, required).
test(unsystematic_public_monitoring_is_never_required, fail) :-
    route_status(public_area_monitoring_not_systematic, required).
test(off_the_national_list_is_never_required, fail) :-
    route_status(national_list_attested_false, required).
test(no_stated_high_risk_is_never_required, fail) :-
    route_status(high_risk_not_stated, required).
test(off_the_exemption_list_is_never_exempt, fail) :-
    route_status(exempt_list_attested_false, not_required).
test(a_member_state_requirement_is_never_exempt, fail) :-
    route_status(member_state_requires_assessment_anyway, not_required).
test(a_refused_member_state_decision_is_not_referred, fail) :-
    route_status(member_state_decision_refused, needs_legal_review(_, _)).
test(a_supplied_profiling_flag_is_not_indeterminate, fail) :-
    route_status(profiling_flag_supplied, indeterminate(_)).
test(a_stated_large_scale_is_not_referred, fail) :-
    route_status(large_scale_stated, needs_legal_review(_, _)).
test(no_legitimate_interest_is_not_indeterminate, fail) :-
    route_status(legitimate_interest_not_pursued, indeterminate(_)).
test(the_well_formed_control_has_no_input_problem, fail) :-
    route_status(well_formed_control, input_problems(_)).
test(officer_not_consulted_is_never_met, fail) :-
    officer_route(officer_not_consulted, met).
test(a_designated_officer_is_never_not_applicable, fail) :-
    officer_route(officer_designated_advice_unknown, not_applicable).
test(no_assessment_carried_out_is_never_indeterminate, fail) :-
    officer_route(no_assessment_carried_out, indeterminate(_)).

cp_test_names([the_status_table_holds_both_final_atoms, profiling_with_legal_effects_is_required, profiling_without_legal_effects_is_not_required, large_scale_health_data_is_required, small_scale_health_data_is_not_required, systematic_public_monitoring_is_required, unsystematic_public_monitoring_is_not_required, the_national_list_requires_it, off_the_national_list_is_not_required, stated_high_risk_is_required, no_stated_high_risk_is_not_required, the_exemption_list_removes_the_high_risk_path, off_the_exemption_list_the_high_risk_path_stands, the_general_assessment_exemption_applies, a_member_state_requirement_restores_the_duty, an_absent_member_state_decision_is_referred, a_refused_member_state_decision_settles_the_exemption, a_missing_profiling_flag_is_indeterminate, a_supplied_profiling_flag_is_required, an_unsure_large_scale_is_referred, a_stated_large_scale_is_required, an_unknown_legitimate_interest_is_named, no_legitimate_interest_is_required_and_complete, a_duplicate_and_unknown_key_are_input_problems, the_well_formed_control_is_decided, officer_advice_sought_is_met, officer_not_consulted_is_not_met, no_officer_designated_is_not_applicable, a_designated_officer_with_unknown_advice_names_the_advice, a_silent_officer_profile_names_the_carried_out_key, no_assessment_carried_out_is_not_applicable]).
cp_test_fail_names([profiling_without_legal_effects_is_not_required_only, small_scale_health_data_is_never_required, unsystematic_public_monitoring_is_never_required, off_the_national_list_is_never_required, no_stated_high_risk_is_never_required, off_the_exemption_list_is_never_exempt, a_member_state_requirement_is_never_exempt, a_refused_member_state_decision_is_not_referred, a_supplied_profiling_flag_is_not_indeterminate, a_stated_large_scale_is_not_referred, no_legitimate_interest_is_not_indeterminate, the_well_formed_control_has_no_input_problem, officer_not_consulted_is_never_met, a_designated_officer_is_never_not_applicable, no_assessment_carried_out_is_never_indeterminate]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
