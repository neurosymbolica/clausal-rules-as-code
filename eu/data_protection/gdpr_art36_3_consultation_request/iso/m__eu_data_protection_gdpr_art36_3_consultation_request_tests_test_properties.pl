% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art36_3_consultation_request_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_gdpr_art36_3_consultation_request, [consultation_request_status/4, missing_consultation_request_items/4, decide_gdpr_art36_3_consultation_request/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_kernel, [gdpr_art36_3_consultation_request_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art36_3_consultation_request_fixtures, [gdpr_art36_3_consultation_request_subject/1, gdpr_art36_3_consultation_request_profile_for/2]).

seven_citations([cite(eu_reg_2016_679_art_36_3), cite(eu_reg_2016_679_art_36_3_a), cite(eu_reg_2016_679_art_36_3_b), cite(eu_reg_2016_679_art_36_3_c), cite(eu_reg_2016_679_art_36_3_d), cite(eu_reg_2016_679_art_36_3_e), cite(eu_reg_2016_679_art_36_3_f)]).

subject_classifies(Subject) :-
    gdpr_art36_3_consultation_request_subject(Subject),
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    decide_gdpr_art36_3_consultation_request(Profile, _Verdict).

status_count(Subject, Count) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, consultation_request_status(Profile, Result, Basis, Citations), Answers),
    length(Answers, Count).

items_count(Subject, Count) :-
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    findall(Items - Basis - Citations, missing_consultation_request_items(Profile, Items, Basis, Citations), Answers),
    length(Answers, Count).

problems_count(Term, Count) :-
    findall(Problems, gdpr_art36_3_consultation_request_input_problems(Term, Problems), Answers),
    length(Answers, Count).

status_shape(consultation_request_complete, Basis, Citations) :-
    is_list(Basis),
    seven_citations(Citations).
status_shape(consultation_request_incomplete, Basis, Citations) :-
    is_list(Basis),
    seven_citations(Citations).
status_shape(not_governed_by_article_36_3, [], [cite(eu_reg_2016_679_art_36_3)]).
status_shape(indeterminate([_MissingKey]), [], []).
status_shape(needs_legal_review(_Reason, _Context), [], []).
status_shape(input_problems([_FirstProblem|_OtherProblems]), [], []).

items_shape([], Basis, Citations) :-
    is_list(Basis),
    seven_citations(Citations).
items_shape([_FirstItem|_OtherItems], Basis, Citations) :-
    is_list(Basis),
    seven_citations(Citations).
items_shape(not_governed_by_article_36_3, [], [cite(eu_reg_2016_679_art_36_3)]).
items_shape(indeterminate([_MissingKey]), [], []).
items_shape(needs_legal_review(_Reason, _Context), [], []).
items_shape(input_problems([_FirstProblem|_OtherProblems]), [], []).

items_status_agree([], consultation_request_complete).
items_status_agree([_FirstItem|_OtherItems], consultation_request_incomplete).

listed_subject(Subject) :-
    gdpr_art36_3_consultation_request_subject(Subject),
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    missing_consultation_request_items(Profile, Items, _, _),
    is_list(Items).

agreeing_subject(Subject) :-
    listed_subject(Subject),
    gdpr_art36_3_consultation_request_profile_for(Subject, Profile),
    missing_consultation_request_items(Profile, Items, _, _),
    consultation_request_status(Profile, Status, _, _),
    items_status_agree(Items, Status).

odd_term(unbound_profile, _Unbound).
odd_term(number_profile, 42).
odd_term(atom_profile, profile).
odd_term(partial_list, [attribute(consultation_under_article_36_1, true)|_Tail]).
odd_term(unbound_element, [_Element]).
odd_term(foreign_element, [attribute(consultation_under_article_36_1)]).
odd_term(unbound_key, [attribute(_Key, true)]).
odd_term(unbound_value, [attribute(purposes_and_means_provided, _Value)]).
odd_term(empty_profile, []).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_art36_3_consultation_request_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(the_subject_set_is_not_vacuous) :-
    findall(Subject, gdpr_art36_3_consultation_request_subject(Subject), Subjects),
    length(Subjects, Count),
    Count >= 20.
