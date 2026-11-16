# SIGNATURE — eu/data_protection/gdpr_cooperation_with_the_supervisory_authority

## Public query surface

| Item | Value |
|---|---|
| Package | `eu/data_protection/gdpr_cooperation_with_the_supervisory_authority` |
| Predicate prefix | `gdpr_cooperation_with_the_supervisory_authority_` |
| Shape family | deontic |
| Layout | kernel -> citations -> parameters -> gdpr_cooperation_with_the_supervisory_authority -> queries -> fixtures -> package facade (unchanged) |

The one determination is the query COOPERATION_DUTY:

`gdpr_cooperation_with_the_supervisory_authority_cooperation_duty(Profile, Result, Basis, Citations)`

The facade wraps it:

- `decide_gdpr_cooperation_with_the_supervisory_authority(Profile, gdpr_cooperation_with_the_supervisory_authority_verdict(Status, Citations))`
- `gdpr_cooperation_with_the_supervisory_authority_status(Profile, Status)`

**Totality and determinism:** for every term given as Profile, the query and the input check yield EXACTLY ONE solution, and they never fail or raise. The guards of the clauses are mutually exclusive, with no cut and no if-then-else. Every combination of the six keys is decided by exactly one step.

**Figures:** none. Art 31 has no thresholds, periods or dates. No figure is imported, and no `constant_value` is declared.

## Verdict STATUS atoms (replace the placeholders required / permitted / not_applicable)

**Final statuses:**

| Status | Meaning |
|---|---|
| `cooperation_met` | The attested statement says the caller cooperated with the request. |
| `cooperation_not_met` | The attested statement says the caller did not cooperate. |
| `cooperation_not_required` | Art 31 imposes no duty on the facts given: no request, the request is not in the performance of the tasks, or the caller is not bound. |

**Statuses that are not final:**

| Status | Meaning |
|---|---|
| `indeterminate([KEY])` | KEY is the first absent needed key. The bare atom `indeterminate` is NEVER written. |
| `needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on(PAIRS)])` | The judgement is unsure (step 6). |
| `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on(PAIRS)])` | The outside fact is absent (step 5). |
| `input_problems(PROBLEMS)` | The profile fails the input check (step 0). |

**Mapping to query type #2 (eligibility):**

- `cooperation_met` and `cooperation_not_met` are the duty-bound verdicts, positive and negative.
- `cooperation_not_required` is the verdict that the duty does not apply.
- `indeterminate` and `needs_legal_review` are the indeterminate verdicts.

**RESULT CONSTRUCTORS** (exported, never called as queries):

- indeterminate/1
- needs_legal_review/2
- open_textured/2
- cross_reference_unresolved/2
- input_problems/1
- unknown_key/1
- wrong_type/1
- duplicate_key/1
- resolution/2
- inputs_relied_on/1
- provenance/2
- outside_fact/2
- attested/2
- attestation/4
- url/2
- document/2

## Profile keys

The profile is an attribute list `[attribute(KEY, VALUE), ...]`. It is read ONLY with `profile_get/3`, by presence first and then by value. Keys are bare atoms.

There are six keys, in root_exports / input_contract order:

| # | Key | Kind | Values |
|---|---|---|---|
| 1 | `acts_as_controller` | crisp | `true` / `false` |
| 2 | `acts_as_processor` | crisp | `true` / `false` |
| 3 | `acts_as_representative_of_controller_or_processor` | crisp | `true` / `false` |
| 4 | `authority_request_made` | crisp | `true` / `false` |
| 5 | `request_is_in_performance_of_authority_tasks` | judgement (tri-state) | `true` / `false` / `unsure` |
| 6 | `cooperation_given` | outside fact | `attested(true\|false, attestation(BY, AT, REASON, EVIDENCE))` |

For the outside fact:

- EVIDENCE is `url(URL, RETRIEVED_AT)`, `document(UPLOAD_ID, SHA256)` or `none`.
- Kinds in precedence order are `attested` and `fetched`. The fetcher is `none`, so only `attested` is read.

The profile has no numeric keys and no date keys. No value is a string or a Python boolean.

## Citation-key atoms (CANONICAL lexicon scheme, _lexicon/citations.yaml)

- `eu_reg_2016_679_art_31`: Regulation (EU) 2016/679 Art 31, pinned unit `02016R0679-20160504#art_031`. This is the only load-bearing provision.
- `cooperation_statement`: the TARGET of the outside fact `cooperation_given`. It is used only in `cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement))` and in `resolution(cite(cooperation_statement), not_attempted)`.

`citation_vocabulary` is `[eu_reg_2016_679_art_31, cooperation_statement]`. No shortened citation atom is ever invented.

The `outside_facts:` entry reads:

- key: `cooperation_given`
- citation: `eu_reg_2016_679_art_31`
- target: `cooperation_statement`
- kinds: `[attested, fetched]`
- fetcher: `none`

The `referrals:` block points to THE PAIRS RULE (slice section, step 5 and step 6).

## Public predicates (one line each)

