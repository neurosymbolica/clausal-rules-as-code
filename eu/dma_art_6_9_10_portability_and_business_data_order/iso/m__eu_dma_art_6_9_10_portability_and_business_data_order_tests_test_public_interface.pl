% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_6_9_10_portability_and_business_data_order_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_dma_art_6_9_10_portability_and_business_data_order, [article_6_application_status/4, end_user_data_portability_status/4, business_user_data_access_status/4, decide_dma_art_6_9_10_portability_and_business_data_order/2, dma_art_6_9_10_portability_and_business_data_order_status/2, dma_art_6_9_10_portability_and_business_data_order_checklist/2, dma_art_6_9_10_portability_and_business_data_order_decision_resolvable/1, dma_art_6_9_10_portability_and_business_data_order_status_values/1]).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_kernel, [dma_art_6_9_10_portability_and_business_data_order_input_problems/2]).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_queries, [provenance/2]).
:- use_module(m__eu_dma_art_6_9_10_portability_and_business_data_order_fixtures, [dma_art_6_9_10_portability_and_business_data_order_subject/1, dma_art_6_9_10_portability_and_business_data_order_profile_for/2, dma_art_6_9_10_portability_and_business_data_order_assess/2]).

subject_status(Subject, Status) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(Subject, Profile),
    findall(Found, dma_art_6_9_10_portability_and_business_data_order_status(Profile, Found), Statuses),
    Statuses = [Status].

single_verdict(Subject) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(Subject, Profile),
    findall(Verdict, decide_dma_art_6_9_10_portability_and_business_data_order(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

checklist_cited(Subject) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(Subject, Profile),
    dma_art_6_9_10_portability_and_business_data_order_checklist(Profile, Items),
    length(Items, 3),
    maplist(item_cited, Items).

item_cited(item(_, _, [cite(_)|_])).

resolvable(Subject) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(Subject, Profile),
    dma_art_6_9_10_portability_and_business_data_order_decision_resolvable(Profile).

application_answers(Subject, Answers) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, article_6_application_status(Profile, Result, Basis, Citations), Answers).

portability_answers(Subject, Answers) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, end_user_data_portability_status(Profile, Result, Basis, Citations), Answers).

business_answers(Subject, Answers) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, business_user_data_access_status(Profile, Result, Basis, Citations), Answers).

test(every_subject_has_exactly_one_verdict) :-
    findall(Subject, dma_art_6_9_10_portability_and_business_data_order_subject(Subject), Subjects),
    length(Subjects, 35),
    maplist(single_verdict, Subjects).
test(every_subject_checklist_is_non_empty_and_cited) :-
    findall(Subject, dma_art_6_9_10_portability_and_business_data_order_subject(Subject), Subjects),
    maplist(checklist_cited, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, dma_art_6_9_10_portability_and_business_data_order_subject(Subject), Subjects),
    maplist(resolvable, Subjects).
test(status_values_hold_the_thirteen_result_atoms) :-
    dma_art_6_9_10_portability_and_business_data_order_status_values(Values),
    length(Values, 13),
    member(portability_duty_met, Values),
    member(personal_data_access_not_required, Values).
test(query_application_listed_applies_once) :-
    application_answers(application_listed, Answers),
    Answers = [article_6_obligations_apply - [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, _))] - [cite(eu_reg_2022_1925_art_6_1)]].
test(query_application_not_listed_does_not_apply_once) :-
    application_answers(application_not_listed, Answers),
    Answers = [article_6_obligations_do_not_apply - [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(false, _))] - [cite(eu_reg_2022_1925_art_6_1)]].
test(query_application_absent_is_referred_once) :-
    application_answers(application_designation_absent, Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_1), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent])]) - [] - []].
test(query_application_input_problems_once) :-
    application_answers(input_unknown_key, Answers),
    Answers == [input_problems([unknown_key(colour)]) - [] - []].
test(query_portability_duty_met_once) :-
    portability_answers(portability_duty_met_subject, Answers),
    Answers = [portability_duty_met - [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, _))] - [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_9)]].
test(query_portability_tools_lacking_not_met_once) :-
    portability_answers(portability_tools_lacking, Answers),
    Answers = [portability_duty_not_met - [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, _))] - [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_9)]].
test(query_portability_charged_not_met_once) :-
    portability_answers(portability_charged_with_other_elements_open, [portability_duty_not_met - _ - _]).
