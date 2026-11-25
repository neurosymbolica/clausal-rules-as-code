% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_conformity_marking_registration_tests_test_queries, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_ai_act_conformity_marking_registration_queries, [conformity_marking_registration_profile_keys/1, conformity_marking_registration_what_if/4, not_applicable_on_date/0, keeping_period_ended/0, status_of_the_ai_system/0]).
:- use_module(m__eu_ai_act_conformity_marking_registration_kernel, [conformity_marking_registration_input_problems/2]).
:- use_module(m__eu_ai_act_conformity_marking_registration_conformity_marking_registration, [conformity_assessment_procedure/4, registration_status/5, declaration_keeping_status/4, listed_items/3, conformity_marking_registration_checklist/2]).
:- use_module(m__eu_ai_act_conformity_marking_registration_fixtures, [conformity_marking_registration_profile_for/2, conformity_marking_registration_assess/2]).

base_case(AssessmentCase) :-
    conformity_marking_registration_profile_for(point_three_internal_control, AssessmentCase).

test(profile_keys_are_the_contract_keys) :-
    conformity_marking_registration_profile_keys(ProfileKeys),
    ProfileKeys == [annex_iii_point, provider_concluded_under_article_6_3_that_the_system_is_not_high_risk, covered_by_union_harmonisation_legislation_listed_in_section_a_of_annex_i, component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, placed_on_the_market_or_put_into_service_before_the_application_day, significant_changes_in_design_from_the_application_day, intended_to_be_used_by_public_authorities, harmonised_standards_or_common_specifications_applied_in_full, applied_harmonised_standard_published_with_a_restriction, harmonisation_legislation_offers_an_option_without_third_party_conformity_assessment, intended_to_be_put_into_service_by_law_enforcement_immigration_or_asylum_authorities_or_union_institutions_bodies_offices_or_agencies, already_subject_to_a_conformity_assessment_procedure, change_pre_determined_for_a_system_that_continues_to_learn, substantial_modification, other_union_harmonisation_legislation_requires_an_eu_declaration_of_conformity, provided_digitally, affixing_to_the_system_possible_and_warranted, notified_body_involved_in_the_conformity_assessment, other_union_law_provides_for_affixing_the_ce_marking, deployer_is_a_public_authority_or_union_institution_body_office_or_agency_or_acts_on_their_behalf].
test(the_re_exported_input_check_answers_bare_problems) :-
    conformity_marking_registration_input_problems([attribute(colour, red)], [unknown_key(colour)]).
test(what_if_unlisted_is_not_high_risk) :-
    base_case(AssessmentCase),
    conformity_marking_registration_what_if(AssessmentCase, annex_iii_point, not_listed_in_annex_iii, NewStatus),
    NewStatus == not_high_risk_under_annex_iii_or_section_a_of_annex_i.
test(what_if_placed_before_the_application_day) :-
    base_case(AssessmentCase),
    conformity_marking_registration_what_if(AssessmentCase, placed_on_the_market_or_put_into_service_before_the_application_day, true, NewStatus),
    NewStatus == not_applicable_to_a_system_placed_before_the_application_day.
test(what_if_an_annex_x_component) :-
    base_case(AssessmentCase),
    conformity_marking_registration_what_if(AssessmentCase, component_of_an_annex_x_large_scale_it_system_placed_on_the_market_or_put_into_service_before_2_august_2027, true, NewStatus),
    NewStatus == compliance_required_by_31_december_2030.
test(what_if_an_unknown_key_is_an_input_problem) :-
    base_case(AssessmentCase),
    conformity_marking_registration_what_if(AssessmentCase, colour, red, NewStatus),
    NewStatus == input_problems([unknown_key(colour)]).
test(what_if_a_wrong_value_is_an_input_problem) :-
    base_case(AssessmentCase),
    conformity_marking_registration_what_if(AssessmentCase, provided_digitally, unsure, NewStatus),
    NewStatus == input_problems([wrong_type(provided_digitally)]).
test(what_if_drops_a_duplicated_key) :-
    base_case(assessment(Profile, AssessmentDate)),
    append(Profile, [attribute(annex_iii_point, annex_iii_point_1)], Duplicated),
    conformity_marking_registration_what_if(assessment(Duplicated, AssessmentDate), annex_iii_point, annex_iii_point_3, NewStatus),
    NewStatus == high_risk_obligations_apply.
