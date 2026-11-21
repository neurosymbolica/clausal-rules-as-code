# SIGNATURE — eu/nis2_jurisdiction_registration

## Public query surface (overview)

The five scored queries are named exactly as in the INTERFACE (non-negotiable):

- `jurisdiction_basis/3`
- `main_establishment_rule/3`
- `registry_submission_items/2`
- `entity_list_submission_items/2`
- `change_notification_limits/2`

They are joined by the input check `nis2_jurisdiction_registration_input_problems/2`.

The scaffold facade is kept:

- `decide_nis2_jurisdiction_registration(PROFILE, nis2_jurisdiction_registration_verdict(STATUS, CITATIONS))`
- `nis2_jurisdiction_registration_status(PROFILE, STATUS)`
- `nis2_jurisdiction_registration_checklist(PROFILE, CHECKLIST)`
- `nis2_jurisdiction_registration_what_if(PROFILE, KEY, VALUE, VERDICT)`
- the fixtures

Totality and determinism: every public predicate yields exactly ONE solution for every ground PROFILE, including malformed ones. There is one clause per disjoint route, with no cut, no if-then-else and no once/findall de-duplication of answers. No figure is imported; the two statutory periods are owned by the slice.

## Verdict STATUS atoms (replace the placeholders `satisfied` / `not_satisfied`)

The facade question is: is this entity's NIS 2 jurisdiction and registration position settled by the formalized law?

| STATUS | Label role | Meaning |
|---|---|---|
| `registration_position_settled` | positive (eligible) | Every checklist item is met. The basis names one Member State by rule, and all lists are final. |
| `registration_position_open` | indeterminate | Some item is `unknown([Key])`: a key is absent, or an unsure judgement is handed to the user or lawyer. |
| `no_single_member_state_jurisdiction` | negative (ineligible) | The basis is `no_rule_in_article_26` or `any_member_state_where_services_are_provided_may_take_legal_action`. |
| `profile_rejected` | before labels | The input check found problems. CITATIONS is `[]` and CHECKLIST is `[]`. |

The labels term is `labels(registration_position_settled, registration_position_open, no_single_member_state_jurisdiction)`. The bare atom `indeterminate` is never a STATUS.

## Profile keys (eight, in root_exports / input_contract order)

Each entry gives the key, its type, its values and its source.

1. `entity_category` — enumeration.
   - Values: `general_entity`, `public_electronic_communications_provider`, `main_establishment_provider`, `public_administration_entity`.
   - Source: Art 26(1).
2. `established_in_union` — crisp `true` / `false`. Source: Art 26(3).
3. `offers_services_in_union` — crisp `true` / `false`. Source: Art 26(3).
4. `representative_designated_in_union` — crisp `true` / `false`. Source: Art 26(3).
5. `decisions_predominantly_taken_in_one_union_member_state` — judgement `true` / `false` / `unsure`. Source: Art 26(2).
6. `cybersecurity_operations_carried_out_in_one_union_member_state` — judgement `true` / `false` / `unsure`. Source: Art 26(2).
7. `sector_and_subsector_applicable` — crisp `true` / `false`. Source: Art 27(2)(b), Art 3(4)(c).
8. `member_states_list_applicable` — crisp `true` / `false`. Source: Art 3(4)(d).

No numeric keys and no dates are used. PROFILE is `[attribute(Key, Value), ...]`, read only with `formalize_lib:profile_get/3`, `profile_has/2` and `profile_lacks/2`. Presence is tested first, then the value.

## Citation-key atoms (canonical lexicon; set-like lists of cite(Key))

Art 26:

- `eu_dir_2022_2555_art_26_1`
- `eu_dir_2022_2555_art_26_1_a`
- `eu_dir_2022_2555_art_26_1_b`
- `eu_dir_2022_2555_art_26_1_c`
- `eu_dir_2022_2555_art_26_2`
- `eu_dir_2022_2555_art_26_3`

Art 27:

- `eu_dir_2022_2555_art_27_2_a` … `eu_dir_2022_2555_art_27_2_f` (points a–f)
- `eu_dir_2022_2555_art_27_3`

Art 3:

- `eu_dir_2022_2555_art_3_4`
- `eu_dir_2022_2555_art_3_4_a` … `eu_dir_2022_2555_art_3_4_d` (points a–d)

