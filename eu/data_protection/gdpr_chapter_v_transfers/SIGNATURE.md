# SIGNATURE — eu/data_protection/gdpr_chapter_v_transfers

## 1 Public query surface

The main query is `decide_transfer(Profile, Verdict)`. Its basis companion is `transfer_basis(Profile, Basis)`.

Profile is an attribute list `[attribute(Key, Value), ...]` over the NINETEEN keys of section 3. It is read only with `profile_get/3`, presence first and then value. Section 2 lists the Verdict and Basis vocabularies.

The input check `gdpr_chapter_v_transfers_input_problems/2` runs FIRST. A non-empty problem list decides every relation, as given in section 6.

Totality: every public relation has exactly ONE solution for every ground well-formed profile. The input check has exactly one solution for EVERY term, unbound terms included.

Determinism: no answer is yielded twice. The scorer collects all solutions.

No statutory figure is imported or declared. The only figure in the pinned text, the Art 45(3) four-year review, is read by no rule.

## 2 Verdict status atoms (replace the scaffold placeholders `required / permitted / not_applicable`)

- `eligible`: the transfer may take place, on the basis given by `transfer_basis/2`.
- `ineligible`: no Chapter V basis is made out.
- `indeterminate(MissingKeys)`: a non-empty list of bare key atoms, in root_exports order, without duplicates. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(Reason, Context)`, where Reason is one of the following:
  - `open_textured(InputKey, cite(CitationKey))`, with Context `[inputs_relied_on(Pairs)]`;
  - `cross_reference_unresolved(cite(eu_reg_2016_679_art_45), cite(eu_reg_2016_679_art_45_3))`, with Context `[resolution(cite(eu_reg_2016_679_art_45_3), not_attempted), inputs_relied_on(Pairs)]`.
- `input_problems(Problems)`, where Problems is a non-empty list of `duplicate_key(K)`, `wrong_type(K)`, `unknown_key(K)` or `[wrong_type(profile)]`.
- Basis atoms: `art45_adequacy`, `art46_safeguards`, `art49_derogation`, `none`.
- Requirement ids, in cascade order: `art45_adequacy`, `art46_safeguards`, `art49_derogation`.
- Derogation atoms (values of `derogation_claimed`): `art49_1_a`, `art49_1_b`, `art49_1_c`, `art49_1_d`, `art49_1_e`, `art49_1_f`, `art49_1_g`, `art49_1_second_subpara`. These are spec-mandated spellings. `subpara` carries `% lint: allow-abbreviation spec-mandated atom` at its one declaration.
- Stage-outcome atoms, used inside the package and by `transfer_basis_status/2`:
  - `met`
  - `unmet`
  - `open_by_absence(MissingKeys)`
  - `open_by_judgement(InputKey)`
  - `open_by_outside_fact(adequacy_decision_in_force)`
- Result constructors, exported and never called as queries: `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `resolution/2`, `inputs_relied_on/1`, `provenance/2`, `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`.

## 3 Profile keys (root_exports order = input_contract order; nineteen, all root-exported)

No key is numeric and no key is a date. The attestation time `At` is the host's term, copied and never read.

| # | key | type | read by |
|---|-----|------|---------|
| 1 | adequacy_decision_in_force | outside fact | stage one; stage two when absent |
| 2 | derogation_claimed | one of the eight derogation atoms | stage three |
| 3 | safeguard_in_place | judgement (true / false / unsure) | stage two |
| 4 | public_authority_public_powers | crisp defeater (true / false) | stage three (a), (b), (c), second subparagraph |
| 5 | explicit_consent_obtained | crisp | (a) |
| 6 | contract_necessity | judgement | (b) |
| 7 | data_subject_interest_contract_necessity | judgement | (c) |
| 8 | important_public_interest | judgement | (d) with Art 49(4) |
| 9 | legal_claims_necessity | judgement | (e) |
| 10 | vital_interests_necessity | judgement | (f) |
| 11 | register_public_by_law | crisp | (g) |
| 12 | register_consultation_conditions_fulfilled | crisp | (g) |
| 13 | register_not_entire | crisp | (g) with Art 49(2) |
| 14 | register_requester_condition_met | crisp; only a present false is UNMET | (g) with Art 49(2) |
| 15 | legitimate_interests_derogation | judgement | second subparagraph |
| 16 | transfer_is_onward_transfer | outside fact | recorded only (Art 44) |
| 17 | binding_corporate_rules_approved | outside fact | stage two (Art 46(2)(b), 47(1)) |
| 18 | third_country_judgment_or_decision_requires_transfer | outside fact | recorded only (Art 48) |
| 19 | international_agreement_basis_for_judgment_or_decision | outside fact | recorded only (Art 48) |

