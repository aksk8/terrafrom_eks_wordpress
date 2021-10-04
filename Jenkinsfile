pipeline{
    agent any
    tools {
     terraform 'terraform-local'
   }
   stages {
       stage("Git checkout"){
           steps{
               git branch: 'main', url: 'https://github.com/aksk8/terrafrom_eks_wordpress'
           }
       }
       stage("Terraform init"){
           steps{
               sh 'terraform init'
           }
       }
       stage("Terraform apply"){
           steps{
               sh 'terraform apply --auto-approve'
           }
       }
   }
}
