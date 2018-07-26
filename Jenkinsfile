pipeline {
  agent {
    node {
      label 'ansible'
    }
  }
  stages {
    stage('Install virtual environment') {
      steps {
        script {
          sh(script: 'pip install virtualenv --user')
          sh(script: 'export PATH=$PATH:~/.local/bin')
          sh(script: '~/.local/bin/virtualenv testenv')
          sh(script: 'source ./testenv/bin/activate')
          sh(script: 'pip install -r tests/requirements.txt --user')
        }
      }
    }
    stage('Syntax Validation') {
      steps {
        s3Upload(bucket: 'jenkins-pas-on-cloud', file: 'aws')
        script {
          response = sh(script: 'aws cloudformation validate-template --region eu-west-2 --template-url https://s3.eu-west-2.amazonaws.com/jenkins-pas-on-cloud/Vault-Single-Deployment.json', returnStdout: true)
          echo "Template description: ${response}"
        }
      }
    }
  }
}
