# SIGNATURE — eu/data_protection/gdpr_administrative_fine_maximum

## Public query surface

The called contract is `administrative_fine_maximum(PROFILE, VERDICT, CITES)`. It gives exactly one solution per profile; the COUNTING rule applies, so a duplicated answer is a refutation.

The scaffold facade wraps it:

- `decide_gdpr_administrative_fine_maximum(PROFILE, gdpr_administrative_fine_maximum_verdict(STATUS, CITATIONS))`
- `gdpr_administrative_fine_maximum_status(PROFILE, STATUS)`

Totality and determinism claims:

- Every term PROFILE gets exactly one verdict, including non-lists, which give `input_problems([wrong_type(profile)])`.
- No public predicate yields a float.
- Caps are integers compared by value.
- Statutory figures are declared once with `constant_value/2` inside the slice file, never re-declared or inlined.

## Verdict STATUS atoms (replace the placeholders `within_limit` / `exceeds_limit`)

| VERDICT term | STATUS atom |
|---|---|
| `fine_maximum/3` | `fine_maximum_determined` |
| `separate_fine_maxima/1` | `separate_fine_maxima_determined` |
| `indeterminate/1` | `required_input_missing` |
| `needs_legal_review/2` | `referred_for_legal_review` |
| `input_problems/1` | `input_rejected` |

The bare atom `indeterminate` is never written as a status. The reserved atom `unknown` is never used.

## Other vocabulary (verdict_vocabulary)

- **TIER:** `lower_maximum_tier`, `higher_maximum_tier`.
- **BASIS:** `fixed_amount`, `percentage_of_turnover`, `fixed_amount_for_non_undertaking`.
- **Judgement values:** `true`, `false`, `unsure`. `true` and `false` are NEVER pinned in verdict_vocabulary or root_exports.
- **Result constructors** (exported, never called as queries):
  - `fine_maximum/3`, `separate_fine_maxima/1`, `infringement_maximum/4`
  - `indeterminate/1`, `needs_legal_review/2`, `not_governed_here/1`, `input_problems/1`
  - `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`
  - `open_textured/2`, `inputs_relied_on/1`

## Profile keys (exactly five, in root_exports / input_contract order)

1. `infringed_provisions`. CRISP: a non-empty list of bare atoms. Closed vocabulary below; any other atom gives not_governed_here.
2. `infringer_is_undertaking`. JUDGEMENT: `true`, `false` or `unsure`. Art 83(4)-(6), economic unit of competition law.
3. `total_worldwide_annual_turnover_in_euros`.
   - CRISP: a non-negative integer of WHOLE euros (the unit suffix is fixed by the contract).
   - It is the economic unit's figure for the preceding business year.
   - Read only when `infringer_is_undertaking` is not false.
4. `infringements_concern_same_or_linked_processing_operations`. JUDGEMENT tri-state, Art 83(3). Read only when |P| >= 2.
5. `infringements_intentional_or_negligent`. JUDGEMENT tri-state, Art 83(3). Read only when |P| >= 2.

Read ONLY via `profile_get/3`, presence first and then value. Keys are bare atoms. No dates in this order.

### Closed vocabulary of provision atoms, in closed-vocabulary order (rank 1..N)

**Lower tier:**

| Atom(s) | Point citation(s) |
|---|---|
| `article_8`, `article_11` | 83(4)(a) |
| `article_25` .. `article_39` (each spelled out) | 83(4)(a) |
| `article_42`, `article_43` | 83(4)(a) and 83(4)(b) |
| `article_41_paragraph_4` | 83(4)(c) |

**Higher tier:**

| Atom(s) | Point citation(s) |
|---|---|
| `article_5`, `article_6`, `article_7`, `article_9` | 83(5)(a) |
| `article_12` .. `article_22` | 83(5)(b) |
| `article_44` .. `article_49` | 83(5)(c) |
| `member_state_law_adopted_under_chapter_ix` | 83(5)(d) |
| `non_compliance_with_supervisory_authority_order` | 83(5)(e); also triggers paragraph cite 83(6) |
| `failure_to_provide_access_to_supervisory_authority` | 83(5)(e) |

Rank follows the order in which the contract's CLOSED VOCABULARY first lists each atom. `article_42` and `article_43` rank once, at their 83(4)(a) position.

## Citation-key atoms (fixed by the contract; never shortened or renamed)

**Load-bearing (may appear in CITES):**

- `eu_reg_2016_679_art_83_3`
- `eu_reg_2016_679_art_83_4`, `eu_reg_2016_679_art_83_4_a`, `eu_reg_2016_679_art_83_4_b`, `eu_reg_2016_679_art_83_4_c`
- `eu_reg_2016_679_art_83_5`, `eu_reg_2016_679_art_83_5_a`, `eu_reg_2016_679_art_83_5_b`, `eu_reg_2016_679_art_83_5_c`, `eu_reg_2016_679_art_83_5_d`, `eu_reg_2016_679_art_83_5_e`
- `eu_reg_2016_679_art_83_6`

