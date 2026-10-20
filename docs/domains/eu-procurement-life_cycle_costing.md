# Is a life-cycle costing method valid, and what does it compute (Art 68)?

`eu/procurement/life_cycle_costing`

| Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|
| 234/234 | enforced: 15 units: 13 formalized, 2 deferred (2 authorized, 0 expansion), 0 unaccounted | pass | pass | pass |

## Scope

EU Directive 2014/24/EU Article 68 -- life-cycle costing. THREE separable determinations over ONE procurement's declared life-cycle costing approach; none gates another. (A) METHOD VALIDITY: is the approach lawful? Returns valid_lcc_method, or invalid_lcc_method with EVERY Art 68 limb the facts defeat -- an environmental externality cost whose monetary value cannot be determined and verified (Art 68(1)(b) proviso); procurement documents that fail to indicate the data tenderers must provide, or the method the authority will use (Art 68(2) first alinea, two separate limbs); and the three cumulative conditions Art 68(2) second alinea imposes on the method used to assess externality costs -- objectively verifiable criteria and non-discriminatory criteria (two limbs from point (a) sentence 1), no undue favour or disadvantage where the method was not established for repeated or continuous ...

## Pinned sources

| Document | Consolidated | Fetched | SHA-256 (extract) |
|---|---|---|---|
| CELEX 02014L0024 | 2026-01-01 | 2026-08-20 | `8db7c50b81a128c8...` |
| CELEX 02014L0024 | 2026-01-01 | 2026-08-20 | `c01729e7fd182ac1...` |

