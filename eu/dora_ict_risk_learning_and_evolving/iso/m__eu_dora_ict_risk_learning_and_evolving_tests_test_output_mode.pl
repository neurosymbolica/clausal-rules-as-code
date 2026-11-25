% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_risk_learning_and_evolving_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_dora_ict_risk_learning_and_evolving, [ict_risk_learning_and_evolving_duties_required/3, ict_risk_learning_and_evolving_duties_complete/3, ict_risk_learning_and_evolving_duties_outstanding/3, decide_dora_ict_risk_learning_and_evolving/2, dora_ict_risk_learning_and_evolving_status/2, dora_ict_risk_learning_and_evolving_checklist/2]).
:- use_module(m__eu_dora_ict_risk_learning_and_evolving_fixtures, [dora_ict_risk_learning_and_evolving_subject/1, dora_ict_risk_learning_and_evolving_profile_for/2]).

expected_status(article_16_1_entity_simplified_framework, simplified_framework_entity).
expected_status(gate_unanswered, indeterminate([financial_entity_is_article_16_1_entity])).
expected_status(non_microenterprise_incident_request_all_performed, complete).
expected_status(communication_after_request_not_performed, incomplete).
expected_status(microenterprise_communication_not_performed, complete).
expected_status(incident_without_request_communication_unanswered, complete).
expected_status(incident_with_request_communication_unanswered, indeterminate([post_incident_review_changes_communicated_to_competent_authorities])).
expected_status(microenterprise_without_incident_all_performed, complete).
expected_status(microenterprise_yearly_report_not_performed, incomplete).
expected_status(size_class_unanswered_all_performed, complete).
expected_status(size_class_unanswered_technology_monitoring_not_performed, indeterminate([financial_entity_is_microenterprise])).
expected_status(capabilities_judgement_unsure, needs_legal_review(open_textured(capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information, cite(eu_reg_2022_2554_art_13_1)), [inputs_relied_on(_Pairs)])).
expected_status(capabilities_judgement_unsure_yearly_report_not_performed, incomplete).
expected_status(unknown_key_given, input_problems([unknown_key(colour)])).
expected_status(fact_key_given_unsure, input_problems([wrong_type(financial_entity_is_microenterprise)])).
expected_status(gate_key_given_twice, input_problems([duplicate_key(financial_entity_is_article_16_1_entity)])).

reads_out_expected(Subject) :-
    expected_status(Subject, ExpectedStatus),
    dora_ict_risk_learning_and_evolving_profile_for(Subject, Profile),
    findall(Status, dora_ict_risk_learning_and_evolving_status(Profile, Status), [FoundStatus]),
    subsumes_term(ExpectedStatus, FoundStatus).

test(every_subject_has_an_expectation) :-
    findall(Subject, dora_ict_risk_learning_and_evolving_subject(Subject), Subjects),
    findall(Subject, expected_status(Subject, _), ExpectedSubjects),
    clausal_msort(Subjects, SortedSubjects),
    clausal_msort(ExpectedSubjects, SortedSubjects).
test(every_subject_reads_out_its_expected_status) :-
    findall(Subject, expected_status(Subject, _), Subjects),
    maplist(reads_out_expected, Subjects).
test(a_final_verdict_carries_citations) :-
    dora_ict_risk_learning_and_evolving_profile_for(non_microenterprise_incident_request_all_performed, Profile),
    decide_dora_ict_risk_learning_and_evolving(Profile, dora_ict_risk_learning_and_evolving_verdict(complete, [_FirstCitation|_OtherCitations])).
test(a_status_compound_carries_no_citation) :-
    dora_ict_risk_learning_and_evolving_profile_for(gate_unanswered, Profile),
    decide_dora_ict_risk_learning_and_evolving(Profile, dora_ict_risk_learning_and_evolving_verdict(_Status, Citations)),
    Citations == [].
