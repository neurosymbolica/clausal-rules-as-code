% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_texas_tdpsa_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__us_texas_tdpsa_queries, [texas_tdpsa_profile_keys/1, texas_tdpsa_what_if/4, in_scope/0]).
:- use_module(m__us_texas_tdpsa_kernel, [texas_tdpsa_input_problems/2]).
:- use_module(m__us_texas_tdpsa_texas_tdpsa, [texas_tdpsa_status/2, applicability_status/4, response_deadline/4, civil_penalty_maximum/3, texas_tdpsa_checklist/2]).
:- use_module(m__us_texas_tdpsa_fixtures, [texas_tdpsa_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    texas_tdpsa_profile_keys(ProfileKeys),
    ProfileKeys == [entity_category, processes_or_sells_personal_data, conducts_business_in_texas_or_serves_texas_residents, small_business_as_defined_by_sba, extension_reasonably_necessary, extension_notice_given_within_initial_period, cured_within_cure_period, written_statement_provided, written_statement_breached, violation_after_cure_period_or_statement_breach, violation_count].
test(what_if_same_value_keeps_in_scope) :-
    texas_tdpsa_profile_for(in_scope_controller, Profile),
    findall(Status, texas_tdpsa_what_if(Profile, processes_or_sells_personal_data, true, Status), Statuses),
    Statuses == [in_scope].
test(what_if_nonprofit_flips_to_out_of_scope) :-
    texas_tdpsa_profile_for(in_scope_controller, Profile),
    findall(Status, texas_tdpsa_what_if(Profile, entity_category, nonprofit_organization, Status), Statuses),
    Statuses == [out_of_scope].
test(what_if_small_business_flips_to_out_of_scope) :-
    texas_tdpsa_profile_for(in_scope_controller, Profile),
    findall(Status, texas_tdpsa_what_if(Profile, small_business_as_defined_by_sba, attested(true, attestation(host_user, host_time, size_review, none)), Status), Statuses),
    Statuses == [out_of_scope].
test(what_if_unsure_business_is_referred) :-
    texas_tdpsa_profile_for(in_scope_controller, Profile),
    findall(Status, texas_tdpsa_what_if(Profile, conducts_business_in_texas_or_serves_texas_residents, unsure, Status), Statuses),
    Statuses = [needs_legal_review(open_textured(conducts_business_in_texas_or_serves_texas_residents, _), _)].
test(what_if_repairs_a_duplicate_key) :-
    texas_tdpsa_profile_for(malformed_duplicate_key, Profile),
    findall(Status, texas_tdpsa_what_if(Profile, entity_category, nonprofit_organization, Status), Statuses),
    Statuses == [out_of_scope].
test(what_if_unknown_key_is_an_input_problem) :-
    texas_tdpsa_profile_for(in_scope_controller, Profile),
    texas_tdpsa_what_if(Profile, colour, blue, input_problems([unknown_key(colour)])).
test(what_if_leaves_the_original_status) :-
    texas_tdpsa_profile_for(in_scope_controller, Profile),
    texas_tdpsa_what_if(Profile, entity_category, financial_institution, out_of_scope),
    texas_tdpsa_status(Profile, in_scope).
test(input_check_reached_through_the_query_layer) :-
    texas_tdpsa_input_problems([attribute(violation_count, many)], [wrong_type(violation_count)]).
test(result_atom_resolves) :-
    in_scope.
test(result_constructors_build_and_destructure) :-
    Missing = indeterminate([entity_category]),
    Missing = indeterminate([MissingKey]),
    MissingKey == entity_category,
    Referral = needs_legal_review(open_textured(extension_reasonably_necessary, cite(us_tx_bc_541_052_b)), []),
    Referral = needs_legal_review(open_textured(InputKey, _), _),
    InputKey == extension_reasonably_necessary.
test(status_determination_query) :-
    texas_tdpsa_profile_for(nonprofit_excluded, Profile),
    findall(Result, applicability_status(Profile, Result, _, _), Results),
    Results == [out_of_scope].
test(deadline_query) :-
    findall(Result, response_deadline([], date(2026, 6, 30), Result, _), Results),
    Results == [date(2026, 8, 14)].
test(calculation_query) :-
    findall(Result, civil_penalty_maximum([attribute(violation_after_cure_period_or_statement_breach, true), attribute(violation_count, 10)], Result, _), Results),
    Results == [75000].
test(justification_checklist_rows_carry_citations) :-
    texas_tdpsa_profile_for(nonprofit_excluded, Profile),
    texas_tdpsa_checklist(Profile, Checklist),
    Checklist = [item(not_an_excluded_kind_of_person, unmet(excluded_category(nonprofit_organization)), cite(us_tx_bc_541_002_b_4))|_],
    length(Checklist, 4).
test(justification_unsure_row_is_unknown) :-
    texas_tdpsa_profile_for(conducts_business_unsure, Profile),
    texas_tdpsa_checklist(Profile, Checklist),
    member(item(conducts_business_in_texas_or_serves_texas_residents, unknown([conducts_business_in_texas_or_serves_texas_residents]), cite(us_tx_bc_541_002_a_1)), Checklist).

cp_test_names([profile_keys_are_the_contract_keys, what_if_same_value_keeps_in_scope, what_if_nonprofit_flips_to_out_of_scope, what_if_small_business_flips_to_out_of_scope, what_if_unsure_business_is_referred, what_if_repairs_a_duplicate_key, what_if_unknown_key_is_an_input_problem, what_if_leaves_the_original_status, input_check_reached_through_the_query_layer, result_atom_resolves, result_constructors_build_and_destructure, status_determination_query, deadline_query, calculation_query, justification_checklist_rows_carry_citations, justification_unsure_row_is_unknown]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
