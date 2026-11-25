# SIGNATURE: eu/dora_ict_risk_learning_and_evolving

## Public query surface

The package answers three questions about one financial entity under DORA Art 13, gated by Art 16(1), first subparagraph. It also exposes a typed input check and the scaffold facade.

Every public predicate:

- is total;
- is deterministic, yielding EXACTLY ONE solution for every PROFILE term, including malformed ones;
- never raises;
- never returns a float, a string or a record.

Determinism comes from mutually exclusive clause guards and from first-of-findall selection. There is no cut, no `->` and no `*->`. Ground outputs are folded into clause heads (C17).

No statutory figure is numeric, so nothing is imported or re-declared as a constant.

## Verdict STATUS atoms

These replace the placeholder `required / permitted / not_applicable`.

### Final answers

- `required(DUTIES)`: arity 1. DUTIES is a non-empty list of duty atoms in DUTY ORDER.
- `complete`
- `incomplete`
- `none_outstanding`
- `outstanding(DUTIES)`: arity 1. DUTIES is a non-empty list in DUTY ORDER.
- `simplified_framework_entity`

### Status compounds

These are never final. CITATIONS is always `[]` with them.

- `indeterminate([KEY])`: exactly one bare key atom. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(KEY, cite(CITATION_KEY)), [inputs_relied_on(PAIRS)])`. An optional unscored `provenance(CLAUSE, CITATIONS)` item may follow `inputs_relied_on(PAIRS)`.
- `input_problems(PROBLEMS)`. PROBLEMS is a list of `duplicate_key(KEY)`, `wrong_type(KEY)` and `unknown_key(KEY)` terms.

### Facade-only atoms

These are for the checklist and the compliance check:

- per-duty item status: `met`, `unmet(not_performed)`, `unknown([KEY])`, `inapplicable` (the formalize_lib vocabulary atoms `met`, `inapplicable` and `applicable`);
- compliance verdict: `compliant`, `non_compliant`, `not_applicable`.

### Result constructors

These are exported and never called as queries: `required/1`, `outstanding/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## Profile keys

PROFILE is `[attribute(KEY, VALUE), ...]`. It is read ONLY with `profile_get/3`: presence first, then value. Keys are bare atoms. There are no numeric keys and no dates.

The twenty-four keys are listed in root_exports and input_contract order.

### Fact keys (crisp, type `boolean`: the atoms `true` or `false` only)

1. `financial_entity_is_article_16_1_entity`: the GATE.
2. `financial_entity_is_microenterprise`: TRIGGER. NON-MICROENTERPRISE means this key is `false`.
3. `major_ict_related_incident_disrupted_core_activities`: TRIGGER. INCIDENT means this key is `true`.
4. `competent_authority_requested_post_incident_review_changes`: TRIGGER. REQUEST means this key is `true`.

### Judgement keys (tri-state, type `one_of(boolean, unsure)`: the atoms `true`, `false` or `unsure`)

5. `capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information`
6. `post_ict_related_incident_reviews_put_in_place`
7. `post_incident_review_changes_communicated_to_competent_authorities`
8. `post_incident_reviews_determine_procedures_followed_and_actions_effective`
9. `post_incident_reviews_cover_promptness_of_response_and_impact_determination`
10. `post_incident_reviews_cover_quality_and_speed_of_forensic_analysis`
11. `post_incident_reviews_cover_effectiveness_of_incident_escalation`
12. `post_incident_reviews_cover_effectiveness_of_internal_and_external_communication`
13. `lessons_incorporated_into_ict_risk_assessment_process`
14. `findings_form_basis_for_reviews_of_ict_risk_management_framework`
15. `effectiveness_of_resilience_strategy_implementation_monitored`
16. `evolution_of_ict_risk_mapped_over_time`
17. `frequency_types_magnitude_and_evolution_of_incidents_analysed`
18. `cyber_maturity_and_preparedness_enhanced`
19. `senior_ict_staff_report_findings_and_recommendations_at_least_yearly`
20. `awareness_programmes_and_resilience_training_compulsory_in_staff_training`
21. `programmes_and_training_apply_to_all_staff_at_commensurate_complexity`
22. `ict_third_party_service_providers_included_in_training_where_appropriate`
23. `relevant_technological_developments_monitored_continuously`
24. `kept_up_to_date_with_latest_ict_risk_management_processes`

