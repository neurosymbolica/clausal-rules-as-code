% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_art_5_3_terminal_equipment_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_eprivacy_art_5_3_terminal_equipment, [terminal_equipment_storage_or_access_permitted/3, decide_eprivacy_art_5_3_terminal_equipment/2, eprivacy_art_5_3_terminal_equipment_status/2, eprivacy_art_5_3_terminal_equipment_checklist/2, eprivacy_art_5_3_terminal_equipment_decision_resolvable/1, eprivacy_art_5_3_terminal_equipment_status_values/1, needs_legal_review/2, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, indeterminate/1, inputs_relied_on/1]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_kernel, [eprivacy_art_5_3_terminal_equipment_input_problems/2]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_queries, [eprivacy_art_5_3_terminal_equipment_what_if/4]).
:- use_module(m__eu_eprivacy_art_5_3_terminal_equipment_fixtures, [eprivacy_art_5_3_terminal_equipment_subject/1, eprivacy_art_5_3_terminal_equipment_profile_for/2, eprivacy_art_5_3_terminal_equipment_assess/2]).

expected(empty_profile, indeterminate([storage_or_access_in_terminal_equipment]), []).
expected(out_of_scope, not_applicable, [cite(eu_dir_2002_58_art_5_3)]).
expected(scope_only, indeterminate([storage_or_access_solely_for_transmission]), []).
expected(transmission_only, permitted, [cite(eu_dir_2002_58_art_5_3)]).
expected(transmission_failed_alone, indeterminate([service_explicitly_requested_by_user]), []).
expected(requested_and_strictly_necessary, permitted, [cite(eu_dir_2002_58_art_5_3)]).
expected(requested_but_not_strictly_necessary, not_permitted, [cite(eu_dir_2002_58_art_5_3)]).
expected(informed_consent, permitted, [cite(eu_dir_2002_58_art_5_3)]).
expected(consent_without_information, not_permitted, [cite(eu_dir_2002_58_art_5_3)]).
expected(all_ways_failed, not_permitted, [cite(eu_dir_2002_58_art_5_3)]).
expected(transmission_restores_permission, permitted, [cite(eu_dir_2002_58_art_5_3)]).
expected(fewest_unresolved_first, indeterminate([strictly_necessary_to_provide_requested_service]), []).
expected(unsure_open_way_skipped_for_missing, indeterminate([service_explicitly_requested_by_user]), []).
expected(scope_unsure_missing_named, indeterminate([storage_or_access_solely_for_transmission]), []).
expected(scope_unsure_settled_permitted, needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on([storage_or_access_in_terminal_equipment - unsure, storage_or_access_solely_for_transmission - true])]), []).
expected(scope_unsure_settled_forbidden, needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on([storage_or_access_in_terminal_equipment - unsure, storage_or_access_solely_for_transmission - false, service_explicitly_requested_by_user - false, user_consent_given - false])]), []).
expected(transmission_unsure_referred, needs_legal_review(open_textured(storage_or_access_solely_for_transmission, cite(eu_dir_2002_58_art_5_3_s2)), [inputs_relied_on([storage_or_access_in_terminal_equipment - true, storage_or_access_solely_for_transmission - unsure, service_explicitly_requested_by_user - false, user_consent_given - false])]), []).
expected(consent_unsure_referred, needs_legal_review(open_textured(user_consent_given, cite(eu_dir_2002_58_art_2_f)), [inputs_relied_on([storage_or_access_in_terminal_equipment - true, storage_or_access_solely_for_transmission - false, service_explicitly_requested_by_user - false, user_consent_given - unsure, clear_and_comprehensive_information_provided - true])]), []).
expected(information_unsure_referred, needs_legal_review(open_textured(clear_and_comprehensive_information_provided, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on([storage_or_access_in_terminal_equipment - true, storage_or_access_solely_for_transmission - false, service_explicitly_requested_by_user - false, user_consent_given - true, clear_and_comprehensive_information_provided - unsure])]), []).
expected(full_referral_row, needs_legal_review(open_textured(storage_or_access_solely_for_transmission, cite(eu_dir_2002_58_art_5_3_s2)), [inputs_relied_on([storage_or_access_in_terminal_equipment - true, storage_or_access_solely_for_transmission - unsure, service_explicitly_requested_by_user - unsure, strictly_necessary_to_provide_requested_service - unsure, user_consent_given - unsure, clear_and_comprehensive_information_provided - unsure])]), []).
expected(full_row_transmission_met, permitted, [cite(eu_dir_2002_58_art_5_3)]).
expected(attested_value, input_problems([wrong_type(storage_or_access_in_terminal_equipment)]), []).
expected(duplicate_scope_key, input_problems([duplicate_key(storage_or_access_in_terminal_equipment), unknown_key(zzz)]), []).
expected(not_attribute_list, input_problems([wrong_type(profile)]), []).

