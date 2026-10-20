:- module(m__eu_procurement_time_limits_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_time_limits_time_limits, [decide_time_limits/2, time_limits_status/2, minimum_days/2, time_limits_conformity/2, time_limits_checklist/2, time_limits_decision_resolvable/1, time_limits_status_values/1, time_limits_conformity_values/1]).
:- use_module(m__eu_procurement_time_limits_queries, [time_limits_floor/3]).
:- use_module(m__eu_procurement_time_limits_fixtures, [time_limits_subject/1, time_limits_profile_for/2, time_limits_assess/2]).
:- use_module(formalize_lib, [not_member/2]).

time_limits_conformity_never(Profile, Conformity) :-
    findall(Found, time_limits_conformity(Profile, Found), FoundConformities),
    not_member(Conformity, FoundConformities).

test('public interface resolves on every registered subject') :-
    findall(Subject, time_limits_subject(Subject), SubjectList),
    length(SubjectList, SubjectCount),
    SubjectCount #= 24,
    findall(Subject, (time_limits_subject(Subject), findall(time_limits_verdict(Status, MinimumDays, Conformity, Citations), time_limits_assess(Subject, time_limits_verdict(Status, MinimumDays, Conformity, Citations)), [_|_])), AssessedSubjectList),
    length(AssessedSubjectList, SubjectCount).
test('every assessed status is in the exported closed vocabulary') :-
    time_limits_status_values(StatusValues),
    findall(Subject, (time_limits_subject(Subject), time_limits_assess(Subject, time_limits_verdict(Status, _, _, _)), not_member(Status, StatusValues)), []).
test('decision facade: checklist + resolvable hold via the package surface') :-
    time_limits_profile_for("open_tenders_baseline", Profile),
    time_limits_decision_resolvable(Profile),
    time_limits_checklist(Profile, Checklist),
    length(Checklist, 1),
    member(item(_, minimum_days_prescribed, _), Checklist).
test('an ad-hoc profile built from re-exported atoms resolves') :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - true, state_of_urgency_substantiated - false]),
    minimum_days(Profile, 30),
    time_limits_status(Profile, minimum_days_prescribed).
test('floor query is exported: restricted tenders floor to 10 days') :-
    time_limits_floor(restricted_procedure, receipt_of_tenders, 10).
test('every assessed conformity is in the exported closed vocabulary') :-
    time_limits_conformity_values(ConformityValues),
    findall(Subject, (time_limits_subject(Subject), time_limits_assess(Subject, time_limits_verdict(_, _, Conformity, _)), not_member(Conformity, ConformityValues)), []).
test('public interface: an ad-hoc profile decides conformity both ways') :-
    dict_pairs(ShortProfile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false, observed_time_limit_days - 20]),
    time_limits_conformity(ShortProfile, shorter_than_prescribed_minimum),
    time_limits_conformity_never(ShortProfile, meets_prescribed_minimum),
    dict_pairs(LawfulProfile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - true, electronic_submission_accepted - false, state_of_urgency_substantiated - false, observed_time_limit_days - 20]),
    time_limits_conformity(LawfulProfile, meets_prescribed_minimum),
    time_limits_conformity_never(LawfulProfile, shorter_than_prescribed_minimum).
test('public interface: an unsupplied day count is named, never assumed') :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]),
    time_limits_conformity(Profile, observed_days_not_supplied),
    time_limits_conformity_never(Profile, meets_prescribed_minimum),
    time_limits_conformity_never(Profile, shorter_than_prescribed_minimum),
    time_limits_conformity_never(Profile, no_prescribed_minimum_to_meet).

cp_test_names(['public interface resolves on every registered subject', 'every assessed status is in the exported closed vocabulary', 'decision facade: checklist + resolvable hold via the package surface', 'an ad-hoc profile built from re-exported atoms resolves', 'floor query is exported: restricted tenders floor to 10 days', 'every assessed conformity is in the exported closed vocabulary', 'public interface: an ad-hoc profile decides conformity both ways', 'public interface: an unsupplied day count is named, never assumed']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
