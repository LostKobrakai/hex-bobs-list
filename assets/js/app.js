// Import dependencies
//
import "phoenix_html"
import "./liveview"

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