% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_swiss_fadp_art24_breach_notification, [decide_swiss_fadp_art24_breach_notification/2, swiss_fadp_art24_breach_notification_status/2, swiss_fadp_art24_breach_notification_checklist/2, swiss_fadp_art24_breach_notification_decision_resolvable/1, swiss_fadp_art24_breach_notification_status_values/1]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_fixtures, [swiss_fadp_art24_breach_notification_subject/1, swiss_fadp_art24_breach_notification_profile_for/2, swiss_fadp_art24_breach_notification_assess/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_swiss_fadp_art24_breach_notification, [swiss_controller_report_to_commissioner/3, swiss_processor_report_to_controller/3, swiss_information_of_data_subject/3, eu_controller_notification_to_supervisory_authority/3, compare_swiss_eu_authority_notification/5]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_kernel, [swiss_fadp_art24_breach_notification_input_problems/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_queries, [swiss_fadp_art24_breach_notification_what_if/4, swiss_fadp_art24_breach_notification_profile_keys/1]).

controller_answers(Subject, Answers) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    findall(Result - Citations, swiss_controller_report_to_commissioner(Profile, Result, Citations), Answers).

processor_answers(Subject, Answers) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    findall(Result - Citations, swiss_processor_report_to_controller(Profile, Result, Citations), Answers).

information_answers(Subject, Answers) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    findall(Result - Citations, swiss_information_of_data_subject(Profile, Result, Citations), Answers).

union_answers(Subject, Answers) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    findall(Result - Citations, eu_controller_notification_to_supervisory_authority(Profile, Result, Citations), Answers).

comparison_answers(Subject, Answers) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    findall(answer(SwissResult, UnionResult, Difference, ChangedBy), compare_swiss_eu_authority_notification(Profile, SwissResult, UnionResult, Difference, ChangedBy), Answers).

problem_answers(Subject, Answers) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems(Profile, Problems), Answers).

single_verdict(Subject) :-
    findall(Verdict, swiss_fadp_art24_breach_notification_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

cited_checklist(Subject) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    findall(Items, swiss_fadp_art24_breach_notification_checklist(Profile, Items), Checklists),
    Checklists = [Checklist],
    length(Checklist, 4),
    maplist(cited_item, Checklist).

cited_item(item(_, _, cite(_))).

resolvable_subject(Subject) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    swiss_fadp_art24_breach_notification_decision_resolvable(Profile).

sides_copied(Subject) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    swiss_controller_report_to_commissioner(Profile, SwissResult, _SwissCitations),
    eu_controller_notification_to_supervisory_authority(Profile, UnionResult, _UnionCitations),
    compare_swiss_eu_authority_notification(Profile, ComparedSwiss, ComparedUnion, _Difference, _ChangedBy),
    ComparedSwiss == SwissResult,
    ComparedUnion == UnionResult.

all_subjects(Subjects) :-
    findall(Subject, swiss_fadp_art24_breach_notification_subject(Subject), Subjects).

test(there_are_twenty_fixture_subjects) :-
    all_subjects(Subjects),
    length(Subjects, 20).
test(every_subject_has_exactly_one_verdict) :-
    all_subjects(Subjects),
    maplist(single_verdict, Subjects).
test(every_subject_has_a_four_item_cited_checklist) :-
    all_subjects(Subjects),
    maplist(cited_checklist, Subjects).
test(every_subject_is_resolvable) :-
    all_subjects(Subjects),
    maplist(resolvable_subject, Subjects).
test(the_comparison_copies_both_sides_on_every_subject) :-
    all_subjects(Subjects),
    maplist(sides_copied, Subjects).
test(the_profile_schema_lists_the_nine_contract_keys) :-
    swiss_fadp_art24_breach_notification_profile_keys(ProfileKeys),
    ProfileKeys == [breach_of_data_security, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, information_necessary_for_protection_of_data_subject, commissioner_requested_information_of_data_subject, article_26_ground_or_statutory_secrecy_obligation_applies, information_impossible_or_requires_disproportionate_effort, information_ensured_comparably_by_public_announcement, personal_data_breach, breach_unlikely_to_result_in_risk].
test(all_duties_owed_verdict_is_required) :-
    swiss_fadp_art24_breach_notification_assess(all_duties_owed, swiss_fadp_art24_breach_notification_verdict(authority_notification_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)])).
