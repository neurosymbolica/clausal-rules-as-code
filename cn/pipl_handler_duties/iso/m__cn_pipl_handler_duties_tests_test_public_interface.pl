% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_handler_duties_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__cn_pipl_handler_duties_pipl_handler_duties, [decide_pipl_handler_duties/2, pipl_handler_duties_status/2, pipl_handler_duties_checklist/2, pipl_handler_duties_decision_resolvable/1, pipl_handler_duties_status_values/1, duty_status/4, duty_contents/2, provenance/2]).
:- use_module(m__cn_pipl_handler_duties_fixtures, [pipl_handler_duties_subject/1, pipl_handler_duties_profile_for/2, pipl_handler_duties_assess/2]).
:- use_module(m__cn_pipl_handler_duties_kernel, [pipl_handler_duties_input_problems/2]).
:- use_module(m__cn_pipl_handler_duties_queries, [pipl_handler_duties_what_if/4]).

citation_set(no_citations, []).
citation_set(not_in_force_citations, [cite(cn_pipl_art_74_p1)]).
citation_set(compliance_citations, [cite(cn_pipl_art_51_p1), cite(cn_pipl_art_73_p1_i1)]).
citation_set(officer_citations, [cite(cn_pipl_art_52_p1), cite(cn_pipl_art_73_p1_i1)]).
citation_set(contact_citations, [cite(cn_pipl_art_52_p1), cite(cn_pipl_art_52_p2), cite(cn_pipl_art_73_p1_i1)]).
citation_set(representative_citations, [cite(cn_pipl_art_53_p1), cite(cn_pipl_art_3_p2), cite(cn_pipl_art_3_p2_i1), cite(cn_pipl_art_3_p2_i2), cite(cn_pipl_art_3_p2_i3), cite(cn_pipl_art_73_p1_i1)]).
citation_set(audit_citations, [cite(cn_pipl_art_54_p1), cite(cn_pipl_art_73_p1_i1)]).
citation_set(occasion_citations, [cite(cn_pipl_art_55_p1), cite(cn_pipl_art_55_p1_i1), cite(cn_pipl_art_55_p1_i2), cite(cn_pipl_art_55_p1_i3), cite(cn_pipl_art_55_p1_i4), cite(cn_pipl_art_55_p1_i5), cite(cn_pipl_art_73_p1_i1), cite(cn_pipl_art_73_p1_i2)]).
citation_set(assessment_required_citations, [cite(cn_pipl_art_55_p1), cite(cn_pipl_art_55_p1_i1), cite(cn_pipl_art_55_p1_i2), cite(cn_pipl_art_55_p1_i3), cite(cn_pipl_art_55_p1_i4), cite(cn_pipl_art_55_p1_i5), cite(cn_pipl_art_56_p1), cite(cn_pipl_art_73_p1_i1), cite(cn_pipl_art_73_p1_i2)]).
citation_set(retention_required_citations, [cite(cn_pipl_art_56_p2), cite(cn_pipl_art_55_p1), cite(cn_pipl_art_55_p1_i1), cite(cn_pipl_art_55_p1_i2), cite(cn_pipl_art_55_p1_i3), cite(cn_pipl_art_55_p1_i4), cite(cn_pipl_art_55_p1_i5), cite(cn_pipl_art_73_p1_i1), cite(cn_pipl_art_73_p1_i2)]).
citation_set(breach_citations, [cite(cn_pipl_art_57_p1), cite(cn_pipl_art_73_p1_i1)]).
citation_set(individuals_citations, [cite(cn_pipl_art_57_p1), cite(cn_pipl_art_57_p2), cite(cn_pipl_art_73_p1_i1)]).
citation_set(platform_citations, [cite(cn_pipl_art_58_p1), cite(cn_pipl_art_73_p1_i1)]).
citation_set(entrusted_citations, [cite(cn_pipl_art_59_p1)]).

