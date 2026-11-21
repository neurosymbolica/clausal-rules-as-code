% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dma_art_5_2_data_combination_order_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dma_art_5_2_data_combination_order_dma_art_5_2_data_combination_order, [article_5_application_status/4, personal_data_practice_status/4, consent_request_repetition_status/6, decide_dma_art_5_2_data_combination_order/2, dma_art_5_2_data_combination_order_status/2, dma_art_5_2_data_combination_order_checklist/2, dma_art_5_2_data_combination_order_decision_resolvable/1, dma_art_5_2_data_combination_order_status_values/1]).
:- use_module(m__eu_dma_art_5_2_data_combination_order_kernel, [dma_art_5_2_data_combination_order_input_problems/2]).
:- use_module(m__eu_dma_art_5_2_data_combination_order_queries, [dma_art_5_2_data_combination_order_what_if/4]).
:- use_module(m__eu_dma_art_5_2_data_combination_order_fixtures, [dma_art_5_2_data_combination_order_subject/1, dma_art_5_2_data_combination_order_profile_for/2, dma_art_5_2_data_combination_order_assess/2]).

expected_status(listed_combining_with_consent, practice_allowed_with_consent).
expected_status(listed_combining_consent_refused_control, practice_prohibited).
expected_status(listed_cross_use_no_choice_legal_obligation, practice_allowed_on_other_legal_basis).
expected_status(listed_cross_use_no_choice_no_basis_control, practice_prohibited).
expected_status(listed_sign_in_consent_refused_no_basis, practice_prohibited).
expected_status(listed_sign_in_consent_given_control, practice_allowed_with_consent).
expected_status(listed_none_of_the_four, practice_outside_article_5_2).
expected_status(listed_advertising_with_consent_control, practice_allowed_with_consent).
expected_status(not_listed_everything_unsure, article_5_obligations_do_not_apply).
expected_status(listed_everything_unsure_control, needs_legal_review(open_textured(practice_under_article_5_2, cite(eu_reg_2022_1925_art_5_2)), [inputs_relied_on([practice_under_article_5_2 - unsure, end_user_presented_with_specific_choice - unsure])])).
expected_status(practice_missing, indeterminate([practice_under_article_5_2])).
expected_status(choice_missing, indeterminate([end_user_presented_with_specific_choice])).
expected_status(choice_missing_consent_refused_basis_true, practice_allowed_on_other_legal_basis).
expected_status(designation_absent_complete, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_5_1), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent, practice_under_article_5_2 - combining_personal_data, end_user_presented_with_specific_choice - true])])).
expected_status(consent_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_5_2), cite(digital_markets_end_user_consent_statement)), [resolution(cite(digital_markets_end_user_consent_statement), not_attempted), inputs_relied_on([practice_under_article_5_2 - combining_personal_data, end_user_presented_with_specific_choice - true, end_user_consent_given - absent])])).
expected_status(consent_absent_choice_false_control, practice_prohibited).
expected_status(basis_absent, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_5_2), cite(digital_markets_article_6_1_c_d_e_basis_statement)), [resolution(cite(digital_markets_article_6_1_c_d_e_basis_statement), not_attempted), inputs_relied_on([practice_under_article_5_2 - combining_personal_data, end_user_presented_with_specific_choice - false, gatekeeper_may_rely_on_article_6_1_c_d_or_e - absent])])).
expected_status(basis_given_control, practice_allowed_on_other_legal_basis).
expected_status(practice_unsure_complete, needs_legal_review(open_textured(practice_under_article_5_2, cite(eu_reg_2022_1925_art_5_2)), [inputs_relied_on([practice_under_article_5_2 - unsure, end_user_presented_with_specific_choice - true])])).
expected_status(choice_unsure_consent_true, needs_legal_review(open_textured(end_user_presented_with_specific_choice, cite(eu_reg_2022_1925_art_5_2)), [inputs_relied_on([practice_under_article_5_2 - combining_personal_data, end_user_presented_with_specific_choice - unsure])])).
expected_status(duplicate_and_unknown_keys, input_problems([duplicate_key(practice_under_article_5_2), unknown_key(colour)])).
expected_status(unbound_attestation_reason, input_problems([wrong_type(designated_as_gatekeeper_for_core_platform_service)])).
expected_status(partial_list_profile, input_problems([wrong_type(profile)])).
expected_status(repeat_listed_not_yet_repeated, indeterminate([practice_under_article_5_2])).
expected_status(repeat_listed_already_repeated, indeterminate([practice_under_article_5_2])).
expected_status(repeat_not_listed, article_5_obligations_do_not_apply).
expected_status(repeat_designation_absent, indeterminate([practice_under_article_5_2])).

