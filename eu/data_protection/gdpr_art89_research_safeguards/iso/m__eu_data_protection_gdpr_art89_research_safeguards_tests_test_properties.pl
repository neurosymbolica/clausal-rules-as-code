% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art89_research_safeguards_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_safeguards_status, [decide_safeguards_status/2, safeguards_status/2, unmet_requirements/2]).
:- use_module(m__eu_data_protection_gdpr_art89_research_safeguards_fixtures, [gdpr_art89_research_safeguards_subject/1, gdpr_art89_research_safeguards_profile_for/2, gdpr_art89_research_safeguards_assess/2]).

subject_classifies(Subject) :-
    gdpr_art89_research_safeguards_subject(Subject),
    gdpr_art89_research_safeguards_profile_for(Subject, Profile),
    decide_safeguards_status(Profile, _Verdict).

subject_verdict_count(Subject, Count) :-
    gdpr_art89_research_safeguards_subject(Subject),
    findall(Verdict, gdpr_art89_research_safeguards_assess(Subject, Verdict), Verdicts),
    length(Verdicts, Count).

subject_status_count(Subject, Count) :-
    gdpr_art89_research_safeguards_subject(Subject),
    gdpr_art89_research_safeguards_profile_for(Subject, Profile),
    findall(Status, safeguards_status(Profile, Status), Statuses),
    length(Statuses, Count).

subject_unmet_count(Subject, Count) :-
    gdpr_art89_research_safeguards_subject(Subject),
    gdpr_art89_research_safeguards_profile_for(Subject, Profile),
    findall(Unmet, unmet_requirements(Profile, Unmet), UnmetLists),
    length(UnmetLists, Count).

verdict_shape(gdpr_art89_verdict(in_accordance, [], [cite(eu_reg_2016_679_art_89_1)])).
verdict_shape(gdpr_art89_verdict(not_in_accordance, [_|_], [cite(eu_reg_2016_679_art_89_1)])).
verdict_shape(gdpr_art89_verdict(not_applicable, [], [])).
verdict_shape(gdpr_art89_verdict(indeterminate([_|_]), [], [])).
verdict_shape(gdpr_art89_verdict(needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on([_|_])]), [], [])).
verdict_shape(gdpr_art89_verdict(input_problems([_|_]), [], [])).

subject_shape_holds(Subject) :-
    gdpr_art89_research_safeguards_subject(Subject),
    gdpr_art89_research_safeguards_assess(Subject, Verdict),
    verdict_shape(Verdict).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_art89_research_safeguards_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    findall(Count, subject_verdict_count(_, Count), Counts),
    sort(Counts, [1]).
test(determinism_every_subject_has_exactly_one_status) :-
    findall(Count, subject_status_count(_, Count), Counts),
    sort(Counts, [1]).
test(determinism_every_subject_has_exactly_one_unmet_list) :-
    findall(Count, subject_unmet_count(_, Count), Counts),
    sort(Counts, [1]).
test(every_verdict_has_a_contract_shape) :-
    findall(Subject, gdpr_art89_research_safeguards_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_shape_holds(Subject), ShapedSubjects),
    sort(ShapedSubjects, SubjectSet).
test(the_subject_set_is_not_empty) :-
    findall(Subject, gdpr_art89_research_safeguards_subject(Subject), Subjects),
    Subjects = [_|_].

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, determinism_every_subject_has_exactly_one_status, determinism_every_subject_has_exactly_one_unmet_list, every_verdict_has_a_contract_shape, the_subject_set_is_not_empty]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
