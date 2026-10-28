:- module(m__uk_british_nationality_act_1981_registration, [british_citizenship_registration/4, registration_provision/1, section_4_2_absence_days/4, section_1_4_year_absence_days/4, three_year_absence_days/3]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [get/3]).
:- use_module(library(clpz)).
:- use_module(m__uk_british_nationality_act_1981_citations, [implements/1]).
:- use_module(m__uk_british_nationality_act_1981_kernel, [commencement_day_number/1, date_day_number/2, day_number_date/2, years_after/3, period_bounds/3, days_in_periods_within/4, present_on_day_t/3, period_of_years_ending_with/4, absence_days_in_years_ending_with/4, present_at_start_of_years_ending_with_t/4, day_in_any_period_t/3, any_period_overlaps_t/4, attained_age_t/4, minor_t/3, and_t/3, or_t/3, profile_value/4, condition_outcome/2]).
:- use_module(m__uk_british_nationality_act_1981_input_check, [british_nationality_input_problems/3, date_argument_problems/3]).
:- use_module(m__uk_british_nationality_act_1981_citizenship, [citizenship_on_day/3, citizen_on_day_t/3, settled_on_day_t/3, legal_parent_routes/2, ground_of_section_1_1_or_1_2_on_day_t/3]).

registration_provision(section_1_3).
registration_provision(section_1_4).
registration_provision(section_3_1).
registration_provision(section_3_2).
registration_provision(section_3_5).
registration_provision(section_4_2).
registration_provision(section_4_5).

british_citizenship_registration(Profile, Provision, ApplicationDate, Result) :-
    registration_provision(Provision),
    british_nationality_input_problems(registration, Profile, ProfileProblems),
    date_argument_problems(application_date, ApplicationDate, DateProblems),
    append(ProfileProblems, DateProblems, Problems),
    registration_given(Problems, Profile, Provision, ApplicationDate, Result).

registration_given([_|_], _, _, _, assessment(indeterminate, [])).
registration_given([], Profile, Provision, ApplicationDate, assessment(Outcome, Conditions)) :-
    date_day_number(ApplicationDate, ApplicationDay),
    conditions(Provision, Profile, ApplicationDate, ApplicationDay, Conditions),
    condition_outcome(Conditions, Fulfilment),
    power_or_entitlement(Provision, Kind),
    registration_outcome(Kind, Fulfilment, Outcome).

power_or_entitlement(section_1_3, entitlement).
power_or_entitlement(section_1_4, entitlement).
power_or_entitlement(section_3_1, power).
power_or_entitlement(section_3_2, entitlement).
power_or_entitlement(section_3_5, entitlement).
power_or_entitlement(section_4_2, entitlement).
power_or_entitlement(section_4_5, power).

registration_outcome(entitlement, fulfilled, entitled).
registration_outcome(entitlement, fulfilled_only_if_waived, at_discretion).
registration_outcome(entitlement, not_fulfilled, not_entitled).
registration_outcome(power, fulfilled, at_discretion).
registration_outcome(power, fulfilled_only_if_waived, at_discretion).
registration_outcome(power, not_fulfilled, not_entitled).

met_t(true, met).
met_t(false, unmet).

waivable_t(true, met).
waivable_t(false, waivable).

conditions(section_1_3, Profile, _, ApplicationDay, [condition(born_in_united_kingdom_after_commencement, BornHere, british_nationality_act_1981_section_1_3), condition(not_british_citizen_under_section_1_1_or_1_2, NotCitizen, british_nationality_act_1981_section_1_3), condition(parent_became_british_citizen_or_settled_while_minor, ParentBecame, british_nationality_act_1981_section_1_3), condition(application_made_while_minor, Minor, british_nationality_act_1981_section_1_3)]) :-
    implements(british_nationality_act_1981_section_1_3),
    born_in_united_kingdom_after_commencement_t(Profile, BornHereTruth),
    met_t(BornHereTruth, BornHere),
    ground_of_section_1_1_or_1_2_on_day_t(Profile, ApplicationDay, Already),
    not_t(Already, NotCitizenTruth),
    met_t(NotCitizenTruth, NotCitizen),
    get(Profile, date_of_birth, DateOfBirth),
    date_day_number(DateOfBirth, BirthDay),
    legal_parent_routes(Profile, Routes),
    parent_became_t(Routes, BirthDay, ApplicationDay, ParentTruth),
    met_t(ParentTruth, ParentBecame),
    minor_t(DateOfBirth, ApplicationDay, MinorTruth),
    met_t(MinorTruth, Minor).
