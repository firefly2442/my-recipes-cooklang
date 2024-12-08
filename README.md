# my-recipes-cooklang

My personal recipes in markdown [cooklang format](https://github.com/cooklang/spec).

## Requirements

* Docker (w/buildkit enabled)
* docker compose

## Setup

```shell
docker compose build --pull
```

## Running

```shell
docker compose up -d
```

Access the web-ui at: `http://localhost:9080`

## Updating Recipes

* Images must match up with the `.cook` filename to appear.
* The server will hot-load recipe changes so refresh the browser
and you will see updates.

## References

* [https://github.com/cooklang/cookcli](https://github.com/cooklang/cookcli)
* [https://cooklang.org/](https://cooklang.org/)
* [https://github.com/cooklang/spec](https://github.com/cooklang/spec)
* [https://github.com/Zheoni/cooklang-chef](https://github.com/Zheoni/cooklang-chef)
