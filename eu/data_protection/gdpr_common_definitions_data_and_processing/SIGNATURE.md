# SIGNATURE — eu/data_protection/gdpr_common_definitions_data_and_processing

## 1 Public query surface

The package exposes twelve definition relations, one input check and one outside-fact listing:

- `NAME(PROFILE, definition_answer(STATUS, GROUND, CITATIONS))` for each of the twelve Art 4 points.
- `gdpr_common_definitions_data_and_processing_input_problems(PROFILE, PROBLEMS)`.
- `data_and_processing_outside_facts(PROFILE, OUTSIDE_FACTS)`.

The scaffold facade wraps them all:

- `decide_gdpr_common_definitions_data_and_processing(PROFILE, gdpr_common_definitions_data_and_processing_verdict(CLASSIFICATION, CITATIONS))`
- `gdpr_common_definitions_data_and_processing_status(PROFILE, CLASSIFICATION)`

CLASSIFICATION is one of:

- `classification(ROWS)`, with ROWS the list of `definition(RELATION_NAME, DEFINITION_ANSWER)` in the relation order of section 6;
- `input_problems(PROBLEMS)`.

PROFILE is an attribute list of 26 keys (section 4), read only with `profile_get/3` after the input check.

Totality and determinism: every public predicate gives EXACTLY ONE solution for every term passed as PROFILE, including unbound, non-list and partial-list profiles. Each rule follows these constraints:

- It is cut-free, with no `!`, `->` or `*->`.
- Its ground outputs are folded into clause heads, one clause per disjoint route.
- `once/1` appears only in guarded form, around a goal whose key is already checked ground.

There are no statutory figures (classification family), so nothing is imported or re-declared from parameters.

## 2 Verdict STATUS atoms (replacing the placeholders satisfied / not_satisfied)

- `met`: the formula is MET.
- `not_met`: the formula is UNMET.
- `indeterminate(MISSING_KEYS)`: absent profile keys reached by the descent. The bare atom `indeterminate` is NEVER written.
- `needs_legal_review(REASON, CONTEXT)`. REASON is one of:
  - `open_textured(INPUT, cite(KEY))`;
  - `cross_reference_unresolved(cite(CITATION), cite(TARGET))`.
- `input_problems(PROBLEMS)`. PROBLEMS items are `unknown_key(KEY)`, `wrong_type(KEY)` and `duplicate_key(KEY)`.

CONTEXT is one of:

- `[inputs_relied_on(PAIRS)]` for open_textured;
- `[resolution(cite(TARGET), not_attempted), inputs_relied_on(PAIRS)]` for cross_reference_unresolved.

Result constructors (exported, never queries): definition_answer/3, unmet_elements/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1, indeterminate/1, needs_legal_review/2, open_textured/2, cross_reference_unresolved/2, resolution/2, inputs_relied_on/1, provenance/2, outside_fact/2, attested/2, attestation/4, url/2, document/2.

## 3 GROUND vocabulary (verdict_vocabulary)

- `consent_elements`: `unmet_elements(KEYS)` with not_met; `none` otherwise.
- `international_organisation` with met:
  - `governed_by_public_international_law` when the outside fact is attested true;
  - otherwise `set_up_by_agreement_between_countries`.
- `international_organisation` with any other status: `none`.
- Every other relation, every status: `none`.

## 4 Profile keys (root_exports order = rank; no numeric or date keys)

Kinds: J = judgement (true / false / unsure), C = crisp (true / false), O = outside fact (attested(true or false, attestation(BY, AT, REASON, EVIDENCE))).