conditions(section_1_4, Profile, _, ApplicationDay, [condition(born_in_united_kingdom_after_commencement, BornHere, british_nationality_act_1981_section_1_4), condition(not_british_citizen_under_section_1_1_or_1_2, NotCitizen, british_nationality_act_1981_section_1_4), condition(application_made_after_attaining_age_of_ten, Ten, british_nationality_act_1981_section_1_4), condition(absent_at_most_90_days_in_each_of_first_ten_years, Absence, british_nationality_act_1981_section_1_7)]) :-
    implements(british_nationality_act_1981_section_1_4),
    implements(british_nationality_act_1981_section_1_7),
    born_in_united_kingdom_after_commencement_t(Profile, BornHereTruth),
    met_t(BornHereTruth, BornHere),
    ground_of_section_1_1_or_1_2_on_day_t(Profile, ApplicationDay, Already),
    not_t(Already, NotCitizenTruth),
    met_t(NotCitizenTruth, NotCitizen),
    get(Profile, date_of_birth, DateOfBirth),
    attained_age_t(DateOfBirth, 10, ApplicationDay, TenTruth),
    met_t(TenTruth, Ten),
    profile_value(Profile, absences_from_united_kingdom, [], Absences),
    first_ten_years_t(Absences, DateOfBirth, 0, AbsenceTruth),
    waivable_t(AbsenceTruth, Absence).
conditions(section_3_1, Profile, _, ApplicationDay, [condition(application_made_while_minor, Minor, british_nationality_act_1981_section_3_1)]) :-
    implements(british_nationality_act_1981_section_3_1),
    get(Profile, date_of_birth, DateOfBirth),
    minor_t(DateOfBirth, ApplicationDay, MinorTruth),
    met_t(MinorTruth, Minor).
conditions(section_3_2, Profile, _, ApplicationDay, [condition(born_outside_united_kingdom, Outside, british_nationality_act_1981_section_3_2), condition(application_made_within_twelve_months_of_birth, InTime, british_nationality_act_1981_section_3_4), condition(requirements_of_section_3_3_fulfilled_by_father_or_mother, Parent, british_nationality_act_1981_section_3_3)]) :-
    implements(british_nationality_act_1981_section_3_2),
    get(Profile, place_of_birth, Place),
    outside_t(Place, OutsideTruth),
    met_t(OutsideTruth, Outside),
    get(Profile, date_of_birth, DateOfBirth),
    date_day_number(DateOfBirth, BirthDay),
    application_time(DateOfBirth, ApplicationDay, InTime),
    profile_value(Profile, born_stateless, false, Stateless),
    legal_parent_routes(Profile, Routes),
    routes_by_day(Routes, ApplicationDay, Parents),
    any_parent_section_3_3_t(Parents, BirthDay, Stateless, ParentTruth),
    met_t(ParentTruth, Parent).
