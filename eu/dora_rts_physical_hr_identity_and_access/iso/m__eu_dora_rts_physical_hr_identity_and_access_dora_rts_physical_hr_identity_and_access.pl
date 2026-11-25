% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_physical_hr_identity_and_access_dora_rts_physical_hr_identity_and_access, [physical_hr_identity_and_access_duties_required/3, physical_hr_identity_and_access_duties_complete/3, physical_hr_identity_and_access_duties_outstanding/3, decide_dora_rts_physical_hr_identity_and_access/2, dora_rts_physical_hr_identity_and_access_status/2, dora_rts_physical_hr_identity_and_access_checklist/2, dora_rts_physical_hr_identity_and_access_decision_resolvable/1, dora_rts_physical_hr_identity_and_access_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys/2, pairs_values/2]).
:- use_module(library(reif), [(=)/3]).
:- use_module(clausal_lists_extra, [last/2, clausal_msort/2]).
:- use_module(library(reif), [if_/3, memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_dora_rts_physical_hr_identity_and_access_kernel, [dora_rts_physical_hr_identity_and_access_input_problems/2]).
:- use_module(m__eu_dora_rts_physical_hr_identity_and_access_citations, [implements/1]).

dora_rts_physical_hr_identity_and_access_status_values([complete, incomplete, simplified_framework_entity]).

fixed_citations([cite(eu_reg_2024_1774_art_18_1), cite(eu_reg_2024_1774_art_18_2), cite(eu_reg_2024_1774_art_19), cite(eu_reg_2024_1774_art_20_1), cite(eu_reg_2024_1774_art_20_2), cite(eu_reg_2024_1774_art_21)]).

duty(physical_and_environmental_security_policy, physical_and_environmental_security_policy_specified_documented_and_implemented, [cite(eu_reg_2024_1774_art_18_1)], cite(eu_reg_2024_1774_art_18_1), physical_and_environmental_security_policy_unclear, cite(eu_reg_2024_1774_art_18_1)).
duty(physical_security_policy_design_basis, physical_security_policy_designed_in_light_of_threat_landscape_classification_and_risk_profile, [cite(eu_reg_2024_1774_art_18_1)], cite(eu_reg_2024_1774_art_18_1), physical_security_policy_design_basis_unclear, cite(eu_reg_2024_1774_art_18_1)).
duty(reference_to_physical_access_controls_section, physical_security_policy_refers_to_section_on_physical_access_controls, [cite(eu_reg_2024_1774_art_18_2_a)], cite(eu_reg_2024_1774_art_18_2), reference_to_physical_access_controls_section_unclear, cite(eu_reg_2024_1774_art_18_2_a)).
duty(protection_of_premises_data_centres_and_sensitive_areas, physical_security_policy_contains_measures_protecting_premises_data_centres_and_sensitive_areas, [cite(eu_reg_2024_1774_art_18_2_b)], cite(eu_reg_2024_1774_art_18_2), protection_of_premises_data_centres_and_sensitive_areas_unclear, cite(eu_reg_2024_1774_art_18_2_b)).
duty(securing_of_ict_assets_within_and_outside_premises, physical_security_policy_contains_measures_securing_ict_assets_within_and_outside_premises, [cite(eu_reg_2024_1774_art_18_2_c)], cite(eu_reg_2024_1774_art_18_2), securing_of_ict_assets_within_and_outside_premises_unclear, cite(eu_reg_2024_1774_art_18_2_c)).
duty(appropriate_maintenance_of_assets_and_access_control_devices, physical_security_policy_contains_measures_of_appropriate_maintenance, [cite(eu_reg_2024_1774_art_18_2_d)], cite(eu_reg_2024_1774_art_18_2), appropriate_maintenance_of_assets_and_access_control_devices_unclear, cite(eu_reg_2024_1774_art_18_2_d)).
duty(clear_desk_policy_for_papers, physical_security_policy_contains_clear_desk_policy_for_papers, [cite(eu_reg_2024_1774_art_18_2_e_i)], cite(eu_reg_2024_1774_art_18_2), clear_desk_policy_for_papers_unclear, cite(eu_reg_2024_1774_art_18_2_e_i)).
duty(clear_screen_policy, physical_security_policy_contains_clear_screen_policy_for_information_processing_facilities, [cite(eu_reg_2024_1774_art_18_2_e_ii)], cite(eu_reg_2024_1774_art_18_2), clear_screen_policy_unclear, cite(eu_reg_2024_1774_art_18_2_e_ii)).
duty(protection_of_unattended_ict_assets, physical_security_policy_contains_measures_protecting_unattended_ict_assets, [cite(eu_reg_2024_1774_art_18_2)], cite(eu_reg_2024_1774_art_18_2), protection_of_unattended_ict_assets_unclear, cite(eu_reg_2024_1774_art_18_2)).
duty(ict_security_responsibilities, human_resource_policy_identifies_and_assigns_ict_security_responsibilities, [cite(eu_reg_2024_1774_art_19_a)], cite(eu_reg_2024_1774_art_19), ict_security_responsibilities_unclear, cite(eu_reg_2024_1774_art_19_a)).
duty(staff_informed_of_and_adhering_to_ict_security_policies, human_resource_policy_requires_staff_to_be_informed_of_and_adhere_to_ict_security_policies, [cite(eu_reg_2024_1774_art_19_b_i)], cite(eu_reg_2024_1774_art_19), staff_informed_of_and_adhering_to_ict_security_policies_unclear, cite(eu_reg_2024_1774_art_19_b_i)).
duty(staff_aware_of_reporting_channels, human_resource_policy_requires_staff_to_be_aware_of_reporting_channels, [cite(eu_reg_2024_1774_art_19_b_ii)], cite(eu_reg_2024_1774_art_19), staff_aware_of_reporting_channels_unclear, cite(eu_reg_2024_1774_art_19_b_ii)).
duty(return_of_assets_upon_termination_of_employment, human_resource_policy_requires_staff_to_return_assets_upon_termination_of_employment, [cite(eu_reg_2024_1774_art_19_b_iii)], cite(eu_reg_2024_1774_art_19), return_of_assets_upon_termination_of_employment_unclear, cite(eu_reg_2024_1774_art_19_b_iii)).
duty(identity_management_policies_and_procedures, identity_management_policies_and_procedures_developed_documented_and_implemented, [cite(eu_reg_2024_1774_art_20_1)], cite(eu_reg_2024_1774_art_20_1), identity_management_policies_and_procedures_unclear, cite(eu_reg_2024_1774_art_20_1)).
duty(unique_identity_for_each_user_account, identity_management_assigns_unique_identity_corresponding_to_unique_user_account, [cite(eu_reg_2024_1774_art_20_2_a)], cite(eu_reg_2024_1774_art_20_2), unique_identity_for_each_user_account_unclear, cite(eu_reg_2024_1774_art_20_2_a)).
duty(identity_and_account_lifecycle_management_process, identity_management_contains_lifecycle_management_process_for_identities_and_accounts, [cite(eu_reg_2024_1774_art_20_2_b)], cite(eu_reg_2024_1774_art_20_2), identity_and_account_lifecycle_management_process_unclear, cite(eu_reg_2024_1774_art_20_2_b)).
duty(records_of_identity_assignments, records_of_all_identity_assignments_maintained_and_kept, [cite(eu_reg_2024_1774_art_20_2)], cite(eu_reg_2024_1774_art_20_2), records_of_identity_assignments_unclear, cite(eu_reg_2024_1774_art_20_2)).
duty(automated_identity_lifecycle_solutions, automated_solutions_for_lifecycle_identity_management_deployed_where_feasible_and_appropriate, [cite(eu_reg_2024_1774_art_20_2)], cite(eu_reg_2024_1774_art_20_2), automated_identity_lifecycle_solutions_unclear, cite(eu_reg_2024_1774_art_20_2)).
duty(access_control_policy, access_control_policy_developed_documented_and_implemented, [cite(eu_reg_2024_1774_art_21)], cite(eu_reg_2024_1774_art_21), access_control_policy_unclear, cite(eu_reg_2024_1774_art_21)).
duty(need_to_know_and_least_privilege_access_rights, access_control_policy_assigns_access_rights_on_need_to_know_need_to_use_and_least_privilege, [cite(eu_reg_2024_1774_art_21_a)], cite(eu_reg_2024_1774_art_21), need_to_know_and_least_privilege_access_rights_unclear, cite(eu_reg_2024_1774_art_21_a)).
duty(segregation_of_duties, access_control_policy_contains_segregation_of_duties, [cite(eu_reg_2024_1774_art_21_b)], cite(eu_reg_2024_1774_art_21), segregation_of_duties_unclear, cite(eu_reg_2024_1774_art_21_b)).
duty(user_accountability, access_control_policy_contains_provision_on_user_accountability, [cite(eu_reg_2024_1774_art_21_c)], cite(eu_reg_2024_1774_art_21), user_accountability_unclear, cite(eu_reg_2024_1774_art_21_c)).
duty(restrictions_of_access_to_ict_assets, access_control_policy_contains_provision_on_restrictions_of_access_to_ict_assets, [cite(eu_reg_2024_1774_art_21_d)], cite(eu_reg_2024_1774_art_21), restrictions_of_access_to_ict_assets_unclear, cite(eu_reg_2024_1774_art_21_d)).
duty(roles_for_granting_reviewing_and_revoking_access, account_management_procedures_assign_roles_for_granting_reviewing_and_revoking_access_rights, [cite(eu_reg_2024_1774_art_21_e_i)], cite(eu_reg_2024_1774_art_21), roles_for_granting_reviewing_and_revoking_access_unclear, cite(eu_reg_2024_1774_art_21_e_i)).
duty(privileged_emergency_and_administrator_access, account_management_procedures_assign_privileged_emergency_and_administrator_access_on_need_to_use_or_ad_hoc_basis, [cite(eu_reg_2024_1774_art_21_e_ii)], cite(eu_reg_2024_1774_art_21), privileged_emergency_and_administrator_access_unclear, cite(eu_reg_2024_1774_art_21_e_ii)).
duty(withdrawal_of_access_rights, account_management_procedures_withdraw_access_rights_without_undue_delay, [cite(eu_reg_2024_1774_art_21_e_iii)], cite(eu_reg_2024_1774_art_21), withdrawal_of_access_rights_unclear, cite(eu_reg_2024_1774_art_21_e_iii)).
duty(update_of_access_rights, account_management_procedures_update_access_rights_where_necessary_and_at_the_required_intervals, [cite(eu_reg_2024_1774_art_21_e_iv)], cite(eu_reg_2024_1774_art_21), update_of_access_rights_unclear, cite(eu_reg_2024_1774_art_21_e_iv)).
duty(authentication_methods_commensurate_to_classification_and_risk, access_control_policy_uses_authentication_methods_commensurate_to_classification_and_risk_profile, [cite(eu_reg_2024_1774_art_21_f_i)], cite(eu_reg_2024_1774_art_21), authentication_methods_commensurate_to_classification_and_risk_unclear, cite(eu_reg_2024_1774_art_21_f_i)).
duty(strong_authentication_methods, access_control_policy_uses_strong_authentication_methods_where_required, [cite(eu_reg_2024_1774_art_21_f_ii)], cite(eu_reg_2024_1774_art_21), strong_authentication_methods_unclear, cite(eu_reg_2024_1774_art_21_f_ii)).
duty(identification_and_logging_of_authorised_persons, physical_access_controls_identify_and_log_persons_authorised_to_access_premises, [cite(eu_reg_2024_1774_art_21_g_i)], cite(eu_reg_2024_1774_art_21), identification_and_logging_of_authorised_persons_unclear, cite(eu_reg_2024_1774_art_21_g_i)).
duty(physical_access_rights_to_critical_ict_assets, physical_access_rights_to_critical_ict_assets_granted_to_authorised_persons_only, [cite(eu_reg_2024_1774_art_21_g_ii)], cite(eu_reg_2024_1774_art_21), physical_access_rights_to_critical_ict_assets_unclear, cite(eu_reg_2024_1774_art_21_g_ii)).
duty(monitoring_of_physical_access, physical_access_to_premises_data_centres_and_sensitive_areas_monitored, [cite(eu_reg_2024_1774_art_21_g_iii)], cite(eu_reg_2024_1774_art_21), monitoring_of_physical_access_unclear, cite(eu_reg_2024_1774_art_21_g_iii)).
duty(review_of_physical_access_rights, physical_access_rights_reviewed_and_unnecessary_rights_promptly_revoked, [cite(eu_reg_2024_1774_art_21_g_iv)], cite(eu_reg_2024_1774_art_21), review_of_physical_access_rights_unclear, cite(eu_reg_2024_1774_art_21_g_iv)).
duty(retention_period_for_point_e_i, retention_period_for_the_purposes_of_point_e_i_established, [cite(eu_reg_2024_1774_art_21)], cite(eu_reg_2024_1774_art_21), retention_period_for_point_e_i_unclear, cite(eu_reg_2024_1774_art_21)).
duty(dedicated_administrative_accounts, dedicated_accounts_used_for_administrative_tasks_where_possible, [cite(eu_reg_2024_1774_art_21)], cite(eu_reg_2024_1774_art_21), dedicated_administrative_accounts_unclear, cite(eu_reg_2024_1774_art_21)).
duty(automated_privileged_access_management, automated_solutions_for_privileged_access_management_deployed_where_feasible_and_appropriate, [cite(eu_reg_2024_1774_art_21)], cite(eu_reg_2024_1774_art_21), automated_privileged_access_management_unclear, cite(eu_reg_2024_1774_art_21)).

key_state(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_state(Profile, Key, Value) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

gate_state(Profile, Gate) :-
    key_state(Profile, financial_entity_is_article_16_1_entity, Gate).

input_keys([financial_entity_is_article_16_1_entity|DutyKeys]) :-
    findall(Key, duty(_, Key, _, _, _, _), DutyKeys).

inputs_relied_on_pairs(Profile, Pairs) :-
    input_keys(Keys),
    findall(Key - Value, (member(Key, Keys), profile_has(Profile, Key), profile_get(Profile, Key, Value)), Pairs).

first_with_state([Candidate - State|Pairs], Wanted, Key) :-
    if_(State = Wanted, Key = Candidate, first_with_state(Pairs, Wanted, Key)).

duty_key_state(Duty, Profile, State) :-
    duty(Duty, Key, _, _, _, _),
    key_state(Profile, Key, State).

duty_status(physical_and_environmental_security_policy, Profile, State) :-
    implements(eu_reg_2024_1774_art_18_1),
    duty_key_state(physical_and_environmental_security_policy, Profile, State).
duty_status(physical_security_policy_design_basis, Profile, State) :-
    implements(eu_reg_2024_1774_art_18_1),
    duty_key_state(physical_security_policy_design_basis, Profile, State).
duty_status(reference_to_physical_access_controls_section, Profile, State) :-
    implements(eu_reg_2024_1774_art_18_2_a),
    duty_key_state(reference_to_physical_access_controls_section, Profile, State).
duty_status(protection_of_premises_data_centres_and_sensitive_areas, Profile, State) :-
    implements(eu_reg_2024_1774_art_18_2_b),
    duty_key_state(protection_of_premises_data_centres_and_sensitive_areas, Profile, State).
duty_status(securing_of_ict_assets_within_and_outside_premises, Profile, State) :-
    implements(eu_reg_2024_1774_art_18_2_c),
    duty_key_state(securing_of_ict_assets_within_and_outside_premises, Profile, State).
duty_status(appropriate_maintenance_of_assets_and_access_control_devices, Profile, State) :-
    implements(eu_reg_2024_1774_art_18_2_d),
    duty_key_state(appropriate_maintenance_of_assets_and_access_control_devices, Profile, State).
duty_status(clear_desk_policy_for_papers, Profile, State) :-
    implements(eu_reg_2024_1774_art_18_2_e_i),
    duty_key_state(clear_desk_policy_for_papers, Profile, State).
duty_status(clear_screen_policy, Profile, State) :-
    implements(eu_reg_2024_1774_art_18_2_e_ii),
    duty_key_state(clear_screen_policy, Profile, State).
duty_status(protection_of_unattended_ict_assets, Profile, State) :-
    implements(eu_reg_2024_1774_art_18_2),
    duty_key_state(protection_of_unattended_ict_assets, Profile, State).
duty_status(ict_security_responsibilities, Profile, State) :-
    implements(eu_reg_2024_1774_art_19_a),
    duty_key_state(ict_security_responsibilities, Profile, State).
duty_status(staff_informed_of_and_adhering_to_ict_security_policies, Profile, State) :-
    implements(eu_reg_2024_1774_art_19_b_i),
    duty_key_state(staff_informed_of_and_adhering_to_ict_security_policies, Profile, State).
duty_status(staff_aware_of_reporting_channels, Profile, State) :-
    implements(eu_reg_2024_1774_art_19_b_ii),
    duty_key_state(staff_aware_of_reporting_channels, Profile, State).
duty_status(return_of_assets_upon_termination_of_employment, Profile, State) :-
    implements(eu_reg_2024_1774_art_19_b_iii),
    duty_key_state(return_of_assets_upon_termination_of_employment, Profile, State).
duty_status(identity_management_policies_and_procedures, Profile, State) :-
    implements(eu_reg_2024_1774_art_20_1),
    duty_key_state(identity_management_policies_and_procedures, Profile, State).
duty_status(unique_identity_for_each_user_account, Profile, State) :-
    implements(eu_reg_2024_1774_art_20_2_a),
    duty_key_state(unique_identity_for_each_user_account, Profile, State).
duty_status(identity_and_account_lifecycle_management_process, Profile, State) :-
    implements(eu_reg_2024_1774_art_20_2_b),
    duty_key_state(identity_and_account_lifecycle_management_process, Profile, State).
duty_status(records_of_identity_assignments, Profile, State) :-
    implements(eu_reg_2024_1774_art_20_2),
    duty_key_state(records_of_identity_assignments, Profile, State).
duty_status(automated_identity_lifecycle_solutions, Profile, State) :-
    implements(eu_reg_2024_1774_art_20_2),
    duty_key_state(automated_identity_lifecycle_solutions, Profile, State).
duty_status(access_control_policy, Profile, State) :-
    implements(eu_reg_2024_1774_art_21),
    duty_key_state(access_control_policy, Profile, State).
duty_status(need_to_know_and_least_privilege_access_rights, Profile, State) :-
    implements(eu_reg_2024_1774_art_21_a),
    duty_key_state(need_to_know_and_least_privilege_access_rights, Profile, State).
duty_status(segregation_of_duties, Profile, State) :-
    implements(eu_reg_2024_1774_art_21_b),
    duty_key_state(segregation_of_duties, Profile, State).
duty_status(user_accountability, Profile, State) :-
    implements(eu_reg_2024_1774_art_21_c),
    duty_key_state(user_accountability, Profile, State).
duty_status(restrictions_of_access_to_ict_assets, Profile, State) :-
    implements(eu_reg_2024_1774_art_21_d),
    duty_key_state(restrictions_of_access_to_ict_assets, Profile, State).
duty_status(roles_for_granting_reviewing_and_revoking_access, Profile, State) :-
    implements(eu_reg_2024_1774_art_21_e_i),
    duty_key_state(roles_for_granting_reviewing_and_revoking_access, Profile, State).
duty_status(privileged_emergency_and_administrator_access, Profile, State) :-
    implements(eu_reg_2024_1774_art_21_e_ii),
    duty_key_state(privileged_emergency_and_administrator_access, Profile, State).
duty_status(withdrawal_of_access_rights, Profile, State) :-
    implements(eu_reg_2024_1774_art_21_e_iii),
    duty_key_state(withdrawal_of_access_rights, Profile, State).
duty_status(update_of_access_rights, Profile, State) :-
    implements(eu_reg_2024_1774_art_21_e_iv),
    duty_key_state(update_of_access_rights, Profile, State).
duty_status(authentication_methods_commensurate_to_classification_and_risk, Profile, State) :-
    implements(eu_reg_2024_1774_art_21_f_i),
    duty_key_state(authentication_methods_commensurate_to_classification_and_risk, Profile, State).
duty_status(strong_authentication_methods, Profile, State) :-
    implements(eu_reg_2024_1774_art_21_f_ii),
    duty_key_state(strong_authentication_methods, Profile, State).
duty_status(identification_and_logging_of_authorised_persons, Profile, State) :-
    implements(eu_reg_2024_1774_art_21_g_i),
    duty_key_state(identification_and_logging_of_authorised_persons, Profile, State).
duty_status(physical_access_rights_to_critical_ict_assets, Profile, State) :-
    implements(eu_reg_2024_1774_art_21_g_ii),
    duty_key_state(physical_access_rights_to_critical_ict_assets, Profile, State).
duty_status(monitoring_of_physical_access, Profile, State) :-
    implements(eu_reg_2024_1774_art_21_g_iii),
    duty_key_state(monitoring_of_physical_access, Profile, State).
duty_status(review_of_physical_access_rights, Profile, State) :-
    implements(eu_reg_2024_1774_art_21_g_iv),
    duty_key_state(review_of_physical_access_rights, Profile, State).
duty_status(retention_period_for_point_e_i, Profile, State) :-
    implements(eu_reg_2024_1774_art_21),
    duty_key_state(retention_period_for_point_e_i, Profile, State).
duty_status(dedicated_administrative_accounts, Profile, State) :-
    implements(eu_reg_2024_1774_art_21),
    duty_key_state(dedicated_administrative_accounts, Profile, State).
duty_status(automated_privileged_access_management, Profile, State) :-
    implements(eu_reg_2024_1774_art_21),
    duty_key_state(automated_privileged_access_management, Profile, State).

duty_states(Profile, Pairs) :-
    findall(Key - State, (duty(Duty, Key, _, _, _, _), duty_status(Duty, Profile, State)), Pairs).

physical_hr_identity_and_access_duties_required(Profile, Result, Citations) :-
    query_answer(required, Profile, Result, Citations).

physical_hr_identity_and_access_duties_complete(Profile, Result, Citations) :-
    query_answer(complete, Profile, Result, Citations).

physical_hr_identity_and_access_duties_outstanding(Profile, Result, Citations) :-
    query_answer(outstanding, Profile, Result, Citations).

query_answer(Query, Profile, Result, Citations) :-
    dora_rts_physical_hr_identity_and_access_input_problems(Profile, Problems),
    problems_answer(Problems, Query, Profile, Result, Citations).

problems_answer([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
problems_answer([], Query, Profile, Result, Citations) :-
    gate_state(Profile, Gate),
    gated_answer(Gate, Query, Profile, Result, Citations).

gated_answer(true, _, _, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]) :-
    implements(eu_reg_2022_2554_art_16_1).
gated_answer(absent, _, _, indeterminate([financial_entity_is_article_16_1_entity]), []) :-
    implements(eu_reg_2022_2554_art_16_1).
gated_answer(false, Query, Profile, Result, Citations) :-
    implements(eu_reg_2022_2554_art_16_1),
    duties_answer(Query, Profile, Result, Citations).

duties_answer(required, _, required(Duties), Citations) :-
    implements(eu_reg_2024_1774_art_18_1),
    findall(Duty, duty(Duty, _, _, _, _, _), Duties),
    findall(Paragraph, duty(_, _, _, Paragraph, _, _), Paragraphs),
    sort(Paragraphs, Citations).
duties_answer(complete, Profile, Result, Citations) :-
    duty_states(Profile, Pairs),
    pairs_values(Pairs, States),
    memberd_t(false, States, HasFailing),
    complete_step(HasFailing, Pairs, Profile, Result, Citations).
duties_answer(outstanding, Profile, Result, Citations) :-
    duty_states(Profile, Pairs),
    pairs_values(Pairs, States),
    memberd_t(absent, States, HasAbsent),
    memberd_t(unsure, States, HasUnsure),
    outstanding_step(HasAbsent, HasUnsure, Pairs, Profile, Result, Citations).

complete_step(true, _, _, incomplete, Citations) :-
    implements(eu_reg_2024_1774_art_18_1),
    fixed_citations(Citations).
complete_step(false, Pairs, Profile, Result, Citations) :-
    pairs_values(Pairs, States),
    memberd_t(absent, States, HasAbsent),
    memberd_t(unsure, States, HasUnsure),
    complete_open_step(HasAbsent, HasUnsure, Pairs, Profile, Result, Citations).

complete_open_step(false, false, _, _, complete, Citations) :-
    implements(eu_reg_2024_1774_art_18_1),
    fixed_citations(Citations).
complete_open_step(true, _, Pairs, _, indeterminate([Key]), []) :-
    first_with_state(Pairs, absent, Key).
complete_open_step(false, true, Pairs, Profile, Result, []) :-
    referral(Pairs, Profile, Result).

outstanding_step(true, _, Pairs, _, indeterminate([Key]), []) :-
    first_with_state(Pairs, absent, Key).
outstanding_step(false, true, Pairs, Profile, Result, []) :-
    referral(Pairs, Profile, Result).
outstanding_step(false, false, Pairs, _, Result, Citations) :-
    failing_duties(Pairs, Failing),
    outstanding_final(Failing, Result, Citations).

failing_duties(Pairs, Failing) :-
    implements(eu_reg_2024_1774_art_18_1),
    findall(Duty, (member(Key - false, Pairs), duty(Duty, Key, _, _, _, _)), Failing).

outstanding_final([], none_outstanding, Citations) :-
    fixed_citations(Citations).
outstanding_final([Duty|Duties], outstanding([Duty|Duties]), Citations) :-
    findall(Citation, (member(Outstanding, [Duty|Duties]), duty(Outstanding, _, DutyCitations, _, _, _), member(Citation, DutyCitations)), AllCitations),
    sort(AllCitations, Citations).

referral(Pairs, Profile, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Inputs)])) :-
    first_with_state(Pairs, unsure, Key),
    duty(_, Key, _, _, _, Citation),
    inputs_relied_on_pairs(Profile, Inputs).