near_miss(empty_profile, out_of_scope).
near_miss(out_of_scope, scope_only).
near_miss(transmission_only, transmission_failed_alone).
near_miss(requested_and_strictly_necessary, requested_but_not_strictly_necessary).
near_miss(informed_consent, consent_without_information).
near_miss(all_ways_failed, transmission_restores_permission).
near_miss(fewest_unresolved_first, transmission_failed_alone).
near_miss(unsure_open_way_skipped_for_missing, scope_only).
near_miss(scope_unsure_missing_named, scope_unsure_settled_permitted).
near_miss(scope_unsure_settled_permitted, transmission_only).
near_miss(scope_unsure_settled_forbidden, all_ways_failed).
near_miss(transmission_unsure_referred, all_ways_failed).
near_miss(consent_unsure_referred, informed_consent).
near_miss(information_unsure_referred, consent_without_information).
near_miss(full_referral_row, full_row_transmission_met).
near_miss(attested_value, scope_only).
near_miss(duplicate_scope_key, scope_only).
near_miss(not_attribute_list, empty_profile).

resolves_to_expected(Subject) :-
    expected(Subject, ExpectedResult, ExpectedCitations),
    findall(Result - Citations, eprivacy_art_5_3_terminal_equipment_assess(Subject, eprivacy_art_5_3_terminal_equipment_verdict(Result, Citations)), Answers),
    Answers == [ExpectedResult - ExpectedCitations].

contract_agrees(Subject) :-
    expected(Subject, ExpectedResult, ExpectedCitations),
    eprivacy_art_5_3_terminal_equipment_profile_for(Subject, Profile),
    findall(Result - Citations, terminal_equipment_storage_or_access_permitted(Profile, Result, Citations), Answers),
    Answers == [ExpectedResult - ExpectedCitations].

checklist_non_empty(Subject) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(Subject, Profile),
    findall(Items, eprivacy_art_5_3_terminal_equipment_checklist(Profile, Items), AllItems),
    AllItems = [[_FirstItem|_OtherItems]].

near_miss_differs(Positive - Control) :-
    eprivacy_art_5_3_terminal_equipment_assess(Positive, eprivacy_art_5_3_terminal_equipment_verdict(PositiveResult, _)),
    eprivacy_art_5_3_terminal_equipment_assess(Control, eprivacy_art_5_3_terminal_equipment_verdict(ControlResult, _)),
    dif(PositiveResult, ControlResult).

test(every_subject_has_an_expected_result) :-
    findall(Subject, eprivacy_art_5_3_terminal_equipment_subject(Subject), Subjects),
    msort(Subjects, SortedSubjects),
    findall(Subject, expected(Subject, _, _), ExpectedSubjects),
    msort(ExpectedSubjects, SortedExpected),
    SortedSubjects == SortedExpected.
test(every_subject_resolves_to_its_expected_result) :-
    findall(Subject, eprivacy_art_5_3_terminal_equipment_subject(Subject), Subjects),
    maplist(resolves_to_expected, Subjects).
test(the_called_contract_agrees_on_every_subject) :-
    findall(Subject, eprivacy_art_5_3_terminal_equipment_subject(Subject), Subjects),
    maplist(contract_agrees, Subjects).