conditions(section_3_5, Profile, ApplicationDate, ApplicationDay, [condition(born_outside_united_kingdom, Outside, british_nationality_act_1981_section_3_5), condition(father_or_mother_british_citizen_by_descent_at_birth, ByDescent, british_nationality_act_1981_section_3_5), condition(three_years_residence_of_person_and_parents, Residence, british_nationality_act_1981_section_3_6), condition(consent_of_parents_signified, Consent, british_nationality_act_1981_section_3_6), condition(application_made_while_minor, Minor, british_nationality_act_1981_section_3_5)]) :-
    implements(british_nationality_act_1981_section_3_5),
    implements(british_nationality_act_1981_section_3_6),
    get(Profile, place_of_birth, Place),
    outside_t(Place, OutsideTruth),
    met_t(OutsideTruth, Outside),
    get(Profile, date_of_birth, DateOfBirth),
    date_day_number(DateOfBirth, BirthDay),
    legal_parent_routes(Profile, Routes),
    routes_by_day(Routes, ApplicationDay, Parents),
    any_parent_by_descent_t(Parents, BirthDay, ByDescentTruth),
    met_t(ByDescentTruth, ByDescent),
    legitimate_on_t(Profile, ApplicationDay, Legitimate),
    any_parent_dead_t(Parents, ApplicationDay, ParentDead),
    marriage_ended_t(Profile, ApplicationDay, MarriageEnded),
    or_t(ParentDead, MarriageEnded, EitherForResidence),
    reading(Legitimate, EitherForResidence, ResidenceReading),
    profile_value(Profile, absences_from_united_kingdom, [], Absences),
    resident_three_years_t(Absences, ApplicationDate, PersonResident),
    parents_resident_t(ResidenceReading, Parents, ApplicationDate, ParentsResident),
    and_t(PersonResident, ParentsResident, ResidenceTruth),
    met_t(ResidenceTruth, Residence),
    reading(Legitimate, ParentDead, ConsentReading),
    profile_value(Profile, consent_to_registration_signified_by, [], Consents),
    consent_t(ConsentReading, Parents, Consents, ConsentTruth),
    met_t(ConsentTruth, Consent),
    minor_t(DateOfBirth, ApplicationDay, MinorTruth),
    met_t(MinorTruth, Minor).
conditions(section_4_2, Profile, ApplicationDate, ApplicationDay, [condition(person_to_whom_section_4_applies, Applies, british_nationality_act_1981_section_4_1), condition(in_united_kingdom_at_beginning_of_five_years, Beginning, british_nationality_act_1981_section_4_3), condition(absent_at_most_450_days_in_five_years, FiveYears, british_nationality_act_1981_section_4_4), condition(absent_at_most_90_days_in_twelve_months, TwelveMonths, british_nationality_act_1981_section_4_4), condition(no_restriction_on_stay_in_twelve_months, Restriction, british_nationality_act_1981_section_4_4), condition(not_in_breach_of_immigration_laws_in_five_years, Breach, british_nationality_act_1981_section_4_4)]) :-
    implements(british_nationality_act_1981_section_4_2),
    implements(british_nationality_act_1981_section_4_4),
    section_4_applies(Profile, Applies),
    profile_value(Profile, absences_from_united_kingdom, [], Absences),
    present_at_start_of_years_ending_with_t(Absences, ApplicationDate, 5, Present),
    settled_immediately_before_commencement_t(Profile, SettledBefore),
    or_t(Present, SettledBefore, BeginningTruth),
    met_t(BeginningTruth, Beginning),
    section_4_2_absence_days(Profile, ApplicationDate, FiveYearDays, YearDays),
    at_most_t(FiveYearDays, 450, FiveYearsTruth),
    waivable_t(FiveYearsTruth, FiveYears),
    at_most_t(YearDays, 90, TwelveMonthsTruth),
    waivable_t(TwelveMonthsTruth, TwelveMonths),
    profile_value(Profile, immigration_restrictions_on_stay, [], Restrictions),
    period_of_years_ending_with(ApplicationDate, 1, YearStart, _),
    any_period_overlaps_t(Restrictions, YearStart, ApplicationDay, RestrictedInYear),
    day_in_any_period_t(Restrictions, ApplicationDay, RestrictedOnDate),
    restriction_status(RestrictedInYear, RestrictedOnDate, Restriction),
    profile_value(Profile, in_united_kingdom_in_breach_of_immigration_laws, [], Breaches),
    period_of_years_ending_with(ApplicationDate, 5, FiveYearStart, _),
    any_period_overlaps_t(Breaches, FiveYearStart, ApplicationDay, InBreach),
    not_t(InBreach, LawfulTruth),
    waivable_t(LawfulTruth, Breach).
