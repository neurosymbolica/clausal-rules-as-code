# SIGNATURE — eu/dsa_art_14_terms_and_conditions_order

## 0 Public query surface (summary)

### The six contract queries

- The six queries have the form `QUERY(Profile, Result, Basis, Citations)`, one per paragraph of Art 14 of Reg (EU) 2022/2065.
- The input check is `dsa_art_14_terms_and_conditions_order_input_problems(Profile, Problems)`.
- Every query has exactly one solution; the scorer counts every solution.
- Totality: there is one answer for every term, including malformed profiles, which give `input_problems`.
- Determinism: the routes are disjoint, with no cut, no `->` and no `*->`. Ground results are folded into the clause heads.
- No figure is imported. The order has no thresholds, periods or dates, so parameters.clausal declares no value.

### The facade

- `decide_dsa_art_14_terms_and_conditions_order(Profile, dsa_art_14_terms_and_conditions_order_verdict(Status, Citations))`
- `dsa_art_14_terms_and_conditions_order_status(Profile, Status)`
- `dsa_art_14_terms_and_conditions_order_checklist(Profile, Checklist)`
- `dsa_art_14_terms_and_conditions_order_what_if(Profile, Key, Value, Status)`

The facade roll-up is a convenience over the six answers (NOTES D-F).

## 1 Verdict / status atoms

These replace the scaffold placeholders `required / permitted / not_applicable`.

### Per-query final RESULT atoms (contract)

- (A) `art_14_1_terms_and_conditions_compliant`, `art_14_1_terms_and_conditions_not_compliant`
- (B) `art_14_2_change_information_compliant`, `art_14_2_change_information_not_compliant`, `art_14_2_change_information_not_required`
- (C) `art_14_3_minors_explanation_compliant`, `art_14_3_minors_explanation_not_compliant`, `art_14_3_minors_explanation_not_required`
- (D) `art_14_4_restriction_enforcement_compliant`, `art_14_4_restriction_enforcement_not_compliant`, `art_14_4_restriction_enforcement_not_required`
- (E) `art_14_5_summary_compliant`, `art_14_5_summary_not_compliant`, `art_14_5_summary_not_required`
- (F) `art_14_6_official_languages_compliant`, `art_14_6_official_languages_not_compliant`, `art_14_6_official_languages_not_required`

### Not-final status compounds (shared by all six)

- `indeterminate([Key])` — the bare atom `indeterminate` is never written.
- `needs_legal_review(open_textured(Key, cite(Paragraph)), [inputs_relied_on(Pairs)])`
- `needs_legal_review(cross_reference_unresolved(cite(Paragraph), cite(commission_vlop_or_vlose_designation_decision)), [resolution(cite(commission_vlop_or_vlose_designation_decision), not_attempted), inputs_relied_on(Pairs)])`
- `input_problems(Problems)`

### Facade roll-up labels (`labels(Pos, Indet, Neg)` for formalize_lib `assess/6`)

- `labels(dsa_art_14_terms_and_conditions_order_compliant, dsa_art_14_terms_and_conditions_order_indeterminate, dsa_art_14_terms_and_conditions_order_not_compliant)`

### Constructors

These are exact functors and arities, exported and never called as queries: `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `resolution/2`, `inputs_relied_on/1`, `provenance/2`, `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## 2 Profile keys

The profile is `[attribute(Key, Value), ...]`, read only with `profile_get/3` and `profile_lacks/2`. There are eighteen keys, listed in root_exports / input_contract order. No numeric or date keys exist.