| rank | key | kind | point |
|---|---|---|---|
| 1 | information_relates_to_natural_person | J | 4(1) |
| 2 | natural_person_identified | C | 4(1) |
| 3 | natural_person_identifiable | J | 4(1) |
| 4 | operation_performed_on_the_data | C | 4(2) |
| 5 | stored_data_marked_to_limit_future_processing | C | 4(3) |
| 6 | processing_automated | C | 4(4) |
| 7 | evaluates_personal_aspects_of_natural_person | J | 4(4) |
| 8 | attribution_needs_additional_information | J | 4(5) |
| 9 | additional_information_kept_separately | C | 4(5) |
| 10 | measures_prevent_attribution | J | 4(5) |
| 11 | structured_set_accessible_by_specific_criteria | J | 4(6) |
| 12 | data_disclosed_to_receiving_body | C | 4(9) |
| 13 | receiving_body_public_authority_in_particular_inquiry | C | 4(9) |
| 14 | receiving_body_is_data_subject | C | 4(10) |
| 15 | receiving_body_is_controller_or_processor | C | 4(10) |
| 16 | receiving_body_authorised_under_direct_authority | C | 4(10) |
| 17 | indication_freely_given | J | 4(11) |
| 18 | indication_specific | J | 4(11) |
| 19 | indication_informed | J | 4(11) |
| 20 | indication_unambiguous | J | 4(11) |
| 21 | agreement_by_statement_or_clear_affirmative_action | J | 4(11) |
| 22 | breach_of_security | J | 4(12) |
| 23 | breach_led_to_listed_outcome | C | 4(12) |
| 24 | service_is_information_society_service | O | 4(25) |
| 25 | organisation_governed_by_public_international_law | O | 4(26) |
| 26 | body_set_up_by_agreement_between_countries | C | 4(26) |

Totals: twelve J, twelve C, two O. EVIDENCE is `url(URL, RETRIEVED_AT)`, `document(UPLOAD_ID, SHA256)` or `none`; it is never inspected.

## 5 Citation keys

citation_vocabulary, in this order:

1. eu_reg_2016_679_art_4_1
2. eu_reg_2016_679_art_4_2
3. eu_reg_2016_679_art_4_3
4. eu_reg_2016_679_art_4_4
5. eu_reg_2016_679_art_4_5
6. eu_reg_2016_679_art_4_6
7. eu_reg_2016_679_art_4_9
8. eu_reg_2016_679_art_4_10
9. eu_reg_2016_679_art_4_11
10. eu_reg_2016_679_art_4_12
11. eu_reg_2016_679_art_4_25
12. eu_reg_2016_679_art_4_26

Each key maps to unit `02016R0679-20160504#point_004_N`.

Lexicon targets (outside-fact TARGETs, NOT in citation_vocabulary, always written last):

- eu_dir_2015_1535_art_1_1_b;
- public_international_law_governing_organisation.

## 6 Public predicates (relation order = this list's order for the twelve)

- `personal_data(Profile, Answer)`: PD. Cites eu_reg_2016_679_art_4_1.
- `processing(Profile, Answer)`: PR. Cites eu_reg_2016_679_art_4_2.
- `restriction_of_processing(Profile, Answer)`: PD AND stored_data_marked_to_limit_future_processing. Cites eu_reg_2016_679_art_4_3.
- `profiling(Profile, Answer)`: PR AND processing_automated AND evaluates_personal_aspects_of_natural_person. Cites eu_reg_2016_679_art_4_4.
- `pseudonymisation(Profile, Answer)`: PR AND attribution_needs_additional_information AND additional_information_kept_separately AND measures_prevent_attribution. Cites eu_reg_2016_679_art_4_5.
- `filing_system(Profile, Answer)`: PD AND structured_set_accessible_by_specific_criteria. Cites eu_reg_2016_679_art_4_6.
- `receiving_body_is_recipient(Profile, Answer)`: PD AND data_disclosed_to_receiving_body AND NOT receiving_body_public_authority_in_particular_inquiry (defeater). Cites eu_reg_2016_679_art_4_9.
- `receiving_body_is_third_party(Profile, Answer)`: NOT data subject AND NOT controller or processor AND NOT authorised under direct authority (three defeaters). Cites eu_reg_2016_679_art_4_10.
- `consent_elements(Profile, Answer)`: the AND of the five indication judgements. GROUND unmet_elements(KEYS) with not_met. Cites eu_reg_2016_679_art_4_11.
- `personal_data_breach(Profile, Answer)`: PR AND breach_of_security AND breach_led_to_listed_outcome. Cites eu_reg_2016_679_art_4_12.
- `information_society_service(Profile, Answer)`: the outside fact service_is_information_society_service. Cites eu_reg_2016_679_art_4_25, with target eu_dir_2015_1535_art_1_1_b on referral.
- `international_organisation(Profile, Answer)`: outside fact OR body_set_up_by_agreement_between_countries, with GROUND per section 3. Cites eu_reg_2016_679_art_4_26, with target public_international_law_governing_organisation on referral.
- `data_and_processing_outside_facts(Profile, OutsideFacts)`: returns one of:
  - `[outside_fact(service_is_information_society_service, Attested), outside_fact(organisation_governed_by_public_international_law, Attested)]`, with each Attested the given term or `absent`;
  - `input_problems(Problems)`.

  Cites eu_reg_2016_679_art_4_25 and eu_reg_2016_679_art_4_26.
