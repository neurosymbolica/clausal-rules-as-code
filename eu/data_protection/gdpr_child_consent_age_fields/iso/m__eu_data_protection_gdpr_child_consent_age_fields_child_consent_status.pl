% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_fields_child_consent_status, [child_consent_status/2, child_consent_outside_facts/2, decide_child_consent_status/2, child_consent_status_status/2, child_consent_status_checklist/2, child_consent_status_decision_resolvable/1, child_consent_status_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_kernel, [gdpr_child_consent_age_fields_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_citations, [implements/1]).

child_consent_status_status_values([eligible, ineligible]).

engagement_keys([processing_rests_on_consent, information_society_service, offered_directly_to_child]).

referral_row(information_society_service, cite(eu_reg_2016_679_art_4_25)).
referral_row(offered_directly_to_child, cite(eu_reg_2016_679_art_8_1)).

ground_row(art8_not_engaged, cite(eu_reg_2016_679_art_8_1)).
ground_row(child_at_least_16, cite(eu_reg_2016_679_art_8_1)).
ground_row(parental_consent_given, cite(eu_reg_2016_679_art_8_1)).
ground_row(parental_consent_missing_below_13, cite(eu_reg_2016_679_art_8_1_second_subpara)).
ground_row(child_at_least_national_age, cite(eu_reg_2016_679_art_8_1_second_subpara)).
ground_row(parental_consent_missing_below_national_age, cite(eu_reg_2016_679_art_8_1_second_subpara)).
ground_row(none, cite(eu_reg_2016_679_art_8_1)).

ground_checklist(art8_not_engaged, unmet, not_reached, not_reached, not_reached).
ground_checklist(child_at_least_16, met, met, not_reached, not_reached).
ground_checklist(parental_consent_given, met, unmet, met, not_reached).
ground_checklist(parental_consent_missing_below_13, met, unmet, unmet, not_reached).
ground_checklist(child_at_least_national_age, met, unmet, unmet, met).
ground_checklist(parental_consent_missing_below_national_age, met, unmet, unmet, unmet).
ground_checklist(none, unknown, unknown, unknown, unknown).

reading(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
reading(Profile, Key, Value) :-
    profile_get(Profile, Key, Value).

profile_pairs(_, [], []).
profile_pairs(Profile, [Key|Keys], Pairs) :-
    profile_lacks(Profile, Key),
    profile_pairs(Profile, Keys, Pairs).
profile_pairs(Profile, [Key|Keys], [Key - Value|Pairs]) :-
    profile_get(Profile, Key, Value),
    profile_pairs(Profile, Keys, Pairs).

missing_of([], [], []).
missing_of([Key|Keys], [absent|Readings], [Key|Missing]) :-
    missing_of(Keys, Readings, Missing).
missing_of([_|Keys], [Reading|Readings], Missing) :-
    dif(Reading, absent),
    missing_of(Keys, Readings, Missing).

element_class(true, met).
element_class(false, unmet).
element_class(absent, absent).
element_class(unsure, unsure).

engagement_outcome(Classes, Outcome) :-
    memberd_t(unmet, Classes, HasUnmet),
    memberd_t(absent, Classes, HasAbsent),
    memberd_t(unsure, Classes, HasUnsure),
    outcome_of(HasUnmet, HasAbsent, HasUnsure, Outcome).

outcome_of(true, _, _, unmet).
outcome_of(false, true, _, absent).
outcome_of(false, false, true, unsure).
outcome_of(false, false, false, met).

stage_status(Profile, Status, Ground) :-
    reading(Profile, processing_rests_on_consent, Consent),
    reading(Profile, information_society_service, Service),
    reading(Profile, offered_directly_to_child, Direct),
    element_class(Consent, ConsentClass),
    element_class(Service, ServiceClass),
    element_class(Direct, DirectClass),
    engagement_outcome([ConsentClass, ServiceClass, DirectClass], Outcome),
    engaged_status(Outcome, Profile, [Consent, Service, Direct], Status, Ground).

engaged_status(unmet, _, _, eligible, art8_not_engaged) :-
    implements(eu_reg_2016_679_art_8_1).
engaged_status(absent, _, Readings, indeterminate(Missing), none) :-
    implements(eu_reg_2016_679_art_8_1),
    engagement_keys(Keys),
    missing_of(Keys, Readings, Missing).
engaged_status(unsure, Profile, [_, Service, Direct], needs_legal_review(open_textured(Input, Citation), [inputs_relied_on(Pairs)]), none) :-
    implements(eu_reg_2016_679_art_8_1),
    first_unsure(Service, Direct, Input, Citation),
    engagement_keys(Keys),
    profile_pairs(Profile, Keys, Pairs).
engaged_status(met, Profile, _, Status, Ground) :-
    implements(eu_reg_2016_679_art_8_1),
    age_stage(Profile, Status, Ground).

first_unsure(unsure, _, information_society_service, Citation) :-
    implements(eu_reg_2016_679_art_4_25),
    referral_row(information_society_service, Citation).
first_unsure(Service, unsure, offered_directly_to_child, Citation) :-
    implements(eu_reg_2016_679_art_8_1),
    dif(Service, unsure),
    referral_row(offered_directly_to_child, Citation).

age_stage(Profile, Status, Ground) :-
    reading(Profile, child_age_years, AgeYears),
    age_status(AgeYears, Profile, Status, Ground).

age_status(absent, _, indeterminate([child_age_years]), none) :-
    implements(eu_reg_2016_679_art_8_1).
age_status(AgeYears, _, eligible, child_at_least_16) :-
    implements(eu_reg_2016_679_art_8_1),
    integer(AgeYears),
    AgeYears #>= 16.
age_status(AgeYears, Profile, Status, Ground) :-
    implements(eu_reg_2016_679_art_8_1),
    integer(AgeYears),
    AgeYears #< 16,
    parent_stage(Profile, AgeYears, Status, Ground).

parent_stage(Profile, AgeYears, Status, Ground) :-
    reading(Profile, parental_consent_given, Parental),
    parent_status(Parental, Profile, AgeYears, Status, Ground).

parent_status(absent, _, _, indeterminate([parental_consent_given]), none) :-
    implements(eu_reg_2016_679_art_8_1).
parent_status(true, _, _, eligible, parental_consent_given) :-
    implements(eu_reg_2016_679_art_8_1).
parent_status(false, _, AgeYears, ineligible, parental_consent_missing_below_13) :-
    implements(eu_reg_2016_679_art_8_1_second_subpara),
    AgeYears #< 13.
parent_status(false, Profile, AgeYears, Status, Ground) :-
    implements(eu_reg_2016_679_art_8_1_second_subpara),
    AgeYears #>= 13,
    national_stage(Profile, AgeYears, Status, Ground).

national_stage(Profile, AgeYears, Status, Ground) :-
    reading(Profile, member_state, MemberState),
    reading(Profile, member_state_selection_test, SelectionTest),
    reading(Profile, consent_date, ConsentDate),
    missing_of([member_state, member_state_selection_test, consent_date], [MemberState, SelectionTest, ConsentDate], Missing),
    national_checked(Missing, Profile, AgeYears, MemberState, Status, Ground).

national_checked([Key|Keys], _, _, _, indeterminate([Key|Keys]), none) :-
    implements(eu_reg_2016_679_art_8_1_second_subpara).
national_checked([], Profile, AgeYears, MemberState, Status, Ground) :-
    implements(eu_reg_2016_679_art_8_1_second_subpara),
    reading(Profile, member_state_digital_consent_age, Fact),
    national_fact_status(Fact, MemberState, Profile, AgeYears, Status, Ground).

national_fact_status(absent, _, Profile, _, Status, none) :-
    implements(eu_reg_2016_679_art_8_1_second_subpara),
    referral_status(Profile, Status).
national_fact_status(attested(national_digital_consent_age(MemberState, NationalAgeYears, _), _), MemberState, _, AgeYears, eligible, child_at_least_national_age) :-
    implements(eu_reg_2016_679_art_8_1_second_subpara),
    NationalAgeYears #=< AgeYears.
national_fact_status(attested(national_digital_consent_age(MemberState, NationalAgeYears, _), _), MemberState, _, AgeYears, ineligible, parental_consent_missing_below_national_age) :-
    implements(eu_reg_2016_679_art_8_1_second_subpara),
    NationalAgeYears #> AgeYears.
national_fact_status(attested(national_digital_consent_age(FactMemberState, _, _), _), MemberState, Profile, _, Status, none) :-
    implements(eu_reg_2016_679_art_8_1_second_subpara),
    dif(FactMemberState, MemberState),
    referral_status(Profile, Status).

referral_status(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_8_1_second_subpara), cite(member_state_digital_consent_age_law)), [resolution(cite(member_state_digital_consent_age_law), not_attempted), inputs_relied_on(Pairs)])) :-
    implements(member_state_digital_consent_age_law),
    profile_pairs(Profile, [child_age_years, parental_consent_given, member_state, member_state_selection_test, consent_date], Pairs).