test(every_subject_answers_exactly_once) :-
    findall(Subject, eprivacy_art_5_3_terminal_equipment_subject(Subject), Subjects),
    length(Subjects, SubjectCount),
    findall(Subject - Verdict, (eprivacy_art_5_3_terminal_equipment_subject(Subject), eprivacy_art_5_3_terminal_equipment_assess(Subject, Verdict)), Answers),
    length(Answers, SubjectCount).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, eprivacy_art_5_3_terminal_equipment_subject(Subject), Subjects),
    maplist(checklist_non_empty, Subjects).
test(every_near_miss_control_gets_a_different_result) :-
    findall(Positive - Control, near_miss(Positive, Control), Pairs),
    Pairs = [_|_],
    maplist(near_miss_differs, Pairs).
test(empty_profile_resolves) :-
    resolves_to_expected(empty_profile).
test(out_of_scope_resolves) :-
    resolves_to_expected(out_of_scope).
test(scope_only_resolves) :-
    resolves_to_expected(scope_only).
test(transmission_only_resolves) :-
    resolves_to_expected(transmission_only).
test(transmission_only_is_permitted) :-
    eprivacy_art_5_3_terminal_equipment_assess(transmission_only, eprivacy_art_5_3_terminal_equipment_verdict(permitted, [cite(eu_dir_2002_58_art_5_3)])).
test(transmission_failed_alone_resolves) :-
    resolves_to_expected(transmission_failed_alone).
test(requested_and_strictly_necessary_resolves) :-
    resolves_to_expected(requested_and_strictly_necessary).
test(requested_but_not_strictly_necessary_resolves) :-
    resolves_to_expected(requested_but_not_strictly_necessary).
test(requested_but_not_strictly_necessary_is_not_permitted) :-
    eprivacy_art_5_3_terminal_equipment_assess(requested_but_not_strictly_necessary, eprivacy_art_5_3_terminal_equipment_verdict(not_permitted, [cite(eu_dir_2002_58_art_5_3)])).
test(informed_consent_resolves) :-
    resolves_to_expected(informed_consent).
test(consent_without_information_resolves) :-
    resolves_to_expected(consent_without_information).
test(all_ways_failed_resolves) :-
    resolves_to_expected(all_ways_failed).
test(transmission_restores_permission_resolves) :-
    resolves_to_expected(transmission_restores_permission).
test(fewest_unresolved_first_resolves) :-
    resolves_to_expected(fewest_unresolved_first).
test(unsure_open_way_skipped_for_missing_resolves) :-
    resolves_to_expected(unsure_open_way_skipped_for_missing).
test(scope_unsure_missing_named_resolves) :-
    resolves_to_expected(scope_unsure_missing_named).
test(scope_unsure_settled_permitted_resolves) :-
    resolves_to_expected(scope_unsure_settled_permitted).
test(scope_unsure_settled_forbidden_resolves) :-
    resolves_to_expected(scope_unsure_settled_forbidden).
test(transmission_unsure_referred_resolves) :-
    resolves_to_expected(transmission_unsure_referred).
test(consent_unsure_referred_resolves) :-
    resolves_to_expected(consent_unsure_referred).
test(information_unsure_referred_resolves) :-
    resolves_to_expected(information_unsure_referred).
test(full_referral_row_resolves) :-
    resolves_to_expected(full_referral_row).
test(full_row_transmission_met_resolves) :-
    resolves_to_expected(full_row_transmission_met).
test(attested_value_resolves) :-
    resolves_to_expected(attested_value).
test(duplicate_scope_key_resolves) :-
    resolves_to_expected(duplicate_scope_key).
test(not_attribute_list_resolves) :-
    resolves_to_expected(not_attribute_list).
test(status_projection_on_a_fixture) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(all_ways_failed, Profile),
    findall(Status, eprivacy_art_5_3_terminal_equipment_status(Profile, Status), Statuses),
    Statuses == [not_permitted].
test(final_results_are_in_the_status_vocabulary) :-
    eprivacy_art_5_3_terminal_equipment_status_values(StatusValues),
    StatusValues == [permitted, not_permitted, not_applicable],
    findall(Result, expected(_, Result, [cite(eu_dir_2002_58_art_5_3)]), FinalResults),
    sort(FinalResults, DistinctFinalResults),
    msort(StatusValues, SortedStatusValues),
    DistinctFinalResults == SortedStatusValues.
