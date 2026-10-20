# SIGNATURE — eu/procurement/life_cycle_costing

## Public query surface

The domain exposes five public predicates (scaffold facade names preserved):

- `decide_life_cycle_costing(PROFILE, VERDICT)` — the main combined verdict; VERDICT is `life_cycle_costing_verdict(METHOD_STATUS, MANDATORY_STATUS, COMPUTATION_STATUS, DEFECT_IDS, CITATIONS, TOTAL_EUR_CENTS, EXCLUDED_CATEGORIES)` combining all three determinations. Cite: eu_dir_2014_24_art_68_1, eu_dir_2014_24_art_68_2, eu_dir_2014_24_art_68_3.
- `life_cycle_costing_status(PROFILE, STATUS)` — a single-atom summary: `compliant` / `non_compliant` / `indeterminate`. Cite: eu_dir_2014_24_art_68_2.
- `life_cycle_costing_checklist(PROFILE, CHECKLIST)` — the full per-limb checklist with `cite(...)` provenance per item. Cite: eu_dir_2014_24_art_68_2.
- `life_cycle_costing_what_if(PROFILE, KEY, VALUE, RESULT)` — override one profile key and re-decide all three determinations. Cite: eu_dir_2014_24_art_68_2.
- `fixtures` — test fixture profiles covering all seven test modes. Cite: —.

PROFILE keys (12, bare atoms; native booleans except where noted):
- `cost_components` — flat list of three-element lists [CATEGORY_ATOM, AMOUNT_EUR_CENTS, DETERMINABLE_INT]; may be empty; same category may appear more than once
- `tenderer_data_indicated_in_procurement_documents` — boolean
- `costing_method_indicated_in_procurement_documents` — boolean
- `externality_method_criteria_objectively_verifiable` — boolean
- `externality_method_criteria_non_discriminatory` — boolean
- `externality_method_established_for_repeated_or_continuous_application` — boolean
- `externality_method_unduly_favours_or_disadvantages_operators` — boolean (NEGATIVE polarity: True = defect exists)
- `externality_method_accessible_to_all_interested_parties` — boolean
- `externality_data_obtainable_with_reasonable_effort` — boolean
- `externality_data_obtainable_by_third_country_gpa_operators` — boolean
- `union_common_method_act_key` — bare atom (one of three union-act atoms)
- `union_common_method_applied` — boolean

## Verdict STATUS vocabulary

### Method validity (determination A)
- `valid_lcc_method`
- `invalid_lcc_method`

### Mandatory method (determination B)
- `union_common_method_mandatory_and_applied`
- `union_common_method_mandatory_not_applied`
- `no_union_common_method_mandatory`

### Computation (determination C)
- `lcc_total_computed`
- `lcc_no_costs_declared`
- `lcc_indeterminate`

### Combined status (life_cycle_costing_status/2)
- `compliant`
- `non_compliant`
- `indeterminate`

## Defect IDs (fixed statutory order, 9 limbs)

1. `tenderer_data_not_indicated`
2. `costing_method_not_indicated`
3. `externality_criteria_not_objectively_verifiable`
4. `externality_criteria_discriminatory`
5. `undue_favour_or_disadvantage_of_economic_operators`
6. `externality_method_not_accessible`
7. `externality_data_not_obtainable_with_reasonable_effort`
8. `externality_data_not_obtainable_by_third_country_gpa_operators`
9. `externality_monetary_value_not_determinable`

## Cost category atoms (fixed order, 6)

1. `acquisition_cost`
2. `cost_of_use`
3. `maintenance_cost`
4. `end_of_life_cost`
5. `environmental_externality_cost`
6. `other_cost_borne_by_authority_or_users`

## Union-act atoms (3)

- `no_union_common_method`
- `directive_2009_33_ec`
- `other_union_legislative_act`

## Component admissibility statuses

- `component_included`
- `component_excluded`

## Externality assessment atoms

- `externality_costs_assessed`
- `externality_costs_not_assessed`

## Limb status atoms (lcc_method_validity_limb_status/4)

- `satisfied`
- `not_satisfied`

## Mandatory method status atoms (lcc_mandatory_method_status/3)

- `mandatory_and_applied`
- `mandatory_not_applied`
- `not_mandatory`

## Union act listing atoms (lcc_union_act_listing/2)

- `listed_in_annex_xiii`
- `not_listed_in_annex_xiii`

## Citation-key atoms

- `eu_dir_2014_24_art_68_1`
- `eu_dir_2014_24_art_68_2`
- `eu_dir_2014_24_art_68_3`
- `eu_dir_2014_24_annex_xiii`
- `eu_dir_2009_33_ec`

## Public predicates (one line each)

