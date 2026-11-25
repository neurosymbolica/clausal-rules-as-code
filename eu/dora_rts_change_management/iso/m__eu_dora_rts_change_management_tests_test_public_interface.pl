% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_change_management_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_rts_change_management_dora_rts_change_management, [decide_dora_rts_change_management/2, dora_rts_change_management_status/2, dora_rts_change_management_checklist/2, dora_rts_change_management_decision_resolvable/1, dora_rts_change_management_status_values/1, ict_change_management_duties_required/3, ict_change_management_duties_complete/3, ict_change_management_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_change_management_fixtures, [dora_rts_change_management_subject/1, dora_rts_change_management_profile_for/2, dora_rts_change_management_assess/2]).

expected_verdict(article_16_1_entity, simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
expected_verdict(article_16_1_status_unstated, indeterminate([financial_entity_is_article_16_1_entity]), []).
expected_verdict(credit_institution_all_elements_performed, complete, [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]).
expected_verdict(credit_institution_verification_not_performed, incomplete, [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]).
expected_verdict(central_counterparty_tested_with_parties, complete, [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]).
expected_verdict(central_counterparty_parties_not_involved, incomplete, [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]).
expected_verdict(central_securities_depository_without_significant_changes, complete, [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]).
expected_verdict(central_securities_depository_involvement_unstated, indeterminate([users_service_providers_and_other_parties_involved_in_testing]), []).
expected_verdict(credit_institution_verification_unsure, needs_legal_review(open_textured(change_procedures_verify_whether_ict_security_requirements_met, cite(eu_reg_2024_1774_art_17_1)), [inputs_relied_on([financial_entity_is_article_16_1_entity - false, dora_entity_type - credit_institution, change_procedures_verify_whether_ict_security_requirements_met - unsure, change_procedures_ensure_independence_of_approving_functions - true, change_roles_described_for_specifying_and_planning - true, change_roles_described_for_designing_adequate_transition - true, change_roles_described_for_controlled_testing_and_finalisation - true, change_roles_described_for_effective_quality_assurance - true, change_purpose_and_scope_documented_and_communicated - true, change_implementation_timeline_documented_and_communicated - true, change_expected_outcomes_documented_and_communicated - true, change_fall_back_procedures_and_responsibilities_identified - true, emergency_change_procedures_protocols_and_tools_provide_adequate_safeguards - true, emergency_changes_documented_reevaluated_assessed_and_approved_after_implementation - true, change_impact_on_ict_security_measures_identified_and_assessed - true])]), []).
expected_verdict(entity_type_unstated, indeterminate([dora_entity_type]), []).
expected_verdict(investment_firm_trigger_unstated, complete, [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]).
expected_verdict(profile_with_unknown_key, input_problems([unknown_key(colour)]), []).
expected_verdict(article_16_1_status_unsure, input_problems([wrong_type(financial_entity_is_article_16_1_entity)]), []).
expected_verdict(duplicated_gate_key, input_problems([duplicate_key(financial_entity_is_article_16_1_entity)]), []).

resolves_as_expected(Subject) :-
    expected_verdict(Subject, Status, Citations),
    findall(Verdict, dora_rts_change_management_assess(Subject, Verdict), Verdicts),
    Verdicts == [dora_rts_change_management_verdict(Status, Citations)].

has_expected_verdict(Subject) :-
    expected_verdict(Subject, _, _).

is_registered(Subject) :-
    dora_rts_change_management_subject(Subject).

status_of(Subject, Status) :-
    dora_rts_change_management_profile_for(Subject, Profile),
    dora_rts_change_management_status(Profile, Status).

checklist_is_cited(Subject) :-
    dora_rts_change_management_profile_for(Subject, Profile),
    dora_rts_change_management_checklist(Profile, [FirstItem|OtherItems]),
    maplist(item_is_cited, [FirstItem|OtherItems]).

item_is_cited(item(_, _, cite(_))).

resolvable(Subject) :-
    dora_rts_change_management_profile_for(Subject, Profile),
    dora_rts_change_management_decision_resolvable(Profile).

expected_subjects(Subjects) :-
    findall(Subject, expected_verdict(Subject, _, _), Subjects).

article_17_1_duties([verification_of_ict_security_requirements, independence_of_change_approval_functions, roles_for_specifying_and_planning_changes, roles_for_designing_the_transition, roles_for_controlled_testing_and_finalisation, roles_for_quality_assurance, documentation_of_purpose_and_scope_of_change, documentation_of_implementation_timeline, documentation_of_expected_outcomes, fall_back_procedures_and_responsibilities, management_of_emergency_changes, review_of_emergency_changes_after_implementation, impact_of_change_on_ict_security_measures]).

test(every_subject_has_an_expected_verdict) :-
    findall(Subject, dora_rts_change_management_subject(Subject), Subjects),
    length(Subjects, 14),
    maplist(has_expected_verdict, Subjects).
test(every_expected_verdict_names_a_registered_subject) :-
    expected_subjects(Subjects),
    maplist(is_registered, Subjects).
test(every_subject_resolves_to_its_expected_verdict) :-
    expected_subjects(Subjects),
    maplist(resolves_as_expected, Subjects).
test(every_checklist_is_non_empty_and_cited) :-
    expected_subjects(Subjects),
    maplist(checklist_is_cited, Subjects).
test(every_subject_is_resolvable) :-
    expected_subjects(Subjects),
    maplist(resolvable, Subjects).
test(final_statuses_are_in_the_status_vocabulary) :-
    dora_rts_change_management_status_values(StatusValues),
    status_of(credit_institution_all_elements_performed, Complete),
    status_of(credit_institution_verification_not_performed, Incomplete),
    status_of(article_16_1_entity, Simplified),
    member(Complete, StatusValues),
    member(Incomplete, StatusValues),
    member(Simplified, StatusValues).
test(article_16_1_entity_is_a_simplified_framework_entity) :-
    status_of(article_16_1_entity, simplified_framework_entity).
test(unstated_gate_is_asked_first) :-
    status_of(article_16_1_status_unstated, indeterminate([financial_entity_is_article_16_1_entity])).
test(all_elements_performed_is_complete) :-
    status_of(credit_institution_all_elements_performed, complete).
test(one_element_not_performed_is_incomplete) :-
    status_of(credit_institution_verification_not_performed, incomplete).
test(the_failing_element_is_unmet_in_the_checklist) :-
    dora_rts_change_management_profile_for(credit_institution_verification_not_performed, Profile),
    dora_rts_change_management_checklist(Profile, Items),
    member(item(verification_of_ict_security_requirements, unmet(not_performed), cite(eu_reg_2024_1774_art_17_1)), Items).
test(the_performed_element_is_met_in_the_checklist) :-
    dora_rts_change_management_profile_for(credit_institution_all_elements_performed, Profile),
    dora_rts_change_management_checklist(Profile, Items),
    length(Items, 16),
    member(item(verification_of_ict_security_requirements, met, cite(eu_reg_2024_1774_art_17_1)), Items).
test(central_counterparty_tested_with_parties_is_complete) :-
    status_of(central_counterparty_tested_with_parties, complete).
test(central_counterparty_parties_not_involved_is_incomplete) :-
    status_of(central_counterparty_parties_not_involved, incomplete).
test(no_significant_changes_is_complete) :-
    status_of(central_securities_depository_without_significant_changes, complete).
test(significant_changes_with_involvement_unstated_names_the_involvement_key) :-
    status_of(central_securities_depository_involvement_unstated, indeterminate([users_service_providers_and_other_parties_involved_in_testing])).
test(an_unsure_element_goes_to_a_lawyer) :-
    status_of(credit_institution_verification_unsure, needs_legal_review(open_textured(Key, Citation), _)),
    Key == change_procedures_verify_whether_ict_security_requirements_met,
    Citation == cite(eu_reg_2024_1774_art_17_1).
test(unstated_type_is_asked) :-
    status_of(entity_type_unstated, indeterminate([dora_entity_type])).
test(investment_firm_needs_no_trigger) :-
    status_of(investment_firm_trigger_unstated, complete).
test(an_unknown_key_is_an_input_problem) :-
    status_of(profile_with_unknown_key, input_problems([unknown_key(colour)])).
test(an_unsure_gate_is_wrong_type) :-
    status_of(article_16_1_status_unsure, input_problems([wrong_type(financial_entity_is_article_16_1_entity)])).
test(a_duplicated_gate_is_a_duplicate_key_only) :-
    status_of(duplicated_gate_key, input_problems([duplicate_key(financial_entity_is_article_16_1_entity)])).
test(verdict_and_status_agree) :-
    dora_rts_change_management_profile_for(central_counterparty_parties_not_involved, Profile),
    decide_dora_rts_change_management(Profile, dora_rts_change_management_verdict(Status, Citations)),
    dora_rts_change_management_status(Profile, Status),
    Status == incomplete,
    Citations == [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)].
