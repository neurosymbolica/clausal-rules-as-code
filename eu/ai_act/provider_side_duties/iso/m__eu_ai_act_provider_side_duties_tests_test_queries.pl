% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_provider_side_duties_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_provider_side_duties_queries, [provider_side_duties_profile_keys/1, provider_side_duties_what_if/4, provider_side_duties_compliance_check/3, provider_side_duties_obligations/3]).
:- use_module(m__eu_ai_act_provider_side_duties_kernel, [provider_side_duties_input_problems/2]).
:- use_module(m__eu_ai_act_provider_side_duties_provider_side_duties, [provider_side_duties_status/2, provider_side_duties_checklist/2]).
:- use_module(m__eu_ai_act_provider_side_duties_fixtures, [provider_side_duties_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    provider_side_duties_profile_keys(ProfileKeys),
    ProfileKeys == [ai_system, high_risk_ai_system, high_risk_route, actor_role, component_of_a_large_scale_it_system_listed_in_annex_x, placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_date_of_application_of_chapter_iii, significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, intended_to_be_used_by_public_authorities, provider_established_in_a_third_country, logs_under_the_providers_control, reasoned_request_from_a_competent_authority, request_from_a_market_surveillance_authority_for_a_copy_of_the_mandate, competent_authority_action_in_relation_to_the_system, system_under_the_operators_responsibility, provider_considers_or_has_reason_to_consider_the_system_not_in_conformity, presents_a_risk_within_the_meaning_of_article_79_1, provider_aware_of_the_risk, representative_considers_or_has_reason_to_consider_the_provider_acting_contrary_to_its_obligations, importer_has_sufficient_reason_to_consider_the_system_not_in_conformity_or_falsified, distributor_considers_or_has_reason_to_consider_the_system_not_in_conformity, distributor_has_made_the_system_available_on_the_market].
test(the_reexported_input_check) :-
    provider_side_duties_input_problems([attribute(actor_role, captain), attribute(colour, blue)], [wrong_type(actor_role), unknown_key(colour)]).
test(status_determination_has_one_answer) :-
    provider_side_duties_profile_for(fixture_provider_asks_a_provider_duty, Case),
    findall(Status, provider_side_duties_status(Case, Status), Statuses),
    Statuses == [duty_applies].
test(the_checklist_item_carries_its_citations) :-
    provider_side_duties_profile_for(fixture_importer_asks_a_provider_duty, Case),
    provider_side_duties_checklist(Case, [item(quality_management_system, not_the_addressee_of_the_duty, Citations)]),
    sort([cite(eu_reg_2024_1689_art_16_c), cite(eu_reg_2024_1689_art_3_3)], Expected),
    Citations == Expected.
test(omitting_an_applicable_duty_is_non_compliant) :-
    provider_side_duties_profile_for(fixture_provider_asks_a_provider_duty, Case),
    findall(Verdict, provider_side_duties_compliance_check(Case, omit_duty, Verdict), Verdicts),
    Verdicts == [non_compliant].
test(omitting_an_untriggered_duty_is_compliant) :-
    provider_side_duties_profile_for(fixture_logs_not_under_the_providers_control, Case),
    provider_side_duties_compliance_check(Case, omit_duty, compliant).
test(performing_a_duty_is_compliant) :-
    provider_side_duties_profile_for(fixture_provider_asks_a_provider_duty, Case),
    provider_side_duties_compliance_check(Case, perform_duty, compliant).
test(a_referral_passes_through_the_compliance_check) :-
    provider_side_duties_profile_for(fixture_unsure_risk_referral, Case),
    provider_side_duties_compliance_check(Case, omit_duty, Verdict),
    Verdict = needs_legal_review(open_textured(Key, _), _),
    Key == presents_a_risk_within_the_meaning_of_article_79_1.
test(an_unknown_action_is_an_input_problem) :-
    provider_side_duties_profile_for(fixture_provider_asks_a_provider_duty, Case),
    provider_side_duties_compliance_check(Case, postpone_duty, input_problems([wrong_type(action)])).
test(the_provider_owes_its_unconditional_duties_and_ai_literacy) :-
    provider_side_duties_profile_for(fixture_provider_asks_a_provider_duty, duty_case(Profile, _, _)),
    findall(Duties, provider_side_duties_obligations(Profile, date(2029, 1, 1), Duties), AllDuties),
    AllDuties == [[compliance_with_the_requirements_of_section_2, provider_name_and_contact_address, quality_management_system, documentation_keeping, log_keeping, conformity_assessment_before_placing_on_the_market, eu_declaration_of_conformity, ce_marking, registration, accessibility_requirements, ai_literacy_measures]].
test(a_deployer_owes_only_ai_literacy) :-
    provider_side_duties_profile_for(fixture_ai_literacy_deployer_applies, duty_case(Profile, _, _)),
    provider_side_duties_obligations(Profile, date(2029, 1, 1), Duties),
    Duties == [ai_literacy_measures].
test(before_chapter_i_nothing_is_owed) :-
    provider_side_duties_profile_for(fixture_ai_literacy_deployer_applies, duty_case(Profile, _, _)),
    provider_side_duties_obligations(Profile, date(2025, 2, 1), []).
test(what_if_logs_come_under_control) :-
    provider_side_duties_profile_for(fixture_logs_not_under_the_providers_control, Case),
    provider_side_duties_what_if(Case, logs_under_the_providers_control, true, NewStatus),
    NewStatus == duty_applies.
test(what_if_the_unsure_risk_is_settled) :-
    provider_side_duties_profile_for(fixture_unsure_risk_referral, Case),
    provider_side_duties_what_if(Case, presents_a_risk_within_the_meaning_of_article_79_1, false, NewStatus),
    NewStatus == duty_not_triggered.
test(what_if_resolves_a_duplicate_key) :-
    provider_side_duties_what_if(duty_case([attribute(actor_role, provider), attribute(actor_role, deployer), attribute(ai_system, true)], ai_literacy_measures, date(2027, 1, 1)), actor_role, deployer, NewStatus),
    NewStatus == duty_applies.
test(what_if_keeps_a_non_list_profile_as_an_input_problem) :-
    provider_side_duties_what_if(duty_case(profile, ce_marking, date(2029, 1, 1)), actor_role, provider, NewStatus),
    NewStatus == input_problems([wrong_type(profile)]).

test(omitting_an_applicable_duty_is_not_compliant, fail) :-
    provider_side_duties_profile_for(fixture_provider_asks_a_provider_duty, Case),
    provider_side_duties_compliance_check(Case, omit_duty, compliant).

cp_test_names([profile_keys_are_the_contract_keys, the_reexported_input_check, status_determination_has_one_answer, the_checklist_item_carries_its_citations, omitting_an_applicable_duty_is_non_compliant, omitting_an_untriggered_duty_is_compliant, performing_a_duty_is_compliant, a_referral_passes_through_the_compliance_check, an_unknown_action_is_an_input_problem, the_provider_owes_its_unconditional_duties_and_ai_literacy, a_deployer_owes_only_ai_literacy, before_chapter_i_nothing_is_owed, what_if_logs_come_under_control, what_if_the_unsure_risk_is_settled, what_if_resolves_a_duplicate_key, what_if_keeps_a_non_list_profile_as_an_input_problem]).
cp_test_fail_names([omitting_an_applicable_duty_is_not_compliant]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
