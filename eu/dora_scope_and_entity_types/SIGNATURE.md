# SIGNATURE — eu/dora_scope_and_entity_types

## Public query surface

The contract queries come first. Each takes PROFILE and yields exactly ONE solution.

- `dora_scope_decision(Profile, Result, Citations)`
- `dora_entity_category(Profile, Result, Citations)`
- `dora_scope_and_entity_types_input_problems(Profile, Problems)`

The scaffold facade is kept with its names. It is a thin layer over `dora_scope_decision/3`.

- `decide_dora_scope_and_entity_types(Profile, dora_scope_and_entity_types_verdict(Status, Citations))`
- `dora_scope_and_entity_types_status(Profile, Status)`
- `dora_scope_and_entity_types_checklist(Profile, Checklist)`
- `dora_scope_and_entity_types_what_if(Profile, Key, Value, Status)`
- the fixtures

**Totality.** Every term given as PROFILE yields exactly one solution of each query. This includes unbound terms, partial lists and non-lists. No query ever fails or raises.

**Determinism.** Clause guards are pairwise disjoint, with the ground result in each clause head (C17). There is no `!`, `->`, `*->` or `once/1`.

**No imported figures.** The only statutory figure is the IORP member ceiling, 15. It is declared once in the slice file.

## Verdict STATUS atoms (replace the placeholder `eligible`/`ineligible`)

### Final answers of `dora_scope_decision/3` (and the facade STATUS)

- `in_scope(Type)`: arity 1, where `Type` is a bare atom of THE SHARED TYPE SET.
- `out_of_scope`: a bare atom.

### Final answers of `dora_entity_category/3`

- `financial_entity`
- `ict_third_party_service_provider`
- `out_of_scope`

### Status compounds (CITATIONS always `[]`)

- `indeterminate([Key])`: exactly one bare key atom. The bare atom `indeterminate` is NEVER written.
- `input_problems(Problems)`: `Problems` is a non-empty list of `duplicate_key(Key)`, `wrong_type(Key)` and `unknown_key(Key)`.

### Result constructors

These are exported and never called as queries: `in_scope/1`, `indeterminate/1`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

### Not used

- `needs_legal_review`: there are no judgement keys in this order.
- `unsure`: not used either.
- `true` and `false` are never pinned in `verdict_vocabulary` or `root_exports`.

## Profile keys (input_contract order = root_exports order)

PROFILE is `[attribute(Key, Value), ...]`. Values are read ONLY with `profile_get/3`.

| # | Key | Type | Read for |
|---|---|---|---|
| 1 | `dora_entity_type` | enumeration: 28 type atoms + `none_of_the_listed_types` | always |
| 2 | `aifm_under_article_3_2_of_directive_2011_61` | boolean (`true`/`false`) | `manager_of_alternative_investment_funds` (Art 2(3)(a)) |
| 3 | `undertaking_under_article_4_of_directive_2009_138` | boolean | `insurance_undertaking`, `reinsurance_undertaking` (Art 2(3)(b)) |
| 4 | `iorp_pension_scheme_members_total` | non_negative_integer (a count of persons; integer units; never a float) | `institution_for_occupational_retirement_provision` (Art 2(3)(c)) |
| 5 | `exempted_under_articles_2_and_3_of_directive_2014_65` | boolean | `investment_firm` (Art 2(3)(d)) |
| 6 | `financial_entity_is_microenterprise` | boolean | the three intermediary types (Art 2(3)(e); Art 3(60)) |
| 7 | `financial_entity_is_small_or_medium_sized_enterprise` | boolean | the three intermediary types (Art 2(3)(e); Art 3(63), (64)) |
| 8 | `post_office_giro_institution_under_article_2_5_3_of_directive_2013_36` | boolean | `credit_institution` (Art 2(3)(f)) |
| 9 | `exempted_from_dora_scope_by_member_state` | boolean | `institution_exempted_pursuant_to_directive_2013_36` (Art 2(4)) |

- **No money keys.** No euro figure is read, so no `_eur_cents` key exists.
- **No dates.** No date is read (reading (14)).
- **Mandated spellings.** `aifm` and `iorp` are contract-mandated spellings shared across orders, kept verbatim. Use a `% lint:` pragma if C6 flags them.

