% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_6_9_10_portability_and_business_data_order_dma_art_6_9_10_portability_and_business_data_order, [article_6_application_status/4, end_user_data_portability_status/4, business_user_data_access_status/4, decide_dma_art_6_9_10_portability_and_business_data_order/2, dma_art_6_9_10_portability_and_business_data_order_status/2, dma_art_6_9_10_portability_and_business_data_order_checklist/2, dma_art_6_9_10_portability_and_business_data_order_decision_resolvable/1, dma_art_6_9_10_portability_and_business_data_order_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [(=)/3]).
:- use_module(clausal_lists_extra, [min_list/2]).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_kernel, [dma_art_6_9_10_portability_and_business_data_order_input_problems/2]).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_citations, [implements/1]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(library(reif), [if_/3, memberd_t/3]).

dma_art_6_9_10_portability_and_business_data_order_status_values([article_6_obligations_apply, article_6_obligations_do_not_apply, portability_duty_met, portability_duty_not_met, portability_not_requested, data_outside_article_6_9, data_access_duty_met, data_access_duty_not_met, personal_data_access_duty_met, personal_data_access_duty_not_met, personal_data_access_not_required, data_access_not_requested, data_outside_article_6_10]).

final_result_citations(article_6_obligations_apply, [cite(eu_reg_2022_1925_art_6_1)]).
final_result_citations(article_6_obligations_do_not_apply, [cite(eu_reg_2022_1925_art_6_1)]).
final_result_citations(portability_not_requested, [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_9)]).
final_result_citations(data_outside_article_6_9, [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_9)]).
final_result_citations(portability_duty_met, [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_9)]).
final_result_citations(portability_duty_not_met, [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_9)]).
final_result_citations(data_access_not_requested, [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10)]).
final_result_citations(data_outside_article_6_10, [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10)]).
final_result_citations(data_access_duty_met, [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10)]).
final_result_citations(data_access_duty_not_met, [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10)]).
final_result_citations(personal_data_access_not_required, [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10), cite(eu_reg_2022_1925_art_2_25), cite(eu_reg_2022_1925_art_2_32)]).
final_result_citations(personal_data_access_duty_met, [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10), cite(eu_reg_2022_1925_art_2_25), cite(eu_reg_2022_1925_art_2_32)]).
final_result_citations(personal_data_access_duty_not_met, [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10), cite(eu_reg_2022_1925_art_2_25), cite(eu_reg_2022_1925_art_2_32)]).

question_provisions(article_6_application, [cite(eu_reg_2022_1925_art_6_1)]).
question_provisions(end_user_data_portability, [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_9)]).
question_provisions(business_user_data_access, [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10), cite(eu_reg_2022_1925_art_2_25), cite(eu_reg_2022_1925_art_2_32)]).

portability_referral_keys([portability_requested_by_end_user_or_authorised_third_party, data_provided_by_or_generated_through_activity_of_end_user, end_user_data_portability_free_of_charge, end_user_data_portability_effective, end_user_data_portability_tools_provided, end_user_data_continuous_real_time_access_provided]).

business_referral_keys_before_consent([data_access_requested_by_business_user_or_authorised_third_party, data_provided_or_generated_in_use_by_business_user_and_its_end_users, requested_business_user_data_are_personal_data, personal_data_directly_connected_with_end_user_use_of_business_user_offer]).

business_referral_keys_after_consent([business_user_data_access_free_of_charge, business_user_data_access_and_use_effective_and_high_quality, business_user_data_access_continuous_and_real_time]).

key_state(Profile, ProfileKey, State) :-
    profile_has(Profile, ProfileKey),
    profile_get(Profile, ProfileKey, State).
key_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).

present_pairs([], [], []).
present_pairs([_|ProfileKeys], [absent|States], Pairs) :-
    present_pairs(ProfileKeys, States, Pairs).
present_pairs([ProfileKey|ProfileKeys], [State|States], [ProfileKey - State|Pairs]) :-
    dif(State, absent),
    present_pairs(ProfileKeys, States, Pairs).

first_key_with(Wanted, [ProfileKey|ProfileKeys], [State|States], FoundKey) :-
    if_(State = Wanted, FoundKey = ProfileKey, first_key_with(Wanted, ProfileKeys, States, FoundKey)).

truth_or(true, _, true).
truth_or(false, Truth, Truth).

outcome_answer(final(Result, Basis), Result, Basis, Citations) :-
    final_result_citations(Result, Citations).
outcome_answer(pending(Status), Status, [], []).

