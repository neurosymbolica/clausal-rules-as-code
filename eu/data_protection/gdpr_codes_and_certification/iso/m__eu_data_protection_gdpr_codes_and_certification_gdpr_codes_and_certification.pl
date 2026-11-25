% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_codes_and_certification_gdpr_codes_and_certification, [certification_status/5, code_monitoring_status/3, accreditation_status/6, decide_gdpr_codes_and_certification/2, gdpr_codes_and_certification_status/2, gdpr_codes_and_certification_checklist/2, gdpr_codes_and_certification_decision_resolvable/1, gdpr_codes_and_certification_status_values/1]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(library(clpz)).
:- use_module(library(reif), [memberd_t/3]).
:- use_module(formalize_lib, [profile_get/3, profile_lacks/2]).
:- use_module(deadline_lib, [month_last_day/3]).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_citations, [implements/1]).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_kernel, [gdpr_codes_and_certification_input_problems/2, calendar_date_t/2, calendar_year_t/2, date_triple_order/7, crisp_step/5, judgement_step/5, enumeration_step/5, all_step/4, walk_ladder/3, combine_parts/3, combine_one/2, relied_pairs/3]).

maximum_period(certification, 3, cite(eu_reg_2016_679_art_42_7)).
maximum_period(certification_body_accreditation, 5, cite(eu_reg_2016_679_art_43_4)).

monitoring_body_duty(1, take_appropriate_action_on_infringement, cite(eu_reg_2016_679_art_41_4)).
monitoring_body_duty(2, inform_supervisory_authority_of_actions_and_reasons, cite(eu_reg_2016_679_art_41_4)).

referral_citation(certification_requirements_not_met, cite(eu_reg_2016_679_art_42_7)).
referral_citation(code_prepared_by_body_representing_controllers_or_processors, cite(eu_reg_2016_679_art_40_2)).
referral_citation(monitoring_body_independence_and_expertise_demonstrated, cite(eu_reg_2016_679_art_41_2_a)).
referral_citation(monitoring_body_no_conflict_of_interests_demonstrated, cite(eu_reg_2016_679_art_41_2_d)).
referral_citation(monitoring_body_actions_infringe_regulation, cite(eu_reg_2016_679_art_41_5)).
referral_citation(certification_body_independence_and_expertise_demonstrated, cite(eu_reg_2016_679_art_43_2_a)).
referral_citation(certification_body_no_conflict_of_interests_demonstrated, cite(eu_reg_2016_679_art_43_2_e)).
referral_citation(certification_body_actions_infringe_regulation, cite(eu_reg_2016_679_art_43_7)).

query_read_keys(certification_status, [certification_issuer, certification_body_accredited, certification_criteria_approved, supervisory_authority_informed_before_issue_or_renewal, certification_withdrawn, certification_requirements_not_met, certification_holder_not_subject_to_regulation, certification_holder_binding_commitments_made]).
query_read_keys(code_monitoring_status, [processing_by_public_authority_or_body, code_prepared_by_body_representing_controllers_or_processors, code_approved_by_competent_supervisory_authority, code_contains_monitoring_mechanisms, monitoring_body_accredited, code_adhered_to_by_party_not_subject_to_regulation, code_has_general_validity, code_adherent_binding_commitments_made]).
query_read_keys(monitoring_body, [monitoring_body_accreditation_revoked, monitoring_body_independence_and_expertise_demonstrated, monitoring_body_eligibility_monitoring_and_review_procedures_established, monitoring_body_complaint_procedures_and_structures_established, monitoring_body_no_conflict_of_interests_demonstrated, monitoring_body_actions_infringe_regulation]).
query_read_keys(certification_body, [certification_body_accreditation_revoked, certification_body_accrediting_entity, certification_body_independence_and_expertise_demonstrated, certification_body_undertook_to_respect_approved_criteria, certification_body_issuing_review_and_withdrawal_procedures_established, certification_body_complaint_procedures_and_structures_established, certification_body_no_conflict_of_interests_demonstrated, certification_body_actions_infringe_regulation]).

