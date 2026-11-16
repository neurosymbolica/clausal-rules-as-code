% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_supervision_fines_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_nis2_supervision_fines_nis2_supervision_fines, [decide_nis2_supervision_fines/2, nis2_supervision_fines_status/2, nis2_supervision_fines_checklist/2, fine_ceiling_floor/3, minimum_powers/2, escalation_powers_exercisable/3, fine_barred_by_gdpr_fine/3, data_protection_authority_information/2]).
:- use_module(m__eu_nis2_supervision_fines_fixtures, [nis2_supervision_fines_profile_for/2]).

statuses_of(Subject, Statuses) :-
    nis2_supervision_fines_profile_for(Subject, Profile),
    findall(Status, nis2_supervision_fines_status(Profile, Status), Statuses).

ceilings_of(Subject, Answers) :-
    nis2_supervision_fines_profile_for(Subject, Profile),
    findall(Ceiling - Citations, fine_ceiling_floor(Profile, Ceiling, Citations), Answers).

test(the_baseline_profile_yields_exactly_one_status) :-
    statuses_of(escalation_exercisable, Statuses),
    Statuses == [eligible].
test(the_verdict_carries_a_citation) :-
    nis2_supervision_fines_profile_for(escalation_exercisable, Profile),
    decide_nis2_supervision_fines(Profile, nis2_supervision_fines_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(action_taken_is_ineligible) :-
    statuses_of(escalation_action_taken_within_deadline, Statuses),
    Statuses == [ineligible].
test(public_administration_is_ineligible) :-
    statuses_of(escalation_public_administration_entity, Statuses),
    Statuses == [ineligible].
test(unsure_measures_refer) :-
    statuses_of(escalation_measures_unsure, Statuses),
    Statuses == [needs_legal_review(open_textured(earlier_measures_ineffective, cite(eu_dir_2022_2555_art_32_5)), [inputs_relied_on([earlier_measures_ineffective - unsure])])].
test(missing_deadline_keys_are_named_in_order) :-
    statuses_of(escalation_deadline_keys_missing, Statuses),
    Statuses == [indeterminate([deadline_set_for_necessary_action, required_action_taken_within_deadline])].
test(empty_profile_needs_the_entity_class) :-
    statuses_of(entity_class_absent, Statuses),
    Statuses == [indeterminate([entity_class])].
test(duplicate_key_reports_input_problems) :-
    statuses_of(duplicate_entity_class, Statuses),
    Statuses == [input_problems([duplicate_key(entity_class)])].
test(unknown_key_reports_input_problems) :-
    statuses_of(unknown_key_present, Statuses),
    Statuses == [input_problems([unknown_key(sector)])].
test(checklist_reads_out_every_condition) :-
    nis2_supervision_fines_profile_for(escalation_no_deadline_set, Profile),
    findall(Items, nis2_supervision_fines_checklist(Profile, Items), [Items]),
    Items == [item(essential_entity, met, cite(eu_dir_2022_2555_art_32_5)), item(not_public_administration_entity, met, cite(eu_dir_2022_2555_art_32_5)), item(earlier_measures_found_ineffective, met, cite(eu_dir_2022_2555_art_32_5)), item(deadline_set, unmet(no_deadline_set), cite(eu_dir_2022_2555_art_32_5)), item(action_not_taken_within_deadline, met, cite(eu_dir_2022_2555_art_32_5))].
test(essential_below_tie_rounds_up_to_the_fixed_amount) :-
    ceilings_of(essential_fine_below_tie, Answers),
    Answers == [minimum_national_maximum(10000000, fixed_amount) - [cite(eu_dir_2022_2555_art_34_4)]].
test(essential_at_tie_is_fixed_amount) :-
    ceilings_of(essential_fine_at_tie, Answers),
    Answers == [minimum_national_maximum(10000000, fixed_amount) - [cite(eu_dir_2022_2555_art_34_4)]].
test(essential_above_tie_is_turnover_percentage) :-
    ceilings_of(essential_fine_above_tie, Answers),
    Answers == [minimum_national_maximum(10000001, turnover_percentage) - [cite(eu_dir_2022_2555_art_34_4)]].
test(important_at_tie_is_fixed_amount) :-
    ceilings_of(important_fine_at_tie, Answers),
    Answers == [minimum_national_maximum(7000000, fixed_amount) - [cite(eu_dir_2022_2555_art_34_5)]].
test(important_above_tie_is_turnover_percentage) :-
    ceilings_of(important_fine_above_tie, Answers),
    Answers == [minimum_national_maximum(7000001, turnover_percentage) - [cite(eu_dir_2022_2555_art_34_5)]].
test(other_infringement_has_no_union_minimum) :-
    ceilings_of(other_infringement, Answers),
    Answers == [no_union_minimum - [cite(eu_dir_2022_2555_art_34_4), cite(eu_dir_2022_2555_art_34_5)]].
test(important_powers_read_out_once) :-
    nis2_supervision_fines_profile_for(important_fine_at_tie, Profile),
    findall(Powers, minimum_powers(Profile, Powers), [Powers]),
    length(Powers, 14),
    last(Powers, power(enforcement, administrative_fine, cite(eu_dir_2022_2555_art_33_4_h))).
test(escalation_read_out_for_important) :-
    nis2_supervision_fines_profile_for(gdpr_fine_barred, Profile),
    findall(Result - Citations, escalation_powers_exercisable(Profile, Result, Citations), Answers),
    Answers == [not_exercisable(important_entity) - [cite(eu_dir_2022_2555_art_32_5)]].
test(fine_bar_same_conduct_unsure_read_out) :-
    nis2_supervision_fines_profile_for(gdpr_same_conduct_unsure, Profile),
    findall(Result - Citations, fine_barred_by_gdpr_fine(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(gdpr_fine_for_same_conduct, cite(eu_dir_2022_2555_art_35_2)), [inputs_relied_on([infringement_may_entail_notifiable_personal_data_breach - true, gdpr_fine_for_same_conduct - unsure])]) - []].
test(duty_read_out_with_other_member_state) :-
    nis2_supervision_fines_profile_for(information_other_member_state, Profile),
    findall(Duty, data_protection_authority_information(Profile, Duty), Answers),
    Answers == [[inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1)), inform_supervisory_authority_in_own_member_state(cite(eu_dir_2022_2555_art_35_3))]].

cp_test_names([the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, action_taken_is_ineligible, public_administration_is_ineligible, unsure_measures_refer, missing_deadline_keys_are_named_in_order, empty_profile_needs_the_entity_class, duplicate_key_reports_input_problems, unknown_key_reports_input_problems, checklist_reads_out_every_condition, essential_below_tie_rounds_up_to_the_fixed_amount, essential_at_tie_is_fixed_amount, essential_above_tie_is_turnover_percentage, important_at_tie_is_fixed_amount, important_above_tie_is_turnover_percentage, other_infringement_has_no_union_minimum, important_powers_read_out_once, escalation_read_out_for_important, fine_bar_same_conduct_unsure_read_out, duty_read_out_with_other_member_state]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
