% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_register_of_information_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_register_of_information_dora_register_of_information, [decide_dora_register_of_information/2, dora_register_of_information_status/2, dora_register_of_information_checklist/2, dora_register_of_information_decision_resolvable/1, dora_register_of_information_status_values/1]).
:- use_module(m__eu_dora_register_of_information_fixtures, [dora_register_of_information_subject/1, dora_register_of_information_profile_for/2, dora_register_of_information_assess/2]).
:- use_module(m__eu_dora_register_of_information_dora_register_of_information, [register_of_information_duties_required/3, register_of_information_duties_complete/3, register_of_information_duties_outstanding/3]).
:- use_module(m__eu_dora_register_of_information_kernel, [dora_register_of_information_input_problems/2]).
:- use_module(m__eu_dora_register_of_information_queries, [dora_register_of_information_profile_keys/1, dora_register_of_information_what_if/4, dora_register_of_information_eligibility/2, dora_register_of_information_compliance_check/3]).

expected_status(solo_entity_all_performed, complete).
expected_status(solo_entity_yearly_report_missed, incomplete).
expected_status(group_parent_all_performed, complete).
expected_status(group_parent_consolidated_consistency_missed, incomplete).
expected_status(critical_function_entity_all_performed, complete).
expected_status(critical_function_subcontractor_identifiers_missed, incomplete).
expected_status(false_trigger_with_unread_duty_key, complete).
expected_status(planned_arrangement_informed, complete).
expected_status(planned_arrangement_not_informed, incomplete).
expected_status(branches_and_intra_group_all_performed, complete).
expected_status(branches_template_unanswered, indeterminate).
expected_status(triggers_unanswered, indeterminate).
expected_status(data_quality_unsure, needs_legal_review).
expected_status(data_quality_unsure_with_missed_report, incomplete).
expected_status(microenterprise_key_given, input_problems).
expected_status(unsure_trigger, input_problems).
expected_status(duplicate_judgement, input_problems).
expected_status(not_an_attribute_list, input_problems).

fixed_citation_set([cite(eu_reg_2022_2554_art_28_3), cite(eu_reg_2024_2956_art_2), cite(eu_reg_2024_2956_art_3_1), cite(eu_reg_2024_2956_art_3_2), cite(eu_reg_2024_2956_art_3_3), cite(eu_reg_2024_2956_art_3_4), cite(eu_reg_2024_2956_art_3_5), cite(eu_reg_2024_2956_art_3_6), cite(eu_reg_2024_2956_art_4_1), cite(eu_reg_2024_2956_art_4_2), cite(eu_reg_2024_2956_art_4_3), cite(eu_reg_2024_2956_art_5_1), cite(eu_reg_2024_2956_art_6_1), cite(eu_reg_2024_2956_art_6_2)]).

same_set(Left, Right) :-
    clausal_msort(Left, Sorted),
    clausal_msort(Right, Sorted).

subject_profile(Subject, Profile) :-
    dora_register_of_information_profile_for(Subject, Profile).

answers_once(Subject) :-
    subject_profile(Subject, Profile),
    findall(Result - Citations, register_of_information_duties_required(Profile, Result, Citations), Required),
    length(Required, 1),
    findall(Result - Citations, register_of_information_duties_complete(Profile, Result, Citations), Complete),
    length(Complete, 1),
    findall(Result - Citations, register_of_information_duties_outstanding(Profile, Result, Citations), Outstanding),
    length(Outstanding, 1).

test(every_subject_has_an_expected_status) :-
    findall(Subject, dora_register_of_information_subject(Subject), Subjects),
    findall(Subject, expected_status(Subject, _), Expected),
    clausal_msort(Subjects, Sorted),
    clausal_msort(Expected, Sorted).
test(each_subject_resolves_to_its_expected_status) :-
    findall(Subject, expected_status(Subject, _), All),
    findall(Subject, (expected_status(Subject, Status), subject_profile(Subject, Profile), dora_register_of_information_status(Profile, Status)), Matched),
    Matched == All.
test(every_query_answers_once_per_subject) :-
    findall(Subject, dora_register_of_information_subject(Subject), Subjects),
    findall(Subject, (member(Subject, Subjects), answers_once(Subject)), Once),
    Once == Subjects.
test(every_status_is_in_the_vocabulary) :-
    dora_register_of_information_status_values(Values),
    findall(Subject, dora_register_of_information_subject(Subject), Subjects),
    findall(Subject, (member(Subject, Subjects), dora_register_of_information_assess(Subject, dora_register_of_information_verdict(Result, _)), subject_profile(Subject, Profile), dora_register_of_information_status(Profile, Status), member(Status, Values), dif(Result, indeterminate)), Resolved),
    Resolved == Subjects.
