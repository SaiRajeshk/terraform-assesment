# Define Variables
environment   = "dev"
region        = "us-east-1"
cidr_vpc      = "10.0.0.0/16"
subnet_cidr   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
ami_name      = "ami-0e472ba40eb589f49"
public_key    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDDwD3IsnduY2cPz0GqBL+9Jo8i9aDRM+92z2ZyJf3uQ7IOPb9dlQJjJJid26zxCbtSVWgXc6wmhqPU2WzBI+tg4/ePIIlHvTryaOkmHuL75ZUf+6jZ9PW2fmN4zkBvufh8RJXIcx3+9+31gwWGK8qdbTUUa6VEvFWFgBCoibJrja+MM4id6T4P8KeE4teM5obYgGLjmmzz5HKVmwDFMq8DjkF5IrUsyYrZK1pP0OCgp217xJ9F+4Zv3fLvMh0FnQ/7VEwumYGp3vzPBzoTQN5i4PjVQUzSBHAPFYXDV+OuNZlqK4VTXsVAFYgmcP5pXApeJyRMrHx2AsQPtPzuP9yh raj"
instance_type = "t2.small"