query_citations(certification_status, [cite(eu_reg_2016_679_art_42_2), cite(eu_reg_2016_679_art_42_4), cite(eu_reg_2016_679_art_42_5), cite(eu_reg_2016_679_art_42_7), cite(eu_reg_2016_679_art_43_1)]).
query_citations(code_monitoring_status, [cite(eu_reg_2016_679_art_40_2), cite(eu_reg_2016_679_art_40_3), cite(eu_reg_2016_679_art_40_4), cite(eu_reg_2016_679_art_40_5), cite(eu_reg_2016_679_art_40_9), cite(eu_reg_2016_679_art_41_1), cite(eu_reg_2016_679_art_41_4), cite(eu_reg_2016_679_art_41_6)]).
query_citations(monitoring_body, [cite(eu_reg_2016_679_art_41_1), cite(eu_reg_2016_679_art_41_2), cite(eu_reg_2016_679_art_41_2_a), cite(eu_reg_2016_679_art_41_2_b), cite(eu_reg_2016_679_art_41_2_c), cite(eu_reg_2016_679_art_41_2_d), cite(eu_reg_2016_679_art_41_5)]).
query_citations(certification_body, [cite(eu_reg_2016_679_art_43_1), cite(eu_reg_2016_679_art_43_1_a), cite(eu_reg_2016_679_art_43_1_b), cite(eu_reg_2016_679_art_43_2), cite(eu_reg_2016_679_art_43_2_a), cite(eu_reg_2016_679_art_43_2_b), cite(eu_reg_2016_679_art_43_2_c), cite(eu_reg_2016_679_art_43_2_d), cite(eu_reg_2016_679_art_43_2_e), cite(eu_reg_2016_679_art_43_4), cite(eu_reg_2016_679_art_43_7)]).

code_checklist_rows([public_authority_processing - cite(eu_reg_2016_679_art_41_6), code_prepared_by_representative_body - cite(eu_reg_2016_679_art_40_2), code_approval - cite(eu_reg_2016_679_art_40_5), monitoring_mechanisms - cite(eu_reg_2016_679_art_40_4), accredited_monitoring_body - cite(eu_reg_2016_679_art_41_1), transfer_adherence - cite(eu_reg_2016_679_art_40_3), transfer_conditions - cite(eu_reg_2016_679_art_40_3)]).

gdpr_codes_and_certification_status_values([code_result, indeterminate, needs_legal_review, input_problems]).

argument_problems(true, _, []).
argument_problems(false, Name, [wrong_type(Name)]).

body_t(Body, false) :-
    var(Body).
body_t(Body, Truth) :-
    nonvar(Body),
    memberd_t(Body, [monitoring_body, certification_body], Truth).

start_order_outcome(<, Atom, decides(Atom)).
start_order_outcome(=, _, passed).
start_order_outcome(>, _, passed).

period_end_outcome(date(StartYear, StartMonth, StartDay), date(CheckYear, CheckMonth, CheckDay), Years, Outcome) :-
    EndYear #= StartYear + Years,
    calendar_year_t(EndYear, InCalendar),
    end_year_outcome(InCalendar, EndYear, StartMonth, StartDay, CheckYear, CheckMonth, CheckDay, Outcome).

end_year_outcome(false, _, _, _, _, _, _, passed).
end_year_outcome(true, EndYear, StartMonth, StartDay, CheckYear, CheckMonth, CheckDay, Outcome) :-
    month_last_day(EndYear, StartMonth, LastDayOfMonth),
    EndDay #= min(StartDay, LastDayOfMonth),
    date_triple_order(CheckYear, CheckMonth, CheckDay, EndYear, StartMonth, EndDay, Order),
    period_order_outcome(Order, Outcome).

period_order_outcome(>, decides(maximum_period_ended)).
period_order_outcome(=, passed).
period_order_outcome(<, passed).

certification_issue_step(date(IssueYear, IssueMonth, IssueDay), date(CheckYear, CheckMonth, CheckDay), Outcome) :-
    implements(eu_reg_2016_679_art_42_7),
    date_triple_order(CheckYear, CheckMonth, CheckDay, IssueYear, IssueMonth, IssueDay, Order),
    start_order_outcome(Order, not_yet_issued, Outcome).

certification_period_step(IssuedOn, CheckDate, Outcome) :-
    implements(eu_reg_2016_679_art_42_7),
    maximum_period(certification, Years, _),
    period_end_outcome(IssuedOn, CheckDate, Years, Outcome).

