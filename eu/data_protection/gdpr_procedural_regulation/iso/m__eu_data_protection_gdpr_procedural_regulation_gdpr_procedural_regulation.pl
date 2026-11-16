% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_procedural_regulation_gdpr_procedural_regulation, [complaint_admissibility/3, prior_request_condition/3, early_resolution/3, simple_cooperation_procedure/4, draft_decision_time_limit/4, late_step_effect/4, procedural_time_limit/4, temporal_application/5, decide_gdpr_procedural_regulation/2, gdpr_procedural_regulation_status/2, gdpr_procedural_regulation_checklist/2, gdpr_procedural_regulation_decision_resolvable/1, gdpr_procedural_regulation_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(library(error), [must_be/2]).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_kernel, [gdpr_procedural_regulation_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_citations, [implements/1]).

gdpr_procedural_regulation_status_values([admissible, inadmissible]).

time_limit_row(declare_complaint_inadmissible, limit(2, weeks, within, receipt_of_complaint, no_extension), [cite(eu_reg_2025_2518_art_4_2)]).
time_limit_row(transmit_complaint_to_presumed_lead_authority, limit(6, weeks, within, receipt_of_complaint, no_extension), [cite(eu_reg_2025_2518_art_4_5)]).
time_limit_row(confirm_competence_or_refer_to_board, limit(6, weeks, within, receipt_of_complaint, no_extension), [cite(eu_reg_2025_2518_art_4_6)]).
time_limit_row(object_to_early_resolution, limit(4, weeks, within, complainant_receiving_early_resolution_information, no_extension), [cite(eu_reg_2025_2518_art_5_2_c)]).
time_limit_row(establish_early_resolution, limit(2, weeks, within, expiry_of_objection_time_limit, no_extension), [cite(eu_reg_2025_2518_art_5_3)]).
time_limit_row(submit_early_resolution_draft_decision, limit(4, weeks, within, expiry_of_objection_time_limit, no_extension), [cite(eu_reg_2025_2518_art_5_4)]).
time_limit_row(notify_simple_cooperation_procedure, limit(6, weeks, within, confirmation_of_competence_or_board_binding_decision, no_extension), [cite(eu_reg_2025_2518_art_6_2)]).
time_limit_row(object_to_simple_cooperation_procedure, limit(2, weeks, within, notification_of_simple_cooperation_procedure, no_extension), [cite(eu_reg_2025_2518_art_6_3)]).
time_limit_row(provide_summary_of_key_issues, limit(3, months, within, confirmation_of_competence_or_board_binding_decision, no_extension), [cite(eu_reg_2025_2518_art_10_3)]).
time_limit_row(comment_on_summary_of_key_issues, limit(4, weeks, within, receipt_of_summary_of_key_issues, extension(exactly, 2, weeks)), [cite(eu_reg_2025_2518_art_10_4)]).
time_limit_row(respond_to_comments_on_summary_of_key_issues, limit(4, weeks, within, expiry_of_comment_period, extension(exactly, 2, weeks)), [cite(eu_reg_2025_2518_art_10_5)]).
time_limit_row(submit_draft_decision, limit(15, months, within, confirmation_of_competence_or_board_binding_decision, extension(up_to, 12, months)), [cite(eu_reg_2025_2518_art_12_1), cite(eu_reg_2025_2518_art_12_3)]).
time_limit_row(inform_of_draft_decision_extension, limit(4, weeks, at_least_before, expiry_of_draft_decision_time_limit, no_extension), [cite(eu_reg_2025_2518_art_12_3)]).
time_limit_row(object_to_draft_decision_extension, limit(2, weeks, within, being_informed_of_extension, no_extension), [cite(eu_reg_2025_2518_art_12_4)]).
time_limit_row(submit_draft_decision_in_simple_procedure, limit(12, months, within, confirmation_of_competence_or_board_binding_decision, extension(up_to, 2, months)), [cite(eu_reg_2025_2518_art_12_6)]).
time_limit_row(inform_of_simple_procedure_extension, limit(2, weeks, at_least_before, expiry_of_simple_procedure_time_limit, no_extension), [cite(eu_reg_2025_2518_art_12_6)]).

admissibility_point(point_a, lodging_person_name_and_contact_details_included, every_complaint, cite(eu_reg_2025_2518_art_4_1_a)).
admissibility_point(point_b, proof_of_proper_constitution_included, lodged_by([article_80_1_body, article_80_2_body]), cite(eu_reg_2025_2518_art_4_1_b)).
admissibility_point(point_c, proof_of_data_subject_mandate_included, lodged_by([article_80_1_body]), cite(eu_reg_2025_2518_art_4_1_c)).
admissibility_point(point_d, controller_or_processor_identification_information_included, every_complaint, cite(eu_reg_2025_2518_art_4_1_d)).
admissibility_point(point_e, alleged_infringement_description_included, every_complaint, cite(eu_reg_2025_2518_art_4_1_e)).

outside_fact_row(case_handled_under_article_56_2, cite(eu_reg_2025_2518_art_6_5), cite(article_56_2_local_case_statement)).
outside_fact_row(national_law_requires_domestic_proceedings_after_time_limit, cite(eu_reg_2025_2518_art_12_6), cite(national_domestic_proceedings_statement)).
outside_fact_row(time_limit_set_by_this_regulation_or_article_65_6, cite(eu_reg_2025_2518_art_14), cite(time_limit_source_statement)).

judgement_referral_row(complaint_concerns_right_exercised_by_request, cite(eu_reg_2025_2518_art_4_3)).
judgement_referral_row(issues_addressable_without_additional_cooperation, cite(eu_reg_2025_2518_art_6_1_b)).
judgement_referral_row(extension_justified_by_exceptional_complexity, cite(eu_reg_2025_2518_art_12_3)).

application_day(2027, 4, 2, cite(eu_reg_2025_2518_art_37_2)).

application_part(complaints_and_early_resolution, on_or_after, [cite(eu_reg_2025_2518_art_37_2)]).
application_part(cooperation_and_files, after, [cite(eu_reg_2025_2518_art_36), cite(eu_reg_2025_2518_art_37_2)]).
application_part(dispute_resolution_and_urgency, after, [cite(eu_reg_2025_2518_art_36), cite(eu_reg_2025_2518_art_37_2)]).

key_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
key_state(Profile, ProfileKey, Value) :-
    profile_has(Profile, ProfileKey),
    profile_get(Profile, ProfileKey, Value).

outside_state(Profile, ProfileKey, absent) :-
    profile_lacks(Profile, ProfileKey).
outside_state(Profile, ProfileKey, State) :-
    profile_has(Profile, ProfileKey),
    profile_get(Profile, ProfileKey, Attested),
    Attested = attested(AttestedValue, _),
    attested_state(AttestedValue, Attested, State).

attested_state(true, Attested, attested_true(Attested)).
attested_state(false, Attested, attested_false(Attested)).

absent_referral(ProfileKey, needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, not_attempted), inputs_relied_on([ProfileKey - absent])])) :-
    outside_fact_row(ProfileKey, Citation, Target).

