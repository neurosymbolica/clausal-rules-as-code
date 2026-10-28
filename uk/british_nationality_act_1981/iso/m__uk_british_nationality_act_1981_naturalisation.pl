:- module(m__uk_british_nationality_act_1981_naturalisation, [british_citizenship_naturalisation/4, naturalisation_provision/1, schedule_1_absence_days/5]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [get/3]).
:- use_module(library(clpz)).
:- use_module(m__uk_british_nationality_act_1981_citations, [implements/1]).
:- use_module(m__uk_british_nationality_act_1981_kernel, [date_day_number/2, day_in_any_period_t/3, any_period_overlaps_t/4, period_of_years_ending_with/4, days_in_periods_within/4, present_on_day_t/3, attained_age_t/4, and_t/3, or_t/3, profile_value/4, condition_outcome/2]).
:- use_module(m__uk_british_nationality_act_1981_input_check, [british_nationality_input_problems/3, date_argument_problems/3]).
:- use_module(m__uk_british_nationality_act_1981_citizenship, [citizen_on_day_t/3]).

naturalisation_provision(section_6_1).
naturalisation_provision(section_6_2).

british_citizenship_naturalisation(Profile, Provision, ApplicationDate, Result) :-
    naturalisation_provision(Provision),
    british_nationality_input_problems(naturalisation, Profile, ProfileProblems),
    date_argument_problems(application_date, ApplicationDate, DateProblems),
    append(ProfileProblems, DateProblems, Problems),
    naturalisation_given(Problems, Profile, Provision, ApplicationDate, Result).

naturalisation_given([_|_], _, _, _, assessment(indeterminate, [])).
naturalisation_given([], Profile, Provision, ApplicationDate, assessment(Outcome, Conditions)) :-
    date_day_number(ApplicationDate, ApplicationDay),
    conditions(Provision, Profile, ApplicationDate, ApplicationDay, Conditions),
    condition_outcome(Conditions, Fulfilment),
    naturalisation_outcome(Fulfilment, Outcome).

naturalisation_outcome(fulfilled, requirements_fulfilled).
naturalisation_outcome(fulfilled_only_if_waived, requirements_fulfilled_only_if_waived).
naturalisation_outcome(not_fulfilled, requirements_not_fulfilled).

met_t(true, met).
met_t(false, unmet).

waivable_t(true, met).
waivable_t(false, waivable).

not_t(true, false).
not_t(false, true).

days_at_most_t(Count, Limit, true) :-
    Count #=< Limit.
days_at_most_t(Count, Limit, false) :-
    Count #> Limit.

conditions(section_6_1, Profile, ApplicationDate, ApplicationDay, [condition(full_age, FullAge, british_nationality_act_1981_section_6_1), condition(full_capacity, FullCapacity, british_nationality_act_1981_section_6_1)|Rest]) :-
    implements(british_nationality_act_1981_section_6_1),
    implements(british_nationality_act_1981_schedule_1_paragraph_1_1),
    implements(british_nationality_act_1981_section_50_11),
    full_age_and_capacity(Profile, ApplicationDay, FullAge, FullCapacity),
    crown_service_outside_on_day_t(Profile, ApplicationDay, Alternative),
    residence_or_alternative(Alternative, Profile, ApplicationDate, ApplicationDay, Residence),
    get(Profile, good_character, CharacterTruth),
    met_t(CharacterTruth, Character),
    get(Profile, sufficient_knowledge_of_language, LanguageTruth),
    language_status(LanguageTruth, Language),
    get(Profile, intention_after_naturalisation, Intention),
    intention_status(Intention, IntentionStatus),
    append(Residence, [condition(good_character, Character, british_nationality_act_1981_schedule_1_paragraph_1_1), condition(sufficient_knowledge_of_language, Language, british_nationality_act_1981_schedule_1_paragraph_2), condition(intention_as_to_home_or_service, IntentionStatus, british_nationality_act_1981_schedule_1_paragraph_1_1)], Rest).
