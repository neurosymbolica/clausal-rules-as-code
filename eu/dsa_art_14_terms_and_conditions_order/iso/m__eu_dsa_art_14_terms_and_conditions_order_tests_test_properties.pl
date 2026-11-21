% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dsa_art_14_terms_and_conditions_order_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_dsa_art_14_terms_and_conditions_order, [art_14_1_terms_and_conditions_content_status/4, art_14_2_significant_change_information_status/4, art_14_3_minors_explanation_status/4, art_14_4_restriction_enforcement_status/4, art_14_5_terms_and_conditions_summary_status/4, art_14_6_official_languages_status/4, decide_dsa_art_14_terms_and_conditions_order/2]).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_kernel, [dsa_art_14_terms_and_conditions_order_input_problems/2]).
:- use_module(m__eu_dsa_art_14_terms_and_conditions_order_fixtures, [dsa_art_14_terms_and_conditions_order_subject/1, dsa_art_14_terms_and_conditions_order_profile_for/2]).

paragraph(art_14_1).
paragraph(art_14_2).
paragraph(art_14_3).
paragraph(art_14_4).
paragraph(art_14_5).
paragraph(art_14_6).

paragraph_citation(art_14_1, cite(eu_reg_2022_2065_art_14_1)).
paragraph_citation(art_14_2, cite(eu_reg_2022_2065_art_14_2)).
paragraph_citation(art_14_3, cite(eu_reg_2022_2065_art_14_3)).
paragraph_citation(art_14_4, cite(eu_reg_2022_2065_art_14_4)).
paragraph_citation(art_14_5, cite(eu_reg_2022_2065_art_14_5)).
paragraph_citation(art_14_6, cite(eu_reg_2022_2065_art_14_6)).

final_result(art_14_1, art_14_1_terms_and_conditions_compliant).
final_result(art_14_1, art_14_1_terms_and_conditions_not_compliant).
final_result(art_14_2, art_14_2_change_information_compliant).
final_result(art_14_2, art_14_2_change_information_not_compliant).
final_result(art_14_2, art_14_2_change_information_not_required).
final_result(art_14_3, art_14_3_minors_explanation_compliant).
final_result(art_14_3, art_14_3_minors_explanation_not_compliant).
final_result(art_14_3, art_14_3_minors_explanation_not_required).
final_result(art_14_4, art_14_4_restriction_enforcement_compliant).
final_result(art_14_4, art_14_4_restriction_enforcement_not_compliant).
final_result(art_14_4, art_14_4_restriction_enforcement_not_required).
final_result(art_14_5, art_14_5_summary_compliant).
final_result(art_14_5, art_14_5_summary_not_compliant).
final_result(art_14_5, art_14_5_summary_not_required).
final_result(art_14_6, art_14_6_official_languages_compliant).
final_result(art_14_6, art_14_6_official_languages_not_compliant).
final_result(art_14_6, art_14_6_official_languages_not_required).

final_basis(art_14_1, []).
final_basis(art_14_2, []).
final_basis(art_14_3, []).
final_basis(art_14_4, []).
final_basis(art_14_5, [outside_fact(designated_as_very_large_online_platform_or_search_engine, attested(_, attestation(_, _, _, _)))]).
final_basis(art_14_6, [outside_fact(designated_as_very_large_online_platform_or_search_engine, attested(_, attestation(_, _, _, _)))]).

query_answer(art_14_1, Profile, Result, Basis, Citations) :-
    art_14_1_terms_and_conditions_content_status(Profile, Result, Basis, Citations).
query_answer(art_14_2, Profile, Result, Basis, Citations) :-
    art_14_2_significant_change_information_status(Profile, Result, Basis, Citations).
query_answer(art_14_3, Profile, Result, Basis, Citations) :-
    art_14_3_minors_explanation_status(Profile, Result, Basis, Citations).
query_answer(art_14_4, Profile, Result, Basis, Citations) :-
    art_14_4_restriction_enforcement_status(Profile, Result, Basis, Citations).
