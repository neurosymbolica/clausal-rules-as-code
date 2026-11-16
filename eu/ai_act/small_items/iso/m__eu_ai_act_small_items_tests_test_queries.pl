% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_small_items_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_small_items_queries, [small_items_profile_keys/1, small_items_what_if/4, not_applicable_on_date/0, real_world_testing_permitted/0, right_to_explanation_under_article_86/0, unsure/0, date/3, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1]).
:- use_module(m__eu_ai_act_small_items_kernel, [small_items_input_problems/2]).
:- use_module(m__eu_ai_act_small_items_small_items, [decide_small_items/2, small_items_status/2, small_items_checklist/2]).
:- use_module(m__eu_ai_act_small_items_fixtures, [small_items_profile_for/2]).

subject_what_if(Subject, Key, Value, Status) :-
    small_items_profile_for(Subject, Request),
    small_items_what_if(Request, Key, Value, Status).

subject_checklist(Subject, Items) :-
    small_items_profile_for(Subject, Request),
    small_items_checklist(Request, Items).

met_item(item(_Requirement, met, cite(_Key))).

cited_item(item(_Requirement, _Status, cite(_Key))).

test(profile_keys_are_the_contract_keys) :-
    small_items_profile_keys(ProfileKeys),
    ProfileKeys == [bias_processing_capacity, strictly_necessary_for_bias_detection_and_correction_under_article_10_2_f_and_g, strictly_necessary_for_bias_detection_and_correction_of_biases_affecting_health_safety_or_fundamental_rights, appropriate_safeguards_for_fundamental_rights_and_freedoms, bias_detection_cannot_be_effectively_fulfilled_by_processing_other_data, technical_limitations_on_reuse_and_state_of_the_art_security_and_privacy_preserving_measures, measures_securing_and_protecting_the_data_with_strict_access_controls_and_documentation, data_not_transmitted_transferred_or_otherwise_accessed_by_other_parties, data_deleted_once_bias_corrected_or_retention_period_ended, records_of_processing_include_the_reasons_for_the_processing, sandbox_processing_of_data_collected_for_other_purposes_solely_for_developing_training_and_testing, developed_for_safeguarding_substantial_public_interest, public_interest_area, data_necessary_for_chapter_iii_section_2_requirements_and_non_personal_data_not_effective, effective_monitoring_and_response_mechanisms, functionally_separate_isolated_and_protected_environment_under_provider_control, data_shared_only_as_article_59_allows, processing_leads_to_no_measures_or_decisions_affecting_data_subjects_or_their_rights, appropriate_technical_and_organisational_measures, data_deleted_at_end_of_participation_or_retention_period, processing_logs_kept_for_the_duration_of_participation, description_of_process_and_rationale_kept_in_technical_documentation, project_summary_published_on_competent_authority_website, for_law_enforcement_purposes_under_law_enforcement_authority_control, based_on_specific_union_or_national_law, testing_route, member_state_has_adopted_a_real_world_testing_framework, testing_plan_drawn_up_and_submitted_to_the_market_surveillance_authority, approval_status, national_law_provides_for_tacit_approval, testing_registered_as_article_60_4_c_requires, established_in_the_union_or_legal_representative_established_in_the_union, third_country_transfers_only_with_appropriate_and_applicable_safeguards, testing_duration, extension_notified_in_advance_with_explanation, testing_no_longer_than_necessary_to_achieve_its_objectives, vulnerable_subjects_appropriately_protected, testing_in_cooperation_with_deployers, deployers_informed_instructed_and_agreement_concluded, informed_consent_given_in_accordance_with_article_61, law_enforcement_testing_where_seeking_consent_would_prevent_the_test, no_negative_effect_on_subjects_and_data_deleted_after_the_test, effectively_overseen_by_suitably_qualified_persons, outputs_can_be_effectively_reversed_and_disregarded, consent_freely_given, consent_obtained_before_participation, information_concise_clear_relevant_and_understandable, informed_of_nature_objectives_and_possible_inconvenience, informed_of_conditions_and_expected_duration, informed_of_rights_and_guarantees_including_refusal_and_withdrawal, informed_of_arrangements_for_reversal_or_disregarding, informed_of_identification_number_and_contact_details, consent_dated_and_documented, copy_given_to_the_subject_or_legal_representative, is_an_sme_including_a_start_up, has_partner_or_linked_enterprises, affected_person_subject_to_a_deployer_decision_based_on_the_system_output, system_is_a_high_risk_ai_system_listed_in_annex_iii, system_listed_under_point_2_of_annex_iii, decision_produces_legal_effects_or_similarly_significantly_affects_the_person, person_considers_an_adverse_impact_on_health_safety_or_fundamental_rights, union_or_national_law_provides_an_exception_or_restriction, right_otherwise_provided_for_under_union_law].
