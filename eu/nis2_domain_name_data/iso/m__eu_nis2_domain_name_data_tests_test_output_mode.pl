% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_nis2_domain_name_data_nis2_domain_name_data, [decide_nis2_domain_name_data/2, nis2_domain_name_data_checklist/2, provider_duties/2, required_registration_data/2, publication_duty/3, access_duty/3, access_reply_timeliness/3]).
:- use_module(m__eu_nis2_domain_name_data_fixtures, [nis2_domain_name_data_profile_for/2, nis2_domain_name_data_hours_for/2]).

expected_duties([duty(collect_and_maintain_accurate_and_complete_registration_data, cite(eu_dir_2022_2555_art_28_1)), duty(hold_the_information_identifying_and_contacting_the_holders_and_points_of_contact, cite(eu_dir_2022_2555_art_28_2)), duty(have_policies_and_verification_procedures_for_accurate_and_complete_data, cite(eu_dir_2022_2555_art_28_3)), duty(make_the_accuracy_policies_and_procedures_publicly_available, cite(eu_dir_2022_2555_art_28_3)), duty(make_non_personal_registration_data_publicly_available, cite(eu_dir_2022_2555_art_28_4)), duty(provide_access_to_specific_registration_data_on_lawful_and_substantiated_requests, cite(eu_dir_2022_2555_art_28_5)), duty(reply_to_access_requests_within_72_hours, cite(eu_dir_2022_2555_art_28_5)), duty(make_the_disclosure_policies_and_procedures_publicly_available, cite(eu_dir_2022_2555_art_28_5)), duty(cooperate_to_avoid_duplicate_collection_of_registration_data, cite(eu_dir_2022_2555_art_28_6))]).

registrant_fields([field(domain_name, cite(eu_dir_2022_2555_art_28_2_a)), field(date_of_registration, cite(eu_dir_2022_2555_art_28_2_b)), field(registrant_name, cite(eu_dir_2022_2555_art_28_2_c)), field(registrant_contact_email_address, cite(eu_dir_2022_2555_art_28_2_c)), field(registrant_telephone_number, cite(eu_dir_2022_2555_art_28_2_c))]).

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

subject_reply(Subject, Answers) :-
    nis2_domain_name_data_profile_for(Subject, Profile),
    nis2_domain_name_data_hours_for(Subject, HoursElapsed),
    findall(Result, access_reply_timeliness(Profile, HoursElapsed, Result), Answers).

subject_verdict(Subject, Answers) :-
    nis2_domain_name_data_profile_for(Subject, Profile),
    findall(Verdict, decide_nis2_domain_name_data(Profile, Verdict), Answers).

test(a_registry_yields_the_nine_duties_once_in_order) :-
    expected_duties(Duties),
    subject_duties(registry_full_profile, Answers),
    Answers == [Duties].
test(a_registrar_entity_yields_the_nine_duties_once_in_order) :-
    expected_duties(Duties),
    subject_duties(registrar_entity_profile, Answers),
    Answers == [Duties].
test(another_entity_yields_the_empty_list_once) :-
    subject_duties(other_entity, Answers),
    Answers == [[]].
test(an_absent_provider_type_yields_indeterminate_once) :-
    subject_duties(provider_type_absent, Answers),
    Answers == [indeterminate([provider_type])].
test(a_point_of_contact_like_the_registrant_adds_nothing) :-
    registrant_fields(Fields),
    subject_fields(point_of_contact_same, Answers),
    Answers == [Fields].
test(a_differing_email_adds_only_the_email) :-
    registrant_fields(RegistrantFields),
    append(RegistrantFields, [field(point_of_contact_contact_email_address, cite(eu_dir_2022_2555_art_28_2_d))], Fields),
    subject_fields(point_of_contact_email_differs_only, Answers),
    Answers == [Fields].
test(a_differing_telephone_adds_only_the_telephone) :-
    registrant_fields(RegistrantFields),
    append(RegistrantFields, [field(point_of_contact_telephone_number, cite(eu_dir_2022_2555_art_28_2_d))], Fields),
    subject_fields(point_of_contact_telephone_differs_only, Answers),
    Answers == [Fields].
test(both_differing_add_the_email_then_the_telephone) :-
    registrant_fields(RegistrantFields),
    append(RegistrantFields, [field(point_of_contact_contact_email_address, cite(eu_dir_2022_2555_art_28_2_d)), field(point_of_contact_telephone_number, cite(eu_dir_2022_2555_art_28_2_d))], Fields),
    subject_fields(registry_full_profile, Answers),
    Answers == [Fields].
