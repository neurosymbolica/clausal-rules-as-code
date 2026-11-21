# SIGNATURE — eu/data_protection/gdpr_churches_and_religious_associations

This is the public query surface. Some predicates are governed by the order:

- `church_rules_continuation/4` (Art 91(1));
- `church_supervision/4` (Art 91(2), read with Art 91(1));
- `gdpr_churches_and_religious_associations_input_problems/2` (the input check).

Others form the scaffold facade:

- `decide_gdpr_churches_and_religious_associations/2`;
- `gdpr_churches_and_religious_associations_status/2`;
- `gdpr_churches_and_religious_associations_checklist/2`;
- `gdpr_churches_and_religious_associations_what_if/4`;
- `gdpr_churches_and_religious_associations_eligibility/2`, which serves query types #2 and #7;
- the fixtures.

The facade STATUS is the RESULT of `church_rules_continuation/4`. It replaces the placeholder `{required, permitted, not_applicable}`.

**Totality and determinism.** Every query yields EXACTLY ONE solution for every profile term (COUNTING), and the input check yields exactly one solution for every term. No statutory figure is numeric. There are no thresholds, periods or dates, so nothing is imported or declared with `constant_value`.

## 1. Verdict STATUS atoms (replacing the scaffold placeholders)

Final answers of `church_rules_continuation` (also the facade STATUS):

- `church_rules_may_continue_to_apply`
- `church_rules_not_covered_by_article_91_1`

Final answers of `church_supervision`:

- `article_91_2_not_engaged`
- `subject_to_independent_supervisory_authority`
- `specific_supervisory_authority_permitted`
- `specific_supervisory_authority_not_permitted`

Non-final status compounds (never a bare `indeterminate` atom):

- `input_problems(PROBLEMS)`;
- `indeterminate([KEY])`;
- `needs_legal_review(open_textured(KEY, cite(eu_reg_2016_679_art_91_1)), [inputs_relied_on(PAIRS)])`;
- `needs_legal_review(cross_reference_unresolved(cite(CITATION), cite(TARGET)), [resolution(cite(TARGET), not_attempted), inputs_relied_on(PAIRS)])`.

