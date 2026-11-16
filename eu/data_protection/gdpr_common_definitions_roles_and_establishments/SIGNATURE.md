# SIGNATURE - eu/data_protection/gdpr_common_definitions_roles_and_establishments

## Verdict STATUS atoms

met, not_met, indeterminate(MISSING_KEYS), needs_legal_review(REASON, CONTEXT), input_problems(PROBLEMS). The bare atom indeterminate is never written. The answer term is definition_answer(STATUS, GROUND, CITATIONS).

## Profile keys (26, an attribute list read with profile_get/3)

Judgements (true, false or unsure): data_are_personal_data, party_determines_purposes_and_means, party_processes_on_behalf_of_controller, data_relate_to_genetic_characteristics_giving_unique_information, data_result_from_technical_processing_allowing_unique_identification, data_relate_to_health_and_reveal_health_status, other_establishment_can_have_decisions_implemented, entity_engaged_in_economic_activity, controlling_undertaking_and_controlled_undertakings, data_subjects_in_authority_member_state_substantially_affected, processing_in_context_of_establishments_in_more_than_one_member_state, processing_in_context_of_single_union_establishment, substantially_affects_data_subjects_in_more_than_one_member_state, objection_demonstrates_significance_of_risks.

Crisp (true or false): purposes_and_means_determined_by_law, established_in_more_than_one_member_state, central_administration_in_union, decisions_taken_in_other_union_establishment, processor_subject_to_specific_obligations, entity_is_person_partnership_or_association, party_established_in_authority_member_state, complaint_lodged_with_authority, objection_to_draft_decision, objection_concerns_infringement_or_envisaged_action.

Role: party_role (controller or processor).

Outside fact: party_provided_for_as_controller_by_law, attested(true or false, attestation(By, At, Reason, Evidence)).

## Citation keys

eu_reg_2016_679_art_4_1, _4_7, _4_8, _4_13, _4_14, _4_15, _4_16, _4_16_a, _4_16_b, _4_18, _4_19, _4_22, _4_22_a, _4_22_b, _4_22_c, _4_23, _4_23_a, _4_23_b, _4_24, union_or_member_state_law_providing_for_controller.

## Public predicates

- party_is_controller(Profile, Answer): Art 4(7).
- party_is_processor(Profile, Answer): Art 4(8).
- genetic_data(Profile, Answer): Art 4(13).
- biometric_data(Profile, Answer): Art 4(14).
- data_concerning_health(Profile, Answer): Art 4(15).
- main_establishment(Profile, Answer): Art 4(16).
- enterprise(Profile, Answer): Art 4(18).
- group_of_undertakings(Profile, Answer): Art 4(19).
- supervisory_authority_concerned(Profile, Answer): Art 4(22).
- cross_border_processing(Profile, Answer): Art 4(23).
- relevant_and_reasoned_objection(Profile, Answer): Art 4(24).
- roles_and_establishments_outside_facts(Profile, Facts): the outside fact as outside_fact(Key, Attested or absent); Art 4(7).
- decide_gdpr_common_definitions_roles_and_establishments(Profile, Verdict): headline verdict, the controller determination (Art 4(7)).
- gdpr_common_definitions_roles_and_establishments_status(Profile, Status): the status atom of that verdict.
- gdpr_common_definitions_roles_and_establishments_checklist(Profile, Items): one item(Relation, Status, cite(Point)) per relation (justification).
- gdpr_common_definitions_roles_and_establishments_what_if(Profile, Key, Value, Status): one key overridden, then re-evaluated.
- gdpr_common_definitions_roles_and_establishments_input_problems(Profile, Problems): kernel input check.
- fixtures: subject/1, profile_for/2, assess/2.

## Result constructors (data terms)

- definition_answer(Status, Ground, Citations): the answer of every definition relation.
- input_problems(Problems): status of a profile with input problems.
- unknown_key(Key): input problem, a key outside the twenty-six.
- wrong_type(Key): input problem, a present value outside its type; wrong_type(profile) for a non attribute list.
- duplicate_key(Key): input problem, a contract key occurring more than once.
- indeterminate(MissingKeys): status, the absent keys at the leaves reached.
- needs_legal_review(Reason, Context): status, facts complete but the law does not settle it.
- open_textured(Input, Citation): reason, an unsure judgement decides; Citation is cite(Key).
- cross_reference_unresolved(Citation, Target): reason, an absent outside fact decides.
- resolution(Target, Status): context item, Status is not_attempted (no fetcher); Art 4(7).
- inputs_relied_on(Pairs): context item, the Key-Value pairs relied on.
- provenance(Clause, Citations): optional context item marking the deciding clause, not compared.
- outside_fact(Key, Attested): item of the outside facts list.
- attested(Value, Attestation): outside fact value, Value true or false.
- attestation(By, At, Reason, Evidence): host-supplied attestation.
- url(Address, RetrievedAt): evidence kind of an attestation.
- document(UploadId, Sha256): evidence kind of an attestation.

## Slice: gdpr_common_definitions_roles_and_establishments.clausal

Owns: the formula table (relation to formula), the referral rows, the outside-fact row, the contract key order and the citation tables. There are no numeric thresholds. Verdict atoms are as above. Nothing is shared with another slice; the kernel holds only the input check.

Rules: 11 relations, one checklist row each.

## Planned reuse

formalize_lib (profile_get/3, profile_lacks/2), library(reif) (memberd_t/3), citations (implements/1), kernel (input check).
