# SIGNATURE: eu/data_protection/gdpr_impact_assessment_prior_consultation

Predicate prefix: `gdpr_impact_assessment_prior_consultation_`.

Layout, unchanged from the scaffold:

`kernel -> citations -> parameters -> prior_consultation_duty -> queries -> fixtures -> package facade`

## Public query surface

### Order relations (names and arities fixed by the order)

- `decide_prior_consultation(Profile, Verdict)`
  - Gives the whole entry-B verdict `prior_consultation_verdict(Status, Bases, Context, Citations)`.
  - Answers whether the controller must consult the supervisory authority before processing.
  - Citations: `eu_reg_2016_679_art_36_1`, `eu_reg_2016_679_art_36_5`.
  - Exactly one solution per profile.
- `prior_consultation_duty(Profile, Status)`
  - Gives the Status field of `decide_prior_consultation/2`, or `input_problems(Problems)`.
  - Citations: Art 36(1), (5).
- `impact_assessment_outside_facts(Profile, OutsideFacts)`
  - Gives `[outside_fact(Key, Attested)]` for the five boolean outside facts in root_exports order. Each entry carries the `attested(...)` term as given, or the atom `absent`.
  - With a non-empty problem list it gives `input_problems(Problems)`.
  - Citation: no verdict citation (it is a context relation).
- `gdpr_impact_assessment_prior_consultation_input_problems(Profile, Problems)`
  - The INPUT CHECK (G1). Gives `[]` for a well-formed profile, else the ordered problem terms.
  - Citation: contract, no legal citation.

### Scaffold facade names (kept; thin aliases over the order relations)

- `decide_prior_consultation_duty(Profile, Verdict)`
  - The same verdict as `decide_prior_consultation/2`. It calls that relation once.
  - Citations: Art 36(1), (5).
- `prior_consultation_duty_status(Profile, Status)`
  - The same as `prior_consultation_duty/2`.
  - Citations: Art 36(1), (5).
- `prior_consultation_duty_checklist(Profile, Checklist)`
  - Query type #7, justification. Gives the list of `item(RequirementId, Status, cite(CitationKey))` over the entry-B requirements (see the slice section). Every item carries `cite(...)`, met items included.
  - With a non-empty problem list it gives `input_problems(Problems)`.
  - Citations: Art 36(1), (5).
- `gdpr_impact_assessment_prior_consultation_what_if(Profile, Key, Value, Verdict)`
  - Sets `attribute(Key, Value)` with `profile_set/3`, then gives the verdict of `decide_prior_consultation/2` on the edited profile.
  - An unknown or ill-typed edit surfaces as `input_problems(...)` through the input check.
  - Citations: Art 36(1), (5).
- `gdpr_impact_assessment_prior_consultation_compliance_check(Profile, Action, Verdict)`
  - Query type #13, compliance check: is a proposed action allowed in the current state.
  - Action is one of `begin_processing_without_prior_consultation` or `begin_processing_after_prior_consultation`. Built on `compliance_check/7` of `kit/compliance_lib`. The single norm `art36_prior_consultation` (an obligation to consult before processing) applies only when Status is `required`. Deny-overrides then forbids `begin_processing_without_prior_consultation`.
  - When Status is not final (`indeterminate/1`, `needs_legal_review/2`, `input_problems/1`), Verdict is `not_decided(Status)`. No permission is ever inferred from an open answer.
  - Citations: Art 36(1), (5).

### Fixtures (in `fixtures.clausal`)

Named profiles `gdpr_impact_assessment_prior_consultation_fixture(Name, Profile)`:

| Name | Profile | Expected verdict |
|---|---|---|
| `residual_high_risk_no_measures` | | required, Art 36(1) |
| `residual_high_risk_measures_insufficient` | | required, Art 36(1) |
| `measures_bring_risk_below_high` | | not_required |
| `no_high_risk_indicated` | | not_required |
| `member_state_prior_authorisation` | C1 true, A unmet, P5 met | required, Art 36(5) |
| `both_ways_met` | | basis Art 36(1) |
| `no_assessment_public_interest_unmet` | | not_governed_here |
| `no_assessment_member_state_authorisation` | | required, Art 36(5) |
| `no_assessment_member_state_fact_absent` | | cross_reference_unresolved |
| `assessment_status_absent_no_way_open` | | not_required, reading 13 |
| `assessment_status_absent_way_open` | | indeterminate naming `impact_assessment_carried_out` |
| `two_keys_missing` | | indeterminate with both keys, the list-all missing-keys rule |
| `residual_risk_unsure` | | open_textured |
| `duplicate_and_unknown_keys` | | input_problems |
| `criteria_and_item_keys_ignored` | | answer equal to the base fixture |