test(well_formed_subjects_have_a_cited_checklist_of_thirty_four_items) :-
    findall(Subject, (dora_register_of_information_subject(Subject), subject_profile(Subject, Profile), dora_register_of_information_input_problems(Profile, [])), WellFormed),
    length(WellFormed, 14),
    findall(Subject, (member(Subject, WellFormed), subject_profile(Subject, Profile), dora_register_of_information_decision_resolvable(Profile), dora_register_of_information_checklist(Profile, Items), length(Items, 34), findall(Duty, member(item(Duty, _, [cite(_)|_]), Items), Cited), length(Cited, 34)), Checked),
    Checked == WellFormed.
test(solo_entity_is_complete_with_the_fixed_citations) :-
    dora_register_of_information_assess(solo_entity_all_performed, dora_register_of_information_verdict(Result, Citations)),
    Result == complete,
    fixed_citation_set(Fixed),
    same_set(Citations, Fixed).
test(yearly_report_missed_is_incomplete_with_the_fixed_citations) :-
    dora_register_of_information_assess(solo_entity_yearly_report_missed, dora_register_of_information_verdict(Result, Citations)),
    Result == incomplete,
    fixed_citation_set(Fixed),
    same_set(Citations, Fixed).
test(group_parent_complete_and_its_near_miss_incomplete) :-
    subject_profile(group_parent_all_performed, Complete),
    register_of_information_duties_complete(Complete, complete, _),
    subject_profile(group_parent_consolidated_consistency_missed, Missed),
    register_of_information_duties_complete(Missed, incomplete, _).
test(critical_function_complete_and_its_near_miss_incomplete) :-
    subject_profile(critical_function_entity_all_performed, Complete),
    register_of_information_duties_complete(Complete, complete, _),
    subject_profile(critical_function_subcontractor_identifiers_missed, Missed),
    register_of_information_duties_complete(Missed, incomplete, _).
test(a_false_key_under_a_false_trigger_is_never_read) :-
    subject_profile(false_trigger_with_unread_duty_key, Profile),
    register_of_information_duties_complete(Profile, complete, _),
    register_of_information_duties_outstanding(Profile, none_outstanding, _).
test(planned_arrangement_informed_and_not_informed) :-
    subject_profile(planned_arrangement_informed, Informed),
    register_of_information_duties_complete(Informed, complete, _),
    subject_profile(planned_arrangement_not_informed, NotInformed),
    register_of_information_duties_outstanding(NotInformed, Result, Citations),
    Result == outstanding([information_on_planned_arrangement]),
    Citations == [cite(eu_reg_2022_2554_art_28_3)].
test(branches_template_unanswered_names_its_key) :-
    subject_profile(branches_template_unanswered, Profile),
    register_of_information_duties_complete(Profile, Result, Citations),
    Result == indeterminate([register_includes_identification_of_branches_outside_home_country]),
    Citations == [].
test(branches_template_answered_is_complete) :-
    subject_profile(branches_and_intra_group_all_performed, Profile),
    register_of_information_duties_complete(Profile, complete, _).
test(triggers_unanswered_names_the_first_trigger_in_every_query) :-
    subject_profile(triggers_unanswered, Profile),
    register_of_information_duties_required(Profile, Required, []),
    Required == indeterminate([financial_entity_responsible_for_sub_consolidated_register]),
    register_of_information_duties_complete(Profile, Complete, []),
    Complete == indeterminate([financial_entity_responsible_for_sub_consolidated_register]),
    register_of_information_duties_outstanding(Profile, Outstanding, []),
    Outstanding == indeterminate([financial_entity_responsible_for_sub_consolidated_register]).
test(data_quality_unsure_is_referred_with_its_pairs) :-
    subject_profile(data_quality_unsure, Profile),
    register_of_information_duties_complete(Profile, Result, Citations),
    Citations == [],
    Result = needs_legal_review(Reason, [inputs_relied_on(Pairs)]),
    Reason == open_textured(template_information_meets_data_quality_principles, cite(eu_reg_2024_2956_art_3_3)),
    length(Pairs, 30),
    Pairs = [FirstPair|_],
    FirstPair == financial_entity_responsible_for_sub_consolidated_register - false,
    member(template_information_meets_data_quality_principles - unsure, Pairs).
test(a_false_duty_decides_before_the_unsure_one_is_referred) :-
    subject_profile(data_quality_unsure_with_missed_report, Profile),
    register_of_information_duties_complete(Profile, Complete, _),
    Complete == incomplete,
    register_of_information_duties_outstanding(Profile, Outstanding, []),
    Outstanding = needs_legal_review(open_textured(Key, _), _),
    Key == template_information_meets_data_quality_principles.
