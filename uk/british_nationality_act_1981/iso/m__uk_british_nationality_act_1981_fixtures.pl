:- module(m__uk_british_nationality_act_1981_fixtures, [british_nationality_subject/1, british_nationality_profile_for/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).

british_nationality_subject(Subject) :-
    subject_profile(Subject, _).

british_nationality_profile_for(Subject, Profile) :-
    subject_profile(Subject, Profile).

citizen_from_commencement(Profile) :-
    dict_pairs(Profile, [date_of_birth - date(1955, 3, 1), place_of_birth - united_kingdom, citizenship_at_commencement - otherwise_than_by_descent]).

foreign_national(Profile) :-
    dict_pairs(Profile, [date_of_birth - date(1955, 6, 1), place_of_birth - outside_united_kingdom]).

settled_foreign_national(Profile) :-
    dict_pairs(Profile, [date_of_birth - date(1956, 6, 1), place_of_birth - outside_united_kingdom, ordinarily_resident_in_united_kingdom - [period(date(1980, 1, 1), ongoing)]]).

citizen_by_descent_father(Profile) :-
    citizen_from_commencement(Grandfather),
    dict_pairs(Profile, [date_of_birth - date(1960, 2, 1), place_of_birth - outside_united_kingdom, father - Grandfather, citizenship_at_commencement - by_descent, absences_from_united_kingdom - [period(date(1960, 2, 1), date(1977, 12, 31)), period(date(1985, 6, 1), date(2030, 12, 31))]]).

subject_profile(born_in_united_kingdom_to_citizen_mother, Profile) :-
    citizen_from_commencement(Mother),
    foreign_national(Father),
    dict_pairs(Profile, [date_of_birth - date(1990, 5, 5), place_of_birth - united_kingdom, mother - Mother, father - Father]).
subject_profile(born_on_commencement_day, Profile) :-
    citizen_from_commencement(Mother),
    dict_pairs(Profile, [date_of_birth - date(1983, 1, 1), place_of_birth - united_kingdom, mother - Mother]).
subject_profile(born_day_before_commencement, Profile) :-
    citizen_from_commencement(Mother),
    dict_pairs(Profile, [date_of_birth - date(1982, 12, 31), place_of_birth - united_kingdom, mother - Mother]).
subject_profile(born_day_before_commencement_citizen_at_commencement, Profile) :-
    citizen_from_commencement(Mother),
    dict_pairs(Profile, [date_of_birth - date(1982, 12, 31), place_of_birth - united_kingdom, mother - Mother, citizenship_at_commencement - otherwise_than_by_descent]).
subject_profile(born_in_united_kingdom_to_settled_father, Profile) :-
    settled_foreign_national(Father),
    foreign_national(Mother),
    dict_pairs(Profile, [date_of_birth - date(1995, 7, 7), place_of_birth - united_kingdom, mother - Mother, father - Father]).
subject_profile(born_illegitimate_to_citizen_father, Profile) :-
    citizen_from_commencement(Father),
    foreign_national(Mother),
    dict_pairs(Profile, [date_of_birth - date(1990, 3, 3), place_of_birth - united_kingdom, mother - Mother, father - Father, born_legitimate - false]).
subject_profile(legitimated_by_marriage_in_2000, Profile) :-
    citizen_from_commencement(Father),
    foreign_national(Mother),
    dict_pairs(Profile, [date_of_birth - date(1990, 3, 3), place_of_birth - united_kingdom, mother - Mother, father - Father, born_legitimate - false, legitimated_on - date(2000, 6, 1)]).
subject_profile(born_to_mother_with_limited_leave, Profile) :-
    dict_pairs(Mother, [date_of_birth - date(1985, 1, 1), place_of_birth - outside_united_kingdom, ordinarily_resident_in_united_kingdom - [period(date(2010, 1, 1), ongoing)], immigration_restrictions_on_stay - [period(date(2010, 1, 1), date(2016, 12, 31))]]),
    dict_pairs(Profile, [date_of_birth - date(2015, 4, 4), place_of_birth - united_kingdom, mother - Mother]).
subject_profile(born_after_mother_restriction_ended, Profile) :-
    dict_pairs(Mother, [date_of_birth - date(1985, 1, 1), place_of_birth - outside_united_kingdom, ordinarily_resident_in_united_kingdom - [period(date(2010, 1, 1), ongoing)], immigration_restrictions_on_stay - [period(date(2010, 1, 1), date(2016, 12, 31))]]),
    dict_pairs(Profile, [date_of_birth - date(2017, 4, 4), place_of_birth - united_kingdom, mother - Mother]).
subject_profile(born_to_mother_in_breach_of_immigration_laws, Profile) :-
    dict_pairs(Mother, [date_of_birth - date(1980, 1, 1), place_of_birth - outside_united_kingdom, ordinarily_resident_in_united_kingdom - [period(date(2000, 1, 1), ongoing)], in_united_kingdom_in_breach_of_immigration_laws - [period(date(2003, 1, 1), date(2006, 1, 1))]]),
    dict_pairs(Profile, [date_of_birth - date(2004, 8, 8), place_of_birth - united_kingdom, mother - Mother]).
subject_profile(born_to_exempt_diplomat, Profile) :-
    dict_pairs(Father, [date_of_birth - date(1970, 1, 1), place_of_birth - outside_united_kingdom, ordinarily_resident_in_united_kingdom - [period(date(1998, 1, 1), ongoing)], immigration_exemptions - [exemption(section_8_3, date(1998, 1, 1), ongoing)], diplomatic_immunity - [period(date(1998, 1, 1), ongoing)]]),
    foreign_national(Mother),
    dict_pairs(Profile, [date_of_birth - date(2001, 9, 9), place_of_birth - united_kingdom, mother - Mother, father - Father]).
subject_profile(born_to_formerly_settled_exempt_mother, Profile) :-
    dict_pairs(Mother, [date_of_birth - date(1965, 1, 1), place_of_birth - outside_united_kingdom, ordinarily_resident_in_united_kingdom - [period(date(1990, 1, 1), ongoing)], immigration_exemptions - [exemption(section_8_3, date(1999, 1, 1), ongoing)]]),
    dict_pairs(Profile, [date_of_birth - date(2002, 2, 2), place_of_birth - united_kingdom, mother - Mother]).
subject_profile(born_to_formerly_settled_exempt_mother_father_immune, Profile) :-
    dict_pairs(Mother, [date_of_birth - date(1965, 1, 1), place_of_birth - outside_united_kingdom, ordinarily_resident_in_united_kingdom - [period(date(1990, 1, 1), ongoing)], immigration_exemptions - [exemption(section_8_3, date(1999, 1, 1), ongoing)]]),
    dict_pairs(Father, [date_of_birth - date(1963, 1, 1), place_of_birth - outside_united_kingdom, diplomatic_immunity - [period(date(1999, 1, 1), ongoing)]]),
    dict_pairs(Profile, [date_of_birth - date(2002, 2, 2), place_of_birth - united_kingdom, mother - Mother, father - Father]).
subject_profile(born_in_united_kingdom_third_generation, Profile) :-
    citizen_from_commencement(Grandmother),
    dict_pairs(Mother, [date_of_birth - date(1985, 10, 10), place_of_birth - united_kingdom, mother - Grandmother]),
    dict_pairs(Profile, [date_of_birth - date(2010, 11, 11), place_of_birth - united_kingdom, mother - Mother]).
subject_profile(found_abandoned_new_born, Profile) :-
    dict_pairs(Profile, [date_of_birth - date(1991, 1, 20), place_of_birth - united_kingdom, found_abandoned_in_united_kingdom_on - date(1991, 1, 21)]).
subject_profile(found_abandoned_contrary_shown, Profile) :-
    foreign_national(Mother),
    dict_pairs(Profile, [date_of_birth - date(1991, 1, 20), place_of_birth - united_kingdom, mother - Mother, found_abandoned_in_united_kingdom_on - date(1991, 1, 21), contrary_shown_for_abandoned_infant - true]).
subject_profile(born_abroad_to_citizen_mother, Profile) :-
    citizen_from_commencement(Mother),
    dict_pairs(Profile, [date_of_birth - date(1992, 2, 2), place_of_birth - outside_united_kingdom, mother - Mother]).
subject_profile(born_abroad_to_father_citizen_by_descent, Profile) :-
    citizen_by_descent_father(Father),
    foreign_national(Mother),
    dict_pairs(Profile, [date_of_birth - date(1998, 8, 1), place_of_birth - outside_united_kingdom, mother - Mother, father - Father]).
subject_profile(born_abroad_to_crown_servant_father, Profile) :-
    citizen_from_commencement(Grandfather),
    dict_pairs(Father, [date_of_birth - date(1960, 2, 1), place_of_birth - outside_united_kingdom, father - Grandfather, citizenship_at_commencement - by_descent, service_outside_united_kingdom - [service(crown_service_under_the_government_of_the_united_kingdom, date(1995, 1, 1), date(2002, 1, 1), united_kingdom)]]),
    dict_pairs(Profile, [date_of_birth - date(1998, 8, 1), place_of_birth - outside_united_kingdom, father - Father]).
subject_profile(born_abroad_to_crown_servant_recruited_abroad, Profile) :-
    citizen_from_commencement(Grandfather),
    dict_pairs(Father, [date_of_birth - date(1960, 2, 1), place_of_birth - outside_united_kingdom, father - Grandfather, citizenship_at_commencement - by_descent, service_outside_united_kingdom - [service(crown_service_under_the_government_of_the_united_kingdom, date(1995, 1, 1), date(2002, 1, 1), other_country)]]),
    dict_pairs(Profile, [date_of_birth - date(1998, 8, 1), place_of_birth - outside_united_kingdom, father - Father]).
subject_profile(born_abroad_to_community_servant_mother, Profile) :-
    citizen_from_commencement(Grandmother),
    dict_pairs(Mother, [date_of_birth - date(1962, 4, 4), place_of_birth - outside_united_kingdom, mother - Grandmother, citizenship_at_commencement - by_descent, service_outside_united_kingdom - [service(community_institution, date(1990, 1, 1), ongoing, member_state_of_the_communities)]]),
    dict_pairs(Profile, [date_of_birth - date(1999, 9, 9), place_of_birth - outside_united_kingdom, mother - Mother]).
subject_profile(adopted_by_citizen_in_united_kingdom_court, Profile) :-
    citizen_from_commencement(Adopter),
    dict_pairs(Profile, [date_of_birth - date(2005, 5, 5), place_of_birth - outside_united_kingdom, adoption_orders - [adoption_order(date(2008, 3, 3), court_in_united_kingdom, [Adopter])]]).
subject_profile(adopted_by_citizen_in_foreign_court, Profile) :-
    citizen_from_commencement(Adopter),
    dict_pairs(Profile, [date_of_birth - date(2005, 5, 5), place_of_birth - outside_united_kingdom, adoption_orders - [adoption_order(date(2008, 3, 3), court_outside_united_kingdom, [Adopter])]]).
subject_profile(adopted_jointly_one_adopter_citizen, Profile) :-
    citizen_from_commencement(Adopter),
    foreign_national(OtherAdopter),
    dict_pairs(Profile, [date_of_birth - date(2005, 5, 5), place_of_birth - outside_united_kingdom, adoption_orders - [adoption_order(date(2008, 3, 3), court_in_united_kingdom, [OtherAdopter, Adopter])]]).
subject_profile(adopted_as_adult, Profile) :-
    citizen_from_commencement(Adopter),
    dict_pairs(Profile, [date_of_birth - date(1985, 5, 5), place_of_birth - outside_united_kingdom, adoption_orders - [adoption_order(date(2004, 3, 3), court_in_united_kingdom, [Adopter])]]).
subject_profile(registered_under_section_3_2, Profile) :-
    citizen_by_descent_father(Father),
    dict_pairs(Profile, [date_of_birth - date(1998, 8, 1), place_of_birth - outside_united_kingdom, father - Father, registrations - [registration(section_3_2, date(1999, 2, 1))]]).
subject_profile(naturalised_in_2010, Profile) :-
    dict_pairs(Profile, [date_of_birth - date(1975, 1, 1), place_of_birth - outside_united_kingdom, naturalisations - [naturalisation(section_6_1, date(2010, 6, 30))]]).
subject_profile(section_1_3_mother_settles_later, Profile) :-
    dict_pairs(Mother, [date_of_birth - date(1975, 1, 1), place_of_birth - outside_united_kingdom, ordinarily_resident_in_united_kingdom - [period(date(1998, 1, 1), ongoing)], immigration_restrictions_on_stay - [period(date(1998, 1, 1), date(2005, 3, 31))]]),
    dict_pairs(Profile, [date_of_birth - date(2000, 6, 15), place_of_birth - united_kingdom, mother - Mother]).
subject_profile(section_1_4_ten_years_in_united_kingdom, Profile) :-
    foreign_national(Mother),
    dict_pairs(Profile, [date_of_birth - date(2000, 6, 15), place_of_birth - united_kingdom, mother - Mother, absences_from_united_kingdom - [period(date(2003, 7, 1), date(2003, 7, 30))]]).
subject_profile(section_1_4_long_absence_in_year_five, Profile) :-
    foreign_national(Mother),
    dict_pairs(Profile, [date_of_birth - date(2000, 6, 15), place_of_birth - united_kingdom, mother - Mother, absences_from_united_kingdom - [period(date(2004, 7, 1), date(2004, 10, 28))]]).
subject_profile(section_3_2_born_abroad_to_father_by_descent, Profile) :-
    citizen_by_descent_father(Father),
    foreign_national(Mother),
    dict_pairs(Profile, [date_of_birth - date(2000, 3, 10), place_of_birth - outside_united_kingdom, mother - Mother, father - Father]).
subject_profile(section_3_2_father_never_resident, Profile) :-
    citizen_from_commencement(Grandfather),
    dict_pairs(Father, [date_of_birth - date(1960, 2, 1), place_of_birth - outside_united_kingdom, father - Grandfather, citizenship_at_commencement - by_descent, absences_from_united_kingdom - [period(date(1960, 2, 1), date(2040, 1, 1))]]),
    dict_pairs(Profile, [date_of_birth - date(2000, 3, 10), place_of_birth - outside_united_kingdom, father - Father]).
subject_profile(section_3_2_father_never_resident_child_stateless, Profile) :-
    citizen_from_commencement(Grandfather),
    dict_pairs(Father, [date_of_birth - date(1960, 2, 1), place_of_birth - outside_united_kingdom, father - Grandfather, citizenship_at_commencement - by_descent, absences_from_united_kingdom - [period(date(1960, 2, 1), date(2040, 1, 1))]]),
    dict_pairs(Profile, [date_of_birth - date(2000, 3, 10), place_of_birth - outside_united_kingdom, father - Father, born_stateless - true]).
subject_profile(section_3_5_family_resident, Profile) :-
    citizen_from_commencement(Grandmother),
    dict_pairs(Mother, [date_of_birth - date(1975, 4, 4), place_of_birth - outside_united_kingdom, mother - Grandmother, citizenship_at_commencement - by_descent, absences_from_united_kingdom - [period(date(1975, 4, 4), date(2009, 12, 31))]]),
    dict_pairs(Father, [date_of_birth - date(1973, 3, 3), place_of_birth - outside_united_kingdom, absences_from_united_kingdom - [period(date(1973, 3, 3), date(2009, 12, 31))]]),
    dict_pairs(Profile, [date_of_birth - date(2005, 1, 1), place_of_birth - outside_united_kingdom, mother - Mother, father - Father, absences_from_united_kingdom - [period(date(2005, 1, 1), date(2009, 12, 31))], consent_to_registration_signified_by - [mother, father]]).
subject_profile(section_3_5_father_abroad, Profile) :-
    citizen_from_commencement(Grandmother),
    dict_pairs(Mother, [date_of_birth - date(1975, 4, 4), place_of_birth - outside_united_kingdom, mother - Grandmother, citizenship_at_commencement - by_descent, absences_from_united_kingdom - [period(date(1975, 4, 4), date(2009, 12, 31))]]),
    dict_pairs(Father, [date_of_birth - date(1973, 3, 3), place_of_birth - outside_united_kingdom, absences_from_united_kingdom - [period(date(1973, 3, 3), date(2012, 12, 31))]]),
    dict_pairs(Profile, [date_of_birth - date(2005, 1, 1), place_of_birth - outside_united_kingdom, mother - Mother, father - Father, absences_from_united_kingdom - [period(date(2005, 1, 1), date(2009, 12, 31))], consent_to_registration_signified_by - [mother, father]]).
subject_profile(section_3_5_father_abroad_died, Profile) :-
    citizen_from_commencement(Grandmother),
    dict_pairs(Mother, [date_of_birth - date(1975, 4, 4), place_of_birth - outside_united_kingdom, mother - Grandmother, citizenship_at_commencement - by_descent, absences_from_united_kingdom - [period(date(1975, 4, 4), date(2009, 12, 31))]]),
    dict_pairs(Father, [date_of_birth - date(1973, 3, 3), place_of_birth - outside_united_kingdom, absences_from_united_kingdom - [period(date(1973, 3, 3), date(2012, 12, 31))], date_of_death - date(2011, 5, 5)]),
    dict_pairs(Profile, [date_of_birth - date(2005, 1, 1), place_of_birth - outside_united_kingdom, mother - Mother, father - Father, absences_from_united_kingdom - [period(date(2005, 1, 1), date(2009, 12, 31))], consent_to_registration_signified_by - [mother]]).
subject_profile(section_4_british_overseas_citizen_resident, Profile) :-
    dict_pairs(Profile, [date_of_birth - date(1970, 7, 7), place_of_birth - outside_united_kingdom, british_nationality_other_than_citizenship - british_overseas_citizen, ordinarily_resident_in_united_kingdom - [period(date(2005, 1, 1), ongoing)], absences_from_united_kingdom - [period(date(1970, 7, 7), date(2004, 12, 31)), period(date(2012, 8, 1), date(2012, 8, 21))]]).
subject_profile(section_4_british_overseas_citizen_long_absence, Profile) :-
    dict_pairs(Profile, [date_of_birth - date(1970, 7, 7), place_of_birth - outside_united_kingdom, british_nationality_other_than_citizenship - british_overseas_citizen, ordinarily_resident_in_united_kingdom - [period(date(2005, 1, 1), ongoing)], absences_from_united_kingdom - [period(date(1970, 7, 7), date(2004, 12, 31)), period(date(2014, 9, 1), date(2014, 12, 9))]]).
subject_profile(section_4_british_overseas_citizen_restricted, Profile) :-
    dict_pairs(Profile, [date_of_birth - date(1970, 7, 7), place_of_birth - outside_united_kingdom, british_nationality_other_than_citizenship - british_overseas_citizen, ordinarily_resident_in_united_kingdom - [period(date(2005, 1, 1), ongoing)], immigration_restrictions_on_stay - [period(date(2005, 1, 1), date(2016, 12, 31))], absences_from_united_kingdom - [period(date(1970, 7, 7), date(2004, 12, 31))]]).
subject_profile(section_4_foreign_national_resident, Profile) :-
    dict_pairs(Profile, [date_of_birth - date(1970, 7, 7), place_of_birth - outside_united_kingdom, ordinarily_resident_in_united_kingdom - [period(date(2005, 1, 1), ongoing)], absences_from_united_kingdom - [period(date(1970, 7, 7), date(2004, 12, 31))]]).
subject_profile(naturalisation_resident_five_years, Profile) :-
    dict_pairs(Profile, [date_of_birth - date(1980, 1, 1), place_of_birth - outside_united_kingdom, ordinarily_resident_in_united_kingdom - [period(date(2008, 1, 1), ongoing)], immigration_restrictions_on_stay - [period(date(2008, 1, 1), date(2012, 12, 31))], absences_from_united_kingdom - [period(date(1980, 1, 1), date(2007, 12, 31)), period(date(2014, 8, 1), date(2014, 8, 31))], good_character - true, sufficient_knowledge_of_language - true, intention_after_naturalisation - principal_home_in_united_kingdom]).
subject_profile(naturalisation_too_many_absences, Profile) :-
    dict_pairs(Profile, [date_of_birth - date(1980, 1, 1), place_of_birth - outside_united_kingdom, ordinarily_resident_in_united_kingdom - [period(date(2008, 1, 1), ongoing)], immigration_restrictions_on_stay - [period(date(2008, 1, 1), date(2012, 12, 31))], absences_from_united_kingdom - [period(date(1980, 1, 1), date(2007, 12, 31)), period(date(2011, 1, 1), date(2012, 5, 14))], good_character - true, sufficient_knowledge_of_language - true, intention_after_naturalisation - principal_home_in_united_kingdom]).
subject_profile(naturalisation_not_of_good_character, Profile) :-
    dict_pairs(Profile, [date_of_birth - date(1980, 1, 1), place_of_birth - outside_united_kingdom, ordinarily_resident_in_united_kingdom - [period(date(2008, 1, 1), ongoing)], immigration_restrictions_on_stay - [period(date(2008, 1, 1), date(2012, 12, 31))], absences_from_united_kingdom - [period(date(1980, 1, 1), date(2007, 12, 31))], good_character - false, sufficient_knowledge_of_language - true, intention_after_naturalisation - principal_home_in_united_kingdom]).
subject_profile(naturalisation_spouse_of_citizen, Profile) :-
    citizen_from_commencement(Spouse),
    dict_pairs(Profile, [date_of_birth - date(1982, 1, 1), place_of_birth - outside_united_kingdom, spouse - Spouse, ordinarily_resident_in_united_kingdom - [period(date(2011, 1, 1), ongoing)], immigration_restrictions_on_stay - [period(date(2011, 1, 1), date(2013, 12, 31))], absences_from_united_kingdom - [period(date(1982, 1, 1), date(2010, 12, 31))], good_character - true, sufficient_knowledge_of_language - false, intention_after_naturalisation - other]).
subject_profile(naturalisation_spouse_of_crown_servant_abroad, Profile) :-
    dict_pairs(Spouse, [date_of_birth - date(1975, 1, 1), place_of_birth - united_kingdom, citizenship_at_commencement - otherwise_than_by_descent, service_outside_united_kingdom - [service(crown_service_under_the_government_of_the_united_kingdom, date(2010, 1, 1), ongoing, united_kingdom)]]),
    dict_pairs(Profile, [date_of_birth - date(1982, 1, 1), place_of_birth - outside_united_kingdom, spouse - Spouse, absences_from_united_kingdom - [period(date(1982, 1, 1), date(2030, 12, 31))], good_character - true, sufficient_knowledge_of_language - true, intention_after_naturalisation - other]).
subject_profile(section_3_2_grandfather_died_before_commencement, Profile) :-
    dict_pairs(Grandfather, [date_of_birth - date(1930, 1, 1), place_of_birth - united_kingdom, date_of_death - date(1980, 1, 1), citizenship_at_commencement - would_have_become_but_for_death(otherwise_than_by_descent)]),
    dict_pairs(Father, [date_of_birth - date(1960, 2, 1), place_of_birth - outside_united_kingdom, father - Grandfather, citizenship_at_commencement - by_descent, absences_from_united_kingdom - [period(date(1960, 2, 1), date(1977, 12, 31)), period(date(1985, 6, 1), date(2030, 12, 31))]]),
    dict_pairs(Profile, [date_of_birth - date(2000, 3, 10), place_of_birth - outside_united_kingdom, father - Father]).
subject_profile(section_3_2_grandfather_died_would_have_been_by_descent, Profile) :-
    dict_pairs(Grandfather, [date_of_birth - date(1930, 1, 1), place_of_birth - outside_united_kingdom, date_of_death - date(1980, 1, 1), citizenship_at_commencement - would_have_become_but_for_death(by_descent)]),
    dict_pairs(Father, [date_of_birth - date(1960, 2, 1), place_of_birth - outside_united_kingdom, father - Grandfather, citizenship_at_commencement - by_descent, absences_from_united_kingdom - [period(date(1960, 2, 1), date(1977, 12, 31)), period(date(1985, 6, 1), date(2030, 12, 31))]]),
    dict_pairs(Profile, [date_of_birth - date(2000, 3, 10), place_of_birth - outside_united_kingdom, father - Father]).
subject_profile(section_3_2_through_mother, Profile) :-
    citizen_from_commencement(Grandmother),
    dict_pairs(Mother, [date_of_birth - date(1970, 5, 5), place_of_birth - outside_united_kingdom, mother - Grandmother, citizenship_at_commencement - by_descent, absences_from_united_kingdom - [period(date(1970, 5, 5), date(1989, 12, 31)), period(date(1996, 1, 1), date(2030, 12, 31))]]),
    foreign_national(Father),
    dict_pairs(Profile, [date_of_birth - date(2001, 1, 15), place_of_birth - outside_united_kingdom, mother - Mother, father - Father]).
subject_profile(found_abandoned_just_after_commencement, Profile) :-
    dict_pairs(Profile, [date_of_birth - date(1982, 12, 30), place_of_birth - united_kingdom, found_abandoned_in_united_kingdom_on - date(1983, 1, 2)]).
subject_profile(found_abandoned_before_commencement, Profile) :-
    dict_pairs(Profile, [date_of_birth - date(1982, 12, 20), place_of_birth - united_kingdom, found_abandoned_in_united_kingdom_on - date(1982, 12, 21)]).
subject_profile(adopted_before_commencement, Profile) :-
    citizen_from_commencement(Adopter),
    dict_pairs(Profile, [date_of_birth - date(1980, 5, 5), place_of_birth - outside_united_kingdom, adoption_orders - [adoption_order(date(1982, 6, 1), court_in_united_kingdom, [Adopter])]]).
subject_profile(born_abroad_legitimated_in_1995, Profile) :-
    citizen_from_commencement(Father),
    foreign_national(Mother),
    dict_pairs(Profile, [date_of_birth - date(1990, 3, 3), place_of_birth - outside_united_kingdom, mother - Mother, father - Father, born_legitimate - false, legitimated_on - date(1995, 3, 1)]).
