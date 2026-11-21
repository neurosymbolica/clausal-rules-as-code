# SIGNATURE — eu/cra_administrative_fines

## Public query surface

### Core contract

The core contract is fixed by the order and is non-negotiable.

- `administrative_fine_maximum(Profile, InfringementDate, Verdict, Citations)` gives exactly one solution.
- `cra_administrative_fines_input_problems(Profile, Problems)` gives exactly one solution, never fails and never raises.

### Scaffold facade

The scaffold facade names are kept. A CASE term is `cra_administrative_fines_case(Profile, InfringementDate)`, because the date is an argument and not a profile key.

- `decide_cra_administrative_fines(Case, cra_administrative_fines_verdict(Status, Citations))`, where Status is the order's VERDICT.
- `cra_administrative_fines_status(Case, Status)`.

### Profile keys

The four profile keys are listed in root_exports order:

1. `infringed_provision`: one atom of the closed list.
2. `offender_is_open_source_software_steward`: `true` / `false` / `unsure`.
3. `offender_is_undertaking`: `true` / `false` / `unsure`.
4. `total_worldwide_annual_turnover_in_euros`: a non-negative integer of whole euros.

### Determinism and totality

Every public predicate is total and deterministic: exactly ONE solution for every input term.

- The F0-F7 routes are disjoint clauses with ground outputs folded into the heads (C17).
- No `!`, `->` or `*->` is used.

Statutory figures are declared once with `:- constant_value/2` in the slice file and read with `constant/1`. No figure is imported from another domain.

## Verdict atoms

These replace the placeholders `within_limit` / `exceeds_limit`.

### Final answers

- `fine_maximum(Tier, Basis, CapInEuroCents)`
  - Tier is one of `highest_maximum_tier`, `middle_maximum_tier`, `lowest_maximum_tier`.
  - Basis is one of `fixed_amount`, `percentage_of_turnover`, `fixed_amount_for_non_undertaking`.
  - CapInEuroCents is a non-negative integer.
- `fine_excluded(open_source_software_steward)`
- `not_listed_in_article_64`
- `not_yet_applicable`

### Statuses

Every status has Citations `[]`.

