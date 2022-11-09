pipeline {
    agent any
    environment {
       Tag = "0.2.9"
    }
    stages {
        
        stage('git pull') {
            steps {
                echo "${Tag}"
                // cleanWs()
                checkout([$class: 'GitSCM', branches: [[name: "refs/tags/$Tag"]], extensions: [], userRemoteConfigs: [[url: 'https://github.com/age68573/learnjenkins.git']]])
                
                echo 'Hello World'
                
            }
        }
//         stage('SonarQube Analysis') {
//             def scannerHome = tool 'sonarqube-scanner';
//             withSonarQubeEnv('sonarqube') {
//               sh "${scannerHome}/bin/sonar-scanner"
//             }
//         }
        stage('sonar scan') { 
            steps {
                script {
                    // 引入sonarQubeScanner 工具
                    scannerHome= tool 'sonarqube-scanner'
                }
                // 引入 sonarQube server 的環境 在 manage configure  SonarQube servers
                withSonarQubeEnv('sonarqube') {
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=vue-app"
                    //sh "${scannerHome} -Dsonar.projectKey=develop"
                }
            }
        }
        stage('npm stage') {
            steps {
                sh 'node -v'
                sh 'npm install'
                sh 'npm run build' 
            }
        }
        stage('docker build') {
            steps {
                // sh 'docker -v'
                // sh 'docker login -u admin -p Harbor12345 https://lab.harbor.com'
                sh 'docker build -t lab.harbor.com/library/vue:${Tag} .'
                // sh 'docker tag vue:$Tag lab.harbor.com/library/vue:$Tag'
                withDockerRegistry(credentialsId: 'harbor', url: 'https://lab.harbor.com') {
                    sh 'docker push lab.harbor.com/library/vue:${Tag}'
                }
                sh 'docker system prune --force --all'
            }
        }
    }
}
