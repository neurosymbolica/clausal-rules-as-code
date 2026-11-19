# SIGNATURE — eu/cbam/origin_exclusions

The public query surface is:

- `origin_exclusion(PROFILE, RESULT, CITATIONS)` (the called contract);
- `origin_exclusions_input_problems(PROFILE, PROBLEMS)` (the input check);
- `decide_origin_exclusions(PROFILE, origin_exclusions_verdict(STATUS, CITATIONS))`, the facade;
- `origin_exclusions_status(PROFILE, STATUS)`.

**Totality and determinism.** Every public query yields EXACTLY ONE solution for every term it is given. The input check never fails and never raises. The engine uses no `!`, `->` or `*->`. Determinism comes from disjoint key CLASSIFICATIONS and a disjoint decision table with ground heads (C17).

**Statutory figures.** There are no imported or numeric statutory figures. The only statutory values are the closed Annex III point 1 list, owned by the slice. Annex III point 2 is empty on the pin.

## STATUS atoms (replacing `required / permitted / not_applicable`)

STATUS equals RESULT of `origin_exclusion/3`. It is exactly one of the following.

Final answers:
- `excluded_military_activities`
- `excluded_origin_annex_iii_point_1`
- `excluded_electricity_continental_shelf_or_eez`
- `excluded_hydrogen_continental_shelf_or_eez`
- `not_third_country_origin`
- `no_origin_exclusion`

Not-final answers (the status compound ITSELF, never wrapped in a list):
- `indeterminate([Key])`, holding ONE bare key atom;
- `input_problems(Problems)`, with Problems a non-empty flat list.

The bare atom `indeterminate` is NEVER written. There is no `needs_legal_review`.