**Documentary only** (in citations.clausal, NEVER in CITES): `eu_reg_2016_679_art_83_7`, `eu_reg_2016_679_art_4_18`, `eu_reg_2016_679_art_4_19`.

If C6 flags the segments `reg` / `art`, suppress it with a `% lint:` pragma naming the contract. Do NOT rename these atoms.

Canonical citation rank, used to order CITES:

1. `art_83_4`
2. `art_83_5`
3. `art_83_6`
4. `art_83_4_a`
5. `art_83_4_b`
6. `art_83_4_c`
7. `art_83_5_a`
8. `art_83_5_b`
9. `art_83_5_c`
10. `art_83_5_d`
11. `art_83_5_e`
12. `art_83_3`, last and only in MODE combined.

## Public predicates

- **`administrative_fine_maximum(Profile, Verdict, Citations)`.** The called contract: steps (0)-(5) of THE LIMBS, with exactly one solution. Art 83(3), (4), (5), (6).
- **`gdpr_administrative_fine_maximum_input_problems(Profile, Problems)`.** The typed input check, exactly one solution. Problems is `[]` or an ordered list of `duplicate_key/1`, `wrong_type/1` and `unknown_key/1` terms. Cites: input contract (no article).
- **`decide_gdpr_administrative_fine_maximum(Profile, Verdict)`.** Verdict is `gdpr_administrative_fine_maximum_verdict(Status, Citations)`; Status is mapped from the contract verdict and Citations is the contract CITES. Art 83(3)-(6).
- **`gdpr_administrative_fine_maximum_status(Profile, Status)`.** One of the five STATUS atoms. Art 83(3)-(6).
- **`gdpr_administrative_fine_maximum_cap_in_euro_cents(Profile, CapInEuroCents)`** (query type #23, calculation).
  - It gives the integer cap when the verdict is `fine_maximum/3`.
  - It has NO solution otherwise. For separate maxima, use the verdict.
  - Art 83(4)-(6), and 83(3) in combined mode.
- **`gdpr_administrative_fine_maximum_tier_cap(Tier, InfringerIsUndertaking, TurnoverInEuros, Basis, CapInEuroCents)`** (query type #23, pure arithmetic).
  - InfringerIsUndertaking is `true` or `false`.
  - When it is false, TurnoverInEuros is not read.
  - The tie goes to `fixed_amount`.
  - Art 83(4) or 83(5)/(6).
- **`gdpr_administrative_fine_maximum_checklist(Profile, Checklist)`** (query type #7, justification).
  - A list of `item(RequirementId, Status, cite(Key))`. Every item carries a cite, met items included.
  - It is built with `eval_requirements/4` over the slice's `requirement/4` closure.
  - It is `[]` when the input check reports problems.
  - Exactly one solution.
- **`gdpr_administrative_fine_maximum_what_if(Profile, Key, Value, Verdict)`.** Replaces or adds `attribute(Key, Value)` and returns the contract verdict.
  - Uses `profile_set/3`. Phase P2 must confirm it REPLACES an existing key; if it appends, a duplicate_key would result, so write a local replace.
  - Exactly one solution.
- **`gdpr_administrative_fine_maximum_fixture(Name, Profile)`** and **`gdpr_administrative_fine_maximum_fixture_expected(Name, Verdict, Citations)`.** Named fixtures with their expected contract answers.

## Planned reuse (manifest `uses:`)

From `formalize_lib`:

- Profile access: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `profile_keys/2`.
- Collection helpers: `memberd/2`, `not_member/2`, `eval_requirements/4`, `item/3`, `unknown/1`, `unmet/1`, `attribute/2`.
- `check_tri/4`, only if phase P2 confirms it maps `unsure` to `unknown`. Otherwise write a local three-clause check, which C15 tolerates for a distinct semantics; note it.

From `validate_props`, in tests: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_boundary_coverage/2`, `prop_missing_key_coverage/3`.

`ratio_bps/4` is NOT used: the percentage is exact (T x RATE cents), not a ratio. `int_max/3` is NOT used, because the basis label is needed. No `_common` family-backbone predicate applies. currency_vocab is not needed, since the unit is fixed as euros by the key name.

## Layout notes

- **kernel.clausal:** no domain predicate needs sharing, because there is one slice. The kernel stays the empty shared floor and only re-exports the module header conventions.
- **parameters.clausal:** carries NO statutory figure (the figures live in the slice). It holds only the pinned source metadata: version 02016R0679-20160504, in force 2016-05-04.
- **queries.clausal:** imports the slice and defines the facade, status, checklist, what_if and cap predicates.
- **fixtures.clausal:** imports nothing but the constructors.

---

## Slice: gdpr_administrative_fine_maximum.clausal

### Value facts owned (declared once, here)

```
:- constant_value(lower_maximum_tier_fixed_amount_in_euro_cents, 1000000000).   % Art 83(4): EUR 10000000
:- constant_value(lower_maximum_tier_turnover_percentage, 2).                    % Art 83(4): 2 %
:- constant_value(higher_maximum_tier_fixed_amount_in_euro_cents, 2000000000).  % Art 83(5),(6): EUR 20000000
:- constant_value(higher_maximum_tier_turnover_percentage, 4).                   % Art 83(5),(6): 4 %
```

PERCENTAGE in cents = TurnoverInEuros x percentage. This is exact, because P % of T euros is T x P cents.

Tables, one row per key so that lookups are deterministic:

- `provision_tier(ProvisionAtom, Tier)` — one row per vocabulary atom.
- `provision_rank(ProvisionAtom, Rank)` — closed-vocabulary order.
- `provision_point(ProvisionAtom, CitationKey)` — two rows for `article_42` and `article_43`. Read ONLY inside findall.
- `citation_rank(CitationKey, Rank)` — the canonical order above.
- `tier_paragraph(lower_maximum_tier, eu_reg_2016_679_art_83_4)` and `tier_paragraph(higher_maximum_tier, eu_reg_2016_679_art_83_5)`.
- `contract_key(Key, Rank)` — the five keys in root_exports order.

### Rules / requirements, in step order (first applicable decides; guards make the routes mutually exclusive)

**R0 input check.** `gdpr_administrative_fine_maximum_input_problems/2`. A non-empty result gives `input_problems(Problems)` and `[]`.

The profile must be a proper list of `attribute(Key, Value)` with atom Key; otherwise the result is `[wrong_type(profile)]`.

Then, for each contract key in order:

- occurrences > 1 gives `duplicate_key(K)`, and the values are not read;
- exactly one occurrence with a bad type gives `wrong_type(K)`.

Then `unknown_key(K)` once per distinct non-contract key, in first-occurrence order.

Types:

- provisions: a non-empty proper list, each item `atom/1` and not `[]`;
- judgements: one of `true`, `false`, `unsure`;
- turnover: `integer/1` and >= 0.

**R1 missing keys** gives `indeterminate(MissingKeys)` and `[]`. It names EVERY needed absent key, in contract order:

- `infringed_provisions`, if absent;
- `infringer_is_undertaking`, if absent;
- the turnover, if absent and the undertaking key is not present-false;
- each Art 83(3) key that is absent, only when provisions are present, |P| >= 2 (P = `sort/2` of the list) and no Art 83(3) key is present-false.

A malformed value never reaches this step.

**R2 unlisted provision.** Some member of P has no `provision_tier` row. The verdict is `needs_legal_review(not_governed_here([cite(eu_reg_2016_679_art_83_4), cite(eu_reg_2016_679_art_83_5), cite(eu_reg_2016_679_art_83_6)]), [inputs_relied_on([infringed_provisions-List])])` with CITES `[]`. List is the value exactly as given.

**R3 mode:**

| P and Art 83(3) keys | MODE |
|---|---|
| \|P\| = 1 | single |
| \|P\| >= 2, both keys true | combined |
| \|P\| >= 2, either key false | separate |
| otherwise | open; R4 refers |

**R4 unsure.** The first unsure judgement among those read, in contract order:

- `infringer_is_undertaking` (always read) gives `open_textured(infringer_is_undertaking, cite(eu_reg_2016_679_art_83_4))`;
- otherwise, if |P| >= 2 and no key is false, the first unsure Art 83(3) key gives `open_textured(Key, cite(eu_reg_2016_679_art_83_3))`.

CONTEXT is `[inputs_relied_on(Pairs)]`. Pairs is `infringer_is_undertaking-V`, followed, when |P| >= 2, by each PRESENT Art 83(3) key as `Key-V` in contract order. CITES `[]`.

**R5 tier cap** (`gdpr_administrative_fine_maximum_tier_cap/5`), three guarded clauses with the result in the head:

- undertaking false gives FIXED and `fixed_amount_for_non_undertaking`;
- true with PERCENTAGE > FIXED gives PERCENTAGE and `percentage_of_turnover`;
- true with PERCENTAGE =< FIXED gives FIXED and `fixed_amount`.

**R5a single / combined** gives `fine_maximum(Tier, Basis, Cap)`.

- Tier is `higher_maximum_tier` if some member of P is higher (the gravest-infringement rule), else `lower_maximum_tier`.
- CITES, in this order:
  1. the deciding tier's paragraph;
  2. `art_83_6` if the order atom is in P;
  3. the point cites of the members of P IN the deciding tier, deduped and sorted by citation rank;
  4. `art_83_3` last, in combined mode only.

**R5b separate** gives `separate_fine_maxima(Maxima)`.

- Maxima holds one `infringement_maximum(Provision, OwnTier, Basis, Cap)` per member of P, ordered by `provision_rank`. Nothing is summed.
- CITES, in this order:
  1. `art_83_4` if any member is lower tier;
  2. `art_83_5` if any member is higher tier;
  3. `art_83_6` if the order atom is in P;
  4. the point cites of EVERY member, deduped and rank-sorted;
  5. never `art_83_3`.

### Checklist requirement ids (`requirement(RequirementId, Profile, Status, Citation)`, three exclusive clauses each)

- **`provisions_listed_in_article_83`.**
  - met: all of P listed.
  - unmet(`not_governed_here`): some member unlisted.
  - unknown([`infringed_provisions`]): absent.
  - cite: `art_83_5` if a higher member is present, else `art_83_4`.
- **`undertaking_status_settled`.**
  - met: true or false.
  - unknown([`infringer_is_undertaking`]): absent or unsure.
  - cite: `art_83_4`.
- **`turnover_available_when_needed`.**
  - met: undertaking false, or turnover present.
  - unknown([`total_worldwide_annual_turnover_in_euros`]): needed and absent.
  - cite: `art_83_4`.
- **`article_83_paragraph_3_mode_settled`.**
  - met: |P| =< 1, or a false key, or both keys true.
  - unknown(the absent or unsure Art 83(3) keys).
  - cite: `art_83_3`.

The checklist is a justification trace only. The verdict always comes from `administrative_fine_maximum/3`.

### Verdict atoms produced

The five STATUS atoms, the TIER and BASIS atoms, and the result constructors listed above.

### Shared predicates

None. Nothing is moved to kernel.clausal.

### Per-rule tests (in the slice tests; each negative test paired with a positive one on the same case; findall plus length 1 for COUNTING)

**Final answers:**

| Profile | Expected verdict | CITES |
|---|---|---|
| [article_32], undertaking true, T 1000000000 | fine_maximum(lower_maximum_tier, percentage_of_turnover, 2000000000) | [83_4, 83_4_a] |
| [article_6], true, T 400000000 | fine_maximum(higher_maximum_tier, fixed_amount, 2000000000) | as stated in the contract |
| [article_30], true, T 500000000 (lower tie) | fine_maximum(lower_maximum_tier, fixed_amount, 1000000000) | as stated in the contract |
| [article_30], true, T 500000001 | cap 1000000002, percentage_of_turnover | as stated in the contract |
| [article_17], true, T 500000000 (higher tie) | cap 2000000000, fixed_amount | as stated in the contract |
| [article_42], false, no turnover | fine_maximum(lower_maximum_tier, fixed_amount_for_non_undertaking, 1000000000) | [83_4, 83_4_a, 83_4_b] |
| [non_compliance_with_supervisory_authority_order], false | fixed higher tier | [83_5, 83_6, 83_5_e] |
| [article_33, article_6], both Art 83(3) keys true (combined) | higher tier | [83_5, 83_5_a, 83_3] |
| [article_6, article_33], linked false (separate) | maxima ordered article_33, article_6 | [83_4, 83_5, 83_4_a, 83_5_a] |
| [article_5, article_5] | single mode, no Art 83(3) key read | as stated in the contract |

**Missing keys:**

| Profile | Expected verdict |
|---|---|
| [] (empty profile) | indeterminate([infringed_provisions, infringer_is_undertaking, total_worldwide_annual_turnover_in_euros]) |
| unsure undertaking, no turnover | indeterminate([total_worldwide_annual_turnover_in_euros]) |
| two provisions, linked false, fault absent | no Art 83(3) key named |

**Referrals:**

| Profile | Expected verdict |
|---|---|
| [article_24] | not_governed_here, with the context list as given |
| [article_24] with keys missing | indeterminate first |
| undertaking unsure, all else complete | open_textured(infringer_is_undertaking, cite(eu_reg_2016_679_art_83_4)), with PAIRS |
| linked true, fault unsure | open_textured(infringements_intentional_or_negligent, cite(eu_reg_2016_679_art_83_3)), PAIRS with three pairs |
| linked false, fault unsure | separate maxima, no referral |

**Input problems:**

| Profile | Expected PROBLEMS |
|---|---|
| turnover 1.5 | [wrong_type(total_worldwide_annual_turnover_in_euros)] |
| turnover -1 | [wrong_type(total_worldwide_annual_turnover_in_euros)] |
| infringed_provisions [] | [wrong_type(infringed_provisions)] |
| provision item "article_6" (string) | wrong_type |
| key given twice (equal or not) | [duplicate_key(Key)] only |
| foo_key twice | [unknown_key(foo_key)] once, after the contract-key problems |
| non-list profile | [wrong_type(profile)] |
