% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_change_management_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2, clausal_msort/2]).
:- use_module(m__eu_dora_rts_change_management_dora_rts_change_management, [ict_change_management_duties_required/3, ict_change_management_duties_complete/3, ict_change_management_duties_outstanding/3, decide_dora_rts_change_management/2, dora_rts_change_management_status/2]).
:- use_module(m__eu_dora_rts_change_management_fixtures, [dora_rts_change_management_profile_for/2]).

test(all_elements_performed_reads_out_complete) :-
    dora_rts_change_management_profile_for(credit_institution_all_elements_performed, Profile),
    findall(Result - Citations, ict_change_management_duties_complete(Profile, Result, Citations), [complete - Citations]),
    clausal_msort(Citations, [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]).
test(one_element_false_reads_out_incomplete) :-
    dora_rts_change_management_profile_for(credit_institution_verification_not_performed, Profile),
    findall(Result - Citations, ict_change_management_duties_complete(Profile, Result, Citations), [incomplete - Citations]),
    clausal_msort(Citations, [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]).
test(gate_true_reads_out_simplified_framework_entity) :-
    dora_rts_change_management_profile_for(article_16_1_entity, Profile),
    findall(Result - Citations, ict_change_management_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [simplified_framework_entity - [cite(eu_reg_2022_2554_art_16_1)]].
test(gate_absent_reads_out_the_gate) :-
    dora_rts_change_management_profile_for(article_16_1_status_unstated, Profile),
    findall(Result - Citations, ict_change_management_duties_complete(Profile, Result, Citations), Answers),
    Answers == [indeterminate([financial_entity_is_article_16_1_entity]) - []].
test(credit_institution_requires_the_thirteen_elements) :-
    dora_rts_change_management_profile_for(credit_institution_all_elements_performed, Profile),
    findall(Result - Citations, ict_change_management_duties_required(Profile, Result, Citations), [required(Duties) - Citations]),
    length(Duties, 13),
    Duties = [verification_of_ict_security_requirements|_],
    last(Duties, impact_of_change_on_ict_security_measures),
    Citations == [cite(eu_reg_2024_1774_art_17_1)].
test(central_securities_depository_after_significant_changes_requires_fifteen) :-
    dora_rts_change_management_profile_for(central_securities_depository_involvement_unstated, Profile),
    findall(Result - Citations, ict_change_management_duties_required(Profile, Result, Citations), [required(Duties) - Citations]),
    length(Duties, 15),
    last(Duties, central_securities_depository_involvement_of_parties_in_testing),
    member(stringent_testing_after_significant_changes, Duties),
    clausal_msort(Citations, [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]).
test(central_counterparty_requires_its_own_involvement_duty) :-
    dora_rts_change_management_profile_for(central_counterparty_tested_with_parties, Profile),
    ict_change_management_duties_required(Profile, required(Duties), _),
    length(Duties, 15),
    last(Duties, central_counterparty_involvement_of_parties_in_testing).
test(no_significant_changes_requires_thirteen_for_a_depository) :-
    dora_rts_change_management_profile_for(central_securities_depository_without_significant_changes, Profile),
    ict_change_management_duties_required(Profile, required(Duties), Citations),
    length(Duties, 13),
    Citations == [cite(eu_reg_2024_1774_art_17_1)].
test(entity_type_unstated_reads_out_the_type) :-
    dora_rts_change_management_profile_for(entity_type_unstated, Profile),
    findall(Result - Citations, ict_change_management_duties_required(Profile, Result, Citations), RequiredAnswers),
    RequiredAnswers == [indeterminate([dora_entity_type]) - []],
    findall(Result - Citations, ict_change_management_duties_complete(Profile, Result, Citations), CompleteAnswers),
    CompleteAnswers == [indeterminate([dora_entity_type]) - []],
    findall(Result - Citations, ict_change_management_duties_outstanding(Profile, Result, Citations), OutstandingAnswers),
    OutstandingAnswers == [indeterminate([dora_entity_type]) - []].
test(involvement_unstated_reads_out_the_involvement_key) :-
    dora_rts_change_management_profile_for(central_securities_depository_involvement_unstated, Profile),
    ict_change_management_duties_complete(Profile, CompleteResult, []),
    CompleteResult == indeterminate([users_service_providers_and_other_parties_involved_in_testing]),
    ict_change_management_duties_outstanding(Profile, OutstandingResult, []),
    OutstandingResult == indeterminate([users_service_providers_and_other_parties_involved_in_testing]).
test(an_unsure_element_reads_out_a_referral) :-
    dora_rts_change_management_profile_for(credit_institution_verification_unsure, Profile),
    findall(Result - Citations, ict_change_management_duties_complete(Profile, Result, Citations), [Result - Citations]),
    Citations == [],
    Result = needs_legal_review(open_textured(change_procedures_verify_whether_ict_security_requirements_met, cite(eu_reg_2024_1774_art_17_1)), [inputs_relied_on(Pairs)]),
    Pairs = [financial_entity_is_article_16_1_entity - false, dora_entity_type - credit_institution, change_procedures_verify_whether_ict_security_requirements_met - unsure|RemainingPairs],
    length(RemainingPairs, 12).
test(an_unsure_element_is_referred_by_outstanding_too) :-
    dora_rts_change_management_profile_for(credit_institution_verification_unsure, Profile),
    ict_change_management_duties_outstanding(Profile, needs_legal_review(open_textured(JudgementKey, Citation), _), []),
    JudgementKey == change_procedures_verify_whether_ict_security_requirements_met,
    Citation == cite(eu_reg_2024_1774_art_17_1).
test(outstanding_reads_out_the_failing_element) :-
    dora_rts_change_management_profile_for(credit_institution_verification_not_performed, Profile),
    findall(Result - Citations, ict_change_management_duties_outstanding(Profile, Result, Citations), Answers),
    Answers == [outstanding([verification_of_ict_security_requirements]) - [cite(eu_reg_2024_1774_art_17_1)]].
test(nothing_outstanding_reads_out_none_outstanding) :-
    dora_rts_change_management_profile_for(central_counterparty_tested_with_parties, Profile),
    findall(Result - Citations, ict_change_management_duties_outstanding(Profile, Result, Citations), [none_outstanding - Citations]),
    clausal_msort(Citations, [cite(eu_reg_2024_1774_art_17_1), cite(eu_reg_2024_1774_art_17_2)]).
test(the_unsure_gate_reads_out_wrong_type) :-
    dora_rts_change_management_profile_for(article_16_1_status_unsure, Profile),
    dora_rts_change_management_status(Profile, Status),
    Status == input_problems([wrong_type(financial_entity_is_article_16_1_entity)]).
test(the_duplicated_gate_reads_out_duplicate_key) :-
    dora_rts_change_management_profile_for(duplicated_gate_key, Profile),
    dora_rts_change_management_status(Profile, Status),
    Status == input_problems([duplicate_key(financial_entity_is_article_16_1_entity)]).
test(the_verdict_carries_a_citation) :-
    dora_rts_change_management_profile_for(credit_institution_all_elements_performed, Profile),
    decide_dora_rts_change_management(Profile, dora_rts_change_management_verdict(complete, [_FirstCitation|_OtherCitations])).

cp_test_names([all_elements_performed_reads_out_complete, one_element_false_reads_out_incomplete, gate_true_reads_out_simplified_framework_entity, gate_absent_reads_out_the_gate, credit_institution_requires_the_thirteen_elements, central_securities_depository_after_significant_changes_requires_fifteen, central_counterparty_requires_its_own_involvement_duty, no_significant_changes_requires_thirteen_for_a_depository, entity_type_unstated_reads_out_the_type, involvement_unstated_reads_out_the_involvement_key, an_unsure_element_reads_out_a_referral, an_unsure_element_is_referred_by_outstanding_too, outstanding_reads_out_the_failing_element, nothing_outstanding_reads_out_none_outstanding, the_unsure_gate_reads_out_wrong_type, the_duplicated_gate_reads_out_duplicate_key, the_verdict_carries_a_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
