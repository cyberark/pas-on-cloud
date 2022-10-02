import pytest
import boto3
import time

class TestPASNetworkEnvironmentPrivateLinkTemplate():
  resources = {}

  def test_PASNetworkEnvironmentPrivateLink_CreateChangeSet(self, region, branch, commitid, templateurl):
      cf_client = boto3.client('cloudformation', region_name=region)
      templatename = 'PAS-network-environment-PrivateLink'
      stack_name = 'test-{}-{}-{}'.format(templatename, branch.replace('_','-').replace('.','-'), commitid)
      template_params = [
          {'ParameterKey': 'UsersAccessCIDR', 'ParameterValue': '0.0.0.0/0', 'UsePreviousValue': False},
          {'ParameterKey': 'AdministrativeAccessCIDR', 'ParameterValue': '0.0.0.0/0', 'UsePreviousValue': False}
      ]
      response = cf_client.create_change_set(
          StackName=stack_name,
          TemplateURL='{}/{}.json'.format(templateurl, templatename),
          UsePreviousTemplate=False,
          Parameters=template_params,
          Capabilities=['CAPABILITY_IAM'],
          ChangeSetName=stack_name,
          Description='test-{}-{}-{}'.format(templatename, branch.replace('_','-').replace('.','-'), commitid),
          ChangeSetType='CREATE'
      )
      assert response['ResponseMetadata']['HTTPStatusCode'] == 200

      retries = 10
      while retries > 0:
        res = cf_client.describe_change_set(
            StackName=stack_name,
            ChangeSetName=stack_name
        )
        if res['ExecutionStatus'] == 'AVAILABLE':
            break
        time.sleep(1)
      assert res['ExecutionStatus'] == 'AVAILABLE'
      assert res['Status'] == 'CREATE_COMPLETE'

      for resource in res['Changes']:
          if resource['ResourceChange']['Action'] == "Add":
              if resource['ResourceChange']['ResourceType'] not in self.resources:
                  self.resources[resource['ResourceChange']['ResourceType']] = []
              self.resources[resource['ResourceChange']['ResourceType']].append(
                  resource['ResourceChange']['LogicalResourceId'])

      # in case changeset exceed number of resources, there is a need to run it again with NextToken
      while 'NextToken' in res:
        res = cf_client.describe_change_set(
                  StackName= stack_name,
                  ChangeSetName=stack_name,
                  NextToken= res['NextToken']
              )

        for resource in res['Changes']:
          if resource['ResourceChange']['Action'] == "Add":
              if resource['ResourceChange']['ResourceType'] not in self.resources:
                  self.resources[resource['ResourceChange']['ResourceType']] = []
              self.resources[resource['ResourceChange']['ResourceType']].append(
                  resource['ResourceChange']['LogicalResourceId'])

      # Validate expected number of elements
      assert len(self.resources) == 14

  def test_PASNetworkEnvironmentPrivateLink_SecurityGroups(self, region):
      expected_SecurityGroups = {'CPMSG', 'PSMSG', 'PSMSSHSG', 'PVWASG', 'PrivateLinkPASSG', 'VaultSG', 'PTASG'}
      assert set(self.resources['AWS::EC2::SecurityGroup']) == expected_SecurityGroups

  def test_PASNetworkEnvironmentPrivateLink_SecurityGroupsEgress(self):
      expected_SecurityGroupsEgress = {'CPMSGEgress1', 'CPMSGEgress2', 'PSMSGEgress1', 'PSMSGEgress2', 'PSMSGEgress3', 'PSMSGEgress4',
                      'PSMSSHSGEgress1', 'PSMSSHSGEgress2', 'PSMSSHSGEgress3', 'PVWASGEgress1', 'PVWASGEgress2', 'PVWASGEgress3',
                      'VaultSGEgress1', 'VaultSGEgress2', 'VaultSGEgress3', 'VaultSGEgress4', 'PTASGEgress1', 'PTASGEgress2', 'PTASGEgress3',
                      'PTASGEgress4', 'PTASGEgress5', 'PTASGEgress6', 'PTASGEgress7', 'PTASGEgress8', 'PTASGEgress9',
                      'PTASGEgress10', 'PTASGEgress11', 'PTASGEgress12', 'PTASGEgress13','PTASGEgress14', 'PTASGEgress15', 'PTASGEgress5',
                      'PVWASGEgress6','PVWASGEgress4','PTASGEgress16','VaultSGEgress5','PSMSSHSGEgress4','CPMSGEgress3','PVWASGEgress5','PTASGEgress17', 'PrivateLinkPASSGEgress'
      }
      assert set(self.resources['AWS::EC2::SecurityGroupEgress']) == expected_SecurityGroupsEgress

  def test_PASNetworkEnvironmentPrivateLink_SecurityGroupsIngress(self):
      expected_SecurityGroupsIngress = {'CPMSGIngress1', 'PSMSGIngress1', 'PSMSGIngress2', 'PSMSSHSGIngress1', 'PSMSSHSGIngress2',
                      'PVWASGIngress1', 'PVWASGIngress2', 'VaultSGIngress1', 'VaultSGIngress2', 'VaultSGIngress3', 'PTASGIngress1',
                      'PTASGIngress11', 'PTASGIngress2','PTASGIngress3', 'PTASGIngress4','PTASGIngress5', 'PTASGIngress6',
                      'PTASGIngress7', 'PTASGIngress8','PTASGIngress9', 'PTASGIngress12','PTASGIngress11', 'PTASGIngress13',
                      'PTASGIngress14', 'PTASGIngress15','PTASGIngress16', 'PTASGIngress17','PTASGIngress18',
                      'VaultSGIngress9','PVWASGIngress7','VaultSGIngress7','PTASGIngress19','VaultSGIngress4','PVWASGIngress3',
                      'VaultSGIngress8','VaultSGIngress5','PVWASGIngress4','PVWASGIngress5','PVWASGIngress8','VaultSGIngress6','PVWASGIngress6',
                      'PrivateLinkPASSGIngress','PVWASGIngress9','PVWASGIngress10'
      }
      assert set(self.resources['AWS::EC2::SecurityGroupIngress']) == expected_SecurityGroupsIngress

  def test_PASNetworkEnvironmentPrivateLink_SubnetNetworkAclAssociation(self):
      expected_SubnetNetworkAclAssociation = {'PASVaultDRNACLAssociation','PASVaultMainNACLAssociation'}
      assert set(self.resources['AWS::EC2::SubnetNetworkAclAssociation']) == expected_SubnetNetworkAclAssociation

  def test_PASNetworkEnvironmentPrivateLink_SubnetRouteTableAssociation(self):
      expected_SubnetRouteTableAssociation = {'VaultDRRTAssociation','VaultMainRTAssociation','PSMSecondaryRTAssociation','PSMPMainRTAssociation','VaultDRRTAssociation','PSMMainRTAssociation',
      'PSMPSecondaryRTAssociation','PTAMainRTAssociation','PVWAMainRTAssociation','CPMDRRTAssociation','PVWASecondaryRTAssociation','PTADRRTAssociation','CPMMainRTAssociation','VaultMainRTAssociation'}
      assert set(self.resources['AWS::EC2::SubnetRouteTableAssociation']) == expected_SubnetRouteTableAssociation

  def test_PASNetworkEnvironmentPrivateLink_Route(self):
      expected_Route = {'PASPublicIGWRoute'}
      assert set(self.resources['AWS::EC2::Route']) == expected_Route

  def test_PASNetworkEnvironmentPrivateLink_NetworkAclEntry(self):
      expected_NetworkAclEntry = {'PASAclEntry1', 'PASAclEntry2'}
      assert set(self.resources['AWS::EC2::NetworkAclEntry']) == expected_NetworkAclEntry

  def test_PASNetworkEnvironmentPrivateLink_VPCEndpoint(self):
      expected_VPCEndpoint = {'VaultS3Endpoint','VaultKMSEndpoint','PASCFNEndpoint','PASSSMEndpoint','PASCWEndpoint'}
      assert set(self.resources['AWS::EC2::VPCEndpoint']) == expected_VPCEndpoint

  def test_PASNetworkEnvironmentPrivateLink_VPCGatewayAttachment(self):
      expected_VPCGatewayAttachment = {'PASGWAttachment'}
      assert set(self.resources['AWS::EC2::VPCGatewayAttachment']) == expected_VPCGatewayAttachment

  def test_PASNetworkEnvironmentPrivateLink_InternetGateway(self):
      expected_InternetGateway = {'PASIGW'}
      assert set(self.resources['AWS::EC2::InternetGateway']) == expected_InternetGateway

  def test_PASNetworkEnvironmentPrivateLink_Subnet(self):
      expected_Subnet = {'VaultDRSubnet','VaultMainSubnet','PSMSSHSecondarySubnet','PVWASecondarySubnet','PTAMainSubnet','PSMSSHMainSubnet','PTADRSubnet','CPMDRSubnet',
      'PSMSecondarySubnet','PVWAMainSubnet','PSMMainSubnet','CPMMainSubnet'}
      assert set(self.resources['AWS::EC2::Subnet']) == expected_Subnet

  def test_PASNetworkEnvironmentPrivateLink_NetworkAcl(self):
      expected_NetworkAcl = {'PASVaultNACL'}
      assert set(self.resources['AWS::EC2::NetworkAcl']) == expected_NetworkAcl

  # def test_PASNetworkEnvironmentPrivateLink_EIP(self):
  #     expected_EIP = {'PASNATEIP'}
  #     assert set(self.resources['AWS::EC2::EIP']) == expected_EIP

  def test_PASNetworkEnvironmentPrivateLink_RouteTable(self):
      expected_RouteTable = {'PASPublicRT', 'PASPrivateRT'}
      assert set(self.resources['AWS::EC2::RouteTable']) == expected_RouteTable

  def test_PASNetworkEnvironmentPrivateLink_VPC(self):
      expected_VPC= {'PASVPC'}
      assert set(self.resources['AWS::EC2::VPC']) == expected_VPC

  def test_CleanupEnvironment(self, region, branch, commitid, templateurl):
      cf_client = boto3.client('cloudformation', region_name=region)
      templatename = 'PAS-network-environment-PrivateLink'
      stack_name = 'test-{}-{}-{}'.format(templatename, branch.replace('_','-').replace('.','-'), commitid)
      response = cf_client.delete_stack(
          StackName=stack_name
      )
      assert response['ResponseMetadata']['HTTPStatusCode'] == 200
