# SIGNATURE — uk/uk_automated_decision_making

This is the authoring plan for phases P2 onward. It does not restructure the scaffold. The package layout is unchanged:

`kernel -> citations -> parameters -> uk_automated_decision_making -> queries -> fixtures -> package facade`

The manifest is v2 and there are seven test modes. The shape family is deontic. The predicate prefix is `uk_automated_decision_making_`.

## 1. Public query surface (overview)

### The five called queries and the input check

These follow THE CALLED CONTRACT exactly, and each yields exactly ONE solution:

- `uk_significant_automated_decision(Profile, Result, Citations)`
- `uk_automated_decision_restriction(Profile, Result, Citations)`
- `uk_automated_decision_safeguards(Profile, Result, Citations)`
- `eu_automated_decision(Profile, Result, Citations)`
- `compare_uk_eu_automated_decision(Profile, UkResult, EuResult, Difference, ChangedBy)`
- `uk_automated_decision_making_input_problems(Profile, Problems)`

### The scaffold facade (names kept)

- `decide_uk_automated_decision_making/2`
- `uk_automated_decision_making_status/2`
- `uk_automated_decision_making_checklist/2`
- `uk_automated_decision_making_what_if/4`
- fixtures

### Answer shapes

- Argument 2 is ONE atom or the status compound itself. It is never wrapped in a list.
- Citations is ONE flat set-like list of `cite(KEY)` terms. It is [] when the answer is not final.

### Totality and determinism

- Every query is total over all terms. The input check never fails and never raises.
- Every query is deterministic: exactly one solution.
- To get this without cut or if-then-else, the routes are mutually exclusive by their guards, and each route is one clause with its ground verdict in the head (C17).
- The status-rule route is guarded by the negation of every final step. Its guard is computed by completion enumeration, so the route can never overlap a final step.

### Imported figures

There are none. This domain has no thresholds, periods or amounts. `parameters.clausal` keeps its scaffold floor and declares no domain constants.

## 2. Verdict STATUS atoms

These replace the scaffold placeholder `{ required, permitted, not_applicable }`.

### Final atoms per query

- `uk_significant_automated_decision/3`:
  - `significant_decision_based_solely_on_automated_processing`
  - `not_a_significant_decision_based_solely_on_automated_processing`
- `uk_automated_decision_restriction/3` and `eu_automated_decision/3`:
  - `restrictions_not_engaged`
  - `decision_permitted`
  - `decision_prohibited`
- `uk_automated_decision_safeguards/3`:
  - `safeguards_not_required`
  - `required_safeguards_in_place`
  - `required_safeguards_not_in_place`
- `compare_uk_eu_automated_decision/5`, DIFFERENCE:
  - `same`
  - `differs`

### Not-final compounds (exact functors and arities)

- `indeterminate([Key])`: exactly one bare key atom. The bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(CitationKey)), [inputs_relied_on(Pairs)])`: Pairs is a flat list of `Key-Value` terms. Trailing `provenance/2` is optional.
- `input_problems(Problems)`: Problems lists `duplicate_key(Key)`, `wrong_type(Key)` and `unknown_key(Key)` terms.
- All nine constructors are exported as result constructors and are never called as queries: `inputs_relied_on/1`, `open_textured/2`, `provenance/2`, `indeterminate/1`, `needs_legal_review/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

### Facade STATUS

The facade STATUS is the Result of `uk_automated_decision_restriction/3`: one of `restrictions_not_engaged`, `decision_permitted`, `decision_prohibited`, or its status compound itself.

## 3. Profile keys

The profile is an attribute list `[attribute(Key, Value), ...]`. It is read ONLY with `profile_get/3`: presence first, then value. Keys are bare atoms. There are no numeric, date or enumeration keys. There are NINETEEN keys, in root_exports / input_contract order:

