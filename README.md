# [Docker Image](https://registry.hub.docker.com/u/wjordan/sharp/) for [sharp](https://github.com/lovell/sharp)
[![](https://images.microbadger.com/badges/image/wjordan/sharp.svg)](https://microbadger.com/images/wjordan/sharp "wjordan/sharp") [![](https://images.microbadger.com/badges/version/wjordan/sharp.svg)](https://microbadger.com/images/wjordan/sharp "wjordan/sharp")

Installs [sharp](https://github.com/lovell/sharp) in an Alpine Linux container.

## Usage

Within the Docker image, `sharp` is pre-installed into the global `node_modules` folder with all compile-time dependencies removed.

To link global `sharp` to a local application `$APP`, you will need to do some manual steps to link your npm package to the pre-compiled `sharp` dependency without triggering recompilation, something like:

```bash
npm install --ignore-scripts
npm link sharp
rm -rf node_modules/$APP/node_modules/sharp
npm install
```

## How to build

Just run `docker build .`

## License

Licensed under [MIT](http://opensource.org/licenses/mit-license.html)
