% SPDX-License-Identifier: EUPL-1.2
:- module(m__us_virginia_vcdpa_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(m__us_virginia_vcdpa_virginia_vcdpa, [applicability_status/3, response_deadline/4, extended_response_deadline/4, appeal_response_deadline/4, cure_period_last_day/4, attorney_general_action_status/5, civil_penalty_maximum/3, decide_virginia_vcdpa/2]).
:- use_module(m__us_virginia_vcdpa_fixtures, [virginia_vcdpa_subject/1, virginia_vcdpa_profile_for/2]).

query_names([applicability, response, extended, appeal, cure, action_before_notice, action_within_cure_period, action_after_cure_period, penalty]).

query_answers(applicability, Profile, Answers) :-
    findall(Result - Citations, applicability_status(Profile, Result, Citations), Answers).
query_answers(response, Profile, Answers) :-
    findall(Deadline - Citations, response_deadline(Profile, date(2026, 3, 10), Deadline, Citations), Answers).
query_answers(extended, Profile, Answers) :-
    findall(Deadline - Citations, extended_response_deadline(Profile, date(2026, 3, 10), Deadline, Citations), Answers).
query_answers(appeal, Profile, Answers) :-
    findall(Deadline - Citations, appeal_response_deadline(Profile, date(2026, 3, 10), Deadline, Citations), Answers).
query_answers(cure, Profile, Answers) :-
    findall(LastDay - Citations, cure_period_last_day(Profile, date(2026, 3, 10), LastDay, Citations), Answers).
query_answers(action_before_notice, Profile, Answers) :-
    findall(Result - Citations, attorney_general_action_status(Profile, date(2026, 3, 10), date(2026, 3, 9), Result, Citations), Answers).
query_answers(action_within_cure_period, Profile, Answers) :-
    findall(Result - Citations, attorney_general_action_status(Profile, date(2026, 3, 10), date(2026, 4, 9), Result, Citations), Answers).
query_answers(action_after_cure_period, Profile, Answers) :-
    findall(Result - Citations, attorney_general_action_status(Profile, date(2026, 3, 10), date(2026, 4, 10), Result, Citations), Answers).
query_answers(penalty, Profile, Answers) :-
    findall(Maximum - Citations, civil_penalty_maximum(Profile, Maximum, Citations), Answers).

answers_once(Profile, QueryName) :-
    query_answers(QueryName, Profile, Answers),
    length(Answers, 1).

subject_answers_every_query_once(Subject) :-
    virginia_vcdpa_profile_for(Subject, Profile),
    query_names(QueryNames),
    maplist(answers_once(Profile), QueryNames).

subject_has_one_profile(Subject) :-
    findall(Profile, virginia_vcdpa_profile_for(Subject, Profile), Profiles),
    length(Profiles, 1).

test(totality_every_subject_has_one_profile) :-
    findall(Subject, virginia_vcdpa_subject(Subject), Subjects),
    maplist(subject_has_one_profile, Subjects).
test(determinism_every_subject_answers_every_query_once) :-
    findall(Subject, virginia_vcdpa_subject(Subject), Subjects),
    maplist(subject_answers_every_query_once, Subjects).
test(determinism_the_facade_verdict_is_single) :-
    findall(Subject, virginia_vcdpa_subject(Subject), Subjects),
    maplist(subject_has_one_verdict, Subjects).
test(determinism_every_applicability_combination_answers_once) :-
    findall(Profile, applicability_combination(Profile), Profiles),
    length(Profiles, 216),
    maplist(applicability_answers_once, Profiles).
test(determinism_every_extension_combination_answers_once) :-
    findall(Count, extension_combination_count(Count), Counts),
    length(Counts, 12),
    sort(Counts, [1]).
test(determinism_every_action_combination_answers_once) :-
    findall(Count, action_combination_count(Count), Counts),
    length(Counts, 9),
    sort(Counts, [1]).
test(the_penalty_is_seven_thousand_five_hundred_per_violation) :-
    numlist(0, 20, ViolationCounts),
    maplist(penalty_is_linear, ViolationCounts).
test(coverage_is_monotone_in_the_consumer_count) :-
    maplist(coverage_at, [0, 24999, 25000, 99999, 100000, 500000], Statuses),
    Statuses == [out_of_scope, out_of_scope, in_scope, in_scope, in_scope, in_scope].
test(the_extension_lands_forty_five_days_after_the_response_deadline) :-
    maplist(extension_adds_forty_five_days, [date(2026, 1, 1) - date(2026, 2, 15) - date(2026, 4, 1), date(2026, 11, 16) - date(2026, 12, 31) - date(2027, 2, 14)]).
test(the_cure_period_ends_on_its_last_day) :-
    cure_period_last_day([], date(2026, 3, 10), LastDay, _),
    attorney_general_action_status([], date(2026, 3, 10), LastDay, cure_period_running, _),
    attorney_general_action_status([], date(2026, 3, 10), date(2026, 4, 10), indeterminate([cured_with_express_written_statement]), []).
test(deadline_queries_read_no_profile_key) :-
    virginia_vcdpa_profile_for(large_virginia_controller, Profile),
    response_deadline(Profile, date(2026, 5, 1), FromProfile, _),
    response_deadline([], date(2026, 5, 1), FromEmpty, _),
    FromProfile = FromEmpty.

subject_has_one_verdict(Subject) :-
    virginia_vcdpa_profile_for(Subject, Profile),
    findall(Verdict, decide_virginia_vcdpa(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

optional_attribute(_, absent, []).
optional_attribute(Key, Value, [attribute(Key, Value)]) :-
    dif(Value, absent).

applicability_combination(Profile) :-
    member(Category, [absent, nonprofit_organization, none_of_the_exempt_categories]),
    member(BusinessLink, [absent, true, false, unsure]),
    member(ConsumerCount, [absent, 0, 24999, 25000, 99999, 100000]),
    member(OverHalf, [absent, true, false]),
    optional_attribute(entity_category, Category, CategoryPart),
    optional_attribute(conducts_business_in_or_targets_virginia, BusinessLink, BusinessPart),
    optional_attribute(consumer_count, ConsumerCount, CountPart),
    optional_attribute(over_half_of_gross_revenue_from_sale, OverHalf, RevenuePart),
    append([CategoryPart, BusinessPart, CountPart, RevenuePart], Profile).

citation_shape(in_scope, [_|_]).
citation_shape(out_of_scope, [_|_]).
citation_shape(exempt_entity, [_|_]).
citation_shape(indeterminate([_]), []).
citation_shape(needs_legal_review(_, _), []).
citation_shape(input_problems(_), []).

applicability_answers_once(Profile) :-
    findall(Result - Citations, applicability_status(Profile, Result, Citations), Answers),
    Answers = [OnlyResult - OnlyCitations],
    citation_shape(OnlyResult, OnlyCitations).

extension_combination_count(Count) :-
    member(Necessary, [absent, true, false, unsure]),
    member(NoticeGiven, [absent, true, false]),
    optional_attribute(extension_reasonably_necessary, Necessary, NecessaryPart),
    optional_attribute(extension_notice_given_within_initial_period, NoticeGiven, NoticePart),
    append(NecessaryPart, NoticePart, Profile),
    findall(Deadline, extended_response_deadline(Profile, date(2026, 1, 1), Deadline, _), Deadlines),
    length(Deadlines, Count).

action_combination_count(Count) :-
    member(Cured, [absent, true, false]),
    member(Continued, [absent, true, false]),
    optional_attribute(cured_with_express_written_statement, Cured, CuredPart),
    optional_attribute(continued_violation_or_statement_breached, Continued, ContinuedPart),
    append(CuredPart, ContinuedPart, Profile),
    findall(Result, attorney_general_action_status(Profile, date(2026, 1, 1), date(2026, 3, 1), Result, _), Results),
    length(Results, Count).

penalty_is_linear(ViolationCount) :-
    civil_penalty_maximum([attribute(violation_count, ViolationCount)], Maximum, [cite(us_va_code_59_1_584_c)]),
    integer(Maximum),
    Maximum =:= ViolationCount * 7500.

coverage_at(ConsumerCount, Status) :-
    applicability_status([attribute(entity_category, none_of_the_exempt_categories), attribute(conducts_business_in_or_targets_virginia, true), attribute(over_half_of_gross_revenue_from_sale, true), attribute(consumer_count, ConsumerCount)], Status, _).

extension_adds_forty_five_days(ReceivedDate - ExpectedResponse - ExpectedExtended) :-
    response_deadline([], ReceivedDate, ExpectedResponse, _),
    extended_response_deadline([attribute(extension_reasonably_necessary, true), attribute(extension_notice_given_within_initial_period, true)], ReceivedDate, ExpectedExtended, _).

cp_test_names([totality_every_subject_has_one_profile, determinism_every_subject_answers_every_query_once, determinism_the_facade_verdict_is_single, determinism_every_applicability_combination_answers_once, determinism_every_extension_combination_answers_once, determinism_every_action_combination_answers_once, the_penalty_is_seven_thousand_five_hundred_per_violation, coverage_is_monotone_in_the_consumer_count, the_extension_lands_forty_five_days_after_the_response_deadline, the_cure_period_ends_on_its_last_day, deadline_queries_read_no_profile_key]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
