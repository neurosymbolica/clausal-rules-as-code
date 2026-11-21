# SIGNATURE — eu/nis2_supervision_fines

This is the authoring plan for the later phases. The layout is:

`kernel -> citations -> parameters -> nis2_supervision_fines -> queries -> fixtures -> package facade`

The one determination slice is `nis2_supervision_fines.clausal`, and it is self-contained. It owns:

- its statutory VALUE facts;
- its arithmetic;
- the five contracted queries;
- its checklist requirements, verdict and per-rule tests.

`kernel.clausal` holds only what the slice and the `queries` / facade layers must share. `parameters.clausal` declares NO domain figure: every figure lives in the slice. `parameters.clausal` keeps only its scaffold module header and exports nothing new.

## Public query surface (summary)

The five contracted queries:

- `fine_ceiling_floor/3`
- `minimum_powers/2`
- `escalation_powers_exercisable/3`
- `fine_barred_by_gdpr_fine/3`
- `data_protection_authority_information/2`

The input check is `nis2_supervision_fines_input_problems/2`.

The facade predicates:

- `decide_nis2_supervision_fines(PROFILE, nis2_supervision_fines_verdict(STATUS, CITATIONS))`
- `nis2_supervision_fines_status(PROFILE, STATUS)`
- `nis2_supervision_fines_checklist(PROFILE, CHECKLIST)`
- `nis2_supervision_fines_what_if(PROFILE, KEY, VALUE, VERDICT)`

**Totality.** Every public predicate yields EXACTLY ONE solution for every ground PROFILE, the ill-formed profiles included. No public predicate is a bare atom beside a same-name compound: `indeterminate` is never written at arity 0. No figure is imported from another domain; all figures are declared in the slice with `:- constant_value(...)`.

## Verdict STATUS atoms (replacing the scaffold placeholder)

STATUS is one of these, for query types #2 and #7:

- `eligible`: a NIS2 Art 34 fine is open, with a Union minimum national ceiling. The infringement is of Art 21 or 23, the entity class and turnover are known, and the fine is not barred by a GDPR fine under Art 35(2).
- `ineligible`: some checklist item is unmet. Either there is no Union minimum (another provision was infringed), or the fine is barred by a GDPR fine.
- `indeterminate`: no item is unmet and some item is unknown. The unknown is either a needed key that is absent, or an open-textured judgement given as `unsure`. That judgement is handed to the user or lawyer through the matching contracted query's `needs_legal_review`; there is no crisp test.
- `invalid_profile`: the input check found problems.

The labels passed to the checklist engine are `labels(eligible, indeterminate, ineligible)`. `invalid_profile` is a separate head-folded clause guarded by a non-empty PROBLEMS list.

Contracted result atoms and constructors (exact):

- `minimum_national_maximum/2`, `fixed_amount`, `turnover_percentage`, `no_union_minimum`
- `power/3`, with KIND `supervision`, `enforcement` or `escalation`
- `exercisable`, `not_exercisable/1`, with REASON `important_entity`, `public_administration_entity`, `measures_not_ineffective`, `no_deadline_set` or `action_taken_within_deadline`
- `fine_barred`, `fine_not_barred`
- `inform_gdpr_supervisory_authorities/1`, `inform_supervisory_authority_in_own_member_state/1`
- `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`
- `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`

## Profile keys (attribute list `[attribute(KEY, VALUE), ...]`, read only with profile_get/3)

The twelve keys, in root_exports and input_contract order. The key names are fixed by the contract; the money key is unit-suffixed, and there are no dates.

