% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art15_access_copy_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_gdpr_art15_access_copy, [gdpr_art15_access_copy_status/2, gdpr_art15_access_copy_status_values/1, access_answer_items/4, access_answer_items_missing/4, copy_scope/3, copy_fee/3, information_form/3]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_fixtures, [gdpr_art15_access_copy_profile_for/2]).

attested_by_caller(Value, attested(Value, attestation(host, recorded_at, attested_by_caller, none))).

items_profile(Recipients, Collected, Source, AutomatedValue, Transfer, SafeguardsValue, [attribute(personal_data_concerning_data_subject_processed, true), attribute(disclosure_to_recipients_made_or_envisaged, Recipients), attribute(some_personal_data_not_collected_from_data_subject, Collected), attribute(source_information_available, Source), attribute(automated_decision_making_referred_to_in_article_22, Automated), attribute(transfer_to_third_country_or_international_organisation, Transfer), attribute(transfer_subject_to_article_46_safeguards, Safeguards)]) :-
    attested_by_caller(AutomatedValue, Automated),
    attested_by_caller(SafeguardsValue, Safeguards).

owed_item(Item, Recipients, Collected, Source, AutomatedValue, Transfer, SafeguardsValue) :-
    items_profile(Recipients, Collected, Source, AutomatedValue, Transfer, SafeguardsValue, Profile),
    access_answer_items(Profile, Result, _, _),
    member(Item, Result).

test(the_status_table_has_every_near_miss_atom) :-
    gdpr_art15_access_copy_status_values(StatusValues),
    member(access_answer_complete, StatusValues),
    member(access_answer_incomplete, StatusValues),
    member(access_answer_awaiting_input, StatusValues),
    member(access_answer_referred_for_legal_review, StatusValues),
    member(access_answer_input_rejected, StatusValues).
test(confirmation_given_is_complete) :-
    gdpr_art15_access_copy_profile_for(no_personal_data_confirmation_given, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_complete).
test(confirmation_not_given_is_incomplete) :-
    gdpr_art15_access_copy_profile_for(no_personal_data_confirmation_not_given, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_incomplete).
test(items_provided_absent_awaits_input) :-
    gdpr_art15_access_copy_profile_for(items_provided_not_stated, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_awaiting_input).
test(article_46_statement_absent_is_referred) :-
    gdpr_art15_access_copy_profile_for(article_46_statement_absent, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_referred_for_legal_review).
test(article_46_statement_attested_false_is_incomplete) :-
    gdpr_art15_access_copy_profile_for(article_46_statement_attested_false, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_incomplete).
test(bare_outside_fact_is_rejected) :-
    gdpr_art15_access_copy_profile_for(outside_fact_given_bare, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_input_rejected).
test(attested_outside_fact_awaits_input) :-
    gdpr_art15_access_copy_profile_for(outside_fact_given_attested, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_awaiting_input).
test(no_processing_owes_the_confirmation_only) :-
    access_answer_items([attribute(personal_data_concerning_data_subject_processed, false)], [confirmation_of_processing], [], [cite(eu_reg_2016_679_art_15_1)]).
test(processing_owes_the_copy) :-
    owed_item(copy_of_personal_data, false, false, false, false, false, false).
test(a_disclosure_owes_the_recipients) :-
    owed_item(recipients_or_categories_of_recipients, true, false, false, false, false, false).
test(data_from_elsewhere_with_source_information_owes_the_source) :-
    owed_item(source_of_personal_data, false, true, true, false, false, false).
test(source_information_false_settles_the_collection_key) :-
    attested_by_caller(false, Attested),
    access_answer_items([attribute(personal_data_concerning_data_subject_processed, true), attribute(disclosure_to_recipients_made_or_envisaged, false), attribute(source_information_available, false), attribute(automated_decision_making_referred_to_in_article_22, Attested), attribute(transfer_to_third_country_or_international_organisation, false)], [confirmation_of_processing|_], _, _).
test(source_information_true_asks_for_the_collection_key) :-
    attested_by_caller(false, Attested),
    access_answer_items([attribute(personal_data_concerning_data_subject_processed, true), attribute(disclosure_to_recipients_made_or_envisaged, false), attribute(source_information_available, true), attribute(automated_decision_making_referred_to_in_article_22, Attested), attribute(transfer_to_third_country_or_international_organisation, false)], indeterminate([some_personal_data_not_collected_from_data_subject]), [], []).
test(attested_automated_decision_making_owes_its_information) :-
    owed_item(automated_decision_making_information, false, false, false, true, false, false).
test(a_transfer_on_article_46_safeguards_owes_their_information) :-
    owed_item(transfer_safeguards_information, false, false, false, false, true, true).
test(safeguards_attested_false_settles_the_transfer_key) :-
    attested_by_caller(false, Attested),
    access_answer_items([attribute(personal_data_concerning_data_subject_processed, true), attribute(disclosure_to_recipients_made_or_envisaged, false), attribute(source_information_available, false), attribute(automated_decision_making_referred_to_in_article_22, Attested), attribute(transfer_subject_to_article_46_safeguards, Attested)], Result, Basis, _),
    Result = [confirmation_of_processing|_],
    Basis == [outside_fact(automated_decision_making_referred_to_in_article_22, Attested), outside_fact(transfer_subject_to_article_46_safeguards, Attested)].
