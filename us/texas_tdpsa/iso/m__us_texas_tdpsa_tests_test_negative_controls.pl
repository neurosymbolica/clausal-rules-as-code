% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_texas_tdpsa_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__us_texas_tdpsa_texas_tdpsa, [texas_tdpsa_status/2, texas_tdpsa_status_values/1, applicability_status/4, extended_response_deadline/4, response_deadline/4, attorney_general_action_status/5, civil_penalty_maximum/3]).
:- use_module(m__us_texas_tdpsa_fixtures, [texas_tdpsa_profile_for/2]).

test(the_status_table_has_a_near_miss_atom) :-
    texas_tdpsa_status_values(StatusValues),
    StatusValues == [in_scope, out_of_scope].
test(the_baseline_profile_yields_exactly_one_status) :-
    texas_tdpsa_profile_for(in_scope_controller, Profile),
    findall(Status, texas_tdpsa_status(Profile, Status), [in_scope]).
test(small_business_is_out_of_scope) :-
    texas_tdpsa_profile_for(small_business_attested, Profile),
    applicability_status(Profile, out_of_scope, [outside_fact(small_business_as_defined_by_sba, _)], _).
test(not_a_small_business_is_in_scope) :-
    texas_tdpsa_profile_for(in_scope_controller, Profile),
    applicability_status(Profile, in_scope, _, _).
test(nonprofit_is_out_of_scope) :-
    texas_tdpsa_profile_for(nonprofit_excluded, Profile),
    applicability_status(Profile, out_of_scope, [], _).
test(not_processing_is_out_of_scope) :-
    texas_tdpsa_profile_for(not_processing_personal_data, Profile),
    applicability_status(Profile, out_of_scope, [], _).
test(not_conducting_is_out_of_scope) :-
    texas_tdpsa_profile_for(not_conducting_business, Profile),
    applicability_status(Profile, out_of_scope, [], _).
test(missing_entity_category_is_named) :-
    texas_tdpsa_profile_for(entity_category_missing, Profile),
    applicability_status(Profile, indeterminate([entity_category]), [], []).
test(absent_attestation_is_referred) :-
    texas_tdpsa_profile_for(sba_absent_referral, Profile),
    applicability_status(Profile, needs_legal_review(cross_reference_unresolved(cite(us_tx_bc_541_002_a_3), cite(sba_small_business_size_determination)), _), [], []).
test(unsure_business_is_referred) :-
    texas_tdpsa_profile_for(conducts_business_unsure, Profile),
    applicability_status(Profile, needs_legal_review(open_textured(conducts_business_in_texas_or_serves_texas_residents, cite(us_tx_bc_541_002_a_1)), _), [], []).
test(duplicate_key_is_an_input_problem) :-
    texas_tdpsa_profile_for(malformed_duplicate_key, Profile),
    applicability_status(Profile, input_problems([duplicate_key(entity_category)]), [], []).
test(response_deadline_is_day_45) :-
    response_deadline([], date(2026, 1, 1), date(2026, 2, 15), _).
test(extension_granted_gives_day_90) :-
    texas_tdpsa_profile_for(extension_granted, Profile),
    extended_response_deadline(Profile, date(2026, 1, 1), date(2026, 4, 1), _).
test(late_notice_gives_no_extension) :-
    texas_tdpsa_profile_for(extension_notice_late, Profile),
    extended_response_deadline(Profile, date(2026, 1, 1), no_extension_available, _).
test(unsure_necessity_is_referred) :-
    texas_tdpsa_profile_for(extension_necessity_unsure, Profile),
    extended_response_deadline(Profile, date(2026, 1, 1), needs_legal_review(open_textured(extension_reasonably_necessary, cite(us_tx_bc_541_052_b)), [inputs_relied_on([extension_reasonably_necessary - unsure])]), []).
test(missing_notice_is_named) :-
    texas_tdpsa_profile_for(extension_notice_missing, Profile),
    extended_response_deadline(Profile, date(2026, 1, 1), indeterminate([extension_notice_given_within_initial_period]), []).
test(thirtieth_day_is_running) :-
    texas_tdpsa_profile_for(cure_not_achieved, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 3, 31), cure_period_running, _).
test(uncured_violation_allows_the_action) :-
    texas_tdpsa_profile_for(cure_not_achieved, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 4, 1), action_may_be_brought, _).
