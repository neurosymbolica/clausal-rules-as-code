# SIGNATURE — eu/eprivacy_art_5_3_terminal_equipment

## Public query surface (summary)

The public query surface consists of:

- `decide_eprivacy_art_5_3_terminal_equipment(Profile, eprivacy_art_5_3_terminal_equipment_verdict(Result, Citations))`;
- `eprivacy_art_5_3_terminal_equipment_status(Profile, Result)`;
- the called contract `terminal_equipment_storage_or_access_permitted(Profile, Result, Citations)`;
- the input check `eprivacy_art_5_3_terminal_equipment_input_problems(Profile, Problems)`.

Profile, keys and values:

- `Profile` is an attribute list `[attribute(Key, Value), ...]`.
- It is read only with `profile_get/3`, `profile_has/2` and `profile_lacks/2`: by presence first, then by value.
- It may hold six tri-state judgement keys, each with the value `true`, `false` or `unsure`.

Results and citations:

- `Result` is one of `permitted`, `not_permitted`, `not_applicable`, `indeterminate([Key])`, `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])` or `input_problems(Problems)`.
- `Citations` is `[cite(eu_dir_2002_58_art_5_3)]` for the three final results and `[]` for every other result.

Totality and determinism:

- **Totality:** every term, bound or not and well-formed or not, yields an answer.
- **Determinism:** every public predicate yields exactly ONE solution. No cut, `->` or `*->` is used. Disjointness comes from mutually exclusive clause guards and from `findall` plus `msort` selection.

No statutory figures exist, so nothing is imported or declared with `constant_value`.

## Verdict STATUS atoms (replacing the placeholder `{ required, permitted, not_applicable }`)

Final statuses:

- `permitted`: allowed under Art 5(3). This is the eligible pole of query type #2.
- `not_permitted`: all three ways failed. This is the ineligible pole.
- `not_applicable`: the scope judgement is `false`.

Non-final statuses (result constructors; the bare atom `indeterminate` is NEVER written):

- `indeterminate(MissingKeys)`, where `MissingKeys` is a one-key list.
- `needs_legal_review(Reason, Context)`, where:
  - `Reason` is always `open_textured(Key, cite(CitationKey))`;
  - `Context` is `[inputs_relied_on(Pairs)]`, with no provenance term and no leaning.
- `input_problems(Problems)`, where each problem is `unknown_key(Key)`, `wrong_type(Key)` or `duplicate_key(Key)`, and `wrong_type(profile)` is also possible.

The constructors that are exported and never called as queries are:

- `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`;
- `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`;
- `inputs_relied_on/1`, `provenance/2`.

`provenance/2` is exported but not produced.

Checklist item statuses are the kit's: `met`, `unmet(Reason)` and `unknown(Keys)` (`formalize_lib`).

The atoms `true` and `false` are never pinned in `verdict_vocabulary` or `root_exports`.

## Profile keys (root_exports order = input_contract order; all tri-state judgements)

| # | Key | Values | Source | Referral citation when `unsure` |
|---|---|---|---|---|
| 1 | `storage_or_access_in_terminal_equipment` | `true` / `false` / `unsure` | Art 5(3) s1, scope (reading 2) | `cite(eu_dir_2002_58_art_5_3_s1)` |
| 2 | `storage_or_access_solely_for_transmission` | `true` / `false` / `unsure` | Art 5(3) s2, transmission exemption (reading 4) | `cite(eu_dir_2002_58_art_5_3_s2)` |
| 3 | `service_explicitly_requested_by_user` | `true` / `false` / `unsure` | Art 5(3) s2, 'explicitly requested' (reading 5) | `cite(eu_dir_2002_58_art_5_3_s2)` |
| 4 | `strictly_necessary_to_provide_requested_service` | `true` / `false` / `unsure` | Art 5(3) s2, 'strictly necessary' (reading 6) | `cite(eu_dir_2002_58_art_5_3_s2)` |
| 5 | `user_consent_given` | `true` / `false` / `unsure` | Art 5(3) s1 with Art 2(f) (reading 7) | `cite(eu_dir_2002_58_art_2_f)` |
| 6 | `clear_and_comprehensive_information_provided` | `true` / `false` / `unsure` | Art 5(3) s1, information (reading 7) | `cite(eu_dir_2002_58_art_5_3_s1)` |

Value rules:

- Values are bare atoms only.
- `attested(...)`, strings, numbers and unbound values are all `wrong_type(Key)`.
- No key is numeric and no key is a date.

## Citation-key atoms (canonical scheme, `_lexicon/citations.yaml`; never shortened further)

| Key | Unit | Role |
|---|---|---|
| `eu_dir_2002_58_art_5_3` | `#art5_p3_s1` + `#art5_p3_s2` | the citation on every final result |
| `eu_dir_2002_58_art_5_3_s1` | `02002L0058-20091219#art5_p3_s1` | scope and consent rule; referral of keys 1 and 6 |
| `eu_dir_2002_58_art_5_3_s2` | `02002L0058-20091219#art5_p3_s2` | the two exemptions; referral of keys 2, 3 and 4 |
| `eu_dir_2002_58_art_2_f` | `02002L0058-20091219#art2_f` | 'consent'; referral of key 5 |
| `eu_dir_2002_58_art_2_a` | `02002L0058-20091219#art2_a` | 'user'; checklist context only, never in a result |

The Article 5 heading (`#art5`) is deferred. It is recorded in `citations.clausal` as context, with no citation key in any result.

## Public predicates (one line each)

- `terminal_equipment_storage_or_access_permitted(Profile, Result, Citations)`: the called contract. It applies THE LIMBS (0)–(5) in that order. It yields exactly one solution, with `Citations` as `[cite(eu_dir_2002_58_art_5_3)]` for a final result and `[]` otherwise. Citations: Art 5(3) s1 and s2, Art 2(f).
- `eprivacy_art_5_3_terminal_equipment_input_problems(Profile, Problems)`: THE INPUT CHECK, run against the typed input_contract. It yields exactly one solution, never fails and never raises. Citation: none (it is a contract check).
- `decide_eprivacy_art_5_3_terminal_equipment(Profile, Verdict)`: the facade. `Verdict` is `eprivacy_art_5_3_terminal_equipment_verdict(Result, Citations)`, from the called contract. Citation: `eu_dir_2002_58_art_5_3`.
- `eprivacy_art_5_3_terminal_equipment_status(Profile, Result)`: the `Result` of the called contract alone, as a scalar status term. Citation: `eu_dir_2002_58_art_5_3`.
- `eprivacy_art_5_3_terminal_equipment_checklist(Profile, Checklist)`: the cited eligibility checklist for query type #2.
  - It holds four `item(Id, Status, Citation)` rows, in order: `scope`, `transmission_exemption`, `strictly_necessary_exemption`, `consent`.
  - It is built with `eval_requirements/4` over `eprivacy_art_5_3_terminal_equipment_requirement/4`.
  - If the input check finds problems, the checklist is `[]`.
  - Citations per item: `scope` cites `_s1`, `transmission_exemption` cites `_s2`, `strictly_necessary_exemption` cites `_s2`, `consent` cites `_s1`.
  - The checklist explains the result. It never decides it: the ways are a disjunction, so `decide_labeled/3` is not used for the verdict.
- `eprivacy_art_5_3_terminal_equipment_what_if(Profile, Key, Value, Result)`: the `Result` of the called contract on `Profile` with `attribute(Key, Value)` set. It uses `profile_set/3` through `what_if/5` (kit.query_combinators), with the closure `eprivacy_art_5_3_terminal_equipment_status`. The result after the override is subject to the input check as usual. Citation: as for the called contract.
- `eprivacy_art_5_3_terminal_equipment_requirement(RequirementId, Profile, Status, Citation)`: the requirement rows, with the kit argument order and `RequirementId` first. Each id has three disjoint clauses: met, unmet and unknown.
- `eprivacy_art_5_3_terminal_equipment_fixture(Name, Profile)` and `eprivacy_art_5_3_terminal_equipment_fixture_expected(Name, Result, Citations)`: the golden fixtures (fixtures.clausal). See the table below.

## Planned reuse (manifest `uses:`)

- From `formalize_lib`:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2` and `profile_set/3`;
  - `check_tri/4`, used for the single-key scope and transmission items (C15: not hand-rolled);
  - `and_status/2`, used for the two-key ways (b) and (c) in the checklist;
  - `eval_requirements/4`, used for the checklist rows (R1: no hand-rolled findall item builder);
  - `memberd/2` and `not_member/2`;
  - the constructors `attribute/2`, `item/3`, `unmet/1` and `unknown/1`.
- From `kit.query_combinators`: `what_if/5`.
- From `validate_props` (tests only): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3` and `bad_citation/1`.
- Built-in: `list_item/3`, the 0-based index, used for root_exports positions in tie-breaks.
- Not used: `compliance_lib`, `deadline_lib`, `rolling_window`, `date_time`, `currency_vocab`, `vat_category` and `country`. No modality lattice is needed because there is a single permission rule, and no dates or money are involved.

