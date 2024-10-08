# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
# SPDX-License-Identifier: MIT-0
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import boto3, json, sys, os
boto3.compat.filter_python_deprecation_warnings()
from decimal import Decimal
pricing_client = boto3.client('pricing', region_name='us-east-1')


def find_by_key(data, target):
    for key, value in data.items():
        if isinstance(value, dict):
            yield from find_by_key(value, target)
        elif key == target:
            yield value


def get_compute_type():
    
    with open('/etc/parallelcluster/slurm_plugin/fleet-config.json', 'r') as f:
        data = json.load(f)

        end_val = find_by_key(data, 'Instances')
        for value in end_val:
            return value[0]['InstanceType']
    
    
def get_instance_type_pricing(instance_type):
    #response = pricing_client.describe_services(ServiceCode='AmazonEC2')

    #response = pricing_client.get_attribute_values(ServiceCode='AmazonEC2', AttributeName='tenancy')
    
    response = pricing_client.get_products(ServiceCode='AmazonEC2',
        Filters=[
            {
                'Field': 'instanceType',
                'Type': 'TERM_MATCH',
                'Value': instance_type,
            },
            {
                'Field': 'regionCode',
                'Type': 'TERM_MATCH',
                'Value': 'eu-north-1',
            },
            {
                'Field': 'operatingSystem',
                'Type': 'TERM_MATCH',
                'Value': 'Linux',
            },
            {
                'Field': 'tenancy',
                'Type': 'TERM_MATCH',
                'Value': 'shared',
            }
        ]
    )
    
    product_pricing = None
    for item in response['PriceList']:
        json_item = json.loads(item)
        if 'BoxUsage' in json_item['product']['attributes']['usagetype']:
            product_pricing = json_item
        else:
            continue
            
    price = find_by_key(product_pricing['terms']['OnDemand'],'USD')
    vcpu_count = int(product_pricing['product']['attributes']['vcpu'])
    
    return Decimal(next(price)) / 60 / vcpu_count


def convert_budget_to_minutes(budget, price_per_minute):
    
    # the budget_padding_factor setting configures a percent threshold against the overall budget to compare against
    # for example, .9 means 90% of the budget will be used to set the GrpTRESMins limit
    # TODO parameterize this value
    budget_padding_factor = Decimal(.9)
    return int((Decimal(budget) / price_per_minute) * budget_padding_factor)
    

def apply_grpstresmins(minutes):
    
    output_code = os.system('sacctmgr modify account pcdefault set GrpTRESMins=cpu={0} -i'.format(minutes))
    if output_code == 0:
        return
    else:
        raise Exception('Unable to apply GrpTRESMins via sacctmgr')


if __name__ == '__main__':
    
    budget = sys.argv[1]
    
    # get instance type
    instance_type = get_compute_type()
    
    # query pricelist API
    price_per_minute = get_instance_type_pricing(instance_type)
    
    # convert price to minutes
    total_mins = convert_budget_to_minutes(budget, price_per_minute)
    
    # apply grptresmins
    apply_grpstresmins(total_mins)

    print('successfully applied {0} minute limit to sacctmgr'.format(total_mins))
    
    # slurm-accounting-db-test-v5-publicdb

    