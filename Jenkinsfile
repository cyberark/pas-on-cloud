pipeline {
  agent any
  stages {
    stage('Upload template to S3') {
      steps {
        s3Upload(bucket: 'jenkins-temp-poc', file: 'Vault-Single-Deployment.json', path: '/')
      }
    }
    stage('Validation') {
      steps {
        cfnValidate(url: 'https://s3.eu-west-2.amazonaws.com/jenkins-temp-poc/Vault-Single-Deployment.json')
      }
    }
  }
}