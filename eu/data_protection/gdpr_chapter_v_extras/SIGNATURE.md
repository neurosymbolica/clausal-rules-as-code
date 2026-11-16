# SIGNATURE — eu/data_protection/gdpr_chapter_v_extras

This is the authoring plan for later phases. The package layout is unchanged:
`kernel -> citations -> parameters -> gdpr_chapter_v_extras -> queries -> fixtures -> package facade`.
There is one determination slice, `gdpr_chapter_v_extras.clausal`. The predicate prefix is `gdpr_chapter_v_extras_`; the three called-contract queries keep the exact names the contract gives.

## 1. Public query surface (summary)

### 1.1 Called contract

This section is non-negotiable and is scored by collecting EVERY solution. Every query yields exactly ONE solution.

- **`second_subparagraph_duty(Profile, Duty, Result, Basis, Citations)`**
  - Query type #13, compliance check.
  - Cites `eu_reg_2016_679_art_49_1_second_subpara` and `eu_reg_2016_679_art_49_6`.
- **`foreign_judgment_or_decision_recognition(Profile, Result, Basis, Citations)`**
  - Query type #13.
  - Cites `eu_reg_2016_679_art_48`.
- **`onward_transfer_condition(Profile, Result, Basis, Citations)`**
  - Query type #13.
  - Cites `eu_reg_2016_679_art_44`.
- **`gdpr_chapter_v_extras_input_problems(Profile, Problems)`**
  - The input check.
  - It never fails and never raises, for any term.

### 1.2 Scaffold facade

The facade keeps the scaffold names. It is a convenience surface built only from the four predicates above.

- **`decide_gdpr_chapter_v_extras(Profile, gdpr_chapter_v_extras_verdict(Status, Citations))`**
  - Gives the overall verdict.
  - `Status` is one of the facade STATUS atoms in section 3, or `input_problems(Problems)`.
  - `Citations` is the set-like list of `cite(KEY)` terms drawn from the final items of the checklist.
- **`gdpr_chapter_v_extras_status(Profile, Status)`**
  - Query type #3, status determination.
  - It is the same `Status` as `decide_gdpr_chapter_v_extras/2`.
- **`gdpr_chapter_v_extras_checklist(Profile, Checklist)`**
  - Returns a list of `item(RequirementId, ItemStatus, cite(KEY))`, one per requirement, in the order of section 6.2.
  - For a profile with input problems, `Checklist` is `[]`.
- **`gdpr_chapter_v_extras_what_if(Profile, Key, Value, Verdict)`**
  - Builds `profile_set(Profile, attribute(Key, Value), RevisedProfile)`, which replaces any existing entry for `Key`.
  - Then returns `decide_gdpr_chapter_v_extras(RevisedProfile, Verdict)`.
  - The revised profile passes through the input check like any other.
- **Fixtures**
  - `gdpr_chapter_v_extras_fixture(FixtureName, Profile)` holds named example profiles; see section 7.
  - If the scaffold already names the fixture predicate differently, keep the scaffold name.

### 1.3 Totality and determinism

- Every public predicate yields exactly one solution for every ground `Profile` and `Duty`.
- The input check also yields exactly one solution for non-ground input.
- Routes are mutually exclusive by guard. There is no `!`, `->` or `*->`, and no `once/1` used to suppress duplicates.
- Ground result terms are folded into clause heads (C17), one clause per disjoint route.
- Imported figures: none. This order has no statutory number. The 250-person figure of Art 30(5) belongs to `gdpr-records-and-officer` and is not read.

## 2. Result vocabulary (called contract)

### 2.1 Final RESULT atoms (result constructors of arity 0)

| Query | Final RESULT atoms |
|---|---|
| `second_subparagraph_duty` | `no_second_subparagraph_transfer`, `not_a_processor_duty`, `duty_met`, `duty_not_met` |
| `foreign_judgment_or_decision_recognition` | `article_48_not_engaged`, `not_barred_by_article_48`, `not_recognisable_or_enforceable` |
| `onward_transfer_condition` | `not_an_onward_transfer`, `onward_transfer_may_take_place`, `onward_transfer_may_not_take_place` |

### 2.2 Non-final RESULT compounds (exactly one applies; BASIS `[]` and CITATIONS `[]` for each)

- **`input_problems(Problems)`.** Problems is a list of these terms:
  - `duplicate_key(KEY)`;
  - `wrong_type(KEY)`;
  - `wrong_type(profile)`;
  - `wrong_type(duty)`;
  - `unknown_key(KEY)`.