near_miss(listed_combining_with_consent, listed_combining_consent_refused_control).
near_miss(listed_cross_use_no_choice_legal_obligation, listed_cross_use_no_choice_no_basis_control).
near_miss(listed_sign_in_consent_refused_no_basis, listed_sign_in_consent_given_control).
near_miss(listed_none_of_the_four, listed_advertising_with_consent_control).
near_miss(not_listed_everything_unsure, listed_everything_unsure_control).
near_miss(choice_missing, choice_missing_consent_refused_basis_true).
near_miss(consent_absent, consent_absent_choice_false_control).
near_miss(basis_absent, basis_given_control).
near_miss(designation_absent_complete, listed_combining_with_consent).
near_miss(practice_unsure_complete, listed_combining_with_consent).
near_miss(choice_unsure_consent_true, listed_combining_with_consent).
near_miss(practice_missing, listed_none_of_the_four).

stated(Truth, attested(Truth, attestation(host_operator, attested_on_2026_11_19, caller_statement, none))).

subject_profile(Subject, Profile) :-
    dma_art_5_2_data_combination_order_profile_for(Subject, Profile).

subject_status(Subject, Status) :-
    subject_profile(Subject, Profile),
    personal_data_practice_status(Profile, Status, _, _).

subject_has_expected_status(Subject) :-
    expected_status(Subject, Expected),
    findall(Status, subject_status(Subject, Status), Statuses),
    Statuses == [Expected].

subject_assessed_as_expected(Subject) :-
    expected_status(Subject, Expected),
    findall(Status, dma_art_5_2_data_combination_order_assess(Subject, dma_art_5_2_data_combination_order_verdict(Status, _)), Statuses),
    Statuses == [Expected].

subject_checklist_not_empty(Subject) :-
    subject_profile(Subject, Profile),
    dma_art_5_2_data_combination_order_checklist(Profile, [_FirstItem|_OtherItems]).

subject_resolvable(Subject) :-
    subject_profile(Subject, Profile),
    dma_art_5_2_data_combination_order_decision_resolvable(Profile).

near_miss_differs(Positive - Control) :-
    expected_status(Positive, PositiveStatus),
    expected_status(Control, ControlStatus),
    subject_has_expected_status(Positive),
    subject_has_expected_status(Control),
    dif(PositiveStatus, ControlStatus).

same_set(Citations, Expected) :-
    sort(Citations, Sorted),
    sort(Expected, Sorted).

repetition(Subject, RefusalDate, RequestDate, Result, Basis, Citations) :-
    subject_profile(Subject, Profile),
    consent_request_repetition_status(Profile, RefusalDate, RequestDate, Result, Basis, Citations).

test(every_subject_has_an_expected_status) :-
    findall(Subject, dma_art_5_2_data_combination_order_subject(Subject), Subjects),
    findall(Subject, expected_status(Subject, _), ExpectedSubjects),
    sort(Subjects, SortedSubjects),
    sort(ExpectedSubjects, SortedSubjects),
    length(Subjects, 27).
test(every_subject_resolves_to_its_expected_status_once) :-
    findall(Subject, dma_art_5_2_data_combination_order_subject(Subject), Subjects),
    maplist(subject_has_expected_status, Subjects).
test(every_subject_is_assessed_to_its_expected_status_once) :-
    findall(Subject, dma_art_5_2_data_combination_order_subject(Subject), Subjects),
    maplist(subject_assessed_as_expected, Subjects).
