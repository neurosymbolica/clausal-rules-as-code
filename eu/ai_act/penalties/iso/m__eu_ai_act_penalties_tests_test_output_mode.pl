% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_penalties_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_ai_act_penalties_penalties, [decide_penalties/2, maximum_fine/4, general_purpose_ai_model_maximum_fine/4]).
:- use_module(m__eu_ai_act_penalties_fixtures, [penalties_subject/1, penalties_profile_for/2]).

expected_answer(earlier_version_day_before_pinned_text, no_union_maximum_determined, earlier_version_applies, []).
expected_answer(pinned_text_start_day, union_maximum_determined, fine_maximum(7000000000, turnover_percentage), [cite(eu_reg_2024_1689_art_99_3)]).
expected_answer(deferred_prohibition_day_before_application, no_union_maximum_determined, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_a)]).
expected_answer(deferred_prohibition_application_day, union_maximum_determined, fine_maximum(7000000000, turnover_percentage), [cite(eu_reg_2024_1689_art_99_3)]).
expected_answer(deferred_prohibition_public_authority_day_before, no_union_maximum_determined, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_a)]).
expected_answer(public_authority_operator_breach, no_union_maximum_determined, set_by_member_state_rules, [cite(eu_reg_2024_1689_art_99_8)]).
expected_answer(public_authority_absent_infringement_day_before_december, information_missing, indeterminate([infringement]), []).
expected_answer(public_authority_absent_infringement_december_day, no_union_maximum_determined, set_by_member_state_rules, [cite(eu_reg_2024_1689_art_99_8)]).
expected_answer(union_institution_prohibition, union_maximum_determined, fine_maximum(150000000, fixed_amount), [cite(eu_reg_2024_1689_art_100_1), cite(eu_reg_2024_1689_art_100_2)]).
expected_answer(union_institution_deferred_prohibition_from_december, union_maximum_determined, fine_maximum(150000000, fixed_amount), [cite(eu_reg_2024_1689_art_100_1), cite(eu_reg_2024_1689_art_100_2)]).
expected_answer(union_institution_incorrect_information, union_maximum_determined, fine_maximum(75000000, fixed_amount), [cite(eu_reg_2024_1689_art_100_1), cite(eu_reg_2024_1689_art_100_3)]).
expected_answer(union_institution_other_infringement, union_maximum_determined, fine_maximum(75000000, fixed_amount), [cite(eu_reg_2024_1689_art_100_1), cite(eu_reg_2024_1689_art_100_3)]).
expected_answer(other_infringement_undertaking, no_union_maximum_determined, no_union_maximum, [cite(eu_reg_2024_1689_art_99_3), cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_5)]).
expected_answer(not_an_undertaking_provider_obligations, union_maximum_determined, fine_maximum(1500000000, fixed_amount), [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_a)]).
expected_answer(not_an_undertaking_authorised_representative, union_maximum_determined, fine_maximum(1500000000, fixed_amount), [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_b)]).
expected_answer(undertaking_provider_obligations_without_turnover, information_missing, indeterminate([worldwide_annual_turnover_eur]), []).
expected_answer(offender_category_absent, information_missing, indeterminate([offender_category]), []).
expected_answer(infringement_absent, information_missing, indeterminate([infringement]), []).
expected_answer(prohibition_turnover_at_boundary, union_maximum_determined, fine_maximum(3500000000, fixed_amount), [cite(eu_reg_2024_1689_art_99_3)]).
expected_answer(prohibition_turnover_above_boundary, union_maximum_determined, fine_maximum(3500000007, turnover_percentage), [cite(eu_reg_2024_1689_art_99_3)]).
expected_answer(transparency_turnover_at_boundary, union_maximum_determined, fine_maximum(1500000000, fixed_amount), [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_g)]).
expected_answer(transparency_turnover_above_boundary, union_maximum_determined, fine_maximum(1500000003, turnover_percentage), [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_g)]).
expected_answer(incorrect_information_turnover_at_boundary, union_maximum_determined, fine_maximum(750000000, fixed_amount), [cite(eu_reg_2024_1689_art_99_5)]).
expected_answer(incorrect_information_turnover_above_boundary, union_maximum_determined, fine_maximum(750000001, turnover_percentage), [cite(eu_reg_2024_1689_art_99_5)]).
expected_answer(distributor_undertaking, union_maximum_determined, fine_maximum(3000000000, turnover_percentage), [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_d)]).
expected_answer(provider_and_operator_undertaking, union_maximum_determined, fine_maximum(1500000000, fixed_amount), [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_da)]).
expected_answer(small_or_medium_enterprise_prohibition_at_boundary, union_maximum_determined, fine_maximum(3500000000, fixed_amount), [cite(eu_reg_2024_1689_art_99_3), cite(eu_reg_2024_1689_art_99_6)]).
expected_answer(small_or_medium_enterprise_prohibition_below_boundary, union_maximum_determined, fine_maximum(3499999993, turnover_percentage), [cite(eu_reg_2024_1689_art_99_3), cite(eu_reg_2024_1689_art_99_6)]).
expected_answer(small_or_medium_enterprise_notified_body, union_maximum_determined, fine_maximum(300000000, turnover_percentage), [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_f), cite(eu_reg_2024_1689_art_99_6)]).
expected_answer(small_mid_cap_importer_at_boundary, union_maximum_determined, fine_maximum(1500000000, fixed_amount), [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_c), cite(eu_reg_2024_1689_art_99_6a)]).
expected_answer(small_mid_cap_importer_below_boundary, union_maximum_determined, fine_maximum(1499999997, turnover_percentage), [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_c), cite(eu_reg_2024_1689_art_99_6a)]).
expected_answer(small_mid_cap_deployer, union_maximum_determined, fine_maximum(1500000000, fixed_amount), [cite(eu_reg_2024_1689_art_99_4), cite(eu_reg_2024_1689_art_99_4_e), cite(eu_reg_2024_1689_art_99_6a)]).
expected_answer(small_mid_cap_prohibition_below_boundary, union_maximum_determined, fine_maximum(3500000000, fixed_amount), [cite(eu_reg_2024_1689_art_99_3)]).
expected_answer(profile_and_date_problems, input_rejected, input_problems([unknown_key(colour), wrong_type(infringement_date)]), []).
expected_answer(duplicate_infringement_key, input_rejected, input_problems([duplicate_key(infringement)]), []).
expected_answer(profile_not_an_attribute_list, input_rejected, input_problems([wrong_type(profile)]), []).
expected_answer(model_fine_before_pinned_text, no_union_maximum_determined, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113), cite(eu_reg_2024_1689_art_113_b)]).
expected_answer(model_fine_day_before_application, no_union_maximum_determined, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113), cite(eu_reg_2024_1689_art_113_b)]).
expected_answer(model_fine_application_day, union_maximum_determined, fine_maximum(3000000000, turnover_percentage), [cite(eu_reg_2024_1689_art_101_1), cite(eu_reg_2024_1689_art_101_1_a)]).
expected_answer(model_fine_not_a_provider, no_union_maximum_determined, no_commission_fine, [cite(eu_reg_2024_1689_art_101_1)]).
expected_answer(model_fine_none_of_the_acts, no_union_maximum_determined, no_commission_fine, [cite(eu_reg_2024_1689_art_101_1)]).
expected_answer(model_fine_no_intent_or_negligence, no_union_maximum_determined, no_commission_fine, [cite(eu_reg_2024_1689_art_101_1)]).
expected_answer(model_fine_intent_unsure, legal_review_needed, needs_legal_review(open_textured(provider_acted_intentionally_or_negligently, cite(eu_reg_2024_1689_art_101_1)), [inputs_relied_on([provider_acted_intentionally_or_negligently - unsure])]), []).
expected_answer(model_fine_intent_settled, union_maximum_determined, fine_maximum(3000000000, turnover_percentage), [cite(eu_reg_2024_1689_art_101_1), cite(eu_reg_2024_1689_art_101_1_a)]).
expected_answer(model_fine_intent_unsure_act_absent, information_missing, indeterminate([general_purpose_ai_model_infringement]), []).
expected_answer(model_fine_provider_absent, information_missing, indeterminate([offender_is_general_purpose_ai_model_provider]), []).
expected_answer(model_fine_turnover_absent, information_missing, indeterminate([worldwide_annual_turnover_eur]), []).
expected_answer(model_fine_information_request, union_maximum_determined, fine_maximum(6000000000, turnover_percentage), [cite(eu_reg_2024_1689_art_101_1), cite(eu_reg_2024_1689_art_101_1_b)]).
expected_answer(model_fine_measure_at_boundary, union_maximum_determined, fine_maximum(1500000000, fixed_amount), [cite(eu_reg_2024_1689_art_101_1), cite(eu_reg_2024_1689_art_101_1_c)]).
expected_answer(model_fine_measure_above_boundary, union_maximum_determined, fine_maximum(1500000003, turnover_percentage), [cite(eu_reg_2024_1689_art_101_1), cite(eu_reg_2024_1689_art_101_1_c)]).
expected_answer(model_fine_access_small_provider, union_maximum_determined, fine_maximum(1500000000, fixed_amount), [cite(eu_reg_2024_1689_art_101_1), cite(eu_reg_2024_1689_art_101_1_d)]).
expected_answer(model_fine_ignores_small_or_medium_category, union_maximum_determined, fine_maximum(1500000000, fixed_amount), [cite(eu_reg_2024_1689_art_101_1), cite(eu_reg_2024_1689_art_101_1_a)]).
expected_answer(model_fine_input_problems, input_rejected, input_problems([wrong_type(offender_is_general_purpose_ai_model_provider)]), []).

