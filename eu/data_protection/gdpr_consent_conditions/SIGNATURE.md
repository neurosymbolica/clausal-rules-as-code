# SIGNATURE — eu/data_protection/gdpr_consent_conditions

## 0. Public surface

The facade is `decide_gdpr_consent_conditions(Profile, gdpr_consent_conditions_verdict(Status, Citations))` together with `gdpr_consent_conditions_status(Profile, Status)`. Status is the STATUS of the contract query `consent_conditions_status/4`.

The called contract is served by seven root-exported predicates, (A) to (G):

- `consent_conditions_status/4`
- `consent_declaration_effect/3`
- `consent_assessment_factors/2`
- `identification_obligation/4`
- `identification_information_duty/4`
- `identification_rights_effect/4`
- `gdpr_consent_conditions_input_problems/2`

The profile is an attribute list of thirteen keys, read only with `profile_get/3` (presence first, then value).

### Totality and determinism

- Every public predicate yields EXACTLY ONE solution for every term it is given, an unbound or ill-formed Profile included.
- The input check never fails and never raises.
- Every other query returns `input_problems(Problems)` when the problem list is non-empty.

### Figures

There are no numeric statutory figures. There are no `constant_value/2` declarations, and nothing is imported from another domain. The parameters file stays an empty placeholder.

## 1. Status atoms (replace the scaffold placeholders `required` / `permitted`)

**Final statuses:**

- `consent_conditions_status`: `not_applicable`, `conditions_met`, `conditions_not_met`
- `consent_declaration_effect`: `not_applicable`, `part_not_binding`, `no_part_infringing`
- `identification_obligation`: `not_obliged_to_acquire_identifying_information`, `art11_1_not_engaged`
- `identification_information_duty`: `must_inform_data_subject`, `need_not_inform_data_subject`, `art11_2_not_engaged`
- `identification_rights_effect`: `articles_15_to_20_apply`, `articles_15_to_20_do_not_apply`, `art11_2_not_engaged`
- `consent_assessment_factors` (FACTORS): `[]` or `[factor(contract_conditional_on_unneeded_consent, cite(eu_reg_2016_679_art_7_4))]`

**Non-final compounds (never the bare atom `indeterminate`):**

- `indeterminate(MissingKeys)`
- `needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on([Key-absent])])`
- `input_problems(Problems)`

**Problem terms:** `duplicate_key(Key)`, `wrong_type(Key)`, `wrong_type(profile)`, `unknown_key(Key)`.

**Query-type surfaces (not part of the called contract):**

| Surface | Value atoms |
|---|---|
| Eligibility labels | `labels(eligible, undecided, ineligible)` |
| Compliance verdicts | `compliant`, `non_compliant`, `undecided` |
| Obligation terms | `obligation(Duty, cite(Key))` with Duty one of `demonstrate_consent`, `present_consent_request_distinguishably`, `inform_of_withdrawal_right_before_consent`, `make_withdrawal_as_easy_as_giving_consent`, `inform_data_subject_not_in_position_to_identify` |
| Checklist statuses | `met`, `unmet(Reason)`, `unknown(Keys)`, `inapplicable` |

## 2. Profile keys (thirteen, in root_exports / input_contract order)

The Short column holds the letters used in the limbs. Kind is either an outside fact, valued `attested(true|false, attestation(By, At, Reason, Evidence))`, or crisp, valued the atom `true` or `false`.

| # | Key | Short | Kind | Source |
|---|---|---|---|---|
| 1 | `processing_based_on_consent` | C | crisp | scope of Art 7 |
| 2 | `consent_demonstrable` | DEM | outside fact | Art 7(1) |
| 3 | `consent_in_declaration_with_other_matters` | G | crisp | Art 7(2), first sentence |
| 4 | `request_clearly_distinguishable_and_intelligible` | R | outside fact | Art 7(2) |
| 5 | `declaration_part_infringes_regulation` | X | crisp | Art 7(2), last sentence |
| 6 | `informed_of_withdrawal_right_before_consent` | I | crisp | Art 7(3), third sentence |
| 7 | `withdrawal_as_easy_as_giving_consent` | W | outside fact | Art 7(3), fourth sentence |
| 8 | `contract_conditional_on_unneeded_consent` | K | crisp | Art 7(4) factor |
| 9 | `consent_freely_given` | F | outside fact | Art 7(4) |
| 10 | `purposes_do_not_require_identification` | N | outside fact | Art 11(1) |
| 11 | `able_to_demonstrate_not_in_position_to_identify` | A | outside fact | Art 11(2) |
| 12 | `informing_data_subject_possible` | PO | outside fact | Art 11(2) 'if possible' |
| 13 | `additional_identifying_information_provided` | V | crisp | Art 11(2), last sentence |

