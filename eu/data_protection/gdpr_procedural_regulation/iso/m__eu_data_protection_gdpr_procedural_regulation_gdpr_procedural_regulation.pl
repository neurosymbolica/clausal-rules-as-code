% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_procedural_regulation_gdpr_procedural_regulation, [complaint_admissibility/3, prior_request_condition/3, early_resolution/3, simple_cooperation_procedure/4, draft_decision_time_limit/4, late_step_effect/4, procedural_time_limit/4, temporal_application/5, decide_gdpr_procedural_regulation/2, gdpr_procedural_regulation_status/2, gdpr_procedural_regulation_checklist/2, gdpr_procedural_regulation_decision_resolvable/1, gdpr_procedural_regulation_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(pairs), [pairs_values/2]).
:- use_module(clausal_hof, [include/3]).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_has/2, profile_lacks/2]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_kernel, [gdpr_procedural_regulation_input_problems/2]).
:- use_module(m__eu_data_protection_gdpr_procedural_regulation_citations, [implements/1]).

gdpr_procedural_regulation_status_values([admissible, inadmissible]).

application_day(2027, 4, 2, cite(eu_reg_2025_2518_art_37_2)).

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

outside_fact_row(case_handled_under_article_56_2, cite(eu_reg_2025_2518_art_6_5), cite(article_56_2_local_case_statement)).
outside_fact_row(national_law_requires_domestic_proceedings_after_time_limit, cite(eu_reg_2025_2518_art_12_6), cite(national_domestic_proceedings_statement)).
outside_fact_row(time_limit_set_by_this_regulation_or_article_65_6, cite(eu_reg_2025_2518_art_14), cite(time_limit_source_statement)).

lodger_citations(data_subject, []).
lodger_citations(article_80_1_body, [cite(eu_reg_2025_2518_art_4_1_b), cite(eu_reg_2025_2518_art_4_1_c)]).
lodger_citations(article_80_2_body, [cite(eu_reg_2025_2518_art_4_1_b)]).

key_value(Profile, Key, absent) :-
    profile_lacks(Profile, Key).
key_value(Profile, Key, Value) :-
    profile_has(Profile, Key),
    profile_get(Profile, Key, Value).

outside_fact_kind(absent, absent).
outside_fact_kind(attested(true, _), attested_true).
outside_fact_kind(attested(false, _), attested_false).

first_absent_key([], complete).
first_absent_key([Key - absent|_], missing(Key)).
first_absent_key([_ - Value|Pairs], Outcome) :-
    dif(Value, absent),
    first_absent_key(Pairs, Outcome).

absent_referral(Key, needs_legal_review(cross_reference_unresolved(Citation, Target), [resolution(Target, not_attempted), inputs_relied_on([Key - absent])])) :-
    outside_fact_row(Key, Citation, Target).

complaint_admissibility(Profile, input_problems([Problem|Problems]), []) :-
    gdpr_procedural_regulation_input_problems(Profile, [Problem|Problems]).
complaint_admissibility(Profile, Result, Citations) :-
    gdpr_procedural_regulation_input_problems(Profile, []),
    key_value(Profile, lodging_person_name_and_contact_details_included, Name),
    key_value(Profile, controller_or_processor_identification_information_included, Identification),
    key_value(Profile, alleged_infringement_description_included, Description),
    key_value(Profile, complaint_lodged_by, Lodger),
    key_value(Profile, proof_of_proper_constitution_included, Constitution),
    key_value(Profile, proof_of_data_subject_mandate_included, Mandate),
    lodger_items(Lodger, Constitution, Mandate, LodgerItems),
    Items = [lodging_person_name_and_contact_details_included - Name, controller_or_processor_identification_information_included - Identification, alleged_infringement_description_included - Description, complaint_lodged_by - Lodger|LodgerItems],
    pairs_values(Items, Values),
    memberd_t(false, Values, HasMissingItem),
    admissibility_route(HasMissingItem, Items, Lodger, Result, Citations).

lodger_items(data_subject, _, _, []) :-
    implements(eu_reg_2016_679_art_80).
lodger_items(article_80_1_body, Constitution, Mandate, [proof_of_proper_constitution_included - Constitution, proof_of_data_subject_mandate_included - Mandate]) :-
    implements(eu_reg_2025_2518_art_4_1_c).
lodger_items(article_80_2_body, Constitution, _, [proof_of_proper_constitution_included - Constitution]) :-
    implements(eu_reg_2025_2518_art_4_1_b).
lodger_items(absent, _, _, []).

admissibility_route(true, _, _, inadmissible, [cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_2), cite(eu_reg_2025_2518_art_4_5)]) :-
    implements(eu_reg_2025_2518_art_4_2).
admissibility_route(false, Items, Lodger, Result, Citations) :-
    first_absent_key(Items, Outcome),
    completeness_route(Outcome, Lodger, Result, Citations).

completeness_route(missing(Key), _, indeterminate([Key]), []).
completeness_route(complete, Lodger, admissible, Citations) :-
    implements(eu_reg_2025_2518_art_4_1),
    lodger_citations(Lodger, LodgerCitations),
    append([cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_1_a), cite(eu_reg_2025_2518_art_4_1_d), cite(eu_reg_2025_2518_art_4_1_e), cite(eu_reg_2025_2518_art_4_5)], LodgerCitations, Citations).

prior_request_condition(Profile, input_problems([Problem|Problems]), []) :-
    gdpr_procedural_regulation_input_problems(Profile, [Problem|Problems]).
prior_request_condition(Profile, Result, Citations) :-
    gdpr_procedural_regulation_input_problems(Profile, []),
    key_value(Profile, complaint_concerns_right_exercised_by_request, Right),
    key_value(Profile, request_made_to_controller_before_complaint, Request),
    prior_request_route(Right, Request, Result, Citations).

