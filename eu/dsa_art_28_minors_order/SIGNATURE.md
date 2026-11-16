# SIGNATURE — eu/dsa_art_28_minors_order

## 0. Public query surface (summary)

### Facade

- `decide_dsa_art_28_minors_order(Profile, dsa_art_28_minors_order_verdict(Status, Citations))`
- `dsa_art_28_minors_order_status(Profile, Status)`

STATUS is one of `dsa_art_28_minors_order_breached`, `dsa_art_28_minors_order_complied`, `dsa_art_28_minors_order_not_engaged`, or a not-final status compound. The compound is `indeterminate([Key])`, `needs_legal_review(Reason, Context)` or `input_problems(Problems)`, written ITSELF and never inside a list.

### Contract queries

The four contract queries are exported unchanged:

- `section_3_application_status/4`
- `art_28_1_obligation_status/4`
- `art_28_1_compliance_status/4`
- `art_28_2_advertising_status/4`

The input check `dsa_art_28_minors_order_input_problems/2` is also exported.

### Totality and determinism

Every public query yields EXACTLY ONE solution for every term it is given.

- The input check never fails and never raises.
- Routes are disjoint clauses, with no `!`, `->` or `*->`, and ground verdicts folded into heads (C17).

### Figures

There are NO statutory figures: no thresholds, periods or dates are computed. The 12-month run-off and the enterprise thresholds are caller findings. There is no `constant_value/2` declaration, and nothing is imported from another domain.

## 1. Verdict STATUS atoms (replace scaffold `required | permitted | not_applicable`)

### Contract RESULT atoms (exact)

| Query | Final RESULT atoms |
|---|---|
| `section_3_application_status` | `section_3_applies`, `section_3_not_applicable` |
| `art_28_1_obligation_status` | `art_28_1_obligation_applies`, `art_28_1_obligation_not_applicable` |
| `art_28_1_compliance_status` | `art_28_1_measures_compliant`, `art_28_1_measures_not_compliant`, `art_28_1_measures_not_required` |
| `art_28_2_advertising_status` | `art_28_2_presentation_prohibited`, `art_28_2_presentation_not_prohibited` |

### Facade STATUS atoms (author's composition, the working notes (not published))

| Atom | Meaning |
|---|---|
| `dsa_art_28_minors_order_breached` | Measures not compliant, or presentation prohibited. |
| `dsa_art_28_minors_order_complied` | Measures compliant, and presentation not prohibited. |
| `dsa_art_28_minors_order_not_engaged` | Measures not required, and presentation not prohibited. |

### Not-final compounds (exact functors and arities)

- `indeterminate/1`: argument is `[Key]`, exactly one bare key. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review/2`
- `open_textured/2`
- `cross_reference_unresolved/2`
- `resolution/2`
- `inputs_relied_on/1`
- `provenance/2`: optional and unscored. It is NOT emitted.
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`

### Value constructors

`outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`.

### The bare atom `absent`

The atom `absent` appears ONLY as the value in the pair `designated_as_very_large_online_platform-absent`, as the contract requires. Internal key readings use `given(Value)` and `not_given` instead, to avoid shadowing `formalize_lib:absent/1`.

## 2. Profile keys (root_exports and input_contract order; bare atoms; no numerics; no dates)

| # | Key | Kind | Values | Provision |
|---|---|---|---|---|
| 1 | `platform_accessible_to_minors` | judgement | `true` / `false` / `unsure` | Art 28(1) |
| 2 | `advertisements_presented_to_recipient_on_interface` | crisp | `true` / `false` | Art 28(2) |
| 3 | `advertisements_based_on_profiling_of_recipient` | judgement | `true` / `false` / `unsure` | Art 28(2) |
| 4 | `aware_with_reasonable_certainty_recipient_is_minor` | judgement | `true` / `false` / `unsure` | Art 28(2) |
| 5 | `provider_qualifies_as_micro_or_small_enterprise` | crisp | `true` / `false` | Art 19(1), first sentence |
| 6 | `provider_within_12_months_after_losing_micro_or_small_status` | crisp | `true` / `false` | Art 19(1), second sentence |
| 7 | `designated_as_very_large_online_platform` | outside fact | `attested(true\|false, attestation(By, At, Reason, Evidence))` | Arts 19(2), 33 |
| 8 | `measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors` | judgement | `true` / `false` / `unsure` | Art 28(1) |

### The outside-fact entry (`outside_facts:`)

