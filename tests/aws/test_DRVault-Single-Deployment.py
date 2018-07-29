import pytest
import boto3

cf_client = boto3.client('cloudformation', region_name='eu-west-2')
templatename = 'DRVault-Single-Deployment.json'

class TestDrVaultSingleDeployment():
    
                  
    def test_validate(self, branch, commitid, templateurl):
      template_params = [{'ParameterKey': 'VaultHostName', 'ParameterValue': 'test.drvault', 'UsePreviousValue': False},
                  {'ParameterKey': 'VaultPrivateIP', 'ParameterValue': '10.10.10.10', 'UsePreviousValue': False},
                  {'ParameterKey': 'VaultInstanceSecurityGroups', 'ParameterValue': 'sg-123456', 'UsePreviousValue': False},
                  {'ParameterKey': 'RetypeDRPassword', 'ParameterValue': 'Cyber123456$', 'UsePreviousValue': False},
                  {'ParameterKey': 'DRInstanceSubnetId', 'ParameterValue': 'subnet-123456', 'UsePreviousValue': False},
                  {'ParameterKey': 'KeyName', 'ParameterValue': 'DR-KeyName', 'UsePreviousValue': False},
                  {'ParameterKey': 'VaultMasterPassword', 'ParameterValue': 'Cyber123456$', 'UsePreviousValue': False},
                  {'ParameterKey': 'VaultAdminPassword', 'ParameterValue': 'Cyber123456$', 'UsePreviousValue': False},
                  {'ParameterKey': 'RetypeMasterPassword', 'ParameterValue': 'Cyber123456$', 'UsePreviousValue': False},
                  {'ParameterKey': 'VaultDRPassword', 'ParameterValue': 'Cyber123456$', 'UsePreviousValue': False},
                  {'ParameterKey': 'VaultFilesBucket', 'ParameterValue': 'Cyber123456$', 'UsePreviousValue': False},
                  {'ParameterKey': 'EULA', 'ParameterValue': 'Accept', 'UsePreviousValue': False}]
      response = cf_client.create_change_set(
        StackName = 'test-DRVault-Single-Deployment-{}-{}'.format(branch,commitid),
        TemplateURL = '{}/{}'.format(templateurl, templatename),
        UsePreviousTemplate = False,
        Parameters = template_params,
        Capabilities = [ 'CAPABILITY_IAM' ],
        ChangeSetName = 'test-DRVault-Single-Deployment-{}-{}'.format(branch,commitid),
        Description = 'test-DRVault-Single-Deployment-{}-{}'.format(branch,commitid),
        ChangeSetType = 'CREATE'
      )
      print(response)
  
