git clone --depth=1 https://github.com/vhive-serverless/vhive.git
git clone --depth=1 https://github.com/vhive-serverless/vSwarm.git

# install go 1.19, awscli and istioctl
sudo snap install go --channel=1.22/stable --classic
sudo snap install aws-cli --classic
sudo apt update && sudo apt install -y gcc
curl -sL https://istio.io/downloadIstioctl | sh -
echo "export PATH=$HOME/.istioctl/bin:$PATH" >> ~/.bashrc

# build necessary binaries
source /etc/profile
cd ~/vhive/
go build
pushd scripts && go build -o setup_tool && popd && mv ./scripts/setup_tool ./
cd ~/vSwarm/tools/deployer/
go build
cd ~/vSwarm/tools/invoker/
go build
cd ~/vSwarm/tools/test-client/
go build

# copy deployment config for deployer
cp ~/sosp-tutorial-infra-setup/vHive_hands_on/configs/*.json ~/

# copy deployment config for video analytics
cp -r ~/vSwarm/benchmarks/video-analytics/yamls/knative/s3 ~/vSwarm/benchmarks/video-analytics/yamls/knative/s3_single
cp ~/sosp-tutorial-infra-setup/vHive_hands_on/configs/service-decoder.yaml ~/vSwarm/benchmarks/video-analytics/yamls/knative/s3_single/