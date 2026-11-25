% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_incident_management_process_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_ict_incident_management_process_dora_ict_incident_management_process, [decide_dora_ict_incident_management_process/2, dora_ict_incident_management_process_status/2, dora_ict_incident_management_process_checklist/2, dora_ict_incident_management_process_decision_resolvable/1, dora_ict_incident_management_process_status_values/1]).
:- use_module(m__eu_dora_ict_incident_management_process_fixtures, [dora_ict_incident_management_process_subject/1, dora_ict_incident_management_process_profile_for/2, dora_ict_incident_management_process_assess/2]).
:- use_module(m__eu_dora_ict_incident_management_process_dora_ict_incident_management_process, [ict_incident_management_process_duties_required/3, ict_incident_management_process_duties_complete/3, ict_incident_management_process_duties_outstanding/3]).
:- use_module(m__eu_dora_ict_incident_management_process_kernel, [dora_ict_incident_management_process_input_problems/2]).
:- use_module(m__eu_dora_ict_incident_management_process_queries, [dora_ict_incident_management_process_compliance/3]).

all_ten_duties([incident_management_process, recording_of_incidents_and_significant_cyber_threats, monitoring_handling_and_follow_up_procedures, early_warning_indicators, identification_and_classification_procedures, incident_roles_and_responsibilities, communication_and_escalation_plans, reporting_to_senior_management_and_management_body, incident_response_procedures, classification_of_significant_cyber_threats]).

fixed_citation_set(Set) :-
    sort([cite(eu_reg_2022_2554_art_17_1), cite(eu_reg_2022_2554_art_17_2), cite(eu_reg_2022_2554_art_17_3), cite(eu_reg_2022_2554_art_18_2)], Set).

has_fixed_citations(Citations) :-
    length(Citations, 4),
    sort(Citations, Set),
    fixed_citation_set(Set).

answer_of(required, Subject, Answer) :-
    dora_ict_incident_management_process_profile_for(Subject, Profile),
    findall(Result - Citations, ict_incident_management_process_duties_required(Profile, Result, Citations), Answers),
    Answers = [Answer].
answer_of(complete, Subject, Answer) :-
    dora_ict_incident_management_process_profile_for(Subject, Profile),
    findall(Result - Citations, ict_incident_management_process_duties_complete(Profile, Result, Citations), Answers),
    Answers = [Answer].
answer_of(outstanding, Subject, Answer) :-
    dora_ict_incident_management_process_profile_for(Subject, Profile),
    findall(Result - Citations, ict_incident_management_process_duties_outstanding(Profile, Result, Citations), Answers),
    Answers = [Answer].

attribute_pair(attribute(Key, Value), Key - Value).

facade_status(Subject, Status) :-
    dora_ict_incident_management_process_assess(Subject, dora_ict_incident_management_process_verdict(Got, _Citations)),
    Got == Status.

