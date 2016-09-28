# projet0_mmiworkshop

Salut les amis.


// On récupère le dump de la base

`heroku pg:backups capture --app lpdwworkshop`


`curl -o latest.dump 'heroku pg:backups public-url --app lpdwworkshop'`

// Import du dump vers la base de donnée en local

`pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d mmiworkshop latest.dump`


// Dump base 

`psql mmiworkshop > base.dump`

// Import depuis le dump psql


`psql mmiworkshop < base.dump`