Eligibility labels (#2), used in `labels(eligible, indeterminate, ineligible)`:

- `eligible` is `church_rules_may_continue_to_apply`;
- `ineligible` is `church_rules_not_covered_by_article_91_1`;
- `indeterminate` is any non-final status. Here `indeterminate` is a label atom in a different predicate, never a RESULT.

Checklist item statuses come from `formalize_lib`: `met`, `unmet(Reason)` and `unknown([Key])`.

Result constructors (exported, never called as queries):

- `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`;
- `resolution/2`, `inputs_relied_on/1`, `outside_fact/2`, `attested/2`, `attestation/4`;
- `url/2`, `document/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## 2. Profile keys

PROFILE is `[attribute(KEY, VALUE), ...]`. There are seven keys, exactly, in root_exports and input_contract order. Values are atoms, never strings or Python booleans. No key is numeric or a date.

| # | Key | Kind | Values |
|---|---|---|---|
| 1 | `body_is_church_or_religious_association_or_community` | crisp | `true` / `false` |
| 2 | `rules_applied_in_a_member_state` | crisp | `true` / `false` |
| 3 | `comprehensive_rules_relating_to_protection_with_regard_to_processing` | judgement | `true` / `false` / `unsure` |
| 4 | `rules_applied_at_entry_into_force_of_the_regulation` | outside fact | `attested(true` or `false, attestation(BY, AT, REASON, EVIDENCE))` |
| 5 | `rules_brought_into_line_with_the_regulation` | judgement | `true` / `false` / `unsure` |
| 6 | `supervisory_authority_is_specific` | crisp | `true` / `false` |
| 7 | `specific_authority_fulfils_chapter_vi_conditions` | outside fact | `attested(true` or `false, attestation(BY, AT, REASON, EVIDENCE))` |

- EVIDENCE is `url(URL, RETRIEVED_AT)`, `document(UPLOAD_ID, SHA256)` or `none`. The attestation arguments are never inspected beyond each being ground.
- ABSENT means not established.
- THE ARTICLE 91(1) CONDITIONS are keys 1, 2, 3, 4 and 5, in that order. The four that are not outside facts are keys 1, 2, 3 and 5.
- `church_rules_continuation` reads keys 1 to 5 only. `church_supervision` reads all seven, and reads key 7 only when key 6 is `true`.

Outside-facts table (`outside_facts:` in the manifest; fetcher `none`, kind `attested` only):

| Key | Citation | Target |
|---|---|---|
| `rules_applied_at_entry_into_force_of_the_regulation` | `eu_reg_2016_679_art_91_1` | `rules_applied_at_entry_into_force_statement` |
| `specific_authority_fulfils_chapter_vi_conditions` | `eu_reg_2016_679_art_91_2` | `chapter_vi_conditions_statement` |

## 3. Citation-key atoms (canonical lexicon, `_lexicon/citations.yaml`; never shortened)

- `eu_reg_2016_679_art_91_1`: GDPR Art 91(1) [02016R0679-20160504#parag_091.001]
- `eu_reg_2016_679_art_91_2`: GDPR Art 91(2) [02016R0679-20160504#parag_091.002]
- `citation_vocabulary` is `[eu_reg_2016_679_art_91_1, eu_reg_2016_679_art_91_2]`.
- The deferred unit 02016R0679-20160504#art_091 (the heading) has no citation atom, because it carries no rule.
- The referral targets `rules_applied_at_entry_into_force_statement` and `chapter_vi_conditions_statement` are target atoms of `outside_facts:`, not provisions.

## 4. Public predicates

- `church_rules_continuation(Profile, Result, Basis, Citations)`: whether Art 91(1) lets the described rules continue to apply. LIMBS steps 0 to 5:
  - 0: input problems;
  - 1: any condition false gives `church_rules_not_covered_by_article_91_1`, with `[]` and `[cite(eu_reg_2016_679_art_91_1)]`;
  - 2: `indeterminate([first absent of keys 1, 2, 3, 5])`;
  - 3: absent key 4 gives a `cross_reference_unresolved` referral;
  - 4: unsure key 3 or key 5, the first of the two, gives an `open_textured` referral;
  - 5: `church_rules_may_continue_to_apply`, with `[outside_fact(rules_applied_at_entry_into_force_of_the_regulation, Attested)]` and `[cite(eu_reg_2016_679_art_91_1)]`.

  + cite(eu_reg_2016_679_art_91_1)
- `church_supervision(Profile, Result, Basis, Citations)`: whether Art 91(2) is engaged, and what it says of the authority. LIMBS steps 0 to 9:
  - 0: input problems;
  - 1: any condition false gives `article_91_2_not_engaged`, with `[]` and both cites;
  - 2: first absent of keys 1, 2, 3, 5;
  - 3: `indeterminate([supervisory_authority_is_specific])`;
  - 4: absent key 4 gives a referral;
  - 5: key 6 true and key 7 absent gives a referral;
  - 6: an unsure judgement gives a referral;
  - 7: key 6 false gives `subject_to_independent_supervisory_authority`, with the BASIS of key 4. Key 7 is not read;
  - 8: key 7 attested true gives `specific_supervisory_authority_permitted`, with the BASIS of keys 4 and 7;
  - 9: key 7 attested false gives `specific_supervisory_authority_not_permitted`, with the BASIS of keys 4 and 7.

  All final answers from step 1 on carry the CITATIONS `[cite(eu_reg_2016_679_art_91_1), cite(eu_reg_2016_679_art_91_2)]`. + cite(eu_reg_2016_679_art_91_1), cite(eu_reg_2016_679_art_91_2)
- `gdpr_churches_and_religious_associations_input_problems(Profile, Problems)`: THE INPUT CHECK against the typed input_contract. It gives exactly one solution, never fails and never raises. + no provision (input contract)
- `decide_gdpr_churches_and_religious_associations(Profile, Verdict)`: Verdict is `gdpr_churches_and_religious_associations_verdict(Status, Citations)`, where Status and Citations are the RESULT and CITATIONS of `church_rules_continuation/4`. + cite(eu_reg_2016_679_art_91_1)
- `gdpr_churches_and_religious_associations_status(Profile, Status)`: the RESULT of `church_rules_continuation/4` only. + cite(eu_reg_2016_679_art_91_1)
- `gdpr_churches_and_religious_associations_checklist(Profile, Checklist)`: five `item(RequirementId, Status, cite(eu_reg_2016_679_art_91_1))` rows, one per Art 91(1) condition, in key order. They are built with `formalize_lib:eval_requirements/4` over `requirement/4`. An unsure judgement or an absent key is `unknown([Key])`, which hands the open-textured judgement to the user. A false value is `unmet(Key)`. Given an input problem, the checklist is `[]`. + cite(eu_reg_2016_679_art_91_1)
- `gdpr_churches_and_religious_associations_eligibility(Profile, Assessment)`: query types #2 and #7. Its result is `assessment(Profile, Decision, Checklist)` from `formalize_lib:assess/6` with `labels(eligible, indeterminate, ineligible)`. An unmet item decides `ineligible` before an unknown one, which matches LIMBS step 1. Every item carries `cite(...)`. Given an input problem, Decision is `indeterminate`. + cite(eu_reg_2016_679_art_91_1)
- `gdpr_churches_and_religious_associations_what_if(Profile, Key, Value, Status)`: the facade Status after overriding one key. It delegates to `query_combinators:what_if/5` with the closure `gdpr_churches_and_religious_associations_status`. + cite(eu_reg_2016_679_art_91_1)
- Fixtures (`fixtures.clausal`): `gdpr_churches_and_religious_associations_fixture(Name, Profile)` and `gdpr_churches_and_religious_associations_expected(Name, Query, Result, Basis, Citations)`. There is one fixture per LIMBS step of each query, plus input-check fixtures:
  - duplicate keys;
  - `wrong_type` for crisp, judgement and attested values;
  - unbound value;
  - unbound attestation argument;
  - unknown atom, number and variable keys;
  - non-list and partial-list profiles;
  - a non-attribute element.

  There are also irrelevance fixtures: key 7 present while key 6 is false; keys 6 and 7 present for `church_rules_continuation`; two false conditions, which must give one solution. + cite(eu_reg_2016_679_art_91_1), cite(eu_reg_2016_679_art_91_2)

The requirement closure, which is not a query, has the head order the kit requires: `requirement(RequirementId, Profile, Status, Citation)`, with RequirementId FIRST. The RequirementIds are the five condition keys. There is one met clause, one unmet clause and one unknown clause per condition, mutually exclusive, with no cut.

## 5. Planned reuse (manifest `uses:`)

From `formalize_lib`:

- `profile_get/3`, the only profile reader: presence first, then value;
- `assess/6`, `eval_requirements/4`, `item/3`, `unmet/1`, `unknown/1`, `labels/3`, `assessment/3`;
- `attribute/2`;
- `memberd/2`, for the deterministic contract-key membership in the input check.

`check_tri/4` is NOT used for the judgement items, because its three-valued mapping must also treat absence and the attested wrapper. Requirement clauses are written explicitly to avoid a hand-rolled clone (C15). If `check_tri/4` maps `unsure` to unknown, the judgement items use `check_tri/4` directly.

From `kit/query_combinators`: `what_if/5`.

From `validate_props`, in the tests only:

- `run_props/1`, `prop_totality/3`, `prop_determinism/3`;
- `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.

The family backbone `_common` (deontic) supplies the shared status-compound and referral shapes, if the scaffold manifest already lists it. No new backbone predicate is added.

Not used: `deadline_lib`, `date_time`, `country`, `compliance_lib`, `rolling_window`, `currency_vocab` and `vat_category` (see NOTES S3).

## 6. Module layout

The chain is kernel → citations → parameters → gdpr_churches_and_religious_associations → queries → fixtures → facade. File and module names are unchanged.

- **`kernel.clausal`** (the shared floor; only what any slice would share):
  - `attested_value_well_formed(Term)`: holds iff Term is `attested(V, attestation(B, A, R, E))` with V in {true, false} and B, A, R and E ground. It never binds and never raises on a variable, because it tests `nonvar` before unifying.
  - `pairs_merge_absent(Pairs, Key, KeyOrder, MergedPairs)`: inserts `Key-absent` at its root_exports place.
  - `first_in_order(Keys, Test, First)`: ordered, head-disjoint scan for the first key passing a test. It succeeds at most once.
- **`citations.clausal`**:
  - `citation_vocabulary/1`;
  - `citation_unit(eu_reg_2016_679_art_91_1, '02016R0679-20160504#parag_091.001')`;
  - `citation_unit(eu_reg_2016_679_art_91_2, '02016R0679-20160504#parag_091.002')`.
- **`parameters.clausal`**: no statutory value facts, because Art 91 has no thresholds, periods or tables. The file holds only the contract tables:
  - `contract_key(Key, Kind)` for the seven keys, in order, with Kind in {crisp, judgement, outside_fact};
  - `article_91_1_condition/1`;
  - `outside_fact_entry(Key, Citation, Target)`;
  - `root_exports_order/1`.
- **`queries.clausal`**: thin public wrappers that re-export the governed queries and the facade.
- **`fixtures.clausal`**: as in §4.

## 7. Determination slice — `gdpr_churches_and_religious_associations.clausal`

**VALUE facts owned.** There are no numeric or date values: Art 91 fixes none. The slice owns its own reading tables, which live here and not in a constants file:

- the five Art 91(1) condition keys, in order;
- the four non-outside-fact condition keys, in order (1, 2, 3, 5);
- the two judgement keys, in order (3, 5);
- the outside-fact entries for keys 4 and 7 (citation and target), restated from parameters for self-containment, or else imported from parameters but never duplicated in kernel.

**Rules / requirements.**

1. `condition_state(Profile, Key, State)`: one solution per condition key, with State in {holds(Basis), fails, absent, unsure}.
   - A crisp key: `true` gives holds, `false` gives fails.
   - A judgement: `true` gives holds, `false` gives fails, `unsure` gives unsure.
   - The outside fact: `attested(true, _)` gives `holds(outside_fact(Key, Attested))`, `attested(false, _)` gives fails, and an absent key gives absent.
   - Each case is a disjoint clause: presence via `profile_get/3`, then the value in the head.
2. `some_condition_fails(States, Answer)`: ordered recursion over the five states, with Answer `true` or `false`. It is deterministic, so two false keys give ONE solution. This is LIMBS step 1 for both queries.
3. `first_absent_profile_condition(Profile, Key)`: over keys 1, 2, 3, 5. This is step 2.
4. `first_unsure_judgement(Profile, Key)`: over keys 3, 5. This is step 4 of `church_rules_continuation` and step 6 of `church_supervision`.
5. `judgement_pairs(Profile, Pairs)`: present judgement keys only, `Key-Value`, in root_exports order. The referral PAIRS add `Key-absent` via the kernel `pairs_merge_absent/4`. This gives:
   - `church_rules_continuation` step 3 and `church_supervision` step 4: `[k3-V, k4-absent, k5-V]`;
   - `church_supervision` step 5: `[k3-V, k5-V, k7-absent]`;
   - the open_textured steps: `[k3-V, k5-V]`.
6. `church_rules_continuation/4`: one clause per LIMBS step, with the ground RESULT folded into the head (C17). The steps are mutually exclusive through explicit guards that restate the failure of every earlier step: the input problems are `[]`, no condition fails, and none of keys 1, 2, 3 or 5 is absent, and so on. There is no cut, `->` or `*->`.
7. `church_supervision/4`: as above, over steps 0 to 9. Key 7 is read only in the clauses guarded by key 6 = `true`. In step 7 it is never touched.
8. `gdpr_churches_and_religious_associations_input_problems/2`, with exactly one solution:
   - Profile is a variable, a partial list, or a non-list, or the list has a variable element or a non-`attribute(_, _)` element: `[wrong_type(profile)]`.
   - Otherwise the problems are built per contract key, in contract order: `duplicate_key(K)` if the key occurs at least twice. Occurrences are counted with `==` on atom keys and no value is read. Else `wrong_type(K)` if the value fails its type: crisp in {true, false}, judgement in {true, false, unsure}, outside fact `attested_value_well_formed/1`. An unbound value is `wrong_type`.
   - Then `unknown_key(K)` once per non-contract key, variables and non-atoms included, in first-occurrence order. Repeats are deduplicated with `==`, and a variable key is reported as that same variable.
9. `requirement(RequirementId, Profile, Status, Citation)` for the checklist and eligibility view. For each condition key, Citation is `cite(eu_reg_2016_679_art_91_1)`, and Status is met, `unmet(Key)` or `unknown([Key])`. Absent or unsure gives unknown.

**Verdict atoms owned.** All the final answers in §1, the status compounds and the eligibility labels.

**Predicates SHARED with another slice (they go in kernel.clausal).** There is only one determination slice, so nothing is strictly shared. Only the three generic helpers named in §6 are placed in kernel, because they are domain-neutral and are the recurrence candidates in NOTES S3. Everything about Art 91 stays in this slice.

## 8. Tests (seven modes, v2 manifest)

The seven test modes are:

1. load;
2. per-rule unit tests, one per LIMBS step of each query;
3. fixtures, compared as golden results with `findall` and `length = 1`;
4. properties: totality, determinism, citation completeness, and missing-key coverage, over a generator of all value combinations (3×3×4×4×3×3×4 profiles with absence) plus malformed inputs;
5. irrelevance: a non-read key never changes the answer;
6. input check, with PROBLEMS compared as a set;
7. what-if and facade consistency: status equals the `church_rules_continuation` RESULT, and the eligibility label mapping matches.

Every negative `test(_, fail)` is paired with a positive test over the same case.
