% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_5_2_data_combination_order_queries, [dma_art_5_2_data_combination_order_profile_keys/1, dma_art_5_2_data_combination_order_what_if/4, article_5_obligations_apply/0, article_5_obligations_do_not_apply/0, practice_allowed_with_consent/0, practice_allowed_on_other_legal_basis/0, practice_prohibited/0, practice_outside_article_5_2/0, repeated_request_permitted/0, repeated_request_not_permitted/0, request_after_one_year_period/0, designated_as_gatekeeper_for_core_platform_service/0, practice_under_article_5_2/0, end_user_presented_with_specific_choice/0, end_user_consent_given/0, gatekeeper_may_rely_on_article_6_1_c_d_or_e/0, consent_request_already_repeated_in_period/0, processing_for_online_advertising_services/0, combining_personal_data/0, cross_using_personal_data/0, signing_in_end_users_to_combine_personal_data/0, none_of_the_four_practices/0, unsure/0, absent/0, not_attempted/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_5_2_data_combination_order_kernel, [dma_art_5_2_data_combination_order_input_problems/2]).
:- use_module(m__eu_dma_art_5_2_data_combination_order_dma_art_5_2_data_combination_order, [dma_art_5_2_data_combination_order_status/2]).

dma_art_5_2_data_combination_order_profile_keys([designated_as_gatekeeper_for_core_platform_service, practice_under_article_5_2, end_user_presented_with_specific_choice, end_user_consent_given, gatekeeper_may_rely_on_article_6_1_c_d_or_e, consent_request_already_repeated_in_period]).

article_5_obligations_apply.

article_5_obligations_do_not_apply.

practice_allowed_with_consent.

practice_allowed_on_other_legal_basis.

practice_prohibited.

practice_outside_article_5_2.

repeated_request_permitted.

repeated_request_not_permitted.

request_after_one_year_period.

designated_as_gatekeeper_for_core_platform_service.

practice_under_article_5_2.

end_user_presented_with_specific_choice.

end_user_consent_given.

gatekeeper_may_rely_on_article_6_1_c_d_or_e.

consent_request_already_repeated_in_period.

processing_for_online_advertising_services.

combining_personal_data.

cross_using_personal_data.

signing_in_end_users_to_combine_personal_data.

none_of_the_four_practices.

unsure.

absent.

not_attempted.

dma_art_5_2_data_combination_order_what_if(Profile, OverriddenKey, NewValue, NewStatus) :-
    attribute_override(Profile, OverriddenKey, NewValue, Hypothesis),
    dma_art_5_2_data_combination_order_status(Hypothesis, NewStatus).

attribute_override(Profile, OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)]) :-
    Profile == [].
attribute_override(Profile, OverriddenKey, NewValue, [attribute(OverriddenKey, NewValue)|Rest]) :-
    nonvar(Profile),
    Profile = [attribute(ElementKey, _)|Rest],
    ElementKey == OverriddenKey.
attribute_override(Profile, OverriddenKey, NewValue, [attribute(ElementKey, ElementValue)|Hypothesis]) :-
    nonvar(Profile),
    Profile = [attribute(ElementKey, ElementValue)|Rest],
    ElementKey \== OverriddenKey,
    attribute_override(Rest, OverriddenKey, NewValue, Hypothesis).

test(override_replaces_a_present_key) :-
    attribute_override([attribute(practice_under_article_5_2, unsure)], practice_under_article_5_2, combining_personal_data, Hypothesis),
    Hypothesis == [attribute(practice_under_article_5_2, combining_personal_data)].
test(override_adds_an_absent_key) :-
    attribute_override([attribute(end_user_presented_with_specific_choice, true)], practice_under_article_5_2, combining_personal_data, Hypothesis),
    Hypothesis == [attribute(end_user_presented_with_specific_choice, true), attribute(practice_under_article_5_2, combining_personal_data)].
test(what_if_moves_the_status) :-
    dma_art_5_2_data_combination_order_what_if([], practice_under_article_5_2, none_of_the_four_practices, Status),
    Status == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_5_1), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent, practice_under_article_5_2 - none_of_the_four_practices])]).
test(profile_keys_are_the_six) :-
    dma_art_5_2_data_combination_order_profile_keys(Keys),
    length(Keys, 6).
test(the_root_atoms_are_served) :-
    article_5_obligations_apply,
    practice_prohibited,
    request_after_one_year_period,
    consent_request_already_repeated_in_period,
    none_of_the_four_practices,
    unsure,
    absent,
    not_attempted.

test(what_if_on_a_non_list_has_no_answer, fail) :-
    dma_art_5_2_data_combination_order_what_if(nothing, practice_under_article_5_2, unsure, _).
