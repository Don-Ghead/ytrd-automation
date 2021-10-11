# ytrd-automation
For now it will contain all infrastructure/automation related code for youtube rundown application, may split to separate repos in the future

# Running locally

## Setup

To run this Application locally you can use the docker-compose file to build both the React App & GraphQL API.

When you run the docker compose command below it looks for a file called `.env.dev` in the config directory.
Within this file are two environment variables the containers need to run:

- GCP_API_KEY is your google cloud api key GraphQL needs to access the youtube API
- REACT_APP_GQL_HOST is a react-app environment variable that instructs react where to point the graphql client. By default this value uses localhost assuming you are running everything on the same machine.

For safety reasons it is suggested to make a copy of the env file, changing the dev ending to your own name e.g. `.env.lukep` and then passing that file through to docker-compose instead. There is a gitignore rule to exclude all but .env.dev, that way you don't end up accidentally committing your API key.
You need to replace YOUR_API_KEY_HERE in the .env file with your own.

## Running

Then simply run
```
docker-compose up --env-file ./config/.env.dev up
```
and you should be able to navigate to localhost:3000 and view the Youtube Rundown UI.

# AWS Deployment

Optionally you can run this in AWS instead for a full blown cloud deployment. 

The ECR folder contains the code needed to create/destroy the image repositories, you usually won't want to destroy these which is why they are isolated in that folder.



