PoC MongoDB Injections
======================

The are just sample PoC injections that can be executed on improperly secured MongoDB instances.

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
db.getSiblingDB('public').publics.find({\$where: 'this.name == ' + userInput})
```

we could inject our own code into the where clause and it would be executed.

### Protection

The simpliest way to fix this is to disallow arbitrary javascript expressions on the server using the --noscripting option.

### Injections

#### Case 1: Stealing Sensetive Data

See [copy.sh](copy.sh)

#### Case 2: Reading host machine files

See [cat.sh](cat.sh)