certification_issuer_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_42_5),
    enumeration_step(Profile, certification_issuer, other_issuer, not_issued_by_competent_issuer, Outcome).

certification_body_accredited_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_42_5),
    issuer_dependent_step(Profile, certification_body_accredited, not_issued_by_competent_issuer, Outcome).

certification_criteria_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_42_5),
    crisp_step(Profile, certification_criteria_approved, false, criteria_not_approved, Outcome).

certification_informing_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_43_1),
    issuer_dependent_step(Profile, supervisory_authority_informed_before_issue_or_renewal, issued_without_informing_supervisory_authority, Outcome).

certification_withdrawn_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_42_7),
    crisp_step(Profile, certification_withdrawn, true, withdrawn, Outcome).

certification_requirements_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_42_7),
    judgement_step(Profile, certification_requirements_not_met, true, withdrawal_required, Outcome).

issuer_dependent_step(Profile, _, _, passed) :-
    profile_lacks(Profile, certification_issuer).
issuer_dependent_step(Profile, Key, DecidingAtom, Outcome) :-
    profile_get(Profile, certification_issuer, certification_body),
    crisp_step(Profile, Key, false, DecidingAtom, Outcome).
issuer_dependent_step(Profile, _, _, passed) :-
    profile_get(Profile, certification_issuer, Issuer),
    dif(Issuer, certification_body).

certification_validity_outcomes(Profile, IssuedOn, CheckDate, [IssueOutcome, PeriodOutcome, IssuerOutcome, AccreditedOutcome, CriteriaOutcome, InformingOutcome, WithdrawnOutcome, RequirementsOutcome]) :-
    certification_issue_step(IssuedOn, CheckDate, IssueOutcome),
    certification_period_step(IssuedOn, CheckDate, PeriodOutcome),
    certification_issuer_step(Profile, IssuerOutcome),
    certification_body_accredited_step(Profile, AccreditedOutcome),
    certification_criteria_step(Profile, CriteriaOutcome),
    certification_informing_step(Profile, InformingOutcome),
    certification_withdrawn_step(Profile, WithdrawnOutcome),
    certification_requirements_step(Profile, RequirementsOutcome).

certification_holder_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_42_2),
    crisp_step(Profile, certification_holder_not_subject_to_regulation, false, not_relied_on_for_transfers, Outcome).

certification_transfer_conditions_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_42_2),
    all_step(Profile, [certification_criteria_approved, certification_holder_binding_commitments_made], transfer_conditions_not_met, Outcome).

certification_transfer_outcomes(Profile, [HolderOutcome, ConditionsOutcome]) :-
    certification_holder_step(Profile, HolderOutcome),
    certification_transfer_conditions_step(Profile, ConditionsOutcome).

certification_status(Profile, IssuedOn, CheckDate, Result, Citations) :-
    gdpr_codes_and_certification_input_problems(Profile, ProfileProblems),
    calendar_date_t(IssuedOn, IssuedOnValid),
    calendar_date_t(CheckDate, CheckDateValid),
    argument_problems(IssuedOnValid, issued_on, IssuedOnProblems),
    argument_problems(CheckDateValid, check_date, CheckDateProblems),
    append([ProfileProblems, IssuedOnProblems, CheckDateProblems], Problems),
    certification_answer(Problems, Profile, IssuedOn, CheckDate, Result, Citations).

certification_answer([Problem|Problems], _, _, _, input_problems([Problem|Problems]), []).
certification_answer([], Profile, IssuedOn, CheckDate, Result, Citations) :-
    certification_validity_outcomes(Profile, IssuedOn, CheckDate, ValidityOutcomes),
    walk_ladder(ValidityOutcomes, within_maximum_period, ValidityAnswer),
    certification_transfer_outcomes(Profile, TransferOutcomes),
    walk_ladder(TransferOutcomes, transfer_conditions_met, TransferAnswer),
    combine_parts(ValidityAnswer, TransferAnswer, Combined),
    project(Combined, Profile, certification_status, Result, Citations).

public_authority_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_41_6),
    crisp_step(Profile, processing_by_public_authority_or_body, true, article_41_not_applicable, Outcome).

code_preparation_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_40_2),
    judgement_step(Profile, code_prepared_by_body_representing_controllers_or_processors, false, not_a_code_under_article_40_2, Outcome).

