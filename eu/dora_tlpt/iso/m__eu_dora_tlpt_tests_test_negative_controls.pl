% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_tlpt_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_tlpt_dora_tlpt, [tlpt_identification_basis/3, tlpt_duty/3]).
:- use_module(m__eu_dora_tlpt_fixtures, [dora_tlpt_profile_for/2]).

identification_of(Subject, Result) :-
    dora_tlpt_profile_for(Subject, Profile),
    tlpt_identification_basis(Profile, Result, _).

duty_of(Subject, Result) :-
    dora_tlpt_profile_for(Subject, Profile),
    tlpt_duty(Profile, Result, _).

test(a_float_premium_is_an_input_problem) :-
    identification_of(float_premium_figure, input_problems([wrong_type(gross_written_premium_eur)])).
test(an_integer_premium_is_no_input_problem) :-
    tlpt_identification_basis([attribute(gross_written_premium_eur, 1500000000)], indeterminate([financial_entity_is_article_16_1_entity]), []).
test(an_unknown_key_refuses_the_duty) :-
    duty_of(unknown_key_present, input_problems([unknown_key(colour_of_logo)])).
test(without_the_unknown_key_the_duty_answers) :-
    tlpt_duty([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false)], indeterminate([identified_by_tlpt_authority_as_required_to_perform_tlpt]), []).
test(an_article_16_1_entity_is_excluded) :-
    identification_of(article_16_1_entity_identified, excluded_from_tlpt(article_16_1_entity)).
test(a_microenterprise_is_excluded_as_a_microenterprise) :-
    identification_of(microenterprise_identified, excluded_from_tlpt(microenterprise)).
test(without_carve_outs_a_trading_venue_is_asked_its_system) :-
    tlpt_identification_basis([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, trading_venue)], indeterminate([trading_venue_has_electronic_trading_system]), []).
test(the_missing_article_16_1_fact_is_named) :-
    identification_of(article_16_1_fact_missing, indeterminate([financial_entity_is_article_16_1_entity])).
test(the_missing_microenterprise_fact_is_named) :-
    identification_of(microenterprise_fact_missing, indeterminate([financial_entity_is_microenterprise])).
test(a_stated_microenterprise_fact_lets_the_depository_be_listed) :-
    identification_of(central_securities_depository_identification_missing, listed_for_tlpt(point_d)).
test(the_missing_type_is_named) :-
    identification_of(entity_type_missing_not_identified, indeterminate([dora_entity_type])).
test(a_trade_repository_is_not_listed) :-
    identification_of(trade_repository_identified, not_listed_for_tlpt).
test(a_depository_is_listed) :-
    identification_of(central_securities_depository_identified_standard_frequency, listed_for_tlpt(point_d)).
test(an_exempted_payment_institution_is_not_listed_whatever_its_figures) :-
    tlpt_identification_basis([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, exempted_payment_institution), attribute(payment_transactions_total_value_eur_first_preceding_calendar_year, 200000000000), attribute(payment_transactions_total_value_eur_second_preceding_calendar_year, 200000000000)], not_listed_for_tlpt, _).
test(a_payment_institution_with_the_same_figures_is_listed) :-
    tlpt_identification_basis([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, payment_institution), attribute(payment_transactions_total_value_eur_first_preceding_calendar_year, 200000000000), attribute(payment_transactions_total_value_eur_second_preceding_calendar_year, 200000000000)], listed_for_tlpt(point_b), _).
test(a_missing_second_year_is_named) :-
    identification_of(payment_institution_second_year_missing, indeterminate([payment_transactions_total_value_eur_second_preceding_calendar_year])).
test(with_both_years_the_payment_institution_is_listed) :-
    identification_of(payment_institution_above_threshold_both_years, listed_for_tlpt(point_b)).
test(a_systemic_credit_institution_is_listed_under_point_a) :-
    identification_of(systemic_credit_institution, listed_for_tlpt(point_a)).
test(a_non_systemic_credit_institution_is_not_listed) :-
    identification_of(non_systemic_credit_institution, not_listed_for_tlpt).
test(payments_at_the_threshold_are_not_listed) :-
    identification_of(payment_institution_at_threshold_first_year, not_listed_for_tlpt).
test(an_electronic_money_institution_with_mixed_figures_is_listed) :-
    identification_of(electronic_money_institution_mixed_figures, listed_for_tlpt(point_c)).
