pipeline {
  agent {
    node {
      label 'ansible'
    }

  }
  stages {
    stage('Syntax Validation') {
      steps {
        script {
          withAWS(region:'eu-west-2') {
            s3Upload(bucket: 'jenkins-temp-poc', file: 'aws/Vault-Single-Deployment.json')
            def response = cfnValidate(file: 'aws/Vault-Single-Deployment.json')
            echo "Template description: ${response.description}"
          }
        }

      }
    }
  }
}