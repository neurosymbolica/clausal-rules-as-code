% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_territorial_material_scope_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_gdpr_applies, [gdpr_applies/2, gdpr_applies_status/2, scope_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_gdpr_scope_ground, [gdpr_scope_ground/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_representative_requirement, [representative_requirement/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_queries, [decide_gdpr_scope/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_kernel, [gdpr_territorial_material_scope_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_fixtures, [gdpr_territorial_material_scope_profile_for/2]).

test(applies_with_the_verdict_bound) :-
    gdpr_territorial_material_scope_profile_for(eu_controller_in_context, Profile),
    gdpr_applies_status(Profile, applies).
test(ground_with_the_ground_bound) :-
    gdpr_territorial_material_scope_profile_for(non_eu_monitoring, Profile),
    gdpr_scope_ground(Profile, art3_2_b).
test(representative_with_the_answer_bound) :-
    gdpr_territorial_material_scope_profile_for(non_eu_monitoring, Profile),
    representative_requirement(Profile, required).
test(full_verdict_bound_for_an_eu_controller) :-
    gdpr_territorial_material_scope_profile_for(eu_controller_in_context, Profile),
    decide_gdpr_scope(Profile, gdpr_scope_verdict(applies, art3_1, not_applicable, [cite(eu_reg_2016_679_art_2_1), cite(eu_reg_2016_679_art_3_1)])).
test(full_verdict_bound_for_an_outside_union_law_activity) :-
    gdpr_territorial_material_scope_profile_for(outside_union_law, Profile),
    decide_gdpr_scope(Profile, gdpr_scope_verdict(does_not_apply, art2_2_a, not_applicable, [cite(eu_reg_2016_679_art_2_2_a)])).
test(outside_fact_attested_is_copied) :-
    gdpr_territorial_material_scope_profile_for(public_international_law_place, Profile),
    scope_outside_facts(Profile, [outside_fact(member_state_law_applies_by_public_international_law, attested(true, attestation(decision_layer, fixture_time, fixture_reason, none)))]).
test(outside_fact_absent_is_named) :-
    gdpr_territorial_material_scope_profile_for(public_international_law_not_attested, Profile),
    scope_outside_facts(Profile, [outside_fact(member_state_law_applies_by_public_international_law, absent)]).
test(a_well_formed_profile_has_no_problem) :-
    gdpr_territorial_material_scope_profile_for(eu_controller_in_context, Profile),
    gdpr_territorial_material_scope_input_problems(Profile, []).
test(an_empty_profile_is_well_formed) :-
    gdpr_territorial_material_scope_input_problems([], []).
test(a_non_list_is_not_a_profile) :-
    gdpr_territorial_material_scope_input_problems(foo, [wrong_type(profile)]).
test(an_unknown_key_is_named) :-
    gdpr_territorial_material_scope_profile_for(unknown_key_given, Profile),
    gdpr_territorial_material_scope_input_problems(Profile, [unknown_key(place_of_processing)]).
test(a_wrong_type_is_named) :-
    gdpr_territorial_material_scope_profile_for(wrong_type_given, Profile),
    gdpr_territorial_material_scope_input_problems(Profile, [wrong_type(established_in_union)]).
test(unsure_is_wrong_type_for_a_crisp_key) :-
    gdpr_territorial_material_scope_input_problems([attribute(established_in_union, unsure)], [wrong_type(established_in_union)]).
test(unsure_is_fine_for_a_judgement_key) :-
    gdpr_territorial_material_scope_input_problems([attribute(occasional_processing, unsure)], []).
test(a_bad_party_role_is_wrong_type) :-
    gdpr_territorial_material_scope_input_problems([attribute(party_role, joint_controller)], [wrong_type(party_role)]).
test(a_bare_outside_fact_is_wrong_type) :-
    gdpr_territorial_material_scope_input_problems([attribute(member_state_law_applies_by_public_international_law, true)], [wrong_type(member_state_law_applies_by_public_international_law)]).
test(a_duplicate_key_is_named_once_and_never_also_wrong_type) :-
    gdpr_territorial_material_scope_input_problems([attribute(party_role, controller), attribute(party_role, bogus)], [duplicate_key(party_role)]).
test(problems_order_contract_keys_then_unknown_keys) :-
    gdpr_territorial_material_scope_input_problems([attribute(zzz, 1), attribute(established_in_union, maybe), attribute(aaa, 2), attribute(zzz, 3)], [wrong_type(established_in_union), unknown_key(zzz), unknown_key(aaa)]).
test(input_problems_verdict_is_bound) :-
    gdpr_territorial_material_scope_profile_for(unknown_key_given, Profile),
    decide_gdpr_scope(Profile, gdpr_scope_verdict(input_problems([unknown_key(place_of_processing)]), none, not_reached, [])).
test(input_problems_give_the_fixed_field_answers) :-
    gdpr_territorial_material_scope_profile_for(wrong_type_given, Profile),
    gdpr_applies(Profile, input_problems([wrong_type(established_in_union)])),
    gdpr_scope_ground(Profile, none),
    representative_requirement(Profile, not_reached),
    scope_outside_facts(Profile, input_problems([wrong_type(established_in_union)])).

test(the_wrong_bound_status_is_rejected, fail) :-
    gdpr_territorial_material_scope_profile_for(eu_controller_in_context, Profile),
    gdpr_applies_status(Profile, does_not_apply).

cp_test_names([applies_with_the_verdict_bound, ground_with_the_ground_bound, representative_with_the_answer_bound, full_verdict_bound_for_an_eu_controller, full_verdict_bound_for_an_outside_union_law_activity, outside_fact_attested_is_copied, outside_fact_absent_is_named, a_well_formed_profile_has_no_problem, an_empty_profile_is_well_formed, a_non_list_is_not_a_profile, an_unknown_key_is_named, a_wrong_type_is_named, unsure_is_wrong_type_for_a_crisp_key, unsure_is_fine_for_a_judgement_key, a_bad_party_role_is_wrong_type, a_bare_outside_fact_is_wrong_type, a_duplicate_key_is_named_once_and_never_also_wrong_type, problems_order_contract_keys_then_unknown_keys, input_problems_verdict_is_bound, input_problems_give_the_fixed_field_answers]).
cp_test_fail_names([the_wrong_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