conditions(section_4_5, Profile, _, _, [condition(person_to_whom_section_4_applies, Applies, british_nationality_act_1981_section_4_1), condition(crown_service_in_dependent_territory, Service, british_nationality_act_1981_section_4_6)]) :-
    implements(british_nationality_act_1981_section_4_5),
    implements(british_nationality_act_1981_section_4_6),
    section_4_applies(Profile, Applies),
    profile_value(Profile, crown_service_in_dependent_territory, false, ServiceTruth),
    met_t(ServiceTruth, Service).

application_time(DateOfBirth, ApplicationDay, Status) :-
    implements(british_nationality_act_1981_section_3_4),
    years_after(DateOfBirth, 1, TwelveMonths),
    date_day_number(TwelveMonths, TwelveMonthsDay),
    years_after(DateOfBirth, 6, SixYears),
    date_day_number(SixYears, SixYearsDay),
    date_day_number(DateOfBirth, BirthDay),
    application_time_status(BirthDay, TwelveMonthsDay, SixYearsDay, ApplicationDay, Status).

application_time_status(BirthDay, _, _, ApplicationDay, unmet) :-
    ApplicationDay #< BirthDay.
application_time_status(BirthDay, TwelveMonthsDay, _, ApplicationDay, met) :-
    ApplicationDay #>= BirthDay,
    ApplicationDay #< TwelveMonthsDay.
application_time_status(_, TwelveMonthsDay, SixYearsDay, ApplicationDay, waivable) :-
    ApplicationDay #>= TwelveMonthsDay,
    ApplicationDay #< SixYearsDay.
application_time_status(_, _, SixYearsDay, ApplicationDay, unmet) :-
    ApplicationDay #>= SixYearsDay.

routes_by_day([], _, []).
routes_by_day([route(Role, Parent, FromDay)|Routes], Day, Parents) :-
    counts_t(FromDay, Day, Counts),
    keep_parent(Counts, Role, Parent, Rest, Parents),
    routes_by_day(Routes, Day, Rest).

counts_t(FromDay, Day, true) :-
    FromDay #=< Day.
counts_t(FromDay, Day, false) :-
    FromDay #> Day.

keep_parent(true, Role, Parent, Rest, [Role - Parent|Rest]).
keep_parent(false, _, _, Rest, Rest).

any_parent_section_3_3_t([], _, _, false).
any_parent_section_3_3_t([_ - Parent|Parents], BirthDay, Stateless, Truth) :-
    parent_section_3_3_t(Parent, BirthDay, Stateless, Here),
    or_t(Here, Rest, Truth),
    any_parent_section_3_3_t(Parents, BirthDay, Stateless, Rest).

parent_section_3_3_t(Parent, BirthDay, Stateless, Truth) :-
    implements(british_nationality_act_1981_section_3_3),
    citizenship_on_day(Parent, BirthDay, Status),
    by_descent_status_t(Status, ByDescent),
    get(Parent, date_of_birth, ParentDateOfBirth),
    date_day_number(ParentDateOfBirth, ParentBirthDay),
    legal_parent_routes(Parent, GrandparentRoutes),
    any_grandparent_t(GrandparentRoutes, ParentBirthDay, Grandparent),
    and_t(ByDescent, Grandparent, Both),
    residence_before_birth_t(Stateless, Parent, ParentBirthDay, BirthDay, Residence),
    and_t(Both, Residence, Truth).

by_descent_status_t(not_british_citizen, false).
by_descent_status_t(british_citizen(by_descent, _), true).
by_descent_status_t(british_citizen(otherwise_than_by_descent, _), false).

any_grandparent_t([], _, false).
any_grandparent_t([route(_, Grandparent, _)|Routes], ParentBirthDay, Truth) :-
    implements(british_nationality_act_1981_section_3_3),
    citizenship_on_day(Grandparent, ParentBirthDay, Status),
    otherwise_status_t(Status, LimbOne),
    profile_value(Grandparent, citizenship_at_commencement, none, AtCommencement),
    commencement_otherwise_t(AtCommencement, LimbTwo),
    or_t(LimbOne, LimbTwo, Here),
    or_t(Here, Rest, Truth),
    any_grandparent_t(Routes, ParentBirthDay, Rest).

otherwise_status_t(not_british_citizen, false).
otherwise_status_t(british_citizen(otherwise_than_by_descent, _), true).
otherwise_status_t(british_citizen(by_descent, _), false).

