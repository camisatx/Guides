# System Settings

## Software

### Ubuntu Store

- Caffeine
- System Load Indicator

### Online

- Calibre (book manager - optional)
- Chrome
- Dropbox
- Foxit
- GIMP (photo editing - optional)
- Kdenlive (video editing - optional)
- Signal
- Steam
- Veracrypt
- VMware Player

## SMB

Create a .smbcredentials file with 600 permission. Include the following:
```bash
<Samba user name>
<Samba user password>
```

Edit the /etc/fstab file to include:
```bash
//192.168.0.##/<folder> /mnt/<folder> cifs noperm,credentials=/home/<user>/.smbcredentials,iocharset=utf8,gid=1000,uid=1000,file_mode=0777,dir_mode=0777 0 0
```

## Terminal

### Background

- Background: #1D1D1D
- Text: #FFFFFF

### Colors

- Black 1: #2D3C46
- Black 2: #425059
- Red 1: #A54242
- Red 2: #CC6666
- Green 1: #8C9440
- Green 2: #B5BD68
- Yellow 1: #C4A000
- Yellow 2: #FCE94F
- Blue 1: #3465A4
- Blue 2: #729FCF
- Purple 1: #75507B
- Purple 2: #AD7FA8
- Teal 1: #06989A
- Teal 2: #34E2E2
- White 1: #D3D7CF
- White 2: #EEEEEC

### Font
- Meslo LG S for Powerline Regular
- 8 pt

### Plugins

- git
- tmux
- tmux resurrect
- vim

### Paths

```bash
# added for ROS Kinetic; only have one ROS distribution active at one time
#   and do not use Python Anaconda
#source /opt/ros/kinetic/setup.bash

# added for Robotics ND ROS environments
#source /home/josh/Programming/Code/RoboticsND_Main/ROS-PickPlace/catkin_ws/devel/setup.bash
#export GAZEBO_MODEL_PATH=/home/josh/Programming/Code/RoboticsND_Main/ROS-PickPlace/catkin_ws/src/RoboND-Kinematics-Project/kuka_arm/models
#source /home/josh/Programming/Code/RoboticsND_Main/ROS-Perception/catkin_ws/devel/setup.bash
#export GAZEBO_MODEL_PATH=/home/josh/Programming/Code/RoboticsND_Main/ROS-Perception/catkin_ws/src/sensor_stick/models
#export GAZEBO_MODEL_PATH=/home/josh/Programming/Code/RoboticsND_Main/ROS-Perception/catkin_ws/src/RoboND-Perception-Project/models
#source /home/josh/Programming/Code/RoboticsND_Main/ROS-Control/catkin_ws/devel/setup.bash


# added by Anaconda3 installer
export PATH="/home/josh/Programming/Python/Anaconda3_5/bin:$PATH"
```

## VPN

Copy the hidden manger file from the home folder to the `/media/<user>/` file, ensuring that all ownership remains to the user. Then create a sym link from this new location back to the original home folder location.
