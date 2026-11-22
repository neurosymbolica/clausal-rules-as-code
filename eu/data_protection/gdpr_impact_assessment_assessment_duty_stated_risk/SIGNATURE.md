# SIGNATURE — eu/data_protection/gdpr_impact_assessment_assessment_duty_stated_risk

## 1. Public query surface

The layout is kept as scaffolded:

`kernel -> citations -> parameters -> gdpr_impact_assessment_assessment_duty_stated_risk -> queries -> fixtures -> package facade`

The order's own relations are `decide_impact_assessment_duty/2` (entry A), `impact_assessment_officer_advice/2` (entry O) and `gdpr_impact_assessment_assessment_duty_stated_risk_input_problems/2` (the input check). The scaffold facade names wrap them.

Totality and determinism hold for every profile, ground or not. Every query gives EXACTLY ONE solution, never zero and never two. A non-list or unbound PROFILE gives `input_problems([wrong_type(profile)])`. No figure is imported, because Article 35 has no numeric parameter.

## 2. Verdict STATUS atoms (replacing `{ required, permitted, not_applicable }`)

**Entry A**: `impact_assessment_verdict(STATUS, BASES, MISSING_CONTENTS, CONTEXT, CITATIONS, ROUTES_RELIED_ON)`. STATUS is one of:

- `required`
- `not_required`
- `indeterminate([KEY])`
- `needs_legal_review(REASON, CONTEXT)`, where REASON is `open_textured(INPUT, cite(C))` or `cross_reference_unresolved(cite(C), cite(T))`
- `input_problems(PROBLEMS)`

The other fields are:

- BASES atoms: `art35_3_a_profiling_with_significant_decisions`, `art35_3_b_large_scale_sensitive_data`, `art35_3_c_public_area_monitoring`, `art35_4_national_list`, `art35_1_high_risk`, `art35_10_general_assessment_exemption`, `art35_5_national_list_exemption`, `no_requirement_triggered`.
- MISSING_CONTENTS atoms, in this order: `description_and_purposes`, `necessity_and_proportionality`, `risk_assessment`, `envisaged_measures`.
- ROUTES_RELIED_ON is always `[]`.

**Entry O**: `officer_advice_verdict(STATUS, CITATIONS)`. STATUS is one of: `met`, `not_met`, `not_applicable`, `indeterminate([KEY])`, `input_problems(PROBLEMS)`.

**Facade compliance check**: `permitted`, `prohibited`, or entry A's non-final STATUS passed through.

**Checklist item status** (formalize_lib vocabulary): `met`, `unmet(Reason)`, `unknown(Keys)`.

## 3. Profile keys (38, root_exports order = alphabetical)

Type legend:

- C: crisp `true` or `false`
- J: judgement `true`, `false` or `unsure`
- K: criteria key, typed J, read by no step
- F: boolean outside fact `attested(true|false, attestation(_,_,_,_))`
- I: item fact `attested(national_list_item(AUTHORITY, ITEM_ID), attestation(_,_,_,_))`
- R: route approvals `approvals(viewer(Account), [approval(RouteId, RouteSha256, Status, At, Reason), ...])`

Reader legend:

- A: read by entry A
- AC: read by entry A's checklist
- O: read by entry O
- none: read by no step

