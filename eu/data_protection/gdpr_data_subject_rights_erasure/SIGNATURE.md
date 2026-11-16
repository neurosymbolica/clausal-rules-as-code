# SIGNATURE — eu/data_protection/gdpr_data_subject_rights_erasure

## Public query surface

The kept query is `decide_data_subject_request(PROFILE, gdpr_data_subject_request_verdict(COMPLY, BASIS, EXCEPTION, CONDITIONS, CITATIONS))`. The input check is `gdpr_data_subject_rights_erasure_input_problems(PROFILE, PROBLEMS)`.

The scaffold facade keeps its names and serves the two slices, plus what-if, compliance-check (#13) and fixtures. The checklists carry `cite(...)` per item (#7 justification).

PROFILE is an attribute list `[attribute(KEY, VALUE), ...]`. It is read only with `profile_get/3`, `profile_has/2` and `profile_lacks/2` (formalize_lib), always with atom keys, never with string literals.

TOTALITY and DETERMINISM: every public predicate yields EXACTLY ONE solution for every profile, a ground one, never repeated. This holds for an ill-formed profile too.

There are no imported or declared statutory figures. Every period of the kept scope is deferred (Art 12(3)).

The placeholder `decide_gdpr_data_subject_rights_erasure/2` and `gdpr_data_subject_rights_erasure_status/2` with `{required, permitted, not_applicable}` are REPLACED by the surface below. The package facade exports only the predicates of this file.

## Verdict STATUS atoms (replacing the scaffold placeholders)

### COMPLY of the kept query

COMPLY is exactly one of:

- `must_comply`
- `need_not_comply`
- `indeterminate(MISSING_KEYS)`. MISSING_KEYS is a non-empty list of bare key atoms. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(REASON, CONTEXT)`, with REASON one of:
  - `open_textured(INPUT, cite(KEY))`
  - `cross_reference_unresolved(cite(CITATION), cite(TARGET))`
  - `outside_this_order(request_type)` (internal, untested)
- `suspended(art12_6_identity_not_confirmed)`
- `input_problems(PROBLEMS)`, with PROBLEMS a list of `duplicate_key(KEY)`, `wrong_type(KEY)` and `unknown_key(KEY)` terms (`wrong_type(profile)` for a non-list).

### The other verdict fields

- **BASIS**: `art17_1_a | art17_1_b | art17_1_c | art17_1_d | art17_1_e | art17_1_f | none`.
- **EXCEPTION**: `art17_3_a | art17_3_b | art17_3_c | art17_3_d | art17_3_e | art12_5_manifestly_unfounded_or_excessive | art12_2_unable_to_identify | art23_legislative_restriction | none`.
- **CONDITIONS**: `[reasonable_fee_may_be_charged]` or `[]`.

### Slice status atoms

There is no bare atom beside a same-name compound.

- **request_basis**:
  - `engaged`
  - `not_engaged`
  - `open_by_absence(KEYS)`
  - `open_by_outside_fact(KEYS)`
  - `open_by_judgement(KEYS)`
  - `outside_this_order(request_type)`
  - `indeterminate(KEYS)` (request_type absent)
  - `input_problems(PROBLEMS)`
- **request_exception**:
  - `relieved(EXCEPTION)`
  - `suspended(art12_6_identity_not_confirmed)`
  - `not_relieved`
  - `open_by_absence(KEYS)`
  - `open_by_judgement(KEYS)`
  - `outside_this_order(request_type)`
  - `indeterminate(KEYS)`
  - `input_problems(PROBLEMS)`

### Compliance-check (#13) verdict atoms

`permitted | forbidden | not_yet_determined`.

## Profile keys (fifty-four, root_exports order; the manifest order governs if it differs)

- **Atom keys (2)**:
  - `request_type`: one of access, rectification, erasure, restriction, portability, objection, automated_decision. REQUIRED; it is read by step (i).
  - `objection_ground_claimed`: one of art21_1, art21_2, art21_6. Type-checked only.
- **Date key (1)**: `request_received_on`, a `date(Year, Month, Day)` term that is a real calendar day. Type-checked only (Art 12(3) is deferred).
- **Crisp keys (25)**, each the atom true or false. In order:
  - extension_claimed
  - controller_demonstrates_unable_to_identify_data_subject
  - identity_confirmed
  - personal_data_inaccurate
  - consent_is_the_basis_of_processing
  - consent_withdrawn
  - other_legal_ground_for_processing_exists
  - objection_under_art21_1_made
  - objection_under_art21_2_made
  - collected_in_relation_to_information_society_services_offer
  - accuracy_contested_by_data_subject
  - data_subject_opposes_erasure
  - data_required_by_data_subject_for_legal_claims
  - verification_of_overriding_grounds_pending
  - personal_data_provided_by_data_subject
  - processing_based_on_consent_or_contract
  - processing_carried_out_by_automated_means
  - processing_based_on_art6_1_e_or_f
  - processing_for_direct_marketing
  - processing_for_research_or_statistics_pursuant_to_art89_1
  - data_subject_gave_explicit_consent
  - decision_based_on_special_categories
  - special_category_condition_and_safeguards_met_for_decision
  - personal_data_disclosed_to_recipients
  - data_subject_asks_who_the_recipients_are
- **Judgement keys (21)**, each true, false or unsure. In order:
  - extension_necessary_for_complexity_and_number
  - reasonable_doubts_about_identity
  - request_manifestly_unfounded_or_excessive
  - personal_data_incomplete_in_light_of_purposes
  - data_no_longer_necessary_for_purposes
  - overriding_legitimate_grounds_exist
  - personal_data_unlawfully_processed
  - processing_necessary_for_freedom_of_expression_and_information
  - processing_necessary_for_public_task_or_official_authority
  - processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i
  - processing_for_archiving_research_or_statistics_in_accordance_with_art89_1
  - erasure_would_render_impossible_or_seriously_impair_processing_objectives
  - processing_necessary_for_legal_claims
  - controller_no_longer_needs_data_for_processing_purposes
  - transmission_would_adversely_affect_rights_and_freedoms_of_others
  - objection_grounds_relate_to_particular_situation
  - controller_demonstrates_compelling_legitimate_grounds
  - decision_based_solely_on_automated_processing
  - decision_produces_legal_or_similarly_significant_effects
  - decision_necessary_for_contract_with_data_subject
  - recipient_notification_impossible_or_disproportionate_effort
- **Outside facts (5)**:
  - Declared in `outside_facts:`, in order:
    - `erasure_required_by_union_or_member_state_law` (ENABLING)
    - `processing_required_by_union_or_member_state_law` (BLOCKING)
    - `legislative_restriction_applies_to_the_right` (BLOCKING)
  - Contract only, unread:
    - `decision_authorised_by_union_or_member_state_law`
    - `public_holidays`
  - Each value is `attested(VALUE, attestation(BY, AT, REASON, EVIDENCE))`. VALUE is true or false; for public_holidays it is a list of real `date(Year, Month, Day)` terms.
  - BY, AT, REASON and EVIDENCE are never read.

No key is numeric, so no unit suffix applies. The key names are contract-fixed and are not renamed.

## Citation-key atoms (from citation_vocabulary; this order of the vocabulary is assumed, the manifest governs)

- `art_12_2`: GDPR Art 12(2), second sentence.
- `art_12_5`: GDPR Art 12(5).
- `art_17_1`: GDPR Art 17(1), chapeau.
- `art_17_1_a`, `art_17_1_b`, `art_17_1_c`, `art_17_1_d`, `art_17_1_e`, `art_17_1_f`: GDPR Art 17(1)(a)-(f).
- `art_17_3`: GDPR Art 17(3), chapeau.
- `art_17_3_a`, `art_17_3_b`, `art_17_3_c`, `art_17_3_d`, `art_17_3_e`: GDPR Art 17(3)(a)-(e).
- `art_23_1`: GDPR Art 23(1), opening words.

Other citation sources:

- **Referral cites** come from the manifest tables, verbatim, and are never derived from a key name:
  - `open_textured(INPUT, cite(KEY))`: KEY is the `referrals:` row of INPUT for erasure (the suspension uses the row `identity_doubts_reasonable`);
  - `cross_reference_unresolved`: CITATION and TARGET come from the `outside_facts:` row of erasure_required_by_union_or_member_state_law.
- **No shortened or new citation atom is invented.**

### CITATIONS of a final verdict

CITATIONS are listed in vocabulary order, without duplicates:

- `cite(art_17_1)`;
- plus `cite(art_17_1_X)` when BASIS is a point;
- plus the exception's cites:
  - for `art17_3_X`: art_17_3 and art_17_3_X;
  - for art12_5: art_12_5;
  - for art12_2: art_12_2;
  - for art23: art_23_1.

Non-final verdicts have CITATIONS [].

## Public predicates

Each public predicate gives one solution:

- `decide_data_subject_request(Profile, Verdict)`: the whole verdict by THE DECISION, steps (0) to (v). Cites GDPR Art 17(1), 17(3), 12(2), 12(5), 12(6) and 23(1).
- `gdpr_data_subject_rights_erasure_input_problems(Profile, Problems)`: the INPUT CHECK of the contract (G1). Problems is [] when the profile is well-formed. Input contract, no provision.
- `decide_request_basis(Profile, request_basis_verdict(Status, Basis, Citations))`: the engagement E of the right to erasure, with BASIS the first met point. Cites GDPR Art 17(1)(a)-(f).
- `request_basis_status(Profile, Status)`: the Status of `decide_request_basis/2` alone. Cites GDPR Art 17(1).
- `request_basis_checklist(Profile, Checklist)`: one `item(PointId, Status, cite(art_17_1_X))` per Art 17(1) point, in order a-f. Status is met, `unmet(Reason)` or `unknown(Keys)`. Cites GDPR Art 17(1)(a)-(f).
- `decide_request_exception(Profile, request_exception_verdict(Status, Exception, Conditions, Citations))`: the first met exception, else the Art 12(6) suspension, else open or not_relieved. Cites GDPR Art 17(3)(a)-(e), 12(5), 12(2), 23(1) and 12(6).
- `request_exception_status(Profile, Status)`: the Status of `decide_request_exception/2` alone. Cites GDPR Art 17(3), 12(2), 12(5), 12(6) and 23(1).
- `request_exception_checklist(Profile, Checklist)`: one item per exception in test order, then the suspension item. Each item carries its own cite; the suspension item cites the referral row `identity_doubts_reasonable`. Cites GDPR Art 17(3), 12(5), 12(2), 23(1) and 12(6).
- `gdpr_data_subject_rights_erasure_what_if(Profile, Key, Value, Verdict)`: the verdict after `profile_set(Profile, attribute(Key, Value), Edited)`. It replaces the key's entry (or adds it) before `decide_data_subject_request/2`. Cites the provisions of the decision.
- `gdpr_data_subject_rights_erasure_compliance_check(Profile, Action, Verdict)`: query type #13. Action is one of `refuse_erasure`, `charge_reasonable_fee`, `defer_pending_identity`. Verdict is permitted, forbidden or not_yet_determined. Cites GDPR Art 17(1), 17(3), 12(5)(a)-(b), 12(2), 12(6) and 23(1).
  - `refuse_erasure`:
    - permitted iff need_not_comply;
    - forbidden iff must_comply.
  - `charge_reasonable_fee`:
    - permitted iff CONDITIONS has `reasonable_fee_may_be_charged`;
    - forbidden on any other final verdict (Art 12(5): free of charge).
  - `defer_pending_identity`:
    - permitted iff suspended;
    - forbidden on a final verdict.
  - Every other COMPLY (indeterminate, needs_legal_review, input_problems) gives not_yet_determined.
  - An Action outside the three is not_yet_determined. The action is not a profile key, so this is no input problem.
- `gdpr_data_subject_rights_erasure_fixture(Name, Profile, ExpectedVerdict)`: the fixtures (fixtures.clausal), one solution per Name.

### Result constructors (exported, never queried)

`gdpr_data_subject_request_verdict/5`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `resolution/2`, `inputs_relied_on/1`, `provenance/2`, `suspended/1`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `attested/2`, `attestation/4`, `url/2`, `document/2`.

### Not exported

`response_deadline/3`, `request_response_deadline/2`, `request_outside_facts/2`.

## File layout (unchanged names; kernel -> citations -> parameters -> request_basis -> request_exception -> queries -> fixtures -> facade)

- **citations.clausal**: `gdpr_data_subject_rights_erasure_citation(Key, Instrument, Unit)`, one row per citation atom above, in vocabulary order. Also `gdpr_data_subject_rights_erasure_citation_rank(Key, Rank)`, used to sort CITATIONS.
- **parameters.clausal**: the INPUT CONTRACT table only. It holds `gdpr_data_subject_rights_erasure_contract_key(Rank, Key, Type)` for the 54 keys in root_exports order.
  - Type is one of: `enumeration(Atoms)`, `calendar_date`, `crisp`, `judgement`, `outside_fact`, `holiday_list`.
  - It is the contract, not a statutory figure, and is read by the kernel's input check and key ordering.
  - No `constant_value` is declared.
- **kernel.clausal**: the shared predicates listed in the next section.
- **request_basis.clausal** and **request_exception.clausal**: the slices, described below.
- **queries.clausal**: `decide_data_subject_request/2`, the compliance check and what_if, combining the two slice statuses by THE DECISION.
- **fixtures.clausal**: the fixtures.
- **package facade**: re-exports the public predicates and the result constructors.

## kernel.clausal — predicates SHARED by both slices (and only those)

### Input check

`gdpr_data_subject_rights_erasure_input_problems(Profile, Problems)`. Both slices' decide predicates and the query answer input problems FIRST.

It is built on `profile_keys/2` and the parameters table. It reports, per contract key in rank order, `duplicate_key` (values not read) else `wrong_type`. Then it reports `unknown_key` in first-occurrence order.

The date check uses `month_last_day/3`. A non-list profile, or a non-`attribute/2` element, gives `[wrong_type(profile)]`.

### Request type

`gdpr_data_subject_rights_erasure_request_type_route(Profile, Route)`. Route is one of:

- `absent`
- `in_order` (erasure)
- `outside_this_order(Type)`

Three disjoint clauses.

### Limb readers (strong Kleene)

Each reader returns `met`, `unmet` or `open(AbsentKeys, UnsureKeys, OutsideFacts)`.

- `gdpr_data_subject_rights_erasure_required_limb(Profile, Key, Limb)`. For a crisp or judgement key:
  - true is met;
  - false is unmet;
  - unsure is `open([], [Key], [])`;
  - absent is `open([Key], [], [])`.
- `gdpr_data_subject_rights_erasure_defeater_limb(Profile, Key, Limb)`:
  - true is met;
  - false or absent is unmet;
  - unsure is `open([], [Key], [])`.
- `gdpr_data_subject_rights_erasure_outside_fact_limb(Profile, Key, Direction, Limb)`, with Direction `enabling` or `blocking`:
  - `attested(true, _)` is met;
  - `attested(false, _)` is unmet;
  - absent with enabling is `open([], [], [Key])`;
  - absent with blocking is unmet.
- `gdpr_data_subject_rights_erasure_negated_limb(Limb, Negated)`.
- `gdpr_data_subject_rights_erasure_conjunction(Limbs, Limb)` and `gdpr_data_subject_rights_erasure_disjunction(Limbs, Limb)`. These are cut-free, with one clause per dominance case, and union the lists of open children only.

### Ordering and evidence helpers

- `gdpr_data_subject_rights_erasure_keys_in_contract_order(Keys, Ordered)`: rank-sorted, without duplicates. Used for MISSING_KEYS, INPUT and PAIRS.
- `gdpr_data_subject_rights_erasure_present_pairs(Profile, Keys, Pairs)`: `Key-Value` for each present key, in contract order.
- `gdpr_data_subject_rights_erasure_citations_in_order(Keys, Citations)`: `cite(Key)` sorted by citation_rank.

### First met in order

`gdpr_data_subject_rights_erasure_first_met(Rows, Id)`, where Rows is a ground ordered list of `Id-Limb`. It is guarded by `once/1` over `member(Id-met, Rows)`: a cut-free defeater search. A second clause gives `none` when no row is met, via `not_member/2`.

## Slice: request_basis.clausal (Art 17(1) — the ENGAGEMENT)

### Value facts owned here

- `request_basis_scope(erasure)`: the request_type this order decides.
- `request_basis_point(Rank, PointId, BasisAtom, Citation)`, in the order a-f:
  - `1, point_a, art17_1_a, art_17_1_a`
  - `2, point_b, art17_1_b, art_17_1_b`
  - `3, point_c, art17_1_c, art_17_1_c`
  - `4, point_d, art17_1_d, art_17_1_d`
  - `5, point_e, art17_1_e, art_17_1_e`
  - `6, point_f, art17_1_f, art_17_1_f`
- `request_basis_article_citation(art_17_1)`.
- `request_basis_judgement_key(Key)`, the judgements read by E (for PAIRS):
  - data_no_longer_necessary_for_purposes
  - overriding_legitimate_grounds_exist
  - personal_data_unlawfully_processed
- `request_basis_enabling_fact(erasure_required_by_union_or_member_state_law)`.

### Rules (limb per point; every key REQUIRED except the outside fact)

- **A** = required(data_no_longer_necessary_for_purposes).
- **B** = AND of:
  - required(consent_is_the_basis_of_processing)
  - required(consent_withdrawn)
  - NOT required(other_legal_ground_for_processing_exists)
- **C** = OR of:
  - AND(required(objection_under_art21_1_made), NOT required(overriding_legitimate_grounds_exist))
  - required(objection_under_art21_2_made)
- **D** = required(personal_data_unlawfully_processed).
- **E** = outside_fact(erasure_required_by_union_or_member_state_law, enabling).
- **F** = required(collected_in_relation_to_information_society_services_offer).
- **Engagement** = disjunction([A, B, C, D, E, F]). BASIS is `first_met([art17_1_a-A, ..., art17_1_f-F])`.

### Verdict mapping (disjoint clause routes, constants in heads)

- Input problems give `input_problems(P)`, BASIS none, [].
- request_type absent gives `indeterminate([request_type])`.
- A non-erasure type gives `outside_this_order(request_type)`.
- met gives `engaged` with BASIS and `[cite(art_17_1), cite(art_17_1_X)]`.
- unmet gives `not_engaged`, none, `[cite(art_17_1)]`.
- When open, the first non-empty list wins:
  - AbsentKeys gives `open_by_absence(AbsentKeys in contract order)`;
  - else OutsideFacts gives `open_by_outside_fact(OutsideFacts)`;
  - else `open_by_judgement(UnsureKeys)`.

  BASIS is none and CITATIONS are [].

### Exports used by queries.clausal

- `request_basis_limb(Profile, Limb)`: the raw Kleene result.
- `request_basis_point_basis(Profile, Basis)`.
- `request_basis_relied_on_keys(Keys)`.

### Checklist

The checklist uses `eval_requirements/4` with the closure `request_basis_requirement`. The requirement predicate is `request_basis_requirement(PointId, Profile, Status, Citation)`, with RequirementId first. It has three disjoint clauses per point:

- met;
- `unmet(no_disjunct_met)` or `unmet(some_conjunct_unmet)`;
- `unknown(Keys)`.

The status itself comes from the Kleene disjunction, not from the AND of `assess/6`, because E is an OR.

### Per-rule tests

Each point is tested met, unmet and open, with a positive test paired to every negative one. The tests cover:

- B with consent withdrawn but another legal ground;
- C via Art 21(2) alone;
- C with Art 21(1) and overriding unsure (open by judgement);
- E attested true, attested false and absent;
- BASIS order, for example A and F both met giving art17_1_a.

## Slice: request_exception.clausal (Art 17(3), 12(5), 12(2), 23(1); Art 12(6) suspension)

### Value facts owned here

- `request_exception_order(Rank, ExceptionAtom, Citations)`, in test order:
  - `1, art17_3_a, [art_17_3, art_17_3_a]`
  - `2, art17_3_b, [art_17_3, art_17_3_b]`
  - `3, art17_3_c, [art_17_3, art_17_3_c]`
  - `4, art17_3_d, [art_17_3, art_17_3_d]`
  - `5, art17_3_e, [art_17_3, art_17_3_e]`
  - `6, art12_5_manifestly_unfounded_or_excessive, [art_12_5]`
  - `7, art12_2_unable_to_identify, [art_12_2]`
  - `8, art23_legislative_restriction, [art_23_1]`
- `request_exception_conditions(art12_5_manifestly_unfounded_or_excessive, [reasonable_fee_may_be_charged])`. Every other exception has [].
- `request_exception_blocking_fact(Key)`:
  - processing_required_by_union_or_member_state_law
  - legislative_restriction_applies_to_the_right
- `request_exception_judgement_key(ExceptionAtom, Key)`, the judgements each Xi reads (for PAIRS):
  - a: processing_necessary_for_freedom_of_expression_and_information
  - b: processing_necessary_for_public_task_or_official_authority
  - c: processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i
  - d: processing_for_archiving_research_or_statistics_in_accordance_with_art89_1 and erasure_would_render_impossible_or_seriously_impair_processing_objectives
  - e: processing_necessary_for_legal_claims
  - art12_5: request_manifestly_unfounded_or_excessive
- `request_exception_suspension_status(suspended(art12_6_identity_not_confirmed))`.
- `request_exception_suspension_referral_row(identity_doubts_reasonable)`.
- `request_exception_suspension_judgement_key(reasonable_doubts_about_identity)`.

### Rules (all exception keys are DEFEATERS)

- **art17_3_a** = defeater(processing_necessary_for_freedom_of_expression_and_information).
- **art17_3_b** = OR of:
  - outside_fact(processing_required_by_union_or_member_state_law, blocking)
  - defeater(processing_necessary_for_public_task_or_official_authority)
- **art17_3_c** = defeater(processing_necessary_for_public_health_in_accordance_with_art9_2_h_and_i).
- **art17_3_d** = AND of:
  - defeater(processing_for_archiving_research_or_statistics_in_accordance_with_art89_1)
  - defeater(erasure_would_render_impossible_or_seriously_impair_processing_objectives)
- **art17_3_e** = defeater(processing_necessary_for_legal_claims).
- **art12_5_manifestly_unfounded_or_excessive** = defeater(request_manifestly_unfounded_or_excessive).
- **art12_2_unable_to_identify** = defeater(controller_demonstrates_unable_to_identify_data_subject).
- **art23_legislative_restriction** = outside_fact(legislative_restriction_applies_to_the_right, blocking).
- **SUSP** = AND of:
  - defeater(reasonable_doubts_about_identity)
  - NOT required(identity_confirmed)

### Verdict mapping (disjoint routes)

- Input problems, request_type absent and a non-erasure type are handled as in request_basis.
- If some Xi is met, the result is `relieved(Xfirst)`, where Xfirst is `first_met` over the order with `once/1`. CONDITIONS come from the conditions fact and CITATIONS are Xfirst's cites.
- Else, if SUSP is met, the result is `suspended(art12_6_identity_not_confirmed)`, none, [], [].
- Else, if some Xi or SUSP is open:
  - with AbsentKeys (only identity_confirmed can be absent here), `open_by_absence(Keys)`;
  - else `open_by_judgement(UnsureKeys)`.
- Else `not_relieved`, none, [], [].

### Exports used by queries.clausal

- `request_exception_rows(Profile, Rows)`: the ordered `Id-Limb` rows.
- `request_exception_suspension_limb(Profile, Limb)`.
- `request_exception_relied_on_keys(Profile, Keys)`: the judgement keys of the OPEN Xi and of SUSP if it is open.

### Checklist

The checklist uses `eval_requirements/4` with the closure `request_exception_requirement(ExceptionId, Profile, Status, Citation)`. It has one item per exception plus `identity_suspension`, three disjoint clauses each, and a cite on every item.

### Per-rule tests

The tests cover:

- each exception met, unmet and absent (absent is unmet, as a defeater);
- each exception unsure (open);
- 17(3)(b) via the attested fact alone, and via the judgement alone;
- 17(3)(d) with only one of its two judgements;
- the order: (a) unsure and (e) true gives relieved(art17_3_e);
- the art12_5 conditions;
- art23 attested true, attested false and absent;
- SUSP with identity_confirmed false, true and absent;
- a met exception beating SUSP.

## queries.clausal — THE DECISION (combining the slices)

The routes are disjoint clause heads that fold the constants:

- **(0)** PROBLEMS is non-empty: `input_problems(PROBLEMS)`, none, none, [], [].
- **(i)** request_type is absent: `indeterminate([request_type])`.
- **** a non-erasure type: `needs_legal_review(outside_this_order(request_type), [inputs_relied_on([request_type-Type])])`.
- **(ii)** E is unmet: `need_not_comply`, none, none, [], `[cite(art_17_1)]`.
- **(iii)** some Xi is met: `need_not_comply`, with:
  - BASIS: the E point basis if E is met, else none;
  - EXCEPTION: Xfirst;
  - CONDITIONS: Xfirst's conditions;
  - CITATIONS: art_17_1, plus the point if there is a basis, plus Xfirst's cites.
- **(iii-a)** SUSP is met: `suspended(art12_6_identity_not_confirmed)`.
- **(iv)** something is open, among E, SUSP and the open Xi:
  - the union of AbsentKeys is non-empty: `indeterminate(MISSING_KEYS)`, in contract order;
  - else, E carries the enabling fact: `needs_legal_review(cross_reference_unresolved(cite(CITATION), cite(TARGET)), [resolution(cite(TARGET), not_attempted), inputs_relied_on(PAIRS)])`;
  - else `needs_legal_review(open_textured(INPUT, cite(ROW_KEY)), [inputs_relied_on(PAIRS)])`. INPUT is the first carried unsure key and ROW_KEY comes from `referrals:`.
  - PAIRS follow request_type, then the present judgement keys of every OPEN top-level limb, then `erasure_required_by_union_or_member_state_law-absent` when E is open and that fact is absent.
- **(v)** otherwise: `must_comply`, BASIS, none, [], `[cite(art_17_1), cite(art_17_1_X)]`.

## Planned reuse (manifest `uses:`)

### formalize_lib

Imported:

- `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_keys/2`, `profile_set/3`
- `eval_requirements/4`, `item/3`, `unknown/1`, `unmet/1`, `attribute/2`
- `not_member/2`, `memberd/2`, `missing_keys/3`

Vocabulary atoms: `met`, `no_disjunct_met`, `some_conjunct_unmet`.

Considered and NOT used:

- `check_tri/4`, `check_tri_neg/4`, `and_status/2`, `or_status/2`. They fold ABSENT and `unsure` into one `unknown(Keys)`, while THE DECISION must separate OPEN BY ABSENCE, OPEN BY JUDGEMENT and OPEN BY OUTSIDE FACT. The local readers carry a `% lint: C15` pragma that gives this reason.
- `assess/6`. Its AND aggregation does not fit the OR engagement or the first-met exceptions.

### kit/deadline_lib

`month_last_day/3`, used only for the real-calendar-day input check of `request_received_on` and `public_holidays`.

### Considered and not imported

- **kit/compliance_lib**. Its CWA-parameterised modality lattice would close an absent key to a default. This order is fail-closed: absent means OPEN BY ABSENCE. So #13 is derived from the verdict locally.
- **kit/query_combinators `what_if/5`**. It works on dict worlds, and `profile_set/3` is the attribute-list equivalent.
- **library(datetime)**. No date arithmetic is in kept scope.

### validate_props (tests only)

`run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, and `bad_citation/1` over the fixture generator.

### Family backbone (`_common`)

None required. Deontic defeat is the guarded `once/1` first-met search in kernel.clausal, cut-free, with no `->`.

## Totality and determinism claims

- Every route of every public predicate is a disjoint clause, discriminated by the route, the Kleene value or the first non-empty list.
- The only `once/1` guards the first-met search over a ground list.
- Unread keys are type-checked and never consulted, so they cannot change an answer.
- Every fixture is tested for exactly one solution with `findall/3` plus `length(Verdicts, 1)`.

## Fixtures (`gdpr_data_subject_rights_erasure_fixture/3`)

| Fixture | Expected verdict |
|---|---|
| `must_comply_no_longer_necessary` | must_comply, art17_1_a, [art_17_1, art_17_1_a] |
| `must_comply_with_legislative_restriction_absent` | must_comply (A2) |
| `need_not_comply_no_ground` | every point unmet, the fact attested false |
| `need_not_comply_freedom_of_expression` | art17_3_a, with BASIS |
| `need_not_comply_public_task_with_basis_open` | BASIS none, [art_17_1, art_17_3, art_17_3_b] |
| `need_not_comply_manifestly_unfounded_with_fee` | conditions [reasonable_fee_may_be_charged] |
| `need_not_comply_unable_to_identify` | art12_2_unable_to_identify |
| `need_not_comply_legislative_restriction_attested` | art23_legislative_restriction |
| `suspended_identity_not_confirmed` | suspended(art12_6_identity_not_confirmed) |
| `indeterminate_identity_confirmed_absent` | indeterminate([identity_confirmed]) |
| `indeterminate_every_missing_key` | the the list-all missing-keys rule list-all case |
| `needs_legal_review_erasure_law_unattested` | needs_legal_review(cross_reference_unresolved(...), ...) |
| `needs_legal_review_unlawful_processing_unsure` | needs_legal_review(open_textured(...), ...) |
| `request_type_absent` | indeterminate([request_type]) |
| `input_problems_duplicate_and_unknown` | input_problems(...) |
| `input_problems_string_boolean` | wrong_type |
