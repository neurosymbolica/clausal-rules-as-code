# Run it yourself

Everything below runs on an ordinary computer with Python 3.13 or later.

```sh
git clone https://github.com/neurosymbolica/clausal-rules-as-code
cd clausal-rules-as-code
pip install clausal pyyaml        # the engine (Clausal Prolog) and YAML for the tools

python run_tests.py               # every domain's tests
python run_tests.py eu/procurement/time_limits   # one domain
```

The same tests on an independent ISO Prolog engine, through the plain ISO Prolog generated
into each domain's `iso/` folder. Install [Scryer Prolog](https://www.scryer.pl) or
[Trealla Prolog](https://github.com/trealla-prolog/trealla), then:

```sh
python run_iso_tests.py scryer /path/to/scryer-prolog
python run_iso_tests.py trealla /path/to/tpl
python run_iso_tests.py trealla /path/to/tpl eu/procurement/time_limits   # one domain
```

All three engines pass the same 1,218 tests (tested with Clausal Prolog 1.0.0, Scryer Prolog
v0.10.0-137-g9acba77a and Trealla Prolog v2.92.3).

The public checks for one domain:

```sh
python _tools/check_citations.py   eu/procurement/time_limits
python _tools/check_parameters.py  eu/procurement/time_limits
python _tools/check_provisions.py  eu/procurement/time_limits
python _tools/check_provenance.py  eu/procurement/time_limits
```

And its side-by-side provision report:

```sh
python _tools/render_provisions.py eu/procurement/time_limits/provisions.yaml --out report.html
```

## Asking a domain a question

A domain is a set of modules you can query from Clausal Prolog or from Python. Each domain's
`SIGNATURE.md` lists its public predicates, the inputs each expects and the answers it gives,
and its `tests/` folder holds worked examples that double as usage examples.