expected_result(day_before_entry_into_force, compliance_measures, not_in_force, not_in_force_citations).
expected_result(day_before_entry_into_force, entrusted_party_safeguards, not_in_force, not_in_force_citations).
expected_result(september_before_entry_into_force, compliance_audit, not_in_force, not_in_force_citations).
expected_result(two_thousand_leap_day, impact_assessment, not_in_force, not_in_force_citations).
expected_result(day_of_entry_into_force, compliance_measures, required, compliance_citations).
expected_result(reference_date_absent, compliance_measures, indeterminate([reference_date]), no_citations).
expected_result(pinned_text_status_absent, compliance_measures, indeterminate([pinned_articles_unamended_on_reference_date]), no_citations).
expected_result(amended_text, compliance_measures, pinned_text_not_applicable, no_citations).
expected_result(amended_text, entrusted_party_safeguards, pinned_text_not_applicable, no_citations).
expected_result(handler_only, compliance_measures, required, compliance_citations).
expected_result(handler_only, compliance_audit, required, audit_citations).
expected_result(handler_only, protection_officer, indeterminate([reaches_officer_quantity]), no_citations).
expected_result(handler_only, officer_contact_details, indeterminate([reaches_officer_quantity]), no_citations).
expected_result(handler_only, china_representative, indeterminate([handler_located_outside_china]), no_citations).
expected_result(handler_only, impact_assessment, indeterminate([processes_sensitive_personal_information]), no_citations).
expected_result(handler_only, assessment_record_retention, indeterminate([processes_sensitive_personal_information]), no_citations).
expected_result(handler_only, breach_remedial_measures, indeterminate([incident_occurred_or_possible]), no_citations).
expected_result(handler_only, breach_notice_to_department, indeterminate([incident_occurred_or_possible]), no_citations).
expected_result(handler_only, breach_notice_to_individuals, indeterminate([incident_occurred_or_possible]), no_citations).
expected_result(handler_only, large_platform_obligations, indeterminate([important_platform_handler]), no_citations).
expected_result(handler_only, entrusted_party_safeguards, indeterminate([processes_on_entrustment]), no_citations).
expected_result(not_a_handler, compliance_measures, not_required, compliance_citations).
expected_result(not_a_handler, compliance_audit, not_required, audit_citations).
expected_result(not_a_handler, protection_officer, not_required, officer_citations).
expected_result(not_a_handler, china_representative, not_required, representative_citations).
expected_result(not_a_handler, impact_assessment, not_required, occasion_citations).
expected_result(not_a_handler, breach_notice_to_individuals, not_required, individuals_citations).
expected_result(not_a_handler, large_platform_obligations, not_required, platform_citations).
expected_result(not_a_handler, entrusted_party_safeguards, indeterminate([processes_on_entrustment]), no_citations).
expected_result(handler_unstated, compliance_measures, indeterminate([decides_purposes_and_means]), no_citations).
expected_result(handler_unstated, protection_officer, indeterminate([decides_purposes_and_means]), no_citations).
expected_result(handler_unstated, entrusted_party_safeguards, indeterminate([processes_on_entrustment]), no_citations).
expected_result(handler_unsure, compliance_measures, needs_legal_review(open_textured(decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1)), [inputs_relied_on([decides_purposes_and_means - unsure])]), no_citations).
expected_result(handler_unsure, compliance_audit, needs_legal_review(open_textured(decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1)), [inputs_relied_on([decides_purposes_and_means - unsure])]), no_citations).
expected_result(handler_unsure, protection_officer, indeterminate([reaches_officer_quantity]), no_citations).
expected_result(officer_quantity_reached, protection_officer, required, officer_citations).
expected_result(officer_quantity_reached, officer_contact_details, required, contact_citations).
expected_result(officer_quantity_not_reached, protection_officer, not_required, officer_citations).
expected_result(officer_quantity_not_reached, officer_contact_details, not_required, contact_citations).
expected_result(officer_unsure_handler, protection_officer, needs_legal_review(open_textured(decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1)), [inputs_relied_on([decides_purposes_and_means - unsure])]), no_citations).
expected_result(officer_unsure_handler, officer_contact_details, needs_legal_review(open_textured(decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1)), [inputs_relied_on([decides_purposes_and_means - unsure])]), no_citations).
expected_result(offshore_services_handler, china_representative, required, representative_citations).
expected_result(onshore_services_handler, china_representative, not_required, representative_citations).
expected_result(offshore_no_case, china_representative, not_required, representative_citations).
expected_result(offshore_other_case, china_representative, required, representative_citations).
expected_result(offshore_case_unstated, china_representative, indeterminate([offers_products_or_services_to_individuals_in_china]), no_citations).
expected_result(offshore_location_unstated, china_representative, indeterminate([handler_located_outside_china]), no_citations).
expected_result(offshore_purpose_unsure, china_representative, needs_legal_review(open_textured(offers_products_or_services_to_individuals_in_china, cite(cn_pipl_art_3_p2_i1)), [inputs_relied_on([decides_purposes_and_means - true, offers_products_or_services_to_individuals_in_china - unsure, analyses_or_evaluates_individuals_in_china - false])]), no_citations).
expected_result(offshore_analysis_unsure, china_representative, needs_legal_review(open_textured(analyses_or_evaluates_individuals_in_china, cite(cn_pipl_art_3_p2_i2)), [inputs_relied_on([decides_purposes_and_means - true, offers_products_or_services_to_individuals_in_china - false, analyses_or_evaluates_individuals_in_china - unsure])]), no_citations).
expected_result(offshore_unsure_handler, china_representative, needs_legal_review(open_textured(decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1)), [inputs_relied_on([decides_purposes_and_means - unsure, offers_products_or_services_to_individuals_in_china - true])]), no_citations).
expected_result(automated_decision_handler, impact_assessment, required_in_advance, assessment_required_citations).
expected_result(automated_decision_handler, assessment_record_retention, required_for_at_least_three_years, retention_required_citations).
expected_result(no_assessment_occasion, impact_assessment, not_required, occasion_citations).
expected_result(no_assessment_occasion, assessment_record_retention, not_required, occasion_citations).
expected_result(significant_impact_unsure, impact_assessment, needs_legal_review(open_textured(other_significant_impact_processing, cite(cn_pipl_art_55_p1_i5)), [inputs_relied_on([decides_purposes_and_means - true, other_significant_impact_processing - unsure])]), no_citations).
expected_result(significant_impact_unsure, assessment_record_retention, needs_legal_review(open_textured(other_significant_impact_processing, cite(cn_pipl_art_55_p1_i5)), [inputs_relied_on([decides_purposes_and_means - true, other_significant_impact_processing - unsure])]), no_citations).
expected_result(incident_harm_not_avoided, breach_remedial_measures, required_immediately, breach_citations).
expected_result(incident_harm_not_avoided, breach_notice_to_department, required, breach_citations).
expected_result(incident_harm_not_avoided, breach_notice_to_individuals, required, individuals_citations).
expected_result(no_incident, breach_remedial_measures, not_required, breach_citations).
expected_result(no_incident, breach_notice_to_department, not_required, breach_citations).
expected_result(no_incident, breach_notice_to_individuals, not_required, individuals_citations).
expected_result(incident_harm_avoided, breach_notice_to_individuals, notice_may_be_omitted, individuals_citations).
expected_result(incident_harm_avoided, breach_remedial_measures, required_immediately, breach_citations).
expected_result(incident_department_required, breach_notice_to_individuals, required, individuals_citations).
expected_result(incident_harm_unstated, breach_notice_to_individuals, indeterminate([harm_effectively_avoided]), no_citations).
expected_result(incident_harm_unstated, breach_remedial_measures, required_immediately, breach_citations).
expected_result(incident_requirement_unstated, breach_notice_to_individuals, indeterminate([department_required_individual_notice]), no_citations).
expected_result(incident_harm_unsure, breach_notice_to_individuals, needs_legal_review(open_textured(harm_effectively_avoided, cite(cn_pipl_art_57_p2)), [inputs_relied_on([decides_purposes_and_means - true, harm_effectively_avoided - unsure])]), no_citations).
expected_result(incident_unsure_handler, breach_notice_to_individuals, needs_legal_review(open_textured(decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1)), [inputs_relied_on([decides_purposes_and_means - unsure, harm_effectively_avoided - true])]), no_citations).
expected_result(incident_unsure_handler, breach_remedial_measures, needs_legal_review(open_textured(decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1)), [inputs_relied_on([decides_purposes_and_means - unsure])]), no_citations).
expected_result(important_platform, large_platform_obligations, required, platform_citations).
expected_result(ordinary_platform, large_platform_obligations, not_required, platform_citations).
expected_result(platform_unsure, large_platform_obligations, needs_legal_review(open_textured(important_platform_handler, cite(cn_pipl_art_58_p1)), [inputs_relied_on([decides_purposes_and_means - true, important_platform_handler - unsure])]), no_citations).
expected_result(platform_unsure_handler, large_platform_obligations, needs_legal_review(open_textured(decides_purposes_and_means, cite(cn_pipl_art_73_p1_i1)), [inputs_relied_on([decides_purposes_and_means - unsure, important_platform_handler - true])]), no_citations).
expected_result(entrusted_party, entrusted_party_safeguards, required, entrusted_citations).
expected_result(entrusted_party, compliance_measures, not_required, compliance_citations).
expected_result(no_duties_at_all, entrusted_party_safeguards, not_required, entrusted_citations).
expected_result(unknown_key_profile, compliance_measures, input_problems([unknown_key(colour)]), no_citations).
expected_result(crisp_key_given_unsure, protection_officer, input_problems([wrong_type(reaches_officer_quantity)]), no_citations).
expected_result(repeated_key, compliance_audit, input_problems([duplicate_key(decides_purposes_and_means)]), no_citations).
expected_result(nineteen_hundred_leap_day, compliance_measures, input_problems([wrong_type(reference_date)]), no_citations).
expected_result(stray_element, entrusted_party_safeguards, input_problems([wrong_type(profile)]), no_citations).