test(what_if_an_absent_key_is_still_named) :-
    conformity_marking_registration_profile_for(point_one_standards_unstated, AssessmentCase),
    conformity_marking_registration_what_if(AssessmentCase, annex_iii_point, annex_iii_point_1, NewStatus),
    NewStatus == indeterminate([harmonised_standards_or_common_specifications_applied_in_full]).
test(what_if_supplying_the_absent_key_settles) :-
    conformity_marking_registration_profile_for(point_one_standards_unstated, AssessmentCase),
    conformity_marking_registration_what_if(AssessmentCase, harmonised_standards_or_common_specifications_applied_in_full, false, NewStatus),
    NewStatus == high_risk_obligations_apply.
test(what_if_has_one_answer) :-
    base_case(AssessmentCase),
    findall(NewStatus, conformity_marking_registration_what_if(AssessmentCase, annex_iii_point, annex_iii_point_2, NewStatus), Answers),
    Answers == [high_risk_obligations_apply].
test(status_determination_query_answers) :-
    base_case(assessment(Profile, AssessmentDate)),
    conformity_assessment_procedure(Profile, AssessmentDate, internal_control_under_annex_vi, [_|_]).
test(obligation_surfacing_query_answers) :-
    base_case(assessment(Profile, AssessmentDate)),
    registration_status(Profile, provider, AssessmentDate, registration_in_the_eu_database, [cite(eu_reg_2024_1689_art_49_1)]).
test(deadline_query_answers) :-
    declaration_keeping_status(date(2028, 8, 2), date(2038, 8, 3), keeping_period_ended, [cite(eu_reg_2024_1689_art_47_1)]).
test(factual_lookup_query_answers) :-
    listed_items(annex_ix_secure_section, Items, Citations),
    Items == [union_wide_unique_single_identification_number_of_the_testing, name_and_contact_details_of_the_provider_and_of_the_deployers_involved_in_the_testing, brief_description_of_the_ai_system_and_of_its_intended_purpose, information_on_suspension_or_termination_of_the_testing],
    member(cite(eu_reg_2024_1689_art_49_4_d), Citations).
test(the_checklist_has_one_row_per_answer_each_cited) :-
    base_case(AssessmentCase),
    conformity_marking_registration_checklist(AssessmentCase, Items),
    length(Items, 11),
    maplist(checklist_row_is_cited, Items).
test(the_checklist_names_the_procedure_row) :-
    base_case(AssessmentCase),
    conformity_marking_registration_checklist(AssessmentCase, Items),
    member(item(conformity_assessment_procedure, internal_control_under_annex_vi, _), Items).
test(the_checklist_of_a_non_case_is_an_input_problem) :-
    conformity_marking_registration_checklist(colour, [item(overall, input_problems([wrong_type(case)]), [])]).
test(the_fixture_wrapper_assesses) :-
    conformity_marking_registration_assess(point_three_concluded_not_high_risk, conformity_marking_registration_verdict(not_high_risk_under_annex_iii_or_section_a_of_annex_i, [_|_])).
test(the_vocabulary_is_served) :-
    not_applicable_on_date,
    keeping_period_ended,
    status_of_the_ai_system.
test(the_constructors_build_data_terms) :-
    Referral = needs_legal_review(open_textured(substantial_modification, cite(eu_reg_2024_1689_art_3_23)), [inputs_relied_on([])]),
    functor(Referral, needs_legal_review, 2),
    Duplicate = duplicate_key(provided_digitally),
    functor(Duplicate, duplicate_key, 1).

checklist_row_is_cited(item(_, _, [_|_])).

cp_test_names([profile_keys_are_the_contract_keys, the_re_exported_input_check_answers_bare_problems, what_if_unlisted_is_not_high_risk, what_if_placed_before_the_application_day, what_if_an_annex_x_component, what_if_an_unknown_key_is_an_input_problem, what_if_a_wrong_value_is_an_input_problem, what_if_drops_a_duplicated_key, what_if_an_absent_key_is_still_named, what_if_supplying_the_absent_key_settles, what_if_has_one_answer, status_determination_query_answers, obligation_surfacing_query_answers, deadline_query_answers, factual_lookup_query_answers, the_checklist_has_one_row_per_answer_each_cited, the_checklist_names_the_procedure_row, the_checklist_of_a_non_case_is_an_input_problem, the_fixture_wrapper_assesses, the_vocabulary_is_served, the_constructors_build_data_terms]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
