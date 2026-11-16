# SIGNATURE — eu/nis2_supervision_fines

## Public query surface (summary)

### The facade verdict

`decide_nis2_supervision_fines(Profile, nis2_supervision_fines_verdict(Status, Citations))` answers one question: is the Art 34 administrative fine available to the competent authority on the stated facts?

`nis2_supervision_fines_status(Profile, Status)` projects the Status.

`nis2_supervision_fines_checklist(Profile, Checklist)` gives the cited checklist, which serves query types #2 and #7.

### The six contract predicates

These live in the slice and are re-exported by the facade:

- `fine_ceiling_floor/3`;
- `minimum_powers/2`;
- `escalation_powers_exercisable/3`;
- `fine_barred_by_gdpr_fine/3`;
- `data_protection_authority_information/2`;
- `nis2_supervision_fines_input_problems/2`.

### Totality and determinism

Every public predicate is TOTAL and DETERMINISTIC. It gives exactly one solution for every ground profile, including ill-formed ones, which give `input_problems(Problems)`.

All statutory figures are declared once as `constant_value` facts inside the slice. Nothing is imported from another domain.

## Verdict STATUS atoms

These replace the placeholder `{ required, permitted, not_applicable }`.

- `eligible`: the Art 34 fine is available. The infringement is of Art 21 or 23, the class is known and there is no GDPR bar.
- `ineligible`: the fine is not available. Either the infringement is `other`, or the fine is barred by a GDPR Art 58(2)(i) fine for the same conduct (Art 35(2)).
- `indeterminate(MissingKeys)`: needed keys are absent. They are listed in root_exports order.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`: the facts are complete, but an unsure judgement decides.
- `input_problems(Problems)`: the input check failed. Citations are `[]`.

The bare atom `indeterminate` is never written.

The contract result constructors (exported, never queried) are:

- `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`;
- `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`;
- `minimum_national_maximum/2`, `power/3`, `not_exercisable/1`;
- `inform_gdpr_supervisory_authorities/1`, `inform_supervisory_authority_in_own_member_state/1`.

## Profile keys

The profile is an attribute list `[attribute(Key, Value), ...]`, read only with `profile_get/3`, `profile_has/2` and `profile_lacks/2`. It has twelve keys, in root_exports and input_contract order:

| # | Key | Type |
|---|---|---|
| 1 | `entity_class` | enumeration `essential` / `important` |
| 2 | `infringed_provision` | enumeration `art_21` / `art_23` / `other` |
| 3 | `worldwide_annual_turnover_eur` | non-negative integer, whole euros (contract-fixed unit) |
| 4 | `entity_is_public_administration` | crisp |
| 5 | `earlier_measures_ineffective` | judgement (`true` / `false` / `unsure`) |
| 6 | `deadline_set_for_necessary_action` | crisp |
| 7 | `required_action_taken_within_deadline` | crisp |
| 8 | `infringement_may_entail_notifiable_personal_data_breach` | judgement |
| 9 | `authority_became_aware_in_supervision_or_enforcement` | crisp |
| 10 | `data_protection_authority_in_other_member_state` | crisp |
| 11 | `gdpr_fine_imposed_under_art_58_2_i` | crisp |
| 12 | `gdpr_fine_for_same_conduct` | judgement |

No date keys are used.

## Citation-key atoms

The canonical lexicon scheme is `_lexicon/citations.yaml`. These atoms are the `citation_vocabulary`, written verbatim and never shortened further.

- Art 32(2): `eu_dir_2022_2555_art_32_2_a`, `eu_dir_2022_2555_art_32_2_b`, `eu_dir_2022_2555_art_32_2_c`, `eu_dir_2022_2555_art_32_2_d`, `eu_dir_2022_2555_art_32_2_e`, `eu_dir_2022_2555_art_32_2_f`, `eu_dir_2022_2555_art_32_2_g`
- Art 32(4): `eu_dir_2022_2555_art_32_4_a`, `eu_dir_2022_2555_art_32_4_b`, `eu_dir_2022_2555_art_32_4_c`, `eu_dir_2022_2555_art_32_4_d`, `eu_dir_2022_2555_art_32_4_e`, `eu_dir_2022_2555_art_32_4_f`, `eu_dir_2022_2555_art_32_4_g`, `eu_dir_2022_2555_art_32_4_h`, `eu_dir_2022_2555_art_32_4_i`
- Art 32(5): `eu_dir_2022_2555_art_32_5`, `eu_dir_2022_2555_art_32_5_a`, `eu_dir_2022_2555_art_32_5_b`
- Art 33(2): `eu_dir_2022_2555_art_33_2_a`, `eu_dir_2022_2555_art_33_2_b`, `eu_dir_2022_2555_art_33_2_c`, `eu_dir_2022_2555_art_33_2_d`, `eu_dir_2022_2555_art_33_2_e`, `eu_dir_2022_2555_art_33_2_f`
- Art 33(4): `eu_dir_2022_2555_art_33_4_a`, `eu_dir_2022_2555_art_33_4_b`, `eu_dir_2022_2555_art_33_4_c`, `eu_dir_2022_2555_art_33_4_d`, `eu_dir_2022_2555_art_33_4_e`, `eu_dir_2022_2555_art_33_4_f`, `eu_dir_2022_2555_art_33_4_g`, `eu_dir_2022_2555_art_33_4_h`
- Art 34: `eu_dir_2022_2555_art_34_4`, `eu_dir_2022_2555_art_34_5`
- Art 35: `eu_dir_2022_2555_art_35_1`, `eu_dir_2022_2555_art_35_2`, `eu_dir_2022_2555_art_35_3`

`citations.clausal` declares each as `citation_vocabulary(Key)` with its unit id.

## Public predicates

- `fine_ceiling_floor(Profile, Ceiling, Citations)`: the least national maximum fine. Ceiling is one of:
  - `minimum_national_maximum(AmountEur, Basis)`, where Basis is `fixed_amount` or `turnover_percentage`;
  - `no_union_minimum`;
  - `indeterminate(Keys)`;
  - `input_problems(Problems)`.

  It cites Art 34(4) or 34(5).
- `minimum_powers(Profile, Powers)`: ONE article-ordered list of `power(Kind, Measure, cite(Key))`, or a status compound. It cites Art 32(2), (4) and (5), or Art 33(2) and (4).
- `escalation_powers_exercisable(Profile, Result, Citations)`: Result is `exercisable` or `not_exercisable(Reason)`, or a status compound. It cites Art 32(5).
- `fine_barred_by_gdpr_fine(Profile, Result, Citations)`: Result is `fine_barred` or `fine_not_barred`, or a status compound. It cites Art 35(2), and Art 35(1) inside open_textured.
- `data_protection_authority_information(Profile, Duty)`: ONE list of duties (`[]` when none), or a status compound. It cites Art 35(1) and 35(3).
- `nis2_supervision_fines_input_problems(Profile, Problems)`: the typed input check. Problems is `[]` or an ordered list of problem terms. It is the input_contract and has no legal citation.
- `decide_nis2_supervision_fines(Profile, nis2_supervision_fines_verdict(Status, Citations))`: the facade verdict on fine availability. Citations is the set of the checklist items' cites, or `[]` when Status is input_problems. It cites Art 34(4) or (5) and Art 35(2).
- `nis2_supervision_fines_status(Profile, Status)`: the Status projection of decide.
- `nis2_supervision_fines_checklist(Profile, Checklist)`: a list of `item(RequirementId, ItemStatus, cite(Key))`. ItemStatus is one of formalize_lib `met`, `unmet(Reason)` or `unknown(Keys)`. Every item, met included, carries a cite.
- `nis2_supervision_fines_what_if(Profile, Key, Value, Verdict)`: re-decides on the profile with `attribute(Key, Value)` set by `profile_set/3`. Verdict is the `nis2_supervision_fines_verdict/2` of the edited profile.
- `nis2_supervision_fines_fixture(Name, Profile)` (fixtures.clausal): the named test profiles. There are one or more per limb, plus the boundary cases at the fixed/percentage tie:
  - essential turnover 500 000 000 gives exactly 10 000 000, basis `fixed_amount`;
  - essential turnover 500 000 001 gives 10 000 001, basis `turnover_percentage`, rounded up;
  - important turnover 500 000 000 gives exactly 7 000 000, basis `fixed_amount`.

## Planned reuse (manifest `uses:`)

- **formalize_lib** provides:
  - profile access: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `missing_keys/3`;
  - the checklist engine: `assess/6`, `has_unmet/1`, `has_unknown/1`;
  - constructors and vocabulary: `item/3`, `unmet/1`, `unknown/1`, `labels/3`, `attribute/2`, `met`;
  - `int_max/3`, for the higher of the fixed and percentage amounts.

  The requirement predicate is passed to `assess/6` as the closure `nis2_supervision_fines_requirement`, with head `nis2_supervision_fines_requirement(RequirementId, Profile, Status, Citation)`.
- **validate_props**: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2` and `prop_missing_key_coverage/3`, in the test modes.
- **Not used, with reasons:**
  - `check_tri/4` is not used for the open-textured keys, because the contract needs `needs_legal_review`, not a Kleene unknown. The facade checklist maps the slice result instead.
  - deadline_lib is not used: no dates.
  - currency_vocab is not used: the unit is in the key name.
