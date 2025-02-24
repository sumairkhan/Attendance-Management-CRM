
Imports System.Globalization

Partial Class Admin_Attendance_OvertimeList
    Inherits System.Web.UI.Page

    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(User.Identity.Name).ProviderUserKey)
    Dim TotalQty As Integer = 0
    Dim TotalPrice As Integer = 0

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
            Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)


            Dim haveRights = PortalUtilities.fnHaveRights(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.Att_Overtime_List)
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

                'Dim objEmpRights = cntx.sp_GetPageRightsByEmpAndMenuLinkID(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.Attendance).Where(Function(f) f.EmpRightID > 0).ToList()
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
                Dim AttDate As Date = Convert.ToDateTime(DataBinder.Eval(e.Row.DataItem, "AttDate")).Date
                Dim DateTimeIn As String = DataBinder.Eval(e.Row.DataItem, "DateTimeIn")
                Dim DateTimeOut As String = DataBinder.Eval(e.Row.DataItem, "DateTimeOut")
                Dim IsLeave As Boolean = Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "IsLeave"))


                Dim lblTimeIn As Label = e.Row.FindControl("lblTimeIn")
                Dim lblTimeOut As Label = e.Row.FindControl("lblTimeOut")

                If DateTimeIn IsNot Nothing Then
                    lblTimeIn.Text = Convert.ToDateTime(DateTimeIn).ToString("hh:mm tt")
                    DateTimeIn = Convert.ToDateTime(DateTimeIn).ToString("hh:mm tt")
                End If

                If DateTimeOut IsNot Nothing Then
                    lblTimeOut.Text = Convert.ToDateTime(DateTimeOut).ToString("hh:mm tt")
                    DateTimeOut = Convert.ToDateTime(DateTimeOut).ToString("hh:mm tt")
                End If


                Dim AttStatus As String = DataBinder.Eval(e.Row.DataItem, "AttStatus")
                Dim HolidayTitle As String = DataBinder.Eval(e.Row.DataItem, "HolidayTitle")
                Dim isHoliday As Boolean = False

                Using cntx As New PortalModel.PortalEntities
                    Dim objHoliday = cntx.Holidays.Where(Function(f) f.IsDeleted = False AndAlso f.HolidayDate = AttDate).ToList().FirstOrDefault()
                    If objHoliday IsNot Nothing Then
                        isHoliday = True
                        HolidayTitle = objHoliday.Title
                    End If
                End Using
                Dim lblAttStatus As Label = e.Row.FindControl("lblAttStatus")
                Dim strAttStatus As String = String.Empty


                If IsLeave Then
                    strAttStatus = "On Leave"
                ElseIf AttStatus = PortalUtilities.AttendanceStatus.Present Then
                    strAttStatus = "Present"
                    If isHoliday Then
                        strAttStatus = "Present<br>Holiday<br><b>(" + HolidayTitle + ")</b>"
                    End If
                ElseIf AttStatus = PortalUtilities.AttendanceStatus.Absent Then
                    strAttStatus = "Absent"
                ElseIf AttStatus = PortalUtilities.AttendanceStatus.Holiday Then
                    If Not String.IsNullOrEmpty(HolidayTitle) Then
                        strAttStatus = "Holiday<br><b>(" + HolidayTitle + ")</b>"
                    Else
                        strAttStatus = "Holiday"
                    End If

                End If


                lblAttStatus.Text = strAttStatus



                Dim IsLateArrive? As Boolean = DataBinder.Eval(e.Row.DataItem, "IsLateArrive")
                Dim IsEarlyGoing? As Boolean = DataBinder.Eval(e.Row.DataItem, "IsEarlyGoing")


                Dim lblLate As Label = e.Row.FindControl("lblLate")
                Dim lblEarly As Label = e.Row.FindControl("lblEarly")

                If IsLateArrive IsNot Nothing AndAlso IsLateArrive = True Then
                    lblLate.ForeColor = Drawing.Color.DarkRed
                    lblLate.Font.Bold = True
                End If

                If IsEarlyGoing IsNot Nothing AndAlso IsEarlyGoing = True Then
                    lblEarly.ForeColor = Drawing.Color.DarkRed
                    lblEarly.Font.Bold = True
                End If

                Dim totalWorkTime? As TimeSpan = Nothing
                Dim lblWorkTime As Label = e.Row.FindControl("lblWorkTime")
                If DateTimeIn IsNot Nothing AndAlso DateTimeOut IsNot Nothing Then
                    totalWorkTime = Convert.ToDateTime(DateTimeOut) - Convert.ToDateTime(DateTimeIn)
                    lblWorkTime.Text = Math.Abs(totalWorkTime.Value.Hours).ToString("D2") & ":" & Math.Abs(totalWorkTime.Value.Minutes).ToString("D2")
                End If

                Dim ShiftTimingIn As TimeSpan = DataBinder.Eval(e.Row.DataItem, "ShiftTimingIn")
                Dim ShiftTimingOut As TimeSpan = DataBinder.Eval(e.Row.DataItem, "ShiftTimingOut")
                Dim GraceTimeMinutes As String = DataBinder.Eval(e.Row.DataItem, "GraceTimeMinutes")

                Dim lblExtraTime As Label = e.Row.FindControl("lblExtraTime")

                Dim lblShiftTimeIn As Label = e.Row.FindControl("lblShiftTimeIn")
                Dim lblShiftTimeOut As Label = e.Row.FindControl("lblShiftTimeOut")
                Dim lblTotalShiftTime As Label = e.Row.FindControl("lblTotalShiftTime")
                Dim lblShiftGraceMin As Label = e.Row.FindControl("lblShiftGraceMin")
                Dim lblShift As Label = e.Row.FindControl("lblShift")

                If ShiftTimingIn.Hours > 0 OrElse ShiftTimingIn.Minutes > 0 Then
                    lblShiftTimeIn.Text = New DateTime(ShiftTimingIn.Ticks).ToString("hh:mm tt")
                End If

                If ShiftTimingOut.Hours > 0 OrElse ShiftTimingOut.Minutes > 0 Then
                    lblShiftTimeOut.Text = New DateTime(ShiftTimingOut.Ticks).ToString("hh:mm tt")
                End If

                Dim totalShiftTime? As TimeSpan = Nothing
                If isHoliday Then
                    lblExtraTime.Text = lblWorkTime.Text
                    lblLate.Text = String.Empty
                    lblEarly.Text = String.Empty
                    lblShiftTimeIn.Text = String.Empty
                    lblShiftTimeOut.Text = String.Empty
                    lblShiftGraceMin.Text = String.Empty
                    lblShift.Text = String.Empty
                Else
                    If (ShiftTimingIn.Hours > 0 OrElse ShiftTimingIn.Minutes > 0) AndAlso (ShiftTimingOut.Hours > 0 OrElse ShiftTimingOut.Minutes > 0) Then
                        totalShiftTime = ShiftTimingOut - ShiftTimingIn
                        lblTotalShiftTime.Text = totalShiftTime.Value.Hours.ToString("D2") & ":" & totalShiftTime.Value.Minutes.ToString("D2")
                    End If

                    If totalShiftTime IsNot Nothing AndAlso totalWorkTime IsNot Nothing Then
                        lblExtraTime.Text = PortalBinding.fnGetExtraTime(totalShiftTime, totalWorkTime)
                    End If
                End If
                If String.IsNullOrEmpty(lblExtraTime.Text.Trim()) OrElse lblExtraTime.Text.Trim().Contains("-") Then
                    e.Row.Visible = False
                End If

            Catch ex As Exception

            End Try
        End If
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
        Dim boolIsLateArrived As Boolean? = Nothing
        Dim boolIsEarlyGoing As Boolean? = Nothing
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

        strAttStatus = 0


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

        Dim objList = PortalBinding.fnGetAllAttRecords(cntx, intCompanyID, deptID, empID, strJobStatus, dtFrom, dtTo, Nothing, Nothing, intShiftID, strAttStatus, Nothing, Nothing, Nothing, Nothing, Nothing,
                                                       boolIsLateArrived, boolIsEarlyGoing, strDesignation, isExempt, intScaleID, isRetired).ToList()
        'Dim objList = PortalBinding.fnGetAllAttRecords(cntx, intCompanyID, deptID, empID, strJobStatus, dtFrom, dtTo, Nothing, Nothing, intShiftID, strAttStatus, Nothing, Nothing, Nothing, Nothing, Nothing, boolIsLateArrived, boolIsEarlyGoing).ToList()

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
            'If Not String.IsNullOrEmpty(txtIRNo.Text.Trim()) OrElse (Not String.IsNullOrEmpty(txtDateFrom.Text.Trim()) AndAlso Not String.IsNullOrEmpty(txtDateTo.Text.Trim())) Then
            divGrid.Visible = False
            lblStatus.Text = String.Empty
            Using cntx As New PortalModel.PortalEntities
                cntx.CommandTimeout = Int32.MaxValue
                BindGrid(cntx)
            End Using
            'Else
            '    lblStatus.ForeColor = Drawing.Color.Red
            '    lblStatus.Text = "Please enter I.R. No Or Date From And Date To!"
            'End If
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
            Response.AddHeader("content-disposition", "attachment;filename=OvertimeList.xls")
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
            lblStatus.Text = ex.Message
            lblStatus.ForeColor = Drawing.Color.Red
        End Try
    End Sub
End Class