article_6_application_status(Profile, Result, Basis, Citations) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems(Profile, Problems),
    application_answer(Problems, Profile, Result, Basis, Citations).

application_answer([], Profile, Result, Basis, Citations) :-
    key_state(Profile, designated_as_gatekeeper_for_core_platform_service, Designation),
    application_outcome(Designation, Outcome),
    outcome_answer(Outcome, Result, Basis, Citations).
application_answer([Problem|Problems], _, input_problems([Problem|Problems]), [], []).

application_outcome(attested(true, Attestation), final(article_6_obligations_apply, [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, Attestation))])) :-
    implements(eu_reg_2022_1925_art_6_1).
application_outcome(attested(false, Attestation), final(article_6_obligations_do_not_apply, [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(false, Attestation))])) :-
    implements(eu_reg_2022_1925_art_6_1).
application_outcome(absent, pending(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_1), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent])]))) :-
    implements(eu_reg_2022_1925_art_6_1).

end_user_data_portability_status(Profile, Result, Basis, Citations) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems(Profile, Problems),
    portability_answer(Problems, Profile, Result, Basis, Citations).

portability_answer([], Profile, Result, Basis, Citations) :-
    portability_profile_states(Profile, States),
    portability_outcome(States, Outcome),
    outcome_answer(Outcome, Result, Basis, Citations).
portability_answer([Problem|Problems], _, input_problems([Problem|Problems]), [], []).

portability_profile_states(Profile, portability_states(Designation, Request, Scope, FreeOfCharge, Effective, Tools, Continuous)) :-
    key_state(Profile, designated_as_gatekeeper_for_core_platform_service, Designation),
    key_state(Profile, portability_requested_by_end_user_or_authorised_third_party, Request),
    key_state(Profile, data_provided_by_or_generated_through_activity_of_end_user, Scope),
    key_state(Profile, end_user_data_portability_free_of_charge, FreeOfCharge),
    key_state(Profile, end_user_data_portability_effective, Effective),
    key_state(Profile, end_user_data_portability_tools_provided, Tools),
    key_state(Profile, end_user_data_continuous_real_time_access_provided, Continuous).

portability_outcome(States, Outcome) :-
    findall(StepNumber, portability_step(States, StepNumber, _), StepNumbers),
    min_list(StepNumbers, FirstStepNumber),
    portability_step(States, FirstStepNumber, Outcome).

portability_elements_hold(FreeOfCharge, Effective, Tools, Continuous) :-
    implements(eu_reg_2022_1925_art_6_9),
    maplist(=(true), [FreeOfCharge, Effective, Tools, Continuous]).

portability_element_fails_t(FreeOfCharge, Effective, Tools, Continuous, Truth) :-
    implements(eu_reg_2022_1925_art_6_9),
    memberd_t(false, [FreeOfCharge, Effective, Tools, Continuous], Truth).

portability_present_pairs(portability_states(_, Request, Scope, FreeOfCharge, Effective, Tools, Continuous), Pairs) :-
    portability_referral_keys(ReferralKeys),
    present_pairs(ReferralKeys, [Request, Scope, FreeOfCharge, Effective, Tools, Continuous], Pairs).

portability_step(portability_states(attested(false, Attestation), _, _, _, _, _, _), 4, final(article_6_obligations_do_not_apply, [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(false, Attestation))])) :-
    implements(eu_reg_2022_1925_art_6_1).
portability_step(portability_states(attested(true, Attestation), false, _, _, _, _, _), 5, final(portability_not_requested, [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, Attestation))])) :-
    implements(eu_reg_2022_1925_art_6_9).
portability_step(portability_states(attested(true, Attestation), true, false, _, _, _, _), 6, final(data_outside_article_6_9, [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, Attestation))])) :-
    implements(eu_reg_2022_1925_art_6_9).
portability_step(portability_states(attested(true, Attestation), true, true, FreeOfCharge, Effective, Tools, Continuous), 7, final(portability_duty_met, [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, Attestation))])) :-
    implements(eu_reg_2022_1925_art_6_9),
    portability_elements_hold(FreeOfCharge, Effective, Tools, Continuous).
portability_step(portability_states(attested(true, Attestation), true, true, FreeOfCharge, Effective, Tools, Continuous), 8, final(portability_duty_not_met, [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, Attestation))])) :-
    implements(eu_reg_2022_1925_art_6_9),
    portability_element_fails_t(FreeOfCharge, Effective, Tools, Continuous, true).
portability_step(portability_states(_, absent, _, _, _, _, _), 9, pending(indeterminate([portability_requested_by_end_user_or_authorised_third_party]))) :-
    implements(eu_reg_2022_1925_art_6_9).