status_and_ground(Profile, Status, Ground) :-
    gdpr_child_consent_age_fields_input_problems(Profile, Problems),
    problems_status(Problems, Profile, Status, Ground).

problems_status([], Profile, Status, Ground) :-
    stage_status(Profile, Status, Ground).
problems_status([Problem|Problems], _, input_problems([Problem|Problems]), none).

decide_child_consent_status(Profile, child_consent_status_verdict(Status, [Citation])) :-
    status_and_ground(Profile, Status, Ground),
    ground_row(Ground, Citation).

child_consent_status(Profile, Status) :-
    decide_child_consent_status(Profile, child_consent_status_verdict(Status, _Citations)).

child_consent_status_status(Profile, Status) :-
    decide_child_consent_status(Profile, child_consent_status_verdict(Status, _Citations)).

child_consent_status_checklist(Profile, [item(engagement, EngagementStatus, cite(eu_reg_2016_679_art_8_1)), item(age_at_least_16, AgeStatus, cite(eu_reg_2016_679_art_8_1)), item(parental_consent, ParentalStatus, cite(eu_reg_2016_679_art_8_1)), item(national_age_reached, NationalStatus, cite(eu_reg_2016_679_art_8_1_second_subpara))]) :-
    status_and_ground(Profile, _Status, Ground),
    ground_checklist(Ground, EngagementStatus, AgeStatus, ParentalStatus, NationalStatus).