### Totality and determinism

- Every query is total over any term: a non-attribute-list profile gives `[wrong_type(profile)]`.
- Every query is deterministic: exactly one solution, checked with `findall` + `length(_, 1)` in the tests.
- No figure is imported or declared. The pinned text carries no threshold this order computes with.

## Verdict STATUS atoms (replacing the placeholder `{ required, permitted, not_applicable }`)

- `required`: a bare atom, final.
- `not_required`: a bare atom, final.
- `indeterminate(MissingKeys)`
  - MissingKeys is a non-empty list of bare key atoms in root_exports order, without duplicates.
  - The bare atom `indeterminate` is never written.
- `needs_legal_review(Reason, Context)`, where Reason is one of:
  - `cross_reference_unresolved(cite(eu_reg_2016_679_art_36_5), cite(Target))`
    - Context: `[resolution(cite(Target), not_attempted), inputs_relied_on(Pairs)]`.
    - Target is the TARGET atom of the `member_state_requires_prior_authorisation` entry in the manifest `outside_facts:` block. It is read from there and never invented.
  - `open_textured(Key, cite(eu_reg_2016_679_art_36_1))` for `assessment_indicates_high_risk_absent_mitigation` or `measures_reduce_residual_risk_below_high`.
    - Context: `[inputs_relied_on(Pairs)]`.
  - `not_governed_here([cite(eu_reg_2016_679_art_35_1), cite(eu_reg_2016_679_art_36_1)])`
    - Context: `[inputs_relied_on(Pairs)]`.
- `input_problems(Problems)`
  - Problems are `duplicate_key(Key)`, `wrong_type(Key)` and `unknown_key(Key)`.
  - The verdict is `prior_consultation_verdict(input_problems(Problems), [], [], [])`.

Basis atoms (a list of one atom for a final STATUS, else `[]`):

- `art36_1_residual_high_risk`
- `art36_5_member_state_prior_authorisation`
- `art36_1_condition_not_met`

Citation rule:

- `art36_1_residual_high_risk` and `art36_1_condition_not_met` give `[cite(eu_reg_2016_679_art_36_1)]`.
- `art36_5_member_state_prior_authorisation` gives `[cite(eu_reg_2016_679_art_36_5)]`.
- A non-final STATUS gives `[]`.

## Profile keys (exactly 36; read only through `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_keys/2`)

### Crisp, `true` / `false` (17)

| Key | Read by entry B |
|---|---|
| `uses_new_technologies` | no |
| `automated_evaluation_including_profiling` | no |
| `decisions_based_on_evaluation` | no |
| `decisions_produce_legal_effects` | no |
| `special_category_data_processed` | no |
| `criminal_offence_data_processed` | no |
| `publicly_accessible_area_monitored` | no |
| `lawful_basis_is_legal_obligation_or_public_task` | no |
| `impact_assessment_carried_out` | **yes**, C1 |
| `description_of_processing_and_purposes_present` | no |
| `legitimate_interest_pursued` | no |
| `legitimate_interest_described` | no |
| `necessity_and_proportionality_assessed` | no |
| `risks_to_data_subjects_assessed` | no |
| `envisaged_measures_described` | no |
| `mitigating_measures_taken` | **yes**, MT |
| `processing_for_public_interest_task` | **yes**, P5 part one |

### Judgement, `true` / `false` / `unsure` (7)

| Key | Read by entry B |
|---|---|
| `systematic_and_extensive_evaluation` | no |
| `decisions_similarly_significantly_affect` | no |
| `processing_on_large_scale` | no |
| `monitoring_is_systematic` | no |
| `likely_high_risk_to_rights_and_freedoms` | no |
| `assessment_indicates_high_risk_absent_mitigation` | **yes**, JB |
| `measures_reduce_residual_risk_below_high` | **yes**, MR |

### Criteria, `true` / `false` / `unsure` (4; never read for an answer)

- `highly_personal_data_processed`
- `datasets_matched_or_combined`
- `vulnerable_data_subjects`
- `processing_prevents_exercise_of_right_or_service`

### Outside facts, `attested(true|false, attestation(By, At, Reason, Evidence))` or absent (5)

