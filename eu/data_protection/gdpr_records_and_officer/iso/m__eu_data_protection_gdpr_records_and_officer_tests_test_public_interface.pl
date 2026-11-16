% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_records_and_officer_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_records_and_officer_gdpr_records_and_officer, [decide_gdpr_records_and_officer/2, gdpr_records_and_officer_status/2, gdpr_records_and_officer_checklist/2, gdpr_records_and_officer_decision_resolvable/1, gdpr_records_and_officer_status_values/1, record_obligation/2, record_missing_items/2, data_protection_officer_designation/2, officer_missing_tasks/2, data_protection_officer_outside_facts/2, officer_position_status/5]).
:- use_module(m__eu_data_protection_gdpr_records_and_officer_fixtures, [gdpr_records_and_officer_subject/1, gdpr_records_and_officer_profile_for/2, gdpr_records_and_officer_assess/2]).

assessments(Subject, Verdicts) :-
    findall(Verdict, gdpr_records_and_officer_assess(Subject, Verdict), Verdicts).

checklist_statuses(Subject, RecordStatus, DesignationStatus, TaskStatus) :-
    gdpr_records_and_officer_profile_for(Subject, Profile),
    gdpr_records_and_officer_checklist(Profile, [item(record_of_processing_activities, RecordStatus, _), item(data_protection_officer_designation, DesignationStatus, _), item(data_protection_officer_tasks, TaskStatus, _)]).

subject_assessed_once(Subject) :-
    assessments(Subject, Verdicts),
    length(Verdicts, 1).

subject_status_in_vocabulary(Subject) :-
    gdpr_records_and_officer_assess(Subject, gdpr_records_and_officer_verdict(Status, _)),
    gdpr_records_and_officer_status_values(StatusValues),
    member(Status, StatusValues).

subject_has_checklist(Subject) :-
    gdpr_records_and_officer_profile_for(Subject, Profile),
    gdpr_records_and_officer_checklist(Profile, [_FirstItem|_OtherItems]).

fixture_attestation(attestation(fixture_host, fixture_moment, fixture_reason, none)).

test(every_subject_is_assessed_exactly_once) :-
    findall(Subject, gdpr_records_and_officer_subject(Subject), Subjects),
    length(Subjects, 17),
    maplist(subject_assessed_once, Subjects).
test(every_subject_status_is_in_the_vocabulary) :-
    findall(Subject, gdpr_records_and_officer_subject(Subject), Subjects),
    maplist(subject_status_in_vocabulary, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, gdpr_records_and_officer_subject(Subject), Subjects),
    maplist(subject_has_checklist, Subjects).
test(at_249_the_record_is_not_required) :-
    assessments(small_controller_exempt_at_249, Verdicts),
    Verdicts == [gdpr_records_and_officer_verdict(record_not_required, [cite(eu_reg_2016_679_art_30_5)])].
test(at_250_the_controller_record_is_required) :-
    assessments(controller_at_ceiling_250, Verdicts),
    Verdicts == [gdpr_records_and_officer_verdict(record_required, [cite(eu_reg_2016_679_art_30_1)])].
test(the_249_checklist_marks_the_record_unmet) :-
    checklist_statuses(small_controller_exempt_at_249, unmet(record_not_required), _, _).
test(the_250_checklist_marks_the_record_met) :-
    checklist_statuses(controller_at_ceiling_250, met, _, _).
test(special_categories_owe_the_processor_record) :-
    assessments(small_processor_special_categories, Verdicts),
    Verdicts == [gdpr_records_and_officer_verdict(record_required, [cite(eu_reg_2016_679_art_30_2)])].
test(no_trigger_leaves_the_small_processor_exempt) :-
    assessments(small_processor_without_trigger, Verdicts),
    Verdicts == [gdpr_records_and_officer_verdict(record_not_required, [cite(eu_reg_2016_679_art_30_5)])].
test(both_roles_owe_both_records) :-
    assessments(both_roles_large_entity, Verdicts),
    Verdicts == [gdpr_records_and_officer_verdict(record_required, [cite(eu_reg_2016_679_art_30_1), cite(eu_reg_2016_679_art_30_2)])].
test(neither_role_is_unresolved) :-
    assessments(neither_role_entity, Verdicts),
    Verdicts == [gdpr_records_and_officer_verdict(record_unresolved, [])].
