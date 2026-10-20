# Is a framework agreement's term, and a call-off under it, lawful (Directive 2014/24 Art 33)?

`eu/procurement/framework_agreements`

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 199/199 | enforced: 13 units: 12 formalized, 1 deferred (1 authorized, 0 expansion), 0 unaccounted | pass | pass | pass |

## Scope

EU Directive 2014/24/EU Article 33 -- framework agreements. TWO separable determinations, and neither gates the other. (A) FRAMEWORK TERM: is the framework agreement's own term lawful under Art 33(1)? Returns lawful_framework_term, or unlawful_framework_term with every limb the facts defeat -- a term exceeding four years without a duly justified exceptional case (Art 33(1) third subparagraph), and a well-formedness limb for an end date preceding the start date, which is NOT an Article 33 rule and is labelled as such. The four-year limit is measured on the FRAMEWORK's own declared term, from FRAMEWORK_START_DATE to the fourth anniversary of that date, inclusive: a term of exactly four years does not EXCEED four years. (B) CALL-OFF LAWFULNESS AND ROUTE: given the framework's parameters and one proposed call-off, is the call-off lawful, and by which of the routes Art 33(3) and Art ...

## Pinned sources

| Document | Consolidated | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02014L0024 | 2026-01-01 | 2026-08-20 | `707fc3dab41b3e35...` |

[Side-by-side provision report](../reports/eu-procurement-framework_agreements.html){ .md-button }
[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/procurement/framework_agreements){ .md-button }

## Interpretive choices

Where the text admits more than one reading, the domain records the question, the readings and the one it takes.

??? note "four_year_term_measurement_basis"

    Art 33(1) third subparagraph reads "The term of a framework agreement shall not exceed four years". Is the four years measured on the FRAMEWORK's own term -- the period during which contracts may be awarded under it -- or on the whole period over which the framework generates obligations, so that a call-off whose PERFORMANCE runs past the fourth anniversary breaches it too?

    - **framework_term_only** (chosen): The limit binds FRAMEWORK_START_DATE to FRAMEWORK_END_DATE and nothing else. A call-off awarded inside the term may be performed after the term expires, and this domain carries NO call-off performance dates at all -- there is no key for one, so a producer cannot invent a limb that reads it. Matches the drafting: the provision speaks of the term of the AGREEMENT, and Art 33(1)'s definition sentence speaks of "contracts to be awarded during a given period", which is an award window, not a performance window. Risk: a four-year framework whose final call-off is a ten-year concession-like contract ...
    - **framework_term_plus_call_off_performance**, the more conservative reading: The limit binds the whole period over which the framework produces contracts AND those contracts run, so a CALL_OFF_PERFORMANCE_END_DATE key would exist and a call-off performed beyond the fourth anniversary would breach Art 33(1). Safer against the abuse the four-year rule exists to prevent -- a short framework generating long contracts -- and much more restrictive than settled practice. Costly: it condemns the ordinary case of a maintenance contract called off in the framework's final month.

    **Why this reading:** Chosen on the text: Art 33(1) limits "the term of a framework agreement", and the definition two sentences earlier tells us what a term is for -- establishing the terms governing "contracts to be awarded during a given period". A period during which contracts are AWARDED is an award window. NOTE THE DEPARTURE: the conservative reading is `framework_term_plus_call_off_performance` and this domain departs from it. The departure is the reviewable decision. NOTE ALSO HOW THE RIVAL IS REFUTED, because it is not by the battery: the rival is closed off at the INTERFACE -- no call-off performance date is a profile key, so no case can distinguish the two readings and the oracle cannot kill the rival. If a reviewer overturns this entry the fix is a new profile key and a new limb, not a clause edit.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

