% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_notice_consent_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__ind_dpdp_notice_consent_dpdp_notice_consent, [decide_dpdp_notice_consent/2, dpdp_notice_consent_status/2, dpdp_notice_consent_checklist/2, dpdp_notice_consent_decision_resolvable/1, dpdp_notice_consent_status_values/1, consent_ground/3, legitimate_use_ground/3, consent_notice/3, withdrawal_effect/3, consent_manager_status/3, provision_lists/2]).
:- use_module(m__ind_dpdp_notice_consent_fixtures, [dpdp_notice_consent_subject/1, dpdp_notice_consent_profile_for/2, dpdp_notice_consent_assess/2]).
:- use_module(m__ind_dpdp_notice_consent_kernel, [dpdp_notice_consent_input_problems/2]).
:- use_module(m__ind_dpdp_notice_consent_queries, [provenance/2]).

expected_status(consent_lawful, eligible).
expected_status(consent_withdrawn, ineligible).
expected_status(consent_not_given, ineligible).
expected_status(consent_purpose_forbidden, ineligible).
expected_status(consent_fails_section_6_1, ineligible).
expected_status(consent_sections_not_in_force, ineligible).
expected_status(consent_in_force_absent, indeterminate).
expected_status(consent_withdrawal_absent, indeterminate).
expected_status(consent_purpose_unsure, indeterminate).
expected_status(consent_section_6_1_unsure, indeterminate).
expected_status(consent_wrong_type, indeterminate).
expected_status(consent_duplicate_key, indeterminate).
expected_status(consent_unknown_key, indeterminate).
expected_status(legitimate_use_employment, indeterminate).
expected_status(legitimate_use_conditions_unmet, indeterminate).
expected_status(legitimate_use_no_listed_use, indeterminate).
expected_status(legitimate_use_conditions_unsure, indeterminate).
expected_status(notice_request_before_rule_3, indeterminate).
expected_status(notice_request_on_rule_3_day, indeterminate).
expected_status(notice_earlier_consent_before_rule_3, indeterminate).
expected_status(notice_earlier_consent_on_rule_3_day, indeterminate).
expected_status(notice_processor, indeterminate).
expected_status(notice_no_occasion, indeterminate).
expected_status(notice_fiduciary_unsure, indeterminate).
expected_status(withdrawal_cease, ineligible).
expected_status(withdrawal_may_continue, ineligible).
expected_status(withdrawal_not_withdrawn, indeterminate).
expected_status(withdrawal_law_unsure, ineligible).
expected_status(manager_registered, indeterminate).
expected_status(manager_suspended, indeterminate).
expected_status(manager_unregistered, indeterminate).
expected_status(manager_section_not_in_force, indeterminate).

resolves_to_expected(Subject - Expected) :-
    findall(Status, dpdp_notice_consent_assess(Subject, dpdp_notice_consent_verdict(Status, _)), Statuses),
    Statuses == [Expected].

has_cited_checklist(Subject) :-
    dpdp_notice_consent_profile_for(Subject, Profile),
    dpdp_notice_consent_checklist(Profile, [FirstItem|OtherItems]),
    maplist(cited_item, [FirstItem|OtherItems]).

cited_item(item(_, _, cite(Key))) :-
    atom(Key).

subject_profile(Subject, Profile) :-
    dpdp_notice_consent_profile_for(Subject, Profile).

test(every_subject_has_an_expected_status) :-
    findall(Subject, dpdp_notice_consent_subject(Subject), Subjects),
    findall(Subject, expected_status(Subject, _), ExpectedSubjects),
    clausal_msort(Subjects, SortedSubjects),
    clausal_msort(ExpectedSubjects, SortedExpected),
    SortedSubjects == SortedExpected.
test(every_subject_resolves_to_its_expected_status_once) :-
    findall(Subject - Expected, expected_status(Subject, Expected), Pairs),
    maplist(resolves_to_expected, Pairs).
test(every_subject_has_a_non_empty_cited_checklist) :-
    findall(Subject, dpdp_notice_consent_subject(Subject), Subjects),
    maplist(has_cited_checklist, Subjects).
test(every_status_is_in_the_vocabulary) :-
    dpdp_notice_consent_status_values(StatusValues),
    findall(Status, expected_status(_, Status), Statuses),
    sort(Statuses, DistinctStatuses),
    DistinctStatuses == [eligible, indeterminate, ineligible],
    clausal_msort(StatusValues, SortedValues),
    SortedValues == [eligible, indeterminate, ineligible].
