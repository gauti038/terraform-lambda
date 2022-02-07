# terraform-lambda

## Pre-requisites
1. Install git and docker. (terraform not needed)
2. AWS user must be configured with valid permissions

## How to run the terraform script 
1. No need to install any specific version of terraform. Just use terraform docker image mentioned
2. 
    ```
        git clone https://github.com/gauti038/terraform-lambda.git 
        cd terraform-lambda
        docker run -it -v "$PWD":/app -v ~/.aws:/root/.aws --entrypoint "/bin/sh"  hashicorp/terraform:1.1.5 
            $ cd /app 
            $ apk add curl 
            $ terraform init
            $ terraform apply
            $ curl -vvv "$(terraform output -raw base_url)/"
            $ curl -vvv --header "Content-Type: application/json" --data '{"username":"asdf","password":"asdf"}' "$(terraform output -raw base_url)/api"
            curl -vvv --header "Content-Type: application/json" --data '{"username":"xyz","password":"xyz"}' "$(terraform output -raw base_url)/api"

            ## make changes locally since the code is mounted, no need to restart the container
            ## Run these steps after making changes for it to take effect
            $ terraform fmt -check 
            $ terraform apply 

            ## To delete changes
            $ terraform destory

            ## To exit the container
            $ exit 

    ``` 
    
3. The terraform script would automatically create a gateway and an s3 bucket to store the artifact
4. I have used the local filesystem as backend here for simplicity. 
4. You can modify the code in [microservice/main.js]. as per the requirement for further enhancements
5. There is also an integration with [github actions] with standard terraform steps. But it requires a secret to be stored as github secret and a remote backend to store the state files.

[microservice/main.js]: microservice/main.js "lambda file"
[github actions]: .github/workflows/terraform.yml "actions file"

