# SIGNATURE — eu/data_protection/gdpr_art36_3_consultation_request

Shape family: deontic. Layout (kept as scaffolded; no file or module renamed): `kernel -> citations -> parameters -> gdpr_art36_3_consultation_request -> queries -> fixtures -> package facade`. One determination slice: `gdpr_art36_3_consultation_request.clausal`. v2 manifest; seven test modes.

## 1. Public query surface (summary)

The three CONTRACT queries (names fixed by the called contract, PROFILE first, exactly one solution each):

- `consultation_request_status(Profile, Result, Basis, Citations)`
- `missing_consultation_request_items(Profile, Items, Basis, Citations)`
- `gdpr_art36_3_consultation_request_input_problems(Profile, Problems)`

The scaffold FACADE (names kept): `decide_gdpr_art36_3_consultation_request/2`, `gdpr_art36_3_consultation_request_status/2`, `gdpr_art36_3_consultation_request_checklist/2`, `gdpr_art36_3_consultation_request_what_if/4`, and the fixtures predicates. The facade is a thin wrapper over the contract queries; it adds no rule.

Totality / determinism claims: every public predicate yields exactly ONE solution for every ground or non-ground PROFILE term (the input check never fails or raises; every other query runs the input check first). No `!`, `->`, `*->`, `once/1`; ground verdicts folded into clause heads (C17), one clause per disjoint route. No figure is imported or declared: the order has no statutory number, period or threshold.

## 2. Verdict STATUS atoms (replace placeholders `required, permitted, not_applicable`)

Final result atoms (status query):
- `consultation_request_complete`
- `consultation_request_incomplete`
- `not_governed_by_article_36_3`

Final answer of the items query: a list drawn from the six item atoms (possibly `[]`), or `not_governed_by_article_36_3`.

Item atoms (order (a) to (f), the order of every list):
1. `respective_responsibilities` — point (a)
2. `purposes_and_means` — point (b)
3. `measures_and_safeguards` — point (c)
4. `data_protection_officer_contact_details` — point (d)
5. `data_protection_impact_assessment` — point (e)
6. `other_requested_information` — point (f)

Open statuses (exactly one of, in precedence order):
- `input_problems(Problems)` — Problems built from `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.
- `indeterminate([Key])` — one bare crisp key atom. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_36_3_a), cite(controller_and_processor_roles_statement)), [resolution(cite(controller_and_processor_roles_statement), not_attempted), inputs_relied_on([joint_controllers_or_processors_involved-absent])])` — THE ABSENT REFERRAL, the only referral.

