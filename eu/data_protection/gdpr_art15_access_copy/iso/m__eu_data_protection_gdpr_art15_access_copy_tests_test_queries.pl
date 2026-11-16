% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art15_access_copy_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_queries, [gdpr_art15_access_copy_profile_keys/1, gdpr_art15_access_copy_what_if/4, gdpr_art15_access_copy_compliance/4, gdpr_art15_access_copy_deadline/3, confirmation_of_processing/0, copy_of_personal_data/0, no_item_missing/0, full_copy/0, reasonable_fee_permitted/0, commonly_used_electronic_form/0]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_kernel, [gdpr_art15_access_copy_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_gdpr_art15_access_copy, [decide_gdpr_art15_access_copy/2]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_fixtures, [gdpr_art15_access_copy_profile_for/2]).

test(profile_keys_are_the_contract_keys) :-
    gdpr_art15_access_copy_profile_keys(ProfileKeys),
    ProfileKeys == [items_provided, personal_data_concerning_data_subject_processed, disclosure_to_recipients_made_or_envisaged, some_personal_data_not_collected_from_data_subject, source_information_available, automated_decision_making_referred_to_in_article_22, transfer_to_third_country_or_international_organisation, transfer_subject_to_article_46_safeguards, copy_would_adversely_affect_rights_and_freedoms_of_others, further_copy_requested, request_made_by_electronic_means, other_form_requested_by_data_subject].
test(the_re_exported_input_check_answers) :-
    gdpr_art15_access_copy_input_problems([attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(the_verdict_is_reachable_through_the_slice) :-
    gdpr_art15_access_copy_profile_for(full_answer_all_items_given, Profile),
    decide_gdpr_art15_access_copy(Profile, gdpr_art15_access_copy_verdict(access_answer_complete, [cite(eu_reg_2016_679_art_15_1)])).
test(what_if_the_confirmation_were_given) :-
    gdpr_art15_access_copy_profile_for(no_personal_data_confirmation_not_given, Profile),
    gdpr_art15_access_copy_what_if(Profile, items_provided, [confirmation_of_processing], access_answer_complete).
test(what_if_yields_one_status) :-
    gdpr_art15_access_copy_profile_for(no_personal_data_confirmation_not_given, Profile),
    findall(Status, gdpr_art15_access_copy_what_if(Profile, items_provided, [confirmation_of_processing], Status), Statuses),
    Statuses == [access_answer_complete].
test(omitting_the_confirmation_is_not_permitted) :-
    findall(Outcome - Citations, gdpr_art15_access_copy_compliance([attribute(personal_data_concerning_data_subject_processed, false)], omit_item(confirmation_of_processing), Outcome, Citations), Answers),
    Answers == [action_not_permitted - [cite(eu_reg_2016_679_art_15_1)]].
test(omitting_an_item_not_owed_is_permitted) :-
    gdpr_art15_access_copy_compliance([attribute(personal_data_concerning_data_subject_processed, false)], omit_item(copy_of_personal_data), action_permitted, [cite(eu_reg_2016_679_art_15_3)]).
test(refusing_the_copy_of_processed_data_is_not_permitted) :-
    gdpr_art15_access_copy_compliance([attribute(personal_data_concerning_data_subject_processed, true)], refuse_copy, action_not_permitted, [cite(eu_reg_2016_679_art_15_3)]).
test(refusing_a_copy_with_no_data_is_not_applicable) :-
    gdpr_art15_access_copy_compliance([attribute(personal_data_concerning_data_subject_processed, false)], refuse_copy, action_not_applicable, [cite(eu_reg_2016_679_art_15_3)]).
test(a_full_copy_where_others_are_affected_is_not_permitted) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_true, Profile),
    gdpr_art15_access_copy_compliance(Profile, provide_full_copy, action_not_permitted, Citations),
    sort(Citations, [cite(eu_reg_2016_679_art_15_3), cite(eu_reg_2016_679_art_15_4)]).
test(a_limited_copy_where_others_are_affected_is_permitted) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_true, Profile),
    gdpr_art15_access_copy_compliance(Profile, provide_limited_copy, action_permitted, _).
test(a_fee_for_the_first_copy_is_not_permitted_under_article_15) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_false, Profile),
    gdpr_art15_access_copy_compliance(Profile, charge_fee_for_copy, action_not_permitted_under_article_15, [cite(eu_reg_2016_679_art_15_3)]).
test(a_fee_for_a_further_copy_is_permitted) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_true, Profile),
    gdpr_art15_access_copy_compliance(Profile, charge_fee_for_copy, action_permitted, [cite(eu_reg_2016_679_art_15_3)]).
test(another_form_against_an_electronic_request_is_not_permitted) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_false, Profile),
    gdpr_art15_access_copy_compliance(Profile, provide_answer_in_other_form, action_not_permitted, [cite(eu_reg_2016_679_art_15_3)]).
test(a_missing_key_passes_through_compliance) :-
    findall(Outcome - Citations, gdpr_art15_access_copy_compliance([], provide_full_copy, Outcome, Citations), Answers),
    Answers == [indeterminate([personal_data_concerning_data_subject_processed]) - []].
test(input_problems_pass_through_compliance) :-
    gdpr_art15_access_copy_compliance([attribute(colour, blue)], omit_item(confirmation_of_processing), input_problems([unknown_key(colour)]), []),
    gdpr_art15_access_copy_compliance([attribute(colour, blue)], refuse_copy, input_problems([unknown_key(colour)]), []).
test(the_deadline_is_decided_by_the_sibling_order) :-
    gdpr_art15_access_copy_profile_for(full_answer_all_items_given, Profile),
    findall(Result, gdpr_art15_access_copy_deadline(Profile, Result, []), Results),
    Results == [deadline_decided_by_sibling_order(gdpr_data_subject_rights_response_period)].
test(the_deadline_refuses_a_malformed_profile) :-
    gdpr_art15_access_copy_deadline([attribute(colour, blue)], input_problems([unknown_key(colour)]), []).
test(the_root_atoms_resolve) :-
    confirmation_of_processing,
    copy_of_personal_data,
    no_item_missing,
    full_copy,
    reasonable_fee_permitted,
    commonly_used_electronic_form.

test(an_unknown_action_has_no_outcome, fail) :-
    gdpr_art15_access_copy_compliance([attribute(personal_data_concerning_data_subject_processed, true)], sell_the_data, _, _).

cp_test_names([profile_keys_are_the_contract_keys, the_re_exported_input_check_answers, the_verdict_is_reachable_through_the_slice, what_if_the_confirmation_were_given, what_if_yields_one_status, omitting_the_confirmation_is_not_permitted, omitting_an_item_not_owed_is_permitted, refusing_the_copy_of_processed_data_is_not_permitted, refusing_a_copy_with_no_data_is_not_applicable, a_full_copy_where_others_are_affected_is_not_permitted, a_limited_copy_where_others_are_affected_is_permitted, a_fee_for_the_first_copy_is_not_permitted_under_article_15, a_fee_for_a_further_copy_is_permitted, another_form_against_an_electronic_request_is_not_permitted, a_missing_key_passes_through_compliance, input_problems_pass_through_compliance, the_deadline_is_decided_by_the_sibling_order, the_deadline_refuses_a_malformed_profile, the_root_atoms_resolve]).
cp_test_fail_names([an_unknown_action_has_no_outcome]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
