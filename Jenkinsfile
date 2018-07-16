pipeline {
  agent {
    node {
      label 'windows'
    }
  }
  stages {
    stage('Run AWS template structure validation tests [Pester]') {
      steps {
        //powershell "Install-Module -Name Pester -Force -SkipPublisherCheck"
        
        s3Upload(bucket: 'Jenkins-${env.BUILD_ID}', workingDir : 'aws')
        //script {
        //    response = powershell(script: 'Invoke-Pester -Script @{ Path = "tests/structure"; Parameters = @{ randomNumber = "1" }; }', returnStdout: true)
        //    echo "Response: ${response}"
        //}
      }
    }
  }
}
