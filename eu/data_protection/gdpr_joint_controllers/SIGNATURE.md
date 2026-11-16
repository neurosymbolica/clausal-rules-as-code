# SIGNATURE — eu/data_protection/gdpr_joint_controllers

## Public query surface (summary)

The three order queries plus the input check are the contract. Each takes PROFILE first and yields EXACTLY ONE solution.
- `rights_against_each_joint_controller/3`
- `liability_for_the_entire_damage/4`
- `recourse_after_full_compensation/4`
- `gdpr_joint_controllers_input_problems/2`

The facade is the eligibility view (query type #2) of the Art 82(5) claim back:
- `decide_gdpr_joint_controllers(PROFILE, gdpr_joint_controllers_verdict(STATUS, CITATIONS))`
- `gdpr_joint_controllers_status(PROFILE, STATUS)`

Its justification checklist (query type #7) is `gdpr_joint_controllers_checklist/2`, with `cite(...)` on every item.

Totality and determinism:
- Every public predicate is total over all terms; the input check never fails or raises.
- Every public predicate is deterministic: one solution, with disjoint guarded clauses and no cut or if-then-else.
- No statutory figures exist, so nothing is imported or declared as a constant.

## Verdict STATUS atoms (replace scaffold `required / permitted / not_applicable`)

Facade STATUS, mapped from the RESULT of `recourse_after_full_compensation`:

| STATUS | from RESULT |
|---|---|
| `eligible` | `entitled_to_claim_back(PARTIES)` |
| `ineligible` | `not_entitled_to_claim_back` |
| `unresolved` | `indeterminate([KEY])` |
| `referred_for_legal_review` | `needs_legal_review(REASON, CONTEXT)` |
| `malformed_input` | `input_problems(PROBLEMS)` |

The bare atom `indeterminate` is never written, because of the atom-shadowing trap with `indeterminate/1`.

Order RESULT atoms:
- `not_joint_controllers`
- `rights_exercisable_against_this_controller`
- `not_responsible_for_the_damage`
- `no_other_responsible_party`
- `liable_for_the_entire_damage`
- `not_entitled_to_claim_back`

Order RESULT constructor: `entitled_to_claim_back/1`.

Status compounds:
- `indeterminate/1`
- `needs_legal_review/2`
- `open_textured/2`
- `cross_reference_unresolved/2`
- `resolution/2`
- `inputs_relied_on/1`
- `input_problems/1`

Other exported constructors:
- `outside_fact/2`
- `attested/2`
- `attestation/4`
- `url/2`
- `document/2`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`

## Profile keys (input_contract order = root_exports order)

1. `controllers_jointly_determine_purposes_and_means`: judgement, one of `true | false | unsure`.
2. `responsible_under_article_82_2_and_3`: outside fact, `attested(true|false, attestation(BY, AT, REASON, EVIDENCE))`.
   - EVIDENCE is one of `url(URL, RETRIEVED_AT)`, `document(UPLOAD_ID, SHA256)` or `none`.
   - The fields are never read.
   - Kinds in precedence order: attested, fetched (fetcher none).
3. `other_responsible_parties`: list key, a proper list of bare atoms, possibly `[]`.
4. `full_compensation_paid`: judgement, one of `true | false | unsure`.

There are no numeric or date keys, so no unit suffix and no `date/…` term is used. The profile is read only with `profile_get/3`, `profile_has/2` and `profile_lacks/2`. Keys are bare atoms.

## Citation-key atoms (canonical `_lexicon/citations.yaml` scheme)

- `eu_reg_2016_679_art_26_3`: Art 26(3), rights against each joint controller.
- `eu_reg_2016_679_art_28_10`: Art 28(10), a processor determining purposes and means is considered a controller.
- `eu_reg_2016_679_art_82_4`: Art 82(4), liability for the entire damage. It is also the citation of the `outside_facts:` entry.
- `eu_reg_2016_679_art_82_5`: Art 82(5), claim back after full compensation.
- `responsibility_under_article_82_statement`: referral target, the Art 82(2)/(3) statement from `gdpr-compensation-and-liability`.

Deferred and not cited: Art 26(1), Art 82(2), Art 82(3).

## Public predicates

- `rights_against_each_joint_controller(Profile, Result, Citations)`: Art 26(3) with Art 28(10), limbs 0 and A1 to A4. Cites `eu_reg_2016_679_art_26_3` and `eu_reg_2016_679_art_28_10`.
- `liability_for_the_entire_damage(Profile, Result, Basis, Citations)`: Art 82(4), limbs 0 and B1 to B5. Basis is `[outside_fact(responsible_under_article_82_2_and_3, Attested)]` on a final answer and `[]` otherwise. Cites `eu_reg_2016_679_art_82_4`.
- `recourse_after_full_compensation(Profile, Result, Basis, Citations)`: Art 82(5), limbs 0 and C1 to C8. Basis is the copied outside fact only at C1 and C8. Cites `eu_reg_2016_679_art_82_5`.
- `gdpr_joint_controllers_input_problems(Profile, Problems)`: typed input check of the four keys. Cites none (input check).
- `decide_gdpr_joint_controllers(Profile, Verdict)`: eligibility verdict. Verdict is `gdpr_joint_controllers_verdict(Status, Citations)`, where Status is mapped from the recourse RESULT and Citations is the recourse CITATIONS. Cites `eu_reg_2016_679_art_82_5`.
- `gdpr_joint_controllers_status(Profile, Status)`: Status alone, as above. Cites `eu_reg_2016_679_art_82_5`.
- `gdpr_joint_controllers_checklist(Profile, Checklist)`: justification checklist built with `eval_requirements/4`. Each element is `item(RequirementId, ItemStatus, cite(Key))`. The checklist is `[]` when the input check reports problems. Cites `eu_reg_2016_679_art_82_4` and `eu_reg_2016_679_art_82_5`.
- `gdpr_joint_controllers_what_if(Profile, Key, Value, Status)`: Status after overriding Key with Value. It uses `what_if/5` with the closure `gdpr_joint_controllers_status`. Cites as the status.
- `gdpr_joint_controllers_fixture(Name, Profile)` and `gdpr_joint_controllers_fixture_expected(Name, Query, Expected)`: fixtures, one per limb (A1 to A4, B1 to B5, C1 to C8), plus input-problem cases. Cites the citation of each limb.

## Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`;
  - `eval_requirements/4`, `item/3`, `unmet/1`, `unknown/1`;
  - `check_tri/4`, used for the `full_compensation_paid` checklist item;
  - `has_unmet/1`, `has_unknown/1`;
  - `attribute/2`.
- `kit.query_combinators`: `what_if/5`.
- `validate_props` (tests):
  - `run_props/1`, `prop_totality/3`, `prop_determinism/3`;
  - `prop_citation_complete/3`, `prop_consistency/4`, `prop_missing_key_coverage/3`;
  - `bad_citation/1`.
- Not used:
  - currency_vocab, vat_category, country (no money or places);
  - date_time, deadline_lib, rolling_window (no dates);
  - compliance_lib (the limbs are a closed decision table, not a modality lattice or plan search).
- Local, flagged in the working notes (not published) as a candidate kit module: the attested-wrapper type test and the BASIS copy.

## Layout

The layout is unchanged: kernel -> citations -> parameters -> gdpr_joint_controllers -> queries -> fixtures -> package facade.
- **kernel.clausal**: no domain predicate is shared, because there is only one slice. It keeps its scaffold floor only.
- **citations.clausal**: the five citation keys above, with unit ids `02016R0679-20160504#parag_026.003`, `#parag_028.010`, `#parag_082.004` and `#parag_082.005`, plus the referral target.
- **parameters.clausal**: intentionally empty, with a comment saying the order has no statutory figures.
- **queries.clausal**: the facade-facing wrappers that delegate to the slice, and the facade STATUS mapping (one clause per RESULT shape, constant in the head).
- **fixtures.clausal**: the fixtures above.

## Slice: gdpr_joint_controllers.clausal

**VALUE facts owned:**
- No thresholds, periods or tables.
- The ordered contract-key facts `gdpr_joint_controllers_contract_key(Position, Key, Type)`:
  - `1, controllers_jointly_determine_purposes_and_means, judgement`
  - `2, responsible_under_article_82_2_and_3, outside_fact`
  - `3, other_responsible_parties, list_of_atoms`
  - `4, full_compensation_paid, judgement`
- The absent-referral term, as a fact in the head: `gdpr_joint_controllers_absent_referral(needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_4), cite(responsibility_under_article_82_statement)), [resolution(cite(responsibility_under_article_82_statement), not_attempted), inputs_relied_on([responsible_under_article_82_2_and_3-absent])]))`.

### Rules

**R0 input check.**
- Not an attribute list gives `[wrong_type(profile)]` alone. This covers: non-list, unbound, partial list, or any element that is unbound or not `attribute(_, _)`.
- Otherwise, for each contract key in position order:
  - `duplicate_key(K)` if it occurs more than once (counted with `==`, values unread);
  - else `wrong_type(K)` if present and of the wrong type.
- Then `unknown_key(K)` for each non-contract key, including non-atom keys, in first-occurrence order, deduplicated with `==`.
- The type tests are non-binding:
  - judgement: `atom` and a member of `true`/`false`/`unsure`;
  - outside fact: bound `attested(X, A)`, with X `true` or `false` and A bound with functor `attestation/4`;
  - list: `is_list`, with each element a bound atom other than `[]`.

**Classifiers** (one clause per class, exclusive guards, class constant in the head):
- J and F: `true`, `false`, `unsure`, `absent`;
- S: `attested_true(Attested)`, `attested_false(Attested)`, `absent`;
- O: `absent`, `empty`, `non_empty(Parties)`.

**Routes.** Problems not `[]` gives step 0. Otherwise:
- **rights_against_each_joint_controller:**
  - A1: J false gives `not_joint_controllers`, `[cite(eu_reg_2016_679_art_26_3)]`.
  - A2: J absent gives `indeterminate([controllers_jointly_determine_purposes_and_means])`, `[]`.
  - A3: J unsure gives `needs_legal_review(open_textured(controllers_jointly_determine_purposes_and_means, cite(eu_reg_2016_679_art_26_3)), [inputs_relied_on([controllers_jointly_determine_purposes_and_means-unsure])])`, `[]`.
  - A4: J true gives `rights_exercisable_against_this_controller`, `[cite(eu_reg_2016_679_art_26_3), cite(eu_reg_2016_679_art_28_10)]`.
- **liability_for_the_entire_damage:**
  - B1: S attested_false gives `not_responsible_for_the_damage`, BASIS the copied outside fact, `[cite(eu_reg_2016_679_art_82_4)]`.
  - B2: S absent gives the absent referral, `[]`, `[]`.
  - B3: S attested_true and O absent gives `indeterminate([other_responsible_parties])`, `[]`, `[]`.
  - B4: S attested_true and O empty gives `no_other_responsible_party`, BASIS the copied outside fact, `[cite(eu_reg_2016_679_art_82_4)]`.
  - B5: S attested_true and O non_empty gives `liable_for_the_entire_damage`, BASIS the copied outside fact, `[cite(eu_reg_2016_679_art_82_4)]`.
- **recourse_after_full_compensation:**
  - C1: S attested_false gives `not_entitled_to_claim_back`, BASIS the copied outside fact, `[cite(eu_reg_2016_679_art_82_5)]`.
  - C2: S not false and O empty gives `not_entitled_to_claim_back`, `[]`, `[cite(eu_reg_2016_679_art_82_5)]`.
  - C3: S not false, O not empty and F false gives `not_entitled_to_claim_back`, `[]`, `[cite(eu_reg_2016_679_art_82_5)]`.
  - C4: S absent, O absent or non_empty, and F not false gives the absent referral, `[]`, `[]`.
  - C5: S attested_true, O absent and F not false gives `indeterminate([other_responsible_parties])`.
  - C6: S attested_true, O non_empty and F absent gives `indeterminate([full_compensation_paid])`.
  - C7: S attested_true, O non_empty and F unsure gives `needs_legal_review(open_textured(full_compensation_paid, cite(eu_reg_2016_679_art_82_5)), [inputs_relied_on([full_compensation_paid-unsure])])`.
  - C8: S attested_true(A), O non_empty(P) and F true gives `entitled_to_claim_back(P)`, `[outside_fact(responsible_under_article_82_2_and_3, A)]`, `[cite(eu_reg_2016_679_art_82_5)]`.

**Checklist requirements**, in the form `requirement(RequirementId, Profile, Status, Citation)` with the id FIRST:
- `caller_responsible_under_article_82_2_and_3`, citing `cite(eu_reg_2016_679_art_82_4)`:
  - met when S is attested true;
  - `unmet(not_responsible)` when false;
  - `unknown([responsible_under_article_82_2_and_3])` when absent. This is a checklist marker only, never a MISSING_KEYS.
- `other_responsible_party_listed`, citing `cite(eu_reg_2016_679_art_82_4)`:
  - met when O is non-empty;
  - `unmet(no_other_responsible_party)` when `[]`;
  - `unknown([other_responsible_parties])` when absent.
- `full_compensation_paid`, citing `cite(eu_reg_2016_679_art_82_5)`: `check_tri/4` on `full_compensation_paid`.

**Verdict atoms (slice):** the six RESULT atoms, plus `entitled_to_claim_back/1` and the status compounds above.

**Shared with other slices:** none. Nothing is moved to kernel.clausal.

**Tests (per rule, all seven modes):**
- one positive fixture per limb A1 to A4, B1 to B5 and C1 to C8, each asserting `findall` length 1 and the exact RESULT, BASIS and CITATIONS;
- precedence tests:
  - C2 and C3 with S absent;
  - B2 with O absent;
  - C5 with F unsure;
  - C4 with F unsure and O absent;
- input-check tests:
  - duplicate key with equal values, which must not also give wrong_type;
  - bare `true` as S;
  - `[]` and a string as list elements;
  - an unbound value;
  - an unbound profile;
  - a partial list;
  - a non-atom key;
  - repeated unknown keys;
  - a well-formed `[]` list;
- each negative test paired with a positive test on the same case;
- validate_props properties: totality, determinism, citation completeness (every citation in the vocabulary) and checklist/status consistency.