test(controller_role_is_required) :-
    assessments(controller_role_entity, Verdicts),
    Verdicts == [gdpr_records_and_officer_verdict(record_required, [cite(eu_reg_2016_679_art_30_1)])].
test(neither_role_checklist_refers) :-
    checklist_statuses(neither_role_entity, unknown([]), _, _).
test(unsure_occasional_is_unresolved) :-
    assessments(unsure_occasional_controller, Verdicts),
    Verdicts == [gdpr_records_and_officer_verdict(record_unresolved, [])].
test(not_occasional_owes_the_record) :-
    assessments(not_occasional_controller, Verdicts),
    Verdicts == [gdpr_records_and_officer_verdict(record_required, [cite(eu_reg_2016_679_art_30_1)])].
test(not_occasional_is_resolvable) :-
    gdpr_records_and_officer_profile_for(not_occasional_controller, Profile),
    gdpr_records_and_officer_decision_resolvable(Profile).
test(absent_headcount_is_unresolved) :-
    assessments(headcount_absent_controller, Verdicts),
    Verdicts == [gdpr_records_and_officer_verdict(record_unresolved, [])].
test(absent_headcount_is_named_in_the_checklist) :-
    checklist_statuses(headcount_absent_controller, unknown([persons_employed]), _, _).
test(exempt_controller_is_resolvable) :-
    gdpr_records_and_officer_profile_for(small_controller_exempt_at_249, Profile),
    gdpr_records_and_officer_decision_resolvable(Profile).
test(public_authority_must_designate) :-
    checklist_statuses(public_authority_controller, met, met, _).
test(court_in_judicial_capacity_needs_no_designation) :-
    checklist_statuses(court_in_judicial_capacity_controller, met, unmet(designation_not_required), _).
test(public_authority_record_verdict) :-
    assessments(public_authority_controller, Verdicts),
    Verdicts == [gdpr_records_and_officer_verdict(record_required, [cite(eu_reg_2016_679_art_30_1)])].
test(member_state_law_requires_designation) :-
    checklist_statuses(member_state_law_requires_officer, met, met, _).
test(member_state_law_not_requiring_gives_no_designation) :-
    checklist_statuses(member_state_law_does_not_require_officer, met, unmet(designation_not_required), _).
test(mandate_lacking_contact_point_is_unmet) :-
    checklist_statuses(officer_mandate_lacks_contact_point, met, _, unmet(tasks_missing)).
test(complete_mandate_is_met) :-
    checklist_statuses(officer_mandate_complete, met, _, met).
test(duplicate_headcount_is_unresolved) :-
    assessments(duplicate_headcount_malformed, Verdicts),
    Verdicts == [gdpr_records_and_officer_verdict(record_unresolved, [])].
test(duplicate_headcount_checklist_is_malformed) :-
    checklist_statuses(duplicate_headcount_malformed, unmet(malformed_profile), unmet(malformed_profile), unmet(malformed_profile)).
test(single_headcount_is_required) :-
    gdpr_records_and_officer_profile_for(controller_role_entity, Profile),
    gdpr_records_and_officer_status(Profile, record_required).
