# SIGNATURE — eu/data_protection/gdpr_joint_controllers

## Public query surface

The order has three statutory queries and an input check. Their names are fixed by THE CALLED CONTRACT; the three queries carry no prefix by contract.

- `rights_against_each_joint_controller/3`
- `liability_for_the_entire_damage/4`
- `recourse_after_full_compensation/4`
- `gdpr_joint_controllers_input_problems/2`

The scaffold facade, whose names are kept, gives the claim-back eligibility verdict and its cited checklist:

- `decide_gdpr_joint_controllers(PROFILE, gdpr_joint_controllers_verdict(STATUS, CITATIONS))`
- `gdpr_joint_controllers_status(PROFILE, STATUS)`
- `gdpr_joint_controllers_checklist(PROFILE, CHECKLIST)`
- `gdpr_joint_controllers_what_if(PROFILE, KEY, VALUE, STATUS)`

The fixtures predicate keeps its scaffolded name.

The following claims hold for every query:

- **Totality.** Every query yields EXACTLY ONE solution for every PROFILE term, malformed ones included. The input check never fails and never raises.
- **Determinism.** Each limb set is mutually exclusive by head pattern and guard. There is no `!`, `->` or `*->`. Ground outputs are folded into clause heads (C17).
- **Imported figures.** None. The order has no statutory figures, so no `constant_value` is needed.

## Verdict STATUS atoms (replace the placeholder `{ required, permitted, not_applicable }`)

The facade `STATUS` is one of `eligible`, `ineligible` or `indeterminate`. It answers whether the caller is entitled to claim back under Art 82(5).

| `recourse_after_full_compensation` RESULT | Facade STATUS | Facade CITATIONS |
|---|---|---|
| `entitled_to_claim_back(PARTIES)` | `eligible` | the query's CITATIONS, `[cite(eu_reg_2016_679_art_82_5)]` |
| `not_entitled_to_claim_back` | `ineligible` | `[cite(eu_reg_2016_679_art_82_5)]` |
| `indeterminate(_)`, `needs_legal_review(_, _)` or `input_problems(_)` | `indeterminate` | `[]` |

The statutory result atoms of the queries, exactly as specified, are:

- `not_joint_controllers`
- `rights_exercisable_against_this_controller`
- `not_responsible_for_the_damage`
- `no_other_responsible_party`
- `liable_for_the_entire_damage`
- `not_entitled_to_claim_back`
- the constructor `entitled_to_claim_back/1`

The status compounds are:

- `indeterminate([Key])`, never the bare atom
- `needs_legal_review(open_textured(Key, cite(Citation)), [inputs_relied_on(Pairs)])`
- `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_82_4), cite(responsibility_under_article_82_statement)), [resolution(cite(responsibility_under_article_82_statement), not_attempted), inputs_relied_on([responsible_under_article_82_2_and_3-absent])])`, which is THE ABSENT REFERRAL
- `input_problems(Problems)`

## Profile keys (attribute list; read only with `profile_get/3`, presence first)

The four keys, in contract order:

| # | Key | Kind | Value vocabulary |
|---|---|---|---|
| 1 | `controllers_jointly_determine_purposes_and_means` | judgement, tri-state | `true` \| `false` \| `unsure` |
| 2 | `responsible_under_article_82_2_and_3` | outside fact | `attested(true\|false, attestation(By, At, Reason, Evidence))` |
| 3 | `other_responsible_parties` | list | proper list of bare atoms, `[]` allowed, repeats allowed |
| 4 | `full_compensation_paid` | judgement, tri-state | `true` \| `false` \| `unsure` |

In the outside-fact key, `Evidence` is `none`, `url(Url, RetrievedAt)` or `document(UploadIdentifier, Sha256)`. No key is numeric and none is a date, so no unit suffix or date term is needed.

## Citation-key atoms (canonical lexicon, `_lexicon/citations.yaml`)

- `eu_reg_2016_679_art_26_3`: Art 26(3), unit `parag_026.003`
- `eu_reg_2016_679_art_28_10`: Art 28(10), unit `parag_028.010`
- `eu_reg_2016_679_art_82_4`: Art 82(4), unit `parag_082.004`; it is also the citation of the `outside_facts:` entry
- `eu_reg_2016_679_art_82_5`: Art 82(5), unit `parag_082.005`
- `responsibility_under_article_82_statement`: the cross-reference TARGET of THE ABSENT REFERRAL, not a rule

