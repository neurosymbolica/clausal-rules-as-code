% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_proportionality_and_simplified_framework_tests_test_output_mode, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_dora_proportionality_and_simplified_framework, [decide_dora_proportionality_and_simplified_framework/2, dora_proportionality_and_simplified_framework_status/2, simplified_framework_qualification/3, simplified_framework_duties_required/3, simplified_framework_duties_complete/3, simplified_framework_duties_outstanding/3]).
:- use_module(m__eu_dora_proportionality_and_simplified_framework_fixtures, [dora_proportionality_and_simplified_framework_profile_for/2]).

duty_citations([cite(eu_reg_2022_2554_art_4_1), cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_16_1_a), cite(eu_reg_2022_2554_art_16_1_b), cite(eu_reg_2022_2554_art_16_1_c), cite(eu_reg_2022_2554_art_16_1_d), cite(eu_reg_2022_2554_art_16_1_e), cite(eu_reg_2022_2554_art_16_1_f), cite(eu_reg_2022_2554_art_16_1_g), cite(eu_reg_2022_2554_art_16_1_h), cite(eu_reg_2022_2554_art_16_2)]).

standing_duties([simplified_ict_risk_management_framework, continuous_monitoring_of_ict_systems, ict_risk_impact_minimisation, detection_and_handling, key_third_party_dependencies, continuity_of_critical_or_important_functions, regular_testing, operational_conclusions_implemented, awareness_and_training_programmes, framework_documentation_and_review, continuous_improvement]).

same_citation_set(Citations, Expected) :-
    clausal_msort(Citations, SortedCitations),
    clausal_msort(Expected, SortedCitations).

unsure_pairs([dora_entity_type - exempted_payment_institution, authority_requested_framework_review_report - false, simplified_framework_in_place_and_maintained - unsure, ict_systems_continuously_monitored - true, ict_risk_impact_minimised_with_sound_systems - true, risk_sources_detected_and_incidents_handled - true, key_ict_third_party_dependencies_identified - true, continuity_of_critical_functions_ensured - true, plans_and_controls_tested_regularly - true, test_and_incident_conclusions_implemented - true, awareness_and_training_programmes_developed - true, simplified_framework_documented_and_reviewed - true, simplified_framework_continuously_improved - true]).

test(the_qualification_is_read_out_once) :-
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_all_duties_performed, Profile),
    findall(Result - Citations, simplified_framework_qualification(Profile, Result, Citations), Answers),
    Answers = [article_16_1_entity - QualificationCitations],
    same_citation_set(QualificationCitations, [cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_3_36)]).
test(the_required_list_is_read_out_in_duty_order) :-
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_all_duties_performed, Profile),
    findall(Result - Citations, simplified_framework_duties_required(Profile, Result, Citations), Answers),
    Answers = [required(Duties) - RequiredCitations],
    standing_duties(Expected),
    Duties == Expected,
    duty_citations(ExpectedCitations),
    same_citation_set(RequiredCitations, ExpectedCitations).
test(a_requested_report_is_read_out_last) :-
    dora_proportionality_and_simplified_framework_profile_for(requested_report_submitted, Profile),
    simplified_framework_duties_required(Profile, required(Duties), _),
    standing_duties(Standing),
    append(Standing, [review_report_to_authority], Expected),
    Duties == Expected.
test(complete_is_read_out_once_with_its_fixed_citations) :-
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_all_duties_performed, Profile),
    findall(Result - Citations, simplified_framework_duties_complete(Profile, Result, Citations), Answers),
    Answers = [complete - CompleteCitations],
    duty_citations(ExpectedCitations),
    same_citation_set(CompleteCitations, ExpectedCitations).
test(incomplete_carries_the_same_fixed_citations) :-
    dora_proportionality_and_simplified_framework_profile_for(requested_report_not_submitted, Profile),
    findall(Result - Citations, simplified_framework_duties_complete(Profile, Result, Citations), Answers),
    Answers = [incomplete - IncompleteCitations],
    duty_citations(ExpectedCitations),
    same_citation_set(IncompleteCitations, ExpectedCitations).
test(the_outstanding_list_is_read_out_once) :-
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_framework_not_performed, Profile),
    findall(Result - Citations, simplified_framework_duties_outstanding(Profile, Result, Citations), Answers),
    Answers = [outstanding(Duties) - OutstandingCitations],
    Duties == [simplified_ict_risk_management_framework],
    same_citation_set(OutstandingCitations, [cite(eu_reg_2022_2554_art_4_1), cite(eu_reg_2022_2554_art_16_1), cite(eu_reg_2022_2554_art_16_1_a)]).
