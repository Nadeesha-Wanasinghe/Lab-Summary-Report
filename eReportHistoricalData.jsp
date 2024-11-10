<html>
<%@ page import="java.text.*" %>
<head>
    <link href="eHosStoreStyles.css" rel="stylesheet" type="text/css">

</head>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%--<%@ page import="eHospitalSystemAdmin.*" %>--%>
<%@ page errorPage="/ErrorScreen.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.ResultSet" %>
<%--<%@ page import="java.sql.*" %>--%>
<%@ page import="java.text.*" %>
<%@ page import="eHospitalLab.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.ParseException" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%--<%@ page errorPage="/ErrorScreen.jsp" %>--%>

<%
    String upin = (String) request.getParameter("upin");
    String dayFromDate = (String) request.getParameter("dayFromDate");
    String dayToDate = (String) request.getParameter("dayToDate");
    List<String> refNos = new ArrayList<String>();
    List<String[]> transformedData = new ArrayList<String[]>();
    List<String[]> refNoAndDate = new ArrayList<String[]>();
    EChannelDB conn = new EChannelDB();
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "inline; filename=HistoricalDataOf_'"+upin+"'_From_'"+dayFromDate+"'_To_'"+dayToDate+"'.xls");

//    EChannelDB conn = new EChannelDB();
//    ResultSet rs = null;

%>
<body align="left" topmargin="0" class="optionsTop"
      background="/eHospitalNurseStation/images/optionsTop.jpg">
<table width="165%" border="0" cellspacing="0" cellpadding="0">
    <tr>
<%--        <td width="0%" height="50" align="left" background="/eHospitalNurseStation/images/titleMiddle.gif"--%>
<%--            class="titles"><img src="/eHospitalNurseStation/images/titleCorner.gif" width="0" height="50" border="0">--%>
<%--        </td>--%>
        <td height="30" colspan="3" valign="middle" background="/eHospitalNurseStation/images/titleMiddle.gif" class="titles"><p>
            Historical Data of <%=upin%> from <%=dayFromDate%> to <%=dayToDate%>
        </p></td>
    </tr>
</table>

