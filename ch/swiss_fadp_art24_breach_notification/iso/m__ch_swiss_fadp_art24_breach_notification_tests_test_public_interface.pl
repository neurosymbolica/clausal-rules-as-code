% SPDX-License-Identifier: EUPL-1.2
:- module(m__ch_swiss_fadp_art24_breach_notification_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_swiss_fadp_art24_breach_notification, [decide_swiss_fadp_art24_breach_notification/2, swiss_fadp_art24_breach_notification_status/2, swiss_fadp_art24_breach_notification_checklist/2, swiss_fadp_art24_breach_notification_decision_resolvable/1, swiss_fadp_art24_breach_notification_status_values/1, swiss_controller_report_to_commissioner/3, swiss_processor_report_to_controller/3, swiss_information_of_data_subject/3, eu_controller_notification_to_supervisory_authority/3, compare_swiss_eu_authority_notification/5]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_fixtures, [swiss_fadp_art24_breach_notification_subject/1, swiss_fadp_art24_breach_notification_profile_for/2, swiss_fadp_art24_breach_notification_assess/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_kernel, [swiss_fadp_art24_breach_notification_input_problems/2]).
:- use_module(m__ch_swiss_fadp_art24_breach_notification_queries, [swiss_fadp_art24_breach_notification_what_if/4, swiss_fadp_art24_breach_notification_obligations/2, swiss_fadp_art24_breach_notification_profile_keys/1]).

expected_status(high_risk_breach_all_duties, authority_notification_required).
expected_status(breach_without_high_risk, authority_notification_not_required).
expected_status(no_breach, authority_notification_not_required).
expected_status(breach_only, indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights])).
expected_status(controller_unsure_breach, needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), [inputs_relied_on([breach_of_data_security - unsure, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights - true])])).
expected_status(controller_unsure_breach_settled_by_risk, authority_notification_not_required).
expected_status(information_commissioner_request_with_public_announcement, indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights])).
expected_status(information_commissioner_request_without_exception, indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights])).
expected_status(information_ground_failed, indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights])).
expected_status(information_exception_unsure, indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights])).
expected_status(information_exception_unsure_settled_by_announcement, indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights])).
expected_status(eu_unlikely_risk_settles_absent_breach, indeterminate([breach_of_data_security])).
expected_status(eu_not_unlikely_risk_absent_breach, indeterminate([breach_of_data_security])).
expected_status(swiss_and_eu_both_true_thresholds, authority_notification_required).
expected_status(duplicate_and_unknown_keys, input_problems([duplicate_key(breach_of_data_security), unknown_key(colour)])).
expected_status(crisp_key_unsure, input_problems([wrong_type(commissioner_requested_information_of_data_subject)])).
expected_status(crisp_key_true, indeterminate([breach_of_data_security])).
expected_status(not_an_attribute_list, input_problems([wrong_type(profile)])).

controller_citations([cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]).

processor_citations([cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]).

information_not_required_citations([cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4)]).

information_final_citations([cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]).

european_citations([cite(eu_reg_2016_679_art_33_1)]).

subject_profile(Subject, Profile) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile).

subject_has_expected_status(Subject - Expected) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    findall(Status, swiss_fadp_art24_breach_notification_status(Profile, Status), Statuses),
    Statuses == [Expected].

