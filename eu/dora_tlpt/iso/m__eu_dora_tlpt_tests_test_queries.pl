% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_tlpt_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_tlpt_queries, [dora_tlpt_profile_keys/1, dora_tlpt_what_if/4, listed_for_tlpt/1, no_tlpt_duty/1, tlpt_required/1, excluded_from_tlpt/1, indeterminate/1, input_problems/1]).
:- use_module(m__eu_dora_tlpt_dora_tlpt, [tlpt_identification_basis/3, tlpt_duty/3]).
:- use_module(m__eu_dora_tlpt_kernel, [dora_tlpt_input_problems/2]).
:- use_module(m__eu_dora_tlpt_dora_tlpt, [decide_dora_tlpt/2, dora_tlpt_status/2, dora_tlpt_checklist/2]).
:- use_module(m__eu_dora_tlpt_fixtures, [dora_tlpt_profile_for/2]).

checklist_row_cited(item(_, _, cite(_))).

test(profile_keys_are_the_contract_keys) :-
    dora_tlpt_profile_keys(ProfileKeys),
    ProfileKeys == [financial_entity_is_article_16_1_entity, financial_entity_is_microenterprise, dora_entity_type, credit_institution_is_or_is_part_of_g_sii_or_o_sii, payment_transactions_total_value_eur_first_preceding_calendar_year, payment_transactions_total_value_eur_second_preceding_calendar_year, outstanding_electronic_money_eur_first_preceding_calendar_year, outstanding_electronic_money_eur_second_preceding_calendar_year, trading_venue_has_electronic_trading_system, trading_venue_has_highest_national_turnover_share_in_both_preceding_years, trading_venue_union_turnover_share_exceeds_5_percent_in_both_preceding_years, insurance_undertaking_activities, gross_written_premium_eur, technical_provisions_eur, total_assets_share_of_member_state_insurance_sector_basis_points, identified_by_tlpt_authority_as_required_to_perform_tlpt, tlpt_frequency_changed_by_competent_authority].
test(the_eligibility_status_is_the_duty) :-
    dora_tlpt_profile_for(central_securities_depository_identified_standard_frequency, Profile),
    dora_tlpt_status(Profile, Status),
    tlpt_duty(Profile, Status, _),
    Status == tlpt_required(at_least_every_three_years).
test(the_eligibility_verdict_carries_the_duty_citations) :-
    dora_tlpt_profile_for(central_counterparty_not_identified, Profile),
    decide_dora_tlpt(Profile, dora_tlpt_verdict(no_tlpt_duty(not_identified), [cite(eu_reg_2022_2554_art_26_1), cite(eu_reg_2022_2554_art_26_8)])).
test(an_indeterminate_verdict_carries_no_citation) :-
    dora_tlpt_profile_for(central_securities_depository_frequency_missing, Profile),
    decide_dora_tlpt(Profile, dora_tlpt_verdict(indeterminate([tlpt_frequency_changed_by_competent_authority]), [])).
test(the_checklist_cites_each_row) :-
    dora_tlpt_profile_for(central_counterparty_not_identified, Profile),
    dora_tlpt_checklist(Profile, Rows),
    maplist(checklist_row_cited, Rows),
    Rows = [item(not_article_16_1_entity, met, _), item(not_microenterprise, met, _), item(listed_in_article_2_2, met, cite(eu_reg_2025_1190_art_2_2)), item(identified_by_tlpt_authority, unmet(not_identified), cite(eu_reg_2022_2554_art_26_8))].
test(the_checklist_marks_an_unlisted_type) :-
    dora_tlpt_profile_for(trade_repository_identified, Profile),
    dora_tlpt_checklist(Profile, [_, _, item(listed_in_article_2_2, unmet(not_listed_for_tlpt), cite(eu_reg_2025_1190_art_2_2)), item(identified_by_tlpt_authority, met, _)]).
test(the_checklist_marks_a_missing_fact_unknown) :-
    dora_tlpt_profile_for(central_securities_depository_identification_missing, Profile),
    dora_tlpt_checklist(Profile, [_, _, _, item(identified_by_tlpt_authority, unknown([identified_by_tlpt_authority_as_required_to_perform_tlpt]), _)]).
test(the_what_if_identifies_a_listed_entity) :-
    dora_tlpt_profile_for(central_counterparty_not_identified, Profile),
    dora_tlpt_what_if(Profile, identified_by_tlpt_authority_as_required_to_perform_tlpt, true, indeterminate([tlpt_frequency_changed_by_competent_authority])).