test(a_provenance_item_follows_the_scored_inputs_relied_on) :-
    subject_profile(data_quality_unsure, Profile),
    register_of_information_duties_complete(Profile, needs_legal_review(Reason, Context), []),
    Reason = open_textured(Key, Citation),
    Context = [inputs_relied_on(Pairs)|Optional],
    Optional == [],
    WithProvenance = [inputs_relied_on(Pairs), provenance(complete_after_unsure, [Citation])],
    WithProvenance = [Scored, provenance(Clause, ProvenanceCitations)],
    Scored == inputs_relied_on(Pairs),
    Clause == complete_after_unsure,
    ProvenanceCitations == [cite(eu_reg_2024_2956_art_3_3)],
    Key == template_information_meets_data_quality_principles.
test(the_outstanding_referral_carries_its_inputs_relied_on) :-
    subject_profile(data_quality_unsure, Profile),
    register_of_information_duties_outstanding(Profile, needs_legal_review(_, Context), []),
    Context = [inputs_relied_on(Pairs)],
    length(Pairs, 30).
test(a_key_of_another_order_is_unknown) :-
    subject_profile(microenterprise_key_given, Profile),
    register_of_information_duties_complete(Profile, Result, Citations),
    Result == input_problems([unknown_key(financial_entity_is_microenterprise)]),
    Citations == [].
test(unsure_on_a_trigger_is_wrong_type) :-
    subject_profile(unsure_trigger, Profile),
    register_of_information_duties_required(Profile, Result, []),
    Result == input_problems([wrong_type(competent_authority_requested_register)]).
test(a_repeated_judgement_is_a_duplicate_only) :-
    subject_profile(duplicate_judgement, Profile),
    dora_register_of_information_input_problems(Profile, Problems),
    Problems == [duplicate_key(template_information_meets_data_quality_principles)],
    register_of_information_duties_outstanding(Profile, input_problems(Problems), []).
test(a_term_that_is_not_an_attribute_list) :-
    subject_profile(not_an_attribute_list, Profile),
    register_of_information_duties_complete(Profile, Result, []),
    Result == input_problems([wrong_type(profile)]).
test(input_problems_give_an_empty_checklist) :-
    subject_profile(not_an_attribute_list, Profile),
    dora_register_of_information_checklist(Profile, Items),
    Items == [].
test(solo_entity_requires_the_twenty_two_always_duties) :-
    subject_profile(solo_entity_all_performed, Profile),
    register_of_information_duties_required(Profile, required(Duties), Citations),
    length(Duties, 22),
    Duties = [FirstDuty|_],
    FirstDuty == register_at_entity_level,
    length(Citations, 11),
    member(cite(eu_reg_2024_2956_art_5_1), Citations).
test(group_parent_requires_the_group_level_duties) :-
    subject_profile(group_parent_all_performed, Profile),
    register_of_information_duties_required(Profile, required(Duties), Citations),
    length(Duties, 26),
    member(register_at_consolidated_level, Duties),
    member(consistency_with_sub_consolidated_level, Duties),
    length(Citations, 13),
    member(cite(eu_reg_2024_2956_art_6_2), Citations).
test(critical_function_entity_requires_its_three_duties) :-
    subject_profile(critical_function_entity_all_performed, Profile),
    register_of_information_duties_required(Profile, required(Duties), Citations),
    length(Duties, 25),
    member(identifiers_of_subcontractors, Duties),
    member(assessment_of_ict_services_supporting_critical_or_important_functions, Duties),
    length(Citations, 12),
    member(cite(eu_reg_2024_2956_art_3_6), Citations).
test(branches_and_intra_group_duties_in_duty_order) :-
    subject_profile(branches_and_intra_group_all_performed, Profile),
    register_of_information_duties_required(Profile, required(Duties), _),
    length(Duties, 24),
    append(_, [identification_of_branches_outside_home_country|After], Duties),
    member(links_between_intra_group_and_other_arrangements, After).
test(solo_entity_has_none_outstanding_with_the_fixed_citations) :-
    subject_profile(solo_entity_all_performed, Profile),
    register_of_information_duties_outstanding(Profile, Result, Citations),
    Result == none_outstanding,
    fixed_citation_set(Fixed),
    same_set(Citations, Fixed).
test(yearly_report_missed_is_outstanding) :-
    subject_profile(solo_entity_yearly_report_missed, Profile),
    register_of_information_duties_outstanding(Profile, Result, Citations),
    Result == outstanding([yearly_report_to_competent_authorities]),
    Citations == [cite(eu_reg_2022_2554_art_28_3)].
