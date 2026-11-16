% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_nis2_supervision_fines_nis2_supervision_fines, [decide_nis2_supervision_fines/2, nis2_supervision_fines_status/2, nis2_supervision_fines_checklist/2, nis2_supervision_fines_decision_resolvable/1, nis2_supervision_fines_status_values/1, fine_ceiling_floor/3, minimum_powers/2, escalation_powers_exercisable/3, fine_barred_by_gdpr_fine/3, data_protection_authority_information/2, provenance/2]).
:- use_module(m__eu_nis2_supervision_fines_fixtures, [nis2_supervision_fines_subject/1, nis2_supervision_fines_profile_for/2, nis2_supervision_fines_assess/2]).
:- use_module(m__eu_nis2_supervision_fines_kernel, [nis2_supervision_fines_input_problems/2]).

all_subjects(Subjects) :-
    findall(Subject, nis2_supervision_fines_subject(Subject), Subjects).

assessed_once(Subject) :-
    findall(Verdict, nis2_supervision_fines_assess(Subject, Verdict), [_]).

checklist_cited(Subject) :-
    nis2_supervision_fines_profile_for(Subject, Profile),
    nis2_supervision_fines_checklist(Profile, [Item|Items]),
    maplist(item_cited, [Item|Items]).

item_cited(item(_, _, cite(Key))) :-
    atom(Key).

resolvable(Subject) :-
    nis2_supervision_fines_profile_for(Subject, Profile),
    nis2_supervision_fines_decision_resolvable(Profile).

queries_answer_once(Subject) :-
    nis2_supervision_fines_profile_for(Subject, Profile),
    findall(Ceiling - CeilingCitations, fine_ceiling_floor(Profile, Ceiling, CeilingCitations), [_]),
    findall(Powers, minimum_powers(Profile, Powers), [_]),
    findall(Escalation - EscalationCitations, escalation_powers_exercisable(Profile, Escalation, EscalationCitations), [_]),
    findall(Bar - BarCitations, fine_barred_by_gdpr_fine(Profile, Bar, BarCitations), [_]),
    findall(Duty, data_protection_authority_information(Profile, Duty), [_]),
    findall(Problems, nis2_supervision_fines_input_problems(Profile, Problems), [_]).

subject_powers(Subject, Powers) :-
    nis2_supervision_fines_profile_for(Subject, Profile),
    minimum_powers(Profile, Powers).

subject_ceiling(Subject, Ceiling, Citations) :-
    nis2_supervision_fines_profile_for(Subject, Profile),
    fine_ceiling_floor(Profile, Ceiling, Citations).

subject_bar(Subject, Result, Citations) :-
    nis2_supervision_fines_profile_for(Subject, Profile),
    fine_barred_by_gdpr_fine(Profile, Result, Citations).

subject_duty(Subject, Duty) :-
    nis2_supervision_fines_profile_for(Subject, Profile),
    data_protection_authority_information(Profile, Duty).

test(every_subject_is_assessed_exactly_once) :-
    all_subjects(Subjects),
    Subjects = [_|_],
    maplist(assessed_once, Subjects).
test(every_subject_has_a_non_empty_cited_checklist) :-
    all_subjects(Subjects),
    maplist(checklist_cited, Subjects).
test(every_subject_is_resolvable) :-
    all_subjects(Subjects),
    maplist(resolvable, Subjects).
test(every_query_answers_exactly_once_on_every_subject) :-
    all_subjects(Subjects),
    maplist(queries_answer_once, Subjects).
test(final_statuses_are_in_the_status_vocabulary) :-
    nis2_supervision_fines_status_values(StatusValues),
    nis2_supervision_fines_assess(escalation_exercisable, nis2_supervision_fines_verdict(Eligible, _)),
    member(Eligible, StatusValues),
    nis2_supervision_fines_assess(important_fine_at_tie, nis2_supervision_fines_verdict(Ineligible, _)),
    member(Ineligible, StatusValues).