[Side-by-side provision report](../reports/eu-procurement-life_cycle_costing.html){ .md-button }
[Source on GitHub](https://github.com/neurosymbolica/clausal-rules-as-code/blob/main/eu/procurement/life_cycle_costing){ .md-button }

## Interpretive choices

Where the text admits more than one reading, the domain records the question, the readings and the one it takes.

??? note "art_68_1_a_categories_are_illustrative"

    Art 68(1)(a) reads "costs, borne by the contracting authority or other users, such as: (i) costs relating to acquisition, (ii) costs of use ... (iii) maintenance costs, (iv) end of life costs ...". Is that four-item list EXHAUSTIVE of the authority-side costs an Article 68 life-cycle costing may cover, or ILLUSTRATIVE, so that a fifth kind of cost borne by the authority or other users is equally coverable?

    - **illustrative** (chosen): The cost-category vocabulary carries a sixth atom, `other_cost_borne_by_authority_or_users`, and a component declared under it is admissible and enters the total like any other. A caller costing, say, insurance or decommissioning liability over the life cycle has somewhere to put it. The price is that the atom is a catch-all whose contents this domain cannot inspect: whether the cost is really borne by the authority or other users, and really falls within the Art 2(1)(20) life cycle, is the caller's judgement.
    - **exhaustive**, the more conservative reading: Only the four named categories are Article 68(1)(a) costs. A cost outside them is excluded from the total and reported as an excluded category. Safer in the sense that it condemns more and admits less -- it cannot be used to smuggle an arbitrary figure into a life-cycle cost under a category nobody can check. Costly because it refuses to cost things the Directive plainly permits to be costed, and because it leaves a caller with a genuine fifth cost no lawful place to declare it.

    **Why this reading:** "SUCH AS" IS EXPRESS. The Directive uses it twice inside this very point -- once to introduce the four sub-points and once inside (ii) ("such as consumption of energy and other resources") -- and again in (iv) and in (b). Reading an express illustration as exhaustive is not conservatism, it is an error, and the fact that the conservative label sits on the rival is a fact about which side condemns more, not about which side is right. NOTE THE DEPARTURE ANYWAY: this domain leaves the reading marked conservative, and that is the reviewable decision. If it is overturned, the fix is to delete one member of `lcc_cost_category/1` and one clause of `lcc_component_admissibility/3`; nothing else moves.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

??? note "art_68_2_a_undue_favour_is_an_independent_limb"

    Art 68(2)(a) reads "it is based on objectively verifiable and non-discriminatory criteria. In particular, where it has not been established for repeated or continuous application, it shall not unduly favour or disadvantage certain economic operators". Is the second sentence an INDEPENDENT obligation, breachable by an ad-hoc method whose criteria are nevertheless objectively verifiable and non-discriminatory -- or is "in particular" a SPECIFICATION of the non-discrimination requirement, so that a non-discriminatory method cannot breach it?

    - **independent_limb** (chosen), the more conservative reading: A method that was not established for repeated or continuous application, and that unduly favours or disadvantages certain economic operators, is defective under Art 68(2)(a) EVEN IF the caller has certified its criteria non-discriminatory. The defect `undue_favour_or_disadvantage_of_economic_operators` is reported on its own. The two caller-supplied judgements stay independent, so a defect report says which one failed. NOTE THE SPELLING: the defect id is deliberately NOT the profile key it reads (`externality_method_unduly_favours_or_disadvantages_operators`). Every other limb's key and ...
    - **illustrative_of_non_discrimination**: The second sentence does no work of its own: where the criteria are certified non-discriminatory the undue-favour limb cannot fire, and where they are not, the discrimination limb has already fired. The sentence collapses into a gloss. Textually attractive -- "in particular" ordinarily introduces an instance rather than an addition -- but it makes a whole sentence of the Directive inert, and it lets one caller-asserted boolean (non-discrimination), which this domain cannot verify, switch off a check.

    **Why this reading:** Two reasons, and the second is the one that decides it. FIRST, the second sentence carries its OWN condition -- "where it has not been established for repeated or continuous application" -- which the first sentence does not. A pure gloss does not need a scope condition of its own; a distinct obligation does, and this one has one. SECOND, and decisively, a reading whose effect is "an unverifiable caller assertion disables a statutory check" is the less safe one whatever its textual merit -- the same test the Wave-2 Art 67 sibling applied to its own fixed-price question. The rival has the better claim on the ordinary sense of "in particular", and this entry exists because that is not obviously outweighed. RESIDUAL HOLE, stated rather than hidden: on the chosen reading a method ESTABLISHED for repeated or continuous application can unduly favour an operator with no Art 68(2)(a) defect at all, because the sentence's own condition excludes it. That is what the text says; a reviewer who finds it intolerable should look at Art 18(1)'s general equal-treatment principle, which this domain does not pin.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

??? note "art_68_3_annex_xiii_is_declaratory"

    Art 68(3) reads "Whenever a common method for the calculation of life-cycle costs has been made mandatory by a legislative act of the Union, that common method shall be applied ... A list of such legislative acts ... is set out in Annex XIII." Does the duty follow the UNION ACT -- so a Union act that makes a method mandatory but is not (yet) in Annex XIII triggers it -- or does it follow the LIST, so that only a listed act can?

    - **declaratory** (chosen), the more conservative reading: `lcc_mandatory_method_status/3` treats any Union act the caller names as triggering the duty, listed or not, and `lcc_union_act_listing/2` reports the Annex XIII status separately without changing the verdict. An authority that ignores a newly-imposed Union method is reported as defective from the day that method binds, not from the day the Commission gets round to amending the annex.
    - **constitutive**: Only an act named in Annex XIII triggers the duty. `annex_xiii_act/1` becomes the gate rather than a report, and an unlisted act yields `no_union_common_method_mandatory`. Predictable, and it gives the annex a job. But it makes the duty depend on administrative housekeeping rather than on law, and -- see below -- it makes Art 68(3) a dead letter on the text in force today.

    **Why this reading:** THE SECOND ALINEA ARGUES AGAINST ITSELF AS A GATE. It empowers the Commission to update the list "WHEN AN UPDATE OF THE LIST IS NECESSARY DUE TO the adoption of new legislation making a common method mandatory or the repeal or modification of existing legal acts" -- so the list FOLLOWS the legislation, and a lag between them is contemplated by the provision itself. A gate that the drafter expects to be out of date is a signpost. Sentence 1 is also self-contained: it conditions the duty on the act, and mentions the list only in the sentence after. AND THE FACT MAKES THIS LOAD-BEARING RATHER THAN ACADEMIC: the sole act on the list, Directive 2009/33/EC, lost its costing methodology when Article 1(7) of Directive (EU) 2019/1161 deleted its Articles 6 and 7, and Annex XIII has never been updated. On the constitutive reading Art 68(3) therefore commands nothing at all today; on the declaratory reading it revives the moment any Union act imposes a method. See the fourth `sources:` entry for the verification. RESIDUAL HOLE: this reading puts the whole weight on the caller's `union_common_method_act_key`, which this domain cannot check. A caller who names `directive_2009_33_ec` merely because it is the Annex XIII entry -- not because that act imposes anything today -- will get a confident `union_common_method_mandatory_and_not_applied`, and nothing here can tell that from the real thing.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

??? note "art_68_1_b_unverifiable_externality_is_excluded_not_fatal"

    Art 68(1)(b) admits externality costs "provided their monetary value can be determined and verified". Where a declared externality component fails that proviso, does the COMPONENT drop out of the life-cycle cost, leaving the rest of the sum standing -- or is the life-cycle cost itself unavailable?

    - **component_excluded** (chosen): `lcc_component_admissibility/3` returns `component_excluded` for that component alone; the total is the sum of the rest, the status is `lcc_computed`, and the excluded category is REPORTED in the verdict so the omission is visible rather than silent. The Art 68(1)(b) defect is reported separately by the validity slice, so the caller learns both that the method is defective and what the lawful part of the cost comes to.
    - **costing_is_indeterminate**, the more conservative reading: Any unverifiable externality component makes the whole computation `lcc_indeterminate` with a total of 0. Safer in that it never returns a number derived from a breakdown it has just called defective; costly in that it discards a lawful acquisition-and-maintenance figure the caller can compute perfectly well, and gives a caller nothing to act on.
    - **included_anyway**: The proviso is treated as addressed to the authority's method design rather than to the sum, so the component is counted and the defect merely reported. Rejected outright: it produces a life-cycle cost that includes a figure the Directive says may not be included, which is the one outcome the proviso exists to prevent.

    **Why this reading:** The proviso is drafted as a condition on WHAT (b) COVERS -- "costs imputed to environmental externalities ... provided their monetary value can be determined and verified" -- not as a condition on the exercise as a whole. So the natural effect is on the item, and the rest of Art 68(1)'s categories are untouched by it. This also keeps the three determinations independent, which is this domain's design commitment: the defect is reported by the validity slice and the number by the computation slice, and neither gates the other. NOTE THE DEPARTURE: the conservative reading is `costing_is_indeterminate` and this domain departs from it. The departure is defensible only because the exclusion is REPORTED -- the verdict names the excluded category, so a caller who wants the conservative behaviour can implement it in one line by refusing any verdict whose excluded-category list is non-empty. If the reporting were dropped, this choice would become indefensible.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

??? note "art_68_3_displacement_does_not_switch_off_art_68_2"

    Where Art 68(3) makes a Union common method mandatory, so that the authority's own method is displaced, do the Art 68(2) second-alinea conditions still bite on the method actually used -- or does the Union legislator's own choice of method settle them, leaving only the Art 68(2) first-alinea duty to indicate the data and the method?

    - **conditions_always_assessed** (chosen), the more conservative reading: `decide_lcc_method_validity/2` never reads `union_common_method_act_key` or `union_common_method_applied` at all. The nine limbs are assessed on whatever method is in front of them. A caller gets two independent verdicts and composes them. The discomfort, stated plainly: on this reading the domain can report a method mandated by a Union legislative act as failing an Art 68(2) condition -- which is a coherent thing for a court to say about a national authority's application of it, and an odd thing to say about the Union act itself.
    - **displacement_switches_them_off**: Where a Union common method is mandatory, the three conditions are not assessed and only the first-alinea indication duties remain. Tidier, and arguably right that the Union legislator has already made the judgement Art 68(2)(a)-(c) asks the authority to make. But it lets `union_common_method_act_key` -- a caller-supplied atom this domain cannot verify, and which today names an act with no method in it -- switch off six statutory checks at once.

    **Why this reading:** Chosen on the same test as the second entry above, and for the same reason: a reading whose effect is "an unverifiable caller assertion disables a statutory check" is the less safe one, and here it disables six at once. Art 68(2)'s conditions are addressed to "the method used for the assessment of costs imputed to environmental externalities" without any carve-out for a method the Union has mandated, and Art 68(3) says only that the common method "shall be applied" -- it does not say the conditions cease to apply to it. Keeping the slices independent is also what makes the domain's three verdicts composable at all: a caller wanting the rival's behaviour can implement it by ignoring the validity verdict whenever the mandatory-method verdict says a Union method applies, which is one line and is reversible; the reverse is not.

    **Authority cited:** none (a reading of the text alone). **Reviewed by a lawyer:** not yet.

## Provisions deferred, and what follows

??? info "article_heading"

    **Why:** Article 68's own title, "Life-cycle costing", carries no obligation: it is the document's structure, not operative law. Deferred so that every unit the pinned extract defines is accounted for, rather than left silently unaccounted.

    **Consequence for a user:** None. A heading states no rule, so nothing turns on it.

??? info "annex_heading"

    **Why:** The bare "ANNEX XIII" title of the annex container. The annex's operative content -- the heading "LIST OF UNION LEGAL ACTS REFERRED TO IN ARTICLE 68(3)" together with the one act it names -- is the SECOND unit of that extract and is formalized (annex_xiii_act/1, cited at eu_dir_2014_24_annex_xiii). This unit is the container's own label and states no rule.

    **Consequence for a user:** None. A heading states no rule. Note that this is the only unit either pin contributes that carries no legal content of its own; a reviewer checking whether the Annex XIII pin earns its place should look at the OTHER unit.