portability_step(portability_states(_, true, absent, _, _, _, _), 10, pending(indeterminate([data_provided_by_or_generated_through_activity_of_end_user]))) :-
    implements(eu_reg_2022_1925_art_6_9).
portability_step(portability_states(_, true, Scope, FreeOfCharge, Effective, Tools, Continuous), 11, pending(indeterminate([MissingKey]))) :-
    implements(eu_reg_2022_1925_art_6_9),
    dif(Scope, false),
    portability_element_fails_t(FreeOfCharge, Effective, Tools, Continuous, false),
    first_key_with(absent, [end_user_data_portability_free_of_charge, end_user_data_portability_effective, end_user_data_portability_tools_provided, end_user_data_continuous_real_time_access_provided], [FreeOfCharge, Effective, Tools, Continuous], MissingKey).
portability_step(States, 12, pending(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_1), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent|Pairs])]))) :-
    implements(eu_reg_2022_1925_art_6_1),
    States = portability_states(absent, _, _, _, _, _, _),
    portability_present_pairs(States, Pairs).
portability_step(States, 13, pending(needs_legal_review(open_textured(data_provided_by_or_generated_through_activity_of_end_user, cite(eu_reg_2022_1925_art_6_9)), [inputs_relied_on(Pairs)]))) :-
    implements(eu_reg_2022_1925_art_6_9),
    States = portability_states(_, _, unsure, _, _, _, _),
    portability_present_pairs(States, Pairs).
portability_step(States, 14, pending(needs_legal_review(open_textured(UnsureKey, cite(eu_reg_2022_1925_art_6_9)), [inputs_relied_on(Pairs)]))) :-
    implements(eu_reg_2022_1925_art_6_9),
    States = portability_states(_, _, _, _, Effective, Tools, Continuous),
    first_key_with(unsure, [end_user_data_portability_effective, end_user_data_portability_tools_provided, end_user_data_continuous_real_time_access_provided], [Effective, Tools, Continuous], UnsureKey),
    portability_present_pairs(States, Pairs).

business_user_data_access_status(Profile, Result, Basis, Citations) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems(Profile, Problems),
    business_answer(Problems, Profile, Result, Basis, Citations).

business_answer([], Profile, Result, Basis, Citations) :-
    business_profile_states(Profile, States),
    business_outcome(States, Outcome),
    outcome_answer(Outcome, Result, Basis, Citations).
business_answer([Problem|Problems], _, input_problems([Problem|Problems]), [], []).

business_profile_states(Profile, business_states(Designation, Request, Scope, Personal, Connected, Consent, FreeOfCharge, Effective, Continuous)) :-
    key_state(Profile, designated_as_gatekeeper_for_core_platform_service, Designation),
    key_state(Profile, data_access_requested_by_business_user_or_authorised_third_party, Request),
    key_state(Profile, data_provided_or_generated_in_use_by_business_user_and_its_end_users, Scope),
    key_state(Profile, requested_business_user_data_are_personal_data, Personal),
    key_state(Profile, personal_data_directly_connected_with_end_user_use_of_business_user_offer, Connected),
    key_state(Profile, end_users_opted_in_to_sharing_by_consent, Consent),
    key_state(Profile, business_user_data_access_free_of_charge, FreeOfCharge),
    key_state(Profile, business_user_data_access_and_use_effective_and_high_quality, Effective),
    key_state(Profile, business_user_data_access_continuous_and_real_time, Continuous).

business_outcome(States, Outcome) :-
    findall(StepNumber, business_step(States, StepNumber, _), StepNumbers),
    min_list(StepNumbers, FirstStepNumber),
    business_step(States, FirstStepNumber, Outcome).

business_elements_hold(FreeOfCharge, Effective, Continuous) :-
    implements(eu_reg_2022_1925_art_6_10),
    maplist(=(true), [FreeOfCharge, Effective, Continuous]).

business_element_fails_t(FreeOfCharge, Effective, Continuous, Truth) :-
    implements(eu_reg_2022_1925_art_6_10),
    memberd_t(false, [FreeOfCharge, Effective, Continuous], Truth).

consent_attested_false_t(attested(false, _), true) :-
    implements(eu_reg_2022_1925_art_2_32).
consent_attested_false_t(attested(true, _), false) :-
    implements(eu_reg_2022_1925_art_2_32).
consent_attested_false_t(absent, false) :-
    implements(eu_reg_2022_1925_art_2_32).

