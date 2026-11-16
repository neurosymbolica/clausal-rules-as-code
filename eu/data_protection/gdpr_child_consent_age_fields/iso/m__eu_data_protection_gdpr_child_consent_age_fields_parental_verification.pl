% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_fields_parental_verification, [parental_verification/2, decide_parental_verification/2, parental_verification_status/2, parental_verification_checklist/2, parental_verification_decision_resolvable/1, parental_verification_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_child_consent_status, [child_consent_status/2]).

parental_verification_status_values([efforts_reasonable, efforts_not_reasonable, not_applicable, not_reached]).

reading(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
reading(Profile, Key, Value) :-
    profile_get(Profile, Key, Value).

parental_verification(Profile, Verification) :-
    child_consent_status(Profile, Status),
    verification_for(Status, Profile, Verification).

verification_for(eligible, Profile, Verification) :-
    relies_on_parental_consent_t(Profile, Reliance),
    verified_by(Reliance, Profile, Verification).
verification_for(ineligible, _, not_applicable).
verification_for(indeterminate(_), _, not_reached).
verification_for(needs_legal_review(_, _), _, not_reached).
verification_for(input_problems(_), _, not_reached).

relies_on_parental_consent_t(Profile, Reliance) :-
    reading(Profile, processing_rests_on_consent, Consent),
    reading(Profile, information_society_service, Service),
    reading(Profile, offered_directly_to_child, Direct),
    reading(Profile, parental_consent_given, Parental),
    reading(Profile, child_age_years, AgeYears),
    flag_true_t(Consent, ConsentFlag),
    flag_true_t(Service, ServiceFlag),
    flag_true_t(Direct, DirectFlag),
    flag_true_t(Parental, ParentalFlag),
    age_below_t(AgeYears, AgeFlag),
    all_flags_t([ConsentFlag, ServiceFlag, DirectFlag, ParentalFlag, AgeFlag], Reliance).

flag_true_t(true, true).
flag_true_t(false, false).
flag_true_t(unsure, false).
flag_true_t(absent, false).

age_below_t(absent, false).
age_below_t(AgeYears, true) :-
    integer(AgeYears),
    AgeYears #< 16.
age_below_t(AgeYears, false) :-
    integer(AgeYears),
    AgeYears #>= 16.

all_flags_t(Flags, Truth) :-
    memberd_t(false, Flags, HasFalse),
    flip_truth(HasFalse, Truth).

flip_truth(true, false).
flip_truth(false, true).

verified_by(false, _, not_applicable) :-
    implements(eu_reg_2016_679_art_8_2).
verified_by(true, Profile, Verification) :-
    implements(eu_reg_2016_679_art_8_2),
    reading(Profile, verification_efforts_reasonable, Efforts),
    efforts_result(Efforts, Verification).

efforts_result(true, efforts_reasonable) :-
    implements(eu_reg_2016_679_art_8_2).
efforts_result(false, efforts_not_reasonable) :-
    implements(eu_reg_2016_679_art_8_2).
efforts_result(absent, indeterminate([verification_efforts_reasonable])) :-
    implements(eu_reg_2016_679_art_8_2).
efforts_result(unsure, needs_legal_review(open_textured(verification_efforts_reasonable, cite(eu_reg_2016_679_art_8_2)), [inputs_relied_on([verification_efforts_reasonable - unsure])])) :-
    implements(eu_reg_2016_679_art_8_2).

decide_parental_verification(Profile, parental_verification_verdict(Verification, [cite(eu_reg_2016_679_art_8_2)])) :-
    parental_verification(Profile, Verification).

parental_verification_status(Profile, Verification) :-
    decide_parental_verification(Profile, parental_verification_verdict(Verification, _Citations)).

parental_verification_checklist(Profile, [item(verification_efforts, Status, cite(eu_reg_2016_679_art_8_2))]) :-
    parental_verification(Profile, Verification),
    checklist_status(Verification, Status).

checklist_status(efforts_reasonable, met).
checklist_status(efforts_not_reasonable, unmet).
checklist_status(not_applicable, not_applicable).
checklist_status(not_reached, not_reached).
checklist_status(indeterminate(_), unknown).
checklist_status(needs_legal_review(_, _), unknown).

parental_verification_decision_resolvable(Profile) :-
    decide_parental_verification(Profile, _Verdict).

sample_engaged_attributes([attribute(processing_rests_on_consent, true), attribute(information_society_service, true), attribute(offered_directly_to_child, true)]).

sample_profile(Rest, Profile) :-
    sample_engaged_attributes(Engaged),
    append(Engaged, Rest, Profile).

test(reasonable_efforts_with_parental_consent) :-
    sample_profile([attribute(child_age_years, 12), attribute(parental_consent_given, true), attribute(verification_efforts_reasonable, true)], Profile),
    parental_verification(Profile, efforts_reasonable).
test(unreasonable_efforts_with_parental_consent) :-
    sample_profile([attribute(child_age_years, 12), attribute(parental_consent_given, true), attribute(verification_efforts_reasonable, false)], Profile),
    parental_verification(Profile, efforts_not_reasonable).
test(a_sixteen_year_old_needs_no_verification) :-
    sample_profile([attribute(child_age_years, 16)], Profile),
    parental_verification(Profile, not_applicable).
test(an_ineligible_processing_needs_no_verification) :-
    sample_profile([attribute(child_age_years, 12), attribute(parental_consent_given, false)], Profile),
    parental_verification(Profile, not_applicable).
test(a_missing_age_is_not_reached) :-
    sample_profile([], Profile),
    parental_verification(Profile, not_reached).
test(an_unsure_judgement_refers) :-
    sample_profile([attribute(child_age_years, 12), attribute(parental_consent_given, true), attribute(verification_efforts_reasonable, unsure)], Profile),
    parental_verification(Profile, needs_legal_review(open_textured(verification_efforts_reasonable, cite(eu_reg_2016_679_art_8_2)), [inputs_relied_on([verification_efforts_reasonable - unsure])])).
test(an_absent_judgement_is_indeterminate) :-
    sample_profile([attribute(child_age_years, 12), attribute(parental_consent_given, true)], Profile),
    parental_verification(Profile, indeterminate([verification_efforts_reasonable])).
test(the_verification_is_answered_once) :-
    sample_profile([attribute(child_age_years, 12), attribute(parental_consent_given, true), attribute(verification_efforts_reasonable, true)], Profile),
    findall(Verification, parental_verification(Profile, Verification), Verifications),
    Verifications == [efforts_reasonable].

test(unreasonable_efforts_are_not_reasonable_efforts, fail) :-
    sample_profile([attribute(child_age_years, 12), attribute(parental_consent_given, true), attribute(verification_efforts_reasonable, false)], Profile),
    parental_verification(Profile, efforts_reasonable).
