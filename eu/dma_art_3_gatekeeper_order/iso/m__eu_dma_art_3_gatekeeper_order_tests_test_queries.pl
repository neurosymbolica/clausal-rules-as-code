% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_3_gatekeeper_order_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_3_gatekeeper_order_queries, [dma_art_3_gatekeeper_order_profile_keys/1, dma_art_3_gatekeeper_order_what_if/4, dma_art_3_gatekeeper_order_eligibility/3, impact_threshold_met/0, gatekeeper_not_presumed/0, requirements_presumed_met/0, not_designated_gatekeeper/0, indeterminate/1, duplicate_key/1, needs_legal_review/2, provenance/2, outside_fact/2, attested/2, url/2, document/2, input_problems/1, unknown_key/1, wrong_type/1]).
:- use_module(m__eu_dma_art_3_gatekeeper_order_kernel, [dma_art_3_gatekeeper_order_input_problems/2]).
:- use_module(m__eu_dma_art_3_gatekeeper_order_fixtures, [dma_art_3_gatekeeper_order_profile_for/2]).

cited_item(item(_RequirementId, _ItemStatus, cite(_CitationKey))).

subject_eligibility(Subject, Eligibility) :-
    dma_art_3_gatekeeper_order_profile_for(Subject, Profile),
    dma_art_3_gatekeeper_order_eligibility(Profile, Eligibility, _Checklist).

test(profile_keys_are_the_contract_keys) :-
    dma_art_3_gatekeeper_order_profile_keys(ProfileKeys),
    ProfileKeys == [market_capitalisation_eur_most_recent_financial_year, member_states_where_core_platform_service_provided, union_turnover_eur_most_recent_financial_year, union_turnover_eur_second_most_recent_financial_year, union_turnover_eur_third_most_recent_financial_year, monthly_active_end_users_most_recent_financial_year, monthly_active_end_users_second_most_recent_financial_year, monthly_active_end_users_third_most_recent_financial_year, yearly_active_business_users_most_recent_financial_year, yearly_active_business_users_second_most_recent_financial_year, yearly_active_business_users_third_most_recent_financial_year, rebuttal_arguments_presented, rebuttal_accepted_by_commission, significant_impact_on_internal_market, core_platform_service_is_important_gateway, entrenched_and_durable_position, designated_as_gatekeeper_for_core_platform_service].
test(eligibility_labels_follow_the_requirements) :-
    findall(Subject - Labels, (member(Subject, [all_thresholds_at_boundary, below_thresholds_all_judgements_true, below_thresholds_one_judgement_false, presumed_arguments_unstated, below_thresholds_judgement_unsure, malformed_float_turnover]), findall(Eligibility, subject_eligibility(Subject, Eligibility), Labels)), Observed),
    Observed == [all_thresholds_at_boundary - [eligible], below_thresholds_all_judgements_true - [eligible], below_thresholds_one_judgement_false - [ineligible], presumed_arguments_unstated - [undetermined], below_thresholds_judgement_unsure - [undetermined], malformed_float_turnover - [undetermined]].
test(justification_every_checklist_row_is_cited) :-
    dma_art_3_gatekeeper_order_profile_for(below_thresholds_one_judgement_false, Profile),
    dma_art_3_gatekeeper_order_eligibility(Profile, ineligible, Checklist),
    length(Checklist, 7),
    maplist(cited_item, Checklist),
    member(item(entrenched_and_durable_position, unmet(judged_false), cite(eu_reg_2022_1925_art_3_1_c)), Checklist).
test(justification_a_malformed_profile_has_one_cited_row) :-
    dma_art_3_gatekeeper_order_profile_for(malformed_float_turnover, Profile),
    dma_art_3_gatekeeper_order_eligibility(Profile, undetermined, Checklist),
    Checklist == [item(input_check, unmet(input_problems([wrong_type(union_turnover_eur_most_recent_financial_year)])), cite(eu_reg_2022_1925_art_3_1))].
test(what_if_end_users_reach_the_threshold) :-
    dma_art_3_gatekeeper_order_profile_for(end_users_one_below, Profile),
    findall(Status, dma_art_3_gatekeeper_order_what_if(Profile, monthly_active_end_users_most_recent_financial_year, 45000000, Status), Answers),
    Answers == [requirements_presumed_met].
test(what_if_one_below_stays_not_met) :-
    dma_art_3_gatekeeper_order_profile_for(end_users_one_below, Profile),
    findall(Status, dma_art_3_gatekeeper_order_what_if(Profile, monthly_active_end_users_most_recent_financial_year, 44999999, Status), Answers),
    Answers == [requirements_not_met].
