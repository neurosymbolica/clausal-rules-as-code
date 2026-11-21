% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_representation_and_suspension_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_gdpr_representation_and_suspension, [mandated_representation/5, representation_without_mandate/5, court_contact_duty/3, court_suspension_option/3, court_declining_jurisdiction_option/4, gdpr_representation_and_suspension_status/2, gdpr_representation_and_suspension_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_kernel, [gdpr_representation_and_suspension_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_representation_and_suspension_fixtures, [gdpr_representation_and_suspension_profile_for/2]).

test(mandated_may_act_bound) :-
    gdpr_representation_and_suspension_profile_for(mandated_complaint_qualified, Profile),
    mandated_representation(Profile, lodge_complaint_under_article_77, may_act_on_mandate, [], [cite(eu_reg_2016_679_art_80_1)]).
test(mandated_may_not_act_bound) :-
    gdpr_representation_and_suspension_profile_for(mandated_complaint_not_mandated, Profile),
    mandated_representation(Profile, lodge_complaint_under_article_77, may_not_act_on_mandate, [], [cite(eu_reg_2016_679_art_80_1)]).
test(mandated_missing_mandate_bound) :-
    gdpr_representation_and_suspension_profile_for(mandated_complaint_mandate_missing, Profile),
    mandated_representation(Profile, exercise_rights_under_article_78, indeterminate([data_subject_mandated_the_body]), [], []).
test(without_mandate_may_act_bound) :-
    gdpr_representation_and_suspension_profile_for(without_mandate_complaint_provided, Profile),
    representation_without_mandate(Profile, lodge_complaint_under_article_77, may_act_without_mandate, [outside_fact(member_state_law_provides_for_the_action_without_mandate, attested(true, attestation(host_service, attestation_moment, caller_statement, none)))], [cite(eu_reg_2016_679_art_80_2)]).
test(without_mandate_compensation_bound) :-
    gdpr_representation_and_suspension_profile_for(without_mandate_compensation_refused, Profile),
    representation_without_mandate(Profile, receive_compensation_under_article_82, may_not_act_without_mandate, [], [cite(eu_reg_2016_679_art_80_2)]).
test(contact_duty_bound) :-
    gdpr_representation_and_suspension_profile_for(court_contact_related, Profile),
    court_contact_duty(Profile, contact_duty_applies, [cite(eu_reg_2016_679_art_81_1)]).
test(suspension_bound) :-
    gdpr_representation_and_suspension_profile_for(court_suspension_court_first_seized, Profile),
    court_suspension_option(Profile, suspension_not_available, [cite(eu_reg_2016_679_art_81_2)]).
test(declining_bound) :-
    gdpr_representation_and_suspension_profile_for(court_declining_application_missing, Profile),
    court_declining_jurisdiction_option(Profile, indeterminate([party_applied_for_court_to_decline_jurisdiction]), [], []).
test(status_holds_with_the_verdict_bound) :-
    gdpr_representation_and_suspension_profile_for(court_suspension_second_court, Profile),
    findall(Status, gdpr_representation_and_suspension_status(court_suspension_option(Profile), Status), Statuses),
    Statuses == [may_suspend_proceedings],
    gdpr_representation_and_suspension_status(court_suspension_option(Profile), may_suspend_proceedings).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_representation_and_suspension_input_problems([], Problems), Answers),
    Answers == [[]].
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, gdpr_representation_and_suspension_input_problems(_Unbound, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_not_an_attribute_list) :-
    gdpr_representation_and_suspension_input_problems([attribute(court_is_competent_court, true)|_Tail], Problems),
    Problems == [wrong_type(profile)].
test(a_foreign_element_makes_the_whole_profile_wrong) :-
    gdpr_representation_and_suspension_input_problems([attribute(court_is_competent_court, unsure), court], Problems),
    Problems == [wrong_type(profile)].
test(an_atom_is_not_a_profile) :-
    gdpr_representation_and_suspension_input_problems(not_a_profile, Problems),
    Problems == [wrong_type(profile)].
test(an_unbound_value_is_wrong_type) :-
    gdpr_representation_and_suspension_input_problems([attribute(court_is_competent_court, _Value)], Problems),
    Problems == [wrong_type(court_is_competent_court)].
test(an_unbound_attestation_argument_is_wrong_type) :-
    gdpr_representation_and_suspension_input_problems([attribute(law_of_court_first_seized_permits_consolidation, attested(true, attestation(_Attester, moment, reason, none)))], Problems),
    Problems == [wrong_type(law_of_court_first_seized_permits_consolidation)].
test(a_full_attestation_is_accepted) :-
    gdpr_representation_and_suspension_input_problems([attribute(law_of_court_first_seized_permits_consolidation, attested(false, attestation(host, moment, reason, url(address, retrieved))))], Problems),
    Problems == [].
test(a_bare_outside_fact_is_wrong_type) :-
    gdpr_representation_and_suspension_input_problems([attribute(member_state_law_provides_for_the_action_without_mandate, true)], Problems),
    Problems == [wrong_type(member_state_law_provides_for_the_action_without_mandate)].
