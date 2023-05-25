# # Creation of VM in AWS 
#  - Security group 

resource "aws_security_group" "allow_SSH" {
  name        = "allow_SSH"
  description = "Allow SSH inbound traffic"

  #  - INBOUND

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  #  - OUTBOUND RULES

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#  - key pair

resource "aws_key_pair" "k_deployer" {
  key_name   = "deployer-key1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCihAunULgX4uVu4yQYIclQG3DKf9glPN9meAglipNRg7UGwRYM7P083Y07h+qzubVAqgztunKno3jMmKD8GFtLuH23nilCcFKIaTHx0XM26yk3nhnnBDBbB0pYcuC4v6pvmOH2Xyg42SlnWSP5hjdlDhMmyO6dZ4oPQ7EKFtg8C9Dl042X4h8kR5JA8VLfky7xCY/UjSJS3serWKPjdTwJ6/MnjrxED8tLwJVevYFtUP0dM9MJe5swWCRpd6t5mz8zkOsoaSEH5dHsdAMEzXAUKKrRs8fhTo89FBXewNF9CmXEBWHVP1CgyAk58eAMDnKhzEu37J5JWnWBWZNIU2NZDRtz4h59sGyVvsMKCe+1aB4b3ChUeNd5+jHLGQyvGRFCqYE8EOiw+t8OjezpXW2oNHHbSHXURTdLJz+tfPlwxWzrWGqDNL+WGaMl95YCptDHbW/oKOqgQYbFUqRiZkWyouhenWqtDCqCHR1oP6vuefTfApWGt0Y/MdOVriwae1E= ubuntu-node1@ubuntunode1-virtual-machine"
}

resource "aws_instance" "amzn-linux" {
  ami                    = "ami-090fa75af13c156b4"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.k_deployer.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_SSH.id}"]
  tags = {
    "Name" = "Linux-Node"
    "ENV"  = "Dev"
  }
  depends_on = [aws_key_pair.k_deployer]
}

####### Ubuntu VM #####

resource "aws_instance" "ubuntu_MS" {
  ami                    = "ami-007855ac798b5175e"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.k_deployer.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_SSH.id}"]
  tags = {
    "Name" = "UBUNTU-MS"
    "ENV"  = "Dev"
  }
  /*
  provisioner "file" {
    source      = "./install_docker.sh"
    destination = "/tmp/install_docker.sh"     
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./k_deployer")
      host        = self.public_ip
    }
  }
  */
  
  # Remotely execute commands to install Java, Python, Jenkins
  provisioner "remote-exec" {
    # Type of connection to be established      
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./k_deployer")
      host        = self.public_ip
    }
    
    # script = "./install_docker.sh"
    inline =  [
      "sudo apt update && sudo apt install docker.io",
    ]
    

  }
  depends_on = [aws_key_pair.k_deployer]
}

resource "aws_instance" "ubuntu_Node1" {
  ami                    = "ami-007855ac798b5175e"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.k_deployer.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_SSH.id}"]
  tags = {
    "Name" = "UBUNTU-Node1"
    "ENV"  = "Dev"
  }

  #  # Remotely execute commands to install Java, Python, Jenkins
  #  provisioner "remote-exec" {
  #    # Type of connection to be established      
  #    connection {
  #      type        = "ssh"
  #      user        = "ubuntu"
  #      private_key = file("./k_deployer")
  #      host        = self.public_ip
  #    }
  #    #    inline = [
  #    #      "sudo apt update && sudo apt upgrade ",
  #    #      "sudo apt install -y python2",
  #    #      "sudo apt install -y python3",
  #    #    ]
  #  }
  depends_on = [aws_key_pair.k_deployer]
}

resource "aws_instance" "ubuntu_Node2" {
  ami                    = "ami-007855ac798b5175e"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.k_deployer.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_SSH.id}"]
  tags = {
    "Name" = "UBUNTU-Node2"
    "ENV"  = "Dev"
  }

  # Remotely execute commands to install Java, Python, Jenkins
  #  provisioner "remote-exec" {
  #    # Type of connection to be established      
  #    connection {
  #      type        = "ssh"
  #      user        = "ubuntu"
  #      private_key = file("./k_deployer")
  #      host        = self.public_ip
  #    }
  #    inline = [
  #      "sudo apt update && sudo apt upgrade ",
  #      "sudo apt install -y python2",
  #      "sudo apt install -y python3",
  #    ]
  #  }
  depends_on = [aws_key_pair.k_deployer]
}

resource "aws_iam_user" "user" {
  name = "test_commit_user"
  path = "/"
}

resource "aws_iam_user_ssh_key" "user" {
  username   = aws_iam_user.user.name
  encoding   = "SSH"
  public_key = aws_key_pair.k_deployer.public_key
}
