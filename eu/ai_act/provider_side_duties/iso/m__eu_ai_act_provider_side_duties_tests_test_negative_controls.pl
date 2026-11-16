% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_provider_side_duties_tests_test_negative_controls, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(m__eu_ai_act_provider_side_duties_provider_side_duties, [retention_period_end/4, provider_side_duties_status/2, provider_side_duties_status_values/1]).
:- use_module(m__eu_ai_act_provider_side_duties_fixtures, [provider_side_duties_profile_for/2]).

subject_status(Subject, Status) :-
    provider_side_duties_profile_for(Subject, Case),
    provider_side_duties_status(Case, Status).

named_status_atoms([not_applicable_on_date, earlier_text_not_formalised, not_an_ai_system, not_a_high_risk_ai_system, not_the_addressee_of_the_duty, compliance_required_by_31_december_2030, compliance_required_by_2_august_2030, system_already_placed_without_significant_change, duty_not_triggered, duty_applies]).

test(every_named_status_atom_is_in_the_table) :-
    provider_side_duties_status_values(StatusValues),
    named_status_atoms(Named),
    msort(StatusValues, SortedValues),
    msort(Named, SortedNamed),
    SortedNamed == SortedValues.
test(chapter_three_the_day_before_is_not_applicable) :-
    subject_status(fixture_annex_iii_day_before_application, not_applicable_on_date).
test(chapter_three_the_day_itself_applies) :-
    subject_status(fixture_annex_iii_provider_duty_applies, duty_applies).
test(annex_i_the_day_before_is_not_applicable) :-
    subject_status(fixture_annex_i_before_2_august_2028, not_applicable_on_date).
test(annex_i_the_day_itself_applies) :-
    subject_status(fixture_annex_i_on_2_august_2028, duty_applies).
test(a_system_that_is_not_high_risk) :-
    subject_status(fixture_not_a_high_risk_ai_system, not_a_high_risk_ai_system).
test(a_high_risk_system_owes_the_duty) :-
    subject_status(fixture_high_risk_ai_system_control, duty_applies).
test(an_importer_is_not_the_addressee_of_a_provider_duty) :-
    subject_status(fixture_importer_asks_a_provider_duty, not_the_addressee_of_the_duty).
test(the_provider_owes_its_duty) :-
    subject_status(fixture_provider_asks_a_provider_duty, duty_applies).
test(a_large_scale_component_before_31_december_2030) :-
    subject_status(fixture_large_scale_component_before_31_december_2030, compliance_required_by_31_december_2030).
test(a_large_scale_component_on_31_december_2030_owes_the_duty) :-
    subject_status(fixture_large_scale_component_on_31_december_2030, duty_applies).
test(a_public_authority_provider_before_2_august_2030) :-
    subject_status(fixture_public_authority_provider_before_2_august_2030, compliance_required_by_2_august_2030).
test(a_public_authority_provider_on_2_august_2030_owes_the_duty) :-
    subject_status(fixture_public_authority_provider_on_2_august_2030, duty_applies).
test(an_already_placed_system_without_change) :-
    subject_status(fixture_already_placed_importer, system_already_placed_without_significant_change).
test(a_significantly_changed_system_owes_the_duty) :-
    subject_status(fixture_already_placed_importer_with_significant_change, duty_applies).
test(logs_not_under_control_do_not_trigger) :-
    subject_status(fixture_logs_not_under_the_providers_control, duty_not_triggered).
test(logs_under_control_trigger_the_duty) :-
    subject_status(fixture_logs_under_the_providers_control, duty_applies).
test(ai_literacy_before_2_february_2025) :-
    subject_status(fixture_ai_literacy_before_chapter_i, not_applicable_on_date).
test(ai_literacy_on_2_february_2025_is_the_earlier_text) :-
    subject_status(fixture_ai_literacy_earlier_text, earlier_text_not_formalised).
test(ai_literacy_on_26_july_2026_is_the_earlier_text) :-
    subject_status(fixture_ai_literacy_day_before_pinned_text, earlier_text_not_formalised).
test(ai_literacy_on_27_july_2026_applies) :-
    subject_status(fixture_ai_literacy_deployer_applies, duty_applies).
test(an_importer_is_not_the_addressee_of_ai_literacy) :-
    subject_status(fixture_ai_literacy_importer_not_the_addressee, not_the_addressee_of_the_duty).
test(a_system_that_is_not_an_ai_system) :-
    subject_status(fixture_ai_literacy_not_an_ai_system, not_an_ai_system).
test(a_missing_role_is_named) :-
    subject_status(fixture_missing_actor_role, indeterminate([actor_role])).
test(a_given_role_settles_the_answer) :-
    subject_status(fixture_actor_role_given, duty_applies).
test(an_unsure_risk_is_referred) :-
    subject_status(fixture_unsure_risk_referral, needs_legal_review(open_textured(presents_a_risk_within_the_meaning_of_article_79_1, cite(eu_reg_2024_1689_art_24_2)), _)).
test(a_settled_risk_triggers_the_duty) :-
    subject_status(fixture_settled_risk, duty_applies).
test(a_duplicate_and_an_unknown_key_are_input_problems) :-
    subject_status(fixture_duplicate_and_unknown_keys, input_problems([duplicate_key(actor_role), unknown_key(colour)])).
