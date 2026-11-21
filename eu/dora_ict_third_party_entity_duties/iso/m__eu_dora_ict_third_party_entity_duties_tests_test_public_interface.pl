% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_dora_ict_third_party_entity_duties_tests_test_public_interface, [run_tests/0]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(clausal_lists_extra, [clausal_msort/2]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_dora_ict_third_party_entity_duties, [decide_dora_ict_third_party_entity_duties/2, dora_ict_third_party_entity_duties_status/2, dora_ict_third_party_entity_duties_checklist/2, dora_ict_third_party_entity_duties_decision_resolvable/1, dora_ict_third_party_entity_duties_status_values/1, entity_duties_required/3, entity_duties_complete/3, entity_duties_outstanding/3, ict_third_party_strategy_required/3]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_fixtures, [dora_ict_third_party_entity_duties_subject/1, dora_ict_third_party_entity_duties_profile_for/2, dora_ict_third_party_entity_duties_assess/2]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_queries, [dora_ict_third_party_entity_duties_what_if/4]).
:- use_module(m__eu_dora_ict_third_party_entity_duties_kernel, [dora_ict_third_party_entity_duties_input_problems/2]).

checked_six([cite(eu_reg_2022_2554_art_28_4), cite(eu_reg_2022_2554_art_28_5), cite(eu_reg_2022_2554_art_28_6), cite(eu_reg_2022_2554_art_28_8), cite(eu_reg_2022_2554_art_29_1), cite(eu_reg_2022_2554_art_29_2)]).

always_duties([assessment_of_critical_or_important_function, assessment_of_supervisory_conditions, risk_identification_and_assessment, due_diligence_on_provider, conflicts_of_interest_assessment, provider_with_appropriate_information_security_standards]).

all_duties([assessment_of_critical_or_important_function, assessment_of_supervisory_conditions, risk_identification_and_assessment, due_diligence_on_provider, conflicts_of_interest_assessment, provider_with_appropriate_information_security_standards, consideration_of_most_up_to_date_information_security_standards, predetermined_audit_frequency_and_areas, verification_of_auditor_skills, exit_strategy, exit_without_business_disruption, exit_without_limiting_regulatory_compliance, exit_without_detriment_to_client_services, tested_and_reviewed_exit_plans, alternative_solutions_and_transition_plans, contingency_measures, concentration_risk_consideration, weighing_of_alternative_solutions, weighing_of_subcontracting_benefits_and_risks, consideration_of_insolvency_law_and_data_recovery, consideration_of_third_country_data_protection_and_enforcement, assessment_of_subcontracting_chains]).

unsure_referral(needs_legal_review(open_textured(supports_critical_or_important_function, cite(eu_reg_2022_2554_art_28_4_a)), [inputs_relied_on([assessed_whether_arrangement_supports_critical_or_important_function - true, assessed_supervisory_conditions_for_contracting - true, identified_and_assessed_relevant_risks - true, undertook_due_diligence_on_provider - true, identified_and_assessed_conflicts_of_interest - true, provider_complies_with_appropriate_information_security_standards - true, entity_exercises_access_inspection_and_audit_rights - false, supports_critical_or_important_function - unsure, considered_most_up_to_date_information_security_standards - false])])).

expected_status(plain_arrangement_complete, complete).
expected_status(plain_arrangement_supervisory_assessment_not_performed, incomplete).
expected_status(audit_arrangement_complete, complete).
expected_status(audit_arrangement_frequency_not_predetermined, incomplete).
expected_status(complex_audit_arrangement_complete, complete).
expected_status(complex_audit_arrangement_auditor_skills_not_verified, incomplete).
expected_status(critical_arrangement_complete, complete).
expected_status(critical_arrangement_exit_strategy_not_performed, incomplete).
expected_status(critical_arrangement_exit_strategy_not_performed_concentration_unanswered, incomplete).
expected_status(critical_arrangement_exit_strategy_unanswered, indeterminate([exit_strategy_in_place])).
expected_status(critical_arrangement_exit_strategy_not_performed_complexity_unanswered, incomplete).
expected_status(critical_arrangement_complexity_unanswered, indeterminate([arrangement_entails_high_technical_complexity])).
expected_status(critical_judgement_unsure_dependent_duty_not_performed, Status) :-
    unsure_referral(Status).
