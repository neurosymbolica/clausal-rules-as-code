# SIGNATURE — ch/swiss_fadp_art24_breach_notification

This is the authoring plan for the later phases. Package layout, file names and module names are unchanged:

kernel -> citations -> parameters -> swiss_fadp_art24_breach_notification -> queries -> fixtures -> package facade

Shape family: deontic. The manifest is v2 and there are seven test modes.

## Public query surface (summary)

The CALLED CONTRACT is non-negotiable. Its predicates are exported from the slice, re-exported by queries.clausal and by the facade:

- `swiss_controller_report_to_commissioner/3`
- `swiss_processor_report_to_controller/3`
- `swiss_information_of_data_subject/3`
- `eu_controller_notification_to_supervisory_authority/3`
- `compare_swiss_eu_authority_notification/5`
- `swiss_fadp_art24_breach_notification_input_problems/2`

The scaffold facade names are kept and built on top of the contract:

- `decide_swiss_fadp_art24_breach_notification/2`
- `swiss_fadp_art24_breach_notification_status/2`
- `swiss_fadp_art24_breach_notification_checklist/2`
- `swiss_fadp_art24_breach_notification_what_if/4`
- fixtures

**Totality and determinism.** Every public predicate yields EXACTLY ONE solution for every PROFILE term.
- The input check never fails and never raises.
- Every other query is total, with no failure, for every term.
- Uniqueness comes from mutually exclusive clause guards over a single key-state classification.
- No `!`, `->`, `*->`, `once/1` or findall-dedup tricks are used.

**Imported figures.** There are none. The domain has no statutory number. In particular, the GDPR 72 hours is NOT declared as a constant, because no rule reads it.

## Verdict STATUS atoms (replace the placeholder `{ required, permitted, not_applicable }`)

**Final answer atoms** (arity 0):
- `authority_notification_required`, `authority_notification_not_required`: Swiss Art 24(1) and EU Art 33(1).
- `report_to_controller_required`, `report_to_controller_not_required`: Art 24(3).
- `information_of_data_subject_required`, `information_of_data_subject_not_required`, `information_of_data_subject_may_be_restricted_deferred_or_omitted`: Art 24(4)/(5).
- `same`, `differs`, `not_comparable`: the comparison DIFFERENCE.

**Status compounds** (not final; written as the compound ITSELF, never in a list and never as a bare atom):
- `indeterminate([KEY])`: exactly one bare key atom, the first missing key the answer can still need.
- `needs_legal_review(open_textured(KEY, cite(CITE)), [inputs_relied_on(PAIRS)])`: PAIRS is a flat list of `KEY-VALUE` terms in root_exports order.
- `input_problems(PROBLEMS)`: PROBLEMS is a flat list of `duplicate_key/1`, `wrong_type/1` and `unknown_key/1` terms.

