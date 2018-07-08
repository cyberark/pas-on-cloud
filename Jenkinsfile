pipeline {
  agent any
  stages {
    stage('validation') {
      steps {
        cfnValidate(file: 'Vault-Single-Deployment.json', url: 'file://Vault-Single-Deployment.json')
      }
    }
  }
}