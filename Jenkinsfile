pipeline {
    agent {
        node {
            label "master"
        } 
    }

    stages {
        stage('rm folder') {
			steps {
				script {
					sh 'rm -rf jenkins-terraform'
				}
			}
		}
        stage('clone repo') {
            steps {
                script{
                    sh 'git clone https://github.com/spadevapps/jenkins-terraform.git'
                }
            }
        }

        stage('start terraform') {
            steps {
                script {
                    sh '/bin/terraform init'
                }             
            }      
        }

        stage('apply terraform') {
            steps {
                script {
                    sh '/bin/terraform apply -input=false -auto-approve'
                }
            }
        }
        
        stage('get pods') {
            steps {
                script {
                    sh '/bin/kubectl get all --all-namespaces'
                }
            }
        }
    } 
}