decide_dora_rts_physical_hr_identity_and_access(Profile, dora_rts_physical_hr_identity_and_access_verdict(Status, Citations)) :-
    physical_hr_identity_and_access_duties_complete(Profile, Status, Citations).

dora_rts_physical_hr_identity_and_access_status(Profile, Status) :-
    decide_dora_rts_physical_hr_identity_and_access(Profile, dora_rts_physical_hr_identity_and_access_verdict(Status, _Citations)).

dora_rts_physical_hr_identity_and_access_checklist(Profile, [GateItem|DutyItems]) :-
    dora_rts_physical_hr_identity_and_access_input_problems(Profile, []),
    gate_state(Profile, Gate),
    gate_item(Gate, GateItem),
    findall(item(Duty, Status, Citation), (duty(Duty, Key, _, _, _, Citation), duty_status(Duty, Profile, State), item_status(State, Key, Status)), DutyItems).

gate_item(false, item(financial_entity_is_article_16_1_entity, met, cite(eu_reg_2022_2554_art_16_1))) :-
    implements(eu_reg_2022_2554_art_16_1).
gate_item(true, item(financial_entity_is_article_16_1_entity, unmet(simplified_framework_entity), cite(eu_reg_2022_2554_art_16_1))) :-
    implements(eu_reg_2022_2554_art_16_1).