test(subcontractor_identifiers_missed_is_outstanding_at_point_level) :-
    subject_profile(critical_function_subcontractor_identifiers_missed, Profile),
    register_of_information_duties_outstanding(Profile, Result, Citations),
    Result == outstanding([identifiers_of_subcontractors]),
    Citations == [cite(eu_reg_2024_2956_art_3_6)].
test(group_consistency_missed_is_outstanding) :-
    subject_profile(group_parent_consolidated_consistency_missed, Profile),
    register_of_information_duties_outstanding(Profile, Result, Citations),
    Result == outstanding([consistency_with_consolidated_level]),
    Citations == [cite(eu_reg_2024_2956_art_3_3)].
test(what_if_a_missed_report_is_made) :-
    subject_profile(solo_entity_yearly_report_missed, Profile),
    dora_register_of_information_what_if(Profile, reported_to_competent_authorities_at_least_yearly, true, Status),
    Status == complete.
test(what_if_a_performed_duty_is_missed) :-
    subject_profile(solo_entity_all_performed, Profile),
    findall(Status, dora_register_of_information_what_if(Profile, template_information_meets_data_quality_principles, false, Status), Statuses),
    Statuses == [incomplete].
test(what_if_replaces_every_entry_of_a_repeated_key) :-
    subject_profile(duplicate_judgement, Profile),
    dora_register_of_information_what_if(Profile, template_information_meets_data_quality_principles, true, Status),
    Status == complete.
test(profile_keys_are_the_forty_two_contract_keys) :-
    dora_register_of_information_profile_keys(Keys),
    length(Keys, 42).
test(eligibility_of_the_solo_entity_carries_a_cited_checklist) :-
    subject_profile(solo_entity_all_performed, Profile),
    findall(Assessment, dora_register_of_information_eligibility(Profile, Assessment), Assessments),
    Assessments = [assessment(_, Decision, Items)],
    Decision == complete,
    member(item(register_at_entity_level, met, [cite(eu_reg_2022_2554_art_28_3), cite(eu_reg_2024_2956_art_3_1)]), Items),
    member(item(identifiers_of_subcontractors, inapplicable, [cite(eu_reg_2024_2956_art_3_6)]), Items).
test(eligibility_of_the_near_miss_is_incomplete_with_an_unmet_item) :-
    subject_profile(solo_entity_yearly_report_missed, Profile),
    dora_register_of_information_eligibility(Profile, assessment(_, Decision, Items)),
    Decision == incomplete,
    member(item(yearly_report_to_competent_authorities, unmet(_), [cite(eu_reg_2022_2554_art_28_3)]), Items).
test(eligibility_refuses_a_profile_with_input_problems) :-
    subject_profile(microenterprise_key_given, Profile),
    dora_register_of_information_eligibility(Profile, Assessment),
    Assessment == input_problems([unknown_key(financial_entity_is_microenterprise)]).
test(leaving_an_always_duty_unperformed_is_forbidden) :-
    subject_profile(solo_entity_all_performed, Profile),
    findall(Verdict, dora_register_of_information_compliance_check(Profile, leave_unperformed(yearly_report_to_competent_authorities), Verdict), Verdicts),
    Verdicts == [forbidden].
test(leaving_a_defeated_duty_unperformed_is_permitted) :-
    subject_profile(solo_entity_all_performed, Profile),
    dora_register_of_information_compliance_check(Profile, leave_unperformed(identifiers_of_subcontractors), Verdict),
    Verdict == permitted.
test(leaving_the_duty_once_its_trigger_holds_is_forbidden) :-
    subject_profile(critical_function_entity_all_performed, Profile),
    dora_register_of_information_compliance_check(Profile, leave_unperformed(identifiers_of_subcontractors), Verdict),
    Verdict == forbidden.
test(a_duty_open_on_an_absent_trigger_is_indeterminate) :-
    subject_profile(triggers_unanswered, Profile),
    dora_register_of_information_compliance_check(Profile, leave_unperformed(identifiers_of_subcontractors), Verdict),
    Verdict == indeterminate([entity_uses_ict_services_supporting_critical_or_important_functions]),
    dora_register_of_information_compliance_check(Profile, leave_unperformed(register_at_entity_level), Always),
    Always == forbidden.
test(an_unknown_duty_atom_is_an_input_problem) :-
    subject_profile(solo_entity_all_performed, Profile),
    dora_register_of_information_compliance_check(Profile, leave_unperformed(no_such_duty), Verdict),
    Verdict == input_problems([unknown_key(no_such_duty)]).
