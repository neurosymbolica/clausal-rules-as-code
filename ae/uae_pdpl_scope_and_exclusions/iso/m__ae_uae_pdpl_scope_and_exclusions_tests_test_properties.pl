% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_scope_and_exclusions_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_is_list/1]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_uae_pdpl_scope_and_exclusions, [pdpl_applies/3, pdpl_in_force/3, decide_uae_pdpl_scope_and_exclusions/2]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_kernel, [uae_pdpl_scope_and_exclusions_input_problems/2]).
:- use_module(m__ae_uae_pdpl_scope_and_exclusions_fixtures, [uae_pdpl_scope_and_exclusions_subject/1, uae_pdpl_scope_and_exclusions_profile_for/2]).

all_subjects(SubjectSet) :-
    findall(Subject, uae_pdpl_scope_and_exclusions_subject(Subject), Subjects),
    sort(Subjects, SubjectSet).

subject_classifies(Subject) :-
    uae_pdpl_scope_and_exclusions_subject(Subject),
    uae_pdpl_scope_and_exclusions_profile_for(Subject, Profile),
    decide_uae_pdpl_scope_and_exclusions(Profile, _Verdict).

subject_applies_once(Subject) :-
    uae_pdpl_scope_and_exclusions_subject(Subject),
    uae_pdpl_scope_and_exclusions_profile_for(Subject, Profile),
    findall(Result - Citations, pdpl_applies(Profile, Result, Citations), [_]).

subject_in_force_once(Subject) :-
    uae_pdpl_scope_and_exclusions_subject(Subject),
    uae_pdpl_scope_and_exclusions_profile_for(Subject, Profile),
    findall(Result - Citations, pdpl_in_force(Profile, Result, Citations), [_]).

consistent_answer(applies, [_|_]).
consistent_answer(does_not_apply, [cite(uae_pdpl_art_2_1), cite(uae_pdpl_art_2_2)]).
consistent_answer(not_in_force, [cite(uae_pdpl_art_31)]).
consistent_answer(in_force, [cite(uae_pdpl_art_31)]).
consistent_answer(indeterminate([MissingKey]), []) :-
    atom(MissingKey).
consistent_answer(needs_legal_review(open_textured(ReferredKey, cite(CitationKey)), [inputs_relied_on(ReliedPairs)]), []) :-
    atom(ReferredKey),
    atom(CitationKey),
    clausal_is_list(ReliedPairs).
consistent_answer(input_problems([_|_]), []).

subject_answers_consistently(Subject) :-
    uae_pdpl_scope_and_exclusions_subject(Subject),
    uae_pdpl_scope_and_exclusions_profile_for(Subject, Profile),
    pdpl_applies(Profile, Result, Citations),
    consistent_answer(Result, Citations),
    pdpl_in_force(Profile, InForceResult, InForceCitations),
    consistent_answer(InForceResult, InForceCitations).

attribute_pair(attribute(AttributeKey, AttributeValue), AttributeKey - AttributeValue).

subject_pairs_are_present_attributes(Subject) :-
    uae_pdpl_scope_and_exclusions_subject(Subject),
    uae_pdpl_scope_and_exclusions_profile_for(Subject, Profile),
    pdpl_applies(Profile, needs_legal_review(_, [inputs_relied_on(ReliedPairs)]), []),
    maplist(attribute_pair, Profile, ExpectedPairs),
    ReliedPairs == ExpectedPairs.

well_formed_dated_subject(Subject) :-
    uae_pdpl_scope_and_exclusions_subject(Subject),
    uae_pdpl_scope_and_exclusions_profile_for(Subject, Profile),
    uae_pdpl_scope_and_exclusions_input_problems(Profile, []),
    member(attribute(processing_date, _), Profile).

in_force_reads_only_the_day(Subject) :-
    well_formed_dated_subject(Subject),
    uae_pdpl_scope_and_exclusions_profile_for(Subject, Profile),
    member(attribute(processing_date, ProcessingDate), Profile),
    pdpl_in_force(Profile, Result, Citations),
    pdpl_in_force([attribute(processing_date, ProcessingDate)], Result, Citations).

subject_not_in_force_by_applies(Subject) :-
    uae_pdpl_scope_and_exclusions_subject(Subject),
    uae_pdpl_scope_and_exclusions_profile_for(Subject, Profile),
    pdpl_applies(Profile, not_in_force, _).

subject_not_in_force_by_both(Subject) :-
    subject_not_in_force_by_applies(Subject),
    uae_pdpl_scope_and_exclusions_profile_for(Subject, Profile),
    pdpl_in_force(Profile, not_in_force, _).

test(totality_every_subject_classifies) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_pdpl_applies_answers_once_per_subject) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_applies_once(Subject), OnceSubjects),
    sort(OnceSubjects, OnceSubjectSet),
    OnceSubjectSet == SubjectSet.
test(determinism_pdpl_in_force_answers_once_per_subject) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_in_force_once(Subject), OnceSubjects),
    sort(OnceSubjects, OnceSubjectSet),
    OnceSubjectSet == SubjectSet.
test(citation_discipline_holds_for_every_subject) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_answers_consistently(Subject), ConsistentSubjects),
    sort(ConsistentSubjects, SubjectSet).
test(applies_has_one_citation_set_however_reached) :-
    findall(Citations, (uae_pdpl_scope_and_exclusions_subject(Subject), uae_pdpl_scope_and_exclusions_profile_for(Subject, Profile), pdpl_applies(Profile, applies, Citations)), CitationLists),
    sort(CitationLists, [_]).
test(the_pairs_rule_holds_for_every_referral) :-
    findall(Subject, subject_pairs_are_present_attributes(Subject), Subjects),
    sort(Subjects, SubjectSet),
    SubjectSet == [free_zone_judgement_unsure, processing_judgement_unsure].
test(in_force_reads_only_the_day_for_every_dated_subject) :-
    findall(Subject, well_formed_dated_subject(Subject), Dated),
    sort(Dated, DatedSet),
    DatedSet = [_|_],
    findall(Subject, in_force_reads_only_the_day(Subject), Agreeing),
    sort(Agreeing, DatedSet).
test(the_queries_agree_on_not_in_force) :-
    findall(Subject, subject_not_in_force_by_applies(Subject), ByApplies),
    ByApplies = [_|_],
    findall(Subject, subject_not_in_force_by_both(Subject), ByBoth),
    ByBoth == ByApplies.

test(a_final_answer_with_no_citation_is_inconsistent, fail) :-
    consistent_answer(applies, []).
test(a_non_final_answer_with_a_citation_is_inconsistent, fail) :-
    consistent_answer(indeterminate([processing_date]), [cite(uae_pdpl_art_31)]).
test(a_two_key_indeterminate_is_inconsistent, fail) :-
    consistent_answer(indeterminate([processing_date, data_subject_inside_state]), []).
test(an_unregistered_subject_does_not_classify, fail) :-
    subject_classifies(no_such_subject).

cp_test_names([totality_every_subject_classifies, determinism_pdpl_applies_answers_once_per_subject, determinism_pdpl_in_force_answers_once_per_subject, citation_discipline_holds_for_every_subject, applies_has_one_citation_set_however_reached, the_pairs_rule_holds_for_every_referral, in_force_reads_only_the_day_for_every_dated_subject, the_queries_agree_on_not_in_force]).
cp_test_fail_names([a_final_answer_with_no_citation_is_inconsistent, a_non_final_answer_with_a_citation_is_inconsistent, a_two_key_indeterminate_is_inconsistent, an_unregistered_subject_does_not_classify]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
