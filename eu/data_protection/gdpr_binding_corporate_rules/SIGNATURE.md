# SIGNATURE — eu/data_protection/gdpr_binding_corporate_rules

## Public query surface

The package answers three contract queries over one PROFILE: `binding_corporate_rules_definition/3` (Art 4(20)), `binding_corporate_rules_content/3` (Art 47(2)) and `binding_corporate_rules_content_checklist/2` (Art 47(2), per point). It also exposes the input check `gdpr_binding_corporate_rules_input_problems/2`.

The scaffold facade keeps its names:

- `decide_gdpr_binding_corporate_rules(PROFILE, gdpr_binding_corporate_rules_verdict(STATUS, CITATIONS))` wraps the definition query (status determination).
- `gdpr_binding_corporate_rules_status(PROFILE, STATUS)` gives the definition RESULT alone.
- `gdpr_binding_corporate_rules_checklist(PROFILE, ITEMS)` gives the content checklist.
- `gdpr_binding_corporate_rules_what_if/4` re-asks the query that reads a key, after that key is overridden.

PROFILE is an attribute list `[attribute(KEY, VALUE), ...]` holding up to twenty-one keys.

**Totality and determinism.** Every public predicate yields EXACTLY ONE solution for every PROFILE term, an unbound one or a non-list included. The engine counts every solution, so a duplicate answer is a refutation.

**Imported figures.** There are none. The order has no dates, periods or amounts, so `parameters.clausal` declares no `constant_value` (reading 15).

## Verdict STATUS atoms (replace the placeholder `{ required, permitted, not_applicable }`)

| Query | Final atoms |
|---|---|
| `binding_corporate_rules_definition/3` | `binding_corporate_rules`, `not_binding_corporate_rules` |
| `binding_corporate_rules_content/3` | `content_complete`, `content_incomplete` |
| `binding_corporate_rules_content_checklist/2` STATE | `met`, `unmet`, `open_by_absence`, `open_by_judgement` |
| judgement value | `unsure` (with `true` and `false`) |

Non-final RESULTs are status compounds:

- `input_problems(PROBLEMS)`
- `indeterminate([KEY])`. This holds one key, the first missing one. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(KEY, cite(CITATION)), [inputs_relied_on(PAIRS)])`

Result constructors are exported and never called as queries:

- `checklist_item/3`
- `indeterminate/1`
- `needs_legal_review/2`
- `open_textured/2`
- `inputs_relied_on/1`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`

`root_exports` holds every bare atom the scorer resolves: the twenty-one keys, the four RESULT atoms, the four STATE atoms and `unsure`.

## Profile keys (input_contract order = root_exports order)

There are no numeric keys and no date keys.

- **judgement** type: one_of boolean or unsure. Boolean means the atoms `true` and `false`.
- **crisp** type: the atom `true` or the atom `false`.