## Layer files

- **kernel.clausal** holds the shared floor, used by the slice, queries and fixtures:
  - `eprivacy_art_5_3_terminal_equipment_contract_keys/1`: the six keys in root_exports order;
  - `eprivacy_art_5_3_terminal_equipment_tri_state/1`: the facts `true`, `false` and `unsure`;
  - `eprivacy_art_5_3_terminal_equipment_input_problems/2`: THE INPUT CHECK;
  - `eprivacy_art_5_3_terminal_equipment_key_state(Profile, Key, State)`, where `State` is one of `true`, `false`, `unsure` or `absent`. It has four disjoint clauses: `profile_lacks` gives `absent`; `profile_get` gives the value.
  - `eprivacy_art_5_3_terminal_equipment_pairs(Profile, Pairs)`: `Key-Value` for each present key in contract order, the unsure ones included. It is built with `findall` over the contract keys plus `profile_get`.
- **citations.clausal** holds the five citation keys with their unit ids and verbatim pinned text, plus the deferred heading `#art5` as context.
- **parameters.clausal** holds no statutory figures, since Art 5(3) has no thresholds, periods or amounts. It keeps the scaffold module with a comment saying so and declares no `constant_value`.
- **queries.clausal** holds the facade status, checklist and what_if predicates.
- **fixtures.clausal** holds the golden table below.
- **package facade** re-exports the public predicates and constructors.

### THE INPUT CHECK (kernel) — clause plan

1. **Shape.** `Profile` must be a proper list in which every element is `attribute(Key, Value)`.
   - An unbound profile, a partial list, an unbound element or any other element fails the shape test.
   - The shape test is guarded with `is_list`/`var` tests and `findall`, never by failure-driven raising.
   - A profile that fails it gives `[wrong_type(profile)]` and nothing else.
2. **Per contract key, in contract order.**
   - Count the occurrences, comparing keys with `==` so that a variable key never unifies with a contract key.
   - A count of 2 or more gives `duplicate_key(Key)`, and no value is read.
   - A count of 1 with a value that is not exactly `true`, `false` or `unsure` gives `wrong_type(Key)`. The test is `nonvar` plus `memberd` against the tri_state facts. Unbound values and `attested(_)` are both `wrong_type`.
3. **Unknown keys.** Each `Key` that is not `==` to a contract key gives `unknown_key(Key)`.
   - This includes non-atoms such as numbers, strings, compounds and variables, each kept as given.
   - Each such key is listed once, in the order of its first occurrence.
4. The problems are concatenated in that order, and an empty list means a well-formed profile. Absence is never a problem.

## Slice: eprivacy_art_5_3_terminal_equipment.clausal

### Value facts owned by this slice (statutory structure, not numbers)

- `eprivacy_art_5_3_terminal_equipment_way(transmission_exemption, [storage_or_access_solely_for_transmission])`.
- `eprivacy_art_5_3_terminal_equipment_way(strictly_necessary_exemption, [service_explicitly_requested_by_user, strictly_necessary_to_provide_requested_service])`.
- `eprivacy_art_5_3_terminal_equipment_way(consent, [user_consent_given, clear_and_comprehensive_information_provided])`.
- `eprivacy_art_5_3_terminal_equipment_referral_citation(Key, cite(CitationKey))`, one fact per key:
  - key 1 cites `_s1`;
  - keys 2, 3 and 4 cite `_s2`;
  - key 5 cites `_art_2_f`;
  - key 6 cites `_s1`.
- `eprivacy_art_5_3_terminal_equipment_final_citations([cite(eu_dir_2002_58_art_5_3)])`.

There are no thresholds, periods or tables, and so no `constant_value`.

### Derived predicates (local; none shared)

- `way_state(Profile, WayId, State)`, where `State` is `met`, `failed` or `open`. It has three disjoint clauses:
  - `met`: every key is `true`;
  - `failed`: some key is `false`, checked with `memberd` over the key states;
  - `open`: no key is `false` and some key is `absent` or `unsure`.
