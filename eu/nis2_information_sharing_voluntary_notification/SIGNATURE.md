# SIGNATURE — eu/nis2_information_sharing_voluntary_notification

## Public query surface

The package layout is kept as scaffolded:

`kernel -> citations -> parameters -> nis2_information_sharing_voluntary_notification -> queries -> fixtures -> package facade`

**The called contract (non-negotiable):**
- `voluntary_notification_possible(Profile, Result, Citations)`
- `information_exchange_permitted(Profile, Result, Citations)`
- `arrangement_notification_duty(Profile, Result, Citations)`
- `nis2_information_sharing_voluntary_notification_input_problems(Profile, Problems)`

**The scaffold facade:**
- `decide_nis2_information_sharing_voluntary_notification(Profile, nis2_information_sharing_voluntary_notification_verdict(Status, Citations))`
- `nis2_information_sharing_voluntary_notification_status(Profile, Status)`

**Determinism.** Every query yields EXACTLY ONE solution for every ground profile. Each is written as disjoint clauses, with ground answers folded into the head (C17). There is no cut, no `->` and no `once/1`. The scorer counts duplicates.

**Imported figures.** No figure is imported, and none is re-declared. The order has no numeric thresholds, periods or money.

## Verdict STATUS atoms (replacing `required / permitted / not_applicable`)

### Facade eligibility STATUS (query type #2)

| Atom | Meaning |
|---|---|
| `eligible` | A voluntary notification can be submitted under Art 30(1). |
| `ineligible` | A voluntary notification cannot be submitted under Art 30(1). |
| `eligibility_undetermined` | The Art 30(1) answer is `indeterminate/1` or `input_problems/1`. |

The bare atom `indeterminate` is NEVER used, which avoids the atom-shadowing trap.

### Determination answer atoms (the called contract)

- `voluntary_notification_possible/3`: `voluntary_notification_possible`, `voluntary_notification_not_possible`.
- `information_exchange_permitted/3`: `information_exchange_permitted`, `information_exchange_not_permitted`.
- `arrangement_notification_duty/3`: `must_notify_on_entering`, `must_notify_on_withdrawal_taking_effect`, `no_notification_duty`.

### Status compounds (exact functors and arities)

- `indeterminate(MissingKeys)`: a flat non-empty list of bare key atoms, in root_exports order, with no duplicates.
- `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])`: an optional trailing `provenance(Clause, Citations)` may follow, and it is unscored.
- `input_problems(Problems)`.
- The problem terms `unknown_key(Key)`, `wrong_type(Key)` and `duplicate_key(Key)`.

These are all exported as result constructors and are never called as queries.

## Profile keys (seven, in root_exports / input_contract order)

PROFILE is `[attribute(Key, Value), ...]`, read ONLY with `profile_get/3`. There are no numeric keys, no dates and no crisp keys.

| # | Key | Type | Values | Source |
|---|---|---|---|---|
| 1 | `entity_class` | enumeration | `essential_entity`, `important_entity`, `out_of_scope` | Art 30(1), Art 29(4) |
| 2 | `event_kind` | enumeration | `incident`, `significant_incident`, `cyber_threat`, `near_miss` | Art 30(1) |
| 3 | `arrangement_event` | enumeration | `entered`, `withdrew`, `no_arrangement_event` | Art 29(4) |
| 4 | `information_is_relevant_cybersecurity_information` | judgement | `true`, `false`, `unsure` | Art 29(1) |
| 5 | `sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact` | judgement | `true`, `false`, `unsure` | Art 29(1)(a) |
| 6 | `sharing_enhances_the_level_of_cybersecurity` | judgement | `true`, `false`, `unsure` | Art 29(1)(b) |
| 7 | `arrangement_is_a_cybersecurity_information_sharing_arrangement` | judgement | `true`, `false`, `unsure` | Art 29(2) and (4) |

**Not typed (reading 7):** `entity_in_scope`, `mandatory_under_art_23`, `notified_authority_of_arrangement_event`. Each of these is an `unknown_key(Key)` if supplied.

## Citation-key atoms (canonical lexicon; citations.clausal)

