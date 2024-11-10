<%@ page errorPage="/JSPErrorPage.jsp" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
    <link href="/eHospitalLab/eHosLabStyles.css" rel="stylesheet" type="text/css">
    <script language="JavaScript" src="calendar.js"></script>
    <script language="JavaScript" src="overlib_mini.js"></script>
    <link rel="stylesheet" href="/eHRMSystem/jquery-ui-1.11.1.custom/jquery-ui.css">
    <script src="/eHRMSystem/jquery-ui-1.11.1.custom/external/jquery/jquery.js"></script>
    <script src="/eHRMSystem/jquery-ui-1.11.1.custom/jquery-ui.js"></script>
    <title>Lab Summary Report for UPIN</title>

    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">


</head>

<script language="JavaScript" type="text/JavaScript">
    $(function () {
        $("#dateFrom").datepicker({
            dateFormat: 'dd/mm/yy',
            defaultDate: "w",
            changeMonth: true,
            changeYear: true
        });
        $("#dateTo").datepicker({
            dateFormat: 'dd/mm/yy',
            defaultDate: "w",
            changeMonth: true,
            changeYear: true
        });
    });
</script>

<body topmargin="0" leftmargin="0" rightmargin="0" bottommargin="0" class="optionsTop">

<table width="100%" border="0" cellspacing="0" cellpadding="0">

    <tr>
        <td width="3%" height="30" align="left" background="/eHospitalSystemAdmin/images/titleMiddle.gif"
            class="titles"><img src="/eHospitalSystemAdmin/images/titleCorner.gif" width="30" height="30" border="0">
        </td>
        <td width="97%" background="/eHospitalSystemAdmin/images/titleMiddle.gif" valign="middle" class="titles"><p
                style="margin-right:10; margin-left: 10px"><b>Lab Summary Report for UPIN</b></p></td>
    </tr>
</table>

<table width="75%" border="0" cellpadding="0" cellspacing="0" class="optionsTop">
    <tr>
        <td colspan="3" height="15">&nbsp;</td>
    </tr>

    <form name="myform1" action="UPINSummaryReportStep2.jsp" method="post">
        <tr>
            <td height="97" valign="top" align="center">

                <table width="90%" height="22" border="0" cellpadding="0" cellspacing="0" class="bodyTable">
                    <tr>
                        <td colspan="4" height="15" class="rowgrey" align=center>&nbsp;</td>
                    </tr>

                    <tr>
                        <td valign="middle" height="25" class="rowgrey" align="left">&nbsp;&nbsp;&nbsp;&nbsp;</td>
                        <td valign="middle" height="25" class="rowgrey" align="left">UPIN</td>
                        <td height="25" valign="middle" class="rowgrey">: &nbsp;
                        </td>
                        <td height="25" valign="middle" class="rowgrey">
                            <input name="upin" type="text" class="input" value="" size="20" id="upin">
                        </td>
                    </tr>

                    <tr>
                        <td valign="middle" height="25" class="rowgrey" align="left">&nbsp;</td>
                        <td valign="middle" height="25" class="rowgrey" align="left">Date From</td>
                        <td height="25" valign="middle" class="rowgrey">: &nbsp;
                        </td>
                        <td height="25" valign="middle" class="rowgrey">
                            <input name="dateFrom" type="text" class="input" value="" size="20" id="dateFrom">
                            <!--<a href="javascript:show_calendar('myform1.dateFrom');"
                               onMouseOver="window.status='Date Picker'; overlib('Click here to choose a date from a one month pop-up calendar.'); return true;"
                               onMouseOut="window.status='';  return true;"><img
                                    src="/eHospitalCashier/images/calendaricon.gif" border="0" width="16"
                                    height="16"></a>-->
                        </td>
                    </tr>

                    <tr>
                        <td valign="middle" height="25" class="rowgrey" align="left">&nbsp;</td>
                        <td valign="middle" height="25" class="rowgrey" align="left">Date To</td>
                        <td height="25" valign="middle" class="rowgrey">: &nbsp;
                        </td>
                        <td height="25" valign="middle" class="rowgrey">
                            <input name="dateTo" type="text" class="input" value="" size="20" id="dateTo">
                            <!--<a href="javascript:show_calendar('myform1.dateTo');"
                               onMouseOver="window.status='Date Picker'; overlib('Click here to choose a date from a one month pop-up calendar.'); return true;"
                               onMouseOut="window.status='';  return true;"><img
                                    src="/eHospitalCashier/images/calendaricon.gif" border="0" width="16"
                                    height="16"></a>-->
                        </td>
                    </tr>
                    <tr>
                        <td valign="middle" height="25" class="rowgrey" align="left" colspan="4">&nbsp;</td>
                    </tr>
                    <tr>
                        <td height="26" colspan="3" valign="middle" class="rowgrey" align="center">&nbsp;
                        </td>
                        <td height="26" valign="middle" class="rowgrey" align="left">
                            <input type="submit" name="Submit" class="submitBut"
                                   value="  View Report  " tabindex="1"
                                   id="btnDone">
                        </td>
                    </tr>
                </table>

            </td>
        </tr>
    </form>

</table>

<br>

<script type="text/javascript" language="JavaScript1.2" src="pop_events.js"></script>

</body>
</html>