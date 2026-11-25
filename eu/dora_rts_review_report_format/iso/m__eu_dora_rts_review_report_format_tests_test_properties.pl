% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_rts_review_report_format_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_rts_review_report_format_dora_rts_review_report_format, [decide_dora_rts_review_report_format/2, ict_risk_framework_review_report_duties_required/3, ict_risk_framework_review_report_duties_complete/3, ict_risk_framework_review_report_duties_outstanding/3]).
:- use_module(m__eu_dora_rts_review_report_format_fixtures, [dora_rts_review_report_format_subject/1, dora_rts_review_report_format_profile_for/2]).

citation_vocabulary([eu_reg_2024_1774_art_27_1, eu_reg_2024_1774_art_27_2_a_i, eu_reg_2024_1774_art_27_2_a_ii, eu_reg_2024_1774_art_27_2_a_iii, eu_reg_2024_1774_art_27_2_a_iv, eu_reg_2024_1774_art_27_2_b, eu_reg_2024_1774_art_27_2_c, eu_reg_2024_1774_art_27_2, eu_reg_2024_1774_art_27_2_d, eu_reg_2024_1774_art_27_2_e, eu_reg_2024_1774_art_27_2_f, eu_reg_2024_1774_art_27_2_g, eu_reg_2024_1774_art_27_2_h_i, eu_reg_2024_1774_art_27_2_h_ii, eu_reg_2024_1774_art_27_2_h_iii, eu_reg_2024_1774_art_27_2_h_iv, eu_reg_2024_1774_art_27_2_h_v, eu_reg_2024_1774_art_27_2_h_vi, eu_reg_2024_1774_art_27_2_i, eu_reg_2024_1774_art_27_2_j, eu_reg_2024_1774_art_27_2_k_i, eu_reg_2024_1774_art_27_2_k_ii, eu_reg_2024_1774_art_27_2_k_iii, eu_reg_2024_1774_art_27_2_l_i, eu_reg_2024_1774_art_27_2_l_ii, eu_reg_2024_1774_art_27_2_l_iii, eu_reg_2024_1774_art_27_2_l_iv, eu_reg_2022_2554_art_16_1]).

known_citation(cite(CitationKey)) :-
    citation_vocabulary(Vocabulary),
    member(CitationKey, Vocabulary).

distinct_citations(Citations) :-
    sort(Citations, Sorted),
    length(Citations, Count),
    length(Sorted, Count).

fixed_citations(Citations) :-
    clausal_msort(Citations, Sorted),
    Sorted == [cite(eu_reg_2024_1774_art_27_1), cite(eu_reg_2024_1774_art_27_2)].

query_name(required_query).
query_name(completeness_query).
query_name(outstanding_query).

answers_of(required_query, Profile, Answers) :-
    findall(Result - Citations, ict_risk_framework_review_report_duties_required(Profile, Result, Citations), Answers).
answers_of(completeness_query, Profile, Answers) :-
    findall(Result - Citations, ict_risk_framework_review_report_duties_complete(Profile, Result, Citations), Answers).
answers_of(outstanding_query, Profile, Answers) :-
    findall(Result - Citations, ict_risk_framework_review_report_duties_outstanding(Profile, Result, Citations), Answers).

subject_classifies(Subject) :-
    dora_rts_review_report_format_subject(Subject),
    dora_rts_review_report_format_profile_for(Subject, Profile),
    decide_dora_rts_review_report_format(Profile, _Verdict).

answers_once(Subject, QueryName) :-
    dora_rts_review_report_format_profile_for(Subject, Profile),
    answers_of(QueryName, Profile, [_]).

subject_answer(Subject, QueryName, Answer) :-
    dora_rts_review_report_format_subject(Subject),
    query_name(QueryName),
    dora_rts_review_report_format_profile_for(Subject, Profile),
    answers_of(QueryName, Profile, Answers),
    member(Answer, Answers).

answer_well_cited(Result - Citations) :-
    result_citation_shape(Result, Citations).

result_citation_shape(indeterminate([_]), []).
result_citation_shape(needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on(_)|_]), []).
result_citation_shape(input_problems([_|_]), []).
result_citation_shape(framework_review_report_not_requested, []).
result_citation_shape(simplified_framework_entity, [cite(eu_reg_2022_2554_art_16_1)]).
result_citation_shape(complete, Citations) :-
    fixed_citations(Citations).
result_citation_shape(incomplete, Citations) :-
    fixed_citations(Citations).
result_citation_shape(none_outstanding, Citations) :-
    fixed_citations(Citations).
result_citation_shape(required([_|_]), [FirstCitation|OtherCitations]) :-
    maplist(known_citation, [FirstCitation|OtherCitations]),
    distinct_citations([FirstCitation|OtherCitations]).
result_citation_shape(outstanding([_|_]), [FirstCitation|OtherCitations]) :-
    maplist(known_citation, [FirstCitation|OtherCitations]),
    distinct_citations([FirstCitation|OtherCitations]).

subsequence([], _).
subsequence([Element|Elements], [Element|Others]) :-
    subsequence(Elements, Others).
