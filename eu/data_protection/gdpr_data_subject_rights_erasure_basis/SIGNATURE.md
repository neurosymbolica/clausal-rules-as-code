# SIGNATURE: eu/data_protection/gdpr_data_subject_rights_erasure_basis

## Verdict status atoms

BASIS: art17_1_a | art17_1_b | art17_1_c | art17_1_d | art17_1_e | art17_1_f | none.
COMPLY (internal): must_comply | need_not_comply | indeterminate(Keys) | needs_legal_review(Reason, Context) | suspended(art12_6_identity_not_confirmed) | input_problems(Problems).
EXCEPTION: art17_3_a .. art17_3_e | art12_5_manifestly_unfounded_or_excessive | art12_2_unable_to_identify | art23_legislative_restriction | none.

## Profile keys

The fifty-four keys of the order's input contract (see kernel.clausal key_type/2), an attribute list [attribute(Key, Value), ...] read with profile_get/3. Dates are date(Year, Month, Day).

## Citation keys

eu_reg_2016_679_art_12_2, eu_reg_2016_679_art_12_5, eu_reg_2016_679_art_12_6, eu_reg_2016_679_art_17_1, eu_reg_2016_679_art_17_1_a to eu_reg_2016_679_art_17_1_f, eu_reg_2016_679_art_17_3_a to eu_reg_2016_679_art_17_3_e, eu_reg_2016_679_art_23_1, and the three outside-fact targets union_or_member_state_law_requiring_erasure, union_or_member_state_law_requiring_processing, union_or_member_state_law_restricting_the_right.

## Public predicates

- request_basis(Profile, Basis): the BASIS field of the erasure decision (Art 17(1)); none for every non-final COMPLY.
- gdpr_data_subject_rights_erasure_basis_input_problems(Profile, Problems): input check, in kernel (contract).
- decide_request_basis(Profile, Verdict): the compliance check, with Art 17 provenance (cite(...) per item).
- request_basis_status(Profile, Status): the Basis projection.
- request_basis_checklist(Profile, Items): item(Id, Status, cite(Key)) per ground, exception and the Art 12(6) suspension (justification).
- request_basis_decision_resolvable(Profile): the decision has an answer.
- request_basis_status_values(Values): the pinned vocabulary.
- gdpr_data_subject_rights_erasure_basis_what_if(Profile, Key, Value, Status): override one key and re-evaluate.
- fixtures: subject/1, profile_for/2, assess/2.

## Result constructors (terms, never called as queries)

- indeterminate(MissingKeys): COMPLY status naming the absent required profile keys (Art 17(1)).
- needs_legal_review(Reason, Context): COMPLY status when facts are complete but a limb is open (Art 17(1)).
- open_textured(Input, Citation): REASON for an unsure judgement; Citation is cite(Key) from the referrals table.
- inputs_relied_on(Pairs): CONTEXT item listing the Key-Value pairs relied on.
- provenance(Clause, Citations): optional unscored CONTEXT item marking the deciding clause.
- input_problems(Problems): COMPLY status when the input check is non-empty.
- unknown_key(Key): input problem, a key outside the fifty-four of the contract.
- wrong_type(Key): input problem, a present value outside its type.
- duplicate_key(Key): input problem, a contract key occurring more than once.
- attested(Value, Attestation): wrapper of an outside-fact value.
- attestation(By, At, Reason, Evidence): provenance of an attested outside fact.
- url(Address, RetrievedAt): EVIDENCE form for a fetched source.
- document(UploadId, Sha256): EVIDENCE form for an uploaded document.

## Slice: request_basis.clausal

Owns: the six Art 17(1) points, the eight exceptions, the suspension, the referral table (judgement key to citation key), the key orders (contract order) used for MISSING_KEYS and PAIRS. No numeric statutory values: no parameters.
Routes: unengaged, relieved, suspended, open, must_comply, one clause each in route/5 with disjoint guards.
Shares nothing with other slices; the input check lives in the kernel.

## Planned reuse

formalize_lib (profile_get/3, profile_lacks/2), library(reif) memberd_t/3, citations implements/1, kernel input check.