| # | Key | Type | Reader |
|---|---|---|---|
| 1 | `assessment_indicates_high_risk_absent_mitigation` | J | none |
| 2 | `automated_evaluation_including_profiling` | C | A |
| 3 | `criminal_offence_data_processed` | C | A |
| 4 | `data_protection_officer_advice_sought` | C | O |
| 5 | `data_protection_officer_designated` | C | O |
| 6 | `datasets_matched_or_combined` | K | none |
| 7 | `decisions_based_on_evaluation` | C | A |
| 8 | `decisions_produce_legal_effects` | C | A |
| 9 | `decisions_similarly_significantly_affect` | J | A |
| 10 | `description_of_processing_and_purposes_present` | C | AC |
| 11 | `envisaged_measures_described` | C | AC |
| 12 | `highly_personal_data_processed` | K | none |
| 13 | `impact_assessment_carried_out` | C | AC, O |
| 14 | `lawful_basis_is_legal_obligation_or_public_task` | C | A |
| 15 | `legal_basis_with_general_impact_assessment` | F (blocking) | A |
| 16 | `legitimate_interest_described` | C | AC |
| 17 | `legitimate_interest_pursued` | C | AC |
| 18 | `likely_high_risk_to_rights_and_freedoms` | J | A |
| 19 | `measures_reduce_residual_risk_below_high` | J | none |
| 20 | `member_state_requires_assessment_despite_general_one` | F (enabling) | A |
| 21 | `member_state_requires_prior_authorisation` | F | none |
| 22 | `mitigating_measures_taken` | C | none |
| 23 | `monitoring_is_systematic` | J | A |
| 24 | `national_list_exempts_assessment` | F (blocking) | A |
| 25 | `national_list_exempts_item` | I | A, only when 24 is attested true |
| 26 | `national_list_requires_assessment` | F (blocking) | A |
| 27 | `national_list_requires_item` | I | A, only when 26 is attested true |
| 28 | `necessity_and_proportionality_assessed` | C | AC |
| 29 | `processing_for_public_interest_task` | C | none |
| 30 | `processing_on_large_scale` | J | A |
| 31 | `processing_prevents_exercise_of_right_or_service` | K | none |
| 32 | `publicly_accessible_area_monitored` | C | A |
| 33 | `risks_to_data_subjects_assessed` | C | AC |
| 34 | `route_approvals` | R | none |
| 35 | `special_category_data_processed` | C | A |
| 36 | `systematic_and_extensive_evaluation` | J | A |
| 37 | `uses_new_technologies` | C | none |
| 38 | `vulnerable_data_subjects` | K | none |

- No key is numeric or a date, so there are no unit suffixes and no `date/3` terms.
- Item AUTHORITY is one of `de_dsk`, `ie_dpc`, `fr_cnil`.
- RouteSha256 is an atom of 64 lowercase hexadecimal digits. Status is `approved` or `rejected`.

## 4. Citation-key atoms (citations.clausal)

**Emitted:**

- `eu_reg_2016_679_art_35_1`
- `eu_reg_2016_679_art_35_2`
- `eu_reg_2016_679_art_35_3_a`
- `eu_reg_2016_679_art_35_3_b`
- `eu_reg_2016_679_art_35_3_c`
- `eu_reg_2016_679_art_35_4`
- `eu_reg_2016_679_art_35_5`
- `eu_reg_2016_679_art_35_7_a`
- `eu_reg_2016_679_art_35_7_b`
- `eu_reg_2016_679_art_35_7_c`
- `eu_reg_2016_679_art_35_7_d`
- `eu_reg_2016_679_art_35_10`
- the 29 item atoms, emitted as `cite(ITEM_ID)` only under the item rule:
  - `de_dsk_35_4_nr_1` to `de_dsk_35_4_nr_17`;
  - `ie_dpc_35_4_nr_1` to `ie_dpc_35_4_nr_10`;
  - `fr_cnil_35_4_list` and `fr_cnil_35_5_list`.

**Reasoning-only, never emitted:** `eu_reg_2016_679_art_4_4`, which is registered with its unit `point_004_4` for provenance of the profiling flag.

**Cross-reference TARGET:** for `member_state_requires_assessment_despite_general_one`, the citation is `eu_reg_2016_679_art_35_10`. TARGET is read verbatim from that key's scaffolded manifest `outside_facts:` entry and is never coined in code.

## 5. Public predicates (one line each)

- `decide_impact_assessment_duty(Profile, Verdict)`: entry A. Gives the whole `impact_assessment_verdict/6`. Cites Art 35(1), 35(3)(a)-(c), 35(4), 35(5), 35(7)(a)-(d) and 35(10).
- `impact_assessment_officer_advice(Profile, Verdict)`: entry O. Gives `officer_advice_verdict/2` by THE LADDER (O0 to O4). Cites Art 35(2).
- `gdpr_impact_assessment_assessment_duty_stated_risk_input_problems(Profile, Problems)`: THE INPUT CHECK (G1), shared by both entries. PROBLEMS are listed in this order: `duplicate_key/1` or `wrong_type/1` per contract key in root_exports order, then `unknown_key/1` by first occurrence (an unbound KEY is reported as itself, once per variable).
- `decide_gdpr_impact_assessment_assessment_duty_stated_risk(Profile, gdpr_impact_assessment_assessment_duty_stated_risk_verdict(Status, Citations))`: facade projection of entry A's STATUS and CITATIONS. Citations as entry A.
- `gdpr_impact_assessment_assessment_duty_stated_risk_status(Profile, Status)`: query type #3, classification. Gives entry A's STATUS. Cites Art 35(1), (3), (4), (5), (10).
- `gdpr_impact_assessment_assessment_duty_stated_risk_officer_status(Profile, Status)`: query type #3 for entry O. Gives entry O's STATUS. Cites Art 35(2).
- `gdpr_impact_assessment_assessment_duty_stated_risk_checklist(Profile, Checklist)`: query type #7, justification. Gives a list of `item(RequirementId, ItemStatus, cite(Key))`. The requirements are:
  - `art35_3_a_profiling_with_significant_decisions`, `art35_3_b_large_scale_sensitive_data`, `art35_3_c_public_area_monitoring`, `art35_4_national_list`, `art35_5_national_list_exemption`, `art35_10_general_assessment_exemption`, `art35_1_high_risk`;
  - `description_and_purposes`, `necessity_and_proportionality`, `risk_assessment`, `envisaged_measures`;
  - `art35_2_officer_advice`.

  Each item carries its own cite, met items included. This is a view only and never changes a verdict.