test(provenance_recognises_a_clause_with_a_citation_list) :-
    provenance(escalation_measures_ineffective, [cite(eu_dir_2022_2555_art_32_5)]).
test(provenance_recognises_an_empty_citation_list) :-
    provenance(gdpr_bar_same_conduct, []).
test(escalation_exercisable_is_eligible) :-
    nis2_supervision_fines_assess(escalation_exercisable, nis2_supervision_fines_verdict(eligible, [cite(eu_dir_2022_2555_art_32_5)])).
test(action_taken_within_deadline_is_ineligible) :-
    nis2_supervision_fines_assess(escalation_action_taken_within_deadline, nis2_supervision_fines_verdict(ineligible, [cite(eu_dir_2022_2555_art_32_5)])).
test(public_administration_entity_is_ineligible) :-
    nis2_supervision_fines_profile_for(escalation_public_administration_entity, Profile),
    nis2_supervision_fines_status(Profile, ineligible),
    escalation_powers_exercisable(Profile, not_exercisable(public_administration_entity), [cite(eu_dir_2022_2555_art_32_5)]).
test(measures_not_ineffective_is_ineligible) :-
    nis2_supervision_fines_profile_for(escalation_measures_not_ineffective, Profile),
    nis2_supervision_fines_status(Profile, ineligible),
    escalation_powers_exercisable(Profile, not_exercisable(measures_not_ineffective), [cite(eu_dir_2022_2555_art_32_5)]).
test(no_deadline_set_is_ineligible) :-
    nis2_supervision_fines_profile_for(escalation_no_deadline_set, Profile),
    nis2_supervision_fines_status(Profile, ineligible),
    escalation_powers_exercisable(Profile, not_exercisable(no_deadline_set), [cite(eu_dir_2022_2555_art_32_5)]).
test(unsure_measures_need_legal_review) :-
    nis2_supervision_fines_assess(escalation_measures_unsure, nis2_supervision_fines_verdict(needs_legal_review(open_textured(earlier_measures_ineffective, cite(eu_dir_2022_2555_art_32_5)), [inputs_relied_on([earlier_measures_ineffective - unsure])]), [])).
test(missing_deadline_keys_are_named_in_order) :-
    nis2_supervision_fines_assess(escalation_deadline_keys_missing, nis2_supervision_fines_verdict(indeterminate([deadline_set_for_necessary_action, required_action_taken_within_deadline]), [])).
test(absent_entity_class_is_indeterminate) :-
    nis2_supervision_fines_assess(entity_class_absent, nis2_supervision_fines_verdict(indeterminate([entity_class]), [])).
test(important_entity_is_ineligible) :-
    nis2_supervision_fines_assess(important_fine_at_tie, nis2_supervision_fines_verdict(ineligible, [cite(eu_dir_2022_2555_art_32_5)])).
test(essential_fine_subject_needs_the_escalation_keys) :-
    nis2_supervision_fines_assess(essential_fine_at_tie, nis2_supervision_fines_verdict(indeterminate([entity_is_public_administration, earlier_measures_ineffective, deadline_set_for_necessary_action, required_action_taken_within_deadline]), [])).
test(duplicate_key_is_an_input_problem) :-
    nis2_supervision_fines_assess(duplicate_entity_class, nis2_supervision_fines_verdict(input_problems([duplicate_key(entity_class)]), [])).
test(unknown_key_is_an_input_problem) :-
    nis2_supervision_fines_assess(unknown_key_present, nis2_supervision_fines_verdict(input_problems([unknown_key(sector)]), [])).
test(eligible_checklist_has_every_condition_met_and_cited) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_checklist(Profile, Items),
    length(Items, 5),
    member(item(essential_entity, met, cite(eu_dir_2022_2555_art_32_5)), Items),
    member(item(action_not_taken_within_deadline, met, cite(eu_dir_2022_2555_art_32_5)), Items).
