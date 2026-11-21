% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_chapter_v_extras_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_gdpr_chapter_v_extras, [decide_gdpr_chapter_v_extras/2, gdpr_chapter_v_extras_status/2, gdpr_chapter_v_extras_checklist/2, gdpr_chapter_v_extras_decision_resolvable/1, gdpr_chapter_v_extras_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_chapter_v_extras_fixtures, [gdpr_chapter_v_extras_subject/1, gdpr_chapter_v_extras_profile_for/2, gdpr_chapter_v_extras_assess/2]).

test(status_holds_with_the_verdict_bound) :-
    gdpr_chapter_v_extras_profile_for(todo_baseline_subject, Profile),
    gdpr_chapter_v_extras_status(Profile, onward_transfer_may_take_place).
test(every_other_bound_status_is_rejected) :-
    gdpr_chapter_v_extras_profile_for(todo_baseline_subject, Profile),
    gdpr_chapter_v_extras_status_values(StatusValues),
    findall(Status, (member(Status, StatusValues), gdpr_chapter_v_extras_status(Profile, Status)), HeldStatuses),
    HeldStatuses == [onward_transfer_may_take_place].
test(the_baseline_profile_yields_no_other_table_status) :-
    gdpr_chapter_v_extras_profile_for(todo_baseline_subject, Profile),
    findall(Status, gdpr_chapter_v_extras_status(Profile, Status), Statuses),
    Statuses == [onward_transfer_may_take_place].
test(the_status_table_has_a_near_miss_atom) :-
    gdpr_chapter_v_extras_status_values(StatusValues),
    member(Status, StatusValues),
    dif(Status, onward_transfer_may_take_place).
test(the_baseline_verdict_carries_its_citation) :-
    gdpr_chapter_v_extras_profile_for(todo_baseline_subject, Profile),
    findall(Verdict, decide_gdpr_chapter_v_extras(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_chapter_v_extras_verdict(onward_transfer_may_take_place, [cite(eu_reg_2016_679_art_44)])].
test(the_baseline_is_resolvable) :-
    gdpr_chapter_v_extras_profile_for(todo_baseline_subject, Profile),
    gdpr_chapter_v_extras_decision_resolvable(Profile).
test(the_assess_wrapper_answers_once) :-
    findall(Verdict, gdpr_chapter_v_extras_assess(onward_transfer_without_chapter_v_basis, Verdict), Verdicts),
    Verdicts == [gdpr_chapter_v_extras_verdict(onward_transfer_may_not_take_place, [cite(eu_reg_2016_679_art_44)])].
test(every_expected_row_holds_exactly_once) :-
    findall(Subject - RowId - Specification, expected(Subject, RowId, Specification), ExpectedRows),
    ExpectedRows = [_|_],
    maplist(expected_row_holds, ExpectedRows).
test(every_subject_has_exactly_one_five_row_checklist) :-
    findall(Subject, gdpr_chapter_v_extras_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(subject_has_one_checklist, Subjects).
test(every_subject_has_exactly_one_status) :-
    findall(Subject, gdpr_chapter_v_extras_subject(Subject), Subjects),
    maplist(subject_has_one_status, Subjects).
test(a_met_row_is_met) :-
    row_results(complete_transfer_file, inform_supervisory_authority, [duty_met]).

referral_row(transfer_relies_on_article_49_1_second_subparagraph, eu_reg_2016_679_art_49_1_second_subpara, second_subparagraph_transfer_statement).
referral_row(third_country_judgment_or_decision_requires_transfer, eu_reg_2016_679_art_48, foreign_judgment_requires_transfer_statement).
referral_row(international_agreement_basis_for_judgment_or_decision, eu_reg_2016_679_art_48, international_agreement_basis_statement).
referral_row(transfer_is_onward_transfer, eu_reg_2016_679_art_44, onward_transfer_statement).
referral_row(onward_transfer_has_chapter_v_basis, eu_reg_2016_679_art_44, onward_transfer_chapter_v_basis_statement).

expected_result(plain(Result), Result).
expected_result(referral(OutsideKey), needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on([OutsideKey - absent])])) :-
    referral_row(OutsideKey, Citation, Target).

