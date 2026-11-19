% SPDX-License-Identifier: EUPL-1.2
:- module(m__uk_uk_complaints_to_the_commissioner_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_uk_complaints_to_the_commissioner_uk_complaints_to_the_commissioner, [decide_uk_complaints_to_the_commissioner/2, controller_complaint_right/3, commission_complaint_right/3, acknowledgement_last_day/3]).
:- use_module(m__uk_uk_complaints_to_the_commissioner_fixtures, [uk_complaints_to_the_commissioner_subject/1, uk_complaints_to_the_commissioner_profile_for/2]).

key_choice(complaint_by_data_subject_about_own_personal_data, Choice) :-
    member(Choice, [absent, present(true), present(false)]).
key_choice(infringement_considered, Choice) :-
    member(Choice, [absent, present(uk_gdpr), present(dpa_2018_part_3), present(dpa_2018_part_4), present(none_of_the_three)]).
key_choice(complaint_made_to_the_controller, Choice) :-
    member(Choice, [absent, present(true), present(false)]).

choice_attributes(_, absent, []).
choice_attributes(ProfileKey, present(Value), [attribute(ProfileKey, Value)]).

completion_profile(Profile) :-
    key_choice(complaint_by_data_subject_about_own_personal_data, SubjectChoice),
    choice_attributes(complaint_by_data_subject_about_own_personal_data, SubjectChoice, SubjectAttributes),
    key_choice(infringement_considered, InfringementChoice),
    choice_attributes(infringement_considered, InfringementChoice, InfringementAttributes),
    key_choice(complaint_made_to_the_controller, ControllerChoice),
    choice_attributes(complaint_made_to_the_controller, ControllerChoice, ControllerAttributes),
    append([SubjectAttributes, InfringementAttributes, ControllerAttributes], Profile).

controller_count(Profile, Count) :-
    findall(Result - Citations, controller_complaint_right(Profile, Result, Citations), Answers),
    length(Answers, Count).

commission_count(Profile, Count) :-
    findall(Result - Citations, commission_complaint_right(Profile, Result, Citations), Answers),
    length(Answers, Count).

subject_profile(Subject, Profile) :-
    uk_complaints_to_the_commissioner_subject(Subject),
    uk_complaints_to_the_commissioner_profile_for(Subject, Profile).

test(totality_every_subject_classifies) :-
    findall(Subject, uk_complaints_to_the_commissioner_subject(Subject), Subjects),
    findall(Subject, (subject_profile(Subject, Profile), decide_uk_complaints_to_the_commissioner(Profile, _Verdict)), Classified),
    Classified == Subjects.
test(determinism_controller_on_every_subject) :-
    findall(Subject - 1, uk_complaints_to_the_commissioner_subject(Subject), Expected),
    findall(Subject - Count, (subject_profile(Subject, Profile), controller_count(Profile, Count)), Pairs),
    Pairs == Expected.
test(determinism_commission_on_every_subject) :-
    findall(Subject - 1, uk_complaints_to_the_commissioner_subject(Subject), Expected),
    findall(Subject - Count, (subject_profile(Subject, Profile), commission_count(Profile, Count)), Pairs),
    Pairs == Expected.
test(controller_one_answer_for_every_completion) :-
    findall(Count, (completion_profile(Profile), controller_count(Profile, Count)), Counts),
    length(Counts, 45),
    sort(Counts, [1]).
test(commission_one_answer_for_every_completion) :-
    findall(Count, (completion_profile(Profile), commission_count(Profile, Count)), Counts),
    length(Counts, 45),
    sort(Counts, [1]).
test(controller_answers_are_the_contract_answers) :-
    findall(Result - Citations, (completion_profile(Profile), controller_complaint_right(Profile, Result, Citations)), Answers),
    sort(Answers, AnswerSet),
    length(AnswerSet, 5),
    member(complaint_under_section_164a - [cite(uk_dpa_2018_s_164a_1)], AnswerSet),
    member(not_a_complaint_under_section_164a - [cite(uk_dpa_2018_s_164a_1)], AnswerSet),
    member(indeterminate([complaint_by_data_subject_about_own_personal_data]) - [], AnswerSet),
    member(indeterminate([infringement_considered]) - [], AnswerSet),
    member(indeterminate([complaint_made_to_the_controller]) - [], AnswerSet).
