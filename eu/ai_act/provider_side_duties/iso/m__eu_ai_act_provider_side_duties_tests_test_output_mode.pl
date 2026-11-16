% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_provider_side_duties_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_provider_side_duties_provider_side_duties, [decide_provider_side_duties/2, operator_duty_status/5, retention_period_end/4]).
:- use_module(m__eu_ai_act_provider_side_duties_fixtures, [provider_side_duties_profile_for/2]).

subject_verdicts(Subject, Verdicts) :-
    provider_side_duties_profile_for(Subject, Case),
    findall(Verdict, decide_provider_side_duties(Case, Verdict), Verdicts).

chapter_three_date_citations(Citations) :-
    sort([cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i), cite(eu_reg_2024_1689_art_113_c_ii)], Citations).

test(the_day_before_2_december_2027) :-
    subject_verdicts(fixture_annex_iii_day_before_application, Verdicts),
    chapter_three_date_citations(Citations),
    Verdicts == [provider_side_duties_verdict(not_applicable_on_date, Citations)].
test(on_2_december_2027) :-
    subject_verdicts(fixture_annex_iii_provider_duty_applies, Verdicts),
    Verdicts == [provider_side_duties_verdict(duty_applies, [cite(eu_reg_2024_1689_art_16_h)])].
test(the_annex_i_route_on_1_august_2028) :-
    subject_verdicts(fixture_annex_i_before_2_august_2028, Verdicts),
    chapter_three_date_citations(Citations),
    Verdicts == [provider_side_duties_verdict(not_applicable_on_date, Citations)].
test(the_annex_i_route_on_2_august_2028) :-
    subject_verdicts(fixture_annex_i_on_2_august_2028, Verdicts),
    Verdicts == [provider_side_duties_verdict(duty_applies, [cite(eu_reg_2024_1689_art_16_h)])].
test(not_a_high_risk_system_carries_the_duty_citations) :-
    subject_verdicts(fixture_not_a_high_risk_ai_system, Verdicts),
    Verdicts == [provider_side_duties_verdict(not_a_high_risk_ai_system, [cite(eu_reg_2024_1689_art_16_h)])].
test(not_the_addressee_carries_the_role_citation) :-
    subject_verdicts(fixture_importer_asks_a_provider_duty, Verdicts),
    sort([cite(eu_reg_2024_1689_art_16_c), cite(eu_reg_2024_1689_art_3_3)], Citations),
    Verdicts == [provider_side_duties_verdict(not_the_addressee_of_the_duty, Citations)].
test(a_large_scale_component_on_30_december_2030) :-
    subject_verdicts(fixture_large_scale_component_before_31_december_2030, Verdicts),
    sort([cite(eu_reg_2024_1689_art_16_h), cite(eu_reg_2024_1689_art_111_1)], Citations),
    Verdicts == [provider_side_duties_verdict(compliance_required_by_31_december_2030, Citations)].
test(a_large_scale_component_on_31_december_2030) :-
    subject_verdicts(fixture_large_scale_component_on_31_december_2030, Verdicts),
    Verdicts == [provider_side_duties_verdict(duty_applies, [cite(eu_reg_2024_1689_art_16_h)])].
test(a_public_authority_provider_on_1_august_2030) :-
    subject_verdicts(fixture_public_authority_provider_before_2_august_2030, Verdicts),
    sort([cite(eu_reg_2024_1689_art_16_i), cite(eu_reg_2024_1689_art_111_2)], Citations),
    Verdicts == [provider_side_duties_verdict(compliance_required_by_2_august_2030, Citations)].
test(a_public_authority_provider_on_2_august_2030) :-
    subject_verdicts(fixture_public_authority_provider_on_2_august_2030, Verdicts),
    Verdicts == [provider_side_duties_verdict(duty_applies, [cite(eu_reg_2024_1689_art_16_i)])].
test(an_already_placed_importer) :-
    subject_verdicts(fixture_already_placed_importer, Verdicts),
    sort([cite(eu_reg_2024_1689_art_23_3), cite(eu_reg_2024_1689_art_111_2)], Citations),
    Verdicts == [provider_side_duties_verdict(system_already_placed_without_significant_change, Citations)].
test(logs_not_under_control) :-
    subject_verdicts(fixture_logs_not_under_the_providers_control, Verdicts),
    sort([cite(eu_reg_2024_1689_art_16_e), cite(eu_reg_2024_1689_art_19_1)], Citations),
    Verdicts == [provider_side_duties_verdict(duty_not_triggered, Citations)].