test(all_duties_owed_status_is_a_status_value) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    swiss_fadp_art24_breach_notification_status(Profile, Status),
    swiss_fadp_art24_breach_notification_status_values(StatusValues),
    member(Status, StatusValues).
test(all_duties_owed_decide_and_status_agree) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    decide_swiss_fadp_art24_breach_notification(Profile, swiss_fadp_art24_breach_notification_verdict(Status, _Citations)),
    swiss_fadp_art24_breach_notification_status(Profile, Status).
test(all_duties_owed_controller_must_report) :-
    controller_answers(all_duties_owed, Answers),
    Answers == [authority_notification_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]].
test(all_duties_owed_processor_must_report) :-
    processor_answers(all_duties_owed, Answers),
    Answers == [report_to_controller_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]].
test(all_duties_owed_data_subject_must_be_informed) :-
    information_answers(all_duties_owed, Answers),
    Answers == [information_of_data_subject_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]].
test(all_duties_owed_union_notification_required) :-
    union_answers(all_duties_owed, Answers),
    Answers == [authority_notification_required - [cite(eu_reg_2016_679_art_33_1)]].
test(all_duties_owed_comparison_is_same) :-
    comparison_answers(all_duties_owed, Answers),
    Answers == [answer(authority_notification_required, authority_notification_required, same, [])].
test(all_duties_owed_checklist_items) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    swiss_fadp_art24_breach_notification_checklist(Profile, Items),
    Items == [item(controller_report_to_commissioner, authority_notification_required, cite(ch_fadp_art_24_1)), item(processor_report_to_controller, report_to_controller_required, cite(ch_fadp_art_24_3)), item(information_of_data_subject, information_of_data_subject_required, cite(ch_fadp_art_24_4)), item(eu_notification_to_supervisory_authority, authority_notification_required, cite(eu_reg_2016_679_art_33_1))].
test(high_risk_false_control_verdict_is_not_required) :-
    swiss_fadp_art24_breach_notification_assess(high_risk_false_control, swiss_fadp_art24_breach_notification_verdict(authority_notification_not_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)])).
test(high_risk_false_control_comparison_differs) :-
    comparison_answers(high_risk_false_control, Answers),
    Answers == [answer(authority_notification_not_required, authority_notification_required, differs, [cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)])].
test(high_risk_false_control_information_still_required) :-
    information_answers(high_risk_false_control, Answers),
    Answers == [information_of_data_subject_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]].
test(what_if_high_risk_true_turns_the_control_into_required) :-
    swiss_fadp_art24_breach_notification_profile_for(high_risk_false_control, Profile),
    findall(Status, swiss_fadp_art24_breach_notification_what_if(Profile, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, true, Status), Statuses),
    Statuses == [authority_notification_required].
test(what_if_high_risk_false_turns_the_positive_into_not_required) :-
    swiss_fadp_art24_breach_notification_profile_for(all_duties_owed, Profile),
    findall(Status, swiss_fadp_art24_breach_notification_what_if(Profile, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, false, Status), Statuses),
    Statuses == [authority_notification_not_required].
test(no_breach_verdict_is_not_required) :-
    swiss_fadp_art24_breach_notification_assess(no_breach, swiss_fadp_art24_breach_notification_verdict(authority_notification_not_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)])).
test(no_breach_processor_need_not_report) :-
    processor_answers(no_breach, Answers),
    Answers == [report_to_controller_not_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]].
test(no_breach_data_subject_need_not_be_informed) :-
    information_answers(no_breach, Answers),
    Answers == [information_of_data_subject_not_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4)]].
test(no_breach_union_side_names_its_missing_key) :-
    union_answers(no_breach, Answers),
    Answers == [indeterminate([personal_data_breach]) - []].
test(no_breach_comparison_not_comparable) :-
    comparison_answers(no_breach, Answers),
    Answers == [answer(authority_notification_not_required, indeterminate([personal_data_breach]), not_comparable, [])].
test(public_announcement_exception_may_be_restricted) :-
    information_answers(public_announcement_exception, Answers),
    Answers == [information_of_data_subject_may_be_restricted_deferred_or_omitted - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]].
