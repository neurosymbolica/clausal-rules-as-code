# SIGNATURE - eu/data_protection/gdpr_consent_conditions

## Verdict STATUS atoms (replacing the scaffold placeholders)

- consent_conditions_status/4: not_applicable | conditions_met | conditions_not_met | indeterminate(MissingKeys) | needs_legal_review(Reason, Context) | input_problems(Problems)
- consent_declaration_effect/3: not_applicable | part_not_binding | no_part_infringing | indeterminate(MissingKeys) | input_problems(Problems)
- consent_assessment_factors/2: [] | [factor(contract_conditional_on_unneeded_consent, cite(eu_reg_2016_679_art_7_4))] | indeterminate(MissingKeys) | input_problems(Problems)
- identification_obligation/4: not_obliged_to_acquire_identifying_information | art11_1_not_engaged | needs_legal_review | input_problems
- identification_information_duty/4: must_inform_data_subject | need_not_inform_data_subject | art11_2_not_engaged | needs_legal_review | input_problems
- identification_rights_effect/4: articles_15_to_20_apply | articles_15_to_20_do_not_apply | art11_2_not_engaged | indeterminate | needs_legal_review | input_problems

## Profile keys (attribute list [attribute(Key, Value)], thirteen keys in this order)

Crisp (true or false): processing_based_on_consent, consent_in_declaration_with_other_matters, declaration_part_infringes_regulation, informed_of_withdrawal_right_before_consent, contract_conditional_on_unneeded_consent, additional_identifying_information_provided.
Outside facts (attested(true or false, attestation(By, At, Reason, Evidence))): consent_demonstrable, request_clearly_distinguishable_and_intelligible, withdrawal_as_easy_as_giving_consent, consent_freely_given, purposes_do_not_require_identification, able_to_demonstrate_not_in_position_to_identify, informing_data_subject_possible.
No numeric or date keys.

## Citation keys

eu_reg_2016_679_art_7_1, eu_reg_2016_679_art_7_2, eu_reg_2016_679_art_7_3, eu_reg_2016_679_art_7_4, eu_reg_2016_679_art_11_1, eu_reg_2016_679_art_11_2

## Public predicates

- consent_conditions_status(Profile, Status, Basis, Citations): Art 7(1) to (4) conditions on the stated facts; cites the four Art 7 keys.
- consent_declaration_effect(Profile, Status, Citations): Art 7(2) last sentence, a part that infringes is not binding.
- consent_assessment_factors(Profile, Factors): Art 7(4) named factor, reported and decides nothing.
- identification_obligation(Profile, Status, Basis, Citations): Art 11(1).
- identification_information_duty(Profile, Status, Basis, Citations): Art 11(2) informing duty.
- identification_rights_effect(Profile, Status, Basis, Citations): Art 11(2) Arts 15 to 20 disapplication.
- gdpr_consent_conditions_input_problems(Profile, Problems): the input check (kernel).
- decide_gdpr_consent_conditions(Profile, Verdict): verdict term gdpr_consent_conditions_verdict(Status, Citations) over consent_conditions_status.
- gdpr_consent_conditions_status(Profile, Status): status projection.
- gdpr_consent_conditions_checklist(Profile, Items): item(Id, Status, cite(Key)) rows, one per limb.
- gdpr_consent_conditions_what_if(Profile, Key, Value, NewStatus): override one attribute and re-evaluate.
- gdpr_consent_conditions_subject/1, gdpr_consent_conditions_profile_for/2, gdpr_consent_conditions_assess/2: fixtures.
- Atoms and result constructors exported with defining clauses: not_applicable/0, conditions_met/0, conditions_not_met/0, part_not_binding/0, no_part_infringing/0, not_obliged_to_acquire_identifying_information/0, art11_1_not_engaged/0, art11_2_not_engaged/0, must_inform_data_subject/0, need_not_inform_data_subject/0, articles_15_to_20_apply/0, articles_15_to_20_do_not_apply/0, indeterminate/1, needs_legal_review/2, inputs_relied_on/1, provenance/2, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, factor/2, cross_reference_unresolved/2, resolution/2, outside_fact/2, attested/2, attestation/4, url/2, document/2.

## Planned reuse

formalize_lib: profile_get/3, profile_lacks/2. No other kit module is needed. kernel: gdpr_consent_conditions_input_problems/2. citations: implements/1.

## Slice: gdpr_consent_conditions.clausal

- Value facts it owns: the referral table outside_fact_row/3 (key, cite of its article, cite of the target), and the status-values table. No numeric statutory figures exist, so parameters.clausal stays empty.
- Rules: limbs L1 (Art 7(1)), L2 (Art 7(2), only when the declaration key is true), L3 (Art 7(3): information key and ease statement), L4 (Art 7(4)); the declaration effect; the factor; Art 11(1); Art 11(2) engagement (both outside facts attested true), informing duty, rights effect.
- Verdict atoms: as listed above.
- Shared predicates: none beyond the kernel input check.
