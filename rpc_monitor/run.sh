pacman -Syu --noconfirm
pacman -S --noconfirm base-devel jq dnsutils git yarn cronie screen python


# install nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

nvm install v16.16.0

yarn set version v16.16.0

cd $HOME
git clone --single-branch --branch main https://github.com/notional-labs/cosmosia

########################################################################################################################
# web
cd $HOME/cosmosia/rpc_monitor/web
yarn && yarn build

screen -S server -dm node server.js

########################################################################################################################
# cron
echo "*/1 * * * * root /bin/bash $HOME/cosmosia/rpc_monitor/cronjob_get_status.sh" > /etc/cron.d/cron_get_status
echo "*/5 * * * * root /bin/bash $HOME/cosmosia/rpc_monitor/cronjob_get_snapshot_size.sh" > /etc/cron.d/cron_get_snapshot_size

# start crond
crond

# loop forever for debugging only
while true; do sleep 5; done