open_textured_referral(ProfileKey, needs_legal_review(open_textured(ProfileKey, Citation), [inputs_relied_on([ProfileKey - unsure])])) :-
    judgement_referral_row(ProfileKey, Citation).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

complaint_admissibility(Profile, Result, Citations) :-
    gdpr_procedural_regulation_input_problems(Profile, Problems),
    admissibility_after_input_check(Problems, Profile, Result, Citations).

admissibility_after_input_check([Problem|Problems], _, input_problems([Problem|Problems]), []).
admissibility_after_input_check([], Profile, Result, Citations) :-
    key_state(Profile, complaint_lodged_by, Lodger),
    admissibility_pairs(Profile, Lodger, Pairs),
    pairs_values(Pairs, States),
    memberd_t(false, States, ItemMissing),
    admissibility_outcome(ItemMissing, Pairs, Lodger, Result, Citations).

point_scope_status(every_complaint, _, applies) :-
    implements(eu_reg_2025_2518_art_4_1).
point_scope_status(lodged_by(_), absent, undetermined).
point_scope_status(lodged_by(Lodgers), Lodger, Status) :-
    implements(eu_reg_2025_2518_art_4_1),
    dif(Lodger, absent),
    memberd_t(Lodger, Lodgers, Truth),
    scope_truth(Truth, Status).

scope_truth(true, applies).
scope_truth(false, inapplicable).

admissibility_pairs(Profile, Lodger, Pairs) :-
    findall(ProfileKey - State, common_point_state(Profile, ProfileKey, State), CommonPairs),
    findall(ProfileKey - State, lodger_point_state(Profile, Lodger, ProfileKey, State), LodgerPairs),
    append(CommonPairs, [complaint_lodged_by - Lodger|LodgerPairs], Pairs).

common_point_state(Profile, ProfileKey, State) :-
    admissibility_point(_, ProfileKey, every_complaint, _),
    key_state(Profile, ProfileKey, State).

lodger_point_state(Profile, Lodger, ProfileKey, State) :-
    admissibility_point(_, ProfileKey, lodged_by(Lodgers), _),
    point_scope_status(lodged_by(Lodgers), Lodger, applies),
    key_state(Profile, ProfileKey, State).

first_absent_key([], none).
first_absent_key([ProfileKey - absent|_], key(ProfileKey)).
first_absent_key([_ - State|Pairs], FirstAbsent) :-
    dif(State, absent),
    first_absent_key(Pairs, FirstAbsent).

admissibility_outcome(true, _, _, inadmissible, [cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_2), cite(eu_reg_2025_2518_art_4_5)]) :-
    implements(eu_reg_2025_2518_art_4_2).
admissibility_outcome(false, Pairs, Lodger, Result, Citations) :-
    first_absent_key(Pairs, FirstAbsent),
    admissibility_completion(FirstAbsent, Lodger, Result, Citations).

admissibility_completion(key(ProfileKey), _, indeterminate([ProfileKey]), []).
admissibility_completion(none, Lodger, admissible, Citations) :-
    implements(eu_reg_2025_2518_art_4_1),
    findall(PointCitation, applicable_point_citation(Lodger, PointCitation), PointCitations),
    append([cite(eu_reg_2025_2518_art_4_1)|PointCitations], [cite(eu_reg_2025_2518_art_4_5)], Citations).

applicable_point_citation(Lodger, PointCitation) :-
    admissibility_point(_, _, Scope, PointCitation),
    point_scope_status(Scope, Lodger, applies).

prior_request_condition(Profile, Result, Citations) :-
    gdpr_procedural_regulation_input_problems(Profile, Problems),
    prior_request_after_input_check(Problems, Profile, Result, Citations).

prior_request_after_input_check([Problem|Problems], _, input_problems([Problem|Problems]), []).
prior_request_after_input_check([], Profile, Result, Citations) :-
    key_state(Profile, complaint_concerns_right_exercised_by_request, RightByRequest),
    key_state(Profile, request_made_to_controller_before_complaint, RequestMade),
    prior_request_outcome(RightByRequest, RequestMade, Result, Citations).