There are no numeric keys and no date keys. `Evidence` is one of `url(Url, RetrievedAt)`, `document(UploadIdentifier, Sha256)` or `none`. The attestation fields are copied, never read.

## 3. Citation-key atoms (canonical lexicon, `_lexicon/citations.yaml`)

- `eu_reg_2016_679_art_7_1` — Art 7(1), limb L1
- `eu_reg_2016_679_art_7_2` — Art 7(2), limb L2 and the consequence in its last sentence
- `eu_reg_2016_679_art_7_3` — Art 7(3), third and fourth sentences, limb L3
- `eu_reg_2016_679_art_7_4` — Art 7(4), limb L4 and the factor
- `eu_reg_2016_679_art_11_1` — Art 11(1)
- `eu_reg_2016_679_art_11_2` — Art 11(2)

These six atoms are the whole `citation_vocabulary`. No shortened atom may be used.

## 4. Outside facts (`outside_facts:` in the manifest; kinds attested, then fetched; fetcher none)

For each outside fact, CITATION is the citation used in its referral. TARGET is copied verbatim from that entry's `target:` in the manifest; it must be a member of the citation vocabulary and is never re-invented in code.

| Key | CITATION |
|---|---|
| `consent_demonstrable` | `eu_reg_2016_679_art_7_1` |
| `request_clearly_distinguishable_and_intelligible` | `eu_reg_2016_679_art_7_2` |
| `withdrawal_as_easy_as_giving_consent` | `eu_reg_2016_679_art_7_3` |
| `consent_freely_given` | `eu_reg_2016_679_art_7_4` |
| `purposes_do_not_require_identification` | `eu_reg_2016_679_art_11_1` |
| `able_to_demonstrate_not_in_position_to_identify` | `eu_reg_2016_679_art_11_2` |
| `informing_data_subject_possible` | `eu_reg_2016_679_art_11_2` |

## 5. Public predicates

### Contract queries (root exports)

- `consent_conditions_status(Profile, Status, Basis, Citations)`: whether the Art 7 conditions on a consent that processing rests on are met. Limbs L1 to L4, steps (0) to (6). + Art 7(1)-(4)
- `consent_declaration_effect(Profile, Status, Citations)`: whether an infringing part of a multi-matter written declaration is not binding. Steps (7) and (8); reads only G and X. + Art 7(2)
- `consent_assessment_factors(Profile, Factors)`: the non-binding Art 7(4) factor, as ONE list in one solution, or the non-final status compound alone. Step (9). + Art 7(4)
- `identification_obligation(Profile, Status, Basis, Citations)`: the Art 11(1) relief from acquiring identifying information. Step (10). + Art 11(1)
- `identification_information_duty(Profile, Status, Basis, Citations)`: whether the controller must inform the data subject that it cannot identify them. Steps (11), (12) and (13). + Art 11(2), first sentence
- `identification_rights_effect(Profile, Status, Basis, Citations)`: whether Arts 15 to 20 apply once Art 11(2) is engaged. Steps (11), (12) with its part (b), and (14). + Art 11(2), second sentence
- `gdpr_consent_conditions_input_problems(Profile, Problems)`: the input check against the typed input_contract. Always exactly one solution. + input contract

### Facade (scaffold names kept)

- `decide_gdpr_consent_conditions(Profile, Verdict)`: `Verdict = gdpr_consent_conditions_verdict(Status, Citations)`, built from `consent_conditions_status/4`. + Art 7(1)-(4)
- `gdpr_consent_conditions_status(Profile, Status)`: the Status projection of `consent_conditions_status/4`. + Art 7(1)-(4)
- `gdpr_consent_conditions_checklist(Profile, Checklist)`: the cited checklist of `item(RequirementIdentifier, ItemStatus, cite(Key))`, built with `eval_requirements/4`.
  - Requirement identifiers: `art_7_1_consent_demonstrable`, `art_7_2_request_presentation` (`inapplicable` when G is false), `art_7_3_withdrawal_information`, `art_7_3_withdrawal_ease`, `art_7_4_consent_freely_given`.
  - An input problem gives the single item `item(input_check, unmet(input_problems(Problems)), cite(eu_reg_2016_679_art_7_1))`.
  - Citation: Art 7(1)-(4).
