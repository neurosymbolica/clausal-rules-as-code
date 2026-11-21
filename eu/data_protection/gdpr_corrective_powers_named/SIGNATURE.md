# SIGNATURE — eu/data_protection/gdpr_corrective_powers_named

## Public query surface

The contract queries are the following:

- `corrective_powers_named(PROFILE, RESULT, CITATIONS)` (A)
- `corrective_power_named(PROFILE, MEASURE, RESULT, CITATIONS)` (B)
- `gdpr_corrective_powers_named_input_problems(PROFILE, PROBLEMS)` (C)

The scaffold facade wraps (A):

- `decide_gdpr_corrective_powers_named(PROFILE, gdpr_corrective_powers_named_verdict(RESULT, CITATIONS))`
- `gdpr_corrective_powers_named_status(PROFILE, STATUS)`

PROFILE is an attribute list `[attribute(KEY, VALUE), ...]` over the nine keys below. It is read only with `profile_get/3`.

**Totality.** Every query, facade predicate and the input check yields exactly ONE solution for every term it is given. It never fails and never raises. This covers an unbound or partial PROFILE and an unbound MEASURE. The only exceptions are the enumeration predicates marked as such below.

**Determinism.** Determinism comes from disjoint clause routes (C17: ground outputs in heads). There is no `!`, no `->` and no `*->`.

**Imported figures.** No figure is imported, and there is no number, date or amount anywhere. The statutory value facts (measure table, addressee table, point keys, citations) live in the slice file.

## Verdict STATUS atoms (replace the scaffold placeholders)

`required` / `permitted` / `not_applicable` are REMOVED.

**Result terms**, the RESULT of (A) and (B):

