% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_provider_side_duties_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_provider_side_duties_provider_side_duties, [operator_duty_status/5, retention_period_end/4, decide_provider_side_duties/2, provider_side_duties_status/2, provider_side_duties_checklist/2, provider_side_duties_decision_resolvable/1, provider_side_duties_status_values/1]).
:- use_module(m__eu_ai_act_provider_side_duties_kernel, [provider_side_duties_input_problems/2]).
:- use_module(m__eu_ai_act_provider_side_duties_fixtures, [provider_side_duties_subject/1, provider_side_duties_profile_for/2, provider_side_duties_assess/2]).

answers_once(Subject, Status, Citations) :-
    findall(Verdict, provider_side_duties_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1),
    member(provider_side_duties_verdict(FoundStatus, FoundCitations), Verdicts),
    FoundStatus == Status,
    sort(FoundCitations, SortedCitations),
    sort(Citations, SortedCitations).

chapter_three_date_citations([cite(eu_reg_2024_1689_art_113_c), cite(eu_reg_2024_1689_art_113_c_i), cite(eu_reg_2024_1689_art_113_c_ii)]).

has_checklist(Subject) :-
    provider_side_duties_profile_for(Subject, Case),
    provider_side_duties_checklist(Case, [_|_]).

resolvable(Subject) :-
    provider_side_duties_profile_for(Subject, Case),
    provider_side_duties_decision_resolvable(Case).

trailing_context_allowed([]).
trailing_context_allowed([provenance(_, _)]).

test(fixture_annex_iii_provider_duty_applies) :-
    answers_once(fixture_annex_iii_provider_duty_applies, duty_applies, [cite(eu_reg_2024_1689_art_16_h)]).
test(fixture_annex_iii_day_before_application) :-
    chapter_three_date_citations(Citations),
    answers_once(fixture_annex_iii_day_before_application, not_applicable_on_date, Citations).
test(fixture_annex_i_before_2_august_2028) :-
    chapter_three_date_citations(Citations),
    answers_once(fixture_annex_i_before_2_august_2028, not_applicable_on_date, Citations).
test(fixture_annex_i_on_2_august_2028) :-
    answers_once(fixture_annex_i_on_2_august_2028, duty_applies, [cite(eu_reg_2024_1689_art_16_h)]).
test(fixture_not_a_high_risk_ai_system) :-
    answers_once(fixture_not_a_high_risk_ai_system, not_a_high_risk_ai_system, [cite(eu_reg_2024_1689_art_16_h)]).
test(fixture_high_risk_ai_system_control) :-
    answers_once(fixture_high_risk_ai_system_control, duty_applies, [cite(eu_reg_2024_1689_art_16_h)]).
test(fixture_importer_asks_a_provider_duty) :-
    answers_once(fixture_importer_asks_a_provider_duty, not_the_addressee_of_the_duty, [cite(eu_reg_2024_1689_art_16_c), cite(eu_reg_2024_1689_art_3_3)]).
test(fixture_provider_asks_a_provider_duty) :-
    answers_once(fixture_provider_asks_a_provider_duty, duty_applies, [cite(eu_reg_2024_1689_art_16_c)]).
test(fixture_large_scale_component_before_31_december_2030) :-
    answers_once(fixture_large_scale_component_before_31_december_2030, compliance_required_by_31_december_2030, [cite(eu_reg_2024_1689_art_16_h), cite(eu_reg_2024_1689_art_111_1)]).
test(fixture_large_scale_component_on_31_december_2030) :-
    answers_once(fixture_large_scale_component_on_31_december_2030, duty_applies, [cite(eu_reg_2024_1689_art_16_h)]).
test(fixture_public_authority_provider_before_2_august_2030) :-
    answers_once(fixture_public_authority_provider_before_2_august_2030, compliance_required_by_2_august_2030, [cite(eu_reg_2024_1689_art_16_i), cite(eu_reg_2024_1689_art_111_2)]).
test(fixture_public_authority_provider_on_2_august_2030) :-
    answers_once(fixture_public_authority_provider_on_2_august_2030, duty_applies, [cite(eu_reg_2024_1689_art_16_i)]).
test(fixture_already_placed_importer) :-
    answers_once(fixture_already_placed_importer, system_already_placed_without_significant_change, [cite(eu_reg_2024_1689_art_23_3), cite(eu_reg_2024_1689_art_111_2)]).
test(fixture_already_placed_importer_with_significant_change) :-
    answers_once(fixture_already_placed_importer_with_significant_change, duty_applies, [cite(eu_reg_2024_1689_art_23_3)]).
test(fixture_logs_not_under_the_providers_control) :-
    answers_once(fixture_logs_not_under_the_providers_control, duty_not_triggered, [cite(eu_reg_2024_1689_art_16_e), cite(eu_reg_2024_1689_art_19_1)]).
test(fixture_logs_under_the_providers_control) :-
    answers_once(fixture_logs_under_the_providers_control, duty_applies, [cite(eu_reg_2024_1689_art_16_e), cite(eu_reg_2024_1689_art_19_1)]).
