# SIGNATURE — eu/procurement/shortlisting

The public query surface: `decide_shortlisting(PROFILE, shortlisting_verdict(STATUS, DEFECT_IDS, NUMBER_TO_INVITE, CITATIONS))` and `shortlisting_status(PROFILE, STATUS)`. PROFILE is a dict with ten bare-atom keys (see below). STATUS is one of four atoms. DEFECT_IDS is a flat list of bare atoms in fixed statutory order. NUMBER_TO_INVITE is a bare integer. CITATIONS is a parallel list of cite(...) terms. Totality: decide_shortlisting/2, shortlisting_limitation_modality/4, shortlisting_invitation_floor/4, and shortlisting_inclusion_modality/2 each yield exactly one solution for every input in the contract. statutory_minimum_candidates/2 is deliberately partial (no solution for the two non-Art-65 procedures). Determinism: each predicate yields at most one distinct solution per input.

## Verdict STATUS vocabulary

- `limitation_not_available` — procedure not one of the four Art 65(1) names
- `limitation_prohibited` — at least one defect limb fires
- `continuation_permitted` — no defects, qualified < declared minimum (permission, not obligation)
- `limitation_permitted` — no defects, qualified >= declared minimum

## Profile keys (ten, exactly)

| Key atom | Type | Meaning |
|---|---|---|
| procedure_type_key | bare atom (one of six eu.procurement.directive_2014_24.vocabulary procedure atoms) | the procedure type |
| objective_and_non_discriminatory_criteria_indicated | boolean | whether criteria were indicated |
| minimum_number_indicated | boolean | whether the minimum was indicated |
| declared_minimum_candidates | non-negative integer | the published minimum (0 = none indicated) |
| declared_maximum_candidates | non-negative integer | the published maximum (0 = no maximum declared) |
| qualified_candidates | non-negative integer | count meeting selection criteria + Art 58(5) |
| invited_candidates | non-negative integer | count the authority proposes to invite |
| number_invited_sufficient_for_genuine_competition | boolean | atomic open-textured input |
| invited_include_non_requesting_economic_operators | boolean | whether the shortlist includes non-requesting operators |
| invited_include_candidates_without_required_capabilities | boolean | whether the shortlist includes candidates without required capabilities |

## Citation-key atoms

- `eu_dir_2014_24_art_65_1`
- `eu_dir_2014_24_art_65_2_subpara_1`
- `eu_dir_2014_24_art_65_2_subpara_2`
- `eu_dir_2014_24_art_65_2_subpara_3`

## Public predicates

- `decide_shortlisting(PROFILE, VERDICT)`: main determination; returns shortlisting_verdict(STATUS, DEFECT_IDS, NUMBER_TO_INVITE, CITATIONS). Art 65(1)–(2).
- `shortlisting_status(PROFILE, STATUS)`: status projection from decide_shortlisting. Art 65(1)–(2).
- `shortlisting_checklist(PROFILE, CHECKLIST)`: one item per fired defect (or one met item if none). Art 65(2).
- `shortlisting_decision_resolvable(PROFILE)`: succeeds iff decide_shortlisting yields a solution. Art 65.
- `shortlisting_status_values(STATUS_VALUES)`: enumerates the four status atoms. Art 65(1)–(2).
- `statutory_minimum_candidates(PROCEDURE_TYPE, MINIMUM_CANDIDATES)`: the hard legal floor (5 or 3); partial (no solution for open/negotiated-without-prior-publication). Art 65(2) sub-para 2.
- `shortlisting_limitation_modality(PROCEDURE_TYPE, DECLARED_MINIMUM, QUALIFIED, MODALITY)`: numeric-only modality; total over all six procedures. Art 65(1), 65(2).
- `shortlisting_invitation_floor(PROCEDURE_TYPE, DECLARED_MINIMUM, QUALIFIED, NUMBER_TO_INVITE)`: the computed floor; total over all six procedures. Art 65(2) sub-para 2–3.
- `shortlisting_inclusion_modality(CANDIDATE_STATUS, MODALITY)`: whether including a given candidate type is prohibited. Art 65(2) sub-para 3 sentence 3.
- `shortlisting_what_if(PROFILE, OVERRIDDEN_KEY, NEW_VALUE, NEW_STATUS)`: re-evaluate with one key overridden. Art 65.
- `shortlisting_profile_keys(PROFILE_KEYS)`: the ten-key schema. Art 65(2).
- `shortlisting_subject(SUBJECT)`: fixture registry.
- `shortlisting_profile_for(SUBJECT, PROFILE)`: fixture profiles.
- `shortlisting_assess(SUBJECT, RESULT)`: convenience wrapper.

## Planned reuse

- `eu.procurement.directive_2014_24.vocabulary`: imports the six Art 26 procedure-type atoms (restricted_procedure, competitive_procedure_with_negotiation, competitive_dialogue, innovation_partnership, open_procedure, negotiated_procedure_without_prior_publication). No monetary threshold, no contract-type, no authority-type atoms are imported (Art 65 carries none).
- `formalize_lib`: imports profile_get/3 (profile dict access) and item/3 (checklist row constructor).
- `kit.query_combinators`: imports override_key/4 (for the what-if query).
- Genuinely local vocabulary: all four status atoms, all ten profile-key atoms, all eight defect-limb atoms, the two candidate-status atoms, the two inclusion-modality atoms, and the four citation atoms.

## Determination slice: shortlisting.clausal

**Statutory VALUE facts owned by this file:**
- Statutory minimum table: restricted=5, CPWN=3, CD=3, IP=3 (Art 65(2) sub-para 2)
- The eight defect-limb definitions (one per Art 65(2) sentence)
- The limb-to-citation mapping (eight facts)
- The is_art65_procedure/1 membership predicate (four facts)

**Rules/requirements:**
1. objective_and_non_discriminatory_criteria_not_indicated (Art 65(2) sub-para 1)
2. minimum_number_not_indicated (Art 65(2) sub-para 1)
3. declared_minimum_below_statutory_minimum (Art 65(2) sub-para 2)
4. declared_maximum_below_declared_minimum (Art 65(2) sub-para 1)
5. genuine_competition_not_ensured (Art 65(2) sub-para 2 final sentence)
6. fewer_invited_than_minimum_number (Art 65(2) sub-para 3 sentence 1)
7. non_requesting_economic_operator_included (Art 65(2) sub-para 3 sentence 3)
8. candidate_without_required_capabilities_included (Art 65(2) sub-para 3 sentence 3)

**Verdict vocabulary (local to this file, exported):**
- non_requesting_economic_operator, candidate_without_required_capabilities (candidate-status atoms)
- inclusion_prohibited, inclusion_permitted (modality atoms)

**Vocabulary shared with kernel (declared in kernel.clausal, imported here):**
- shortlisting_verdict/4
- limitation_not_available, limitation_prohibited, continuation_permitted, limitation_permitted
- All ten profile-key atoms
- All eight defect-limb atoms