personal_data_condition_fails_t(Connected, Consent, Truth) :-
    implements(eu_reg_2022_1925_art_6_10),
    memberd_t(Connected, [false], ConnectionFails),
    consent_attested_false_t(Consent, ConsentFails),
    truth_or(ConnectionFails, ConsentFails, Truth).

personal_data_conditions_hold(true, attested(true, _)) :-
    implements(eu_reg_2022_1925_art_6_10).

personal_data_excluded_t(true, Connected, Consent, Truth) :-
    implements(eu_reg_2022_1925_art_2_25),
    personal_data_condition_fails_t(Connected, Consent, Truth).
personal_data_excluded_t(Personal, _, _, false) :-
    implements(eu_reg_2022_1925_art_2_25),
    dif(Personal, true).

business_present_pairs(business_states(_, Request, Scope, Personal, Connected, _, FreeOfCharge, Effective, Continuous), PairsBeforeConsent, PairsAfterConsent) :-
    business_referral_keys_before_consent(KeysBeforeConsent),
    business_referral_keys_after_consent(KeysAfterConsent),
    present_pairs(KeysBeforeConsent, [Request, Scope, Personal, Connected], PairsBeforeConsent),
    present_pairs(KeysAfterConsent, [FreeOfCharge, Effective, Continuous], PairsAfterConsent).

business_step(business_states(attested(false, Attestation), _, _, _, _, _, _, _, _), 15, final(article_6_obligations_do_not_apply, [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(false, Attestation))])) :-
    implements(eu_reg_2022_1925_art_6_1).
business_step(business_states(attested(true, Attestation), false, _, _, _, _, _, _, _), 16, final(data_access_not_requested, [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, Attestation))])) :-
    implements(eu_reg_2022_1925_art_6_10).
business_step(business_states(attested(true, Attestation), true, false, _, _, _, _, _, _), 17, final(data_outside_article_6_10, [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, Attestation))])) :-
    implements(eu_reg_2022_1925_art_6_10).
business_step(business_states(attested(true, Attestation), true, true, true, Connected, Consent, _, _, _), 18, final(personal_data_access_not_required, [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, Attestation))])) :-
    implements(eu_reg_2022_1925_art_6_10),
    implements(eu_reg_2022_1925_art_2_25),
    personal_data_condition_fails_t(Connected, Consent, true).
business_step(business_states(attested(true, Attestation), true, true, true, Connected, attested(true, ConsentAttestation), FreeOfCharge, Effective, Continuous), 19, final(personal_data_access_duty_met, [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, Attestation)), outside_fact(end_users_opted_in_to_sharing_by_consent, attested(true, ConsentAttestation))])) :-
    implements(eu_reg_2022_1925_art_6_10),
    implements(eu_reg_2022_1925_art_2_32),
    personal_data_conditions_hold(Connected, attested(true, ConsentAttestation)),
    business_elements_hold(FreeOfCharge, Effective, Continuous).
business_step(business_states(attested(true, Attestation), true, true, true, Connected, attested(true, ConsentAttestation), FreeOfCharge, Effective, Continuous), 20, final(personal_data_access_duty_not_met, [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, Attestation)), outside_fact(end_users_opted_in_to_sharing_by_consent, attested(true, ConsentAttestation))])) :-
    implements(eu_reg_2022_1925_art_6_10),
    implements(eu_reg_2022_1925_art_2_32),
    personal_data_conditions_hold(Connected, attested(true, ConsentAttestation)),
    business_element_fails_t(FreeOfCharge, Effective, Continuous, true).
business_step(business_states(attested(true, Attestation), true, true, false, _, _, FreeOfCharge, Effective, Continuous), 21, final(data_access_duty_met, [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, Attestation))])) :-
    implements(eu_reg_2022_1925_art_6_10),
    business_elements_hold(FreeOfCharge, Effective, Continuous).
business_step(business_states(attested(true, Attestation), true, true, false, _, _, FreeOfCharge, Effective, Continuous), 22, final(data_access_duty_not_met, [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, Attestation))])) :-
    implements(eu_reg_2022_1925_art_6_10),
    business_element_fails_t(FreeOfCharge, Effective, Continuous, true).
business_step(business_states(_, absent, _, _, _, _, _, _, _), 23, pending(indeterminate([data_access_requested_by_business_user_or_authorised_third_party]))) :-
    implements(eu_reg_2022_1925_art_6_10).
business_step(business_states(_, true, absent, _, _, _, _, _, _), 24, pending(indeterminate([data_provided_or_generated_in_use_by_business_user_and_its_end_users]))) :-
    implements(eu_reg_2022_1925_art_6_10).
