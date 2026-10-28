:- module(m__uk_british_nationality_act_1981_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(m__uk_british_nationality_act_1981_queries, [british_nationality_answer/3, british_nationality_what_if/4, british_citizenship_status_history/2, british_citizenship_absence_figures/4, british_citizenship_routes/3, british_citizenship_earliest_application/4]).
:- use_module(m__uk_british_nationality_act_1981_fixtures, [british_nationality_profile_for/2]).

only(Template, Goal, Expected) :-
    findall(Template, Goal, Answers),
    Answers == [Expected].

one(Template, Goal, Answer) :-
    findall(Template, Goal, Answers),
    Answers = [Answer].

earliest(Subject, Provision, From, Expected) :-
    british_nationality_profile_for(Subject, Profile),
    only(R, british_citizenship_earliest_application(Profile, Provision, From, R), Expected).

test('earliest s 4(2): ten days too many abroad in the year, wait for them to fall out') :-
    earliest(section_4_british_overseas_citizen_long_absence, section_4_2, date(2015, 1, 1), earliest(date(2015, 9, 10))).
test('earliest s 4(2): a restriction must be out of the twelve months') :-
    earliest(section_4_british_overseas_citizen_restricted, section_4_2, date(2015, 1, 1), earliest(date(2017, 12, 31))).
test('earliest s 6(1): the five years must begin on a day in the UK') :-
    earliest(naturalisation_too_many_absences, section_6_1, date(2013, 1, 1), earliest(date(2017, 5, 14))).
test('earliest s 6(2): free of restriction on the date of application') :-
    earliest(naturalisation_spouse_of_citizen, section_6_2, date(2011, 6, 1), earliest(date(2014, 1, 1))).
test('earliest s 1(4): the tenth birthday') :-
    earliest(section_1_4_ten_years_in_united_kingdom, section_1_4, date(2001, 1, 1), earliest(date(2010, 6, 15))).
test('earliest: already fulfilled on the starting date') :-
    earliest(section_4_british_overseas_citizen_resident, section_4_2, date(2015, 1, 1), earliest(date(2015, 1, 1))).
test('earliest: never fulfilled within twenty years') :-
    earliest(section_4_foreign_national_resident, section_4_2, date(2015, 1, 1), none_within(date(2035, 1, 1))).
test('earliest: a provision with no residence period has no answer') :-
    british_nationality_profile_for(section_1_4_ten_years_in_united_kingdom, Profile),
    findall(R, british_citizenship_earliest_application(Profile, section_3_1, date(2001, 1, 1), R), []).
test('figures s 4(2): 100 days in the year, 10 over') :-
    british_nationality_profile_for(section_4_british_overseas_citizen_long_absence, Profile),
    only(F, british_citizenship_absence_figures(Profile, section_4_2, date(2015, 1, 1), F), [figure(absent_days_in_five_years, 100, 450, 0), figure(absent_days_in_twelve_months, 100, 90, 10)]).
test('figures s 6(1): 500 days in the five years, 50 over') :-
    british_nationality_profile_for(naturalisation_too_many_absences, Profile),
    only(F, british_citizenship_absence_figures(Profile, section_6_1, date(2015, 1, 1), F), [figure(absent_days_in_five_years, 500, 450, 50), figure(absent_days_in_twelve_months, 0, 90, 0)]).
test('figures s 1(4): 120 days in the fifth year of life') :-
    british_nationality_profile_for(section_1_4_long_absence_in_year_five, Profile),
    one(F, british_citizenship_absence_figures(Profile, section_1_4, date(2010, 7, 1), F), Figures),
    Figures = [_, _, _, _, Five|_],
    Five == figure(absent_days_in_year_of_life(5), 120, 90, 30),
    length(Figures, 10).
test('figures s 3(5): the person and each parent named') :-
    british_nationality_profile_for(section_3_5_father_abroad, Profile),
    only(F, british_citizenship_absence_figures(Profile, section_3_5, date(2014, 1, 1), F), [figure(absent_days_in_three_years(person), 0, 270, 0), figure(absent_days_in_three_years(mother), 0, 270, 0), figure(absent_days_in_three_years(father), 730, 270, 460)]).
test('history: not a citizen at birth, a citizen from the legitimation') :-
    british_nationality_profile_for(legitimated_by_marriage_in_2000, Profile),
    only(H, british_citizenship_status_history(Profile, H), [since(date(1990, 3, 3), not_british_citizen), since(date(2000, 6, 1), british_citizen(otherwise_than_by_descent, [ground(section_1_1, through(father), date(2000, 6, 1))]))]).
test('history: born before 1983, a citizen from commencement') :-
    british_nationality_profile_for(born_day_before_commencement_citizen_at_commencement, Profile),
    only(H, british_citizenship_status_history(Profile, H), [since(date(1982, 12, 31), not_british_citizen), since(date(1983, 1, 1), british_citizen(otherwise_than_by_descent, [ground(section_11_1, none, date(1983, 1, 1))]))]).
test('history: a citizen from birth has one entry') :-
    british_nationality_profile_for(born_in_united_kingdom_to_citizen_mother, Profile),
    one(H, british_citizenship_status_history(Profile, H), [since(date(1990, 5, 5), _)]).
test('routes: best outcome first, in provision order within an outcome') :-
    british_nationality_profile_for(section_1_4_ten_years_in_united_kingdom, Profile),
    only(R, british_citizenship_routes(Profile, date(2010, 7, 1), R), [route(section_1_4, entitled), route(section_3_1, at_discretion), route(section_1_3, not_entitled), route(section_3_2, not_entitled), route(section_3_5, not_entitled), route(section_4_2, not_entitled), route(section_4_5, not_entitled), route(section_6_1, indeterminate), route(section_6_2, indeterminate)]).
test('answer: the same as the determination it names') :-
    british_nationality_profile_for(born_abroad_to_citizen_mother, Profile),
    only(A, british_nationality_answer(Profile, citizenship(date(2020, 1, 1)), A), british_citizen(by_descent, [ground(section_2_1_a, through(mother), date(1992, 2, 2))])).
test('what-if: legitimation in 2005 makes the child a citizen from then') :-
    british_nationality_profile_for(born_illegitimate_to_citizen_father, Profile),
    only(C, british_nationality_what_if(Profile, [legitimated_on - date(2005, 1, 1)], citizenship(date(2010, 1, 1)), C), compared(not_british_citizen, british_citizen(otherwise_than_by_descent, [ground(section_1_1, through(father), date(2005, 1, 1))]))).
test('what-if: removing the citizen mother removes the ground') :-
    british_nationality_profile_for(born_in_united_kingdom_to_citizen_mother, Profile),
    one(C, british_nationality_what_if(Profile, [remove(mother)], citizenship(date(2020, 1, 1)), C), Compared),
    Compared = compared(british_citizen(_, _), not_british_citizen).
test('what-if: a change list that is not Key-Value / remove(Key) gives indeterminate after') :-
    british_nationality_profile_for(born_in_united_kingdom_to_citizen_mother, Profile),
    only(After, british_nationality_what_if(Profile, [oops], citizenship(date(2020, 1, 1)), compared(_, After)), indeterminate).
test('what-if: a change that breaks the input gives indeterminate after') :-
    british_nationality_profile_for(born_in_united_kingdom_to_citizen_mother, Profile),
    only(After, british_nationality_what_if(Profile, [date_of_birth - tomorrow], citizenship(date(2020, 1, 1)), compared(_, After)), indeterminate).
test('what-if on registration: the Overseas citizen without the long absence is entitled') :-
    british_nationality_profile_for(section_4_british_overseas_citizen_long_absence, Profile),
    findall(Before - After, british_nationality_what_if(Profile, [absences_from_united_kingdom - [period(date(1970, 7, 7), date(2004, 12, 31))]], registration(section_4_2, date(2015, 1, 1)), compared(assessment(Before, _), assessment(After, _))), Pairs),
    Pairs == [at_discretion - entitled].
test('queries refuse bad input with indeterminate') :-
    dict_pairs(Bad, [place_of_birth - united_kingdom]),
    only(H, british_citizenship_status_history(Bad, H), indeterminate),
    only(F, british_citizenship_absence_figures(Bad, section_4_2, date(2015, 1, 1), F), indeterminate),
    only(E, british_citizenship_earliest_application(Bad, section_4_2, date(2015, 1, 1), E), indeterminate).
test('earliest refuses an unbound starting date') :-
    british_nationality_profile_for(section_4_british_overseas_citizen_resident, Profile),
    only(E, british_citizenship_earliest_application(Profile, section_4_2, _, E), indeterminate).

cp_test_names(['earliest s 4(2): ten days too many abroad in the year, wait for them to fall out', 'earliest s 4(2): a restriction must be out of the twelve months', 'earliest s 6(1): the five years must begin on a day in the UK', 'earliest s 6(2): free of restriction on the date of application', 'earliest s 1(4): the tenth birthday', 'earliest: already fulfilled on the starting date', 'earliest: never fulfilled within twenty years', 'earliest: a provision with no residence period has no answer', 'figures s 4(2): 100 days in the year, 10 over', 'figures s 6(1): 500 days in the five years, 50 over', 'figures s 1(4): 120 days in the fifth year of life', 'figures s 3(5): the person and each parent named', 'history: not a citizen at birth, a citizen from the legitimation', 'history: born before 1983, a citizen from commencement', 'history: a citizen from birth has one entry', 'routes: best outcome first, in provision order within an outcome', 'answer: the same as the determination it names', 'what-if: legitimation in 2005 makes the child a citizen from then', 'what-if: removing the citizen mother removes the ground', 'what-if: a change list that is not Key-Value / remove(Key) gives indeterminate after', 'what-if: a change that breaks the input gives indeterminate after', 'what-if on registration: the Overseas citizen without the long absence is entitled', 'queries refuse bad input with indeterminate', 'earliest refuses an unbound starting date']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
