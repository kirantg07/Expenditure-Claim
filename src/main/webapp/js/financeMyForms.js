// Creating reClaimed date i.e. today's date
var today = new Date();
var dd = String(today.getDate()).padStart(2, '0');
var mm = String(today.getMonth() + 1).padStart(2, '0');
var year = today.getFullYear();

const date = dd + "-" + mm + "-" + year;

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

//==================================================

// Convert hours to 12-hour format and determine AM/PM
var am_pm = hours >= 12 ? 'PM' : 'AM';
var hoursIndian = hours % 12;
hoursIndian = hoursIndian ? (hoursIndian < 10 ? "0" + hoursIndian : hoursIndian) : 12; // Handle midnight

// Pad minutes with leading zero 
minutes = minutes < 10 ? "0" + minutes : minutes;


// Formatting the date
var IndianDatee = datee + '-' + month + '-' + year + ' ' + hoursIndian + ':' + minutes + ' ' + am_pm;


function find() {
	let row = this.closest('tr');
	
	document.getElementById('editForm').style.display = 'block';
	const particulars = row.querySelector("#particulars").innerText;
	const bno = row.querySelector("#bno").innerText;
	const billDate = row.querySelector("#billDate").innerText;
	const amount = row.querySelector("#amount").innerText;
	const id = row.querySelector("#id").value; /********************************** */
	const uBillHidden = row.querySelector("#uBillHidden").value;  /*getting the hidden inputs from the jsp page*/
	
	const managerApproval = row.querySelector("#managerApproval").innerText;
	const claimedDate = row.querySelector("#claimedDate").innerText;
	const viewBillLink = document.getElementById("viewBillLink");
	// Set the href attribute dynamically
	viewBillLink.href = uBillHidden;
	

	//retieving the values for the edit form
	const tableRow = document.querySelector('#editTable tbody tr');

	// Define an array to map month abbreviations to numbers
	const monthsMap = {
		'Jan': '01', 'Feb': '02', 'Mar': '03', 'Apr': '04', 'May': '05', 'Jun': '06',
		'Jul': '07', 'Aug': '08', 'Sep': '09', 'Oct': '10', 'Nov': '11', 'Dec': '12'
	};

	// Split the bill date string into parts
	const datePartss = billDate.split("-");

	// Check if the date format is correct
	if (datePartss.length !== 3) {
		console.error("Invalid date format:", billDate);
		return;
	}

	// Extract day, month, and year parts
	const dayBillDate = datePartss[0];
	const monthAbbreviation = datePartss[1];
	const yearBillDate = datePartss[2];

	// Convert month abbreviation to number
	const monthBillDate = monthsMap[monthAbbreviation];

	// Check if the month abbreviation is valid
	if (!month) {
		console.error("Invalid month abbreviation:", monthAbbreviation);
		return;
	}

	// Format the date as yyyy-mm-dd
	const RetrievedBillDate = `${yearBillDate}-${monthBillDate}-${dayBillDate}`;
	
	tableRow.querySelector("#bDate").value = RetrievedBillDate;
	tableRow.querySelector("#parti").value = particulars;
	tableRow.querySelector("#bNo").value = bno;
	tableRow.querySelector("#amo").value = amount;
	document.querySelector("#formId").value = id;      /********************************** */
	document.querySelector("#billEdit").value = uBillHidden;      /********************************** */
	document.querySelector("#mApproval").value = managerApproval;      /********************************** */
	document.querySelector("#cDate").value = claimedDate;      /********************************** */
}

$(document).on('click', '#editButton', function() {
	$('#profile-picture').hide();
})
$(document).on('click', '.user-profile', function() {
	if (!$('.user-info').is(':visible'))
		$('.user-info').show();
	else
		$('.user-info').hide();
})
function closeEditForm() {
	// Hide the edit form
	document.getElementById('editForm').style.display = 'none';
	$('#profile-picture').show();
}