| # | Key | Type | Read by | Citation |
|---|---|---|---|---|
| 1 | `policies_are_personal_data_protection_policies` | crisp | definition | `eu_reg_2016_679_art_4_20` |
| 2 | `policies_adhered_to_by_adhering_party` | crisp | definition | `eu_reg_2016_679_art_4_20` |
| 3 | `adhering_party_is_controller_or_processor` | judgement | definition | `eu_reg_2016_679_art_4_20` |
| 4 | `adhering_party_established_on_territory_of_member_state` | crisp | definition | `eu_reg_2016_679_art_4_20` |
| 5 | `policies_cover_transfers_to_third_countries` | crisp | definition | `eu_reg_2016_679_art_4_20` |
| 6 | `recipients_are_controllers_or_processors` | judgement | definition | `eu_reg_2016_679_art_4_20` |
| 7 | `transfers_within_group_of_undertakings_or_group_of_enterprises` | judgement | definition | `eu_reg_2016_679_art_4_20` |
| 8 | `rules_specify_group_structure_and_contact_details` | crisp | content, checklist | `eu_reg_2016_679_art_47_2_a` |
| 9 | `rules_specify_data_transfers` | crisp | content, checklist | `eu_reg_2016_679_art_47_2_b` |
| 10 | `rules_specify_legally_binding_nature` | crisp | content, checklist | `eu_reg_2016_679_art_47_2_c` |
| 11 | `rules_specify_application_of_general_data_protection_principles` | crisp | content, checklist | `eu_reg_2016_679_art_47_2_d` |
| 12 | `rules_specify_data_subject_rights_and_means_to_exercise_them` | crisp | content, checklist | `eu_reg_2016_679_art_47_2_e` |
| 13 | `rules_specify_acceptance_of_liability_for_members_outside_union` | crisp | content, checklist | `eu_reg_2016_679_art_47_2_f` |
| 14 | `rules_specify_how_information_is_provided_to_data_subjects` | crisp | content, checklist | `eu_reg_2016_679_art_47_2_g` |
| 15 | `rules_specify_tasks_of_compliance_monitoring_persons` | crisp | content, checklist | `eu_reg_2016_679_art_47_2_h` |
| 16 | `rules_specify_complaint_procedures` | crisp | content, checklist | `eu_reg_2016_679_art_47_2_i` |
| 17 | `rules_specify_compliance_verification_mechanisms` | crisp | content, checklist | `eu_reg_2016_679_art_47_2_j` |
| 18 | `rules_specify_change_reporting_and_recording_mechanisms` | crisp | content, checklist | `eu_reg_2016_679_art_47_2_k` |
| 19 | `rules_specify_cooperation_mechanism_with_supervisory_authority` | crisp | content, checklist | `eu_reg_2016_679_art_47_2_l` |
| 20 | `rules_specify_reporting_of_third_country_legal_requirements` | crisp | content, checklist | `eu_reg_2016_679_art_47_2_m` |
| 21 | `rules_specify_appropriate_data_protection_training` | judgement | content, checklist | `eu_reg_2016_679_art_47_2_n` |

Rules for reading the profile:

- Keys are read ONLY with `profile_get/3`, presence first and then value.
- A key a query does not read, present or absent, never changes that query's answer.
- An `attested(...)` value on any key is `wrong_type(KEY)`.

## Citation-key atoms (canonical lexicon, `_lexicon/citations.yaml`; never shortened)

These are load-bearing and used by the queries:

- `eu_reg_2016_679_art_4_20`
- `eu_reg_2016_679_art_47_2`
- `eu_reg_2016_679_art_47_2_a`
- `eu_reg_2016_679_art_47_2_b`
- `eu_reg_2016_679_art_47_2_c`
- `eu_reg_2016_679_art_47_2_d`
- `eu_reg_2016_679_art_47_2_e`
- `eu_reg_2016_679_art_47_2_f`
- `eu_reg_2016_679_art_47_2_g`
- `eu_reg_2016_679_art_47_2_h`
- `eu_reg_2016_679_art_47_2_i`
- `eu_reg_2016_679_art_47_2_j`
- `eu_reg_2016_679_art_47_2_k`
- `eu_reg_2016_679_art_47_2_l`
- `eu_reg_2016_679_art_47_2_m`
- `eu_reg_2016_679_art_47_2_n`

The deferred units are recorded in `citations.clausal` with their pinned text and the marker `deferred`. They are never emitted by a query. Their atoms are used only if present in the lexicon; atoms are never invented. The deferred units are: Art 4(7), Art 4(8), Art 4(19), Art 47 heading, Art 47(1), Art 47(1)(a), Art 47(1)(b), Art 47(1)(c).

## Public predicates

