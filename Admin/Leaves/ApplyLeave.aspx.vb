
Partial Class Admin_Leaves_ApplyLeave
    Inherits System.Web.UI.Page
    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser.ProviderUserKey)
    Dim FileUploadPath As String = Server.MapPath(ConfigurationManager.AppSettings("FileUploadPath"))

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Try
                lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
                Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)

                Dim haveRights = PortalUtilities.fnHaveRights(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.Apply_Leave)
                If Not haveRights Then Response.Redirect("~/Admin/")



                txtFromDate.Text = Format(Date.Now.Date, "dd-MMM-yyyy")

                Using cntx As New PortalModel.PortalEntities


                    Dim objList = (From d In cntx.Departments Where d.IsDeleted Is Nothing OrElse d.IsDeleted = False Order By d.Title Select d.DepartmentID, d.Title).ToList

                    Dim dept = (From f In objList Select f.DepartmentID, f.Title Order By Title).Distinct()
                    With ddlDept
                        .DataValueField = "DepartmentID"
                        .DataTextField = "Title"
                        .DataSource = dept
                        .DataBind()
                        .Items.Insert(0, New ListItem("-- Select --", ""))
                    End With


                    Dim intEmpID As Integer = lstEmployeeAndCompanyID(0)


                    If Not String.IsNullOrEmpty(Request.QueryString("id")) AndAlso Request.QueryString("id") IsNot Nothing AndAlso IsNumeric(Request.QueryString("id")) Then
                        Dim intLeaveId As Integer = Request.QueryString("id")
                        ViewFields()
                        GetLeaveData(cntx, intLeaveId)
                        btnSave.Visible = False
                    Else

                        EditFields()
                    End If
                End Using
            Catch ex As Exception
                lblStatus.ForeColor = Drawing.Color.Red
                lblStatus.Text = ex.Message
                If ex.InnerException IsNot Nothing Then
                    lblStatus.Text = lblStatus.Text & "<br />" & ex.InnerException.Message
                End If
            End Try
        End If
    End Sub

    Private Sub ViewFields()
        txtFromDate.Enabled = False
        lblFromDate.Visible = False
        txtToDate.Enabled = False
        lblToDate.Visible = False
        ddlDept.Enabled = False
        ddlEmployee.Enabled = False
        btnSave.Visible = False
    End Sub

    Private Sub EditFields()

        ddlDept.Enabled = True

        ddlEmployee.Enabled = True

        txtFromDate.Visible = True
        lblFromDate.Visible = False


        txtToDate.Enabled = True
        lblToDate.Visible = False
    End Sub

    Protected Sub ddlDept_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles ddlDept.SelectedIndexChanged
        Try
            lblStatus.Text = String.Empty
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


        Dim objList = (From emp In cntx.sp_GetAllEmployees(Nothing, ddlDept.SelectedValue, Nothing, Nothing, Nothing, Nothing, Nothing)
                       Order By emp.FirstName
                       Select emp.EmployeeID, EmpName = emp.EmpCode + " - " + emp.FirstName + " " + emp.LastName).ToList()

        Dim obj = (From f In objList Select f.EmployeeID, f.EmpName).Distinct()
        With ddlEmployee
            .DataValueField = "EmployeeID"
            .DataTextField = "EmpName"
            .DataSource = obj
            .DataBind()
            .Items.Insert(0, New ListItem("-- Select --", ""))
        End With
    End Sub





    Protected Sub btnSave_Click(sender As Object, e As System.EventArgs) Handles btnSave.Click
        Try
            lblStatus.Text = String.Empty
            Using cntx As New PortalModel.PortalEntities
                SaveLeave(cntx)
            End Using


        Catch ex As Exception
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = "<br>Error in applying Leave: " & vbCrLf & ex.Message
        End Try
    End Sub

    Private Sub SaveLeave(cntx As PortalModel.PortalEntities)
        lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)

        Dim empID As Integer = ddlEmployee.SelectedValue
        Dim leaveID As Integer = hdnLeaveID.Value



        Dim obj As New PortalModel.EmployeeLeaves
        Dim objOld As New PortalModel.EmployeeLeaves
        If leaveID > 0 Then
            obj = cntx.EmployeeLeaves.Where(Function(f) f.EmployeeLeaveID = leaveID).ToList().FirstOrDefault()
            objOld = New PortalModel.PortalEntities().EmployeeLeaves.Where(Function(f) f.EmployeeLeaveID = leaveID).ToList().FirstOrDefault()
        End If

        Dim objExist = cntx.sp_GetLeaves(Nothing, Nothing, txtFromDate.Text, txtToDate.Text, empID, Nothing, Nothing).ToList()
        If leaveID > 0 Then
            objExist = objExist.Where(Function(f) f.EmployeeLeaveID <> leaveID).ToList()
        End If

        If objExist.Count > 0 Then
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = "<br>Already applied"
            Exit Sub
        End If


        With obj
            .EmployeeID = empID
            .FromDate = txtFromDate.Text
            .ToDate = txtToDate.Text
        End With

        If leaveID = 0 Then
            obj.InsertedBy = lstEmployeeAndCompanyID(0)
            obj.InsertedDate = DateTime.Now
            obj.IsDeleted = False
            cntx.EmployeeLeaves.AddObject(obj)
        End If


        cntx.SaveChanges()
        hdnLeaveID.Value = obj.EmployeeLeaveID

        If leaveID > 0 Then
            Try
                PortalUtilities.fnCompare(CType(objOld, Object), CType(obj, Object), obj.EmployeeLeaveID, lstEmployeeAndCompanyID(0))
            Catch ex As Exception

            End Try
        End If

        lblStatus.ForeColor = Drawing.Color.DarkGreen
        lblStatus.Text = "Leave Applied Successfully"


        ViewFields()
    End Sub

    Private Sub GetLeaveData(cntx As PortalModel.PortalEntities, ByVal intID As Integer)
        Dim obj = cntx.sp_GetLeaves(intID, Nothing, Nothing, Nothing, Nothing, Nothing, Nothing).ToList().FirstOrDefault()
        If obj Is Nothing Then Response.Redirect("~/Admin/")


        ddlDept.SelectedValue = obj.DepartmentID
        ddlDept_SelectedIndexChanged(Nothing, Nothing)

        ddlEmployee.SelectedValue = obj.EmployeeID
        hdnLeaveID.Value = intID
        Dim objEmp = cntx.Employees.Where(Function(f) f.EmployeeID = obj.EmployeeID).ToList().FirstOrDefault()
        txtFromDate.Text = Format(obj.FromDate, "dd-MMM-yyyy")
        lblFromDate.Text = Format(obj.FromDate, "dd-MMM-yyyy")
        txtToDate.Text = Format(obj.FromDate, "dd-MMM-yyyy")
        lblToDate.Text = Format(obj.FromDate, "dd-MMM-yyyy")
        ViewFields()
    End Sub


End Class
