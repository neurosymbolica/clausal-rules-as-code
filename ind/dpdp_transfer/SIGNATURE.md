# SIGNATURE — ind/dpdp_transfer

## Public query surface

The scored contract has two predicates:

- `restriction_status(Restriction, Profile, Result, Citations)`
- `dpdp_transfer_input_problems(Profile, Problems)`

`Restriction` is host-supplied, is one of `notified_destination` or `foreign_state_requirements`, and is never checked.

The scaffold facade wraps the contract. Its 2-ary names need one request term carrying both the restriction and the profile:

- The request term is `restriction_request(Restriction, Profile)`.
- The facade verdict is `dpdp_transfer_verdict(Result, Citations)`.

Every public query yields exactly ONE solution, so it is total and deterministic, and a duplicate answer counts as a refutation.

The package holds no imported figures. Its only statutory value, the rule 15 start date, is declared once in the slice file.

## Verdict STATUS atoms (replace the placeholders)

Final results:

- `restricted_see_notification`: notified_destination only.
- `requirements_apply_see_order`: foreign_state_requirements only.
- `not_restricted`
- `not_in_force`

Non-final results always carry citations `[]`. Each is exactly one of:

- `indeterminate([Key])`: a list of exactly one bare key. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`
- `input_problems(Problems)`

The eligibility mapping (query type #2) is reporting only, and the ladder governs:

| Eligibility label | Results |
|---|---|
| positive ('the restriction reaches the transfer') | `restricted_see_notification`, `requirements_apply_see_order` |
| negative | `not_restricted`, `not_in_force` |
| indeterminate | `indeterminate/1`, `needs_legal_review/2`, `input_problems/1` |

## Profile keys

The profile is an attribute list `[attribute(Key, Value), ...]`. It is read only with `profile_get/3`, and absence is tested with `profile_lacks/2`. The keys are listed here in root_exports and input_contract order.

| # | Key | Kind | Values | Short name |
|---|---|---|---|---|
| 1 | `section_16_in_force_on_reference_date` | crisp | `true` or `false` | F |
| 2 | `destination_restricted_by_notification` | judgement | `true`, `false` or `unsure` | N |
| 3 | `reference_date` | date | ground `date(Year, Month, Day)`; bare integers; Year at least 1; a real Gregorian day | D |
| 4 | `recipient_is_foreign_state_or_its_entity` | judgement | `true`, `false` or `unsure` | G |
| 5 | `foreign_state_requirements_specified` | crisp | `true` or `false` | R |

There are no money or numeric keys, so no unit suffix is needed. There are no attested envelopes.

## Citation-key atoms (canonical lexicon, `_lexicon/citations.yaml`; never shortened)

- `in_dpdp_act_2023_s_16_1`: Act s 16(1), the notified restriction.
- `in_dpdp_act_2023_s_16_2`: Act s 16(2), other laws saved.
- `in_dpdp_rules_2025_r_15`: Rules rule 15, the foreign State requirements.
- `in_dpdp_rules_2025_r_1_4`: Rules rule 1(4), the commencement of rule 15.

The segments `s` and `r` are part of the canonical lexicon keys. They are not abbreviations introduced here; if C6 queries them, record a `% lint:` pragma citing the lexicon.

Citations are a set-like list of `cite(Key)`.

## Public predicates

- `restriction_status(Restriction, Profile, Result, Citations)`: Gives the ladder of the restriction (below); exactly one solution. Cites s 16(1), s 16(2), rule 15 and rule 1(4) per step.
- `dpdp_transfer_input_problems(Profile, Problems)`: The typed input check. It gives `[]` when the profile is well-formed, else the ordered problem list. It never fails or raises and has one solution. No citation.
- `decide_dpdp_transfer(Request, Verdict)`: Request is `restriction_request(Restriction, Profile)`. Verdict is `dpdp_transfer_verdict(Result, Citations)`, delegating to `restriction_status/4`. Same citations.
- `dpdp_transfer_status(Request, Status)`: The Result of `restriction_status/4` alone. Same citations.
- `dpdp_transfer_checklist(Request, Checklist)`: The justification checklist (query type #7). Each item is `item(RequirementId, Status, cite(Key))`, with Status one of `met`, `unmet(Reason)` or `unknown([Key])`. It is `[]` when there are input problems. Each item carries its own cite.
- `dpdp_transfer_what_if(Request, Key, Value, Verdict)`: Re-decides with Key overridden to Value. It uses `what_if/5` with the closure `restriction_verdict_for(Restriction)`; if `what_if/5` turns out to need a dict, it uses `profile_set/3` instead. Cites as `decide_dpdp_transfer/2`.
- `dpdp_transfer_fixture(Name, Request, ExpectedResult, ExpectedCitations)`: Named worked cases, one or more per ladder step plus boundary and input-problem cases.
- Result constructors are exported and never queried: `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `inputs_relied_on/1`, `provenance/2`.

## Planned reuse (manifest `uses:`)