- `binding_corporate_rules_definition(Profile, Result, Citations)`: Is the policy set binding corporate rules? Answers `binding_corporate_rules`, `not_binding_corporate_rules` or a status, following limbs 0 to 4. Query type #3. Cites `eu_reg_2016_679_art_4_20`.
- `binding_corporate_rules_content(Profile, Result, Citations)`: Do the rules specify all of Art 47(2)(a)-(n)? Answers `content_complete`, `content_incomplete` or a status, following limbs 0 to 4. Query type #13, compliance check of content; this is not an approval and not a transfer permission. Cites `eu_reg_2016_679_art_47_2` (and its points when complete).
- `binding_corporate_rules_content_checklist(Profile, Items)`: Gives fourteen `checklist_item(Key, cite(Citation), State)` items in point order (a) to (n), or `input_problems(Problems)`. Query type #7, justification. Cites `eu_reg_2016_679_art_47_2_a` to `_n`.
- `gdpr_binding_corporate_rules_input_problems(Profile, Problems)`: The typed input check. Never fails, never raises, gives one solution. Has no citation.
- `decide_gdpr_binding_corporate_rules(Profile, Verdict)`: `Verdict = gdpr_binding_corporate_rules_verdict(Result, Citations)` with Result and Citations from `binding_corporate_rules_definition/3`. Cites `eu_reg_2016_679_art_4_20`.
- `gdpr_binding_corporate_rules_status(Profile, Status)`: Status is the Result of `binding_corporate_rules_definition/3`. Cites `eu_reg_2016_679_art_4_20`.
- `gdpr_binding_corporate_rules_checklist(Profile, Items)`: Same as `binding_corporate_rules_content_checklist/2`. Cites `eu_reg_2016_679_art_47_2_a` to `_n`.
- `gdpr_binding_corporate_rules_what_if(Profile, Key, Value, Verdict)`: Builds `Updated` with `profile_set(Profile, attribute(Key, Value), Updated)`. Then:
  - when Key is one of the seven Art 4(20) keys, Verdict is `gdpr_binding_corporate_rules_verdict(Result, Citations)` of `binding_corporate_rules_definition(Updated, ...)`;
  - when Key is one of the fourteen point keys, it is the verdict of `binding_corporate_rules_content(Updated, ...)`;
  - when Key is outside the contract, it is the verdict of the definition query, which yields `input_problems([..., unknown_key(Key)])`.

  The three routes are disjoint clauses, selected by `definition_element/1`, `content_point/3` and the negation of both. Cites per the routed query.
- Fixtures: `fixtures.clausal` keeps its scaffolded fixture predicate and name. Each row holds a named PROFILE plus the expected definition, content and checklist answers (see Fixtures). Fixtures have no citation of their own.

## File layout (dependency order kept: kernel -> citations -> parameters -> gdpr_binding_corporate_rules -> queries -> fixtures -> package facade)

- **kernel.clausal**: the shared floor. There is ONE determination slice, so no predicate is shared between slices. The kernel keeps its scaffold module header only and gains NO domain predicate.
- **citations.clausal**: `citation_vocabulary/1` facts for the sixteen load-bearing atoms. Each atom also gets a `citation_text(Atom, Unit, PinnedText)` fact holding the verbatim pinned unit, with the unit id `02016R0679-20160504#...`. The deferred units are listed with a `deferred` marker.
- **parameters.clausal**: no statutory figure. It carries a comment stating why (reading 15).
- **gdpr_binding_corporate_rules.clausal**: the one slice. Everything for both legal concepts lives here (see the next section).
- **queries.clausal**: re-exports the three contract queries and the input check from the slice. Nothing else.
- **fixtures.clausal**: the named profiles below.
- **package facade**: the facade predicates above, plus `root_exports`.

## Determination slice: gdpr_binding_corporate_rules.clausal

### Value facts owned by this slice (tables, no numbers)

The slice owns four ordered key tables. Clause order IS the limbs order, so `findall/3` over each table keeps that order.

- `definition_element(Key)`: seven facts, keys 1 to 7 in the table order above.
- `definition_judgement(Key)`: three facts, in this order:
  1. `adhering_party_is_controller_or_processor`
  2. `recipients_are_controllers_or_processors`
  3. `transfers_within_group_of_undertakings_or_group_of_enterprises`
- `content_point(Letter, Key, Citation)`: fourteen facts, (a) to (n). For example, `content_point(a, rules_specify_group_structure_and_contact_details, eu_reg_2016_679_art_47_2_a)`. The letters are the bare atoms `a` to `n`.
- `content_judgement(rules_specify_appropriate_data_protection_training)`.

