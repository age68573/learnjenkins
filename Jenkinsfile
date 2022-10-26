pipeline {
    agent any
    environment {
       Tag = "0.2.1"
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
        stage('deploy on k8s') {
            steps {
                sshPublisher(publishers: [sshPublisherDesc(configName: 'k8s-master', transfers: [sshTransfer(
                    cleanRemote: false, 
                    excludes: '', 
                    // execCommand: 'kubectl apply -f /root/vue/vue-deployment.yaml',
                    execCommand: "kubectl set image deployment/vue-deployment -n dev xxx=lab.harbor.com/library/vue:${Tag}",
                    execTimeout: 120000, 
                    flatten: false, 
                    makeEmptyDirs: false, 
                    noDefaultExcludes: false, 
                    patternSeparator: '[, ]+', 
                    remoteDirectory: '', 
                    remoteDirectorySDF: false, 
                    removePrefix: '', 
                    sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
            }
        }
    }
}