business_step(business_states(_, true, Scope, absent, _, _, _, _, _), 25, pending(indeterminate([requested_business_user_data_are_personal_data]))) :-
    implements(eu_reg_2022_1925_art_2_25),
    dif(Scope, false).
business_step(business_states(_, true, Scope, Personal, absent, Consent, _, _, _), 26, pending(indeterminate([personal_data_directly_connected_with_end_user_use_of_business_user_offer]))) :-
    implements(eu_reg_2022_1925_art_6_10),
    dif(Scope, false),
    dif(Personal, false),
    consent_attested_false_t(Consent, false).
business_step(business_states(_, true, Scope, Personal, Connected, Consent, FreeOfCharge, Effective, Continuous), 27, pending(indeterminate([MissingKey]))) :-
    implements(eu_reg_2022_1925_art_6_10),
    dif(Scope, false),
    business_element_fails_t(FreeOfCharge, Effective, Continuous, false),
    personal_data_excluded_t(Personal, Connected, Consent, false),
    first_key_with(absent, [business_user_data_access_free_of_charge, business_user_data_access_and_use_effective_and_high_quality, business_user_data_access_continuous_and_real_time], [FreeOfCharge, Effective, Continuous], MissingKey).
business_step(States, 28, pending(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_1), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent|Pairs])]))) :-
    implements(eu_reg_2022_1925_art_6_1),
    States = business_states(absent, _, _, _, _, _, _, _, _),
    business_present_pairs(States, PairsBeforeConsent, PairsAfterConsent),
    append(PairsBeforeConsent, PairsAfterConsent, Pairs).
business_step(States, 29, pending(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_10), cite(digital_markets_business_user_data_sharing_consent_statement)), [resolution(cite(digital_markets_business_user_data_sharing_consent_statement), not_attempted), inputs_relied_on(Pairs)]))) :-
    implements(eu_reg_2022_1925_art_2_32),
    States = business_states(_, _, _, Personal, Connected, absent, _, _, _),
    dif(Personal, false),
    dif(Connected, false),
    business_present_pairs(States, PairsBeforeConsent, PairsAfterConsent),
    append(PairsBeforeConsent, [end_users_opted_in_to_sharing_by_consent - absent|PairsAfterConsent], Pairs).
business_step(States, 30, pending(needs_legal_review(open_textured(data_provided_or_generated_in_use_by_business_user_and_its_end_users, cite(eu_reg_2022_1925_art_6_10)), [inputs_relied_on(Pairs)]))) :-
    implements(eu_reg_2022_1925_art_6_10),
    States = business_states(_, _, unsure, _, _, _, _, _, _),
    business_present_pairs(States, PairsBeforeConsent, PairsAfterConsent),
    append(PairsBeforeConsent, PairsAfterConsent, Pairs).
business_step(States, 31, pending(needs_legal_review(open_textured(requested_business_user_data_are_personal_data, cite(eu_reg_2022_1925_art_6_10)), [inputs_relied_on(Pairs)]))) :-
    implements(eu_reg_2022_1925_art_2_25),
    States = business_states(_, _, _, unsure, _, _, _, _, _),
    business_present_pairs(States, PairsBeforeConsent, PairsAfterConsent),
    append(PairsBeforeConsent, PairsAfterConsent, Pairs).
business_step(States, 32, pending(needs_legal_review(open_textured(personal_data_directly_connected_with_end_user_use_of_business_user_offer, cite(eu_reg_2022_1925_art_6_10)), [inputs_relied_on(Pairs)]))) :-
    implements(eu_reg_2022_1925_art_6_10),
    States = business_states(_, _, _, true, unsure, attested(true, _), _, _, _),
    business_present_pairs(States, PairsBeforeConsent, PairsAfterConsent),
    append(PairsBeforeConsent, PairsAfterConsent, Pairs).
business_step(States, 33, pending(needs_legal_review(open_textured(UnsureKey, cite(eu_reg_2022_1925_art_6_10)), [inputs_relied_on(Pairs)]))) :-
    implements(eu_reg_2022_1925_art_6_10),
    States = business_states(_, _, _, _, _, _, _, Effective, Continuous),
    first_key_with(unsure, [business_user_data_access_and_use_effective_and_high_quality, business_user_data_access_continuous_and_real_time], [Effective, Continuous], UnsureKey),
    business_present_pairs(States, PairsBeforeConsent, PairsAfterConsent),
    append(PairsBeforeConsent, PairsAfterConsent, Pairs).

