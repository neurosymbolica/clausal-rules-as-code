% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_proportionality_and_simplified_framework_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_dora_proportionality_and_simplified_framework, [dora_proportionality_and_simplified_framework_status/2, dora_proportionality_and_simplified_framework_status_values/1, simplified_framework_qualification/3, simplified_framework_duties_required/3, simplified_framework_duties_complete/3, simplified_framework_duties_outstanding/3]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_kernel, [dora_proportionality_and_simplified_framework_input_problems/2]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_fixtures, [dora_proportionality_and_simplified_framework_profile_for/2]).

later_duties([attribute(ict_systems_continuously_monitored, true), attribute(ict_risk_impact_minimised_with_sound_systems, true), attribute(risk_sources_detected_and_incidents_handled, true), attribute(key_ict_third_party_dependencies_identified, true), attribute(continuity_of_critical_functions_ensured, true), attribute(plans_and_controls_tested_regularly, true), attribute(test_and_incident_conclusions_implemented, true), attribute(awareness_and_training_programmes_developed, true), attribute(simplified_framework_documented_and_reviewed, true), attribute(simplified_framework_continuously_improved, true)]).

payment_profile(Extra, FrameworkValue, Profile) :-
    later_duties(LaterDuties),
    append([attribute(dora_entity_type, exempted_payment_institution)|Extra], [attribute(simplified_framework_in_place_and_maintained, FrameworkValue)|LaterDuties], Profile).

qualification_of(Attributes, Result) :-
    simplified_framework_qualification(Attributes, Result, _).

members_attributes(Members, [attribute(dora_entity_type, institution_for_occupational_retirement_provision), attribute(iorp_pension_scheme_members_total, Members)]).

test(the_status_table_has_a_near_miss_atom) :-
    dora_proportionality_and_simplified_framework_status_values(StatusValues),
    StatusValues = [_, _|_].
test(an_exempted_payment_institution_qualifies) :-
    qualification_of([attribute(dora_entity_type, exempted_payment_institution)], article_16_1_entity).
test(a_payment_institution_does_not_qualify) :-
    qualification_of([attribute(dora_entity_type, payment_institution)], not_article_16_1_entity).
test(an_exempted_electronic_money_institution_qualifies) :-
    qualification_of([attribute(dora_entity_type, exempted_electronic_money_institution)], article_16_1_entity).
test(an_electronic_money_institution_does_not_qualify) :-
    qualification_of([attribute(dora_entity_type, electronic_money_institution)], not_article_16_1_entity).
test(a_small_investment_firm_qualifies) :-
    qualification_of([attribute(dora_entity_type, investment_firm), attribute(investment_firm_is_small_and_non_interconnected, true)], article_16_1_entity).
test(an_investment_firm_not_small_does_not_qualify) :-
    qualification_of([attribute(dora_entity_type, investment_firm), attribute(investment_firm_is_small_and_non_interconnected, false)], not_article_16_1_entity).
test(fifteen_members_is_out_of_scope) :-
    members_attributes(15, Attributes),
    qualification_of(Attributes, out_of_scope).
test(sixteen_members_qualifies) :-
    members_attributes(16, Attributes),
    qualification_of(Attributes, article_16_1_entity).
test(ninety_nine_members_qualifies) :-
    members_attributes(99, Attributes),
    qualification_of(Attributes, article_16_1_entity).
test(one_hundred_members_does_not_qualify) :-
    members_attributes(100, Attributes),
    qualification_of(Attributes, not_article_16_1_entity).
test(a_directive_institution_not_excluded_qualifies) :-
    qualification_of([attribute(dora_entity_type, institution_exempted_pursuant_to_directive_2013_36), attribute(exempted_from_dora_scope_by_member_state, false)], article_16_1_entity).
test(a_directive_institution_excluded_is_out_of_scope) :-
    qualification_of([attribute(dora_entity_type, institution_exempted_pursuant_to_directive_2013_36), attribute(exempted_from_dora_scope_by_member_state, true)], out_of_scope).