test(required_lists_thirteen_duties_for_a_credit_institution) :-
    dora_rts_change_management_profile_for(credit_institution_all_elements_performed, Profile),
    findall(Result - Citations, ict_change_management_duties_required(Profile, Result, Citations), Answers),
    article_17_1_duties(Duties),
    Answers == [required(Duties) - [cite(eu_reg_2024_1774_art_17_1)]].
test(required_adds_testing_and_parties_for_a_central_counterparty) :-
    dora_rts_change_management_profile_for(central_counterparty_tested_with_parties, Profile),
    findall(Result - Citations, ict_change_management_duties_required(Profile, Result, Citations), Answers),
    article_17_1_duties(ElementDuties),
    append(ElementDuties, [stringent_testing_after_significant_changes, central_counterparty_involvement_of_parties_in_testing], Duties),
    Answers == [required(Duties) - [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]].
test(required_without_significant_changes_lists_thirteen_duties) :-
    dora_rts_change_management_profile_for(central_securities_depository_without_significant_changes, Profile),
    ict_change_management_duties_required(Profile, required(Duties), Citations),
    length(Duties, 13),
    Citations == [cite(eu_reg_2024_1774_art_17_1)].
test(required_for_an_article_16_1_entity_is_a_simplified_framework_entity) :-
    dora_rts_change_management_profile_for(article_16_1_entity, Profile),
    findall(Result - Citations, ict_change_management_duties_required(Profile, Result, Citations), Answers),
    Answers == [simplified_framework_entity - [cite(eu_reg_2022_2554_art_16_1)]].