test(result_atoms_and_unsure_are_served) :-
    not_applicable_on_date,
    real_world_testing_permitted,
    right_to_explanation_under_article_86,
    unsure.
test(result_constructor_terms_build_and_destructure) :-
    functor(date(2026, 8, 2), date, 3),
    functor(needs_legal_review(open_textured(consent_freely_given, cite(eu_reg_2024_1689_art_61_1)), [inputs_relied_on([consent_freely_given - unsure])]), needs_legal_review, 2),
    functor(open_textured(consent_freely_given, cite(eu_reg_2024_1689_art_61_1)), open_textured, 2),
    functor(provenance(informed_consent, []), provenance, 2).
test(date_holds_for_a_real_day) :-
    findall(found, date(2026, 8, 2), Answers),
    Answers == [found].
test(indeterminate_holds_for_one_bare_key) :-
    findall(found, indeterminate([testing_route]), Answers),
    Answers == [found].
test(needs_legal_review_holds_for_a_referral) :-
    findall(found, needs_legal_review(open_textured(consent_freely_given, cite(eu_reg_2024_1689_art_61_1)), [inputs_relied_on([consent_freely_given - unsure])]), Answers),
    Answers == [found].
test(open_textured_holds_for_a_key_and_citation) :-
    findall(found, open_textured(consent_freely_given, cite(eu_reg_2024_1689_art_61_1)), Answers),
    Answers == [found].
test(inputs_relied_on_holds_for_pairs) :-
    findall(found, inputs_relied_on([consent_freely_given - unsure, information_concise_clear_relevant_and_understandable - true]), Answers),
    Answers == [found].
test(provenance_holds_for_a_clause_and_citations) :-
    findall(found, provenance(informed_consent, [cite(eu_reg_2024_1689_art_61_1)]), Answers),
    Answers == [found].
test(input_problems_holds_for_a_problem_list) :-
    findall(found, input_problems([unknown_key(unlisted_key), wrong_type(assessment_date)]), Answers),
    Answers == [found].
test(unknown_key_holds_for_a_key_outside_the_contract) :-
    findall(found, unknown_key(unlisted_key), Answers),
    Answers == [found].
test(wrong_type_holds_for_a_contract_key) :-
    findall(found, wrong_type(testing_route), Answers),
    Answers == [found].
test(wrong_type_holds_for_the_profile) :-
    findall(found, wrong_type(profile), Answers),
    Answers == [found].
test(duplicate_key_holds_for_a_contract_key) :-
    findall(found, duplicate_key(is_an_sme_including_a_start_up), Answers),
    Answers == [found].
test(date_called_directly_with_a_real_day) :-
    date(2026, 8, 2).
test(indeterminate_called_directly_with_one_bare_key) :-
    indeterminate([testing_route]).
test(needs_legal_review_called_directly_with_a_referral) :-
    needs_legal_review(open_textured(consent_freely_given, cite(eu_reg_2024_1689_art_61_1)), [inputs_relied_on([consent_freely_given - unsure])]).
test(open_textured_called_directly_with_a_key_and_citation) :-
    open_textured(consent_freely_given, cite(eu_reg_2024_1689_art_61_1)).
test(inputs_relied_on_called_directly_with_pairs) :-
    inputs_relied_on([consent_freely_given - unsure]).
test(provenance_called_directly_with_a_clause_and_citations) :-
    provenance(informed_consent, [cite(eu_reg_2024_1689_art_61_1)]).
test(input_problems_called_directly_with_a_problem_list) :-
    input_problems([unknown_key(unlisted_key), wrong_type(assessment_date)]).
test(unknown_key_called_directly_with_a_key_outside_the_contract) :-
    unknown_key(unlisted_key).
test(wrong_type_called_directly_with_a_contract_key) :-
    wrong_type(testing_route).
test(wrong_type_called_directly_with_the_assessment_date) :-
    wrong_type(assessment_date).
