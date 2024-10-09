pipeline {
    agent any

    parameters {
        string(name: 'aws_region', defaultValue: 'us-east-1', description: 'AWS Region to deploy')
        string(name: 'ami', defaultValue: 'ami-005fc0f236362e99f', description: 'AMI ID to use for the instance')
        string(name: 'instance_type', defaultValue: 't2.micro', description: 'Type of the instance')
        string(name: 'key_name', defaultValue: 'workstation-key', description: 'Key pair name for SSH access')
    }

    stages {
        stage('Preparation') {
            steps {
                script {
                    // Check if Terraform is installed
                    def terraformInstalled = sh(script: 'terraform version', returnStatus: true) == 0
                    if (!terraformInstalled) {
                        echo 'Terraform not found. Installing...'
                        
                        // Commands to install Terraform
                        sh '''
                            # Add HashiCorp GPG key
                            wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
                            
                            # Add HashiCorp repository
                            echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
                            
                            # Update and install Terraform
                            sudo apt update && sudo apt install -y terraform
                        '''
                    } else {
                        echo 'Terraform is already installed.'
                    }
                }
            }
        }

        stage('Checkout Code') {
            steps {
                script {
                    // Check if the directory exists
                    if (fileExists('Terraform')) {
                        // Remove the directory if it exists
                        sh 'rm -rf Terraform'
                    }
                    // Clone the repository
                    sh 'git clone https://github.com/Noah-linux/Terraform.git'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    // Use AWS credentials stored in Jenkins
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'Jenkins_aws_key']]) { // ADDED THIS
                        // Run Terraform plan with parameters
                        sh 'terraform plan -var='aws_region=${params.aws_region}' -var='ami=${params.ami}' -var='instance_type=${params.instance_type}' -var='key_name=${params.key_name}''
                    } // ADDED THIS
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    // Use AWS credentials stored in Jenkins
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'Jenkins_aws_key']]) { // ADDED THIS
                        // Apply the Terraform changes
                        sh 'terraform apply -auto-approve -var='aws_region=${params.aws_region}' -var='ami=${params.ami}' -var='instance_type=${params.instance_type}' -var='key_name=${params.key_name}''
                    } // ADDED THIS
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform applied successfully!'
        }
        failure {
            echo 'Terraform apply failed!'
        }
    }
}