test(an_attested_crisp_key_is_wrong_type) :-
    gdpr_representation_and_suspension_input_problems([attribute(body_is_not_for_profit, attested(true, attestation(host, moment, reason, none)))], Problems),
    Problems == [wrong_type(body_is_not_for_profit)].
test(unsure_is_a_judgement_value) :-
    gdpr_representation_and_suspension_input_problems([attribute(other_proceedings_concern_same_subject_matter, unsure)], Problems),
    Problems == [].
test(unsure_is_not_a_crisp_value) :-
    gdpr_representation_and_suspension_input_problems([attribute(court_is_court_first_seized, unsure)], Problems),
    Problems == [wrong_type(court_is_court_first_seized)].
test(a_duplicate_key_is_named_once_and_never_wrong_type) :-
    gdpr_representation_and_suspension_input_problems([attribute(court_is_competent_court, true), attribute(court_is_competent_court, banana)], Problems),
    Problems == [duplicate_key(court_is_competent_court)].
test(a_repeated_unknown_key_is_named_once) :-
    gdpr_representation_and_suspension_input_problems([attribute(colour, red), attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(a_number_key_is_unknown) :-
    gdpr_representation_and_suspension_input_problems([attribute(42, true)], Problems),
    Problems == [unknown_key(42)].
test(an_unbound_key_is_reported_as_given) :-
    gdpr_representation_and_suspension_input_problems([attribute(Key, true)], Problems),
    Problems = [unknown_key(Reported)],
    Reported == Key.
test(problems_come_in_contract_order_then_unknown_keys) :-
    gdpr_representation_and_suspension_input_problems([attribute(zebra, stripes), attribute(law_of_court_first_seized_permits_consolidation, true), attribute(court_is_competent_court, unsure)], Problems),
    Problems == [wrong_type(court_is_competent_court), wrong_type(law_of_court_first_seized_permits_consolidation), unknown_key(zebra)].
test(a_bad_profile_gives_only_input_problems) :-
    findall(Result - Basis - Citations, court_declining_jurisdiction_option(not_a_profile, Result, Basis, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - [] - []].
test(an_unbound_action_is_never_enumerated) :-
    mandated_representation([], Action, Result, Basis, Citations),
    var(Action),
    Result == input_problems([wrong_type(action)]),
    Basis == [],
    Citations == [].
test(a_compound_action_is_wrong_type) :-
    representation_without_mandate([attribute(body_is_not_for_profit, true)], lodge(complaint), input_problems([wrong_type(action)]), [], []).
test(profile_problems_come_before_the_action_problem) :-
    representation_without_mandate([attribute(body_is_not_for_profit, unsure)], appeal, input_problems([wrong_type(body_is_not_for_profit), wrong_type(action)]), [], []).

test(mandated_may_act_rejects_the_negative_bound, fail) :-
    gdpr_representation_and_suspension_profile_for(mandated_complaint_qualified, Profile),
    mandated_representation(Profile, lodge_complaint_under_article_77, may_not_act_on_mandate, _, _).
test(contact_duty_rejects_the_negative_bound, fail) :-
    gdpr_representation_and_suspension_profile_for(court_contact_related, Profile),
    court_contact_duty(Profile, contact_duty_does_not_apply, _).
test(every_other_bound_status_is_rejected, fail) :-
    gdpr_representation_and_suspension_profile_for(court_suspension_second_court, Profile),
    gdpr_representation_and_suspension_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, may_suspend_proceedings),
    gdpr_representation_and_suspension_status(court_suspension_option(Profile), Other).

cp_test_names([mandated_may_act_bound, mandated_may_not_act_bound, mandated_missing_mandate_bound, without_mandate_may_act_bound, without_mandate_compensation_bound, contact_duty_bound, suspension_bound, declining_bound, status_holds_with_the_verdict_bound, an_empty_profile_has_no_problem, an_unbound_profile_is_not_an_attribute_list, a_partial_list_is_not_an_attribute_list, a_foreign_element_makes_the_whole_profile_wrong, an_atom_is_not_a_profile, an_unbound_value_is_wrong_type, an_unbound_attestation_argument_is_wrong_type, a_full_attestation_is_accepted, a_bare_outside_fact_is_wrong_type, an_attested_crisp_key_is_wrong_type, unsure_is_a_judgement_value, unsure_is_not_a_crisp_value, a_duplicate_key_is_named_once_and_never_wrong_type, a_repeated_unknown_key_is_named_once, a_number_key_is_unknown, an_unbound_key_is_reported_as_given, problems_come_in_contract_order_then_unknown_keys, a_bad_profile_gives_only_input_problems, an_unbound_action_is_never_enumerated, a_compound_action_is_wrong_type, profile_problems_come_before_the_action_problem]).
cp_test_fail_names([mandated_may_act_rejects_the_negative_bound, contact_duty_rejects_the_negative_bound, every_other_bound_status_is_rejected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