- `decide_life_cycle_costing(PROFILE, VERDICT)`: combined three-determination verdict with defect IDs, parallel citations, total, and excluded categories. Cite: eu_dir_2014_24_art_68_1, eu_dir_2014_24_art_68_2, eu_dir_2014_24_art_68_3.
- `life_cycle_costing_status(PROFILE, STATUS)`: single-atom compliance summary derived from the three determinations. Cite: eu_dir_2014_24_art_68_2.
- `life_cycle_costing_checklist(PROFILE, CHECKLIST)`: per-limb checklist with cite(...) provenance for every item including satisfied limbs. Cite: eu_dir_2014_24_art_68_2.
- `life_cycle_costing_what_if(PROFILE, KEY, VALUE, RESULT)`: override one profile key with a new value and re-decide. Cite: eu_dir_2014_24_art_68_2.
- `fixtures`: test fixture profiles for all seven test modes. Cite: —.

## Verdict constructors (one line each)

- `lcc_method_validity_verdict(STATUS, DEFECT_IDS, CITATIONS)`: the verdict term bound by decide_lcc_method_validity/2; STATUS is valid_lcc_method or invalid_lcc_method, DEFECT_IDS is a list of bare defect atoms in fixed statutory order with no duplicates, CITATIONS is the parallel list of cite(ATOM) terms. Cite: eu_dir_2014_24_art_68_2.
- `lcc_mandatory_method_verdict(STATUS, DEFECT_IDS, CITATIONS)`: the verdict term bound by decide_lcc_mandatory_method/2; STATUS is one of the three mandatory-method atoms, DEFECT_IDS carries at most one defect atom (union_common_method_not_applied), CITATIONS is the parallel list of cite(ATOM) terms. Cite: eu_dir_2014_24_art_68_3.
- `lcc_computation_verdict(STATUS, TOTAL_EUR_CENTS, EXCLUDED_CATEGORIES)`: the verdict term bound by decide_lcc_computation/2; STATUS is one of the three computation atoms, TOTAL_EUR_CENTS is an integer (unbound on lcc_no_costs_declared and lcc_indeterminate), EXCLUDED_CATEGORIES is a list of bare cost-category atoms in fixed order with no duplicates. Cite: eu_dir_2014_24_art_68_1.

## Internal predicates (implementation within the slice)

- `decide_lcc_method_validity(PROFILE, VERDICT)`: Art 68(1)(b) + Art 68(2) method validity; never reads union-act keys. Cite: eu_dir_2014_24_art_68_2.
- `decide_lcc_mandatory_method(PROFILE, VERDICT)`: Art 68(3) displacement; never reads Art 68(2) flags or component list. Cite: eu_dir_2014_24_art_68_3.
- `decide_lcc_computation(PROFILE, VERDICT)`: Art 68(1) exact integer sum; reads component list and nothing else. Cite: eu_dir_2014_24_art_68_1.
- `lcc_method_validity_limb_status(LIMB_ID, PROFILE, STATUS, CITATION)`: per-limb status with one cite(ATOM) term; takes bound atom in arg 1, profile dict in arg 2. Cite: eu_dir_2014_24_art_68_2.
- `lcc_externality_assessment(COST_COMPONENTS, ASSESSMENT)`: inner gate; reads only the category atoms in the list. Cite: eu_dir_2014_24_art_68_1.
- `lcc_total(COST_COMPONENTS, TOTAL_EUR_CENTS)`: exact integer sum of admissible components; fails on any negative amount. Cite: eu_dir_2014_24_art_68_1.
- `lcc_component_admissibility(COST_CATEGORY, MONETARY_VALUE_DETERMINABLE_AND_VERIFIED, STATUS)`: scalar inputs (atom + integer 1/0), one status atom out. Cite: eu_dir_2014_24_art_68_1.
- `lcc_mandatory_method_status(UNION_ACT_KEY, UNION_COMMON_METHOD_APPLIED, STATUS)`: scalar inputs (atom + integer 1/0), one status atom out. Cite: eu_dir_2014_24_art_68_3.
- `lcc_union_act_listing(UNION_ACT_KEY, LISTING)`: one bound atom in, one listing atom out. Cite: eu_dir_2014_24_annex_xiii.

## Planned reuse

- `formalize_lib`: `profile_get/3`, `check_true/4`, `check_false/4`, `sum_list/2`, `assess/6`, `item/3`, `met`, `unmet/1`, `labels/3`, `assessment/3` — for profile access, boolean checks, list summation, and the checklist engine.
- `kit.query_combinators`: `what_if/4`, `override_key/4` — for the what-if predicate.
- `validate_props`: `run_props/1`, `prop_totality/3`, `prop_determinism/3` — for test verification.
- `citations`: bare atom keys; text resolved from the shared lexicon via LEXICON-ENTRIES.yaml.
- `eu.procurement.directive_2014_24.vocabulary`: NOT imported. Art 68 has no hook for contract-type, authority-type, or procedure-type vocabulary. No clause in this domain spells a name from that backbone.

Genuinely local vocabulary (declared in this package, not imported from any kit or backbone):
- All 12 profile key atoms
- All 6 cost category atoms
- All 3 union-act atoms
- All 9 defect ID atoms
- All verdict status atoms (method, mandatory, computation, combined)
- All admissibility / assessment / listing / limb-status atoms
- All 5 citation-key atoms
- All 3 verdict constructor functors (lcc_method_validity_verdict, lcc_mandatory_method_verdict, lcc_computation_verdict)