decide_dma_art_6_9_10_portability_and_business_data_order(Profile, dma_art_6_9_10_portability_and_business_data_order_verdict(answers(ApplicationResult, PortabilityResult, BusinessResult), Citations)) :-
    article_6_application_status(Profile, ApplicationResult, _, ApplicationCitations),
    end_user_data_portability_status(Profile, PortabilityResult, _, PortabilityCitations),
    business_user_data_access_status(Profile, BusinessResult, _, BusinessCitations),
    append([ApplicationCitations, PortabilityCitations, BusinessCitations], AllCitations),
    sort(AllCitations, Citations).

dma_art_6_9_10_portability_and_business_data_order_status(Profile, Status) :-
    decide_dma_art_6_9_10_portability_and_business_data_order(Profile, dma_art_6_9_10_portability_and_business_data_order_verdict(Status, _Citations)).

dma_art_6_9_10_portability_and_business_data_order_checklist(Profile, [item(article_6_application, ApplicationResult, ApplicationItemCitations), item(end_user_data_portability, PortabilityResult, PortabilityItemCitations), item(business_user_data_access, BusinessResult, BusinessItemCitations)]) :-
    article_6_application_status(Profile, ApplicationResult, _, ApplicationCitations),
    end_user_data_portability_status(Profile, PortabilityResult, _, PortabilityCitations),
    business_user_data_access_status(Profile, BusinessResult, _, BusinessCitations),
    item_citations(ApplicationCitations, article_6_application, ApplicationItemCitations),
    item_citations(PortabilityCitations, end_user_data_portability, PortabilityItemCitations),
    item_citations(BusinessCitations, business_user_data_access, BusinessItemCitations).

item_citations([], Question, Citations) :-
    question_provisions(Question, Citations).
item_citations([Citation|Citations], _, [Citation|Citations]).

dma_art_6_9_10_portability_and_business_data_order_decision_resolvable(Profile) :-
    decide_dma_art_6_9_10_portability_and_business_data_order(Profile, _Verdict).

sample_listed(attested(true, attestation(host_operator, '2026-11-19T10:00:00Z', listed_in_designation_decision, none))).

sample_not_listed(attested(false, attestation(host_operator, '2026-11-19T10:00:00Z', not_listed_in_designation_decision, none))).

sample_consent_given(attested(true, attestation(host_operator, '2026-11-19T10:00:00Z', end_users_opted_in, none))).

sample_consent_refused(attested(false, attestation(host_operator, '2026-11-19T10:00:00Z', end_users_did_not_opt_in, none))).

test(application_listed_applies) :-
    sample_listed(Listed),
    findall(Result - Basis - Citations, article_6_application_status([attribute(designated_as_gatekeeper_for_core_platform_service, Listed)], Result, Basis, Citations), Answers),
    Answers == [article_6_obligations_apply - [outside_fact(designated_as_gatekeeper_for_core_platform_service, Listed)] - [cite(eu_reg_2022_1925_art_6_1)]].
test(application_not_listed_does_not_apply) :-
    sample_not_listed(NotListed),
    article_6_application_status([attribute(designated_as_gatekeeper_for_core_platform_service, NotListed)], article_6_obligations_do_not_apply, _, _).
test(application_absent_is_referred) :-
    findall(Result - Basis - Citations, article_6_application_status([], Result, Basis, Citations), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_1), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent])]) - [] - []].
test(portability_all_elements_met_once) :-
    sample_listed(Listed),
    findall(Result - Citations, end_user_data_portability_status([attribute(designated_as_gatekeeper_for_core_platform_service, Listed), attribute(portability_requested_by_end_user_or_authorised_third_party, true), attribute(data_provided_by_or_generated_through_activity_of_end_user, true), attribute(end_user_data_portability_free_of_charge, true), attribute(end_user_data_portability_effective, true), attribute(end_user_data_portability_tools_provided, true), attribute(end_user_data_continuous_real_time_access_provided, true)], Result, _, Citations), Answers),
    Answers == [portability_duty_met - [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_9)]].
test(portability_missing_tools_not_met) :-
    sample_listed(Listed),
    findall(Result, end_user_data_portability_status([attribute(designated_as_gatekeeper_for_core_platform_service, Listed), attribute(portability_requested_by_end_user_or_authorised_third_party, true), attribute(data_provided_by_or_generated_through_activity_of_end_user, true), attribute(end_user_data_portability_effective, unsure), attribute(end_user_data_portability_tools_provided, false)], Result, _, _), Results),
    Results == [portability_duty_not_met].
