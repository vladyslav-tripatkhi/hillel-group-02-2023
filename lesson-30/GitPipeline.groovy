pipeline {
  agent {
    label "dind"
  }
  
  parameters {
    string(
      name: "branch_name",
      description: "Branch name to checkout",
      defaultValue: "master"
    )
  }

  stages {
    stage("Checkout") {
      steps {
        git(
            url: "https://github.com/vladyslav-tripatkhi/react-redux-realworld-example-app.git",
            branch: params.branch_name,
        )
      }
    }

    stage("Build docker image") {
      steps {
        script {
          docker.build "react-app:test"
        }
      }
    }
  }
}