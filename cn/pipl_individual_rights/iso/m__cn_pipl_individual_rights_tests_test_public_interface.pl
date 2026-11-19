% SPDX-License-Identifier: EUPL-1.2
:- module(m__cn_pipl_individual_rights_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__cn_pipl_individual_rights_pipl_individual_rights, [restriction_or_refusal_right/3, access_and_copy_duty/3, portability_duty/3, correction_duty/3, deletion_duty/3, explanation_duty/3, deceased_person_rights/3, request_mechanism/3, refusal_status/3, decide_pipl_individual_rights/2, pipl_individual_rights_status/2, pipl_individual_rights_checklist/2, pipl_individual_rights_decision_resolvable/1, pipl_individual_rights_status_values/1]).
:- use_module(m__cn_pipl_individual_rights_kernel, [pipl_individual_rights_input_problems/2]).
:- use_module(m__cn_pipl_individual_rights_queries, [pipl_individual_rights_what_if/4]).
:- use_module(m__cn_pipl_individual_rights_fixtures, [pipl_individual_rights_subject/1, pipl_individual_rights_profile_for/2, pipl_individual_rights_assess/2]).

query_name(restriction_or_refusal_right).
query_name(access_and_copy_duty).
query_name(portability_duty).
query_name(correction_duty).
query_name(deletion_duty).
query_name(explanation_duty).
query_name(deceased_person_rights).
query_name(request_mechanism).
query_name(refusal_status).

answer(restriction_or_refusal_right, Profile, Result, Citations) :-
    restriction_or_refusal_right(Profile, Result, Citations).
answer(access_and_copy_duty, Profile, Result, Citations) :-
    access_and_copy_duty(Profile, Result, Citations).
answer(portability_duty, Profile, Result, Citations) :-
    portability_duty(Profile, Result, Citations).
answer(correction_duty, Profile, Result, Citations) :-
    correction_duty(Profile, Result, Citations).
answer(deletion_duty, Profile, Result, Citations) :-
    deletion_duty(Profile, Result, Citations).
answer(explanation_duty, Profile, Result, Citations) :-
    explanation_duty(Profile, Result, Citations).
answer(deceased_person_rights, Profile, Result, Citations) :-
    deceased_person_rights(Profile, Result, Citations).
answer(request_mechanism, Profile, Result, Citations) :-
    request_mechanism(Profile, Result, Citations).
answer(refusal_status, Profile, Result, Citations) :-
    refusal_status(Profile, Result, Citations).

deletion_answer_citations([cite(cn_pipl_art_47_p1), cite(cn_pipl_art_47_p1_i1), cite(cn_pipl_art_47_p1_i2), cite(cn_pipl_art_47_p1_i3), cite(cn_pipl_art_47_p1_i4), cite(cn_pipl_art_47_p1_i5), cite(cn_pipl_art_47_p2)]).

deletion_case_citations([cite(cn_pipl_art_47_p1), cite(cn_pipl_art_47_p1_i1), cite(cn_pipl_art_47_p1_i2), cite(cn_pipl_art_47_p1_i3), cite(cn_pipl_art_47_p1_i4), cite(cn_pipl_art_47_p1_i5)]).

expected_status(baseline_all_rights_engaged, eligible).
expected_status(restriction_excluded_by_other_law, eligible).
expected_status(restriction_other_law_unstated, undetermined).
expected_status(access_article_18_1_case, eligible).
expected_status(access_article_35_case, eligible).
expected_status(access_article_35_unstated, undetermined).
expected_status(portability_conditions_not_met, eligible).
expected_status(portability_conditions_unstated, undetermined).
expected_status(correction_verification_negative, eligible).
expected_status(correction_verification_unsure, referred_for_legal_review).
expected_status(deletion_retention_period_unexpired, eligible).
expected_status(deletion_technically_difficult, eligible).
expected_status(deletion_no_case_holds, eligible).
expected_status(deletion_two_cases_hold, eligible).
expected_status(deletion_retention_unstated, undetermined).
expected_status(deletion_purpose_unsure, referred_for_legal_review).
expected_status(deletion_violation_unsure, referred_for_legal_review).
expected_status(deletion_difficulty_unsure, referred_for_legal_review).
expected_status(deletion_purpose_unstated, undetermined).
expected_status(deceased_arranged_otherwise, eligible).
expected_status(deceased_requester_not_near_relative, eligible).
expected_status(deceased_person_alive, eligible).
expected_status(deceased_interests_unsure, referred_for_legal_review).
expected_status(mechanism_not_convenient, ineligible).
expected_status(mechanism_convenience_unsure, referred_for_legal_review).
expected_status(refusal_without_reasons, ineligible).
expected_status(refusal_not_refused, eligible).
expected_status(refusal_reasons_unstated, undetermined).
expected_status(text_not_in_force, text_not_in_force).
expected_status(text_in_force_unstated, undetermined).
expected_status(input_duplicate_key, input_rejected).
expected_status(input_wrong_type_and_unknown_key, input_rejected).
expected_status(input_empty_profile, undetermined).
expected_status(input_not_an_attribute_list, input_rejected).