test(fixture_ai_literacy_before_chapter_i) :-
    answers_once(fixture_ai_literacy_before_chapter_i, not_applicable_on_date, [cite(eu_reg_2024_1689_art_113_a)]).
test(fixture_ai_literacy_earlier_text) :-
    answers_once(fixture_ai_literacy_earlier_text, earlier_text_not_formalised, [cite(eu_reg_2024_1689_art_113_a)]).
test(fixture_ai_literacy_day_before_pinned_text) :-
    answers_once(fixture_ai_literacy_day_before_pinned_text, earlier_text_not_formalised, [cite(eu_reg_2024_1689_art_113_a)]).
test(fixture_ai_literacy_deployer_applies) :-
    answers_once(fixture_ai_literacy_deployer_applies, duty_applies, [cite(eu_reg_2024_1689_art_4_1)]).
test(fixture_ai_literacy_not_an_ai_system) :-
    answers_once(fixture_ai_literacy_not_an_ai_system, not_an_ai_system, [cite(eu_reg_2024_1689_art_3_1), cite(eu_reg_2024_1689_art_4_1)]).
test(fixture_ai_literacy_importer_not_the_addressee) :-
    answers_once(fixture_ai_literacy_importer_not_the_addressee, not_the_addressee_of_the_duty, [cite(eu_reg_2024_1689_art_3_3), cite(eu_reg_2024_1689_art_3_4), cite(eu_reg_2024_1689_art_4_1)]).
test(fixture_missing_actor_role) :-
    answers_once(fixture_missing_actor_role, indeterminate([actor_role]), []).
test(fixture_actor_role_given) :-
    answers_once(fixture_actor_role_given, duty_applies, [cite(eu_reg_2024_1689_art_4_1)]).
test(fixture_empty_profile) :-
    answers_once(fixture_empty_profile, indeterminate([high_risk_ai_system]), []).
test(fixture_unsure_risk_referral) :-
    answers_once(fixture_unsure_risk_referral, needs_legal_review(open_textured(presents_a_risk_within_the_meaning_of_article_79_1, cite(eu_reg_2024_1689_art_24_2)), [inputs_relied_on([significant_change_in_design_as_from_the_date_of_application_of_chapter_iii - false, presents_a_risk_within_the_meaning_of_article_79_1 - unsure])]), []).
test(fixture_settled_risk) :-
    answers_once(fixture_settled_risk, duty_applies, [cite(eu_reg_2024_1689_art_24_2), cite(eu_reg_2024_1689_art_24_4)]).
test(a_referral_context_has_at_most_a_provenance_marker_after_its_pairs) :-
    provider_side_duties_assess(fixture_unsure_risk_referral, provider_side_duties_verdict(needs_legal_review(_, [inputs_relied_on(_)|Trailing]), [])),
    trailing_context_allowed(Trailing).
test(a_provenance_marker_is_an_allowed_trailing_context_element) :-
    Marker = provenance(distributor_information_on_a_risk, [cite(eu_reg_2024_1689_art_24_2)]),
    functor(Marker, provenance, 2),
    trailing_context_allowed([Marker]).
test(no_trailing_element_is_also_allowed) :-
    trailing_context_allowed([]).
test(fixture_duplicate_and_unknown_keys) :-
    answers_once(fixture_duplicate_and_unknown_keys, input_problems([duplicate_key(actor_role), unknown_key(colour)]), []).
test(fixture_well_formed_keys) :-
    answers_once(fixture_well_formed_keys, duty_applies, [cite(eu_reg_2024_1689_art_4_1)]).
test(the_input_check_through_the_facade) :-
    provider_side_duties_input_problems([attribute(actor_role, provider), attribute(actor_role, deployer), attribute(colour, blue)], Problems),
    Problems == [duplicate_key(actor_role), unknown_key(colour)].
test(a_well_formed_profile_has_no_problem) :-
    provider_side_duties_input_problems([attribute(actor_role, provider), attribute(ai_system, true)], []).
test(every_subject_has_a_checklist) :-
    findall(Subject, provider_side_duties_subject(Subject), Subjects),
    length(Subjects, SubjectCount),
    SubjectCount > 0,
    maplist(has_checklist, Subjects).
test(every_subject_is_resolvable) :-
    findall(Subject, provider_side_duties_subject(Subject), Subjects),
    maplist(resolvable, Subjects).
test(a_final_status_is_a_status_value) :-
    provider_side_duties_profile_for(fixture_annex_iii_provider_duty_applies, Case),
    provider_side_duties_status(Case, Status),
    provider_side_duties_status_values(StatusValues),
    member(Status, StatusValues).
test(the_checklist_carries_the_citation) :-
    provider_side_duties_profile_for(fixture_annex_iii_provider_duty_applies, Case),
    provider_side_duties_checklist(Case, Checklist),
    Checklist == [item(ce_marking, duty_applies, [cite(eu_reg_2024_1689_art_16_h)])].
test(decide_matches_the_contract_predicate) :-
    provider_side_duties_profile_for(fixture_already_placed_importer, duty_case(Profile, Duty, AssessmentDate)),
    findall(Result - Citations, operator_duty_status(Profile, Duty, AssessmentDate, Result, Citations), Answers),
    length(Answers, 1),
    decide_provider_side_duties(duty_case(Profile, Duty, AssessmentDate), provider_side_duties_verdict(Status, VerdictCitations)),
    Answers == [Status - VerdictCitations].
