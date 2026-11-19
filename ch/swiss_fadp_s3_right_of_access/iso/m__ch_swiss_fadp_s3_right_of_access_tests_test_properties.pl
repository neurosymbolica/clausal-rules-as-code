% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s3_right_of_access_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(clausal_dates, [days_between/3]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_swiss_fadp_s3_right_of_access, [decide_swiss_fadp_s3_right_of_access/2, swiss_access_request_answer/3, swiss_access_cost_contribution/3, swiss_access_deadline/3, swiss_access_deadline_after_cost_notice/3, eu_access_response_deadline/3, compare_swiss_eu_access_deadline/5]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_kernel, [swiss_fadp_s3_right_of_access_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_citations, [citation/2]).
:- use_module(m__ch_swiss_fadp_s3_right_of_access_fixtures, [swiss_fadp_s3_right_of_access_subject/1, swiss_fadp_s3_right_of_access_profile_for/2]).

subject_classifies(Subject) :-
    swiss_fadp_s3_right_of_access_subject(Subject),
    swiss_fadp_s3_right_of_access_profile_for(Subject, Profile),
    decide_swiss_fadp_s3_right_of_access(Profile, _Verdict).

verdict_count(Subject, Count) :-
    swiss_fadp_s3_right_of_access_profile_for(Subject, Profile),
    findall(Verdict, decide_swiss_fadp_s3_right_of_access(Profile, Verdict), Verdicts),
    length(Verdicts, Count).

test(totality_every_subject_classifies) :-
    findall(Subject, swiss_fadp_s3_right_of_access_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_yields_exactly_one_verdict) :-
    findall(Count, (swiss_fadp_s3_right_of_access_subject(Subject), verdict_count(Subject, Count)), Counts),
    length(Counts, 19),
    maplist(=(1), Counts).
test(every_verdict_cites_each_recorded_key_once) :-
    findall(Subject, swiss_fadp_s3_right_of_access_subject(Subject), Subjects),
    maplist(citations_well_formed, Subjects).
test(not_final_answers_carry_no_citations) :-
    maplist(not_final_without_citations, [empty_profile, formal_law_unsure, category_absent_private_letter_only]).
test(the_cost_query_yields_one_solution_for_every_value) :-
    findall(Count, (member(Profile, [[], [attribute(access_involves_disproportionate_effort, true)], [attribute(access_involves_disproportionate_effort, false)], [attribute(access_involves_disproportionate_effort, unsure)], [attribute(access_involves_disproportionate_effort, maybe)]]), cost_solution_count(Profile, Count)), Counts),
    length(Counts, 5),
    maplist(=(1), Counts).
test(the_input_check_yields_one_solution_for_every_term) :-
    maplist(input_check_solution_count, [_, [], nonsense, [stray], [attribute(request_form, written)|_], [_], [attribute(1, true)], [attribute(request_form, _)], [attribute(request_form, written), attribute(request_form, written)]], Counts),
    maplist(=(1), Counts).
test(each_date_query_yields_one_solution_for_every_day_sampled) :-
    findall(Count, (member(Query, [swiss_access_deadline, swiss_access_deadline_after_cost_notice, eu_access_response_deadline]), between(1, 12, CalendarMonth), between(1, 28, CalendarDay), date_query_solution_count(Query, CalendarMonth, CalendarDay, Count)), Counts),
    length(Counts, 1008),
    maplist(=(1), Counts).
test(the_swiss_limit_is_always_thirty_days_and_never_moved) :-
    findall(Span, (between(1, 12, CalendarMonth), between(1, 28, CalendarDay), swiss_span(CalendarMonth, CalendarDay, Span)), Spans),
    length(Spans, 336),
    maplist(=(30), Spans).
test(the_cost_notice_limit_is_always_forty_days) :-
    findall(Span, (between(1, 12, CalendarMonth), between(1, 28, CalendarDay), cost_notice_span(CalendarMonth, CalendarDay, Span)), Spans),
    length(Spans, 336),
    maplist(=(40), Spans).
test(the_eu_month_lies_between_twenty_eight_and_thirty_three_days) :-
    findall(CalendarMonth - CalendarDay, (between(1, 12, CalendarMonth), between(1, 28, CalendarDay), eu_span_in_range(CalendarMonth, CalendarDay)), InRange),
    length(InRange, 336).
test(the_comparison_agrees_with_the_two_date_queries) :-
    findall(CalendarMonth - CalendarDay, (between(1, 12, CalendarMonth), between(1, 28, CalendarDay), comparison_agrees(CalendarMonth, CalendarDay)), Agreeing),
    length(Agreeing, 336).
test(the_failed_form_decides_whatever_any_judgement_says) :-
    findall(Result, (judgement_key(InputKey), member(Value, [true, false, unsure]), answer_with(oral_request_without_agreement, InputKey, Value, Result)), Results),
    length(Results, 33),
    sort(Results, ResultSet),
    ResultSet == [access_request_not_in_required_form].
test(each_standalone_ground_alone_permits_restriction) :-
    findall(Result, (member(InputKey, [formal_law_provides_for_restriction, restriction_required_by_overriding_third_party_interests, request_manifestly_unfounded_or_querulous, data_serve_media_professional_exclusively_as_personal_working_instrument]), answer_with(written_request_no_ground, InputKey, true, Result)), Results),
    Results == [access_may_be_refused_restricted_or_deferred, access_may_be_refused_restricted_or_deferred, access_may_be_refused_restricted_or_deferred, access_may_be_refused_restricted_or_deferred].
test(a_settled_permission_is_not_disturbed_by_an_unsure_judgement) :-
    findall(Result, (judgement_key(InputKey), dif(InputKey, restriction_required_by_overriding_third_party_interests), answer_with(written_request_third_party_interests, InputKey, unsure, Result)), Results),
    length(Results, 10),
    sort(Results, ResultSet),
    ResultSet == [access_may_be_refused_restricted_or_deferred].

recorded(cite(CitationKey)) :-
    citation(CitationKey, _).

citations_well_formed(Subject) :-
    swiss_fadp_s3_right_of_access_profile_for(Subject, Profile),
    decide_swiss_fadp_s3_right_of_access(Profile, swiss_fadp_s3_right_of_access_verdict(_, Citations)),
    sort(Citations, SortedCitations),
    length(Citations, CitationCount),
    length(SortedCitations, CitationCount),
    maplist(recorded, Citations).

not_final_without_citations(Subject) :-
    swiss_fadp_s3_right_of_access_profile_for(Subject, Profile),
    swiss_access_request_answer(Profile, _, []).

cost_solution_count(Profile, Count) :-
    findall(Result, swiss_access_cost_contribution(Profile, Result, _), Results),
    length(Results, Count).

input_check_solution_count(InputTerm, Count) :-
    findall(Problems, swiss_fadp_s3_right_of_access_input_problems(InputTerm, Problems), ProblemLists),
    length(ProblemLists, Count).

date_query_solution_count(Query, CalendarMonth, CalendarDay, Count) :-
    findall(Deadline, call(Query, date(2026, CalendarMonth, CalendarDay), Deadline, _), Deadlines),
    length(Deadlines, Count).

swiss_span(CalendarMonth, CalendarDay, Span) :-
    swiss_access_deadline(date(2026, CalendarMonth, CalendarDay), Deadline, _),
    days_between(Deadline, date(2026, CalendarMonth, CalendarDay), Span).

cost_notice_span(CalendarMonth, CalendarDay, Span) :-
    swiss_access_deadline_after_cost_notice(date(2026, CalendarMonth, CalendarDay), Deadline, _),
    days_between(Deadline, date(2026, CalendarMonth, CalendarDay), Span).

eu_span_in_range(CalendarMonth, CalendarDay) :-
    eu_access_response_deadline(date(2026, CalendarMonth, CalendarDay), Deadline, _),
    days_between(Deadline, date(2026, CalendarMonth, CalendarDay), Span),
    Span #>= 28,
    Span #< 34.

comparison_agrees(CalendarMonth, CalendarDay) :-
    compare_swiss_eu_access_deadline(date(2026, CalendarMonth, CalendarDay), SwissDeadline, EuDeadline, _, _),
    swiss_access_deadline(date(2026, CalendarMonth, CalendarDay), SwissAlone, _),
    eu_access_response_deadline(date(2026, CalendarMonth, CalendarDay), EuAlone, _),
    SwissDeadline == SwissAlone,
    EuDeadline == EuAlone.

with_value(Profile, InputKey, Value, Changed) :-
    maplist(replace_attribute(InputKey, Value), Profile, Changed).

replace_attribute(InputKey, Value, attribute(InputKey, _), attribute(InputKey, Value)).
replace_attribute(InputKey, _, attribute(OtherKey, OtherValue), attribute(OtherKey, OtherValue)) :-
    dif(InputKey, OtherKey).

judgement_key(formal_law_provides_for_restriction).
judgement_key(restriction_required_by_overriding_third_party_interests).
judgement_key(request_manifestly_unfounded_or_querulous).
judgement_key(restriction_required_by_overriding_controller_interests).
judgement_key(restriction_required_by_overriding_public_interests).
judgement_key(information_could_endanger_investigation_or_proceedings).
judgement_key(processed_exclusively_for_publication_in_editorial_part_of_periodical_medium).
judgement_key(data_reveal_information_sources).
judgement_key(access_would_give_insight_into_drafts_for_publications).
judgement_key(publication_would_endanger_free_formation_of_public_opinion).
judgement_key(data_serve_media_professional_exclusively_as_personal_working_instrument).

answer_with(Subject, InputKey, Value, Result) :-
    swiss_fadp_s3_right_of_access_profile_for(Subject, Profile),
    with_value(Profile, InputKey, Value, Changed),
    swiss_access_request_answer(Changed, Result, _).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_yields_exactly_one_verdict, every_verdict_cites_each_recorded_key_once, not_final_answers_carry_no_citations, the_cost_query_yields_one_solution_for_every_value, the_input_check_yields_one_solution_for_every_term, each_date_query_yields_one_solution_for_every_day_sampled, the_swiss_limit_is_always_thirty_days_and_never_moved, the_cost_notice_limit_is_always_forty_days, the_eu_month_lies_between_twenty_eight_and_thirty_three_days, the_comparison_agrees_with_the_two_date_queries, the_failed_form_decides_whatever_any_judgement_says, each_standalone_ground_alone_permits_restriction, a_settled_permission_is_not_disturbed_by_an_unsure_judgement]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