test(near_miss_checklist_names_the_failing_condition) :-
    nis2_supervision_fines_profile_for(escalation_action_taken_within_deadline, Profile),
    nis2_supervision_fines_checklist(Profile, Items),
    member(item(action_not_taken_within_deadline, unmet(action_taken_within_deadline), cite(eu_dir_2022_2555_art_32_5)), Items).
test(missing_key_checklist_marks_it_unknown) :-
    nis2_supervision_fines_profile_for(escalation_deadline_keys_missing, Profile),
    nis2_supervision_fines_checklist(Profile, Items),
    member(item(deadline_set, unknown([deadline_set_for_necessary_action]), cite(eu_dir_2022_2555_art_32_5)), Items).
test(essential_below_tie_rounds_up_to_the_fixed_floor) :-
    subject_ceiling(essential_fine_below_tie, minimum_national_maximum(10000000, fixed_amount), [cite(eu_dir_2022_2555_art_34_4)]).
test(essential_at_tie_takes_the_fixed_basis) :-
    subject_ceiling(essential_fine_at_tie, minimum_national_maximum(10000000, fixed_amount), [cite(eu_dir_2022_2555_art_34_4)]).
test(essential_above_tie_takes_the_turnover_basis_rounded_up) :-
    subject_ceiling(essential_fine_above_tie, minimum_national_maximum(10000001, turnover_percentage), [cite(eu_dir_2022_2555_art_34_4)]).
test(important_at_tie_takes_the_fixed_basis) :-
    subject_ceiling(important_fine_at_tie, minimum_national_maximum(7000000, fixed_amount), [cite(eu_dir_2022_2555_art_34_5)]).
test(important_above_tie_takes_the_turnover_basis_rounded_up) :-
    subject_ceiling(important_fine_above_tie, minimum_national_maximum(7000001, turnover_percentage), [cite(eu_dir_2022_2555_art_34_5)]).
test(other_infringement_has_no_union_minimum) :-
    subject_ceiling(other_infringement, no_union_minimum, Citations),
    msort(Citations, [cite(eu_dir_2022_2555_art_34_4), cite(eu_dir_2022_2555_art_34_5)]).
test(absent_provision_ceiling_is_indeterminate) :-
    subject_ceiling(escalation_exercisable, indeterminate([infringed_provision]), []).
test(input_problems_ceiling_has_no_citations) :-
    subject_ceiling(duplicate_entity_class, input_problems([duplicate_key(entity_class)]), []).
test(important_entity_has_fourteen_powers) :-
    subject_powers(important_fine_at_tie, Powers),
    length(Powers, 14),
    Powers = [power(supervision, on_site_inspections_and_off_site_ex_post_supervision, cite(eu_dir_2022_2555_art_33_2_a))|_],
    last(Powers, power(enforcement, administrative_fine, cite(eu_dir_2022_2555_art_33_4_h))).
test(essential_not_public_administration_has_the_escalation_powers) :-
    subject_powers(escalation_exercisable, Powers),
    length(Powers, 18),
    member(power(escalation, suspend_certification_or_authorisation, cite(eu_dir_2022_2555_art_32_5_a)), Powers),
    last(Powers, power(escalation, request_temporary_management_ban, cite(eu_dir_2022_2555_art_32_5_b))).
test(public_administration_entity_has_sixteen_powers) :-
    subject_powers(escalation_public_administration_entity, Powers),
    length(Powers, 16),
    last(Powers, power(enforcement, administrative_fine, cite(eu_dir_2022_2555_art_32_4_i))).
test(essential_powers_need_the_public_administration_key) :-
    subject_powers(essential_fine_at_tie, indeterminate([entity_is_public_administration])).
test(powers_need_the_entity_class) :-
    subject_powers(entity_class_absent, indeterminate([entity_class])).
test(powers_report_input_problems) :-
    subject_powers(unknown_key_present, input_problems([unknown_key(sector)])).
test(gdpr_fine_for_same_conduct_bars_the_fine) :-
    subject_bar(gdpr_fine_barred, fine_barred, [cite(eu_dir_2022_2555_art_35_2)]).
