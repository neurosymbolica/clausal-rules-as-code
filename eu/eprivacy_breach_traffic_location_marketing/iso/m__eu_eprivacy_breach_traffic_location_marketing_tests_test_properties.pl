% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_breach_traffic_location_marketing_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_eprivacy_breach_traffic_location_marketing, [decide_eprivacy_breach_traffic_location_marketing/2, personal_data_breach_notification_status/3, traffic_data_processing_status/3, location_data_processing_status/3, direct_marketing_communication_status/3, direct_marketing_email_practice_status/3]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_kernel, [eprivacy_breach_traffic_location_marketing_input_problems/2]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_fixtures, [eprivacy_breach_traffic_location_marketing_subject/1, eprivacy_breach_traffic_location_marketing_profile_for/2]).

contract_query(personal_data_breach_notification).
contract_query(traffic_data_processing).
contract_query(location_data_processing).
contract_query(direct_marketing_communication).
contract_query(direct_marketing_email_practice).

query_answer(personal_data_breach_notification, Profile, Result, Citations) :-
    personal_data_breach_notification_status(Profile, Result, Citations).
query_answer(traffic_data_processing, Profile, Result, Citations) :-
    traffic_data_processing_status(Profile, Result, Citations).
query_answer(location_data_processing, Profile, Result, Citations) :-
    location_data_processing_status(Profile, Result, Citations).
query_answer(direct_marketing_communication, Profile, Result, Citations) :-
    direct_marketing_communication_status(Profile, Result, Citations).
query_answer(direct_marketing_email_practice, Profile, Result, Citations) :-
    direct_marketing_email_practice_status(Profile, Result, Citations).

expected_citations(personal_data_breach_notification, authority_and_individual_notification_due, [cite(eu_dir_2002_58_art_4_3)]).
expected_citations(personal_data_breach_notification, authority_notification_due, [cite(eu_dir_2002_58_art_4_3)]).
expected_citations(personal_data_breach_notification, not_applicable, [cite(eu_dir_2002_58_art_4_3)]).
expected_citations(traffic_data_processing, permitted, [cite(eu_dir_2002_58_art_6_1), cite(eu_dir_2002_58_art_6_2), cite(eu_dir_2002_58_art_6_3)]).
expected_citations(traffic_data_processing, not_permitted, [cite(eu_dir_2002_58_art_6_1)]).
expected_citations(traffic_data_processing, not_applicable, [cite(eu_dir_2002_58_art_6_1)]).
expected_citations(location_data_processing, permitted, [cite(eu_dir_2002_58_art_9_1)]).
expected_citations(location_data_processing, not_permitted, [cite(eu_dir_2002_58_art_9_1)]).
expected_citations(location_data_processing, not_applicable, [cite(eu_dir_2002_58_art_9_1)]).
expected_citations(direct_marketing_communication, not_applicable, [cite(eu_dir_2002_58_art_13_1)]).
expected_citations(direct_marketing_communication, national_law_decides, [cite(eu_dir_2002_58_art_13_3), cite(eu_dir_2002_58_art_13_5)]).
expected_citations(direct_marketing_communication, sending_permitted, [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]).
expected_citations(direct_marketing_communication, sending_not_permitted, [cite(eu_dir_2002_58_art_13_1), cite(eu_dir_2002_58_art_13_2)]).
expected_citations(direct_marketing_email_practice, practice_prohibited, [cite(eu_dir_2002_58_art_13_4)]).
expected_citations(direct_marketing_email_practice, practice_not_prohibited, [cite(eu_dir_2002_58_art_13_4)]).
expected_citations(direct_marketing_email_practice, not_applicable, [cite(eu_dir_2002_58_art_13_4)]).

answer_well_formed(_, indeterminate([_]), []).
answer_well_formed(_, needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on(_)]), []).
answer_well_formed(_, input_problems([_|_]), []).
answer_well_formed(QueryName, Result, Citations) :-
    expected_citations(QueryName, Result, Citations).

all_subjects(Subjects) :-
    findall(Subject, eprivacy_breach_traffic_location_marketing_subject(Subject), Found),
    sort(Found, Subjects).

subject_classifies(Subject) :-
    eprivacy_breach_traffic_location_marketing_subject(Subject),
    eprivacy_breach_traffic_location_marketing_profile_for(Subject, Profile),
    decide_eprivacy_breach_traffic_location_marketing(Profile, _Verdict).

subject_has_one_verdict(Subject) :-
    eprivacy_breach_traffic_location_marketing_profile_for(Subject, Profile),
    findall(Verdict, decide_eprivacy_breach_traffic_location_marketing(Profile, Verdict), Verdicts),
    length(Verdicts, 1).

subject_has_one_input_check(Subject) :-
    eprivacy_breach_traffic_location_marketing_profile_for(Subject, Profile),
    findall(Problems, eprivacy_breach_traffic_location_marketing_input_problems(Profile, Problems), ProblemLists),
    length(ProblemLists, 1).

