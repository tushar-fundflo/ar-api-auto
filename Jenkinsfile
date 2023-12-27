pipeline{
    agent any
    parameters{
        choice(name:'AWS_ENV', choices:['DEV','KMR'],description:'From which environment do you want to deploy?')
        choice(name:'AWS_REGION', choices:['ap-south-1'],description:'From which region do you want to deploy?')
        // choice(name:'CONFIG', choices:['NO','YES'],description:'Do you want to configure the Server?')
    }
    stages{
        stage('Checking AWS RESOURCES'){
            steps{
                script{
                    if(params.AWS_ENV=='DEV'){
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId:params.AWS_ENV]]){
                            def vpcExists = sh(returnStdout: true, script: "aws ec2 describe-vpcs --region ${params.AWS_REGION} --filters Name=tag:Name,Values=FUND-${params.AWS_ENV}-VPC --query 'Vpcs[0].VpcId' --output text").trim()
                            def instanceExists = sh(returnStdout: true, script: "aws ec2 describe-instances --region ap-south-1 --filter Name=tag:Name,Values=TEST-API-SERVER --query 'Reservations[0].Instances[0].InstanceId' --output text").trim()
                            def instanceRoleExists = sh(returnStdout:true, script: "aws iam list-instance-profiles --query 'InstanceProfiles[?InstanceProfileName==`test-ec2-role`] | [0].Arn' --output text").trim()
                
                            if(vpcExists!='None'){
                                echo 'Virtual Private Cloud Exists'
                            }else {
                                echo 'Virtual Private Cloud Not exists'
                                dir ('Terraform/VPC'){
                                    echo'Creating VPC'
                                    sh 'terraform init'
                                    sh "terraform plan -var='vpc_name=FUND-${params.AWS_ENV}'"
                                    sh "terraform apply --auto-approve -var='vpc_name=FUND-${params.AWS_ENV}'"
                                }
                            }
                            if (instanceRoleExists!='None'){
                                echo 'Instance Profile Role Exists'
                            }else {
                                echo 'Instance Profile Role Not Exists'
                                dir('Terraform/EC2_ROLE'){
                                    echo'Creating API SERVER EC2InstanceProfile'
                                    sh 'terraform init'
                                    sh "terraform plan \
                                    -var='instance_role_name=FUND-${params.AWS_ENV}-APIServer-EC2InstanceProfile'"
                                    sh "terraform apply --auto-approve -var='instance_role_name=FUND-${params.AWS_ENV}-APIServer-EC2InstanceProfile'"
                                }
                            }
                            if (instanceExists!='None'){
                                echo 'Instance Exists'
                            }else {
                                echo 'Instance Not Exists'
                                dir ('Terraform/EC2') {
                                    echo 'Creating API SERVER'
                                    def publicsubnet = sh(returnStdout:true, script: "aws ec2 describe-subnets --region ${params.AWS_REGION} --filters Name=tag:Name,Values='FUND-${params.AWS_ENV}-PublicSubnet1a' --query 'Subnets[0].SubnetId' --output text").trim()
                                    def eip_id = sh (returnStdout:true, script:"aws ec2 describe-addresses --filters Name=tag:Name,Values='FUND-${params.AWS_ENV}-APIServer' --query 'Addresses[0].AssociationId' --output text").trim()
                                    // existing pem, eip is used
                                    sh 'terraform init'
                                    sh "terraform plan -var='ec2_name=FUND-${params.AWS_ENV}-APIServer' \
                                    -var='ec2_ami=ami-03f4878755434977f' \
                                    -var='ec2_type=t2.micro' \
                                    -var='key_name=FUND-${params.AWS_ENV}-APIServer' \
                                    -var='ec2_subnet_id=${publicsubnet}' \
                                    -var='instance_profile='FUND-${params.AWS_ENV}-APIServer-EC2InstanceProfile' \
                                    -var='security_group_name='FUND-${params.AWS_ENV}-APIServer-SecurityGroup' \
                                    -var='vpc_id=${vpcExists}' \
                                    -var='allocation_id=${eip_id}"
                                    sh "terraform apply -var='ec2_name=FUND-${params.AWS_ENV}-APIServer' \
                                    -var='ec2_ami=ami-03f4878755434977f' \
                                    -var='ec2_type=t2.micro' \
                                    -var='key_name=FUND-${params.AWS_ENV}-APIServer' \
                                    -var='ec2_subnet_id=${publicsubnet}' \
                                    -var='instance_profile='FUND-${params.AWS_ENV}-APIServer-EC2InstanceProfile' \
                                    -var='security_group_name='FUND-${params.AWS_ENV}-APIServer-SecurityGroup' \
                                    -var='vpc_id=${vpcExists}' \
                                    -var='allocation_id=${eip_id}"
                                }
                                
                            }
                            
                        }
                    }else if(params.AWS_ENV=='KMR'){
                        withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId:params.AWS_ENV]]){
                            def vpcExists = sh(returnStdout: true, script: "aws ec2 describe-vpcs --region ${params.AWS_REGION} --filters Name=tag:Name,Values=FUND-${params.AWS_ENV}-VPC --query 'Vpcs[0].VpcId' --output text").trim()
                            def instanceExists = sh(returnStdout: true, script: "aws ec2 describe-instances --region ap-south-1 --filter Name=tag:Name,Values=TEST-API-SERVER --query 'Reservations[0].Instances[0].InstanceId' --output text").trim()
                            def instanceRoleExists = sh(returnStdout:true, script: "aws iam list-instance-profiles --query 'InstanceProfiles[?InstanceProfileName=="FUND-${params.AWS_ENV}-APIServer-EC2InstanceProfile"] | [0].Arn' --output text").trim()
                
                            if(vpcExists!='None'){
                                echo 'Virtual Private Cloud Exists'
                            }else {
                                echo 'Virtual Private Cloud Not exists'
                                dir ('Terraform/VPC'){
                                    echo'Creating VPC'
                                    sh 'terraform init'
                                    sh "terraform plan -var='vpc_name=FUND-${params.AWS_ENV}'"
                                    sh "terraform apply --auto-approve -var='vpc_name=FUND-${params.AWS_ENV}'"
                                }
                            }
                            if (instanceRoleExists!='None'){
                                echo 'Instance Profile Role Exists'
                            }else {
                                echo 'Instance Profile Role Not Exists'
                                dir('Terraform/EC2_ROLE'){
                                    echo'Creating API SERVER EC2InstanceProfile'
                                    sh 'terraform init'
                                    sh "terraform plan \
                                    -var='instance_role_name=FUND-${params.AWS_ENV}-APIServer-EC2InstanceProfile'"
                                    sh "terraform apply --auto-approve -var='instance_role_name=FUND-${params.AWS_ENV}-APIServer-EC2InstanceProfile'"
                                }
                            }
                            if (instanceExists!='None'){
                                echo 'Instance Exists'
                            }else {
                                echo 'Instance Not Exists'
                                dir ('Terraform/EC2') {
                                    echo 'Creating API SERVER'
                                    def publicsubnet = sh(returnStdout:true, script: "aws ec2 describe-subnets --region ${params.AWS_REGION} --filters Name=tag:Name,Values='FUND-${params.AWS_ENV}-PublicSubnet1a' --query 'Subnets[0].SubnetId' --output text").trim()
                                    def eip_id = sh (returnStdout:true, script:"aws ec2 describe-addresses --filters Name=tag:Name,Values='FUND-${params.AWS_ENV}-APIServer' --query 'Addresses[0].AssociationId' --output text").trim()
                                    // existing pem, eip is used
                                    sh 'terraform init'
                                    sh "terraform plan -var='ec2_name=FUND-${params.AWS_ENV}-APIServer' \
                                    -var='ec2_ami=ami-03f4878755434977f' \
                                    -var='ec2_type=t2.micro' \
                                    -var='key_name=FUND-${params.AWS_ENV}-APIServer' \
                                    -var='ec2_subnet_id=${publicsubnet}' \
                                    -var='instance_profile='FUND-${params.AWS_ENV}-APIServer-EC2InstanceProfile' \
                                    -var='security_group_name='FUND-${params.AWS_ENV}-APIServer-SecurityGroup' \
                                    -var='vpc_id=${vpcExists}' \
                                    -var='allocation_id=${eip_id}"
                                    sh "terraform apply -var='ec2_name=FUND-${params.AWS_ENV}-APIServer' \
                                    -var='ec2_ami=ami-03f4878755434977f' \
                                    -var='ec2_type=t2.micro' \
                                    -var='key_name=FUND-${params.AWS_ENV}-APIServer' \
                                    -var='ec2_subnet_id=${publicsubnet}' \
                                    -var='instance_profile='FUND-${params.AWS_ENV}-APIServer-EC2InstanceProfile' \
                                    -var='security_group_name='FUND-${params.AWS_ENV}-APIServer-SecurityGroup' \
                                    -var='vpc_id=${vpcExists}' \
                                    -var='allocation_id=${eip_id}"
                                }
                                
                            }
                            
                        }
                    }
                }
            }
        }
        // stage('BUILD API'){
        //     steps{
        //         script{
        //             if(params.AWS_ENV=='DEV'){
        //                 sshagent(credentials: ['your_ssh_credentials_id']){
        //                     sh 'ssh ubuntu@your-server "ls; cd test; mkdir test/new_directory; ls test"'
        //                 }
        //             }

        //         }
        //     }
        // }
    }
}