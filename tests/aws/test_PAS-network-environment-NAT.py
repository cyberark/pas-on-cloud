import pytest
import boto3
import time

class TestPASNetworkEnvironmentNatTemplate():
  resources = {}

  def test_PASNetworkEnvironmentNat_CreateChangeSet(self, region, branch, commitid, templateurl):
      cf_client = boto3.client('cloudformation', region_name=region)
      templatename = 'PAS-network-environment-NAT'
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
      # Validate expected number of elements
      assert len(self.resources) == 16

  def test_PASNetworkEnvironmentNat_SecurityGroups(self, region):
      expected_SecurityGroups = {'CPMSG', 'PSMSG', 'PSMSSHSG', 'PVWASG', 'VaultSG'}
      assert set(self.resources['AWS::EC2::SecurityGroup']) == expected_SecurityGroups

  def test_PASNetworkEnvironmentNat_SecurityGroupsEgress(self):
      expected_SecurityGroupsEgress = {'CPMSGEgress1', 'CPMSGEgress2', 'PSMSGEgress1', 'PSMSGEgress2', 'PSMSGEgress3', 'PSMSGEgress4',
                      'PSMSSHSGEgress1', 'PSMSSHSGEgress2', 'PSMSSHSGEgress3', 'PVWASGEgress1', 'PVWASGEgress2',
                      'VaultSGEgress1', 'VaultSGEgress2', 'VaultSGEgress3'}
      assert set(self.resources['AWS::EC2::SecurityGroupEgress']) == expected_SecurityGroupsEgress

  def test_PASNetworkEnvironmentNat_SecurityGroupsIngress(self):
      expected_SecurityGroupsIngress = {'CPMSGIngress1', 'PSMSGIngress1', 'PSMSGIngress2', 'PSMSSHSGIngress1', 'PSMSSHSGIngress2',
                      'PVWASGIngress1', 'PVWASGIngress2', 'VaultSGIngress1', 'VaultSGIngress2', 'VaultSGIngress3'}
      assert set(self.resources['AWS::EC2::SecurityGroupIngress']) == expected_SecurityGroupsIngress

  def test_PASNetworkEnvironmentNat_SubnetNetworkAclAssociation(self):
      expected_SubnetNetworkAclAssociation = {'CompMainNACLAssociation', 'CompSecondaryNACLAssociation', 'VaultDRNACLAssociation',
                      'VaultMainNACLAssociation', 'VaultNatNACLAssociation', 'CompNatNACLAssociation'}
      assert set(self.resources['AWS::EC2::SubnetNetworkAclAssociation']) == expected_SubnetNetworkAclAssociation

  def test_PASNetworkEnvironmentNat_SubnetRouteTableAssociation(self):
      expected_SubnetRouteTableAssociation = {'CompMainRTAssociation', 'CompSecondaryRTAssociation', 'VaultDRRTAssociation',
                      'VaultMainRTAssociation', 'CompNatRTAssociation', 'VaultNatRTAssociation'}
      assert set(self.resources['AWS::EC2::SubnetRouteTableAssociation']) == expected_SubnetRouteTableAssociation

  def test_PASNetworkEnvironmentNat_Route(self):
      expected_Route = {'CompPeerRoute', 'CompPublicNATRoute', 'VaultPeerRoute', 'VaultPublicNATRoute', 'CompPrivateNATRoute', 'VaultPrivateNATRoute'}
      assert set(self.resources['AWS::EC2::Route']) == expected_Route

  def test_PASNetworkEnvironmentNat_NetworkAclEntry(self):
      expected_NetworkAclEntry = {'ComponentsAclEntry1', 'ComponentsAclEntry2', 'VaultAclEntry1', 'VaultAclEntry2'}
      assert set(self.resources['AWS::EC2::NetworkAclEntry']) == expected_NetworkAclEntry

  def test_PASNetworkEnvironmentNat_VPCGatewayAttachment(self):
      expected_VPCGatewayAttachment = {'ComponentsGWAttachment', 'VaultGWAttachment'}
      assert set(self.resources['AWS::EC2::VPCGatewayAttachment']) == expected_VPCGatewayAttachment

  def test_PASNetworkEnvironmentNat_InternetGateway(self):
      expected_InternetGateway = {'ComponentsIGW', 'VaultIGW'}
      assert set(self.resources['AWS::EC2::InternetGateway']) == expected_InternetGateway

  def test_PASNetworkEnvironmentNat_Subnet(self):
      expected_Subnet = {'ComponentsMainSubnet', 'ComponentsSecondarySubnet', 'VaultDRSubnet', 'VaultMainSubnet', 'VaultNATSubnet', 'ComponentsNATSubnet'}
      assert set(self.resources['AWS::EC2::Subnet']) == expected_Subnet

  def test_PASNetworkEnvironmentNat_NetworkAcl(self):
      expected_NetworkAcl = {'ComponentsNACL', 'VaultNACL'}
      assert set(self.resources['AWS::EC2::NetworkAcl']) == expected_NetworkAcl

  def test_PASNetworkEnvironmentNat_EIP(self):
      expected_EIP = {'ComponentsNATEIP', 'VaultNATEIP'}
      assert set(self.resources['AWS::EC2::EIP']) == expected_EIP

  def test_PASNetworkEnvironmentNat_NatGateway(self):
      expected_NatGateway = {'ComponentsNATGW', 'VaultNATGW'}
      assert set(self.resources['AWS::EC2::NatGateway']) == expected_NatGateway

  def test_PASNetworkEnvironmentNat_RouteTable(self):
      expected_RouteTable = {'ComponentsPrivateRT', 'ComponentsPublicRT', 'VaultPrivateRT', 'VaultPublicRT'}
      assert set(self.resources['AWS::EC2::RouteTable']) == expected_RouteTable

  def test_PASNetworkEnvironmentNat_VPC(self):
      expected_VPC= {'ComponentsVPC', 'VaultVPC'}
      assert set(self.resources['AWS::EC2::VPC']) == expected_VPC

  def test_CleanupEnvironment(self, region, branch, commitid, templateurl):
      cf_client = boto3.client('cloudformation', region_name=region)
      templatename = 'PAS-network-environment-NAT'
      stack_name = 'test-{}-{}-{}'.format(templatename, branch.replace('_','-').replace('.','-'), commitid)
      response = cf_client.delete_stack(
          StackName=stack_name
      )
      assert response['ResponseMetadata']['HTTPStatusCode'] == 200