The slice also owns the input contract and the citation lists:

- `contract_key(Key, Type)`: twenty-one facts in input_contract order. Type is `crisp` or `judgement`.
- `type_accepts(crisp, true)`, `type_accepts(crisp, false)`, `type_accepts(judgement, true)`, `type_accepts(judgement, false)`, `type_accepts(judgement, unsure)`.
- `complete_content_citations(Citations)`: one fact holding the fifteen `cite(...)` terms. The order is the opening words, then (a) to (n).

### Rules / requirements

**R0, the input check: `gdpr_binding_corporate_rules_input_problems(Profile, Problems)`.** Its clauses are disjoint.

1. `\+ attribute_list(Profile)` gives `[wrong_type(profile)]`.
   `attribute_list/1` is recursive. It is guarded so it never binds the profile:
   - `attribute_list(List) :- nonvar(List), List == [].`
   - `attribute_list(List) :- nonvar(List), List = [Element|Rest], nonvar(Element), Element = attribute(_, _), attribute_list(Rest).`
2. `attribute_list(Profile)` gives `Problems` as the append of the contract problems and the unknown-key problems.
   - **Contract problems.** `maplist` runs over the contract keys in order, then the empty entries are removed. For each contract key there are three disjoint clauses:
     - The key occurs at least twice: `duplicate_key(Key)`. Values are not read.
     - The key occurs exactly once with a value V where `\+ (nonvar(V), type_accepts(Type, V))`: `wrong_type(Key)`. This catches an unbound value, `unsure` on a crisp key, `attested(_)`, strings and numbers.
     - Otherwise: nothing.
   - **Occurrences** are counted by walking the elements and comparing keys with `==` (`atom(ElementKey)`, `ElementKey == Key`), never by unification.
   - **Unknown keys.** A recursive walk in profile order keeps each element key K where `\+ (atom(K), contract_key(K, _))`. Its first occurrence is kept by `==`. The key is reported as `unknown_key(K)` exactly as given, so a variable key stays a variable.

**R1 to R4, `binding_corporate_rules_definition/3` (Art 4(20)).** The helpers are:

- `definition_false_keys(Profile, FalseKeys)`: `findall` over `definition_element(Key)` with `profile_get(Profile, Key, false)`.
- `definition_absent_keys(Profile, AbsentKeys)`: `findall` with `profile_lacks(Profile, Key)`.
- `definition_unsure_keys(Profile, UnsureKeys)`: `findall` over `definition_judgement(Key)` with `profile_get(Profile, Key, unsure)`.
- `definition_judgement_pairs(Profile, Pairs)`: `findall(Key-Value, (definition_judgement(Key), profile_get(Profile, Key, Value)), Pairs)`.

The five clauses are disjoint, and each verdict is folded into the clause head:

- **Limb 0.** `binding_corporate_rules_definition(Profile, input_problems(Problems), [])` holds when the input check gives `Problems = [_|_]`.
- **Limb 1.** `binding_corporate_rules_definition(Profile, not_binding_corporate_rules, [cite(eu_reg_2016_679_art_4_20)])` holds when the input check gives `[]` and `definition_false_keys(Profile, [_|_])`.
- **Limb 2.** `binding_corporate_rules_definition(Profile, indeterminate([Key]), [])` holds when the input check gives `[]`, the false keys are `[]`, and the absent keys are `[Key|_]`.
- **Limb 3.** `binding_corporate_rules_definition(Profile, needs_legal_review(open_textured(Key, cite(eu_reg_2016_679_art_4_20)), [inputs_relied_on(Pairs)]), [])` holds when the input check gives `[]`, the false keys are `[]`, the absent keys are `[]`, and the unsure keys are `[Key|_]`. Pairs are the three judgement pairs in order, with values `true` or `unsure`.
- **Limb 4.** `binding_corporate_rules_definition(Profile, binding_corporate_rules, [cite(eu_reg_2016_679_art_4_20)])` holds when the input check gives `[]` and the false, absent and unsure keys are all `[]`. With the type check passed, all seven keys are then `true`.

