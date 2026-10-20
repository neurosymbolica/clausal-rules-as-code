:- module(m__eu_procurement_time_limits_tests_test_robustness, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(library(clpz)).
:- use_module(m__eu_procurement_time_limits_time_limits, [decide_time_limits/2, time_limits_decision_resolvable/1, time_limits_input_problem/2, time_limits_input_acceptable/1, time_limits_checklist/2]).
:- use_module(m__eu_procurement_time_limits_fixtures, [time_limits_subject/1, time_limits_profile_for/2]).
:- use_module(m__eu_procurement_time_limits_queries, [time_limits_what_if/4]).
:- use_module(query_combinators, [override_key/4]).

decision_outcome(Profile, Outcome) :-
    catch((findall(Verdict, decide_time_limits(Profile, Verdict), Verdicts), Outcome = answers(Verdicts)), Error, Outcome = raised(Error)).

outcome_without_verdicts(answers([])).
outcome_without_verdicts(raised(_)).

gives_no_verdict(Profile) :-
    decision_outcome(Profile, Outcome),
    Outcome = answers([]).

open_tenders_profile(Pin, Electronic, Urgency, Profile) :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - Pin, electronic_submission_accepted - Electronic, state_of_urgency_substantiated - Urgency]).

open_tenders_profile_observing(Days, Profile) :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false, observed_time_limit_days - Days]).

test('dropping procedure type raises an unguarded dict key existence error instead of giving no verdict') :-
    dict_pairs(Profile, [stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]),
    gives_no_verdict(Profile).
test('dropping stage raises an unguarded dict key existence error instead of giving no verdict') :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]),
    gives_no_verdict(Profile).
test('default: an absent prior information notice flag reads as not published') :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, electronic_submission_accepted - false, state_of_urgency_substantiated - false]),
    decide_time_limits(Profile, Verdict),
    Verdict = time_limits_verdict(minimum_days_prescribed, 35, observed_days_not_supplied, [cite(eu_dir_2014_24_art_27)]).
test('default: an absent electronic submission flag reads as not accepted') :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, state_of_urgency_substantiated - false]),
    decide_time_limits(Profile, Verdict),
    Verdict = time_limits_verdict(minimum_days_prescribed, 35, observed_days_not_supplied, [cite(eu_dir_2014_24_art_27)]).
test('default: an absent urgency flag reads as not substantiated') :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false]),
    decide_time_limits(Profile, Verdict),
    Verdict = time_limits_verdict(minimum_days_prescribed, 35, observed_days_not_supplied, [cite(eu_dir_2014_24_art_27)]).
test('default: an absent observed day count is reported as not supplied') :-
    time_limits_profile_for("open_tenders_baseline_allowing_35", WithDays),
    decide_time_limits(WithDays, time_limits_verdict(_, _, meets_prescribed_minimum, _)),
    open_tenders_profile(false, false, false, WithoutDays),
    findall(Conformity, decide_time_limits(WithoutDays, time_limits_verdict(_, _, Conformity, _)), Conformities),
    Conformities = [observed_days_not_supplied].
test('procedure type spelled as a character list gives no verdict') :-
    dict_pairs(Profile, [procedure_type_key - "open_procedure", stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]),
    gives_no_verdict(Profile).
test('procedure type given as a number gives no verdict') :-
    dict_pairs(Profile, [procedure_type_key - 1, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]),
    gives_no_verdict(Profile).
test('procedure type given as a list gives no verdict') :-
    dict_pairs(Profile, [procedure_type_key - [open_procedure], stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]),
    gives_no_verdict(Profile).
test('procedure type outside the five procedures gives no verdict') :-
    dict_pairs(Profile, [procedure_type_key - not_a_procedure, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]),
    gives_no_verdict(Profile).
test('unbound procedure type gives no verdict rather than one verdict per procedure') :-
    dict_pairs(Profile, [procedure_type_key - _, stage_key - receipt_of_tenders, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]),
    gives_no_verdict(Profile).
test('stage given as a number gives no verdict') :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - 1, prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]),
    gives_no_verdict(Profile).
