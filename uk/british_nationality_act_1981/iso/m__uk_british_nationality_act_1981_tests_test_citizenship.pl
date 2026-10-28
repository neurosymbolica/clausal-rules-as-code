:- module(m__uk_british_nationality_act_1981_tests_test_citizenship, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__uk_british_nationality_act_1981_citizenship, [british_citizenship_status/3]).
:- use_module(m__uk_british_nationality_act_1981_fixtures, [british_nationality_profile_for/2]).

status(Subject, Date, Status) :-
    british_nationality_profile_for(Subject, Profile),
    findall(Answer, british_citizenship_status(Profile, Date, Answer), Answers),
    Answers == [Status].

test('s 1(1): born in the UK in 1990 to a mother who became a citizen at commencement') :-
    status(born_in_united_kingdom_to_citizen_mother, date(2020, 1, 1), british_citizen(otherwise_than_by_descent, [ground(section_1_1, through(mother), date(1990, 5, 5))])).
test('s 1(1) is not retroactive: the same person on the day before birth is not a citizen') :-
    status(born_in_united_kingdom_to_citizen_mother, date(1990, 5, 4), not_british_citizen).
test('commencement boundary: born on 1 January 1983 is born after commencement') :-
    status(born_on_commencement_day, date(2020, 1, 1), british_citizen(otherwise_than_by_descent, [ground(section_1_1, through(mother), date(1983, 1, 1))])).
test('commencement boundary: born on 31 December 1982, no s 11 status stated: not a citizen') :-
    status(born_day_before_commencement, date(2020, 1, 1), not_british_citizen).
test('born before commencement, citizen at commencement under s 11(1)') :-
    status(born_day_before_commencement_citizen_at_commencement, date(2020, 1, 1), british_citizen(otherwise_than_by_descent, [ground(section_11_1, none, date(1983, 1, 1))])).
test('s 11(1) status runs from commencement, not from birth') :-
    status(born_day_before_commencement_citizen_at_commencement, date(1982, 12, 31), not_british_citizen).
test('s 1(1)(b): a settled father is enough') :-
    status(born_in_united_kingdom_to_settled_father, date(2020, 1, 1), british_citizen(otherwise_than_by_descent, [ground(section_1_1, through(father), date(1995, 7, 7))])).
test('s 50(9)(b): a citizen father of an illegitimate child does not count') :-
    status(born_illegitimate_to_citizen_father, date(2020, 1, 1), not_british_citizen).
test('s 47(1): legitimated by marriage on 1 June 2000, a citizen from that date') :-
    status(legitimated_by_marriage_in_2000, date(2020, 1, 1), british_citizen(otherwise_than_by_descent, [ground(section_1_1, through(father), date(2000, 6, 1))])).
test('s 47(1): not a citizen before the marriage') :-
    status(legitimated_by_marriage_in_2000, date(2000, 5, 31), not_british_citizen).
test('s 50(2): a mother with limited leave is not settled') :-
    status(born_to_mother_with_limited_leave, date(2020, 1, 1), not_british_citizen).
test('s 50(2): the same mother once her restriction has ended is settled') :-
    status(born_after_mother_restriction_ended, date(2020, 1, 1), british_citizen(otherwise_than_by_descent, [ground(section_1_1, through(mother), date(2017, 4, 4))])).
test('s 50(5): in breach of the immigration laws is not ordinarily resident, so not settled') :-
    status(born_to_mother_in_breach_of_immigration_laws, date(2020, 1, 1), not_british_citizen).
test('s 50(3)(a): an exemption under s 8(3) Immigration Act 1971 prevents settlement') :-
    status(born_to_exempt_diplomat, date(2020, 1, 1), not_british_citizen).
test('s 50(4): formerly settled parent exempt under s 8(3), resident throughout, is regarded as settled') :-
    status(born_to_formerly_settled_exempt_mother, date(2020, 1, 1), british_citizen(otherwise_than_by_descent, [ground(section_1_1, through(mother), date(2002, 2, 2))])).
test('s 50(4) does not apply when the other parent has diplomatic immunity') :-
    status(born_to_formerly_settled_exempt_mother_father_immune, date(2020, 1, 1), not_british_citizen).
test('recursion: the mother is a citizen under s 1(1) through the grandmother') :-
    status(born_in_united_kingdom_third_generation, date(2020, 1, 1), british_citizen(otherwise_than_by_descent, [ground(section_1_1, through(mother), date(2010, 11, 11))])).
test('s 1(2): a new-born found abandoned in the UK after commencement') :-
    status(found_abandoned_new_born, date(2020, 1, 1), british_citizen(otherwise_than_by_descent, [ground(section_1_2, none, date(1991, 1, 20))])).
test('s 1(2): unless the contrary is shown') :-
    status(found_abandoned_contrary_shown, date(2020, 1, 1), not_british_citizen).
test('s 2(1)(a): born abroad to a citizen otherwise than by descent: a citizen by descent') :-
    status(born_abroad_to_citizen_mother, date(2020, 1, 1), british_citizen(by_descent, [ground(section_2_1_a, through(mother), date(1992, 2, 2))])).
test('s 2(1)(a): a parent who is a citizen by descent does not pass it on') :-
    status(born_abroad_to_father_citizen_by_descent, date(2020, 1, 1), not_british_citizen).
test('s 2(1)(b): a parent by descent in Crown service, recruited in the UK: otherwise than by descent') :-
    status(born_abroad_to_crown_servant_father, date(2020, 1, 1), british_citizen(otherwise_than_by_descent, [ground(section_2_1_b, through(father), date(1998, 8, 1))])).
test('s 2(1)(b): recruited abroad, the paragraph does not apply') :-
    status(born_abroad_to_crown_servant_recruited_abroad, date(2020, 1, 1), not_british_citizen).
