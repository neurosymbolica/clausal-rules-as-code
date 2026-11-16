% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_3_gatekeeper_order_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_3_gatekeeper_order_dma_art_3_gatekeeper_order, [dma_art_3_gatekeeper_order_status/2, dma_art_3_gatekeeper_order_status_values/1, impact_threshold_status/3, gateway_threshold_status/3, entrenchment_threshold_status/3, presumption_status/3, designation_requirements_status/4, gatekeeper_status/4]).
:- use_module(m__eu_dma_art_3_gatekeeper_order_fixtures, [dma_art_3_gatekeeper_order_profile_for/2]).

turnover_branch_profile(MemberStateCount, [attribute(member_states_where_core_platform_service_provided, MemberStateCount), attribute(union_turnover_eur_most_recent_financial_year, 8000000000), attribute(union_turnover_eur_second_most_recent_financial_year, 8000000000), attribute(union_turnover_eur_third_most_recent_financial_year, 8000000000)]).

test(the_verdict_atoms_are_the_slice_vocabulary) :-
    dma_art_3_gatekeeper_order_status_values(StatusValues),
    StatusValues == [requirements_presumed_met, requirements_met, requirements_not_met].
test(turnover_branch_with_three_member_states_is_met) :-
    turnover_branch_profile(3, Profile),
    impact_threshold_status(Profile, impact_threshold_met, [cite(eu_reg_2022_1925_art_3_2_a)]).
test(turnover_branch_with_two_member_states_is_not_met) :-
    turnover_branch_profile(2, Profile),
    impact_threshold_status(Profile, impact_threshold_not_met, [cite(eu_reg_2022_1925_art_3_2_a)]).
test(turnover_at_threshold_is_impact_met) :-
    dma_art_3_gatekeeper_order_profile_for(turnover_at_threshold, Profile),
    impact_threshold_status(Profile, impact_threshold_met, _).
test(turnover_one_euro_below_is_impact_not_met) :-
    dma_art_3_gatekeeper_order_profile_for(turnover_one_euro_below, Profile),
    impact_threshold_status(Profile, impact_threshold_not_met, _).
test(market_at_threshold_is_impact_met) :-
    dma_art_3_gatekeeper_order_profile_for(market_capitalisation_at_threshold, Profile),
    impact_threshold_status(Profile, impact_threshold_met, _).
test(boundary_users_meet_the_gateway) :-
    dma_art_3_gatekeeper_order_profile_for(all_thresholds_at_boundary, Profile),
    gateway_threshold_status(Profile, gateway_threshold_met, _).
test(end_users_one_below_fail_the_gateway) :-
    dma_art_3_gatekeeper_order_profile_for(end_users_one_below, Profile),
    gateway_threshold_status(Profile, gateway_threshold_not_met, _).
test(boundary_users_meet_entrenchment) :-
    dma_art_3_gatekeeper_order_profile_for(all_thresholds_at_boundary, Profile),
    entrenchment_threshold_status(Profile, entrenchment_threshold_met, _).
test(third_year_business_users_below_fail_entrenchment) :-
    dma_art_3_gatekeeper_order_profile_for(business_users_third_year_one_below, Profile),
    entrenchment_threshold_status(Profile, entrenchment_threshold_not_met, _).
test(boundary_profile_is_presumed) :-
    dma_art_3_gatekeeper_order_profile_for(all_thresholds_at_boundary, Profile),
    presumption_status(Profile, gatekeeper_presumed, _).
test(one_point_short_is_not_presumed) :-
    dma_art_3_gatekeeper_order_profile_for(end_users_third_year_one_below, Profile),
    presumption_status(Profile, gatekeeper_not_presumed, Citations),
    sort(Citations, SortedCitations),
    SortedCitations == [cite(eu_reg_2022_1925_art_3_2_b), cite(eu_reg_2022_1925_art_3_2_c)].
test(arguments_not_presented_is_presumed_met) :-
    dma_art_3_gatekeeper_order_profile_for(all_thresholds_at_boundary, Profile),
    dma_art_3_gatekeeper_order_status(Profile, requirements_presumed_met).
test(arguments_unstated_with_rejection_stated_is_presumed_met_without_basis) :-
    dma_art_3_gatekeeper_order_profile_for(presumed_arguments_unstated, Base),
    append(Base, [attribute(rebuttal_accepted_by_commission, attested(false, attestation(host, at, reason, none)))], Profile),
    designation_requirements_status(Profile, requirements_presumed_met, [], [cite(eu_reg_2022_1925_art_3_1), cite(eu_reg_2022_1925_art_3_2)]).
