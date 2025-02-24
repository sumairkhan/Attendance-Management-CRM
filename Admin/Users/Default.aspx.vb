
Partial Class Admin_Users_Default
    Inherits System.Web.UI.Page
    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(User.Identity.Name).ProviderUserKey)

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim haveRights = PortalUtilities.fnHaveRights(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.AddUser)
            If Not haveRights Then Response.Redirect("~/Admin/")
            Using cntx As New PortalModel.PortalEntities
                Dim dept = (From d In cntx.Departments Order By d.Title Select d.DepartmentID, d.Title).ToList
                dept = dept.Where(Function(f) Not f.Title.ToLower().Trim().Equals("superadmin")).ToList()
                With ddlDept
                    .DataValueField = "DepartmentID"
                    .DataTextField = "Title"
                    .DataSource = dept
                    .DataBind()
                    .Items.Insert(0, New ListItem("-- Select --", ""))
                End With
            End Using
        End If
    End Sub

    Protected Sub ddlDept_TextChanged(sender As Object, e As System.EventArgs) Handles ddlDept.TextChanged
        Try
            If Not String.IsNullOrEmpty(ddlDept.SelectedValue) AndAlso ddlDept.SelectedValue > 0 Then
                Using cntx As New PortalModel.PortalEntities
                    Dim emp = (From empl In cntx.Employees
                               Where empl.UserId Is Nothing And empl.DepartmentID = ddlDept.SelectedValue
                               Order By empl.FirstName
                               Select empl.EmployeeID, EmpName = empl.FirstName).ToList()
                    With ddlEmployee
                        .DataValueField = "EmployeeID"
                        .DataTextField = "EmpName"
                        .DataSource = emp
                        .DataBind()
                    End With

                End Using
            Else
                ddlEmployee.Items.Clear()
                txtLoginName.Text = String.Empty
                txtPassword.Text = String.Empty
                txtConfirmPassword.Text = String.Empty
            End If
        Catch ex As Exception
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = ex.Message
        End Try
    End Sub


    Protected Sub btnSave_Click(sender As Object, e As System.EventArgs) Handles btnSave.Click
        Dim UserCreated As Boolean = False
        Try
            Dim countAlreadyExists = Membership.GetUser(txtLoginName.Text)

            If countAlreadyExists Is Nothing Then
                Membership.CreateUser(txtLoginName.Text, txtPassword.Text)
                Roles.AddUserToRole(txtLoginName.Text, "user")
                UserCreated = True


                Using cntx As New PortalModel.PortalEntities
                    Dim emp = (From empl In cntx.Employees Where empl.EmployeeID = ddlEmployee.SelectedValue).FirstOrDefault
                    emp.UserId = Membership.GetUser(txtLoginName.Text.Trim).ProviderUserKey
                    cntx.SaveChanges()
                End Using


                lblStatus.ForeColor = Drawing.Color.DarkGreen
                lblStatus.Text = "User Created Successfully..."

                ddlDept.SelectedIndex = 0
                ddlEmployee.Items.Clear()
                txtLoginName.Text = String.Empty
                txtPassword.Text = String.Empty
                txtConfirmPassword.Text = String.Empty
            Else
                lblStatus.ForeColor = Drawing.Color.DarkRed
                lblStatus.Text = "Username already exists!"
            End If

        Catch ex As Exception
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = ex.Message
            If UserCreated Then
                Membership.DeleteUser(txtLoginName.Text.Trim)
            End If
        End Try
    End Sub

End Class
