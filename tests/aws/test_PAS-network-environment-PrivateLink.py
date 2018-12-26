import pytest
import boto3



class TestPASNetworkEnvironmentPrivateLinkTemplate():
  cf_client = boto3.client('cloudformation', region_name='eu-west-2')
  templatename = 'PAS-network-environment-PrivateLink'
  
  @pytest.fixture
  def load_template_resources(self, branch, commitid, templateurl):
      template_params = [
                {'ParameterKey': 'UsersAccessCIDR','ParameterValue': '0.0.0.0/0','UsePreviousValue': False},
                {'ParameterKey': 'AdministrativeAccessCIDR', 'ParameterValue': '0.0.0.0/0', 'UsePreviousValue': False}
      ]
      response = self.cf_client.create_change_set(
        StackName = 'test-{}-{}-{}'.format(self.templatename,branch,commitid),
        TemplateURL = '{}/{}.json'.format(templateurl, self.templatename),
        UsePreviousTemplate = False,
        Parameters = template_params,
        Capabilities = [ 'CAPABILITY_IAM' ],
        ChangeSetName = 'test-{}-{}-{}'.format(self.templatename,branch,commitid),
        Description = 'test-{}-{}-{}'.format(self.templatename,branch,commitid),
        ChangeSetType = 'CREATE'
      )
      
      res = self.cf_client.describe_change_set(
            StackName='test-{}-{}-{}'.format(self.templatename,branch,commitid),
            ChangeSetName='test-{}-{}-{}'.format(self.templatename,branch,commitid)
      )

      resources = {}
      for resource in res['Changes']:
        if resource['ResourceChange']['Action'] == "Add":
          if resource['ResourceChange']['ResourceType'] not in resources:
              resources[resource['ResourceChange']['ResourceType']] = []
          resources[resource['ResourceChange']['ResourceType']].append(resource['ResourceChange']['LogicalResourceId'])
      return resources
  

  def test_VaultSingleDeployment(self, load_template_resources):
      
      print(load_template_resources)
                
