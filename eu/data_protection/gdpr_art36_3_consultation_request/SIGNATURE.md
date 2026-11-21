# SIGNATURE — eu/data_protection/gdpr_art36_3_consultation_request

## Public query surface

The contract queries come first. Each takes PROFILE first and yields exactly ONE solution. Every predicate is built from disjoint clause heads, with no `!`, `->` or `once/1`.

```
consultation_request_status(Profile, Result, Basis, Citations)
missing_consultation_request_items(Profile, Items, Basis, Citations)
gdpr_art36_3_consultation_request_input_problems(Profile, Problems)
```

The facade is kept as scaffolded:

```
decide_gdpr_art36_3_consultation_request(Profile, gdpr_art36_3_consultation_request_verdict(Status, Citations))
gdpr_art36_3_consultation_request_status(Profile, Status)
gdpr_art36_3_consultation_request_checklist(Profile, Checklist)
gdpr_art36_3_consultation_request_what_if(Profile, Key, Value, Verdict)
```

The fixtures predicates are listed under the fixtures layer below.

Totality: every query answers every term, malformed profiles included, through `input_problems(...)`. Determinism: each query has one solution. No figure is imported, because the order has no threshold, period or date.

## Verdict STATUS atoms

These replace the placeholders `required`, `permitted` and `not_applicable`.

**Final atoms:**

- `consultation_request_complete`
- `consultation_request_incomplete`
- `not_governed_by_article_36_3`

**Status compounds (non-final)** are exactly one of:

- `indeterminate([KEY])`: one bare crisp key. The bare atom `indeterminate` is never written.
- `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_3_a), cite(controller_and_processor_roles_statement)), [resolution(cite(controller_and_processor_roles_statement), not_attempted), inputs_relied_on([joint_controllers_or_processors_involved-absent])])`. This is THE ABSENT REFERRAL.
- `input_problems(PROBLEMS)`: PROBLEMS holds `duplicate_key(K)`, `wrong_type(K)`, `wrong_type(profile)` or `unknown_key(K)`.

**Item atoms**, in order:

1. `respective_responsibilities`
2. `purposes_and_means`
3. `measures_and_safeguards`
4. `data_protection_officer_contact_details`
5. `data_protection_impact_assessment`
6. `other_requested_information`

## Profile keys (ten, in contract order)

PROFILE is `[attribute(KEY, VALUE), ...]`, read with `profile_get/3` only.

| # | Key | Type |
|---|---|---|
| 1 | `consultation_under_article_36_1` | crisp `true` / `false` |
| 2 | `joint_controllers_or_processors_involved` | OUTSIDE FACT: `attested(true or false, attestation(By, At, Reason, Evidence))` |
| 3 | `respective_responsibilities_provided` | crisp |
| 4 | `purposes_and_means_provided` | crisp |
| 5 | `measures_and_safeguards_provided` | crisp |
| 6 | `data_protection_officer_designated` | crisp |
| 7 | `data_protection_officer_contact_details_provided` | crisp |
| 8 | `impact_assessment_provided` | crisp |
| 9 | `other_information_requested_by_supervisory_authority` | crisp |
| 10 | `requested_other_information_provided` | crisp |

The Evidence argument of the outside fact is one of `none`, `url(Url, RetrievedAt)` or `document(UploadIdentifier, Sha256)`.

The domain has no numeric key and no date key.

`root_exports` lists:

- the ten keys;
- the three result atoms;
- the six item atoms;
- `absent` and `not_attempted`.

## Citation-key atoms (canonical lexicon)

- `eu_reg_2016_679_art_36_3`: Art 36(3), opening words.
- `eu_reg_2016_679_art_36_3_a` to `eu_reg_2016_679_art_36_3_f`: points (a) to (f), one atom each.
- `controller_and_processor_roles_statement`: the referral target of the outside fact.

No shortened atom is used. Art 36(1) and 36(5) are read only for interpretation and are never emitted.

**Citation sets:**

- A final answer other than `not_governed_by_article_36_3` cites the SEVEN atoms (36_3 and 36_3_a to f).
- `not_governed_by_article_36_3` cites `[cite(eu_reg_2016_679_art_36_3)]`.
- Indeterminate, referral and input problems cite `[]`.

## Public predicates, one line each