expected_status(critical_judgement_true_dependent_duty_not_performed, incomplete).
expected_status(third_country_provider_data_protection_not_considered, incomplete).
expected_status(union_provider_data_protection_not_considered, complete).
expected_status(subcontracting_arrangement_chains_not_assessed, incomplete).
expected_status(no_subcontracting_arrangement_chains_not_assessed, complete).
expected_status(empty_profile, indeterminate([assessed_whether_arrangement_supports_critical_or_important_function])).
expected_status(article_16_entity, complete).
expected_status(microenterprise_entity, complete).
expected_status(entity_exemption_unanswered, complete).
expected_status(duplicate_key_profile, input_problems([duplicate_key(exit_strategy_in_place)])).
expected_status(single_key_profile, indeterminate([assessed_whether_arrangement_supports_critical_or_important_function])).
expected_status(fact_given_unsure_profile, input_problems([wrong_type(arrangement_allows_further_subcontracting)])).
expected_status(judgement_given_unsure_profile, indeterminate([assessed_whether_arrangement_supports_critical_or_important_function])).
expected_status(unknown_key_profile, input_problems([unknown_key(unexpected_key)])).
expected_status(numeric_key_profile, input_problems([unknown_key(42)])).
expected_status(mixed_problems_profile, input_problems([wrong_type(supports_critical_or_important_function), unknown_key(unexpected_key)])).
expected_status(non_attribute_profile, input_problems([wrong_type(profile)])).

near_miss_pair(plain_arrangement_complete, plain_arrangement_supervisory_assessment_not_performed).
near_miss_pair(audit_arrangement_complete, audit_arrangement_frequency_not_predetermined).
near_miss_pair(complex_audit_arrangement_complete, complex_audit_arrangement_auditor_skills_not_verified).
near_miss_pair(critical_arrangement_complete, critical_arrangement_exit_strategy_not_performed).
near_miss_pair(union_provider_data_protection_not_considered, third_country_provider_data_protection_not_considered).
near_miss_pair(no_subcontracting_arrangement_chains_not_assessed, subcontracting_arrangement_chains_not_assessed).

profile_of(Subject, Profile) :-
    dora_ict_third_party_entity_duties_profile_for(Subject, Profile).

answers(Query, Subject, Answers) :-
    profile_of(Subject, Profile),
    findall(Result - Citations, call(Query, Profile, Result, Citations), Answers).

same_set(Left, Right) :-
    clausal_msort(Left, Sorted),
    clausal_msort(Right, Sorted).

near_miss_holds(Positive - Control) :-
    dora_ict_third_party_entity_duties_assess(Positive, dora_ict_third_party_entity_duties_verdict(complete, _)),
    dora_ict_third_party_entity_duties_assess(Control, dora_ict_third_party_entity_duties_verdict(incomplete, _)).

subject_answer_count(Query, Subject - Count) :-
    answers(Query, Subject, Answers),
    length(Answers, Count).

count_is_one(_ - 1).

status_known(Values, Status) :-
    functor(Status, Name, _),
    member(Name, Values).

is_cite(cite(Key)) :-
    atom(Key).

all_subjects(Subjects) :-
    findall(Subject, dora_ict_third_party_entity_duties_subject(Subject), Subjects).

test(every_subject_resolves_to_its_expected_status) :-
    findall(Subject - Status, (dora_ict_third_party_entity_duties_subject(Subject), dora_ict_third_party_entity_duties_assess(Subject, dora_ict_third_party_entity_duties_verdict(Status, _))), Actual),
    findall(Subject - Status, expected_status(Subject, Status), Expected),
    clausal_msort(Actual, SortedActual),
    clausal_msort(Expected, SortedExpected),
    SortedActual == SortedExpected.
test(near_miss_controls_get_the_opposite_verdict) :-
    findall(Positive - Control, near_miss_pair(Positive, Control), Pairs),
    length(Pairs, 6),
    maplist(near_miss_holds, Pairs).
test(plain_subject_is_complete) :-
    dora_ict_third_party_entity_duties_assess(plain_arrangement_complete, dora_ict_third_party_entity_duties_verdict(complete, _)).
test(unsure_function_judgement_is_referred_while_true_is_incomplete) :-
    unsure_referral(Referral),
    dora_ict_third_party_entity_duties_assess(critical_judgement_unsure_dependent_duty_not_performed, dora_ict_third_party_entity_duties_verdict(Referral, [])),
    dora_ict_third_party_entity_duties_assess(critical_judgement_true_dependent_duty_not_performed, dora_ict_third_party_entity_duties_verdict(incomplete, _)).
