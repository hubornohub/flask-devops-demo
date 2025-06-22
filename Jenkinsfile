pipeline {
  agent any

  environment {
    IMAGE_NAME   = 'flask-app'
    IMAGE_TAG    = 'latest'
    REGISTRY     = 'registry.digitalocean.com/sample-registry'
    DOCR_IMAGE   = "${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
    KUBECONFIG   = 'kubeconfig'
  }

  stages {
    stage('Checkout Code') {
      steps {
        checkout scm
      }
    }

    stage('Build') {
      steps {
        sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
      }
    }

    stage('Test') {
      steps {
        sh '''
          pip install -r requirements.txt
          pip install pytest
          pytest tests/
        '''
      }
    }

    stage('Push') {
      steps {
        withCredentials([string(credentialsId: 'DOCR_ACCESS_TOKEN', variable: 'DO_TOKEN')]) {
          sh '''
            echo \$DO_TOKEN | docker login -u doctl --password-stdin registry.digitalocean.com
            docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCR_IMAGE}
            docker push ${DOCR_IMAGE}
          '''
        }
      }
    }

    stage('Deploy') {
      steps {
        withCredentials([file(credentialsId: "${KUBECONFIG}", variable: 'KUBECONFIG_FILE')]) {
          sh '''
            export KUBECONFIG=$KUBECONFIG_FILE
            kubectl apply -f k8s/
          '''
        }
      }
    }
  }

  post {
    success {
      echo 'Deployment to DOKS completed successfully.'
    }
    failure {
      echo 'Deployment failed. Check the console for logs.'
    }
  }
}
