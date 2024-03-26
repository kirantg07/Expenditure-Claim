const navLinks = document.querySelectorAll('nav a.nav-link');

// Add click event listener to each anchor tag
navLinks.forEach(link => {
	link.addEventListener('click', function() {
		// Remove 'active' class from all anchor tags
		navLinks.forEach(link => {
			link.classList.remove('active');
		});
		// Add 'active' class to the clicked anchor tag
		this.classList.add('active');
	});
});

function setActiveLink() {
	var links = document.querySelectorAll('nav a');
	var currentPage = location.pathname.split('/').pop();

	links.forEach(function(link) {
		var href = link.getAttribute('href').split('/').pop();
		if (href === currentPage) {
			link.classList.add('active');
		} else {
			link.classList.remove('active');
		}
	});
}

window.onload = setActiveLink;