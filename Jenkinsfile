Resources:
  LogGroup:
    Type: 'AWS::Logs::LogGroup'
    Properties:
      RetentionInDays: 30
    DeletionPolicy: Retain
  DeployBucket:
    Type: 'AWS::S3::Bucket'
    Properties:
      AccessControl: Private
  CPMCfnInitLogStream:
    Type: 'AWS::Logs::LogStream'
    Properties:
      LogGroupName: !Sub '${LogGroup}'
      LogStreamName: CPMMachine/CPMCfnInitLogStream
    DeletionPolicy: Retain
  CPMConfigurationsLog:
    Type: 'AWS::Logs::LogStream'
    Properties:
      LogGroupName: !Sub '${LogGroup}'
      LogStreamName: CPMMachine/CPMConfigurations
    DeletionPolicy: Retain
  CPMRegistrationLog:
    Type: 'AWS::Logs::LogStream'
    Properties:
      LogGroupName: !Sub '${LogGroup}'
      LogStreamName: CPMMachine/CPMRegistrationLog
    DeletionPolicy: Retain
  CPMSetLocalServiceLog:
    Type: 'AWS::Logs::LogStream'
    Properties:
      LogGroupName: !Sub '${LogGroup}'
      LogStreamName: CPMMachine/CPMSetLocalServiceLog
    DeletionPolicy: Retain
  PSMCfnInitLogStreamLog:
    Type: 'AWS::Logs::LogStream'
    Properties:
      LogGroupName: !Sub '${LogGroup}'
      LogStreamName: PSMMachine/PSMCfnInitLogStreamLog
    DeletionPolicy: Retain
  PSMConfigurationsLog:
    Type: 'AWS::Logs::LogStream'
    Properties:
      LogGroupName: !Sub '${LogGroup}'
      LogStreamName: PSMMachine/PSMConfigurationsLog
    DeletionPolicy: Retain
  PSMRegistrationLog:
    Type: 'AWS::Logs::LogStream'
    Properties:
      LogGroupName: !Sub '${LogGroup}'
      LogStreamName: PSMMachine/PSMRegistrationLog
    DeletionPolicy: Retain
  PVWACfnInitLogStreamLog:
    Type: 'AWS::Logs::LogStream'
    Properties:
      LogGroupName: !Sub '${LogGroup}'
      LogStreamName: PVWAMachine/PVWACfnInitLogStreamLog
    DeletionPolicy: Retain
  PVWAConfigurationsLog:
    Type: 'AWS::Logs::LogStream'
    Properties:
      LogGroupName: !Sub '${LogGroup}'
      LogStreamName: PVWAMachine/PVWAConfigurationsLog
    DeletionPolicy: Retain
  PVWARegistrationLog:
    Type: 'AWS::Logs::LogStream'
    Properties:
      LogGroupName: !Sub '${LogGroup}'
      LogStreamName: PVWAMachine/PVWARegistrationLog
    DeletionPolicy: Retain
  PVWASetLocalServiceLog:
    Type: 'AWS::Logs::LogStream'
    Properties:
      LogGroupName: !Sub '${LogGroup}'
      LogStreamName: PVWAMachine/PVWASetLocalServiceLog
    DeletionPolicy: Retain
  CfnInitLogStream:
    Type: 'AWS::Logs::LogStream'
    Properties:
      LogGroupName: !Sub '${LogGroup}'
      LogStreamName: VaultDRMachine/CfnInitLog
    UpdateReplacePolicy: Retain
    DeletionPolicy: Retain
  VaultInitLogStream:
    Type: 'AWS::Logs::LogStream'
    Properties:
      LogGroupName: !Sub '${LogGroup}'
      LogStreamName: VaultDRMachine/VaultInitLog
    UpdateReplacePolicy: Retain
    DeletionPolicy: Retain
  VaultPostInstallLogStream:
    Type: 'AWS::Logs::LogStream'
    Properties:
      LogGroupName: !Sub '${LogGroup}'
      LogStreamName: VaultDRMachine/VaultPostInstallLog
    UpdateReplacePolicy: Retain
    DeletionPolicy: Retain
  StoreMasterPassword:
    Type: 'AWS::CloudFormation::CustomResource'
    Version: '1.0'
    Properties:
      ServiceToken: !GetAtt StorePasswordLambda.Arn
      Password: !Ref VaultMasterPassword
    DependsOn:
      - LambdaDeployRole
  StoreAdminPassword:
    Type: 'AWS::CloudFormation::CustomResource'
    Properties:
      ServiceToken: !GetAtt StorePasswordLambda.Arn
      Password: !Ref VaultAdminPassword
    DependsOn:
      - LambdaDeployRole
  StoreDRPassword:
    Type: 'AWS::CloudFormation::CustomResource'
    Properties:
      ServiceToken: !GetAtt StorePasswordLambda.Arn
      Password: !Ref VaultDRPassword
    DependsOn:
      - LambdaDeployRole
  CleanMasterPassword:
    Type: 'AWS::CloudFormation::CustomResource'
    Version: '1.0'
    Properties:
      ServiceToken: !GetAtt DeletePasswordLambda.Arn
      key: !GetAtt StoreMasterPassword.SsmId
    DependsOn:
      - LambdaDeployRole
      - VaultDRMachine
  CleanAdminPassword:
    Type: 'AWS::CloudFormation::CustomResource'
    Version: '1.0'
    Properties:
      ServiceToken: !GetAtt DeletePasswordLambda.Arn
      key: !GetAtt StoreAdminPassword.SsmId
    DependsOn:
      - LambdaDeployRole
      - VaultDRMachine
  CleanDRPassword:
    Type: 'AWS::CloudFormation::CustomResource'
    Version: '1.0'
    Properties:
      ServiceToken: !GetAtt DeletePasswordLambda.Arn
      key: !GetAtt StoreDRPassword.SsmId
    DependsOn:
      - LambdaDeployRole
      - VaultDRMachine
  LambdaDeployRole:
    Type: 'AWS::IAM::Role'
    Properties:
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - lambda.amazonaws.com
            Action:
              - 'sts:AssumeRole'
      Policies:
        - PolicyName: CloudWatch
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              - Effect: Allow
                Action:
                  - 'logs:CreateLogGroup'
                  - 'logs:CreateLogStream'
                  - 'logs:DescribeLogGroups'
                  - 'logs:DescribeLogStreams'
                  - 'logs:PutLogEvents'
                Resource:
                  - '*'
        - PolicyName: SSM
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              - Effect: Allow
                Action:
                  - 'ssm:PutParameter'
                  - 'ssm:DeleteParameter'
                Resource:
                  - !Sub >-
                    arn:${AWS::Partition}:ssm:${AWS::Region}:${AWS::AccountId}:parameter/*
  StorePasswordLambda:
    Type: 'AWS::Lambda::Function'
    Properties:
      Description: Saves given password to parameter store as SecureString
      Code:
        ZipFile: |-
          import uuid
          import boto3
          import cfnresponse


          def lambda_handler(event, context):
              ssmClient = boto3.client('ssm')
              physicalResourceId = str(uuid.uuid4())
              if 'PhysicalResourceId' in event:
                  physicalResourceId = event['PhysicalResourceId']
              if 'Password' not in event['ResourceProperties'] or not event['ResourceProperties']['Password']:
                  print ('The property Password must not be empty')
                  return cfnresponse.send(event, context, cfnresponse.FAILED, {}, physicalResourceId)
              try:
                  if event['RequestType'] == 'Delete':
                      ssmClient.delete_parameter(Name=physicalResourceId)
                      print ('Password successfully deleted. Id='+physicalResourceId)
                      return cfnresponse.send(event, context, cfnresponse.SUCCESS, {}, physicalResourceId)
                  if event['RequestType'] == 'Create':
                      ssmClient.put_parameter(Name=physicalResourceId, Value=event['ResourceProperties']['Password'], Type='SecureString')
                      print ('The store parameter has been created. Id='+physicalResourceId)
                      response = {'SsmId': physicalResourceId}
                      return cfnresponse.send(event, context, cfnresponse.SUCCESS, response, physicalResourceId)
              except ssmClient.exceptions.ParameterNotFound:
                  print ('Item already removed')
                  return cfnresponse.send(event, context, cfnresponse.SUCCESS, {}, physicalResourceId)
              except Exception as E:
                  print (E)
                  return cfnresponse.send(event, context, cfnresponse.FAILED, {}, physicalResourceId)
      Runtime: python3.7
      Handler: index.lambda_handler
      Timeout: 60
      Role: !GetAtt LambdaDeployRole.Arn
  DeletePasswordLambda:
    Type: 'AWS::Lambda::Function'
    Properties:
      Description: Delete password from parameter store
      Code:
        ZipFile: |-
          import uuid
          import boto3
          import cfnresponse


          def lambda_handler(event, context):
              ssmClient = boto3.client('ssm')
              physicalResourceId = str(uuid.uuid4())
              if 'PhysicalResourceId' in event:
                  physicalResourceId = event['PhysicalResourceId']
              try:
                  if event['RequestType'] == 'Create':
                      ssmClient.delete_parameter(Name=event['ResourceProperties']['key'])
                      print ('Password succesfully deleted. Id='+event['ResourceProperties']['key'])
                      return cfnresponse.send(event, context, cfnresponse.SUCCESS, {}, physicalResourceId)
                  if event['RequestType'] == 'Delete':
                      return cfnresponse.send(event, context, cfnresponse.SUCCESS, {}, physicalResourceId)
              except ssmClient.exceptions.ParameterNotFound:
                  print ('Item already removed')
                  return cfnresponse.send(event, context, cfnresponse.SUCCESS, {}, physicalResourceId)
              except Exception as E:
                  print (E)
                  return cfnresponse.send(event, context, cfnresponse.FAILED, {}, physicalResourceId)
      Runtime: python3.7
      Handler: index.lambda_handler
      Timeout: 60
      Role: !GetAtt LambdaDeployRole.Arn
  LambdaLogDenyRole:
    Type: 'AWS::IAM::Role'
    Properties:
      AssumeRolePolicyDocument:
        Version: 2012-10-17
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - lambda.amazonaws.com
            Action:
              - 'sts:AssumeRole'
      Policies:
        - PolicyName: denyLambdaLogging
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              - Effect: Deny
                Action:
                  - 'logs:*'
                Resource: '*'
  CopyfileFromBucketLambda:
    Type: 'AWS::Lambda::Function'
    Properties:
      Description: Copy files from foreign region to local region
      Code:
        ZipFile: >-
          import uuid

          import boto3

          import cfnresponse


          def CopyFileFromBucketToBucket(bucket, fileKey, destination,
          destBucket):
             s3Client = boto3.client('s3')
             copy_source = {'Bucket': bucket,'Key': fileKey}
             s3Client.copy_object(CopySource=copy_source, Bucket=destBucket, Key=destination)

          def DeleteObjectFromBucket(bucket, key):
             s3Client = boto3.client('s3')
             s3Client.delete_object(Bucket=bucket, Key=key)

          def lambda_handler(event, context):

             physicalResourceId = str(uuid.uuid4())
             if 'PhysicalResourceId' in event:
                physicalResourceId = event['PhysicalResourceId']

             try:
                if event['RequestType'] == 'Delete':
                      DeleteObjectFromBucket(event['ResourceProperties']['DestBucket'], event['ResourceProperties']['FileKey'])
                      print 'Object Deleted Successfully'
                      return cfnresponse.send(event, context, cfnresponse.SUCCESS, {}, physicalResourceId)

                if event['RequestType'] == 'Create':
                      CopyFileFromBucketToBucket(event['ResourceProperties']['BucketName'],event['ResourceProperties']['FileKey'],event['ResourceProperties']['FileName'],event['ResourceProperties']['DestBucket'])
                      print 'file copied successfully'
                      return cfnresponse.send(event, context, cfnresponse.SUCCESS, {}, physicalResourceId)

             except Exception as E:
                print E
                return cfnresponse.send(event, context, cfnresponse.FAILED, {}, physicalResourceId)
      Runtime: python2.7
      Handler: index.lambda_handler
      Role: !GetAtt LambdaDeployRole.Arn
  RandomStringLambdaFunction:
    Type: 'AWS::Lambda::Function'
    Properties:
      Code:
        ZipFile: >
          const response = require("./cfn-response");

          const randomString = (length, chars) => {
             var result = '';
             for (var i = length; i > 0; --i) result += chars[Math.floor(Math.random() * chars.length)];
             return result;
          }

          exports.handler = (event, context) =>{


          const str = randomString(1, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ') +
          randomString(1, 'abcdefghijklmnopqrstuvwxyz') + randomString(3,
          '0123456789') + randomString(11,
          'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');

          const responseData = {RandomString: str};

          response.send(event, context, response.SUCCESS, responseData);


          };
      Handler: index.handler
      Runtime: nodejs10.x
      Role: !GetAtt LambdaLogDenyRole.Arn
      MemorySize: 128
      Timeout: 20
  PVWASecretString:
    Type: 'AWS::CloudFormation::CustomResource'
    Properties:
      ServiceToken: !GetAtt RandomStringLambdaFunction.Arn
  CPMSecretString:
    Type: 'AWS::CloudFormation::CustomResource'
    Properties:
      Length: 15
      ServiceToken: !GetAtt RandomStringLambdaFunction.Arn
  VaultMachine:
    Type: 'AWS::EC2::Instance'
    Properties:
      Tags:
        - Key: Name
          Value: !Ref VaultInstanceName
      SecurityGroupIds: !Ref VaultInstanceSecurityGroups
      SubnetId: !Ref VaultInstanceSubnetId
      ImageId: !FindInMap 
        - RegionMap
        - !Ref 'AWS::Region'
        - Vault
      InstanceType: !Ref VaultInstanceType
      UserData: !Base64 
        'Fn::Sub': >-
          <script>

          cfn-init.exe -v -s ${AWS::StackId} -r VaultMachine --region
          ${AWS::Region}

          cfn-signal.exe -e %ERRORLEVEL% --stack ${AWS::StackId} --resource
          VaultMachine --region ${AWS::Region}

          </script>
      KeyName: !Ref KeyName
      IamInstanceProfile: !Ref VaultInstancesProfile
    Metadata:
      'AWS::CloudFormation::Init':
        configSets:
          ascending:
            - configSSMAndHostname
            - configServices
            - configSignal
        configSSMAndHostname:
          files:
            'C:\CyberArk\Deployment\KMSPolicy.json':
              content:
                'Fn::Sub': >-
                  {"Statement": [{"Action": ["kms:Encrypt", "kms:Decrypt"],
                  "Resource":
                  "arn:${AWS::Partition}:kms:${AWS::Region}:${AWS::AccountId}:key/KMSKEYID_PLACEHOLDER",
                  "Effect": "Allow"}]}
          services:
            windows:
              AmazonSSMAgent:
                enabled: 'true'
                ensureRunning: 'true'
                files:
                  - >-
                    C:\Program
                    Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json
          commands:
            1-configCloudWatch:
              command: !Sub >
                powershell.exe -File C:\CyberArk\Deployment\CloudWatch.ps1
                -LogGroup ${LogGroup} -CfnInitLogStream ${CfnInitLogStream}
                -VaultInitLogStream ${VaultInitLogStream}
                -VaultPostInstallLogStream ${VaultPostInstallLogStream} -Region
                ${AWS::Region}
              waitAfterCompletion: 10
            2-restartSSM:
              command: powershell.exe -Command "Restart-Service AmazonSSMAgent"
              waitAfterCompletion: 0
        configServices:
          commands:
            1-downloadLicenseRecpub:
              command: !Sub >
                powershell.exe -File C:\CyberArk\Deployment\VaultInit.ps1
                -VaultFilesBucket ${VaultFilesBucket} -LicenseFileKey
                ${LicenseFile} -RecoveryPublicKey ${RecoveryPublicKey} -Region
                ${AWS::Region}
              waitAfterCompletion: 0
            2-fixENE:
              command: |
                powershell.exe -File C:\CyberArk\Deployment\FixENE.ps1
              waitAfterCompletion: 0
            3-postInstall:
              command: !Sub >
                powershell.exe -File C:\CyberArk\Deployment\VaultPostInstall.ps1
                -SSMMasterPassParameterID ${StoreMasterPassword.SsmId}
                -SSMAdminPassParameterID ${StoreAdminPassword.SsmId}
                -IsPrimaryOrDR "Primary" -PrimaryVaultIP "1.1.1.1" -LicensePath
                "C:\CyberArk\Deployment\vaultLicense.xml" -RecoveryPublicKeyPath
                "C:\CyberArk\Deployment\recoveryPublic.key" -Region
                ${AWS::Region}
              waitAfterCompletion: 0
            4-removePermissions:
              command: !Sub >
                powershell.exe -File
                C:\CyberArk\Deployment\VaultRemoveIAMPolicies.ps1 -Role
                ${VaultInstancesRole}
              waitAfterCompletion: 0
        configSignal:
          commands:
            0-signalCompletion:
              command: !Sub >
                cfn-signal.exe -e %ERRORLEVEL% --stack ${AWS::StackId}
                --resource VaultMachine --region ${AWS::Region}
              waitAfterCompletion: 0
    CreationPolicy:
      ResourceSignal:
        Timeout: PT20M
    DeletionPolicy: Retain
  VaultDRMachine:
    Type: 'AWS::EC2::Instance'
    Properties:
      Tags:
        - Key: Name
          Value: !Sub '${VaultInstanceName} DR'
      SecurityGroupIds: !Ref VaultInstanceSecurityGroups
      SubnetId: !Ref DRInstanceSubnetId
      ImageId: !FindInMap 
        - RegionMap
        - !Ref 'AWS::Region'
        - Vault
      InstanceType: !Ref VaultInstanceType
      UserData: !Base64 
        'Fn::Sub': >-
          <script>

          cfn-init.exe -v -s ${AWS::StackId} -r VaultDRMachine --region
          ${AWS::Region}

          cfn-signal.exe -e %ERRORLEVEL% --stack ${AWS::StackId} --resource
          VaultDRMachine --region ${AWS::Region}

          </script>
      KeyName: !Ref KeyName
      IamInstanceProfile: !Ref VaultInstancesProfile
    Metadata:
      'AWS::CloudFormation::Init':
        configSets:
          ascending:
            - configSSMAndHostname
            - configServices
            - configSignal
        configSSMAndHostname:
          files:
            'C:\CyberArk\Deployment\KMSPolicy.json':
              content:
                'Fn::Sub': >-
                  {"Statement": [{"Action": ["kms:Encrypt", "kms:Decrypt"],
                  "Resource":
                  "arn:${AWS::Partition}:kms:${AWS::Region}:${AWS::AccountId}:key/KMSKEYID_PLACEHOLDER",
                  "Effect": "Allow"}]}
          services:
            windows:
              AmazonSSMAgent:
                enabled: 'true'
                ensureRunning: 'true'
                files:
                  - >-
                    C:\Program
                    Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json
          commands:
            1-configCloudWatch:
              command: !Sub >
                powershell.exe -File C:\CyberArk\Deployment\CloudWatch.ps1
                -LogGroup ${LogGroup} -CfnInitLogStream ${CfnInitLogStream}
                -VaultInitLogStream ${VaultInitLogStream}
                -VaultPostInstallLogStream ${VaultPostInstallLogStream} -Region
                ${AWS::Region}
              waitAfterCompletion: 10
            2-restartSSM:
              command: powershell.exe -Command "Restart-Service AmazonSSMAgent"
              waitAfterCompletion: 0
        configServices:
          commands:
            1-downloadLicenseRecpub:
              command: !Sub >
                powershell.exe -File C:\CyberArk\Deployment\VaultInit.ps1
                -VaultFilesBucket ${VaultFilesBucket} -LicenseFileKey
                ${LicenseFile} -RecoveryPublicKey ${RecoveryPublicKey} -Region
                ${AWS::Region}
              waitAfterCompletion: 0
            2-fixENE:
              command: !Sub |
                powershell.exe -File C:\CyberArk\Deployment\FixENE.ps1
              waitAfterCompletion: 0
            3-allowDR:
              command: !Sub >
                powershell.exe -File C:\CyberArk\Deployment\AllowDR.ps1
                -PrimaryVaultIP ${VaultMachine.PrivateIp}
              waitAfterCompletion: 0
            4-postInstall:
              command: !Sub >
                powershell.exe -File C:\CyberArk\Deployment\VaultPostInstall.ps1
                -SSMMasterPassParameterID ${StoreMasterPassword.SsmId}
                -SSMAdminPassParameterID ${StoreAdminPassword.SsmId}
                -SSMDRPassParameterID ${StoreDRPassword.SsmId} -IsPrimaryOrDR
                "DR" -PrimaryVaultIP ${VaultMachine.PrivateIp} -LicensePath
                "C:\CyberArk\Deployment\vaultLicense.xml" -RecoveryPublicKeyPath
                "C:\CyberArk\Deployment\recoveryPublic.key" -Region
                ${AWS::Region}
              waitAfterCompletion: 0
            5-removePermissions:
              command: !Sub >
                powershell.exe -File
                C:\CyberArk\Deployment\VaultRemoveIAMPolicies.ps1 -Role
                ${VaultInstancesRole}
              waitAfterCompletion: 0
        configSignal:
          commands:
            0-signalCompletion:
              command: !Sub >
                cfn-signal.exe -e %ERRORLEVEL% --stack ${AWS::StackId}
                --resource VaultDRMachine --region ${AWS::Region}
              waitAfterCompletion: 0
    CreationPolicy:
      ResourceSignal:
        Timeout: PT20M
    DeletionPolicy: Retain
  VaultInstancesProfile:
    Type: 'AWS::IAM::InstanceProfile'
    Properties:
      Path: /
      Roles:
        - !Ref VaultInstancesRole
  VaultInstancesRole:
    Type: 'AWS::IAM::Role'
    Properties:
      AssumeRolePolicyDocument:
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - ec2.amazonaws.com
            Action:
              - 'sts:AssumeRole'
      Path: /
      Policies:
        - PolicyName: VaultLogPolicy
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              - Effect: Allow
                Action:
                  - 'logs:DescribeLogGroups'
                  - 'logs:DescribeLogStreams'
                Resource:
                  - !Sub >-
                    arn:${AWS::Partition}:logs:${AWS::Region}:${AWS::AccountId}:log-group:${LogGroup}
              - Effect: Allow
                Action:
                  - 'logs:PutLogEvents'
                Resource:
                  - !Sub >-
                    arn:${AWS::Partition}:logs:${AWS::Region}:${AWS::AccountId}:log-group:${LogGroup}:log-stream:${CfnInitLogStream}
                  - !Sub >-
                    arn:${AWS::Partition}:logs:${AWS::Region}:${AWS::AccountId}:log-group:${LogGroup}:log-stream:${VaultInitLogStream}
                  - !Sub >-
                    arn:${AWS::Partition}:logs:${AWS::Region}:${AWS::AccountId}:log-group:${LogGroup}:log-stream:${VaultPostInstallLogStream}
        - PolicyName: VaultSSMPolicy
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              - Effect: Allow
                Action:
                  - 'ssm:GetParameters'
                Resource:
                  - !Sub >-
                    arn:${AWS::Partition}:ssm:${AWS::Region}:${AWS::AccountId}:parameter/${StoreMasterPassword.SsmId}
                  - !Sub >-
                    arn:${AWS::Partition}:ssm:${AWS::Region}:${AWS::AccountId}:parameter/${StoreAdminPassword.SsmId}
                  - !Sub >-
                    arn:${AWS::Partition}:ssm:${AWS::Region}:${AWS::AccountId}:parameter/${StoreDRPassword.SsmId}
        - PolicyName: VaultFilesBucketAccess
          PolicyDocument:
            Statement:
              - Effect: Allow
                Action:
                  - 's3:GetObject'
                  - 's3:GetObjectVersion'
                Resource:
                  - !Sub >-
                    arn:${AWS::Partition}:s3:::${VaultFilesBucket}/${LicenseFile}
                  - !Sub >-
                    arn:${AWS::Partition}:s3:::${VaultFilesBucket}/${RecoveryPublicKey}
        - PolicyName: VaultInstancesKMSPolicy
          PolicyDocument:
            Statement:
              - Effect: Allow
                Action:
                  - 'kms:CreateKey'
                  - 'kms:GenerateRandom'
                  - 'kms:TagResource'
                  - 'kms:Encrypt'
                  - 'kms:Decrypt'
                  - 'kms:EnableKeyRotation'
                  - 'kms:UpdateKeyDescription'
                  - 'kms:CreateAlias'
                Resource: '*'
        - PolicyName: VaultBootstrapIAMPolicy
          PolicyDocument:
            Statement:
              - Effect: Allow
                Action:
                  - 'iam:DeleteRolePolicy'
                  - 'iam:PutRolePolicy'
                Resource: '*'
    DeletionPolicy: Retain
  ComponentInstanceProfile:
    Type: 'AWS::IAM::InstanceProfile'
    Properties:
      Roles:
        - !Ref ComponentInstanceRole
    DeletionPolicy: Retain
  ComponentInstanceRole:
    Type: 'AWS::IAM::Role'
    Properties:
      AssumeRolePolicyDocument:
        Statement:
          - Effect: Allow
            Principal:
              Service:
                - ec2.amazonaws.com
            Action:
              - 'sts:AssumeRole'
      Path: /
      ManagedPolicyArns:
        - !Sub 'arn:${AWS::Partition}:iam::aws:policy/service-role/AmazonEC2RoleforSSM'
      Policies:
        - PolicyName: LogRolePolicy
          PolicyDocument:
            Version: 2012-10-17
            Statement:
              - Effect: Allow
                Action:
                  - 'logs:CreateLogGroup'
                  - 'logs:CreateLogStream'
                  - 'logs:PutLogEvents'
                  - 'logs:DescribeLogStreams'
                Resource:
                  - !Sub 'arn:${AWS::Partition}:logs:*:*:*'
    DeletionPolicy: Retain
  PVWAMachine:
    Type: 'AWS::EC2::Instance'
    Properties:
      Tags:
        - Key: Name
          Value: !Ref PVWAInstanceName
      SecurityGroupIds: !Ref PVWAInstanceSecurityGroups
      SubnetId: !Ref PVWAInstanceSubnetId
      ImageId: !FindInMap 
        - RegionMap
        - !Ref 'AWS::Region'
        - PVWA
      InstanceType: !Ref PVWAInstanceType
      UserData: !Base64 
        'Fn::Sub': >-
          <script>

          cfn-init.exe -v -s ${AWS::StackId} -r PVWAMachine --region
          ${AWS::Region}

          cfn-signal.exe -e %ERRORLEVEL% --stack ${AWS::StackId} --resource
          PVWAMachine --region ${AWS::Region}

          </script>
      KeyName: !Ref KeyName
      IamInstanceProfile: !Ref ComponentInstanceProfile
    Metadata:
      'AWS::CloudFormation::Init':
        configSets:
          ascending:
            - configSSMAndHostname
            - configServices
            - configSignal
        configSSMAndHostname:
          services:
            windows:
              AmazonSSMAgent:
                enabled: 'true'
                ensureRunning: 'true'
                files:
                  - >-
                    C:\Program
                    Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json
          commands:
            1-cloudwatch:
              command: !Sub >
                powershell.exe -File C:\CyberArk\Deployment\CloudWatch.ps1
                -LogGroup ${LogGroup} -PVWACfnInitLogStream
                ${PVWACfnInitLogStreamLog} -PVWAConfiguration
                ${PVWAConfigurationsLog} -PVWARegistration
                ${PVWARegistrationLog} -PVWASetLocalService
                ${PVWASetLocalServiceLog} -Region ${AWS::Region}
            2-downloadLatestSSM:
              command: >
                powershell.exe -Command
                [Net.ServicePointManager]::SecurityProtocol =
                [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest
                "https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe"
                -OutFile "$env:USERPROFILE\Desktop\SSMAgent_latest.exe"
                -UseBasicParsing
              waitAfterCompletion: '0'
              ignoreErrors: 'true'
            3-updateLatestSSM:
              command: >
                powershell.exe -Command Start-Process -FilePath
                $env:USERPROFILE\Desktop\SSMAgent_latest.exe -ArgumentList "/S"
                -Wait
              waitAfterCompletion: '0'
              ignoreErrors: 'true'
            4-removeLatestSSM:
              command: >
                powershell.exe -Command rm -Force
                $env:USERPROFILE\Desktop\SSMAgent_latest.exe
              waitAfterCompletion: '0'
              ignoreErrors: 'true'
            5-restartSSM:
              command: powershell.exe -Command "Restart-Service AmazonSSMAgent"
              waitAfterCompletion: '60'
              ignoreErrors: 'true'
        configServices:
          commands:
            1-configurePVWAService:
              command: !Sub >
                powershell.exe -File C:\CyberArk\Deployment\Set-LocalService.ps1
                -Username "PVWAReportsUser" -Services "CyberArk Scheduled Tasks"
              waitAfterCompletion: '0'
            2-configuration:
              command: !Sub 
                - >-
                  powershell.exe -File
                  C:\CyberArk\Deployment\PVWAConfiguration.ps1 -VaultIpAddress
                  ${VaultIpAddress} -VaultAdminUser Administrator -VaultPort
                  1858 -HostName ${InputHostname}
                - VaultIpAddress: !Sub '${VaultMachine.PrivateIp},${VaultDRMachine.PrivateIp}'
                  InputHostname: !If 
                    - PVWAHostNameEmpty
                    - empty
                    - !Sub '${PVWAHostName}'
              waitAfterCompletion: '0'
            3-registration:
              command: !Sub >
                powershell.exe -File C:\CyberArk\Deployment\PVWARegistration.ps1
                -VaultAdminUser Administrator -SSMAdminPassParameterID
                ${StoreAdminPassword.SsmId}
              waitAfterCompletion: '0'
            4-startAppPool:
              command: >-
                powershell -Command "& {&'Import-Module' WebAdministration}"; "&
                {&'Start-WebAppPool' -Name PasswordVaultWebAccessPool}"; "&
                {&'Set-ItemProperty' -Path
                IIS:\AppPools\PasswordVaultWebAccessPool -Name autoStart -Value
                'true'}"
              waitAfterCompletion: '0'
            5-CSTserviceConfig:
              command: sc config "CyberArk Scheduled Tasks" start=auto
              waitAfterCompletion: '0'
            6-restart:
              command: powershell.exe -Command "Restart-Computer -Force"
              waitAfterCompletion: forever
        configSignal:
          commands:
            0-signalCompletion:
              command: !Sub >
                cfn-signal.exe -e %ERRORLEVEL% --stack ${AWS::StackId}
                --resource PVWAMachine --region ${AWS::Region}
              waitAfterCompletion: '0'
    CreationPolicy:
      ResourceSignal:
        Timeout: PT15M
    DeletionPolicy: Retain
  CPMMachine:
    Type: 'AWS::EC2::Instance'
    Properties:
      Tags:
        - Key: Name
          Value: !Ref CPMInstanceName
      SecurityGroupIds: !Ref CPMInstanceSecurityGroups
      SubnetId: !Ref CPMInstanceSubnetId
      ImageId: !FindInMap 
        - RegionMap
        - !Ref 'AWS::Region'
        - CPM
      InstanceType: !Ref CPMInstanceType
      UserData: !Base64 
        'Fn::Sub': >-
          <script>

          cfn-init.exe -v -s ${AWS::StackId} -r CPMMachine --region
          ${AWS::Region}

          cfn-signal.exe -e %ERRORLEVEL% --stack ${AWS::StackId} --resource
          CPMMachine --region ${AWS::Region}

          </script>
      KeyName: !Ref KeyName
      IamInstanceProfile: !Ref ComponentInstanceProfile
    Metadata:
      'AWS::CloudFormation::Init':
        configSets:
          ascending:
            - configSSMAndHostname
            - configServices
            - configSignal
        configSSMAndHostname:
          services:
            windows:
              AmazonSSMAgent:
                enabled: 'true'
                ensureRunning: 'true'
                files:
                  - >-
                    C:\Program
                    Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json
          commands:
            1-cloudwatch:
              command: !Sub >
                powershell.exe -File C:\CyberArk\Deployment\CloudWatch.ps1
                -LogGroup ${LogGroup} -CPMCfnInitLogStream
                ${CPMCfnInitLogStream} -CPMConfiguration ${CPMConfigurationsLog}
                -CPMRegistration ${CPMRegistrationLog} -CPMSetLocalService
                ${CPMSetLocalServiceLog} -Region ${AWS::Region}
            2-downloadLatestSSM:
              command: !Sub >
                powershell.exe -Command
                [Net.ServicePointManager]::SecurityProtocol =
                [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest
                "https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe"
                -OutFile "$env:USERPROFILE\Desktop\SSMAgent_latest.exe"
                -UseBasicParsing
              waitAfterCompletion: '0'
              ignoreErrors: 'true'
            3-updateLatestSSM:
              command: >
                powershell.exe -Command Start-Process -FilePath
                $env:USERPROFILE\Desktop\SSMAgent_latest.exe -ArgumentList "/S"
                -Wait
              waitAfterCompletion: '0'
              ignoreErrors: 'true'
            4-removeLatestSSM:
              command: >
                powershell.exe -Command rm -Force
                $env:USERPROFILE\Desktop\SSMAgent_latest.exe
              waitAfterCompletion: '0'
              ignoreErrors: 'true'
            5-restartSSM:
              command: powershell.exe -Command "Restart-Service AmazonSSMAgent"
              waitAfterCompletion: '60'
              ignoreErrors: 'true'
        configServices:
          commands:
            1-configuration:
              command: !Sub 
                - >-
                  powershell.exe -File
                  C:\CyberArk\Deployment\CPMConfiguration.ps1 -VaultIpAddress
                  ${VaultIpAddress} -VaultAdminUser Administrator -VaultPort
                  1858
                - VaultIpAddress: !Sub '${VaultMachine.PrivateIp},${VaultDRMachine.PrivateIp}'
              waitAfterCompletion: '0'
            2-registration:
              command: !Sub >
                powershell.exe -File C:\CyberArk\Deployment\CPMRegistration.ps1
                -VaultAdminUser Administrator -SSMAdminPassParameterID
                ${StoreAdminPassword.SsmId}
              waitAfterCompletion: '0'
            3-configureCPMService:
              command: !Sub >
                powershell.exe -File C:\CyberArk\Deployment\Set-LocalService.ps1
                -Username "PasswordManagerUser" -Services "CyberArk Central
                Policy Manager Scanner"
              waitAfterCompletion: '0'
            4-configureCPMService:
              command: !Sub >
                powershell.exe -File C:\CyberArk\Deployment\Set-LocalService.ps1
                -Username "PasswordManagerUser" -Services "CyberArk Password
                Manager"
              waitAfterCompletion: '0'
            5-CPMserviceConfig:
              command: sc config "CyberArk Password Manager" start=auto
              waitAfterCompletion: '0'
            6-CPMSserviceConfig:
              command: sc config "CyberArk Central Policy Manager Scanner" start=auto
              waitAfterCompletion: '0'
        configSignal:
          commands:
            0-signalCompletion:
              command: !Sub >
                cfn-signal.exe -e %ERRORLEVEL% --stack ${AWS::StackId}
                --resource CPMMachine --region ${AWS::Region}
              waitAfterCompletion: '0'
    CreationPolicy:
      ResourceSignal:
        Timeout: PT15M
    DeletionPolicy: Retain
  PSMMachine:
    Type: 'AWS::EC2::Instance'
    Properties:
      Tags:
        - Key: Name
          Value: !Ref PSMInstanceName
      SecurityGroupIds: !Ref PSMInstanceSecurityGroups
      SubnetId: !Ref PSMInstanceSubnetId
      ImageId: !FindInMap 
        - RegionMap
        - !Ref 'AWS::Region'
        - PSM
      InstanceType: !Ref PSMInstanceType
      UserData: !Base64 
        'Fn::Sub': >-
          <script>

          cfn-init.exe -v -s ${AWS::StackId} -r PSMMachine --region
          ${AWS::Region}

          cfn-signal.exe -e %ERRORLEVEL% --stack ${AWS::StackId} --resource
          PSMMachine --region ${AWS::Region}

          </script>
      KeyName: !Ref KeyName
      IamInstanceProfile: !Ref ComponentInstanceProfile
    Metadata:
      'AWS::CloudFormation::Init':
        configSets:
          ascending:
            - configSSMAndHostname
            - configServices
            - configSignal
        configSSMAndHostname:
          services:
            windows:
              AmazonSSMAgent:
                enabled: 'true'
                ensureRunning: 'true'
                files:
                  - >-
                    C:\Program
                    Files\Amazon\SSM\Plugins\awsCloudWatch\AWS.EC2.Windows.CloudWatch.json
          commands:
            1-cloudwatch:
              command: !Sub >
                powershell.exe -File C:\CyberArk\Deployment\CloudWatch.ps1
                -LogGroup ${LogGroup} -PSMCfnInitLogStream
                ${PSMCfnInitLogStreamLog} -PSMConfiguration
                ${PSMConfigurationsLog} -PSMRegistration ${PSMRegistrationLog}
                -Region ${AWS::Region}
            2-downloadLatestSSM:
              command: >
                powershell.exe -Command
                [Net.ServicePointManager]::SecurityProtocol =
                [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest
                "https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/windows_amd64/AmazonSSMAgentSetup.exe"
                -OutFile "$env:USERPROFILE\Desktop\SSMAgent_latest.exe"
                -UseBasicParsing
              waitAfterCompletion: '0'
              ignoreErrors: 'true'
            3-updateLatestSSM:
              command: >
                powershell.exe -Command Start-Process -FilePath
                $env:USERPROFILE\Desktop\SSMAgent_latest.exe -ArgumentList "/S"
                -Wait
              waitAfterCompletion: '0'
              ignoreErrors: 'true'
            4-removeLatestSSM:
              command: >
                powershell.exe -Command rm -Force
                $env:USERPROFILE\Desktop\SSMAgent_latest.exe
              waitAfterCompletion: '0'
              ignoreErrors: 'true'
            5-restartSSM:
              command: powershell.exe -Command "Restart-Service AmazonSSMAgent"
              waitAfterCompletion: '60'
              ignoreErrors: 'true'
        configServices:
          commands:
            1-configuration:
              command: !Sub 
                - >-
                  powershell.exe -File
                  C:\CyberArk\Deployment\PSMConfiguration.ps1 -VaultIpAddress
                  ${VaultIpAddress} -VaultAdminUser Administrator -VaultPort
                  1858
                - VaultIpAddress: !Sub '${VaultMachine.PrivateIp},${VaultDRMachine.PrivateIp}'
              waitAfterCompletion: '0'
            2-registration:
              command: !Sub >
                powershell.exe -File C:\CyberArk\Deployment\PSMRegistration.ps1
                -VaultAdminUser Administrator -SSMAdminPassParameterID
                ${StoreAdminPassword.SsmId}
              waitAfterCompletion: '0'
            3-PSMserviceConfig:
              command: sc config "Cyber-Ark Privileged Session Manager" start=auto
              waitAfterCompletion: '0'
        configSignal:
          commands:
            0-signalCompletion:
              command: !Sub >
                cfn-signal.exe -e %ERRORLEVEL% --stack ${AWS::StackId}
                --resource PSMMachine --region ${AWS::Region}
              waitAfterCompletion: '0'
    CreationPolicy:
      ResourceSignal:
        Timeout: PT15M
    DeletionPolicy: Retain
  PSMPMachine:
    Type: 'AWS::EC2::Instance'
    Properties:
      Tags:
        - Key: Name
          Value: !Ref PSMPInstanceName
      SecurityGroupIds: !Ref PSMPInstanceSecurityGroups
      SubnetId: !Ref PSMPInstanceSubnetId
      ImageId: !FindInMap 
        - RegionMap
        - !Ref 'AWS::Region'
        - PSMP
      InstanceType: !Ref PSMPInstanceType
      UserData: !Base64 
        'Fn::Sub': >
          #!/bin/bash -e

          /opt/aws/bin/cfn-init -v --stack ${AWS::StackId} --resource
          PSMPMachine --configsets install_all --region ${AWS::Region}

          /opt/aws/bin/cfn-signal -e $? --stack ${AWS::StackId} --resource
          PSMPMachine --region ${AWS::Region}
      KeyName: !Ref KeyName
      IamInstanceProfile: !Ref ComponentInstanceProfile
    Metadata:
      'AWS::CloudFormation::Init':
        configSets:
          install_all:
            - install_logs
            - install_psmp
        install_logs:
          files:
            /etc/awslogs/awslogs.conf:
              content: !Sub |
                [general]
                state_file= /var/awslogs/state/agent-state
                [/var/log/cloud-init.log]
                file = /var/log/cloud-init.log
                log_group_name = ${LogGroup}
                log_stream_name = {instance_id}/cloud-init.log
                datetime_format = 
                [/var/log/cloud-init-output.log]
                file = /var/log/cloud-init-output.log
                log_group_name = ${LogGroup}
                log_stream_name = {instance_id}/cloud-init-output.log
                datetime_format = 
                [/var/log/cfn-init.log]
                file = /var/log/cfn-init.log
                log_group_name = ${LogGroup}
                log_stream_name = {instance_id}/cfn-init.log
                datetime_format = 
                [/var/log/cfn-wire.log]
                file = /var/log/cfn-wire.log
                log_group_name = ${LogGroup}
                log_stream_name = {instance_id}/cfn-wire.log
                datetime_format =               
              mode: '000444'
              owner: root
              group: root
            /etc/awslogs/awscli.conf:
              content: !Sub |
                [plugins]
                cwlogs = cwlogs
                [default]
                region = ${AWS::Region}
              mode: '000444'
              owner: root
              group: root
          commands:
            01_create_state_directory:
              command: mkdir -p /var/awslogs/state
          services:
            sysvinit:
              awslogs:
                enabled: 'true'
                ensureRunning: 'true'
                files:
                  - /etc/awslogs/awslogs.conf
        install_psmp:
          commands:
            01-CreateCredFile:
              command: !Sub >-
                sudo /opt/CARKpsmp/bin/createcredfile /root/CD-Image/user.cred
                Password -Username Administrator -Password ${VaultAdminPassword}
                -Hostname
            02-PSMPdeploy:
              command:
                'Fn::Sub':
                  - >-
                    /root/CD-Image/register_and_activation.sh
                    /root/CD-Image/user.cred ${VaultIpAddress} $(curl
                    http://169.254.169.254/latest/meta-data/instance-id) y
                  - VaultIpAddress: !Sub '${VaultMachine.PrivateIp},${VaultDRMachine.PrivateIp}'
            03-PostInstall:
              command: sudo rm -rf /root/CD-Image/
            99-SignalCompletion:
              command: !Sub >-
                /opt/aws/bin/cfn-signal -e $? --stack ${AWS::StackId} --resource
                PSMPMachine --region ${AWS::Region}
    DependsOn:
      - PSMMachine
    CreationPolicy:
      ResourceSignal:
        Timeout: PT10M
    DeletionPolicy: Retain
  InstancesSSMPolicy:
    Type: 'AWS::IAM::Policy'
    Properties:
      PolicyName: InstancesSsmAccess
      PolicyDocument:
        Statement:
          - Effect: Allow
            Action:
              - 'ssm:GetParameter'
            Resource:
              - !Sub >-
                arn:${AWS::Partition}:ssm:${AWS::Region}:${AWS::AccountId}:parameter/*
      Roles:
        - !Ref ComponentInstanceRole
        - !Ref VaultInstancesRole
  VaultInstancesKMSPolicy:
    Type: 'AWS::IAM::Policy'
    Properties:
      PolicyName: VaultInstancesKMSAccess
      PolicyDocument:
        Statement:
          - Effect: Allow
            Action:
              - 'kms:Encrypt'
              - 'kms:Decrypt'
            Resource: '*'
      Roles:
        - !Ref VaultInstancesRole
    DeletionPolicy: Retain
  VaultInstancesS3VaultFilesBucketPolicy:
    Type: 'AWS::IAM::Policy'
    Properties:
      PolicyName: VaultFilesBucketAccess
      PolicyDocument:
        Statement:
          - Effect: Allow
            Action:
              - 's3:GetObject'
              - 's3:GetObjectVersion'
            Resource: !Sub 'arn:${AWS::Partition}:s3:::${VaultFilesBucket}/*'
      Roles:
        - !Ref VaultInstancesRole
  VaultBootstrapKMSPolicy:
    Type: 'AWS::IAM::Policy'
    Properties:
      PolicyName: VaultBootstrapKMSAccess
      PolicyDocument:
        Statement:
          - Effect: Allow
            Action:
              - 'kms:CreateKey'
              - 'kms:GenerateRandom'
            Resource: '*'
      Roles:
        - !Ref VaultInstancesRole
Parameters:
  EULA:
    Type: String
    Description: I have read and agree to the Terms and Conditions.
    AllowedValues:
      - Accept
      - Decline
    Default: Decline
  KeyName:
    Type: 'AWS::EC2::KeyPair::KeyName'
    Description: Select an existing Key Pair from your AWS account.
    ConstraintDescription: Can contain only ASCII characters.
  VaultFilesBucket:
    Type: String
    Description: >-
      Enter the name of the bucket containing the license and recovery public
      key.
  LicenseFile:
    Type: String
    Description: Enter the path of the license file within the bucket.
    Default: license.xml
  RecoveryPublicKey:
    Type: String
    Description: Enter the path of the recovery public key file within the bucket.
    Default: recpub.key
  VaultInstanceName:
    Type: String
    Description: Enter a name for the Vault instance.
    Default: CyberArk Vault
  VaultMasterPassword:
    Type: String
    Description: Enter a password for the Vault Master user.
    NoEcho: true
    MinLength: 8
    AllowedPattern: >-
      ^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[~!@#$%^&\*\(\)_\-+=:])(?=\S+$).{8,}$
    ConstraintDescription: >-
      Vault Master password must contain at least 1 lowercase letter, 1
      uppercase letter, 1 digit and 1 special character
  RetypeMasterPassword:
    Type: String
    Description: Retype the password for the Vault Master user.
    NoEcho: true
    MinLength: 8
  VaultAdminPassword:
    Type: String
    Description: Enter a password for the Vault Administrator user.
    NoEcho: true
    MinLength: 8
    AllowedPattern: >-
      ^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[~!@#$%^&\*\(\)_\-+=:])(?=\S+$).{8,}$
    ConstraintDescription: >-
      Vault Administrator password must contain at least 1 lowercase letter, 1
      uppercase letter, 1 digit and 1 special character
  RetypeAdminPassword:
    Type: String
    Description: Retype the password for the Vault Administrator user.
    NoEcho: true
    MinLength: 8
  VaultDRPassword:
    Type: String
    Description: Enter a password for the Vault DR user.
    NoEcho: true
    MinLength: 8
    AllowedPattern: >-
      ^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[~!@#$%^&\*\(\)_\-+=:])(?=\S+$).{8,}$
    ConstraintDescription: >-
      Vault DR password must contain at least 1 lowercase letter, 1 uppercase
      letter, 1 digit and 1 special character
  RetypeDRPassword:
    Type: String
    Description: Retype the password for the Vault DR user.
    NoEcho: true
    MinLength: 8
  VaultInstanceType:
    Type: String
    Description: Select the instance type of the Vault instance.
    AllowedValues:
      - m5.large
      - m5.xlarge
      - m5.2xlarge
      - m5.4xlarge
    Default: m5.large
  VaultInstanceSecurityGroups:
    Type: 'List<AWS::EC2::SecurityGroup::Id>'
    Description: Assign Security Groups to the Vault and Vault DR instances.
  VaultInstanceSubnetId:
    Type: 'AWS::EC2::Subnet::Id'
    Description: Select the Subnet Id where the Vault instance will reside.
  DRInstanceSubnetId:
    Type: 'AWS::EC2::Subnet::Id'
    Description: Select the Subnet Id where the Vault DR instance will reside.
  CPMInstanceName:
    Type: String
    Description: Enter a name for the CPM instance.
    Default: CyberArk CPM
  CPMInstanceType:
    Type: String
    Description: Select the instance type of the CPM instance.
    AllowedValues:
      - c5.large
      - c5.xlarge
      - c5.2xlarge
      - c5.4xlarge
    Default: c5.large
  CPMInstanceSecurityGroups:
    Type: 'List<AWS::EC2::SecurityGroup::Id>'
    Description: Assign Security Groups to the CPM instance.
  CPMInstanceSubnetId:
    Type: 'AWS::EC2::Subnet::Id'
    Description: Select the Subnet Id where the CPM instance will reside.
  PVWAInstanceName:
    Type: String
    Description: Enter a name for the PVWA instance.
    Default: CyberArk PVWA
  PVWAInstanceType:
    Type: String
    Description: Select the instance type of the PVWA instance.
    AllowedValues:
      - t3.medium
      - t3.large
      - t3.xlarge
      - t3.2xlarge
    Default: t3.medium
  PVWAInstanceSecurityGroups:
    Type: 'List<AWS::EC2::SecurityGroup::Id>'
    Description: Assign Security Groups to the PVWA instance.
  PVWAInstanceSubnetId:
    Type: 'AWS::EC2::Subnet::Id'
    Description: Select the Subnet Id where the PVWA instance will reside.
  PVWAHostName:
    Type: String
    Description: IP or FQDN of PVWA server
  PSMInstanceName:
    Type: String
    Description: Enter a name for the PSM instance.
    Default: CyberArk PSM
  PSMInstanceType:
    Type: String
    Description: Select the instance type of the PSM instance.
    AllowedValues:
      - m5.2xlarge
      - m5.4xlarge
      - m5.8xlarge
    Default: m5.2xlarge
  PSMInstanceSecurityGroups:
    Type: 'List<AWS::EC2::SecurityGroup::Id>'
    Description: Assign Security Groups to the PSM instance.
  PSMInstanceSubnetId:
    Type: 'AWS::EC2::Subnet::Id'
    Description: Select the Subnet Id where the PSM instance will reside.
  PSMPInstanceName:
    Type: String
    Description: Enter a name for the PSM SSH Proxy instance.
    Default: CyberArk PSM SSH Proxy
  PSMPInstanceType:
    Type: String
    Description: Select the instance type of the PSM SSH Proxy instance.
    AllowedValues:
      - m5.large
      - m5.xlarge
      - m5.2xlarge
      - m5.4xlarge
    Default: m5.large
  PSMPInstanceSecurityGroups:
    Type: 'List<AWS::EC2::SecurityGroup::Id>'
    Description: Assign Security Groups to the PSM SSH Proxy instance.
  PSMPInstanceSubnetId:
    Type: 'AWS::EC2::Subnet::Id'
    Description: Select the Subnet Id where the PSM SSH Proxy instance will reside.
Conditions:
  PVWAHostNameEmpty: !Equals 
    - ''
    - !Ref PVWAHostName
Rules:
  PasswordConfirmation:
    Assertions:
      - Assert: !Equals 
          - !Ref VaultMasterPassword
          - !Ref RetypeMasterPassword
        AssertDescription: The password confirmation does not match.
      - Assert: !Equals 
          - !Ref VaultAdminPassword
          - !Ref RetypeAdminPassword
        AssertDescription: The password confirmation does not match.
      - Assert: !Equals 
          - !Ref VaultDRPassword
          - !Ref RetypeDRPassword
        AssertDescription: The password confirmation does not match.
  EULAAcception:
    Assertions:
      - Assert: !Equals 
          - !Ref EULA
          - Accept
        AssertDescription: You must accept EULA to continue.
Metadata:
  'AWS::CloudFormation::Interface':
    ParameterGroups:
      - Label:
          default: General parameters
        Parameters:
          - EULA
          - KeyName
          - VaultFilesBucket
          - LicenseFile
          - RecoveryPublicKey
      - Label:
          default: Vault and Vault DR configuration
        Parameters:
          - VaultInstanceName
          - VaultMasterPassword
          - RetypeMasterPassword
          - VaultAdminPassword
          - RetypeAdminPassword
          - VaultDRPassword
          - RetypeDRPassword
          - VaultInstanceType
          - VaultInstanceSecurityGroups
          - VaultInstanceSubnetId
          - DRInstanceSubnetId
      - Label:
          default: CPM configuration
        Parameters:
          - CPMInstanceName
          - CPMInstanceType
          - CPMInstanceSecurityGroups
          - CPMInstanceSubnetId
      - Label:
          default: PVWA configuration
        Parameters:
          - PVWAInstanceName
          - PVWAInstanceType
          - PVWAInstanceSecurityGroups
          - PVWAInstanceSubnetId
          - PVWAHostName
      - Label:
          default: PSM configuration
        Parameters:
          - PSMInstanceName
          - PSMInstanceType
          - PSMInstanceSecurityGroups
          - PSMInstanceSubnetId
      - Label:
          default: PSM SSH Proxy configuration
        Parameters:
          - PSMPInstanceName
          - PSMPInstanceType
          - PSMPInstanceSecurityGroups
          - PSMPInstanceSubnetId
    ParameterLabels:
      EULA:
        default: License Agreement
      KeyName:
        default: Key Pair
      VaultFilesBucket:
        default: Vault Files Bucket
      LicenseFile:
        default: License File
      RecoveryPublicKey:
        default: Recovery Public Key
      VaultInstanceName:
        default: Vault Instance Name
      VaultMasterPassword:
        default: Vault Master Password
      RetypeMasterPassword:
        default: Retype Master Password
      VaultAdminPassword:
        default: Vault Admin Password
      RetypeAdminPassword:
        default: Retype Admin Password
      VaultDRPassword:
        default: DR Password
      RetypeDRPassword:
        default: Retype DR Password
      VaultInstanceType:
        default: Vault and Vault DR Instance Type
      VaultInstanceSecurityGroups:
        default: Vault Security Groups
      VaultInstanceSubnetId:
        default: Vault Instance Subnet Id
      DRInstanceSubnetId:
        default: Vault DR Instance Subnet Id
      CPMInstanceName:
        default: CPM Instance Name
      CPMInstanceType:
        default: CPM Instance Type
      CPMInstanceSecurityGroups:
        default: CPM Instance Security Groups
      CPMInstanceSubnetId:
        default: CPM Instance Subnet Id
      PVWAInstanceName:
        default: PVWA Instance Name
      PVWAInstanceType:
        default: PVWA Instance Type
      PVWAInstanceSecurityGroups:
        default: PVWA Instance Security Groups
      PVWAInstanceSubnetId:
        default: PVWA Instance Subnet Id
      PVWAHostName:
        default: PVWA FQDN (Optional)
      PSMInstanceName:
        default: PSM Instance Name
      PSMInstanceType:
        default: PSM Instance Type
      PSMInstanceSecurityGroups:
        default: PSM Instance Security Groups
      PSMInstanceSubnetId:
        default: PSM Instance Subnet Id
      PSMPInstanceName:
        default: PSM SSH Proxy Instance Name
      PSMPInstanceType:
        default: PSM SSH Proxy Instance Type
      PSMPInstanceSecurityGroups:
        default: PSM SSH Proxy Instance Security Groups
      PSMPInstanceSubnetId:
        default: PSM SSH Proxy Instance Subnet Id
Mappings:
  RegionMap:
    us-east-1:
      Vault: ami-01d4a7bd46088f700
      CPM: ami-0c5048832f0ba342b
      PVWA: ami-01512e92898f7ba04
      PSM: ami-08e096c0a3522f356
      PSMP: ami-0bb8f4622a32ccbbe
    us-east-2:
      Vault: ami-068bc4ecc92db8199
      CPM: ami-083b0f4f9d741d954
      PVWA: ami-0f945da6e23f077a9
      PSM: ami-09b4ac3bdeae933c0
      PSMP: ami-022c7e173b0e6e7c4
    eu-west-2:
      Vault: ami-08e302bd203bff170
      CPM: ami-0d5a063b7e7768e1e
      PVWA: ami-00cc2f98a86beb833
      PSM: ami-00cc2f98a86beb833
      PSMP: ami-0e04bdb478e01edec
    us-west-1:
      Vault: ami-0f1803a9c76472be5
      CPM: ami-099bcb5ad7933f4ea
      PVWA: ami-04696a8ab6b72e55c
      PSM: ami-01eb3fb9c9c81365d
      PSMP: ami-056229e9b60431969
    us-west-2:
      Vault: ami-01edee6e967c17628
      CPM: ami-0e217872421f388da
      PVWA: ami-08d239a59b430d34e
      PSM: ami-08ee313797af3001f
      PSMP: ami-02643903bb58ccd9b
    ca-central-1:
      Vault: ami-0582d8c1a70001244
      CPM: ami-0d30069a5fefbb76b
      PVWA: ami-0609dcbfc67c0ff0b
      PSM: ami-0ac9ec0e3a84f7d2f
      PSMP: ami-0169b158e5aedf114
    eu-west-1:
      Vault: ami-09397273b9046d5b9
      CPM: ami-0e7871f260cff49cd
      PVWA: ami-06b533e49a82d0eaf
      PSM: ami-0c1aab51f2b76b3f3
      PSMP: ami-0fcc0e1d2a564297c
    eu-central-1:
      Vault: ami-06f43402c6e002660
      CPM: ami-0d80700930f21c822
      PVWA: ami-0f9f83f225903fa54
      PSM: ami-0d25e8bcf7b72ddc4
      PSMP: ami-0646e73bd35827fd3
    ap-southeast-1:
      Vault: ami-0872cf43e69e28466
      CPM: ami-0f4c5e5d997518a87
      PVWA: ami-0cb6d24dcd607ec98
      PSM: ami-08f7c51d67091747f
      PSMP: ami-0e39d0b84ebb54e1a
    ap-southeast-2:
      Vault: ami-0a02581b7c2a55e6f
      CPM: ami-0ba04d0de7e57e96a
      PVWA: ami-03f90659c438a56c8
      PSM: ami-0221aac7e5aa4877e
      PSMP: ami-0d13566385aaaa992
    ap-northeast-2:
      Vault: ami-0ed3745003fa46976
      CPM: ami-089d652381509cb91
      PVWA: ami-0d40187c0f8c4b8db
      PSM: ami-08ac621e8106f7ece
      PSMP: ami-04401539a5f3afc5c
    ap-northeast-1:
      Vault: ami-02e14fe4621742bde
      CPM: ami-0e8fa7121b8b46482
      PVWA: ami-0fcb9f4bfab7f1b64
      PSM: ami-03de5e42ad5435e97
      PSMP: ami-0320b8464c30d2df8
    ap-south-1:
      Vault: ami-0ff8fe4a731baa07a
      CPM: ami-06abf8d5e4c0f3ba1
      PVWA: ami-076964d92284f16fa
      PSM: ami-000f302e84175b8ab
      PSMP: ami-02dc87adaa5c196da
    sa-east-1:
      Vault: ami-04b91be9198835fc8
      CPM: ami-0c4d646f214dc2565
      PVWA: ami-0f7517ec36ced0752
      PSM: ami-0a0688382df21b7fa
      PSMP: ami-02129f1be6a069a69
    us-gov-west-1:
      Vault: ami-0e87a36f
      CPM: ami-e94e6a88
      PVWA: ami-f2e2c693
      PSM: ami-13406472
      PSMP: ami-2c23044d
    us-gov-east-1:
      Vault: ami-00268514ee37890b9
      CPM: ami-084456b03a3ed8ab2
      PVWA: ami-062952a36194ca27e
      PSM: ami-07858426bb4179bfc
      PSMP: ami-06569e3bb5ab0cf98
Outputs:
  CloudWatchLogGroupName:
    Description: The name of the CloudWatch log group
    Value: !Ref LogGroup