prior_request_route(absent, _, indeterminate([complaint_concerns_right_exercised_by_request]), []).
prior_request_route(false, _, prior_request_not_required, [cite(eu_reg_2025_2518_art_4_3)]) :-
    implements(eu_reg_2025_2518_art_4_3).
prior_request_route(true, absent, indeterminate([request_made_to_controller_before_complaint]), []).
prior_request_route(unsure, absent, indeterminate([request_made_to_controller_before_complaint]), []).
prior_request_route(unsure, Request, needs_legal_review(open_textured(complaint_concerns_right_exercised_by_request, cite(eu_reg_2025_2518_art_4_3)), [inputs_relied_on([complaint_concerns_right_exercised_by_request - unsure])]), []) :-
    implements(eu_reg_2025_2518_art_4_3),
    dif(Request, absent).
prior_request_route(true, true, prior_request_made, [cite(eu_reg_2025_2518_art_4_3)]) :-
    implements(eu_reg_2025_2518_art_4_3).
prior_request_route(true, false, prior_request_not_made, [cite(eu_reg_2025_2518_art_4_3)]) :-
    implements(eu_reg_2025_2518_art_4_3).

early_resolution(Profile, input_problems([Problem|Problems]), []) :-
    gdpr_procedural_regulation_input_problems(Profile, [Problem|Problems]).
early_resolution(Profile, Result, Citations) :-
    gdpr_procedural_regulation_input_problems(Profile, []),
    key_value(Profile, complaint_concerns_chapter_iii_rights, ChapterRights),
    key_value(Profile, end_of_infringement_established_on_supporting_evidence, InfringementEnded),
    key_value(Profile, complainant_objected_to_early_resolution_in_time, Objection),
    key_value(Profile, early_resolution_procedure_before, Authority),
    early_resolution_route(ChapterRights, InfringementEnded, Objection, Authority, Result, Citations).

early_resolution_route(absent, _, _, _, indeterminate([complaint_concerns_chapter_iii_rights]), []).
early_resolution_route(false, _, _, _, early_resolution_not_available, [cite(eu_reg_2025_2518_art_5_1)]) :-
    implements(eu_reg_2025_2518_art_5_1).
early_resolution_route(true, absent, _, _, indeterminate([end_of_infringement_established_on_supporting_evidence]), []).
early_resolution_route(true, false, _, _, complaint_not_devoid_of_purpose, [cite(eu_reg_2025_2518_art_5_2)]) :-
    implements(eu_reg_2025_2518_art_5_2).
early_resolution_route(true, true, absent, _, indeterminate([complainant_objected_to_early_resolution_in_time]), []).
early_resolution_route(true, true, true, _, early_resolution_objected, [cite(eu_reg_2025_2518_art_5_2), cite(eu_reg_2025_2518_art_5_2_c)]) :-
    implements(eu_reg_2025_2518_art_5_2_c).
early_resolution_route(true, true, false, absent, indeterminate([early_resolution_procedure_before]), []).
early_resolution_route(true, true, false, receiving_authority, resolution_established_by_receiving_authority, [cite(eu_reg_2025_2518_art_5_1_a), cite(eu_reg_2025_2518_art_5_2), cite(eu_reg_2025_2518_art_5_2_c), cite(eu_reg_2025_2518_art_5_3), cite(eu_reg_2025_2518_art_5_6)]) :-
    implements(eu_reg_2025_2518_art_5_3).
early_resolution_route(true, true, false, lead_authority, draft_decision_establishing_resolution, [cite(eu_reg_2025_2518_art_5_1_b), cite(eu_reg_2025_2518_art_5_2), cite(eu_reg_2025_2518_art_5_2_c), cite(eu_reg_2025_2518_art_5_4), cite(eu_reg_2025_2518_art_5_6)]) :-
    implements(eu_reg_2025_2518_art_5_4).

simple_cooperation_procedure(Profile, input_problems([Problem|Problems]), [], []) :-
    gdpr_procedural_regulation_input_problems(Profile, [Problem|Problems]).
simple_cooperation_procedure(Profile, Result, Basis, Citations) :-
    gdpr_procedural_regulation_input_problems(Profile, []),
    key_value(Profile, case_handled_under_article_56_2, LocalCase),
    key_value(Profile, lead_authority_considers_no_reasonable_doubt_as_to_scope, Scope),
    key_value(Profile, issues_addressable_without_additional_cooperation, Issues),
    key_value(Profile, concerned_authority_objected_to_simple_procedure_in_time, Objection),
    outside_fact_kind(LocalCase, LocalCaseKind),
    condition_unmet_t(Scope, Issues, ConditionUnmet),
    simple_route(LocalCaseKind, LocalCase, ConditionUnmet, Scope, Issues, Objection, Result, Basis, Citations).

condition_unmet_t(false, _, true) :-
    implements(eu_reg_2025_2518_art_6_1_a).
condition_unmet_t(Scope, false, true) :-
    implements(eu_reg_2025_2518_art_6_1_b),
    dif(Scope, false).
condition_unmet_t(Scope, Issues, false) :-
    implements(eu_reg_2025_2518_art_6_1),
    dif(Scope, false),
    dif(Issues, false).

simple_route(attested_true, LocalCase, _, _, _, _, chapter_iii_not_applicable, [outside_fact(case_handled_under_article_56_2, LocalCase)], [cite(eu_reg_2025_2518_art_6_5)]) :-
    implements(eu_reg_2025_2518_art_6_5).
simple_route(attested_false, LocalCase, true, _, _, _, simple_procedure_not_available, [outside_fact(case_handled_under_article_56_2, LocalCase)], [cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_6_1_a), cite(eu_reg_2025_2518_art_6_1_b)]) :-
    implements(eu_reg_2025_2518_art_6_1).
