% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_protection_and_detection_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_keys/2]).
:- use_module(clausal_lists_extra, [last/2, clausal_msort/2]).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_dora_ict_risk_protection_and_detection, [decide_dora_ict_risk_protection_and_detection/2, dora_ict_risk_protection_and_detection_status/2, dora_ict_risk_protection_and_detection_checklist/2, dora_ict_risk_protection_and_detection_decision_resolvable/1, dora_ict_risk_protection_and_detection_status_values/1]).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_fixtures, [dora_ict_risk_protection_and_detection_subject/1, dora_ict_risk_protection_and_detection_profile_for/2, dora_ict_risk_protection_and_detection_assess/2]).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_dora_ict_risk_protection_and_detection, [ict_risk_protection_and_detection_duties_required/3, ict_risk_protection_and_detection_duties_complete/3, ict_risk_protection_and_detection_duties_outstanding/3]).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_kernel, [dora_ict_risk_protection_and_detection_input_problems/2]).
:- use_module(m__eu_dora_ict_risk_protection_and_detection_queries, [dora_ict_risk_protection_and_detection_profile_keys/1, dora_ict_risk_protection_and_detection_what_if/4]).

expected_status(credit_institution_all_duties_performed, complete).
expected_status(credit_institution_patch_policies_not_documented, incomplete).
expected_status(data_reporting_provider_all_duties_performed, complete).
expected_status(data_reporting_provider_trade_report_checking_not_in_place, incomplete).
expected_status(credit_institution_trade_report_checking_not_in_place, complete).
expected_status(credit_institution_trade_report_checking_unsure, complete).
expected_status(data_reporting_provider_trade_report_checking_unanswered, indeterminate([trade_report_checking_systems_in_place])).
expected_status(article_16_1_entity_with_duties_not_performed, simplified_framework_entity).
expected_status(article_16_1_status_unanswered, indeterminate([financial_entity_is_article_16_1_entity])).
expected_status(entity_type_and_trade_report_checking_unanswered, indeterminate([dora_entity_type])).
expected_status(entity_type_unanswered_trade_report_checking_in_place, complete).
expected_status(entity_type_monitoring_and_trade_report_checking_unanswered, indeterminate([monitors_and_controls_security_and_functioning_of_ict_systems])).
expected_status(entity_type_and_monitoring_unanswered_trade_report_checking_not_in_place, indeterminate([dora_entity_type])).
expected_status(security_tools_deployment_unsure, needs_legal_review(open_textured(deploys_ict_security_tools_policies_and_procedures, cite(eu_reg_2022_2554_art_9_1)), [inputs_relied_on(_)])).
expected_status(security_tools_deployment_unsure_patch_policies_not_documented, incomplete).
expected_status(security_tools_deployment_unsure_anomaly_detection_unanswered, indeterminate([anomaly_detection_mechanisms_in_place])).
expected_status(ict_third_party_service_provider_all_duties_performed, complete).
expected_status(article_16_1_status_given_as_unsure, input_problems([wrong_type(financial_entity_is_article_16_1_entity)])).
expected_status(unknown_key_given, input_problems([unknown_key(colour)])).
expected_status(anomaly_detection_given_twice, input_problems([duplicate_key(anomaly_detection_mechanisms_in_place)])).

eight_paragraph_citations([cite(eu_reg_2022_2554_art_9_1), cite(eu_reg_2022_2554_art_9_2), cite(eu_reg_2022_2554_art_9_3), cite(eu_reg_2022_2554_art_9_4), cite(eu_reg_2022_2554_art_10_1), cite(eu_reg_2022_2554_art_10_2), cite(eu_reg_2022_2554_art_10_3), cite(eu_reg_2022_2554_art_10_4)]).

seven_paragraph_citations([cite(eu_reg_2022_2554_art_9_1), cite(eu_reg_2022_2554_art_9_2), cite(eu_reg_2022_2554_art_9_3), cite(eu_reg_2022_2554_art_9_4), cite(eu_reg_2022_2554_art_10_1), cite(eu_reg_2022_2554_art_10_2), cite(eu_reg_2022_2554_art_10_3)]).