test(electronic_money_at_the_threshold_is_not_listed) :-
    identification_of(electronic_money_institution_at_money_threshold, not_listed_for_tlpt).
test(a_central_counterparty_is_listed_under_point_e) :-
    identification_of(central_counterparty_not_identified, listed_for_tlpt(point_e)).
test(an_electronic_national_leader_is_listed_under_point_f) :-
    identification_of(trading_venue_electronic_national_leader, listed_for_tlpt(point_f)).
test(a_venue_without_an_electronic_system_is_not_listed) :-
    identification_of(trading_venue_without_electronic_system, not_listed_for_tlpt).
test(a_life_insurer_above_the_subset_share_is_listed) :-
    identification_of(life_insurer_above_subset_share, listed_for_tlpt(point_g)).
test(a_life_insurer_at_the_subset_share_is_not_listed) :-
    identification_of(life_insurer_at_subset_share, not_listed_for_tlpt).
test(a_non_life_insurer_above_the_second_list_share_is_listed) :-
    identification_of(non_life_insurer_above_second_list_share, listed_for_tlpt(point_g)).
test(a_non_life_insurer_at_the_second_list_share_is_not_listed) :-
    identification_of(non_life_insurer_at_second_list_share, not_listed_for_tlpt).
test(a_reinsurer_above_the_second_list_provisions_is_listed) :-
    identification_of(reinsurer_above_second_list_provisions, listed_for_tlpt(point_g)).
test(a_reinsurer_at_the_second_list_provisions_is_not_listed) :-
    identification_of(reinsurer_at_second_list_provisions, not_listed_for_tlpt).
test(a_reinsurer_above_the_subset_premium_is_listed) :-
    identification_of(reinsurer_above_subset_premium, listed_for_tlpt(point_g)).
test(a_reinsurer_at_the_subset_premium_is_not_listed) :-
    identification_of(reinsurer_at_subset_premium, not_listed_for_tlpt).
test(a_reinsurer_above_the_subset_provisions_is_listed) :-
    identification_of(reinsurer_above_subset_provisions, listed_for_tlpt(point_g)).
test(a_reinsurer_at_the_subset_provisions_is_not_listed) :-
    identification_of(reinsurer_at_subset_provisions, not_listed_for_tlpt).
test(a_reinsurer_above_the_second_list_premium_is_listed) :-
    identification_of(reinsurer_above_second_list_premium, listed_for_tlpt(point_g)).
test(a_reinsurer_at_the_second_list_premium_is_not_listed) :-
    identification_of(reinsurer_at_second_list_premium, not_listed_for_tlpt).
test(an_article_16_1_entity_has_no_duty) :-
    duty_of(article_16_1_entity_identified, no_tlpt_duty(article_16_1_entity)).
test(an_identified_microenterprise_has_no_duty) :-
    duty_of(microenterprise_identified, no_tlpt_duty(microenterprise)).
test(the_article_16_1_fact_is_asked_in_the_duty) :-
    duty_of(article_16_1_fact_missing, indeterminate([financial_entity_is_article_16_1_entity])).
test(the_microenterprise_fact_is_asked_in_the_duty) :-
    duty_of(microenterprise_fact_missing, indeterminate([financial_entity_is_microenterprise])).
test(a_listed_entity_not_identified_has_no_duty) :-
    duty_of(central_counterparty_not_identified, no_tlpt_duty(not_identified)).
test(an_identified_depository_must_test) :-
    duty_of(central_securities_depository_identified_standard_frequency, tlpt_required(at_least_every_three_years)).
test(a_missing_identification_is_named) :-
    duty_of(central_securities_depository_identification_missing, indeterminate([identified_by_tlpt_authority_as_required_to_perform_tlpt])).
test(a_stated_identification_names_the_frequency) :-
    duty_of(central_securities_depository_frequency_missing, indeterminate([tlpt_frequency_changed_by_competent_authority])).
test(a_changed_frequency_is_set_by_the_competent_authority) :-
    duty_of(central_securities_depository_identified_changed_frequency, tlpt_required(frequency_set_by_competent_authority)).

test(an_integer_premium_gives_no_input_problems, fail) :-
    tlpt_identification_basis([attribute(gross_written_premium_eur, 1500000000)], input_problems(_), _).