simple_route(absent, _, true, _, _, _, Referral, [], []) :-
    implements(eu_reg_2025_2518_art_6_5),
    absent_referral(case_handled_under_article_56_2, Referral).
simple_route(Kind, _, false, absent, _, _, indeterminate([lead_authority_considers_no_reasonable_doubt_as_to_scope]), [], []) :-
    dif(Kind, attested_true).
simple_route(Kind, _, false, true, absent, _, indeterminate([issues_addressable_without_additional_cooperation]), [], []) :-
    dif(Kind, attested_true).
simple_route(Kind, _, false, true, Issues, absent, indeterminate([concerned_authority_objected_to_simple_procedure_in_time]), [], []) :-
    dif(Kind, attested_true),
    dif(Issues, absent).
simple_route(absent, _, false, true, Issues, Objection, Referral, [], []) :-
    implements(eu_reg_2025_2518_art_6_5),
    dif(Issues, absent),
    dif(Objection, absent),
    absent_referral(case_handled_under_article_56_2, Referral).
simple_route(attested_false, _, false, true, unsure, Objection, needs_legal_review(open_textured(issues_addressable_without_additional_cooperation, cite(eu_reg_2025_2518_art_6_1_b)), [inputs_relied_on([issues_addressable_without_additional_cooperation - unsure])]), [], []) :-
    implements(eu_reg_2025_2518_art_6_1_b),
    dif(Objection, absent).
simple_route(attested_false, LocalCase, false, true, true, true, simple_procedure_excluded_by_objection, [outside_fact(case_handled_under_article_56_2, LocalCase)], [cite(eu_reg_2025_2518_art_6_3)]) :-
    implements(eu_reg_2025_2518_art_6_3).
simple_route(attested_false, LocalCase, false, true, true, false, simple_procedure_available, [outside_fact(case_handled_under_article_56_2, LocalCase)], [cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_6_1_a), cite(eu_reg_2025_2518_art_6_1_b), cite(eu_reg_2025_2518_art_6_3)]) :-
    implements(eu_reg_2025_2518_art_6_1).

draft_decision_time_limit(Profile, input_problems([Problem|Problems]), [], []) :-
    gdpr_procedural_regulation_input_problems(Profile, [Problem|Problems]).
draft_decision_time_limit(Profile, Result, Basis, Citations) :-
    gdpr_procedural_regulation_input_problems(Profile, []),
    key_value(Profile, simple_cooperation_procedure_applied, SimpleProcedure),
    key_value(Profile, draft_decision_time_limit_extended, Extended),
    key_value(Profile, board_request_under_article_11_6_made, BoardRequest),
    key_value(Profile, extension_justified_by_exceptional_complexity, Complexity),
    key_value(Profile, national_law_requires_domestic_proceedings_after_time_limit, NationalLaw),
    draft_route(SimpleProcedure, Extended, BoardRequest, Complexity, NationalLaw, Result, Basis, Citations).

suspension(true, [suspended_until_board_binding_decision], [cite(eu_reg_2025_2518_art_12_2)]) :-
    implements(eu_reg_2025_2518_art_12_2).
suspension(false, [], []).

draft_route(absent, _, _, _, _, indeterminate([simple_cooperation_procedure_applied]), [], []).
draft_route(SimpleProcedure, absent, _, _, _, indeterminate([draft_decision_time_limit_extended]), [], []) :-
    dif(SimpleProcedure, absent).
draft_route(false, Extended, absent, _, _, indeterminate([board_request_under_article_11_6_made]), [], []) :-
    dif(Extended, absent).
draft_route(false, true, BoardRequest, absent, _, indeterminate([extension_justified_by_exceptional_complexity]), [], []) :-
    dif(BoardRequest, absent).
draft_route(false, true, BoardRequest, unsure, _, needs_legal_review(open_textured(extension_justified_by_exceptional_complexity, cite(eu_reg_2025_2518_art_12_3)), [inputs_relied_on([extension_justified_by_exceptional_complexity - unsure])]), [], []) :-
    implements(eu_reg_2025_2518_art_12_3),
    dif(BoardRequest, absent).
draft_route(false, false, BoardRequest, _, _, draft_decision_limit(Months, no_extension), Basis, Citations) :-
    implements(eu_reg_2025_2518_art_12_1),
    time_limit_row(submit_draft_decision, limit(Months, months, within, _, _), _),
    suspension(BoardRequest, Basis, SuspensionCitations),
    append([cite(eu_reg_2025_2518_art_12_1)], SuspensionCitations, Citations).
draft_route(false, true, BoardRequest, true, _, draft_decision_limit(Months, Extension), Basis, Citations) :-
    implements(eu_reg_2025_2518_art_12_3),
    time_limit_row(submit_draft_decision, limit(Months, months, within, _, Extension), _),
    suspension(BoardRequest, Basis, SuspensionCitations),
    append([cite(eu_reg_2025_2518_art_12_1)|SuspensionCitations], [cite(eu_reg_2025_2518_art_12_3)], Citations).
draft_route(false, true, BoardRequest, false, _, draft_decision_limit(Months, no_extension), Basis, Citations) :-
    implements(eu_reg_2025_2518_art_12_3),
    time_limit_row(submit_draft_decision, limit(Months, months, within, _, _), _),
    suspension(BoardRequest, SuspensionBasis, SuspensionCitations),
    append(SuspensionBasis, [extension_not_permitted], Basis),
    append([cite(eu_reg_2025_2518_art_12_1)|SuspensionCitations], [cite(eu_reg_2025_2518_art_12_3)], Citations).
draft_route(true, false, _, _, _, draft_decision_limit(Months, no_extension), [], [cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_12_6)]) :-
    implements(eu_reg_2025_2518_art_12_6),
    time_limit_row(submit_draft_decision_in_simple_procedure, limit(Months, months, within, _, _), _).