same_citation_set(Citations, Expected) :-
    clausal_msort(Citations, Sorted),
    clausal_msort(Expected, Sorted).

accepted_context([inputs_relied_on(Pairs)], Pairs).
accepted_context([inputs_relied_on(Pairs), provenance(_Clause, _Citations)], Pairs).

subject_profile(Subject, Profile) :-
    dora_ict_risk_protection_and_detection_profile_for(Subject, Profile).

all_subjects(Subjects) :-
    findall(Subject, dora_ict_risk_protection_and_detection_subject(Subject), Subjects).

subject_resolves_as_expected(Subject) :-
    expected_status(Subject, Expected),
    dora_ict_risk_protection_and_detection_assess(Subject, dora_ict_risk_protection_and_detection_verdict(Status, _Citations)),
    Status = Expected.

subject_answers_once(Subject) :-
    subject_profile(Subject, Profile),
    findall(Verdict, decide_dora_ict_risk_protection_and_detection(Profile, Verdict), Verdicts),
    length(Verdicts, 1),
    findall(Result - Citations, ict_risk_protection_and_detection_duties_required(Profile, Result, Citations), RequiredAnswers),
    length(RequiredAnswers, 1),
    findall(Result - Citations, ict_risk_protection_and_detection_duties_complete(Profile, Result, Citations), CompleteAnswers),
    length(CompleteAnswers, 1),
    findall(Result - Citations, ict_risk_protection_and_detection_duties_outstanding(Profile, Result, Citations), OutstandingAnswers),
    length(OutstandingAnswers, 1),
    findall(Problems, dora_ict_risk_protection_and_detection_input_problems(Profile, Problems), ProblemAnswers),
    length(ProblemAnswers, 1).

subject_status_in_vocabulary(Subject) :-
    subject_profile(Subject, Profile),
    dora_ict_risk_protection_and_detection_status(Profile, Status),
    functor(Status, Name, _),
    dora_ict_risk_protection_and_detection_status_values(StatusValues),
    member(Name, StatusValues).

subject_checklist_cited(Subject) :-
    subject_profile(Subject, Profile),
    dora_ict_risk_protection_and_detection_decision_resolvable(Profile),
    dora_ict_risk_protection_and_detection_checklist(Profile, [FirstItem|OtherItems]),
    maplist(cited_item, [FirstItem|OtherItems]).

cited_item(item(_, _, cite(Key))) :-
    atom(Key).

test(every_subject_has_an_expectation) :-
    all_subjects(Subjects),
    findall(Subject, expected_status(Subject, _), ExpectedSubjects),
    Subjects == ExpectedSubjects,
    length(Subjects, 20).
test(each_subject_resolves_to_its_expected_status) :-
    all_subjects(Subjects),
    maplist(subject_resolves_as_expected, Subjects).
test(each_subject_answers_exactly_once_in_every_query) :-
    all_subjects(Subjects),
    maplist(subject_answers_once, Subjects).
test(each_status_is_in_the_verdict_vocabulary) :-
    all_subjects(Subjects),
    maplist(subject_status_in_vocabulary, Subjects).
test(each_checklist_is_non_empty_and_cited) :-
    all_subjects(Subjects),
    maplist(subject_checklist_cited, Subjects).
test(all_duties_performed_is_complete_with_the_eight_paragraphs) :-
    dora_ict_risk_protection_and_detection_assess(credit_institution_all_duties_performed, dora_ict_risk_protection_and_detection_verdict(complete, Citations)),
    eight_paragraph_citations(Expected),
    same_citation_set(Citations, Expected).
test(one_duty_not_performed_is_incomplete_with_the_eight_paragraphs) :-
    dora_ict_risk_protection_and_detection_assess(credit_institution_patch_policies_not_documented, dora_ict_risk_protection_and_detection_verdict(incomplete, Citations)),
    eight_paragraph_citations(Expected),
    same_citation_set(Citations, Expected).