??? note "call_off_award_window"

    Art 33(1)'s definition sentence speaks of terms "governing contracts to be awarded during a given period" and Art 33(2) of contracts "based on a framework agreement". Neither says in terms that a call-off must be awarded inside the framework's term. Is there an award-window rule at all; if so, is the window CLOSED at both endpoints; and is it the term the framework DECLARES, or that term capped at the four-year limit?

    - **closed_interval_of_the_declared_term** (chosen): The window is [FRAMEWORK_START_DATE, FRAMEWORK_END_DATE] with both endpoints INSIDE, taken from the term the framework as concluded declares. A call-off awarded on the framework's first or last day is in window; one awarded the day before or the day after is not. An over-long framework has ONE defect -- its term -- and its call-offs are judged against the term it actually declares.
    - **half_open_interval**, the more conservative reading: The window excludes the end date, so a call-off awarded on the framework's own last day is out of window. One day stricter, and it makes a zero-length framework incapable of any lawful call-off. No textual support for excluding the final day; it is the convention a reader who thinks in half-open ranges reaches for by habit.
    - **window_capped_at_the_four_year_limit**: The window is the declared term intersected with the four-year limit, so every call-off made in the fifth year of an over-long framework carries an out-of-window defect ON TOP OF the framework's term defect. Attractive as a way to make the four-year rule bite on call-offs; double-counts one wrong as two, and makes the call-off determination depend on the term determination, which this domain otherwise keeps separate.
    - **no_award_window_rule**: Art 33 imposes no award window and the limb does not exist. A call-off awarded years after the framework expired is judged only on the closed-parties and terms limbs. Textually arguable -- the window is read out of a DEFINITION -- and it leaves the four-year rule with no effect at all on call-offs, which cannot be right.

    **Why this reading:** There IS a window: "contracts to be awarded during a given period" is what a framework agreement is for, and a rule limiting the period would be pointless if contracts could be awarded outside it, so `no_award_window_rule` is rejected. The window is CLOSED because a term expressed as two dates ordinarily includes both, and nothing in Art 33 excludes the last day; the conservative `half_open_interval` is departed from for that reason, and because it produces the absurd result that a framework whose start and end dates coincide can never be used. It is the DECLARED term rather than the capped one because the two determinations are deliberately independent: collapsing them means an over-long framework reports two defects for one wrong, and it makes the call-off verdict move when the term verdict moves, which is exactly the coupling the slice split exists to prevent. All three rejected readings are refuted by the oracle's swept case space, not merely argued against, and `sanity_check()` names the first cell each dies on.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

??? note "reopening_availability_under_a_complete_terms_framework"

    Art 33(4) says a several-operator framework "shall be performed in one of the following ways", and its point (c) authorises a reopening "where not all the terms ... are laid down in the framework agreement". May a contracting authority whose framework DOES set out all the terms, and which never stipulated the Art 33(4)(b) partly-with-partly-without possibility, nevertheless reopen competition among the parties?

    - **closed_list_of_three_routes** (chosen), the more conservative reading: It may not. "One of the following ways" is exhaustive: (a) is a direct award, (b) needs the stipulation in the procurement documents, and (c) is conditioned on NOT all the terms being laid down. That combination therefore falls under none of them and the route is `no_lawful_route`, carrying the limb `reopening_not_available_where_framework_sets_out_all_terms`. Strict, and it condemns a practice that is arguably MORE competitive than the direct award the framework did authorise.
    - **reopening_always_permitted**: It may. A reopening is more competitive than a direct award and cannot prejudice the operators, so nothing in Art 33 forbids an authority entitled to award directly from competing the contract instead; point (c) describes the case in which a reopening is COMPULSORY, not the only case in which it is permitted. The route is a lawful `multi_operator_reopened_competition` and the Art 33(5) procedural limbs apply to it. Comfortable in practice; it reads "shall be performed in one of the following ways" as if it said "may".

    **Why this reading:** Chosen as the conservative reading and on the chapeau's own words. Art 33(4) is drafted as an exhaustive trichotomy and point (b) exists precisely to give an authority the option the rival would grant for free -- if reopening were always available under a complete-terms framework, point (b) would have nothing to do, because its whole content is permission to mix the two routes plus the documentation duties that come with that permission. The rival's practical merit is real and is why this is registered rather than assumed: an authority that competes what it could have awarded directly harms nobody. A reviewer overturning this entry changes ONE branch of the route rule and one limb; the Art 33(5) limbs then apply to the newly lawful reopening automatically, because they are scoped on the ROUTE.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