test(commission_answers_are_the_contract_answers) :-
    findall(Result - Citations, (completion_profile(Profile), commission_complaint_right(Profile, Result, Citations)), Answers),
    sort(Answers, AnswerSet),
    length(AnswerSet, 4),
    member(complaint_under_section_165_2 - [cite(uk_dpa_2018_s_165_2)], AnswerSet),
    member(not_a_complaint_under_section_165_2 - [cite(uk_dpa_2018_s_165_2)], AnswerSet),
    member(indeterminate([complaint_by_data_subject_about_own_personal_data]) - [], AnswerSet),
    member(indeterminate([infringement_considered]) - [], AnswerSet).
test(a_deciding_false_settles_both_queries) :-
    findall(Result, (completion_profile(Profile), member(attribute(complaint_by_data_subject_about_own_personal_data, false), Profile), controller_complaint_right(Profile, Result, _)), ControllerResults),
    sort(ControllerResults, [not_a_complaint_under_section_164a]),
    findall(Result, (completion_profile(Profile), member(attribute(complaint_by_data_subject_about_own_personal_data, false), Profile), commission_complaint_right(Profile, Result, _)), CommissionResults),
    sort(CommissionResults, [not_a_complaint_under_section_165_2]).
test(commission_does_not_read_the_controller_key) :-
    findall(Profile, completion_profile(Profile), Profiles),
    findall(Profile, (completion_profile(Profile), commission_ignores_controller_key(Profile)), Ignoring),
    length(Profiles, Count),
    length(Ignoring, Count).
test(a_controller_complaint_is_also_a_commission_complaint) :-
    findall(Profile, controller_positive_profile(Profile), Positives),
    length(Positives, 2),
    findall(Profile, (controller_positive_profile(Profile), commission_complaint_right(Profile, complaint_under_section_165_2, _)), Both),
    length(Both, 2).
test(acknowledgement_one_answer_per_receipt) :-
    findall(Count, (sample_receipt(Receipt), receipt_count(Receipt, Count)), Counts),
    length(Counts, 8),
    sort(Counts, [1]).
test(acknowledgement_citations_are_set_like) :-
    findall(Citations, (sample_receipt(Receipt), acknowledgement_last_day(Receipt, _, Citations)), CitationLists),
    findall(Citations, (member(Citations, CitationLists), sort(Citations, Sorted), length(Citations, Length), length(Sorted, Length)), SetLike),
    length(CitationLists, Count),
    length(SetLike, Count).

without_controller_key([], []).
without_controller_key([attribute(complaint_made_to_the_controller, _)|Attributes], Rest) :-
    without_controller_key(Attributes, Rest).
without_controller_key([attribute(ProfileKey, Value)|Attributes], [attribute(ProfileKey, Value)|Rest]) :-
    dif(ProfileKey, complaint_made_to_the_controller),
    without_controller_key(Attributes, Rest).

commission_ignores_controller_key(Profile) :-
    without_controller_key(Profile, Stripped),
    commission_complaint_right(Profile, Result, Citations),
    commission_complaint_right(Stripped, Result, Citations).

controller_positive_profile(Profile) :-
    completion_profile(Profile),
    controller_complaint_right(Profile, complaint_under_section_164a, _).

sample_receipt(date(2026, 6, 18)).
sample_receipt(date(2026, 6, 19)).
sample_receipt(date(2026, 12, 15)).
sample_receipt(date(2027, 2, 10)).
sample_receipt(date(2028, 2, 29)).
sample_receipt(date(2027, 2, 29)).
sample_receipt(date(2200, 1, 1)).
sample_receipt(nineteenth_june).

receipt_count(Receipt, Count) :-
    findall(LastDay - Citations, acknowledgement_last_day(Receipt, LastDay, Citations), Answers),
    length(Answers, Count).

cp_test_names([totality_every_subject_classifies, determinism_controller_on_every_subject, determinism_commission_on_every_subject, controller_one_answer_for_every_completion, commission_one_answer_for_every_completion, controller_answers_are_the_contract_answers, commission_answers_are_the_contract_answers, a_deciding_false_settles_both_queries, commission_does_not_read_the_controller_key, a_controller_complaint_is_also_a_commission_complaint, acknowledgement_one_answer_per_receipt, acknowledgement_citations_are_set_like]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