- `gdpr_common_definitions_data_and_processing_input_problems(Profile, Problems)`: the typed input check of section 8.3, with exactly one solution; it does not answer a point of Art 4.
- `decide_gdpr_common_definitions_data_and_processing(Profile, Verdict)`: query type #3. Verdict is gdpr_common_definitions_data_and_processing_verdict(Classification, Citations).
  - Citations is the set union of every row's CITATIONS: citation_vocabulary order first, then lexicon targets in the order listed in section 5.
  - With input problems, the verdict is gdpr_common_definitions_data_and_processing_verdict(input_problems(Problems), []).
- `gdpr_common_definitions_data_and_processing_status(Profile, Classification)`: the Classification of decide/2. Query type #3.
- `gdpr_common_definitions_data_and_processing_checklist(Profile, Checklist)`: query type #7. Built with `eval_requirements(RelationNames, Profile, requirement, Checklist)`.
  - Each item is `item(RelationName, DefinitionAnswer, cite(PointKey))`, so every item, met ones included, carries cite provenance of the point it answers.
  - `requirement(RelationName, Profile, Status, Citation)` takes RelationName FIRST.
- `gdpr_common_definitions_data_and_processing_what_if(Profile, Key, Value, Verdict)`: `profile_set(Profile, attribute(Key, Value), Changed)`, then decide/2 on Changed. An unknown Key or wrong-typed Value surfaces as input_problems.
- Fixtures: `gdpr_common_definitions_data_and_processing_fixture(FixtureName, Profile)` and `gdpr_common_definitions_data_and_processing_fixture_expected(FixtureName, RelationName, Answer)`. See section 8.7.

## 7 Planned reuse (manifest `uses:`)

**formalize_lib**

Used:

- `profile_get/3`, `profile_has/2`, `profile_lacks/2` (the only profile access);
- `profile_set/3` (what_if);
- `eval_requirements/4` (checklist; not hand-rolled, R1);
- `and_status/2`, `or_status/2`, `collect_unknown/2` (Kleene AND / OR);
- `memberd/2`, `not_member/2`;
- result terms `item/3`, `attribute/2`.

The Kleene combinators use these encodings:

- MET leaves are `met`.
- UNMET leaves are `unmet(Key)`.
- OPEN leaves are `unknown([Leaf])`, with Leaf one of `open_by_absence(Key)`, `open_by_judgement(Key)` or `open_by_outside_fact(Key)`.

P2 MUST verify that and_status/or_status implement UNMET-dominates (AND) and MET-dominates (OR). It must also verify that the unknown payloads of OPEN children are concatenated without loss. If they are not, the slice defines local `node_all/2` and `node_any/2` over its own open/1 term, which is a different payload and not a C15 clone, and records the kit gap in NOTES.md.

Not used:

- `check_tri/4` and `check_tri_neg/4`. Their unknown status does not separate absent from unsure, which the status precedence needs. The four-way leaf classifier is not a clone of them; record a lint pragma if C15 fires.
- `assess/6`. Its labels(Pos, Indet, Neg) decision does not fit twelve parallel definitions.

**validate_props** (tests):

- `run_props/1`;
- `prop_totality/3`, `prop_determinism/3` (exactly one solution per relation per fixture);
- `prop_citation_complete/3`;
- `prop_missing_key_coverage/3`.

**library(lists)**: `msort/2` and `sort/2` order rank-tagged leaves. `sort/4` with `@<` deduplication is used only on Rank-Leaf pairs.

Not used: currency_vocab, vat_category, country, date_time, deadline_lib, rolling_window and compliance_lib. The package has no money, dates or norms.