expected_status(day_before_entry_into_force, not_in_force).
expected_status(day_of_entry_into_force, duties_owed).
expected_status(two_thousand_leap_day, not_in_force).
expected_status(amended_text, pinned_text_not_applicable).
expected_status(reference_date_absent, duties_pending).
expected_status(handler_unstated, duties_pending).
expected_status(not_a_handler, duties_pending).
expected_status(handler_only, duties_owed).
expected_status(entrusted_party, duties_owed).
expected_status(no_duties_at_all, no_duties_owed).
expected_status(unknown_key_profile, input_problems([unknown_key(colour)])).
expected_status(stray_element, input_problems([wrong_type(profile)])).

expectation_holds(expected(Subject, Duty, Result, CitationSetName)) :-
    pipl_handler_duties_profile_for(Subject, Profile),
    citation_set(CitationSetName, ExpectedCitations),
    findall(Answer - AnswerCitations, duty_status(Duty, Profile, Answer, AnswerCitations), Answers),
    Answers = [OnlyAnswer - OnlyCitations],
    OnlyAnswer == Result,
    clausal_msort(OnlyCitations, SortedCitations),
    clausal_msort(ExpectedCitations, SortedCitations).

status_holds(Subject - Status) :-
    pipl_handler_duties_profile_for(Subject, Profile),
    findall(Answer, pipl_handler_duties_status(Profile, Answer), Answers),
    Answers == [Status].