test(portability_no_request_not_requested) :-
    sample_listed(Listed),
    end_user_data_portability_status([attribute(designated_as_gatekeeper_for_core_platform_service, Listed), attribute(portability_requested_by_end_user_or_authorised_third_party, false)], portability_not_requested, _, _).
test(portability_first_absent_element_named) :-
    sample_listed(Listed),
    findall(Result, end_user_data_portability_status([attribute(designated_as_gatekeeper_for_core_platform_service, Listed), attribute(portability_requested_by_end_user_or_authorised_third_party, true), attribute(data_provided_by_or_generated_through_activity_of_end_user, true), attribute(end_user_data_portability_free_of_charge, true)], Result, _, _), Results),
    Results == [indeterminate([end_user_data_portability_effective])].
test(portability_designation_absent_referred_with_pairs) :-
    findall(Result, end_user_data_portability_status([attribute(portability_requested_by_end_user_or_authorised_third_party, true), attribute(data_provided_by_or_generated_through_activity_of_end_user, true), attribute(end_user_data_portability_free_of_charge, true), attribute(end_user_data_portability_effective, unsure), attribute(end_user_data_portability_tools_provided, true), attribute(end_user_data_continuous_real_time_access_provided, true)], Result, _, _), Results),
    Results == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_1), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent, portability_requested_by_end_user_or_authorised_third_party - true, data_provided_by_or_generated_through_activity_of_end_user - true, end_user_data_portability_free_of_charge - true, end_user_data_portability_effective - unsure, end_user_data_portability_tools_provided - true, end_user_data_continuous_real_time_access_provided - true])])].
test(portability_unsure_element_open_textured) :-
    sample_listed(Listed),
    findall(Result, end_user_data_portability_status([attribute(designated_as_gatekeeper_for_core_platform_service, Listed), attribute(portability_requested_by_end_user_or_authorised_third_party, true), attribute(data_provided_by_or_generated_through_activity_of_end_user, true), attribute(end_user_data_portability_free_of_charge, true), attribute(end_user_data_portability_effective, true), attribute(end_user_data_portability_tools_provided, unsure), attribute(end_user_data_continuous_real_time_access_provided, true)], Result, _, _), Results),
    Results == [needs_legal_review(open_textured(end_user_data_portability_tools_provided, cite(eu_reg_2022_1925_art_6_9)), [inputs_relied_on([portability_requested_by_end_user_or_authorised_third_party - true, data_provided_by_or_generated_through_activity_of_end_user - true, end_user_data_portability_free_of_charge - true, end_user_data_portability_effective - true, end_user_data_portability_tools_provided - unsure, end_user_data_continuous_real_time_access_provided - true])])].
test(business_personal_data_met_copies_consent) :-
    sample_listed(Listed),
    sample_consent_given(Consent),
    findall(Result - Basis, business_user_data_access_status([attribute(designated_as_gatekeeper_for_core_platform_service, Listed), attribute(data_access_requested_by_business_user_or_authorised_third_party, true), attribute(data_provided_or_generated_in_use_by_business_user_and_its_end_users, true), attribute(requested_business_user_data_are_personal_data, true), attribute(personal_data_directly_connected_with_end_user_use_of_business_user_offer, true), attribute(end_users_opted_in_to_sharing_by_consent, Consent), attribute(business_user_data_access_free_of_charge, true), attribute(business_user_data_access_and_use_effective_and_high_quality, true), attribute(business_user_data_access_continuous_and_real_time, true)], Result, Basis, _), Answers),
    Answers == [personal_data_access_duty_met - [outside_fact(designated_as_gatekeeper_for_core_platform_service, Listed), outside_fact(end_users_opted_in_to_sharing_by_consent, Consent)]].
test(business_consent_refused_not_required) :-
    sample_listed(Listed),
    sample_consent_refused(Refused),
    findall(Result - Basis, business_user_data_access_status([attribute(designated_as_gatekeeper_for_core_platform_service, Listed), attribute(data_access_requested_by_business_user_or_authorised_third_party, true), attribute(data_provided_or_generated_in_use_by_business_user_and_its_end_users, true), attribute(requested_business_user_data_are_personal_data, true), attribute(end_users_opted_in_to_sharing_by_consent, Refused)], Result, Basis, _), Answers),
    Answers == [personal_data_access_not_required - [outside_fact(designated_as_gatekeeper_for_core_platform_service, Listed)]].
