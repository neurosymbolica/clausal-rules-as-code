% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_information_sharing_arrangements_tests_test_load, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_dora_information_sharing_arrangements_kernel, [dora_information_sharing_arrangements_input_problems/2]).
:- use_module(m__eu_dora_information_sharing_arrangements_citations, [citation/2, implements/1]).

test(the_sharing_atoms_are_distinct) :-
    dif(sharing_within_article_45, sharing_outside_article_45).
test(the_notification_atoms_are_distinct) :-
    dif(notify_participation_upon_validation, notify_cessation_once_effective),
    dif(notify_participation_upon_validation, no_notification_duty),
    dif(notify_cessation_once_effective, no_notification_duty).
test(the_membership_event_atoms_are_distinct) :-
    dif(membership_validated, membership_cessation_took_effect),
    dif(membership_validated, no_membership_event),
    dif(membership_cessation_took_effect, no_membership_event).
test(the_facade_verdict_term_carries_status_and_citations) :-
    Verdict = dora_information_sharing_arrangements_verdict(sharing_within_article_45, [cite(eu_reg_2022_2554_art_45_1)]),
    Verdict = dora_information_sharing_arrangements_verdict(Status, Citations),
    Status == sharing_within_article_45,
    Citations == [cite(eu_reg_2022_2554_art_45_1)].
test(the_indeterminate_term_names_one_key) :-
    Result = indeterminate([membership_event]),
    Result = indeterminate([Key]),
    Key == membership_event.
test(the_referral_term_destructures) :-
    Result = needs_legal_review(open_textured(arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, cite(eu_reg_2022_2554_art_45_3)), [inputs_relied_on([membership_event - membership_validated, arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1 - unsure])]),
    Result = needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)]),
    Key == arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1,
    CitationKey == eu_reg_2022_2554_art_45_3,
    Pairs == [membership_event - membership_validated, arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1 - unsure].
test(the_input_problems_term_destructures) :-
    Result = input_problems([unknown_key(colour)]),
    Result = input_problems(Problems),
    Problems == [unknown_key(colour)].
test(the_lead_words_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_45_1, _Record).
test(the_notification_citation_is_recorded) :-
    citation(eu_reg_2022_2554_art_45_3, _Record).
test(every_contract_citation_is_recorded) :-
    implements(eu_reg_2022_2554_art_45_1),
    implements(eu_reg_2022_2554_art_45_1_a),
    implements(eu_reg_2022_2554_art_45_1_b),
    implements(eu_reg_2022_2554_art_45_1_c),
    implements(eu_reg_2022_2554_art_45_2),
    implements(eu_reg_2022_2554_art_45_3).
test(an_empty_profile_has_no_problem) :-
    findall(Problems, dora_information_sharing_arrangements_input_problems([], Problems), Answers),
    Answers == [[]].
test(a_well_formed_profile_has_no_problem) :-
    findall(Problems, dora_information_sharing_arrangements_input_problems([attribute(membership_event, membership_validated), attribute(arrangement_is_information_sharing_arrangement_referred_to_in_article_45_1, unsure)], Problems), Answers),
    Answers == [[]].
test(a_value_outside_its_type_is_wrong_type) :-
    findall(Problems, dora_information_sharing_arrangements_input_problems([attribute(membership_event, maybe)], Problems), Answers),
    Answers == [[wrong_type(membership_event)]].
test(a_repeated_key_is_a_duplicate_only) :-
    findall(Problems, dora_information_sharing_arrangements_input_problems([attribute(membership_event, membership_validated), attribute(membership_event, maybe)], Problems), Answers),
    Answers == [[duplicate_key(membership_event)]].
test(a_key_outside_the_contract_is_unknown) :-
    findall(Problems, dora_information_sharing_arrangements_input_problems([attribute(colour, red)], Problems), Answers),
    Answers == [[unknown_key(colour)]].
test(a_term_that_is_not_a_list_is_wrong_type_profile) :-
    findall(Problems, dora_information_sharing_arrangements_input_problems(not_a_profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].
test(an_unbound_profile_is_wrong_type_profile) :-
    findall(Problems, dora_information_sharing_arrangements_input_problems(_Profile, Problems), Answers),
    Answers == [[wrong_type(profile)]].

test(a_shortened_citation_is_not_recorded, fail) :-
    implements(art_45_3).
test(a_well_formed_profile_is_not_refused, fail) :-
    dora_information_sharing_arrangements_input_problems([attribute(membership_event, membership_validated)], [_|_]).

cp_test_names([the_sharing_atoms_are_distinct, the_notification_atoms_are_distinct, the_membership_event_atoms_are_distinct, the_facade_verdict_term_carries_status_and_citations, the_indeterminate_term_names_one_key, the_referral_term_destructures, the_input_problems_term_destructures, the_lead_words_citation_is_recorded, the_notification_citation_is_recorded, every_contract_citation_is_recorded, an_empty_profile_has_no_problem, a_well_formed_profile_has_no_problem, a_value_outside_its_type_is_wrong_type, a_repeated_key_is_a_duplicate_only, a_key_outside_the_contract_is_unknown, a_term_that_is_not_a_list_is_wrong_type_profile, an_unbound_profile_is_wrong_type_profile]).
cp_test_fail_names([a_shortened_citation_is_not_recorded, a_well_formed_profile_is_not_refused]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
