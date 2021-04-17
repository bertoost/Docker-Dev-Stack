# Install the project

Copy the `default.env` to `.env` and change the contents to your need.

> __Note:__ You can also pass some of the variables to your environment if you want them globally available in all your projects. For example the `DEV_HOST_DOMAIN` is good to set global. See section below.

## Docker networks
Add a new Docker networks first

```bash
# Network for development (PHP, MySQL images etc)
docker network create development

# Network for Traefik webservers (NginX)
docker network create webgateway
```

## Global environment variables (recommended)

I'll advice you to register some environment variables on your machine. This will become helpful when dealing with a custom hostname per project (see [examples](examples/Index.md)).

```bash
# Setup a root hostname
DEV_HOST_DOMAIN=yourname.local
```

> **Tip!**  
> if your using multiple terminals, put this in a new file like `~/.dev_profile` and 
> load it in your .bashrc, .bash_profile or .zshrc

## Windows users

I'll recommend to use [CMD-er](http://cmder.net/) on Windows. Since it comes with a couple of nice built-in features to make life a bit easier.

__Note:__ to run bash scripts as above on commandline interface, prefix commands with `sh` command. So it should look like `sh scripts/install.sh`
