% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_information_sharing_arrangements_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_information_sharing_arrangements_dora_information_sharing_arrangements, [decide_dora_information_sharing_arrangements/2, dora_information_sharing_arrangements_status/2, dora_information_sharing_arrangements_status_values/1, dora_information_sharing_arrangements_checklist/2, information_sharing_within_article_45/3, membership_notification_duty/3]).
:- use_module(m__eu_dora_information_sharing_arrangements_fixtures, [dora_information_sharing_arrangements_profile_for/2]).

condition_citations([cite(eu_reg_2022_2554_art_45_1), cite(eu_reg_2022_2554_art_45_1_a), cite(eu_reg_2022_2554_art_45_1_b), cite(eu_reg_2022_2554_art_45_1_c), cite(eu_reg_2022_2554_art_45_2)]).

sharing_answers(Subject, Answers) :-
    dora_information_sharing_arrangements_profile_for(Subject, Profile),
    findall(Result - Citations, information_sharing_within_article_45(Profile, Result, Citations), Answers).

duty_answers(Subject, Answers) :-
    dora_information_sharing_arrangements_profile_for(Subject, Profile),
    findall(Result - Citations, membership_notification_duty(Profile, Result, Citations), Answers).

test(a4_all_conditions_met_is_within) :-
    sharing_answers(all_conditions_met, Answers),
    condition_citations(Citations),
    Answers == [sharing_within_article_45 - Citations].
test(a1_paragraph_2_false_is_outside) :-
    sharing_answers(paragraph_2_false, Answers),
    condition_citations(Citations),
    Answers == [sharing_outside_article_45 - Citations].
test(a1_false_decides_alone_with_others_absent) :-
    sharing_answers(community_false_with_absent_others, Answers),
    condition_citations(Citations),
    Answers == [sharing_outside_article_45 - Citations].
test(a2_absent_condition_is_named) :-
    sharing_answers(community_absent, Answers),
    Answers == [indeterminate([sharing_takes_place_within_trusted_community_of_financial_entities]) - []].
test(a2_absent_named_before_earlier_unsure) :-
    sharing_answers(first_absent_before_unsure, Answers),
    Answers == [indeterminate([sharing_takes_place_within_trusted_community_of_financial_entities]) - []].
test(a2_first_absent_in_root_exports_order) :-
    sharing_answers(cessation_effective_true, Answers),
    Answers == [indeterminate([information_is_cyber_threat_information_and_intelligence]) - []].
test(a3_point_c_unsure_is_referred_with_pairs) :-
    sharing_answers(point_c_unsure_referral, Answers),
    Answers == [needs_legal_review(open_textured(arrangement_protects_sensitive_information_and_has_rules_of_conduct, cite(eu_reg_2022_2554_art_45_1_c)), [inputs_relied_on([information_is_cyber_threat_information_and_intelligence - true, sharing_aims_to_enhance_digital_operational_resilience - true, sharing_takes_place_within_trusted_community_of_financial_entities - true, arrangement_protects_sensitive_information_and_has_rules_of_conduct - unsure, arrangement_defines_participation_conditions_and_appropriate_details - true])]) - []].
test(a3_each_unsure_key_takes_its_referral_citation) :-
    Profile = [attribute(information_is_cyber_threat_information_and_intelligence, true), attribute(sharing_aims_to_enhance_digital_operational_resilience, true), attribute(sharing_takes_place_within_trusted_community_of_financial_entities, true), attribute(arrangement_protects_sensitive_information_and_has_rules_of_conduct, true), attribute(arrangement_defines_participation_conditions_and_appropriate_details, unsure)],
    findall(Result, information_sharing_within_article_45(Profile, Result, []), Results),
    Results = [needs_legal_review(open_textured(arrangement_defines_participation_conditions_and_appropriate_details, cite(eu_reg_2022_2554_art_45_2)), _Context)].
test(a0_input_problems_first) :-
    sharing_answers(duplicate_and_unknown_keys, Answers),
    Answers == [input_problems([duplicate_key(membership_event), unknown_key(entity_size)]) - []].
test(b4_validation_gives_participation_notice) :-
    duty_answers(all_conditions_met, Answers),
    Answers == [notify_participation_upon_validation - [cite(eu_reg_2022_2554_art_45_3)]].
test(b4_conditions_are_not_read_by_the_duty_query) :-
    duty_answers(paragraph_2_false, Answers),
    Answers == [notify_participation_upon_validation - [cite(eu_reg_2022_2554_art_45_3)]].