test(absent_exit_strategy_is_named_while_false_is_incomplete) :-
    dora_ict_third_party_entity_duties_assess(critical_arrangement_exit_strategy_unanswered, dora_ict_third_party_entity_duties_verdict(indeterminate([exit_strategy_in_place]), [])),
    dora_ict_third_party_entity_duties_assess(critical_arrangement_exit_strategy_not_performed_complexity_unanswered, dora_ict_third_party_entity_duties_verdict(incomplete, _)).
test(required_plain_lists_the_six_duties_that_always_apply) :-
    answers(entity_duties_required, plain_arrangement_complete, [required(Duties) - Citations]),
    always_duties(Duties),
    same_set(Citations, [cite(eu_reg_2022_2554_art_28_4), cite(eu_reg_2022_2554_art_28_5)]).
test(required_audit_adds_audit_practice) :-
    answers(entity_duties_required, audit_arrangement_complete, [required(Duties) - Citations]),
    always_duties(Always),
    append(Always, [predetermined_audit_frequency_and_areas], Duties),
    same_set(Citations, [cite(eu_reg_2022_2554_art_28_4), cite(eu_reg_2022_2554_art_28_5), cite(eu_reg_2022_2554_art_28_6)]).
test(required_complex_audit_adds_auditor_skills) :-
    answers(entity_duties_required, complex_audit_arrangement_complete, [required(Duties) - Citations]),
    always_duties(Always),
    append(Always, [predetermined_audit_frequency_and_areas, verification_of_auditor_skills], Duties),
    same_set(Citations, [cite(eu_reg_2022_2554_art_28_4), cite(eu_reg_2022_2554_art_28_5), cite(eu_reg_2022_2554_art_28_6)]).
test(required_critical_lists_all_twenty_two_duties) :-
    answers(entity_duties_required, critical_arrangement_complete, [required(Duties) - Citations]),
    all_duties(Duties),
    checked_six(Six),
    same_set(Citations, Six).
test(required_union_provider_omits_the_third_country_duty) :-
    answers(entity_duties_required, union_provider_data_protection_not_considered, [required(Duties) - _]),
    all_duties(All),
    select(consideration_of_third_country_data_protection_and_enforcement, All, Expected),
    Duties == Expected.
test(required_names_the_absent_complexity_judgement) :-
    answers(entity_duties_required, critical_arrangement_complexity_unanswered, Answers),
    Answers == [indeterminate([arrangement_entails_high_technical_complexity]) - []].
test(required_names_absent_subcontracting_under_an_unsure_function) :-
    answers(entity_duties_required, critical_judgement_unsure_dependent_duty_not_performed, Answers),
    Answers == [indeterminate([arrangement_allows_further_subcontracting]) - []].
test(required_refuses_a_duplicate_key) :-
    answers(entity_duties_required, duplicate_key_profile, Answers),
    Answers == [input_problems([duplicate_key(exit_strategy_in_place)]) - []].
test(complete_cites_the_six_checked_paragraphs) :-
    answers(entity_duties_complete, plain_arrangement_complete, [complete - Citations]),
    checked_six(Six),
    same_set(Citations, Six).
test(incomplete_cites_the_same_six_paragraphs) :-
    answers(entity_duties_complete, plain_arrangement_supervisory_assessment_not_performed, [incomplete - Citations]),
    checked_six(Six),
    same_set(Citations, Six).
test(complete_referral_carries_the_pairs_relied_on) :-
    unsure_referral(Referral),
    answers(entity_duties_complete, critical_judgement_unsure_dependent_duty_not_performed, Answers),
    Answers == [Referral - []].
test(complete_indeterminate_has_no_citations) :-
    answers(entity_duties_complete, critical_arrangement_complexity_unanswered, Answers),
    Answers == [indeterminate([arrangement_entails_high_technical_complexity]) - []].
test(none_outstanding_cites_the_six_checked_paragraphs) :-
    answers(entity_duties_outstanding, plain_arrangement_complete, [none_outstanding - Citations]),
    checked_six(Six),
    same_set(Citations, Six).
test(outstanding_lists_the_supervisory_assessment) :-
    answers(entity_duties_outstanding, plain_arrangement_supervisory_assessment_not_performed, Answers),
    Answers == [outstanding([assessment_of_supervisory_conditions]) - [cite(eu_reg_2022_2554_art_28_4_b)]].