The values `true` and `false` are atoms, never Python booleans or quoted strings. They are never pinned in verdict_vocabulary or root_exports.

## Citation-key atoms

These use the canonical `_lexicon/citations.yaml` scheme. No shortened atoms are used.

- `eu_reg_2022_2554_art_13_1`
- `eu_reg_2022_2554_art_13_2`
- `eu_reg_2022_2554_art_13_2_a`
- `eu_reg_2022_2554_art_13_2_b`
- `eu_reg_2022_2554_art_13_2_c`
- `eu_reg_2022_2554_art_13_2_d`
- `eu_reg_2022_2554_art_13_3`
- `eu_reg_2022_2554_art_13_4`
- `eu_reg_2022_2554_art_13_5`
- `eu_reg_2022_2554_art_13_6`
- `eu_reg_2022_2554_art_13_7`
- `eu_reg_2022_2554_art_16_1`

THE FIXED CITATIONS are `[cite(eu_reg_2022_2554_art_13_1), ..., cite(eu_reg_2022_2554_art_13_7)]`: the seven paragraph keys.

## Public predicates

### Limb queries

- `ict_risk_learning_and_evolving_duties_required(Profile, Result, Citations)`: which Art 13 duties apply.
  - Result is `required(Duties)`, `simplified_framework_entity` or a status compound.
  - Steps R0, R-G1, R-G2, R1, R2.
  - Reads only the gate and the triggers and never refers.
  - Citation: Art 13(1) to (7), Art 16(1).
- `ict_risk_learning_and_evolving_duties_complete(Profile, Result, Citations)`: whether every applying duty is performed.
  - Result is `complete`, `incomplete`, `simplified_framework_entity` or a status compound.
  - Steps S0 to S4.
  - Citation: THE FIXED CITATIONS; Art 16(1) for the gate.
- `ict_risk_learning_and_evolving_duties_outstanding(Profile, Result, Citations)`: which applying duties are not performed.
  - Result is `none_outstanding`, `outstanding(Duties)`, `simplified_framework_entity` or a status compound.
  - Steps M0 to M3.
  - Citation: the keys of each outstanding duty, or THE FIXED CITATIONS.

### Input check

- `dora_ict_risk_learning_and_evolving_input_problems(Profile, Problems)`: the typed input check (INTERFACE - THE INPUT CHECK).
  - Problems is `[]` for a well-formed profile.
  - Never fails, never raises, exactly one solution.

### Facade (scaffold names kept)

- `decide_dora_ict_risk_learning_and_evolving(Profile, dora_ict_risk_learning_and_evolving_verdict(Status, Citations))`: the package verdict.
  - Delegates to `ict_risk_learning_and_evolving_duties_complete/3`.
  - Status and Citations are exactly that query's Result and Citations.
  - Citation: Art 13(1) to (7), Art 16(1).
- `dora_ict_risk_learning_and_evolving_status(Profile, Status)`: the Status of the decide predicate alone.
  - This is the eligibility-style verdict, query type #2: `complete` corresponds to eligible, `incomplete` to ineligible, and `indeterminate(...)` to indeterminate.
  - Citation: Art 13.
