# SIGNATURE — eu/dora_payment_related_incidents

## 0. Public query surface (summary)

The order's three CONTRACT predicates are

- `payment_related_incident_status/3`
- `payment_related_incident_report_recipients/3`
- `dora_payment_related_incidents_input_problems/2`

They are defined in `queries.clausal`, over the slice `dora_payment_related_incidents.clausal` and the kernel. The scaffold facade names are kept and delegate to them:

- `decide_dora_payment_related_incidents(PROFILE, dora_payment_related_incidents_verdict(STATUS, CITATIONS))` wraps `payment_related_incident_status/3`.
- `dora_payment_related_incidents_status(PROFILE, STATUS)` projects STATUS.

**Totality.** Every call of every public predicate yields EXACTLY ONE solution for every term PROFILE. The input check never fails or raises.

**Determinism.** Step clauses are mutually exclusive by their guards. The code has no `!`, no `->` and no `*->`. Defeaters are guarded with `once/1`.

**No imported figures.** The order has no numeric parameter, so `parameters.clausal` carries no thresholds. It carries only the enumerations (see section 6).

## 1. Verdict STATUS atoms (replace the placeholder `{ required, permitted, not_applicable }`)

**`payment_related_incident_status`** returns one of the final answers or a status compound.

- Final answers:
  - `chapter_requirements_and_article_19_reporting_apply`
  - `chapter_requirements_apply`
  - `not_a_payment_related_incident`
  - `not_an_article_23_entity`
- Status compounds:
  - `indeterminate([Key])`
  - `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`
  - `input_problems(Problems)`

**`payment_related_incident_report_recipients`** returns one of the final answers or the same status compounds.

- Final answers:
  - `recipients(List)`, where `List` is a non-empty ordered list drawn from three recipient atoms:
    - `relevant_competent_authority`
    - `national_competent_authority_designated_under_directive_2013_36`
    - `directive_2022_2555_competent_authority_or_csirt`
  - `chapter_requirements_apply`
  - `not_a_payment_related_incident`
  - `not_an_article_23_entity`

**Problem terms:** `duplicate_key(Key)`, `wrong_type(Key)`, `unknown_key(Key)`, and `wrong_type(profile)`.