test(an_absent_telephone_key_is_named_once) :-
    subject_fields(point_of_contact_telephone_absent, Answers),
    Answers == [indeterminate([point_of_contact_telephone_number_differs_from_registrant])].
test(the_email_key_is_named_before_the_telephone_key) :-
    subject_fields(other_entity, Answers),
    Answers == [indeterminate([point_of_contact_email_address_differs_from_registrant])].
test(non_personal_data_must_be_published_once) :-
    subject_publication(non_personal_data, Answers),
    Answers == [must_publish_without_undue_delay - [cite(eu_dir_2022_2555_art_28_4)]].
test(personal_data_carry_no_publication_duty_once) :-
    subject_publication(personal_data, Answers),
    Answers == [no_publication_duty - [cite(eu_dir_2022_2555_art_28_4)]].
test(an_unsure_personal_data_judgement_is_referred_once) :-
    subject_publication(personal_data_unsure, Answers),
    Answers == [needs_legal_review(open_textured(registration_data_is_personal_data, cite(eu_dir_2022_2555_art_28_4)), [inputs_relied_on([registration_data_is_personal_data - unsure])]) - []].
test(an_absent_personal_data_judgement_is_asked_for_once) :-
    subject_publication(personal_data_absent, Answers),
    Answers == [indeterminate([registration_data_is_personal_data]) - []].
test(both_conditions_met_give_access_once) :-
    subject_access(access_both_true, Answers),
    Answers == [must_provide_access - [cite(eu_dir_2022_2555_art_28_5)]].
test(a_false_seeker_settles_no_duty_once) :-
    subject_access(access_seeker_false_lawful_true, Answers),
    Answers == [no_duty_to_provide_access - [cite(eu_dir_2022_2555_art_28_5)]].
test(a_false_request_settles_no_duty_beside_an_unsure_seeker) :-
    subject_access(access_lawful_false_seeker_unsure, Answers),
    Answers == [no_duty_to_provide_access - [cite(eu_dir_2022_2555_art_28_5)]].
test(an_absent_request_key_beside_an_unsure_seeker_is_named) :-
    subject_access(access_seeker_unsure_lawful_absent, Answers),
    Answers == [indeterminate([request_is_lawful_and_duly_substantiated]) - []].
test(an_absent_seeker_key_beside_an_unsure_request_is_named) :-
    subject_access(access_seeker_absent_lawful_unsure, Answers),
    Answers == [indeterminate([requester_is_legitimate_access_seeker]) - []].
test(both_unsure_refer_the_seeker_key_with_both_pairs) :-
    subject_access(access_both_unsure, Answers),
    Answers == [needs_legal_review(open_textured(requester_is_legitimate_access_seeker, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on([requester_is_legitimate_access_seeker - unsure, request_is_lawful_and_duly_substantiated - unsure])]) - []].
test(an_unsure_request_beside_a_true_seeker_is_referred) :-
    subject_access(access_seeker_true_lawful_unsure, Answers),
    Answers == [needs_legal_review(open_textured(request_is_lawful_and_duly_substantiated, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on([requester_is_legitimate_access_seeker - true, request_is_lawful_and_duly_substantiated - unsure])]) - []].
test(zero_hours_without_undue_delay_is_on_time) :-
    subject_reply(reply_zero_hours_on_time, Answers),
    Answers == [on_time].
test(seventy_two_hours_without_undue_delay_is_on_time) :-
    subject_reply(reply_72_hours_on_time, Answers),
    Answers == [on_time].
test(seventy_three_hours_without_undue_delay_is_late) :-
    subject_reply(reply_73_hours_late, Answers),
    Answers == [late(hour_limit)].
test(seventy_two_hours_with_undue_delay_is_late_for_delay) :-
    subject_reply(reply_72_hours_undue_delay, Answers),
    Answers == [late(without_undue_delay)].
test(seventy_three_hours_with_undue_delay_is_late_for_the_limit) :-
    subject_reply(reply_73_hours_undue_delay, Answers),
    Answers == [late(hour_limit)].
test(seventy_two_hours_unsure_is_referred) :-
    subject_reply(reply_72_hours_unsure, Answers),
    Answers == [needs_legal_review(open_textured(reply_without_undue_delay, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on([reply_without_undue_delay - unsure])])].
