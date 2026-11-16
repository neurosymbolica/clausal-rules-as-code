% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_data_subject_rights_response_period_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_gdpr_data_subject_rights_response_period, [decide_gdpr_data_subject_rights_response_period/2, gdpr_data_subject_rights_response_period_status/2, gdpr_data_subject_rights_response_period_checklist/2, gdpr_data_subject_rights_response_period_decision_resolvable/1, gdpr_data_subject_rights_response_period_status_values/1, applicable_response_period/2, response_deadline/3, request_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_fixtures, [gdpr_data_subject_rights_response_period_subject/1, gdpr_data_subject_rights_response_period_profile_for/2, gdpr_data_subject_rights_response_period_assess/2]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_queries, [gdpr_data_subject_rights_response_period_what_if/4]).
:- use_module(m__eu_data_protection_gdpr_data_subject_rights_response_period_kernel, [gdpr_data_subject_rights_response_period_input_problems/2]).

expected_status(no_extension_claimed, first_period).
expected_status(claim_withdrawn_but_necessary, first_period).
expected_status(necessity_without_claim, first_period).
expected_status(claimed_and_necessary, extended_period).
expected_status(claimed_not_necessary, first_period).
expected_status(claimed_without_judgement, indeterminate).
expected_status(claimed_and_unsure, needs_legal_review).
expected_status(unread_keys_present, extended_period).
expected_status(unknown_key_given, input_problems).
expected_status(duplicate_claim_given, input_problems).
expected_status(claim_given_unsure, input_problems).
expected_status(profile_not_a_list, input_problems).

subject_statuses(Subject, Statuses) :-
    findall(Status, gdpr_data_subject_rights_response_period_assess(Subject, gdpr_data_subject_rights_response_period_verdict(Status, _Citations)), Statuses).

test(every_subject_resolves_to_its_expected_status_once) :-
    findall(Subject - Statuses, (gdpr_data_subject_rights_response_period_subject(Subject), subject_statuses(Subject, Statuses)), Pairs),
    findall(Subject - [Status], (gdpr_data_subject_rights_response_period_subject(Subject), expected_status(Subject, Status)), Expected),
    Pairs == Expected.
test(every_status_is_in_the_vocabulary) :-
    gdpr_data_subject_rights_response_period_status_values(StatusValues),
    findall(Status, expected_status(_, Status), Statuses),
    sort(Statuses, Distinct),
    sort(StatusValues, Vocabulary),
    Distinct == Vocabulary.
test(no_extension_claimed_is_first_period) :-
    subject_statuses(no_extension_claimed, [first_period]).
test(claimed_and_necessary_is_extended_period) :-
    subject_statuses(claimed_and_necessary, [extended_period]).
test(claimed_and_necessary_cites_article_12_3) :-
    gdpr_data_subject_rights_response_period_assess(claimed_and_necessary, gdpr_data_subject_rights_response_period_verdict(extended_period, [cite(eu_reg_2016_679_art_12_3)])).
test(claimed_not_necessary_is_first_period) :-
    subject_statuses(claimed_not_necessary, [first_period]).
test(claimed_without_judgement_is_indeterminate) :-
    subject_statuses(claimed_without_judgement, [indeterminate]).
test(claimed_and_unsure_is_needs_legal_review) :-
    subject_statuses(claimed_and_unsure, [needs_legal_review]).
test(unknown_key_given_is_input_problems) :-
    subject_statuses(unknown_key_given, [input_problems]).
test(applicable_period_needs_legal_review_term) :-
    gdpr_data_subject_rights_response_period_profile_for(claimed_and_unsure, Profile),
    findall(Period, applicable_response_period(Profile, Period), Periods),
    Periods == [needs_legal_review(open_textured(extension_necessary_for_complexity_and_number, cite(eu_reg_2016_679_art_12_3)), [inputs_relied_on([extension_necessary_for_complexity_and_number - unsure])])].
test(applicable_period_indeterminate_names_the_key) :-
    gdpr_data_subject_rights_response_period_profile_for(claimed_without_judgement, Profile),
    findall(Period, applicable_response_period(Profile, Period), Periods),
    Periods == [indeterminate([extension_necessary_for_complexity_and_number])].
test(applicable_period_duplicate_key) :-
    gdpr_data_subject_rights_response_period_profile_for(duplicate_claim_given, Profile),
    findall(Period, applicable_response_period(Profile, Period), Periods),
    Periods == [input_problems([duplicate_key(extension_claimed)])].
test(applicable_period_wrong_type_claim) :-
    gdpr_data_subject_rights_response_period_profile_for(claim_given_unsure, Profile),
    applicable_response_period(Profile, input_problems([wrong_type(extension_claimed)])).
test(applicable_period_not_a_list) :-
    applicable_response_period(not_an_attribute_list, input_problems([wrong_type(profile)])).
