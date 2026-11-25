% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_review_report_format_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_dora_rts_review_report_format_dora_rts_review_report_format, [decide_dora_rts_review_report_format/2, dora_rts_review_report_format_status/2, dora_rts_review_report_format_checklist/2, ict_risk_framework_review_report_duties_required/3, ict_risk_framework_review_report_duties_complete/3, ict_risk_framework_review_report_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_review_report_format_fixtures, [dora_rts_review_report_format_profile_for/2]).
:- use_module(m__eu_dora_rts_review_report_format_kernel, [dora_rts_review_report_format_input_problems/2]).

baseline_required_citations([cite(eu_reg_2024_1774_art_27_1), cite(eu_reg_2024_1774_art_27_2), cite(eu_reg_2024_1774_art_27_2_a_i), cite(eu_reg_2024_1774_art_27_2_a_ii), cite(eu_reg_2024_1774_art_27_2_a_iii), cite(eu_reg_2024_1774_art_27_2_a_iv), cite(eu_reg_2024_1774_art_27_2_b), cite(eu_reg_2024_1774_art_27_2_c), cite(eu_reg_2024_1774_art_27_2_d), cite(eu_reg_2024_1774_art_27_2_e), cite(eu_reg_2024_1774_art_27_2_f), cite(eu_reg_2024_1774_art_27_2_g), cite(eu_reg_2024_1774_art_27_2_h_i), cite(eu_reg_2024_1774_art_27_2_h_ii), cite(eu_reg_2024_1774_art_27_2_h_iii), cite(eu_reg_2024_1774_art_27_2_h_iv), cite(eu_reg_2024_1774_art_27_2_h_v), cite(eu_reg_2024_1774_art_27_2_i), cite(eu_reg_2024_1774_art_27_2_j), cite(eu_reg_2024_1774_art_27_2_k_i), cite(eu_reg_2024_1774_art_27_2_k_ii), cite(eu_reg_2024_1774_art_27_2_l_i), cite(eu_reg_2024_1774_art_27_2_l_ii), cite(eu_reg_2024_1774_art_27_2_l_iii), cite(eu_reg_2024_1774_art_27_2_l_iv)]).

item_is_cited(item(_, _, [_|_])).

test(the_baseline_profile_yields_exactly_one_status) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    findall(Status, dora_rts_review_report_format_status(Profile, Status), Statuses),
    Statuses == [complete].
test(the_verdict_carries_a_citation) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    decide_dora_rts_review_report_format(Profile, dora_rts_review_report_format_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(the_baseline_requires_twenty_five_duties_with_their_citations) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    ict_risk_framework_review_report_duties_required(Profile, Result, Citations),
    Result = required(Duties),
    length(Duties, 25),
    Duties = [report_in_searchable_electronic_format|_],
    last(Duties, report_uses_external_sources),
    member(report_uses_internal_audit_results, Duties),
    baseline_required_citations(Expected),
    sort(Expected, ExpectedSorted),
    sort(Citations, ActualSorted),
    ActualSorted == ExpectedSorted.
test(every_condition_holding_requires_all_twenty_nine_duties) :-
    dora_rts_review_report_format_profile_for(all_conditions_complete, Profile),
    ict_risk_framework_review_report_duties_required(Profile, required(Duties), Citations),
    length(Duties, 29),
    member(cite(eu_reg_2024_1774_art_27_2_h_vi), Citations),
    member(cite(eu_reg_2024_1774_art_27_2_k_iii), Citations),
    member(cite(eu_reg_2024_1774_art_27_2_l_i), Citations).
test(the_missing_item_is_read_out) :-
    dora_rts_review_report_format_profile_for(missing_executive_summary, Profile),
    ict_risk_framework_review_report_duties_outstanding(Profile, Result, Citations),
    Result == outstanding([report_gives_executive_summary]),
    Citations == [cite(eu_reg_2024_1774_art_27_2_a_iv)].
test(the_supervisory_references_cite_point_c_and_the_paragraph) :-
    dora_rts_review_report_format_profile_for(supervisory_initiation_references_missing, Profile),
    ict_risk_framework_review_report_duties_outstanding(Profile, Result, Citations),
    Result == outstanding([report_references_initiating_instructions_or_conclusions]),
    sort(Citations, Sorted),
    Sorted == [cite(eu_reg_2024_1774_art_27_2), cite(eu_reg_2024_1774_art_27_2_c)].
test(the_referral_relies_on_every_present_pair) :-
    dora_rts_review_report_format_profile_for(unsure_format, Profile),
    ict_risk_framework_review_report_duties_complete(Profile, Result, Citations),
    Citations == [],
    Result = needs_legal_review(Reason, [inputs_relied_on(Pairs)|_]),
    Reason == open_textured(review_report_in_searchable_electronic_format, cite(eu_reg_2024_1774_art_27_1)),
    length(Pairs, 36),
    Pairs = [financial_entity_is_article_16_1_entity - false|_],
    member(review_report_in_searchable_electronic_format - unsure, Pairs).
test(an_absent_key_is_named_before_an_unsure_one) :-
    dora_rts_review_report_format_profile_for(absent_beats_unsure, Profile),
    ict_risk_framework_review_report_duties_complete(Profile, Result, Citations),
    Result == indeterminate([review_report_gives_executive_summary]),
    Citations == [].
test(a_false_duty_decides_before_an_unsure_one) :-
    dora_rts_review_report_format_profile_for(false_beats_unsure, Profile),
    ict_risk_framework_review_report_duties_complete(Profile, Result, _),
    Result == incomplete.
test(the_trigger_over_a_false_duty_is_named) :-
    dora_rts_review_report_format_profile_for(microenterprise_absent_audit_missing, Profile),
    ict_risk_framework_review_report_duties_complete(Profile, CompleteResult, _),
    CompleteResult == indeterminate([financial_entity_is_microenterprise]),
    ict_risk_framework_review_report_duties_outstanding(Profile, OutstandingResult, _),
    OutstandingResult == indeterminate([financial_entity_is_microenterprise]).
test(a_non_list_profile_reads_out_one_problem) :-
    dora_rts_review_report_format_profile_for(not_attribute_list, Profile),
    dora_rts_review_report_format_input_problems(Profile, Problems),
    Problems == [wrong_type(profile)].
test(unsure_for_a_fact_reads_out_a_wrong_type) :-
    dora_rts_review_report_format_profile_for(input_wrong_type_fact, Profile),
    ict_risk_framework_review_report_duties_required(Profile, Result, Citations),
    Result == input_problems([wrong_type(financial_entity_is_microenterprise)]),
    Citations == [].
test(the_checklist_cites_every_row) :-
    dora_rts_review_report_format_profile_for(scheduled_review_complete, Profile),
    dora_rts_review_report_format_checklist(Profile, Items),
    length(Items, 31),
    maplist(item_is_cited, Items).

cp_test_names([the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, the_baseline_requires_twenty_five_duties_with_their_citations, every_condition_holding_requires_all_twenty_nine_duties, the_missing_item_is_read_out, the_supervisory_references_cite_point_c_and_the_paragraph, the_referral_relies_on_every_present_pair, an_absent_key_is_named_before_an_unsure_one, a_false_duty_decides_before_an_unsure_one, the_trigger_over_a_false_duty_is_named, a_non_list_profile_reads_out_one_problem, unsure_for_a_fact_reads_out_a_wrong_type, the_checklist_cites_every_row]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