| # | Key | Kind | Values |
|---|-----|------|--------|
| 1 | `entity_class` | enumeration | `essential`, `important` |
| 2 | `infringed_provision` | enumeration | `art_21`, `art_23`, `other` |
| 3 | `worldwide_annual_turnover_eur` | non-negative integer | whole euros |
| 4 | `entity_is_public_administration` | crisp | `true`, `false` |
| 5 | `earlier_measures_ineffective` | judgement | `true`, `false`, `unsure` |
| 6 | `deadline_set_for_necessary_action` | crisp | `true`, `false` |
| 7 | `required_action_taken_within_deadline` | crisp | `true`, `false` |
| 8 | `infringement_may_entail_notifiable_personal_data_breach` | judgement | `true`, `false`, `unsure` |
| 9 | `authority_became_aware_in_supervision_or_enforcement` | crisp | `true`, `false` |
| 10 | `data_protection_authority_in_other_member_state` | crisp | `true`, `false` |
| 11 | `gdpr_fine_imposed_under_art_58_2_i` | crisp | `true`, `false` |
| 12 | `gdpr_fine_for_same_conduct` | judgement | `true`, `false`, `unsure` |

The turnover is in whole euros, as the contract fixes, not in cents. It is the preceding financial year's turnover of the undertaking to which the entity belongs.

## Citation-key atoms (citations.clausal, `citation_vocabulary/1` facts; canonical lexicon scheme)

- Art 32(2): `eu_dir_2022_2555_art_32_2_a`, `eu_dir_2022_2555_art_32_2_b`, `eu_dir_2022_2555_art_32_2_c`, `eu_dir_2022_2555_art_32_2_d`, `eu_dir_2022_2555_art_32_2_e`, `eu_dir_2022_2555_art_32_2_f`, `eu_dir_2022_2555_art_32_2_g`
- Art 32(4): `eu_dir_2022_2555_art_32_4_a`, `eu_dir_2022_2555_art_32_4_b`, `eu_dir_2022_2555_art_32_4_c`, `eu_dir_2022_2555_art_32_4_d`, `eu_dir_2022_2555_art_32_4_e`, `eu_dir_2022_2555_art_32_4_f`, `eu_dir_2022_2555_art_32_4_g`, `eu_dir_2022_2555_art_32_4_h`, `eu_dir_2022_2555_art_32_4_i`
- Art 32(5): `eu_dir_2022_2555_art_32_5`, `eu_dir_2022_2555_art_32_5_a`, `eu_dir_2022_2555_art_32_5_b`
- Art 33(2): `eu_dir_2022_2555_art_33_2_a`, `eu_dir_2022_2555_art_33_2_b`, `eu_dir_2022_2555_art_33_2_c`, `eu_dir_2022_2555_art_33_2_d`, `eu_dir_2022_2555_art_33_2_e`, `eu_dir_2022_2555_art_33_2_f`
- Art 33(4): `eu_dir_2022_2555_art_33_4_a`, `eu_dir_2022_2555_art_33_4_b`, `eu_dir_2022_2555_art_33_4_c`, `eu_dir_2022_2555_art_33_4_d`, `eu_dir_2022_2555_art_33_4_e`, `eu_dir_2022_2555_art_33_4_f`, `eu_dir_2022_2555_art_33_4_g`, `eu_dir_2022_2555_art_33_4_h`
- Art 34: `eu_dir_2022_2555_art_34_4`, `eu_dir_2022_2555_art_34_5`
- Art 35: `eu_dir_2022_2555_art_35_1`, `eu_dir_2022_2555_art_35_2`, `eu_dir_2022_2555_art_35_3`

No other citation atom is used, and none is shortened.

## Public predicates (one line each)

- `nis2_supervision_fines_input_problems(Profile, Problems)`: THE INPUT CHECK. Gives the bare list of problems:
  - `duplicate_key/1`, else `wrong_type/1`, per contract key in contract order;
  - then `unknown_key/1` in order of first occurrence;
  - `[wrong_type(profile)]` for a non-attribute-list.
  Citation: input_contract.
