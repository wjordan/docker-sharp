# [Docker Image](https://registry.hub.docker.com/u/wjordan/sharp/) for [sharp](https://github.com/lovell/sharp)
[![](https://badge.imagelayers.io/wjordan/sharp:latest.svg)](https://imagelayers.io/?images=wjordan/sharp:latest 'wjordan/sharp:latest')

Installs [sharp](https://github.com/lovell/sharp) and all C-extension dependencies under Alpine Linux.

Depends on [wjordan/libvips](https://github.com/wjordan/dockerfile-libvips).

## Usage

Within the Docker image, `sharp` is pre-installed into the global npm folder with all compile-time dependencies removed.
To link global `sharp` to a local application $APP, you will need to do some manual steps to link your npm package to the pre-compiled
`sharp` dependency without triggering recompilation, something like:

```bash
npm install --ignore-scripts
npm link sharp
rm -rf node_modules/$APP/node_modules/sharp
npm install
```

## How to build

Just run `./sharp.docker.sh`.

Uses [dockerize](https://github.com/docker/docker/issues/14080#issuecomment-132841442) script instead of `docker build` to create the Docker image.

## License

Licensed under [MIT](http://opensource.org/licenses/mit-license.html)
