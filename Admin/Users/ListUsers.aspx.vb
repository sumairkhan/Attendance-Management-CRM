
Partial Class Admin_Users_ListUsers
    Inherits System.Web.UI.Page
    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(User.Identity.Name).ProviderUserKey)

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim haveRights = PortalUtilities.fnHaveRights(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.ListUsers)
            If Not haveRights Then Response.Redirect("~/Admin/")
            Try
                Using cntx As New PortalModel.PortalEntities
                    Dim obj = (From d In cntx.Departments
                               Order By d.Title Select d.DepartmentID, d.Title).ToList()
                    obj = obj.Where(Function(f) Not f.Title.ToLower().Trim().Equals("superadmin")).ToList()
                    With ddlDept
                        .DataValueField = "DepartmentID"
                        .DataTextField = "Title"
                        .DataSource = obj
                        .DataBind()
                        .Items.Insert(0, New ListItem("-- Select Department --", ""))
                    End With
                End Using
            Catch ex As Exception
                lblStatus.Text = ex.Message
            End Try
        End If
    End Sub

    Protected Sub ddlDept_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles ddlDept.SelectedIndexChanged
        Try
            lblStatus.Text = String.Empty
            pnlDetails.Visible = True
            Using cntx As New PortalModel.PortalEntities
                GetUsers(cntx)
            End Using
        Catch ex As Exception
            pnlDetails.Visible = False
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = ex.Message
            If ex.InnerException IsNot Nothing Then
                lblStatus.Text = lblStatus.Text & "<br />" & ex.InnerException.Message
            End If
        End Try
    End Sub

    Protected Sub GetUsers(cntx As PortalModel.PortalEntities)
        Dim obj = (From emp In cntx.Employees
                   Join u In cntx.aspnet_Users On emp.UserId Equals u.UserId
                   Where emp.DepartmentID = ddlDept.SelectedValue And (emp.IsDeleted = False Or emp.IsDeleted Is Nothing)
                   Order By emp.FirstName
                   Select emp.EmployeeID, EmpName = emp.FirstName, u.UserName)
        grd.DataSource = obj
        grd.DataBind()
        If obj.Count > 0 Then
            grd.DataSource = obj
            grd.DataBind()
        Else
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = "0 records found in selected department!"
        End If
    End Sub

    Protected Sub grd_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles grd.RowCommand
        If e.CommandName = "chngStatus" Then
            Try

                Dim RowIndex As Integer = Integer.Parse(e.CommandArgument.ToString)
                Dim UserName As String = grd.Rows(RowIndex).Cells(0).Text
                Dim usr As MembershipUser = Membership.GetUser(UserName)
                If UserName = "admin" Then
                    lblStatus.ForeColor = Drawing.Color.Red
                    lblStatus.Text = "admin user can not be blocked."
                Else
                    usr.IsApproved = Not usr.IsApproved
                    Membership.UpdateUser(usr)
                    lblStatus.ForeColor = Drawing.Color.DarkGreen
                    lblStatus.Text = "User status has been updated."
                    Using cntx As New PortalModel.PortalEntities
                        GetUsers(cntx)
                    End Using
                End If
            Catch ex As Exception
                lblStatus.ForeColor = Drawing.Color.Red
                lblStatus.Text = ex.Message
            End Try
        ElseIf e.CommandName = "chngPwd" Then
            Try

                Dim RowIndex As Integer = Integer.Parse(e.CommandArgument.ToString)
                Dim UserName As String = grd.Rows(RowIndex).Cells(0).Text
                Dim usr As MembershipUser = Membership.GetUser(UserName)
                Dim user = Membership.GetUser(UserName)
                user.ChangePassword(user.ResetPassword(), UserName & "@12345")

                lblStatus.Text = "Password updated with: " & UserName & "@12345"
                lblStatus.ForeColor = Drawing.Color.DarkGreen
            Catch ex As Exception
                lblStatus.ForeColor = Drawing.Color.Red
                lblStatus.Text = ex.Message
            End Try
        End If
    End Sub

    Protected Sub grd_RowDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grd.RowDataBound
        If e.Row.RowType = DataControlRowType.DataRow Then
            Dim UserName As String = e.Row.Cells(0).Text
            Dim usr As MembershipUser = Membership.GetUser(UserName)
            Dim imgStatus As Image = e.Row.FindControl("imgStatus")

            If usr.IsApproved Then
                imgStatus.ImageUrl = "~/Admin/images/icoactive.png"
            Else
                imgStatus.ImageUrl = "~/Admin/images/icoblocked.png"
            End If
        End If
    End Sub

End Class
