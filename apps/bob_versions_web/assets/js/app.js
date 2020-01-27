// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import "../css/app.sass"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

// Bulma Navbar


// Get all "navbar-burger" elements
const navbarBurgers = Array.from(document.querySelectorAll('.navbar-burger'));

// Add a click event on each of them
navbarBurgers.forEach(el => {
	el.addEventListener('click', () => {
		const target = document.getElementById(el.dataset.target);
		// Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
		el.classList.toggle('is-active');
		target.classList.toggle('is-active');
	});
});