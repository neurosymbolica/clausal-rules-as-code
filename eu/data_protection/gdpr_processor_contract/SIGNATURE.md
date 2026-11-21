# SIGNATURE — eu/data_protection/gdpr_processor_contract

## Public query surface

`decide_processor_contract(Profile, processor_contract_verdict(Status, Missing, Citations))` gives the whole verdict. `processor_contract_status(Profile, Status)` gives the STATUS field.

Profile is an attribute list `[attribute(Key, Value), ...]` read only with `profile_get/3`, by presence first, then by value. It has exactly 32 keys, all root-exported.

Every query is TOTAL: it gives exactly one solution for every profile, malformed profiles included, through `input_problems`. It is DETERMINISTIC: one solution, never one distinct answer yielded twice.

There are no imported figures. Art 28 states no number or date (reading 12), and `parameters.clausal` declares no constant.

## Verdict STATUS atoms (replace scaffold placeholders `required` / `permitted` / `not_applicable`)

| Status | Missing | Citations |
|---|---|---|
| `eligible` (bare) | `[]` | distinct `cite(C)` of every checklist limb read, in order of first appearance in key order; never the R1 or R2 citation |
| `ineligible` (bare) | keys of the UNMET limbs, key order | parallel `cite(C)`, duplicates kept |
| `not_applicable` (bare; new, open question Q5) | `[]` | `[cite(eu_reg_2016_679_art_4_8)]` |
| `indeterminate(MissingKeys)` | `[]` | `[]` |
| `needs_legal_review(Reason, Context)` | `[]` | `[]` |
| `input_problems(Problems)` | `[]` | `[]` |

- The bare atom `indeterminate` is never written.
- Reason is one of:
  - `open_textured(Key, cite(Citation))`
  - `deferred_provision(cite(eu_reg_2016_679_art_28_10))`
- Context is `[inputs_relied_on(Pairs)]`. No provenance item is emitted.

## Canonical key order (root_exports, alphabetical) — `gdpr_processor_contract_key_order/1` in kernel

This order governs Missing, Citations, MissingKeys, Items, Pairs and the first unsure judgement.

1. contract_binding_on_processor
2. contract_governed_by_union_or_member_state_law
3. contract_in_writing
4. contract_sets_out_categories_of_data_subjects
5. contract_sets_out_controller_obligations_and_rights
6. contract_sets_out_duration
7. contract_sets_out_nature_of_processing
8. contract_sets_out_purpose_of_processing
9. contract_sets_out_subject_matter
10. contract_sets_out_type_of_personal_data
11. controller_given_opportunity_to_object
12. processing_on_behalf_of_controller
13. processor_determines_purposes_and_means
14. processor_informed_controller_of_intended_changes
15. processor_provides_sufficient_guarantees
16. standard_clauses_adopted
17. stipulates_assistance_with_articles_32_to_36_obligations
18. stipulates_assistance_with_data_subject_requests
19. stipulates_conditions_for_engaging_another_processor
20. stipulates_confidentiality_commitment
21. stipulates_deletion_or_return_of_personal_data
22. stipulates_information_and_audit_rights
23. stipulates_notice_of_infringing_instruction
24. stipulates_processing_only_on_documented_instructions
25. stipulates_security_measures
26. subprocessor_authorisation
27. subprocessor_authorisation_given_before_engagement
28. subprocessor_contract_governed_by_union_or_member_state_law
29. subprocessor_contract_in_writing
30. subprocessor_engaged
31. subprocessor_obligations_same
32. subprocessor_provides_sufficient_guarantees

## Contract key order (input_contract, used for Problems) — `gdpr_processor_contract_contract_key_order/1` in kernel

The order is:

1. The 8 judgements: processing_on_behalf_of_controller, processor_determines_purposes_and_means, processor_provides_sufficient_guarantees, contract_binding_on_processor, subprocessor_obligations_same, subprocessor_provides_sufficient_guarantees, contract_governed_by_union_or_member_state_law, subprocessor_contract_governed_by_union_or_member_state_law.
2. The 22 crisp keys, in this order: contract_in_writing, the seven contract_sets_out_* (subject_matter, duration, nature_of_processing, purpose_of_processing, type_of_personal_data, categories_of_data_subjects, controller_obligations_and_rights), the stipulates_* keys for points (a) to (h) and then the second subparagraph, subprocessor_engaged, subprocessor_authorisation_given_before_engagement, processor_informed_controller_of_intended_changes, controller_given_opportunity_to_object, subprocessor_contract_in_writing.
3. subprocessor_authorisation.
4. standard_clauses_adopted.