subject_answers(Subject, Verdicts) :-
    penalties_profile_for(Subject, Request),
    findall(Verdict, decide_penalties(Request, Verdict), Verdicts).

answer_differs(Subject) :-
    expected_answer(Subject, Status, Maximum, Citations),
    subject_answers(Subject, Verdicts),
    dif(Verdicts, [penalties_verdict(Status, Maximum, Citations)]).

matched_subject(Subject) :-
    expected_answer(Subject, Status, Maximum, Citations),
    subject_answers(Subject, [penalties_verdict(Status, Maximum, Citations)]).

test(every_subject_gets_its_expected_answer_alone) :-
    findall(Subject, penalties_subject(Subject), Subjects),
    msort(Subjects, SortedSubjects),
    findall(Subject, matched_subject(Subject), Matched),
    msort(Matched, SortedMatched),
    SortedMatched == SortedSubjects.
test(the_day_before_the_pinned_text_reads_out_the_earlier_version) :-
    findall(Maximum - Citations, maximum_fine([attribute(offender_category, not_an_undertaking), attribute(infringement, prohibited_practice)], date(2026, 7, 26), Maximum, Citations), Answers),
    Answers == [earlier_version_applies - []].
test(the_pinned_text_start_reads_out_the_cap) :-
    findall(Maximum - Citations, maximum_fine([attribute(offender_category, not_an_undertaking), attribute(infringement, prohibited_practice)], date(2026, 7, 27), Maximum, Citations), Answers),
    Answers == [fine_maximum(3500000000, fixed_amount) - [cite(eu_reg_2024_1689_art_99_3)]].