expected_answer(baseline_all_rights_engaged, restriction_or_refusal_right, right_available, [cite(cn_pipl_art_44_p1)]).
expected_answer(baseline_all_rights_engaged, access_and_copy_duty, provide_in_time, [cite(cn_pipl_art_45_p1), cite(cn_pipl_art_45_p2)]).
expected_answer(baseline_all_rights_engaged, portability_duty, provide_transfer_route, [cite(cn_pipl_art_45_p3)]).
expected_answer(baseline_all_rights_engaged, correction_duty, correct_or_supplement_in_time, [cite(cn_pipl_art_46_p1), cite(cn_pipl_art_46_p2)]).
expected_answer(baseline_all_rights_engaged, deletion_duty, delete_personal_information, Citations) :-
    deletion_answer_citations(Citations).
expected_answer(baseline_all_rights_engaged, explanation_duty, explain_processing_rules, [cite(cn_pipl_art_48_p1)]).
expected_answer(baseline_all_rights_engaged, deceased_person_rights, near_relative_may_exercise, [cite(cn_pipl_art_49_p1)]).
expected_answer(baseline_all_rights_engaged, request_mechanism, requirement_met, [cite(cn_pipl_art_50_p1)]).
expected_answer(baseline_all_rights_engaged, refusal_status, refused_with_reasons, [cite(cn_pipl_art_50_p1), cite(cn_pipl_art_50_p2)]).
expected_answer(restriction_excluded_by_other_law, restriction_or_refusal_right, excluded_by_other_law, [cite(cn_pipl_art_44_p1)]).
expected_answer(restriction_other_law_unstated, restriction_or_refusal_right, indeterminate([laws_or_regulations_provide_otherwise]), []).
expected_answer(access_article_18_1_case, access_and_copy_duty, not_owed, [cite(cn_pipl_art_45_p1)]).
expected_answer(access_article_35_case, access_and_copy_duty, not_owed, [cite(cn_pipl_art_45_p1)]).
expected_answer(access_article_35_unstated, access_and_copy_duty, indeterminate([article_35_case]), []).
expected_answer(portability_conditions_not_met, portability_duty, not_owed, [cite(cn_pipl_art_45_p3)]).
expected_answer(portability_conditions_unstated, portability_duty, indeterminate([cyberspace_department_transfer_conditions_met]), []).
expected_answer(correction_verification_negative, correction_duty, no_correction_owed, [cite(cn_pipl_art_46_p1), cite(cn_pipl_art_46_p2)]).
expected_answer(correction_verification_unsure, correction_duty, needs_legal_review(open_textured(verification_confirms_inaccurate_or_incomplete, cite(cn_pipl_art_46_p2)), [inputs_relied_on([verification_confirms_inaccurate_or_incomplete - unsure])]), []).
expected_answer(deletion_retention_period_unexpired, deletion_duty, stop_processing_except_storage_and_security, Citations) :-
    deletion_answer_citations(Citations).
expected_answer(deletion_technically_difficult, deletion_duty, stop_processing_except_storage_and_security, Citations) :-
    deletion_answer_citations(Citations).
expected_answer(deletion_no_case_holds, deletion_duty, not_owed, Citations) :-
    deletion_case_citations(Citations).
expected_answer(deletion_two_cases_hold, deletion_duty, delete_personal_information, Citations) :-
    deletion_answer_citations(Citations).