## 8 Determination slice: gdpr_common_definitions_data_and_processing.clausal

The slice is self-contained. It owns every value fact, every formula, the input check, the descent and the answer construction.

### 8.1 Value facts owned (in this file, not in a constants file)

- **`contract_key(Rank, Key, Kind)`**: 26 rows, section 4 order. Kind is `judgement`, `crisp` or `outside_fact`.
- **`citation_order(Rank, CitationKey)`**: 12 rows for citation_vocabulary, then the 2 lexicon targets at ranks 13 and 14.
- **`relation_point(RelationName, CitationKey)`**: 12 rows, section 6 order.
- **Named formulas**, built from the node terms `leaf(Key)`, `negation(Node)`, `all_of(Nodes)`, `any_of(Nodes)` and `named(FormulaName)`:
  - `named_formula(personal_data_formula, all_of([leaf(information_relates_to_natural_person), any_of([leaf(natural_person_identified), leaf(natural_person_identifiable)])]))`;
  - `named_formula(processing_formula, all_of([named(personal_data_formula), leaf(operation_performed_on_the_data)]))`.
- **`relation_formula(RelationName, Node)`**: 12 rows exactly as section 6.
- **`referral(Input, CitationKey, Target, Inputs)`**. Target is `none` for judgements. Inputs are listed in rank order. Rows:
  - information_relates_to_natural_person and natural_person_identifiable: eu_reg_2016_679_art_4_1, inputs [information_relates_to_natural_person, natural_person_identified, natural_person_identifiable].
  - evaluates_personal_aspects_of_natural_person: eu_reg_2016_679_art_4_4, inputs [processing_automated, evaluates_personal_aspects_of_natural_person].
  - attribution_needs_additional_information and measures_prevent_attribution: eu_reg_2016_679_art_4_5, inputs [attribution_needs_additional_information, additional_information_kept_separately, measures_prevent_attribution].
  - structured_set_accessible_by_specific_criteria: eu_reg_2016_679_art_4_6, inputs [structured_set_accessible_by_specific_criteria].
  - Each of the five 4(11) judgements: eu_reg_2016_679_art_4_11, inputs the five 4(11) keys.
  - breach_of_security: eu_reg_2016_679_art_4_12, inputs [breach_of_security, breach_led_to_listed_outcome].
  - service_is_information_society_service: eu_reg_2016_679_art_4_25, target eu_dir_2015_1535_art_1_1_b, inputs [service_is_information_society_service].
  - organisation_governed_by_public_international_law: eu_reg_2016_679_art_4_26, target public_international_law_governing_organisation, inputs [organisation_governed_by_public_international_law, body_set_up_by_agreement_between_countries].
- **`outside_fact_row(Key, CitationKey, Target, fetcher(none), arrival([attested, fetched]))`**: 2 rows mirroring the manifest `outside_facts:` block.
- **`consent_element(Rank, Key)`**: the five 4(11) keys in rank order.
- There are no thresholds, periods or tables.

### 8.2 Rules / requirements

The twelve relation formulas are in section 6. The defeaters are:

- recipient_inquiry_exception (4(9) second sentence);
- third_party_excluded_data_subject (4(10));
- third_party_excluded_controller_or_processor (4(10));
- third_party_excluded_authorised_person (4(10)).

Each defeater is a `negation(leaf(Key))` node, so a defeater that is itself OPEN keeps the rule OPEN rather than failing it. Each defeater leaf read is `once(profile_get(Profile, Key, Value))`, guarded by the ground key and the duplicate-free profile the input check guarantees.

### 8.3 Algorithm (one solution per step)

1. **INPUT CHECK** (`gdpr_common_definitions_data_and_processing_input_problems/2`).
   - The profile is not an attribute list in any of these cases, each giving [wrong_type(profile)]:
     - it is a variable;
     - it is a partial or improper list;
     - an item is not attribute(_, _);
     - an item's KEY is a non-ground compound.
   - Otherwise, for each contract key in rank order, count occurrences with ==. A count above 1 gives duplicate_key(Key), and its values are not read.
   - A count of exactly 1 with a value outside the type gives wrong_type(Key):
     - crisp: nonvar and == true or false;
     - judgement: nonvar and == true, false or unsure;
     - outside fact: subsumes_term(attested(_, attestation(_, _, _, _)), Value) and the first argument == true or false.
   - Then unknown_key(Key) for each non-contract key, in first-occurrence order, deduplicated with ==. This includes each distinct unbound key variable, returned as that same variable, with its value unchecked.
   - Absence is never a problem.