## Profile keys

There are no numeric keys and no dates. Booleans are the atoms `true` and `false`.

| Key | Type | Read when | Cite |
|---|---|---|---|
| processing_on_behalf_of_controller | judgement (true/false/unsure) | always, gate R1 | eu_reg_2016_679_art_4_8 |
| processor_determines_purposes_and_means | judgement | R1 true, gate R2 | eu_reg_2016_679_art_28_10 |
| processor_provides_sufficient_guarantees | judgement | checklist | eu_reg_2016_679_art_28_1 |
| contract_binding_on_processor | judgement | checklist | eu_reg_2016_679_art_28_3 |
| contract_governed_by_union_or_member_state_law | judgement | checklist | eu_reg_2016_679_art_28_3 |
| contract_in_writing | crisp | checklist | eu_reg_2016_679_art_28_9 |
| contract_sets_out_subject_matter / _duration / _nature_of_processing / _purpose_of_processing / _type_of_personal_data / _categories_of_data_subjects / _controller_obligations_and_rights | crisp | checklist | eu_reg_2016_679_art_28_3 |
| stipulates_processing_only_on_documented_instructions | crisp | checklist | eu_reg_2016_679_art_28_3_a |
| stipulates_confidentiality_commitment | crisp | checklist | eu_reg_2016_679_art_28_3_b |
| stipulates_security_measures | crisp | checklist | eu_reg_2016_679_art_28_3_c |
| stipulates_conditions_for_engaging_another_processor | crisp | checklist | eu_reg_2016_679_art_28_3_d |
| stipulates_assistance_with_data_subject_requests | crisp | checklist | eu_reg_2016_679_art_28_3_e |
| stipulates_assistance_with_articles_32_to_36_obligations | crisp | checklist | eu_reg_2016_679_art_28_3_f |
| stipulates_deletion_or_return_of_personal_data | crisp | checklist | eu_reg_2016_679_art_28_3_g |
| stipulates_information_and_audit_rights | crisp | checklist | eu_reg_2016_679_art_28_3_h |
| stipulates_notice_of_infringing_instruction | crisp | checklist | eu_reg_2016_679_art_28_3_second_subpara |
| subprocessor_engaged | crisp; true or false both MET | checklist | eu_reg_2016_679_art_28_2 |
| subprocessor_authorisation | enumerated: specific_written, general_written, none (UNMET) | subprocessor_engaged true | eu_reg_2016_679_art_28_2 |
| subprocessor_authorisation_given_before_engagement | crisp | authorisation specific_written or general_written | eu_reg_2016_679_art_28_2 |
| processor_informed_controller_of_intended_changes | crisp | authorisation general_written | eu_reg_2016_679_art_28_2 |
| controller_given_opportunity_to_object | crisp | authorisation general_written | eu_reg_2016_679_art_28_2 |
| subprocessor_obligations_same | judgement | subprocessor_engaged true | eu_reg_2016_679_art_28_4 |
| subprocessor_provides_sufficient_guarantees | judgement | subprocessor_engaged true | eu_reg_2016_679_art_28_4 |
| subprocessor_contract_in_writing | crisp | subprocessor_engaged true | eu_reg_2016_679_art_28_9 |
| subprocessor_contract_governed_by_union_or_member_state_law | judgement | subprocessor_engaged true | eu_reg_2016_679_art_28_4 |
| standard_clauses_adopted | outside fact: `attested(true or false, attestation(By, At, Reason, Evidence))` | never for status; recorded only | eu_reg_2016_679_art_28_7 (with art_28_6, art_28_8) |

## Citation-key atoms (citations.clausal)

These atoms are emitted in answers:

- eu_reg_2016_679_art_4_8
- eu_reg_2016_679_art_28_1
- eu_reg_2016_679_art_28_2
- eu_reg_2016_679_art_28_3
- eu_reg_2016_679_art_28_3_a, _b, _c, _d, _e, _f, _g, _h
- eu_reg_2016_679_art_28_3_second_subpara
- eu_reg_2016_679_art_28_4
- eu_reg_2016_679_art_28_9
- eu_reg_2016_679_art_28_10

These atoms are declared for traceability of the outside fact and the deferred set, and are NEVER emitted:

- eu_reg_2016_679_art_4_1
- eu_reg_2016_679_art_4_2
- eu_reg_2016_679_art_4_7
- eu_reg_2016_679_art_28_5
- eu_reg_2016_679_art_28_6
- eu_reg_2016_679_art_28_7
- eu_reg_2016_679_art_28_8
- eu_reg_2016_679_art_29

Each atom is a `citation(Atom, Unit, Text)` fact carrying the unit id and the pinned verbatim text.

The atoms are mandated by the interface and must not be shortened. The segments `reg`, `art` and `subpara` carry a `% lint: C6 mandated citation atom` pragma.

## Public predicates

**Order relations (queries.clausal, re-exported by the facade):**

- `decide_processor_contract(Profile, Verdict)`: the whole verdict `processor_contract_verdict(Status, Missing, Citations)`. This is the query type #13 compliance check: may the controller use this processor under this arrangement. Cites Art 28(1), (2), (3), (4), (9), (10) and Art 4(8).
- `processor_contract_status(Profile, Status)`: the Status field, query type #3. Cites the same articles.
- `contract_missing_stipulations(Profile, Missing)`: the Missing field. It is `[]` unless the status is ineligible, and `[]` with input problems. Cites Art 28(3)(a) to (h), Art 28(3) second subparagraph, and Art 28(1), (2), (4), (9).
- `contract_checklist(Profile, Items)`: the checklist stage alone, independent of the gates. Query type #7 justification.
  - Items is a list of `checklist_item(Key, cite(Citation), State)` in key order.
  - State is one of `met`, `unmet`, `open_by_absence`, `open_by_judgement`.
  - Items is `[]` with input problems.
  - Cites Art 28(1), (2), (3), (4), (9).
- `processor_contract_outside_facts(Profile, OutsideFacts)`: the outside fact.
  - When the key is present: `[outside_fact(standard_clauses_adopted, Attested)]`, with the attested term as given.
  - When the key is absent: `[outside_fact(standard_clauses_adopted, absent)]`.
  - With input problems: `input_problems(Problems)`.
  - Cites Art 28(6), (7), (8).
- `gdpr_processor_contract_input_problems(Profile, Problems)`: the input check. It gives:
  - `[]` for a well-formed profile;
  - `[wrong_type(profile)]` for a non-attribute list;
  - otherwise, per contract key in contract key order, `duplicate_key(Key)` or else `wrong_type(Key)`, then `unknown_key(Key)` in order of first occurrence.
  - No citation (INPUT CONTRACT).

**Facade names (kept from the scaffold; package facade):**

- `decide_processor_contract_status(Profile, Verdict)`: delegates to `decide_processor_contract/2`. Cites Art 28 and Art 4(8).
- `processor_contract_status_status(Profile, Status)`: delegates to `processor_contract_status/2`. Same citations.
- `processor_contract_status_checklist(Profile, Items)`: delegates to `contract_checklist/2`. Cites Art 28(1), (2), (3), (4), (9).
- `gdpr_processor_contract_what_if(Profile, Key, Value, Verdict)`: the verdict after replacing (not appending) `attribute(Key, _)`.
  - It calls `what_if(Profile, Key, Value, decide_processor_contract_status, Verdict)` from kit/query_combinators.
  - If that combinator cannot handle attribute lists, the replacement is done with `profile_set/3`.
  - Appending would create a `duplicate_key` input problem.
  - Citations are those of the verdict.
- `gdpr_processor_contract_fixture(FixtureName, Profile)` and `gdpr_processor_contract_fixture_expected(FixtureName, Verdict)` (fixtures.clausal): named profiles with their expected verdicts. They have no citation of their own.

**Result constructors (exported, never queried):**

processor_contract_verdict/3, checklist_item/3, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, indeterminate/1, needs_legal_review/2, open_textured/2, deferred_provision/1, inputs_relied_on/1, provenance/2, outside_fact/2, attested/2, attestation/4, url/2, document/2.