test(the_first_of_december_reads_out_not_applicable) :-
    findall(Maximum, maximum_fine([attribute(offender_category, union_institution_body_office_or_agency), attribute(infringement, prohibited_practice_under_article_5_1_ba_bb_1a_or_1b)], date(2026, 12, 1), Maximum, _), Answers),
    Answers == [not_applicable_on_date].
test(the_second_of_december_reads_out_the_article_100_2_cap) :-
    findall(Maximum, maximum_fine([attribute(offender_category, union_institution_body_office_or_agency), attribute(infringement, prohibited_practice_under_article_5_1_ba_bb_1a_or_1b)], date(2026, 12, 2), Maximum, _), Answers),
    Answers == [fine_maximum(150000000, fixed_amount)].
test(the_first_of_august_reads_out_no_model_fine) :-
    findall(Maximum, general_purpose_ai_model_maximum_fine([], date(2026, 8, 1), Maximum, _), Answers),
    Answers == [not_applicable_on_date].
test(the_second_of_august_reads_out_the_first_missing_key) :-
    findall(Maximum, general_purpose_ai_model_maximum_fine([], date(2026, 8, 2), Maximum, _), Answers),
    Answers == [indeterminate([offender_is_general_purpose_ai_model_provider])].
test(an_absent_judgement_is_named_after_the_act) :-
    findall(Maximum, general_purpose_ai_model_maximum_fine([attribute(offender_is_general_purpose_ai_model_provider, true), attribute(general_purpose_ai_model_infringement, infringed_relevant_provisions)], date(2026, 9, 1), Maximum, _), Answers),
    Answers == [indeterminate([provider_acted_intentionally_or_negligently])].
test(a_missing_turnover_is_named_before_an_unsure_judgement) :-
    findall(Maximum, general_purpose_ai_model_maximum_fine([attribute(offender_is_general_purpose_ai_model_provider, true), attribute(general_purpose_ai_model_infringement, infringed_relevant_provisions), attribute(provider_acted_intentionally_or_negligently, unsure)], date(2026, 9, 1), Maximum, _), Answers),
    Answers == [indeterminate([worldwide_annual_turnover_eur])].

test(no_expected_answer_differs, fail) :-
    answer_differs(_).

cp_test_names([every_subject_gets_its_expected_answer_alone, the_day_before_the_pinned_text_reads_out_the_earlier_version, the_pinned_text_start_reads_out_the_cap, the_first_of_december_reads_out_not_applicable, the_second_of_december_reads_out_the_article_100_2_cap, the_first_of_august_reads_out_no_model_fine, the_second_of_august_reads_out_the_first_missing_key, an_absent_judgement_is_named_after_the_act, a_missing_turnover_is_named_before_an_unsure_judgement]).
cp_test_fail_names([no_expected_answer_differs]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