test(business_consent_absent_referred_with_pairs) :-
    sample_listed(Listed),
    findall(Result, business_user_data_access_status([attribute(designated_as_gatekeeper_for_core_platform_service, Listed), attribute(data_access_requested_by_business_user_or_authorised_third_party, true), attribute(data_provided_or_generated_in_use_by_business_user_and_its_end_users, true), attribute(requested_business_user_data_are_personal_data, true), attribute(personal_data_directly_connected_with_end_user_use_of_business_user_offer, true), attribute(business_user_data_access_free_of_charge, true), attribute(business_user_data_access_and_use_effective_and_high_quality, true), attribute(business_user_data_access_continuous_and_real_time, true)], Result, _, _), Results),
    Results == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_10), cite(digital_markets_business_user_data_sharing_consent_statement)), [resolution(cite(digital_markets_business_user_data_sharing_consent_statement), not_attempted), inputs_relied_on([data_access_requested_by_business_user_or_authorised_third_party - true, data_provided_or_generated_in_use_by_business_user_and_its_end_users - true, requested_business_user_data_are_personal_data - true, personal_data_directly_connected_with_end_user_use_of_business_user_offer - true, end_users_opted_in_to_sharing_by_consent - absent, business_user_data_access_free_of_charge - true, business_user_data_access_and_use_effective_and_high_quality - true, business_user_data_access_continuous_and_real_time - true])])].
test(business_non_personal_met_without_consent) :-
    sample_listed(Listed),
    findall(Result - Citations, business_user_data_access_status([attribute(designated_as_gatekeeper_for_core_platform_service, Listed), attribute(data_access_requested_by_business_user_or_authorised_third_party, true), attribute(data_provided_or_generated_in_use_by_business_user_and_its_end_users, true), attribute(requested_business_user_data_are_personal_data, false), attribute(business_user_data_access_free_of_charge, true), attribute(business_user_data_access_and_use_effective_and_high_quality, true), attribute(business_user_data_access_continuous_and_real_time, true)], Result, _, Citations), Answers),
    Answers == [data_access_duty_met - [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10)]].
test(business_request_absent_named) :-
    findall(Result, business_user_data_access_status([], Result, _, _), Results),
    Results == [indeterminate([data_access_requested_by_business_user_or_authorised_third_party])].
test(business_not_listed_does_not_apply) :-
    sample_not_listed(NotListed),
    business_user_data_access_status([attribute(designated_as_gatekeeper_for_core_platform_service, NotListed), attribute(requested_business_user_data_are_personal_data, unsure)], article_6_obligations_do_not_apply, _, _).
test(unknown_key_gives_input_problems) :-
    findall(Result - Basis - Citations, end_user_data_portability_status([attribute(colour, blue)], Result, Basis, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - [] - []].
test(crisp_key_unsure_is_wrong_type) :-
    business_user_data_access_status([attribute(business_user_data_access_free_of_charge, unsure)], input_problems([wrong_type(business_user_data_access_free_of_charge)]), [], []).
test(facade_gives_one_verdict) :-
    sample_listed(Listed),
    findall(Status, dma_art_6_9_10_portability_and_business_data_order_status([attribute(designated_as_gatekeeper_for_core_platform_service, Listed)], Status), Statuses),
    Statuses == [answers(article_6_obligations_apply, indeterminate([portability_requested_by_end_user_or_authorised_third_party]), indeterminate([data_access_requested_by_business_user_or_authorised_third_party]))].
test(checklist_rows_carry_citations) :-
    dma_art_6_9_10_portability_and_business_data_order_checklist([], Items),
    Items = [item(article_6_application, _, [cite(eu_reg_2022_1925_art_6_1)]), item(end_user_data_portability, _, [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_9)]), item(business_user_data_access, _, [cite(eu_reg_2022_1925_art_6_1)|_])].

test(portability_missing_tools_is_not_met_duty, fail) :-
    sample_listed(Listed),
    end_user_data_portability_status([attribute(designated_as_gatekeeper_for_core_platform_service, Listed), attribute(portability_requested_by_end_user_or_authorised_third_party, true), attribute(data_provided_by_or_generated_through_activity_of_end_user, true), attribute(end_user_data_portability_effective, unsure), attribute(end_user_data_portability_tools_provided, false)], portability_duty_met, _, _).
test(business_consent_refused_is_not_duty_met, fail) :-
    sample_listed(Listed),
    sample_consent_refused(Refused),
    business_user_data_access_status([attribute(designated_as_gatekeeper_for_core_platform_service, Listed), attribute(data_access_requested_by_business_user_or_authorised_third_party, true), attribute(data_provided_or_generated_in_use_by_business_user_and_its_end_users, true), attribute(requested_business_user_data_are_personal_data, true), attribute(end_users_opted_in_to_sharing_by_consent, Refused)], personal_data_access_duty_met, _, _).
