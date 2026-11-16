% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_special_categories_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_special_categories_processing_permitted, [processing_permitted/2]).
:- use_module(m__eu_data_protection_gdpr_special_categories_permitted_bases, [permitted_bases/2]).
:- use_module(m__eu_data_protection_gdpr_special_categories_fixtures, [gdpr_special_categories_profile_for/2]).

status_of(Subject, Status) :-
    gdpr_special_categories_profile_for(Subject, Profile),
    processing_permitted(Profile, Status).

bases_of(Subject, Bases) :-
    gdpr_special_categories_profile_for(Subject, Profile),
    permitted_bases(Profile, Bases).

test(not_special_category_route) :-
    bases_of(not_special_category, [not_special_category_data]).
test(no_claim_near_miss_is_ineligible) :-
    status_of(health_without_claim, ineligible).
test(point_a_route) :-
    bases_of(explicit_consent, [art9_2_a]).
test(point_a_near_miss_is_ineligible) :-
    status_of(explicit_consent_barred_by_law, ineligible).
test(point_b_route) :-
    bases_of(employment_law_authorised, [art9_2_b]).
test(point_b_near_miss_is_ineligible) :-
    status_of(employment_law_attested_false, ineligible).
test(point_c_route) :-
    bases_of(vital_interest_incapable, [art9_2_c]).
test(point_c_near_miss_is_ineligible) :-
    status_of(vital_interest_capable, ineligible).
test(point_d_route) :-
    bases_of(not_for_profit_members, [art9_2_d]).
test(point_d_near_miss_is_ineligible) :-
    status_of(not_for_profit_outsiders, ineligible).
test(point_e_route) :-
    bases_of(made_public, [art9_2_e]).
test(point_e_near_miss_is_ineligible) :-
    status_of(made_public_denied, ineligible).
test(point_f_route) :-
    bases_of(legal_claims, [art9_2_f]).
test(point_f_near_miss_is_ineligible) :-
    status_of(legal_claims_other_purpose, ineligible).
test(point_g_route) :-
    bases_of(substantial_public_interest, [art9_2_g]).
test(point_g_near_miss_is_ineligible) :-
    status_of(substantial_public_interest_denied, ineligible).
test(point_h_route) :-
    bases_of(health_care_contract, [art9_2_h]).
test(point_h_near_miss_is_ineligible) :-
    status_of(health_care_without_secrecy, ineligible).
test(point_i_route) :-
    bases_of(public_health_law, [art9_2_i]).
test(point_i_near_miss_is_ineligible) :-
    status_of(public_health_law_attested_false, ineligible).
test(point_j_route) :-
    bases_of(research_archiving, [art9_2_j]).
test(point_j_near_miss_is_ineligible) :-
    status_of(research_without_article_89, ineligible).
test(article_10_route_a) :-
    bases_of(criminal_official_authority, [art10_official_authority]).
test(article_10_route_a_near_miss_is_ineligible) :-
    status_of(criminal_no_route, ineligible).
test(article_10_route_b) :-
    bases_of(criminal_authorised_by_law, [art10_authorised_by_law]).
test(article_10_route_b_near_miss_is_ineligible) :-
    status_of(criminal_register_defeats_law, ineligible).
test(article_9_4_attested_false_is_applied) :-
    status_of(further_conditions_attested_false, eligible).
test(article_9_4_attested_true_is_referred) :-
    status_of(further_conditions_attested_true, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_9_1), cite(eu_reg_2016_679_art_9_4)), _)).
test(article_9_4_health_false_stands) :-
    status_of(health_false_further_conditions, eligible).
test(article_9_4_health_unsure_is_referred) :-
    status_of(health_unsure_further_conditions, needs_legal_review(open_textured(concerns_health, cite(eu_reg_2016_679_art_4_15)), _)).
test(biometric_without_identification_is_out_of_scope) :-
    bases_of(biometric_without_identification, [not_special_category_data]).
test(biometric_with_identification_is_ineligible) :-
    status_of(biometric_with_identification, ineligible).
test(scope_settled_false_is_eligible) :-
    status_of(scope_settled_false, eligible).
test(scope_unsure_is_referred) :-
    status_of(scope_unsure_referral, needs_legal_review(open_textured(concerns_sex_life_or_sexual_orientation, cite(eu_reg_2016_679_art_9_1)), _)).
test(attested_enabling_fact_is_eligible) :-
    status_of(employment_law_authorised, eligible).
test(absent_enabling_fact_is_referred) :-
    status_of(employment_law_absent_cross_reference, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_9_2_b), cite(eu_reg_2016_679_art_9_2_b)), _)).
