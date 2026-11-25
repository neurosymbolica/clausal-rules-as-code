% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_physical_hr_identity_and_access_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2, clausal_msort/2]).
:- use_module(m__eu_dora_rts_physical_hr_identity_and_access_dora_rts_physical_hr_identity_and_access, [physical_hr_identity_and_access_duties_required/3, physical_hr_identity_and_access_duties_complete/3, physical_hr_identity_and_access_duties_outstanding/3, decide_dora_rts_physical_hr_identity_and_access/2, dora_rts_physical_hr_identity_and_access_status/2, dora_rts_physical_hr_identity_and_access_checklist/2, dora_rts_physical_hr_identity_and_access_decision_resolvable/1, dora_rts_physical_hr_identity_and_access_status_values/1]).
:- use_module(m__eu_dora_rts_physical_hr_identity_and_access_kernel, [dora_rts_physical_hr_identity_and_access_input_problems/2]).
:- use_module(m__eu_dora_rts_physical_hr_identity_and_access_fixtures, [dora_rts_physical_hr_identity_and_access_subject/1, dora_rts_physical_hr_identity_and_access_profile_for/2, dora_rts_physical_hr_identity_and_access_assess/2]).

subject_status(Subject, Status) :-
    dora_rts_physical_hr_identity_and_access_profile_for(Subject, Profile),
    dora_rts_physical_hr_identity_and_access_status(Profile, Status).

test(an_article_16_1_entity_follows_the_simplified_framework) :-
    dora_rts_physical_hr_identity_and_access_assess(article_16_1_entity, dora_rts_physical_hr_identity_and_access_verdict(simplified_framework_entity, Citations)),
    Citations == [cite(eu_reg_2022_2554_art_16_1)].
test(all_duties_performed_is_complete) :-
    dora_rts_physical_hr_identity_and_access_assess(all_duties_performed, dora_rts_physical_hr_identity_and_access_verdict(complete, Citations)),
    clausal_msort(Citations, [cite(eu_reg_2024_1774_art_18_1), cite(eu_reg_2024_1774_art_18_2), cite(eu_reg_2024_1774_art_19), cite(eu_reg_2024_1774_art_20_1), cite(eu_reg_2024_1774_art_20_2), cite(eu_reg_2024_1774_art_21)]).
test(a_missing_gate_is_asked_first) :-
    subject_status(gate_absent, indeterminate([financial_entity_is_article_16_1_entity])).
test(one_duty_not_performed_is_incomplete) :-
    subject_status(one_duty_not_performed, incomplete).
test(the_first_absent_duty_is_asked) :-
    subject_status(first_absent_duty, indeterminate([dedicated_accounts_used_for_administrative_tasks_where_possible])).
test(an_unsure_duty_goes_to_a_lawyer) :-
    subject_status(unsure_referral, needs_legal_review(open_textured(access_control_policy_contains_segregation_of_duties, cite(eu_reg_2024_1774_art_21_b)), [inputs_relied_on(Pairs)])),
    length(Pairs, 37),
    Pairs = [financial_entity_is_article_16_1_entity - false|_].
test(a_failing_duty_decides_before_an_absent_one) :-
    subject_status(failing_duty_with_absent_duty, incomplete).
test(the_closing_duties_not_performed_is_incomplete) :-
    subject_status(closing_subparagraph_duties_outstanding, incomplete).
test(a_duplicate_and_a_wrong_type_are_input_problems) :-
    subject_status(duplicate_and_wrong_type, input_problems([duplicate_key(financial_entity_is_article_16_1_entity), wrong_type(access_control_policy_contains_segregation_of_duties)])).
test(an_unknown_key_is_an_input_problem) :-
    subject_status(unknown_key, input_problems([unknown_key(colour)])).
test(the_gate_alone_asks_for_the_first_duty) :-
    subject_status(gate_only_false, indeterminate([physical_and_environmental_security_policy_specified_documented_and_implemented])).
test(the_referral_context_is_one_of_the_two_allowed_forms) :-
    subject_status(unsure_referral, needs_legal_review(_, Context)),
    member(Context, [[inputs_relied_on(_)], [inputs_relied_on(_), provenance(_, _)]]).
test(the_referral_context_opens_with_the_inputs_relied_on) :-
    subject_status(unsure_referral, needs_legal_review(_, [inputs_relied_on(Pairs)|_])),
    length(Pairs, 37).
test(every_subject_has_exactly_one_verdict) :-
    findall(Subject, dora_rts_physical_hr_identity_and_access_subject(Subject), Subjects),
    findall(Subject - Count, (member(Subject, Subjects), findall(Verdict, dora_rts_physical_hr_identity_and_access_assess(Subject, Verdict), Verdicts), length(Verdicts, Count)), Counts),
    findall(Subject - 1, member(Subject, Subjects), Expected),
    Counts == Expected.
