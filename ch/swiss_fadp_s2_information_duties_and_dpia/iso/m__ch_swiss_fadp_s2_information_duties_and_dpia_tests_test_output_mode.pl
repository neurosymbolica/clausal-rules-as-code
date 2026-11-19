% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_s2_information_duties_and_dpia_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_swiss_fadp_s2_information_duties_and_dpia, [decide_swiss_fadp_s2_information_duties_and_dpia/2, swiss_fadp_s2_information_duties_and_dpia_status/2, swiss_information_duty/3, swiss_minimum_information_item/4, swiss_automated_decision_review/3, swiss_automated_decision_marking/3, swiss_impact_assessment/3, eu_information_duty/3, eu_automated_decision_information/3, eu_impact_assessment/3, compare_swiss_eu_automated_decision_information/5, compare_swiss_eu_impact_assessment/5]).
:- use_module(m__ch_swiss_fadp_s2_information_duties_and_dpia_fixtures, [swiss_fadp_s2_information_duties_and_dpia_profile_for/2]).

test(the_baseline_profile_yields_exactly_one_status) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(private_controller_must_inform, Profile),
    findall(Status, swiss_fadp_s2_information_duties_and_dpia_status(Profile, Status), Statuses),
    Statuses == [information_required].
test(the_verdict_carries_its_fixed_citations) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(private_controller_must_inform, Profile),
    findall(Verdict, decide_swiss_fadp_s2_information_duties_and_dpia(Profile, Verdict), Verdicts),
    Verdicts == [swiss_fadp_s2_information_duties_and_dpia_verdict(information_required, [cite(ch_fadp_art_19_1), cite(ch_fadp_art_20_1), cite(ch_fadp_art_20_2), cite(ch_fadp_art_20_3)])].
test(not_required_reads_out_its_citations) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(private_secrecy_exception, Profile),
    findall(Result - Citations, swiss_information_duty(Profile, Result, Citations), Answers),
    Answers == [information_not_required - [cite(ch_fadp_art_19_1), cite(ch_fadp_art_20_1), cite(ch_fadp_art_20_1_a), cite(ch_fadp_art_20_1_b), cite(ch_fadp_art_20_1_c), cite(ch_fadp_art_20_1_d), cite(ch_fadp_art_20_2), cite(ch_fadp_art_20_2_a), cite(ch_fadp_art_20_2_b)]].
test(restriction_reads_out_its_citations) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(federal_investigation_restriction, Profile),
    findall(Result - Citations, swiss_information_duty(Profile, Result, Citations), Answers),
    Answers == [information_may_be_restricted_deferred_or_omitted - [cite(ch_fadp_art_19_1), cite(ch_fadp_art_20_3), cite(ch_fadp_art_20_3_a), cite(ch_fadp_art_20_3_b), cite(ch_fadp_art_20_3_c), cite(ch_fadp_art_20_3_c_1), cite(ch_fadp_art_20_3_c_2), cite(ch_fadp_art_20_3_d), cite(ch_fadp_art_20_3_d_1), cite(ch_fadp_art_20_3_d_2), cite(ch_fadp_art_20_4)]].
test(minimum_items_of_a_disclosure_abroad) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(disclosure_abroad_with_safeguards, Profile),
    findall(Item - Result, swiss_minimum_information_item(Profile, Item, Result, _), _Unbound),
    findall(Result, swiss_minimum_information_item(Profile, categories_of_personal_data_processed, Result, _), Categories),
    Categories == [information_item_required],
    findall(Result, swiss_minimum_information_item(Profile, safeguards_or_exception_relied_on, Result, _), Safeguards),
    Safeguards == [information_item_required],
    findall(Result, swiss_minimum_information_item(Profile, recipients_or_categories_of_recipients, Result, _), Recipients),
    Recipients == [information_item_required].
test(minimum_item_open_names_its_key) :-
    findall(Result - Citations, swiss_minimum_information_item([], recipients_or_categories_of_recipients, Result, Citations), Answers),
    Answers == [indeterminate([personal_data_disclosed_to_recipients]) - []].
test(review_without_hearing_reads_out_do_not_apply) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(federal_automated_decision_without_hearing, Profile),
    findall(Result, swiss_automated_decision_review(Profile, Result, _), Results),
    Results == [view_and_review_rights_do_not_apply].