test(safeguards_absent_asks_for_the_transfer_key) :-
    attested_by_caller(false, Attested),
    access_answer_items([attribute(personal_data_concerning_data_subject_processed, true), attribute(disclosure_to_recipients_made_or_envisaged, false), attribute(source_information_available, false), attribute(automated_decision_making_referred_to_in_article_22, Attested)], indeterminate([transfer_to_third_country_or_international_organisation]), [], []).
test(recipients_given_makes_the_disclosure_key_irrelevant) :-
    attested_by_caller(false, Attested),
    given_profile([confirmation_of_processing, access_to_personal_data, purposes_of_processing, categories_of_personal_data, recipients_or_categories_of_recipients, storage_period_or_criteria, rights_to_rectification_erasure_restriction_and_objection, right_to_lodge_complaint, copy_of_personal_data], Profile),
    access_answer_items_missing(Profile, no_item_missing, [outside_fact(automated_decision_making_referred_to_in_article_22, Attested)], [cite(eu_reg_2016_679_art_15_1)]).
test(recipients_not_given_asks_for_the_disclosure_key) :-
    given_profile([confirmation_of_processing, access_to_personal_data, purposes_of_processing, categories_of_personal_data, storage_period_or_criteria, rights_to_rectification_erasure_restriction_and_objection, right_to_lodge_complaint, copy_of_personal_data], Profile),
    access_answer_items_missing(Profile, indeterminate([disclosure_to_recipients_made_or_envisaged]), [], []).
test(adverse_effect_limits_the_copy) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_true, Profile),
    copy_scope(Profile, copy_limited_by_rights_and_freedoms_of_others, _).
test(no_adverse_effect_gives_the_full_copy) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_false, Profile),
    copy_scope(Profile, full_copy, _).
test(an_unsure_judgement_goes_to_a_lawyer) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_unsure, Profile),
    copy_scope(Profile, needs_legal_review(open_textured(copy_would_adversely_affect_rights_and_freedoms_of_others, cite(eu_reg_2016_679_art_15_4)), _), []).
test(no_processing_leaves_nothing_to_copy_whatever_the_judgement) :-
    copy_scope([attribute(personal_data_concerning_data_subject_processed, false), attribute(copy_would_adversely_affect_rights_and_freedoms_of_others, unsure)], no_personal_data_to_copy, [cite(eu_reg_2016_679_art_15_3)]).
test(the_article_15_4_limit_never_removes_the_copy_item) :-
    items_profile(false, false, false, false, false, false, Base),
    access_answer_items([attribute(copy_would_adversely_affect_rights_and_freedoms_of_others, true)|Base], Result, _, _),
    member(copy_of_personal_data, Result).
test(a_further_copy_permits_a_fee) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_true, Profile),
    copy_fee(Profile, reasonable_fee_permitted, [cite(eu_reg_2016_679_art_15_3)]).
test(the_first_copy_bears_no_fee) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_false, Profile),
    copy_fee(Profile, no_fee_under_article_15_3, [cite(eu_reg_2016_679_art_15_3)]).
test(no_processing_leaves_no_copy_to_charge_for) :-
    copy_fee([attribute(personal_data_concerning_data_subject_processed, false), attribute(further_copy_requested, true)], no_personal_data_to_copy, [cite(eu_reg_2016_679_art_15_3)]).
test(an_electronic_request_gets_the_electronic_form) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_false, Profile),
    information_form(Profile, commonly_used_electronic_form, [cite(eu_reg_2016_679_art_15_3)]).
test(another_form_requested_displaces_the_electronic_form) :-
    gdpr_art15_access_copy_profile_for(full_answer_copy_not_given, Profile),
    information_form(Profile, other_form_requested, [cite(eu_reg_2016_679_art_15_3)]).
test(a_request_not_electronic_sets_no_form) :-
    information_form([attribute(request_made_by_electronic_means, false), attribute(other_form_requested_by_data_subject, false)], no_electronic_request, [cite(eu_reg_2016_679_art_15_3)]).

test(confirmation_not_given_is_not_complete, fail) :-
    gdpr_art15_access_copy_profile_for(no_personal_data_confirmation_not_given, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_complete).
test(items_provided_stated_does_not_await_input, fail) :-
    gdpr_art15_access_copy_profile_for(no_personal_data_confirmation_given, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_awaiting_input).
test(article_46_statement_attested_false_is_not_referred, fail) :-
    gdpr_art15_access_copy_profile_for(article_46_statement_attested_false, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_referred_for_legal_review).
test(attested_outside_fact_is_not_rejected, fail) :-
    gdpr_art15_access_copy_profile_for(outside_fact_given_attested, Profile),
    gdpr_art15_access_copy_status(Profile, access_answer_input_rejected).
