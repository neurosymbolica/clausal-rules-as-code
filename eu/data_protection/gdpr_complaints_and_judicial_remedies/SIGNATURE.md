# SIGNATURE — eu/data_protection/gdpr_complaints_and_judicial_remedies

## S0 Public query surface (one paragraph)

The order exposes five query predicates: `complaint_right`, `authority_decision_remedy_right`, `authority_inaction_remedy_right`, `controller_processor_remedy_right` and `controller_processor_forum`. Each answers for one PROFILE.

The facade dispatches on a REQUEST term `request(QUERY, PROFILE)`, with QUERY one of the five query atoms. It answers as follows:

- `decide_gdpr_complaints_and_judicial_remedies(request(QUERY, PROFILE), gdpr_complaints_and_judicial_remedies_verdict(STATUS, CITATIONS))`;
- `gdpr_complaints_and_judicial_remedies_status(request(QUERY, PROFILE), STATUS)`.

STATUS is exactly the RESULT of the query: a final result atom or one of the non-final compounds.

**Totality and determinism.** For every ground REQUEST with a known QUERY, each query yields EXACTLY ONE solution. The steps are disjoint routes, folded into clause heads (C17), with no `!`, `->` or `*->`. `gdpr_complaints_and_judicial_remedies_input_problems/2` yields exactly one solution for EVERY term and never raises.

**Imported figures.** No statutory figure is computed. The three months of Art 78(2) are a caller-stated boolean, so `parameters.clausal` declares no constant for them. A dead `constant_value` is avoided.

## S1 Status atoms (replace the scaffold placeholders required / permitted / not_applicable)

Final RESULT atoms:

- `complaint_right_exists`, `no_complaint_right` (Art 77(1));
- `decision_remedy_right_exists`, `no_decision_remedy_right` (Art 78(1));
- `inaction_remedy_right_exists`, `no_inaction_remedy_right` (Art 78(2));
- `judicial_remedy_right_exists`, `no_judicial_remedy_right` (Art 79(1));
- `forum_establishment_state_only`, `forum_establishment_or_habitual_residence_state` (Art 79(2)).

Non-final RESULT compounds, exactly one of:

- `input_problems(PROBLEMS)`;
- `indeterminate([KEY])`. The bare atom `indeterminate` is NEVER a RESULT;
- `needs_legal_review(open_textured(KEY, cite(CITATION)), [inputs_relied_on(PAIRS)])`;
- `needs_legal_review(cross_reference_unresolved(cite(CITATION), cite(TARGET)), [resolution(cite(TARGET), not_attempted), inputs_relied_on(PAIRS)])`.

