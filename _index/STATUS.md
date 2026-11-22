# Status of each domain

Generated at export by running, in this repository, each domain's tests and the public
validators (`_tools/check_citations.py`, `check_parameters.py`, `check_provisions.py`,
`check_provenance.py`). Provision tracking shows the ledger's own headline: how many
units of the pinned statute extract are formalized, deferred and unaccounted.

Hidden-test results (reference implementation, mutation testing, adversarial review) are
not listed yet; they will be added per domain in the next release.

The 8 domains of the first release have a provision-tracking ledger. The domains added on 2026-11-16, 2026-11-18, 2026-11-20, 2026-11-21 and 2026-11-22 do not: their provision tracking is "none", and no check accounts for the share of the statute they cover. `check_provisions.py` is not run for them.


| Domain | Tests passed | Provision tracking | Citations | Parameters | Provenance |
|---|---|---|---|---|---|
| `ch/swiss_fadp_art24_breach_notification` | 192/192 | none (no provision-tracking ledger) | pass | pass | pass |
| `ch/swiss_fadp_s1_international_transfers` | 193/193 | none (no provision-tracking ledger) | pass | pass | pass |
| `ch/swiss_fadp_s2_information_duties_and_dpia` | 189/189 | none (no provision-tracking ledger) | pass | pass | pass |
| `ch/swiss_fadp_s3_right_of_access` | 272/272 | none (no provision-tracking ledger) | pass | pass | pass |
| `ch/swiss_fadp_s4_criminal_provisions` | 189/189 | none (no provision-tracking ledger) | pass | pass | pass |
| `cn/pipl_handler_duties` | 204/204 | none (no provision-tracking ledger) | pass | pass | pass |
| `cn/pipl_individual_rights` | 199/199 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/ai_act/deployer_duties_fria` | 207/207 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/ai_act/gpai_models` | 282/282 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/ai_act/high_risk_requirements` | 194/194 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/ai_act/penalties` | 226/226 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/ai_act/post_market_monitoring` | 213/213 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/ai_act/provider_side_duties` | 187/187 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/ai_act/scope_and_roles` | 267/267 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/ai_act/serious_incident_reporting` | 262/262 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/ai_act/small_items` | 300/300 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/ai_act/transparency_art50` | 250/250 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/aml/amlr_beneficial_ownership_threshold` | 106/106 | enforced: 13 units: 3 formalized, 10 deferred (9 authorized, 1 expansion), 0 unaccounted | pass | pass | pass |
| `eu/aml/amlr_bo_chain` | 84/84 | enforced: 10 units: 3 formalized, 7 deferred (2 authorized, 5 expansion), 0 unaccounted | pass | pass | pass |
| `eu/cbam/de_minimis` | 188/188 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/cbam/origin_exclusions` | 199/199 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/cra_administrative_fines` | 224/224 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/cra_art14_manufacturer_reporting` | 200/200 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/cra_manufacturer_duties` | 188/188 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_act_connected_product_data_sharing` | 223/223 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_accountability_security` | 199/199 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_administrative_fine_maximum` | 164/164 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_art15_access_copy` | 172/172 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_art36_3_consultation_request` | 147/147 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_art6_lawful_basis` | 247/247 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_art89_research_safeguards` | 146/146 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_arts33_34_breach_notification` | 192/192 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_binding_corporate_rules` | 214/214 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_chapter_v_extras` | 142/142 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_chapter_v_transfers` | 201/201 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_child_consent_age_fields` | 216/216 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_child_consent_age_verdict` | 138/138 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_churches_and_religious_associations` | 175/175 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_common_definitions_data_and_processing` | 231/231 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_common_definitions_roles_and_establishments` | 213/213 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_compensation_and_liability` | 192/192 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_complaints_and_judicial_remedies` | 153/153 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_consent_conditions` | 259/259 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_cooperation_with_the_supervisory_authority` | 173/173 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_corrective_powers_named` | 156/156 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_data_subject_rights_access_rectification_restriction` | 120/120 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_data_subject_rights_articles_15_to_18_decision_and_exception` | 218/218 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_data_subject_rights_articles_20_to_22_decision_and_exception` | 251/251 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_data_subject_rights_automated_decision` | 134/134 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_data_subject_rights_erasure` | 215/215 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_data_subject_rights_erasure_basis` | 130/130 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_data_subject_rights_objection_notice_and_erasure_follow_up` | 219/219 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_data_subject_rights_portability_and_objection` | 177/177 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_data_subject_rights_response_duties` | 202/202 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_data_subject_rights_response_period` | 177/177 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_impact_assessment_assessment_duty_stated_risk` | 209/209 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_impact_assessment_prior_consultation` | 179/179 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_information_duties_headline_verdict` | 184/184 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_information_duties_items_and_further_processing` | 144/144 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_information_duties_timing` | 172/172 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_joint_controllers` | 187/187 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_procedural_regulation` | 245/245 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_processor_contract` | 216/216 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_records_and_officer` | 200/200 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_representation_and_suspension` | 169/169 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_special_categories` | 247/247 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_territorial_material_scope` | 170/170 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_transfer_dpf` | 175/175 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/data_protection/gdpr_transfer_scc` | 232/232 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/dma_art_3_gatekeeper_order` | 175/175 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/dma_art_5_2_data_combination_order` | 211/211 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/dma_art_6_9_10_portability_and_business_data_order` | 280/280 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/dora_ict_risk_governance_and_framework` | 242/242 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/dora_ict_risk_protection_and_detection` | 188/188 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/dora_ict_risk_response_and_recovery` | 184/184 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/dora_ict_third_party_contract_provisions` | 178/178 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/dora_ict_third_party_entity_duties` | 198/198 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/dora_proportionality_and_simplified_framework` | 208/208 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/dora_resilience_testing_programme` | 210/210 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/dora_scope_and_entity_types` | 245/245 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/dora_tlpt` | 291/291 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/dsa_art_14_terms_and_conditions_order` | 171/171 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/dsa_art_28_minors_order` | 225/225 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/eprivacy_art_5_3_terminal_equipment` | 200/200 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/eprivacy_breach_traffic_location_marketing` | 239/239 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/labour/daily_rest` | 227/227 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/labour/night_work` | 249/249 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/labour/weekly_rest` | 219/219 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/labour/working_time_weekly_limit` | 273/273 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/nis2_domain_name_data` | 221/221 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/nis2_governance_risk_measures` | 170/170 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/nis2_implementing_regulation_significant_incidents` | 241/241 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/nis2_incident_reporting` | 174/174 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/nis2_information_sharing_voluntary_notification` | 203/203 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/nis2_jurisdiction_registration` | 216/216 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/nis2_scope_entity_class` | 242/242 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/nis2_supervision_fines` | 191/191 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/procurement/framework_agreements` | 200/200 | enforced: 13 units: 12 formalized, 1 deferred (1 authorized, 0 expansion), 0 unaccounted | pass | pass | pass |
| `eu/procurement/life_cycle_costing` | 235/235 | enforced: 15 units: 13 formalized, 2 deferred (2 authorized, 0 expansion), 0 unaccounted | pass | pass | pass |
| `eu/procurement/shortlisting` | 183/183 | enforced: 3 units: 2 formalized, 1 deferred (1 authorized, 0 expansion), 0 unaccounted | pass | pass | pass |
| `eu/procurement/time_limits` | 118/118 | enforced: 43 units: 18 formalized, 25 deferred (25 authorized, 0 expansion), 0 unaccounted | pass | pass | pass |
| `eu/procurement/utilities_negotiated_without_prior_call` | 147/147 | enforced: 14 units: 10 formalized, 4 deferred (4 authorized, 0 expansion), 0 unaccounted | pass | pass | pass |
| `eu/state_aid/de_minimis_cumulation` | 120/120 | enforced: 10 units: 4 formalized, 6 deferred (0 authorized, 6 expansion), 0 unaccounted | pass | pass | pass |
| `eu/state_aid/gber_general_conditions` | 219/219 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/state_aid/single_undertaking` | 232/232 | none (no provision-tracking ledger) | pass | pass | pass |
| `eu/state_aid/sme_definition` | 237/237 | none (no provision-tracking ledger) | pass | pass | pass |
| `ind/dpdp_appeal_information` | 216/216 | none (no provision-tracking ledger) | pass | pass | pass |
| `ind/dpdp_notice_consent` | 246/246 | none (no provision-tracking ledger) | pass | pass | pass |
| `ind/dpdp_research_state_processing` | 196/196 | none (no provision-tracking ledger) | pass | pass | pass |
| `ind/dpdp_security_retention` | 278/278 | none (no provision-tracking ledger) | pass | pass | pass |
| `ind/dpdp_transfer` | 215/215 | none (no provision-tracking ledger) | pass | pass | pass |
| `sg/companies/csp_registration` | 90/90 | none (no provision-tracking ledger) | pass | pass | pass |
| `sg/companies/small_company_audit_exemption` | 114/114 | none (no provision-tracking ledger) | pass | pass | pass |
| `sg/data_protection/pdpa_data_breach_notification` | 223/223 | none (no provision-tracking ledger) | pass | pass | pass |
| `sg/payments/psa_licence_class` | 99/99 | none (no provision-tracking ledger) | pass | pass | pass |
| `sg/securities/sfa_offer_exemptions` | 68/68 | none (no provision-tracking ledger) | pass | pass | pass |
| `sg/tax/gst_registration` | 86/86 | none (no provision-tracking ledger) | pass | pass | pass |
| `uk/uk_automated_decision_making` | 199/199 | none (no provision-tracking ledger) | pass | pass | pass |
| `uk/uk_complaints_to_the_commissioner` | 206/206 | none (no provision-tracking ledger) | pass | pass | pass |
| `uk/uk_pecr_cookie_exemptions_and_fines` | 215/215 | none (no provision-tracking ledger) | pass | pass | pass |
| `uk/uk_recognised_legitimate_interests` | 232/232 | none (no provision-tracking ledger) | pass | pass | pass |
| `uk/uk_subject_access_requests` | 247/247 | none (no provision-tracking ledger) | pass | pass | pass |
| `us/colorado_cpa` | 245/245 | none (no provision-tracking ledger) | pass | pass | pass |
| `us/texas_tdpsa` | 235/235 | none (no provision-tracking ledger) | FAIL | pass | FAIL |
| `us/virginia_vcdpa` | 210/210 | none (no provision-tracking ledger) | pass | pass | pass |