expected_answer(deletion_retention_unstated, deletion_duty, indeterminate([legal_retention_period_unexpired]), []).
expected_answer(deletion_purpose_unsure, deletion_duty, needs_legal_review(open_textured(purpose_achieved_impossible_or_unnecessary, cite(cn_pipl_art_47_p1_i1)), [inputs_relied_on([purpose_achieved_impossible_or_unnecessary - unsure, processing_violates_law_or_agreement - false, deletion_technically_difficult - false])]), []).
expected_answer(deletion_violation_unsure, deletion_duty, needs_legal_review(open_textured(processing_violates_law_or_agreement, cite(cn_pipl_art_47_p1_i4)), [inputs_relied_on([purpose_achieved_impossible_or_unnecessary - false, processing_violates_law_or_agreement - unsure, deletion_technically_difficult - false])]), []).
expected_answer(deletion_difficulty_unsure, deletion_duty, needs_legal_review(open_textured(deletion_technically_difficult, cite(cn_pipl_art_47_p2)), [inputs_relied_on([purpose_achieved_impossible_or_unnecessary - false, processing_violates_law_or_agreement - false, deletion_technically_difficult - unsure])]), []).
expected_answer(deletion_purpose_unstated, deletion_duty, indeterminate([purpose_achieved_impossible_or_unnecessary]), []).
expected_answer(deceased_arranged_otherwise, deceased_person_rights, near_relative_may_not_exercise, [cite(cn_pipl_art_49_p1)]).
expected_answer(deceased_requester_not_near_relative, deceased_person_rights, near_relative_may_not_exercise, [cite(cn_pipl_art_49_p1)]).
expected_answer(deceased_person_alive, deceased_person_rights, near_relative_may_not_exercise, [cite(cn_pipl_art_49_p1)]).
expected_answer(deceased_interests_unsure, deceased_person_rights, needs_legal_review(open_textured(for_requester_own_lawful_and_legitimate_interests, cite(cn_pipl_art_49_p1)), [inputs_relied_on([for_requester_own_lawful_and_legitimate_interests - unsure])]), []).
expected_answer(mechanism_not_convenient, request_mechanism, requirement_not_met, [cite(cn_pipl_art_50_p1)]).
expected_answer(mechanism_convenience_unsure, request_mechanism, needs_legal_review(open_textured(convenient_mechanism_established, cite(cn_pipl_art_50_p1)), [inputs_relied_on([convenient_mechanism_established - unsure])]), []).
expected_answer(refusal_without_reasons, refusal_status, refused_without_reasons, [cite(cn_pipl_art_50_p1), cite(cn_pipl_art_50_p2)]).
expected_answer(refusal_not_refused, refusal_status, not_refused, [cite(cn_pipl_art_50_p1)]).
expected_answer(refusal_reasons_unstated, refusal_status, indeterminate([refusal_reasons_given]), []).
expected_answer(Subject, Query, Result, []) :-
    gate_answer(Subject, Result),
    query_name(Query).

gate_answer(text_not_in_force, pinned_text_not_applicable).
gate_answer(text_in_force_unstated, indeterminate([pinned_text_in_force_on_reference_day])).
gate_answer(input_empty_profile, indeterminate([pinned_text_in_force_on_reference_day])).
gate_answer(input_duplicate_key, input_problems([duplicate_key(consent_withdrawn)])).
gate_answer(input_wrong_type_and_unknown_key, input_problems([wrong_type(article_35_case), unknown_key(colour)])).
gate_answer(input_not_an_attribute_list, input_problems([wrong_type(profile)])).

subject_status_holds(Subject) :-
    expected_status(Subject, Expected),
    pipl_individual_rights_profile_for(Subject, Profile),
    findall(Status, pipl_individual_rights_status(Profile, Status), Statuses),
    Statuses == [Expected].

expected_answer_holds(Subject - Query - Result - Citations) :-
    pipl_individual_rights_profile_for(Subject, Profile),
    findall(Answer - Cited, answer(Query, Profile, Answer, Cited), Answers),
    Answers == [Result - Citations].

answers_each_query_once(Queries, Subject) :-
    pipl_individual_rights_profile_for(Subject, Profile),
    maplist(answers_once(Profile), Queries).

answers_once(Profile, Query) :-
    findall(Result, answer(Query, Profile, Result, _), Results),
    length(Results, 1).

input_check_once(Subject) :-
    pipl_individual_rights_profile_for(Subject, Profile),
    findall(Problems, pipl_individual_rights_input_problems(Profile, Problems), Answers),
    length(Answers, 1).

checklist_fully_cited(Subject) :-
    pipl_individual_rights_profile_for(Subject, Profile),
    pipl_individual_rights_checklist(Profile, Items),
    length(Items, 9),
    maplist(cited_item, Items).