test(every_subject_is_resolvable) :-
    findall(Profile, (dpdp_notice_consent_subject(Subject), subject_profile(Subject, Profile)), Profiles),
    maplist(dpdp_notice_consent_decision_resolvable, Profiles).
test(consent_lawful_is_eligible_with_its_citations) :-
    dpdp_notice_consent_assess(consent_lawful, dpdp_notice_consent_verdict(eligible, Citations)),
    Citations == [cite(in_dpdp_act_2023_s_4_1), cite(in_dpdp_act_2023_s_4_1_a), cite(in_dpdp_act_2023_s_6_1)].
test(consent_withdrawn_near_miss_is_ineligible) :-
    dpdp_notice_consent_profile_for(consent_withdrawn, Profile),
    dpdp_notice_consent_status(Profile, ineligible).
test(consent_not_in_force_is_ineligible_citing_section_4_1) :-
    dpdp_notice_consent_assess(consent_sections_not_in_force, dpdp_notice_consent_verdict(ineligible, Citations)),
    Citations == [cite(in_dpdp_act_2023_s_4_1)].
test(indeterminate_verdict_has_no_citations) :-
    dpdp_notice_consent_assess(consent_purpose_unsure, dpdp_notice_consent_verdict(indeterminate, Citations)),
    Citations == [].
test(checklist_of_the_lawful_consent_is_all_met) :-
    dpdp_notice_consent_profile_for(consent_lawful, Profile),
    dpdp_notice_consent_checklist(Profile, Items),
    length(Items, 5),
    member(item(consent_not_withdrawn, met, cite(in_dpdp_act_2023_s_6_4)), Items).
test(checklist_of_the_withdrawn_consent_names_the_withdrawal) :-
    dpdp_notice_consent_profile_for(consent_withdrawn, Profile),
    dpdp_notice_consent_checklist(Profile, Items),
    member(item(consent_not_withdrawn, unmet(consent_withdrawn), cite(in_dpdp_act_2023_s_6_4)), Items).
test(consent_ground_lawful_once) :-
    subject_profile(consent_lawful, Profile),
    findall(Result - Citations, consent_ground(Profile, Result, Citations), Answers),
    Answers == [lawful_on_consent - [cite(in_dpdp_act_2023_s_4_1), cite(in_dpdp_act_2023_s_4_1_a), cite(in_dpdp_act_2023_s_6_1)]].
test(consent_ground_failed_section_6_1_not_lawful_once) :-
    subject_profile(consent_fails_section_6_1, Profile),
    findall(Result - Citations, consent_ground(Profile, Result, Citations), Answers),
    Answers == [not_lawful_on_consent - [cite(in_dpdp_act_2023_s_4_1), cite(in_dpdp_act_2023_s_4_1_a), cite(in_dpdp_act_2023_s_4_2), cite(in_dpdp_act_2023_s_6_1), cite(in_dpdp_act_2023_s_6_4)]].
test(consent_ground_forbidden_purpose_not_lawful) :-
    subject_profile(consent_purpose_forbidden, Profile),
    consent_ground(Profile, not_lawful_on_consent, _).
test(consent_ground_in_force_absent_named_first) :-
    subject_profile(consent_in_force_absent, Profile),
    findall(Result - Citations, consent_ground(Profile, Result, Citations), Answers),
    Answers == [indeterminate([sections_4_to_7_in_force]) - []].
test(consent_ground_withdrawal_absent_named) :-
    subject_profile(consent_withdrawal_absent, Profile),
    consent_ground(Profile, indeterminate([consent_withdrawn]), []).
test(consent_ground_refers_unsure_purpose) :-
    subject_profile(consent_purpose_unsure, Profile),
    findall(Result - Citations, consent_ground(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(lawful_purpose, cite(in_dpdp_act_2023_s_4_2)), [inputs_relied_on([lawful_purpose - unsure, consent_meets_section_6_1 - true])]) - []].
test(consent_ground_refers_unsure_section_6_1) :-
    subject_profile(consent_section_6_1_unsure, Profile),
    consent_ground(Profile, needs_legal_review(open_textured(consent_meets_section_6_1, cite(in_dpdp_act_2023_s_6_1)), [inputs_relied_on([lawful_purpose - true, consent_meets_section_6_1 - unsure])]), []).
test(input_check_wrong_type) :-
    subject_profile(consent_wrong_type, Profile),
    dpdp_notice_consent_input_problems(Profile, [wrong_type(consent_given)]),
    consent_ground(Profile, input_problems([wrong_type(consent_given)]), []).
test(input_check_duplicate_key_is_not_also_wrong_type) :-
    subject_profile(consent_duplicate_key, Profile),
    findall(Problems, dpdp_notice_consent_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(consent_given)]].