test(absent_scope_flag_is_indeterminate) :-
    status_of(criminal_scope_absent, indeterminate([criminal_offence_data_present])).
test(input_problems_are_reported) :-
    status_of(wrong_type_value, input_problems([wrong_type(genetic_data_present)])).

test(no_claim_near_miss_is_not_eligible, fail) :-
    status_of(health_without_claim, eligible).
test(point_a_near_miss_is_not_eligible, fail) :-
    status_of(explicit_consent_barred_by_law, eligible).
test(point_b_near_miss_is_not_eligible, fail) :-
    status_of(employment_law_attested_false, eligible).
test(point_c_near_miss_is_not_eligible, fail) :-
    status_of(vital_interest_capable, eligible).
test(point_d_near_miss_is_not_eligible, fail) :-
    status_of(not_for_profit_outsiders, eligible).
test(point_e_near_miss_is_not_eligible, fail) :-
    status_of(made_public_denied, eligible).
test(point_f_near_miss_is_not_eligible, fail) :-
    status_of(legal_claims_other_purpose, eligible).
test(point_g_near_miss_is_not_eligible, fail) :-
    status_of(substantial_public_interest_denied, eligible).
test(point_h_near_miss_is_not_eligible, fail) :-
    status_of(health_care_without_secrecy, eligible).
test(point_i_near_miss_is_not_eligible, fail) :-
    status_of(public_health_law_attested_false, eligible).
test(point_j_near_miss_is_not_eligible, fail) :-
    status_of(research_without_article_89, eligible).
test(article_10_route_a_near_miss_is_not_eligible, fail) :-
    status_of(criminal_no_route, eligible).
test(article_10_route_b_near_miss_is_not_eligible, fail) :-
    status_of(criminal_register_defeats_law, eligible).
test(article_9_4_attested_true_is_not_eligible, fail) :-
    status_of(further_conditions_attested_true, eligible).
test(article_9_4_health_unsure_is_not_eligible, fail) :-
    status_of(health_unsure_further_conditions, eligible).
test(biometric_with_identification_is_not_eligible, fail) :-
    status_of(biometric_with_identification, eligible).
test(scope_unsure_is_not_eligible, fail) :-
    status_of(scope_unsure_referral, eligible).
test(absent_enabling_fact_is_not_eligible, fail) :-
    status_of(employment_law_absent_cross_reference, eligible).
test(absent_scope_flag_is_not_eligible, fail) :-
    status_of(criminal_scope_absent, eligible).
test(input_problems_are_not_eligible, fail) :-
    status_of(wrong_type_value, eligible).

cp_test_names([not_special_category_route, no_claim_near_miss_is_ineligible, point_a_route, point_a_near_miss_is_ineligible, point_b_route, point_b_near_miss_is_ineligible, point_c_route, point_c_near_miss_is_ineligible, point_d_route, point_d_near_miss_is_ineligible, point_e_route, point_e_near_miss_is_ineligible, point_f_route, point_f_near_miss_is_ineligible, point_g_route, point_g_near_miss_is_ineligible, point_h_route, point_h_near_miss_is_ineligible, point_i_route, point_i_near_miss_is_ineligible, point_j_route, point_j_near_miss_is_ineligible, article_10_route_a, article_10_route_a_near_miss_is_ineligible, article_10_route_b, article_10_route_b_near_miss_is_ineligible, article_9_4_attested_false_is_applied, article_9_4_attested_true_is_referred, article_9_4_health_false_stands, article_9_4_health_unsure_is_referred, biometric_without_identification_is_out_of_scope, biometric_with_identification_is_ineligible, scope_settled_false_is_eligible, scope_unsure_is_referred, attested_enabling_fact_is_eligible, absent_enabling_fact_is_referred, absent_scope_flag_is_indeterminate, input_problems_are_reported]).
cp_test_fail_names([no_claim_near_miss_is_not_eligible, point_a_near_miss_is_not_eligible, point_b_near_miss_is_not_eligible, point_c_near_miss_is_not_eligible, point_d_near_miss_is_not_eligible, point_e_near_miss_is_not_eligible, point_f_near_miss_is_not_eligible, point_g_near_miss_is_not_eligible, point_h_near_miss_is_not_eligible, point_i_near_miss_is_not_eligible, point_j_near_miss_is_not_eligible, article_10_route_a_near_miss_is_not_eligible, article_10_route_b_near_miss_is_not_eligible, article_9_4_attested_true_is_not_eligible, article_9_4_health_unsure_is_not_eligible, biometric_with_identification_is_not_eligible, scope_unsure_is_not_eligible, absent_enabling_fact_is_not_eligible, absent_scope_flag_is_not_eligible, input_problems_are_not_eligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