test(public_announcement_exception_verdict_is_required) :-
    swiss_fadp_art24_breach_notification_assess(public_announcement_exception, swiss_fadp_art24_breach_notification_verdict(authority_notification_required, _)).
test(public_announcement_false_control_must_inform) :-
    information_answers(public_announcement_false_control, Answers),
    Answers == [information_of_data_subject_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]].
test(commissioner_request_with_exception_may_be_restricted) :-
    information_answers(commissioner_request_with_exception, Answers),
    Answers == [information_of_data_subject_may_be_restricted_deferred_or_omitted - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]].
test(commissioner_request_with_exception_verdict_names_high_risk) :-
    swiss_fadp_art24_breach_notification_assess(commissioner_request_with_exception, swiss_fadp_art24_breach_notification_verdict(indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]), [])).
test(commissioner_request_only_must_inform) :-
    information_answers(commissioner_request_only, Answers),
    Answers == [information_of_data_subject_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]].
test(ground_failed_need_not_inform) :-
    information_answers(ground_failed, Answers),
    Answers == [information_of_data_subject_not_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4)]].
test(ground_failed_processor_still_reports) :-
    processor_answers(ground_failed, Answers),
    Answers == [report_to_controller_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]].
test(high_risk_absent_controller_names_the_missing_key) :-
    controller_answers(high_risk_absent, Answers),
    Answers == [indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]) - []].
test(high_risk_absent_verdict_is_indeterminate) :-
    swiss_fadp_art24_breach_notification_assess(high_risk_absent, swiss_fadp_art24_breach_notification_verdict(indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]), [])).
test(high_risk_absent_processor_must_report) :-
    processor_answers(high_risk_absent, Answers),
    Answers == [report_to_controller_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]].
test(breach_unsure_high_risk_absent_names_missing_before_unsure) :-
    controller_answers(breach_unsure_high_risk_absent, Answers),
    Answers == [indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]) - []].
test(breach_unsure_controller_refers_the_breach) :-
    controller_answers(breach_unsure, Answers),
    Answers == [needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), [inputs_relied_on([breach_of_data_security - unsure, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights - true])]) - []].
test(breach_unsure_verdict_is_a_referral) :-
    swiss_fadp_art24_breach_notification_assess(breach_unsure, swiss_fadp_art24_breach_notification_verdict(needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), _), [])).
test(breach_unsure_processor_refers_the_breach) :-
    processor_answers(breach_unsure, Answers),
    Answers == [needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), [inputs_relied_on([breach_of_data_security - unsure])]) - []].
test(necessity_unsure_information_refers_necessity) :-
    information_answers(necessity_unsure, Answers),
    Answers == [needs_legal_review(open_textured(information_necessary_for_protection_of_data_subject, cite(ch_fadp_art_24_4)), [inputs_relied_on([breach_of_data_security - true, information_necessary_for_protection_of_data_subject - unsure, commissioner_requested_information_of_data_subject - false, article_26_ground_or_statutory_secrecy_obligation_applies - false, information_impossible_or_requires_disproportionate_effort - false, information_ensured_comparably_by_public_announcement - false])]) - []].
test(necessity_unsure_request_met_must_inform) :-
    information_answers(necessity_unsure_request_met, Answers),
    Answers == [information_of_data_subject_required - [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]].
test(exception_partly_open_names_the_missing_announcement) :-
    information_answers(exception_partly_open, Answers),
    Answers == [indeterminate([information_ensured_comparably_by_public_announcement]) - []].
test(the_optional_provenance_element_builds_and_destructures) :-
    Context = [inputs_relied_on([breach_of_data_security - unsure]), provenance(ch_fadp_art_5_h, swiss_processor_report_to_controller)],
    Context = [inputs_relied_on(Pairs), provenance(Source, Query)],
    Pairs == [breach_of_data_security - unsure],
    Source == ch_fadp_art_5_h,
    Query == swiss_processor_report_to_controller.
test(the_processor_referral_context_is_exactly_inputs_relied_on) :-
    processor_answers(breach_unsure, [needs_legal_review(_, Context) - []]),
    Context = [inputs_relied_on(_)].
