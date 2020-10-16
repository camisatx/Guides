echo "Setting up the Raspberry Pi"
echo ""

echo "Disabling and removing system swap"
sudo dphys-swapfile swapoff
sudo dphys-swapfile uninstall
sudo update-rc.d dphys-swapfile remove
sudo systemctl disable dphys-swapfile

echo ""
echo "Setting swappiness to 0"
if [ $(grep -c swappiness /etc/sysctl.conf) -eq 0 ]; then
    echo "vm.swappiness=0" | sudo tee -a /etc/sysctl.conf
    echo "updated /etc/sysctl.conf with vm.swappiness=0"
else
    sudo sed -i "/vm.swappiness/c\vm.swappiness=0" /etc/sysctl.conf
    echo "vm.swappiness found in /etc/sysctl.conf update to 0"
fi
sudo sysctl vm.swappiness=0

echo ""
echo "Installing log2ram"
echo "deb http://packages.azlux.fr/debian/ buster main" | sudo tee /etc/apt/sources.list.d/azlux.list
wget -qO - https://azlux.fr/repo.gpg.key | sudo apt-key add -
sudo apt update
sudo apt install log2ram

echo ""
echo "Finished setting up system. Please restart system now"
