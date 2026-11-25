# SIGNATURE — eu/nis2_lex_specialis_and_definitions

Predicate prefix: `nis2_lex_specialis_and_definitions_`. Shape family: deontic.

The layout is kept exactly: `kernel -> citations -> parameters -> nis2_lex_specialis_and_definitions -> queries -> fixtures -> package facade`. Seven test modes; v2 manifest. No file or module is renamed.

## Public query surface (summary)

The two CALLED-CONTRACT queries answer one group each, from PROFILE alone, with exactly ONE solution per call:

- `nis2_risk_management_provisions_status(Profile, Result, Citations)`
- `nis2_incident_notification_provisions_status(Profile, Result, Citations)`

The input check is `nis2_lex_specialis_and_definitions_input_problems(Profile, Problems)`.

The scaffold facade combines the two group answers:

- `decide_nis2_lex_specialis_and_definitions(Profile, nis2_lex_specialis_and_definitions_verdict(Status, Citations))`
- `nis2_lex_specialis_and_definitions_status(Profile, Status)`

There are no imported figures: the domain has no statutory figures.

Totality and determinism claims:

- Every query is total over every term given as PROFILE.
- Every query is deterministic: exactly one solution, never a duplicate.
- No query fails or raises.

## Verdict STATUS atoms (replacing the placeholder `required / permitted / not_applicable`)

Final RESULT atoms (both group queries):

- `nis2_provisions_disapplied`: Art 4(1) disapplies the group's provisions, Chapter VII included as far as it concerns that group.
- `nis2_provisions_apply`: the group's test is not met, so Art 4 does not take the provisions away.
- `out_of_scope`: `entity_class` is `out_of_scope`, so the Art 4 question does not arise.

Status compounds (never final; CITATIONS always `[]`):

- `indeterminate([Key])`: exactly one bare key atom. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`. An unscored trailing `provenance(Clause, Citations)` item is optional; the plan is to OMIT it.
- `input_problems(Problems)`: `Problems` is a list of `duplicate_key(Key)`, `wrong_type(Key)` and `unknown_key(Key)`.

Result constructors are exported and never called as queries: `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

