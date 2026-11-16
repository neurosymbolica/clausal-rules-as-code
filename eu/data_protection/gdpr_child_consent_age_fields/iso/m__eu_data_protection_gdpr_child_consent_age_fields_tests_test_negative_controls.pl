% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_child_consent_age_fields_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_child_consent_status, [child_consent_status/2, child_consent_status_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_child_consent_age_fields_parental_verification, [parental_verification/2, parental_verification_status_values/1]).

engaged([attribute(processing_rests_on_consent, true), attribute(information_society_service, true), attribute(offered_directly_to_child, true)]).

context(MemberState, [attribute(member_state, MemberState), attribute(member_state_selection_test, child_residence), attribute(consent_date, date(2026, 5, 1))]).

fact(MemberState, AgeYears, attribute(member_state_digital_consent_age, attested(national_digital_consent_age(MemberState, AgeYears, national_act(test_act, article_one)), attestation(decision_layer, date(2026, 11, 9), user_declared, none)))).

child_profile(AgeYears, Parental, Profile) :-
    engaged(Engaged),
    append(Engaged, [attribute(child_age_years, AgeYears), attribute(parental_consent_given, Parental)], Profile).

national_profile(AgeYears, NationalAgeYears, Profile) :-
    child_profile(AgeYears, false, Base),
    context(france, Context),
    fact(france, NationalAgeYears, Fact),
    append(Base, [Fact|Context], Profile).

other_state_profile(AgeYears, Profile) :-
    child_profile(AgeYears, false, Base),
    context(france, Context),
    fact(germany, 16, Fact),
    append(Base, [Fact|Context], Profile).

absent_fact_profile(AgeYears, Profile) :-
    child_profile(AgeYears, false, Base),
    context(france, Context),
    append(Base, Context, Profile).

verification_profile(Efforts, Profile) :-
    child_profile(12, true, Base),
    append(Base, [attribute(verification_efforts_reasonable, Efforts)], Profile).

test(the_status_atoms_are_real) :-
    child_consent_status_status_values(StatusValues),
    member(eligible, StatusValues),
    member(ineligible, StatusValues).
test(the_verification_atoms_are_real) :-
    parental_verification_status_values(Values),
    member(efforts_reasonable, Values),
    member(efforts_not_reasonable, Values),
    member(not_applicable, Values),
    member(not_reached, Values).
test(consent_not_the_basis_is_not_engaged) :-
    child_consent_status([attribute(processing_rests_on_consent, false), attribute(information_society_service, true), attribute(offered_directly_to_child, true), attribute(child_age_years, 12), attribute(parental_consent_given, false)], eligible).
test(engaged_below_13_without_parent_is_ineligible) :-
    child_profile(12, false, Profile),
    child_consent_status(Profile, ineligible).
test(unmet_engagement_beats_absence) :-
    child_consent_status([attribute(processing_rests_on_consent, false)], eligible).
test(a_met_engagement_key_leaves_the_rest_absent) :-
    child_consent_status([attribute(processing_rests_on_consent, true)], indeterminate([information_society_service, offered_directly_to_child])).
test(unmet_engagement_beats_unsure) :-
    child_consent_status([attribute(processing_rests_on_consent, true), attribute(information_society_service, unsure), attribute(offered_directly_to_child, false)], eligible).
test(the_first_unsure_judgement_is_the_service) :-
    child_consent_status([attribute(processing_rests_on_consent, true), attribute(information_society_service, unsure), attribute(offered_directly_to_child, unsure)], needs_legal_review(open_textured(information_society_service, cite(eu_reg_2016_679_art_4_25)), _)).
test(the_direct_offer_is_referred_when_the_service_is_true) :-
    child_consent_status([attribute(processing_rests_on_consent, true), attribute(information_society_service, true), attribute(offered_directly_to_child, unsure)], needs_legal_review(open_textured(offered_directly_to_child, cite(eu_reg_2016_679_art_8_1)), _)).
test(an_absent_key_beats_an_unsure_judgement) :-
    child_consent_status([attribute(processing_rests_on_consent, true), attribute(information_society_service, unsure)], indeterminate([offered_directly_to_child])).
test(sixteen_is_eligible_by_own_consent) :-
    child_profile(16, false, Profile),
    child_consent_status(Profile, eligible).
test(fifteen_without_the_national_age_refers) :-
    absent_fact_profile(15, Profile),
    child_consent_status(Profile, needs_legal_review(cross_reference_unresolved(_, _), _)).