commencement_otherwise_t(none, false).
commencement_otherwise_t(by_descent, false).
commencement_otherwise_t(otherwise_than_by_descent, true).
commencement_otherwise_t(would_have_become_but_for_death(otherwise_than_by_descent), true).
commencement_otherwise_t(would_have_become_but_for_death(by_descent), false).

residence_before_birth_t(true, _, _, _, true).
residence_before_birth_t(false, Parent, ParentBirthDay, BirthDay, Truth) :-
    implements(british_nationality_act_1981_section_3_3),
    profile_value(Parent, absences_from_united_kingdom, [], Absences),
    some_three_year_period_t(Absences, ParentBirthDay, BirthDay, Truth).

some_three_year_period_t(Absences, ParentBirthDay, BirthDay, Truth) :-
    implements(british_nationality_act_1981_section_3_3),
    absence_starts(Absences, Starts),
    ends_before(Starts, EndsBefore),
    ends_of_periods_beginning_before(Starts, EndsAfter),
    period_end_from_start(ParentBirthDay, ParentEnd),
    append([[BirthDay], EndsBefore, EndsAfter, [ParentEnd]], Candidates),
    any_three_year_end_t(Candidates, Absences, ParentBirthDay, BirthDay, Truth).

absence_starts([], []).
absence_starts([Period|Periods], [Start|Starts]) :-
    period_bounds(Period, Start, _),
    absence_starts(Periods, Starts).

ends_before([], []).
ends_before([Start|Starts], [End|Ends]) :-
    End #= Start - 1,
    ends_before(Starts, Ends).

ends_of_periods_beginning_before([], []).
ends_of_periods_beginning_before([Start|Starts], [End|Ends]) :-
    Begin #= Start - 1,
    period_end_from_start(Begin, End),
    ends_of_periods_beginning_before(Starts, Ends).

period_end_from_start(StartDay, EndDay) :-
    day_number_date(StartDay, StartDate),
    years_after(StartDate, 3, Next),
    date_day_number(Next, NextDay),
    EndDay #= NextDay - 1.

any_three_year_end_t([], _, _, _, false).
any_three_year_end_t([EndDay|EndDays], Absences, ParentBirthDay, BirthDay, Truth) :-
    three_year_period_t(EndDay, Absences, ParentBirthDay, BirthDay, Here),
    or_t(Here, Rest, Truth),
    any_three_year_end_t(EndDays, Absences, ParentBirthDay, BirthDay, Rest).

three_year_period_t(EndDay, _, _, BirthDay, false) :-
    EndDay #> BirthDay.
three_year_period_t(EndDay, Absences, ParentBirthDay, BirthDay, Truth) :-
    EndDay #=< BirthDay,
    day_number_date(EndDay, EndDate),
    period_of_years_ending_with(EndDate, 3, StartDay, _),
    after_parent_birth_t(StartDay, ParentBirthDay, Born),
    present_on_day_t(Absences, StartDay, Present),
    days_in_periods_within(Absences, StartDay, EndDay, Days),
    at_most_t(Days, 270, Few),
    and_t(Born, Present, Both),
    and_t(Both, Few, Truth).

after_parent_birth_t(StartDay, ParentBirthDay, true) :-
    StartDay #>= ParentBirthDay.
after_parent_birth_t(StartDay, ParentBirthDay, false) :-
    StartDay #< ParentBirthDay.

at_most_t(Count, Limit, true) :-
    Count #=< Limit.
at_most_t(Count, Limit, false) :-
    Count #> Limit.

any_parent_by_descent_t([], _, false).
any_parent_by_descent_t([_ - Parent|Parents], BirthDay, Truth) :-
    citizenship_on_day(Parent, BirthDay, Status),
    by_descent_status_t(Status, Here),
    or_t(Here, Rest, Truth),
    any_parent_by_descent_t(Parents, BirthDay, Rest).

legitimate_on_t(Profile, Day, Truth) :-
    profile_value(Profile, born_legitimate, true, Born),
    profile_value(Profile, legitimated_on, none, Legitimated),
    legitimate_given_t(Born, Legitimated, Day, Truth).