draft_route(true, true, _, _, absent, Referral, [], []) :-
    implements(eu_reg_2025_2518_art_12_6),
    absent_referral(national_law_requires_domestic_proceedings_after_time_limit, Referral).
draft_route(true, true, _, _, attested(true, Attestation), draft_decision_limit(Months, Extension), [outside_fact(national_law_requires_domestic_proceedings_after_time_limit, attested(true, Attestation))], [cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_12_6)]) :-
    implements(eu_reg_2025_2518_art_12_6),
    time_limit_row(submit_draft_decision_in_simple_procedure, limit(Months, months, within, _, Extension), _).
draft_route(true, true, _, _, attested(false, Attestation), draft_decision_limit(Months, no_extension), [extension_not_permitted, outside_fact(national_law_requires_domestic_proceedings_after_time_limit, attested(false, Attestation))], [cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_12_6)]) :-
    implements(eu_reg_2025_2518_art_12_6),
    time_limit_row(submit_draft_decision_in_simple_procedure, limit(Months, months, within, _, _), _).

late_step_effect(Profile, input_problems([Problem|Problems]), [], []) :-
    gdpr_procedural_regulation_input_problems(Profile, [Problem|Problems]).
late_step_effect(Profile, Result, Basis, Citations) :-
    gdpr_procedural_regulation_input_problems(Profile, []),
    key_value(Profile, time_limit_set_by_this_regulation_or_article_65_6, TimeLimitSource),
    late_step_route(TimeLimitSource, Result, Basis, Citations).

late_step_route(absent, Referral, [], []) :-
    implements(eu_reg_2025_2518_art_14),
    absent_referral(time_limit_set_by_this_regulation_or_article_65_6, Referral).
late_step_route(attested(true, Attestation), legality_and_validity_not_affected, [outside_fact(time_limit_set_by_this_regulation_or_article_65_6, attested(true, Attestation))], [cite(eu_reg_2025_2518_art_14)]) :-
    implements(eu_reg_2025_2518_art_14).
late_step_route(attested(false, Attestation), not_governed_by_article_14, [outside_fact(time_limit_set_by_this_regulation_or_article_65_6, attested(false, Attestation))], [cite(eu_reg_2025_2518_art_14)]) :-
    implements(eu_reg_2025_2518_art_14).

known_argument(true, _, []).
known_argument(false, Name, [wrong_type(Name)]).

step_problems(Step, [wrong_type(step)]) :-
    var(Step).
step_problems(Step, Problems) :-
    nonvar(Step),
    findall(KnownStep, time_limit_row(KnownStep, _, _), KnownSteps),
    memberd_t(Step, KnownSteps, Known),
    known_argument(Known, step, Problems).

part_problems(Part, [wrong_type(part)]) :-
    var(Part).
part_problems(Part, Problems) :-
    nonvar(Part),
    memberd_t(Part, [complaints_and_early_resolution, cooperation_and_files, dispute_resolution_and_urgency], Known),
    known_argument(Known, part, Problems).

event_date_problems(Date, Problems) :-
    calendar_date_t(Date, Valid),
    known_argument(Valid, event_date, Problems).

calendar_date_t(Date, false) :-
    var(Date).
calendar_date_t(Date, Truth) :-
    nonvar(Date),
    functor(Date, Name, Arity),
    memberd_t(Name - Arity, [date - 3], IsDateShape),
    date_shape_t(IsDateShape, Date, Truth).

date_shape_t(false, _, false).
date_shape_t(true, date(Year, Month, Day), Truth) :-
    integer_t(Year, YearInteger),
    integer_t(Month, MonthInteger),
    integer_t(Day, DayInteger),
    truth_and(YearInteger, MonthInteger, YearMonthIntegers),
    truth_and(YearMonthIntegers, DayInteger, Integers),
    integer_date_t(Integers, Year, Month, Day, Truth).

integer_t(Value, Truth) :-
    include(integer, [Value], Kept),
    kept_truth(Kept, Truth).

kept_truth([_], true).
kept_truth([], false).

truth_and(true, Truth, Truth).
truth_and(false, _, false).

integer_date_t(false, _, _, _, false).
integer_date_t(true, Year, Month, Day, Truth) :-
    calendar_day_t(Year, Month, Day, Truth).

calendar_day_t(Year, Month, Day, true) :-
    year_in_range(Year),
    month_in_range(Month),
    month_length(Year, Month, LastDay),
    Day >= 1,
    Day =< LastDay.
calendar_day_t(Year, _, _, false) :-
    year_out_of_range(Year).
calendar_day_t(Year, Month, _, false) :-
    year_in_range(Year),
    month_out_of_range(Month).
calendar_day_t(Year, Month, Day, false) :-
    year_in_range(Year),
    month_in_range(Month),
    month_length(Year, Month, LastDay),
    day_out_of_range(Day, LastDay).

year_in_range(Year) :-
    Year >= 1,
    Year =< 9999.

year_out_of_range(Year) :-
    Year < 1.
year_out_of_range(Year) :-
    Year > 9999.

month_in_range(Month) :-
    Month >= 1,
    Month =< 12.

month_out_of_range(Month) :-
    Month < 1.
month_out_of_range(Month) :-
    Month > 12.

day_out_of_range(Day, _) :-
    Day < 1.
day_out_of_range(Day, LastDay) :-
    Day > LastDay.

month_length(_, 1, 31).
month_length(Year, 2, Days) :-
    leap_year_t(Year, Leap),
    february_length(Leap, Days).
month_length(_, 3, 31).
month_length(_, 4, 30).
month_length(_, 5, 31).
month_length(_, 6, 30).
month_length(_, 7, 31).
month_length(_, 8, 31).
month_length(_, 9, 30).
month_length(_, 10, 31).
month_length(_, 11, 30).
month_length(_, 12, 31).

february_length(true, 29).
february_length(false, 28).