test(a_well_formed_profile_is_decided) :-
    subject_status(fixture_well_formed_keys, duty_applies).
test(a_leap_day_record_ends_on_28_february) :-
    retention_period_end(documentation_keeping, date(2028, 2, 29), date(2038, 2, 28), _).

test(chapter_three_the_day_itself_is_not_inapplicable, fail) :-
    subject_status(fixture_annex_iii_provider_duty_applies, not_applicable_on_date).
test(annex_i_the_day_itself_is_not_inapplicable, fail) :-
    subject_status(fixture_annex_i_on_2_august_2028, not_applicable_on_date).
test(a_high_risk_system_is_not_reported_as_not_high_risk, fail) :-
    subject_status(fixture_high_risk_ai_system_control, not_a_high_risk_ai_system).
test(the_provider_is_the_addressee_of_its_duty, fail) :-
    subject_status(fixture_provider_asks_a_provider_duty, not_the_addressee_of_the_duty).
test(a_large_scale_component_on_31_december_2030_is_not_deferred, fail) :-
    subject_status(fixture_large_scale_component_on_31_december_2030, compliance_required_by_31_december_2030).
test(a_public_authority_provider_on_2_august_2030_is_not_deferred, fail) :-
    subject_status(fixture_public_authority_provider_on_2_august_2030, compliance_required_by_2_august_2030).
test(a_significant_change_ends_the_exemption, fail) :-
    subject_status(fixture_already_placed_importer_with_significant_change, system_already_placed_without_significant_change).
test(logs_under_control_are_not_untriggered, fail) :-
    subject_status(fixture_logs_under_the_providers_control, duty_not_triggered).
test(ai_literacy_on_2_february_2025_is_not_inapplicable, fail) :-
    subject_status(fixture_ai_literacy_earlier_text, not_applicable_on_date).
test(ai_literacy_on_27_july_2026_is_not_the_earlier_text, fail) :-
    subject_status(fixture_ai_literacy_deployer_applies, earlier_text_not_formalised).
test(a_deployer_is_the_addressee_of_ai_literacy, fail) :-
    subject_status(fixture_ai_literacy_deployer_applies, not_the_addressee_of_the_duty).
test(an_ai_system_is_not_reported_as_not_an_ai_system, fail) :-
    subject_status(fixture_ai_literacy_deployer_applies, not_an_ai_system).
test(a_given_role_is_not_missing, fail) :-
    subject_status(fixture_actor_role_given, indeterminate(_)).
test(a_settled_risk_is_not_referred, fail) :-
    subject_status(fixture_settled_risk, needs_legal_review(_, _)).
test(a_well_formed_profile_has_no_input_problem, fail) :-
    subject_status(fixture_well_formed_keys, input_problems(_)).
test(a_leap_day_record_does_not_end_on_an_impossible_day, fail) :-
    retention_period_end(documentation_keeping, date(2028, 2, 29), date(2038, 2, 29), _).

cp_test_names([every_named_status_atom_is_in_the_table, chapter_three_the_day_before_is_not_applicable, chapter_three_the_day_itself_applies, annex_i_the_day_before_is_not_applicable, annex_i_the_day_itself_applies, a_system_that_is_not_high_risk, a_high_risk_system_owes_the_duty, an_importer_is_not_the_addressee_of_a_provider_duty, the_provider_owes_its_duty, a_large_scale_component_before_31_december_2030, a_large_scale_component_on_31_december_2030_owes_the_duty, a_public_authority_provider_before_2_august_2030, a_public_authority_provider_on_2_august_2030_owes_the_duty, an_already_placed_system_without_change, a_significantly_changed_system_owes_the_duty, logs_not_under_control_do_not_trigger, logs_under_control_trigger_the_duty, ai_literacy_before_2_february_2025, ai_literacy_on_2_february_2025_is_the_earlier_text, ai_literacy_on_26_july_2026_is_the_earlier_text, ai_literacy_on_27_july_2026_applies, an_importer_is_not_the_addressee_of_ai_literacy, a_system_that_is_not_an_ai_system, a_missing_role_is_named, a_given_role_settles_the_answer, an_unsure_risk_is_referred, a_settled_risk_triggers_the_duty, a_duplicate_and_an_unknown_key_are_input_problems, a_well_formed_profile_is_decided, a_leap_day_record_ends_on_28_february]).
cp_test_fail_names([chapter_three_the_day_itself_is_not_inapplicable, annex_i_the_day_itself_is_not_inapplicable, a_high_risk_system_is_not_reported_as_not_high_risk, the_provider_is_the_addressee_of_its_duty, a_large_scale_component_on_31_december_2030_is_not_deferred, a_public_authority_provider_on_2_august_2030_is_not_deferred, a_significant_change_ends_the_exemption, logs_under_control_are_not_untriggered, ai_literacy_on_2_february_2025_is_not_inapplicable, ai_literacy_on_27_july_2026_is_not_the_earlier_text, a_deployer_is_the_addressee_of_ai_literacy, an_ai_system_is_not_reported_as_not_an_ai_system, a_given_role_is_not_missing, a_settled_risk_is_not_referred, a_well_formed_profile_has_no_input_problem, a_leap_day_record_does_not_end_on_an_impossible_day]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
