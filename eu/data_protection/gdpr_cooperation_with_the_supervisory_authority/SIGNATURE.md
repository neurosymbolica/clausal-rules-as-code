# SIGNATURE — eu/data_protection/gdpr_cooperation_with_the_supervisory_authority

## Public query surface

The core query is `gdpr_cooperation_with_the_supervisory_authority_cooperation_duty(Profile, Result, Basis, Citations)` (COOPERATION_DUTY). The facade wraps it:

- `decide_gdpr_cooperation_with_the_supervisory_authority(Profile, gdpr_cooperation_with_the_supervisory_authority_verdict(Status, Citations))`
- `gdpr_cooperation_with_the_supervisory_authority_status(Profile, Status)`

Totality and determinism:

- **Total**: every term given as PROFILE gets exactly one RESULT.
- **Deterministic**: there is exactly one solution, with no witness duplication. The role test is written as three disjoint clauses, so a profile with two `true` roles still has one witness.

No figures are imported or declared. Art 31 has no thresholds or periods, and parameters.clausal stays empty of `constant_value` facts.

## Verdict STATUS atoms (replace scaffold `required / permitted / not_applicable`)

Final statuses:

- `cooperation_met`: a duty exists and the attested statement says the caller cooperated.
- `cooperation_not_met`: a duty exists and the attested statement says the caller did not cooperate.
- `cooperation_not_required`: Art 31 imposes no duty on these facts.

Non-final statuses (compound terms only):

- `indeterminate([Key])`. The bare atom `indeterminate` is never written.
- `needs_legal_review(Reason, Context)`, where Reason is one of:
  - `open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31))`
  - `cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement))`
- `input_problems(Problems)`