test(decide_matches_assess_for_the_ceiling_case) :-
    gdpr_records_and_officer_profile_for(controller_at_ceiling_250, Profile),
    findall(Verdict, decide_gdpr_records_and_officer(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_records_and_officer_verdict(record_required, [cite(eu_reg_2016_679_art_30_1)])].
test(record_obligation_owes_the_controller_record_at_250) :-
    gdpr_records_and_officer_profile_for(controller_at_ceiling_250, Profile),
    findall(Answer, record_obligation(Profile, Answer), Answers),
    Answers == [[keep_controller_record(cite(eu_reg_2016_679_art_30_1))]].
test(record_obligation_is_exempt_at_249) :-
    gdpr_records_and_officer_profile_for(small_controller_exempt_at_249, Profile),
    findall(Answer, record_obligation(Profile, Answer), Answers),
    Answers == [[no_record_required(cite(eu_reg_2016_679_art_30_5))]].
test(record_obligation_refers_an_entity_with_neither_role) :-
    gdpr_records_and_officer_profile_for(neither_role_entity, Profile),
    findall(Answer, record_obligation(Profile, Answer), Answers),
    Answers == [needs_legal_review(not_governed_here([cite(eu_reg_2016_679_art_30_1), cite(eu_reg_2016_679_art_30_2)]), [inputs_relied_on([acts_as_controller - false, acts_as_processor - false])])].
test(record_obligation_names_the_absent_headcount) :-
    gdpr_records_and_officer_profile_for(headcount_absent_controller, Profile),
    findall(Answer, record_obligation(Profile, Answer), Answers),
    Answers == [indeterminate([persons_employed])].
test(record_obligation_refers_an_unsure_occasional_judgement) :-
    gdpr_records_and_officer_profile_for(unsure_occasional_controller, Profile),
    findall(Answer, record_obligation(Profile, Answer), Answers),
    Answers == [needs_legal_review(open_textured(processing_is_occasional, cite(eu_reg_2016_679_art_30_5)), [inputs_relied_on([persons_employed - 100, processing_is_occasional - unsure, processing_likely_to_result_in_risk - false])])].
test(record_obligation_names_a_duplicate_key) :-
    gdpr_records_and_officer_profile_for(duplicate_headcount_malformed, Profile),
    findall(Answer, record_obligation(Profile, Answer), Answers),
    Answers == [input_problems([duplicate_key(persons_employed)])].
test(record_missing_items_is_empty_when_exempt) :-
    gdpr_records_and_officer_profile_for(small_controller_exempt_at_249, Profile),
    findall(Answer, record_missing_items(Profile, Answer), Answers),
    Answers == [[]].
test(record_missing_items_names_the_absent_content_keys) :-
    gdpr_records_and_officer_profile_for(controller_role_entity, Profile),
    findall(Answer, record_missing_items(Profile, Answer), Answers),
    Answers == [indeterminate([controller_record_has_categories_of_data_subjects_and_personal_data, controller_record_has_categories_of_recipients, controller_record_has_contact_details, controller_record_has_erasure_time_limits, controller_record_has_purposes, controller_record_has_security_measures_description, controller_transfers_to_third_countries])].
test(record_missing_items_lists_the_missing_purposes) :-
    Profile = [attribute(acts_as_controller, true), attribute(acts_as_processor, false), attribute(persons_employed, 300), attribute(controller_record_has_contact_details, true), attribute(controller_record_has_purposes, false), attribute(controller_record_has_categories_of_data_subjects_and_personal_data, true), attribute(controller_record_has_categories_of_recipients, true), attribute(controller_transfers_to_third_countries, false), attribute(controller_record_has_erasure_time_limits, true), attribute(controller_record_has_security_measures_description, true)],
    findall(Answer, record_missing_items(Profile, Answer), Answers),
    Answers == [[missing_record_item(controller, purposes_of_the_processing, cite(eu_reg_2016_679_art_30_1_b))]].
test(record_missing_items_refers_an_entity_with_neither_role) :-
    gdpr_records_and_officer_profile_for(neither_role_entity, Profile),
    record_missing_items(Profile, needs_legal_review(not_governed_here(_), _)).
test(designation_for_a_public_authority_cites_limb_a) :-
    gdpr_records_and_officer_profile_for(public_authority_controller, Profile),
    findall(Answer, data_protection_officer_designation(Profile, Answer), Answers),
    Answers == [[designate_data_protection_officer(cite(eu_reg_2016_679_art_37_1_a))]].
test(designation_for_a_court_is_not_required) :-
    gdpr_records_and_officer_profile_for(court_in_judicial_capacity_controller, Profile),
    findall(Answer, data_protection_officer_designation(Profile, Answer), Answers),
    Answers == [[no_designation_required(cite(eu_reg_2016_679_art_37_4))]].
test(officer_missing_tasks_lists_the_contact_point) :-
    gdpr_records_and_officer_profile_for(officer_mandate_lacks_contact_point, Profile),
    findall(Answer, officer_missing_tasks(Profile, Answer), Answers),
    Answers == [[missing_officer_task(acting_as_contact_point, cite(eu_reg_2016_679_art_39_1_e))]].
test(officer_missing_tasks_is_empty_for_a_complete_mandate) :-
    gdpr_records_and_officer_profile_for(officer_mandate_complete, Profile),
    findall(Answer, officer_missing_tasks(Profile, Answer), Answers),
    Answers == [[]].
test(officer_missing_tasks_names_absent_flags) :-
    gdpr_records_and_officer_profile_for(controller_role_entity, Profile),
    findall(Answer, officer_missing_tasks(Profile, Answer), Answers),
    Answers == [indeterminate([officer_tasks_include_acting_as_contact_point, officer_tasks_include_advising_on_impact_assessment, officer_tasks_include_cooperating_with_supervisory_authority, officer_tasks_include_informing_and_advising, officer_tasks_include_monitoring_compliance])].
test(outside_facts_copy_the_attested_term_and_mark_absence) :-
    gdpr_records_and_officer_profile_for(public_authority_controller, Profile),
    fixture_attestation(Attestation),
    findall(Answer, data_protection_officer_outside_facts(Profile, Answer), Answers),
    Answers == [[outside_fact(is_public_authority_or_body, attested(true, Attestation)), outside_fact(union_or_member_state_law_requires_data_protection_officer, absent)]].
test(outside_facts_are_both_absent_for_a_bare_profile) :-
    gdpr_records_and_officer_profile_for(controller_role_entity, Profile),
    data_protection_officer_outside_facts(Profile, [outside_fact(is_public_authority_or_body, absent), outside_fact(union_or_member_state_law_requires_data_protection_officer, absent)]).
test(position_absent_reporting_statement_refers) :-
    findall(Result - Basis - Citations, officer_position_status([], direct_reporting, Result, Basis, Citations), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_38_3), cite(officer_reporting_line_statement)), [resolution(cite(officer_reporting_line_statement), not_attempted), inputs_relied_on([officer_reports_to_highest_management_level - absent])]) - [] - []].