Auxiliary atoms in root_exports: `absent`, `not_attempted`. Result constructors exported (never called as queries): `indeterminate/1`, `needs_legal_review/2`, `cross_reference_unresolved/2`, `resolution/2`, `inputs_relied_on/1`, `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

Internal item-state atoms (slice-private, not exported): `satisfied`, `missing`, `open_named(Key, Deciding)` with Deciding `deciding` or `not_deciding`, `open_by_referral`.

## 3. Profile keys (attribute list, read only with `profile_get/3`; bare atoms; this order = root_exports order = input_contract order)

| # | Key | Kind | Values | True means |
|---|---|---|---|---|
| 1 | `consultation_under_article_36_1` | crisp | `true` / `false` | the controller consults, or is about to consult, under Art 36(1) |
| 2 | `joint_controllers_or_processors_involved` | OUTSIDE FACT | `attested(true or false, attestation(BY, AT, REASON, EVIDENCE))`; EVIDENCE `none`, `url(URL, RETRIEVED_AT)` or `document(UPLOAD_ID, SHA256)` | at least one joint controller or processor is involved besides the controller (citation `eu_reg_2016_679_art_36_3_a`, target `controller_and_processor_roles_statement`) |
| 3 | `respective_responsibilities_provided` | crisp | `true` / `false` | the request states the respective responsibilities of the controller and every joint controller and processor involved |
| 4 | `purposes_and_means_provided` | crisp | `true` / `false` | the request states purposes and means of the intended processing |
| 5 | `measures_and_safeguards_provided` | crisp | `true` / `false` | the request states the measures and safeguards protecting data subjects |
| 6 | `data_protection_officer_designated` | crisp | `true` / `false` | the controller has designated a DPO |
| 7 | `data_protection_officer_contact_details_provided` | crisp | `true` / `false` | the request gives that DPO's contact details |
| 8 | `impact_assessment_provided` | crisp | `true` / `false` | the controller provides its Art 35 DPIA |
| 9 | `other_information_requested_by_supervisory_authority` | crisp | `true` / `false` | by the moment the caller asks, the authority has asked for information beyond (a) to (e) |
| 10 | `requested_other_information_provided` | crisp | `true` / `false` | every piece of that information is provided |

No numeric key, no date key, no money key, no judgement key, no enumeration key. Booleans are the atoms `true`/`false`, never strings or Python booleans. Absence is never a problem.

## 4. Citation-key atoms (canonical lexicon `_lexicon/citations.yaml`; never shortened)

- `eu_reg_2016_679_art_36_3` — Regulation (EU) 2016/679 Art 36(3), chapeau (`02016R0679-20160504#parag_036.003`)
- `eu_reg_2016_679_art_36_3_a` — point (a) (`#point_036.003_a`)
- `eu_reg_2016_679_art_36_3_b` — point (b) (`#point_036.003_b`)
- `eu_reg_2016_679_art_36_3_c` — point (c) (`#point_036.003_c`)
- `eu_reg_2016_679_art_36_3_d` — point (d) (`#point_036.003_d`)
- `eu_reg_2016_679_art_36_3_e` — point (e) (`#point_036.003_e`)
- `eu_reg_2016_679_art_36_3_f` — point (f) (`#point_036.003_f`)
- `controller_and_processor_roles_statement` — referral TARGET only (inside `cite(...)` in THE ABSENT REFERRAL), not a provision of this order.

Art 36(1) and Art 36(5) are read for reading (1) and Q1 only and are never emitted in CITATIONS. `citations.clausal` holds one fact per key above with its pinned unit id and verbatim text (36(3) as the paragraph unit and the six point units joined by one space).

Citation sets (set-like lists, order not scored):
- SEVEN = `[cite(eu_reg_2016_679_art_36_3), cite(eu_reg_2016_679_art_36_3_a), cite(eu_reg_2016_679_art_36_3_b), cite(eu_reg_2016_679_art_36_3_c), cite(eu_reg_2016_679_art_36_3_d), cite(eu_reg_2016_679_art_36_3_e), cite(eu_reg_2016_679_art_36_3_f)]` — every final answer other than not-governed.
- PARAGRAPH = `[cite(eu_reg_2016_679_art_36_3)]` — `not_governed_by_article_36_3`.
- `[]` — every open status.

## 5. Public predicates (one line each)

