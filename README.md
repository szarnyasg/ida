# ida

Intelligens Data Analysis homework

[![Build Status](https://travis-ci.org/szarnyasg/ida.svg)](https://travis-ci.org/szarnyasg/ida)

## Tools

### Corese



### Stardog database

Install the Stardog database and [disable the authentication](http://docs.stardog.com/man/server-start.html) with `--disable-security`:

```bash
$ ./stardog-admin server start --disable-security
```

### R

Install R 3.2+:

```bash
$ sudo apt-get install -y r-base r-base-dev
```

To use the `SPARQL` package, you need some additional dependencies:

```bash
$ sudo apt-get install -y libxml2-dev libcurl4-gnutls-dev
$ R
> install.packages("SPARQL")
```
