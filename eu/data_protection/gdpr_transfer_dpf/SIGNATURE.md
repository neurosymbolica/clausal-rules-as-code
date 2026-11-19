# SIGNATURE — eu/data_protection/gdpr_transfer_dpf

## Public query surface

The one operative query is `data_privacy_framework_adequacy(PROFILE, RESULT, BASIS, CITATIONS)`. Its name is fixed by INTERFACE - THE CALLED CONTRACT and carries no prefix by contract. It is joined by the input check `gdpr_transfer_dpf_input_problems(PROFILE, PROBLEMS)` and by the scaffold facade:

- `decide_gdpr_transfer_dpf/2`
- `gdpr_transfer_dpf_status/2`
- `gdpr_transfer_dpf_checklist/2`
- `gdpr_transfer_dpf_what_if/4`
- the fixtures

The query type #13 predicate is `gdpr_transfer_dpf_compliance_check/2`.

PROFILE is the attribute list `[attribute(KEY, VALUE), ...]`. It is read only with `profile_get/3` (formalize_lib), by presence first and then by value.

**Totality and determinism.** Every public predicate yields exactly ONE solution for every input term. There is no cut, no `->` and no `*->`. Disjoint clauses are selected by:

- presence (`profile_has` / `profile_lacks`);
- value;
- `PROBLEMS = []` versus `[_|_]`;
- a precomputed state vector.

The slice holds no imported or re-declared statutory figure, because the order has no numeric threshold.

## Verdict STATUS atoms (replacing `required / permitted / not_applicable`)

Final result atoms:

- `covered_by_data_privacy_framework_adequacy`
- `not_covered_by_data_privacy_framework_adequacy`

Status compounds (exactly one of them when the result is not final):

- `input_problems(PROBLEMS)`
- `needs_legal_review(cross_reference_unresolved(cite(CITATION), cite(TARGET)), [resolution(cite(TARGET), not_attempted), inputs_relied_on([KEY-absent])])`
- `indeterminate([KEY])`. MISSING_KEYS is always one key. The bare atom `indeterminate` is never written.

