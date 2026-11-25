% SPDX-License-Identifier: EUPL-1.2
:- module(m__eu_data_protection_gdpr_codes_and_certification_fixtures, [gdpr_codes_and_certification_subject/1, gdpr_codes_and_certification_profile_for/2, gdpr_codes_and_certification_assess/2]).
:- use_module(library(lists)).
:- use_module(library(iso_ext)).
:- use_module(library(between)).
:- use_module(library(dif)).
:- use_module(m__eu_data_protection_gdpr_codes_and_certification_gdpr_codes_and_certification, [certification_status/5, code_monitoring_status/3, accreditation_status/6]).

base_profile(certification_by_authority, [attribute(certification_issuer, competent_supervisory_authority), attribute(certification_criteria_approved, true), attribute(certification_withdrawn, false), attribute(certification_requirements_not_met, false), attribute(certification_holder_not_subject_to_regulation, false)]).
base_profile(certification_by_body, [attribute(certification_issuer, certification_body), attribute(certification_body_accredited, true), attribute(certification_criteria_approved, true), attribute(supervisory_authority_informed_before_issue_or_renewal, true), attribute(certification_withdrawn, false), attribute(certification_requirements_not_met, false), attribute(certification_holder_not_subject_to_regulation, false)]).
base_profile(certification_for_transfers, [attribute(certification_issuer, competent_supervisory_authority), attribute(certification_criteria_approved, true), attribute(certification_withdrawn, false), attribute(certification_requirements_not_met, false), attribute(certification_holder_not_subject_to_regulation, true), attribute(certification_holder_binding_commitments_made, true)]).
base_profile(code_relied_on_for_transfers, [attribute(processing_by_public_authority_or_body, false), attribute(code_prepared_by_body_representing_controllers_or_processors, true), attribute(code_approved_by_competent_supervisory_authority, true), attribute(code_contains_monitoring_mechanisms, true), attribute(monitoring_body_accredited, true), attribute(code_adhered_to_by_party_not_subject_to_regulation, true), attribute(code_has_general_validity, true), attribute(code_adherent_binding_commitments_made, true)]).
base_profile(monitoring_body_in_good_standing, [attribute(monitoring_body_accreditation_revoked, false), attribute(monitoring_body_independence_and_expertise_demonstrated, true), attribute(monitoring_body_eligibility_monitoring_and_review_procedures_established, true), attribute(monitoring_body_complaint_procedures_and_structures_established, true), attribute(monitoring_body_no_conflict_of_interests_demonstrated, true), attribute(monitoring_body_actions_infringe_regulation, false)]).
base_profile(certification_body_in_good_standing, [attribute(certification_body_accreditation_revoked, false), attribute(certification_body_accrediting_entity, national_accreditation_body), attribute(certification_body_independence_and_expertise_demonstrated, true), attribute(certification_body_undertook_to_respect_approved_criteria, true), attribute(certification_body_issuing_review_and_withdrawal_procedures_established, true), attribute(certification_body_complaint_procedures_and_structures_established, true), attribute(certification_body_no_conflict_of_interests_demonstrated, true), attribute(certification_body_actions_infringe_regulation, false)]).
base_profile(empty, []).
base_profile(duplicate_and_unknown, [attribute(certification_withdrawn, true), attribute(certification_withdrawn, false), attribute(colour, blue)]).
base_profile(attested_value, [attribute(certification_withdrawn, attested(true))]).
base_profile(crisp_key_unsure, [attribute(certification_withdrawn, unsure)]).
base_profile(judgement_key_unsure, [attribute(certification_requirements_not_met, unsure)]).

