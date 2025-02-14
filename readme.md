# Fork

Code from a fork of https://github.com/trafnar/imba-builder (ISC license). Please do check out Nathan's presence here https://www.nathanmanousos.com/.   

forked the template here (https://github.com/chints98/imba-builder), with the goal of trying to extend it out into rendering markdown files as blogs, and maybe include dynamic routes taking advantage of some of the ssr features. 

I have pushed some initial changes that I worked on while updating my product design portfolio, including enabling nested routing and a dev mode (nodemon, build and serve script watching for file changes) to improve the overall experience. Not sure where I want to extend this, potentially building on this prototype to serve as a minimal static site building template for imba? Connecting with a cms? Layouts / templates? 

# Original README

Original repository: https://github.com/trafnar/imba-builder

Prototype static site builder for imba with SSR and hydration.

- Add pages to the `pages/` directory (each page needs to default export a tag)
- Run `npm run build` to build the site into the `dist/` directory
- Use `npm run serve` to serve the dist directory
- An HTML template is defined within the build script, `build.imba`

Problems:

- To get the CSS file, I have a weird technique of running `vite build` which builds a file called `compound.imba` which includes all pages within it, this way it creates a CSS file with all pages' CSS in it. Not sure how else to do it.

Todo:

- Better layout system
- Development mode
- Posts concept
- ...
