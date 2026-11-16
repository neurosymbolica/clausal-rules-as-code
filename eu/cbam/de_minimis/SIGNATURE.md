# SIGNATURE — eu/cbam/de_minimis

## Public query surface

The core contract has three predicates:
- `de_minimis_exemption(Profile, Result, Citations)`
- `de_minimis_goods_status(Profile, Result, Citations)`
- `de_minimis_input_problems(Profile, Problems)`

The scaffold facade keeps these names:
- `decide_de_minimis/2`
- `de_minimis_status/2`
- `de_minimis_checklist/2`
- `de_minimis_what_if/4`
- fixtures

Every query is total and deterministic: it yields EXACTLY ONE solution for every term given. It never fails and never raises.
- Routes are disjoint clauses with the ground verdict folded into the head (C17).
- There is no `!`, `->`, `*->` or `once/1`.
- Disjointness comes from mutually exclusive guards.
- No figure is imported from another domain. The only statutory value facts live in `de_minimis.clausal`.

## Verdict STATUS atoms

These replace the placeholders `required / permitted / not_applicable`.

- `de_minimis_exemption/3` final atoms:
  - `de_minimis_exemption_applies`
  - `de_minimis_exemption_does_not_apply`
- `de_minimis_goods_status/3` final atoms:
  - `outside_de_minimis_exemption`
  - `counted_toward_threshold`
  - `not_goods_of_this_regulation`
- Not-final status compounds, for both queries, with exact functors and arities. The bare atom `indeterminate` is never written.
  - `indeterminate([Key])`
  - `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`, optionally followed by an unscored `provenance(Clause, Citations)`
  - `input_problems(Problems)`
- Problem terms:
  - `unknown_key(Key)`
  - `wrong_type(Key)`
  - `duplicate_key(Key)`
  - `wrong_type(profile)`

## Profile keys

There are five keys, in root_exports / input_contract order. The profile is `[attribute(Key, Value), ...]`, read only with `profile_get/3`. There are no date-valued keys: the year basis is an enumeration (Q1), so no `date(Year, Month, Day)` term enters the profile.

1. `single_mass_based_threshold_tonnes` — figure; a non-negative integer, in whole tonnes.
2. `year_date_basis` — enumeration:
   - `acceptance_of_the_customs_declaration`
   - `release_for_free_circulation`
   - `unsure`
3. `net_mass_kg_by_acceptance_date` — figure; a non-negative integer, in kilograms.
4. `net_mass_kg_by_release_date` — figure; a non-negative integer, in kilograms.
5. `goods_kind` — enumeration:
   - `electricity`
   - `hydrogen`
   - `other_annex_i_goods`
   - `goods_not_listed_in_annex_i`

## Citation-key atoms

These use the canonical lexicon scheme (`_lexicon/citations.yaml`), with no shortened forms.

- `eu_reg_2023_956_art_2_1` — Art 2(1)
- `eu_reg_2023_956_art_2a_1` — Art 2a(1); also the referral citation
- `eu_reg_2023_956_art_2a_2` — Art 2a(2)
- `eu_reg_2023_956_art_2a_4` — Art 2a(4)
- `eu_reg_2023_956_art_3_15` — Art 3, point (15)
- `eu_reg_2023_956_annex_i_1` — Annex I, point 1
- `eu_reg_2023_956_annex_i_electricity` — Annex I, Electricity division
- `eu_reg_2023_956_annex_vii_1` — Annex VII, point 1
- Deferred: recorded in citations.clausal with status `deferred`, and never emitted by a query:
  - `eu_reg_2023_956_art_2a_3`
  - `eu_reg_2023_956_annex_i_chemicals`

## Public predicates

