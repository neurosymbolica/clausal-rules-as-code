% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_information_sharing_arrangements_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_information_sharing_arrangements_dora_information_sharing_arrangements, [decide_dora_information_sharing_arrangements/2, dora_information_sharing_arrangements_status/2, dora_information_sharing_arrangements_checklist/2, dora_information_sharing_arrangements_decision_resolvable/1, dora_information_sharing_arrangements_status_values/1, information_sharing_within_article_45/3, membership_notification_duty/3]).
:- use_module(m__eu_dora_information_sharing_arrangements_fixtures, [dora_information_sharing_arrangements_subject/1, dora_information_sharing_arrangements_profile_for/2, dora_information_sharing_arrangements_assess/2]).
:- use_module(m__eu_dora_information_sharing_arrangements_kernel, [dora_information_sharing_arrangements_input_problems/2]).

expected_sharing(all_conditions_met, sharing_within_article_45).
expected_sharing(paragraph_2_false, sharing_outside_article_45).
expected_sharing(community_false_with_absent_others, sharing_outside_article_45).
expected_sharing(community_absent, indeterminate([sharing_takes_place_within_trusted_community_of_financial_entities])).
expected_sharing(first_absent_before_unsure, indeterminate([sharing_takes_place_within_trusted_community_of_financial_entities])).
expected_sharing(point_c_unsure_referral, needs_legal_review(open_textured(arrangement_protects_sensitive_information_and_has_rules_of_conduct, cite(eu_reg_2022_2554_art_45_1_c)), [inputs_relied_on([information_is_cyber_threat_information_and_intelligence - true, sharing_aims_to_enhance_digital_operational_resilience - true, sharing_takes_place_within_trusted_community_of_financial_entities - true, arrangement_protects_sensitive_information_and_has_rules_of_conduct - unsure, arrangement_defines_participation_conditions_and_appropriate_details - true])])).
expected_sharing(cessation_effective_true, indeterminate([information_is_cyber_threat_information_and_intelligence])).
expected_sharing(cessation_arrangement_false, indeterminate([information_is_cyber_threat_information_and_intelligence])).
expected_sharing(no_event_with_unsure_arrangement, indeterminate([information_is_cyber_threat_information_and_intelligence])).
expected_sharing(event_absent_arrangement_unsure, indeterminate([information_is_cyber_threat_information_and_intelligence])).
expected_sharing(arrangement_absent, indeterminate([information_is_cyber_threat_information_and_intelligence])).
expected_sharing(arrangement_unsure_referral, indeterminate([information_is_cyber_threat_information_and_intelligence])).
expected_sharing(duplicate_and_unknown_keys, input_problems([duplicate_key(membership_event), unknown_key(entity_size)])).
expected_sharing(wrong_type_value, input_problems([wrong_type(membership_event)])).
expected_sharing(non_list_profile, input_problems([wrong_type(profile)])).
expected_sharing(unbound_value, input_problems([wrong_type(sharing_aims_to_enhance_digital_operational_resilience)])).

expected_notification(all_conditions_met, notify_participation_upon_validation).
expected_notification(paragraph_2_false, notify_participation_upon_validation).
expected_notification(community_false_with_absent_others, indeterminate([membership_event])).
expected_notification(community_absent, notify_participation_upon_validation).
expected_notification(first_absent_before_unsure, indeterminate([membership_event])).
expected_notification(point_c_unsure_referral, indeterminate([membership_event])).
expected_notification(cessation_effective_true, notify_cessation_once_effective).
expected_notification(cessation_arrangement_false, no_notification_duty).
expected_notification(no_event_with_unsure_arrangement, no_notification_duty).
expected_notification(event_absent_arrangement_unsure, indeterminate([membership_event])).
expected_notification(arrangement_absent, indeterminate([arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1])).
expected_notification(arrangement_unsure_referral, needs_legal_review(open_textured(arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, cite(eu_reg_2022_2554_art_45_3)), [inputs_relied_on([membership_event - membership_validated, arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1 - unsure])])).
expected_notification(duplicate_and_unknown_keys, input_problems([duplicate_key(membership_event), unknown_key(entity_size)])).
expected_notification(wrong_type_value, input_problems([wrong_type(membership_event)])).
expected_notification(non_list_profile, input_problems([wrong_type(profile)])).
expected_notification(unbound_value, input_problems([wrong_type(sharing_aims_to_enhance_digital_operational_resilience)])).