1. `decision_based_entirely_or_partly_on_personal_data` — crisp (true/false) — UK Art 22C(1)(a)
2. `meaningful_human_involvement_in_the_decision` — judgement (true/false/unsure) — UK Art 22A(1)(a), (2); EU Art 22(1)
3. `decision_produces_a_legal_effect_for_the_data_subject` — judgement — UK Art 22A(1)(b)(i); EU Art 22(1)
4. `decision_has_a_similarly_significant_effect_for_the_data_subject` — judgement — UK Art 22A(1)(b)(ii); EU Art 22(1)
5. `processing_for_the_decision_relies_on_article_6_1_ea` — crisp — UK Art 22B(4)
6. `decision_based_entirely_or_partly_on_special_category_data` — crisp — UK Art 22B(1); EU Art 22(4)
7. `decision_based_entirely_on_processing_with_explicit_consent` — judgement — UK Art 22B(2)
8. `uk_article_9_2_g_applies` — judgement — UK Art 22B(3)(b)
9. `decision_necessary_for_a_contract_with_the_data_subject` — judgement — UK Art 22B(3)(a)(i); EU Art 22(2)(a)
10. `decision_required_or_authorised_by_law` — judgement — UK Art 22B(3)(a)(ii)
11. `decision_authorised_by_union_or_member_state_law_laying_down_suitable_measures` — judgement — EU Art 22(2)(b)
12. `decision_based_on_explicit_consent` — judgement — EU Art 22(2)(c)
13. `article_9_2_a_applies` — judgement — EU Art 22(4)
14. `eu_article_9_2_g_applies` — judgement — EU Art 22(4)
15. `suitable_measures_for_special_category_data_in_place` — judgement — EU Art 22(4)
16. `safeguards_provide_information_about_decisions` — judgement — UK Art 22C(2)(a)
17. `safeguards_enable_representations` — judgement — UK Art 22C(2)(b)
18. `safeguards_enable_human_intervention` — judgement — UK Art 22C(2)(c)
19. `safeguards_enable_contesting` — judgement — UK Art 22C(2)(d)

## 4. Citation-key atoms

These use the canonical lexicon scheme from `_lexicon/citations.yaml`, through citation_vocabulary. They are declared in `citations.clausal`. Never shorten them.

- UK Art 22A:
  - `uk_gdpr_art_22a_1`
  - `uk_gdpr_art_22a_1_a`
  - `uk_gdpr_art_22a_1_b`
  - `uk_gdpr_art_22a_1_b_i`
  - `uk_gdpr_art_22a_1_b_ii`
  - `uk_gdpr_art_22a_2`
- UK Art 22B:
  - `uk_gdpr_art_22b_1`
  - `uk_gdpr_art_22b_2`
  - `uk_gdpr_art_22b_3`
  - `uk_gdpr_art_22b_3_a`
  - `uk_gdpr_art_22b_3_a_i`
  - `uk_gdpr_art_22b_3_a_ii`
  - `uk_gdpr_art_22b_3_b`
  - `uk_gdpr_art_22b_4`
- UK Art 22C:
  - `uk_gdpr_art_22c_1`
  - `uk_gdpr_art_22c_1_a`
  - `uk_gdpr_art_22c_1_b`
  - `uk_gdpr_art_22c_2`
  - `uk_gdpr_art_22c_2_a`
  - `uk_gdpr_art_22c_2_b`
  - `uk_gdpr_art_22c_2_c`
  - `uk_gdpr_art_22c_2_d`
- EU Art 22:
  - `eu_reg_2016_679_art_22_1`
  - `eu_reg_2016_679_art_22_2`
  - `eu_reg_2016_679_art_22_2_a`
  - `eu_reg_2016_679_art_22_2_b`
  - `eu_reg_2016_679_art_22_2_c`
  - `eu_reg_2016_679_art_22_4`
- Deferred provisions: these are pinned in the manifest sources only. They are never emitted in an answer.
  - Art 22D(1) to (5)
  - EU Art 22(3)
  - S.I. 2026/82 reg 2, 2(j), 2(z8) and 5
  - DUAA 2025 s.142(1), (2), (2)(h)

### Fixed citation lists

Each final atom has one list, whichever step gives it.

| List | Contents | Used by |
|---|---|---|
| CITATIONS_22A | all six 22A keys | both atoms of `uk_significant_automated_decision/3`; UK `restrictions_not_engaged` |
| CITATIONS_22B | all eight 22B keys | UK `decision_permitted` and `decision_prohibited`; CHANGED_BY when not [] |
| CITATIONS_22A_22C1 | the six 22A keys plus `uk_gdpr_art_22c_1`, `uk_gdpr_art_22c_1_a`, `uk_gdpr_art_22c_1_b` | `safeguards_not_required` |
| CITATIONS_22C | `uk_gdpr_art_22c_1`, `_1_a`, `_1_b`, `_2`, `_2_a`, `_2_b`, `_2_c`, `_2_d` | `required_safeguards_in_place` and `required_safeguards_not_in_place` |
| CITATIONS_EU_NOT_ENGAGED | `[cite(eu_reg_2016_679_art_22_1)]` | EU `restrictions_not_engaged` |
| CITATIONS_EU | `eu_..._22_1`, `_22_2`, `_22_2_a`, `_22_2_b`, `_22_2_c`, `_22_4` | EU `decision_permitted` and `decision_prohibited` |