subsequence([Element|Elements], [Other|Others]) :-
    dif(Element, Other),
    subsequence([Element|Elements], Others).

full_duty_order(Duties) :-
    dora_rts_review_report_format_profile_for(all_conditions_complete, Profile),
    ict_risk_framework_review_report_duties_required(Profile, required(Duties), _).

in_duty_order(Order, Duties) :-
    subsequence(Duties, Order).

required_list(Subject, Duties) :-
    dora_rts_review_report_format_subject(Subject),
    dora_rts_review_report_format_profile_for(Subject, Profile),
    ict_risk_framework_review_report_duties_required(Profile, required(Duties), _).

has_outstanding(Subject) :-
    dora_rts_review_report_format_subject(Subject),
    dora_rts_review_report_format_profile_for(Subject, Profile),
    ict_risk_framework_review_report_duties_outstanding(Profile, outstanding(_), _).

outstanding_within_required(Subject) :-
    dora_rts_review_report_format_profile_for(Subject, Profile),
    ict_risk_framework_review_report_duties_outstanding(Profile, outstanding(Outstanding), _),
    ict_risk_framework_review_report_duties_required(Profile, required(Required), _),
    subsequence(Outstanding, Required).

consistent_pair(complete, none_outstanding).
consistent_pair(incomplete, outstanding(_)).
consistent_pair(incomplete, indeterminate(_)).
consistent_pair(incomplete, needs_legal_review(_, _)).
consistent_pair(indeterminate(_), indeterminate(_)).
consistent_pair(needs_legal_review(_, _), needs_legal_review(_, _)).
consistent_pair(simplified_framework_entity, simplified_framework_entity).
consistent_pair(framework_review_report_not_requested, framework_review_report_not_requested).
consistent_pair(input_problems(Problems), input_problems(Problems)).

subject_pair(Subject, CompleteResult - OutstandingResult) :-
    dora_rts_review_report_format_subject(Subject),
    dora_rts_review_report_format_profile_for(Subject, Profile),
    ict_risk_framework_review_report_duties_complete(Profile, CompleteResult, _),
    ict_risk_framework_review_report_duties_outstanding(Profile, OutstandingResult, _).

consistent_answer_pair(CompleteResult - OutstandingResult) :-
    consistent_pair(CompleteResult, OutstandingResult).

test(totality_every_subject_classifies) :-
    findall(Subject, dora_rts_review_report_format_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_answers_each_query_once) :-
    findall(Subject - QueryName, (dora_rts_review_report_format_subject(Subject), query_name(QueryName)), Expected),
    findall(Subject - QueryName, (dora_rts_review_report_format_subject(Subject), query_name(QueryName), answers_once(Subject, QueryName)), Actual),
    Actual == Expected.
test(every_answer_has_its_citation_shape) :-
    findall(Answer, subject_answer(_, _, Answer), Answers),
    Answers = [_|_],
    maplist(answer_well_cited, Answers).
test(the_full_duty_order_has_twenty_nine_duties) :-
    full_duty_order(Order),
    length(Order, 29),
    sort(Order, Distinct),
    length(Distinct, 29).
test(every_required_list_is_in_duty_order) :-
    full_duty_order(Order),
    findall(Duties, required_list(_, Duties), Lists),
    Lists = [_|_],
    maplist(in_duty_order(Order), Lists).
test(outstanding_duties_are_required_duties) :-
    findall(Subject, has_outstanding(Subject), WithOutstanding),
    WithOutstanding = [_|_],
    findall(Subject, (has_outstanding(Subject), outstanding_within_required(Subject)), Checked),
    Checked == WithOutstanding.
test(completeness_and_outstanding_agree) :-
    findall(Pair, subject_pair(_, Pair), Pairs),
    Pairs = [_|_],
    maplist(consistent_answer_pair, Pairs).

test(an_invented_citation_is_not_known, fail) :-
    known_citation(cite(eu_reg_2024_1774_art_27)).
test(complete_does_not_agree_with_outstanding_duties, fail) :-
    consistent_pair(complete, outstanding([report_gives_executive_summary])).
test(a_reversed_list_is_not_in_duty_order, fail) :-
    full_duty_order(Order),
    subsequence([report_uses_external_sources, report_in_searchable_electronic_format], Order).
test(a_status_with_citations_has_the_wrong_shape, fail) :-
    result_citation_shape(indeterminate([financial_entity_is_article_16_1_entity]), [cite(eu_reg_2024_1774_art_27_1)]).

cp_test_names([totality_every_subject_classifies, determinism_every_subject_answers_each_query_once, every_answer_has_its_citation_shape, the_full_duty_order_has_twenty_nine_duties, every_required_list_is_in_duty_order, outstanding_duties_are_required_duties, completeness_and_outstanding_agree]).
cp_test_fail_names([an_invented_citation_is_not_known, complete_does_not_agree_with_outstanding_duties, a_reversed_list_is_not_in_duty_order, a_status_with_citations_has_the_wrong_shape]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
