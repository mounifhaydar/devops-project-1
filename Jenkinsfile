pipeline {
    agent any

    parameters {
            booleanParam(name: 'PLAN_TERRAFORM', defaultValue: true, description: 'Check to plan Terraform changes')
            booleanParam(name: 'APPLY_TERRAFORM', defaultValue: true, description: 'Check to apply Terraform changes')
            booleanParam(name: 'DESTROY_TERRAFORM', defaultValue: false, description: 'Check to destroy Terraform changes')
    }

    stages {
        stage('Clone Repository') {
            steps {
                // Clean workspace before cloning (optional)
                deleteDir()

                // Clone the Git repository
                git branch: 'main',
                    url: 'https://github.com/mounifhaydar/devops-project-1.git'

                sh "ls -lart"
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-mhaydar']]) {
                    dir('infra') {
                        sh '''
                        set -e
                        echo "=================Terraform Init=================="
                        if ! command -v terraform >/dev/null 2>&1; then
                          curl -fsSLo /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip
                          unzip -o /tmp/terraform.zip -d /tmp/terraform-bin >/dev/null
                          chmod +x /tmp/terraform-bin/terraform
                          export PATH="/tmp/terraform-bin:$PATH"
                        fi
                        export AWS_REGION=eu-central-1
                        export AWS_DEFAULT_REGION=eu-central-1
                        unset AWS_PROFILE AWS_DEFAULT_PROFILE
                        terraform init -input=false -reconfigure -backend-config="bucket=dev-proj-1-remote-state-527397543025" -backend-config="key=devops-project-1/terraform.tfstate" -backend-config="region=ap-southeast-1"
                        '''
                    }
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                script {
                    if (params.PLAN_TERRAFORM) {
                       withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-mhaydar']]){
                            dir('infra') {
                                sh '''
                                set -e
                                echo "=================Terraform Plan=================="
                                if ! command -v terraform >/dev/null 2>&1; then
                                  curl -fsSLo /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip
                                  unzip -o /tmp/terraform.zip -d /tmp/terraform-bin >/dev/null
                                  chmod +x /tmp/terraform-bin/terraform
                                  export PATH="/tmp/terraform-bin:$PATH"
                                fi
                                export AWS_REGION=eu-central-1
                                export AWS_DEFAULT_REGION=eu-central-1
                                unset AWS_PROFILE AWS_DEFAULT_PROFILE
                                terraform plan -var-file=terraform.tfvars -no-color
                                '''
                            }
                        }
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    if (params.APPLY_TERRAFORM) {
                       withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-mhaydar']]){
                            dir('infra') {
                                sh '''
                                set -e
                                echo "=================Terraform Apply=================="
                                if ! command -v terraform >/dev/null 2>&1; then
                                  curl -fsSLo /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip
                                  unzip -o /tmp/terraform.zip -d /tmp/terraform-bin >/dev/null
                                  chmod +x /tmp/terraform-bin/terraform
                                  export PATH="/tmp/terraform-bin:$PATH"
                                fi
                                export AWS_REGION=eu-central-1
                                export AWS_DEFAULT_REGION=eu-central-1
                                unset AWS_PROFILE AWS_DEFAULT_PROFILE
                                terraform apply -auto-approve -var-file=terraform.tfvars -no-color
                                '''
                            }
                        }
                    }
                }
            }
        }

        stage('Terraform Destroy') {
            steps {
                script {
                    if (params.DESTROY_TERRAFORM) {
                       withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials-mhaydar']]){
                            dir('infra') {
                                sh '''
                                set -e
                                echo "=================Terraform Destroy=================="
                                if ! command -v terraform >/dev/null 2>&1; then
                                  curl -fsSLo /tmp/terraform.zip https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip
                                  unzip -o /tmp/terraform.zip -d /tmp/terraform-bin >/dev/null
                                  chmod +x /tmp/terraform-bin/terraform
                                  export PATH="/tmp/terraform-bin:$PATH"
                                fi
                                export AWS_REGION=eu-central-1
                                export AWS_DEFAULT_REGION=eu-central-1
                                unset AWS_PROFILE AWS_DEFAULT_PROFILE
                                terraform destroy -auto-approve -var-file=terraform.tfvars -no-color
                                '''
                            }
                        }
                    }
                }
            }
        }
    }
}