- `powers_named(POWERS, authority_discretion)`, with each element of POWERS being `power(MEASURE, ADDRESSEES)`.
- `named(ADDRESSEES, authority_discretion)`.
- `not_named` (a bare atom).
- `indeterminate([KEY])`. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(KEY, cite(CITATION_KEY)), [inputs_relied_on(PAIRS)])`, with each element of PAIRS being `KEY-VALUE`.
- `input_problems(PROBLEMS)`, with PROBLEMS made of `duplicate_key(KEY)`, `wrong_type(KEY)` and `unknown_key(KEY)`.

**Facade STATUS atoms** of `gdpr_corrective_powers_named_status/2`. These are distinct names, so no bare atom shadows an arity-1 result functor:

| STATUS | RESULT |
|---|---|
| `powers_listed` | `powers_named/2` |
| `awaiting_input` | `indeterminate/1` |
| `referred_to_lawyer` | `needs_legal_review/2` |
| `input_rejected` | `input_problems/1` |

**verdict_vocabulary:**

- the result functors and constants above: `powers_named`, `power`, `named`, `not_named`, `authority_discretion`, `indeterminate`, `needs_legal_review`, `open_textured`, `inputs_relied_on`, `input_problems`, `duplicate_key`, `wrong_type`, `unknown_key`;
- the four facade status atoms.

`true` and `false` are NEVER pinned. `unknown` is never used.

## Profile keys

There is no numeric key, date or list. The order below is the order of `root_exports` and `input_contract`.

| # | Key | Type | Values | Read by point |
|---|---|---|---|---|
| 1 | `intended_processing_likely_to_infringe` | judgement | `true` / `false` / `unsure` | (a), (f) |
| 2 | `processing_has_infringed` | judgement | `true` / `false` / `unsure` | (b), (f), (i) |
| 3 | `data_subject_request_to_exercise_rights_made` | crisp (boolean) | `true` / `false` | (c) |
| 4 | `processing_not_in_compliance` | judgement | `true` / `false` / `unsure` | (d), (f) |
| 5 | `personal_data_breach_occurred` | crisp (boolean) | `true` / `false` | (e) |
| 6 | `rectification_erasure_or_restriction_ground_met` | judgement | `true` / `false` / `unsure` | (g) |
| 7 | `certification_issued_or_applied_for` | crisp (boolean) | `true` / `false` | (h) |
| 8 | `certification_requirements_not_met` | judgement | `true` / `false` / `unsure` | (h) |
| 9 | `data_flows_to_third_country_or_international_organisation` | crisp (boolean) | `true` / `false` | (j) |

Input contract types:

- `boolean` = the atoms `true` and `false`.
- `judgement` = `boolean` plus `unsure`.
- `measure` = the ten measure atoms.
- `attested(...)` is `wrong_type(KEY)` for every key.
- `measure` and `profile` are argument names used only inside `wrong_type(...)`. They are not profile keys and are not exported.

**root_exports:**

- the nine keys;
- `not_named` and `authority_discretion`;
- the ten measure atoms;
- `controller`, `processor` and `certification_body`;
- `unsure`.

## Measure atoms (one per point, fixed addressees)

| Point | Measure atom | ADDRESSEES | Point citation |
|---|---|---|---|
| (a) | `warning` | `[controller, processor]` | `eu_reg_2016_679_art_58_2_a` |
| (b) | `reprimand` | `[controller, processor]` | `eu_reg_2016_679_art_58_2_b` |
| (c) | `order_to_comply_with_data_subject_requests` | `[controller, processor]` | `eu_reg_2016_679_art_58_2_c` |
| (d) | `order_to_bring_processing_into_compliance` | `[controller, processor]` | `eu_reg_2016_679_art_58_2_d` |
| (e) | `order_to_communicate_personal_data_breach` | `[controller]` | `eu_reg_2016_679_art_58_2_e` |
| (f) | `limitation_or_ban_on_processing` | `[]` | `eu_reg_2016_679_art_58_2_f` |
| (g) | `order_of_rectification_erasure_or_restriction` | `[]` | `eu_reg_2016_679_art_58_2_g` |
| (h) | `withdrawal_or_refusal_of_certification` | `[certification_body]` | `eu_reg_2016_679_art_58_2_h` |
| (i) | `administrative_fine` | `[]` | `eu_reg_2016_679_art_58_2_i` |
| (j) | `suspension_of_data_flows` | `[]` | `eu_reg_2016_679_art_58_2_j` |

## Citation-key atoms (canonical lexicon scheme, `_lexicon/citations.yaml`)

**Emitted:**

- `eu_reg_2016_679_art_58_2` (chapeau);
- `eu_reg_2016_679_art_58_2_a`, `_b`, `_c`, `_d`, `_e`, `_f`, `_g`, `_h`, `_i` and `_j`, as `eu_reg_2016_679_art_58_2_a` through `eu_reg_2016_679_art_58_2_j`.

**Registered, never emitted** (deferred provenance for readings (1) and (15)):

- `eu_reg_2016_679_art_58_4`
- `eu_reg_2016_679_art_58_5`
- `eu_reg_2016_679_art_58_6`

No shortened citation atom is ever invented.

**Referral citations**, one per judgement key, in `open_textured(KEY, cite(K))`:

| Judgement key | K |
|---|---|
| `intended_processing_likely_to_infringe` | `eu_reg_2016_679_art_58_2_a` |
| `processing_has_infringed` | `eu_reg_2016_679_art_58_2_b` |
| `processing_not_in_compliance` | `eu_reg_2016_679_art_58_2_d` |
| `rectification_erasure_or_restriction_ground_met` | `eu_reg_2016_679_art_58_2_g` |
| `certification_requirements_not_met` | `eu_reg_2016_679_art_58_2_h` |

These hold whichever point refers on the key.

## Public predicates (one line each)

- `corrective_powers_named(Profile, Result, Citations)`: query type #4 enumeration (the full ordered list). Steps:
  - (0) `input_problems(Problems)` with `[]` citations;
  - (1) the first point (a) to (j) that is open by absence gives `indeterminate([Key])` with `[]`;
  - (2) else the first point (a) to (j) that is open by judgement gives `needs_legal_review(open_textured(Key, cite(K)), [inputs_relied_on(Pairs)])`, Pairs over all nine keys, with `[]`;
  - (3) else `powers_named(Powers, authority_discretion)` with the eleven citations `eu_reg_2016_679_art_58_2` plus `_a` to `_j`.
  Citation: Art 58(2) and (a) to (j).
- `corrective_power_named(Profile, Measure, Result, Citations)`: query type #1 factual lookup. Steps:
  - (0) `input_problems(ProfileProblems ++ [wrong_type(measure)] if Measure is not a measure atom)` with `[]`;
  - then the point of Measure gives `named(Addressees, authority_discretion)` or `not_named`, each with `[cite(eu_reg_2016_679_art_58_2), cite(PointCitation)]`;
  - or `indeterminate([Key])` with `[]`;
  - or `needs_legal_review(...)`, Pairs over the point's keys, with `[]`.
  Citation: Art 58(2) and the point.
- `gdpr_corrective_powers_named_input_problems(Profile, Problems)`: the input check, one solution, never fails or raises. It returns `[]` or the ordered problem list. Citation: none (input check).
- `decide_gdpr_corrective_powers_named(Profile, Verdict)`: the facade. Verdict is `gdpr_corrective_powers_named_verdict(Result, Citations)`, with Result and Citations exactly those of `corrective_powers_named/3`. Citation: Art 58(2) and (a) to (j).
- `gdpr_corrective_powers_named_status(Profile, Status)`: maps the Result functor of `corrective_powers_named/3` to `powers_listed` / `awaiting_input` / `referred_to_lawyer` / `input_rejected`. Citation: Art 58(2).
- `gdpr_corrective_powers_named_checklist(Profile, Checklist)`: query type #7 justification. Checklist is ten `item(Measure, PointResult, cite(PointCitation))` terms (`formalize_lib` `item/3`) in point order. PointResult is exactly the Result of `corrective_power_named(Profile, Measure, PointResult, _)`. Every item carries its point's `cite(...)`, open items included. A malformed profile gives `[]`. Citation: Art 58(2)(a) to (j) per item.
- `gdpr_corrective_powers_named_what_if(Profile, Key, Value, Result)`: runs the input check on the original Profile first. If that gives problems, Result is `input_problems(Problems)`. Otherwise it sets `attribute(Key, Value)` with `profile_set/3` and returns the Result of `corrective_powers_named/3` on the new profile (whose input check then catches a bad Key or Value). One solution. Citation: Art 58(2).
- `gdpr_corrective_powers_named_measure(Measure)`: query type #4 output-mode enumeration. Yields each of the ten measure atoms once, in point order. Citation: Art 58(2)(a) to (j).
- `gdpr_corrective_powers_named_named_measure(Profile, Measure)`: query type #4 output-mode enumeration. Yields each Measure of Powers once, in point order, when the Result is final. Gives no solution when the Result is not final or Powers is `[]`. Citation: Art 58(2).
- `gdpr_corrective_powers_named_measure_addressees(Measure, Addressees)`: query type #1 lookup. Gives the fixed addressee list of a point (reading (2)). Citation: the point.
- `gdpr_corrective_powers_named_measure_citation(Measure, CitationKey)`: query type #1 lookup. Gives the point's citation atom. Citation: the point.
- `gdpr_corrective_powers_named_measure_keys(Measure, Keys)`: query type #1 lookup. Gives the keys the point reads, in root_exports order (reading (4)). Citation: the point.
- `gdpr_corrective_powers_named_fixture(Name, Profile)`: fixtures (see below).
- `gdpr_corrective_powers_named_fixture_expected(Name, Result, Citations)`: the expected answer of `corrective_powers_named/3` for each fixture.

The result constructors are exported and never called as queries: `powers_named/2`, `power/2`, `named/2`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `input_problems/1`, `unknown_key/1`, `wrong_type/1` and `duplicate_key/1`.

## Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3`, the only profile reader, used after the input check passes;
  - `profile_set/3`, for what_if;
  - `item/3`, the checklist item constructor.
