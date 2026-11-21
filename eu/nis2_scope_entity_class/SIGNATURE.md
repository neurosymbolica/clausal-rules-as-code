# SIGNATURE — eu/nis2_scope_entity_class

## Public query surface

The eligibility facade wraps the class determination:

```
decide_nis2_scope_entity_class(Profile, nis2_scope_entity_class_verdict(Status, Citations))
```

- `Status` is the CLASS of `entity_class/3`.
- `Citations` is its set-like list of `cite(KEY)`.

`nis2_scope_entity_class_status(Profile, Status)` projects `Status` alone.

The three determination queries are exported beside the facade:

- `size_class/3`
- `scope_decision/3`
- `entity_class/3`

### Totality and determinism

Every public predicate yields EXACTLY ONE solution for every ground profile.

- Results are built from `findall`-collected sets and a deterministic final selection.
- There are no cuts and no if-then-else.
- Clauses are disjoint, and ground verdicts are folded into clause heads (C17).
- A correct answer yielded twice is a refutation. Fixtures assert `length(Solutions, 1)`.

### Figures

- All statutory figures are integers, declared once by `constant_value/2` in the slice.
- No figure is imported from another domain. The Recommendation 2003/361/EC ceilings are quoted from the raw pin 32003H0361.

## Verdict STATUS atoms (replace placeholder eligible/ineligible)

### Final statuses

- `essential_entity` — the eligible-positive, strongest class.
- `important_entity` — the eligible-positive default class.
- `out_of_scope` — the ineligible answer.

The scope-level statuses are `in_scope` and `out_of_scope`. The size-level statuses are:

- `microenterprise`
- `small_enterprise`
- `medium_sized_enterprise`
- `large_enterprise`

### Non-final status compounds (exactly one, standing alone)

- `input_problems(Problems)`
- `indeterminate([Key])` — the bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])`
  - `Pairs` is a list of `Key-Value` pairs.
  - An optional unscored `provenance(Clause, Citations)` may follow.

Every status compound carries `Citations = []`.

### Result constructors (exported, never queried)

- `indeterminate/1`
- `needs_legal_review/2`
- `open_textured/2`
- `inputs_relied_on/1`
- `provenance/2`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`

## Profile keys (root_exports and input_contract order; read only with profile_get/3)

The profile is `[attribute(Key, Value), ...]`.

**Types.**

- **Judgement** keys take `true`, `false` or `unsure`.
- **Crisp** keys take `true` or `false`.
- **Integer** keys take a non-negative integer.

**Unit note.** The contract fixes the money keys as integer WHOLE EUROS (`_eur`), not cents. All ceilings are therefore declared in whole euros, so there is no unit mismatch.

| Order | Key | Type |
|---|---|---|
| 1 | `annex_i_type` | judgement |
| 2 | `annex_ii_type` | judgement |
| 3 | `services_or_activities_in_union` | crisp |
| 4 | `staff_headcount` | non-negative integer, persons |
| 5 | `annual_turnover_eur` | non-negative integer, whole euros |
| 6 | `annual_balance_sheet_total_eur` | non-negative integer, whole euros |
| 7 | `public_electronic_communications_provider` | crisp |
| 8 | `trust_service_provider_status` | enumeration: `not_a_trust_service_provider`, `non_qualified_trust_service_provider`, `qualified_trust_service_provider` |
| 9 | `tld_name_registry` | crisp |
| 10 | `dns_service_provider` | crisp |
| 11 | `sole_provider_of_an_essential_service_in_a_member_state` | judgement |
| 12 | `disruption_could_significantly_impact_public_safety_security_or_health` | judgement |
| 13 | `disruption_could_induce_a_significant_systemic_risk` | judgement |
| 14 | `critical_by_specific_national_or_regional_importance` | judgement |
| 15 | `public_administration_kind` | enumeration: `not_public_administration`, `central_government`, `regional_with_risk_assessed_services`, `other_public_administration` |
| 16 | `public_administration_in_national_security_defence_or_law_enforcement` | crisp |
| 17 | `critical_entity_under_directive_2022_2557` | crisp |
| 18 | `domain_name_registration_service_entity` | crisp |
| 19 | `exempted_from_dora_scope_by_member_state` | crisp |
| 20 | `identified_by_member_state_as_essential_entity` | crisp |
| 21 | `former_operator_of_essential_services_kept_essential_by_member_state` | crisp |