| Key | Direction | Read by entry B |
|---|---|---|
| `legal_basis_with_general_impact_assessment` | blocking | no |
| `member_state_requires_assessment_despite_general_one` | enabling | no |
| `member_state_requires_prior_authorisation` | enabling | **yes**, P5 part two |
| `national_list_exempts_assessment` | blocking | no |
| `national_list_requires_assessment` | blocking | no |

### Item facts (2; checked, never read)

Each is `attested(national_list_item(Authority, ItemId), attestation(_, _, _, _))`.

- `national_list_requires_item`
  - Authority is one of `de_dsk`, `ie_dpc`, `fr_cnil`, and must match the ItemId prefix.
  - ItemId is one of 28 atoms: `de_dsk_35_4_nr_1` to `de_dsk_35_4_nr_17`, `ie_dpc_35_4_nr_1` to `ie_dpc_35_4_nr_10`, `fr_cnil_35_4_list`.
- `national_list_exempts_item`
  - Only `national_list_item(fr_cnil, fr_cnil_35_5_list)`.

### Route approvals (1; checked, never read)

- `route_approvals`: `approvals(viewer(Account), [approval(RouteId, RouteSha256, Status, At, Reason), ...])`.
  - RouteId is any atom.
  - RouteSha256 is an atom of 64 lowercase hexadecimal digits.
  - Status is `approved` or `rejected`.

### Notes on keys

- No numeric key and no date key exists, so no unit suffix and no `date/4` term is needed.
- Evidence terms (`url/2`, `document/2`, `none`) are copied and never inspected.

## Citation-key atoms (`citations.clausal`; order-given, never shortened, never invented)

- `eu_reg_2016_679_art_36_1`: Regulation (EU) 2016/679 Art 36(1), unit `02016R0679-20160504#parag_036.001`.
- `eu_reg_2016_679_art_36_5`: Regulation (EU) 2016/679 Art 36(5), unit `02016R0679-20160504#parag_036.005`.
- `eu_reg_2016_679_art_35_1`: Regulation (EU) 2016/679 Art 35(1), used only inside `not_governed_here/1`.

The cross-reference TARGET for `member_state_requires_prior_authorisation` is taken verbatim from the manifest `outside_facts:` entry.

## Planned reuse (manifest `uses:`)

### `formalize_lib`

