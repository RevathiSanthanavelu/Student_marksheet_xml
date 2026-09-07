<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" encoding="UTF-8" indent="yes"/>

<xsl:template match="/Students">

    <html>
        <head>

            <title>Student Report Card</title>
            <link rel="stylesheet" type="text/css" href="style.css"/>
        </head>

        <body>


            <div class="container">

                <!-- HEADER -->

                <div class="header">

                    <h1>🎓 Student Report Card</h1>

                    <p>
                        Academic Performance Report • 2026
                    </p>

                </div>


                <!-- SUMMARY -->

                <div class="summary">

                    <div class="card">

                        <div class="card-title">
                            Total Students
                        </div>

                        <div class="card-value">
                            <xsl:value-of select="count(Student)"/>
                        </div>

                    </div>


                    <div class="card">

                        <div class="card-title">
                            Passed
                        </div>

                        <div class="card-value pass-value">

                            <xsl:value-of
                                select="count(Student[marks >= 35])"/>

                        </div>

                    </div>


                    <div class="card">

                        <div class="card-title">
                            Failed
                        </div>

                        <div class="card-value fail-value">

                            <xsl:value-of
                                select="count(Student[marks &lt; 35])"/>

                        </div>

                    </div>


                    <div class="card">

                        <div class="card-title">
                            Class Average
                        </div>

                        <div class="card-value average-value">

                            <xsl:value-of
                                select="format-number(sum(Student/marks) div count(Student), '0.00')"/>

                        </div>

                    </div>

                </div>


                <!-- ADD STUDENT -->

                <div class="add-student-section">

                    <h2>Add Student</h2>

                    <form id="addStudentForm">

                        <input
                            type="text"
                            id="studentId"
                            name="id"
                            placeholder="Student ID"
                            required="required"/>

                        <input
                            type="text"
                            id="studentName"
                            name="name"
                            placeholder="Student Name"
                            required="required"/>

                        <input
                            type="text"
                            id="studentDepartment"
                            name="department"
                            placeholder="Department"
                            required="required" />

                        <input
                            type="number"
                            id="studentMarks"
                            name="marks"
                            placeholder="Marks"
                            min="0"
                            max="100"
                            required="required" />

                        <button type="submit">
                            Add Student
                        </button>

                    </form>

                    <p id="message"></p>

                </div>



                <!-- STUDENT DROPDOWN -->

                <div class="student-selector">

                    <label for="studentSelect">
                        Select Student
                    </label>

                    <select id="studentSelect" onchange="filterStudents()">

                        <option value="all">
                            All Students
                        </option>

                        <xsl:for-each select="Student">

                            <option value="{@id}">
                                <xsl:value-of select="name"/>
                            </option>

                        </xsl:for-each>

                    </select>

                </div>


                <!-- TOPPER -->

                <xsl:for-each select="Student">

                    <xsl:sort
                        select="marks"
                        data-type="number"
                        order="descending"/>

                    <xsl:if test="position() = 1">

                        <div class="topper">

                            <div>

                                <div class="topper-title">
                                    🏆 Top Performer
                                </div>

                                <div class="topper-name">
                                    <xsl:value-of select="name"/>
                                </div>

                                <div>
                                    <xsl:value-of select="department"/>
                                    • Student ID:
                                    <xsl:value-of select="@id"/>
                                </div>

                            </div>

                            <div class="topper-mark">
                                <xsl:value-of select="marks"/>%
                            </div>

                        </div>

                    </xsl:if>

                </xsl:for-each>


                <!-- ALL STUDENT TABLE -->

                <div class="table-card">

                    <table>

                        <thead>

                            <tr>

                                <th>ID</th>
                                <th>Name</th>
                                <th>Department</th>
                                <th>Marks</th>
                                <th>Grade</th>
                                <th>Status</th>
                                <th>Actions</th>

                            </tr>

                        </thead>


                        <tbody>

                            <!-- SORT STUDENTS BY NAME -->

                            <xsl:for-each select="Student">

                                <xsl:sort
                                    select="name"
                                    data-type="text"
                                    order="ascending"/>

                                <tr class="student-row" data-student-id="{@id}">

                                    <td class="student-id">
                                        #
                                        <xsl:value-of select="@id"/>
                                    </td>

                                    <td class="student-name">
                                        <xsl:value-of select="name"/>
                                    </td>

                                    <td class="department">
                                        <xsl:value-of select="department"/>
                                    </td>

                                    <td class="marks">
                                        <xsl:value-of select="marks"/>%
                                    </td>


                                    <!-- GRADE -->

                                    <td>

                                        <xsl:choose>

                                            <xsl:when test="marks &gt;= 90">
                                                <span class="grade grade-a">
                                                    Grade A
                                                </span>
                                            </xsl:when>

                                            <xsl:when test="marks &gt;= 70">
                                                <span class="grade grade-b">
                                                    Grade B
                                                </span>
                                            </xsl:when>

                                            <xsl:when test="marks &gt;= 50">
                                                <span class="grade grade-c">
                                                    Grade C
                                                </span>
                                            </xsl:when>

                                            <xsl:when test="marks &gt;= 35">
                                                <span class="grade grade-d">
                                                    Grade D
                                                </span>
                                            </xsl:when>

                                            <xsl:otherwise>
                                                <span class="grade grade-f">
                                                    Fail
                                                </span>
                                            </xsl:otherwise>

                                        </xsl:choose>

                                    </td>


                                    <!-- STATUS -->

                                    <td>

                                        <xsl:choose>

                                            <xsl:when test="marks &gt;= 35">

                                                <span class="status pass">
                                                    ✓ Pass
                                                </span>

                                            </xsl:when>

                                            <xsl:otherwise>

                                                <span class="status fail">
                                                    ✕ Fail
                                                </span>

                                            </xsl:otherwise>

                                        </xsl:choose>

                                    </td>

                                    <!-- ACTION -->

                                    <td class="actions">

                                        <button
                                            type="button"
                                            class="icon-button edit-button"
                                            data-student-id="{@id}"
                                            title="Edit Student">
                                            ✏️
                                        </button>

                                        <button
                                            type="button"
                                            class="icon-button delete-button"
                                            data-student-id="{@id}"
                                            title="Delete Student">
                                            🗑️
                                        </button>

                                    </td>

                                </tr>

                            </xsl:for-each>

                        </tbody>

                    </table>

                </div>


                <!-- FOOTER -->

                <div class="footer">

                    Generated Student Performance Report • 2026

                </div>

            </div>

<script type="text/javascript"><![CDATA[

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

]]></script>



        </body>

    </html>

</xsl:template>
</xsl:stylesheet>