- `indeterminate([Key])`: exactly one bare key. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`, optionally followed by one unscored `provenance(Clause, Citations)`.
- `input_problems(Problems)`: the terms `duplicate_key/1`, `wrong_type/1`, `unknown_key/1`.

The atoms `true` and `false` are never pinned in verdict_vocabulary or root_exports.

## Provision atoms (closed list of `infringed_provision`)

- **Highest tier, Art 64(2):** `annex_i_essential_cybersecurity_requirements`, `article_13`, `article_14`.
- **Middle tier, Art 64(3):** `article_18`, `article_19`, `article_20`, `article_21`, `article_22`, `article_23`, `article_28`, `article_30_paragraphs_1_to_4`, `article_31_paragraphs_1_to_4`, `article_32_paragraphs_1_to_3`, `article_33_paragraph_5`, `article_39`, `article_41`, `article_47`, `article_49`, `article_53`.
- **Lowest tier, Art 64(4):** `incorrect_incomplete_or_misleading_information_in_reply_to_request`.
- **Unlisted:** `other_provision`.

## Citation-key atoms

These are the canonical lexicon atoms as fixed by the order. No shortened atom is invented.

| Key | Provision | Use |
|---|---|---|
| `eu_reg_2024_2847_art_71_2` | Art 71(2) | date of application |
| `eu_reg_2024_2847_art_64_1` | Art 64(1) | national penalties; the `not_listed_in_article_64` answer |
| `eu_reg_2024_2847_art_64_2` | Art 64(2) | highest tier |
| `eu_reg_2024_2847_art_64_3` | Art 64(3) | middle tier |
| `eu_reg_2024_2847_art_64_4` | Art 64(4) | lowest tier |
| `eu_reg_2024_2847_art_64_10_b` | Art 64(10)(b) | steward derogation |

The Citations each verdict carries:

| Verdict | Citations |
|---|---|
| `not_yet_applicable` | `[cite(eu_reg_2024_2847_art_71_2)]` |
| `not_listed_in_article_64` | `[cite(eu_reg_2024_2847_art_64_1), cite(eu_reg_2024_2847_art_64_2), cite(eu_reg_2024_2847_art_64_3), cite(eu_reg_2024_2847_art_64_4)]` |
| `fine_excluded(open_source_software_steward)` | `[cite(eu_reg_2024_2847_art_64_10_b)]` |
| `fine_maximum(highest_maximum_tier, _, _)` | `[cite(eu_reg_2024_2847_art_64_2)]` |
| `fine_maximum(middle_maximum_tier, _, _)` | `[cite(eu_reg_2024_2847_art_64_3)]` |
| `fine_maximum(lowest_maximum_tier, _, _)` | `[cite(eu_reg_2024_2847_art_64_4)]` |
| every status | `[]` |

## Public predicates

### Fixed by the order

- `administrative_fine_maximum(Profile, InfringementDate, Verdict, Citations)`: the one query. It runs steps F0-F7 of THE LIMBS and gives exactly one VERDICT with its fixed CITATIONS. Art 64(1)-(4), (10)(b); Art 71(2).
- `cra_administrative_fines_input_problems(Profile, Problems)`: THE INPUT CHECK on the profile alone. It reports duplicate_key or wrong_type per contract key in contract order, then unknown_key in order of first occurrence, or `[wrong_type(profile)]` for a non-attribute-list. Art 64(2)-(4), (10)(b), read for the typed contract.

### Query-type surfaces

- `cra_administrative_fines_maximum_in_euro_cents(Tier, UndertakingJudgement, TurnoverInEuros, Basis, CapInEuroCents)`: the CALCULATION (#23).
  - UndertakingJudgement is `true` or `false`, and the inputs must be bound.
  - Returns the integer cap and its basis: the fixed amount for a non-undertaking; otherwise the percentage amount if it is strictly greater than the fixed amount, else the fixed amount.
  - Art 64(2)/(3)/(4) by Tier (reading (6)).
- `cra_administrative_fines_tier_amounts_in_euro_cents(Tier, TurnoverInEuros, FixedAmountInEuroCents, PercentageAmountInEuroCents)`: the two candidate amounts of one tier, with the highest tier floored. Art 64(2)/(3)/(4).
- `cra_administrative_fines_provision_tier(Provision, Tier)`: the closed table from provision atom to tier (20 facts, excluding `other_provision`). Art 64(2)-(4).

### Scaffold facade (names kept)

- `decide_cra_administrative_fines(Case, Verdict)`: Verdict is `cra_administrative_fines_verdict(Status, Citations)`. It delegates to `administrative_fine_maximum/4` with the Profile and InfringementDate of `cra_administrative_fines_case/2`. Citations as above.
- `cra_administrative_fines_status(Case, Status)`: the VERDICT alone, as one solution. Citations as above.
- `cra_administrative_fines_checklist(Case, Checklist)`: the JUSTIFICATION (#7).
  - It returns a list of `item(RequirementId, Status, cite(Key))` built with `eval_requirements/4` over `cra_administrative_fines_requirement/4`.
  - Each item has a Status of `met`, `unmet(Reason)`, `unknown([Key])` or `inapplicable`.
  - Every item, met ones included, carries its cite.
  - The requirement ids:

| Requirement id | Cite | Note |
|---|---|---|
| `article_64_applies_on_infringement_date` | `eu_reg_2024_2847_art_71_2` | |
| `provision_listed_in_article_64` | `eu_reg_2024_2847_art_64_1` | |
| `open_source_software_steward_derogation_not_triggered` | `eu_reg_2024_2847_art_64_10_b` | `inapplicable` for the highest tier |
| `undertaking_judgement_settled` | the tier key | |
| `turnover_supplied_where_needed` | the tier key | |
| `maximum_computed` | the tier key | |

- `cra_administrative_fines_what_if(Case, Key, Value, Status)`: the VERDICT after one edit.
  - When Key is one of the four profile keys, it replaces that attribute using `profile_set/3`.
  - When Key is `infringement_date`, it replaces the date.
  - Used for the boundary demonstrations listed below. Citations as in the base query.
- `cra_administrative_fines_fixture(Name, Case, ExpectedStatus, ExpectedCitations)`: the named fixtures (fixtures.clausal). Each pins one route of F0-F7 and the boundaries:
  - dates 2027-12-10 and 2027-12-11;
  - a tie at a turnover of 600000000 euros in the highest tier (2,5 % of it equals 1500000000 cents);
  - the odd turnover 600000001, giving 1500000002 cents with the half cent dropped;
  - a middle-tier tie at 500000000 euros;
  - a lowest-tier tie at 500000000 euros;
  - 29 February 2028 valid and 29 February 2027 invalid;
  - a float turnover;
  - a duplicate key;
  - an unknown key.

## Planned reuse (manifest `uses:`)

- `formalize_lib`: `profile_get/3` (the only profile reader, by presence then value), `profile_set/3` (what_if), `eval_requirements/4` (checklist), and the constructors `item/3`, `unmet/1`, `unknown/1`, `attribute/2`. The vocabulary atoms `met` and `inapplicable` are used.
- `kit/deadline_lib`:
  - `month_last_day/3`, for the calendar-day validation of the date argument;
  - `date_before/2`, for F1, called only on a ground, validated date.
- `validate_props` (tests): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `prop_monotone/5`. The monotone property checks that the cap does not decrease in turnover within a tier.
- Not used:
  - `library(datetime)`: `date/3` is not yet registered, and the contract carries a `date(Y, M, D)` term.
  - `kit/query_combinators`: its `what_if` works on dicts and the profile is an attribute list.
  - `ratio_bps/4`: the percentages are exact integer multipliers, not basis-point ratios of two keys.
  - `check_tri/4`: the tri-state routing has a fixed key order and fixed referral shapes that the order dictates.

## Module layout (unchanged)

`kernel -> citations -> parameters -> cra_administrative_fines -> queries -> fixtures -> package facade`

- **kernel.clausal** holds only predicates SHARED across the package:
  - `cra_administrative_fines_judgement_value/1`: the facts `true`, `false`, `unsure`.
  - `cra_administrative_fines_attribute_list/1`: a proper, ground-spine list of `attribute(_, _)` elements with none unbound.
  - `cra_administrative_fines_calendar_day/1`: a ground `date(Y, M, D)` of integers with M in 1..12 and D in 1..`month_last_day`.
  - `cra_administrative_fines_key_occurrences/3`: counts by `==`.
  - `cra_administrative_fines_contract_keys/1`: the four keys in contract order.
- **citations.clausal** holds the six `citation_key/2` facts: the key and the unit id from the table above.
- **parameters.clausal** declares no statutory figure (every figure lives in its slice). It holds only the source pin record: the CELEX id, the sha256 and the pin folder.
- **queries.clausal** holds the facade predicates above, delegating to the slice.
- **fixtures.clausal** holds `cra_administrative_fines_fixture/4`.

## Slice: cra_administrative_fines.clausal

### Value facts it owns

These are declared once with `:- constant_value(Name, Value).` and read with `constant(Name)`.

| Constant | Value | Source |
|---|---|---|
| `article_64_application_year` | 2027 | Art 71(2) |
| `article_64_application_month` | 12 | Art 71(2) |
| `article_64_application_day` | 11 | Art 71(2) |
| `highest_maximum_tier_fixed_amount_in_euro_cents` | 1500000000 | Art 64(2) |
| `middle_maximum_tier_fixed_amount_in_euro_cents` | 1000000000 | Art 64(3) |
| `lowest_maximum_tier_fixed_amount_in_euro_cents` | 500000000 | Art 64(4) |
| `highest_maximum_tier_turnover_multiplier_numerator` | 5 | Art 64(2) |
| `highest_maximum_tier_turnover_multiplier_denominator` | 2 | Art 64(2) |
| `middle_maximum_tier_turnover_multiplier_numerator` | 2 | Art 64(3) |
| `middle_maximum_tier_turnover_multiplier_denominator` | 1 | Art 64(3) |
| `lowest_maximum_tier_turnover_multiplier_numerator` | 1 | Art 64(4) |
| `lowest_maximum_tier_turnover_multiplier_denominator` | 1 | Art 64(4) |

The multipliers work because a turnover in euros times a percentage gives euro cents: 2,5 % is ×5//2, 2 % is ×2 and 1 % is ×1. Integer division (`//`) floors, which is reading (6).

