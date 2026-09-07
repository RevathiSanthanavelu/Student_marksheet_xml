// ==================================================
// DROPDOWN FILTER
// ==================================================

function filterStudents() {

    var selectedId =
        document.getElementById("studentSelect").value;

    var rows =
        document.getElementsByClassName("student-row");

    for (var i = 0; i < rows.length; i++) {

        var row = rows[i];

        if (selectedId === "all") {

            row.style.display = "";

        } else if (
            row.getAttribute("data-student-id") === selectedId
        ) {

            row.style.display = "";

        } else {

            row.style.display = "none";

        }
    }
}


// ==================================================
// ADD STUDENT
// ==================================================

document
    .getElementById("addStudentForm")
    .addEventListener("submit", function(event) {

        event.preventDefault();

        var form =
            document.getElementById("addStudentForm");

        var formData =
            new FormData(form);

        fetch("/addStudent", {
            method: "POST",
            body: new URLSearchParams(formData)
        })

        .then(function(response) {
            return response.text();
        })

        .then(function(message) {

            document.getElementById("message")
                .textContent = message;

            if (
                message ===
                "Student added successfully!"
            ) {

                form.reset();

                setTimeout(function() {
                    location.reload();
                }, 500);
            }

        })

        .catch(function(error) {

            document.getElementById("message")
                .textContent =
                "Error adding student.";

            console.error(error);

        });

    });


// ==================================================
// EDIT BUTTONS
// ==================================================

var editButtons =
    document.getElementsByClassName("edit-button");

for (
    var i = 0;
    i < editButtons.length;
    i++
) {

    editButtons[i].addEventListener(
        "click",
        function() {

            var studentId =
                this.getAttribute("data-student-id");

            editStudent(studentId);

        }
    );

}


// ==================================================
// DELETE BUTTONS
// ==================================================

var deleteButtons =
    document.getElementsByClassName("delete-button");

for (
    var i = 0;
    i < deleteButtons.length;
    i++
) {

    deleteButtons[i].addEventListener(
        "click",
        function() {

            var studentId =
                this.getAttribute("data-student-id");

            deleteStudent(studentId);

        }
    );

}


// ==================================================
// EDIT STUDENT
// ==================================================

function editStudent(studentId) {

    var row =
        document.querySelector(
            'tr[data-student-id="' + studentId + '"]'
        );

    if (!row) {
        return;
    }

    if (row.classList.contains("editing")) {
        return;
    }


    var name =
        row.querySelector(
            ".student-name"
        ).textContent.trim();


    var department =
        row.querySelector(
            ".department"
        ).textContent.trim();


    var marks =
        row.querySelector(
            ".marks"
        ).textContent
        .replace("%", "")
        .trim();
    row.classList.add("editing");


    // NAME

    row.querySelector(
        ".student-name"
    ).innerHTML =
        '<input type="text" class="edit-input edit-name"/>';

    row.querySelector(
        ".edit-name"
    ).value = name;


    // DEPARTMENT

    row.querySelector(
        ".department"
    ).innerHTML =
        '<input type="text" class="edit-input edit-department"/>';

    row.querySelector(
        ".edit-department"
    ).value = department;


    // MARKS

    row.querySelector(
        ".marks"
    ).innerHTML =
        '<input type="number" class="edit-input edit-marks" min="0" max="100"/>';

    row.querySelector(
        ".edit-marks"
    ).value = marks;


    // ACTION BUTTONS

    row.querySelector(
        ".actions"
    ).innerHTML =
        '<button type="button" class="icon-button save-button" title="Save">💾</button>' +

        '<button type="button" class="icon-button cancel-button" title="Cancel">❌</button>';


    // SAVE

    row.querySelector(
        ".save-button"
    ).addEventListener(
        "click",
        function() {

            saveStudent(studentId);

        }
    );


    // CANCEL

    row.querySelector(
        ".cancel-button"
    ).addEventListener(
        "click",
        function() {

            location.reload();

        }
    );

}


// ==================================================
// SAVE STUDENT
// ==================================================

function saveStudent(studentId) {

    var row =
        document.querySelector(
            'tr[data-student-id="' + studentId + '"]'
        );

    if (!row) {
        return;
    }


    var name =
        row.querySelector(
            ".edit-name"
        ).value.trim();


    var department =
        row.querySelector(
            ".edit-department"
        ).value.trim();


    var marks =
        row.querySelector(
            ".edit-marks"
        ).value.trim();


    // VALIDATION

    if (
        !name ||
        !department ||
        !marks
    ) {

        alert("All fields are required.");

        return;
    }


    var marksNumber =
        parseInt(marks);


    if (
        isNaN(marksNumber) ||
        marksNumber < 0 ||
        marksNumber > 100
    ) {

        alert(
            "Marks must be between 0 and 100."
        );

        return;
    }


    var formData =
        new URLSearchParams();


    formData.append(
        "id",
        studentId
    );

    formData.append(
        "name",
        name
    );

    formData.append(
        "department",
        department
    );

    formData.append(
        "marks",
        marksNumber
    );


    fetch(
        "/updateStudent",
        {
            method: "POST",
            body: formData
        }
    )

    .then(function(response) {

        return response.text();

    })

    .then(function(message) {

        if (
            message ===
            "Student updated successfully!"
        ) {

            alert(message);

            location.reload();

        } else {

            alert(message);

        }

    })

    .catch(function(error) {

        console.error(error);

        alert(
            "Error updating student."
        );

    });

}


// ==================================================
// DELETE STUDENT
// ==================================================

function deleteStudent(studentId) {

    var confirmed =
        confirm(
            "Are you sure you want to delete Student ID " +
            studentId +
            "?"
        );


    if (!confirmed) {
        return;
    }


    var formData =
        new URLSearchParams();


    formData.append(
        "id",
        studentId
    );


    fetch(
        "/deleteStudent",
        {
            method: "POST",
            body: formData
        }
    )

    .then(function(response) {

        return response.text();

    })

    .then(function(message) {

        if (
            message ===
            "Student deleted successfully!"
        ) {

            alert(message);

            location.reload();

        } else {

            alert(message);

        }

    })

    .catch(function(error) {

        console.error(error);

        alert(
            "Error deleting student."
        );

    });

}