| # | Key | Kind | Values | Paragraph |
|---|---|---|---|---|
| 1 | `terms_and_conditions_include_information_on_restrictions_on_recipient_information` | judgement | true / false / unsure | 14(1) |
| 2 | `terms_and_conditions_include_information_on_content_moderation` | judgement | true / false / unsure | 14(1) |
| 3 | `terms_and_conditions_in_clear_plain_intelligible_user_friendly_and_unambiguous_language` | judgement | true / false / unsure | 14(1) |
| 4 | `terms_and_conditions_publicly_available_in_easily_accessible_and_machine_readable_format` | judgement | true / false / unsure | 14(1) |
| 5 | `provider_has_internal_complaint_handling_system` | crisp | true / false | 14(1) |
| 6 | `terms_and_conditions_include_rules_of_procedure_of_internal_complaint_handling_system` | judgement | true / false / unsure | 14(1) |
| 7 | `terms_and_conditions_changed` | crisp | true / false | 14(2) |
| 8 | `change_to_terms_and_conditions_is_significant` | judgement | true / false / unsure | 14(2) |
| 9 | `recipients_informed_of_change_to_terms_and_conditions` | crisp | true / false | 14(2) |
| 10 | `service_primarily_directed_at_minors` | judgement | true / false / unsure | 14(3) |
| 11 | `service_predominantly_used_by_minors` | judgement | true / false / unsure | 14(3) |
| 12 | `conditions_and_restrictions_explained_in_way_minors_can_understand` | judgement | true / false / unsure | 14(3) |
| 13 | `provider_applies_or_enforces_restriction` | crisp | true / false | 14(4) |
| 14 | `restriction_applied_in_diligent_objective_and_proportionate_manner` | judgement | true / false / unsure | 14(4) |
| 15 | `restriction_applied_with_due_regard_to_rights_and_legitimate_interests_of_parties` | judgement | true / false / unsure | 14(4) |
| 16 | `concise_clear_machine_readable_summary_of_terms_and_conditions_provided` | judgement | true / false / unsure | 14(5) |
| 17 | `terms_and_conditions_published_in_official_languages_of_all_member_states_of_service` | crisp | true / false | 14(6) |
| 18 | `designated_as_very_large_online_platform_or_search_engine` | outside fact | `attested(true\|false, attestation(By, At, Reason, Evidence))` | 14(5), 14(6) |

For the outside fact (row 18):

- Evidence is `url(Url, RetrievedAt)`, `document(UploadIdentifier, Sha256)` or `none`.
- All four attestation arguments must be ground. Their content is never inspected beyond groundness.
- The `outside_facts:` manifest entry has key `designated_as_very_large_online_platform_or_search_engine`, target `commission_vlop_or_vlose_designation_decision`, kinds `[attested, fetched]` and fetcher `none`.

## 3 Citation-key atoms

These come from the canonical lexicon (`_lexicon/citations.yaml`); no shortened atom is invented.

- `eu_reg_2022_2065_art_14_1` — Reg (EU) 2022/2065 Art 14(1)
- `eu_reg_2022_2065_art_14_2` — Art 14(2)
- `eu_reg_2022_2065_art_14_3` — Art 14(3)
- `eu_reg_2022_2065_art_14_4` — Art 14(4)
- `eu_reg_2022_2065_art_14_5` — Art 14(5)
- `eu_reg_2022_2065_art_14_6` — Art 14(6)
- `commission_vlop_or_vlose_designation_decision` — the referral TARGET only, never in a final CITATIONS set.

The Art 19 units and Art 3 points are deferred. They are recorded in citations.clausal as source provenance only and are not cited by any answer.

## 4 Public predicates

### Contract queries

- `art_14_1_terms_and_conditions_content_status(Profile, Result, Basis, Citations)`: Art 14(1) terms-and-conditions content and form duty, steps 0–4 + `cite(eu_reg_2022_2065_art_14_1)`
- `art_14_2_significant_change_information_status(Profile, Result, Basis, Citations)`: Art 14(2) duty to inform of a significant change, steps 0, 5–9 + `cite(eu_reg_2022_2065_art_14_2)`
- `art_14_3_minors_explanation_status(Profile, Result, Basis, Citations)`: Art 14(3) explanation minors can understand, steps 0, 10–15 + `cite(eu_reg_2022_2065_art_14_3)`
- `art_14_4_restriction_enforcement_status(Profile, Result, Basis, Citations)`: Art 14(4) diligent, objective, proportionate enforcement with due regard, steps 0, 16–21 + `cite(eu_reg_2022_2065_art_14_4)`
- `art_14_5_terms_and_conditions_summary_status(Profile, Result, Basis, Citations)`: Art 14(5) summary duty of designated very large platforms and engines, steps 0, 22–27 + `cite(eu_reg_2022_2065_art_14_5)`
- `art_14_6_official_languages_status(Profile, Result, Basis, Citations)`: Art 14(6) official-languages duty of designated very large platforms and engines, steps 0, 28–32 + `cite(eu_reg_2022_2065_art_14_6)`
- `dsa_art_14_terms_and_conditions_order_input_problems(Profile, Problems)`: the INPUT CHECK. It returns the bare problem list, never wrapped, and is used by all six queries.

