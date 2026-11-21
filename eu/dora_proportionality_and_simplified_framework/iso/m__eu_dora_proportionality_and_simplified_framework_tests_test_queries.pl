% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_proportionality_and_simplified_framework_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_queries, [dora_proportionality_and_simplified_framework_profile_keys/1, dora_proportionality_and_simplified_framework_what_if/4]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_kernel, [dora_proportionality_and_simplified_framework_input_problems/2]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_kernel, [contract_key_order/1]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_dora_proportionality_and_simplified_framework, [simplified_framework_qualification/3, simplified_framework_duties_complete/3, dora_proportionality_and_simplified_framework_checklist/2]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_fixtures, [dora_proportionality_and_simplified_framework_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    dora_proportionality_and_simplified_framework_profile_keys(ProfileKeys),
    ProfileKeys == [dora_entity_type, investment_firm_is_small_and_non_interconnected, iorp_pension_scheme_members_total, exempted_from_dora_scope_by_member_state, authority_requested_framework_review_report, simplified_framework_in_place_and_maintained, ict_systems_continuously_monitored, ict_risk_impact_minimised_with_sound_systems, risk_sources_detected_and_incidents_handled, key_ict_third_party_dependencies_identified, continuity_of_critical_functions_ensured, plans_and_controls_tested_regularly, test_and_incident_conclusions_implemented, awareness_and_training_programmes_developed, simplified_framework_documented_and_reviewed, simplified_framework_continuously_improved, simplified_framework_review_report_submitted].
test(profile_keys_agree_with_the_kernel) :-
    dora_proportionality_and_simplified_framework_profile_keys(ProfileKeys),
    contract_key_order(ContractKeys),
    ProfileKeys == ContractKeys.
test(the_reexported_input_check_answers) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(dora_entity_type, credit_institution)], []).
test(what_if_a_duty_is_not_performed) :-
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_all_duties_performed, Profile),
    dora_proportionality_and_simplified_framework_what_if(Profile, simplified_framework_in_place_and_maintained, false, incomplete).
test(what_if_the_unsure_duty_is_performed) :-
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_framework_unsure, Profile),
    dora_proportionality_and_simplified_framework_what_if(Profile, simplified_framework_in_place_and_maintained, true, complete).
test(what_if_the_member_count_crosses_one_hundred) :-
    dora_proportionality_and_simplified_framework_profile_for(occupational_retirement_ninety_nine_members, Profile),
    dora_proportionality_and_simplified_framework_what_if(Profile, iorp_pension_scheme_members_total, 100, not_article_16_1_entity).
test(what_if_the_member_count_rises_above_fifteen) :-
    dora_proportionality_and_simplified_framework_profile_for(occupational_retirement_fifteen_members, Profile),
    dora_proportionality_and_simplified_framework_what_if(Profile, iorp_pension_scheme_members_total, 16, complete).
test(what_if_the_authority_requests_the_report) :-
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_all_duties_performed, Profile),
    dora_proportionality_and_simplified_framework_what_if(Profile, authority_requested_framework_review_report, true, indeterminate([simplified_framework_review_report_submitted])).
test(what_if_a_value_outside_its_type_is_refused) :-
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_all_duties_performed, Profile),
    dora_proportionality_and_simplified_framework_what_if(Profile, dora_entity_type, bank, input_problems([wrong_type(dora_entity_type)])).
test(what_if_refuses_a_profile_with_a_duplicate) :-
    dora_proportionality_and_simplified_framework_profile_for(entity_type_given_twice, Profile),
    dora_proportionality_and_simplified_framework_what_if(Profile, dora_entity_type, credit_institution, input_problems([duplicate_key(dora_entity_type)])).
test(what_if_has_exactly_one_answer) :-
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_all_duties_performed, Profile),
    findall(Status, dora_proportionality_and_simplified_framework_what_if(Profile, ict_systems_continuously_monitored, unsure, Status), Statuses),
    Statuses = [needs_legal_review(open_textured(ict_systems_continuously_monitored, cite(eu_reg_2022_2554_art_16_1_b)), _)].
test(the_eligibility_query_answers_with_its_citation) :-
    dora_proportionality_and_simplified_framework_profile_for(small_investment_firm_all_duties_performed, Profile),
    simplified_framework_qualification(Profile, article_16_1_entity, Citations),
    member(cite(eu_reg_2022_2554_art_3_34), Citations).
test(the_compliance_check_answers) :-
    dora_proportionality_and_simplified_framework_profile_for(requested_report_not_submitted, Profile),
    simplified_framework_duties_complete(Profile, incomplete, _).
test(the_justification_checklist_cites_each_duty) :-
    dora_proportionality_and_simplified_framework_profile_for(requested_report_not_submitted, Profile),
    dora_proportionality_and_simplified_framework_checklist(Profile, Items),
    length(Items, 13),
    member(item(review_report_to_authority, unmet(not_performed), cite(eu_reg_2022_2554_art_16_2)), Items),
    member(item(simplified_ict_risk_management_framework, met, cite(eu_reg_2022_2554_art_16_1_a)), Items).

cp_test_names([profile_keys_are_the_contract_keys, profile_keys_agree_with_the_kernel, the_reexported_input_check_answers, what_if_a_duty_is_not_performed, what_if_the_unsure_duty_is_performed, what_if_the_member_count_crosses_one_hundred, what_if_the_member_count_rises_above_fifteen, what_if_the_authority_requests_the_report, what_if_a_value_outside_its_type_is_refused, what_if_refuses_a_profile_with_a_duplicate, what_if_has_exactly_one_answer, the_eligibility_query_answers_with_its_citation, the_compliance_check_answers, the_justification_checklist_cites_each_duty]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