**Result constructors** are exported and never called as queries. Each has exactly this arity:
- `indeterminate/1`
- `needs_legal_review/2`
- `open_textured/2`
- `inputs_relied_on/1`
- `provenance/2`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`

The facade verdict term is `swiss_fadp_art24_breach_notification_verdict(STATUS, CITATIONS)`.
- STATUS is the RESULT of `swiss_controller_report_to_commissioner/3`, the headline duty of Art 24(1).
- CITATIONS is its citation list.

## Profile keys (input_contract / root_exports order)

PROFILE is `[attribute(KEY, VALUE), ...]`. It is read ONLY with `profile_get/3` and `profile_lacks/2`, by presence first and then by value. Keys are bare atoms.

| # | Key | Type | Provision |
|---|---|---|---|
| 1 | `breach_of_data_security` | judgement: `true`/`false`/`unsure` | DSG Art 5 lit h |
| 2 | `breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights` | judgement | DSG Art 24(1) |
| 3 | `information_necessary_for_protection_of_data_subject` | judgement | DSG Art 24(4) |
| 4 | `commissioner_requested_information_of_data_subject` | crisp: `true`/`false` | DSG Art 24(4) |
| 5 | `article_26_ground_or_statutory_secrecy_obligation_applies` | judgement | DSG Art 24(5)(a) |
| 6 | `information_impossible_or_requires_disproportionate_effort` | judgement | DSG Art 24(5)(b) |
| 7 | `information_ensured_comparably_by_public_announcement` | judgement | DSG Art 24(5)(c) |
| 8 | `personal_data_breach` | judgement | GDPR Art 33(1) (Art 4(12) not pinned) |
| 9 | `breach_unlikely_to_result_in_risk` | judgement | GDPR Art 33(1) |

The domain has no numeric keys and no date keys. There is no attested wrapper (ruling 2 stance: every key is a plain value). An absent key is never an input problem.

## Citation-key atoms (citation_vocabulary, canonical lexicon scheme)

- `ch_fadp_art_5_h` — DSG Art 5 letter h
- `ch_fadp_art_24_1` — DSG Art 24(1)
- `ch_fadp_art_24_3` — DSG Art 24(3)
- `ch_fadp_art_24_4` — DSG Art 24(4)
- `ch_fadp_art_24_5` — DSG Art 24(5), lead-in
- `ch_fadp_art_24_5_a` — DSG Art 24(5)(a)
- `ch_fadp_art_24_5_b` — DSG Art 24(5)(b)
- `ch_fadp_art_24_5_c` — DSG Art 24(5)(c)
- `eu_reg_2016_679_art_33_1` — GDPR Art 33(1)

These atoms are rendered in citations.clausal from the lexicon. Arts 60 and 61 are deferred, and no atom is emitted for them.

## Public predicates (one line each)

- `swiss_controller_report_to_commissioner(Profile, Result, Citations)`: the controller's report duty to the EDÖB. Result is `authority_notification_required`, `authority_notification_not_required` or a status compound; Citations are `[cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]` when final, `[]` otherwise. + `ch_fadp_art_5_h`, `ch_fadp_art_24_1`. Query type #14.
- `swiss_processor_report_to_controller(Profile, Result, Citations)`: the processor's report duty to the controller. Result is `report_to_controller_required`, `report_to_controller_not_required` or a status compound; Citations are `[cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]` when final. + `ch_fadp_art_5_h`, `ch_fadp_art_24_3`. Query type #14.
- `swiss_information_of_data_subject(Profile, Result, Citations)`: the information of the data subject. Result is `information_of_data_subject_required`, `information_of_data_subject_not_required`, `information_of_data_subject_may_be_restricted_deferred_or_omitted` or a status compound. Citations: `[cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4)]` for not_required; `[cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]` for the other two final atoms. + `ch_fadp_art_5_h`, `ch_fadp_art_24_4`, `ch_fadp_art_24_5`, with `ch_fadp_art_24_5_a/_b/_c` in referrals. Query type #14.
- `eu_controller_notification_to_supervisory_authority(Profile, Result, Citations)`: the EU controller's notification to the supervisory authority. Result is `authority_notification_required`, `authority_notification_not_required` or a status compound; Citations are `[cite(eu_reg_2016_679_art_33_1)]` when final. + `eu_reg_2016_679_art_33_1`. Query type #14.
- `compare_swiss_eu_authority_notification(Profile, SwissResult, EuResult, Difference, ChangedBy)`: contrasts the two authority duties. SwissResult and EuResult are copied unchanged from the two RESULT positions. Difference is `same`, `differs` or `not_comparable`. ChangedBy is `[cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)]` iff `differs`, else `[]`. + `ch_fadp_art_24_1`, `eu_reg_2016_679_art_33_1`. Query type #5.
- `swiss_fadp_art24_breach_notification_input_problems(Profile, Problems)`: THE INPUT CHECK. Problems is the BARE list (`[]` when well-formed). It is total and yields one solution. + no citation (the input contract).
- `decide_swiss_fadp_art24_breach_notification(Profile, Verdict)`: the facade. It binds `Verdict = swiss_fadp_art24_breach_notification_verdict(Status, Citations)` from `swiss_controller_report_to_commissioner/3`. + `ch_fadp_art_5_h`, `ch_fadp_art_24_1`.
- `swiss_fadp_art24_breach_notification_status(Profile, Status)`: the Status of decide/2, as one term. + as decide/2.
- `swiss_fadp_art24_breach_notification_checklist(Profile, Checklist)`: a list of `item(DutyId, Result, Citations)` for the four duties, in this fixed order: `controller_report_to_commissioner`, `processor_report_to_controller`, `information_of_data_subject`, `eu_controller_notification`. Each item carries its cite(...) provenance, final items included. It is built with `eval_requirements/4` over the closure `breach_duty_requirement`. + all citation keys above. Query type #7.
- `swiss_fadp_art24_breach_notification_what_if(Profile, Key, Value, Verdict)`: the decide/2 verdict after replacing `attribute(Key, _)` with `attribute(Key, Value)` via `profile_set/3`. The override is attribute-list native, so a single entry results. + as decide/2.
- `swiss_fadp_art24_breach_notification_fixture(Name, Profile)` (fixtures.clausal): the named fixture profiles below. + n/a.

## Planned reuse (manifest `uses:`)

From `formalize_lib`:
- `profile_get/3` and `profile_lacks/2` for key presence and value;
- `eval_requirements/4` for the checklist, so that R1 holds;
- `attribute/2` and `item/3` as constructors;
- `memberd/2` and `not_member/2` for set-like membership.

`check_tri/4` is NOT used, because the precedence rules (first absent key in order, then first unsure key, then PAIRS) are not its contract. The local helper is named so that C15 does not read it as a clone.

Not used, with the reason:
- `kit.deadline_lib`: no deadline is computed.
- `library(datetime)`: there is no date.
- `kit.query_combinators` `what_if/5`: its `override_key/4` is dict-based. what_if/4 uses `profile_set/3` on the attribute list instead.
- `validate_props` is used in the tests for:
  - totality: `prop_totality/3`;
  - determinism: `prop_determinism/3`;
  - citation completeness: `prop_citation_complete/3`;
  - missing-key coverage: `prop_missing_key_coverage/3`.

`list_item/3` is built in and is not needed.

## kernel.clausal (shared floor)

There is only one determination slice, so no predicate must be SHARED between slices. kernel.clausal keeps only its scaffold floor, plus the result-constructor declarations that queries.clausal and the facade re-export:

- `indeterminate/1`
- `needs_legal_review/2`
- `open_textured/2`
- `inputs_relied_on/1`
- `provenance/2`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`