test(every_fixture_is_resolvable) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(full_referral_row, Profile),
    eprivacy_art_5_3_terminal_equipment_decision_resolvable(Profile).
test(decide_wraps_the_called_contract) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(informed_consent, Profile),
    decide_eprivacy_art_5_3_terminal_equipment(Profile, eprivacy_art_5_3_terminal_equipment_verdict(permitted, [cite(eu_dir_2002_58_art_5_3)])).
test(provenance_constructor_records_a_clause_and_its_citations) :-
    findall(Clause - Citations, (Clause = art_5_3_referral, Citations = [cite(eu_dir_2002_58_art_5_3_s1)], provenance(Clause, Citations)), Answers),
    Answers == [art_5_3_referral - [cite(eu_dir_2002_58_art_5_3_s1)]].
test(provenance_may_follow_inputs_relied_on_in_a_referral_context) :-
    provenance(art_5_3_referral, [cite(eu_dir_2002_58_art_5_3_s1)]),
    needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on([storage_or_access_in_terminal_equipment - unsure]), provenance(art_5_3_referral, [cite(eu_dir_2002_58_art_5_3_s1)])]).
test(input_problems_constructor_accepts_a_problem_list) :-
    findall(true, input_problems([wrong_type(profile)]), Answers),
    Answers == [true].
test(unknown_key_constructor_accepts_a_key_outside_the_contract) :-
    findall(true, unknown_key(zzz), Answers),
    Answers == [true].
test(wrong_type_constructor_accepts_the_profile) :-
    findall(true, wrong_type(profile), Answers),
    Answers == [true].
test(wrong_type_constructor_accepts_a_contract_key) :-
    findall(true, wrong_type(user_consent_given), Answers),
    Answers == [true].
test(duplicate_key_constructor_accepts_a_contract_key) :-
    findall(true, duplicate_key(storage_or_access_in_terminal_equipment), Answers),
    Answers == [true].
test(indeterminate_constructor_accepts_one_missing_key) :-
    findall(true, indeterminate([storage_or_access_in_terminal_equipment]), Answers),
    Answers == [true].
test(inputs_relied_on_constructor_accepts_pairs_in_contract_order) :-
    findall(true, inputs_relied_on([storage_or_access_in_terminal_equipment - true, user_consent_given - unsure]), Answers),
    Answers == [true].
test(input_problems_constructor_called_with_a_ground_list) :-
    input_problems([duplicate_key(storage_or_access_in_terminal_equipment), unknown_key(zzz)]).
test(unknown_key_constructor_called_with_a_ground_key) :-
    unknown_key(not_a_key_of_the_contract).
test(wrong_type_constructor_called_with_a_ground_key) :-
    wrong_type(clear_and_comprehensive_information_provided).
test(duplicate_key_constructor_called_with_a_ground_key) :-
    duplicate_key(user_consent_given).
test(indeterminate_constructor_called_with_a_ground_list) :-
    indeterminate([strictly_necessary_to_provide_requested_service]).
test(inputs_relied_on_constructor_called_with_ground_pairs) :-
    inputs_relied_on([storage_or_access_in_terminal_equipment - true, storage_or_access_solely_for_transmission - unsure, user_consent_given - false]).
test(checklist_of_a_failed_profile_cites_every_row) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(all_ways_failed, Profile),
    eprivacy_art_5_3_terminal_equipment_checklist(Profile, Items),
    Items == [item(scope, met, cite(eu_dir_2002_58_art_5_3_s1)), item(transmission, unmet(way_failed), cite(eu_dir_2002_58_art_5_3_s2)), item(strictly_necessary, unmet(way_failed), cite(eu_dir_2002_58_art_5_3_s2)), item(consent, unmet(way_failed), cite(eu_dir_2002_58_art_5_3_s1))].
test(checklist_of_a_refused_profile_is_one_input_row) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(not_attribute_list, Profile),
    eprivacy_art_5_3_terminal_equipment_checklist(Profile, [item(input_check, unmet(input_problems([wrong_type(profile)])), cite(eu_dir_2002_58_art_5_3))]).
