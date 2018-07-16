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
        
        GIT_COMMIT_HASH = sh (script: "git log -n 1 --pretty=format:'%H'", returnStdout: true)
        script {
        echo "**************************************************"
                echo "${GIT_COMMIT_HASH}"
                echo "**************************************************"
        }
        s3Upload(bucket: 'Jenkins-${GIT_COMMIT_HASH}', workingDir : 'aws')
        //script {
        //    response = powershell(script: 'Invoke-Pester -Script @{ Path = "tests/structure"; Parameters = @{ randomNumber = "1" }; }', returnStdout: true)
        //    echo "Response: ${response}"
        //}
      }
    }
  }
}