Compliance answers (#13 projection):

- `no_specific_authorisation_required`, from the covered result;
- `not_established_by_this_decision`, from the not-covered result. It is never 'prohibited' (Q12).
- Otherwise the status compound is passed through unchanged.

## Profile keys (contract order = root_exports order = input_contract order)

| # | Key | Kind | Value vocabulary |
|---|---|---|---|
| U | `transfer_from_union` | crisp | `true` / `false` |
| O | `recipient_is_organisation_in_united_states` | crisp | `true` / `false` |
| F | `data_privacy_framework_decision_in_force` | outside fact | `attested(true\|false, attestation(BY, AT, REASON, EVIDENCE))` |
| L | `recipient_on_data_privacy_framework_list` | outside fact | same |
| C | `certification_covers_transferred_data` | outside fact | same |

EVIDENCE is `none`, `url(URL, RETRIEVED_AT)` or `document(UPLOAD_ID, SHA256)`. The key has no other inspection than the unbound-variable test.

The profile has no numeric key, no date key and no judgement key, so the value `unsure` never occurs.

## Citation-key atoms (canonical lexicon scheme, `_lexicon/citations.yaml`)

- `eu_dec_2023_1795_art_1`: Decision (EU) 2023/1795 Art 1, the one operative rule.
- `eu_reg_2016_679_art_45_1`: GDPR Art 45(1), the no-specific-authorisation effect. It is cited on the covered answer only.

Referral targets are cite terms inside `needs_legal_review` only:

- `data_privacy_framework_decision_in_force_statement`
- `data_privacy_framework_list_entry_statement`
- `data_privacy_framework_certification_coverage_statement`

No shortened citation atom is invented.

## Public predicates

- `data_privacy_framework_adequacy(Profile, Result, Basis, Citations)`: the one limb, taking steps 0 to 4 of THE LIMBS. Basis is a set of `outside_fact(KEY, ATTESTED)` items copied exactly as supplied. Citations are as fixed by the result. Cites `eu_dec_2023_1795_art_1` (+ `eu_reg_2016_679_art_45_1` when covered).
- `gdpr_transfer_dpf_input_problems(Profile, Problems)`: THE INPUT CHECK. It returns `[]` or, in this order:
  1. `duplicate_key` / `wrong_type`, by contract key order;
  2. `unknown_key`, by first occurrence;
  3. or `[wrong_type(profile)]` alone.

  It never fails or raises. No citation (structural).
- `decide_gdpr_transfer_dpf(Profile, gdpr_transfer_dpf_verdict(Result, Citations))`: the facade verdict. Result and Citations are taken from `data_privacy_framework_adequacy/4`. Cites as the limb.
- `gdpr_transfer_dpf_status(Profile, Result)`: the RESULT alone. Cites as the limb.
- `gdpr_transfer_dpf_checklist(Profile, Checklist)`: a per-condition explanation list of `item(ConditionId, Status, cite(eu_dec_2023_1795_art_1))`, built with `eval_requirements/4`. Status is `met`, `unmet(Reason)` or `unknown([Key])`. It is for display only and never decides the verdict. On input problems the checklist is `[]`. Cites `eu_dec_2023_1795_art_1` on every item, met items included.
- `gdpr_transfer_dpf_what_if(Profile, Key, Value, Result)`: replaces or adds `attribute(Key, Value)` with `profile_set/3`, then gives the RESULT of the limb on the new profile. Cites as the limb.
- `gdpr_transfer_dpf_compliance_check(Profile, Answer)`: query type #13. It asks whether THIS proposed transfer may take place without specific authorisation on the strength of Decision 2023/1795. Cites Art 1 + Art 45(1) GDPR.
- `gdpr_transfer_dpf_fixture(Name, Profile)` and `gdpr_transfer_dpf_fixture_expected(Name, Result, Basis, Citations)`: the named fixtures.

## Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`;
  - `eval_requirements/4` (checklist; no hand-rolled findall row helper, per R1);
  - `item/3`, `unmet/1`, `unknown/1`, `attribute/2`.
- `validate_props`:
  - `run_props/1`, `prop_totality/3`, `prop_determinism/3`;
  - `prop_citation_complete/3`, `prop_missing_key_coverage/3`.
- `kit.query_combinators`: `what_if/5` was considered. `profile_set/3` is used instead because PROFILE is an attribute list, not a dict.
- Not used:
  - `kit.compliance_lib` (closed-world modality; see NOTES reuse notes);
  - deadline, date_time and rolling_window (no dates or periods);
  - currency_vocab, vat_category and country (no such values).
- Family backbone (`_common`, deontic): none beyond formalize_lib. The slice is self-contained.

## Slice: gdpr_transfer_dpf.clausal (the only determination slice)

### Value facts owned by this slice (they live here, not in a constants file)

- `gdpr_transfer_dpf_contract_key(Position, Key)`: one fact per position 1 to 5, in the order U, O, F, L, C.
- `gdpr_transfer_dpf_crisp_key(Key)`:
  - `transfer_from_union`
  - `recipient_is_organisation_in_united_states`
- `gdpr_transfer_dpf_outside_fact(Key, Citation, Target)`:
  - `data_privacy_framework_decision_in_force`, `eu_dec_2023_1795_art_1`, `data_privacy_framework_decision_in_force_statement`
  - `recipient_on_data_privacy_framework_list`, `eu_dec_2023_1795_art_1`, `data_privacy_framework_list_entry_statement`
  - `certification_covers_transferred_data`, `eu_dec_2023_1795_art_1`, `data_privacy_framework_certification_coverage_statement`
- `gdpr_transfer_dpf_result_citations(Result, Citations)`:
  - `not_covered_by_data_privacy_framework_adequacy` gives `[cite(eu_dec_2023_1795_art_1)]`
  - `covered_by_data_privacy_framework_adequacy` gives `[cite(eu_dec_2023_1795_art_1), cite(eu_reg_2016_679_art_45_1)]`
- No numeric threshold, period or table exists, so no `constant_value/2` is declared.

### Rules / requirements

1. **Input check (step 0).** Sub-steps:
   - `attribute_list_shape(Profile, Shape)`, where Shape is `proper` or `improper`. It is total over var, partial list, non-list and bad element, using `var/1`, `nonvar/1` and `functor` tests in disjoint clauses.
   - `key_occurrence_count(Profile, Key, Count)`, using `==`.
   - `key_problem(Profile, Key, ProblemList)`, where ProblemList is `[]`, `[duplicate_key(Key)]` or `[wrong_type(Key)]`.
   - `well_typed_crisp(Value)` is `true` or `false`.
   - `well_typed_attested(Value)` is `attested(true|false, attestation(A1, A2, A3, A4))` with each argument `ground/1`.
   - `unknown_keys_in_order(Profile, UnknownKeys)`, deduplicated by `==`.
2. **State vector.** Each crisp key gives the state `true`, `false` or `absent`. Each outside fact gives the state `affirmed(Attested)`, `denied(Attested)` or `absent`.
3. **Step 1, any false.** `false_basis(Vector, Basis)` collects the `outside_fact` items whose state is denied. `vector_has_false(Vector, true|false)` is a total fold.
4. **Step 2.** The first absent outside fact in the order F, L, C gives THE ABSENT REFERRAL. Its PAIRS are `[KEY-absent]`.
5. **Step 3.** The first absent crisp key in the order U, O gives `indeterminate([KEY])`.
6. **Step 4.** Everything holds, so the transfer is covered and BASIS is `[F, L, C]` as supplied.
7. **Checklist requirements** (`requirement(RequirementId, Profile, Status, Citation)`, RequirementId first). There are three exclusive clauses each, for met, unmet and unknown:
   - `transfer_from_union`
   - `recipient_in_united_states`
   - `decision_in_force`
   - `recipient_listed`
   - `data_within_certification`

Ground outputs are folded into clause heads (C17): one clause per disjoint route.

### Verdict atoms of this slice

- `covered_by_data_privacy_framework_adequacy`
- `not_covered_by_data_privacy_framework_adequacy`
- the statuses `input_problems/1`, `needs_legal_review/2` and `indeterminate/1`

### Shared predicates (kernel.clausal)

None. This is the only slice, so nothing must be shared. kernel.clausal keeps its scaffold floor unchanged.

### Result constructors exported (never called as queries)

- `indeterminate/1`
- `needs_legal_review/2`
- `cross_reference_unresolved/2`
- `resolution/2`
- `inputs_relied_on/1`
- `outside_fact/2`
- `attested/2`
- `attestation/4`
- `url/2`
- `document/2`
- `cite/1`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`
- `covered_by_data_privacy_framework_adequacy/0`
- `not_covered_by_data_privacy_framework_adequacy/0`
- `gdpr_transfer_dpf_verdict/2` (facade record)

### Fixtures and tests (seven modes; every query collected with findall, length 1)

**Fixtures:**

- `all_conditions_hold`: covered.
- `not_from_union`: not covered, BASIS `[]`.
- `recipient_outside_united_states`: not covered, BASIS `[]`.
- `decision_not_in_force`: not covered, BASIS `[F]`.
- `recipient_off_list`: not covered, BASIS `[L]`.
- `human_resources_data_not_declared`: not covered, BASIS `[C]`.
- `two_facts_denied`: not covered, BASIS `[F, C]` as a set.
- `crisp_false_with_facts_absent`: not covered, BASIS `[]`.
- `decision_statement_absent`: referral on F.
- `list_statement_absent_union_absent`: referral on L. Neither U nor O is named.
- `coverage_statement_absent`: referral on C.
- `union_absent`: `indeterminate([transfer_from_union])`.
- `recipient_absent`: `indeterminate([recipient_is_organisation_in_united_states])`.
- `bare_boolean_outside_fact`: `input_problems([wrong_type(KEY)])`.
- `duplicate_and_unknown`: duplicate first, then unknown.
- `unbound_attestation_argument`: wrong_type.
- `partial_list_profile`: `[wrong_type(profile)]`.

**Tests:**

- one positive and one negative test per rule over the same case;
- monotonicity: stating an absent key never changes a final RESULT or its CITATIONS;
- totality and determinism over every five-key state combination via validate_props;
- citation completeness.