- `fine_ceiling_floor(Profile, Ceiling, Citations)`: the least national maximum fine (limbs (0) to (4)). Citation: `eu_dir_2022_2555_art_34_4` (essential) or `eu_dir_2022_2555_art_34_5` (important); both for `no_union_minimum`.
- `minimum_powers(Profile, Powers)`: the ordered list of `power(Kind, Measure, cite(Key))`, or one status compound (limbs (0), (5) to (7)). Citations: Art 32(2)(a) to (g), 32(4)(a) to (i), 32(5)(a) and (b); Art 33(2)(a) to (f), 33(4)(a) to (h).
- `escalation_powers_exercisable(Profile, Result, Citations)`: `exercisable`, `not_exercisable(Reason)` or a status compound (limbs (0), (8), (9)). Citation: `eu_dir_2022_2555_art_32_5`.
- `fine_barred_by_gdpr_fine(Profile, Result, Citations)`: `fine_barred`, `fine_not_barred` or a status compound (limbs (0), (10), (10a), (10b), (11)). Citations: `eu_dir_2022_2555_art_35_2`, with `eu_dir_2022_2555_art_35_1` in a referral.
- `data_protection_authority_information(Profile, Duty)`: the ordered duty list or a status compound (limbs (0), (12), (12a), (12b), (13), (14)). Citations: `eu_dir_2022_2555_art_35_1`, `eu_dir_2022_2555_art_35_3`.
- `decide_nis2_supervision_fines(Profile, Verdict)`: `nis2_supervision_fines_verdict(Status, Citations)`. Status is from the STATUS atoms above; Citations is the set of item citations, or `[]` for `invalid_profile`. Citations: Art 34(4) or (5), Art 35(2).
- `nis2_supervision_fines_status(Profile, Status)`: the Status of `decide_nis2_supervision_fines/2`. Same citations.
- `nis2_supervision_fines_checklist(Profile, Checklist)`: a list of `item(RequirementId, Status, cite(Key))` in requirement order, or `[]` for an invalid profile. Every item cites, met items included.
- `nis2_supervision_fines_what_if(Profile, Key, Value, Verdict)`: replaces or adds `attribute(Key, Value)` with `profile_set/3`, then gives `decide_nis2_supervision_fines/2` on the edited profile. It yields one solution. Same citations as the verdict.
- Fixtures (fixtures.clausal): `nis2_supervision_fines_fixture(Name, Profile)` facts for the named cases in the slice test plan, and `nis2_supervision_fines_fixture_names(Names)`.

## Planned reuse (manifest `uses:`)