- **`formalize_lib`:**
  - `profile_get/3`, `profile_lacks/2`, `profile_has/2`
  - `check_true/4` (crisp checklist items)
  - `check_tri/4` (judgement checklist items: true gives met, false gives unmet, unsure or absent gives unknown)
  - `item/3`, `unmet/1`, `unknown/1`, `attribute/2`, `profile_set/3`
- **`kit/deadline_lib`:**
  - `date_before/2` and `date_on_or_after/2`, for the rule 15 start comparison. These are native date comparison; there is no hand-rolled day count and no other date arithmetic.
  - `month_last_day/3`, for the real-day check of `reference_date`.
- **`kit/query_combinators`:** `what_if/5`.
- **`validate_props`:** `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- **Not used:** `assess/6`, `eval_requirements/4` and `decide_labeled/3` are not used for the verdict. The law is a first-applicable ladder whose priorities a conjunctive classifier would break; for example, with F absent and N false the ladder names F, while a conjunctive classifier would say negative. The checklist is justification only.
- **No `_common` deontic backbone predicates** are needed beyond these.

## Package files (layout unchanged)

`kernel -> citations -> parameters -> dpdp_transfer -> queries -> fixtures -> package facade`

- **`kernel.clausal`.** The shared floor, holding only what precedes every determination:
  - The profile contract: key list and kinds.
  - The input check: `dpdp_transfer_input_problems/2`, plus its helpers `contract_key/2`, `value_has_type/2` and `real_gregorian_day/1`.
  - The result constructors.
- **`citations.clausal`.** The citation vocabulary: the four keys above as facts, each with its pinned-unit id (`in-dpdp-act-2023-meity-pdf#s16_1`, `#s16_2`, `in-dpdp-rules-2025-meity-pdf#r15`, `#r1_4`) and source note.
- **`parameters.clausal`.** No figures (they live in the slice). It only records that the order holds no list of notified destinations and no list of requirements.
- **`dpdp_transfer.clausal`.** The one determination slice (below).
- **`queries.clausal`.** `restriction_status/4` (input check, then the slice ladder) and the facade predicates.
- **`fixtures.clausal`.** `dpdp_transfer_fixture/4`.

## Slice: dpdp_transfer.clausal

### Value facts owned

- `:- constant_value(rule_15_commencement_date, date(2027, 5, 13)).` This is CALCULATED by the drafter from rule 1(4) (MAIN READING, Q4) and read with `constant(rule_15_commencement_date)`.
- `:- constant_value(rules_2025_gazette_publication_date, date(2025, 11, 13)).` Documentation; the date is from the pin label's Hindi header.
- `:- constant_value(rule_15_commencement_period_months, 18).` Documentation.

### Shared predicates

The slice shares nothing with another slice. It consumes `dpdp_transfer_input_problems/2` from the kernel, via queries.

### Verdict atoms

`restricted_see_notification`, `requirements_apply_see_order`, `not_restricted`, `not_in_force`, plus the statuses.

### Calling convention

The slice predicate is `restriction_ladder(Restriction, Profile, Result, Citations)`. It is called only when the problems list is `[]`, so each key appears at most once with a value of its type.

There is one clause per disjoint route, with the result and citations in the head, and only positive guards. Each clause's guards exclude every earlier step.

### Ladder notified_destination (s 16(1) with s 16(2)): 6 clauses

| Step | Guard | Result | Citations |
|---|---|---|---|
| 1 | F = false | `not_in_force` | `[cite(in_dpdp_act_2023_s_16_1)]` |
| 2 | F absent | `indeterminate([section_16_in_force_on_reference_date])` | `[]` |
| 3 | F = true, N = false | `not_restricted` | `[cite(in_dpdp_act_2023_s_16_1), cite(in_dpdp_act_2023_s_16_2)]` |
| 4 | F = true, N absent | `indeterminate([destination_restricted_by_notification])` | `[]` |
| 5 | F = true, N = unsure | `needs_legal_review(open_textured(destination_restricted_by_notification, cite(in_dpdp_act_2023_s_16_1)), [inputs_relied_on([destination_restricted_by_notification-unsure])])` | `[]` |
| 6 | F = true, N = true | `restricted_see_notification` | `[cite(in_dpdp_act_2023_s_16_1)]` |

D, G and R are never read.

### Ladder foreign_state_requirements (rule 15 with rule 1(4) and s 16)

Start is `constant(rule_15_commencement_date)`. 'D before' means `date_before(D, Start)`. 'D on or after' means `date_on_or_after(D, Start)`.

The not_in_force citations, NIF, are `[cite(in_dpdp_rules_2025_r_15), cite(in_dpdp_rules_2025_r_1_4), cite(in_dpdp_act_2023_s_16_1)]`.

| Step | Guard | Result | Citations |
|---|---|---|---|
| 1 | F = false (any D) | `not_in_force` | NIF |
| 2a | F = true, D before | `not_in_force` | NIF |
| 2b | F absent, D before | `not_in_force` | NIF |
| 3a | F absent, D absent | `indeterminate([section_16_in_force_on_reference_date])` | `[]` |
| 3b | F absent, D on or after | `indeterminate([section_16_in_force_on_reference_date])` | `[]` |
| 4 | F = true, D absent | `indeterminate([reference_date])` | `[]` |

