# SIGNATURE — eu/data_protection/gdpr_chapter_v_extras

## Query surface (summary)

**The called contract** is the scored surface. Each query takes PROFILE first and yields exactly ONE solution.

- `second_subparagraph_duty(Profile, Duty, Result, Basis, Citations)`
- `foreign_judgment_or_decision_recognition(Profile, Result, Basis, Citations)`
- `onward_transfer_condition(Profile, Result, Basis, Citations)`
- `gdpr_chapter_v_extras_input_problems(Profile, Problems)`

**The scaffold facade** delegates to these. Its first argument is a REQUEST term naming the query:

- `duty(Duty, Profile)`;
- `foreign_judgment(Profile)`;
- `onward_transfer(Profile)`.

This lets one arity-2 facade serve three queries without ever guessing which one is meant.

**Totality.** Every query answers every term with exactly one solution:

- input problems first;
- then the limb steps, as mutually exclusive clauses guarded by the negation of every earlier step;
- no `!`, no `->`, no `*->`.

**Determinism.** `profile_get/3` meets a duplicated key only when the input check has already answered `input_problems`, so each reached limb sees one value per key.

**Imported figures.** No statutory figures exist: there are no numeric thresholds, periods or dates, so there is no `constant_value`.

## Verdict STATUS atoms (replacing the placeholder `required / permitted / not_applicable`)

Final results:

- `second_subparagraph_duty`: `no_second_subparagraph_transfer`, `not_a_processor_duty`, `duty_met`, `duty_not_met`.
- `foreign_judgment_or_decision_recognition`: `article_48_not_engaged`, `not_barred_by_article_48`, `not_recognisable_or_enforceable`.
- `onward_transfer_condition`: `not_an_onward_transfer`, `onward_transfer_may_take_place`, `onward_transfer_may_not_take_place`.

Non-final status compounds (never the bare atom `indeterminate`):

- `indeterminate([Key])`: exactly one bare key atom, never an outside fact.
- `needs_legal_review(cross_reference_unresolved(cite(Citation), cite(Target)), [resolution(cite(Target), not_attempted), inputs_relied_on([Key-absent])])`.
- `input_problems(Problems)`, with Problems terms `duplicate_key(Key)`, `wrong_type(Key)`, `unknown_key(Key)`, `wrong_type(profile)` and `wrong_type(duty)`.

`open_textured` is never produced, because there is no judgement key.

## Profile keys (eleven, in contract order)

PROFILE = `[attribute(Key, Value), ...]`. It is read ONLY with `profile_get/3`, presence first, then value. Absent means not established.

| # | Key | Kind | Values |
|---|---|---|---|
| 1 | `transfer_relies_on_article_49_1_second_subparagraph` | outside fact | `attested(true\|false, attestation(By, At, Reason, Evidence))` |
| 2 | `party_role` | enumeration | `controller`, `processor` |
| 3 | `supervisory_authority_informed_of_transfer` | crisp | `true`, `false` |
| 4 | `data_subject_informed_of_transfer` | crisp | `true`, `false` |
| 5 | `data_subject_informed_of_compelling_legitimate_interests` | crisp | `true`, `false` |
| 6 | `assessment_documented_in_records` | crisp | `true`, `false` |
| 7 | `suitable_safeguards_documented_in_records` | crisp | `true`, `false` |
| 8 | `third_country_judgment_or_decision_requires_transfer` | outside fact | attested as above |
| 9 | `international_agreement_basis_for_judgment_or_decision` | outside fact | attested as above |
| 10 | `transfer_is_onward_transfer` | outside fact | attested as above |
| 11 | `onward_transfer_has_chapter_v_basis` | outside fact | attested as above |

Notes on values:

- Evidence is `none`, `url(Url, RetrievedAt)` or `document(UploadId, Sha256)`. It is not inspected, beyond requiring that no attestation argument is, or holds, an unbound variable.
- There are no money, numeric or date keys, so no unit suffixes and no `date(Year, Month, Day)` terms are needed.

DUTY argument (not a profile key): `inform_supervisory_authority`, `inform_data_subject`, `document_assessment_and_safeguards`. Any other term, an unbound one included, gives `wrong_type(duty)`.

## Citation-key atoms (canonical lexicon; never shortened, never invented)

Load-bearing:

