% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_gdpr_cooperation_with_the_supervisory_authority, [cooperation_duty/4, decide_gdpr_cooperation_with_the_supervisory_authority/2, gdpr_cooperation_with_the_supervisory_authority_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_cooperation_with_the_supervisory_authority_fixtures, [gdpr_cooperation_with_the_supervisory_authority_subject/1, gdpr_cooperation_with_the_supervisory_authority_profile_for/2]).

subject_classifies(Subject) :-
    gdpr_cooperation_with_the_supervisory_authority_subject(Subject),
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    decide_gdpr_cooperation_with_the_supervisory_authority(Profile, _Verdict).

answer_count(Profile, Count) :-
    findall(Result, cooperation_duty(Profile, Result, _, _), Results),
    length(Results, Count).

subject_answer_count(Subject, Count) :-
    gdpr_cooperation_with_the_supervisory_authority_profile_for(Subject, Profile),
    answer_count(Profile, Count).

crisp_choice(absent).
crisp_choice(given(true)).
crisp_choice(given(false)).

judgement_choice(absent).
judgement_choice(given(true)).
judgement_choice(given(false)).
judgement_choice(given(unsure)).

statement_choice(absent).
statement_choice(given(attested(true, attestation(host, at_time, reason, none)))).
statement_choice(given(attested(false, attestation(host, at_time, reason, document(upload_identifier, digest_value))))).

choices_profile([], []).
choices_profile([_ - absent|Choices], Profile) :-
    choices_profile(Choices, Profile).
choices_profile([ProfileKey - given(Value)|Choices], [attribute(ProfileKey, Value)|Profile]) :-
    choices_profile(Choices, Profile).

generated_profile(Profile) :-
    crisp_choice(Controller),
    crisp_choice(Processor),
    crisp_choice(Representative),
    crisp_choice(Request),
    judgement_choice(Tasks),
    statement_choice(Statement),
    choices_profile([acts_as_controller - Controller, acts_as_processor - Processor, acts_as_representative_of_controller_or_processor - Representative, authority_request_made - Request, request_is_in_performance_of_authority_tasks - Tasks, cooperation_given - Statement], Profile).

answer_shape_consistent(Result, Basis, Citations) :-
    gdpr_cooperation_with_the_supervisory_authority_status_values(StatusValues),
    member(Result, StatusValues),
    Citations == [cite(eu_reg_2016_679_art_31)],
    final_basis(Result, Basis).
answer_shape_consistent(Result, [], []) :-
    compound(Result).

final_basis(cooperation_not_required, []).
final_basis(cooperation_met, [outside_fact(cooperation_given, attested(true, attestation(_, _, _, _)))]).
final_basis(cooperation_not_met, [outside_fact(cooperation_given, attested(false, attestation(_, _, _, _)))]).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_cooperation_with_the_supervisory_authority_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_answer) :-
    findall(Subject, gdpr_cooperation_with_the_supervisory_authority_subject(Subject), Subjects),
    findall(Subject, (gdpr_cooperation_with_the_supervisory_authority_subject(Subject), subject_answer_count(Subject, 1)), Determined),
    Determined == Subjects.
test(the_generator_builds_every_combination) :-
    findall(Profile, generated_profile(Profile), Profiles),
    length(Profiles, 972).
test(every_well_formed_profile_has_exactly_one_answer) :-
    findall(Profile, generated_profile(Profile), Profiles),
    findall(Profile, (member(Profile, Profiles), answer_count(Profile, 1)), Determined),
    length(Determined, 972).
test(every_answer_has_the_shape_of_its_status) :-
    findall(Profile, (generated_profile(Profile), cooperation_duty(Profile, Result, Basis, Citations), answer_shape_consistent(Result, Basis, Citations)), Consistent),
    length(Consistent, 972).
test(no_request_never_imposes_a_duty) :-
    findall(Profile, (generated_profile(Profile), member(attribute(authority_request_made, false), Profile)), NoRequestProfiles),
    length(NoRequestProfiles, Count),
    findall(Profile, (member(Profile, NoRequestProfiles), cooperation_duty(Profile, cooperation_not_required, [], [cite(eu_reg_2016_679_art_31)])), NotRequired),
    length(NotRequired, Count),
    Count == 324.

test(no_well_formed_profile_has_an_input_problem, fail) :-
    generated_profile(Profile),
    cooperation_duty(Profile, input_problems(_), _, _).
test(the_outside_fact_is_never_named_missing, fail) :-
    generated_profile(Profile),
    cooperation_duty(Profile, indeterminate([cooperation_given]), _, _).
test(a_missing_key_list_names_exactly_one_key, fail) :-
    generated_profile(Profile),
    cooperation_duty(Profile, indeterminate([_, _|_]), _, _).
test(an_attested_true_never_gives_not_met, fail) :-
    generated_profile(Profile),
    member(attribute(cooperation_given, attested(true, _)), Profile),
    cooperation_duty(Profile, cooperation_not_met, _, _).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_answer, the_generator_builds_every_combination, every_well_formed_profile_has_exactly_one_answer, every_answer_has_the_shape_of_its_status, no_request_never_imposes_a_duty]).
cp_test_fail_names([no_well_formed_profile_has_an_input_problem, the_outside_fact_is_never_named_missing, a_missing_key_list_names_exactly_one_key, an_attested_true_never_gives_not_met]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