conditions(section_6_2, Profile, ApplicationDate, ApplicationDay, [condition(full_age, FullAge, british_nationality_act_1981_section_6_2), condition(full_capacity, FullCapacity, british_nationality_act_1981_section_6_2), condition(married_to_british_citizen_on_date_of_application, Married, british_nationality_act_1981_section_6_2)|Rest]) :-
    implements(british_nationality_act_1981_section_6_2),
    implements(british_nationality_act_1981_schedule_1_paragraph_3),
    implements(british_nationality_act_1981_schedule_1_paragraph_4),
    full_age_and_capacity(Profile, ApplicationDay, FullAge, FullCapacity),
    profile_value(Profile, spouse, none, Spouse),
    spouse_citizen_t(Spouse, ApplicationDay, MarriedTruth),
    met_t(MarriedTruth, Married),
    residence_conditions(Profile, ApplicationDate, ApplicationDay, 3, 270, british_nationality_act_1981_schedule_1_paragraph_3, first_schedule_paragraph_3, Residence),
    spouse_in_service_t(Spouse, ApplicationDay, SpouseServing),
    waive_residence(SpouseServing, Residence, Waived),
    get(Profile, good_character, CharacterTruth),
    met_t(CharacterTruth, Character),
    append(Waived, [condition(good_character, Character, british_nationality_act_1981_schedule_1_paragraph_3)], Rest).

residence_or_alternative(true, _, _, _, [condition(crown_service_outside_united_kingdom_on_date_of_application, met, british_nationality_act_1981_schedule_1_paragraph_1_3)]) :-
    implements(british_nationality_act_1981_schedule_1_paragraph_1_3).
residence_or_alternative(false, Profile, ApplicationDate, ApplicationDay, Conditions) :-
    implements(british_nationality_act_1981_schedule_1_paragraph_1_2),
    implements(british_nationality_act_1981_schedule_1_paragraph_2),
    residence_conditions(Profile, ApplicationDate, ApplicationDay, 5, 450, british_nationality_act_1981_schedule_1_paragraph_1_2, first_schedule_paragraph_1, Conditions).

language_status(true, met).
language_status(false, waivable).

intention_status(principal_home_in_united_kingdom, met).
intention_status(qualifying_service, met).
intention_status(other, unmet).

spouse_citizen_t(none, _, false).
spouse_citizen_t(Spouse, Day, Truth) :-
    dif(Spouse, none),
    citizen_on_day_t(Spouse, Day, Truth).

spouse_in_service_t(none, _, false).
spouse_in_service_t(Spouse, Day, Truth) :-
    implements(british_nationality_act_1981_schedule_1_paragraph_4),
    dif(Spouse, none),
    profile_value(Spouse, service_outside_united_kingdom, [], Services),
    paragraph_b_service_on_day_t(Services, Day, Truth).

paragraph_b_service_on_day_t([], _, false).
paragraph_b_service_on_day_t([service(Kind, From, To, RecruitedIn)|Services], Day, Truth) :-
    paragraph_b_kind_t(Kind, KindOk),
    recruited_here_t(RecruitedIn, RecruitedOk),
    day_in_any_period_t([period(From, To)], Day, Serving),
    and_t(KindOk, RecruitedOk, Both),
    and_t(Both, Serving, Here),
    or_t(Here, Rest, Truth),
    paragraph_b_service_on_day_t(Services, Day, Rest).

paragraph_b_kind_t(crown_service_under_the_government_of_the_united_kingdom, true).
paragraph_b_kind_t(designated_service, true).
paragraph_b_kind_t(community_institution, false).
paragraph_b_kind_t(other_service, false).

recruited_here_t(united_kingdom, true).
recruited_here_t(member_state_of_the_communities, false).
recruited_here_t(other_country, false).