test(argument_problems_through_the_facade) :-
    findall(Result - Citations, operator_duty_status([attribute(colour, blue)], unknown_duty, date(2026, 2, 30), Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour), wrong_type(duty), wrong_type(assessment_date)]) - []].
test(a_ten_year_record) :-
    findall(EndDate - Citations, retention_period_end(documentation_keeping, date(2028, 3, 15), EndDate, Citations), Answers),
    Answers == [date(2038, 3, 15) - [cite(eu_reg_2024_1689_art_18_1)]].
test(six_month_logs) :-
    retention_period_end(log_keeping, date(2028, 3, 15), date(2028, 9, 15), [cite(eu_reg_2024_1689_art_19_1)]).
test(a_leap_day_moves_to_february_28) :-
    retention_period_end(importer_keeping_of_copies, date(2028, 2, 29), date(2038, 2, 28), [cite(eu_reg_2024_1689_art_23_5)]).
test(logs_from_august_31_end_on_february_28) :-
    retention_period_end(log_keeping, date(2028, 8, 31), date(2029, 2, 28), [cite(eu_reg_2024_1689_art_19_1)]).
test(a_representative_record_above_year_9999) :-
    retention_period_end(keeping_of_the_provider_contact_details_and_documents, date(9999, 3, 1), date(10009, 3, 1), [cite(eu_reg_2024_1689_art_22_3_b)]).
test(retention_argument_problems) :-
    findall(EndDate - Citations, retention_period_end(ce_marking, date(2026, 13, 1), EndDate, Citations), Answers),
    Answers == [input_problems([wrong_type(keeping_duty), wrong_type(start_date)]) - []].

test(fixture_annex_iii_provider_duty_applies_is_not_not_applicable, fail) :-
    provider_side_duties_assess(fixture_annex_iii_provider_duty_applies, provider_side_duties_verdict(not_applicable_on_date, _)).
test(fixture_high_risk_ai_system_control_is_not_low_risk, fail) :-
    provider_side_duties_assess(fixture_high_risk_ai_system_control, provider_side_duties_verdict(not_a_high_risk_ai_system, _)).
test(a_large_scale_component_is_never_the_august_2030_answer, fail) :-
    provider_side_duties_assess(fixture_large_scale_component_before_31_december_2030, provider_side_duties_verdict(compliance_required_by_2_august_2030, _)).
test(fixture_logs_not_under_control_do_not_apply, fail) :-
    provider_side_duties_assess(fixture_logs_not_under_the_providers_control, provider_side_duties_verdict(duty_applies, _)).
test(a_trailing_element_other_than_provenance_is_not_allowed, fail) :-
    trailing_context_allowed([inputs_relied_on([])]).

cp_test_names([fixture_annex_iii_provider_duty_applies, fixture_annex_iii_day_before_application, fixture_annex_i_before_2_august_2028, fixture_annex_i_on_2_august_2028, fixture_not_a_high_risk_ai_system, fixture_high_risk_ai_system_control, fixture_importer_asks_a_provider_duty, fixture_provider_asks_a_provider_duty, fixture_large_scale_component_before_31_december_2030, fixture_large_scale_component_on_31_december_2030, fixture_public_authority_provider_before_2_august_2030, fixture_public_authority_provider_on_2_august_2030, fixture_already_placed_importer, fixture_already_placed_importer_with_significant_change, fixture_logs_not_under_the_providers_control, fixture_logs_under_the_providers_control, fixture_ai_literacy_before_chapter_i, fixture_ai_literacy_earlier_text, fixture_ai_literacy_day_before_pinned_text, fixture_ai_literacy_deployer_applies, fixture_ai_literacy_not_an_ai_system, fixture_ai_literacy_importer_not_the_addressee, fixture_missing_actor_role, fixture_actor_role_given, fixture_empty_profile, fixture_unsure_risk_referral, fixture_settled_risk, a_referral_context_has_at_most_a_provenance_marker_after_its_pairs, a_provenance_marker_is_an_allowed_trailing_context_element, no_trailing_element_is_also_allowed, fixture_duplicate_and_unknown_keys, fixture_well_formed_keys, the_input_check_through_the_facade, a_well_formed_profile_has_no_problem, every_subject_has_a_checklist, every_subject_is_resolvable, a_final_status_is_a_status_value, the_checklist_carries_the_citation, decide_matches_the_contract_predicate, argument_problems_through_the_facade, a_ten_year_record, six_month_logs, a_leap_day_moves_to_february_28, logs_from_august_31_end_on_february_28, a_representative_record_above_year_9999, retention_argument_problems]).
cp_test_fail_names([fixture_annex_iii_provider_duty_applies_is_not_not_applicable, fixture_high_risk_ai_system_control_is_not_low_risk, a_large_scale_component_is_never_the_august_2030_answer, fixture_logs_not_under_control_do_not_apply, a_trailing_element_other_than_provenance_is_not_allowed]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
