# SIGNATURE - eu/data_protection/gdpr_territorial_material_scope

## Verdict statuses

- APPLIES: applies | does_not_apply | indeterminate(MissingKeys) | needs_legal_review(Reason, Context) | input_problems(Problems).
- GROUND: art3_1 | art3_2_a | art3_2_b | art3_3 | art2_1_not_met | art2_2_a | art2_2_b | art2_2_c | art2_2_d | art2_3 | art3_not_met | none.
- REPRESENTATIVE: required | exempt_art27_2_a | exempt_art27_2_b | not_applicable | not_reached | indeterminate(MissingKeys) | needs_legal_review(Reason, Context).
- Slice result terms: gdpr_applies_verdict(Status, Citations), gdpr_scope_ground_verdict(Status, Citations), representative_requirement_verdict(Status, Citations). Package verdict: gdpr_scope_verdict(Applies, Ground, Representative, Citations).

## Profile keys (attribute list of attribute(Key, Value), 21 keys, in order)

personal_data_processed, processing_wholly_or_partly_automated, personal_data_in_filing_system, activity_outside_union_law, member_state_common_foreign_security_activity, processing_by_natural_person, purely_personal_or_household_activity (judgement), processing_by_competent_authority, criminal_law_enforcement_purpose, processing_by_union_institution, party_role (controller|processor), established_in_union, processing_in_context_of_establishment_activities (judgement), data_subjects_in_union, offering_goods_or_services_to_data_subjects_in_union (judgement), monitoring_behaviour_of_data_subjects_in_union (judgement), member_state_law_applies_by_public_international_law (outside fact attested(Value, attestation(By, At, Reason, Evidence))), public_authority_or_body, occasional_processing (judgement), special_or_criminal_data_on_large_scale (judgement), unlikely_to_result_in_risk (judgement). Crisp keys are true|false; judgements true|false|unsure. No dates, no numeric keys.

## Citation keys

eu_reg_2016_679_art_2_1, _art_2_2_a, _art_2_2_b, _art_2_2_c, _art_2_2_d, _art_2_3, _art_3_1, _art_3_2_a, _art_3_2_b, _art_3_3, _art_27_1, _art_27_2_a, _art_27_2_b, public_international_law_member_state_law_applies; recorded for reasoning only: eu_reg_2016_679_art_4_1, _4_2, _4_6, _4_7, _4_8, _4_17.

## Public predicates

- decide_gdpr_scope(Profile, Verdict): the full verdict gdpr_scope_verdict/4; Art 2, Art 3, Art 27.
- gdpr_applies(Profile, Applies): the APPLIES field; Art 2(1)-(3), Art 3(1)-(3).
- gdpr_scope_ground(Profile, Ground): the GROUND field.
- representative_requirement(Profile, Representative): Art 27(1), 27(2).
- scope_outside_facts(Profile, Facts): the attested Art 3(3) fact as given, or absent.
- gdpr_territorial_material_scope_input_problems(Profile, Problems): input check (unknown_key, wrong_type, duplicate_key).
- decide_gdpr_applies/2, gdpr_applies_status/2, gdpr_applies_checklist/2: APPLIES slice with checklist and cite provenance.
- decide_gdpr_scope_ground/2, gdpr_scope_ground_status/2, gdpr_scope_ground_checklist/2.
- decide_representative_requirement/2, representative_requirement_status/2, representative_requirement_checklist/2.
- gdpr_territorial_material_scope_what_if(Profile, Key, Value, Status): override one key, re-evaluate APPLIES.
- fixtures: gdpr_territorial_material_scope_subject/1, _profile_for/2, _assess/2.
- Result constructors: gdpr_scope_verdict/4, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, indeterminate/1, needs_legal_review/2, open_textured/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, provenance/2, outside_fact/2, attested/2, attestation/4, url/2, document/2.

## Slices

### gdpr_applies.clausal
Owns: the table of citations per ground (ground_citations), stage citation lists, the open-limb judgement table (limb_judgement). Rules: stage one Art 2(1), stage two Art 2(2)/(3), stage three Art 3. Verdict atoms: applies, does_not_apply, plus compounds. Also holds scope_outside_facts/2. Shares with others only via kernel.

### gdpr_scope_ground.clausal
Owns: the ground to citation table. Rules: first unmet stage names the ground (art2_1_not_met, first met exclusion, art3_not_met); all stages met names the first met Art 3 limb; otherwise none.

### representative_requirement.clausal
Owns: the Art 27(2) exemption logic and the citation table. Rules: not_applicable unless Art 3(2) is met; exemption (a) conjunction of three judgements; exemption (b) crisp; required otherwise; indeterminate or needs_legal_review when open.

### kernel.clausal (shared)
Input check, the five-state Kleene algebra, element readings, limb and stage statuses, first-met ground, absent-key collection, present pairs, ordering helpers, vocabulary orders.

## Planned reuse

formalize_lib: profile_get/3, profile_has/2, profile_lacks/2. library(reif): memberd_t/3. Builtins: maplist, findall, append, dif.