prior_request_outcome(absent, _, indeterminate([complaint_concerns_right_exercised_by_request]), []).
prior_request_outcome(false, _, prior_request_not_required, [cite(eu_reg_2025_2518_art_4_3)]) :-
    implements(eu_reg_2025_2518_art_4_3).
prior_request_outcome(true, absent, indeterminate([request_made_to_controller_before_complaint]), []).
prior_request_outcome(unsure, absent, indeterminate([request_made_to_controller_before_complaint]), []).
prior_request_outcome(unsure, RequestMade, Referral, []) :-
    implements(eu_reg_2025_2518_art_4_3),
    dif(RequestMade, absent),
    open_textured_referral(complaint_concerns_right_exercised_by_request, Referral).
prior_request_outcome(true, true, prior_request_made, [cite(eu_reg_2025_2518_art_4_3)]) :-
    implements(eu_reg_2025_2518_art_4_3).
prior_request_outcome(true, false, prior_request_not_made, [cite(eu_reg_2025_2518_art_4_3)]) :-
    implements(eu_reg_2025_2518_art_4_3).

early_resolution(Profile, Result, Citations) :-
    gdpr_procedural_regulation_input_problems(Profile, Problems),
    early_resolution_after_input_check(Problems, Profile, Result, Citations).

early_resolution_after_input_check([Problem|Problems], _, input_problems([Problem|Problems]), []).
early_resolution_after_input_check([], Profile, Result, Citations) :-
    key_state(Profile, complaint_concerns_chapter_iii_rights, ChapterThreeRights),
    key_state(Profile, end_of_infringement_established_on_supporting_evidence, InfringementEnded),
    key_state(Profile, complainant_objected_to_early_resolution_in_time, Objected),
    key_state(Profile, early_resolution_procedure_before, Conductor),
    early_resolution_outcome(ChapterThreeRights, InfringementEnded, Objected, Conductor, Result, Citations).

early_resolution_outcome(absent, _, _, _, indeterminate([complaint_concerns_chapter_iii_rights]), []).
early_resolution_outcome(false, _, _, _, early_resolution_not_available, [cite(eu_reg_2025_2518_art_5_1)]) :-
    implements(eu_reg_2025_2518_art_5_1).
early_resolution_outcome(true, absent, _, _, indeterminate([end_of_infringement_established_on_supporting_evidence]), []).
early_resolution_outcome(true, false, _, _, complaint_not_devoid_of_purpose, [cite(eu_reg_2025_2518_art_5_2)]) :-
    implements(eu_reg_2025_2518_art_5_2).
early_resolution_outcome(true, true, absent, _, indeterminate([complainant_objected_to_early_resolution_in_time]), []).
early_resolution_outcome(true, true, true, _, early_resolution_objected, [cite(eu_reg_2025_2518_art_5_2), cite(eu_reg_2025_2518_art_5_2_c)]) :-
    implements(eu_reg_2025_2518_art_5_2_c).
early_resolution_outcome(true, true, false, absent, indeterminate([early_resolution_procedure_before]), []).
early_resolution_outcome(true, true, false, receiving_authority, resolution_established_by_receiving_authority, [cite(eu_reg_2025_2518_art_5_1_a), cite(eu_reg_2025_2518_art_5_2), cite(eu_reg_2025_2518_art_5_2_c), cite(eu_reg_2025_2518_art_5_3), cite(eu_reg_2025_2518_art_5_6)]) :-
    implements(eu_reg_2025_2518_art_5_3).
early_resolution_outcome(true, true, false, lead_authority, draft_decision_establishing_resolution, [cite(eu_reg_2025_2518_art_5_1_b), cite(eu_reg_2025_2518_art_5_2), cite(eu_reg_2025_2518_art_5_2_c), cite(eu_reg_2025_2518_art_5_4), cite(eu_reg_2025_2518_art_5_6)]) :-
    implements(eu_reg_2025_2518_art_5_4).

simple_cooperation_procedure(Profile, Result, Basis, Citations) :-
    gdpr_procedural_regulation_input_problems(Profile, Problems),
    simple_after_input_check(Problems, Profile, Result, Basis, Citations).

