%include fedora-live-workstation.ks

keyboard gb
lang en_GB

# rpmfusion 
repo --name="rpmfusion-free" --mirrorlist=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-32&arch=x86_64
repo --name="rpmfusion-free-updates" --mirrorlist=https://mirrors.rpmfusion.org/metalink?repo=free-fedora-updates-released-32&arch=x86_64
repo --name="rpmfusion-nonfree" --mirrorlist=https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-32&arch=x86_64
repo --name="rpmfusion-nonfree-updates" --mirrorlist=https://mirrors.rpmfusion.org/metalink?repo=nonfree-fedora-updates-released-32&arch=x86_64

# copr repos
repo --name="copr:copr.fedorainfracloud.org:alebastr:sway-extras" --baseurl=https://download.copr.fedorainfracloud.org/results/alebastr/sway-extras/fedora-32-x86_64
repo --name="copr:copr.fedorainfracloud.org:pschyska:alacritty" --baseurl=https://download.copr.fedorainfracloud.org/results/pschyska/alacritty/fedora-32-x86_64
repo --name="copr:copr.fedorainfracloud.org:sentry:v4l2loopback" --baseurl=https://download.copr.fedorainfracloud.org/results/sentry/v4l2loopback/fedora-32-x86_64
repo --name="copr:copr.fedorainfracloud.org:wef:swappy" --baseurl=https://download.copr.fedorainfracloud.org/results/wef/swappy/fedora-32-x86_64

%packages
# basics
htop
vlc
lshw

# dev deps
make
automake
gcc
kernel-devel

# desktop environment
sway 
waybar # status bar
gammastep # flux
mako # notifications
ulauncher # popup launcher

# terminal
alacritty

# work
chromium

# video for linux
kernel-devel # needed to build the kernel module in the next package (install hook)
v4l2loopback-dkms # kernel module
v4l2loopback # tools to manage module
wf-recorder # records screen and writes to device

# tools for creating live isos
# livecd-tools
%end

%post
home_dir=/home/charlieegan3
if [ -d /home/charlieegan3 ]; then
	echo "hey" > $home_dir/message
else
	echo "hey" > /etc/message
fi
%end