- Key: `designated_as_very_large_online_platform`.
- Citation: `eu_reg_2022_2065_art_19_2`.
- Target: `commission_vlop_designation_decision`.
- Kinds, in precedence order: attested, then fetched. The fetcher is `none`, so only attested is read.
- Evidence is `url(Url, RetrievedAt)`, `document(UploadId, Sha256)` or `none`. It is never inspected.

## 3. Citation-key atoms (canonical lexicon `_lexicon/citations.yaml`; never shortened)

| Atom | Pinned unit |
|---|---|
| `eu_reg_2022_2065_art_19_1` | 32022R2065#parag_019.001 |
| `eu_reg_2022_2065_art_19_2` | 32022R2065#parag_019.002 |
| `eu_reg_2022_2065_art_28_1` | 32022R2065#parag_028.001 |
| `eu_reg_2022_2065_art_28_2` | 32022R2065#parag_028.002 |
| `commission_vlop_designation_decision` | Cross-reference TARGET only; not a pinned unit. |

The segment `vlop` in the target atom is fixed by the contract and the lexicon. Carry `% lint: C6 contract-fixed citation atom` on the line that declares it in `citations.clausal`, and on each line that uses it.

Each pinned unit carries the source sha256 `11b119a7d45f3a10cd41714061f9d907839ef5d1634e41774490f00b95856bbf` and the verbatim text in `citations.clausal`.

### Fixed CITATIONS per final RESULT (set-like; order not scored; written in this order)

- `C19 = [cite(eu_reg_2022_2065_art_19_1), cite(eu_reg_2022_2065_art_19_2)]`. Used by `section_3_applies` and `section_3_not_applicable`.
- `C281 = C19 ++ [cite(eu_reg_2022_2065_art_28_1)]`. Used by all three Art 28(1) obligation answers and all three compliance answers.
- `C282 = C19 ++ [cite(eu_reg_2022_2065_art_28_2)]`. Used by both advertising answers.
- `CALL = C19 ++ [cite(eu_reg_2022_2065_art_28_1), cite(eu_reg_2022_2065_art_28_2)]`. Used by the three final facade STATUS atoms.
- Every not-final answer has CITATIONS `[]`.

### Fixed BASIS

- `section_3_not_applicable` has BASIS `[outside_fact(designated_as_very_large_online_platform, Attested)]`, with `Attested` exactly as supplied.
- Every other answer has BASIS `[]`.

## 4. Public predicates (one line each)

