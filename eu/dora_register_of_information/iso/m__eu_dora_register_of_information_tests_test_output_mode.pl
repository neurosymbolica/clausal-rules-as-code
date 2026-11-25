% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_register_of_information_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_register_of_information_dora_register_of_information, [register_of_information_duties_required/3, register_of_information_duties_complete/3, register_of_information_duties_outstanding/3, decide_dora_register_of_information/2, dora_register_of_information_status/2]).
:- use_module(m__eu_dora_register_of_information_fixtures, [dora_register_of_information_subject/1, dora_register_of_information_profile_for/2]).

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

test(every_subject_reads_out_its_status_once) :-
    findall(Subject - Status, (dora_register_of_information_subject(Subject), dora_register_of_information_profile_for(Subject, Profile), dora_register_of_information_status(Profile, Status)), Pairs),
    findall(Subject - Status, expected_status(Subject, Status), Expected),
    Pairs == Expected.
test(the_verdict_carries_a_citation) :-
    dora_register_of_information_profile_for(solo_entity_all_performed, Profile),
    decide_dora_register_of_information(Profile, dora_register_of_information_verdict(complete, [_FirstCitation|_OtherCitations])).
test(complete_reads_out_the_first_trigger) :-
    dora_register_of_information_profile_for(triggers_unanswered, Profile),
    findall(Result - Citations, register_of_information_duties_complete(Profile, Result, Citations), Answers),
    Answers == [indeterminate([financial_entity_responsible_for_sub_consolidated_register]) - []].
test(complete_reads_out_the_referral_with_its_pairs) :-
    dora_register_of_information_profile_for(data_quality_unsure, Profile),
    findall(Result - Citations, register_of_information_duties_complete(Profile, Result, Citations), Answers),
    Answers = [needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]) - []],
    Key == template_information_meets_data_quality_principles,
    Citation == cite(eu_reg_2024_2956_art_3_3),
    length(Pairs, 30),
    Pairs = [financial_entity_responsible_for_sub_consolidated_register - false|_],
    member(template_information_meets_data_quality_principles - unsure, Pairs).
test(required_reads_out_the_group_duties) :-
    dora_register_of_information_profile_for(group_parent_all_performed, Profile),
    findall(Result - Citations, register_of_information_duties_required(Profile, Result, Citations), Answers),
    Answers = [required(Duties) - Citations],
    length(Duties, 26),
    Duties = [register_at_entity_level, register_at_sub_consolidated_level, register_at_consolidated_level|_],
    member(consistency_with_sub_consolidated_level, Duties),
    member(consistency_with_consolidated_level, Duties),
    length(Citations, 13),
    member(cite(eu_reg_2024_2956_art_6_1), Citations),
    member(cite(eu_reg_2024_2956_art_6_2), Citations).
test(required_reads_out_the_critical_function_duties) :-
    dora_register_of_information_profile_for(critical_function_entity_all_performed, Profile),
    register_of_information_duties_required(Profile, required(Duties), Citations),
    length(Duties, 25),
    member(information_on_subcontractors_underpinning_critical_or_important_functions, Duties),
    member(identifiers_of_subcontractors, Duties),
    member(assessment_of_ict_services_supporting_critical_or_important_functions, Duties),
    length(Citations, 12),
    member(cite(eu_reg_2024_2956_art_3_6), Citations).
test(required_reads_out_the_branch_and_link_templates) :-
    dora_register_of_information_profile_for(branches_and_intra_group_all_performed, Profile),
    register_of_information_duties_required(Profile, required(Duties), Citations),
    length(Duties, 24),
    member(identification_of_branches_outside_home_country, Duties),
    member(links_between_intra_group_and_other_arrangements, Duties),
    length(Citations, 11).
test(outstanding_reads_out_the_failing_duties) :-
    dora_register_of_information_profile_for(critical_function_subcontractor_identifiers_missed, Profile),
    findall(Result - Citations, register_of_information_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [outstanding([identifiers_of_subcontractors]) - [cite(eu_reg_2024_2956_art_3_6)]].
test(outstanding_refers_where_complete_is_already_settled) :-
    dora_register_of_information_profile_for(data_quality_unsure_with_missed_report, Profile),
    register_of_information_duties_outstanding(Profile, Result, Citations),
    Result = needs_legal_review(open_textured(template_information_meets_data_quality_principles, cite(eu_reg_2024_2956_art_3_3)), _),
    Citations == [].

cp_test_names([every_subject_reads_out_its_status_once, the_verdict_carries_a_citation, complete_reads_out_the_first_trigger, complete_reads_out_the_referral_with_its_pairs, required_reads_out_the_group_duties, required_reads_out_the_critical_function_duties, required_reads_out_the_branch_and_link_templates, outstanding_reads_out_the_failing_duties, outstanding_refers_where_complete_is_already_settled]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