test(every_subject_is_resolvable) :-
    findall(Subject, (dora_rts_physical_hr_identity_and_access_subject(Subject), dora_rts_physical_hr_identity_and_access_profile_for(Subject, Profile), dora_rts_physical_hr_identity_and_access_decision_resolvable(Profile)), Resolvable),
    length(Resolvable, 11).
test(final_verdicts_are_in_the_status_values) :-
    dora_rts_physical_hr_identity_and_access_status_values(StatusValues),
    subject_status(all_duties_performed, Complete),
    subject_status(one_duty_not_performed, Incomplete),
    subject_status(article_16_1_entity, Simplified),
    clausal_msort([Complete, Incomplete, Simplified], Sorted),
    clausal_msort(StatusValues, Sorted).
test(the_checklist_of_a_complete_entity_is_cited_per_item) :-
    dora_rts_physical_hr_identity_and_access_profile_for(all_duties_performed, Profile),
    dora_rts_physical_hr_identity_and_access_checklist(Profile, Items),
    length(Items, 37),
    findall(Citation, member(item(_, met, cite(Citation)), Items), Cited),
    length(Cited, 37).
test(the_checklist_marks_the_failing_duty) :-
    dora_rts_physical_hr_identity_and_access_profile_for(one_duty_not_performed, Profile),
    dora_rts_physical_hr_identity_and_access_checklist(Profile, Items),
    member(item(segregation_of_duties, unmet(_), cite(eu_reg_2024_1774_art_21_b)), Items).
test(every_duty_is_required) :-
    dora_rts_physical_hr_identity_and_access_profile_for(all_duties_performed, Profile),
    physical_hr_identity_and_access_duties_required(Profile, required(Duties), Citations),
    length(Duties, 36),
    Duties = [physical_and_environmental_security_policy, physical_security_policy_design_basis|_],
    last(Duties, automated_privileged_access_management),
    length(Citations, 6).
test(the_required_query_reads_no_judgement) :-
    dora_rts_physical_hr_identity_and_access_profile_for(gate_only_false, Profile),
    physical_hr_identity_and_access_duties_required(Profile, required(Duties), _),
    length(Duties, 36).
test(the_complete_query_has_one_answer) :-
    dora_rts_physical_hr_identity_and_access_profile_for(failing_duty_with_absent_duty, Profile),
    findall(Result - Citations, physical_hr_identity_and_access_duties_complete(Profile, Result, Citations), Answers),
    length(Answers, 1),
    Answers = [incomplete - _].
test(the_closing_duties_are_outstanding_in_duty_order) :-
    dora_rts_physical_hr_identity_and_access_profile_for(closing_subparagraph_duties_outstanding, Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, outstanding([retention_period_for_point_e_i, dedicated_administrative_accounts, automated_privileged_access_management]), Citations),
    Citations == [cite(eu_reg_2024_1774_art_21)].
test(one_failing_duty_is_outstanding_with_its_point) :-
    dora_rts_physical_hr_identity_and_access_profile_for(one_duty_not_performed, Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, outstanding([segregation_of_duties]), Citations),
    Citations == [cite(eu_reg_2024_1774_art_21_b)].
test(a_failing_duty_does_not_end_the_outstanding_query) :-
    dora_rts_physical_hr_identity_and_access_profile_for(failing_duty_with_absent_duty, Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, indeterminate([dedicated_accounts_used_for_administrative_tasks_where_possible]), []).
test(nothing_failing_is_none_outstanding) :-
    dora_rts_physical_hr_identity_and_access_profile_for(all_duties_performed, Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, none_outstanding, Citations),
    length(Citations, 6).
test(the_outstanding_query_refers_an_unsure_duty) :-
    dora_rts_physical_hr_identity_and_access_profile_for(unsure_referral, Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, needs_legal_review(open_textured(access_control_policy_contains_segregation_of_duties, cite(eu_reg_2024_1774_art_21_b)), [inputs_relied_on(_)]), []).
test(a_good_profile_has_no_input_problem) :-
    dora_rts_physical_hr_identity_and_access_profile_for(all_duties_performed, Profile),
    dora_rts_physical_hr_identity_and_access_input_problems(Profile, []).
test(input_problems_come_before_the_gate) :-
    dora_rts_physical_hr_identity_and_access_profile_for(duplicate_and_wrong_type, Profile),
    physical_hr_identity_and_access_duties_required(Profile, input_problems(Problems), []),
    Problems = [duplicate_key(financial_entity_is_article_16_1_entity)|_].
test(a_profile_that_is_not_a_list) :-
    physical_hr_identity_and_access_duties_complete(not_a_list, input_problems([wrong_type(profile)]), []).