- `consultation_request_status(Profile, Result, Basis, Citations)`: compliance check (#13) — is the consultation request complete under Art 36(3); steps 0–7 of THE LIMBS — cite SEVEN / PARAGRAPH / [] (`eu_reg_2016_679_art_36_3` and points (a)–(f)).
- `missing_consultation_request_items(Profile, Items, Basis, Citations)`: enumeration (#4) — list of MISSING item atoms in order (a)–(f); steps 0–5 of THE LIMBS — cite SEVEN / PARAGRAPH / [].
- `gdpr_art36_3_consultation_request_input_problems(Profile, Problems)`: THE INPUT CHECK against the typed input_contract; `[]` when well-formed — no citation (renders no provision).
- `decide_gdpr_art36_3_consultation_request(Profile, Verdict)`: Verdict = `gdpr_art36_3_consultation_request_verdict(Result, Citations)` with Result and Citations from `consultation_request_status/4` — cites as that query.
- `gdpr_art36_3_consultation_request_status(Profile, Status)`: Status = the Result of `consultation_request_status/4` — cites as that query.
- `gdpr_art36_3_consultation_request_checklist(Profile, Checklist)`: justification (#7) — Checklist = six `item(ItemAtom, Status, cite(PointKey))` rows in order (a)–(f), produced by `eval_requirements/4` over `requirement/4`; Status `met` (SATISFIED), `unmet(not_provided(ContentKey))` (MISSING), `unknown([Key])` (OPEN, named key), `unknown(referred(joint_controllers_or_processors_involved))` (OPEN BY REFERRAL); Checklist is `[]` when the input check gives problems, when `consultation_under_article_36_1` is absent or false — each row cites its own point (`eu_reg_2016_679_art_36_3_a` … `_f`).
- `gdpr_art36_3_consultation_request_what_if(Profile, Key, Value, Result)`: Result = the status Result after setting Key to Value (via `what_if/5` with closure `gdpr_art36_3_consultation_request_status`); the override is re-checked by the input check, so an out-of-type Value gives `input_problems(...)` — cites as the status query.
- `gdpr_art36_3_consultation_request_fixture(Name, Profile)`: named sample profiles (section 9).
- `gdpr_art36_3_consultation_request_fixture_expected(Name, Result, Items)`: the expected status Result and items answer per fixture.

Note on prefix: the three contract query names are fixed by the called contract and are kept exactly; every non-contract predicate carries the prefix `gdpr_art36_3_consultation_request_`.

## 6. Planned reuse (manifest `uses:`)

- `formalize_lib`: `profile_get/3` (only reader of PROFILE; presence first, then value), `profile_has/2`, `profile_lacks/2` (absent routes, disjoint from present routes), `profile_set/3` (what-if override), `eval_requirements/4` (checklist; no hand-rolled findall row-builder, lint R1), vocabulary `attribute/2`, `item/3`, `unmet/1`, `unknown/1`, `memberd/2`, `not_member/2` (input-check key bookkeeping).
- `kit.query_combinators`: `what_if/5` for the facade what-if.
- `validate_props`: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`, `declare_vacuous/1` (declare `prop_boundary_coverage` and `prop_monotone` vacuous: no numeric axis).
- NOT used, with reason: `kit.compliance_lib` (its modality lattice and `verdict/5` shape do not match the fixed contract outputs; the deontic content is a single `shall provide` duty read as a checklist), `check_tri/4` (no tri-valued key; outside fact is an attested wrapper), `assess/6`/`decide_labeled/3` (the status order of THE LIMBS — MISSING first, DECIDING before non-deciding, referral last — is not the kit's label order), all date, deadline, ratio, money, rolling-window modules (no date, no figure), `currency_vocab`, `vat_category`, `country`.
- Family backbone (`_common`): none needed beyond `formalize_lib`; the attested-outside-fact shape check is written locally in the slice (single outside fact).

## 7. File-by-file plan

- `kernel.clausal` — shared floor only. No domain predicate is shared between slices (there is one slice), so kernel keeps its scaffold floor: module header, `formalize_lib` import, the exported result constructors. Nothing from the slice moves here.
- `citations.clausal` — the seven citation facts plus the referral target fact, each with unit id and verbatim pinned text.
- `parameters.clausal` — NO statutory figure exists in Art 36(3): no threshold, period or table. The file keeps its module and holds a comment stating so; no `constant_value/2` is declared (none is inlined either).
- `gdpr_art36_3_consultation_request.clausal` — the slice (section 8).
- `queries.clausal` — the three contract queries, wired to the slice; step 0 input check first.
- `fixtures.clausal` — section 9.
- package facade — section 5 facade predicates.

## 8. Determination slice: `gdpr_art36_3_consultation_request.clausal`

### 8.1 Statutory VALUE facts owned (live in this file)

No numeric value. The slice owns these table facts:

- `gdpr_art36_3_consultation_request_contract_key(Position, Key, Type)` — the ten keys in contract order, Type `boolean` or `outside_fact`.
- `gdpr_art36_3_consultation_request_item(Position, ItemAtom, PointCitation)` — the six items: `1 respective_responsibilities eu_reg_2016_679_art_36_3_a`, `2 purposes_and_means _b`, `3 measures_and_safeguards _c`, `4 data_protection_officer_contact_details _d`, `5 data_protection_impact_assessment _e`, `6 other_requested_information _f`.
- `gdpr_art36_3_consultation_request_content_key(ItemAtom, ContentKey)` and `gdpr_art36_3_consultation_request_applicability_key(ItemAtom, ApplicabilityKey)` — (a) applicability = outside fact; (d) `data_protection_officer_designated`; (f) `other_information_requested_by_supervisory_authority`; (b), (c), (e) unconditional.
- The SEVEN and PARAGRAPH citation lists as facts.

### 8.2 Rules / requirements

R0 INPUT CHECK `gdpr_art36_3_consultation_request_input_problems/2`:
- Not an attribute list (unbound, partial list, unbound element, any element not `attribute(_, _)`, non-list) → `[wrong_type(profile)]` alone.
- Otherwise, for each contract key in contract order: `duplicate_key(KEY)` if it occurs more than once (values not read), else `wrong_type(KEY)` if its single value is out of type (crisp: not exactly `true`/`false`, unbound included, attested included; outside fact: not `attested(true|false, attestation(_, _, _, _))`, bare `true`/`false`/`unsure` included); then `unknown_key(KEY)` for each non-contract key (non-atom keys included, as given) in first-occurrence order, once each.
- Never fails, never raises, one solution. Absent keys are never problems; no cross-key check.

R1 ITEM STATE `item_state(ItemAtom, Profile, State)` — one solution per item, disjoint clauses (Rc = respective_responsibilities_provided, J = joint outside fact value):
- (a): Rc true → satisfied; J attested false (Rc not true) → satisfied; J attested true, Rc false → missing; Rc absent, J attested true → `open_named(respective_responsibilities_provided, deciding)`; Rc absent, J absent → `open_named(respective_responsibilities_provided, not_deciding)`; Rc false, J absent → `open_by_referral`.
- (b)/(c)/(e): content key true → satisfied; false → missing; absent → `open_named(ContentKey, deciding)`.
- (d) (D = designated, K = contact details provided): K true → satisfied; D false (K not true) → satisfied; D true, K false → missing; D true, K absent → `open_named(data_protection_officer_contact_details_provided, deciding)`; D absent, K false → `open_named(data_protection_officer_designated, deciding)`; D absent, K absent → `open_named(data_protection_officer_designated, not_deciding)`.
- (f) identical shape with `other_information_requested_by_supervisory_authority` / `requested_other_information_provided`.

R2 BASIS JB `joint_basis(Profile, Basis)`: `[outside_fact(joint_controllers_or_processors_involved, Attested)]` (Attested exactly as supplied) when J present and Rc false or absent; `[]` when J absent, or when Rc true.

R3 STATUS (steps after input check, first that answers decides):
1. consultation key absent → `indeterminate([consultation_under_article_36_1])`, [], [].
2. false → `not_governed_by_article_36_3`, [], PARAGRAPH.
3. any item missing → `consultation_request_incomplete`, JB, SEVEN.
4. first item (a)–(f) in `open_named(Key, deciding)` → `indeterminate([Key])`, [], [].
5. first item (a)–(f) in `open_named(Key, not_deciding)` → `indeterminate([Key])`, [], [].
6. item (a) `open_by_referral` → THE ABSENT REFERRAL, [], [].
7. all satisfied → `consultation_request_complete`, JB, SEVEN.

R4 ITEMS (after input check):
1./2. as status.
3. first item (a)–(f) in `open_named(Key, _)` → `indeterminate([Key])`, [], [] (a missing item does not end this query).
4. item (a) `open_by_referral` → THE ABSENT REFERRAL, [], [].
5. all satisfied or missing → list of missing item atoms in order (a)–(f) (`[]` if none), JB, SEVEN.

Determinism plan: the item states are computed once into a six-element list in order; `first_open_named/3` walks that list with disjoint head patterns; `no_missing/1`, `has_missing/1` are disjoint; step guards are mutually exclusive by construction (each later step's clause carries the negation of earlier conditions as positive pattern facts over the state list, not as `\+` of a nondeterministic goal).

R5 CHECKLIST `requirement(ItemAtom, Profile, Status, cite(PointKey))` for `eval_requirements/4`: maps R1 states to `met` / `unmet(not_provided(ContentKey))` / `unknown([Key])` / `unknown(referred(joint_controllers_or_processors_involved))`.

Keys a query does not read never change its answer (e.g. a present J with Rc true; D or K beyond a satisfied content key; anything after consultation key false).

### 8.3 Verdict atoms of the slice

`consultation_request_complete`, `consultation_request_incomplete`, `not_governed_by_article_36_3`; the six item atoms; open statuses of section 2.

### 8.4 Predicates SHARED with another slice

None. There is one slice; nothing goes into `kernel.clausal` beyond its scaffold floor.

### 8.5 Per-rule tests (seven test modes)

One positive and one paired negative test per R1 clause; R0 one test per problem kind (incl. unbound profile, partial list, unbound element, non-attribute element, non-atom key, unbound value, attested crisp, bare outside fact, duplicate with equal values not also wrong_type, unknown key repeated once); R3/R4 one test per step; `length(Solutions, 1)` count test for every query on every fixture; irrelevant-key invariance tests; property runs via `validate_props` (totality, determinism, citation completeness, missing-key coverage).

## 9. Fixtures (Name — profile essentials — expected status | expected items)

All with `consultation_under_article_36_1` true unless stated; `ATT(V)` = `attested(V, attestation(host_user, host_time, stated_by_caller, none))`.

1. `controller_alone_complete` — J ATT(false), means true, measures true, designated false, impact true, requested false — `consultation_request_complete`, Basis [outside_fact(J, ATT(false))] | `[]`, same Basis.
2. `impact_assessment_not_provided` — Rc true, means true, measures true, designated false, impact false, requested false — `consultation_request_incomplete`, Basis [] | `[data_protection_impact_assessment]`.
3. `consultation_under_member_state_law` — consultation false — `not_governed_by_article_36_3`, PARAGRAPH | same.
4. `consultation_footing_not_stated` — consultation absent — `indeterminate([consultation_under_article_36_1])` | same.
5. `roles_not_attested_responsibilities_not_given` — Rc false, J absent, others satisfied — THE ABSENT REFERRAL | THE ABSENT REFERRAL.
6. `missing_item_and_officer_unknown` — Rc true, means false, measures true, impact true, designated absent, contact absent, requested false — `consultation_request_incomplete`, [] | `indeterminate([data_protection_officer_designated])`.
7. `deciding_key_before_responsibilities` — Rc absent, J absent, means true, measures absent, others satisfied — `indeterminate([measures_and_safeguards_provided])` | `indeterminate([respective_responsibilities_provided])`.
8. `processor_involved_responsibilities_missing` — J ATT(true), Rc false, others satisfied — `consultation_request_incomplete`, Basis [outside_fact(J, ATT(true))] | `[respective_responsibilities]`, same Basis.
9. `officer_designated_contact_missing` — Rc true, designated true, contact false, others satisfied — incomplete | `[data_protection_officer_contact_details]`.
10. `contact_given_designation_unstated` — Rc true, contact true, designated absent, others satisfied — complete, [] | `[]`.
11. `authority_request_answer_unstated` — Rc true, requested true, provided absent, others satisfied — `indeterminate([requested_other_information_provided])` | same.
12. `attested_value_on_crisp_key` — means given as ATT(true) — `input_problems([wrong_type(purposes_and_means_provided)])` | same.
13. `bare_roles_value` — J given bare `true` — `input_problems([wrong_type(joint_controllers_or_processors_involved)])` | same.
14. `duplicate_and_unknown_keys` — impact twice, plus `attribute(controller_name, acme)` — `input_problems([duplicate_key(impact_assessment_provided), unknown_key(controller_name)])` | same.
