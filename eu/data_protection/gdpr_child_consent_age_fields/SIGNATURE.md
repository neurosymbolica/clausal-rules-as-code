# SIGNATURE: eu/data_protection/gdpr_child_consent_age_fields

Shape family: deontic. Predicate prefix: gdpr_child_consent_age_fields_.

## Verdict atoms

- child_consent_status/2: eligible | ineligible. Compound statuses: indeterminate(MISSING_KEYS), needs_legal_review(REASON, CONTEXT), input_problems(PROBLEMS).
- parental_verification/2: efforts_reasonable | efforts_not_reasonable | not_applicable | not_reached. Compound statuses: indeterminate(MISSING_KEYS), needs_legal_review(REASON, CONTEXT).
- Grounds (internal): art8_not_engaged, child_at_least_16, parental_consent_given, parental_consent_missing_below_13, child_at_least_national_age, parental_consent_missing_below_national_age, none.

## Profile keys

The profile is an attribute list [attribute(Key, Value), ...] read with profile_get/3. The ten keys, in order:

1. processing_rests_on_consent (true or false)
2. information_society_service (true, false or unsure)
3. offered_directly_to_child (true, false or unsure)
4. child_age_years (non-negative integer)
5. parental_consent_given (true or false)
6. member_state (one of 27 atoms)
7. member_state_selection_test (controller_establishment or child_residence)
8. consent_date (date(Year, Month, Day))
9. member_state_digital_consent_age (attested(national_digital_consent_age(MEMBER_STATE, AGE, PROVISION), attestation(BY, AT, REASON, EVIDENCE)), AGE an integer 13 to 16)
10. verification_efforts_reasonable (true, false or unsure)

## Citation keys

eu_reg_2016_679_art_4_25, eu_reg_2016_679_art_8_1, eu_reg_2016_679_art_8_1_second_subpara, eu_reg_2016_679_art_8_2, member_state_digital_consent_age_law, eu_reg_2016_679_art_8_3 (recorded, never returned).

## Public predicates

- child_consent_status(Profile, Status): STATUS field, Art 8(1).
- child_consent_outside_facts(Profile, OutsideFacts): the national-age fact as attested, or absent. Art 8(1) second subparagraph.
- parental_verification(Profile, Verification): VERIFICATION field, Art 8(2).
- gdpr_child_consent_age_fields_input_problems(Profile, Problems): typed input check (kernel).
- decide_child_consent_status(Profile, Verdict): verdict with cite list. Art 8(1).
- child_consent_status_status(Profile, Status): projection of the verdict.
- child_consent_status_checklist(Profile, Items): item/3 rows with cite(...). Art 8(1).
- decide_parental_verification(Profile, Verdict): Art 8(2).
- parental_verification_status(Profile, Status): projection of the verdict.
- parental_verification_checklist(Profile, Items): Art 8(2).
- gdpr_child_consent_age_fields_what_if(Profile, Key, Value, NewStatus): override one key, re-evaluate STATUS.
- gdpr_child_consent_age_fields_compliance_check(Profile, Action, Verdict): is processing on consent allowed. Query type #13.
- gdpr_child_consent_age_fields_justification(Profile, Checklist): cite provenance per item. Query type #7.
- Fixtures: subject/1, profile_for/2, assess/2.
- Result constructors (data terms): indeterminate/1, needs_legal_review/2, open_textured/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, provenance/2, outside_fact/2, attested/2, fetched/2, attestation/4, source/3, national_digital_consent_age/3, url/2, document/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1.

## Slice: child_consent_status

- Value facts: digital_consent_default_age_years 16 and digital_consent_floor_age_years 13 (integer constants, cite art_8_1 and art_8_1_second_subpara).
- Rules: engagement, age at least 16, parental consent, national age.
- Verdict atoms: eligible, ineligible, plus the compound statuses.
- Shared with the other slice: only the input check, held in the kernel.

## Slice: parental_verification

- Value fact: parental_consent_age_ceiling_years 16.
- Rules: reliance on parental consent, then the efforts judgement (Art 8(2)).
- Verdict atoms: efforts_reasonable, efforts_not_reasonable, not_applicable, not_reached, plus the compound statuses.
- Reads the STATUS through the public child_consent_status/2.

## Planned reuse

formalize_lib (profile_get/3, profile_lacks/2), library(reif) (memberd_t/3), library(clpz). No `_common` backbone is used.