- `validate_props` (tests): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3` and `bad_citation/1`.
- Considered and NOT used, with reasons:
  - `check_tri/4` and `check_tri_neg/4`: three-valued, with no `unsure` leg. The local four-way point table carries a `% lint:` pragma.
  - `assess/6`, `eval_requirements/4` and `decide_labeled/3`: the contract answer is not a positive / indeterminate / negative label but a list of named powers with first-missing precedence across points.
  - `kit/compliance_lib`: it would assert a modality the text does not state (reading (1)).
  - The deadline, date and rolling-window kits: there is no date, period or amount.
  - `kit/query_combinators` `what_if/5`: its `override_key/4` works on dicts, not attribute lists. `profile_set/3` is used instead.
  - No `_common` family-backbone predicate fits.
- Local candidate for a kit module: the typed attribute-list input check (see NOTES).

## Package layout (unchanged file and module names)

The build order is: kernel → citations → parameters → `gdpr_corrective_powers_named` → queries → fixtures → package facade.

- **kernel.clausal.** The shared floor:
  - the contract key order `contract_key(Position, Key, Type)` for the nine keys;
  - the type tests `value_has_type(Type, Value)` for judgement and boolean, which are ground-safe and fail on a variable;
  - the input check `gdpr_corrective_powers_named_input_problems/2`;
  - `present_pairs(Profile, Keys, Pairs)` (THE PAIRS RULE).
  These are shared because the slice (step 0 and referrals), queries, facade and what_if all use them.
- **citations.clausal.** The fourteen citation atoms with their unit identifiers `02016R0679-20160504#...` and verbatim pinned text. Only eleven are emitted.
- **parameters.clausal.** Holds no statutory figure. The order has no threshold, period or amount, and a comment says so. There is no `constant_value`.
- **gdpr_corrective_powers_named.clausal.** The one determination slice (below).
- **queries.clausal.** The public lookup and enumeration predicates, the checklist and what_if.
- **fixtures.clausal.** Named profiles with their expected answers.
- **Package facade.** `decide_gdpr_corrective_powers_named/2`, `gdpr_corrective_powers_named_status/2` and the re-exports.