test(rejected_rebuttal_is_presumed_met) :-
    dma_art_3_gatekeeper_order_profile_for(presumed_rebuttal_rejected, Profile),
    dma_art_3_gatekeeper_order_status(Profile, requirements_presumed_met).
test(accepted_rebuttal_is_not_met) :-
    dma_art_3_gatekeeper_order_profile_for(presumed_rebuttal_accepted, Profile),
    dma_art_3_gatekeeper_order_status(Profile, requirements_not_met).
test(conclusion_not_shown_is_referred) :-
    dma_art_3_gatekeeper_order_profile_for(presumed_rebuttal_conclusion_not_shown, Profile),
    designation_requirements_status(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_3_5), cite(commission_rebuttal_conclusion)), [resolution(cite(commission_rebuttal_conclusion), not_attempted), inputs_relied_on([rebuttal_accepted_by_commission - absent])]), [], []).
test(accepted_rebuttal_and_false_judgement_settle_early) :-
    designation_requirements_status([attribute(rebuttal_arguments_presented, true), attribute(rebuttal_accepted_by_commission, attested(true, attestation(host, at, reason, none))), attribute(entrenched_and_durable_position, false)], requirements_not_met, [], [cite(eu_reg_2022_1925_art_3_1)]).
test(rejected_rebuttal_and_false_judgement_name_the_figure) :-
    designation_requirements_status([attribute(rebuttal_arguments_presented, true), attribute(rebuttal_accepted_by_commission, attested(false, attestation(host, at, reason, none))), attribute(entrenched_and_durable_position, false)], indeterminate([market_capitalisation_eur_most_recent_financial_year]), [], []).
test(all_judgements_true_is_met) :-
    dma_art_3_gatekeeper_order_profile_for(below_thresholds_all_judgements_true, Profile),
    dma_art_3_gatekeeper_order_status(Profile, requirements_met).
test(one_judgement_false_is_not_met) :-
    dma_art_3_gatekeeper_order_profile_for(below_thresholds_one_judgement_false, Profile),
    dma_art_3_gatekeeper_order_status(Profile, requirements_not_met).
test(absent_judgement_is_named) :-
    dma_art_3_gatekeeper_order_profile_for(below_thresholds_judgement_absent, Profile),
    dma_art_3_gatekeeper_order_status(Profile, indeterminate([core_platform_service_is_important_gateway])).
test(attested_designation_is_designated) :-
    dma_art_3_gatekeeper_order_profile_for(designated_attested_true, Profile),
    gatekeeper_status(Profile, designated_gatekeeper, _, [cite(eu_reg_2022_1925_art_3_9)]).
test(attested_no_designation_is_not_designated) :-
    dma_art_3_gatekeeper_order_profile_for(designated_attested_false, Profile),
    gatekeeper_status(Profile, not_designated_gatekeeper, _, [cite(eu_reg_2022_1925_art_3_9)]).
test(a_malformed_profile_answers_input_problems) :-
    dma_art_3_gatekeeper_order_profile_for(malformed_float_turnover, Profile),
    presumption_status(Profile, input_problems([wrong_type(union_turnover_eur_most_recent_financial_year)]), []).

test(turnover_branch_with_two_member_states_is_never_met, fail) :-
    turnover_branch_profile(2, Profile),
    impact_threshold_status(Profile, impact_threshold_met, _).
test(turnover_one_euro_below_is_never_impact_met, fail) :-
    dma_art_3_gatekeeper_order_profile_for(turnover_one_euro_below, Profile),
    impact_threshold_status(Profile, impact_threshold_met, _).
test(market_one_euro_below_is_never_impact_met, fail) :-
    dma_art_3_gatekeeper_order_profile_for(market_capitalisation_one_euro_below, Profile),
    impact_threshold_status(Profile, impact_threshold_met, _).
test(end_users_one_below_never_meet_the_gateway, fail) :-
    dma_art_3_gatekeeper_order_profile_for(end_users_one_below, Profile),
    gateway_threshold_status(Profile, gateway_threshold_met, _).
test(business_users_one_below_never_meet_the_gateway, fail) :-
    dma_art_3_gatekeeper_order_profile_for(business_users_one_below, Profile),
    gateway_threshold_status(Profile, gateway_threshold_met, _).
test(third_year_business_users_below_never_meet_entrenchment, fail) :-
    dma_art_3_gatekeeper_order_profile_for(business_users_third_year_one_below, Profile),
    entrenchment_threshold_status(Profile, entrenchment_threshold_met, _).
