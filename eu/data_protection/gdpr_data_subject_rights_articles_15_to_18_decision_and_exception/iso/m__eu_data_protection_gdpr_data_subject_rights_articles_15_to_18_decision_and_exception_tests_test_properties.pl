% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [subtract/3]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_request_exception, [decide_request_exception/2, request_decision/2, request_exception/2, request_exception_checklist/2, request_exception_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_citations, [citation/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_fixtures, [gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_subject/1, gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for/2]).

subject_profile(Subject, Profile) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_subject(Subject),
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(Subject, Profile).

subject_classifies(Subject) :-
    subject_profile(Subject, Profile),
    decide_request_exception(Profile, _Verdict).

subject_verdict_count(Subject, Count) :-
    subject_profile(Subject, Profile),
    findall(Verdict, decide_request_exception(Profile, Verdict), Verdicts),
    length(Verdicts, Count).

subject_decision_count(Subject, Count) :-
    subject_profile(Subject, Profile),
    findall(Comply, request_decision(Profile, Comply), Decisions),
    length(Decisions, Count).

subject_exception_count(Subject, Count) :-
    subject_profile(Subject, Profile),
    findall(Exception, request_exception(Profile, Exception), Exceptions),
    length(Exceptions, Count).

all_subjects(SubjectSet) :-
    findall(Subject, gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subjects_with_one(CountGoal, SubjectSet) :-
    findall(Subject, call(CountGoal, Subject, 1), Subjects),
    sort(Subjects, SubjectSet).

compound_decision_exception(Exception) :-
    subject_profile(_, Profile),
    request_decision(Profile, Comply),
    compound(Comply),
    request_exception(Profile, Exception).

must_comply_exception(Exception) :-
    subject_profile(_, Profile),
    request_decision(Profile, must_comply),
    request_exception(Profile, Exception).

verdict_citation(Citation) :-
    subject_profile(_, Profile),
    decide_request_exception(Profile, request_exception_verdict(_, Citations)),
    member(Citation, Citations).

checklist_item(Item) :-
    subject_profile(_, Profile),
    request_exception_checklist(Profile, Items),
    member(Item, Items).

test(totality_every_subject_classifies) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    all_subjects(SubjectSet),
    subjects_with_one(subject_verdict_count, SubjectSet).
test(determinism_every_subject_has_exactly_one_decision) :-
    all_subjects(SubjectSet),
    subjects_with_one(subject_decision_count, SubjectSet).
test(determinism_every_subject_has_exactly_one_exception) :-
    all_subjects(SubjectSet),
    subjects_with_one(subject_exception_count, SubjectSet).
test(every_exception_is_in_the_vocabulary) :-
    findall(Exception, (subject_profile(_, Profile), request_exception(Profile, Exception)), Exceptions),
    request_exception_status_values(Vocabulary),
    subtract(Exceptions, Vocabulary, Outside),
    Outside == [].
test(every_non_final_decision_has_the_exception_none) :-
    findall(Exception, compound_decision_exception(Exception), Exceptions),
    sort(Exceptions, ExceptionSet),
    ExceptionSet == [none].
test(every_must_comply_has_the_exception_none) :-
    findall(Exception, must_comply_exception(Exception), Exceptions),
    sort(Exceptions, ExceptionSet),
    ExceptionSet == [none].
test(every_verdict_citation_is_a_cite_term) :-
    findall(Citation, verdict_citation(Citation), Citations),
    Citations = [_|_],
    findall(Citation, (member(Citation, Citations), Citation = cite(_)), CiteTerms),
    length(Citations, CitationCount),
    length(CiteTerms, CitationCount).
test(every_verdict_citation_key_is_recorded) :-
    findall(CitationKey, verdict_citation(cite(CitationKey)), CitationKeys),
    sort(CitationKeys, CitationKeySet),
    CitationKeySet = [_|_],
    findall(CitationKey, (member(CitationKey, CitationKeySet), citation(CitationKey, _)), RecordedKeys),
    sort(RecordedKeys, RecordedKeySet),
    RecordedKeySet == CitationKeySet.
test(every_checklist_item_carries_cite_provenance) :-
    findall(Item, checklist_item(Item), Items),
    Items = [_|_],
    findall(Item, (member(Item, Items), Item = item(_, _, cite(_))), CitedItems),
    length(Items, ItemCount),
    length(CitedItems, ItemCount).
test(a_key_no_limb_reads_leaves_the_answer) :-
    gdpr_data_subject_rights_articles_15_to_18_decision_and_exception_profile_for(erasure_data_no_longer_necessary, Profile),
    append(Profile, [attribute(processing_for_direct_marketing, true), attribute(decision_authorised_by_union_or_member_state_law, attested(true, attestation(by, at, reason, none)))], Extended),
    findall(Comply, request_decision(Extended, Comply), Decisions),
    Decisions == [must_comply].

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, determinism_every_subject_has_exactly_one_decision, determinism_every_subject_has_exactly_one_exception, every_exception_is_in_the_vocabulary, every_non_final_decision_has_the_exception_none, every_must_comply_has_the_exception_none, every_verdict_citation_is_a_cite_term, every_verdict_citation_key_is_recorded, every_checklist_item_carries_cite_provenance, a_key_no_limb_reads_leaves_the_answer]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
