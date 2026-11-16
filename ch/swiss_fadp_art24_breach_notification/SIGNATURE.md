# SIGNATURE — ch/swiss_fadp_art24_breach_notification

## Public query surface (overview)

The layout is kept as scaffolded: kernel -> citations -> parameters -> swiss_fadp_art24_breach_notification -> queries -> fixtures -> package facade. No file or module is renamed.

**The called contract** has six queries:

- (A) `swiss_controller_report_to_commissioner/3`
- (B) `swiss_processor_report_to_controller/3`
- (C) `swiss_information_of_data_subject/3`
- (D) `eu_controller_notification_to_supervisory_authority/3`
- (E) `compare_swiss_eu_authority_notification/5`
- (F) `swiss_fadp_art24_breach_notification_input_problems/2`

**The facade** keeps the scaffold names and adds the query types this domain must serve:

- `decide_swiss_fadp_art24_breach_notification/2`
- `swiss_fadp_art24_breach_notification_status/2`
- `swiss_fadp_art24_breach_notification_checklist/2` (#7 justification)
- `swiss_fadp_art24_breach_notification_what_if/4`
- `swiss_fadp_art24_breach_notification_obligations/2` (#14 obligation surfacing)
- `swiss_fadp_art24_breach_notification_fixture/2`
- `compare_swiss_eu_authority_notification/5` (#5 comparison)

The headline verdict is (A), the controller's report to the EDÖB.

**Guarantees.**

- **Totality.** Every query yields exactly ONE solution for every PROFILE term: unbound, partial list, non-list and malformed included.
- **Determinism.** Disjoint clause guards, with no `!`, `->`, `*->` or `once/1`. Ground outputs are folded into clause heads (C17).
- **No imported figures.** There are no numeric statutory values. Nothing is imported from another order, and nothing is re-declared.

## Verdict STATUS atoms (replace placeholder `{required, permitted, not_applicable}`)

**Final atoms.**

- Authority duties (A, D, facade headline): `authority_notification_required`, `authority_notification_not_required`.
- Processor duty (B): `report_to_controller_required`, `report_to_controller_not_required`.
- Information duty (C): `information_of_data_subject_required`, `information_of_data_subject_not_required`, `information_of_data_subject_may_be_restricted_deferred_or_omitted`.
- Comparison DIFFERENCE (E): `same`, `differs`, `not_comparable`.
- Obligation bearers (#14): `controller`, `processor`.
- Obligation actions (#14): `report_to_commissioner`, `report_to_controller`, `inform_data_subject`, `notify_eu_supervisory_authority`.

**Status compounds.** A not-final answer is the compound ITSELF in the answer position, never a list holding it. There are exactly three:

- `indeterminate([KEY])` holds exactly one bare key atom, the first needed absent key in root_exports order. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(KEY, cite(CITE)), [inputs_relied_on(PAIRS)])`. PAIRS is a flat list of `KEY-VALUE` terms: the present keys among the firing query's inputs, in root_exports order, with the unsure one included.
- `input_problems(PROBLEMS)` holds a non-empty flat list of `duplicate_key(KEY)`, `wrong_type(KEY)` and `unknown_key(KEY)` terms.

**Result constructors.** These are exported, never called as queries: `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## Profile keys (root_exports / input_contract order; nine, no others)

PROFILE is `[attribute(KEY, VALUE), ...]`, read ONLY with `profile_get/3`. Keys are bare atoms. Judgement values are `true | false | unsure`; the crisp value is `true | false`. There are no numeric or date keys.

1. `breach_of_data_security` — judgement — DSG Art 5 h
2. `breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights` — judgement — DSG Art 24(1)
3. `information_necessary_for_protection_of_data_subject` — judgement — DSG Art 24(4)
4. `commissioner_requested_information_of_data_subject` — CRISP — DSG Art 24(4)
5. `article_26_ground_or_statutory_secrecy_obligation_applies` — judgement — DSG Art 24(5)(a)
6. `information_impossible_or_requires_disproportionate_effort` — judgement — DSG Art 24(5)(b)
7. `information_ensured_comparably_by_public_announcement` — judgement — DSG Art 24(5)(c)
8. `personal_data_breach` — judgement — GDPR Art 33(1) (definition Art 4(12), not pinned)
9. `breach_unlikely_to_result_in_risk` — judgement — GDPR Art 33(1)

## Citation-key atoms (canonical lexicon scheme, `_lexicon/citations.yaml`; never shortened)

| Key | Unit | Cited in answers? |
|---|---|---|
| `ch_fadp_art_5_h` | `ch-fadp-sr-235-1-2025-07-07#art_5/para/lbl_h` | yes |
| `ch_fadp_art_24_1` | `#art_24/para_1` | yes |
| `ch_fadp_art_24_3` | `#art_24/para_3` | yes |
| `ch_fadp_art_24_4` | `#art_24/para_4` | yes |
| `ch_fadp_art_24_5` | `#art_24/para_5`, `#art_24/para_5/listintro` | yes |
| `ch_fadp_art_24_5_a` | `#art_24/para_5/lbl_a` | referral cite only |
| `ch_fadp_art_24_5_b` | `#art_24/para_5/lbl_b` | referral cite only |
| `ch_fadp_art_24_5_c` | `#art_24/para_5/lbl_c` | referral cite only |
| `eu_reg_2016_679_art_33_1` | `02016R0679-20160504#parag_033.001` | yes |
| `ch_fadp_art_60` | `#art_60/...` | no — deferred, provenance only |
| `ch_fadp_art_61` | `#art_61/...` | no — deferred, provenance only |

All eleven are in `citation_vocabulary`. They are declared once in `citations.clausal` as `swiss_fadp_art24_breach_notification_citation(KEY, UNIT_ID, SOURCE_SHA256)` facts. Each SOURCE_SHA256 is the file sha256 stated in the order.

## Public predicates (one line each)

- `swiss_fadp_art24_breach_notification_input_problems(Profile, Problems)`: THE INPUT CHECK. Problems is the BARE flat list (`[]` when well-formed), never wrapped. It never fails or raises and has one solution. Typed against `input_contract` + `citation_vocabulary` (no single article).
- `swiss_controller_report_to_commissioner(Profile, Result, Citations)`: limbs (0)–(4). Final Citations are `[cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_1)]`; DSG Art 5 h, Art 24(1).
- `swiss_processor_report_to_controller(Profile, Result, Citations)`: limbs (0), (5)–(8). Final Citations are `[cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_3)]`; DSG Art 5 h, Art 24(3).
- `swiss_information_of_data_subject(Profile, Result, Citations)`: limbs (0), (9)–(13). `not_required` cites `[cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4)]`. `required` and `may_be_restricted_deferred_or_omitted` cite `[cite(ch_fadp_art_5_h), cite(ch_fadp_art_24_4), cite(ch_fadp_art_24_5)]`. DSG Art 5 h, Art 24(4), (5).
- `eu_controller_notification_to_supervisory_authority(Profile, Result, Citations)`: limbs (0), (14)–(17). Final Citations are `[cite(eu_reg_2016_679_art_33_1)]`; GDPR Art 33(1).
- `compare_swiss_eu_authority_notification(Profile, SwissResult, EuResult, Difference, ChangedBy)`: comparison (#5), limbs (18)–(20). Each side is copied unchanged from its own query. ChangedBy is `[cite(ch_fadp_art_24_1), cite(eu_reg_2016_679_art_33_1)]` iff `differs`, else `[]`. DSG Art 24(1), GDPR Art 33(1).
- `decide_swiss_fadp_art24_breach_notification(Profile, swiss_fadp_art24_breach_notification_verdict(Status, Citations))`: the headline verdict. Status and Citations are exactly the Result and Citations of `swiss_controller_report_to_commissioner/3`; DSG Art 5 h, Art 24(1).
- `swiss_fadp_art24_breach_notification_status(Profile, Status)`: the Status of the headline verdict only (one atom or one status compound); DSG Art 24(1).
- `swiss_fadp_art24_breach_notification_checklist(Profile, Checklist)`: the justification (#7) of the headline verdict.
  - Checklist is `[item(breach_of_data_security, S1, cite(ch_fadp_art_5_h)), item(breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights, S2, cite(ch_fadp_art_24_1))]`.
  - Each S is `met` (true), `unmet(judged_false(KEY))` (false), `unknown([KEY])` (absent) or `unknown([KEY])` with referral marked as `unmet(needs_legal_review(KEY))` (unsure).
  - It is built by `eval_requirements/4` over a local `requirement/4`.
  - It is `[]` when input problems exist, because a malformed profile is never read.
- `swiss_fadp_art24_breach_notification_what_if(Profile, Key, Value, Status)`: the headline Status after `profile_set(Profile, attribute(Key, Value), NewProfile)`. With an unknown Key or a bad Value, the input check of NewProfile answers `input_problems(...)`. DSG Art 24(1).
- `swiss_fadp_art24_breach_notification_obligations(Profile, Obligations)`: obligation surfacing (#14). Obligations is the fixed four-element list below. Each element copies its query's single answer; with input problems each Result is `input_problems(P)` and each citation list is `[]`.
  - `duty(controller, report_to_commissioner, ResultA, CitationsA)`
  - `duty(processor, report_to_controller, ResultB, CitationsB)`
  - `duty(controller, inform_data_subject, ResultC, CitationsC)`
  - `duty(controller, notify_eu_supervisory_authority, ResultD, CitationsD)`
- `swiss_fadp_art24_breach_notification_fixture(FixtureName, Profile)`: named test profiles; see `fixtures.clausal` below.

## Planned reuse (manifest `uses:`)

**`formalize_lib`** — use these:

- `profile_get/3`: the only reader of values.
- `profile_lacks/2`: absence.
- `profile_set/3`: what_if. Verify that it REPLACES an existing attribute rather than appending.
- `eval_requirements/4`: checklist rows (avoids lint R1).
- `item/3`, `unmet/1`, `unknown/1`, `attribute/2`: constructors.

Do NOT use from `formalize_lib`:

- `assess/6` and `decide_labeled/3`, because the headline decision comes from the contract limbs, not from a labelled roll-up;
- `check_tri/4`, because it has no `unsure` state.

**`validate_props`** (tests only) — use these:

- `run_props/1`
- `prop_totality/3`
- `prop_determinism/3`: exactly one solution, by `findall` + `length(L, 1)`.
- `prop_citation_complete/3`
- `prop_missing_key_coverage/3`

**Not used, by design:**

| Module | Why not |
|---|---|
| `kit/deadline_lib`, `library(datetime)` | no deadline is read |
| `kit/compliance_lib` | the contract fixes its own statuses; a modality lattice would add a second decision path |
| `kit/query_combinators` `what_if/5` | it is dict-based (`override_key/4`) and the profile is an attribute list |
| `currency_vocab`, `vat_category`, `country` | no money, VAT or countries |

**`_common` family backbone.** None is needed. The tri-state reader and the input check are local (kernel) and noted in the working notes (not published) as candidates for a shared module.

## Module plan (shared floor and support files)

### kernel.clausal — the shared floor (used by the slice AND by queries)

Kernel holds ONLY the predicates shared between the slice and `queries.clausal`.

**`swiss_fadp_art24_breach_notification_contract_key(Position, Key, Type)`** — nine facts.

- Position runs 1..9 in root_exports order.
- Type is `judgement` or `crisp`.

**`swiss_fadp_art24_breach_notification_input_problems(Profile, Problems)`** — total, deterministic and `var`-safe.

Shape check:

- `var(Profile)` gives `[wrong_type(profile)]`.
- A non-list, a partial list, an unbound element, or any element not `attribute(_, _)` (tested with `nonvar` and `functor/3`) gives `[wrong_type(profile)]` alone.

Otherwise, walk the nine contract keys in order:

- a key occurring more than once (count with `==`) gives `duplicate_key(KEY)`;
- a key occurring once with a value outside its type (`var`, or not `==` to an allowed atom) gives `wrong_type(KEY)`.

Then append `unknown_key(KEY)` for each non-contract key: a non-atom (unbound included) or an atom outside the nine. These come in first-occurrence order, de-duplicated with `==`.

All branches are disjoint clauses guarded by `var/nonvar`, `atom`, `==` and `\==`.

**`swiss_fadp_art24_breach_notification_key_state(Profile, Key, State)`**

- State is `absent` (via `profile_lacks/2`), or `true`, `false` or `unsure` (via `profile_get/3`).
- It is called only on a problem-free profile, so it has exactly one solution.

**`swiss_fadp_art24_breach_notification_first_key_in_state(Profile, Keys, State, Key)`**

- It gives the first Key of the ordered list Keys whose state is State.
- It fails if there is none, which the caller guards.
- It is deterministic through a disjoint 'this key matches' / 'this key does not match' recursion.

**`swiss_fadp_art24_breach_notification_pairs(Profile, InputKeys, Pairs)`** — the PAIRS RULE.

- It gives `Key-Value` for each key of InputKeys present in the profile, in root_exports order.
- Absent keys are skipped.

### citations.clausal

It holds the eleven `swiss_fadp_art24_breach_notification_citation/3` facts. It contains no logic.

### parameters.clausal

It is intentionally EMPTY of statutory figures. A comment records that Art 24(1)/(3) give no number and that the EU 72 hours is not read (the deadline-only rounding scope, ruling 6 does not arise). No `constant_value` is declared, so none is inlined either.

### queries.clausal

It defines:

- `compare_swiss_eu_authority_notification/5`
- `swiss_fadp_art24_breach_notification_obligations/2`
- `swiss_fadp_art24_breach_notification_checklist/2`, with its local `requirement/4`: four disjoint clauses per key for true, false, unsure and absent
- `swiss_fadp_art24_breach_notification_what_if/4`
- `decide_swiss_fadp_art24_breach_notification/2`
- `swiss_fadp_art24_breach_notification_status/2`

The comparison is built from the slice's predicates:

- an input-problems clause (Problems `\== []`);
- otherwise one call to each side;
- then a disjoint `difference(SwissResult, EuResult, Difference, ChangedBy)` table with four rows:
  - both final and equal (`same`, `[]`);
  - both final and unequal (`differs`, the two threshold cites);
  - Swiss side a compound (`not_comparable`, `[]`);
  - Swiss side final and EU side a compound (`not_comparable`, `[]`).

A term is final iff it is one of the two authority atoms, tested by a fact table.

### fixtures.clausal

**Named fixture profiles** (`swiss_fadp_art24_breach_notification_fixture/2`):

| Fixture | Expected answers |
|---|---|
| `high_risk_breach_all_duties` | (A) required, (B) required, (C) required, (D) required, `same` |
| `breach_no_high_risk_eu_risk` | Swiss high-risk false, EU unlikely false: (A) not_required, (D) required, `differs` |
| `no_breach` | (A)/(B)/(C) not required |
| `information_commissioner_request_with_public_announcement` | (C) may_be_restricted_deferred_or_omitted (Q1) |
| `information_necessary_no_exception` | (C) required |
| `controller_missing_high_risk` | (A) `indeterminate([breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights])` |
| `controller_unsure_breach` | (A) `needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), [inputs_relied_on([breach_of_data_security-unsure, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights-true])])` |
| `information_exception_unsure` | (C) referral citing `ch_fadp_art_24_5_b` |
| `eu_unlikely_risk_settles_absent_breach` | (D) not_required |
| `swiss_and_eu_both_true_thresholds` | Q4 profile: `differs` |

**Malformed fixtures:**

- `duplicate_and_unknown_keys`: `[duplicate_key(breach_of_data_security), unknown_key(foo)]`
- `crisp_key_unsure`: `[wrong_type(commissioner_requested_information_of_data_subject)]`
- `not_an_attribute_list`: `[wrong_type(profile)]`

### Package facade

It re-exports the public predicates above plus the result constructors. It contains no logic.

## Slice: swiss_fadp_art24_breach_notification.clausal

This is the only determination slice. It is self-contained for the Art 24 duties and the EU comparison limb.

### Statutory VALUE facts it owns

It owns no numeric values, periods or tables. It owns these lookup facts:

**Input keys read by each query:**

- `query_inputs(controller_report, [breach_of_data_security, breach_likely_to_lead_to_high_risk_to_personality_or_fundamental_rights])`
- `query_inputs(processor_report, [breach_of_data_security])`
- `query_inputs(information_of_data_subject, [breach_of_data_security, information_necessary_for_protection_of_data_subject, commissioner_requested_information_of_data_subject, article_26_ground_or_statutory_secrecy_obligation_applies, information_impossible_or_requires_disproportionate_effort, information_ensured_comparably_by_public_announcement])`
- `query_inputs(eu_notification, [personal_data_breach, breach_unlikely_to_result_in_risk])`

**Referral citation by query and key** (`referral_citation(Query, Key, CiteKey)`):

- controller report:
  - `breach_of_data_security` -> `ch_fadp_art_5_h`
  - high-risk -> `ch_fadp_art_24_1`
- processor report:
  - `breach_of_data_security` -> `ch_fadp_art_5_h`
- information of the data subject:
  - `breach_of_data_security` -> `ch_fadp_art_5_h`
  - necessary -> `ch_fadp_art_24_4`
  - Art 26/secrecy -> `ch_fadp_art_24_5_a`
  - impossible/disproportionate -> `ch_fadp_art_24_5_b`
  - public announcement -> `ch_fadp_art_24_5_c`
- EU notification:
  - both keys -> `eu_reg_2016_679_art_33_1`

**Final-answer citation lists** (fixed per answer, Q10), folded into clause heads.

### Rules (each query: input-problem clause first, then disjoint state clauses; heads carry the ground result)

**Step 0 (every query).**

- If `input_problems(Profile, P)` with `P \== []`, the answer is `input_problems(P)` and `[]`.
- Every other clause requires `P == []`, then reads states via `key_state/3`.

**(A) `swiss_controller_report_to_commissioner/3`.** Let B and H be the states of the two keys.

| Case | Result | Citations |
|---|---|---|
| B = false | `authority_notification_not_required` | `[5_h, 24_1]` |
| B \= false, H = false | `authority_notification_not_required` | `[5_h, 24_1]` |
| B = true, H = true | `authority_notification_required` | `[5_h, 24_1]` |
| otherwise, first absent of [B, H] exists | `indeterminate([Key])` | `[]` |
| otherwise (none absent), first unsure | `needs_legal_review(open_textured(Key, cite(C)), [inputs_relied_on(Pairs)])` | `[]` |

The second row is the disjoint split of 'or'. In the needs_legal_review row, C comes from `referral_citation` and Pairs from `pairs/3` over `query_inputs(controller_report)`.

**(B) `swiss_processor_report_to_controller/3`.** Four disjoint clauses on B:

| B | Result |
|---|---|
| false | `report_to_controller_not_required`, citations `[5_h, 24_3]` |
| true | `report_to_controller_required`, citations `[5_h, 24_3]` |
| absent | `indeterminate([breach_of_data_security])` |
| unsure | `needs_legal_review(open_textured(breach_of_data_security, cite(ch_fadp_art_5_h)), [inputs_relied_on(Pairs)])` |

**(C) `swiss_information_of_data_subject/3`.**

GROUND state, from a disjoint table over (Necessary, Commissioner):

- `met` if Necessary = true, or Necessary \= true and Commissioner = true;
- `failed` if Necessary = false and Commissioner = false;
- `open` otherwise.

EXCEPTION state, from a disjoint table over the three exception keys:

- `held` if any is true (first-true split);
- `all_failed` if all are false;
- `open` otherwise.

Clauses, in order:

| Step | Case | Result | Citations |
|---|---|---|---|
| 9 | B = false | `information_of_data_subject_not_required` | `[5_h, 24_4]` |
| 9 | B \= false, GROUND failed | `information_of_data_subject_not_required` | `[5_h, 24_4]` |
| 10 | B = true, GROUND met, EXCEPTION held | `information_of_data_subject_may_be_restricted_deferred_or_omitted` | `[5_h, 24_4, 24_5]` |
| 11 | B = true, GROUND met, EXCEPTION all_failed | `information_of_data_subject_required` | `[5_h, 24_4, 24_5]` |
| 12 | otherwise, NEEDED not empty | `indeterminate([first of NEEDED])` | `[]` |
| 13 | otherwise, first unsure of REVIEWABLE | `needs_legal_review(open_textured(Key, cite(C)), [inputs_relied_on(Pairs)])` | `[]` |

NEEDED (step 12), in root_exports order, is built from:

- B if absent;
- if GROUND \= met: Necessary if absent and Commissioner if absent;
- if EXCEPTION \= held: each absent exception key.

REVIEWABLE (step 13) is:

- B;
- Necessary if GROUND \= met;
- the three exception keys if EXCEPTION \= held.

The crisp Commissioner key is never unsure.

The guards are exhaustive: whenever steps 9–12 do not fire, some reviewable key is unsure. Tests check this by enumerating all 4^5 × 3 state combinations (B, Necessary, the three exceptions at four states each; Commissioner at absent/true/false).

**(D) `eu_controller_notification_to_supervisory_authority/3`.** Let PDB be the state of `personal_data_breach` and U the state of `breach_unlikely_to_result_in_risk`.

| Case | Result | Citations |
|---|---|---|
| PDB = false | `authority_notification_not_required` | `[eu_reg_2016_679_art_33_1]` |
| PDB \= false, U = true | `authority_notification_not_required` | `[eu_reg_2016_679_art_33_1]` |
| PDB = true, U = false | `authority_notification_required` | `[eu_reg_2016_679_art_33_1]` |
| first absent | `indeterminate([Key])` | `[]` |
| first unsure | `needs_legal_review(open_textured(Key, cite(eu_reg_2016_679_art_33_1)), [inputs_relied_on(Pairs)])` | `[]` |

### Verdict atoms of this slice

- `authority_notification_required`, `authority_notification_not_required`
- `report_to_controller_required`, `report_to_controller_not_required`
- `information_of_data_subject_required`, `information_of_data_subject_not_required`, `information_of_data_subject_may_be_restricted_deferred_or_omitted`
- the three status compounds

### Predicates SHARED with other modules (live in kernel.clausal, not here)

- `swiss_fadp_art24_breach_notification_input_problems/2`
- `swiss_fadp_art24_breach_notification_key_state/3`
- `swiss_fadp_art24_breach_notification_first_key_in_state/4`
- `swiss_fadp_art24_breach_notification_pairs/3`
- `swiss_fadp_art24_breach_notification_contract_key/3`

Everything else above is local to this slice. The four limb predicates are exported through the facade.

### Per-rule tests (seven modes)

1. **Unit per limb.** One positive test per row (0)–(20), each paired with a negative test over the same case.
2. **Exactly-one-solution.** `findall` + `length(L, 1)` for every query over every fixture. This includes both-false profiles such as B = false with H = false, and PDB = false with U = true.
3. **Totality.** Enumerate the full state space per query with `prop_totality`.
4. **Citation completeness.** Final answers carry their fixed lists; not-final answers carry `[]`; every cite is in `citation_vocabulary`.
5. **Missing-key precedence.** the first-missing-key rule first-missing behaviour; a missing key beats an unsure judgement.
6. **Input check.** Duplicates, wrong types, unknown keys (including unbound and non-atom keys), unbound and partial profiles, unbound values, and the exact problem order; the input check never raises.
7. **Fixtures/golden.** Including comparison `same` / `differs` / `not_comparable` and the obligations list.