answers_each_query_once(Subject) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    findall(Result, swiss_controller_report_to_commissioner(Profile, Result, _), ControllerAnswers),
    length(ControllerAnswers, 1),
    findall(Result, swiss_processor_report_to_controller(Profile, Result, _), ProcessorAnswers),
    length(ProcessorAnswers, 1),
    findall(Result, swiss_information_of_data_subject(Profile, Result, _), InformationAnswers),
    length(InformationAnswers, 1),
    findall(Result, eu_controller_notification_to_supervisory_authority(Profile, Result, _), EuropeanAnswers),
    length(EuropeanAnswers, 1),
    findall(Difference, compare_swiss_eu_authority_notification(Profile, _, _, Difference, _), ComparisonAnswers),
    length(ComparisonAnswers, 1),
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems(Profile, Problems), ProblemAnswers),
    length(ProblemAnswers, 1),
    findall(Verdict, swiss_fadp_art24_breach_notification_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

checklist_rows_carry_provenance(Subject) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    swiss_fadp_art24_breach_notification_checklist(Profile, [FirstItem|OtherItems]),
    maplist(item_cites, [FirstItem|OtherItems]).

item_cites(item(_, _, [cite(_)|_])).

test(every_subject_has_an_expected_status) :-
    findall(Subject, swiss_fadp_art24_breach_notification_subject(Subject), Subjects),
    findall(Subject, expected_status(Subject, _), ExpectedSubjects),
    msort(Subjects, SortedSubjects),
    msort(ExpectedSubjects, SortedExpected),
    SortedSubjects == SortedExpected.
test(every_subject_resolves_to_its_expected_status) :-
    findall(Subject - Expected, expected_status(Subject, Expected), Expectations),
    maplist(subject_has_expected_status, Expectations).
test(every_subject_answers_each_query_exactly_once) :-
    findall(Subject, swiss_fadp_art24_breach_notification_subject(Subject), Subjects),
    maplist(answers_each_query_once, Subjects).
test(every_subject_has_a_cited_checklist) :-
    findall(Subject, swiss_fadp_art24_breach_notification_subject(Subject), Subjects),
    maplist(checklist_rows_carry_provenance, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, swiss_fadp_art24_breach_notification_subject(Subject), Subjects),
    maplist(subject_resolvable, Subjects).
test(profile_keys_are_the_nine_contract_keys) :-
    swiss_fadp_art24_breach_notification_profile_keys(Keys),
    length(Keys, 9).
test(high_risk_breach_requires_the_report) :-
    controller_citations(Citations),
    findall(Verdict, swiss_fadp_art24_breach_notification_assess(high_risk_breach_all_duties, Verdict), Verdicts),
    Verdicts == [swiss_fadp_art24_breach_notification_verdict(authority_notification_required, Citations)].
test(breach_without_high_risk_needs_no_report) :-
    controller_citations(Citations),
    findall(Verdict, swiss_fadp_art24_breach_notification_assess(breach_without_high_risk, Verdict), Verdicts),
    Verdicts == [swiss_fadp_art24_breach_notification_verdict(authority_notification_not_required, Citations)].
test(unsure_breach_goes_to_a_lawyer_with_empty_citations) :-
    subject_profile(controller_unsure_breach, Profile),
    findall(Citations, swiss_controller_report_to_commissioner(Profile, _, Citations), CitationAnswers),
    CitationAnswers == [[]].
test(unsure_breach_settled_by_false_risk) :-
    controller_citations(Citations),
    subject_profile(controller_unsure_breach_settled_by_risk, Profile),
    findall(Result - Given, swiss_controller_report_to_commissioner(Profile, Result, Given), Answers),
    Answers == [authority_notification_not_required - Citations].
test(final_headline_statuses_are_status_values) :-
    swiss_fadp_art24_breach_notification_status_values(StatusValues),
    swiss_fadp_art24_breach_notification_assess(high_risk_breach_all_duties, swiss_fadp_art24_breach_notification_verdict(RequiredStatus, _)),
    member(RequiredStatus, StatusValues),
    swiss_fadp_art24_breach_notification_assess(no_breach, swiss_fadp_art24_breach_notification_verdict(NotRequiredStatus, _)),
    member(NotRequiredStatus, StatusValues).
test(provenance_is_the_optional_trailing_context_item) :-
    Context = [inputs_relied_on([breach_of_data_security - unsure]), provenance(ch_fadp_art_5_h, swiss_fadp_art24_breach_notification)],
    maplist(context_item_kind, Context, Kinds),
    Kinds == [pairs, provenance],
    Context = [_, TrailingItem],
    functor(TrailingItem, provenance, 2).
test(referral_context_carries_no_provenance_item) :-
    subject_profile(controller_unsure_breach, Profile),
    swiss_controller_report_to_commissioner(Profile, needs_legal_review(_, Context), _),
    maplist(context_item_kind, Context, Kinds),
    Kinds == [pairs].
test(processor_reports_every_breach) :-
    processor_citations(Citations),
    subject_profile(breach_only, Profile),
    findall(Result - Given, swiss_processor_report_to_controller(Profile, Result, Given), Answers),
    Answers == [report_to_controller_required - Citations].
test(processor_reports_without_high_risk) :-
    subject_profile(breach_without_high_risk, Profile),
    findall(Result, swiss_processor_report_to_controller(Profile, Result, _), Results),
    Results == [report_to_controller_required].
test(processor_no_breach_no_report) :-
    processor_citations(Citations),
    subject_profile(no_breach, Profile),
    findall(Result - Given, swiss_processor_report_to_controller(Profile, Result, Given), Answers),
    Answers == [report_to_controller_not_required - Citations].
test(processor_absent_breach_is_named) :-
    subject_profile(eu_unlikely_risk_settles_absent_breach, Profile),
    findall(Result - Given, swiss_processor_report_to_controller(Profile, Result, Given), Answers),
    Answers == [indeterminate([breach_of_data_security]) - []].
test(information_required_when_necessary_and_no_exception) :-
    information_final_citations(Citations),
    subject_profile(high_risk_breach_all_duties, Profile),
    findall(Result - Given, swiss_information_of_data_subject(Profile, Result, Given), Answers),
    Answers == [information_of_data_subject_required - Citations].
test(information_may_be_restricted_on_request_with_announcement) :-
    information_final_citations(Citations),
    subject_profile(information_commissioner_request_with_public_announcement, Profile),
    findall(Result - Given, swiss_information_of_data_subject(Profile, Result, Given), Answers),
    Answers == [information_of_data_subject_may_be_restricted_deferred_or_omitted - Citations].
test(information_on_request_without_exception_is_required) :-
    subject_profile(information_commissioner_request_without_exception, Profile),
    findall(Result, swiss_information_of_data_subject(Profile, Result, _), Results),
    Results == [information_of_data_subject_required].
test(information_not_required_when_ground_fails) :-
    information_not_required_citations(Citations),
    subject_profile(information_ground_failed, Profile),
    findall(Result - Given, swiss_information_of_data_subject(Profile, Result, Given), Answers),
    Answers == [information_of_data_subject_not_required - Citations].
test(information_unsure_exception_goes_to_a_lawyer) :-
    subject_profile(information_exception_unsure, Profile),
    findall(Result - Given, swiss_information_of_data_subject(Profile, Result, Given), Answers),
    Answers == [needs_legal_review(open_textured(information_impossible_or_requires_disproportionate_effort, cite(ch_fadp_art_24_5_b)), [inputs_relied_on([breach_of_data_security - true, information_necessary_for_protection_of_data_subject - true, article_26_ground_or_statutory_secrecy_obligation_applies - false, information_impossible_or_requires_disproportionate_effort - unsure, information_ensured_comparably_by_public_announcement - false])]) - []].
test(information_unsure_exception_settled_by_announcement) :-
    subject_profile(information_exception_unsure_settled_by_announcement, Profile),
    findall(Result, swiss_information_of_data_subject(Profile, Result, _), Results),
    Results == [information_of_data_subject_may_be_restricted_deferred_or_omitted].
test(information_breach_only_names_necessity) :-
    subject_profile(breach_only, Profile),
    findall(Result, swiss_information_of_data_subject(Profile, Result, _), Results),
    Results == [indeterminate([information_necessary_for_protection_of_data_subject])].
test(eu_notification_required) :-
    european_citations(Citations),
    subject_profile(high_risk_breach_all_duties, Profile),
    findall(Result - Given, eu_controller_notification_to_supervisory_authority(Profile, Result, Given), Answers),
    Answers == [authority_notification_required - Citations].
test(eu_unlikely_risk_settles_absent_breach) :-
    european_citations(Citations),
    subject_profile(eu_unlikely_risk_settles_absent_breach, Profile),
    findall(Result - Given, eu_controller_notification_to_supervisory_authority(Profile, Result, Given), Answers),
    Answers == [authority_notification_not_required - Citations].
test(eu_not_unlikely_risk_names_the_breach) :-
    subject_profile(eu_not_unlikely_risk_absent_breach, Profile),
    findall(Result - Given, eu_controller_notification_to_supervisory_authority(Profile, Result, Given), Answers),
    Answers == [indeterminate([personal_data_breach]) - []].
test(comparison_same_on_high_risk_breach) :-
    subject_profile(high_risk_breach_all_duties, Profile),
    findall(answer(SwissResult, EuropeanResult, Difference, ChangedBy), compare_swiss_eu_authority_notification(Profile, SwissResult, EuropeanResult, Difference, ChangedBy), Answers),
    Answers == [answer(authority_notification_required, authority_notification_required, same, [])].
test(comparison_same_on_no_breach) :-
    subject_profile(no_breach, Profile),
    findall(Difference - ChangedBy, compare_swiss_eu_authority_notification(Profile, _, _, Difference, ChangedBy), Answers),
    Answers == [same - []].
test(comparison_differs_without_high_risk) :-
    subject_profile(breach_without_high_risk, Profile),
    findall(answer(SwissResult, EuropeanResult, Difference, ChangedBy), compare_swiss_eu_authority_notification(Profile, SwissResult, EuropeanResult, Difference, ChangedBy), Answers),
    Answers == [answer(authority_notification_not_required, authority_notification_required, differs, [cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)])].