- **`indeterminate([KEY])`.** It names exactly one key, never an outside fact. The bare atom `indeterminate` is NEVER written.
- **The absent referral:**
  `needs_legal_review(cross_reference_unresolved(cite(CITATION), cite(TARGET)), [resolution(cite(TARGET), not_attempted), inputs_relied_on([KEY-absent])])`

### 2.3 Argument atoms

The DUTY argument takes one of three inputs. They are never results.

- `inform_supervisory_authority`
- `inform_data_subject`
- `document_assessment_and_safeguards`

### 2.4 Other exported result constructors

`outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`, `resolution/2`, `inputs_relied_on/1`, `cross_reference_unresolved/2`, `needs_legal_review/2`.

## 3. Facade STATUS atoms (replacing `required, permitted, not_applicable`)

- **`no_condition_breached`.** Every checklist item is `met` or `inapplicable`.
- **`more_input_needed`.** No item is unmet and at least one item is `unknown(...)`.
- **`condition_breached`.** At least one item is `unmet(...)`. Unmet decides before unknown.
- **`input_problems(Problems)`.** The profile is malformed. The verdict is `gdpr_chapter_v_extras_verdict(input_problems(Problems), [])`.

The decision is computed with `decide_labeled(Checklist, labels(no_condition_breached, more_input_needed, condition_breached), Status)`.

## 4. Profile keys (eleven, in this order)

This is the order of `root_exports` and of `input_contract`. Each key is a bare atom read only with `profile_get/3`, by presence first and then by value. Absence is tested as `\+ profile_get(Profile, Key, _)`.

| # | Key | Kind | Values |
|---|---|---|---|
| 1 | `transfer_relies_on_article_49_1_second_subparagraph` | outside fact | `attested(true\|false, attestation(BY, AT, REASON, EVIDENCE))` |
| 2 | `party_role` | enumeration | `controller`, `processor` |
| 3 | `supervisory_authority_informed_of_transfer` | crisp | `true`, `false` |
| 4 | `data_subject_informed_of_transfer` | crisp | `true`, `false` |
| 5 | `data_subject_informed_of_compelling_legitimate_interests` | crisp | `true`, `false` |
| 6 | `assessment_documented_in_records` | crisp | `true`, `false` |
| 7 | `suitable_safeguards_documented_in_records` | crisp | `true`, `false` |
| 8 | `third_country_judgment_or_decision_requires_transfer` | outside fact | attested, as for key 1 |
| 9 | `international_agreement_basis_for_judgment_or_decision` | outside fact | attested, as for key 1 |
| 10 | `transfer_is_onward_transfer` | outside fact | attested, as for key 1 |
| 11 | `onward_transfer_has_chapter_v_basis` | outside fact | attested, as for key 1 |

Notes on the keys:

- **No numeric, money or date keys.** There are no unit suffixes and no `date(Year, Month, Day)` terms.
- **No judgement key.** No key takes the value `unsure`.
- **The attestation term.**
  - EVIDENCE is `none`, `url(URL, RETRIEVED_AT)` or `document(UPLOAD_ID, SHA256)`.
  - None of the four attestation arguments is inspected.
  - The whole `attested(...)` term is copied into BASIS as `outside_fact(KEY, Attested)`.

### 4.1 Outside-fact table

This table lives in `kernel.clausal` as `outside_fact_reference(Key, Citation, Target)`.

| Key | Citation | Target |
|---|---|---|
| `transfer_relies_on_article_49_1_second_subparagraph` | `eu_reg_2016_679_art_49_1_second_subpara` | `second_subparagraph_transfer_statement` |
| `third_country_judgment_or_decision_requires_transfer` | `eu_reg_2016_679_art_48` | `foreign_judgment_requires_transfer_statement` |
| `international_agreement_basis_for_judgment_or_decision` | `eu_reg_2016_679_art_48` | `international_agreement_basis_statement` |
| `transfer_is_onward_transfer` | `eu_reg_2016_679_art_44` | `onward_transfer_statement` |
| `onward_transfer_has_chapter_v_basis` | `eu_reg_2016_679_art_44` | `onward_transfer_chapter_v_basis_statement` |

## 5. Citation-key atoms (`citations.clausal`)

All atoms use the canonical `_lexicon/citations.yaml` scheme; no shortened atom is ever invented.

### 5.1 Load-bearing provisions

- `eu_reg_2016_679_art_44` — Art 44, first sentence (onward transfers).
- `eu_reg_2016_679_art_48` — Art 48.
- `eu_reg_2016_679_art_49_1_second_subpara` — Art 49(1), second subparagraph (the two duties to inform; `not_a_processor_duty`).
- `eu_reg_2016_679_art_49_6` — Art 49(6) (the documentation duty).

