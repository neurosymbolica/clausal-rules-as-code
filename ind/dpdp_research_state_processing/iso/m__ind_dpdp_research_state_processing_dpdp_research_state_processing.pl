% SPDX-License-Identifier: EUPL-1.2
:- module(m__ind_dpdp_research_state_processing_dpdp_research_state_processing, [research_exemption/3, state_processing_standards/3, state_processing_disapplied_provisions/3, decide_dpdp_research_state_processing/2, dpdp_research_state_processing_status/2, dpdp_research_state_processing_checklist/2, dpdp_research_state_processing_decision_resolvable/1, dpdp_research_state_processing_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__ind_dpdp_research_state_processing_kernel, [dpdp_research_state_processing_input_problems/2, dpdp_research_state_processing_key_state/3, dpdp_research_state_processing_day_before/3]).
:- use_module(m__ind_dpdp_research_state_processing_citations, [implements/1]).

rules_commencement_day(date(2027, 5, 13), cite(in_dpdp_rules_2025_r_1_4)).

dpdp_research_state_processing_status_values([exempt_from_act, not_exempt, not_in_force, follows_second_schedule, does_not_follow_second_schedule, not_applicable, sections_8_7_12_2_and_12_3_do_not_apply, sections_8_7_and_12_3_do_not_apply]).

research_exemption_ladder([step(key_value(section_17_in_force_on_reference_date, false), not_in_force, [cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_rules_2025_r_16), cite(in_dpdp_act_2023_s_17_2), cite(in_dpdp_act_2023_s_17_2_b)]), step(before_commencement, not_in_force, [cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_rules_2025_r_16), cite(in_dpdp_act_2023_s_17_2), cite(in_dpdp_act_2023_s_17_2_b)]), step(key_value(section_17_in_force_on_reference_date, absent), indeterminate([section_17_in_force_on_reference_date]), []), step(key_value(reference_date, absent), indeterminate([reference_date]), []), step(key_value(processing_necessary_for_research_archiving_or_statistical_purposes, false), not_exempt, [cite(in_dpdp_act_2023_s_17_2), cite(in_dpdp_act_2023_s_17_2_b), cite(in_dpdp_rules_2025_r_16)]), step(key_value(personal_data_to_be_used_for_decision_specific_to_data_principal, true), not_exempt, [cite(in_dpdp_act_2023_s_17_2), cite(in_dpdp_act_2023_s_17_2_b), cite(in_dpdp_rules_2025_r_16)]), step(any_key_value([lawful_manner, limited_to_necessary_personal_data, completeness_accuracy_and_consistency, retention_only_while_required, reasonable_security_safeguards, accountability_for_observance], false), not_exempt, [cite(in_dpdp_act_2023_s_17_2), cite(in_dpdp_act_2023_s_17_2_b), cite(in_dpdp_rules_2025_r_16)]), step(key_value(processing_necessary_for_research_archiving_or_statistical_purposes, absent), indeterminate([processing_necessary_for_research_archiving_or_statistical_purposes]), []), step(key_value(personal_data_to_be_used_for_decision_specific_to_data_principal, absent), indeterminate([personal_data_to_be_used_for_decision_specific_to_data_principal]), []), step(key_value(lawful_manner, absent), indeterminate([lawful_manner]), []), step(key_value(limited_to_necessary_personal_data, absent), indeterminate([limited_to_necessary_personal_data]), []), step(key_value(completeness_accuracy_and_consistency, absent), indeterminate([completeness_accuracy_and_consistency]), []), step(key_value(retention_only_while_required, absent), indeterminate([retention_only_while_required]), []), step(key_value(reasonable_security_safeguards, absent), indeterminate([reasonable_security_safeguards]), []), step(key_value(accountability_for_observance, absent), indeterminate([accountability_for_observance]), []), step(key_value(processing_necessary_for_research_archiving_or_statistical_purposes, unsure), needs_legal_review(open_textured(processing_necessary_for_research_archiving_or_statistical_purposes, cite(in_dpdp_act_2023_s_17_2_b)), [inputs_relied_on([processing_necessary_for_research_archiving_or_statistical_purposes - unsure])]), []), step(key_value(lawful_manner, unsure), needs_legal_review(open_textured(lawful_manner, cite(in_dpdp_rules_2025_sch_2_a)), [inputs_relied_on([lawful_manner - unsure])]), []), step(key_value(limited_to_necessary_personal_data, unsure), needs_legal_review(open_textured(limited_to_necessary_personal_data, cite(in_dpdp_rules_2025_sch_2_c)), [inputs_relied_on([limited_to_necessary_personal_data - unsure])]), []), step(key_value(completeness_accuracy_and_consistency, unsure), needs_legal_review(open_textured(completeness_accuracy_and_consistency, cite(in_dpdp_rules_2025_sch_2_d)), [inputs_relied_on([completeness_accuracy_and_consistency - unsure])]), []), step(key_value(retention_only_while_required, unsure), needs_legal_review(open_textured(retention_only_while_required, cite(in_dpdp_rules_2025_sch_2_e)), [inputs_relied_on([retention_only_while_required - unsure])]), []), step(key_value(reasonable_security_safeguards, unsure), needs_legal_review(open_textured(reasonable_security_safeguards, cite(in_dpdp_rules_2025_sch_2_f)), [inputs_relied_on([reasonable_security_safeguards - unsure])]), []), step(key_value(accountability_for_observance, unsure), needs_legal_review(open_textured(accountability_for_observance, cite(in_dpdp_rules_2025_sch_2_h)), [inputs_relied_on([accountability_for_observance - unsure])]), []), step(always, exempt_from_act, [cite(in_dpdp_act_2023_s_17_2), cite(in_dpdp_act_2023_s_17_2_b), cite(in_dpdp_rules_2025_r_16), cite(in_dpdp_rules_2025_sch_2), cite(in_dpdp_rules_2025_sch_2_a), cite(in_dpdp_rules_2025_sch_2_b), cite(in_dpdp_rules_2025_sch_2_c), cite(in_dpdp_rules_2025_sch_2_d), cite(in_dpdp_rules_2025_sch_2_e), cite(in_dpdp_rules_2025_sch_2_f), cite(in_dpdp_rules_2025_sch_2_h)])]).

