"""Transparent TCO scenarios; illustrative assumptions never establish a business case."""
import copy
import math
from .dataset import digest_json

REQUIRED_TARGETS = {'accuracy_improvement', 'severe_error_reduction', 'exception_boundary_improvement',
                    'missing_information_correct_handling', 'primary_significance', 'best_llm_accuracy_improvement'}


def number(obj,key,*,positive=False):
    value=obj.get(key)
    if type(value) not in (int,float) or not math.isfinite(value) or value<0 or (positive and value==0):
        raise ValueError(f'Explicit finite nonnegative cost/input required: {key}')
    return value


def strategy_cost(strategy,volume,amortization):
    upfront,annual,variable=strategy['upfront'],strategy['annual'],strategy['per_case']
    initial=(number(upfront,'formalisation_hours')*number(upfront,'formalisation_hourly_rate_usd')+number(upfront,'integration_usd')+number(upfront,'initial_legal_review_usd'))
    fixed=(initial/amortization+number(annual,'licence_usd')+number(annual,'hosting_usd')+number(annual,'maintenance_hours')*number(annual,'maintenance_hourly_rate_usd')+number(annual,'fixed_legal_review_usd'))
    per_case=(number(variable,'api_cost_usd')+number(variable,'hosting_cost_usd')+number(variable,'human_minutes')/60*number(variable,'human_hourly_rate_usd')+number(variable,'rework_cost_usd'))
    q=strategy.get('correct_rate')
    if q is not None and (type(q) not in (int,float) or not math.isfinite(q) or not 0<=q<=1):
        raise ValueError('correct_rate must be null or a probability')
    total=fixed+volume*per_case
    risk=strategy.get('error_risk')
    loss=None
    if risk is not None:
        probability=number(risk,'probability')
        if probability>1:raise ValueError('Error probability above one')
        loss=probability*number(risk,'loss_per_event_usd')
    return {'upfront_cost_usd':initial,'annual_fixed_cost_usd':fixed,'variable_cost_per_case_usd':per_case,'annual_cost_usd':total,
            'correct_rate':q,'expected_correct_cases':volume*q if q is not None else None,'cost_per_correct_usd':total/(volume*q) if q else None,
            'risk_adjusted_annual_cost_usd':total+volume*loss if loss is not None else None,'error_risk_assumption':risk}


def break_even(fixed_difference,variable_saving):
    if variable_saving<=0:
        return None
    return max(0,math.ceil(fixed_difference/variable_saving))


def evaluate_economics(inputs,*,include_sensitivity=True):
    if inputs.get('currency')!='USD' or inputs.get('evidence_status') not in {'illustrative','operator_estimate','measured'}:
        raise ValueError('Currency USD and explicit evidence_status required')
    volume=number(inputs,'volume_cases_per_year',positive=True)
    amortization=number(inputs,'amortization_years',positive=True)
    if type(volume) is not int:raise ValueError('Annual volume must be an integer')
    if set(inputs['strategies'])!={'baseline','candidate'}:raise ValueError('Exactly baseline and candidate strategies required')
    costs={name:strategy_cost(value,volume,amortization) for name,value in inputs['strategies'].items()}
    a,b=costs['baseline'],costs['candidate']
    comparable=a['cost_per_correct_usd'] is not None and b['cost_per_correct_usd'] is not None
    saving=a['cost_per_correct_usd']-b['cost_per_correct_usd'] if comparable else None
    measured=(inputs['evidence_status']=='measured' and inputs.get('independent_quality_review_complete') is True
              and isinstance(inputs.get('evidence_references'),list) and bool(inputs['evidence_references']) and comparable)
    quality_be=break_even(b['annual_fixed_cost_usd']/b['correct_rate']-a['annual_fixed_cost_usd']/a['correct_rate'],
                         a['variable_cost_per_case_usd']/a['correct_rate']-b['variable_cost_per_case_usd']/b['correct_rate']) if comparable else None
    result={'status':'scenario_calculated','input_sha256':digest_json(inputs),'input_assumptions':copy.deepcopy(inputs),
            'evidence_references':copy.deepcopy(inputs.get('evidence_references',[])),
            'independent_quality_review_complete':inputs.get('independent_quality_review_complete') is True,
            'evidence_status':inputs['evidence_status'],'currency':'USD','volume_cases_per_year':volume,'amortization_years':amortization,
            'strategies':costs,'comparison':{'cash_saving_usd':a['annual_cost_usd']-b['annual_cost_usd'],'saving_per_correct_usd':saving,
            'cash_break_even_cases':break_even(b['annual_fixed_cost_usd']-a['annual_fixed_cost_usd'],a['variable_cost_per_case_usd']-b['variable_cost_per_case_usd']),
            'quality_adjusted_break_even_cases':quality_be},
            'H5':{'status':('pass' if saving>0 else 'fail') if measured else 'not_evaluable','observed_saving_per_correct_usd':saving if measured else None,
                  'scenario_saving_per_correct_usd':saving,'reason':'Operator evidence declarations are recorded, not independently authenticated; positive illustrative scenarios are not market validation.'},
            'commercial_validation':inputs.get('commercial_validation','pending'),'sensitivity':[]}
    if include_sensitivity:
        for n in inputs.get('sensitivity_volumes',[]):
            changed=copy.deepcopy(inputs);changed['volume_cases_per_year']=n
            r=evaluate_economics(changed,include_sensitivity=False)
            result['sensitivity'].append({'volume':n,**r['comparison']})
    return result


def decision_report(analysis,economics):
    raw=analysis.get('targets',{})
    targets={key:value for key,value in raw.items() if isinstance(value,dict) and key!='positive_saving_per_correct_case'}
    outcomes=[value.get('status') for value in targets.values()]
    h5=economics.get('H5',{'status':'not_evaluable'})
    complete = (REQUIRED_TARGETS <= set(targets) and analysis.get('metric') == 'human_accuracy'
                and len(analysis.get('model_reports',{})) == 6 and analysis.get('status') == 'ok')
    if not complete or analysis.get('final_review_complete') is not True or any(s not in {'pass','fail'} for s in outcomes) or h5.get('status') not in {'pass','fail'}:
        decision='inconclusive'
        reason='Real independent legal ratings and adequate economic evidence are required; no success inferred from placeholders or illustrative inputs.'
    elif all(s=='pass' for s in outcomes) and h5['status']=='pass':
        decision='go_to_customer_pilot'
        reason='Proposed technical/economic gates passed for the tested scope; customer willingness-to-pay and deployment validation are separate gates.'
    else:
        decision='reassess_scope_or_no_go'
        reason='One or more proposed gates failed; inspect niche effects, simpler Python alternatives and costs before deciding whether to narrow or stop.'
    return {'decision':decision,'reason':reason,'technical_targets':targets,'H5':h5,'commercial_validation':economics.get('commercial_validation','pending'),
            'business_case_proven':False,'note':'A reproducible calculator and a pilot benchmark cannot establish demand, liability reduction or general superiority.'}
