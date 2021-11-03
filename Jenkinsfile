pipeline {
    agent any

    parameters {
        choice(
            name: 'aws_region',
            description: 'The desired region of the AWS resources.',
            choices: 'us-east-2\nus-east-1'
        )

        string(
            name: 's3_bucket_name',
            description: 'The desired name of the Amazon S3 bucket.',
            defaultValue: 'michaelxmcbride-jenkins-ansible-terraform-example'
        )

        string(
            name: 'terraform_backend_bucket',
            description: 'The name of the Terraform backend Amazon S3 bucket.',
            defaultValue: 'michaelxmcbride-jenkins-ansible-terraform-example-backend'
        )

        string(
            name: 'terraform_backend_key',
            description: 'The key of the Terraform backend Amazon S3 object.',
            defaultValue: 'terraform.tfstate'
        )

        choice(
            name: 'terraform_backend_region',
            description: 'The region of the Terraform backend AWS resources.',
            choices: 'us-east-2\nus-east-1'
        )

        string(
            name: 'terraform_plan_file',
            description: 'The path of an existing Terraform plan file to apply.',
            defaultValue: ''
        )
    }

    environment {
        ansible_inventory = 'ansible/inventory.ini'
        ansible_playbook = 'ansible/playbook.yaml'
        default_terraform_plan_file = "/tmp/${BUILD_TAG}.tfplan"
        generate_terraform_plan = "${env.terraform_plan_file == '' ? 'yes' : 'no'}"
        resolved_terraform_plan_file = "${env.terraform_plan_file == '' ? env.default_terraform_plan_file : env.terraform_plan_file}"
    }

    stages {
        stage('Generate Terraform Plan') {
            when {
                environment name: 'generate_terraform_plan', value: 'yes'
            }

            steps {
                ansiblePlaybook(
                    extraVars: [
                        aws_region: '${aws_region}',
                        s3_bucket_name: '${s3_bucket_name}',
                        terraform_backend_bucket: '${terraform_backend_bucket}',
                        terraform_backend_key: '${terraform_backend_key}',
                        terraform_backend_region: '${terraform_backend_region}',
                        terraform_plan_file: '${resolved_terraform_plan_file}',
                        terraform_state: 'planned'
                    ],
                    inventory: '${ansible_inventory}',
                    playbook: '${ansible_playbook}'
                )
            }
        }

        stage('Approve Terraform Plan') {
            when {
                environment name: 'generate_terraform_plan', value: 'yes'
            }

            steps {
                script {
                    env.apply_terraform_plan = input message: 'Approve Terraform Plan',
                    parameters: [
                        choice(
                            name: 'apply_terraform_plan',
                            choices: 'no\nyes',
                            description: 'Indicator denoting if Terraform plan can be applied.'
                        )
                    ]
                }
            }
        }

        stage('Apply Terraform Plan') {
            when {
                anyOf {
                    environment name: 'apply_terraform_plan', value: 'yes'
                    environment name: 'generate_terraform_plan', value: 'no'
                }
            }

            steps {
                ansiblePlaybook(
                    extraVars: [
                        terraform_backend_bucket: '${terraform_backend_bucket}',
                        terraform_backend_key: '${terraform_backend_key}',
                        terraform_backend_region: '${terraform_backend_region}',
                        terraform_plan_file: '${resolved_terraform_plan_file}',
                        terraform_state: 'present'
                    ],
                    inventory: '${ansible_inventory}',
                    playbook: '${ansible_playbook}'
                )
            }
        }
    }
}