## Slice: gdpr_corrective_powers_named.clausal

### Statutory VALUE facts owned by this slice

The slice owns these tables:

- `measure_point(Position, Measure, PointCitation)`: ten rows, Position 1 to 10, in the order (a) to (j). This fixes the measure order and the point citations.
- `measure_addressees(Measure, Addressees)`: ten rows, as in the measure table above (reading (2)).
- `measure_keys(Measure, Keys)`, giving the keys each point reads, in root_exports order (reading (4)):
  - (f): `[intended_processing_likely_to_infringe, processing_has_infringed, processing_not_in_compliance]`;
  - (h): `[certification_issued_or_applied_for, certification_requirements_not_met]`;
  - each other point: its single key.
- `one_key_point(Measure, Key)`: eight rows, for (a), (b), (c), (d), (e), (g), (i) and (j).
- `referral_citation(JudgementKey, CitationKey)`: five rows (the referral citations above).
- `chapeau_citation(eu_reg_2016_679_art_58_2)`.

There are no numeric facts.

### Point outcomes (internal verdict atoms of the slice)

`point_outcome(Profile, Measure, Outcome)` gives exactly one of:

- `named`
- `not_named`
- `open_by_absence(Key)`
- `open_by_judgement(Key)`

It has disjoint routes, and its output is folded into the clause heads. It is called only on a profile with no input problems.

### Rules / requirements

**R-one-key**, for points (a), (b), (c), (d), (e), (g), (i) and (j) with their Key:

| Key | Outcome |
|---|---|
| `true` | `named` |
| `false` | `not_named` |
| absent (no `profile_get/3` solution) | `open_by_absence(Key)` |
| `unsure` | `open_by_judgement(Key)` (reachable only for judgement keys; for crisp keys it was already caught by step 0) |

Each row is a separate clause.

**R-point-f**, over I = `intended_processing_likely_to_infringe`, H = `processing_has_infringed` and N = `processing_not_in_compliance`. These are eight disjoint routes. 'Not true' means absent, `false` or `unsure`.

