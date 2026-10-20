from _tools import gen_citation_index as gci

def test_instrument_prefix():
    assert gci.instrument_prefix("us_cfr_7_273_9_a_1") == "us_cfr"
    assert gci.instrument_prefix("us_usc_7_2017_a") == "us_usc"
    assert gci.instrument_prefix("au_aml_ctf_act_s45") == "au_aml_ctf_act"
    assert gci.instrument_prefix("eu_gdpr_art6_1_a") == "eu_gdpr"
