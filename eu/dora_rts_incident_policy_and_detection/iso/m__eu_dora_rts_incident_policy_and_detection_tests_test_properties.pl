% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_incident_policy_and_detection_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys/2]).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_dora_rts_incident_policy_and_detection, [decide_dora_rts_incident_policy_and_detection/2, rts_incident_policy_and_detection_duties_required/3, rts_incident_policy_and_detection_duties_complete/3, rts_incident_policy_and_detection_duties_outstanding/3, dora_rts_incident_policy_and_detection_checklist/2]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_kernel, [dora_rts_incident_policy_and_detection_input_problems/2]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_queries, [dora_rts_incident_policy_and_detection_profile_keys/1]).
:- use_module(m__eu_dora_rts_incident_policy_and_detection_fixtures, [dora_rts_incident_policy_and_detection_subject/1, dora_rts_incident_policy_and_detection_profile_for/2]).

query_name(required).
query_name(complete).
query_name(outstanding).

query_answer(Subject, required, Result, Citations) :-
    dora_rts_incident_policy_and_detection_profile_for(Subject, Profile),
    rts_incident_policy_and_detection_duties_required(Profile, Result, Citations).
query_answer(Subject, complete, Result, Citations) :-
    dora_rts_incident_policy_and_detection_profile_for(Subject, Profile),
    rts_incident_policy_and_detection_duties_complete(Profile, Result, Citations).
query_answer(Subject, outstanding, Result, Citations) :-
    dora_rts_incident_policy_and_detection_profile_for(Subject, Profile),
    rts_incident_policy_and_detection_duties_outstanding(Profile, Result, Citations).

answer_count(Subject, QueryName, Count) :-
    findall(Result - Citations, query_answer(Subject, QueryName, Result, Citations), Answers),
    length(Answers, Count).

subject_classifies(Subject) :-
    dora_rts_incident_policy_and_detection_subject(Subject),
    dora_rts_incident_policy_and_detection_profile_for(Subject, Profile),
    decide_dora_rts_incident_policy_and_detection(Profile, _Verdict).