test(marking_reads_out_its_citations) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(federal_automated_decision_without_hearing, Profile),
    findall(Result - Citations, swiss_automated_decision_marking(Profile, Result, Citations), Answers),
    Answers == [decision_marking_required - [cite(ch_fadp_art_21_1), cite(ch_fadp_art_21_4)]].
test(impact_assessment_exempt_reads_out_its_citations) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(private_controller_obliged_by_law, Profile),
    findall(Result - Citations, swiss_impact_assessment(Profile, Result, Citations), Answers),
    Answers == [impact_assessment_not_required - [cite(ch_fadp_art_22_1), cite(ch_fadp_art_22_2), cite(ch_fadp_art_22_2_a), cite(ch_fadp_art_22_2_b), cite(ch_fadp_art_22_4)]].
test(eu_duty_reads_out_not_required) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(eu_indirect_professional_secrecy, Profile),
    findall(Result, eu_information_duty(Profile, Result, _), Results),
    Results == [information_not_required].
test(eu_automated_reads_out_required) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(automated_decision_both_regimes, Profile),
    findall(Result, eu_automated_decision_information(Profile, Result, _), Results),
    Results == [automated_decision_information_required].
test(eu_impact_exempt_reads_out_not_required) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(eu_article_35_10_exemption, Profile),
    findall(Result, eu_impact_assessment(Profile, Result, _), Results),
    Results == [impact_assessment_not_required].
test(unsure_judgement_reads_out_a_referral) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(already_informed_unsure, Profile),
    findall(Result - Citations, swiss_information_duty(Profile, Result, Citations), [needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]) - Cited]),
    Key == data_subject_already_has_information,
    Citation == cite(ch_fadp_art_20_1_a),
    Cited == [],
    member(data_subject_already_has_information - unsure, Pairs).
test(automated_comparison_reads_out_differs) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(automated_decision_eu_already_informed, Profile),
    findall(answer(Swiss, Eu, Difference, ChangedBy), compare_swiss_eu_automated_decision_information(Profile, Swiss, Eu, Difference, ChangedBy), Answers),
    Answers == [answer(automated_decision_information_required, automated_decision_information_not_required, differs, [cite(ch_fadp_art_21_1), cite(ch_fadp_art_21_3), cite(eu_reg_2016_679_art_13_2_f), cite(eu_reg_2016_679_art_14_2_g), cite(eu_reg_2016_679_art_13_4), cite(eu_reg_2016_679_art_14_5), cite(eu_reg_2016_679_art_22_1)])].
test(impact_comparison_permission_differs) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(certified_system_may_omit_assessment, Profile),
    findall(answer(Swiss, Eu, Difference, ChangedBy), compare_swiss_eu_impact_assessment(Profile, Swiss, Eu, Difference, ChangedBy), Answers),
    Answers == [answer(impact_assessment_may_be_omitted, impact_assessment_not_required, differs, [cite(ch_fadp_art_22_1), cite(ch_fadp_art_22_2), cite(ch_fadp_art_22_4), cite(ch_fadp_art_22_5), cite(eu_reg_2016_679_art_35_1), cite(eu_reg_2016_679_art_35_3), cite(eu_reg_2016_679_art_35_10)])].
test(impact_comparison_same_has_no_changed_by) :-
    swiss_fadp_s2_information_duties_and_dpia_profile_for(high_risk_both_regimes, Profile),
    findall(answer(Swiss, Eu, Difference, ChangedBy), compare_swiss_eu_impact_assessment(Profile, Swiss, Eu, Difference, ChangedBy), Answers),
    Answers == [answer(impact_assessment_required, impact_assessment_required, same, [])].

cp_test_names([the_baseline_profile_yields_exactly_one_status, the_verdict_carries_its_fixed_citations, not_required_reads_out_its_citations, restriction_reads_out_its_citations, minimum_items_of_a_disclosure_abroad, minimum_item_open_names_its_key, review_without_hearing_reads_out_do_not_apply, marking_reads_out_its_citations, impact_assessment_exempt_reads_out_its_citations, eu_duty_reads_out_not_required, eu_automated_reads_out_required, eu_impact_exempt_reads_out_not_required, unsure_judgement_reads_out_a_referral, automated_comparison_reads_out_differs, impact_comparison_permission_differs, impact_comparison_same_has_no_changed_by]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