The slice also owns these tables:

- `cra_administrative_fines_provision_tier/2`: 20 facts.
- `tier_citation_key/2`: each tier with its key.
- `tier_reaches_steward_derogation/1`: `middle_maximum_tier` and `lowest_maximum_tier` only (reading (7)).

The Art 14 date (2026-09-11) and the Chapter IV date (2026-06-11) are NOT declared, because no limb reads them (Q2).

### Rules / requirements (one route clause each, disjoint, in limb order)

- **F0.** The input problems are the profile problems followed by `wrong_type(infringement_date)` if the date is not `cra_administrative_fines_calendar_day`. If the list is non-empty, the verdict is `input_problems(Problems)` with Citations `[]`. All later routes require Problems `== []`.
- **F1.** `date_before(InfringementDate, date(2027,12,11))` gives `not_yet_applicable` with `[cite(eu_reg_2024_2847_art_71_2)]`. The later routes require the date to be on or after that day.
- **F2.** `infringed_provision` absent gives `indeterminate([infringed_provision])`.
- **F3.** P = `other_provision` gives `not_listed_in_article_64` with the four cites.
- **F4.** For a middle- or lowest-tier P:
  - S true gives `fine_excluded(open_source_software_steward)` with `[cite(eu_reg_2024_2847_art_64_10_b)]`;
  - S absent gives `indeterminate([offender_is_open_source_software_steward])`;
  - S false or unsure continues.
  - For the highest tier, S is never read.