cited_item(item(_, _, cite(Key))) :-
    atom(Key).

resolvable(Subject) :-
    pipl_individual_rights_profile_for(Subject, Profile),
    pipl_individual_rights_decision_resolvable(Profile).

status_in_vocabulary(Values, Subject) :-
    expected_status(Subject, Status),
    member(Status, Values).

all_subjects(Subjects) :-
    findall(Subject, pipl_individual_rights_subject(Subject), Subjects).

test(every_subject_has_an_expected_status) :-
    all_subjects(Subjects),
    sort(Subjects, SortedSubjects),
    findall(Subject, expected_status(Subject, _), ExpectedSubjects),
    sort(ExpectedSubjects, SortedExpected),
    SortedSubjects == SortedExpected.
test(every_subject_resolves_to_its_expected_status) :-
    all_subjects(Subjects),
    maplist(subject_status_holds, Subjects).
test(every_expected_query_answer_holds) :-
    findall(Subject - Query - Result - Citations, expected_answer(Subject, Query, Result, Citations), Rows),
    Rows = [_|_],
    maplist(expected_answer_holds, Rows).
test(every_subject_answers_every_query_exactly_once) :-
    all_subjects(Subjects),
    findall(Query, query_name(Query), Queries),
    maplist(answers_each_query_once(Queries), Subjects).
test(the_input_check_answers_once_for_every_subject) :-
    all_subjects(Subjects),
    maplist(input_check_once, Subjects).
test(every_checklist_has_nine_cited_items) :-
    all_subjects(Subjects),
    maplist(checklist_fully_cited, Subjects).
test(every_subject_is_resolvable) :-
    all_subjects(Subjects),
    maplist(resolvable, Subjects).
test(every_expected_status_is_in_the_vocabulary) :-
    pipl_individual_rights_status_values(Values),
    all_subjects(Subjects),
    maplist(status_in_vocabulary(Values), Subjects).
test(baseline_assesses_eligible_with_a_cited_checklist) :-
    pipl_individual_rights_assess(baseline_all_rights_engaged, pipl_individual_rights_verdict(eligible, Items)),
    length(Items, 9),
    member(item(article_50_refusal, met, cite(cn_pipl_art_50_p1)), Items).
test(refusal_without_reasons_assesses_ineligible) :-
    pipl_individual_rights_assess(refusal_without_reasons, pipl_individual_rights_verdict(ineligible, Items)),
    member(item(article_50_refusal, unmet(refused_without_reasons), cite(cn_pipl_art_50_p1)), Items).
test(mechanism_not_convenient_is_ineligible) :-
    pipl_individual_rights_profile_for(mechanism_not_convenient, Profile),
    pipl_individual_rights_status(Profile, ineligible).
test(deletion_retention_period_stops_processing) :-
    pipl_individual_rights_profile_for(deletion_retention_period_unexpired, Profile),
    deletion_duty(Profile, stop_processing_except_storage_and_security, _).
test(deletion_no_case_holds_is_not_owed) :-
    pipl_individual_rights_profile_for(deletion_no_case_holds, Profile),
    deletion_duty(Profile, not_owed, _).
test(access_article_35_case_is_not_owed) :-
    pipl_individual_rights_profile_for(access_article_35_case, Profile),
    access_and_copy_duty(Profile, not_owed, [cite(cn_pipl_art_45_p1)]).
test(deceased_arranged_otherwise_may_not_exercise) :-
    pipl_individual_rights_profile_for(deceased_arranged_otherwise, Profile),
    deceased_person_rights(Profile, near_relative_may_not_exercise, _).
test(text_not_in_force_is_not_applicable_in_explanation) :-
    pipl_individual_rights_profile_for(text_not_in_force, Profile),
    explanation_duty(Profile, pinned_text_not_applicable, []).
test(the_duplicate_key_is_reported_by_the_input_check) :-
    pipl_individual_rights_profile_for(input_duplicate_key, Profile),
    pipl_individual_rights_input_problems(Profile, [duplicate_key(consent_withdrawn)]).
test(the_baseline_has_no_input_problem) :-
    pipl_individual_rights_profile_for(baseline_all_rights_engaged, Profile),
    pipl_individual_rights_input_problems(Profile, []).