test(referral_context_carries_inputs_relied_on) :-
    gdpr_data_subject_rights_response_period_profile_for(claimed_and_unsure, Profile),
    applicable_response_period(Profile, needs_legal_review(_Reason, Context)),
    member(inputs_relied_on([extension_necessary_for_complexity_and_number - unsure]), Context).
test(input_check_clean_profile) :-
    gdpr_data_subject_rights_response_period_profile_for(unread_keys_present, Profile),
    gdpr_data_subject_rights_response_period_input_problems(Profile, []).
test(input_check_orders_contract_keys_then_unknown_keys) :-
    findall(Problems, gdpr_data_subject_rights_response_period_input_problems([attribute(foo, 1), attribute(extension_claimed, unsure), attribute(request_type, deletion), attribute(foo, 2)], Problems), Answers),
    Answers == [[wrong_type(request_type), wrong_type(extension_claimed), unknown_key(foo)]].
test(input_check_impossible_date) :-
    gdpr_data_subject_rights_response_period_input_problems([attribute(request_received_on, date(2026, 2, 29))], [wrong_type(request_received_on)]).
test(input_check_bare_outside_fact) :-
    gdpr_data_subject_rights_response_period_input_problems([attribute(legislative_restriction_applies_to_the_right, true)], [wrong_type(legislative_restriction_applies_to_the_right)]).
test(input_check_accepts_document_evidence) :-
    gdpr_data_subject_rights_response_period_input_problems([attribute(processing_required_by_union_or_member_state_law, attested(true, attestation(by, at, reason, document(upload_one, sha256_digest))))], []).
test(input_check_accepts_url_evidence) :-
    gdpr_data_subject_rights_response_period_input_problems([attribute(processing_required_by_union_or_member_state_law, attested(false, attestation(by, at, reason, url(address, retrieved_at))))], []).
test(deadline_friday_is_not_shifted) :-
    findall(Deadline, response_deadline(date(2026, 10, 27), first_period, Deadline), Deadlines),
    Deadlines == [date(2026, 11, 27)].
test(deadline_saturday_moves_to_monday) :-
    findall(Deadline, response_deadline(date(2026, 10, 28), first_period, Deadline), Deadlines),
    Deadlines == [date(2026, 11, 30)].
test(deadline_sunday_moves_to_monday) :-
    findall(Deadline, response_deadline(date(2026, 10, 29), first_period, Deadline), Deadlines),
    Deadlines == [date(2026, 11, 30)].
test(deadline_wednesday_is_not_shifted) :-
    response_deadline(date(2026, 3, 15), first_period, date(2026, 4, 15)).
test(deadline_clipped_to_leap_day) :-
    response_deadline(date(2028, 1, 31), first_period, date(2028, 2, 29)).
test(deadline_clipped_common_year_sunday_moves_to_monday) :-
    response_deadline(date(2027, 1, 31), first_period, date(2027, 3, 1)).
test(deadline_clipped_saturday_moves_to_monday) :-
    response_deadline(date(2026, 1, 31), first_period, date(2026, 3, 2)).
test(deadline_year_carry) :-
    response_deadline(date(2026, 12, 31), first_period, date(2027, 2, 1)).
test(deadline_extended_from_receipt) :-
    findall(Deadline, response_deadline(date(2026, 1, 31), extended_period, Deadline), Deadlines),
    Deadlines == [date(2026, 4, 30)].
test(deadline_extended_sunday_moves_to_monday) :-
    response_deadline(date(2026, 11, 30), extended_period, date(2027, 3, 1)).
test(deadline_impossible_receipt) :-
    findall(Deadline, response_deadline(date(2026, 2, 30), first_period, Deadline), Deadlines),
    Deadlines == [input_problems([wrong_type(receipt_date)])].
test(deadline_list_receipt_is_wrong_type) :-
    response_deadline([2026, 1, 1], first_period, input_problems([wrong_type(receipt_date)])).
test(deadline_unknown_period) :-
    response_deadline(date(2026, 1, 1), two_months, input_problems([wrong_type(response_period)])).
test(deadline_both_arguments_wrong) :-
    findall(Deadline, response_deadline(foo, bar, Deadline), Deadlines),
    Deadlines == [input_problems([wrong_type(receipt_date), wrong_type(response_period)])].
test(outside_facts_record_the_attested_holidays) :-
    gdpr_data_subject_rights_response_period_profile_for(unread_keys_present, Profile),
    findall(OutsideFacts, request_outside_facts(Profile, OutsideFacts), Answers),
    Answers == [[outside_fact(erasure_required_by_union_or_member_state_law, absent), outside_fact(processing_required_by_union_or_member_state_law, absent), outside_fact(decision_authorised_by_union_or_member_state_law, absent), outside_fact(legislative_restriction_applies_to_the_right, absent), outside_fact(public_holidays, attested([date(2026, 11, 30)], attestation(by, at, reason, none)))]].