test(required_reads_out_the_microenterprise_list_in_duty_order) :-
    dora_ict_risk_learning_and_evolving_profile_for(microenterprise_without_incident_all_performed, Profile),
    findall(Result - Citations, ict_risk_learning_and_evolving_duties_required(Profile, Result, Citations), [required(Duties) - RequiredCitations]),
    Duties == [threat_and_incident_information_capability, lessons_incorporated_into_ict_risk_assessment, findings_basis_for_framework_reviews, monitoring_of_resilience_strategy_effectiveness, mapping_of_ict_risk_evolution, analysis_of_ict_related_incidents, enhancement_of_cyber_maturity, yearly_report_to_management_body, compulsory_awareness_and_training_modules, training_for_all_staff_commensurate_to_remit, third_party_providers_in_training],
    clausal_msort(RequiredCitations, SortedCitations),
    SortedCitations == [cite(eu_reg_2022_2554_art_13_1), cite(eu_reg_2022_2554_art_13_3), cite(eu_reg_2022_2554_art_13_4), cite(eu_reg_2022_2554_art_13_5), cite(eu_reg_2022_2554_art_13_6)].
test(required_without_request_omits_only_the_communication) :-
    dora_ict_risk_learning_and_evolving_profile_for(incident_without_request_communication_unanswered, Profile),
    ict_risk_learning_and_evolving_duties_required(Profile, required(Duties), _),
    length(Duties, 19),
    member(post_incident_reviews, Duties),
    member(monitoring_of_technological_developments, Duties).
test(required_asks_the_size_class_first) :-
    dora_ict_risk_learning_and_evolving_profile_for(size_class_unanswered_all_performed, Profile),
    ict_risk_learning_and_evolving_duties_required(Profile, Result, Citations),
    Result == indeterminate([financial_entity_is_microenterprise]),
    Citations == [].
test(outstanding_reads_out_the_yearly_report) :-
    dora_ict_risk_learning_and_evolving_profile_for(microenterprise_yearly_report_not_performed, Profile),
    findall(Result - Citations, ict_risk_learning_and_evolving_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [outstanding([yearly_report_to_management_body]) - [cite(eu_reg_2022_2554_art_13_5)]].
test(referral_pairs_are_every_present_pair_in_contract_order) :-
    dora_ict_risk_learning_and_evolving_profile_for(capabilities_judgement_unsure, Profile),
    ict_risk_learning_and_evolving_duties_complete(Profile, needs_legal_review(Reason, [inputs_relied_on(Pairs)]), []),
    Reason == open_textured(capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information, cite(eu_reg_2022_2554_art_13_1)),
    length(Pairs, 23),
    Pairs = [financial_entity_is_article_16_1_entity - false, financial_entity_is_microenterprise - true, major_ict_related_incident_disrupted_core_activities - false, FourthPair|_],
    FourthPair == capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information - unsure.
test(outstanding_refers_the_unsure_key_after_a_false_one) :-
    dora_ict_risk_learning_and_evolving_profile_for(capabilities_judgement_unsure_yearly_report_not_performed, Profile),
    ict_risk_learning_and_evolving_duties_outstanding(Profile, needs_legal_review(open_textured(ReferredKey, _Citation), _Context), []),
    ReferredKey == capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information.
test(checklist_reads_out_one_cited_item_per_duty) :-
    dora_ict_risk_learning_and_evolving_profile_for(communication_after_request_not_performed, Profile),
    dora_ict_risk_learning_and_evolving_checklist(Profile, Items),
    length(Items, 20),
    member(item(communication_of_post_incident_changes, unmet(not_performed), cite(eu_reg_2022_2554_art_13_2)), Items),
    member(item(review_of_forensic_analysis, met, cite(eu_reg_2022_2554_art_13_2_b)), Items).

test(required_without_request_has_no_communication, fail) :-
    dora_ict_risk_learning_and_evolving_profile_for(incident_without_request_communication_unanswered, Profile),
    ict_risk_learning_and_evolving_duties_required(Profile, required(Duties), _),
    member(communication_of_post_incident_changes, Duties).

cp_test_names([every_subject_has_an_expectation, every_subject_reads_out_its_expected_status, a_final_verdict_carries_citations, a_status_compound_carries_no_citation, required_reads_out_the_microenterprise_list_in_duty_order, required_without_request_omits_only_the_communication, required_asks_the_size_class_first, outstanding_reads_out_the_yearly_report, referral_pairs_are_every_present_pair_in_contract_order, outstanding_refers_the_unsure_key_after_a_false_one, checklist_reads_out_one_cited_item_per_duty]).
cp_test_fail_names([required_without_request_has_no_communication]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
