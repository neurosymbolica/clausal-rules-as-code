# SIGNATURE — eu/data_protection/gdpr_common_definitions_data_and_processing

## Verdict statuses

STATUS is one of the bare atoms `met` and `not_met`, or one of the compounds `indeterminate(MissingKeys)`, `needs_legal_review(Reason, Context)` and `input_problems(Problems)`. The bare atom `indeterminate` is never written.

GROUND is `none`, or `unmet_elements(Keys)` for consent_elements with not_met. For international_organisation it is `governed_by_public_international_law` or `set_up_by_agreement_between_countries`.

## Profile keys

The profile is an attribute list `[attribute(Key, Value), ...]`, read only with profile_get/3. There are 26 keys, in root_exports order:

- 4(1): information_relates_to_natural_person [J], natural_person_identified [C], natural_person_identifiable [J]
- 4(2): operation_performed_on_the_data [C]
- 4(3): stored_data_marked_to_limit_future_processing [C]
- 4(4): processing_automated [C], evaluates_personal_aspects_of_natural_person [J]
- 4(5): attribution_needs_additional_information [J], additional_information_kept_separately [C], measures_prevent_attribution [J]
- 4(6): structured_set_accessible_by_specific_criteria [J]
- 4(9): data_disclosed_to_receiving_body [C], receiving_body_public_authority_in_particular_inquiry [C]
- 4(10): receiving_body_is_data_subject [C], receiving_body_is_controller_or_processor [C], receiving_body_authorised_under_direct_authority [C]
- 4(11): indication_freely_given, indication_specific, indication_informed, indication_unambiguous, agreement_by_statement_or_clear_affirmative_action (all [J])
- 4(12): breach_of_security [J], breach_led_to_listed_outcome [C]
- 4(25): service_is_information_society_service [outside fact]
- 4(26): organisation_governed_by_public_international_law [outside fact], body_set_up_by_agreement_between_countries [C]

## Citation keys

eu_reg_2016_679_art_4_1, _4_2, _4_3, _4_4, _4_5, _4_6, _4_9, _4_10, _4_11, _4_12, _4_25 and _4_26, plus eu_dir_2015_1535_art_1_1_b and public_international_law_governing_organisation.

## Public predicates

- personal_data(Profile, Answer): Art 4(1).
- processing(Profile, Answer): Art 4(2).
- restriction_of_processing(Profile, Answer): Art 4(3).
- profiling(Profile, Answer): Art 4(4).
- pseudonymisation(Profile, Answer): Art 4(5).
- filing_system(Profile, Answer): Art 4(6).
- receiving_body_is_recipient(Profile, Answer): Art 4(9).
- receiving_body_is_third_party(Profile, Answer): Art 4(10).
- consent_elements(Profile, Answer): Art 4(11).
- personal_data_breach(Profile, Answer): Art 4(12).
- information_society_service(Profile, Answer): Art 4(25).
- international_organisation(Profile, Answer): Art 4(26).
- data_and_processing_outside_facts(Profile, Facts): the outside_fact(Key, Attested|absent) list.
- gdpr_common_definitions_data_and_processing_input_problems(Profile, Problems): in the kernel, Art 4 input contract.
- decide_gdpr_common_definitions_data_and_processing(Profile, Verdict): verdict term of personal data, Art 4(1).
- gdpr_common_definitions_data_and_processing_status(Profile, Status): status projection of that verdict.
- gdpr_common_definitions_data_and_processing_checklist(Profile, Items): one item(Relation, Status, Citations) per relation.
- gdpr_common_definitions_data_and_processing_what_if(Profile, Key, Value, Status): override one key, then re-evaluate.
- Fixtures: gdpr_common_definitions_data_and_processing_subject/1, gdpr_common_definitions_data_and_processing_profile_for/2, gdpr_common_definitions_data_and_processing_assess/2.
- Result constructors: definition_answer/3, unmet_elements/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, indeterminate/1, needs_legal_review/2, open_textured/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, provenance/2, outside_fact/2, attested/2, attestation/4, url/2, document/2.

## Slice gdpr_common_definitions_data_and_processing

- Value facts it owns: the formula tree of each relation, the referral rows and the outside-fact rows. All carry ready-made cite(...) terms and live in the slice file.
- Evaluation: strong Kleene with a descent. It yields outcome(Value, Missing, Outside, Unsure).
- Shared with another slice: nothing. The kernel holds only the input check.

## Planned reuse

formalize_lib (profile_get/3, profile_lacks/2) and library(reif) (memberd_t/3).