Facade STATUS (query type #2, eligibility) is the compound `nis2_groups(RiskResult, NotificationResult)`.

- Each argument is exactly the RESULT of the corresponding group query.
- When the profile has input problems, both arguments are the same `input_problems(Problems)`.
- The facade is deterministic: exactly one solution.

## Profile keys (input_contract order = root_exports order; the ORDER IS SCORED in PAIRS)

| # | Key | Type | Values | Read by |
|---|---|---|---|---|
| 1 | `entity_class` | enumeration `entity_class` | `essential_entity`, `important_entity`, `out_of_scope` | both queries |
| 2 | `dora_risk_management_measures_at_least_equivalent_in_effect` | judgement (one_of boolean or unsure) | `true`, `false`, `unsure` | risk query |
| 3 | `dora_gives_immediate_access_to_incident_notifications` | judgement | `true`, `false`, `unsure` | notification query |
| 4 | `dora_incident_notification_requirements_at_least_equivalent_in_effect` | judgement | `true`, `false`, `unsure` | notification query |

Profile conventions:

- PROFILE is `[attribute(Key, Value), ...]`, read ONLY with `profile_get/3` and `profile_lacks/2`: presence first, then value.
- There are no numeric, money or date keys.
- There are no crisp keys.
- No value is a Python boolean or a quoted string.
- `true` and `false` are never pinned in verdict_vocabulary or root_exports.

## Citation-key atoms (canonical, `_lexicon/citations.yaml`; declared in citations.clausal)

- `eu_dir_2022_2555_art_4_1`: Directive (EU) 2022/2555 Art 4(1) [32022L2555#parag_004.001]
- `eu_dir_2022_2555_art_4_2`: Art 4(2), lead words [32022L2555#parag_004.002]
- `eu_dir_2022_2555_art_4_2_a`: Art 4(2)(a) [32022L2555#point_004.002_a]
- `eu_dir_2022_2555_art_4_2_b`: Art 4(2)(b) [32022L2555#point_004.002_b]
- `eu_reg_2022_2554_art_1_2`: Regulation (EU) 2022/2554 Art 1(2) [32022R2554#parag_001.002]

These keys are fixed by the order's canonical lexicon. Their short segments (`dir`, `art`, `reg`) are lexicon atoms, not authored identifiers. Each is carried with `% lint: canonical-citation-key` if the C6 lint flags it; the citations are never respelled.

Pinned and deferred, carried as citation_vocabulary entries ONLY if the manifest requires the deferred set listed (no answer cites them):

- 32022L2555#parag_004.003
- 32022L2555#art_006
- 32022L2555#art_025
- 32022R2554#art_001

## Public predicates (one line each)

- `nis2_risk_management_provisions_status(Profile, Result, Citations)`: the Art 4(1) answer for the risk-management group, by limbs A0 to A5. Final citations are `[art_4_1, art_4_2, art_4_2_a, art_1_2]` as cite/1 terms. Cites Art 4(1), Art 4(2)(a), DORA Art 1(2).
- `nis2_incident_notification_provisions_status(Profile, Result, Citations)`: the Art 4(1) answer for the notification group, by limbs B0 to B6. Final citations are `[art_4_1, art_4_2, art_4_2_b, art_1_2]` as cite/1 terms. Cites Art 4(1), Art 4(2)(b), DORA Art 1(2).
- `nis2_lex_specialis_and_definitions_input_problems(Profile, Problems)`: THE INPUT CHECK. It gives the BARE problem list (`[]` when well-formed) and exactly one solution for every term. It carries no citation, because it is an input contract.
- `decide_nis2_lex_specialis_and_definitions(Profile, Verdict)`: the facade (query type #2). `Verdict` is `nis2_lex_specialis_and_definitions_verdict(nis2_groups(RiskResult, NotificationResult), Citations)`.
  - `Citations` is the duplicate-free union of the two group citation lists: `[art_4_1, art_4_2, art_4_2_a, art_4_2_b, art_1_2]` when both results are final.
  - When only one result is final, `Citations` is that result's list.
  - When neither result is final, `Citations` is `[]`.
  - Cites Art 4(1), (2), (2)(a), (2)(b), DORA Art 1(2).
- `nis2_lex_specialis_and_definitions_status(Profile, Status)`: `Status` is `nis2_groups(RiskResult, NotificationResult)`, the same as the verdict without citations. Same citations as the facade.
- `nis2_lex_specialis_and_definitions_checklist(Profile, Checklist)`: query type #7 (justification). It gives a list of `item(RequirementId, Status, cite(Key))` terms from `eval_requirements/4`, with `Status` one of `met`, `unmet(Reason)` or `unknown([Key])`, and a cite on EVERY item, met items included. Requirement ids, in order:
  - `entity_identified_essential_or_important`: cite `eu_reg_2022_2554_art_1_2`.
  - `risk_management_measures_equivalent`: cite `eu_dir_2022_2555_art_4_2_a`.
  - `immediate_access_to_incident_notifications`: cite `eu_dir_2022_2555_art_4_2_b`.
  - `incident_notification_requirements_equivalent`: cite `eu_dir_2022_2555_art_4_2_b`.
  - When there are input problems, the checklist is `[]`.
- `nis2_lex_specialis_and_definitions_what_if(Profile, Key, Value, Verdict)`: the facade verdict on Profile with Key overridden to Value, via `query_combinators:what_if/5` with the closure `decide_nis2_lex_specialis_and_definitions`. The override goes through `profile_set/3`. Its citations are those of the facade.
- fixtures: `nis2_lex_specialis_and_definitions_fixture(Name, Profile)` and `nis2_lex_specialis_and_definitions_fixture_expected(Name, RiskResult, NotificationResult)`. These are the named cases listed under Fixtures below.

## Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`
  - `eval_requirements/4`, `check_eq/5`, `check_tri/4`
  - `item/3`, `attribute/2`, `unknown/1`, `unmet/1`
  - `memberd/2`, `not_member/2`
- `kit/query_combinators`: `what_if/5`.
- `validate_props` (tests only): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- Not used: `deadline_lib` (no period is formalised), `currency_vocab`, `vat_category`, `country`, `date_time`, `compliance_lib`, `rolling_window`.
  - `compliance_lib` is not used because the deontic answer here is an applicability status, not a modality lattice over actions.

## kernel.clausal (shared floor)

There is only ONE determination slice, so NO domain predicate must be shared, and the kernel gains no domain logic. The kernel keeps its scaffold floor:

- the module header;
- the result-constructor declarations listed above;
- the shared re-exports of `formalize_lib` that the scaffold already carries.

The TODO placeholders are replaced only by these declarations. The input check is NOT moved to the kernel: it belongs to the single slice.

## citations.clausal

It declares the five canonical citation keys above, with instrument, unit id and a short gloss, as citation_vocabulary rows. There are no other keys.

## parameters.clausal

It holds no `constant_value` declaration: there are no thresholds, periods or amounts. A comment records that Art 4(3)'s 17 July 2023 date is deferred and not a parameter.

## Slice: nis2_lex_specialis_and_definitions.clausal

**Statutory VALUE facts owned.** There is no numeric value.

The slice owns its enumerations as facts:

- `entity_class_value/1`: `essential_entity`, `important_entity`, `out_of_scope`.
- `judgement_value/1`: `true`, `false`, `unsure`.
- `contract_key/2`, in input_contract order with type: `(entity_class, entity_class)` and then the three keys with type `judgement`.
- `in_scope_class/1`: `essential_entity`, `important_entity`.

Citation lists are folded into heads:

- `risk_management_citations/1` is the fixed four-cite list with `art_4_2_a`.
- `incident_notification_citations/1` is the fixed four-cite list with `art_4_2_b`.

Referral rows are `referral_row(Query, Key, CitationKey, Inputs)`:

- `(risk_management, dora_risk_management_measures_at_least_equivalent_in_effect, eu_dir_2022_2555_art_4_2_a, [entity_class, dora_risk_management_measures_at_least_equivalent_in_effect])`
- `(incident_notification, dora_gives_immediate_access_to_incident_notifications, eu_dir_2022_2555_art_4_2_b, [entity_class, dora_gives_immediate_access_to_incident_notifications, dora_incident_notification_requirements_at_least_equivalent_in_effect])`
- `(incident_notification, dora_incident_notification_requirements_at_least_equivalent_in_effect, eu_dir_2022_2555_art_4_2_b, [the same three keys])`

### Rules (one clause per disjoint route, outputs folded into heads, no `!`, `->`, `*->`)

**Input check.** `nis2_lex_specialis_and_definitions_input_problems/2`:

- Profile shape:
  - A non-attribute-list profile gives `[wrong_type(profile)]`. This covers an unbound profile, a partial list, an unbound element, and any element that is not `attribute(_, _)`.
  - The shape walk uses `var/1` and `nonvar/1` guards so that it never raises.
- Contract keys, in contract order:
  - A contract key occurring two or more times (counted with ==) gives `duplicate_key(Key)`, and its values are not read.
  - Otherwise, a key occurring once with a value outside its type gives `wrong_type(Key)`. An unbound value is outside its type, and any number is outside its type.
- Unknown keys:
  - Each key not == to a contract key gives `unknown_key(Key)`, once, in first-occurrence order, deduplicated with ==.
  - The key is reported as given: two distinct variables are two keys, and 7 and 7.0 are two keys.
  - The values of unknown keys are never checked.
- Absence is never a problem.
- The check yields exactly one solution: it is built by deterministic list recursion with disjoint clause guards, never by findall over a nondeterministic generator that could repeat.

**Risk query.** `nis2_risk_management_provisions_status/3`. Each route has a disjoint guard; the input check is called once.

- **A0:** Problems is non-empty. Result `input_problems(Problems)`, citations `[]`.
- **A1:** Problems is `[]` and `entity_class` is absent. Result `indeterminate([entity_class])`, citations `[]`.
- **A2:** `entity_class` is `out_of_scope`. Result `out_of_scope`, with the risk citations.
- **A3a:** in-scope class and judgement `true`. Result `nis2_provisions_disapplied`, with the risk citations.
- **A3b:** in-scope class and judgement `false`. Result `nis2_provisions_apply`, with the risk citations.
- **A4:** in-scope class and judgement absent. Result `indeterminate([dora_risk_management_measures_at_least_equivalent_in_effect])`, citations `[]`.
- **A5:** in-scope class and judgement `unsure`. Result `needs_legal_review(open_textured(dora_risk_management_measures_at_least_equivalent_in_effect, cite(eu_dir_2022_2555_art_4_2_a)), [inputs_relied_on(Pairs)])`, citations `[]`.

**Notification query.** `nis2_incident_notification_provisions_status/3`. Write Access for key 3 and Requirements for key 4.

- **B0:** as A0.
- **B1:** as A1.
- **B2:** `entity_class` is `out_of_scope`. Result `out_of_scope`, with the notification citations.
- **B3** (two DISJOINT clauses, so that both-false yields ONE solution):
  - **B3a:** Access is `false`. Result `nis2_provisions_apply`, with the notification citations.
  - **B3b:** Access is present and not false, and Requirements is `false`. Result `nis2_provisions_apply`, with the notification citations.
- **B4** (disjoint):
  - **B4a:** Access is absent and Requirements is not `false` (absent or present). Result `indeterminate([dora_gives_immediate_access_to_incident_notifications])`.
  - **B4b:** Access is `true` or `unsure`, and Requirements is absent. Result `indeterminate([dora_incident_notification_requirements_at_least_equivalent_in_effect])`.
- **B5** (disjoint):
  - **B5a:** Access is `unsure` and Requirements is `true` or `unsure`. Result `needs_legal_review(open_textured(dora_gives_immediate_access_to_incident_notifications, cite(eu_dir_2022_2555_art_4_2_b)), [inputs_relied_on(Pairs)])`.
  - **B5b:** Access is `true` and Requirements is `unsure`. The same compound with key 4.
- **B6:** both are `true`. Result `nis2_provisions_disapplied`, with the notification citations.

**PAIRS.** `relied_on_pairs(Profile, Inputs, Pairs)` gives the `Key-Value` pair for each key of the firing referral row's `inputs` that is present in the profile:

- the pairs follow root_exports order;
- each value is exactly as given;
- the unsure key is included;
- `entity_class` is always present at a referral.

**Requirements for the checklist.** `nis2_lex_specialis_and_definitions_requirement(RequirementId, Profile, Status, Citation)`. RequirementId comes FIRST, and there are three mutually exclusive clauses per requirement:

- `entity_identified_essential_or_important`:
  - met when the class is in scope;
  - `unmet(entity_class_out_of_scope)` when the class is `out_of_scope`;
  - `unknown([entity_class])` when it is absent.
- The three judgement requirements:
  - `true` gives met;
  - `false` gives `unmet(judgement_false)`;
  - absent or `unsure` gives `unknown([Key])`, which is the open-textured hand-off to the user and never a crisp test.
  - These checks go through `check_tri/4`.

The checklist explains; the verdict is ALWAYS the group queries' answer, never re-derived from the checklist.

**Verdict atoms of this slice:** `nis2_provisions_disapplied`, `nis2_provisions_apply`, `out_of_scope`, plus the three status compounds.

**Shared predicates:** none. Nothing goes to the kernel.

### Per-rule tests (in the slice's test file; seven test modes)

1. One positive test per limb A0 to A5 and B0 to B6, and per sub-clause.
2. COUNTING: a `findall` length of 1 for every query on every fixture, and on the both-false, both-absent and both-unsure cases.
3. Behind and decides-alone cases:
   - `entity_class` absent with each judgement `unsure` gives `indeterminate([entity_class])`;
   - `out_of_scope` with the judgements absent or `unsure` gives `out_of_scope`;
   - `false` beside an absent or `unsure` partner gives `nis2_provisions_apply`.
4. <<DNUM>> and Q8:
   - Access absent and Requirements `unsure` names Access;
   - Access `unsure` and Requirements absent names Requirements.
5. Input check:
   - duplicate beats wrong_type;
   - unknown-key order and dedup with ==;
   - two variables give two keys;
   - 7 and 7.0;
   - unbound value gives wrong_type;
   - partial list, non-attribute element and unbound profile give `[wrong_type(profile)]`;
   - a number value gives wrong_type;
   - the unknown key's value is never checked.
6. Citation completeness: final answers carry the fixed lists, and statuses carry `[]`.
7. Properties via `validate_props`: totality and determinism over the full grid of the profiles over the four keys, each absent or taking each of its values (4 x 4 x 4 x 4 = 256), including the completion-meaning check for absent and unsure keys.

Every `fail` test is paired with a positive test over the same case.

## queries.clausal

It re-exports the two group queries and the input check unchanged. It defines `nis2_lex_specialis_and_definitions_status/2` and `nis2_lex_specialis_and_definitions_checklist/2` (via `eval_requirements/4` with the closure `nis2_lex_specialis_and_definitions_requirement`), and `nis2_lex_specialis_and_definitions_what_if/4`.

## Fixtures (fixtures.clausal)

Each line gives the profile in key order, then the risk result and the notification result.

- `essential_all_equivalent`: essential_entity, true, true, true. Risk `nis2_provisions_disapplied`; notification `nis2_provisions_disapplied`.
- `important_only_point_a_met`: important_entity, true, false, true. Risk `nis2_provisions_disapplied`; notification `nis2_provisions_apply`. This shows reading (3) and Q1.
- `essential_only_point_b_met`: essential_entity, false, true, true. Risk `nis2_provisions_apply`; notification `nis2_provisions_disapplied`.
- `out_of_scope_entity`: out_of_scope, with the judgements absent. Risk `out_of_scope`; notification `out_of_scope`.
- `class_missing`: the class is absent and the judgements are unsure. Risk `indeterminate([entity_class])`; notification `indeterminate([entity_class])`.
- `unsure_risk_measures`: essential_entity, unsure, false, absent. Risk `needs_legal_review(...)` with Pairs `[entity_class-essential_entity, dora_risk_management_measures_at_least_equivalent_in_effect-unsure]`; notification `nis2_provisions_apply`.
- `access_missing_requirements_unsure`: important_entity, absent, absent, unsure. Risk `indeterminate([dora_risk_management_measures_at_least_equivalent_in_effect])`; notification `indeterminate([dora_gives_immediate_access_to_incident_notifications])`.
- `both_notification_unsure`: essential_entity, true, unsure, unsure. Risk `nis2_provisions_disapplied`; notification `needs_legal_review` naming key 3.
- `malformed_duplicate_and_unknown`: entity_class given twice, plus `attribute(sector, banking)`. Both results are `input_problems([duplicate_key(entity_class), unknown_key(sector)])`.