- `dora_ict_risk_learning_and_evolving_checklist(Profile, Checklist)`: the justification checklist, query type #7.
  - One `item(Duty, ItemStatus, cite(CitationKey))` per duty, twenty items in DUTY ORDER, each carrying its duty's own cite.
  - Built with formalize_lib `eval_requirements/4` over the closure `dora_ict_risk_learning_and_evolving_requirement`, called as `requirement(DutyAtom, Profile, Status, Citation)`.
  - A gate-true profile yields every item `inapplicable`, defeated by the Art 16(1) defeater. Each item cites the duty's own citation key; Art 16(1) is cited by the verdict.
  - The checklist is explanatory. The decisive answer is always the limb query.
- `dora_ict_risk_learning_and_evolving_what_if(Profile, Key, Value, Verdict)`: re-decides with Key set to Value.
  - Uses kit `what_if/5`, with the closure `decide_dora_ict_risk_learning_and_evolving` as Decide.
  - Yields one verdict term `dora_ict_risk_learning_and_evolving_verdict(Status, Citations)`.
  - Citation: as decide.
- `dora_ict_risk_learning_and_evolving_compliance_check(Profile, Duty, Verdict)`: query type #13. Is the entity's present position on Duty compliant?
  - `simplified_framework_entity` when the gate is true.
  - `not_applicable` when one of the duty's conditions fails.
  - `compliant` when the duty applies and its key is true.
  - `non_compliant` when the duty applies and its key is false.
  - `indeterminate([Key])` for the first absent key, in root_exports order, among the gate, the duty's condition keys and its own key. A condition key is named only while it is still OPEN.
  - `needs_legal_review(open_textured(Key, cite(C)), [inputs_relied_on(Pairs)])` when the duty applies and its key is unsure.
  - `input_problems(P)` first.
  - Exactly one solution per (Profile, Duty) with Duty bound.
  - Citation: the duty's own key.

### Fixtures

- `dora_ict_risk_learning_and_evolving_fixture(FixtureName, Profile)`: named test profiles.
- `dora_ict_risk_learning_and_evolving_fixture_expected(FixtureName, Query, Result, Citations)`: the expected answer of each limb query for each fixture.
- The fixtures cover:
  - the gate true, absent and false;
  - a microenterprise without an incident;
  - a non-microenterprise with an incident and a request;
  - a false duty with absent keys;
  - unsure referral in both the completeness and outstanding queries;
  - <<DNUM>> behind-key cases;
  - every input-problem class.

## Planned reuse (manifest `uses:`)