### Referral rows (the `citation` of open_textured)

The manifest `referrals:` block is authoritative. This plan mirrors it. Each row's `inputs` are ALL the keys its query reads, in root_exports order (THE PAIRS RULE).

- `uk_significant_automated_decision/3`:
  - meaningful_human_involvement -> `uk_gdpr_art_22a_1_a`
  - legal_effect -> `uk_gdpr_art_22a_1_b_i`
  - similarly_significant_effect -> `uk_gdpr_art_22a_1_b_ii`
- `uk_automated_decision_restriction/3`:
  - the same three rows as above, plus:
  - explicit_consent (UK, entirely) -> `uk_gdpr_art_22b_2`
  - uk_article_9_2_g -> `uk_gdpr_art_22b_3_b`
  - contract -> `uk_gdpr_art_22b_3_a_i`
  - required_or_authorised_by_law -> `uk_gdpr_art_22b_3_a_ii`
- `uk_automated_decision_safeguards/3`:
  - the same three 22A rows, plus:
  - information -> `uk_gdpr_art_22c_2_a`
  - representations -> `uk_gdpr_art_22c_2_b`
  - human_intervention -> `uk_gdpr_art_22c_2_c`
  - contesting -> `uk_gdpr_art_22c_2_d`
- `eu_automated_decision/3`:
  - meaningful_human_involvement, legal_effect, similarly_significant_effect -> `eu_reg_2016_679_art_22_1`
  - contract -> `eu_reg_2016_679_art_22_2_a`
  - union_or_member_state_law -> `eu_reg_2016_679_art_22_2_b`
  - EU explicit consent -> `eu_reg_2016_679_art_22_2_c`
  - article_9_2_a, eu_article_9_2_g, suitable_measures -> `eu_reg_2016_679_art_22_4`
- `compare_uk_eu_automated_decision/5`, for DIFFERENCE:
  - keys the UK restriction reads -> the UK restriction row's citation (contract -> `uk_gdpr_art_22b_3_a_i`)
  - EU-only keys -> the EU row's citation

## 5. Public predicates (one line each)

