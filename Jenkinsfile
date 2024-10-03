pipeline {
    agent any
    
    tools {
        maven 'maven3'
    }
    
    environment {
        SCANNER_HOME= tool 'sonar-scanner'
    }
    
    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/adityadahake24/MultiTier-Pipeline-.git'
            }
        }
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }
        stage('Test') {
            steps {
                sh "mvn test -DskipTests=true"
            }
        }
        stage('Trivy FS Scan') {
            steps {
                sh "trivy fs --format table -o fs-report.html ."
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh "$SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=Multitier -Dsonar.projectKey=Multitier -Dsonar.java.binaries=target"
                }
            }
        }
        stage('Build') {
            steps {
                sh "mvn package -DskipTests=true "
            }
        }
        stage('Publish to Nexus3') {
            steps {
                withMaven(globalMavenSettingsConfig: 'mvn-settings', jdk: '', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                
                    sh "mvn deploy -DskipTests=true"
                }
            }
        }
        stage('Docker Build Image') {
            steps {
                withDockerRegistry(credentialsId: 'docker-cred', url: 'https://index.docker.io/v1/') {
                    sh "docker build -t adityadahake/multitier:latest ."
                }
            }
        }
        stage('Trivy Image Scan') {
            steps {
                sh "trivy image --format table -o fs-report.html adityadahake/multitier:latest"
            }
        }
        stage('Docker Push Image') {
            steps {
                withDockerRegistry(credentialsId: 'docker-cred', url: 'https://index.docker.io/v1/') {
                    sh "docker push adityadahake/multitier:latest"
                }
            }
        }
        stage('Deploy to kubernetes') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'MultiTierPipeline-cluster', contextName: '', credentialsId: 'k8s-token', namespace: 'multitier', restrictKubeConfigAccess: false, serverUrl: 'Add EKS Cluster API server endpoint') {
                    sh "kubectl apply -f ds.yml -n multitier"
                    sleep 30 
                }
            }
        }
        stage('Verify deploy to kubernetes') {
            steps {
                withKubeConfig(caCertificate: '', clusterName: 'MultiTierPipeline-cluster', contextName: '', credentialsId: 'k8s-token', namespace: 'multitier', restrictKubeConfigAccess: false, serverUrl: 'Add EKS Cluster API server endpoint') {
                    sh "kubectl get pods -n multitier"
                    sh "kubectl get svc -n multitier"
                    
                }
            }
        }
    }
}
