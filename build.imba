const fs = require("fs-extra")
const childProcess = require("child_process")
const exec = require("util").promisify(childProcess.exec)

const pages = import.meta.glob("./pages/**/*.imba", {eager: true})

# This function defines an html page layout, it accepts a function which
# returns the page content (usually a single custom tag)
export def layout pageContent, stylesheet, javascript
	<html lang="en">
		<head>
			<title> "Cool App"
			<style src=stylesheet>
			<script type="module" src=javascript>
		<body>
			<pageContent()>


# run imba build command on the page file (this is necessary to generate css from that file)
# this is run on compound.imba, which is a page that includes all pages, so that the CSS includes everything needed
def imbaBuildToGetStylesheet
	console.log 'running imba build to get stylesheet'
	# await exec "imba build --web --no-minify --no-sourcemap --esbuild --base './' {__dirname}/compound.imba"

	# this vite build relies on specific directory structure, src/index.js and a root level index.html
	# since this exists only to generate a css file, i'd like to stick that all somewhere but i'm not sure how to configure vite build
	await exec "vite build --manifest"
	return "./{__dirname}/dist/"

# from the generated manifest in imbaBuildToGetStylesheet, use the manifest to get the path to the CSS file
def getCssJsPathsFromManifest
	console.log 'getting css and js paths from manifest'
	# read the manifest to get the path to the CSS file
	const data = fs.readFileSync "{__dirname}/dist/manifest.json"	
	const manifest = JSON.parse(data)
	const stylesheetPath = manifest["index.css"].file

	# Try to get the JS entry from "index.js"; if it doesn't exist, fall back to "index.html" only if it ends with ".js". This fixes the 'counter component' not appearing on a nested page.
	let javascriptPath = ""
	if manifest["index.js"]
		javascriptPath = manifest["index.js"].file
	else if manifest["index.html"] and manifest["index.html"].file.endsWith(".js")
		javascriptPath = manifest["index.html"].file

	# Ensure the paths are absolute by prepending a slash if missing
	let absStylesheetPath = stylesheetPath[0] == '/' ? stylesheetPath : "/" + stylesheetPath
	let absJavascriptPath = ""
	if javascriptPath
		absJavascriptPath = javascriptPath[0] == '/' ? javascriptPath : "/" + javascriptPath

	console.log { stylesheetPath: absStylesheetPath, javascriptPath: absJavascriptPath }
	return { stylesheetPath: absStylesheetPath, javascriptPath: absJavascriptPath }

# given a page tag, stick it in the layout, and add the stylesheet path
def assemblePageInLayout page, stylesheetPath, javascriptPath
	console.log 'assembling page in layout'
	# use the CSS file to build the page content layout
	return layout((do page), stylesheetPath, javascriptPath)

# SSR a page tag and write it to a file
def writeSSRPage page, filename
	console.log 'writing ssr page'
	# SSR the html template and index.html into the dist folder
	const directory = "{__dirname}/dist"
	const fullPath = "{directory}/{filename}"
	if await fs.pathExists(directory)
		fs.outputFile fullPath, String(page)
		return fullPath

# given pages in the form {filename: "index.html", tagInstance: <HomePage>}, build them and write them
def buildPages pages = []
	await imbaBuildToGetStylesheet()
	const { stylesheetPath, javascriptPath } = getCssJsPathsFromManifest()
	for page in pages
		console.log "Building page: {page.filename}"
		const pageInLayout = assemblePageInLayout(page.tagInstance, stylesheetPath, javascriptPath)
		writeSSRPage(pageInLayout, page.filename)


const pageList = Object.keys(pages).map do(key)
	const filename = key.replace("./pages/", "").replace(".imba", ".html")
	const tagInstance = pages[key].default
	return {filename, tagInstance}

buildPages(pageList)