- **Local, with a reuse note in the working notes (not published):** the attribute-list input checker.

## Layout

The package layout is `kernel -> citations -> parameters -> nis2_supervision_fines -> queries -> fixtures -> package facade`. It is unchanged.

- `parameters.clausal` holds no statutory figure. The figures live in the slice; parameters keeps only the scaffold's empty export.
- `queries.clausal` re-exports the six contract predicates and holds decide, status, checklist and what_if.

The seven test modes are:

1. load;
2. per-rule unit;
3. boundary;
4. missing-key;
5. input-check;
6. counting (`findall` length 1 per query per fixture);
7. properties (validate_props).

## kernel.clausal (shared floor)

The kernel owns the only predicates shared between the slice and queries/facade:

- `nis2_supervision_fines_contract_key(Key, Type)`: twelve facts in contract order. Type is one of:
  - `enumeration([essential, important])`;
  - `enumeration([art_21, art_23, other])`;
  - `non_negative_integer`;
  - `crisp`;
  - `judgement`.
- `nis2_supervision_fines_input_problems(Profile, Problems)`: exactly one solution, computed in this order.
  1. If Profile is not a proper list, or any element is not `attribute(Key, Value)`, the answer is `[wrong_type(profile)]` alone.
  2. Otherwise, for each contract key in order:
     - `duplicate_key(Key)` if it occurs more than once, with its values not read;
     - else `wrong_type(Key)` if it is present with a value outside its type:
       - a judgement value is not `true`, `false` or `unsure`;
       - a crisp value is not `true` or `false`;
       - an enumeration value is not one of its atoms;
       - a turnover is not an integer `>= 0`; a float or rational is wrong.
  3. Then `unknown_key(Key)` for each non-contract key, in order of first occurrence, deduplicated.

  Absence is never a problem.
