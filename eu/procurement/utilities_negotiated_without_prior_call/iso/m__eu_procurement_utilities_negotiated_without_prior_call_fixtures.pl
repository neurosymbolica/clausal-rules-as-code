:- module(m__eu_procurement_utilities_negotiated_without_prior_call_fixtures, [utilities_negotiated_without_prior_call_subject/1, utilities_negotiated_without_prior_call_profile_for/2, utilities_negotiated_without_prior_call_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_dicts, [dict_pairs/2]).
:- use_module(m__eu_procurement_utilities_negotiated_without_prior_call_utilities_negotiated_without_prior_call, [decide_utilities_negotiated_without_prior_call/2]).

utilities_negotiated_without_prior_call_subject("a_lawful").
utilities_negotiated_without_prior_call_subject("a_near_miss").
utilities_negotiated_without_prior_call_subject("b_lawful").
utilities_negotiated_without_prior_call_subject("b_near_miss").
utilities_negotiated_without_prior_call_subject("c_art_lawful").
utilities_negotiated_without_prior_call_subject("c_art_near_miss").
utilities_negotiated_without_prior_call_subject("c_tech_lawful").
utilities_negotiated_without_prior_call_subject("c_tech_near_miss").
utilities_negotiated_without_prior_call_subject("c_rights_lawful").
utilities_negotiated_without_prior_call_subject("c_rights_near_miss").
utilities_negotiated_without_prior_call_subject("d_lawful").
utilities_negotiated_without_prior_call_subject("d_near_miss").
utilities_negotiated_without_prior_call_subject("e_lawful").
utilities_negotiated_without_prior_call_subject("e_near_miss").
utilities_negotiated_without_prior_call_subject("f_lawful").
utilities_negotiated_without_prior_call_subject("f_near_miss").
utilities_negotiated_without_prior_call_subject("g_lawful").
utilities_negotiated_without_prior_call_subject("g_near_miss").
utilities_negotiated_without_prior_call_subject("h_lawful").
utilities_negotiated_without_prior_call_subject("h_near_miss").
utilities_negotiated_without_prior_call_subject("i_lawful").
utilities_negotiated_without_prior_call_subject("i_near_miss").
utilities_negotiated_without_prior_call_subject("j_lawful").
utilities_negotiated_without_prior_call_subject("j_near_miss").

utilities_negotiated_without_prior_call_profile_for("a_lawful", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_a_no_suitable_tenders, contract_type_key - services, no_suitable_tenders_or_requests_received - true, initial_conditions_not_substantially_altered - true]).
utilities_negotiated_without_prior_call_profile_for("a_near_miss", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_a_no_suitable_tenders, contract_type_key - services, no_suitable_tenders_or_requests_received - true, initial_conditions_not_substantially_altered - false]).
utilities_negotiated_without_prior_call_profile_for("b_lawful", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_b_research_contract, contract_type_key - services, contract_purely_for_research_experiment_study_or_development - true, not_for_securing_profit_or_recovering_research_costs - true, award_does_not_prejudice_competitive_award_of_subsequent_contracts - true]).
utilities_negotiated_without_prior_call_profile_for("b_near_miss", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_b_research_contract, contract_type_key - services, contract_purely_for_research_experiment_study_or_development - true, not_for_securing_profit_or_recovering_research_costs - true, award_does_not_prejudice_competitive_award_of_subsequent_contracts - false]).
utilities_negotiated_without_prior_call_profile_for("c_art_lawful", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_c_sole_operator, contract_type_key - works, sole_operator_reason_key - unique_artistic_work_or_performance, only_particular_operator_can_perform - true]).
utilities_negotiated_without_prior_call_profile_for("c_art_near_miss", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_c_sole_operator, contract_type_key - works, sole_operator_reason_key - unique_artistic_work_or_performance, only_particular_operator_can_perform - false]).
utilities_negotiated_without_prior_call_profile_for("c_tech_lawful", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_c_sole_operator, contract_type_key - works, sole_operator_reason_key - competition_absent_for_technical_reasons, only_particular_operator_can_perform - true, no_reasonable_alternative_or_substitute - true, absence_of_competition_not_artificially_narrowed - true]).
utilities_negotiated_without_prior_call_profile_for("c_tech_near_miss", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_c_sole_operator, contract_type_key - works, sole_operator_reason_key - competition_absent_for_technical_reasons, only_particular_operator_can_perform - true, no_reasonable_alternative_or_substitute - true, absence_of_competition_not_artificially_narrowed - false]).
utilities_negotiated_without_prior_call_profile_for("c_rights_lawful", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_c_sole_operator, contract_type_key - works, sole_operator_reason_key - protection_of_exclusive_rights, only_particular_operator_can_perform - true, no_reasonable_alternative_or_substitute - true, absence_of_competition_not_artificially_narrowed - true]).
utilities_negotiated_without_prior_call_profile_for("c_rights_near_miss", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_c_sole_operator, contract_type_key - works, sole_operator_reason_key - protection_of_exclusive_rights, only_particular_operator_can_perform - true, no_reasonable_alternative_or_substitute - false, absence_of_competition_not_artificially_narrowed - true]).
utilities_negotiated_without_prior_call_profile_for("d_lawful", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_d_extreme_urgency, contract_type_key - services, extreme_urgency_time_limits_cannot_be_met - true, urgency_events_unforeseeable_by_contracting_entity - true, urgency_not_attributable_to_contracting_entity - true]).
utilities_negotiated_without_prior_call_profile_for("d_near_miss", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_d_extreme_urgency, contract_type_key - services, extreme_urgency_time_limits_cannot_be_met - true, urgency_events_unforeseeable_by_contracting_entity - true, urgency_not_attributable_to_contracting_entity - false]).
utilities_negotiated_without_prior_call_profile_for("e_lawful", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_e_additional_deliveries, contract_type_key - supplies, additional_deliveries_by_original_supplier - true, change_of_supplier_would_cause_technical_incompatibility - true]).
utilities_negotiated_without_prior_call_profile_for("e_near_miss", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_e_additional_deliveries, contract_type_key - works, additional_deliveries_by_original_supplier - true, change_of_supplier_would_cause_technical_incompatibility - true]).
utilities_negotiated_without_prior_call_profile_for("f_lawful", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_f_repetition, contract_type_key - services, repetition_conforms_to_basic_project - true, original_contract_followed_article_44_1_procedure - true, basic_project_indicated_extent_and_conditions - true, possible_use_of_this_procedure_disclosed_at_first_tender - true]).
utilities_negotiated_without_prior_call_profile_for("f_near_miss", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_f_repetition, contract_type_key - supplies, repetition_conforms_to_basic_project - true, original_contract_followed_article_44_1_procedure - true, basic_project_indicated_extent_and_conditions - true, possible_use_of_this_procedure_disclosed_at_first_tender - true]).
utilities_negotiated_without_prior_call_profile_for("g_lawful", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_g_commodity_market, contract_type_key - supplies, supplies_quoted_and_purchased_on_commodity_market - true]).
utilities_negotiated_without_prior_call_profile_for("g_near_miss", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_g_commodity_market, contract_type_key - services, supplies_quoted_and_purchased_on_commodity_market - true]).
utilities_negotiated_without_prior_call_profile_for("h_lawful", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_h_bargain_purchase, contract_type_key - supplies, bargain_opportunity_available_for_very_short_time - true, price_considerably_lower_than_normal_market_prices - true]).
utilities_negotiated_without_prior_call_profile_for("h_near_miss", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_h_bargain_purchase, contract_type_key - supplies, bargain_opportunity_available_for_very_short_time - true, price_considerably_lower_than_normal_market_prices - false]).
utilities_negotiated_without_prior_call_profile_for("i_lawful", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_i_advantageous_winding_up, contract_type_key - services, particularly_advantageous_conditions_from_winding_up_or_liquidator - true, supplier_winding_up_or_in_insolvency_procedure - true]).
utilities_negotiated_without_prior_call_profile_for("i_near_miss", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_i_advantageous_winding_up, contract_type_key - works, particularly_advantageous_conditions_from_winding_up_or_liquidator - true, supplier_winding_up_or_in_insolvency_procedure - true]).
utilities_negotiated_without_prior_call_profile_for("j_lawful", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_j_design_contest, contract_type_key - services, contract_follows_directive_design_contest - true, awarded_to_contest_winner_or_all_winners_invited - true]).
utilities_negotiated_without_prior_call_profile_for("j_near_miss", Profile) :-
    dict_pairs(Profile, [pleaded_ground_key - art_50_j_design_contest, contract_type_key - supplies, contract_follows_directive_design_contest - true, awarded_to_contest_winner_or_all_winners_invited - true]).

utilities_negotiated_without_prior_call_assess(Subject, Result) :-
    utilities_negotiated_without_prior_call_profile_for(Subject, Profile),
    decide_utilities_negotiated_without_prior_call(Profile, Result).