expected(supervisory_authority_informed, inform_supervisory_authority, plain(duty_met)).
expected(supervisory_authority_not_informed, inform_supervisory_authority, plain(duty_not_met)).
expected(supervisory_authority_information_unstated, inform_supervisory_authority, plain(indeterminate([supervisory_authority_informed_of_transfer]))).
expected(processor_asks_about_informing, inform_supervisory_authority, plain(not_a_processor_duty)).
expected(processor_asks_about_informing, inform_data_subject, plain(not_a_processor_duty)).
expected(processor_asks_with_transfer_fact_absent, inform_data_subject, plain(not_a_processor_duty)).
expected(processor_asks_with_transfer_fact_absent, document_assessment_and_safeguards, referral(transfer_relies_on_article_49_1_second_subparagraph)).
expected(controller_asks_with_transfer_fact_absent, inform_supervisory_authority, referral(transfer_relies_on_article_49_1_second_subparagraph)).
expected(party_role_unstated, inform_supervisory_authority, plain(indeterminate([party_role]))).
expected(transfer_not_under_second_subparagraph, inform_data_subject, plain(no_second_subparagraph_transfer)).
expected(transfer_not_under_second_subparagraph_role_unstated, inform_supervisory_authority, plain(indeterminate([party_role]))).
expected(transfer_not_under_second_subparagraph_role_unstated, document_assessment_and_safeguards, plain(no_second_subparagraph_transfer)).
expected(data_subject_fully_informed, inform_data_subject, plain(duty_met)).
expected(data_subject_not_told_of_interests, inform_data_subject, plain(duty_not_met)).
expected(data_subject_interests_refused_transfer_unstated, inform_data_subject, plain(duty_not_met)).
expected(data_subject_transfer_information_unstated, inform_data_subject, plain(indeterminate([data_subject_informed_of_transfer]))).
expected(records_complete_for_processor, document_assessment_and_safeguards, plain(duty_met)).
expected(records_lack_safeguards, document_assessment_and_safeguards, plain(duty_not_met)).
expected(records_lack_assessment_safeguards_unstated, document_assessment_and_safeguards, plain(duty_not_met)).
expected(records_safeguards_unstated, document_assessment_and_safeguards, plain(indeterminate([suitable_safeguards_documented_in_records]))).
expected(judgment_not_requiring_transfer, article_48, plain(article_48_not_engaged)).
expected(judgment_with_international_agreement, article_48, plain(not_barred_by_article_48)).
expected(judgment_without_international_agreement, article_48, plain(not_recognisable_or_enforceable)).
expected(judgment_agreement_unstated, article_48, referral(international_agreement_basis_for_judgment_or_decision)).
expected(judgment_unstated_agreement_stated, article_48, referral(third_country_judgment_or_decision_requires_transfer)).
expected(onward_transfer_with_chapter_v_basis, onward_transfer, plain(onward_transfer_may_take_place)).
expected(onward_transfer_without_chapter_v_basis, onward_transfer, plain(onward_transfer_may_not_take_place)).
expected(onward_transfer_basis_unstated, onward_transfer, referral(onward_transfer_has_chapter_v_basis)).
expected(transfer_not_onward, onward_transfer, plain(not_an_onward_transfer)).
expected(transfer_not_onward_with_link_evidence, onward_transfer, plain(not_an_onward_transfer)).
expected(onward_status_unstated_basis_stated, onward_transfer, referral(transfer_is_onward_transfer)).
expected(duplicated_party_role, inform_supervisory_authority, plain(input_problems([duplicate_key(party_role)]))).
expected(bare_boolean_outside_fact, onward_transfer, plain(input_problems([wrong_type(transfer_is_onward_transfer)]))).
expected(unknown_key_supplied, article_48, plain(input_problems([unknown_key(transfer_date)]))).
expected(empty_profile, inform_supervisory_authority, referral(transfer_relies_on_article_49_1_second_subparagraph)).
expected(empty_profile, article_48, referral(third_country_judgment_or_decision_requires_transfer)).
expected(empty_profile, onward_transfer, referral(transfer_is_onward_transfer)).
expected(complete_transfer_file, inform_supervisory_authority, plain(duty_met)).
expected(complete_transfer_file, inform_data_subject, plain(duty_met)).
expected(complete_transfer_file, document_assessment_and_safeguards, plain(duty_met)).
expected(complete_transfer_file, article_48, plain(not_barred_by_article_48)).
expected(complete_transfer_file, onward_transfer, plain(onward_transfer_may_take_place)).

row_results(Subject, RowId, Results) :-
    gdpr_chapter_v_extras_profile_for(Subject, Profile),
    findall(Result, (gdpr_chapter_v_extras_checklist(Profile, Checklist), member(item(RowId, Result, _Citations), Checklist)), Results).

expected_row_holds(Subject - RowId - Specification) :-
    expected_result(Specification, Expected),
    row_results(Subject, RowId, Results),
    Results == [Expected].

subject_has_one_checklist(Subject) :-
    gdpr_chapter_v_extras_profile_for(Subject, Profile),
    findall(Checklist, gdpr_chapter_v_extras_checklist(Profile, Checklist), Checklists),
    Checklists = [[_, _, _, _, _]].

subject_has_one_status(Subject) :-
    gdpr_chapter_v_extras_profile_for(Subject, Profile),
    findall(Status, gdpr_chapter_v_extras_status(Profile, Status), Statuses),
    Statuses = [_].

test(a_met_row_is_not_also_not_met, fail) :-
    row_results(complete_transfer_file, inform_supervisory_authority, [duty_not_met]).

cp_test_names([status_holds_with_the_verdict_bound, every_other_bound_status_is_rejected, the_baseline_profile_yields_no_other_table_status, the_status_table_has_a_near_miss_atom, the_baseline_verdict_carries_its_citation, the_baseline_is_resolvable, the_assess_wrapper_answers_once, every_expected_row_holds_exactly_once, every_subject_has_exactly_one_five_row_checklist, every_subject_has_exactly_one_status, a_met_row_is_met]).
cp_test_fail_names([a_met_row_is_not_also_not_met]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
