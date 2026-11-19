% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_administrative_fine_maximum_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_gdpr_administrative_fine_maximum, [administrative_fine_maximum/3, decide_gdpr_administrative_fine_maximum/2]).
:- use_module(m__eu_data_protection_gdpr_administrative_fine_maximum_fixtures, [gdpr_administrative_fine_maximum_subject/1, gdpr_administrative_fine_maximum_profile_for/2]).

subject_classifies(Subject) :-
    gdpr_administrative_fine_maximum_subject(Subject),
    gdpr_administrative_fine_maximum_profile_for(Subject, Profile),
    decide_gdpr_administrative_fine_maximum(Profile, _Verdict).

subject_answer_count(Subject, Count) :-
    gdpr_administrative_fine_maximum_profile_for(Subject, Profile),
    findall(Verdict - Citations, administrative_fine_maximum(Profile, Verdict, Citations), Answers),
    length(Answers, Count).

subject_facade_count(Subject, Count) :-
    gdpr_administrative_fine_maximum_profile_for(Subject, Profile),
    findall(Result, decide_gdpr_administrative_fine_maximum(Profile, Result), Results),
    length(Results, Count).

all_subjects(Subjects) :-
    findall(Subject, gdpr_administrative_fine_maximum_subject(Subject), Subjects).

allowed_citation(cite(eu_reg_2016_679_art_83_3)).
allowed_citation(cite(eu_reg_2016_679_art_83_4)).
allowed_citation(cite(eu_reg_2016_679_art_83_4_a)).
allowed_citation(cite(eu_reg_2016_679_art_83_4_b)).
allowed_citation(cite(eu_reg_2016_679_art_83_4_c)).
allowed_citation(cite(eu_reg_2016_679_art_83_5)).
allowed_citation(cite(eu_reg_2016_679_art_83_5_a)).
allowed_citation(cite(eu_reg_2016_679_art_83_5_b)).
allowed_citation(cite(eu_reg_2016_679_art_83_5_c)).
allowed_citation(cite(eu_reg_2016_679_art_83_5_d)).
allowed_citation(cite(eu_reg_2016_679_art_83_5_e)).
allowed_citation(cite(eu_reg_2016_679_art_83_6)).

verdict_citations_consistent(fine_maximum(_, _, CapInEuroCents), [Citation|Citations]) :-
    integer(CapInEuroCents),
    CapInEuroCents >= 0,
    sort([Citation|Citations], DistinctCitations),
    length([Citation|Citations], CitationCount),
    length(DistinctCitations, CitationCount),
    maplist(allowed_citation, [Citation|Citations]).
verdict_citations_consistent(separate_fine_maxima([Maximum|Maxima]), [Citation|Citations]) :-
    maplist(non_negative_maximum, [Maximum|Maxima]),
    sort([Citation|Citations], DistinctCitations),
    length([Citation|Citations], CitationCount),
    length(DistinctCitations, CitationCount),
    maplist(allowed_citation, [Citation|Citations]).
verdict_citations_consistent(indeterminate([_|_]), []).
verdict_citations_consistent(needs_legal_review(_, [inputs_relied_on(_)]), []).
verdict_citations_consistent(input_problems([_|_]), []).

non_negative_maximum(infringement_maximum(_, _, _, CapInEuroCents)) :-
    integer(CapInEuroCents),
    CapInEuroCents >= 0.

subject_consistent(Subject) :-
    gdpr_administrative_fine_maximum_profile_for(Subject, Profile),
    administrative_fine_maximum(Profile, Verdict, Citations),
    verdict_citations_consistent(Verdict, Citations).

undertaking_cap(Provision, TurnoverEuros, CapInEuroCents) :-
    administrative_fine_maximum([attribute(infringed_provisions, [Provision]), attribute(infringer_is_undertaking, true), attribute(total_worldwide_annual_turnover_in_euros, TurnoverEuros)], fine_maximum(_, _, CapInEuroCents), _).

not_above(SmallerCapInEuroCents, LargerCapInEuroCents) :-
    SmallerCapInEuroCents =< LargerCapInEuroCents.

turnover_points([0, 1, 250000000, 499999999, 500000000, 500000001, 1000000000, 7000000000]).

test(totality_every_subject_classifies) :-
    all_subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_answers_exactly_once) :-
    all_subjects(Subjects),
    Subjects = [_|_],
    maplist(subject_answer_count, Subjects, Counts),
    maplist(=(1), Counts).
test(determinism_the_facade_answers_exactly_once) :-
    all_subjects(Subjects),
    maplist(subject_facade_count, Subjects, Counts),
    maplist(=(1), Counts).
test(citation_completeness_and_non_negative_caps) :-
    all_subjects(Subjects),
    maplist(subject_consistent, Subjects).
test(the_lower_tier_cap_is_monotone_in_the_turnover) :-
    turnover_points(TurnoverPoints),
    maplist(undertaking_cap(article_30), TurnoverPoints, CapsInEuroCents),
    clausal_msort(CapsInEuroCents, CapsInEuroCents).
test(the_higher_tier_cap_is_monotone_in_the_turnover) :-
    turnover_points(TurnoverPoints),
    maplist(undertaking_cap(article_17), TurnoverPoints, CapsInEuroCents),
    clausal_msort(CapsInEuroCents, CapsInEuroCents).
test(the_higher_tier_cap_is_never_smaller_than_the_lower) :-
    turnover_points(TurnoverPoints),
    maplist(undertaking_cap(article_30), TurnoverPoints, LowerCapsInEuroCents),
    maplist(undertaking_cap(article_17), TurnoverPoints, HigherCapsInEuroCents),
    maplist(not_above, LowerCapsInEuroCents, HigherCapsInEuroCents).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_answers_exactly_once, determinism_the_facade_answers_exactly_once, citation_completeness_and_non_negative_caps, the_lower_tier_cap_is_monotone_in_the_turnover, the_higher_tier_cap_is_monotone_in_the_turnover, the_higher_tier_cap_is_never_smaller_than_the_lower]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