sharing_citations([cite(eu_reg_2022_2554_art_45_1), cite(eu_reg_2022_2554_art_45_1_a), cite(eu_reg_2022_2554_art_45_1_b), cite(eu_reg_2022_2554_art_45_1_c), cite(eu_reg_2022_2554_art_45_2)]).

result_citations(sharing_within_article_45, Citations) :-
    sharing_citations(Citations).
result_citations(sharing_outside_article_45, Citations) :-
    sharing_citations(Citations).
result_citations(notify_participation_upon_validation, [cite(eu_reg_2022_2554_art_45_3)]).
result_citations(notify_cessation_once_effective, [cite(eu_reg_2022_2554_art_45_3)]).
result_citations(no_notification_duty, [cite(eu_reg_2022_2554_art_45_3)]).
result_citations(indeterminate(_MissingKeys), []).
result_citations(needs_legal_review(_Reason, _Context), []).
result_citations(input_problems(_Problems), []).

same_citation_set(Actual, Expected) :-
    clausal_msort(Actual, SortedActual),
    clausal_msort(Expected, SortedExpected),
    SortedActual == SortedExpected.

sharing_as_expected(Subject) :-
    expected_sharing(Subject, Expected),
    dora_information_sharing_arrangements_profile_for(Subject, Profile),
    findall(Result - Citations, information_sharing_within_article_45(Profile, Result, Citations), Answers),
    Answers = [Result - Citations],
    Result == Expected,
    result_citations(Expected, ExpectedCitations),
    same_citation_set(Citations, ExpectedCitations).

notification_as_expected(Subject) :-
    expected_notification(Subject, Expected),
    dora_information_sharing_arrangements_profile_for(Subject, Profile),
    findall(Result - Citations, membership_notification_duty(Profile, Result, Citations), Answers),
    Answers = [Result - Citations],
    Result == Expected,
    result_citations(Expected, ExpectedCitations),
    same_citation_set(Citations, ExpectedCitations).

assess_as_expected(Subject) :-
    expected_sharing(Subject, Expected),
    findall(Verdict, dora_information_sharing_arrangements_assess(Subject, Verdict), Verdicts),
    Verdicts = [dora_information_sharing_arrangements_verdict(Status, _Citations)],
    Status == Expected.

all_subjects(Subjects) :-
    findall(Subject, dora_information_sharing_arrangements_subject(Subject), Subjects).

test(there_are_sixteen_subjects) :-
    all_subjects(Subjects),
    length(Subjects, 16).
test(every_subject_gets_its_expected_sharing_answer_once) :-
    all_subjects(Subjects),
    maplist(sharing_as_expected, Subjects).
test(every_subject_gets_its_expected_notification_answer_once) :-
    all_subjects(Subjects),
    maplist(notification_as_expected, Subjects).
test(every_subject_assesses_through_the_facade_once) :-
    all_subjects(Subjects),
    maplist(assess_as_expected, Subjects).
test(all_conditions_met_is_within) :-
    dora_information_sharing_arrangements_assess(all_conditions_met, dora_information_sharing_arrangements_verdict(sharing_within_article_45, _Citations)).
test(paragraph_2_false_is_outside) :-
    dora_information_sharing_arrangements_assess(paragraph_2_false, dora_information_sharing_arrangements_verdict(sharing_outside_article_45, _Citations)).
test(community_false_is_outside) :-
    dora_information_sharing_arrangements_status_of(community_false_with_absent_others, sharing_outside_article_45).
