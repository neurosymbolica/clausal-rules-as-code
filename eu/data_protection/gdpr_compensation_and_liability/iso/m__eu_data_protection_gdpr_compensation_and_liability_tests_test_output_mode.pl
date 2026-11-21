% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_compensation_and_liability_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_gdpr_compensation_and_liability, [compensation_liability/4, decide_gdpr_compensation_and_liability/2, gdpr_compensation_and_liability_status/2, gdpr_compensation_and_liability_status_values/1, gdpr_compensation_and_liability_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_compensation_and_liability_fixtures, [gdpr_compensation_and_liability_subject/1, gdpr_compensation_and_liability_profile_for/2, gdpr_compensation_and_liability_assess/2]).

expected_result(liable_controller, liable_for_damage).
expected_result(exempt_controller, exempt_from_liability).
expected_result(liable_processor_breach, liable_for_damage).
expected_result(not_liable_processor, not_liable_for_damage).
expected_result(liable_processor_instructions, liable_for_damage).
expected_result(indeterminate_processor_ground_absent, indeterminate([processor_acted_outside_or_contrary_to_lawful_instructions])).
expected_result(not_liable_uninvolved_controller, not_liable_for_damage).
expected_result(right_not_established_no_damage, right_not_established).
expected_result(right_not_established_no_infringement, right_not_established).
expected_result(right_not_established_no_causation, right_not_established).
expected_result(right_not_established_outside_caller, right_not_established).
expected_result(indeterminate_judgement_absent, indeterminate([damage_resulted_from_the_infringement])).
expected_result(indeterminate_role_absent, indeterminate([party_role])).
expected_result(indeterminate_involvement_absent, indeterminate([involved_in_the_processing])).
expected_result(referred_outside_unsure, needs_legal_review(open_textured(infringement_of_the_regulation_occurred, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on([damage_suffered - true, infringement_of_the_regulation_occurred - unsure, damage_resulted_from_the_infringement - true])])).
expected_result(referred_statement_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), [resolution(cite(non_responsibility_statement), not_attempted), inputs_relied_on([damage_suffered - true, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - true, not_in_any_way_responsible_for_the_event - absent])])).
expected_result(referred_inside_unsure, needs_legal_review(open_textured(damage_suffered, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on([damage_suffered - unsure, infringement_of_the_regulation_occurred - true, damage_resulted_from_the_infringement - true])])).
expected_result(input_problem_unknown_key, input_problems([unknown_key(colour)])).
expected_result(input_problem_wrong_type, input_problems([wrong_type(involved_in_the_processing)])).
expected_result(input_problem_duplicate_key, input_problems([duplicate_key(damage_suffered)])).

subject_result(Subject, Result) :-
    gdpr_compensation_and_liability_subject(Subject),
    gdpr_compensation_and_liability_profile_for(Subject, Profile),
    compensation_liability(Profile, Result, _Basis, _Citations).

expected_subject_result(Subject, Result) :-
    gdpr_compensation_and_liability_subject(Subject),
    expected_result(Subject, Result).

test(the_baseline_profile_yields_exactly_one_status) :-
    gdpr_compensation_and_liability_profile_for(todo_baseline_subject, Profile),
    findall(Status, gdpr_compensation_and_liability_status(Profile, Status), Statuses),
    Statuses == [liable_for_damage].
test(the_verdict_carries_a_citation) :-
    gdpr_compensation_and_liability_profile_for(todo_baseline_subject, Profile),
    decide_gdpr_compensation_and_liability(Profile, gdpr_compensation_and_liability_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(every_subject_reads_out_its_expected_result) :-
    findall(Subject - Result, subject_result(Subject, Result), Actual),
    findall(Subject - Result, expected_subject_result(Subject, Result), Expected),
    Actual == Expected.
test(the_status_values_are_the_four_final_atoms) :-
    gdpr_compensation_and_liability_status_values(StatusValues),
    StatusValues == [right_not_established, not_liable_for_damage, exempt_from_liability, liable_for_damage].
test(enumerating_the_liable_subjects) :-
    findall(Subject, (gdpr_compensation_and_liability_subject(Subject), gdpr_compensation_and_liability_assess(Subject, gdpr_compensation_and_liability_verdict(liable_for_damage, _Citations))), LiableSubjects),
    LiableSubjects == [liable_controller, liable_processor_breach, liable_processor_instructions].
test(enumerating_the_right_not_established_subjects) :-
    findall(Subject, (gdpr_compensation_and_liability_subject(Subject), gdpr_compensation_and_liability_assess(Subject, gdpr_compensation_and_liability_verdict(right_not_established, _Citations))), Subjects),
    Subjects == [right_not_established_no_damage, right_not_established_no_infringement, right_not_established_no_causation, right_not_established_outside_caller].
test(the_liable_citations_read_out) :-
    gdpr_compensation_and_liability_profile_for(liable_processor_breach, Profile),
    compensation_liability(Profile, _Result, _Basis, Citations),
    Citations == [cite(eu_reg_2016_679_art_82_1), cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)].
