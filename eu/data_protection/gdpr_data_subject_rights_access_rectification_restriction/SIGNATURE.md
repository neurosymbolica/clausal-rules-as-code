# SIGNATURE: eu/data_protection/gdpr_data_subject_rights_access_rectification_restriction

## Verdict STATUS atoms

COMPLY: must_comply | need_not_comply | indeterminate(Keys) | needs_legal_review(Reason, Context) | suspended(art12_6_identity_not_confirmed) | input_problems(Problems).
BASIS: art15_1 | art16_inaccurate_data | art16_incomplete_data | art18_1_a | art18_1_b | art18_1_c | art18_1_d | none.
EXCEPTION: art12_5_manifestly_unfounded_or_excessive | art12_2_unable_to_identify | art23_legislative_restriction | none.
CONDITIONS: [reasonable_fee_may_be_charged] | [].

## Profile keys

An attribute list [attribute(Key, Value)] with the fifty-four contract keys of the order (see kernel.clausal key_type/2): request_type, the 25 crisp flags, the 21 tri-state judgements, the four attested outside facts and public_holidays. Dates are date(Year, Month, Day).

## Citation keys

eu_reg_2016_679_art_12_2, _12_5, _12_6, _15_1, _16, _18_1, _18_1_a, _18_1_b, _18_1_c, _18_1_d, _23_1.

## Public predicates

- decide_data_subject_request(Profile, Verdict): the whole verdict. Art 12, 15, 16, 18, 23.
- request_basis(Profile, Basis): the BASIS field.
- gdpr_data_subject_rights_access_rectification_restriction_input_problems(Profile, Problems): input check (kernel).
- decide_request_basis(Profile, request_basis_verdict(Basis, Citations)): facade projection.
- request_basis_status(Profile, Status): the BASIS atom.
- request_basis_checklist(Profile, Items): item(Id, Status, cite(Key)) rows, one per limb.
- request_basis_decision_resolvable(Profile): a verdict exists.
- request_basis_status_values(Values): the BASIS vocabulary.
- gdpr_data_subject_rights_access_rectification_restriction_what_if(Profile, Key, Value, Status): override one attribute, re-decide.
- result constructors: gdpr_data_subject_request_verdict/5, indeterminate/1, needs_legal_review/2, open_textured/2, inputs_relied_on/1, provenance/2, suspended/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, attested/2, attestation/4, url/2, document/2.
- fixtures: ..._subject/1, ..._profile_for/2, ..._assess/2.

## Slice: request_basis.clausal

Owns: the engagement of each right, the exceptions, the suspension, the citation assembly and the checklist. No numeric statutory values (periods are not exported by this order). Verdict atoms as above. Nothing is shared with another slice, so the kernel holds only the input check.

## Planned reuse

formalize_lib (profile_get/3, profile_lacks/2), library(reif) memberd_t/3, citations implements/1, kernel input check.
