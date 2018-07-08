pipeline {
  agent any
  stages {
    stage('validation') {
      steps {
        cfnValidate(file: 'aws/Vault-Single-Deployment.json')
      }
    }
  }
}