test(query_portability_not_requested_once) :-
    portability_answers(portability_not_requested_subject, [portability_not_requested - [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, _))] - [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_9)]]).
test(query_portability_data_outside_once) :-
    portability_answers(portability_data_outside, [data_outside_article_6_9 - [_] - [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_9)]]).
test(query_portability_not_listed_once) :-
    portability_answers(portability_not_listed, [article_6_obligations_do_not_apply - [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(false, _))] - [cite(eu_reg_2022_1925_art_6_1)]]).
test(query_portability_request_absent_once) :-
    portability_answers(portability_request_absent, Answers),
    Answers == [indeterminate([portability_requested_by_end_user_or_authorised_third_party]) - [] - []].
test(query_portability_scope_absent_once) :-
    portability_answers(portability_scope_absent, Answers),
    Answers == [indeterminate([data_provided_by_or_generated_through_activity_of_end_user]) - [] - []].
test(query_portability_effective_absent_once) :-
    portability_answers(portability_effective_absent, Answers),
    Answers == [indeterminate([end_user_data_portability_effective]) - [] - []].
test(query_portability_designation_absent_referred_once) :-
    portability_answers(portability_designation_absent, [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_1), cite(commission_designation_decision)), _) - [] - []]).
test(query_portability_scope_unsure_once) :-
    portability_answers(portability_scope_unsure, [needs_legal_review(open_textured(data_provided_by_or_generated_through_activity_of_end_user, cite(eu_reg_2022_1925_art_6_9)), [inputs_relied_on(_)]) - [] - []]).
test(query_portability_tools_unsure_once) :-
    portability_answers(portability_tools_unsure, [needs_legal_review(open_textured(end_user_data_portability_tools_provided, cite(eu_reg_2022_1925_art_6_9)), [inputs_relied_on(_)]) - [] - []]).
test(query_portability_input_problems_once) :-
    portability_answers(input_crisp_key_unsure, Answers),
    Answers == [input_problems([wrong_type(end_user_data_portability_free_of_charge)]) - [] - []].
test(query_business_non_personal_met_once) :-
    business_answers(business_non_personal_met, [data_access_duty_met - [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, _))] - [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10)]]).
test(query_business_non_personal_charged_once) :-
    business_answers(business_non_personal_charged, [data_access_duty_not_met - [_] - [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10)]]).
test(query_business_personal_met_copies_consent_once) :-
    business_answers(business_personal_met, [personal_data_access_duty_met - [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, _)), outside_fact(end_users_opted_in_to_sharing_by_consent, attested(true, _))] - [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10), cite(eu_reg_2022_1925_art_2_25), cite(eu_reg_2022_1925_art_2_32)]]).
test(query_business_personal_real_time_lacking_once) :-
    business_answers(business_personal_real_time_lacking, [personal_data_access_duty_not_met - [_, _] - [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10), cite(eu_reg_2022_1925_art_2_25), cite(eu_reg_2022_1925_art_2_32)]]).
test(query_business_consent_refused_not_required_once) :-
    business_answers(business_consent_refused, [personal_data_access_not_required - [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(true, _))] - [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10), cite(eu_reg_2022_1925_art_2_25), cite(eu_reg_2022_1925_art_2_32)]]).
test(query_business_not_directly_connected_once) :-
    business_answers(business_not_directly_connected, [personal_data_access_not_required - [_] - _]).
test(query_business_not_requested_once) :-
    business_answers(business_not_requested, [data_access_not_requested - [_] - [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10)]]).
test(query_business_data_outside_once) :-
    business_answers(business_data_outside, [data_outside_article_6_10 - [_] - [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10)]]).
test(query_business_not_listed_once) :-
    business_answers(business_not_listed, [article_6_obligations_do_not_apply - [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(false, _))] - [cite(eu_reg_2022_1925_art_6_1)]]).
test(query_business_request_absent_once) :-
    business_answers(business_request_absent, Answers),
    Answers == [indeterminate([data_access_requested_by_business_user_or_authorised_third_party]) - [] - []].
test(query_business_personal_absent_once) :-
    business_answers(business_personal_absent, Answers),
    Answers == [indeterminate([requested_business_user_data_are_personal_data]) - [] - []].
test(query_business_connection_absent_once) :-
    business_answers(business_connection_absent, Answers),
    Answers == [indeterminate([personal_data_directly_connected_with_end_user_use_of_business_user_offer]) - [] - []].
