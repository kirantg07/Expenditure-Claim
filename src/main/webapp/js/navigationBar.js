
const profilePic = document.querySelector(".profilePic");
const profile = document.querySelector(".profile");

// Function to close profile div when clicked outside
function closeProfileOnClickOutside(event) {
    if (!profile.contains(event.target) && event.target !== profilePic) {
        profile.style.display = "none";
        document.removeEventListener("click", closeProfileOnClickOutside);
    }
}

profilePic.addEventListener("click", () => {
    if (profile.style.display === "none" || profile.style.display === "" || profile.style.left === "-100%") {
        profile.style.display = "flex";
        profile.style.display = "0%";
        // Add event listener to close profile on click outside
        document.addEventListener("click", closeProfileOnClickOutside);
    } else {
        profile.style.display = "none";
        profile.style.display = "100%";
        // Remove event listener when profile is closed
        document.removeEventListener("click", closeProfileOnClickOutside);
    }
});



const profileInfoButton = document.querySelector(".profileInfoButton");
const payment = document.querySelector(".payment");
const close = document.querySelector(".close");

profileInfoButton.addEventListener("click", () => {
	payment.style.display = "flex";
});

close.addEventListener("click", () => {
	payment.style.display = "none";
});

// Get all anchor tags within the navigation
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
	var links = document.querySelectorAll('nav a.nav-link');
	var currentPage = window.location.pathname.split('/').pop(); // Get the current page filename

	links.forEach(function(link) {
		var href = link.getAttribute('href');
		var pageType = href.split('?')[0]; // Extract the pageType from the href

		// Compare current page filename with the pageType
		if (pageType === currentPage) {
			link.classList.add('active');
		} else {
			link.classList.remove('active');
		}
	});
}


// Set the active link when the window loads
window.onload = setActiveLink;