test(community_absent_is_indeterminate_not_outside) :-
    dora_information_sharing_arrangements_status_of(community_absent, indeterminate([sharing_takes_place_within_trusted_community_of_financial_entities])).
test(cessation_true_gives_cessation_notice) :-
    dora_information_sharing_arrangements_profile_for(cessation_effective_true, Profile),
    membership_notification_duty(Profile, notify_cessation_once_effective, [cite(eu_reg_2022_2554_art_45_3)]).
test(cessation_arrangement_false_gives_no_duty) :-
    dora_information_sharing_arrangements_profile_for(cessation_arrangement_false, Profile),
    membership_notification_duty(Profile, no_notification_duty, [cite(eu_reg_2022_2554_art_45_3)]).
test(validated_gives_participation_notice) :-
    dora_information_sharing_arrangements_profile_for(all_conditions_met, Profile),
    membership_notification_duty(Profile, notify_participation_upon_validation, [cite(eu_reg_2022_2554_art_45_3)]).
test(notification_ignores_the_condition_keys) :-
    dora_information_sharing_arrangements_profile_for(paragraph_2_false, Profile),
    membership_notification_duty(Profile, notify_participation_upon_validation, _Citations).
test(input_check_names_duplicate_then_unknown) :-
    dora_information_sharing_arrangements_profile_for(duplicate_and_unknown_keys, Profile),
    findall(Problems, dora_information_sharing_arrangements_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(membership_event), unknown_key(entity_size)]].