test('stage spelled as a character list gives no verdict') :-
    dict_pairs(Profile, [procedure_type_key - restricted_procedure, stage_key - "receipt_of_tenders", prior_information_notice_published - false, electronic_submission_accepted - false, state_of_urgency_substantiated - false]),
    gives_no_verdict(Profile).
test('prior information notice flag given as the number 1 still gives a definite verdict') :-
    open_tenders_profile(1, false, false, Profile),
    gives_no_verdict(Profile).
test('prior information notice flag given as an atom still gives a definite verdict') :-
    open_tenders_profile(yes, false, false, Profile),
    gives_no_verdict(Profile).
test('prior information notice flag given as a list still gives a definite verdict') :-
    open_tenders_profile([true], false, false, Profile),
    gives_no_verdict(Profile).
test('prior information notice flag given as a character list still gives a definite verdict') :-
    open_tenders_profile("True", false, false, Profile),
    gives_no_verdict(Profile).
test('electronic submission flag given as the number 1 still gives a definite verdict') :-
    open_tenders_profile(false, 1, false, Profile),
    gives_no_verdict(Profile).
test('electronic submission flag given as an atom still gives a definite verdict') :-
    open_tenders_profile(false, yes, false, Profile),
    gives_no_verdict(Profile).
test('electronic submission flag given as a list still gives a definite verdict') :-
    open_tenders_profile(false, [true], false, Profile),
    gives_no_verdict(Profile).
test('electronic submission flag given as a character list still gives a definite verdict') :-
    open_tenders_profile(false, "True", false, Profile),
    gives_no_verdict(Profile).
test('urgency flag given as the number 1 still gives a definite verdict') :-
    open_tenders_profile(false, false, 1, Profile),
    gives_no_verdict(Profile).
test('urgency flag given as an atom still gives a definite verdict') :-
    open_tenders_profile(false, false, yes, Profile),
    gives_no_verdict(Profile).
test('urgency flag given as a list still gives a definite verdict') :-
    open_tenders_profile(false, false, [true], Profile),
    gives_no_verdict(Profile).
test('urgency flag given as a character list still gives a definite verdict') :-
    open_tenders_profile(false, false, "True", Profile),
    gives_no_verdict(Profile).
test('unbound prior information notice flag gives no verdict instead of applying the 15-day reduction') :-
    open_tenders_profile(_, false, false, Profile),
    gives_no_verdict(Profile).
test('unbound electronic submission flag gives no verdict instead of applying the 30-day reduction') :-
    open_tenders_profile(false, _, false, Profile),
    gives_no_verdict(Profile).
test('unbound urgency flag gives no verdict instead of applying the 15-day reduction') :-
    open_tenders_profile(false, false, _, Profile),
    gives_no_verdict(Profile).
test('observed day count spelled as a character list gives no verdict') :-
    open_tenders_profile_observing("40", Profile),
    gives_no_verdict(Profile).
test('observed day count given as an atom gives no verdict') :-
    open_tenders_profile_observing(forty, Profile),
    gives_no_verdict(Profile).
test('observed day count given as a list gives no verdict') :-
    open_tenders_profile_observing([40], Profile),
    gives_no_verdict(Profile).
test('observed day count given as a boolean gives no verdict') :-
    open_tenders_profile_observing(true, Profile),
    gives_no_verdict(Profile).
test('unbound observed day count gives no verdict') :-
    open_tenders_profile_observing(_, Profile),
    gives_no_verdict(Profile).
test('negative observed day count is reported as a breach instead of refused') :-
    open_tenders_profile_observing(-5, Profile),
    gives_no_verdict(Profile).
test('a profile that is not a dict gives no definite verdict') :-
    decision_outcome(not_a_procedure, Outcome),
    outcome_without_verdicts(Outcome).
test('empty profile raises an unguarded dict key existence error instead of giving no verdict') :-
    dict_pairs(Profile, []),
    gives_no_verdict(Profile).
test('empty profile makes the resolvable facade raise instead of failing') :-
    catch((findall(Profile, (dict_pairs(Profile, []), time_limits_decision_resolvable(Profile)), Resolved), Outcome = answers(Resolved)), Error, Outcome = raised(Error)),
    Outcome = answers([]).
