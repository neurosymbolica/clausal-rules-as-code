% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_transfer_dpf_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_gdpr_transfer_dpf, [data_privacy_framework_adequacy/4, decide_gdpr_transfer_dpf/2]).
:- use_module(m__eu_data_protection_gdpr_transfer_dpf_fixtures, [gdpr_transfer_dpf_subject/1, gdpr_transfer_dpf_profile_for/2, gdpr_transfer_dpf_assess/2]).

affirmed(attested(true, attestation(by, at, reason, none))).

denied(attested(false, attestation(by, at, reason, none))).

final_result(covered_by_data_privacy_framework_adequacy).
final_result(not_covered_by_data_privacy_framework_adequacy).

status_result(input_problems(_)).
status_result(needs_legal_review(_, _)).
status_result(indeterminate(_)).

subject_classifies(Subject) :-
    gdpr_transfer_dpf_subject(Subject),
    gdpr_transfer_dpf_assess(Subject, _Verdict).

subject_answer_count(Subject, Count) :-
    gdpr_transfer_dpf_subject(Subject),
    gdpr_transfer_dpf_profile_for(Subject, Profile),
    findall(Result, data_privacy_framework_adequacy(Profile, Result, _, _), Results),
    length(Results, Count).

subject_verdict_count(Subject, Count) :-
    gdpr_transfer_dpf_subject(Subject),
    gdpr_transfer_dpf_profile_for(Subject, Profile),
    findall(Verdict, decide_gdpr_transfer_dpf(Profile, Verdict), Verdicts),
    length(Verdicts, Count).

subject_answer(Result, Basis, Citations) :-
    gdpr_transfer_dpf_subject(Subject),
    gdpr_transfer_dpf_profile_for(Subject, Profile),
    data_privacy_framework_adequacy(Profile, Result, Basis, Citations).

every_list_cites_article_one([]).
every_list_cites_article_one([Citations|Remaining]) :-
    member(cite(eu_dec_2023_1795_art_1), Citations),
    every_list_cites_article_one(Remaining).

every_item_denied([]).
every_item_denied([outside_fact(_, attested(false, _))|Remaining]) :-
    every_item_denied(Remaining).

every_basis_denied([]).
every_basis_denied([Basis|Remaining]) :-
    every_item_denied(Basis),
    every_basis_denied(Remaining).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_transfer_dpf_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_answer) :-
    findall(Count, subject_answer_count(_, Count), Counts),
    Counts = [_|_],
    sort(Counts, CountSet),
    CountSet == [1].
test(determinism_every_subject_has_exactly_one_verdict) :-
    findall(Count, subject_verdict_count(_, Count), Counts),
    Counts = [_|_],
    sort(Counts, CountSet),
    CountSet == [1].
test(every_final_answer_cites_article_one) :-
    findall(Citations, (subject_answer(Result, _, Citations), final_result(Result)), CitationLists),
    CitationLists = [_|_],
    every_list_cites_article_one(CitationLists).
test(the_covered_citations_are_article_one_and_article_45_1) :-
    findall(Citations, subject_answer(covered_by_data_privacy_framework_adequacy, _, Citations), CitationLists),
    sort(CitationLists, CitationSet),
    CitationSet == [[cite(eu_dec_2023_1795_art_1), cite(eu_reg_2016_679_art_45_1)]].
test(the_not_covered_citations_are_article_one_alone) :-
    findall(Citations, subject_answer(not_covered_by_data_privacy_framework_adequacy, _, Citations), CitationLists),
    sort(CitationLists, CitationSet),
    CitationSet == [[cite(eu_dec_2023_1795_art_1)]].
test(every_status_has_empty_basis_and_citations) :-
    findall(Basis - Citations, (subject_answer(Result, Basis, Citations), status_result(Result)), Pairs),
    Pairs = [_|_],
    sort(Pairs, PairSet),
    PairSet == [[] - []].
test(a_not_covered_basis_holds_only_facts_attested_false) :-
    findall(Basis, subject_answer(not_covered_by_data_privacy_framework_adequacy, Basis, _), BasisLists),
    BasisLists = [_|_],
    every_basis_denied(BasisLists).
test(a_covered_basis_holds_the_three_facts_attested_true) :-
    findall(Basis, subject_answer(covered_by_data_privacy_framework_adequacy, Basis, _), BasisLists),
    BasisLists = [[outside_fact(data_privacy_framework_decision_in_force, attested(true, _)), outside_fact(recipient_on_data_privacy_framework_list, attested(true, _)), outside_fact(certification_covers_transferred_data, attested(true, _))]].
test(stating_an_absent_fact_true_keeps_a_not_covered_answer) :-
    affirmed(Affirmed),
    data_privacy_framework_adequacy([attribute(transfer_from_union, false), attribute(data_privacy_framework_decision_in_force, Affirmed)], not_covered_by_data_privacy_framework_adequacy, [], [cite(eu_dec_2023_1795_art_1)]).
test(stating_an_absent_fact_false_only_adds_its_basis_item) :-
    denied(Denied),
    findall(Result - Basis - Citations, data_privacy_framework_adequacy([attribute(transfer_from_union, false), attribute(recipient_on_data_privacy_framework_list, Denied)], Result, Basis, Citations), Answers),
    Answers == [not_covered_by_data_privacy_framework_adequacy - [outside_fact(recipient_on_data_privacy_framework_list, Denied)] - [cite(eu_dec_2023_1795_art_1)]].
test(stating_an_absent_crisp_key_keeps_a_denied_fact_answer) :-
    denied(Denied),
    findall(Result - Basis - Citations, data_privacy_framework_adequacy([attribute(recipient_is_organisation_in_united_states, true), attribute(certification_covers_transferred_data, Denied)], Result, Basis, Citations), Answers),
    Answers == [not_covered_by_data_privacy_framework_adequacy - [outside_fact(certification_covers_transferred_data, Denied)] - [cite(eu_dec_2023_1795_art_1)]].

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_answer, determinism_every_subject_has_exactly_one_verdict, every_final_answer_cites_article_one, the_covered_citations_are_article_one_and_article_45_1, the_not_covered_citations_are_article_one_alone, every_status_has_empty_basis_and_citations, a_not_covered_basis_holds_only_facts_attested_false, a_covered_basis_holds_the_three_facts_attested_true, stating_an_absent_fact_true_keeps_a_not_covered_answer, stating_an_absent_fact_false_only_adds_its_basis_item, stating_an_absent_crisp_key_keeps_a_denied_fact_answer]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