test(every_subject_has_a_non_empty_checklist) :-
    findall(Subject, dma_art_5_2_data_combination_order_subject(Subject), Subjects),
    maplist(subject_checklist_not_empty, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, dma_art_5_2_data_combination_order_subject(Subject), Subjects),
    maplist(subject_resolvable, Subjects).
test(every_near_miss_control_gets_another_status) :-
    findall(Positive - Control, near_miss(Positive, Control), Pairs),
    length(Pairs, 12),
    maplist(near_miss_differs, Pairs).
test(final_statuses_are_in_the_status_vocabulary) :-
    dma_art_5_2_data_combination_order_status_values(StatusValues),
    subject_status(listed_combining_with_consent, ConsentStatus),
    member(ConsentStatus, StatusValues),
    subject_status(listed_cross_use_no_choice_legal_obligation, OtherStatus),
    member(OtherStatus, StatusValues),
    subject_status(listed_sign_in_consent_refused_no_basis, ProhibitedStatus),
    member(ProhibitedStatus, StatusValues),
    subject_status(listed_none_of_the_four, OutsideStatus),
    member(OutsideStatus, StatusValues),
    subject_status(not_listed_everything_unsure, UnlistedStatus),
    member(UnlistedStatus, StatusValues).
test(allowed_with_consent_basis_and_citations) :-
    subject_profile(listed_combining_with_consent, Profile),
    stated(true, Attested),
    personal_data_practice_status(Profile, practice_allowed_with_consent, Basis, Citations),
    Basis == [outside_fact(designated_as_gatekeeper_for_core_platform_service, Attested), outside_fact(end_user_consent_given, Attested)],
    same_set(Citations, [cite(eu_reg_2022_1925_art_5_1), cite(eu_reg_2022_1925_art_5_2), cite(eu_reg_2022_1925_art_5_2_b), cite(eu_reg_2022_1925_art_2_32)]).
test(consent_refused_control_is_prohibited) :-
    subject_profile(listed_combining_consent_refused_control, Profile),
    personal_data_practice_status(Profile, practice_prohibited, _, _).
test(other_legal_basis_cites_point_c) :-
    subject_profile(listed_cross_use_no_choice_legal_obligation, Profile),
    stated(true, Attested),
    personal_data_practice_status(Profile, practice_allowed_on_other_legal_basis, Basis, Citations),
    Basis == [outside_fact(designated_as_gatekeeper_for_core_platform_service, Attested), outside_fact(gatekeeper_may_rely_on_article_6_1_c_d_or_e, Attested)],
    same_set(Citations, [cite(eu_reg_2022_1925_art_5_1), cite(eu_reg_2022_1925_art_5_2), cite(eu_reg_2022_1925_art_5_2_c)]).
test(prohibited_basis_omits_the_consent_statement) :-
    subject_profile(listed_sign_in_consent_refused_no_basis, Profile),
    stated(true, Designation),
    stated(false, OtherBasis),
    personal_data_practice_status(Profile, practice_prohibited, Basis, Citations),
    Basis == [outside_fact(designated_as_gatekeeper_for_core_platform_service, Designation), outside_fact(gatekeeper_may_rely_on_article_6_1_c_d_or_e, OtherBasis)],
    same_set(Citations, [cite(eu_reg_2022_1925_art_5_1), cite(eu_reg_2022_1925_art_5_2), cite(eu_reg_2022_1925_art_5_2_d)]).
test(point_a_is_cited_for_advertising) :-
    subject_profile(listed_advertising_with_consent_control, Profile),
    personal_data_practice_status(Profile, practice_allowed_with_consent, _, Citations),
    member(cite(eu_reg_2022_1925_art_5_2_a), Citations).
test(outside_article_5_2_citations) :-
    subject_profile(listed_none_of_the_four, Profile),
    stated(true, Attested),
    personal_data_practice_status(Profile, practice_outside_article_5_2, [outside_fact(designated_as_gatekeeper_for_core_platform_service, Attested)], Citations),
    same_set(Citations, [cite(eu_reg_2022_1925_art_5_1), cite(eu_reg_2022_1925_art_5_2)]).
