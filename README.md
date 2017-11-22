# Travis Build [![Build Status](https://travis-ci.org/travis-ci/travis-build.svg?branch=master)](https://travis-ci.org/travis-ci/travis-build)

Travis Build is a library that [Travis
Workers](https://github.com/travis-ci/worker) use to generate a shell
based build script which is then uploaded to the VMs using SSH and executed,
with the resulting output streamed back to Travis.

This code base has gone through several iterations of development, and was
originally extracted from [Travis
Worker](https://github.com/travis-ci/worker), before taking its current
form.

## Running test suites

Run

    bundle exec rake

<a name="addon"></a>
## Use as addon for Travis CLI

You can set travis-build up as a plugin for the [command line client](https://github.com/travis-ci/travis.rb):

    git clone https://github.com/travis-ci/travis-build
    cd travis-build
    mkdir -p ~/.travis
    ln -s $PWD ~/.travis/travis-build
    gem install bundler
    bundle install --gemfile ~/.travis/travis-build/Gemfile
    bundler binstubs travis --force

You will now be able to run the `travis compile` command, which produces
a bash script that runs the specified job and prints it to stdout.
However, secure variables will not be defined, and the build matrix 
expansion will not be considered.

    ~/.travis/travis-build/bin/travis compile

### _Important_

The bash script generated by the compile command contains commands that make changes 
to the system on which it is executed (e.g., edit `/etc/resolv.conf`, install software).
Some require `sudo` privileges and they are not easily undone.

It is highly recommended that you run the script produced by the compile command on a virtual machine.

### Invocation

The command can be invoked in 3 ways:

1. Without an argument, it produces and prints a bash script from the actions in the local `.travis.yml` 
without considering `env` and `matrix` values (`travis-build` is unable to expand these keys correctly).

    `$ ~/.travis/travis-build/bin/travis compile`

1. With a single integer, it produces the script for the given build
(or the first job of that build matrix).

    `$ ~/.travis/travis-build/bin/travis compile 8`

1. With an argument of the form `M.N`, it produces the bash script for the job `M.N`.

    `$ ~/.travis/travis-build/bin/travis compile 351.2`

The resultant script can be used on a (virtual) machine that closely mimics Travis CI's build
environment to aid you in debugging the build failures.

## Raw CLI script

In addition to the travis CLI plugin you can also run the standalone CLI script:

    $ bundle exec script/compile < payload.json > build.sh

## Docker container

If you want to run travis-build locally on your machine (e.g. to interact with [worker](https://github.com/travis-ci/worker)), you can also run it as a docker container with docker-compose:

    $ docker-compose build

to build the container, or

    $ docker-compose up

to build and run it. This will create a container with the contents of the `travis-build`
repository in the `/usr/src/app` directory, and start you off in that directory.
From there, you can run the commands listed in the [Use as addon for Travis CLI](#addon)
section to make the compile command available to Travis CLI within the container.

## License & copyright information

See LICENSE file.

Copyright (c) 2011-2016 [Travis CI development
team](https://github.com/travis-ci).
