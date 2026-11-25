# SIGNATURE — eu/dora_ctpp_designation

## 1. Public query surface

The package layout is unchanged: kernel -> citations -> parameters -> dora_ctpp_designation (the one determination slice) -> queries -> fixtures -> package facade.

The contract queries all take `PROFILE` (an attribute list read only via `profile_get/3`).

Every call of every public predicate yields EXACTLY ONE solution:
- disjoint clause routes;
- no `!`, `->` or `*->`;
- no `once/1` used to hide duplicates;
- witnesses are collapsed by `findall` + `sort`, or by ground computation, before an answer is built.

No public predicate returns a float, a string or a record.

Lines are in the form `predicate(ArgumentOne, ArgumentTwo, ...): description — citation`.

- `ctpp_designation_criteria_status(Profile, Result, Citations)`: limbs A0-A9 — Art 31(1)(a), (2), (3), (8)(i)-(iv); Reg 2024/1502 Arts 1(1), 1(2), 2(1), 2(4), 3(1)-(3), 5(1), 5(4).
- `ctpp_step_1_indicators(Profile, Result, Citations)`: limbs B0-B2. Result `step_1_indicators(Met)` — Art 31(2), (3); Reg 2024/1502 Arts 1(1), 2(1)-(4), 3(1)-(3), 5(1)-(4).
- `ctpp_lead_overseer(Profile, Result, Citations)`: limbs C0-C2 — Art 31(1)(b).
- `ctpp_designated_provider_duties(Profile, Result, Citations)`: limbs D0-D5 — Art 31(1)(a), (4), (5) last sentence, (13).
- `dora_ctpp_designation_input_problems(Profile, Problems)`: THE INPUT CHECK. It never fails and never raises. No citation.