test(position_involvement_attested_true_with_url_evidence_is_met) :-
    Attested = attested(true, attestation(host_system, recorded_moment, stated_reason, url(source_address, retrieved_moment))),
    Profile = [attribute(officer_involved_properly_and_in_time, Attested)],
    findall(Result - Basis - Citations, officer_position_status(Profile, involvement, Result, Basis, Citations), Answers),
    Answers == [met - [outside_fact(officer_involved_properly_and_in_time, Attested)] - [cite(eu_reg_2016_679_art_38_1)]].
test(position_resources_attested_false_with_document_evidence_is_not_met) :-
    Attested = attested(false, attestation(host_system, recorded_moment, stated_reason, document(upload_identifier, digest_value))),
    Profile = [attribute(officer_supported_with_resources_and_access, Attested)],
    findall(Result - Basis - Citations, officer_position_status(Profile, resources_and_access, Result, Basis, Citations), Answers),
    Answers == [not_met - [outside_fact(officer_supported_with_resources_and_access, Attested)] - [cite(eu_reg_2016_679_art_38_2)]].
test(position_conflict_of_interests_absent_is_indeterminate) :-
    findall(Result - Basis - Citations, officer_position_status([], conflict_of_interests, Result, Basis, Citations), Answers),
    Answers == [indeterminate([officer_other_tasks_result_in_conflict_of_interests]) - [] - []].
test(position_conflict_of_interests_unsure_refers) :-
    Profile = [attribute(officer_other_tasks_result_in_conflict_of_interests, unsure)],
    findall(Result - Basis - Citations, officer_position_status(Profile, conflict_of_interests, Result, Basis, Citations), Answers),
    Answers == [needs_legal_review(open_textured(officer_other_tasks_result_in_conflict_of_interests, cite(eu_reg_2016_679_art_38_6)), [inputs_relied_on([officer_other_tasks_result_in_conflict_of_interests - unsure])]) - [] - []].
test(position_with_a_known_duty_has_a_solution) :-
    officer_position_status([], no_instructions_or_penalty, needs_legal_review(_, _), [], []).
test(result_constructors_build_terms) :-
    Terms = [missing_officer_task(informing_and_advising, cite(eu_reg_2016_679_art_39_1_a)), duplicate_key(persons_employed), not_governed_here([cite(eu_reg_2016_679_art_30_1), cite(eu_reg_2016_679_art_30_2)]), provenance(record_obligation, [cite(eu_reg_2016_679_art_30_5)]), outside_fact(is_public_authority_or_body, absent), attested(true, attestation(host_system, recorded_moment, stated_reason, none)), url(source_address, retrieved_moment), document(upload_identifier, digest_value)],
    length(Terms, 8),
    Terms = [missing_officer_task(TaskItem, _)|_],
    TaskItem == informing_and_advising.

test(at_249_the_record_is_not_required_verdict, fail) :-
    gdpr_records_and_officer_assess(small_controller_exempt_at_249, gdpr_records_and_officer_verdict(record_required, _)).
test(at_250_the_exemption_is_lost, fail) :-
    gdpr_records_and_officer_assess(controller_at_ceiling_250, gdpr_records_and_officer_verdict(record_not_required, _)).