test(outstanding_lists_the_audit_frequency) :-
    answers(entity_duties_outstanding, audit_arrangement_frequency_not_predetermined, Answers),
    Answers == [outstanding([predetermined_audit_frequency_and_areas]) - [cite(eu_reg_2022_2554_art_28_6)]].
test(outstanding_lists_the_auditor_skills) :-
    answers(entity_duties_outstanding, complex_audit_arrangement_auditor_skills_not_verified, Answers),
    Answers == [outstanding([verification_of_auditor_skills]) - [cite(eu_reg_2022_2554_art_28_6)]].
test(outstanding_lists_the_exit_strategy) :-
    answers(entity_duties_outstanding, critical_arrangement_exit_strategy_not_performed, Answers),
    Answers == [outstanding([exit_strategy]) - [cite(eu_reg_2022_2554_art_28_8)]].
test(outstanding_lists_the_third_country_duty) :-
    answers(entity_duties_outstanding, third_country_provider_data_protection_not_considered, Answers),
    Answers == [outstanding([consideration_of_third_country_data_protection_and_enforcement]) - [cite(eu_reg_2022_2554_art_29_2)]].
test(outstanding_waits_for_the_concentration_risk_key) :-
    answers(entity_duties_outstanding, critical_arrangement_exit_strategy_not_performed_concentration_unanswered, Answers),
    Answers == [indeterminate([considered_concentration_risk]) - []].
test(outstanding_names_the_exit_strategy_under_an_unsure_function) :-
    answers(entity_duties_outstanding, critical_judgement_unsure_dependent_duty_not_performed, Answers),
    Answers == [indeterminate([exit_strategy_in_place]) - []].
test(strategy_required_for_an_entity_that_is_not_exempt) :-
    answers(ict_third_party_strategy_required, plain_arrangement_complete, Answers),
    Answers == [strategy_required - [cite(eu_reg_2022_2554_art_28_2)]].
test(article_16_entity_needs_no_strategy) :-
    answers(ict_third_party_strategy_required, article_16_entity, Answers),
    Answers == [strategy_not_required - [cite(eu_reg_2022_2554_art_28_2)]].
test(microenterprise_needs_no_strategy) :-
    answers(ict_third_party_strategy_required, microenterprise_entity, Answers),
    Answers == [strategy_not_required - [cite(eu_reg_2022_2554_art_28_2)]].
test(strategy_asks_for_the_microenterprise_fact) :-
    answers(ict_third_party_strategy_required, entity_exemption_unanswered, Answers),
    Answers == [indeterminate([financial_entity_is_microenterprise]) - []].
test(strategy_asks_for_the_article_16_fact_first) :-
    answers(ict_third_party_strategy_required, empty_profile, Answers),
    Answers == [indeterminate([financial_entity_is_article_16_1_entity]) - []].
test(input_check_accepts_a_well_formed_profile) :-
    profile_of(plain_arrangement_complete, Profile),
    findall(Problems, dora_ict_third_party_entity_duties_input_problems(Profile, Problems), All),
    All == [[]].
test(input_check_refuses_an_unbound_profile) :-
    findall(Problems, dora_ict_third_party_entity_duties_input_problems(_, Problems), All),
    All == [[wrong_type(profile)]].
test(input_check_refuses_a_partial_list) :-
    findall(Problems, dora_ict_third_party_entity_duties_input_problems([attribute(exit_strategy_in_place, true)|_], Problems), All),
    All == [[wrong_type(profile)]].
test(input_check_names_an_unbound_key_as_given) :-
    Profile = [attribute(Key, true)],
    findall(Key - Problems, dora_ict_third_party_entity_duties_input_problems(Profile, Problems), [Copy - [unknown_key(Named)]]),
    Copy == Named.
test(input_check_gives_wrong_type_for_an_unbound_value) :-
    findall(Problems, dora_ict_third_party_entity_duties_input_problems([attribute(exit_strategy_in_place, _)], Problems), All),
    All == [[wrong_type(exit_strategy_in_place)]].
test(input_check_accepts_unsure_on_a_judgement) :-
    profile_of(judgement_given_unsure_profile, Profile),
    dora_ict_third_party_entity_duties_input_problems(Profile, []).
test(input_check_refuses_unsure_on_a_fact) :-
    profile_of(fact_given_unsure_profile, Profile),
    dora_ict_third_party_entity_duties_input_problems(Profile, [wrong_type(arrangement_allows_further_subcontracting)]).