| Citation key | Unit | Role |
|---|---|---|
| `eu_dir_2022_2555_art_29_1` | parag_029.001 | Answers of `information_exchange_permitted/3`; referral on key 4. |
| `eu_dir_2022_2555_art_29_1_a` | point_029.001_a | Referral on key 5. |
| `eu_dir_2022_2555_art_29_1_b` | point_029.001_b | Referral on key 6. |
| `eu_dir_2022_2555_art_29_2` | parag_029.002 | Referral on key 7. |
| `eu_dir_2022_2555_art_29_4` | parag_029.004 | Answers of `arrangement_notification_duty/3`. |
| `eu_dir_2022_2555_art_30_1_a` | point_030.001_a | Answers of `voluntary_notification_possible/3`. |
| `eu_dir_2022_2555_art_30_1_b` | point_030.001_b | Answers of `voluntary_notification_possible/3`. |

Art 30(2) [parag_030.002] is recorded in the deferred set (debt). No query cites it.

## Public predicates (one line each)

- `voluntary_notification_possible(Profile, Result, Citations)`: whether a voluntary notification of the event can be submitted, per limbs 0–3 — Art 30(1)(a), Art 30(1)(b).
- `information_exchange_permitted(Profile, Result, Citations)`: whether the voluntary exchange is one the Member States must let entities carry out, per limbs 0 and 4–7 — Art 29(1), (1)(a), (1)(b).
- `arrangement_notification_duty(Profile, Result, Citations)`: whether an essential or important entity must notify the competent authorities of entering or withdrawing, per limbs 0 and 8–11 — Art 29(4), Art 29(2).
- `nis2_information_sharing_voluntary_notification_input_problems(Profile, Problems)`: THE INPUT CHECK; returns the BARE flat list of problem terms, `[]` when well-formed — input_contract.
- `decide_nis2_information_sharing_voluntary_notification(Profile, Verdict)`: eligibility verdict `nis2_information_sharing_voluntary_notification_verdict(Status, Citations)` with Status from {`eligible`, `ineligible`, `eligibility_undetermined`}, derived from `voluntary_notification_possible/3`; Citations are that query's citations — Art 30(1)(a)/(b).
- `nis2_information_sharing_voluntary_notification_status(Profile, Status)`: the Status of the decide verdict alone — Art 30(1).
- `nis2_information_sharing_voluntary_notification_checklist(Profile, Checklist)`: justification (query type #7); see below — Arts 29(1), 29(4), 30(1).
- `nis2_information_sharing_voluntary_notification_what_if(Profile, Key, Value, Verdict)`: the decide verdict after overriding Key with Value — Art 30(1).
- `nis2_information_sharing_voluntary_notification_fixture(Name, Profile)`: the named fixture profiles (fixtures.clausal).
- `nis2_information_sharing_voluntary_notification_fixture_expected(Name, Query, Result, Citations)`: the expected answer per fixture and query (fixtures.clausal).

### The checklist

`nis2_information_sharing_voluntary_notification_checklist(Profile, Checklist)` is a flat list of three `item(Id, Status, Citation)` terms, with Id in this order:
1. `voluntary_notification`
2. `information_exchange`
3. `arrangement_notification`

Item Status maps each determination's answer as follows:

| Determination answer | Item Status |
|---|---|
| positive answer (possible / permitted / a `must_notify_*` atom) | `met` |
| negative answer | `unmet(Answer)` |
| `indeterminate(Keys)` | `unknown(Keys)` |
| `needs_legal_review(open_textured(Key, _), _)` | `unknown([Key])` |
| `input_problems(_)` | `unknown([profile])` |

Item Citation:
- If the answer's Citations list is non-empty, it is that list.
- Otherwise, for a referral, it is the referral's `cite(Key)`.
- Otherwise it is `cite(Key)` of the determination's head article (`art_30_1_a`, `art_29_1`, `art_29_4`).

Every item, met items included, carries `cite(...)`.

### What-if

`nis2_information_sharing_voluntary_notification_what_if/4` calls `what_if(Profile, Key, Value, decide_nis2_information_sharing_voluntary_notification, Verdict)` from kit.query_combinators. The decide predicate is passed as a closure.

## Planned reuse (manifest `uses:`)

### formalize_lib

Planned imports:
- `profile_get/3`: the ONLY profile reader, used for presence and value.
- `profile_has/2`, `profile_lacks/2`.
- `missing_keys/3`: called with the root_exports-ordered key list, so MISSING_KEYS come out in that order.
- `memberd/2`, `not_member/2`.
- `item/3`, `unknown/1`, `unmet/1`, `attribute/2`: constructors, plus the `met` vocabulary atom.

`check_tri/4` was considered for the judgement keys, but it is not used: the contract needs the 3+1-way split (true / false / unsure / absent) and the exact referral shape. To avoid C15, the split is written as head-unified `profile_get` matches, not as a clone of `check_tri`.

### kit.query_combinators

Planned import: `what_if/5`, for the what_if facade.

### validate_props (tests only)

Planned imports: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.

The tests enumerate every profile over the key domains, each key either absent or holding each of its values. They check that each query has exactly one solution, and that every cite atom is in `citation_vocabulary`.

### Not used

- **kit.compliance_lib.** The called contract fixes the answer atoms and precedence. A deny-overrides modality lattice would add nothing and could yield more than one solution.
- **kit.deadline_lib.** There is no time limit (Q4).
- **date_time, rolling_window, currency_vocab, vat_category.** Not relevant. The `vat_category` atom `out_of_scope` coincides in spelling with the `entity_class` atom but is unrelated, and needs no import.

## Kernel (kernel.clausal) — the shared floor

There is one determination slice. The kernel holds only what the queries, fixtures and facade modules also need:

- `contract_key(Position, Key)`: the seven keys with Position 1..7, in root_exports order.
- `contract_key_type(Key, Type)`: each key's Type, either `judgement` or `enumeration(Atoms)`. The atoms are those listed in the profile key table.
- `nis2_information_sharing_voluntary_notification_input_problems/2` (THE INPUT CHECK), implemented as follows:
  - A non-list, or a list with any element not `attribute(Key, Value)`, gives `[wrong_type(profile)]` alone.
  - Otherwise, for each contract key in Position order:
    - `duplicate_key(Key)` if `findall(Value, profile_get(Profile, Key, Value), Values)` has length ≥ 2. No value is inspected, so a duplicated key is never also `wrong_type`.
    - Otherwise `wrong_type(Key)` if its single present value is not of its type.
  - Then `unknown_key(Key)` once per non-contract key, in order of first occurrence, deduplicated.
  - Absence is never a problem. There is no `missing_key` term.
- `profile_problems_gate(Profile, Problems)`: binds the problem list once. Each query's limb 0 is `Problems \= []` with head answer `input_problems(Problems)` and `[]`. The other limbs require `Problems = []`, which keeps every query to one solution.
- `present_pairs(Profile, Keys, Pairs)`: THE PAIRS RULE. It gives `Key-Value` for each key of Keys that is present, in root_exports order, the unsure one included.

## Slice: nis2_information_sharing_voluntary_notification.clausal

This slice is self-contained. It owns all three determinations, their value facts, their per-rule tests, the checklist and the verdict.

### Statutory VALUE facts owned by this slice

There are no numbers, periods or money; `parameters.clausal` keeps no threshold. The slice declares these facts:

**Notifying groups and their events.** The fact `point_a_entity_class(Class)` holds for `essential_entity` and `important_entity`. Art 30(1)(a) is read as 'all event kinds', so no event table is needed for point (a).

**Point (b) event kinds (Art 30(1)(b)).** `point_b_notifiable_event_kind(Kind)` holds for `significant_incident`, `cyber_threat` and `near_miss`. `point_b_not_notifiable_event_kind(incident)` marks the one kind point (b) excludes (Q2).

**Referral rows.** `referral_row(Query, Input, Citation, Inputs)`:
- `referral_row(information_exchange_permitted, information_is_relevant_cybersecurity_information, eu_dir_2022_2555_art_29_1, [R, A, B])`
- `referral_row(information_exchange_permitted, sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact, eu_dir_2022_2555_art_29_1_a, [R, A, B])`
- `referral_row(information_exchange_permitted, sharing_enhances_the_level_of_cybersecurity, eu_dir_2022_2555_art_29_1_b, [R, A, B])`
- `referral_row(arrangement_notification_duty, arrangement_is_a_cybersecurity_information_sharing_arrangement, eu_dir_2022_2555_art_29_2, [arrangement_is_a_cybersecurity_information_sharing_arrangement])`

Here R, A and B are written out as keys 4, 5 and 6 in full; they are abbreviations in this document only. `voluntary_notification_possible/3` has no referral row.

**Arrangement event answers.** `arrangement_event_answer(Event, Answer)`:
- `arrangement_event_answer(entered, must_notify_on_entering)`
- `arrangement_event_answer(withdrew, must_notify_on_withdrawal_taking_effect)`

### Rules / requirements (disjoint clauses; limb numbers from THE LIMBS)

#### voluntary_notification_possible/3

- **V0** — Problems non-empty: `input_problems(Problems)`, `[]`.
- **V1** — `entity_class` is `essential_entity` or `important_entity`: `voluntary_notification_possible`, `[cite(eu_dir_2022_2555_art_30_1_a)]`. `event_kind` is not read.
- **V2a** — `entity_class` is `out_of_scope` and `event_kind` is a point (b) notifiable kind: `voluntary_notification_possible`, `[cite(eu_dir_2022_2555_art_30_1_b)]`.
- **V2b** — `entity_class` is absent and `event_kind` is a point (b) notifiable kind: `voluntary_notification_possible`, `[cite(eu_dir_2022_2555_art_30_1_a), cite(eu_dir_2022_2555_art_30_1_b)]`.
- **V3a** — `entity_class` is `out_of_scope` or absent, and `event_kind` is `incident` or absent, and at least one of the two is absent: `indeterminate(Missing)`, `[]`. Missing comes from `missing_keys(Profile, [entity_class, event_kind], Missing)`. The possible results are:
  - `[entity_class]` (class absent, event `incident`);
  - `[event_kind]` (class `out_of_scope`, event absent);
  - `[entity_class, event_kind]` (both absent).
- **V3b** — `entity_class` is `out_of_scope` and `event_kind` is `incident`: `voluntary_notification_not_possible`, `[cite(eu_dir_2022_2555_art_30_1_b)]`.

#### information_exchange_permitted/3

R is `information_is_relevant_cybersecurity_information`, A is `sharing_aims_to_prevent_detect_respond_to_or_recover_from_incidents_or_mitigate_their_impact`, and B is `sharing_enhances_the_level_of_cybersecurity`.

- **E0** — Problems non-empty: `input_problems(Problems)`, `[]`.
- **E4a** — R is `false`: `information_exchange_not_permitted`, `[cite(eu_dir_2022_2555_art_29_1)]`.
- **E4b** — R is not `false` (true, unsure or absent), A is `false` and B is `false`: `information_exchange_not_permitted`, `[cite(eu_dir_2022_2555_art_29_1)]`. E4a and E4b are disjoint, so there is a single solution even when R is `false` and A and B are both `false`.
- **E5a** — R is `true` and A is `true`: `information_exchange_permitted`, `[cite(eu_dir_2022_2555_art_29_1)]`.
- **E5b** — R is `true`, A is not `true` and B is `true`: `information_exchange_permitted`, `[cite(eu_dir_2022_2555_art_29_1)]`.
- **E6** — Not E4 and not E5, and Needed is non-empty: `indeterminate(Needed)`, `[]`. Needed is built in root_exports order as follows:
  - R is in it if R is absent.
  - A is in it if A is absent and neither A nor B is `true`.
  - B is in it if B is absent and neither A nor B is `true`.
  - This applies whether or not any judgement is unsure.
- **E7a** — Not E4 or E5, Needed is empty, and R is `unsure`: `needs_legal_review(open_textured(information_is_relevant_cybersecurity_information, cite(eu_dir_2022_2555_art_29_1)), [inputs_relied_on(Pairs)])`, `[]`.
- **E7b** — Not E4 or E5, Needed is empty, R is `true`, and A is `unsure`: open_textured on A with `cite(eu_dir_2022_2555_art_29_1_a)`, `[]`.
- **E7c** — Not E4 or E5, Needed is empty, R is `true`, A is `false` and B is `unsure`: open_textured on B with `cite(eu_dir_2022_2555_art_29_1_b)`, `[]`.

For E7a–E7c, Pairs is `present_pairs(Profile, [R, A, B], Pairs)`.

#### arrangement_notification_duty/3

K is `arrangement_is_a_cybersecurity_information_sharing_arrangement`.

- **N0** — Problems non-empty: `input_problems(Problems)`, `[]`.
- **N8a** — `entity_class` is `out_of_scope`: `no_notification_duty`, `[cite(eu_dir_2022_2555_art_29_4)]`.
- **N8b** — `entity_class` is not `out_of_scope`, and `arrangement_event` is `no_arrangement_event`: `no_notification_duty`, `[cite(eu_dir_2022_2555_art_29_4)]`.
- **N8c** — Neither of the above, and K is `false`: `no_notification_duty`, `[cite(eu_dir_2022_2555_art_29_4)]`. N8a, N8b and N8c are written disjoint, so there is a single solution.
- **N9** — No N8 decider holds, and at least one of `entity_class`, `arrangement_event`, K is absent: `indeterminate(Missing)`, `[]`. Missing comes from `missing_keys(Profile, [entity_class, arrangement_event, K], Missing)`. This applies even when K is `unsure`.
- **N10** — All three keys are present, and K is `unsure`: `needs_legal_review(open_textured(K, cite(eu_dir_2022_2555_art_29_2)), [inputs_relied_on([K-unsure])])`, `[]`.
- **N11** — `entity_class` is `essential_entity` or `important_entity`, K is `true`, and `arrangement_event` is `entered` or `withdrew`: the Answer from `arrangement_event_answer`, with `[cite(eu_dir_2022_2555_art_29_4)]`.

### Slice verdict atoms

- **Determinations:** the contract atoms and status compounds above.
- **Facade mapping:** `eligibility_status_of(VoluntaryResult, Status)`, with Status in {`eligible`, `ineligible`, `eligibility_undetermined`}. It is one head-unified clause per result shape.
- **Checklist mapping:** `checklist_item_of(Id, Result, Citations, Item)`, one head-unified clause per result shape.

### Shared with another slice

None. This is the only slice. It uses these kernel predicates: `contract_key/2`, `contract_key_type/2`, `profile_problems_gate/2`, `present_pairs/3` and the input check.

### Per-rule tests (tests/, seven modes)

**Positive tests.** One positive test per limb clause, V1 through N11, each with `findall` and `length(Results, 1)` plus an exact answer and citation match. The cases include:
- an `essential_entity` with `event_kind` absent gives possible / art_30_1_a;
- an absent class with `near_miss` gives possible with both citations;
- `out_of_scope` with `incident` gives not possible.

**Paired negative tests:**
- an `out_of_scope` entity with `incident` is NOT possible;
- R `true`, A `false`, B `false` is NOT permitted;
- an `important_entity` with K `false` has NO duty.

**Precedence tests:**
- R `unsure` with A and B absent gives `indeterminate([A, B])`, not a referral.
- R `false` with B `unsure` gives `information_exchange_not_permitted`.
- `entity_class` absent, `arrangement_event` `entered` and K `unsure` give `indeterminate([entity_class])`.

**Input-check tests:**
- a duplicated key with differing values gives `[duplicate_key(Key)]` only;
- a bad enumeration atom gives `wrong_type`;
- `entity_in_scope` gives `unknown_key`;
- `[foo]` gives `[wrong_type(profile)]`;
- the problem order follows the contract key order, then first occurrence.

**Property tests:** totality, determinism and citation completeness over the full key-domain enumeration, using validate_props.

**Facade tests:** decide, status, checklist (three items, each with a cite) and what_if. One what_if test flips `entity_class` from `out_of_scope` to `essential_entity` and checks that `ineligible` becomes `eligible`.
