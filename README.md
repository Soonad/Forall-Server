[![Build Status](https://api.cirrus-ci.com/github/moonad/Forall-Server.svg)](https://cirrus-ci.com/github/moonad/Forall-Server)

# Forall Server

Forall is the repository for Formality files.

## Description

This app is built with [Phoenix Framework](https://www.phoenixframework.org).

## Installation

```bash
$ mix deps.get
```

## Running the app

Before starting the server, you need to start all external dependencies (Posgres for now), create
the minio bucket, the database and run migrations:

```bash
# start dependencies
$ docker-compose up -d

# setup minio bucket
$ mix setup_bucket

# create database
$ mix ecto.create

# run migrations
$ mix ecto.migrate
```

And then you just need to start the server with one of the two commands below:

```bash
# start server in development
$ mix phx.server

# start server in development with a interactive shell
$ iex -S mix phx.server
```

## Test and Checks

```bash
# run all tests and checks
$ mix check
```