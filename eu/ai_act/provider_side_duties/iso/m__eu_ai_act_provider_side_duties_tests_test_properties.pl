% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_ai_act_provider_side_duties_tests_test_properties, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists, [msort/2]).
:- use_module(library(clpz)).
:- use_module(m__eu_ai_act_provider_side_duties_provider_side_duties, [decide_provider_side_duties/2, operator_duty_status/5, retention_period_end/4, provider_side_duties_status_values/1]).
:- use_module(m__eu_ai_act_provider_side_duties_kernel, [provider_side_duties_input_problems/2, provider_side_duties_day_key/2]).
:- use_module(m__eu_ai_act_provider_side_duties_fixtures, [provider_side_duties_subject/1, provider_side_duties_profile_for/2, provider_side_duties_assess/2]).

duty_atoms([compliance_with_the_requirements_of_section_2, provider_name_and_contact_address, quality_management_system, documentation_keeping, log_keeping, conformity_assessment_before_placing_on_the_market, eu_declaration_of_conformity, ce_marking, registration, corrective_actions_and_information, investigation_and_information_on_a_risk, demonstration_of_conformity_on_request, access_to_logs_on_request, accessibility_requirements, appointment_of_an_authorised_representative, enabling_the_authorised_representative, performance_of_the_mandate_tasks, copy_of_the_mandate_on_request, verification_of_the_declaration_documentation_and_conformity_assessment, keeping_of_the_provider_contact_details_and_documents, representative_information_on_request, representative_cooperation_with_authorities, representative_registration, termination_of_the_mandate, importer_verification_before_placing_on_the_market, importer_withholding_of_a_non_conforming_system, importer_information_on_a_risk, importer_name_and_contact_address, importer_storage_and_transport_conditions, importer_keeping_of_copies, importer_information_on_request, importer_cooperation_with_authorities, distributor_verification_before_making_available, distributor_withholding_of_a_non_conforming_system, distributor_information_on_a_risk, distributor_storage_and_transport_conditions, distributor_corrective_actions, distributor_information_on_request, distributor_cooperation_with_authorities, ai_literacy_measures]).

roles([provider, deployer, importer, distributor, product_manufacturer, authorised_representative, affected_person]).

keeping_duties([documentation_keeping, keeping_of_the_provider_contact_details_and_documents, importer_keeping_of_copies, log_keeping]).

complete_profile(Role, [attribute(ai_system, true), attribute(high_risk_ai_system, true), attribute(high_risk_route, annex_iii), attribute(actor_role, Role), attribute(component_of_a_large_scale_it_system_listed_in_annex_x, false), attribute(placed_on_the_market_or_put_into_service_before_2_august_2027, false), attribute(placed_on_the_market_or_put_into_service_before_the_date_of_application_of_chapter_iii, false), attribute(significant_change_in_design_as_from_the_date_of_application_of_chapter_iii, false), attribute(intended_to_be_used_by_public_authorities, false), attribute(provider_established_in_a_third_country, true), attribute(logs_under_the_providers_control, true), attribute(reasoned_request_from_a_competent_authority, true), attribute(request_from_a_market_surveillance_authority_for_a_copy_of_the_mandate, false), attribute(competent_authority_action_in_relation_to_the_system, true), attribute(system_under_the_operators_responsibility, false), attribute(provider_considers_or_has_reason_to_consider_the_system_not_in_conformity, false), attribute(presents_a_risk_within_the_meaning_of_article_79_1, true), attribute(provider_aware_of_the_risk, false), attribute(representative_considers_or_has_reason_to_consider_the_provider_acting_contrary_to_its_obligations, false), attribute(importer_has_sufficient_reason_to_consider_the_system_not_in_conformity_or_falsified, false), attribute(distributor_considers_or_has_reason_to_consider_the_system_not_in_conformity, true), attribute(distributor_has_made_the_system_available_on_the_market, false)]).

subject_classifies(Subject) :-
    provider_side_duties_subject(Subject),
    provider_side_duties_profile_for(Subject, Profile),
    decide_provider_side_duties(Profile, _Verdict).

subject_count_pair(Subject, Subject - Count) :-
    provider_side_duties_profile_for(Subject, Case),
    findall(Verdict, decide_provider_side_duties(Case, Verdict), Verdicts),
    length(Verdicts, Count).

role_duty_count(Role, Duty, Role - Duty - Count) :-
    complete_profile(Role, Profile),
    findall(Result - Citations, operator_duty_status(Profile, Duty, date(2029, 1, 1), Result, Citations), Answers),
    length(Answers, Count).

role_duty_pair(Role, Duty) :-
    roles(Roles),
    duty_atoms(Duties),
    member(Role, Roles),
    member(Duty, Duties).

