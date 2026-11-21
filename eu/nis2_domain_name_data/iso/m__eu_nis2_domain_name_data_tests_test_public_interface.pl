% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_domain_name_data_nis2_domain_name_data, [decide_nis2_domain_name_data/2, nis2_domain_name_data_status/2, nis2_domain_name_data_checklist/2, nis2_domain_name_data_decision_resolvable/1, nis2_domain_name_data_status_values/1, provider_duties/2, required_registration_data/2, publication_duty/3, access_duty/3, access_reply_timeliness/3]).
:- use_module(m__eu_nis2_domain_name_data_fixtures, [nis2_domain_name_data_subject/1, nis2_domain_name_data_profile_for/2, nis2_domain_name_data_assess/2]).
:- use_module(m__eu_nis2_domain_name_data_kernel, [nis2_domain_name_data_input_problems/2]).
:- use_module(m__eu_nis2_domain_name_data_queries, [provenance/2]).
:- use_module(m__eu_nis2_domain_name_data_fixtures, [nis2_domain_name_data_hours_for/2]).
:- use_module(m__eu_nis2_domain_name_data_queries, [nis2_domain_name_data_reply_deadline/2, nis2_domain_name_data_hours_elapsed/3]).
:- use_module(clausal_datetime, [datetime/7]).

expected_status(registry_full_profile, addressed_provider).
expected_status(registrar_entity_profile, addressed_provider).
expected_status(other_entity, not_addressed_provider).
expected_status(provider_type_absent, indeterminate([provider_type])).
expected_status(point_of_contact_same, addressed_provider).
expected_status(point_of_contact_email_differs_only, addressed_provider).
expected_status(point_of_contact_telephone_differs_only, addressed_provider).
expected_status(point_of_contact_telephone_absent, addressed_provider).
expected_status(non_personal_data, addressed_provider).
expected_status(personal_data, addressed_provider).
expected_status(personal_data_unsure, addressed_provider).
expected_status(personal_data_absent, addressed_provider).
expected_status(access_both_true, addressed_provider).
expected_status(access_seeker_false_lawful_true, addressed_provider).
expected_status(access_lawful_false_seeker_unsure, addressed_provider).
expected_status(access_seeker_unsure_lawful_absent, addressed_provider).
expected_status(access_seeker_absent_lawful_unsure, addressed_provider).
expected_status(access_both_unsure, addressed_provider).
expected_status(access_seeker_true_lawful_unsure, addressed_provider).
expected_status(reply_zero_hours_on_time, addressed_provider).
expected_status(reply_72_hours_on_time, addressed_provider).
expected_status(reply_73_hours_late, addressed_provider).
expected_status(reply_72_hours_undue_delay, addressed_provider).
expected_status(reply_73_hours_undue_delay, addressed_provider).
expected_status(reply_72_hours_unsure, addressed_provider).
expected_status(reply_73_hours_unsure, addressed_provider).
expected_status(reply_72_hours_judgement_absent, addressed_provider).
expected_status(reply_73_hours_judgement_absent, addressed_provider).
expected_status(duplicate_key_profile, input_problems([duplicate_key(provider_type)])).
expected_status(unknown_key_profile, input_problems([unknown_key(colour)])).
expected_status(wrong_type_profile, input_problems([wrong_type(point_of_contact_email_address_differs_from_registrant)])).
expected_status(not_attribute_list, input_problems([wrong_type(profile)])).

expected_reply(reply_zero_hours_on_time, on_time).
expected_reply(reply_72_hours_on_time, on_time).
expected_reply(reply_73_hours_late, late(hour_limit)).
expected_reply(reply_72_hours_undue_delay, late(without_undue_delay)).
expected_reply(reply_73_hours_undue_delay, late(hour_limit)).
expected_reply(reply_72_hours_unsure, needs_legal_review(open_textured(reply_without_undue_delay, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on([reply_without_undue_delay - unsure])])).
expected_reply(reply_73_hours_unsure, late(hour_limit)).
expected_reply(reply_72_hours_judgement_absent, indeterminate([reply_without_undue_delay])).
expected_reply(reply_73_hours_judgement_absent, late(hour_limit)).