test(query_business_element_absent_once) :-
    business_answers(business_element_absent, Answers),
    Answers == [indeterminate([business_user_data_access_and_use_effective_and_high_quality]) - [] - []].
test(query_business_designation_absent_referred_once) :-
    business_answers(business_designation_absent, [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_1), cite(commission_designation_decision)), _) - [] - []]).
test(query_business_consent_absent_referred_once) :-
    business_answers(business_consent_absent, [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_10), cite(digital_markets_business_user_data_sharing_consent_statement)), _) - [] - []]).
test(query_business_personal_unsure_once) :-
    business_answers(business_personal_unsure, [needs_legal_review(open_textured(requested_business_user_data_are_personal_data, cite(eu_reg_2022_1925_art_6_10)), [inputs_relied_on(_)]) - [] - []]).
test(query_business_effective_unsure_once) :-
    business_answers(business_effective_unsure, [needs_legal_review(open_textured(business_user_data_access_and_use_effective_and_high_quality, cite(eu_reg_2022_1925_art_6_10)), [inputs_relied_on(_)]) - [] - []]).
test(query_business_input_problems_once) :-
    business_answers(input_duplicate_key, Answers),
    Answers == [input_problems([duplicate_key(portability_requested_by_end_user_or_authorised_third_party)]) - [] - []].
test(input_check_bare_list_for_unknown_key) :-
    findall(Problems, dma_art_6_9_10_portability_and_business_data_order_input_problems([attribute(colour, blue)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(input_check_empty_for_well_formed_profile) :-
    dma_art_6_9_10_portability_and_business_data_order_profile_for(portability_duty_met_subject, Profile),
    dma_art_6_9_10_portability_and_business_data_order_input_problems(Profile, []).
test(input_check_not_a_list) :-
    dma_art_6_9_10_portability_and_business_data_order_input_problems(not_a_profile, [wrong_type(profile)]).
test(provenance_constructor_holds_for_ground_arguments) :-
    provenance(host_operator, document(upload_one, sha_value)).
test(application_listed_applies) :-
    subject_status(application_listed, answers(article_6_obligations_apply, _, _)).
test(application_not_listed_does_not_apply) :-
    subject_status(application_not_listed, Status),
    Status == answers(article_6_obligations_do_not_apply, article_6_obligations_do_not_apply, article_6_obligations_do_not_apply).
test(application_designation_absent_is_referred) :-
    subject_status(application_designation_absent, answers(ApplicationResult, _, _)),
    ApplicationResult == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_1), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent])]).
test(application_listed_verdict_cites_article_6_1) :-
    dma_art_6_9_10_portability_and_business_data_order_assess(application_listed, dma_art_6_9_10_portability_and_business_data_order_verdict(_, Citations)),
    Citations == [cite(eu_reg_2022_1925_art_6_1)].
test(portability_duty_met_subject_is_met) :-
    subject_status(portability_duty_met_subject, answers(article_6_obligations_apply, portability_duty_met, indeterminate([data_access_requested_by_business_user_or_authorised_third_party]))).
test(portability_duty_met_subject_verdict_citations) :-
    dma_art_6_9_10_portability_and_business_data_order_assess(portability_duty_met_subject, dma_art_6_9_10_portability_and_business_data_order_verdict(_, Citations)),
    Citations == [cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_9)].
test(portability_tools_lacking_is_not_met) :-
    subject_status(portability_tools_lacking, answers(_, portability_duty_not_met, _)).
test(portability_charged_is_not_met_whatever_the_others) :-
    subject_status(portability_charged_with_other_elements_open, answers(_, portability_duty_not_met, _)).
test(portability_not_requested_subject_sets_no_duty) :-
    subject_status(portability_not_requested_subject, answers(_, portability_not_requested, _)).
test(portability_data_outside_is_outside) :-
    subject_status(portability_data_outside, answers(_, data_outside_article_6_9, _)).
test(portability_not_listed_does_not_apply) :-
    subject_status(portability_not_listed, answers(_, article_6_obligations_do_not_apply, _)).
test(portability_request_absent_named) :-
    subject_status(portability_request_absent, answers(_, indeterminate([portability_requested_by_end_user_or_authorised_third_party]), _)).
test(portability_scope_absent_named) :-
    subject_status(portability_scope_absent, answers(_, indeterminate([data_provided_by_or_generated_through_activity_of_end_user]), _)).
