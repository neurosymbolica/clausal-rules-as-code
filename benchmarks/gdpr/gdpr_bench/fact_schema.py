"""Typed extraction fields, independent of supplied oracle values.

Field meanings are documented in data/RULE_INPUTS.md. Null always denotes unknown.
"""
from datetime import date
import math

BOOLEAN_FIELDS = set('''eu_establishment_context offers_to_people_in_eu monitors_behaviour_in_eu
person_is_contract_party requested_precontractual_steps processing_needed_for_purpose
equally_effective_less_intrusive_option safeguards_in_place reasonable_expectation severe_individual_impact
article_six_basis_identified explicit_consent service_depends_on_consent consent_processing_needed_for_service
care_purpose health_law_or_professional_contract professional_secrecy affirmative_action purpose_specific informed
withdrawal_received consent_is_only_basis complex_or_numerous notice_explains_delay
purpose_ended consent_withdrawn_without_other_basis statutory_retention needed_for_legal_claims
provided_by_person automated_processing direct_marketing objection_received decide_purpose_together
decide_essential_means_together change_notice_sent objection_opportunity equivalent_data_protection_obligations
controller_objected public_access readable_sensitive_data individual_access_controls tested_restore
sensitive_data_encrypted keys_separate personal_data_breach data_unintelligible later_measures_avert_high_risk
individual_contact_disproportionate systematic_extensive_evaluation automated_basis significant_decisions
special_or_criminal_data large_scale systematic_public_monitoring other_high_risk_indicators public_authority
court_judicial_capacity monitoring_core_activity regular_systematic_monitoring large_scale_monitoring
special_data_core_activity large_scale_special_or_criminal_data separate_non_eea_recipient recipient_has_data_access
adequacy_covers_recipient effective_protection_assessed derogation_applies meaningful_human_review_before_effect
legal_or_similarly_significant_effect necessary_for_contract authorized_by_law uses_special_categories
special_category_exception_applies'''.split())
ENUMS = {'basis': {'consent', 'contract', 'legitimate_interest', 'legal_obligation'},
         'written_authorization': {'specific', 'general', 'none'},
         'risk_assessment': {'unlikely', 'risk', 'high'}}
DATES = {'received_date', 'extension_notice_date', 'proposed_response_date'}
TEXT = {'interest', 'data_category'}
INTEGERS = {'worldwide_prior_year_turnover_eur', 'proposed_fine_eur'}
FIELDS = BOOLEAN_FIELDS | set(ENUMS) | DATES | TEXT | INTEGERS | {'hours_since_awareness', 'infringed_articles'}


def validate_fact(name, value):
    if name not in FIELDS:
        raise ValueError('Unknown extraction field')
    if value is None:
        return
    valid = False
    if name in BOOLEAN_FIELDS:
        valid = type(value) is bool
    elif name in ENUMS:
        valid = isinstance(value, str) and value in ENUMS[name]
    elif name in DATES:
        valid = isinstance(value, str) and len(value) == 10 and date.fromisoformat(value).isoformat() == value
    elif name in TEXT:
        valid = isinstance(value, str) and bool(value.strip())
    elif name in INTEGERS:
        valid = type(value) is int and value >= 0
    elif name == 'hours_since_awareness':
        valid = type(value) in (int, float) and math.isfinite(value) and value >= 0
    elif name == 'infringed_articles':
        valid = isinstance(value, list) and bool(value) and all(type(v) is int and 1 <= v <= 99 for v in value)
    if not valid:
        raise ValueError(f'Invalid extracted fact type or value: {name}')