- `uk_significant_automated_decision(Profile, Result, Citations)`: Art 22A classification, status determination (#3). Steps 1 to 4. Cites CITATIONS_22A.
- `uk_automated_decision_restriction(Profile, Result, Citations)`: Art 22B deontic answer. Steps 5 to 9. Cites CITATIONS_22A or CITATIONS_22B.
- `uk_automated_decision_safeguards(Profile, Result, Citations)`: Art 22C(1) and (2) safeguard duty and compliance. Steps 10 to 14. Cites CITATIONS_22A_22C1 or CITATIONS_22C.
- `eu_automated_decision(Profile, Result, Citations)`: EU Art 22(1), (2) and (4). Steps 15 to 19. Cites CITATIONS_EU_NOT_ENGAGED or CITATIONS_EU.
- `compare_uk_eu_automated_decision(Profile, UkResult, EuResult, Difference, ChangedBy)`: comparison (#5). Steps 20 to 23. ChangedBy is CITATIONS_22B or [].
- `uk_automated_decision_making_input_problems(Profile, Problems)`: THE INPUT CHECK. Problems is a bare flat list. Cites the input_contract.
- `decide_uk_automated_decision_making(Profile, Verdict)`: facade. Verdict is `uk_automated_decision_making_verdict(Status, Citations)`, where Status and Citations are exactly the Result and Citations of `uk_automated_decision_restriction/3`. Cites UK Art 22A and 22B.
- `uk_automated_decision_making_status(Profile, Status)`: facade status only. Same Status as `decide_uk_automated_decision_making/2`. Cites UK Art 22B.
- `uk_automated_decision_making_checklist(Profile, Checklist)`: justification (#7).
  - Each item is a formalize_lib `item(RequirementId, Status, cite(Key))`, one per legal unit, met items included.
  - Status is from the formalize_lib vocabulary: `met`, `unmet(Reason)` or `unknown([Key])`.
  - The items, with their citations:
    - `solely_automated` (`uk_gdpr_art_22a_1_a`)
    - `significant_decision` (`uk_gdpr_art_22a_1_b`)
    - `no_reliance_on_recognised_legitimate_interests` (`uk_gdpr_art_22b_4`)
    - `special_category_condition` (`uk_gdpr_art_22b_1`)
    - `first_condition_explicit_consent` (`uk_gdpr_art_22b_2`)
    - `second_condition` (`uk_gdpr_art_22b_3`)
    - `safeguards_required` (`uk_gdpr_art_22c_1`)
    - `safeguard_information` (`uk_gdpr_art_22c_2_a`)
    - `safeguard_representations` (`uk_gdpr_art_22c_2_b`)
    - `safeguard_human_intervention` (`uk_gdpr_art_22c_2_c`)
    - `safeguard_contesting` (`uk_gdpr_art_22c_2_d`)
  - It yields exactly one checklist.
  - With input problems the checklist is `[item(input_check, unmet(input_problems(Problems)), cite(uk_gdpr_art_22a_1))]`.
- `uk_automated_decision_making_what_if(Profile, Key, Value, Status)`: sets Key to Value with kit `what_if/5`, giving `uk_automated_decision_making_status` as the DECIDE closure. Returns the facade Status of the edited profile. Cites as the facade.
- `fixtures`: named profiles in `fixtures.clausal`, read by `uk_automated_decision_making_fixture(Name, Profile)`:
  - `fixture_human_involved`: restrictions_not_engaged and safeguards_not_required
  - `fixture_ordinary_permitted_safeguards_in_place`
  - `fixture_ordinary_permitted_safeguards_missing_contesting`
  - `fixture_recognised_legitimate_interest_prohibited`
  - `fixture_special_category_explicit_consent_permitted`
  - `fixture_special_category_contract_and_9_2_g_permitted`
  - `fixture_special_category_no_condition_prohibited`
  - `fixture_uk_permits_eu_prohibits_no_exception`: compare gives differs, ChangedBy CITATIONS_22B
  - `fixture_uk_prohibits_eu_permits_article_6_1_ea`
  - `fixture_missing_effect_keys`: indeterminate
  - `fixture_unsure_human_involvement`: needs_legal_review
  - `fixture_bad_profile`: input_problems

## 6. Planned reuse (manifest `uses:`)

- **formalize_lib.** Imports: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `profile_keys/2`, `item/3`, `attribute/2`, `unmet/1`, `unknown/1`, `memberd/2`, `not_member/2`.
  - Use `check_tri/4` for the per-key tri-state checklist items.
  - Use the vocabulary atoms `met`, `applicable` and `inapplicable` where needed.
  - Never hand-roll a clone of check_tri or eval_requirements (C15 and R1).
- **kit.query_combinators.** Import `what_if/5` for `uk_automated_decision_making_what_if/4`, and `override_key/4` if needed.
- **validate_props** (tests only): `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- **list_item/3.** Built in. Not expected to be needed.
- **Not used**, because there are no amounts, dates or deadlines: currency_vocab, vat_category, date_time, deadline_lib, rolling_window.
  - kit.compliance_lib is also not used. Its deny-overrides lattice does not express the ordered-step, fixed-citation contract.
- **Local, flagged as a kit candidate in NOTES.md.** The completion-enumeration status rule: NEEDED, BEHIND, first unsure, and the PAIRS builder.

## 7. Determination slices

### 7.1 Slice `uk_automated_decision_making.clausal` (the only slice)

This slice is self-contained for the whole legal concept, Section 4A plus the EU comparison limb.

#### Statutory VALUE facts it owns

There are no thresholds, periods or tables. It owns the following tables as facts in this file:

- **Contract key table:**
  - `contract_key(Position, Key, Kind)` for the nineteen keys in root_exports order;
  - Kind is `judgement` or `crisp`;
  - `key_value_type(judgement, [true, false, unsure])` and `key_value_type(crisp, [true, false])`.
- **`query_reads(Query, Keys)`.** The keys each query reads, in root_exports order, as listed in THE LIMBS. The compare row is the union, 14 keys.
- **`result_citations(Query, ResultAtom, CitationList)`.** The fixed lists of section 4.
- **`referral_citation(Query, Key, CitationKey)`.** The rows of section 4.

#### Rules / requirements, in step order

The first step that applies decides. The status-rule clause is guarded by 'no final step applies'.

**Input check** (step 0): `uk_automated_decision_making_input_problems/2`.

- If the profile is not a proper attribute list, the answer is `[wrong_type(profile)]`. This covers:
  - an unbound profile;
  - a partial list;
  - a list with an unbound element;
  - a list with a non-attribute/2 element.
- Otherwise the checks go per contract key, in contract order:
  - `duplicate_key(Key)` if the key occurs more than once; its values are not read;
  - else `wrong_type(Key)` if its value is outside its type; an unbound value counts as outside.
- Then `unknown_key(Key)` once per non-contract key, in order of first occurrence. Non-atom keys count here, and are written as given.
- Implementation constraints:
  - Type tests use `var/1` and `atom/1` guards with `memberd/2` and `not_member/2`, so the check never raises.
  - There is no cut. Mutually exclusive clauses give exactly one solution.

**Shared derived classifications.** Each is a three-way predicate with exclusive clauses.

- `solely_significant(Profile, State)`, where State is `solely_significant`, `not_solely_significant` or `open`. It follows the LIMBS definition.
- `uk_second_condition(Profile, State)`: `met`, `fails` or `open`.
- `eu_exception(Profile, State)`: `applies`, `none` or `open`.
- `eu_paragraph_4(Profile, State)`: `met`, `fails` or `open`.

**Final steps per query.**

- Art 22A: steps 1, 2, 3.
- Art 22B: steps 5, 6, 7, 8.
  - Step 7 ignores the Art 6(1)(ea) key, absent included.
  - Step 8 needs Art 6(1)(ea) false.
- Art 22C: steps 10, 11, 12, 13.
  - In step 12, any false measure decides.
- EU: steps 15, 16, 17, 18.
  - Step 17 holds whatever the exceptions are.

Each final step is one clause whose head carries the ground Result atom and fixed Citations (C17).

**Status rule** (steps 4, 9, 14, 19 and 22). This is local and generic over the query id.

- **`completions(Query, Profile, Completions)`.** Enumerate assignments of true/false to the query's read keys that are absent, or that are unsure judgements.
- **`result_of_completion`.** Runs the query's final steps only.
- **`can_still_change(Query, Profile, Key)`.** True when two completions that differ only on Key give different results.
- **NEEDED.** The absent read keys that can still change the result, in root_exports order.
- **`behind(Query, Profile, Key, OtherKey)`.** Implemented as THE STATUS RULE defines it: add OtherKey with each value and test Key, then add Key with each value and test OtherKey.
- **(N)** `indeterminate([Key])` for the first key in NEEDED that is not behind another.
- **(U)** Otherwise, `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])` for the first unsure read judgement that can still change the result.
  - Pairs are the present read keys with their values, in root_exports order.
- **Single solution.** Uniqueness of the first element is enforced by a 'no earlier qualifying key' guard, not by cut.
- **Size bound.** At most 2^14 completions for compare. This is acceptable; memoise per call with findall.

**Comparison** (steps 20 to 23).

- UkResult and EuResult call the two queries unchanged, referral Pairs included.
- DIFFERENCE:
  - `same` if every completion over the 14 keys gives equal results;
  - `differs` if every completion gives unequal results;
  - else the status rule over the compare keys, with the compare referral rows.
- ChangedBy is CITATIONS_22B when DIFFERENCE is `differs` and UkResult is a final atom. In every other case it is [].
- With input problems, the three answer positions are each `input_problems(Problems)` and ChangedBy is [].

**Checklist items** (justification): the items of section 5, built with formalize_lib `item/3`, each carrying `cite(...)`.

#### Verdict atoms

All atoms of section 2.

#### Predicates SHARED with another slice

NONE. This is the only determination slice, so nothing is moved into `kernel.clausal`.

- `kernel.clausal` keeps its scaffold floor: re-exports of the formalize_lib profile access, and the result-constructor declarations.
- `queries.clausal` and the package facade only re-export or wrap the slice's public predicates. They never re-implement a rule.

## 8. Test plan (seven modes, per-rule)

1. **Load.** Every module loads and every export resolves.
2. **Unit, per step.** One positive and one paired negative case for every LIMBS step, 0 to 23. Steps 6 and 7 dominance is tested with the 6(1)(ea) key absent.
3. **Citations.** The fixed list per final atom is unchanged when absent keys are supplied. Use `prop_citation_complete/3` and `bad_citation/1` against the lexicon.
4. **Statuses.** `indeterminate([Key])` picks the first non-behind key. A missing key beats an unsure one. Referral Pairs are exact. Status answers have Citations [].
5. **Input check.** Cover each of the following:
   - an unbound profile;
   - a partial list;
   - a non-attribute element;
   - duplicates with equal and with unequal values;
   - an unbound value;
   - a non-atom key;
   - an unknown key repeated;
   - ordering.
6. **Counting and determinism.** Use findall plus length 1 on every query over the fixtures and a generated sample. Use `prop_totality/3` and `prop_determinism/3`.
7. **Comparison.** Cover both directions of difference, same, differs while one side is still open, ChangedBy [] while the UK side is open, and the input-problems shape.