test(not_listed_whatever_else) :-
    subject_profile(not_listed_everything_unsure, Profile),
    stated(false, Attested),
    personal_data_practice_status(Profile, article_5_obligations_do_not_apply, [outside_fact(designated_as_gatekeeper_for_core_platform_service, Attested)], [cite(eu_reg_2022_1925_art_5_1)]).
test(not_final_answers_have_no_basis_or_citations) :-
    subject_profile(consent_absent, Profile),
    personal_data_practice_status(Profile, needs_legal_review(_, _), [], []).
test(facade_status_projection) :-
    subject_profile(basis_given_control, Profile),
    dma_art_5_2_data_combination_order_status(Profile, practice_allowed_on_other_legal_basis),
    decide_dma_art_5_2_data_combination_order(Profile, dma_art_5_2_data_combination_order_verdict(practice_allowed_on_other_legal_basis, Citations)),
    member(cite(eu_reg_2022_1925_art_5_2_b), Citations).
test(checklist_items_carry_citations) :-
    subject_profile(listed_combining_with_consent, Profile),
    dma_art_5_2_data_combination_order_checklist(Profile, Items),
    length(Items, 5),
    member(item(core_platform_service_listed, met, cite(eu_reg_2022_1925_art_5_1)), Items),
    member(item(practice_under_article_5_2, met, cite(eu_reg_2022_1925_art_5_2_b)), Items),
    member(item(consent_given, met, cite(eu_reg_2022_1925_art_2_32)), Items).
test(checklist_marks_an_absent_key_unknown) :-
    subject_profile(basis_absent, Profile),
    dma_art_5_2_data_combination_order_checklist(Profile, Items),
    member(item(other_legal_basis, unknown([gatekeeper_may_rely_on_article_6_1_c_d_or_e]), cite(eu_reg_2022_1925_art_5_2)), Items).
test(application_listed) :-
    subject_profile(practice_missing, Profile),
    stated(true, Attested),
    article_5_application_status(Profile, article_5_obligations_apply, [outside_fact(designated_as_gatekeeper_for_core_platform_service, Attested)], [cite(eu_reg_2022_1925_art_5_1)]).
test(application_not_listed) :-
    subject_profile(repeat_not_listed, Profile),
    article_5_application_status(Profile, article_5_obligations_do_not_apply, _, [cite(eu_reg_2022_1925_art_5_1)]).
test(application_designation_absent_is_referred) :-
    subject_profile(designation_absent_complete, Profile),
    article_5_application_status(Profile, Result, [], []),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_5_1), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent])]).
test(application_input_problems) :-
    subject_profile(duplicate_and_unknown_keys, Profile),
    article_5_application_status(Profile, input_problems([duplicate_key(practice_under_article_5_2), unknown_key(colour)]), [], []).
test(application_has_one_answer) :-
    subject_profile(practice_missing, Profile),
    findall(Result, article_5_application_status(Profile, Result, _, _), Results),
    length(Results, 1).
test(url_evidence_is_copied_into_the_basis) :-
    Attested = attested(true, attestation(host_operator, attested_on_2026_11_19, commission_listing, url('https://digital-markets-act.ec.europa.eu/gatekeepers', retrieved_on_2026_11_19))),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Attested)],
    dma_art_5_2_data_combination_order_input_problems(Profile, []),
    article_5_application_status(Profile, article_5_obligations_apply, Basis, [cite(eu_reg_2022_1925_art_5_1)]),
    Basis == [outside_fact(designated_as_gatekeeper_for_core_platform_service, Attested)],
    Basis = [outside_fact(_, attested(_, attestation(_, _, _, url(Address, RetrievedAt))))],
    Address == 'https://digital-markets-act.ec.europa.eu/gatekeepers',
    RetrievedAt == retrieved_on_2026_11_19.
test(url_evidence_with_an_unbound_part_is_wrong_type) :-
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, attested(true, attestation(host_operator, attested_on_2026_11_19, commission_listing, url(_UnstatedAddress, retrieved_on_2026_11_19))))],
    dma_art_5_2_data_combination_order_input_problems(Profile, [wrong_type(designated_as_gatekeeper_for_core_platform_service)]).
