% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_eprivacy_breach_traffic_location_marketing_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_kernel, [eprivacy_breach_traffic_location_marketing_input_problems/2]).
:- use_module(m__eu_eprivacy_breach_traffic_location_marketing_citations, [citation/2, implements/1]).

test(an_empty_profile_has_no_problem) :-
    findall(Problems, eprivacy_breach_traffic_location_marketing_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    Profile = [attribute(breach_provider_of_publicly_available_service, true), attribute(personal_data_breach_occurred, unsure), attribute(authority_required_individual_notification, false), attribute(traffic_processing_purpose, other_purpose), attribute(marketing_communication_means, electronic_mail)],
    findall(Problems, eprivacy_breach_traffic_location_marketing_input_problems(Profile, Problems), Answers),
    Answers == [[]].
test(an_atom_is_not_an_attribute_list) :-
    findall(Problems, eprivacy_breach_traffic_location_marketing_input_problems(profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_not_an_attribute_list) :-
    findall(Problems, eprivacy_breach_traffic_location_marketing_input_problems(_, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(a_key_outside_the_contract_is_unknown) :-
    findall(Problems, eprivacy_breach_traffic_location_marketing_input_problems([attribute(colour, blue)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(a_repeated_contract_key_is_a_duplicate_only) :-
    Profile = [attribute(personal_data_breach_occurred, true), attribute(personal_data_breach_occurred, banana)],
    findall(Problems, eprivacy_breach_traffic_location_marketing_input_problems(Profile, Problems), Answers),
    Answers == [[duplicate_key(personal_data_breach_occurred)]].
test(unsure_is_outside_a_boolean) :-
    Profile = [attribute(authority_required_individual_notification, unsure)],
    findall(Problems, eprivacy_breach_traffic_location_marketing_input_problems(Profile, Problems), Answers),
    Answers == [[wrong_type(authority_required_individual_notification)]].
test(unsure_is_inside_a_judgement) :-
    Profile = [attribute(location_consent_given, unsure)],
    eprivacy_breach_traffic_location_marketing_input_problems(Profile, []).
test(the_verdict_term_carries_status_and_citations) :-
    Verdict = eprivacy_breach_traffic_location_marketing_verdict(permitted, [cite(eu_dir_2002_58_art_9_1)]),
    Verdict = eprivacy_breach_traffic_location_marketing_verdict(Status, Citations),
    Status == permitted,
    Citations == [cite(eu_dir_2002_58_art_9_1)].
test(the_referral_term_destructures) :-
    Result = needs_legal_review(open_textured(personal_data_breach_occurred, cite(eu_dir_2002_58_art_2_i)), [inputs_relied_on([personal_data_breach_occurred - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == personal_data_breach_occurred,
    CitationKey == eu_dir_2002_58_art_2_i,
    Pairs == [personal_data_breach_occurred - unsure].
test(the_missing_key_term_destructures) :-
    Result = indeterminate([traffic_processing_purpose]),
    Result = indeterminate([Key]),
    Key == traffic_processing_purpose.
test(the_breach_atoms_are_distinct) :-
    dif(authority_and_individual_notification_due, authority_notification_due),
    dif(authority_and_individual_notification_due, not_applicable),
    dif(authority_notification_due, not_applicable).
test(the_processing_atoms_are_distinct) :-
    dif(permitted, not_permitted),
    dif(permitted, not_applicable),
    dif(not_permitted, not_applicable).
test(the_marketing_atoms_are_distinct) :-
    dif(sending_permitted, sending_not_permitted),
    dif(sending_permitted, national_law_decides),
    dif(sending_not_permitted, national_law_decides),
    dif(national_law_decides, not_applicable).
test(the_practice_atoms_are_distinct) :-
    dif(practice_prohibited, practice_not_prohibited),
    dif(practice_prohibited, not_applicable),
    dif(practice_not_prohibited, not_applicable).
test(the_breach_citation_is_recorded) :-
    citation(eu_dir_2002_58_art_4_3, Record),
    Record = [label - _, ref - _, verbatim - _].
test(the_marker_resolves_a_real_key) :-
    implements(eu_dir_2002_58_art_13_4).

test(an_unrecorded_key_does_not_resolve, fail) :-
    citation(eu_todo_primary_source, _).

cp_test_names([an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, an_atom_is_not_an_attribute_list, an_unbound_profile_is_not_an_attribute_list, a_key_outside_the_contract_is_unknown, a_repeated_contract_key_is_a_duplicate_only, unsure_is_outside_a_boolean, unsure_is_inside_a_judgement, the_verdict_term_carries_status_and_citations, the_referral_term_destructures, the_missing_key_term_destructures, the_breach_atoms_are_distinct, the_processing_atoms_are_distinct, the_marketing_atoms_are_distinct, the_practice_atoms_are_distinct, the_breach_citation_is_recorded, the_marker_resolves_a_real_key]).
cp_test_fail_names([an_unrecorded_key_does_not_resolve]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