- **formalize_lib** — the predicates used, and what each is for:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`: every key read, presence first, then value.
  - `profile_set/3`: what_if.
  - `eval_requirements/4`, `decide_labeled/3`: the facade checklist and its verdict. The domain `nis2_supervision_fines_requirement/4` is injected as a closure, RequirementId first.
  - `labels/3`, `item/3`, `unmet/1`, `unknown/1`, `attribute/2`: constructors.
  - `memberd/2`, `not_member/2`: the input check (contract membership, first-occurrence detection).
  - `int_max/3`: the higher of FIXED and PERCENT_AMOUNT.
- **validate_props** (tests only): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- **Not used.** These do not apply to this order:
  - `kit/compliance_lib`: the deontic modality is fixed by the text, with no norm conflict to resolve.
  - `kit/deadline_lib`, `date_time`: there are no dates; the Art 32(5) deadline is a crisp input.
  - `kit/query_combinators`: what_if is over an attribute list via profile_set/3.
  - `country`, `currency_vocab`: the amounts are always EUR, and the currency is not carried as a value.
- **Local helper** (no kit module; recorded in NOTES.md S3): `nis2_supervision_fines_ceiling_division/3`.

## kernel.clausal (shared floor — only what slice AND queries/facade both need)

- `nis2_supervision_fines_contract_key(Position, Key, Type)`: twelve facts, Position 1 to 12, in the table order above. Type is one of:
  - `judgement`
  - `crisp`
  - `enumeration([Atom, ...])`
  - `non_negative_integer`
- `nis2_supervision_fines_input_problems(Profile, Problems)`: THE INPUT CHECK as specified. It is shared because the slice uses it as limb (0) and the facade uses it for `invalid_profile`. Details:
  - Attribute-list test first. Any non-list, or any element not `attribute(_, _)`, gives `[wrong_type(profile)]`.
  - Then, per contract key in position order: the count of occurrences above 1 gives `duplicate_key(Key)`, with no value read. Else a single present value outside its type gives `wrong_type(Key)`. An absent key gives no problem.
  - Then `unknown_key(Key)` per non-contract key at its first occurrence.
  - Each clause is disjoint, with no cut.
- `nis2_supervision_fines_relied_pairs(Profile, JudgementKeys, Pairs)`: THE PAIRS RULE. It gives the `Key-Value` pairs of the listed judgement keys that are present, in the order given, which callers pass in root_exports order.

## parameters.clausal

It declares no domain value; all statutory figures are owned by the slice. It keeps its scaffold module header only.

## SLICE: nis2_supervision_fines.clausal

### Statutory VALUE facts owned here (`:- constant_value(Name, Value).`, read with `constant(Name)`)

- `essential_entity_fixed_floor_eur` = 10000000 (Art 34(4))
- `essential_entity_turnover_share_numerator` = 2 (Art 34(4))
- `essential_entity_turnover_share_denominator` = 100 (Art 34(4))
- `important_entity_fixed_floor_eur` = 7000000 (Art 34(5))
- `important_entity_turnover_share_numerator` = 14 (Art 34(5))
- `important_entity_turnover_share_denominator` = 1000 (Art 34(5))

The power tables are ordered facts in this file:

- `nis2_supervision_fines_power_row(EntityClass, Position, Kind, Measure, CitationKey)`, with these rows:
  - `important`: 14 rows (Art 33(2)(a) to (f), then 33(4)(a) to (h)).
  - `essential`: 16 base rows (Art 32(2)(a) to (g), then 32(4)(a) to (i)).
  - `essential_escalation`: 2 rows (Art 32(5)(a) and (b)).
- The measure atoms are exactly those of THE LIMBS steps (6) and (7):
  - `on_site_inspections_and_off_site_ex_post_supervision`
  - `on_site_inspections_and_off_site_supervision`
  - `targeted_security_audits`
  - `regular_and_targeted_security_audits`
  - `ad_hoc_audits`
  - `security_scans`
  - `information_requests`
  - `data_access_requests`
  - `implementation_evidence_requests`
  - `warnings`
  - `binding_instructions_or_remedy_orders`
  - `cease_and_desist_orders`
  - `compliance_orders`
  - `inform_affected_persons_orders`
  - `audit_recommendation_orders`
  - `monitoring_officer`
  - `publication_orders`
  - `administrative_fine`
  - `suspend_certification_or_authorisation`
  - `request_temporary_management_ban`
- The list is built with one `findall/3` over the ordered rows, then `msort` on Position. It is returned as ONE list, so the query has a single solution.

### Derived arithmetic

- `nis2_supervision_fines_ceiling_division(Dividend, Divisor, Quotient)`: `Quotient is (Dividend + Divisor - 1) // Divisor`. It needs non-negative integers, all bound.
- `nis2_supervision_fines_least_maximum(EntityClass, TurnoverEur, AmountEur, Basis)`:
  - PERCENT_AMOUNT = ceiling_division(TurnoverEur * Numerator, Denominator).
  - AmountEur = int_max(FIXED, PERCENT_AMOUNT).
  - Two disjoint clauses fold Basis into the head: `fixed_amount` when FIXED >= PERCENT_AMOUNT, and `turnover_percentage` when FIXED < PERCENT_AMOUNT.

### Rules / requirements (the limbs; each a set of disjoint head-folded clauses, no cut, no if-then-else)

**Limb (0), for every query.** When `nis2_supervision_fines_input_problems(Profile, Problems)` gives Problems different from `[]`, the answer is `input_problems(Problems)`, with Citations `[]` for the arity-3 queries. Every other clause is guarded by Problems = `[]`.

**`fine_ceiling_floor/3`**

- (1) `infringed_provision` absent gives `indeterminate([infringed_provision])`, `[]`.
- (2) `other` gives `no_union_minimum`, `[cite(eu_dir_2022_2555_art_34_4), cite(eu_dir_2022_2555_art_34_5)]`.
- (3) For `art_21` or `art_23`:
  - `entity_class` absent gives `indeterminate([entity_class])`;
  - else the turnover absent gives `indeterminate([worldwide_annual_turnover_eur])`.