test(outside_facts_copy_document_evidence_as_given) :-
    findall(OutsideFacts, request_outside_facts([attribute(processing_required_by_union_or_member_state_law, attested(true, attestation(by, at, reason, document(upload_one, sha256_digest))))], OutsideFacts), Answers),
    Answers == [[outside_fact(erasure_required_by_union_or_member_state_law, absent), outside_fact(processing_required_by_union_or_member_state_law, attested(true, attestation(by, at, reason, document(upload_one, sha256_digest)))), outside_fact(decision_authorised_by_union_or_member_state_law, absent), outside_fact(legislative_restriction_applies_to_the_right, absent), outside_fact(public_holidays, absent)]].
test(outside_facts_copy_url_evidence_as_given) :-
    request_outside_facts([attribute(processing_required_by_union_or_member_state_law, attested(false, attestation(by, at, reason, url(address, retrieved_at))))], OutsideFacts),
    member(outside_fact(processing_required_by_union_or_member_state_law, attested(false, attestation(by, at, reason, url(address, retrieved_at)))), OutsideFacts).
test(outside_facts_on_a_bad_profile) :-
    request_outside_facts(not_an_attribute_list, input_problems([wrong_type(profile)])).
test(attested_holiday_does_not_shift_the_deadline) :-
    response_deadline(date(2026, 10, 29), first_period, date(2026, 11, 30)).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, gdpr_data_subject_rights_response_period_subject(Subject), Subjects),
    findall(Subject, (gdpr_data_subject_rights_response_period_subject(Subject), gdpr_data_subject_rights_response_period_profile_for(Subject, Profile), gdpr_data_subject_rights_response_period_checklist(Profile, [_FirstItem|_OtherItems])), WithChecklist),
    WithChecklist == Subjects.
test(claimed_and_necessary_checklist_is_all_met) :-
    gdpr_data_subject_rights_response_period_profile_for(claimed_and_necessary, Profile),
    gdpr_data_subject_rights_response_period_checklist(Profile, [item(extension_claimed, met, cite(eu_reg_2016_679_art_12_3)), item(extension_necessary_for_complexity_and_number, met, cite(eu_reg_2016_679_art_12_3))]).
test(no_claim_checklist_marks_necessity_inapplicable) :-
    gdpr_data_subject_rights_response_period_profile_for(no_extension_claimed, Profile),
    gdpr_data_subject_rights_response_period_checklist(Profile, [item(extension_claimed, unmet(extension_not_claimed), cite(eu_reg_2016_679_art_12_3)), item(extension_necessary_for_complexity_and_number, inapplicable, cite(eu_reg_2016_679_art_12_3))]).
test(every_subject_is_resolvable) :-
    findall(Subject, gdpr_data_subject_rights_response_period_subject(Subject), Subjects),
    findall(Subject, (gdpr_data_subject_rights_response_period_subject(Subject), gdpr_data_subject_rights_response_period_profile_for(Subject, Profile), gdpr_data_subject_rights_response_period_decision_resolvable(Profile)), Resolvable),
    Resolvable == Subjects.
test(status_agrees_with_decide) :-
    gdpr_data_subject_rights_response_period_profile_for(claimed_and_unsure, Profile),
    gdpr_data_subject_rights_response_period_status(Profile, needs_legal_review),
    decide_gdpr_data_subject_rights_response_period(Profile, gdpr_data_subject_rights_response_period_verdict(needs_legal_review, [cite(eu_reg_2016_679_art_12_3)])).
test(what_if_judgement_true_extends_the_claimed_profile) :-
    gdpr_data_subject_rights_response_period_profile_for(claimed_without_judgement, Profile),
    findall(Status, gdpr_data_subject_rights_response_period_what_if(Profile, extension_necessary_for_complexity_and_number, true, Status), Statuses),
    Statuses == [extended_period].
test(what_if_withdrawing_the_claim_gives_first_period) :-
    gdpr_data_subject_rights_response_period_profile_for(claimed_and_necessary, Profile),
    findall(Status, gdpr_data_subject_rights_response_period_what_if(Profile, extension_claimed, false, Status), Statuses),
    Statuses == [first_period].

test(near_miss_not_necessary_is_not_extended, fail) :-
    gdpr_data_subject_rights_response_period_assess(claimed_not_necessary, gdpr_data_subject_rights_response_period_verdict(extended_period, _)).
test(near_miss_necessity_without_claim_is_not_extended, fail) :-
    gdpr_data_subject_rights_response_period_assess(necessity_without_claim, gdpr_data_subject_rights_response_period_verdict(extended_period, _)).