leap_year_t(Year, Leap) :-
    RemainderFour is Year mod 4,
    RemainderHundred is Year mod 100,
    RemainderFourHundred is Year mod 400,
    leap_from_remainders(RemainderFour, RemainderHundred, RemainderFourHundred, Leap).

leap_from_remainders(_, _, 0, true).
leap_from_remainders(0, RemainderHundred, _, true) :-
    RemainderHundred > 0.
leap_from_remainders(RemainderFour, _, _, false) :-
    RemainderFour > 0.
leap_from_remainders(0, 0, RemainderFourHundred, false) :-
    RemainderFourHundred > 0.

procedural_time_limit(Profile, Step, Limit, Citations) :-
    gdpr_procedural_regulation_input_problems(Profile, ProfileProblems),
    step_problems(Step, StepProblems),
    append(ProfileProblems, StepProblems, Problems),
    time_limit_outcome(Problems, Step, Limit, Citations).

time_limit_outcome([Problem|Problems], _, input_problems([Problem|Problems]), []).
time_limit_outcome([], Step, Limit, Citations) :-
    time_limit_row(Step, Limit, Citations).

temporal_application(Profile, Part, EventDate, Result, Citations) :-
    gdpr_procedural_regulation_input_problems(Profile, ProfileProblems),
    part_problems(Part, PartProblems),
    event_date_problems(EventDate, DateProblems),
    append([ProfileProblems, PartProblems, DateProblems], Problems),
    temporal_outcome(Problems, Part, EventDate, Result, Citations).

temporal_outcome([Problem|Problems], _, _, input_problems([Problem|Problems]), []).
temporal_outcome([], Part, EventDate, Result, Citations) :-
    implements(eu_reg_2025_2518_art_37_2),
    part_threshold(Part, Threshold, Citations),
    date_position(EventDate, Position),
    threshold_result(Threshold, Position, Result).

part_threshold(complaints_and_early_resolution, on_or_after, [cite(eu_reg_2025_2518_art_37_2)]).
part_threshold(cooperation_and_files, strictly_after, [cite(eu_reg_2025_2518_art_36), cite(eu_reg_2025_2518_art_37_2)]).
part_threshold(dispute_resolution_and_urgency, strictly_after, [cite(eu_reg_2025_2518_art_36), cite(eu_reg_2025_2518_art_37_2)]).

date_position(date(Year, Month, Day), Position) :-
    application_day(ApplicationYear, ApplicationMonth, ApplicationDayOfMonth, _),
    compare(Order, day_key(Year, Month, Day), day_key(ApplicationYear, ApplicationMonth, ApplicationDayOfMonth)),
    order_position(Order, Position).

order_position(<, before).
order_position(=, on).
order_position(>, after).

threshold_result(on_or_after, before, part_does_not_apply) :-
    implements(eu_reg_2025_2518_art_37_2).
threshold_result(on_or_after, on, part_applies) :-
    implements(eu_reg_2025_2518_art_37_2).
threshold_result(on_or_after, after, part_applies) :-
    implements(eu_reg_2025_2518_art_37_2).
threshold_result(strictly_after, before, part_does_not_apply) :-
    implements(eu_reg_2025_2518_art_36).
threshold_result(strictly_after, on, part_does_not_apply) :-
    implements(eu_reg_2025_2518_art_36).
threshold_result(strictly_after, after, part_applies) :-
    implements(eu_reg_2025_2518_art_36).

decide_gdpr_procedural_regulation(Profile, gdpr_procedural_regulation_verdict(Status, Citations)) :-
    complaint_admissibility(Profile, Status, Citations).

gdpr_procedural_regulation_status(Profile, Status) :-
    decide_gdpr_procedural_regulation(Profile, gdpr_procedural_regulation_verdict(Status, _Citations)).

gdpr_procedural_regulation_checklist(Profile, [item(input_check, input_problems([Problem|Problems]), [])]) :-
    gdpr_procedural_regulation_input_problems(Profile, [Problem|Problems]).
gdpr_procedural_regulation_checklist(Profile, Items) :-
    gdpr_procedural_regulation_input_problems(Profile, []),
    key_value(Profile, complaint_lodged_by, Lodger),
    key_value(Profile, lodging_person_name_and_contact_details_included, Name),
    key_value(Profile, proof_of_proper_constitution_included, Constitution),
    key_value(Profile, proof_of_data_subject_mandate_included, Mandate),
    key_value(Profile, controller_or_processor_identification_information_included, Identification),
    key_value(Profile, alleged_infringement_description_included, Description),
    value_status(lodging_person_name_and_contact_details_included, Name, NameStatus),
    point_applicability(constitution, Lodger, ConstitutionApplicability),
    conditional_status(ConstitutionApplicability, proof_of_proper_constitution_included, Constitution, ConstitutionStatus),
    point_applicability(mandate, Lodger, MandateApplicability),
    conditional_status(MandateApplicability, proof_of_data_subject_mandate_included, Mandate, MandateStatus),
    value_status(controller_or_processor_identification_information_included, Identification, IdentificationStatus),
    value_status(alleged_infringement_description_included, Description, DescriptionStatus),
    Items = [item(lodging_person_name_and_contact_details, NameStatus, cite(eu_reg_2025_2518_art_4_1_a)), item(proof_of_proper_constitution, ConstitutionStatus, cite(eu_reg_2025_2518_art_4_1_b)), item(proof_of_data_subject_mandate, MandateStatus, cite(eu_reg_2025_2518_art_4_1_c)), item(controller_or_processor_identification, IdentificationStatus, cite(eu_reg_2025_2518_art_4_1_d)), item(alleged_infringement_description, DescriptionStatus, cite(eu_reg_2025_2518_art_4_1_e))].

value_status(_, true, met).
value_status(_, false, unmet(not_included)).
value_status(Key, absent, unknown([Key])).

