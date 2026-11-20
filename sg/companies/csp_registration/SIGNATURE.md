# SIGNATURE — sg/companies/csp_registration

## Public query surface

`csp_assessment(PROFILE, RESULT)` — the called contract. PROFILE is the profile term; RESULT is `csp(DECISION, SERVICE_TYPES, MISSING, NOMINEE_DUTY, CITATIONS)`. Exactly one solution per profile. s 2(1), s 7(1), s 7(2), s 16(1), s 16(2).

`decide_csp_registration(PROFILE, RESULT)` — the primary entry point. PROFILE is the profile term; RESULT is `csp(DECISION, SERVICE_TYPES, MISSING, NOMINEE_DUTY, CITATIONS)`. Exactly one solution per profile.

`csp_registration_status(PROFILE, STATUS)` — returns the DECISION atom alone (the status_determination query type).

`csp_registration_checklist(PROFILE, CHECKLIST)` — returns the cited checklist (the eligibility query type): a list of `item(Id, Status, Citation)` terms.

`csp_registration_what_if(PROFILE, KEY, VALUE, RESULT)` — counterfactual: override one profile key and re-decide.

`fixtures` — the test fixture generator for this domain.

## Verdict STATUS atoms

- `no_corporate_service`
- `not_carrying_on_business_in_singapore`
- `registered`
- `registration_required`
- `indeterminate`

## Profile keys

| Key | Type | Required? | Default | Notes |
|-----|------|-----------|---------|-------|
| `activities` | list of activity atoms | YES | — | Atoms: `forms_legal_person_for_another`, `acts_as_director_or_secretary`, `arranges_director_or_secretary`, `acts_as_partner`, `arranges_partner`, `acts_in_similar_capacity_for_legal_person`, `provides_registered_office_or_address`, `nominee_shareholder_for_unlisted_corporation`, `nominee_shareholder_for_listed_corporation`, `designated_activity_with_accounting_service`, `acra_transaction_for_another`, `acra_transaction_as_secretary_of_companies`. Unknown atoms ignored. |
| `carries_on_business_in_singapore` | `true` \| `false` | YES | — | |
| `registered_service_types` | list of type atoms | YES | — | Atoms: `formation`, `director_secretary`, `address`, `nominee_shareholder`, `designated_accounting`, `acra_transaction`. Only active (non-suspended) registrations. |
| `is_accounting_entity` | `true` \| `false` | NO | `false` | s 7(2) deemed registration. |
| `accounting_service_is_own` | `true` \| `false` | NO | `true` | Deemed registration only for own services. |
| `deemed_registration_suspended_or_cancelled` | `true` \| `false` | NO | `false` | Defeats s 7(2) deemed registration. |
| `arranges_nominee_director` | `true` \| `false` | NO | `false` | Triggers s 16 duty; adds `director_secretary` to engaged types. |
| `satisfied_nominee_fit_and_proper` | `true` \| `false` | NO | `false` | s 16(1). |
| `took_reasonable_steps_on_disqualification` | `true` \| `false` | NO | `false` | s 16(2)(a). |
| `considered_prescribed_factors` | `true` \| `false` | NO | `false` | s 16(2)(b). |

## Citation-key atoms

- `sg_cspa_2024_s2_1_corporate_service`
- `sg_cspa_2024_s7_1`
- `sg_cspa_2024_s7_2`
- `sg_cspa_2024_s16_1`
- `sg_cspa_2024_s16_2`

## Public predicates

```
csp_assessment(PROFILE, RESULT): primary assessment — csp(Decision, ServiceTypes, Missing, NomineeDuty, Citations). s 2(1), s 7(1), s 7(2), s 16(1), s 16(2).
decide_csp_registration(PROFILE, RESULT): primary verdict — csp(Decision, ServiceTypes, Missing, NomineeDuty, Citations). s 2(1), s 7(1), s 7(2), s 16(1), s 16(2).
csp_registration_status(PROFILE, STATUS): status_determination — returns the Decision atom. s 7(1).
csp_registration_checklist(PROFILE, CHECKLIST): eligibility — cited checklist of item(Id, Status, Citation). s 2(1), s 7(1), s 7(2), s 16(1), s 16(2).
csp_registration_what_if(PROFILE, KEY, VALUE, RESULT): counterfactual override of one key, re-decide. s 7(1).
fixtures: test fixture generator for this domain.
```

## Planned reuse (kit / MODULES.yaml)