simple_after_input_check([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
simple_after_input_check([], Profile, Result, Basis, Citations) :-
    outside_state(Profile, case_handled_under_article_56_2, LocalCase),
    key_state(Profile, lead_authority_considers_no_reasonable_doubt_as_to_scope, NoDoubt),
    key_state(Profile, issues_addressable_without_additional_cooperation, Addressable),
    key_state(Profile, concerned_authority_objected_to_simple_procedure_in_time, Objected),
    memberd_t(false, [NoDoubt, Addressable], ConditionFails),
    simple_outcome(LocalCase, ConditionFails, NoDoubt, Addressable, Objected, Result, Basis, Citations).

not_local_case(absent).
not_local_case(attested_false(_)).

simple_outcome(attested_true(Attested), _, _, _, _, chapter_iii_not_applicable, [outside_fact(case_handled_under_article_56_2, Attested)], [cite(eu_reg_2025_2518_art_6_5)]) :-
    implements(eu_reg_2025_2518_art_6_5).
simple_outcome(attested_false(Attested), true, _, _, _, simple_procedure_not_available, [outside_fact(case_handled_under_article_56_2, Attested)], [cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_6_1_a), cite(eu_reg_2025_2518_art_6_1_b)]) :-
    implements(eu_reg_2025_2518_art_6_1).
simple_outcome(absent, true, _, _, _, Referral, [], []) :-
    implements(eu_reg_2025_2518_art_6_5),
    absent_referral(case_handled_under_article_56_2, Referral).
simple_outcome(LocalCase, false, absent, _, _, indeterminate([lead_authority_considers_no_reasonable_doubt_as_to_scope]), [], []) :-
    not_local_case(LocalCase).
simple_outcome(LocalCase, false, true, absent, _, indeterminate([issues_addressable_without_additional_cooperation]), [], []) :-
    not_local_case(LocalCase).
simple_outcome(LocalCase, false, true, Addressable, absent, indeterminate([concerned_authority_objected_to_simple_procedure_in_time]), [], []) :-
    not_local_case(LocalCase),
    dif(Addressable, absent).
simple_outcome(absent, false, true, Addressable, Objected, Referral, [], []) :-
    implements(eu_reg_2025_2518_art_6_5),
    dif(Addressable, absent),
    dif(Objected, absent),
    absent_referral(case_handled_under_article_56_2, Referral).
simple_outcome(attested_false(_), false, true, unsure, Objected, Referral, [], []) :-
    implements(eu_reg_2025_2518_art_6_1_b),
    dif(Objected, absent),
    open_textured_referral(issues_addressable_without_additional_cooperation, Referral).
simple_outcome(attested_false(Attested), false, true, true, true, simple_procedure_excluded_by_objection, [outside_fact(case_handled_under_article_56_2, Attested)], [cite(eu_reg_2025_2518_art_6_3)]) :-
    implements(eu_reg_2025_2518_art_6_3).
simple_outcome(attested_false(Attested), false, true, true, false, simple_procedure_available, [outside_fact(case_handled_under_article_56_2, Attested)], [cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_6_1_a), cite(eu_reg_2025_2518_art_6_1_b), cite(eu_reg_2025_2518_art_6_3)]) :-
    implements(eu_reg_2025_2518_art_6_1).

draft_decision_time_limit(Profile, Result, Basis, Citations) :-
    gdpr_procedural_regulation_input_problems(Profile, Problems),
    draft_after_input_check(Problems, Profile, Result, Basis, Citations).

draft_after_input_check([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
draft_after_input_check([], Profile, Result, Basis, Citations) :-
    key_state(Profile, simple_cooperation_procedure_applied, SimpleApplied),
    key_state(Profile, draft_decision_time_limit_extended, Extended),
    key_state(Profile, board_request_under_article_11_6_made, BoardRequest),
    key_state(Profile, extension_justified_by_exceptional_complexity, Complexity),
    outside_state(Profile, national_law_requires_domestic_proceedings_after_time_limit, NationalLaw),
    draft_outcome(SimpleApplied, Extended, BoardRequest, Complexity, NationalLaw, Result, Basis, Citations).

suspension_effect(true, [suspended_until_board_binding_decision], [cite(eu_reg_2025_2518_art_12_2)]) :-
    implements(eu_reg_2025_2518_art_12_2).
suspension_effect(false, [], []).

draft_outcome(absent, _, _, _, _, indeterminate([simple_cooperation_procedure_applied]), [], []).
draft_outcome(SimpleApplied, absent, _, _, _, indeterminate([draft_decision_time_limit_extended]), [], []) :-
    dif(SimpleApplied, absent).
draft_outcome(false, Extended, absent, _, _, indeterminate([board_request_under_article_11_6_made]), [], []) :-
    dif(Extended, absent).
draft_outcome(false, true, BoardRequest, absent, _, indeterminate([extension_justified_by_exceptional_complexity]), [], []) :-
    dif(BoardRequest, absent).
draft_outcome(false, true, BoardRequest, unsure, _, Referral, [], []) :-
    implements(eu_reg_2025_2518_art_12_3),
    dif(BoardRequest, absent),
    open_textured_referral(extension_justified_by_exceptional_complexity, Referral).
draft_outcome(false, false, BoardRequest, _, _, draft_decision_limit(Months, no_extension), Basis, [cite(eu_reg_2025_2518_art_12_1)|SuspensionCitations]) :-
    implements(eu_reg_2025_2518_art_12_1),
    suspension_effect(BoardRequest, Basis, SuspensionCitations),
    time_limit_row(submit_draft_decision, limit(Months, months, _, _, _), _).
draft_outcome(false, true, BoardRequest, true, _, draft_decision_limit(Months, extension(up_to, Ceiling, months)), Basis, Citations) :-
    implements(eu_reg_2025_2518_art_12_3),
    suspension_effect(BoardRequest, Basis, SuspensionCitations),
    time_limit_row(submit_draft_decision, limit(Months, months, _, _, extension(up_to, Ceiling, months)), _),
    append([cite(eu_reg_2025_2518_art_12_1)|SuspensionCitations], [cite(eu_reg_2025_2518_art_12_3)], Citations).
draft_outcome(false, true, BoardRequest, false, _, draft_decision_limit(Months, no_extension), Basis, Citations) :-
    implements(eu_reg_2025_2518_art_12_3),
    suspension_effect(BoardRequest, SuspensionBasis, SuspensionCitations),
    append(SuspensionBasis, [extension_not_permitted], Basis),
    time_limit_row(submit_draft_decision, limit(Months, months, _, _, _), _),
    append([cite(eu_reg_2025_2518_art_12_1)|SuspensionCitations], [cite(eu_reg_2025_2518_art_12_3)], Citations).
draft_outcome(true, false, _, _, _, draft_decision_limit(Months, no_extension), [], [cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_12_6)]) :-
    implements(eu_reg_2025_2518_art_12_6),
    time_limit_row(submit_draft_decision_in_simple_procedure, limit(Months, months, _, _, _), _).
draft_outcome(true, true, _, _, absent, Referral, [], []) :-
    implements(eu_reg_2025_2518_art_12_6),
    absent_referral(national_law_requires_domestic_proceedings_after_time_limit, Referral).
draft_outcome(true, true, _, _, attested_true(Attested), draft_decision_limit(Months, extension(up_to, Ceiling, months)), [outside_fact(national_law_requires_domestic_proceedings_after_time_limit, Attested)], [cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_12_6)]) :-
    implements(eu_reg_2025_2518_art_12_6),
    time_limit_row(submit_draft_decision_in_simple_procedure, limit(Months, months, _, _, extension(up_to, Ceiling, months)), _).
