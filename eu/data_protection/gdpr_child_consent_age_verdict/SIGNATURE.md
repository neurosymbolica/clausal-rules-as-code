# SIGNATURE -- eu/data_protection/gdpr_child_consent_age_verdict

Public surface: decide_child_consent(Profile, gdpr_child_consent_verdict(Status, Ground, Verification, Citations)) and its projections. Profile is an attribute list [attribute(Key, Value), ...] read with profile_get/3.

## Verdict atoms

- STATUS: eligible | ineligible | indeterminate(MissingKeys) | needs_legal_review(Reason, Context) | input_problems(Problems)
- GROUND: art8_not_engaged | child_at_least_16 | parental_consent_given | child_at_least_national_age | parental_consent_missing_below_13 | parental_consent_missing_below_national_age | none
- VERIFICATION: efforts_reasonable | efforts_not_reasonable | not_applicable | not_reached | indeterminate(MissingKeys) | needs_legal_review(Reason, Context)
- Reasons: open_textured(Input, cite(Key)) | cross_reference_unresolved(cite(Key), cite(Target))

## Profile keys (in order)

processing_rests_on_consent (crisp), information_society_service (judgement), offered_directly_to_child (judgement), child_age_years (non-negative integer), parental_consent_given (crisp), member_state (atom), member_state_selection_test (atom), consent_date (date(Year, Month, Day)), member_state_digital_consent_age (attested outside fact), verification_efforts_reasonable (judgement).

## Citation keys

eu_reg_2016_679_art_4_25, eu_reg_2016_679_art_8_1, eu_reg_2016_679_art_8_1_second_subpara, eu_reg_2016_679_art_8_2, member_state_digital_consent_age_law

## Public predicates

- decide_child_consent(Profile, Verdict): the full verdict; serves #13 compliance_check (eligible means Art 8 does not bar the processing). eu_reg_2016_679_art_8_1
- child_consent_ground(Profile, Ground): the GROUND field. eu_reg_2016_679_art_8_1
- decide_child_consent_ground(Profile, Verdict): facade name, same as decide_child_consent/2.
- child_consent_ground_status(Profile, Status): #3 status_determination, the STATUS field.
- child_consent_ground_checklist(Profile, Items): #7 justification, one item(Id, Status, cite(Key)) per requirement.
- child_consent_ground_decision_resolvable(Profile): the profile gets a verdict.
- child_consent_ground_status_values(Values): the GROUND vocabulary table.
- gdpr_child_consent_age_verdict_input_problems(Profile, Problems): the input check, defined in kernel.
- gdpr_child_consent_age_verdict_what_if(Profile, Key, Value, Status): override one key, re-evaluate the status.
- gdpr_child_consent_age_verdict_subject/1, gdpr_child_consent_age_verdict_profile_for/2, gdpr_child_consent_age_verdict_assess/2: fixtures.
- Result constructors (declared, never queried): gdpr_child_consent_verdict/4, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, indeterminate/1, needs_legal_review/2, open_textured/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, provenance/2, attested/2, fetched/2, attestation/4, source/3, national_digital_consent_age/3, url/2, document/2.

## Slice: child_consent_ground

Value facts owned (constants in the slice): default age of digital consent 16, lowest national age 13; the referral rows; the root key order; the citation vocabulary order.

Rules: engagement (three elements); age (at least 16); parent (below 16); national age (13 to 15 without parental consent); verification (Art 8(2)).

Verdict atoms: as above. Nothing is shared with another slice; the kernel holds only the input check.

## Planned reuse

- formalize_lib: profile_get/3, profile_lacks/2
- library(reif): memberd_t/3
- library(clpz)
- citations: implements/1; kernel: gdpr_child_consent_age_verdict_input_problems/2
