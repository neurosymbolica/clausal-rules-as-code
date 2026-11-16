% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_art15_access_copy_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_gdpr_art15_access_copy, [decide_gdpr_art15_access_copy/2, gdpr_art15_access_copy_status/2, gdpr_art15_access_copy_checklist/2, access_answer_items/4, access_answer_items_missing/4, copy_scope/3, copy_fee/3, information_form/3]).
:- use_module(m__eu_data_protection_gdpr_art15_access_copy_fixtures, [gdpr_art15_access_copy_profile_for/2]).

attested_by_caller(Value, attested(Value, attestation(host, recorded_at, attested_by_caller, none))).

all_items([confirmation_of_processing, access_to_personal_data, purposes_of_processing, categories_of_personal_data, recipients_or_categories_of_recipients, storage_period_or_criteria, rights_to_rectification_erasure_restriction_and_objection, right_to_lodge_complaint, source_of_personal_data, automated_decision_making_information, transfer_safeguards_information, copy_of_personal_data]).

unconditional_items([confirmation_of_processing, access_to_personal_data, purposes_of_processing, categories_of_personal_data, storage_period_or_criteria, rights_to_rectification_erasure_restriction_and_objection, right_to_lodge_complaint, copy_of_personal_data]).

test(full_answer_owes_all_twelve_items) :-
    gdpr_art15_access_copy_profile_for(full_answer_all_items_given, Profile),
    attested_by_caller(true, Attested),
    all_items(Items),
    findall(answer(Result, Basis, Citations), access_answer_items(Profile, Result, Basis, Citations), Answers),
    Answers = [answer(Result, Basis, Citations)],
    Result == Items,
    Basis == [outside_fact(automated_decision_making_referred_to_in_article_22, Attested), outside_fact(transfer_subject_to_article_46_safeguards, Attested)],
    sort(Citations, Sorted),
    Sorted == [cite(eu_reg_2016_679_art_15_1), cite(eu_reg_2016_679_art_15_1_a), cite(eu_reg_2016_679_art_15_1_b), cite(eu_reg_2016_679_art_15_1_c), cite(eu_reg_2016_679_art_15_1_d), cite(eu_reg_2016_679_art_15_1_e), cite(eu_reg_2016_679_art_15_1_f), cite(eu_reg_2016_679_art_15_1_g), cite(eu_reg_2016_679_art_15_1_h), cite(eu_reg_2016_679_art_15_2), cite(eu_reg_2016_679_art_15_3)].
test(minimal_processing_owes_the_unconditional_items) :-
    gdpr_art15_access_copy_profile_for(minimal_processing_all_owed_items_given, Profile),
    attested_by_caller(false, Attested),
    unconditional_items(Items),
    findall(answer(Result, Basis, Citations), access_answer_items(Profile, Result, Basis, Citations), Answers),
    Answers = [answer(Result, Basis, Citations)],
    Result == Items,
    Basis == [outside_fact(automated_decision_making_referred_to_in_article_22, Attested)],
    sort(Citations, Sorted),
    Sorted == [cite(eu_reg_2016_679_art_15_1), cite(eu_reg_2016_679_art_15_1_a), cite(eu_reg_2016_679_art_15_1_b), cite(eu_reg_2016_679_art_15_1_d), cite(eu_reg_2016_679_art_15_1_e), cite(eu_reg_2016_679_art_15_1_f), cite(eu_reg_2016_679_art_15_3)].
test(article_46_attested_false_shows_both_statements) :-
    gdpr_art15_access_copy_profile_for(article_46_statement_attested_false, Profile),
    attested_by_caller(false, Attested),
    unconditional_items(Items),
    findall(answer(Result, Basis), access_answer_items(Profile, Result, Basis, _), Answers),
    Answers == [answer(Items, [outside_fact(automated_decision_making_referred_to_in_article_22, Attested), outside_fact(transfer_subject_to_article_46_safeguards, Attested)])].
test(items_refer_the_absent_article_22_statement) :-
    gdpr_art15_access_copy_profile_for(article_22_statement_absent, Profile),
    findall(answer(Result, Basis, Citations), access_answer_items(Profile, Result, Basis, Citations), Answers),
    Answers == [answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_15_1_h), cite(article_22_automated_decision_making_statement)), [resolution(cite(article_22_automated_decision_making_statement), not_attempted), inputs_relied_on([automated_decision_making_referred_to_in_article_22 - absent])]), [], [])].
test(items_refer_the_absent_article_46_statement) :-
    gdpr_art15_access_copy_profile_for(article_46_statement_absent, Profile),
    findall(answer(Result, Basis, Citations), access_answer_items(Profile, Result, Basis, Citations), Answers),
    Answers == [answer(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_15_2), cite(article_46_safeguards_statement)), [resolution(cite(article_46_safeguards_statement), not_attempted), inputs_relied_on([transfer_subject_to_article_46_safeguards - absent])]), [], [])].
test(missing_settled_with_the_statements_for_items_not_given) :-
    gdpr_art15_access_copy_profile_for(article_46_statement_attested_false, Profile),
    attested_by_caller(false, Attested),
    unconditional_items(Items),
    findall(answer(Result, Basis), access_answer_items_missing(Profile, Result, Basis, _), Answers),
    Answers == [answer(Items, [outside_fact(automated_decision_making_referred_to_in_article_22, Attested), outside_fact(transfer_subject_to_article_46_safeguards, Attested)])].
