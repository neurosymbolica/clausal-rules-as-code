# SIGNATURE - eu/data_protection/gdpr_art89_research_safeguards

Public surface: decide_safeguards(Profile, gdpr_art89_verdict(Status, Unmet, Citations)), safeguards_status(Profile, Status), unmet_requirements(Profile, Unmet), plus the scaffold facade names. The profile is an attribute list read only with profile_get/3 from formalize_lib. Every query runs the input check first, and the answer is total with exactly one solution.

## Verdict STATUS atoms

in_accordance, not_in_accordance, not_applicable, indeterminate(MissingKeys), needs_legal_review(open_textured(Input, cite(Key)), [inputs_relied_on(Pairs)]), input_problems(Problems).

## Profile keys

purpose (archiving_public_interest, scientific_research, historical_research, statistical, other_purpose), technical_organisational_measures_in_place, minimisation_measures_in_place, identifiable_data_processed (each true or false), non_identifying_processing_sufficient, safeguards_appropriate (each true, false or unsure).

## Citation keys

eu_reg_2016_679_art_89_1

## Public predicates

- decide_safeguards(Profile, Verdict): the headline verdict, Art 89(1) (eu_reg_2016_679_art_89_1).
- safeguards_status(Profile, Status): the STATUS field of the verdict, Art 89(1) (eu_reg_2016_679_art_89_1).
- unmet_requirements(Profile, Unmet): the unmet requirements, [] unless not_in_accordance, Art 89(1) (eu_reg_2016_679_art_89_1).
- gdpr_art89_research_safeguards_input_problems(Profile, Problems): the typed input check, run first, Art 89(1) (eu_reg_2016_679_art_89_1).
- gdpr_art89_verdict(Status, Unmet, Citations): the verdict term built by decide_safeguards/2, Art 89(1) (eu_reg_2016_679_art_89_1).
- indeterminate(MissingKeys): status compound listing the absent keys the open requirements need, Art 89(1) (eu_reg_2016_679_art_89_1).
- needs_legal_review(Reason, Context): status compound handing an open-textured judgement to a lawyer, Art 89(1) (eu_reg_2016_679_art_89_1).
- open_textured(Input, Citation): the REASON constructor of needs_legal_review, Input the first unsure judgement key, Art 89(1) (eu_reg_2016_679_art_89_1).
- inputs_relied_on(Pairs): the CONTEXT item of needs_legal_review, the Key-Value pairs read, Art 89(1) (eu_reg_2016_679_art_89_1).
- input_problems(Problems): status compound carrying the input check problems, Art 89(1) (eu_reg_2016_679_art_89_1).
- unknown_key(Key): input problem, a profile key that is not in the input contract, Art 89(1) (eu_reg_2016_679_art_89_1).
- wrong_type(Key): input problem, a key whose value is not of its contract type (a non-attribute-list profile gives wrong_type(profile)), Art 89(1) (eu_reg_2016_679_art_89_1).
- duplicate_key(Key): input problem, a contract key that occurs more than once, no value read, Art 89(1) (eu_reg_2016_679_art_89_1).
- decide_safeguards_status(Profile, Verdict): scaffold facade, the verdict as safeguards_status_verdict(Status, Citations).
- safeguards_status_status(Profile, Status): scaffold facade, the status projection.
- safeguards_status_checklist(Profile, Items): one item per requirement, each with cite(...).
- gdpr_art89_research_safeguards_what_if(Profile, Key, Value, Status): override one key and re-evaluate.
- gdpr_art89_research_safeguards_compliance_check(Profile, Result): permitted, prohibited or undetermined.
- gdpr_art89_research_safeguards_justification(Profile, Items): the checklist with provenance.
- fixtures: gdpr_art89_research_safeguards_subject/1, gdpr_art89_research_safeguards_profile_for/2, gdpr_art89_research_safeguards_assess/2.

## Slice: safeguards_status

- Value facts it owns: named_purpose/1 (the four named purposes), missing_key_order/1, judgement_key_order/1, and the referral/4 rows.
- Requirements: measures, minimisation, identification, appropriateness.
- Verdict atoms: in_accordance, not_in_accordance, not_applicable, plus the compound statuses above.
- Shared predicate: only the input check, which lives in kernel.clausal.

## Planned reuse

formalize_lib profile_get/3 and profile_lacks/2. The kernel input check. citations implements/1.