test(portability_effective_absent_named) :-
    subject_status(portability_effective_absent, answers(_, indeterminate([end_user_data_portability_effective]), _)).
test(portability_designation_absent_referred_with_pairs) :-
    subject_status(portability_designation_absent, answers(_, PortabilityResult, _)),
    PortabilityResult == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_1), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent, portability_requested_by_end_user_or_authorised_third_party - true, data_provided_by_or_generated_through_activity_of_end_user - true, end_user_data_portability_free_of_charge - true, end_user_data_portability_effective - true, end_user_data_portability_tools_provided - true, end_user_data_continuous_real_time_access_provided - true])]).
test(portability_scope_unsure_is_open_textured) :-
    subject_status(portability_scope_unsure, answers(_, needs_legal_review(open_textured(data_provided_by_or_generated_through_activity_of_end_user, cite(eu_reg_2022_1925_art_6_9)), [inputs_relied_on(_)]), _)).
test(portability_tools_unsure_is_open_textured_with_pairs) :-
    subject_status(portability_tools_unsure, answers(_, PortabilityResult, _)),
    PortabilityResult == needs_legal_review(open_textured(end_user_data_portability_tools_provided, cite(eu_reg_2022_1925_art_6_9)), [inputs_relied_on([portability_requested_by_end_user_or_authorised_third_party - true, data_provided_by_or_generated_through_activity_of_end_user - true, end_user_data_portability_free_of_charge - true, end_user_data_portability_effective - true, end_user_data_portability_tools_provided - unsure, end_user_data_continuous_real_time_access_provided - true])]).
test(business_non_personal_met_is_met) :-
    subject_status(business_non_personal_met, answers(article_6_obligations_apply, indeterminate([portability_requested_by_end_user_or_authorised_third_party]), data_access_duty_met)).
test(business_non_personal_charged_is_not_met) :-
    subject_status(business_non_personal_charged, answers(_, _, data_access_duty_not_met)).
test(business_personal_met_is_met) :-
    subject_status(business_personal_met, answers(_, _, personal_data_access_duty_met)).
test(business_personal_met_verdict_cites_definitions) :-
    dma_art_6_9_10_portability_and_business_data_order_assess(business_personal_met, dma_art_6_9_10_portability_and_business_data_order_verdict(_, Citations)),
    Citations == [cite(eu_reg_2022_1925_art_2_25), cite(eu_reg_2022_1925_art_2_32), cite(eu_reg_2022_1925_art_6_1), cite(eu_reg_2022_1925_art_6_10)].
test(business_personal_real_time_lacking_is_not_met) :-
    subject_status(business_personal_real_time_lacking, answers(_, _, personal_data_access_duty_not_met)).
test(business_consent_refused_not_required) :-
    subject_status(business_consent_refused, answers(_, _, personal_data_access_not_required)).
test(business_not_directly_connected_not_required) :-
    subject_status(business_not_directly_connected, answers(_, _, personal_data_access_not_required)).
test(business_not_requested_sets_no_duty) :-
    subject_status(business_not_requested, answers(_, _, data_access_not_requested)).
test(business_data_outside_is_outside) :-
    subject_status(business_data_outside, answers(_, _, data_outside_article_6_10)).
test(business_not_listed_does_not_apply) :-
    subject_status(business_not_listed, answers(_, _, article_6_obligations_do_not_apply)).
test(business_request_absent_named) :-
    subject_status(business_request_absent, answers(_, _, indeterminate([data_access_requested_by_business_user_or_authorised_third_party]))).
test(business_personal_absent_named) :-
    subject_status(business_personal_absent, answers(_, _, indeterminate([requested_business_user_data_are_personal_data]))).
test(business_connection_absent_named) :-
    subject_status(business_connection_absent, answers(_, _, indeterminate([personal_data_directly_connected_with_end_user_use_of_business_user_offer]))).
test(business_element_absent_named) :-
    subject_status(business_element_absent, answers(_, _, indeterminate([business_user_data_access_and_use_effective_and_high_quality]))).
test(business_designation_absent_referred_with_pairs) :-
    subject_status(business_designation_absent, answers(_, _, BusinessResult)),
    BusinessResult == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_1), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent, data_access_requested_by_business_user_or_authorised_third_party - true, data_provided_or_generated_in_use_by_business_user_and_its_end_users - true, requested_business_user_data_are_personal_data - false, business_user_data_access_free_of_charge - true, business_user_data_access_and_use_effective_and_high_quality - true, business_user_data_access_continuous_and_real_time - true])]).