1. I `true` → `named`
2. I not true and H `true` → `named`
3. I not true, H not true and N `true` → `named`
4. I, H and N all `false` → `not_named`
5. None true and I absent → `open_by_absence(I)`
6. None true, I present and H absent → `open_by_absence(H)`
7. None true, I and H present and N absent → `open_by_absence(N)`
8. None true and none absent, with at least one unsure → `open_by_judgement` on the first unsure in I, H, N order:
   - I `unsure` → I;
   - I `false` and H `unsure` → H;
   - I `false`, H `false` and N `unsure` → N.

So NAMED is proven exactly once however many keys are true.

**R-point-h**, over C = `certification_issued_or_applied_for` (crisp) and R = `certification_requirements_not_met` (judgement). These are six disjoint routes.

1. C `false` → `not_named`
2. C `true` or absent, and R `false` → `not_named`
3. C `true` and R `true` → `named`
4. C absent and R `true`, absent or `unsure` → `open_by_absence(C)` (R waits behind C: <<DNUM>> with <<DNUM>>)
5. C `true` and R absent → `open_by_absence(R)`
6. C `true` and R `unsure` → `open_by_judgement(R)`

**R-power-named** (`corrective_power_named/4`). This is step 0 and then the point. Each route below is disjoint:

| Condition | RESULT | CITATIONS |
|---|---|---|
| Problems non-empty, where Problems is ProfileProblems plus `wrong_type(measure)` when Measure is a variable, a non-atom, or an atom outside the ten (tested with `nonvar/1`, `atom/1` and a fact lookup on a bound atom; an unbound Measure is never enumerated) | `input_problems(Problems)` | `[]` |
| outcome `named` | `named(Addressees, authority_discretion)` | `[cite(eu_reg_2016_679_art_58_2), cite(PointCitation)]` |
| outcome `not_named` | `not_named` | the same two |
| outcome `open_by_absence(Key)` | `indeterminate([Key])` | `[]` |
| outcome `open_by_judgement(Key)` | `needs_legal_review(open_textured(Key, cite(K)), [inputs_relied_on(Pairs)])`, with Pairs from `present_pairs` over the point's keys | `[]` |

**R-powers-named** (`corrective_powers_named/3`):

- Step 0: input problems.
- Then compute the ten outcomes in point order as a list.
- A deterministic scan with disjoint clauses applies:
  - if any element is `open_by_absence`, the FIRST such element gives `indeterminate([Key])` with `[]`;
  - else if any is `open_by_judgement`, the FIRST gives a needs_legal_review with Pairs over all nine keys, with `[]`;
  - else the Result is `powers_named(Powers, authority_discretion)`, where Powers is a `power(Measure, Addressees)` term for each `named` outcome in point order, and the eleven citations are attached.
- The scan predicates use head patterns `[open_by_absence(Key) | _]` and `[Outcome | Rest]`, the latter guarded by a ground test that Outcome is not of that form. There is no cut.

### Verdict atoms of this slice

The slice uses the result terms listed under Verdict STATUS atoms. The checklist items reuse the `corrective_power_named` Result per measure.

### Predicates this slice must SHARE (and therefore are in kernel.clausal)

- `contract_key/3`
- `value_has_type/2`
- `gdpr_corrective_powers_named_input_problems/2`
- `present_pairs/3`

Nothing else is shared. The measure, addressee, point-key and referral tables stay in the slice.

### Input check (kernel) — exact algorithm

1. PROFILE is a variable, a partial list, a non-list, or a list with an element that is a variable or not `attribute/2` → `[wrong_type(profile)]`. This is a structural walk with `var/1` tested before any unification.
2. Otherwise, for each contract key in `contract_key` order:
   - count the elements whose KEY is `==` that atom;
   - a count of 2 or more → `duplicate_key(Key)`, with values not read;
   - a count of 1 and a VALUE that is a variable or fails `value_has_type` → `wrong_type(Key)`;
   - a count of 0 → nothing (absence is not a problem).
3. Then add `unknown_key(Key)` for each element KEY that is not an atom `==` some contract key. This covers numbers, strings, compounds and unbound variables, each reported as given. The order is first occurrence, and duplicates by `==` are dropped, so one variable repeated is reported once.

