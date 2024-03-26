function solve() {
	var designation = document.getElementById("designation");
	
	var designationRegex = /^[a-zA-Z\s()-]+$/;
	if (!designationRegex.test(designation.value)) {
		displayErrorMessage("Designation can only contain text, spaces, '-', '(', and ')' characters.");
		setTimeout(() => {
			errorMessageElement.style.display = 'none';
		}, 4000);
		return;  // Stop further execution if email is invalid
	}
	// If all validations pass, submit the form
	registerUser();
}

function registerUser() {
	var designation = document.getElementById("designation").value;
	fetch('DesignationAction', {
		method: 'POST',
		headers: {
			'Content-Type': 'application/x-www-form-urlencoded',
		},
		body: `designation=${encodeURIComponent(designation)}`
	})
		.then(response => response.json())
		.then(data => {
			if (data.success) {
				document.getElementById("designation").value="";
				displayErrorMessage(data.message);
			} else {
				displayErrorMessage(data.message);
			}
		})
		.catch(error => console.error('Error:', error));
}

function displayErrorMessage(message) {
	const errorMessageElement = document.getElementById('errormessage');
	errorMessageElement.innerText = message;
	errorMessageElement.style.display = 'block';

	setTimeout(() => {
		errorMessageElement.style.display = 'none';
	}, 4000);
}




window.onload = function() {
	var urlParams = new URLSearchParams(window.location.search);
	var errorMessage = urlParams.get('error');

	if (errorMessage && errorMessage.length > 0) {
		displayErrorMessage(errorMessage);

	}
};