test(required_asks_for_the_gate_first) :-
    dora_rts_change_management_profile_for(article_16_1_status_unstated, Profile),
    findall(Result - Citations, ict_change_management_duties_required(Profile, Result, Citations), Answers),
    Answers == [indeterminate([financial_entity_is_article_16_1_entity]) - []].
test(required_asks_for_the_type_while_the_trigger_is_unstated) :-
    dora_rts_change_management_profile_for(entity_type_unstated, Profile),
    findall(Result - Citations, ict_change_management_duties_required(Profile, Result, Citations), Answers),
    Answers == [indeterminate([dora_entity_type]) - []].
test(required_asks_a_central_counterparty_for_the_trigger) :-
    findall(Result - Citations, ict_change_management_duties_required([attribute(financial_entity_is_article_16_1_entity, false), attribute(dora_entity_type, central_counterparty)], Result, Citations), Answers),
    Answers == [indeterminate([significant_changes_made_to_ict_systems]) - []].
test(required_does_not_ask_an_investment_firm_for_the_trigger) :-
    dora_rts_change_management_profile_for(investment_firm_trigger_unstated, Profile),
    ict_change_management_duties_required(Profile, required(Duties), _),
    length(Duties, 13).
test(required_refuses_a_profile_with_input_problems) :-
    dora_rts_change_management_profile_for(profile_with_unknown_key, Profile),
    findall(Result - Citations, ict_change_management_duties_required(Profile, Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(complete_holds_when_every_duty_is_performed) :-
    dora_rts_change_management_profile_for(central_counterparty_tested_with_parties, Profile),
    findall(Result - Citations, ict_change_management_duties_complete(Profile, Result, Citations), Answers),
    Answers == [complete - [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]].
test(complete_is_incomplete_when_a_duty_fails) :-
    dora_rts_change_management_profile_for(central_counterparty_parties_not_involved, Profile),
    findall(Result - Citations, ict_change_management_duties_complete(Profile, Result, Citations), Answers),
    Answers == [incomplete - [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]].
test(complete_answers_simplified_framework_entity_for_the_gate) :-
    dora_rts_change_management_profile_for(article_16_1_entity, Profile),
    findall(Result - Citations, ict_change_management_duties_complete(Profile, Result, Citations), Answers),
    Answers == [simplified_framework_entity - [cite(eu_reg_2022_2554_art_16_1)]].
test(complete_names_the_missing_involvement_key) :-
    dora_rts_change_management_profile_for(central_securities_depository_involvement_unstated, Profile),
    findall(Result - Citations, ict_change_management_duties_complete(Profile, Result, Citations), Answers),
    Answers == [indeterminate([users_service_providers_and_other_parties_involved_in_testing]) - []].
test(complete_refers_an_unsure_element) :-
    dora_rts_change_management_profile_for(credit_institution_verification_unsure, Profile),
    findall(Result - Citations, ict_change_management_duties_complete(Profile, Result, Citations), Answers),
    Answers = [needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(_)]) - []],
    Key == change_procedures_verify_whether_ict_security_requirements_met,
    Citation == cite(eu_reg_2024_1774_art_17_1).
