% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_information_sharing_voluntary_notification_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_nis2_information_sharing_voluntary_notification, [voluntary_notification_possible/3, information_exchange_permitted/3, arrangement_notification_duty/3, decide_nis2_information_sharing_voluntary_notification/2, nis2_information_sharing_voluntary_notification_status_values/1]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_kernel, [nis2_information_sharing_voluntary_notification_input_problems/2]).
:- use_module(m__eu_nis2_information_sharing_voluntary_notification_fixtures, [nis2_information_sharing_voluntary_notification_subject/1, nis2_information_sharing_voluntary_notification_profile_for/2]).

query_name(voluntary_notification_possible).
query_name(information_exchange_permitted).
query_name(arrangement_notification_duty).

query_answer(voluntary_notification_possible, Profile, Result, Citations) :-
    voluntary_notification_possible(Profile, Result, Citations).
query_answer(information_exchange_permitted, Profile, Result, Citations) :-
    information_exchange_permitted(Profile, Result, Citations).
query_answer(arrangement_notification_duty, Profile, Result, Citations) :-
    arrangement_notification_duty(Profile, Result, Citations).

final_atom(voluntary_notification_possible, voluntary_notification_possible).
final_atom(voluntary_notification_possible, voluntary_notification_not_possible).
final_atom(information_exchange_permitted, information_exchange_permitted).
final_atom(information_exchange_permitted, information_exchange_not_permitted).
final_atom(arrangement_notification_duty, must_notify_on_entering).
final_atom(arrangement_notification_duty, must_notify_on_withdrawal_taking_effect).
final_atom(arrangement_notification_duty, no_notification_duty).

contract_keys([entity_class, event_kind, arrangement_event, information_is_relevant_cybersecurity_information, sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, sharing_enhances_the_level_of_cybersecurity, arrangement_is_a_cybersecurity_information_sharing_arrangement]).

subject_profile(Subject, Profile) :-
    nis2_information_sharing_voluntary_notification_subject(Subject),
    nis2_information_sharing_voluntary_notification_profile_for(Subject, Profile).

