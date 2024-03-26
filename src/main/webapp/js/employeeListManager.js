
window.onload = function() {
    var xhr = new XMLHttpRequest();
    xhr.open("POST", "ReportingManagerOptionServlet", true);
    xhr.onreadystatechange = function() {
        if (xhr.readyState == 4 && xhr.status == 200) {
            var selectElements = document.querySelectorAll("tr td #reportingManager");
            selectElements.forEach(function(selectElement, index) {
                var nameArr = xhr.responseText.split(/\s*,\s*/);
                var htmlCode = '<option value="" disabled selected>Select Reporting Manager</option>'; // Initialize htmlCode here
                var initialAssignedValue = selectElement.closest('tr').querySelector('#reportingManager').value; // Get the initially assigned value
                var htmlCode = '<option value="' + initialAssignedValue + '" selected >' + initialAssignedValue + '</option>'; // Set initial assigned value as first option
                for (var i = 0; i < nameArr.length; i++) {
                    var trimmedName = nameArr[i].trim();
                    	if (trimmedName !== "" && trimmedName !== selectElement.closest('tr').querySelector('#userName').textContent.trim() && trimmedName !== initialAssignedValue) {
						htmlCode += "<option value=" + trimmedName + ">" + trimmedName + "</option>";
					}
                }
                selectElement.innerHTML = htmlCode; // Set the dropdown options
            });
        }
    };
    xhr.send();
};