The scaffold facade names are kept (query types #2 eligibility and #7 justification):

- `decide_dora_ctpp_designation(Profile, Verdict)`: `Verdict = dora_ctpp_designation_verdict(Status, Citations)`, where `(Status, Citations)` is exactly the `(Result, Citations)` of `ctpp_designation_criteria_status/3`. It cites as that predicate does.
- `dora_ctpp_designation_status(Profile, Status)`: the Status of the verdict alone.
- `dora_ctpp_designation_checklist(Profile, Checklist)`: a cited checklist built with `eval_requirements/4` over the slice's `requirement/4`. Each item is `item(RequirementId, ItemStatus, cite(Key))`, and ItemStatus is `met`, `unmet(Reason)` or `unknown([Key])`. Met items are cited too. A profile with input problems gives `[]`. The checklist is explanatory; the verdict is governed by the limbs and is NOT computed by `decide_labeled/3`, so the two can never diverge.
- `dora_ctpp_designation_what_if(Profile, Key, Value, Status)`: calls `profile_set(Profile, attribute(Key, Value), Revised)` and then `dora_ctpp_designation_status(Revised, Status)`.
- Fixtures (`fixtures.clausal`): `dora_ctpp_designation_fixture(Name, Profile)`, and `dora_ctpp_designation_fixture_expected(Name, Query, Result, Citations)`. The fixture names are listed in section 7.

Result constructors are exported and never called as queries:

```text
designation_not_applicable/1  step_1_indicators/1  sub_criteria_1_1_and_1_2/1
sub_criterion_4_1/1           sub_criterion_4_2/1  lead_overseer/1
lead_overseer_tied/1          required/1           indeterminate/1
input_problems/1              unknown_key/1        wrong_type/1
duplicate_key/1
```

## 2. Verdict STATUS atoms

These replace the scaffold `eligible`/`ineligible` placeholders.

Eligibility mapping:
- `step_1_sub_criteria_fulfilled` is the eligible analogue: the provider proceeds to the ESAs' step 2. It is NOT a designation.
- `step_1_sub_criteria_not_fulfilled` is the ineligible analogue.
- The excluded routes are `designation_not_applicable(Ground)`, with Ground one of `financial_entity`, `article_127_2_tfeu_oversight_framework`, `ict_intra_group_service_provider`, `single_member_state_provider`; and `not_an_ict_third_party_service_provider`.
- Status compounds: `indeterminate([Key])` (exactly one key) and `input_problems(Problems)`.

verdict_vocabulary:

```text
step_1_sub_criteria_fulfilled, step_1_sub_criteria_not_fulfilled,
designation_not_applicable, not_an_ict_third_party_service_provider,
financial_entity, article_127_2_tfeu_oversight_framework,
ict_intra_group_service_provider, single_member_state_provider,
step_1_indicators, sub_criteria_1_1_and_1_2, sub_criterion_2_1,
sub_criterion_2_2, sub_criterion_4_1, sub_criterion_4_2,
lead_overseer, lead_overseer_tied, eba, eiopa, esma,
not_designated_as_critical, required, designate_coordination_point,
notify_financial_entities_of_designation,
notify_lead_overseer_of_subsidiary_management_changes,
indeterminate, input_problems, duplicate_key, wrong_type, unknown_key
```

The bare atom `indeterminate` is never a result (atom-shadowing trap). The atoms `true` and `false` are never pinned in the vocabulary.

## 3. Profile keys

There are seventeen keys, in root_exports / input_contract order. Their names are fixed by the contract and are not renamed.

1. `dora_entity_type`: an enumeration with twenty-eight values — the twenty-seven atoms of THE SHARED TYPE SET plus `none_of_the_listed_types`.
2. `provider_subject_to_article_127_2_tfeu_oversight_framework`: boolean (`true`/`false` atoms).
3. `provider_is_ict_intra_group_service_provider`: boolean.
4. `provider_provides_ict_services_solely_in_one_member_state`: boolean.
5. `financial_entities_served_are_active_only_in_that_member_state`: boolean.
6. `systemic_impact_figures`: a list of `category_share_figures(Category, EntitiesServed, EntitiesTotal, AssetsServed, AssetsTotal)` records. Counts are integers; assets are whole euro.
7. `g_sii_served_count`: non-negative integer.
8. `o_sii_scores_of_o_siis_served`: a list of non-negative integers (O-SII scores).
9. `systemic_infrastructure_entities_served_count`: non-negative integer.
10. `systemic_other_entities_served_count`: non-negative integer.
11. `substitutability_figures`: a list of `category_substitutability_figures(Category, EntitiesWithoutAlternative, EntitiesHighlyDifficultToMigrate, EntitiesTotal)` records.
12. `total_assets_of_users_within_eba_responsibility`: non-negative integer, whole euro.
13. `total_assets_of_users_within_eiopa_responsibility`: non-negative integer, whole euro.
14. `total_assets_of_users_within_esma_responsibility`: non-negative integer, whole euro.
15. `provider_designated_as_critical`: boolean.
16. `provider_is_part_of_a_group`: boolean.
17. `provider_established_in_third_country`: boolean.

Numeric units: every figure is an integer. Money is whole euro, which is the integer unit fixed by reading (7). No dates are read.

## 4. Citation-key atoms

These are the canonical lexicon spellings, declared in `citations.clausal`, and form `citation_vocabulary`:

```text
eu_reg_2022_2554_art_31_1_a, eu_reg_2022_2554_art_31_1_b, eu_reg_2022_2554_art_31_2,
eu_reg_2022_2554_art_31_3, eu_reg_2022_2554_art_31_4, eu_reg_2022_2554_art_31_5,
eu_reg_2022_2554_art_31_8, eu_reg_2022_2554_art_31_8_i, eu_reg_2022_2554_art_31_8_ii,
eu_reg_2022_2554_art_31_8_iii, eu_reg_2022_2554_art_31_8_iv, eu_reg_2022_2554_art_31_13,
eu_reg_2024_1502_art_1_1, eu_reg_2024_1502_art_1_2, eu_reg_2024_1502_art_2_1,
eu_reg_2024_1502_art_2_2, eu_reg_2024_1502_art_2_3, eu_reg_2024_1502_art_2_4,
eu_reg_2024_1502_art_3_1, eu_reg_2024_1502_art_3_2, eu_reg_2024_1502_art_3_3,
eu_reg_2024_1502_art_5_1, eu_reg_2024_1502_art_5_2, eu_reg_2024_1502_art_5_3,
eu_reg_2024_1502_art_5_4
```

Fixed citation lists, one per final RESULT:

| Result | Citations |
|---|---|
| A2 | `[_31_8, _31_8_i]` |
| A3 | `[_31_1_a]` |
| A4 | `[_31_8, _31_8_ii]` |
| A6 | `[_31_8, _31_8_iii]` |
| A9 (iv) | `[_31_8, _31_8_iv]` |
| A9 fulfilled / not fulfilled | the same twelve: `31_1_a`, `31_2`, `31_3`, `1502` arts `1_1`, `1_2`, `2_1`, `2_4`, `3_1`, `3_2`, `3_3`, `5_1`, `5_4` |
| B2 | fourteen: `31_2`, `31_3`, `1502` arts `1_1`, `2_1`, `2_2`, `2_3`, `2_4`, `3_1`, `3_2`, `3_3`, `5_1`, `5_2`, `5_3`, `5_4` |
| C2 | `[_31_1_b]` |
| D1 | `[_31_1_a]` |
| D5 | one citation per duty present: `_31_4`, `_31_5`, `_31_13` |

Every status compound has `[]`.

## 5. Planned reuse (manifest `uses:`)

- **formalize_lib**: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `profile_keys/2`, `eval_requirements/4`, `item/3`, `unmet/1`, `unknown/1`, `memberd/2`, `not_member/2`, `sum_list/2`, `int_max/3`, `and_status/2`, `or_status/2`; and the vocabulary atom `met`.
  - `ratio_bps/4` and `check_ratio_gte/6` read profile KEYS, not record arguments, so they are not usable for the per-record shares.
  - The 10 % test is a direct multiplication with NO division (`N * 10000 >= D * #share_minimum_basis_points`). It is therefore not a clone of ratio_bps (C14).
  - `required_numerator_gte/3` may replace it if its ceiling semantics is verified exact.
- **validate_props**: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `bad_citation/1` (tests).
- **list_item/3** (built-in): positional lookup into the shared type set, used for ordering categories.
- **kit.query_combinators**: not imported. `what_if/5` overrides dict keys, and this profile is an attribute list, so `profile_set/3` is used instead.
- Not used: `country` (no country key); `deadline_lib`, `date_time` and `rolling_window` (no date is read); `currency_vocab` (euro is implicit and whole); `compliance_lib`.

## 6. kernel.clausal (shared floor)

This holds only what the queries layer, the facade and the slice all read.

Shared type set:
- `dora_ctpp_designation_shared_type(Atom, Position)`: the twenty-seven atoms, 0-based, in Art 2(1) order.
- `dora_ctpp_designation_financial_entity_type(Atom)`: the twenty-six atoms other than `ict_third_party_service_provider`.
- `dora_ctpp_designation_category_synonym(Synonym, Main)`: two facts, `exempted_payment_institution -> payment_institution` and `exempted_electronic_money_institution -> electronic_money_institution`.
- `dora_ctpp_designation_entity_type_value(Atom)`: the twenty-eight accepted values.

Contract key order:
- `dora_ctpp_designation_contract_key(Key, Position)`, 1-17.
- `dora_ctpp_designation_key_type(Key, Type)`, with Type one of `enumeration`, `boolean`, `non_negative_integer`, `integer_list`, `share_records`, `substitutability_records`.

INPUT CHECK, `dora_ctpp_designation_input_problems(Profile, Problems)`:
- **Not an attribute list** gives `[wrong_type(profile)]`. This covers an unbound or partial list, an unbound element, or any element that is not a nonvar `attribute(_, _)`. Proper-list and element checks use `\+` and `nonvar`/`is_list` only.
- **Contract keys**: the seventeen contract keys are walked in order. Each yields `duplicate_key(Key)` if it occurs twice or more, compared with `==` (no value is read); else `wrong_type(Key)` if its value fails its type; else nothing.
- **Value types**:
  - The ground and nonvar-ness of values is checked first. An unbound value, or a value holding a variable or a partial list, is wrong_type.
  - A non-negative integer must satisfy `integer(V), V >= 0`, so floats are rejected.
  - The records are checked as THE ADDED CHECKS require: the category is a financial-entity atom; every figure is a non-negative integer; each total is >= 1; each numerator is <= its total; and no atom is the category of two records (a main atom beside its synonym is allowed).
- **Unknown keys**: each key not `==` to a contract key yields `unknown_key(Key)` once. Keys are de-duplicated by `==` in order of first occurrence, so distinct variables are distinct keys and the same variable is one key. A key that is not an atom is unknown as given.
- One solution: the input check is built by deterministic recursion with disjoint clauses.

Exact-completion missing-key selector (local; flagged in NOTES for kit extraction):
- `dora_ctpp_designation_first_named_key(Candidates, DecidesAlone, Key)`, where Candidates is a list of `Key-DecidesAloneFlag` in root order.
- It picks the first candidate whose flag is `true` if any has one, else the first candidate.

## 7. parameters.clausal

This layer is empty of statutory figures; the figures live in the slice. It re-exports nothing.

The fixtures listed here are kept in `fixtures.clausal`:

```text
fixture_financial_entity_provider            fixture_not_a_provider
fixture_tfeu_oversight_excluded              fixture_intra_group_excluded
fixture_single_member_state_excluded         fixture_step_1_fulfilled
fixture_step_1_fulfilled_exact_ten_percent   fixture_step_1_fails_impact_split_categories
fixture_step_1_fails_only_2_2                fixture_pooled_payment_institutions
fixture_synonym_alone                        fixture_o_sii_score_exactly_3000
fixture_lead_overseer_eiopa                  fixture_lead_overseer_tied_eba_esma
fixture_duties_group_third_country           fixture_not_designated
fixture_missing_type                         fixture_missing_point_iv
fixture_input_problems_float_and_duplicate   fixture_unbound_key
```

## 8. Slice — dora_ctpp_designation.clausal

### 8.1 Statutory VALUE facts

These are owned here and declared with `:- constant_value(Name, Value).`; they are read only as `#Name`.

| Constant | Value | Source |
|---|---|---|
| `share_minimum_basis_points` | 1000 | 10 %; Reg 2024/1502 Arts 2(4), 5(4) |
| `basis_points_whole` | 10000 | |
| `global_systemically_important_institution_minimum` | 1 | Art 3(2)(a) |
| `other_systemically_important_institution_count_minimum` | 3 | Art 3(2)(b) |
| `other_systemically_important_institution_score_exceeded` | 3000 | strict `>`; Art 3(2)(c) |
| `systemic_infrastructure_entity_minimum` | 1 | Art 3(3)(a) |
| `systemic_other_entity_minimum` | 3 | Art 3(3)(b) |

### 8.2 Rules and requirements

The status predicates are three-valued, `met` / `unmet` / `unknown`, with one clause each and mutually exclusive.

1. **Provider type**: `dora_ctpp_designation_type_route(Profile, Route)`.
   - Route `absent` gives A1.
   - `financial_entity` gives A2. This holds when the type is in `dora_ctpp_designation_financial_entity_type/1`, synonyms included.
   - `not_a_provider` gives A3 (type `none_of_the_listed_types`).
   - `provider` (type `ict_third_party_service_provider`) goes on to A4.
2. **Point (ii)**: true gives A4, absent gives A5, false goes on.
3. **Point (iii)**: true gives A6, absent gives A7, false goes on.
4. **Point (iv)**: `dora_ctpp_designation_point_iv_status(Profile, S)`.
   - `applies` when both facts are true.
   - `not_applies` when either fact is false.
   - `unknown` otherwise.
5. **Pooling and naming**: `dora_ctpp_designation_pooled_share_categories(Records, Pooled)` and `dora_ctpp_designation_pooled_substitutability_categories(Records, Pooled)`.
   - They produce `category(Name, Position, Figures...)`, ordered by the type-set position of Name.
   - A main record plus its synonym record are summed argument by argument and named by the main atom; a lone synonym keeps the synonym's name.
6. **Share test**: `dora_ctpp_designation_share_at_least_minimum(Numerator, Denominator)` holds iff `Numerator * #basis_points_whole >= Denominator * #share_minimum_basis_points`. It is integer-only and exact; 10 % counts.
7. **IMPACT**: `dora_ctpp_designation_impact_categories(Records, Names)` gives the pooled categories with share 1.1 and share 1.2 both at the minimum in the same category (Q2).
   - IMPACT status: met if Names is non-empty, unmet if empty, unknown if the key is absent.
8. **Sub-criterion 2.1** status from `g_sii_served_count` and `o_sii_scores_of_o_siis_served`.
   - The O-SII list fulfils it when its length is >= 3 or some score is > 3000.
   - Met when g >= 1 is present, or the list is present and fulfilling.
   - Unmet when both are present and failing.
   - Unknown otherwise.
9. **Sub-criterion 2.2** status from the infrastructure count (>= 1) and the other count (>= 3), with the same three-valued shape.
10. **SUBSTITUTABILITY**:
    - Categories 4.1 are those where share 4.1 meets the minimum; categories 4.2 likewise for share 4.2.
    - Status: met if either list is non-empty (Q10); unmet if both are empty; unknown if the key is absent.
11. **STEP 1**: the Kleene AND of IMPACT, 2.1, 2.2 and SUBSTITUTABILITY. Any unmet part gives unmet; all met gives met; otherwise unknown.
12. **A8 selector**:
    - Point (iv) `unknown`: name the first absent of the two point (iv) keys.
    - Point (iv) `not_applies` and STEP 1 unknown: the candidates are the absent keys of unknown parts.
    - Decides-alone flag:
      - the two lists: always `true`;
      - g / o: `true` iff the other is present and failing, or IMPACT, 2.2 and SUBSTITUTABILITY are all met;
      - infrastructure / other: symmetric to g / o.
    - Pass the candidates to the kernel selector.
13. **B1 selector**: the first absent figure key, in root order, whose component (impact list, 2.1, 2.2, substitutability list) is unknown.
14. **Indicators MET**: the items in contract order. Items with empty categories are omitted.
15. **Lead Overseer**:
    - The first absent sum gives C1.
    - Otherwise compute the maximum with `int_max/3`.
    - Exactly one ESA at the maximum gives `lead_overseer(Esa)`; two or three give `lead_overseer_tied(Esas)` in eba, eiopa, esma order.
16. **Duties**: D1-D5. The duties list is built in printed order; citations come one per duty.
17. **Checklist requirements**: `requirement(RequirementId, Profile, Status, Citation)`, with RequirementId FIRST.

    | Requirement id | Citation |
    |---|---|
    | `provider_is_not_a_financial_entity` | `eu_reg_2022_2554_art_31_8_i` |
    | `provider_is_an_ict_third_party_service_provider` | `eu_reg_2022_2554_art_31_1_a` |
    | `provider_not_under_article_127_2_oversight_framework` | `eu_reg_2022_2554_art_31_8_ii` |
    | `provider_not_an_ict_intra_group_service_provider` | `eu_reg_2022_2554_art_31_8_iii` |
    | `provider_not_single_member_state_provider` | `eu_reg_2022_2554_art_31_8_iv` |
    | `systemic_impact_sub_criteria_1_1_and_1_2` | `eu_reg_2024_1502_art_2_4` |
    | `systemic_importance_sub_criterion_2_1` | `eu_reg_2024_1502_art_3_2` |
    | `systemic_importance_sub_criterion_2_2` | `eu_reg_2024_1502_art_3_3` |
    | `substitutability_sub_criteria_4_1_and_4_2` | `eu_reg_2024_1502_art_5_4` |

### 8.3 Verdict atoms owned

All of section 2. Ground results are folded into clause heads, with one clause per disjoint limb route (C17).

### 8.4 Shared with kernel

The slice uses these kernel predicates, and only these:
- the type-set predicates;
- `dora_ctpp_designation_input_problems/2`;
- `dora_ctpp_designation_first_named_key/3`.

Everything else is local to the slice.

### 8.5 Per-rule tests (seven modes)

1. **Unit**: one test per limb A0-A9, B0-B2, C0-C2, D0-D5.
2. **Boundary**: exactly 10 % passes and just under fails; O-SII score 3000 fails and 3001 passes; O-SII count 2 vs 3; other systemic 2 vs 3.
3. **Missing-key**: covers each A8 / B1 selection case named in WHY THIS ORDER.
4. **Input check**: float, duplicate (never also wrong_type), unknown, unbound key and value, partial list, Directive 2013/36 atom, record bounds, synonym pooling allowed.
5. **Counting / determinism**: `findall` length 1 for every fixture and query.
6. **Citation completeness**: every cite is in citation_vocabulary, via `bad_citation/1`.
7. **Fixtures regression**: every expected row in `fixtures.clausal`.

Every negative test is paired with a positive one over the same case.