test(one_point_short_is_never_presumed, fail) :-
    dma_art_3_gatekeeper_order_profile_for(end_users_third_year_one_below, Profile),
    presumption_status(Profile, gatekeeper_presumed, _).
test(arguments_unstated_is_not_presumed_met, fail) :-
    dma_art_3_gatekeeper_order_profile_for(presumed_arguments_unstated, Profile),
    dma_art_3_gatekeeper_order_status(Profile, requirements_presumed_met).
test(accepted_rebuttal_is_never_presumed_met, fail) :-
    dma_art_3_gatekeeper_order_profile_for(presumed_rebuttal_accepted, Profile),
    dma_art_3_gatekeeper_order_status(Profile, requirements_presumed_met).
test(conclusion_not_shown_is_never_presumed_met, fail) :-
    dma_art_3_gatekeeper_order_profile_for(presumed_rebuttal_conclusion_not_shown, Profile),
    dma_art_3_gatekeeper_order_status(Profile, requirements_presumed_met).
test(rejected_rebuttal_and_false_judgement_never_settle, fail) :-
    designation_requirements_status([attribute(rebuttal_arguments_presented, true), attribute(rebuttal_accepted_by_commission, attested(false, attestation(host, at, reason, none))), attribute(entrenched_and_durable_position, false)], requirements_not_met, _, _).
test(one_judgement_false_is_never_met, fail) :-
    dma_art_3_gatekeeper_order_profile_for(below_thresholds_one_judgement_false, Profile),
    dma_art_3_gatekeeper_order_status(Profile, requirements_met).
test(unsure_judgement_is_never_met, fail) :-
    dma_art_3_gatekeeper_order_profile_for(below_thresholds_judgement_unsure, Profile),
    dma_art_3_gatekeeper_order_status(Profile, requirements_met).
test(absent_judgement_is_never_met, fail) :-
    dma_art_3_gatekeeper_order_profile_for(below_thresholds_judgement_absent, Profile),
    dma_art_3_gatekeeper_order_status(Profile, requirements_met).
test(attested_no_designation_is_never_designated, fail) :-
    dma_art_3_gatekeeper_order_profile_for(designated_attested_false, Profile),
    gatekeeper_status(Profile, designated_gatekeeper, _, _).
test(thresholds_alone_never_designate, fail) :-
    dma_art_3_gatekeeper_order_profile_for(all_thresholds_at_boundary, Profile),
    gatekeeper_status(Profile, designated_gatekeeper, _, _).
test(a_malformed_profile_is_never_presumed, fail) :-
    dma_art_3_gatekeeper_order_profile_for(malformed_float_turnover, Profile),
    presumption_status(Profile, gatekeeper_presumed, _).

cp_test_names([the_verdict_atoms_are_the_slice_vocabulary, turnover_branch_with_three_member_states_is_met, turnover_branch_with_two_member_states_is_not_met, turnover_at_threshold_is_impact_met, turnover_one_euro_below_is_impact_not_met, market_at_threshold_is_impact_met, boundary_users_meet_the_gateway, end_users_one_below_fail_the_gateway, boundary_users_meet_entrenchment, third_year_business_users_below_fail_entrenchment, boundary_profile_is_presumed, one_point_short_is_not_presumed, arguments_not_presented_is_presumed_met, arguments_unstated_with_rejection_stated_is_presumed_met_without_basis, rejected_rebuttal_is_presumed_met, accepted_rebuttal_is_not_met, conclusion_not_shown_is_referred, accepted_rebuttal_and_false_judgement_settle_early, rejected_rebuttal_and_false_judgement_name_the_figure, all_judgements_true_is_met, one_judgement_false_is_not_met, absent_judgement_is_named, attested_designation_is_designated, attested_no_designation_is_not_designated, a_malformed_profile_answers_input_problems]).
cp_test_fail_names([turnover_branch_with_two_member_states_is_never_met, turnover_one_euro_below_is_never_impact_met, market_one_euro_below_is_never_impact_met, end_users_one_below_never_meet_the_gateway, business_users_one_below_never_meet_the_gateway, third_year_business_users_below_never_meet_entrenchment, one_point_short_is_never_presumed, arguments_unstated_is_not_presumed_met, accepted_rebuttal_is_never_presumed_met, conclusion_not_shown_is_never_presumed_met, rejected_rebuttal_and_false_judgement_never_settle, one_judgement_false_is_never_met, unsure_judgement_is_never_met, absent_judgement_is_never_met, attested_no_designation_is_never_designated, thresholds_alone_never_designate, a_malformed_profile_is_never_presumed]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
