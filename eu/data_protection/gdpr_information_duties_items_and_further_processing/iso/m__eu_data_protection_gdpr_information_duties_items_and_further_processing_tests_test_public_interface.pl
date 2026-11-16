% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_information_route, [decide_information_route/2, information_route_status/2, information_route_checklist/2, information_route_decision_resolvable/1, information_route_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_further_processing_information_verdict, [decide_further_processing_information_verdict/2, further_processing_information_verdict_status/2, further_processing_information_verdict_checklist/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_fixtures, [gdpr_information_duties_items_and_further_processing_subject/1, gdpr_information_duties_items_and_further_processing_profile_for/2, gdpr_information_duties_items_and_further_processing_assess/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_information_route, [information_route/2, information_items_owed/2, information_items_missing/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_further_processing_information_verdict, [further_processing_information_verdict/3]).
:- use_module(m__eu_data_protection_gdpr_information_duties_items_and_further_processing_queries, [gdpr_information_duties_items_and_further_processing_deadline/2]).

test(the_collected_flag_is_the_art13_route) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    information_route_status(Profile, art13).
test(the_not_collected_flag_is_the_art14_route) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_complete, Profile),
    information_route_status(Profile, art14).
test(the_route_status_values_are_the_pinned_atoms) :-
    information_route_status_values([art13, art14]).
test(the_assess_wrapper_gives_the_route_verdict) :-
    gdpr_information_duties_items_and_further_processing_assess(art13_complete, information_route_verdict(art13, [cite(eu_reg_2016_679_art_13_1)])).
test(the_route_decision_is_resolvable_and_has_a_checklist) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    information_route_decision_resolvable(Profile),
    information_route_checklist(Profile, [item(route, met, _Citation)|_OtherItems]),
    decide_information_route(Profile, information_route_verdict(art13, _Citations)).
test(an_empty_profile_names_the_missing_route_key) :-
    information_route([], indeterminate([personal_data_collected_from_data_subject])).
test(an_unknown_key_is_an_input_problem) :-
    information_route([attribute(bogus_key, true)], input_problems([unknown_key(bogus_key)])).
test(the_art13_checklist_in_item_order) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    information_items_owed(Profile, Owed),
    Owed == [owed_item(controller_identity_and_contact_details, cite(eu_reg_2016_679_art_13_1_a)), owed_item(data_protection_officer_contact_details, cite(eu_reg_2016_679_art_13_1_b)), owed_item(purposes_and_legal_basis, cite(eu_reg_2016_679_art_13_1_c)), owed_item(recipients_or_categories_of_recipients, cite(eu_reg_2016_679_art_13_1_e)), owed_item(storage_period_or_criteria, cite(eu_reg_2016_679_art_13_2_a)), owed_item(data_subject_rights, cite(eu_reg_2016_679_art_13_2_b)), owed_item(right_to_lodge_complaint, cite(eu_reg_2016_679_art_13_2_d)), owed_item(statutory_or_contractual_requirement, cite(eu_reg_2016_679_art_13_2_e))].
test(the_art14_checklist_adds_categories_and_source) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_complete, Profile),
    information_items_owed(Profile, Owed),
    Owed == [owed_item(controller_identity_and_contact_details, cite(eu_reg_2016_679_art_14_1_a)), owed_item(data_protection_officer_contact_details, cite(eu_reg_2016_679_art_14_1_b)), owed_item(purposes_and_legal_basis, cite(eu_reg_2016_679_art_14_1_c)), owed_item(recipients_or_categories_of_recipients, cite(eu_reg_2016_679_art_14_1_e)), owed_item(categories_of_personal_data, cite(eu_reg_2016_679_art_14_1_d)), owed_item(storage_period_or_criteria, cite(eu_reg_2016_679_art_14_2_a)), owed_item(data_subject_rights, cite(eu_reg_2016_679_art_14_2_c)), owed_item(right_to_lodge_complaint, cite(eu_reg_2016_679_art_14_2_e)), owed_item(source_of_personal_data, cite(eu_reg_2016_679_art_14_2_f))].
test(an_unsure_automated_decision_judgement_is_open_textured) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_automated_unsure, Profile),
    information_items_owed(Profile, needs_legal_review(open_textured(automated_decision_making_under_article_22, cite(eu_reg_2016_679_art_13_2_f)), [inputs_relied_on([automated_decision_making_under_article_22 - unsure])])).
test(nothing_is_missing_when_everything_owed_is_provided) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_complete, Profile),
    findall(Answer, information_items_missing(Profile, Answer), Answers),
    Answers == [[no_item_missing]].