- `de_minimis_exemption(Profile, Result, Citations)`: exemption per importer and year, following limbs 0 to 6 below. Citations: art_2a_1, annex_vii_1, art_3_15, plus art_2a_2 when the exemption does not apply. The referral cites art_2a_1.
- `de_minimis_goods_status(Profile, Result, Citations)`: status of one import, following limbs 0 and 7 to 11. Citations: art_2a_4, annex_i_electricity, art_2a_1, annex_i_1, art_2_1.
- `de_minimis_input_problems(Profile, Problems)`: the input check. It returns the BARE problem list, `[]` when the profile is well-formed. Citation: the input_contract, which is not legal.
- `decide_de_minimis(Profile, Verdict)`: `Verdict = de_minimis_verdict(Status, Citations)`, where Status and Citations are exactly those of `de_minimis_exemption/3`. This is query type #2, the eligibility verdict. Citations as for `de_minimis_exemption/3`.
- `de_minimis_status(Profile, Status)`: the bare Status of `de_minimis_exemption/3` (an atom or a status compound, never a list). Citation: art_2a_1.
- `de_minimis_checklist(Profile, Checklist)`: a list of `item(RequirementId, ItemStatus, cite(Key))`, built with `formalize_lib:eval_requirements/4` over `de_minimis_requirement/4`. ItemStatus is `met`, `unmet(Reason)` or `unknown([Key])`. This is query type #7: every item carries `cite`, met items included. The rows are:
  - `relevant_figures_within_threshold` cites art_2a_1 and annex_vii_1.
  - `threshold_in_force_stated` cites annex_vii_1.
  - `date_basis_settles_year` cites art_2a_1; an open-textured `unknown([year_date_basis])` hands the question to the user.
  - `importer_figures_aggregated` cites art_3_15.
- `de_minimis_what_if(Profile, Key, Value, Result)`: `query_combinators:what_if/5` with Decide = `de_minimis_status`. It replaces Key by Value and returns the new Status. Citation: as for `de_minimis_exemption/3`.
- `fixtures`: `de_minimis_fixture(Name, Profile, ExpectedResult, ExpectedCitations)` rows in `fixtures.clausal`. They cover each limb 0 to 11 and the boundary at exactly `Limit` (with the pinned 50: 50000 kg within, 50001 kg above). Further rows cover zero figures with the threshold absent, duplicate keys, a non-atom key, an unbound value, a partial list and an unbound profile.

## Determination slice: de_minimis.clausal

### Value facts owned by this slice

- `:- constant_value(kilograms_per_tonne, 1000).`
  - This is the unit conversion, read through `constant(kilograms_per_tonne)`.
  - It computes `Limit is ThresholdTonnes * constant(kilograms_per_tonne)`, on exact integers.
- `:- constant_value(pinned_single_mass_based_threshold_tonnes, 50).`
  - This is Annex VII, point 1 as pinned (cites annex_vii_1).
  - It is used ONLY by fixtures and documentation, NEVER as a default for an absent key (Q5).
- Enumeration tables:
  - `de_minimis_year_date_basis_value/1`: three rows.
  - `de_minimis_goods_kind_value/1`: four rows.
  - `de_minimis_figure_key/1`: three rows.
  - `de_minimis_contract_key/2`: five rows, `Key-Type`, in contract order.

### Derived arithmetic and helpers

- `de_minimis_limit_kilograms(Profile, Limit)` succeeds only when the threshold is present.
- `de_minimis_relevant_figure_keys(Profile, Keys)` has three disjoint clauses, keyed on the date basis:
  - `acceptance_of_the_customs_declaration` gives `[net_mass_kg_by_acceptance_date]`.
  - `release_for_free_circulation` gives `[net_mass_kg_by_release_date]`.
  - `unsure` or absent gives both keys. Absence is guarded with `profile_lacks/2`.
- `de_minimis_figure_within(Profile, Key)`: the figure is 0, OR the threshold is present and `Figure =< Limit`. These are written as two disjoint clauses: one for figure 0, one for figure greater than 0 with the threshold present. This avoids a double solution at 0.
- `de_minimis_figure_above(Profile, Key)`: the threshold is present and `Figure > Limit`.
- `de_minimis_every_relevant_within(Profile)` and `de_minimis_every_relevant_above(Profile)` are deterministic list walks.

### Rules (limbs, first that answers decides)

Step 0 applies to both queries. Steps 1 to 6 are `de_minimis_exemption/3`; steps 7 to 11 are `de_minimis_goods_status/3`.

