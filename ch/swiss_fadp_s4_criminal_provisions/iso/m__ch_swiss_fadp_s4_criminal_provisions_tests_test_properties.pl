% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s4_criminal_provisions_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_swiss_fadp_s4_criminal_provisions, [decide_swiss_fadp_s4_criminal_provisions/2, swiss_offence_punishable/3, swiss_prosecution_complaint_condition/3, swiss_prosecution_limitation/5, swiss_business_ordered_to_pay_fine/3, eu_administrative_fine_ceiling/3, compare_swiss_eu_fine_provided/5]).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_kernel, [swiss_fadp_s4_criminal_provisions_input_problems/2]).
:- use_module(m__ch_swiss_fadp_s4_criminal_provisions_fixtures, [swiss_fadp_s4_criminal_provisions_subject/1, swiss_fadp_s4_criminal_provisions_profile_for/2]).

subject_classifies(Subject) :-
    swiss_fadp_s4_criminal_provisions_subject(Subject),
    swiss_fadp_s4_criminal_provisions_profile_for(Subject, Profile),
    decide_swiss_fadp_s4_criminal_provisions(Profile, _Verdict).

query_name(swiss_offence_punishable).
query_name(swiss_prosecution_complaint_condition).
query_name(swiss_prosecution_limitation).
query_name(swiss_business_ordered_to_pay_fine).
query_name(eu_administrative_fine_ceiling).
query_name(compare_swiss_eu_fine_provided).
query_name(input_check).

query_answer(swiss_offence_punishable, Profile, Result - Citations) :-
    swiss_offence_punishable(Profile, Result, Citations).
query_answer(swiss_prosecution_complaint_condition, Profile, Result - Citations) :-
    swiss_prosecution_complaint_condition(Profile, Result, Citations).
query_answer(swiss_prosecution_limitation, Profile, Result - Citations) :-
    swiss_prosecution_limitation(Profile, date(2020, 2, 29), date(2025, 2, 28), Result, Citations).
query_answer(swiss_business_ordered_to_pay_fine, Profile, Result - Citations) :-
    swiss_business_ordered_to_pay_fine(Profile, Result, Citations).
query_answer(eu_administrative_fine_ceiling, Profile, Result - Citations) :-
    eu_administrative_fine_ceiling(Profile, Result, Citations).
query_answer(compare_swiss_eu_fine_provided, Profile, answer(SwissSide, EuropeanSide, Difference, ChangedBy)) :-
    compare_swiss_eu_fine_provided(Profile, SwissSide, EuropeanSide, Difference, ChangedBy).
query_answer(input_check, Profile, Problems) :-
    swiss_fadp_s4_criminal_provisions_input_problems(Profile, Problems).

answers_exactly_once(Profile, QueryName) :-
    findall(Answer, query_answer(QueryName, Profile, Answer), Answers),
    length(Answers, 1).

subject_query_deterministic(Subject - QueryName) :-
    swiss_fadp_s4_criminal_provisions_subject(Subject),
    query_name(QueryName),
    swiss_fadp_s4_criminal_provisions_profile_for(Subject, Profile),
    answers_exactly_once(Profile, QueryName).

result_citation_shape(indeterminate([_KeyName]), []).
result_citation_shape(needs_legal_review(open_textured(_KeyName, cite(_Citation)), [inputs_relied_on(_Inputs)]), []).
result_citation_shape(input_problems([_FirstProblem|_OtherProblems]), []).
result_citation_shape(Result, [cite(FirstKey)|OtherCitations]) :-
    atom(Result),
    atom(FirstKey),
    sort([cite(FirstKey)|OtherCitations], DistinctCitations),
    length([cite(FirstKey)|OtherCitations], CitationCount),
    length(DistinctCitations, CitationCount).

changed_by_shape(differs, ChangedBy) :-
    length(ChangedBy, 9).
changed_by_shape(same, []).
changed_by_shape(indeterminate(_Missing), []).
changed_by_shape(needs_legal_review(_Reason, _Context), []).
changed_by_shape(input_problems(_Problems), []).

