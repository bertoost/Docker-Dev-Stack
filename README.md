<p align="center"><img src="docs/images/docker-logo.svg" alt="Docker" width="400"></p>

<h1 align="center">Docker Dev Stack</h1>

[![Build Status](https://travis-ci.org/bertoost/Docker-Dev-Stack.svg?branch=master)](https://travis-ci.org/bertoost/Docker-Dev-Stack)

> __Please read the docs carefully__  
> The purpose of this development stack with Docker images is to help setting up a local environment for development of PHP/MySQL projects. It's not meant to be used in production.

Before you use this dev stack, please read the following topics.

- [Stack contents (services)](docs/Contents.md)
- [Installation](docs/Installation.md)
- [Supported systems](docs/Supported.md)
- [Traefik usage](docs/Traefik.md)
  - [Frontends vs. Backends](docs/Traefik.md#frontends-vs-backends)
  - [Per project basis](docs/Traefik.md#using-traefik-on-per-project-basis)
  - [Auto-added binary files](docs/Traefik.md#auto-added-binary-files)
- [MySQL & Upgrading version](docs/MySQL.md)
- [Mailhog & Portainer](docs/Others.md)

For advanced users

- [Custom NginX Config](docs/CustomNginx.md)
  - [Configuration folder](docs/CustomNginx.md#configuration-folder)
  - [Environment variables](docs/CustomNginx.md#using-environment-variables)

### Fallback PHP version support

Before this was included by default. Read more about the fallback PHP version support

[Dev Stack Fallback setup](docs/fallback/Setup.md)

### Custom services

There are a couple of services, separated from the main features in this dev-stack

[More about custom services](docs/CustomServices.md)