% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_codes_and_certification_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_gdpr_codes_and_certification, [decide_gdpr_codes_and_certification/2, gdpr_codes_and_certification_status/2, gdpr_codes_and_certification_checklist/2, gdpr_codes_and_certification_decision_resolvable/1, gdpr_codes_and_certification_status_values/1, certification_status/5, code_monitoring_status/3, accreditation_status/6]).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_fixtures, [gdpr_codes_and_certification_subject/1, gdpr_codes_and_certification_profile_for/2, gdpr_codes_and_certification_assess/2]).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_kernel, [gdpr_codes_and_certification_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_queries, [gdpr_codes_and_certification_profile_keys/1, gdpr_codes_and_certification_what_if/4, gdpr_codes_and_certification_provision/3, gdpr_codes_and_certification_ground_provision/3, gdpr_codes_and_certification_key_read/2]).

resolves_to(Subject, Expected) :-
    findall(Result, gdpr_codes_and_certification_assess(Subject, gdpr_codes_and_certification_verdict(Result, _)), Results),
    Results == [Expected].

exactly_one_answer(Subject) :-
    findall(Verdict, gdpr_codes_and_certification_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

citations_fit(Subject) :-
    gdpr_codes_and_certification_assess(Subject, gdpr_codes_and_certification_verdict(Result, Citations)),
    result_citations_fit(Result, Citations).

result_citations_fit(indeterminate(_), []).
result_citations_fit(needs_legal_review(_, _), []).
result_citations_fit(input_problems(_), []).
result_citations_fit(certification_result(_, _), [_|_]).
result_citations_fit(code_result(_, _), [_|_]).
result_citations_fit(Result, [_|_]) :-
    atom(Result).

item_cited(item(_, _, cite(_))).

cites_exactly(Subject, Expected) :-
    gdpr_codes_and_certification_assess(Subject, gdpr_codes_and_certification_verdict(_, Citations)),
    sort(Citations, Sorted),
    sort(Expected, Sorted).

duties([take_appropriate_action_on_infringement, inform_supervisory_authority_of_actions_and_reasons]).

test(every_fixture_subject_has_exactly_one_answer) :-
    findall(Subject, gdpr_codes_and_certification_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(exactly_one_answer, Subjects).
test(fixture_subjects_are_named_once) :-
    findall(Subject, gdpr_codes_and_certification_subject(Subject), Subjects),
    sort(Subjects, Distinct),
    length(Subjects, Count),
    length(Distinct, Count).
test(every_final_answer_cites_and_every_open_answer_does_not) :-
    findall(Subject, gdpr_codes_and_certification_subject(Subject), Subjects),
    maplist(citations_fit, Subjects).
test(certification_in_force) :-
    resolves_to(certification_in_force, certification_result(within_maximum_period, not_relied_on_for_transfers)).
test(certification_on_last_day_of_period_is_in_force) :-
    resolves_to(certification_on_last_day_of_period, certification_result(within_maximum_period, not_relied_on_for_transfers)).
test(certification_day_after_last_day_has_ended) :-
    resolves_to(certification_day_after_last_day_of_period, certification_result(maximum_period_ended, not_relied_on_for_transfers)).
test(certification_leap_day_start_ends_on_twenty_eighth) :-
    resolves_to(certification_leap_day_start_on_last_day, certification_result(within_maximum_period, not_relied_on_for_transfers)).
test(certification_leap_day_start_has_ended_on_first_of_march) :-
    resolves_to(certification_leap_day_start_day_after_last_day, certification_result(maximum_period_ended, not_relied_on_for_transfers)).
test(certification_checked_on_issue_day_is_in_force) :-
    resolves_to(certification_checked_on_issue_day, certification_result(within_maximum_period, not_relied_on_for_transfers)).
test(certification_checked_before_issue_day_is_not_yet_issued) :-
    resolves_to(certification_checked_before_issue_day, certification_result(not_yet_issued, not_relied_on_for_transfers)).
test(certification_by_other_issuer) :-
    resolves_to(certification_by_other_issuer, certification_result(not_issued_by_competent_issuer, not_relied_on_for_transfers)).
test(certification_by_accredited_body_that_informed) :-
    resolves_to(certification_by_accredited_body_that_informed, certification_result(within_maximum_period, not_relied_on_for_transfers)).
test(certification_by_unaccredited_body) :-
    resolves_to(certification_by_unaccredited_body, certification_result(not_issued_by_competent_issuer, not_relied_on_for_transfers)).
test(certification_body_accreditation_absent_is_named) :-
    resolves_to(certification_body_accreditation_absent, indeterminate([certification_body_accredited])).
test(certification_body_did_not_inform) :-
    resolves_to(certification_body_did_not_inform, certification_result(issued_without_informing_supervisory_authority, not_relied_on_for_transfers)).
test(certification_criteria_not_approved) :-
    resolves_to(certification_criteria_not_approved, certification_result(criteria_not_approved, not_relied_on_for_transfers)).
test(certification_withdrawn) :-
    resolves_to(certification_withdrawn, certification_result(withdrawn, not_relied_on_for_transfers)).
test(certification_requirements_no_longer_met) :-
    resolves_to(certification_requirements_no_longer_met, certification_result(withdrawal_required, not_relied_on_for_transfers)).
test(certification_requirements_unsure_is_referred) :-
    resolves_to(certification_requirements_unsure, needs_legal_review(open_textured(certification_requirements_not_met, cite(eu_reg_2016_679_art_42_7)), [inputs_relied_on([certification_issuer - competent_supervisory_authority, certification_criteria_approved - true, certification_withdrawn - false, certification_requirements_not_met - unsure, certification_holder_not_subject_to_regulation - false])])).
test(certification_absent_key_named_before_unsure_judgement) :-
    resolves_to(certification_requirements_unsure_holder_absent, indeterminate([certification_holder_not_subject_to_regulation])).
test(certification_issuer_absent_is_named_alone) :-
    resolves_to(certification_issuer_absent, indeterminate([certification_issuer])).
test(certification_for_transfers_conditions_met) :-
    resolves_to(certification_for_transfers_conditions_met, certification_result(within_maximum_period, transfer_conditions_met)).
test(certification_for_transfers_without_commitments) :-
    resolves_to(certification_for_transfers_without_commitments, certification_result(within_maximum_period, transfer_conditions_not_met)).
test(certification_for_transfers_commitments_absent) :-
    resolves_to(certification_for_transfers_commitments_absent, indeterminate([certification_holder_binding_commitments_made])).
test(certification_withdrawn_beside_transfer_conditions_met) :-
    resolves_to(certification_withdrawn_transfer_conditions_met, certification_result(withdrawn, transfer_conditions_met)).
test(certification_final_answer_cites_its_provisions) :-
    cites_exactly(certification_in_force, [cite(eu_reg_2016_679_art_42_2), cite(eu_reg_2016_679_art_42_4), cite(eu_reg_2016_679_art_42_5), cite(eu_reg_2016_679_art_42_7), cite(eu_reg_2016_679_art_43_1)]).
test(code_monitored_and_relied_on_for_transfers) :-
    duties(Duties),
    resolves_to(code_monitored_and_relied_on_for_transfers, code_result(monitoring_by_accredited_body(Duties), transfer_conditions_met)).
test(code_without_general_validity) :-
    duties(Duties),
    resolves_to(code_without_general_validity, code_result(monitoring_by_accredited_body(Duties), transfer_conditions_not_met)).
test(code_not_relied_on_for_transfers) :-
    duties(Duties),
    resolves_to(code_not_relied_on_for_transfers, code_result(monitoring_by_accredited_body(Duties), not_relied_on_for_transfers)).
test(code_for_public_authority_processing) :-
    resolves_to(code_for_public_authority_processing, code_result(article_41_not_applicable, not_relied_on_for_transfers)).
test(code_not_prepared_by_representative_body) :-
    resolves_to(code_not_prepared_by_representative_body, code_result(not_a_code_under_article_40_2, transfer_conditions_met)).
test(code_not_approved) :-
    resolves_to(code_not_approved, code_result(code_not_approved, transfer_conditions_not_met)).
test(code_without_monitoring_mechanisms) :-
    resolves_to(code_without_monitoring_mechanisms, code_result(monitoring_mechanisms_missing, transfer_conditions_met)).
test(code_without_accredited_monitoring_body) :-
    resolves_to(code_without_accredited_monitoring_body, code_result(no_accredited_monitoring_body, transfer_conditions_met)).
test(code_preparer_unsure_is_referred) :-
    resolves_to(code_preparer_unsure, needs_legal_review(open_textured(code_prepared_by_body_representing_controllers_or_processors, cite(eu_reg_2016_679_art_40_2)), [inputs_relied_on([processing_by_public_authority_or_body - false, code_prepared_by_body_representing_controllers_or_processors - unsure, code_approved_by_competent_supervisory_authority - true, code_contains_monitoring_mechanisms - true, monitoring_body_accredited - true, code_adhered_to_by_party_not_subject_to_regulation - true, code_has_general_validity - true, code_adherent_binding_commitments_made - true])])).
test(code_absent_approval_named_before_unsure_preparer) :-
    resolves_to(code_preparer_unsure_approval_absent, indeterminate([code_approved_by_competent_supervisory_authority])).
test(code_absence_in_transfer_part_named_before_judgement_in_monitoring_part) :-
    resolves_to(code_preparer_unsure_general_validity_absent, indeterminate([code_has_general_validity])).
test(code_public_authority_adherence_absent) :-
    resolves_to(code_public_authority_adherence_absent, indeterminate([code_adhered_to_by_party_not_subject_to_regulation])).
test(code_final_answer_cites_its_provisions) :-
    cites_exactly(code_not_approved, [cite(eu_reg_2016_679_art_40_2), cite(eu_reg_2016_679_art_40_3), cite(eu_reg_2016_679_art_40_4), cite(eu_reg_2016_679_art_40_5), cite(eu_reg_2016_679_art_40_9), cite(eu_reg_2016_679_art_41_1), cite(eu_reg_2016_679_art_41_4), cite(eu_reg_2016_679_art_41_6)]).
test(monitoring_body_conditions_met) :-
    resolves_to(monitoring_body_conditions_met, accreditation_conditions_met).
test(monitoring_body_checked_on_accreditation_day) :-
    resolves_to(monitoring_body_checked_on_accreditation_day, accreditation_conditions_met).
test(monitoring_body_checked_before_accreditation_day) :-
    resolves_to(monitoring_body_checked_before_accreditation_day, not_yet_accredited).
test(monitoring_body_accreditation_revoked) :-
    resolves_to(monitoring_body_accreditation_revoked, accreditation_revoked).
test(monitoring_body_complaint_procedures_missing) :-
    resolves_to(monitoring_body_complaint_procedures_missing, accreditation_conditions_not_met).
test(monitoring_body_actions_infringe) :-
    resolves_to(monitoring_body_actions_infringe, revocation_required).
test(monitoring_body_independence_unsure_is_referred) :-
    resolves_to(monitoring_body_independence_unsure, needs_legal_review(open_textured(monitoring_body_independence_and_expertise_demonstrated, cite(eu_reg_2016_679_art_41_2_a)), [inputs_relied_on([monitoring_body_accreditation_revoked - false, monitoring_body_independence_and_expertise_demonstrated - unsure, monitoring_body_eligibility_monitoring_and_review_procedures_established - true, monitoring_body_complaint_procedures_and_structures_established - true, monitoring_body_no_conflict_of_interests_demonstrated - true, monitoring_body_actions_infringe_regulation - false])])).
test(monitoring_body_refuted_point_decides_over_unsure_point) :-
    resolves_to(monitoring_body_independence_unsure_conflict_refuted, accreditation_conditions_not_met).
test(monitoring_body_infringement_unsure_is_referred) :-
    resolves_to(monitoring_body_infringement_unsure, needs_legal_review(open_textured(monitoring_body_actions_infringe_regulation, cite(eu_reg_2016_679_art_41_5)), [inputs_relied_on([monitoring_body_accreditation_revoked - false, monitoring_body_independence_and_expertise_demonstrated - true, monitoring_body_eligibility_monitoring_and_review_procedures_established - true, monitoring_body_complaint_procedures_and_structures_established - true, monitoring_body_no_conflict_of_interests_demonstrated - true, monitoring_body_actions_infringe_regulation - unsure])])).
test(monitoring_body_accredited_on_leap_day) :-
    resolves_to(monitoring_body_accredited_on_leap_day, accreditation_conditions_met).
test(monitoring_body_final_answer_cites_its_provisions) :-
    cites_exactly(monitoring_body_conditions_met, [cite(eu_reg_2016_679_art_41_1), cite(eu_reg_2016_679_art_41_2), cite(eu_reg_2016_679_art_41_2_a), cite(eu_reg_2016_679_art_41_2_b), cite(eu_reg_2016_679_art_41_2_c), cite(eu_reg_2016_679_art_41_2_d), cite(eu_reg_2016_679_art_41_5)]).
test(certification_body_conditions_met) :-
    resolves_to(certification_body_conditions_met, accreditation_conditions_met).
test(certification_body_on_last_day_of_period) :-
    resolves_to(certification_body_on_last_day_of_period, accreditation_conditions_met).
test(certification_body_day_after_last_day_of_period) :-
    resolves_to(certification_body_day_after_last_day_of_period, maximum_period_ended).
test(certification_body_leap_day_start_on_last_day) :-
    resolves_to(certification_body_leap_day_start_on_last_day, accreditation_conditions_met).
test(certification_body_leap_day_start_day_after_last_day) :-
    resolves_to(certification_body_leap_day_start_day_after_last_day, maximum_period_ended).
test(certification_body_checked_before_accreditation_day) :-
    resolves_to(certification_body_checked_before_accreditation_day, not_yet_accredited).
test(certification_body_period_beyond_calendar_raises_nothing) :-
    resolves_to(certification_body_period_beyond_calendar, accreditation_conditions_met).
test(certification_body_accredited_by_both_entities) :-
    resolves_to(certification_body_accredited_by_both_entities, accreditation_conditions_met).
test(certification_body_accredited_by_other_entity) :-
    resolves_to(certification_body_accredited_by_other_entity, not_accredited_by_entity_named_in_article_43_1).
test(certification_body_accreditation_revoked) :-
    resolves_to(certification_body_accreditation_revoked, accreditation_revoked).
test(certification_body_criteria_undertaking_missing) :-
    resolves_to(certification_body_criteria_undertaking_missing, accreditation_conditions_not_met).
test(certification_body_actions_infringe) :-
    resolves_to(certification_body_actions_infringe, revocation_required).
test(certification_body_conflict_unsure_is_referred) :-
    resolves_to(certification_body_conflict_unsure, needs_legal_review(open_textured(certification_body_no_conflict_of_interests_demonstrated, cite(eu_reg_2016_679_art_43_2_e)), [inputs_relied_on([certification_body_accreditation_revoked - false, certification_body_accrediting_entity - national_accreditation_body, certification_body_independence_and_expertise_demonstrated - true, certification_body_undertook_to_respect_approved_criteria - true, certification_body_issuing_review_and_withdrawal_procedures_established - true, certification_body_complaint_procedures_and_structures_established - true, certification_body_no_conflict_of_interests_demonstrated - unsure, certification_body_actions_infringe_regulation - false])])).
test(certification_body_final_answer_cites_its_provisions) :-
    cites_exactly(certification_body_conditions_met, [cite(eu_reg_2016_679_art_43_1), cite(eu_reg_2016_679_art_43_1_a), cite(eu_reg_2016_679_art_43_1_b), cite(eu_reg_2016_679_art_43_2), cite(eu_reg_2016_679_art_43_2_a), cite(eu_reg_2016_679_art_43_2_b), cite(eu_reg_2016_679_art_43_2_c), cite(eu_reg_2016_679_art_43_2_d), cite(eu_reg_2016_679_art_43_2_e), cite(eu_reg_2016_679_art_43_4), cite(eu_reg_2016_679_art_43_7)]).
test(input_duplicate_and_unknown) :-
    resolves_to(input_duplicate_and_unknown, input_problems([duplicate_key(certification_withdrawn), unknown_key(colour)])).
test(input_attested_value_is_wrong_type) :-
    resolves_to(input_attested_value, input_problems([wrong_type(certification_withdrawn)])).
test(input_crisp_key_unsure_is_wrong_type) :-
    resolves_to(input_crisp_key_unsure, input_problems([wrong_type(certification_withdrawn)])).
test(input_judgement_key_unsure_is_well_typed) :-
    resolves_to(input_judgement_key_unsure, indeterminate([processing_by_public_authority_or_body])).
test(input_bad_body_and_dates) :-
    resolves_to(input_bad_body_and_dates, input_problems([wrong_type(body), wrong_type(accredited_on), wrong_type(check_date)])).
test(input_issue_date_not_a_real_day) :-
    resolves_to(input_issue_date_not_a_real_day, input_problems([wrong_type(issued_on)])).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, gdpr_codes_and_certification_input_problems([], Problems), Answers),
    Answers == [[]].
test(an_unbound_profile_is_not_a_profile) :-
    findall(Problems, gdpr_codes_and_certification_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_partial_list_is_not_a_profile) :-
    gdpr_codes_and_certification_input_problems([attribute(certification_withdrawn, true)|_], [wrong_type(profile)]).
test(a_non_attribute_item_is_not_a_profile) :-
    gdpr_codes_and_certification_input_problems([certification_withdrawn], [wrong_type(profile)]).
test(an_atom_is_not_a_profile) :-
    gdpr_codes_and_certification_input_problems(nothing, [wrong_type(profile)]).
test(an_unbound_key_is_unknown_as_given) :-
    gdpr_codes_and_certification_input_problems([attribute(Key, true)], [unknown_key(Named)]),
    Named == Key.
test(two_unbound_keys_are_two_unknown_keys) :-
    gdpr_codes_and_certification_input_problems([attribute(FirstKey, true), attribute(SecondKey, false)], [unknown_key(FirstNamed), unknown_key(SecondNamed)]),
    FirstNamed == FirstKey,
    SecondNamed == SecondKey.
test(one_unbound_key_twice_is_one_unknown_key) :-
    gdpr_codes_and_certification_input_problems([attribute(Key, true), attribute(Key, false)], [unknown_key(Named)]),
    Named == Key.
test(an_unbound_contract_value_is_wrong_type) :-
    gdpr_codes_and_certification_input_problems([attribute(certification_withdrawn, _)], [wrong_type(certification_withdrawn)]).
test(an_unbound_body_is_wrong_type) :-
    findall(Result, accreditation_status([], _, date(2020, 1, 1), date(2021, 1, 1), Result, _), Results),
    Results == [input_problems([wrong_type(body)])].
test(an_unbound_check_date_is_wrong_type) :-
    findall(Result, certification_status([], date(2020, 1, 1), _, Result, _), Results),
    Results == [input_problems([wrong_type(check_date)])].
test(an_unread_key_does_not_change_the_code_answer) :-
    duties(Duties),
    gdpr_codes_and_certification_profile_for(code_monitored_and_relied_on_for_transfers, Profile),
    code_monitoring_status([attribute(certification_withdrawn, true)|Profile], code_result(monitoring_by_accredited_body(Duties), transfer_conditions_met), _).
test(an_unread_key_does_not_change_the_monitoring_body_answer) :-
    gdpr_codes_and_certification_profile_for(monitoring_body_conditions_met, Profile),
    accreditation_status([attribute(certification_body_accrediting_entity, other_entity)|Profile], monitoring_body, date(2020, 1, 1), date(2030, 1, 1), accreditation_conditions_met, _).
test(decision_is_the_code_query) :-
    duties(Duties),
    gdpr_codes_and_certification_profile_for(code_monitored_and_relied_on_for_transfers, Profile),
    findall(Verdict, decide_gdpr_codes_and_certification(Profile, Verdict), Verdicts),
    Verdicts = [gdpr_codes_and_certification_verdict(code_result(monitoring_by_accredited_body(Duties), transfer_conditions_met), [_|_])].
test(status_is_in_the_status_values) :-
    gdpr_codes_and_certification_profile_for(code_not_approved, Profile),
    gdpr_codes_and_certification_status(Profile, Status),
    Status == code_result,
    gdpr_codes_and_certification_status_values(StatusValues),
    member(Status, StatusValues).
test(status_of_an_open_profile_is_indeterminate) :-
    gdpr_codes_and_certification_profile_for(code_public_authority_adherence_absent, Profile),
    gdpr_codes_and_certification_status(Profile, indeterminate).
test(checklist_is_non_empty_and_cited) :-
    gdpr_codes_and_certification_profile_for(code_without_accredited_monitoring_body, Profile),
    gdpr_codes_and_certification_checklist(Profile, Items),
    Items = [_|_],
    maplist(item_cited, Items),
    member(item(accredited_monitoring_body, unmet(no_accredited_monitoring_body), cite(eu_reg_2016_679_art_41_1)), Items).
test(checklist_marks_passed_steps_met) :-
    gdpr_codes_and_certification_profile_for(code_monitored_and_relied_on_for_transfers, Profile),
    gdpr_codes_and_certification_checklist(Profile, Items),
    member(item(code_approval, met, cite(eu_reg_2016_679_art_40_5)), Items).
test(checklist_of_an_input_problem_profile_is_cited) :-
    gdpr_codes_and_certification_profile_for(input_duplicate_and_unknown, Profile),
    gdpr_codes_and_certification_checklist(Profile, [Item]),
    item_cited(Item).
test(decision_is_resolvable_on_a_fixture) :-
    gdpr_codes_and_certification_profile_for(code_for_public_authority_processing, Profile),
    gdpr_codes_and_certification_decision_resolvable(Profile).
test(what_if_settling_the_absent_approval_reaches_the_referral) :-
    gdpr_codes_and_certification_profile_for(code_preparer_unsure_approval_absent, Profile),
    gdpr_codes_and_certification_what_if(Profile, code_approved_by_competent_supervisory_authority, true, needs_legal_review).
test(without_the_what_if_the_approval_is_missing) :-
    gdpr_codes_and_certification_profile_for(code_preparer_unsure_approval_absent, Profile),
    gdpr_codes_and_certification_status(Profile, indeterminate).
test(what_if_on_an_unread_key_keeps_the_answer) :-
    gdpr_codes_and_certification_profile_for(code_monitored_and_relied_on_for_transfers, Profile),
    gdpr_codes_and_certification_what_if(Profile, certification_withdrawn, true, code_result).
test(provision_lookup_reads_the_period_sentence) :-
    findall(Verbatim, gdpr_codes_and_certification_provision(eu_reg_2016_679_art_43_4, _, Verbatim), Verbatims),
    Verbatims == ['The accreditation shall be issued for a maximum period of five years and may be renewed on the same conditions provided that the certification body meets the requirements set out in this Article.'].
test(provision_lookup_enumerates_every_provision) :-
    findall(Key, gdpr_codes_and_certification_provision(Key, _, _), Keys),
    length(Keys, 29).
test(ground_lookup_separates_the_two_periods) :-
    gdpr_codes_and_certification_ground_provision(certification_status, maximum_period_ended, cite(eu_reg_2016_679_art_42_7)),
    gdpr_codes_and_certification_ground_provision(certification_body, maximum_period_ended, cite(eu_reg_2016_679_art_43_4)).
test(key_read_enumerates_the_monitoring_body_keys_in_order) :-
    findall(Key, gdpr_codes_and_certification_key_read(monitoring_body, Key), Keys),
    Keys == [monitoring_body_accreditation_revoked, monitoring_body_independence_and_expertise_demonstrated, monitoring_body_eligibility_monitoring_and_review_procedures_established, monitoring_body_complaint_procedures_and_structures_established, monitoring_body_no_conflict_of_interests_demonstrated, monitoring_body_actions_infringe_regulation].
test(profile_keys_are_the_thirty_contract_keys) :-
    gdpr_codes_and_certification_profile_keys(Keys),
    length(Keys, 30).

test(certification_day_after_last_day_is_not_in_force, fail) :-
    resolves_to(certification_day_after_last_day_of_period, certification_result(within_maximum_period, _)).
test(monitoring_body_never_has_a_maximum_period, fail) :-
    resolves_to(monitoring_body_conditions_met, maximum_period_ended).
test(no_maximum_period_ground_for_a_monitoring_body, fail) :-
    gdpr_codes_and_certification_ground_provision(monitoring_body, maximum_period_ended, _).

cp_test_names([every_fixture_subject_has_exactly_one_answer, fixture_subjects_are_named_once, every_final_answer_cites_and_every_open_answer_does_not, certification_in_force, certification_on_last_day_of_period_is_in_force, certification_day_after_last_day_has_ended, certification_leap_day_start_ends_on_twenty_eighth, certification_leap_day_start_has_ended_on_first_of_march, certification_checked_on_issue_day_is_in_force, certification_checked_before_issue_day_is_not_yet_issued, certification_by_other_issuer, certification_by_accredited_body_that_informed, certification_by_unaccredited_body, certification_body_accreditation_absent_is_named, certification_body_did_not_inform, certification_criteria_not_approved, certification_withdrawn, certification_requirements_no_longer_met, certification_requirements_unsure_is_referred, certification_absent_key_named_before_unsure_judgement, certification_issuer_absent_is_named_alone, certification_for_transfers_conditions_met, certification_for_transfers_without_commitments, certification_for_transfers_commitments_absent, certification_withdrawn_beside_transfer_conditions_met, certification_final_answer_cites_its_provisions, code_monitored_and_relied_on_for_transfers, code_without_general_validity, code_not_relied_on_for_transfers, code_for_public_authority_processing, code_not_prepared_by_representative_body, code_not_approved, code_without_monitoring_mechanisms, code_without_accredited_monitoring_body, code_preparer_unsure_is_referred, code_absent_approval_named_before_unsure_preparer, code_absence_in_transfer_part_named_before_judgement_in_monitoring_part, code_public_authority_adherence_absent, code_final_answer_cites_its_provisions, monitoring_body_conditions_met, monitoring_body_checked_on_accreditation_day, monitoring_body_checked_before_accreditation_day, monitoring_body_accreditation_revoked, monitoring_body_complaint_procedures_missing, monitoring_body_actions_infringe, monitoring_body_independence_unsure_is_referred, monitoring_body_refuted_point_decides_over_unsure_point, monitoring_body_infringement_unsure_is_referred, monitoring_body_accredited_on_leap_day, monitoring_body_final_answer_cites_its_provisions, certification_body_conditions_met, certification_body_on_last_day_of_period, certification_body_day_after_last_day_of_period, certification_body_leap_day_start_on_last_day, certification_body_leap_day_start_day_after_last_day, certification_body_checked_before_accreditation_day, certification_body_period_beyond_calendar_raises_nothing, certification_body_accredited_by_both_entities, certification_body_accredited_by_other_entity, certification_body_accreditation_revoked, certification_body_criteria_undertaking_missing, certification_body_actions_infringe, certification_body_conflict_unsure_is_referred, certification_body_final_answer_cites_its_provisions, input_duplicate_and_unknown, input_attested_value_is_wrong_type, input_crisp_key_unsure_is_wrong_type, input_judgement_key_unsure_is_well_typed, input_bad_body_and_dates, input_issue_date_not_a_real_day, an_empty_profile_has_no_problem, an_unbound_profile_is_not_a_profile, a_partial_list_is_not_a_profile, a_non_attribute_item_is_not_a_profile, an_atom_is_not_a_profile, an_unbound_key_is_unknown_as_given, two_unbound_keys_are_two_unknown_keys, one_unbound_key_twice_is_one_unknown_key, an_unbound_contract_value_is_wrong_type, an_unbound_body_is_wrong_type, an_unbound_check_date_is_wrong_type, an_unread_key_does_not_change_the_code_answer, an_unread_key_does_not_change_the_monitoring_body_answer, decision_is_the_code_query, status_is_in_the_status_values, status_of_an_open_profile_is_indeterminate, checklist_is_non_empty_and_cited, checklist_marks_passed_steps_met, checklist_of_an_input_problem_profile_is_cited, decision_is_resolvable_on_a_fixture, what_if_settling_the_absent_approval_reaches_the_referral, without_the_what_if_the_approval_is_missing, what_if_on_an_unread_key_keeps_the_answer, provision_lookup_reads_the_period_sentence, provision_lookup_enumerates_every_provision, ground_lookup_separates_the_two_periods, key_read_enumerates_the_monitoring_body_keys_in_order, profile_keys_are_the_thirty_contract_keys]).
cp_test_fail_names([certification_day_after_last_day_is_not_in_force, monitoring_body_never_has_a_maximum_period, no_maximum_period_ground_for_a_monitoring_body]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
