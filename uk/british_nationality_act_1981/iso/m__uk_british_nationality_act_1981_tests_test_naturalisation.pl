:- module(m__uk_british_nationality_act_1981_tests_test_naturalisation, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(m__uk_british_nationality_act_1981_naturalisation, [british_citizenship_naturalisation/4]).
:- use_module(m__uk_british_nationality_act_1981_fixtures, [british_nationality_profile_for/2]).

outcome(Subject, Provision, Date, Outcome) :-
    british_nationality_profile_for(Subject, Profile),
    findall(Answer, british_citizenship_naturalisation(Profile, Provision, Date, assessment(Answer, _)), Answers),
    Answers == [Outcome].

condition_status(Subject, Provision, Date, Name, Status) :-
    british_nationality_profile_for(Subject, Profile),
    findall(Conditions, british_citizenship_naturalisation(Profile, Provision, Date, assessment(_, Conditions)), Answers),
    Answers = [Conditions],
    member(condition(Name, Status, _), Conditions).

test('s 6(1): five years in the UK, no restriction in the last twelve months: requirements fulfilled') :-
    outcome(naturalisation_resident_five_years, section_6_1, date(2015, 1, 1), requirements_fulfilled).
test('Sch 1 para 1(2)(c), 2(c): restricted earlier in the twelve months, not on the date: waivable') :-
    outcome(naturalisation_resident_five_years, section_6_1, date(2013, 6, 1), requirements_fulfilled_only_if_waived),
    condition_status(naturalisation_resident_five_years, section_6_1, date(2013, 6, 1), no_restriction_on_stay, waivable).
test('Sch 1 para 2(a): 500 days abroad in the five years: fulfilled only if waived') :-
    outcome(naturalisation_too_many_absences, section_6_1, date(2015, 1, 1), requirements_fulfilled_only_if_waived).
test('Sch 1 para 1(1)(b): not of good character: not fulfilled') :-
    outcome(naturalisation_not_of_good_character, section_6_1, date(2015, 1, 1), requirements_not_fulfilled).
test('s 6(2): married to a citizen, three years in the UK: fulfilled, with no language requirement') :-
    outcome(naturalisation_spouse_of_citizen, section_6_2, date(2015, 1, 1), requirements_fulfilled).
test('s 6(1) for the same person: not in the UK five years before') :-
    condition_status(naturalisation_spouse_of_citizen, section_6_1, date(2015, 1, 1), in_united_kingdom_at_beginning_of_period, unmet).
test('Sch 1 para 2(e): insufficient language is waivable') :-
    condition_status(naturalisation_spouse_of_citizen, section_6_1, date(2015, 1, 1), sufficient_knowledge_of_language, waivable).
test('s 6(2): not married to a citizen') :-
    condition_status(naturalisation_resident_five_years, section_6_2, date(2015, 1, 1), married_to_british_citizen_on_date_of_application, unmet).
test('Sch 1 para 4(d): spouse in Crown service abroad, residence waivable') :-
    outcome(naturalisation_spouse_of_crown_servant_abroad, section_6_2, date(2015, 1, 1), requirements_fulfilled_only_if_waived).
test('s 6, s 50(11): seventeen on the date of the application is not of full age') :-
    condition_status(naturalisation_resident_five_years, section_6_1, date(1997, 12, 31), full_age, unmet).
test('s 50(11)(b): eighteen on the anniversary itself is of full age') :-
    condition_status(naturalisation_resident_five_years, section_6_1, date(1998, 1, 1), full_age, met).
test('Home Office example: arrived on 2 September 2017, in the UK at the beginning') :-
    beginning_status(date(2017, 9, 2), met).
test('Home Office example: arrived on 3 September 2017, not in the UK at the beginning') :-
    beginning_status(date(2017, 9, 3), unmet).
test('every naturalisation condition status is decided when asked through findall') :-
    all_hold([naturalisation_resident_five_years - section_6_1, naturalisation_too_many_absences - section_6_1, naturalisation_not_of_good_character - section_6_1, naturalisation_spouse_of_citizen - section_6_1, naturalisation_spouse_of_citizen - section_6_2, naturalisation_spouse_of_crown_servant_abroad - section_6_2], decided_for).

arrived(Arrival, Profile) :-
    Arrival = date(Year, Month, Day),
    LastAbsent = date(Year, Month, PreviousDay),
    PreviousDay is Day - 1,
    dict_pairs(Profile, [date_of_birth - date(1980, 1, 1), place_of_birth - outside_united_kingdom, ordinarily_resident_in_united_kingdom - [period(Arrival, ongoing)], absences_from_united_kingdom - [period(date(1980, 1, 1), LastAbsent)], good_character - true, sufficient_knowledge_of_language - true, intention_after_naturalisation - principal_home_in_united_kingdom]).

beginning_status(Arrival, Status) :-
    arrived(Arrival, Profile),
    findall(C, british_citizenship_naturalisation(Profile, section_6_1, date(2022, 9, 1), assessment(_, C)), Answers),
    Answers = [Conditions],
    member(condition(in_united_kingdom_at_beginning_of_period, Status, _), Conditions).

decided_status(met).
decided_status(unmet).
decided_status(waivable).

all_decided([]).
all_decided([condition(_, Status, _)|Conditions]) :-
    nonvar(Status),
    decided_status(Status),
    all_decided(Conditions).

decided_for(Subject - Provision) :-
    british_nationality_profile_for(Subject, Profile),
    findall(Conditions, british_citizenship_naturalisation(Profile, Provision, date(2015, 1, 1), assessment(_, Conditions)), Answers),
    Answers = [Conditions],
    Conditions = [_|_],
    all_decided(Conditions).

all_hold([], _).
all_hold([Item|Items], Check) :-
    call(Check, Item),
    all_hold(Items, Check).

cp_test_names(['s 6(1): five years in the UK, no restriction in the last twelve months: requirements fulfilled', 'Sch 1 para 1(2)(c), 2(c): restricted earlier in the twelve months, not on the date: waivable', 'Sch 1 para 2(a): 500 days abroad in the five years: fulfilled only if waived', 'Sch 1 para 1(1)(b): not of good character: not fulfilled', 's 6(2): married to a citizen, three years in the UK: fulfilled, with no language requirement', 's 6(1) for the same person: not in the UK five years before', 'Sch 1 para 2(e): insufficient language is waivable', 's 6(2): not married to a citizen', 'Sch 1 para 4(d): spouse in Crown service abroad, residence waivable', 's 6, s 50(11): seventeen on the date of the application is not of full age', 's 50(11)(b): eighteen on the anniversary itself is of full age', 'Home Office example: arrived on 2 September 2017, in the UK at the beginning', 'Home Office example: arrived on 3 September 2017, not in the UK at the beginning', 'every naturalisation condition status is decided when asked through findall']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
