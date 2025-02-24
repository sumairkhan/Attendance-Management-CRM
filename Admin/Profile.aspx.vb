
Partial Class Admin_Profile
    Inherits System.Web.UI.Page
    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(User.Identity.Name).ProviderUserKey)
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Using cntx As New PortalModel.PortalEntities
                Dim dept = (From d In cntx.Departments Order By d.Title Select d.DepartmentID, d.Title).ToList
                With ddlDept
                    .DataValueField = "DepartmentID"
                    .DataTextField = "Title"
                    .DataSource = dept
                    .DataBind()
                End With

                Dim intEmpID = lstEmployeeAndCompanyID(0)
                Dim objEmployee = cntx.Employees.Where(Function(f) f.EmployeeID = intEmpID).ToList().FirstOrDefault()
                Dim intDeptID = lstEmployeeAndCompanyID(2)
                Dim objDept = cntx.Departments.Where(Function(f) f.DepartmentID = intDeptID).ToList().FirstOrDefault()

                lblFirstName.Text = objEmployee.FirstName
                lblLastName.Text = objEmployee.LastName
                ddlDept.SelectedValue = objDept.DepartmentID
                lblDepartment.Text = objDept.Title
                ddlDept.Visible = False
                lblDepartment.Visible = True
                ddlDept.Visible = False
                lblDepartment.Visible = True
            End Using
        End If
    End Sub


End Class