test(breached_statement_allows_the_action) :-
    texas_tdpsa_profile_for(statement_breached, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 4, 1), action_may_be_brought, _).
test(cured_violation_bars_the_action) :-
    texas_tdpsa_profile_for(cure_completed, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 4, 1), no_action_for_cured_violation, _).
test(missing_cure_keys_named_after_the_period) :-
    texas_tdpsa_profile_for(cure_keys_missing, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 4, 1), indeterminate([cured_within_cure_period]), []).
test(reference_on_the_notice_day_is_accepted) :-
    attorney_general_action_status([], date(2026, 3, 1), date(2026, 3, 1), cure_period_running, _).
test(reference_the_day_before_notice_is_refused) :-
    attorney_general_action_status([], date(2026, 3, 1), date(2026, 2, 28), input_problems([wrong_type(reference_date)]), []).
test(three_violations_cap_at_22500) :-
    texas_tdpsa_profile_for(penalty_three_violations, Profile),
    civil_penalty_maximum(Profile, 22500, _).
test(no_ground_gives_no_civil_penalty) :-
    texas_tdpsa_profile_for(penalty_no_ground, Profile),
    civil_penalty_maximum(Profile, no_civil_penalty, _).
test(missing_count_is_named) :-
    texas_tdpsa_profile_for(penalty_count_missing, Profile),
    civil_penalty_maximum(Profile, indeterminate([violation_count]), []).
test(missing_ground_is_named) :-
    civil_penalty_maximum([], indeterminate([violation_after_cure_period_or_statement_breach]), []).

test(the_baseline_profile_yields_no_other_table_status, fail) :-
    texas_tdpsa_profile_for(in_scope_controller, Profile),
    findall(Status, texas_tdpsa_status(Profile, Status), [BaselineStatus]),
    texas_tdpsa_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, BaselineStatus),
    texas_tdpsa_status(Profile, Other).
test(small_business_is_not_in_scope, fail) :-
    texas_tdpsa_profile_for(small_business_attested, Profile),
    applicability_status(Profile, in_scope, _, _).
test(not_a_small_business_is_not_out_of_scope, fail) :-
    texas_tdpsa_profile_for(in_scope_controller, Profile),
    applicability_status(Profile, out_of_scope, _, _).
test(nonprofit_is_not_in_scope, fail) :-
    texas_tdpsa_profile_for(nonprofit_excluded, Profile),
    applicability_status(Profile, in_scope, _, _).
test(not_processing_is_not_in_scope, fail) :-
    texas_tdpsa_profile_for(not_processing_personal_data, Profile),
    applicability_status(Profile, in_scope, _, _).
test(not_conducting_is_not_in_scope, fail) :-
    texas_tdpsa_profile_for(not_conducting_business, Profile),
    applicability_status(Profile, in_scope, _, _).
test(missing_entity_category_is_not_in_scope, fail) :-
    texas_tdpsa_profile_for(entity_category_missing, Profile),
    applicability_status(Profile, in_scope, _, _).
test(absent_attestation_is_not_in_scope, fail) :-
    texas_tdpsa_profile_for(sba_absent_referral, Profile),
    applicability_status(Profile, in_scope, _, _).
test(absent_attestation_never_named_as_missing, fail) :-
    texas_tdpsa_profile_for(sba_absent_referral, Profile),
    applicability_status(Profile, indeterminate(_), _, _).
test(unsure_business_is_not_in_scope, fail) :-
    texas_tdpsa_profile_for(conducts_business_unsure, Profile),
    applicability_status(Profile, in_scope, _, _).
test(unsure_business_is_not_out_of_scope, fail) :-
    texas_tdpsa_profile_for(conducts_business_unsure, Profile),
    applicability_status(Profile, out_of_scope, _, _).
test(duplicate_key_is_not_also_wrong_type, fail) :-
    texas_tdpsa_profile_for(malformed_duplicate_key, Profile),
    applicability_status(Profile, input_problems(Problems), _, _),
    member(wrong_type(entity_category), Problems).
test(duplicate_key_gets_no_status, fail) :-
    texas_tdpsa_profile_for(malformed_duplicate_key, Profile),
    applicability_status(Profile, out_of_scope, _, _).
test(response_deadline_is_not_day_44, fail) :-
    response_deadline([], date(2026, 1, 1), date(2026, 2, 14), _).
