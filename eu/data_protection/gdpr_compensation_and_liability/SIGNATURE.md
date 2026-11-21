# SIGNATURE — eu/data_protection/gdpr_compensation_and_liability

## Public query surface

- Main answer: `decide_gdpr_compensation_and_liability(Profile, gdpr_compensation_and_liability_verdict(Status, Citations))`.
- Status only: `gdpr_compensation_and_liability_status(Profile, Status)`.
- Full answer with basis: `gdpr_compensation_and_liability_compensation_liability(Profile, Result, Basis, Citations)`.
- PROFILE is an attribute list `[attribute(Key, Value), ...]`, read only with `profile_get/3` and its siblings.

### Claims

- **Totality.** Every term given to the input check yields exactly one PROBLEMS list. Every combination of the eight keys (each absent or with any typed value) is decided by exactly one step of the ladder.
- **Determinism.** Exactly one RESULT per profile. Guards are disjoint, with no cut and no if-then-else.
- **No imported figures.** There are no statutory numbers, so parameters.clausal holds no `constant_value` and nothing is re-declared.

## Verdict STATUS atoms (replace the placeholders `required`, `permitted` and `not_applicable`)

### Final results (bare atoms)

| Status | Meaning | Eligibility mapping (#2) |
|---|---|---|
| `liable_for_damage` | Article 82(1) to (3): the caller must compensate. | eligible (the right to compensation from the caller holds) |
| `exempt_from_liability` | Article 82(3), attested true. | ineligible |
| `not_liable_for_damage` | Article 82(2) leaves the caller out. | ineligible |
| `right_not_established` | A condition of Article 82(1) is false. | ineligible |

### Non-final results (compounds; never the bare atom `indeterminate`)

All three map to indeterminate for eligibility (#2).

- `input_problems(Problems)`. Problems is a list of `duplicate_key(Key)`, `wrong_type(Key)` and `unknown_key(Key)`, or `[wrong_type(profile)]`.
- `indeterminate([Key])`. One key only, per the ruling.
- `needs_legal_review(Reason, Context)`. Reason is one of:
  - `open_textured(Key, cite(eu_reg_2016_679_art_82_1))`, with Context `[inputs_relied_on(Pairs)]`;
  - `cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement))`, with Context `[resolution(cite(non_responsibility_statement), not_attempted), inputs_relied_on(Pairs)]`.

### Result constructors

These are exported and never called as queries: `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `resolution/2`, `inputs_relied_on/1`, `provenance/2`, `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`, and the verdict wrapper `gdpr_compensation_and_liability_verdict/2`.

## Profile keys (exactly eight, in root_exports / input_contract order)

| # | Key | Class | Values |
|---|---|---|---|
| 1 | `party_role` | enumerated | `controller` \| `processor` |
| 2 | `involved_in_the_processing` | crisp | `true` \| `false` |
| 3 | `processor_breached_obligations_directed_to_processors` | crisp | `true` \| `false` |
| 4 | `processor_acted_outside_or_contrary_to_lawful_instructions` | crisp | `true` \| `false` |
| 5 | `damage_suffered` | judgement (tri-state) | `true` \| `false` \| `unsure` |
| 6 | `infringement_of_the_regulation_occurred` | judgement (tri-state) | `true` \| `false` \| `unsure` |
| 7 | `damage_resulted_from_the_infringement` | judgement (tri-state) | `true` \| `false` \| `unsure` |
| 8 | `not_in_any_way_responsible_for_the_event` | outside fact | `attested(true\|false, attestation(By, At, Reason, Evidence))` |

- There are no numeric keys and no date keys.
- Evidence is `url(Url, RetrievedAt)`, `document(UploadId, Sha256)` or `none`, and is not inspected.
- Booleans are atoms, never strings.

### outside_facts: entry

- key: `not_in_any_way_responsible_for_the_event`
- citation: `eu_reg_2016_679_art_82_3`
- target: `non_responsibility_statement`
- kinds: `[attested, fetched]`
- fetcher: `none`

## Citation-key atoms (canonical lexicon scheme, `_lexicon/citations.yaml`)

### Load-bearing (may appear in CITATIONS)

- `eu_reg_2016_679_art_82_1`: Article 82(1), the right to compensation and its three conditions.
- `eu_reg_2016_679_art_82_2`: Article 82(2), the controller and processor liability limbs.
- `eu_reg_2016_679_art_82_3`: Article 82(3), the exemption.
- `non_responsibility_statement`: the target of the outside fact. It appears only inside `cross_reference_unresolved` and `resolution`.

### Deferred (citations.clausal only; never emitted)

These carry the verbatim text for the deferral record:

- `eu_reg_2016_679_art_82_4`
- `eu_reg_2016_679_art_82_5`
- `eu_reg_2016_679_art_82_6`

No shortened atom is ever invented. CITATIONS is a set-like list: each atom appears once, and the order is not scored.

## Public predicates

- `decide_gdpr_compensation_and_liability(Profile, Verdict)`: Verdict is `gdpr_compensation_and_liability_verdict(Result, Citations)`, from the step ladder. Citations: Article 82(1) to (3).
- `gdpr_compensation_and_liability_status(Profile, Status)`: Status is the RESULT term of the ladder (final atom or non-final compound). Citations: Article 82(1) to (3).
- `gdpr_compensation_and_liability_checklist(Profile, Checklist)`: the justification checklist (#7).
  - Checklist is `[item(RequirementId, Status, cite(Key)), ...]` over the requirements of the slice, built with `eval_requirements/4`.
  - Every item carries `cite(...)`, met items included.
  - Citations: Article 82(1), Article 82(2) and Article 82(3).
- `gdpr_compensation_and_liability_what_if(Profile, Key, Value, Result)`: the RESULT after overriding Key with Value, using `profile_set/3` and then the ladder. Citations: as for the ladder.
- `gdpr_compensation_and_liability_compensation_liability(Profile, Result, Basis, Citations)`: the full step ladder 0 to 11. Citations: Article 82(1), (2) and (3).
- `gdpr_compensation_and_liability_input_problems(Profile, Problems)`: the input check. It gives exactly one solution, never fails and never raises (INTERFACE - THE INPUT CHECK).
- `gdpr_compensation_and_liability_fixture(Name, Profile, ExpectedResult)`: fixtures, at least one per step 0 to 11, plus the Q8 and Q9 edge cases and the input-check edge cases.
- `gdpr_compensation_and_liability_requirement(RequirementId, Profile, Status, Citation)`: the requirement closure for `eval_requirements/4`, with RequirementId FIRST.

## Planned reuse (manifest `uses:`)

### formalize_lib

Import by name and arity: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `check_tri/4`, `eval_requirements/4`, `item/3`, `unmet/1`, `unknown/1`, `attribute/2`.

- `check_tri/4` is used for the judgement checklist items. If its vocabulary does not cover the atom `unsure`, write a local three-clause mapping with `% lint: C15 tri-state includes unsure atom`.

### kit/query_combinators

`what_if/5`, with the closure `gdpr_compensation_and_liability_status`, so the kit supplies `(Profile, Result)`.

### validate_props (tests)

`run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `declare_vacuous/1`.

- `prop_boundary_coverage` and `prop_monotone` are declared vacuous, because there is no numeric axis.

### Not used

deadline_lib, rolling_window, date_time, currency_vocab, vat_category and compliance_lib. There are no dates, money or plans.

## kernel.clausal — the shared floor

Only predicates shared between the slice, queries and facade go here:

- `gdpr_compensation_and_liability_contract_key(Key)`: the eight keys in order.
- `gdpr_compensation_and_liability_judgement_key(Key)`: the three judgement keys in order.
- The value-type facts.
- `gdpr_compensation_and_liability_input_problems/2`, because the queries and the facade call it first.

### Input check rules

- An unbound or partial list, or a non-`attribute/2` element, gives `[wrong_type(profile)]` alone.
- Problems are listed in this order:
  - for each contract key in contract order, `duplicate_key(Key)` (values not read), else `wrong_type(Key)`;
  - then `unknown_key(Key)`, in order of first occurrence. A non-atom key is unknown, kept as given.
- An unbound value, or an attestation argument that is or holds a variable, gives `wrong_type(Key)`.
- Implementation: guarded with `var/1` and `nonvar/1` tests in disjoint clauses, with no cut.

## parameters.clausal

No statutory figures (Q1: no seriousness threshold). The file is kept, holding only a comment stating this.

## Slice: gdpr_compensation_and_liability.clausal

### VALUE facts it owns

- Role vocabulary: `party_role_value(controller)` and `party_role_value(processor)`.
- Judgement order for 'first absent' and 'first unsure': `damage_suffered`, `infringement_of_the_regulation_occurred`, `damage_resulted_from_the_infringement`.
- There are no thresholds, periods or tables.

### Requirements (checklist rows; `RequirementId -> cite`)

- `damage_suffered -> eu_reg_2016_679_art_82_1`. `true` is met, `false` is `unmet(judgement_false)`, `unsure` or absent is `unknown([damage_suffered])`.
- `infringement_of_the_regulation_occurred -> eu_reg_2016_679_art_82_1`. Same mapping.
- `damage_resulted_from_the_infringement -> eu_reg_2016_679_art_82_1`. Same mapping.
- `liability_limb_met -> eu_reg_2016_679_art_82_2`.
  - met when the caller is INSIDE Article 82(2);
  - `unmet(outside_article_82_2)` when the caller is OUTSIDE;
  - `unknown([FirstMissingLimbKey])` when the position is UNDECIDED.
- `not_exempt -> eu_reg_2016_679_art_82_3`.
  - met when attested `false`;
  - `unmet(attested_not_responsible)` when attested `true`;
  - `unknown([not_in_any_way_responsible_for_the_event])` when absent.

The checklist explains the answer. The verdict comes from the ladder, never from aggregating the checklist.

### Caller position: `caller_position(Profile, Position)`

One clause per route. Position is one of three values:

- **`outside`:** controller and `involved_in_the_processing` is `false`; or processor and both processor keys are present and `false`.
- **`inside`:** controller and `involved_in_the_processing` is `true`; or processor and at least one processor key is `true` (one clause per key; a duplicate witness is allowed).
- **`undecided`:** `party_role` is absent; or controller and `involved_in_the_processing` is absent; or processor with no processor key `true` and one of the two absent.

### Step ladder: `compensation_liability/4`

Each step has a disjoint guard. The constant result is folded into the head (C17).

| Step | Guard | Result | Basis | Citations |
|---|---|---|---|---|
| 0 | Problems non-empty | `input_problems(Problems)` | `[]` | `[]` |
| 1 | `damage_suffered` is `false` | `right_not_established` | `[]` | `[cite(eu_reg_2016_679_art_82_1)]` |
| 2 | `damage_suffered` is not `false`; `infringement_of_the_regulation_occurred` is `false` | `right_not_established` | `[]` | `[cite(eu_reg_2016_679_art_82_1)]` |
| 3 | No earlier judgement is `false`; `damage_resulted_from_the_infringement` is `false` | `right_not_established` | `[]` | `[cite(eu_reg_2016_679_art_82_1)]` |
| 4 | No judgement is `false`; one is absent | `indeterminate([FirstAbsentJudgement])` | `[]` | `[]` |
| 5 | All judgements are `true` or `unsure`; position `undecided` | `indeterminate([FirstMissingLimbKey])` | `[]` | `[]` |
| 6 | Position `outside`; all three judgements `true` | `not_liable_for_damage` | `[]` | `[cite(eu_reg_2016_679_art_82_2)]` |
| 7 | Position `outside`; a judgement `unsure` | `needs_legal_review(open_textured(FirstUnsure, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on(Pairs3)])` | `[]` | `[]` |
| 8 | Position `inside`; outside fact absent | `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), [resolution(cite(non_responsibility_statement), not_attempted), inputs_relied_on(Pairs4)])` | `[]` | `[]` |
| 9 | Position `inside`; outside fact present; a judgement `unsure` | `needs_legal_review(open_textured(FirstUnsure, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on(Pairs3)])` | `[]` | `[]` |
| 10 | Position `inside`; all `true`; `attested(true, A)` | `exempt_from_liability` | `[outside_fact(not_in_any_way_responsible_for_the_event, attested(true, A))]` | `[cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]` |
| 11 | Position `inside`; all `true`; `attested(false, A)` | `liable_for_damage` | `[outside_fact(not_in_any_way_responsible_for_the_event, attested(false, A))]` | `[cite(eu_reg_2016_679_art_82_1), cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]` |

Step details:

- **Step 0.** This is the only step for a malformed profile. Steps 1 to 11 run only when Problems is `[]`, so `profile_get/3` never sees duplicate keys.
- **Steps 1 to 3.** The other keys may be absent, unsure, false or of any role. The caller may be outside Article 82(2) (Q8).
- **Step 4.** One exclusive clause per first absent key, in judgement order.
- **Step 5.** The first missing key is `party_role`. Then, only for a controller, `involved_in_the_processing`. Then, only for a processor with no processor key `true`, `processor_breached_obligations_directed_to_processors` and then `processor_acted_outside_or_contrary_to_lawful_instructions`. Keys of the other role are never named.
- **Step 7.** The outside fact is never read here.
- **Step 8.** The outside fact is never named in MISSING_KEYS.

### PAIRS rule

- **Pairs3:** `[damage_suffered-V1, infringement_of_the_regulation_occurred-V2, damage_resulted_from_the_infringement-V3]`. Each V is `true` or `unsure`, and at least one is `unsure`.
- **Pairs4:** Pairs3 extended with `not_in_any_way_responsible_for_the_event-absent` last. Here the values may all be `true`.

### Verdict atoms produced by this slice

- Final: `liable_for_damage`, `exempt_from_liability`, `not_liable_for_damage`, `right_not_established`.
- Non-final: `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`.

### Shared with another slice

None beyond kernel.clausal (the contract key order, the judgement key order and `input_problems/2`). This is the only determination slice.

### Per-rule tests (seven modes)

1. **load:** the package loads.
2. **unit:** one positive test per step 0 to 11, each paired with a negative test over the same case.
3. **fixtures:** every fixture yields its expected result.
4. **properties:** totality, determinism, citation completeness and missing-key coverage over all key combinations.
5. **input check:** duplicates, wrong types, unknown and non-atom keys, unbound profile, partial list, unbound value, and attestation holding a variable.
6. **what-if:** supplying the named missing key changes the answer only through that key.
7. **edge readings:** the Q8 outside caller with a false judgement gives `right_not_established`; the outside caller with `unsure` gives `open_textured` whatever the outside fact is; a processor with one key `true` and the other absent is inside.