resolves_to_expected(Subject) :-
    expected_status(Subject, Expected),
    nis2_domain_name_data_profile_for(Subject, Profile),
    findall(Status, nis2_domain_name_data_status(Profile, Status), Statuses),
    Statuses == [Expected].

assesses_to_expected(Subject) :-
    expected_status(Subject, Expected),
    findall(Status, nis2_domain_name_data_assess(Subject, nis2_domain_name_data_verdict(Status, _)), Statuses),
    Statuses == [Expected].

has_cited_checklist(Subject) :-
    nis2_domain_name_data_profile_for(Subject, Profile),
    findall(Checklist, nis2_domain_name_data_checklist(Profile, Checklist), [Checklist]),
    Checklist = [_|_],
    maplist(cited_item, Checklist).

cited_item(item(_, _, cite(CitationKey))) :-
    atom(CitationKey).

reply_matches(Subject) :-
    expected_reply(Subject, Expected),
    nis2_domain_name_data_profile_for(Subject, Profile),
    nis2_domain_name_data_hours_for(Subject, Hours),
    findall(Result, access_reply_timeliness(Profile, Hours, Result), Results),
    Results == [Expected].

subject_duties(Subject, Answers) :-
    nis2_domain_name_data_profile_for(Subject, Profile),
    findall(Duties, provider_duties(Profile, Duties), Answers).

subject_fields(Subject, Answers) :-
    nis2_domain_name_data_profile_for(Subject, Profile),
    findall(Fields, required_registration_data(Profile, Fields), Answers).

subject_publication(Subject, Answers) :-
    nis2_domain_name_data_profile_for(Subject, Profile),
    findall(Result - Citations, publication_duty(Profile, Result, Citations), Answers).

subject_access(Subject, Answers) :-
    nis2_domain_name_data_profile_for(Subject, Profile),
    findall(Result - Citations, access_duty(Profile, Result, Citations), Answers).

subject_problems(Subject, Answers) :-
    nis2_domain_name_data_profile_for(Subject, Profile),
    findall(Problems, nis2_domain_name_data_input_problems(Profile, Problems), Answers).

nine_duties([duty(collect_and_maintain_accurate_and_complete_registration_data, cite(eu_dir_2022_2555_art_28_1)), duty(hold_the_information_identifying_and_contacting_the_holders_and_points_of_contact, cite(eu_dir_2022_2555_art_28_2)), duty(have_policies_and_verification_procedures_for_accurate_and_complete_data, cite(eu_dir_2022_2555_art_28_3)), duty(make_the_accuracy_policies_and_procedures_publicly_available, cite(eu_dir_2022_2555_art_28_3)), duty(make_non_personal_registration_data_publicly_available, cite(eu_dir_2022_2555_art_28_4)), duty(provide_access_to_specific_registration_data_on_lawful_and_substantiated_requests, cite(eu_dir_2022_2555_art_28_5)), duty(reply_to_access_requests_within_72_hours, cite(eu_dir_2022_2555_art_28_5)), duty(make_the_disclosure_policies_and_procedures_publicly_available, cite(eu_dir_2022_2555_art_28_5)), duty(cooperate_to_avoid_duplicate_collection_of_registration_data, cite(eu_dir_2022_2555_art_28_6))]).

base_fields([field(domain_name, cite(eu_dir_2022_2555_art_28_2_a)), field(date_of_registration, cite(eu_dir_2022_2555_art_28_2_b)), field(registrant_name, cite(eu_dir_2022_2555_art_28_2_c)), field(registrant_contact_email_address, cite(eu_dir_2022_2555_art_28_2_c)), field(registrant_telephone_number, cite(eu_dir_2022_2555_art_28_2_c))]).