test(without_the_unknown_key_no_input_problems, fail) :-
    tlpt_duty([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false)], input_problems(_), _).
test(a_microenterprise_is_not_an_article_16_1_exclusion, fail) :-
    identification_of(microenterprise_identified, excluded_from_tlpt(article_16_1_entity)).
test(without_carve_outs_a_trading_venue_is_not_excluded, fail) :-
    tlpt_identification_basis([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, trading_venue)], excluded_from_tlpt(_), _).
test(a_stated_article_16_1_fact_is_not_asked, fail) :-
    identification_of(microenterprise_identified, indeterminate(_)).
test(a_stated_microenterprise_fact_is_not_asked, fail) :-
    identification_of(central_securities_depository_identification_missing, indeterminate([financial_entity_is_microenterprise])).
test(a_stated_type_is_not_asked, fail) :-
    identification_of(central_securities_depository_identification_missing, indeterminate([dora_entity_type])).
test(a_depository_is_not_unlisted, fail) :-
    identification_of(central_securities_depository_identified_standard_frequency, not_listed_for_tlpt).
test(an_exempted_payment_institution_is_not_under_point_b, fail) :-
    tlpt_identification_basis([attribute(financial_entity_is_article_16_1_entity, false), attribute(financial_entity_is_microenterprise, false), attribute(dora_entity_type, exempted_payment_institution), attribute(payment_transactions_total_value_eur_first_preceding_calendar_year, 200000000000), attribute(payment_transactions_total_value_eur_second_preceding_calendar_year, 200000000000)], listed_for_tlpt(_), _).
test(with_both_years_nothing_is_asked, fail) :-
    identification_of(payment_institution_above_threshold_both_years, indeterminate(_)).
test(a_non_systemic_credit_institution_is_not_under_point_a, fail) :-
    identification_of(non_systemic_credit_institution, listed_for_tlpt(_)).
test(payments_at_the_threshold_are_not_under_point_b, fail) :-
    identification_of(payment_institution_at_threshold_first_year, listed_for_tlpt(_)).
test(electronic_money_at_the_threshold_is_not_under_point_c, fail) :-
    identification_of(electronic_money_institution_at_money_threshold, listed_for_tlpt(_)).
test(a_venue_without_an_electronic_system_is_not_under_point_f, fail) :-
    identification_of(trading_venue_without_electronic_system, listed_for_tlpt(_)).
test(a_life_insurer_at_the_subset_share_is_not_under_point_g, fail) :-
    identification_of(life_insurer_at_subset_share, listed_for_tlpt(_)).
test(a_non_life_insurer_at_the_second_list_share_is_not_under_point_g, fail) :-
    identification_of(non_life_insurer_at_second_list_share, listed_for_tlpt(_)).
test(a_reinsurer_at_the_second_list_provisions_is_not_under_point_g, fail) :-
    identification_of(reinsurer_at_second_list_provisions, listed_for_tlpt(_)).
test(a_reinsurer_at_the_subset_premium_is_not_under_point_g, fail) :-
    identification_of(reinsurer_at_subset_premium, listed_for_tlpt(_)).
test(a_reinsurer_at_the_subset_provisions_is_not_under_point_g, fail) :-
    identification_of(reinsurer_at_subset_provisions, listed_for_tlpt(_)).
test(a_reinsurer_at_the_second_list_premium_is_not_under_point_g, fail) :-
    identification_of(reinsurer_at_second_list_premium, listed_for_tlpt(_)).
test(an_identified_microenterprise_is_not_required, fail) :-
    duty_of(microenterprise_identified, tlpt_required(_)).
test(a_stated_microenterprise_fact_is_not_asked_in_the_duty, fail) :-
    duty_of(central_securities_depository_identification_missing, indeterminate([financial_entity_is_microenterprise])).
test(an_identified_depository_is_not_unidentified, fail) :-
    duty_of(central_securities_depository_identified_standard_frequency, no_tlpt_duty(_)).
test(a_stated_identification_is_not_asked, fail) :-
    duty_of(central_securities_depository_frequency_missing, indeterminate([identified_by_tlpt_authority_as_required_to_perform_tlpt])).
test(a_stated_frequency_is_not_asked, fail) :-
    duty_of(central_securities_depository_identified_standard_frequency, indeterminate(_)).
