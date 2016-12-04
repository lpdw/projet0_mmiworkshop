# projet0_mmiworkshop

DOCUMENTATION LPDWWORKSHOP

INSTALLATION :


Installer Ruby-2.2.4 :

	xcode-select --install
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
	brew update
	brew install rbenv ruby-build
	echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
	echo 'export PATH="$HOME/.rbenv/shims:$PATH"' >> ~/.bash_profile
	source ~/.bash_profile
	rbenv install 2.2.4
	rbenv global 2.2.4
	gem install rails --no-document

Installer Postgresql :

	brew update
	brew doctor
	brew install postgresql
	gem install lunchy
	mkdir -p ~/Library/LaunchAgents
	cp /usr/local/Cellar/postgresql/X.X.X/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents/ # REMPLACER X.X.X par la version de Postgresql installée
	launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist
	lunchy start postgres # POUR LANCER POSTGRESQL
	lunchy stop postgres # POUR ARRETER POSTGRESQL

Créer l'utilisateur "postgres" :

`createuser -s -r postgres`

Installer bundler :

`gem install bundler`


Cloner le projet :

`git clone https://github.com/lpdw/projet0_mmiworkshop.git`

Depuis le répertoire du projet, lancer l'installation du bundle :

`bundle install`

Créer et migrer la base :

`bundle exec rake db:create db:migrate`


Import du dump vers la base de donnée en local

`pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d mmiworkshop latest.dump`


Lancer le serveur :

`rails -s`
(Ne pas oublier de lancer Postgres avant -> lunchy start postres)