waive_residence(false, Conditions, Conditions).
waive_residence(true, Conditions, Waived) :-
    implements(british_nationality_act_1981_schedule_1_paragraph_4),
    waive_paragraph_3_a_and_b(Conditions, Waived).

waive_paragraph_3_a_and_b([], []).
waive_paragraph_3_a_and_b([condition(Name, Status, Citation)|Conditions], [condition(Name, Waived, Citation)|Rest]) :-
    paragraph_3_a_or_b_t(Name, AorB),
    waive_status(AorB, Status, Waived),
    waive_paragraph_3_a_and_b(Conditions, Rest).

paragraph_3_a_or_b_t(in_united_kingdom_at_beginning_of_period, true).
paragraph_3_a_or_b_t(absent_at_most_allowed_days_in_period, true).
paragraph_3_a_or_b_t(absent_at_most_90_days_in_twelve_months, true).
paragraph_3_a_or_b_t(no_restriction_on_stay, false).
paragraph_3_a_or_b_t(not_in_breach_of_immigration_laws_in_period, false).

waive_status(false, Status, Status).
waive_status(true, met, met).
waive_status(true, waivable, waivable).
waive_status(true, unmet, waivable).

residence_conditions(Profile, ApplicationDate, ApplicationDay, Years, Limit, Citation, Paragraph, [condition(in_united_kingdom_at_beginning_of_period, Beginning, Citation), condition(absent_at_most_allowed_days_in_period, Period, Citation), condition(absent_at_most_90_days_in_twelve_months, TwelveMonths, Citation), condition(no_restriction_on_stay, Restriction, Citation), condition(not_in_breach_of_immigration_laws_in_period, Breach, Citation)]) :-
    implements(british_nationality_act_1981_schedule_1_paragraph_9_1),
    profile_value(Profile, absences_from_united_kingdom, [], Absences),
    treated_absences(Profile, Treated),
    append(Absences, Treated, AllAbsences),
    period_of_years_ending_with(ApplicationDate, Years, StartDay, _),
    present_on_day_t(Absences, StartDay, Present),
    present_on_day_t(AllAbsences, StartDay, PresentTreated),
    beginning_status(Present, PresentTreated, Beginning),
    schedule_1_absence_days(Profile, ApplicationDate, Years, DaysTreated, YearDays),
    days_at_most_t(DaysTreated, Limit, PeriodTruth),
    waivable_t(PeriodTruth, Period),
    period_of_years_ending_with(ApplicationDate, 1, YearStart, _),
    days_at_most_t(YearDays, 90, TwelveMonthsTruth),
    waivable_t(TwelveMonthsTruth, TwelveMonths),
    profile_value(Profile, immigration_restrictions_on_stay, [], Restrictions),
    restriction_condition(Paragraph, Restrictions, YearStart, ApplicationDay, Restriction),
    profile_value(Profile, in_united_kingdom_in_breach_of_immigration_laws, [], Breaches),
    any_period_overlaps_t(Breaches, StartDay, ApplicationDay, InBreach),
    not_t(InBreach, LawfulTruth),
    waivable_t(LawfulTruth, Breach).

beginning_status(true, true, met).
beginning_status(true, false, waivable).
beginning_status(false, _, unmet).

restriction_condition(first_schedule_paragraph_1, Restrictions, YearStart, ApplicationDay, Status) :-
    implements(british_nationality_act_1981_schedule_1_paragraph_1_2),
    any_period_overlaps_t(Restrictions, YearStart, ApplicationDay, InYear),
    day_in_any_period_t(Restrictions, ApplicationDay, OnDate),
    restriction_status(InYear, OnDate, Status).
restriction_condition(first_schedule_paragraph_3, Restrictions, _, ApplicationDay, Status) :-
    implements(british_nationality_act_1981_schedule_1_paragraph_3),
    day_in_any_period_t(Restrictions, ApplicationDay, OnDate),
    not_t(OnDate, Free),
    met_t(Free, Status).