test(a_changed_frequency_is_not_the_standard_frequency, fail) :-
    duty_of(central_securities_depository_identified_changed_frequency, tlpt_required(at_least_every_three_years)).
test(an_unchanged_frequency_is_not_set_by_the_authority, fail) :-
    duty_of(central_securities_depository_identified_standard_frequency, tlpt_required(frequency_set_by_competent_authority)).

cp_test_names([a_float_premium_is_an_input_problem, an_integer_premium_is_no_input_problem, an_unknown_key_refuses_the_duty, without_the_unknown_key_the_duty_answers, an_article_16_1_entity_is_excluded, a_microenterprise_is_excluded_as_a_microenterprise, without_carve_outs_a_trading_venue_is_asked_its_system, the_missing_article_16_1_fact_is_named, the_missing_microenterprise_fact_is_named, a_stated_microenterprise_fact_lets_the_depository_be_listed, the_missing_type_is_named, a_trade_repository_is_not_listed, a_depository_is_listed, an_exempted_payment_institution_is_not_listed_whatever_its_figures, a_payment_institution_with_the_same_figures_is_listed, a_missing_second_year_is_named, with_both_years_the_payment_institution_is_listed, a_systemic_credit_institution_is_listed_under_point_a, a_non_systemic_credit_institution_is_not_listed, payments_at_the_threshold_are_not_listed, an_electronic_money_institution_with_mixed_figures_is_listed, electronic_money_at_the_threshold_is_not_listed, a_central_counterparty_is_listed_under_point_e, an_electronic_national_leader_is_listed_under_point_f, a_venue_without_an_electronic_system_is_not_listed, a_life_insurer_above_the_subset_share_is_listed, a_life_insurer_at_the_subset_share_is_not_listed, a_non_life_insurer_above_the_second_list_share_is_listed, a_non_life_insurer_at_the_second_list_share_is_not_listed, a_reinsurer_above_the_second_list_provisions_is_listed, a_reinsurer_at_the_second_list_provisions_is_not_listed, a_reinsurer_above_the_subset_premium_is_listed, a_reinsurer_at_the_subset_premium_is_not_listed, a_reinsurer_above_the_subset_provisions_is_listed, a_reinsurer_at_the_subset_provisions_is_not_listed, a_reinsurer_above_the_second_list_premium_is_listed, a_reinsurer_at_the_second_list_premium_is_not_listed, an_article_16_1_entity_has_no_duty, an_identified_microenterprise_has_no_duty, the_article_16_1_fact_is_asked_in_the_duty, the_microenterprise_fact_is_asked_in_the_duty, a_listed_entity_not_identified_has_no_duty, an_identified_depository_must_test, a_missing_identification_is_named, a_stated_identification_names_the_frequency, a_changed_frequency_is_set_by_the_competent_authority]).
cp_test_fail_names([an_integer_premium_gives_no_input_problems, without_the_unknown_key_no_input_problems, a_microenterprise_is_not_an_article_16_1_exclusion, without_carve_outs_a_trading_venue_is_not_excluded, a_stated_article_16_1_fact_is_not_asked, a_stated_microenterprise_fact_is_not_asked, a_stated_type_is_not_asked, a_depository_is_not_unlisted, an_exempted_payment_institution_is_not_under_point_b, with_both_years_nothing_is_asked, a_non_systemic_credit_institution_is_not_under_point_a, payments_at_the_threshold_are_not_under_point_b, electronic_money_at_the_threshold_is_not_under_point_c, a_venue_without_an_electronic_system_is_not_under_point_f, a_life_insurer_at_the_subset_share_is_not_under_point_g, a_non_life_insurer_at_the_second_list_share_is_not_under_point_g, a_reinsurer_at_the_second_list_provisions_is_not_under_point_g, a_reinsurer_at_the_subset_premium_is_not_under_point_g, a_reinsurer_at_the_subset_provisions_is_not_under_point_g, a_reinsurer_at_the_second_list_premium_is_not_under_point_g, an_identified_microenterprise_is_not_required, a_stated_microenterprise_fact_is_not_asked_in_the_duty, an_identified_depository_is_not_unidentified, a_stated_identification_is_not_asked, a_stated_frequency_is_not_asked, a_changed_frequency_is_not_the_standard_frequency, an_unchanged_frequency_is_not_set_by_the_authority]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