legitimate_given_t(true, _, _, true).
legitimate_given_t(false, none, _, false).
legitimate_given_t(false, date(Year, Month, Day), OnDay, Truth) :-
    date_day_number(date(Year, Month, Day), MarriageDay),
    counts_t(MarriageDay, OnDay, Truth).

any_parent_dead_t([], _, false).
any_parent_dead_t([_ - Parent|Parents], Day, Truth) :-
    profile_value(Parent, date_of_death, none, Death),
    dead_by_t(Death, Day, Here),
    or_t(Here, Rest, Truth),
    any_parent_dead_t(Parents, Day, Rest).

dead_by_t(none, _, false).
dead_by_t(date(Year, Month, Day), OnDay, Truth) :-
    date_day_number(date(Year, Month, Day), DeathDay),
    counts_t(DeathDay, OnDay, Truth).

marriage_ended_t(Profile, Day, Truth) :-
    implements(british_nationality_act_1981_section_3_6),
    profile_value(Profile, parents_marriage_terminated_on, none, Terminated),
    dead_by_t(Terminated, Day, Ended),
    profile_value(Profile, parents_legally_separated_on, none, Separated),
    dead_by_t(Separated, Day, Apart),
    or_t(Ended, Apart, Truth).

reading(false, _, mother_only).
reading(true, true, either).
reading(true, false, both).

three_year_absence_days(Absences, ApplicationDate, Days) :-
    implements(british_nationality_act_1981_section_3_5),
    absence_days_in_years_ending_with(Absences, ApplicationDate, 3, Days).

section_4_2_absence_days(Profile, ApplicationDate, FiveYearDays, YearDays) :-
    implements(british_nationality_act_1981_section_4_2),
    profile_value(Profile, absences_from_united_kingdom, [], Absences),
    absence_days_in_years_ending_with(Absences, ApplicationDate, 5, FiveYearDays),
    absence_days_in_years_ending_with(Absences, ApplicationDate, 1, YearDays).

resident_three_years_t(Absences, ApplicationDate, Truth) :-
    present_at_start_of_years_ending_with_t(Absences, ApplicationDate, 3, Present),
    three_year_absence_days(Absences, ApplicationDate, Days),
    at_most_t(Days, 270, Few),
    and_t(Present, Few, Truth).

parent_resident_t(Parent, ApplicationDate, Truth) :-
    profile_value(Parent, absences_from_united_kingdom, [], Absences),
    resident_three_years_t(Absences, ApplicationDate, Truth).

parents_resident_t(mother_only, Parents, ApplicationDate, Truth) :-
    implements(british_nationality_act_1981_section_3_6),
    role_parent(mother, Parents, Found),
    resident_found_t(Found, ApplicationDate, Truth).
parents_resident_t(either, Parents, ApplicationDate, Truth) :-
    implements(british_nationality_act_1981_section_3_6),
    role_parent(mother, Parents, Mother),
    resident_found_t(Mother, ApplicationDate, MotherTruth),
    role_parent(father, Parents, Father),
    resident_found_t(Father, ApplicationDate, FatherTruth),
    or_t(MotherTruth, FatherTruth, Truth).
parents_resident_t(both, Parents, ApplicationDate, Truth) :-
    implements(british_nationality_act_1981_section_3_6),
    role_parent(mother, Parents, Mother),
    resident_found_t(Mother, ApplicationDate, MotherTruth),
    role_parent(father, Parents, Father),
    resident_found_t(Father, ApplicationDate, FatherTruth),
    and_t(MotherTruth, FatherTruth, Truth).

role_parent(_, [], not_given).
role_parent(Role, [Role - Parent|_], found(Parent)).
role_parent(Role, [Other - _|Parents], Found) :-
    dif(Role, Other),
    role_parent(Role, Parents, Found).

resident_found_t(not_given, _, false).
resident_found_t(found(Parent), ApplicationDate, Truth) :-
    parent_resident_t(Parent, ApplicationDate, Truth).

consent_t(mother_only, _, Consents, Truth) :-
    implements(british_nationality_act_1981_section_3_6),
    consented_t(mother, Consents, Truth).