No rule logic goes into kernel.clausal.

## citations.clausal

This file renders the nine citation atoms above from `_lexicon/citations.yaml`. Each carries its instrument, provision and pinned unit id:

- `ch-fadp-sr-235-1-2025-07-07#art_5/para/lbl_h`
- `#art_24/para_1`
- `#art_24/para_3`
- `#art_24/para_4`
- `#art_24/para_5`
- `#art_24/para_5/lbl_a`
- `#art_24/para_5/lbl_b`
- `#art_24/para_5/lbl_c`
- `02016R0679-20160504#parag_033.001`

## parameters.clausal

This file holds NO statutory figures, because none exist in the pinned rules. A comment records that 'so rasch als möglich' has no number and that the EU 72 hours is deliberately not declared (the rounding ruling does not arise). The file stays in the layout and keeps its module name.

## Slice: swiss_fadp_art24_breach_notification.clausal

This slice is self-contained. It owns every value fact, the input check, the five contract queries and the checklist requirement closure.

### Value facts owned by this slice

**The contract key table**, in root_exports order:

```
contract_key(Position, Key, Type)
```

The nine rows have Type `judgement` or `crisp`. Only `commissioner_requested_information_of_data_subject` (position 4) is crisp.

**The allowed values per type:**

```
type_value(judgement, true).
type_value(judgement, false).
type_value(judgement, unsure).
type_value(crisp, true).
type_value(crisp, false).
```