test(every_query_yields_exactly_one_solution_on_every_subject) :-
    all_subjects(Subjects),
    maplist(count_query_once(Subjects), [entity_duties_required, entity_duties_complete, entity_duties_outstanding, ict_third_party_strategy_required]).
test(facade_verdict_yields_exactly_one_solution_on_every_subject) :-
    findall(Subject - Count, (dora_ict_third_party_entity_duties_subject(Subject), profile_of(Subject, Profile), findall(Verdict, decide_dora_ict_third_party_entity_duties(Profile, Verdict), Verdicts), length(Verdicts, Count)), Counts),
    maplist(count_is_one, Counts).
test(every_status_is_in_the_status_vocabulary) :-
    dora_ict_third_party_entity_duties_status_values(Values),
    findall(Status, (dora_ict_third_party_entity_duties_subject(Subject), profile_of(Subject, Profile), dora_ict_third_party_entity_duties_status(Profile, Status)), Statuses),
    maplist(status_known(Values), Statuses).
test(every_subject_has_a_non_empty_cited_checklist) :-
    all_subjects(Subjects),
    findall(Subject, (member(Subject, Subjects), profile_of(Subject, Profile), dora_ict_third_party_entity_duties_checklist(Profile, [_|_])), WithChecklist),
    WithChecklist == Subjects.
test(every_checklist_item_carries_a_citation) :-
    profile_of(critical_arrangement_exit_strategy_not_performed, Profile),
    dora_ict_third_party_entity_duties_checklist(Profile, Items),
    findall(Citation, member(item(_, _, Citation), Items), Citations),
    length(Items, Count),
    length(Citations, Count),
    maplist(is_cite, Citations).
test(checklist_marks_the_failing_duty_unmet) :-
    profile_of(critical_arrangement_exit_strategy_not_performed, Profile),
    dora_ict_third_party_entity_duties_checklist(Profile, Items),
    member(item(exit_strategy, unmet(not_performed), cite(eu_reg_2022_2554_art_28_8)), Items).
test(checklist_marks_the_performed_duty_met) :-
    profile_of(critical_arrangement_complete, Profile),
    dora_ict_third_party_entity_duties_checklist(Profile, Items),
    member(item(exit_strategy, met, cite(eu_reg_2022_2554_art_28_8)), Items).
test(decision_is_resolvable_on_every_subject) :-
    all_subjects(Subjects),
    findall(Subject, (member(Subject, Subjects), profile_of(Subject, Profile), dora_ict_third_party_entity_duties_decision_resolvable(Profile)), Resolvable),
    Resolvable == Subjects.
test(what_if_a_duty_is_not_performed_gives_incomplete) :-
    profile_of(plain_arrangement_complete, Profile),
    findall(Status, dora_ict_third_party_entity_duties_what_if(Profile, assessed_supervisory_conditions_for_contracting, false, Status), Statuses),
    Statuses == [incomplete].
test(what_if_the_near_miss_is_performed_gives_complete) :-
    profile_of(plain_arrangement_supervisory_assessment_not_performed, Profile),
    findall(Status, dora_ict_third_party_entity_duties_what_if(Profile, assessed_supervisory_conditions_for_contracting, true, Status), Statuses),
    Statuses == [complete].
test(what_if_an_absent_exit_strategy_is_filled_in) :-
    profile_of(critical_arrangement_exit_strategy_unanswered, Profile),
    findall(Status, dora_ict_third_party_entity_duties_what_if(Profile, exit_strategy_in_place, true, Status), Statuses),
    Statuses == [indeterminate([arrangement_entails_high_technical_complexity])].
test(what_if_keeps_a_malformed_profile_refused) :-
    profile_of(non_attribute_profile, Profile),
    findall(Status, dora_ict_third_party_entity_duties_what_if(Profile, exit_strategy_in_place, true, Status), Statuses),
    Statuses == [input_problems([wrong_type(profile)])].

test(plain_subject_is_not_incomplete, fail) :-
    dora_ict_third_party_entity_duties_assess(plain_arrangement_complete, dora_ict_third_party_entity_duties_verdict(incomplete, _)).
test(unsure_function_judgement_is_not_incomplete, fail) :-
    dora_ict_third_party_entity_duties_assess(critical_judgement_unsure_dependent_duty_not_performed, dora_ict_third_party_entity_duties_verdict(incomplete, _)).
test(absent_exit_strategy_is_not_complexity_first, fail) :-
    dora_ict_third_party_entity_duties_assess(critical_arrangement_exit_strategy_unanswered, dora_ict_third_party_entity_duties_verdict(indeterminate([arrangement_entails_high_technical_complexity]), _)).
