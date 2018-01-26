[![DOI](https://zenodo.org/badge/74043433.svg)](https://zenodo.org/badge/latestdoi/74043433)

# Speckle Server
This is the Speckle Server, which coordinates communications between the various SpeckleClients. It provides a basic accounts system, stream coordination, design data collation and retrieval, live update events and a basic querying mechanism.

## Deploy

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

### Docker container
For development you will probably want to build your own Docker image rather than use the development image available.  On the development server you will have local files mapped to the /usr/src/app folder so that you can make real-time edits with live-updates as the server is running with nodemon.
```
docker-compose run speckle sh
npm install
exit
```
This will install all of the node_modules into a node_modules folder in this folder.  You can then start up all of the services on the development server with:
```
docker-compose up
```

### Connecting to the Mongo DB

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
#
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


## API
[API docs are here](https://speckleworks.github.io/SpeckleOpenApi/#introduction) - they are a good overview of what you can do with the speckle server.


## Credits
Developed by Dimitrie A. Stefanescu [@idid](http://twitter.com/idid) / [UCL The Bartlett](https://www.ucl.ac.uk/bartlett/) / [InnoChain](http://innochain.net) / [Jenca](http://www.jenca.org)

This project has received funding from the European Union’s Horizon 2020 research and innovation programme under the Marie Sklodowska-Curie grant agreement No 642877.

### License
MIT.
