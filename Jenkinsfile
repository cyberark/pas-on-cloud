pipeline {
  agent {
    node {
      label 'ansible'
    }
  }
  environment {
    BUCKET = 'jenkins-pas-on-cloud'
    BUCKET_PATH = "${env.BRANCH_NAME}/${env.GIT_COMMIT}"
    
  }
  stages {
    stage('Install virtual environment') {
      steps {
        script {
          sh(script: 'pytohn -m pip install --user virtualenv')
          sh(script: 'python -m virtualenv --no-site-packages testenv')
          sh(script: 'source ./testenv/bin/activate')
          sh(script: 'testenv/bin/pip install -r tests/requirements.txt --no-cache-dir')
        }
      }
    }
    stage('Upload templates to S3 bucket') {
      steps {
        s3Upload(bucket: "$BUCKET", file: 'aws', path: "$BUCKET_PATH/")
      }
    }
    stage('Syntax Validation') {
      environment {
        TEMPLATE_URL = "https://s3.eu-west-2.amazonaws.com/$BUCKET/$BUCKET_PATH"
        AWS_REGION = "eu-west-2"
      }
      steps {
        script {
          response = sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/DRVault-Single-Deployment.json", returnStdout: true)
          echo "Template description: ${response}"
          response = sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/Full-PAS-Deployment.json", returnStdout: true)
          echo "Template description: ${response}"
          response = sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/PAS-AIO-dr-Deployment.json", returnStdout: true)
          echo "Template description: ${response}"
          response = sh(script: "aws cloudformation validate-template --region $AWS_REGION --template-url $TEMPLATE_URL/PAS-AIO-network-environment-template.json", returnStdout: true)
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
    stage('pytest') {
      steps {
        sh(script: "testenv/bin/pytest tests")
      }
    }
  } 
  // Perform cleanup always
  post {
    always {
      s3Delete(bucket: "$BUCKET", path: "$BUCKET_PATH/")
    }
  }
}