No dates are read, so no `date/3` term is used.

## Citation-key atoms (canonical lexicon scheme, _lexicon/citations.yaml; never shortened)

- `eu_dir_2022_2555_art_2_1`
- `eu_dir_2022_2555_art_2_2`
- `eu_dir_2022_2555_art_2_2_a_i`
- `eu_dir_2022_2555_art_2_2_a_ii`
- `eu_dir_2022_2555_art_2_2_a_iii`
- `eu_dir_2022_2555_art_2_2_b`
- `eu_dir_2022_2555_art_2_2_c`
- `eu_dir_2022_2555_art_2_2_d`
- `eu_dir_2022_2555_art_2_2_e`
- `eu_dir_2022_2555_art_2_2_f_i`
- `eu_dir_2022_2555_art_2_2_f_ii`
- `eu_dir_2022_2555_art_2_3`
- `eu_dir_2022_2555_art_2_4`
- `eu_dir_2022_2555_art_2_7`
- `eu_dir_2022_2555_art_2_9`
- `eu_dir_2022_2555_art_2_10`
- `eu_dir_2022_2555_art_3_1_a`
- `eu_dir_2022_2555_art_3_1_b`
- `eu_dir_2022_2555_art_3_1_c`
- `eu_dir_2022_2555_art_3_1_d`
- `eu_dir_2022_2555_art_3_1_e`
- `eu_dir_2022_2555_art_3_1_f`
- `eu_dir_2022_2555_art_3_1_g`
- `eu_dir_2022_2555_art_3_2`

citations.clausal declares them as `citation_vocabulary` facts, each with its pinned unit identifier (for example, `32022L2555#point_002.002_a_i`). No key names an Annex unit or Recommendation 2003/361/EC.

## Public predicates (one line each)

- `size_class(Profile, Size, Citations)`: the size category by the size answer rule under THE PARTIAL RULE, reading staff_headcount, annual_turnover_eur and annual_balance_sheet_total_eur only. Settled answers cite `[cite(eu_dir_2022_2555_art_2_1)]`. It never refers. Citation: Directive (EU) 2022/2555 Art 2(1) with Rec 2003/361/EC Annex Art 2.
- `scope_decision(Profile, Result, Citations)`: in_scope, out_of_scope or a status, from the exclusion stage X1 and X2 and then the scope stage G1 to G13, under THE PARTIAL RULE. Citations by steps (4) to (6). Citation: Art 2(1) to (4), (7), (9), (10).
- `entity_class(Profile, Class, Citations)`: essential_entity, important_entity, out_of_scope or a status. It applies the scope answer rule first, then the class stage E1 to E9, defaulting to important_entity. Citations by step (11). Citation: Art 3(1)(a) to (g), Art 3(2).
- `nis2_scope_entity_class_input_problems(Profile, Problems)`: the bare ordered problems list, `[]` when well-formed. It lists `duplicate_key/1` or `wrong_type/1` per contract key in contract order, then `unknown_key/1` in first-occurrence order. A non-attribute-list profile gives `[wrong_type(profile)]`. Citation: input_contract (no statutory cite).
- `decide_nis2_scope_entity_class(Profile, Verdict)`: `Verdict = nis2_scope_entity_class_verdict(Class, Citations)` from `entity_class/3`. This is query type #2, eligibility. Citation: Art 2 and Art 3.
- `nis2_scope_entity_class_status(Profile, Status)`: the `Class` of the facade verdict alone. Citation: Art 2 and Art 3.
- `nis2_scope_entity_class_checklist(Profile, Checklist)`: query type #7, justification.
  - `Checklist` is the ordered list of `item(GroundId, ItemStatus, cite(Key))`, one per ground: `x1, x2, g1 ... g13, e1 ... e9`.
  - `ItemStatus` is one of:
    - `met`;
    - `unmet(no_disjunct_met)` or `unmet(some_conjunct_unmet)`;
    - `unknown(Keys)`, where `Keys` are the absent or unsure keys of the ground's tests in root_exports order.
  - Every item, met ones included, carries its cite. X1 carries `cite(eu_dir_2022_2555_art_2_7)`, with 2_9 noted in provenance.
  - Citation: per ground, as listed.