state_processing_standards_ladder([step(key_value(section_7_in_force_on_reference_date, false), not_in_force, [cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_rules_2025_r_5_1), cite(in_dpdp_act_2023_s_7_b)]), step(before_commencement, not_in_force, [cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_rules_2025_r_5_1), cite(in_dpdp_act_2023_s_7_b)]), step(key_value(section_7_in_force_on_reference_date, absent), indeterminate([section_7_in_force_on_reference_date]), []), step(key_value(reference_date, absent), indeterminate([reference_date]), []), step(key_value(processing_for_section_7_b_use, false), not_applicable, [cite(in_dpdp_rules_2025_r_5_1), cite(in_dpdp_act_2023_s_7_b)]), step(key_value(processing_for_section_7_b_use, absent), indeterminate([processing_for_section_7_b_use]), []), step(both(key_value(processing_for_section_7_b_use, unsure), any_key_value([lawful_manner, limited_to_necessary_personal_data, completeness_accuracy_and_consistency, retention_only_while_required, reasonable_security_safeguards, intimation_to_data_principal, business_contact_for_questions, link_and_means_to_exercise_rights, consistent_with_other_applicable_standards, accountability_for_observance], false)), needs_legal_review(open_textured(processing_for_section_7_b_use, cite(in_dpdp_act_2023_s_7_b)), [inputs_relied_on([processing_for_section_7_b_use - unsure])]), []), step(any_key_value([lawful_manner, limited_to_necessary_personal_data, completeness_accuracy_and_consistency, retention_only_while_required, reasonable_security_safeguards, intimation_to_data_principal, business_contact_for_questions, link_and_means_to_exercise_rights, consistent_with_other_applicable_standards, accountability_for_observance], false), does_not_follow_second_schedule, [cite(in_dpdp_rules_2025_r_5_1), cite(in_dpdp_rules_2025_sch_2)]), step(key_value(lawful_manner, absent), indeterminate([lawful_manner]), []), step(key_value(limited_to_necessary_personal_data, absent), indeterminate([limited_to_necessary_personal_data]), []), step(key_value(completeness_accuracy_and_consistency, absent), indeterminate([completeness_accuracy_and_consistency]), []), step(key_value(retention_only_while_required, absent), indeterminate([retention_only_while_required]), []), step(key_value(reasonable_security_safeguards, absent), indeterminate([reasonable_security_safeguards]), []), step(key_value(intimation_to_data_principal, absent), indeterminate([intimation_to_data_principal]), []), step(key_value(business_contact_for_questions, absent), indeterminate([business_contact_for_questions]), []), step(key_value(link_and_means_to_exercise_rights, absent), indeterminate([link_and_means_to_exercise_rights]), []), step(key_value(consistent_with_other_applicable_standards, absent), indeterminate([consistent_with_other_applicable_standards]), []), step(key_value(accountability_for_observance, absent), indeterminate([accountability_for_observance]), []), step(key_value(processing_for_section_7_b_use, unsure), needs_legal_review(open_textured(processing_for_section_7_b_use, cite(in_dpdp_act_2023_s_7_b)), [inputs_relied_on([processing_for_section_7_b_use - unsure])]), []), step(key_value(lawful_manner, unsure), needs_legal_review(open_textured(lawful_manner, cite(in_dpdp_rules_2025_sch_2_a)), [inputs_relied_on([lawful_manner - unsure])]), []), step(key_value(limited_to_necessary_personal_data, unsure), needs_legal_review(open_textured(limited_to_necessary_personal_data, cite(in_dpdp_rules_2025_sch_2_c)), [inputs_relied_on([limited_to_necessary_personal_data - unsure])]), []), step(key_value(completeness_accuracy_and_consistency, unsure), needs_legal_review(open_textured(completeness_accuracy_and_consistency, cite(in_dpdp_rules_2025_sch_2_d)), [inputs_relied_on([completeness_accuracy_and_consistency - unsure])]), []), step(key_value(retention_only_while_required, unsure), needs_legal_review(open_textured(retention_only_while_required, cite(in_dpdp_rules_2025_sch_2_e)), [inputs_relied_on([retention_only_while_required - unsure])]), []), step(key_value(reasonable_security_safeguards, unsure), needs_legal_review(open_textured(reasonable_security_safeguards, cite(in_dpdp_rules_2025_sch_2_f)), [inputs_relied_on([reasonable_security_safeguards - unsure])]), []), step(key_value(consistent_with_other_applicable_standards, unsure), needs_legal_review(open_textured(consistent_with_other_applicable_standards, cite(in_dpdp_rules_2025_sch_2_g_iii)), [inputs_relied_on([consistent_with_other_applicable_standards - unsure])]), []), step(key_value(accountability_for_observance, unsure), needs_legal_review(open_textured(accountability_for_observance, cite(in_dpdp_rules_2025_sch_2_h)), [inputs_relied_on([accountability_for_observance - unsure])]), []), step(always, follows_second_schedule, [cite(in_dpdp_rules_2025_r_5_1), cite(in_dpdp_rules_2025_sch_2), cite(in_dpdp_rules_2025_sch_2_a), cite(in_dpdp_rules_2025_sch_2_b), cite(in_dpdp_rules_2025_sch_2_c), cite(in_dpdp_rules_2025_sch_2_d), cite(in_dpdp_rules_2025_sch_2_e), cite(in_dpdp_rules_2025_sch_2_f), cite(in_dpdp_rules_2025_sch_2_g), cite(in_dpdp_rules_2025_sch_2_g_i), cite(in_dpdp_rules_2025_sch_2_g_ii), cite(in_dpdp_rules_2025_sch_2_g_iii), cite(in_dpdp_rules_2025_sch_2_h)])]).