- `gdpr_consent_conditions_what_if(Profile, Key, Value, Verdict)`: re-decides with one key overridden (`profile_set/3` through `what_if/5`). The facade verdict is the decide closure. + Art 7(1)-(4)
- `gdpr_consent_conditions_fixture(Name, Profile)` and `gdpr_consent_conditions_fixture_expected(Name, Query, Expected)`: named worked cases (fixtures.clausal).

### Query type #2, eligibility

- `gdpr_consent_conditions_eligibility(Profile, Assessment)`: runs `assess(consent, RequirementIdentifiers, Profile, gdpr_consent_conditions_requirement, labels(eligible, undecided, ineligible), Assessment)`. The checklist above gives `assessment(consent, Decision, Checklist)`. + Art 7(1)-(4)

### Query type #14, obligation surfacing

- `gdpr_consent_conditions_obligations(Profile, Obligations)`: ONE list, in one solution, of the `obligation(Duty, cite(Key))` that bind on the stated facts:
  - `demonstrate_consent` (Art 7(1)), when C is true;
  - `present_consent_request_distinguishably` (Art 7(2)), when C and G are true;
  - `inform_of_withdrawal_right_before_consent` and `make_withdrawal_as_easy_as_giving_consent` (Art 7(3)), when C is true;
  - `inform_data_subject_not_in_position_to_identify` (Art 11(2)), when `identification_information_duty` is `must_inform_data_subject`.

  An input problem gives `input_problems(Problems)` alone. + Art 7(1)-(3), Art 11(2)

### Query type #13, compliance check

- `gdpr_consent_conditions_compliance(Profile, Action, Verdict)`: one solution. Verdict is `compliant`, `non_compliant` or `undecided`. Built with `compliance_check/7` (deny-overrides) over `nm/2` norm rows. Actions:
  - `rely_on_consent_for_processing` — `compliant` iff `conditions_met`; `non_compliant` iff `conditions_not_met`; else `undecided`. Citation: Art 7.
  - `enforce_infringing_declaration_part` — `non_compliant` iff `part_not_binding`. Citation: Art 7(2).
  - `decline_request_under_articles_15_to_20` — `compliant` iff `articles_15_to_20_do_not_apply`; `non_compliant` iff `articles_15_to_20_apply`. Citation: Art 11(2).

### Defeasible structure (cut-free, guarded once/1 defeaters, via `not_defeated/3`)

- `gdpr_consent_conditions_defeater(art_11_2_rights_disapplied, Profile) :- once(profile_get(Profile, additional_identifying_information_provided, true)).` This defeats the default that Arts 15 to 20 do not apply once Art 11(2) is engaged.
- `gdpr_consent_conditions_defeater(declaration_binding, Profile) :- once(profile_get(Profile, declaration_part_infringes_regulation, true)).` This defeats the bindingness of the declaration (Art 7(2), last sentence).

Each defeater is consulted only after the input check passes, so `once/1` never hides a duplicate key.

## 6. Planned reuse (manifest `uses:`)

