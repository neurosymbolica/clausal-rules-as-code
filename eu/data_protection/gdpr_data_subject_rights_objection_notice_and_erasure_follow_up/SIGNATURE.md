# SIGNATURE — eu/data_protection/gdpr_data_subject_rights_objection_notice_and_erasure_follow_up

## Public query surface

The two named queries are authoritative. The facade combines them:

```
decide_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up(PROFILE,
    gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_verdict(STATUS, CITATIONS))
```

In this call, `STATUS = determination(NOTICE_RESULT, FOLLOW_UP_RESULT)`, and `CITATIONS` is the set union of the citations of both queries.

`gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_status(PROFILE, STATUS)` gives the same STATUS without the citations.

- **Totality.** Every query yields exactly one solution for every term it is given. Counting tests use `findall` with `length(_, 1)`.
- **Determinism.** No result is yielded twice.
- **Imported figures.** There are none. The two provisions state no numeric threshold and no period, so `parameters.clausal` declares nothing.

## Verdict STATUS atoms (these replace `required / permitted / not_applicable`)

Final RESULT atoms for `objection_right_notice`, GDPR Art 21(4):

- `notice_not_owed`
- `notice_not_yet_due`
- `notice_complies`
- `notice_does_not_comply`

Final RESULT atoms for `erasure_follow_up_duty`, GDPR Art 17(2):

- `follow_up_duty_does_not_apply`
- `follow_up_duty_met`
- `follow_up_duty_not_met`

Status compounds. Each query returns exactly one, unwrapped. The bare atom `indeterminate` is never written.

- `indeterminate([KEY])` — one bare key; never an outside fact.
- `needs_legal_review(cross_reference_unresolved(cite(CITATION), cite(TARGET)), [resolution(cite(TARGET), not_attempted), inputs_relied_on([KEY-absent])])`
- `needs_legal_review(open_textured(KEY, cite(CITATION)), [inputs_relied_on([KEY-unsure])])`
- `input_problems(PROBLEMS)` — PROBLEMS terms: `duplicate_key/1`, `wrong_type/1`, `unknown_key/1`.

Other bare atoms exported from the root (`root_exports`):

- `unsure`
- `absent`
- `not_attempted`
- `true`
- `false`
- the 8 keys
- the 7 RESULT atoms