| Predicates | Use |
|---|---|
| `profile_get/3`, `profile_has/2`, `profile_lacks/2` | leaf reads, by presence first and then by value |
| `profile_keys/2` | duplicate and unknown-key detection in the input check; no hand traversal |
| `profile_set/3` | what-if |
| `check_true/4`, `check_false/4` | C1, NOT MT and the public-interest flag |
| `check_tri/4`, `check_tri_neg/4` | the true/false cases of JB and of NOT MR. `unsure` and absence are classified first by the slice's leaf clauses into the open kinds judgement and absence. |
| `and_status/2`, `or_status/2`, `collect_unknown/2` | Kleene nodes, with open leaves carried as `unknown([open_leaf(Kind, Key)])`. P2 verifies that `and_status`/`or_status` give unmet-dominates / met-dominates and union the unknowns. If they do not, the slice keeps three-clause local `kleene_conjunction/2` and `kleene_disjunction/2` and notes the gap. |
| `eval_requirements/4`, `item/3` | the checklist (query type #7); no hand-rolled findall row helper (R1) |
| `not_defeated/3` | the defeasible default `not_required` |
| `memberd/2`, `not_member/2` | ordered filtering of keys against the kernel's root_exports key list |

### `kit/compliance_lib`

- `compliance_check/7` with an Applies closure over the slice's STATUS (query type #13).

### `validate_props`

- `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`.
- These drive the property and test modes, with generators over the fixtures and over the Cartesian product of the six entry-B leaves.

### Not used

- `kit/deadline_lib`: Art 36(2) is deferred.
- `kit/query_combinators` `what_if/5`: it takes a Dict world, while the profile is an attribute list, so `profile_set/3` is used.
- Date, currency and country vocabularies.

## Defeasible structure (guarded `once/1` defeaters, cut-free)

- **Default rule `art36_1_condition_not_met`.** When CONSULT is UNMET, `not_required` holds unless it is defeated.
- **Defeater `missing_assessment_referral` (Q5).** It fires when `impact_assessment_carried_out` is `false`.
  - Called as `not_defeated(art36_1_condition_not_met, Profile, prior_consultation_defeater)`.
  - The defeater body is `once(...)`, guarded by a ground, problem-free profile.
  - It is never triggered by absence (reading 13).
- **Priority (Art 36(5), 'notwithstanding paragraph 1').** A MET P5 makes the status `required`, and the Q5 defeater is not consulted. The route guards are disjoint, so no clause is retracted at run time.

## Kernel (`kernel.clausal`): the shared floor

The kernel holds only what both the slice and `queries.clausal` need.

- **The ordered contract key table.** `gdpr_impact_assessment_prior_consultation_contract_key(Key, Kind)` covers all 36 keys in root_exports (alphabetical) order. Kind is one of `crisp`, `judgement`, `criteria`, `outside_fact`, `item_fact` or `route_approvals`.
- **The item-id vocabulary.**
  - `national_list_requires_item_identifier(Authority, ItemId)`: 28 facts.
  - `national_list_exempts_item_identifier(fr_cnil, fr_cnil_35_5_list)`: 1 fact.
  - These are contract vocabulary, not statutory figures.
- **`gdpr_impact_assessment_prior_consultation_input_problems/2`.** It checks:
  - attribute-list shape;
  - duplicate keys, per key in root_exports order, without reading values;
  - `wrong_type/1` per key kind;
  - SHA-256 shape (64 lowercase hex digits) and approval Status;
  - `unknown_key/1` in order of first occurrence, once each.
- **`gdpr_impact_assessment_prior_consultation_outside_fact_reading(Profile, Key, Attested)`.** Gives the `attested(...)` term as given, or `absent`.

## Citations (`citations.clausal`)

- `citation(Key, Instrument, Unit)` for the three atoms above.
- `basis_citation(Basis, cite(Key))` for the three basis atoms.

## Parameters (`parameters.clausal`)

- The module is kept. It declares no `constant_value/2`: there is no threshold, period or table this order computes with.
- The Art 36(2) periods are deferred.
- A header comment records this, so that the later phases do not add figures.

## Determination slice: `prior_consultation_duty.clausal`

### Statutory value facts owned

- None numeric.
- The slice owns the legal constants of the determination:
  - the three basis atoms and their citation mapping (from `citations.clausal`);
  - `open_textured_citation(assessment_indicates_high_risk_absent_mitigation, eu_reg_2016_679_art_36_1)`;
  - `open_textured_citation(measures_reduce_residual_risk_below_high, eu_reg_2016_679_art_36_1)`;
  - `not_governed_here` citation list: `[cite(eu_reg_2016_679_art_35_1), cite(eu_reg_2016_679_art_36_1)]`;
  - the entry-B key list in root_exports order: `assessment_indicates_high_risk_absent_mitigation`, `impact_assessment_carried_out`, `measures_reduce_residual_risk_below_high`, `member_state_requires_prior_authorisation`, `mitigating_measures_taken`, `processing_for_public_interest_task`;
  - the entry-B judgement keys: `assessment_indicates_high_risk_absent_mitigation`, `measures_reduce_residual_risk_below_high`.

### Leaves

Leaf status is one of `met`, `unmet` or `open(Kind, Key)`, where Kind is `absence`, `cross_reference` or `judgement`.

| Leaf | Key | Kind of key | Behaviour |
|---|---|---|---|
| C1 | `impact_assessment_carried_out` | crisp | absent gives OPEN BY ABSENCE |
| JB | `assessment_indicates_high_risk_absent_mitigation` | judgement | `unsure` gives OPEN BY JUDGEMENT |
| NOT MT | `mitigating_measures_taken` | crisp, negated | false gives MET |
| NOT MR | `measures_reduce_residual_risk_below_high` | judgement, negated | false gives MET; `unsure` stays OPEN BY JUDGEMENT |
| PI | `processing_for_public_interest_task` | crisp | |
| MS | `member_state_requires_prior_authorisation` | enabling outside fact | attested true gives MET; attested false gives UNMET; absent gives OPEN BY CROSS-REFERENCE |

### Nodes

- `A = AND(C1, JB, OR(NOT MT, NOT MR))`
- `P5 = AND(PI, MS)`
- `CONSULT = OR(A, P5)`
- Strong Kleene applies. A node's open leaves are the open leaves of its OPEN children only.

### Rules and requirements (checklist ids for `eval_requirements/4`; each with `cite(...)`)

| Requirement id | Test | Citation |
|---|---|---|
| `impact_assessment_carried_out` | C1 | Art 36(1) |
| `high_risk_indicated_absent_mitigation` | JB | Art 36(1) |
| `residual_risk_remains_high` | `OR(NOT MT, NOT MR)` | Art 36(1) |
| `processing_for_public_interest_task` | PI | Art 36(5) |
| `member_state_requires_prior_authorisation` | MS | Art 36(5) |

Checklist statuses are the `formalize_lib` statuses `met`, `unmet(Reason)` and `unknown(Keys)`:

- An `unsure` judgement or an absent outside fact shows as `unknown([Key])` in the checklist only.
- The verdict's MISSING_KEYS never contains an outside fact.

### Decision routes

The routes are disjoint, ground outputs are folded into the heads, and there is exactly one solution.

1. **Problems non-empty.**
   - Verdict: `prior_consultation_verdict(input_problems(Problems), [], [], [])`.
2. **A MET.**
   - Status: `required`.
   - Bases: `[art36_1_residual_high_risk]`.
   - Citations: `[cite(eu_reg_2016_679_art_36_1)]`.
3. **A not MET and P5 MET.**
   - Status: `required`.
   - Bases: `[art36_5_member_state_prior_authorisation]`.
   - Citations: `[cite(eu_reg_2016_679_art_36_5)]`.
4. **C1 `false` and P5 UNMET.**
   - Status: `needs_legal_review(not_governed_here([cite(eu_reg_2016_679_art_35_1), cite(eu_reg_2016_679_art_36_1)]), [inputs_relied_on(Pairs)])`.
   - Bases, Context and Citations: `[]`.
5. **CONSULT UNMET and C1 not `false`** (true, or absent: reading 13).
   - Status: `not_required`.
   - Bases: `[art36_1_condition_not_met]`.
   - Citations: `[cite(eu_reg_2016_679_art_36_1)]`.
6. **CONSULT OPEN.** The status takes the open kind of CONSULT's leaves, checked in this order:
   - any absence leaf gives `indeterminate(Keys)`, naming every absent crisp or judgement key in root_exports order;
   - else a cross-reference leaf gives `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_5), cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on(PairsWithAbsent)])`;
   - else the first `unsure` judgement in root_exports order gives `needs_legal_review(open_textured(Key, cite(eu_reg_2016_679_art_36_1)), [inputs_relied_on(Pairs)])`.

   With C1 false, A is UNMET and is not descended into, so the open kind is P5's own.

For final routes 2, 3 and 5, Context is:

- `[outside_fact(member_state_requires_prior_authorisation, Attested)]`, when that fact is present;
- followed by `inputs_relied_on(Pairs)`.

### Pairs

- Pairs are the present entry-B judgement keys as `Key-Value`, in root_exports order.
- In the cross-reference referral, `member_state_requires_prior_authorisation-absent` is merged at its alphabetical place, after `measures_reduce_residual_risk_below_high`.

### Verdict atoms

- The slice uses the STATUS atoms and basis atoms listed above.
- It owns `decide_prior_consultation/2` and `prior_consultation_duty/2`.
- It also owns the checklist requirement predicate `prior_consultation_requirement(RequirementId, Profile, Status, Citation)`, with RequirementId first, as `assess/6` and `eval_requirements/4` expect.

### Shared with another slice

- Nothing beyond the kernel items above: the contract key table, the input check and the outside-fact reading.
- There is no second determination slice. `queries.clausal` uses only the kernel's outside-fact reading for `impact_assessment_outside_facts/2`, and the slice's `decide_prior_consultation/2` for the facade, the what-if and the compliance check.

## Queries (`queries.clausal`)

- `impact_assessment_outside_facts/2`.
- The facade aliases.
- `prior_consultation_duty_checklist/2`.
- The what-if.
- The compliance check.

Each query calls the input check first and has exactly one solution.

## Tests (seven modes, v2 manifest)

- Per-route positive tests, each paired with a negative test over the same case.
- Exactly-once counting with `findall` + `length(_, 1)`.
- Input-problem ordering: duplicate before wrong type, contract keys in root_exports order, unknown keys by first occurrence.
- Reading 13, together with the Q5 contrast profile.
- two missing keys are both named.
- PAIRS merge position.
- Invariance: the criteria keys, item facts, `route_approvals` and sibling keys present or absent give an identical verdict.
- Properties via `validate_props`: totality, determinism, citation completeness and missing-key coverage over the 3x3x3x3x3x3 grid of the entry-B leaves (with outside-fact states absent / true / false).
