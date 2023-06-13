pipeline {
  agent {
    label "docker"
  }

  stages {
    stage("Stage 0") {
      steps {
        echo "123"
      }
    }


    stage("Parallel execution") {
      parallel {
        stage("Stage 1") {
          steps {
            sh "whoami"
            echo "I'm running in parallel!"
            sleep 30
          }
        }

        stage("Stage 2") {
          steps {
            sh "pwd"
            echo "I'm also running in parallel!"
            sleep 60
          }
        }

        stage("Fail") {
          steps {
            sleep 45
            sh "/bin/false"
          }
        }
      }
    }

    stage("Stage 3") {
      steps {
        echo "All done now!"
      }
    }
  }
}