gate_item(absent, item(financial_entity_is_article_16_1_entity, unknown([financial_entity_is_article_16_1_entity]), cite(eu_reg_2022_2554_art_16_1))) :-
    implements(eu_reg_2022_2554_art_16_1).

item_status(true, _, met).
item_status(false, _, unmet(not_performed)).
item_status(absent, Key, unknown([Key])).
item_status(unsure, Key, unknown([Key])).

dora_rts_physical_hr_identity_and_access_decision_resolvable(Profile) :-
    decide_dora_rts_physical_hr_identity_and_access(Profile, _Verdict).

profile_with(Gate, Overrides, [attribute(financial_entity_is_article_16_1_entity, Gate)|DutyAttributes]) :-
    findall(attribute(Key, Value), (duty(_, Key, _, _, _, _), override_value(Key, Overrides, Value), dif(Value, absent)), DutyAttributes).

override_value(Key, Overrides, Value) :-
    pairs_keys(Overrides, OverrideKeys),
    memberd_t(Key, OverrideKeys, Overridden),
    chosen_value(Overridden, Key, Overrides, Value).

chosen_value(true, Key, Overrides, Value) :-
    member(Key - Value, Overrides).
chosen_value(false, _, _, true).

test(the_duty_table_has_thirty_six_rows) :-
    findall(Duty, duty(Duty, _, _, _, _, _), Duties),
    length(Duties, 36).