restriction_status(false, _, met).
restriction_status(true, false, waivable).
restriction_status(true, true, unmet).

schedule_1_absence_days(Profile, ApplicationDate, Years, PeriodDays, TwelveMonthDays) :-
    implements(british_nationality_act_1981_schedule_1_paragraph_9_1),
    profile_value(Profile, absences_from_united_kingdom, [], Absences),
    treated_absences(Profile, Treated),
    append(Absences, Treated, AllAbsences),
    period_of_years_ending_with(ApplicationDate, Years, StartDay, EndDay),
    days_in_periods_within(AllAbsences, StartDay, EndDay, PeriodDays),
    period_of_years_ending_with(ApplicationDate, 1, YearStart, _),
    days_in_periods_within(AllAbsences, YearStart, EndDay, TwelveMonthDays).

treated_absences(Profile, Periods) :-
    implements(british_nationality_act_1981_schedule_1_paragraph_9_1),
    profile_value(Profile, immigration_exemptions, [], Exemptions),
    paragraph_9_exemptions(Exemptions, ExemptionPeriods),
    profile_value(Profile, detentions, [], Detentions),
    append(ExemptionPeriods, Detentions, Periods).

paragraph_9_exemptions([], []).
paragraph_9_exemptions([exemption(Kind, From, To)|Exemptions], Periods) :-
    paragraph_9_kind_t(Kind, Counts),
    paragraph_9_keep(Counts, From, To, Rest, Periods),
    paragraph_9_exemptions(Exemptions, Rest).

paragraph_9_kind_t(section_8_2, false).
paragraph_9_kind_t(section_8_2_order_provides_otherwise, false).
paragraph_9_kind_t(section_8_3, true).
paragraph_9_kind_t(section_8_4_a, true).
paragraph_9_kind_t(section_8_4_b, true).
paragraph_9_kind_t(section_8_4_c, true).

paragraph_9_keep(true, From, To, Rest, [period(From, To)|Rest]).
paragraph_9_keep(false, _, _, Rest, Rest).

full_age_and_capacity(Profile, ApplicationDay, FullAge, FullCapacity) :-
    implements(british_nationality_act_1981_section_50_11),
    get(Profile, date_of_birth, DateOfBirth),
    attained_age_t(DateOfBirth, 18, ApplicationDay, AgeTruth),
    met_t(AgeTruth, FullAge),
    profile_value(Profile, of_unsound_mind, false, Unsound),
    not_t(Unsound, CapacityTruth),
    met_t(CapacityTruth, FullCapacity).

crown_service_outside_on_day_t(Profile, Day, Truth) :-
    implements(british_nationality_act_1981_schedule_1_paragraph_1_3),
    profile_value(Profile, service_outside_united_kingdom, [], Services),
    crown_service_on_day_t(Services, Day, Truth).

crown_service_on_day_t([], _, false).
crown_service_on_day_t([service(Kind, From, To, _)|Services], Day, Truth) :-
    crown_kind_t(Kind, KindOk),
    day_in_any_period_t([period(From, To)], Day, Serving),
    and_t(KindOk, Serving, Here),
    or_t(Here, Rest, Truth),
    crown_service_on_day_t(Services, Day, Rest).

crown_kind_t(crown_service_under_the_government_of_the_united_kingdom, true).
crown_kind_t(designated_service, false).
crown_kind_t(community_institution, false).
crown_kind_t(other_service, false).

no_statute("british_citizenship_naturalisation", 4, "interface_shape").
no_statute("naturalisation_given", 5, "computation_helper").
no_statute("days_at_most_t", 3, "computation_helper").
no_statute("spouse_citizen_t", 3, "computation_helper").
no_statute("paragraph_b_service_on_day_t", 3, "computation_helper").
no_statute("waive_paragraph_3_a_and_b", 2, "computation_helper").
no_statute("paragraph_9_exemptions", 2, "computation_helper").
no_statute("crown_service_on_day_t", 3, "computation_helper").
