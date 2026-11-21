% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_contract_provisions_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_dora_ict_third_party_contract_provisions, [decide_dora_ict_third_party_contract_provisions/2, dora_ict_third_party_contract_provisions_status/2, contract_provisions_required/3, contract_provisions_sufficient/3, contract_provisions_missing/3]).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_kernel, [dora_ict_third_party_contract_provisions_input_problems/2]).
:- use_module(m__eu_dora_ict_third_party_contract_provisions_fixtures, [dora_ict_third_party_contract_provisions_subject/1, dora_ict_third_party_contract_provisions_profile_for/2]).

all_subjects(Subjects) :-
    findall(Subject, dora_ict_third_party_contract_provisions_subject(Subject), Subjects).

subject_classifies(Subject) :-
    dora_ict_third_party_contract_provisions_subject(Subject),
    dora_ict_third_party_contract_provisions_profile_for(Subject, Profile),
    decide_dora_ict_third_party_contract_provisions(Profile, _Verdict).

answers_once(Query, Subject) :-
    dora_ict_third_party_contract_provisions_profile_for(Subject, Profile),
    findall(OneResult - OneCitations, call(Query, Profile, OneResult, OneCitations), Answers),
    Answers = [Result - Citations],
    citations_fit(Result, Citations).

input_check_once(Subject) :-
    dora_ict_third_party_contract_provisions_profile_for(Subject, Profile),
    findall(Problems, dora_ict_third_party_contract_provisions_input_problems(Profile, Problems), Answers),
    Answers = [_OnlyProblems].

citations_fit(indeterminate([_]), []).
citations_fit(needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on(_)]), []).
citations_fit(input_problems([_|_]), []).
citations_fit(sufficient, Citations) :-
    cite_list(Citations).
citations_fit(insufficient, Citations) :-
    cite_list(Citations).
citations_fit(none_missing, Citations) :-
    cite_list(Citations).
citations_fit(required([_|_]), Citations) :-
    cite_list(Citations).
citations_fit(missing([_|_]), Citations) :-
    cite_list(Citations).

cite_list([Citation|Citations]) :-
    maplist(cite_term, [Citation|Citations]),
    sort([Citation|Citations], Distinct),
    length([Citation|Citations], Count),
    length(Distinct, Count).

cite_term(cite(CitationKey)) :-
    atom(CitationKey).

subject_with_sufficiency(Answer, Subject) :-
    dora_ict_third_party_contract_provisions_subject(Subject),
    dora_ict_third_party_contract_provisions_profile_for(Subject, Profile),
    contract_provisions_sufficient(Profile, Answer, _).

misses_nothing(Subject) :-
    dora_ict_third_party_contract_provisions_profile_for(Subject, Profile),
    contract_provisions_missing(Profile, none_missing, _).

not_none_missing(Subject) :-
    dora_ict_third_party_contract_provisions_profile_for(Subject, Profile),
    contract_provisions_missing(Profile, Result, _),
    dif(Result, none_missing).

status_matches_sufficiency(Subject) :-
    dora_ict_third_party_contract_provisions_profile_for(Subject, Profile),
    dora_ict_third_party_contract_provisions_status(Profile, Status),
    contract_provisions_sufficient(Profile, Answer, _),
    Status == Answer.

test(totality_every_subject_classifies) :-
    all_subjects(Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(required_answers_exactly_once_for_every_subject) :-
    all_subjects(Subjects),
    maplist(answers_once(contract_provisions_required), Subjects).
test(sufficient_answers_exactly_once_for_every_subject) :-
    all_subjects(Subjects),
    maplist(answers_once(contract_provisions_sufficient), Subjects).
test(missing_answers_exactly_once_for_every_subject) :-
    all_subjects(Subjects),
    maplist(answers_once(contract_provisions_missing), Subjects).
test(the_input_check_answers_exactly_once_for_every_subject) :-
    all_subjects(Subjects),
    maplist(input_check_once, Subjects).
test(a_sufficient_contract_misses_nothing) :-
    findall(Subject, subject_with_sufficiency(sufficient, Subject), Subjects),
    Subjects = [_|_],
    maplist(misses_nothing, Subjects).
test(an_insufficient_contract_is_never_none_missing) :-
    findall(Subject, subject_with_sufficiency(insufficient, Subject), Subjects),
    Subjects = [_|_],
    maplist(not_none_missing, Subjects).
test(the_status_is_the_sufficiency_answer) :-
    all_subjects(Subjects),
    maplist(status_matches_sufficiency, Subjects).

cp_test_names([totality_every_subject_classifies, required_answers_exactly_once_for_every_subject, sufficient_answers_exactly_once_for_every_subject, missing_answers_exactly_once_for_every_subject, the_input_check_answers_exactly_once_for_every_subject, a_sufficient_contract_misses_nothing, an_insufficient_contract_is_never_none_missing, the_status_is_the_sufficiency_answer]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