point_applicability(constitution, data_subject, inapplicable) :-
    implements(eu_reg_2025_2518_art_4_1_b).
point_applicability(constitution, article_80_1_body, applicable) :-
    implements(eu_reg_2025_2518_art_4_1_b).
point_applicability(constitution, article_80_2_body, applicable) :-
    implements(eu_reg_2025_2518_art_4_1_b).
point_applicability(constitution, absent, unknown_lodger).
point_applicability(mandate, data_subject, inapplicable) :-
    implements(eu_reg_2025_2518_art_4_1_c).
point_applicability(mandate, article_80_1_body, applicable) :-
    implements(eu_reg_2025_2518_art_4_1_c).
point_applicability(mandate, article_80_2_body, inapplicable) :-
    implements(eu_reg_2025_2518_art_4_1_c).
point_applicability(mandate, absent, unknown_lodger).

conditional_status(inapplicable, _, _, inapplicable).
conditional_status(unknown_lodger, _, _, unknown([complaint_lodged_by])).
conditional_status(applicable, Key, Value, Status) :-
    value_status(Key, Value, Status).

gdpr_procedural_regulation_decision_resolvable(Profile) :-
    decide_gdpr_procedural_regulation(Profile, _Verdict).

data_subject_complaint_profile([attribute(complaint_lodged_by, data_subject), attribute(lodging_person_name_and_contact_details_included, true), attribute(controller_or_processor_identification_information_included, true), attribute(alleged_infringement_description_included, true)]).

attested_true_statement(attested(true, attestation(host, instant, reason, none))).

attested_false_statement(attested(false, attestation(host, instant, reason, none))).

test(admissibility_data_subject_complaint_is_admissible_once) :-
    data_subject_complaint_profile(Profile),
    findall(Result - Citations, complaint_admissibility(Profile, Result, Citations), Answers),
    Answers == [admissible - [cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_1_a), cite(eu_reg_2025_2518_art_4_1_d), cite(eu_reg_2025_2518_art_4_1_e), cite(eu_reg_2025_2518_art_4_5)]].
test(admissibility_several_missing_items_answer_once) :-
    Profile = [attribute(lodging_person_name_and_contact_details_included, false), attribute(controller_or_processor_identification_information_included, false), attribute(complaint_lodged_by, article_80_1_body), attribute(proof_of_proper_constitution_included, false)],
    findall(Result - Citations, complaint_admissibility(Profile, Result, Citations), Answers),
    Answers == [inadmissible - [cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_2), cite(eu_reg_2025_2518_art_4_5)]].
test(admissibility_false_item_decides_before_absent_key) :-
    complaint_admissibility([attribute(alleged_infringement_description_included, false)], inadmissible, _).
test(admissibility_lodger_named_after_three_items) :-
    Profile = [attribute(lodging_person_name_and_contact_details_included, true), attribute(controller_or_processor_identification_information_included, true), attribute(alleged_infringement_description_included, true)],
    complaint_admissibility(Profile, indeterminate([complaint_lodged_by]), []).
test(admissibility_first_missing_item_named) :-
    complaint_admissibility([], indeterminate([lodging_person_name_and_contact_details_included]), []).
test(admissibility_article_80_2_body_needs_no_mandate) :-
    Profile = [attribute(complaint_lodged_by, article_80_2_body), attribute(lodging_person_name_and_contact_details_included, true), attribute(controller_or_processor_identification_information_included, true), attribute(alleged_infringement_description_included, true), attribute(proof_of_proper_constitution_included, true)],
    complaint_admissibility(Profile, admissible, Citations),
    Citations == [cite(eu_reg_2025_2518_art_4_1), cite(eu_reg_2025_2518_art_4_1_a), cite(eu_reg_2025_2518_art_4_1_d), cite(eu_reg_2025_2518_art_4_1_e), cite(eu_reg_2025_2518_art_4_5), cite(eu_reg_2025_2518_art_4_1_b)].
test(admissibility_article_80_1_body_mandate_asked) :-
    Profile = [attribute(complaint_lodged_by, article_80_1_body), attribute(lodging_person_name_and_contact_details_included, true), attribute(controller_or_processor_identification_information_included, true), attribute(alleged_infringement_description_included, true), attribute(proof_of_proper_constitution_included, true)],
    complaint_admissibility(Profile, indeterminate([proof_of_data_subject_mandate_included]), []).
test(admissibility_unknown_key_is_input_problem) :-
    findall(Result - Citations, complaint_admissibility([attribute(colour, red)], Result, Citations), Answers),
    Answers == [input_problems([unknown_key(colour)]) - []].
test(admissibility_non_list_profile) :-
    complaint_admissibility(nonsense, input_problems([wrong_type(profile)]), []).
test(admissibility_facade_verdict) :-
    data_subject_complaint_profile(Profile),
    gdpr_procedural_regulation_status(Profile, admissible).
test(prior_request_unsure_with_request_goes_to_lawyer) :-
    Profile = [attribute(complaint_concerns_right_exercised_by_request, unsure), attribute(request_made_to_controller_before_complaint, false)],
    findall(Result - Citations, prior_request_condition(Profile, Result, Citations), Answers),
    Answers == [needs_legal_review(open_textured(complaint_concerns_right_exercised_by_request, cite(eu_reg_2025_2518_art_4_3)), [inputs_relied_on([complaint_concerns_right_exercised_by_request - unsure])]) - []].
test(prior_request_unsure_asks_for_request_first) :-
    prior_request_condition([attribute(complaint_concerns_right_exercised_by_request, unsure)], indeterminate([request_made_to_controller_before_complaint]), []).
test(prior_request_not_made) :-
    Profile = [attribute(complaint_concerns_right_exercised_by_request, true), attribute(request_made_to_controller_before_complaint, false)],
    prior_request_condition(Profile, prior_request_not_made, [cite(eu_reg_2025_2518_art_4_3)]).