- (4) `minimum_national_maximum(AmountEur, Basis)`, `[cite(art_34_4)]` for essential or `[cite(art_34_5)]` for important.

**`minimum_powers/2`**

- (5) `entity_class` absent gives `indeterminate([entity_class])`.
- (6) `important` gives the 14 rows.
- (7) `essential`:
  - public administration absent gives `indeterminate([entity_is_public_administration])`;
  - `true` gives the 16 rows;
  - `false` gives the 16 rows followed by the 2 escalation rows.

**`escalation_powers_exercisable/3`**

- (8) `important` gives `not_exercisable(important_entity)`, `[cite(eu_dir_2022_2555_art_32_5)]`.
- (9) Class essential or absent. A failing condition is any of:
  - C1 `entity_is_public_administration` = `true`;
  - C2 `earlier_measures_ineffective` = `false`;
  - C3 `deadline_set_for_necessary_action` = `false`;
  - C4 `required_action_taken_within_deadline` = `true`.

  The clauses for (9), in order:
  - **First failing condition decides.** For each Cn there is a clause: Cn fails, and every earlier Ci is not failing (absent, unsure, or passing). That clause gives `not_exercisable(Reason)`, `[cite(eu_dir_2022_2555_art_32_5)]`. The reasons are `public_administration_entity`, `measures_not_ineffective`, `no_deadline_set` and `action_taken_within_deadline`. No condition is read for its absence of failure through the class.
  - **Class absent.** No condition fails and the class is absent: `indeterminate([entity_class])`, `[]`.
  - **Condition absent.** No condition fails, the class is essential, and some condition is absent: `indeterminate([FirstAbsent])`, in root_exports order 4, 5, 6, 7.
  - **Referral.** All four are present, none fails, and C2 = `unsure`: `needs_legal_review(open_textured(earlier_measures_ineffective, cite(eu_dir_2022_2555_art_32_5)), [inputs_relied_on([earlier_measures_ineffective-unsure])])`, `[]`.
  - **Otherwise** `exercisable`, `[cite(eu_dir_2022_2555_art_32_5)]`.

**`fine_barred_by_gdpr_fine/3`**

- (10) Any of these keys `false` gives `fine_not_barred`, `[cite(eu_dir_2022_2555_art_35_2)]`. The rule is ONE clause guarded by "some condition false", so a profile with two false conditions still yields ONE solution. Use the first false condition in root order as the witness, with the earlier ones not false. The keys are:
  - D2 `infringement_may_entail_notifiable_personal_data_breach`
  - D1 `gdpr_fine_imposed_under_art_58_2_i`
  - D3 `gdpr_fine_for_same_conduct`
- (10a) No condition false and the provision is `other`: `fine_not_barred`, `[cite(art_35_2)]`.
- (10b) No condition false and the provision is absent: `indeterminate([infringed_provision])`, `[]`.
- (11) `art_21` or `art_23`, in order:
  - the first absent of D2, D1, D3 (positions 8, 11, 12) gives `indeterminate([Key])`, `[]`;
  - else D2 `unsure` gives a referral citing `eu_dir_2022_2555_art_35_1`;
  - else D3 `unsure` gives a referral citing `eu_dir_2022_2555_art_35_2`;
  - the referral PAIRS are the present values of D2 then D3, and its Citations are `[]`;
  - else `fine_barred`, `[cite(eu_dir_2022_2555_art_35_2)]`.

**`data_protection_authority_information/2`**