- `gdpr_impact_assessment_assessment_duty_stated_risk_compliance_check(Profile, Action, Result)`: query type #13. Action is `begin_processing`. Result is `permitted`, `prohibited`, or entry A's non-final STATUS (NOTES S4.16). Cites Art 35(1) and 35(7).
- `gdpr_impact_assessment_assessment_duty_stated_risk_what_if(Profile, Key, Value, Verdict)`: replaces Key's value using `profile_set/3`, then reruns entry A. Gives entry A's verdict on the edited profile.
- `gdpr_impact_assessment_assessment_duty_stated_risk_fixture(FixtureName, Profile)`: named fixture profiles (§7). If the scaffold's fixture export name differs, the scaffold name is kept.

The result constructors listed in the INPUT CONTRACT are exported as constructors and are never called as queries.

### 5.1 Result constructors (data terms, one line each)

- `resolution(Target, Outcome)`: in the context list of a `cross_reference_unresolved` referral of entry A, records that the cross-referenced provision `cite(TARGET)` was not looked up; Outcome is always the atom `not_attempted` (fetcher none). Cites Art 35(10), last clause (`eu_reg_2016_679_art_35_10`).
- `url(Address, RetrievedAt)`: an EVIDENCE form inside `attestation/4` of an outside fact: the web address of the published supervisory authority list or law and when it was retrieved; copied into CONTEXT, never read, compared or computed with. Cites Art 35(4), 35(5) and 35(10).
- `document(UploadIdentifier, Sha256)`: the other EVIDENCE form inside `attestation/4`: an uploaded document and its hash; copied, never read. Cites Art 35(4), 35(5) and 35(10).
- `attested(Value, Attestation)` and `attestation(By, At, Reason, Evidence)`: the outside-fact wrapper; By and At host-supplied. Cites Art 35(4), 35(5) and 35(10).
- `outside_fact(Key, AttestedOrAbsent)` and `inputs_relied_on(Pairs)`: CONTEXT entries of a final verdict or referral. Cites Art 35(1) to 35(10) as the deciding clause.
- `provenance(Clause, Citations)`: optional unscored marker after PAIRS naming the deciding clause.
- `impact_assessment_verdict/6`, `officer_advice_verdict/2`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `approvals/2`, `approval/5`, `viewer/1`: as defined in §2 and the INPUT CONTRACT.

## 6. Planned reuse (manifest `uses:`)

**formalize_lib**

- `profile_get/3` is the ONLY profile reader. Keys are read by presence first, then by value.
- `profile_set/3` is used by what_if.
- `not_defeated/3` and `first_applicable/2` support the guarded defeaters.
- `item/3`, `unmet/1` and `unknown/1` build checklist rows.
- `memberd/2` and `not_member/2` support the input check.
- `and_status/2` and `or_status/2` are NOT used, because the order needs three open kinds (see kernel).
- `check_tri/4` is used for the checklist rows of judgement keys only.

**validate_props** (tests): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.

**kit/query_combinators**: `what_if/5` is used if it accepts attribute lists. Otherwise the facade uses `profile_set/3` directly. `not_met/1` is never imported into the slice (atom-shadowing guard).

**kit/compliance_lib**: `nm/2` and `compliance_check/7`. A one-row norm table, `nm(art35_1_assessment_prior_to_processing, obligation)`, is mapped onto `permitted` or `prohibited` in the facade compliance check.

The following are not used, because there are no dates, money or plans: currency_vocab, vat_category, deadline_lib, rolling_window, date_time, country.

**Idioms**