subject_count(SubjectCount) :-
    findall(Subject, nis2_information_sharing_voluntary_notification_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    length(SubjectSet, SubjectCount).

single_answer(Query, Subject) :-
    subject_profile(Subject, Profile),
    findall(Result - Citations, query_answer(Query, Profile, Result, Citations), Answers),
    length(Answers, 1).

well_shaped_answer(Query, Subject) :-
    subject_profile(Subject, Profile),
    query_answer(Query, Profile, Result, Citations),
    answer_well_shaped(Query, Result, Citations).

answer_well_shaped(Query, Result, [Citation|Citations]) :-
    final_atom(Query, Result),
    set_like_citations([Citation|Citations]).
answer_well_shaped(_, indeterminate([MissingKey|MissingKeys]), []) :-
    contract_keys(ContractKeys),
    ordered_subsequence([MissingKey|MissingKeys], ContractKeys).
answer_well_shaped(_, needs_legal_review(open_textured(InputKey, cite(CitationKey)), [inputs_relied_on([FirstPair|OtherPairs])]), []) :-
    atom(InputKey),
    atom(CitationKey),
    member(InputKey - unsure, [FirstPair|OtherPairs]).
answer_well_shaped(_, input_problems([_|_]), []).

set_like_citations(Citations) :-
    maplist(citation_term, Citations),
    sort(Citations, SortedCitations),
    length(SortedCitations, Length),
    length(Citations, Length).

citation_term(cite(CitationKey)) :-
    atom(CitationKey).

ordered_subsequence([], _).
ordered_subsequence([InputKey|InputKeys], [InputKey|ContractKeys]) :-
    ordered_subsequence(InputKeys, ContractKeys).
ordered_subsequence([InputKey|InputKeys], [ContractKey|ContractKeys]) :-
    dif(InputKey, ContractKey),
    ordered_subsequence([InputKey|InputKeys], ContractKeys).

subject_classifies(Subject) :-
    subject_profile(Subject, Profile),
    decide_nis2_information_sharing_voluntary_notification(Profile, _Verdict).

subject_has_one_verdict(Subject) :-
    subject_profile(Subject, Profile),
    findall(Verdict, decide_nis2_information_sharing_voluntary_notification(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

subject_has_one_input_check(Subject) :-
    subject_profile(Subject, Profile),
    findall(Problems, nis2_information_sharing_voluntary_notification_input_problems(Profile, Problems), Answers),
    length(Answers, 1).

subject_status_is_known(Subject) :-
    subject_profile(Subject, Profile),
    decide_nis2_information_sharing_voluntary_notification(Profile, nis2_information_sharing_voluntary_notification_verdict(Status, _)),
    nis2_information_sharing_voluntary_notification_status_values(StatusValues),
    member(Status, StatusValues).

test(totality_every_subject_classifies) :-
    findall(Subject, nis2_information_sharing_voluntary_notification_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_one_facade_verdict) :-
    subject_count(SubjectCount),
    findall(Subject, subject_has_one_verdict(Subject), Subjects),
    length(Subjects, SubjectCount).
test(determinism_every_query_answers_every_subject_exactly_once) :-
    subject_count(SubjectCount),
    findall(Query - Subject, (query_name(Query), single_answer(Query, Subject)), Pairs),
    length(Pairs, PairCount),
    ExpectedCount is 3 * SubjectCount,
    PairCount =:= ExpectedCount.
test(every_answer_has_the_contract_shape) :-
    subject_count(SubjectCount),
    findall(Query - Subject, (query_name(Query), well_shaped_answer(Query, Subject)), Pairs),
    length(Pairs, PairCount),
    ExpectedCount is 3 * SubjectCount,
    PairCount =:= ExpectedCount.
test(the_input_check_answers_every_subject_exactly_once) :-
    subject_count(SubjectCount),
    findall(Subject, subject_has_one_input_check(Subject), Subjects),
    length(Subjects, SubjectCount).
test(every_facade_status_is_in_the_vocabulary) :-
    subject_count(SubjectCount),
    findall(Subject, subject_status_is_known(Subject), Subjects),
    length(Subjects, SubjectCount).
test(an_essential_or_important_entity_can_notify_every_event_kind) :-
    findall(EntityClass - EventKind - Result, (member(EntityClass, [essential_entity, important_entity]), member(EventKind, [incident, significant_incident, cyber_threat, near_miss]), voluntary_notification_possible([attribute(entity_class, EntityClass), attribute(event_kind, EventKind)], Result, _)), Answers),
    findall(EntityClass - EventKind - voluntary_notification_possible, (member(EntityClass, [essential_entity, important_entity]), member(EventKind, [incident, significant_incident, cyber_threat, near_miss])), Expected),
    Answers == Expected.
test(an_other_entity_never_has_an_arrangement_duty) :-
    findall(Result, (member(ArrangementEvent, [entered, withdrew, no_arrangement_event]), member(Judgement, [true, false, unsure]), arrangement_notification_duty([attribute(entity_class, out_of_scope), attribute(arrangement_event, ArrangementEvent), attribute(arrangement_is_a_cybersecurity_information_sharing_arrangement, Judgement)], Result, _)), Results),
    length(Results, 9),
    sort(Results, ResultSet),
    ResultSet == [no_notification_duty].
test(a_mandatory_flag_is_not_an_input_of_the_voluntary_route) :-
    voluntary_notification_possible([attribute(entity_class, essential_entity), attribute(mandatory_under_art_23, true)], input_problems([unknown_key(mandatory_under_art_23)]), []).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_one_facade_verdict, determinism_every_query_answers_every_subject_exactly_once, every_answer_has_the_contract_shape, the_input_check_answers_every_subject_exactly_once, every_facade_status_is_in_the_vocabulary, an_essential_or_important_entity_can_notify_every_event_kind, an_other_entity_never_has_an_arrangement_duty, a_mandatory_flag_is_not_an_input_of_the_voluntary_route]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
