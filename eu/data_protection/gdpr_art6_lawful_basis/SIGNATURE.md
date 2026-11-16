# SIGNATURE — eu/data_protection/gdpr_art6_lawful_basis

## Public query surface

The two called-contract queries are `lawful_basis_status(PROFILE, RESULT, BASIS, CITATIONS)` and `purpose_compatibility(PROFILE, RESULT, BASIS, CITATIONS)`. The input check is `gdpr_art6_lawful_basis_input_problems(PROFILE, PROBLEMS)`. The facade wraps the first query as `decide_gdpr_art6_lawful_basis(PROFILE, gdpr_art6_lawful_basis_verdict(STATUS, CITATIONS))` and `gdpr_art6_lawful_basis_status(PROFILE, STATUS)`.

PROFILE is an attribute list `[attribute(KEY, VALUE), ...]`, read only with `profile_get/3`.

- **Totality:** every query yields exactly ONE solution for every term, and the input check never fails or raises.
- **Determinism:** routes are disjoint clause heads with the ground verdict folded into the head (C17), with no `!`, `->` or `*->`. Answers are never deduplicated with `once/1` on a whole query.
- **Imported figures:** none. There are no numeric statutory figures; `parameters.clausal` stays an empty constants file with a comment saying so.

## Verdict STATUS atoms (replace the placeholders `required / permitted / not_applicable`)

- `lawful_basis_status/4` RESULT is exactly one of:
  - `eligible`;
  - `ineligible`;
  - `indeterminate([KEY])`;
  - `needs_legal_review(open_textured(KEY, cite(C)), [inputs_relied_on(PAIRS)])`;
  - `needs_legal_review(cross_reference_unresolved(cite(C), cite(T)), [resolution(cite(T), not_attempted), inputs_relied_on([KEY-absent])])`;
  - `input_problems(PROBLEMS)`.
- `purpose_compatibility/4` RESULT is exactly one of:
  - `purpose_compatible`;
  - `purpose_not_compatible`;
  - `compatibility_test_not_engaged`;
  - `indeterminate([KEY])`;
  - `needs_legal_review(open_textured(compatible_purpose, cite(eu_reg_2016_679_art_6_4)), [inputs_relied_on([new_purpose_processing-true, compatible_purpose-unsure])])`;
  - `input_problems(PROBLEMS)`.
- Rules for both:
  - The bare atom `indeterminate` is never written.
  - `true` and `false` are never verdict or root_exports atoms.
  - No result atom shares a name with a query.

## Profile keys (root_exports / input_contract order; fifteen)

| # | Key | Kind | Values |
|---|---|---|---|
| 1 | basis_claimed | enumeration | consent, contract, legal_obligation, vital_interests, public_interest_task, legitimate_interests |
| 2 | consent_given_and_conditions_met | outside fact | attested(true or false, attestation(By, At, Reason, Evidence)) |
| 3 | contract_necessary | judgement | true, false, unsure |
| 4 | legal_obligation_necessary | judgement | true, false, unsure |
| 5 | legal_obligation_laid_down_by_law | outside fact | attested(...) |
| 6 | vital_interests_necessary | judgement | true, false, unsure |
| 7 | public_interest_task_necessary | judgement | true, false, unsure |
| 8 | public_interest_task_laid_down_by_law | outside fact | attested(...) |
| 9 | processing_by_public_authority_in_its_tasks | crisp | true, false |
| 10 | legitimate_interests_pursued | judgement | true, false, unsure |
| 11 | interests_overridden | judgement | true, false, unsure |
| 12 | child_data_subject | outside fact | attested(...) |
| 13 | special_category | outside fact | attested(...) |
| 14 | new_purpose_processing | crisp | true, false |
| 15 | compatible_purpose | judgement | true, false, unsure |

There are no numeric keys and no dates; the order has no date argument. Evidence is `none`, `url(Url, RetrievedAt)` or `document(UploadIdentifier, Sha256)`, and is never inspected beyond the unbound-variable test.