**Result constructors** (exported, never queried): `recipients/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

The bare atom `indeterminate` is NEVER written.

**Checklist decision labels** are for the #2 eligibility view only (`assess/6`): `labels(eligible, indeterminate, ineligible)`.

- `eligible` means Article 23 extends the chapter's requirements to the incident.
- `ineligible` means it does not.
- `indeterminate` means a requirement is unknown.

These labels never appear in STATUS.

## 2. Profile keys (attribute list, read only with `profile_get/3`; root_exports / input_contract order)

There are no numeric keys and no date keys.

| # | Key | Type | Values |
|---|---|---|---|
| 1 | `dora_entity_type` | `entity_type` (enumeration) | the 29 atoms listed below |
| 2 | `incident_is_operational_or_security_payment_related` | `judgement` | `true`, `false`, `unsure` |
| 3 | `payment_related_incident_is_major` | `judgement` | `true`, `false`, `unsure` |
| 4 | `credit_institution_classified_as_significant` | `fact` | `true`, `false` |
| 5 | `member_state_requires_reports_to_directive_2022_2555_authorities` | `fact` | `true`, `false` |

The 29 atoms of `dora_entity_type`, in this order:

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
29. `none_of_the_listed_types`

`true` and `false` are atoms. They are never Python booleans or strings, and they are never pinned in `verdict_vocabulary` or `root_exports`.

## 3. Citation-key atoms (canonical lexicon scheme; `citations.clausal`; never shortened)

| Citation key | Article | Used for |
|---|---|---|
| `eu_reg_2022_2554_art_23` | Art 23 | entities reached; extension of the chapter |
| `eu_reg_2022_2554_art_3_9` | Art 3, point (9) | operational or security payment-related incident |
| `eu_reg_2022_2554_art_3_11` | Art 3, point (11) | major |
| `eu_reg_2022_2554_art_18_3_a` | Art 18(3), point (a) | link of major incidents to Art 19(1) |
| `eu_reg_2022_2554_art_19_1` | Art 19(1) | reporting obligation and recipients |

The C6 risk on the segments `reg` / `art` is answered with the pragma `% lint: canonical-citation-key`. Renaming is not allowed.

## 4. Public predicates (one line each)

- `payment_related_incident_status(Profile, Status, Citations)`: steps (S0) to (S9) of THE LIMBS. It reads keys 1 to 3 only, and gives one solution — Art 23, Art 3(9), Art 3(11), Art 18(3)(a), Art 19(1).
- `payment_related_incident_report_recipients(Profile, Result, Citations)`: steps (R0) to (R11) of THE LIMBS. It reads all five keys and gives one solution — Art 19(1), first, third and sixth subparagraphs, with Art 23, Art 3(9), Art 3(11) and Art 18(3)(a).
- `dora_payment_related_incidents_input_problems(Profile, Problems)`: THE INPUT CHECK against the typed input_contract. It gives one solution, never fails and never raises — contract of this order (no article).
- `decide_dora_payment_related_incidents(Profile, dora_payment_related_incidents_verdict(Status, Citations))`: the facade over `payment_related_incident_status/3` — Art 23.
- `dora_payment_related_incidents_status(Profile, Status)`: the projection of the decide facade's Status — Art 23.
- `dora_payment_related_incidents_checklist(Profile, Checklist)`: the #2 eligibility and #7 justification view, built by `assess/6`.
  - It returns `assessment(Subject, Decision, Items)`, with `Decision` in `{eligible, indeterminate, ineligible}`.
  - Each item is `item(RequirementId, Status, cite(Key))`, with `Status` in `met`, `unmet(Reason)` or `unknown([Key])`. An unsure judgement gives `unknown([Key])`.
  - Every item carries its cite, including met items — Art 23, Art 3(9), Art 3(11), Art 19(1).
- `dora_payment_related_incidents_what_if(Profile, Key, Value, Status)`: replaces or adds `attribute(Key, Value)` with `profile_set/3`, then re-runs `payment_related_incident_status/3`. It gives one solution — same citations as the status query.
- `dora_payment_related_incidents_fixture(Name, Profile)` (in `fixtures.clausal`): the named test profiles of section 7.

## 5. Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`
  - `check_tri/4`, `check_eq/5`
  - `assess/6`, `item/3`, `unknown/1`, `unmet/1`, `labels/3`, `assessment/3`
  - `not_defeated/3`, `memberd/2`, `not_member/2`, `attribute/2`
  - The vocabulary atoms `met`, `applicable`, `inapplicable`.
- `validate_props` (tests only):
  - `run_props/1`, `prop_totality/3`, `prop_determinism/3`
  - `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`
- `kit/query_combinators` is not used. The what-if is a single re-run through `profile_set/3`, and its `what_if/5` expects a dictionary world.
- These modules are not used, because the order has no money, dates, deadlines, plans, norms lattice or windows: currency_vocab, vat_category, deadline_lib, compliance_lib, rolling_window, date_time, country.

## 6. Package layers

**`kernel.clausal`** (the shared floor; only what more than one layer needs):

- `dora_payment_related_incidents_contract_key(Position, Key, Type)`: five facts in root_exports order. Type is `entity_type`, `judgement` or `fact`.
- `dora_payment_related_incidents_value_has_type(Type, Value)`: membership test on ground atoms, via `memberd/2` over the enumeration lists from `parameters.clausal`. It is `false` for unbound values and for numbers.
- `dora_payment_related_incidents_profile_problems(Profile, Problems)`: THE INPUT CHECK, which the queries layer and the facade both need.
  - Attribute-list test: if the profile is a variable, a partial list, or holds an element that is not `attribute(_, _)`, the result is `[wrong_type(profile)]`.
  - Per contract key in order: `duplicate_key` if the key occurs more than once (compared with `==`), else `wrong_type` if its value fails its type.
  - Then unknown keys, de-duplicated by `==`, in first-occurrence order. A variable key is kept as that same variable.
- `dora_payment_related_incidents_relied_pairs(Profile, ReadKeys, Pairs)`: builds `Key-Value` pairs for the present read keys, in root_exports order.

