# SIGNATURE — eu/data_protection/gdpr_transfer_scc

The public query surface is `decide_gdpr_transfer_scc(PROFILE, gdpr_transfer_scc_verdict(STATUS, CITATIONS))` and `gdpr_transfer_scc_status(PROFILE, STATUS)`. The facade reports the SAFEGUARD determination, query (C). Beside the facade there are the four contract queries (A) to (D) and the input check (E).

Every public predicate yields EXACTLY ONE solution for every PROFILE. This is totality and determinism, and it is tested in every mode. Determinism comes from disjoint clause guards with ground outputs folded into heads (C17), with no `!`, `->` or `*->`. Where an ordered first-match is needed (the status rule), candidates are collected with `findall/3` in contract order and the head of the list is taken, so one witness is returned.

There are no numeric statutory figures, so there are no `constant_value/2` declarations. There are no dates and no money. Nothing is imported from another domain.

## 1. Verdict STATUS atoms (replace placeholder `{ required, permitted, not_applicable }`)

Final RESULT atoms, bare:

- (A) `module_one`, `module_two`, `module_three`, `module_four`
- (B) `clauses_available`, `clauses_not_available`
- (C) `appropriate_safeguards_provided`, `appropriate_safeguards_not_provided`. These are the facade STATUS.
- (D) `appendix_complete`, `appendix_incomplete`

Status compounds (not final). Each is exactly one of:

- `indeterminate([KEY])`. The list holds one bare key. The bare atom `indeterminate` is never written.
- `needs_legal_review(cross_reference_unresolved(cite(CITATION), cite(TARGET)), [resolution(cite(TARGET), not_attempted), inputs_relied_on([KEY-absent])])`
- `needs_legal_review(open_textured(KEY, cite(CITATION)), [inputs_relied_on([KEY-unsure])])`
- `input_problems(PROBLEMS)`