<form action="" method="post">
    <%--    <table width="45%" border="0" cellspacing="0" cellpadding="0" class="bodyTable" align="center">--%>

    <%


        try {
            ResultSet rsH = null;
            String queryH =  "SELECT LI.INVOICE_NO, " +
                    "       LT.TEST_CODE, " +
                    "       LR.TEST_NAME                                                     AS TEST_NAME, " +
                    "       LT.UNITS                                                         AS UNITS, " +
                    "       TO_CHAR(LI.TXN_DATE, 'YYYY-MM-DD')                               AS TEST_DATE, " +
                    "       LR.NORMAL_RESULTS                                                AS RESULTS, " +
                    "       DECODE(LT.REF_LEVEL1, NULL, (SELECT NORMAL_LOW_VALUE " +
                    "                                    FROM EHOS.LAB_TEST_REF_RANGES LRF " +
                    "                                    WHERE LT.TEST_CODE = LRF.TEST_CODE " +
                    " " +
                    " " +
                    "                                      AND LRF.GENDER IN (SELECT DECODE(UPI.GENDAR, 'MALE', '1', 'FEMALE', '2') " +
                    "                                                         FROM EHOS.UNQ_PATIENT_IDS UPI " +
                    "                                                         WHERE UPI.PIN_NO = '"+upin+"') " +
                    " " +
                    " " +
                    "                                      AND LRF.MIN_AGE_DAYS < (SELECT TRUNC(SYSDATE) - DOB " +
                    "                                                              FROM EHOS.UNQ_PATIENT_IDS UPI " +
                    "                                                              WHERE UPI.PIN_NO = '"+upin+"') " +
                    " " +
                    "                                      AND LRF.MAX_AGE_DAYS >= (SELECT TRUNC(SYSDATE) - DOB " +
                    "                                                               FROM EHOS.UNQ_PATIENT_IDS UPI " +
                    "                                                               WHERE UPI.PIN_NO = '"+upin+"')), LT.REF_LEVEL1) " +
                    "           || '/' || " +
                    "       DECODE(LT.REF_LEVEL2, NULL, (SELECT NORMAL_HIGH_VALUE " +
                    "                                    FROM EHOS.LAB_TEST_REF_RANGES LRF " +
                    "                                    WHERE LT.TEST_CODE = LRF.TEST_CODE " +
                    " " +
                    " " +
                    "                                      AND LRF.GENDER IN (SELECT DECODE(UPI.GENDAR, 'MALE', '1', 'FEMALE', '2') " +
                    "                                                         FROM EHOS.UNQ_PATIENT_IDS UPI " +
                    "                                                         WHERE UPI.PIN_NO = '"+upin+"') " +
                    " " +
                    " " +
                    "                                      AND LRF.MIN_AGE_DAYS < (SELECT TRUNC(SYSDATE) - DOB " +
                    "                                                              FROM EHOS.UNQ_PATIENT_IDS UPI " +
                    "                                                              WHERE UPI.PIN_NO = '"+upin+"') " +
                    " " +
                    "                                      AND LRF.MAX_AGE_DAYS >= (SELECT TRUNC(SYSDATE) - DOB " +
                    "                                                               FROM EHOS.UNQ_PATIENT_IDS UPI " +
                    "                                                               WHERE UPI.PIN_NO = '"+upin+"')), " +
                    "              LT.REF_LEVEL2)                                            AS NORMAL_RANGE, " +
                    " " +
                    " " +
                    "       CASE WHEN LI.INVOICE_NO LIKE 'NSL%' THEN 'INWARD' ELSE 'OPD' END AS PATIENT_TYPE " +
                    "FROM EHOS.LAB_TEST_INVOICES LI, " +
                    "     EHOS.LAB_TEST_BREAKDOWN LBR, " +
                    "     EHOS.LAB_TEST_RESULTS LR, " +
                    "     EHOS.LAB_TESTS LT " +
                    "WHERE LI.UPIN = '"+upin+"' " +
                    "  AND LI.INVOICE_NO = LBR.INVOICE_NO " +
                    "  AND LBR.LAB_REF_NO = LR.LAB_REF_NO " +
                    "  AND LR.TEST_ID = LT.TEST_CODE " +
                    "  AND LI.TXN_DATE BETWEEN TO_DATE('"+dayFromDate+"', 'DD/MM/YYYY') AND TO_DATE('"+dayToDate+"', 'DD/MM/YYYY') " +
                    "  AND LI.STATUS = 1 " +
                    "ORDER BY TEST_CODE, TXN_DATE";

            conn.connectToDB();
            rsH = conn.query(queryH);
            int no = 0;
            String oldTestCode = "";
            String[] row = new String[0];

            while (rsH.next()){
                String invNo = rsH.getString("INVOICE_NO");
                String testDate = rsH.getString("TEST_DATE");


                if (!refNos.contains(invNo)){
                    refNos.add(invNo);
                    String[] refArray = new String[2];
                    refArray[0] = testDate;
                    refArray[1] = invNo;
                    refNoAndDate.add(refArray);
                }
            }

            final SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

            Collections.sort(refNoAndDate, new Comparator<String[]>() {
                @Override
                public int compare(String[] a, String[] b) {
                    try {
                        Date dateA = formatter.parse(a[0]);
                        Date dateB = formatter.parse(b[0]);

                        return dateA.compareTo(dateB);
                    } catch (ParseException e) {
                        e.printStackTrace();
                        return 0;
                    }
                }
            });

            rsH = conn.query(queryH);

            while (rsH.next()) {

                String invNo = rsH.getString("INVOICE_NO");
                String testCode = rsH.getString("TEST_CODE");
                String testName = rsH.getString("TEST_NAME");
                String units = rsH.getString("UNITS");
                String normalRange = rsH.getString("NORMAL_RANGE");
                String result = rsH.getString("RESULTS");

                if (!oldTestCode.equals(testCode)){
                    no++;
                    if (no != 1){
                        transformedData.add(row);
                    }
                    row = new String[5 + refNoAndDate.size()];
                    row[0] = no+")";
                    row[1] = testCode;
                    row[2] = testName;
                    row[3] = units;
                    row[4] = normalRange;
                    oldTestCode = testCode;
                }

                for(int i = 0; i < refNoAndDate.size(); i++) {
                    if (refNoAndDate.get(i)[1].equals(invNo)){
                        row[i+5] = result;
                    }
                }

            }
            if (row[0] != null){
                transformedData.add(row);
            }

            conn.flushStmtRs();
        } catch (Exception e) {
            conn.flushStmtRs();
            System.out.println(" SQL Exception " + e);
            request.setAttribute("ErrorMessage", ErrorMessages.DATABASE_ERROR);
            request.setAttribute("ErrorType", "ERROR");
            RequestDispatcher dispatcher1;
            dispatcher1 = getServletContext().getRequestDispatcher("/ErrorScreen.jsp");
            dispatcher1.include(request, response);
        }
    %>

    <table width="90%" border="1" cellspacing="0" cellpadding="4" class="bodyTable" align="center">
        <thead>
        <tr height="25" style="background-color: #0c5460 ; color: white; vertical-align: text-top">
            <th align="left">#</th>
            <th align="left">Test Code</th>
            <th align="left" width="250px">Test Name</th>
            <th align="left" width="110px">Unit</th>
            <th align="left" width="110px">Normal Range</th>
            <%
                for (int i = 0; i < refNoAndDate.size(); i++) {
            %>
            <th align="center">
                <%=
                refNoAndDate.get(i)[0]
                %>
                <br>
                <%=
                refNoAndDate.get(i)[1]
                %>
            </th>
            <%
                }
            %>
        </tr>
        </thead>
        <tbody>
        <%
            String align = "";
            for (int j = 0; j < transformedData.size(); j++) {
                String[] row = transformedData.get(j);
        %>
        <tr>
            <%
                for (int i = 0; i < row.length; i++) {
                    if (i < 5) {
                        align = "left";
                    } else {
                        align = "center";
                    }
            %>
            <td align="<%=align%>" class="rowgrey"><%= (row[i] != null ? row[i] : "-") %>
            </td>
            <%
                }
            %>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
</form>
<script>
    function Printexcell(tableID, filename = '') {
        var downloadLink;
        var dataType = 'application/vnd.ms-excel';
        var tableSelect = document.getElementById(tableID);
        var tableHTML = tableSelect.outerHTML.replace(/ /g, '%20');
        // Specify file name
        filename = filename ? filename + '.xls' : 'excel_data.xls';
        // Create download link element
        downloadLink = document.createElement("a");
        document.body.appendChild(downloadLink);
        if (navigator.msSaveOrOpenBlob) {
            var blob = new Blob(['\ufeff', tableHTML], {
                type: dataType
            });
            navigator.msSaveOrOpenBlob(blob, filename);
        } else {
            // Create a link to the file
            downloadLink.href = 'data:' + dataType + ', ' + tableHTML;
            // Setting the file name
            downloadLink.download = filename;
            //triggering the function
            downloadLink.click();
        }
    }
</script>
</body>
</html>
