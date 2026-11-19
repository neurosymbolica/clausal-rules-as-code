% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_verdict, [information_duty_verdict/3, information_outside_facts/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_information_duty_exemption, [information_duty_exemption/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_fixtures, [gdpr_information_duties_headline_verdict_profile_for/2]).

expected_verdict(article_13_complete_on_obtaining_day, eligible, [cite(eu_reg_2016_679_art_13_1)]).
expected_verdict(article_13_complete_one_day_after_obtaining, ineligible, [cite(eu_reg_2016_679_art_13_1)]).
expected_verdict(article_13_requirement_item_missing, ineligible, [cite(eu_reg_2016_679_art_13_2_e)]).
expected_verdict(article_13_automated_decision_unsure, needs_legal_review(open_textured(automated_decision_making_under_article_22, cite(eu_reg_2016_679_art_13_2_f)), [inputs_relied_on([automated_decision_making_under_article_22 - unsure])]), []).
expected_verdict(article_13_automated_decision_item_missing, ineligible, [cite(eu_reg_2016_679_art_13_2_f)]).
expected_verdict(article_13_further_processing_informed_day_before, eligible, [cite(eu_reg_2016_679_art_13_1), cite(eu_reg_2016_679_art_13_3)]).
expected_verdict(article_13_further_processing_informed_same_day, ineligible, [cite(eu_reg_2016_679_art_13_3)]).
expected_verdict(article_14_on_last_day_of_month, eligible, [cite(eu_reg_2016_679_art_14_1)]).
expected_verdict(article_14_day_after_last_day_of_month, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(article_14_month_end_shifted_past_weekend, eligible, [cite(eu_reg_2016_679_art_14_1)]).
expected_verdict(article_14_day_after_shifted_month_end, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(article_14_holiday_shifted_last_day, eligible, [cite(eu_reg_2016_679_art_14_1)]).
expected_verdict(article_14_day_after_holiday_shifted_last_day, ineligible, [cite(eu_reg_2016_679_art_14_3_a)]).
expected_verdict(article_14_first_communication_on_the_day, eligible, [cite(eu_reg_2016_679_art_14_1)]).
expected_verdict(article_14_first_communication_day_after, ineligible, [cite(eu_reg_2016_679_art_14_3_b)]).
expected_verdict(article_14_source_missing_law_attested_false, ineligible, [cite(eu_reg_2016_679_art_14_2_f)]).
expected_verdict(article_14_source_missing_law_attested_true, eligible, [cite(eu_reg_2016_679_art_14_5_c)]).
expected_verdict(article_14_effort_unsure_with_measures, needs_legal_review(open_textured(provision_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)), [inputs_relied_on([provision_impossible_or_disproportionate_effort - unsure])]), []).
expected_verdict(article_14_effort_with_measures, eligible, [cite(eu_reg_2016_679_art_14_5_b)]).
expected_verdict(article_14_only_the_route, indeterminate([items_provided, items_data_subject_already_has, data_protection_officer_designated, processing_based_on_legitimate_interests, recipients_exist, transfer_intended, processing_based_on_consent, automated_decision_making_under_article_22, obtaining_date, provision_date, data_used_for_communication_with_data_subject, disclosure_to_another_recipient_envisaged, provision_impossible_or_disproportionate_effort, protective_measures_taken, further_processing_for_another_purpose_intended]), []).
expected_verdict(route_not_supplied, indeterminate([personal_data_collected_from_data_subject, items_provided, items_data_subject_already_has, data_protection_officer_designated, processing_based_on_legitimate_interests, recipients_exist, transfer_intended, processing_based_on_consent, automated_decision_making_under_article_22, obtaining_date, provision_date, further_processing_for_another_purpose_intended]), []).
expected_verdict(input_problems_mix, input_problems([duplicate_key(items_provided), wrong_type(obtaining_date), unknown_key(colour)]), []).
expected_verdict(not_a_profile, input_problems([wrong_type(profile)]), []).

expected_exemption(article_13_complete_on_obtaining_day, none).
expected_exemption(article_13_requirement_item_missing, none).
expected_exemption(article_14_day_after_last_day_of_month, none).
expected_exemption(article_14_source_missing_law_attested_false, none).
expected_exemption(article_14_source_missing_law_attested_true, law_lays_down_obtaining_or_disclosure).
expected_exemption(article_14_effort_unsure_with_measures, needs_legal_review(open_textured(provision_impossible_or_disproportionate_effort, cite(eu_reg_2016_679_art_14_5_b)), [inputs_relied_on([provision_impossible_or_disproportionate_effort - unsure])])).
expected_exemption(article_14_effort_with_measures, impossible_or_disproportionate_effort).
expected_exemption(article_14_only_the_route, indeterminate([provision_impossible_or_disproportionate_effort, protective_measures_taken])).
expected_exemption(route_not_supplied, indeterminate([personal_data_collected_from_data_subject])).
expected_exemption(not_a_profile, input_problems([wrong_type(profile)])).

gives_expected_verdict_once(Subject) :-
    expected_verdict(Subject, Verdict, Citations),
    gdpr_information_duties_headline_verdict_profile_for(Subject, Profile),
    findall(Found - FoundCitations, information_duty_verdict(Profile, Found, FoundCitations), Answers),
    Answers == [Verdict - Citations].

gives_expected_exemption_once(Subject) :-
    expected_exemption(Subject, Exemption),
    gdpr_information_duties_headline_verdict_profile_for(Subject, Profile),
    findall(Found, information_duty_exemption(Profile, Found), Answers),
    Answers == [Exemption].

test(every_fixture_gives_its_expected_headline_exactly_once) :-
    findall(Subject, expected_verdict(Subject, _, _), Subjects),
    maplist(gives_expected_verdict_once, Subjects).
test(every_listed_fixture_gives_its_expected_exemption_exactly_once) :-
    findall(Subject, expected_exemption(Subject, _), Subjects),
    maplist(gives_expected_exemption_once, Subjects).
test(outside_facts_enumerate_in_order_once) :-
    gdpr_information_duties_headline_verdict_profile_for(article_14_holiday_shifted_last_day, Profile),
    findall(Facts, information_outside_facts(Profile, Facts), Answers),
    Answers == [[outside_fact(obtaining_or_disclosure_laid_down_by_law, absent), outside_fact(professional_secrecy_obligation_by_law, absent), outside_fact(public_holidays, attested([date(2027, 2, 1)], attestation(by, at, reason, none)))]].
test(outside_facts_report_an_attested_false_law) :-
    gdpr_information_duties_headline_verdict_profile_for(article_14_source_missing_law_attested_false, Profile),
    information_outside_facts(Profile, [outside_fact(obtaining_or_disclosure_laid_down_by_law, attested(false, attestation(by, at, reason, none))), outside_fact(professional_secrecy_obligation_by_law, absent), outside_fact(public_holidays, absent)]).
test(outside_facts_answer_whatever_the_headline) :-
    gdpr_information_duties_headline_verdict_profile_for(route_not_supplied, Profile),
    information_outside_facts(Profile, [outside_fact(obtaining_or_disclosure_laid_down_by_law, absent), outside_fact(professional_secrecy_obligation_by_law, absent), outside_fact(public_holidays, absent)]).

cp_test_names([every_fixture_gives_its_expected_headline_exactly_once, every_listed_fixture_gives_its_expected_exemption_exactly_once, outside_facts_enumerate_in_order_once, outside_facts_report_an_attested_false_law, outside_facts_answer_whatever_the_headline]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
