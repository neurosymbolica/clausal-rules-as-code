% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_act_connected_product_data_sharing_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [is_list/1]).
:- use_module(m__eu_data_act_connected_product_data_sharing_data_act_connected_product_data_sharing, [product_design_duty_status/3, pre_contract_information_duty_status/3, user_access_request_status/3, third_party_sharing_request_status/3, decide_data_act_connected_product_data_sharing/2, data_act_connected_product_data_sharing_status/2]).
:- use_module(m__eu_data_act_connected_product_data_sharing_fixtures, [data_act_connected_product_data_sharing_subject/1, data_act_connected_product_data_sharing_profile_for/2]).

query_name(product_design_duty_status).
query_name(pre_contract_information_duty_status).
query_name(user_access_request_status).
query_name(third_party_sharing_request_status).

final_result(product_design_duty_status, design_duty_met).
final_result(product_design_duty_status, design_duty_not_met).
final_result(product_design_duty_status, not_applicable).
final_result(pre_contract_information_duty_status, information_duty_met).
final_result(pre_contract_information_duty_status, information_duty_not_met).
final_result(pre_contract_information_duty_status, not_applicable).
final_result(user_access_request_status, access_due).
final_result(user_access_request_status, not_applicable).
final_result(user_access_request_status, refusal_permitted_security_restriction).
final_result(user_access_request_status, personal_data_not_to_be_made_available).
final_result(user_access_request_status, withholding_permitted_trade_secrets).
final_result(third_party_sharing_request_status, sharing_due).
final_result(third_party_sharing_request_status, not_applicable).
final_result(third_party_sharing_request_status, third_party_not_eligible_gatekeeper).
final_result(third_party_sharing_request_status, personal_data_not_to_be_made_available).
final_result(third_party_sharing_request_status, trade_secret_disclosure_not_permitted).
final_result(third_party_sharing_request_status, withholding_permitted_trade_secrets).

citation_allowed(product_design_duty_status, eu_reg_2023_2854_art_3_1).
citation_allowed(pre_contract_information_duty_status, eu_reg_2023_2854_art_3_2).
citation_allowed(pre_contract_information_duty_status, eu_reg_2023_2854_art_3_3).
citation_allowed(user_access_request_status, eu_reg_2023_2854_art_4_1).
citation_allowed(user_access_request_status, eu_reg_2023_2854_art_4_2).
citation_allowed(user_access_request_status, eu_reg_2023_2854_art_4_12).
citation_allowed(user_access_request_status, eu_reg_2023_2854_art_4_7).
citation_allowed(third_party_sharing_request_status, eu_reg_2023_2854_art_5_1).
citation_allowed(third_party_sharing_request_status, eu_reg_2023_2854_art_5_3).
citation_allowed(third_party_sharing_request_status, eu_reg_2023_2854_art_5_7).
citation_allowed(third_party_sharing_request_status, eu_reg_2023_2854_art_5_9).
citation_allowed(third_party_sharing_request_status, eu_reg_2023_2854_art_5_10).

referral_citation(eu_reg_2023_2854_art_2_5).
referral_citation(eu_reg_2023_2854_art_2_12).
referral_citation(eu_reg_2023_2854_art_2_13).
referral_citation(eu_reg_2023_2854_art_2_17).
referral_citation(eu_reg_2023_2854_art_3_1).
referral_citation(eu_reg_2023_2854_art_3_2).
referral_citation(eu_reg_2023_2854_art_3_3).
referral_citation(eu_reg_2023_2854_art_4_1).
referral_citation(eu_reg_2023_2854_art_4_2).
referral_citation(eu_reg_2023_2854_art_4_7).
referral_citation(eu_reg_2023_2854_art_4_8).
referral_citation(eu_reg_2023_2854_art_4_12).
referral_citation(eu_reg_2023_2854_art_5_1).
referral_citation(eu_reg_2023_2854_art_5_3).
referral_citation(eu_reg_2023_2854_art_5_7).
referral_citation(eu_reg_2023_2854_art_5_9).
referral_citation(eu_reg_2023_2854_art_5_10).
referral_citation(eu_reg_2023_2854_art_5_11).
referral_citation(eu_reg_2023_2854_art_7_1).

