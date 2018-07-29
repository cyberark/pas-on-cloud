import pytest
import boto3

cf_client = boto3.client('cloudformation', region_name='eu-west-2')
templatename = 'DRVault-Single-Deployment.json'

class TestDrVaultSingleDeployment():
    def test_validate(self, branch, commitid, templateurl):
      response = cf_client.create_change_set(
        StackName='test-DRVault-Single-Deployment-{}-{}'.format(branch,commitid),
        TemplateURL='{}/{}'.format(templateurl, templatename),
        UsePreviousTemplate=False,
        Parameters=[
            {
                'ParameterKey': 'string',
                'ParameterValue': 'string',
                'UsePreviousValue': False,
                'ResolvedValue': 'string'
            },
        ],
        Capabilities=[ 'CAPABILITY_IAM' ],
        Tags=[
            {
                'Key': 'string',
                'Value': 'string'
            },
        ],
        ChangeSetName='test-DRVault-Single-Deployment-{}-{}'.format(branch,commitid),
        Description='test-DRVault-Single-Deployment-{}-{}'.format(branch,commitid),
        ChangeSetType='CREATE'
    )
  