citations_shape(required(_), [_|_]).
citations_shape(complete, [_|_]).
citations_shape(incomplete, [_|_]).
citations_shape(none_outstanding, [_|_]).
citations_shape(outstanding(_), [_|_]).
citations_shape(simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
citations_shape(indeterminate(_), []).
citations_shape(needs_legal_review(_, _), []).
citations_shape(input_problems(_), []).

allowed_citation(eu_reg_2024_1774_art_22).
allowed_citation(eu_reg_2024_1774_art_22_a).
allowed_citation(eu_reg_2024_1774_art_22_b).
allowed_citation(eu_reg_2024_1774_art_22_c).
allowed_citation(eu_reg_2024_1774_art_22_d).
allowed_citation(eu_reg_2024_1774_art_22_e).
allowed_citation(eu_reg_2024_1774_art_23_1).
allowed_citation(eu_reg_2024_1774_art_23_2).
allowed_citation(eu_reg_2024_1774_art_23_2_a).
allowed_citation(eu_reg_2024_1774_art_23_2_b).
allowed_citation(eu_reg_2024_1774_art_23_2_c).
allowed_citation(eu_reg_2024_1774_art_23_2_d).
allowed_citation(eu_reg_2024_1774_art_23_3).
allowed_citation(eu_reg_2024_1774_art_23_4).
allowed_citation(eu_reg_2024_1774_art_23_5).
allowed_citation(eu_reg_2024_1774_art_23_6).
allowed_citation(eu_reg_2022_2554_art_16_1).

fixed_result(required(_)).
fixed_result(complete).
fixed_result(incomplete).
fixed_result(none_outstanding).

query_pair_consistent(complete, none_outstanding).
query_pair_consistent(incomplete, outstanding(_)).
query_pair_consistent(incomplete, indeterminate(_)).
query_pair_consistent(incomplete, needs_legal_review(_, _)).
query_pair_consistent(simplified_framework_entity, simplified_framework_entity).
query_pair_consistent(indeterminate(MissingKeys), indeterminate(MissingKeys)).
query_pair_consistent(needs_legal_review(Reason, Context), needs_legal_review(Reason, Context)).
query_pair_consistent(input_problems(Problems), input_problems(Problems)).

subject_consistent(Subject) :-
    dora_rts_incident_policy_and_detection_subject(Subject),
    query_answer(Subject, complete, CompleteResult, _),
    query_answer(Subject, outstanding, OutstandingResult, _),
    query_pair_consistent(CompleteResult, OutstandingResult).

ordered_sublist([], _).
ordered_sublist([Element|Elements], [Element|Candidates]) :-
    ordered_sublist(Elements, Candidates).
ordered_sublist([Element|Elements], [Other|Candidates]) :-
    dif(Element, Other),
    ordered_sublist([Element|Elements], Candidates).

in_duty_order(AllDuties, DutyAtoms) :-
    ordered_sublist(DutyAtoms, AllDuties).

pairs_in_key_order(ContractKeys, Pairs) :-
    pairs_keys(Pairs, PairKeys),
    ordered_sublist(PairKeys, ContractKeys).

referral_pairs(needs_legal_review(_, [inputs_relied_on(Pairs)|_]), Pairs).

test(totality_every_subject_classifies) :-
    findall(Subject, dora_rts_incident_policy_and_detection_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_answers_once_for_every_subject) :-
    findall(Count, (dora_rts_incident_policy_and_detection_subject(Subject), query_name(QueryName), answer_count(Subject, QueryName, Count)), Counts),
    Counts = [_|_],
    sort(Counts, [1]).
test(determinism_the_input_check_answers_once_for_every_subject) :-
    findall(Count, (dora_rts_incident_policy_and_detection_subject(Subject), dora_rts_incident_policy_and_detection_profile_for(Subject, Profile), findall(Problems, dora_rts_incident_policy_and_detection_input_problems(Profile, Problems), Answers), length(Answers, Count)), Counts),
    Counts = [_|_],
    sort(Counts, [1]).
test(determinism_the_checklist_answers_once_for_every_subject) :-
    findall(Count, (dora_rts_incident_policy_and_detection_subject(Subject), dora_rts_incident_policy_and_detection_profile_for(Subject, Profile), findall(Items, dora_rts_incident_policy_and_detection_checklist(Profile, Items), Answers), length(Answers, Count)), Counts),
    Counts = [_|_],
    sort(Counts, [1]).
test(every_answer_has_the_citations_of_its_form) :-
    findall(Subject - QueryName, (dora_rts_incident_policy_and_detection_subject(Subject), query_name(QueryName)), Everything),
    findall(Subject - QueryName, (dora_rts_incident_policy_and_detection_subject(Subject), query_name(QueryName), query_answer(Subject, QueryName, Result, Citations), citations_shape(Result, Citations)), WellShaped),
    sort(Everything, EverythingSet),
    sort(WellShaped, WellShapedSet),
    WellShapedSet == EverythingSet.
test(every_citation_is_in_the_vocabulary) :-
    findall(CitationKey, (dora_rts_incident_policy_and_detection_subject(Subject), query_name(QueryName), query_answer(Subject, QueryName, _, Citations), member(cite(CitationKey), Citations)), CitationKeys),
    sort(CitationKeys, CitationKeySet),
    CitationKeySet = [_|_],
    maplist(allowed_citation, CitationKeySet).
test(settled_answers_cite_the_fixed_seven) :-
    findall(SortedCitations, (dora_rts_incident_policy_and_detection_subject(Subject), query_name(QueryName), query_answer(Subject, QueryName, Result, Citations), fixed_result(Result), clausal_msort(Citations, SortedCitations)), CitationLists),
    CitationLists = [_|_],
    sort(CitationLists, [FixedSet]),
    FixedSet == [cite(eu_reg_2024_1774_art_22), cite(eu_reg_2024_1774_art_23_1), cite(eu_reg_2024_1774_art_23_2), cite(eu_reg_2024_1774_art_23_3), cite(eu_reg_2024_1774_art_23_4), cite(eu_reg_2024_1774_art_23_5), cite(eu_reg_2024_1774_art_23_6)].
test(complete_and_outstanding_agree_on_every_subject) :-
    findall(Subject, dora_rts_incident_policy_and_detection_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_consistent(Subject), ConsistentSubjects),
    sort(ConsistentSubjects, SubjectSet).
test(outstanding_lists_keep_duty_order) :-
    query_answer(complete_entity, required, required(AllDuties), _),
    findall(DutyAtoms, (dora_rts_incident_policy_and_detection_subject(Subject), query_answer(Subject, outstanding, outstanding(DutyAtoms), _)), DutyLists),
    DutyLists = [_|_],
    maplist(in_duty_order(AllDuties), DutyLists).
test(referral_pairs_follow_the_contract_key_order) :-
    dora_rts_incident_policy_and_detection_profile_keys(ContractKeys),
    findall(Pairs, (dora_rts_incident_policy_and_detection_subject(Subject), query_name(QueryName), query_answer(Subject, QueryName, Result, _), referral_pairs(Result, Pairs)), PairLists),
    PairLists = [_|_],
    maplist(pairs_in_key_order(ContractKeys), PairLists).

cp_test_names([totality_every_subject_classifies, determinism_every_query_answers_once_for_every_subject, determinism_the_input_check_answers_once_for_every_subject, determinism_the_checklist_answers_once_for_every_subject, every_answer_has_the_citations_of_its_form, every_citation_is_in_the_vocabulary, settled_answers_cite_the_fixed_seven, complete_and_outstanding_agree_on_every_subject, outstanding_lists_keep_duty_order, referral_pairs_follow_the_contract_key_order]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