`second_subpara` is the canonical lexicon spelling. If C6 flags `subpara`, add `% lint: canonical citation atom` beside it; do not shorten or rename the atom.

### 5.2 Target atoms

These are used only inside `cite(TARGET)` at the absent referral:

- `second_subparagraph_transfer_statement`
- `foreign_judgment_requires_transfer_statement`
- `international_agreement_basis_statement`
- `onward_transfer_statement`
- `onward_transfer_chapter_v_basis_statement`

### 5.3 Deferred units

Art 30(1)(e), Art 30(2)(c) and Art 30(5) are pinned as sources in the manifest but get NO citation atom. They are read only for interpretation and never appear in CITATIONS.

## 6. Determination slice — `gdpr_chapter_v_extras.clausal`

### 6.1 Statutory value facts owned

- **No numeric thresholds, periods or tables.** No `constant_value` is declared and `parameters.clausal` stays empty of figures, with a comment saying so.
- **The slice owns these domain value facts:**
  - `duty_to_inform(inform_supervisory_authority).`
  - `duty_to_inform(inform_data_subject).`
  - `duty_atom(Duty)` for the three duty atoms.
  - `duty_fulfilment_keys(inform_supervisory_authority, [supervisory_authority_informed_of_transfer]).`
  - `duty_fulfilment_keys(inform_data_subject, [data_subject_informed_of_transfer, data_subject_informed_of_compelling_legitimate_interests]).`
  - `duty_fulfilment_keys(document_assessment_and_safeguards, [assessment_documented_in_records, suitable_safeguards_documented_in_records]).`
  - `duty_citation(inform_supervisory_authority, cite(eu_reg_2016_679_art_49_1_second_subpara)).`
  - `duty_citation(inform_data_subject, cite(eu_reg_2016_679_art_49_1_second_subpara)).`
  - `duty_citation(document_assessment_and_safeguards, cite(eu_reg_2016_679_art_49_6)).`

### 6.2 Rules / requirements

The first route whose guard holds decides. Guards are written to be mutually exclusive, so no second route can also hold.

#### Step 0, shared by all three queries

- `gdpr_chapter_v_extras_input_problems(Profile, Problems)` is called first.
- For the duty query, `wrong_type(duty)` is appended when `Duty` is not one of the three atoms; this includes an unbound `Duty`.
- A non-empty list gives `input_problems(Problems), [], []`.
- Every other route requires the list to be `[]`. Duplicate keys are therefore excluded before `profile_get/3` runs, so `profile_get` yields at most one value per key.

#### `second_subparagraph_duty(Profile, Duty, Result, Basis, Citations)`

Notation: `T` = `transfer_relies_on_article_49_1_second_subparagraph`, `R` = `party_role`, `TB` = `[outside_fact(T, Attested)]`.

1. **Processor and a duty to inform.**
   - Guard: `duty_to_inform(Duty)` and `R == processor`.
   - Answer: `not_a_processor_duty`, Basis `[]`, Citations `[cite(eu_reg_2016_679_art_49_1_second_subpara)]`.
   - This holds whatever `T` is.
2. **T absent.**
   - Guard: not route 1, and `T` absent.
   - Answer: the absent referral on `T`.
3. **Party role absent for a duty to inform.**
   - Guard: `duty_to_inform(Duty)`, `R` absent, and `T` present.
   - Answer: `indeterminate([party_role])`, `[]`, `[]`.
4. **T attested false.**
   - Guard: `T = attested(false, _)` and party settled.
   - Answer: `no_second_subparagraph_transfer`, `TB`, `[DCITE]`.
5. **A fulfilment key false.**
   - Guard: `T = attested(true, _)`, party settled, and `fulfilment_outcome(Profile, Keys, some_false)`.
   - Answer: `duty_not_met`, `TB`, `[DCITE]`.
   - A false key decides before an absent one is named.
6. **A fulfilment key absent.**
   - Guard: `T` true, party settled, and outcome `first_absent(Key)`.
   - Answer: `indeterminate([Key])`, `[]`, `[]`.
7. **Every fulfilment key true.**
   - Guard: `T` true, party settled, and outcome `all_true`.
   - Answer: `duty_met`, `TB`, `[DCITE]`.

Helpers:

- **Party settled.** `Duty == document_assessment_and_safeguards`, or `R == controller`. `R` is never read for the documentation duty.
- **`fulfilment_outcome(Profile, Keys, Outcome)`** has three exclusive clauses:
  - `some_false`: guarded by `\+ \+ (member(Key, Keys), profile_get(Profile, Key, false))`, so it gives one solution even when both keys are false.
  - `first_absent(Key)`: no key is false, and `first_absent_key/3` recurses over `Keys` by presence.
  - `all_true`: every key is present with value `true`.
- **Keys read.** The query reads only `T`, `R` (for the duties to inform) and the fulfilment keys of its own `Duty`. Every other key never changes its answer.

#### `foreign_judgment_or_decision_recognition(Profile, Result, Basis, Citations)`

Notation: `J` = `third_country_judgment_or_decision_requires_transfer`, `I` = `international_agreement_basis_for_judgment_or_decision`.

1. **J absent.** The absent referral on `J`. `I` is not yet needed.
2. **J attested false.** `article_48_not_engaged`, `[outside_fact(J, AttestedJ)]`, `[cite(eu_reg_2016_679_art_48)]`.
3. **J attested true, I absent.** The absent referral on `I`.
4. **J attested true, I present.**
   - I attested true: `not_barred_by_article_48`.
   - I attested false: `not_recognisable_or_enforceable`.
   - For both: `[outside_fact(J, AttestedJ), outside_fact(I, AttestedI)]`, `[cite(eu_reg_2016_679_art_48)]`.

#### `onward_transfer_condition(Profile, Result, Basis, Citations)`

Notation: `W` = `transfer_is_onward_transfer`, `M` = `onward_transfer_has_chapter_v_basis`.

1. **W absent.** The absent referral on `W`.
2. **W attested false.** `not_an_onward_transfer`, `[outside_fact(W, AttestedW)]`, `[cite(eu_reg_2016_679_art_44)]`.
3. **W attested true, M absent.** The absent referral on `M`.
4. **W attested true, M present.**
   - M attested true: `onward_transfer_may_take_place`.
   - M attested false: `onward_transfer_may_not_take_place`.
   - For both: `[outside_fact(W, AttestedW), outside_fact(M, AttestedM)]`, `[cite(eu_reg_2016_679_art_44)]`.

#### Checklist requirements

The checklist requirements are `gdpr_chapter_v_extras_requirement(RequirementId, Profile, ItemStatus, Citation)`. RequirementId comes FIRST, matching the kit's `requirement/4` closure.

**Requirement ids, in this order, with the call each one makes:**

| Requirement id | Call | Item citation |
|---|---|---|
| `inform_supervisory_authority` | `second_subparagraph_duty(Profile, inform_supervisory_authority, Result, _, _)` | `cite(eu_reg_2016_679_art_49_1_second_subpara)` |
| `inform_data_subject` | `second_subparagraph_duty(Profile, inform_data_subject, Result, _, _)` | `cite(eu_reg_2016_679_art_49_1_second_subpara)` |
| `document_assessment_and_safeguards` | `second_subparagraph_duty(Profile, document_assessment_and_safeguards, Result, _, _)` | `cite(eu_reg_2016_679_art_49_6)` |
| `foreign_judgment_or_decision_recognition` | the Art 48 query | `cite(eu_reg_2016_679_art_48)` |
| `onward_transfer_condition` | the onward-transfer query | `cite(eu_reg_2016_679_art_44)` |

**ItemStatus mapping,** one head clause per RESULT family:

| ItemStatus | RESULT values |
|---|---|
| `met` | `duty_met`, `not_barred_by_article_48`, `onward_transfer_may_take_place` |
| `inapplicable` | `no_second_subparagraph_transfer`, `not_a_processor_duty`, `article_48_not_engaged`, `not_an_onward_transfer` |
| `unmet(Result)` | `duty_not_met`, `not_recognisable_or_enforceable`, `onward_transfer_may_not_take_place` |
| `unknown([Result])` | `indeterminate(_)`, `needs_legal_review(_, _)` |

`inapplicable` is a kit vocabulary atom. Every item carries its `cite(...)`, met items included. The verdict's `Citations` are the sorted set of item citations whose status is not `unknown(...)`.

### 6.3 Verdict atoms

The slice uses the RESULT atoms of section 2.1, the non-final compounds of section 2.2 and the facade STATUS atoms of section 3.

### 6.4 Predicates SHARED with other files (these, and only these, go in `kernel.clausal`)