test(an_empty_profile_asks_for_the_gate) :-
    physical_hr_identity_and_access_duties_required([], indeterminate([financial_entity_is_article_16_1_entity]), []).
test(an_article_16_1_entity_follows_the_simplified_framework) :-
    physical_hr_identity_and_access_duties_complete([attribute(financial_entity_is_article_16_1_entity, true)], simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(an_article_16_1_entity_has_no_outstanding_list) :-
    profile_with(true, [access_control_policy_contains_segregation_of_duties - false], Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(every_duty_is_required) :-
    physical_hr_identity_and_access_duties_required([attribute(financial_entity_is_article_16_1_entity, false)], required(Duties), Citations),
    length(Duties, 36),
    Duties = [physical_and_environmental_security_policy|_],
    last(Duties, automated_privileged_access_management),
    fixed_citations(Fixed),
    clausal_msort(Fixed, Sorted),
    clausal_msort(Citations, Sorted).
test(all_duties_performed_is_complete) :-
    profile_with(false, [], Profile),
    physical_hr_identity_and_access_duties_complete(Profile, complete, Citations),
    length(Citations, 6).
test(the_complete_query_has_one_answer) :-
    profile_with(false, [], Profile),
    findall(Result - Citations, physical_hr_identity_and_access_duties_complete(Profile, Result, Citations), Answers),
    length(Answers, 1).
test(a_failing_duty_decides_before_an_absent_one) :-
    profile_with(false, [access_control_policy_contains_segregation_of_duties - false, automated_solutions_for_privileged_access_management_deployed_where_feasible_and_appropriate - absent], Profile),
    physical_hr_identity_and_access_duties_complete(Profile, incomplete, _).
test(an_absent_duty_is_asked_before_an_unsure_one) :-
    profile_with(false, [physical_security_policy_refers_to_section_on_physical_access_controls - unsure, automated_solutions_for_privileged_access_management_deployed_where_feasible_and_appropriate - absent], Profile),
    physical_hr_identity_and_access_duties_complete(Profile, indeterminate([automated_solutions_for_privileged_access_management_deployed_where_feasible_and_appropriate]), []).
test(an_unsure_duty_goes_to_a_lawyer) :-
    profile_with(false, [access_control_policy_contains_segregation_of_duties - unsure], Profile),
    physical_hr_identity_and_access_duties_complete(Profile, needs_legal_review(open_textured(access_control_policy_contains_segregation_of_duties, cite(eu_reg_2024_1774_art_21_b)), [inputs_relied_on(Pairs)]), []),
    length(Pairs, 37),
    Pairs = [financial_entity_is_article_16_1_entity - false|_].
test(outstanding_lists_failing_duties_in_duty_order) :-
    profile_with(false, [access_control_policy_contains_segregation_of_duties - false, physical_security_policy_refers_to_section_on_physical_access_controls - false], Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, outstanding([reference_to_physical_access_controls_section, segregation_of_duties]), Citations),
    clausal_msort(Citations, [cite(eu_reg_2024_1774_art_18_2_a), cite(eu_reg_2024_1774_art_21_b)]).
test(a_failing_duty_does_not_end_the_outstanding_query) :-
    profile_with(false, [access_control_policy_contains_segregation_of_duties - false, automated_solutions_for_privileged_access_management_deployed_where_feasible_and_appropriate - absent], Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, indeterminate([automated_solutions_for_privileged_access_management_deployed_where_feasible_and_appropriate]), []).
test(nothing_failing_is_none_outstanding) :-
    profile_with(false, [], Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, none_outstanding, Citations),
    length(Citations, 6).
test(an_input_problem_comes_first) :-
    physical_hr_identity_and_access_duties_required([attribute(colour, blue), attribute(financial_entity_is_article_16_1_entity, true)], input_problems([unknown_key(colour)]), []).
test(the_checklist_has_a_row_per_duty_and_the_gate) :-
    profile_with(false, [], Profile),
    dora_rts_physical_hr_identity_and_access_checklist(Profile, Items),
    length(Items, 37).
test(the_verdict_is_the_complete_answer) :-
    profile_with(false, [], Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, complete).

test(a_failing_duty_is_not_complete, fail) :-
    profile_with(false, [access_control_policy_contains_segregation_of_duties - false], Profile),
    physical_hr_identity_and_access_duties_complete(Profile, complete, _).
test(nothing_failing_is_not_an_outstanding_list, fail) :-
    profile_with(false, [], Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, outstanding(_), _).