code_approval_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_40_5),
    crisp_step(Profile, code_approved_by_competent_supervisory_authority, false, code_not_approved, Outcome).

monitoring_mechanisms_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_40_4),
    crisp_step(Profile, code_contains_monitoring_mechanisms, false, monitoring_mechanisms_missing, Outcome).

accredited_monitoring_body_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_41_1),
    crisp_step(Profile, monitoring_body_accredited, false, no_accredited_monitoring_body, Outcome).

monitoring_body_duties(Duties) :-
    implements(eu_reg_2016_679_art_41_4),
    findall(Duty, monitoring_body_duty(_, Duty, _), Duties).

code_monitoring_outcomes(Profile, [PublicOutcome, PreparationOutcome, ApprovalOutcome, MechanismsOutcome, BodyOutcome]) :-
    public_authority_step(Profile, PublicOutcome),
    code_preparation_step(Profile, PreparationOutcome),
    code_approval_step(Profile, ApprovalOutcome),
    monitoring_mechanisms_step(Profile, MechanismsOutcome),
    accredited_monitoring_body_step(Profile, BodyOutcome).

code_adherence_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_40_3),
    crisp_step(Profile, code_adhered_to_by_party_not_subject_to_regulation, false, not_relied_on_for_transfers, Outcome).

code_transfer_conditions_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_40_3),
    all_step(Profile, [code_approved_by_competent_supervisory_authority, code_has_general_validity, code_adherent_binding_commitments_made], transfer_conditions_not_met, Outcome).

code_transfer_outcomes(Profile, [AdherenceOutcome, ConditionsOutcome]) :-
    code_adherence_step(Profile, AdherenceOutcome),
    code_transfer_conditions_step(Profile, ConditionsOutcome).

code_monitoring_status(Profile, Result, Citations) :-
    gdpr_codes_and_certification_input_problems(Profile, Problems),
    code_answer(Problems, Profile, Result, Citations).

code_answer([Problem|Problems], _, input_problems([Problem|Problems]), []).
code_answer([], Profile, Result, Citations) :-
    code_monitoring_outcomes(Profile, MonitoringOutcomes),
    monitoring_body_duties(Duties),
    walk_ladder(MonitoringOutcomes, monitoring_by_accredited_body(Duties), MonitoringAnswer),
    code_transfer_outcomes(Profile, TransferOutcomes),
    walk_ladder(TransferOutcomes, transfer_conditions_met, TransferAnswer),
    combine_parts(MonitoringAnswer, TransferAnswer, Combined),
    project(Combined, Profile, code_monitoring_status, Result, Citations).

monitoring_body_start_step(date(StartYear, StartMonth, StartDay), date(CheckYear, CheckMonth, CheckDay), Outcome) :-
    implements(eu_reg_2016_679_art_41_2),
    date_triple_order(CheckYear, CheckMonth, CheckDay, StartYear, StartMonth, StartDay, Order),
    start_order_outcome(Order, not_yet_accredited, Outcome).

monitoring_body_revoked_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_41_5),
    crisp_step(Profile, monitoring_body_accreditation_revoked, true, accreditation_revoked, Outcome).

monitoring_body_conditions_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_41_2),
    all_step(Profile, [monitoring_body_independence_and_expertise_demonstrated, monitoring_body_eligibility_monitoring_and_review_procedures_established, monitoring_body_complaint_procedures_and_structures_established, monitoring_body_no_conflict_of_interests_demonstrated], accreditation_conditions_not_met, Outcome).

monitoring_body_infringement_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_41_5),
    judgement_step(Profile, monitoring_body_actions_infringe_regulation, true, revocation_required, Outcome).

certification_body_start_step(date(StartYear, StartMonth, StartDay), date(CheckYear, CheckMonth, CheckDay), Outcome) :-
    implements(eu_reg_2016_679_art_43_4),
    date_triple_order(CheckYear, CheckMonth, CheckDay, StartYear, StartMonth, StartDay, Order),
    start_order_outcome(Order, not_yet_accredited, Outcome).

certification_body_period_step(AccreditedOn, CheckDate, Outcome) :-
    implements(eu_reg_2016_679_art_43_4),
    maximum_period(certification_body_accreditation, Years, _),
    period_end_outcome(AccreditedOn, CheckDate, Years, Outcome).

