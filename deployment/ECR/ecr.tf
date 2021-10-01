provider "aws" {
  alias   = "ecr_public_repos"
  # For pushing to public ECR repos the region must always be us-east-1
  region  = "us-east-1"
  profile = "donghead"
}

resource "aws_ecrpublic_repository" "ecr_gql_repo" {
  provider = aws.ecr_public_repos

  repository_name = "ytrd-gql-dev"

  catalog_data {
    description = "Contains the development images for the youtube-rundown graphql API"
    usage_text  = <<EOT
# ytrd-automation
For now it will contain all infrastructure/automation related code for youtube rundown application, may split to separate repos in the future

# Setup

For the GraphQL API to work we need to provide it an API key for Google Cloud. 
The docker-compose file will try to mount a file called config.json in the base directory. 
You need to populate this json file with the following: 

```
{
    "api_key": "YOUR_API_KEY_HERE"
}
```

Replacing YOUR_API_KEY_HERE between the quotes with your own. It should look like "AIzaS3jlaJ8Vz_syDfIESrkDnDy2Kllt_i2YDwg"

# Running

Then simply run
```
docker-compose up
```
and you should be able to navigate to localhost:3000 and view the Youtube Rundown UI.
        EOT
  }
}

resource "aws_ecrpublic_repository" "ecr_web_repo" {
  provider = aws.ecr_public_repos

  repository_name = "ytrd-web-dev"

  catalog_data {
    description = "Contains the development images for the youtube-rundown React App"
    usage_text = ""
  }
}
