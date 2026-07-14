bucket_name = "dev-proj-1-remote-state-527397543025"
name        = "environment"
environment = "dev-1"

vpc_cidr             = "10.0.0.0/16"
vpc_name             = "dev-proj-eu-central-vpc-1"
cidr_public_subnet   = ["10.0.1.0/24", "10.0.2.0/24"]
cidr_private_subnet  = ["10.0.3.0/24", "10.0.4.0/24"]
eu_availability_zone = ["eu-central-1a", "eu-central-1b"]

# EC2 Configuration
public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCcwPcI3qJiWBA3FfIT9Roaxl1vQIsTEN3qNZitQ9jNf4cer6R2FmsYM8pKvadCMqeYNthIJZoDVTe7EGJ8khdwnbesN1kF8lWEmjCKYf8RZpbqs8bgWXBixU4u3z60jMjeA+AY4OmzFQ+OrNp009TpPb12jFEDx9qX8n6/0zabUwc17k8ztjvPgtJ+VfIUUEcjM2N6AhcZYNwNNrxfSp8OaEcFeDdyJ47dthaNg2q4FTLvSnT05LT5nrII3wwC3jKcBIsMiMblrULL/+RUQanUblMs2AiwgiodYGIyRssIR0Cv2AI9JZ+a5OIMv12OwnCXEy5YtM1hdbHlwXJx9924t72oInFpz3UkKAVytqQWd/kKh5G84pTWxC6250IJQa0yxrz5ase5Ih0Tyfyf+bbiI7rLq8YeE/We4wumn7ptTF4F+EXvuqWNjx8OPqITiy8LWdSeSZ0vfwtBeSmc9ccnTtvlbQK1E9y9INYdGZQXBIFJtGGyPxPBsbC18YOl2Sk= user@DESKTOP-BFDBACI"
ec2_ami_id = "ami-0d1ddd83282187d18"

# ec2_user_data_install_python_api = "#!/bin/bash\necho 'Terraform pipeline bootstrap' > /tmp/pipeline-bootstrap.txt"
ec2_user_data_install_python_api = ""

domain_name = "jhooq.org"