state_processing_disapplied_provisions_ladder([step(key_value(section_17_in_force_on_reference_date, false), not_in_force, [cite(in_dpdp_act_2023_s_17_4)]), step(key_value(section_17_in_force_on_reference_date, absent), indeterminate([section_17_in_force_on_reference_date]), []), step(key_value(processing_by_state_or_instrumentality, false), not_applicable, [cite(in_dpdp_act_2023_s_17_4)]), step(key_value(processing_by_state_or_instrumentality, absent), indeterminate([processing_by_state_or_instrumentality]), []), step(key_value(purpose_includes_decision_affecting_data_principal, absent), indeterminate([purpose_includes_decision_affecting_data_principal]), []), step(key_value(processing_by_state_or_instrumentality, unsure), needs_legal_review(open_textured(processing_by_state_or_instrumentality, cite(in_dpdp_act_2023_s_17_4)), [inputs_relied_on([processing_by_state_or_instrumentality - unsure])]), []), step(key_value(purpose_includes_decision_affecting_data_principal, unsure), needs_legal_review(open_textured(purpose_includes_decision_affecting_data_principal, cite(in_dpdp_act_2023_s_17_4)), [inputs_relied_on([purpose_includes_decision_affecting_data_principal - unsure])]), []), step(key_value(purpose_includes_decision_affecting_data_principal, false), sections_8_7_12_2_and_12_3_do_not_apply, [cite(in_dpdp_act_2023_s_17_4)]), step(always, sections_8_7_and_12_3_do_not_apply, [cite(in_dpdp_act_2023_s_17_4)])]).

