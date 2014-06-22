PoC MongoDB Injections
======================

These are sample PoC SSJSI (Server-side JavaScript Injections) that can be executed on improperly secured MongoDB instances.

### Background

For a more complete background, see MongoDB's [website](http://docs.mongodb.org/manual/faq/developers/#how-does-mongodb-address-sql-or-query-injection)

The four functions focused in these demo's are:

- $where
- db.eval()
- mapReduce
- group

Each one of these functions allows the execution of arbitrary javascript expressions. So if we had an expression such as:

```javascript
userInput = req.params.name;
db.getSiblingDB('public').publics.find({$where: 'this.name == ' + userInput})
```

we could inject our own code into the where clause and it would be executed.

### Protection

The simpliest way to fix this is to disallow arbitrary javascript expressions on the server using the _--noscripting_ option.

### Injections

#### Case 1: Stealing Sensetive Data

Using a user supplied injection, we are able to copy data from a private db.collection into a public db.collection. 

See [copy.sh](copy.sh)

#### Case 2: Reading host machine files

Using a user supplied injection, we are able to read files on the remote machine and insert them into a public db.collection.

See [cat.sh](cat.sh)