- `formalize_lib`: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `missing_keys/3`, `all_present/2`, `check_true/4`, `check_false/4`, `check_holds/5`, `memberd/2`, `not_member/2`, `first_applicable/2`, `or_status/2`, `and_status/2`, `collect_unknown/2`, `item/3`, `unmet/1`, `unknown/1`, `value/1`, `absent/1`, `labels/3`, `assessment/3`, `decide_labeled/3`, `summarize/3`, `classify_labeled/4`, `has_unmet/1`, `has_unknown/1`, `eval_requirements/4`, `assess/6`
- `validate_props`: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`
- `kit.query_combinators`: `what_if/5`, `what_if2/6`, `what_if_deltas/5`, `override_key/4`, `diff_checklists/3`, `changed_deltas/2`

No `currency_vocab`, `vat_category`, `kit.compliance_lib`, `kit.deadline_lib`, `kit.rolling_window`, `date_time`, `list_item`, or `country` modules are needed.

---

## Determination slice: csp_registration.clausal

### Statutory value facts owned by this slice

- **Service-type vocabulary** (six atoms, in limb order): `formation`, `director_secretary`, `address`, `nominee_shareholder`, `designated_accounting`, `acra_transaction`.
- **Activity-to-type mapping** (activity atom → type atom):
  - `forms_legal_person_for_another` → `formation`
  - `acts_as_director_or_secretary`, `arranges_director_or_secretary`, `acts_as_partner`, `arranges_partner`, `acts_in_similar_capacity_for_legal_person` → `director_secretary`
  - `provides_registered_office_or_address` → `address`
  - `nominee_shareholder_for_unlisted_corporation` → `nominee_shareholder`
  - `nominee_shareholder_for_listed_corporation` → (no mapping; excluded from s 2(1)(d))
  - `designated_activity_with_accounting_service` → `designated_accounting`
  - `acra_transaction_for_another`, `acra_transaction_as_secretary_of_companies` → `acra_transaction`
- **Limb order** (fixed): `[formation, director_secretary, address, nominee_shareholder, designated_accounting, acra_transaction]`.
- **Required profile keys**: `activities`, `carries_on_business_in_singapore`, `registered_service_types`.
- **Optional profile keys** (default `false` unless noted): `is_accounting_entity` (default `false`), `accounting_service_is_own` (default `true`), `deemed_registration_suspended_or_cancelled` (default `false`), `arranges_nominee_director` (default `false`), `satisfied_nominee_fit_and_proper` (default `false`), `took_reasonable_steps_on_disqualification` (default `false`), `considered_prescribed_factors` (default `false`).

### Rules / requirements (first match wins)

| Rule | Condition | Outcome |
|------|-----------|---------|
| 0 | Any required key absent | `indeterminate`, `[]`, `[]`, `n_a`, `[]` |
| 1 | No engaged type (after mapping + nominee-director addition) | `no_corporate_service`, `[]`, `[]`, `not_applicable`, `[sg_cspa_2024_s2_1_corporate_service]` |
| 2 | `carries_on_business_in_singapore` is `false` | `not_carrying_on_business_in_singapore`, `SERVICE_TYPES`, `[]`, `not_applicable`, `[sg_cspa_2024_s7_1]` |
| 3 | Coverage: each engaged type is covered iff in `registered_service_types` OR (`designated_accounting` AND `is_accounting_entity` AND `accounting_service_is_own` AND NOT `deemed_registration_suspended_or_cancelled`). `MISSING` = uncovered engaged types. Citations: `[sg_cspa_2024_s7_1]` + `sg_cspa_2024_s7_2` iff `designated_accounting` was covered by deeming (not actual registration). | — |
| 4 | Nominee duty: applies iff `arranges_nominee_director` AND `director_secretary` engaged AND `director_secretary` NOT in `MISSING`. When applies: `complied` iff all three s 16 booleans true, else `breached`. Citations gain `sg_cspa_2024_s16_1`, `sg_cspa_2024_s16_2`. Otherwise `not_applicable`. | — |
| 5 | Decision: `registration_required` if `MISSING` non-empty, else `registered`. | — |

### Verdict atoms

`no_corporate_service`, `not_carrying_on_business_in_singapore`, `registered`, `registration_required`, `indeterminate`

### Nominee-duty atoms

`complied`, `breached`, `not_applicable`, `n_a` (only when indeterminate)

### Predicates shared with other slices

None. This is a single-slice domain; all logic lives in `csp_registration.clausal`. The kernel (`kernel.clausal`) provides only the module declaration and the `csp/5` compound term definition.

### Per-rule tests (planned)

- Rule 0: missing `activities` → indeterminate; missing `carries_on_business_in_singapore` → indeterminate; missing `registered_service_types` → indeterminate.
- Rule 1: empty activities list → no_corporate_service.
- Rule 2: activities present but `carries_on_business_in_singapore` false → not_carrying_on_business_in_singapore.
- Rule 3: all engaged types in `registered_service_types` → registered; one missing → registration_required; `designated_accounting` covered by deeming → registered with s 7(2) citation.
- Rule 4: `arranges_nominee_director` true, `director_secretary` registered, all three booleans true → complied; one false → breached; `director_secretary` in MISSING → not_applicable.
- Rule 5: covered by deeming only → registered; partially covered → registration_required.