### Facade (scaffold names kept)

- `decide_dsa_art_14_terms_and_conditions_order(Profile, Verdict)`: Verdict is `dsa_art_14_terms_and_conditions_order_verdict(Status, Citations)`.
  - Status is the roll-up label from `assess/6` over the six-item checklist.
  - Citations is the set of `cite(...)` of the six paragraphs carried by the checklist items.
  - Citations: Art 14(1)–(6).
- `dsa_art_14_terms_and_conditions_order_status(Profile, Status)`: the roll-up label alone, an atom in the scalar position + Art 14(1)–(6).
- `dsa_art_14_terms_and_conditions_order_checklist(Profile, Checklist)`: a list of six `item(RequirementId, ItemStatus, cite(ParagraphKey))`, one per paragraph, in paragraph order (query type #7).
  - ItemStatus is `met`, `unmet(Result)` or `unknown([Key])`.
  - Citations: Art 14(1)–(6).
- `dsa_art_14_terms_and_conditions_order_what_if(Profile, Key, Value, Status)`: the roll-up Status after setting Key to Value. It uses query_combinators `what_if/5` with the closure `dsa_art_14_terms_and_conditions_order_status`.

### Fixtures

Keep the scaffold fixture predicate name and arity; the planned shape is `dsa_art_14_terms_and_conditions_order_fixture(FixtureName, Profile)`. Fixtures are named in full words:

- `fixture_fully_compliant_very_large_platform`
- `fixture_small_hosting_service_no_complaint_system`
- `fixture_missing_content_moderation_information`
- `fixture_significant_change_not_notified`
- `fixture_minors_service_unclear_explanation`
- `fixture_disproportionate_enforcement`
- `fixture_designation_absent_summary_unsure`
- `fixture_designation_attested_false`
- `fixture_unsure_language_judgement`
- `fixture_malformed_duplicate_and_unknown_keys`
- `fixture_unbound_key`

## 5 Planned reuse (manifest `uses:`)

- **formalize_lib** — `profile_get/3`, `profile_lacks/2`, `profile_set/3`, `assess/6`, `item/3`, `labels/3`, `unmet/1`, `unknown/1`, `attribute/2`, `memberd/2`, `not_member/2`, `has_unmet/1`, `has_unknown/1`.
  - `check_tri/4` and `check_tri_neg/4` are NOT used for the contract limbs, because their unknown branch cannot distinguish absent from unsure, which the limbs need.
  - Instead a local `key_state/3` reads presence first and then value, so C15 is not triggered: it is not a clone.
- **kit.query_combinators** — `what_if/5`.
- **validate_props** — `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`, used in the test modes.
- **Not used**, recorded as such: `kit/deadline_lib` and `library(datetime)` (no clock), `kit/compliance_lib` (the six duties are not a modality lattice; each limb is explicit), `currency_vocab`, `vat_category`, and `country` (Member States are the caller's finding, Q9).

## 6 Layout

The layout is kernel -> citations -> parameters -> dsa_art_14_terms_and_conditions_order -> queries -> fixtures -> package facade. File names and modules are unchanged.

### kernel.clausal — shared floor (only what more than one module needs)

- `dsa_art_14_terms_and_conditions_order_key_kind(Key, Kind)`: eighteen facts in input_contract order. Kind is `crisp`, `judgement` or `outside_fact`.
- `dsa_art_14_terms_and_conditions_order_input_problems(Profile, Problems)`: the INPUT CHECK. It is shared by the slice (step 0) and the facade.
  - Shape: one guard route to `[wrong_type(profile)]` for an unbound profile, a partial list, or any element that is not `attribute(_, _)`, unbound elements included. The other route covers a proper attribute list.
  - Problems are listed in this order: per contract key in kind-fact order, `duplicate_key(Key)` if it occurs twice or more, else `wrong_type(Key)` if its value is outside its type; then `unknown_key(Key)` per non-contract key, including non-atoms and unbound variables, kept as given, in first-occurrence order, deduplicated with `==` and not unification.
  - It never fails or raises and has one solution. It uses `findall`-free structural recursion with mutually exclusive clauses.
- `dsa_art_14_terms_and_conditions_order_key_state(Profile, Key, State)`: one solution, read only after a clean input check.
  - State is `absent` (via `profile_lacks/2`), or `true`, `false` or `unsure` (via `profile_get/3`).
  - For the outside fact, State is `attested_true(Attested)` or `attested_false(Attested)`, where Attested is the whole value term as supplied.
- `dsa_art_14_terms_and_conditions_order_pairs(Profile, Keys, Pairs)`: the present Key-Value pairs of Keys, in the given order (THE PAIRS RULE).

### citations.clausal

- `citation_vocabulary/1` facts for the six paragraph keys and the referral target.
- Source provenance (unit identifiers, source sha256) for the six units plus the deferred units.

### parameters.clausal

No `constant_value` is declared. The order has no thresholds, periods, amounts or dates; this is stated in a comment. The scaffold TODO is replaced by that comment, and the module stays exported-empty.

## 7 Slice: dsa_art_14_terms_and_conditions_order.clausal

### Owned VALUE facts

There are none. This is deontic with no arithmetic.

### Owned per-paragraph tables

- `paragraph_citation(QueryId, CitationKey)` — six facts.
- `query_judgement_keys(QueryId, Keys)` — THE PAIRS RULE lists.
- `paragraph_requirement(RequirementId, QueryId)` — six facts for the facade checklist.

### Rule pattern

1. Each query first calls the kernel input check.
   - If Problems is not `[]`, the result is `input_problems(Problems)`, `[]`, `[]`.
   - Otherwise it reads the key states it needs with `key_state/3` and dispatches through a private `*_route/N` predicate.
2. Each route clause has a ground result, basis shape and citations folded into its head. One clause per disjoint state combination ensures one solution.
3. 'First false', 'first absent' and 'first unsure' are written as positional chains: clause k requires keys 1..k-1 not to be in that state. No witness enumeration is used. For example, step 1 with two false items gives one solution.

### Requirements / limbs

**(A) Art 14(1) — steps 1–4**

- Items (i)–(iv) are the states of keys 1–4.
- Item (v):
  - met = key 5 false or key 6 true;
  - fails = key 5 true and key 6 false;
  - otherwise open.
- Key 6 is read only if key 5 is not false.
- Step 1 → `art_14_1_terms_and_conditions_not_compliant`.
- Step 2 → `art_14_1_terms_and_conditions_compliant`.
  - Both have Basis `[]` and Citations `[cite(eu_reg_2022_2065_art_14_1)]`.
- Step 3 → indeterminate, naming the first absent of keys 1–4. Failing that, key 5 if it is absent and key 6 is not true. Failing that, key 6 if key 5 is true and key 6 is absent.
- Step 4 → `open_textured`, naming the first unsure of keys 1–4, then key 6 (if key 5 is not false). Pairs are the present keys 1–4, plus key 6 if key 5 is not false.

**(B) Art 14(2) — steps 5–9**

- Step 5: key 7 false or key 8 false → `art_14_2_change_information_not_required`. Key 9 is not read.
- Step 6: 7, 8, 9 all true → `art_14_2_change_information_compliant`.
- Step 7: 7 and 8 true, 9 false → `art_14_2_change_information_not_compliant`.
- Step 8: first absent of 7, 8, 9 → indeterminate.
- Step 9: open_textured(key 8), Pairs `[change_to_terms_and_conditions_is_significant-unsure]`.
- Final answers cite `[cite(eu_reg_2022_2065_art_14_2)]` with Basis `[]`.

**(C) Art 14(3) — steps 10–15**

- The duty APPLIES if key 10 or key 11 is true.
- Step 10: 10 and 11 both false → not_required.
- Step 11: applies, 12 true → compliant.
- Step 12: applies, 12 false → not_compliant.
- Step 13: not applying, first absent of 10, 11 → indeterminate. Key 12 waits behind them.
- Step 14: 12 absent → indeterminate([12]).
- Step 15: open_textured on the first unsure of 10, 11 where the duty does not apply, else on 12. Pairs are the present keys 10, 11, 12.
- Final answers cite `[cite(eu_reg_2022_2065_art_14_3)]`.

**(D) Art 14(4) — steps 16–21**

- Step 16: 13 false → not_required.
- Step 17: 13 true, 14 or 15 false → not_compliant. Positional: 14 false, or 14 not false and 15 false.
- Step 18: all true → compliant.
- Step 19: 13 absent → indeterminate([provider_applies_or_enforces_restriction]).
- Step 20: first absent of 14, 15.
- Step 21: open_textured on the first unsure of 14, 15. Pairs are `[14-Value, 15-Value]`.
- Final answers cite `[cite(eu_reg_2022_2065_art_14_4)]`.

**(E) Art 14(5) — steps 22–27**

Final answers have Basis `[outside_fact(designated_as_very_large_online_platform_or_search_engine, Attested)]` and Citations `[cite(eu_reg_2022_2065_art_14_5)]`.

- Step 22: attested_false → not_required. Key 16 is not read.
- Step 23: attested_true, 16 true → compliant.
- Step 24: attested_true, 16 false → not_compliant.
- Step 25: 16 absent → indeterminate([16]).
- Step 26: designation absent → `cross_reference_unresolved(cite(eu_reg_2022_2065_art_14_5), cite(commission_vlop_or_vlose_designation_decision))`. Pairs are `[16-Value, designated_as_very_large_online_platform_or_search_engine-absent]`.
- Step 27: attested_true, 16 unsure → open_textured(16). Pairs are `[16-unsure]`.

**(F) Art 14(6) — steps 28–32**

Final answers have the same Basis shape as (E) and Citations `[cite(eu_reg_2022_2065_art_14_6)]`.

- Step 28: attested_false → not_required.
- Step 29: attested_true, 17 true → compliant.
- Step 30: attested_true, 17 false → not_compliant.
- Step 31: 17 absent → indeterminate([17]).
- Step 32: designation absent → cross_reference_unresolved on Art 14(6). Pairs are `[designated_as_very_large_online_platform_or_search_engine-absent]`.

### Facade requirement (shared with the facade; lives here, exported)

`dsa_art_14_terms_and_conditions_order_requirement(RequirementId, Profile, Status, Citation)`:

- The argument order matches formalize_lib `assess/6`.
- There is one requirement per paragraph, each with three exclusive clauses:
  - met: result is compliant or not_required;
  - `unmet(Result)`: result is not_compliant;
  - `unknown([Key])`: result is not final. Key is the named missing key, the open_textured key, the designation key for a referral, or `profile` for input problems.
- Citation is always `cite(ParagraphKey)`.
- RequirementIds: `art_14_1_terms_and_conditions_content`, `art_14_2_significant_change_information`, `art_14_3_minors_explanation`, `art_14_4_restriction_enforcement`, `art_14_5_terms_and_conditions_summary`, `art_14_6_official_languages`.

### Shared with another module

Only the kernel predicates of §6 are shared. Nothing else belongs in kernel.clausal.

### Per-rule tests (seven modes, v2 manifest)

1. **Load.**
2. **Unit.** One test per step 0–32, each a positive case. Every `test(_, fail)` is paired with a positive test on the same profile.
3. **Counting.** Every query is checked with `findall` and `length(Answers, 1)` on all fixtures, including two-false and two-absent profiles.
4. **Fixed citations/basis.** For each final result, CITATIONS and BASIS are identical across every profile reaching it (validate_props `prop_citation_complete/3`).
5. **Totality/determinism.** Totality and determinism over the generated profile space (`prop_totality/3`, `prop_determinism/3`).
6. **Input check.** Duplicates, wrong types, attestation with an unbound argument, unknown and unbound keys, a partial list, a non-attribute element, an unbound profile.
7. **Facade.** The checklist carries `cite(...)` per item, the roll-up label, and what_if flips, for example designation attested_false → summary item met.