- `eu_reg_2016_679_art_44`
- `eu_reg_2016_679_art_48`
- `eu_reg_2016_679_art_49_1_second_subpara`
- `eu_reg_2016_679_art_49_6`

Referral targets (used only inside `cite(...)` in THE ABSENT REFERRAL):

- `second_subparagraph_transfer_statement`
- `foreign_judgment_requires_transfer_statement`
- `international_agreement_basis_statement`
- `onward_transfer_statement`
- `onward_transfer_chapter_v_basis_statement`

CITATIONS is a set-like list of `cite(Key)`. Each atom is written once.

## Public predicates (one line each)

**Called contract**

- `second_subparagraph_duty(Profile, Duty, Result, Basis, Citations)`: compliance check (#13) of one Art 49(1) second-subparagraph or Art 49(6) duty. Steps 0–7 below. Cites `eu_reg_2016_679_art_49_1_second_subpara` or `eu_reg_2016_679_art_49_6`.
- `foreign_judgment_or_decision_recognition(Profile, Result, Basis, Citations)`: status determination (#3) of the Art 48 bar. Cites `eu_reg_2016_679_art_48`.
- `onward_transfer_condition(Profile, Result, Basis, Citations)`: compliance check (#13) of an onward transfer under Art 44, first sentence. Cites `eu_reg_2016_679_art_44`.
- `gdpr_chapter_v_extras_input_problems(Profile, Problems)`: the typed input check, which never fails or raises. Problems is `[]` when the profile is well-formed. No citation.

**Scaffold facade** (kept names)

- `decide_gdpr_chapter_v_extras(Request, Verdict)`:
  - Request is `duty(Duty, Profile)`, `foreign_judgment(Profile)` or `onward_transfer(Profile)`.
  - Verdict is `gdpr_chapter_v_extras_verdict(Status, Citations)`, where Status and Citations are the delegated query's Result and Citations.
  - Cites as the delegated query.
- `gdpr_chapter_v_extras_status(Request, Status)`: status determination (#3). Status is the delegated query's Result. Cites as the delegated query.
- `gdpr_chapter_v_extras_checklist(Request, Checklist)`:
  - Checklist is a list of formalize_lib `item(StepId, Status, cite(Key))` rows, one per element of the requested limb.
  - Each Status is `met`, `unmet(Reason)` or `unknown([Key])`.
  - Requirement ids:
    - `party_is_controller`, `transfer_under_second_subparagraph`;
    - `supervisory_authority_informed`, `data_subject_informed_of_transfer`, `data_subject_informed_of_interests`;
    - `assessment_documented`, `safeguards_documented`;
    - `judgment_requires_transfer`, `international_agreement_basis`;
    - `transfer_is_onward`, `onward_basis`.
  - Built with `eval_requirements/4`, using the closure `gdpr_chapter_v_extras_requirement`, called as `requirement(RequirementId, Profile, Status, Citation)`.
  - This is explanatory only. The verdict comes from the limbs, never from `decide_labeled`.
- `gdpr_chapter_v_extras_what_if(Request, Key, Value, Status)`:
  - Overrides Key with Value in the Request's profile (`what_if/5` from query_combinators, with the decide closure `gdpr_chapter_v_extras_status`), then returns the new Status.
  - One solution.
- Fixtures: `gdpr_chapter_v_extras_fixture(Name, Request)` and `gdpr_chapter_v_extras_fixture_expected(Name, Status)`. There is one fixture per terminal step of every limb, including each absent referral, each input-problem shape and the Q9 case.

## Planned reuse (manifest `uses:`)

- **formalize_lib**:
  - `profile_get/3`: the ONLY profile reader in the queries;
  - `eval_requirements/4`, `item/3`, `attribute/2`, `unmet/1`, `unknown/1`: the checklist;
  - `memberd/2`: membership in key tables.
  - Vocabulary atom: `met`.
- **kit.query_combinators**: `what_if/5`, `override_key/4`.
- **validate_props** (tests):
  - `run_props/1`;
  - `prop_totality/3`, `prop_determinism/3`: exactly one solution over a generated profile grid, including duplicates and unbound terms;
  - `prop_citation_complete/3`: every final answer carries its citation;
  - `prop_missing_key_coverage/3`.
- **Not used** (deliberately):
  - `kit.compliance_lib`: its deny-overrides modality lattice and CWA would not reproduce the fixed step order and referral shapes, and could yield several solutions.
  - deadline, rolling_window, date_time: the order has no dates or periods.
  - currency_vocab, vat_category, country: no money, no VAT, no country codes.
- **`_common` family backbone**: none needed.

## Module layout (unchanged file and module names)

`kernel -> citations -> parameters -> gdpr_chapter_v_extras -> queries -> fixtures -> package facade`

- **`kernel.clausal`**: the scaffold floor only. With one determination slice, no predicate must be shared, so nothing domain-specific is added.
- **`citations.clausal`**: the four load-bearing citation keys and five targets, with pinned unit ids:
  - `eu_reg_2016_679_art_44`: `02016R0679-20160504#art_044`;
  - `eu_reg_2016_679_art_48`: `#art_048`;
  - `eu_reg_2016_679_art_49_1_second_subpara`: `#parag_049.001`;
  - `eu_reg_2016_679_art_49_6`: `#parag_049.006`.
- **`parameters.clausal`**: no statutory figures. The TODO is replaced by a comment stating that none exist.
- **`gdpr_chapter_v_extras.clausal`**: the single slice (below).
- **`queries.clausal`**: re-exports the four contract predicates.
- **`fixtures.clausal`**: the fixtures.
- **Package facade**: the four scaffold facade predicates.

## Slice: gdpr_chapter_v_extras.clausal

### Value facts owned (local tables, not a shared constants file)

Contract and key tables:

- `contract_key_order([transfer_relies_on_article_49_1_second_subparagraph, party_role, supervisory_authority_informed_of_transfer, data_subject_informed_of_transfer, data_subject_informed_of_compelling_legitimate_interests, assessment_documented_in_records, suitable_safeguards_documented_in_records, third_country_judgment_or_decision_requires_transfer, international_agreement_basis_for_judgment_or_decision, transfer_is_onward_transfer, onward_transfer_has_chapter_v_basis]).`
- `key_kind(Key, outside_fact | enumeration | crisp).` for each of the eleven.
- `enumeration_value(party_role, controller).` and `enumeration_value(party_role, processor).`

Outside facts, as `outside_fact_entry(Key, Citation, Target)`:

- `transfer_relies_on_article_49_1_second_subparagraph`, `eu_reg_2016_679_art_49_1_second_subpara`, `second_subparagraph_transfer_statement`;
- `third_country_judgment_or_decision_requires_transfer`, `eu_reg_2016_679_art_48`, `foreign_judgment_requires_transfer_statement`;
- `international_agreement_basis_for_judgment_or_decision`, `eu_reg_2016_679_art_48`, `international_agreement_basis_statement`;
- `transfer_is_onward_transfer`, `eu_reg_2016_679_art_44`, `onward_transfer_statement`;
- `onward_transfer_has_chapter_v_basis`, `eu_reg_2016_679_art_44`, `onward_transfer_chapter_v_basis_statement`.

Duties:

- `duty_fulfilment_keys(Duty, Keys)`:
  - `inform_supervisory_authority`: `[supervisory_authority_informed_of_transfer]`;
  - `inform_data_subject`: `[data_subject_informed_of_transfer, data_subject_informed_of_compelling_legitimate_interests]`;
  - `document_assessment_and_safeguards`: `[assessment_documented_in_records, suitable_safeguards_documented_in_records]`.
- `duty_citation(Duty, Cite)`:
  - `inform_supervisory_authority`: `cite(eu_reg_2016_679_art_49_1_second_subpara)`;
  - `inform_data_subject`: `cite(eu_reg_2016_679_art_49_1_second_subpara)`;
  - `document_assessment_and_safeguards`: `cite(eu_reg_2016_679_art_49_6)`.
- `duty_to_inform(inform_supervisory_authority).` and `duty_to_inform(inform_data_subject).`

### Rules / requirements

**Helpers**

- `absent_referral(Key, Result)` builds THE ABSENT REFERRAL from `outside_fact_entry/3`.
- `attested_value(Profile, Key, Value, Attested)` reads via `profile_get/3` and unifies `attested(Value, _)`.
- `key_absent(Profile, Key)` is `\+ profile_get(Profile, Key, _)`.

**Step 0 (all queries).** `gdpr_chapter_v_extras_input_problems/2` walks the list structurally. This is the input check, not a value read.

1. If the profile is unbound, a partial list, holds an unbound element, or holds an element that is not `attribute(_, _)`, Problems is `[wrong_type(profile)]`.
2. Otherwise, for each contract key in `contract_key_order`:
   - if it occurs two or more times: `duplicate_key(Key)`, without reading its values;
   - else, if its single value fails `value_has_type(Kind, Value)`: `wrong_type(Key)`.
3. Then `unknown_key(Key)` once per non-contract key (a non-atom or unbound key included, as given), in first-occurrence order. Identity is compared with `==`, never unification.

Type tests:

- An outside fact must be `nonvar`, `attested(V, attestation(A, B, C, D))` with V `==` `true` or `false`, and A–D each `ground`.
- A crisp key must be `==` `true` or `false`.
- `party_role` must be `==` `controller` or `processor`.

The duty query appends `wrong_type(duty)` unless Duty is `nonvar` and a duty atom. Any problem gives `input_problems(Problems), [], []`.

**`second_subparagraph_duty`** (T, R, the fulfilment keys and DCITE as above; TB = `[outside_fact(T, Attested)]`)

1. A duty to inform, and R `processor`: `not_a_processor_duty, [], [cite(eu_reg_2016_679_art_49_1_second_subpara)]`.
2. T absent: `absent_referral(T)`.
3. A duty to inform, and R absent: `indeterminate([party_role]), [], []`.
4. T `false`: `no_second_subparagraph_transfer, TB, [DCITE]`.
5. T `true` (and R `controller` for a duty to inform), and some fulfilment key `false`: `duty_not_met, TB, [DCITE]`. This is ONE clause: the `false` test is wrapped in `\+ \+` or uses a once-yielding existence check, so two false keys cannot give two solutions.
6. The first absent fulfilment key (in table order) gives `indeterminate([Key]), [], []`.
7. Every fulfilment key `true` gives `duty_met, TB, [DCITE]`.

R is not read for `document_assessment_and_safeguards`.

**`foreign_judgment_or_decision_recognition`** (J, I)

1. J absent: referral on J.
2. J `false`: `article_48_not_engaged, [outside_fact(J, AttestedJ)], [cite(eu_reg_2016_679_art_48)]`.
3. I absent: referral on I.
4. I `true`: `not_barred_by_article_48`. I `false`: `not_recognisable_or_enforceable`. Both give Basis `[outside_fact(J, AttestedJ), outside_fact(I, AttestedI)]` and Citations `[cite(eu_reg_2016_679_art_48)]`.

**`onward_transfer_condition`** (W, M)

1. W absent: referral on W.
2. W `false`: `not_an_onward_transfer, [outside_fact(W, AttestedW)], [cite(eu_reg_2016_679_art_44)]`.
3. M absent: referral on M.
4. M `true`: `onward_transfer_may_take_place`. M `false`: `onward_transfer_may_not_take_place`. Both give Basis `[outside_fact(W, AttestedW), outside_fact(M, AttestedM)]` and Citations `[cite(eu_reg_2016_679_art_44)]`.

**Style and isolation**

- Every ground result is folded into the clause head (C17), one clause per disjoint route.
- No cut and no if-then-else.
- Each query reads only the keys its steps name.

### Verdict atoms

As listed in 'Verdict STATUS atoms' above, grouped per query.

### Shared predicates (kernel.clausal)

None. This is the only determination slice, so nothing must be shared.

### Tests (seven modes, per-rule)

1. **Load.**
2. **Per-step unit tests.** One positive per terminal step of each query, each paired with a negative over the same case.
3. **Precedence.** Covers:
   - processor with T absent, giving `not_a_processor_duty` (Q9);
   - document duty with T absent, giving a referral;
   - a false key beating an absent key;
   - J `false` with I absent.
4. **Irrelevance.** Changing an unread key never changes an answer.
5. **Input check.** Duplicates, wrong types, a bare `true` for an outside fact, an unbound attestation argument, an unknown non-atom key, a partial list, and `[wrong_type(profile), wrong_type(duty)]`.
6. **Properties.** Totality and exactly-one-solution, via `findall` plus `length(Solutions, 1)`.
7. **Fixtures.** Each fixture round-trips through the facade and what-if.