- **`gdpr_chapter_v_extras_input_problems/2`, with its typed contract.**
  - `contract_key(Key, Type)` facts list the eleven keys in contract order. Type is `outside_fact`, `crisp` or `party_role_enumeration`.
  - The check yields one solution per term, guarded by `var/1`, `nonvar/1` and `==`, never by unification against the input:
    - an unbound profile, a partial list, or a list with a non-`attribute(KEY, VALUE)` or unbound element gives `[wrong_type(profile)]`;
    - then, per contract key in order, `duplicate_key(KEY)` (its values are not read), or else `wrong_type(KEY)`;
    - then `unknown_key(KEY)` for keys outside the eleven, by first occurrence and compared with `==`. A non-atom KEY, an unbound variable included, is unknown as given.
  - The duty argument check `duty_argument_problems(Duty, Problems)` gives `[]` or `[wrong_type(duty)]`.
- **`outside_fact_reference(Key, Citation, Target)`.** The five rows of section 4.1.
- **`absent_referral(Key, Result)`.** Builds the absent referral term of section 2.2 from `outside_fact_reference/3`.

The slice reads presence and values itself with `profile_get/3`. The facade and `queries.clausal` read only the three called queries and the input check.

### 6.5 Tests (per rule, in `tests/`)

- **One positive test per route** of each query, including:
  - route 1 with `T` absent and with `T` attested false;
  - route 2 with `party_role` absent (the the absent-outside-fact referral rule case, Q9);
  - route 5 with one key false and the other absent.
- **One counting test per route:** `findall(Result-Basis-Citations, Query, All), length(All, 1)`.
- **Unread keys do not matter.** Adding or removing any key a query does not read leaves its answer unchanged; for example, the Art 48 keys leave the duty query unchanged.
- **Absent versus false.** A key that is absent gives a different answer from the same key present and false.
- **Input check cases:**
  - duplicate equal values;
  - duplicate unequal values;
  - a bare `true` for an outside fact;
  - an attested term for a crisp key;
  - `attestation/3`;
  - an unbound value;
  - a non-atom key;
  - an unbound profile;
  - a partial list;
  - a non-attribute element;
  - a bad duty together with a bad profile, which gives `[wrong_type(profile), wrong_type(duty)]`.
- **Pairing.** Every `test(_, fail)` is paired with a positive test over the same case.
- **Property runs** with `validate_props`: totality, determinism and citation completeness over the fixture generator.

## 7. Fixtures (`fixtures.clausal`)

Fixtures use `gdpr_chapter_v_extras_fixture(FixtureName, Profile)`. Each includes a well-formed `attestation(host_user, host_timestamp, Reason, none)`; BY and AT are placeholders the host supplies.

| Fixture name | Profile summary | Expected status |
|---|---|---|
| `controller_all_duties_met` | Controller, `T` true, every crisp key true, Art 48 and onward facts attested false. | `no_condition_breached` |
| `controller_data_subject_not_told_interests` | As above, but the compelling legitimate interests were not told to the data subject. | `condition_breached` |
| `processor_documentation_pending` | Processor, `T` true, the safeguards documentation key absent. | `more_input_needed` |
| `second_subparagraph_unstated` | `T` absent. | `more_input_needed` (the duty queries refer) |
| `foreign_judgment_without_agreement` | `J` true, `I` false. | `condition_breached` |
| `onward_transfer_with_basis` | `W` true, `M` true. | the onward item is `met` |
| `malformed_bare_boolean_outside_fact` | An outside fact supplied as a bare boolean. | `input_problems([wrong_type(transfer_is_onward_transfer)])` |

## 8. Planned reuse (manifest `uses:`)

- **`formalize_lib`:**
  - `profile_get/3` (the only profile reader);
  - `profile_set/3` (`what_if`);
  - `eval_requirements/4` (the checklist, injecting the `gdpr_chapter_v_extras_requirement` closure);
  - `decide_labeled/3` (the status);
  - `item/3`, `unmet/1`, `unknown/1`, `labels/3`, `attribute/2` (constructors);
  - the vocabulary atoms `met` and `inapplicable`.
- **`validate_props`:** `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3` in the test modes.
- **Not used, with reasons:**
  - **`kit.compliance_lib`.** Its deny-overrides modality verdict cannot produce the exact RESULT, BASIS and CITATIONS terms of the called contract, so the compliance checks (#13) are hand-routed limbs.
  - **`kit.query_combinators:what_if/5`.** It overrides dict worlds, while this profile is an attribute list, so `profile_set/3` is used instead.
  - **`date_time`, `deadline_lib`, `rolling_window`, `currency_vocab`, `country`.** This order has no dates, money or country codes.
- **Family backbone (`_common`, deontic).** Nothing is imported until a shared attested-fact reader exists. The local `kernel.clausal` helpers (`outside_fact_reference/3`, `absent_referral/2`) are flagged in the working notes (not published) as a candidate kit module.