certification_body_revoked_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_43_7),
    crisp_step(Profile, certification_body_accreditation_revoked, true, accreditation_revoked, Outcome).

certification_body_entity_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_43_1),
    enumeration_step(Profile, certification_body_accrediting_entity, other_entity, not_accredited_by_entity_named_in_article_43_1, Outcome).

certification_body_conditions_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_43_2),
    all_step(Profile, [certification_body_independence_and_expertise_demonstrated, certification_body_undertook_to_respect_approved_criteria, certification_body_issuing_review_and_withdrawal_procedures_established, certification_body_complaint_procedures_and_structures_established, certification_body_no_conflict_of_interests_demonstrated], accreditation_conditions_not_met, Outcome).

certification_body_infringement_step(Profile, Outcome) :-
    implements(eu_reg_2016_679_art_43_7),
    judgement_step(Profile, certification_body_actions_infringe_regulation, true, revocation_required, Outcome).

accreditation_outcomes(monitoring_body, Profile, AccreditedOn, CheckDate, [StartOutcome, RevokedOutcome, ConditionsOutcome, InfringementOutcome]) :-
    monitoring_body_start_step(AccreditedOn, CheckDate, StartOutcome),
    monitoring_body_revoked_step(Profile, RevokedOutcome),
    monitoring_body_conditions_step(Profile, ConditionsOutcome),
    monitoring_body_infringement_step(Profile, InfringementOutcome).
accreditation_outcomes(certification_body, Profile, AccreditedOn, CheckDate, [StartOutcome, PeriodOutcome, RevokedOutcome, EntityOutcome, ConditionsOutcome, InfringementOutcome]) :-
    certification_body_start_step(AccreditedOn, CheckDate, StartOutcome),
    certification_body_period_step(AccreditedOn, CheckDate, PeriodOutcome),
    certification_body_revoked_step(Profile, RevokedOutcome),
    certification_body_entity_step(Profile, EntityOutcome),
    certification_body_conditions_step(Profile, ConditionsOutcome),
    certification_body_infringement_step(Profile, InfringementOutcome).

accreditation_status(Profile, Body, AccreditedOn, CheckDate, Result, Citations) :-
    gdpr_codes_and_certification_input_problems(Profile, ProfileProblems),
    body_t(Body, BodyValid),
    calendar_date_t(AccreditedOn, AccreditedOnValid),
    calendar_date_t(CheckDate, CheckDateValid),
    argument_problems(BodyValid, body, BodyProblems),
    argument_problems(AccreditedOnValid, accredited_on, AccreditedOnProblems),
    argument_problems(CheckDateValid, check_date, CheckDateProblems),
    append([ProfileProblems, BodyProblems, AccreditedOnProblems, CheckDateProblems], Problems),
    accreditation_answer(Problems, Profile, Body, AccreditedOn, CheckDate, Result, Citations).

accreditation_answer([Problem|Problems], _, _, _, _, input_problems([Problem|Problems]), []).
accreditation_answer([], Profile, Body, AccreditedOn, CheckDate, Result, Citations) :-
    accreditation_outcomes(Body, Profile, AccreditedOn, CheckDate, Outcomes),
    walk_ladder(Outcomes, accreditation_conditions_met, PartAnswer),
    combine_one(PartAnswer, Combined),
    project(Combined, Profile, Body, Result, Citations).

project(absence(Key), _, _, indeterminate([Key]), []).
project(judgement(Key), Profile, Query, needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)]), []) :-
    referral_citation(Key, Citation),
    query_read_keys(Query, ReadKeys),
    relied_pairs(Profile, ReadKeys, Pairs).
project(answers(Validity, Transfer), _, certification_status, certification_result(Validity, Transfer), Citations) :-
    query_citations(certification_status, Citations).
project(answers(Monitoring, Transfer), _, code_monitoring_status, code_result(Monitoring, Transfer), Citations) :-
    query_citations(code_monitoring_status, Citations).
project(answer(Answer), _, Body, Answer, Citations) :-
    query_citations(Body, Citations).

decide_gdpr_codes_and_certification(Profile, gdpr_codes_and_certification_verdict(Result, Citations)) :-
    code_monitoring_status(Profile, Result, Citations).