**R5 to R9, `binding_corporate_rules_content/3` (Art 47(2)).** The same five-clause shape is used, over `content_point(_, Key, _)` for the false and absent keys and over `content_judgement(Key)` for the unsure keys.

- **Limb 1.** `content_incomplete` with `[cite(eu_reg_2016_679_art_47_2)]`. The citation is the same whatever points are false.
- **Limb 2.** `indeterminate([Key])` naming the first absent point in order (a) to (n), with `[]`.
- **Limb 3.** `needs_legal_review(open_textured(rules_specify_appropriate_data_protection_training, cite(eu_reg_2016_679_art_47_2_n)), [inputs_relied_on([rules_specify_appropriate_data_protection_training-unsure])])` with `[]`.
- **Limb 4.** `content_complete` with the fifteen citations from `complete_content_citations/1`.

**R10, `binding_corporate_rules_content_checklist/2` (Art 47(2)(a)-(n)).** The clauses are disjoint:

- When the input check gives `Problems = [_|_]`, the answer is `input_problems(Problems)`.
- When the input check gives `[]`:
  1. `findall(Key, content_point(_, Key, _), Keys)` lists the keys. This builds atoms, not items.
  2. `maplist(point_checklist_item(Profile), Keys, Items)` builds the items. The head is `point_checklist_item(Profile, Key, checklist_item(Key, cite(Citation), State))`. It looks up `content_point(_, Key, Citation)` and then calls `point_state/3`.
- `point_state/3` has four disjoint clauses:
  - `profile_lacks` gives `open_by_absence`;
  - `true` gives `met`;
  - `false` gives `unmet`;
  - `unsure` gives `open_by_judgement`.
  - `unsure` passes the type check only on point (n).
- The checklist always lists all fourteen items. It names no missing key and refers nothing.

### Verdict atoms of this slice

- `binding_corporate_rules`, `not_binding_corporate_rules`, `content_complete`, `content_incomplete`.
- The STATE atoms `met`, `unmet`, `open_by_absence`, `open_by_judgement`.
- The status compounds listed above.

### Predicates shared with another slice (to kernel.clausal)

None. This is the only slice.

### Style constraints for the author

- No `!`, no `->`, no `*->`.
- Verdicts are folded into the heads (C17).
- One goal per line.
- Variables are full CamelCase words: `Profile`, `Problems`, `FalseKeys`, `AbsentKeys`, `UnsureKeys`, `Pairs`, `Element`, `ElementKey`.
- There are no abbreviated name segments. The citation atoms are lexicon-canonical and are kept verbatim.
- `unmet/1` and `unknown/1` are not imported, to avoid a bare atom beside a same-name compound of arity 1.

## Fixtures (fixtures.clausal; each row states the expected answers of all three queries)

