% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_deployer_duties_fria_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_deployer_duties_fria_queries, [deployer_duties_fria_profile_keys/1, deployer_duties_fria_what_if/4, deployer_duties_fria_obligation_status/2, deployer_duties_fria_compliance_check/2, deployer_duties_fria_chapter_iii_date/2]).
:- use_module(m__eu_ai_act_deployer_duties_fria_kernel, [deployer_duties_fria_input_problems/2]).
:- use_module(m__eu_ai_act_deployer_duties_fria_deployer_duties_fria, [deployer_duties_fria_status/2, deployer_duties_fria_checklist/2]).
:- use_module(m__eu_ai_act_deployer_duties_fria_fixtures, [deployer_duties_fria_profile_for/2]).

item_cited(item(_, _, cite(_))).
item_cited(item(_, _, [_|_])).

test(profile_keys_are_the_contract_keys) :-
    deployer_duties_fria_profile_keys(ProfileKeys),
    ProfileKeys == [deployer_of_the_system, system_is_a_high_risk_ai_system_listed_in_annex_iii, system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, logs_automatically_generated_by_the_system_under_the_deployers_control, union_or_national_law_provides_otherwise_on_the_log_retention_period, deployer_is_an_employer, put_into_service_or_used_at_the_workplace, makes_or_assists_in_making_decisions_related_to_natural_persons, used_for_law_enforcement_purposes, system_listed_under_point_2_of_annex_iii, body_governed_by_public_law, private_entity_providing_public_services, system_listed_under_point_5_b_of_annex_iii, system_listed_under_point_5_c_of_annex_iii, exempt_from_notification_in_the_case_of_article_46_1, component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_chapter_iii_date, significant_changes_in_design_as_from_the_chapter_iii_date, intended_to_be_used_by_public_authorities].
test(the_input_check_is_re_exported) :-
    deployer_duties_fria_input_problems([attribute(colour, blue)], Problems),
    Problems == [unknown_key(colour)].
test(status_answers_the_base_request) :-
    deployer_duties_fria_profile_for(log_retention_applies, Request),
    findall(Status, deployer_duties_fria_status(Request, Status), Statuses),
    Statuses == [obligation_applies].
test(what_if_the_logs_are_not_under_control) :-
    deployer_duties_fria_profile_for(log_retention_applies, Request),
    deployer_duties_fria_what_if(Request, logs_automatically_generated_by_the_system_under_the_deployers_control, false, Status),
    Status == obligation_does_not_apply.
test(what_if_back_to_the_given_value_changes_nothing) :-
    deployer_duties_fria_profile_for(logs_not_under_control, Request),
    deployer_duties_fria_what_if(Request, logs_automatically_generated_by_the_system_under_the_deployers_control, true, Status),
    Status == obligation_applies.
test(what_if_answers_exactly_once) :-
    deployer_duties_fria_profile_for(retention_of_five_months, Request),
    findall(Status, deployer_duties_fria_what_if(Request, union_or_national_law_provides_otherwise_on_the_log_retention_period, true, Status), Statuses),
    Statuses == [period_set_by_other_union_or_national_law].
test(obligation_surfacing_lists_all_five_duties_of_the_base_deployer) :-
    deployer_duties_fria_profile_for(log_retention_applies, deployer_obligation_request(Profile, _, AssessmentDate)),
    findall(Obligation - Result, (member(Obligation, [log_retention, information_of_workers_and_their_representatives, information_of_natural_persons_subject_to_decisions, fundamental_rights_impact_assessment, notification_of_assessment_results]), deployer_duties_fria_obligation_status(deployer_obligation_request(Profile, Obligation, AssessmentDate), Result)), Surfaced),
    Surfaced == [log_retention - obligation_applies, information_of_workers_and_their_representatives - obligation_applies, information_of_natural_persons_subject_to_decisions - obligation_applies, fundamental_rights_impact_assessment - obligation_applies, notification_of_assessment_results - obligation_applies].
test(obligation_surfacing_for_a_private_non_public_deployer) :-
    deployer_duties_fria_profile_for(log_retention_applies, deployer_obligation_request(Profile, _, AssessmentDate)),
    deployer_duties_fria_what_if(deployer_obligation_request(Profile, fundamental_rights_impact_assessment, AssessmentDate), body_governed_by_public_law, false, Result),
    Result == obligation_does_not_apply.
test(compliance_check_accepts_six_months) :-
    deployer_duties_fria_profile_for(retention_of_six_months, Request),
    deployer_duties_fria_compliance_check(Request, Result),
    Result == retention_period_of_at_least_six_months.
test(compliance_check_rejects_five_months) :-
    deployer_duties_fria_profile_for(retention_of_five_months, Request),
    deployer_duties_fria_compliance_check(Request, Result),
    Result == retention_period_shorter_than_six_months.
test(a_system_under_both_routes_takes_the_earlier_date) :-
    deployer_duties_fria_chapter_iii_date([attribute(system_is_a_high_risk_ai_system_listed_in_annex_iii, true), attribute(system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, true)], ChapterThreeDate),
    ChapterThreeDate == date(2027, 12, 2).
test(an_annex_i_only_system_takes_the_later_date) :-
    deployer_duties_fria_chapter_iii_date([attribute(system_is_a_high_risk_ai_system_listed_in_annex_iii, false), attribute(system_is_a_high_risk_ai_system_under_article_6_1_and_annex_i, true)], ChapterThreeDate),
    ChapterThreeDate == date(2028, 8, 2).
test(the_checklist_carries_a_citation_on_every_item) :-
    deployer_duties_fria_profile_for(log_retention_applies, Request),
    deployer_duties_fria_checklist(Request, Checklist),
    Checklist = [_|_],
    maplist(item_cited, Checklist),
    member(item(determination, obligation_applies, Citations), Checklist),
    Citations == [cite(eu_reg_2024_1689_art_26_6)].
test(the_checklist_marks_the_unmet_date) :-
    deployer_duties_fria_profile_for(day_before_first_chapter_iii_day, Request),
    deployer_duties_fria_checklist(Request, Checklist),
    member(item(chapter_iii_application, unmet(before_chapter_iii_application_date), cite(eu_reg_2024_1689_art_113_c)), Checklist).
test(the_checklist_of_a_refused_request_is_the_input_check) :-
    deployer_duties_fria_profile_for(unknown_profile_key, Request),
    deployer_duties_fria_checklist(Request, Checklist),
    Checklist == [item(input_check, input_problems([unknown_key(colour)]), [])].

test(a_malformed_profile_has_no_chapter_iii_date, fail) :-
    deployer_duties_fria_chapter_iii_date([attribute(system_is_a_high_risk_ai_system_listed_in_annex_iii, unsure)], _).

cp_test_names([profile_keys_are_the_contract_keys, the_input_check_is_re_exported, status_answers_the_base_request, what_if_the_logs_are_not_under_control, what_if_back_to_the_given_value_changes_nothing, what_if_answers_exactly_once, obligation_surfacing_lists_all_five_duties_of_the_base_deployer, obligation_surfacing_for_a_private_non_public_deployer, compliance_check_accepts_six_months, compliance_check_rejects_five_months, a_system_under_both_routes_takes_the_earlier_date, an_annex_i_only_system_takes_the_later_date, the_checklist_carries_a_citation_on_every_item, the_checklist_marks_the_unmet_date, the_checklist_of_a_refused_request_is_the_input_check]).
cp_test_fail_names([a_malformed_profile_has_no_chapter_iii_date]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
