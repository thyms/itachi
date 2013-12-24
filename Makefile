# type 'make -s list' to see list of targets.
checkout-project:
	git checkout develop
	git submodule update --init --recursive
	make setup-git

setup-project:
	make checkout-project
	cd presentation && make setup-project
	cd presentation-stubulator && make setup-project

setup-git:
	git remote rm origin && git remote add origin git@github-thyms.com:thyms/macross.git && git fetch && git checkout develop
	cd presentation && git remote rm origin && git remote add origin git@github-thyms.com:thyms/macross-presentation.git && git fetch && git checkout develop
	cd presentation-functional && git remote rm origin && git remote add origin git@github-thyms.com:thyms/macross-presentation-functional.git && git fetch && git checkout develop
	cd presentation-stubulator && git remote rm origin && git remote add origin git@github-thyms.com:thyms/macross-presentation-stubulator.git && git fetch && git checkout develop

setup-heroku:
	heroku apps:create --remote func01  --app itachi-presentation-func01
	heroku apps:create --remote qa01    --app itachi-presentation-qa01
	heroku apps:create --remote demo01  --app itachi-presentation-demo01
	heroku apps:create --remote stage01 --app itachi-presentation-stage01
	heroku apps:create --remote prod01  --app itachi-presentation-prod01
	heroku apps:create --remote stub01  --app itachi-presentation-stub01
	heroku config:add NODE_ENV=func01   --app itachi-presentation-func01
	heroku config:add NODE_ENV=qa01     --app itachi-presentation-qa01
	heroku config:add NODE_ENV=demo01   --app itachi-presentation-demo01
	heroku config:add NODE_ENV=stage01  --app itachi-presentation-stage01
	heroku config:add NODE_ENV=prod01   --app itachi-presentation-prod01
	heroku config:add NODE_ENV=stub01   --app itachi-presentation-stub01

setup-travis:
	cd presentation && travis encrypt $(heroku auth:token) --add deploy.api_key --skip-version-check && git add -A && git commit -m "@thyms updated heroku deployment key."
	cd presentation-stubulator && travis encrypt $(heroku auth:token) --add deploy.api_key --skip-version-check && git add -A && git commit -m "@thyms updated heroku deployment key."
	git add -A && git commit -m "@thyms updated heroku deployment key."
	git push

test-app-ci:
	cd presentation-functional && make test-app-ci

ide-idea-clean:
	rm -rf *iml
	rm -rf .idea*

.PHONY: no_targets__ list
no_targets__:
list:
	sh -c "$(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | sort"
