pipeline {
    agent {label 'npm'}
    stages {
        stage('build') {
            steps {
                echo 'Running npm build'
                
                sh 'npm run build'
            }
        }
        stage('Test') {
            steps{
                script{
                    echo 'Sonar Test'
                    withCredentials([string(credentialsId: 'sonar', variable: 'TOKEN')]) {
                        withSonarQubeEnv('sonar') {
                            sh "/opt/sonar-scanner-4.3.0.2102-linux/bin/sonar-scanner -Dsonar.login=${TOKEN} -Dsonar.projectKey='HelloWorldNodeJs' -Dsonar.typescript.eslint.reportPaths=getStringArray -Dsonar.sourceEncoding=UTF-8 -Dsonar.javascript.lcov.reportPaths=coverage/lcov.info -Dsonar.ws.timeout='6000' -Dsonar.projectBaseDir=."
                            
                        }
                    }
                }
            }
        }
        stage('Quality Gate'){
            steps{
                script{
                    timeout(time: 4, unit: 'MINUTES') { 
                        def qg = waitForQualityGate() 
                        if (qg.status != 'OK') {
                            error "Pipeline aborted due to quality gate failure: ${qg.status}"
                        }
                    }
                }
                
            }
        }
    }
    post {
            always {
                        echo 'Cleaning Workspace...'
                        cleanWs()
                    }

        }
}