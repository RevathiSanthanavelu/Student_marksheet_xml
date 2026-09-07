from http.server import HTTPServer, SimpleHTTPRequestHandler
from urllib.parse import parse_qs
from lxml import etree

XML_FILE = "students.xml"


class StudentHandler(SimpleHTTPRequestHandler):

    def send_text_response(self, status, message):
        self.send_response(status)
        self.send_header(
            "Content-Type",
            "text/plain; charset=UTF-8"
        )
        self.end_headers()

        self.wfile.write(
            message.encode("utf-8")
        )


    def do_POST(self):

        try:

            length = int(
                self.headers.get("Content-Length", 0)
            )

            data = self.rfile.read(length).decode("utf-8")

            form = parse_qs(data)

            # ==================================================
            # ADD STUDENT
            # ==================================================

            if self.path == "/addStudent":

                student_id = form.get(
                    "id", [""]
                )[0].strip()

                name = form.get(
                    "name", [""]
                )[0].strip()

                department = form.get(
                    "department", [""]
                )[0].strip()

                marks = form.get(
                    "marks", [""]
                )[0].strip()


                # -----------------------------
                # VALIDATION
                # -----------------------------

                if (
                    not student_id
                    or not name
                    or not department
                    or not marks
                ):

                    self.send_text_response(
                        400,
                        "All fields are required."
                    )

                    return


                try:

                    marks_value = int(marks)

                except ValueError:

                    self.send_text_response(
                        400,
                        "Marks must be a valid number."
                    )

                    return


                if marks_value < 0 or marks_value > 100:

                    self.send_text_response(
                        400,
                        "Marks must be between 0 and 100."
                    )

                    return


                # -----------------------------
                # READ XML
                # -----------------------------

                parser = etree.XMLParser(
                    remove_blank_text=False
                )

                tree = etree.parse(
                    XML_FILE,
                    parser
                )

                root = tree.getroot()


                # -----------------------------
                # CHECK DUPLICATE ID
                # -----------------------------

                for existing_student in root.findall("Student"):

                    if (
                        existing_student.get("id")
                        == student_id
                    ):

                        self.send_text_response(
                            400,
                            "Student ID already exists."
                        )

                        return


                # -----------------------------
                # CREATE STUDENT
                # -----------------------------

                student = etree.SubElement(
                    root,
                    "Student"
                )

                student.set(
                    "id",
                    student_id
                )

                name_element = etree.SubElement(
                    student,
                    "name"
                )

                name_element.text = name


                department_element = etree.SubElement(
                    student,
                    "department"
                )

                department_element.text = department


                marks_element = etree.SubElement(
                    student,
                    "marks"
                )

                marks_element.text = str(
                    marks_value
                )


                # -----------------------------
                # SAVE XML
                # -----------------------------

                tree.write(
                    XML_FILE,
                    encoding="UTF-8",
                    xml_declaration=True,
                    pretty_print=True
                )


                self.send_text_response(
                    200,
                    "Student added successfully!"
                )

                return


            # ==================================================
            # UPDATE STUDENT
            # ==================================================

            elif self.path == "/updateStudent":

                student_id = form.get(
                    "id", [""]
                )[0].strip()

                name = form.get(
                    "name", [""]
                )[0].strip()

                department = form.get(
                    "department", [""]
                )[0].strip()

                marks = form.get(
                    "marks", [""]
                )[0].strip()


                # -----------------------------
                # VALIDATION
                # -----------------------------

                if (
                    not student_id
                    or not name
                    or not department
                    or not marks
                ):

                    self.send_text_response(
                        400,
                        "All fields are required."
                    )

                    return


                try:

                    marks_value = int(marks)

                except ValueError:

                    self.send_text_response(
                        400,
                        "Marks must be a valid number."
                    )

                    return


                if marks_value < 0 or marks_value > 100:

                    self.send_text_response(
                        400,
                        "Marks must be between 0 and 100."
                    )

                    return


                # -----------------------------
                # READ XML
                # -----------------------------

                parser = etree.XMLParser(
                    remove_blank_text=False
                )

                tree = etree.parse(
                    XML_FILE,
                    parser
                )

                root = tree.getroot()


                # -----------------------------
                # FIND STUDENT
                # -----------------------------

                student_found = False

                for student in root.findall("Student"):

                    if student.get("id") == student_id:

                        student_found = True

                        student.find(
                            "name"
                        ).text = name

                        student.find(
                            "department"
                        ).text = department

                        student.find(
                            "marks"
                        ).text = str(
                            marks_value
                        )

                        break


                if not student_found:

                    self.send_text_response(
                        404,
                        "Student not found."
                    )

                    return


                # -----------------------------
                # SAVE XML
                # -----------------------------

                tree.write(
                    XML_FILE,
                    encoding="UTF-8",
                    xml_declaration=True,
                    pretty_print=True
                )


                self.send_text_response(
                    200,
                    "Student updated successfully!"
                )

                return


            # ==================================================
            # DELETE STUDENT
            # ==================================================

            elif self.path == "/deleteStudent":

                student_id = form.get(
                    "id", [""]
                )[0].strip()


                if not student_id:

                    self.send_text_response(
                        400,
                        "Student ID is required."
                    )

                    return


                # -----------------------------
                # READ XML
                # -----------------------------

                parser = etree.XMLParser(
                    remove_blank_text=False
                )

                tree = etree.parse(
                    XML_FILE,
                    parser
                )

                root = tree.getroot()


                # -----------------------------
                # FIND AND DELETE
                # -----------------------------

                student_found = False

                for student in root.findall("Student"):

                    if student.get("id") == student_id:

                        root.remove(student)

                        student_found = True

                        break


                if not student_found:

                    self.send_text_response(
                        404,
                        "Student not found."
                    )

                    return


                # -----------------------------
                # SAVE XML
                # -----------------------------
                
                tree.write(
                    XML_FILE,
                    encoding="UTF-8",
                    xml_declaration=True,
                    pretty_print=True
                )


                self.send_text_response(
                    200,
                    "Student deleted successfully!"
                )

                return


            # ==================================================
            # UNKNOWN POST URL
            # ==================================================

            else:

                self.send_error(404)

                return


        except Exception as e:

            print("ERROR:", e)

            self.send_text_response(
                500,
                "Error: " + str(e)
            )


# ==================================================
# START SERVER
# ==================================================

server = HTTPServer(
    ("localhost", 8000),
    StudentHandler
)

print(
    "Server running at http://localhost:8000"
)

server.serve_forever()