### THE SHARED TYPE SET (in Art 2(1) order)

1. `credit_institution`
2. `institution_exempted_pursuant_to_directive_2013_36`
3. `payment_institution`
4. `exempted_payment_institution`
5. `account_information_service_provider`
6. `electronic_money_institution`
7. `exempted_electronic_money_institution`
8. `investment_firm`
9. `crypto_asset_service_provider`
10. `issuer_of_asset_referenced_tokens`
11. `central_securities_depository`
12. `central_counterparty`
13. `trading_venue`
14. `trade_repository`
15. `manager_of_alternative_investment_funds`
16. `management_company`
17. `data_reporting_service_provider`
18. `insurance_undertaking`
19. `reinsurance_undertaking`
20. `insurance_intermediary`
21. `reinsurance_intermediary`
22. `ancillary_insurance_intermediary`
23. `institution_for_occupational_retirement_provision`
24. `credit_rating_agency`
25. `administrator_of_critical_benchmarks`
26. `crowdfunding_service_provider`
27. `securitisation_repository`
28. `ict_third_party_service_provider`

Outside the set: `none_of_the_listed_types`.

## Citation-key atoms (canonical lexicon; never shortened)

- **Art 2(1):** `eu_reg_2022_2554_art_2_1`
- **Art 2(1)(a) to (u):** `eu_reg_2022_2554_art_2_1_a`, `eu_reg_2022_2554_art_2_1_b`, `eu_reg_2022_2554_art_2_1_c`, `eu_reg_2022_2554_art_2_1_d`, `eu_reg_2022_2554_art_2_1_e`, `eu_reg_2022_2554_art_2_1_f`, `eu_reg_2022_2554_art_2_1_g`, `eu_reg_2022_2554_art_2_1_h`, `eu_reg_2022_2554_art_2_1_i`, `eu_reg_2022_2554_art_2_1_j`, `eu_reg_2022_2554_art_2_1_k`, `eu_reg_2022_2554_art_2_1_l`, `eu_reg_2022_2554_art_2_1_m`, `eu_reg_2022_2554_art_2_1_n`, `eu_reg_2022_2554_art_2_1_o`, `eu_reg_2022_2554_art_2_1_p`, `eu_reg_2022_2554_art_2_1_q`, `eu_reg_2022_2554_art_2_1_r`, `eu_reg_2022_2554_art_2_1_s`, `eu_reg_2022_2554_art_2_1_t`, `eu_reg_2022_2554_art_2_1_u`
- **Art 2(2):** `eu_reg_2022_2554_art_2_2`
- **Art 2(3)(a) to (f):** `eu_reg_2022_2554_art_2_3_a`, `eu_reg_2022_2554_art_2_3_b`, `eu_reg_2022_2554_art_2_3_c`, `eu_reg_2022_2554_art_2_3_d`, `eu_reg_2022_2554_art_2_3_e`, `eu_reg_2022_2554_art_2_3_f`
- **Art 2(4):** `eu_reg_2022_2554_art_2_4`
- **Art 3:** `eu_reg_2022_2554_art_3_19`, `eu_reg_2022_2554_art_3_32`, `eu_reg_2022_2554_art_3_36`, `eu_reg_2022_2554_art_3_39`, `eu_reg_2022_2554_art_3_60`, `eu_reg_2022_2554_art_3_63`, `eu_reg_2022_2554_art_3_64`

All 38 atoms go into `citation_vocabulary` and `citations.clausal`, each with its pinned unit id.

## Public predicates (one line each)