- **F5.**
  - U absent gives `indeterminate([offender_is_undertaking])`.
  - U true or unsure with T absent gives `indeterminate([total_worldwide_annual_turnover_in_euros])`.
  - U false never reads T.
- **F6.**
  - S unsure (middle or lowest tier) gives `needs_legal_review(open_textured(offender_is_open_source_software_steward, cite(eu_reg_2024_2847_art_64_10_b)), [inputs_relied_on(Pairs)])`.
  - Otherwise U unsure gives `needs_legal_review(open_textured(offender_is_undertaking, cite(TierKey)), [inputs_relied_on(Pairs)])`.
  - Pairs lists, in root_exports order, `offender_is_open_source_software_steward-S` (middle or lowest tier only) and then `offender_is_undertaking-U`, with each value exactly as given.
- **F7.**
  - U false gives `fine_maximum(Tier, fixed_amount_for_non_undertaking, Fixed)`.
  - U true with Percent `>` Fixed gives `fine_maximum(Tier, percentage_of_turnover, Percent)`.
  - U true with Percent `=<` Fixed gives `fine_maximum(Tier, fixed_amount, Fixed)`.
  - Citations are `[cite(TierKey)]`.

The checklist requirements are `cra_administrative_fines_requirement(RequirementId, Profile, Status, Citation)`, with RequirementId FIRST. Each has met, unmet and unknown clauses, which are mutually exclusive. The ids are those listed for `cra_administrative_fines_checklist/2`.

### Verdict atoms

The slice produces every verdict atom of the domain. It is the only determination slice.

### Shared with another slice

The slice shares nothing beyond the kernel predicates listed above. The judgement value set, the attribute-list check, the calendar-day check, key occurrence counting and the contract key order sit in `kernel.clausal`, because `queries.clausal` and `fixtures.clausal` reuse them for what_if and the fixture validation.

## Tests (seven modes, v2 manifest)

- **Load.**
- **Per-rule.** One positive and one negative test for each route F0-F7.
- **Boundary.**
  - The dates 2027-12-10 and 2027-12-11.
  - The tier ties: highest at 600000000 euros, middle at 500000000 euros, lowest at 500000000 euros.
  - The odd-turnover floor.
  - The leap day.
- **Input check.** Order of duplicate_key, wrong_type and unknown_key; floats; unbound values; a non-atom key; a partial list.
- **Counting.** `findall` plus `length/2` = 1 for every fixture.
- **Property.** The `validate_props` collectors.
- **Fixtures.** Every `cra_administrative_fines_fixture/4` is replayed through `administrative_fine_maximum/4`, and Citations are compared as sets.