test(input_check_non_list_profile) :-
    findall(Problems, eprivacy_art_5_3_terminal_equipment_input_problems(not_a_profile, Problems), AllProblems),
    AllProblems == [[wrong_type(profile)]].
test(input_check_non_attribute_element) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([attribute(storage_or_access_in_terminal_equipment, true), foo], Problems),
    Problems == [wrong_type(profile)].
test(input_check_number_key_is_unknown) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(input_check_repeated_unknown_key_named_once) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([attribute(zzz, 1), attribute(zzz, 2)], Problems),
    Problems == [unknown_key(zzz)].
test(input_check_duplicate_with_differing_values_is_only_duplicate) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([attribute(user_consent_given, true), attribute(user_consent_given, maybe)], Problems),
    Problems == [duplicate_key(user_consent_given)].
test(input_check_contract_order_then_unknown) :-
    eprivacy_art_5_3_terminal_equipment_input_problems([attribute(zzz, 1), attribute(clear_and_comprehensive_information_provided, yes), attribute(storage_or_access_in_terminal_equipment, 1)], Problems),
    Problems == [wrong_type(storage_or_access_in_terminal_equipment), wrong_type(clear_and_comprehensive_information_provided), unknown_key(zzz)].
test(input_check_well_formed_fixture_has_no_problem) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(full_referral_row, Profile),
    eprivacy_art_5_3_terminal_equipment_input_problems(Profile, []).
test(input_check_partial_list) :-
    findall(Problems, eprivacy_art_5_3_terminal_equipment_input_problems([attribute(storage_or_access_in_terminal_equipment, true)|_Tail], Problems), AllProblems),
    AllProblems == [[wrong_type(profile)]].
test(input_check_unbound_element) :-
    findall(Problems, eprivacy_art_5_3_terminal_equipment_input_problems([_Element], Problems), AllProblems),
    AllProblems == [[wrong_type(profile)]].
test(input_check_unbound_profile) :-
    findall(Problems, eprivacy_art_5_3_terminal_equipment_input_problems(_Profile, Problems), AllProblems),
    AllProblems == [[wrong_type(profile)]].
test(input_check_unbound_value) :-
    findall(Problems, eprivacy_art_5_3_terminal_equipment_input_problems([attribute(storage_or_access_in_terminal_equipment, _Value)], Problems), AllProblems),
    AllProblems == [[wrong_type(storage_or_access_in_terminal_equipment)]].
test(what_if_flips_all_ways_failed_to_permitted) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(all_ways_failed, Profile),
    findall(Status, eprivacy_art_5_3_terminal_equipment_what_if(Profile, storage_or_access_solely_for_transmission, true, Status), Statuses),
    Statuses == [permitted].
test(what_if_scope_false_is_not_applicable) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(informed_consent, Profile),
    eprivacy_art_5_3_terminal_equipment_what_if(Profile, storage_or_access_in_terminal_equipment, false, not_applicable).

test(out_of_scope_is_not_permitted_status, fail) :-
    eprivacy_art_5_3_terminal_equipment_assess(out_of_scope, eprivacy_art_5_3_terminal_equipment_verdict(permitted, _)).
test(transmission_only_is_not_not_permitted, fail) :-
    eprivacy_art_5_3_terminal_equipment_assess(transmission_only, eprivacy_art_5_3_terminal_equipment_verdict(not_permitted, _)).
test(requested_but_not_strictly_necessary_is_not_permitted_status, fail) :-
    eprivacy_art_5_3_terminal_equipment_assess(requested_but_not_strictly_necessary, eprivacy_art_5_3_terminal_equipment_verdict(permitted, _)).
test(scope_unsure_settled_permitted_is_not_final, fail) :-
    eprivacy_art_5_3_terminal_equipment_assess(scope_unsure_settled_permitted, eprivacy_art_5_3_terminal_equipment_verdict(permitted, _)).
test(input_problems_constructor_rejects_an_empty_list, fail) :-
    input_problems([]).
test(unknown_key_constructor_rejects_a_contract_key, fail) :-
    unknown_key(user_consent_given).
test(wrong_type_constructor_rejects_a_key_outside_the_contract, fail) :-
    wrong_type(zzz).