2. **GATE**. PROBLEMS non-empty gives definition_answer(input_problems(PROBLEMS), none, []) from every relation and input_problems(PROBLEMS) from data_and_processing_outside_facts. PROBLEMS = [] proceeds. The two clauses are disjoint on [] versus [_|_].
3. **LEAF**. `leaf_value(Profile, Key, Value)` has disjoint clauses, keyed on the kind:
   - profile_lacks: unknown([open_by_absence(Key)]) for crisp and judgement keys, unknown([open_by_outside_fact(Key)]) for outside facts;
   - true, or attested(true, _): met;
   - false, or attested(false, _): unmet(Key);
   - unsure: unknown([open_by_judgement(Key)]).
4. **NODES**.
   - all_of and any_of go through and_status/or_status.
   - negation swaps met and unmet(Key) and keeps unknown(Leaves).
   - named(Name) expands named_formula.
   - An UNMET child of an OPEN any_of contributes no leaves, which is the descent rule.
5. **STATUS**. met gives met and not_met gives not_met. For unknown(Leaves), tag each leaf with its key rank and sort/2, which removes duplicates. Then:
   1. MISSING = the open_by_absence keys. If [_|_], the status is indeterminate(MISSING).
   2. Else, if any open_by_outside_fact exists, the first one, F, gives needs_legal_review(cross_reference_unresolved(cite(C), cite(T)), [resolution(cite(T), not_attempted), inputs_relied_on(PAIRS)]), with C and T from F's referral row.
   3. Else the first open_by_judgement key, J, gives needs_legal_review(open_textured(J, cite(C)), [inputs_relied_on(PAIRS)]).

   PAIRS = Key-Value for the row's Inputs that are present, in rank order, the unsure one included, with no provenance term.
6. **GROUND**.
   - consent_elements with not_met: unmet_elements(KEYS), with KEYS the consent_element keys whose given value == false, in rank order.
   - international_organisation with met: as section 3.
   - Else none.
7. **CITATIONS**.
   - met, not_met and indeterminate: [cite(relation_point)].
   - open_textured: [cite(C)].
   - cross_reference_unresolved: [cite(C), cite(T)].

### 8.4 Verdict atoms

The slice uses the atoms of section 2 and the grounds of section 3. Internally it also uses leaf and kind atoms that never appear in an answer:

- open_by_absence, open_by_judgement, open_by_outside_fact;
- judgement, crisp, outside_fact;
- the node functors all_of, any_of, negation, leaf, named.

### 8.5 Shared with another slice (belongs in kernel.clausal)

NONE. This is the only determination slice, so no predicate must be shared.

kernel.clausal keeps its scaffold floor (module header and result-constructor declarations) with no legal content. The kit candidates of NOTES.md would move there only when a second slice needs them.

### 8.6 Per-rule tests, checklist and verdict (in the slice's tests)

At least one test per route per relation:

- met;
- not_met;
- indeterminate (list-all, rank order);
- open_textured (first unsure in rank order, referral citation);
- cross_reference_unresolved (4(25), 4(26));
- input_problems.

Each negative test is paired with a positive test over the same case.

Property tests:

- exactly one solution (count with findall plus length, 1);
- an unread key never changes an answer;
- a settled answer is not reopened by extra unsure input elsewhere.

Citation completeness: every checklist item carries cite(PointKey).

### 8.7 Fixtures with expected answers

**fixture_empty_profile** ([]):

- personal_data: indeterminate([information_relates_to_natural_person, natural_person_identified, natural_person_identifiable]), citing 4_1.
- receiving_body_is_third_party: indeterminate([receiving_body_is_data_subject, receiving_body_is_controller_or_processor, receiving_body_authorised_under_direct_authority]).
- information_society_service:
  - status: needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_25), cite(eu_dir_2015_1535_art_1_1_b)), [resolution(cite(eu_dir_2015_1535_art_1_1_b), not_attempted), inputs_relied_on([])]);
  - citations: [cite(eu_reg_2016_679_art_4_25), cite(eu_dir_2015_1535_art_1_1_b)].
