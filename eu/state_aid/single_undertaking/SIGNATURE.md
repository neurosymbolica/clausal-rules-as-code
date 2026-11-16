# SIGNATURE — eu/state_aid/single_undertaking

This is the authoring plan for later phases. The package layout is kept unchanged:

`kernel -> citations -> parameters -> single_undertaking -> queries -> fixtures -> package facade`

The manifest is v2 with seven test modes. The file names and module names are those of the scaffold. The only determination slice is `single_undertaking.clausal`.

## 1. Public query surface (summary)

The facade `decide_single_undertaking(PROFILE, single_undertaking_verdict(STATUS, CITATIONS))` delegates to `same_single_undertaking/3`. STATUS is the RESULT of that query, as one of:

- a settled atom;
- a status compound ITSELF.

`single_undertaking_status(PROFILE, STATUS)` (query type #3, status_determination) projects STATUS from the facade.

`single_undertaking_checklist(PROFILE, CHECKLIST)` (query type #7, justification) returns the per-requirement checklist of the direct-relationship determination. Every item is `item(Id, Status, cite(Key))`, met items included.

Every query is total and deterministic:

- exactly ONE solution for every ground or non-ground profile;
- no cut, `->` or `*->`;
- ground verdicts folded into clause heads, one clause per disjoint route.

No figure is imported from another domain. The single statutory figure is the majority denominator 2. It is declared in the slice.

## 2. Verdict STATUS atoms (replace placeholder `{ required, permitted, not_applicable }`)

Settled atoms, by query:

- `direct_relationship/3`: `directly_related` and `not_directly_related`.
- `same_single_undertaking/3`, and so the facade STATUS: `single_undertaking` and `not_single_undertaking`.
- `single_undertaking_members/4`: `members_settled`.

Not-final status compounds, written in the RESULT position itself:

- `input_problems(PROBLEMS)`, where PROBLEMS is a list of the following terms:
  - `unknown_key(KEY)`
  - `wrong_type(KEY)`
  - `duplicate_key(KEY)`
- `indeterminate([KEY])`. The list always holds ONE key. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(KEY, cite(CITE)), [inputs_relied_on(PAIRS)])`. An optional trailing `provenance(CLAUSE, CITATIONS)` may follow, and it is unscored.

Constructors are exported as result constructors and are never called as queries:

- `indeterminate/1`
- `needs_legal_review/2`
- `open_textured/2`
- `inputs_relied_on/1`
- `provenance/2`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`
- `relationship/4`

Checklist labels for `assess/6` are `labels(directly_related, relationship_undetermined, not_directly_related)`. These are internal to the checklist and never a RESULT.

## 3. Profile keys (twelve, in root_exports / input_contract order)

PROFILE is `[attribute(KEY, VALUE), ...]`. It is read ONLY with `profile_get/3`, by presence first and then by value. Keys are bare atoms.

| # | Key | Type | Notes |
|---|---|---|---|
| 1 | `holder_is_an_enterprise` | judgement `true`/`false`/`unsure` | reading (3) |
| 2 | `held_is_an_enterprise` | judgement | reading (3) |
| 3 | `voting_rights_held` | non-negative integer (whole voting rights) | added check: not greater than total |
| 4 | `voting_rights_total` | non-negative integer (whole voting rights) | added check: at least 1 |
| 5 | `right_to_appoint_or_remove_majority_of_board` | boolean | point (b) |
| 6 | `dominant_influence_by_contract_or_articles` | judgement | point (c) |
| 7 | `holder_is_shareholder_or_member` | boolean | point (d), condition 1 |
| 8 | `controls_majority_of_voting_rights_alone_by_agreement` | boolean | point (d), condition 2 |
| 9 | `first_enterprise` | atom | |
| 10 | `second_enterprise` | atom | read by `same_single_undertaking` only |
| 11 | `relationships` | proper list of `relationship(HOLDER, HELD, LIMB, CERTAINTY)` | LIMB is one of `point_a`, `point_b`, `point_c`, `point_d`; CERTAINTY is `true` or `unsure` |
| 12 | `relationships_complete` | boolean | `false` is treated like absent (reading (10)) |

Units: the numeric keys are integer COUNTS of voting rights, so the unit is the voting right itself. Their names are fixed by the non-negotiable interface and are not suffixed. The domain has no money and no dates.

## 4. Citation-key atoms (canonical lexicon, `_lexicon/citations.yaml`; never shortened)

- `eu_reg_2023_2831_art_2_2`: Art 2(2), lead-in.
- `eu_reg_2023_2831_art_2_2_a`: Art 2(2)(a).
- `eu_reg_2023_2831_art_2_2_b`: Art 2(2)(b).
- `eu_reg_2023_2831_art_2_2_c`: Art 2(2)(c).
- `eu_reg_2023_2831_art_2_2_d`: Art 2(2)(d).
- `eu_reg_2023_2831_art_2_t1`: Art 2(2), closing sentence.

`citations.clausal` holds these six as `citation_vocabulary` facts with their unit ids (`32023R2831#art2_p2`, `#art2_p2_a` to `#art2_p2_d`, `#art2_t1`) and the pinned sha256. Limb-to-key map, a slice fact: `limb_citation(point_a, eu_reg_2023_2831_art_2_2_a)`, and likewise for points b, c and d.

## 5. Public predicates (one line each)

- `single_undertaking_input_problems(Profile, Problems)`: THE INPUT CHECK.
  - Returns a BARE list.
  - Problems come in contract key order: `duplicate_key` else `wrong_type` per key, then `unknown_key` in first-occurrence order.
  - A non-attribute-list profile gives `[wrong_type(profile)]`.
  - Never fails or raises; exactly one solution.
  - Applies the two added integer checks.
  - Citation: input contract, no legal citation.
- `direct_relationship(Profile, Result, Citations)`: steps 0 to 5. Classifies points (a) to (d) as HOLDS, FAILS or OPEN, then returns:
  - `not_directly_related` on a false enterprise judgement;
  - `directly_related`, citing Art 2(2) plus each holding point;
  - `not_directly_related` when all points fail;
  - `indeterminate([Key])`, with the key chosen per the status rule/the first-missing-key rule;
  - `needs_legal_review`.

  Citations: `eu_reg_2023_2831_art_2_2` and `_a` to `_d`.
- `same_single_undertaking(Profile, Result, Citations)`: steps 0 and 6 to 12, reading keys 9 to 12. In order:
  1. missing names;
  2. same enterprise;
  3. missing relationships;
  4. reached in THE GROUP, giving `single_undertaking` with group limb citations plus `_t1` unless directly joined by a true relationship;
  5. completeness;
  6. an unsure-only chain, giving `needs_legal_review(open_textured(relationships, cite(eu_reg_2023_2831_art_2_2)), ...)`;
  7. otherwise `not_single_undertaking`, citing Art 2(2).
- `single_undertaking_members(Profile, Result, Members, Citations)`: steps 0 and 13 to 17, reading keys 9, 11 and 12. Returns `members_settled` with Members as THE GROUP, sorted by standard order and unique. Citations are Art 2(2), plus group limbs, plus `_t1` when some member is not directly joined. In every not-final case Members is `[]`.
- `decide_single_undertaking(Profile, single_undertaking_verdict(Status, Citations))`: package facade. Equals `same_single_undertaking(Profile, Status, Citations)`.
- `single_undertaking_status(Profile, Status)`: query type #3. Status is the Status of the facade verdict.
- `single_undertaking_checklist(Profile, Checklist)`: query type #7. Built with `eval_requirements/4` over the requirement ids `[holder_enterprise, held_enterprise, majority_of_voting_rights, appoint_or_remove_board_majority, dominant_influence, sole_control_by_agreement]`, using closure `single_undertaking_requirement`. Each item is `item(Id, met | unmet(Reason) | unknown([Keys]), cite(Key))`. Item citations are:
  - `eu_reg_2023_2831_art_2_2` for the two enterprise items;
  - `_a`, `_b`, `_c` and `_d` respectively for the four point items.
- `single_undertaking_what_if(Profile, Key, Value, Verdict)`: re-decides the facade with `attribute(Key, Value)` put in place of any existing entry, using `profile_set/3` so that no duplicate key is created. Verdict is `single_undertaking_verdict(Status, Citations)`.
- Fixtures (`fixtures.clausal`): `single_undertaking_fixture(Name, Profile)` and `single_undertaking_fixture_expected(Name, Query, Result, Citations)`. Named cases cover every limb:
  - parent and subsidiary at 51 of 100;
  - exactly 50 of 100, not a majority;
  - held 0;
  - board right;
  - unsure dominant influence;
  - point (d) with one condition false;
  - sisters through a common holder;
  - two holders of one enterprise;
  - unsure-only chain;
  - complete list giving `not_single_undertaking`;
  - `relationships_complete` false;
  - same enterprise;
  - each input problem;
  - unbound profile;
  - non-atom key;
  - duplicate key.

## 6. Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`;
  - `memberd/2`, `not_member/2`;
  - `check_tri/4`, for the three judgement keys in the checklist;
  - `check_true/4`, for the boolean points;
  - `eval_requirements/4` and `assess/6`, the checklist engine, with `item/3`, `unmet/1`, `unknown/1`, `attribute/2` and `labels/3`;
  - `int_max/3`, not needed; NOT imported.

  `ratio_bps/4` is deliberately NOT used. A majority is an exact strict comparison `2 x held > total`, not a basis-point ratio. The comparison uses `constant(majority_denominator)`.
- `validate_props`:
  - `run_props/1`, `prop_totality/3`, `prop_determinism/3`;
  - `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`;
  - `bad_citation/1`.

  These serve the test modes. Totality and determinism are checked over fixtures plus generated profiles. Boundary coverage uses held = total/2, total/2 + 1 and 0.
- `kit/query_combinators`: `what_if/5` is not used, because it overrides dict entries; the what-if is local via `profile_set/3`.
- Not used:
  - `currency_vocab`, `vat_category` and `country`: no Member State test (reading (14));
  - `deadline_lib`, `rolling_window` and `date_time`: no dates (reading (15));
  - `compliance_lib`.
- Family backbone (`_common`, deontic): none. The order produces classifications, not modalities.

## 7. Per-slice section — `single_undertaking.clausal`

### 7.1 Statutory VALUE facts owned by this slice

- `:- constant_value(majority_denominator, 2).` This is Art 2(2)(a), `majority` read as more than half. Point (a) HOLDS iff `voting_rights_held * constant(majority_denominator) > voting_rights_total`.
- `limb_citation(point_a, eu_reg_2023_2831_art_2_2_a)`, and likewise `point_b` to `_b`, `point_c` to `_c` and `point_d` to `_d`.
- `point_order([point_a, point_b, point_c, point_d])`, used for tie-breaking in step 4.
- `point_keys(point_a, [voting_rights_held, voting_rights_total])`, `point_keys(point_b, [right_to_appoint_or_remove_majority_of_board])`, `point_keys(point_c, [dominant_influence_by_contract_or_articles])` and `point_keys(point_d, [holder_is_shareholder_or_member, controls_majority_of_voting_rights_alone_by_agreement])`.
- `contract_key(Key, Type)` for the twelve keys in order. The types are `judgement`, `boolean`, `non_negative_integer`, `enterprise_atom` and `relationship_list`.
- `referral_inputs(direct_relationship, [holder_is_an_enterprise, held_is_an_enterprise, dominant_influence_by_contract_or_articles])` and `referral_inputs(group, [relationships])`. These drive THE PAIRS RULE: present inputs as `KEY-VALUE` in root_exports order.

No other figure exists. There are no periods, tables, money amounts or dates.

### 7.2 Rules / requirements (in step order; first deciding step wins; disjoint clauses)

- **Step 0, input check.** For a malformed profile, every query returns `input_problems(Problems)` with Citations `[]`, and Members `[]` where applicable.
- **Point status.** `point_status(Profile, Point, Status)` gives Status `holds`, `fails` or `open`, with each point's conditions as in THE LIMBS:
  - point (a): held 0 gives `fails` without reading the total;
  - point (c): `unsure` gives `open`;
  - point (d): either condition false gives `fails`.
- **Steps 1 to 5 of `direct_relationship`.**
  1. A false enterprise judgement gives `not_directly_related`.
  2. Both judgements true and some point holding gives `directly_related`, citing Art 2(2) plus each holding point.
  3. All points failing gives `not_directly_related`.
  4. Otherwise, name an absent key:
     - `holder_is_an_enterprise`;
     - `held_is_an_enterprise`;
     - only when no point holds, the first absent key of the open point with the fewest absent keys, ties to the earlier point. An unsure-only point (c) is not counted.
  5. Otherwise `needs_legal_review`:
     - KEY is the first unsure key of `holder_is_an_enterprise`, `held_is_an_enterprise`, then `dominant_influence_by_contract_or_articles` (the last only when no point holds);
     - CITE is `eu_reg_2023_2831_art_2_2` for the two enterprise keys and `_c` for dominant influence.
- **Group helpers (local, domain-specific).**
  - `joins(Relationships, Certainty, X, Y)`: undirected edge.
  - `reach(Relationships, CertaintyFilter, Start, Set)`: fixpoint closure via `findall` and `sort`, terminating on cyclic lists.
  - `the_group(Relationships, First, Group)` uses true relationships only. `reach_any(...)` uses either certainty.
  - `group_limb_citations(Relationships, Group, Cites)`: the sorted set of `cite(Key)` terms over true relationships whose two enterprises are both in Group.
  - `directly_joined_true(Relationships, X, Y)`.
- **Steps 6 to 12 of `same_single_undertaking`.** As in section 5.
- **Steps 13 to 17 of `single_undertaking_members`.** As in section 5.
- **Checklist requirements.** `single_undertaking_requirement(RequirementId, Profile, Status, Citation)` has RequirementId FIRST, with three mutually exclusive clauses (met / unmet / unknown) per requirement and no default values.

### 7.3 Verdict atoms of this slice

- `directly_related`, `not_directly_related`
- `single_undertaking`, `not_single_undertaking`
- `members_settled`
- the status compounds `input_problems/1`, `indeterminate/1` and `needs_legal_review/2`

### 7.4 Predicates SHARED with another slice (go to `kernel.clausal`)

None. This is the only determination slice. `kernel.clausal` keeps its scaffold floor unchanged and gains no domain predicate. `parameters.clausal` carries no statutory figure, because the majority denominator lives in the slice by rule. `queries.clausal` and the facade re-export the slice predicates and add the facade, status, checklist and what-if wrappers of section 5.
