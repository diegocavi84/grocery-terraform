import boto3, datetime

cloudwatch = boto3.client('cloudwatch')

def lambda_handler(event, context):
    cloudwatch.put_metric_data(
        Namespace='GroceryHealth',
        MetricData=[{
            'MetricName': 'CPUUtilization',
            'Dimensions': [{'Name': 'Service', 'Value': 'grocery'}],
            'Timestamp': datetime.datetime.utcnow(),
            'Value': 70.0,
            'Unit': 'Percent'
        }]
    )
    return "Health metric sent"