test(business_consent_absent_referred_with_pairs) :-
    subject_status(business_consent_absent, answers(_, _, BusinessResult)),
    BusinessResult == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_6_10), cite(digital_markets_business_user_data_sharing_consent_statement)), [resolution(cite(digital_markets_business_user_data_sharing_consent_statement), not_attempted), inputs_relied_on([data_access_requested_by_business_user_or_authorised_third_party - true, data_provided_or_generated_in_use_by_business_user_and_its_end_users - true, requested_business_user_data_are_personal_data - true, personal_data_directly_connected_with_end_user_use_of_business_user_offer - true, end_users_opted_in_to_sharing_by_consent - absent, business_user_data_access_free_of_charge - true, business_user_data_access_and_use_effective_and_high_quality - true, business_user_data_access_continuous_and_real_time - true])]).
test(business_personal_unsure_is_open_textured) :-
    subject_status(business_personal_unsure, answers(_, _, needs_legal_review(open_textured(requested_business_user_data_are_personal_data, cite(eu_reg_2022_1925_art_6_10)), [inputs_relied_on(_)]))).
test(business_effective_unsure_is_open_textured_with_pairs) :-
    subject_status(business_effective_unsure, answers(_, _, BusinessResult)),
    BusinessResult == needs_legal_review(open_textured(business_user_data_access_and_use_effective_and_high_quality, cite(eu_reg_2022_1925_art_6_10)), [inputs_relied_on([data_access_requested_by_business_user_or_authorised_third_party - true, data_provided_or_generated_in_use_by_business_user_and_its_end_users - true, requested_business_user_data_are_personal_data - false, business_user_data_access_free_of_charge - true, business_user_data_access_and_use_effective_and_high_quality - unsure, business_user_data_access_continuous_and_real_time - true])]).
test(input_unknown_key_rejected_in_every_query) :-
    subject_status(input_unknown_key, Status),
    Status == answers(input_problems([unknown_key(colour)]), input_problems([unknown_key(colour)]), input_problems([unknown_key(colour)])).
test(input_unknown_key_verdict_has_no_citation) :-
    dma_art_6_9_10_portability_and_business_data_order_assess(input_unknown_key, dma_art_6_9_10_portability_and_business_data_order_verdict(_, Citations)),
    Citations == [].
test(input_duplicate_key_named_once) :-
    subject_status(input_duplicate_key, answers(input_problems([duplicate_key(portability_requested_by_end_user_or_authorised_third_party)]), _, _)).
test(input_crisp_key_unsure_is_wrong_type) :-
    subject_status(input_crisp_key_unsure, answers(_, input_problems([wrong_type(end_user_data_portability_free_of_charge)]), _)).

test(query_application_not_listed_is_not_apply, fail) :-
    application_answers(application_not_listed, [article_6_obligations_apply - _ - _]).
test(query_portability_tools_lacking_is_not_met_duty, fail) :-
    portability_answers(portability_tools_lacking, [portability_duty_met - _ - _]).
test(query_business_non_personal_charged_is_not_met_duty, fail) :-
    business_answers(business_non_personal_charged, [data_access_duty_met - _ - _]).
test(query_business_consent_refused_is_not_duty_met, fail) :-
    business_answers(business_consent_refused, [personal_data_access_duty_met - _ - _]).
test(provenance_constructor_refuses_unbound_detail, fail) :-
    provenance(host_operator, _).
test(application_not_listed_is_not_apply, fail) :-
    subject_status(application_not_listed, answers(article_6_obligations_apply, _, _)).
test(portability_tools_lacking_is_not_duty_met, fail) :-
    subject_status(portability_tools_lacking, answers(_, portability_duty_met, _)).
test(portability_not_requested_is_not_met, fail) :-
    subject_status(portability_not_requested_subject, answers(_, portability_duty_met, _)).
test(portability_data_outside_is_not_met, fail) :-
    subject_status(portability_data_outside, answers(_, portability_duty_met, _)).
test(portability_effective_absent_is_not_met, fail) :-
    subject_status(portability_effective_absent, answers(_, portability_duty_met, _)).
test(business_non_personal_charged_is_not_duty_met, fail) :-
    subject_status(business_non_personal_charged, answers(_, _, data_access_duty_met)).