test(what_if_supplies_the_missing_crisp_key) :-
    dma_art_3_gatekeeper_order_profile_for(presumed_arguments_unstated, Profile),
    findall(Status, dma_art_3_gatekeeper_order_what_if(Profile, rebuttal_arguments_presented, false, Status), Answers),
    Answers == [requirements_presumed_met].
test(what_if_removes_a_duplicate_of_the_overridden_key) :-
    dma_art_3_gatekeeper_order_profile_for(below_thresholds_one_judgement_false, Base),
    append(Base, [attribute(entrenched_and_durable_position, false)], Profile),
    dma_art_3_gatekeeper_order_input_problems(Profile, [duplicate_key(entrenched_and_durable_position)]),
    findall(Status, dma_art_3_gatekeeper_order_what_if(Profile, entrenched_and_durable_position, true, Status), Answers),
    Answers == [requirements_met].
test(what_if_a_wrong_value_is_reported) :-
    dma_art_3_gatekeeper_order_profile_for(below_thresholds_one_judgement_false, Profile),
    findall(Status, dma_art_3_gatekeeper_order_what_if(Profile, entrenched_and_durable_position, maybe, Status), Answers),
    Answers == [input_problems([wrong_type(entrenched_and_durable_position)])].
test(the_input_check_is_re_exported) :-
    findall(Problems, dma_art_3_gatekeeper_order_input_problems([], Problems), Answers),
    Answers == [[]].
test(the_result_vocabulary_is_served) :-
    impact_threshold_met,
    gatekeeper_not_presumed,
    requirements_presumed_met,
    not_designated_gatekeeper,
    indeterminate([significant_impact_on_internal_market]),
    duplicate_key(rebuttal_arguments_presented).
test(the_problem_terms_hold_for_ground_problems) :-
    input_problems([duplicate_key(rebuttal_arguments_presented), wrong_type(entrenched_and_durable_position), unknown_key(colour)]),
    unknown_key(colour),
    wrong_type(profile),
    wrong_type(entrenched_and_durable_position).
test(the_referral_shapes_hold) :-
    needs_legal_review(open_textured(core_platform_service_is_important_gateway, cite(eu_reg_2022_1925_art_3_1_b)), [inputs_relied_on([significant_impact_on_internal_market - true, core_platform_service_is_important_gateway - unsure, entrenched_and_durable_position - true])]),
    needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_3_9), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent])]).
test(the_attestation_shapes_hold) :-
    attested(true, attestation(european_commission, at_2026_09_06, provenance(designation_decision, commission_register), url('https://eur-lex.europa.eu/decision', retrieved_2026_09_06))),
    outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(false, attestation(european_commission, at_2026_09_06, designation_decision, document(upload_one, sha_one)))),
    provenance(designation_decision, commission_register),
    url('https://eur-lex.europa.eu/decision', retrieved_2026_09_06),
    document(upload_one, sha_one).

test(eligible_is_not_given_to_an_accepted_rebuttal, fail) :-
    subject_eligibility(presumed_rebuttal_accepted, eligible).
test(a_contract_key_is_not_an_unknown_key, fail) :-
    unknown_key(rebuttal_arguments_presented).
test(an_empty_problem_list_is_not_input_problems, fail) :-
    input_problems([]).
test(an_open_textured_referral_on_a_figure_key_does_not_hold, fail) :-
    needs_legal_review(open_textured(member_states_where_core_platform_service_provided, cite(eu_reg_2022_1925_art_3_2_a)), [inputs_relied_on([])]).
test(an_unsure_attested_value_does_not_hold, fail) :-
    attested(unsure, attestation(european_commission, at_2026_09_06, designation_decision, none)).
test(a_judgement_key_is_not_an_outside_fact, fail) :-
    outside_fact(significant_impact_on_internal_market, attested(true, attestation(european_commission, at_2026_09_06, designation_decision, none))).

cp_test_names([profile_keys_are_the_contract_keys, eligibility_labels_follow_the_requirements, justification_every_checklist_row_is_cited, justification_a_malformed_profile_has_one_cited_row, what_if_end_users_reach_the_threshold, what_if_one_below_stays_not_met, what_if_supplies_the_missing_crisp_key, what_if_removes_a_duplicate_of_the_overridden_key, what_if_a_wrong_value_is_reported, the_input_check_is_re_exported, the_result_vocabulary_is_served, the_problem_terms_hold_for_ground_problems, the_referral_shapes_hold, the_attestation_shapes_hold]).
cp_test_fail_names([eligible_is_not_given_to_an_accepted_rebuttal, a_contract_key_is_not_an_unknown_key, an_empty_problem_list_is_not_input_problems, an_open_textured_referral_on_a_figure_key_does_not_hold, an_unsure_attested_value_does_not_hold, a_judgement_key_is_not_an_outside_fact]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