test(none_outstanding_is_read_out_once) :-
    dora_proportionality_and_simplified_framework_profile_for(requested_report_submitted, Profile),
    findall(Result, simplified_framework_duties_outstanding(Profile, Result, _), Answers),
    Answers == [none_outstanding].
test(a_referral_reads_out_its_pairs_in_root_order) :-
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_framework_unsure, Profile),
    findall(Result - Citations, simplified_framework_duties_complete(Profile, Result, Citations), Answers),
    Answers = [needs_legal_review(Reason, [inputs_relied_on(Pairs)]) - []],
    Reason == open_textured(simplified_framework_in_place_and_maintained, cite(eu_reg_2022_2554_art_16_1_a)),
    unsure_pairs(Expected),
    Pairs == Expected.
test(a_reversed_profile_reads_out_the_same_pairs) :-
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_framework_unsure, Profile),
    reverse(Profile, ReversedProfile),
    simplified_framework_duties_outstanding(ReversedProfile, needs_legal_review(_, [inputs_relied_on(Pairs)]), []),
    unsure_pairs(Expected),
    Pairs == Expected.
test(a_passed_on_answer_keeps_the_qualification_citations) :-
    dora_proportionality_and_simplified_framework_profile_for(directive_institution_excluded_by_member_state, Profile),
    simplified_framework_duties_required(Profile, out_of_scope, RequiredCitations),
    simplified_framework_duties_complete(Profile, out_of_scope, CompleteCitations),
    simplified_framework_duties_outstanding(Profile, out_of_scope, OutstandingCitations),
    RequiredCitations == [cite(eu_reg_2022_2554_art_2_4)],
    CompleteCitations == [cite(eu_reg_2022_2554_art_2_4)],
    OutstandingCitations == [cite(eu_reg_2022_2554_art_2_4)].
test(a_missing_type_is_read_out_by_every_query) :-
    dora_proportionality_and_simplified_framework_profile_for(entity_type_not_given, Profile),
    findall(Result - Citations, simplified_framework_qualification(Profile, Result, Citations), [indeterminate([dora_entity_type]) - []]),
    findall(Result - Citations, simplified_framework_duties_required(Profile, Result, Citations), [indeterminate([dora_entity_type]) - []]),
    findall(Result - Citations, simplified_framework_duties_complete(Profile, Result, Citations), [indeterminate([dora_entity_type]) - []]),
    findall(Result - Citations, simplified_framework_duties_outstanding(Profile, Result, Citations), [indeterminate([dora_entity_type]) - []]).
test(the_baseline_profile_yields_exactly_one_status) :-
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_all_duties_performed, Profile),
    findall(Status, dora_proportionality_and_simplified_framework_status(Profile, Status), Statuses),
    Statuses == [complete].
test(the_verdict_carries_a_citation) :-
    dora_proportionality_and_simplified_framework_profile_for(exempted_payment_institution_all_duties_performed, Profile),
    decide_dora_proportionality_and_simplified_framework(Profile, dora_proportionality_and_simplified_framework_verdict(complete, [_FirstCitation|_OtherCitations])).
test(a_status_verdict_carries_no_citation) :-
    dora_proportionality_and_simplified_framework_profile_for(entity_type_misspelt, Profile),
    decide_dora_proportionality_and_simplified_framework(Profile, dora_proportionality_and_simplified_framework_verdict(input_problems([wrong_type(dora_entity_type)]), [])).

cp_test_names([the_qualification_is_read_out_once, the_required_list_is_read_out_in_duty_order, a_requested_report_is_read_out_last, complete_is_read_out_once_with_its_fixed_citations, incomplete_carries_the_same_fixed_citations, the_outstanding_list_is_read_out_once, none_outstanding_is_read_out_once, a_referral_reads_out_its_pairs_in_root_order, a_reversed_profile_reads_out_the_same_pairs, a_passed_on_answer_keeps_the_qualification_citations, a_missing_type_is_read_out_by_every_query, the_baseline_profile_yields_exactly_one_status, the_verdict_carries_a_citation, a_status_verdict_carries_no_citation]).
cp_test_fail_names([]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