| Step | Condition | Result | Citations |
|---|---|---|---|
| 0 | Problems `\== []` | `input_problems(Problems)` | `[]` |
| 1 | Problems `[]`, every relevant figure present and WITHIN | `de_minimis_exemption_applies` | art_2a_1, annex_vii_1, art_3_15 |
| 2 | Every relevant figure present and ABOVE | `de_minimis_exemption_does_not_apply` | art_2a_1, art_2a_2, annex_vii_1, art_3_15 |
| 3 | Not step 1 or 2, a relevant figure absent | `indeterminate([FirstAbsentRelevantFigure])` | `[]` |
| 4 | All relevant figures present, threshold absent, not step 1 or 2 | `indeterminate([single_mass_based_threshold_tonnes])` | `[]` |
| 5 | Threshold present, date basis absent, figures split | `indeterminate([year_date_basis])` | `[]` |
| 6 | Threshold present, date basis `unsure`, figures split | `needs_legal_review(open_textured(year_date_basis, cite(eu_reg_2023_956_art_2a_1)), [inputs_relied_on([year_date_basis-unsure])])` | `[]` |
| 7 | `goods_kind` = electricity | `outside_de_minimis_exemption` | art_2a_4, annex_i_electricity |
| 8 | `goods_kind` = hydrogen | `outside_de_minimis_exemption` | art_2a_4 |
| 9 | `goods_kind` = other_annex_i_goods | `counted_toward_threshold` | art_2a_1, annex_i_1 |
| 10 | `goods_kind` = goods_not_listed_in_annex_i | `not_goods_of_this_regulation` | art_2_1, annex_i_1 |
| 11 | `goods_kind` absent | `indeterminate([goods_kind])` | `[]` |

Step 3 picks the first absent relevant figure via `formalize_lib:missing_keys/3`, in root_exports order.

Disjointness of steps 1 to 6:
- Steps 1 and 2 cannot both hold, because WITHIN and ABOVE exclude each other on a present figure.
- Steps 3 to 6 are guarded by `\+ de_minimis_every_relevant_within` and `\+ de_minimis_every_relevant_above`, plus presence or absence tests.

### Input check (in this slice, since only it uses it)

`de_minimis_input_problems/2` is built from disjoint clauses on the shape of the profile:
- An unbound profile, a non-list, a partial list, or a list with a non-`attribute/2` element or an unbound element gives `[wrong_type(profile)]`.
- The test is a local `de_minimis_attribute_list/1`, written with `var/1` and `nonvar/1` guards so that it never binds or loops.
- Otherwise the problems are built per contract key, in order: `duplicate_key(Key)` if the key occurs more than once, without reading its values; else `wrong_type(Key)` if the value is unbound or of the wrong type.
- Then `unknown_key(Key)` follows for each non-contract key (non-atom keys included, as given), deduplicated in first-occurrence order.
- The non-contract keys are matched with `==` and never by unification, so unbound keys stay distinct.

### Checklist requirements

`de_minimis_requirement(RequirementId, Profile, Status, Citation)` has the RequirementId first, as the `eval_requirements` closure expects. Each requirement has exactly three disjoint clauses: met, unmet and unknown.

### Verdict atoms of this slice

All atoms above. This is the only slice.

### Shared with another slice (kernel.clausal)

None. `kernel.clausal` keeps only the result-constructor declarations (`indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`) and re-exports of formalize_lib profile access. No predicate is shared, because there is a single determination slice.

## Planned reuse (manifest `uses:`)

- **formalize_lib**:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2` and `missing_keys/3` (first absent relevant figure)
  - `eval_requirements/4` (checklist; no hand-rolled findall row-helper, lint R1)
  - `item/3`, `attribute/2`, `unmet/1`, `unknown/1`
  - `has_unknown/1`, `has_unmet/1`
  - `not_member/2`, `memberd/2`
- **kit.query_combinators**: `what_if/5` for `de_minimis_what_if/4`.
- **validate_props**:
  - `run_props/1`, `prop_totality/3`, `prop_determinism/3`
  - `prop_citation_complete/3`, `prop_boundary_coverage/2` (50000 / 50001 kg at the pinned threshold), `prop_missing_key_coverage/3`
  - `prop_monotone/5` (a larger figure never turns `does_not_apply` into `applies`)
- **Not used**:
  - currency_vocab and vat_category: no money.
  - deadline_lib, rolling_window and date_time: no date inputs.
  - compliance_lib: there is no norm lattice, because the exemption is a single deontic switch read off a figure.
  - country: not needed.
