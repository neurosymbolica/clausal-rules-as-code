:- module(m__eu_procurement_time_limits_tests_test_conformity, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_time_limits_time_limits, [decide_time_limits/2, time_limits_conformity/2, time_limits_status/2, minimum_days/2, time_limits_conformity_values/1]).
:- use_module(m__eu_procurement_time_limits_fixtures, [time_limits_profile_for/2]).
:- use_module(formalize_lib, [not_member/2]).

time_limits_conformity_never(Profile, Conformity) :-
    findall(Found, time_limits_conformity(Profile, Found), FoundConformities),
    not_member(Conformity, FoundConformities).

test('a notice 15 days short of the Art 27(1) minimum is a breach') :-
    time_limits_profile_for("open_tenders_baseline_allowing_20", Profile),
    minimum_days(Profile, 35),
    time_limits_conformity(Profile, shorter_than_prescribed_minimum),
    time_limits_conformity_never(Profile, meets_prescribed_minimum),
    time_limits_conformity_never(Profile, observed_days_not_supplied),
    time_limits_conformity_never(Profile, no_prescribed_minimum_to_meet).
test('exactly the published figure complies; one day fewer does not') :-
    time_limits_profile_for("open_tenders_baseline_allowing_35", AtMinimum),
    time_limits_conformity(AtMinimum, meets_prescribed_minimum),
    time_limits_conformity_never(AtMinimum, shorter_than_prescribed_minimum),
    time_limits_profile_for("open_tenders_baseline_allowing_34", OneShort),
    time_limits_conformity(OneShort, shorter_than_prescribed_minimum),
    time_limits_conformity_never(OneShort, meets_prescribed_minimum).
test('the same 20 days breach at the base and comply under Art 27(2)') :-
    time_limits_profile_for("open_tenders_baseline_allowing_20", AtBase),
    time_limits_conformity(AtBase, shorter_than_prescribed_minimum),
    time_limits_profile_for("open_tenders_prior_notice_allowing_20", Reduced),
    minimum_days(Reduced, 15),
    time_limits_conformity(Reduced, meets_prescribed_minimum),
    time_limits_conformity_never(Reduced, shorter_than_prescribed_minimum).
test('a subject with no observed day count is neither compliant nor in breach') :-
    time_limits_profile_for("open_tenders_baseline", Profile),
    time_limits_status(Profile, minimum_days_prescribed),
    time_limits_conformity(Profile, observed_days_not_supplied),
    time_limits_conformity_never(Profile, meets_prescribed_minimum),
    time_limits_conformity_never(Profile, shorter_than_prescribed_minimum).
test('EVERY prescribed-minimum subject without a day count says so, and claims nothing') :-
    findall(S, no_days_supplied_subject(S), Subjects),
    length(Subjects, 16),
    findall(S, (no_days_supplied_subject(S), time_limits_profile_for(S, Profile), time_limits_conformity(Profile, observed_days_not_supplied)), Unsupplied),
    length(Unsupplied, 16),
    findall(S, (no_days_supplied_subject(S), time_limits_profile_for(S, Profile), time_limits_conformity(Profile, meets_prescribed_minimum)), ClaimedCompliant),
    ClaimedCompliant = [].
test('no prescribed minimum stays no prescribed minimum, day count or not') :-
    time_limits_profile_for("dialogue_tenders_allowing_20", WithDays),
    time_limits_status(WithDays, no_minimum_prescribed),
    time_limits_conformity(WithDays, no_prescribed_minimum_to_meet),
    time_limits_conformity_never(WithDays, meets_prescribed_minimum),
    time_limits_conformity_never(WithDays, shorter_than_prescribed_minimum),
    time_limits_profile_for("dialogue_tenders", WithoutDays),
    time_limits_conformity(WithoutDays, no_prescribed_minimum_to_meet),
    time_limits_conformity_never(WithoutDays, meets_prescribed_minimum).
test('a stage the Directive does not provide for claims no conformity either') :-
    time_limits_profile_for("open_participation_requests", Profile),
    time_limits_status(Profile, stage_not_applicable),
    time_limits_conformity(Profile, no_prescribed_minimum_to_meet),
    time_limits_conformity_never(Profile, meets_prescribed_minimum),
    time_limits_conformity_never(Profile, shorter_than_prescribed_minimum).
test('every fixture yields exactly one conformity answer') :-
    findall(S, (time_limits_profile_for(S, Profile), findall(C, time_limits_conformity(Profile, C), Conformities), length(Conformities, ConformityCount), dif(ConformityCount, 1)), Ambiguous),
    Ambiguous = [].
test('a non-numeric day count yields no verdict rather than a wrong one') :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false, observed_time_limit_days - open_procedure]),
    findall(Verdict, decide_time_limits(Profile, Verdict), []),
    time_limits_conformity_never(Profile, meets_prescribed_minimum),
    time_limits_conformity_never(Profile, observed_days_not_supplied).
test('Art 28: 12 days breach the 30-day base and comply under Art 28(6)(b)') :-
    dict_pairs(Base, [procedure_type_key - restricted_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false, observed_time_limit_days - 12]),
    minimum_days(Base, 30),
    time_limits_conformity(Base, shorter_than_prescribed_minimum),
    dict_pairs(Urgent, [procedure_type_key - restricted_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - true, observed_time_limit_days - 12]),
    minimum_days(Urgent, 10),
    time_limits_conformity(Urgent, meets_prescribed_minimum).
test('the CONFORMITY slot travels on the verdict term itself') :-
    time_limits_profile_for("open_tenders_baseline_allowing_20", Profile),
    decide_time_limits(Profile, Verdict),
    Verdict = time_limits_verdict(Status, MinimumDays, Conformity, Citations),
    Status = minimum_days_prescribed,
    MinimumDays #= 35,
    Conformity = shorter_than_prescribed_minimum,
    dif(Citations, []),
    time_limits_conformity_values(ConformityValues),
    member(Conformity, ConformityValues).

no_days_supplied_subject(Subject) :-
    member(Subject, ["open_tenders_baseline", "open_tenders_prior_information_notice", "open_tenders_electronic_submission", "open_tenders_urgency", "open_tenders_prior_notice_and_electronic", "restricted_requests_baseline", "restricted_requests_urgency", "restricted_tenders_baseline", "restricted_tenders_prior_information_notice", "restricted_tenders_electronic_submission", "restricted_tenders_urgency", "negotiation_requests_urgency", "negotiation_tenders_electronic_submission", "dialogue_requests_baseline", "dialogue_requests_urgency_claimed", "partnership_requests_baseline"]).

cp_test_names(['a notice 15 days short of the Art 27(1) minimum is a breach', 'exactly the published figure complies; one day fewer does not', 'the same 20 days breach at the base and comply under Art 27(2)', 'a subject with no observed day count is neither compliant nor in breach', 'EVERY prescribed-minimum subject without a day count says so, and claims nothing', 'no prescribed minimum stays no prescribed minimum, day count or not', 'a stage the Directive does not provide for claims no conformity either', 'every fixture yields exactly one conformity answer', 'a non-numeric day count yields no verdict rather than a wrong one', 'Art 28: 12 days breach the 30-day base and comply under Art 28(6)(b)', 'the CONFORMITY slot travels on the verdict term itself']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