test(ai_literacy_on_1_february_2025) :-
    subject_verdicts(fixture_ai_literacy_before_chapter_i, Verdicts),
    Verdicts == [provider_side_duties_verdict(not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_a)])].
test(ai_literacy_on_2_february_2025) :-
    subject_verdicts(fixture_ai_literacy_earlier_text, Verdicts),
    Verdicts == [provider_side_duties_verdict(earlier_text_not_formalised, [cite(eu_reg_2024_1689_art_113_a)])].
test(ai_literacy_on_26_july_2026) :-
    subject_verdicts(fixture_ai_literacy_day_before_pinned_text, Verdicts),
    Verdicts == [provider_side_duties_verdict(earlier_text_not_formalised, [cite(eu_reg_2024_1689_art_113_a)])].
test(ai_literacy_on_27_july_2026) :-
    subject_verdicts(fixture_ai_literacy_deployer_applies, Verdicts),
    Verdicts == [provider_side_duties_verdict(duty_applies, [cite(eu_reg_2024_1689_art_4_1)])].
test(ai_literacy_not_an_ai_system) :-
    subject_verdicts(fixture_ai_literacy_not_an_ai_system, Verdicts),
    sort([cite(eu_reg_2024_1689_art_3_1), cite(eu_reg_2024_1689_art_4_1)], Citations),
    Verdicts == [provider_side_duties_verdict(not_an_ai_system, Citations)].
test(a_missing_key_is_read_out) :-
    subject_verdicts(fixture_missing_actor_role, Verdicts),
    Verdicts == [provider_side_duties_verdict(indeterminate([actor_role]), [])].
test(a_referral_is_read_out) :-
    subject_verdicts(fixture_unsure_risk_referral, [provider_side_duties_verdict(Status, Citations)]),
    Status = needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(_)]),
    Key == presents_a_risk_within_the_meaning_of_article_79_1,
    Citation == cite(eu_reg_2024_1689_art_24_2),
    Citations == [].
test(input_problems_are_read_out) :-
    subject_verdicts(fixture_duplicate_and_unknown_keys, Verdicts),
    Verdicts == [provider_side_duties_verdict(input_problems([duplicate_key(actor_role), unknown_key(colour)]), [])].
test(the_result_and_citations_are_read_out_of_the_query) :-
    findall(Result - Citations, operator_duty_status([attribute(actor_role, provider), attribute(ai_system, true)], ai_literacy_measures, date(2027, 1, 1), Result, Citations), Answers),
    Answers == [duty_applies - [cite(eu_reg_2024_1689_art_4_1)]].
test(every_retention_end_is_read_out) :-
    findall(KeepingDuty - EndDate, (member(KeepingDuty, [documentation_keeping, keeping_of_the_provider_contact_details_and_documents, importer_keeping_of_copies, log_keeping]), retention_period_end(KeepingDuty, date(2028, 3, 15), EndDate, _)), Answers),
    Answers == [documentation_keeping - date(2038, 3, 15), keeping_of_the_provider_contact_details_and_documents - date(2038, 3, 15), importer_keeping_of_copies - date(2038, 3, 15), log_keeping - date(2028, 9, 15)].
test(logs_from_31_august_end_on_28_february) :-
    findall(EndDate - Citations, retention_period_end(log_keeping, date(2028, 8, 31), EndDate, Citations), Answers),
    Answers == [date(2029, 2, 28) - [cite(eu_reg_2024_1689_art_19_1)]].
test(logs_cross_the_year_end) :-
    retention_period_end(log_keeping, date(2028, 10, 31), EndDate, _),
    EndDate == date(2029, 4, 30).

cp_test_names([the_day_before_2_december_2027, on_2_december_2027, the_annex_i_route_on_1_august_2028, the_annex_i_route_on_2_august_2028, not_a_high_risk_system_carries_the_duty_citations, not_the_addressee_carries_the_role_citation, a_large_scale_component_on_30_december_2030, a_large_scale_component_on_31_december_2030, a_public_authority_provider_on_1_august_2030, a_public_authority_provider_on_2_august_2030, an_already_placed_importer, logs_not_under_control, ai_literacy_on_1_february_2025, ai_literacy_on_2_february_2025, ai_literacy_on_26_july_2026, ai_literacy_on_27_july_2026, ai_literacy_not_an_ai_system, a_missing_key_is_read_out, a_referral_is_read_out, input_problems_are_read_out, the_result_and_citations_are_read_out_of_the_query, every_retention_end_is_read_out, logs_from_31_august_end_on_28_february, logs_cross_the_year_end]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