test(an_unbound_key_is_named_as_given) :-
    dora_rts_physical_hr_identity_and_access_input_problems([attribute(Key, true)], [unknown_key(Named)]),
    Named == Key.

test(an_article_16_1_entity_is_not_complete, fail) :-
    subject_status(article_16_1_entity, complete).
test(all_duties_performed_is_not_the_simplified_framework, fail) :-
    subject_status(all_duties_performed, simplified_framework_entity).
test(a_missing_gate_is_not_complete, fail) :-
    subject_status(gate_absent, complete).
test(one_duty_not_performed_is_not_complete, fail) :-
    subject_status(one_duty_not_performed, complete).
test(all_duties_performed_is_not_incomplete, fail) :-
    subject_status(all_duties_performed, incomplete).
test(the_first_absent_duty_is_not_complete, fail) :-
    subject_status(first_absent_duty, complete).
test(an_unsure_duty_is_not_complete, fail) :-
    subject_status(unsure_referral, complete).
test(the_absent_control_is_not_incomplete, fail) :-
    subject_status(first_absent_duty, incomplete).
test(a_duplicate_is_not_complete, fail) :-
    subject_status(duplicate_and_wrong_type, complete).
test(the_gate_alone_has_no_input_problem, fail) :-
    subject_status(gate_only_false, input_problems(_)).
test(the_referral_context_carries_no_provenance_item, fail) :-
    subject_status(unsure_referral, needs_legal_review(_, Context)),
    member(provenance(_, _), Context).
test(the_outstanding_referral_carries_no_provenance_item, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(unsure_referral, Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, needs_legal_review(_, Context), []),
    member(provenance(_, _), Context).
test(the_checklist_of_a_complete_entity_has_no_failing_duty, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(all_duties_performed, Profile),
    dora_rts_physical_hr_identity_and_access_checklist(Profile, Items),
    member(item(_, unmet(_), _), Items).
test(a_profile_with_input_problems_has_no_checklist, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(unknown_key, Profile),
    dora_rts_physical_hr_identity_and_access_checklist(Profile, _).
test(an_article_16_1_entity_has_no_required_list, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(article_16_1_entity, Profile),
    physical_hr_identity_and_access_duties_required(Profile, required(_), _).
test(nothing_failing_is_not_an_outstanding_list, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(all_duties_performed, Profile),
    physical_hr_identity_and_access_duties_outstanding(Profile, outstanding(_), _).
test(a_good_profile_has_no_named_problem, fail) :-
    dora_rts_physical_hr_identity_and_access_profile_for(all_duties_performed, Profile),
    dora_rts_physical_hr_identity_and_access_input_problems(Profile, [_|_]).

cp_test_names([an_article_16_1_entity_follows_the_simplified_framework, all_duties_performed_is_complete, a_missing_gate_is_asked_first, one_duty_not_performed_is_incomplete, the_first_absent_duty_is_asked, an_unsure_duty_goes_to_a_lawyer, a_failing_duty_decides_before_an_absent_one, the_closing_duties_not_performed_is_incomplete, a_duplicate_and_a_wrong_type_are_input_problems, an_unknown_key_is_an_input_problem, the_gate_alone_asks_for_the_first_duty, the_referral_context_is_one_of_the_two_allowed_forms, the_referral_context_opens_with_the_inputs_relied_on, every_subject_has_exactly_one_verdict, every_subject_is_resolvable, final_verdicts_are_in_the_status_values, the_checklist_of_a_complete_entity_is_cited_per_item, the_checklist_marks_the_failing_duty, every_duty_is_required, the_required_query_reads_no_judgement, the_complete_query_has_one_answer, the_closing_duties_are_outstanding_in_duty_order, one_failing_duty_is_outstanding_with_its_point, a_failing_duty_does_not_end_the_outstanding_query, nothing_failing_is_none_outstanding, the_outstanding_query_refers_an_unsure_duty, a_good_profile_has_no_input_problem, input_problems_come_before_the_gate, a_profile_that_is_not_a_list, an_unbound_key_is_named_as_given]).
cp_test_fail_names([an_article_16_1_entity_is_not_complete, all_duties_performed_is_not_the_simplified_framework, a_missing_gate_is_not_complete, one_duty_not_performed_is_not_complete, all_duties_performed_is_not_incomplete, the_first_absent_duty_is_not_complete, an_unsure_duty_is_not_complete, the_absent_control_is_not_incomplete, a_duplicate_is_not_complete, the_gate_alone_has_no_input_problem, the_referral_context_carries_no_provenance_item, the_outstanding_referral_carries_no_provenance_item, the_checklist_of_a_complete_entity_has_no_failing_duty, a_profile_with_input_problems_has_no_checklist, an_article_16_1_entity_has_no_required_list, nothing_failing_is_not_an_outstanding_list, a_good_profile_has_no_named_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
