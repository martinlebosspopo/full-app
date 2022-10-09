def remote = [:]
remote.name = 'java_serv'
remote.host = '54.172.243.140'
remote.user = 'martin'
remote.password = 'maletroumo'
remote.allowAnyHosts = true

def old_jar_path = 'build/libs/full-app-0.0.1-SNAPSHOT.jar'
def new_jar_path = 'build/libs/full-app.jar'

pipeline {
    agent any

    stages {
        stage('Clone repo') {
            steps {
                echo old_jar_path
                git 'https://github.com/martinlebosspopo/full-app.git'
            }
        }
        stage('Build jar gradle') {
            steps {
                sh './gradlew build'
                sh "mv ${old_jar_path} ${new_jar_path}"
                archiveArtifacts artifacts: new_jar_path, fingerprint: true
            }
        }
        stage('Copy jar to java server') {
            steps {
                sshPut remote: remote, from: new_jar_path, into: '.'
                sshPut remote: remote, from: 'Dockerfile', into: '.'
            }
        }
        stage('Stop container') {
            steps {
                script {
                    try {
                        sshCommand remote: remote, command:"docker stop springapp_container"
                    } catch (err) {
                        echo err.getMessage()
                    }
                    try {
                        sshCommand remote: remote, command:"docker rm springapp_container"
                    } catch (err) {
                        echo err.getMessage()
                    }
                }
            }
        }
        stage('Build and run new image') {
            steps {
                sshCommand remote: remote, command:"docker build . -t spring_image"
                sshCommand remote: remote, command:"docker run -d -p 8080:8080 --name springapp_container spring_image"
            }
        }
    }
}