test(comparison_differs_when_both_thresholds_true) :-
    subject_profile(swiss_and_eu_both_true_thresholds, Profile),
    findall(answer(SwissResult, EuropeanResult, Difference, ChangedBy), compare_swiss_eu_authority_notification(Profile, SwissResult, EuropeanResult, Difference, ChangedBy), Answers),
    Answers == [answer(authority_notification_required, authority_notification_not_required, differs, [cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)])].
test(comparison_not_comparable_keeps_each_side) :-
    subject_profile(breach_only, Profile),
    findall(answer(SwissResult, EuropeanResult, Difference, ChangedBy), compare_swiss_eu_authority_notification(Profile, SwissResult, EuropeanResult, Difference, ChangedBy), Answers),
    Answers == [answer(indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights]), indeterminate([personal_data_breach]), not_comparable, [])].
test(comparison_with_input_problems) :-
    subject_profile(duplicate_and_unknown_keys, Profile),
    findall(answer(SwissResult, EuropeanResult, Difference, ChangedBy), compare_swiss_eu_authority_notification(Profile, SwissResult, EuropeanResult, Difference, ChangedBy), Answers),
    Answers == [answer(input_problems([duplicate_key(breach_of_data_security), unknown_key(colour)]), input_problems([duplicate_key(breach_of_data_security), unknown_key(colour)]), not_comparable, [])].