research_exemption(Profile, Result, Citations) :-
    dpdp_research_state_processing_input_problems(Profile, Problems),
    research_exemption_answer(Problems, Profile, Result, Citations).

research_exemption_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
research_exemption_answer([], Profile, Result, Citations) :-
    implements(in_dpdp_act_2023_s_17_2_b),
    research_exemption_ladder(Steps),
    ladder_first_step(Steps, Profile, Result, Citations).

state_processing_standards(Profile, Result, Citations) :-
    dpdp_research_state_processing_input_problems(Profile, Problems),
    state_processing_standards_answer(Problems, Profile, Result, Citations).

state_processing_standards_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
state_processing_standards_answer([], Profile, Result, Citations) :-
    implements(in_dpdp_rules_2025_r_5_1),
    state_processing_standards_ladder(Steps),
    ladder_first_step(Steps, Profile, Result, Citations).

state_processing_disapplied_provisions(Profile, Result, Citations) :-
    dpdp_research_state_processing_input_problems(Profile, Problems),
    state_processing_disapplied_provisions_answer(Problems, Profile, Result, Citations).

state_processing_disapplied_provisions_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
state_processing_disapplied_provisions_answer([], Profile, Result, Citations) :-
    implements(in_dpdp_act_2023_s_17_4),
    state_processing_disapplied_provisions_ladder(Steps),
    ladder_first_step(Steps, Profile, Result, Citations).

ladder_first_step([step(Condition, StepResult, StepCitations)|Steps], Profile, Result, Citations) :-
    condition_verdict(Condition, Profile, Verdict),
    take_ladder_step(Verdict, StepResult, StepCitations, Steps, Profile, Result, Citations).

take_ladder_step(holds, Result, Citations, _, _, Result, Citations).
take_ladder_step(does_not_hold, _, _, Steps, Profile, Result, Citations) :-
    ladder_first_step(Steps, Profile, Result, Citations).