- `section_3_application_status(Profile, Result, Basis, Citations)`: does Section 3 of Chapter III apply under Art 19. Cites `eu_reg_2022_2065_art_19_1` and `eu_reg_2022_2065_art_19_2`.
- `art_28_1_obligation_status(Profile, Result, Basis, Citations)`: does the obligation of Art 28(1) apply, read with Art 19. Cites `eu_reg_2022_2065_art_19_1`, `eu_reg_2022_2065_art_19_2` and `eu_reg_2022_2065_art_28_1`.
- `art_28_1_compliance_status(Profile, Result, Basis, Citations)`: are the measures compliant, given that the obligation applies. Cites `eu_reg_2022_2065_art_19_1`, `eu_reg_2022_2065_art_19_2` and `eu_reg_2022_2065_art_28_1`.
- `art_28_2_advertising_status(Profile, Result, Basis, Citations)`: is presentation of profiling-based advertisements to a known minor prohibited. Cites `eu_reg_2022_2065_art_19_1`, `eu_reg_2022_2065_art_19_2` and `eu_reg_2022_2065_art_28_2`.
- `dsa_art_28_minors_order_input_problems(Profile, Problems)`: the typed INPUT CHECK. Problems is a BARE flat list, `[]` when the profile is well-formed. It applies to every provision above.
- `decide_dsa_art_28_minors_order(Profile, dsa_art_28_minors_order_verdict(Status, Citations))`: the facade verdict (query type #2), with the fixed `CALL` citations when final and `[]` when not final. Cites Arts 19(1), 19(2), 28(1) and 28(2).
- `dsa_art_28_minors_order_status(Profile, Status)`: Status alone, the same value as in the verdict. Cites Arts 19(1), 19(2), 28(1) and 28(2).
- `dsa_art_28_minors_order_checklist(Profile, Checklist)`: the justification for query type #7. It is exactly four `item(Identifier, Result, CitationList)` rows, in this fixed order:
  1. `item(section_3_application, R1, C19)`
  2. `item(art_28_1_obligation, R2, C281)`
  3. `item(art_28_1_compliance, R3, C281)`
  4. `item(art_28_2_advertising, R4, C282)`

  Each `Ri` is the RESULT of the matching query. The per-item citation list is FIXED per item, met or not, so that every item carries `cite(...)` provenance.
- `dsa_art_28_minors_order_what_if(Profile, Key, Value, Status)`: the facade Status after overriding `attribute(Key, Value)` with `formalize_lib:profile_set/3`. The override is re-validated by the input check, so an override outside the type gives `input_problems(...)`. Cites Arts 19(1), 19(2), 28(1) and 28(2).
- Fixtures (in `fixtures.clausal`):
  - `dsa_art_28_minors_order_fixture(FixtureName, Profile)`
  - `dsa_art_28_minors_order_fixture_expected(FixtureName, QueryName, Result)`

  There is one fixture per step 0 to 26 below, plus the facade routes.

## 5. Planned reuse (manifest `uses:`)

### From `formalize_lib`

- `profile_get/3`: the ONLY reader of profile values. Absence is tested by its failure under negation (`\\+`).
- `profile_set/3`: for what_if.
- `item/3`: checklist rows.
- `attribute/2`: the profile element constructor.

Not used, with reasons:

- `assess/6` and `eval_requirements/4`: the limbs are ordered with precedence, not independent requirements (the working notes (not published)).
- `check_tri/4` and `check_tri_neg/4`: these map the judgement to met/unmet/unknown, but the contract needs `unsure` distinct from absent and step-specific precedence. The local readers are presence/value DISPATCH, not Kleene combinators. If lint C15 still fires, record the reason in a `% lint:` pragma.

### From `validate_props` (tests only)

`run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.

### Not used

- `deadline_lib`, `datetime`, `rolling_window`: there is no clock.
- `compliance_lib`: deontic, but there is a single bearer, the order is fixed by the contract, and there is no modality lattice to combine.
- `query_combinators`: what_if is via `profile_set/3` on the attribute list.
- `currency_vocab`, `vat_category`, `country`: not relevant.

### `_common` family backbone

None required.

## 6. Package layout (unchanged)

`kernel -> citations -> parameters -> dsa_art_28_minors_order -> queries -> fixtures -> facade`

| File | Holds |
|---|---|
| `kernel.clausal` | The shared floor ONLY. There is one determination slice, so no domain predicate is shared between slices. Kernel declares the exported result-constructor vocabulary (the functor/arity list of section 1), so queries, fixtures and facade agree on the shapes. Nothing domain-specific. |
| `citations.clausal` | `citation(Key, Instrument, UnitIdentifier, Sha256, VerbatimText)` for the four pinned units. `cross_reference_target(commission_vlop_designation_decision, eu_reg_2022_2065_art_19_2)`. |
| `parameters.clausal` | No statutory figures (stated in a comment). It keeps its module, with the `outside_fact_declaration(designated_as_very_large_online_platform, eu_reg_2022_2065_art_19_2, commission_vlop_designation_decision, [attested, fetched], none)` row mirrored from the manifest. |
| `dsa_art_28_minors_order.clausal` | The slice (section 7). |
| `queries.clausal` | Re-exports the four contract queries and the input check from the slice. It also defines facade status, checklist and what_if over them. |
| `fixtures.clausal` | Section 4. |
| Package facade | `decide_dsa_art_28_minors_order/2` plus re-exports. |

## 7. Determination slice — `dsa_art_28_minors_order.clausal`

### 7.1 VALUE facts owned

There are no thresholds, periods or tables. The slice owns:

- `contract_key(Position, Key, Type)`: eight rows in the order of section 2. Type is `crisp`, `judgement` or `outside_fact`. This is the input_contract key order used by the input check and the PAIRS rule.
- The fixed citation lists as facts:
  - `section_3_citations(C19)`
  - `article_28_1_citations(C281)`
  - `article_28_2_citations(C282)`

  Each is a ground list from section 3, written in the head.

### 7.2 Local helpers (non-exported; full-word names)

- `key_reading(Profile, Key, given(Value))` holds via `profile_get(Profile, Key, Value)`.
- `key_reading(Profile, Key, not_given)` holds via `\\+ profile_get(Profile, Key, _)`.
- `designation_reading(Profile, Reading)` gives exactly one of:
  - `attested_true(Attested)` for `attested(true, attestation(_,_,_,_))`, with `Attested` the whole term;
  - `attested_false(Attested)`;
  - `not_given`.
- `exempt_qualified(Profile)`, split into disjoint clauses:
  1. micro or small is `given(true)`; or
  2. micro or small is not `given(true)`, and within-12-months is `given(true)`.

  It is called only under negation or as a single guard, so it never duplicates a solution.
- `well_formed(Profile)` holds when the input check gives `Problems = []`. EVERY route clause of the four queries starts with it, except the one step-0 clause, whose guard is `Problems = [_|_]`.

### 7.3 Rules (THE LIMBS; each a disjoint clause with RESULT, BASIS and CITATIONS in the head)

Abbreviations used in this section only: Q = provider_qualifies_as_micro_or_small_enterprise, W = provider_within_12_months_after_losing_micro_or_small_status, D = designation, A = platform_accessible_to_minors, M = the measures judgement, P = presented, F = profiling, K = aware.

#### Step 0 — every query

`input_problems(Problems), [], []` when Problems is non-empty.

#### section_3_application_status (Art 19)

| Step | Condition | RESULT, BASIS, CITATIONS |
|---|---|---|
| 1 | Q is false and W is false. | `section_3_applies, [], C19` |
| 2 | Not (Q false and W false), and D is `attested_true`. | `section_3_applies, [], C19` |
| 3 | Exempt-qualified, and D is `attested_false(Attested)`. | `section_3_not_applicable, [outside_fact(designated_as_very_large_online_platform, Attested)], C19` |
| 4 | Exempt-qualified, and D is `not_given`. | `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2022_2065_art_19_2), cite(commission_vlop_designation_decision)), [resolution(cite(commission_vlop_designation_decision), not_attempted), inputs_relied_on([designated_as_very_large_online_platform-absent])]), [], []` |
| 5a | D is not `attested_true`, Q is `not_given`, and W is not `given(true)`. | `indeterminate([provider_qualifies_as_micro_or_small_enterprise])` |
| 5b | D is not `attested_true`, Q is false, and W is `not_given`. | `indeterminate([provider_within_12_months_after_losing_micro_or_small_status])` |

#### art_28_1_obligation_status (S = the RESULT of section_3_application_status)

| Step | Condition | RESULT |
|---|---|---|
| 6 | A is false. | `art_28_1_obligation_not_applicable, [], C281` |
| 7 | A is not false, and S is `section_3_not_applicable`. | `art_28_1_obligation_not_applicable, [], C281` |
| 8 | S is `section_3_applies` and A is true. | `art_28_1_obligation_applies, [], C281` |
| 9 | A is not given, and S is not `section_3_not_applicable`. | `indeterminate([platform_accessible_to_minors])` |
| 10 | A is true or unsure, and S is `indeterminate(Keys)`. | S |
| 11 | A is true or unsure (value V), and S is the step-4 referral. | The cross-reference, with pairs `[platform_accessible_to_minors-V, designated_as_very_large_online_platform-absent]`. |
| 12 | S is `section_3_applies` and A is unsure. | `needs_legal_review(open_textured(platform_accessible_to_minors, cite(eu_reg_2022_2065_art_28_1)), [inputs_relied_on([platform_accessible_to_minors-unsure])])` |

#### art_28_1_compliance_status (O = the RESULT of art_28_1_obligation_status)

| Step | Condition | RESULT |
|---|---|---|
| 13 | O is `art_28_1_obligation_not_applicable`. | `art_28_1_measures_not_required, [], C281` |
| 14 | O applies and M is true. | `art_28_1_measures_compliant, [], C281` |
| 15 | O applies and M is false. | `art_28_1_measures_not_compliant, [], C281` |
| 16 | O is `indeterminate(Keys)`. | O |
| 17 | O applies or is a referral, and M is not given. | `indeterminate([measures_appropriate_and_proportionate_for_high_level_of_privacy_safety_and_security_of_minors])` |
| 18a | O is the cross-reference, and M is given(V2), whatever V2 is (true, false or unsure). | The same reason, with pairs `[platform_accessible_to_minors-V, designated_as_very_large_online_platform-absent, measures_...-V2]`. |
| 18b | O is the open_textured referral on A, and M is given(V2). | The same reason, with pairs `[platform_accessible_to_minors-unsure, measures_...-V2]`. |
| 19 | O applies and M is unsure. | `needs_legal_review(open_textured(measures_..., cite(eu_reg_2022_2065_art_28_1)), [inputs_relied_on([platform_accessible_to_minors-true, measures_...-unsure])])` |

#### art_28_2_advertising_status (S as above; A and M are not read)

| Step | Condition | RESULT |
|---|---|---|
| 20a | P is false. | `art_28_2_presentation_not_prohibited, [], C282` |
| 20b | P is not false and F is false. | `art_28_2_presentation_not_prohibited, [], C282` |
| 20c | P is not false, F is not false and K is false. | `art_28_2_presentation_not_prohibited, [], C282` |
| 21 | None of P, F, K is false, and S is `section_3_not_applicable`. | `art_28_2_presentation_not_prohibited, [], C282` |
| 22 | S is `section_3_applies` and P, F, K are all true. | `art_28_2_presentation_prohibited, [], C282` |
| 23a | None false, S is not `section_3_not_applicable`, and P is not given. | `indeterminate([advertisements_presented_to_recipient_on_interface])` |
| 23b | None false, S is not `section_3_not_applicable`, P is given and F is not given. | `indeterminate([advertisements_based_on_profiling_of_recipient])` |
| 23c | None false, S is not `section_3_not_applicable`, P and F are given and K is not given. | `indeterminate([aware_with_reasonable_certainty_recipient_is_minor])` |
| 24 | All three are given (true or unsure), and S is `indeterminate(Keys)`. | S |
| 25 | All three are given, and S is the step-4 referral. | The cross-reference, with pairs `[advertisements_based_on_profiling_of_recipient-VF, aware_with_reasonable_certainty_recipient_is_minor-VK, designated_as_very_large_online_platform-absent]`. |
| 26a | S applies, P is true, and F is unsure. | `open_textured(advertisements_based_on_profiling_of_recipient, cite(eu_reg_2022_2065_art_28_2))`, with pairs `[F-VF, K-VK]`. |
| 26b | S applies, P is true, F is true and K is unsure. | `open_textured(aware_with_reasonable_certainty_recipient_is_minor, cite(eu_reg_2022_2065_art_28_2))`, with the same pairs. |

#### Input check — `dsa_art_28_minors_order_input_problems(Profile, Problems)`

It is total and non-raising. It walks the raw term, with no `profile_get`.

- `[wrong_type(profile)]` when Profile is any of:
  - unbound;
  - a partial list;
  - not a list;
  - a list holding an unbound element or any element other than `attribute(_, _)`.
- Otherwise Problems is two parts joined in order:
  1. For each `contract_key` in position order:
     - `duplicate_key(Key)` if Key occurs two or more times (matched with `==`). Its values are not read.
     - Otherwise `wrong_type(Key)` if it occurs once with a value outside its type. An unbound value counts as outside its type.
  2. `unknown_key(Key)` for each distinct non-contract key, in order of its first occurrence. Distinctness is tested with `==`. A non-atom key (number, string, compound or unbound variable) is unknown and is kept exactly as given.
- Types:
  - crisp: `true` or `false`;
  - judgement: `true`, `false` or `unsure`;
  - outside fact: `nonvar` and `attested(V, attestation(_,_,_,_))` with V `true` or `false`. The four attestation arguments are not inspected.
- Absence is never a problem.

### 7.4 Verdict atoms

The slice owns the four RESULT sets of section 1. The facade atoms live in `queries.clausal` and are composed only from the slice's RESULTs.

### 7.5 Predicates shared with another slice

None. There is a single slice, so `kernel.clausal` receives no domain predicate.

### 7.6 Per-rule tests (seven modes; v2 manifest)

- **Positive:** one test per step 0 to 26, including split sub-steps.
- **Paired negatives:** each `fail` test is paired with a positive over the same case.
- **COUNTING:** `findall` of each query has length 1 on every fixture and on the step-0 edge terms:
  - an unbound profile;
  - a partial list;
  - an unbound key;
  - an unbound value;
  - duplicates with equal values;
  - a string key;
  - a compound key.
- **Fixed-set properties:**
  - The same RESULT always gives the same BASIS and CITATIONS, over the exhaustive enumeration of the 3x2x3x3x2x2x3x3 value space, with absence counted as one more value for each key.
  - Filling any absent key never changes only the BASIS or only the CITATIONS.
- **Monotonicity of not-final answers:** `indeterminate` names exactly one key, and that key is absent from the profile.
- **Q1 regression:** `platform_accessible_to_minors` has no effect on `art_28_2_advertising_status`.
- **validate_props:** `prop_totality`, `prop_determinism`, `prop_citation_complete` (every final answer cites only lexicon atoms; `bad_citation/1` never holds) and `prop_missing_key_coverage`.

### 7.7 Checklist (slice-level, consumed by the facade)

The slice provides the four RESULTs. `queries.clausal` assembles the fixed four-row checklist of section 4, without findall.