test(document_evidence_is_copied_into_the_basis) :-
    Attested = attested(false, attestation(host_operator, attested_on_2026_11_19, not_listed, document(upload_0001, sha256_of_the_designation_decision))),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Attested)],
    dma_art_5_2_data_combination_order_input_problems(Profile, []),
    article_5_application_status(Profile, article_5_obligations_do_not_apply, Basis, [cite(eu_reg_2022_1925_art_5_1)]),
    Basis = [outside_fact(designated_as_gatekeeper_for_core_platform_service, attested(false, attestation(_, _, _, document(UploadIdentifier, Digest))))],
    UploadIdentifier == upload_0001,
    Digest == sha256_of_the_designation_decision.
test(document_evidence_on_consent_reaches_the_practice_basis) :-
    stated(true, Designation),
    Consent = attested(true, attestation(host_operator, attested_on_2026_11_19, consent_record, document(upload_0002, sha256_of_the_consent_record))),
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, Designation), attribute(practice_under_article_5_2, combining_personal_data), attribute(end_user_presented_with_specific_choice, true), attribute(end_user_consent_given, Consent)],
    personal_data_practice_status(Profile, practice_allowed_with_consent, Basis, _),
    member(outside_fact(end_user_consent_given, Consent), Basis).
test(provenance_is_an_optional_trailing_context_element) :-
    article_5_application_status([], needs_legal_review(Reason, Context), [], []),
    Reason == cross_reference_unresolved(cite(eu_reg_2022_1925_art_5_1), cite(commission_designation_decision)),
    append(Context, [provenance(eu_dma_art_5_2_data_combination_order, pinned_original_act)], Extended),
    Extended = [resolution(cite(Target), not_attempted), inputs_relied_on(Pairs), provenance(Origin, Detail)],
    Target == commission_designation_decision,
    Pairs == [designated_as_gatekeeper_for_core_platform_service - absent],
    Origin == eu_dma_art_5_2_data_combination_order,
    Detail == pinned_original_act.
test(refusal_day_itself_is_within_the_period) :-
    repetition(repeat_listed_not_yet_repeated, date(2025, 3, 10), date(2025, 3, 10), repeated_request_permitted, _, Citations),
    same_set(Citations, [cite(eu_reg_2022_1925_art_5_1), cite(eu_reg_2022_1925_art_5_2)]).
test(day_before_anniversary_first_repeat_permitted) :-
    stated(true, Attested),
    repetition(repeat_listed_not_yet_repeated, date(2025, 3, 10), date(2026, 3, 9), repeated_request_permitted, [outside_fact(designated_as_gatekeeper_for_core_platform_service, Attested)], _).
test(day_before_anniversary_second_repeat_not_permitted) :-
    repetition(repeat_listed_already_repeated, date(2025, 3, 10), date(2026, 3, 9), repeated_request_not_permitted, _, _).
test(anniversary_day_is_after_the_period) :-
    repetition(repeat_listed_already_repeated, date(2025, 3, 10), date(2026, 3, 10), request_after_one_year_period, _, Citations),
    same_set(Citations, [cite(eu_reg_2022_1925_art_5_1), cite(eu_reg_2022_1925_art_5_2)]).
test(leap_day_refusal_day_before_28_february_is_within) :-
    repetition(repeat_listed_not_yet_repeated, date(2024, 2, 29), date(2025, 2, 27), repeated_request_permitted, _, _).
test(leap_day_refusal_28_february_is_after) :-
    repetition(repeat_listed_not_yet_repeated, date(2024, 2, 29), date(2025, 2, 28), request_after_one_year_period, _, _).
test(year_9999_refusal_keeps_the_request_within) :-
    repetition(repeat_listed_not_yet_repeated, date(9999, 6, 1), date(9999, 12, 31), repeated_request_permitted, _, _).
test(repetition_not_listed) :-
    repetition(repeat_not_listed, date(2025, 3, 10), date(2025, 4, 1), article_5_obligations_do_not_apply, _, [cite(eu_reg_2022_1925_art_5_1)]).