- international_organisation: indeterminate([body_set_up_by_agreement_between_countries]).

**fixture_identifiability_unsure** (information true, identified false, identifiable unsure, operation true, processing_automated true, evaluates true):

- personal_data and profiling: needs_legal_review(open_textured(natural_person_identifiable, cite(eu_reg_2016_679_art_4_1)), [inputs_relied_on([information_relates_to_natural_person-true, natural_person_identified-false, natural_person_identifiable-unsure])]), citing [cite(eu_reg_2016_679_art_4_1)].

**fixture_partially_automated_profiling** (PD met by identified true, operation true, automated true, evaluates true): profiling met, none, [cite(eu_reg_2016_679_art_4_4)].

**fixture_manual_evaluation** (automated false, evaluates unsure, identifiable absent): profiling not_met. UNMET dominates.

**fixture_pseudonymised_research_set**: pseudonymisation met.

**fixture_inquiry_authority** (PD met, disclosed true, inquiry true): receiving_body_is_recipient not_met.

**fixture_processor_receiving_body** (data subject false, controller or processor true, authorised false): receiving_body_is_third_party not_met.

**fixture_pre_ticked_box** (freely true, specific true, informed true, unambiguous false, agreement false): consent_elements not_met, unmet_elements([indication_unambiguous, agreement_by_statement_or_clear_affirmative_action]), [cite(eu_reg_2016_679_art_4_11)].

**fixture_ransomware_breach** (PD met, operation true, breach true, outcome true): personal_data_breach met.

**fixture_treaty_body** (body true, outside fact absent): international_organisation met, set_up_by_agreement_between_countries.

**fixture_attested_organisation** (outside fact attested(true, attestation(host, at, reason, none)), body false): international_organisation met, governed_by_public_international_law. data_and_processing_outside_facts lists that term and outside_fact(service_is_information_society_service, absent).

**fixture_body_not_treaty_unattested** (body false, outside fact absent): international_organisation needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_4_26), cite(public_international_law_governing_organisation)), [resolution(cite(public_international_law_governing_organisation), not_attempted), inputs_relied_on([body_set_up_by_agreement_between_countries-false])]).

Input-check fixtures:

- fixture_duplicate_key: two processing_automated items with equal values gives [duplicate_key(processing_automated)].
- fixture_wrong_types: natural_person_identified unsure gives [wrong_type(natural_person_identified)].
- fixture_unknown_and_unbound_key: an unknown key spelled in full, then an unbound variable twice, gives [unknown_key(that_key), unknown_key(SameVariable)].
- fixture_not_a_list: an atom gives [wrong_type(profile)].

## 9 Other modules in the chain

- **kernel.clausal**: the scaffold floor only (section 8.5).
- **citations.clausal**: the 12 citation keys plus the 2 lexicon targets with pinned unit ids and short titles. The slice's citation_order facts must agree with it; a test checks this.
- **parameters.clausal**: no statutory figures. It keeps the scaffold header and states that the classification family has none.
- **queries.clausal**: the facade predicates of section 6 (decide, status, checklist, what_if) over the slice's twelve relations.
- **fixtures.clausal**: section 8.7.
- **Package facade**: re-exports the twelve relations, the input check, data_and_processing_outside_facts, the facade predicates, the fixtures and the result constructors, in root_exports order.

## 10 Claims checked by the seven test modes

- **Totality**: every public predicate succeeds on every fixture and on generated profiles (all 3^12 × 3^12 judgement and crisp combinations are sampled, not enumerated).
- **Determinism**: exactly one solution, counted, never deduplicated.
- **Citation completeness**:
  - CITATIONS is non-empty unless the status is input_problems;
  - it is in citation_vocabulary order with targets last;
  - every item is cite/1.
- **Unread-key invariance**: no relation's answer changes when a key it does not read is added, well-formed.
- **Input-check precedence**: an ill-formed key no relation reads still yields input_problems everywhere.
- **Cut-free**: no `!`, `->` or `*->` anywhere. `once/1` appears only around guarded profile reads.
