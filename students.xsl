<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template match="/Students">

        <html>
            <body>

                <h1>Student Report Card</h1>

                <table border="1">

                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Department</th>
                        <th>Marks</th>
                        <th>Grade</th>
                        <th>Status</th>
                    </tr>

                    <xsl:for-each select="Student">

                        <!-- SORT BY NAMES -->
                        <xsl:sort
                            select="name"
                            data-type="text"
                            order="ascending"/>

                        <tr>

                            <td>
                                <xsl:value-of select="@id"/>
                            </td>

                            <td>
                                <xsl:value-of select="name"/>
                            </td>

                            <td>
                                <xsl:value-of select="department"/>
                            </td>

                            <td>
                                <xsl:value-of select="marks"/>
                            </td>

                            <td>
                                <xsl:choose>
                                    <xsl:when test="marks >= 90">Grade A</xsl:when>
                                    <xsl:when test="marks >= 70">Grade B</xsl:when>
                                    <xsl:when test="marks >= 50">Grade C</xsl:when>
                                    <xsl:when test="marks >= 35">Grade D</xsl:when>
                                    <xsl:otherwise>Fail</xsl:otherwise>
                                </xsl:choose>
                            </td>

                            <td>
                                <xsl:choose>

                                    <xsl:when test="marks >= 35">
                                        Pass
                                    </xsl:when>

                                    <xsl:otherwise>
                                        Fail
                                    </xsl:otherwise>

                                </xsl:choose>

                            </td>

                        </tr>

                    </xsl:for-each>

                </table>

            </body>
        </html>

    </xsl:template>

</xsl:stylesheet>
