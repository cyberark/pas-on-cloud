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
        def s3ObjectUrl = s3PresignURL(bucket: 'jenkins-temp-poc', key: 'aws/Vault-Single-Deployment.json')
        def response = cfnValidate(url: s3ObjectUrl)
        echo "Template description: ${response.description}"
      }
    }
  }
}