test(missing_nothing_when_all_owed_items_given) :-
    gdpr_art15_access_copy_profile_for(minimal_processing_all_owed_items_given, Profile),
    attested_by_caller(false, Attested),
    findall(answer(Result, Basis, Citations), access_answer_items_missing(Profile, Result, Basis, Citations), Answers),
    Answers == [answer(no_item_missing, [outside_fact(automated_decision_making_referred_to_in_article_22, Attested)], [cite(eu_reg_2016_679_art_15_1)])].
test(missing_recipients_cites_point_c) :-
    gdpr_art15_access_copy_profile_for(minimal_processing_recipients_not_named, Profile),
    findall(answer(Result, Citations), access_answer_items_missing(Profile, Result, _, Citations), Answers),
    Answers == [answer([recipients_or_categories_of_recipients], [cite(eu_reg_2016_679_art_15_1_c)])].
test(missing_refers_the_absent_article_46_statement) :-
    gdpr_art15_access_copy_profile_for(article_46_statement_absent, Profile),
    findall(Result, access_answer_items_missing(Profile, Result, _, _), Results),
    Results = [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_15_2), cite(article_46_safeguards_statement)), _)].
test(copy_scope_outputs_over_the_fixtures) :-
    findall(Subject - Result, (member(Subject, [copy_judgement_unsure, copy_judgement_true, copy_judgement_false, minimal_processing_all_owed_items_given, no_personal_data_confirmation_given]), gdpr_art15_access_copy_profile_for(Subject, Profile), copy_scope(Profile, Result, _)), Pairs),
    Pairs == [copy_judgement_unsure - needs_legal_review(open_textured(copy_would_adversely_affect_rights_and_freedoms_of_others, cite(eu_reg_2016_679_art_15_4)), [inputs_relied_on([copy_would_adversely_affect_rights_and_freedoms_of_others - unsure])]), copy_judgement_true - copy_limited_by_rights_and_freedoms_of_others, copy_judgement_false - full_copy, minimal_processing_all_owed_items_given - indeterminate([copy_would_adversely_affect_rights_and_freedoms_of_others]), no_personal_data_confirmation_given - no_personal_data_to_copy].
test(copy_fee_outputs_over_the_fixtures) :-
    findall(Subject - Result, (member(Subject, [copy_judgement_true, copy_judgement_false, minimal_processing_all_owed_items_given, no_personal_data_confirmation_given, processing_not_stated]), gdpr_art15_access_copy_profile_for(Subject, Profile), copy_fee(Profile, Result, _)), Pairs),
    Pairs == [copy_judgement_true - reasonable_fee_permitted, copy_judgement_false - no_fee_under_article_15_3, minimal_processing_all_owed_items_given - indeterminate([further_copy_requested]), no_personal_data_confirmation_given - no_personal_data_to_copy, processing_not_stated - indeterminate([personal_data_concerning_data_subject_processed])].
test(information_form_outputs_over_the_fixtures) :-
    findall(Subject - Result, (member(Subject, [copy_judgement_false, full_answer_copy_not_given, minimal_processing_all_owed_items_given, copy_judgement_unsure, copy_judgement_true]), gdpr_art15_access_copy_profile_for(Subject, Profile), information_form(Profile, Result, _)), Pairs),
    Pairs == [copy_judgement_false - commonly_used_electronic_form, full_answer_copy_not_given - other_form_requested, minimal_processing_all_owed_items_given - no_electronic_request, copy_judgement_unsure - indeterminate([other_form_requested_by_data_subject]), copy_judgement_true - indeterminate([request_made_by_electronic_means])].
test(the_incomplete_verdict_carries_its_citation) :-
    gdpr_art15_access_copy_profile_for(full_answer_copy_not_given, Profile),
    findall(Verdict, decide_gdpr_art15_access_copy(Profile, Verdict), Verdicts),
    Verdicts == [gdpr_art15_access_copy_verdict(access_answer_incomplete, [cite(eu_reg_2016_679_art_15_3)])].
test(the_status_outputs_over_the_fixtures) :-
    findall(Subject - Status, (member(Subject, [no_personal_data_confirmation_given, no_personal_data_confirmation_not_given, items_provided_not_stated, article_46_statement_absent, outside_fact_given_bare]), gdpr_art15_access_copy_profile_for(Subject, Profile), gdpr_art15_access_copy_status(Profile, Status)), Pairs),
    Pairs == [no_personal_data_confirmation_given - access_answer_complete, no_personal_data_confirmation_not_given - access_answer_incomplete, items_provided_not_stated - access_answer_awaiting_input, article_46_statement_absent - access_answer_referred_for_legal_review, outside_fact_given_bare - access_answer_input_rejected].
test(the_checklist_has_one_row_per_item) :-
    gdpr_art15_access_copy_profile_for(full_answer_copy_not_given, Profile),
    gdpr_art15_access_copy_checklist(Profile, Items),
    length(Items, 12),
    member(item(copy_of_personal_data, unmet(owed_and_not_provided), cite(eu_reg_2016_679_art_15_3)), Items),
    member(item(confirmation_of_processing, met, cite(eu_reg_2016_679_art_15_1)), Items).

cp_test_names([full_answer_owes_all_twelve_items, minimal_processing_owes_the_unconditional_items, article_46_attested_false_shows_both_statements, items_refer_the_absent_article_22_statement, items_refer_the_absent_article_46_statement, missing_settled_with_the_statements_for_items_not_given, missing_nothing_when_all_owed_items_given, missing_recipients_cites_point_c, missing_refers_the_absent_article_46_statement, copy_scope_outputs_over_the_fixtures, copy_fee_outputs_over_the_fixtures, information_form_outputs_over_the_fixtures, the_incomplete_verdict_carries_its_citation, the_status_outputs_over_the_fixtures, the_checklist_has_one_row_per_item]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
