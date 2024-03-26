var tableData = [];

var today = new Date();
var dd = String(today.getDate()).padStart(2, '0');
var mm = String(today.getMonth() + 1).padStart(2, '0');
var year = today.getFullYear();

const settledDate = dd + "-" + mm + "-" + year;

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
function approveAll() {
    // Show confirmation alert
    const confirmed = confirm("Do you want to approve all?");

    if (confirmed) {
        const tableRows = document.querySelectorAll('.financeContainer table tbody tr');

        tableRows.forEach(row => {
            const managerApprovalDropdown = row.querySelector("#finaceApprovalDropdown");
            // Update the dropdown value to 'Approved'
            managerApprovalDropdown.value = 'Settled';
        });

        
        /*// Redirect after 3 seconds
        setTimeout(() => {
            window.location.href = 'DemoManager?pageType=managerReview';
        }, 2000);*/
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
	const tableRows = document.querySelectorAll('.financeContainer table tbody tr');

	// Reset tableData before populating it
	tableData = [];

	tableRows.forEach((row, index) => {
		/*const slNo = row.querySelector("#slNo").innerHTML;*/
		/*  const slNo = 1;*/
		const particulars = row.querySelector("#particulars").innerHTML;
		const billNo = row.querySelector("#bno").innerHTML;
		const billDate = row.querySelector("#billDate").innerHTML;
		const amount = row.querySelector("#amount").innerHTML;
		const financeApprovalElement = row.querySelector("#finaceApprovalDropdown");
		const finaceApproval = financeApprovalElement ? financeApprovalElement.value : 'N/A';
		const approvedAmount = row.querySelector("#approvedAmount").value;
		const finTeamRemarks = row.querySelector("#finTeamRemarks").value;
		const managerApprovalHidden = row.querySelector("#managerApprovalHidden").value;
		const name = row.querySelector("#fn").innerHTML;
		const id = row.querySelector("#empId").value;
		const updatedDate = row.querySelector("#updatedDate").value;
		console.log("Finance approval decision is " + finaceApproval);

		tableData.push({

			billNo: billNo,
			/* approvedAmount: approvedAmount,*/
			approvedAmount: (finaceApproval === "Settled") ? approvedAmount : "",
			finTeamRemarks: finTeamRemarks,
			managerApproval: (finaceApproval === "select") ? managerApprovalHidden : finaceApproval,
			settledDate: (finaceApproval === "Settled") ? IndianDatee : "",
			paymentReference: (finaceApproval === "accept") ? "Credited" : "-",
			name: name,
			id: id,
			updatedDate: (finaceApproval === "select") ? updatedDate : formattedDatee
		});

	});

	if (tableData.length > 0) {
		console.log("testing....");
		fetch('SubmitActionFinance', {
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
						window.location.href = 'DemoManager?pageType=financeReview';
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

document.querySelector('#a_background').addEventListener("change", function() {

	if (this.value == "1") {
		
		window.location.href = "DemoManager?pageType=financeReview";
	} else if (this.value == "2") {
		window.location.href = "SortAmount?pageType=financeReview";
		
	}
});

