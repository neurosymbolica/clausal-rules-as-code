% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_erasure_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_queries, [decide_data_subject_request/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_citations, [citation/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_erasure_fixtures, [gdpr_data_subject_rights_erasure_subject/1, gdpr_data_subject_rights_erasure_profile_for/2, gdpr_data_subject_rights_erasure_assess/2]).

all_subjects(SubjectSet) :-
    findall(Subject, gdpr_data_subject_rights_erasure_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_verdict_count(Subject, Count) :-
    gdpr_data_subject_rights_erasure_profile_for(Subject, Profile),
    findall(Verdict, decide_data_subject_request(Profile, Verdict), Verdicts),
    length(Verdicts, Count).

citation_invariant(must_comply, Citations) :-
    member(cite(eu_reg_2016_679_art_17_1), Citations).
citation_invariant(need_not_comply, Citations) :-
    member(cite(eu_reg_2016_679_art_17_1), Citations).
citation_invariant(indeterminate(_), []).
citation_invariant(needs_legal_review(_, _), []).
citation_invariant(suspended(_), []).
citation_invariant(input_problems(_), []).

conditions_invariant(art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged]).
conditions_invariant(Exception, []) :-
    dif(Exception, art12_5_manifestly_unfounded_or_excessive).

citations_well_ordered(Subject) :-
    gdpr_data_subject_rights_erasure_assess(Subject, gdpr_data_subject_request_verdict(_, _, _, _, Citations)),
    sort(Citations, SortedCitations),
    SortedCitations == Citations.

unread_key_stable(Subject) :-
    gdpr_data_subject_rights_erasure_profile_for(Subject, Profile),
    decide_data_subject_request(Profile, Verdict),
    decide_data_subject_request([attribute(accuracy_contested_by_data_subject, true)|Profile], Verdict).

verdict_citation_key(Subject, CitationKey) :-
    gdpr_data_subject_rights_erasure_assess(Subject, gdpr_data_subject_request_verdict(_, _, _, _, Citations)),
    member(cite(CitationKey), Citations).

test(totality_every_subject_classifies) :-
    all_subjects(SubjectSet),
    findall(Subject, (gdpr_data_subject_rights_erasure_subject(Subject), gdpr_data_subject_rights_erasure_assess(Subject, _)), ClassifiedSubjects),
    sort(ClassifiedSubjects, ClassifiedSet),
    ClassifiedSet == SubjectSet.
test(determinism_every_subject_yields_exactly_one_verdict) :-
    findall(Subject - Count, (gdpr_data_subject_rights_erasure_subject(Subject), subject_verdict_count(Subject, Count)), ActualRows),
    findall(Subject - 1, gdpr_data_subject_rights_erasure_subject(Subject), ExpectedRows),
    ActualRows == ExpectedRows.
test(final_verdicts_cite_article_17_1_and_non_final_cite_nothing) :-
    all_subjects(SubjectSet),
    findall(Subject, (gdpr_data_subject_rights_erasure_subject(Subject), gdpr_data_subject_rights_erasure_assess(Subject, gdpr_data_subject_request_verdict(Comply, _, _, _, Citations)), citation_invariant(Comply, Citations)), Holding),
    sort(Holding, HoldingSet),
    HoldingSet == SubjectSet.
test(the_fee_condition_goes_with_article_12_5_only) :-
    all_subjects(SubjectSet),
    findall(Subject, (gdpr_data_subject_rights_erasure_subject(Subject), gdpr_data_subject_rights_erasure_assess(Subject, gdpr_data_subject_request_verdict(_, _, Exception, Conditions, _)), conditions_invariant(Exception, Conditions)), Holding),
    sort(Holding, HoldingSet),
    HoldingSet == SubjectSet.
test(citations_are_in_vocabulary_order_without_duplicates) :-
    all_subjects(SubjectSet),
    findall(Subject, (gdpr_data_subject_rights_erasure_subject(Subject), citations_well_ordered(Subject)), Holding),
    sort(Holding, HoldingSet),
    HoldingSet == SubjectSet.
test(every_returned_citation_is_recorded) :-
    findall(CitationKey, verdict_citation_key(_, CitationKey), CitationKeys),
    sort(CitationKeys, CitationKeySet),
    findall(CitationKey, (member(CitationKey, CitationKeySet), citation(CitationKey, _)), RecordedKeys),
    RecordedKeys == CitationKeySet.
test(an_unread_key_changes_no_answer) :-
    all_subjects(SubjectSet),
    findall(Subject, (gdpr_data_subject_rights_erasure_subject(Subject), unread_key_stable(Subject)), Holding),
    sort(Holding, HoldingSet),
    HoldingSet == SubjectSet.

cp_test_names([totality_every_subject_classifies, determinism_every_subject_yields_exactly_one_verdict, final_verdicts_cite_article_17_1_and_non_final_cite_nothing, the_fee_condition_goes_with_article_12_5_only, citations_are_in_vocabulary_order_without_duplicates, every_returned_citation_is_recorded, an_unread_key_changes_no_answer]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
