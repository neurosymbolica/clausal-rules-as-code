% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_territorial_material_scope_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_gdpr_applies, [gdpr_applies/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_gdpr_scope_ground, [gdpr_scope_ground/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_representative_requirement, [representative_requirement/2]).
:- use_module(m__eu_data_protection_gdpr_territorial_material_scope_fixtures, [gdpr_territorial_material_scope_subject/1, gdpr_territorial_material_scope_profile_for/2, gdpr_territorial_material_scope_assess/2]).

all_subjects(Subjects) :-
    findall(Subject, gdpr_territorial_material_scope_subject(Subject), Collected),
    sort(Collected, Subjects).

verdict_count(Subject, Count) :-
    findall(Verdict, gdpr_territorial_material_scope_assess(Subject, Verdict), Verdicts),
    length(Verdicts, Count).

relations_agree(Subject) :-
    gdpr_territorial_material_scope_profile_for(Subject, Profile),
    gdpr_territorial_material_scope_assess(Subject, gdpr_scope_verdict(Applies, Ground, Representative, _Citations)),
    gdpr_applies(Profile, Applies),
    gdpr_scope_ground(Profile, Ground),
    representative_requirement(Profile, Representative).

citations_unique(Subject) :-
    gdpr_territorial_material_scope_assess(Subject, gdpr_scope_verdict(_, _, _, Citations)),
    sort(Citations, Sorted),
    length(Citations, Count),
    length(Sorted, Count).

ground_names_a_limb(Subject) :-
    gdpr_territorial_material_scope_assess(Subject, gdpr_scope_verdict(applies, Ground, _, _)),
    member(Ground, [art3_1, art3_2_a, art3_2_b, art3_3]).

test(totality_and_determinism_exactly_one_verdict_each) :-
    findall(Subject - Count, (gdpr_territorial_material_scope_subject(Subject), verdict_count(Subject, Count)), Pairs),
    findall(Subject - 1, gdpr_territorial_material_scope_subject(Subject), Expected),
    Pairs == Expected.
test(the_subject_registry_is_not_empty) :-
    all_subjects([_|_]).
test(field_relations_agree_with_the_package_verdict) :-
    all_subjects(Subjects),
    findall(Subject, (gdpr_territorial_material_scope_subject(Subject), relations_agree(Subject)), Agreeing),
    sort(Agreeing, Subjects).
test(citations_never_repeat) :-
    all_subjects(Subjects),
    findall(Subject, (gdpr_territorial_material_scope_subject(Subject), citations_unique(Subject)), Unique),
    sort(Unique, Subjects).
test(citations_are_non_empty_unless_the_input_is_refused) :-
    all_subjects(Subjects),
    findall(Subject, (gdpr_territorial_material_scope_subject(Subject), gdpr_territorial_material_scope_assess(Subject, gdpr_scope_verdict(_, _, _, [_|_]))), WithCitations),
    findall(Subject, (gdpr_territorial_material_scope_subject(Subject), gdpr_territorial_material_scope_assess(Subject, gdpr_scope_verdict(input_problems(_), _, _, _))), Refused),
    append(WithCitations, Refused, Both),
    sort(Both, Subjects).
test(applies_always_names_an_art3_limb) :-
    findall(Subject, (gdpr_territorial_material_scope_subject(Subject), gdpr_territorial_material_scope_assess(Subject, gdpr_scope_verdict(applies, _, _, _))), Applying),
    findall(Subject, (gdpr_territorial_material_scope_subject(Subject), ground_names_a_limb(Subject)), Named),
    Applying == Named.
test(a_non_application_never_carries_a_representative_duty) :-
    findall(Representative, (gdpr_territorial_material_scope_subject(Subject), gdpr_territorial_material_scope_assess(Subject, gdpr_scope_verdict(does_not_apply, _, Representative, _))), Representatives),
    sort(Representatives, [not_applicable]).

cp_test_names([totality_and_determinism_exactly_one_verdict_each, the_subject_registry_is_not_empty, field_relations_agree_with_the_package_verdict, citations_never_repeat, citations_are_non_empty_unless_the_input_is_refused, applies_always_names_an_art3_limb, a_non_application_never_carries_a_representative_duty]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