child_consent_status_decision_resolvable(Profile) :-
    decide_child_consent_status(Profile, _Verdict).

child_consent_outside_facts(Profile, OutsideFacts) :-
    gdpr_child_consent_age_fields_input_problems(Profile, Problems),
    outside_for(Problems, Profile, OutsideFacts).

outside_for([], Profile, [outside_fact(member_state_digital_consent_age, Fact)]) :-
    reading(Profile, member_state_digital_consent_age, Fact).
outside_for([Problem|Problems], _, input_problems([Problem|Problems])).

engaged_attributes([attribute(processing_rests_on_consent, true), attribute(information_society_service, true), attribute(offered_directly_to_child, true)]).

engaged_profile(Rest, Profile) :-
    engaged_attributes(Engaged),
    append(Engaged, Rest, Profile).

sample_context([attribute(member_state, germany), attribute(member_state_selection_test, controller_establishment), attribute(consent_date, date(2026, 5, 1))]).

sample_fact(NationalAgeYears, attribute(member_state_digital_consent_age, attested(national_digital_consent_age(germany, NationalAgeYears, national_act(some_act, article_one)), attestation(decision_layer, date(2026, 11, 9), user_declared, none)))).

test(sixteen_is_eligible) :-
    engaged_profile([attribute(child_age_years, 16)], Profile),
    child_consent_status(Profile, eligible).
test(fifteen_without_parent_and_national_sixteen_is_ineligible) :-
    engaged_profile([attribute(child_age_years, 15), attribute(parental_consent_given, false)], Base),
    sample_context(Context),
    sample_fact(16, Fact),
    append(Base, [Fact|Context], Profile),
    child_consent_status(Profile, ineligible).
test(fifteen_without_parent_and_national_fifteen_is_eligible) :-
    engaged_profile([attribute(child_age_years, 15), attribute(parental_consent_given, false)], Base),
    sample_context(Context),
    sample_fact(15, Fact),
    append(Base, [Fact|Context], Profile),
    child_consent_status(Profile, eligible).
test(twelve_without_parent_is_ineligible) :-
    engaged_profile([attribute(child_age_years, 12), attribute(parental_consent_given, false)], Profile),
    child_consent_status(Profile, ineligible).
test(twelve_with_parent_is_eligible) :-
    engaged_profile([attribute(child_age_years, 12), attribute(parental_consent_given, true)], Profile),
    child_consent_status(Profile, eligible).
test(an_absent_national_age_refers) :-
    engaged_profile([attribute(child_age_years, 14), attribute(parental_consent_given, false)], Base),
    sample_context(Context),
    append(Base, Context, Profile),
    child_consent_status(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_8_1_second_subpara), cite(member_state_digital_consent_age_law)), [resolution(cite(member_state_digital_consent_age_law), not_attempted), inputs_relied_on(_Pairs)])).
test(a_service_not_offered_to_a_child_is_not_engaged) :-
    Profile = [attribute(processing_rests_on_consent, true), attribute(information_society_service, true), attribute(offered_directly_to_child, false)],
    child_consent_status(Profile, eligible).
test(a_missing_age_is_indeterminate) :-
    engaged_profile([], Profile),
    child_consent_status(Profile, indeterminate([child_age_years])).
test(the_status_is_answered_once) :-
    engaged_profile([attribute(child_age_years, 16)], Profile),
    findall(Status, child_consent_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(a_checklist_has_rows) :-
    engaged_profile([attribute(child_age_years, 16)], Profile),
    child_consent_status_checklist(Profile, [item(engagement, met, _)|_]).

test(fifteen_with_national_sixteen_is_not_eligible, fail) :-
    engaged_profile([attribute(child_age_years, 15), attribute(parental_consent_given, false)], Base),
    sample_context(Context),
    sample_fact(16, Fact),
    append(Base, [Fact|Context], Profile),
    child_consent_status(Profile, eligible).