| Predicate | Description | Citation |
|---|---|---|
| `gdpr_cooperation_with_the_supervisory_authority_cooperation_duty(Profile, Result, Basis, Citations)` | The query COOPERATION_DUTY, steps 0 to 8, first step decides. Gives exactly one solution. | `cite(eu_reg_2016_679_art_31)` |
| `gdpr_cooperation_with_the_supervisory_authority_input_problems(Profile, Problems)` | The typed input check against input_contract. Problems is `[]` or the ordered problem list. It gives exactly one solution, and never fails or raises. | (none: a check of form) |
| `decide_gdpr_cooperation_with_the_supervisory_authority(Profile, Verdict)` | Facade. Verdict is `gdpr_cooperation_with_the_supervisory_authority_verdict(Status, Citations)`, with Status the Result of cooperation_duty. | `cite(eu_reg_2016_679_art_31)` |
| `gdpr_cooperation_with_the_supervisory_authority_status(Profile, Status)` | Facade. Status alone, equal to the Result of cooperation_duty. | `cite(eu_reg_2016_679_art_31)` |
| `gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, Checklist)` | Query types #2 and #7. Checklist is a list of `item(RequirementId, Status, cite(eu_reg_2016_679_art_31))`, one per requirement, met items included. Checklist is `[]` when the input check gives problems. | `cite(eu_reg_2016_679_art_31)` on every item |
| `gdpr_cooperation_with_the_supervisory_authority_what_if(Profile, Key, Value, Status)` | Status of the profile with attribute(Key, Value) put in place of any existing Key. Uses `what_if/5` from kit/query_combinators, with the closure `gdpr_cooperation_with_the_supervisory_authority_status`. | `cite(eu_reg_2016_679_art_31)` |
| `gdpr_cooperation_with_the_supervisory_authority_requirement(RequirementId, Profile, Status, Citation)` | The requirement goal injected into `eval_requirements/4`. RequirementId comes FIRST. | `cite(eu_reg_2016_679_art_31)` |
| `gdpr_cooperation_with_the_supervisory_authority_fixture(Name, Profile)` | Fixtures: named profiles, one per step and per interesting edge. | (none) |
| `gdpr_cooperation_with_the_supervisory_authority_fixture_expected(Name, Result, Basis, Citations)` | Fixtures: the expected answer of each fixture. | (none) |

## Planned reuse (manifest `uses:`)

**formalize_lib**, importing exactly what is used:

- profile_get/3
- profile_has/2
- profile_lacks/2
- eval_requirements/4
- not_member/2
- memberd/2
- attribute/2
- item/3
- unmet/1
- unknown/1

The checklist is built with `eval_requirements/4` over the injected `gdpr_cooperation_with_the_supervisory_authority_requirement`. It is never a hand-rolled findall-over-item helper (lint R1).

The tri-state judgement item is written as three explicit clauses (true / false / unsure-or-absent) and not as a clone of check_tri. If the `unsure` mapping of check_tri/4 matches `unknown([request_is_in_performance_of_authority_tasks])`, check_tri/4 is used instead (lint C15).

**kit/query_combinators:** what_if/5, for the what_if/4 facade.

**validate_props** (tests only):

- run_props/1
- prop_totality/3
- prop_determinism/3
- prop_citation_complete/3
- prop_missing_key_coverage/3
- bad_citation/1

**Not used:**

- deadline_lib, rolling_window and date_time: Art 31 has no period.
- currency_vocab and vat_category: there is no money.
- compliance_lib: the query types are not in scope.
- country: competence is not checked.

**Not in the kit yet** (noted in the working notes (not published), local for now):

- the outside-fact shape check;
- the duplicate-aware typed input check.

## kernel.clausal

It keeps only the shared floor of the scaffold. There is ONE determination slice, so NO domain predicate is shared, and nothing domain-specific moves into the kernel.

## Slice: gdpr_cooperation_with_the_supervisory_authority.clausal

### Value facts owned

- No statutory figures. There is no threshold, period or table, and no `constant_value`.
- Facts owned:
  - the contract key order `gdpr_cooperation_with_the_supervisory_authority_contract_key(Position, Key, Kind)`, positions 1 to 6 as in the table above, with Kind `crisp`, `judgement` or `outside_fact`;
  - the role keys `gdpr_cooperation_with_the_supervisory_authority_role_key(Key)` for the three role atoms;
  - the requirement order `gdpr_cooperation_with_the_supervisory_authority_requirement_order([caller_bound_by_article, request_made_by_authority, request_in_performance_of_authority_tasks, cooperation_given_on_request])`.

### Input check (step 0)

The check is `gdpr_cooperation_with_the_supervisory_authority_input_problems(Profile, Problems)`. It gives exactly one solution for every term.

**When the profile is not an attribute list**, Problems is `[wrong_type(profile)]`. This covers:

- a Profile that is unbound;
- a partial list;
- a non-list;
- a list holding an unbound element;
- a list holding any element that is not `attribute(_, _)`.

**Otherwise**, Problems lists the following, in this order:

