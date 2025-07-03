# svg-preview.yazi

## Motivation

debian bookworm has an older version of imagemagick installed, where the default 
previewer of yazi fails. But there are other standard tools available which could 
be used on those server operating systems without the need to upgrade distro supplied
packages.

This plugin makes use of those tools.

## Installation

ya pack -a michaelrommel/svg-preview

## Prerequisites

`svg-preview` uses different tools on Apple/Darwin and Linux for obtaining the size
of an image. On Darwin the `exiftool` proved to be a lot faster for `.svg`
files than the `identify` tool from the imagemagick suite. I have no idea why, because
it is a perl script and it is much larger in size.

On both platforms the `rsvg-convert` binary is used to do the actual image conversion.

### On macOS

```
brew install librsvg exiftool
```

### On Linux

```
sudo apt install librsvg2-bin imagemagick
```

## Configuration

```
[plugin]
prepend_preloaders = [
    { mime = "image/svg+xml", run = "svg-preview" }
]
prepend_previewers = [
    { mime = "image/svg+xml", run = "svg-preview" },
]
```