test(prior_request_not_required) :-
    prior_request_condition([attribute(complaint_concerns_right_exercised_by_request, false)], prior_request_not_required, [cite(eu_reg_2025_2518_art_4_3)]).
test(early_resolution_objection_decides) :-
    Profile = [attribute(complaint_concerns_chapter_iii_rights, true), attribute(end_of_infringement_established_on_supporting_evidence, true), attribute(complainant_objected_to_early_resolution_in_time, true)],
    findall(Result - Citations, early_resolution(Profile, Result, Citations), Answers),
    Answers == [early_resolution_objected - [cite(eu_reg_2025_2518_art_5_2), cite(eu_reg_2025_2518_art_5_2_c)]].
test(early_resolution_by_lead_authority) :-
    Profile = [attribute(complaint_concerns_chapter_iii_rights, true), attribute(end_of_infringement_established_on_supporting_evidence, true), attribute(complainant_objected_to_early_resolution_in_time, false), attribute(early_resolution_procedure_before, lead_authority), attribute(simple_cooperation_procedure_applied, true)],
    early_resolution(Profile, draft_decision_establishing_resolution, Citations),
    Citations == [cite(eu_reg_2025_2518_art_5_1_b), cite(eu_reg_2025_2518_art_5_2), cite(eu_reg_2025_2518_art_5_2_c), cite(eu_reg_2025_2518_art_5_4), cite(eu_reg_2025_2518_art_5_6)].
test(early_resolution_not_devoid_of_purpose) :-
    Profile = [attribute(complaint_concerns_chapter_iii_rights, true), attribute(end_of_infringement_established_on_supporting_evidence, false)],
    early_resolution(Profile, complaint_not_devoid_of_purpose, [cite(eu_reg_2025_2518_art_5_2)]).
test(early_resolution_not_available) :-
    early_resolution([attribute(complaint_concerns_chapter_iii_rights, false)], early_resolution_not_available, [cite(eu_reg_2025_2518_art_5_1)]).
test(simple_local_case) :-
    attested_true_statement(Attested),
    findall(Result - Basis - Citations, simple_cooperation_procedure([attribute(case_handled_under_article_56_2, Attested)], Result, Basis, Citations), Answers),
    Answers == [chapter_iii_not_applicable - [outside_fact(case_handled_under_article_56_2, Attested)] - [cite(eu_reg_2025_2518_art_6_5)]].
test(simple_condition_failure_without_statement_refers) :-
    simple_cooperation_procedure([attribute(lead_authority_considers_no_reasonable_doubt_as_to_scope, false)], Result, [], []),
    Result == needs_legal_review(cross_reference_unresolved(cite(eu_reg_2025_2518_art_6_5), cite(article_56_2_local_case_statement)), [resolution(cite(article_56_2_local_case_statement), not_attempted), inputs_relied_on([case_handled_under_article_56_2 - absent])]).
test(simple_missing_scope_named_before_statement) :-
    simple_cooperation_procedure([], indeterminate([lead_authority_considers_no_reasonable_doubt_as_to_scope]), [], []).
test(simple_available) :-
    attested_false_statement(Attested),
    Profile = [attribute(case_handled_under_article_56_2, Attested), attribute(lead_authority_considers_no_reasonable_doubt_as_to_scope, true), attribute(issues_addressable_without_additional_cooperation, true), attribute(concerned_authority_objected_to_simple_procedure_in_time, false)],
    findall(Result - Basis, simple_cooperation_procedure(Profile, Result, Basis, _), Answers),
    Answers == [simple_procedure_available - [outside_fact(case_handled_under_article_56_2, Attested)]].
test(simple_statement_referred_before_unsure_judgement) :-
    Profile = [attribute(lead_authority_considers_no_reasonable_doubt_as_to_scope, true), attribute(issues_addressable_without_additional_cooperation, unsure), attribute(concerned_authority_objected_to_simple_procedure_in_time, false)],
    simple_cooperation_procedure(Profile, needs_legal_review(cross_reference_unresolved(_, _), _), [], []).
test(simple_unsure_judgement_with_statement) :-
    attested_false_statement(Attested),
    Profile = [attribute(case_handled_under_article_56_2, Attested), attribute(lead_authority_considers_no_reasonable_doubt_as_to_scope, true), attribute(issues_addressable_without_additional_cooperation, unsure), attribute(concerned_authority_objected_to_simple_procedure_in_time, true)],
    simple_cooperation_procedure(Profile, needs_legal_review(open_textured(issues_addressable_without_additional_cooperation, cite(eu_reg_2025_2518_art_6_1_b)), [inputs_relied_on([issues_addressable_without_additional_cooperation - unsure])]), [], []).
test(draft_unjustified_extension_with_suspension) :-
    Profile = [attribute(simple_cooperation_procedure_applied, false), attribute(draft_decision_time_limit_extended, true), attribute(board_request_under_article_11_6_made, true), attribute(extension_justified_by_exceptional_complexity, false)],
    findall(Result - Basis - Citations, draft_decision_time_limit(Profile, Result, Basis, Citations), Answers),
    Answers == [draft_decision_limit(15, no_extension) - [suspended_until_board_binding_decision, extension_not_permitted] - [cite(eu_reg_2025_2518_art_12_1), cite(eu_reg_2025_2518_art_12_2), cite(eu_reg_2025_2518_art_12_3)]].
test(draft_justified_extension) :-
    Profile = [attribute(simple_cooperation_procedure_applied, false), attribute(draft_decision_time_limit_extended, true), attribute(board_request_under_article_11_6_made, false), attribute(extension_justified_by_exceptional_complexity, true)],
    draft_decision_time_limit(Profile, draft_decision_limit(15, extension(up_to, 12, months)), [], [cite(eu_reg_2025_2518_art_12_1), cite(eu_reg_2025_2518_art_12_3)]).