- `nis2_supervision_fines_pairs(Profile, JudgementKeys, Pairs)`: the `Key-Value` pairs of the listed judgement keys that are PRESENT, in the given (root_exports) order, unsure ones included.
- `nis2_supervision_fines_missing_in_order(Profile, Keys, Missing)`: the absent keys of Keys in root_exports order, built on `missing_keys/3`.

## Slice: nis2_supervision_fines.clausal

### Statutory VALUE facts (owned here, nowhere else)

```
:- constant_value(essential_fixed_maximum_floor_eur, 10000000).      % Art 34(4)
:- constant_value(essential_turnover_percentage_numerator, 2).        % Art 34(4): 2 %
:- constant_value(essential_turnover_percentage_denominator, 100).
:- constant_value(important_fixed_maximum_floor_eur, 7000000).       % Art 34(5)
:- constant_value(important_turnover_percentage_numerator, 14).       % Art 34(5): 1,4 %
:- constant_value(important_turnover_percentage_denominator, 1000).
```

Power tables are facts in article order, keyed by an ordinal so the list is built once by `findall` over the ordered facts. That gives one list and one solution.

- `essential_power(Ordinal, Kind, Measure, CitationKey)` has 1 to 16, the Art 32(2)(a) to (g) and Art 32(4)(a) to (i) rows of the LIMBS.
- `essential_escalation_power(Ordinal, Measure, CitationKey)` has 1 to 2: Art 32(5)(a) `suspend_certification_or_authorisation` and Art 32(5)(b) `request_temporary_management_ban`.
- `important_power(Ordinal, Kind, Measure, CitationKey)` has 1 to 14, the Art 33(2)(a) to (f) and Art 33(4)(a) to (h) rows of the LIMBS.

The measure atoms are exactly those of the LIMBS. Supervision measures are:

- `on_site_inspections_and_off_site_supervision`, `on_site_inspections_and_off_site_ex_post_supervision`;
- `regular_and_targeted_security_audits`, `targeted_security_audits`, `ad_hoc_audits`;
- `security_scans`, `information_requests`, `data_access_requests`, `implementation_evidence_requests`.