- `consultation_request_status(Profile, Result, Basis, Citations)`: compliance check (#13). Is the request complete under Art 36(3)? It follows status steps 0 to 7 of THE LIMBS. Cites Art 36(3) and 36(3)(a) to (f).
- `missing_consultation_request_items(Profile, Items, Basis, Citations)`: enumeration (#4). Lists the item atoms that apply and are missing, in order (a) to (f), possibly `[]`. It follows items steps 0 to 5. Cites Art 36(3) and 36(3)(a) to (f).
- `gdpr_art36_3_consultation_request_input_problems(Profile, Problems)`: the typed input check. It never fails and never raises. It implements the contract of INTERFACE - THE INPUT CHECK and cites nothing.
- `decide_gdpr_art36_3_consultation_request(Profile, Verdict)`: Verdict is `gdpr_art36_3_consultation_request_verdict(Result, Citations)` from `consultation_request_status/4`. Cites Art 36(3).
- `gdpr_art36_3_consultation_request_status(Profile, Status)`: Status is the Result of `consultation_request_status/4`. Cites Art 36(3).
- `gdpr_art36_3_consultation_request_checklist(Profile, Checklist)`: justification (#7). Checklist has six `item(ItemAtom, Status, cite(PointKey))` rows built with `eval_requirements/4`, one per point (a) to (f), each carrying its own point citation. The Status values are:
  - `met`: SATISFIED.
  - `unmet(not_provided(ItemAtom))`: MISSING.
  - `unknown([Key])`: OPEN with a named key.
  - `unknown([])`: OPEN BY REFERRAL. The outside fact is never named.
  
  On input problems, `not_governed` or an absent consultation key, Checklist is `[]`.
- `gdpr_art36_3_consultation_request_what_if(Profile, Key, Value, Verdict)`: overrides one key with `profile_set/3` (`attribute(Key, Value)`) and re-runs `decide_gdpr_art36_3_consultation_request/2`. Cites Art 36(3).
- Fixtures: `gdpr_art36_3_consultation_request_fixture(Name, Profile)` and `gdpr_art36_3_consultation_request_fixture_expected(Name, Result, Items)`.

## Planned reuse (manifest `uses:`)

- **formalize_lib**:
  - `profile_get/3`: the only profile reader. Absence is tested as `\+ profile_get(...)`.
  - `profile_set/3`: for what_if.
  - `eval_requirements/4` with `requirement/4`: the checklist, so there is no R1 clone.
  - `item/3`, `unmet/1`, `unknown/1`, `attribute/2`, `memberd/2`.
- **validate_props** (tests): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`.
- **Not used, with reasons:**
  - `kit/compliance_lib`: its deny-overrides modality lattice does not express the item-state precedence of THE LIMBS and would add solutions.
  - `kit/query_combinators` `what_if/5`: it assumes a dict world.
  - `deadline_lib` and `datetime`: the order computes no date.
  - currency, VAT and country vocabularies: not relevant.

## Layer plan

`kernel` -> `citations` -> `parameters` -> `gdpr_art36_3_consultation_request` -> `queries` -> `fixtures` -> package facade.

- **kernel.clausal** (shared floor):
  - `contract_key/2`: ten facts, Key and type `crisp` or `outside_fact`, in contract order.
  - `key_state(Profile, Key, State)`: State is `present(Value)` or `absent`, with two disjoint clauses.
  - `gdpr_art36_3_consultation_request_input_problems/2`.
  - `absent_referral(Result)`: builds THE ABSENT REFERRAL term.
  
  These are shared by the slice, the queries and the facade.
  
  The input check is total over all terms:
  - The profile shape test covers an unbound profile, a partial list, an unbound element and a non-attribute element, each giving `[wrong_type(profile)]`.
  - The duplicate, wrong-type and unknown-key passes follow the order of INTERFACE - THE INPUT CHECK.
  - Ground tests apply to attestation arguments. A non-atom key gives `unknown_key(Key)` as given.
- **citations.clausal**: the eight citation atoms with their pinned unit ids and verbatim text.
- **parameters.clausal**: no statutory figure. The module header stays, with a comment that the order has no threshold, period or date.
- **queries.clausal**: re-exports the two contract queries and the input check.
- **fixtures.clausal**: named profiles, listed in the slice section.

## Slice: gdpr_art36_3_consultation_request.clausal

### Value facts owned (no numbers)

- `item_order/1`: `[respective_responsibilities, purposes_and_means, measures_and_safeguards, data_protection_officer_contact_details, data_protection_impact_assessment, other_requested_information]`.
- `item_citation/2`: item to point key `_a` to `_f`.
- `final_citations/1`: the seven cites.

### Rules / requirements

`item_state(Profile, Item, State)` uses `key_state/3` with mutually exclusive clauses. State is one of:

- `satisfied`
- `missing`
- `named(Key, deciding)`
- `named(Key, waiting)`
- `referral`

**(a) `respective_responsibilities`**

| `respective_responsibilities_provided` | `joint_controllers_or_processors_involved` | State |
|---|---|---|
| true | any | satisfied |
| false or absent | attested false | satisfied |
| false | attested true | missing |
| absent | attested true | `named(respective_responsibilities_provided, deciding)` |
| absent | absent | `named(respective_responsibilities_provided, waiting)` |
| false | absent | referral |

**(b) `purposes_and_means`, (c) `measures_and_safeguards`, (e) `data_protection_impact_assessment`**

The content keys are `purposes_and_means_provided`, `measures_and_safeguards_provided` and `impact_assessment_provided`.

| Content key | State |
|---|---|
| true | satisfied |
| false | missing |
| absent | `named(ContentKey, deciding)` |

**(d) `data_protection_officer_contact_details`**

Here `designated` is `data_protection_officer_designated` and `contact` is `data_protection_officer_contact_details_provided`.

| `contact` | `designated` | State |
|---|---|---|
| true | any | satisfied |
| false or absent | false | satisfied |
| false | true | missing |
| false | absent | `named(designated, deciding)` |
| absent | absent | `named(designated, waiting)` |
| absent | true | `named(contact, deciding)` |

**(f) `other_requested_information`**

This is the same table as (d), with `other_information_requested_by_supervisory_authority` as the applicability key and `requested_other_information_provided` as the content key.

**`item_states(Profile, States)`**: an explicit recursion over `item_order`, giving `[state(Item, State), ...]`. It does not use findall.

**Deterministic list scans**, each with disjoint head and tail clauses:

- `has_missing/1` and `no_missing/1`.
- `first_named(States, Mode, Key)` with Mode `deciding` or `any`, and its failure-complement `no_named/2`.
- `has_referral/1`.
- `missing_items/2`.

No scan may succeed twice.

**`justification_basis(Profile, Basis)`** (JB):

- `[outside_fact(joint_controllers_or_processors_involved, Attested)]` when the outside fact is present and `respective_responsibilities_provided` is not true.
- `[]` otherwise.

**`consultation_request_status/4`**: steps 0 to 7. Each route is one clause with its ground result folded into the head (C17).

**`missing_consultation_request_items/4`**: steps 0 to 5.

**`requirement(ItemAtom, Profile, Status, cite(PointKey))`**: one clause per state family, for the checklist.

### Verdict atoms

As above: three final atoms plus `indeterminate/1`, `needs_legal_review/2` and `input_problems/1`. The items query yields an item-atom list or `not_governed_by_article_36_3`.

### Shared with kernel

`key_state/3`, `contract_key/2`, `absent_referral/1` and the input check. Nothing else is shared.

### Tests (seven modes)

- **Unit tests per item**: every row of every item table.
- **Precedence tests**:
  - a missing item beats an absent key in status, but not in items;
  - deciding beats waiting;
  - a named key beats the referral.
- **Counting tests**: `findall` with `length(_, 1)` for every query.
- **Input-check matrix**:
  - duplicate (equal and unequal values);
  - attested on a crisp key;
  - bare true on the outside fact;
  - an unbound attestation argument;
  - a non-atom key;
  - a partial list.
- **JB tests**: the outside fact present but not read is not copied.
- **Irrelevance tests**: a key not read changes nothing.
- **validate_props**: totality, determinism and citation completeness.

### Fixtures

| Fixture | Expected status | Expected items |
|---|---|---|
| `complete_sole_controller` | complete | `[]` |
| `incomplete_missing_assessment` | incomplete | `[data_protection_impact_assessment]` |
| `joint_controllers_responsibilities_missing` | incomplete | `[respective_responsibilities]`, with BASIS copying the attested term |
| `member_state_law_consultation` | `not_governed_by_article_36_3` | `not_governed_by_article_36_3` |
| `roles_unattested_referral` | referral | referral |
| `officer_designation_unknown` | `indeterminate([data_protection_officer_designated])` | `indeterminate([data_protection_officer_designated])` |
| `malformed_attested_crisp_key` | `input_problems([wrong_type(purposes_and_means_provided)])` | `input_problems([wrong_type(purposes_and_means_provided)])` |
