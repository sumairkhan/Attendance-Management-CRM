
Imports System.Globalization
Imports Oracle.ManagedDataAccess.Client

Partial Class Admin_Attendance_ConsolidateList
    Inherits System.Web.UI.Page

    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(User.Identity.Name).ProviderUserKey)
    Dim TotalQty As Integer = 0
    Dim TotalPrice As Integer = 0

    ReadOnly _connString As String = ConfigurationManager.ConnectionStrings("OracleConnection").ConnectionString

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
            Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)


            Dim haveRights = PortalUtilities.fnHaveRights(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.Att_Summary)
            If Not haveRights Then Response.Redirect("~/Admin/")


            Using cntx As New PortalModel.PortalEntities
                Dim dept = (From d In cntx.Departments Where d.IsDeleted Is Nothing OrElse d.IsDeleted = False Order By d.Title Select d.DepartmentID, d.Title).ToList

                Dim intDeptID As Integer = lstEmployeeAndCompanyID(2)

                Dim strDeptTitle = String.Empty
                If intDeptID > 0 Then
                    strDeptTitle = dept.Where(Function(f) f.DepartmentID = lstEmployeeAndCompanyID(2)).ToList().FirstOrDefault().Title
                End If

                If Not strDeptTitle.Trim().ToLower.Equals("superadmin") Then
                    dept = dept.Where(Function(f) Not f.Title.ToLower().Trim().Equals("superadmin")).ToList()
                End If

                'Dim objEmpRights = cntx.sp_GetPageRightsByEmpAndMenuLinkID(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.Attendance, intCompanyID).Where(Function(f) f.EmpRightID > 0).ToList()
                'If objEmpRights.Count <= 0 Then
                '    Response.Redirect("~/Admin/")
                'End If

                'Dim lstInnerRights = objEmpRights.Select(Function(f) f.Title).ToList()


                'If Not lstInnerRights.Contains("View Other Departments") Then
                '    dept = dept.Where(Function(f) f.DepartmentID = intDeptID).ToList()
                'End If
                With ddlDept
                    .DataValueField = "DepartmentID"
                    .DataTextField = "Title"
                    .DataSource = dept
                    .DataBind()
                    .Items.Insert(0, New ListItem("-- Select --", ""))
                End With

                ddlEmployee.Items.Insert(0, New ListItem("-- All --", ""))

                Dim objShifts = (From d In cntx.sp_GetAllAttShifts() Order By d.Title Select d.ShiftID, d.Title).ToList
                With ddlShift
                    .DataValueField = "ShiftID"
                    .DataTextField = "Title"
                    .DataSource = objShifts
                    .DataBind()
                    .Items.Insert(0, New ListItem("-- All --", ""))
                End With

                Dim objDesignation = (From d In cntx.HR_Designations Where d.IsDeleted = False Order By d.Title Select d.DesignationID, d.Title).ToList

                With ddlDesignation
                    .DataValueField = "DesignationID"
                    .DataTextField = "Title"
                    .DataSource = objDesignation
                    .DataBind()
                    .Items.Insert(0, New ListItem("-- All --", ""))
                End With

                Dim objScale = (From d In cntx.HR_Scales Where d.IsDeleted = False Order By d.Title Select d.ScaleID, d.Title).ToList

                With ddlScale
                    .DataValueField = "ScaleID"
                    .DataTextField = "Title"
                    .DataSource = objScale
                    .DataBind()
                    .Items.Insert(0, New ListItem("-- All --", ""))
                End With
            End Using
        End If
    End Sub


    Private Sub ddlDept_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlDept.SelectedIndexChanged
        Try
            lblStatus.Text = String.Empty
            ddlEmployee.Items.Clear()
            ddlEmployee.Items.Insert(0, New ListItem("-- Select --", ""))

            Using cntx As New PortalModel.PortalEntities
                ddlEmployee.Items.Clear()
                If Not String.IsNullOrEmpty(ddlDept.SelectedValue) AndAlso ddlDept.SelectedValue > 0 Then
                    GetEmployees(cntx)
                End If
            End Using

        Catch ex As Exception
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = ex.Message
            If ex.InnerException IsNot Nothing Then
                lblStatus.Text = lblStatus.Text & "<br />" & ex.InnerException.Message
            End If
        End Try
    End Sub

    Protected Sub GetEmployees(cntx As PortalModel.PortalEntities)
        lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
        Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)

        Dim obj = (From emp In cntx.Employees
                   Where (emp.IsDeleted = False Or emp.IsDeleted Is Nothing) AndAlso emp.DepartmentID = ddlDept.SelectedValue
                   Order By emp.FirstName
                   Select emp.EmployeeID, EmpName = emp.EmpCode + " - " + emp.FirstName).ToList()

        'Dim objEmpRights = cntx.sp_GetPageRightsByEmpAndMenuLinkID(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.Attendance, intCompanyID).Where(Function(f) f.EmpRightID > 0).ToList()
        'Dim lstInnerRights = objEmpRights.Select(Function(f) f.Title).ToList()

        'If lstInnerRights.Contains("View Other Departments") OrElse lstInnerRights.Contains("View Others") Then
        'Else

        '    obj = obj.Where(Function(f) f.EmployeeID = empID).ToList()
        'End If
        With ddlEmployee
            .DataValueField = "EmployeeID"
            .DataTextField = "EmpName"
            .DataSource = obj
            .DataBind()
            .Items.Insert(0, New ListItem("-- All --", ""))
        End With
    End Sub



    Protected Sub grd_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grd.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Try


                'Dim AttStatus As String = DataBinder.Eval(e.Row.DataItem, "AttStatus")

                ''Dim lblAttStatus As Label = e.Row.FindControl("lblAttStatus")
                'Dim strAttStatus As String = String.Empty


                'If AttStatus = PortalUtilities.AttendanceStatus.Present Then
                '    strAttStatus = "Present"
                'ElseIf AttStatus = PortalUtilities.AttendanceStatus.Absent Then
                '    strAttStatus = "Absent"
                'End If


                ''lblAttStatus.Text = strAttStatus

                'If AttStatus = PortalUtilities.AttendanceStatus.Present Then
                Dim lblTotalWorked As Label = e.Row.FindControl("lblTotalWorked")
                Dim lblTotalExtraTime As Label = e.Row.FindControl("lblTotalExtraTime")
                Dim lblTotalShiftTime As Label = e.Row.FindControl("lblTotalShiftTime")

                Using cntx As New PortalModel.PortalEntities
                    lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
                    Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)
                    Dim dtFrom As DateTime? = Nothing
                    Dim dtTo As DateTime? = Nothing
                    Dim deptID As Integer? = Nothing
                    Dim empID As Integer? = Nothing
                    Dim strJobStatus As String = Nothing
                    Dim intShiftID As Integer? = Nothing

                    If IsDate(txtDateFrom.Text.Trim()) Then
                        dtFrom = Convert.ToDateTime(txtDateFrom.Text.Trim()).Date
                    End If

                    If IsDate(txtDateTo.Text.Trim()) Then
                        dtTo = Convert.ToDateTime(txtDateTo.Text.Trim()).Date
                    End If

                    If dtFrom IsNot Nothing AndAlso dtTo Is Nothing Then
                        dtTo = DateTime.Today
                    End If

                    'If Not String.IsNullOrEmpty(ddlDept.SelectedValue) AndAlso ddlDept.SelectedValue > 0 Then
                    '    deptID = ddlDept.SelectedValue
                    'End If

                    empID = grd.DataKeys(e.Row.RowIndex).Value

                    'If Not String.IsNullOrEmpty(ddlShift.SelectedValue) AndAlso ddlShift.SelectedValue > 0 Then
                    '    intShiftID = ddlShift.SelectedValue
                    'End If

                    'If Not String.IsNullOrEmpty(ddlJobStatus.SelectedValue) Then
                    '    strJobStatus = ddlJobStatus.SelectedValue
                    'End If


                    Dim objList = PortalBinding.fnGetAllAttRecords(cntx, intCompanyID, deptID, empID, strJobStatus, dtFrom, dtTo, Nothing, Nothing, intShiftID, PortalUtilities.AttendanceStatus.Present).ToList()

                    Dim intWorkTimeHours? As Integer = 0
                    Dim intWorkTimeMinutes? As Integer = 0

                    Dim intShiftTimeHours? As Integer = 0
                    Dim intShiftTimeMinutes? As Integer = 0

                    For Each obj In objList
                        Dim DateTimeIn As String = Nothing
                        Dim DateTimeOut As String = Nothing


                        If obj.DateTimeIn IsNot Nothing AndAlso obj.DateTimeOut IsNot Nothing Then
                            If obj.DateTimeIn IsNot Nothing Then
                                DateTimeIn = Convert.ToDateTime(obj.DateTimeIn).ToString("hh:mm tt")
                            End If

                            If obj.DateTimeOut IsNot Nothing Then
                                DateTimeOut = Convert.ToDateTime(obj.DateTimeOut).ToString("hh:mm tt")
                            End If



                            Dim totalWorkTime? As TimeSpan = Nothing
                            If DateTimeIn IsNot Nothing AndAlso DateTimeOut IsNot Nothing Then
                                totalWorkTime = Convert.ToDateTime(DateTimeOut) - Convert.ToDateTime(DateTimeIn)
                                intWorkTimeHours += totalWorkTime.Value.Hours
                                intWorkTimeMinutes += totalWorkTime.Value.Minutes
                            End If

                            Dim isHoliday As Boolean = False
                            Dim objHoliday = cntx.Holidays.Where(Function(f) f.IsDeleted = False AndAlso f.HolidayDate = obj.AttDate).ToList().FirstOrDefault()
                            If objHoliday IsNot Nothing Then
                                isHoliday = True
                            End If

                            If Not isHoliday Then
                                If obj.ShiftTimingIn IsNot Nothing AndAlso obj.ShiftTimingOut IsNot Nothing Then
                                    Dim ShiftTimingIn As TimeSpan = obj.ShiftTimingIn
                                    Dim ShiftTimingOut As TimeSpan = obj.ShiftTimingOut
                                    Dim totalShiftTime? As TimeSpan = Nothing

                                    If (ShiftTimingIn.Hours > 0 OrElse ShiftTimingIn.Minutes > 0) AndAlso (ShiftTimingOut.Hours > 0 OrElse ShiftTimingOut.Minutes > 0) Then
                                        totalShiftTime = ShiftTimingOut - ShiftTimingIn
                                        intShiftTimeHours += totalShiftTime.Value.Hours
                                        intShiftTimeMinutes += totalShiftTime.Value.Minutes
                                    End If
                                End If
                            End If
                        End If
                    Next



                    Dim tmpTotalShiftTime As New TimeSpan(intShiftTimeHours, intShiftTimeMinutes, 0)
                    lblTotalShiftTime.Text = ((tmpTotalShiftTime.Days * 24) + (tmpTotalShiftTime.Hours)).ToString("D2") + ":" + tmpTotalShiftTime.Minutes.ToString("D2")

                    Dim tmpTotalWorkTime As New TimeSpan(intWorkTimeHours, intWorkTimeMinutes, 0)
                    lblTotalWorked.Text = ((tmpTotalWorkTime.Days * 24) + (tmpTotalWorkTime.Hours)).ToString("D2") + ":" + tmpTotalWorkTime.Minutes.ToString("D2")

                    Dim strTempTotalExtraSplit As String() = PortalBinding.fnGetExtraTime(tmpTotalShiftTime, tmpTotalWorkTime).Split(":")
                    lblTotalExtraTime.Text = strTempTotalExtraSplit(0) + ":" + strTempTotalExtraSplit(1)
                End Using
            Catch ex As Exception

            End Try
        End If

        'End If
    End Sub



    Private Sub BindGrid(ByVal cntx As PortalModel.PortalEntities)
        lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
        Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)

        Dim dtFrom As DateTime? = Nothing
        Dim dtTo As DateTime? = Nothing
        Dim deptID As Integer? = Nothing
        Dim empID As Integer? = Nothing
        Dim strJobStatus As String = Nothing
        Dim strAttStatus As String = Nothing
        Dim intShiftID As Integer? = Nothing
        Dim strDesignation As String = Nothing
        Dim isExempt As Boolean? = Nothing
        Dim intScaleID As Integer? = Nothing
        Dim isRetired As Boolean? = Nothing


        If IsDate(txtDateFrom.Text.Trim()) Then
            dtFrom = Convert.ToDateTime(txtDateFrom.Text.Trim()).Date
        End If

        If IsDate(txtDateTo.Text.Trim()) Then
            dtTo = Convert.ToDateTime(txtDateTo.Text.Trim()).Date
        End If

        If dtFrom IsNot Nothing AndAlso dtTo Is Nothing Then
            dtTo = DateTime.Today
        End If

        If Not String.IsNullOrEmpty(ddlDept.SelectedValue) AndAlso ddlDept.SelectedValue > 0 Then
            deptID = ddlDept.SelectedValue
        End If

        If Not String.IsNullOrEmpty(ddlEmployee.SelectedValue) AndAlso ddlEmployee.SelectedValue > 0 Then
            empID = ddlEmployee.SelectedValue
        End If

        If Not String.IsNullOrEmpty(ddlShift.SelectedValue) AndAlso ddlShift.SelectedValue > 0 Then
            intShiftID = ddlShift.SelectedValue
        End If


        If Not String.IsNullOrEmpty(ddlAttStatus.SelectedValue) Then
            strAttStatus = ddlAttStatus.SelectedValue
        End If

        If Not String.IsNullOrEmpty(ddlDesignation.SelectedValue) Then
            strDesignation = ddlDesignation.SelectedItem.Text
        End If


        If Not String.IsNullOrEmpty(ddlExempt.SelectedValue) Then
            isExempt = ddlExempt.SelectedValue
        End If

        If Not String.IsNullOrEmpty(ddlScale.SelectedValue) Then
            intScaleID = ddlScale.SelectedValue
        End If


        If Not String.IsNullOrEmpty(ddlIsRetired.SelectedValue) Then
            isRetired = ddlIsRetired.SelectedValue
        End If

        Dim objList = PortalBinding.fnGetAllAttConsolidate(cntx, intCompanyID, deptID, empID, strJobStatus, dtFrom, dtTo, intShiftID, strAttStatus, strDesignation, isExempt, intScaleID, isRetired).ToList()

        grd.DataSource = objList
        grd.DataBind()
        If objList.Count > 0 Then
            divGrid.Visible = True
        Else
            divGrid.Visible = False
            lblStatus.Text = "No record(s) found!"
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Font.Bold = True
        End If

    End Sub

    Protected Sub btnShow_Click(sender As Object, e As System.EventArgs) Handles btnShow.Click
        Try
            divGrid.Visible = False
            lblStatus.Text = String.Empty
            Using cntx As New PortalModel.PortalEntities
                cntx.CommandTimeout = Int32.MaxValue
                BindGrid(cntx)
            End Using
        Catch ex As Exception
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = ex.Message
        End Try

    End Sub
    Public Overrides Sub VerifyRenderingInServerForm(control As Control)
        Return
    End Sub
    Private Sub btnExport_Click(sender As Object, e As EventArgs) Handles btnExport.Click
        Try

            Response.ClearContent()
            Response.Buffer = True
            Response.AddHeader("content-disposition", "attachment;filename=ConsolidatedAttendanceList.xls")
            Response.Charset = ""
            Response.ContentType = "application/vnd.ms-excel"


            'grd.Columns(13).Visible = False
            'grd.Columns(14).Visible = False
            'grd.Columns(15).Visible = False



            Using sw As New IO.StringWriter()
                Dim hw As New HtmlTextWriter(sw)



                grd.HeaderRow.BackColor = Drawing.Color.White
                For Each cell As TableCell In grd.HeaderRow.Cells
                    cell.BackColor = grd.HeaderStyle.BackColor
                Next
                For Each row As GridViewRow In grd.Rows
                    row.BackColor = Drawing.Color.White
                    For Each cell As TableCell In row.Cells
                        If row.RowIndex Mod 2 = 0 Then
                            cell.BackColor = grd.AlternatingRowStyle.BackColor
                        Else
                            cell.BackColor = grd.RowStyle.BackColor
                        End If
                        cell.CssClass = "textmode"
                    Next
                Next

                grd.RenderControl(hw)
                'style to format numbers to string
                Dim style As String = "<style> .textmode { mso-number-format:\@; } </style>"
                Response.Write(style)
                Response.Output.Write(sw.ToString())
                Response.Flush()
                Response.End()
                'HttpContext.Current.Response.Flush() ' Sends all currently buffered output to the client.
                'Response.SuppressContent = True ' Gets or sets a value indicating whether to send HTTP content to the client.
                'HttpContext.Current.ApplicationInstance.CompleteRequest() ' Causes ASP.NET to bypass all events and filtering in the HTTP pipeline chain of execution and directly execute the EndRequest event.

                'grd.Columns(13).Visible = True
                'grd.Columns(14).Visible = True
                'grd.Columns(15).Visible = True

            End Using
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub btnProcess_Click(sender As Object, e As System.EventArgs) Handles btnProcess.Click
        lblStatus.Text = String.Empty

        Try
            If Not String.IsNullOrEmpty(ddlDept.SelectedValue) AndAlso ddlDept.SelectedValue > 0 Then


                Using connection As New OracleConnection(_connString)
                    connection.Open()

                    Dim dtFrom As String = txtDateFrom.Text.Trim()
                    Dim dtTo As String = txtDateTo.Text.Trim()

                    For Each row As GridViewRow In grd.Rows
                        Dim lblProcessMsg As Label = row.FindControl("lblProcessMsg")
                        Try
                            Dim strEmpCode As String = DirectCast(row.FindControl("lblEmpCode"), Label).Text
                            Dim strEmpName As String = DirectCast(row.FindControl("lblName"), Label).Text

                            Dim intPresent As Integer = Convert.ToInt32(DirectCast(row.FindControl("lblTotalPresent"), Label).Text) + Convert.ToInt32(DirectCast(row.FindControl("lblTotalHolidays"), Label).Text) + Convert.ToInt32(DirectCast(row.FindControl("lblTotalLeaves"), Label).Text)
                            Dim intAbsent As Integer = DirectCast(row.FindControl("lblTotalAbsent"), Label).Text

                            Dim strSql As String = "Insert into BIOMETRIC(MR_NO,EMP_NAME,WORK_DAYS,FROMDATE,TODATE,TOTABS) Values('" & strEmpCode & "','" & strEmpName & "'," & intPresent & ",'" & dtFrom & "','" & dtTo & "'," & intAbsent & ")"
                            Dim objCmd As New OracleCommand

                            With objCmd
                                .Connection = connection
                                .CommandText = strSql
                                .CommandType = Data.CommandType.Text
                            End With

                            objCmd.ExecuteNonQuery()
                            lblProcessMsg.Text = "<br><b>Success</b>"
                            lblProcessMsg.ForeColor = Drawing.Color.DarkGreen
                        Catch ex As Exception
                            lblProcessMsg.Text = "<br><b>" & ex.Message & "</b>"
                            lblProcessMsg.ForeColor = Drawing.Color.DarkRed

                        End Try


                    Next


                End Using

            End If
        Catch ex As Exception
            lblStatus.Text = ex.Message
            lblStatus.ForeColor = Drawing.Color.Red
        End Try
    End Sub
End Class