test(decide_matches_status_on_the_baseline) :-
    pipl_individual_rights_profile_for(baseline_all_rights_engaged, Profile),
    decide_pipl_individual_rights(Profile, pipl_individual_rights_verdict(Status, _)),
    Status == eligible.
test(what_if_reasons_withheld_flips_the_baseline_to_ineligible) :-
    pipl_individual_rights_profile_for(baseline_all_rights_engaged, Profile),
    findall(Status, pipl_individual_rights_what_if(Profile, refusal_reasons_given, false, Status), Statuses),
    Statuses == [ineligible].
test(what_if_reasons_given_flips_the_control_back_to_eligible) :-
    pipl_individual_rights_profile_for(refusal_without_reasons, Profile),
    findall(Status, pipl_individual_rights_what_if(Profile, refusal_reasons_given, true, Status), Statuses),
    Statuses == [eligible].
test(what_if_duplicate_key_override_is_well_formed) :-
    pipl_individual_rights_profile_for(input_duplicate_key, Profile),
    findall(Status, pipl_individual_rights_what_if(Profile, consent_withdrawn, true, Status), Statuses),
    Statuses == [eligible].

test(baseline_is_not_ineligible, fail) :-
    pipl_individual_rights_assess(baseline_all_rights_engaged, pipl_individual_rights_verdict(ineligible, _)).
test(refusal_without_reasons_is_not_eligible, fail) :-
    pipl_individual_rights_assess(refusal_without_reasons, pipl_individual_rights_verdict(eligible, _)).
test(mechanism_not_convenient_is_not_eligible, fail) :-
    pipl_individual_rights_profile_for(mechanism_not_convenient, Profile),
    pipl_individual_rights_status(Profile, eligible).
test(deletion_retention_period_does_not_delete, fail) :-
    pipl_individual_rights_profile_for(deletion_retention_period_unexpired, Profile),
    deletion_duty(Profile, delete_personal_information, _).
test(deletion_no_case_holds_does_not_delete, fail) :-
    pipl_individual_rights_profile_for(deletion_no_case_holds, Profile),
    deletion_duty(Profile, delete_personal_information, _).
test(access_article_35_case_is_not_provided, fail) :-
    pipl_individual_rights_profile_for(access_article_35_case, Profile),
    access_and_copy_duty(Profile, provide_in_time, _).
test(deceased_arranged_otherwise_may_not_be_exercised, fail) :-
    pipl_individual_rights_profile_for(deceased_arranged_otherwise, Profile),
    deceased_person_rights(Profile, near_relative_may_exercise, _).
test(text_not_in_force_owes_no_explanation, fail) :-
    pipl_individual_rights_profile_for(text_not_in_force, Profile),
    explanation_duty(Profile, explain_processing_rules, _).
test(the_baseline_has_no_input_problem_reported, fail) :-
    pipl_individual_rights_profile_for(baseline_all_rights_engaged, Profile),
    pipl_individual_rights_input_problems(Profile, [_|_]).

cp_test_names([every_subject_has_an_expected_status, every_subject_resolves_to_its_expected_status, every_expected_query_answer_holds, every_subject_answers_every_query_exactly_once, the_input_check_answers_once_for_every_subject, every_checklist_has_nine_cited_items, every_subject_is_resolvable, every_expected_status_is_in_the_vocabulary, baseline_assesses_eligible_with_a_cited_checklist, refusal_without_reasons_assesses_ineligible, mechanism_not_convenient_is_ineligible, deletion_retention_period_stops_processing, deletion_no_case_holds_is_not_owed, access_article_35_case_is_not_owed, deceased_arranged_otherwise_may_not_exercise, text_not_in_force_is_not_applicable_in_explanation, the_duplicate_key_is_reported_by_the_input_check, the_baseline_has_no_input_problem, decide_matches_status_on_the_baseline, what_if_reasons_withheld_flips_the_baseline_to_ineligible, what_if_reasons_given_flips_the_control_back_to_eligible, what_if_duplicate_key_override_is_well_formed]).
cp_test_fail_names([baseline_is_not_ineligible, refusal_without_reasons_is_not_eligible, mechanism_not_convenient_is_not_eligible, deletion_retention_period_does_not_delete, deletion_no_case_holds_does_not_delete, access_article_35_case_is_not_provided, deceased_arranged_otherwise_may_not_be_exercised, text_not_in_force_owes_no_explanation, the_baseline_has_no_input_problem_reported]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
