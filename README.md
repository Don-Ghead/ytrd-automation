# ytrd-automation
For now it will contain all infrastructure/automation related code for youtube rundown application, may split to separate repos in the future

# Running locally

## Setup

To run this Application locally you can use the docker-compose file to build both the React App & GraphQL API.

For the GraphQL API to work we need to provide it an API key for Google Cloud. 
The docker-compose file will try to mount a file called config.json in the base directory. 
You need to populate this json file with the following: 

```
{
    "api_key": "YOUR_API_KEY_HERE"
}
```

Replacing YOUR_API_KEY_HERE between the quotes with your own.

## Running

Then simply run
```
docker-compose up
```
and you should be able to navigate to localhost:3000 and view the Youtube Rundown UI.

# AWS Deployment

Optionally you can run this in AWS instead for a full blown cloud deployment. 

The ECR folder contains the code needed to create/destroy the image repositories, you usually won't want to destroy these which is why they are isolated in that folder.