## Determination slice: life_cycle_costing.clausal

### Statutory value facts owned by this slice

- The six cost-category atoms and their fixed order.
- The three union-act atoms.
- The nine defect-ID atoms and their fixed statutory order.
- The two applicability gates (outer: empty component list; inner: no externality category present).
- The no-rounding, no-division arithmetic rule (exact integer sum only).
- The negative-amount fail-closed rule (lcc_total/2 yields no solution).
- The polarity convention (8 positive flags, 1 negative flag).
- The mixed flag convention (profile booleans True/False vs. component-record and scalar-predicate integers 1/0).
- The declaratory (non-constitutive) reading of Annex XIII.

### Rules / requirements

1. **Outer gate**: empty `cost_components` → all nine limbs `satisfied`, verdict `valid_lcc_method`, empty DEFECT_IDS, empty CITATIONS.
2. **Inner gate**: no `environmental_externality_cost` in components → limbs 3–9 `satisfied`; only limbs 1–2 live.
3. **Limb 1**: `tenderer_data_indicated_in_procurement_documents` is False → defect `tenderer_data_not_indicated`.
4. **Limb 2**: `costing_method_indicated_in_procurement_documents` is False → defect `costing_method_not_indicated`.
5. **Limb 3**: `externality_method_criteria_objectively_verifiable` is False → defect `externality_criteria_not_objectively_verifiable`.
6. **Limb 4**: `externality_method_criteria_non_discriminatory` is False → defect `externality_criteria_discriminatory`.
7. **Limb 5**: `externality_method_established_for_repeated_or_continuous_application` is False AND `externality_method_unduly_favours_or_disadvantages_operators` is True → defect `undue_favour_or_disadvantage_of_economic_operators`. Never reads the non-discriminatory flag.
8. **Limb 6**: `externality_method_accessible_to_all_interested_parties` is False → defect `externality_method_not_accessible`.
9. **Limb 7**: `externality_data_obtainable_with_reasonable_effort` is False → defect `externality_data_not_obtainable_with_reasonable_effort`.
10. **Limb 8**: `externality_data_obtainable_by_third_country_gpa_operators` is False → defect `externality_data_not_obtainable_by_third_country_gpa_operators`.
11. **Limb 9**: any externality component with third element 0 → defect `externality_monetary_value_not_determinable` (reported once regardless of count).
12. **Mandatory method applied**: `union_common_method_act_key` is not `no_union_common_method` AND `union_common_method_applied` is True → `union_common_method_mandatory_and_applied`.
13. **Mandatory method not applied**: `union_common_method_act_key` is not `no_union_common_method` AND `union_common_method_applied` is False → `union_common_method_mandatory_not_applied`, defect `union_common_method_not_applied`.
14. **No mandatory method**: `union_common_method_act_key` is `no_union_common_method` → `no_union_common_method_mandatory`.
15. **Computation — no costs**: empty `cost_components` → `lcc_no_costs_declared`, TOTAL_EUR_CENTS unbound, EXCLUDED_CATEGORIES empty.
16. **Computation — indeterminate**: any component with negative AMOUNT_EUR_CENTS → `lcc_indeterminate`, EXCLUDED_CATEGORIES empty.
17. **Computation — computed**: all amounts non-negative → `lcc_total_computed`, TOTAL_EUR_CENTS is the exact integer sum of admissible components, EXCLUDED_CATEGORIES lists excluded categories in fixed order with no duplicates.
18. **Admissibility**: non-externality categories (1–4, 6) always `component_included`; `environmental_externality_cost` is `component_included` iff third element is 1, `component_excluded` iff 0.
19. **Externality assessment**: at least one component carries `environmental_externality_cost` → `externality_costs_assessed`; otherwise → `externality_costs_not_assessed`. Reads only category atoms, not amounts or third elements.
20. **Union act listing**: `directive_2009_33_ec` → `listed_in_annex_xiii`; `no_union_common_method` and `other_union_legislative_act` → `not_listed_in_annex_xiii`.

### Verdict vocabulary (this slice)

- Method: `valid_lcc_method`, `invalid_lcc_method`
- Mandatory: `union_common_method_mandatory_and_applied`, `union_common_method_mandatory_not_applied`, `no_union_common_method_mandatory`
- Computation: `lcc_total_computed`, `lcc_no_costs_declared`, `lcc_indeterminate`
- Combined: `compliant`, `non_compliant`, `indeterminate`
- Limb status: `satisfied`, `not_satisfied`
- Admissibility: `component_included`, `component_excluded`
- Externality assessment: `externality_costs_assessed`, `externality_costs_not_assessed`
- Mandatory status: `mandatory_and_applied`, `mandatory_not_applied`, `not_mandatory`
- Listing: `listed_in_annex_xiii`, `not_listed_in_annex_xiii`

### Vocabulary shared with kernel.clausal

None. This domain is a single-slice package. All domain-specific vocabulary is local to `life_cycle_costing.clausal`. The kernel provides only the shared floor (module loading, basic utilities) and no domain-specific atoms. No vocabulary is shared with any other slice because there is only one slice.