test(compliance_refuses_a_profile_with_input_problems) :-
    subject_profile(unsure_trigger, Profile),
    dora_register_of_information_compliance_check(Profile, leave_unperformed(register_at_entity_level), Verdict),
    Verdict == input_problems([wrong_type(competent_authority_requested_register)]).

test(solo_entity_is_not_incomplete, fail) :-
    dora_register_of_information_assess(solo_entity_all_performed, dora_register_of_information_verdict(incomplete, _)).
test(yearly_report_missed_is_not_complete, fail) :-
    dora_register_of_information_assess(solo_entity_yearly_report_missed, dora_register_of_information_verdict(complete, _)).
test(group_parent_near_miss_is_not_complete, fail) :-
    subject_profile(group_parent_consolidated_consistency_missed, Missed),
    register_of_information_duties_complete(Missed, complete, _).
test(a_false_key_under_a_false_trigger_is_not_incomplete, fail) :-
    subject_profile(false_trigger_with_unread_duty_key, Profile),
    register_of_information_duties_complete(Profile, incomplete, _).
test(the_missed_report_with_unsure_is_not_referred_by_complete, fail) :-
    subject_profile(data_quality_unsure_with_missed_report, Profile),
    register_of_information_duties_complete(Profile, needs_legal_review(_, _), _).
test(the_outstanding_referral_carries_no_provenance_item, fail) :-
    subject_profile(data_quality_unsure, Profile),
    register_of_information_duties_outstanding(Profile, needs_legal_review(_, Context), []),
    member(provenance(_, _), Context).
test(solo_entity_does_not_cite_the_group_paragraphs, fail) :-
    subject_profile(solo_entity_all_performed, Profile),
    register_of_information_duties_required(Profile, required(_), Citations),
    member(cite(eu_reg_2024_2956_art_6_1), Citations).

cp_test_names([every_subject_has_an_expected_status, each_subject_resolves_to_its_expected_status, every_query_answers_once_per_subject, every_status_is_in_the_vocabulary, well_formed_subjects_have_a_cited_checklist_of_thirty_four_items, solo_entity_is_complete_with_the_fixed_citations, yearly_report_missed_is_incomplete_with_the_fixed_citations, group_parent_complete_and_its_near_miss_incomplete, critical_function_complete_and_its_near_miss_incomplete, a_false_key_under_a_false_trigger_is_never_read, planned_arrangement_informed_and_not_informed, branches_template_unanswered_names_its_key, branches_template_answered_is_complete, triggers_unanswered_names_the_first_trigger_in_every_query, data_quality_unsure_is_referred_with_its_pairs, a_false_duty_decides_before_the_unsure_one_is_referred, a_provenance_item_follows_the_scored_inputs_relied_on, the_outstanding_referral_carries_its_inputs_relied_on, a_key_of_another_order_is_unknown, unsure_on_a_trigger_is_wrong_type, a_repeated_judgement_is_a_duplicate_only, a_term_that_is_not_an_attribute_list, input_problems_give_an_empty_checklist, solo_entity_requires_the_twenty_two_always_duties, group_parent_requires_the_group_level_duties, critical_function_entity_requires_its_three_duties, branches_and_intra_group_duties_in_duty_order, solo_entity_has_none_outstanding_with_the_fixed_citations, yearly_report_missed_is_outstanding, subcontractor_identifiers_missed_is_outstanding_at_point_level, group_consistency_missed_is_outstanding, what_if_a_missed_report_is_made, what_if_a_performed_duty_is_missed, what_if_replaces_every_entry_of_a_repeated_key, profile_keys_are_the_forty_two_contract_keys, eligibility_of_the_solo_entity_carries_a_cited_checklist, eligibility_of_the_near_miss_is_incomplete_with_an_unmet_item, eligibility_refuses_a_profile_with_input_problems, leaving_an_always_duty_unperformed_is_forbidden, leaving_a_defeated_duty_unperformed_is_permitted, leaving_the_duty_once_its_trigger_holds_is_forbidden, a_duty_open_on_an_absent_trigger_is_indeterminate, an_unknown_duty_atom_is_an_input_problem, compliance_refuses_a_profile_with_input_problems]).
cp_test_fail_names([solo_entity_is_not_incomplete, yearly_report_missed_is_not_complete, group_parent_near_miss_is_not_complete, a_false_key_under_a_false_trigger_is_not_incomplete, the_missed_report_with_unsure_is_not_referred_by_complete, the_outstanding_referral_carries_no_provenance_item, solo_entity_does_not_cite_the_group_paragraphs]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