All of these live in citations.clausal (`citation_vocabulary/1`, canonical scheme from `_lexicon/citations.yaml`). Art 3(3), 27(1) and 27(5) are documented in NOTES.md but are emitted by no query. No other atom is invented.

## Public predicates

### The input check and the five scored queries

- `nis2_jurisdiction_registration_input_problems(Profile, Problems)`
  - Problems is the BARE list, `[]` when well-formed.
  - For a non-attribute list it is `[wrong_type(profile)]`.
  - Otherwise, for each of the eight keys in contract order: `duplicate_key(Key)` if it repeats, else `wrong_type(Key)` if its value is outside its type.
  - Then `unknown_key(Key)` once per non-contract key, in order of first occurrence.
  - Citation: input contract (no legal cite).
- `jurisdiction_basis(Profile, Basis, Citations)`
  - Basis is one of seven atoms, `indeterminate([Key])` or `input_problems(Problems)`.
  - Implements steps (0)–(7). Citations is `[]` when not final.
  - Citation: Art 26(1), 26(1)(a)–(c), 26(2), 26(3).
- `main_establishment_rule(Profile, Result, Citations)`
  - Result is one of:
    - `state_where_cybersecurity_risk_management_decisions_are_taken`
    - `state_where_cybersecurity_operations_are_carried_out`
    - `state_of_establishment_with_most_employees_in_the_union`
    - `indeterminate([Key])`
    - `needs_legal_review(open_textured(Key, cite(eu_dir_2022_2555_art_26_2)), [inputs_relied_on(Pairs)])`
    - `input_problems(Problems)`
  - Implements steps (0), (8), (9).
  - Citation: Art 26(2).
- `registry_submission_items(Profile, Items)`
  - Items is the ordered `item(Name, cite(Key))` list, `[]` for non-point-(b) categories, or a status compound alone.
  - Implements steps (0), (10)–(12).
  - Citation: Art 27(1), 27(2)(a)–(f).
- `entity_list_submission_items(Profile, Items)`
  - Items is the ordered `item(Name, cite(Key))` list or a status compound alone.
  - Implements steps (0), (13)–(14). `entity_category` is not read.
  - Citation: Art 3(4)(a)–(d).
- `change_notification_limits(Profile, Limits)`
  - Limits is the ordered `limit(Regime, Period, cite(Key))` list or a status compound alone.
  - Implements steps (0), (15)–(17).
  - Citation: Art 27(3), Art 3(4) second subparagraph.

### Facade

- `decide_nis2_jurisdiction_registration(Profile, Verdict)`
  - Verdict is `nis2_jurisdiction_registration_verdict(Status, Citations)`.
  - Citations is the sorted, de-duplicated union of the checklist item citations, or `[]` for `profile_rejected`.
  - Citation: all of the above.
