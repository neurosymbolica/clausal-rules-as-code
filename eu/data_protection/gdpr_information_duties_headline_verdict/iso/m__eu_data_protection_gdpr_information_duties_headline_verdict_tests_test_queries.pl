% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_information_duties_headline_verdict_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_queries, [gdpr_information_duties_headline_verdict_profile_keys/1, gdpr_information_duties_headline_verdict_what_if/4, gdpr_information_duties_headline_verdict_compliance_check/3, gdpr_information_duties_headline_verdict_obligations/2, gdpr_information_duties_headline_verdict_deadline/2]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_kernel, [contract_keys/1]).
:- use_module(m__eu_data_protection_gdpr_information_duties_headline_verdict_fixtures, [gdpr_information_duties_headline_verdict_profile_for/2]).

profile_of(Subject, Profile) :-
    gdpr_information_duties_headline_verdict_profile_for(Subject, Profile).

test(profile_keys_are_the_contract_keys) :-
    gdpr_information_duties_headline_verdict_profile_keys(ProfileKeys),
    contract_keys(ContractKeys),
    ProfileKeys == ContractKeys.
test(what_if_an_earlier_provision_makes_it_eligible) :-
    profile_of(article_13_complete_one_day_after_obtaining, Profile),
    gdpr_information_duties_headline_verdict_what_if(Profile, provision_date, date(2026, 3, 2), eligible).
test(what_if_automated_decisions_make_it_ineligible) :-
    profile_of(article_13_complete_on_obtaining_day, Profile),
    gdpr_information_duties_headline_verdict_what_if(Profile, automated_decision_making_under_article_22, true, ineligible).
test(providing_before_obtaining_is_allowed) :-
    profile_of(article_13_complete_on_obtaining_day, Profile),
    gdpr_information_duties_headline_verdict_compliance_check(Profile, provide_information_on(date(2026, 3, 1)), allowed).
test(providing_after_obtaining_is_not_allowed) :-
    profile_of(article_13_complete_on_obtaining_day, Profile),
    gdpr_information_duties_headline_verdict_compliance_check(Profile, provide_information_on(date(2026, 3, 3)), not_allowed).
test(starting_further_processing_after_the_notice_is_allowed) :-
    profile_of(article_13_further_processing_informed_day_before, Profile),
    gdpr_information_duties_headline_verdict_compliance_check(Profile, start_further_processing_on(date(2026, 4, 11)), allowed).
test(starting_further_processing_on_the_notice_day_is_not_allowed) :-
    profile_of(article_13_further_processing_informed_day_before, Profile),
    gdpr_information_duties_headline_verdict_compliance_check(Profile, start_further_processing_on(date(2026, 4, 9)), not_allowed).
test(a_refused_profile_gets_input_problems) :-
    profile_of(not_a_profile, Profile),
    gdpr_information_duties_headline_verdict_compliance_check(Profile, provide_information_on(date(2026, 3, 1)), input_problems([wrong_type(profile)])).
test(a_missing_item_surfaces_its_citation) :-
    profile_of(article_13_requirement_item_missing, Profile),
    gdpr_information_duties_headline_verdict_obligations(Profile, [must_remedy(items_missing, [cite(eu_reg_2016_679_art_13_2_e)])]).
test(a_law_exemption_disapplies_the_duty) :-
    profile_of(article_14_source_missing_law_attested_true, Profile),
    gdpr_information_duties_headline_verdict_obligations(Profile, [duty_disapplied(law_lays_down_obtaining_or_disclosure)]).
test(a_compliant_article_14_notice_owes_nothing) :-
    profile_of(article_14_on_last_day_of_month, Profile),
    gdpr_information_duties_headline_verdict_obligations(Profile, [no_outstanding_obligation]).
test(article_13_deadline_is_the_obtaining_day) :-
    profile_of(article_13_complete_on_obtaining_day, Profile),
    gdpr_information_duties_headline_verdict_deadline(Profile, deadline(date(2026, 3, 2), [cite(eu_reg_2016_679_art_13_1)], consequence(ineligible))).
test(article_14_one_month_deadline_shifts_off_a_sunday) :-
    profile_of(article_14_on_last_day_of_month, Profile),
    gdpr_information_duties_headline_verdict_deadline(Profile, deadline(date(2026, 2, 16), [cite(eu_reg_2016_679_art_14_3_a)], consequence(ineligible))).
test(article_14_holiday_deadline_moves_once_more) :-
    profile_of(article_14_holiday_shifted_last_day, Profile),
    gdpr_information_duties_headline_verdict_deadline(Profile, deadline(date(2027, 2, 2), [cite(eu_reg_2016_679_art_14_3_a)], consequence(ineligible))).
test(article_14_first_communication_deadline_binds) :-
    profile_of(article_14_first_communication_on_the_day, Profile),
    gdpr_information_duties_headline_verdict_deadline(Profile, deadline(date(2026, 1, 20), [cite(eu_reg_2016_679_art_14_3_b)], consequence(ineligible))).
test(an_absent_obtaining_date_leaves_the_deadline_open) :-
    profile_of(route_not_supplied, Profile),
    gdpr_information_duties_headline_verdict_deadline(Profile, indeterminate([obtaining_date])).

test(what_if_automated_decisions_is_not_eligible, fail) :-
    profile_of(article_13_complete_on_obtaining_day, Profile),
    gdpr_information_duties_headline_verdict_what_if(Profile, automated_decision_making_under_article_22, true, eligible).
test(providing_after_obtaining_is_not_allowed_silently, fail) :-
    profile_of(article_13_complete_on_obtaining_day, Profile),
    gdpr_information_duties_headline_verdict_compliance_check(Profile, provide_information_on(date(2026, 3, 3)), allowed).
test(a_late_article_14_notice_is_not_free_of_obligations, fail) :-
    profile_of(article_14_day_after_last_day_of_month, Profile),
    gdpr_information_duties_headline_verdict_obligations(Profile, [no_outstanding_obligation]).
test(the_sunday_is_not_the_deadline, fail) :-
    profile_of(article_14_on_last_day_of_month, Profile),
    gdpr_information_duties_headline_verdict_deadline(Profile, deadline(date(2026, 2, 15), _, _)).

cp_test_names([profile_keys_are_the_contract_keys, what_if_an_earlier_provision_makes_it_eligible, what_if_automated_decisions_make_it_ineligible, providing_before_obtaining_is_allowed, providing_after_obtaining_is_not_allowed, starting_further_processing_after_the_notice_is_allowed, starting_further_processing_on_the_notice_day_is_not_allowed, a_refused_profile_gets_input_problems, a_missing_item_surfaces_its_citation, a_law_exemption_disapplies_the_duty, a_compliant_article_14_notice_owes_nothing, article_13_deadline_is_the_obtaining_day, article_14_one_month_deadline_shifts_off_a_sunday, article_14_holiday_deadline_moves_once_more, article_14_first_communication_deadline_binds, an_absent_obtaining_date_leaves_the_deadline_open]).
cp_test_fail_names([what_if_automated_decisions_is_not_eligible, providing_after_obtaining_is_not_allowed_silently, a_late_article_14_notice_is_not_free_of_obligations, the_sunday_is_not_the_deadline]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