test(no_trigger_small_processor_owes_no_record, fail) :-
    gdpr_records_and_officer_assess(small_processor_without_trigger, gdpr_records_and_officer_verdict(record_required, _)).
test(neither_role_is_never_record_not_required, fail) :-
    gdpr_records_and_officer_assess(neither_role_entity, gdpr_records_and_officer_verdict(record_not_required, _)).
test(unsure_occasional_is_not_resolvable, fail) :-
    gdpr_records_and_officer_profile_for(unsure_occasional_controller, Profile),
    gdpr_records_and_officer_decision_resolvable(Profile).
test(absent_headcount_is_not_resolvable, fail) :-
    gdpr_records_and_officer_profile_for(headcount_absent_controller, Profile),
    gdpr_records_and_officer_decision_resolvable(Profile).
test(court_in_judicial_capacity_designation_is_not_met, fail) :-
    checklist_statuses(court_in_judicial_capacity_controller, _, met, _).
test(member_state_law_not_requiring_is_not_met, fail) :-
    checklist_statuses(member_state_law_does_not_require_officer, _, met, _).
test(mandate_lacking_contact_point_is_not_met, fail) :-
    checklist_statuses(officer_mandate_lacks_contact_point, _, _, met).
test(duplicate_headcount_is_never_required, fail) :-
    gdpr_records_and_officer_profile_for(duplicate_headcount_malformed, Profile),
    gdpr_records_and_officer_status(Profile, record_required).
test(position_with_an_unknown_duty_has_no_solution, fail) :-
    officer_position_status([], publication_of_contact_details, _, _, _).

cp_test_names([every_subject_is_assessed_exactly_once, every_subject_status_is_in_the_vocabulary, every_subject_has_a_non_empty_checklist, at_249_the_record_is_not_required, at_250_the_controller_record_is_required, the_249_checklist_marks_the_record_unmet, the_250_checklist_marks_the_record_met, special_categories_owe_the_processor_record, no_trigger_leaves_the_small_processor_exempt, both_roles_owe_both_records, neither_role_is_unresolved, controller_role_is_required, neither_role_checklist_refers, unsure_occasional_is_unresolved, not_occasional_owes_the_record, not_occasional_is_resolvable, absent_headcount_is_unresolved, absent_headcount_is_named_in_the_checklist, exempt_controller_is_resolvable, public_authority_must_designate, court_in_judicial_capacity_needs_no_designation, public_authority_record_verdict, member_state_law_requires_designation, member_state_law_not_requiring_gives_no_designation, mandate_lacking_contact_point_is_unmet, complete_mandate_is_met, duplicate_headcount_is_unresolved, duplicate_headcount_checklist_is_malformed, single_headcount_is_required, decide_matches_assess_for_the_ceiling_case, record_obligation_owes_the_controller_record_at_250, record_obligation_is_exempt_at_249, record_obligation_refers_an_entity_with_neither_role, record_obligation_names_the_absent_headcount, record_obligation_refers_an_unsure_occasional_judgement, record_obligation_names_a_duplicate_key, record_missing_items_is_empty_when_exempt, record_missing_items_names_the_absent_content_keys, record_missing_items_lists_the_missing_purposes, record_missing_items_refers_an_entity_with_neither_role, designation_for_a_public_authority_cites_limb_a, designation_for_a_court_is_not_required, officer_missing_tasks_lists_the_contact_point, officer_missing_tasks_is_empty_for_a_complete_mandate, officer_missing_tasks_names_absent_flags, outside_facts_copy_the_attested_term_and_mark_absence, outside_facts_are_both_absent_for_a_bare_profile, position_absent_reporting_statement_refers, position_involvement_attested_true_with_url_evidence_is_met, position_resources_attested_false_with_document_evidence_is_not_met, position_conflict_of_interests_absent_is_indeterminate, position_conflict_of_interests_unsure_refers, position_with_a_known_duty_has_a_solution, result_constructors_build_terms]).
cp_test_fail_names([at_249_the_record_is_not_required_verdict, at_250_the_exemption_is_lost, no_trigger_small_processor_owes_no_record, neither_role_is_never_record_not_required, unsure_occasional_is_not_resolvable, absent_headcount_is_not_resolvable, court_in_judicial_capacity_designation_is_not_met, member_state_law_not_requiring_is_not_met, mandate_lacking_contact_point_is_not_met, duplicate_headcount_is_never_required, position_with_an_unknown_duty_has_no_solution]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
