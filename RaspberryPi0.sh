#!/bin/bash
#Pi Zero Install, largely plagiarised from MagicMirror2's raspberry.sh shell script for Pi2 and Pi3
echo 'Updating Pi'
sudo apt-get update;
echo 'Upgrading Pi'
sudo apt-get upgrade;
#sudo apt-get upgrade --fix-missing;

echo 'Downloading node v11.6.0'
curl -o node-v11.6.0-linux-armv6l.tar.gz  https://nodejs.org/dist/v11.6.0/node-v11.6.0-linux-armv6l.tar.gz; #Most up to date recent version
echo 'Extracting node v11.6.0'
tar -xzf node-v11.6.0-linux-armv6l.tar.gz; # extract files
echo 'Extracting node and npm'

cd node-v11.6.0-linux-armv6l/;
sudo cp -R * /usr/local/;
cd ~;
sudo apt install git; sudo apt install unclutter;
echo 'Cloning Magic Mirror'

git clone https://github.com/MichMich/MagicMirror;
cd MagicMirror;
echo 'Installing Magic Mirror Dependencies'
npx npmc@latest install -arch=armv71; npm install acorn@latest; npm install stylelint@latest; npm audit fix;
# or remove -arch from above and just run "npm install -arch=armv71" here
echo 'Loading default config'

# Use sample config for start MagicMirror
cp config/config.js.sample config/config.js;

#Set the splash screen to be magic mirror
THEME_DIR="/usr/share/plymouth/themes"
sudo mkdir $THEME_DIR/MagicMirror
sudo cp ~/MagicMirror/splashscreen/splash.png $THEME_DIR/MagicMirror/splash.png && sudo cp ~/MagicMirror/splashscreen/MagicMirror.plymouth $THEME_DIR/MagicMirror/MagicMirror.plymouth && sudo cp ~/MagicMirror/splashscreen/MagicMirror.script $THEME_DIR/MagicMirror/MagicMirror.script; 
sudo plymouth-set-default-theme -R MagicMirror; 
mkdir ~/MagicMirror/PiZero;
sudo mv ~/MagicMirrorPi0Installer/startMagicMirrorPi0.sh ~/MagicMirror/PiZero/startMagicMirrorPi0.sh;
sudo mv ~/MagicMirrorPi0Installer/pm2_MagicMirrorPi0.json ~/MagicMirror/PiZero/pm2_MagicMirrorPi0.json;
sudo mv ~/MagicMirrorPi0Installer/chromium_startPi0.sh ~/MagicMirror/PiZero/chromium_startPi0.sh;
sudo chmod a+x ~/MagicMirror/PiZero/startMagicMirrorPi0.sh;
sudo chmod a+x ~/MagicMirror/PiZero/pm2_MagicMirrorPi0.json;
sudo chmod a+x ~/MagicMirror/PiZero/chromium_startPi0.sh;

# Use pm2 control like a service MagicMirror
sudo npm install -g pm2;
sudo su -c "env PATH=$PATH:/usr/bin pm2 startup systemd -u pi --hp $HOME";
pm2 start /home/pi/MagicMirror/PiZero/pm2_MagicMirrorPi0.json;
pm2 save;
echo 'Magic Mirror should begin shortly'