test(the_not_liable_citations_read_out) :-
    gdpr_compensation_and_liability_profile_for(not_liable_uninvolved_controller, Profile),
    compensation_liability(Profile, _Result, Basis, Citations),
    Basis == [],
    Citations == [cite(eu_reg_2016_679_art_82_2)].
test(a_referral_reads_out_no_basis_and_no_citation) :-
    gdpr_compensation_and_liability_profile_for(referred_statement_absent, Profile),
    compensation_liability(Profile, _Result, Basis, Citations),
    Basis == [],
    Citations == [].
test(the_basis_copies_the_document_attestation) :-
    gdpr_compensation_and_liability_profile_for(exempt_controller, Profile),
    compensation_liability(Profile, _Result, Basis, _Citations),
    Basis == [outside_fact(not_in_any_way_responsible_for_the_event, attested(true, attestation(host, at, reason, document(upload_identifier, checksum))))].
test(the_basis_copies_the_url_attestation) :-
    gdpr_compensation_and_liability_profile_for(liable_processor_instructions, Profile),
    compensation_liability(Profile, _Result, Basis, _Citations),
    Basis == [outside_fact(not_in_any_way_responsible_for_the_event, attested(false, attestation(host, at, reason, url(address, retrieved_at))))].
test(the_liable_checklist_is_all_met) :-
    gdpr_compensation_and_liability_profile_for(liable_controller, Profile),
    gdpr_compensation_and_liability_checklist(Profile, Checklist),
    Checklist == [item(damage_suffered, met, cite(eu_reg_2016_679_art_82_1)), item(infringement_of_the_regulation_occurred, met, cite(eu_reg_2016_679_art_82_1)), item(damage_resulted_from_the_infringement, met, cite(eu_reg_2016_679_art_82_1)), item(liability_limb_of_article_82_2, met, cite(eu_reg_2016_679_art_82_2)), item(no_exemption_under_article_82_3, met, cite(eu_reg_2016_679_art_82_3))].
test(the_exempt_checklist_marks_the_exemption) :-
    gdpr_compensation_and_liability_profile_for(exempt_controller, Profile),
    gdpr_compensation_and_liability_checklist(Profile, Checklist),
    last(Checklist, LastItem),
    LastItem == item(no_exemption_under_article_82_3, unmet(exempt_on_attested_statement), cite(eu_reg_2016_679_art_82_3)).
test(the_outside_processor_checklist_marks_the_limb) :-
    gdpr_compensation_and_liability_profile_for(not_liable_processor, Profile),
    gdpr_compensation_and_liability_checklist(Profile, Checklist),
    member(item(liability_limb_of_article_82_2, LimbStatus, cite(eu_reg_2016_679_art_82_2)), Checklist),
    LimbStatus == unmet(outside_article_82_2).
test(the_absent_statement_checklist_marks_it_unknown) :-
    gdpr_compensation_and_liability_profile_for(referred_statement_absent, Profile),
    gdpr_compensation_and_liability_checklist(Profile, Checklist),
    last(Checklist, LastItem),
    LastItem == item(no_exemption_under_article_82_3, unknown([not_in_any_way_responsible_for_the_event]), cite(eu_reg_2016_679_art_82_3)).

test(a_profile_with_input_problems_has_no_checklist, fail) :-
    gdpr_compensation_and_liability_profile_for(input_problem_unknown_key, Profile),
    gdpr_compensation_and_liability_checklist(Profile, _Checklist).

cp_test_names([the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, every_subject_reads_out_its_expected_result, the_status_values_are_the_four_final_atoms, enumerating_the_liable_subjects, enumerating_the_right_not_established_subjects, the_liable_citations_read_out, the_not_liable_citations_read_out, a_referral_reads_out_no_basis_and_no_citation, the_basis_copies_the_document_attestation, the_basis_copies_the_url_attestation, the_liable_checklist_is_all_met, the_exempt_checklist_marks_the_exemption, the_outside_processor_checklist_marks_the_limb, the_absent_statement_checklist_marks_it_unknown]).
cp_test_fail_names([a_profile_with_input_problems_has_no_checklist]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
