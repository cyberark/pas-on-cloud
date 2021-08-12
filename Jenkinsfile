pipeline {
  agent {
    node {
      label 'ansible'
    }

  }
  environment {
    BUCKET = 'jenkins-pas-on-cloud'
    BUCKET_PATH = "${env.BRANCH_NAME}/${env.GIT_COMMIT}"
    TEMPLATE_URL = "https://s3.eu-west-2.amazonaws.com/$BUCKET/$BUCKET_PATH"
    AWS_REGION = 'eu-west-2'
  }
  stages {
    stage('Install virtual environment') {
      steps {
        script {
          sh(script: 'python3 -m pip install --user virtualenv')
          sh(script: 'python3 -m virtualenv testenv')
          sh(script: 'source ./testenv/bin/activate')
          sh(script: 'testenv/bin/pip install -r tests/requirements.txt')
        }

      }
    }

    stage('Upload templates to S3 bucket') {
      steps {
        s3Upload(bucket: "$BUCKET", file: 'aws', path: "$BUCKET_PATH/")
      }
    }
    stage('Syntax Validation') {
      steps {
        script {
          sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/Full-PAS-Deployment.yaml", returnStdout: true)
          sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/Vault-Single-Deployment.yaml", returnStdout: true)
          sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/DRVault-Single-Deployment.yaml", returnStdout: true)
          sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/PAS-Component-Single-Deployment.yaml", returnStdout: true)
          sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/PAS-AIO-DR-Deployment.yaml", returnStdout: true)
          sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/PTA-Single-Deployment.yaml", returnStdout: true)
          sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/PAS-network-environment-NAT.json", returnStdout: true)
          sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/PAS-network-environment-PrivateLink.json", returnStdout: true)
        }
      }
    }
    stage('cfn-lint') {
      steps {
        script {
          sh(script: "testenv/bin/cfn-lint aws/Full-PAS-Deployment.yaml --ignore-checks W1001", returnStdout: true)
          sh(script: "testenv/bin/cfn-lint aws/Vault-Single-Deployment.yaml --ignore-checks W1001", returnStdout: true)
          sh(script: "testenv/bin/cfn-lint aws/DRVault-Single-Deployment.yaml --ignore-checks W1001", returnStdout: true)
          sh(script: "testenv/bin/cfn-lint aws/PAS-Component-Single-Deployment.yaml --ignore-checks W1001", returnStdout: true)
          sh(script: "testenv/bin/cfn-lint aws/PAS-AIO-DR-Deployment.yaml --ignore-checks W1001", returnStdout: true)
          sh(script: "testenv/bin/cfn-lint aws/PTA-Single-Deployment.yaml --ignore-checks W1001", returnStdout: true)
          sh(script: "testenv/bin/cfn-lint aws/PAS-network-environment-NAT.json --ignore-checks W1001", returnStdout: true)
          sh(script: "testenv/bin/cfn-lint aws/PAS-network-environment-PrivateLink.json --ignore-checks W1001", returnStdout: true)
        }
      }
    }
    stage('pytest') {
      steps {
        script {
          sh(script: "testenv/bin/pytest tests/aws/ --region $AWS_REGION --branch ${env.BRANCH_NAME} --commit-id ${env.GIT_COMMIT} --template-url $TEMPLATE_URL", returnStdout: true)
        }
      }
    }
  }
  post {
    always {
      s3Delete(bucket: "$BUCKET", path: "$BUCKET_PATH/")
    }
  }
}
