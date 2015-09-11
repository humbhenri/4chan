# 4chan
Grab images, gifs and webms from a 4chan thread.

## Install

- Download and install [Quicklisp](https://www.quicklisp.org/beta/)
- Download this thing to `quicklisp/local-projects/`
- Install SBCL
- Building a binary
```
sbcl --no-user-init --no-sysinit --non-interactive --load ~/quicklisp/setup.lisp --eval '(ql:quickload "4chan")' --eval '(ql:write-asdf-manifest-file "quicklisp-manifest.txt")'
```
And then

```
buildapp --manifest-file quicklisp-manifest.txt --load-system 4chan --entry 4chan:main --output bin/4chan
```
Run it with `4chan <thread url>`.

## Usage from sbcl
- In a terminal, type `sbcl`
- `(ql:quickload '4chan)`
- `(4chan:get-images <4chan url>)`
- All images (gif, web, etc) are saved to a folder in the pwd named after the url
