    #!/bin/bash
    sudo yum update -y && sudo yum install docker -y
    sudo systemctl start docker 
    sudo service docker restart
    sudo usermod -aG docker ec2-user
    sudo chmod 777 /var/run/docker.sock
    sudo service docker restart
    docker run -p 8080:80 nginx