test(duplicate_key_called_directly_with_a_contract_key) :-
    duplicate_key(is_an_sme_including_a_start_up).
test(status_reads_the_result_of_the_query) :-
    small_items_profile_for(sme_independent, Request),
    findall(Status, small_items_status(Request, Status), Statuses),
    Statuses == [may_comply_in_a_simplified_manner].
test(compliance_check_gives_the_permission_with_its_citations) :-
    small_items_profile_for(testing_annex_iii_all_conditions_met, Request),
    findall(Verdict, decide_small_items(Request, Verdict), Verdicts),
    Verdicts == [small_items_verdict(real_world_testing_permitted, [cite(eu_reg_2024_1689_art_60_1), cite(eu_reg_2024_1689_art_60_4)])].
test(compliance_check_refuses_the_unpermitted_action) :-
    small_items_profile_for(sandbox_law_enforcement_without_specific_law, Request),
    decide_small_items(Request, small_items_verdict(sandbox_processing_not_permitted, _Citations)).
test(checklist_marks_the_failed_condition_with_its_citation) :-
    subject_checklist(bias_provider_without_records_of_reasons, Items),
    member(item(records_of_processing, unmet(records_of_processing), cite(eu_reg_2024_1689_art_4a_1_f)), Items).
test(checklist_of_a_permitted_processing_is_all_met) :-
    subject_checklist(bias_provider_all_conditions_met, Items),
    length(Items, 8),
    maplist(met_item, Items).
test(checklist_marks_an_unsure_judgement_unknown) :-
    subject_checklist(consent_freely_given_unsure, Items),
    member(item(freely_given, unknown([consent_freely_given]), cite(eu_reg_2024_1689_art_61_1)), Items).
test(checklist_every_item_carries_a_citation) :-
    subject_checklist(testing_deployers_without_agreement, Items),
    Items = [_|_],
    maplist(cited_item, Items),
    member(item(deployer_cooperation, unmet(deployer_cooperation), cite(eu_reg_2024_1689_art_60_4_h)), Items).
test(checklist_of_the_framework_route) :-
    subject_checklist(testing_section_b_with_framework, Items),
    Items == [item(framework_adopted, met, cite(eu_reg_2024_1689_art_60a_2))].
test(what_if_records_missing_removes_the_permission) :-
    subject_what_if(bias_provider_all_conditions_met, records_of_processing_include_the_reasons_for_the_processing, false, Status),
    Status == bias_processing_not_permitted.
test(what_if_national_law_allows_tacit_approval) :-
    subject_what_if(testing_tacit_approval_not_in_national_law, national_law_provides_for_tacit_approval, true, Status),
    Status == real_world_testing_permitted.
test(what_if_the_member_state_adopts_a_framework) :-
    subject_what_if(testing_section_b_without_framework, member_state_has_adopted_a_real_world_testing_framework, true, Status),
    Status == subject_to_the_member_state_framework.
test(what_if_the_route_is_annex_iii_instead) :-
    subject_what_if(testing_section_b_without_framework, testing_route, annex_iii, Status),
    Status == indeterminate([testing_plan_drawn_up_and_submitted_to_the_market_surveillance_authority]).
test(what_if_a_specific_law_is_adopted) :-
    subject_what_if(sandbox_law_enforcement_without_specific_law, based_on_specific_union_or_national_law, true, Status),
    Status == sandbox_processing_permitted.
test(what_if_the_lawyer_finds_consent_freely_given) :-
    subject_what_if(consent_freely_given_unsure, consent_freely_given, true, Status),
    Status == consent_meets_article_61.
test(what_if_an_exception_follows_from_national_law) :-
    subject_what_if(explanation_all_conditions_met, union_or_national_law_provides_an_exception_or_restriction, true, Status),
    Status == no_right_to_explanation_under_article_86.
test(what_if_replaces_a_duplicated_key) :-
    subject_what_if(input_duplicate_and_unknown_key, is_an_sme_including_a_start_up, true, Status),
    Status == input_problems([unknown_key(unlisted_key)]).
test(what_if_with_a_wrong_value_is_an_input_problem) :-
    subject_what_if(sme_independent, has_partner_or_linked_enterprises, maybe, Status),
    Status == input_problems([wrong_type(has_partner_or_linked_enterprises)]).
