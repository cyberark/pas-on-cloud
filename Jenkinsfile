pipeline {
  agent {
    node {
      label 'ansible'
    }

  }
  stages {
    stage('Syntax Validation') {
      steps {
        s3Upload(bucket: 'jenkins-temp-poc', file: 'aws/Vault-Single-Deployment.json')
        script {
          response = sh(script: 'aws cloudformation validate-template --region eu-west-2 --template-url https://s3.eu-west-2.amazonaws.com/jenkins-temp-poc/Vault-Single-Deployment.json', returnStdout: true)
          echo "Template description: ${response}"
        }
      }
    }
  }
}
