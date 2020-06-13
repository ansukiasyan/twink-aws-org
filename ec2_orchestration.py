import boto3
from os import environ
from json import dumps 
import datetime


def lambda_handler(event, context):
    region = environ['AWS_REGION']
    role_ARN = environ['EC2_Assume_Role_ARN']
    sts_connection = boto3.client('sts')
    acct_dev = sts_connection.assume_role(
        RoleArn=role_ARN,
        RoleSessionName="cross_acct_lambda"
    )
    
    ACCESS_KEY = acct_dev['Credentials']['AccessKeyId']
    SECRET_KEY = acct_dev['Credentials']['SecretAccessKey']
    SESSION_TOKEN = acct_dev['Credentials']['SessionToken']

    
    ec2 = boto3.client(
        'ec2',
        aws_access_key_id=ACCESS_KEY,
        aws_secret_access_key=SECRET_KEY,
        aws_session_token=SESSION_TOKEN,
        region_name=region
    )

    filters = [{'Name': 'tag-key', 'Values': ['StartTime']}, {'Name': 'tag-key', 'Values': ['StopTime']}, {'Name':'instance-state-name','Values':['running', 'stopped']}]
    instances = ec2.describe_instances(Filters=filters)
    
    start_instanceId_list = []
    stop_instanceId_list = []
    responses = []

      
    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:

            instance_state = instance['State']['Name']

            start_schedule_tag = ""
            end_schedule_tag = ""
            for tag in instance['Tags']:
                if tag["Key"] == 'StartTime':
                    start_schedule_tag = tag["Value"]
                if tag["Key"] == 'StopTime':
                    end_schedule_tag = tag["Value"]

            start_time = datetime.datetime.strptime(start_schedule_tag, '%H:%M').time()
            end_time = datetime.datetime.strptime(end_schedule_tag, '%H:%M').time()

            evn_time = (datetime.datetime.utcnow() + datetime.timedelta(hours=4)).time()

            if evn_time >= start_time and evn_time <= end_time and instance_state == "stopped":
                start_instanceId_list.append(instance['InstanceId'])
            elif (evn_time < start_time or evn_time > end_time) and instance_state == "running":
                stop_instanceId_list.append(instance['InstanceId'])

        if len(start_instanceId_list) > 0:
            start_resp = ec2.start_instances(InstanceIds=start_instanceId_list)
            responses.append(start_resp)
        if len(stop_instanceId_list) > 0:
            stop_resp = ec2.stop_instances(InstanceIds=stop_instanceId_list)
            responses.append(stop_resp)

    return responses

        
       
    


        
        
    





