# ytrd-automation
For now it will contain all infrastructure/automation related code for youtube rundown application, may split to separate repos in the future

# Setup

For the GraphQL API to work we need to provide it an API key for Google Cloud. 
The docker-compose file will try to mount a file called config.json in the base directory. 
You need to populate this json file with the following: 

```
{
    "api_key": "AIzaS3jlaJ8Vz_syDfIESrkDnDy2Kllt_i2YDwg"
}
```

Replacing the key between the quotes with your own.

# Running

Then simply run
```
docker-compose up
```
and you should be able to navigate to localhost:3000 and view the Youtube Rundown UI.