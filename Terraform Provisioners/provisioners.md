**What are Terraform Provisioners?**

Terraform Provisioners are used to execute scripts or commands on a local machine or a remote server after or before Terraform creates or destroys a resource.


Suppose you create an EC2 instance using Terraform. The EC2 instance is created, but you also want to:

- Install Docker.
- Install Nginx.
- Copy application files.
- Execute shell scripts.
- Configure the server.
  
You can use Terraform Provisioners to perform these additional tasks.

| Provisioner | Purpose |
|---|---|
| `file` | Copy files from local machine to remote server |
| `remote-exec` | Execute commands on a remote server |
| `local-exec` | Execute commands on the machine running Terraform |

**1. File Provisioner:** Used to copy files from your local machine to a remote EC2 instance.

Real-time scenario:

**You have an application configuration file on your laptop. After creating an EC2 instance, you want to copy that file to the EC2 server.**

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"

  provisioner "file" {
    source      = "app.conf"
    destination = "/tmp/app.conf"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("my-key.pem")
      host        = self.public_ip
    }
  }
}
```

**Explanation:**
- source – File location on your local machine.
- destination – Where the file should be copied on EC2.
- connection – Details required to connect to EC2 through SSH.
- self.public_ip – Public IP of the EC2 instance being created.
  
**Result:** Your local app.conf file is copied to /tmp/app.conf on EC2.

**2.Remote-exec Provisioner**: Used to execute commands or scripts directly on a remote server.

Real-time scenario:

You created an EC2 instance and want to install Nginx automatically.

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install nginx -y",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("my-key.pem")
      host        = self.public_ip
    }
  }
}
```
**What happens?**

1. Terraform creates the EC2 instance.
2. Terraform connects to EC2 using SSH.
3. It executes the commands.
4. Nginx gets installed and started.

**Local-exec Provisioner:** Executes commands on the machine where Terraform is running, not on the EC2 instance.

Real-time scenario:

You created an EC2 instance using Terraform. After successful creation, you want to print its public IP address or execute a local script.

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo EC2 instance created successfully"
  }
}
```

**What happens?**

1. Terraform creates EC2.
2. The local-exec provisioner runs.
3. The message is printed on your local machine or Terraform execution environment.

**Creation-time vs Destroy-time Provisioners**

There are two ways to execute provisioners depending on when you want to run them.

**Creation-time provisioner**

Runs after Terraform creates the resource. This is the default behavior.

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo EC2 created successfully"
  }
}
```

**Execution:** Create EC2 → Execute command.

**Destroy-time provisioner**

Runs before Terraform destroys the resource.

**Real-time scenario:**

Suppose you are deleting an EC2 instance. Before deletion, you want to execute a cleanup script.

```hcl
resource "aws_instance" "web" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    when    = destroy
    command = "echo EC2 is going to be deleted"
  }
}
```

**Execution:** Execute cleanup command → Destroy EC2.