- `ways_settled(Profile, Settlement)`, where `Settlement` is one of three values, computed once from the findall of way states:
  - `some_met`: some way is MET;
  - `all_failed`: all three ways are FAILED;
  - `unsettled`: otherwise.
- `missing_candidate(Profile, candidate(UnresolvedCount, FirstAbsentIndex, FirstAbsentKey))`, for each OPEN way with an absent key:
  - `UnresolvedCount` is the number of its keys that are absent or `unsure`;
  - `FirstAbsentIndex` is the 0-based root_exports index, via `list_item/3`.
- `first_missing_key(Profile, Key)`: `findall` candidates, `msort`, then take the head. It fails if there are no candidates. The fewest-unresolved rule and the tie-break by first-absent index both fall out of the term order.
- `first_open_unsure_key(Profile, Key)`: the first key in contract order that belongs to an OPEN way and is `unsure`.

### Rules (the called contract; ground status in the head, C17; one clause per disjoint route)

- **R0** `input_problems(Problems)`, `[]`: applies when the input check gives a non-empty list.
- **R1a** `indeterminate([storage_or_access_in_terminal_equipment])`, `[]`: well-formed profile, scope absent.
- **R1b** `not_applicable`, `[cite(eu_dir_2002_58_art_5_3)]`: well-formed, scope `false`.
- **R3a** `permitted`, `[cite(eu_dir_2002_58_art_5_3)]`: well-formed, scope `true`, `some_met`.
- **R3b** `not_permitted`, `[cite(eu_dir_2002_58_art_5_3)]`: well-formed, scope `true`, `all_failed`.
- **R3c** `needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on(Pairs)])`, `[]`: well-formed, scope `unsure`, settlement `some_met` or `all_failed`. Two guards (one per settlement atom) keep this to one solution.
- **R4** `indeterminate([Key])`, `[]`: well-formed, scope `true` or `unsure`, `unsettled`, and `first_missing_key(Profile, Key)` succeeds.
- **R5a** `needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on(Pairs)])`, `[]`: well-formed, scope `unsure`, `unsettled`, and no missing candidate (checked with a findall that returns `[]`).
- **R5b** `needs_legal_review(open_textured(Key, Citation), [inputs_relied_on(Pairs)])`, `[]`: well-formed, scope `true`, `unsettled`, no missing candidate, `first_open_unsure_key(Profile, Key)`, and `referral_citation(Key, Citation)`.

Why the routes are disjoint, and why the cases are exhaustive:

- The scope state takes one value per profile.
- The settlement takes one value per profile.
- "Has a missing candidate" and "has no missing candidate" are complementary.
- Under scope `true` and `unsettled` with no absent key, some open way has an `unsure` key, because an OPEN way with no absent key must hold an `unsure` key. R5b therefore always fires there.

### Requirements (checklist rows, `eprivacy_art_5_3_terminal_equipment_requirement/4`)

- `scope`: `check_tri(Profile, storage_or_access_in_terminal_equipment, outside_article_5_3, Status)`; cites `_s1`.
- `transmission_exemption`: `check_tri` on key 2; cites `_s2`.
- `strictly_necessary_exemption`: `and_status` of the `check_tri` results on keys 3 and 4; cites `_s2`.
- `consent`: `and_status` of the `check_tri` results on keys 5 and 6; cites `_s1`. The `art_2_f` provenance is carried in the referral, not in the item.
- An `unsure` value is reported as `unknown([Key])`, exactly as an absent key is reported. The checklist is explanatory only.

### Verdict atoms of this slice

The slice produces:

- the final results `permitted`, `not_permitted` and `not_applicable`;
- the non-final results `indeterminate/1` and `needs_legal_review/2` with `open_textured/2`;
- `input_problems/1`, through the kernel's input check.

### Shared with another slice

Nothing is shared with another slice, since this is the only slice. Only the kernel floor listed above is shared, with queries and fixtures.

## Golden fixtures (fixtures.clausal) and expected results

Abbreviations used in this table only (the code uses full keys):

- S = `storage_or_access_in_terminal_equipment`, T = `storage_or_access_solely_for_transmission`;
- R = `service_explicitly_requested_by_user`, N = `strictly_necessary_to_provide_requested_service`;
- C = `user_consent_given`, I = `clear_and_comprehensive_information_provided`.

