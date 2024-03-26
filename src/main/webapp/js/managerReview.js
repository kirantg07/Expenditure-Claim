//==================================================
// Create a new Date object
var cDate = new Date();

// Define arrays for months and days
var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

// Get day, month, year, hours, minutes, and seconds
//var day = days[currentDate.getDay()];
var datee = cDate.getDate();
var month = months[cDate.getMonth()];
var year = cDate.getFullYear();
var hours = cDate.getHours();
var minutes = cDate.getMinutes();
var seconds = cDate.getSeconds();

// Pad seconds with leading zero if necessary
seconds = seconds < 10 ? "0" + seconds : seconds;
// Formatting the date
var formattedDatee = datee + '-' + month + '-' + year + ' ' + hours + ':' + minutes + ':' + seconds;

// Display the formatted date
console.log("formatted date is " + formattedDatee);
//==================================================

var tableData = [];
function approveAll() {
    // Show confirmation alert
    
    const confirmed = confirm("Do you want to approve all?");

    if (confirmed) {
        const tableRows = document.querySelectorAll('.ManagerContainer table tbody tr');

        tableRows.forEach(row => {
            const managerApprovalDropdown = row.querySelector("#managerApprovalDropdown");
            // Update the dropdown value to 'Approved'
            managerApprovalDropdown.value = 'Approved';
        });

        
     
    } else {
        // Do nothing if user cancels the confirmation
    }
}



function displayErrorMessage(message) {
	const errorMessageElement = document.getElementById('failed');
	errorMessageElement.innerText = message;
	errorMessageElement.style.display = 'block';

	setTimeout(() => {
		errorMessageElement.style.display = 'none';
	}, 3000);
}

function submit() {
	const tableRows = document.querySelectorAll('.ManagerContainer table tbody tr');

	// Reset tableData before populating it
	tableData = [];

	tableRows.forEach((row, index) => {

		const particulars = row.querySelector("#particulars").innerHTML;
		const billNo = row.querySelector("#bno").innerHTML;
		const billDate = row.querySelector("#billDate").innerHTML;
		const amount = row.querySelector("#amount").innerHTML;
		/* const uploadBill = row.querySelector("#uploadBill").innerHTML;*/
		// const managerApprovalElement = row.querySelector("#managerApproval");
		//const managerApproval = managerApprovalElement.options[managerApprovalElement.selectedIndex].value;
		const managerApprovalHidden = row.querySelector("#managerApprovalHidden").value;
		const managerApprovalElement = row.querySelector("#managerApprovalDropdown");
		const managerApproval = managerApprovalElement ? managerApprovalElement.value : 'N/A';
		const managerRemarks = row.querySelector("#managerRemarks").value;
		const name = row.querySelector("#fn").innerHTML;
		const id = row.querySelector("#empId").value;
		const empCodeNo = row.querySelector("#empCodeNo").value;
		const updatedDate = row.querySelector("#updatedDate").value;

		console.log("Manager approval decision is " + managerApproval);

		tableData.push({

			billNo: billNo,
			managerRemarks: managerRemarks,
			managerApproval: (managerApproval === "select") ? managerApprovalHidden : managerApproval,
			name: name,
			id: id,
			updatedDate: (managerApproval === "select") ? updatedDate : formattedDatee,
			empCodeNo: empCodeNo
		});

	});

	if (tableData.length > 0) {
		console.log("testing....");
		fetch('SubmitActionManager', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/json',
			},
			body: JSON.stringify(tableData),
		})
			.then(response => response.json())
			.then(data => {
				if (data.success) {

					document.getElementById('success').innerText = "Submitted successfully";
					document.getElementById('success').style.display = 'block';
					document.getElementById('failed').style.display = 'none'; // Hide the error message
					// Redirect after 3 seconds
					setTimeout(() => {
						window.location.href = 'DemoManager?pageType=managerReview';
					}, 2000);
				} else {
					displayErrorMessage(data.message);
				}
				//console.log('Data submitted successfully:', data);
			})
			.catch(error => {
				console.error('Error submitting data to the server:', error);
			});
	} else {
		console.log('Data submission failed. Please check the form.');
	}
}




function sortAction() {
	console.log("Sort function is called");
	var sortSelectionRes = document.getElementById("sortSelectionOption").value;
	if (sortSelectionRes === "1") {
		console.log("Latest action is being called");
		window.location.href = "DemoManager?pageType=managerReview";
		
	} else {
		window.location.href = "SortAmount?pageType=managerReview";
		console.log("Sort through is called");
	}

}

document.querySelector('#a_background').addEventListener("change", function() {

	if (this.value == "1") {
		console.log("Latest action is being called");
		window.location.href = "DemoManager?pageType=managerReview";
	} else if (this.value == "2") {
		window.location.href = "SortAmount?pageType=managerReview";
		console.log("Sort through is called");
	}
});


//Intial threshold values to the date inputs
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

//Filtering the data
function filterTable() {
	const fullName = document.getElementById("fullName").value.toLowerCase(); // Convert name to lowercase for case-insensitive matching
	const fromDateStr = document.getElementById("fromDate").value;
	const toDateStr = document.getElementById("toDate").value;
	const amountValidationString = document.getElementById("amountValidation").value;
	const amountValidation = parseFloat(amountValidationString.replace(",", ""));

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

		// Check if the month abbreviation is valid
		if (!month) {
			console.error("Invalid month abbreviation:", monthAbbreviationing);
			return;
		}

		// Format the date as yyyy-mm-dd
		/*  const billDate = `${yearBillingDate}-${monthBillingDate}-${dayBillingDate}`; */
		const RetrievedBillingDate = yearBillingDate + "-" + monthBillingDate + "-" + dayBillingDate;
		console.log("Retrieved bill date is " + RetrievedBillingDate);

		const billDate = new Date(yearBillingDate, monthBillingDate - 1, dayBillingDate);
		console.log("billDate is " + billDate);

		//============================================================


		const name = row.querySelector("#fn").innerHTML.toLowerCase(); // Convert name to lowercase for case-insensitive matching
		/* const amount = parseFloat(row.querySelector("#amount").innerHTML); */ // Parse amount to float

		const amountString = row.querySelector("#amount").innerHTML; // Assuming innerHTML contains "25,500"
		const amount = parseFloat(amountString.replace(",", ""));
		/* console.log(amount); */ // Output: 25500

		// Check if either dates are empty or bill date falls within the specified range
		const isDateInRange = !fromDate || !toDate || (billDate >= fromDate && billDate <= toDate);

		// Check if fullName is empty or name contains the provided fullName
		const isNameMatched = fullName === "" || name.includes(fullName);

		// Check if amountValidation is empty or amount is equal or above the provided amountValidation
		const isAmountMatched = isNaN(amountValidation) || amount >= amountValidation;

		// Show the row if all conditions are satisfied, otherwise hide it
		row.style.display = (isDateInRange && isNameMatched && isAmountMatched) ? "" : "none";
	});
}



// Initial call to set the initial date limits
updateDateLimits();

//when clicked on reset button , the page is refreshed
function refreshPage() {
	window.location.reload();
}

/*  function refreshPage() {
	 window.location.href = "DemoManager?pageType=managerReview";
 } */

function sortedDataFunction() {
	var managerApproval = document.getElementById("managerApprovalFilter").value;
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


