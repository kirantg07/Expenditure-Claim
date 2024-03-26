function solve() {
	var emailInput = document.getElementById("email");
	var passwordInput = document.getElementById("password");
	var confirmPasswordInput = document.getElementById("repassword");

	// Validate email format
	var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	if (!emailRegex.test(emailInput.value)) {
		displayErrorMessage("Please enter a valid email address.");
		setTimeout(() => {
			errorMessageElement.style.display = 'none';
		}, 3000);
		return;  // Stop further execution if email is invalid
	}

	// Validate password format
	var passwordRegex = /^[0-9]{6}$/;
	if (!passwordRegex.test(passwordInput.value)) {
		displayErrorMessage("Invalid Password, Password must contain 6 digits.");
		setTimeout(() => {
			errorMessageElement.style.display = 'none';
		}, 3000);
		return;  // Stop further execution if password is invalid

	}

	// Validate password and confirm password match
	if (passwordInput.value !== confirmPasswordInput.value) {
		displayErrorMessage("Passwords do not match.");
		setTimeout(() => {
			errorMessageElement.style.display = 'none';
		}, 3000);
		return;  // Stop further execution if passwords don't match
	}

	// If all validations pass, submit the form
	registerUser();
}

function registerUser() {
	var emailInput = document.getElementById("email").value;
	var passwordInput = document.getElementById("password").value;
	var fullnameInput = document.getElementById("fn").value;
	var designationInput = document.getElementById("designation").value;
	var regionInput = document.getElementById("region").value;
	var reportingMInput = document.getElementById("travelPlan").value;
	var employeeCodeInput = document.getElementById("EC").value;

	fetch('RegisterAction', {
		method: 'POST',
		headers: {
			'Content-Type': 'application/x-www-form-urlencoded',
		},
		body: `email=${encodeURIComponent(emailInput)}&password=${encodeURIComponent(passwordInput)}&fn=${encodeURIComponent(fullnameInput)}&designation=${encodeURIComponent(designationInput)}&region=${encodeURIComponent(regionInput)}&travelPlan=${encodeURIComponent(reportingMInput)}&EC=${encodeURIComponent(employeeCodeInput)}`,
	})
		.then(response => response.json())
		.then(data => {
			if (data.success) {
				document.getElementById('registered').style.display = 'block';
				document.getElementById('errormessage').style.display = 'none'; // Hide the error message
				// Redirect after 3 seconds
				setTimeout(() => {
					window.location.href = 'login.jsp';
				}, 2000);
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
	}, 3000);
}

document.getElementById('registrationForm').addEventListener('submit', function(event) {
	event.preventDefault();
	solve();  // Call the solve function when the form is submitted
});


			window.onload = function() {
				var urlParams = new URLSearchParams(window.location.search);
				var errorMessage = urlParams.get('error');

				if (errorMessage && errorMessage.length > 0) {
					displayErrorMessage(errorMessage);

				}
			};
			
			
			

  // Function to fetch data from JSON file
  function fetchDesignations() {
    fetch('designation.json')
      .then(response => response.json())
      .then(data => {
        const dropdown = document.getElementById('designation');
        data.forEach(designation => {
          const option = document.createElement('option');
          option.value = designation;
          option.text = designation;
          dropdown.appendChild(option);
        });
      })
      .catch(error => console.error('Error fetching designations:', error));
  }

  // Call the fetchDesignations function when the page loads
  document.addEventListener('DOMContentLoaded', fetchDesignations);