Final results carry `[cite(eu_dir_2002_58_art_5_3)]`, and every other result carries `[]`.

| Fixture | Profile | Result |
|---|---|---|
| `empty_profile` | `[]` | `indeterminate([storage_or_access_in_terminal_equipment])` |
| `out_of_scope` | S=false | `not_applicable` |
| `transmission_only` | S=true, T=true | `permitted` |
| `requested_and_strictly_necessary` | S=true, T=false, R=true, N=true | `permitted` |
| `informed_consent` | S=true, C=true, I=true | `permitted` |
| `all_ways_failed` | S=true, T=false, R=false, C=false | `not_permitted` |
| `consent_without_information` | S=true, T=false, R=false, C=true, I=false | `not_permitted` |
| `scope_only` | S=true | `indeterminate([storage_or_access_solely_for_transmission])` |
| `tie_broken_by_key_order` | S=true, T=false | `indeterminate([service_explicitly_requested_by_user])` |
| `fewest_unresolved_first` | S=true, T=false, R=true | `indeterminate([strictly_necessary_to_provide_requested_service])` |
| `unsure_open_way_skipped_for_missing` | S=true, T=unsure | `indeterminate([service_explicitly_requested_by_user])` |
| `scope_unsure_missing_named` | S=unsure | `indeterminate([storage_or_access_solely_for_transmission])` |
| `scope_unsure_settled_permitted` | S=unsure, T=true | `needs_legal_review(open_textured(storage_or_access_in_terminal_equipment, cite(eu_dir_2002_58_art_5_3_s1)), [inputs_relied_on([storage_or_access_in_terminal_equipment-unsure, storage_or_access_solely_for_transmission-true])])` |
| `scope_unsure_settled_forbidden` | S=unsure, T=false, R=false, C=false | the same referral on S, with PAIRS for S, T, R and C |
| `transmission_unsure_referred` | S=true, T=unsure, R=false, C=false | `needs_legal_review(open_textured(storage_or_access_solely_for_transmission, cite(eu_dir_2002_58_art_5_3_s2)), [inputs_relied_on([...S, T, R, C...])])` |
| `consent_unsure_referred` | S=true, T=false, R=false, C=unsure, I=true | `needs_legal_review(open_textured(user_consent_given, cite(eu_dir_2002_58_art_2_f)), ...)` |
| `information_unsure_referred` | S=true, T=false, R=false, C=true, I=unsure | `needs_legal_review(open_textured(clear_and_comprehensive_information_provided, cite(eu_dir_2002_58_art_5_3_s1)), ...)` |
| `full_referral_row` | all six present: S=true, T=unsure, R=unsure, N=unsure, C=unsure, I=unsure | `needs_legal_review(open_textured(storage_or_access_solely_for_transmission, cite(eu_dir_2002_58_art_5_3_s2)), [inputs_relied_on(all six pairs)])` |
| `attested_value` | S=attested(true) | `input_problems([wrong_type(storage_or_access_in_terminal_equipment)])` |
| `duplicate_key` | S=true, S=true, zzz=1 | `input_problems([duplicate_key(storage_or_access_in_terminal_equipment), unknown_key(zzz)])` |
| `not_attribute_list` | `[foo]` | `input_problems([wrong_type(profile)])` |

## Tests (seven modes; v2 manifest)

1. **Unit / per-rule.** At least one positive test per route R0–R5b, and every `fail` test is paired with a positive test over the same case.
2. **Golden fixtures.** Every row of the table above.
3. **Input check.** Unbound profile, partial list, unbound element, unbound value, variable key, string key, compound key, repeated unknown key, and a duplicate key with differing values (never also `wrong_type`).
4. **Counting.** `findall` over every public predicate gives length 1, over all 4^6 tri-state-or-absent profiles.
5. **Properties** (`validate_props`): totality, determinism, citation completeness (final results cite `_art_5_3`, every other result cites `[]`), and missing-key coverage.
6. **Settled-first invariants.**
   - With S=true and a MET way, the result is `permitted` whatever the other keys are.
   - With three FAILED ways, the result is `not_permitted`.
   - The result never names a way.
7. **Mutation / what_if.**
   - Flipping a single key in a settled profile through `eprivacy_art_5_3_terminal_equipment_what_if/4` gives the expected result.
   - The scope key set to `false` always gives `not_applicable`.
