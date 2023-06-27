# pulumi-docker-ssh-issue

This repository demonstrates the issue trying connecting to remote Docker via ssh protocol when using Pulumi (YAML runtime)

### Resolution

The issue was resolved in [v4.3.0](https://github.com/pulumi/pulumi-docker/releases/tag/v4.3.0)

### Steps to repoduction

Using environment variable:

1. Clone this repository.
2. Make sure you have working SSH connection with your server and both has Docker installed, run `DOCKER_HOST=ssh://user@ip docker info` and you'll see information about your remote docker in `Server` section.
3. Run `DOCKER_HOST=ssh://user@ip pulumi up -y` (replace `user` and `ip` according to your server connection params).

This will throw an error trying creating a new image using remote docker:

```
error: error during connect: Post "http://user%40ip/v1.24/build?buildargs=null&cachefrom=null&cgroupparent=&cpuperiod=0&cpuquota=0&cpusetcpus=&cpusetmems=&cpushares=0&dockerfile=Dockerfile&labels=null&memory=0&memswap=0&networkmode=&platform=linux%2Farm64&rm=0&session=weqqp5ps9wn73y2uvl3nrqrkn&shmsize=0&t=my-image&target=&ulimits=null&version=2": dial tcp: lookup user@ip: no such host
```

Using pulumi config:

1. Open `Pulumi.yaml`:
2. Uncomment the whole `docker-remote` resource, and `options.provider` on every other resource.
3. Uncomment `docker-remote` params in `Via connection string only` section, then replace `host` with your ssh server address.
4. Run `pulumi up -y`, and you'll get the same error as in previous attempt.
3. Then comment out this parameters for `docker-remote`, and uncomment the parameters from `With sshOpts` section, then:
  3.1. Replace `ip` with server hostname or ip
  3.2. Replace `user` in `sshOpts` array with the actual username
  3.3. Run `pulumi up -y`, and you'll still get the same error

Then, to make sure the same connection works as expected with `docker` cli:

1. Build a new image for this project: `DOCKER_HOST=ssh://user@ip docker build -t my-image .`.
2. Start a container that uses our image `DOCKER_HOST=ssh://user@ip docker run -p 3030:3030 --rm my-image`. Once finished you'll see following message from the server: `Listen on port 3030`.
3. Optionally, you can connect to that application (from the same server where it runs) using netcat: `nc localhost 3030`, once connected you can send a string to that application and it will return it uppercased.