condition_verdict(always, _, holds).
condition_verdict(key_value(Key, Value), Profile, Verdict) :-
    dpdp_research_state_processing_key_state(Profile, Key, State),
    same_verdict(State, Value, Verdict).
condition_verdict(any_key_value(Keys, Value), Profile, Verdict) :-
    any_key_verdict(Keys, Value, Profile, Verdict).
condition_verdict(before_commencement, Profile, Verdict) :-
    implements(in_dpdp_rules_2025_r_1_4),
    dpdp_research_state_processing_key_state(Profile, reference_date, State),
    commencement_verdict(State, Verdict).
condition_verdict(both(First, Second), Profile, Verdict) :-
    condition_verdict(First, Profile, FirstVerdict),
    condition_verdict(Second, Profile, SecondVerdict),
    verdict_and(FirstVerdict, SecondVerdict, Verdict).

same_verdict(State, State, holds).
same_verdict(State, Value, does_not_hold) :-
    dif(State, Value).

any_key_verdict([], _, _, does_not_hold).
any_key_verdict([Key|Keys], Value, Profile, Verdict) :-
    dpdp_research_state_processing_key_state(Profile, Key, State),
    same_verdict(State, Value, KeyVerdict),
    any_more_verdict(KeyVerdict, Keys, Value, Profile, Verdict).

any_more_verdict(holds, _, _, _, holds).
any_more_verdict(does_not_hold, Keys, Value, Profile, Verdict) :-
    any_key_verdict(Keys, Value, Profile, Verdict).

verdict_and(holds, Verdict, Verdict).
verdict_and(does_not_hold, _, does_not_hold).

commencement_verdict(absent, does_not_hold).
commencement_verdict(date(Year, Month, DayNumber), Verdict) :-
    implements(in_dpdp_rules_2025_r_1_4),
    rules_commencement_day(CommencementDay, _Citation),
    dpdp_research_state_processing_day_before(date(Year, Month, DayNumber), CommencementDay, Order),
    order_verdict(Order, Verdict).

order_verdict(before, holds).
order_verdict(not_before, does_not_hold).

decide_dpdp_research_state_processing(Profile, dpdp_research_state_processing_verdict(determinations(ResearchResult, StandardsResult, DisappliedResult), Citations)) :-
    research_exemption(Profile, ResearchResult, ResearchCitations),
    state_processing_standards(Profile, StandardsResult, StandardsCitations),
    state_processing_disapplied_provisions(Profile, DisappliedResult, DisappliedCitations),
    append([ResearchCitations, StandardsCitations, DisappliedCitations], AllCitations),
    sort(AllCitations, Citations).

dpdp_research_state_processing_status(Profile, Status) :-
    decide_dpdp_research_state_processing(Profile, dpdp_research_state_processing_verdict(Status, _Citations)).

dpdp_research_state_processing_checklist(Profile, [item(research_exemption, ResearchResult, ResearchCitations), item(state_processing_standards, StandardsResult, StandardsCitations), item(state_processing_disapplied_provisions, DisappliedResult, DisappliedCitations)]) :-
    research_exemption(Profile, ResearchResult, ResearchCitations),
    state_processing_standards(Profile, StandardsResult, StandardsCitations),
    state_processing_disapplied_provisions(Profile, DisappliedResult, DisappliedCitations).

dpdp_research_state_processing_decision_resolvable(Profile) :-
    decide_dpdp_research_state_processing(Profile, _Verdict).

