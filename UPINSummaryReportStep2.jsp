<html>
<head>
    <link rel="stylesheet" href="pop_style.css">

    <title>eHospital Lab Portal</title>

    <script language="JavaScript">
        // function submitform() {
        //     if (confirm("Do you want to continue?")) {
        //         document.form1.target = "PopPrint";
        //         open('', 'PopPrint', 'width=700,height=600,resizable=0,scrollbars=0');
        //         document.forms.form1.submit();
        //     }
        //     // location.href = "home.jsp";
        // }

    </script>

    <link href="/eHospitalLab/eHosLabStyles.css" rel="stylesheet" type="text/css">

</head>

<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page import="eHospitalLab.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Arrays" %>
<%@ page errorPage="/ErrorScreen.jsp" %>

<body class="optionsTop" topmargin="0" leftmargin="0">


<%
    HttpSession sessions = request.getSession(false);

    if (sessions == null) {
        RequestDispatcher dispatcher;
        request.setAttribute("ErrorMessage", ErrorMessages.NOT_LOGGED_IN);
        request.setAttribute("ErrorType", "ERROR");
        dispatcher = getServletContext().getRequestDispatcher("/ErrorScreen.jsp");
        dispatcher.include(request, response);
    } else {

        String usertype = (String) sessions.getValue("usertype");
        String uid = (String) sessions.getValue("uid");
        String unitID = (String) sessions.getValue("unitID");


        if ((usertype.equals("Admin")) || (usertype.equals("User"))) // start checking user type
        {
            String upin = request.getParameter("upin");
            String dayFromDate = request.getParameter("dateFrom");
            String dayToDate = request.getParameter("dateTo");

            System.out.println("upin >> " + upin);
            System.out.println("dateFrom >> " + dayFromDate);
            System.out.println("dateTo >> " + dayToDate);

            List<String> dateColumns = new ArrayList<String>();
            List<String[]> transformedData = new ArrayList<String[]>();
            EChannelDB conn = new EChannelDB();

%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">

    <tr>
        <td width="3%" height="30" align="left" background="/eHospitalSystemAdmin/images/titleMiddle.gif"
            class="titles"><img src="/eHospitalSystemAdmin/images/titleCorner.gif" width="30" height="30" border="0">
        </td>
        <td width="97%" background="/eHospitalSystemAdmin/images/titleMiddle.gif" valign="middle" class="titles"><p
                style="margin-right:10"><b>Lab Summary Report for UPIN <%=upin%>
        </b></p></td>
    </tr>
</table>

<form action="" method="post">
    <table width="45%" border="0" cellspacing="0" cellpadding="0" class="bodyTable" align="center">

            <%


            try {
                ResultSet rsH = null;
                System.out.println("upin>> "+upin);
                System.out.println("dayFromDate>> "+dayFromDate);
                System.out.println("dayToDate>> "+dayToDate);
                String queryH = "SELECT LI.INVOICE_NO, LT.TEST_CODE, LR.TEST_NAME AS TEST_NAME, "
                        + "LT.UNITS AS UNITS, TO_CHAR(LI.TXN_DATE, 'YYYY-MM-DD') AS TEST_DATE, "
                        + "LR.NORMAL_RESULTS AS RESULTS, "
                        + "DECODE(LT.REF_LEVEL1, NULL, (SELECT NORMAL_LOW_VALUE FROM EHOS.LAB_TEST_REF_RANGES LRF "
                        + "WHERE LT.TEST_CODE = LRF.TEST_CODE AND LRF.GENDER = 1 AND LRF.MAX_AGE_VAL = 150), LT.REF_LEVEL1) || '/' || "
                        + "DECODE(LT.REF_LEVEL2, NULL, (SELECT NORMAL_HIGH_VALUE FROM EHOS.LAB_TEST_REF_RANGES LRF "
                        + "WHERE LT.TEST_CODE = LRF.TEST_CODE AND LRF.GENDER = 1 AND LRF.MAX_AGE_VAL = 150), LT.REF_LEVEL2) AS NORMAL_RANGE, "
                        + "CASE WHEN LI.INVOICE_NO LIKE 'NSL%' THEN 'INWARD' ELSE 'OPD' END AS PATIENT_TYPE "
                        + "FROM EHOS.LAB_TEST_INVOICES LI, EHOS.LAB_TEST_BREAKDOWN LBR, EHOS.LAB_TEST_RESULTS LR, EHOS.LAB_TESTS LT "
                        + "WHERE LI.UPIN = '"+upin+"' AND LI.INVOICE_NO = LBR.INVOICE_NO "
                        + "AND LBR.LAB_REF_NO = LR.LAB_REF_NO AND LR.TEST_ID = LT.TEST_CODE "
                        + "AND LI.TXN_DATE BETWEEN TO_DATE('"+dayFromDate+"', 'DD/MM/YYYY') AND TO_DATE('"+dayToDate+"', 'DD/MM/YYYY') AND LI.STATUS = 1 "
                        + "ORDER BY TEST_CODE, TXN_DATE";

                conn.connectToDB();
                rsH = conn.query(queryH);
                int no = 0;
                String oldTestCode = "";
                String[] row = new String[1];
                while (rsH.next()) {

                    String testCode = rsH.getString("TEST_CODE");
                    String testName = rsH.getString("TEST_NAME");
                    String units = rsH.getString("UNITS");
                    String normalRange = rsH.getString("NORMAL_RANGE");
//                    String patientType = rsH.getString("PATIENT_TYPE");
                    String testDate = rsH.getString("TEST_DATE");
                    String result = rsH.getString("RESULTS");

                    if (!dateColumns.contains(testDate)) {
                        dateColumns.add(testDate);

                        String[] newRow = new String[row.length + 1];
                        for(int n = 0; n < row.length; n++) {
                          newRow[n] = row[n];
                        }
                        row = newRow;
                    }

                    if (!oldTestCode.equals(testCode)){
                        no++;
                        if (no != 1){
                            transformedData.add(row);
                        }
//                    }
                    row = new String[5 + dateColumns.size()];
                    row[0] = no+".)";
                    row[1] = testCode;
                    row[2] = testName;
                    row[3] = units;
                    row[4] = normalRange;
//                    row[4] = patientType;
                    oldTestCode = testCode;
//                    transformedData.add(row);
                    }
                    int dateIndex = dateColumns.indexOf(testDate) + 5;
                    row[dateIndex] = result;
//                    System.out.println("row array : "+ Arrays.toString(row));

//                    transformedData.add(row);
//                    no++;
                }
                            transformedData.add(row);

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

        <table width="90%" border="0" cellspacing="0" cellpadding="4" class="bodyTable" align="center">
            <thead>
            <tr height="22" class="tableTitle" valign="middle">
                <th align="left">#</th>
                <th align="left">Test Code</th>
                <th align="left">Test Name</th>
                <th align="left">Unit</th>
                <th align="left">Normal Range</th>
                <%--                <th>Patient Type</th>--%>
                <%
                    for (int i = 0; i < dateColumns.size(); i++) {
                %>
                <th align="center"><%= dateColumns.get(i) %>
                </th>
                <%
                    }
                %>
            </tr>
            </thead>
            <tbody>
            <%
                String[] row2 = new String[dateColumns.size() + 5];
                String align = "";
                for (int j = 0; j < transformedData.size(); j++) {
                    String[] row = transformedData.get(j);

                    for (int k = 0; k < row.length; k++) {
                        row2[k] = row[k];
                    }
                    System.out.println("array list>> : " + Arrays.toString(row2));
            %>
            <tr>
                <%
                    for (int i = 0; i < row2.length; i++) {
                        if (i < 5) {
                            align = "left";
                        } else {
                            align = "center";
                        }
                %>
                <td align="<%=align%>" class="rowgrey"><%= (row2[i] != null ? row2[i] : "-") %>
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
<%
        }
    }
%>
<br>

</body>

</html>