test(input_check_unknown_key) :-
    subject_profile(consent_unknown_key, Profile),
    dpdp_notice_consent_input_problems(Profile, [unknown_key(colour)]),
    withdrawal_effect(Profile, input_problems([unknown_key(colour)]), []).
test(input_check_well_formed_profile_has_no_problem) :-
    subject_profile(consent_lawful, Profile),
    dpdp_notice_consent_input_problems(Profile, []).
test(input_check_non_list_profile) :-
    dpdp_notice_consent_input_problems(nothing, [wrong_type(profile)]).
test(input_check_impossible_date) :-
    dpdp_notice_consent_input_problems([attribute(question_date, date(2027, 2, 29))], [wrong_type(question_date)]).
test(input_check_real_leap_day) :-
    dpdp_notice_consent_input_problems([attribute(question_date, date(2028, 2, 29))], []).
test(legitimate_use_employment_cites_clause_i_once) :-
    subject_profile(legitimate_use_employment, Profile),
    findall(Result - Citations, legitimate_use_ground(Profile, Result, Citations), Answers),
    Answers == [lawful_on_legitimate_use - [cite(in_dpdp_act_2023_s_4_1_b), cite(in_dpdp_act_2023_s_7), cite(in_dpdp_act_2023_s_7_i)]].
test(legitimate_use_conditions_unmet_not_lawful) :-
    subject_profile(legitimate_use_conditions_unmet, Profile),
    findall(Result - Citations, legitimate_use_ground(Profile, Result, Citations), Answers),
    Answers == [not_lawful_on_legitimate_use - [cite(in_dpdp_act_2023_s_4_1), cite(in_dpdp_act_2023_s_4_1_b), cite(in_dpdp_act_2023_s_4_2), cite(in_dpdp_act_2023_s_7)]].
test(legitimate_use_no_listed_use_not_lawful) :-
    subject_profile(legitimate_use_no_listed_use, Profile),
    legitimate_use_ground(Profile, not_lawful_on_legitimate_use, _).
test(legitimate_use_refers_unsure_conditions) :-
    subject_profile(legitimate_use_conditions_unsure, Profile),
    legitimate_use_ground(Profile, needs_legal_review(open_textured(legitimate_use_conditions_met, cite(in_dpdp_act_2023_s_7)), [inputs_relied_on([lawful_purpose - true, legitimate_use_conditions_met - unsure])]), []).
test(notice_request_day_before_rule_3) :-
    subject_profile(notice_request_before_rule_3, Profile),
    findall(Result - Citations, consent_notice(Profile, Result, Citations), Answers),
    Answers == [notice_with_request_required_before_rule_3 - [cite(in_dpdp_act_2023_s_5_1), cite(in_dpdp_act_2023_s_5_3), cite(in_dpdp_rules_2025_r_1_4)]].
test(notice_request_on_rule_3_day) :-
    subject_profile(notice_request_on_rule_3_day, Profile),
    findall(Result - Citations, consent_notice(Profile, Result, Citations), Answers),
    Answers == [notice_with_request_required - [cite(in_dpdp_act_2023_s_5_1), cite(in_dpdp_act_2023_s_5_3), cite(in_dpdp_rules_2025_r_3)]].
test(notice_earlier_consent_day_before_rule_3) :-
    subject_profile(notice_earlier_consent_before_rule_3, Profile),
    consent_notice(Profile, notice_for_earlier_consent_required_before_rule_3, [cite(in_dpdp_act_2023_s_5_2), cite(in_dpdp_act_2023_s_5_2_a), cite(in_dpdp_act_2023_s_5_3), cite(in_dpdp_rules_2025_r_1_4)]).
test(notice_earlier_consent_on_rule_3_day) :-
    subject_profile(notice_earlier_consent_on_rule_3_day, Profile),
    findall(Result, consent_notice(Profile, Result, _), Answers),
    Answers == [notice_for_earlier_consent_required].
test(notice_not_required_for_a_processor) :-
    subject_profile(notice_processor, Profile),
    consent_notice(Profile, not_required, [cite(in_dpdp_act_2023_s_2_i), cite(in_dpdp_act_2023_s_5_1), cite(in_dpdp_act_2023_s_5_2_a)]).
test(notice_not_required_without_occasion) :-
    subject_profile(notice_no_occasion, Profile),
    findall(Result, consent_notice(Profile, Result, _), Answers),
    Answers == [not_required].