test(what_if_answers_exactly_once) :-
    findall(Status, subject_what_if(explanation_all_conditions_met, right_otherwise_provided_for_under_union_law, true, Status), Statuses),
    Statuses == [no_right_to_explanation_under_article_86].
test(what_if_the_input_check_is_re_exported) :-
    small_items_input_problems([attribute(testing_route, annex_ii)], Problems),
    Problems == [wrong_type(testing_route)].

test(date_refuses_an_impossible_day, fail) :-
    date(2026, 2, 30).
test(indeterminate_refuses_two_keys, fail) :-
    indeterminate([testing_route, approval_status]).
test(needs_legal_review_refuses_a_bare_citation, fail) :-
    needs_legal_review(open_textured(consent_freely_given, eu_reg_2024_1689_art_61_1), [inputs_relied_on([])]).
test(open_textured_refuses_a_bare_citation, fail) :-
    open_textured(consent_freely_given, eu_reg_2024_1689_art_61_1).
test(inputs_relied_on_refuses_a_non_pair, fail) :-
    inputs_relied_on([consent_freely_given]).
test(provenance_refuses_a_non_list, fail) :-
    provenance(informed_consent, cite(eu_reg_2024_1689_art_61_1)).
test(input_problems_refuses_an_empty_list, fail) :-
    input_problems([]).
test(unknown_key_refuses_a_contract_key, fail) :-
    unknown_key(testing_route).
test(wrong_type_refuses_an_unlisted_key, fail) :-
    wrong_type(unlisted_key).
test(duplicate_key_refuses_an_unlisted_key, fail) :-
    duplicate_key(unlisted_key).
test(compliance_check_never_permits_the_unpermitted_action, fail) :-
    small_items_profile_for(sandbox_law_enforcement_without_specific_law, Request),
    decide_small_items(Request, small_items_verdict(sandbox_processing_permitted, _Citations)).

cp_test_names([profile_keys_are_the_contract_keys, result_atoms_and_unsure_are_served, result_constructor_terms_build_and_destructure, date_holds_for_a_real_day, indeterminate_holds_for_one_bare_key, needs_legal_review_holds_for_a_referral, open_textured_holds_for_a_key_and_citation, inputs_relied_on_holds_for_pairs, provenance_holds_for_a_clause_and_citations, input_problems_holds_for_a_problem_list, unknown_key_holds_for_a_key_outside_the_contract, wrong_type_holds_for_a_contract_key, wrong_type_holds_for_the_profile, duplicate_key_holds_for_a_contract_key, date_called_directly_with_a_real_day, indeterminate_called_directly_with_one_bare_key, needs_legal_review_called_directly_with_a_referral, open_textured_called_directly_with_a_key_and_citation, inputs_relied_on_called_directly_with_pairs, provenance_called_directly_with_a_clause_and_citations, input_problems_called_directly_with_a_problem_list, unknown_key_called_directly_with_a_key_outside_the_contract, wrong_type_called_directly_with_a_contract_key, wrong_type_called_directly_with_the_assessment_date, duplicate_key_called_directly_with_a_contract_key, status_reads_the_result_of_the_query, compliance_check_gives_the_permission_with_its_citations, compliance_check_refuses_the_unpermitted_action, checklist_marks_the_failed_condition_with_its_citation, checklist_of_a_permitted_processing_is_all_met, checklist_marks_an_unsure_judgement_unknown, checklist_every_item_carries_a_citation, checklist_of_the_framework_route, what_if_records_missing_removes_the_permission, what_if_national_law_allows_tacit_approval, what_if_the_member_state_adopts_a_framework, what_if_the_route_is_annex_iii_instead, what_if_a_specific_law_is_adopted, what_if_the_lawyer_finds_consent_freely_given, what_if_an_exception_follows_from_national_law, what_if_replaces_a_duplicated_key, what_if_with_a_wrong_value_is_an_input_problem, what_if_answers_exactly_once, what_if_the_input_check_is_re_exported]).
cp_test_fail_names([date_refuses_an_impossible_day, indeterminate_refuses_two_keys, needs_legal_review_refuses_a_bare_citation, open_textured_refuses_a_bare_citation, inputs_relied_on_refuses_a_non_pair, provenance_refuses_a_non_list, input_problems_refuses_an_empty_list, unknown_key_refuses_a_contract_key, wrong_type_refuses_an_unlisted_key, duplicate_key_refuses_an_unlisted_key, compliance_check_never_permits_the_unpermitted_action]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