No shortened atom is ever invented. Art 26(1), Art 82(2) and Art 82(3) are deferred: they are quoted for reading only and are not in the vocabulary.

## Public predicates

- `rights_against_each_joint_controller(Profile, Result, Citations)`: Art 26(3) with Art 28(10). It runs step 0, then limbs A1 to A4, and reads `controllers_jointly_determine_purposes_and_means` only. It cites `eu_reg_2016_679_art_26_3` and `eu_reg_2016_679_art_28_10`.
- `liability_for_the_entire_damage(Profile, Result, Basis, Citations)`: Art 82(4). It runs step 0, then limbs B1 to B5, and reads S and O. Basis is `[outside_fact(responsible_under_article_82_2_and_3, Attested)]` on a final answer and `[]` otherwise. It cites `eu_reg_2016_679_art_82_4`.
- `recourse_after_full_compensation(Profile, Result, Basis, Citations)`: Art 82(5). It runs step 0, then limbs C1 to C8, and reads S, O and F. Basis holds the copied outside fact only at C1 and C8. It cites `eu_reg_2016_679_art_82_5`.
- `gdpr_joint_controllers_input_problems(Profile, Problems)`: THE INPUT CHECK. It yields exactly one solution for every term. It applies no provision.
- `decide_gdpr_joint_controllers(Profile, Verdict)`: `Verdict = gdpr_joint_controllers_verdict(Status, Citations)`, the claim-back eligibility derived from `recourse_after_full_compensation/4`. Art 82(5).
- `gdpr_joint_controllers_status(Profile, Status)`: the projection of the Status of `decide_gdpr_joint_controllers/2`. Art 82(5).
- `gdpr_joint_controllers_checklist(Profile, Checklist)`: three cited items, each the `item/3` of formalize_lib. Art 82(4) and Art 82(5). The items are:
  - `item(responsible_under_article_82, ItemStatus, cite(eu_reg_2016_679_art_82_4))`, which reads S;
  - `item(other_responsible_party_listed, ItemStatus, cite(eu_reg_2016_679_art_82_4))`, which reads O;
  - `item(full_compensation_paid, ItemStatus, cite(eu_reg_2016_679_art_82_5))`, which reads F.

  Each `ItemStatus` is `met`, `unmet(Reason)`, `unknown([Key])` (judgement or list key only) or `referred(Referral)`. `Referral` is THE ABSENT REFERRAL for an absent S, or the open_textured term for an unsure F. The open-textured judgement is handed to the user and never given a crisp test. A malformed profile gives `[]`.
- `gdpr_joint_controllers_what_if(Profile, Key, Value, Status)`: replaces `attribute(Key, _)` by `attribute(Key, Value)` with `profile_set/3`, then returns `gdpr_joint_controllers_status/2` of the edited profile. Art 82(5).
- Fixtures, under the scaffolded predicate name: named PROFILE terms covering every limb A1 to A4, B1 to B5 and C1 to C8, plus input-problem cases.

## Planned reuse (manifest `uses:`)

- **`formalize_lib`.** Used predicates:
  - `profile_get/3`, the only value reader in the queries;
  - `profile_has/2` and `profile_lacks/2`, for presence first;
  - `profile_set/3`, for what-if;
  - `attribute/2` and `item/3`, as constructors.

  `assess/6` and `decide_labeled/3` are NOT used. The limbs are an ORDERED first-step-decides list with referral precedence, and the referred statuses are not `unknown/1`. The facade verdict is therefore derived from the query result, not aggregated. `check_tri/4` is not used either, because an `unsure` value must produce the order's own open_textured referral term, not a kit unknown.
