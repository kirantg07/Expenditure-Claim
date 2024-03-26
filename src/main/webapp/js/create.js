document.addEventListener('DOMContentLoaded', function() {
	var inputAmount = document.getElementById('amount');

	// function to Format the initial input
	formatAmountInputs(inputAmount);
});




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


// Convert hours to 12-hour format and determine AM/PM
var am_pm = hours >= 12 ? 'PM' : 'AM';
var hoursIndian = hours % 12;
hoursIndian = hoursIndian ? (hoursIndian < 10 ? "0" + hoursIndian : hoursIndian) : 12; // Handle midnight


// Pad minutes with leading zero 
minutes = minutes < 10 ? "0" + minutes : minutes;


// Formatting the date
var IndianDatee = datee + '-' + month + '-' + year + ' ' + hoursIndian + ':' + minutes + ' ' + am_pm;


//==================================================
var currentDate = new Date().toISOString().split("T")[0]; // Get current date in yyyy-mm-dd format
document.getElementById("billDate").max = currentDate;


function addRow(tableBody) {
	const body = document.getElementById(tableBody);

	let lastRow = body.lastElementChild;
	let cloneRow = lastRow.cloneNode(true);

	// Make the SL NO. field non-editable
	cloneRow.querySelector("#slNo").readOnly = true;

	// Set "Upload Bill" field to empty string in the cloned row
	cloneRow.querySelector("#uploadBill").value = '';
	const amountInput = cloneRow.querySelector("#amount");
	formatAmountInputs(amountInput);
	body.append(cloneRow);



	// Update SL NO. dynamically based on the current number of rows
	updateSLNO();

	// Clean the last row
	cleanLastRow(body.lastElementChild);
}




function updateSLNO() {
	const tableRows = document.querySelectorAll('.container table tbody tr');
	tableRows.forEach((row, index) => {
		row.querySelector("#slNo").value = index + 1;
	});
}

function cleanLastRow(lastRow) {
	let childNodes = lastRow.children;
	childNodes = Array.isArray(childNodes) ? childNodes : Object.values(childNodes);

	childNodes.forEach(item => {
		if (item != lastRow.firstElementChild) {
			if (item.firstElementChild) {
				item.firstElementChild.value = '';
			}
		}
	});
}

function deleteRow(This) {
	const body = This.closest('tbody');
	const rowCount = body.childElementCount;

	if (rowCount === 1) {
		alert("Can't remove this row");
	} else {
		This.closest('tr').remove();
		// Renumber the remaining rows after a row is deleted
		updateSLNO();
	}
}


// Function to format amount using commas
function formatAmountWithCommas(amount) {
	// Convert amount to string and split it into array of characters
	let amountString = amount.toString().split('');
	let formattedAmount = '';

	// Iterate through each character in the amount string
	for (let i = 0; i < amountString.length; i++) {
		// Add comma after every 3 digits from the end, except for the last 3 digits
		if (i > 0 && i % 3 === 0 && i !== amountString.length % 3) {
			formattedAmount = ',' + formattedAmount; // Add comma
		}
		formattedAmount = amountString[amountString.length - 1 - i] + formattedAmount; // Append character
	}

	return formattedAmount;
}