complete_profile([attribute(section_7_in_force_on_reference_date, true), attribute(section_17_in_force_on_reference_date, true), attribute(reference_date, date(2027, 6, 1)), attribute(processing_necessary_for_research_archiving_or_statistical_purposes, true), attribute(personal_data_to_be_used_for_decision_specific_to_data_principal, false), attribute(processing_for_section_7_b_use, true), attribute(lawful_manner, true), attribute(limited_to_necessary_personal_data, true), attribute(completeness_accuracy_and_consistency, true), attribute(retention_only_while_required, true), attribute(reasonable_security_safeguards, true), attribute(intimation_to_data_principal, true), attribute(business_contact_for_questions, true), attribute(link_and_means_to_exercise_rights, true), attribute(consistent_with_other_applicable_standards, true), attribute(accountability_for_observance, true), attribute(processing_by_state_or_instrumentality, true), attribute(purpose_includes_decision_affecting_data_principal, false)]).

replaced(Base, Key, Value, [attribute(Key, Value)|Rest]) :-
    select(attribute(Key, _), Base, Rest).

removed(Base, Key, Rest) :-
    select(attribute(Key, _), Base, Rest).

profile_with(Key, Value, Profile) :-
    complete_profile(Base),
    replaced(Base, Key, Value, Profile).

test(a_complete_profile_is_exempt_from_the_act) :-
    complete_profile(Profile),
    research_exemption(Profile, exempt_from_act, Citations),
    length(Citations, 11).
test(each_query_yields_exactly_one_solution) :-
    complete_profile(Profile),
    findall(Result - Citations, research_exemption(Profile, Result, Citations), ResearchAnswers),
    findall(Result - Citations, state_processing_standards(Profile, Result, Citations), StandardsAnswers),
    findall(Result - Citations, state_processing_disapplied_provisions(Profile, Result, Citations), DisappliedAnswers),
    length(ResearchAnswers, 1),
    length(StandardsAnswers, 1),
    length(DisappliedAnswers, 1).
test(section_17_not_in_force_gives_not_in_force) :-
    profile_with(section_17_in_force_on_reference_date, false, Profile),
    research_exemption(Profile, not_in_force, ResearchCitations),
    length(ResearchCitations, 4),
    state_processing_disapplied_provisions(Profile, not_in_force, [cite(in_dpdp_act_2023_s_17_4)]).
test(the_day_before_commencement_is_not_in_force) :-
    profile_with(reference_date, date(2027, 5, 12), Profile),
    research_exemption(Profile, not_in_force, _),
    state_processing_standards(Profile, not_in_force, _),
    state_processing_disapplied_provisions(Profile, sections_8_7_12_2_and_12_3_do_not_apply, _).
test(an_early_day_settles_not_in_force_before_a_missing_section) :-
    research_exemption([attribute(reference_date, date(2026, 1, 1))], not_in_force, _).
test(the_commencement_day_is_in_force) :-
    profile_with(reference_date, date(2027, 5, 13), Profile),
    research_exemption(Profile, exempt_from_act, _).
test(a_decision_specific_use_is_not_exempt) :-
    profile_with(personal_data_to_be_used_for_decision_specific_to_data_principal, true, Profile),
    research_exemption(Profile, not_exempt, Citations),
    length(Citations, 3).
test(a_false_standard_settles_not_exempt_over_an_unsure_purpose) :-
    profile_with(processing_necessary_for_research_archiving_or_statistical_purposes, unsure, Unsure),
    replaced(Unsure, lawful_manner, false, Profile),
    research_exemption(Profile, not_exempt, _).
test(an_unsure_purpose_is_referred) :-
    profile_with(processing_necessary_for_research_archiving_or_statistical_purposes, unsure, Profile),
    research_exemption(Profile, needs_legal_review(open_textured(processing_necessary_for_research_archiving_or_statistical_purposes, cite(in_dpdp_act_2023_s_17_2_b)), [inputs_relied_on([processing_necessary_for_research_archiving_or_statistical_purposes - unsure])]), []).
test(a_missing_standard_is_named_before_an_unsure_purpose) :-
    profile_with(processing_necessary_for_research_archiving_or_statistical_purposes, unsure, Unsure),
    removed(Unsure, lawful_manner, Profile),
    research_exemption(Profile, indeterminate([lawful_manner]), []).