draft_outcome(true, true, _, _, attested_false(Attested), draft_decision_limit(Months, no_extension), [extension_not_permitted, outside_fact(national_law_requires_domestic_proceedings_after_time_limit, Attested)], [cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_12_6)]) :-
    implements(eu_reg_2025_2518_art_12_6),
    time_limit_row(submit_draft_decision_in_simple_procedure, limit(Months, months, _, _, _), _).

late_step_effect(Profile, Result, Basis, Citations) :-
    gdpr_procedural_regulation_input_problems(Profile, Problems),
    late_step_after_input_check(Problems, Profile, Result, Basis, Citations).

late_step_after_input_check([Problem|Problems], _, input_problems([Problem|Problems]), [], []).
late_step_after_input_check([], Profile, Result, Basis, Citations) :-
    outside_state(Profile, time_limit_set_by_this_regulation_or_article_65_6, LimitSource),
    late_step_outcome(LimitSource, Result, Basis, Citations).

late_step_outcome(absent, Referral, [], []) :-
    implements(eu_reg_2025_2518_art_14),
    absent_referral(time_limit_set_by_this_regulation_or_article_65_6, Referral).
late_step_outcome(attested_true(Attested), legality_and_validity_not_affected, [outside_fact(time_limit_set_by_this_regulation_or_article_65_6, Attested)], [cite(eu_reg_2025_2518_art_14)]) :-
    implements(eu_reg_2025_2518_art_14).
late_step_outcome(attested_false(Attested), not_governed_by_article_14, [outside_fact(time_limit_set_by_this_regulation_or_article_65_6, Attested)], [cite(eu_reg_2025_2518_art_14)]) :-
    implements(eu_reg_2025_2518_art_14).

procedural_time_limit(Profile, ProceduralStep, Limit, Citations) :-
    gdpr_procedural_regulation_input_problems(Profile, ProfileProblems),
    step_problems(ProceduralStep, StepProblems),
    append(ProfileProblems, StepProblems, Problems),
    time_limit_after_input_check(Problems, ProceduralStep, Limit, Citations).

step_problems(ProceduralStep, [wrong_type(step)]) :-
    var(ProceduralStep).
step_problems(ProceduralStep, Problems) :-
    nonvar(ProceduralStep),
    findall(KnownStep, time_limit_row(KnownStep, _, _), KnownSteps),
    memberd_t(ProceduralStep, KnownSteps, Known),
    step_known_problems(Known, Problems).

step_known_problems(true, []).
step_known_problems(false, [wrong_type(step)]).

time_limit_after_input_check([Problem|Problems], _, input_problems([Problem|Problems]), []).
time_limit_after_input_check([], ProceduralStep, Limit, Citations) :-
    time_limit_for(ProceduralStep, Limit, Citations).

time_limit_for(declare_complaint_inadmissible, Limit, Citations) :-
    implements(eu_reg_2025_2518_art_4_2),
    time_limit_row(declare_complaint_inadmissible, Limit, Citations).
time_limit_for(transmit_complaint_to_presumed_lead_authority, Limit, Citations) :-
    implements(eu_reg_2025_2518_art_4_5),
    time_limit_row(transmit_complaint_to_presumed_lead_authority, Limit, Citations).
time_limit_for(confirm_competence_or_refer_to_board, Limit, Citations) :-
    implements(eu_reg_2025_2518_art_4_6),
    time_limit_row(confirm_competence_or_refer_to_board, Limit, Citations).
time_limit_for(object_to_early_resolution, Limit, Citations) :-
    implements(eu_reg_2025_2518_art_5_2_c),
    time_limit_row(object_to_early_resolution, Limit, Citations).
time_limit_for(establish_early_resolution, Limit, Citations) :-
    implements(eu_reg_2025_2518_art_5_3),
    time_limit_row(establish_early_resolution, Limit, Citations).
time_limit_for(submit_early_resolution_draft_decision, Limit, Citations) :-
    implements(eu_reg_2025_2518_art_5_4),
    time_limit_row(submit_early_resolution_draft_decision, Limit, Citations).
time_limit_for(notify_simple_cooperation_procedure, Limit, Citations) :-
    implements(eu_reg_2025_2518_art_6_2),
    time_limit_row(notify_simple_cooperation_procedure, Limit, Citations).
time_limit_for(object_to_simple_cooperation_procedure, Limit, Citations) :-
    implements(eu_reg_2025_2518_art_6_3),
    time_limit_row(object_to_simple_cooperation_procedure, Limit, Citations).
time_limit_for(provide_summary_of_key_issues, Limit, Citations) :-
    implements(eu_reg_2025_2518_art_10_3),
    time_limit_row(provide_summary_of_key_issues, Limit, Citations).