test(input_check_duplicate_and_unknown) :-
    subject_profile(duplicate_and_unknown_keys, Profile),
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(breach_of_data_security), unknown_key(colour)]].
test(input_check_crisp_key_unsure) :-
    subject_profile(crisp_key_unsure, Profile),
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(commissioner_requested_information_of_data_subject)]].
test(input_check_crisp_key_true_is_clean) :-
    subject_profile(crisp_key_true, Profile),
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(input_check_not_an_attribute_list) :-
    subject_profile(not_an_attribute_list, Profile),
    findall(Problems, swiss_fadp_art24_breach_notification_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(input_check_unbound_profile) :-
    findall(Result - Citations, swiss_controller_report_to_commissioner(_, Result, Citations), Answers),
    Answers == [input_problems([wrong_type(profile)]) - []].
test(input_check_well_formed_fixture_is_clean) :-
    subject_profile(high_risk_breach_all_duties, Profile),
    swiss_fadp_art24_breach_notification_input_problems(Profile, []).
test(what_if_high_risk_true_requires_the_report) :-
    subject_profile(breach_without_high_risk, Profile),
    findall(Status, swiss_fadp_art24_breach_notification_what_if(Profile, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, true, Status), Statuses),
    Statuses == [authority_notification_required].
test(what_if_high_risk_false_removes_the_report) :-
    subject_profile(high_risk_breach_all_duties, Profile),
    findall(Status, swiss_fadp_art24_breach_notification_what_if(Profile, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, false, Status), Statuses),
    Statuses == [authority_notification_not_required].
test(what_if_supplies_a_missing_key) :-
    subject_profile(breach_only, Profile),
    findall(Status, swiss_fadp_art24_breach_notification_what_if(Profile, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, true, Status), Statuses),
    Statuses == [authority_notification_required].
test(what_if_unknown_key_is_an_input_problem) :-
    subject_profile(breach_only, Profile),
    findall(Status, swiss_fadp_art24_breach_notification_what_if(Profile, colour, red, Status), Statuses),
    Statuses == [input_problems([unknown_key(colour)])].
test(what_if_bad_crisp_value_is_an_input_problem) :-
    subject_profile(breach_only, Profile),
    findall(Status, swiss_fadp_art24_breach_notification_what_if(Profile, commissioner_requested_information_of_data_subject, unsure, Status), Statuses),
    Statuses == [input_problems([wrong_type(commissioner_requested_information_of_data_subject)])].
test(obligations_of_a_high_risk_breach) :-
    controller_citations(ControllerCitations),
    processor_citations(ProcessorCitations),
    information_final_citations(InformationCitations),
    european_citations(EuropeanCitations),
    subject_profile(high_risk_breach_all_duties, Profile),
    findall(Obligations, swiss_fadp_art24_breach_notification_obligations(Profile, Obligations), Answers),
    Answers == [[duty(controller, report_to_commissioner, authority_notification_required, ControllerCitations), duty(processor, report_to_controller, report_to_controller_required, ProcessorCitations), duty(controller, inform_data_subject, information_of_data_subject_required, InformationCitations), duty(controller, notify_eu_supervisory_authority, authority_notification_required, EuropeanCitations)]].
test(obligations_of_no_breach) :-
    subject_profile(no_breach, Profile),
    swiss_fadp_art24_breach_notification_obligations(Profile, [duty(controller, report_to_commissioner, authority_notification_not_required, _), duty(processor, report_to_controller, report_to_controller_not_required, _), duty(controller, inform_data_subject, information_of_data_subject_not_required, _), duty(controller, notify_eu_supervisory_authority, authority_notification_not_required, _)]).
test(obligations_with_input_problems) :-
    subject_profile(not_an_attribute_list, Profile),
    swiss_fadp_art24_breach_notification_obligations(Profile, [duty(controller, report_to_commissioner, input_problems([wrong_type(profile)]), []), duty(processor, report_to_controller, input_problems([wrong_type(profile)]), []), duty(controller, inform_data_subject, input_problems([wrong_type(profile)]), []), duty(controller, notify_eu_supervisory_authority, input_problems([wrong_type(profile)]), [])]).
test(checklist_of_a_high_risk_breach) :-
    subject_profile(high_risk_breach_all_duties, Profile),
    swiss_fadp_art24_breach_notification_checklist(Profile, Items),
    Items = [item(controller_report_to_commissioner, authority_notification_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]), item(processor_report_to_controller, report_to_controller_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]), item(information_of_data_subject, information_of_data_subject_required, [cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]), item(eu_notification_to_supervisory_authority, authority_notification_required, [cite(eu_reg_2016_679_art_33_1)])].

