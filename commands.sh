# Build various versions of ubuntu
docker build -t docker/ubuntu-12 ubuntu/12
docker build -t docker/ubuntu-14 ubuntu/14
docker build -t docker/ubuntu-16 ubuntu/16
docker build -t docker/ubuntu-custom ubuntu/custom

# Build various versions of fedora
docker build -t docker/fedora-21 fedora/21
docker build -t docker/fedora-22 fedora/22
docker build -t docker/fedora-23 fedora/23
docker build -t docker/fedora-24 fedora/24


# Run a simple docker-compose
docker-compose -f ./nodejs/basic.yml up
    # whats running
    docker-compose -f ./nodejs/basic.yml ps

# Consul and all the things
docker build -t docker/haproxy haproxy
docker-compose -f ./nodejs/consul.yml up

    # whats running
    docker-compose -f nodejs/consul.yml ps