- **formalize_lib**:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2` for profile reading;
  - `profile_set/3`;
  - `eval_requirements/4` and `item/3` for the checklist;
  - `not_defeated/3`: the guarded `once/1` defeater for the Art 16(1) gate; the Art 13 rules hold defeasibly unless the gate defeater fires;
  - `not_member/2`, `memberd/2`;
  - the vocabulary atoms `met`, `applicable`, `inapplicable`.

  `check_tri/4` is NOT used for the limb queries, which use their own step ordering. It is used inside the checklist requirement, via `check_tri`, for the met / unmet / unknown mapping of each judgement key. No hand-rolled clone of `check_tri` or `eval_requirements` is written.
- **kit.query_combinators**: `what_if/5` for the facade what-if; `override_key/4` is not needed.
- **validate_props**: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `declare_vacuous/1` (for boundary coverage: no numeric axis), `bad_citation/1`.
- **Not used**:
  - deadline_lib, rolling_window, date_time: no dates (Q16);
  - currency_vocab, vat_category, country: no money or places;
  - kit.compliance_lib is considered and NOT used. Its deny-overrides modality lattice does not express the ordered missing-key-first and referral steps this order requires. The compliance check is local over the slice's duty table.

## Module layout (unchanged)

`kernel -> citations -> parameters -> dora_ict_risk_learning_and_evolving -> queries -> fixtures -> package facade`

- `kernel.clausal`: the shared floor only. It declares the result constructors and holds `key_order/2`, the root_exports position of each of the twenty-four keys, used by the input check and PAIRS ordering. Nothing else is shared: there is one determination slice.
- `citations.clausal`: `citation_key/1` facts for the twelve citation keys, plus the fixed-citation list.
- `parameters.clausal`: no numeric statutory figures. It holds the input-contract typing:
  - `key_type(Key, fact)` for the four fact keys;
  - `key_type(Key, judgement)` for the twenty judgement keys.
- `dora_ict_risk_learning_and_evolving.clausal`: the slice (below).
- `queries.clausal`: the facade predicates, delegating to the slice.
- `fixtures.clausal`: the fixtures.
- Test modes, seven, v2 manifest:
  1. load;
  2. per-rule unit;
  3. limb queries against fixtures;
  4. input check;
  5. properties: totality, determinism, citation completeness, missing-key coverage;
  6. counting: `findall` length 1 for every query on every fixture;
  7. what-if and compliance check.

## Slice: dora_ict_risk_learning_and_evolving.clausal

### Value facts owned by this slice

These live here, not in a shared constants file.

**Duty table: `duty_row(Position, Duty, ProfileKey, CitationKey, Conditions)`.** There are twenty rows in DUTY ORDER. Conditions is a list of `condition(TriggerKey, Value)` terms. In the rows below, `micro` abbreviates `condition(financial_entity_is_microenterprise, false)`, `incident` abbreviates `condition(major_ict_related_incident_disrupted_core_activities, true)` and `request` abbreviates `condition(competent_authority_requested_post_incident_review_changes, true)`. These are notation here only; the code spells the full terms.

1. `threat_and_incident_information_capability`, `capabilities_and_staff_to_gather_and_analyse_threat_and_incident_information`, `eu_reg_2022_2554_art_13_1`, `[]`
2. `post_incident_reviews`, `post_ict_related_incident_reviews_put_in_place`, `eu_reg_2022_2554_art_13_2`, `[incident]`
3. `communication_of_post_incident_changes`, `post_incident_review_changes_communicated_to_competent_authorities`, `eu_reg_2022_2554_art_13_2`, `[micro, incident, request]`
4. `review_of_procedures_and_actions`, `post_incident_reviews_determine_procedures_followed_and_actions_effective`, `eu_reg_2022_2554_art_13_2`, `[incident]`
5. `review_of_response_promptness`, `post_incident_reviews_cover_promptness_of_response_and_impact_determination`, `eu_reg_2022_2554_art_13_2_a`, `[incident]`
6. `review_of_forensic_analysis`, `post_incident_reviews_cover_quality_and_speed_of_forensic_analysis`, `eu_reg_2022_2554_art_13_2_b`, `[incident]`
7. `review_of_incident_escalation`, `post_incident_reviews_cover_effectiveness_of_incident_escalation`, `eu_reg_2022_2554_art_13_2_c`, `[incident]`
8. `review_of_internal_and_external_communication`, `post_incident_reviews_cover_effectiveness_of_internal_and_external_communication`, `eu_reg_2022_2554_art_13_2_d`, `[incident]`
9. `lessons_incorporated_into_ict_risk_assessment`, `lessons_incorporated_into_ict_risk_assessment_process`, `eu_reg_2022_2554_art_13_3`, `[]`
10. `findings_basis_for_framework_reviews`, `findings_form_basis_for_reviews_of_ict_risk_management_framework`, `eu_reg_2022_2554_art_13_3`, `[]`
11. `monitoring_of_resilience_strategy_effectiveness`, `effectiveness_of_resilience_strategy_implementation_monitored`, `eu_reg_2022_2554_art_13_4`, `[]`
12. `mapping_of_ict_risk_evolution`, `evolution_of_ict_risk_mapped_over_time`, `eu_reg_2022_2554_art_13_4`, `[]`
13. `analysis_of_ict_related_incidents`, `frequency_types_magnitude_and_evolution_of_incidents_analysed`, `eu_reg_2022_2554_art_13_4`, `[]`
14. `enhancement_of_cyber_maturity`, `cyber_maturity_and_preparedness_enhanced`, `eu_reg_2022_2554_art_13_4`, `[]`
15. `yearly_report_to_management_body`, `senior_ict_staff_report_findings_and_recommendations_at_least_yearly`, `eu_reg_2022_2554_art_13_5`, `[]`
16. `compulsory_awareness_and_training_modules`, `awareness_programmes_and_resilience_training_compulsory_in_staff_training`, `eu_reg_2022_2554_art_13_6`, `[]`
17. `training_for_all_staff_commensurate_to_remit`, `programmes_and_training_apply_to_all_staff_at_commensurate_complexity`, `eu_reg_2022_2554_art_13_6`, `[]`
18. `third_party_providers_in_training`, `ict_third_party_service_providers_included_in_training_where_appropriate`, `eu_reg_2022_2554_art_13_6`, `[]`
19. `monitoring_of_technological_developments`, `relevant_technological_developments_monitored_continuously`, `eu_reg_2022_2554_art_13_7`, `[micro]`
20. `up_to_date_ict_risk_management_processes`, `kept_up_to_date_with_latest_ict_risk_management_processes`, `eu_reg_2022_2554_art_13_7`, `[micro]`

**Other value facts:**

- `duty_paragraph(Duty, ParagraphCitationKey)`: points (a) to (d) map to `eu_reg_2022_2554_art_13_2`; every other duty maps to its own citation key. Used for the citations of `required`.
- `referral_citation(JudgementKey, CitationKey)`: equal to the duty row's CitationKey.
- `gate_key(financial_entity_is_article_16_1_entity)`, `gate_citation(eu_reg_2022_2554_art_16_1)`.
- `trigger(Key)` for the three triggers.

### Rules and requirements

Each helper has mutually exclusive clauses and no cut.

**Key state:** `key_state(Profile, Key, State)` with State one of `absent`, `value(true)`, `value(false)`, `value(unsure)`. Called only after the input check passes, so no duplicates exist and values are typed.

**Condition and duty states:**

- `condition_state(Profile, condition(Key, Want), holds|fails|open)`.
- `duty_open(Profile, Duty)`: no condition fails.
- `duty_applies(Profile, Duty)`: every condition holds, AND `not_defeated(Duty, Profile, article_16_1_defeater)`.
- `article_16_1_defeater(Duty, Profile)`: guarded `once/1` over `profile_get(Profile, financial_entity_is_article_16_1_entity, true)`. This is the defeasible-logic idiom.
- `duty_fails(Profile, Duty)`: the duty applies and its key is `value(false)`.
- 'Not true' means `value(false)`, `value(unsure)` or `absent`.

**PAIRS:** `inputs_relied_on_pairs(Profile, Pairs)` lists every present Key-Value pair, in `key_order/2` order, with values exactly as given.

**Input check** (`dora_ict_risk_learning_and_evolving_input_problems/2`):

- A non-list, partial list or unbound profile, or any element that is not a bound `attribute(_, _)`, gives `[wrong_type(profile)]`.
- Otherwise, for each contract key in key order:
  - `duplicate_key(K)` if it occurs at least twice, comparing with `==` and never reading values;
  - else `wrong_type(K)` if its single value is unbound or outside its type (facts: `true` or `false`; judgements: `true`, `false` or `unsure`).
- Then `unknown_key(K)` for each non-contract key, compared with `==`, in first-occurrence order and once each, keeping unbound-variable and non-atom keys as given.
- Implemented with `findall` and `==`-based membership, so there is no unification of keys.

**Query `..._duties_required` (R0 to R2):**

- R0: problems exist.
- R-G1: the gate is true.
- R-G2: the gate is absent.
- R1: the first trigger, in key order, that is absent and is a condition key of some open duty.
- R2: `required(Duties)`. Duties is `findall` over the duty rows of applying duties, in position order. Citations are the distinct `duty_paragraph` keys of Duties, with Art 13(1), (3), (4), (5) and (6) always.

**Query `..._duties_complete` (S0 to S4):**

- S0, S-G1 and S-G2 as for the required query.
- S1: some duty fails. Result `incomplete`, with THE FIXED CITATIONS.
- S2: compute the candidate list.
  - Candidates are the absent keys, in key order, that CAN STILL CHANGE THE ANSWER by rule (a) (the key of an open duty D, and no other false-keyed duty whose conditions each hold or are among D's conditions) or rule (b) (a trigger X with a value V, an open duty D with condition X V and a not-true key, and no other false-keyed duty without the condition X V whose non-X conditions each hold or are among D's conditions).
  - For each candidate, record its THROUGH-duties and whether it DECIDES ALONE: it is the key of an applying duty, or it is a trigger whose value V completes, together with holding conditions, a false-keyed duty.
  - X is BEHIND Y when either:
    - (i) Y decides alone and X does not; or
    - (ii) neither decides alone, Y is the key or a condition key of every THROUGH-duty of X, and Y has a THROUGH-duty of which X is neither the key nor a condition key.
  - Name the first candidate that is not behind any other candidate: `indeterminate([Key])`.
- S3: the first unsure judgement key, in key order, satisfying rule (a) with unsure in place of absent. Result `needs_legal_review(open_textured(Key, cite(C)), [inputs_relied_on(Pairs)])`.
- S4: `complete`, with THE FIXED CITATIONS.

**Query `..._duties_outstanding` (M0 to M3):**

- M0, M-G1 and M-G2 as above.
- M1: compute the candidates.
  - A candidate is an absent key of an open duty, through that duty; or an absent trigger that is a condition key of an open duty with a not-true key, through each such duty.
  - A key CHANGES THE LIST ALONE when it is the key of an applying duty, or it is a trigger condition key of an open, not-true duty whose other conditions all hold.
  - X is BEHIND Y when Y changes the list alone, X does not, and Y is the key or a condition key of every THROUGH-duty of X.
  - Name the first candidate, in key order, not behind another.
- M2: the first unsure key, in key order, of an open duty. Result `needs_legal_review`, as in S3.
- M3: Outstanding is `findall` over failing duties, in position order.
  - `[]` gives `none_outstanding`, with THE FIXED CITATIONS.
  - Otherwise `outstanding(Outstanding)`, with the distinct citation keys of those duties.

**Single-solution discipline.** Each step is one clause whose guard is the negation of every earlier step, via `\+` on the earlier step's condition goal. Selections of the form 'first X' are computed as `findall(...)` followed by unification with `[First|_]`. Guards are mutually exclusive, so every call yields exactly one solution, and the counting tests assert `length(Solutions, 1)`.

**Checklist requirement.** `dora_ict_risk_learning_and_evolving_requirement(Duty, Profile, Status, cite(CitationKey))` has three or four exclusive clauses:

- `inapplicable`: the gate is true or a condition fails;
- `met`: the duty applies and its key is true;
- `unmet(not_performed)`: the duty applies and its key is false;
- `unknown([Key])`: the first absent or unsure key among the gate, the open condition keys and the duty key.

### Verdict atoms of this slice

`required/1`, `complete`, `incomplete`, `none_outstanding`, `outstanding/1`, `simplified_framework_entity`, `indeterminate/1`, `needs_legal_review/2` (with `open_textured/2` and `inputs_relied_on/1`), `input_problems/1`.

Facade only: `compliant`, `non_compliant`, `not_applicable`, `met`, `unmet/1`, `unknown/1`, `inapplicable`.

### Predicates shared with another slice

NONE: this is the only determination slice. `kernel.clausal` keeps only:

- the result-constructor declarations;
- `key_order/2`, the root_exports positions, which both the input check and the PAIRS builder read.

The facade in `queries.clausal` imports the slice's public predicates. It does not re-implement them.