Enforcement measures are:

- `warnings`, `binding_instructions_or_remedy_orders`, `cease_and_desist_orders`, `compliance_orders`;
- `inform_affected_persons_orders`, `audit_recommendation_orders`, `monitoring_officer`, `publication_orders`;
- `administrative_fine`.

### Derived arithmetic

`nis2_supervision_fines_percentage_amount_eur(Class, TurnoverEur, PercentAmountEur)` computes the ceiling division `(TurnoverEur * Numerator + Denominator - 1) // Denominator`, with the class constants.

`nis2_supervision_fines_least_maximum(Class, TurnoverEur, AmountEur, Basis)` has two disjoint clauses:

- `Basis = fixed_amount` when `Fixed >= PercentAmount`, with `AmountEur = Fixed`;
- `Basis = turnover_percentage` when `Fixed < PercentAmount`, with `AmountEur = PercentAmount`.

The ground basis is folded into each head (C17).

### Rules (each a disjoint clause set; the first applicable step decides)

Every query has a step (0): `nis2_supervision_fines_input_problems(Profile, Problems)` with `Problems \= []`. It gives `input_problems(Problems)` with Citations `[]`, or no citations argument for the two-argument queries. Every later clause carries the guard `Problems = []`.

#### fine_ceiling_floor/3

1. `infringed_provision` absent: `indeterminate([infringed_provision])`, `[]`.
2. `other`: `no_union_minimum`, `[cite(eu_dir_2022_2555_art_34_4), cite(eu_dir_2022_2555_art_34_5)]`.
3. `art_21` or `art_23`, with `entity_class` or `worldwide_annual_turnover_eur` absent: `indeterminate(Missing)` in root order, `[]`.
4. Both present: `minimum_national_maximum(AmountEur, Basis)` from `least_maximum`. Citations are `[cite(eu_dir_2022_2555_art_34_4)]` for essential and `[cite(eu_dir_2022_2555_art_34_5)]` for important. `entity_is_public_administration` is not read (Q7).

#### minimum_powers/2

5. `entity_class` absent: `indeterminate([entity_class])`.
6. `important`: the 14 important rows.
7. `essential`:
   - `entity_is_public_administration` absent: `indeterminate([entity_is_public_administration])`;
   - `true`: the 16 rows;
   - `false`: the 16 rows followed by the 2 escalation rows.

#### escalation_powers_exercisable/3

8. `entity_class` absent: `indeterminate([entity_class])`, `[]`. `important`: `not_exercisable(important_entity)`, `[cite(eu_dir_2022_2555_art_32_5)]`.
9. `essential`. Each failing clause requires that every earlier condition is not failing, meaning its key is absent or has a non-failing value. The steps run in this order:
   - C1 key `true`: `not_exercisable(public_administration_entity)`.
   - C2 key `false`: `not_exercisable(measures_not_ineffective)`.
   - C3 key `false`: `not_exercisable(no_deadline_set)`.
   - C4 key `true`: `not_exercisable(action_taken_within_deadline)`.

   These four cite `[cite(eu_dir_2022_2555_art_32_5)]`.
   - Else, if any of keys 4, 5, 6 or 7 is absent: `indeterminate(Missing)`, `[]`.
   - Else, if C2 is `unsure`: `needs_legal_review(open_textured(earlier_measures_ineffective, cite(eu_dir_2022_2555_art_32_5)), [inputs_relied_on([earlier_measures_ineffective-unsure])])`, `[]`.
   - Else: `exercisable`, `[cite(eu_dir_2022_2555_art_32_5)]`.

#### fine_barred_by_gdpr_fine/3

The conditions use keys 8, 11 and 12 only. Key 9 is never read here.

10. `infringed_provision` absent: `indeterminate([infringed_provision])`, `[]`. `other`: `fine_not_barred`, `[cite(eu_dir_2022_2555_art_35_2)]`.
11. `art_21` or `art_23`:
    - any of keys 8, 11 or 12 PRESENT and `false`: `fine_not_barred`, `[cite(eu_dir_2022_2555_art_35_2)]`;
    - else any absent: `indeterminate(Missing)`, `[]`;
    - else key 8 is `unsure`: `needs_legal_review(open_textured(infringement_may_entail_notifiable_personal_data_breach, cite(eu_dir_2022_2555_art_35_1)), [inputs_relied_on(Pairs)])`, `[]`;
    - else key 12 is `unsure`: the same with `open_textured(gdpr_fine_for_same_conduct, cite(eu_dir_2022_2555_art_35_2))`, `[]`;
    - else: `fine_barred`, `[cite(eu_dir_2022_2555_art_35_2)]`.

    Pairs are the present values of keys 8 and 12, in that order.

