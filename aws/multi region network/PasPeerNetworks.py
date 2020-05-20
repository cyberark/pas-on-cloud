import urllib
import boto3
import time
import cfnresponse
import uuid
def lambda_handler(event, context):
    try:
        physicalResourceId = str(uuid.uuid4())
        if 'PhysicalResourceId' in event:
            physicalResourceId = event['PhysicalResourceId']
        if event['RequestType'] == 'Delete':
            return cfnresponse.send(event, context, cfnresponse.SUCCESS, None, {}, physicalResourceId)
        if event['RequestType'] == 'Create':
            CloudFormationNameRequester = event['ResourceProperties']['CloudFormationName']
            CloudFormationNameAccepter = event['ResourceProperties']['CloudFormationSecondaryRegionName']
            AccepterRegion = event['ResourceProperties']['SecondaryRegionName']
            cf_requester_client = boto3.client('cloudformation')
            cf_accepter_client = boto3.client('cloudformation',AccepterRegion)
            ec2_requester_resource = boto3.resource('ec2')
            ec2_accepter_resource = boto3.resource('ec2',AccepterRegion)
            # Fetch physical resource ids of VPC, Route Table
            response = cf_requester_client.describe_stack_resource(StackName=CloudFormationNameRequester,LogicalResourceId='PASVPC')
            vpc_requester_id = response['StackResourceDetail']['PhysicalResourceId']
            response = cf_requester_client.describe_stack_resource(StackName=CloudFormationNameRequester,LogicalResourceId='PASPrivateRT')
            route_table_requester_id = response['StackResourceDetail']['PhysicalResourceId']
            # Fetch physical resource ids of VPC, Route Table
            response = cf_accepter_client.describe_stack_resource(StackName=CloudFormationNameAccepter,LogicalResourceId='PASVPC')
            vpc_accepter_id = response['StackResourceDetail']['PhysicalResourceId']
            response = cf_accepter_client.describe_stack_resource(StackName=CloudFormationNameAccepter,LogicalResourceId='PASPrivateRT')
            route_table_accepter_id = response['StackResourceDetail']['PhysicalResourceId']
            # Create Peering connection
            vpc_requester = ec2_requester_resource.Vpc(vpc_requester_id)
            vpc_peering_connection = vpc_requester.request_vpc_peering_connection(DryRun=False,PeerVpcId=vpc_accepter_id,PeerRegion=AccepterRegion)
            # Accept Peering connection (wait 2 seconds until the peer exists in second region)
            vpc_peering_connection_accepter = ec2_accepter_resource.VpcPeeringConnection(vpc_peering_connection.id)
            time.sleep(2)
            response = vpc_peering_connection_accepter.accept()
            # Fetch VPC CIDRs from the peering connection (for further use)
            vpc_cidr_requester = response['VpcPeeringConnection']['RequesterVpcInfo']['CidrBlock']
            vpc_cidr_accepter = response['VpcPeeringConnection']['AccepterVpcInfo']['CidrBlock']
            route_table_requester = ec2_requester_resource.RouteTable(route_table_requester_id)
            route_table_accepter = ec2_accepter_resource.RouteTable(route_table_accepter_id)
            route_table_requester.create_route(DestinationCidrBlock=vpc_cidr_accepter, VpcPeeringConnectionId=vpc_peering_connection.id)
            route_table_accepter.create_route(DestinationCidrBlock=vpc_cidr_requester, VpcPeeringConnectionId=vpc_peering_connection.id)
            return cfnresponse.send(event, context, cfnresponse.SUCCESS, None, {}, physicalResourceId)
    except Exception as e:
        print(e)
        return cfnresponse.send(event, context, cfnresponse.FAILED, None, {}, physicalResourceId)
