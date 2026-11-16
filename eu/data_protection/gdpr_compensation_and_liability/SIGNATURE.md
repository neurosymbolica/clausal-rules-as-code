# SIGNATURE — eu/data_protection/gdpr_compensation_and_liability

## Public query surface

The package facade exposes:

- `decide_gdpr_compensation_and_liability(PROFILE, gdpr_compensation_and_liability_verdict(STATUS, CITATIONS))`
- `gdpr_compensation_and_liability_status(PROFILE, STATUS)`

Both are thin wrappers over the slice query `compensation_liability(PROFILE, RESULT, BASIS, CITATIONS)`, with STATUS = RESULT. The name `compensation_liability/4` is pinned by the order (COMPENSATION_LIABILITY) and is exported verbatim, without the domain prefix, because the test harness calls it by that name.

PROFILE is an attribute list `[attribute(KEY, VALUE), ...]` over the EIGHT keys below. It is read only with `profile_get/3`, `profile_has/2` and `profile_lacks/2` from formalize_lib: presence first, then value.

**Totality:** the query yields a solution for every term given as PROFILE (malformed profiles give `input_problems/1`).

**Determinism:** the query yields EXACTLY ONE solution for every PROFILE. Every combination of the eight keys is decided by exactly one step (0 to 11). The route clauses are disjoint by construction, with no cut, no `->` and no `*->`.

No statutory figure exists in Art 82, so nothing is imported or re-declared as a constant.

## Verdict STATUS atoms (replacing the placeholder `{ required, permitted, not_applicable }`)

Final:

- `liable_for_damage`: Art 82(1), (2) and (3); attested non-responsibility is false.
- `exempt_from_liability`: Art 82(2) and (3); attested non-responsibility is true.
- `not_liable_for_damage`: Art 82(2); the caller is outside its limb.
- `right_not_established`: Art 82(1); a condition is false.

Non-final (compound terms only; the bare atom `indeterminate` is NEVER written):

- `indeterminate([KEY])`: a one-element list naming the first missing needed key.
- `needs_legal_review(open_textured(KEY, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on(PAIRS)])`
- `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), [resolution(cite(non_responsibility_statement), not_attempted), inputs_relied_on(PAIRS)])`
- `input_problems(PROBLEMS)`: the PROBLEMS list is non-empty.

