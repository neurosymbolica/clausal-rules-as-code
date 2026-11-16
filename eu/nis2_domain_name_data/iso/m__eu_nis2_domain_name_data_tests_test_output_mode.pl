% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_nis2_domain_name_data_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [last/2]).
:- use_module(m__eu_nis2_domain_name_data_nis2_domain_name_data, [decide_nis2_domain_name_data/2, nis2_domain_name_data_status/2, nis2_domain_name_data_checklist/2, provider_duties/2, required_registration_data/2, publication_duty/3, access_duty/3, access_reply_timeliness/3]).
:- use_module(m__eu_nis2_domain_name_data_fixtures, [nis2_domain_name_data_profile_for/2]).

test(the_registry_profile_yields_exactly_one_status) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    findall(Status, nis2_domain_name_data_status(Profile, Status), Statuses),
    Statuses == [eligible].
test(the_other_provider_yields_exactly_one_status) :-
    nis2_domain_name_data_profile_for(other_provider, Profile),
    findall(Status, nis2_domain_name_data_status(Profile, Status), Statuses),
    Statuses == [ineligible].
test(the_verdict_carries_a_citation) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    decide_nis2_domain_name_data(Profile, nis2_domain_name_data_verdict(_Status, [_FirstCitation|_OtherCitations])).
test(the_checklist_item_carries_a_citation) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    findall(Checklist, nis2_domain_name_data_checklist(Profile, Checklist), Checklists),
    Checklists == [[item(provider_addressed, met, cite(eu_dir_2022_2555_art_28_1))]].
test(the_ineligible_checklist_names_the_unmet_ground) :-
    nis2_domain_name_data_profile_for(other_provider, Profile),
    nis2_domain_name_data_checklist(Profile, [item(provider_addressed, unmet(not_an_addressed_provider), cite(eu_dir_2022_2555_art_28_1))]).
test(duties_are_one_list_of_nine_in_article_order) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    findall(Duties, provider_duties(Profile, Duties), Solutions),
    Solutions = [Duties],
    length(Duties, 9),
    Duties = [duty(collect_and_maintain_accurate_and_complete_registration_data, cite(eu_dir_2022_2555_art_28_1))|_],
    last(Duties, duty(cooperate_to_avoid_duplicate_collection_of_registration_data, cite(eu_dir_2022_2555_art_28_6))).
test(duties_of_other_are_the_empty_list) :-
    nis2_domain_name_data_profile_for(other_provider, Profile),
    findall(Duties, provider_duties(Profile, Duties), Solutions),
    Solutions == [[]].
test(fields_with_email_difference_only) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    findall(Fields, required_registration_data(Profile, Fields), Solutions),
    Solutions == [[field(domain_name, cite(eu_dir_2022_2555_art_28_2_a)), field(date_of_registration, cite(eu_dir_2022_2555_art_28_2_b)), field(registrant_name, cite(eu_dir_2022_2555_art_28_2_c)), field(registrant_contact_email_address, cite(eu_dir_2022_2555_art_28_2_c)), field(registrant_telephone_number, cite(eu_dir_2022_2555_art_28_2_c)), field(point_of_contact_contact_email_address, cite(eu_dir_2022_2555_art_28_2_d))]].
test(fields_with_both_differences_are_seven) :-
    required_registration_data([attribute(point_of_contact_email_address_differs_from_registrant, true), attribute(point_of_contact_telephone_number_differs_from_registrant, true)], Fields),
    length(Fields, 7).
test(fields_missing_both_keys_names_both) :-
    required_registration_data([], indeterminate([point_of_contact_email_address_differs_from_registrant, point_of_contact_telephone_number_differs_from_registrant])).
test(publication_yields_one_solution) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    findall(Result - Citations, publication_duty(Profile, Result, Citations), Solutions),
    Solutions == [must_publish_without_undue_delay - [cite(eu_dir_2022_2555_art_28_4)]].
test(publication_absent_key_is_indeterminate) :-
    publication_duty([], indeterminate([registration_data_is_personal_data]), []).
test(access_yields_one_solution) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    findall(Result - Citations, access_duty(Profile, Result, Citations), Solutions),
    Solutions == [must_provide_access - [cite(eu_dir_2022_2555_art_28_5)]].
test(access_both_absent_names_both_keys) :-
    access_duty([], indeterminate([requester_is_legitimate_access_seeker, request_is_lawful_and_duly_substantiated]), []).
test(access_unsure_and_absent_names_the_absent_key) :-
    access_duty([attribute(request_is_lawful_and_duly_substantiated, unsure)], indeterminate([requester_is_legitimate_access_seeker]), []).
test(reply_yields_one_solution) :-
    nis2_domain_name_data_profile_for(registry_addressed, Profile),
    findall(Result, access_reply_timeliness(Profile, 48, Result), Solutions),
    Solutions == [on_time].
test(reply_absent_key_inside_limit_is_indeterminate) :-
    access_reply_timeliness([], 10, indeterminate([reply_without_undue_delay])).
test(reply_unsure_inside_limit_refers) :-
    access_reply_timeliness([attribute(reply_without_undue_delay, unsure)], 10, needs_legal_review(open_textured(reply_without_undue_delay, cite(eu_dir_2022_2555_art_28_5)), [inputs_relied_on([reply_without_undue_delay - unsure])])).

cp_test_names([the_registry_profile_yields_exactly_one_status, the_other_provider_yields_exactly_one_status, the_verdict_carries_a_citation, the_checklist_item_carries_a_citation, the_ineligible_checklist_names_the_unmet_ground, duties_are_one_list_of_nine_in_article_order, duties_of_other_are_the_empty_list, fields_with_email_difference_only, fields_with_both_differences_are_seven, fields_missing_both_keys_names_both, publication_yields_one_solution, publication_absent_key_is_indeterminate, access_yields_one_solution, access_both_absent_names_both_keys, access_unsure_and_absent_names_the_absent_key, reply_yields_one_solution, reply_absent_key_inside_limit_is_indeterminate, reply_unsure_inside_limit_refers]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