The atom `not_attempted` is root-exported and returned by no query.

## Planned reuse (manifest `uses:`)

**formalize_lib:**

- `profile_get/3`: the only profile reader.
- `profile_has/2` and `profile_lacks/2`: presence first.
- `profile_keys/2`: input check, duplicates and unknowns.
- `profile_set/3`: what-if replacement.
- `not_defeated/3`: the defeasible gates.
- `memberd/2` and `not_member/2`: deterministic membership over ground lists.
- `attribute/2`: the profile entry constructor.

`check_tri/4` and `assess/6` are NOT used.

- `check_tri/4` merges unsure with absent. This order needs `open_by_judgement` distinct from `open_by_absence` and four states.
- `assess/6` and `eval_requirements/4` produce `item/3` and a three-label decision. This order needs `checklist_item/3`, a referral status, and conditional limbs.

If lint C15 or R1 fires on the local evaluators, a `% lint:` pragma points to the NOTES reuse note.

**kit/query_combinators:** `what_if/5`, for `gdpr_processor_contract_what_if/4`.

**validate_props (tests only):**

- `run_props/1`
- `prop_totality/3`
- `prop_determinism/3`
- `prop_citation_complete/3`
- `prop_missing_key_coverage/3`

These modules are NOT used:

- `kit/compliance_lib`: there are no competing norm modalities to resolve, and the checklist verdict is the compliance answer.
- deadline, rolling_window and date_time: there are no dates and no numbers.
- currency, vat and country: their vocabularies are not relevant.

## kernel.clausal (shared floor; only what the slice AND queries/facade both need)

- `gdpr_processor_contract_key_order(KeyOrder)`: the ground list of 32 keys in root_exports order.
- `gdpr_processor_contract_contract_key_order(ContractKeyOrder)`: the ground list in input_contract order.
- `gdpr_processor_contract_key_type(Key, Type)`: Type is one of `judgement`, `crisp`, `authorisation_kind`, `outside_fact`. 32 facts.
- `gdpr_processor_contract_input_problems(Profile, Problems)`: the input check. It lives in the kernel because queries.clausal uses it to answer `processor_contract_outside_facts/2` and `contract_checklist/2` with input problems. The type tests are guarded by `atom/1` (or a compound-shape test for the outside fact) so a variable never unifies.
- `gdpr_processor_contract_well_formed(Profile)`: succeeds once when Problems is `[]`. Used as the first defeater guard.

## Slice: processor_contract_status.clausal

This slice is self-contained. It owns the role gates, the checklist, and the verdict assembly.

### Value facts it owns

There are no thresholds, periods or tables (reading 12). The slice owns these ground facts:

- `limb_citation(Key, Citation)`: one row per checklist limb, 26 rows, mapping each key to its citation atom as in the profile table.
- `role_gate(processing_on_behalf_of_controller, eu_reg_2016_679_art_4_8)` and `role_gate(processor_determines_purposes_and_means, eu_reg_2016_679_art_28_10)`.
- `authorisation_kind(specific_written)`, `authorisation_kind(general_written)`, `authorisation_kind(none)`.
- `authorisation_given(specific_written)` and `authorisation_given(general_written)`.

### Rules

1. **Limb state** (`limb_state(Profile, Key, State)`, four mutually exclusive clauses, cut-free). For a crisp key, true is `met` and false is `unmet`. For a judgement, true is `met`, false is `unmet` and unsure is `open_by_judgement`. An absent key is `open_by_absence`. Two keys have their own rules:
   - `subprocessor_engaged`: true or false is `met`.
   - `subprocessor_authorisation`: `none` is `unmet`; `specific_written` or `general_written` is `met`.
2. **Limbs read** (`checklist_keys_read(Profile, Keys)`). Built by structural recursion over the key order, keeping a key when `limb_read(Profile, Key)` holds:
   - all non-sub-processor checklist keys;
   - `subprocessor_engaged`;
   - when it is true: `subprocessor_authorisation`, the obligations-same and guarantees limbs, the writing limb and the governing-law limb;
   - when the authorisation is given: the before-engagement limb;
   - when the authorisation is `general_written`: the changes-notice and opportunity-to-object limbs.
   R1 and R2 and `standard_clauses_adopted` are never checklist limbs.