consent_t(either, Parents, Consents, Truth) :-
    implements(british_nationality_act_1981_section_3_6),
    living_consent_t(mother, Parents, Consents, MotherTruth),
    living_consent_t(father, Parents, Consents, FatherTruth),
    or_t(MotherTruth, FatherTruth, Truth).
consent_t(both, _, Consents, Truth) :-
    implements(british_nationality_act_1981_section_3_6),
    consented_t(mother, Consents, MotherTruth),
    consented_t(father, Consents, FatherTruth),
    and_t(MotherTruth, FatherTruth, Truth).

living_consent_t(Role, _, Consents, Truth) :-
    consented_t(Role, Consents, Truth).

consented_t(_, [], false).
consented_t(Role, [Role|_], true).
consented_t(Role, [Other|Consents], Truth) :-
    dif(Role, Other),
    consented_t(Role, Consents, Truth).

section_4_applies(Profile, Status) :-
    implements(british_nationality_act_1981_section_4_1),
    profile_value(Profile, british_nationality_other_than_citizenship, none, Nationality),
    section_4_nationality_t(Nationality, Truth),
    met_t(Truth, Status).

section_4_nationality_t(none, false).
section_4_nationality_t(british_dependent_territories_citizen, true).
section_4_nationality_t(british_overseas_citizen, true).
section_4_nationality_t(british_subject_under_this_act, true).
section_4_nationality_t(british_protected_person, true).

restriction_status(false, _, met).
restriction_status(true, false, waivable).
restriction_status(true, true, unmet).

settled_immediately_before_commencement_t(Profile, Truth) :-
    implements(british_nationality_act_1981_section_4_3),
    commencement_day_number(Commencement),
    DayBefore #= Commencement - 1,
    settled_on_day_t(Profile, DayBefore, Truth).

born_in_united_kingdom_after_commencement_t(Profile, Truth) :-
    get(Profile, place_of_birth, Place),
    inside_t(Place, Inside),
    get(Profile, date_of_birth, DateOfBirth),
    date_day_number(DateOfBirth, BirthDay),
    commencement_day_number(Commencement),
    counts_t(Commencement, BirthDay, After),
    and_t(Inside, After, Truth).

inside_t(united_kingdom, true).
inside_t(outside_united_kingdom, false).

outside_t(united_kingdom, false).
outside_t(outside_united_kingdom, true).

not_t(true, false).
not_t(false, true).

parent_became_t([], _, _, false).
parent_became_t([route(_, Parent, FromDay)|Routes], BirthDay, ApplicationDay, Truth) :-
    counts_t(FromDay, ApplicationDay, Counts),
    parent_became_given_t(Counts, Parent, FromDay, ApplicationDay, Here),
    or_t(Here, Rest, Truth),
    parent_became_t(Routes, BirthDay, ApplicationDay, Rest).

parent_became_given_t(false, _, _, _, false).
parent_became_given_t(true, Parent, FromDay, ApplicationDay, Truth) :-
    citizen_on_day_t(Parent, ApplicationDay, Citizen),
    settled_on_some_day_t(Parent, FromDay, ApplicationDay, Settled),
    or_t(Citizen, Settled, Truth).

settled_on_some_day_t(Profile, StartDay, EndDay, Truth) :-
    profile_value(Profile, ordinarily_resident_in_united_kingdom, [], Residence),
    profile_value(Profile, immigration_restrictions_on_stay, [], Restrictions),
    profile_value(Profile, immigration_exemptions, [], Exemptions),
    exemption_as_periods(Exemptions, ExemptionPeriods),
    profile_value(Profile, in_united_kingdom_in_breach_of_immigration_laws, [], Breaches),
    append([Residence, Restrictions, ExemptionPeriods, Breaches], Periods),
    change_days(Periods, Changes),
    window_days([StartDay|Changes], StartDay, EndDay, Days),
    settled_on_any_t(Days, Profile, Truth).

exemption_as_periods([], []).
exemption_as_periods([exemption(_, From, To)|Exemptions], [period(From, To)|Periods]) :-
    exemption_as_periods(Exemptions, Periods).

