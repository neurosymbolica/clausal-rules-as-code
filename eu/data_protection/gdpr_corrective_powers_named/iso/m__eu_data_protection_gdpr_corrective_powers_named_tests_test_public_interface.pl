% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_corrective_powers_named_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_gdpr_corrective_powers_named, [corrective_powers_named/3, corrective_power_named/4, decide_gdpr_corrective_powers_named/2, gdpr_corrective_powers_named_status/2, gdpr_corrective_powers_named_checklist/2, gdpr_corrective_powers_named_decision_resolvable/1, gdpr_corrective_powers_named_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_kernel, [gdpr_corrective_powers_named_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_queries, [gdpr_corrective_powers_named_profile_keys/1, gdpr_corrective_powers_named_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_corrective_powers_named_fixtures, [gdpr_corrective_powers_named_subject/1, gdpr_corrective_powers_named_profile_for/2, gdpr_corrective_powers_named_assess/2]).

all_citations([cite(eu_reg_2016_679_art_58_2), cite(eu_reg_2016_679_art_58_2_a), cite(eu_reg_2016_679_art_58_2_b), cite(eu_reg_2016_679_art_58_2_c), cite(eu_reg_2016_679_art_58_2_d), cite(eu_reg_2016_679_art_58_2_e), cite(eu_reg_2016_679_art_58_2_f), cite(eu_reg_2016_679_art_58_2_g), cite(eu_reg_2016_679_art_58_2_h), cite(eu_reg_2016_679_art_58_2_i), cite(eu_reg_2016_679_art_58_2_j)]).

expected_result(all_false, powers_named([], authority_discretion)).
expected_result(intended_infringement, powers_named([power(warning, [controller, processor]), power(limitation_or_ban_on_processing, [])], authority_discretion)).
expected_result(past_infringement, powers_named([power(reprimand, [controller, processor]), power(limitation_or_ban_on_processing, []), power(administrative_fine, [])], authority_discretion)).
expected_result(non_compliance_only, powers_named([power(order_to_bring_processing_into_compliance, [controller, processor]), power(limitation_or_ban_on_processing, [])], authority_discretion)).
expected_result(breach_and_request, powers_named([power(order_to_comply_with_data_subject_requests, [controller, processor]), power(order_to_communicate_personal_data_breach, [controller])], authority_discretion)).
expected_result(breach_stated_plainly, powers_named([power(order_to_communicate_personal_data_breach, [controller])], authority_discretion)).
expected_result(certification_failing, powers_named([power(withdrawal_or_refusal_of_certification, [certification_body])], authority_discretion)).
expected_result(certification_requirements_met, powers_named([], authority_discretion)).
expected_result(certification_not_held, powers_named([], authority_discretion)).
expected_result(third_country_flows, powers_named([power(suspension_of_data_flows, [])], authority_discretion)).
expected_result(everything_true, powers_named([power(warning, [controller, processor]), power(reprimand, [controller, processor]), power(order_to_comply_with_data_subject_requests, [controller, processor]), power(order_to_bring_processing_into_compliance, [controller, processor]), power(order_to_communicate_personal_data_breach, [controller]), power(limitation_or_ban_on_processing, []), power(order_of_rectification_erasure_or_restriction, []), power(withdrawal_or_refusal_of_certification, [certification_body]), power(administrative_fine, []), power(suspension_of_data_flows, [])], authority_discretion)).
expected_result(missing_flows, indeterminate([data_flows_to_third_country_or_international_organisation])).
expected_result(missing_certification_key, indeterminate([certification_issued_or_applied_for])).
expected_result(unsure_infringement, needs_legal_review(open_textured(processing_has_infringed, cite(eu_reg_2016_679_art_58_2_b)), [inputs_relied_on([intended_processing_likely_to_infringe - false, processing_has_infringed - unsure, data_subject_request_to_exercise_rights_made - false, processing_not_in_compliance - false, personal_data_breach_occurred - false, rectification_erasure_or_restriction_ground_met - false, certification_issued_or_applied_for - false, certification_requirements_not_met - false, data_flows_to_third_country_or_international_organisation - false])])).
expected_result(unsure_requirements, needs_legal_review(open_textured(certification_requirements_not_met, cite(eu_reg_2016_679_art_58_2_h)), [inputs_relied_on([intended_processing_likely_to_infringe - false, processing_has_infringed - false, data_subject_request_to_exercise_rights_made - false, processing_not_in_compliance - false, personal_data_breach_occurred - false, rectification_erasure_or_restriction_ground_met - false, certification_issued_or_applied_for - true, certification_requirements_not_met - unsure, data_flows_to_third_country_or_international_organisation - false])])).
expected_result(attested_value, input_problems([wrong_type(personal_data_breach_occurred)])).
expected_result(duplicate_and_unknown, input_problems([duplicate_key(processing_has_infringed), unknown_key(fine_amount)])).

citations_expected(powers_named(_, _), Citations) :-
    all_citations(Citations).
citations_expected(indeterminate(_), []).
citations_expected(needs_legal_review(_, _), []).
citations_expected(input_problems(_), []).

same_citations(Citations, Wanted) :-
    clausal_msort(Citations, SortedCitations),
    clausal_msort(Wanted, SortedWanted),
    SortedCitations == SortedWanted.

subjects_resolve([]).
subjects_resolve([Subject|Subjects]) :-
    expected_result(Subject, Expected),
    findall(Result - Citations, gdpr_corrective_powers_named_assess(Subject, gdpr_corrective_powers_named_verdict(Result, Citations)), Answers),
    Answers = [Result - Citations],
    Result == Expected,
    citations_expected(Expected, Wanted),
    same_citations(Citations, Wanted),
    subjects_resolve(Subjects).

subjects_have_checklists([]).
subjects_have_checklists([Subject|Subjects]) :-
    gdpr_corrective_powers_named_profile_for(Subject, Profile),
    findall(Items, gdpr_corrective_powers_named_checklist(Profile, Items), [Checklist]),
    Checklist = [_|_],
    items_cited(Checklist),
    subjects_have_checklists(Subjects).

items_cited([]).
items_cited([item(_, _, cite(CitationKey))|Items]) :-
    atom(CitationKey),
    items_cited(Items).

registered_subjects(Subjects) :-
    findall(Subject, gdpr_corrective_powers_named_subject(Subject), Subjects).

test(every_subject_has_an_expected_result) :-
    registered_subjects(Subjects),
    findall(Subject, expected_result(Subject, _), ExpectedSubjects),
    clausal_msort(Subjects, SortedSubjects),
    clausal_msort(ExpectedSubjects, SortedExpected),
    SortedSubjects == SortedExpected.
test(every_subject_resolves_once_to_its_expected_result) :-
    registered_subjects(Subjects),
    subjects_resolve(Subjects).
test(every_subject_has_a_cited_checklist) :-
    registered_subjects(Subjects),
    subjects_have_checklists(Subjects).
test(every_result_functor_is_in_the_status_values) :-
    gdpr_corrective_powers_named_assess(everything_true, gdpr_corrective_powers_named_verdict(Result, _)),
    functor(Result, Name, _),
    gdpr_corrective_powers_named_status_values(StatusValues),
    member(Name, StatusValues).
test(status_and_resolvable_agree_with_the_verdict) :-
    gdpr_corrective_powers_named_profile_for(past_infringement, Profile),
    gdpr_corrective_powers_named_decision_resolvable(Profile),
    findall(Result, gdpr_corrective_powers_named_status(Profile, Result), [Result]),
    corrective_powers_named(Profile, Result, _).
test(past_infringement_names_the_reprimand) :-
    gdpr_corrective_powers_named_profile_for(past_infringement, Profile),
    corrective_power_named(Profile, reprimand, named([controller, processor], authority_discretion), [cite(eu_reg_2016_679_art_58_2), cite(eu_reg_2016_679_art_58_2_b)]).
test(all_false_does_not_name_the_reprimand) :-
    gdpr_corrective_powers_named_profile_for(all_false, Profile),
    corrective_power_named(Profile, reprimand, not_named, [cite(eu_reg_2016_679_art_58_2), cite(eu_reg_2016_679_art_58_2_b)]).
test(intended_infringement_names_the_warning) :-
    gdpr_corrective_powers_named_profile_for(intended_infringement, Profile),
    corrective_power_named(Profile, warning, named([controller, processor], authority_discretion), _).
test(intended_infringement_does_not_name_the_fine) :-
    gdpr_corrective_powers_named_profile_for(intended_infringement, Profile),
    corrective_power_named(Profile, administrative_fine, not_named, _).
test(certification_failing_names_the_withdrawal) :-
    gdpr_corrective_powers_named_profile_for(certification_failing, Profile),
    corrective_power_named(Profile, withdrawal_or_refusal_of_certification, named([certification_body], authority_discretion), [cite(eu_reg_2016_679_art_58_2), cite(eu_reg_2016_679_art_58_2_h)]).
test(certification_requirements_met_does_not_name_the_withdrawal) :-
    gdpr_corrective_powers_named_profile_for(certification_requirements_met, Profile),
    corrective_power_named(Profile, withdrawal_or_refusal_of_certification, not_named, _).
test(certification_not_held_settles_before_the_unsure) :-
    gdpr_corrective_powers_named_profile_for(certification_not_held, Profile),
    findall(Result, corrective_power_named(Profile, withdrawal_or_refusal_of_certification, Result, _), Results),
    Results == [not_named].
test(unsure_requirements_refers_the_point) :-
    gdpr_corrective_powers_named_profile_for(unsure_requirements, Profile),
    findall(Result - Citations, corrective_power_named(Profile, withdrawal_or_refusal_of_certification, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(certification_requirements_not_met, cite(eu_reg_2016_679_art_58_2_h)), [inputs_relied_on([certification_issued_or_applied_for - true, certification_requirements_not_met - unsure])]) - []].
test(missing_certification_key_names_the_issued_key_first) :-
    gdpr_corrective_powers_named_profile_for(missing_certification_key, Profile),
    corrective_power_named(Profile, withdrawal_or_refusal_of_certification, indeterminate([certification_issued_or_applied_for]), []).
test(third_country_flows_names_the_suspension) :-
    gdpr_corrective_powers_named_profile_for(third_country_flows, Profile),
    corrective_power_named(Profile, suspension_of_data_flows, named([], authority_discretion), _).
test(missing_flows_leaves_the_suspension_open) :-
    gdpr_corrective_powers_named_profile_for(missing_flows, Profile),
    corrective_power_named(Profile, suspension_of_data_flows, indeterminate([data_flows_to_third_country_or_international_organisation]), []).
test(unsure_infringement_refers_the_fine) :-
    gdpr_corrective_powers_named_profile_for(unsure_infringement, Profile),
    corrective_power_named(Profile, administrative_fine, needs_legal_review(open_textured(processing_has_infringed, cite(eu_reg_2016_679_art_58_2_b)), [inputs_relied_on([processing_has_infringed - unsure])]), []).
test(breach_stated_plainly_names_the_order_to_the_controller) :-
    gdpr_corrective_powers_named_profile_for(breach_stated_plainly, Profile),
    corrective_power_named(Profile, order_to_communicate_personal_data_breach, named([controller], authority_discretion), _).
test(attested_value_is_refused_for_every_measure) :-
    gdpr_corrective_powers_named_profile_for(attested_value, Profile),
    corrective_power_named(Profile, warning, input_problems([wrong_type(personal_data_breach_occurred)]), []).
test(each_measure_answers_once_on_everything_true) :-
    gdpr_corrective_powers_named_profile_for(everything_true, Profile),
    findall(Measure - Result, (member(Measure, [warning, reprimand, order_to_comply_with_data_subject_requests, order_to_bring_processing_into_compliance, order_to_communicate_personal_data_breach, limitation_or_ban_on_processing, order_of_rectification_erasure_or_restriction, withdrawal_or_refusal_of_certification, administrative_fine, suspension_of_data_flows]), corrective_power_named(Profile, Measure, Result, _)), Answers),
    length(Answers, 10).
test(an_unread_key_does_not_change_the_warning) :-
    corrective_power_named([attribute(intended_processing_likely_to_infringe, true)], warning, named([controller, processor], authority_discretion), _),
    gdpr_corrective_powers_named_profile_for(everything_true, Profile),
    corrective_power_named(Profile, warning, named([controller, processor], authority_discretion), _).
test(an_unknown_measure_comes_after_the_profile_problems) :-
    gdpr_corrective_powers_named_profile_for(attested_value, Profile),
    findall(Result, corrective_power_named(Profile, caution, Result, _), Results),
    Results == [input_problems([wrong_type(personal_data_breach_occurred), wrong_type(measure)])].
test(an_unbound_measure_is_not_enumerated) :-
    findall(Result, corrective_power_named([], _, Result, _), Results),
    Results == [input_problems([wrong_type(measure)])].
test(a_well_formed_profile_has_no_problem) :-
    gdpr_corrective_powers_named_profile_for(everything_true, Profile),
    gdpr_corrective_powers_named_input_problems(Profile, []).
test(an_unbound_profile_is_wrong_type) :-
    findall(Problems, gdpr_corrective_powers_named_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_wrong_type) :-
    gdpr_corrective_powers_named_input_problems([attribute(processing_has_infringed, true)|_], [wrong_type(profile)]).
test(a_stray_element_is_wrong_type) :-
    gdpr_corrective_powers_named_input_problems([foo], [wrong_type(profile)]).
test(an_unbound_key_is_unknown_as_given) :-
    gdpr_corrective_powers_named_input_problems([attribute(UnboundKey, true)], [unknown_key(ReportedKey)]),
    ReportedKey == UnboundKey.
test(an_unbound_value_is_wrong_type) :-
    gdpr_corrective_powers_named_input_problems([attribute(processing_has_infringed, _)], [wrong_type(processing_has_infringed)]).
test(a_crisp_key_refuses_unsure) :-
    gdpr_corrective_powers_named_input_problems([attribute(certification_issued_or_applied_for, unsure)], [wrong_type(certification_issued_or_applied_for)]).
test(a_judgement_key_accepts_unsure) :-
    gdpr_corrective_powers_named_input_problems([attribute(certification_requirements_not_met, unsure)], []).
test(what_if_infringement_names_reprimand_limitation_and_fine) :-
    gdpr_corrective_powers_named_profile_for(all_false, Profile),
    findall(Result, gdpr_corrective_powers_named_what_if(Profile, processing_has_infringed, true, Result), Results),
    expected_result(past_infringement, Expected),
    Results == [Expected].
test(what_if_supplying_the_flows_settles_the_list) :-
    gdpr_corrective_powers_named_profile_for(missing_flows, Profile),
    gdpr_corrective_powers_named_what_if(Profile, data_flows_to_third_country_or_international_organisation, true, powers_named([power(suspension_of_data_flows, [])], authority_discretion)).
test(what_if_a_bad_value_is_refused) :-
    gdpr_corrective_powers_named_profile_for(all_false, Profile),
    gdpr_corrective_powers_named_what_if(Profile, personal_data_breach_occurred, unsure, input_problems([wrong_type(personal_data_breach_occurred)])).
test(profile_keys_has_the_nine_keys) :-
    gdpr_corrective_powers_named_profile_keys(ProfileKeys),
    length(ProfileKeys, 9).
test(the_facade_verdict_matches_the_query) :-
    gdpr_corrective_powers_named_profile_for(certification_failing, Profile),
    decide_gdpr_corrective_powers_named(Profile, gdpr_corrective_powers_named_verdict(Result, Citations)),
    corrective_powers_named(Profile, Result, Citations).

test(all_false_gives_no_named_reprimand, fail) :-
    gdpr_corrective_powers_named_profile_for(all_false, Profile),
    corrective_power_named(Profile, reprimand, named(_, _), _).
test(certification_requirements_met_gives_no_named_withdrawal, fail) :-
    gdpr_corrective_powers_named_profile_for(certification_requirements_met, Profile),
    corrective_power_named(Profile, withdrawal_or_refusal_of_certification, named(_, _), _).
test(missing_flows_gives_no_named_suspension, fail) :-
    gdpr_corrective_powers_named_profile_for(missing_flows, Profile),
    corrective_power_named(Profile, suspension_of_data_flows, named(_, _), _).
test(unsure_infringement_gives_no_named_fine, fail) :-
    gdpr_corrective_powers_named_profile_for(unsure_infringement, Profile),
    corrective_power_named(Profile, administrative_fine, named(_, _), _).
test(attested_value_gives_no_named_order, fail) :-
    gdpr_corrective_powers_named_profile_for(attested_value, Profile),
    corrective_power_named(Profile, order_to_communicate_personal_data_breach, named(_, _), _).

cp_test_names([every_subject_has_an_expected_result, every_subject_resolves_once_to_its_expected_result, every_subject_has_a_cited_checklist, every_result_functor_is_in_the_status_values, status_and_resolvable_agree_with_the_verdict, past_infringement_names_the_reprimand, all_false_does_not_name_the_reprimand, intended_infringement_names_the_warning, intended_infringement_does_not_name_the_fine, certification_failing_names_the_withdrawal, certification_requirements_met_does_not_name_the_withdrawal, certification_not_held_settles_before_the_unsure, unsure_requirements_refers_the_point, missing_certification_key_names_the_issued_key_first, third_country_flows_names_the_suspension, missing_flows_leaves_the_suspension_open, unsure_infringement_refers_the_fine, breach_stated_plainly_names_the_order_to_the_controller, attested_value_is_refused_for_every_measure, each_measure_answers_once_on_everything_true, an_unread_key_does_not_change_the_warning, an_unknown_measure_comes_after_the_profile_problems, an_unbound_measure_is_not_enumerated, a_well_formed_profile_has_no_problem, an_unbound_profile_is_wrong_type, a_partial_list_is_wrong_type, a_stray_element_is_wrong_type, an_unbound_key_is_unknown_as_given, an_unbound_value_is_wrong_type, a_crisp_key_refuses_unsure, a_judgement_key_accepts_unsure, what_if_infringement_names_reprimand_limitation_and_fine, what_if_supplying_the_flows_settles_the_list, what_if_a_bad_value_is_refused, profile_keys_has_the_nine_keys, the_facade_verdict_matches_the_query]).
cp_test_fail_names([all_false_gives_no_named_reprimand, certification_requirements_met_gives_no_named_withdrawal, missing_flows_gives_no_named_suspension, unsure_infringement_gives_no_named_fine, attested_value_gives_no_named_order]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