**The referral citation table**, `referral_citation(Query, Key, CitationAtom)`, with these rows:
- controller: `breach_of_data_security` -> `ch_fadp_art_5_h`, `breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights` -> `ch_fadp_art_24_1`;
- processor: `breach_of_data_security` -> `ch_fadp_art_5_h`;
- information: `breach_of_data_security` -> `ch_fadp_art_5_h`, `information_necessary_for_protection_of_data_subject` -> `ch_fadp_art_24_4`, `article_26_ground_or_statutory_secrecy_obligation_applies` -> `ch_fadp_art_24_5_a`, `information_impossible_or_requires_disproportionate_effort` -> `ch_fadp_art_24_5_b`, `information_ensured_comparably_by_public_announcement` -> `ch_fadp_art_24_5_c`;
- eu: `personal_data_breach` -> `eu_reg_2016_679_art_33_1`, `breach_unlikely_to_result_in_risk` -> `eu_reg_2016_679_art_33_1`.

**The read-keys table** (the referral row `inputs`, for THE PAIRS RULE), `query_reads(Query, Keys)`:
- controller: keys 1 and 2;
- processor: key 1;
- information: keys 1, 3, 4, 5, 6 and 7;
- eu: keys 8 and 9.

**The fixed citation lists per final answer** (Q10), `final_citations(Query, Atom, Citations)`. These are facts, so a decided answer always carries the same list.

The slice has no thresholds, no periods and no tables of figures.

### Helpers (local, not exported)

- `key_state(Profile, Key, State)`: State is `absent` (via `profile_lacks/2`), or else the value from `profile_get/3` (`true` / `false` / `unsure`). It is called only after the input check gives `[]`, so it yields exactly one solution because no key is duplicated.
- `first_absent(Profile, Keys, Key)` / `none_absent(Profile, Keys)`: give the first absent key in the given (root_exports-ordered) list. The list is walked with head/tail clauses with disjoint guards.
- `first_unsure(Profile, Keys, Key)`: the same walk for the first unsure key.
- `relied_pairs(Profile, Query, Pairs)`: lists the `Key-Value` pairs of the present keys in `query_reads(Query, _)`, in root_exports order.
- `information_ground(Profile, met | failed | open)` and `information_exception(Profile, held | all_failed | open)`. Each yields one of three disjoint outcomes.

### Rules / requirements (THE LIMBS; first step that answers decides)

**Step 0, every query.**
- Compute PROBLEMS with the input check.
- If PROBLEMS is non-empty, the answer is `input_problems(PROBLEMS)` with Citations `[]`.
- Every later clause carries the guard `PROBLEMS = []`.

**swiss_controller_report_to_commissioner/3** (B = `breach_of_data_security`, H = high risk):
1. B `false`, or H `false`: `authority_notification_not_required`. These are two head-folded clauses with disjoint guards: (B false), and (B not false with H false).
2. B `true` and H `true`: `authority_notification_required`.
3. Otherwise, the first absent of [B, H]: `indeterminate([Key])`, Citations `[]`.
4. Otherwise, the first unsure of [B, H]: `needs_legal_review(open_textured(Key, cite(Cite)), [inputs_relied_on(Pairs)])`, Citations `[]`.

**swiss_processor_report_to_controller/3:**

| B | Result |
|---|---|
| false | `report_to_controller_not_required` |
| true | `report_to_controller_required` |
| absent | `indeterminate([breach_of_data_security])` |
| unsure | the referral, with cite `ch_fadp_art_5_h` and the pairs `[breach_of_data_security-unsure]` |

**swiss_information_of_data_subject/3:**
- **The ground** is MET if the necessity judgement is `true` or the commissioner request is `true`. It is FAILED if both are `false`. Otherwise it is OPEN.
- **The exception** is HELD if any of keys 5, 6 or 7 is `true`. It is ALL FAILED if all three are `false`. Otherwise it is OPEN.

Steps:
- (9) B `false`, or the ground FAILED: `information_of_data_subject_not_required`. Clauses are disjoint: (B false), and (B not false with the ground failed).
- (10) B `true`, the ground MET and the exception HELD: `information_of_data_subject_may_be_restricted_deferred_or_omitted`. Q1: the request ground is included.
- (11) B `true`, the ground MET and the exception ALL FAILED: `information_of_data_subject_required`.
- (12) Build NEEDED, the absent keys among these, in root_exports order:
  - B;
  - keys 3 and 4, if the ground is not MET;
  - keys 5, 6 and 7, if the exception is not HELD.

  If NEEDED is non-empty: `indeterminate([First])`.
