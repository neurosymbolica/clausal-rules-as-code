# May the authority limit the number of candidates, and to how many (Art 65)?

`eu/procurement/shortlisting`

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 182/182 | enforced: 3 units: 2 formalized, 1 deferred (1 authorized, 0 expansion), 0 unaccounted | pass | pass | pass |

## Scope

EU Directive 2014/24/EU Article 65 -- reduction of the number of otherwise qualified candidates to be invited to participate. ONE determination over ONE procurement: may this contracting authority limit the number of candidates it invites to tender or to conduct a dialogue, and how many candidates must it invite? The verdict is MODAL, not boolean, and that is the point of the domain: `limitation_not_available` (Art 65(1) confers the power in the restricted procedure, the competitive procedure with negotiation, the competitive dialogue and the innovation partnership, and in no other, so for an open procedure or a negotiated procedure without prior publication there is no power to exercise -- a different answer from a power exercised badly); `limitation_permitted`; `limitation_prohibited` with EVERY Art 65(2) limb the facts defeat, never just the first; and `continuation_permitted`, the ...

## Pinned sources

| Document | Consolidated | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02014L0024 | 2026-01-01 | 2026-08-20 | `97407c001e90251b...` |

[Side-by-side provision report](../reports/eu-procurement-shortlisting.html){ .md-button }
[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/procurement/shortlisting){ .md-button }

## Interpretive choices

Where the text admits more than one reading, the domain records the question, the readings and the one it takes.

??? note "art_65_2_declared_minimum_below_statutory_minimum"

    Art 65(2) first sub-paragraph obliges the contracting authority to indicate the minimum number of candidates it intends to invite; the second sub-paragraph fixes that minimum at five in the restricted procedure and three in the other three. Where an authority indicates a minimum BELOW the statutory one -- three candidates in a restricted procedure -- has it made an UNLAWFUL DECLARATION, so that the limitation it has configured is prohibited outright and no reduction is available at all, or merely an INOPERATIVE one, so that the statutory five substitutes silently and the procedure runs on lawfully at five?

    - **unlawful_declaration** (chosen), the more conservative reading: The declaration is a defect. STATUS is `limitation_prohibited`, DEFECT_IDS carries `declared_minimum_below_statutory_minimum`, and NUMBER_TO_INVITE is the FULL qualified count: with no lawful limitation available, every candidate meeting the selection criteria must be invited. A tenderer excluded from the shortlist has a defect to point at and the authority cannot cure it by inviting five after the fact, because what it published is what candidates relied on when deciding whether to request to participate.
    - **inoperative_declaration**: The declaration is a nullity as to the number only. No defect is reported, STATUS is whatever the corrected minimum yields, and NUMBER_TO_INVITE is the STATUTORY five or three. The authority shortlists five and the procedure is clean; the under-declaration becomes invisible in the record, and a candidate who did not request to participate because it read "minimum three" and judged its chances poor has no defect to point at.

    **Why this reading:** Art 65(2) sub-para 1's duty is to indicate the minimum number the authority "intend[s] to invite", and sub-para 2 fixes what that minimum "shall be". A published figure below the floor is therefore a breach of the publication duty and not merely a mis-statement of a number the Directive supplies anyway: the sentence's function is to let economic operators decide whether to request to participate, so the harm lands before any invitation is issued and substituting the correct figure afterwards cannot undo it. The reading is also the CONSERVATIVE one -- it reports a defect where the rival reports none -- which is the right default for a domain with no controlling authority. Its cost is stated plainly: it makes an authority that published three and then invited eight nonetheless defective, which the rival reading would not.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