time_limit_for(comment_on_summary_of_key_issues, Limit, Citations) :-
    implements(eu_reg_2025_2518_art_10_4),
    time_limit_row(comment_on_summary_of_key_issues, Limit, Citations).
time_limit_for(respond_to_comments_on_summary_of_key_issues, Limit, Citations) :-
    implements(eu_reg_2025_2518_art_10_5),
    time_limit_row(respond_to_comments_on_summary_of_key_issues, Limit, Citations).
time_limit_for(submit_draft_decision, Limit, Citations) :-
    implements(eu_reg_2025_2518_art_12_1),
    time_limit_row(submit_draft_decision, Limit, Citations).
time_limit_for(inform_of_draft_decision_extension, Limit, Citations) :-
    implements(eu_reg_2025_2518_art_12_3),
    time_limit_row(inform_of_draft_decision_extension, Limit, Citations).
time_limit_for(object_to_draft_decision_extension, Limit, Citations) :-
    implements(eu_reg_2025_2518_art_12_4),
    time_limit_row(object_to_draft_decision_extension, Limit, Citations).
time_limit_for(submit_draft_decision_in_simple_procedure, Limit, Citations) :-
    implements(eu_reg_2025_2518_art_12_6),
    time_limit_row(submit_draft_decision_in_simple_procedure, Limit, Citations).
time_limit_for(inform_of_simple_procedure_extension, Limit, Citations) :-
    implements(eu_reg_2025_2518_art_12_6),
    time_limit_row(inform_of_simple_procedure_extension, Limit, Citations).

temporal_application(Profile, RegulationPart, EventDate, Result, Citations) :-
    gdpr_procedural_regulation_input_problems(Profile, ProfileProblems),
    part_problems(RegulationPart, PartProblems),
    event_date_problems(EventDate, DateProblems),
    append(ProfileProblems, PartProblems, EarlierProblems),
    append(EarlierProblems, DateProblems, Problems),
    temporal_after_input_check(Problems, RegulationPart, EventDate, Result, Citations).

part_problems(RegulationPart, [wrong_type(part)]) :-
    var(RegulationPart).
part_problems(RegulationPart, Problems) :-
    nonvar(RegulationPart),
    findall(KnownPart, application_part(KnownPart, _, _), KnownParts),
    memberd_t(RegulationPart, KnownParts, Known),
    part_known_problems(Known, Problems).

part_known_problems(true, []).
part_known_problems(false, [wrong_type(part)]).

event_date_problems(EventDate, Problems) :-
    calendar_day_truth(EventDate, Truth),
    event_date_known_problems(Truth, Problems).

event_date_known_problems(true, []).
event_date_known_problems(false, [wrong_type(event_date)]).

calendar_day_truth(Candidate, false) :-
    var(Candidate).
calendar_day_truth(Candidate, false) :-
    nonvar(Candidate),
    Candidate \= date(_, _, _).
calendar_day_truth(Candidate, Truth) :-
    nonvar(Candidate),
    Candidate = date(YearNumber, MonthNumber, DayNumber),
    integers_truth([YearNumber, MonthNumber, DayNumber], IntegersTruth),
    calendar_fields_truth(IntegersTruth, YearNumber, MonthNumber, DayNumber, Truth).

integers_truth([], true).
integers_truth([Candidate|Candidates], Truth) :-
    integer_truth(Candidate, CandidateTruth),
    integers_truth(Candidates, RemainingTruth),
    truth_and(CandidateTruth, RemainingTruth, Truth).

integer_truth(Candidate, Truth) :-
    catch(integer_check(Candidate, Truth), _, not_an_integer(Truth)).

integer_check(Candidate, true) :-
    must_be(integer, Candidate).

not_an_integer(false).

calendar_fields_truth(false, _, _, _, false).
calendar_fields_truth(true, YearNumber, MonthNumber, DayNumber, Truth) :-
    range_truth(YearNumber, 1, 9999, YearTruth),
    range_truth(MonthNumber, 1, 12, MonthTruth),
    truth_and(YearTruth, MonthTruth, YearMonthTruth),
    day_field_truth(YearMonthTruth, YearNumber, MonthNumber, DayNumber, Truth).

range_truth(Number, Lowest, Highest, true) :-
    Number #>= Lowest,
    Number #=< Highest.
range_truth(Number, Lowest, _, false) :-
    Number #< Lowest.
range_truth(Number, _, Highest, false) :-
    Number #> Highest.

day_field_truth(false, _, _, _, false).
day_field_truth(true, YearNumber, MonthNumber, DayNumber, Truth) :-
    month_length(YearNumber, MonthNumber, LastDay),
    range_truth(DayNumber, 1, LastDay, Truth).

month_length(_, MonthNumber, Length) :-
    fixed_month_length(MonthNumber, Length).
month_length(YearNumber, 2, Length) :-
    february_length(YearNumber, Length).

fixed_month_length(1, 31).
fixed_month_length(3, 31).
fixed_month_length(4, 30).
fixed_month_length(5, 31).
fixed_month_length(6, 30).
fixed_month_length(7, 31).
fixed_month_length(8, 31).
fixed_month_length(9, 30).
fixed_month_length(10, 31).
fixed_month_length(11, 30).
fixed_month_length(12, 31).

february_length(YearNumber, 28) :-
    YearNumber mod 4 #\= 0.
february_length(YearNumber, 29) :-
    YearNumber mod 4 #= 0,
    YearNumber mod 100 #\= 0.