subject_resolvable(Subject) :-
    swiss_fadp_art24_breach_notification_profile_for(Subject, Profile),
    swiss_fadp_art24_breach_notification_decision_resolvable(Profile).

test(high_risk_breach_is_not_not_required, fail) :-
    swiss_fadp_art24_breach_notification_assess(high_risk_breach_all_duties, swiss_fadp_art24_breach_notification_verdict(authority_notification_not_required, _)).
test(breach_without_high_risk_is_not_required, fail) :-
    swiss_fadp_art24_breach_notification_assess(breach_without_high_risk, swiss_fadp_art24_breach_notification_verdict(authority_notification_required, _)).
test(referral_context_holds_no_provenance, fail) :-
    subject_profile(controller_unsure_breach, Profile),
    swiss_controller_report_to_commissioner(Profile, needs_legal_review(_, Context), _),
    member(provenance(_, _), Context).
test(processor_no_breach_is_not_required, fail) :-
    subject_profile(no_breach, Profile),
    swiss_processor_report_to_controller(Profile, report_to_controller_required, _).
test(information_with_announcement_is_not_plainly_required, fail) :-
    subject_profile(information_commissioner_request_with_public_announcement, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_required, _).
test(information_ground_failed_is_not_required, fail) :-
    subject_profile(information_ground_failed, Profile),
    swiss_information_of_data_subject(Profile, information_of_data_subject_required, _).
