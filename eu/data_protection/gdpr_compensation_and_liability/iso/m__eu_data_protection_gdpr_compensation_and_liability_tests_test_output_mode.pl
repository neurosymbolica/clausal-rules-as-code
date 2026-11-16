% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_gdpr_compensation_and_liability, [compensation_liability/4, decide_gdpr_compensation_and_liability/2, gdpr_compensation_and_liability_status/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_fixtures, [gdpr_compensation_and_liability_subject/1, gdpr_compensation_and_liability_profile_for/2]).

expected_answer(controller_liable, liable_for_damage - [outside_fact(not_in_any_way_responsible_for_the_event, attested(false, attestation(host_operator, recorded_at, reason_given, none)))] - [cite(eu_reg_2016_679_art_82_1), cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]).
expected_answer(controller_exempt, exempt_from_liability - [outside_fact(not_in_any_way_responsible_for_the_event, attested(true, attestation(host_operator, recorded_at, reason_given, url(evidence_address, retrieved_at))))] - [cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]).
expected_answer(controller_not_involved, not_liable_for_damage - [] - [cite(eu_reg_2016_679_art_82_2)]).
expected_answer(controller_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), [resolution(cite(non_responsibility_statement), not_attempted), inputs_relied_on([damage_suffered - true, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - true, not_in_any_way_responsible_for_the_event - absent])]) - [] - []).
expected_answer(processor_liable_by_breach, liable_for_damage - [outside_fact(not_in_any_way_responsible_for_the_event, attested(false, attestation(host_operator, recorded_at, reason_given, document(upload_identifier, content_hash))))] - [cite(eu_reg_2016_679_art_82_1), cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]).
expected_answer(processor_liable_by_instructions, liable_for_damage - [outside_fact(not_in_any_way_responsible_for_the_event, attested(false, attestation(host_operator, recorded_at, reason_given, none)))] - [cite(eu_reg_2016_679_art_82_1), cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]).
expected_answer(processor_outside_both_false, not_liable_for_damage - [] - [cite(eu_reg_2016_679_art_82_2)]).
expected_answer(damage_false_role_absent, right_not_established - [] - [cite(eu_reg_2016_679_art_82_1)]).
expected_answer(infringement_false_outside_caller, right_not_established - [] - [cite(eu_reg_2016_679_art_82_1)]).
expected_answer(causation_false, right_not_established - [] - [cite(eu_reg_2016_679_art_82_1)]).
expected_answer(judgement_absent, indeterminate([damage_resulted_from_the_infringement]) - [] - []).
expected_answer(role_absent, indeterminate([party_role]) - [] - []).
expected_answer(controller_involvement_absent, indeterminate([involved_in_the_processing]) - [] - []).
expected_answer(processor_keys_absent, indeterminate([processor_breached_obligations_directed_to_processors]) - [] - []).
expected_answer(processor_second_key_absent, indeterminate([processor_acted_outside_or_contrary_to_lawful_instructions]) - [] - []).
expected_answer(outside_caller_unsure, needs_legal_review(open_textured(damage_suffered, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on([damage_suffered - unsure, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - true])]) - [] - []).
expected_answer(inside_statement_absent_with_unsure, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), [resolution(cite(non_responsibility_statement), not_attempted), inputs_relied_on([damage_suffered - true, infringement_of_the_regulation_occurred - unsure, damage_resulted_from_the_infringement - true, not_in_any_way_responsible_for_the_event - absent])]) - [] - []).
expected_answer(inside_unsure, needs_legal_review(open_textured(damage_resulted_from_the_infringement, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on([damage_suffered - true, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - unsure])]) - [] - []).
expected_answer(input_wrong_type_crisp_unsure, input_problems([wrong_type(involved_in_the_processing)]) - [] - []).
expected_answer(input_duplicate_key, input_problems([duplicate_key(damage_suffered)]) - [] - []).
expected_answer(input_unknown_key, input_problems([unknown_key(colour)]) - [] - []).
expected_answer(input_not_attribute_list, input_problems([wrong_type(profile)]) - [] - []).
expected_answer(input_unbound_value, input_problems([wrong_type(damage_suffered)]) - [] - []).

subject_gives_expected_answer(Subject) :-
    expected_answer(Subject, Expected),
    gdpr_compensation_and_liability_profile_for(Subject, Profile),
    findall(Result - Basis - Citations, compensation_liability(Profile, Result, Basis, Citations), Answers),
    Answers == [Expected].

test(the_expected_table_covers_every_subject) :-
    findall(Subject, gdpr_compensation_and_liability_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, expected_answer(Subject, _), TableSubjects),
    sort(TableSubjects, SubjectSet).
test(every_subject_gives_exactly_its_expected_answer) :-
    findall(Subject, expected_answer(Subject, _), TableSubjects),
    findall(Subject, subject_gives_expected_answer(Subject), MatchingSubjects),
    MatchingSubjects == TableSubjects.
test(the_liable_profile_yields_exactly_one_status) :-
    gdpr_compensation_and_liability_profile_for(controller_liable, Profile),
    findall(Status, gdpr_compensation_and_liability_status(Profile, Status), Statuses),
    Statuses == [liable_for_damage].
test(the_final_verdict_carries_a_citation) :-
    gdpr_compensation_and_liability_profile_for(controller_liable, Profile),
    decide_gdpr_compensation_and_liability(Profile, gdpr_compensation_and_liability_verdict(liable_for_damage, [_FirstCitation|_OtherCitations])).
test(a_non_final_verdict_carries_no_citation) :-
    gdpr_compensation_and_liability_profile_for(role_absent, Profile),
    decide_gdpr_compensation_and_liability(Profile, gdpr_compensation_and_liability_verdict(indeterminate([party_role]), [])).
test(an_empty_profile_names_the_first_judgement) :-
    findall(Status, gdpr_compensation_and_liability_status([], Status), Statuses),
    Statuses == [indeterminate([damage_suffered])].

cp_test_names([the_expected_table_covers_every_subject, every_subject_gives_exactly_its_expected_answer, the_liable_profile_yields_exactly_one_status, the_final_verdict_carries_a_citation, a_non_final_verdict_carries_no_citation, an_empty_profile_names_the_first_judgement]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