february_length(YearNumber, 29) :-
    YearNumber mod 400 #= 0.
february_length(YearNumber, 28) :-
    YearNumber mod 100 #= 0,
    YearNumber mod 400 #\= 0.

date_position(date(YearNumber, MonthNumber, DayNumber), Position) :-
    Position #= YearNumber * 10000 + MonthNumber * 100 + DayNumber.

application_day_position(Position) :-
    application_day(YearNumber, MonthNumber, DayNumber, _),
    date_position(date(YearNumber, MonthNumber, DayNumber), Position).

temporal_after_input_check([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
temporal_after_input_check([], RegulationPart, EventDate, Result, Citations) :-
    date_position(EventDate, EventPosition),
    part_outcome(RegulationPart, EventPosition, Result, Citations).

part_outcome(RegulationPart, EventPosition, part_applies, Citations) :-
    implements(eu_reg_2025_2518_art_37_2),
    application_part(RegulationPart, on_or_after, Citations),
    application_day_position(DayPosition),
    EventPosition #>= DayPosition.
part_outcome(RegulationPart, EventPosition, part_does_not_apply, Citations) :-
    implements(eu_reg_2025_2518_art_37_2),
    application_part(RegulationPart, on_or_after, Citations),
    application_day_position(DayPosition),
    EventPosition #< DayPosition.
part_outcome(RegulationPart, EventPosition, part_applies, Citations) :-
    implements(eu_reg_2025_2518_art_36),
    application_part(RegulationPart, after, Citations),
    application_day_position(DayPosition),
    EventPosition #> DayPosition.
part_outcome(RegulationPart, EventPosition, part_does_not_apply, Citations) :-
    implements(eu_reg_2025_2518_art_36),
    application_part(RegulationPart, after, Citations),
    application_day_position(DayPosition),
    EventPosition #=< DayPosition.

decide_gdpr_procedural_regulation(Profile, gdpr_procedural_regulation_verdict(Status, Citations)) :-
    complaint_admissibility(Profile, Status, Citations).

gdpr_procedural_regulation_status(Profile, Status) :-
    decide_gdpr_procedural_regulation(Profile, gdpr_procedural_regulation_verdict(Status, _)).

gdpr_procedural_regulation_decision_resolvable(Profile) :-
    decide_gdpr_procedural_regulation(Profile, gdpr_procedural_regulation_verdict(Status, _)),
    gdpr_procedural_regulation_status_values(Values),
    memberd_t(Status, Values, true).

gdpr_procedural_regulation_checklist(Profile, Items) :-
    gdpr_procedural_regulation_input_problems(Profile, Problems),
    checklist_after_input_check(Problems, Profile, Items).

checklist_after_input_check([Problem|Problems], _, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_reg_2025_2518_art_4_1))]).
checklist_after_input_check([], Profile, Items) :-
    key_state(Profile, complaint_lodged_by, Lodger),
    findall(ChecklistItem, checklist_point(Profile, Lodger, ChecklistItem), Items).

checklist_point(Profile, Lodger, item(PointId, Status, Citation)) :-
    admissibility_point(PointId, ProfileKey, Scope, Citation),
    point_scope_status(Scope, Lodger, Applicability),
    key_state(Profile, ProfileKey, State),
    point_status(Applicability, ProfileKey, State, Status).

point_status(applies, _, true, met).
point_status(applies, _, false, unmet(not_included)).
point_status(applies, ProfileKey, absent, unknown([ProfileKey])).
point_status(inapplicable, _, _, inapplicable).
point_status(undetermined, _, _, unknown([complaint_lodged_by])).

test(a_complete_complaint_by_a_data_subject_is_admissible) :-
    findall(Result, complaint_admissibility([attribute(complaint_lodged_by, data_subject), attribute(lodging_person_name_and_contact_details_included, true), attribute(controller_or_processor_identification_information_included, true), attribute(alleged_infringement_description_included, true)], Result, _), Results),
    Results == [admissible].
test(a_false_item_decides_before_an_absent_key) :-
    findall(Result - Citations, complaint_admissibility([attribute(controller_or_processor_identification_information_included, false)], Result, Citations), Answers),
    Answers == [inadmissible - [cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_2), cite(eu_reg_2025_2518_art_4_5)]].
test(an_empty_profile_names_the_name_and_contact_details_first) :-
    findall(Result, complaint_admissibility([], Result, _), Results),
    Results == [indeterminate([lodging_person_name_and_contact_details_included])].
test(a_mandated_body_without_the_mandate_key_names_it) :-
    findall(Result, complaint_admissibility([attribute(complaint_lodged_by, article_80_1_body), attribute(lodging_person_name_and_contact_details_included, true), attribute(controller_or_processor_identification_information_included, true), attribute(alleged_infringement_description_included, true), attribute(proof_of_proper_constitution_included, true)], Result, _), Results),
    Results == [indeterminate([proof_of_data_subject_mandate_included])].
test(an_admissible_mandated_body_cites_points_b_and_c) :-
    complaint_admissibility([attribute(complaint_lodged_by, article_80_1_body), attribute(lodging_person_name_and_contact_details_included, true), attribute(controller_or_processor_identification_information_included, true), attribute(alleged_infringement_description_included, true), attribute(proof_of_proper_constitution_included, true), attribute(proof_of_data_subject_mandate_included, true)], admissible, Citations),
    member(cite(eu_reg_2025_2518_art_4_1_b), Citations),
    member(cite(eu_reg_2025_2518_art_4_1_c), Citations).