test(a_dropped_item_is_missing) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_missing_requirement, Profile),
    information_items_missing(Profile, [missing_item(statutory_or_contractual_requirement, cite(eu_reg_2016_679_art_13_2_e))]).
test(an_item_already_held_is_not_missing) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_categories_already_known, Profile),
    information_items_missing(Profile, [no_item_missing]).
test(the_same_item_not_held_is_missing) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_categories_missing, Profile),
    information_items_missing(Profile, [missing_item(categories_of_personal_data, cite(eu_reg_2016_679_art_14_1_d))]).
test(an_unsure_automated_decision_judgement_with_the_item_uncovered_is_open) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_automated_unsure, Profile),
    information_items_missing(Profile, needs_legal_review(open_textured(automated_decision_making_under_article_22, cite(eu_reg_2016_679_art_13_2_f)), [inputs_relied_on([automated_decision_making_under_article_22 - unsure])])).
test(an_unsure_automated_decision_judgement_with_the_item_covered_is_settled) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_automated_unsure_covered, Profile),
    information_items_missing(Profile, [no_item_missing]).
test(information_before_the_start_is_eligible) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_in_time, Profile),
    further_processing_information_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_13_3)]).
test(the_same_day_is_ineligible) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_same_day, Profile),
    further_processing_information_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_13_3)]).
test(a_missing_paragraph_2_item_is_ineligible) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_item_missing, Profile),
    further_processing_information_verdict(Profile, ineligible, [cite(eu_reg_2016_679_art_13_3)]).
test(no_further_processing_is_not_applicable) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_not_intended, Profile),
    further_processing_information_verdict(Profile, not_applicable, []).
test(an_unsure_relevance_judgement_is_open_textured) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_relevance_unsure, Profile),
    further_processing_information_verdict(Profile, needs_legal_review(open_textured(paragraph_2_information_relevant_to_further_processing, cite(eu_reg_2016_679_art_13_3)), _Context), []).
test(the_art14_route_cites_art14_4) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_further_in_time, Profile),
    further_processing_information_verdict(Profile, eligible, [cite(eu_reg_2016_679_art_14_4)]).
test(an_absent_start_date_is_named) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_without_start_date, Profile),
    further_processing_information_verdict(Profile, indeterminate([further_processing_start_date]), []).
test(the_further_processing_facade_agrees) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_in_time, Profile),
    decide_further_processing_information_verdict(Profile, further_processing_information_verdict_verdict(eligible, [cite(eu_reg_2016_679_art_13_3)])),
    further_processing_information_verdict_status(Profile, eligible),
    further_processing_information_verdict_checklist(Profile, [item(information_before_further_processing, met, _Citation)|_OtherItems]).
test(the_deadline_is_stated_with_its_consequence) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_in_time, Profile),
    gdpr_information_duties_items_and_further_processing_deadline(Profile, deadline(_LastDate, cite(eu_reg_2016_679_art_13_3), consequence(ineligible))).
test(no_deadline_without_further_processing) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_not_intended, Profile),
    gdpr_information_duties_items_and_further_processing_deadline(Profile, not_applicable).

test(the_art14_subject_is_not_art13, fail) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art14_complete, Profile),
    information_route_status(Profile, art13).
test(the_same_day_is_not_eligible, fail) :-
    gdpr_information_duties_items_and_further_processing_profile_for(art13_further_same_day, Profile),
    further_processing_information_verdict(Profile, eligible, _Cites).

cp_test_names([the_collected_flag_is_the_art13_route, the_not_collected_flag_is_the_art14_route, the_route_status_values_are_the_pinned_atoms, the_assess_wrapper_gives_the_route_verdict, the_route_decision_is_resolvable_and_has_a_checklist, an_empty_profile_names_the_missing_route_key, an_unknown_key_is_an_input_problem, the_art13_checklist_in_item_order, the_art14_checklist_adds_categories_and_source, an_unsure_automated_decision_judgement_is_open_textured, nothing_is_missing_when_everything_owed_is_provided, a_dropped_item_is_missing, an_item_already_held_is_not_missing, the_same_item_not_held_is_missing, an_unsure_automated_decision_judgement_with_the_item_uncovered_is_open, an_unsure_automated_decision_judgement_with_the_item_covered_is_settled, information_before_the_start_is_eligible, the_same_day_is_ineligible, a_missing_paragraph_2_item_is_ineligible, no_further_processing_is_not_applicable, an_unsure_relevance_judgement_is_open_textured, the_art14_route_cites_art14_4, an_absent_start_date_is_named, the_further_processing_facade_agrees, the_deadline_is_stated_with_its_consequence, no_deadline_without_further_processing]).
cp_test_fail_names([the_art14_subject_is_not_art13, the_same_day_is_not_eligible]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