test(an_ict_third_party_service_provider_is_not_a_financial_entity) :-
    qualification_of([attribute(dora_entity_type, ict_third_party_service_provider)], not_a_financial_entity).
test(an_unlisted_type_is_out_of_scope) :-
    qualification_of([attribute(dora_entity_type, none_of_the_listed_types)], out_of_scope).
test(every_duty_performed_is_complete) :-
    payment_profile([attribute(authority_requested_framework_review_report, false)], true, Profile),
    simplified_framework_duties_complete(Profile, complete, _).
test(one_duty_not_performed_is_incomplete) :-
    payment_profile([attribute(authority_requested_framework_review_report, false)], false, Profile),
    simplified_framework_duties_complete(Profile, incomplete, _).
test(a_requested_and_submitted_report_is_complete) :-
    payment_profile([attribute(authority_requested_framework_review_report, true), attribute(simplified_framework_review_report_submitted, true)], true, Profile),
    simplified_framework_duties_complete(Profile, complete, _).
test(a_requested_report_not_submitted_is_incomplete) :-
    payment_profile([attribute(authority_requested_framework_review_report, true), attribute(simplified_framework_review_report_submitted, false)], true, Profile),
    simplified_framework_duties_complete(Profile, incomplete, _).
test(an_unrequested_report_not_submitted_is_complete) :-
    payment_profile([attribute(authority_requested_framework_review_report, false), attribute(simplified_framework_review_report_submitted, false)], true, Profile),
    simplified_framework_duties_complete(Profile, complete, _).
test(an_unsent_report_asks_for_the_trigger) :-
    payment_profile([attribute(simplified_framework_review_report_submitted, false)], true, Profile),
    simplified_framework_duties_complete(Profile, indeterminate([authority_requested_framework_review_report]), []).
test(a_sent_report_needs_no_trigger) :-
    payment_profile([attribute(simplified_framework_review_report_submitted, true)], true, Profile),
    simplified_framework_duties_complete(Profile, complete, _).
test(an_unsent_report_puts_the_trigger_before_an_absent_duty) :-
    later_duties(LaterDuties),
    simplified_framework_duties_complete([attribute(dora_entity_type, exempted_payment_institution), attribute(simplified_framework_review_report_submitted, false)|LaterDuties], indeterminate([authority_requested_framework_review_report]), []).
test(an_absent_report_puts_an_absent_duty_before_the_trigger) :-
    later_duties(LaterDuties),
    simplified_framework_duties_complete([attribute(dora_entity_type, exempted_payment_institution)|LaterDuties], indeterminate([simplified_framework_in_place_and_maintained]), []).
test(an_unsure_duty_is_referred) :-
    payment_profile([attribute(authority_requested_framework_review_report, false)], unsure, Profile),
    simplified_framework_duties_complete(Profile, needs_legal_review(open_textured(simplified_framework_in_place_and_maintained, cite(eu_reg_2022_2554_art_16_1_a)), _), []).
test(an_unsure_duty_beside_a_false_one_is_incomplete) :-
    later_duties([_|OtherDuties]),
    simplified_framework_duties_complete([attribute(dora_entity_type, exempted_payment_institution), attribute(simplified_framework_in_place_and_maintained, unsure), attribute(ict_systems_continuously_monitored, false)|OtherDuties], incomplete, _).
test(a_requested_report_is_required) :-
    simplified_framework_duties_required([attribute(dora_entity_type, exempted_payment_institution), attribute(authority_requested_framework_review_report, true)], required(Duties), _),
    length(Duties, 12),
    member(review_report_to_authority, Duties).
test(an_unrequested_report_leaves_eleven_duties) :-
    simplified_framework_duties_required([attribute(dora_entity_type, exempted_payment_institution), attribute(authority_requested_framework_review_report, false)], required(Duties), _),
    length(Duties, 11).
