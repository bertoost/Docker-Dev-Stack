# Dev Stack Fallback Setup

Sometimes you don't want to up a whole project configuration for a single script. Testing things out, or just run a project which is not yet ready or supported by the provided images.

For this projects there is a fallback launched when you up the Dev Stack.

## How it works

By default there is a project directory when you checkout this repository. It contains a phpinfo "project".

Traefik is configured to load this fallback as last (regarding custom project domains via Traefik). Meaning, if any dockerized project is having their own config/setup, it's loaded and used first above the fallback projects.

## Supported URLs

The next URLs are leading to your projects-directory loaded via PHP7.2

```bash
http://my-project.php74.{domain}
```

This next URLs are leading to your projects-directory loaded via PHP7.3

```bash
http://my-project.php74.{domain}
```

> In above example the folder `my-project/` should exist in the projects-directory. The name of the directory inside the projects-directory is used as first part.

## Document root

Inside a project directory, NginX is looking for several options. Below in order;

1. `{project-dir}/public_html/`
2. `{project-dir}/public/`
3. `{project-dir}/web/`
4. `{project-dir}/httpdocs/`
5. `{project-dir}/`

It is looking for an `index.php`, `index.html` and last `index.htm`

_By default there is no friendly-url support in this fallback system._

## Start the fallback

From inside the root of your dev-stack checkout you should run the next command

```bash
docker-compose -f services/fallback/docker-compose.yml up -d
```

## Projects directory

Default the dev-stack works with the root projects/ directory.

By default a phpinfo is included.

Once upped, try to open this URLs and see what happens.

```bash
http://phpinfo.php73.{domain}

http://phpinfo.php74.{domain}

http://phpinfo.php80.{domain}
```

### Changing directory

Therefore you have to create a .env file inside `services/fallback/` with this variable

```dotenv
PROJECTS_DIR=relative/path/actual/directory
```