test(complete_refuses_a_duplicate_gate) :-
    dora_rts_change_management_profile_for(duplicated_gate_key, Profile),
    findall(Result - Citations, ict_change_management_duties_complete(Profile, Result, Citations), Answers),
    Answers == [input_problems([duplicate_key(financial_entity_is_article_16_1_entity)]) - []].
test(outstanding_lists_the_failing_element) :-
    dora_rts_change_management_profile_for(credit_institution_verification_not_performed, Profile),
    findall(Result - Citations, ict_change_management_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [outstanding([verification_of_ict_security_requirements]) - [cite(eu_reg_2024_1774_art_17_1)]].
test(outstanding_lists_the_failing_involvement_duty) :-
    dora_rts_change_management_profile_for(central_counterparty_parties_not_involved, Profile),
    findall(Result - Citations, ict_change_management_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [outstanding([central_counterparty_involvement_of_parties_in_testing]) - [cite(eu_reg_2024_1774_art_17_2)]].
test(outstanding_is_none_outstanding_when_every_duty_is_performed) :-
    dora_rts_change_management_profile_for(central_counterparty_tested_with_parties, Profile),
    findall(Result - Citations, ict_change_management_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [none_outstanding - [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]].
test(outstanding_answers_simplified_framework_entity_for_the_gate) :-
    dora_rts_change_management_profile_for(article_16_1_entity, Profile),
    findall(Result - Citations, ict_change_management_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [simplified_framework_entity - [cite(eu_reg_2022_2554_art_16_1)]].
test(outstanding_names_the_missing_type) :-
    dora_rts_change_management_profile_for(entity_type_unstated, Profile),
    findall(Result - Citations, ict_change_management_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [indeterminate([dora_entity_type]) - []].
test(outstanding_refers_an_unsure_element) :-
    dora_rts_change_management_profile_for(credit_institution_verification_unsure, Profile),
    findall(Result - Citations, ict_change_management_duties_outstanding(Profile, Result, Citations), Answers),
    Answers = [needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(_)]) - []],
    Key == change_procedures_verify_whether_ict_security_requirements_met,
    Citation == cite(eu_reg_2024_1774_art_17_1).
test(outstanding_refuses_an_unsure_gate) :-
    dora_rts_change_management_profile_for(article_16_1_status_unsure, Profile),
    findall(Result - Citations, ict_change_management_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(financial_entity_is_article_16_1_entity)]) - []].
test(a_referral_context_may_carry_a_provenance_item) :-
    status_of(credit_institution_verification_unsure, needs_legal_review(Reason, [inputs_relied_on(Pairs)])),
    Extended = [inputs_relied_on(Pairs), provenance(complete_missing, [cite(eu_reg_2024_1774_art_17_1)])],
    Extended = [inputs_relied_on(_), provenance(Clause, ClauseCitations)],
    Clause == complete_missing,
    ClauseCitations == [cite(eu_reg_2024_1774_art_17_1)],
    Reason = open_textured(_, cite(_)).

test(article_16_1_entity_is_not_incomplete_although_elements_are_false, fail) :-
    status_of(article_16_1_entity, incomplete).
test(unstated_gate_is_not_complete, fail) :-
    status_of(article_16_1_status_unstated, complete).
test(all_elements_performed_is_not_incomplete, fail) :-
    status_of(credit_institution_all_elements_performed, incomplete).
test(one_element_not_performed_is_not_complete, fail) :-
    status_of(credit_institution_verification_not_performed, complete).
test(central_counterparty_tested_with_parties_is_not_incomplete, fail) :-
    status_of(central_counterparty_tested_with_parties, incomplete).
test(central_counterparty_parties_not_involved_is_not_complete, fail) :-
    status_of(central_counterparty_parties_not_involved, complete).
test(no_significant_changes_is_not_indeterminate, fail) :-
    status_of(central_securities_depository_without_significant_changes, indeterminate(_)).
test(significant_changes_with_involvement_unstated_is_not_complete, fail) :-
    status_of(central_securities_depository_involvement_unstated, complete).
test(an_unsure_element_is_not_complete, fail) :-
    status_of(credit_institution_verification_unsure, complete).
test(unstated_type_is_not_complete, fail) :-
    status_of(entity_type_unstated, complete).
test(investment_firm_is_not_asked_for_the_trigger, fail) :-
    status_of(investment_firm_trigger_unstated, indeterminate(_)).
test(an_unknown_key_is_not_complete, fail) :-
    status_of(profile_with_unknown_key, complete).
test(an_unsure_gate_is_not_a_simplified_framework_entity, fail) :-
    status_of(article_16_1_status_unsure, simplified_framework_entity).
test(a_duplicated_gate_is_not_wrong_type, fail) :-
    status_of(duplicated_gate_key, input_problems([wrong_type(_)|_])).
test(required_for_a_credit_institution_has_no_testing_duty, fail) :-
    dora_rts_change_management_profile_for(credit_institution_all_elements_performed, Profile),
    ict_change_management_duties_required(Profile, required(Duties), _),
    member(stringent_testing_after_significant_changes, Duties).

cp_test_names([every_subject_has_an_expected_verdict, every_expected_verdict_names_a_registered_subject, every_subject_resolves_to_its_expected_verdict, every_checklist_is_non_empty_and_cited, every_subject_is_resolvable, final_statuses_are_in_the_status_vocabulary, article_16_1_entity_is_a_simplified_framework_entity, unstated_gate_is_asked_first, all_elements_performed_is_complete, one_element_not_performed_is_incomplete, the_failing_element_is_unmet_in_the_checklist, the_performed_element_is_met_in_the_checklist, central_counterparty_tested_with_parties_is_complete, central_counterparty_parties_not_involved_is_incomplete, no_significant_changes_is_complete, significant_changes_with_involvement_unstated_names_the_involvement_key, an_unsure_element_goes_to_a_lawyer, unstated_type_is_asked, investment_firm_needs_no_trigger, an_unknown_key_is_an_input_problem, an_unsure_gate_is_wrong_type, a_duplicated_gate_is_a_duplicate_key_only, verdict_and_status_agree, required_lists_thirteen_duties_for_a_credit_institution, required_adds_testing_and_parties_for_a_central_counterparty, required_without_significant_changes_lists_thirteen_duties, required_for_an_article_16_1_entity_is_a_simplified_framework_entity, required_asks_for_the_gate_first, required_asks_for_the_type_while_the_trigger_is_unstated, required_asks_a_central_counterparty_for_the_trigger, required_does_not_ask_an_investment_firm_for_the_trigger, required_refuses_a_profile_with_input_problems, complete_holds_when_every_duty_is_performed, complete_is_incomplete_when_a_duty_fails, complete_answers_simplified_framework_entity_for_the_gate, complete_names_the_missing_involvement_key, complete_refers_an_unsure_element, complete_refuses_a_duplicate_gate, outstanding_lists_the_failing_element, outstanding_lists_the_failing_involvement_duty, outstanding_is_none_outstanding_when_every_duty_is_performed, outstanding_answers_simplified_framework_entity_for_the_gate, outstanding_names_the_missing_type, outstanding_refers_an_unsure_element, outstanding_refuses_an_unsure_gate, a_referral_context_may_carry_a_provenance_item]).
cp_test_fail_names([article_16_1_entity_is_not_incomplete_although_elements_are_false, unstated_gate_is_not_complete, all_elements_performed_is_not_incomplete, one_element_not_performed_is_not_complete, central_counterparty_tested_with_parties_is_not_incomplete, central_counterparty_parties_not_involved_is_not_complete, no_significant_changes_is_not_indeterminate, significant_changes_with_involvement_unstated_is_not_complete, an_unsure_element_is_not_complete, unstated_type_is_not_complete, investment_firm_is_not_asked_for_the_trigger, an_unknown_key_is_not_complete, an_unsure_gate_is_not_a_simplified_framework_entity, a_duplicated_gate_is_not_wrong_type, required_for_a_credit_institution_has_no_testing_duty]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