Eligibility mapping (query type #2):

| Mapping | Statuses |
|---|---|
| positive (the claimant is entitled to compensation from this caller) | `liable_for_damage` |
| negative | `exempt_from_liability`, `not_liable_for_damage`, `right_not_established` |
| indeterminate | `indeterminate/1`, `needs_legal_review/2`, `input_problems/1` |

## Profile keys (input_contract order = root_exports order)

| # | key | class | values |
|---|---|---|---|
| 1 | `party_role` | enumerated | `controller`, `processor` |
| 2 | `involved_in_the_processing` | crisp | `true`, `false` (read only for controller) |
| 3 | `processor_breached_obligations_directed_to_processors` | crisp | `true`, `false` (read only for processor) |
| 4 | `processor_acted_outside_or_contrary_to_lawful_instructions` | crisp | `true`, `false` (read only for processor) |
| 5 | `damage_suffered` | judgement (tri-state) | `true`, `false`, `unsure` |
| 6 | `infringement_of_the_regulation_occurred` | judgement (tri-state) | `true`, `false`, `unsure` |
| 7 | `damage_resulted_from_the_infringement` | judgement (tri-state) | `true`, `false`, `unsure` |
| 8 | `not_in_any_way_responsible_for_the_event` | outside fact | `attested(true or false, attestation(BY, AT, REASON, EVIDENCE))` |

Notes on the keys:

- There are no numeric or date keys.
- In the outside-fact value, EVIDENCE is `url(URL, RETRIEVED_AT)`, `document(UPLOAD_ID, SHA256)` or `none`. None of the four attestation arguments is inspected.
- Booleans are the atoms `true` and `false`, never strings.

`outside_facts:` entry:

- key `not_in_any_way_responsible_for_the_event`
- citation `eu_reg_2016_679_art_82_3`
- target `non_responsibility_statement`
- kinds `[attested, fetched]`, fetcher `none`

## Citation-key atoms (canonical lexicon scheme, _lexicon/citations.yaml)

Load-bearing (appear in CITATIONS or in an open_textured / cross_reference_unresolved REASON):

- `eu_reg_2016_679_art_82_1`: Art 82(1), unit 02016R0679-20160504#parag_082.001
- `eu_reg_2016_679_art_82_2`: Art 82(2), unit parag_082.002
- `eu_reg_2016_679_art_82_3`: Art 82(3), unit parag_082.003

Deferred (quoted in citations.clausal for the deferral record; never emitted in a RESULT):

- `eu_reg_2016_679_art_82_4`, `eu_reg_2016_679_art_82_5`, `eu_reg_2016_679_art_82_6`

Cross-reference target (outside-fact target, not an article):

- `non_responsibility_statement`

CITATIONS is a set-like list of `cite(KEY)` terms. Each atom is written once; the order is not scored. No shortened citation atom is ever invented.

## Public predicates

- `compensation_liability(Profile, Result, Basis, Citations)`: the order's query COMPENSATION_LIABILITY, spelled exactly as pinned; steps 0 to 11 below decide Result, Basis and Citations for one claim against the caller for one processing; exactly one solution for every term. Cites Art 82(1), 82(2) and 82(3) (`eu_reg_2016_679_art_82_1`, `eu_reg_2016_679_art_82_2`, `eu_reg_2016_679_art_82_3`).
- `decide_gdpr_compensation_and_liability(Profile, Verdict)`: Verdict = `gdpr_compensation_and_liability_verdict(Status, Citations)`, from `compensation_liability/4`; one solution. Cites Art 82(1) to (3) per route.
- `gdpr_compensation_and_liability_status(Profile, Status)`: Status = the RESULT of `compensation_liability/4`; one solution. Cites Art 82(1) to (3).
- `gdpr_compensation_and_liability_checklist(Profile, Checklist)`: the justification checklist (query type #7). It is a list of `item(RequirementId, ItemStatus, cite(Key))`, one per requirement, built with `eval_requirements/4` over `gdpr_compensation_and_liability_requirement/4`, and is `[]` when the input check finds problems. Every item carries cite(...) provenance, met items included. Cites Art 82(1), (2) and (3).
- `gdpr_compensation_and_liability_what_if(Profile, Key, Value, Status)`: the Status the query gives when Key is set to Value. It calls kit `what_if(Profile, Key, Value, gdpr_compensation_and_liability_status, Status)`, so an existing entry is replaced and never duplicated. Cites Art 82(1) to (3).
- `gdpr_compensation_and_liability_input_problems(Profile, Problems)`: the typed input check. It yields exactly one solution for every term, never fails and never raises. Cites INTERFACE - THE INPUT CHECK.
- `gdpr_compensation_and_liability_requirement(RequirementId, Profile, ItemStatus, Citation)`: the checklist requirement predicate, with RequirementId FIRST, passed as a closure to `eval_requirements/4`. Cites per requirement.
- `gdpr_compensation_and_liability_fixture(Name, Profile)`: the named example profiles (fixtures.clausal).
- `gdpr_compensation_and_liability_fixture_expected(Name, Result, Basis, Citations)`: the expected answer of each fixture.

Result constructors, exported and never called as queries:

- `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`
- `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`
- `resolution/2`, `inputs_relied_on/1`, `provenance/2`, `outside_fact/2`
- `attested/2`, `attestation/4`, `url/2`, `document/2`
- `gdpr_compensation_and_liability_verdict/2`

## Planned reuse (manifest `uses:`)

- **formalize_lib:** `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `eval_requirements/4`, `item/3`, `attribute/2`, `unknown/1`, `unmet/1`, `memberd/2`, `not_member/2`.
  - The vocabulary atoms `met` and `inapplicable` are used as checklist item statuses.
  - `check_tri/4` is NOT used for the verdict. The verdict is a fixed step order, not a Kleene conjunction, and the R1 and C15 lints forbid a hand-rolled clone, so the checklist rows read keys with `profile_get/3` directly.
- **kit/query_combinators:** `what_if/5`, used by the facade what_if.
- **validate_props** (tests only):
  - `run_props/1`
  - `prop_totality/3`
  - `prop_determinism/3`
  - `prop_citation_complete/3`
  - `prop_missing_key_coverage/3`
  - `bad_citation/1`
  - `declare_vacuous/1`, for `prop_boundary_coverage` and `prop_monotone`: there is no numeric axis.
- **Not used**, each with its reason:

| Module | Reason |
|---|---|
| kit/compliance_lib | single norm and single bearer; no modality lattice |
| deadline_lib, rolling_window, date_time | no periods or dates |
| currency_vocab | no money |
| country | no jurisdiction test |

- **Family backbone `_common` (deontic):** no predicate is needed. If the backbone exposes a status-to-label helper, the facade may reuse it, and the later phase checks MODULES.yaml before authoring a local mapping.

## Layer files (layout unchanged)

- **kernel.clausal:** the shared floor. It re-exports nothing domain-specific, because there is ONE slice and no predicate needs sharing. The scaffold floor (module header and the input check) is kept as is.
- **citations.clausal:** `citation(Key, Instrument, Unit, Gloss)` facts for the six Art 82 atoms. It also holds `deferred_citation/1` for `eu_reg_2016_679_art_82_4`, `_5` and `_6`, and `cross_reference_target(non_responsibility_statement, eu_reg_2016_679_art_82_3)`.
- **parameters.clausal:** no `constant_value/2`, because Art 82 has no figures. It carries a comment that it is intentionally empty of figures.
- **queries.clausal:** the facade predicates above.
- **fixtures.clausal:** the fixtures listed below.

## Slice: gdpr_compensation_and_liability.clausal

### Value facts owned by this slice

There are no thresholds, periods or tables. The slice owns these closed vocabularies and orders as facts:

- `contract_key_order/1`: the eight keys in the order of the profile table.
- `key_class(Key, Class)`, with Class in:
  - `enumerated` (`party_role`)
  - `crisp` (keys 2 to 4)
  - `judgement` (keys 5 to 7)
  - `outside_fact` (key 8)
- `role_value/1`: `controller`, `processor`.
- `crisp_value/1`: `true`, `false`.
- `judgement_value/1`: `true`, `false`, `unsure`.
- `judgement_order/1`: `[damage_suffered, infringement_of_the_regulation_occurred, damage_resulted_from_the_infringement]`.
- `outside_fact_entry(not_in_any_way_responsible_for_the_event, eu_reg_2016_679_art_82_3, non_responsibility_statement)`.

### Internal helpers (local; no cut, no if-then-else; mutually exclusive clauses)

- `judgement_state(Profile, Key, State)`: State is `absent` (via `profile_lacks/2`), or `true`, `false` or `unsure` (via `profile_get/3`).
- `some_judgement_false(Profile)`: holds when any of the three judgement keys is `false`.
- `first_absent_judgement(Profile, Key)`: no judgement is false, and Key is the first absent judgement key in judgement order. The exclusivity is written out positionally: for damage_suffered, Key is absent. For infringement_of_the_regulation_occurred, damage_suffered is present and not false and Key is absent. For damage_resulted_from_the_infringement, the earlier two are present and not false and Key is absent.
- `all_judgements_true(Profile)`: holds when all three judgement keys are `true`.
- `first_unsure_judgement(Profile, Key)`: all three are present, each `true` or `unsure`, and Key is the first `unsure` one.
- `caller_position(Profile, Position)`: Position is `inside`, `outside` or `undecided(Key)`. It is read only after steps 1 to 4.
  - `controller` with involved `false`: outside.
  - `controller` with involved `true`: inside.
  - `controller` with involved absent: undecided(involved_in_the_processing).
  - `processor` with either processor key `true`: inside.
  - `processor` with both keys present and `false`: outside.
  - `processor` with neither key `true` and processor_breached_obligations_directed_to_processors absent: undecided(processor_breached_obligations_directed_to_processors).
  - `processor` with processor_breached_obligations_directed_to_processors `false` and processor_acted_outside_or_contrary_to_lawful_instructions absent: undecided(processor_acted_outside_or_contrary_to_lawful_instructions).
  - `party_role` absent: undecided(party_role).
  - Keys of the other role are never read.
- `judgement_pairs(Profile, Pairs)`: `[damage_suffered-V1, infringement_of_the_regulation_occurred-V2, damage_resulted_from_the_infringement-V3]`, in root_exports order.
- `cross_reference_pairs(Profile, Pairs)`: judgement_pairs with `not_in_any_way_responsible_for_the_event-absent` appended (it is last in root_exports order).

### Rules: the query `compensation_liability(Profile, Result, Basis, Citations)`

The ground RESULT, BASIS and CITATIONS are folded into the clause head (C17), with one clause per disjoint route. The first step that applies decides.

| step | guard | RESULT | BASIS | CITATIONS |
|---|---|---|---|---|
| 0 | input problems non-empty | `input_problems(Problems)` | `[]` | `[]` |
| 1 | `damage_suffered` false | `right_not_established` | `[]` | `[cite(eu_reg_2016_679_art_82_1)]` |
| 2 | `infringement_of_the_regulation_occurred` false (damage_suffered not false) | `right_not_established` | `[]` | `[cite(eu_reg_2016_679_art_82_1)]` |
| 3 | `damage_resulted_from_the_infringement` false (earlier two not false) | `right_not_established` | `[]` | `[cite(eu_reg_2016_679_art_82_1)]` |
| 4 | none false; first absent judgement Key | `indeterminate([Key])` | `[]` | `[]` |
| 5 | position `undecided(Key)` | `indeterminate([Key])` | `[]` | `[]` |
| 6 | outside; all three true | `not_liable_for_damage` | `[]` | `[cite(eu_reg_2016_679_art_82_2)]` |
| 7 | outside; first unsure Key | `needs_legal_review(open_textured(Key, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on(JudgementPairs)])` | `[]` | `[]` |
| 8 | inside; outside fact absent | `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_3), cite(non_responsibility_statement)), [resolution(cite(non_responsibility_statement), not_attempted), inputs_relied_on(CrossReferencePairs)])` | `[]` | `[]` |
| 9 | inside; outside fact present; first unsure Key | `needs_legal_review(open_textured(Key, cite(eu_reg_2016_679_art_82_1)), [inputs_relied_on(JudgementPairs)])` | `[]` | `[]` |
| 10 | inside; all true; `attested(true, Attestation)` | `exempt_from_liability` | `[outside_fact(not_in_any_way_responsible_for_the_event, attested(true, Attestation))]` | `[cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]` |
| 11 | inside; all true; `attested(false, Attestation)` | `liable_for_damage` | `[outside_fact(not_in_any_way_responsible_for_the_event, attested(false, Attestation))]` | `[cite(eu_reg_2016_679_art_82_1), cite(eu_reg_2016_679_art_82_2), cite(eu_reg_2016_679_art_82_3)]` |

Every step from 1 onwards also requires that the input problems are `[]`. The ATTESTED term is copied exactly as supplied.

### Input check `gdpr_compensation_and_liability_input_problems(Profile, Problems)`

It yields one solution for every term and is free of cut and if-then-else. Exclusivity comes from `var/1`, `nonvar/1`, `is_list/1` and `atom/1` guards.

- **Shape.** An unbound Profile, a partial list, a non-list, a list with an unbound element, or a list with any element that is not `attribute(_, _)` gives `[wrong_type(profile)]` alone.
- **Per contract key**, in contract_key_order:
  - `duplicate_key(Key)` if the key occurs at least twice. Its values are not read.
  - Otherwise `wrong_type(Key)` if the key occurs once with a value outside its class:

| Class | Values accepted |
|---|---|
| enumerated | `controller` or `processor` |
| crisp | `true` or `false` |
| judgement | `true`, `false` or `unsure` |
| outside fact | `attested(V, attestation(_, _, _, _))` with V `true` or `false` |

  - An unbound value is `wrong_type(Key)`.
- **Then** `unknown_key(Key)`, once per distinct key outside the eight, in the order of its first occurrence. A non-atom key (number, string, compound, variable) is reported as given. Distinctness is tested with `==`, so that variables are not unified.
- **Absence** is never a problem.

### Checklist requirements (justification, query type #7)

The requirement predicate is `gdpr_compensation_and_liability_requirement(RequirementId, Profile, ItemStatus, Citation)`. ItemStatus is `met`, `unmet(Reason)`, `unknown([Key])` or `inapplicable`, and there are three or four mutually exclusive clauses per id. The requirement ids are, in order:

1. `damage_suffered`, cite `eu_reg_2016_679_art_82_1`:
   - true gives `met`.
   - false gives `unmet(judgement_false)`.
   - unsure gives `unknown([damage_suffered])`.
   - absent gives `unknown([damage_suffered])`.
2. `infringement_of_the_regulation_occurred`, cite `eu_reg_2016_679_art_82_1`: the same pattern.
3. `damage_resulted_from_the_infringement`, cite `eu_reg_2016_679_art_82_1`: the same pattern.
4. `party_within_article_82_2`, cite `eu_reg_2016_679_art_82_2`, from caller_position:
   - inside gives `met`.
   - outside gives `unmet(outside_article_82_2)`.
   - undecided(Key) gives `unknown([Key])`.
5. `not_exempt_under_article_82_3`, cite `eu_reg_2016_679_art_82_3`:
   - attested false gives `met`.
   - attested true gives `unmet(exempt)`.
   - absent with the caller inside gives `unknown([not_in_any_way_responsible_for_the_event])`.
   - a caller that is outside or undecided gives `inapplicable`.

The checklist is explanatory only. The verdict comes from the step order, never from `decide_labeled/3`, and an outside fact still never enters MISSING_KEYS. Consistency is tested: `liable_for_damage` holds if and only if every item is `met`.

### Verdict atoms of the slice

`liable_for_damage`, `exempt_from_liability`, `not_liable_for_damage`, `right_not_established`, plus the non-final `indeterminate/1`, `needs_legal_review/2` and `input_problems/1`.

### Shared with other slices (kernel.clausal)

None. This is the only determination slice. All helpers and the outside-fact handling stay local to the slice; the input check stays where the scaffold put it.

### Fixtures (fixtures.clausal; one per route, plus edge cases)

**One per route:**

- `controller_liable` (step 11)
- `controller_exempt` (step 10)
- `processor_liable_by_breach` (step 11, with the second processor key absent and not named)
- `processor_liable_by_instructions` (step 11)
- `processor_outside_both_false` (step 6)
- `controller_not_involved` (step 6)
- `damage_false_role_absent` (step 1)
- `infringement_false_outside_caller` (step 2, Q8)
- `causation_false` (step 3)
- `judgement_absent` (step 4)
- `role_absent` (step 5, `party_role`)
- `controller_involvement_absent` (step 5)
- `processor_keys_absent` (step 5, first processor key)
- `processor_second_key_absent` (step 5)
- `outside_caller_unsure` (step 7, with the outside fact absent and not read)
- `inside_outside_fact_absent_with_unsure` (step 8 before step 9)
- `inside_unsure` (step 9)

**Input problems (step 0):**

- `input_wrong_type_crisp_unsure`
- `input_duplicate_key`
- `input_unknown_key`
- `input_not_attribute_list`
- `input_unbound_value`

### Test modes (seven, v2 manifest)

1. load
2. per-route unit tests over the fixtures, each negative paired with a positive
3. input-check tests
4. totality and determinism, using `prop_totality/3` and `prop_determinism/3` over an exhaustive generator of the eight keys (absent or each value)
5. citation completeness, using `prop_citation_complete/3` and `bad_citation/1`
6. missing-key coverage, using `prop_missing_key_coverage/3`
7. checklist and what_if consistency (`prop_boundary_coverage` and `prop_monotone` are declared vacuous)