test(not_same_conduct_does_not_bar_the_fine) :-
    subject_bar(gdpr_not_same_conduct, fine_not_barred, [cite(eu_dir_2022_2555_art_35_2)]).
test(unsure_same_conduct_needs_legal_review) :-
    subject_bar(gdpr_same_conduct_unsure, needs_legal_review(open_textured(gdpr_fine_for_same_conduct, cite(eu_dir_2022_2555_art_35_2)), [inputs_relied_on([infringement_may_entail_notifiable_personal_data_breach - true, gdpr_fine_for_same_conduct - unsure])]), []).
test(other_infringement_is_not_barred) :-
    subject_bar(other_infringement, fine_not_barred, [cite(eu_dir_2022_2555_art_35_2)]).
test(gdpr_bar_does_not_read_the_awareness_key) :-
    subject_bar(information_not_aware, indeterminate([gdpr_fine_imposed_under_art_58_2_i, gdpr_fine_for_same_conduct]), []).
test(other_member_state_adds_the_own_supervisory_authority) :-
    subject_duty(information_other_member_state, [inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1)), inform_supervisory_authority_in_own_member_state(cite(eu_dir_2022_2555_art_35_3))]).
test(own_member_state_informs_the_gdpr_authorities_only) :-
    subject_duty(information_own_member_state, [inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1))]).
test(not_aware_has_no_duty) :-
    subject_duty(information_not_aware, []).
test(other_infringement_has_no_duty) :-
    subject_duty(other_infringement, []).
test(duty_names_the_absent_awareness_key) :-
    subject_duty(gdpr_fine_barred, indeterminate([authority_became_aware_in_supervision_or_enforcement])).
test(duty_needs_the_provision) :-
    subject_duty(entity_class_absent, indeterminate([infringed_provision])).
test(well_formed_fixture_has_no_input_problem) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    nis2_supervision_fines_input_problems(Profile, []).
test(a_non_list_profile_is_wrong_type) :-
    nis2_supervision_fines_input_problems(essential, [wrong_type(profile)]).
test(a_non_list_profile_status_is_input_problems) :-
    decide_nis2_supervision_fines(essential, nis2_supervision_fines_verdict(input_problems([wrong_type(profile)]), [])).

test(provenance_rejects_a_non_list_citation, fail) :-
    provenance(gdpr_bar_same_conduct, cite(eu_dir_2022_2555_art_35_2)).
test(escalation_exercisable_is_not_ineligible, fail) :-
    nis2_supervision_fines_assess(escalation_exercisable, nis2_supervision_fines_verdict(ineligible, _)).
test(action_taken_within_deadline_is_not_eligible, fail) :-
    nis2_supervision_fines_assess(escalation_action_taken_within_deadline, nis2_supervision_fines_verdict(eligible, _)).
test(public_administration_entity_is_not_eligible, fail) :-
    nis2_supervision_fines_profile_for(escalation_public_administration_entity, Profile),
    nis2_supervision_fines_status(Profile, eligible).
test(unsure_measures_are_not_eligible, fail) :-
    nis2_supervision_fines_assess(escalation_measures_unsure, nis2_supervision_fines_verdict(eligible, _)).
test(missing_deadline_keys_are_not_eligible, fail) :-
    nis2_supervision_fines_assess(escalation_deadline_keys_missing, nis2_supervision_fines_verdict(eligible, _)).
test(important_entity_is_not_eligible, fail) :-
    nis2_supervision_fines_assess(important_fine_at_tie, nis2_supervision_fines_verdict(eligible, _)).
test(unknown_key_profile_is_not_ineligible, fail) :-
    nis2_supervision_fines_assess(unknown_key_present, nis2_supervision_fines_verdict(ineligible, _)).
test(essential_at_tie_is_not_turnover_percentage, fail) :-
    subject_ceiling(essential_fine_at_tie, minimum_national_maximum(_, turnover_percentage), _).
test(important_above_tie_is_not_fixed_amount, fail) :-
    subject_ceiling(important_fine_above_tie, minimum_national_maximum(_, fixed_amount), _).
