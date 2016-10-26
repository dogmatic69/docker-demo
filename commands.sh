# Basics
docker build -t docker/ubuntu-16 ubuntu/16
docker run --rm -it docker/ubuntu-16 pwd # run a command on the box
docker run --rm -it docker/ubuntu-16 bash # basically like ssh

# Build various versions of ubuntu
docker build -t docker/ubuntu-16 ubuntu/16
docker build -t docker/ubuntu-14 ubuntu/14
docker build -t docker/ubuntu-12 ubuntu/12
docker build -t docker/ubuntu-custom ubuntu/custom

    # check its actually not just the host machine
    docker run --rm -it docker/ubuntu-16 cat /etc/*release | grep RELEASE
    docker run --rm -it docker/ubuntu-14 cat /etc/*release | grep RELEASE
    docker run --rm -it docker/ubuntu-12 cat /etc/*release | grep RELEASE
    docker run --rm -it docker/ubuntu-custom cat /etc/*release | grep RELEASE

# Build various versions of fedora
docker build -t docker/fedora-24 fedora/24
docker build -t docker/fedora-23 fedora/23
docker build -t docker/fedora-22 fedora/22
docker build -t docker/fedora-21 fedora/21

    # Well, its not even the same distro anymore.
    docker run --rm -it docker/fedora-24 cat /etc/fedora-release
    docker run --rm -it docker/fedora-23 cat /etc/fedora-release
    docker run --rm -it docker/fedora-22 cat /etc/fedora-release
    docker run --rm -it docker/fedora-21 cat /etc/fedora-release

######################################
#
# Basic app example, nodeJs
#
######################################

# build the nodejs app
docker build -t docker/nodejs nodejs
docker run --rm -it docker/nodejs bash # same as before, nothing new.

docker run --rm -it --entrypoint bash docker/nodejs # let explore
    # on the container
    /app/start.sh & # because we overrode the entrypoint to use bash
    w3m http://localhost:1234/info # can only be accessed from within the container

wget -o - http://localhost:8080/info # wont work, nothing is listening

docker run --rm -it -p 8080:1234 docker/nodejs # forward the port from the container to the host, now its accessible.

wget -o - http://localhost:8080/info 2>/dev/null | jq -r ".Network[0].address" - # tada

#####################################
#
# Web Scale?
#
#####################################

# running multiple containers
docker run --rm -it -p 8080:1234 docker/nodejs
docker run --rm -it -p 8081:1234 docker/nodejs
docker run --rm -it -p 8082:1234 docker/nodejs

wget -O - http://localhost:8080/info 2>/dev/null | jq -r ".Network[0].address" -
wget -O - http://localhost:8081/info 2>/dev/null | jq -r ".Network[0].address" -
wget -O - http://localhost:8082/info 2>/dev/null | jq -r ".Network[0].address" -

# Kinda difficult to manage right, probably need to automate this

# Run a simple docker-compose
docker-compose -f ./nodejs/basic.yml up
    # whats running
    docker-compose -f ./nodejs/basic.yml ps

wget -O - http://localhost:4321/info 2>/dev/null | jq -r ".Network[0].address" -

# Still not automated, hard coded ports etc.

# Consul and all the things
docker build -t docker/haproxy haproxy

# add /etc/hosts entry

docker-compose -f ./nodejs/consul.yml up # bring up the new infra with consul, haproxy and registrator

# whats running
docker-compose -f nodejs/consul.yml ps

# consul data
http://nodejs.docker.test:1800/ui/#/dc1/services

# access the haproxy details
http://nodejs.docker.test/haproxy-stats

# Web Scale
docker-compose -f nodejs/consul.yml scale nodejs=100





##################################
#
# Resources???
#
##################################

docker-compose -f ./os-test.yml up

docker exec -it docker_fedora-21_1 cat /etc/fedora-release
docker exec -it docker_fedora-22_1 cat /etc/fedora-release
docker exec -it docker_fedora-23_1 cat /etc/fedora-release
docker exec -it docker_fedora-24_1 cat /etc/fedora-release

# start up 20 instances of 8 different OSs
docker-compose -f ./os-test.yml scale \
    fedora-21=20 \
    fedora-22=20 \
    fedora-23=20 \
    fedora-24=20 \
    ubuntu-12=20 \
    ubuntu-14=20 \
    ubuntu-16=20 \
    ubuntu-custom=20

docker-compose -f ./os-test.yml ps # see what is running

docker-compose -f ./os-test.yml ps | wc -l # o.O








##########################
#
# When shit breaks
#
##########################

# kill consul data
docker-compose -f nodejs/consul.yml stop consul haproxy registrator && \
    yes | docker-compose -f nodejs/consul.yml rm consul haproxy registrator && \
    yes | docker volume rm nodejs_consul_data && \
    docker-compose -f nodejs/consul.yml up -d consul registrator haproxy

# Running out of file descriptors
sudo sysctl -w fs.file-max=100000