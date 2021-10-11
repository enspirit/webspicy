pipeline {

  agent {
    label 'buildkit'
  }

  triggers {
    issueCommentTrigger('.*build this please.*')
  }

  environment {
    SLACK_CHANNEL = '#opensource-cicd'
    DOCKER_REGISTRY = 'docker.io'
    VERSION = get_docker_tag()
  }

  stages {

    stage ('Start') {
      steps {
        cancelPreviousBuilds()
        sendNotifications('STARTED', SLACK_CHANNEL)
      }
    }

    stage ('Running all tests') {
      steps {
        container('builder') {
          script {
            sh 'make jenkins-test'
          }
        }
        junit testResults: 'test-results/*.xml',
          allowEmptyResults: false
      }
    }

    stage ('Building Docker Images') {
      steps {
        container('builder') {
          script {
            sh 'make images'
          }
        }
      }
    }

    stage ('Building and Pushing Gems') {
      environment {
        GEM_HOST_API_KEY = credentials('jenkins-rubygems-api-key')
      }
      when {
        buildingTag()
      }
      steps {
        container('builder') {
          script {
            sh 'make release'
          }
        }
      }
    }

    stage ('Pushing Docker Images') {
      when {
        anyOf {
          branch 'master'
          buildingTag()
        }
      }
      steps {
        container('builder') {
          script {
            docker.withRegistry('', 'dockerhub-credentials') {
              sh 'make push-images'
            }
          }
        }
      }
    }
  }

  post {
    success {
      sendNotifications('SUCCESS', SLACK_CHANNEL)
    }
    failure {
      sendNotifications('FAILED', SLACK_CHANNEL)
      junit testResults: '/test-results/*.xml',
        allowEmptyResults: true
    }
  }
}

def get_docker_tag() {
  if (env.TAG_NAME != null) {
    return env.TAG_NAME
  }
  if (env.BRANCH_NAME == "staging") {
    return 'staging'
  }
  return 'latest'
}