test(another_entity_gets_the_qualification_passed_on) :-
    simplified_framework_duties_required([attribute(dora_entity_type, credit_institution), attribute(authority_requested_framework_review_report, true)], not_article_16_1_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(a_failing_duty_is_outstanding) :-
    payment_profile([attribute(authority_requested_framework_review_report, false)], false, Profile),
    simplified_framework_duties_outstanding(Profile, outstanding([simplified_ict_risk_management_framework]), _).
test(no_failing_duty_is_none_outstanding) :-
    payment_profile([attribute(authority_requested_framework_review_report, false)], true, Profile),
    simplified_framework_duties_outstanding(Profile, none_outstanding, _).
test(a_false_duty_does_not_end_the_outstanding_query) :-
    later_duties(LaterDuties),
    simplified_framework_duties_outstanding([attribute(dora_entity_type, exempted_payment_institution), attribute(simplified_framework_in_place_and_maintained, false)|LaterDuties], indeterminate([authority_requested_framework_review_report]), []).
test(a_well_formed_profile_has_no_problem) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(dora_entity_type, exempted_payment_institution)], []).
test(a_misspelt_type_is_wrong_type) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(dora_entity_type, exempted_payment_institutions)], [wrong_type(dora_entity_type)]).
test(a_stray_key_is_unknown) :-
    dora_proportionality_and_simplified_framework_input_problems([attribute(dora_entity_type, exempted_payment_institution), attribute(entity_size, small)], [unknown_key(entity_size)]).
test(the_facade_flips_on_the_fixture_near_miss) :-
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_all_duties_performed, Profile),
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_framework_not_performed, NearMiss),
    dora_proportionality_and_simplified_framework_status(Profile, complete),
    dora_proportionality_and_simplified_framework_status(NearMiss, incomplete).

test(a_payment_institution_is_never_article_16_1_entity, fail) :-
    qualification_of([attribute(dora_entity_type, payment_institution)], article_16_1_entity).
test(an_electronic_money_institution_is_never_article_16_1_entity, fail) :-
    qualification_of([attribute(dora_entity_type, electronic_money_institution)], article_16_1_entity).
test(an_investment_firm_not_small_is_never_article_16_1_entity, fail) :-
    qualification_of([attribute(dora_entity_type, investment_firm), attribute(investment_firm_is_small_and_non_interconnected, false)], article_16_1_entity).
test(sixteen_members_is_not_out_of_scope, fail) :-
    members_attributes(16, Attributes),
    qualification_of(Attributes, out_of_scope).
test(one_hundred_members_is_never_article_16_1_entity, fail) :-
    members_attributes(100, Attributes),
    qualification_of(Attributes, article_16_1_entity).
test(an_excluded_directive_institution_is_never_article_16_1_entity, fail) :-
    qualification_of([attribute(dora_entity_type, institution_exempted_pursuant_to_directive_2013_36), attribute(exempted_from_dora_scope_by_member_state, true)], article_16_1_entity).
test(an_unlisted_type_is_never_not_a_financial_entity, fail) :-
    qualification_of([attribute(dora_entity_type, none_of_the_listed_types)], not_a_financial_entity).
test(an_ict_third_party_service_provider_is_never_out_of_scope, fail) :-
    qualification_of([attribute(dora_entity_type, ict_third_party_service_provider)], out_of_scope).
test(one_duty_not_performed_is_never_complete, fail) :-
    payment_profile([attribute(authority_requested_framework_review_report, false)], false, Profile),
    simplified_framework_duties_complete(Profile, complete, _).
test(a_requested_report_not_submitted_is_never_complete, fail) :-
    payment_profile([attribute(authority_requested_framework_review_report, true), attribute(simplified_framework_review_report_submitted, false)], true, Profile),
    simplified_framework_duties_complete(Profile, complete, _).
test(a_sent_report_never_asks_for_the_trigger, fail) :-
    payment_profile([attribute(simplified_framework_review_report_submitted, true)], true, Profile),
    simplified_framework_duties_complete(Profile, indeterminate(_), _).
