# SIGNATURE - eu/data_protection/gdpr_data_subject_rights_automated_decision

## Verdict statuses

COMPLY is one of: must_comply, need_not_comply, indeterminate(MISSING_KEYS), needs_legal_review(REASON, CONTEXT), suspended(art12_6_identity_not_confirmed), input_problems(PROBLEMS).
BASIS: art22_1 | none.
EXCEPTION: art22_2_a | art22_2_b | art22_2_c | art12_5_manifestly_unfounded_or_excessive | art12_2_unable_to_identify | art23_legislative_restriction | none.
CONDITIONS: [human_intervention, express_point_of_view, contest_decision] | [reasonable_fee_may_be_charged] | [].
Verdict term: gdpr_data_subject_request_verdict(COMPLY, BASIS, EXCEPTION, CONDITIONS, CITATIONS).

## Profile keys

The profile is an attribute list [attribute(Key, Value), ...] with the fifty-four contract keys of the order, read only with profile_get/3 and profile_lacks/2. Keys this slice reads:
- request_type
- decision_based_solely_on_automated_processing (judgement)
- decision_produces_legal_or_similarly_significant_effects (judgement)
- decision_necessary_for_contract_with_data_subject (judgement)
- data_subject_gave_explicit_consent
- decision_based_on_special_categories
- special_category_condition_and_safeguards_met_for_decision
- request_manifestly_unfounded_or_excessive (judgement)
- controller_demonstrates_unable_to_identify_data_subject
- reasonable_doubts_about_identity (judgement)
- identity_confirmed
- decision_authorised_by_union_or_member_state_law (outside fact)
- legislative_restriction_applies_to_the_right (outside fact)

Dates are date(Year, Month, Day) terms. Outside facts are attested(Value, attestation(By, At, Reason, Evidence)).

## Citation keys

eu_reg_2016_679_art_12_2, eu_reg_2016_679_art_12_3 (reasoning only), eu_reg_2016_679_art_12_4 (reasoning only), eu_reg_2016_679_art_12_5, eu_reg_2016_679_art_12_6, eu_reg_2016_679_art_22_1, eu_reg_2016_679_art_22_2, eu_reg_2016_679_art_22_2_a, eu_reg_2016_679_art_22_2_b, eu_reg_2016_679_art_22_2_c, eu_reg_2016_679_art_22_3, eu_reg_2016_679_art_22_4 (reasoning only), eu_reg_2016_679_art_23_1.

## Public predicates

- decide_data_subject_request(Profile, Verdict): the whole verdict; exactly one solution per profile (Art 22, Art 12, Art 23).
- request_basis(Profile, Basis): the BASIS field of the verdict (art22_1 | none).
- gdpr_data_subject_rights_automated_decision_input_problems(Profile, Problems): the input check, from the kernel.
- decide_request_basis(Profile, request_basis_verdict(Basis, Citations)): scaffold facade projection of the verdict.
- request_basis_status(Profile, Basis): scaffold facade status projection.
- request_basis_checklist(Profile, Items): justification, one item(Id, Status, cite(Key)) per limb.
- request_basis_decision_resolvable(Profile): a verdict exists.
- request_basis_status_values(Values): [art22_1, none].
- gdpr_data_subject_rights_automated_decision_what_if(Profile, Key, Value, Status): override one key and re-evaluate.
- gdpr_data_subject_rights_automated_decision_profile_keys(Keys): the key schema.
- fixtures: gdpr_data_subject_rights_automated_decision_subject/1, _profile_for/2, _assess/2.
- Result constructors (declared, never queries): gdpr_data_subject_request_verdict/5, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, suspended/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, attested/2, attestation/4, url/2, document/2.

## Planned reuse

- formalize_lib: profile_get/3, profile_lacks/2.
- library(reif): memberd_t/3.
- kernel: gdpr_data_subject_rights_automated_decision_input_problems/2.
- citations: implements/1.
- No other kit module is needed; the kit's compliance_lib is not used because the verdict has its own six-step decision order.

## Slice: request_basis.clausal

- Value facts it owns: the exception order, the per-exception CONDITIONS table, the per-exception CITATIONS table, the key-order tables (root_exports order), the referral-citation table. There are no numeric thresholds or periods in this order.
- Rules (each opens with implements/1): engagement (Art 22(1)), suspension (Art 12(6)), special-category bar (Art 22(4)), art22_2_a, art22_2_b, art22_2_c, art12_5, art12_2, art23_legislative_restriction.
- Limb status terms: met | unmet | open(AbsentKeys, UnsureKeys), combined by strong Kleene (unmet dominates AND).
- Verdict atoms: as above. Routes are disjoint clauses of assemble/8: engagement unmet; exception met; suspended; open limb (indeterminate or needs_legal_review); must_comply.
- Shared predicates: none besides the kernel input check.