test(an_unknown_key_is_an_input_problem) :-
    findall(Result - Citations, complaint_admissibility([attribute(colour, blue)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(an_unsure_right_with_a_known_request_goes_to_a_lawyer) :-
    findall(Result, prior_request_condition([attribute(complaint_concerns_right_exercised_by_request, unsure), attribute(request_made_to_controller_before_complaint, false)], Result, _), Results),
    Results == [needs_legal_review(open_textured(complaint_concerns_right_exercised_by_request, cite(eu_reg_2025_2518_art_4_3)), [inputs_relied_on([complaint_concerns_right_exercised_by_request - unsure])])].
test(a_right_exercised_by_request_with_a_prior_request) :-
    prior_request_condition([attribute(complaint_concerns_right_exercised_by_request, true), attribute(request_made_to_controller_before_complaint, true)], prior_request_made, [cite(eu_reg_2025_2518_art_4_3)]).
test(an_unobjected_early_resolution_before_the_lead_authority) :-
    findall(Result, early_resolution([attribute(complaint_concerns_chapter_iii_rights, true), attribute(end_of_infringement_established_on_supporting_evidence, true), attribute(complainant_objected_to_early_resolution_in_time, false), attribute(early_resolution_procedure_before, lead_authority)], Result, _), Results),
    Results == [draft_decision_establishing_resolution].
test(an_absent_local_case_statement_is_referred_when_scope_fails) :-
    findall(Result - Basis, simple_cooperation_procedure([attribute(lead_authority_considers_no_reasonable_doubt_as_to_scope, false)], Result, Basis, _), Answers),
    Answers == [needs_legal_review(cross_reference_unresolved(cite(eu_reg_2025_2518_art_6_5), cite(article_56_2_local_case_statement)), [resolution(cite(article_56_2_local_case_statement), not_attempted), inputs_relied_on([case_handled_under_article_56_2 - absent])]) - []].
test(a_missing_objection_is_named_before_the_absent_outside_fact) :-
    findall(Result, simple_cooperation_procedure([attribute(lead_authority_considers_no_reasonable_doubt_as_to_scope, true), attribute(issues_addressable_without_additional_cooperation, unsure)], Result, _, _), Results),
    Results == [indeterminate([concerned_authority_objected_to_simple_procedure_in_time])].
test(the_simple_procedure_is_available_with_its_basis) :-
    Attested = attested(false, attestation(host, at, reason, none)),
    findall(Result - Basis, simple_cooperation_procedure([attribute(case_handled_under_article_56_2, Attested), attribute(lead_authority_considers_no_reasonable_doubt_as_to_scope, true), attribute(issues_addressable_without_additional_cooperation, true), attribute(concerned_authority_objected_to_simple_procedure_in_time, false)], Result, Basis, _), Answers),
    Answers == [simple_procedure_available - [outside_fact(case_handled_under_article_56_2, Attested)]].
test(an_unjustified_extension_with_a_board_request) :-
    findall(Result - Basis, draft_decision_time_limit([attribute(simple_cooperation_procedure_applied, false), attribute(draft_decision_time_limit_extended, true), attribute(board_request_under_article_11_6_made, true), attribute(extension_justified_by_exceptional_complexity, false)], Result, Basis, _), Answers),
    Answers == [draft_decision_limit(15, no_extension) - [suspended_until_board_binding_decision, extension_not_permitted]].
test(a_simple_procedure_extension_required_by_national_law) :-
    Attested = attested(true, attestation(host, at, reason, none)),
    findall(Result, draft_decision_time_limit([attribute(simple_cooperation_procedure_applied, true), attribute(draft_decision_time_limit_extended, true), attribute(national_law_requires_domestic_proceedings_after_time_limit, Attested)], Result, _, _), Results),
    Results == [draft_decision_limit(12, extension(up_to, 2, months))].
test(a_late_step_without_a_statement_is_referred) :-
    late_step_effect([], needs_legal_review(cross_reference_unresolved(cite(eu_reg_2025_2518_art_14), cite(time_limit_source_statement)), _), [], []).
test(the_draft_decision_row) :-
    findall(Limit - Citations, procedural_time_limit([], submit_draft_decision, Limit, Citations), Answers),
    Answers == [limit(15, months, within, confirmation_of_competence_or_board_binding_decision, extension(up_to, 12, months)) - [cite(eu_reg_2025_2518_art_12_1), cite(eu_reg_2025_2518_art_12_3)]].
test(an_unknown_step_is_an_input_problem) :-
    procedural_time_limit([], file_appeal, input_problems([wrong_type(step)]), []).
test(chapter_two_applies_on_the_day_of_application) :-
    temporal_application([], complaints_and_early_resolution, date(2027, 4, 2), part_applies, _).
test(chapter_three_does_not_apply_on_the_day_itself) :-
    findall(Result, temporal_application([], cooperation_and_files, date(2027, 4, 2), Result, _), Results),
    Results == [part_does_not_apply].
test(an_impossible_day_is_an_input_problem) :-
    temporal_application([], cooperation_and_files, date(2027, 2, 29), input_problems([wrong_type(event_date)]), []).
test(an_unbound_part_is_an_input_problem) :-
    temporal_application([], _, date(2028, 2, 29), input_problems([wrong_type(part)]), []).

test(a_false_item_is_not_admissible, fail) :-
    complaint_admissibility([attribute(controller_or_processor_identification_information_included, false)], admissible, _).
test(chapter_three_does_not_apply_on_the_day_itself_is_not_applies, fail) :-
    temporal_application([], cooperation_and_files, date(2027, 4, 2), part_applies, _).