Compliance verdict atoms (query type #13, facade `gdpr_transfer_scc_reliance_check/2`):

- `may_rely_on_clauses` when (C) gives `appropriate_safeguards_provided`;
- `may_not_rely_on_clauses` when (C) gives `appropriate_safeguards_not_provided`;
- otherwise the status compound of (C), passed through unchanged.

## 2. Profile keys

PROFILE is `[attribute(KEY, VALUE), ...]`, read only with `profile_get/3`. There are eighteen keys, listed here in contract order, which is also the order of root_exports and input_contract. There are no numeric keys and no date keys.

| # | Key | Kind | Values |
|---|---|---|---|
| 1 | `standard_contractual_clauses_decision_in_force` | outside fact | `attested(true\|false, attestation(BY, AT, REASON, EVIDENCE))` |
| 2 | `exporter_processing_subject_to_gdpr` | outside fact | as above |
| 3 | `importer_processing_subject_to_gdpr` | outside fact | as above (false is what Art 1(1) needs) |
| 4 | `no_reason_to_believe_local_laws_prevent_compliance` | outside fact | as above |
| 5 | `exporter_role` | enumeration | `controller`, `processor` |
| 6 | `importer_role` | enumeration | `controller`, `processor` |
| 7 | `standard_contractual_clauses_concluded` | crisp | `true`, `false` |
| 8 | `module_selected` | enumeration | `module_one`, `module_two`, `module_three`, `module_four` |
| 9 | `clauses_modified` | crisp | `true`, `false` |
| 10 | `added_clauses_contradict_clauses` | judgement | `true`, `false`, `unsure` |
| 11 | `local_laws_assessment_documented` | crisp | `true`, `false` |
| 12 | `processor_combines_received_data_with_data_collected_in_union` | crisp | `true`, `false` |
| 13 | `annex_i_a_list_of_parties_completed` | crisp | `true`, `false` |
| 14 | `annex_i_b_description_of_transfer_completed` | crisp | `true`, `false` |
| 15 | `annex_i_c_competent_supervisory_authority_identified` | crisp | `true`, `false` |
| 16 | `annex_ii_measures_described_in_specific_terms` | judgement | `true`, `false`, `unsure` |
| 17 | `sub_processor_authorisation_option` | enumeration | `specific_prior_authorisation`, `general_written_authorisation` |
| 18 | `annex_iii_list_of_sub_processors_completed` | crisp | `true`, `false` |

EVIDENCE is `none`, `url(URL, RETRIEVED_AT)` or `document(UPLOAD_ID, SHA256)`. Its contents are never inspected, beyond requiring that it is not, and holds no, unbound variable.

root_exports holds every bare atom the scorer resolves:

- the eighteen keys;
- `controller`, `processor`, `specific_prior_authorisation`, `general_written_authorisation`;
- the ten RESULT atoms;
- `unsure`, `absent`, `not_attempted`.

Result constructors (exported, never queries): `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `resolution/2`, `inputs_relied_on/1`, `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`.

## 3. Citation-key atoms (citations.clausal, canonical lexicon scheme)

Load-bearing:

- `eu_dec_2021_914_art_1` (Art 1, paragraph 1 read; unit 32021D0914#art1)
- `eu_dec_2021_914_annex_cl_1_b`, `eu_dec_2021_914_annex_cl_1_b_i`, `eu_dec_2021_914_annex_cl_1_b_ii`
- `eu_dec_2021_914_annex_cl_1_d`
- `eu_dec_2021_914_annex_cl_2_a`
- `eu_dec_2021_914_annex_cl_9_m2_a`, `eu_dec_2021_914_annex_cl_9_m3_a`
- `eu_dec_2021_914_annex_cl_14_m1m2m3m4_t`
- `eu_dec_2021_914_annex_cl_14_m1m2m3m4_a`
- `eu_dec_2021_914_annex_cl_14_m1m2m3m4_b`, `eu_dec_2021_914_annex_cl_14_m1m2m3m4_b_i`, `eu_dec_2021_914_annex_cl_14_m1m2m3m4_b_ii`, `eu_dec_2021_914_annex_cl_14_m1m2m3m4_b_iii`
- `eu_dec_2021_914_annex_cl_14_m1m2m3m4_d`
- `eu_dec_2021_914_appendix`
- `eu_dec_2021_914_annex_i` (units annexI, annexI_B, annexI_C)
- `eu_dec_2021_914_annex_ii`
- `eu_dec_2021_914_annex_iii`
- `eu_reg_2016_679_art_46_2_c`

Deferred (in the deferred set, never emitted by a query): `eu_reg_2016_679_art_46_1`, `eu_reg_2016_679_art_46_2`.

Referral TARGET atoms (cross_reference_unresolved), with their CITATION:

| Key | CITATION | TARGET |
|---|---|---|
| `standard_contractual_clauses_decision_in_force` | `eu_dec_2021_914_art_1` | `standard_contractual_clauses_decision_in_force_statement` |
| `exporter_processing_subject_to_gdpr` | `eu_dec_2021_914_art_1` | `exporter_subject_to_gdpr_statement` |
| `importer_processing_subject_to_gdpr` | `eu_dec_2021_914_art_1` | `importer_subject_to_gdpr_statement` |
| `no_reason_to_believe_local_laws_prevent_compliance` | `eu_dec_2021_914_annex_cl_14_m1m2m3m4_a` | `local_laws_assessment_outcome_statement` |

Open-textured referral rows:

| Key | CITATION |
|---|---|
| `added_clauses_contradict_clauses` | `eu_dec_2021_914_annex_cl_2_a` |
| `annex_ii_measures_described_in_specific_terms` | `eu_dec_2021_914_annex_ii` |

## 4. Public predicates

- `standard_contractual_clauses_module(Profile, Result, Citations)`: maps the roles to the module (step 0 input problems; step 1 or 2 `indeterminate([exporter_role])` / `indeterminate([importer_role])`; step 3 the module). Citations [cite(eu_dec_2021_914_art_1), cite(eu_dec_2021_914_annex_i)].
- `standard_contractual_clauses_availability(Profile, Result, Basis, Citations)`: Article 1(1). The steps are:
  1. any of: decision false, exporter false, importer true gives `clauses_not_available`;
  2. otherwise the first absent outside fact gives the referral;
  3. otherwise `clauses_available`.

  Basis holds the present outside facts in order. Citation eu_dec_2021_914_art_1.
- `standard_contractual_clauses_safeguard(Profile, Result, Basis, Citations)`: Art 1(1) with Clause 2(a), Clause 14 and GDPR Art 46(2)(c), via THE STATUS RULE over its twelve keys. On a settled result, Citations is the 13-key list (Art 1, Cl 1(b), (b)(i), (b)(ii), Cl 2(a), Cl 14 t, a, b, b_i, b_ii, b_iii, d, GDPR 46(2)(c)) for both atoms.
- `standard_contractual_clauses_appendix(Profile, Result, Citations)`: Clause 1(d) with Appendix and Annexes I to III, via THE STATUS RULE over its eight keys. On a settled result, Citations is the 8-key list (Art 1, Cl 1(d), appendix, annex_i, annex_ii, annex_iii, Cl 9 m2 a, Cl 9 m3 a).
- `gdpr_transfer_scc_input_problems(Profile, Problems)`: the typed input check (THE INPUT CHECK). It never fails or raises and gives one solution for every term. Order of PROBLEMS:
  1. per contract key in contract order: `duplicate_key(KEY)`, else `wrong_type(KEY)`;
  2. then `unknown_key(KEY)` in order of first occurrence;
  3. a non-attribute-list PROFILE gives `[wrong_type(profile)]` alone.
- `decide_gdpr_transfer_scc(Profile, gdpr_transfer_scc_verdict(Status, Citations))`: facade. Status and Citations are those of the safeguard query. Citation per (C).
- `gdpr_transfer_scc_status(Profile, Status)`: query type #3 status_determination. It returns the safeguard RESULT (final atom or status compound). Citation per (C).
- `gdpr_transfer_scc_checklist(Profile, Checklist)`: query type #7 justification. Checklist is a list of `item(RequirementId, Status, cite(KEY))` built with formalize_lib `eval_requirements/4` over `gdpr_transfer_scc_requirement/4`. Every item carries cite, met items included. Items are listed below, with the citation each carries:
  - decision_in_force (art_1)
  - exporter_subject_to_gdpr (art_1)
  - importer_not_subject_to_gdpr (art_1)
  - clauses_concluded (annex_cl_1_b)
  - module_matches_roles (annex_cl_2_a)
  - clauses_not_modified (annex_cl_2_a)
  - added_clauses_do_not_contradict (annex_cl_2_a)
  - local_laws_warranty_given (annex_cl_14_m1m2m3m4_a)
  - local_laws_assessment_documented (annex_cl_14_m1m2m3m4_d)

  Item status is `met`, `unmet(Reason)` or `unknown([Key])`, or `inapplicable` for the two Clause 14 items where Clause 14 does not apply (annex_cl_14_m1m2m3m4_t). The checklist explains (C) and never overrides it: the verdict comes from the status rule.
- `gdpr_transfer_scc_what_if(Profile, Key, Value, Status)`: counterfactual over the safeguard status. It uses kit/query_combinators `what_if/5` with closure `gdpr_transfer_scc_status`, which replaces or adds `attribute(Key, Value)` via `profile_set/3`. Citation per (C).
- `gdpr_transfer_scc_reliance_check(Profile, Verdict)`: query type #13 compliance_check. It asks whether the proposed action 'rely on these clauses as the Art 46(2)(c) safeguard for this transfer' is allowed. The verdict is `may_rely_on_clauses`, `may_not_rely_on_clauses`, or the status compound passed through. Citations eu_dec_2021_914_art_1, eu_reg_2016_679_art_46_2_c. It never says the transfer is lawful.
- `gdpr_transfer_scc_fixture(Name, Profile)` and `gdpr_transfer_scc_fixture_expected(Name, Query, Expected)`: fixtures (fixtures.clausal). Planned names:
  - `module_two_all_met`
  - `module_four_no_combination`
  - `module_four_with_combination_undocumented`
  - `importer_subject_to_gdpr`
  - `decision_in_force_absent`
  - `module_selected_wrong`
  - `added_clauses_unsure_decisive`
  - `added_clauses_unsure_settled_elsewhere`
  - `appendix_module_three_option_one_missing_annex_iii`
  - `appendix_module_four_complete`
  - `annex_ii_unsure`
  - `duplicate_and_unknown_keys`
  - `bare_boolean_outside_fact`
  - `unbound_profile`

## 5. Slice section — gdpr_transfer_scc.clausal

**Statutory VALUE facts owned here.** These are not in a shared constants file. Each is a table of facts:

- `module_for_roles(ExporterRole, ImporterRole, Module)`: four rows (controller/controller to module_one; controller/processor to module_two; processor/processor to module_three; processor/controller to module_four). Citation annex_i.
- `clause_fourteen_applies(Module, Combines)`: module_one, module_two and module_three with any value; module_four only with `true`. Citation annex_cl_14_m1m2m3m4_t.
- `appendix_part_required(Module, Option, PartKey)`:
  - I.A and I.B for all modules;
  - I.C and II for module_one, module_two and module_three;
  - III for module_two and module_three with `specific_prior_authorisation`.

  Citations annex_i, annex_ii, annex_iii, annex_cl_9_m2_a, annex_cl_9_m3_a.
- `key_domain(Key, Values)` for completion: outside facts `[true, false]` (attested values); crisp and judgement `[true, false]`; roles `[controller, processor]`; module_selected four atoms; option two atoms.
- `safeguard_keys(Keys)`: the twelve keys in contract order. `appendix_keys(Keys)`: the eight keys.
- `safeguard_citations(List)` and `appendix_citations(List)`: the exact lists of section 4.

**Rules / requirements.**

Safeguard final rule, `safeguard_final(Values, Result)`, over a completed assignment, folded into two heads:

- `appropriate_safeguards_provided` iff all of these hold:
  - decision true;
  - exporter true;
  - importer false;
  - concluded true;
  - module_selected equals `module_for_roles`;
  - modified false;
  - added false;
  - Clause 14 is not applicable, or (warranty true and documented true).
- otherwise `appropriate_safeguards_not_provided`, with one clause per disjoint failing route, guarded so that exactly one head fires.

Appendix final rule, `appendix_final(Values, Result)`: `appendix_complete` iff every `appendix_part_required` part is true; otherwise `appendix_incomplete`.

The module and availability queries follow THE LIMBS directly, with an ordered disjoint step for each clause.

**Verdict atoms.** `module_one`, `module_two`, `module_three`, `module_four`, `clauses_available`, `clauses_not_available`, `appropriate_safeguards_provided`, `appropriate_safeguards_not_provided`, `appendix_complete`, `appendix_incomplete`, plus the status compounds of section 1.

**Per-rule tests.** Each of these has a positive test and a paired negative test:

- each module row;
- each availability step;
- the settled-with-absent case (importer attested true and everything else absent gives `appropriate_safeguards_not_provided`, with BASIS holding the one item);
- Clause 14 off under Module Four (warranty and documented absent, still settled);
- the outside-fact referral beats a missing key (decision absent and concluded absent gives the referral on the decision);
- the behind test (roles absent and module_selected absent names `exporter_role`, not `module_selected`);
- an unsure judgement only when nothing decisive is missing;
- an unread key not changing the answer (Appendix keys under the safeguard query);
- a duplicate solution guard, `findall` length 1, in every test.

**Shared with another slice (lives in kernel.clausal, nothing else).**

- `gdpr_transfer_scc_input_problems/2` and its helpers. These are used by every query, by the facade and by queries.clausal.
- `outside_fact_referral(Key, Citation, Target)`, the four rows of section 3.
- `judgement_referral(Key, Citation)`, two rows.
- `present_outside_facts(Profile, Keys, Basis)`: builds `outside_fact(KEY, ATTESTED)` in key order.
- The generic STATUS RULE engine `status_rule(Profile, Keys, FinalPredicate, Result)`. The steps are:
  1. enumerate completions of absent and unsure keys over `key_domain/2`;
  2. settled if one final atom;
  3. else the first absent outside fact that matters gives the referral;
  4. else the first absent non-outside key that matters and is behind no other absent key that matters ((i) some value of L makes K not matter, (ii) for every value of K, L still matters) gives `indeterminate([K])`;
  5. else the first unsure judgement that matters gives open_textured.

  FinalPredicate is passed as a closure (`safeguard_final` / `appendix_final`). 'Matters' compares completions that differ only in K. Worst case is 2^10 x 4 completions for (C); this is acceptable, and the engine memoises per call by computing the completion list once.

## 6. Planned reuse (manifest `uses:`)

- `formalize_lib`:
  - `profile_get/3`, `profile_has/2`, `profile_lacks/2` (presence first, then value);
  - `profile_set/3` (what-if and completion);
  - `eval_requirements/4` and `item/3` (checklist; not hand-rolled, R1);
  - `memberd/2`, `not_member/2`, `first_applicable/2` (ordered first match);
  - vocabulary `met`, `unmet/1`, `unknown/1`, `applicable`, `inapplicable`.

  `check_tri/4` is NOT used for the verdict: judgements feed the completion engine. They are used only in the checklist, where `check_tri` and `check_tri_neg` give the item status for `added_clauses_contradict_clauses` (negative polarity).
- `kit/query_combinators`: `what_if/5` (gdpr_transfer_scc_what_if/4).
- `validate_props`: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1` (property test mode).
- `kit/compliance_lib`: not used. The reliance check is a single-norm projection of (C), and a modality lattice would add a second source of truth. This is recorded so the gate does not expect it.
- Not used: `deadline_lib`, `date_time`, `rolling_window`, `currency_vocab`, `vat_category`, `country`. There are no dates, money or countries in the contract.
- Local, flagged for kit promotion: the completion-based status rule engine (NOTES S3 item 15).

## 7. Test modes (seven, v2 manifest)

1. load
2. unit (per-rule, in the slice)
3. fixtures (expected answers per query)
4. contract (answer shape, single solution, atoms only, no strings, numbers or booleans)
5. input check (duplicate, wrong_type, unknown_key, unbound and partial profile)
6. properties (validate_props totality, determinism, citation completeness)
7. mutations (eval/mutations.yaml: flip each guard and expect a failing test)