- `dora_scope_decision(Profile, Result, Citations)`: steps A0 to A5. `Result` is `in_scope(Type)`, `out_of_scope`, `indeterminate([Key])` or `input_problems(Problems)`. Cites Art 2(1)–(4) and Art 3(19), (32), (36), (39), (60), (63), (64), as fixed per result.
- `dora_entity_category(Profile, Result, Citations)`: steps B0 to B6. Same as A0 to A4. Then type (u) gives `ict_third_party_service_provider` with `[cite(eu_reg_2022_2554_art_2_1_u), cite(eu_reg_2022_2554_art_3_19)]`. Every other type gives `financial_entity` with the in_scope citations followed by `cite(eu_reg_2022_2554_art_2_2)`. Art 2(2).
- `dora_scope_and_entity_types_input_problems(Profile, Problems)`: THE INPUT CHECK. `[]` when well formed. It never fails and never raises. Contract basis: Art 2 input contract.
- `decide_dora_scope_and_entity_types(Profile, Verdict)`: `Verdict` is `dora_scope_and_entity_types_verdict(Result, Citations)`, with `Result` and `Citations` exactly as `dora_scope_decision/3`. Art 2.
- `dora_scope_and_entity_types_status(Profile, Status)`: `Status` is the `Result` of `dora_scope_decision/3`. Art 2.
- `dora_scope_and_entity_types_checklist(Profile, Checklist)`: the justification query (#7). Each item carries `cite(...)` provenance, met items included. It is built with `formalize_lib:eval_requirements/4` over `dora_scope_requirement/4`, with RequirementId first. Requirement ids, in order:
  - `entity_type_listed_in_article_2_1`: met when the type is in the set; unmet for `none_of_the_listed_types`; unknown([dora_entity_type]) when absent. Cites the type's in_scope citations, or `eu_reg_2022_2554_art_2_1`.
  - `no_exclusion_applies`: met when the row is NOT EXCLUDED or the type has no row; unmet when EXCLUDED; unknown([Key]) when neither; inapplicable-free. Cites the row's out_of_scope citations, or `eu_reg_2022_2554_art_2_3` items for its type.
  - **Input problems.** When the profile has input problems, the checklist is `[item(input_check, unmet(input_problems(Problems)), cite(eu_reg_2022_2554_art_2_1))]` only.
- `dora_scope_and_entity_types_what_if(Profile, Key, Value, Status)`: replaces or adds `attribute(Key, Value)` with `formalize_lib:profile_set/3`, then takes the Status of `dora_scope_decision/3` on the new profile. Art 2.
- Fixtures: `dora_scope_and_entity_types_fixture(Name, Profile)` and `dora_scope_and_entity_types_fixture_expected(Name, Result, Citations)`. The planned fixtures are:
  - `credit_institution_in_scope`
  - `post_office_giro_out_of_scope`
  - `crd_exempted_member_state_excluded`
  - `crd_exempted_in_scope`
  - `exempted_payment_institution_in_scope`
  - `investment_firm_mifid_exempted`
  - `small_aifm_out_of_scope`
  - `small_insurer_out_of_scope`
  - `iorp_fifteen_members_out_of_scope`
  - `iorp_sixteen_members_in_scope`
  - `intermediary_microenterprise_out_of_scope`
  - `intermediary_size_absent_indeterminate`
  - `intermediary_microenterprise_false_sme_absent_indeterminate`
  - `intermediary_large_in_scope`
  - `ict_provider_in_scope`
  - `none_listed_out_of_scope`
  - `type_absent_indeterminate`
  - `float_member_count_wrong_type`
  - `duplicate_type_key`
  - `unknown_key_reported`
  - `profile_not_a_list`

## Planned reuse (manifest `uses:`)

- **`formalize_lib`.** Imports `profile_get/3`, `profile_set/3`, `eval_requirements/4`, `item/3`, `attribute/2`, `unknown/1`, `unmet/1` and `memberd/2`. Profile reads go only through `profile_get/3`.
- **`validate_props`.** Used in the tests: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2` (IORP 15/16) and `prop_missing_key_coverage/3`.
- **Not used.** `kit/query_combinators` `what_if/5` is not used, because `override_key/4` works on dicts and the profile is an attribute list. `profile_set/3` is used instead. There is no deadline, date, ratio, compliance or currency use.
- **Local, likely to recur.** The `==`-identity duplicate/unknown key scanner and the 28-atom type vocabulary are noted in NOTES.md.

## Layout (kept as scaffolded)

kernel -> citations -> parameters -> dora_scope_and_entity_types -> queries -> fixtures -> package facade.

### kernel.clausal

- Holds the result-constructor declarations only: `in_scope/1`, `indeterminate/1`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.
- It also holds the `cite/1` wrapper.
- There is only one determination slice, so no domain predicate is shared and nothing else moves to the kernel.

### Other files

- `citations.clausal`: the 38 citation atoms with pinned unit ids.
- `parameters.clausal`: stays a thin re-export. The value fact lives in the slice; see below.
- `queries.clausal`: wires the facade names to the slice.

## Slice: dora_scope_and_entity_types.clausal

This section is self-contained; the later phase authors the file from it alone.

### Value facts owned by this slice

- `:- constant_value(occupational_retirement_provision_members_maximum, 15).` This is the Art 2(3)(c) ceiling, read with `constant(occupational_retirement_provision_members_maximum)`. Excluded when `Members =< constant(...)`; not excluded when `Members > constant(...)`.
- **The type table.** `dora_type_atom(Type)`: 28 facts in Art 2(1) order.
- **`dora_type_in_scope_citations(Type, Citations)`.** 28 facts, exactly as THE LIMBS: one point of Art 2(1), plus Art 3(32), (36), (39) or (19) for the four types read through a definition.
- **`dora_exclusion_row(Type, RowName)`.** The row names are:
  - `credit_institution`: `post_office_giro`
  - `institution_exempted_pursuant_to_directive_2013_36`: `member_state_option`
  - `investment_firm`: `markets_in_financial_instruments_exemption`
  - `manager_of_alternative_investment_funds`: `small_alternative_fund_manager`
  - `insurance_undertaking` and `reinsurance_undertaking`: `small_insurance_undertaking`
  - the three intermediaries: `intermediary_size`
  - `institution_for_occupational_retirement_provision`: `occupational_retirement_members`
- **`dora_type_without_exclusion(Type)`.** This holds for the other 17 types. It is an explicit fact table, so that the no-row route is a positive guard (no negation needed for disjointness).
- **`dora_exclusion_row_key(RowName, Key)`.** For the single-key rows.
- **`dora_exclusion_row_citations(RowName, Citations)`:**
  - `post_office_giro`: `[cite(eu_reg_2022_2554_art_2_3_f)]`
  - `member_state_option`: `[cite(eu_reg_2022_2554_art_2_4)]`
  - `markets_in_financial_instruments_exemption`: `[cite(eu_reg_2022_2554_art_2_3_d)]`
  - `small_alternative_fund_manager`: `[cite(eu_reg_2022_2554_art_2_3_a)]`
  - `small_insurance_undertaking`: `[cite(eu_reg_2022_2554_art_2_3_b)]`
  - `intermediary_size`: `[cite(eu_reg_2022_2554_art_2_3_e), cite(eu_reg_2022_2554_art_3_60), cite(eu_reg_2022_2554_art_3_63), cite(eu_reg_2022_2554_art_3_64)]`
  - `occupational_retirement_members`: `[cite(eu_reg_2022_2554_art_2_3_c)]`
- **Input contract table.** `dora_contract_key(Position, Key, ValueType)` holds the nine keys in order. `ValueType` is `entity_type`, `boolean` or `non_negative_integer`.

### Rules

**R0. THE INPUT CHECK** (`dora_scope_and_entity_types_input_problems/2`). Exactly one solution for any term.

- **`profile_shape(Profile, Shape)`.** `Shape` is `attribute_list` or `not_attribute_list`. Three disjoint clauses decide it:
  - a `var` profile;
  - a proper list whose every element is `nonvar` and of the form `attribute(_, _)`;
  - otherwise, including partial lists and any bad or unbound element.
- **Not an attribute list** gives `[wrong_type(profile)]`.
- **Otherwise**, for each contract key in position order:
  - count its occurrences by `==` on the key;
  - count >= 2 gives `duplicate_key(Key)`, and no value is read;
  - count 1 with the value outside its type gives `wrong_type(Key)`;
  - count 0 or a good value gives nothing.
- **Value type checks** (an unbound value is wrong_type):
  - `entity_type`: `atom`, and either `dora_type_atom` or `none_of_the_listed_types`;
  - `boolean`: `==` true or `==` false;
  - `non_negative_integer`: `integer(Value)` and `Value >= 0`; a float, 15.0 included, fails `integer/1`.
- **Then `unknown_key(Key)`** once per distinct non-contract key, in first-occurrence order:
  - distinctness by `==`;
  - an unbound key is reported as that same variable;
  - a non-atom key is reported as given.
- **Building the list.** Implement with structural recursion and accumulators, using `\==` and `==` tests. There is no `->` or `!`, and each helper has disjoint clauses.

**R1 (A0/B0).** Problems is non-empty, so the Result is `input_problems(Problems)` and Citations are `[]`.

**R2 (A1/B1).** Problems is `[]` and `dora_entity_type` is absent. The Result is `indeterminate([dora_entity_type])` and Citations are `[]`.

**R3 (A2/B2).** The type is `none_of_the_listed_types`. The Result is `out_of_scope` with `[cite(eu_reg_2022_2554_art_2_1)]`.

**R4. `exclusion_outcome(Profile, RowName, Outcome)`.** `Outcome` is `excluded`, `not_excluded` or `missing(Key)`, with exactly one solution.

- **Single crisp-key rows:**
  - the key is `true`: `excluded`;
  - the key is `false`: `not_excluded`;
  - the key is absent: `missing(Key)`.
- **`occupational_retirement_members`:**
  - integer `=<` the maximum: `excluded`;
  - integer `>` the maximum: `not_excluded`;
  - absent: `missing(iorp_pension_scheme_members_total)`.
- **`intermediary_size`.** The clauses must be disjoint over (micro, sme), where each is `true`, `false` or absent:
  - micro `true` (whatever the other): `excluded`;
  - micro `false` and sme `true`: `excluded`;
  - micro absent and sme `true`: `excluded`;
  - micro `false` and sme `false`: `not_excluded`;
  - micro absent and sme absent: `missing(financial_entity_is_microenterprise)`;
  - micro absent and sme `false`: `missing(financial_entity_is_microenterprise)`;
  - micro `false` and sme absent: `missing(financial_entity_is_small_or_medium_sized_enterprise)`.
- **Presence and absence** are tested with `profile_get/3` and its failure. Use `\+ profile_get(...)` for absence; it is safe because the profile is ground-checked by R0 first.

**R5 (A3/B3).** The row outcome is `missing(Key)`. The Result is `indeterminate([Key])` and Citations are `[]`.

**R6 (A4/B4).** The row outcome is `excluded`. The Result is `out_of_scope`, with the row's citations.

**R7 (A5).** The type has no row, or its row is `not_excluded`. The Result is `in_scope(Type)`, with `dora_type_in_scope_citations(Type, Citations)`.

**R8 (B5).** As R7, with Type `ict_third_party_service_provider`. The Result is `ict_third_party_service_provider`, with `[cite(eu_reg_2022_2554_art_2_1_u), cite(eu_reg_2022_2554_art_3_19)]`.

**R9 (B6).** As R7, with any other type. The Result is `financial_entity`, with the in_scope citations followed by `cite(eu_reg_2022_2554_art_2_2)`, built with `append/3`.

**Disjointness** comes from three guards:

- the R0 result: `[]` versus `[_|_]`;
- type presence and value;
- the row-outcome atom.

`dora_type_atom` and `dora_type_without_exclusion` are fact lookups on a bound atom, so each gives one solution.

### Verdict atoms of this slice

- `in_scope/1`
- `out_of_scope`
- `financial_entity`
- `ict_third_party_service_provider`
- `indeterminate/1`
- `input_problems/1`

The checklist item statuses are `met`, `unmet(Reason)` and `unknown([Key])`.

### Shared predicates

NONE. This is the only slice, so nothing is moved to `kernel.clausal` beyond the result constructors and `cite/1`.

## Tests (seven modes, v2 manifest)

1. **Per-rule unit tests.** One per limb and per exclusion row: true / false / absent. Both size facts are covered in all seven combinations.
2. **Boundary.** IORP at 15 is `out_of_scope`. IORP at 16 is `in_scope(institution_for_occupational_retirement_provision)`.
3. **Counting.** `findall` length is 1 for every fixture and for adversarial profiles: an unbound profile, a partial list, unbound keys and values, `15.0`, `-1`, duplicates, and the string key `"x"`.
4. **Citation order.** Exact list equality for all 28 in_scope citation lists, the 7 out_of_scope rows and the 27 `financial_entity` lists.
5. **Input check order.** Duplicate before wrong_type within a key. Contract order first, then unknown keys in first-occurrence order.
6. **Completion soundness.** For each profile with absent keys, every completion agrees with the answer whenever the completions all agree.
7. **Properties.** `validate_props` checks totality, determinism and citation completeness. Each negative test is paired with a positive one over the same case.
