
Partial Class Admin_Leaves_LeavesList
    Inherits System.Web.UI.Page

    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(User.Identity.Name).ProviderUserKey)
    'Dim companyID As Integer = lstEmployeeAndCompanyID(1)

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
            Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)

            Dim haveRights = PortalUtilities.fnHaveRights(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.Leaves_List)
            If Not haveRights Then Response.Redirect("~/Admin/")
            txtDateFrom.Text = Format(Date.Now.Date.AddDays(-3), "dd-MMM-yyyy")
            txtDateTo.Text = Format(Date.Now.Date.AddDays(3), "dd-MMM-yyyy")
            Using cntx As New PortalModel.PortalEntities


                Dim objListDept = (From d In cntx.Departments Where d.IsDeleted Is Nothing OrElse d.IsDeleted = False Order By d.Title Select d.DepartmentID, d.Title).ToList




                Dim dept = (From f In objListDept Select f.DepartmentID, f.Title Order By Title).Distinct()

                With ddlDept
                    .DataValueField = "DepartmentID"
                    .DataTextField = "Title"
                    .DataSource = dept
                    .DataBind()
                    .Items.Insert(0, New ListItem("-- All --", ""))
                End With


            End Using
            btnShow_Click(Nothing, Nothing)
        End If
    End Sub






    Private Sub BindGrid(ByVal cntx As PortalModel.PortalEntities)
        Dim dtFrom As Date? = Nothing
        Dim dtTo As Date? = Nothing
        Dim intID As Integer? = Nothing
        Dim intTypeID As Integer? = Nothing
        Dim intEmpID As Integer? = Nothing
        Dim intDeptID As Integer? = Nothing
        Dim strEmpCode As String = Nothing



        If IsDate(txtDateFrom.Text.Trim()) Then
            dtFrom = Convert.ToDateTime(txtDateFrom.Text.Trim()).Date
        End If

        If IsDate(txtDateTo.Text.Trim()) Then
            dtTo = Convert.ToDateTime(txtDateTo.Text.Trim()).Date
        End If

        If Not String.IsNullOrEmpty(ddlEmployee.SelectedValue) AndAlso ddlEmployee.SelectedValue > 0 Then
            intEmpID = ddlEmployee.SelectedValue
        End If

        If Not String.IsNullOrEmpty(ddlDept.SelectedValue) AndAlso ddlDept.SelectedValue > 0 Then
            intDeptID = ddlDept.SelectedValue
        End If

        Dim objList = cntx.sp_GetLeaves(intID, intTypeID, dtFrom, dtTo, intEmpID, intDeptID, strEmpCode).OrderByDescending(Function(f) f.EmployeeLeaveID).ToList()


        grd.DataSource = objList
        grd.DataBind()
        If objList.Count > 0 Then
            divGrid.Visible = True
        Else
            divGrid.Visible = False
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = "No records found!"
        End If


    End Sub

    Protected Sub btnShow_Click(sender As Object, e As System.EventArgs) Handles btnShow.Click
        Try
            lblStatus.Text = String.Empty
            divGrid.Visible = False
            Using cntx As New PortalModel.PortalEntities
                BindGrid(cntx)
            End Using

        Catch ex As Exception
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = ex.Message
        End Try

    End Sub
    Protected Sub grd_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles grd.RowDeleting
        Using cntx As New PortalModel.PortalEntities
            Dim id As Integer = grd.DataKeys(e.RowIndex).Value
            Try
                Dim obj = New PortalModel.EmployeeLeaves With {.EmployeeLeaveID = id}
                With cntx
                    .EmployeeLeaves.Attach(obj)
                    '.Products.DeleteObject(obj)
                    obj.DeletedBy = lstEmployeeAndCompanyID(0)
                    obj.DeletedDate = DateTime.Now
                    obj.IsDeleted = True
                    .SaveChanges()
                End With
                BindGrid(cntx)
                Me.lblStatus.ForeColor = Drawing.Color.DarkGreen
                Me.lblStatus.Text = "Leave Deleted Successfully."
            Catch ex As Exception
                lblStatus.ForeColor = Drawing.Color.Red
                lblStatus.Text = "This record is in use and can not be deleted. <br />" & ex.Message
            End Try
        End Using
    End Sub


    Private Sub btnExport_Click(sender As Object, e As EventArgs) Handles btnExport.Click
        Try

            Response.ClearContent()
            Response.Buffer = True
            Response.AddHeader("content-disposition", "attachment;filename=LeavesList.xls")
            Response.Charset = ""
            Response.ContentType = "application/vnd.ms-excel"


            grd.Columns(4).Visible = False
            grd.Columns(5).Visible = False



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
                'Dim style As String = "<style> .textmode { } </style>"
                'Response.Write(style)
                Response.Output.Write(sw.ToString())
                Response.Flush()
                Response.End()
                'HttpContext.Current.Response.Flush() ' Sends all currently buffered output to the client.
                'Response.SuppressContent = True ' Gets or sets a value indicating whether to send HTTP content to the client.
                'HttpContext.Current.ApplicationInstance.CompleteRequest() ' Causes ASP.NET to bypass all events and filtering in the HTTP pipeline chain of execution and directly execute the EndRequest event.

                grd.Columns(4).Visible = True
                grd.Columns(5).Visible = True

            End Using
        Catch ex As Exception
            lblStatus.Text = ex.Message
            lblStatus.ForeColor = Drawing.Color.Red
        End Try
    End Sub

    Public Overrides Sub VerifyRenderingInServerForm(control As Control)
        Return
    End Sub

    Private Sub ddlDept_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ddlDept.SelectedIndexChanged
        Try
            lblStatus.Text = String.Empty
            ddlEmployee.Items.Clear()
            If Not String.IsNullOrEmpty(ddlDept.SelectedValue) AndAlso ddlDept.SelectedValue > 0 Then
                Using cntx As New PortalModel.PortalEntities

                    'If Not String.IsNullOrEmpty(ddlDept.SelectedValue) AndAlso ddlDept.SelectedValue > 0 Then
                    GetEmployees(cntx)
                    'End If
                End Using

            End If
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
                       Select emp.EmployeeID, EmpName = emp.FirstName + " " + emp.LastName).ToList()

        Dim obj = (From f In objList Select f.EmployeeID, f.EmpName).Distinct()

        With ddlEmployee
            .DataValueField = "EmployeeID"
            .DataTextField = "EmpName"
            .DataSource = obj
            .DataBind()
            .Items.Insert(0, New ListItem("-- All --", ""))
        End With
    End Sub


End Class