- (13) Otherwise, the first unsure key, in root_exports order, among these:
  - B;
  - key 3, if the ground is not MET;
  - keys 5, 6 and 7, if the exception is not HELD.

  The answer is the referral, with the cite from `referral_citation` and the pairs over the six keys the query reads. Key 4 is crisp and never unsure.

The high-risk key and the EU keys are never read here (Q2).

**eu_controller_notification_to_supervisory_authority/3** (P = `personal_data_breach`, U = `breach_unlikely_to_result_in_risk`):
- (14) P `false`, or U `true`: `authority_notification_not_required`.
- (15) P `true` and U `false`: `authority_notification_required`.
- (16) The first absent of [P, U]: `indeterminate([Key])`.
- (17) The first unsure of [P, U]: the referral, with cite `eu_reg_2016_679_art_33_1`.

**compare_swiss_eu_authority_notification/5:**
- (18) SwissResult comes from the controller query and EuResult from the EU query. Each is called once and copied unchanged, with its own missing key or referral and PAIRS.
- (19) Difference is decided by disjoint clauses:
  - both final and equal: `same`;
  - both final and unequal: `differs`;
  - otherwise `not_comparable`.

  A final atom is recognised through the facts `authority_final(authority_notification_required)` and `authority_final(authority_notification_not_required)`. A status compound is recognised by functor.
- (20) ChangedBy is `[cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)]` iff `differs`, else `[]`.
- With input problems, both sides are `input_problems(PROBLEMS)`, Difference is `not_comparable` and ChangedBy is `[]`.

**THE INPUT CHECK** (swiss_fadp_art24_breach_notification_input_problems/2). It is total over any term. It uses `var/1` and `nonvar/1` guards and compares with `==`, never by unification, so it never binds the caller's variables.
- **Not an attribute list.** If PROFILE is unbound, a partial list, not a list, or holds any element that is unbound or not `attribute(_, _)`, the answer is `[wrong_type(profile)]` alone.
- **Otherwise, for each contract key in contract order:**
  - `duplicate_key(K)` if K occurs two or more times (values not read);
  - else `wrong_type(K)` if it occurs once with a value that is unbound or not in `type_value(Type, _)`.
- **Then** `unknown_key(K)` once per distinct non-contract key, in the order of first occurrence. This covers any non-atom key: a number, a string, a compound or a variable, written as given. Variables are distinguished with `==`.
- Absent keys are never problems.

### Verdict atoms of this slice

All the final answer atoms listed in STATUS above, and the three status compounds.

### Checklist requirement closure

```
breach_duty_requirement(DutyId, Profile, Result, Citations)
```

RequirementId comes FIRST. There is one clause per DutyId, and each delegates to its contract query. It is passed to `eval_requirements/4` as the closure `breach_duty_requirement`.

### Shared with another slice

Nothing.

## queries.clausal

Re-exports the six contract predicates and the result constructors. It also defines:
- `decide_swiss_fadp_art24_breach_notification/2`
- `swiss_fadp_art24_breach_notification_status/2`
- `swiss_fadp_art24_breach_notification_checklist/2`
- `swiss_fadp_art24_breach_notification_what_if/4`

Each yields exactly one solution.

## fixtures.clausal (`swiss_fadp_art24_breach_notification_fixture(Name, Profile)`)

Each fixture lists its keys and its expected results (key numbers as in the profile table).

- **fixture_all_duties_owed**
  - Keys: 1 true, 2 true, 3 true, 4 false, 5 false, 6 false, 7 false, 8 true, 9 false.
  - Expected: controller `authority_notification_required`; processor `report_to_controller_required`; information `information_of_data_subject_required`; eu `authority_notification_required`; compare `same`, `[]`.
- **fixture_swiss_not_required_eu_required**
  - Keys: 1 true, 2 false, 8 true, 9 false.
  - Expected: compare gives `authority_notification_not_required`, `authority_notification_required`, `differs`, `[cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)]`.
- **fixture_no_breach**
  - Keys: 1 false, everything else absent.
  - Expected: controller not_required (key 2 not read); processor not_required; information not_required; eu `indeterminate([personal_data_breach])`; compare `not_comparable`, `[]`.