## Citation-key atoms

All are canonical lexicon atoms from `_lexicon/citations.yaml`. They are never shortened and never invented.

| Atom | Provision |
|---|---|
| `eu_reg_2016_679_art_6_1` | Art 6(1) first words, at least one applies |
| `eu_reg_2016_679_art_6_1_a` | Art 6(1)(a) consent |
| `eu_reg_2016_679_art_6_1_b` | Art 6(1)(b) contract |
| `eu_reg_2016_679_art_6_1_c` | Art 6(1)(c) legal obligation |
| `eu_reg_2016_679_art_6_1_d` | Art 6(1)(d) vital interests |
| `eu_reg_2016_679_art_6_1_e` | Art 6(1)(e) public task |
| `eu_reg_2016_679_art_6_1_f` | Art 6(1)(f) legitimate interests; also the outside-fact citation of `child_data_subject` |
| `eu_reg_2016_679_art_6_1_second_subpara` | Art 6(1) last subparagraph, the public authority bar |
| `eu_reg_2016_679_art_6_3` | Art 6(3) first sentence, the law statements |
| `eu_reg_2016_679_art_6_4` | Art 6(4) compatibility |
| `eu_reg_2016_679_art_9_1` | Art 9(1), outside-fact citation of `special_category` only |

**Referral targets** (cite(TARGET) atoms, from the `outside_facts:` block): `consent_basis_statement`, `legal_obligation_law_statement`, `public_interest_task_law_statement`, `child_data_subject_statement`, `special_category_statement`.

The deferred units are recorded in the manifest's deferred set by pinned unit id and are never emitted in CITATIONS: Art 4(11), Art 6(2), Art 6(3)(a), Art 6(3)(b), Art 6(4)(a) to (e), Art 7(1) to (4) and Art 8(1) to (3).

## Public predicates