test(twelve_with_parent_is_eligible) :-
    child_profile(12, true, Profile),
    child_consent_status(Profile, eligible).
test(twelve_without_parent_is_ineligible) :-
    child_profile(12, false, Profile),
    child_consent_status(Profile, ineligible).
test(an_absent_parent_flag_is_indeterminate) :-
    engaged(Engaged),
    append(Engaged, [attribute(child_age_years, 12)], Profile),
    child_consent_status(Profile, indeterminate([parental_consent_given])).
test(thirteen_reaches_the_national_age) :-
    national_profile(13, 13, Profile),
    child_consent_status(Profile, eligible).
test(twelve_with_a_national_fact_is_ineligible) :-
    national_profile(12, 13, Profile),
    child_consent_status(Profile, ineligible).
test(age_15_national_15_is_eligible) :-
    national_profile(15, 15, Profile),
    child_consent_status(Profile, eligible).
test(age_15_national_16_is_ineligible) :-
    national_profile(15, 16, Profile),
    child_consent_status(Profile, ineligible).
test(age_14_national_14_is_eligible) :-
    national_profile(14, 14, Profile),
    child_consent_status(Profile, eligible).
test(age_14_national_15_is_ineligible) :-
    national_profile(14, 15, Profile),
    child_consent_status(Profile, ineligible).
test(parental_consent_at_14_ignores_a_high_national_age) :-
    child_profile(14, true, Base),
    context(france, Context),
    fact(france, 16, Fact),
    append(Base, [Fact|Context], Profile),
    child_consent_status(Profile, eligible).
test(no_parental_consent_at_14_with_a_high_national_age_is_ineligible) :-
    national_profile(14, 16, Profile),
    child_consent_status(Profile, ineligible).
test(an_absent_national_age_refers) :-
    absent_fact_profile(14, Profile),
    child_consent_status(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_8_1_second_subpara), cite(member_state_digital_consent_age_law)), [resolution(cite(member_state_digital_consent_age_law), not_attempted), inputs_relied_on(_Pairs)])).
test(another_states_age_refers) :-
    other_state_profile(14, Profile),
    child_consent_status(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_8_1_second_subpara), cite(member_state_digital_consent_age_law)), _)).
test(a_missing_member_state_is_named) :-
    child_profile(14, false, Base),
    append(Base, [attribute(member_state_selection_test, child_residence), attribute(consent_date, date(2026, 5, 1))], Profile),
    child_consent_status(Profile, indeterminate([member_state])).
test(all_three_missing_context_keys_are_named_in_order) :-
    child_profile(14, false, Profile),
    child_consent_status(Profile, indeterminate([member_state, member_state_selection_test, consent_date])).
test(reasonable_efforts) :-
    verification_profile(true, Profile),
    parental_verification(Profile, efforts_reasonable).
test(unreasonable_efforts) :-
    verification_profile(false, Profile),
    parental_verification(Profile, efforts_not_reasonable).
test(unreasonable_efforts_leave_the_status_eligible) :-
    verification_profile(false, Profile),
    child_consent_status(Profile, eligible).
test(unsure_efforts_refer) :-
    verification_profile(unsure, Profile),
    parental_verification(Profile, needs_legal_review(open_textured(verification_efforts_reasonable, cite(eu_reg_2016_679_art_8_2)), _)).
test(absent_efforts_are_indeterminate) :-
    child_profile(12, true, Profile),
    parental_verification(Profile, indeterminate([verification_efforts_reasonable])).
test(sixteen_needs_no_verification) :-
    child_profile(16, true, Base),
    append(Base, [attribute(verification_efforts_reasonable, false)], Profile),
    parental_verification(Profile, not_applicable).
test(fifteen_with_parent_needs_verification) :-
    child_profile(15, true, Base),
    append(Base, [attribute(verification_efforts_reasonable, false)], Profile),
    parental_verification(Profile, efforts_not_reasonable).
test(a_national_age_ground_needs_no_verification) :-
    national_profile(15, 15, Profile),
    parental_verification(Profile, not_applicable).
test(a_referral_status_is_not_reached) :-
    absent_fact_profile(14, Profile),
    parental_verification(Profile, not_reached).

test(consent_the_basis_engages_and_bars, fail) :-
    child_consent_status([attribute(processing_rests_on_consent, true), attribute(information_society_service, true), attribute(offered_directly_to_child, true), attribute(child_age_years, 12), attribute(parental_consent_given, false)], eligible).