test(processing_owes_more_than_the_confirmation, fail) :-
    items_profile(false, false, false, false, false, false, Profile),
    access_answer_items(Profile, [confirmation_of_processing], _, _).
test(no_disclosure_owes_no_recipients, fail) :-
    owed_item(recipients_or_categories_of_recipients, false, false, false, false, false, false).
test(no_source_information_owes_no_source, fail) :-
    owed_item(source_of_personal_data, false, true, false, false, false, false).
test(data_all_from_the_data_subject_owes_no_source, fail) :-
    owed_item(source_of_personal_data, false, false, true, false, false, false).
test(attested_no_automated_decision_making_owes_nothing, fail) :-
    owed_item(automated_decision_making_information, false, false, false, false, false, false).
test(a_transfer_without_article_46_safeguards_owes_nothing, fail) :-
    owed_item(transfer_safeguards_information, false, false, false, false, true, false).
test(no_transfer_owes_no_safeguards_information, fail) :-
    owed_item(transfer_safeguards_information, false, false, false, false, false, true).
test(recipients_not_given_is_not_settled_complete, fail) :-
    given_profile([confirmation_of_processing, access_to_personal_data, purposes_of_processing, categories_of_personal_data, storage_period_or_criteria, rights_to_rectification_erasure_restriction_and_objection, right_to_lodge_complaint, copy_of_personal_data], Profile),
    access_answer_items_missing(Profile, no_item_missing, _, _).
test(no_adverse_effect_does_not_limit_the_copy, fail) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_false, Profile),
    copy_scope(Profile, copy_limited_by_rights_and_freedoms_of_others, _).
test(a_settled_judgement_does_not_go_to_a_lawyer, fail) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_true, Profile),
    copy_scope(Profile, needs_legal_review(_, _), _).
test(the_first_copy_permits_no_fee, fail) :-
    gdpr_art15_access_copy_profile_for(copy_judgement_false, Profile),
    copy_fee(Profile, reasonable_fee_permitted, _).
test(another_form_requested_is_not_the_electronic_form, fail) :-
    gdpr_art15_access_copy_profile_for(full_answer_copy_not_given, Profile),
    information_form(Profile, commonly_used_electronic_form, _).
test(a_request_not_electronic_is_not_the_electronic_form, fail) :-
    information_form([attribute(request_made_by_electronic_means, false), attribute(other_form_requested_by_data_subject, false)], commonly_used_electronic_form, _).

given_profile(Provided, [attribute(items_provided, Provided), attribute(personal_data_concerning_data_subject_processed, true), attribute(some_personal_data_not_collected_from_data_subject, false), attribute(source_information_available, false), attribute(automated_decision_making_referred_to_in_article_22, Attested), attribute(transfer_to_third_country_or_international_organisation, false)]) :-
    attested_by_caller(false, Attested).

cp_test_names([the_status_table_has_every_near_miss_atom, confirmation_given_is_complete, confirmation_not_given_is_incomplete, items_provided_absent_awaits_input, article_46_statement_absent_is_referred, article_46_statement_attested_false_is_incomplete, bare_outside_fact_is_rejected, attested_outside_fact_awaits_input, no_processing_owes_the_confirmation_only, processing_owes_the_copy, a_disclosure_owes_the_recipients, data_from_elsewhere_with_source_information_owes_the_source, source_information_false_settles_the_collection_key, source_information_true_asks_for_the_collection_key, attested_automated_decision_making_owes_its_information, a_transfer_on_article_46_safeguards_owes_their_information, safeguards_attested_false_settles_the_transfer_key, safeguards_absent_asks_for_the_transfer_key, recipients_given_makes_the_disclosure_key_irrelevant, recipients_not_given_asks_for_the_disclosure_key, adverse_effect_limits_the_copy, no_adverse_effect_gives_the_full_copy, an_unsure_judgement_goes_to_a_lawyer, no_processing_leaves_nothing_to_copy_whatever_the_judgement, the_article_15_4_limit_never_removes_the_copy_item, a_further_copy_permits_a_fee, the_first_copy_bears_no_fee, no_processing_leaves_no_copy_to_charge_for, an_electronic_request_gets_the_electronic_form, another_form_requested_displaces_the_electronic_form, a_request_not_electronic_sets_no_form]).
cp_test_fail_names([confirmation_not_given_is_not_complete, items_provided_stated_does_not_await_input, article_46_statement_attested_false_is_not_referred, attested_outside_fact_is_not_rejected, processing_owes_more_than_the_confirmation, no_disclosure_owes_no_recipients, no_source_information_owes_no_source, data_all_from_the_data_subject_owes_no_source, attested_no_automated_decision_making_owes_nothing, a_transfer_without_article_46_safeguards_owes_nothing, no_transfer_owes_no_safeguards_information, recipients_not_given_is_not_settled_complete, no_adverse_effect_does_not_limit_the_copy, a_settled_judgement_does_not_go_to_a_lawyer, the_first_copy_permits_no_fee, another_form_requested_is_not_the_electronic_form, a_request_not_electronic_is_not_the_electronic_form]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
