# SIGNATURE — eu/eprivacy_breach_traffic_location_marketing

## Public query surface

The package exposes six groups of predicates:

- the five contract queries, under the exact names of THE INTERFACE (unprefixed, because the contract names govern);
- the input check;
- the scaffold facade;
- the checklist;
- what-if;
- the fixtures.

Every query is total and deterministic. Every term PROFILE yields exactly one solution, and no answer is yielded twice. The domain has no statutory figures, periods or dates (reading 4). Nothing is imported from another domain or re-declared.

**Cut-free.** No `!`, `->` or `*->` is used. Ground verdicts are folded into the clause heads, one clause per disjoint route (C17).

**Defeasible logic.** It is written with guarded `once/1` defeaters through formalize_lib `not_defeated/3`:

- the protection exemption defeats the individual notification, and the authority's requirement overrides that defeater;
- the customer exception is an exception to Art 13(1);
- anonymisation is a separate way that consent conditions cannot defeat.

**Open-textured judgements** are handed to the user as tri-state keys. No crisp test is invented.

## Verdict STATUS atoms (replacing `{ required, permitted, not_applicable }`)

| Query | Final RESULT atoms |
|---|---|
| (A) breach | `authority_and_individual_notification_due`, `authority_notification_due`, `not_applicable` |
| (B) traffic | `permitted`, `not_permitted`, `not_applicable` |
| (C) location | `permitted`, `not_permitted`, `not_applicable` |
| (D) direct marketing communication | `sending_permitted`, `sending_not_permitted`, `national_law_decides`, `not_applicable` |
| (E) email practice | `practice_prohibited`, `practice_not_prohibited`, `not_applicable` |
| facade eligibility (query type #2) | `eligible`, `ineligible`, `national_law_decides`, `not_applicable` |

Every query and the facade can also give a non-final status. It is exactly one of:

- `indeterminate([KEY])` (never the bare atom);
- `needs_legal_review(open_textured(KEY, CITATION), [inputs_relied_on(PAIRS)])`;
- `input_problems(PROBLEMS)`.

PROBLEMS are built from `duplicate_key(KEY)`, `wrong_type(KEY)`, `unknown_key(KEY)` and `wrong_type(profile)`. Every non-final status carries CITATIONS [].

**Result constructors.** These are exported and never called as queries: `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `inputs_relied_on/1`, `provenance/2`. Provenance is never emitted.

The atoms `true` and `false` are never pinned in verdict_vocabulary or root_exports.

## Profile keys

The PROFILE is `[attribute(Key, Value), ...]`, read only with formalize_lib `profile_get/3`, by presence first and then by value. Keys are bare atoms.

The key types are:

- **judgement:** `true`, `false` or `unsure`;
- **boolean:** `true` or `false`;
- **enumeration:** one of four atoms.

There are no numeric keys and no date keys. The order computes no deadline, so no `_eur_cents` keys and no `date(Year, Month, Day)` terms exist. Values are bare. An `attested(...)` value is `wrong_type(KEY)`.

The thirty-five keys, in root_exports / input_contract order:

1. `breach_provider_of_publicly_available_service` — judgement — A
2. `personal_data_breach_occurred` — judgement — A
3. `authority_required_individual_notification` — boolean — A
4. `breach_likely_to_adversely_affect_subscriber_or_individual` — judgement — A
5. `protection_measures_demonstrated_to_authority` — boolean — A
6. `traffic_provider_of_public_network_or_service` — judgement — B
7. `traffic_data_relating_to_subscribers_or_users` — judgement — B
8. `traffic_processing_purpose` — enumeration {`transmission_of_communication`, `subscriber_billing_or_interconnection_payments`, `marketing_or_value_added_service`, `other_purpose`} — B
9. `traffic_data_still_needed_for_transmission` — judgement — B
10. `traffic_data_necessary_for_billing_or_interconnection` — judgement — B
11. `traffic_billing_challenge_or_payment_period_running` — judgement — B
12. `traffic_marketing_provider_of_publicly_available_service` — judgement — B
13. `traffic_marketing_prior_consent_given` — judgement — B
14. `traffic_marketing_consent_withdrawn` — boolean — B
15. `traffic_marketing_processing_within_necessary_extent_and_duration` — judgement — B
16. `location_data_other_than_traffic_data_in_scope` — judgement — C
17. `location_data_made_anonymous` — judgement — C
18. `location_consent_given` — judgement — C
19. `location_consent_withdrawn` — boolean — C
20. `location_processing_within_necessary_extent_and_duration_for_value_added_service` — judgement — C
21. `location_processing_temporarily_refused` — boolean — C
22. `marketing_communication_for_direct_marketing` — judgement — D, E
23. `marketing_subscriber_is_natural_person` — boolean — D
24. `marketing_communication_means` — enumeration {`automatic_calling_machine`, `fax`, `electronic_mail`, `other_means`} — D, E
25. `marketing_prior_consent_given` — judgement — D
26. `marketing_contact_details_obtained_from_customer_in_sale` — judgement — D
27. `marketing_sender_obtained_the_contact_details` — boolean — D
28. `marketing_own_similar_products_or_services` — judgement — D
29. `marketing_objection_offered_at_collection` — judgement — D
30. `marketing_objection_offered_in_each_message` — judgement — D
31. `marketing_customer_refused_or_objected` — boolean — D
32. `email_sender_identity_disguised_or_concealed` — judgement — E
33. `email_contravenes_electronic_commerce_directive_article_6` — judgement — E
34. `email_valid_cessation_address_provided` — judgement — E
35. `email_encourages_visiting_contravening_websites` — judgement — E

## Citation-key atoms

These follow the canonical lexicon scheme (`_lexicon/citations.yaml`) and are listed in citations.clausal as citation_vocabulary. They are always written as `cite(KEY)` and never shortened.

- `eu_dir_2002_58_art_2_b`
- `eu_dir_2002_58_art_2_c`
- `eu_dir_2002_58_art_2_f`
- `eu_dir_2002_58_art_2_g`
- `eu_dir_2002_58_art_2_h`
- `eu_dir_2002_58_art_2_i`
- `eu_dir_2002_58_art_4_3`
- `eu_dir_2002_58_art_6_1`
- `eu_dir_2002_58_art_6_2`
- `eu_dir_2002_58_art_6_3`
- `eu_dir_2002_58_art_9_1`
- `eu_dir_2002_58_art_9_2`
- `eu_dir_2002_58_art_13_1`
- `eu_dir_2002_58_art_13_2`
- `eu_dir_2002_58_art_13_3`
- `eu_dir_2002_58_art_13_4`
- `eu_dir_2002_58_art_13_5`

The last three Art 2 keys and Art 9(2) are vocabulary-only. They are never a final citation: Art 2(g) and 2(h) are read inside judgements and enumerations, and Art 9(2) is carried by Art 9(1) (reading 15).

## Public predicates

The five contract queries:

- `personal_data_breach_notification_status(Profile, Result, Citations)`: Art 4(3) notifications due, limbs A.1 to A.3. Every final answer cites [cite(eu_dir_2002_58_art_4_3)].
- `traffic_data_processing_status(Profile, Result, Citations)`: Art 6(1) to (3) permission, limbs B.1 to B.5. `permitted` cites [6_1, 6_2, 6_3]; `not_permitted` and `not_applicable` cite [6_1].
- `location_data_processing_status(Profile, Result, Citations)`: Art 9(1), (2) permission, limbs C.1 to C.4. Every final answer cites [cite(eu_dir_2002_58_art_9_1)].
- `direct_marketing_communication_status(Profile, Result, Citations)`: Art 13(1), (2), (3), (5), limbs D.1 to D.6. The citations are:
  - `not_applicable`: [13_1];
  - `national_law_decides`: [13_3, 13_5];
  - `sending_permitted` and `sending_not_permitted`: [13_1, 13_2].
- `direct_marketing_email_practice_status(Profile, Result, Citations)`: Art 13(4), limbs E.1 to E.3. Every final answer cites [cite(eu_dir_2002_58_art_13_4)].

The input check:

- `eprivacy_breach_traffic_location_marketing_input_problems(Profile, Problems)`: typed check against input_contract, one solution, never fails or raises. Cites the contract (no article).

The scaffold facade:

- `decide_eprivacy_breach_traffic_location_marketing(Profile, eprivacy_breach_traffic_location_marketing_verdict(Status, Citations))`: the facade eligibility verdict for the one communication. It asks queries D and E and applies the the working notes (not published) facade decision. Cites Art 13(1) to (5) as stated there.
- `eprivacy_breach_traffic_location_marketing_status(Profile, Status)`: the Status of the facade verdict. Same citations.
- `eprivacy_breach_traffic_location_marketing_checklist(Profile, Checklist)`: five formalize_lib `item(Determination, Result, Citations)` rows, in this order: `personal_data_breach_notification`, `traffic_data_processing`, `location_data_processing`, `direct_marketing_communication`, `direct_marketing_email_practice`. Each row carries its query's citations.
- `eprivacy_breach_traffic_location_marketing_what_if(Profile, Key, Value, Status)`: replaces or adds `attribute(Key, Value)` with formalize_lib `profile_set/3`, then gives the facade Status. Same citations.

The fixtures:

- `eprivacy_breach_traffic_location_marketing_fixture(Name, Profile)` and `eprivacy_breach_traffic_location_marketing_fixture_expected(Name, Query, Result, Citations)`: named profiles covering every limb, every settled, indeterminate and referral route, and the input-problem forms.

## Planned reuse (manifest `uses:`)

**formalize_lib**:

- `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`
- `not_defeated/3`
- `memberd/2`, `not_member/2`
- `attribute/2`, `item/3`

**kit/query_combinators**: `what_if/5`, but only if it overrides attribute lists. Otherwise `profile_set/3` alone; decided in the facade phase.

**validate_props** (tests only):

- `run_props/1`
- `prop_totality/3`, `prop_determinism/3`
- `prop_citation_complete/3`
- `prop_missing_key_coverage/3`
- `bad_citation/1`

Not used:

- **kit/deadline_lib, date_time:** no clock (reading 4).
- **kit/compliance_lib:** its combining-world lattice would add a rule beyond the fixed limbs.
- **assess/6:** the five determinations are not met/unmet requirements of one subject. The checklist uses `item/3` rows instead.
- **Currency, VAT and country vocabularies:** not relevant.

## Layers

- **kernel.clausal:** the generic completion engine. It works over a decision-ordered key list with typed domains and a closure `Outcome(CompleteValues, Answer)`. It provides `settled_answer`, `key_matters`, `key_behind`, `first_missing_key`, `first_unsure_referral` and `inputs_relied_on` pairs. It also holds the generic cut-free input-check walker. The walker is driven by a key-type table and uses mutually exclusive var/nonvar guards for unbound and partial lists. Domain-independent; noted as a kit candidate.
- **citations.clausal:** the 17 citation_vocabulary facts.
- **parameters.clausal:** holds no statutory figure. A comment records reading 4.
- **queries.clausal:** the five contract predicates and the input check. They delegate to the slice.
- **fixtures.clausal:** the fixtures.
- **Package facade:** the facade predicates.

## Slice: eprivacy_breach_traffic_location_marketing.clausal

**Value facts owned.** There are no thresholds, periods or tables of numbers. The slice owns these facts:

- `key_type(Key, Type)` for the 35 keys, with Type `judgement`, `boolean` or `enumeration(Atoms)`. This is the input_contract order.
- `query_decision_order(Query, Keys)` for the five queries, exactly as THE LIMBS list them.
- `final_citations(Query, Result, Citations)`, which fixes the citations of every final RESULT.
- `referral_citation(Query, Key, Citation)`, as listed in THE LIMBS.

The referral citations by query:

- **A:** provider → 4_3; breach → 2_i; likely adverse effect → 4_3.
- **B:**
  - provider → 6_1; traffic data → 2_b; still needed → 6_1;
  - necessary for billing → 6_2; period running → 6_2;
  - marketing provider → 6_3; consent → 2_f; necessary extent → 6_3.
- **C:** scope → 2_c; anonymous → 9_1; consent → 2_f; necessary extent → 9_1.
- **D:**
  - direct marketing → 13_1; consent → 2_f;
  - obtained in sale, similar products, objection at collection, objection in each message → 13_2.
- **E:** every judgement → 13_4.

**Rules: outcome on a complete profile.** One clause per disjoint limb, with the answer folded into the head.

- **A.1:** provider false or breach false → `not_applicable`.
- **A.2:** otherwise the authority required notification (a defeater-override), or a likely adverse effect where the defeater `protection_measures_demonstrated_to_authority` is not true (guarded `once/1` via `not_defeated/3`) → `authority_and_individual_notification_due`.
- **A.3:** otherwise → `authority_notification_due`.
- **B.1:** provider false or traffic data false → `not_applicable`.
- **B.2:** transmission and still needed → `permitted`.
- **B.3:** billing, necessary and period running → `permitted`.
- **B.4:** marketing, marketing provider, consent, not withdrawn and within extent → `permitted`.
- **B.5:** otherwise → `not_permitted`.
- **C.1:** scope false → `not_applicable`.
- **C.2:** anonymous → `permitted`.
- **C.3:** consent, not withdrawn, within extent, not refused → `permitted`.
- **C.4:** otherwise → `not_permitted`.
- **D.1:** not direct marketing → `not_applicable`.
- **D.2:** `other_means` → `national_law_decides`.
- **D.3:** not a natural person → `national_law_decides`.
- **D.4:** consent → `sending_permitted`.
- **D.5:** electronic mail and all six customer-exception keys (refused or objected false) → `sending_permitted`.
- **D.6:** otherwise → `sending_not_permitted`.
- **E.1:** not direct marketing, or means not `electronic_mail` → `not_applicable`.
- **E.2:** disguised, contravenes, no valid address, or encourages → `practice_prohibited`.
- **E.3:** otherwise → `practice_not_prohibited`.

The guards are written as mutually exclusive positive tests, so each complete profile yields exactly one outcome.

**Rules: statuses for any profile.** Each query applies these steps through the kernel engine:

1. The input check.
2. Settled: every completion gives one answer, compared by `findall` plus `sort`.
3. The first absent key, in decision order, that matters and is not behind another absent key → `indeterminate([KEY])`.
4. Otherwise the first unsure judgement that matters → `needs_legal_review(open_textured(KEY, CITATION), [inputs_relied_on(PAIRS)])`. PAIRS are the Key-Value pairs of every present key of the query, in decision order.

The completion spaces are small: at most 2^9 × 4 = 2048 completions per query.

**Verdict atoms** are those of queries A to E above. The slice also owns the facade composition rule, which is kept in the package facade but specified in the working notes (not published).

**Shared predicates (kernel only).** The completion engine and the input-check walker are domain-independent. With a single slice nothing else is shared. Key types, decision orders and citations stay in the slice.

## Tests (per rule; v2 manifest, seven test modes)

The tests cover:

- every limb, positive and negative over the same profile;
- every settled route, e.g. data made anonymous with consent unsure gives `permitted`;
- every indeterminate route, including BEHIND cases (e.g. the billing keys are not named when the purpose is absent);
- every referral key;
- input check cases:
  - duplicate keys with equal and unequal values;
  - `attested(...)` values;
  - `unsure` given for a boolean;
  - a non-atom key;
  - an unbound value;
  - an unbound profile;
  - a partial list;
  - a non-attribute element;
- counting: `findall` length 1 for every query and fixture;
- citation completeness against citation_vocabulary;
- facade, checklist and what-if.