test('every fixture profile yields exactly one verdict') :-
    findall(Subject, time_limits_subject(Subject), Subjects),
    length(Subjects, 24),
    findall(Subject, (time_limits_subject(Subject), time_limits_profile_for(Subject, Profile), findall(Verdict, decide_time_limits(Profile, Verdict), Verdicts), length(Verdicts, VerdictCount), dif(VerdictCount, 1)), Offenders),
    Offenders = [].
test('boundary: open tenders base of 35 days is an inclusive floor') :-
    time_limits_profile_for("open_tenders_baseline", Profile),
    floor_boundaries_hold(Profile, 35).
test('boundary: open tenders electronic figure of 30 days is an inclusive floor') :-
    time_limits_profile_for("open_tenders_electronic_submission", Profile),
    floor_boundaries_hold(Profile, 30).
test('boundary: restricted tenders electronic figure of 25 days is an inclusive floor') :-
    time_limits_profile_for("restricted_tenders_electronic_submission", Profile),
    floor_boundaries_hold(Profile, 25).
test('boundary: open tenders prior information notice figure of 15 days is an inclusive floor') :-
    time_limits_profile_for("open_tenders_prior_information_notice", Profile),
    floor_boundaries_hold(Profile, 15).
test('boundary: restricted tenders urgency figure of 10 days is an inclusive floor') :-
    time_limits_profile_for("restricted_tenders_urgency", Profile),
    floor_boundaries_hold(Profile, 10).
test('input check finds no problem on any registered fixture') :-
    findall(Subject, (time_limits_subject(Subject), time_limits_profile_for(Subject, Profile), time_limits_input_problem(Profile, _)), Offenders),
    Offenders = [].
test('input check reports an unbound variable as not_ground') :-
    open_tenders_profile(_, false, false, Profile),
    time_limits_input_problem(Profile, not_ground).
test('input check reports a profile that is not a dict') :-
    time_limits_input_problem(not_a_procedure, not_a_dict).
test('input check reports a missing procedure type first on the empty profile') :-
    dict_pairs(Profile, []),
    findall(Problem, time_limits_input_problem(Profile, Problem), [missing_key(procedure_type_key)]).
test('input check reports a missing stage') :-
    dict_pairs(Profile, [procedure_type_key - open_procedure]),
    time_limits_input_problem(Profile, missing_key(stage_key)).
test('input check reports an unknown procedure type') :-
    dict_pairs(Profile, [procedure_type_key - not_a_procedure, stage_key - receipt_of_tenders]),
    time_limits_input_problem(Profile, wrong_value(procedure_type_key, expected_procedure_type)).
test('input check reports an unknown stage') :-
    dict_pairs(Profile, [procedure_type_key - open_procedure, stage_key - 1]),
    time_limits_input_problem(Profile, wrong_value(stage_key, expected_stage)).
test('input check reports a flag that is not exactly True or False') :-
    open_tenders_profile(false, 1, false, Profile),
    time_limits_input_problem(Profile, wrong_type(electronic_submission_accepted, expected_boolean)).
test('input check reports a boolean day count as not an integer') :-
    open_tenders_profile_observing(true, Profile),
    time_limits_input_problem(Profile, wrong_type(observed_time_limit_days, expected_integer)).
test('input check reports a fractional day count as not an integer') :-
    open_tenders_profile_observing(34.5, Profile),
    time_limits_input_problem(Profile, wrong_type(observed_time_limit_days, expected_integer)).
test('input check reports a negative day count') :-
    open_tenders_profile_observing(-5, Profile),
    time_limits_input_problem(Profile, negative_count(observed_time_limit_days)).
test('input check accepts a zero day count, which is then a breach') :-
    open_tenders_profile_observing(0, Profile),
    time_limits_input_acceptable(Profile),
    decide_time_limits(Profile, time_limits_verdict(_, 35, shorter_than_prescribed_minimum, _)).