??? note "substantial_modification_limb_and_article_72"

    Art 33(2) third subparagraph forbids a call-off entailing "substantial modifications to the terms laid down in that framework agreement". Is substantiality here the same test as Art 72(4)'s -- the four in-any-event limbs about admitting other candidates, the economic balance, the extension of scope and the replacement of the contractor -- to be run inside this domain, or is it a judgement this domain takes as given?

    - **atomic_input_here** (chosen), the more conservative reading: `call_off_entails_substantial_modification` is a single boolean the caller supplies, and this domain neither derives it nor second-guesses it. The Art 33(2) limb fires on it directly. Keeps the two articles' determinations separate and does not silently import a test the Directive states for a different question (modification of a contract DURING its term, not the making of a contract UNDER a framework). The cost is stated in the Art 72 excluded_set entry: a caller who answers it wrong gets a confident wrong verdict and nothing here can detect it.
    - **delegate_to_art_72_substantiality_limbs**: The four Art 72(4) limbs are run against the call-off and the framework as the reference contract, and the Art 33(2) limb fires where any of them holds. Gives the caller a real test instead of a boolean, and gives the two articles one coherent notion of substantiality. But it imports four more atomic inputs (each of the Art 72(4) limbs is itself open-textured), it duplicates eu/procurement/contract_modifications, and it asserts an identity between two provisions that the Directive does not state -- Art 33(2) says "substantial modifications to the terms", Art 72(4) defines when "a modification ...

    **Why this reading:** Chosen as the conservative reading, and on the ground that the rival asserts an identity the text does not: a call-off is a contract MADE UNDER the framework, not a modification OF it, so Art 72(4)'s definition is at best an analogy. Taking the judgement as an atomic input is the same posture this domain takes to Art 33(1)'s "duly justified exceptional case" and Art 33(5)(b)'s "sufficiently long" -- it hands open texture to the user rather than inventing a crisp test. RESIDUAL HOLE, stated rather than hidden: this leaves the single most consequential input in the domain entirely unverified, and a caller with an interest in the answer supplies it. A reviewer who overturns this should expect the change to reach the profile contract, not just a clause.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

??? note "anti_abuse_principle_is_not_an_operative_condition_of_art_33"

    Directive 2004/18/EC Art 32(2) second subparagraph ended the framework-agreements article with "Contracting authorities may not use framework agreements improperly or in such a way as to prevent, restrict or distort competition". Directive 2014/24/EU's Article 33 does not carry that sentence. Should this domain nevertheless test an anti-abuse condition as part of Article 33, reading the principle back in from the predecessor and from recital 61?

    - **not_an_operative_condition_of_article_33** (chosen): No such limb exists here. The domain has no `used_improperly` input, no intention input, and returns `call_off_lawful` on facts that Art 18(1) would condemn. The consequence for a caller is written out in excluded_set[principles_of_procurement_and_the_anti_abuse_rule]: a lawful verdict from this domain is not a finding that the framework was used properly. Faithful to the pinned bytes, and it keeps the determination testable -- every one of the 21 inputs is a fact about what was done, not about why.
    - **read_the_anti_abuse_rule_into_article_33**, the more conservative reading: An `improper_use_of_the_framework_agreement` limb is added, taking an atomic input, and any call-off ticked improper is unlawful under Art 33 itself. Catches the abuse case inside this domain instead of deferring it, which is safer for a caller who runs only this article. But it formalizes as Article 33 a sentence that Article 33 does not contain, and it makes the domain's verdict turn on an unfalsifiable input about the authority's intention -- which is precisely the shape of finding that Art 18(1) reserves to itself ("made with the INTENTION of ...").

    **Why this reading:** VERIFIED AGAINST THE PINNED BYTES, not asserted: the word "improperly" does not occur anywhere in the consolidated act, and "distort competition" occurs exactly once, in Art 30(6) about competitive dialogue. The 2004 sentence was not carried into Article 33; its content lives in Art 18(1) second subparagraph, which this domain excludes with a stated consequence. Note that the consolidated Formex manifestation carries an EMPTY <PREAMBLE>, so recital 61 is not in the pinned document either and cannot be cited from it -- which is a further reason not to found a limb on it. DEPARTURE FROM THE CONSERVATIVE READING, and it is deliberate: the rival is "safer" only in the sense that it condemns more, and a limb whose input is the authority's own intention, self-reported, is not a check. This entry exists because the Wave-3 commission brief for this domain attributed the 2004 sentence to Art 33(1) of the 2014 Directive and asked for the choice to be registered rather than settled silently. It is registered, and the premise is corrected.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