test(near_miss_claim_false_is_not_extended, fail) :-
    gdpr_data_subject_rights_response_period_assess(claim_withdrawn_but_necessary, gdpr_data_subject_rights_response_period_verdict(extended_period, _)).
test(near_miss_claimed_and_necessary_is_not_first_period, fail) :-
    gdpr_data_subject_rights_response_period_assess(claimed_and_necessary, gdpr_data_subject_rights_response_period_verdict(first_period, _)).
test(near_miss_judgement_given_is_not_indeterminate, fail) :-
    gdpr_data_subject_rights_response_period_assess(claimed_and_necessary, gdpr_data_subject_rights_response_period_verdict(indeterminate, _)).
test(near_miss_judgement_false_is_not_referred, fail) :-
    gdpr_data_subject_rights_response_period_assess(claimed_not_necessary, gdpr_data_subject_rights_response_period_verdict(needs_legal_review, _)).
test(near_miss_unread_keys_are_not_input_problems, fail) :-
    gdpr_data_subject_rights_response_period_assess(unread_keys_present, gdpr_data_subject_rights_response_period_verdict(input_problems, _)).
test(near_miss_well_formed_is_not_input_problems, fail) :-
    gdpr_data_subject_rights_response_period_assess(claimed_and_necessary, gdpr_data_subject_rights_response_period_verdict(input_problems, _)).
test(referral_context_carries_no_provenance_item, fail) :-
    gdpr_data_subject_rights_response_period_profile_for(claimed_and_unsure, Profile),
    applicable_response_period(Profile, needs_legal_review(_Reason, Context)),
    member(provenance(_Source, _Detail), Context).
test(deadline_sunday_is_not_the_answer, fail) :-
    response_deadline(date(2026, 10, 29), first_period, date(2026, 11, 29)).
test(deadline_extended_is_not_step_by_step, fail) :-
    response_deadline(date(2026, 1, 31), extended_period, date(2026, 4, 28)).
test(what_if_judgement_false_does_not_extend, fail) :-
    gdpr_data_subject_rights_response_period_profile_for(claimed_without_judgement, Profile),
    gdpr_data_subject_rights_response_period_what_if(Profile, extension_necessary_for_complexity_and_number, false, extended_period).

cp_test_names([every_subject_resolves_to_its_expected_status_once, every_status_is_in_the_vocabulary, no_extension_claimed_is_first_period, claimed_and_necessary_is_extended_period, claimed_and_necessary_cites_article_12_3, claimed_not_necessary_is_first_period, claimed_without_judgement_is_indeterminate, claimed_and_unsure_is_needs_legal_review, unknown_key_given_is_input_problems, applicable_period_needs_legal_review_term, applicable_period_indeterminate_names_the_key, applicable_period_duplicate_key, applicable_period_wrong_type_claim, applicable_period_not_a_list, referral_context_carries_inputs_relied_on, input_check_clean_profile, input_check_orders_contract_keys_then_unknown_keys, input_check_impossible_date, input_check_bare_outside_fact, input_check_accepts_document_evidence, input_check_accepts_url_evidence, deadline_friday_is_not_shifted, deadline_saturday_moves_to_monday, deadline_sunday_moves_to_monday, deadline_wednesday_is_not_shifted, deadline_clipped_to_leap_day, deadline_clipped_common_year_sunday_moves_to_monday, deadline_clipped_saturday_moves_to_monday, deadline_year_carry, deadline_extended_from_receipt, deadline_extended_sunday_moves_to_monday, deadline_impossible_receipt, deadline_list_receipt_is_wrong_type, deadline_unknown_period, deadline_both_arguments_wrong, outside_facts_record_the_attested_holidays, outside_facts_copy_document_evidence_as_given, outside_facts_copy_url_evidence_as_given, outside_facts_on_a_bad_profile, attested_holiday_does_not_shift_the_deadline, every_subject_has_a_non_empty_checklist, claimed_and_necessary_checklist_is_all_met, no_claim_checklist_marks_necessity_inapplicable, every_subject_is_resolvable, status_agrees_with_decide, what_if_judgement_true_extends_the_claimed_profile, what_if_withdrawing_the_claim_gives_first_period]).
cp_test_fail_names([near_miss_not_necessary_is_not_extended, near_miss_necessity_without_claim_is_not_extended, near_miss_claim_false_is_not_extended, near_miss_claimed_and_necessary_is_not_first_period, near_miss_judgement_given_is_not_indeterminate, near_miss_judgement_false_is_not_referred, near_miss_unread_keys_are_not_input_problems, near_miss_well_formed_is_not_input_problems, referral_context_carries_no_provenance_item, deadline_sunday_is_not_the_answer, deadline_extended_is_not_step_by_step, what_if_judgement_false_does_not_extend]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
