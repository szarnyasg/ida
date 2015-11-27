# ida
Intelligens Data Analysis homework

## Tools

### Stardog database

Install the Stardog database and [disable the authentication](http://docs.stardog.com/man/server-start.html) with `--disable-security` ():

```bash
$ ./stardog-admin server start --disable-security
```

### R

Install R 3.2+. To use the `SPARQL` package, you need some additional dependencies:

```
$ sudo apt-get install -y libxml2-dev libcurl4-gnutls-dev
$ sudo R
> install.packages("SPARQL")
```