- `nis2_scope_entity_class_what_if(Profile, Key, Value, Verdict)`: overrides one key and returns the facade verdict for the changed profile. It calls kit `what_if/5` with the closure `decide_nis2_scope_entity_class`. Citation: as the facade.
- **Fixtures** (fixtures.clausal): `nis2_scope_entity_class_fixture(Name, Profile)` and `nis2_scope_entity_class_expected(Name, Query, Answer, Citations)`. Each named case comes with the exact single answer of each query.

## Planned reuse (manifest `uses:`)

- **formalize_lib**:
  - `profile_get/3`, `profile_has/2`, `profile_keys/2` — presence first, then value;
  - `memberd/2`, `not_member/2`;
  - `item/3`, `unmet/1`, `unknown/1`, `attribute/2` — constructors;
  - `eval_requirements/4` — for the checklist, with the slice's `requirement/4` closure `nis2_scope_entity_class_requirement`, argument order (RequirementId, Profile, Status, Citation);
  - vocabulary atoms `met`, `no_disjunct_met`, `some_conjunct_unmet`.
  - `check_tri/4` is NOT used for the verdict, because the tri-state there is not the completion semantics. The checklist may use `check_tri/4` for judgement items.
- **kit/query_combinators**: `what_if/5` for `nis2_scope_entity_class_what_if/4`.
- **validate_props** (tests only): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- **currency_vocab**: the atom `eur` in the unit metadata of the figure keys only.
- **Not used**: date_time, deadline_lib, rolling_window, compliance_lib. No dates, deadlines or norms of conduct are read.
- **Local, flagged for the kit** (NOTES S4): the ladder partial-evaluation engine. It covers decision-tree completion, can-change, gating, settled citations and referral selection.

## Layout (unchanged)

The chain is kernel -> citations -> parameters -> nis2_scope_entity_class -> queries -> fixtures -> package facade. File and module names are kept.

- **kernel.clausal** (shared floor): the typed contract table only.
  - `nis2_scope_entity_class_contract_key(Order, Key, Type)`, with `Type` one of `judgement`, `crisp`, `non_negative_integer` or `enumeration(Atoms)`.
  - `nis2_scope_entity_class_root_export_order/1`, the list of the twenty-one keys.
  - These are shared by the slice (input check, PAIRS, candidate ordering), queries.clausal (facade) and fixtures/tests (generators). Nothing else lives here.
- **citations.clausal**: the 24 `citation_vocabulary` facts above.
- **parameters.clausal**: holds no figures. The ceilings are owned by the slice. It keeps its scaffold module with a comment pointing to the slice.
- **queries.clausal**: the facade, status, checklist and what_if, delegating to the slice.
- **fixtures.clausal**: the named cases.
- **Package facade**: re-exports the public predicates and result constructors.

## Slice: nis2_scope_entity_class.clausal

### Statutory VALUE facts owned here (integers, `:- constant_value/2`, read with `constant(Name)`)

Ceilings from Recommendation 2003/361/EC Annex Art 2, quoted from raw pin 32003H0361:

| Constant | Value | Comparison |
|---|---|---|
| `medium_sized_staff_ceiling_persons` | 250 | strict: below |
| `medium_sized_turnover_ceiling_eur` | 50000000 | inclusive: at most |
| `medium_sized_balance_sheet_ceiling_eur` | 43000000 | inclusive |
| `small_staff_ceiling_persons` | 50 | strict |
| `small_financial_ceiling_eur` | 10000000 | inclusive, both figures |
| `micro_staff_ceiling_persons` | 10 | strict |
| `micro_financial_ceiling_eur` | 2000000 | inclusive, both figures |

Band tables, derived from the constants, never re-inlined:

- `staff_band/2` with the bands `below_ten`, `ten_to_forty_nine`, `fifty_to_two_hundred_forty_nine`, `two_hundred_fifty_or_more`.
- `turnover_band/2` with the bands `up_to_micro`, `up_to_small`, `up_to_medium`, `above_medium`.
- `balance_sheet_band/2` with the same band names, on the 43000000 ceiling.

Ground tables, as facts:

- `exclusion_ground(Id, Tests, Cites)` for x1 and x2.
- `scope_ground(Id, Tests, Cites)` for g1 to g13.
- `class_ground(Id, Tests, Cites)` for e1 to e9.
- The test forms are `key_true(Key)`, `key_is(Key, Atom)`, `key_is_not(Key, Atom)`, `annex_type`, `at_least_medium`, `exceeds_medium` and `medium_sized`.

Referral citation tables:

- `scope_referral_citation(JudgementKey, CiteKey)`.
- `class_referral_fallback_citation(annex_i_type, eu_dir_2022_2555_art_3_1_a)`.
- `class_referral_fallback_citation(annex_ii_type, eu_dir_2022_2555_art_3_1_e)`.

### Rules and requirements

1. **Input check.** `nis2_scope_entity_class_input_problems/2`, as in the public line. It reads no values of duplicate keys.
2. **Size answer rule** s1 to s5 on bands: `size_of_bands(StaffBand, TurnoverBand, BalanceSheetBand, Size)`. The clauses are disjoint, one per route.
3. **Complete-profile answer rules.** These are the scope rule (exclusions, then G1 to G13, else out_of_scope) and the class rule (scope first, then E1 to E9, else important_entity). Each leaf records its deciding ground id.
4. **Decision tree of completions.** The ladder is walked in table order. On a test whose key is absent or unsure, it branches over that key's domain:
   - a figure key branches over its band;
   - a judgement branches over true and false;
   - an enumeration branches over its atoms.

   The walk stops at the first TRUE ground. Each leaf is `leaf(Assignment, Result, GroundId)`, with Assignment the list of `Key-Value` pairs chosen. The query fixes which keys may branch: size reads three, scope reads nineteen, class reads all twenty-one.
5. **Settled.** All leaves have one Result. The citations are:
   - the cites of the first ground TRUE IN PROFILE AS GIVEN, where a size test is true when it holds for every band of the absent figures;
   - else the union of the leaves' ground cites, for in_scope and essential_entity;
   - else the negative answer's cites (scope step (5), size `art_2_1`, class `art_3_2`).
6. **Can change.** An absent or unsure key K can change the result when two leaves with different Results assign K different values and agree on every other key both assign.
7. **Behind and gated.** K is behind K2 when some value of K2 makes K unable to change the result within the leaves compatible with that value. K is gated when it is behind a K2 that is not behind it. This is tested pairwise.
8. **Missing.** The answer is `indeterminate([K])` for the first non-gated absent candidate in root_exports order, or the first candidate when all are gated.
9. **Unsure.** Otherwise the answer is `needs_legal_review` for the first unsure judgement in root_exports order that can change the result.
   - Its CITE comes from the referral tables. For entity_class, an Annex key cites Art 2(1) when it can change the scope_decision result for the same profile.
   - PAIRS follow THE PAIRS RULE: all six judgement keys present for an Article 2 cite, only the two Annex keys for an Article 3 cite.
10. **Checklist requirement.** `nis2_scope_entity_class_requirement(GroundId, Profile, Status, Citation)` has three disjoint clauses per ground: met, unmet or unknown.
11. **Exactly once.** Every exported query collects with findall and selects deterministically.

### Verdict atoms

- Size: `microenterprise`, `small_enterprise`, `medium_sized_enterprise`, `large_enterprise`.
- Scope: `in_scope`, `out_of_scope`.
- Class: `essential_entity`, `important_entity`, `out_of_scope`.
- Status compounds: `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`.

### Shared with another slice

There is no other determination slice. The only cross-file predicates are the kernel's contract table and key order, which this slice consumes. Nothing in this slice is moved to the kernel.

### Tests (per-rule, in tests/)

- **Boundaries:** 9 and 10, 49 and 50, 249 and 250 persons; 2000000 and 2000001, 10000000 and 10000001, 50000000 and 50000001, 43000000 and 43000001 euros.
- **Each ground** G1 to G13, E1 to E9, X1 and X2, with X1 disapplied for a trust service provider.
- **Settled while a key is absent:** turnover above 50000000 with balance sheet above 43000000 gives large whatever the headcount.
- **Gated keys never named;** a key named before a referral (Q11).
- **Citations:**
  - the union of citations when no ground is shown;
  - out_of_scope with an exclusion key absent cites Art 2(1) to (4).
- **The Q10 default.**
- **Each input problem form and its order.**
- **Properties via validate_props:** totality, determinism (exactly one solution) and citation completeness.