**`parameters.clausal`**: no numeric values. It holds only `dora_payment_related_incidents_entity_types(List)` (the 29 atoms in order). The judgement and fact value lists live in the slice's own facts (section 7).

**`citations.clausal`**: the five citation keys of section 3, with their unit ids (`32022R2554#art_023`, `#point_003_9`, `#point_003_11`, `#point_018.003_a`, `#parag_019.001`) and the pinned verbatim text.

**`queries.clausal`**: the three contract predicates. Each first calls the kernel input check, then dispatches to the slice. Each query is wrapped so that exactly one solution comes out.

**`fixtures.clausal`**: the named profiles.

**Package facade**: the scaffold names of section 4.

## 7. Determination slice — `dora_payment_related_incidents.clausal`

### 7.1 Value facts it owns (in this file, not in a constants file)

- `article_23_reached_entity_type(Type)`: six facts.
  - `credit_institution`
  - `payment_institution`
  - `exempted_payment_institution`
  - `account_information_service_provider`
  - `electronic_money_institution`
  - `exempted_electronic_money_institution`
  - (Art 23 with Art 2(1)(a) to (d) and Art 3(35) to (39).)
- `judgement_value(Value)`: `true`, `false`, `unsure`.
- `fact_value(Value)`: `true`, `false`.
- `final_citations(Answer, Citations)`: the fixed citation list of each final answer.
  - `not_an_article_23_entity` gives `[cite(eu_reg_2022_2554_art_23)]`.
  - `not_a_payment_related_incident` gives `[cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9)]`.
  - `chapter_requirements_apply` gives `[cite(eu_reg_2022_2554_art_23), cite(eu_reg_2022_2554_art_3_9), cite(eu_reg_2022_2554_art_3_11)]`.
  - `chapter_requirements_and_article_19_reporting_apply` gives all five citation keys.
  - `recipients` gives all five citation keys.
- `referral_citation(Key, cite(CitationKey))`:
  - `incident_is_operational_or_security_payment_related` gives `cite(eu_reg_2022_2554_art_3_9)`.
  - `payment_related_incident_is_major` gives `cite(eu_reg_2022_2554_art_3_11)`.
- `status_read_keys([dora_entity_type, incident_is_operational_or_security_payment_related, payment_related_incident_is_major])`.
- `recipients_read_keys(...)`: all five keys.

There is no arithmetic and there are no thresholds. Major is the caller's judgement (reading (4)).

### 7.2 Rules / requirements

**Classification helpers.** The type is classified as `reached`, `not_reached` or `absent`; each judgement as `true`, `false`, `unsure` or `absent`. Each helper has exactly one clause per class and uses `profile_lacks/2` or `profile_get/3`. Classification reads presence first, then value. Profiles are already validated, so values are well-typed and each key appears at most once.

**Defeasible core** (guarded `once/1` defeaters, read through `not_defeated/3`):

- Default rule `chapter_requirements_extended`. Its defeaters are:
  - `defeater(chapter_requirements_extended, Profile) :- once(type_not_reached(Profile)).`
  - `defeater(chapter_requirements_extended, Profile) :- once(incident_not_payment_related(Profile)).`
- Default rule `report_to_relevant_competent_authority`. Its defeater is:
  - `defeater(report_to_relevant_competent_authority, Profile) :- once(significant_credit_institution(Profile)).`

**Status steps** (S0 is in `queries`). One clause per disjoint route, with the ground STATUS folded into the head (C17):

- **S1** — type absent: `indeterminate([dora_entity_type])`.
- **S2** — type not reached: `not_an_article_23_entity`.
- **S3** — type reached, incident false: `not_a_payment_related_incident`.
- **S4** — incident absent: `indeterminate([incident_is_operational_or_security_payment_related])`.
- **S5** — incident true or unsure, major absent: `indeterminate([payment_related_incident_is_major])`.
- **S6** — incident unsure, major present: `needs_legal_review` with the incident referral.
- **S7** — incident true, major unsure: `needs_legal_review` with the major referral.
- **S8** — major false: `chapter_requirements_apply`.
- **S9** — major true: `chapter_requirements_and_article_19_reporting_apply`.

**Recipients steps** (R0 is in `queries`):