test(an_unsure_duty_is_never_complete, fail) :-
    payment_profile([attribute(authority_requested_framework_review_report, false)], unsure, Profile),
    simplified_framework_duties_complete(Profile, complete, _).
test(an_unrequested_report_is_never_required, fail) :-
    simplified_framework_duties_required([attribute(dora_entity_type, exempted_payment_institution), attribute(authority_requested_framework_review_report, false)], required(Duties), _),
    member(review_report_to_authority, Duties).
test(another_entity_has_no_duty_list, fail) :-
    simplified_framework_duties_required([attribute(dora_entity_type, credit_institution), attribute(authority_requested_framework_review_report, true)], required(_), _).
test(no_failing_duty_has_no_outstanding_list, fail) :-
    payment_profile([attribute(authority_requested_framework_review_report, false)], true, Profile),
    simplified_framework_duties_outstanding(Profile, outstanding(_), _).
test(a_misspelt_type_gets_no_qualification, fail) :-
    qualification_of([attribute(dora_entity_type, exempted_payment_institutions)], article_16_1_entity).
test(the_fixture_near_miss_is_never_complete, fail) :-
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_framework_not_performed, NearMiss),
    dora_proportionality_and_simplified_framework_status(NearMiss, complete).

cp_test_names([the_status_table_has_a_near_miss_atom, an_exempted_payment_institution_qualifies, a_payment_institution_does_not_qualify, an_exempted_electronic_money_institution_qualifies, an_electronic_money_institution_does_not_qualify, a_small_investment_firm_qualifies, an_investment_firm_not_small_does_not_qualify, fifteen_members_is_out_of_scope, sixteen_members_qualifies, ninety_nine_members_qualifies, one_hundred_members_does_not_qualify, a_directive_institution_not_excluded_qualifies, a_directive_institution_excluded_is_out_of_scope, an_ict_third_party_service_provider_is_not_a_financial_entity, an_unlisted_type_is_out_of_scope, every_duty_performed_is_complete, one_duty_not_performed_is_incomplete, a_requested_and_submitted_report_is_complete, a_requested_report_not_submitted_is_incomplete, an_unrequested_report_not_submitted_is_complete, an_unsent_report_asks_for_the_trigger, a_sent_report_needs_no_trigger, an_unsent_report_puts_the_trigger_before_an_absent_duty, an_absent_report_puts_an_absent_duty_before_the_trigger, an_unsure_duty_is_referred, an_unsure_duty_beside_a_false_one_is_incomplete, a_requested_report_is_required, an_unrequested_report_leaves_eleven_duties, another_entity_gets_the_qualification_passed_on, a_failing_duty_is_outstanding, no_failing_duty_is_none_outstanding, a_false_duty_does_not_end_the_outstanding_query, a_well_formed_profile_has_no_problem, a_misspelt_type_is_wrong_type, a_stray_key_is_unknown, the_facade_flips_on_the_fixture_near_miss]).
cp_test_fail_names([a_payment_institution_is_never_article_16_1_entity, an_electronic_money_institution_is_never_article_16_1_entity, an_investment_firm_not_small_is_never_article_16_1_entity, sixteen_members_is_not_out_of_scope, one_hundred_members_is_never_article_16_1_entity, an_excluded_directive_institution_is_never_article_16_1_entity, an_unlisted_type_is_never_not_a_financial_entity, an_ict_third_party_service_provider_is_never_out_of_scope, one_duty_not_performed_is_never_complete, a_requested_report_not_submitted_is_never_complete, a_sent_report_never_asks_for_the_trigger, an_unsure_duty_is_never_complete, an_unrequested_report_is_never_required, another_entity_has_no_duty_list, no_failing_duty_has_no_outstanding_list, a_misspelt_type_gets_no_qualification, the_fixture_near_miss_is_never_complete]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
