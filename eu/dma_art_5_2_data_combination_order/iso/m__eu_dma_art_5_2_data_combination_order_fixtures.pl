% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_5_2_data_combination_order_fixtures, [dma_art_5_2_data_combination_order_subject/1, dma_art_5_2_data_combination_order_profile_for/2, dma_art_5_2_data_combination_order_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_5_2_data_combination_order_dma_art_5_2_data_combination_order, [decide_dma_art_5_2_data_combination_order/2]).

dma_art_5_2_data_combination_order_subject(listed_combining_with_consent).
dma_art_5_2_data_combination_order_subject(listed_combining_consent_refused_control).
dma_art_5_2_data_combination_order_subject(listed_cross_use_no_choice_legal_obligation).
dma_art_5_2_data_combination_order_subject(listed_cross_use_no_choice_no_basis_control).
dma_art_5_2_data_combination_order_subject(listed_sign_in_consent_refused_no_basis).
dma_art_5_2_data_combination_order_subject(listed_sign_in_consent_given_control).
dma_art_5_2_data_combination_order_subject(listed_none_of_the_four).
dma_art_5_2_data_combination_order_subject(listed_advertising_with_consent_control).
dma_art_5_2_data_combination_order_subject(not_listed_everything_unsure).
dma_art_5_2_data_combination_order_subject(listed_everything_unsure_control).
dma_art_5_2_data_combination_order_subject(practice_missing).
dma_art_5_2_data_combination_order_subject(choice_missing).
dma_art_5_2_data_combination_order_subject(choice_missing_consent_refused_basis_true).
dma_art_5_2_data_combination_order_subject(designation_absent_complete).
dma_art_5_2_data_combination_order_subject(consent_absent).
dma_art_5_2_data_combination_order_subject(consent_absent_choice_false_control).
dma_art_5_2_data_combination_order_subject(basis_absent).
dma_art_5_2_data_combination_order_subject(basis_given_control).
dma_art_5_2_data_combination_order_subject(practice_unsure_complete).
dma_art_5_2_data_combination_order_subject(choice_unsure_consent_true).
dma_art_5_2_data_combination_order_subject(duplicate_and_unknown_keys).
dma_art_5_2_data_combination_order_subject(unbound_attestation_reason).
dma_art_5_2_data_combination_order_subject(partial_list_profile).
dma_art_5_2_data_combination_order_subject(repeat_listed_not_yet_repeated).
dma_art_5_2_data_combination_order_subject(repeat_listed_already_repeated).
dma_art_5_2_data_combination_order_subject(repeat_not_listed).
dma_art_5_2_data_combination_order_subject(repeat_designation_absent).

stated(Truth, attested(Truth, attestation(host_operator, attested_on_2026_11_19, caller_statement, none))).

dma_art_5_2_data_combination_order_profile_for(listed_combining_with_consent, Profile) :-
    stated(true, Designation),
    stated(true, Consent),
    stated(false, OtherBasis),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, combining_personal_data), attribute(end_user_presented_with_specific_choice, true), attribute(end_user_consent_given, Consent), attribute(gatekeeper_may_rely_on_article_6_1_c_d_or_e, OtherBasis)].
dma_art_5_2_data_combination_order_profile_for(listed_combining_consent_refused_control, Profile) :-
    stated(true, Designation),
    stated(false, Consent),
    stated(false, OtherBasis),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, combining_personal_data), attribute(end_user_presented_with_specific_choice, true), attribute(end_user_consent_given, Consent), attribute(gatekeeper_may_rely_on_article_6_1_c_d_or_e, OtherBasis)].
dma_art_5_2_data_combination_order_profile_for(listed_cross_use_no_choice_legal_obligation, Profile) :-
    stated(true, Designation),
    stated(true, OtherBasis),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, cross_using_personal_data), attribute(end_user_presented_with_specific_choice, false), attribute(gatekeeper_may_rely_on_article_6_1_c_d_or_e, OtherBasis)].
dma_art_5_2_data_combination_order_profile_for(listed_cross_use_no_choice_no_basis_control, Profile) :-
    stated(true, Designation),
    stated(false, OtherBasis),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, cross_using_personal_data), attribute(end_user_presented_with_specific_choice, false), attribute(gatekeeper_may_rely_on_article_6_1_c_d_or_e, OtherBasis)].
dma_art_5_2_data_combination_order_profile_for(listed_sign_in_consent_refused_no_basis, Profile) :-
    stated(true, Designation),
    stated(false, Consent),
    stated(false, OtherBasis),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, signing_in_end_users_to_combine_personal_data), attribute(end_user_presented_with_specific_choice, true), attribute(end_user_consent_given, Consent), attribute(gatekeeper_may_rely_on_article_6_1_c_d_or_e, OtherBasis)].
dma_art_5_2_data_combination_order_profile_for(listed_sign_in_consent_given_control, Profile) :-
    stated(true, Designation),
    stated(true, Consent),
    stated(false, OtherBasis),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, signing_in_end_users_to_combine_personal_data), attribute(end_user_presented_with_specific_choice, true), attribute(end_user_consent_given, Consent), attribute(gatekeeper_may_rely_on_article_6_1_c_d_or_e, OtherBasis)].
dma_art_5_2_data_combination_order_profile_for(listed_none_of_the_four, Profile) :-
    stated(true, Designation),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, none_of_the_four_practices)].
dma_art_5_2_data_combination_order_profile_for(listed_advertising_with_consent_control, Profile) :-
    stated(true, Designation),
    stated(true, Consent),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, processing_for_online_advertising_services), attribute(end_user_presented_with_specific_choice, true), attribute(end_user_consent_given, Consent)].