- **`formalize_lib`:** `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `assess/6`, `eval_requirements/4`, `decide_labeled/3`, `not_defeated/3`, `not_member/2`, `item/3`, `unmet/1`, `unknown/1`, `labels/3`, `assessment/3`, `attribute/2`.
  - Vocabulary atoms: `met`, `inapplicable`.
- **`kit/compliance_lib`:** `nm/2`, `compliance_check/7`.
- **`kit/query_combinators`:** `what_if/5`.
- **`validate_props` (tests):** `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`.
- **Not used:** dates, money, currency, VAT, country and deadline modules, because there are no dated, numeric or monetary inputs.
- **Built-in, no import:** `ground/1`, `is_list/1`, `atom/1`, `findall/3`, `once/1`.
- **Local, flagged in NOTES as a kit candidate:** the attested-fact reader.

## 7. Package files and what each owns

### kernel.clausal (shared floor)

**Shared predicates.** Only what both the slice and the facade, obligation and compliance queries call:

- `gdpr_consent_conditions_input_problems/2` and its helpers:
  - `attribute_list_shape/1` (rejects an unbound profile, a partial list, an unbound element and a non-attribute element);
  - `contract_key/2` (key, kind) in contract order;
  - `key_occurrences/3`;
  - `value_has_type/2` for kinds `crisp` and `outside_fact`.
- `attested_value_shape/1`: the value is `attested(true|false, attestation(By, At, Reason, Evidence))` and is `ground`.
- `outside_fact_limb(Profile, Key, Limb, Attested)`, which has three disjoint clauses:
  - `profile_lacks` gives `absent`;
  - an attested true value gives `met`;
  - an attested false value gives `unmet`.
- `crisp_limb(Profile, Key, Limb)`, which has three disjoint clauses: `absent`, `met`, `unmet`.
- `absent_referral(Key, Status)`: builds the `needs_legal_review/2` term from the outside_fact entry.

**Key-order fact.** `gdpr_consent_conditions_key_order/1` (the thirteen keys), used to order MISSING_KEYS, BASIS and referrals.

### citations.clausal

- `citation_vocabulary/1` (the six atoms of section 3).
- `outside_fact_entry(Key, Citation, Target)`: the seven rows of section 4.

### parameters.clausal

Kept, with no constants. It holds a comment stating that the order has no statutory figures.

### gdpr_consent_conditions.clausal (the one determination slice; see section 8)

### queries.clausal

The facade-level query-type predicates:

- `gdpr_consent_conditions_eligibility/2`
- `gdpr_consent_conditions_obligations/2`
- `gdpr_consent_conditions_compliance/3`
- `gdpr_consent_conditions_checklist/2`
- the `gdpr_consent_conditions_requirement/4` closure for `assess/6`, which has three clauses per requirement: met, unmet, unknown / inapplicable.

### fixtures.clausal

Named profiles. At least one per final status, per non-final status, and per precedence edge listed in section 8.

### Package facade

- `decide_gdpr_consent_conditions/2`
- `gdpr_consent_conditions_status/2`
- `gdpr_consent_conditions_what_if/4`
- re-exports of the contract predicates and of the result constructors:
  - `indeterminate/1`, `needs_legal_review/2`, `cross_reference_unresolved/2`, `resolution/2`
  - `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`
  - `inputs_relied_on/1`, `provenance/2`, `input_problems/1`
  - `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `factor/2`

## 8. Determination slice — gdpr_consent_conditions.clausal

### Statutory value facts owned here

No thresholds, periods or tables. The value facts are the limb tables, held only in this file:

- `consent_limb(LimbIdentifier, Citation)`:
  - `l1` — `eu_reg_2016_679_art_7_1`
  - `l2` — `eu_reg_2016_679_art_7_2`
  - `l3` — `eu_reg_2016_679_art_7_3`
  - `l4` — `eu_reg_2016_679_art_7_4`
- `limb_outside_fact(LimbIdentifier, Key)`:
  - `l1` — `consent_demonstrable`
  - `l2` — `request_clearly_distinguishable_and_intelligible`
  - `l3` — `withdrawal_as_easy_as_giving_consent`
  - `l4` — `consent_freely_given`
- `limb_crisp_key(l3, informed_of_withdrawal_right_before_consent)`.
- `needed_consent_crisp_keys([consent_in_declaration_with_other_matters, informed_of_withdrawal_right_before_consent])`.

### Rules and requirements, in step order (every head carries its ground status, C17)

**Step 0 (all queries).** If `gdpr_consent_conditions_input_problems(Profile, Problems)` gives `Problems \== []`, the answer is `input_problems(Problems)`, with Basis [] and Citations [].

Every other clause requires `Problems == []`.

**consent_conditions_status (steps 1 to 6):**

1. C absent gives `indeterminate([processing_based_on_consent])`. C false gives `not_applicable`.
2. With C true, compute each limb value:
   - L1 = DEM.
   - L2 = R, only when G is true. When G is false or absent, L2 is `not_applying` / `pending_g`.
   - L3 = I combined with W. L3 is UNMET if I is false or W is attested false.
   - L4 = F.
3. Any UNMET limb gives `conditions_not_met`.
   - Citations: the UNMET limbs in the order L1, L2, L3, L4, each once.
   - Basis: the attested-false facts among DEM, R (when G is true), W and F, in key order.