test(notice_refers_unsure_fiduciary) :-
    subject_profile(notice_fiduciary_unsure, Profile),
    consent_notice(Profile, needs_legal_review(open_textured(acts_as_data_fiduciary, cite(in_dpdp_act_2023_s_2_i)), [inputs_relied_on([acts_as_data_fiduciary - unsure])]), []).
test(withdrawal_cease_required_once) :-
    subject_profile(withdrawal_cease, Profile),
    findall(Result - Citations, withdrawal_effect(Profile, Result, Citations), Answers),
    Answers == [cease_processing_required - [cite(in_dpdp_act_2023_s_6_4), cite(in_dpdp_act_2023_s_6_5), cite(in_dpdp_act_2023_s_6_6)]].
test(withdrawal_processing_may_continue) :-
    subject_profile(withdrawal_may_continue, Profile),
    withdrawal_effect(Profile, processing_may_continue_without_consent, [cite(in_dpdp_act_2023_s_6_6)]).
test(withdrawal_none_needs_no_cessation) :-
    subject_profile(withdrawal_not_withdrawn, Profile),
    findall(Result, withdrawal_effect(Profile, Result, _), Answers),
    Answers == [not_required].
test(withdrawal_refers_unsure_law) :-
    subject_profile(withdrawal_law_unsure, Profile),
    withdrawal_effect(Profile, needs_legal_review(open_textured(processing_required_or_authorised_by_law, cite(in_dpdp_act_2023_s_6_6)), [inputs_relied_on([acts_as_data_fiduciary - true, processing_required_or_authorised_by_law - unsure])]), []).
test(manager_registered_may_act_once) :-
    subject_profile(manager_registered, Profile),
    findall(Result - Citations, consent_manager_status(Profile, Result, Citations), Answers),
    Answers == [may_act_as_consent_manager - [cite(in_dpdp_act_2023_s_2_g), cite(in_dpdp_act_2023_s_6_7), cite(in_dpdp_act_2023_s_6_8), cite(in_dpdp_act_2023_s_6_9), cite(in_dpdp_rules_2025_r_4_2_a), cite(in_dpdp_rules_2025_r_4_3)]].
test(manager_suspended_may_not_act) :-
    subject_profile(manager_suspended, Profile),
    consent_manager_status(Profile, may_not_act_as_consent_manager, [cite(in_dpdp_act_2023_s_2_g), cite(in_dpdp_act_2023_s_6_9), cite(in_dpdp_rules_2025_r_4_5_a)]).
test(manager_unregistered_may_not_act) :-
    subject_profile(manager_unregistered, Profile),
    findall(Result, consent_manager_status(Profile, Result, _), Answers),
    Answers == [may_not_act_as_consent_manager].
test(manager_section_not_in_force) :-
    subject_profile(manager_section_not_in_force, Profile),
    consent_manager_status(Profile, not_in_force, [cite(in_dpdp_act_2023_s_6_9)]).
test(every_topic_gives_one_list_of_its_length) :-
    findall(Topic - Length, topic_length(Topic, Length), Pairs),
    maplist(list_has_length_once, Pairs).
test(the_shared_safeguard_atom_carries_each_list_citation) :-
    provision_lists(state_use_standards, Standards),
    member(content_item(reasonable_security_safeguards, cite(in_dpdp_rules_2025_sch_2_f)), Standards),
    provision_lists(consent_manager_obligations, Obligations),
    member(content_item(reasonable_security_safeguards, cite(in_dpdp_rules_2025_sch_1_partb_7)), Obligations).
test(the_notice_list_opens_with_personal_data_and_purpose) :-
    provision_lists(notice_with_request, [content_item(personal_data_and_proposed_purpose, cite(in_dpdp_act_2023_s_5_1_i))|_]).
test(provenance_names_the_pinned_unit_of_a_citation_once) :-
    findall(Unit, provenance(in_dpdp_act_2023_s_4_1, Unit), Units),
    Units == ['in-dpdp-act-2023-meity-pdf#s4_1'].
test(provenance_names_a_rules_unit) :-
    provenance(in_dpdp_rules_2025_r_1_4, 'in-dpdp-rules-2025-meity-pdf#r1_4').

test(consent_lawful_is_not_ineligible, fail) :-
    dpdp_notice_consent_assess(consent_lawful, dpdp_notice_consent_verdict(ineligible, _)).
test(consent_withdrawn_near_miss_is_not_eligible, fail) :-
    dpdp_notice_consent_assess(consent_withdrawn, dpdp_notice_consent_verdict(eligible, _)).
test(consent_not_given_near_miss_is_not_eligible, fail) :-
    dpdp_notice_consent_assess(consent_not_given, dpdp_notice_consent_verdict(eligible, _)).