test(unmet_engagement_with_unsure_is_not_a_referral, fail) :-
    child_consent_status([attribute(processing_rests_on_consent, true), attribute(information_society_service, unsure), attribute(offered_directly_to_child, false)], needs_legal_review(_, _)).
test(the_direct_offer_referral_is_not_about_the_service, fail) :-
    child_consent_status([attribute(processing_rests_on_consent, true), attribute(information_society_service, true), attribute(offered_directly_to_child, unsure)], needs_legal_review(open_textured(information_society_service, _), _)).
test(fifteen_without_parent_and_age_is_not_eligible_by_own_consent, fail) :-
    absent_fact_profile(15, Profile),
    child_consent_status(Profile, eligible).
test(twelve_without_parent_is_not_eligible, fail) :-
    child_profile(12, false, Profile),
    child_consent_status(Profile, eligible).
test(twelve_never_reaches_the_national_age, fail) :-
    national_profile(12, 13, Profile),
    child_consent_status(Profile, eligible).
test(age_15_national_16_is_not_eligible, fail) :-
    national_profile(15, 16, Profile),
    child_consent_status(Profile, eligible).
test(age_14_national_15_is_not_eligible, fail) :-
    national_profile(14, 15, Profile),
    child_consent_status(Profile, eligible).
test(no_parental_consent_at_14_reads_the_high_national_age, fail) :-
    national_profile(14, 16, Profile),
    child_consent_status(Profile, eligible).
test(an_absent_national_age_is_not_ineligible, fail) :-
    absent_fact_profile(14, Profile),
    child_consent_status(Profile, ineligible).
test(an_attested_national_age_resolves_the_referral, fail) :-
    national_profile(14, 14, Profile),
    child_consent_status(Profile, needs_legal_review(_, _)).
test(another_states_age_is_not_applied, fail) :-
    other_state_profile(14, Profile),
    child_consent_status(Profile, ineligible).
test(the_context_present_gives_a_referral_not_indeterminate, fail) :-
    absent_fact_profile(14, Profile),
    child_consent_status(Profile, indeterminate(_)).
test(unreasonable_efforts_are_not_reasonable_efforts, fail) :-
    verification_profile(false, Profile),
    parental_verification(Profile, efforts_reasonable).
test(a_referral_status_is_not_not_applicable, fail) :-
    absent_fact_profile(14, Profile),
    parental_verification(Profile, not_applicable).

cp_test_names([the_status_atoms_are_real, the_verification_atoms_are_real, consent_not_the_basis_is_not_engaged, engaged_below_13_without_parent_is_ineligible, unmet_engagement_beats_absence, a_met_engagement_key_leaves_the_rest_absent, unmet_engagement_beats_unsure, the_first_unsure_judgement_is_the_service, the_direct_offer_is_referred_when_the_service_is_true, an_absent_key_beats_an_unsure_judgement, sixteen_is_eligible_by_own_consent, fifteen_without_the_national_age_refers, twelve_with_parent_is_eligible, twelve_without_parent_is_ineligible, an_absent_parent_flag_is_indeterminate, thirteen_reaches_the_national_age, twelve_with_a_national_fact_is_ineligible, age_15_national_15_is_eligible, age_15_national_16_is_ineligible, age_14_national_14_is_eligible, age_14_national_15_is_ineligible, parental_consent_at_14_ignores_a_high_national_age, no_parental_consent_at_14_with_a_high_national_age_is_ineligible, an_absent_national_age_refers, another_states_age_refers, a_missing_member_state_is_named, all_three_missing_context_keys_are_named_in_order, reasonable_efforts, unreasonable_efforts, unreasonable_efforts_leave_the_status_eligible, unsure_efforts_refer, absent_efforts_are_indeterminate, sixteen_needs_no_verification, fifteen_with_parent_needs_verification, a_national_age_ground_needs_no_verification, a_referral_status_is_not_reached]).
cp_test_fail_names([consent_the_basis_engages_and_bars, unmet_engagement_with_unsure_is_not_a_referral, the_direct_offer_referral_is_not_about_the_service, fifteen_without_parent_and_age_is_not_eligible_by_own_consent, twelve_without_parent_is_not_eligible, twelve_never_reaches_the_national_age, age_15_national_16_is_not_eligible, age_14_national_15_is_not_eligible, no_parental_consent_at_14_reads_the_high_national_age, an_absent_national_age_is_not_ineligible, an_attested_national_age_resolves_the_referral, another_states_age_is_not_applied, the_context_present_gives_a_referral_not_indeterminate, unreasonable_efforts_are_not_reasonable_efforts, a_referral_status_is_not_not_applicable]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