- `nis2_jurisdiction_registration_status(Profile, Status)`: the STATUS of the verdict only.
- `nis2_jurisdiction_registration_checklist(Profile, Checklist)`
  - Checklist is the `formalize_lib` `item(RequirementId, Status, Citations)` list. Each item carries its cite(...) list, met items included (query type #7).
  - It is `[]` for `profile_rejected`.
- `nis2_jurisdiction_registration_what_if(Profile, Key, Value, Verdict)`
  - Implemented as `kit/query_combinators:what_if(Profile, Key, Value, decide_nis2_jurisdiction_registration, Verdict)`.
  - The verdict is taken after the override; an override may itself create an input problem, and the verdict then reports it.
- `nis2_jurisdiction_registration_fixture(Name, Profile)` and `nis2_jurisdiction_registration_fixture_expected(Name, Query, Expected)`: the named fixture profiles and their expected scored answers (see fixtures below).

### Result constructors

These are exported but never called as queries:

- Status compounds: `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2` (never emitted).
- Input problems: `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.
- List terms: `item/2`, `limit/3`, `months_after_change/1`, `weeks_after_change/1`.

## Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2` for all key reads.
  - `assess/6`, `labels/3`, `item/3`, `unmet/1`, `unknown/1`, `decide_labeled/3` for the facade verdict.
  - `memberd/2`, `not_member/2` for type and occurrence tests in the input check.
- `kit/query_combinators`: `what_if/5` for `nis2_jurisdiction_registration_what_if/4`.
- `validate_props` (tests only): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- NOT used, with reasons:
  - `kit/deadline_lib`: the limits are not computed.
  - `country`: no Member State is named.
  - `library(datetime)`: no date is read.
  - `check_tri/4`: the Art 26(2) cascade with reading (10) is not a single tri-valued check, and a tri-state key never becomes a crisp test.

## Layout

The package layout is kept unchanged: kernel → citations → parameters → nis2_jurisdiction_registration → queries → fixtures → package facade.

- **kernel.clausal:** keeps only the shared floor: the result-constructor declarations and the `attribute/2` import. There is only ONE determination slice, so NO predicate needs sharing and nothing else moves into the kernel.
- **citations.clausal:** `citation_vocabulary/1` with the atoms listed above.
- **parameters.clausal:** holds no statutory figure (the values live in the slice). It keeps its scaffold module and exports.
- **queries.clausal:** the facade's requirement/4, the assess/6 call and the what_if wrapper.
- **fixtures.clausal:** the fixtures listed below.

## Slice: nis2_jurisdiction_registration.clausal

### Value facts owned by this slice

- `:- constant_value(registry_change_notification_months, 3).` (Art 27(3))
- `:- constant_value(entity_list_change_notification_weeks, 2).` (Art 3(4) second subparagraph)

These are read with `constant(Name)` when building `months_after_change(3)` and `weeks_after_change(2)`. The integers are never inlined in a rule.

### Contract tables owned by this slice

- `contract_key(Key, Type)` in root_exports order, with Type one of `enumeration(Atoms)`, `crisp` or `judgement`.
- `basis_atom/1`, `main_establishment_result/1`, `registry_item_name/1` and `list_item_name/1` for the closed vocabularies.

### Input check

- `nis2_jurisdiction_registration_input_problems/2` follows THE INPUT CHECK.
- **Malformed profile.** It has two disjoint top routes:
  - not a proper list of `attribute(_, _)` gives `[wrong_type(profile)]`;
  - an attribute list gives the per-key problems, then the unknown keys.
- **Contract keys.** For each contract key the occurrence count is computed:
  - count 0: no problem;
  - count 1 with the value in type: no problem;
  - count 1 with the value out of type: `wrong_type(Key)`;
  - count 2 or more: `duplicate_key(Key)`, with its values not read.
- **Unknown keys.** These are collected in order of first occurrence and de-duplicated.
- **Uniqueness for later steps.** After a clean check every present key occurs once, so `profile_get/3` yields one value.

### Rules (each query routes first on Problems = [] versus Problems = [_|_])

Each query has two top routes on the input check:

- Problems non-empty: the query gives `input_problems(Problems)`, with Citations `[]` where it has Citations.
- Problems empty: the query applies the steps below.

**JURISDICTION_BASIS** has one clause per disjoint route, keyed on presence and value:

- (1) `entity_category` absent: `indeterminate([entity_category])`.
- (2) `general_entity`: `state_of_establishment`, `[cite(eu_dir_2022_2555_art_26_1)]`.
- (3) `public_electronic_communications_provider`: `state_where_services_are_provided`, `[cite(eu_dir_2022_2555_art_26_1_a)]`.
- (4) `public_administration_entity`: `state_that_established_the_entity`, `[cite(eu_dir_2022_2555_art_26_1_c)]`.
- (5) `main_establishment_provider`:
  - `established_in_union` absent: `indeterminate([established_in_union])`.
  - `established_in_union` true: `state_of_main_establishment`, `[cite(eu_dir_2022_2555_art_26_1_b), cite(eu_dir_2022_2555_art_26_2)]`.
- (6) `established_in_union` false:
  - `offers_services_in_union` absent: `indeterminate([offers_services_in_union])`.
  - `offers_services_in_union` false: `no_rule_in_article_26`, `[cite(eu_dir_2022_2555_art_26_3)]`.
- (7) `offers_services_in_union` true:
  - `representative_designated_in_union` absent: `indeterminate([representative_designated_in_union])`.
  - true: `state_of_representative`, `[cite(eu_dir_2022_2555_art_26_3)]`.
  - false: `any_member_state_where_services_are_provided_may_take_legal_action`, `[cite(eu_dir_2022_2555_art_26_3)]`.

**MAIN_ESTABLISHMENT_RULE** uses D = `decisions_predominantly_taken_in_one_union_member_state` and O = `cybersecurity_operations_carried_out_in_one_union_member_state`.

Step (8), D absent or not false:

- D absent: `indeterminate([D])`, Citations `[]`. O is not named.
- D true: `state_where_cybersecurity_risk_management_decisions_are_taken`, `[cite(eu_dir_2022_2555_art_26_2)]`.
- D unsure and O absent: `indeterminate([O])`, Citations `[]`.
- D unsure and O present (any value): `needs_legal_review(open_textured(D, cite(eu_dir_2022_2555_art_26_2)), [inputs_relied_on([D-unsure])])`, Citations `[]`.

Step (9), D false:

- O absent: `indeterminate([O])`, Citations `[]`.
- O true: `state_where_cybersecurity_operations_are_carried_out`, `[cite(eu_dir_2022_2555_art_26_2)]`.
- O unsure: `needs_legal_review(open_textured(O, cite(eu_dir_2022_2555_art_26_2)), [inputs_relied_on([D-false, O-unsure])])`, Citations `[]`.
- O false: `state_of_establishment_with_most_employees_in_the_union`, `[cite(eu_dir_2022_2555_art_26_2)]`.

The PAIRS are built by a local `pairs_relied_on/3` that follows THE PAIRS RULE. `entity_category` and `established_in_union` are not read (Q10).

**REGISTRY_SUBMISSION_ITEMS:**

- (10) `entity_category` absent: `indeterminate([entity_category])`. Any other non-point-(b) category: `[]`.
- (11) `main_establishment_provider`: the first absent needed key, in root_exports order, among:
  - `established_in_union`;
  - `representative_designated_in_union`, only if established is false;
  - `sector_and_subsector_applicable`.
  The answer is `indeterminate([Key])`. Because `established_in_union` is read first, `representative_designated_in_union` is never named while `established_in_union` is absent.
- (12) Otherwise the ordered list is built by appending fixed segments chosen by disjoint clause heads (no conditionals):
  - `entity_name` (a);
  - [`sector_subsector_and_type_of_entity` (b)];
  - `address_of_main_establishment_and_other_legal_establishments_in_the_union` (c) | `address_of_representative` (c) | nothing;
  - `contact_details_of_entity` (d);
  - [`contact_details_of_representative` (d)];
  - `member_states_where_services_are_provided` (e);
  - `ip_ranges` (f).

**ENTITY_LIST_SUBMISSION_ITEMS:**

- (13) `sector_and_subsector_applicable` absent gives `indeterminate([sector_and_subsector_applicable])`. Otherwise, `member_states_list_applicable` absent gives `indeterminate([member_states_list_applicable])`.
- (14) Otherwise the ordered list:
  - `entity_name` (3(4)(a));
  - `address_and_contact_details_including_email_addresses_ip_ranges_and_telephone_numbers` (b);
  - [`sector_and_subsector` (c)];
  - [`member_states_where_services_in_scope_are_provided` (d)].

**CHANGE_NOTIFICATION_LIMITS:**

- (15) `entity_category` absent: `indeterminate([entity_category])`.
- (16) `main_establishment_provider`: `[limit(registry_information, months_after_change(3), cite(eu_dir_2022_2555_art_27_3)), limit(entity_list_information, weeks_after_change(2), cite(eu_dir_2022_2555_art_3_4))]`.
- (17) Any other category: `[limit(entity_list_information, weeks_after_change(2), cite(eu_dir_2022_2555_art_3_4))]`.

### Verdict atoms produced by this slice

- **Seven basis atoms:**
  - `state_of_establishment`
  - `state_where_services_are_provided`
  - `state_that_established_the_entity`
  - `state_of_main_establishment`
  - `state_of_representative`
  - `any_member_state_where_services_are_provided_may_take_legal_action`
  - `no_rule_in_article_26`
- **Three main establishment results:** the three listed under step (8) and step (9).
- **Status compounds:** `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`.
- **List terms:** `item/2` and `limit/3`.

### Facade requirements (requirement/4, RequirementId FIRST)

The facade lives in queries.clausal and reads only the slice's public answers. Each requirement has three mutually exclusive clauses: met, unmet and unknown.

- **`jurisdiction_basis_settled`**
  - met: the basis is one of the five single-state bases.
  - unmet: `unmet(basis_names_no_single_member_state(Basis))` for `no_rule_in_article_26` or the legal-action basis.
  - unknown: `unknown([Key])` from `indeterminate([Key])`.
  - Citations: the basis citations when final, else `[cite(eu_dir_2022_2555_art_26_1)]`.
- **`main_establishment_located`**
  - Included in the ids ONLY when the basis is `state_of_main_establishment`.
  - met: one of the three results.
  - unknown: `unknown([Key])` from `indeterminate([Key])`, or from `needs_legal_review(open_textured(Key, _), _)`. In the latter case the unsure judgement is handed to the user.
  - Citations: `[cite(eu_dir_2022_2555_art_26_2)]`.
- **`registry_items_settled`**
  - met: a list.
  - unknown: `unknown([Key])`.
  - Citations: the six `art_27_2` points.
- **`entity_list_items_settled`**
  - met: a list.
  - unknown: `unknown([Key])`.
  - Citations: the four `art_3_4` points.
- **`change_limits_settled`**
  - met: a list.
  - unknown: `unknown([Key])`.
  - Citations: `[cite(eu_dir_2022_2555_art_27_3), cite(eu_dir_2022_2555_art_3_4)]`.

The facade has two disjoint routes. With input problems it gives `profile_rejected`. With a clean profile it calls `assess(Profile, RequirementIds, Profile, requirement, labels(registration_position_settled, registration_position_open, no_single_member_state_jurisdiction), Result)`.

### Shared with another slice

None. This is the only determination slice, so nothing moves to kernel.clausal.

### Fixtures (fixtures.clausal) and per-rule tests

1. `general_entity_minimal`: `[entity_category-general_entity]`.
   - basis `state_of_establishment`.
   - registry `[]`.
   - list `indeterminate([sector_and_subsector_applicable])`.
   - limits: the list limit only.
   - facade open.
2. `electronic_communications_complete`: basis `state_where_services_are_provided`; facade settled.
3. `public_administration_complete`: basis `state_that_established_the_entity`.
4. `cloud_provider_established_decisions_true`, all keys present:
   - basis `state_of_main_establishment` with the 26(1)(b) and 26(2) citations.
   - main establishment: the decisions step.
   - registry: all seven items, with the establishment address.
   - list: four items.
   - limits: two.
   - facade settled.
5. `cloud_provider_outside_union_representative`:
   - basis `state_of_representative`.
   - registry: the representative address and the representative contact details.
6. `cloud_provider_outside_union_no_representative`:
   - basis: the legal-action atom.
   - registry: no address item.
   - facade `no_single_member_state_jurisdiction`.
7. `cloud_provider_outside_union_no_services`: basis `no_rule_in_article_26`.
8. `decisions_unsure_operations_absent`: main establishment `indeterminate([cybersecurity_operations_carried_out_in_one_union_member_state])`.
9. `decisions_unsure_operations_false`: main establishment `needs_legal_review` on D, PAIRS `[D-unsure]`.
10. `decisions_false_operations_unsure`: main establishment `needs_legal_review` on O, PAIRS `[D-false, O-unsure]`.
11. `decisions_false_operations_false`: main establishment `state_of_establishment_with_most_employees_in_the_union`.
12. `category_absent`: basis, registry and limits each `indeterminate([entity_category])`.
13. `provider_established_absent`: registry `indeterminate([established_in_union])`, even with `representative_designated_in_union` also absent.
14. `duplicate_and_wrong_type`: duplicate `established_in_union` with differing values, plus `entity_category` given `foo`.
    - problems `[wrong_type(entity_category), duplicate_key(established_in_union)]`.
    - every query gives `input_problems`.
15. `unknown_keys_repeated`: problems `[unknown_key(head_office), unknown_key(employee_count)]`, in first-occurrence order and de-duplicated.
16. `not_an_attribute_list` (an atom) and `non_attribute_element` (a list holding `foo(bar)`): problems `[wrong_type(profile)]`.
17. `crisp_given_unsure`: problems `[wrong_type(sector_and_subsector_applicable)]`.

Tests across the seven modes include:

- per-limb unit tests for every step (0)–(17);
- COUNTING tests: `findall` + `length(Solutions, 1)` for every query on every fixture;
- each negative test paired with a positive test over the same case;
- `validate_props` totality, determinism, citation completeness and missing-key coverage over the fixture generator;
- a `bad_citation/1` scan against `citation_vocabulary/1`;
- what_if flips:
  - `established_in_union` true → false on fixture 4 flips the verdict to open;
  - D unsure → true on fixture 9 settles the main establishment.