??? note "art_65_2_minimum_number_referent"

    Art 65(2) third sub-paragraph: "where the number of candidates meeting the selection criteria and the minimum levels of ability as referred to in Article 58(5) is below THE MINIMUM NUMBER, the contracting authority may continue the procedure by inviting the candidates with the required capabilities." Which minimum is "the minimum number" -- the one the authority INDICATED under sub-para 1 (which may be higher than the statutory floor), or the STATUTORY five or three of sub-para 2?

    - **declared_minimum** (chosen): The continuation limb opens whenever the qualified count falls below the authority's OWN published minimum. A restricted procedure that published a minimum of eight and attracted six qualified candidates is in the continuation limb: STATUS is `continuation_permitted`, the floor is six, and inviting six is compliant. The authority is not trapped by its own ambition.
    - **statutory_minimum**: The continuation limb opens only below five (or three). The same procedure -- published minimum eight, six qualified -- is NOT in the continuation limb, because six is at or above the statutory five, so the sub-para 1 duty to invite at least the published minimum stands unrelieved: the floor is eight, inviting six is `fewer_invited_than_minimum_number`, and the authority must either invite eight candidates it does not have or abandon the procedure.

    **Why this reading:** "The minimum number" is a definite reference and its nearest antecedent is the immediately preceding sentence of the SAME sub-paragraph: "The contracting authorities shall invite a number of candidates at least equal to the minimum number" -- which is unarguably the number indicated under sub-para 1, since that is the number sub-para 1 obliges them to publish. The "However" that opens the continuation sentence marks it as the exception to that immediately preceding duty, so it must be measured against the same figure. The rival reading also produces an absurdity the Directive plainly does not intend: an authority that voluntarily set a HIGHER minimum than the law requires would be worse off than one that set the floor, because the relief the sentence exists to give would be unavailable to it. NOT conservative-flagged: neither reading is systematically stricter -- the chosen one relieves the authority more readily, the rival reports a defect more readily, and which is "safer" depends on whose interest is in issue.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

??? note "art_65_2_required_capabilities_set_identity"

    The continuation sentence permits the authority to continue "by inviting the candidates with THE REQUIRED CAPABILITIES", and the following sentence bars it from including "candidates that do not have the required capabilities". Is that set the SAME as "the candidates meeting the selection criteria and the minimum levels of ability as referred to in Article 58(5)" named earlier in the same sentence, or a NARROWER set -- those who, over and above meeting the Art 58 selection criteria, are actually capable of performing this contract?

    - **coextensive** (chosen): One number describes the candidate pool. The profile carries a single `qualified_candidates` key, the continuation floor is that count, and "shall not include candidates that do not have the required capabilities" is the same bar as "did not meet the selection criteria", expressed from the other side. The prohibition adds nothing to the arithmetic and exists to stop the authority topping up a short shortlist with candidates it has already rejected.
    - **narrower**, the more conservative reading: Two numbers describe the pool, and the INPUT CONTRACT changes: the profile would need a second key, the count of candidates with the required capabilities, always at most `qualified_candidates`. The continuation floor would be that smaller count, and the authority would hold a residual capability judgement over and above Art 58 that it could exercise to shrink the shortlist further -- which is exactly the "unrestricted freedom of choice" the Directive elsewhere forbids, but which this sentence's separate wording arguably contemplates.

    **Why this reading:** The sentence's own subject is "the number of candidates meeting the selection criteria and the minimum levels of ability as referred to in Article 58(5)"; "the candidates with the required capabilities" appears in the SAME sentence as the thing the authority may invite, and reading it as a different set would give the authority a selection power the Directive confers nowhere and would let it defeat Art 65's minima by declaring candidates capable-but-not-capable-enough. Art 58(5) is precisely where the "required conditions of participation ... expressed as minimum levels of ability" live, which makes the two phrases two names for one Art 58 test. STATED PLAINLY BECAUSE IT MATTERS FOR THE MEASUREMENT: this choice is made in the INPUT CONTRACT, not in a rule. The rejected reading needs a profile key this domain does not have, so NO perturbation over this domain's input space can discriminate between the two -- the sealed oracle's rival-reading battery covers the other two readings and CANNOT cover this one. The only discriminator is the profile-key set itself.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

## Provisions deferred, and what follows

??? info "article_heading"

    **Why:** Article 65's own title, "Reduction of the number of otherwise qualified candidates to be invited to participate", carries no obligation: it is the document's structure, not operative law. Deferred so that every unit the pinned extract defines is accounted for, rather than left silently unaccounted.

    **Consequence for a user:** None. A heading states no rule, so nothing turns on it.

