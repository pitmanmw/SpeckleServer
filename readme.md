<a href="url"><img src="https://speckle.works/img/logos/2xlogo-white.png" align="left" height="128" ></a>
# Speckle Server

> This is the Speckle Server, which coordinates communications between the various SpeckleClients.
[![DOI](https://zenodo.org/badge/74043433.svg)](https://zenodo.org/badge/latestdoi/74043433)

Speckle Server provides :
- a basic accounts system
- stream coordination
- design data collation and retrieval
- live update events
- a basic querying mechanism

## Deploy

Prerequisites:  
- A machine running [docker](https://www.docker.com/community-edition#download).
- Have `git` installed too.

Please note: the speckle server application is a clustered service that will spawn as many instances as you have CPU cores.

Steps:
1) Clone this repository and change your working path to this repository:
`git clone https://github.com/speckleworks/SpeckleServer.git` then `cd SpeckleServer`.

2) Run `docker-compose up -d`. This will take a bit of time at first. To stop the service, run `docker-compose down`.

3) Visit your speckle server [http://localhost](http://localhost) or whatever the IP address of your VPS is.

### Deploying to Heroku

    $ heroku create --stack cedar
    $ heroku addons:create mongolab:sandbox
    $ heroku addons:create heroku-redis:hobby-dev
    $ git push heroku master
    $ heroku open

### Deploying on Debian-based OSes (Ubuntu etc)

1) Install mongodb, redis servers and npm:

       sudo apt-get install mongodb redis npm

2) If you don't want both the redis and mongo servers running all the time (For ex. if you are just testing), disable both startup scripts (If you wish to leave both running automatically, skip to step 4):

       sudo systemctl disable mongodb
       sudo systemctl disable redis-server`

3) And stop both mongo and redis processes that were started automatically by apt-get:

       sudo systemctl stop mongodb
       sudo systemctl stop redis-server

4) Clone SpeckleServer and run npm to install the needed nodejs packages:

       git clone https://github.com/speckleworks/SpeckleServer.git
       cd SpeckleServer
       npm install

5) Edit config.js and adjust the mongo url line and the redis url line:

       url: process.env.MONGODB_URI || process.env.MONGO_URI || 'mongodb://localhost:27017/speckle'
       url: process.env.REDIS_URL || 'redis://localhost:6379'

6) Start mongo (create a folder somewhere to store the db):

       mongodb --dbpath /path/to/some/folder

7) Start redis in another terminal:

       redis-server

8) Check that both mongo and redis are running OK and that you can connect to them with these two clients:

       mongo
       redis-cli

9) Start Speckle in a third terminal:

       node server.js

## Deploying with Docker (any Platform - Windows, Linux, Mac, etc)

Perquisites:  
- A machine running [docker](https://www.docker.com/community-edition#download).
- Have `git` installed too.

Please note: the speckle server application is a clustered service that will spawn as many instances as you have CPU cores.

Steps:
1) Clone this repository and change your working path to this repository:
`git clone https://github.com/speckleworks/SpeckleServer.git` then `cd SpeckleServer`.

2) Run `docker-compose up -d`. This will take a bit of time at first. To stop the service, run `docker-compose down`.

3) Visit your speckle server [http://localhost](http://localhost) or whatever the IP address of your VPS is.

## Develop
More detailed instructions coming soon. Simply spin off an instance of Redis & Mongo locally, make sure in `config.js` that you're connecting to them, and spin out the server with `nodemon server.js` if  you want live reloads or `node server.js` otherwise.

### Speckle Viewer
The SpeckeViewer repository is a submodule of the SpeckleServer (this) repo.  The submodules entrypoint is "static/view".  So before you can access the "/view/" URL you need to ensure that the submodule is cloned as follows:
```
# If you want to clone the submodule at the same time as the main repo
git clone --recursive https://github.com/speckleworks/SpeckleServer.git

# OR If you have already cloned the main repo
git submodule update --init --recursive
```

### Development using Docker containers
For development you will probably want to build your own Docker image rather than use the development image available ("speckle/speckleserver:dev").  On the development server you will have local files mapped to the /usr/src/app folder so that you can make real-time edits with live-updates as the server is running with nodemon.
```
docker-compose run speckle sh
npm install
exit
```

This will install all of the node_modules into a node_modules folder in this folder.  You can then start up all of the services on the development server with:
```
docker-compose up
```

To have more fine-grained control of the execution (ie to run nodemon and other such node commands), it is nice to start the individual services running in separate terminal windows and then enter shell on the speckle container and run commands from there.  This way you can see the output from each of the services in a separate windows.  Like this:
```
# Open a new PowerShell (or Linux terminal)
docker-compose run mongo

# And another one for redis
docker-compose run redis

# Start the
docker-compose run speckle sh

## Now you are in the shell - run commands like "nodemod server.js" to start the server with live-updates.  Or simple "node server.js" for standard node (no live updates)
```

#### Connecting to the Mongo DB

With the development server running, you can connect directly to the Mongo for inspection of DB by opening up a new Terminal window and running:
```
docker exec -it speckleserver_mongo_1 mongo
```

#### Mongo crash course
You can then navigate the database with commands like this:
```
show dbs (shows all databases)
use speckle (use the speckle database)
show collections (show the collections in the speckle database)
```

Showing all objects in a collection:
```
db.users.find().pretty() - To pretty print all of the data in the users collection
db.datastreams.find().pretty() - Pretty print all of the data in the datastreams collection
db.speckleobjects.find().pretty() - Pretty print all of the data in the speckleobjects collection
```

Querying objects in the collection (get a filtered list):
```
# Get objects after a specific date
db.speckleobjects.find({"createdAt" : { $gte : new ISODate("2018-01-25T00:00:00Z") }}).pretty();

# Get objects that are part of a specific stream
db.speckleobjects.find({partOf: "BJ-wxq_HG"}).pretty()
```

## Develop
More detailed instructions coming soon. Simply spin off an instance of Redis & Mongo locally, make sure in `config.js` that you're connecting to them, and spin out the server with `nodemon server.js` if  you want live reloads or `node server.js` otherwise.

## API
[API docs are here](https://speckleworks.github.io/SpeckleOpenApi/#introduction) - they are a good overview of what you can do with the speckle server.

### Current limitations
SpeckleServer currently imposes a default payload size limit for streams, they are as detailed below.

Single object payload restricted before deflation, but this can be adjusted. Current limit :
- `2e6 bytes` : `2,000,000 bytes` or `2,000 KB`

Max total payload size is currently restricted at
- 1 payload of `50e6 bytes` : `50,000,000 bytes` or `50,000 KB` or `50 MB` or
- 100 payloads of around `500KB` each

## Credits
Developed by Dimitrie A. Stefanescu [@idid](http://twitter.com/idid) / [UCL The Bartlett](https://www.ucl.ac.uk/bartlett/) / [InnoChain](http://innochain.net) / [Jenca](http://www.jenca.org)

This project has received funding from the European Union’s Horizon 2020 research and innovation programme under the Marie Sklodowska-Curie grant agreement No 642877.

### License
[MIT](https://github.com/speckleworks/SpeckleServer/blob/master/LICENSE)
