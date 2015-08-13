## Install

- Download and install [Quicklisp](https://www.quicklisp.org/beta/)
- Download this thing to `quicklisp/local-projects/`
- Install SBCL

## Usage
- In a terminal, type `sbcl`
- `(ql:quickload '4chan)`
- `(4chan:get-images <4chan url>)`
- All images (gif, web, etc) are saved to a folder in the pwd named after the url
