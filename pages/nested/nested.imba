import Nav from "../../components/nav.imba"

export default tag NestedPage
	<self>
		<Nav>
		<div[bgc:green5]>
			<h1[c:white]> "This is a nested route"
			<ul>
				<li> "Nested route via a subfolder"
				<li> "pages/your-folder/page.html"
			<CounterNew>

tag CounterNew
	prop count = 0
	def mount
		log 'mounted counter'
	<self>
		css bgc:gray2
		'this is counter'
		<button @click=(count++)> "count is {count}"