Eligibility triad (query type #2), via `origin_exclusions_eligibility/2`:

| RESULT | Eligibility |
|---|---|
| one of the five exclusion atoms | `eligible` |
| `no_origin_exclusion` | `ineligible` |
| `indeterminate(_)` or `input_problems(_)` | `undetermined` |

The eligibility atom is `undetermined` rather than `indeterminate`, to avoid the shadowing trap.

Result constructors are exported and never called as queries:
- `indeterminate/1`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`

## Profile keys

PROFILE is `[attribute(Key, Value), ...]`. It is read only with `profile_get/3`, by presence first and then by value. Keys are bare atoms. All four keys are plain caller enumeration facts. There is no attested wrapper, no number, no date and no boolean.

The order below is the root_exports and input_contract order.

1. `military_activities`: `yes` | `no` | `unsure`. `unsure` is treated as absent.
2. `non_preferential_origin`: eleven atoms.
   - `member_state`
   - `iceland`, `liechtenstein`, `norway`, `switzerland`, `busingen`, `heligoland`, `livigno`, `ceuta`, `melilla`
   - `other_third_country`
3. `goods_kind`: `electricity` | `hydrogen` | `other_annex_i_goods`.
4. `continental_shelf_or_eez_of`: twelve atoms.
   - `not_on_continental_shelf_or_eez`
   - `member_state`
   - the nine listed atoms
   - `other_third_country`

## Citation-key atoms

These come from the canonical `_lexicon/citations.yaml` and are exported as `citation_vocabulary`. Each is written as `cite(Key)`.

- `eu_reg_2023_956_art_2_1`: Art 2(1)
- `eu_reg_2023_956_art_2_3`: Art 2(3)
- `eu_reg_2023_956_art_2_3a`: Art 2(3a), lead
- `eu_reg_2023_956_art_2_3a_a`: Art 2(3a), point (a)
- `eu_reg_2023_956_art_2_3a_b`: Art 2(3a), point (b)
- `eu_reg_2023_956_art_2_4`: Art 2(4)
- `eu_reg_2023_956_art_2_5`: Art 2(5)
- `eu_reg_2023_956_art_3_7`: Art 3, point (7)
- `eu_reg_2023_956_art_3_8`: Art 3, point (8)
- `eu_reg_2023_956_art_3_9`: Art 3, point (9)
- `eu_reg_2023_956_annex_3_1`: Annex III, point 1

Deferred units are not cited by any answer, and no atom is invented for them:
- Art 2(2), 2(6), 2(7), 2(8), 2(11);
- Art 3(6);
- Annex III title and point 2.

## Public predicates

- `origin_exclusion(Profile, Result, Citations)`: THE LIMBS steps 0 to 12. Result is an atom or status compound, and Citations is a flat set-like list of `cite(Key)`, `[]` when not final. Cites: Art 2(1), 2(3), 2(3a)(a)(b), 2(4), 2(5), 3(7), 3(8), 3(9) and Annex III pt 1.
- `origin_exclusions_input_problems(Profile, Problems)`: THE INPUT CHECK. It returns the BARE flat list (`[]` or problem terms), never wrapped. Cite: input_contract, no legal cite.
- `decide_origin_exclusions(Profile, Verdict)`: the facade. Verdict is `origin_exclusions_verdict(Status, Citations)`, which is `origin_exclusion/3` folded into one term. Cites: as `origin_exclusion/3`.
- `origin_exclusions_status(Profile, Status)`: Status = RESULT of `origin_exclusion/3`. Cites: as above.
- `origin_exclusions_eligibility(Profile, Eligibility)`: query type #2. Eligibility is `eligible`, `ineligible` or `undetermined`, mapped from Status. Cites: as above.
- `origin_exclusions_checklist(Profile, Checklist)`: the cited checklist. It gives one `item(RequirementId, Status, cite(Key))` per limb, with item Status `met`, `unmet(Reason)` or `unknown([Key])`. On input problems the Checklist is `[]`. Cites: per limb, below.
- `origin_exclusions_what_if(Profile, Key, Value, Result)`: the RESULT of `origin_exclusion/3` after Key is set to Value, through `profile_set/3`. It runs via kit `what_if/5` with the closure `origin_exclusions_status`, and one solution is kept. Cites: as above.
- fixtures (`fixtures.clausal`):
  - `origin_exclusions_fixture(FixtureName, Profile)` holds named profiles.
  - `origin_exclusions_fixture_expected(FixtureName, Result, Citations)` holds the gold answers.
  - There is at least one fixture per step 0 to 12, plus the Q1, Q4 and ruling-11 (`unsure`) cases.

## Planned reuse (manifest `uses:`)

From `formalize_lib`:
- `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`;
- `eval_requirements/4`, for the checklist with an injected `origin_exclusions_requirement/4` closure, RequirementId first;
- `memberd/2`, `item/3`, `unmet/1`, `unknown/1`, `attribute/2`.

`assess/6` is NOT used for the verdict. Its conjunctive unmet aggregation does not fit a first-exclusion disjunction, so the verdict comes from the decision table.

From `kit/query_combinators`: `what_if/5`.

From `validate_props`:
- `run_props/1`;
- `prop_totality/3` and `prop_determinism/3`, over all 4 x 12 x 4 x 13 = 2496 key-value combinations, absent included;
- `prop_citation_complete/3`;
- `prop_missing_key_coverage/3`.

The `_common` deontic backbone is not used: there are no obligations or permissions in this order.

Local, flagged in NOTES as a promotion candidate: the total attribute-list input check in `kernel.clausal`.

## kernel.clausal (the shared floor)

- `origin_exclusions_contract_key(Key)` holds the four keys, in contract order. Each key is also given its type through `origin_exclusions_key_type(Key, Value)` enumeration facts.
- `origin_exclusions_input_problems/2` is total and cut-free, built from disjoint clauses with `var/1` and `nonvar/1` guards.
  1. **Attribute-list check.** The profile must be a proper list whose every element is a non-variable `attribute(_, _)`. An unbound profile, a partial list, an unbound element or a non-attribute element gives `[wrong_type(profile)]` alone.
  2. **Per contract key, in order.** Count occurrences with `==`. Two or more gives `duplicate_key(Key)`, and the values are not read. Exactly one occurrence with an unbound value or a value outside the type gives `wrong_type(Key)`.
  3. **Unknown keys.** Then add `unknown_key(Key)` for each non-contract key, including non-atom and unbound keys as given. These are in first-occurrence order and de-duplicated by `==`, never by unification.
- Nothing else is shared: there is only one determination slice.

## Slice: origin_exclusions.clausal

**Value facts owned here (from the pin).**
- `annex_iii_point_1_listed(iceland)`, plus `liechtenstein`, `norway`, `switzerland`, `busingen`, `heligoland`, `livigno`, `ceuta` and `melilla`: nine facts, a closed list.
- Annex III point 2 has NO facts on the pin. This is commented with the pinned placeholder text and Q2.
- `electricity_shelf_or_zone_party(Atom)` follows Art 2(3a)(a), read as point 1 OR point 2. It derives from `member_state` or `annex_iii_point_1_listed/1`; point 2 contributes nothing.
- `hydrogen_shelf_or_zone_party(Atom)` follows Art 2(3a)(b). It is `member_state` or `annex_iii_point_1_listed/1`.

**Classifications.** There is one clause per class, and they are mutually exclusive. They read a profile already checked free of duplicates.

| Classification | Classes |
|---|---|
| `military_class(Profile, Class)` | `yes`; `no`; `missing` (absent or `unsure`) |
| `origin_class(Profile, Class)` | `listed`; `member_state`; `other_third_country`; `missing` |
| `goods_class(Profile, Class)` | `electricity`; `hydrogen`; `other_annex_i_goods`; `missing` |
| `shelf_class(Profile, Class)` | `member_state`; `listed`; `not_relevant` (`not_on_continental_shelf_or_eez` or `other_third_country`); `missing` |

**Rules (THE LIMBS).** Each step is a ground-headed clause of `origin_exclusion_decided/6` over the four classes. Each clause carries the negation of every earlier step as positive class guards, so clauses are disjoint and exactly one fires.

| Step | Condition | Result | Citations |
|---|---|---|---|
| 0 | Problems non-empty | `input_problems(Problems)` | `[]` |
| 1 | M = yes | `excluded_military_activities` | `[cite(eu_reg_2023_956_art_2_3)]` |
| 2 | M is not yes; O = listed | `excluded_origin_annex_iii_point_1` | Art 2(4), 2(5), Annex III pt 1 |
| 3 | M is not yes; O is not listed; G = electricity; S = member_state | `excluded_electricity_continental_shelf_or_eez` | Art 2(3a), 2(3a)(a), 3(8), 3(9) |
| 4 | as step 3 but S = listed | `excluded_electricity_continental_shelf_or_eez` | step 3 citations plus Annex III pt 1 |
| 5 | as step 3 but G = hydrogen | `excluded_hydrogen_continental_shelf_or_eez` | Art 2(3a), 2(3a)(b), 3(8), 3(9) |
| 6 | as step 5 but S = listed | `excluded_hydrogen_continental_shelf_or_eez` | step 5 citations plus Annex III pt 1 |
| 7 | O = member_state, and steps 1 to 6 do not hold | `not_third_country_origin` | Art 2(1), 2(5), 3(7) |
| 8 | M = missing, and steps 2 to 7 do not hold | `indeterminate([military_activities])` | `[]` |
| 9 | M = no; O = missing; steps 3 to 6 do not hold | `indeterminate([non_preferential_origin])` | `[]` |
| 10 | M = no; O = other_third_country; G = missing; S in {missing, member_state, listed} | `indeterminate([goods_kind])` | `[]` |
| 11 | M = no; O = other_third_country; G in {electricity, hydrogen}; S = missing | `indeterminate([continental_shelf_or_eez_of])` | `[]` |
| 12 | M = no; O = other_third_country; and either G = other_annex_i_goods, or S = not_relevant | `no_origin_exclusion` | Art 2(3), 2(3a), 2(4), Annex III pt 1 |

The classes are M (military), O (origin), G (goods) and S (shelf).

**Checklist requirements.** These are for `origin_exclusions_requirement(RequirementId, Profile, Status, Citation)`. Each has three disjoint clauses: met, `unmet(Reason)` and `unknown([Key])`.

| RequirementId | Cite | Unknown key |
|---|---|---|
| `military_activities_exclusion` | Art 2(3) | `military_activities`, when absent or `unsure` |
| `annex_iii_point_1_origin_exclusion` | Art 2(4) | `non_preferential_origin` |
| `electricity_continental_shelf_or_exclusive_economic_zone_exclusion` | Art 2(3a)(a) | first missing of `goods_kind` and `continental_shelf_or_eez_of`, where relevant |
| `hydrogen_continental_shelf_or_exclusive_economic_zone_exclusion` | Art 2(3a)(b) | first missing of `goods_kind` and `continental_shelf_or_eez_of`, where relevant |
| `third_country_origin` | Art 2(1) | `non_preferential_origin` |

For `third_country_origin`, met means the goods are of Member State origin, which gives `not_third_country_origin`.

**Verdict atoms.** As in the STATUS atoms section.

**Shared predicates.** None beyond the kernel input check and contract keys.

**Tests.**
- One per-rule test per step 0 to 12.
- Each negative (`fail`) test is paired with a positive test over the same case.
- Q4 cases:
  - norway origin with military absent gives `excluded_origin_annex_iii_point_1`;
  - hydrogen of Norwegian origin from the Norwegian shelf gives `excluded_origin_annex_iii_point_1` only.
- Q1 case: electricity from Iceland's shelf with other_third_country origin gives step 4.
- Ruling 11 case: `unsure` gives `indeterminate([military_activities])`.
- Input-check cases:
  - a duplicate with equal values gives `duplicate_key` and not `wrong_type`;
  - an unbound key gives `unknown_key(_)`;
  - a partial list gives `[wrong_type(profile)]`.
- Exhaustive single-solution counting uses `findall` with `length(_, 1)`.