test(repetition_designation_absent_is_referred) :-
    repetition(repeat_designation_absent, date(2025, 3, 10), date(2025, 4, 1), Result, [], []),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_1925_art_5_1), cite(commission_designation_decision)), [resolution(cite(commission_designation_decision), not_attempted), inputs_relied_on([designated_as_gatekeeper_for_core_platform_service - absent])]).
test(repetition_crisp_key_absent_is_named) :-
    subject_profile(practice_missing, Profile),
    consent_request_repetition_status(Profile, date(2025, 3, 10), date(2025, 4, 1), indeterminate([consent_request_already_repeated_in_period]), [], []).
test(repetition_crisp_key_absent_after_the_period_is_final) :-
    subject_profile(practice_missing, Profile),
    consent_request_repetition_status(Profile, date(2025, 3, 10), date(2026, 3, 10), request_after_one_year_period, _, _).
test(request_before_refusal_is_wrong_type) :-
    repetition(repeat_listed_not_yet_repeated, date(2025, 3, 10), date(2025, 3, 9), input_problems([wrong_type(request_date)]), [], []).
test(impossible_refusal_day_is_wrong_type) :-
    repetition(repeat_listed_not_yet_repeated, date(2023, 2, 29), date(2023, 3, 1), input_problems([wrong_type(refusal_date)]), [], []).
test(leap_refusal_day_is_a_day) :-
    repetition(repeat_listed_not_yet_repeated, date(2024, 2, 29), date(2024, 3, 1), repeated_request_permitted, _, _).
test(month_13_request_is_wrong_type) :-
    repetition(repeat_listed_not_yet_repeated, date(2025, 3, 10), date(2025, 13, 1), input_problems([wrong_type(request_date)]), [], []).
test(profile_problems_come_before_date_problems) :-
    repetition(duplicate_and_unknown_keys, date(2025, 2, 30), date(2025, 4, 1), input_problems([duplicate_key(practice_under_article_5_2), unknown_key(colour), wrong_type(refusal_date)]), [], []).
test(repetition_has_one_answer) :-
    subject_profile(repeat_listed_not_yet_repeated, Profile),
    findall(Result, consent_request_repetition_status(Profile, date(2025, 3, 10), date(2026, 3, 9), Result, _, _), Results),
    length(Results, 1).
test(input_check_well_formed_profile) :-
    subject_profile(listed_combining_with_consent, Profile),
    dma_art_5_2_data_combination_order_input_problems(Profile, []).
test(input_check_duplicate_then_unknown) :-
    subject_profile(duplicate_and_unknown_keys, Profile),
    dma_art_5_2_data_combination_order_input_problems(Profile, [duplicate_key(practice_under_article_5_2), unknown_key(colour)]).
test(input_check_unbound_reason) :-
    subject_profile(unbound_attestation_reason, Profile),
    dma_art_5_2_data_combination_order_input_problems(Profile, [wrong_type(designated_as_gatekeeper_for_core_platform_service)]).
test(input_check_partial_list) :-
    subject_profile(partial_list_profile, Profile),
    dma_art_5_2_data_combination_order_input_problems(Profile, [wrong_type(profile)]).
test(input_check_crisp_unsure_is_wrong_type) :-
    dma_art_5_2_data_combination_order_input_problems([attribute(consent_request_already_repeated_in_period, unsure)], [wrong_type(consent_request_already_repeated_in_period)]).