test(outstanding_with_a_false_key_is_not_incomplete_alone, fail) :-
    answers(entity_duties_outstanding, critical_arrangement_exit_strategy_not_performed_concentration_unanswered, [outstanding(_) - _]).
test(entity_that_is_not_exempt_is_not_relieved, fail) :-
    answers(ict_third_party_strategy_required, plain_arrangement_complete, [strategy_not_required - _]).
test(checklist_of_a_complete_subject_has_no_unmet_exit_strategy, fail) :-
    profile_of(critical_arrangement_complete, Profile),
    dora_ict_third_party_entity_duties_checklist(Profile, Items),
    member(item(exit_strategy, unmet(_), _), Items).

count_query_once(Subjects, Query) :-
    findall(Subject - Count, (member(Subject, Subjects), subject_answer_count(Query, Subject - Count)), Counts),
    length(Subjects, Total),
    length(Counts, Total),
    maplist(count_is_one, Counts).

cp_test_names([every_subject_resolves_to_its_expected_status, near_miss_controls_get_the_opposite_verdict, plain_subject_is_complete, unsure_function_judgement_is_referred_while_true_is_incomplete, absent_exit_strategy_is_named_while_false_is_incomplete, required_plain_lists_the_six_duties_that_always_apply, required_audit_adds_audit_practice, required_complex_audit_adds_auditor_skills, required_critical_lists_all_twenty_two_duties, required_union_provider_omits_the_third_country_duty, required_names_the_absent_complexity_judgement, required_names_absent_subcontracting_under_an_unsure_function, required_refuses_a_duplicate_key, complete_cites_the_six_checked_paragraphs, incomplete_cites_the_same_six_paragraphs, complete_referral_carries_the_pairs_relied_on, complete_indeterminate_has_no_citations, none_outstanding_cites_the_six_checked_paragraphs, outstanding_lists_the_supervisory_assessment, outstanding_lists_the_audit_frequency, outstanding_lists_the_auditor_skills, outstanding_lists_the_exit_strategy, outstanding_lists_the_third_country_duty, outstanding_waits_for_the_concentration_risk_key, outstanding_names_the_exit_strategy_under_an_unsure_function, strategy_required_for_an_entity_that_is_not_exempt, article_16_entity_needs_no_strategy, microenterprise_needs_no_strategy, strategy_asks_for_the_microenterprise_fact, strategy_asks_for_the_article_16_fact_first, input_check_accepts_a_well_formed_profile, input_check_refuses_an_unbound_profile, input_check_refuses_a_partial_list, input_check_names_an_unbound_key_as_given, input_check_gives_wrong_type_for_an_unbound_value, input_check_accepts_unsure_on_a_judgement, input_check_refuses_unsure_on_a_fact, every_query_yields_exactly_one_solution_on_every_subject, facade_verdict_yields_exactly_one_solution_on_every_subject, every_status_is_in_the_status_vocabulary, every_subject_has_a_non_empty_cited_checklist, every_checklist_item_carries_a_citation, checklist_marks_the_failing_duty_unmet, checklist_marks_the_performed_duty_met, decision_is_resolvable_on_every_subject, what_if_a_duty_is_not_performed_gives_incomplete, what_if_the_near_miss_is_performed_gives_complete, what_if_an_absent_exit_strategy_is_filled_in, what_if_keeps_a_malformed_profile_refused]).
cp_test_fail_names([plain_subject_is_not_incomplete, unsure_function_judgement_is_not_incomplete, absent_exit_strategy_is_not_complexity_first, outstanding_with_a_false_key_is_not_incomplete_alone, entity_that_is_not_exempt_is_not_relieved, checklist_of_a_complete_subject_has_no_unmet_exit_strategy]).
run_tests :- cp_test_names(Ns), cp_run(Ns, succeed), cp_test_fail_names(Fs),
    cp_run(Fs, fail), write(cp_tests_done), nl.
cp_run([], _).
cp_run([N|T], Mode) :- cp_one(Mode, N, R), writeq(cp_result(N, R)), nl, cp_run(T, Mode).
cp_one(succeed, N, R) :- catch(( once(test(N)) -> R = pass ; R = fail ), E, R = error(E)).
cp_one(fail, N, R) :- catch(( once(test(N, fail)) -> R = fail ; R = pass ), E, R = error(E)).
