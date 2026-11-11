"""Limited, transparent Python baseline over supplied facts, NOT a legal oracle.

The functions neither load gold labels nor branch on case IDs. Legal qualifiers
such as necessity/risk remain supplied assumptions, not independently inferred law.
"""
import calendar
from datetime import date


def both(*values):
    return False if False in values else (None if None in values else True)


def either(*values):
    return True if True in values else (None if None in values else False)


def neg(value):
    return None if value is None else not value


def add_months(value, count):
    day = date.fromisoformat(value)
    total = day.year * 12 + day.month - 1 + count
    year, month = divmod(total, 12)
    return date(year, month + 1, min(day.day, calendar.monthrange(year, month + 1)[1]))


def evaluate(rule, facts):
    def b(key):
        value = facts.get(key)
        if value is not None and type(value) is not bool:
            raise ValueError(f"{key} must be boolean or null")
        return value

    def choice(key, allowed):
        value = facts.get(key)
        if value is not None and value not in allowed:
            raise ValueError(f"Invalid {key}")
        return value

    def result(value, reason, citations, actions=()):
        decision = {True: "yes", False: "no", None: "unknown"}.get(value, value) if not isinstance(value, str) else value
        return decision, reason, citations, list(actions)

    if rule == "territorial_scope":
        v = either(b("eu_establishment_context"), b("offers_to_people_in_eu"), b("monitors_behaviour_in_eu"))
        return result(v, "Article 3(1)/(2): assess establishment context, targeted offerings or behavioural monitoring in the Union; an unresolved connecting factor remains unresolved.", ["GDPR Art. 3(1)", "GDPR Art. 3(2)"])
    if rule == "contract_basis":
        v = both(either(b("person_is_contract_party"), b("requested_precontractual_steps")), b("processing_needed_for_purpose"))
        return result(v, "Article 6(1)(b) requires objective necessity for a contract with the person or pre-contractual steps at their request.", ["GDPR Art. 6(1)(b)"])
    if rule == "legitimate_interest":
        if b("equally_effective_less_intrusive_option") is True:
            v = False
        else:
            v = "conditional"  # Four booleans cannot substitute a proportionality judgment.
        return result(v, "Assess legitimate interest, necessity and balancing separately. An equally effective, less intrusive alternative defeats necessity; favourable indicators alone do not determine the balance.", ["GDPR Art. 6(1)(f)"], ["Document the interest, alternatives, expectations and consequences."])
    if rule in {"consent_validity", "special_category_processing"}:
        uncoupled = neg(both(b("service_depends_on_consent"), neg(b("consent_processing_needed_for_service"))))
        if rule == "consent_validity":
            v = both(b("affirmative_action"), b("purpose_specific"), b("informed"), uncoupled)
            return result(v, "Consent requires an informed, purpose-specific, unambiguous and freely given indication; unnecessary conditionality is unjustified on the stipulated facts.", ["GDPR Art. 4(11)", "GDPR Art. 7(4)"])
        consent = both(b("explicit_consent"), uncoupled)
        care = both(b("care_purpose"), b("health_law_or_professional_contract"), b("professional_secrecy"))
        v = both(b("article_six_basis_identified"), either(consent, care))
        return result(v, "Alongside Article 6, an exception to Article 9(1) is required: here valid explicit consent or care under Article 9(2)(h) with professional secrecy under paragraph 3. Other exceptions are not modelled.", ["GDPR Art. 6(1)", "GDPR Art. 9(2)(a)", "GDPR Art. 9(2)(h)", "GDPR Art. 9(3)"], ["Substantiate the specific legal basis and, where consent is used, its freely given nature for each purpose."])
    if rule == "consent_withdrawal":
        return result(both(b("withdrawal_received"), b("consent_is_only_basis")), "Withdrawal ends future processing based solely on consent; processing that was lawful before withdrawal is unaffected. Assess other purposes separately.", ["GDPR Art. 7(3)", "GDPR Art. 17(1)(b)"], ["Implement withdrawal and distinguish remaining retention purposes."])
    if rule == "rights_deadline":
        received, proposed = facts.get("received_date"), facts.get("proposed_response_date")
        if received is None or proposed is None:
            v = None
        else:
            end, response = add_months(received, 1), date.fromisoformat(proposed)
            if response < date.fromisoformat(received):
                raise ValueError("Response precedes request")
            if response <= end:
                v = True
            elif response > add_months(received, 3):
                v = False
            else:
                notice = facts.get("extension_notice_date")
                timely_notice = None if notice is None else date.fromisoformat(received) <= date.fromisoformat(notice) <= end
                v = both(b("complex_or_numerous"), b("notice_explains_delay"), timely_notice)
        return result(v, "The ordinary period is one calendar month, still without undue delay. Up to two further months are permitted only where necessary because of complexity or number of requests, with a reasoned notice in the first month. This is not a fixed 30-day period; weekend and holiday rules are not modelled.", ["GDPR Art. 12(3)"], ["Document receipt, the deadline and any necessary extension."])
    if rule == "erasure":
        grounds = either(b("purpose_ended"), b("consent_withdrawn_without_other_basis"))
        exception = either(b("statutory_retention"), b("needed_for_legal_claims"))
        return result(both(grounds, neg(exception)), "Assess an erasure ground under Article 17(1)(a)/(b) and necessary exceptions for statutory duties or legal claims separately for each dataset; no blanket indefinite retention.", ["GDPR Art. 17(1)(a)", "GDPR Art. 17(1)(b)", "GDPR Art. 17(3)(b)", "GDPR Art. 17(3)(e)"], ["Erase data eligible for erasure; restrict data covered by an exception to the necessary purpose."])
    if rule == "portability":
        basis = choice("basis", {"consent", "contract", "legitimate_interest", "legal_obligation"})
        v = both(b("provided_by_person"), b("automated_processing"), None if basis is None else basis in {"consent", "contract"})
        return result(v, "Article 20 requires provided data, automated processing and consent or contract. Purely derived internal assessments are not provided data here; assess third-party rights and direct transmission separately.", ["GDPR Art. 20(1)", "GDPR Art. 20(2)", "GDPR Art. 20(4)"])
    if rule == "direct_marketing_objection":
        return result(both(b("direct_marketing"), b("objection_received")), "An objection ends direct-marketing processing, including related profiling; no further balancing of interests applies to this purpose.", ["GDPR Art. 21(2)", "GDPR Art. 21(3)"], ["Block the advertising purpose and assess necessary minimal documentation of the objection."])
    if rule == "joint_control":
        return result(both(b("decide_purpose_together"), b("decide_essential_means_together")), "Joint decisions on purposes and essential means for the specific operation establish joint control; contractual labels alone do not determine the role.", ["GDPR Art. 4(7)", "GDPR Art. 26(1)"], ["Agree responsibilities transparently and make the essence of the arrangement available."])
    if rule == "subprocessor_engagement":
        auth = choice("written_authorization", {"specific", "general", "none"})
        permission = None if auth is None else (False if auth == "none" else True if auth == "specific" else both(b("change_notice_sent"), b("objection_opportunity")))
        v = both(permission, b("equivalent_data_protection_obligations"), neg(b("controller_objected")))
        return result(v, "Specific or general written authorisation is required. General authorisation requires notice of changes and an opportunity to object; pass on equivalent data protection obligations. Resolve an expressed objection before engagement.", ["GDPR Art. 28(2)", "GDPR Art. 28(4)"])
    if rule == "security_controls":
        exposed = both(b("public_access"), b("readable_sensitive_data"))
        no_access_control = both(b("readable_sensitive_data"), neg(b("individual_access_controls")))
        v = False if either(exposed, no_access_control) is True else "conditional"
        return result(v, "Article 32 requires technical and organisational measures appropriate to risk. Publicly readable sensitive data or absent access controls are clear deficiencies; individual positive measures do not establish overall adequacy.", ["GDPR Art. 32(1)", "GDPR Art. 32(2)"], ["Assess access, key separation, restoration and effectiveness against the risk."])
    if rule in {"breach_authority", "breach_communication"}:
        risk = choice("risk_assessment", {"unlikely", "risk", "high"})
        if rule == "breach_authority":
            v = both(b("personal_data_breach"), None if risk is None else risk != "unlikely")
            return result(v, "Article 33: notify unless risk is unlikely; act without undue delay and, where feasible, within 72 hours of awareness. Missing detailed figures permit phased updates. Explain delay and document all breaches.", ["GDPR Art. 33(1)", "GDPR Art. 33(3)", "GDPR Art. 33(4)", "GDPR Art. 33(5)"], ["Document risk and time of awareness; do not postpone a required initial notification until the investigation is complete."])
        exceptions = either(b("data_unintelligible"), b("later_measures_avert_high_risk"), b("individual_contact_disproportionate"))
        v = both(b("personal_data_breach"), None if risk is None else risk == "high", neg(exceptions))
        return result(v, "Article 34: generally communicate clearly and without undue delay where risk is high. Unintelligibility to unauthorised people or effective subsequent removal of high risk can provide exceptions; disproportionate individual contact requires equally effective public communication.", ["GDPR Art. 34(1)", "GDPR Art. 34(2)", "GDPR Art. 34(3)"], ["Document communication or a valid exception, including substitute communication where required."])
    if rule == "impact_assessment":
        v = either(both(b("systematic_extensive_evaluation"), b("automated_basis"), b("significant_decisions")), both(b("special_or_criminal_data"), b("large_scale")), both(b("systematic_public_monitoring"), b("large_scale")), b("other_high_risk_indicators"))
        return result(v, "Likely high risk requires a DPIA before processing; Article 35(3) covers extensive automated evaluations supporting significant decisions, large-scale special-category data and large-scale systematic public monitoring. Supervisory-authority lists and national additions also require assessment.", ["GDPR Art. 35(1)", "GDPR Art. 35(3)"], ["Assess risks and safeguards before launch; consider Article 36 if high residual risk remains."])
    if rule == "data_protection_officer":
        v = either(both(b("public_authority"), neg(b("court_judicial_capacity"))), both(b("monitoring_core_activity"), b("regular_systematic_monitoring"), b("large_scale_monitoring")), both(b("special_data_core_activity"), b("large_scale_special_or_criminal_data")))
        return result(v, "Article 37(1) concerns public bodies (except courts acting judicially), large-scale regular systematic monitoring as a core activity, or large-scale special-category or criminal-offence data as a core activity; the GDPR has no general employee-number threshold.", ["GDPR Art. 37(1)", "GDPR Art. 37(4)"])
    if rule == "international_transfer":
        transfer = both(b("separate_non_eea_recipient"), b("recipient_has_data_access"))
        basis = either(b("adequacy_covers_recipient"), both(b("safeguards_in_place"), b("effective_protection_assessed")), b("derogation_applies"))
        v = "not_applicable" if transfer is False else both(transfer, basis)
        return result(v, "Access by a separate third-country recipient requires a valid Chapter V route: applicable adequacy, appropriate effective safeguards or a narrowly limited derogation. EU server location alone is insufficient.", ["GDPR Art. 44", "GDPR Art. 45", "GDPR Art. 46", "GDPR Art. 49"], ["Assess the recipient, access, legal basis and effectiveness of safeguards."])
    if rule == "automated_decision":
        covered = both(neg(b("meaningful_human_review_before_effect")), b("legal_or_similarly_significant_effect"))
        exception = either(b("necessary_for_contract"), b("authorized_by_law"), b("explicit_consent"))
        special_ok = either(neg(b("uses_special_categories")), b("special_category_exception_applies"))
        valid_exception = both(exception, b("safeguards_in_place"), special_ok)
        return result(both(covered, neg(valid_exception)), "Article 22 protects against solely automated significant decisions. Assess a valid exception and safeguards separately, including Article 22(4) for special categories; rubber-stamping is not an effective human decision.", ["GDPR Art. 22(1)", "GDPR Art. 22(2)", "GDPR Art. 22(3)", "GDPR Art. 22(4)"], ["Enable meaningful human intervention, expression of the person's viewpoint and contesting the decision."])
    if rule == "fine_cap":
        articles, turnover, proposed = (facts.get(k) for k in ("infringed_articles", "worldwide_prior_year_turnover_eur", "proposed_fine_eur"))
        if articles is None or turnover is None or proposed is None:
            return result(None, "The infringement category, preceding year's turnover or comparison amount is missing.", ["GDPR Art. 83(4)", "GDPR Art. 83(5)"])
        if not isinstance(articles, list) or not articles or any(type(a) is not int for a in articles) or any(type(v) is not int or v < 0 for v in (turnover, proposed)):
            raise ValueError("Fine inputs must be nonnegative integer EUR and article list")
        higher = set(range(5, 10)) | set(range(12, 23)) | set(range(44, 50))
        lower = {8, 11} | set(range(25, 40)) | {42, 43}
        # Art. 8 is expressly listed in paragraph 4(a), not treated as a paragraph 5 principle here.
        higher.discard(8)
        if any(a not in higher | lower for a in articles):
            return result(None, "The specified infringement category is not formalised in this limited baseline.", ["GDPR Art. 83(4)", "GDPR Art. 83(5)"])
        rate, fixed = (4, 20000000) if set(articles) & higher else (2, 10000000)
        ceiling_times_100 = max(fixed * 100, turnover * rate)
        return result(proposed * 100 <= ceiling_times_100, f"Abstract ceiling: max(EUR {fixed}, {rate}% of the preceding year's worldwide turnover). The higher amount applies; whether to impose a fine and its actual amount follow Article 83(1)–(3), not automatically the maximum.", ["GDPR Art. 83(1)", "GDPR Art. 83(2)", f"GDPR Art. 83({5 if rate == 4 else 4})"])
    raise ValueError(f"Unsupported baseline rule: {rule}")


def answer_case(case):
    answers = []
    for q in case["questions"]:
        decision, reason, citations, actions = evaluate(q["rule"], q["facts"])
        answers.append({"question_id": q["id"], "decision": decision, "reasoning": reason,
                        "citations": citations, "missing_facts": [key for key, value in q["facts"].items() if value is None], "actions": actions})
    return {"answers": answers}
