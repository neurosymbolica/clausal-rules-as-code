% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_period_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_kernel, [gdpr_data_subject_rights_response_period_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_citations, [citation/2, implements/1]).

test(the_two_periods_are_distinct) :-
    dif(first_period, extended_period).
test(the_compound_statuses_are_distinct) :-
    dif(indeterminate, needs_legal_review),
    dif(indeterminate, input_problems),
    dif(needs_legal_review, input_problems).
test(a_period_is_not_a_compound_status) :-
    dif(first_period, indeterminate),
    dif(extended_period, needs_legal_review),
    dif(first_period, input_problems).
test(the_problem_items_are_distinct) :-
    dif(unknown_key(request_type), wrong_type(request_type)),
    dif(wrong_type(request_type), duplicate_key(request_type)),
    dif(unknown_key(request_type), duplicate_key(request_type)).
test(the_judgement_values_are_distinct) :-
    dif(unsure, true),
    dif(unsure, false),
    dif(true, false).
test(the_absent_marker_is_not_an_attested_term) :-
    dif(absent, attested(true, attestation(by, at, reason, none))).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = gdpr_data_subject_rights_response_period_verdict(first_period, [cite(eu_reg_2016_679_art_12_3)]),
    Verdict = gdpr_data_subject_rights_response_period_verdict(Status, Citations),
    Status == first_period,
    Citations == [cite(eu_reg_2016_679_art_12_3)].
test(the_indeterminate_term_names_the_missing_key) :-
    Result = indeterminate([extension_necessary_for_complexity_and_number]),
    Result = indeterminate(MissingKeys),
    MissingKeys == [extension_necessary_for_complexity_and_number].