3. **Checklist** (`checklist_items(Profile, Items)`): maps the keys read to `checklist_item(Key, cite(Citation), State)`.
4. **Checklist outcome** (`checklist_outcome(Items, Outcome)`), one head-folded clause per disjoint route:
   - any `unmet` gives `unmet_limbs(Missing, Citations)`;
   - else any `open_by_absence` gives `absent_keys(MissingKeys)`;
   - else any `open_by_judgement` gives `first_unsure(Key, Citation)`;
   - else `all_met(DistinctCitations)`.
5. **Pairs** (`relied_pairs(Profile, StageKeys, Pairs)`): the Key-Value pairs of the present judgement keys read by the stages up to the ending one, plus `standard_clauses_adopted-absent` when that key is absent, merged in key order by walking the key order list.
6. **Status routes** (`processor_contract_status/2` core). Each route has its ground status folded in the head, and the routes are disjoint. The checklist route is the defeasible default; the R1 or R2 ending and input problems are defeaters, each tested by `not_defeated/3` with a guarded `once/1`.

| Route | Condition | Status |
|---|---|---|
| A | Problems non-empty | `input_problems(Problems)` |
| B | R1 false | `not_applicable` |
| C | R1 absent | `indeterminate([processing_on_behalf_of_controller])` |
| D | R1 unsure | `needs_legal_review(open_textured(processing_on_behalf_of_controller, cite(eu_reg_2016_679_art_4_8)), [inputs_relied_on(Pairs)])`, Pairs from R1 only |
| E | R1 true, R2 true | `needs_legal_review(deferred_provision(cite(eu_reg_2016_679_art_28_10)), Context)` |
| F | R1 true, R2 absent | `indeterminate([processor_determines_purposes_and_means])` |
| G | R1 true, R2 unsure | `needs_legal_review(open_textured(processor_determines_purposes_and_means, cite(eu_reg_2016_679_art_28_10)), Context)` |
| H | R1 true, R2 false | checklist outcome: `ineligible`, `indeterminate(MissingKeys)`, `needs_legal_review(open_textured(Key, cite(Citation)), Context)` or `eligible` |

7. **Verdict assembly** (`decide_processor_contract/2`):
   - Missing and Citations as in the status table.
   - `contract_missing_stipulations/2` projects Missing.

### Verdict atoms

`eligible`, `ineligible`, `not_applicable`, `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`.

### Shared with another slice

There is no other slice. Only the key orders, the key types and the input check are shared with queries and the facade, so only they live in the kernel.

### Per-rule tests (tests/), each route covered positive and negative

- The tests check that each route gives exactly one solution, using `findall` and `length(Verdicts, 1)`.
- Every limb has a fixture where it alone is false, giving ineligible, Missing `[Key]` and Citations `[cite(Citation)]`.
- Every key read is absent in some fixture, giving indeterminate list-all.
- Every judgement is unsure in some fixture, giving `open_textured` for the first unsure key in key order.
- R1 and R2 each have false, absent and unsure fixtures, plus R2 true.
- Unread keys are flipped and must leave the verdict unchanged. This covers the sub-processor keys when `subprocessor_engaged` is false, the changes keys under `specific_written`, and `standard_clauses_adopted` present or absent.
- An unmet limb with another key absent must give ineligible.
- The input problems covered are:
  - wrong_type: unsure in a crisp key, a variable value, a bad authorisation atom, a malformed attested term;
  - unknown_key once per repeated unknown;
  - duplicate_key with no wrong_type;
  - a non-list profile giving `[wrong_type(profile)]`.
- Eligible Citations are checked for one fixture without sub-processors and one with `general_written`.

The fixtures are named after the route: `fixture_eligible_no_subprocessor`, `fixture_eligible_general_written`, `fixture_not_applicable`, `fixture_role_controller_deferred`, `fixture_role_unsure`, `fixture_missing_point_h`, `fixture_partial_point_a_recorded_false`, `fixture_third_country_law`, `fixture_authorisation_none`, `fixture_absent_list_all`, `fixture_checklist_unsure_binding`, `fixture_input_problems_mixed`.