test(determinism_status_exactly_one_answer_per_subject) :-
    findall(Subject - Count, (gdpr_art36_3_consultation_request_subject(Subject), status_count(Subject, Count)), Pairs),
    findall(Subject - 1, gdpr_art36_3_consultation_request_subject(Subject), Expected),
    Pairs == Expected.
test(determinism_items_exactly_one_answer_per_subject) :-
    findall(Subject - Count, (gdpr_art36_3_consultation_request_subject(Subject), items_count(Subject, Count)), Pairs),
    findall(Subject - 1, gdpr_art36_3_consultation_request_subject(Subject), Expected),
    Pairs == Expected.
test(input_check_exactly_one_answer_for_every_odd_term) :-
    findall(Name - Count, (odd_term(Name, Term), problems_count(Term, Count)), Pairs),
    findall(Name - 1, odd_term(Name, _), Expected),
    Pairs == Expected.
test(input_check_exactly_one_answer_per_subject) :-
    findall(Subject - Count, (gdpr_art36_3_consultation_request_subject(Subject), gdpr_art36_3_consultation_request_profile_for(Subject, Profile), problems_count(Profile, Count)), Pairs),
    findall(Subject - 1, gdpr_art36_3_consultation_request_subject(Subject), Expected),
    Pairs == Expected.
test(every_status_answer_has_its_basis_and_citation_shape) :-
    findall(Subject, (gdpr_art36_3_consultation_request_subject(Subject), gdpr_art36_3_consultation_request_profile_for(Subject, Profile), consultation_request_status(Profile, Result, Basis, Citations), status_shape(Result, Basis, Citations)), Shaped),
    findall(Subject, gdpr_art36_3_consultation_request_subject(Subject), Subjects),
    Shaped == Subjects.
test(every_items_answer_has_its_basis_and_citation_shape) :-
    findall(Subject, (gdpr_art36_3_consultation_request_subject(Subject), gdpr_art36_3_consultation_request_profile_for(Subject, Profile), missing_consultation_request_items(Profile, Items, Basis, Citations), items_shape(Items, Basis, Citations)), Shaped),
    findall(Subject, gdpr_art36_3_consultation_request_subject(Subject), Subjects),
    Shaped == Subjects.
test(the_two_queries_agree_whenever_the_items_are_listed) :-
    findall(Subject, listed_subject(Subject), Listed),
    findall(Subject, agreeing_subject(Subject), Agreeing),
    Agreeing == Listed,
    length(Listed, Count),
    Count >= 5.
test(an_unread_key_does_not_change_the_answer) :-
    gdpr_art36_3_consultation_request_profile_for(officer_designated_contact_given, Profile),
    findall(Result - Basis - Citations, consultation_request_status(Profile, Result, Basis, Citations), Before),
    findall(Result - Basis - Citations, consultation_request_status([attribute(requested_other_information_provided, false)|Profile], Result, Basis, Citations), After),
    Before == After.
test(an_unread_outside_fact_does_not_change_the_answer) :-
    gdpr_art36_3_consultation_request_profile_for(officer_designated_contact_given, Profile),
    findall(Result - Basis - Citations, consultation_request_status(Profile, Result, Basis, Citations), Before),
    findall(Result - Basis - Citations, consultation_request_status([attribute(joint_controllers_or_processors_involved, attested(true, attestation(host_user, host_time, stated_by_caller, none)))|Profile], Result, Basis, Citations), After),
    Before == After.

cp_test_names([totality_every_subject_classifies, the_subject_set_is_not_vacuous, determinism_status_exactly_one_answer_per_subject, determinism_items_exactly_one_answer_per_subject, input_check_exactly_one_answer_for_every_odd_term, input_check_exactly_one_answer_per_subject, every_status_answer_has_its_basis_and_citation_shape, every_items_answer_has_its_basis_and_citation_shape, the_two_queries_agree_whenever_the_items_are_listed, an_unread_key_does_not_change_the_answer, an_unread_outside_fact_does_not_change_the_answer]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
