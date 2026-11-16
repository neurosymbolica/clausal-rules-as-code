# SIGNATURE - eu/data_protection/gdpr_administrative_fine_maximum

## Verdict statuses

administrative_fine_maximum(PROFILE, VERDICT, CITATIONS) with VERDICT one of fine_maximum(TIER, BASIS, CAP_IN_EURO_CENTS), separate_fine_maxima(MAXIMA), indeterminate(MISSING_KEYS), needs_legal_review(REASON, CONTEXT), input_problems(PROBLEMS). Status atoms: fine_maximum, separate_fine_maxima, indeterminate, needs_legal_review, input_problems. Tier atoms: lower_maximum_tier, higher_maximum_tier. Basis atoms: fixed_amount, percentage_of_turnover, fixed_amount_for_non_undertaking.

## Profile keys (attribute list of attribute(Key, Value))

infringed_provisions (non-empty list of atoms), infringer_is_undertaking (true, false, unsure), total_worldwide_annual_turnover_in_euros (non-negative integer, whole euros), infringements_concern_same_or_linked_processing_operations (true, false, unsure), infringements_intentional_or_negligent (true, false, unsure).

## Citation keys

eu_reg_2016_679_art_83_3, eu_reg_2016_679_art_83_4, eu_reg_2016_679_art_83_4_a, eu_reg_2016_679_art_83_4_b, eu_reg_2016_679_art_83_4_c, eu_reg_2016_679_art_83_5, eu_reg_2016_679_art_83_5_a, eu_reg_2016_679_art_83_5_b, eu_reg_2016_679_art_83_5_c, eu_reg_2016_679_art_83_5_d, eu_reg_2016_679_art_83_5_e, eu_reg_2016_679_art_83_6; recorded only: eu_reg_2016_679_art_4_18, eu_reg_2016_679_art_4_19, eu_reg_2016_679_art_83_7.

## Public predicates

- administrative_fine_maximum(Profile, Verdict, Citations): the calculation, exactly one solution per profile; Art 83(3) to (6).
- gdpr_administrative_fine_maximum_input_problems(Profile, Problems): typed input check, in kernel; Problems is [] or unknown_key/wrong_type/duplicate_key terms.
- decide_gdpr_administrative_fine_maximum(Profile, gdpr_administrative_fine_maximum_verdict(Verdict, Citations)): facade wrapper of the calculation.
- gdpr_administrative_fine_maximum_status(Profile, Status): the verdict functor as an atom.
- gdpr_administrative_fine_maximum_checklist(Profile, Items): one item(Id, Status, cite(Key)) per citation of a final answer, or the single row overall.
- gdpr_administrative_fine_maximum_what_if(Profile, Key, Value, NewVerdict): re-evaluate with one attribute overridden.
- gdpr_administrative_fine_maximum_decision_resolvable/1, gdpr_administrative_fine_maximum_status_values/1.
- fixtures: gdpr_administrative_fine_maximum_subject/1, gdpr_administrative_fine_maximum_profile_for/2, gdpr_administrative_fine_maximum_assess/2.
- result constructors: fine_maximum/3, separate_fine_maxima/1, infringement_maximum/4, indeterminate/1, needs_legal_review/2, not_governed_here/1, open_textured/2, inputs_relied_on/1, input_problems/1, unknown_key/1, wrong_type/1, duplicate_key/1.

## Determination slice: gdpr_administrative_fine_maximum.clausal

Value facts owned: tier_figures (lower 1000000000 cents, 2 %; higher 2000000000 cents, 4 %), and the provision groups mapping each provision atom to its tier and point citations (Art 83(4)(a)-(c), 83(5)(a)-(e)). Rules: input check, missing keys, unlisted provision, mode (single, combined, separate, open), unsure referral, final cap, citations. Verdict atoms as above. Nothing is shared with another slice except the input check, which lives in kernel.clausal.

## Planned reuse

formalize_lib: profile_get/3, profile_has/2, profile_lacks/2. library(reif): memberd_t/3. library(clpz) for integer arithmetic.