test(eu_unsure_union_side_refers_the_breach) :-
    union_answers(eu_unsure, Answers),
    Answers == [needs_legal_review(open_textured(personal_data_breach, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([personal_data_breach - unsure, breach_unlikely_to_result_in_risk - false])]) - []].
test(eu_unsure_comparison_not_comparable) :-
    comparison_answers(eu_unsure, Answers),
    Answers == [answer(authority_notification_required, needs_legal_review(open_textured(personal_data_breach, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on([personal_data_breach - unsure, breach_unlikely_to_result_in_risk - false])]), not_comparable, [])].
test(eu_unsure_verdict_is_required) :-
    swiss_fadp_art24_breach_notification_assess(eu_unsure, swiss_fadp_art24_breach_notification_verdict(authority_notification_required, _)).
test(both_risk_judgements_true_comparison_differs) :-
    comparison_answers(both_risk_judgements_true, Answers),
    Answers == [answer(authority_notification_required, authority_notification_not_required, differs, [cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)])].
test(both_risk_judgements_true_union_not_required) :-
    union_answers(both_risk_judgements_true, Answers),
    Answers == [authority_notification_not_required - [cite(eu_reg_2016_679_art_33_1)]].
test(crisp_unsure_is_a_wrong_type) :-
    problem_answers(crisp_unsure, Answers),
    Answers == [[wrong_type(commissioner_requested_information_of_data_subject)]].
test(crisp_unsure_verdict_is_input_problems) :-
    swiss_fadp_art24_breach_notification_assess(crisp_unsure, swiss_fadp_art24_breach_notification_verdict(input_problems([wrong_type(commissioner_requested_information_of_data_subject)]), [])).
test(crisp_unsure_information_gives_input_problems) :-
    information_answers(crisp_unsure, Answers),
    Answers == [input_problems([wrong_type(commissioner_requested_information_of_data_subject)]) - []].
test(crisp_unsure_comparison_gives_input_problems_on_both_sides) :-
    comparison_answers(crisp_unsure, Answers),
    Answers == [answer(input_problems([wrong_type(commissioner_requested_information_of_data_subject)]), input_problems([wrong_type(commissioner_requested_information_of_data_subject)]), not_comparable, [])].
test(crisp_true_control_has_no_problems) :-
    problem_answers(crisp_true_control, Answers),
    Answers == [[]].
test(crisp_true_control_information_names_the_breach) :-
    information_answers(crisp_true_control, Answers),
    Answers == [indeterminate([breach_of_data_security]) - []].
test(duplicate_and_unknown_problems_in_order) :-
    problem_answers(duplicate_and_unknown, Answers),
    Answers == [[duplicate_key(breach_of_data_security), wrong_type(breach_unlikely_to_result_in_risk), unknown_key(severity)]].
test(duplicate_and_unknown_processor_gives_input_problems) :-
    processor_answers(duplicate_and_unknown, Answers),
    Answers == [input_problems([duplicate_key(breach_of_data_security), wrong_type(breach_unlikely_to_result_in_risk), unknown_key(severity)]) - []].
test(not_attribute_list_is_wrong_type_profile) :-
    problem_answers(not_attribute_list, Answers),
    Answers == [[wrong_type(profile)]].
test(not_attribute_list_union_gives_input_problems) :-
    union_answers(not_attribute_list, Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].

test(high_risk_false_control_is_not_required_to_report, fail) :-
    swiss_fadp_art24_breach_notification_assess(high_risk_false_control, swiss_fadp_art24_breach_notification_verdict(authority_notification_required, _)).
test(no_breach_processor_is_not_required, fail) :-
    processor_answers(no_breach, [report_to_controller_required - _]).
test(public_announcement_exception_is_not_plain_required, fail) :-
    information_answers(public_announcement_exception, [information_of_data_subject_required - _]).
test(public_announcement_false_control_may_not_omit, fail) :-
    information_answers(public_announcement_false_control, [information_of_data_subject_may_be_restricted_deferred_or_omitted - _]).
test(commissioner_request_only_is_not_omittable, fail) :-
    information_answers(commissioner_request_only, [information_of_data_subject_may_be_restricted_deferred_or_omitted - _]).