test(all_duties_performed_has_none_outstanding) :-
    subject_profile(credit_institution_all_duties_performed, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, none_outstanding, Citations),
    eight_paragraph_citations(Expected),
    same_citation_set(Citations, Expected).
test(one_duty_not_performed_is_outstanding_with_its_own_citation) :-
    subject_profile(credit_institution_patch_policies_not_documented, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, outstanding([patch_and_update_policies]), [cite(eu_reg_2022_2554_art_9_4_f)]).
test(a_credit_institution_has_twenty_one_duties_in_duty_order) :-
    subject_profile(credit_institution_all_duties_performed, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, required(Duties), Citations),
    length(Duties, 21),
    Duties = [monitoring_and_control_of_ict_systems, ict_security_tools_policies_and_procedures|_],
    last(Duties, resources_to_monitor_user_activity_anomalies_and_incidents),
    seven_paragraph_citations(Expected),
    same_citation_set(Citations, Expected).
test(a_data_reporting_provider_has_twenty_two_duties) :-
    subject_profile(data_reporting_provider_all_duties_performed, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, required(Duties), Citations),
    length(Duties, 22),
    last(Duties, trade_report_checking_systems),
    eight_paragraph_citations(Expected),
    same_citation_set(Citations, Expected).
test(a_third_party_provider_is_answered_as_another_type) :-
    subject_profile(ict_third_party_service_provider_all_duties_performed, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, required(Duties), _),
    length(Duties, 21).
test(required_asks_the_entity_type) :-
    subject_profile(entity_type_unanswered_trade_report_checking_in_place, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, indeterminate([dora_entity_type]), []).
test(a_provider_without_trade_report_checking_is_incomplete) :-
    dora_ict_risk_protection_and_detection_assess(data_reporting_provider_trade_report_checking_not_in_place, dora_ict_risk_protection_and_detection_verdict(incomplete, _)).
test(a_provider_without_trade_report_checking_has_it_outstanding) :-
    subject_profile(data_reporting_provider_trade_report_checking_not_in_place, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, outstanding([trade_report_checking_systems]), [cite(eu_reg_2022_2554_art_10_4)]).
test(another_type_without_trade_report_checking_is_complete) :-
    dora_ict_risk_protection_and_detection_assess(credit_institution_trade_report_checking_not_in_place, dora_ict_risk_protection_and_detection_verdict(complete, _)).
test(a_provider_with_trade_report_checking_unanswered_is_asked_it) :-
    subject_profile(data_reporting_provider_trade_report_checking_unanswered, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, indeterminate([trade_report_checking_systems_in_place]), []),
    ict_risk_protection_and_detection_duties_outstanding(Profile, indeterminate([trade_report_checking_systems_in_place]), []).