function update(res) {
	var slNo = "10";
	var particulars = document.getElementById("parti").value;
	var billNo = document.getElementById("bNo").value;
	var billDate = document.getElementById("bDate").value;
	var billDateParts = billDate.split("-");
	var formattedBillDate = billDateParts[2] + "-" + billDateParts[1] + "-" + billDateParts[0];


	const dayBill = billDateParts[2];
	const monthIndex = parseInt(billDateParts[1]) - 1; // Subtract 1 because JavaScript months are zero-based
	const monthAbbreviationParts = months[monthIndex];
	const yearBill = billDateParts[0];

	const billDateUpdate = dayBill + '-' + monthAbbreviationParts + '-' + yearBill;
	
	var amount = document.getElementById("amo").value;
	var uploadBill = document.getElementById("uBill");
	var mApproval = document.getElementById("mApproval").value;
	var cDate = document.getElementById("cDate").value;
	var id = document.getElementById("formId").value;
	var billEdit = document.getElementById("billEdit").value;
	var managerApproval;

	if (mApproval === "Rejected" || mApproval === "Settled" || mApproval === "Modify") {
		managerApproval = "Resubmitted";
	} else if (mApproval === "Saved") {
		managerApproval = "Submitted";
	} else {
		managerApproval = mApproval;
	}


	var claimedDate = (mApproval === "Submitted" || mApproval === "Saved") ? IndianDatee : cDate;


	/*    var managerApproval = (mApproval === "Rejected"  || mApproval === "Settled" ||  mApproval === "Modify") ? "Resubmitted" : mApproval;*/
	var reclaimedDate = (mApproval === "Rejected" || mApproval === "Settled" || mApproval === "Resubmitted" || mApproval === "Modify") ? IndianDatee : "";

	var updatedDate = formattedDatee;


	if (particulars === "" || billDate === "" || amount === "") {
		alert("All fields are mandatory to fill");
		return;
	}

	if (uploadBill.files.length > 0) {
		const file = uploadBill.files[0];
		const reader = new FileReader();

		reader.addEventListener("load", () => {
			const uploadBillData = reader.result;

			fetch('EditUserData', {
				method: 'POST',
				headers: {
					'Content-Type': 'application/x-www-form-urlencoded',
				},
				body: `slNo=${encodeURIComponent(slNo)}&particulars=${encodeURIComponent(particulars)}&billNo=${encodeURIComponent(billNo)}&billDate=${encodeURIComponent(billDateUpdate)}&uploadBill=${encodeURIComponent(uploadBillData)}&managerApproval=${encodeURIComponent(managerApproval)}&reclaimedDate=${encodeURIComponent(reclaimedDate)}&amount=${encodeURIComponent(amount)}&id=${encodeURIComponent(id)}&claimedDate=${encodeURIComponent(claimedDate)}&updatedDate=${encodeURIComponent(updatedDate)}`,
			})
				.then(response => response.json())
				.then(data => {
					if (data.success) {
						document.getElementById('success').style.display = 'block';
						document.getElementById('failed').style.display = 'none';
						setTimeout(() => {
							window.location.href = 'financeMyForms.jsp';
						}, 6000);
					} else {
						displayErrorMessage(data.message);
					}
				})
				.catch(error => console.error('Error:', error));
		});

		reader.readAsDataURL(file);
	} else {
		fetch('EditUserData', {
			method: 'POST',
			headers: {
				'Content-Type': 'application/x-www-form-urlencoded',
			},
			body: `slNo=${encodeURIComponent(slNo)}&particulars=${encodeURIComponent(particulars)}&billNo=${encodeURIComponent(billNo)}&billDate=${encodeURIComponent(billDateUpdate)}&uploadBill=${encodeURIComponent(billEdit)}&managerApproval=${encodeURIComponent(managerApproval)}&reclaimedDate=${encodeURIComponent(reclaimedDate)}&amount=${encodeURIComponent(amount)}&id=${encodeURIComponent(id)}&claimedDate=${encodeURIComponent(claimedDate)}&updatedDate=${encodeURIComponent(updatedDate)}`,
		})
			.then(response => response.json())
			.then(data => {
				if (data.success) {
					document.getElementById('success').style.display = 'block';
					document.getElementById('failed').style.display = 'none';
					setTimeout(() => {
						window.location.href = 'financeMyForms.jsp';
					}, 6000);
				} else {
					displayErrorMessage(data.message);
				}
			})
			.catch(error => console.error('Error:', error));
	}
}




function displayErrorMessage(message) {
	const errorMessageElement = document.getElementById('errormessage');
	errorMessageElement.innerText = message;
	errorMessageElement.style.display = 'block';

	setTimeout(() => {
		errorMessageElement.style.display = 'none';
	}, 3000);
}




function openBillInNewPage(imagePath) {
	// Open a new window/tab with the bill image
	window.open(imagePath, '_blank');
}


const tooltipTrigger = document.getElementById('tooltipTrigger');
const tooltipContent = document.getElementById('tooltipContent');

tooltipTrigger.addEventListener('mouseover', function() {
	tooltipContent.classList.add('active');
});

tooltipTrigger.addEventListener('mouseout', function() {
	tooltipContent.classList.remove('active');
});


function updateDateLimits() {
	const fromDateInput = document.getElementById("fromDate");
	const toDateInput = document.getElementById("toDate");
const bDateInput = document.getElementById("bDate");

	// Set the fromDate to the maximum date of today
	const currentDate = new Date();
	fromDateInput.max = currentDate.toISOString().split('T')[0];
bDateInput.max = currentDate.toISOString().split('T')[0];
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
function filterTable() {
	const fromDateStr = document.getElementById("fromDate").value;
	const toDateStr = document.getElementById("toDate").value;
	var managerApproval = document.getElementById("managerApprovalFilter").value;

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



	// Get all table rows
	var tableRows = document.querySelectorAll('.container table tbody tr');

	// Loop through each row and check if it meets the filter criteria
	tableRows.forEach(function(row) {
		const billDateStr = row.querySelector("#billDate").innerHTML;
		const billDateParts = billDateStr.split("-");
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
		const RetrievedBillingDate = yearBillingDate + "-" + monthBillingDate + "-" + dayBillingDate;
		

		const billDate = new Date(yearBillingDate, monthBillingDate - 1, dayBillingDate);
	
		// Check if the bill date falls within the selected date range
		var isDateInRange = (!fromDate || !toDate || (billDate >= fromDate && billDate <= toDate));

		// Get the manager approval status from the row
		var rowManagerApproval = row.querySelector("#managerApproval").innerHTML;
		// Check if the manager approval status matches the selected filter value, unless "All" is selected
		var isManagerApprovalMatched = (managerApproval === "All" || rowManagerApproval === managerApproval);

		// If either condition is true, display the row; otherwise, hide it
		if (isDateInRange && (managerApproval === "All" || isManagerApprovalMatched)) {
			row.style.display = "";
		} else {
			row.style.display = "none";
		}
	});
}






//Initial call to set the initial date limits
updateDateLimits();



function openBillInNewPage(imagePath) {
	// Open a new window/tab with the bill image
	window.open(imagePath, '_blank');
}

function openImage(imageUrl) {
	window.location.href = imageUrl;
}

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