4. Otherwise, absent crisp keys among G and I give `indeterminate(Missing)`, list-all, in key order.
5. Otherwise, the first absent needed outside fact gives the referral. The needed outside facts, in key order, are DEM, R (only when G is true), W and F.
6. Otherwise `conditions_met`.
   - Citations: L1, L2 (only when G is true), L3, L4.
   - Basis: DEM, R (when G is true), W and F, copied as supplied.

**consent_declaration_effect (steps 7 and 8):**

- G absent gives `indeterminate([consent_in_declaration_with_other_matters])`.
- G false gives `not_applicable`.
- With G true:
  - X absent gives `indeterminate([declaration_part_infringes_regulation])`.
  - X true gives `part_not_binding`, cited to Art 7(2), through the defeater `declaration_binding`.
  - X false gives `no_part_infringing`, cited to Art 7(2).

**consent_assessment_factors (step 9):**

- K absent gives `indeterminate([contract_conditional_on_unneeded_consent])`.
- K true gives `[factor(contract_conditional_on_unneeded_consent, cite(eu_reg_2016_679_art_7_4))]`.
- K false gives `[]`.

**identification_obligation (step 10):**

- N absent gives the referral on N.
- N attested true gives `not_obliged_to_acquire_identifying_information`.
- N attested false gives `art11_1_not_engaged`.
- Both final answers have Basis `[outside_fact(purposes_do_not_require_identification, Attested)]` and are cited to Art 11(1).

**Art 11(2) engagement (steps 11 and 12, shared within this slice by the two queries below):**

- **Step 11.** N or A attested false gives `art11_2_not_engaged`, cited to Art 11(2). Basis: the attested-false ones among N and A, in key order.
- **Step 12.** Otherwise, if N or A is absent:
  - in rights_effect with V absent, the answer is `indeterminate([additional_identifying_information_provided])` (part (b));
  - in every other case, the answer is the referral on the first absent one of N and A.

**identification_information_duty (step 13, engaged):**

- PO absent gives the referral on PO.
- PO attested true gives `must_inform_data_subject`.
- PO attested false gives `need_not_inform_data_subject`.
- Both final answers are cited to Art 11(2) and have Basis [N, A, PO].

**identification_rights_effect (step 14, engaged):**

- V absent gives `indeterminate([additional_identifying_information_provided])`.
- V true gives `articles_15_to_20_apply`, through the defeater `art_11_2_rights_disapplied`.
- V false gives `articles_15_to_20_do_not_apply`.
- Both final answers are cited to Art 11(2) and have Basis [N, A].

### Verdict atoms owned

Those of section 1 for queries (A) to (F).

### Shared with kernel (and only these)

From kernel.clausal: `gdpr_consent_conditions_input_problems/2`, `outside_fact_limb/4`, `crisp_limb/3`, `absent_referral/2` and `gdpr_consent_conditions_key_order/1`.

From citations.clausal: `outside_fact_entry/3`.

Nothing else crosses the slice boundary.

### Precedence edges the slice tests must pin

- DEM attested false with every other key absent gives `conditions_not_met`, citing [Art 7(1)], with Basis [DEM].
- G absent and R attested false, with no other UNMET limb, gives `indeterminate([consent_in_declaration_with_other_matters | ...])`. R is not UNMET.
- G false and R absent: R is never referred, and `conditions_met` omits L2.
- G and I both absent gives `indeterminate([consent_in_declaration_with_other_matters, informed_of_withdrawal_right_before_consent])`.
- I false and W attested false give L3 cited once, with Basis [W].
- rights_effect with N absent, A attested true and V absent gives `indeterminate([additional_identifying_information_provided])`. With V present it gives the referral on N.
- A duplicated key gives `duplicate_key(Key)` only, never also `wrong_type`.
- A bare `true` on an outside-fact key gives `wrong_type(Key)`.
- An attestation holding an unbound variable gives `wrong_type(Key)`.
- `[foo]`, an unbound profile and `[attribute(a, b) | _]` each give `[wrong_type(profile)]`.
- `attribute(1, true)` gives `unknown_key(1)`.

### Tests (seven modes)

1. **Per-rule unit tests:** one per step clause, with a positive test paired with every negative test.
2. **Precedence edges:** the list above.
3. **Input check:** every problem kind.
4. **Counting:** `findall` + `length(_, 1)` on every query, over every fixture.
5. **Properties:** `validate_props` totality, determinism and citation completeness; every cite is in `citation_vocabulary`.
6. **Fixtures:** expected answers.
7. **Facade and query types:** eligibility, obligations, compliance and what_if round-trips.