- **R1 to R5**: mirror S1 to S5.
- **R6**: major false. If the incident is unsure, refer the incident judgement. If it is true, the answer is `chapter_requirements_apply`.
- **R7**: major true or unsure, type `credit_institution`, significance key absent: `indeterminate([credit_institution_classified_as_significant])`.
- **R8**: `member_state_requires_reports_to_directive_2022_2555_authorities` absent: indeterminate on that key.
- **R9**: incident unsure: refer the incident judgement.
- **R10**: incident true, major unsure: refer the major judgement.
- **R11**: the result is `recipients(List)`, where:
  - The FIRST element is `national_competent_authority_designated_under_directive_2013_36` when the authority default is defeated, that is, when the type is `credit_institution` and the significance key is `true`. Otherwise it is `relevant_competent_authority`.
  - `directive_2022_2555_competent_authority_or_csirt` is appended when the Member State key is `true`.

**Referral context.** Every referral has CONTEXT `[inputs_relied_on(Pairs)]`. Pairs come from the kernel `relied_pairs` over that query's read keys, and include the unsure key. An optional unscored `provenance(Clause, Citations)` may be appended.

**Checklist requirements** (`requirement(RequirementId, Profile, Status, Citation)`; RequirementId first; three exclusive clauses each — met / unmet / unknown):

- `article_23_entity_reached`, cited `cite(eu_reg_2022_2554_art_23)`. It is unknown when the type is absent.
- `operational_or_security_payment_related_incident`, cited `cite(eu_reg_2022_2554_art_3_9)`. It uses `check_tri/4`, so unsure or absent gives unknown.
- `major_incident_subject_to_article_19_reporting`, cited `cite(eu_reg_2022_2554_art_3_11)`. It uses `check_tri/4`. It is informational: the eligibility decision uses only the first two requirement ids, and the checklist lists all three.

### 7.3 Verdict atoms of this slice

All the atoms of section 1:

- the four status atoms
- `recipients/1` and its three recipient atoms
- the status compounds
- the checklist labels `eligible`, `indeterminate`, `ineligible`

### 7.4 Predicates SHARED with other layers (and only these go in `kernel.clausal`)

- `dora_payment_related_incidents_profile_problems/2`: used by `queries` (S0, R0) and by the facade.
- `dora_payment_related_incidents_relied_pairs/3`: the PAIRS rule, used by both queries' referral rows.
- `dora_payment_related_incidents_contract_key/3` and `dora_payment_related_incidents_value_has_type/2`: used by the input check and by the fixtures and validity tests.

Everything else in section 7 stays in the slice.

## 8. Tests (seven modes; v2 manifest)

Each mode is listed with its test files.

1. **Load** (`tests/test_load.clausal`).
2. **Per-rule unit tests**:
   - every S and R step
   - each defeater
   - each checklist requirement, with met, unmet and unknown cases
3. **Fixtures / golden answers**. Each named fixture has its exact answer, with citations compared as a set:
   - a major payment-institution incident, recipients `[relevant_competent_authority]`
   - a significant credit institution with NIS2 reporting
   - a non-major electronic money institution incident
   - an investment firm, giving `not_an_article_23_entity`
   - an institution exempted pursuant to Directive 2013/36/EU, giving `not_an_article_23_entity`
   - an incident that is not payment-related
   - both judgements unsure, with all keys present
4. **Input check**:
   - duplicates with equal values
   - wrong types, including `unsure` on a fact key, numbers and unbound values
   - unknown keys: variables (distinct versus the same variable), `7` versus `7.0`, compound keys
   - a profile that is not a list, a partial list, and a list with a bad element
5. **Determinism and counting**: `findall` plus `length(_, 1)` over every fixture and every problem profile.
6. **Totality / completion**: properties over all 29 types times the judgement and fact values, including absences.
   - (a) Exactly one answer.
   - (b) Whenever every completion of the absent keys and unsure judgements agrees, the answer equals that common answer.
   - (c) No named key is BEHIND an absent key.
7. **Citation completeness**: every cite is one of the five keys (`bad_citation/1`), and every status compound has `[]` citations.

Every negative `fail` test is paired with a positive test over the same case.