test(every_subject_resolves_once_to_its_expected_status) :-
    findall(Subject, nis2_domain_name_data_subject(Subject), Subjects),
    Subjects = [_|_],
    maplist(resolves_to_expected, Subjects).
test(every_subject_assesses_once_through_the_wrapper) :-
    findall(Subject, nis2_domain_name_data_subject(Subject), Subjects),
    maplist(assesses_to_expected, Subjects).
test(every_subject_has_a_non_empty_cited_checklist) :-
    findall(Subject, nis2_domain_name_data_subject(Subject), Subjects),
    maplist(has_cited_checklist, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, nis2_domain_name_data_subject(Subject), Subjects),
    maplist(subject_resolvable, Subjects).
test(the_status_values_are_the_two_final_atoms) :-
    nis2_domain_name_data_status_values(StatusValues),
    StatusValues == [addressed_provider, not_addressed_provider].
test(an_addressed_provider_verdict_cites_article_28) :-
    nis2_domain_name_data_profile_for(registry_full_profile, Profile),
    decide_nis2_domain_name_data(Profile, nis2_domain_name_data_verdict(addressed_provider, Citations)),
    member(cite(eu_dir_2022_2555_art_28_5), Citations).
test(a_registry_has_the_nine_duties_in_article_order) :-
    nine_duties(Expected),
    subject_duties(registry_full_profile, Answers),
    Answers == [Expected].
test(a_registrar_entity_has_the_nine_duties_in_article_order) :-
    nine_duties(Expected),
    subject_duties(registrar_entity_profile, Answers),
    Answers == [Expected].
test(another_entity_has_no_duty) :-
    subject_duties(other_entity, Answers),
    Answers == [[]].
test(an_absent_provider_type_is_asked_for) :-
    subject_duties(provider_type_absent, Answers),
    Answers == [indeterminate([provider_type])].
test(a_duplicate_key_gives_input_problems_for_duties) :-
    subject_duties(duplicate_key_profile, Answers),
    Answers == [input_problems([duplicate_key(provider_type)])].
test(both_points_of_contact_differing_add_seven_fields) :-
    base_fields(BaseFields),
    append(BaseFields, [field(point_of_contact_contact_email_address, cite(eu_dir_2022_2555_art_28_2_d)), field(point_of_contact_telephone_number, cite(eu_dir_2022_2555_art_28_2_d))], Expected),
    subject_fields(registry_full_profile, Answers),
    Answers == [Expected].
test(a_same_point_of_contact_gives_five_fields) :-
    base_fields(Expected),
    subject_fields(point_of_contact_same, Answers),
    Answers == [Expected].
test(a_differing_email_alone_adds_only_the_email) :-
    base_fields(BaseFields),
    append(BaseFields, [field(point_of_contact_contact_email_address, cite(eu_dir_2022_2555_art_28_2_d))], Expected),
    subject_fields(point_of_contact_email_differs_only, Answers),
    Answers == [Expected].
test(a_differing_telephone_alone_adds_only_the_telephone) :-
    base_fields(BaseFields),
    append(BaseFields, [field(point_of_contact_telephone_number, cite(eu_dir_2022_2555_art_28_2_d))], Expected),
    subject_fields(point_of_contact_telephone_differs_only, Answers),
    Answers == [Expected].
test(the_email_key_is_named_first) :-
    subject_fields(provider_type_absent, Answers),
    Answers == [indeterminate([point_of_contact_email_address_differs_from_registrant])].
test(then_the_telephone_key_is_named) :-
    subject_fields(point_of_contact_telephone_absent, Answers),
    Answers == [indeterminate([point_of_contact_telephone_number_differs_from_registrant])].
test(non_personal_data_must_be_published) :-
    subject_publication(non_personal_data, Answers),
    Answers == [must_publish_without_undue_delay - [cite(eu_dir_2022_2555_art_28_4)]].
