% SPDX-License-Identifier: EUPL-1.2
:- module(m__ae_uae_pdpl_lawful_processing_and_consent_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_uae_pdpl_lawful_processing_and_consent, [decide_uae_pdpl_lawful_processing_and_consent/2, uae_pdpl_lawful_processing_and_consent_status/2, uae_pdpl_lawful_processing_and_consent_checklist/2, uae_pdpl_lawful_processing_and_consent_decision_resolvable/1, uae_pdpl_lawful_processing_and_consent_status_values/1]).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_fixtures, [uae_pdpl_lawful_processing_and_consent_subject/1, uae_pdpl_lawful_processing_and_consent_profile_for/2, uae_pdpl_lawful_processing_and_consent_assess/2]).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_uae_pdpl_lawful_processing_and_consent, [pdpl_processing_lawful_basis/3, pdpl_consent_valid/3, pdpl_processing_controls/3]).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_kernel, [uae_pdpl_lawful_processing_and_consent_input_problems/2]).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_queries, [uae_pdpl_lawful_processing_and_consent_what_if/4, uae_pdpl_lawful_processing_and_consent_eligibility/3, uae_pdpl_lawful_processing_and_consent_justification/4, duplicate_key/1]).
:- use_module(m__ae_uae_pdpl_lawful_processing_and_consent_fixtures, [uae_pdpl_lawful_processing_and_consent_fixture_expected/3]).

query_answers(pdpl_processing_lawful_basis, Profile, Answers) :-
    findall(Result - Citations, pdpl_processing_lawful_basis(Profile, Result, Citations), Answers).
query_answers(pdpl_consent_valid, Profile, Answers) :-
    findall(Result - Citations, pdpl_consent_valid(Profile, Result, Citations), Answers).
query_answers(pdpl_processing_controls, Profile, Answers) :-
    findall(Result - Citations, pdpl_processing_controls(Profile, Result, Citations), Answers).

subject_answer(Subject, Query, Result, Citations) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(Subject, Profile),
    query_answers(Query, Profile, [Result - Citations]).

expected_row_holds(Subject - Query - Expected) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(Subject, Profile),
    query_answers(Query, Profile, Answers),
    Answers = [Result - _Citations],
    Result == Expected.

citation_rule_holds(Subject - Query - _Expected) :-
    subject_answer(Subject, Query, Result, Citations),
    citations_follow_rule(Result, Citations).

final_result(allowed_with_consent).
final_result(allowed_without_consent(_Case)).
final_result(not_allowed).
final_result(not_in_force).
final_result(valid).
final_result(not_valid(_FailureAtom)).
final_result(meets_listed_controls).
final_result(fails_control(_FailureAtom)).

citations_follow_rule(indeterminate(_Keys), []).
citations_follow_rule(needs_legal_review(_Reason, _Context), []).
citations_follow_rule(input_problems(_Problems), []).
citations_follow_rule(Result, [cite(_Key)|_Citations]) :-
    final_result(Result).

checklist_matches(Subject) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(Subject, Profile),
    uae_pdpl_lawful_processing_and_consent_fixture_expected(Subject, pdpl_processing_lawful_basis, Expected),
    uae_pdpl_lawful_processing_and_consent_checklist(Profile, [item(overall, Status, _Citations)|_Rows]),
    Status == Expected.

status_in_vocabulary(Subject) :-
    uae_pdpl_lawful_processing_and_consent_assess(Subject, uae_pdpl_lawful_processing_and_consent_verdict(Status, _Citations)),
    uae_pdpl_lawful_processing_and_consent_status_values(StatusValues),
    functor(Status, Name, _),
    member(Name, StatusValues).

queries_agree(Subject) :-
    subject_answer(Subject, pdpl_processing_lawful_basis, LawfulResult, _),
    subject_answer(Subject, pdpl_consent_valid, ConsentResult, _),
    consistent_pair(LawfulResult, ConsentResult).

consistent_pair(allowed_with_consent, valid).
consistent_pair(LawfulResult, ConsentResult) :-
    dif(LawfulResult, allowed_with_consent),
    dif(ConsentResult, valid).

row_cited(item(_Id, _Status, [cite(_Key)|_Citations])).