fixture_row(certification_in_force, certification(date(2024, 1, 15), date(2026, 6, 1)), certification_by_authority, []).
fixture_row(certification_on_last_day_of_period, certification(date(2020, 1, 15), date(2023, 1, 15)), certification_by_authority, []).
fixture_row(certification_day_after_last_day_of_period, certification(date(2020, 1, 15), date(2023, 1, 16)), certification_by_authority, []).
fixture_row(certification_leap_day_start_on_last_day, certification(date(2024, 2, 29), date(2027, 2, 28)), certification_by_authority, []).
fixture_row(certification_leap_day_start_day_after_last_day, certification(date(2024, 2, 29), date(2027, 3, 1)), certification_by_authority, []).
fixture_row(certification_checked_on_issue_day, certification(date(2024, 2, 29), date(2024, 2, 29)), certification_by_authority, []).
fixture_row(certification_checked_before_issue_day, certification(date(2024, 2, 29), date(2024, 2, 28)), certification_by_authority, []).
fixture_row(certification_by_other_issuer, certification(date(2024, 1, 15), date(2026, 6, 1)), certification_by_authority, [set_value(certification_issuer, other_issuer)]).
fixture_row(certification_by_accredited_body_that_informed, certification(date(2024, 1, 15), date(2026, 6, 1)), certification_by_body, []).
fixture_row(certification_by_unaccredited_body, certification(date(2024, 1, 15), date(2026, 6, 1)), certification_by_body, [set_value(certification_body_accredited, false)]).
fixture_row(certification_body_accreditation_absent, certification(date(2024, 1, 15), date(2026, 6, 1)), certification_by_body, [drop_key(certification_body_accredited)]).
fixture_row(certification_body_did_not_inform, certification(date(2024, 1, 15), date(2026, 6, 1)), certification_by_body, [set_value(supervisory_authority_informed_before_issue_or_renewal, false)]).
fixture_row(certification_criteria_not_approved, certification(date(2024, 1, 15), date(2026, 6, 1)), certification_by_authority, [set_value(certification_criteria_approved, false)]).
fixture_row(certification_withdrawn, certification(date(2024, 1, 15), date(2026, 6, 1)), certification_by_authority, [set_value(certification_withdrawn, true)]).
fixture_row(certification_requirements_no_longer_met, certification(date(2024, 1, 15), date(2026, 6, 1)), certification_by_authority, [set_value(certification_requirements_not_met, true)]).
fixture_row(certification_requirements_unsure, certification(date(2024, 1, 15), date(2026, 6, 1)), certification_by_authority, [set_value(certification_requirements_not_met, unsure)]).
fixture_row(certification_requirements_unsure_holder_absent, certification(date(2024, 1, 15), date(2026, 6, 1)), certification_by_authority, [set_value(certification_requirements_not_met, unsure), drop_key(certification_holder_not_subject_to_regulation)]).
fixture_row(certification_issuer_absent, certification(date(2024, 1, 15), date(2026, 6, 1)), certification_by_authority, [drop_key(certification_issuer)]).
fixture_row(certification_for_transfers_conditions_met, certification(date(2024, 1, 15), date(2026, 6, 1)), certification_for_transfers, []).
fixture_row(certification_for_transfers_without_commitments, certification(date(2024, 1, 15), date(2026, 6, 1)), certification_for_transfers, [set_value(certification_holder_binding_commitments_made, false)]).
fixture_row(certification_for_transfers_commitments_absent, certification(date(2024, 1, 15), date(2026, 6, 1)), certification_for_transfers, [drop_key(certification_holder_binding_commitments_made)]).
fixture_row(certification_withdrawn_transfer_conditions_met, certification(date(2024, 1, 15), date(2026, 6, 1)), certification_for_transfers, [set_value(certification_withdrawn, true)]).
fixture_row(input_issue_date_not_a_real_day, certification(date(2023, 2, 29), date(2024, 1, 1)), certification_by_authority, []).
fixture_row(code_monitored_and_relied_on_for_transfers, code, code_relied_on_for_transfers, []).
fixture_row(code_without_general_validity, code, code_relied_on_for_transfers, [set_value(code_has_general_validity, false)]).
fixture_row(code_not_relied_on_for_transfers, code, code_relied_on_for_transfers, [set_value(code_adhered_to_by_party_not_subject_to_regulation, false)]).
fixture_row(code_for_public_authority_processing, code, code_relied_on_for_transfers, [set_value(processing_by_public_authority_or_body, true), set_value(code_adhered_to_by_party_not_subject_to_regulation, false)]).
fixture_row(code_not_prepared_by_representative_body, code, code_relied_on_for_transfers, [set_value(code_prepared_by_body_representing_controllers_or_processors, false)]).
fixture_row(code_not_approved, code, code_relied_on_for_transfers, [set_value(code_approved_by_competent_supervisory_authority, false)]).
fixture_row(code_without_monitoring_mechanisms, code, code_relied_on_for_transfers, [set_value(code_contains_monitoring_mechanisms, false)]).
fixture_row(code_without_accredited_monitoring_body, code, code_relied_on_for_transfers, [set_value(monitoring_body_accredited, false)]).
fixture_row(code_preparer_unsure, code, code_relied_on_for_transfers, [set_value(code_prepared_by_body_representing_controllers_or_processors, unsure)]).
fixture_row(code_preparer_unsure_approval_absent, code, code_relied_on_for_transfers, [set_value(code_prepared_by_body_representing_controllers_or_processors, unsure), drop_key(code_approved_by_competent_supervisory_authority)]).
fixture_row(code_preparer_unsure_general_validity_absent, code, code_relied_on_for_transfers, [set_value(code_prepared_by_body_representing_controllers_or_processors, unsure), drop_key(code_has_general_validity)]).
fixture_row(code_public_authority_adherence_absent, code, empty, [set_value(processing_by_public_authority_or_body, true)]).
fixture_row(monitoring_body_conditions_met, accreditation(monitoring_body, date(2020, 1, 1), date(2030, 1, 1)), monitoring_body_in_good_standing, []).
fixture_row(monitoring_body_checked_on_accreditation_day, accreditation(monitoring_body, date(2020, 1, 1), date(2020, 1, 1)), monitoring_body_in_good_standing, []).
fixture_row(monitoring_body_checked_before_accreditation_day, accreditation(monitoring_body, date(2020, 1, 1), date(2019, 12, 31)), monitoring_body_in_good_standing, []).
fixture_row(monitoring_body_accreditation_revoked, accreditation(monitoring_body, date(2020, 1, 1), date(2030, 1, 1)), monitoring_body_in_good_standing, [set_value(monitoring_body_accreditation_revoked, true)]).
fixture_row(monitoring_body_complaint_procedures_missing, accreditation(monitoring_body, date(2020, 1, 1), date(2030, 1, 1)), monitoring_body_in_good_standing, [set_value(monitoring_body_complaint_procedures_and_structures_established, false)]).
fixture_row(monitoring_body_actions_infringe, accreditation(monitoring_body, date(2020, 1, 1), date(2030, 1, 1)), monitoring_body_in_good_standing, [set_value(monitoring_body_actions_infringe_regulation, true)]).
fixture_row(monitoring_body_independence_unsure, accreditation(monitoring_body, date(2020, 1, 1), date(2030, 1, 1)), monitoring_body_in_good_standing, [set_value(monitoring_body_independence_and_expertise_demonstrated, unsure)]).
fixture_row(monitoring_body_independence_unsure_conflict_refuted, accreditation(monitoring_body, date(2020, 1, 1), date(2030, 1, 1)), monitoring_body_in_good_standing, [set_value(monitoring_body_independence_and_expertise_demonstrated, unsure), set_value(monitoring_body_no_conflict_of_interests_demonstrated, false)]).
fixture_row(monitoring_body_infringement_unsure, accreditation(monitoring_body, date(2020, 1, 1), date(2030, 1, 1)), monitoring_body_in_good_standing, [set_value(monitoring_body_actions_infringe_regulation, unsure)]).
fixture_row(monitoring_body_accredited_on_leap_day, accreditation(monitoring_body, date(2024, 2, 29), date(2024, 12, 31)), monitoring_body_in_good_standing, []).
fixture_row(input_bad_body_and_dates, accreditation(registry_body, date(2023, 2, 29), date(2023, 13, 1)), monitoring_body_in_good_standing, []).
fixture_row(certification_body_conditions_met, accreditation(certification_body, date(2020, 1, 1), date(2024, 6, 1)), certification_body_in_good_standing, []).
fixture_row(certification_body_on_last_day_of_period, accreditation(certification_body, date(2020, 1, 1), date(2025, 1, 1)), certification_body_in_good_standing, []).
fixture_row(certification_body_day_after_last_day_of_period, accreditation(certification_body, date(2020, 1, 1), date(2025, 1, 2)), certification_body_in_good_standing, []).
fixture_row(certification_body_leap_day_start_on_last_day, accreditation(certification_body, date(2020, 2, 29), date(2025, 2, 28)), certification_body_in_good_standing, []).
fixture_row(certification_body_leap_day_start_day_after_last_day, accreditation(certification_body, date(2020, 2, 29), date(2025, 3, 1)), certification_body_in_good_standing, []).
fixture_row(certification_body_checked_before_accreditation_day, accreditation(certification_body, date(2020, 1, 1), date(2019, 12, 31)), certification_body_in_good_standing, []).
fixture_row(certification_body_period_beyond_calendar, accreditation(certification_body, date(9998, 1, 1), date(9999, 12, 31)), certification_body_in_good_standing, []).
fixture_row(certification_body_accredited_by_both_entities, accreditation(certification_body, date(2020, 1, 1), date(2024, 6, 1)), certification_body_in_good_standing, [set_value(certification_body_accrediting_entity, both_named_entities)]).
fixture_row(certification_body_accredited_by_other_entity, accreditation(certification_body, date(2020, 1, 1), date(2024, 6, 1)), certification_body_in_good_standing, [set_value(certification_body_accrediting_entity, other_entity)]).
fixture_row(certification_body_accreditation_revoked, accreditation(certification_body, date(2020, 1, 1), date(2024, 6, 1)), certification_body_in_good_standing, [set_value(certification_body_accreditation_revoked, true)]).
fixture_row(certification_body_criteria_undertaking_missing, accreditation(certification_body, date(2020, 1, 1), date(2024, 6, 1)), certification_body_in_good_standing, [set_value(certification_body_undertook_to_respect_approved_criteria, false)]).
fixture_row(certification_body_actions_infringe, accreditation(certification_body, date(2020, 1, 1), date(2024, 6, 1)), certification_body_in_good_standing, [set_value(certification_body_actions_infringe_regulation, true)]).
fixture_row(certification_body_conflict_unsure, accreditation(certification_body, date(2020, 1, 1), date(2024, 6, 1)), certification_body_in_good_standing, [set_value(certification_body_no_conflict_of_interests_demonstrated, unsure)]).
fixture_row(input_duplicate_and_unknown, code, duplicate_and_unknown, []).
fixture_row(input_attested_value, code, attested_value, []).
fixture_row(input_crisp_key_unsure, code, crisp_key_unsure, []).
fixture_row(input_judgement_key_unsure, code, judgement_key_unsure, []).

