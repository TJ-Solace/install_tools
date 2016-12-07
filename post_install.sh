#!/usr/bin/env sh
echo 'installing ros'
sudo apt-get update --force-yes

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net --recv-key 0xB01FA116

sudo apt-get --force-yes update
sudo apt-get --force-yes install libgl1-mesa-dev-lts-utopic
sudo apt-get --force-yes install vim vim-runtime
sudo apt-get --force-yes install tmux 
sudo apt-get --force-yes install git 
sudo apt-get --force-yes install ros-kinetic-desktop-full
sudo apt-get --force-yes install ros-kinetic-ackermann-msgs ros-kinetic-serial

sudo apt-get --force-yes update

mkdir -p ~/racecar-ws/src
cd ~/racecar-ws/src
git clone https://github.com/mit-racecar/racecar-simulator.git
git clone https://github.com/mit-racecar/racecar.git
git clone https://github.com/Bobobalink/vesc.git  # use the vesc package with changes for newer versions of boost


### INSTALL GAZEBO

sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'

wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -

sudo apt-get --force-yes update

sudo apt-get --force-yes install ros-kinetic-controller-manager ros-kinetic-gazebo-ros-control ros-kinetic-gazebo-ros-pkgs ros-kinetic-joint-state-controller ros-kinetic-effort-controllers 


### SET UP WORKSPACE
echo "source /opt/ros/kinetic/setup.bash" >> ~/.bashrc
. ~/.bashrc

cd ~/racecar-ws/src/
catkin_init_workspace
cd ~/racecar-ws
catkin_make

echo "source ~/racecar-ws/devel/setup.sh" >> ~/.bashrc
echo "export ROS_IP=`hostname -I`" >> ~/.bashrc


### INSTALL ZED SDK

# Jetson TX1
wget -O ZED_SDK_v1.2.0.run https://www.stereolabs.com/download_327af3/ZED_SDK_Linux_JTX1_v1.2.0_64b_JetPack23.run

# Ubuntu
#wget -O ZED_SDK_v1.2.0.run https://www.stereolabs.com/download_327af3/ZED_SDK_Linux_Ubuntu16_CUDA80_v1.2.0.run

sh ZED_SDK_v1.2.0.run


### INSTALL PCL
sudo apt-get --force-yes install libflann-dev
wget https://github.com/PointCloudLibrary/pcl/archive/pcl-1.8.0.tar.gz
tar xf pcl-pcl-1.8.0.tar.gz
cd pcl-pcl-1.8.0 && mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j4
sudo make -j4 install
