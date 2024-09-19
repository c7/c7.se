## -- Rsync Deploy config -- ##
SSH_USER        = peter@c7.se
SSH_PORT        = 22
DOCUMENT_ROOT   = /var/www/c7.se/

## -- Misc Configs -- ##
PUBLIC_DIR      = .public
DEVELOPMENT_DIR = .development

#####################
# Development       #
#####################

.PHONY: all
all:
	@hugo server --bind=0.0.0.0 --disableFastRender --watch -d ${DEVELOPMENT_DIR}

.PHONY: spy
spy:
	@spy --inc=sass make css

.PHONY: css
css:
	@sassc -t compressed sass/main.scss static/css/main.css

#####################
# Deployment        #
#####################

.PHONY: deploy
deploy: 
	@echo "## Building Hugo site"
	@rm -rf ${PUBLIC_DIR}
	@hugo -b 'https://c7.se/' -d ${PUBLIC_DIR}
	@echo "## Deploying website via Rsync"
	@rsync -avze 'ssh -p ${SSH_PORT}' --delete ${PUBLIC_DIR}/ ${SSH_USER}:${DOCUMENT_ROOT}
	@rm -rf ${PUBLIC_DIR}