1. **`fixture_all_elements_and_points_true`**: all twenty-one keys `true`. Expected: `binding_corporate_rules` / `content_complete` with fifteen citations / fourteen `met`.
2. **`fixture_transfers_inside_union_only`**: `policies_cover_transfers_to_third_countries` false, all else true. Expected: `not_binding_corporate_rules` / `content_complete`.
3. **`fixture_false_element_beats_absent`**: `policies_adhered_to_by_adhering_party` false, other definition keys absent. Expected: `not_binding_corporate_rules`.
4. **`fixture_first_absent_named_while_judgement_unsure`**: keys 1, 2 and 5 true; `adhering_party_is_controller_or_processor` unsure; keys 4, 6 and 7 absent. Expected: `indeterminate([adhering_party_established_on_territory_of_member_state])`.
5. **`fixture_definition_judgements_unsure`**: the seven keys present; adhering-party role and group unsure; recipients true. Expected: `needs_legal_review(open_textured(adhering_party_is_controller_or_processor, cite(eu_reg_2016_679_art_4_20)), [inputs_relied_on([adhering_party_is_controller_or_processor-unsure, recipients_are_controllers_or_processors-true, transfers_within_group_of_undertakings_or_group_of_enterprises-unsure])])`.
6. **`fixture_principles_point_covered_in_part`**: point (d) false, all else true. Expected: `content_incomplete` / checklist (d) `unmet`.
7. **`fixture_false_point_beats_absent_point`**: point (f) false, points (a) and (b) absent. Expected: `content_incomplete`.
8. **`fixture_first_absent_point_named_while_training_unsure`**: point (c) absent, (n) unsure, others true. Expected: `indeterminate([rules_specify_legally_binding_nature])` / checklist (c) `open_by_absence`, (n) `open_by_judgement`.
9. **`fixture_training_appropriateness_unsure`**: (a)-(m) true, (n) unsure. Expected: `needs_legal_review(open_textured(rules_specify_appropriate_data_protection_training, cite(eu_reg_2016_679_art_47_2_n)), [inputs_relied_on([rules_specify_appropriate_data_protection_training-unsure])])`.
10. **`fixture_training_not_appropriate`**: (n) false. Expected: `content_incomplete`.
11. **`fixture_definition_keys_only`**: the seven keys true, no point keys. Expected: `binding_corporate_rules` / `indeterminate([rules_specify_group_structure_and_contact_details])` / fourteen `open_by_absence`. This fixture checks independence.
12. **`fixture_empty_profile`**: `[]`. Expected: `indeterminate([policies_are_personal_data_protection_policies])` / `indeterminate([rules_specify_group_structure_and_contact_details])` / fourteen `open_by_absence`.
13. **Input-problem fixtures**:
    - a crisp key `unsure` gives `wrong_type(KEY)`;
    - `attested(true)` on a judgement gives `wrong_type(KEY)`;
    - a repeated key gives `duplicate_key(KEY)` only;
    - an extra key `colour` appearing twice gives one `unknown_key(colour)`;
    - a non-list, a partial list or an element `foo` gives `[wrong_type(profile)]`;
    - an unbound value gives `wrong_type(KEY)`;
    - a mixed case checks the order of problems: contract-key order first, then unknown keys in order of first occurrence.

## Test plan (the scaffold's seven test modes; tests collect ALL solutions)

- **Per-limb unit tests.** Each limb of each query is tested on the fixtures, with `findall(Result-Citations, Query, All)` and `All == [Expected]`. This checks exactly one solution.
- **Negative tests.** Every negative (`fail`) test is paired with a positive test over the same case.
- **Property tests** (`validate_props`):
  - totality and determinism over generated profiles, including absent, false and unsure on every key;
  - citation completeness, checked with `bad_citation/1` against `citation_vocabulary`;
  - missing-key coverage for the twenty-one keys;
  - independence: perturbing a key the query does not read leaves the answer unchanged.
- **Input-check robustness.** An unbound profile, a partial list, variable keys and variable values each give exactly one solution, with no exception.
- **What-if routing.** Overrides are tested for each of the three routes.

## Planned reuse (manifest `uses:`)

- **`formalize_lib`**: `profile_get/3`, `profile_lacks/2`, `profile_has/2`, `profile_set/3` (what_if), `attribute/2`. The import is restricted. NOT imported: `unmet/1` and `unknown/1` (atom-shadowing with the STATE atom `unmet`). NOT used: `assess/6` and `eval_requirements/4` (the contract fixes a different item shape) and `check_tri/4` (no per-key Kleene status is computed).
- **`validate_props`** (tests only): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- **Built-ins**: `findall/3`, `maplist/3`, `nonvar/1`, `var/1`, `atom/1`, `==/2`, `\+/1`.
- **Not used, with reasons**:
  - `kit.compliance_lib`: its modality lattice does not fit a content-presence conjunction.
  - `kit.deadline_lib` and `date_time`: there are no dates.
  - `country`: third country is a caller fact.
  - `kit.query_combinators`: `override_key` works on dicts, and the profile is an attribute list.
  - The remaining kit modules are irrelevant to this order.
- **Family backbone (`_common`)**: none needed beyond formalize_lib. The conjunctive-gate helper is local and is noted in the working notes (not published) as a candidate kit module.