1. For each contract key in positions 1 to 6:
   - `duplicate_key(KEY)` if KEY occurs more than once. No value of a duplicated key is read, so it is never also wrong_type.
   - Else `wrong_type(KEY)` if the single value is outside its type:
     - a crisp key whose value is not `true` or `false`;
     - the judgement whose value is not `true`, `false` or `unsure`;
     - the outside fact whose value is not `attested(true|false, attestation(_, _, _, _))`;
     - any key whose value is unbound.
2. Then `unknown_key(KEY)` once for each key outside the six, in the order of its first occurrence, however often it repeats. A key that is not an atom (a number, string, compound or unbound variable) is unknown_key(KEY), KEY as given. The check compares keys with `==`, never by unification.

Absence is never a problem. Every present key is checked.

### The limbs

The limbs are clauses of `..._cooperation_duty/4` with the ground result folded into the head (C17). There is one clause per disjoint route. Each guard includes `Problems == []` for steps 1 to 8.

| Step | Guard | Result | Basis | Citations |
|---|---|---|---|---|
| (0) | Problems non-empty | `input_problems(Problems)` | `[]` | `[]` |
| (1) | authority_request_made = false | `cooperation_not_required` | `[]` | `[cite(eu_reg_2016_679_art_31)]` |
| (2) | request_is_in_performance_of_authority_tasks = false, and authority_request_made not false | `cooperation_not_required` | `[]` | `[cite(eu_reg_2016_679_art_31)]` |
| (3) | the three role keys all present and all false; request not false; judgement not false | `cooperation_not_required` | `[]` | `[cite(eu_reg_2016_679_art_31)]` |
| (4) | none of steps 1 to 3; a needed key is absent | `indeterminate([KEY])` | `[]` | `[]` |
| (5) | every needed key present; one role true; request true; judgement true or unsure; cooperation_given absent | `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks-Value, cooperation_given-absent])])`, with Value true or unsure | `[]` | `[]` |
| (6) | as step 5, but judgement unsure and cooperation_given present | `needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks-unsure])])` | `[]` | `[]` |
| (7) | judgement true; cooperation_given = `attested(true, _)` | `cooperation_met` | `[outside_fact(cooperation_given, Attested)]` | `[cite(eu_reg_2016_679_art_31)]` |
| (8) | judgement true; cooperation_given = `attested(false, _)` | `cooperation_not_met` | `[outside_fact(cooperation_given, Attested)]` | `[cite(eu_reg_2016_679_art_31)]` |

At steps 7 and 8, Attested is exactly as supplied.

**Needed keys at step 4.** The needed keys are computed in root_exports order, and KEY is the first absent one:

- **When no role key is true:** acts_as_controller, acts_as_processor, acts_as_representative_of_controller_or_processor, authority_request_made, request_is_in_performance_of_authority_tasks.
- **When some role key is true:** authority_request_made, request_is_in_performance_of_authority_tasks.
- **Never:** cooperation_given.

**The PAIRS rule.** PAIRS holds only the present judgement key. At step 5 it also holds `cooperation_given-absent`, at that key's root_exports place (after the judgement). No other key is a pair.

### Requirements (checklist, query types #2 and #7)

`..._requirement/4` has three mutually exclusive clauses per requirement: met, unmet and unknown. Each is cited `cite(eu_reg_2016_679_art_31)`.

- **caller_bound_by_article** (R1)
  - met: a role key is true;
  - `unmet(caller_not_bound)`: all three role keys are false;
  - `unknown([FirstAbsentRoleKey])`: otherwise.
- **request_made_by_authority** (R2)
  - met: true;
  - `unmet(no_request_made)`: false;
  - `unknown([authority_request_made])`: absent.
- **request_in_performance_of_authority_tasks** (R3)
  - met: true;
  - `unmet(request_outside_authority_tasks)`: false;
  - `unknown([request_is_in_performance_of_authority_tasks])`: unsure or absent.
- **cooperation_given_on_request** (R4)
  - met: `attested(true, _)`;
  - `unmet(cooperation_not_given)`: `attested(false, _)`;
  - `unknown([cooperation_given])`: absent. This is checklist provenance only; MISSING_KEYS never names it.

### Verdict atoms of the slice

- cooperation_met
- cooperation_not_met
- cooperation_not_required
- indeterminate/1
- needs_legal_review/2 (open_textured/2, cross_reference_unresolved/2)
- input_problems/1

### Shared with another slice

None.

### Tests (seven modes, v2 manifest)

There is one fixture per step 0 to 8. Edges:

- duplicate keys, equal and unequal;
- a non-atom key;
- an unbound value;
- an unbound profile;
- a partial list;
- an unknown key that repeats;
- a representative alone bound;
- controller false with processor absent, giving `indeterminate([acts_as_processor])`;
- request absent with a role true, giving `indeterminate([authority_request_made])`;
- judgement unsure with cooperation absent, giving step 5;
- judgement false with request absent, giving step 2.

Every negative test is paired with a positive test over the same case. Totality, determinism and citation-completeness are checked with validate_props.