test(the_referral_term_destructures) :-
    Result = needs_legal_review(open_textured(extension_necessary_for_complexity_and_number, cite(eu_reg_2016_679_art_12_3)), [inputs_relied_on([extension_necessary_for_complexity_and_number - unsure])]),
    Result = needs_legal_review(open_textured(Input, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Input == extension_necessary_for_complexity_and_number,
    CitationKey == eu_reg_2016_679_art_12_3,
    Pairs == [extension_necessary_for_complexity_and_number - unsure].
test(the_deadline_term_has_three_integers) :-
    Deadline = date(2026, 11, 30),
    Deadline = date(Year, Month, DayNumber),
    integer(Year),
    integer(Month),
    integer(DayNumber),
    Year =:= 2026,
    Month =:= 11,
    DayNumber =:= 30.
test(the_deadline_refusal_term_destructures) :-
    Result = input_problems([wrong_type(receipt_date), wrong_type(response_period)]),
    Result = input_problems(Problems),
    Problems == [wrong_type(receipt_date), wrong_type(response_period)].
test(the_outside_fact_item_carries_the_attestation) :-
    Item = outside_fact(public_holidays, attested([date(2026, 11, 30)], attestation(by, at, reason, url(address, retrieved)))),
    Item = outside_fact(Key, attested(Value, attestation(By, At, Reason, Evidence))),
    Key == public_holidays,
    Value == [date(2026, 11, 30)],
    By == by,
    At == at,
    Reason == reason,
    Evidence == url(address, retrieved).
test(the_absent_outside_fact_item) :-
    Item = outside_fact(legislative_restriction_applies_to_the_right, absent),
    Item = outside_fact(_, Attested),
    Attested == absent.
test(the_primary_citation_is_recorded) :-
    citation(eu_reg_2016_679_art_12_3, _).
test(the_calendar_rule_citations_are_recorded) :-
    citation(eu_reg_1971_1182_art_3, _),
    citation(eu_reg_1971_1182_art_3_1, _),
    citation(eu_reg_1971_1182_art_3_2_c, _),
    citation(eu_reg_1971_1182_art_3_4, _).
test(the_outside_fact_citations_are_recorded) :-
    citation(eu_reg_2016_679_art_17_1_e, _),
    citation(eu_reg_2016_679_art_17_3_b, _),
    citation(eu_reg_2016_679_art_22_2_b, _),
    citation(eu_reg_2016_679_art_23_1, _).
test(the_primary_citation_record_has_label_ref_verbatim) :-
    citation(eu_reg_2016_679_art_12_3, [label - Label, ref - Reference, verbatim - Verbatim]),
    atom(Label),
    atom(Reference),
    atom(Verbatim).
test(the_primary_citation_is_recorded_once) :-
    findall(Record, citation(eu_reg_2016_679_art_12_3, Record), Records),
    length(Records, 1).
test(the_marker_succeeds_for_a_recorded_key) :-
    implements(eu_reg_2016_679_art_12_3).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_data_subject_rights_response_period_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(request_type, access), attribute(extension_claimed, true), attribute(extension_necessary_for_complexity_and_number, unsure), attribute(legislative_restriction_applies_to_the_right, attested(false, attestation(by, at, reason, none))), attribute(public_holidays, attested([date(2026, 12, 25)], attestation(by, at, reason, none)))],
    findall(Problems, gdpr_data_subject_rights_response_period_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(a_term_that_is_not_an_attribute_list_is_wrong_type_profile) :-
    findall(Problems, gdpr_data_subject_rights_response_period_input_problems(not_a_profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_of_other_items_is_wrong_type_profile) :-
    findall(Problems, gdpr_data_subject_rights_response_period_input_problems([extension_claimed - true], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_key_outside_the_contract_is_unknown) :-
    findall(Problems, gdpr_data_subject_rights_response_period_input_problems([attribute(colour, red), attribute(colour, blue)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(a_crisp_flag_given_unsure_is_wrong_type) :-
    findall(Problems, gdpr_data_subject_rights_response_period_input_problems([attribute(extension_claimed, unsure)], Problems), Answers),
    Answers == [[wrong_type(extension_claimed)]].
test(a_crisp_flag_given_true_has_no_problem) :-
    gdpr_data_subject_rights_response_period_input_problems([attribute(extension_claimed, true)], []).
test(a_repeated_key_is_a_duplicate_and_not_wrong_type) :-
    findall(Problems, gdpr_data_subject_rights_response_period_input_problems([attribute(extension_claimed, true), attribute(extension_claimed, maybe)], Problems), Answers),
    Answers == [[duplicate_key(extension_claimed)]].
test(a_bare_outside_fact_is_wrong_type) :-
    findall(Problems, gdpr_data_subject_rights_response_period_input_problems([attribute(public_holidays, [])], Problems), Answers),
    Answers == [[wrong_type(public_holidays)]].
test(contract_problems_come_before_unknown_keys) :-
    Profile = [attribute(colour, red), attribute(extension_necessary_for_complexity_and_number, maybe), attribute(request_type, deletion)],
    findall(Problems, gdpr_data_subject_rights_response_period_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(request_type), wrong_type(extension_necessary_for_complexity_and_number), unknown_key(colour)]].

test(the_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_reg_2016_679_art_12_33).
test(an_unrecorded_key_has_no_citation, fail) :-
    citation(eu_todo_primary_source, _).
test(a_crisp_flag_given_true_is_not_wrong_type, fail) :-
    gdpr_data_subject_rights_response_period_input_problems([attribute(extension_claimed, true)], [wrong_type(extension_claimed)]).

cp_test_names([the_two_periods_are_distinct, the_compound_statuses_are_distinct, a_period_is_not_a_compound_status, the_problem_items_are_distinct, the_judgement_values_are_distinct, the_absent_marker_is_not_an_attested_term, the_verdict_term_carries_status_and_citations, the_indeterminate_term_names_the_missing_key, the_referral_term_destructures, the_deadline_term_has_three_integers, the_deadline_refusal_term_destructures, the_outside_fact_item_carries_the_attestation, the_absent_outside_fact_item, the_primary_citation_is_recorded, the_calendar_rule_citations_are_recorded, the_outside_fact_citations_are_recorded, the_primary_citation_record_has_label_ref_verbatim, the_primary_citation_is_recorded_once, the_marker_succeeds_for_a_recorded_key, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_term_that_is_not_an_attribute_list_is_wrong_type_profile, a_list_of_other_items_is_wrong_type_profile, a_key_outside_the_contract_is_unknown, a_crisp_flag_given_unsure_is_wrong_type, a_crisp_flag_given_true_has_no_problem, a_repeated_key_is_a_duplicate_and_not_wrong_type, a_bare_outside_fact_is_wrong_type, contract_problems_come_before_unknown_keys]).
cp_test_fail_names([the_marker_fails_for_an_unrecorded_key, an_unrecorded_key_has_no_citation, a_crisp_flag_given_true_is_not_wrong_type]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