complete_answer_is_final(Role, Duty) :-
    complete_profile(Role, Profile),
    operator_duty_status(Profile, Duty, date(2029, 1, 1), Result, [_|_]),
    provider_side_duties_status_values(StatusValues),
    member(Result, StatusValues).

final_with_citations(Subject) :-
    provider_side_duties_assess(Subject, provider_side_duties_verdict(Status, [_|_])),
    provider_side_duties_status_values(StatusValues),
    member(Status, StatusValues).

not_final_without_citations(Subject) :-
    provider_side_duties_assess(Subject, provider_side_duties_verdict(Status, [])),
    compound(Status).

odd_profile(profile).
odd_profile(_).
odd_profile([attribute(ai_system, true)|_]).
odd_profile([attribute(_, true)]).
odd_profile([attribute(1, true)]).
odd_profile([marker]).
odd_profile([attribute(ai_system, Value), attribute(ai_system, Value)]).
odd_profile([attribute(actor_role, captain), attribute(colour, blue), attribute(colour, red)]).

input_check_count(Profile, Count) :-
    findall(Problems, provider_side_duties_input_problems(Profile, Problems), AllProblems),
    length(AllProblems, Count).

chapter_three_not_applicable(Profile, Duty) :-
    duty_atoms(Duties),
    member(Duty, Duties),
    dif(Duty, ai_literacy_measures),
    operator_duty_status(Profile, Duty, date(2027, 12, 1), not_applicable_on_date, _).

retention_case(KeepingDuty - StartDate) :-
    keeping_duties(KeepingDuties),
    member(KeepingDuty, KeepingDuties),
    member(StartDate, [date(2028, 2, 29), date(2028, 8, 31), date(2027, 12, 31), date(9999, 12, 31)]).

retention_after_start(KeepingDuty - StartDate) :-
    retention_period_end(KeepingDuty, StartDate, EndDate, [_]),
    provider_side_duties_day_key(StartDate, StartKey),
    provider_side_duties_day_key(EndDate, EndKey),
    StartKey #< EndKey.

test(totality_every_subject_classifies) :-
    findall(Subject, provider_side_duties_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, subject_classifies(Subject), ClassifiedSubjects),
    sort(ClassifiedSubjects, SubjectSet).
test(determinism_every_subject_has_exactly_one_verdict) :-
    findall(Subject, provider_side_duties_subject(Subject), Subjects),
    maplist(subject_count_pair, Subjects, Pairs),
    findall(Subject - 1, member(Subject, Subjects), Expected),
    Pairs == Expected.
test(determinism_every_duty_has_one_answer_for_every_role) :-
    findall(Role - Duty, role_duty_pair(Role, Duty), RoleDuties),
    findall(Triple, (member(Role - Duty, RoleDuties), role_duty_count(Role, Duty, Triple)), Counts),
    findall(Role - Duty - 1, member(Role - Duty, RoleDuties), Expected),
    Counts == Expected.
test(a_complete_profile_always_gets_a_final_answer_with_citations) :-
    findall(Role - Duty, role_duty_pair(Role, Duty), RoleDuties),
    findall(Role - Duty, (member(Role - Duty, RoleDuties), complete_answer_is_final(Role, Duty)), FinalRoleDuties),
    FinalRoleDuties == RoleDuties.
test(every_subject_answer_has_its_citation_shape) :-
    findall(Subject, provider_side_duties_subject(Subject), Subjects),
    sort(Subjects, SubjectSet),
    findall(Subject, final_with_citations(Subject), FinalSubjects),
    findall(Subject, not_final_without_citations(Subject), NotFinalSubjects),
    append(FinalSubjects, NotFinalSubjects, ShapedSubjects),
    msort(ShapedSubjects, SortedShaped),
    SortedShaped == SubjectSet.
test(the_input_check_has_one_answer_for_every_term) :-
    findall(Count, (odd_profile(Profile), input_check_count(Profile, Count)), Counts),
    findall(1, odd_profile(_), Expected),
    Counts == Expected.
test(before_2_december_2027_no_chapter_three_duty_applies) :-
    complete_profile(provider, Profile),
    findall(Duty, chapter_three_not_applicable(Profile, Duty), Duties),
    length(Duties, 39).
test(every_retention_end_is_after_its_start) :-
    findall(Case, retention_case(Case), Cases),
    findall(Case, (member(Case, Cases), retention_after_start(Case)), AfterCases),
    AfterCases == Cases.

cp_test_names([totality_every_subject_classifies, determinism_every_subject_has_exactly_one_verdict, determinism_every_duty_has_one_answer_for_every_role, a_complete_profile_always_gets_a_final_answer_with_citations, every_subject_answer_has_its_citation_shape, the_input_check_has_one_answer_for_every_term, before_2_december_2027_no_chapter_three_duty_applies, every_retention_end_is_after_its_start]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
