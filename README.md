## AWS HPC Workshop


Collection of workshops to demonstrate best practices in using Amazon Web Service High Perfomance Computing (HPC) components.

### https://hpcworkshops.com

## Building the Workshop site

The content of the workshops is built using [hugo](https://gohugo.io/).

To build the content
1. Clone this repository
```bash
git clone --recurse-submodules https://github.com/aws-samples/aws-hpc-tutorials.git
```
2. [Install Hugo](https://gohugo.io/getting-started/installing/). On a mac that's:
```bash
brew install hugo
```
3. Run hugo to generate the site, and point your browser to http://localhost:1313
```bash
hugo serve -D
```

### Update Theme

The project uses [hugo learn](https://github.com/matcornic/hugo-theme-learn/) template as a git submodule. To update the content, execute the following code
```bash
pushd themes/hugo-theme-learn
git submodule init
git submodule update --checkout --recursive
popd
```

## License

The documentation is made available under the Creative Commons Attribution-ShareAlike 4.0 International License. See the [LICENSE](LICENSE) file.

The sample code within this documentation is made available under the MIT-0 license. See the [LICENSE-SAMPLECODE](LICENSE-SAMPLECODE) file.
