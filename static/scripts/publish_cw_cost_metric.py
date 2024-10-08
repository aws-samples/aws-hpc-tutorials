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

import subprocess, json, boto3
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


def calculate_node_mins(sacct_output):
    node_minutes = 0
    
    for job in sacct_output['jobs']:
        if len(job['steps']) == 0:
            continue
        
        tmp_time = job['time']['elapsed']
        tmp_node = 0
        
        for val in job['tres']['allocated']:
            if val['type'] == 'node':
                tmp_node = val['count']
        
        node_minutes = node_minutes + (tmp_time * tmp_node)
    
    return node_minutes


def get_instance_type_pricing(instance_type):
    # response = pricing_client.describe_services(ServiceCode='AmazonEC2')
    
    # response = pricing_client.get_attribute_values(ServiceCode='AmazonEC2', AttributeName='tenancy')
    
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
    
    price = find_by_key(product_pricing['terms']['OnDemand'], 'USD')
    
    return Decimal(next(price)) / 60


if __name__ == '__main__':
    # sacct to get job statistics (one week of data)
    # output = subprocess.check_output('sacct --allocations --starttime now-7days --json', shell=True)
    output = subprocess.check_output('sacct --starttime now-7days --json', shell=True)
    
    json_output = json.loads(output)
    node_mins = calculate_node_mins(json_output)
    
    # get instance type
    instance_type = get_compute_type()
    
    # query pricelist API
    price_per_minute = get_instance_type_pricing(instance_type)
    
    compute_budget_total = Decimal(price_per_minute) * Decimal(node_mins)
    
    print('total cost= {0}'.format(str(compute_budget_total)))
    
    cw_client = boto3.client('cloudwatch', region_name='eu-north-1')
    
    response = cw_client.put_metric_data(
        Namespace='ParallelCluster',
        MetricData=[
            {'MetricName': 'cluster_cost',
             'Dimensions': [
                 {
                     'Name': 'ClusterName',
                     'Value': 'hpc'
                 }
             ],
             'Value': compute_budget_total}
        ]
    )