Eligibility labels (query type #2) for the four right queries: `labels(eligible, indeterminate_eligibility, ineligible)`. The mapping is:

- a `*_exists` result maps to `eligible`;
- a `no_*` result maps to `ineligible`;
- every non-final result maps to `indeterminate_eligibility`.

The label atom `indeterminate_eligibility` is used so that the bare atom `indeterminate` never sits beside `indeterminate/1` (atom-shadowing trap). `controller_processor_forum` is a determination, not an eligibility, so it has no label.

Result constructors (exported, never called as queries): `indeterminate/1`, `needs_legal_review/2`, `open_textured/2`, `cross_reference_unresolved/2`, `input_problems/1`, `unknown_key/1`, `wrong_type/1`, `duplicate_key/1`, `resolution/2`, `inputs_relied_on/1`, `provenance/2`, `outside_fact/2`, `attested/2`, `attestation/4`, `url/2`, `document/2`.

## S2 Profile keys (attribute list, read ONLY with profile_get/3; bare atoms; this order = root_exports = input_contract)

The profile holds eleven keys. Every value is an atom or an attested term: there are no numbers, no dates and no strings.

| # | Key | Kind | Values |
|---|---|---|---|
| 1 | `is_data_subject` | crisp | true / false |
| 2 | `data_subject_considers_processing_infringes_regulation` | crisp | true / false |
| 3 | `decision_is_legally_binding` | judgement | true / false / unsure |
| 4 | `decision_concerns_the_caller` | judgement | true / false / unsure |
| 5 | `complaint_lodged_under_article_77` | crisp | true / false |
| 6 | `authority_competent_under_articles_55_and_56` | outside fact | `attested(true or false, attestation(BY, AT, REASON, EVIDENCE))` |
| 7 | `authority_handled_the_complaint` | crisp | true / false |
| 8 | `three_months_from_the_complaint_have_passed` | crisp | true / false |
| 9 | `authority_informed_on_progress_or_outcome` | crisp | true / false |
| 10 | `data_subject_considers_rights_infringed_by_processing` | crisp | true / false |
| 11 | `defendant_is_member_state_public_authority_acting_in_public_powers` | crisp | true / false |

In the outside-fact value of key 6, EVIDENCE is `url(URL, RETRIEVED_AT)`, `document(UPLOAD_ID, SHA256)` or the atom `none`. BY and AT are supplied by the host. The four arguments are copied, never read.

## S3 Citation-key atoms (canonical lexicon scheme, _lexicon/citations.yaml; citation_vocabulary)

- `eu_reg_2016_679_art_77_1`: GDPR Art 77(1), unit 02016R0679-20160504#parag_077.001;
- `eu_reg_2016_679_art_78_1`: GDPR Art 78(1), parag_078.001;
- `eu_reg_2016_679_art_78_2`: GDPR Art 78(2), parag_078.002;
- `eu_reg_2016_679_art_79_1`: GDPR Art 79(1), parag_079.001;
- `eu_reg_2016_679_art_79_2`: GDPR Art 79(2), parag_079.002;
- `competence_statement`: the cross-reference TARGET of the outside fact. It is the entry `target:` of `outside_facts:` and points to GDPR Arts 55 and 56, which are not pinned.

Deferred units are listed in the manifest deferred set, never cited in a result:

- parag_077.002;
- parag_078.003 and parag_078.004;
- art_077, art_078 and art_079.

No shortened citation atom is ever invented. Each CITATIONS list is set-like, each atom written once.

## S4 Public predicates

- `gdpr_complaints_and_judicial_remedies_complaint_right(Profile, Result, Citations)`: Art 77(1). The steps are:
  - 0: input problems;
  - 1: `is_data_subject` false gives `no_complaint_right`;
  - 2: considers false gives `no_complaint_right`;
  - 3: `indeterminate([first absent of is_data_subject, data_subject_considers_processing_infringes_regulation])`;
  - 4: both true gives `complaint_right_exists`.
  - Final steps cite `eu_reg_2016_679_art_77_1`.
- `gdpr_complaints_and_judicial_remedies_authority_decision_remedy_right(Profile, Result, Citations)`: Art 78(1). The steps are:
  - 0: input problems;
  - 1: either judgement false gives `no_decision_remedy_right`;
  - 2: `indeterminate([first absent of decision_is_legally_binding, decision_concerns_the_caller])`;
  - 3: the first unsure judgement gives `needs_legal_review(open_textured(KEY, cite(eu_reg_2016_679_art_78_1)), [inputs_relied_on([decision_is_legally_binding-V1, decision_concerns_the_caller-V2])])`;
  - 4: both true gives `decision_remedy_right_exists`.
  - Final steps cite `eu_reg_2016_679_art_78_1`.
- `gdpr_complaints_and_judicial_remedies_authority_inaction_remedy_right(Profile, Result, Basis, Citations)`: Art 78(2). The steps are 0 to 7 of S6.1. Final steps cite `eu_reg_2016_679_art_78_2`.
- `gdpr_complaints_and_judicial_remedies_controller_processor_remedy_right(Profile, Result, Citations)`: Art 79(1). The steps are:
  - 0: input problems;
  - 1: `is_data_subject` false gives `no_judicial_remedy_right`;
  - 2: considers false gives `no_judicial_remedy_right`;
  - 3: `indeterminate([first absent of is_data_subject, data_subject_considers_rights_infringed_by_processing])`;
  - 4: both true gives `judicial_remedy_right_exists`.
  - Final steps cite `eu_reg_2016_679_art_79_1`.
- `gdpr_complaints_and_judicial_remedies_controller_processor_forum(Profile, Result, Citations)`: Art 79(2). The steps are:
  - 0: input problems;
  - 1: key absent gives `indeterminate([defendant_is_member_state_public_authority_acting_in_public_powers])`;
  - 2: true gives `forum_establishment_state_only`;
  - 3: false gives `forum_establishment_or_habitual_residence_state`.
  - Final steps cite `eu_reg_2016_679_art_79_2`.
- `gdpr_complaints_and_judicial_remedies_input_problems(Profile, Problems)`: THE INPUT CHECK against the typed input_contract (S6.2). It has exactly one solution for every term and never raises. It cites no article; it is an interface check.
- `decide_gdpr_complaints_and_judicial_remedies(Request, Verdict)`: the facade. Request is `request(Query, Profile)`, and Verdict is `gdpr_complaints_and_judicial_remedies_verdict(Status, Citations)`. One clause per query atom dispatches to that query. For the inaction query, BASIS is carried by `gdpr_complaints_and_judicial_remedies_basis/2`. Citations are those of the query.
- `gdpr_complaints_and_judicial_remedies_status(Request, Status)`: the RESULT alone. Citations are those of the query.
- `gdpr_complaints_and_judicial_remedies_basis(Request, Basis)`: BASIS for `authority_inaction_remedy_right` (`[outside_fact(authority_competent_under_articles_55_and_56, ATTESTED)]` or `[]`), and `[]` for the other queries. Cites `eu_reg_2016_679_art_78_2`.
- `gdpr_complaints_and_judicial_remedies_eligibility(Request, Eligibility)`: query type #2, for the four right queries. It calls formalize_lib `assess/6` with the closure `gdpr_complaints_and_judicial_remedies_requirement` and `labels(eligible, indeterminate_eligibility, ineligible)`. It is cross-checked against the query RESULT by a consistency test. Citations come per requirement (S6.3).
- `gdpr_complaints_and_judicial_remedies_checklist(Request, Checklist)`: query type #7. It gives `item(RequirementId, Status, cite(Citation))` for every requirement of the query's limb, met items included. It uses formalize_lib `eval_requirements/4`, and its citations are those of S6.3.
- `gdpr_complaints_and_judicial_remedies_what_if(Request, Key, Value, Status)`: the status after overriding Key with Value in the PROFILE. It uses kit.query_combinators `what_if/5` with the closure `gdpr_complaints_and_judicial_remedies_status_of(Query)`. Citations are those of the query.
- `gdpr_complaints_and_judicial_remedies_requirement(RequirementId, Profile, Status, Citation)`: the requirement/4 row for assess/6, with the id FIRST. It has three disjoint clauses per check (met / unmet / unknown) and is built on `check_true/4`, `check_tri/4` and a local attested reader. Citation per S6.3.
- Fixtures: `gdpr_complaints_and_judicial_remedies_fixture(Name, Query, Profile, ExpectedResult)` and `gdpr_complaints_and_judicial_remedies_fixture_basis(Name, ExpectedBasis)` hold named situations. They cover every step of every query, every input-problem shape, and the precedence pairs of S6.4. Citations are those of the expected result.

## S5 Planned reuse (manifest `uses:`)

- **formalize_lib**: `profile_get/3`, `profile_has/2`, `profile_lacks/2`, `profile_set/3`, `check_true/4`, `check_tri/4`, `assess/6`, `eval_requirements/4`, `labels/3`, `item/3`, `unmet/1`, `unknown/1`, `attribute/2`, `memberd/2`, `not_member/2`.
  - check_tri is used for the two tri-state judgements, so C15 does not hand-roll it.
  - There is no hand-rolled eval_requirements (R1 lint).
- **kit.query_combinators**: `what_if/5`, `override_key/4`, `diff_checklists/3` (the what_if facade and the what-if delta tests).
- **validate_props**: `run_props/1`, `prop_totality/3`, `prop_determinism/3`, `prop_consistency/4`, `prop_citation_complete/3`, `prop_missing_key_coverage/3`, `declare_vacuous/1`, `bad_citation/1`.
  - `prop_boundary_coverage` is declared vacuous: there are no numeric boundaries.
  - `prop_monotone` is declared vacuous: there is no numeric axis.
- **Not used**: kit.deadline_lib (the three months are not counted, Q4), library(datetime), country, currency_vocab, vat_category, kit.compliance_lib, kit.rolling_window.
- **Family backbone (_common, deontic)**: none needed beyond formalize_lib.

## S6 Determination slices

The pipeline runs kernel, then citations, then parameters, then gdpr_complaints_and_judicial_remedies, then queries, then fixtures, then the package facade. There is only ONE slice. No predicate is shared with another slice, so `kernel.clausal` keeps only its scaffolded floor (module declaration and re-exports of the result constructors). Domain logic does not go there.

The other files hold the following:

- `citations.clausal`: the six citation facts of S3, each with its unit id.
- `parameters.clausal`: no statutory figures, only a comment explaining why. It must not hold a three-months constant.
- `queries.clausal`: the facade wrappers of S4.

### S6.1 Slice `gdpr_complaints_and_judicial_remedies.clausal` — rights to a complaint and to judicial remedies (Arts 77(1), 78(1), 78(2), 79(1), 79(2))

**VALUE facts owned here.** These live in this file, not in a shared constants file:

- `contract_key(Position, Key, Kind)`: eleven rows, in the order of S2. Kind is `crisp`, `judgement` or `outside_fact`.
- `outside_fact_entry(authority_competent_under_articles_55_and_56, eu_reg_2016_679_art_78_2, competence_statement)`: the key, its CITATION and its TARGET.
- `outside_fact_kind_precedence([attested, fetched])` and `outside_fact_fetcher(none)`.
- `needed_key_order(Query, Keys)` for the missing-key steps:
  - `complaint_right`: [is_data_subject, data_subject_considers_processing_infringes_regulation];
  - `authority_decision_remedy_right`: [decision_is_legally_binding, decision_concerns_the_caller];
  - `controller_processor_remedy_right`: [is_data_subject, data_subject_considers_rights_infringed_by_processing];
  - `controller_processor_forum`: [defendant_is_member_state_public_authority_acting_in_public_powers].
- The inaction needed keys are conditional (below).
- There are no thresholds, periods or tables: the three months are a caller-stated boolean.

**Rules and requirements**, one clause per disjoint route. Ground results are folded in heads, and there is no cut or if-then-else.

- **complaint_right** (Art 77(1)). See the steps in S4. Steps 1 and 2 overlap when both keys are false. The route split must make them disjoint while keeping a single answer: step 2 requires `is_data_subject` to be not false (true or absent).
- **authority_decision_remedy_right** (Art 78(1)). Step 1 must give one answer when both judgements are false: split into 'binding false' and 'binding not false and concerns false'. The other routes are:
  - step 2 when no judgement is false and the first key of the list is absent;
  - step 3 when both are present, neither is false and at least one is unsure. KEY is the first unsure one in list order, and PAIRS holds both values;
  - step 4 when both are true.
- **authority_inaction_remedy_right** (Art 78(2)). Steps in order; the first that applies decides:
  - 0: input problems give `input_problems(P)`, BASIS [] and CITATIONS [].
  - 1: `is_data_subject` false gives `no_inaction_remedy_right`, BASIS [], cite art_78_2.
  - 2: complaint_lodged false (and step 1 does not apply) gives `no_inaction_remedy_right`, BASIS [], cite art_78_2.
  - 3: competence `attested(false, _)` (steps 1 and 2 do not apply) gives `no_inaction_remedy_right`, BASIS `[outside_fact(authority_competent_under_articles_55_and_56, ATTESTED)]`, cite art_78_2. This applies whatever the other keys are, absent included.
  - 4: handled true AND (three_months false OR informed true) gives `no_inaction_remedy_right`, BASIS [], cite art_78_2. This applies whatever the competence fact is (absent, or attested true). To keep one answer, split into 'three_months false' and 'three_months true and informed true'.
  - 5: the first absent NEEDED key gives `indeterminate([KEY])`, BASIS [] and CITATIONS []. The needed keys, in order, are:
    - is_data_subject;
    - complaint_lodged_under_article_77;
    - authority_handled_the_complaint;
    - three_months_from_the_complaint_have_passed, only if handled is true;
    - authority_informed_on_progress_or_outcome, only if handled is true and three_months is true.
  - 6: every needed key is present and competence is absent. This gives `needs_legal_review(cross_reference_unresolved(cite(eu_reg_2016_679_art_78_2), cite(competence_statement)), [resolution(cite(competence_statement), not_attempted), inputs_relied_on([authority_competent_under_articles_55_and_56-absent])])`, BASIS [] and CITATIONS [].
  - 7: competence is `attested(true, _)` and the failure holds, meaning handled false OR (three_months true AND informed false). This gives `inaction_remedy_right_exists`, BASIS `[outside_fact(authority_competent_under_articles_55_and_56, ATTESTED)]`, cite art_78_2.
  - Nothing remains after step 7. Totality is to be proved by the totality property over the full grid: each crisp key in {true, false, absent}, and competence in {attested true, attested false, absent}.
  - The outside fact is never placed in MISSING_KEYS.
- **controller_processor_remedy_right** (Art 79(1)). As complaint_right, with the Art 79(1) consideration key.
- **controller_processor_forum** (Art 79(2)). Three routes, as in S4.

**Local helpers** (domain-specific, so local is fine):

- `attested_competence(Profile, Value, Attested)`: reads `attested(Value, attestation(_, _, _, _))` through `profile_get/3` and copies the term verbatim.
- `first_absent(Profile, Keys, Key)`: built with `profile_lacks/2` and a recursion that skips present keys. It does not hand-roll `missing_keys/3`. Note: if `missing_keys/3` returns keys in list order, use its head instead and drop this helper.
- `judgement_pairs(Profile, Pairs)`.

### S6.2 The input check (owned by this slice)

`gdpr_complaints_and_judicial_remedies_input_problems(Profile, Problems)` builds PROBLEMS in three steps:

1. **Profile shape.** If Profile is not a proper attribute list, the result is `[wrong_type(profile)]` alone. This covers:
   - an unbound variable;
   - a partial list;
   - a non-list;
   - a list with an unbound element;
   - a list with any element that is not `attribute(_, _)`.
   - The walk is guarded with `var/1` and `nonvar/1` and uses no `=..` on unbound terms, so it never raises.
2. **Contract keys.** For each contract key in S2 order:
   - if it occurs more than once (counted by key alone, its values never read), the problem is `duplicate_key(KEY)` only;
   - else, if it occurs once with a value outside its type, the problem is `wrong_type(KEY)`.
   - The types are: a crisp key is true or false; a judgement is true, false or unsure; the outside fact is `attested(true|false, attestation(_, _, _, _))`, checked for arity only.
   - An unbound VALUE is `wrong_type`.
3. **Unknown keys.** `unknown_key(KEY)` is given once per non-contract key, in the order of first occurrence.
   - A non-atom key (number, string, compound, unbound) is unknown_key, given as written.
   - Key equality for de-duplication uses `==`, so unbound keys are never unified with each other.

An absent key is never a problem. The check uses no cut or if-then-else: it uses disjoint guarded clauses.

### S6.3 Requirements (checklist and eligibility, query types #2 and #7)

These rows feed `gdpr_complaints_and_judicial_remedies_requirement/4`. Each row gives the requirement id, its check, and its citation.

- `complaint_right`:
  - `complaint_claimant_is_data_subject`: is_data_subject true, cite art_77_1;
  - `complaint_data_subject_considers_infringement`: data_subject_considers_processing_infringes_regulation true, cite art_77_1.
- `authority_decision_remedy_right`:
  - `decision_is_legally_binding_requirement`: check_tri on decision_is_legally_binding, cite art_78_1;
  - `decision_concerns_the_caller_requirement`: check_tri on decision_concerns_the_caller, cite art_78_1.
  - An unsure judgement maps to the unknown status.
- `authority_inaction_remedy_right`, all citing art_78_2:
  - `inaction_claimant_is_data_subject`;
  - `inaction_complaint_lodged_under_article_77`;
  - `inaction_authority_is_competent`, from the attested reader: absent maps to unknown;
  - `inaction_authority_failed`: not handled, or the three months passed without informing. Its unknown status names the first needed key.
- `controller_processor_remedy_right`:
  - `judicial_remedy_claimant_is_data_subject`, cite art_79_1;
  - `judicial_remedy_data_subject_considers_rights_infringed`, cite art_79_1.
- `controller_processor_forum` has no eligibility rows. Its checklist is the single item `forum_public_powers_exception`, with Status `value(true|false)` or `unknown([...])`, cite art_79_2.

**Consistency rule** (tested): the eligibility label must equal the label mapped from the query RESULT, for every fixture without input problems. Where the checklist cannot express precedence (for example the status rule), the query RESULT is authoritative, and the checklist is justification only.

### S6.4 Tests (seven modes; v2 manifest)

1. **load**: every module loads.
2. **unit / per-rule**: every step of every query, with a positive test and its paired negative test.
3. **fixtures**: every fixture result, and the BASIS of the inaction fixtures.
4. **properties** (validate_props): totality, determinism, citation-complete, missing-key coverage and consistency. Boundary and monotone are declared vacuous.
5. **input check**:
   - each problem shape;
   - duplicate with equal and with different values;
   - an unbound value;
   - a non-atom key;
   - a partial list;
   - an unbound profile;
   - the ordering of PROBLEMS.
6. **what-if**: flipping `authority_handled_the_complaint`, and supplying the competence attestation.
7. **precedence**:
   - false before missing;
   - unsure with the other judgement missing gives indeterminate;
   - one key named;
   - inaction step 3 with is_data_subject absent;
   - inaction step 4 with competence absent;
   - three months not needed when the complaint was not handled.
