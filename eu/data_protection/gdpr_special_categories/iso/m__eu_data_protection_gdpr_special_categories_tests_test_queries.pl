% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_special_categories_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_special_categories_queries, [gdpr_special_categories_profile_keys/1, gdpr_special_categories_what_if/4, special_category_verdict/4, attested/2, resolution/2]).
:- use_module(m__eu_data_protection_gdpr_special_categories_kernel, [gdpr_special_categories_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_special_categories_processing_permitted, [processing_permitted/2, processing_permitted_status/2, processing_permitted_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_special_categories_fixtures, [gdpr_special_categories_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_special_categories_profile_keys(ProfileKeys),
    ProfileKeys == [accordance_with_article_89_1, appropriate_safeguards, authorising_law_proportionate_and_respects_essence, biometric_data_present, biometric_used_for_unique_identification, comprehensive_register_of_criminal_convictions, concerns_health, concerns_sex_life_or_sexual_orientation, consent_purposes_specified, consent_satisfies_definition, criminal_data_authorising_law_exists, criminal_data_law_safeguards_appropriate, criminal_offence_data_present, data_not_disclosed_outside_body_without_consent, data_subject_incapable_of_giving_consent, employment_law_or_collective_agreement_authorises, employment_social_security_or_social_protection_field, exception_claimed, explicit_consent_given, genetic_data_present, health_care_law_basis_exists, manifestly_made_public_by_data_subject, member_state_further_conditions_exist, not_for_profit_body_with_specified_aim, processed_under_professional_secrecy, processing_in_course_of_legitimate_activities, processing_necessary, processing_relates_solely_to_members_or_regular_contacts, processing_under_official_authority_control, prohibition_lifting_barred_by_law, public_health_law_basis_exists, public_health_public_interest, purpose_is_archiving_research_or_statistics, purpose_is_health_or_social_care, purpose_is_legal_claims_or_judicial_capacity, pursuant_to_contract_with_health_professional, research_archiving_statistics_law_basis_exists, reveals_political_opinions, reveals_racial_or_ethnic_origin, reveals_religious_or_philosophical_beliefs, reveals_trade_union_membership, substantial_public_interest, substantial_public_interest_law_exists, suitable_and_specific_measures, vital_interest_at_stake].
test(status_determination_gives_one_status) :-
    gdpr_special_categories_profile_for(public_health_law, Profile),
    findall(Status, processing_permitted_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(status_determination_of_a_referral) :-
    gdpr_special_categories_profile_for(made_public_unsure, Profile),
    processing_permitted_status(Profile, needs_legal_review(open_textured(manifestly_made_public_by_data_subject, cite(eu_reg_2016_679_art_9_2_e)), _)).
test(compliance_check_allows_the_proposed_processing) :-
    gdpr_special_categories_profile_for(criminal_authorised_by_law, Profile),
    processing_permitted(Profile, eligible).
test(compliance_check_bars_the_register_outside_official_authority) :-
    gdpr_special_categories_profile_for(criminal_register_defeats_law, Profile),
    processing_permitted(Profile, ineligible).
test(justification_checklist_cites_each_requirement) :-
    gdpr_special_categories_profile_for(vital_interest_capable, Profile),
    findall(Items, processing_permitted_checklist(Profile, Items), Answers),
    Answers == [[item(article_9_1_scope, met, cite(eu_reg_2016_679_art_9_1)), item(necessity, met, cite(eu_reg_2016_679_art_9_2_c)), item(vital_interest, met, cite(eu_reg_2016_679_art_9_2_c)), item(incapacity, unmet(incapacity), cite(eu_reg_2016_679_art_9_2_c)), item(article_9_4, not_applicable, cite(eu_reg_2016_679_art_9_4)), item(article_10, not_applicable, cite(eu_reg_2016_679_art_10))]].
test(justification_checklist_cites_the_consent_definition) :-
    gdpr_special_categories_profile_for(explicit_consent, Profile),
    processing_permitted_checklist(Profile, Items),
    member(item(consent_definition, met, cite(eu_reg_2016_679_art_4_11)), Items).
test(justification_checklist_is_empty_with_input_problems) :-
    processing_permitted_checklist([attribute(colour, red)], []).
test(what_if_incapacity_flips_point_c_to_eligible) :-
    gdpr_special_categories_profile_for(vital_interest_capable, Profile),
    findall(Status, gdpr_special_categories_what_if(Profile, data_subject_incapable_of_giving_consent, true, Status), Statuses),
    Statuses == [eligible].
test(what_if_official_authority_flips_article_10) :-
    gdpr_special_categories_profile_for(criminal_no_route, Profile),
    gdpr_special_categories_what_if(Profile, processing_under_official_authority_control, true, eligible).
test(what_if_attesting_the_law_resolves_the_referral) :-
    gdpr_special_categories_profile_for(employment_law_absent_cross_reference, Profile),
    gdpr_special_categories_what_if(Profile, employment_law_or_collective_agreement_authorises, attested(true, attestation(decision_layer, attested_at, attested_reason, none)), eligible).
test(what_if_a_malformed_value_gives_input_problems) :-
    gdpr_special_categories_profile_for(explicit_consent, Profile),
    gdpr_special_categories_what_if(Profile, explicit_consent_given, yes, input_problems([wrong_type(explicit_consent_given)])).
test(input_check_of_a_well_formed_profile) :-
    gdpr_special_categories_profile_for(explicit_consent, Profile),
    gdpr_special_categories_input_problems(Profile, []).
test(input_check_of_a_non_list) :-
    gdpr_special_categories_input_problems(health, [wrong_type(profile)]).
test(verdict_constructor_shape) :-
    special_category_verdict(eligible, [art9_2_a], [explicit_consent], [cite(eu_reg_2016_679_art_9_1)]).
test(attested_constructor_shape) :-
    attested(false, attestation(decision_layer, attested_at, attested_reason, none)).
test(resolution_constructor_shape) :-
    resolution(cite(eu_reg_2016_679_art_10), not_attempted).

test(compliance_check_does_not_allow_the_register, fail) :-
    gdpr_special_categories_profile_for(criminal_register_defeats_law, Profile),
    processing_permitted(Profile, eligible).
test(attested_constructor_rejects_unsure, fail) :-
    attested(unsure, attestation(decision_layer, attested_at, attested_reason, none)).

cp_test_names([profile_keys_are_the_contract_keys, status_determination_gives_one_status, status_determination_of_a_referral, compliance_check_allows_the_proposed_processing, compliance_check_bars_the_register_outside_official_authority, justification_checklist_cites_each_requirement, justification_checklist_cites_the_consent_definition, justification_checklist_is_empty_with_input_problems, what_if_incapacity_flips_point_c_to_eligible, what_if_official_authority_flips_article_10, what_if_attesting_the_law_resolves_the_referral, what_if_a_malformed_value_gives_input_problems, input_check_of_a_well_formed_profile, input_check_of_a_non_list, verdict_constructor_shape, attested_constructor_shape, resolution_constructor_shape]).
cp_test_fail_names([compliance_check_does_not_allow_the_register, attested_constructor_rejects_unsure]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