answers_once(Subject) :-
    dora_ict_incident_management_process_profile_for(Subject, Profile),
    findall(RequiredResult, ict_incident_management_process_duties_required(Profile, RequiredResult, _), RequiredAnswers),
    length(RequiredAnswers, 1),
    findall(CompleteResult, ict_incident_management_process_duties_complete(Profile, CompleteResult, _), CompleteAnswers),
    length(CompleteAnswers, 1),
    findall(OutstandingResult, ict_incident_management_process_duties_outstanding(Profile, OutstandingResult, _), OutstandingAnswers),
    length(OutstandingAnswers, 1),
    findall(Problems, dora_ict_incident_management_process_input_problems(Profile, Problems), ProblemAnswers),
    length(ProblemAnswers, 1),
    findall(Verdict, decide_dora_ict_incident_management_process(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

has_nonempty_checklist(Subject) :-
    dora_ict_incident_management_process_profile_for(Subject, Profile),
    dora_ict_incident_management_process_checklist(Profile, [_FirstItem|_OtherItems]).

status_in_vocabulary(Subject) :-
    dora_ict_incident_management_process_assess(Subject, dora_ict_incident_management_process_verdict(Status, _Citations)),
    dora_ict_incident_management_process_status_values(StatusValues),
    member(Status, StatusValues).

resolvable(Subject) :-
    dora_ict_incident_management_process_profile_for(Subject, Profile),
    dora_ict_incident_management_process_decision_resolvable(Profile).

lists_all_ten_duties(Subject) :-
    answer_of(required, Subject, required(Duties) - Citations),
    all_ten_duties(Duties),
    has_fixed_citations(Citations).

met_item(item(_Duty, met, cite(_Key))).

scored_context([inputs_relied_on(Pairs)], Pairs).
scored_context([inputs_relied_on(Pairs), provenance(_Clause, _Citations)], Pairs).

well_formed_subjects([all_duties_performed, early_warning_indicators_not_performed, classification_of_significant_cyber_threats_not_performed, both_article_17_2_duties_not_performed, no_duty_answered, last_duty_unanswered, not_performed_and_unanswered, communication_plans_unsure, early_warning_unsure_and_response_unanswered]).

expected_status(all_duties_performed, complete).
expected_status(early_warning_indicators_not_performed, incomplete).
expected_status(classification_of_significant_cyber_threats_not_performed, incomplete).
expected_status(both_article_17_2_duties_not_performed, incomplete).
expected_status(no_duty_answered, indeterminate).
expected_status(last_duty_unanswered, indeterminate).
expected_status(not_performed_and_unanswered, incomplete).
expected_status(communication_plans_unsure, needs_legal_review).
expected_status(early_warning_unsure_and_response_unanswered, indeterminate).
expected_status(unknown_key_present, input_problems).
expected_status(duplicate_key_present, input_problems).
expected_status(wrong_type_value, input_problems).
expected_status(not_an_attribute_list, input_problems).

expected_pair_holds(Subject - Status) :-
    facade_status(Subject, Status).

test(every_fixture_has_an_expected_status) :-
    findall(Subject, dora_ict_incident_management_process_subject(Subject), Subjects),
    findall(Expected, expected_status(Expected, _), ExpectedSubjects),
    clausal_msort(Subjects, Sorted),
    clausal_msort(ExpectedSubjects, Sorted).
test(every_fixture_gets_its_expected_status) :-
    findall(Subject - Status, expected_status(Subject, Status), Expected),
    maplist(expected_pair_holds, Expected).
test(every_fixture_answers_each_query_exactly_once) :-
    findall(Subject, dora_ict_incident_management_process_subject(Subject), Subjects),
    maplist(answers_once, Subjects).
test(every_fixture_status_is_in_the_vocabulary) :-
    findall(Subject, dora_ict_incident_management_process_subject(Subject), Subjects),
    maplist(status_in_vocabulary, Subjects).
test(every_fixture_has_a_nonempty_checklist) :-
    findall(Subject, dora_ict_incident_management_process_subject(Subject), Subjects),
    maplist(has_nonempty_checklist, Subjects).
test(every_fixture_is_resolvable) :-
    findall(Subject, dora_ict_incident_management_process_subject(Subject), Subjects),
    maplist(resolvable, Subjects).
test(every_well_formed_fixture_requires_all_ten_duties) :-
    well_formed_subjects(Subjects),
    maplist(lists_all_ten_duties, Subjects).
test(all_duties_performed_is_complete) :-
    answer_of(complete, all_duties_performed, complete - Citations),
    has_fixed_citations(Citations).
test(all_duties_performed_has_none_outstanding) :-
    answer_of(outstanding, all_duties_performed, none_outstanding - Citations),
    has_fixed_citations(Citations).
test(all_duties_performed_facade_is_complete) :-
    dora_ict_incident_management_process_status_for(all_duties_performed, complete).
test(all_duties_performed_checklist_is_ten_met_items_with_citations) :-
    dora_ict_incident_management_process_profile_for(all_duties_performed, Profile),
    dora_ict_incident_management_process_checklist(Profile, Items),
    length(Items, 10),
    maplist(met_item, Items).
test(all_duties_performed_has_no_input_problems) :-
    dora_ict_incident_management_process_profile_for(all_duties_performed, Profile),
    dora_ict_incident_management_process_input_problems(Profile, []).
test(early_warning_indicators_not_performed_is_incomplete) :-
    answer_of(complete, early_warning_indicators_not_performed, incomplete - Citations),
    has_fixed_citations(Citations).
test(early_warning_indicators_not_performed_is_outstanding_with_its_own_citation) :-
    answer_of(outstanding, early_warning_indicators_not_performed, outstanding(Duties) - Citations),
    Duties == [early_warning_indicators],
    Citations == [cite(eu_reg_2022_2554_art_17_3_a)].
test(early_warning_indicators_not_performed_facade_is_incomplete) :-
    dora_ict_incident_management_process_status_for(early_warning_indicators_not_performed, incomplete).
test(classification_not_performed_is_incomplete) :-
    answer_of(complete, classification_of_significant_cyber_threats_not_performed, incomplete - Citations),
    has_fixed_citations(Citations).
test(classification_not_performed_is_outstanding) :-
    answer_of(outstanding, classification_of_significant_cyber_threats_not_performed, outstanding(Duties) - Citations),
    Duties == [classification_of_significant_cyber_threats],
    Citations == [cite(eu_reg_2022_2554_art_18_2)].
test(both_article_17_2_duties_cite_article_17_2_once) :-
    answer_of(outstanding, both_article_17_2_duties_not_performed, outstanding(Duties) - Citations),
    Duties == [recording_of_incidents_and_significant_cyber_threats, monitoring_handling_and_follow_up_procedures],
    Citations == [cite(eu_reg_2022_2554_art_17_2)].
test(both_article_17_2_duties_not_performed_is_incomplete) :-
    answer_of(complete, both_article_17_2_duties_not_performed, incomplete - Citations),
    has_fixed_citations(Citations).
test(no_duty_answered_names_the_first_key_in_complete) :-
    answer_of(complete, no_duty_answered, indeterminate([ict_related_incident_management_process_defined_established_and_implemented]) - []).
test(no_duty_answered_names_the_first_key_in_outstanding) :-
    answer_of(outstanding, no_duty_answered, indeterminate([ict_related_incident_management_process_defined_established_and_implemented]) - []).
test(no_duty_answered_still_requires_all_ten) :-
    lists_all_ten_duties(no_duty_answered).
test(last_duty_unanswered_is_indeterminate_on_that_key) :-
    answer_of(complete, last_duty_unanswered, indeterminate([cyber_threats_classified_as_significant_on_the_article_18_2_criteria]) - []).
test(last_duty_unanswered_outstanding_is_indeterminate) :-
    answer_of(outstanding, last_duty_unanswered, indeterminate([cyber_threats_classified_as_significant_on_the_article_18_2_criteria]) - []).
test(last_duty_unanswered_facade_is_indeterminate) :-
    dora_ict_incident_management_process_status_for(last_duty_unanswered, indeterminate).
test(not_performed_and_unanswered_is_incomplete) :-
    answer_of(complete, not_performed_and_unanswered, incomplete - Citations),
    has_fixed_citations(Citations).
test(not_performed_and_unanswered_outstanding_waits_for_the_absent_key) :-
    answer_of(outstanding, not_performed_and_unanswered, indeterminate([ict_related_incident_management_process_defined_established_and_implemented]) - []).
test(communication_plans_unsure_is_referred_in_complete) :-
    dora_ict_incident_management_process_profile_for(communication_plans_unsure, Profile),
    maplist(attribute_pair, Profile, ExpectedPairs),
    answer_of(complete, communication_plans_unsure, needs_legal_review(open_textured(communication_notification_escalation_and_counterpart_information_plans_set_out, cite(eu_reg_2022_2554_art_17_3_d)), [inputs_relied_on(Pairs)]) - []),
    Pairs == ExpectedPairs.
test(communication_plans_unsure_is_referred_in_outstanding) :-
    dora_ict_incident_management_process_profile_for(communication_plans_unsure, Profile),
    maplist(attribute_pair, Profile, ExpectedPairs),
    answer_of(outstanding, communication_plans_unsure, needs_legal_review(open_textured(communication_notification_escalation_and_counterpart_information_plans_set_out, cite(eu_reg_2022_2554_art_17_3_d)), [inputs_relied_on(Pairs)]) - []),
    Pairs == ExpectedPairs.
test(communication_plans_unsure_facade_is_needs_legal_review) :-
    dora_ict_incident_management_process_status_for(communication_plans_unsure, needs_legal_review).
test(an_absent_key_is_named_before_an_unsure_key_in_complete) :-
    answer_of(complete, early_warning_unsure_and_response_unanswered, indeterminate([incident_response_procedures_established]) - []).
test(an_absent_key_is_named_before_an_unsure_key_in_outstanding) :-
    answer_of(outstanding, early_warning_unsure_and_response_unanswered, indeterminate([incident_response_procedures_established]) - []).
test(a_referral_context_without_provenance_gives_its_pairs) :-
    answer_of(complete, communication_plans_unsure, needs_legal_review(open_textured(_, cite(_)), Context) - []),
    scored_context(Context, Pairs),
    length(Pairs, 10).
test(a_referral_context_with_provenance_gives_the_same_pairs) :-
    answer_of(complete, communication_plans_unsure, needs_legal_review(_Reason, [inputs_relied_on(Pairs)]) - []),
    Provenance = provenance(ict_incident_management_process_duties_complete, [cite(eu_reg_2022_2554_art_17_3_d)]),
    Provenance = provenance(Clause, ProvenanceCitations),
    Clause == ict_incident_management_process_duties_complete,
    ProvenanceCitations == [cite(eu_reg_2022_2554_art_17_3_d)],
    scored_context([inputs_relied_on(Pairs), Provenance], ScoredPairs),
    ScoredPairs == Pairs.
test(unknown_key_present_is_refused_in_every_query) :-
    answer_of(required, unknown_key_present, input_problems([unknown_key(colour)]) - []),
    answer_of(complete, unknown_key_present, input_problems([unknown_key(colour)]) - []),
    answer_of(outstanding, unknown_key_present, input_problems([unknown_key(colour)]) - []).
test(unknown_key_present_facade_is_input_problems) :-
    dora_ict_incident_management_process_status_for(unknown_key_present, input_problems).
test(duplicate_key_present_is_duplicate_key_only) :-
    dora_ict_incident_management_process_profile_for(duplicate_key_present, Profile),
    dora_ict_incident_management_process_input_problems(Profile, [duplicate_key(incident_response_procedures_established)]).
test(duplicate_key_present_is_refused) :-
    answer_of(complete, duplicate_key_present, input_problems([duplicate_key(incident_response_procedures_established)]) - []).
test(wrong_type_value_is_wrong_type) :-
    answer_of(outstanding, wrong_type_value, input_problems([wrong_type(early_warning_indicators_put_in_place)]) - []).
test(not_an_attribute_list_is_wrong_type_profile) :-
    answer_of(required, not_an_attribute_list, input_problems([wrong_type(profile)]) - []),
    answer_of(complete, not_an_attribute_list, input_problems([wrong_type(profile)]) - []).
test(an_unbound_value_is_wrong_type) :-
    dora_ict_incident_management_process_input_problems([attribute(early_warning_indicators_put_in_place, _)], [wrong_type(early_warning_indicators_put_in_place)]).
test(an_unbound_key_is_unknown_as_that_variable) :-
    dora_ict_incident_management_process_input_problems([attribute(Key, true)], Problems),
    Problems = [unknown_key(Found)],
    Found == Key.
test(two_distinct_variable_keys_are_two_unknown_keys) :-
    dora_ict_incident_management_process_input_problems([attribute(FirstKey, true), attribute(SecondKey, true)], Problems),
    Problems = [unknown_key(FoundFirst), unknown_key(FoundSecond)],
    FoundFirst == FirstKey,
    FoundSecond == SecondKey.
test(integer_and_float_keys_are_two_keys) :-
    dora_ict_incident_management_process_input_problems([attribute(7, true), attribute(7.0, true)], Problems),
    Problems == [unknown_key(7), unknown_key(7.0)].
test(a_partial_list_is_wrong_type_profile) :-
    dora_ict_incident_management_process_input_problems([attribute(early_warning_indicators_put_in_place, true)|_], [wrong_type(profile)]).
test(a_non_attribute_element_is_wrong_type_profile) :-
    dora_ict_incident_management_process_input_problems([attribute(early_warning_indicators_put_in_place, true), colour], [wrong_type(profile)]).
test(omitting_a_duty_is_prohibited_with_its_citation) :-
    dora_ict_incident_management_process_profile_for(all_duties_performed, Profile),
    findall(Verdict, dora_ict_incident_management_process_compliance(Profile, omit(reporting_to_senior_management_and_management_body), Verdict), Verdicts),
    Verdicts == [permission(prohibited, [cite(eu_reg_2022_2554_art_17_3_e)])].
test(performing_a_duty_is_allowed_with_its_citation) :-
    dora_ict_incident_management_process_profile_for(early_warning_indicators_not_performed, Profile),
    findall(Verdict, dora_ict_incident_management_process_compliance(Profile, perform(early_warning_indicators), Verdict), Verdicts),
    Verdicts == [permission(allowed, [cite(eu_reg_2022_2554_art_17_3_a)])].
test(compliance_refuses_a_bad_profile) :-
    dora_ict_incident_management_process_profile_for(unknown_key_present, Profile),
    dora_ict_incident_management_process_compliance(Profile, omit(early_warning_indicators), input_problems([unknown_key(colour)])).

test(all_duties_performed_is_not_incomplete, fail) :-
    answer_of(complete, all_duties_performed, incomplete - _).
test(early_warning_indicators_not_performed_is_not_complete, fail) :-
    answer_of(complete, early_warning_indicators_not_performed, complete - _).
test(last_duty_unanswered_is_not_complete, fail) :-
    answer_of(complete, last_duty_unanswered, complete - _).
test(not_performed_and_unanswered_outstanding_gives_no_list, fail) :-
    answer_of(outstanding, not_performed_and_unanswered, outstanding(_) - _).
test(communication_plans_unsure_is_not_complete, fail) :-
    answer_of(complete, communication_plans_unsure, complete - _).
test(an_absent_key_blocks_the_referral, fail) :-
    answer_of(complete, early_warning_unsure_and_response_unanswered, needs_legal_review(_, _) - _).
test(the_query_itself_carries_no_provenance_item, fail) :-
    answer_of(complete, communication_plans_unsure, needs_legal_review(_, [inputs_relied_on(_), provenance(_, _)]) - _).
test(unknown_key_present_is_not_complete, fail) :-
    answer_of(complete, unknown_key_present, complete - _).
test(performing_a_duty_is_not_prohibited, fail) :-
    dora_ict_incident_management_process_profile_for(early_warning_indicators_not_performed, Profile),
    dora_ict_incident_management_process_compliance(Profile, perform(early_warning_indicators), permission(prohibited, _)).

dora_ict_incident_management_process_status_for(Subject, Status) :-
    dora_ict_incident_management_process_profile_for(Subject, Profile),
    dora_ict_incident_management_process_status(Profile, Got),
    Got == Status.

cp_test_names([every_fixture_has_an_expected_status, every_fixture_gets_its_expected_status, every_fixture_answers_each_query_exactly_once, every_fixture_status_is_in_the_vocabulary, every_fixture_has_a_nonempty_checklist, every_fixture_is_resolvable, every_well_formed_fixture_requires_all_ten_duties, all_duties_performed_is_complete, all_duties_performed_has_none_outstanding, all_duties_performed_facade_is_complete, all_duties_performed_checklist_is_ten_met_items_with_citations, all_duties_performed_has_no_input_problems, early_warning_indicators_not_performed_is_incomplete, early_warning_indicators_not_performed_is_outstanding_with_its_own_citation, early_warning_indicators_not_performed_facade_is_incomplete, classification_not_performed_is_incomplete, classification_not_performed_is_outstanding, both_article_17_2_duties_cite_article_17_2_once, both_article_17_2_duties_not_performed_is_incomplete, no_duty_answered_names_the_first_key_in_complete, no_duty_answered_names_the_first_key_in_outstanding, no_duty_answered_still_requires_all_ten, last_duty_unanswered_is_indeterminate_on_that_key, last_duty_unanswered_outstanding_is_indeterminate, last_duty_unanswered_facade_is_indeterminate, not_performed_and_unanswered_is_incomplete, not_performed_and_unanswered_outstanding_waits_for_the_absent_key, communication_plans_unsure_is_referred_in_complete, communication_plans_unsure_is_referred_in_outstanding, communication_plans_unsure_facade_is_needs_legal_review, an_absent_key_is_named_before_an_unsure_key_in_complete, an_absent_key_is_named_before_an_unsure_key_in_outstanding, a_referral_context_without_provenance_gives_its_pairs, a_referral_context_with_provenance_gives_the_same_pairs, unknown_key_present_is_refused_in_every_query, unknown_key_present_facade_is_input_problems, duplicate_key_present_is_duplicate_key_only, duplicate_key_present_is_refused, wrong_type_value_is_wrong_type, not_an_attribute_list_is_wrong_type_profile, an_unbound_value_is_wrong_type, an_unbound_key_is_unknown_as_that_variable, two_distinct_variable_keys_are_two_unknown_keys, integer_and_float_keys_are_two_keys, a_partial_list_is_wrong_type_profile, a_non_attribute_element_is_wrong_type_profile, omitting_a_duty_is_prohibited_with_its_citation, performing_a_duty_is_allowed_with_its_citation, compliance_refuses_a_bad_profile]).
cp_test_fail_names([all_duties_performed_is_not_incomplete, early_warning_indicators_not_performed_is_not_complete, last_duty_unanswered_is_not_complete, not_performed_and_unanswered_outstanding_gives_no_list, communication_plans_unsure_is_not_complete, an_absent_key_blocks_the_referral, the_query_itself_carries_no_provenance_item, unknown_key_present_is_not_complete, performing_a_duty_is_not_prohibited]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