test('checklist and what-if give no answer on a refused profile') :-
    open_tenders_profile(yes, false, false, Profile),
    findall(Checklist, time_limits_checklist(Profile, Checklist), []),
    findall(Days, time_limits_what_if(Profile, state_of_urgency_substantiated, true, Days), []).
test('what-if can still correct the refused key it overrides') :-
    open_tenders_profile(yes, false, false, Profile),
    time_limits_what_if(Profile, prior_information_notice_published, true, 15).

conformity_at(Profile, Days, Conformity) :-
    override_key(Profile, observed_time_limit_days, Days, Observed),
    findall(Found, decide_time_limits(Observed, time_limits_verdict(minimum_days_prescribed, _, Found, _)), [Conformity]).

floor_boundaries_hold(Profile, Minimum) :-
    Below #= Minimum - 1,
    Above #= Minimum + 1,
    conformity_at(Profile, Below, shorter_than_prescribed_minimum),
    conformity_at(Profile, Minimum, meets_prescribed_minimum),
    conformity_at(Profile, Above, meets_prescribed_minimum).

cp_test_names(['dropping procedure type raises an unguarded dict key existence error instead of giving no verdict', 'dropping stage raises an unguarded dict key existence error instead of giving no verdict', 'default: an absent prior information notice flag reads as not published', 'default: an absent electronic submission flag reads as not accepted', 'default: an absent urgency flag reads as not substantiated', 'default: an absent observed day count is reported as not supplied', 'procedure type spelled as a character list gives no verdict', 'procedure type given as a number gives no verdict', 'procedure type given as a list gives no verdict', 'procedure type outside the five procedures gives no verdict', 'unbound procedure type gives no verdict rather than one verdict per procedure', 'stage given as a number gives no verdict', 'stage spelled as a character list gives no verdict', 'prior information notice flag given as the number 1 still gives a definite verdict', 'prior information notice flag given as an atom still gives a definite verdict', 'prior information notice flag given as a list still gives a definite verdict', 'prior information notice flag given as a character list still gives a definite verdict', 'electronic submission flag given as the number 1 still gives a definite verdict', 'electronic submission flag given as an atom still gives a definite verdict', 'electronic submission flag given as a list still gives a definite verdict', 'electronic submission flag given as a character list still gives a definite verdict', 'urgency flag given as the number 1 still gives a definite verdict', 'urgency flag given as an atom still gives a definite verdict', 'urgency flag given as a list still gives a definite verdict', 'urgency flag given as a character list still gives a definite verdict', 'unbound prior information notice flag gives no verdict instead of applying the 15-day reduction', 'unbound electronic submission flag gives no verdict instead of applying the 30-day reduction', 'unbound urgency flag gives no verdict instead of applying the 15-day reduction', 'observed day count spelled as a character list gives no verdict', 'observed day count given as an atom gives no verdict', 'observed day count given as a list gives no verdict', 'observed day count given as a boolean gives no verdict', 'unbound observed day count gives no verdict', 'negative observed day count is reported as a breach instead of refused', 'a profile that is not a dict gives no definite verdict', 'empty profile raises an unguarded dict key existence error instead of giving no verdict', 'empty profile makes the resolvable facade raise instead of failing', 'every fixture profile yields exactly one verdict', 'boundary: open tenders base of 35 days is an inclusive floor', 'boundary: open tenders electronic figure of 30 days is an inclusive floor', 'boundary: restricted tenders electronic figure of 25 days is an inclusive floor', 'boundary: open tenders prior information notice figure of 15 days is an inclusive floor', 'boundary: restricted tenders urgency figure of 10 days is an inclusive floor', 'input check finds no problem on any registered fixture', 'input check reports an unbound variable as not_ground', 'input check reports a profile that is not a dict', 'input check reports a missing procedure type first on the empty profile', 'input check reports a missing stage', 'input check reports an unknown procedure type', 'input check reports an unknown stage', 'input check reports a flag that is not exactly True or False', 'input check reports a boolean day count as not an integer', 'input check reports a fractional day count as not an integer', 'input check reports a negative day count', 'input check accepts a zero day count, which is then a breach', 'checklist and what-if give no answer on a refused profile', 'what-if can still correct the refused key it overrides']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
