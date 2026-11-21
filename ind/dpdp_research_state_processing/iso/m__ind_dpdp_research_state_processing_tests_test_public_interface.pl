% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_research_state_processing_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_research_state_processing_dpdp_research_state_processing, [decide_dpdp_research_state_processing/2, dpdp_research_state_processing_status/2, dpdp_research_state_processing_checklist/2, dpdp_research_state_processing_decision_resolvable/1, dpdp_research_state_processing_status_values/1]).
:- use_module(m__ind_dpdp_research_state_processing_fixtures, [dpdp_research_state_processing_subject/1, dpdp_research_state_processing_profile_for/2, dpdp_research_state_processing_assess/2]).

expected_status(complete_processing, determinations(exempt_from_act, follows_second_schedule, sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(reference_day_before_commencement, determinations(not_in_force, not_in_force, sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(reference_day_on_commencement, determinations(exempt_from_act, follows_second_schedule, sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(reference_day_after_commencement, determinations(exempt_from_act, follows_second_schedule, sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(section_seventeen_not_in_force, determinations(not_in_force, follows_second_schedule, not_in_force)).
expected_status(section_seven_not_in_force, determinations(exempt_from_act, not_in_force, sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(decision_specific_to_data_principal, determinations(not_exempt, follows_second_schedule, sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(not_research_purpose, determinations(not_exempt, follows_second_schedule, sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(lawful_manner_not_observed, determinations(not_exempt, does_not_follow_second_schedule, sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(intimation_not_given, determinations(exempt_from_act, does_not_follow_second_schedule, sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(not_section_seven_b_use, determinations(exempt_from_act, not_applicable, sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(not_state_or_instrumentality, determinations(exempt_from_act, follows_second_schedule, not_applicable)).
expected_status(purpose_includes_affecting_decision, determinations(exempt_from_act, follows_second_schedule, sections_8_7_and_12_3_do_not_apply)).
expected_status(research_purpose_unsure, determinations(needs_legal_review(open_textured(processing_necessary_for_research_archiving_or_statistical_purposes, cite(in_dpdp_act_2023_s_17_2_b)), [inputs_relied_on([processing_necessary_for_research_archiving_or_statistical_purposes - unsure])]), follows_second_schedule, sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(accountability_unsure, determinations(needs_legal_review(open_textured(accountability_for_observance, cite(in_dpdp_rules_2025_sch_2_h)), [inputs_relied_on([accountability_for_observance - unsure])]), needs_legal_review(open_textured(accountability_for_observance, cite(in_dpdp_rules_2025_sch_2_h)), [inputs_relied_on([accountability_for_observance - unsure])]), sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(other_applicable_standards_unsure, determinations(exempt_from_act, needs_legal_review(open_textured(consistent_with_other_applicable_standards, cite(in_dpdp_rules_2025_sch_2_g_iii)), [inputs_relied_on([consistent_with_other_applicable_standards - unsure])]), sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(state_use_unsure, determinations(exempt_from_act, needs_legal_review(open_textured(processing_for_section_7_b_use, cite(in_dpdp_act_2023_s_7_b)), [inputs_relied_on([processing_for_section_7_b_use - unsure])]), sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(state_use_unsure_with_intimation_not_given, determinations(exempt_from_act, needs_legal_review(open_textured(processing_for_section_7_b_use, cite(in_dpdp_act_2023_s_7_b)), [inputs_relied_on([processing_for_section_7_b_use - unsure])]), sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(state_body_unsure, determinations(exempt_from_act, follows_second_schedule, needs_legal_review(open_textured(processing_by_state_or_instrumentality, cite(in_dpdp_act_2023_s_17_4)), [inputs_relied_on([processing_by_state_or_instrumentality - unsure])]))).
expected_status(decision_purpose_unsure, determinations(exempt_from_act, follows_second_schedule, needs_legal_review(open_textured(purpose_includes_decision_affecting_data_principal, cite(in_dpdp_act_2023_s_17_4)), [inputs_relied_on([purpose_includes_decision_affecting_data_principal - unsure])]))).
expected_status(empty_profile, determinations(indeterminate([section_17_in_force_on_reference_date]), indeterminate([section_7_in_force_on_reference_date]), indeterminate([section_17_in_force_on_reference_date]))).
expected_status(reference_date_missing, determinations(indeterminate([reference_date]), indeterminate([reference_date]), sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(lawful_manner_missing_with_research_purpose_unsure, determinations(indeterminate([lawful_manner]), indeterminate([lawful_manner]), sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(unknown_key_given, determinations(input_problems([unknown_key(colour)]), input_problems([unknown_key(colour)]), input_problems([unknown_key(colour)]))).
expected_status(duplicate_key_given, determinations(input_problems([duplicate_key(lawful_manner)]), input_problems([duplicate_key(lawful_manner)]), input_problems([duplicate_key(lawful_manner)]))).
expected_status(february_twenty_ninth_common_year, determinations(input_problems([wrong_type(reference_date)]), input_problems([wrong_type(reference_date)]), input_problems([wrong_type(reference_date)]))).
expected_status(february_twenty_ninth_leap_year, determinations(exempt_from_act, follows_second_schedule, sections_8_7_12_2_and_12_3_do_not_apply)).
expected_status(year_zero, determinations(input_problems([wrong_type(reference_date)]), input_problems([wrong_type(reference_date)]), input_problems([wrong_type(reference_date)]))).
expected_status(year_ten_thousand, determinations(exempt_from_act, follows_second_schedule, sections_8_7_12_2_and_12_3_do_not_apply)).

status_of(Subject, Status) :-
    dpdp_research_state_processing_assess(Subject, dpdp_research_state_processing_verdict(Status, _Citations)).

citations_of(Subject, Citations) :-
    dpdp_research_state_processing_assess(Subject, dpdp_research_state_processing_verdict(_Status, Citations)).

subject_matches_expectation(Subject) :-
    expected_status(Subject, Expected),
    findall(Status, status_of(Subject, Status), Statuses),
    Statuses == [Expected].

subject_has_one_answer(Subject) :-
    findall(Verdict, dpdp_research_state_processing_assess(Subject, Verdict), Verdicts),
    length(Verdicts, 1).

subject_has_expectation(Subject) :-
    expected_status(Subject, _).

subject_is_registered(Subject) :-
    dpdp_research_state_processing_subject(Subject).

subject_has_cited_checklist(Subject) :-
    dpdp_research_state_processing_profile_for(Subject, Profile),
    dpdp_research_state_processing_checklist(Profile, Items),
    length(Items, 3).

result_well_formed(Result, Values) :-
    atom(Result),
    member(Result, Values).
result_well_formed(indeterminate([Key]), _) :-
    atom(Key).
result_well_formed(needs_legal_review(open_textured(Key, cite(_)), [inputs_relied_on([Key - unsure])]), _).
result_well_formed(input_problems([_|_]), _).

subject_status_well_formed(Subject) :-
    status_of(Subject, determinations(Research, Standards, Disapplied)),
    dpdp_research_state_processing_status_values(Values),
    result_well_formed(Research, Values),
    result_well_formed(Standards, Values),
    result_well_formed(Disapplied, Values).

test(every_subject_resolves_to_its_expected_status) :-
    findall(Subject, dpdp_research_state_processing_subject(Subject), Subjects),
    maplist(subject_matches_expectation, Subjects).
test(every_subject_yields_exactly_one_verdict) :-
    findall(Subject, dpdp_research_state_processing_subject(Subject), Subjects),
    maplist(subject_has_one_answer, Subjects).
test(every_subject_has_an_expectation_and_every_expectation_a_subject) :-
    findall(Subject, dpdp_research_state_processing_subject(Subject), Subjects),
    maplist(subject_has_expectation, Subjects),
    findall(Expected, expected_status(Expected, _), ExpectedSubjects),
    maplist(subject_is_registered, ExpectedSubjects),
    length(Subjects, Count),
    length(ExpectedSubjects, Count).
test(every_subject_has_a_three_row_checklist) :-
    findall(Subject, dpdp_research_state_processing_subject(Subject), Subjects),
    maplist(subject_has_cited_checklist, Subjects).
test(every_status_is_from_the_result_vocabulary) :-
    findall(Subject, dpdp_research_state_processing_subject(Subject), Subjects),
    maplist(subject_status_well_formed, Subjects).
test(complete_processing_is_exempt_and_follows_the_schedule) :-
    status_of(complete_processing, determinations(exempt_from_act, follows_second_schedule, sections_8_7_12_2_and_12_3_do_not_apply)).
test(the_day_before_commencement_is_not_in_force) :-
    status_of(reference_day_before_commencement, determinations(not_in_force, not_in_force, _)).
test(the_commencement_day_is_in_force) :-
    status_of(reference_day_on_commencement, determinations(exempt_from_act, follows_second_schedule, _)).
test(the_day_after_commencement_is_in_force) :-
    status_of(reference_day_after_commencement, determinations(exempt_from_act, follows_second_schedule, _)).
test(section_seventeen_not_in_force_settles_research_and_disapplication) :-
    status_of(section_seventeen_not_in_force, determinations(not_in_force, follows_second_schedule, not_in_force)).
test(section_seven_not_in_force_settles_only_the_state_standards) :-
    status_of(section_seven_not_in_force, determinations(exempt_from_act, not_in_force, _)).
test(a_decision_specific_use_is_not_exempt) :-
    status_of(decision_specific_to_data_principal, determinations(not_exempt, _, _)).
test(a_purpose_outside_research_is_not_exempt) :-
    status_of(not_research_purpose, determinations(not_exempt, _, _)).
test(a_standard_not_observed_fails_both_schedule_queries) :-
    status_of(lawful_manner_not_observed, determinations(not_exempt, does_not_follow_second_schedule, _)).
test(an_intimation_not_given_fails_only_the_state_standards) :-
    status_of(intimation_not_given, determinations(exempt_from_act, does_not_follow_second_schedule, _)).
test(processing_outside_section_seven_b_is_not_applicable) :-
    status_of(not_section_seven_b_use, determinations(_, not_applicable, _)).
test(processing_not_by_the_state_is_outside_section_seventeen_four) :-
    status_of(not_state_or_instrumentality, determinations(_, _, not_applicable)).
test(a_decision_purpose_keeps_section_twelve_two) :-
    status_of(purpose_includes_affecting_decision, determinations(_, _, sections_8_7_and_12_3_do_not_apply)).
test(an_unsure_research_purpose_is_referred) :-
    status_of(research_purpose_unsure, determinations(needs_legal_review(open_textured(processing_necessary_for_research_archiving_or_statistical_purposes, cite(in_dpdp_act_2023_s_17_2_b)), [inputs_relied_on([processing_necessary_for_research_archiving_or_statistical_purposes - unsure])]), follows_second_schedule, _)).
test(an_unsure_state_use_with_a_standard_not_observed_is_referred) :-
    status_of(state_use_unsure_with_intimation_not_given, determinations(_, needs_legal_review(open_textured(processing_for_section_7_b_use, cite(in_dpdp_act_2023_s_7_b)), [inputs_relied_on([processing_for_section_7_b_use - unsure])]), _)).
test(an_unsure_state_body_is_referred) :-
    status_of(state_body_unsure, determinations(_, _, needs_legal_review(open_textured(processing_by_state_or_instrumentality, cite(in_dpdp_act_2023_s_17_4)), [inputs_relied_on([processing_by_state_or_instrumentality - unsure])]))).
test(a_referral_context_accepts_a_provenance_item) :-
    status_of(state_body_unsure, determinations(_, _, needs_legal_review(Reason, [inputs_relied_on(Pairs)]))),
    Extended = needs_legal_review(Reason, [inputs_relied_on(Pairs), provenance(state_processing_disapplied_provisions, [cite(in_dpdp_act_2023_s_17_4)])]),
    Extended = needs_legal_review(_, [inputs_relied_on(ExtendedPairs), provenance(Clause, ProvenanceCitations)]),
    ExtendedPairs == [processing_by_state_or_instrumentality - unsure],
    Clause == state_processing_disapplied_provisions,
    ProvenanceCitations == [cite(in_dpdp_act_2023_s_17_4)].
test(an_empty_profile_names_the_first_key_of_each_ladder) :-
    status_of(empty_profile, determinations(indeterminate([section_17_in_force_on_reference_date]), indeterminate([section_7_in_force_on_reference_date]), indeterminate([section_17_in_force_on_reference_date]))).
test(a_missing_standard_is_named_before_an_unsure_purpose) :-
    status_of(lawful_manner_missing_with_research_purpose_unsure, determinations(indeterminate([lawful_manner]), indeterminate([lawful_manner]), _)).
test(february_twenty_ninth_in_a_common_year_is_wrong_type) :-
    status_of(february_twenty_ninth_common_year, determinations(input_problems([wrong_type(reference_date)]), _, _)).
test(february_twenty_ninth_in_a_leap_year_is_a_real_day) :-
    status_of(february_twenty_ninth_leap_year, determinations(exempt_from_act, follows_second_schedule, _)).
test(year_zero_is_wrong_type) :-
    status_of(year_zero, determinations(input_problems([wrong_type(reference_date)]), _, _)).
test(year_ten_thousand_is_a_real_day) :-
    status_of(year_ten_thousand, determinations(exempt_from_act, _, _)).
test(the_complete_profile_cites_the_union_of_three_queries) :-
    citations_of(complete_processing, Citations),
    length(Citations, 17),
    member(cite(in_dpdp_act_2023_s_17_4), Citations),
    member(cite(in_dpdp_rules_2025_r_5_1), Citations),
    member(cite(in_dpdp_rules_2025_r_16), Citations).
test(the_day_before_commencement_cites_rule_one_four) :-
    citations_of(reference_day_before_commencement, Citations),
    length(Citations, 7),
    member(cite(in_dpdp_rules_2025_r_1_4), Citations).
test(input_problems_carry_no_citations) :-
    citations_of(unknown_key_given, []).
test(an_empty_profile_carries_no_citations) :-
    citations_of(empty_profile, []).
test(status_agrees_with_the_verdict) :-
    dpdp_research_state_processing_profile_for(complete_processing, Profile),
    decide_dpdp_research_state_processing(Profile, dpdp_research_state_processing_verdict(Status, _)),
    dpdp_research_state_processing_status(Profile, Status),
    dpdp_research_state_processing_decision_resolvable(Profile).
test(the_checklist_carries_cited_rows) :-
    dpdp_research_state_processing_profile_for(complete_processing, Profile),
    dpdp_research_state_processing_checklist(Profile, Items),
    member(item(research_exemption, exempt_from_act, ResearchCitations), Items),
    length(ResearchCitations, 11),
    member(item(state_processing_standards, follows_second_schedule, StandardsCitations), Items),
    length(StandardsCitations, 13),
    member(item(state_processing_disapplied_provisions, sections_8_7_12_2_and_12_3_do_not_apply, [cite(in_dpdp_act_2023_s_17_4)]), Items).
test(a_referred_row_carries_no_citations) :-
    dpdp_research_state_processing_profile_for(state_body_unsure, Profile),
    dpdp_research_state_processing_checklist(Profile, Items),
    member(item(state_processing_disapplied_provisions, needs_legal_review(_, _), []), Items).

test(complete_processing_is_not_not_exempt, fail) :-
    status_of(complete_processing, determinations(not_exempt, _, _)).
test(the_day_before_commencement_is_not_exempt_from_the_act, fail) :-
    status_of(reference_day_before_commencement, determinations(exempt_from_act, _, _)).
test(the_commencement_day_is_not_not_in_force, fail) :-
    status_of(reference_day_on_commencement, determinations(not_in_force, _, _)).
test(section_seventeen_not_in_force_is_not_exempt_from_the_act, fail) :-
    status_of(section_seventeen_not_in_force, determinations(exempt_from_act, _, _)).
test(section_seven_not_in_force_does_not_follow, fail) :-
    status_of(section_seven_not_in_force, determinations(_, follows_second_schedule, _)).
test(a_decision_specific_use_is_not_exempt_from_the_act, fail) :-
    status_of(decision_specific_to_data_principal, determinations(exempt_from_act, _, _)).
test(a_purpose_outside_research_is_not_exempt_from_the_act, fail) :-
    status_of(not_research_purpose, determinations(exempt_from_act, _, _)).
test(a_standard_not_observed_does_not_follow, fail) :-
    status_of(lawful_manner_not_observed, determinations(_, follows_second_schedule, _)).
test(an_intimation_not_given_does_not_follow, fail) :-
    status_of(intimation_not_given, determinations(_, follows_second_schedule, _)).
test(processing_outside_section_seven_b_does_not_follow, fail) :-
    status_of(not_section_seven_b_use, determinations(_, follows_second_schedule, _)).
test(processing_not_by_the_state_disapplies_nothing, fail) :-
    status_of(not_state_or_instrumentality, determinations(_, _, sections_8_7_12_2_and_12_3_do_not_apply)).
test(a_decision_purpose_does_not_disapply_section_twelve_two, fail) :-
    status_of(purpose_includes_affecting_decision, determinations(_, _, sections_8_7_12_2_and_12_3_do_not_apply)).
test(an_unsure_research_purpose_is_not_exempt_from_the_act, fail) :-
    status_of(research_purpose_unsure, determinations(exempt_from_act, _, _)).
test(an_unsure_state_use_with_a_standard_not_observed_is_not_does_not_follow, fail) :-
    status_of(state_use_unsure_with_intimation_not_given, determinations(_, does_not_follow_second_schedule, _)).
test(a_referral_context_carries_no_provenance_item, fail) :-
    status_of(state_body_unsure, determinations(_, _, needs_legal_review(_, [inputs_relied_on(_), provenance(_, _)]))).
test(a_research_referral_context_carries_no_provenance_item, fail) :-
    status_of(research_purpose_unsure, determinations(needs_legal_review(_, [inputs_relied_on(_), provenance(_, _)]), _, _)).
test(february_twenty_ninth_in_a_leap_year_has_no_input_problem, fail) :-
    status_of(february_twenty_ninth_leap_year, determinations(input_problems(_), _, _)).
test(year_ten_thousand_has_no_input_problem, fail) :-
    status_of(year_ten_thousand, determinations(input_problems(_), _, _)).

cp_test_names([every_subject_resolves_to_its_expected_status, every_subject_yields_exactly_one_verdict, every_subject_has_an_expectation_and_every_expectation_a_subject, every_subject_has_a_three_row_checklist, every_status_is_from_the_result_vocabulary, complete_processing_is_exempt_and_follows_the_schedule, the_day_before_commencement_is_not_in_force, the_commencement_day_is_in_force, the_day_after_commencement_is_in_force, section_seventeen_not_in_force_settles_research_and_disapplication, section_seven_not_in_force_settles_only_the_state_standards, a_decision_specific_use_is_not_exempt, a_purpose_outside_research_is_not_exempt, a_standard_not_observed_fails_both_schedule_queries, an_intimation_not_given_fails_only_the_state_standards, processing_outside_section_seven_b_is_not_applicable, processing_not_by_the_state_is_outside_section_seventeen_four, a_decision_purpose_keeps_section_twelve_two, an_unsure_research_purpose_is_referred, an_unsure_state_use_with_a_standard_not_observed_is_referred, an_unsure_state_body_is_referred, a_referral_context_accepts_a_provenance_item, an_empty_profile_names_the_first_key_of_each_ladder, a_missing_standard_is_named_before_an_unsure_purpose, february_twenty_ninth_in_a_common_year_is_wrong_type, february_twenty_ninth_in_a_leap_year_is_a_real_day, year_zero_is_wrong_type, year_ten_thousand_is_a_real_day, the_complete_profile_cites_the_union_of_three_queries, the_day_before_commencement_cites_rule_one_four, input_problems_carry_no_citations, an_empty_profile_carries_no_citations, status_agrees_with_the_verdict, the_checklist_carries_cited_rows, a_referred_row_carries_no_citations]).
cp_test_fail_names([complete_processing_is_not_not_exempt, the_day_before_commencement_is_not_exempt_from_the_act, the_commencement_day_is_not_not_in_force, section_seventeen_not_in_force_is_not_exempt_from_the_act, section_seven_not_in_force_does_not_follow, a_decision_specific_use_is_not_exempt_from_the_act, a_purpose_outside_research_is_not_exempt_from_the_act, a_standard_not_observed_does_not_follow, an_intimation_not_given_does_not_follow, processing_outside_section_seven_b_does_not_follow, processing_not_by_the_state_disapplies_nothing, a_decision_purpose_does_not_disapply_section_twelve_two, an_unsure_research_purpose_is_not_exempt_from_the_act, an_unsure_state_use_with_a_standard_not_observed_is_not_does_not_follow, a_referral_context_carries_no_provenance_item, a_research_referral_context_carries_no_provenance_item, february_twenty_ninth_in_a_leap_year_has_no_input_problem, year_ten_thousand_has_no_input_problem]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
