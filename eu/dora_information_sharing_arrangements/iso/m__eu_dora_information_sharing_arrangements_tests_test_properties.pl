% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_information_sharing_arrangements_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_information_sharing_arrangements_dora_information_sharing_arrangements, [decide_dora_information_sharing_arrangements/2, information_sharing_within_article_45/3, membership_notification_duty/3]).
:- use_module(m__eu_dora_information_sharing_arrangements_fixtures, [dora_information_sharing_arrangements_subject/1, dora_information_sharing_arrangements_profile_for/2]).

condition_keys([information_is_cyber_threat_information_and_intelligence, sharing_aims_to_enhance_digital_operational_resilience, sharing_takes_place_within_trusted_community_of_financial_entities, arrangement_protects_sensitive_information_and_has_rules_of_conduct, arrangement_defines_participation_conditions_and_appropriate_details]).

subject_classifies(Subject) :-
    dora_information_sharing_arrangements_subject(Subject),
    dora_information_sharing_arrangements_profile_for(Subject, Profile),
    decide_dora_information_sharing_arrangements(Profile, _Verdict).

subject_answers_once(Subject) :-
    dora_information_sharing_arrangements_profile_for(Subject, Profile),
    findall(Result - Citations, information_sharing_within_article_45(Profile, Result, Citations), [_SharingAnswer]),
    findall(Result - Citations, membership_notification_duty(Profile, Result, Citations), [_DutyAnswer]).

answer_shape_ok(Result, Citations) :-
    atom(Result),
    Citations = [_|_],
    maplist(is_citation, Citations).
answer_shape_ok(Result, []) :-
    compound(Result).

is_citation(cite(CitationKey)) :-
    atom(CitationKey).

subject_answers_well_shaped(Subject) :-
    dora_information_sharing_arrangements_profile_for(Subject, Profile),
    information_sharing_within_article_45(Profile, SharingResult, SharingCitations),
    answer_shape_ok(SharingResult, SharingCitations),
    membership_notification_duty(Profile, DutyResult, DutyCitations),
    answer_shape_ok(DutyResult, DutyCitations).

unsure_attribute(ConditionKey, attribute(ConditionKey, unsure)).

false_decides_alone_among_unsure(ConditionKey) :-
    condition_keys(ConditionKeys),
    select(ConditionKey, ConditionKeys, OtherKeys),
    maplist(unsure_attribute, OtherKeys, UnsureAttributes),
    findall(Result, information_sharing_within_article_45([attribute(ConditionKey, false)|UnsureAttributes], Result, _Citations), Results),
    Results == [sharing_outside_article_45].

false_decides_alone_among_absent(ConditionKey) :-
    findall(Result, information_sharing_within_article_45([attribute(ConditionKey, false)], Result, _Citations), Results),
    Results == [sharing_outside_article_45].

test(totality_every_subject_classifies) :-
    findall(Subject, dora_information_sharing_arrangements_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_answers_exactly_once_in_both_queries) :-
    findall(Subject, dora_information_sharing_arrangements_subject(Subject), Subjects),
    maplist(subject_answers_once, Subjects).
test(answer_shape_on_every_subject) :-
    findall(Subject, dora_information_sharing_arrangements_subject(Subject), Subjects),
    maplist(subject_answers_well_shaped, Subjects).
test(a_false_condition_decides_alone_whatever_the_others) :-
    condition_keys(ConditionKeys),
    maplist(false_decides_alone_among_unsure, ConditionKeys),
    maplist(false_decides_alone_among_absent, ConditionKeys).
test(an_unsure_judgement_is_never_decided) :-
    condition_keys(ConditionKeys),
    maplist(unsure_attribute, ConditionKeys, Profile),
    findall(Result - Citations, information_sharing_within_article_45(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(information_is_cyber_threat_information_and_intelligence, cite(eu_reg_2022_2554_art_45_1)), [inputs_relied_on([information_is_cyber_threat_information_and_intelligence - unsure, sharing_aims_to_enhance_digital_operational_resilience - unsure, sharing_takes_place_within_trusted_community_of_financial_entities - unsure, arrangement_protects_sensitive_information_and_has_rules_of_conduct - unsure, arrangement_defines_participation_conditions_and_appropriate_details - unsure])]) - []].
test(the_duty_query_reads_none_of_the_five_conditions) :-
    dora_information_sharing_arrangements_profile_for(all_conditions_met, MetProfile),
    dora_information_sharing_arrangements_profile_for(paragraph_2_false, MissProfile),
    membership_notification_duty(MetProfile, MetResult, MetCitations),
    membership_notification_duty(MissProfile, MissResult, MissCitations),
    MetResult == MissResult,
    MetCitations == MissCitations.
test(the_sharing_query_reads_neither_duty_key) :-
    Base = [attribute(information_is_cyber_threat_information_and_intelligence, true), attribute(sharing_aims_to_enhance_digital_operational_resilience, true), attribute(sharing_takes_place_within_trusted_community_of_financial_entities, true), attribute(arrangement_protects_sensitive_information_and_has_rules_of_conduct, true), attribute(arrangement_defines_participation_conditions_and_appropriate_details, true)],
    information_sharing_within_article_45(Base, sharing_within_article_45, _BaseCitations),
    information_sharing_within_article_45([attribute(membership_event, no_membership_event), attribute(arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, false)|Base], sharing_within_article_45, _OtherCitations).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_answers_exactly_once_in_both_queries, answer_shape_on_every_subject, a_false_condition_decides_alone_whatever_the_others, an_unsure_judgement_is_never_decided, the_duty_query_reads_none_of_the_five_conditions, the_sharing_query_reads_neither_duty_key]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