test(draft_complexity_not_read_without_extension) :-
    Profile = [attribute(simple_cooperation_procedure_applied, false), attribute(draft_decision_time_limit_extended, false), attribute(board_request_under_article_11_6_made, false), attribute(extension_justified_by_exceptional_complexity, unsure)],
    draft_decision_time_limit(Profile, draft_decision_limit(15, no_extension), [], [cite(eu_reg_2025_2518_art_12_1)]).
test(draft_simple_extension_without_statement_refers) :-
    Profile = [attribute(simple_cooperation_procedure_applied, true), attribute(draft_decision_time_limit_extended, true)],
    draft_decision_time_limit(Profile, needs_legal_review(cross_reference_unresolved(cite(eu_reg_2025_2518_art_12_6), cite(national_domestic_proceedings_statement)), [resolution(cite(national_domestic_proceedings_statement), not_attempted), inputs_relied_on([national_law_requires_domestic_proceedings_after_time_limit - absent])]), [], []).
test(draft_simple_extension_attested) :-
    attested_true_statement(Attested),
    Profile = [attribute(simple_cooperation_procedure_applied, true), attribute(draft_decision_time_limit_extended, true), attribute(national_law_requires_domestic_proceedings_after_time_limit, Attested)],
    findall(Result - Basis - Citations, draft_decision_time_limit(Profile, Result, Basis, Citations), Answers),
    Answers == [draft_decision_limit(12, extension(up_to, 2, months)) - [outside_fact(national_law_requires_domestic_proceedings_after_time_limit, Attested)] - [cite(eu_reg_2025_2518_art_6_1), cite(eu_reg_2025_2518_art_12_6)]].
test(draft_first_missing_key) :-
    draft_decision_time_limit([], indeterminate([simple_cooperation_procedure_applied]), [], []).
test(late_step_without_statement_refers) :-
    late_step_effect([], needs_legal_review(cross_reference_unresolved(cite(eu_reg_2025_2518_art_14), cite(time_limit_source_statement)), [resolution(cite(time_limit_source_statement), not_attempted), inputs_relied_on([time_limit_set_by_this_regulation_or_article_65_6 - absent])]), [], []).
test(late_step_not_governed) :-
    attested_false_statement(Attested),
    late_step_effect([attribute(time_limit_set_by_this_regulation_or_article_65_6, Attested)], not_governed_by_article_14, [outside_fact(time_limit_set_by_this_regulation_or_article_65_6, Attested)], [cite(eu_reg_2025_2518_art_14)]).
test(late_step_bare_value_is_wrong_type) :-
    late_step_effect([attribute(time_limit_set_by_this_regulation_or_article_65_6, true)], input_problems([wrong_type(time_limit_set_by_this_regulation_or_article_65_6)]), [], []).
test(time_limit_submit_draft_decision) :-
    findall(Limit - Citations, procedural_time_limit([], submit_draft_decision, Limit, Citations), Answers),
    Answers == [limit(15, months, within, confirmation_of_competence_or_board_binding_decision, extension(up_to, 12, months)) - [cite(eu_reg_2025_2518_art_12_1), cite(eu_reg_2025_2518_art_12_3)]].
test(time_limit_unknown_step) :-
    procedural_time_limit([], no_such_step, input_problems([wrong_type(step)]), []).
test(time_limit_sixteen_rows) :-
    findall(Step, time_limit_row(Step, _, _), Steps),
    sort(Steps, DistinctSteps),
    length(DistinctSteps, 16).
test(temporal_complaint_on_application_day_applies) :-
    findall(Result - Citations, temporal_application([], complaints_and_early_resolution, date(2027, 4, 2), Result, Citations), Answers),
    Answers == [part_applies - [cite(eu_reg_2025_2518_art_37_2)]].
test(temporal_cooperation_on_application_day_does_not_apply) :-
    temporal_application([], cooperation_and_files, date(2027, 4, 2), part_does_not_apply, [cite(eu_reg_2025_2518_art_36), cite(eu_reg_2025_2518_art_37_2)]).
test(temporal_dispute_day_after_applies) :-
    temporal_application([], dispute_resolution_and_urgency, date(2027, 4, 3), part_applies, _).
test(temporal_complaint_before_day_does_not_apply) :-
    temporal_application([], complaints_and_early_resolution, date(2027, 4, 1), part_does_not_apply, _).
test(temporal_leap_day_is_valid) :-
    temporal_application([], complaints_and_early_resolution, date(2028, 2, 29), part_applies, _).
test(temporal_bad_part_and_date) :-
    temporal_application([], chapter_nine, day(2027, 4, 2), input_problems([wrong_type(part), wrong_type(event_date)]), []).

test(admissibility_data_subject_complaint_is_not_inadmissible, fail) :-
    data_subject_complaint_profile(Profile),
    complaint_admissibility(Profile, inadmissible, _).
test(prior_request_not_made_is_not_made, fail) :-
    Profile = [attribute(complaint_concerns_right_exercised_by_request, true), attribute(request_made_to_controller_before_complaint, false)],
    prior_request_condition(Profile, prior_request_made, _).
test(simple_available_is_not_excluded, fail) :-
    attested_false_statement(Attested),
    Profile = [attribute(case_handled_under_article_56_2, Attested), attribute(lead_authority_considers_no_reasonable_doubt_as_to_scope, true), attribute(issues_addressable_without_additional_cooperation, true), attribute(concerned_authority_objected_to_simple_procedure_in_time, false)],
    simple_cooperation_procedure(Profile, simple_procedure_excluded_by_objection, _, _).
test(temporal_cooperation_on_application_day_is_not_applied, fail) :-
    temporal_application([], cooperation_and_files, date(2027, 4, 2), part_applies, _).