#### data_protection_authority_information/2

12. `infringed_provision` absent: `indeterminate([infringed_provision])`. `other`: `[]`.
13. `art_21` or `art_23`:
    - key 8 or key 9 PRESENT and `false`: `[]`;
    - else either absent: `indeterminate(Missing)`, in root order 8 then 9;
    - else key 8 is `unsure`: `needs_legal_review(open_textured(infringement_may_entail_notifiable_personal_data_breach, cite(eu_dir_2022_2555_art_35_1)), [inputs_relied_on([infringement_may_entail_notifiable_personal_data_breach-unsure])])`. Key 10 is not yet needed, so it is not named.
14. Both `true`:
    - key 10 absent: `indeterminate([data_protection_authority_in_other_member_state])`;
    - `false`: `[inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1))]`;
    - `true`: that duty followed by `inform_supervisory_authority_in_own_member_state(cite(eu_dir_2022_2555_art_35_3))`.

An optional unscored `provenance(Clause, Citations)` may follow the Pairs inside `inputs_relied_on`. It is omitted in this order, to keep the answers canonical.

### Facade checklist requirements (the slice exports the requirement predicate)

The head is `nis2_supervision_fines_requirement(RequirementId, Profile, Status, Citation)`. It has three mutually exclusive clauses per requirement (met / unmet / unknown) and is run by `assess/6` with `labels(eligible, indeterminate, ineligible)`.

- `infringement_of_article_21_or_23`:
  - `art_21` or `art_23` is `met`; `other` is `unmet(infringement_outside_article_21_or_23)`; absent is `unknown([infringed_provision])`;
  - the cite is `cite(eu_dir_2022_2555_art_34_5)` when `entity_class` is `important`, else `cite(eu_dir_2022_2555_art_34_4)`; these clauses are disjoint on that guard.
- `entity_class_established`:
  - present is `met`; absent is `unknown([entity_class])`;
  - the cite is `cite(eu_dir_2022_2555_art_34_4)` for essential or absent and `cite(eu_dir_2022_2555_art_34_5)` for important.
- `fine_not_barred_by_gdpr_fine`:
  - it maps `fine_barred_by_gdpr_fine/3`: `fine_not_barred` is `met`; `fine_barred` is `unmet(fine_barred_by_gdpr_fine)`;
  - `indeterminate(Keys)` maps to `unknown(Keys)`;
  - `needs_legal_review(open_textured(Key, Cite), Context)` maps to `unknown([Key])`;
  - the cite is always `cite(eu_dir_2022_2555_art_35_2)`.

The status mapping in queries.clausal is one clause per disjoint route:

1. input problems give `input_problems(P)`;
2. else `has_unmet` gives `ineligible`;
3. else, if any absent key is in the checklist's unknown items, the answer is `indeterminate(Missing)`. Missing names the absent keys over keys 1, 2, 8, 11 and 12, in root order, as the queries name them;
4. else, if the GDPR query gives `needs_legal_review(R, C)`, the answer is that same compound;
5. else `eligible`.

Open-textured judgements are always handed to the user, never crisped.

### Verdict atoms of this slice

The slice uses:

- `minimum_national_maximum/2`, `no_union_minimum`;
- `power/3`;
- `exercisable`, `not_exercisable/1` with reasons `important_entity`, `public_administration_entity`, `measures_not_ineffective`, `no_deadline_set` and `action_taken_within_deadline`;
- `fine_barred`, `fine_not_barred`;
- `inform_gdpr_supervisory_authorities/1`, `inform_supervisory_authority_in_own_member_state/1`;
- the status compounds `indeterminate/1`, `needs_legal_review/2` and `input_problems/1`;
- the facade atoms `eligible` and `ineligible`.

### Shared with other files (kernel only)

The slice uses three kernel predicates:

- `nis2_supervision_fines_input_problems/2`;
- `nis2_supervision_fines_pairs/3`;
- `nis2_supervision_fines_missing_in_order/3`.

Nothing else crosses the slice boundary. The slice reads its citation atoms from `citations.clausal`'s vocabulary only.