test(personal_data_carry_no_publication_duty) :-
    subject_publication(personal_data, Answers),
    Answers == [no_publication_duty - [cite(eu_dir_2022_2555_art_28_4)]].
test(an_unsure_personal_data_judgement_is_referred) :-
    subject_publication(personal_data_unsure, Answers),
    Answers == [needs_legal_review(open_textured(registration_data_is_personal_data, cite(eu_dir_2022_2555_art_28_4)), [inputs_relied_on([registration_data_is_personal_data - unsure])]) - []].
test(an_absent_personal_data_judgement_is_asked_for) :-
    subject_publication(personal_data_absent, Answers),
    Answers == [indeterminate([registration_data_is_personal_data]) - []].
test(an_input_problem_blocks_publication) :-
    subject_publication(wrong_type_profile, Answers),
    Answers == [input_problems([wrong_type(point_of_contact_email_address_differs_from_registrant)]) - []].
test(both_conditions_met_give_access) :-
    subject_access(access_both_true, Answers),
    Answers == [must_provide_access - [cite(eu_dir_2022_2555_art_28_5)]].
test(a_false_seeker_gives_no_duty_to_provide_access) :-
    subject_access(access_seeker_false_lawful_true, Answers),
    Answers == [no_duty_to_provide_access - [cite(eu_dir_2022_2555_art_28_5)]].
test(a_false_request_settles_beside_an_unsure_seeker) :-
    subject_access(access_lawful_false_seeker_unsure, Answers),
    Answers == [no_duty_to_provide_access - [cite(eu_dir_2022_2555_art_28_5)]].
test(an_absent_request_beside_an_unsure_seeker_is_named) :-
    subject_access(access_seeker_unsure_lawful_absent, Answers),
    Answers == [indeterminate([request_is_lawful_and_duly_substantiated]) - []].
test(an_absent_seeker_beside_an_unsure_request_is_named) :-
    subject_access(access_seeker_absent_lawful_unsure, Answers),
    Answers == [indeterminate([requester_is_legitimate_access_seeker]) - []].
test(both_unsure_refer_on_the_seeker_with_both_pairs) :-
    subject_access(access_both_unsure, Answers),
    Answers == [needs_legal_review(open_textured(requester_is_legitimate_access_seeker, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on([requester_is_legitimate_access_seeker - unsure, request_is_lawful_and_duly_substantiated - unsure])]) - []].
test(an_unsure_request_beside_a_true_seeker_is_referred) :-
    subject_access(access_seeker_true_lawful_unsure, Answers),
    Answers == [needs_legal_review(open_textured(request_is_lawful_and_duly_substantiated, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on([requester_is_legitimate_access_seeker - true, request_is_lawful_and_duly_substantiated - unsure])]) - []].
test(every_reply_subject_gets_its_expected_result_once) :-
    findall(Subject, nis2_domain_name_data_hours_for(Subject, _), Subjects),
    Subjects = [_|_],
    maplist(reply_matches, Subjects).
test(seventy_two_hours_is_on_time) :-
    nis2_domain_name_data_profile_for(reply_72_hours_on_time, Profile),
    access_reply_timeliness(Profile, 72, on_time).
test(seventy_three_hours_is_late_on_the_hour_limit) :-
    nis2_domain_name_data_profile_for(reply_73_hours_late, Profile),
    access_reply_timeliness(Profile, 73, late(hour_limit)).
test(a_bad_profile_and_a_negative_hour_count) :-
    nis2_domain_name_data_profile_for(not_attribute_list, Profile),
    findall(Result, access_reply_timeliness(Profile, -1, Result), Results),
    Results == [input_problems([wrong_type(profile), wrong_type(hours_elapsed)])].
test(the_deadline_is_seventy_two_hours_after_receipt) :-
    datetime(2026, 3, 2, 9, 0, 0, Receipt),
    findall(Deadline, nis2_domain_name_data_reply_deadline(Receipt, Deadline), [Deadline]),
    nis2_domain_name_data_hours_elapsed(Receipt, Deadline, 72).