gdpr_codes_and_certification_status(Profile, Status) :-
    decide_gdpr_codes_and_certification(Profile, gdpr_codes_and_certification_verdict(Result, _Citations)),
    functor(Result, Status, _).

gdpr_codes_and_certification_checklist(Profile, Items) :-
    gdpr_codes_and_certification_input_problems(Profile, Problems),
    checklist_for(Problems, Profile, Items).

checklist_for([Problem|Problems], _, [item(input_check, unmet(input_problems([Problem|Problems])), cite(eu_reg_2016_679_art_40_2))]).
checklist_for([], Profile, Items) :-
    code_monitoring_outcomes(Profile, MonitoringOutcomes),
    code_transfer_outcomes(Profile, TransferOutcomes),
    append(MonitoringOutcomes, TransferOutcomes, Outcomes),
    code_checklist_rows(Rows),
    maplist(outcome_item, Rows, Outcomes, Items).

outcome_item(Identifier - Citation, Outcome, item(Identifier, Status, Citation)) :-
    outcome_status(Outcome, Status).

outcome_status(passed, met).
outcome_status(decides(Atom), unmet(Atom)).
outcome_status(open_by_absence(Key), unknown([Key])).
outcome_status(open_by_judgement(Key), unknown([Key])).

gdpr_codes_and_certification_decision_resolvable(Profile) :-
    decide_gdpr_codes_and_certification(Profile, _Verdict).

test(certification_within_period_not_for_transfers) :-
    findall(Result, certification_status([attribute(certification_issuer, competent_supervisory_authority), attribute(certification_criteria_approved, true), attribute(certification_withdrawn, false), attribute(certification_requirements_not_met, false), attribute(certification_holder_not_subject_to_regulation, false)], date(2024, 1, 15), date(2026, 6, 1), Result, _), Results),
    Results == [certification_result(within_maximum_period, not_relied_on_for_transfers)].
test(certification_last_day_is_inside_the_period) :-
    certification_status([attribute(certification_issuer, competent_supervisory_authority), attribute(certification_criteria_approved, true), attribute(certification_withdrawn, false), attribute(certification_requirements_not_met, false), attribute(certification_holder_not_subject_to_regulation, false)], date(2020, 1, 15), date(2023, 1, 15), certification_result(within_maximum_period, not_relied_on_for_transfers), _).
test(certification_day_after_last_day_has_ended) :-
    certification_status([], date(2020, 1, 15), date(2023, 1, 16), indeterminate([certification_holder_not_subject_to_regulation]), []).
test(certification_leap_start_ends_on_twenty_eighth) :-
    certification_status([attribute(certification_holder_not_subject_to_regulation, false)], date(2024, 2, 29), date(2027, 3, 1), certification_result(maximum_period_ended, not_relied_on_for_transfers), _).
test(certification_not_yet_issued) :-
    certification_status([attribute(certification_holder_not_subject_to_regulation, false)], date(2024, 2, 29), date(2024, 2, 28), certification_result(not_yet_issued, not_relied_on_for_transfers), _).
test(certification_absent_issuer_is_named) :-
    certification_status([], date(2024, 1, 15), date(2025, 1, 15), indeterminate([certification_issuer]), []).
test(certification_unaccredited_body_is_not_competent) :-
    certification_status([attribute(certification_issuer, certification_body), attribute(certification_body_accredited, false), attribute(certification_holder_not_subject_to_regulation, true), attribute(certification_criteria_approved, true), attribute(certification_holder_binding_commitments_made, true)], date(2024, 1, 15), date(2025, 1, 15), certification_result(not_issued_by_competent_issuer, transfer_conditions_met), _).
test(certification_unsure_requirements_are_referred) :-
    certification_status([attribute(certification_issuer, competent_supervisory_authority), attribute(certification_criteria_approved, true), attribute(certification_withdrawn, false), attribute(certification_requirements_not_met, unsure), attribute(certification_holder_not_subject_to_regulation, false)], date(2024, 1, 15), date(2025, 1, 15), Result, Citations),
    Result == needs_legal_review(open_textured(certification_requirements_not_met, cite(eu_reg_2016_679_art_42_7)), [inputs_relied_on([certification_issuer - competent_supervisory_authority, certification_criteria_approved - true, certification_withdrawn - false, certification_requirements_not_met - unsure, certification_holder_not_subject_to_regulation - false])]),
    Citations == [].
