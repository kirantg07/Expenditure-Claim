// To set the threshold for date input
function updateDateLimits() {
	const fromDateInput = document.getElementById("fromDate");
	const toDateInput = document.getElementById("toDate");

	// Set the fromDate to the maximum date of today
	const currentDate = new Date();
	fromDateInput.max = currentDate.toISOString().split('T')[0];

	// Set the toDate max attribute to the current date
	toDateInput.max = currentDate.toISOString().split('T')[0];

	// If fromDate is today, set toDate to only allow selecting today
	if (fromDateInput.value === currentDate.toISOString().split('T')[0]) {
		toDateInput.min = fromDateInput.value;
		toDateInput.max = fromDateInput.value;
	} else {
		toDateInput.min = fromDateInput.value;
	}
}

//Filter function
function filterTable() {
	const fullName = document.getElementById("fullName").value.toLowerCase(); // Convert name to lowercase for case-insensitive matching
	const fromDateStr = document.getElementById("fromDate").value;
	const toDateStr = document.getElementById("toDate").value;

	// Parse the dates in dd-mm-yyyy format if they are not empty
	let fromDate, toDate;
	if (fromDateStr && toDateStr) {
		const fromDateParts = fromDateStr.split("-");
		const toDateParts = toDateStr.split("-");
		fromDate = new Date(fromDateParts[0], fromDateParts[1] - 1, fromDateParts[2]);
		toDate = new Date(toDateParts[0], toDateParts[1] - 1, toDateParts[2]);

		// Check if the dates are valid
		if (isNaN(fromDate) || isNaN(toDate) || fromDate > toDate) {
			alert("Please enter valid dates");
			return;
		}
	}

	const tableRows = document.querySelectorAll('.ManagerContainer table tbody tr');

	tableRows.forEach((row) => {
		const billDateStr = row.querySelector("#billDate").innerHTML;
		const billDateParts = billDateStr.split("-");
		//===========================================================================
		// Define an array to map month abbreviations to numbers
		const monthsMaping = {
			'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04', 'May': '05', 'Jun': '06',
			'Jul': '07', 'Aug': '08', 'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'
		};

		// Split the bill date string into parts
		const datePartition = billDateStr.split("-");

		// Check if the date format is correct
		if (datePartition.length !== 3) {
			console.error("Invalid date format:", billDateStr);
			return;
		}

		// Extract day, month, and year parts
		const dayBillingDate = datePartition[0];
		const monthAbbreviationing = datePartition[1];
		const yearBillingDate = datePartition[2];

		// Convert month abbreviation to number
		const monthBillingDate = monthsMaping[monthAbbreviationing];
		const RetrievedBillingDate = yearBillingDate + "-" + monthBillingDate + "-" + dayBillingDate;
		

		const billDate = new Date(yearBillingDate, monthBillingDate - 1, dayBillingDate);
		

		//============================================================
		const name = row.querySelector("#fn").innerHTML.toLowerCase(); // Convert name to lowercase for case-insensitive matching

		// Check if either dates are empty or bill date falls within the specified range
		const isDateInRange = !fromDate || !toDate || (billDate >= fromDate && billDate <= toDate);

		// Check if fullName is empty or name contains the provided fullName
		const isNameMatched = fullName === "" || name.includes(fullName);

		// Show the row if both conditions are satisfied, otherwise hide it
		row.style.display = (isDateInRange && isNameMatched) ? "" : "none";
	});
}


// Initial call to set the initial date limits
updateDateLimits();

// On clicking on the reset button the page will be refreshed
function refreshPage() {
	window.location.reload();
}


//Get the modal
var modal = document.getElementById("myModal");

// Get the close button
var closeBtn = document.getElementsByClassName("closee")[0];

// Get the image and insert it inside the modal - use its "alt" text as a caption
var modalImg = document.getElementById("img01");
var captionText = document.getElementById("caption");

// Get all elements with class="view-bill"
var viewBillLinks = document.getElementsByClassName("view-bill");

// Loop through all elements and add the click event listener
for (var i = 0; i < viewBillLinks.length; i++) {
	viewBillLinks[i].onclick = function() {
		modal.style.display = "block"; // Display the modal

		// Extract the image URL from the href attribute of the clicked link
		var imageUrl = this.getAttribute("href");

		// Set the src attribute of the modal image
		modalImg.src = imageUrl;

		// Prevent the default behavior of the link (opening in a new tab/window)
		return false;
	}
}

// When the user clicks on the close button, close the modal
closeBtn.onclick = function() {
	modal.style.display = "none";
}

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
	if (event.target == modal) {
		modal.style.display = "none";
	}
}
