% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art6_lawful_basis_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_gdpr_art6_lawful_basis, [lawful_basis_status/4, purpose_compatibility/4, decide_gdpr_art6_lawful_basis/2, gdpr_art6_lawful_basis_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_kernel, [gdpr_art6_lawful_basis_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art6_lawful_basis_fixtures, [gdpr_art6_lawful_basis_subject/1, gdpr_art6_lawful_basis_profile_for/2]).

subject_classifies(Subject) :-
    gdpr_art6_lawful_basis_subject(Subject),
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    decide_gdpr_art6_lawful_basis(Profile, _Verdict).

result_kind(eligible, final).
result_kind(ineligible, final).
result_kind(purpose_compatible, final).
result_kind(purpose_not_compatible, final).
result_kind(compatibility_test_not_engaged, final).
result_kind(compatibility_not_ascertained, final).
result_kind(indeterminate([_]), not_final).
result_kind(needs_legal_review(_, _), not_final).
result_kind(input_problems([_|_]), not_final).

query_names([lawful_basis_status, purpose_compatibility, input_check, checklist]).

answer_count(Profile, lawful_basis_status, Count) :-
    findall(Result, lawful_basis_status(Profile, Result, _, _), Results),
    length(Results, Count).
answer_count(Profile, purpose_compatibility, Count) :-
    findall(Result, purpose_compatibility(Profile, Result, _, _), Results),
    length(Results, Count).
answer_count(Profile, input_check, Count) :-
    findall(Problems, gdpr_art6_lawful_basis_input_problems(Profile, Problems), ProblemLists),
    length(ProblemLists, Count).
answer_count(Profile, checklist, Count) :-
    findall(Items, gdpr_art6_lawful_basis_checklist(Profile, Items), ItemLists),
    length(ItemLists, Count).

lawful_outputs(Subject, Kind, Basis, Citations) :-
    gdpr_art6_lawful_basis_subject(Subject),
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    lawful_basis_status(Profile, Result, Basis, Citations),
    result_kind(Result, Kind).

purpose_outputs(Subject, Kind, Basis, Citations) :-
    gdpr_art6_lawful_basis_subject(Subject),
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    purpose_compatibility(Profile, Result, Basis, Citations),
    result_kind(Result, Kind).

lawful_citation_vocabulary([cite(eu_reg_2016_679_art_6_1), cite(eu_reg_2016_679_art_6_1_a), cite(eu_reg_2016_679_art_6_1_b), cite(eu_reg_2016_679_art_6_1_c), cite(eu_reg_2016_679_art_6_1_d), cite(eu_reg_2016_679_art_6_1_e), cite(eu_reg_2016_679_art_6_1_f), cite(eu_reg_2016_679_art_6_1_second_subpara), cite(eu_reg_2016_679_art_6_3)]).

never_named_keys([consent_given_and_conditions_met, legal_obligation_laid_down_by_law, public_interest_task_laid_down_by_law, child_data_subject, special_category, link_between_purposes_taken_into_account, collection_context_taken_into_account, nature_of_data_taken_into_account, possible_consequences_taken_into_account, appropriate_safeguards_taken_into_account]).

named_missing_key(Subject, MissingKey) :-
    gdpr_art6_lawful_basis_subject(Subject),
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    lawful_basis_status(Profile, indeterminate([MissingKey]), _, _).
named_missing_key(Subject, MissingKey) :-
    gdpr_art6_lawful_basis_subject(Subject),
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    purpose_compatibility(Profile, indeterminate([MissingKey]), _, _).

test(totality_every_subject_classifies) :-
    findall(Subject, gdpr_art6_lawful_basis_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_query_answers_once) :-
    findall(Subject, gdpr_art6_lawful_basis_subject(Subject), Subjects),
    length(Subjects, SubjectCount),
    query_names(QueryNames),
    length(QueryNames, QueryCount),
    findall(Subject - QueryName, (member(Subject, Subjects), gdpr_art6_lawful_basis_profile_for(Subject, Profile), member(QueryName, QueryNames), answer_count(Profile, QueryName, 1)), Ones),
    length(Ones, OneCount),
    ExpectedCount is SubjectCount * QueryCount,
    OneCount =:= ExpectedCount.
test(every_lawful_result_is_in_the_vocabulary) :-
    findall(Subject, gdpr_art6_lawful_basis_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, lawful_outputs(Subject, _, _, _), Classified),
    sort(Classified, SubjectSet).
test(every_purpose_result_is_in_the_vocabulary) :-
    findall(Subject, gdpr_art6_lawful_basis_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, purpose_outputs(Subject, _, _, _), Classified),
    sort(Classified, SubjectSet).
test(some_lawful_answers_are_not_final) :-
    lawful_outputs(empty_profile, not_final, [], []).
test(a_final_answer_cites_article_6_1) :-
    lawful_outputs(claimed_contract_holds, final, _, Citations),
    memberd_t(cite(eu_reg_2016_679_art_6_1), Citations, true).
test(a_final_citation_is_in_the_vocabulary) :-
    lawful_outputs(every_way_fails, final, _, [Citation|_]),
    lawful_citation_vocabulary(Vocabulary),
    memberd_t(Citation, Vocabulary, true).
test(purpose_basis_is_empty) :-
    purpose_outputs(purpose_compatible, final, [], [_]).
test(a_missing_key_is_named) :-
    named_missing_key(empty_profile, contract_necessary).

test(no_query_answers_twice_or_never, fail) :-
    gdpr_art6_lawful_basis_subject(Subject),
    gdpr_art6_lawful_basis_profile_for(Subject, Profile),
    query_names(QueryNames),
    member(QueryName, QueryNames),
    answer_count(Profile, QueryName, Count),
    dif(Count, 1).
test(a_not_final_lawful_answer_carries_no_basis_or_citation, fail) :-
    lawful_outputs(_, not_final, Basis, Citations),
    dif(Basis - Citations, [] - []).
test(a_final_answer_without_article_6_1, fail) :-
    lawful_outputs(_, final, _, Citations),
    memberd_t(cite(eu_reg_2016_679_art_6_1), Citations, false).
test(a_final_citation_outside_the_vocabulary, fail) :-
    lawful_outputs(_, final, _, Citations),
    member(Citation, Citations),
    lawful_citation_vocabulary(Vocabulary),
    memberd_t(Citation, Vocabulary, false).
test(purpose_basis_is_never_filled, fail) :-
    purpose_outputs(_, _, Basis, _),
    dif(Basis, []).
test(a_not_final_purpose_answer_carries_no_citation, fail) :-
    purpose_outputs(_, not_final, _, Citations),
    dif(Citations, []).
test(an_outside_fact_or_optional_key_is_never_named_missing, fail) :-
    named_missing_key(_, MissingKey),
    never_named_keys(NeverNamed),
    memberd_t(MissingKey, NeverNamed, true).

cp_test_names([totality_every_subject_classifies, determinism_every_query_answers_once, every_lawful_result_is_in_the_vocabulary, every_purpose_result_is_in_the_vocabulary, some_lawful_answers_are_not_final, a_final_answer_cites_article_6_1, a_final_citation_is_in_the_vocabulary, purpose_basis_is_empty, a_missing_key_is_named]).
cp_test_fail_names([no_query_answers_twice_or_never, a_not_final_lawful_answer_carries_no_basis_or_citation, a_final_answer_without_article_6_1, a_final_citation_outside_the_vocabulary, purpose_basis_is_never_filled, a_not_final_purpose_answer_carries_no_citation, an_outside_fact_or_optional_key_is_never_named_missing]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
