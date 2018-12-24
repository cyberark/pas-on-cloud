import pytest
import boto3
import time

class TestPASNetworkEnvironmentPrivateLinkTemplate():
  resources = {}

  def test_PASNetworkEnvironmentPrivateLink_CreateChangeSet(self, region, branch, commitid, templateurl):
      cf_client = boto3.client('cloudformation', region_name=region)
      templatename = 'PAS-network-environment-PrivateLink'
      stack_name = 'test-{}-{}'.format(templatename, commitid)
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
          Description='test-{}-{}-{}'.format(templatename, branch.replace('_','-'), commitid),
          ChangeSetType='CREATE'
      )
      assert response['ResponseMetadata']['HTTPStatusCode'] == 200
      time.sleep(5)

      res = cf_client.describe_change_set(
          StackName=stack_name,
          ChangeSetName=stack_name
      )
      assert res['ExecutionStatus'] == 'AVAILABLE'
      assert res['Status'] == 'CREATE_COMPLETE'

      for resource in res['Changes']:
          if resource['ResourceChange']['Action'] == "Add":
              if resource['ResourceChange']['ResourceType'] not in self.resources:
                  self.resources[resource['ResourceChange']['ResourceType']] = []
              self.resources[resource['ResourceChange']['ResourceType']].append(
                  resource['ResourceChange']['LogicalResourceId'])
      # Validate expected number of elements
      assert len(self.resources) == 16
  
  def test_PASNetworkEnvironmentPrivateLink_SecurityGroups(self, region):
      expected_SecurityGroups = {'CPMSG', 'PSMSG', 'PSMSSHSG', 'PVWASG', 'PrivateLinkComponentsSG', 'PrivateLinkVaultSG', 'VaultSG'}
      assert set(self.resources['AWS::EC2::SecurityGroup']) == expected_SecurityGroups

  def test_PASNetworkEnvironmentPrivateLink_SecurityGroupsEgress(self):
      expected_SecurityGroupsEgress = {'CPMSGEgress1', 'CPMSGEgress2', 'PSMSGEgress1', 'PSMSGEgress2', 'PSMSGEgress3', 'PSMSGEgress4',
                      'PSMSSHSGEgress1', 'PSMSSHSGEgress2', 'PSMSSHSGEgress3', 'PVWASGEgress1', 'PVWASGEgress2',
                      'PrivateLinkComponentsSGEgress1', 'PrivateLinkVaultSGEgress1', 'VaultSGEgress1', 'VaultSGEgress2',
                      'VaultSGEgress3'}
      assert set(self.resources['AWS::EC2::SecurityGroupEgress']) == expected_SecurityGroupsEgress

  def test_PASNetworkEnvironmentPrivateLink_SecurityGroupsIngress(self):
      expected_SecurityGroupsIngress = {'CPMSGIngress1', 'PSMSGIngress1', 'PSMSGIngress2', 'PSMSSHSGIngress1', 'PSMSSHSGIngress2',
                      'PVWASGIngress1', 'PVWASGIngress2', 'PrivateLinkComponentsSGIngress1', 'PrivateLinkVaultSGIngress1',
                      'VaultSGIngress1', 'VaultSGIngress2', 'VaultSGIngress3'}
      assert set(self.resources['AWS::EC2::SecurityGroupIngress']) == expected_SecurityGroupsIngress

  def test_PASNetworkEnvironmentPrivateLink_SubnetNetworkAclAssociation(self):
      expected_SubnetNetworkAclAssociation = {'CompMainNACLAssociation', 'CompSecondaryNACLAssociation', 'VaultDRNACLAssociation',
                      'VaultMainNACLAssociation'}
      assert set(self.resources['AWS::EC2::SubnetNetworkAclAssociation']) == expected_SubnetNetworkAclAssociation

  def test_PASNetworkEnvironmentPrivateLink_SubnetRouteTableAssociation(self):
      expected_SubnetRouteTableAssociation = {'CompMainRTAssociation', 'CompSecondaryRTAssociation', 'VaultDRRTAssociation',
                      'VaultMainRTAssociation'}
      assert set(self.resources['AWS::EC2::SubnetRouteTableAssociation']) == expected_SubnetRouteTableAssociation

  def test_PASNetworkEnvironmentPrivateLink_Route(self):
      expected_Route = {'CompPeerRoute', 'CompPublicNATRoute', 'VaultPeerRoute', 'VaultPublicNATRoute'}
      assert set(self.resources['AWS::EC2::Route']) == expected_Route

  def test_PASNetworkEnvironmentPrivateLink_NetworkAclEntry(self):
      expected_NetworkAclEntry = {'ComponentsAclEntry1', 'ComponentsAclEntry2', 'VaultAclEntry1', 'VaultAclEntry2'}
      assert set(self.resources['AWS::EC2::NetworkAclEntry']) == expected_NetworkAclEntry

  def test_PASNetworkEnvironmentPrivateLink_VPCEndpoint(self):
      expected_VPCEndpoint = {'ComponentsCFNEndpoint', 'ComponentsCWEndpoint', 'ComponentsSSMEndpoint', 'VaultCFNEndpoint',
                      'VaultCWEndpoint', 'VaultKMSEndpoint', 'VaultS3Endpoint', 'VaultSSMEndpoint'}
      assert set(self.resources['AWS::EC2::VPCEndpoint']) == expected_VPCEndpoint

  def test_PASNetworkEnvironmentPrivateLink_VPCGatewayAttachment(self):
      expected_VPCGatewayAttachment = {'ComponentsGWAttachment', 'VaultGWAttachment'}
      assert set(self.resources['AWS::EC2::VPCGatewayAttachment']) == expected_VPCGatewayAttachment

  def test_PASNetworkEnvironmentPrivateLink_InternetGateway(self):
      expected_InternetGateway = {'ComponentsIGW', 'VaultIGW'}
      assert set(self.resources['AWS::EC2::InternetGateway']) == expected_InternetGateway

  def test_PASNetworkEnvironmentPrivateLink_Subnet(self):
      expected_Subnet = {'ComponentsMainSubnet', 'ComponentsSecondarySubnet', 'VaultDRSubnet', 'VaultMainSubnet'}
      assert set(self.resources['AWS::EC2::Subnet']) == expected_Subnet

  def test_PASNetworkEnvironmentPrivateLink_NetworkAcl(self):
      expected_NetworkAcl = {'ComponentsNACL', 'VaultNACL'}
      assert set(self.resources['AWS::EC2::NetworkAcl']) == expected_NetworkAcl

  def test_PASNetworkEnvironmentPrivateLink_EIP(self):
      expected_EIP = {'ComponentsNATEIP', 'VaultNATEIP'}
      assert set(self.resources['AWS::EC2::EIP']) == expected_EIP

  def test_PASNetworkEnvironmentPrivateLink_RouteTable(self):
      expected_RouteTable = {'ComponentsPrivateRT', 'ComponentsPublicRT', 'VaultPrivateRT', 'VaultPublicRT'}
      assert set(self.resources['AWS::EC2::RouteTable']) == expected_RouteTable

  def test_PASNetworkEnvironmentPrivateLink_VPC(self):
      expected_VPC= {'ComponentsVPC', 'VaultVPC'}
      assert set(self.resources['AWS::EC2::VPC']) == expected_VPC