The remaining steps all hold F = true and D on or after; the guard column shows only G and R.

| Step | Guard | Result | Citations |
|---|---|---|---|
| 5 | G = false (any R) | `not_restricted` | `[cite(in_dpdp_rules_2025_r_15)]` |
| 6a | G = true, R = false | `not_restricted` | `[cite(in_dpdp_rules_2025_r_15)]` |
| 6b | G = unsure, R = false | `not_restricted` | `[cite(in_dpdp_rules_2025_r_15)]` |
| 6c | G absent, R = false | `not_restricted` | `[cite(in_dpdp_rules_2025_r_15)]` |
| 7a | G absent, R = true | `indeterminate([recipient_is_foreign_state_or_its_entity])` | `[]` |
| 7b | G absent, R absent | `indeterminate([recipient_is_foreign_state_or_its_entity])` | `[]` |
| 8a | G = true, R absent | `indeterminate([foreign_state_requirements_specified])` | `[]` |
| 8b | G = unsure, R absent | `indeterminate([foreign_state_requirements_specified])` | `[]` |
| 9 | G = unsure, R = true | `needs_legal_review(open_textured(recipient_is_foreign_state_or_its_entity, cite(in_dpdp_rules_2025_r_15)), [inputs_relied_on([recipient_is_foreign_state_or_its_entity-unsure])])` | `[]` |
| 10 | G = true, R = true | `requirements_apply_see_order` | `[cite(in_dpdp_rules_2025_r_15)]` |

The twelve G and R combinations are each covered exactly once. N is never read.

### Checklist items (justification only; the ladder decides)

notified_destination:

- `section_16_in_force_on_reference_date`: `check_true/4`, cite `in_dpdp_act_2023_s_16_1`.
- `destination_restricted_by_notification`: `check_tri/4`, cite `in_dpdp_act_2023_s_16_1`.

foreign_state_requirements:

- `section_16_in_force_on_reference_date`: cite `in_dpdp_act_2023_s_16_1`.
- `rule_15_in_force_on_reference_date`: met if D is on or after Start, `unmet(before(Start))` if D is before, `unknown([reference_date])` if D is absent. Cite `in_dpdp_rules_2025_r_1_4`.
- `recipient_is_foreign_state_or_its_entity`: `check_tri/4`, cite `in_dpdp_rules_2025_r_15`.
- `foreign_state_requirements_specified`: `check_true/4`, cite `in_dpdp_rules_2025_r_15`.

## Input check (kernel.clausal)

The check gives one solution for every term.

**Profile shape.** These give `[wrong_type(profile)]` alone:

- an unbound profile
- a partial list
- a non-list
- a list with an unbound element
- a list with any element that is not `attribute(K, V)`

Shape is tested with var/nonvar-disjoint clauses.

**Contract keys.** Otherwise, for each contract key in contract order:

- `duplicate_key(Key)` if it occurs more than once. Occurrences are counted with `==`, and values are not read.
- Else `wrong_type(Key)` if its value is outside its type. An unbound value is outside every type.

**Unknown keys.** Then `unknown_key(Key)` once per non-contract key, in order of first occurrence and deduplicated with `==`. Non-atom keys (numbers, strings, compounds, variables) count, and are reported as given.

**Real Gregorian day.** `date(Year, Month, Day)` is a real day when:

- each argument is an integer
- Year is at least 1
- Month is from 1 to 12
- Day is from 1 to the value given by `month_last_day(Year, Month, LastDay)`

**Absence.** An absent key is never a problem.

## Test plan (seven modes)

1. **Per-step tests.** Every ladder clause above has a fixture checking Result and the sorted Citations.
2. **Boundary.** `reference_date` at `date(2027, 5, 12)` gives `not_in_force`; `date(2027, 5, 13)` reaches the later steps. Run through `prop_boundary_coverage/2`.
3. **Missing keys.** Each needed key is absent in turn, and the named key is checked. With several keys missing, the first-named key is checked.
4. **Referral.** Unsure judgements give the exact PAIRS. With G unsure and R absent, R is named before any referral.
5. **Input problems.** Cover wrong type for each kind, duplicate keys with equal values and with unequal values, unknown keys (including non-atom and variable keys), a non-list, a partial list and an unbound profile. Invalid days such as `date(2025, 2, 29)` and `date(0, 1, 1)` give `wrong_type(reference_date)`. Input problems take precedence over every ladder step.
6. **Counting and determinism.** `findall` over every query has `length 1` for the full key cross-product of both restrictions. Run through `prop_totality/3` and `prop_determinism/3`. Every negative test is paired with a positive one.
7. **Citation completeness.** Final results carry exactly their step's cites, and non-final results carry `[]`. No `bad_citation/1` occurs. Checked with `prop_citation_complete/3`.