test(consent_ground_forbidden_purpose_is_not_lawful_on_consent, fail) :-
    subject_profile(consent_purpose_forbidden, Profile),
    consent_ground(Profile, lawful_on_consent, _).
test(legitimate_use_conditions_unmet_is_not_lawful_on_use, fail) :-
    subject_profile(legitimate_use_conditions_unmet, Profile),
    legitimate_use_ground(Profile, lawful_on_legitimate_use, _).
test(notice_request_day_before_rule_3_is_not_under_rule_3, fail) :-
    subject_profile(notice_request_before_rule_3, Profile),
    consent_notice(Profile, notice_with_request_required, _).
test(notice_for_a_processor_is_not_owed, fail) :-
    subject_profile(notice_processor, Profile),
    consent_notice(Profile, notice_with_request_required, _).
test(withdrawal_cease_is_not_may_continue, fail) :-
    subject_profile(withdrawal_cease, Profile),
    withdrawal_effect(Profile, processing_may_continue_without_consent, _).
test(manager_suspended_is_not_allowed_to_act, fail) :-
    subject_profile(manager_suspended, Profile),
    consent_manager_status(Profile, may_act_as_consent_manager, _).
test(provenance_of_an_unrecorded_key_has_no_unit, fail) :-
    provenance(not_a_recorded_citation_key, _).

topic_length(notice_with_request, 4).
topic_length(notice_for_earlier_consent, 4).
topic_length(rule_3_notice, 7).
topic_length(consent_request, 3).
topic_length(legitimate_uses, 9).
topic_length(state_use_standards, 11).
topic_length(consent_manager_conditions, 10).
topic_length(consent_manager_obligations, 22).

list_has_length_once(Topic - Length) :-
    findall(Items, provision_lists(Topic, Items), Answers),
    Answers = [Items],
    length(Answers, 1),
    length(Items, Length).

cp_test_names([every_subject_has_an_expected_status, every_subject_resolves_to_its_expected_status_once, every_subject_has_a_non_empty_cited_checklist, every_status_is_in_the_vocabulary, every_subject_is_resolvable, consent_lawful_is_eligible_with_its_citations, consent_withdrawn_near_miss_is_ineligible, consent_not_in_force_is_ineligible_citing_section_4_1, indeterminate_verdict_has_no_citations, checklist_of_the_lawful_consent_is_all_met, checklist_of_the_withdrawn_consent_names_the_withdrawal, consent_ground_lawful_once, consent_ground_failed_section_6_1_not_lawful_once, consent_ground_forbidden_purpose_not_lawful, consent_ground_in_force_absent_named_first, consent_ground_withdrawal_absent_named, consent_ground_refers_unsure_purpose, consent_ground_refers_unsure_section_6_1, input_check_wrong_type, input_check_duplicate_key_is_not_also_wrong_type, input_check_unknown_key, input_check_well_formed_profile_has_no_problem, input_check_non_list_profile, input_check_impossible_date, input_check_real_leap_day, legitimate_use_employment_cites_clause_i_once, legitimate_use_conditions_unmet_not_lawful, legitimate_use_no_listed_use_not_lawful, legitimate_use_refers_unsure_conditions, notice_request_day_before_rule_3, notice_request_on_rule_3_day, notice_earlier_consent_day_before_rule_3, notice_earlier_consent_on_rule_3_day, notice_not_required_for_a_processor, notice_not_required_without_occasion, notice_refers_unsure_fiduciary, withdrawal_cease_required_once, withdrawal_processing_may_continue, withdrawal_none_needs_no_cessation, withdrawal_refers_unsure_law, manager_registered_may_act_once, manager_suspended_may_not_act, manager_unregistered_may_not_act, manager_section_not_in_force, every_topic_gives_one_list_of_its_length, the_shared_safeguard_atom_carries_each_list_citation, the_notice_list_opens_with_personal_data_and_purpose, provenance_names_the_pinned_unit_of_a_citation_once, provenance_names_a_rules_unit]).
cp_test_fail_names([consent_lawful_is_not_ineligible, consent_withdrawn_near_miss_is_not_eligible, consent_not_given_near_miss_is_not_eligible, consent_ground_forbidden_purpose_is_not_lawful_on_consent, legitimate_use_conditions_unmet_is_not_lawful_on_use, notice_request_day_before_rule_3_is_not_under_rule_3, notice_for_a_processor_is_not_owed, withdrawal_cease_is_not_may_continue, manager_suspended_is_not_allowed_to_act, provenance_of_an_unrecorded_key_has_no_unit]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