dma_art_5_2_data_combination_order_profile_for(not_listed_everything_unsure, Profile) :-
    stated(false, Designation),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, unsure), attribute(end_user_presented_with_specific_choice, unsure)].
dma_art_5_2_data_combination_order_profile_for(listed_everything_unsure_control, Profile) :-
    stated(true, Designation),
    stated(true, Consent),
    stated(true, OtherBasis),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, unsure), attribute(end_user_presented_with_specific_choice, unsure), attribute(end_user_consent_given, Consent), attribute(gatekeeper_may_rely_on_article_6_1_c_d_or_e, OtherBasis)].
dma_art_5_2_data_combination_order_profile_for(practice_missing, Profile) :-
    stated(true, Designation),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation)].
dma_art_5_2_data_combination_order_profile_for(choice_missing, Profile) :-
    stated(true, Designation),
    stated(true, Consent),
    stated(true, OtherBasis),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, combining_personal_data), attribute(end_user_consent_given, Consent), attribute(gatekeeper_may_rely_on_article_6_1_c_d_or_e, OtherBasis)].
dma_art_5_2_data_combination_order_profile_for(choice_missing_consent_refused_basis_true, Profile) :-
    stated(true, Designation),
    stated(false, Consent),
    stated(true, OtherBasis),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, combining_personal_data), attribute(end_user_consent_given, Consent), attribute(gatekeeper_may_rely_on_article_6_1_c_d_or_e, OtherBasis)].
dma_art_5_2_data_combination_order_profile_for(designation_absent_complete, Profile) :-
    stated(true, Consent),
    stated(true, OtherBasis),
    Profile = [attribute(practice_under_article_5_2, combining_personal_data), attribute(end_user_presented_with_specific_choice, true), attribute(end_user_consent_given, Consent), attribute(gatekeeper_may_rely_on_article_6_1_c_d_or_e, OtherBasis)].
dma_art_5_2_data_combination_order_profile_for(consent_absent, Profile) :-
    stated(true, Designation),
    stated(false, OtherBasis),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, combining_personal_data), attribute(end_user_presented_with_specific_choice, true), attribute(gatekeeper_may_rely_on_article_6_1_c_d_or_e, OtherBasis)].
dma_art_5_2_data_combination_order_profile_for(consent_absent_choice_false_control, Profile) :-
    stated(true, Designation),
    stated(false, OtherBasis),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, combining_personal_data), attribute(end_user_presented_with_specific_choice, false), attribute(gatekeeper_may_rely_on_article_6_1_c_d_or_e, OtherBasis)].
dma_art_5_2_data_combination_order_profile_for(basis_absent, Profile) :-
    stated(true, Designation),
    stated(false, Consent),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, combining_personal_data), attribute(end_user_presented_with_specific_choice, false), attribute(end_user_consent_given, Consent)].
dma_art_5_2_data_combination_order_profile_for(basis_given_control, Profile) :-
    stated(true, Designation),
    stated(false, Consent),
    stated(true, OtherBasis),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, combining_personal_data), attribute(end_user_presented_with_specific_choice, false), attribute(end_user_consent_given, Consent), attribute(gatekeeper_may_rely_on_article_6_1_c_d_or_e, OtherBasis)].
dma_art_5_2_data_combination_order_profile_for(practice_unsure_complete, Profile) :-
    stated(true, Designation),
    stated(true, Consent),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, unsure), attribute(end_user_presented_with_specific_choice, true), attribute(end_user_consent_given, Consent)].
dma_art_5_2_data_combination_order_profile_for(choice_unsure_consent_true, Profile) :-
    stated(true, Designation),
    stated(true, Consent),
    stated(false, OtherBasis),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, combining_personal_data), attribute(end_user_presented_with_specific_choice, unsure), attribute(end_user_consent_given, Consent), attribute(gatekeeper_may_rely_on_article_6_1_c_d_or_e, OtherBasis)].
dma_art_5_2_data_combination_order_profile_for(duplicate_and_unknown_keys, Profile) :-
    Profile = [attribute(practice_under_article_5_2, combining_personal_data), attribute(practice_under_article_5_2, none_of_the_four_practices), attribute(colour, red)].
dma_art_5_2_data_combination_order_profile_for(unbound_attestation_reason, Profile) :-
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, attested(true, attestation(host_operator, attested_on_2026_11_19, _UnstatedReason, none)))].
dma_art_5_2_data_combination_order_profile_for(partial_list_profile, Profile) :-
    stated(true, Designation),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation)|_OpenTail].
dma_art_5_2_data_combination_order_profile_for(repeat_listed_not_yet_repeated, Profile) :-
    stated(true, Designation),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(consent_request_already_repeated_in_period, false)].
dma_art_5_2_data_combination_order_profile_for(repeat_listed_already_repeated, Profile) :-
    stated(true, Designation),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(consent_request_already_repeated_in_period, true)].
dma_art_5_2_data_combination_order_profile_for(repeat_not_listed, Profile) :-
    stated(false, Designation),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(consent_request_already_repeated_in_period, false)].
dma_art_5_2_data_combination_order_profile_for(repeat_designation_absent, Profile) :-
    Profile = [attribute(consent_request_already_repeated_in_period, false)].

dma_art_5_2_data_combination_order_assess(Subject, Result) :-
    dma_art_5_2_data_combination_order_profile_for(Subject, Profile),
    decide_dma_art_5_2_data_combination_order(Profile, Result).