test(eu_unlikely_risk_is_not_required, fail) :-
    subject_profile(eu_unlikely_risk_settles_absent_breach, Profile),
    eu_controller_notification_to_supervisory_authority(Profile, authority_notification_required, _).
test(comparison_high_risk_breach_does_not_differ, fail) :-
    subject_profile(high_risk_breach_all_duties, Profile),
    compare_swiss_eu_authority_notification(Profile, _, _, differs, _).

context_item_kind(inputs_relied_on(_), pairs).
context_item_kind(provenance(_, _), provenance).

cp_test_names([every_subject_has_an_expected_status, every_subject_resolves_to_its_expected_status, every_subject_answers_each_query_exactly_once, every_subject_has_a_cited_checklist, every_subject_is_resolvable, profile_keys_are_the_nine_contract_keys, high_risk_breach_requires_the_report, breach_without_high_risk_needs_no_report, unsure_breach_goes_to_a_lawyer_with_empty_citations, unsure_breach_settled_by_false_risk, final_headline_statuses_are_status_values, provenance_is_the_optional_trailing_context_item, referral_context_carries_no_provenance_item, processor_reports_every_breach, processor_reports_without_high_risk, processor_no_breach_no_report, processor_absent_breach_is_named, information_required_when_necessary_and_no_exception, information_may_be_restricted_on_request_with_announcement, information_on_request_without_exception_is_required, information_not_required_when_ground_fails, information_unsure_exception_goes_to_a_lawyer, information_unsure_exception_settled_by_announcement, information_breach_only_names_necessity, eu_notification_required, eu_unlikely_risk_settles_absent_breach, eu_not_unlikely_risk_names_the_breach, comparison_same_on_high_risk_breach, comparison_same_on_no_breach, comparison_differs_without_high_risk, comparison_differs_when_both_thresholds_true, comparison_not_comparable_keeps_each_side, comparison_with_input_problems, input_check_duplicate_and_unknown, input_check_crisp_key_unsure, input_check_crisp_key_true_is_clean, input_check_not_an_attribute_list, input_check_unbound_profile, input_check_well_formed_fixture_is_clean, what_if_high_risk_true_requires_the_report, what_if_high_risk_false_removes_the_report, what_if_supplies_a_missing_key, what_if_unknown_key_is_an_input_problem, what_if_bad_crisp_value_is_an_input_problem, obligations_of_a_high_risk_breach, obligations_of_no_breach, obligations_with_input_problems, checklist_of_a_high_risk_breach]).
cp_test_fail_names([high_risk_breach_is_not_not_required, breach_without_high_risk_is_not_required, referral_context_holds_no_provenance, processor_no_breach_is_not_required, information_with_announcement_is_not_plainly_required, information_ground_failed_is_not_required, eu_unlikely_risk_is_not_required, comparison_high_risk_breach_does_not_differ]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