test(seventy_three_hours_unsure_is_late_never_referred) :-
    subject_reply(reply_73_hours_unsure, Answers),
    Answers == [late(hour_limit)].
test(seventy_two_hours_without_the_judgement_is_asked_for) :-
    subject_reply(reply_72_hours_judgement_absent, Answers),
    Answers == [indeterminate([reply_without_undue_delay])].
test(seventy_three_hours_without_the_judgement_is_late) :-
    subject_reply(reply_73_hours_judgement_absent, Answers),
    Answers == [late(hour_limit)].
test(the_registry_verdict_carries_the_six_paragraph_citations) :-
    subject_verdict(registry_full_profile, Answers),
    Answers == [nis2_domain_name_data_verdict(addressed_provider, [cite(eu_dir_2022_2555_art_28_1), cite(eu_dir_2022_2555_art_28_2), cite(eu_dir_2022_2555_art_28_3), cite(eu_dir_2022_2555_art_28_4), cite(eu_dir_2022_2555_art_28_5), cite(eu_dir_2022_2555_art_28_6)])].
test(another_entity_is_not_addressed_once) :-
    subject_verdict(other_entity, Answers),
    Answers == [nis2_domain_name_data_verdict(not_addressed_provider, [cite(eu_dir_2022_2555_art_28_1)])].
test(an_absent_provider_type_verdict_is_indeterminate) :-
    subject_verdict(provider_type_absent, Answers),
    Answers == [nis2_domain_name_data_verdict(indeterminate([provider_type]), [])].
test(a_duplicate_key_verdict_is_input_problems) :-
    subject_verdict(duplicate_key_profile, Answers),
    Answers == [nis2_domain_name_data_verdict(input_problems([duplicate_key(provider_type)]), [])].
test(the_registry_checklist_has_one_cited_row_per_duty) :-
    nis2_domain_name_data_profile_for(registry_full_profile, Profile),
    findall(Items, nis2_domain_name_data_checklist(Profile, Items), [Items]),
    length(Items, 10),
    findall(Citation, member(item(_, _, cite(Citation)), Items), Citations),
    length(Citations, 10).
test(another_entity_checklist_marks_the_duties_inapplicable) :-
    nis2_domain_name_data_profile_for(other_entity, Profile),
    nis2_domain_name_data_checklist(Profile, [item(provider_addressed, unmet(not_addressed_provider), cite(eu_dir_2022_2555_art_28_1)), item(collect_and_maintain_accurate_and_complete_registration_data, inapplicable, cite(eu_dir_2022_2555_art_28_1))|_]).

cp_test_names([a_registry_yields_the_nine_duties_once_in_order, a_registrar_entity_yields_the_nine_duties_once_in_order, another_entity_yields_the_empty_list_once, an_absent_provider_type_yields_indeterminate_once, a_point_of_contact_like_the_registrant_adds_nothing, a_differing_email_adds_only_the_email, a_differing_telephone_adds_only_the_telephone, both_differing_add_the_email_then_the_telephone, an_absent_telephone_key_is_named_once, the_email_key_is_named_before_the_telephone_key, non_personal_data_must_be_published_once, personal_data_carry_no_publication_duty_once, an_unsure_personal_data_judgement_is_referred_once, an_absent_personal_data_judgement_is_asked_for_once, both_conditions_met_give_access_once, a_false_seeker_settles_no_duty_once, a_false_request_settles_no_duty_beside_an_unsure_seeker, an_absent_request_key_beside_an_unsure_seeker_is_named, an_absent_seeker_key_beside_an_unsure_request_is_named, both_unsure_refer_the_seeker_key_with_both_pairs, an_unsure_request_beside_a_true_seeker_is_referred, zero_hours_without_undue_delay_is_on_time, seventy_two_hours_without_undue_delay_is_on_time, seventy_three_hours_without_undue_delay_is_late, seventy_two_hours_with_undue_delay_is_late_for_delay, seventy_three_hours_with_undue_delay_is_late_for_the_limit, seventy_two_hours_unsure_is_referred, seventy_three_hours_unsure_is_late_never_referred, seventy_two_hours_without_the_judgement_is_asked_for, seventy_three_hours_without_the_judgement_is_late, the_registry_verdict_carries_the_six_paragraph_citations, another_entity_is_not_addressed_once, an_absent_provider_type_verdict_is_indeterminate, a_duplicate_key_verdict_is_input_problems, the_registry_checklist_has_one_cited_row_per_duty, another_entity_checklist_marks_the_duties_inapplicable]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