test(the_what_if_of_the_type_leaves_the_duty) :-
    dora_tlpt_profile_for(central_securities_depository_identified_standard_frequency, Profile),
    dora_tlpt_what_if(Profile, dora_entity_type, investment_firm, tlpt_required(at_least_every_three_years)).
test(the_what_if_replaces_every_copy_of_a_duplicate_key) :-
    dora_tlpt_what_if([attribute(financial_entity_is_article_16_1_entity, true), attribute(financial_entity_is_article_16_1_entity, false)], financial_entity_is_article_16_1_entity, true, no_tlpt_duty(article_16_1_entity)).
test(a_duplicate_key_without_the_what_if_is_an_input_problem) :-
    dora_tlpt_status([attribute(financial_entity_is_article_16_1_entity, true), attribute(financial_entity_is_article_16_1_entity, false)], input_problems([duplicate_key(financial_entity_is_article_16_1_entity)])).
test(the_what_if_of_a_wrong_value_is_an_input_problem) :-
    dora_tlpt_what_if([attribute(financial_entity_is_article_16_1_entity, false)], financial_entity_is_microenterprise, unsure, input_problems([wrong_type(financial_entity_is_microenterprise)])).
test(the_what_if_yields_one_status) :-
    dora_tlpt_profile_for(central_securities_depository_frequency_missing, Profile),
    findall(NewStatus, dora_tlpt_what_if(Profile, tlpt_frequency_changed_by_competent_authority, true, NewStatus), Statuses),
    Statuses == [tlpt_required(frequency_set_by_competent_authority)].
test(the_reexported_identification_answers_once) :-
    findall(Result - Citations, tlpt_identification_basis([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, credit_institution), attribute(credit_institution_is_or_is_part_of_g_sii_or_o_sii, true)], Result, Citations), Answers),
    Answers == [listed_for_tlpt(point_a) - [cite(eu_reg_2025_1190_art_2_2), cite(eu_reg_2025_1190_art_2_2_a)]].
test(the_reexported_input_check_answers) :-
    dora_tlpt_input_problems([attribute(dora_entity_type, bank)], [wrong_type(dora_entity_type)]).
test(every_listed_answer_is_a_constructor_value) :-
    dora_tlpt_profile_for(trading_venue_electronic_national_leader, Profile),
    tlpt_identification_basis(Profile, listed_for_tlpt(Point), _),
    listed_for_tlpt(Point).
test(every_duty_ground_is_a_constructor_value) :-
    dora_tlpt_profile_for(microenterprise_identified, Profile),
    tlpt_duty(Profile, no_tlpt_duty(Ground), _),
    no_tlpt_duty(Ground),
    excluded_from_tlpt(Ground).
test(every_frequency_is_a_constructor_value) :-
    dora_tlpt_profile_for(central_securities_depository_identified_changed_frequency, Profile),
    tlpt_duty(Profile, tlpt_required(Frequency), _),
    tlpt_required(Frequency).
test(every_indeterminate_is_a_constructor_value) :-
    dora_tlpt_profile_for(payment_institution_second_year_missing, Profile),
    tlpt_identification_basis(Profile, indeterminate(MissingKeys), _),
    indeterminate(MissingKeys).
test(every_input_problems_is_a_constructor_value) :-
    dora_tlpt_profile_for(unknown_key_present, Profile),
    tlpt_duty(Profile, input_problems(Problems), _),
    input_problems(Problems).

test(not_identified_is_no_exclusion_ground, fail) :-
    excluded_from_tlpt(not_identified).

cp_test_names([profile_keys_are_the_contract_keys, the_eligibility_status_is_the_duty, the_eligibility_verdict_carries_the_duty_citations, an_indeterminate_verdict_carries_no_citation, the_checklist_cites_each_row, the_checklist_marks_an_unlisted_type, the_checklist_marks_a_missing_fact_unknown, the_what_if_identifies_a_listed_entity, the_what_if_of_the_type_leaves_the_duty, the_what_if_replaces_every_copy_of_a_duplicate_key, a_duplicate_key_without_the_what_if_is_an_input_problem, the_what_if_of_a_wrong_value_is_an_input_problem, the_what_if_yields_one_status, the_reexported_identification_answers_once, the_reexported_input_check_answers, every_listed_answer_is_a_constructor_value, every_duty_ground_is_a_constructor_value, every_frequency_is_a_constructor_value, every_indeterminate_is_a_constructor_value, every_input_problems_is_a_constructor_value]).
cp_test_fail_names([not_identified_is_no_exclusion_ground]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