test(seventy_two_hours_thirty_minutes_counts_as_seventy_three) :-
    datetime(2026, 3, 2, 9, 0, 0, Receipt),
    datetime(2026, 3, 5, 9, 30, 0, Reply),
    nis2_domain_name_data_hours_elapsed(Receipt, Reply, 73).
test(exactly_seventy_two_hours_counts_as_seventy_two) :-
    datetime(2026, 3, 2, 9, 0, 0, Receipt),
    datetime(2026, 3, 5, 9, 0, 0, Reply),
    nis2_domain_name_data_hours_elapsed(Receipt, Reply, 72).
test(a_reply_half_an_hour_past_the_deadline_is_late) :-
    datetime(2026, 3, 2, 9, 0, 0, Receipt),
    datetime(2026, 3, 5, 9, 30, 0, Reply),
    nis2_domain_name_data_hours_elapsed(Receipt, Reply, Hours),
    nis2_domain_name_data_profile_for(reply_73_hours_late, Profile),
    access_reply_timeliness(Profile, Hours, late(hour_limit)).
test(a_well_formed_profile_has_no_problem) :-
    subject_problems(registry_full_profile, Answers),
    Answers == [[]].
test(a_duplicate_key_is_named_once) :-
    subject_problems(duplicate_key_profile, Answers),
    Answers == [[duplicate_key(provider_type)]].
test(an_unknown_key_is_named_once) :-
    subject_problems(unknown_key_profile, Answers),
    Answers == [[unknown_key(colour)]].
test(a_crisp_key_given_unsure_is_a_wrong_type) :-
    subject_problems(wrong_type_profile, Answers),
    Answers == [[wrong_type(point_of_contact_email_address_differs_from_registrant)]].
test(the_near_miss_crisp_key_is_well_formed) :-
    subject_problems(point_of_contact_email_differs_only, Answers),
    Answers == [[]].
test(a_non_attribute_list_is_a_wrong_type_profile) :-
    subject_problems(not_attribute_list, Answers),
    Answers == [[wrong_type(profile)]].
test(a_provenance_item_with_a_clause_and_citations_is_well_formed) :-
    findall(well_formed, provenance(access_reply_timeliness_step_15, [cite(eu_dir_2022_2555_art_28_5)]), Answers),
    Answers == [well_formed].
test(a_provenance_item_with_no_citations_is_well_formed) :-
    provenance(publication_duty_step_7, []).
test(a_referral_context_may_carry_a_provenance_item) :-
    Context = [inputs_relied_on([reply_without_undue_delay - unsure]), provenance(access_reply_timeliness_step_15, [cite(eu_dir_2022_2555_art_28_5)])],
    Context = [_, provenance(DecidingClause, Citations)],
    provenance(DecidingClause, Citations).

subject_resolvable(Subject) :-
    nis2_domain_name_data_profile_for(Subject, Profile),
    nis2_domain_name_data_decision_resolvable(Profile).

test(another_entity_is_not_an_addressed_provider, fail) :-
    nis2_domain_name_data_profile_for(other_entity, Profile),
    nis2_domain_name_data_status(Profile, addressed_provider).
test(a_registry_is_not_a_not_addressed_provider, fail) :-
    nis2_domain_name_data_profile_for(registry_full_profile, Profile),
    nis2_domain_name_data_status(Profile, not_addressed_provider).
test(personal_data_are_not_must_publish, fail) :-
    nis2_domain_name_data_profile_for(personal_data, Profile),
    publication_duty(Profile, must_publish_without_undue_delay, _).
test(a_false_seeker_is_not_given_access, fail) :-
    nis2_domain_name_data_profile_for(access_seeker_false_lawful_true, Profile),
    access_duty(Profile, must_provide_access, _).