test(business_personal_real_time_lacking_is_not_duty_met, fail) :-
    subject_status(business_personal_real_time_lacking, answers(_, _, personal_data_access_duty_met)).
test(business_consent_refused_is_not_duty_met, fail) :-
    subject_status(business_consent_refused, answers(_, _, personal_data_access_duty_met)).
test(business_connection_absent_is_not_duty_met, fail) :-
    subject_status(business_connection_absent, answers(_, _, personal_data_access_duty_met)).
test(well_formed_near_miss_has_no_input_problems, fail) :-
    subject_status(portability_request_absent, answers(input_problems(_), _, _)).

cp_test_names([every_subject_has_exactly_one_verdict, every_subject_checklist_is_non_empty_and_cited, every_subject_is_resolvable, status_values_hold_the_thirteen_result_atoms, query_application_listed_applies_once, query_application_not_listed_does_not_apply_once, query_application_absent_is_referred_once, query_application_input_problems_once, query_portability_duty_met_once, query_portability_tools_lacking_not_met_once, query_portability_charged_not_met_once, query_portability_not_requested_once, query_portability_data_outside_once, query_portability_not_listed_once, query_portability_request_absent_once, query_portability_scope_absent_once, query_portability_effective_absent_once, query_portability_designation_absent_referred_once, query_portability_scope_unsure_once, query_portability_tools_unsure_once, query_portability_input_problems_once, query_business_non_personal_met_once, query_business_non_personal_charged_once, query_business_personal_met_copies_consent_once, query_business_personal_real_time_lacking_once, query_business_consent_refused_not_required_once, query_business_not_directly_connected_once, query_business_not_requested_once, query_business_data_outside_once, query_business_not_listed_once, query_business_request_absent_once, query_business_personal_absent_once, query_business_connection_absent_once, query_business_element_absent_once, query_business_designation_absent_referred_once, query_business_consent_absent_referred_once, query_business_personal_unsure_once, query_business_effective_unsure_once, query_business_input_problems_once, input_check_bare_list_for_unknown_key, input_check_empty_for_well_formed_profile, input_check_not_a_list, provenance_constructor_holds_for_ground_arguments, application_listed_applies, application_not_listed_does_not_apply, application_designation_absent_is_referred, application_listed_verdict_cites_article_6_1, portability_duty_met_subject_is_met, portability_duty_met_subject_verdict_citations, portability_tools_lacking_is_not_met, portability_charged_is_not_met_whatever_the_others, portability_not_requested_subject_sets_no_duty, portability_data_outside_is_outside, portability_not_listed_does_not_apply, portability_request_absent_named, portability_scope_absent_named, portability_effective_absent_named, portability_designation_absent_referred_with_pairs, portability_scope_unsure_is_open_textured, portability_tools_unsure_is_open_textured_with_pairs, business_non_personal_met_is_met, business_non_personal_charged_is_not_met, business_personal_met_is_met, business_personal_met_verdict_cites_definitions, business_personal_real_time_lacking_is_not_met, business_consent_refused_not_required, business_not_directly_connected_not_required, business_not_requested_sets_no_duty, business_data_outside_is_outside, business_not_listed_does_not_apply, business_request_absent_named, business_personal_absent_named, business_connection_absent_named, business_element_absent_named, business_designation_absent_referred_with_pairs, business_consent_absent_referred_with_pairs, business_personal_unsure_is_open_textured, business_effective_unsure_is_open_textured_with_pairs, input_unknown_key_rejected_in_every_query, input_unknown_key_verdict_has_no_citation, input_duplicate_key_named_once, input_crisp_key_unsure_is_wrong_type]).
cp_test_fail_names([query_application_not_listed_is_not_apply, query_portability_tools_lacking_is_not_met_duty, query_business_non_personal_charged_is_not_met_duty, query_business_consent_refused_is_not_duty_met, provenance_constructor_refuses_unbound_detail, application_not_listed_is_not_apply, portability_tools_lacking_is_not_duty_met, portability_not_requested_is_not_met, portability_data_outside_is_not_met, portability_effective_absent_is_not_met, business_non_personal_charged_is_not_duty_met, business_personal_real_time_lacking_is_not_duty_met, business_consent_refused_is_not_duty_met, business_connection_absent_is_not_duty_met, well_formed_near_miss_has_no_input_problems]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
