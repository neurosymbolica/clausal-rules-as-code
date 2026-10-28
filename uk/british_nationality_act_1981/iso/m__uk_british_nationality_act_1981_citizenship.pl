:- module(m__uk_british_nationality_act_1981_citizenship, [british_citizenship_status/3, citizenship_on_day/3, settled_on_day_t/3, legal_parent_routes/2, citizen_on_day_t/3, citizen_otherwise_than_by_descent_on_day_t/3, ground_of_section_1_1_or_1_2_on_day_t/3, ground_change_days/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [get/3]).
:- use_module(library(clpz)).
:- use_module(m__uk_british_nationality_act_1981_citations, [implements/1]).
:- use_module(m__uk_british_nationality_act_1981_kernel, [commencement_day_number/1, date_day_number/2, day_number_date/2, day_in_any_period_t/3, any_period_overlaps_t/4, interval_inside_one_period_t/4, minor_t/3, and_t/3, or_t/3, profile_value/4]).
:- use_module(m__uk_british_nationality_act_1981_input_check, [british_nationality_input_problems/3, date_argument_problems/3]).

british_citizenship_status(Profile, Date, Status) :-
    british_nationality_input_problems(citizenship, Profile, ProfileProblems),
    date_argument_problems(date, Date, DateProblems),
    append(ProfileProblems, DateProblems, Problems),
    status_given(Problems, Profile, Date, Status).

status_given([_|_], _, _, indeterminate).
status_given([], Profile, Date, Status) :-
    date_day_number(Date, Day),
    citizenship_on_day(Profile, Day, Status).

citizenship_on_day(Profile, Day, Status) :-
    candidate_grounds(Profile, Candidates),
    held_on(Candidates, Day, Held),
    status_from(Held, Status).

status_from([], not_british_citizen).
status_from([Candidate|Candidates], british_citizen(Mode, Grounds)) :-
    mode_of([Candidate|Candidates], Mode),
    public_grounds([Candidate|Candidates], Grounds).

mode_of([], by_descent).
mode_of([candidate(_, _, Mode, _)|Candidates], Combined) :-
    implements(british_nationality_act_1981_section_14_1_a),
    mode_of(Candidates, Rest),
    combine_mode(Mode, Rest, Combined).

combine_mode(otherwise_than_by_descent, _, otherwise_than_by_descent).
combine_mode(by_descent, Mode, Mode).

public_grounds([], []).
public_grounds([candidate(Provision, Route, _, Day)|Candidates], [ground(Provision, Route, Date)|Grounds]) :-
    day_number_date(Day, Date),
    public_grounds(Candidates, Grounds).

held_on([], _, []).
held_on([Candidate|Candidates], Day, Held) :-
    Candidate = candidate(_, _, _, Since),
    since_t(Since, Day, Holds),
    keep(Holds, Candidate, Rest, Held),
    held_on(Candidates, Day, Rest).

since_t(Since, Day, true) :-
    Since #=< Day.
since_t(Since, Day, false) :-
    Since #> Day.

keep(true, Item, Rest, [Item|Rest]).
keep(false, _, Rest, Rest).

citizen_on_day_t(Profile, Day, Truth) :-
    citizenship_on_day(Profile, Day, Status),
    citizen_status_t(Status, Truth).

citizen_status_t(not_british_citizen, false).
citizen_status_t(british_citizen(_, _), true).

citizen_otherwise_than_by_descent_on_day_t(Profile, Day, Truth) :-
    citizenship_on_day(Profile, Day, Status),
    otherwise_status_t(Status, Truth).

otherwise_status_t(not_british_citizen, false).
otherwise_status_t(british_citizen(otherwise_than_by_descent, _), true).
otherwise_status_t(british_citizen(by_descent, _), false).

ground_change_days(Profile, Days) :-
    candidate_grounds(Profile, Candidates),
    candidate_days(Candidates, Unsorted),
    sort(Unsorted, Days).

candidate_days([], []).
candidate_days([candidate(_, _, _, Day)|Candidates], [Day|Days]) :-
    candidate_days(Candidates, Days).

candidate_grounds(Profile, Candidates) :-
    candidates_without_adoption(Profile, Others),
    adoption_candidates(Profile, Adoptions),
    append(Others, Adoptions, Candidates).

candidates_without_adoption(Profile, Candidates) :-
    section_11_candidates(Profile, AtCommencement),
    section_1_1_candidates(Profile, BornInUnitedKingdom),
    section_1_2_candidates(Profile, FoundAbandoned),
    section_2_candidates(Profile, ByDescent),
    registration_candidates(Profile, Registered),
    naturalisation_candidates(Profile, Naturalised),
    append([AtCommencement, BornInUnitedKingdom, FoundAbandoned, ByDescent, Registered, Naturalised], Candidates).

born_after_commencement_t(Profile, Truth) :-
    get(Profile, date_of_birth, DateOfBirth),
    date_day_number(DateOfBirth, BirthDay),
    commencement_day_number(Commencement),
    after_commencement_t(BirthDay, Commencement, Truth).

after_commencement_t(Day, Commencement, true) :-
    Day #>= Commencement.
after_commencement_t(Day, Commencement, false) :-
    Day #< Commencement.

section_11_candidates(Profile, Candidates) :-
    implements(british_nationality_act_1981_section_11_1),
    born_after_commencement_t(Profile, After),
    profile_value(Profile, citizenship_at_commencement, none, Value),
    section_11_given(After, Value, Candidates).

section_11_given(true, _, []).
section_11_given(false, none, []).
section_11_given(false, would_have_become_but_for_death(_), []).
section_11_given(false, otherwise_than_by_descent, [candidate(section_11_1, none, otherwise_than_by_descent, Day)]) :-
    implements(british_nationality_act_1981_section_11_1),
    commencement_day_number(Day).
section_11_given(false, by_descent, [candidate(section_11_1, none, by_descent, Day)]) :-
    implements(british_nationality_act_1981_section_11_1),
    commencement_day_number(Day).

legal_parent_routes(Profile, Routes) :-
    implements(british_nationality_act_1981_section_50_9),
    get(Profile, date_of_birth, DateOfBirth),
    date_day_number(DateOfBirth, BirthDay),
    profile_value(Profile, mother, '$not_given', Mother),
    mother_route(Mother, BirthDay, MotherRoutes),
    profile_value(Profile, father, '$not_given', Father),
    profile_value(Profile, born_legitimate, true, Legitimate),
    profile_value(Profile, legitimated_on, none, Legitimated),
    father_route(Father, Legitimate, Legitimated, BirthDay, FatherRoutes),
    append(MotherRoutes, FatherRoutes, Routes).

mother_route('$not_given', _, []).
mother_route(Mother, BirthDay, [route(mother, Mother, BirthDay)]) :-
    implements(british_nationality_act_1981_section_50_9),
    dif(Mother, '$not_given').

father_route('$not_given', _, _, _, []).
father_route(Father, true, _, BirthDay, [route(father, Father, BirthDay)]) :-
    implements(british_nationality_act_1981_section_50_9),
    dif(Father, '$not_given').
father_route(Father, false, none, _, []) :-
    implements(british_nationality_act_1981_section_50_9),
    dif(Father, '$not_given').
father_route(Father, false, date(Year, Month, Day), BirthDay, [route(father, Father, FromDay)]) :-
    implements(british_nationality_act_1981_section_47_1),
    dif(Father, '$not_given'),
    date_day_number(date(Year, Month, Day), MarriageDay),
    FromDay #= max(BirthDay, MarriageDay).

section_1_1_candidates(Profile, Candidates) :-
    implements(british_nationality_act_1981_section_1_1),
    get(Profile, place_of_birth, Place),
    born_after_commencement_t(Profile, After),
    section_1_1_given(Place, After, Profile, Candidates).

section_1_1_given(outside_united_kingdom, _, _, []).
section_1_1_given(united_kingdom, false, _, []).
section_1_1_given(united_kingdom, true, Profile, Candidates) :-
    implements(british_nationality_act_1981_section_1_1),
    legal_parent_routes(Profile, Routes),
    get(Profile, date_of_birth, DateOfBirth),
    date_day_number(DateOfBirth, BirthDay),
    section_1_1_routes(Routes, Routes, BirthDay, Candidates).

section_1_1_routes([], _, _, []).
section_1_1_routes([route(Role, Parent, FromDay)|Routes], AllRoutes, BirthDay, Candidates) :-
    parent_qualifies_for_section_1_1_t(Parent, AllRoutes, BirthDay, Qualifies),
    section_1_1_candidate(Qualifies, Role, FromDay, Here),
    section_1_1_routes(Routes, AllRoutes, BirthDay, Rest),
    append(Here, Rest, Candidates).

section_1_1_candidate(false, _, _, []).
section_1_1_candidate(true, Role, FromDay, [candidate(section_1_1, through(Role), otherwise_than_by_descent, FromDay)]).

parent_qualifies_for_section_1_1_t(Parent, AllRoutes, BirthDay, Truth) :-
    implements(british_nationality_act_1981_section_1_1),
    citizen_on_day_t(Parent, BirthDay, Citizen),
    settled_on_day_t(Parent, BirthDay, Settled),
    settled_by_section_50_4_t(Parent, AllRoutes, BirthDay, Regarded),
    or_t(Citizen, Settled, Either),
    or_t(Either, Regarded, Truth).

section_1_2_candidates(Profile, Candidates) :-
    implements(british_nationality_act_1981_section_1_2),
    profile_value(Profile, found_abandoned_in_united_kingdom_on, none, Found),
    profile_value(Profile, contrary_shown_for_abandoned_infant, false, Contrary),
    section_1_2_given(Found, Contrary, Profile, Candidates).

section_1_2_given(none, _, _, []).
section_1_2_given(date(_, _, _), true, _, []).
section_1_2_given(date(Year, Month, Day), false, Profile, Candidates) :-
    implements(british_nationality_act_1981_section_1_2),
    date_day_number(date(Year, Month, Day), FoundDay),
    commencement_day_number(Commencement),
    after_commencement_t(FoundDay, Commencement, After),
    get(Profile, date_of_birth, DateOfBirth),
    date_day_number(DateOfBirth, BirthDay),
    section_1_2_after(After, BirthDay, Candidates).

section_1_2_after(false, _, []).
section_1_2_after(true, BirthDay, [candidate(section_1_2, none, otherwise_than_by_descent, SinceDay)]) :-
    implements(british_nationality_act_1981_section_1_2),
    commencement_day_number(Commencement),
    SinceDay #= max(BirthDay, Commencement).

ground_of_section_1_1_or_1_2_on_day_t(Profile, Day, Truth) :-
    implements(british_nationality_act_1981_section_1_3),
    section_1_1_candidates(Profile, BornInUnitedKingdom),
    section_1_2_candidates(Profile, FoundAbandoned),
    append(BornInUnitedKingdom, FoundAbandoned, Candidates),
    held_on(Candidates, Day, Held),
    non_empty_t(Held, Truth).

non_empty_t([], false).
non_empty_t([_|_], true).

section_2_candidates(Profile, Candidates) :-
    implements(british_nationality_act_1981_section_2_1_a),
    get(Profile, place_of_birth, Place),
    born_after_commencement_t(Profile, After),
    section_2_given(Place, After, Profile, Candidates).

section_2_given(united_kingdom, _, _, []).
section_2_given(outside_united_kingdom, false, _, []).
section_2_given(outside_united_kingdom, true, Profile, Candidates) :-
    implements(british_nationality_act_1981_section_2_1_a),
    legal_parent_routes(Profile, Routes),
    get(Profile, date_of_birth, DateOfBirth),
    date_day_number(DateOfBirth, BirthDay),
    section_2_routes(Routes, BirthDay, Candidates).

section_2_routes([], _, []).
section_2_routes([route(Role, Parent, FromDay)|Routes], BirthDay, Candidates) :-
    citizenship_on_day(Parent, BirthDay, Status),
    section_2_limbs(Status, Role, Parent, BirthDay, FromDay, Here),
    section_2_routes(Routes, BirthDay, Rest),
    append(Here, Rest, Candidates).

section_2_limbs(not_british_citizen, _, _, _, _, []).
section_2_limbs(british_citizen(Mode, _), Role, Parent, BirthDay, FromDay, Candidates) :-
    implements(british_nationality_act_1981_section_2_1_a),
    section_2_1_a(Mode, Role, FromDay, LimbA),
    profile_value(Parent, service_outside_united_kingdom, [], Services),
    section_2_1_b_t(Services, BirthDay, ServingB),
    section_2_1_b(ServingB, Role, FromDay, LimbB),
    section_2_1_c_t(Services, BirthDay, ServingC),
    section_2_1_c(ServingC, Role, FromDay, LimbC),
    append([LimbA, LimbB, LimbC], Candidates).

section_2_1_a(by_descent, _, _, []).
section_2_1_a(otherwise_than_by_descent, Role, FromDay, [candidate(section_2_1_a, through(Role), by_descent, FromDay)]) :-
    implements(british_nationality_act_1981_section_2_1_a),
    implements(british_nationality_act_1981_section_14_1_a).

section_2_1_b(false, _, _, []).
section_2_1_b(true, Role, FromDay, [candidate(section_2_1_b, through(Role), otherwise_than_by_descent, FromDay)]) :-
    implements(british_nationality_act_1981_section_2_1_b).

section_2_1_c(false, _, _, []).
section_2_1_c(true, Role, FromDay, [candidate(section_2_1_c, through(Role), otherwise_than_by_descent, FromDay)]) :-
    implements(british_nationality_act_1981_section_2_1_c).

section_2_1_b_t([], _, false).
section_2_1_b_t([service(Kind, From, To, RecruitedIn)|Services], BirthDay, Truth) :-
    implements(british_nationality_act_1981_section_2_2),
    paragraph_b_service_t(Kind, KindOk),
    recruited_in_united_kingdom_t(RecruitedIn, RecruitedOk),
    day_in_any_period_t([period(From, To)], BirthDay, Serving),
    and_t(KindOk, RecruitedOk, Both),
    and_t(Both, Serving, Here),
    or_t(Here, Rest, Truth),
    section_2_1_b_t(Services, BirthDay, Rest).

paragraph_b_service_t(crown_service_under_the_government_of_the_united_kingdom, true).
paragraph_b_service_t(designated_service, true).
paragraph_b_service_t(community_institution, false).
paragraph_b_service_t(other_service, false).

recruited_in_united_kingdom_t(united_kingdom, true).
recruited_in_united_kingdom_t(member_state_of_the_communities, false).
recruited_in_united_kingdom_t(other_country, false).

section_2_1_c_t([], _, false).
section_2_1_c_t([service(Kind, From, To, RecruitedIn)|Services], BirthDay, Truth) :-
    implements(british_nationality_act_1981_section_2_1_c),
    community_service_t(Kind, KindOk),
    recruited_in_member_state_t(RecruitedIn, RecruitedOk),
    day_in_any_period_t([period(From, To)], BirthDay, Serving),
    and_t(KindOk, RecruitedOk, Both),
    and_t(Both, Serving, Here),
    or_t(Here, Rest, Truth),
    section_2_1_c_t(Services, BirthDay, Rest).

community_service_t(community_institution, true).
community_service_t(crown_service_under_the_government_of_the_united_kingdom, false).
community_service_t(designated_service, false).
community_service_t(other_service, false).

recruited_in_member_state_t(united_kingdom, true).
recruited_in_member_state_t(member_state_of_the_communities, true).
recruited_in_member_state_t(other_country, false).

adoption_candidates(Profile, Candidates) :-
    implements(british_nationality_act_1981_section_1_5),
    profile_value(Profile, adoption_orders, [], Orders),
    adoption_order_candidates(Orders, Profile, Candidates).

adoption_order_candidates([], _, []).
adoption_order_candidates([Order|Orders], Profile, Candidates) :-
    adoption_order_t(Order, Profile, Qualifies),
    Order = adoption_order(Date, _, _),
    date_day_number(Date, OrderDay),
    adoption_candidate(Qualifies, OrderDay, Here),
    adoption_order_candidates(Orders, Profile, Rest),
    append(Here, Rest, Candidates).

adoption_candidate(false, _, []).
adoption_candidate(true, OrderDay, [candidate(section_1_5, none, otherwise_than_by_descent, OrderDay)]) :-
    implements(british_nationality_act_1981_section_1_5),
    implements(british_nationality_act_1981_section_1_6).

adoption_order_t(adoption_order(Date, Court, Adopters), Profile, Truth) :-
    implements(british_nationality_act_1981_section_1_5),
    date_day_number(Date, OrderDay),
    commencement_day_number(Commencement),
    after_commencement_t(OrderDay, Commencement, After),
    court_in_united_kingdom_t(Court, InUnitedKingdom),
    get(Profile, date_of_birth, DateOfBirth),
    minor_t(DateOfBirth, OrderDay, Minor),
    candidates_without_adoption(Profile, Others),
    held_on(Others, OrderDay, Held),
    non_empty_t(Held, AlreadyCitizen),
    not_t(AlreadyCitizen, NotCitizen),
    any_adopter_citizen_t(Adopters, OrderDay, AdopterCitizen),
    and_t(After, InUnitedKingdom, A),
    and_t(A, Minor, B),
    and_t(B, NotCitizen, C),
    and_t(C, AdopterCitizen, Truth).

court_in_united_kingdom_t(court_in_united_kingdom, true).
court_in_united_kingdom_t(court_outside_united_kingdom, false).

any_adopter_citizen_t([], _, false).
any_adopter_citizen_t([Adopter|Adopters], Day, Truth) :-
    citizen_on_day_t(Adopter, Day, Here),
    or_t(Here, Rest, Truth),
    any_adopter_citizen_t(Adopters, Day, Rest).

not_t(true, false).
not_t(false, true).

registration_candidates(Profile, Candidates) :-
    implements(british_nationality_act_1981_section_14_1_a),
    profile_value(Profile, registrations, [], Registrations),
    registration_list(Registrations, Profile, Candidates).

registration_list([], _, []).
registration_list([registration(Provision, Date)|Registrations], Profile, [candidate(Provision, none, Mode, Day)|Candidates]) :-
    date_day_number(Date, Day),
    registration_mode(Provision, Profile, Mode),
    registration_list(Registrations, Profile, Candidates).

registration_mode(section_3_2, _, by_descent) :-
    implements(british_nationality_act_1981_section_14_1_a).
registration_mode(section_3_1, Profile, Mode) :-
    implements(british_nationality_act_1981_section_14_1_c),
    legal_parent_routes(Profile, Routes),
    get(Profile, date_of_birth, DateOfBirth),
    date_day_number(DateOfBirth, BirthDay),
    section_14_1_c_t(Routes, BirthDay, ByDescent),
    by_descent_mode(ByDescent, Mode).
registration_mode(section_1_3, _, otherwise_than_by_descent).
registration_mode(section_1_4, _, otherwise_than_by_descent).
registration_mode(section_3_5, _, otherwise_than_by_descent).
registration_mode(section_4_2, _, otherwise_than_by_descent).
registration_mode(section_4_5, _, otherwise_than_by_descent).

by_descent_mode(true, by_descent).
by_descent_mode(false, otherwise_than_by_descent).

section_14_1_c_t([], _, false).
section_14_1_c_t([route(_, Parent, _)|Routes], BirthDay, Truth) :-
    implements(british_nationality_act_1981_section_14_1_c),
    citizen_on_day_t(Parent, BirthDay, Citizen),
    commencement_day_number(Commencement),
    after_commencement_t(BirthDay, Commencement, BornAfter),
    profile_value(Parent, citizenship_at_commencement, none, AtCommencement),
    limb_ii_t(BornAfter, AtCommencement, LimbTwo),
    or_t(Citizen, LimbTwo, Here),
    or_t(Here, Rest, Truth),
    section_14_1_c_t(Routes, BirthDay, Rest).

limb_ii_t(true, _, false).
limb_ii_t(false, none, false).
limb_ii_t(false, otherwise_than_by_descent, true).
limb_ii_t(false, by_descent, true).
limb_ii_t(false, would_have_become_but_for_death(_), true).

naturalisation_candidates(Profile, Candidates) :-
    implements(british_nationality_act_1981_section_6_1),
    profile_value(Profile, naturalisations, [], Naturalisations),
    naturalisation_list(Naturalisations, Candidates).

naturalisation_list([], []).
naturalisation_list([naturalisation(Provision, Date)|Naturalisations], [candidate(Provision, none, otherwise_than_by_descent, Day)|Candidates]) :-
    date_day_number(Date, Day),
    naturalisation_list(Naturalisations, Candidates).

settled_on_day_t(Profile, Day, Truth) :-
    implements(british_nationality_act_1981_section_50_2),
    implements(british_nationality_act_1981_section_50_3),
    implements(british_nationality_act_1981_section_50_5),
    ordinarily_resident_on_day_t(Profile, Day, Resident),
    profile_value(Profile, immigration_restrictions_on_stay, [], Restrictions),
    day_in_any_period_t(Restrictions, Day, Restricted),
    not_t(Restricted, Unrestricted),
    profile_value(Profile, immigration_exemptions, [], Exemptions),
    exemption_periods(Exemptions, [section_8_2, section_8_3, section_8_4_b, section_8_4_c], Excluding),
    day_in_any_period_t(Excluding, Day, Exempt),
    not_t(Exempt, NotExempt),
    and_t(Resident, Unrestricted, Both),
    and_t(Both, NotExempt, Truth).

ordinarily_resident_on_day_t(Profile, Day, Truth) :-
    implements(british_nationality_act_1981_section_50_5),
    profile_value(Profile, ordinarily_resident_in_united_kingdom, [], Residence),
    day_in_any_period_t(Residence, Day, Resident),
    profile_value(Profile, in_united_kingdom_in_breach_of_immigration_laws, [], Breaches),
    day_in_any_period_t(Breaches, Day, InBreach),
    not_t(InBreach, Lawful),
    and_t(Resident, Lawful, Truth).

exemption_periods([], _, []).
exemption_periods([exemption(Kind, From, To)|Exemptions], Kinds, Periods) :-
    kind_in_t(Kind, Kinds, In),
    exemption_period(In, From, To, Rest, Periods),
    exemption_periods(Exemptions, Kinds, Rest).

exemption_period(true, From, To, Rest, [period(From, To)|Rest]).
exemption_period(false, _, _, Rest, Rest).

kind_in_t(_, [], false).
kind_in_t(Kind, [Kind|_], true).
kind_in_t(Kind, [Other|Kinds], Truth) :-
    dif(Kind, Other),
    kind_in_t(Kind, Kinds, Truth).

settled_by_section_50_4_t(Parent, AllRoutes, BirthDay, Truth) :-
    implements(british_nationality_act_1981_section_50_4),
    profile_value(Parent, immigration_exemptions, [], Exemptions),
    exemption_periods(Exemptions, [section_8_3], SectionEightThree),
    first_period_containing(SectionEightThree, BirthDay, Found),
    section_50_4_given(Found, Parent, Exemptions, AllRoutes, BirthDay, Truth).

first_period_containing([], _, none).
first_period_containing([Period|Periods], Day, Found) :-
    day_in_any_period_t([Period], Day, Here),
    first_found(Here, Period, Periods, Day, Found).

first_found(true, Period, _, _, Period).
first_found(false, _, Periods, Day, Found) :-
    first_period_containing(Periods, Day, Found).

section_50_4_given(none, _, _, _, _, false).
section_50_4_given(period(From, _), Parent, Exemptions, AllRoutes, BirthDay, Truth) :-
    implements(british_nationality_act_1981_section_50_4),
    ordinarily_resident_on_day_t(Parent, BirthDay, Resident),
    profile_value(Parent, immigration_restrictions_on_stay, [], Restrictions),
    day_in_any_period_t(Restrictions, BirthDay, Restricted),
    not_t(Restricted, Unrestricted),
    exemption_periods(Exemptions, [section_8_2, section_8_4_b, section_8_4_c], OtherExcluding),
    day_in_any_period_t(OtherExcluding, BirthDay, OtherExempt),
    not_t(OtherExempt, NoOtherExemption),
    date_day_number(From, ExemptFromDay),
    DayBefore #= ExemptFromDay - 1,
    settled_on_day_t(Parent, DayBefore, SettledBefore),
    profile_value(Parent, ordinarily_resident_in_united_kingdom, [], Residence),
    interval_inside_one_period_t(Residence, ExemptFromDay, BirthDay, ResidentThroughout),
    profile_value(Parent, in_united_kingdom_in_breach_of_immigration_laws, [], Breaches),
    any_period_overlaps_t(Breaches, ExemptFromDay, BirthDay, BreachMeanwhile),
    not_t(BreachMeanwhile, NoBreach),
    any_parent_immune_t(AllRoutes, BirthDay, Immune),
    not_t(Immune, NotImmune),
    and_t(Resident, Unrestricted, A),
    and_t(A, NoOtherExemption, B),
    and_t(B, SettledBefore, C),
    and_t(C, ResidentThroughout, D),
    and_t(D, NoBreach, E),
    and_t(E, NotImmune, Truth).

any_parent_immune_t([], _, false).
any_parent_immune_t([route(_, Parent, _)|Routes], BirthDay, Truth) :-
    implements(british_nationality_act_1981_section_50_4),
    profile_value(Parent, diplomatic_immunity, [], Immunity),
    day_in_any_period_t(Immunity, BirthDay, Here),
    or_t(Here, Rest, Truth),
    any_parent_immune_t(Routes, BirthDay, Rest).

no_statute("british_citizenship_status", 3, "interface_shape").
no_statute("citizenship_on_day", 3, "computation_helper").
no_statute("citizen_on_day_t", 3, "computation_helper").
no_statute("citizen_otherwise_than_by_descent_on_day_t", 3, "computation_helper").
no_statute("status_given", 4, "computation_helper").
no_statute("status_from", 2, "computation_helper").
no_statute("public_grounds", 2, "computation_helper").
no_statute("held_on", 3, "computation_helper").
no_statute("since_t", 3, "computation_helper").
no_statute("candidate_grounds", 2, "computation_helper").
no_statute("ground_change_days", 2, "computation_helper").
no_statute("candidate_days", 2, "computation_helper").
no_statute("candidates_without_adoption", 2, "computation_helper").
no_statute("born_after_commencement_t", 2, "computation_helper").
no_statute("after_commencement_t", 3, "computation_helper").
no_statute("section_1_1_routes", 4, "computation_helper").
no_statute("section_2_routes", 3, "computation_helper").
no_statute("adoption_order_candidates", 3, "computation_helper").
no_statute("any_adopter_citizen_t", 3, "computation_helper").
no_statute("registration_list", 3, "computation_helper").
no_statute("naturalisation_list", 2, "computation_helper").
no_statute("exemption_periods", 3, "computation_helper").
no_statute("kind_in_t", 3, "computation_helper").
no_statute("first_period_containing", 3, "computation_helper").
no_statute("first_found", 5, "computation_helper").