gdpr_codes_and_certification_subject(Subject) :-
    fixture_row(Subject, _, _, _).

gdpr_codes_and_certification_profile_for(Subject, Profile) :-
    fixture_row(Subject, _, Base, Changes),
    base_profile(Base, BaseProfile),
    apply_changes(Changes, BaseProfile, Profile).

apply_changes([], Profile, Profile).
apply_changes([Change|Changes], Profile, Result) :-
    apply_change(Change, Profile, Changed),
    apply_changes(Changes, Changed, Result).

apply_change(set_value(Key, Value), Profile, Changed) :-
    without_key(Profile, Key, Rest),
    append(Rest, [attribute(Key, Value)], Changed).
apply_change(drop_key(Key), Profile, Changed) :-
    without_key(Profile, Key, Changed).

without_key([], _, []).
without_key([attribute(ElementKey, _)|Elements], Key, Rest) :-
    ElementKey == Key,
    without_key(Elements, Key, Rest).
without_key([attribute(ElementKey, ElementValue)|Elements], Key, [attribute(ElementKey, ElementValue)|Rest]) :-
    ElementKey \== Key,
    without_key(Elements, Key, Rest).

gdpr_codes_and_certification_assess(Subject, gdpr_codes_and_certification_verdict(Result, Citations)) :-
    fixture_row(Subject, Query, _, _),
    gdpr_codes_and_certification_profile_for(Subject, Profile),
    query_verdict(Query, Profile, Result, Citations).

query_verdict(code, Profile, Result, Citations) :-
    code_monitoring_status(Profile, Result, Citations).
query_verdict(certification(IssuedOn, CheckDate), Profile, Result, Citations) :-
    certification_status(Profile, IssuedOn, CheckDate, Result, Citations).
query_verdict(accreditation(Body, AccreditedOn, CheckDate), Profile, Result, Citations) :-
    accreditation_status(Profile, Body, AccreditedOn, CheckDate, Result, Citations).