??? note "which_art_33_4_subparagraph_each_call_off_route_cites"

    Art 33(4) offers three ways to award a call-off under a several-operator framework: (a) without reopening, on the terms of the framework; (b) partly without and partly with reopening; (c) with reopening, where not all the terms are laid down. This domain implements a route it calls multi_operator_direct_award_under_split_framework, selected when partly_with_partly_without_reopening_stipulated is true, and cites Art 33(4)(a) for BOTH of that route's defect limbs (direct_award_without_all_terms_set_out and objective_conditions_for_determining_performer_not_indicated). Art 33(4)(c) is imported by the logic module and cited by NO limb at all. Separately, the limb reopening_not_available_where_framework_sets_out_all_terms cites the Art 33(4) CHAPEAU rather than any sub-paragraph. Three questions on one provision. Does the split route take its all-terms and objective-conditions requirements from (a), as written, or from (b), the sub-paragraph that names that route? Does the reopening-unavailable limb rest on (c)? And is (c) genuinely inapplicable to this domain, or is its absence the symptom?

    - **subparagraph_a_supplies_the_direct_award_conditions** (chosen): As written. (a) supplies the conditions on any DIRECT award (all terms set out, objective conditions indicated) and (b) supplies only the route-choice and reopening-terms duties, because the split route makes direct awards for part of its volume. (c) is then genuinely inapplicable here: it governs reopening where the framework does NOT lay down all terms, and the reopening limb this domain has is about the converse case. The unused import is dead weight to delete, and the chapeau citation on reopening_not_available_where_framework_sets_out_all_terms is right because no single sub-paragraph ...
    - **each_route_cites_its_own_subparagraph**, the more conservative reading: Each route cites the sub-paragraph that names it. The split route's limbs move from (a) to (b); the reopening-unavailable limb moves from the chapeau to (c); the unused import becomes used. A reader following a citation then lands on the sub-paragraph describing the route that actually fired rather than one describing a different way of awarding. Safer in the sense that matters for a citation: it cannot send a reader to a provision about a route the case did not take.

    **Why this reading:** RAISED BY TOOLING, NOT ADJUDICATED. check_citations refused promotion of the 2026-08-24 re-run with "eu_dir_2014_24_art_33_4_c: citation record but atom never cited", which is how the unused import surfaced. Nobody has decided which sub-paragraph governs; this records the question, not an answer. ESTABLISHED: the route is selected by partly_with_partly_without_reopening_stipulated; its two limbs cite (a); (b) is cited by two OTHER limbs (objective_criteria_for_choice_of_route_not_stated, terms_subject_to_reopening_not_specified); (c) is cited nowhere; and this domain's own verified citations-sources.yaml labels (b) "partly without and partly with reopening of competition" and (c) "reopening competition where not all the terms are laid down". NOT ESTABLISHED: which provision a reviewer would say each limb rests on. THE ORACLE IS NOT EVIDENCE EITHER WAY: the re-run scored 1423/1423 with zero refutations while citing as described, because the harness compares the citation atoms the rulebase emits against those the reference expects, so a reference making the same attribution agrees with it. Green means the two halves of the seal concur, not that the attribution is right. THE VERSION ON MAIN IS COARSER, NOT BETTER: it cites the undifferentiated eu_dir_2014_24_art_33_4 six times and never mentions (a), (b) or (c) at all. Whichever way this is answered, apply the answer to both.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

## Provisions deferred, and what follows

??? info "article_heading"

    **Why:** Article 33's own title, "Framework agreements", carries no obligation: it is the document's structure, not operative law. Deferred so that every unit the pinned extract defines is accounted for, rather than left silently unaccounted.

    **Consequence for a user:** None. A heading states no rule, so nothing turns on it.