test(b4_cessation_gives_cessation_notice) :-
    duty_answers(cessation_effective_true, Answers),
    Answers == [notify_cessation_once_effective - [cite(eu_reg_2022_2554_art_45_3)]].
test(b1_arrangement_false_gives_no_duty) :-
    duty_answers(cessation_arrangement_false, Answers),
    Answers == [no_notification_duty - [cite(eu_reg_2022_2554_art_45_3)]].
test(b1_no_event_decides_alone) :-
    duty_answers(no_event_with_unsure_arrangement, Answers),
    Answers == [no_notification_duty - [cite(eu_reg_2022_2554_art_45_3)]].
test(b2_absent_event_named_before_unsure_arrangement) :-
    duty_answers(event_absent_arrangement_unsure, Answers),
    Answers == [indeterminate([membership_event]) - []].
test(b2_absent_event_with_nothing_else) :-
    duty_answers(community_false_with_absent_others, Answers),
    Answers == [indeterminate([membership_event]) - []].
test(b2_absent_arrangement_named) :-
    duty_answers(arrangement_absent, Answers),
    Answers == [indeterminate([arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1]) - []].
test(b3_unsure_arrangement_is_referred) :-
    duty_answers(arrangement_unsure_referral, Answers),
    Answers == [needs_legal_review(open_textured(arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, cite(eu_reg_2022_2554_art_45_3)), [inputs_relied_on([membership_event - membership_validated, arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1 - unsure])]) - []].
test(b0_wrong_type_value) :-
    duty_answers(wrong_type_value, Answers),
    Answers == [input_problems([wrong_type(membership_event)]) - []].
test(b0_unbound_value) :-
    duty_answers(unbound_value, Answers),
    Answers == [input_problems([wrong_type(sharing_aims_to_enhance_digital_operational_resilience)]) - []].
test(the_baseline_profile_yields_exactly_one_status) :-
    dora_information_sharing_arrangements_profile_for(all_conditions_met, Profile),
    findall(Status, dora_information_sharing_arrangements_status(Profile, Status), Statuses),
    Statuses == [sharing_within_article_45].
test(the_verdict_carries_a_citation) :-
    dora_information_sharing_arrangements_profile_for(all_conditions_met, Profile),
    decide_dora_information_sharing_arrangements(Profile, dora_information_sharing_arrangements_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(every_table_status_is_reached_by_a_fixture) :-
    dora_information_sharing_arrangements_status_values(StatusValues),
    findall(Status, (member(Subject, [all_conditions_met, paragraph_2_false]), dora_information_sharing_arrangements_profile_for(Subject, Profile), dora_information_sharing_arrangements_status(Profile, Status)), Reached),
    clausal_msort(StatusValues, Sorted),
    clausal_msort(Reached, Sorted).
test(checklist_reads_out_every_condition_with_its_citation) :-
    dora_information_sharing_arrangements_profile_for(point_c_unsure_referral, Profile),
    findall(Items, dora_information_sharing_arrangements_checklist(Profile, Items), [Items]),
    Items == [item(information_is_cyber_threat_information_and_intelligence, met, cite(eu_reg_2022_2554_art_45_1)), item(sharing_aims_to_enhance_digital_operational_resilience, met, cite(eu_reg_2022_2554_art_45_1_a)), item(sharing_takes_place_within_trusted_community_of_financial_entities, met, cite(eu_reg_2022_2554_art_45_1_b)), item(arrangement_protects_sensitive_information_and_has_rules_of_conduct, open_textured(arrangement_protects_sensitive_information_and_has_rules_of_conduct), cite(eu_reg_2022_2554_art_45_1_c)), item(arrangement_defines_participation_conditions_and_appropriate_details, met, cite(eu_reg_2022_2554_art_45_2))].

cp_test_names([a4_all_conditions_met_is_within, a1_paragraph_2_false_is_outside, a1_false_decides_alone_with_others_absent, a2_absent_condition_is_named, a2_absent_named_before_earlier_unsure, a2_first_absent_in_root_exports_order, a3_point_c_unsure_is_referred_with_pairs, a3_each_unsure_key_takes_its_referral_citation, a0_input_problems_first, b4_validation_gives_participation_notice, b4_conditions_are_not_read_by_the_duty_query, b4_cessation_gives_cessation_notice, b1_arrangement_false_gives_no_duty, b1_no_event_decides_alone, b2_absent_event_named_before_unsure_arrangement, b2_absent_event_with_nothing_else, b2_absent_arrangement_named, b3_unsure_arrangement_is_referred, b0_wrong_type_value, b0_unbound_value, the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, every_table_status_is_reached_by_a_fixture, checklist_reads_out_every_condition_with_its_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