test(extension_granted_is_not_unavailable, fail) :-
    texas_tdpsa_profile_for(extension_granted, Profile),
    extended_response_deadline(Profile, date(2026, 1, 1), no_extension_available, _).
test(late_notice_gives_no_date, fail) :-
    texas_tdpsa_profile_for(extension_notice_late, Profile),
    extended_response_deadline(Profile, date(2026, 1, 1), date(_, _, _), _).
test(unsure_necessity_gives_no_date, fail) :-
    texas_tdpsa_profile_for(extension_necessity_unsure, Profile),
    extended_response_deadline(Profile, date(2026, 1, 1), date(_, _, _), _).
test(missing_notice_is_not_unavailable, fail) :-
    texas_tdpsa_profile_for(extension_notice_missing, Profile),
    extended_response_deadline(Profile, date(2026, 1, 1), no_extension_available, _).
test(thirty_first_day_is_not_running, fail) :-
    texas_tdpsa_profile_for(cure_not_achieved, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 4, 1), cure_period_running, _).
test(breached_statement_does_not_bar_the_action, fail) :-
    texas_tdpsa_profile_for(statement_breached, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 4, 1), no_action_for_cured_violation, _).
test(cured_violation_does_not_allow_the_action, fail) :-
    texas_tdpsa_profile_for(cure_completed, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 4, 1), action_may_be_brought, _).
test(missing_cure_keys_not_named_within_the_period, fail) :-
    texas_tdpsa_profile_for(cure_keys_missing, Profile),
    attorney_general_action_status(Profile, date(2026, 3, 1), date(2026, 3, 31), indeterminate(_), _).
test(reference_the_day_before_notice_is_not_running, fail) :-
    attorney_general_action_status([], date(2026, 3, 1), date(2026, 2, 28), cure_period_running, _).
test(three_violations_do_not_cap_at_22499, fail) :-
    texas_tdpsa_profile_for(penalty_three_violations, Profile),
    civil_penalty_maximum(Profile, 22499, _).
test(no_ground_gives_no_amount, fail) :-
    texas_tdpsa_profile_for(penalty_no_ground, Profile),
    civil_penalty_maximum(Profile, 22500, _).
test(missing_ground_never_names_the_count, fail) :-
    civil_penalty_maximum([], indeterminate([violation_count]), _).

cp_test_names([the_status_table_has_a_near_miss_atom, the_baseline_profile_yields_exactly_one_status, small_business_is_out_of_scope, not_a_small_business_is_in_scope, nonprofit_is_out_of_scope, not_processing_is_out_of_scope, not_conducting_is_out_of_scope, missing_entity_category_is_named, absent_attestation_is_referred, unsure_business_is_referred, duplicate_key_is_an_input_problem, response_deadline_is_day_45, extension_granted_gives_day_90, late_notice_gives_no_extension, unsure_necessity_is_referred, missing_notice_is_named, thirtieth_day_is_running, uncured_violation_allows_the_action, breached_statement_allows_the_action, cured_violation_bars_the_action, missing_cure_keys_named_after_the_period, reference_on_the_notice_day_is_accepted, reference_the_day_before_notice_is_refused, three_violations_cap_at_22500, no_ground_gives_no_civil_penalty, missing_count_is_named, missing_ground_is_named]).
cp_test_fail_names([the_baseline_profile_yields_no_other_table_status, small_business_is_not_in_scope, not_a_small_business_is_not_out_of_scope, nonprofit_is_not_in_scope, not_processing_is_not_in_scope, not_conducting_is_not_in_scope, missing_entity_category_is_not_in_scope, absent_attestation_is_not_in_scope, absent_attestation_never_named_as_missing, unsure_business_is_not_in_scope, unsure_business_is_not_out_of_scope, duplicate_key_is_not_also_wrong_type, duplicate_key_gets_no_status, response_deadline_is_not_day_44, extension_granted_is_not_unavailable, late_notice_gives_no_date, unsure_necessity_gives_no_date, missing_notice_is_not_unavailable, thirty_first_day_is_not_running, breached_statement_does_not_bar_the_action, cured_violation_does_not_allow_the_action, missing_cure_keys_not_named_within_the_period, reference_the_day_before_notice_is_not_running, three_violations_do_not_cap_at_22499, no_ground_gives_no_amount, missing_ground_never_names_the_count]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