Checklist decision labels (query type #2, eligibility view): `labels(requirements_met, requirements_not_established, requirements_not_met)`.

Compliance verdict modalities (query type #13): the `kit/compliance_lib` lattice, `obligatory / forbidden / permitted` with deny-overrides.

## Profile keys (attribute list, read only with `profile_get/3`; key order is fixed)

The 8 keys, in this order. This order is used for `root_exports`, `input_contract`, the input check and every step of the status rule.

| # | Key | Kind | Type | Read by |
|---|---|---|---|---|
| 1 | `right_to_object_applies` | outside fact | `attested(true\|false, attestation(BY, AT, REASON, EVIDENCE))` | objection_right_notice |
| 2 | `first_communication_with_data_subject_has_taken_place` | crisp | `true \| false` | objection_right_notice |
| 3 | `right_explicitly_brought_to_attention_by_first_communication` | crisp | `true \| false` | objection_right_notice |
| 4 | `right_presented_separately_from_other_information` | crisp | `true \| false` | objection_right_notice |
| 5 | `right_presented_clearly` | judgement | `true \| false \| unsure` | objection_right_notice |
| 6 | `controller_made_personal_data_public` | crisp | `true \| false` | erasure_follow_up_duty |
| 7 | `controller_obliged_to_erase_under_article_17_1` | outside fact | `attested(true\|false, attestation(BY, AT, REASON, EVIDENCE))` | erasure_follow_up_duty |
| 8 | `reasonable_steps_taken_to_inform_other_controllers` | judgement | `true \| false \| unsure` | erasure_follow_up_duty |

- There are no numeric keys and no date keys.
- EVIDENCE is one of `none`, `url(URL, RETRIEVED_AT)` or `document(UPLOAD_ID, SHA256)`. It is not inspected beyond groundness.
- Absent means not established. Absence is never an input problem.

## Citation-key atoms (canonical lexicon, `_lexicon/citations.yaml`; no shortened atoms)

- `eu_reg_2016_679_art_21_4` — GDPR Art 21(4). It is load-bearing for `objection_right_notice`, the `right_presented_clearly` referral and the `right_to_object_applies` referral.
- `eu_reg_2016_679_art_17_2` — GDPR Art 17(2). It is load-bearing for `erasure_follow_up_duty`, the `reasonable_steps_taken_to_inform_other_controllers` referral and the `controller_obliged_to_erase_under_article_17_1` referral.
- Cross-reference TARGET atoms, used only inside `cross_reference_unresolved/2` and `resolution/2`:
  - `article_21_right_to_object_statement` — target for `right_to_object_applies`;
  - `article_17_1_erasure_obligation_statement` — target for `controller_obliged_to_erase_under_article_17_1`.

The deferred units (Art 21(1), 21(2), 17(1), 17(3)) get no citation key in this package. They are named in comments only.

## Public predicates

Each public predicate is listed with its arguments, a description and its citation.

- `objection_right_notice(Profile, Result, Basis, Citations)`
  - Gives the Art 21(4) notice verdict, following the ladder in the slice section.
  - Final answers have `Basis = [outside_fact(right_to_object_applies, Attested)]` and `Citations = [cite(eu_reg_2016_679_art_21_4)]`.
  - Status answers have `Basis = []` and `Citations = []`.
  - Citation: `eu_reg_2016_679_art_21_4`.
- `erasure_follow_up_duty(Profile, Result, Basis, Citations)`
  - Gives the Art 17(2) follow-up verdict.
  - Final answers have `Citations = [cite(eu_reg_2016_679_art_17_2)]`.
  - Final answers have `Basis = [outside_fact(controller_obliged_to_erase_under_article_17_1, Attested)]` when that key is present, and `[]` when it is absent.
  - Status answers have `Basis = []` and `Citations = []`.
  - Citation: `eu_reg_2016_679_art_17_2`.
- `gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_input_problems(Profile, Problems)`
  - The typed input check. It gives exactly one solution and never fails or raises.
  - `[]` means the profile is well formed.
  - Problems are listed in this order:
    1. per contract key in key order, `duplicate_key(K)`, otherwise `wrong_type(K)`;
    2. then `unknown_key(K)`, in first-occurrence order;
    3. a profile that is not an attribute list gives `[wrong_type(profile)]` alone.
  - Citation: none (it renders the input contract).
- `decide_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up(Profile, Verdict)`
  - Facade. `Verdict = gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_verdict(determination(NoticeResult, FollowUpResult), Citations)`.
  - It calls both queries once each. `Citations` is the sorted union of their citations.
  - Citations: `eu_reg_2016_679_art_21_4`, `eu_reg_2016_679_art_17_2`.
- `gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_status(Profile, Status)`
  - Gives `Status = determination(NoticeResult, FollowUpResult)`.
  - Citations: both.
- `gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_checklist(Profile, Checklists)` — query type #2, eligibility.
  - `Checklists = [assessment(objection_right_notice, Decision, Items), assessment(erasure_follow_up_duty, Decision, Items)]`.
  - Built with `formalize_lib:assess/6`, using the requirement closure `gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_requirement` and the labels above.
  - Every item carries `cite(...)`.
  - The checklist is an explanatory, cited view. RESULT authority stays with the two queries.
  - If input problems are present, both decisions are the `input_problems(PROBLEMS)` term.
  - Citations: both.
- `gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_action_compliance(Profile, Action, Verdict)` — query type #13, compliance check.
  - Answers whether a proposed action is allowed in the current state.
  - `Action` is one of:
    - `first_communication_without_objection_notice`;
    - `first_communication_with_objection_notice`;
    - `conclude_erasure_without_informing_other_controllers`;
    - `conclude_erasure_after_informing_other_controllers`.
  - When the relevant query's RESULT is final, the predicate calls `kit/compliance_lib:compliance_check/7`. It uses the slice's `Applies` closure, the norms `nm(norm_article_21_4_objection_notice, obligatory)` and `nm(norm_article_17_2_inform_other_controllers, obligatory)`, and deny-overrides.
  - When the relevant query's RESULT is a status compound, `Verdict` is that compound, unwrapped. This keeps the check fail-closed: it never assumes permission on missing facts.
  - Citations: `eu_reg_2016_679_art_21_4` and `eu_reg_2016_679_art_17_2`.
- `gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_what_if(Profile, Key, Value, Verdict)`
  - Gives the facade verdict after setting `Key` to `Value`.
  - Built with `kit/query_combinators:what_if/5`, passing the closure `decide_gdpr_data_subject_rights_objection_notice_and_erasure_follow_up`.
  - The input check still runs first on the edited profile.
  - Citations: both.
- Fixtures, `fixtures.clausal`: `gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_fixture(Name, Profile)` and `gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_fixture_expected(Name, NoticeResult, FollowUpResult)`.
  - There is one fixture per ladder step of each query, plus input-problem fixtures. Attestations in fixtures use ground placeholder atoms such as `attestation(fixture_host, fixture_time, fixture_reason, none)`.

Result constructors are exported and never called as queries:

- `indeterminate/1`
- `needs_legal_review/2`
- `open_textured/2`
- `cross_reference_unresolved/2`
- `resolution/2`
- `inputs_relied_on/1`
- `outside_fact/2`
- `attested/2`
- `attestation/4`
- `url/2`
- `document/2`
- `input_problems/1`
- `unknown_key/1`
- `wrong_type/1`
- `duplicate_key/1`
- `determination/2`
- `gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_verdict/2`

## Planned reuse (becomes manifest `uses:`)

- `formalize_lib`:
  - profile access: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `profile_keys/2`;
  - judgement checks: `check_tri/4` for the bare tri-state judgements in checklist items, and `check_true/4` and `check_false/4` for the crisp keys;
  - checklist engine: `assess/6`, `labels/3`, `item/3`, `unmet/1`, `unknown/1`, `assessment/3`;
  - defeasibility: `not_defeated/3`;
  - list helpers: `not_member/2`, `memberd/2`.
- `kit/compliance_lib` — `compliance_check/7`, `nm/2`, `verdict/5`, for query type #13.
- `kit/query_combinators` — `what_if/5`, for `what_if/4`.
- `validate_props`, used only in tests:
  - `run_props/1`;
  - `prop_totality/3`;
  - `prop_determinism/3`;
  - `prop_citation_complete/3`;
  - `prop_missing_key_coverage/3`;
  - `bad_citation/1`.
- Not used: `deadline_lib`, `date_time`, `rolling_window`, `currency_vocab`, `vat_category`, `country`. There are no periods, dates, money or country atoms in scope.
- Family backbone (`_common`, deontic): none required beyond `compliance_lib`. No `_common` predicate is re-defined locally.

## Layer files

- **`kernel.clausal`** — the shared floor. It holds only generic, domain-neutral helpers, and no legal content.
  - `kernel_attribute_list/1`: a proper list, every element nonvar and of the form `attribute(_, _)`.
  - `kernel_occurrences/3`: counts a key by `==`, without binding.
  - `kernel_attested_well_formed/1`: `attested(V, attestation(A, B, C, D))` with V `true` or `false`, and A, B, C, D each `ground/1`.
  - `kernel_outside_fact_basis/3`: builds `[outside_fact(Key, Attested)]` or `[]` by presence.
- **`citations.clausal`** — the two `cite` keys and the two TARGET atoms, with unit ids.
- **`parameters.clausal`** — intentionally empty of `constant_value` declarations. A comment says why: no figures appear in Art 21(4) or Art 17(2).
- **`queries.clausal`** — re-exports the two queries, the input check, the checklist, `action_compliance` and `what_if` from the slice and the facade wiring.
- **`fixtures.clausal`** — the fixtures described above.
- **Package facade** — decide, status, checklist, what_if, and the root_exports atoms.

## Slice: `gdpr_data_subject_rights_objection_notice_and_erasure_follow_up.clausal`

This slice is self-contained for both determinations. It imports `kernel`, `citations` and `formalize_lib`.

### Value facts this slice owns

- **Key order.** `contract_key_order/1` holds the list of the 8 keys, in the order above.
- **Key kinds.** `contract_key_kind(Key, Kind)` gives the kind of each key: `outside_fact`, `crisp` or `judgement`.
- **Outside-fact table.** `outside_fact_row(Key, Citation, Target)` has two rows:
  - `right_to_object_applies`, `eu_reg_2016_679_art_21_4`, `article_21_right_to_object_statement`;
  - `controller_obliged_to_erase_under_article_17_1`, `eu_reg_2016_679_art_17_2`, `article_17_1_erasure_obligation_statement`.
- **Referral table.** `judgement_referral_row(Key, Citation)` has two rows:
  - `right_presented_clearly`, `eu_reg_2016_679_art_21_4`;
  - `reasonable_steps_taken_to_inform_other_controllers`, `eu_reg_2016_679_art_17_2`.
- **Fetchers.** `outside_fact_fetcher(Key, none)` holds for both outside facts. Resolution is always `not_attempted`.
- **No thresholds, periods or tables of figures.**

### Input check (rules)

1. If the profile is not an attribute list, the result is `[wrong_type(profile)]`. This covers an unbound profile, a partial list, an unbound element, and an element that is not `attribute/2`.
2. Otherwise, for each contract key K in key order:
   - if K occurs twice or more (by `==`), the problem is `duplicate_key(K)`, and the value is not read;
   - else, if K is present once and its value has the wrong type, the problem is `wrong_type(K)`. The type tests are as follows, each beginning with a `var/1` test:
     - crisp: `true` or `false`;
     - judgement: `true`, `false` or `unsure`;
     - outside fact: `kernel_attested_well_formed/1`.
3. Then `unknown_key(K)` is added once for each key that is not `==` to a contract key, in first-occurrence order. Non-atom keys are kept as given, and so are unbound keys (the same variable).
4. The whole result is built in one `findall`/`append` pipeline. It yields exactly one solution.

### Query ladder: `objection_right_notice`, Art 21(4)

The keys are:

- R = `right_to_object_applies` (outside fact);
- F = `first_communication_with_data_subject_has_taken_place`;
- E = `right_explicitly_brought_to_attention_by_first_communication`;
- S = `right_presented_separately_from_other_information`;
- CL = `right_presented_clearly` (judgement).

Each step below is its own clause, and the guards are disjoint.

| Step | Guard | Result |
|---|---|---|
| 0 | Problems \== [] | `input_problems(Problems)` |
| 1 | R = attested(false, _) | `notice_not_owed` |
| 2 | R absent or attested true; F absent | `indeterminate([first_communication_with_data_subject_has_taken_place])` |
| 3a | R attested true; F false | `notice_not_yet_due` |
| 3b | R absent; F false | absent referral on R |
| 4a | R attested true; F true; first-false helper: E false, or E not false and S false, or E, S not false and CL false | `notice_does_not_comply` |
| 4b | R absent; F true; same helper | absent referral on R |
| 5 | F true; none of E, S, CL false; first absent of E, S, CL (disjoint: E absent; E true and S absent; E, S true and CL absent) | `indeterminate([KEY])` |
| 6 | F, E, S true; CL true or unsure; R absent | absent referral on R |
| 7 | R attested true; F, E, S true; CL unsure | `needs_legal_review(open_textured(right_presented_clearly, cite(eu_reg_2016_679_art_21_4)), [inputs_relied_on([right_presented_clearly-unsure])])` |
| 8 | R attested true; F, E, S, CL true | `notice_complies` |

The absent referral on R is:

```
needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_21_4), cite(article_21_right_to_object_statement)), [resolution(cite(article_21_right_to_object_statement), not_attempted), inputs_relied_on([right_to_object_applies-absent])])
```

- Final steps 1, 3a, 4a and 8 return BASIS `[outside_fact(right_to_object_applies, Attested)]` and CITATIONS `[cite(eu_reg_2016_679_art_21_4)]`.
- All other steps return `[]` and `[]`.

### Query ladder: `erasure_follow_up_duty`, Art 17(2)

The keys are:

- P = `controller_made_personal_data_public`;
- O = `controller_obliged_to_erase_under_article_17_1` (outside fact);
- RS = `reasonable_steps_taken_to_inform_other_controllers` (judgement).

| Step | Guard | Result |
|---|---|---|
| 0 | Problems \== [] | `input_problems(Problems)` |
| 1a | P false | `follow_up_duty_does_not_apply` |
| 1b | P absent or true; O = attested(false, _) | `follow_up_duty_does_not_apply` |
| 2 | P absent; O absent or attested true | `indeterminate([controller_made_personal_data_public])` |
| 3 | P true; O absent or attested true; RS absent | `indeterminate([reasonable_steps_taken_to_inform_other_controllers])` |
| 4 | P true; O absent; RS present | absent referral on O |
| 5 | P true; O attested true; RS unsure | `needs_legal_review(open_textured(reasonable_steps_taken_to_inform_other_controllers, cite(eu_reg_2016_679_art_17_2)), [inputs_relied_on([reasonable_steps_taken_to_inform_other_controllers-unsure])])` |
| 6a | P true; O attested true; RS true | `follow_up_duty_met` |
| 6b | P true; O attested true; RS false | `follow_up_duty_not_met` |

The absent referral on O is:

```
needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_17_2), cite(article_17_1_erasure_obligation_statement)), [resolution(cite(article_17_1_erasure_obligation_statement), not_attempted), inputs_relied_on([controller_obliged_to_erase_under_article_17_1-absent])])
```

- Final steps 1a, 1b, 6a and 6b return CITATIONS `[cite(eu_reg_2016_679_art_17_2)]`.
- Their BASIS is `kernel_outside_fact_basis(Profile, controller_obliged_to_erase_under_article_17_1, Basis)`. For example, 1a with O absent gives `[]`.
- All other steps return `[]` and `[]`.

### Defeasible obligations (for compliance, query type #13)

- **Art 21(4) notice obligation.**
  - Rule: `obligation_in_force(norm_article_21_4_objection_notice, Profile)` holds when R is attested true and `not_defeated(norm_article_21_4_objection_notice, Profile, objection_notice_defeater)`.
  - Defeater: `objection_notice_defeater(norm_article_21_4_objection_notice, Profile) :- once(profile_get(Profile, right_to_object_applies, attested(false, _))).`
- **Art 17(2) follow-up duty.**
  - Rule: `obligation_in_force(norm_article_17_2_inform_other_controllers, Profile)` holds when P is true, O is attested true, and the duty is not defeated.
  - Defeater: a `once/1`-guarded defeater on P false or O attested false.
- **Applies closure for `compliance_check/7`.** It maps actions to norms:
  - `first_communication_without_objection_notice` fires as forbidden when the Art 21(4) obligation is in force;
  - `conclude_erasure_without_informing_other_controllers` fires as forbidden when the Art 17(2) duty is in force;
  - the two `with` / `after` actions are permitted.

### Requirements (checklist, query type #2)

The head is `gdpr_data_subject_rights_objection_notice_and_erasure_follow_up_requirement(RequirementId, Profile, Status, Citation)`, with the RequirementId FIRST. Each requirement has three disjoint clauses: met, unmet and unknown.

Notice requirements, all citing `cite(eu_reg_2016_679_art_21_4)`:

- `requirement_right_to_object_attested` — outside fact R. Attested true gives met, attested false gives `unmet(notice_not_owed)`, absent gives `unknown([right_to_object_applies])`. This happens in the checklist view only, never in MISSING_KEYS.
- `requirement_first_communication_reached` — F.
- `requirement_explicitly_brought_to_attention` — E.
- `requirement_presented_separately` — S.
- `requirement_presented_clearly` — CL, via `check_tri/4`. `unsure` gives unknown.

Follow-up requirements, all citing `cite(eu_reg_2016_679_art_17_2)`:

- `requirement_controller_made_data_public` — P.
- `requirement_controller_obliged_to_erase_attested` — O.
- `requirement_reasonable_steps_taken` — RS, via `check_tri/4`.

### Verdict atoms owned

- Notice: `notice_not_owed`, `notice_not_yet_due`, `notice_complies`, `notice_does_not_comply`.
- Follow-up: `follow_up_duty_does_not_apply`, `follow_up_duty_met`, `follow_up_duty_not_met`.
- The status compounds as above.

### Predicates shared with another slice

- There is only one slice. Nothing legal is shared.
- The slice imports from `kernel.clausal` only the generic helpers: attribute-list test, `==` occurrence count, attested well-formedness, and BASIS builder.
- Nothing in this slice is exported to the kernel.

### Per-rule tests (in `tests/`, seven modes)

1. Unit: one test per ladder step of each query, each paired with its negative.
2. Counting: `findall` with `length(_, 1)` for every query over the full enumeration of the 8 keys. Each key ranges over absent, every valid value, and one wrong value.
3. Input check: duplicates, wrong types (bare value on an outside fact, `attested` on a crisp key, unbound value, attestation holding a variable), unknown keys (atom, number, string, compound, unbound), non-list, partial list, unbound element, and ordering of PROBLEMS.
4. Invariance: an unread key, present or absent, never changes a query's answer. Supplying an irrelevant absent key never changes BASIS.
5. Status precedence, checked against the status rule by brute-force completion over every profile:
   - settled comes first;
   - then the missing key;
   - then the absent outside fact;
   - then the unsure judgement.
6. Fixtures/golden: every fixture matches its expected pair.
7. Properties and mutations: `prop_totality`, `prop_determinism` and `prop_citation_complete` via `validate_props`. A mutation per guard (flip true/false, swap ladder order) must be killed.