cases(Cases) :-
    findall(Subject - Query, (data_act_connected_product_data_sharing_subject(Subject), query_name(Query)), Cases).

answers_of(Subject - Query, Answers) :-
    data_act_connected_product_data_sharing_profile_for(Subject, Profile),
    findall(Result - Citations, call(Query, Profile, Result, Citations), Answers).

exactly_one_answer(Case) :-
    answers_of(Case, Answers),
    length(Answers, 1).

well_shaped_case(Subject - Query) :-
    answers_of(Subject - Query, Answers),
    maplist(well_shaped(Query), Answers).

well_shaped(Query, Result - Citations) :-
    result_kind(Query, Result, Kind),
    kind_citations(Kind, Query, Citations).

result_kind(_, input_problems([_|_]), non_final).
result_kind(_, indeterminate([Key]), non_final) :-
    atom(Key).
result_kind(_, needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]), non_final) :-
    atom(Key),
    referral_citation(CitationKey),
    is_list(Pairs).
result_kind(Query, Result, final) :-
    atom(Result),
    final_result(Query, Result).

kind_citations(non_final, _, []).
kind_citations(final, Query, [Citation|Citations]) :-
    maplist(allowed_cite(Query), [Citation|Citations]),
    sort([Citation|Citations], Unique),
    length(Unique, Count),
    length([Citation|Citations], Count).

allowed_cite(Query, cite(Key)) :-
    citation_allowed(Query, Key).

facade_agrees(Subject) :-
    data_act_connected_product_data_sharing_profile_for(Subject, Profile),
    user_access_request_status(Profile, Result, _),
    data_act_connected_product_data_sharing_status(Profile, Status),
    expected_status(Result, Status).

expected_status(access_due, eligible).
expected_status(not_applicable, ineligible).
expected_status(refusal_permitted_security_restriction, ineligible).
expected_status(personal_data_not_to_be_made_available, ineligible).
expected_status(withholding_permitted_trade_secrets, ineligible).
expected_status(indeterminate(Keys), indeterminate(Keys)).
expected_status(needs_legal_review(Reason, Context), needs_legal_review(Reason, Context)).
expected_status(input_problems(Problems), input_problems(Problems)).

facade_verdict_count(Subject) :-
    data_act_connected_product_data_sharing_profile_for(Subject, Profile),
    findall(Verdict, decide_data_act_connected_product_data_sharing(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

test(totality_and_determinism_of_every_query) :-
    cases(Cases),
    Cases = [_|_],
    maplist(exactly_one_answer, Cases).
test(every_answer_is_well_shaped) :-
    cases(Cases),
    maplist(well_shaped_case, Cases).
test(the_facade_has_one_verdict_per_subject) :-
    findall(Subject, data_act_connected_product_data_sharing_subject(Subject), Subjects),
    maplist(facade_verdict_count, Subjects).
test(the_facade_agrees_with_the_user_access_answer) :-
    findall(Subject, data_act_connected_product_data_sharing_subject(Subject), Subjects),
    maplist(facade_agrees, Subjects).
test(the_subject_registry_is_duplicate_free) :-
    findall(Subject, data_act_connected_product_data_sharing_subject(Subject), Subjects),
    sort(Subjects, Unique),
    length(Subjects, Count),
    length(Unique, Count).
test(a_final_result_with_citations_is_well_shaped) :-
    well_shaped(user_access_request_status, access_due - [cite(eu_reg_2023_2854_art_4_1)]).

test(a_foreign_result_is_not_well_shaped, fail) :-
    well_shaped(user_access_request_status, sharing_due - [cite(eu_reg_2023_2854_art_5_1)]).
test(a_final_result_without_citations_is_not_well_shaped, fail) :-
    well_shaped(user_access_request_status, access_due - []).

cp_test_names([totality_and_determinism_of_every_query, every_answer_is_well_shaped, the_facade_has_one_verdict_per_subject, the_facade_agrees_with_the_user_access_answer, the_subject_registry_is_duplicate_free, a_final_result_with_citations_is_well_shaped]).
cp_test_fail_names([a_foreign_result_is_not_well_shaped, a_final_result_without_citations_is_not_well_shaped]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