- (12) Either E2 (key 8) or E1 (key 9) `false` gives `[]` (one clause, as for (10)).
- (12a) The provision is `other`: `[]`.
- (12b) The provision is absent: `indeterminate([infringed_provision])`.
- (13) `art_21` or `art_23`, in order:
  - E2 absent gives `indeterminate([infringement_may_entail_notifiable_personal_data_breach])`;
  - else E1 absent gives `indeterminate([authority_became_aware_in_supervision_or_enforcement])`;
  - else E2 `unsure` and E1 `true`:
    - key 10 absent gives `indeterminate([data_protection_authority_in_other_member_state])`;
    - key 10 present gives `needs_legal_review(open_textured(infringement_may_entail_notifiable_personal_data_breach, cite(eu_dir_2022_2555_art_35_1)), [inputs_relied_on([infringement_may_entail_notifiable_personal_data_breach-unsure])])`.
- (14) Both conditions `true`:
  - key 10 absent gives `indeterminate([data_protection_authority_in_other_member_state])`;
  - `false` gives `[inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1))]`;
  - `true` gives `[inform_gdpr_supervisory_authorities(cite(eu_dir_2022_2555_art_35_1)), inform_supervisory_authority_in_own_member_state(cite(eu_dir_2022_2555_art_35_3))]`.

### Checklist requirements (`nis2_supervision_fines_requirement(RequirementId, Profile, Status, Citation)`, injected into eval_requirements/4)

Each requirement has three mutually exclusive clauses: met, unmet or unknown.

- **`union_fine_floor_applies`**, read from `fine_ceiling_floor/3`.
  - `minimum_national_maximum(_, _)` is `met`.
  - `no_union_minimum` is `unmet(no_union_minimum)`.
  - `indeterminate([Key])` is `unknown([Key])`.
  - Citation: `cite(eu_dir_2022_2555_art_34_5)` when `entity_class` is `important`, else `cite(eu_dir_2022_2555_art_34_4)`.
- **`fine_not_barred_by_gdpr_fine`**, read from `fine_barred_by_gdpr_fine/3`.
  - `fine_not_barred` is `met`.
  - `fine_barred` is `unmet(fine_barred_by_gdpr_fine)`.
  - `indeterminate([Key])` is `unknown([Key])`.
  - `needs_legal_review(open_textured(Key, _), _)` is `unknown([Key])`: the judgement is handed to the user, with no crisp test.
  - Citation: `cite(eu_dir_2022_2555_art_35_2)`.

Requirement order: `[union_fine_floor_applies, fine_not_barred_by_gdpr_fine]`.

### Verdict atoms

- `eligible`, `ineligible`, `indeterminate`: from `decide_labeled/3` with `labels(eligible, indeterminate, ineligible)`. Any unmet item gives ineligible, else any unknown item gives indeterminate, else eligible.
- `invalid_profile`: from the input check. The checklist is then `[]` and the citations `[]`.

### Predicates this slice SHARES (and therefore lives in kernel.clausal)

- `nis2_supervision_fines_input_problems/2`
- `nis2_supervision_fines_contract_key/3`
- `nis2_supervision_fines_relied_pairs/3`

Nothing else is shared. The value facts, power tables, arithmetic, limbs, requirements and verdict are all local to this slice.

### Per-rule test plan (tests/; seven modes; expected answers)

**Fine floors**

| Profile | Expected `fine_ceiling_floor` answer |
|---|---|
| essential, art_21, turnover 600000000 | `minimum_national_maximum(12000000, turnover_percentage)`, `[cite(eu_dir_2022_2555_art_34_4)]` |
| essential, art_23, turnover 500000000 (tie) | `minimum_national_maximum(10000000, fixed_amount)` |
| essential, turnover 500000001 | `minimum_national_maximum(10000001, turnover_percentage)` (rounded up) |
| essential, turnover 0 | `minimum_national_maximum(10000000, fixed_amount)` |
| important, art_21, turnover 500000000 (tie) | `minimum_national_maximum(7000000, fixed_amount)`, `[cite(eu_dir_2022_2555_art_34_5)]` |
| important, turnover 500000001 | `minimum_national_maximum(7000001, turnover_percentage)` |
| infringed_provision other | `no_union_minimum`, both Art 34 cites |
| provision absent | `indeterminate([infringed_provision])` |
| art_21, class and turnover absent | `indeterminate([entity_class])` |
| art_21, essential, turnover absent | `indeterminate([worldwide_annual_turnover_eur])` |