Value typing:

- **Outside fact.** `attested(V, attestation(By, At, Reason, Evidence))`, with V the atom true or false. Only the arity of `attestation` is checked. Evidence is `url(Url, RetrievedAt)`, `document(UploadId, Sha256)` or `none`, and is not inspected.
- **Judgement.** The atoms true, false or unsure.
- **Crisp.** The atoms true or false. unsure is `wrong_type`.
- Absent means NOT ESTABLISHED. A key a stage does not read never changes the answer.

## 4 Citation-key atoms (canonical lexicon scheme; cite(Key) terms; unit map in citations.clausal)

- `eu_reg_2016_679_art_44` -> 02016R0679-20160504#art_044
- `eu_reg_2016_679_art_45` -> Article 45 as a whole, the cross-reference source. The article unit 02016R0679-20160504#art_045 is not pinned.
- `eu_reg_2016_679_art_45_1` -> #parag_045.001
- `eu_reg_2016_679_art_45_3` -> #parag_045.003, the cross-reference target
- `eu_reg_2016_679_art_45_8` -> #parag_045.008
- `eu_reg_2016_679_art_46` -> Article 46 as a whole, the citation of the safeguard_in_place referral row. Pinned through #parag_046.001.
- `eu_reg_2016_679_art_46_1` -> #parag_046.001
- `eu_reg_2016_679_art_46_2` -> #parag_046.002
- `eu_reg_2016_679_art_46_2_b` -> #point_046.002_b
- `eu_reg_2016_679_art_47_1` -> #parag_047.001 (points #point_047.001_a to _c)
- `eu_reg_2016_679_art_48` -> #art_048
- `eu_reg_2016_679_art_49_1` -> #parag_049.001
- `eu_reg_2016_679_art_49_1_a` to `eu_reg_2016_679_art_49_1_g` -> #parag_049.001, first subparagraph, points (a) to (g)
- `eu_reg_2016_679_art_49_1_second_subpara` -> #parag_049.001, second subparagraph
- `eu_reg_2016_679_art_49_2` -> #parag_049.002
- `eu_reg_2016_679_art_49_3` -> #parag_049.003
- `eu_reg_2016_679_art_49_4` -> #parag_049.004

## 5 Outside-fact declaration (manifest `outside_facts:`)

There are five entries:

- `adequacy_decision_in_force`: enabling under A2. Absent refers where the answer turns on it.
- `transfer_is_onward_transfer`: not enabling; recorded only.
- `binding_corporate_rules_approved`: not enabling.
- `third_country_judgment_or_decision_requires_transfer`: not enabling; recorded only.
- `international_agreement_basis_for_judgment_or_decision`: not enabling; recorded only.

Each entry has arrival `[attested, fetched]`, fetcher `none`, and precedence attested over fetched.

## 6 Public predicates

With input problems P non-empty, every predicate below gives the input-problems value stated for it.