subject_is_expected(Subject) :-
    findall(Duty, expected_result(Subject, Duty, _, _), Duties),
    length(Duties, Count),
    Count >= 1.

subject_has_one_profile(Subject) :-
    findall(Profile, pipl_handler_duties_profile_for(Subject, Profile), Profiles),
    length(Profiles, 1).

item_carries_citation(item(_Duty, _Result, cite(Key))) :-
    atom(Key).

test(every_expected_duty_result_holds_exactly_once) :-
    findall(expected(Subject, Duty, Result, Name), expected_result(Subject, Duty, Result, Name), Expectations),
    length(Expectations, ExpectationCount),
    ExpectationCount >= 80,
    maplist(expectation_holds, Expectations).
test(every_expected_facade_status_holds_exactly_once) :-
    findall(Subject - Status, expected_status(Subject, Status), Expectations),
    maplist(status_holds, Expectations).
test(every_subject_has_one_profile_and_an_expectation) :-
    findall(Subject, pipl_handler_duties_subject(Subject), Subjects),
    length(Subjects, 45),
    maplist(subject_has_one_profile, Subjects),
    maplist(subject_is_expected, Subjects).
test(the_day_before_entry_into_force_is_not_in_force) :-
    pipl_handler_duties_profile_for(day_before_entry_into_force, Profile),
    duty_status(compliance_measures, Profile, not_in_force, [cite(cn_pipl_art_74_p1)]).
test(the_day_of_entry_into_force_is_required) :-
    pipl_handler_duties_profile_for(day_of_entry_into_force, Profile),
    duty_status(compliance_measures, Profile, required, _).
test(a_handler_reaching_the_quantity_owes_an_officer) :-
    pipl_handler_duties_profile_for(officer_quantity_reached, Profile),
    duty_status(protection_officer, Profile, required, _).
test(a_handler_below_the_quantity_owes_no_officer) :-
    pipl_handler_duties_profile_for(officer_quantity_not_reached, Profile),
    duty_status(protection_officer, Profile, not_required, _).
test(an_offshore_handler_owes_a_representative) :-
    pipl_handler_duties_profile_for(offshore_services_handler, Profile),
    duty_status(china_representative, Profile, required, _).
test(an_onshore_handler_owes_no_representative) :-
    pipl_handler_duties_profile_for(onshore_services_handler, Profile),
    duty_status(china_representative, Profile, not_required, _).