test(an_empty_profile_names_the_first_key) :-
    research_exemption([], indeterminate([section_17_in_force_on_reference_date]), []),
    state_processing_standards([], indeterminate([section_7_in_force_on_reference_date]), []),
    state_processing_disapplied_provisions([], indeterminate([section_17_in_force_on_reference_date]), []).
test(a_complete_profile_follows_the_second_schedule) :-
    complete_profile(Profile),
    state_processing_standards(Profile, follows_second_schedule, Citations),
    length(Citations, 13).
test(an_unsure_state_use_with_a_false_standard_is_referred) :-
    profile_with(processing_for_section_7_b_use, unsure, Unsure),
    replaced(Unsure, intimation_to_data_principal, false, Profile),
    state_processing_standards(Profile, needs_legal_review(open_textured(processing_for_section_7_b_use, cite(in_dpdp_act_2023_s_7_b)), [inputs_relied_on([processing_for_section_7_b_use - unsure])]), []).
test(a_false_standard_does_not_follow_the_second_schedule) :-
    profile_with(intimation_to_data_principal, false, Profile),
    state_processing_standards(Profile, does_not_follow_second_schedule, [cite(in_dpdp_rules_2025_r_5_1), cite(in_dpdp_rules_2025_sch_2)]).
test(processing_outside_section_7_b_is_not_applicable) :-
    profile_with(processing_for_section_7_b_use, false, Profile),
    state_processing_standards(Profile, not_applicable, _).
test(a_decision_purpose_keeps_section_12_2) :-
    profile_with(purpose_includes_decision_affecting_data_principal, true, Profile),
    state_processing_disapplied_provisions(Profile, sections_8_7_and_12_3_do_not_apply, [cite(in_dpdp_act_2023_s_17_4)]).
test(a_missing_purpose_is_named_before_an_unsure_state_body) :-
    profile_with(processing_by_state_or_instrumentality, unsure, Unsure),
    removed(Unsure, purpose_includes_decision_affecting_data_principal, Profile),
    state_processing_disapplied_provisions(Profile, indeterminate([purpose_includes_decision_affecting_data_principal]), []).
test(an_unsure_state_body_is_referred) :-
    profile_with(processing_by_state_or_instrumentality, unsure, Profile),
    state_processing_disapplied_provisions(Profile, needs_legal_review(open_textured(processing_by_state_or_instrumentality, cite(in_dpdp_act_2023_s_17_4)), [inputs_relied_on([processing_by_state_or_instrumentality - unsure])]), []).
test(an_unknown_key_is_an_input_problem) :-
    complete_profile(Base),
    append(Base, [attribute(colour, red)], Profile),
    research_exemption(Profile, input_problems([unknown_key(colour)]), []),
    state_processing_standards(Profile, input_problems([unknown_key(colour)]), []),
    state_processing_disapplied_provisions(Profile, input_problems([unknown_key(colour)]), []).
test(the_facade_verdict_holds_the_three_results) :-
    complete_profile(Profile),
    dpdp_research_state_processing_status(Profile, determinations(exempt_from_act, follows_second_schedule, sections_8_7_12_2_and_12_3_do_not_apply)).
test(the_checklist_carries_a_citation_per_row) :-
    complete_profile(Profile),
    dpdp_research_state_processing_checklist(Profile, Items),
    length(Items, 3),
    member(item(state_processing_disapplied_provisions, _, [cite(in_dpdp_act_2023_s_17_4)]), Items).

test(a_decision_specific_use_is_not_exempt_from_the_act, fail) :-
    profile_with(personal_data_to_be_used_for_decision_specific_to_data_principal, true, Profile),
    research_exemption(Profile, exempt_from_act, _).
test(a_false_standard_does_not_follow_it, fail) :-
    profile_with(intimation_to_data_principal, false, Profile),
    state_processing_standards(Profile, follows_second_schedule, _).