- `decide_transfer(Profile, Verdict)`: the Chapter V verdict over the cascade (section 2). Input problems give `input_problems(P)`. [eu_reg_2016_679_art_44; eu_reg_2016_679_art_45_1; eu_reg_2016_679_art_46_1; eu_reg_2016_679_art_49_1]. Serves query type #2 eligibility.
- `transfer_status(Profile, Status)`: the status determination (query type #3). Status is the same term as `decide_transfer/2`, one solution. [eu_reg_2016_679_art_44]
- `transfer_permitted(Profile, Permitted)`: the compliance check (query type #13).
  - `true` when eligible.
  - `false` when ineligible.
  - Otherwise the non-final status compound: `indeterminate(...)`, `needs_legal_review(...)` or `input_problems(...)`.
  - [eu_reg_2016_679_art_44]
- `transfer_basis(Profile, Basis)`: the basis of an eligible answer, else `none`. `none` also covers every non-final status and input problems. [eu_reg_2016_679_art_45_1; eu_reg_2016_679_art_46_1; eu_reg_2016_679_art_46_2_b; eu_reg_2016_679_art_49_1]
- `decide_transfer_basis(Profile, Basis)`: the scaffold facade name. It is identical to `transfer_basis/2`, one solution. [same]
- `transfer_basis_status(Profile, Status)`: the outcome of the stage that ended the evaluation: `met`, `unmet`, `open_by_absence(Keys)`, `open_by_judgement(InputKey)` or `open_by_outside_fact(adequacy_decision_in_force)`. Input problems give `input_problems(P)`. [eu_reg_2016_679_art_45_3; eu_reg_2016_679_art_46_1; eu_reg_2016_679_art_49_1]
- `transfer_basis_checklist(Profile, Items)`: the justification (query types #2 and #7). It is one `item(RequirementId, Status, cite(CitationKey))` per stage evaluated, up to and including the ending stage, in cascade order.
  - Status is one of: `met`, `unmet(Reason)`, `unknown(MissingKeys)`, `referred(open_by_judgement(InputKey))`, `referred(open_by_outside_fact(adequacy_decision_in_force))`, or `not_established` (stage one with the adequacy fact absent).
  - Met items carry a citation too.
  - Input problems give `[]`.
  - [section 4 keys per item]
- `transfer_checklist(Profile, Items)`: `[Basis]` when eligible, else `[]`, input problems included. This is the legacy shape. [eu_reg_2016_679_art_44]
- `transfer_verdict(Profile, Verdict, Basis)`: the pair of `decide_transfer/2` and `transfer_basis/2`. Input problems give `input_problems(P)` and `none`. [eu_reg_2016_679_art_44]
- `transfer_requirement(Profile, Requirement, Verdict, Basis)`: Requirement is the requirement id of the ending stage. It is `art46_safeguards` for every stage-two ending, the status rule included. Input problems give `none`, `input_problems(P)` and `none`. [eu_reg_2016_679_art_44]
- `transfer_requirement_ids(Ids)`: `[art45_adequacy, art46_safeguards, art49_derogation]`. [eu_reg_2016_679_art_44]
- `transfer_outside_facts(Profile, OutsideFacts)`:
  - The list starts with `outside_fact(adequacy_decision_in_force, Attested)`, or `outside_fact(adequacy_decision_in_force, absent)` when the key is absent.
  - It continues with `outside_fact(Key, Attested)` for each PRESENT fact among keys 16 to 19, in root order.
  - Input problems give `input_problems(P)`.
  - [eu_reg_2016_679_art_45_3; eu_reg_2016_679_art_44; eu_reg_2016_679_art_47_1; eu_reg_2016_679_art_48]
- `gdpr_chapter_v_transfers_input_problems(Profile, Problems)`: the input contract check. It never fails, never raises, and has one solution. `[]` means well-formed.
- `gdpr_chapter_v_transfers_what_if(Profile, Key, Value, Verdict)`: the verdict of Profile with `attribute(Key, Value)` set through `profile_set/3`, replacing any existing entry. The modified profile passes the input check first. [eu_reg_2016_679_art_44]
- `gdpr_chapter_v_transfers_fixture(Name, Profile)` and `gdpr_chapter_v_transfers_fixture_expectation(Name, Verdict, Basis)`: the fixtures (section 12).

## 7 Planned reuse (manifest `uses:`)

From formalize_lib:

- `profile_get/3` and `profile_has/2` read the profile. `profile_set/3` is used by what_if.
- `check_true/4` reads crisp keys and the true/false/absent worlds of judgement keys. The unsure world is caught first by a guarded clause on `profile_get(Profile, Key, unsure)`.
- `not_defeated/3` runs the Art 49(3) defeater with closure `gdpr_chapter_v_transfers_defeated`.
- `eval_requirements/4` builds the basis checklist with the closure `gdpr_chapter_v_transfers_basis_requirement(RequirementId, Profile, Status, Citation)`. RequirementId is FIRST, which avoids the R1 lint.
- `item/3`, `attribute/2`, `not_member/2` and `memberd/2` are also used.

Not used, by design:

- `and_status/2` and `or_status/2`: three-valued, with no unsure world. A local four-valued combinator lives in kernel.clausal (kit gap, the working notes (not published)).
- `check_tri/4`: it does not distinguish unsure. It is not cloned, which avoids the C15 lint.
- `assess/6`: the verdict vocabulary is richer than `labels/3`.
- `kit/compliance_lib`: the modality lattice adds nothing to a three-stage permission cascade.
- `kit/query_combinators` `what_if/5`: it overrides dict worlds, not attribute lists.
- `validate_props` is used by the tests: `prop_totality/3`, `prop_determinism/3` and `prop_citation_complete/3` over the fixtures.
- Family backbone (`_common`): none needed.

## 8 kernel.clausal (the shared floor — ONLY what both slices read)

Shared value facts:

- **Contract key rows** (19): `gdpr_chapter_v_transfers_contract_key(Position, Key, Type)`, with Type in {outside_fact, derogation, judgement, crisp} in section 3 order. Read by the input check, the PAIRS order and the MISSING_KEYS order.
- **Derogation atom rows** (8): `gdpr_chapter_v_transfers_derogation(Atom, CitationKey)`, for example `art49_1_b` maps to `eu_reg_2016_679_art_49_1_b`.
- **Referral rows** (7, input to citation):
  - `safeguard_in_place` -> `eu_reg_2016_679_art_46`
  - `contract_necessity` -> `eu_reg_2016_679_art_49_1_b`
  - `data_subject_interest_contract_necessity` -> `eu_reg_2016_679_art_49_1_c`
  - `important_public_interest` -> `eu_reg_2016_679_art_49_1_d`
  - `legal_claims_necessity` -> `eu_reg_2016_679_art_49_1_e`
  - `vital_interests_necessity` -> `eu_reg_2016_679_art_49_1_f`
  - `legitimate_interests_derogation` -> `eu_reg_2016_679_art_49_1_second_subpara`
- **Defeated points:** `gdpr_chapter_v_transfers_defeated(Point, Profile)`, where Point is one of `art49_1_a`, `art49_1_b`, `art49_1_c` or `art49_1_second_subpara`, and the body is `once(profile_get(Profile, public_authority_public_powers, true))`. This is the guarded defeater, cut-free.

Shared predicates:

- `gdpr_chapter_v_transfers_input_problems/2`: the total checker of the working notes (not published). It walks the list with `var/1` guards and compares by `==`.
- `gdpr_chapter_v_transfers_conjoin(Outcomes, Outcome)`: the four-valued strong Kleene of the working notes (not published), with MISSING_KEYS in root order and without duplicates.
- `gdpr_chapter_v_transfers_point_outcome(Point, Profile, Outcome)`: one point of Art 49(1), defeater included.
  - Point (g) uses the three required flags, plus `register_requester_condition_met` with only false UNMET.
  - The second subparagraph conjoins `legitimate_interests_derogation` with the negation of each point (a) to (g).
- `gdpr_chapter_v_transfers_cascade(Profile, RequirementId, Outcome, JudgementPairs, CitationKey)`: exactly one solution per well-formed profile. JudgementPairs holds the present judgements the ending stage read, as Key-Value pairs in root order. It is read with mutually exclusive guarded clauses, one per row below (C17: the outcome is in the head).

| row | guard | RequirementId | Outcome | Pairs | CitationKey |
|-----|-------|---------------|---------|-------|-------------|
| C1 | adequacy attested true | art45_adequacy | met | [] | art_45_1 |
| C2 | adequacy not attested true; binding corporate rules attested true | art46_safeguards | met | [] | art_46_2_b |
| C3 | not C1 or C2; safeguard_in_place true | art46_safeguards | met | [] | art_46_1 |
| C4 | not C1 or C2; safeguard_in_place absent | art46_safeguards | open_by_absence([safeguard_in_place]) | [] | art_46_1 |
| C5 | adequacy absent; not C2; safeguard false or unsure | art46_safeguards | open_by_outside_fact(adequacy_decision_in_force) | [safeguard_in_place-V] | art_45_3 |
| C6 | adequacy false; not C2; safeguard unsure; stage three (claimed) is open_by_absence(K) | art46_safeguards | open_by_absence(K) | [] | art_46_1 |
| C7 | adequacy false; not C2; safeguard unsure; stage three not open_by_absence, or no claim | art46_safeguards | open_by_judgement(safeguard_in_place) | [safeguard_in_place-unsure] | art_46 |
| C8 | adequacy false; not C2; safeguard false; no claim | art49_derogation | unmet | [] | art_49_1 |
| C9 | adequacy false; not C2; safeguard false; claim Point | art49_derogation | the point outcome; for open_by_judgement the input is the first unsure key in root order | present judgements read | the derogation row, or the referral row of the input when open_by_judgement |

(All CitationKeys above are prefixed `eu_reg_2016_679_`.)

## 9 Slice: transfer.clausal (may the transfer take place)

Value facts it owns:

- The cross-reference pair: source `eu_reg_2016_679_art_45`, target `eu_reg_2016_679_art_45_3`, and resolution `not_attempted`.
- The verdict vocabulary (section 2).
- The recorded-only list of outside facts: keys 16, 18 and 19, plus 17 for listing.

Rules:

- **T1 input-first.** Problems give `input_problems(P)`.
- **T2 met maps to `eligible`. T3 unmet maps to `ineligible`.**
- **T4** `open_by_absence(K)` maps to `indeterminate(K)`.
- **T5** `open_by_outside_fact` maps to the cross_reference_unresolved review, whose Context is resolution first, then `inputs_relied_on(Pairs)`.
- **T6** `open_by_judgement(I)` maps to `needs_legal_review(open_textured(I, cite(C)), [inputs_relied_on(Pairs)])`.
- **T7 PAIRS.** Pairs are `derogation_claimed-Claim` if present, then `adequacy_decision_in_force-absent` if absent, then the JudgementPairs from the cascade.
- **T8** `transfer_outside_facts/2`, as in section 6.
- **T9** the legacy projections: `transfer_permitted/2`, `transfer_verdict/3`, `transfer_checklist/2`, `transfer_requirement/4`, `transfer_requirement_ids/1`, and `transfer_status/2`.
- **T10** `gdpr_chapter_v_transfers_what_if/4`.

Verdict atoms: section 2. It shares nothing new: it reads the kernel cascade and the input check.

Per-rule tests: one positive and one negative test per T row, over the fixtures, with counting checked by `findall` and `length(Answers, 1)`.

## 10 Slice: transfer_basis.clausal (on which basis)

Value facts it owns:

- **Stage rows:** `gdpr_chapter_v_transfers_stage(Order, RequirementId, Basis, DefaultCitationKey)`:
  - `(1, art45_adequacy, art45_adequacy, eu_reg_2016_679_art_45_1)`
  - `(2, art46_safeguards, art46_safeguards, eu_reg_2016_679_art_46_1)`
  - `(3, art49_derogation, art49_derogation, eu_reg_2016_679_art_49_1)`
- **Unmet reason atoms:** `adequacy_decision_not_in_force`, `safeguards_not_provided`, `no_derogation_claimed`, `derogation_not_made_out`.

Rules:

- **B1** The cascade outcome `met` at a stage gives that stage's Basis. Every other case gives `none`.
- **B2** `transfer_basis_status/2` is the cascade outcome, or `input_problems(P)`.
- **B3** `transfer_basis_checklist/2`.
  - It computes the prefix of the requirement ids up to the ending stage, then calls `eval_requirements(Prefix, Profile, gdpr_chapter_v_transfers_basis_requirement, Items)`.
  - Earlier stages are `unmet(adequacy_decision_not_in_force)` and `unmet(safeguards_not_provided)`, or `not_established` for stage one with the fact absent.
  - The ending stage carries the cascade status, cited with `cite(CitationKey)` from the cascade.
- **B4** `decide_transfer_basis/2` is the same as `transfer_basis/2`.

Verdict atoms: the basis atoms. It shares nothing new.

Per-rule tests: every basis, `none` for each non-final status, and every checklist item cited (`prop_citation_complete/3`).

## 11 Other layers

- `citations.clausal`: the section 4 rows `gdpr_chapter_v_transfers_citation(Key, Unit, Gloss)`.
- `parameters.clausal`: `fetcher(none)`, the arrival precedence `[attested, fetched]`, and the outside-fact declarations. It holds no statutory figure.
- `queries.clausal`: the section 6 surface re-exported.
- `fixtures.clausal`: section 12.
- The package facade exports everything in section 6 plus the result constructors.

## 12 Fixtures

The attestation helper is `attestation(fixture_host, fixture_time, fixture_reason, none)`. Below, adequacy is abbreviated A, safeguard_in_place S, and the claim D.

| # | profile | verdict | basis |
|---|---------|---------|-------|
| 1 | A=true | eligible | art45_adequacy |
| 2 | A=true, S=unsure | eligible | art45_adequacy |
| 3 | A=false, S=true | eligible | art46_safeguards |
| 4 | S=true (A absent) | eligible | art46_safeguards; outside facts `[outside_fact(adequacy_decision_in_force, absent)]` |
| 5 | A=false, S=false, binding corporate rules=true | eligible | art46_safeguards |
| 6 | binding corporate rules=true only | eligible | art46_safeguards |
| 7 | empty profile | indeterminate([safeguard_in_place]) | none |
| 8 | S=false, D=art49_1_b, contract_necessity=true (A absent) | needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_45), cite(eu_reg_2016_679_art_45_3)), [resolution(cite(eu_reg_2016_679_art_45_3), not_attempted), inputs_relied_on([derogation_claimed-art49_1_b, adequacy_decision_in_force-absent, safeguard_in_place-false])]) | none |
| 9 | A=false | indeterminate([safeguard_in_place]) | none |
| 10 | A=false, S=false | ineligible | none |
| 11 | A=false, S=false, D=art49_1_a, consent=true | eligible | art49_derogation |
| 12 | as 11 plus public authority=true | ineligible | none |
| 13 | A=false, S=false, D=art49_1_a | indeterminate([explicit_consent_obtained]) | none |
| 14 | A=false, S=false, D=art49_1_d, important_public_interest=unsure | needs_legal_review(open_textured(important_public_interest, cite(eu_reg_2016_679_art_49_1_d)), [inputs_relied_on([derogation_claimed-art49_1_d, important_public_interest-unsure])]) | none |
| 15 | A=false, S=false, D=art49_1_d, public authority=true, important_public_interest=true | eligible | art49_derogation |
| 16 | A=false, S=false, D=art49_1_g, the three register flags true, requester absent | eligible | art49_derogation |
| 17 | as 16 plus requester=false | ineligible | none |
| 18 | A=false, S=false, D=art49_1_g, public_by_law=false, not_entire absent | ineligible | none |
| 19 | A=false, S=false, D=second subparagraph, legitimate=true, important_public_interest=true | ineligible | none |
| 20 | A=false, S=false, D=second subparagraph, consent=false, contract=unsure, (c) to (f)=false, public_by_law=false, legitimate=true | needs_legal_review(open_textured(contract_necessity, cite(eu_reg_2016_679_art_49_1_b)), [inputs_relied_on([derogation_claimed-art49_1_second_subpara, contract_necessity-unsure, data_subject_interest_contract_necessity-false, important_public_interest-false, legal_claims_necessity-false, vital_interests_necessity-false, legitimate_interests_derogation-true])]) | none |
| 21 | as 20 with contract=false | eligible | art49_derogation |
| 22 | as 21 with consent absent | indeterminate([explicit_consent_obtained]) | none |
| 23 | A=false, S=unsure, D=art49_1_b, contract absent | indeterminate([contract_necessity]) | none |
| 24 | A=false, S=unsure, D=art49_1_b, contract=true | needs_legal_review(open_textured(safeguard_in_place, cite(eu_reg_2016_679_art_46)), [inputs_relied_on([derogation_claimed-art49_1_b, safeguard_in_place-unsure])]) | none |
| 25 | A=false, S=true, onward=true, both Art 48 facts=true | eligible | art46_safeguards; outside facts list adequacy plus the three present facts in root order |
| 26 | S given the atom yes | input_problems([wrong_type(safeguard_in_place)]) | none |
| 27 | [attribute(foo, 1), attribute(safeguard_in_place, true), attribute(safeguard_in_place, true)] | input_problems([duplicate_key(safeguard_in_place), unknown_key(foo)]) | none |
| 28 | the atom not_a_list | input_problems([wrong_type(profile)]) | none |
| 29 | binding corporate rules given the bare atom true | input_problems([wrong_type(binding_corporate_rules_approved)]) | none |
| 30 | A given attested(unsure, attestation(...)) | input_problems([wrong_type(adequacy_decision_in_force)]) | none |

## 13 Totality and determinism claims (checked by validate_props over the fixtures)

- Each public relation has one solution per fixture. This is checked by `findall` plus `length/2`.
- The input check has one solution for unbound terms, partial lists, unbound elements and unbound values.
- No query result contains the bare atoms `indeterminate` or `unknown`.
- Every needs_legal_review Reason carries a `cite(Key)` whose Key is in section 4.
- Keys a stage does not read never change the answer. This is checked by a what_if test: fixture 1 with every other key varied keeps `eligible`.
