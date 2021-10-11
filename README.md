# ytrd-automation
For now it will contain all infrastructure/automation related code for youtube rundown application, may split to separate repos in the future

# Local Deployment

## Setup

To run this Application locally you can use the docker-compose file to build both the React App & GraphQL API.

When you run the docker compose command below it looks for a file called `.env.dev` in the config directory.
Within this file are two environment variables the containers need to run:

- GCP_API_KEY is your google cloud api key GraphQL needs to access the youtube API
- REACT_APP_GQL_HOST is a react-app environment variable that instructs react where to point the graphql client. By default this value uses localhost assuming you are running everything on the same machine.

For safety reasons it is suggested to make a copy of the env file, changing the dev ending to your own name e.g. `.env.lukep` and then passing that file through to docker-compose instead. There is a gitignore rule to exclude all but .env.dev, that way you don't end up accidentally committing your API key.
You need to replace YOUR_API_KEY_HERE in the .env file with your own.

## Running 

Then simply run (changing the name of the env file to your own)
```
docker-compose --env-file ./config/.env.lukep up
```
and you should be able to navigate to localhost:3000 and view the Youtube Rundown UI.

# AWS Deployment

Optionally you can run this in AWS instead for a full blown cloud deployment. 

## Setup

The ECR folder contains the code needed to create/destroy the image repositories, you shouldn't need to do anything in this directory.

Navigate to the deployment folder and copy the `example.tfvars file` and rename it to `YOUR_NAME.tfvars`, replacing `YOUR_NAME` with some identifier like `lukep` for example. In this file replace 

- "YOUR_API_KEY_HERE" with your own Google Cloud API key (preserving the double quotes).
- "YOUR_PROFILE_HERE" with your own aws profile (configured via `aws configure`)

## Running

Once you've set up the aws profile you'll use and provided the Google Cloud API key you're ready to create your AWS Deployment.

`terraform init` will initialise your terraform config

`terraform plan -var-file=YOUR_NAME.tfvars` will show you what changes terraform will make when you apply

`terraform apply -var-file=YOUR_NAME.tfvars` will apply the changes and actually deploy it to AWS

I created aliases in my `.bashrc` for terraform commands which require my tfvars.

```
    alias tfa='terraform apply -var-file=lukep.tfvars'   
```