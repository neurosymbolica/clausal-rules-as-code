% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_kernel, [contract_keys/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [information_duty_verdict/3, information_outside_facts/2, information_duty_verdict_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_exemption, [information_duty_exemption/2, information_duty_exemption_status_values/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_fixtures, [gdpr_information_duties_headline_verdict_subject/1, gdpr_information_duties_headline_verdict_profile_for/2]).

all_subjects(Subjects) :-
    findall(Subject, gdpr_information_duties_headline_verdict_subject(Subject), Subjects).

verdict_answers(Subject, Answers) :-
    gdpr_information_duties_headline_verdict_profile_for(Subject, Profile),
    findall(Verdict - Citations, information_duty_verdict(Profile, Verdict, Citations), Answers).

one_verdict(Subject) :-
    verdict_answers(Subject, [_]).

one_exemption(Subject) :-
    gdpr_information_duties_headline_verdict_profile_for(Subject, Profile),
    findall(Exemption, information_duty_exemption(Profile, Exemption), [_]).

one_outside_facts(Subject) :-
    gdpr_information_duties_headline_verdict_profile_for(Subject, Profile),
    findall(Facts, information_outside_facts(Profile, Facts), [_]).

citations_shape(eligible, [_|_]).
citations_shape(ineligible, [_|_]).
citations_shape(indeterminate([_|_]), []).
citations_shape(needs_legal_review(open_textured(_, cite(_)), [inputs_relied_on(_)|_]), []).
citations_shape(input_problems([_|_]), []).

well_shaped(Subject) :-
    verdict_answers(Subject, [Verdict - Citations]),
    citations_shape(Verdict, Citations).

final_in_vocabulary(Subject) :-
    verdict_answers(Subject, [Verdict - _]),
    final_or_compound(Verdict).

final_or_compound(Verdict) :-
    information_duty_verdict_status_values(Values),
    member(Verdict, Values).
final_or_compound(indeterminate(_)).
final_or_compound(needs_legal_review(_, _)).
final_or_compound(input_problems(_)).

exemption_in_vocabulary(Subject) :-
    gdpr_information_duties_headline_verdict_profile_for(Subject, Profile),
    information_duty_exemption(Profile, Exemption),
    exemption_or_compound(Exemption).

exemption_or_compound(Exemption) :-
    information_duty_exemption_status_values(Values),
    member(Exemption, Values).
exemption_or_compound(indeterminate(_)).
exemption_or_compound(needs_legal_review(_, _)).
exemption_or_compound(input_problems(_)).

ordered_sublist([], _).
ordered_sublist([Key|Keys], [Key|ContractKeys]) :-
    ordered_sublist(Keys, ContractKeys).
ordered_sublist([Key|Keys], [ContractKey|ContractKeys]) :-
    dif(Key, ContractKey),
    ordered_sublist([Key|Keys], ContractKeys).

missing_keys_ordered(Subject) :-
    verdict_answers(Subject, [Verdict - _]),
    missing_keys_of(Verdict).

missing_keys_of(indeterminate(Keys)) :-
    contract_keys(ContractKeys),
    ordered_sublist(Keys, ContractKeys).
missing_keys_of(eligible).
missing_keys_of(ineligible).
missing_keys_of(needs_legal_review(_, _)).
missing_keys_of(input_problems(_)).

test(totality_and_determinism_of_the_headline) :-
    all_subjects(Subjects),
    maplist(one_verdict, Subjects).
test(totality_and_determinism_of_the_exemption) :-
    all_subjects(Subjects),
    maplist(one_exemption, Subjects).
test(totality_and_determinism_of_the_outside_facts) :-
    all_subjects(Subjects),
    maplist(one_outside_facts, Subjects).
test(citations_follow_the_answer_kind) :-
    all_subjects(Subjects),
    maplist(well_shaped, Subjects).
test(headlines_stay_in_the_vocabulary) :-
    all_subjects(Subjects),
    maplist(final_in_vocabulary, Subjects).
test(exemptions_stay_in_the_vocabulary) :-
    all_subjects(Subjects),
    maplist(exemption_in_vocabulary, Subjects).
test(missing_keys_are_in_contract_order) :-
    all_subjects(Subjects),
    maplist(missing_keys_ordered, Subjects).
test(exemption_keys_do_not_change_an_article_13_headline) :-
    gdpr_information_duties_headline_verdict_profile_for(article_13_complete_on_obtaining_day, Profile),
    append(Profile, [attribute(provision_impossible_or_disproportionate_effort, unsure), attribute(obtaining_or_disclosure_laid_down_by_law, attested(true, attestation(by, at, reason, none)))], Extended),
    findall(Verdict - Citations, information_duty_verdict(Extended, Verdict, Citations), Answers),
    Answers == [eligible - [cite(eu_reg_2016_679_art_13_1)]].
test(an_item_already_held_covers_like_one_provided) :-
    information_duty_verdict([attribute(personal_data_collected_from_data_subject, true), attribute(items_provided, [controller_identity_and_contact_details, purposes_and_legal_basis, storage_period_or_criteria, data_subject_rights, right_to_lodge_complaint]), attribute(items_data_subject_already_has, [statutory_or_contractual_requirement]), attribute(data_protection_officer_designated, false), attribute(processing_based_on_legitimate_interests, false), attribute(recipients_exist, false), attribute(transfer_intended, false), attribute(processing_based_on_consent, false), attribute(automated_decision_making_under_article_22, false), attribute(obtaining_date, date(2026, 3, 2)), attribute(provision_date, date(2026, 3, 2)), attribute(further_processing_for_another_purpose_intended, false)], eligible, [cite(eu_reg_2016_679_art_13_1)]).

test(an_unordered_key_list_is_detected, fail) :-
    missing_keys_of(indeterminate([provision_date, obtaining_date])).

cp_test_names([totality_and_determinism_of_the_headline, totality_and_determinism_of_the_exemption, totality_and_determinism_of_the_outside_facts, citations_follow_the_answer_kind, headlines_stay_in_the_vocabulary, exemptions_stay_in_the_vocabulary, missing_keys_are_in_contract_order, exemption_keys_do_not_change_an_article_13_headline, an_item_already_held_covers_like_one_provided]).
cp_test_fail_names([an_unordered_key_list_is_detected]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