query_answer(art_14_5, Profile, Result, Basis, Citations) :-
    art_14_5_terms_and_conditions_summary_status(Profile, Result, Basis, Citations).
query_answer(art_14_6, Profile, Result, Basis, Citations) :-
    art_14_6_official_languages_status(Profile, Result, Basis, Citations).

subject_paragraph_pairs(Pairs) :-
    findall(Subject - Paragraph, (dsa_art_14_terms_and_conditions_order_subject(Subject), paragraph(Paragraph)), Pairs).

one_answer(Subject - Paragraph) :-
    dsa_art_14_terms_and_conditions_order_profile_for(Subject, Profile),
    findall(Result, query_answer(Paragraph, Profile, Result, _, _), Results),
    length(Results, 1).

one_verdict(Subject) :-
    dsa_art_14_terms_and_conditions_order_profile_for(Subject, Profile),
    findall(Verdict, decide_dsa_art_14_terms_and_conditions_order(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

well_shaped(Subject - Paragraph) :-
    dsa_art_14_terms_and_conditions_order_profile_for(Subject, Profile),
    query_answer(Paragraph, Profile, Result, Basis, Citations),
    answer_shape(Paragraph, Result, Basis, Citations).

answer_shape(Paragraph, Result, Basis, Citations) :-
    atom(Result),
    final_result(Paragraph, Result),
    paragraph_citation(Paragraph, Citation),
    Citations == [Citation],
    final_basis(Paragraph, Basis).
answer_shape(_, Result, Basis, Citations) :-
    compound(Result),
    Basis == [],
    Citations == [].

designation_false_subject(Subject) :-
    dsa_art_14_terms_and_conditions_order_subject(Subject),
    dsa_art_14_terms_and_conditions_order_profile_for(Subject, Profile),
    dsa_art_14_terms_and_conditions_order_input_problems(Profile, []),
    member(attribute(designated_as_very_large_online_platform_or_search_engine, attested(false, _)), Profile).

both_not_required(Subject) :-
    dsa_art_14_terms_and_conditions_order_profile_for(Subject, Profile),
    art_14_5_terms_and_conditions_summary_status(Profile, art_14_5_summary_not_required, _, _),
    art_14_6_official_languages_status(Profile, art_14_6_official_languages_not_required, _, _).

same_problems_everywhere(Subject) :-
    dsa_art_14_terms_and_conditions_order_profile_for(Subject, Profile),
    dsa_art_14_terms_and_conditions_order_input_problems(Profile, [Problem|Problems]),
    findall(Paragraph - Result, (paragraph(Paragraph), query_answer(Paragraph, Profile, Result, _, _)), Answers),
    findall(Paragraph - input_problems([Problem|Problems]), paragraph(Paragraph), Expected),
    length(Answers, 6),
    Answers = Expected.

test(totality_every_subject_classifies) :-
    findall(Subject, dsa_art_14_terms_and_conditions_order_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(one_verdict, Subjects).
test(determinism_every_query_has_exactly_one_answer_per_subject) :-
    subject_paragraph_pairs(Pairs),
    Pairs = [_|_],
    maplist(one_answer, Pairs).
test(every_answer_carries_its_fixed_basis_and_citations) :-
    subject_paragraph_pairs(Pairs),
    maplist(well_shaped, Pairs).
test(an_attested_false_designation_settles_both_duties_alike) :-
    findall(Subject, designation_false_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(both_not_required, Subjects).
test(input_problems_are_the_same_in_every_query) :-
    maplist(same_problems_everywhere, [malformed_duplicate_and_unknown_keys]).
test(an_absent_key_is_never_an_input_problem) :-
    dsa_art_14_terms_and_conditions_order_profile_for(empty_profile, Profile),
    dsa_art_14_terms_and_conditions_order_input_problems(Profile, Problems),
    Problems == [].

cp_test_names([totality_every_subject_classifies, determinism_every_query_has_exactly_one_answer_per_subject, every_answer_carries_its_fixed_basis_and_citations, an_attested_false_designation_settles_both_duties_alike, input_problems_are_the_same_in_every_query, an_absent_key_is_never_an_input_problem]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