subject_shapes_hold(Subject) :-
    swiss_fadp_s4_criminal_provisions_subject(Subject),
    swiss_fadp_s4_criminal_provisions_profile_for(Subject, Profile),
    swiss_offence_punishable(Profile, OffenceResult, OffenceCitations),
    result_citation_shape(OffenceResult, OffenceCitations),
    swiss_prosecution_complaint_condition(Profile, ComplaintResult, ComplaintCitations),
    result_citation_shape(ComplaintResult, ComplaintCitations),
    swiss_business_ordered_to_pay_fine(Profile, BusinessResult, BusinessCitations),
    result_citation_shape(BusinessResult, BusinessCitations),
    eu_administrative_fine_ceiling(Profile, EuropeanResult, EuropeanCitations),
    result_citation_shape(EuropeanResult, EuropeanCitations),
    compare_swiss_eu_fine_provided(Profile, _SwissSide, _EuropeanSide, Difference, ChangedBy),
    changed_by_shape(Difference, ChangedBy).

subject_sides_copied(Subject) :-
    swiss_fadp_s4_criminal_provisions_subject(Subject),
    swiss_fadp_s4_criminal_provisions_profile_for(Subject, Profile),
    compare_swiss_eu_fine_provided(Profile, SwissSide, EuropeanSide, _Difference, _ChangedBy),
    swiss_offence_punishable(Profile, SwissResult, _),
    eu_administrative_fine_ceiling(Profile, EuropeanResult, _),
    SwissSide == SwissResult,
    EuropeanSide == EuropeanResult.

test(totality_every_subject_classifies) :-
    findall(Subject, swiss_fadp_s4_criminal_provisions_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_answers_once_on_every_subject) :-
    findall(Subject - QueryName, (swiss_fadp_s4_criminal_provisions_subject(Subject), query_name(QueryName)), Everything),
    sort(Everything, EverythingSet),
    findall(SubjectQuery, subject_query_deterministic(SubjectQuery), Deterministic),
    sort(Deterministic, EverythingSet).
test(final_answers_cite_and_open_answers_do_not) :-
    findall(Subject, swiss_fadp_s4_criminal_provisions_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_shapes_hold(Subject), Shaped),
    sort(Shaped, SubjectSet).
test(comparison_copies_each_side_unchanged) :-
    findall(Subject, swiss_fadp_s4_criminal_provisions_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_sides_copied(Subject), Copied),
    sort(Copied, SubjectSet).
test(input_check_is_total_on_terms_that_are_not_profiles) :-
    findall(Problems, (member(Candidate, [stray, 3, [stray], wrapped(stray), [attribute(acted_wilfully)]]), swiss_fadp_s4_criminal_provisions_input_problems(Candidate, Problems)), AllProblems),
    AllProblems == [[wrong_type(profile)], [wrong_type(profile)], [wrong_type(profile)], [wrong_type(profile)], [wrong_type(profile)]].
test(limitation_is_deterministic_over_date_pairs) :-
    findall(Result, (member(OffenceDate - AssessmentDate, [date(2020, 1, 1) - date(2025, 1, 1), date(2020, 1, 1) - date(2025, 1, 2), date(2024, 2, 29) - date(2029, 2, 28), date(2024, 2, 29) - date(2029, 3, 1), date(2020, 12, 31) - date(2026, 1, 1)]), swiss_prosecution_limitation([], OffenceDate, AssessmentDate, Result, _)), Results),
    Results == [five_year_limitation_period_not_expired, five_year_limitation_period_expired, five_year_limitation_period_not_expired, five_year_limitation_period_expired, five_year_limitation_period_expired].

cp_test_names([totality_every_subject_classifies, determinism_every_query_answers_once_on_every_subject, final_answers_cite_and_open_answers_do_not, comparison_copies_each_side_unchanged, input_check_is_total_on_terms_that_are_not_profiles, limitation_is_deterministic_over_date_pairs]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