test(certification_bad_dates_are_input_problems) :-
    certification_status([], date(2023, 2, 29), _, input_problems([wrong_type(issued_on), wrong_type(check_date)]), []).
test(code_monitored_by_accredited_body) :-
    findall(Result, code_monitoring_status([attribute(processing_by_public_authority_or_body, false), attribute(code_prepared_by_body_representing_controllers_or_processors, true), attribute(code_approved_by_competent_supervisory_authority, true), attribute(code_contains_monitoring_mechanisms, true), attribute(monitoring_body_accredited, true), attribute(code_adhered_to_by_party_not_subject_to_regulation, true), attribute(code_has_general_validity, false)], Result, _), Results),
    Results == [code_result(monitoring_by_accredited_body([take_appropriate_action_on_infringement, inform_supervisory_authority_of_actions_and_reasons]), transfer_conditions_not_met)].
test(code_public_authority_reads_no_other_key) :-
    code_monitoring_status([attribute(processing_by_public_authority_or_body, true), attribute(code_adhered_to_by_party_not_subject_to_regulation, false)], code_result(article_41_not_applicable, not_relied_on_for_transfers), _).
test(code_absence_is_named_before_judgement) :-
    code_monitoring_status([attribute(processing_by_public_authority_or_body, false), attribute(code_prepared_by_body_representing_controllers_or_processors, unsure)], indeterminate([code_approved_by_competent_supervisory_authority]), []).
test(code_unsure_preparer_is_referred) :-
    code_monitoring_status([attribute(processing_by_public_authority_or_body, false), attribute(code_prepared_by_body_representing_controllers_or_processors, unsure), attribute(code_approved_by_competent_supervisory_authority, false), attribute(code_adhered_to_by_party_not_subject_to_regulation, false)], needs_legal_review(open_textured(code_prepared_by_body_representing_controllers_or_processors, cite(eu_reg_2016_679_art_40_2)), _), []).
test(monitoring_body_conditions_met) :-
    findall(Result, accreditation_status([attribute(monitoring_body_accreditation_revoked, false), attribute(monitoring_body_independence_and_expertise_demonstrated, true), attribute(monitoring_body_eligibility_monitoring_and_review_procedures_established, true), attribute(monitoring_body_complaint_procedures_and_structures_established, true), attribute(monitoring_body_no_conflict_of_interests_demonstrated, true), attribute(monitoring_body_actions_infringe_regulation, false)], monitoring_body, date(2020, 1, 1), date(2030, 1, 1), Result, _), Results),
    Results == [accreditation_conditions_met].
test(monitoring_body_false_condition_beats_absent_ones) :-
    accreditation_status([attribute(monitoring_body_accreditation_revoked, false), attribute(monitoring_body_complaint_procedures_and_structures_established, false)], monitoring_body, date(2020, 1, 1), date(2021, 1, 1), accreditation_conditions_not_met, _).
test(certification_body_other_entity) :-
    accreditation_status([attribute(certification_body_accreditation_revoked, false), attribute(certification_body_accrediting_entity, other_entity)], certification_body, date(2020, 1, 1), date(2021, 1, 1), not_accredited_by_entity_named_in_article_43_1, _).
test(certification_body_five_years_ended) :-
    accreditation_status([], certification_body, date(2020, 1, 1), date(2025, 1, 2), maximum_period_ended, _).
test(certification_body_last_day_not_ended) :-
    accreditation_status([], certification_body, date(2020, 1, 1), date(2025, 1, 1), indeterminate([certification_body_accreditation_revoked]), []).
test(an_unbound_body_is_wrong_type) :-
    accreditation_status([], _, date(2020, 1, 1), date(2021, 1, 1), input_problems([wrong_type(body)]), []).
test(checklist_rows_carry_citations) :-
    gdpr_codes_and_certification_checklist([attribute(processing_by_public_authority_or_body, true)], [item(public_authority_processing, unmet(article_41_not_applicable), cite(eu_reg_2016_679_art_41_6))|_]).
test(status_is_the_result_functor) :-
    gdpr_codes_and_certification_status([], indeterminate).

test(an_unbound_body_is_not_answered, fail) :-
    accreditation_status([], _, date(2020, 1, 1), date(2021, 1, 1), not_yet_accredited, _).
