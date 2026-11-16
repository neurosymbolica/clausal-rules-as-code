% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_provider_side_duties_tests_test_input_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_provider_side_duties_provider_side_duties, [operator_duty_status/5, retention_period_end/4, provider_side_duties_status/2, provider_side_duties_status_values/1]).
:- use_module(m__eu_ai_act_provider_side_duties_kernel, [provider_side_duties_input_problems/2]).
:- use_module(m__eu_ai_act_provider_side_duties_fixtures, [provider_side_duties_subject/1, provider_side_duties_profile_for/2]).

expected_status(fixture_annex_iii_provider_duty_applies, duty_applies).
expected_status(fixture_annex_iii_day_before_application, not_applicable_on_date).
expected_status(fixture_annex_i_before_2_august_2028, not_applicable_on_date).
expected_status(fixture_annex_i_on_2_august_2028, duty_applies).
expected_status(fixture_not_a_high_risk_ai_system, not_a_high_risk_ai_system).
expected_status(fixture_high_risk_ai_system_control, duty_applies).
expected_status(fixture_importer_asks_a_provider_duty, not_the_addressee_of_the_duty).
expected_status(fixture_provider_asks_a_provider_duty, duty_applies).
expected_status(fixture_large_scale_component_before_31_december_2030, compliance_required_by_31_december_2030).
expected_status(fixture_large_scale_component_on_31_december_2030, duty_applies).
expected_status(fixture_public_authority_provider_before_2_august_2030, compliance_required_by_2_august_2030).
expected_status(fixture_public_authority_provider_on_2_august_2030, duty_applies).
expected_status(fixture_already_placed_importer, system_already_placed_without_significant_change).
expected_status(fixture_already_placed_importer_with_significant_change, duty_applies).
expected_status(fixture_logs_not_under_the_providers_control, duty_not_triggered).
expected_status(fixture_logs_under_the_providers_control, duty_applies).
expected_status(fixture_ai_literacy_before_chapter_i, not_applicable_on_date).
expected_status(fixture_ai_literacy_earlier_text, earlier_text_not_formalised).
expected_status(fixture_ai_literacy_day_before_pinned_text, earlier_text_not_formalised).
expected_status(fixture_ai_literacy_deployer_applies, duty_applies).
expected_status(fixture_ai_literacy_not_an_ai_system, not_an_ai_system).
expected_status(fixture_ai_literacy_importer_not_the_addressee, not_the_addressee_of_the_duty).
expected_status(fixture_missing_actor_role, indeterminate([actor_role])).
expected_status(fixture_actor_role_given, duty_applies).
expected_status(fixture_empty_profile, indeterminate([high_risk_ai_system])).
expected_status(fixture_unsure_risk_referral, needs_legal_review(open_textured(presents_a_risk_within_the_meaning_of_article_79_1, cite(eu_reg_2024_1689_art_24_2)), [inputs_relied_on([significant_change_in_design_as_from_the_date_of_application_of_chapter_iii - false, presents_a_risk_within_the_meaning_of_article_79_1 - unsure])])).
expected_status(fixture_settled_risk, duty_applies).
expected_status(fixture_duplicate_and_unknown_keys, input_problems([duplicate_key(actor_role), unknown_key(colour)])).
expected_status(fixture_well_formed_keys, duty_applies).

bound_status_holds(Subject) :-
    expected_status(Subject, Status),
    provider_side_duties_profile_for(Subject, Case),
    provider_side_duties_status(Case, Status).

wrong_bound_status(Subject, Other) :-
    expected_status(Subject, Status),
    provider_side_duties_profile_for(Subject, Case),
    provider_side_duties_status_values(StatusValues),
    member(Other, StatusValues),
    dif(Other, Status),
    provider_side_duties_status(Case, Other).

test(every_subject_has_an_expected_status) :-
    findall(Subject, provider_side_duties_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, expected_status(Subject, _), ExpectedSubjects),
    sort(ExpectedSubjects, ExpectedSet),
    ExpectedSet == SubjectSet.
test(every_expected_status_holds_with_the_verdict_bound) :-
    findall(Subject, expected_status(Subject, _), Subjects),
    findall(Subject, bound_status_holds(Subject), HoldingSubjects),
    HoldingSubjects == Subjects.
test(the_citations_bound_with_the_result) :-
    provider_side_duties_profile_for(fixture_logs_under_the_providers_control, duty_case(Profile, Duty, AssessmentDate)),
    sort([cite(eu_reg_2024_1689_art_16_e), cite(eu_reg_2024_1689_art_19_1)], Citations),
    operator_duty_status(Profile, Duty, AssessmentDate, duty_applies, Citations).
test(a_not_final_answer_bound_with_empty_citations) :-
    operator_duty_status([], compliance_with_the_requirements_of_section_2, date(2029, 1, 1), indeterminate([high_risk_ai_system]), []).
test(an_input_problem_bound) :-
    operator_duty_status([attribute(colour, blue)], ce_marking, date(2029, 1, 1), input_problems([unknown_key(colour)]), []).
test(a_retention_end_bound) :-
    retention_period_end(log_keeping, date(2028, 3, 15), date(2028, 9, 15), [cite(eu_reg_2024_1689_art_19_1)]).
test(a_ten_year_retention_end_bound) :-
    retention_period_end(documentation_keeping, date(2028, 2, 29), date(2038, 2, 28), [cite(eu_reg_2024_1689_art_18_1)]).
test(the_input_check_with_its_problems_bound) :-
    provider_side_duties_input_problems([attribute(colour, blue)], [unknown_key(colour)]).

test(no_other_table_status_holds_with_the_verdict_bound, fail) :-
    wrong_bound_status(_, _).
test(wrong_citations_bound_with_the_result, fail) :-
    provider_side_duties_profile_for(fixture_logs_under_the_providers_control, duty_case(Profile, Duty, AssessmentDate)),
    operator_duty_status(Profile, Duty, AssessmentDate, duty_applies, [cite(eu_reg_2024_1689_art_16_e)]).
test(a_wrong_retention_end_bound, fail) :-
    retention_period_end(log_keeping, date(2028, 3, 15), date(2028, 9, 14), _).
test(the_input_check_with_no_problems_bound_for_a_bad_profile, fail) :-
    provider_side_duties_input_problems([attribute(colour, blue)], []).

cp_test_names([every_subject_has_an_expected_status, every_expected_status_holds_with_the_verdict_bound, the_citations_bound_with_the_result, a_not_final_answer_bound_with_empty_citations, an_input_problem_bound, a_retention_end_bound, a_ten_year_retention_end_bound, the_input_check_with_its_problems_bound]).
cp_test_fail_names([no_other_table_status_holds_with_the_verdict_bound, wrong_citations_bound_with_the_result, a_wrong_retention_end_bound, the_input_check_with_no_problems_bound_for_a_bad_profile]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