subject_answers_every_query_once(Subject) :-
    eprivacy_breach_traffic_location_marketing_profile_for(Subject, Profile),
    findall(QueryName, contract_query(QueryName), QueryNames),
    maplist(query_answers_once(Profile), QueryNames).

query_answers_once(Profile, QueryName) :-
    findall(Result - Citations, query_answer(QueryName, Profile, Result, Citations), Answers),
    Answers = [OnlyResult - OnlyCitations],
    answer_well_formed(QueryName, OnlyResult, OnlyCitations).

test(totality_every_subject_classifies) :-
    all_subjects(SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_one_verdict) :-
    all_subjects(Subjects),
    maplist(subject_has_one_verdict, Subjects).
test(determinism_every_subject_has_one_input_check) :-
    all_subjects(Subjects),
    maplist(subject_has_one_input_check, Subjects).
test(determinism_and_citations_every_query_on_every_subject) :-
    all_subjects(Subjects),
    maplist(subject_answers_every_query_once, Subjects).
test(determinism_every_query_on_the_empty_profile) :-
    findall(QueryName, contract_query(QueryName), QueryNames),
    maplist(query_answers_once([]), QueryNames).
test(invariant_anonymous_location_data_always_permitted) :-
    findall(Result, (member(Consent, [true, false, unsure]), member(Withdrawn, [true, false]), member(WithinNecessary, [true, false, unsure]), member(Refused, [true, false]), location_data_processing_status([attribute(location_data_other_than_traffic_data_in_scope, true), attribute(location_data_made_anonymous, true), attribute(location_consent_given, Consent), attribute(location_consent_withdrawn, Withdrawn), attribute(location_processing_within_necessary_extent_and_duration_for_value_added_service, WithinNecessary), attribute(location_processing_temporarily_refused, Refused)], Result, _)), Results),
    sort(Results, Distinct),
    Distinct == [permitted].
test(invariant_authority_requirement_always_notifies_both) :-
    findall(Result, (member(Likely, [true, false, unsure]), member(Protection, [true, false]), personal_data_breach_notification_status([attribute(breach_provider_of_publicly_available_service, true), attribute(personal_data_breach_occurred, true), attribute(authority_required_individual_notification, true), attribute(breach_likely_to_adversely_affect_subscriber_or_individual, Likely), attribute(protection_measures_demonstrated_to_authority, Protection)], Result, _)), Results),
    sort(Results, Distinct),
    Distinct == [authority_and_individual_notification_due].
test(invariant_legal_person_subscriber_always_national_law) :-
    findall(Result, (member(Means, [automatic_calling_machine, fax, electronic_mail, other_means]), member(Consent, [true, false, unsure]), direct_marketing_communication_status([attribute(marketing_communication_for_direct_marketing, true), attribute(marketing_subscriber_is_natural_person, false), attribute(marketing_communication_means, Means), attribute(marketing_prior_consent_given, Consent)], Result, _)), Results),
    sort(Results, Distinct),
    Distinct == [national_law_decides].
test(invariant_other_purpose_never_permitted) :-
    findall(Result, (member(StillNeeded, [true, false, unsure]), member(Consent, [true, false, unsure]), member(Withdrawn, [true, false]), traffic_data_processing_status([attribute(traffic_provider_of_public_network_or_service, true), attribute(traffic_data_relating_to_subscribers_or_users, true), attribute(traffic_processing_purpose, other_purpose), attribute(traffic_data_still_needed_for_transmission, StillNeeded), attribute(traffic_marketing_prior_consent_given, Consent), attribute(traffic_marketing_consent_withdrawn, Withdrawn)], Result, _)), Results),
    sort(Results, Distinct),
    Distinct == [not_permitted].
test(invariant_email_practice_not_applicable_to_other_means) :-
    findall(Result, (member(Means, [automatic_calling_machine, fax, other_means]), member(DirectMarketing, [true, false, unsure]), member(Disguised, [true, false, unsure]), direct_marketing_email_practice_status([attribute(marketing_communication_for_direct_marketing, DirectMarketing), attribute(marketing_communication_means, Means), attribute(email_sender_identity_disguised_or_concealed, Disguised)], Result, _)), Results),
    sort(Results, Distinct),
    Distinct == [not_applicable].
test(invariant_keys_of_other_queries_do_not_change_an_answer) :-
    findall(Result, (member(OtherValue, [true, false, unsure]), location_data_processing_status([attribute(location_data_other_than_traffic_data_in_scope, true), attribute(location_data_made_anonymous, false), attribute(location_consent_given, false), attribute(personal_data_breach_occurred, OtherValue), attribute(marketing_prior_consent_given, OtherValue)], Result, _)), Results),
    sort(Results, Distinct),
    Distinct == [not_permitted].

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_one_verdict, determinism_every_subject_has_one_input_check, determinism_and_citations_every_query_on_every_subject, determinism_every_query_on_the_empty_profile, invariant_anonymous_location_data_always_permitted, invariant_authority_requirement_always_notifies_both, invariant_legal_person_subscriber_always_national_law, invariant_other_purpose_never_permitted, invariant_email_practice_not_applicable_to_other_means, invariant_keys_of_other_queries_do_not_change_an_answer]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