- `lawful_basis_status(Profile, Result, Basis, Citations)`: the Art 6(1) determination over the considered ways, by steps (0) to (6) of THE LIMBS. Cites `eu_reg_2016_679_art_6_1` plus the per-way citations.
- `purpose_compatibility(Profile, Result, Basis, Citations)`: the Art 6(4) test, by steps (0), (7), (8) and (9). Basis is always `[]`. Cites `eu_reg_2016_679_art_6_4`.
- `gdpr_art6_lawful_basis_input_problems(Profile, Problems)`: THE INPUT CHECK against the typed input_contract. It reports duplicate_key, then wrong_type in contract order, then unknown_key in first-occurrence order, or `[wrong_type(profile)]` alone. It always yields exactly one solution. No citation (it is a structural check).
- `decide_gdpr_art6_lawful_basis(Profile, Verdict)`: the facade. Verdict is `gdpr_art6_lawful_basis_verdict(Status, Citations)`, with Status and Citations exactly the RESULT and CITATIONS of `lawful_basis_status/4`. Cites as `lawful_basis_status/4`.
- `gdpr_art6_lawful_basis_status(Profile, Status)`: the facade. Status is the RESULT of `lawful_basis_status/4`, a scalar atom or a status compound and never a record. Cites `eu_reg_2016_679_art_6_1`.
- `gdpr_art6_lawful_basis_checklist(Profile, Checklist)`: the facade, for justification (#7). It returns one `item(WayIdentifier, Status, cite(Citation))` per CONSIDERED way, in way order a to f.
  - Status is `met` (the way holds), `unmet(way_fails)` (it fails) or `unknown(UnresolvedKeys)` (it is open).
  - Citation is the point citation of the way.
  - A profile with input problems gives `[]`.
  - Cites `eu_reg_2016_679_art_6_1_a` to `_f`.
- `gdpr_art6_lawful_basis_what_if(Profile, Key, Value, Status)`: the facade. It overrides one key with `profile_set/3`, then returns the status. It is implemented through `what_if/5` with the closure `gdpr_art6_lawful_basis_status`. Cites as `gdpr_art6_lawful_basis_status/2`.
- `gdpr_art6_lawful_basis_fixture(Name, Profile)` and `gdpr_art6_lawful_basis_fixture_expected(Name, Result, Basis, Citations)` (fixtures.clausal): named profiles with their expected answers.

## Result constructors (exported data terms, never called as queries)

- `provenance(Clause, Citations)`: an optional, unscored CONTEXT item of a `needs_legal_review/2` answer that may follow `inputs_relied_on(PAIRS)` in the CONTEXT list (never inside the PAIRS list); Clause names the deciding step of THE LIMBS and Citations is a list of `cite(Key)` terms for it. Cites `eu_reg_2016_679_art_6_1` (for `lawful_basis_status/4`) or `eu_reg_2016_679_art_6_4` (for `purpose_compatibility/4`).
- `inputs_relied_on(Pairs)`: the KEY-VALUE pairs of THE PAIRS RULE. Cites `eu_reg_2016_679_art_6_1`.
- `resolution(Target, not_attempted)`: the resolution item of THE ABSENT REFERRAL. Cites the outside-fact citation of the referred key (`eu_reg_2016_679_art_6_1_a` or `eu_reg_2016_679_art_6_3`).
- `open_textured(Key, Citation)` and `cross_reference_unresolved(Citation, Target)`: the two REASON forms of `needs_legal_review/2`. Cite the judgement citation of Key, or the outside-fact citation.
- `outside_fact(Key, Attested)` and `flagged(Key, Attested)`: the BASIS items. Cite the outside-fact citation of Key (`eu_reg_2016_679_art_6_1_a`, `eu_reg_2016_679_art_6_3`, `eu_reg_2016_679_art_6_1_f`, `eu_reg_2016_679_art_9_1`).
- `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `attested/2`, `attestation/4`, `url/2`, `document/2`: the remaining result constructors of the input contract. Cite `eu_reg_2016_679_art_6_1`.

## Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`;
  - `not_defeated/3` (the guarded `once/1` defeater, cut-free);
  - `not_member/2`, `memberd/2`;
  - the constructors `item/3`, `unknown/1`, `unmet/1`, `attribute/2`, and the vocabulary atom `met`.
- `kit/query_combinators`: `what_if/5` for the what-if facade.
- `validate_props` (tests only): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`.
- NOT used, because the domain needs none of them:
  - `check_tri/4`: the steps need the raw tri-state, not a met/unmet/unknown status, and the C15 lint forbids a clone, so the raw value is read with `profile_get/3` instead;
  - `assess/6`: the six-step precedence is not a flat checklist aggregation, so the verdict is computed by THE LIMBS and the checklist facade only reports the way states;
  - deadline, date, currency, country and ratio modules.

## Layout (unchanged): kernel -> citations -> parameters -> gdpr_art6_lawful_basis -> queries -> fixtures -> package facade

### kernel.clausal (shared floor)

Kernel holds only what more than one slice or layer needs.

**Contract table:**

- `gdpr_art6_lawful_basis_contract_key(Position, Key, Kind)`: fifteen facts in root_exports order. Kind is `judgement`, `crisp`, `outside_fact` or `enumeration`.
- `gdpr_art6_lawful_basis_enumeration_atom(basis_claimed, Atom)`: six facts.

**Type checks:**

- `gdpr_art6_lawful_basis_value_has_kind(Kind, Value)`. It must be nonvar-guarded.
  - judgement: `true`, `false` or `unsure`.
  - crisp: `true` or `false`.
  - enumeration: one of the six atoms.
  - outside fact: `attested(V, attestation(By, At, Reason, Evidence))` with V `true` or `false`, and each of the four arguments ground (`ground/1` covers both 'is' and 'holds' an unbound variable).

**Input check:** `gdpr_art6_lawful_basis_input_problems/2`, total.

- Profile-shape check first, via a proper-list walk that is safe on a variable, a partial list or an unbound element. Any failure gives `[wrong_type(profile)]`.
- Then the per-contract-key pass: duplicate_key, else wrong_type.
- Then unknown_key, deduplicated in first-occurrence order. A non-atom key is unknown_key as given.
- Written with findall and disjoint clauses only.

**Profile reading:**

- `gdpr_art6_lawful_basis_value_state(Profile, Key, State)`: State is `absent` or `present(Value)`. One solution; the input check runs first, so no key is duplicated.
- `gdpr_art6_lawful_basis_outside_fact_truth(Attested, Truth)`: extracts `true` or `false` from `attested/2` without touching the attestation.

**Referral builders:**

- `gdpr_art6_lawful_basis_absent_referral(Key, Result)`: builds THE ABSENT REFERRAL from the outside-fact table in citations.clausal.
- `gdpr_art6_lawful_basis_open_textured(Key, Citation, Pairs, Result)`.

### citations.clausal

- `gdpr_art6_lawful_basis_citation(Atom, Unit, Text)` for the eleven atoms above.
- `gdpr_art6_lawful_basis_outside_fact_entry(Key, Citation, Target, Referable)` for the five outside facts. Referable is `true` for consent_given_and_conditions_met, legal_obligation_laid_down_by_law and public_interest_task_laid_down_by_law, and `false` for child_data_subject and special_category.

### parameters.clausal

No statutory numeric figure exists in Art 6. The file keeps its module header and a comment recording that fact. Nothing is re-declared elsewhere.

### gdpr_art6_lawful_basis.clausal (the ONE determination slice)

**Statutory VALUE facts owned here (they live in this file):**

- `way(Way, BasisAtom)`, in way order:
  - `way(way_a, consent)`;
  - `way(way_b, contract)`;
  - `way(way_c, legal_obligation)`;
  - `way(way_d, vital_interests)`;
  - `way(way_e, public_interest_task)`;
  - `way(way_f, legitimate_interests)`.
- `way_requirement(Way, Key, NeededValue)`:
  - way_a: consent_given_and_conditions_met, attested true;
  - way_b: contract_necessary, true;
  - way_c: legal_obligation_necessary, true; legal_obligation_laid_down_by_law, attested true;
  - way_d: vital_interests_necessary, true;
  - way_e: public_interest_task_necessary, true; public_interest_task_laid_down_by_law, attested true;
  - way_f: processing_by_public_authority_in_its_tasks, false; legitimate_interests_pursued, true; interests_overridden, false.
- `way_point_citation(Way, Atom)`: a to f, giving `eu_reg_2016_679_art_6_1_a` to `_f`.
- `way_holds_extra_citation(Way, Atom)`:
  - way_c and way_e: `eu_reg_2016_679_art_6_3`;
  - way_f: `eu_reg_2016_679_art_6_1_second_subpara`.
- `way_fails_extra_citation(Way, TriggerKey, TriggerValue, Atom)`:
  - way_c: legal_obligation_laid_down_by_law attested false gives art_6_3;
  - way_e: public_interest_task_laid_down_by_law attested false gives art_6_3;
  - way_f: processing_by_public_authority_in_its_tasks true gives art_6_1_second_subpara.
- `judgement_citation(Key, Atom)`:
  - contract_necessary: `_b`;
  - legal_obligation_necessary: `_c`;
  - vital_interests_necessary: `_d`;
  - public_interest_task_necessary: `_e`;
  - legitimate_interests_pursued: `_f`;
  - interests_overridden: `_f`;
  - compatible_purpose: `eu_reg_2016_679_art_6_4`.

**Rules / requirements:**

- **R0 key status.** `key_standing(Profile, Way, Key, Standing)` gives `satisfied`, `contradicted`, `absent` or `unsure`, with one disjoint clause per standing. Outside facts compare only the extracted truth value.
- **R1 way state.** `way_state(Profile, Way, State)` gives `holds`, `fails` or `open(UnresolvedKeys)`. It is computed by findall over `way_requirement` in fixed order.
  - Defeasible form: WAY F holds `not_defeated(way_f, Profile, way_f_defeater)`, where `way_f_defeater` is processing_by_public_authority_in_its_tasks true (R7, Art 6(1) last subparagraph).
  - WAY C and WAY E holding are defeated by their law statement attested false (Art 6(3)).
  - Defeaters are guarded with `once/1` inside `not_defeated/3`, cut-free.
- **R2 considered ways.** `considered_ways(Profile, Ways)` gives `[W]` when basis_claimed names W, otherwise all six in order.
- **R3 summary.** A single deterministic `way_summary(Profile, Holding, Failing, Open)`, then the step selector.
- **Steps (head-folded, disjoint by guard):**
  - step 1: Holding is non-empty;
  - step 2: Holding and Open are empty;
  - step 3a/3b: one-step ways exist;
  - step 4: an absent judgement or crisp key exists among the unresolved keys;
  - step 5: an absent outside fact exists;
  - step 6: only unsure keys remain.
- **'First key' rule.** 'First' is always the minimum contract Position from the kernel table.
- **Citations.** `[cite(eu_reg_2016_679_art_6_1) | way citations]`, each atom once, merged via `sort/2` on cite terms.
- **BASIS.**
  - Step 1: `outside_fact(K, A)` for the outside facts of the holding ways, in Position order; then `flagged(child_data_subject, A)` (WAY F considered and holds, CH attested true); then `flagged(special_category, A)` (SC attested true).
  - Step 2: `outside_fact(K, A)` for the attested-false facts of considered ways.
  - Otherwise `[]`.
- **PAIRS for step 6.** The present keys among basis_claimed, the keys of the considered ways, and child_data_subject when WAY F is considered, in Position order, as `Key-Value`.
- **Provenance.** A `provenance(Clause, Citations)` item may follow `inputs_relied_on(PAIRS)` in the CONTEXT of a `needs_legal_review/2` answer; it is unscored and never inside PAIRS.
- **R10.** `purpose_compatibility/4` reads only new_purpose_processing and compatible_purpose, with seven disjoint routes:
  - input problems;
  - new_purpose_processing false;
  - new_purpose_processing absent;
  - new_purpose_processing true with compatible_purpose true, false, absent or unsure.
- **Open texture.** Necessity, the (f) balance and compatibility are never computed. They are always taken from the caller.

**Verdict atoms:**

- `eligible`, `ineligible`, `purpose_compatible`, `purpose_not_compatible`, `compatibility_test_not_engaged`;
- the status compounds `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`.

**Shared with another slice:** nothing beyond the kernel predicates listed above. They are the contract table, the value-kind check, the input check, value_state, outside_fact_truth and the referral builders. They are kernel-resident because `queries.clausal` and the facade also call them.

### queries.clausal

- Re-exports `lawful_basis_status/4` and `purpose_compatibility/4`.
- Defines `gdpr_art6_lawful_basis_status/2`, `decide_gdpr_art6_lawful_basis/2`, `gdpr_art6_lawful_basis_checklist/2` and `gdpr_art6_lawful_basis_what_if/4`.
- No new logic.

### fixtures.clausal (and the seven test modes)

Named profiles with their expected `(Result, Basis, Citations)`, at least one per route:

- consent-only eligible, with the attestation copied;
- (c) holding with both citations;
- (f) holding with the child and special-category flags;
- (f) failing on the public authority, citing the second subparagraph;
- claimed contract false gives ineligible;
- all-fail ineligible with the attested-false law statements in BASIS;
- step 3a, e.g. only contract_necessary missing;
- step 3b, the consent statement absent while another judgement is missing;
- step 4 with an unsure judgement present;
- step 5;
- step 6, with PAIRS including child_data_subject;
- input problems: duplicate, wrong_type for a bare outside fact, an attested judgement, an unbound attestation argument, unknown_key for a non-atom key, `[wrong_type(profile)]` for a partial list;
- the Art 6(4) routes: not engaged, NP absent, compatible, not compatible, CP absent, CP unsure.

Every `fail` test is paired with a positive test over the same case. The counting tests use `findall` + `length(.., 1)`.