- Defeasible rules use guarded `once/1` defeaters. There is no `!`, no `->` and no `*->`.
- Ground outputs are folded into clause heads (C17).
- Open-textured terms are handed to the user as judgements.

## 7. Fixtures (fixtures.clausal)

| Fixture | Expected result |
|---|---|
| `profiling_with_legal_effects_complete` | required / 3(a), contents `[]` |
| `large_scale_health_data_no_assessment` | required / 3(b), all four contents missing |
| `public_area_monitoring_missing_measures` | required / 3(c), `[envisaged_measures]` |
| `national_list_item_de_dsk` | required / 4, with `cite(de_dsk_35_4_nr_1)` |
| `stated_high_risk` | required / 1 |
| `exempt_list_fr_cnil` | not_required / 5, with `cite(fr_cnil_35_5_list)` |
| `general_assessment_exemption` | not_required / 10 |
| `nothing_triggered` | not_required / no_requirement_triggered |
| `missing_profiling_flag` | indeterminate([automated_evaluation_including_profiling]) |
| `member_state_decision_absent` | needs_legal_review(cross_reference_unresolved(...)) |
| `large_scale_unsure` | needs_legal_review(open_textured(processing_on_large_scale, cite(eu_reg_2016_679_art_35_3_b))) |
| `legitimate_interest_unknown` | indeterminate([legitimate_interest_pursued]) |
| `duplicate_and_unknown_keys` | input_problems |
| `officer_advice_sought` | met |
| `officer_not_consulted` | not_met |
| `no_officer_designated` | not_applicable |
| `officer_both_absent` | indeterminate([impact_assessment_carried_out]) |

## 8. Shared modules

### 8.1 kernel.clausal (shared floor only)

The kernel holds the strong-Kleene algebra over limb values: `met`, `unmet`, `open(absence, Key)`, `open(judgement, Key)` and `open(cross_reference, Key)`. Its predicates are:

- `strong_and(Values, Value)`
- `strong_or(Values, Value)`
- `strong_not(Value, Negated)`
- `leaf_crisp(Profile, Key, Value)`
- `leaf_judgement(Profile, Key, Value)`
- `leaf_outside_blocking(Profile, Key, Value)`
- `leaf_outside_enabling(Profile, Key, Value)`

These are shared because the slice and the facade checklist (queries) both evaluate limbs. Each leaf has three mutually exclusive clauses: met, unmet and open.

### 8.2 citations.clausal

`citation(Key, Instrument, Unit, Text)` for every atom in §4.

### 8.3 parameters.clausal

No statutory figure exists. The module stays as an empty, documented placeholder and does not declare `constant_value/2`.

### 8.4 queries.clausal

The facade-level status, checklist, compliance_check and what_if, all built on the slice.

## 9. Slice: gdpr_impact_assessment_assessment_duty_stated_risk.clausal

### 9.1 Value facts owned here

Article 35 has no thresholds, periods or money, so the slice owns only the closed tables below.

- `contract_key(Key, Type)`: the 38 rows of §3, in root_exports order.
- `national_list_item_identifier(Side, Authority, ItemId)`:
  - side `requires`: the 28 ids other than `fr_cnil_35_5_list`, with the matching prefix authority;
  - side `exempts`: only `fr_cnil_35_5_list` / `fr_cnil`.
- `basis_citation(Basis, CiteKeys)`:
  - 3(a), 3(b), 3(c), 4 and 1 each map to their own atom;
  - 35(10) maps to `art_35_10`;
  - 35(5) maps to `art_35_5`;
  - `no_requirement_triggered` maps to `[art_35_1, art_35_3_a, art_35_3_b, art_35_3_c, art_35_4]`.
- `content_citation(Content, CiteKey)`: `description_and_purposes` maps to `7_a`, `necessity_and_proportionality` to `7_b`, `risk_assessment` to `7_c`, `envisaged_measures` to `7_d`.
- `judgement_citation(Key, CiteKey)`:
  - `likely_high_risk_to_rights_and_freedoms` maps to `35_1`;
  - `systematic_and_extensive_evaluation` and `decisions_similarly_significantly_affect` map to `35_3_a`;
  - `processing_on_large_scale` maps to `35_3_b`;
  - `monitoring_is_systematic` maps to `35_3_c`.
