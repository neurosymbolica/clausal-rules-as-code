% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_special_categories_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_special_categories_processing_permitted, [processing_permitted/2, decide_special_category_processing/2, special_category_scope/2, special_category_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_special_categories_permitted_bases, [permitted_bases/2]).
:- use_module(m__eu_data_protection_gdpr_special_categories_fixtures, [gdpr_special_categories_profile_for/2]).

profile_of(Subject, Profile) :-
    gdpr_special_categories_profile_for(Subject, Profile).

test(eligible_holds_with_the_status_bound) :-
    profile_of(explicit_consent, Profile),
    processing_permitted(Profile, eligible).
test(ineligible_holds_with_the_status_bound) :-
    profile_of(health_without_claim, Profile),
    processing_permitted(Profile, ineligible).
test(bases_bound_for_an_eligible_profile) :-
    profile_of(employment_law_authorised, Profile),
    permitted_bases(Profile, [art9_2_b]).
test(partially_bound_verdict_reads_out_the_rest) :-
    profile_of(criminal_official_authority, Profile),
    decide_special_category_processing(Profile, special_category_verdict(eligible, Bases, Conditions, Citations)),
    Bases == [art10_official_authority],
    Conditions == [official_authority],
    Citations == [cite(eu_reg_2016_679_art_10)].
test(attribute_order_does_not_change_the_answer) :-
    profile_of(not_for_profit_members, Profile),
    reverse(Profile, Reversed),
    processing_permitted(Reversed, eligible).
test(an_unread_key_does_not_change_the_answer) :-
    profile_of(made_public, Profile),
    processing_permitted([attribute(vital_interest_at_stake, false)|Profile], eligible).
test(url_evidence_is_carried_not_read) :-
    processing_permitted([attribute(exception_claimed, art9_2_i), attribute(concerns_health, true), attribute(criminal_offence_data_present, false), attribute(processing_necessary, true), attribute(public_health_public_interest, true), attribute(public_health_law_basis_exists, attested(true, attestation(decision_layer, attested_at, attested_reason, url(source_address, retrieved_at)))), attribute(suitable_and_specific_measures, true)], eligible).
test(a_list_of_non_attributes_is_a_wrong_type) :-
    processing_permitted([colour], input_problems([wrong_type(profile)])).
test(a_non_list_profile_is_a_wrong_type) :-
    processing_permitted(health, input_problems([wrong_type(profile)])).
test(a_crisp_key_given_unsure_is_a_wrong_type) :-
    profile_of(wrong_type_value, Profile),
    processing_permitted(Profile, input_problems([wrong_type(genetic_data_present)])).
test(a_bare_outside_fact_flag_is_a_wrong_type) :-
    processing_permitted([attribute(health_care_law_basis_exists, true)], input_problems([wrong_type(health_care_law_basis_exists)])).
test(an_exception_outside_the_ten_is_a_wrong_type) :-
    processing_permitted([attribute(exception_claimed, article_6_basis)], input_problems([wrong_type(exception_claimed)])).
test(problems_follow_contract_order_then_unknown_keys) :-
    processing_permitted([attribute(colour, red), attribute(vital_interest_at_stake, maybe), attribute(appropriate_safeguards, perhaps), attribute(colour, blue)], input_problems([wrong_type(appropriate_safeguards), wrong_type(vital_interest_at_stake), unknown_key(colour)])).
test(a_duplicate_key_is_not_also_a_wrong_type) :-
    processing_permitted([attribute(concerns_health, maybe), attribute(concerns_health, perhaps)], input_problems([duplicate_key(concerns_health)])).
test(scope_bound_with_input_problems) :-
    special_category_scope([attribute(colour, red)], input_problems([unknown_key(colour)])).
test(outside_facts_bound_with_input_problems) :-
    special_category_outside_facts([attribute(colour, red)], input_problems([unknown_key(colour)])).
test(bases_bound_empty_with_input_problems) :-
    permitted_bases([attribute(colour, red)], []).

test(eligible_profile_rejects_ineligible_bound, fail) :-
    profile_of(explicit_consent, Profile),
    processing_permitted(Profile, ineligible).
test(ineligible_profile_rejects_eligible_bound, fail) :-
    profile_of(health_without_claim, Profile),
    processing_permitted(Profile, eligible).
test(bases_bound_to_another_point_are_rejected, fail) :-
    profile_of(employment_law_authorised, Profile),
    permitted_bases(Profile, [art9_2_a]).
test(a_malformed_value_is_never_read_as_absent, fail) :-
    profile_of(wrong_type_value, Profile),
    processing_permitted(Profile, indeterminate(_)).

cp_test_names([eligible_holds_with_the_status_bound, ineligible_holds_with_the_status_bound, bases_bound_for_an_eligible_profile, partially_bound_verdict_reads_out_the_rest, attribute_order_does_not_change_the_answer, an_unread_key_does_not_change_the_answer, url_evidence_is_carried_not_read, a_list_of_non_attributes_is_a_wrong_type, a_non_list_profile_is_a_wrong_type, a_crisp_key_given_unsure_is_a_wrong_type, a_bare_outside_fact_flag_is_a_wrong_type, an_exception_outside_the_ten_is_a_wrong_type, problems_follow_contract_order_then_unknown_keys, a_duplicate_key_is_not_also_a_wrong_type, scope_bound_with_input_problems, outside_facts_bound_with_input_problems, bases_bound_empty_with_input_problems]).
cp_test_fail_names([eligible_profile_rejects_ineligible_bound, ineligible_profile_rejects_eligible_bound, bases_bound_to_another_point_are_rejected, a_malformed_value_is_never_read_as_absent]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
