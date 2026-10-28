:- module(m__uk_british_nationality_act_1981_tests_test_registration, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(m__uk_british_nationality_act_1981_registration, [british_citizenship_registration/4]).
:- use_module(m__uk_british_nationality_act_1981_fixtures, [british_nationality_profile_for/2]).

outcome(Subject, Provision, Date, Outcome) :-
    british_nationality_profile_for(Subject, Profile),
    findall(Answer, british_citizenship_registration(Profile, Provision, Date, assessment(Answer, _)), Answers),
    Answers == [Outcome].

condition_status(Subject, Provision, Date, Name, Status) :-
    british_nationality_profile_for(Subject, Profile),
    findall(Conditions, british_citizenship_registration(Profile, Provision, Date, assessment(_, Conditions)), Answers),
    Answers = [Conditions],
    member(condition(Name, Status, _), Conditions).

test('s 1(3): mother settles while the child is a minor, application while a minor: entitled') :-
    outcome(section_1_3_mother_settles_later, section_1_3, date(2006, 1, 1), entitled).
test('s 1(3): application made at eighteen: not entitled') :-
    outcome(section_1_3_mother_settles_later, section_1_3, date(2019, 1, 1), not_entitled).
test('s 1(3): application before the mother settled: not entitled') :-
    outcome(section_1_3_mother_settles_later, section_1_3, date(2004, 1, 1), not_entitled).
test('s 1(3): a child already a citizen under s 1(1) is not within s 1(3)') :-
    condition_status(born_in_united_kingdom_to_citizen_mother, section_1_3, date(1995, 1, 1), not_british_citizen_under_section_1_1_or_1_2, unmet).
test('s 1(4): ten years in the UK, application at ten: entitled') :-
    outcome(section_1_4_ten_years_in_united_kingdom, section_1_4, date(2010, 7, 1), entitled).
test('s 1(4): application at nine: not entitled') :-
    outcome(section_1_4_ten_years_in_united_kingdom, section_1_4, date(2009, 7, 1), not_entitled).
test('s 1(4) and (7): 120 days abroad in the fifth year: at the Secretary of State\'s discretion') :-
    outcome(section_1_4_long_absence_in_year_five, section_1_4, date(2010, 7, 1), at_discretion).
test('s 1(4): born outside the UK is not within the subsection') :-
    outcome(born_abroad_to_father_citizen_by_descent, section_1_4, date(2010, 7, 1), not_entitled).
test('s 3(1): any minor: at discretion') :-
    outcome(section_1_4_ten_years_in_united_kingdom, section_3_1, date(2010, 7, 1), at_discretion).
test('s 3(1): an adult: not within the power') :-
    outcome(section_1_4_ten_years_in_united_kingdom, section_3_1, date(2018, 6, 15), not_entitled).
test('s 3(1): the last day of minority is still within the power') :-
    outcome(section_1_4_ten_years_in_united_kingdom, section_3_1, date(2018, 6, 14), at_discretion).
test('s 3(2): father by descent, grandfather otherwise, three years in the UK, applied within 12 months') :-
    outcome(section_3_2_born_abroad_to_father_by_descent, section_3_2, date(2000, 12, 1), entitled).
test('s 3(2): the last day of the twelve months') :-
    outcome(section_3_2_born_abroad_to_father_by_descent, section_3_2, date(2001, 3, 9), entitled).
test('s 3(4): from the first anniversary, up to six years: at discretion') :-
    outcome(section_3_2_born_abroad_to_father_by_descent, section_3_2, date(2001, 3, 10), at_discretion).
test('s 3(4): after six years: not entitled') :-
    outcome(section_3_2_born_abroad_to_father_by_descent, section_3_2, date(2007, 12, 1), not_entitled).
test('s 3(3)(c): a father who never lived in the UK: not entitled') :-
    outcome(section_3_2_father_never_resident, section_3_2, date(2000, 12, 1), not_entitled).
test('s 3(2): born stateless, (a) and (b) suffice') :-
    outcome(section_3_2_father_never_resident_child_stateless, section_3_2, date(2000, 12, 1), entitled).
test('s 3(5): mother by descent, family three years in the UK, both consent: entitled') :-
    outcome(section_3_5_family_resident, section_3_5, date(2014, 1, 1), entitled).
test('s 3(5)(b): the father was abroad at the beginning of the three years: not entitled') :-
    outcome(section_3_5_father_abroad, section_3_5, date(2014, 1, 1), not_entitled).
test('s 3(6)(a), (b): the father has died, the mother\'s residence and consent suffice') :-
    outcome(section_3_5_father_abroad_died, section_3_5, date(2014, 1, 1), entitled).
test('s 3(5)(c): without the father\'s consent, both parents living: not entitled') :-
    british_nationality_profile_for(section_3_5_family_resident, Profile0),
    dict_pairs(Profile0, Pairs0),
    select(consent_to_registration_signified_by - _, Pairs0, Pairs1),
    dict_pairs(Profile, [consent_to_registration_signified_by - [mother]|Pairs1]),
    findall(Outcome, british_citizenship_registration(Profile, section_3_5, date(2014, 1, 1), assessment(Outcome, _)), Outcomes),
    Outcomes == [not_entitled].
test('s 4(2): British Overseas citizen, five years in the UK: entitled') :-
    outcome(section_4_british_overseas_citizen_resident, section_4_2, date(2015, 1, 1), entitled).
test('s 4(4)(a): 100 days abroad in the last twelve months: at discretion') :-
    outcome(section_4_british_overseas_citizen_long_absence, section_4_2, date(2015, 1, 1), at_discretion).
test('s 4(4)(b): restricted on the date of the application: not entitled') :-
    outcome(section_4_british_overseas_citizen_restricted, section_4_2, date(2015, 1, 1), not_entitled).
test('s 4(4)(b): restricted earlier in the twelve months only: at discretion') :-
    outcome(section_4_british_overseas_citizen_restricted, section_4_2, date(2017, 6, 1), at_discretion).
test('s 4(1): a foreign national is not a person to whom s 4 applies') :-
    outcome(section_4_foreign_national_resident, section_4_2, date(2015, 1, 1), not_entitled).
test('s 4(2)(a): not in the UK at the beginning of the five years: not entitled, and not waivable') :-
    outcome(section_4_british_overseas_citizen_resident, section_4_2, date(2009, 6, 1), not_entitled).
test('s 3(3)(b)(ii): grandfather died before 1983 but would have become a citizen otherwise than by descent') :-
    outcome(section_3_2_grandfather_died_before_commencement, section_3_2, date(2000, 12, 1), entitled).
test('s 3(3)(b)(ii) near miss: he would only have been a citizen by descent') :-
    outcome(section_3_2_grandfather_died_would_have_been_by_descent, section_3_2, date(2000, 12, 1), not_entitled).
test('s 3(2): the requirements fulfilled in the case of the mother') :-
    outcome(section_3_2_through_mother, section_3_2, date(2001, 6, 1), entitled).

cp_test_names(['s 1(3): mother settles while the child is a minor, application while a minor: entitled', 's 1(3): application made at eighteen: not entitled', 's 1(3): application before the mother settled: not entitled', 's 1(3): a child already a citizen under s 1(1) is not within s 1(3)', 's 1(4): ten years in the UK, application at ten: entitled', 's 1(4): application at nine: not entitled', 's 1(4) and (7): 120 days abroad in the fifth year: at the Secretary of State\'s discretion', 's 1(4): born outside the UK is not within the subsection', 's 3(1): any minor: at discretion', 's 3(1): an adult: not within the power', 's 3(1): the last day of minority is still within the power', 's 3(2): father by descent, grandfather otherwise, three years in the UK, applied within 12 months', 's 3(2): the last day of the twelve months', 's 3(4): from the first anniversary, up to six years: at discretion', 's 3(4): after six years: not entitled', 's 3(3)(c): a father who never lived in the UK: not entitled', 's 3(2): born stateless, (a) and (b) suffice', 's 3(5): mother by descent, family three years in the UK, both consent: entitled', 's 3(5)(b): the father was abroad at the beginning of the three years: not entitled', 's 3(6)(a), (b): the father has died, the mother\'s residence and consent suffice', 's 3(5)(c): without the father\'s consent, both parents living: not entitled', 's 4(2): British Overseas citizen, five years in the UK: entitled', 's 4(4)(a): 100 days abroad in the last twelve months: at discretion', 's 4(4)(b): restricted on the date of the application: not entitled', 's 4(4)(b): restricted earlier in the twelve months only: at discretion', 's 4(1): a foreign national is not a person to whom s 4 applies', 's 4(2)(a): not in the UK at the beginning of the five years: not entitled, and not waivable', 's 3(3)(b)(ii): grandfather died before 1983 but would have become a citizen otherwise than by descent', 's 3(3)(b)(ii) near miss: he would only have been a citizen by descent', 's 3(2): the requirements fulfilled in the case of the mother']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
