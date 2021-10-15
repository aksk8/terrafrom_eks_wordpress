resource "aws_instance" "jenkins" {
  ami = "ami-09e67e426f25ce0d7"
  instance_type = "t2.medium"
  security_groups = ["${aws_security_group.jenkins_securiy_group.name}"]
  key_name        = "jenkins_key"

  connection {
    type         = "ssh"
    host         = self.public_ip
    user         = "ubuntu"
    private_key  = file("./jenkins_key.pem" )
    timeout     = "3m"
   }
   
  provisioner "remote-exec"  {
    inline  = [
    "sudo apt-get update -y && sudo apt-get upgrade -y",
    "sudo apt-get install default-jdk -y",
    "sudo printf ' JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64 ' >> /etc/environment",
    "source /etc/environment",
    "wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -",
    "sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' ",
    "sudo apt update -y",
    "sudo apt install jenkins -y",
    "sudo systemctl start jenkins",
    "sudo wget https://releases.hashicorp.com/terraform/1.0.8/terraform_1.0.8_linux_amd64.zip",
    "sudo apt install unzip -y",
    "sudo unzip terraform_1.0.8_linux_amd64.zip ",
    "sudo mv terraform /usr/bin/",
    "sudo cat /var/lib/jenkins/secrets/initialAdminPassword",
     "sudo apt-get install awscli -y"
      ]
   }

}
resource "aws_security_group" "jenkins_securiy_group" {
    name = "jenkins_securiy_group"
    ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