**Minimum powers**

| Profile | Expected `minimum_powers` answer |
|---|---|
| important | 14 items in order |
| essential, public administration false | 18 items in order |
| essential, public administration true | 16 items, no escalation |
| essential, public administration absent | `indeterminate([entity_is_public_administration])` |
| class absent | `indeterminate([entity_class])` |

**Escalation**

| Profile | Expected `escalation_powers_exercisable` answer |
|---|---|
| important, whatever else | `not_exercisable(important_entity)` |
| class absent, public administration true | `not_exercisable(public_administration_entity)` |
| essential, public administration absent, earlier false | `not_exercisable(measures_not_ineffective)` |
| C1 absent, C3 false | `not_exercisable(no_deadline_set)` |
| class absent, C1 to C4 passing | `indeterminate([entity_class])` |
| essential, false/unsure/(deadline absent) | `indeterminate([deadline_set_for_necessary_action])` |
| essential, false/unsure/true/false | `needs_legal_review(open_textured(earlier_measures_ineffective, cite(eu_dir_2022_2555_art_32_5)), [inputs_relied_on([earlier_measures_ineffective-unsure])])`, `[]` |
| essential, false/true/true/false | `exercisable` |

**GDPR bar**

| Profile | Expected `fine_barred_by_gdpr_fine` answer |
|---|---|
| D1 false, provision absent | `fine_not_barred` |
| two conditions false | ONE solution `fine_not_barred` |
| no condition false, provision other | `fine_not_barred` |
| no condition false, provision absent | `indeterminate([infringed_provision])` |
| art_21, D2 absent, D3 unsure | `indeterminate([infringement_may_entail_notifiable_personal_data_breach])` |
| art_21, D2 unsure, D1 true, D3 unsure | review on D2, citing art_35_1, PAIRS `[infringement_may_entail_notifiable_personal_data_breach-unsure, gdpr_fine_for_same_conduct-unsure]` |
| art_21, D2 true, D1 true, D3 unsure | review on D3, citing art_35_2 |
| all true, art_23 | `fine_barred` |

**Duty to inform**

| Profile | Expected `data_protection_authority_information` answer |
|---|---|
| E1 false | `[]` |
| provision other, neither false | `[]` |
| provision absent | `indeterminate([infringed_provision])` |
| art_21, E2 unsure, E1 true, key 10 absent | `indeterminate([data_protection_authority_in_other_member_state])` |
| art_21, E2 unsure, E1 true, key 10 present | review on E2 |
| art_21, both true, key 10 false | one item |
| art_21, both true, key 10 true | two items in order |

**Input check**

| Profile | Expected `nis2_supervision_fines_input_problems` answer |
|---|---|
| well-formed | `[]` |
| entity_class twice | `[duplicate_key(entity_class)]`, never also wrong_type |
| crisp key `unsure` | `[wrong_type(Key)]` |
| turnover -1 or 1.5 | `[wrong_type(worldwide_annual_turnover_eur)]` |
| foo key twice | `[unknown_key(foo)]` |
| ordering | duplicate or wrong_type in contract order, then unknown_key in first-occurrence order |
| `not_a_list`, or a list with a bare atom | `[wrong_type(profile)]` |
| each query on a bad profile | `input_problems(Problems)`, with `[]` citations |

**Facade**

| Profile | Expected verdict |
|---|---|
| essential, art_21, turnover, D1 false | `eligible`, citations `{art_34_4, art_35_2}` |
| provision other | `ineligible` |
| all GDPR conditions true, art_21 | `ineligible` |
| D3 unsure | `indeterminate` |
| bad profile | `invalid_profile` |

what_if: setting `infringed_provision` to `other` flips eligible to ineligible.

**Properties**, via validate_props:

- totality and determinism: every query has exactly one solution over a generated grid of profiles, including absent and unsure values;
- citation completeness: every cite is in `citation_vocabulary`;
- missing-key coverage: each absent needed key is named singly;
- boundary coverage: the tie turnovers 500000000 for both classes.
