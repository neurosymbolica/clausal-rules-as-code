% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_act_connected_product_data_sharing_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_act_connected_product_data_sharing_kernel, [data_act_connected_product_data_sharing_input_problems/2]).
:- use_module(m__eu_data_act_connected_product_data_sharing_citations, [citation/2, implements/1]).

recorded(Key) :-
    citation(Key, _Record).

test(the_final_answer_carries_result_and_citations) :-
    Answer = answer(access_due, [cite(eu_reg_2023_2854_art_4_1)]),
    Answer = answer(Result, Citations),
    Result == access_due,
    Citations == [cite(eu_reg_2023_2854_art_4_1)].
test(the_indeterminate_result_names_one_key) :-
    Result = indeterminate([requester_is_user]),
    Result = indeterminate([MissingKey]),
    MissingKey == requester_is_user.
test(the_referral_result_destructures) :-
    Result = needs_legal_review(open_textured(exceptional_trade_secret_refusal_invoked, cite(eu_reg_2023_2854_art_4_8)), [inputs_relied_on([requested_data_identified_as_trade_secrets - true, exceptional_trade_secret_refusal_invoked - true])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == exceptional_trade_secret_refusal_invoked,
    CitationKey == eu_reg_2023_2854_art_4_8,
    Pairs == [requested_data_identified_as_trade_secrets - true, exceptional_trade_secret_refusal_invoked - true].
test(the_input_problems_result_destructures) :-
    Result = input_problems([wrong_type(profile)]),
    Result = input_problems(Problems),
    Problems == [wrong_type(profile)].
test(the_slice_verdict_term_carries_status_and_citations) :-
    Verdict = data_act_connected_product_data_sharing_verdict(eligible, [cite(eu_reg_2023_2854_art_4_1)]),
    Verdict = data_act_connected_product_data_sharing_verdict(Status, Citations),
    Status == eligible,
    Citations == [cite(eu_reg_2023_2854_art_4_1)].
test(the_design_duty_atoms_are_distinct) :-
    dif(design_duty_met, design_duty_not_met),
    dif(design_duty_met, not_applicable),
    dif(design_duty_not_met, not_applicable).
test(the_information_duty_atoms_are_distinct) :-
    dif(information_duty_met, information_duty_not_met),
    dif(information_duty_met, not_applicable),
    dif(information_duty_not_met, not_applicable).
test(the_user_access_atoms_are_distinct) :-
    dif(access_due, not_applicable),
    dif(access_due, refusal_permitted_security_restriction),
    dif(access_due, personal_data_not_to_be_made_available),
    dif(access_due, withholding_permitted_trade_secrets),
    dif(refusal_permitted_security_restriction, personal_data_not_to_be_made_available),
    dif(refusal_permitted_security_restriction, withholding_permitted_trade_secrets),
    dif(personal_data_not_to_be_made_available, withholding_permitted_trade_secrets).
test(the_third_party_sharing_atoms_are_distinct) :-
    dif(sharing_due, not_applicable),
    dif(sharing_due, third_party_not_eligible_gatekeeper),
    dif(third_party_not_eligible_gatekeeper, personal_data_not_to_be_made_available),
    dif(personal_data_not_to_be_made_available, trade_secret_disclosure_not_permitted),
    dif(trade_secret_disclosure_not_permitted, withholding_permitted_trade_secrets).
test(the_contract_kind_atoms_are_distinct) :-
    dif(purchase_rent_or_lease_of_connected_product, provision_of_related_service).
test(the_design_duty_citation_is_recorded) :-
    citation(eu_reg_2023_2854_art_3_1, Record),
    Record = [label - _Label, ref - _Reference, verbatim - _Verbatim].
test(every_load_bearing_citation_is_recorded) :-
    maplist(recorded, [eu_reg_2023_2854_art_2_5, eu_reg_2023_2854_art_2_12, eu_reg_2023_2854_art_2_13, eu_reg_2023_2854_art_2_17, eu_reg_2023_2854_art_3_1, eu_reg_2023_2854_art_3_2, eu_reg_2023_2854_art_3_3, eu_reg_2023_2854_art_4_1, eu_reg_2023_2854_art_4_2, eu_reg_2023_2854_art_4_7, eu_reg_2023_2854_art_4_8, eu_reg_2023_2854_art_4_12, eu_reg_2023_2854_art_5_1, eu_reg_2023_2854_art_5_3, eu_reg_2023_2854_art_5_7, eu_reg_2023_2854_art_5_9, eu_reg_2023_2854_art_5_10, eu_reg_2023_2854_art_5_11, eu_reg_2023_2854_art_7_1]).
test(every_quoted_unit_is_recorded) :-
    maplist(recorded, [eu_reg_2023_2854_art_2_6, eu_reg_2023_2854_art_2_15, eu_reg_2023_2854_art_2_16, eu_reg_2023_2854_art_3_2_a, eu_reg_2023_2854_art_3_2_b, eu_reg_2023_2854_art_3_2_c, eu_reg_2023_2854_art_3_2_d, eu_reg_2023_2854_art_3_3_a, eu_reg_2023_2854_art_3_3_b, eu_reg_2023_2854_art_3_3_c, eu_reg_2023_2854_art_3_3_d, eu_reg_2023_2854_art_3_3_e, eu_reg_2023_2854_art_3_3_f, eu_reg_2023_2854_art_3_3_g, eu_reg_2023_2854_art_3_3_h, eu_reg_2023_2854_art_3_3_i, eu_reg_2023_2854_art_4_6, eu_reg_2023_2854_art_5_2, eu_reg_2023_2854_art_7_t1, eu_reg_2023_2854_art_50_t2, eu_reg_2023_2854_art_50_t3]).
test(the_provenance_marker_holds_for_a_recorded_key) :-
    implements(eu_reg_2023_2854_art_4_1).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, data_act_connected_product_data_sharing_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(connected_product_or_related_service, true), attribute(small_enterprise_exemption_applies, unsure), attribute(pre_contract_contract_kind, provision_of_related_service), attribute(exceptional_trade_secret_refusal_invoked, false)],
    findall(Problems, data_act_connected_product_data_sharing_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(a_term_that_is_not_a_list_is_the_wrong_type) :-
    findall(Problems, data_act_connected_product_data_sharing_input_problems(not_a_profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_the_wrong_type) :-
    findall(Problems, data_act_connected_product_data_sharing_input_problems(_Unbound, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_list_with_a_stray_element_is_the_wrong_type) :-
    findall(Problems, data_act_connected_product_data_sharing_input_problems([attribute(requester_is_user, true), stray], Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(unsure_is_outside_the_boolean_type) :-
    findall(Problems, data_act_connected_product_data_sharing_input_problems([attribute(testing_data_not_yet_on_market, unsure)], Problems), Answers),
    Answers == [[wrong_type(testing_data_not_yet_on_market)]].
test(an_attested_value_is_the_wrong_type) :-
    findall(Problems, data_act_connected_product_data_sharing_input_problems([attribute(requester_is_user, attested(true))], Problems), Answers),
    Answers == [[wrong_type(requester_is_user)]].
test(contract_key_problems_come_before_unknown_keys) :-
    Profile = [attribute(colour, blue), attribute(requester_is_user, maybe), attribute(colour, red)],
    findall(Problems, data_act_connected_product_data_sharing_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(requester_is_user), unknown_key(colour)]].
test(a_repeated_key_is_a_duplicate_and_never_also_the_wrong_type) :-
    Profile = [attribute(requester_is_user, true), attribute(requester_is_user, maybe)],
    findall(Problems, data_act_connected_product_data_sharing_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(requester_is_user)]].

test(the_placeholder_citation_is_not_recorded, fail) :-
    citation(eu_todo_primary_source, _Record).
test(the_provenance_marker_fails_for_an_unrecorded_key, fail) :-
    implements(eu_reg_2023_2854_art_4).

cp_test_names([the_final_answer_carries_result_and_citations, the_indeterminate_result_names_one_key, the_referral_result_destructures, the_input_problems_result_destructures, the_slice_verdict_term_carries_status_and_citations, the_design_duty_atoms_are_distinct, the_information_duty_atoms_are_distinct, the_user_access_atoms_are_distinct, the_third_party_sharing_atoms_are_distinct, the_contract_kind_atoms_are_distinct, the_design_duty_citation_is_recorded, every_load_bearing_citation_is_recorded, every_quoted_unit_is_recorded, the_provenance_marker_holds_for_a_recorded_key, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_term_that_is_not_a_list_is_the_wrong_type, an_unbound_profile_is_the_wrong_type, a_list_with_a_stray_element_is_the_wrong_type, unsure_is_outside_the_boolean_type, an_attested_value_is_the_wrong_type, contract_key_problems_come_before_unknown_keys, a_repeated_key_is_a_duplicate_and_never_also_the_wrong_type]).
cp_test_fail_names([the_placeholder_citation_is_not_recorded, the_provenance_marker_fails_for_an_unrecorded_key]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
