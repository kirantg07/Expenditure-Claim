document.addEventListener('DOMContentLoaded', function() {
	// Get the email parameter from the URL
	const urlParams = new URLSearchParams(window.location.search);
	const emailParam = urlParams.get('emailid');

	// Check if the email parameter is present
	if (emailParam) {
		// Set the email value in the input field
		document.getElementById('loginEmail').value = decodeURIComponent(emailParam);
	}

	document.getElementById("loginform").addEventListener("submit", function(event) {
		event.preventDefault();

		const email = document.getElementById('loginEmail').value;
		const password = document.getElementById('loginPassword').value;

		fetch('LoginAction', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded',
			},
			body: `email=${encodeURIComponent(email)}&password=${encodeURIComponent(password)}`,
		})
			.then(response => {
				if (response.redirected) {
					window.location.href = response.url; // Redirect to the provided URL
				} else {
					displayErrorMessage("Invalid username or password.");
				}
			})
			.catch(error => console.error('Error:', error));
	});
});

function displayErrorMessage(message) {
	const errorMessageElement = document.getElementById('errormessage');
	errorMessageElement.innerText = message;
	errorMessageElement.style.display = 'block';

	setTimeout(() => {
		errorMessageElement.style.display = 'none';
	}, 3000);
}