same_citations(Citations, Expected) :-
    clausal_msort(Citations, Sorted),
    clausal_msort(Expected, Sorted).

test(every_fixture_answer_is_its_expected_answer_exactly_once) :-
    findall(Subject - Query - Expected, uae_pdpl_lawful_processing_and_consent_fixture_expected(Subject, Query, Expected), Rows),
    Rows = [_|_],
    maplist(expected_row_holds, Rows).
test(every_fixture_answer_follows_the_citation_rule) :-
    findall(Subject - Query - Expected, uae_pdpl_lawful_processing_and_consent_fixture_expected(Subject, Query, Expected), Rows),
    maplist(citation_rule_holds, Rows).
test(every_fixture_checklist_is_non_empty_and_heads_with_the_verdict) :-
    findall(Subject, uae_pdpl_lawful_processing_and_consent_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(checklist_matches, Subjects).
test(every_fixture_status_is_in_the_status_vocabulary) :-
    findall(Subject, uae_pdpl_lawful_processing_and_consent_subject(Subject), Subjects),
    maplist(status_in_vocabulary, Subjects).
test(allowed_with_consent_exactly_when_the_consent_is_valid) :-
    findall(Subject, uae_pdpl_lawful_processing_and_consent_subject(Subject), Subjects),
    maplist(queries_agree, Subjects).
test(valid_consent_is_allowed_with_consent) :-
    subject_answer(valid_consent_no_case, pdpl_processing_lawful_basis, allowed_with_consent, Citations),
    same_citations(Citations, [cite(uae_pdpl_art_4), cite(uae_pdpl_art_1_consent), cite(uae_pdpl_art_6_1), cite(uae_pdpl_art_6_1_a), cite(uae_pdpl_art_6_1_b), cite(uae_pdpl_art_6_1_c), cite(uae_pdpl_art_6_2)]).
test(valid_consent_is_read_before_a_true_case) :-
    subject_answer(valid_consent_and_public_interest, pdpl_processing_lawful_basis, allowed_with_consent, _).
test(withdrawn_consent_is_not_allowed) :-
    subject_answer(consent_fails_withdrawn, pdpl_processing_lawful_basis, not_allowed, Citations),
    same_citations(Citations, [cite(uae_pdpl_art_4), cite(uae_pdpl_art_4_1), cite(uae_pdpl_art_4_2), cite(uae_pdpl_art_4_3), cite(uae_pdpl_art_4_4), cite(uae_pdpl_art_4_5), cite(uae_pdpl_art_4_6), cite(uae_pdpl_art_4_7), cite(uae_pdpl_art_4_8), cite(uae_pdpl_art_4_9), cite(uae_pdpl_art_4_10)]).
test(public_health_alone_allows_without_consent) :-
    subject_answer(consent_refused_case_public_health, pdpl_processing_lawful_basis, allowed_without_consent(public_health), Citations),
    same_citations(Citations, [cite(uae_pdpl_art_4), cite(uae_pdpl_art_4_5)]).
test(no_case_with_refused_consent_is_not_allowed) :-
    subject_answer(consent_fails_given, pdpl_processing_lawful_basis, not_allowed, _).
test(the_first_true_case_is_named) :-
    subject_answer(consent_refused_two_cases, pdpl_processing_lawful_basis, allowed_without_consent(legal_claims_and_judicial_or_security_procedures), Citations),
    same_citations(Citations, [cite(uae_pdpl_art_4), cite(uae_pdpl_art_4_3)]).
test(the_day_before_commencement_is_not_in_force_for_every_query) :-
    subject_answer(day_before_commencement, pdpl_processing_lawful_basis, not_in_force, [cite(uae_pdpl_art_31)]),
    subject_answer(day_before_commencement, pdpl_consent_valid, not_in_force, [cite(uae_pdpl_art_31)]),
    subject_answer(day_before_commencement, pdpl_processing_controls, not_in_force, [cite(uae_pdpl_art_31)]).
test(the_commencement_day_is_read) :-
    subject_answer(commencement_day, pdpl_processing_lawful_basis, allowed_with_consent, _),
    subject_answer(commencement_day, pdpl_consent_valid, valid, _).
test(missing_proof_of_consent_is_named) :-
    subject_answer(consent_fails_proof, pdpl_consent_valid, not_valid(controller_cannot_prove_consent), Citations),
    same_citations(Citations, [cite(uae_pdpl_art_6_1), cite(uae_pdpl_art_6_1_a)]).
test(valid_consent_is_valid) :-
    subject_answer(valid_consent_no_case, pdpl_consent_valid, valid, _).
test(an_unsure_consent_judgement_is_referred) :-
    subject_answer(unsure_specific_consent_with_true_case, pdpl_consent_valid, Result, Citations),
    Result == needs_legal_review(open_textured(consent_specific_clear_and_unambiguous, cite(uae_pdpl_art_1_consent)), [inputs_relied_on([consent_specific_clear_and_unambiguous - unsure])]),
    Citations == [].
test(an_absent_case_is_named_before_an_unsure_consent_is_referred) :-
    subject_answer(unsure_specific_consent_cases_unstated, pdpl_processing_lawful_basis, indeterminate([necessary_to_protect_public_interest]), []).
test(insecure_keeping_fails_its_control) :-
    subject_answer(control_fails_security, pdpl_processing_controls, fails_control(control_6_kept_securely), Citations),
    same_citations(Citations, [cite(uae_pdpl_art_5), cite(uae_pdpl_art_5_6)]).
test(all_controls_met) :-
    subject_answer(valid_consent_no_case, pdpl_processing_controls, meets_listed_controls, _).
test(an_earlier_absent_control_is_named_before_a_later_failing_one) :-
    subject_answer(fairness_unstated_before_failing_purpose, pdpl_processing_controls, indeterminate([processed_fairly_transparently_and_lawfully]), []).
test(year_zero_is_an_input_problem_for_the_query) :-
    subject_answer(year_zero, pdpl_processing_lawful_basis, input_problems([wrong_type(processing_date)]), []).
test(a_leap_day_is_well_formed) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(leap_day_in_force, Profile),
    uae_pdpl_lawful_processing_and_consent_input_problems(Profile, Problems),
    Problems == [].
test(a_non_list_is_not_a_profile) :-
    findall(Problems, uae_pdpl_lawful_processing_and_consent_input_problems(not_a_profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_repeated_contract_key_is_a_duplicate_key_problem) :-
    findall(Result - Citations, pdpl_consent_valid([attribute(consent_given, true), attribute(consent_given, true)], Result, Citations), Answers),
    Answers == [input_problems([duplicate_key(consent_given)]) - []].
test(duplicate_key_recognises_a_contract_key) :-
    duplicate_key(consent_given).
test(assess_gives_the_lawful_basis_verdict) :-
    uae_pdpl_lawful_processing_and_consent_assess(valid_consent_no_case, uae_pdpl_lawful_processing_and_consent_verdict(allowed_with_consent, [_|_])).
test(decide_matches_the_lawful_basis_query) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_refused_case_contract, Profile),
    decide_uae_pdpl_lawful_processing_and_consent(Profile, uae_pdpl_lawful_processing_and_consent_verdict(allowed_without_consent(contract_with_data_subject), _)).
test(the_status_of_refused_consent_without_a_case_is_not_allowed) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_fails_given, Profile),
    uae_pdpl_lawful_processing_and_consent_status(Profile, not_allowed),
    uae_pdpl_lawful_processing_and_consent_decision_resolvable(Profile).