For the eligibility query type (#2), the domain atoms map onto the eligibility labels as follows:

| Eligibility label | Domain status |
|---|---|
| eligible | `cooperation_met` |
| ineligible | `cooperation_not_met` |
| not applicable | `cooperation_not_required` |
| indeterminate | `indeterminate([Key])` / `needs_legal_review(...)` |

The verdict is NOT derived from the `labels(Pos, Indet, Neg)` triple of assess/6. That triple would force a bare `indeterminate` atom, which is the atom-shadowing trap. The verdict comes from the limbs of cooperation_duty instead.

## Profile keys (attribute list, read only with profile_get/3)

The keys are listed in root_exports and input_contract order.

| # | Key | Kind | Values |
|---|---|---|---|
| 1 | `acts_as_controller` | crisp | `true` / `false` |
| 2 | `acts_as_processor` | crisp | `true` / `false` |
| 3 | `acts_as_representative_of_controller_or_processor` | crisp | `true` / `false` |
| 4 | `authority_request_made` | crisp | `true` / `false` |
| 5 | `request_is_in_performance_of_authority_tasks` | judgement (tri-state) | `true` / `false` / `unsure` |
| 6 | `cooperation_given` | outside fact | `attested(true\|false, attestation(By, At, Reason, Evidence))` |

No key is numeric and no key is a date. For `cooperation_given`:

- Evidence is `url(Url, RetrievedAt)`, `document(UploadId, Sha256)` or `none`. None of these arguments is inspected.
- `outside_facts:` entry: key `cooperation_given`, citation `eu_reg_2016_679_art_31`, target `cooperation_statement`. Kinds in precedence order are `attested`, `fetched`; fetcher `none`.

## Citation-key atoms (canonical lexicon scheme; never shortened)

- `eu_reg_2016_679_art_31`: GDPR Art 31, the single paragraph. It is the only load-bearing provision.
- `cooperation_statement`: the cross-reference TARGET of the outside fact (the attested cooperation statement). It appears only inside `cite(cooperation_statement)` in referral terms.

`citation_vocabulary` is the set `[eu_reg_2016_679_art_31, cooperation_statement]`.

## Public predicates

- `gdpr_cooperation_with_the_supervisory_authority_cooperation_duty(Profile, Result, Basis, Citations)`: the COOPERATION_DUTY query. It runs limbs 0-8 in order, and the first limb that applies decides. Cites `eu_reg_2016_679_art_31`.
- `gdpr_cooperation_with_the_supervisory_authority_input_problems(Profile, Problems)`: the shape-only input check against input_contract.
  - Yields exactly one solution for every term and never fails or raises.
  - Problems is `[]` when the profile is well-formed.
  - Problem order: `duplicate_key` / `wrong_type` per contract key in contract order, then `unknown_key` in order of first occurrence.
  - Cites `eu_reg_2016_679_art_31` (input_contract).
- `decide_gdpr_cooperation_with_the_supervisory_authority(Profile, Verdict)`: Verdict is `gdpr_cooperation_with_the_supervisory_authority_verdict(Status, Citations)`, where Status and Citations are the Result and Citations of cooperation_duty. Cites `eu_reg_2016_679_art_31`.
- `gdpr_cooperation_with_the_supervisory_authority_status(Profile, Status)`: the eligibility verdict (query type #2). Status is the Result of cooperation_duty. Cites `eu_reg_2016_679_art_31`.
- `gdpr_cooperation_with_the_supervisory_authority_checklist(Profile, Checklist)`: the justification checklist (query type #7).
  - Built with formalize_lib `eval_requirements/4` over the four requirement ids.
  - Each item is `item(RequirementId, Status, cite(eu_reg_2016_679_art_31))`, met items included.
  - Cites `eu_reg_2016_679_art_31`.
- `gdpr_cooperation_with_the_supervisory_authority_what_if(Profile, Key, Value, Status)`: the status after overriding Key with Value.
  - Implemented through query_combinators `what_if/5` with the closure `gdpr_cooperation_with_the_supervisory_authority_status`.
  - Cites `eu_reg_2016_679_art_31`.
- `gdpr_cooperation_with_the_supervisory_authority_fixture(Name, Profile)` and `gdpr_cooperation_with_the_supervisory_authority_fixture_expected(Name, Result, Basis, Citations)`: the named test profiles and their expected answers. Cites `eu_reg_2016_679_art_31`.

RESULT constructors are exported but never called as queries:

- Result terms: `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `input_problems/1`
- Problem terms: `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`
- Context and basis terms: `resolution/2`, `inputs_relied_on/1`, `provenance/2`, `outside_fact/2`
- Outside-fact terms: `attested/2`, `attestation/4`, `url/2`, `document/2`

## Planned reuse (manifest `uses:`)

- **formalize_lib**:
  - `profile_get/3`, `profile_has/2` and `profile_lacks/2`: presence first, then value.
  - `check_true/4`: the role and request items.
  - `check_tri/4`: the judgement item. Clause outcomes: true → met, false → unmet, unsure or absent → unknown.
  - `or_status/2`: combines the three role items into one bound item.
  - `eval_requirements/4`: builds the checklist. It must not be hand-rolled (lint R1).
  - `memberd/2`, `not_member/2`, `item/3`, `attribute/2`.
- **kit.query_combinators**: `what_if/5`, for the what_if facade.
- **validate_props** (tests only):
  - `run_props/1`
  - `prop_totality/3` and `prop_determinism/3`, run over the full product of key values plus absent.
  - `prop_citation_complete/3`
  - `prop_missing_key_coverage/3`
- **Not used, with reasons**:
  - kit.compliance_lib: the limbs are a closed, ordered list fixed by the interface. A deny-overrides lattice would add nothing and could reorder the precedence.
  - kit.deadline_lib and date_time: Art 31 has no time limit.
  - currency_vocab, vat_category, country: there are no money, VAT or country inputs.
  - rolling_window: not relevant to this order.

## Layer files (layout unchanged)

- **kernel.clausal.** No predicate needs to be shared, because there is only one determination slice. The kernel keeps only its scaffold floor (module header and generic exports) and gains no domain logic.
- **citations.clausal.** Holds the citation facts for `eu_reg_2016_679_art_31` (pinned unit `02016R0679-20160504#art_031` with the verbatim text) and `cooperation_statement` (the outside-fact target).
- **parameters.clausal.** No statutory figures. A comment records that Art 31 sets none.
- **queries.clausal.** Re-exports the facade predicates listed above by delegating to the slice.
- **fixtures.clausal.** Holds the named profiles listed in the slice section, with their expected results.

## Slice: gdpr_cooperation_with_the_supervisory_authority.clausal

### Statutory VALUE facts owned by this slice

Art 31 has no thresholds, periods or tables. The slice owns these interface facts:

- `contract_key(Position, Key, Kind)` for positions 1-6:
  - Kind `crisp`: the four role and request keys.
  - Kind `judgement`: `request_is_in_performance_of_authority_tasks`.
  - Kind `outside_fact`: `cooperation_given`.
- `role_key/1`: the three role keys, in order.
- `outside_fact_entry(cooperation_given, eu_reg_2016_679_art_31, cooperation_statement)`.

### Rules / requirements (checklist ids, each cited `eu_reg_2016_679_art_31`)

Each requirement is written as `requirement(RequirementId, Profile, Status, Citation)`, with RequirementId first. Each has exactly three disjoint clauses (met, unmet, unknown), with no cut and no if-then-else.

| Requirement id | Built from | met | unmet | unknown |
|---|---|---|---|---|
| `caller_is_bound_by_article_31` | `or_status/2` over `check_true/4` on the three role keys | any role key `true` | all role keys `false` | otherwise, `unknown(Keys)` for the absent role keys |
| `authority_request_made` | `check_true/4` | `true` | `false` | absent, `unknown([authority_request_made])` |
| `request_is_in_performance_of_authority_tasks` | `check_tri/4` | `true` | `false` | `unsure` or absent |
| `cooperation_given` | local three-clause predicate | `attested(true, _)` | `attested(false, _)` | absent |

The checklist's `unknown([cooperation_given])` is justification only. It never enters MISSING_KEYS.

### Limbs of cooperation_duty (C17: constant outputs folded into heads; one clause per disjoint route)

Every route after step 0 begins with `input_problems(Profile, [])`.

- **Step 0.** Problems is non-empty.
  - Result: `input_problems(Problems)`.
  - Basis `[]`, Citations `[]`.
- **Step 1.** `authority_request_made` is `false`.
  - Result: `cooperation_not_required`.
  - Basis `[]`, Citations `[cite(eu_reg_2016_679_art_31)]`.
- **Step 2.** The request flag is not `false` (absent or `true`), and the judgement is `false`.
  - Result: `cooperation_not_required`.
  - Basis `[]`, Citations `[cite(eu_reg_2016_679_art_31)]`.
- **Step 3.** Request not `false`, judgement not `false`, and all three role keys present and `false`.
  - Result: `cooperation_not_required`.
  - Basis `[]`, Citations `[cite(eu_reg_2016_679_art_31)]`.
- **Step 4.** Steps 1-3 do not apply, and a needed key is absent.
  - Result: `indeterminate([Key])`, where Key is the first absent needed key in contract order.
  - Basis `[]`, Citations `[]`.
  - Needed keys: the role keys (only while no role key is `true`), then `authority_request_made`, then `request_is_in_performance_of_authority_tasks`.
- **Step 5.** Bound, request `true`, judgement `true` or `unsure`, and `cooperation_given` absent.
  - Result: `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_31), cite(cooperation_statement)), [resolution(cite(cooperation_statement), not_attempted), inputs_relied_on([request_is_in_performance_of_authority_tasks-Judgement, cooperation_given-absent])])`.
  - Basis `[]`, Citations `[]`.
- **Step 6.** Bound, request `true`, judgement `unsure`, and `cooperation_given` present.
  - Result: `needs_legal_review(open_textured(request_is_in_performance_of_authority_tasks, cite(eu_reg_2016_679_art_31)), [inputs_relied_on([request_is_in_performance_of_authority_tasks-unsure])])`.
  - Basis `[]`, Citations `[]`.
- **Step 7.** Bound, request `true`, judgement `true`, and `cooperation_given` is `attested(true, Attestation)`.
  - Result: `cooperation_met`.
  - Basis `[outside_fact(cooperation_given, attested(true, Attestation))]`, Citations `[cite(eu_reg_2016_679_art_31)]`.
- **Step 8.** As step 7, but the statement is `attested(false, Attestation)`.
  - Result: `cooperation_not_met`.
  - Basis `[outside_fact(cooperation_given, attested(false, Attestation))]`, Citations `[cite(eu_reg_2016_679_art_31)]`.

Three helper predicates keep the routes disjoint and single-witness:

- **Bound.** `caller_bound_by_role(Profile)` has three disjoint clauses, so it yields one witness:
  - `acts_as_controller` is `true`; or
  - controller not `true` and `acts_as_processor` is `true`; or
  - neither is `true` and `acts_as_representative_of_controller_or_processor` is `true`.
- **First missing key.** `first_missing_needed_key(Profile, Key)` uses disjoint clauses guarded by `profile_lacks/2` and `profile_has/2` in contract order.
- **Pairs.** `relied_on_pairs/3` builds PAIRS.

### Input check (owned by this slice)

`gdpr_cooperation_with_the_supervisory_authority_input_problems(Profile, Problems)` uses disjoint clauses with no cut, no if-then-else and no exceptions.

**Profile shape.**

- A profile that is a proper, fully bound list in which every element is nonvar and of the form `attribute(_, _)` is an attribute list.
- The test walks the list with `var/1` guards, so a partial list or an unbound tail is never bound.
- Anything else gives `[wrong_type(profile)]` alone.

**Per contract key, in contract order.** Occurrences are counted by `==` on atoms.

- Two or more occurrences give `duplicate_key(Key)`. No value is read.
- Exactly one occurrence whose value is outside its type gives `wrong_type(Key)`:
  - crisp keys: `true` or `false`;
  - judgement: `true`, `false` or `unsure`;
  - outside fact: `attested(V, attestation(A, B, C, D))` with V `true` or `false` and each of A-D `ground/1`.
- An unbound value is `wrong_type(Key)`.

**Unknown keys.**

- Every key that is not one of the six atoms gives `unknown_key(Key)`, Key as given. This covers non-atoms: numbers, strings, compound terms and unbound variables.
- Each such key is listed once, in order of first occurrence, deduplicated by `==`.

### Verdict atoms of this slice

The slice uses the full status set from the top of this file:

- final: `cooperation_met`, `cooperation_not_met`, `cooperation_not_required`;
- non-final: `indeterminate([Key])`, `needs_legal_review(Reason, Context)`, `input_problems(Problems)`.

### Shared predicates

None. Nothing in this slice must be shared with another slice, so nothing moves to kernel.clausal.

### Fixtures and per-rule tests

Each negative test is paired with a positive test over the same case.

| Fixture | Profile | Expected result |
|---|---|---|
| `controller_cooperated` | controller true, others false, request true, judgement true, `attested(true, ...)` | `cooperation_met` |
| `processor_refused` | processor true, request true, judgement true, `attested(false, ...)` | `cooperation_not_met` |
| `representative_cooperated` | representative true, request true, judgement true, `attested(true, ...)` | `cooperation_met` |
| `no_request` | request false | `cooperation_not_required` (also with the role keys absent) |
| `request_outside_tasks` | judgement false, request key absent | `cooperation_not_required` |
| `not_bound` | all role keys false, request true, judgement true | `cooperation_not_required` |
| `role_unknown` | controller absent, the other roles false | `indeterminate([acts_as_controller])` |
| `two_keys_missing` | request and judgement absent, controller true | `indeterminate([authority_request_made])` |
| `statement_missing_unsure` | judgement unsure, cooperation_given absent | step 5 referral with PAIRS `[request_is_in_performance_of_authority_tasks-unsure, cooperation_given-absent]` |
| `statement_missing_true` | judgement true, cooperation_given absent | step 5 referral with judgement `true` |
| `judgement_unsure` | judgement unsure, statement present | step 6 open_textured referral |
| `duplicate_and_unknown` | repeated role key plus key `color` | `input_problems([duplicate_key(acts_as_controller), unknown_key(color)])` |
| `wrong_types` | crisp key `unsure`, attestation holding an unbound argument | `wrong_type` problems |
| `not_a_list` | profile is an atom, an unbound variable, or a partial list | `input_problems([wrong_type(profile)])` |

Property tests:

- **Totality and determinism**: `findall` over the cooperation_duty answers gives length 1, over the full product of the six keys (each value plus absent).
- **Citation completeness**: every final answer cites `eu_reg_2016_679_art_31`.
- **Outside-fact discipline**: `cooperation_given` never appears in any `indeterminate/1` list.