test(other_infringement_has_no_minimum_national_maximum, fail) :-
    subject_ceiling(other_infringement, minimum_national_maximum(_, _), _).
test(important_entity_has_no_monitoring_officer, fail) :-
    subject_powers(important_fine_at_tie, Powers),
    member(power(_, monitoring_officer, _), Powers).
test(public_administration_entity_has_no_escalation_power, fail) :-
    subject_powers(escalation_public_administration_entity, Powers),
    member(power(escalation, _, _), Powers).
test(gdpr_fine_barred_is_not_fine_not_barred, fail) :-
    subject_bar(gdpr_fine_barred, fine_not_barred, _).
test(not_same_conduct_is_not_barred, fail) :-
    subject_bar(gdpr_not_same_conduct, fine_barred, _).
test(own_member_state_has_no_own_member_state_duty, fail) :-
    subject_duty(information_own_member_state, Duty),
    member(inform_supervisory_authority_in_own_member_state(_), Duty).

cp_test_names([every_subject_is_assessed_exactly_once, every_subject_has_a_non_empty_cited_checklist, every_subject_is_resolvable, every_query_answers_exactly_once_on_every_subject, final_statuses_are_in_the_status_vocabulary, provenance_recognises_a_clause_with_a_citation_list, provenance_recognises_an_empty_citation_list, escalation_exercisable_is_eligible, action_taken_within_deadline_is_ineligible, public_administration_entity_is_ineligible, measures_not_ineffective_is_ineligible, no_deadline_set_is_ineligible, unsure_measures_need_legal_review, missing_deadline_keys_are_named_in_order, absent_entity_class_is_indeterminate, important_entity_is_ineligible, essential_fine_subject_needs_the_escalation_keys, duplicate_key_is_an_input_problem, unknown_key_is_an_input_problem, eligible_checklist_has_every_condition_met_and_cited, near_miss_checklist_names_the_failing_condition, missing_key_checklist_marks_it_unknown, essential_below_tie_rounds_up_to_the_fixed_floor, essential_at_tie_takes_the_fixed_basis, essential_above_tie_takes_the_turnover_basis_rounded_up, important_at_tie_takes_the_fixed_basis, important_above_tie_takes_the_turnover_basis_rounded_up, other_infringement_has_no_union_minimum, absent_provision_ceiling_is_indeterminate, input_problems_ceiling_has_no_citations, important_entity_has_fourteen_powers, essential_not_public_administration_has_the_escalation_powers, public_administration_entity_has_sixteen_powers, essential_powers_need_the_public_administration_key, powers_need_the_entity_class, powers_report_input_problems, gdpr_fine_for_same_conduct_bars_the_fine, not_same_conduct_does_not_bar_the_fine, unsure_same_conduct_needs_legal_review, other_infringement_is_not_barred, gdpr_bar_does_not_read_the_awareness_key, other_member_state_adds_the_own_supervisory_authority, own_member_state_informs_the_gdpr_authorities_only, not_aware_has_no_duty, other_infringement_has_no_duty, duty_names_the_absent_awareness_key, duty_needs_the_provision, well_formed_fixture_has_no_input_problem, a_non_list_profile_is_wrong_type, a_non_list_profile_status_is_input_problems]).
cp_test_fail_names([provenance_rejects_a_non_list_citation, escalation_exercisable_is_not_ineligible, action_taken_within_deadline_is_not_eligible, public_administration_entity_is_not_eligible, unsure_measures_are_not_eligible, missing_deadline_keys_are_not_eligible, important_entity_is_not_eligible, unknown_key_profile_is_not_ineligible, essential_at_tie_is_not_turnover_percentage, important_above_tie_is_not_fixed_amount, other_infringement_has_no_minimum_national_maximum, important_entity_has_no_monitoring_officer, public_administration_entity_has_no_escalation_power, gdpr_fine_barred_is_not_fine_not_barred, not_same_conduct_is_not_barred, own_member_state_has_no_own_member_state_duty]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