test(valid_consent_is_eligible) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(valid_consent_no_case, Profile),
    findall(Label, uae_pdpl_lawful_processing_and_consent_eligibility(Profile, Label, _), Labels),
    Labels == [eligible].
test(withdrawn_consent_without_a_case_is_ineligible) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_fails_withdrawn, Profile),
    uae_pdpl_lawful_processing_and_consent_eligibility(Profile, ineligible, _).
test(an_unstated_date_is_indeterminate) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(processing_date_unstated, Profile),
    uae_pdpl_lawful_processing_and_consent_eligibility(Profile, indeterminate, _).
test(every_requirement_row_carries_a_citation) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(valid_consent_no_case, Profile),
    uae_pdpl_lawful_processing_and_consent_eligibility(Profile, eligible, [_Overall|Rows]),
    Rows = [_|_],
    maplist(row_cited, Rows).
test(the_failing_condition_row_is_justified) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_fails_withdrawn, Profile),
    uae_pdpl_lawful_processing_and_consent_justification(Profile, consent_withdrawn_before_processing, unmet(consent_withdrawn), [cite(uae_pdpl_art_6_2)]).
test(what_if_public_health_holds_allows_without_consent) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_fails_given, Profile),
    uae_pdpl_lawful_processing_and_consent_what_if(Profile, necessary_to_protect_public_health, true, Status),
    Status == allowed_without_consent(public_health).