test('s 2(1)(c): Community institution, recruited in a member state') :-
    status(born_abroad_to_community_servant_mother, date(2020, 1, 1), british_citizen(otherwise_than_by_descent, [ground(section_2_1_c, through(mother), date(1999, 9, 9))])).
test('s 1(5): adopted by a citizen under an order of a UK court, a citizen from the order') :-
    status(adopted_by_citizen_in_united_kingdom_court, date(2020, 1, 1), british_citizen(otherwise_than_by_descent, [ground(section_1_5, none, date(2008, 3, 3))])).
test('s 1(5): not before the order') :-
    status(adopted_by_citizen_in_united_kingdom_court, date(2008, 3, 2), not_british_citizen).
test('s 1(5): an order of a court outside the UK does not confer citizenship') :-
    status(adopted_by_citizen_in_foreign_court, date(2020, 1, 1), not_british_citizen).
test('s 1(5): joint adoption, one adopter a citizen') :-
    status(adopted_jointly_one_adopter_citizen, date(2020, 1, 1), british_citizen(otherwise_than_by_descent, [ground(section_1_5, none, date(2008, 3, 3))])).
test('s 1(5): the adoption of an adult does not confer citizenship') :-
    status(adopted_as_adult, date(2020, 1, 1), not_british_citizen).
test('s 14(1)(a): registered under s 3(2), a citizen by descent from the registration') :-
    status(registered_under_section_3_2, date(2020, 1, 1), british_citizen(by_descent, [ground(section_3_2, none, date(1999, 2, 1))])).
test('naturalised: a citizen otherwise than by descent from the certificate') :-
    status(naturalised_in_2010, date(2020, 1, 1), british_citizen(otherwise_than_by_descent, [ground(section_6_1, none, date(2010, 6, 30))])).
test('naturalised: not the day before') :-
    status(naturalised_in_2010, date(2010, 6, 29), not_british_citizen).
test('s 1(2): found after commencement, deemed born after it: a citizen') :-
    status(found_abandoned_just_after_commencement, date(2020, 1, 1), british_citizen(otherwise_than_by_descent, [ground(section_1_2, none, date(1983, 1, 1))])).
test('s 1(2): no citizenship under the Act before the Act is in force') :-
    status(found_abandoned_just_after_commencement, date(1982, 12, 31), not_british_citizen).
test('s 1(2): found abandoned before commencement: the subsection does not apply') :-
    status(found_abandoned_before_commencement, date(2020, 1, 1), not_british_citizen).
test('s 1(5): an adoption order made before commencement confers nothing under the Act') :-
    status(adopted_before_commencement, date(2020, 1, 1), not_british_citizen).
test('s 2(1)(a) with s 47(1): legitimated in 1995, a citizen by descent from the marriage') :-
    status(born_abroad_legitimated_in_1995, date(2020, 1, 1), british_citizen(by_descent, [ground(section_2_1_a, through(father), date(1995, 3, 1))])).
test('s 2(1)(a) with s 47(1): not before the marriage') :-
    status(born_abroad_legitimated_in_1995, date(1995, 2, 28), not_british_citizen).

cp_test_names(['s 1(1): born in the UK in 1990 to a mother who became a citizen at commencement', 's 1(1) is not retroactive: the same person on the day before birth is not a citizen', 'commencement boundary: born on 1 January 1983 is born after commencement', 'commencement boundary: born on 31 December 1982, no s 11 status stated: not a citizen', 'born before commencement, citizen at commencement under s 11(1)', 's 11(1) status runs from commencement, not from birth', 's 1(1)(b): a settled father is enough', 's 50(9)(b): a citizen father of an illegitimate child does not count', 's 47(1): legitimated by marriage on 1 June 2000, a citizen from that date', 's 47(1): not a citizen before the marriage', 's 50(2): a mother with limited leave is not settled', 's 50(2): the same mother once her restriction has ended is settled', 's 50(5): in breach of the immigration laws is not ordinarily resident, so not settled', 's 50(3)(a): an exemption under s 8(3) Immigration Act 1971 prevents settlement', 's 50(4): formerly settled parent exempt under s 8(3), resident throughout, is regarded as settled', 's 50(4) does not apply when the other parent has diplomatic immunity', 'recursion: the mother is a citizen under s 1(1) through the grandmother', 's 1(2): a new-born found abandoned in the UK after commencement', 's 1(2): unless the contrary is shown', 's 2(1)(a): born abroad to a citizen otherwise than by descent: a citizen by descent', 's 2(1)(a): a parent who is a citizen by descent does not pass it on', 's 2(1)(b): a parent by descent in Crown service, recruited in the UK: otherwise than by descent', 's 2(1)(b): recruited abroad, the paragraph does not apply', 's 2(1)(c): Community institution, recruited in a member state', 's 1(5): adopted by a citizen under an order of a UK court, a citizen from the order', 's 1(5): not before the order', 's 1(5): an order of a court outside the UK does not confer citizenship', 's 1(5): joint adoption, one adopter a citizen', 's 1(5): the adoption of an adult does not confer citizenship', 's 14(1)(a): registered under s 3(2), a citizen by descent from the registration', 'naturalised: a citizen otherwise than by descent from the certificate', 'naturalised: not the day before', 's 1(2): found after commencement, deemed born after it: a citizen', 's 1(2): no citizenship under the Act before the Act is in force', 's 1(2): found abandoned before commencement: the subsection does not apply', 's 1(5): an adoption order made before commencement confers nothing under the Act', 's 2(1)(a) with s 47(1): legitimated in 1995, a citizen by descent from the marriage', 's 2(1)(a) with s 47(1): not before the marriage']).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
