pipeline {
  agent {
    node {
      label 'LinuxTestSlave'
    }

  }
  environment {
    BUCKET = 'cinit-pas-on-cloud-bucket'
    BUCKET_PATH = "${env.BRANCH_NAME}/${env.GIT_COMMIT}"
    TEMPLATE_URL = "https://s3.eu-west-2.amazonaws.com/$BUCKET/$BUCKET_PATH"
    AWS_REGION = 'eu-west-2'
  }
  stages {
    stage('Upload templates to S3 bucket') {
      steps {
        withCredentials([
              conjurSecretCredential(credentialsId: 'cinit-AWS-pasoncloud-Access-Key', variable: 'AWS_ACCESS_KEY_ID'),
              conjurSecretCredential(credentialsId: 'cinit-AWS-pasoncloud-Secret-Key', variable: 'AWS_SECRET_ACCESS_KEY')
             ]){     
          s3Upload(bucket: "$BUCKET", file: 'aws', path: "$BUCKET_PATH/")
        }
      }
    }
    stage('Syntax Validation') {
      steps {
        script {
          withCredentials([
              conjurSecretCredential(credentialsId: 'cinit-AWS-pasoncloud-Access-Key', variable: 'AWS_ACCESS_KEY_ID'),
              conjurSecretCredential(credentialsId: 'cinit-AWS-pasoncloud-Secret-Key', variable: 'AWS_SECRET_ACCESS_KEY')
             ]){    
                response = sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/DRVault-Single-Deployment.json", returnStdout: true)
                echo "Template description: ${response}"
                response = sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/Full-PAS-Deployment.json", returnStdout: true)
                echo "Template description: ${response}"
                response = sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/PAS-AIO-dr-Deployment.json", returnStdout: true)
                echo "Template description: ${response}"
                response = sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/PAS-AIO-template.json", returnStdout: true)
                echo "Template description: ${response}"
                response = sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/PAS-Component-Single-Deployment.json", returnStdout: true)
                echo "Template description: ${response}"
                response = sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/PAS-network-environment-template.json", returnStdout: true)
                echo "Template description: ${response}"
                response = sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/Vault-Single-Deployment.json", returnStdout: true)
                echo "Template description: ${response}"
          }
        }
      }
    }
  }
  post {
    always {
      withCredentials([
              conjurSecretCredential(credentialsId: 'cinit-AWS-pasoncloud-Access-Key', variable: 'AWS_ACCESS_KEY_ID'),
              conjurSecretCredential(credentialsId: 'cinit-AWS-pasoncloud-Secret-Key', variable: 'AWS_SECRET_ACCESS_KEY')
             ]){
          s3Delete(bucket: "$BUCKET", path: "$BUCKET_PATH/")
      }
    }
  }
}