test(seventy_three_hours_is_not_on_time, fail) :-
    nis2_domain_name_data_profile_for(reply_73_hours_late, Profile),
    access_reply_timeliness(Profile, 73, on_time).
test(seventy_two_hours_is_not_late_on_the_hour_limit, fail) :-
    nis2_domain_name_data_profile_for(reply_72_hours_on_time, Profile),
    access_reply_timeliness(Profile, 72, late(hour_limit)).
test(a_reply_before_receipt_has_no_hour_count, fail) :-
    datetime(2026, 3, 2, 9, 0, 0, Receipt),
    datetime(2026, 3, 1, 9, 0, 0, Reply),
    nis2_domain_name_data_hours_elapsed(Receipt, Reply, _).
test(a_provenance_item_whose_citations_are_not_a_list_is_refused, fail) :-
    provenance(access_reply_timeliness_step_15, eu_dir_2022_2555_art_28_5).
test(a_provenance_item_whose_clause_is_not_an_atom_is_refused, fail) :-
    provenance(step(15), [cite(eu_dir_2022_2555_art_28_5)]).

cp_test_names([every_subject_resolves_once_to_its_expected_status, every_subject_assesses_once_through_the_wrapper, every_subject_has_a_non_empty_cited_checklist, every_subject_is_resolvable, the_status_values_are_the_two_final_atoms, an_addressed_provider_verdict_cites_article_28, a_registry_has_the_nine_duties_in_article_order, a_registrar_entity_has_the_nine_duties_in_article_order, another_entity_has_no_duty, an_absent_provider_type_is_asked_for, a_duplicate_key_gives_input_problems_for_duties, both_points_of_contact_differing_add_seven_fields, a_same_point_of_contact_gives_five_fields, a_differing_email_alone_adds_only_the_email, a_differing_telephone_alone_adds_only_the_telephone, the_email_key_is_named_first, then_the_telephone_key_is_named, non_personal_data_must_be_published, personal_data_carry_no_publication_duty, an_unsure_personal_data_judgement_is_referred, an_absent_personal_data_judgement_is_asked_for, an_input_problem_blocks_publication, both_conditions_met_give_access, a_false_seeker_gives_no_duty_to_provide_access, a_false_request_settles_beside_an_unsure_seeker, an_absent_request_beside_an_unsure_seeker_is_named, an_absent_seeker_beside_an_unsure_request_is_named, both_unsure_refer_on_the_seeker_with_both_pairs, an_unsure_request_beside_a_true_seeker_is_referred, every_reply_subject_gets_its_expected_result_once, seventy_two_hours_is_on_time, seventy_three_hours_is_late_on_the_hour_limit, a_bad_profile_and_a_negative_hour_count, the_deadline_is_seventy_two_hours_after_receipt, seventy_two_hours_thirty_minutes_counts_as_seventy_three, exactly_seventy_two_hours_counts_as_seventy_two, a_reply_half_an_hour_past_the_deadline_is_late, a_well_formed_profile_has_no_problem, a_duplicate_key_is_named_once, an_unknown_key_is_named_once, a_crisp_key_given_unsure_is_a_wrong_type, the_near_miss_crisp_key_is_well_formed, a_non_attribute_list_is_a_wrong_type_profile, a_provenance_item_with_a_clause_and_citations_is_well_formed, a_provenance_item_with_no_citations_is_well_formed, a_referral_context_may_carry_a_provenance_item]).
cp_test_fail_names([another_entity_is_not_an_addressed_provider, a_registry_is_not_a_not_addressed_provider, personal_data_are_not_must_publish, a_false_seeker_is_not_given_access, seventy_three_hours_is_not_on_time, seventy_two_hours_is_not_late_on_the_hour_limit, a_reply_before_receipt_has_no_hour_count, a_provenance_item_whose_citations_are_not_a_list_is_refused, a_provenance_item_whose_clause_is_not_an_atom_is_refused]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
