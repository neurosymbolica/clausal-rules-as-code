% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_information_route, [decide_information_route/2, information_route/2, information_route_status/2, information_items_owed/2, information_items_missing/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_further_processing_information_verdict, [further_processing_information_verdict/3, decide_further_processing_information_verdict/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_fixtures, [gdpr_information_duties_items_and_further_processing_profile_for/2]).

test(the_art13_profile_yields_exactly_one_status) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    findall(Status, information_route_status(Profile, Status), Statuses),
    Statuses == [art13].
test(the_art14_profile_yields_exactly_one_route) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_complete, Profile),
    findall(Route, information_route(Profile, Route), Routes),
    Routes == [art14].
test(the_verdict_carries_a_citation) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    decide_information_route(Profile, information_route_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(the_art13_owed_list_is_the_checklist_in_order) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    findall(Owed, information_items_owed(Profile, Owed), Answers),
    Answers == [[owed_item(controller_identity_and_contact_details, cite(eu_reg_2016_679_art_13_1_a)), owed_item(data_protection_officer_contact_details, cite(eu_reg_2016_679_art_13_1_b)), owed_item(purposes_and_legal_basis, cite(eu_reg_2016_679_art_13_1_c)), owed_item(recipients_or_categories_of_recipients, cite(eu_reg_2016_679_art_13_1_e)), owed_item(storage_period_or_criteria, cite(eu_reg_2016_679_art_13_2_a)), owed_item(data_subject_rights, cite(eu_reg_2016_679_art_13_2_b)), owed_item(right_to_lodge_complaint, cite(eu_reg_2016_679_art_13_2_d)), owed_item(statutory_or_contractual_requirement, cite(eu_reg_2016_679_art_13_2_e))]].
test(the_art14_owed_list_has_nine_items) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_complete, Profile),
    findall(Owed, information_items_owed(Profile, Owed), [OwedItems]),
    length(OwedItems, 9).
test(the_missing_list_is_read_out_once) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_categories_missing, Profile),
    findall(Missing, information_items_missing(Profile, Missing), Answers),
    Answers == [[missing_item(categories_of_personal_data, cite(eu_reg_2016_679_art_14_1_d))]].
test(the_unsure_covered_case_has_no_missing_item) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_automated_unsure_covered, Profile),
    findall(Missing, information_items_missing(Profile, Missing), Answers),
    Answers == [[no_item_missing]].
test(the_unsure_uncovered_case_is_referred_once) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_automated_unsure, Profile),
    findall(Missing, information_items_missing(Profile, Missing), Answers),
    Answers == [needs_legal_review(open_textured(automated_decision_making_under_article_22, cite(eu_reg_2016_679_art_13_2_f)), [inputs_relied_on([automated_decision_making_under_article_22 - unsure])])].
test(the_further_verdict_and_cites_are_read_out_once) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_further_in_time, Profile),
    findall(Verdict - Cites, further_processing_information_verdict(Profile, Verdict, Cites), Answers),
    Answers == [eligible - [cite(eu_reg_2016_679_art_14_4)]].
test(the_relevance_unsure_case_is_referred) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_relevance_unsure, Profile),
    further_processing_information_verdict(Profile, needs_legal_review(open_textured(paragraph_2_information_relevant_to_further_processing, cite(eu_reg_2016_679_art_13_3)), [inputs_relied_on(_)]), []).
test(the_missing_start_date_is_named) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_without_start_date, Profile),
    findall(Verdict - Cites, further_processing_information_verdict(Profile, Verdict, Cites), Answers),
    Answers == [indeterminate([further_processing_start_date]) - []].
test(the_facade_verdict_term_wraps_the_status) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_same_day, Profile),
    decide_further_processing_information_verdict(Profile, further_processing_information_verdict_verdict(ineligible, [cite(eu_reg_2016_679_art_13_3)])).

cp_test_names([the_art13_profile_yields_exactly_one_status, the_art14_profile_yields_exactly_one_route, the_verdict_carries_a_citation, the_art13_owed_list_is_the_checklist_in_order, the_art14_owed_list_has_nine_items, the_missing_list_is_read_out_once, the_unsure_covered_case_has_no_missing_item, the_unsure_uncovered_case_is_referred_once, the_further_verdict_and_cites_are_read_out_once, the_relevance_unsure_case_is_referred, the_missing_start_date_is_named, the_facade_verdict_term_wraps_the_status]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