test(withdrawn_consent_is_not_allowed_with_consent, fail) :-
    subject_answer(consent_fails_withdrawn, pdpl_processing_lawful_basis, allowed_with_consent, _).
test(no_case_with_refused_consent_is_not_allowed_without_consent, fail) :-
    subject_answer(consent_fails_given, pdpl_processing_lawful_basis, allowed_without_consent(_), _).
test(a_later_true_case_is_not_named, fail) :-
    subject_answer(consent_refused_two_cases, pdpl_processing_lawful_basis, allowed_without_consent(contract_with_data_subject), _).
test(the_commencement_day_is_not_not_in_force, fail) :-
    subject_answer(commencement_day, pdpl_processing_lawful_basis, not_in_force, _).
test(valid_consent_is_not_not_valid, fail) :-
    subject_answer(valid_consent_no_case, pdpl_consent_valid, not_valid(_), _).
test(a_failing_control_does_not_meet_the_controls, fail) :-
    subject_answer(control_fails_security, pdpl_processing_controls, meets_listed_controls, _).
test(duplicate_key_refuses_a_key_outside_the_contract, fail) :-
    duplicate_key(colour).
test(withdrawn_consent_without_a_case_is_not_eligible, fail) :-
    uae_pdpl_lawful_processing_and_consent_profile_for(consent_fails_withdrawn, Profile),
    uae_pdpl_lawful_processing_and_consent_eligibility(Profile, eligible, _).

cp_test_names([every_fixture_answer_is_its_expected_answer_exactly_once, every_fixture_answer_follows_the_citation_rule, every_fixture_checklist_is_non_empty_and_heads_with_the_verdict, every_fixture_status_is_in_the_status_vocabulary, allowed_with_consent_exactly_when_the_consent_is_valid, valid_consent_is_allowed_with_consent, valid_consent_is_read_before_a_true_case, withdrawn_consent_is_not_allowed, public_health_alone_allows_without_consent, no_case_with_refused_consent_is_not_allowed, the_first_true_case_is_named, the_day_before_commencement_is_not_in_force_for_every_query, the_commencement_day_is_read, missing_proof_of_consent_is_named, valid_consent_is_valid, an_unsure_consent_judgement_is_referred, an_absent_case_is_named_before_an_unsure_consent_is_referred, insecure_keeping_fails_its_control, all_controls_met, an_earlier_absent_control_is_named_before_a_later_failing_one, year_zero_is_an_input_problem_for_the_query, a_leap_day_is_well_formed, a_non_list_is_not_a_profile, a_repeated_contract_key_is_a_duplicate_key_problem, duplicate_key_recognises_a_contract_key, assess_gives_the_lawful_basis_verdict, decide_matches_the_lawful_basis_query, the_status_of_refused_consent_without_a_case_is_not_allowed, valid_consent_is_eligible, withdrawn_consent_without_a_case_is_ineligible, an_unstated_date_is_indeterminate, every_requirement_row_carries_a_citation, the_failing_condition_row_is_justified, what_if_public_health_holds_allows_without_consent]).
cp_test_fail_names([withdrawn_consent_is_not_allowed_with_consent, no_case_with_refused_consent_is_not_allowed_without_consent, a_later_true_case_is_not_named, the_commencement_day_is_not_not_in_force, valid_consent_is_not_not_valid, a_failing_control_does_not_meet_the_controls, duplicate_key_refuses_a_key_outside_the_contract, withdrawn_consent_without_a_case_is_not_eligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