test(input_check_has_one_answer) :-
    findall(Problems, dma_art_5_2_data_combination_order_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(what_if_consent_given_flips_to_allowed) :-
    subject_profile(listed_combining_consent_refused_control, Profile),
    stated(true, Consent),
    dma_art_5_2_data_combination_order_what_if(Profile, end_user_consent_given, Consent, practice_allowed_with_consent).
test(what_if_adding_the_practice_names_the_choice) :-
    subject_profile(practice_missing, Profile),
    dma_art_5_2_data_combination_order_what_if(Profile, practice_under_article_5_2, combining_personal_data, indeterminate([end_user_presented_with_specific_choice])).

test(consent_refused_control_is_not_allowed_with_consent, fail) :-
    subject_profile(listed_combining_consent_refused_control, Profile),
    personal_data_practice_status(Profile, practice_allowed_with_consent, _, _).
test(no_basis_control_is_not_allowed_on_other_basis, fail) :-
    subject_profile(listed_cross_use_no_choice_no_basis_control, Profile),
    personal_data_practice_status(Profile, practice_allowed_on_other_legal_basis, _, _).
test(application_not_listed_is_not_apply, fail) :-
    subject_profile(repeat_not_listed, Profile),
    article_5_application_status(Profile, article_5_obligations_apply, _, _).
test(document_evidence_is_not_apply, fail) :-
    Profile = [attribute(designated_as_gatekeeper_for_core_platform_service, attested(false, attestation(host_operator, attested_on_2026_11_19, not_listed, document(upload_0001, sha256_of_the_designation_decision))))],
    article_5_application_status(Profile, article_5_obligations_apply, _, _).
test(provenance_is_not_part_of_the_scored_context, fail) :-
    article_5_application_status([], needs_legal_review(_, Context), [], []),
    member(provenance(_, _), Context).
test(day_before_anniversary_second_repeat_is_not_permitted, fail) :-
    repetition(repeat_listed_already_repeated, date(2025, 3, 10), date(2026, 3, 9), repeated_request_permitted, _, _).
test(anniversary_day_is_not_not_permitted, fail) :-
    repetition(repeat_listed_already_repeated, date(2025, 3, 10), date(2026, 3, 10), repeated_request_not_permitted, _, _).
test(what_if_consent_given_is_not_prohibited, fail) :-
    subject_profile(listed_combining_consent_refused_control, Profile),
    stated(true, Consent),
    dma_art_5_2_data_combination_order_what_if(Profile, end_user_consent_given, Consent, practice_prohibited).

cp_test_names([every_subject_has_an_expected_status, every_subject_resolves_to_its_expected_status_once, every_subject_is_assessed_to_its_expected_status_once, every_subject_has_a_non_empty_checklist, every_subject_is_resolvable, every_near_miss_control_gets_another_status, final_statuses_are_in_the_status_vocabulary, allowed_with_consent_basis_and_citations, consent_refused_control_is_prohibited, other_legal_basis_cites_point_c, prohibited_basis_omits_the_consent_statement, point_a_is_cited_for_advertising, outside_article_5_2_citations, not_listed_whatever_else, not_final_answers_have_no_basis_or_citations, facade_status_projection, checklist_items_carry_citations, checklist_marks_an_absent_key_unknown, application_listed, application_not_listed, application_designation_absent_is_referred, application_input_problems, application_has_one_answer, url_evidence_is_copied_into_the_basis, url_evidence_with_an_unbound_part_is_wrong_type, document_evidence_is_copied_into_the_basis, document_evidence_on_consent_reaches_the_practice_basis, provenance_is_an_optional_trailing_context_element, refusal_day_itself_is_within_the_period, day_before_anniversary_first_repeat_permitted, day_before_anniversary_second_repeat_not_permitted, anniversary_day_is_after_the_period, leap_day_refusal_day_before_28_february_is_within, leap_day_refusal_28_february_is_after, year_9999_refusal_keeps_the_request_within, repetition_not_listed, repetition_designation_absent_is_referred, repetition_crisp_key_absent_is_named, repetition_crisp_key_absent_after_the_period_is_final, request_before_refusal_is_wrong_type, impossible_refusal_day_is_wrong_type, leap_refusal_day_is_a_day, month_13_request_is_wrong_type, profile_problems_come_before_date_problems, repetition_has_one_answer, input_check_well_formed_profile, input_check_duplicate_then_unknown, input_check_unbound_reason, input_check_partial_list, input_check_crisp_unsure_is_wrong_type, input_check_has_one_answer, what_if_consent_given_flips_to_allowed, what_if_adding_the_practice_names_the_choice]).
cp_test_fail_names([consent_refused_control_is_not_allowed_with_consent, no_basis_control_is_not_allowed_on_other_basis, application_not_listed_is_not_apply, document_evidence_is_not_apply, provenance_is_not_part_of_the_scored_context, day_before_anniversary_second_repeat_is_not_permitted, anniversary_day_is_not_not_permitted, what_if_consent_given_is_not_prohibited]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