change_days([], []).
change_days([Period|Periods], [FromDay, AfterDay|Days]) :-
    period_bounds(Period, FromDay, ToDay),
    AfterDay #= ToDay + 1,
    change_days(Periods, Days).

window_days([], _, _, []).
window_days([Day|Days], StartDay, EndDay, Kept) :-
    within_t(Day, StartDay, EndDay, Within),
    keep_day(Within, Day, Rest, Kept),
    window_days(Days, StartDay, EndDay, Rest).

within_t(Day, StartDay, EndDay, true) :-
    Day #>= StartDay,
    Day #=< EndDay.
within_t(Day, StartDay, _, false) :-
    Day #< StartDay.
within_t(Day, _, EndDay, false) :-
    Day #> EndDay.

keep_day(true, Day, Rest, [Day|Rest]).
keep_day(false, _, Rest, Rest).

settled_on_any_t([], _, false).
settled_on_any_t([Day|Days], Profile, Truth) :-
    settled_on_day_t(Profile, Day, Here),
    or_t(Here, Rest, Truth),
    settled_on_any_t(Days, Profile, Rest).

first_ten_years_t(_, _, 10, true).
first_ten_years_t(Absences, DateOfBirth, Year, Truth) :-
    implements(british_nationality_act_1981_section_1_4),
    Year #< 10,
    section_1_4_year_absence_days(Absences, DateOfBirth, Year, Days),
    Next #= Year + 1,
    at_most_t(Days, 90, Here),
    and_t(Here, Rest, Truth),
    first_ten_years_t(Absences, DateOfBirth, Next, Rest).

section_1_4_year_absence_days(Absences, DateOfBirth, Year, Days) :-
    implements(british_nationality_act_1981_section_1_4),
    years_after(DateOfBirth, Year, Start),
    date_day_number(Start, StartDay),
    Next #= Year + 1,
    years_after(DateOfBirth, Next, End),
    date_day_number(End, EndExclusive),
    EndDay #= EndExclusive - 1,
    days_in_periods_within(Absences, StartDay, EndDay, Days).

no_statute("british_citizenship_registration", 4, "interface_shape").
no_statute("registration_given", 5, "computation_helper").
no_statute("application_time_status", 5, "computation_helper").
no_statute("routes_by_day", 3, "computation_helper").
no_statute("counts_t", 3, "computation_helper").
no_statute("any_parent_section_3_3_t", 4, "computation_helper").
no_statute("absence_starts", 2, "computation_helper").
no_statute("ends_before", 2, "computation_helper").
no_statute("ends_of_periods_beginning_before", 2, "computation_helper").
no_statute("period_end_from_start", 2, "computation_helper").
no_statute("any_three_year_end_t", 5, "computation_helper").
no_statute("three_year_period_t", 5, "computation_helper").
no_statute("after_parent_birth_t", 3, "computation_helper").
no_statute("at_most_t", 3, "computation_helper").
no_statute("any_parent_by_descent_t", 3, "computation_helper").
no_statute("legitimate_on_t", 3, "computation_helper").
no_statute("legitimate_given_t", 4, "computation_helper").
no_statute("any_parent_dead_t", 3, "computation_helper").
no_statute("dead_by_t", 3, "computation_helper").
no_statute("resident_three_years_t", 3, "computation_helper").
no_statute("parent_resident_t", 3, "computation_helper").
no_statute("role_parent", 3, "computation_helper").
no_statute("resident_found_t", 3, "computation_helper").
no_statute("living_consent_t", 4, "computation_helper").
no_statute("consented_t", 3, "computation_helper").
no_statute("born_in_united_kingdom_after_commencement_t", 2, "computation_helper").
no_statute("parent_became_t", 4, "computation_helper").
no_statute("parent_became_given_t", 5, "computation_helper").
no_statute("settled_on_some_day_t", 4, "computation_helper").
no_statute("exemption_as_periods", 2, "computation_helper").
no_statute("change_days", 2, "computation_helper").
no_statute("window_days", 4, "computation_helper").
no_statute("within_t", 4, "computation_helper").
no_statute("settled_on_any_t", 3, "computation_helper").
