resource "null_resource" "kube_config_import" {
  provisioner "local-exec" {
    command = "aws eks --region us-east-1 update-kubeconfig --name ${aws_eks_cluster.wordpress_cluster.name}"
  }

  depends_on = [
      aws_eks_cluster.wordpress_cluster,
      aws_eks_node_group.demo
  ]
}

resource "null_resource" "kubewatch" {
  provisioner "local-exec" {
    command = "helm repo add bitnami https://charts.bitnami.com/bitnami"
  }
  provisioner "local-exec" {
    command = "helm install my-release bitnami/wordpress"
  }
  
  
  depends_on = [
      aws_eks_cluster.wordpress_cluster,
      aws_eks_node_group.demo,
      null_resource.kube_config_import
  ]

}