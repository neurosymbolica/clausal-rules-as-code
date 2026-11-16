# SIGNATURE - eu/data_protection/gdpr_processor_contract

## Verdict statuses

eligible | ineligible | not_applicable (bare); indeterminate(MissingKeys); needs_legal_review(Reason, Context); input_problems(Problems). Verdict term: processor_contract_verdict(Status, Missing, Citations). Reasons: open_textured(Input, cite(Key)), deferred_provision(cite(Key)). Context: [inputs_relied_on(Pairs)]. Checklist states: met | unmet | open_by_absence | open_by_judgement.

## Profile keys (attribute list of attribute(Key, Value))

Judgements (true, false, unsure): processing_on_behalf_of_controller, processor_determines_purposes_and_means, processor_provides_sufficient_guarantees, contract_binding_on_processor, subprocessor_obligations_same, subprocessor_provides_sufficient_guarantees.
Crisp (true, false): contract_governed_by_union_or_member_state_law, contract_in_writing, contract_sets_out_subject_matter, contract_sets_out_duration, contract_sets_out_nature_of_processing, contract_sets_out_purpose_of_processing, contract_sets_out_type_of_personal_data, contract_sets_out_categories_of_data_subjects, contract_sets_out_controller_obligations_and_rights, stipulates_processing_only_on_documented_instructions, stipulates_confidentiality_commitment, stipulates_security_measures, stipulates_conditions_for_engaging_another_processor, stipulates_assistance_with_data_subject_requests, stipulates_assistance_with_articles_32_to_36_obligations, stipulates_deletion_or_return_of_personal_data, stipulates_information_and_audit_rights, stipulates_notice_of_infringing_instruction, subprocessor_engaged, subprocessor_authorisation_given_before_engagement, processor_informed_controller_of_intended_changes, controller_given_opportunity_to_object, subprocessor_contract_in_writing, subprocessor_contract_governed_by_union_or_member_state_law.
Enumerated: subprocessor_authorisation (specific_written | general_written | none).
Outside fact: standard_clauses_adopted = attested(true or false, attestation(By, At, Reason, Evidence)).

## Citation keys

eu_reg_2016_679_art_4_8, art_28_1, art_28_2, art_28_3, art_28_3_a to art_28_3_h, art_28_3_second_subpara, art_28_4, art_28_6, art_28_7, art_28_9, art_28_10 (all prefixed eu_reg_2016_679_). Recorded only: art_4_1, art_4_2, art_4_7, art_28_5, art_28_8, art_29.

## Public predicates

- decide_processor_contract(Profile, Verdict): the whole verdict + Art 28.
- processor_contract_status(Profile, Status): the status field.
- contract_missing_stipulations(Profile, Missing): the missing keys, [] unless ineligible.
- contract_checklist(Profile, Items): checklist_item(Key, cite(Citation), State) per limb read, independent of the gates.
- processor_contract_outside_facts(Profile, Facts): outside_fact(standard_clauses_adopted, Attested or absent).
- gdpr_processor_contract_input_problems(Profile, Problems): input check (kernel).
- decide_processor_contract_status(Profile, Verdict), processor_contract_status_status(Profile, Status), processor_contract_status_checklist(Profile, Items): scaffold facade names.
- gdpr_processor_contract_what_if(Profile, Key, Value, Status): override one attribute and re-evaluate.
- gdpr_processor_contract_subject/1, gdpr_processor_contract_profile_for/2, gdpr_processor_contract_assess/2: fixtures.
- Constructors: processor_contract_verdict/3, checklist_item/3, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, indeterminate/1, needs_legal_review/2, open_textured/2, deferred_provision/1, inputs_relied_on/1, provenance/2, outside_fact/2, attested/2, attestation/4, url/2, document/2.

## Slice: processor_contract_status

Owns the limb table (key, cite term, kind, reading condition), the value-to-state tables and the gate and checklist logic. Statutory value facts: none numeric (Art 28 has no deadline or amount). Rules: R1 role gate (Art 4(8)), R2 role gate (Art 28(10)), checklist limbs of Art 28(1), (2), (3), (4), (9). Verdict atoms: eligible, ineligible, not_applicable, indeterminate(..), needs_legal_review(..), input_problems(..). Nothing is shared with another slice, so kernel.clausal keeps only the input check.

## Planned reuse

formalize_lib (profile_get/3, profile_lacks/2), library(reif) (if_/3, memberd_t/3), citations (implements/1), kernel (gdpr_processor_contract_input_problems/2).