- **fixture_public_announcement_exception**
  - Keys: 1 true, 3 true, 4 false, 7 true, keys 5 and 6 absent.
  - Expected: information `information_of_data_subject_may_be_restricted_deferred_or_omitted`, citing 5_h, 24_4 and 24_5.
- **fixture_commissioner_request_only**
  - Keys: 1 true, 3 false, 4 true, 5 false, 6 false, 7 false.
  - Expected: information `information_of_data_subject_required`.
- **fixture_commissioner_request_with_exception** (Q1)
  - Keys: 1 true, 3 false, 4 true, 6 true.
  - Expected: information `may_be_restricted_deferred_or_omitted`.
- **fixture_ground_failed_breach_absent**
  - Keys: 3 false, 4 false.
  - Expected: information not_required.
- **fixture_high_risk_absent**
  - Keys: 1 true.
  - Expected: controller `indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights])`.
- **fixture_absent_before_unsure**
  - Keys: 1 unsure, key 2 absent.
  - Expected: controller `indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights])`.
- **fixture_breach_unsure**
  - Keys: 1 unsure, 2 true.
  - Expected: controller `needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), [inputs_relied_on([breach_of_data_security-unsure, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights-true])])`; processor `needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), [inputs_relied_on([breach_of_data_security-unsure])])`.
- **fixture_necessity_unsure**
  - Keys: 1 true, 3 unsure, 4 false, 5 false, 6 false, 7 false.
  - Expected: information gives the referral on `information_necessary_for_protection_of_data_subject` with cite `ch_fadp_art_24_4` and the pairs of the six read keys, in order.
- **fixture_necessity_unsure_request_met**
  - Keys: 1 true, 3 unsure, 4 true, 5 false, 6 false, 7 false.
  - Expected: information `information_of_data_subject_required` (key 3 not read).
- **fixture_exception_partly_open**
  - Keys: 1 true, 3 true, 5 unsure, 6 false, key 7 absent.
  - Expected: information `indeterminate([information_ensured_comparably_by_public_announcement])`.
- **fixture_eu_unsure**
  - Keys: 1 true, 2 true, 8 unsure, 9 false.
  - Expected: eu referral on `personal_data_breach` with cite `eu_reg_2016_679_art_33_1` and the pairs `[personal_data_breach-unsure, breach_unlikely_to_result_in_risk-false]`; compare `authority_notification_required`, that referral, `not_comparable`, `[]`.
- **fixture_both_risk_judgements_true** (Q4)
  - Keys: 1 true, 2 true, 8 true, 9 true.
  - Expected: compare `differs`.
- **fixture_crisp_unsure**
  - Keys: 4 unsure.
  - Expected: input check `[wrong_type(commissioner_requested_information_of_data_subject)]`; every query gives input_problems.
- **fixture_duplicate_and_unknown**
  - Keys: key 1 true and key 1 false (a repeated key), key 9 maybe, plus `attribute(severity, high)` twice.
  - Expected: `[duplicate_key(breach_of_data_security), wrong_type(breach_unlikely_to_result_in_risk), unknown_key(severity)]`.
- **fixture_not_attribute_list**
  - Profile: `[attribute(breach_of_data_security, true), foo]`.
  - Expected: `[wrong_type(profile)]`.

## Tests (seven modes, per-rule)

1. **load**: every module loads.
2. **unit**: one test per LIMB step (0 to 20), with a positive and a negative pair over the same case.
3. **fixtures**: every fixture against its expected answers. Answers are collected with findall and `length(Solutions, 1)` to enforce exactly one solution.
4. **properties**: validate_props totality, determinism and citation completeness (every final answer has its fixed list; every not-final answer has `[]`) over the 3^8 x 2 key-value grid plus absences.
5. **input check**: unbound profile, partial list, unbound element, non-atom key, unbound value, a repeated key with equal values, and unknown-key repetition.
6. **comparison**: same, differs and not_comparable, and the side-copy identity with each RESULT.
7. **what_if and checklist**: flipping key 2 turns not_required into required; the checklist has 4 items, each with cite provenance.
