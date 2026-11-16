% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_scope_entity_class_tests_test_constructor_atoms, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_scope_entity_class_nis2_scope_entity_class, [nis2_scope_entity_class_status/2, entity_class/3]).
:- use_module(m__eu_nis2_scope_entity_class_fixtures, [nis2_scope_entity_class_profile_for/2]).
:- use_module(m__eu_nis2_scope_entity_class_queries, [nis2_scope_entity_class_what_if/4]).
:- use_module(m__eu_nis2_scope_entity_class_kernel, [nis2_scope_entity_class_input_problems/2]).

test(qualified_trust_service_provider_is_in_scope_and_essential) :-
    nis2_scope_entity_class_profile_for(non_qualified_trust_provider, Profile),
    nis2_scope_entity_class_what_if(Profile, trust_service_provider_status, qualified_trust_service_provider, eligible),
    nis2_scope_entity_class_profile_for(qualified_trust_provider, QualifiedProfile),
    entity_class(QualifiedProfile, Class, _),
    Class == essential_entity.
test(qualified_trust_service_provider_value_is_well_typed) :-
    nis2_scope_entity_class_input_problems([attribute(trust_service_provider_status, qualified_trust_service_provider)], Problems),
    Problems == [].
test(non_qualified_trust_service_provider_is_in_scope_and_important) :-
    nis2_scope_entity_class_profile_for(qualified_trust_provider, Profile),
    nis2_scope_entity_class_what_if(Profile, trust_service_provider_status, non_qualified_trust_service_provider, eligible),
    nis2_scope_entity_class_profile_for(non_qualified_trust_provider, NonQualifiedProfile),
    entity_class(NonQualifiedProfile, Class, _),
    Class == important_entity.
test(non_qualified_trust_service_provider_value_is_well_typed) :-
    nis2_scope_entity_class_input_problems([attribute(trust_service_provider_status, non_qualified_trust_service_provider)], Problems),
    Problems == [].
test(a_made_up_trust_status_is_a_wrong_type) :-
    nis2_scope_entity_class_input_problems([attribute(trust_service_provider_status, semi_qualified)], Problems),
    Problems == [wrong_type(trust_service_provider_status)].
test(regional_with_risk_assessed_services_is_in_scope_and_important) :-
    nis2_scope_entity_class_profile_for(central_government, Profile),
    nis2_scope_entity_class_what_if(Profile, public_administration_kind, regional_with_risk_assessed_services, eligible),
    nis2_scope_entity_class_profile_for(regional_government, RegionalProfile),
    entity_class(RegionalProfile, Class, _),
    Class == important_entity.
test(regional_with_risk_assessed_services_value_is_well_typed) :-
    nis2_scope_entity_class_input_problems([attribute(public_administration_kind, regional_with_risk_assessed_services)], Problems),
    Problems == [].
test(provenance_constructor_destructures) :-
    Item = provenance(g1, [cite(eu_dir_2022_2555_art_2_3)]),
    Item = provenance(Clause, Citations),
    Clause == g1,
    Citations == [cite(eu_dir_2022_2555_art_2_3)].
test(provenance_rides_after_inputs_relied_on) :-
    Context = [inputs_relied_on([annex_i_type - unsure]), provenance(g13, [cite(eu_dir_2022_2555_art_2_1)])],
    Context = [inputs_relied_on(Pairs), provenance(Clause, Citations)],
    Pairs == [annex_i_type - unsure],
    Clause == g13,
    Citations == [cite(eu_dir_2022_2555_art_2_1)].

test(regional_kind_is_not_ineligible, fail) :-
    nis2_scope_entity_class_profile_for(regional_government, Profile),
    nis2_scope_entity_class_status(Profile, ineligible).

cp_test_names([qualified_trust_service_provider_is_in_scope_and_essential, qualified_trust_service_provider_value_is_well_typed, non_qualified_trust_service_provider_is_in_scope_and_important, non_qualified_trust_service_provider_value_is_well_typed, a_made_up_trust_status_is_a_wrong_type, regional_with_risk_assessed_services_is_in_scope_and_important, regional_with_risk_assessed_services_value_is_well_typed, provenance_constructor_destructures, provenance_rides_after_inputs_relied_on]).
cp_test_fail_names([regional_kind_is_not_ineligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
