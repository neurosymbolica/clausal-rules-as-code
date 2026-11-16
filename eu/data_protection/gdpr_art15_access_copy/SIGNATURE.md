# SIGNATURE — eu/data_protection/gdpr_art15_access_copy

## 1 Public query surface (summary)

The called contract is non-negotiable. Its five query names are given bare, without the package prefix, and the contract governs over the prefix convention:

- `access_answer_items(PROFILE, RESULT, BASIS, CITATIONS)`
- `access_answer_items_missing(PROFILE, RESULT, BASIS, CITATIONS)`
- `copy_scope(PROFILE, RESULT, CITATIONS)`
- `copy_fee(PROFILE, RESULT, CITATIONS)`
- `information_form(PROFILE, RESULT, CITATIONS)`
- `gdpr_art15_access_copy_input_problems(PROFILE, PROBLEMS)`

The facade keeps the scaffold names:

- `decide_gdpr_art15_access_copy(PROFILE, gdpr_art15_access_copy_verdict(STATUS, CITATIONS))`
- `gdpr_art15_access_copy_status(PROFILE, STATUS)`
- `gdpr_art15_access_copy_checklist(PROFILE, CHECKLIST)`
- `gdpr_art15_access_copy_what_if(PROFILE, KEY, VALUE, STATUS)`
- `gdpr_art15_access_copy_fixture(NAME, PROFILE)`

Three further predicates cover the required query types:

- `gdpr_art15_access_copy_compliance(PROFILE, ACTION, RESULT, CITATIONS)` (#13)
- `gdpr_art15_access_copy_deadline(PROFILE, RESULT, CITATIONS)` (#15)
- `decide_gdpr_art15_access_copy/2` (#2)

**Totality and determinism.** Every public predicate yields EXACTLY ONE solution for every ground PROFILE. The input check yields exactly one solution for EVERY term, an unbound one included. Supporting rules:

- No cut, `->` or `*->` is used.
- Defeaters are guarded by `once/1`.
- Ordered lists are built by a single pass over the item table.
- Set-like CITATIONS are built with `sort/2`.

**Imported figures.** This domain has no numeric statutory figure: no threshold, no period, no money. `parameters.clausal` therefore declares NO constant. The fee amount is not tested. The response period is deferred.

## 2 Verdict STATUS atoms (replace the placeholder `required, permitted, not_applicable`)

The status is derived ONLY from `access_answer_items_missing/4`:

| STATUS atom | from RESULT of access_answer_items_missing |
|---|---|
| `access_answer_complete` | `no_item_missing` |
| `access_answer_incomplete` | a non-empty item list |
| `access_answer_awaiting_input` | `indeterminate([KEY])` |
| `access_answer_referred_for_legal_review` | `needs_legal_review(REASON, CONTEXT)` |
| `access_answer_input_rejected` | `input_problems(PROBLEMS)` |

The bare atom `indeterminate` is NEVER used, because it is the atom-shadowing trap. Eligibility labels: `labels(access_answer_complete, access_answer_awaiting_input, access_answer_incomplete)`.

The RESULT atoms of the contract are root-exported:

- `no_item_missing`
- `no_personal_data_to_copy`
- `full_copy`
- `copy_limited_by_rights_and_freedoms_of_others`
- `no_fee_under_article_15_3`
- `reasonable_fee_permitted`
- `no_electronic_request`
- `other_form_requested`
- `commonly_used_electronic_form`

The compliance RESULT atoms are root-exported:

- `action_permitted`
- `action_not_permitted`
- `action_not_permitted_under_article_15`
- `action_not_applicable`

The deadline result constructor is `deadline_decided_by_sibling_order/1`. Its argument atom is `gdpr_data_subject_rights_response_period`.

These are also root-exported: `unsure`, `absent`, `not_attempted`.

## 3 Profile keys

The profile is an attribute list `[attribute(KEY, VALUE), ...]`, read ONLY with `formalize_lib:profile_get/3`. It is read by presence first, then by value. Keys are bare atoms.

There are twelve keys. The order below is the order of `root_exports` and of `input_contract`.

| # | key | kind | values |
|---|---|---|---|
| 1 | `items_provided` | list | proper list of item atoms (section 5); `[]` means none; a repeated atom is read once |
| 2 | `personal_data_concerning_data_subject_processed` | crisp (P) | `true` / `false` |
| 3 | `disclosure_to_recipients_made_or_envisaged` | crisp (R) | `true` / `false` |
| 4 | `some_personal_data_not_collected_from_data_subject` | crisp (C) | `true` / `false` |
| 5 | `source_information_available` | crisp (S) | `true` / `false` |
| 6 | `automated_decision_making_referred_to_in_article_22` | outside fact (A) | `attested(true or false, attestation(BY, AT, REASON, EVIDENCE))` |
| 7 | `transfer_to_third_country_or_international_organisation` | crisp (T) | `true` / `false` |
| 8 | `transfer_subject_to_article_46_safeguards` | outside fact (G) | `attested(true or false, attestation(BY, AT, REASON, EVIDENCE))` |
| 9 | `copy_would_adversely_affect_rights_and_freedoms_of_others` | judgement (J) | `true` / `false` / `unsure` |
| 10 | `further_copy_requested` | crisp (F) | `true` / `false` |
| 11 | `request_made_by_electronic_means` | crisp (E) | `true` / `false` |
| 12 | `other_form_requested_by_data_subject` | crisp (O) | `true` / `false` |

The profile has no numeric key and no date key. A key that a query does not read, whether present or absent, never changes that query's answer.

## 4 Citation-key atoms (canonical lexicon scheme, `_lexicon/citations.yaml`)

There is one key per load-bearing provision:

- `eu_reg_2016_679_art_15_1` (chapeau: confirmation and access)
- `eu_reg_2016_679_art_15_1_a`
- `eu_reg_2016_679_art_15_1_b`
- `eu_reg_2016_679_art_15_1_c`
- `eu_reg_2016_679_art_15_1_d`
- `eu_reg_2016_679_art_15_1_e`
- `eu_reg_2016_679_art_15_1_f`
- `eu_reg_2016_679_art_15_1_g`
- `eu_reg_2016_679_art_15_1_h`
- `eu_reg_2016_679_art_15_2`
- `eu_reg_2016_679_art_15_3`
- `eu_reg_2016_679_art_15_4`

Referral TARGET atoms appear only inside `cite(TARGET)` of THE ABSENT REFERRAL. They are listed in `citation_vocabulary` as targets:

- `article_22_automated_decision_making_statement`
- `article_46_safeguards_statement`

Some provisions are never cited: Art 4(1), (2), (7) and (9), Art 12, Art 22 and Art 46. No shortened citation atom is ever invented.

## 5 Public predicates (one line each)

- `access_answer_items(Profile, Result, Basis, Citations)`: the items the access answer owes, in item order. Otherwise `indeterminate([Key])`, the absent referral on A or G, or `input_problems/1`. Basis holds the `outside_fact(Key, Attested)` terms copied verbatim. Cites Art 15(1), points (a) to (h), Art 15(2) and Art 15(3).
- `access_answer_items_missing(Profile, Result, Basis, Citations)`: the owed items not in `items_provided`, or `no_item_missing`, computed by completion over the absent keys among P, R, C, S, T, A and G. Otherwise it names the first absent key that matters, or refers the first absent outside fact that matters. Cites Art 15(1) to (3).
- `copy_scope(Profile, Result, Citations)`: one of `no_personal_data_to_copy`, `full_copy` or `copy_limited_by_rights_and_freedoms_of_others`, or a status compound. A J value of `unsure` gives `needs_legal_review(open_textured(copy_would_adversely_affect_rights_and_freedoms_of_others, cite(eu_reg_2016_679_art_15_4)), [inputs_relied_on([copy_would_adversely_affect_rights_and_freedoms_of_others-unsure])])`. Cites Art 15(3), first sentence, and Art 15(4).
- `copy_fee(Profile, Result, Citations)`: one of `no_personal_data_to_copy`, `no_fee_under_article_15_3` or `reasonable_fee_permitted`, or a status compound. Cites Art 15(3), second sentence.
- `information_form(Profile, Result, Citations)`: one of `no_electronic_request`, `other_form_requested` or `commonly_used_electronic_form`, or a status compound. Cites Art 15(3), third sentence.
- `gdpr_art15_access_copy_input_problems(Profile, Problems)`: THE INPUT CHECK. It reports, in this order:
  - `duplicate_key(Key)` or `wrong_type(Key)` per contract key, in contract order;
  - `unknown_key(Key)` per non-contract key, by first occurrence;
  - `[wrong_type(profile)]` alone for a non-attribute-list profile.

  It never fails and never raises. No citation.
- `decide_gdpr_art15_access_copy(Profile, gdpr_art15_access_copy_verdict(Status, Citations))`: eligibility verdict #2. Status is mapped as in section 2. Citations are those of `access_answer_items_missing`. Cites Art 15(1) to (3).
- `gdpr_art15_access_copy_status(Profile, Status)`: Status only, from the same mapping.
- `gdpr_art15_access_copy_checklist(Profile, Checklist)`: the cited checklist `assessment(Profile, Decision, Items)` from `formalize_lib:assess/6`, over the twelve item ids, with `requirement/4` injected. Each item is `item(ItemAtom, Status, cite(Key))`, where Status is one of:
  - `met`: owed and provided;
  - `unmet(item_not_provided)`;
  - `inapplicable`: not owed;
  - `unknown([Key])`: undecided. This is checklist vocabulary only and is never MISSING_KEYS.

  A consistency property asserts that the checklist agrees with `access_answer_items_missing`.
- `gdpr_art15_access_copy_what_if(Profile, Key, Value, Status)`: Status after overriding Key with Value. It uses `formalize_lib:profile_set(Profile, attribute(Key, Value), Overridden)`, then `gdpr_art15_access_copy_status/2`.
- `gdpr_art15_access_copy_compliance(Profile, Action, Result, Citations)`: compliance check #13. It asks whether a proposed controller action is allowed in the current state. It is derived from the five queries, with a status compound passed through unchanged. The closed set of actions is:
  - `omit_item(Item)`: `action_not_permitted` if Item is owed, else `action_permitted`. Cites the item's key.
  - `refuse_copy`: `action_not_permitted` if P is true; `action_not_applicable` if P is false. Cites Art 15(3).
  - `provide_full_copy`:
    - `full_copy` gives `action_permitted`;
    - `copy_limited...` gives `action_not_permitted` (cites Art 15(3) and 15(4));
    - `no_personal_data_to_copy` gives `action_not_applicable`.
  - `provide_limited_copy`:
    - `copy_limited...` gives `action_permitted`;
    - `full_copy` gives `action_not_permitted`;
    - no data gives `action_not_applicable`.
  - `charge_fee_for_copy`:
    - `reasonable_fee_permitted` gives `action_permitted`;
    - `no_fee_under_article_15_3` gives `action_not_permitted_under_article_15` (Art 12(5) is deferred);
    - no data gives `action_not_applicable`.
  - `provide_answer_in_other_form`:
    - `commonly_used_electronic_form` gives `action_not_permitted`;
    - `other_form_requested` or `no_electronic_request` gives `action_permitted`.
- `gdpr_art15_access_copy_deadline(Profile, Result, Citations)`: deadline #15. The input check comes first. Otherwise Result is `deadline_decided_by_sibling_order(gdpr_data_subject_rights_response_period)` and Citations is `[]`. Art 15 sets no time limit. Art 12(3) is deferred, so no date is computed and no consequence is invented.
- `gdpr_art15_access_copy_fixture(Name, Profile)`: named test profiles (section 8).

The result constructors listed in the contract are exported and are never called as queries:

- `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `resolution/2`, `inputs_relied_on/1`
- `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`
- `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`

## 6 Determination slices

### 6.0 kernel.clausal (shared floor)

This domain has ONE determination slice. No domain predicate MUST be shared between slices.

The kernel keeps only the domain-independent floor that every query reads first:

- `gdpr_art15_access_copy_attribute_list/1`: a proper list of ground-functor `attribute(_, _)` elements. Unbound, partial and non-attribute lists fail.
- `gdpr_art15_access_copy_key_occurrences/3`: counts occurrences of a key without reading any values.

No value facts live in the kernel.

### 6.1 gdpr_art15_access_copy.clausal (self-contained)

**Statutory VALUE facts owned here.** There are no numeric values. The tables below are this slice's own facts.

- `gdpr_art15_access_copy_item(Ordinal, ItemAtom, CitationKey)` holds twelve rows, in the contract item order:

  | Ordinal | ItemAtom | CitationKey |
  |---|---|---|
  | 1 | `confirmation_of_processing` | `eu_reg_2016_679_art_15_1` |
  | 2 | `access_to_personal_data` | `eu_reg_2016_679_art_15_1` |
  | 3 | `purposes_of_processing` | `_1_a` |
  | 4 | `categories_of_personal_data` | `_1_b` |
  | 5 | `recipients_or_categories_of_recipients` | `_1_c` |
  | 6 | `storage_period_or_criteria` | `_1_d` |
  | 7 | `rights_to_rectification_erasure_restriction_and_objection` | `_1_e` |
  | 8 | `right_to_lodge_complaint` | `_1_f` |
  | 9 | `source_of_personal_data` | `_1_g` |
  | 10 | `automated_decision_making_information` | `_1_h` |
  | 11 | `transfer_safeguards_information` | `eu_reg_2016_679_art_15_2` |
  | 12 | `copy_of_personal_data` | `eu_reg_2016_679_art_15_3` |

- `gdpr_art15_access_copy_outside_fact(Key, CitationKey, Target)` holds two rows:
  - (`automated_decision_making_referred_to_in_article_22`, `eu_reg_2016_679_art_15_1_h`, `article_22_automated_decision_making_statement`)
  - (`transfer_subject_to_article_46_safeguards`, `eu_reg_2016_679_art_15_2`, `article_46_safeguards_statement`)
- `gdpr_art15_access_copy_contract_key(Ordinal, Key, Type)` holds twelve rows. Type is one of `item_list`, `boolean`, `attested_boolean` or `judgement`.

**Rules and requirements (defeasible, cut-free).**

1. Strict rules: item 1 is owed always. Items 2, 3, 4, 6, 7, 8 and 12 are owed if P is true.
2. Defeasible rules: each of items 5, 9, 10 and 11 is owed if P is true, unless a defeater fires. The defeater is checked through `formalize_lib:not_defeated(RuleId, Profile, gdpr_art15_access_copy_defeater)`, and the defeater goal is wrapped in `once/1`. The defeaters are:
   - item 5: R is false;
   - item 9: S is false, or C is false;
   - item 10: A is attested false;
   - item 11: G is attested false, or T is false.
3. Copy: Art 15(3) gives `full_copy` by default. The Art 15(4) defeater (J true) turns it into `copy_limited_by_rights_and_freedoms_of_others`. J unsure gives the open_textured referral; the domain hands this to the user and never applies a crisp test.
4. Fee: F true gives `reasonable_fee_permitted`. F false gives `no_fee_under_article_15_3`.
5. Form: E false gives `no_electronic_request`. E true and O false gives `commonly_used_electronic_form`. E true and O true gives `other_form_requested`.
6. Limb steps follow INTERFACE - THE LIMBS exactly. There is one clause per disjoint route, with the ground RESULT folded into the head (C17). Routes:
   - `access_answer_items`:
     1. P absent;
     2. P false;
     3. first absent of [R, C (unless S false), S (when C true), T (unless G attested false)];
     4. A absent: the absent referral on A;
     5. T true and G absent: the absent referral on G;
     6. OWED, with BASIS = A's term, then G's term if present.
   - `access_answer_items_missing`:
     1. I absent;
     2. all completions agree. BASIS holds A's term if A is present and item 10 is not in I, then G's term if G is present and item 11 is not in I;
     3. first absent key that matters in [P, R, C, S, T];
     4. first absent outside fact that matters in [A, G].

     Local helpers:
     - `gdpr_art15_access_copy_completion/2`: enumerates values for the absent keys only;
     - `gdpr_art15_access_copy_missing_for/3`;
     - `gdpr_art15_access_copy_key_matters/2`: two completions differing only in the key give different MISSING. Implemented with `findall/3` and `sort/2`, so it is deterministic.
7. Item citations: `sort/2` over `cite(Key)` of the result items. Items 1 and 2 share a key.

**Verdict atoms owned.** The result atoms of section 2. The facade STATUS atoms are mapped in `queries.clausal`.

**Shared with another slice.** None.

### 6.2 citations.clausal / parameters.clausal / queries.clausal / fixtures.clausal / facade

- `citations.clausal` holds the twelve citation keys and the two referral targets of section 4.
- `parameters.clausal` is intentionally empty of constants (there is no figure). A comment states why.
- `queries.clausal` holds the facade, the compliance predicate, the deadline predicate, the checklist (`assess/6`) and what_if.
- `fixtures.clausal` holds the named profiles of section 8.
- The package facade re-exports every public predicate and every root atom.

## 7 Planned reuse (manifest `uses:`)

- `formalize_lib`: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `memberd/2`, `not_member/2`, `not_defeated/3`, `assess/6`, `decide_labeled/3`, `item/3`, `unmet/1`, `unknown/1`, `labels/3`, `assessment/3`, `attribute/2`.
- `kit.compliance_lib`:
  - `nm/2` declares the modality of each Art 15 norm (obligation for the items and the copy; permission for the further-copy fee);
  - `resolve_modality/3` resolves deny-overrides inside `gdpr_art15_access_copy_compliance/4`.
- `validate_props`, for the seven test modes: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_consistency/4` (checklist against missing query), `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `bad_citation/1`.
- Not used, and why:
  - `kit.deadline_lib`: the response period is deferred (Art 12(3));
  - `date_time`: there are no dates;
  - `currency_vocab` and `vat_category`: the fee amount is not tested;
  - `country`: no country is read;
  - rolling_window kits: not this shape.
- `_common` deontic backbone: none beyond `formalize_lib`. The local completion search is flagged in the working notes (not published) as a candidate kit module.

## 8 Fixtures and test plan (seven modes)

Fixtures (`gdpr_art15_access_copy_fixture/2`):

- `no_personal_data`: P false. Owes `[confirmation_of_processing]`.
- `full_answer_all_conditions_true`: every key true, with A and G attested true. Owes all twelve items.
- `minimal_processing`: P true; R, C and T false; S false; A attested false. Owes items 1, 2, 3, 4, 6, 7, 8 and 12.
- `source_settled_by_no_information`: S false, C absent. No key is named for C.
- `article_46_absent_referral`: T true, G absent. Gives the absent referral on G.
- `copy_unsure`: J unsure. Gives the open_textured referral.
- `further_copy_electronic`: F true, E true, O false.
- `items_all_given`: every owed item is in I. Gives `no_item_missing`.
- `duplicate_and_unknown_keys`: gives input problems.

Test modes:

1. unit tests per limb;
2. exactly-one-solution counting, using `findall` + `length`;
3. input-check robustness (unbound, partial, non-atom keys);
4. irrelevant-key invariance;
5. citation completeness;
6. checklist/missing consistency;
7. negative tests, each paired with a positive test on the same fixture.