test(automated_decisions_need_an_assessment_in_advance) :-
    pipl_handler_duties_profile_for(automated_decision_handler, Profile),
    duty_status(impact_assessment, Profile, required_in_advance, _).
test(no_occasion_needs_no_assessment) :-
    pipl_handler_duties_profile_for(no_assessment_occasion, Profile),
    duty_status(impact_assessment, Profile, not_required, _).
test(avoided_harm_without_requirement_permits_omission) :-
    pipl_handler_duties_profile_for(incident_harm_avoided, Profile),
    duty_status(breach_notice_to_individuals, Profile, notice_may_be_omitted, _).
test(a_department_requirement_makes_notice_required) :-
    pipl_handler_duties_profile_for(incident_department_required, Profile),
    duty_status(breach_notice_to_individuals, Profile, required, _).
test(an_important_platform_owes_the_platform_obligations) :-
    pipl_handler_duties_profile_for(important_platform, Profile),
    duty_status(large_platform_obligations, Profile, required, _).
test(an_entrusted_party_has_duties_owed) :-
    pipl_handler_duties_assess(entrusted_party, pipl_handler_duties_verdict(duties_owed, Checklist)),
    length(Checklist, 12).
test(the_unentrusted_non_handler_owes_no_duties) :-
    pipl_handler_duties_assess(no_duties_at_all, pipl_handler_duties_verdict(no_duties_owed, _Checklist)).
test(the_checklist_cites_every_duty) :-
    pipl_handler_duties_profile_for(handler_only, Profile),
    pipl_handler_duties_checklist(Profile, Checklist),
    length(Checklist, 12),
    maplist(item_carries_citation, Checklist),
    member(item(compliance_measures, required, cite(cn_pipl_art_51_p1)), Checklist).
test(a_bad_profile_has_an_empty_checklist) :-
    pipl_handler_duties_profile_for(unknown_key_profile, Profile),
    pipl_handler_duties_checklist(Profile, []).
test(the_facade_resolves_and_uses_its_vocabulary) :-
    pipl_handler_duties_profile_for(handler_only, Profile),
    pipl_handler_duties_decision_resolvable(Profile),
    pipl_handler_duties_status(Profile, Status),
    pipl_handler_duties_status_values(StatusValues),
    member(Status, StatusValues).
test(the_facade_answers_once) :-
    pipl_handler_duties_profile_for(not_a_handler, Profile),
    findall(Verdict, decide_pipl_handler_duties(Profile, Verdict), Verdicts),
    length(Verdicts, 1).
test(a_well_formed_fixture_has_no_input_problem) :-
    pipl_handler_duties_profile_for(incident_harm_unsure, Profile),
    pipl_handler_duties_input_problems(Profile, []).
test(a_repeated_key_is_a_duplicate_only) :-
    pipl_handler_duties_profile_for(repeated_key, Profile),
    pipl_handler_duties_input_problems(Profile, [duplicate_key(decides_purposes_and_means)]).
test(a_stray_element_is_not_an_attribute_list) :-
    pipl_handler_duties_profile_for(stray_element, Profile),
    pipl_handler_duties_input_problems(Profile, [wrong_type(profile)]).
test(the_breach_notice_contents_are_one_list) :-
    findall(Items, duty_contents(breach_notice, Items), Answers),
    Answers == [[content_item(categories_causes_and_possible_harm, cite(cn_pipl_art_57_p1_i1)), content_item(remedial_measures_and_steps_individuals_can_take, cite(cn_pipl_art_57_p1_i2)), content_item(handler_contact_details, cite(cn_pipl_art_57_p1_i3))]].
test(the_topic_lists_have_their_lengths) :-
    duty_contents(compliance_measures, MeasureItems),
    length(MeasureItems, 6),
    duty_contents(impact_assessment, AssessmentItems),
    length(AssessmentItems, 3),
    duty_contents(large_platform_obligations, PlatformItems),
    length(PlatformItems, 4).
test(the_platform_list_starts_with_the_compliance_system) :-
    duty_contents(large_platform_obligations, [content_item(compliance_system_and_independent_supervisory_body, cite(cn_pipl_art_58_p1_i1))|_]).
test(a_provenance_item_holds_a_clause_and_its_citations) :-
    provenance(duty_status, [cite(cn_pipl_art_74_p1)]).
test(a_provenance_item_may_hold_no_citations) :-
    provenance(duty_status, []).
