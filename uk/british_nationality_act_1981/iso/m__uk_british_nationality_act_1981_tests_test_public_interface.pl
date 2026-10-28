:- module(m__uk_british_nationality_act_1981_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_british_nationality_act_1981_citations, [citation/2, implements/1]).
:- use_module(m__uk_british_nationality_act_1981_citizenship, [british_citizenship_status/3]).
:- use_module(m__uk_british_nationality_act_1981_registration, [british_citizenship_registration/4, registration_provision/1]).
:- use_module(m__uk_british_nationality_act_1981_naturalisation, [british_citizenship_naturalisation/4, naturalisation_provision/1]).
:- use_module(m__uk_british_nationality_act_1981_input_check, [british_nationality_input_problems/3]).
:- use_module(m__uk_british_nationality_act_1981_fixtures, [british_nationality_subject/1, british_nationality_profile_for/2]).

one_status(Subject) :-
    british_nationality_profile_for(Subject, Profile),
    findall(S, british_citizenship_status(Profile, date(2020, 1, 1), S), Answers),
    length(Answers, 1).

one_registration(Subject, Provision) :-
    british_nationality_profile_for(Subject, Profile),
    findall(R, british_citizenship_registration(Profile, Provision, date(2015, 1, 1), R), Answers),
    length(Answers, 1).

one_naturalisation(Subject, Provision) :-
    british_nationality_profile_for(Subject, Profile),
    findall(R, british_citizenship_naturalisation(Profile, Provision, date(2015, 1, 1), R), Answers),
    length(Answers, 1).

all_hold([], _).
all_hold([Item|Items], Check) :-
    call(Check, Item),
    all_hold(Items, Check).

test('there are 52 fixtures') :-
    findall(S, british_nationality_subject(S), Ss),
    length(Ss, 52).
test('every fixture has exactly one citizenship status') :-
    findall(S, british_nationality_subject(S), Ss),
    all_hold(Ss, one_status).
test('every fixture has exactly one answer for each registration provision') :-
    findall(S - P, (british_nationality_subject(S), registration_provision(P)), Pairs),
    all_hold(Pairs, one_registration_pair).
test('every fixture has exactly one answer for each naturalisation provision') :-
    findall(S - P, (british_nationality_subject(S), naturalisation_provision(P)), Pairs),
    all_hold(Pairs, one_naturalisation_pair).
test('every citation the rules use is registered') :-
    implements(british_nationality_act_1981_section_1_1),
    citation(british_nationality_act_1981_section_1_1, Record),
    member(units - Units, Record),
    Units = [_|_].
test('the registration provisions') :-
    findall(P, registration_provision(P), Ps),
    Ps == [section_1_3, section_1_4, section_3_1, section_3_2, section_3_5, section_4_2, section_4_5].

one_registration_pair(S - P) :-
    one_registration(S, P).

one_naturalisation_pair(S - P) :-
    one_naturalisation(S, P).

cp_test_names(['there are 52 fixtures', 'every fixture has exactly one citizenship status', 'every fixture has exactly one answer for each registration provision', 'every fixture has exactly one answer for each naturalisation provision', 'every citation the rules use is registered', 'the registration provisions']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