- **`validate_props`** (tests). Used predicates: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`.
- **`kit/query_combinators`.** Not used. `override_key/4` targets dicts, and the profile is an attribute list, so `profile_set/3` is used instead.
- **Family backbone `_common`.** No deontic backbone predicate is imported. The order has no modality lattice: `kit/compliance_lib` does not fit Art 26(3) and Art 82(4) and (5) as formalised, which are result-valued, not obligation-valued.

## Per-file plan (layout unchanged: kernel -> citations -> parameters -> gdpr_joint_controllers -> queries -> fixtures -> package facade)

- `kernel.clausal`: keeps its scaffolded generic floor. NO domain predicate is shared, because there is only one determination slice.
- `citations.clausal`: four citation facts plus the target atom, each with instrument, article, paragraph and pinned unit identifier.
- `parameters.clausal`: declares no `constant_value`. A comment states that the rules carry no threshold, period or amount.
- `gdpr_joint_controllers.clausal`: the slice, described below.
- `queries.clausal`: re-exports the four contract predicates.
- `fixtures.clausal`: the fixtures.
- Facade: the decide, status, checklist and what-if predicates.

## Slice — `gdpr_joint_controllers.clausal`

### Statutory VALUE facts it owns

None numeric. It owns these fact tables:

- `gdpr_joint_controllers_contract_key(Key, Position)` for the four keys in contract order, positions 1 to 4;
- `gdpr_joint_controllers_judgement_key/1` for keys 1 and 4;
- `gdpr_joint_controllers_outside_fact(responsible_under_article_82_2_and_3, cite(eu_reg_2016_679_art_82_4), responsibility_under_article_82_statement)`.

### Input check (step 0 of every query)

`gdpr_joint_controllers_input_problems(Profile, Problems)` works on the raw term with type tests only: `var/1`, `atom/1`, `is_list/1`, `ground/1` and structural matching.

1. The Profile is checked first. It must be a proper list whose every element is `attribute(Key, Value)`.
   - Each of these gives `[wrong_type(profile)]` alone: an unbound Profile, a partial list, an unbound element, or a non-attribute element.
2. Each contract key is then checked in contract order.
   - If the key occurs more than once, the problem is `duplicate_key(Key)`, and no value is read.
   - Otherwise, a present value outside its type gives `wrong_type(Key)`.
3. The type of each key is as follows:
   - **Judgement keys**: the atom `true`, `false` or `unsure`. An unbound value or an attested term is a wrong type.
   - **S**: `attested(V, attestation(A1, A2, A3, A4))` with V the atom `true` or `false` and all four arguments ground. Any unbound argument, or one holding a variable, is a wrong type. A bare `true`, `false` or `unsure` is a wrong type.
   - **O**: a proper list, every element satisfying `atom/1`. The empty list `[]` itself as an element is NOT an atom here. Repeats are fine.
4. Last comes `unknown_key(Key)` for each non-contract key (non-atom keys included, as given), once, in order of first occurrence.

The absence of a key is never a problem.

### Rules (limbs; first step that answers decides; each clause head carries its ground outputs)

Step 0 is common to every query. Problems `[_|_]` gives `input_problems(Problems)`, with Basis `[]` and Citations `[]`. Otherwise Problems is `[]`, and the limbs follow.

The outputs of `rights_against_each_joint_controller` (J = `controllers_jointly_determine_purposes_and_means`) are:

| Step | J | Result | Citations |
|---|---|---|---|
| A1 | `false` | `not_joint_controllers` | `[cite(eu_reg_2016_679_art_26_3)]` |
| A2 | absent | `indeterminate([controllers_jointly_determine_purposes_and_means])` | `[]` |
| A3 | `unsure` | `needs_legal_review(open_textured(controllers_jointly_determine_purposes_and_means, cite(eu_reg_2016_679_art_26_3)), [inputs_relied_on([controllers_jointly_determine_purposes_and_means-unsure])])` | `[]` |
| A4 | `true` | `rights_exercisable_against_this_controller` | `[cite(eu_reg_2016_679_art_26_3), cite(eu_reg_2016_679_art_28_10)]` |

The outputs of `liability_for_the_entire_damage` (S = `responsible_under_article_82_2_and_3`, O = `other_responsible_parties`; Attested = S's term as supplied) are:

| Step | Condition | Result | Basis | Citations |
|---|---|---|---|---|
| B1 | S `attested(false, _)`, any O | `not_responsible_for_the_damage` | `[outside_fact(responsible_under_article_82_2_and_3, Attested)]` | `[cite(eu_reg_2016_679_art_82_4)]` |
| B2 | S absent, any O | THE ABSENT REFERRAL | `[]` | `[]` |
| B3 | S `attested(true, _)`, O absent | `indeterminate([other_responsible_parties])` | `[]` | `[]` |
| B4 | S `attested(true, _)`, O `[]` | `no_other_responsible_party` | `[outside_fact(responsible_under_article_82_2_and_3, Attested)]` | `[cite(eu_reg_2016_679_art_82_4)]` |
| B5 | S `attested(true, _)`, O `[_\|_]` | `liable_for_the_entire_damage` | `[outside_fact(responsible_under_article_82_2_and_3, Attested)]` | `[cite(eu_reg_2016_679_art_82_4)]` |

The outputs of `recourse_after_full_compensation` (F = `full_compensation_paid`) are:

| Step | Condition | Result | Basis | Citations |
|---|---|---|---|---|
| C1 | S `attested(false, _)` | `not_entitled_to_claim_back` | `[outside_fact(responsible_under_article_82_2_and_3, Attested)]` | `[cite(eu_reg_2016_679_art_82_5)]` |
| C2 | not C1, O `[]` | `not_entitled_to_claim_back` | `[]` | `[cite(eu_reg_2016_679_art_82_5)]` |
| C3 | not C1 or C2, F `false` | `not_entitled_to_claim_back` | `[]` | `[cite(eu_reg_2016_679_art_82_5)]` |
| C4 | none of C1 to C3, S absent | THE ABSENT REFERRAL | `[]` | `[]` |
| C5 | S true, O absent (F absent, true or unsure) | `indeterminate([other_responsible_parties])` | `[]` | `[]` |
| C6 | S true, O `[_\|_]`, F absent | `indeterminate([full_compensation_paid])` | `[]` | `[]` |
| C7 | S true, O `[_\|_]`, F `unsure` | `needs_legal_review(open_textured(full_compensation_paid, cite(eu_reg_2016_679_art_82_5)), [inputs_relied_on([full_compensation_paid-unsure])])` | `[]` | `[]` |
| C8 | S true, O = Parties `[_\|_]`, F `true` | `entitled_to_claim_back(Parties)` | `[outside_fact(responsible_under_article_82_2_and_3, Attested)]` | `[cite(eu_reg_2016_679_art_82_5)]` |

Mutual exclusion is made explicit by guard predicates, so that one profile matches exactly one clause. The guards are `responsibility_state/2` (`attested_true(Attested)`, `attested_false(Attested)` or `absent`) and `parties_state/2` (`empty`, `listed(Parties)` or `absent`).

### Verdict atoms

The slice's verdict atoms are the statutory result atoms and compounds listed above. The facade maps them to `eligible`, `ineligible` or `indeterminate`.

### Checklist item builders (owned here, used by the facade)

`gdpr_joint_controllers_checklist_item/3` has three independent rows, each reading one key, as specified under the public checklist predicate.

The consistency property tested is:

- `eligible` if and only if all three items are `met`;
- `ineligible` if and only if at least one item is `unmet`;
- otherwise `indeterminate`.

The one exception is `input_problems`, which gives checklist `[]` and status `indeterminate`.

### Predicates shared with another slice

None. There is a single slice, so nothing goes into `kernel.clausal`.

## Tests (seven modes)

1. One unit test per limb (A1 to A4, B1 to B5, C1 to C8). Each negative case is paired with a positive one on the same profile.
2. Counting: `findall` plus `length(_, 1)` for every query and fixture.
3. Input-check totality over malformed terms: unbound, partial list, unbound element, non-attribute element, non-atom key, unbound value, duplicates, an attestation with an unbound argument, and an O element that is a number, string, compound, list, `[]` or unbound.
4. Precedence: B2 before B3, and C1, C2 and C3 before C4, before C5, C6 and C7.
5. Citation completeness, and BASIS copied exactly, attested term identical.
6. Checklist and verdict consistency.
7. What-if flips, for example F `false` to `true` turns `ineligible` into `eligible` when S is attested true and O is non-empty.
