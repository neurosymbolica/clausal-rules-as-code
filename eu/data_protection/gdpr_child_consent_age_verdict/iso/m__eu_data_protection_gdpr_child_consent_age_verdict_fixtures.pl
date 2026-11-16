% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_verdict_fixtures, [gdpr_child_consent_age_verdict_subject/1, gdpr_child_consent_age_verdict_profile_for/2, gdpr_child_consent_age_verdict_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_verdict_child_consent_ground, [decide_child_consent/2]).

gdpr_child_consent_age_verdict_subject(consent_not_the_basis).
gdpr_child_consent_age_verdict_subject(service_judgement_unsure).
gdpr_child_consent_age_verdict_subject(service_key_missing).
gdpr_child_consent_age_verdict_subject(adult_at_sixteen).
gdpr_child_consent_age_verdict_subject(adult_ignores_parental_flag).
gdpr_child_consent_age_verdict_subject(fifteen_without_parental_answer).
gdpr_child_consent_age_verdict_subject(fifteen_national_age_not_shown).
gdpr_child_consent_age_verdict_subject(fourteen_at_national_age).
gdpr_child_consent_age_verdict_subject(thirteen_below_national_age).
gdpr_child_consent_age_verdict_subject(fourteen_national_age_other_state).
gdpr_child_consent_age_verdict_subject(fourteen_missing_consent_date).
gdpr_child_consent_age_verdict_subject(twelve_without_parental_consent).
gdpr_child_consent_age_verdict_subject(twelve_with_reasonable_verification).
gdpr_child_consent_age_verdict_subject(twelve_with_unreasonable_verification).
gdpr_child_consent_age_verdict_subject(twelve_with_unsure_verification).
gdpr_child_consent_age_verdict_subject(twelve_without_verification_answer).
gdpr_child_consent_age_verdict_subject(no_age_given).
gdpr_child_consent_age_verdict_subject(negative_age).

engagement_attributes([attribute(processing_rests_on_consent, true), attribute(information_society_service, true), attribute(offered_directly_to_child, true)]).

stage_four_attributes([attribute(member_state, austria), attribute(member_state_selection_test, controller_establishment), attribute(consent_date, date(2026, 10, 1))]).

attested_national_age(State, Age, attribute(member_state_digital_consent_age, attested(national_digital_consent_age(State, Age, national_provision(data_protection_act, article_four)), attestation(decision_layer, host_timestamp, state_law_lookup, none)))).

engaged_subject(adult_at_sixteen, [attribute(child_age_years, 16)]).
engaged_subject(adult_ignores_parental_flag, [attribute(child_age_years, 16), attribute(parental_consent_given, false)]).
engaged_subject(fifteen_without_parental_answer, [attribute(child_age_years, 15)]).
engaged_subject(fifteen_national_age_not_shown, Attributes) :-
    stage_four_attributes(StageFour),
    append([attribute(child_age_years, 15), attribute(parental_consent_given, false)], StageFour, Attributes).
engaged_subject(fourteen_at_national_age, Attributes) :-
    stage_four_attributes(StageFour),
    attested_national_age(austria, 14, Attested),
    append([attribute(child_age_years, 14), attribute(parental_consent_given, false), Attested], StageFour, Attributes).
engaged_subject(thirteen_below_national_age, Attributes) :-
    stage_four_attributes(StageFour),
    attested_national_age(austria, 14, Attested),
    append([attribute(child_age_years, 13), attribute(parental_consent_given, false), Attested], StageFour, Attributes).
engaged_subject(fourteen_national_age_other_state, Attributes) :-
    stage_four_attributes(StageFour),
    attested_national_age(germany, 16, Attested),
    append([attribute(child_age_years, 14), attribute(parental_consent_given, false), Attested], StageFour, Attributes).
engaged_subject(fourteen_missing_consent_date, [attribute(child_age_years, 14), attribute(parental_consent_given, false), attribute(member_state, austria), attribute(member_state_selection_test, controller_establishment)]).
engaged_subject(twelve_without_parental_consent, [attribute(child_age_years, 12), attribute(parental_consent_given, false)]).
engaged_subject(twelve_with_reasonable_verification, [attribute(child_age_years, 12), attribute(parental_consent_given, true), attribute(verification_efforts_reasonable, true)]).
engaged_subject(twelve_with_unreasonable_verification, [attribute(child_age_years, 12), attribute(parental_consent_given, true), attribute(verification_efforts_reasonable, false)]).
engaged_subject(twelve_with_unsure_verification, [attribute(child_age_years, 12), attribute(parental_consent_given, true), attribute(verification_efforts_reasonable, unsure)]).
engaged_subject(twelve_without_verification_answer, [attribute(child_age_years, 12), attribute(parental_consent_given, true)]).
engaged_subject(no_age_given, []).
engaged_subject(negative_age, [attribute(child_age_years, -1)]).

standalone_subject(consent_not_the_basis, [attribute(processing_rests_on_consent, false), attribute(information_society_service, true), attribute(offered_directly_to_child, true), attribute(child_age_years, 10)]).
standalone_subject(service_judgement_unsure, [attribute(processing_rests_on_consent, true), attribute(information_society_service, unsure), attribute(offered_directly_to_child, true), attribute(child_age_years, 12)]).
standalone_subject(service_key_missing, [attribute(processing_rests_on_consent, true), attribute(offered_directly_to_child, true), attribute(child_age_years, 12)]).

gdpr_child_consent_age_verdict_profile_for(Subject, Profile) :-
    standalone_subject(Subject, Profile).
gdpr_child_consent_age_verdict_profile_for(Subject, Profile) :-
    engaged_subject(Subject, Specific),
    engagement_attributes(Engagement),
    append(Engagement, Specific, Profile).

gdpr_child_consent_age_verdict_assess(Subject, Result) :-
    gdpr_child_consent_age_verdict_profile_for(Subject, Profile),
    decide_child_consent(Profile, Result).