test(an_article_16_1_entity_is_a_simplified_framework_entity_in_every_query) :-
    subject_profile(article_16_1_entity_with_duties_not_performed, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    ict_risk_protection_and_detection_duties_complete(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]),
    ict_risk_protection_and_detection_duties_outstanding(Profile, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
test(an_unanswered_gate_is_asked_first_in_every_query) :-
    subject_profile(article_16_1_status_unanswered, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []),
    ict_risk_protection_and_detection_duties_complete(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []),
    ict_risk_protection_and_detection_duties_outstanding(Profile, indeterminate([financial_entity_is_article_16_1_entity]), []).
test(trigger_and_trade_key_unanswered_asks_the_type) :-
    subject_profile(entity_type_and_trade_report_checking_unanswered, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, indeterminate([dora_entity_type]), []),
    ict_risk_protection_and_detection_duties_outstanding(Profile, indeterminate([dora_entity_type]), []).
test(trigger_unanswered_with_trade_key_true_is_complete) :-
    subject_profile(entity_type_unanswered_trade_report_checking_in_place, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, complete, _),
    ict_risk_protection_and_detection_duties_outstanding(Profile, none_outstanding, _).
test(trigger_is_behind_an_unanswered_always_duty_key) :-
    subject_profile(entity_type_monitoring_and_trade_report_checking_unanswered, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, indeterminate([monitors_and_controls_security_and_functioning_of_ict_systems]), []).
test(outstanding_names_the_trigger_first_in_root_order) :-
    subject_profile(entity_type_monitoring_and_trade_report_checking_unanswered, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, indeterminate([dora_entity_type]), []).
test(trade_key_false_puts_the_trigger_first) :-
    subject_profile(entity_type_and_monitoring_unanswered_trade_report_checking_not_in_place, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, indeterminate([dora_entity_type]), []).
test(an_unsure_judgement_is_referred_with_every_pair_in_root_order) :-
    subject_profile(security_tools_deployment_unsure, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, needs_legal_review(open_textured(deploys_ict_security_tools_policies_and_procedures, cite(eu_reg_2022_2554_art_9_1)), [inputs_relied_on(Pairs)]), []),
    pairs_keys(Pairs, Keys),
    dora_ict_risk_protection_and_detection_profile_keys(Keys),
    member(deploys_ict_security_tools_policies_and_procedures - unsure, Pairs).
test(an_unsure_judgement_is_referred_in_outstanding_too) :-
    subject_profile(security_tools_deployment_unsure_patch_policies_not_documented, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, needs_legal_review(open_textured(deploys_ict_security_tools_policies_and_procedures, cite(eu_reg_2022_2554_art_9_1)), [inputs_relied_on(_)]), []).
test(a_false_duty_decides_before_an_unsure_one) :-
    subject_profile(security_tools_deployment_unsure_patch_policies_not_documented, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, incomplete, _).
test(an_absent_key_is_named_before_an_unsure_judgement) :-
    subject_profile(security_tools_deployment_unsure_anomaly_detection_unanswered, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, indeterminate([anomaly_detection_mechanisms_in_place]), []),
    ict_risk_protection_and_detection_duties_outstanding(Profile, indeterminate([anomaly_detection_mechanisms_in_place]), []).
test(the_referral_context_is_an_accepted_form) :-
    subject_profile(security_tools_deployment_unsure, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, needs_legal_review(open_textured(deploys_ict_security_tools_policies_and_procedures, cite(eu_reg_2022_2554_art_9_1)), Context), []),
    accepted_context(Context, Pairs),
    length(Pairs, 24).
test(a_context_with_a_provenance_item_is_also_accepted) :-
    accepted_context([inputs_relied_on([dora_entity_type - credit_institution]), provenance(complete_after_unsure, [cite(eu_reg_2022_2554_art_9_1)])], Pairs),
    Pairs == [dora_entity_type - credit_institution].
test(a_well_formed_fixture_has_no_input_problem) :-
    subject_profile(credit_institution_all_duties_performed, Profile),
    dora_ict_risk_protection_and_detection_input_problems(Profile, []).
test(an_unsure_gate_is_a_wrong_type) :-
    subject_profile(article_16_1_status_given_as_unsure, Profile),
    dora_ict_risk_protection_and_detection_input_problems(Profile, [wrong_type(financial_entity_is_article_16_1_entity)]),
    ict_risk_protection_and_detection_duties_required(Profile, input_problems([wrong_type(financial_entity_is_article_16_1_entity)]), []).
test(an_unknown_key_is_refused_in_every_query) :-
    subject_profile(unknown_key_given, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, input_problems([unknown_key(colour)]), []),
    ict_risk_protection_and_detection_duties_complete(Profile, input_problems([unknown_key(colour)]), []),
    ict_risk_protection_and_detection_duties_outstanding(Profile, input_problems([unknown_key(colour)]), []).
test(a_repeated_key_is_a_duplicate_and_not_a_wrong_type) :-
    subject_profile(anomaly_detection_given_twice, Profile),
    dora_ict_risk_protection_and_detection_input_problems(Profile, [duplicate_key(anomaly_detection_mechanisms_in_place)]).
test(an_unbound_profile_is_not_an_attribute_list) :-
    dora_ict_risk_protection_and_detection_input_problems(_, [wrong_type(profile)]).
test(an_atom_is_not_an_attribute_list) :-
    ict_risk_protection_and_detection_duties_complete(not_a_profile, input_problems([wrong_type(profile)]), []).
test(what_if_the_patch_policies_are_documented_is_complete) :-
    subject_profile(credit_institution_patch_policies_not_documented, Profile),
    dora_ict_risk_protection_and_detection_what_if(Profile, patch_and_update_policies_documented, true, complete).
test(what_if_the_patch_policies_stay_undocumented_is_incomplete) :-
    subject_profile(credit_institution_patch_policies_not_documented, Profile),
    dora_ict_risk_protection_and_detection_what_if(Profile, patch_and_update_policies_documented, false, incomplete).
test(what_if_a_data_reporting_provider_reads_the_trade_key) :-
    subject_profile(credit_institution_trade_report_checking_not_in_place, Profile),
    dora_ict_risk_protection_and_detection_what_if(Profile, dora_entity_type, data_reporting_service_provider, incomplete).
test(what_if_an_article_16_1_entity) :-
    subject_profile(credit_institution_all_duties_performed, Profile),
    dora_ict_risk_protection_and_detection_what_if(Profile, financial_entity_is_article_16_1_entity, true, simplified_framework_entity).
test(what_if_answers_exactly_once) :-
    subject_profile(credit_institution_all_duties_performed, Profile),
    findall(Status, dora_ict_risk_protection_and_detection_what_if(Profile, monitors_and_controls_security_and_functioning_of_ict_systems, unsure, Status), Statuses),
    length(Statuses, 1).
test(the_profile_key_schema_has_twenty_four_keys) :-
    dora_ict_risk_protection_and_detection_profile_keys(Keys),
    length(Keys, 24),
    Keys = [financial_entity_is_article_16_1_entity, dora_entity_type|_].

test(all_duties_performed_is_not_incomplete, fail) :-
    dora_ict_risk_protection_and_detection_assess(credit_institution_all_duties_performed, dora_ict_risk_protection_and_detection_verdict(incomplete, _)).
test(one_duty_not_performed_is_not_complete, fail) :-
    dora_ict_risk_protection_and_detection_assess(credit_institution_patch_policies_not_documented, dora_ict_risk_protection_and_detection_verdict(complete, _)).
test(one_duty_not_performed_is_not_none_outstanding, fail) :-
    subject_profile(credit_institution_patch_policies_not_documented, Profile),
    ict_risk_protection_and_detection_duties_outstanding(Profile, none_outstanding, _).
test(a_credit_institution_is_not_required_to_check_trade_reports, fail) :-
    subject_profile(credit_institution_all_duties_performed, Profile),
    ict_risk_protection_and_detection_duties_required(Profile, required(Duties), _),
    member(trade_report_checking_systems, Duties).
test(another_type_without_trade_report_checking_is_not_incomplete, fail) :-
    dora_ict_risk_protection_and_detection_assess(credit_institution_trade_report_checking_not_in_place, dora_ict_risk_protection_and_detection_verdict(incomplete, _)).
test(another_type_unsure_of_trade_report_checking_is_not_referred, fail) :-
    dora_ict_risk_protection_and_detection_assess(credit_institution_trade_report_checking_unsure, dora_ict_risk_protection_and_detection_verdict(needs_legal_review(_, _), _)).
test(an_article_16_1_entity_is_not_incomplete, fail) :-
    subject_profile(article_16_1_entity_with_duties_not_performed, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, incomplete, _).
test(trigger_is_not_named_while_an_always_duty_key_is_unanswered, fail) :-
    subject_profile(entity_type_monitoring_and_trade_report_checking_unanswered, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, indeterminate([dora_entity_type]), _).
test(a_false_duty_beside_an_unsure_one_is_not_referred, fail) :-
    subject_profile(security_tools_deployment_unsure_patch_policies_not_documented, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, needs_legal_review(_, _), _).
test(this_order_leaves_the_unscored_provenance_item_out, fail) :-
    subject_profile(security_tools_deployment_unsure, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, needs_legal_review(_, [inputs_relied_on(_), provenance(_, _)]), _).
test(a_provenance_item_alone_is_not_an_accepted_context, fail) :-
    accepted_context([provenance(complete_after_unsure, [])], _).
test(an_unknown_key_is_not_complete, fail) :-
    subject_profile(unknown_key_given, Profile),
    ict_risk_protection_and_detection_duties_complete(Profile, complete, _).
test(what_if_the_patch_policies_stay_undocumented_is_not_complete, fail) :-
    subject_profile(credit_institution_patch_policies_not_documented, Profile),
    dora_ict_risk_protection_and_detection_what_if(Profile, patch_and_update_policies_documented, false, complete).

cp_test_names([every_subject_has_an_expectation, each_subject_resolves_to_its_expected_status, each_subject_answers_exactly_once_in_every_query, each_status_is_in_the_verdict_vocabulary, each_checklist_is_non_empty_and_cited, all_duties_performed_is_complete_with_the_eight_paragraphs, one_duty_not_performed_is_incomplete_with_the_eight_paragraphs, all_duties_performed_has_none_outstanding, one_duty_not_performed_is_outstanding_with_its_own_citation, a_credit_institution_has_twenty_one_duties_in_duty_order, a_data_reporting_provider_has_twenty_two_duties, a_third_party_provider_is_answered_as_another_type, required_asks_the_entity_type, a_provider_without_trade_report_checking_is_incomplete, a_provider_without_trade_report_checking_has_it_outstanding, another_type_without_trade_report_checking_is_complete, a_provider_with_trade_report_checking_unanswered_is_asked_it, an_article_16_1_entity_is_a_simplified_framework_entity_in_every_query, an_unanswered_gate_is_asked_first_in_every_query, trigger_and_trade_key_unanswered_asks_the_type, trigger_unanswered_with_trade_key_true_is_complete, trigger_is_behind_an_unanswered_always_duty_key, outstanding_names_the_trigger_first_in_root_order, trade_key_false_puts_the_trigger_first, an_unsure_judgement_is_referred_with_every_pair_in_root_order, an_unsure_judgement_is_referred_in_outstanding_too, a_false_duty_decides_before_an_unsure_one, an_absent_key_is_named_before_an_unsure_judgement, the_referral_context_is_an_accepted_form, a_context_with_a_provenance_item_is_also_accepted, a_well_formed_fixture_has_no_input_problem, an_unsure_gate_is_a_wrong_type, an_unknown_key_is_refused_in_every_query, a_repeated_key_is_a_duplicate_and_not_a_wrong_type, an_unbound_profile_is_not_an_attribute_list, an_atom_is_not_an_attribute_list, what_if_the_patch_policies_are_documented_is_complete, what_if_the_patch_policies_stay_undocumented_is_incomplete, what_if_a_data_reporting_provider_reads_the_trade_key, what_if_an_article_16_1_entity, what_if_answers_exactly_once, the_profile_key_schema_has_twenty_four_keys]).
cp_test_fail_names([all_duties_performed_is_not_incomplete, one_duty_not_performed_is_not_complete, one_duty_not_performed_is_not_none_outstanding, a_credit_institution_is_not_required_to_check_trade_reports, another_type_without_trade_report_checking_is_not_incomplete, another_type_unsure_of_trade_report_checking_is_not_referred, an_article_16_1_entity_is_not_incomplete, trigger_is_not_named_while_an_always_duty_key_is_unanswered, a_false_duty_beside_an_unsure_one_is_not_referred, this_order_leaves_the_unscored_provenance_item_out, a_provenance_item_alone_is_not_an_accepted_context, an_unknown_key_is_not_complete, what_if_the_patch_policies_stay_undocumented_is_not_complete]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