test(entrustment_turns_no_duties_into_duties_owed) :-
    pipl_handler_duties_profile_for(no_duties_at_all, Profile),
    pipl_handler_duties_what_if(Profile, processes_on_entrustment, true, duties_owed).
test(an_early_day_turns_a_handler_to_not_in_force) :-
    pipl_handler_duties_profile_for(handler_only, Profile),
    pipl_handler_duties_what_if(Profile, reference_date, date(2021, 10, 31), not_in_force).

test(the_day_before_entry_into_force_is_not_required, fail) :-
    pipl_handler_duties_profile_for(day_before_entry_into_force, Profile),
    duty_status(compliance_measures, Profile, required, _).
test(the_day_of_entry_into_force_is_not_not_in_force, fail) :-
    pipl_handler_duties_profile_for(day_of_entry_into_force, Profile),
    duty_status(compliance_measures, Profile, not_in_force, _).
test(a_handler_below_the_quantity_is_not_required_an_officer, fail) :-
    pipl_handler_duties_profile_for(officer_quantity_not_reached, Profile),
    duty_status(protection_officer, Profile, required, _).
test(an_onshore_handler_is_not_required_a_representative, fail) :-
    pipl_handler_duties_profile_for(onshore_services_handler, Profile),
    duty_status(china_representative, Profile, required, _).
test(no_occasion_is_not_required_in_advance, fail) :-
    pipl_handler_duties_profile_for(no_assessment_occasion, Profile),
    duty_status(impact_assessment, Profile, required_in_advance, _).
test(avoided_harm_without_requirement_is_not_required, fail) :-
    pipl_handler_duties_profile_for(incident_harm_avoided, Profile),
    duty_status(breach_notice_to_individuals, Profile, required, _).
test(a_department_requirement_does_not_permit_omission, fail) :-
    pipl_handler_duties_profile_for(incident_department_required, Profile),
    duty_status(breach_notice_to_individuals, Profile, notice_may_be_omitted, _).
test(an_ordinary_platform_is_not_required_them, fail) :-
    pipl_handler_duties_profile_for(ordinary_platform, Profile),
    duty_status(large_platform_obligations, Profile, required, _).
test(the_unentrusted_non_handler_does_not_have_duties_owed, fail) :-
    pipl_handler_duties_assess(no_duties_at_all, pipl_handler_duties_verdict(duties_owed, _Checklist)).
test(a_provenance_item_needs_a_citation_list, fail) :-
    provenance(duty_status, not_a_list).

cp_test_names([every_expected_duty_result_holds_exactly_once, every_expected_facade_status_holds_exactly_once, every_subject_has_one_profile_and_an_expectation, the_day_before_entry_into_force_is_not_in_force, the_day_of_entry_into_force_is_required, a_handler_reaching_the_quantity_owes_an_officer, a_handler_below_the_quantity_owes_no_officer, an_offshore_handler_owes_a_representative, an_onshore_handler_owes_no_representative, automated_decisions_need_an_assessment_in_advance, no_occasion_needs_no_assessment, avoided_harm_without_requirement_permits_omission, a_department_requirement_makes_notice_required, an_important_platform_owes_the_platform_obligations, an_entrusted_party_has_duties_owed, the_unentrusted_non_handler_owes_no_duties, the_checklist_cites_every_duty, a_bad_profile_has_an_empty_checklist, the_facade_resolves_and_uses_its_vocabulary, the_facade_answers_once, a_well_formed_fixture_has_no_input_problem, a_repeated_key_is_a_duplicate_only, a_stray_element_is_not_an_attribute_list, the_breach_notice_contents_are_one_list, the_topic_lists_have_their_lengths, the_platform_list_starts_with_the_compliance_system, a_provenance_item_holds_a_clause_and_its_citations, a_provenance_item_may_hold_no_citations, entrustment_turns_no_duties_into_duties_owed, an_early_day_turns_a_handler_to_not_in_force]).
cp_test_fail_names([the_day_before_entry_into_force_is_not_required, the_day_of_entry_into_force_is_not_not_in_force, a_handler_below_the_quantity_is_not_required_an_officer, an_onshore_handler_is_not_required_a_representative, no_occasion_is_not_required_in_advance, avoided_harm_without_requirement_is_not_required, a_department_requirement_does_not_permit_omission, an_ordinary_platform_is_not_required_them, the_unentrusted_non_handler_does_not_have_duties_owed, a_provenance_item_needs_a_citation_list]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