test(duplicate_key_constructor_rejects_a_key_outside_the_contract, fail) :-
    duplicate_key(zzz).
test(indeterminate_constructor_rejects_two_keys, fail) :-
    indeterminate([storage_or_access_in_terminal_equipment, user_consent_given]).
test(inputs_relied_on_constructor_rejects_pairs_out_of_order, fail) :-
    inputs_relied_on([user_consent_given - unsure, storage_or_access_in_terminal_equipment - true]).
test(what_if_scope_false_is_not_permitted, fail) :-
    eprivacy_art_5_3_terminal_equipment_profile_for(informed_consent, Profile),
    eprivacy_art_5_3_terminal_equipment_what_if(Profile, storage_or_access_in_terminal_equipment, false, permitted).

cp_test_names([every_subject_has_an_expected_result, every_subject_resolves_to_its_expected_result, the_called_contract_agrees_on_every_subject, every_subject_answers_exactly_once, every_subject_has_a_non_empty_checklist, every_near_miss_control_gets_a_different_result, empty_profile_resolves, out_of_scope_resolves, scope_only_resolves, transmission_only_resolves, transmission_only_is_permitted, transmission_failed_alone_resolves, requested_and_strictly_necessary_resolves, requested_but_not_strictly_necessary_resolves, requested_but_not_strictly_necessary_is_not_permitted, informed_consent_resolves, consent_without_information_resolves, all_ways_failed_resolves, transmission_restores_permission_resolves, fewest_unresolved_first_resolves, unsure_open_way_skipped_for_missing_resolves, scope_unsure_missing_named_resolves, scope_unsure_settled_permitted_resolves, scope_unsure_settled_forbidden_resolves, transmission_unsure_referred_resolves, consent_unsure_referred_resolves, information_unsure_referred_resolves, full_referral_row_resolves, full_row_transmission_met_resolves, attested_value_resolves, duplicate_scope_key_resolves, not_attribute_list_resolves, status_projection_on_a_fixture, final_results_are_in_the_status_vocabulary, every_fixture_is_resolvable, decide_wraps_the_called_contract, provenance_constructor_records_a_clause_and_its_citations, provenance_may_follow_inputs_relied_on_in_a_referral_context, input_problems_constructor_accepts_a_problem_list, unknown_key_constructor_accepts_a_key_outside_the_contract, wrong_type_constructor_accepts_the_profile, wrong_type_constructor_accepts_a_contract_key, duplicate_key_constructor_accepts_a_contract_key, indeterminate_constructor_accepts_one_missing_key, inputs_relied_on_constructor_accepts_pairs_in_contract_order, input_problems_constructor_called_with_a_ground_list, unknown_key_constructor_called_with_a_ground_key, wrong_type_constructor_called_with_a_ground_key, duplicate_key_constructor_called_with_a_ground_key, indeterminate_constructor_called_with_a_ground_list, inputs_relied_on_constructor_called_with_ground_pairs, checklist_of_a_failed_profile_cites_every_row, checklist_of_a_refused_profile_is_one_input_row, input_check_non_list_profile, input_check_non_attribute_element, input_check_number_key_is_unknown, input_check_repeated_unknown_key_named_once, input_check_duplicate_with_differing_values_is_only_duplicate, input_check_contract_order_then_unknown, input_check_well_formed_fixture_has_no_problem, input_check_partial_list, input_check_unbound_element, input_check_unbound_profile, input_check_unbound_value, what_if_flips_all_ways_failed_to_permitted, what_if_scope_false_is_not_applicable]).
cp_test_fail_names([out_of_scope_is_not_permitted_status, transmission_only_is_not_not_permitted, requested_but_not_strictly_necessary_is_not_permitted_status, scope_unsure_settled_permitted_is_not_final, input_problems_constructor_rejects_an_empty_list, unknown_key_constructor_rejects_a_contract_key, wrong_type_constructor_rejects_a_key_outside_the_contract, duplicate_key_constructor_rejects_a_key_outside_the_contract, indeterminate_constructor_rejects_two_keys, inputs_relied_on_constructor_rejects_pairs_out_of_order, what_if_scope_false_is_not_permitted]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