- `trigger_order/1`: `[3a, 3b, 3c, 4, 1]`, spelled with the BASES atoms.
- `required_key_order/1`: the 12 REQUIRED keys in root_exports order: `automated_evaluation_including_profiling`, `criminal_offence_data_processed`, `decisions_based_on_evaluation`, `decisions_produce_legal_effects`, `decisions_similarly_significantly_affect`, `lawful_basis_is_legal_obligation_or_public_task`, `likely_high_risk_to_rights_and_freedoms`, `monitoring_is_systematic`, `processing_on_large_scale`, `publicly_accessible_area_monitored`, `special_category_data_processed`, `systematic_and_extensive_evaluation`.
- `checklist_key_order/1`: `impact_assessment_carried_out`, `description_of_processing_and_purposes_present`, `legitimate_interest_pursued`, `legitimate_interest_described`, `necessity_and_proportionality_assessed`, `risks_to_data_subjects_assessed`, `envisaged_measures_described`.

### 9.2 Rules and requirements

**Input check (G1).** It decides whether the profile is an attribute list, finding:

- duplicates, without reading their values;
- type checks per row of `contract_key/2`, including item shape, side and prefix-authority checks and the `route_approvals` shape;
- unknown keys by first occurrence, with unbound KEYs reported as themselves.

**Limbs.**

- T3A = AND(profiling, decisions_based, systematic_and_extensive, OR(legal_effects, similarly_significant)).
- T3B = AND(large_scale, OR(special_category, criminal_offence)).
- T3C = AND(public_area, monitoring_systematic, large_scale).
- L4 = the requires list.
- X5 = the exempts list.
- X10 = AND(basis_c_or_e, general_assessment_legal_basis, NOT member_state_requires).
- H1 = the stated risk.

**Decision.** REQUIRED = AND(NOT X10, OR(T3A, T3B, T3C, L4, AND(NOT X5, H1))).

- STEP 1 evaluates REQUIRED with H1 open.
- STEPS 2 and 3 read H1 only if REQUIRED is still open.
- X10 is a guarded `once/1` defeater of every trigger. X5 is a guarded defeater of the H1 path only.

**Checklist.** As in NOTES S4.8.

**Completion test.** This is THE MISSING-KEY RULE.

- The open slots are absent REQUIRED and checklist keys, unsure judgements, and the absent enabling fact.
- The DECISION factorises into REQUIRED and the checklist, so the two are enumerated separately:
  - completions of the REQUIRED slots: at most 2^13;
  - completions of the checklist slots: at most 2^7, and only when REQUIRED can be MET.
- Enumeration uses `findall/3` with no cut.
- **Settled**: there is one DECISION.
- **Matters**: two completions that differ in one slot give different DECISIONS.
- **Behind**: the <<DNUM>> pairwise test.
- The pick order is: the first absent key that matters and is not behind another, REQUIRED keys before checklist keys; then the cross-reference referral (<<DNUM>>(a)); then the first unsure judgement that matters, in root_exports order.

**Final assembly.**

- BASES is the first MET trigger on the profile as given, or the not_required basis.
- CONTEXT holds, in root_exports order:
  - present boolean facts as `outside_fact(K, Attested)`;
  - absent blocking facts as `outside_fact(K, absent)`;
  - a READ and PRESENT item fact directly after its boolean;
  - then `inputs_relied_on(PAIRS)`.
- CITATIONS is a set, built from `basis_citation/2`, `content_citation/2` and the item cite. It never includes `art_4_4`.
- ROUTES_RELIED_ON is `[]`.
- A non-final status gives all lists `[]`.

**Entry O ladder.**

- O0: input problems.
- O1: either key false gives `not_applicable` with `[cite(eu_reg_2016_679_art_35_2)]`.
- O2: `impact_assessment_carried_out` absent gives `indeterminate([impact_assessment_carried_out])`.
- O3: `data_protection_officer_designated` absent gives `indeterminate([data_protection_officer_designated])`.
- O4: with both true, the advice key gives `met` or `not_met` with the Art 35(2) cite, or `indeterminate([data_protection_officer_advice_sought])` when absent.

The clauses are written as disjoint heads with folded constants.

### 9.3 Verdict atoms

As listed in §2.

### 9.4 Shared with other modules

Only the kernel's Kleene leaves and combinators are shared. The slice exports the three order relations, plus `checklist_rows/2` for queries.clausal.

### 9.5 Tests (seven modes)

The tests are written per rule, in seven modes: load, unit per limb, verdict fixtures, missing-key, input-check, properties (totality, determinism, citation completeness, ignored-key invariance) and mutation. Each negative test is paired with a positive test over the same case.
