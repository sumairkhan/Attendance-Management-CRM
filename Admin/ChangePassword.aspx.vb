
Partial Class Admin_ChangePassword
    Inherits System.Web.UI.Page
    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(User.Identity.Name).ProviderUserKey)
    Dim strUserName As String = User.Identity.Name
    Dim strRole As String = String.Empty
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            If strUserName Is Nothing Then Response.Redirect("~/Admin/")

            Using cntx As New PortalModel.PortalEntities
                Dim intEmpID As Integer = lstEmployeeAndCompanyID(0)
                Dim objEmpLinks = cntx.EmpLinks.Where(Function(f) f.EmpID = intEmpID AndAlso f.MenuLinkID = PortalUtilities.MenuLinks.ChangePassword).ToList()
                If objEmpLinks.Count <= 0 Then Response.Redirect("~/Admin/")

                Dim user = Membership.GetUser(strUserName)
                If user Is Nothing Then
                    lblUserName.Text = "-- Invalid User --"
                    btnChangePassword.Enabled = False
                    txtPassword.Enabled = False
                    txtConfirmPassword.Enabled = False
                Else
                    lblUserName.Text = user.UserName
                    'txtEmailAddress.Text = user.Email
                    lblUserRole.Text = System.Threading.Thread.CurrentThread.CurrentCulture.TextInfo.ToTitleCase(Roles.GetRolesForUser(strUserName)(0))
                    strRole = System.Threading.Thread.CurrentThread.CurrentCulture.TextInfo.ToTitleCase(Roles.GetRolesForUser(strUserName)(0))

                    'Dim objEmployee = cntx.Employees.Where(Function(f) f.EmployeeID = intEmpID).ToList().FirstOrDefault()
                    'txtEmailAddress.Text = objEmployee.Email
                End If
            End Using
        End If
    End Sub

    Protected Sub btnChangePassword_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnChangePassword.Click
        Try
            Dim user = Membership.GetUser(lblUserName.Text.Trim())
            user.ChangePassword(user.ResetPassword(), txtPassword.Text)

            lblStatus.Text = "Password changed successfully"
            lblStatus.ForeColor = Drawing.Color.DarkGreen
        Catch ex As Exception
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = ex.Message
        End Try
    End Sub

    'Protected Sub btnUpdateEmail_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btnUpdateEmail.Click
    '    Try
    '        'Dim user = Membership.GetUser(lblUserName.Text)
    '        'user.Email = txtEmailAddress.Text
    '        'Membership.UpdateUser(user)
    '        Using cntx As New PortalModel.PortalEntities
    '            Dim intEmpID = lstEmployeeAndCompanyID(0)
    '            Dim objEmployee = cntx.Employees.Where(Function(f) f.EmployeeID = intEmpID).ToList().FirstOrDefault()
    '            Dim isExists = cntx.Employees.Where(Function(f) f.EmployeeID <> intEmpID AndAlso f.Email.Trim().ToLower().Equals(txtEmailAddress.Text.Trim().ToLower())).ToList().Count
    '            If isExists <= 0 Then
    '                objEmployee.Email = txtEmailAddress.Text.Trim()
    '                cntx.SaveChanges()

    '                lblStatus.Text = "Email Updated Successfully"
    '                lblStatus.ForeColor = Drawing.Color.DarkGreen
    '            Else
    '                lblStatus.Text = "Email already exists!"
    '                lblStatus.ForeColor = Drawing.Color.Red
    '            End If
    '        End Using
    '    Catch ex As Exception
    '        lblStatus.ForeColor = Drawing.Color.Red
    '        lblStatus.Text = ex.Message
    '    End Try
    'End Sub
End Class