test(ground_failed_is_not_required, fail) :-
    information_answers(ground_failed, [information_of_data_subject_required - _]).
test(breach_unsure_high_risk_absent_is_not_a_referral, fail) :-
    controller_answers(breach_unsure_high_risk_absent, [needs_legal_review(_, _) - _]).
test(necessity_unsure_request_met_is_not_a_referral, fail) :-
    information_answers(necessity_unsure_request_met, [needs_legal_review(_, _) - _]).
test(the_processor_referral_carries_no_provenance_element, fail) :-
    processor_answers(breach_unsure, [needs_legal_review(_, [_, provenance(_, _)]) - _]).
test(both_risk_judgements_true_is_not_same, fail) :-
    comparison_answers(both_risk_judgements_true, [answer(_, _, same, _)]).
test(crisp_true_control_is_not_input_problems, fail) :-
    information_answers(crisp_true_control, [input_problems(_) - _]).

cp_test_names([there_are_twenty_fixture_subjects, every_subject_has_exactly_one_verdict, every_subject_has_a_four_item_cited_checklist, every_subject_is_resolvable, the_comparison_copies_both_sides_on_every_subject, the_profile_schema_lists_the_nine_contract_keys, all_duties_owed_verdict_is_required, all_duties_owed_status_is_a_status_value, all_duties_owed_decide_and_status_agree, all_duties_owed_controller_must_report, all_duties_owed_processor_must_report, all_duties_owed_data_subject_must_be_informed, all_duties_owed_union_notification_required, all_duties_owed_comparison_is_same, all_duties_owed_checklist_items, high_risk_false_control_verdict_is_not_required, high_risk_false_control_comparison_differs, high_risk_false_control_information_still_required, what_if_high_risk_true_turns_the_control_into_required, what_if_high_risk_false_turns_the_positive_into_not_required, no_breach_verdict_is_not_required, no_breach_processor_need_not_report, no_breach_data_subject_need_not_be_informed, no_breach_union_side_names_its_missing_key, no_breach_comparison_not_comparable, public_announcement_exception_may_be_restricted, public_announcement_exception_verdict_is_required, public_announcement_false_control_must_inform, commissioner_request_with_exception_may_be_restricted, commissioner_request_with_exception_verdict_names_high_risk, commissioner_request_only_must_inform, ground_failed_need_not_inform, ground_failed_processor_still_reports, high_risk_absent_controller_names_the_missing_key, high_risk_absent_verdict_is_indeterminate, high_risk_absent_processor_must_report, breach_unsure_high_risk_absent_names_missing_before_unsure, breach_unsure_controller_refers_the_breach, breach_unsure_verdict_is_a_referral, breach_unsure_processor_refers_the_breach, necessity_unsure_information_refers_necessity, necessity_unsure_request_met_must_inform, exception_partly_open_names_the_missing_announcement, the_optional_provenance_element_builds_and_destructures, the_processor_referral_context_is_exactly_inputs_relied_on, eu_unsure_union_side_refers_the_breach, eu_unsure_comparison_not_comparable, eu_unsure_verdict_is_required, both_risk_judgements_true_comparison_differs, both_risk_judgements_true_union_not_required, crisp_unsure_is_a_wrong_type, crisp_unsure_verdict_is_input_problems, crisp_unsure_information_gives_input_problems, crisp_unsure_comparison_gives_input_problems_on_both_sides, crisp_true_control_has_no_problems, crisp_true_control_information_names_the_breach, duplicate_and_unknown_problems_in_order, duplicate_and_unknown_processor_gives_input_problems, not_attribute_list_is_wrong_type_profile, not_attribute_list_union_gives_input_problems, an_unbound_profile_is_wrong_type_profile]).
cp_test_fail_names([high_risk_false_control_is_not_required_to_report, no_breach_processor_is_not_required, public_announcement_exception_is_not_plain_required, public_announcement_false_control_may_not_omit, commissioner_request_only_is_not_omittable, ground_failed_is_not_required, breach_unsure_high_risk_absent_is_not_a_referral, necessity_unsure_request_met_is_not_a_referral, the_processor_referral_carries_no_provenance_element, both_risk_judgements_true_is_not_same, crisp_true_control_is_not_input_problems]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