function onSubmit(res) {
	const tableRows = document.querySelectorAll('.container table tbody tr');

	const promises = []; // Array to store promises for each file reader

	tableData = [];
	var duplicateBillNo = [];
	var count = 0;
	var dupliArray = []
	tableRows.forEach((row, index) => {
		validateFields(row);
		const slNo = row.querySelector("#slNo").value;
		const particulars = row.querySelector("#particulars").value;
		const billNo = row.querySelector("#billNo").value;
		if (!duplicateBillNo.includes(billNo))
			duplicateBillNo.push(billNo);
		else {
			count++;
			dupliArray.push(billNo);
		}
		const billDate = row.querySelector("#billDate").value;
		const billDateParts = billDate.split("-");
		const formattedBillDate = billDateParts[2] + "-" + billDateParts[1] + "-" + billDateParts[0];
		//=======================
		const dayBill = billDateParts[2];
		const monthIndex = parseInt(billDateParts[1]) - 1; // Subtract 1 because JavaScript months are zero-based
		const monthAbbreviation = months[monthIndex];
		const yearBill = billDateParts[0];

		const billDateUpdate = dayBill + '-' + monthAbbreviation + '-' + yearBill;
		

		var amount1 = row.querySelector("#amount").value;
		// Get the amount input element
		let amountInput = document.getElementById('amount');
		const amountFormatted = formatAmountWithCommas(amount1);
		const amountFormatted2 = formatCurrency(amount1);
	
		/*const uploadBill = row.querySelector("#uploadBill").value;*/
		const uploadBill = row.querySelector("#uploadBill");
		const id = index + 1;
		const fn = row.querySelector("#name").value;
		const EC = row.querySelector("#EmpCode").value;
		const ApprovingAuthority = row.querySelector("#ApprovingAuthority").value;

		const file = uploadBill.files[0];

		const reader = new FileReader();

		const promise = new Promise((resolve, reject) => {
			reader.addEventListener("load", () => {
				if (validateFields(row)) {
					tableData.push({
						slNo: slNo,
						particulars: particulars,
						billNo: billNo,
						billDate: billDateUpdate,
						/*amount: amount,*/
						amount: amountFormatted2,
						uploadBill: reader.result,
						/*claimedDate: date,*/
						claimedDate: IndianDatee,
						reclaimedDate: '',
						managerRemarks: '',
						managerApproval: res,
						paymentReference: '-',
						id: id,
						name: fn,
						EC: EC,
						"Approving Authority": ApprovingAuthority,
						settledDate: '',
						finTeamRemarks: '',
						approvedAmount: '',
						updatedDate: formattedDatee
					});
					resolve();
				} else {
					reject();
				}
			});
		});

		promises.push(promise);

		reader.readAsDataURL(file);
	});

	Promise.all(promises)
		.then(() => {
			console.log(tableData);
			/*  if (count > 0) {
				  displayErrorMessage("Bill Numbers are duplicate :- " + dupliArray.toString());
				  return;
			  }*/
			console.log(tableData.length);
			if (tableData.length > 0) {
				console.log(tableData);
				fetch('createAction', {
					method: 'POST',
					headers: {
						'Content-Type': 'application/json',
					},
					body: JSON.stringify(tableData),
				})
					.then(response => response.json())
					.then(data => {
						if (data.success) {
							let successMessage;
							if (res === 'Saved') {
								successMessage = 'Saved successfully!';
							} else if (res === 'Submitted') {
								successMessage = 'Submitted successfully!';
							} else {
								successMessage = 'Updated successfully!'; // Default message if res is not 'Saved' or 'Submitted'
							}
							document.getElementById('success').innerText = successMessage;
							document.getElementById('success').style.display = 'block';
							document.getElementById('failed').style.display = 'none'; // Hide the error message
							// Redirect after 3 seconds
							setTimeout(() => {
								window.location.href = 'create.jsp';
							}, 4000);
						} else {
							displayErrorMessage(data.message);
						}
					})
					.catch(error => {
						console.error('Error submitting data to the server:', error);
					});
			} else {
				console.log('Data submission failed. Please check the form.');
			}
		})
		.catch(() => {
			console.error('Error loading file.');
		});
}


function displayErrorMessage(message) {
	const errorMessageElement = document.getElementById('failed');
	errorMessageElement.innerText = message;
	errorMessageElement.style.display = 'block';

	setTimeout(() => {
		errorMessageElement.style.display = 'none';
	}, 6000);
}

function validateFields(row) {
	const slNo = row.querySelector("#slNo").value;
	const particulars = row.querySelector("#particulars").value;
	const billNo = row.querySelector("#billNo").value;
	const billDate = row.querySelector("#billDate").value;
	const amount = row.querySelector("#amount").value;
	const uploadBill = row.querySelector("#uploadBill").value;

	if (slNo === "" || particulars === "" || billNo === "" || billDate === "" || amount === "" || uploadBill === "") {
		alert("All fields are mandatory. Please fill in all the required fields.");
		return;
	}

	return true;
}

// Function to add commas to the number with decimal places
function addCommas(input) {
	// Remove non-digits and add commas
	var parts = input.split('.');
	parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, ',');
	return parts.join('.');
}

// Function to format amount inputs
function formatAmountInputs(input) {
	input.addEventListener('input', function(event) {
		var inputValue = event.target.value;
		var formattedValue = addCommas(inputValue.replace(/[^\d.]/g, ''));
		event.target.value = formattedValue;
	});
}

function formatCurrency(amount1) {
	// Get input value
	/*let value = document.getElementById("amount").value;*/
	let value = amount1;
	// Remove existing formatting
	value = value.replace(/[^\d.]/g, '');

	// Format to Indian currency
	value = parseFloat(value).toLocaleString('en-IN', {
		style: 'currency',
		currency: 'INR'
	});

	// Update input value
	// input = value;

	var resultantAmount = value.substring(1);
	return resultantAmount;
}