test(input_check_is_empty_for_a_good_profile) :-
    dora_information_sharing_arrangements_profile_for(all_conditions_met, Profile),
    findall(Problems, dora_information_sharing_arrangements_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(input_check_refuses_a_non_list) :-
    dora_information_sharing_arrangements_input_problems(not_an_attribute_list, [wrong_type(profile)]).
test(checklist_has_one_cited_item_per_condition) :-
    dora_information_sharing_arrangements_profile_for(all_conditions_met, Profile),
    dora_information_sharing_arrangements_checklist(Profile, Items),
    length(Items, 5),
    maplist(cited_item, Items),
    member(item(arrangement_protects_sensitive_information_and_has_rules_of_conduct, met, cite(eu_reg_2022_2554_art_45_1_c)), Items).
test(checklist_marks_the_false_condition_unmet) :-
    dora_information_sharing_arrangements_profile_for(paragraph_2_false, Profile),
    dora_information_sharing_arrangements_checklist(Profile, [_FirstItem|_OtherItems]),
    dora_information_sharing_arrangements_checklist(Profile, Items),
    member(item(arrangement_defines_participation_conditions_and_appropriate_details, unmet(_Reason), cite(eu_reg_2022_2554_art_45_2)), Items).
test(checklist_holds_for_a_partial_profile) :-
    dora_information_sharing_arrangements_profile_for(community_absent, Profile),
    dora_information_sharing_arrangements_checklist(Profile, Items),
    member(item(sharing_takes_place_within_trusted_community_of_financial_entities, unknown(_Keys), cite(eu_reg_2022_2554_art_45_1_b)), Items).
test(status_values_hold_the_final_answers) :-
    dora_information_sharing_arrangements_status_values(StatusValues),
    clausal_msort(StatusValues, [sharing_outside_article_45, sharing_within_article_45]).
test(decision_resolves_for_every_subject) :-
    all_subjects(Subjects),
    maplist(subject_resolvable, Subjects).
test(decide_carries_the_sharing_citations) :-
    dora_information_sharing_arrangements_profile_for(all_conditions_met, Profile),
    decide_dora_information_sharing_arrangements(Profile, dora_information_sharing_arrangements_verdict(sharing_within_article_45, Citations)),
    sharing_citations(Expected),
    same_citation_set(Citations, Expected).
test(provenance_term_builds_for_a_sharing_referral) :-
    Item = provenance(sharing_answer, [cite(eu_reg_2022_2554_art_45_1_c)]),
    Item = provenance(Clause, Citations),
    Clause == sharing_answer,
    Citations == [cite(eu_reg_2022_2554_art_45_1_c)].
test(provenance_term_builds_for_a_notification_referral) :-
    Item = provenance(notification_answer, [cite(eu_reg_2022_2554_art_45_3)]),
    Item = provenance(Clause, Citations),
    Clause == notification_answer,
    Citations == [cite(eu_reg_2022_2554_art_45_3)].
test(a_referral_context_may_carry_a_provenance_item) :-
    Context = [inputs_relied_on([membership_event - membership_validated, arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1 - unsure]), provenance(notification_answer, [cite(eu_reg_2022_2554_art_45_3)])],
    Context = [inputs_relied_on(_Pairs), provenance(Clause, _Citations)],
    Clause == notification_answer.

test(paragraph_2_false_is_not_within, fail) :-
    dora_information_sharing_arrangements_assess(paragraph_2_false, dora_information_sharing_arrangements_verdict(sharing_within_article_45, _Citations)).
test(all_conditions_met_is_not_outside, fail) :-
    dora_information_sharing_arrangements_assess(all_conditions_met, dora_information_sharing_arrangements_verdict(sharing_outside_article_45, _Citations)).
test(community_absent_is_not_outside, fail) :-
    dora_information_sharing_arrangements_status_of(community_absent, sharing_outside_article_45).
test(point_c_unsure_is_referred_not_within, fail) :-
    dora_information_sharing_arrangements_status_of(point_c_unsure_referral, sharing_within_article_45).
test(cessation_arrangement_false_is_not_cessation_notice, fail) :-
    dora_information_sharing_arrangements_profile_for(cessation_arrangement_false, Profile),
    membership_notification_duty(Profile, notify_cessation_once_effective, _Citations).
test(unsure_arrangement_is_not_participation_notice, fail) :-
    dora_information_sharing_arrangements_profile_for(arrangement_unsure_referral, Profile),
    membership_notification_duty(Profile, notify_participation_upon_validation, _Citations).
test(checklist_is_refused_with_input_problems, fail) :-
    dora_information_sharing_arrangements_profile_for(duplicate_and_unknown_keys, Profile),
    dora_information_sharing_arrangements_checklist(Profile, _Items).

dora_information_sharing_arrangements_status_of(Subject, Status) :-
    dora_information_sharing_arrangements_profile_for(Subject, Profile),
    dora_information_sharing_arrangements_status(Profile, Status).

cited_item(item(_Identifier, _Status, cite(_Key))).

subject_resolvable(Subject) :-
    dora_information_sharing_arrangements_profile_for(Subject, Profile),
    dora_information_sharing_arrangements_decision_resolvable(Profile).

cp_test_names([there_are_sixteen_subjects, every_subject_gets_its_expected_sharing_answer_once, every_subject_gets_its_expected_notification_answer_once, every_subject_assesses_through_the_facade_once, all_conditions_met_is_within, paragraph_2_false_is_outside, community_false_is_outside, community_absent_is_indeterminate_not_outside, cessation_true_gives_cessation_notice, cessation_arrangement_false_gives_no_duty, validated_gives_participation_notice, notification_ignores_the_condition_keys, input_check_names_duplicate_then_unknown, input_check_is_empty_for_a_good_profile, input_check_refuses_a_non_list, checklist_has_one_cited_item_per_condition, checklist_marks_the_false_condition_unmet, checklist_holds_for_a_partial_profile, status_values_hold_the_final_answers, decision_resolves_for_every_subject, decide_carries_the_sharing_citations, provenance_term_builds_for_a_sharing_referral, provenance_term_builds_for_a_notification_referral, a_referral_context_may_carry_a_provenance_item]).
cp_test_fail_names([paragraph_2_false_is_not_within, all_conditions_met_is_not_outside, community_absent_is_not_outside, point_c_unsure_is_referred_not_within, cessation_arrangement_false_is_not_cessation_notice, unsure_arrangement_is_not_participation_notice, checklist_is_refused_with_input_problems]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
