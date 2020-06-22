tag = ''
pipeline {
    agent {label 'npm'}
    stages {
        
        stage('Build') {
            steps {
                echo 'Running npm build'
                
                sh 'npm run build'
            }
        }
        stage('SonarQube Test') {
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
        stage('Tag'){
            steps{
                script{
                    tag = input(message: "Ingrese tag", parameters: [string(defaultValue: '', description: 'tag para git e imagen docker', name: 'tag', trim: false)])
                    echo "${tag}"
                    
                }
            }
        }
        stage('Tag Git Repository'){
            steps{
                echo "Tag de repositorio GitHub"
                withCredentials([usernamePassword(credentialsId: 'GitHubCredential', passwordVariable: 'GIT_PWD', usernameVariable: 'GIT_USR')]) {
                    sh "git tag ${tag}"
                    sh "git push https://${GIT_USR}:${GIT_PWD}@github.com/martincandal/hello-world-npm.git --tags"
                }
                
            }
        }
        stage('Build Image'){
            steps{
                echo "TAG: ${tag}"
                sh "sudo docker build -t hello-world-npm:${tag} ."
            }
        }
        stage('Stop Current Container'){
            steps{
                echo "Stop de container actual"
                sh 'sudo docker stop $(sudo docker ps |grep  hello-world-npm | awk \'{print $1}\')'
            }
        }
        stage ('Deploy Image'){
            steps{
                echo "Deploy de imagen"
                sh "sudo docker run -p 8090:8090 -d hello-world-npm:${tag}"
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