There is no cross-key check.

### Per-rule tests (the seven test modes)

1. **Load.** Every module loads and every export resolves.
2. **Unit, per point.** Cover each row of R-one-key for all eight points, all eight routes of R-point-f and all six routes of R-point-h, with addressees and both citations.
3. **Precedence.** Check:
   - a true I settles (f) with H and N absent;
   - a false C settles (h) with R unsure;
   - absence beats unsure across points: (a) unsure and (j) absent gives `indeterminate([data_flows_to_third_country_or_international_organisation])`;
   - R is not named while C is absent.
4. **Determinism and counting.** `findall` with `length(_, 1)` for every query on every fixture, for all ten measures, and for the multi-true cases of (f).
5. **Totality and robustness.** The input check and every query on an unbound profile, a partial list, `[foo]`, an unbound element, an unbound key, a string key, a compound key, an unbound value, `attested(true)`, crisp `unsure`, duplicates with equal and unequal values, an unbound or unknown Measure (`wrong_type(measure)` last), and a non-read key that is malformed.
6. **Citation completeness.** Every final answer carries exactly its stated set. Every open answer has `[]`. There is no `bad_citation/1` atom, and the art_58_4 to 58_6 atoms are never emitted.
7. **Irrelevance and fixtures.** A key a query does not read, present or absent, never changes the `corrective_power_named` answer. `prop_missing_key_coverage` holds. Every fixture equals its expected answer.

Positive and negative tests are paired over the same case.

### Fixtures (`gdpr_corrective_powers_named_fixture/2` and `_expected/3`)

| Fixture | Profile | Expected RESULT |
|---|---|---|
| `all_false` | all nine keys `false` | `powers_named([], authority_discretion)` |
| `past_infringement` | `processing_has_infringed` true, the rest false | powers b, f, i |
| `intended_and_past` | I and H true | powers a, b, f, i |
| `non_compliance_only` | N true | powers d, f |
| `breach_and_request` | breach and request true | powers c, e |
| `certification_failing` | C and R true | `power(withdrawal_or_refusal_of_certification, [certification_body])` |
| `certification_not_held` | C false and R unsure, the rest false | `[]` |
| `third_country_flows` | flows true | `power(suspension_of_data_flows, [])` |
| `everything_true` | all nine true | all ten powers in order |
| `missing_flows` | eight keys present, flows absent | `indeterminate([data_flows_to_third_country_or_international_organisation])` |
| `missing_certification_key` | C absent and R unsure | `indeterminate([certification_issued_or_applied_for])` |
| `unsure_infringement` | H unsure, the rest false | `needs_legal_review(open_textured(processing_has_infringed, cite(eu_reg_2016_679_art_58_2_b)), [inputs_relied_on(NinePairs)])` |
| `unsure_requirements` | C true, R unsure, the rest false | referral on `certification_requirements_not_met`, `cite(eu_reg_2016_679_art_58_2_h)` |
| `attested_value` | `attribute(personal_data_breach_occurred, attested(true))` | `input_problems([wrong_type(personal_data_breach_occurred)])` |
| `duplicate_and_unknown` | the `processing_has_infringed` key twice, plus `attribute(fine_amount, true)` | `input_problems([duplicate_key(processing_has_infringed), unknown_key(fine_amount)])` |

In `everything_true`, Powers is all ten in point order:

- `power(warning, [controller, processor])`
- `power(reprimand, [controller, processor])`
- `power(order_to_comply_with_data_subject_requests, [controller, processor])`
- `power(order_to_bring_processing_into_compliance, [controller, processor])`
- `power(order_to_communicate_personal_data_breach, [controller])`
- `power(limitation_or_ban_on_processing, [])`
- `power(order_of_rectification_erasure_or_restriction, [])`
- `power(withdrawal_or_refusal_of_certification, [certification_body])`
- `power(administrative_fine, [])`
- `power(suspension_of_data_flows, [])`

Every final answer carries the eleven citations. Every open answer carries `[]`.
