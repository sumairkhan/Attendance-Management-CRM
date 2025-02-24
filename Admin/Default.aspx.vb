Imports System.Web.UI.DataVisualization.Charting

Partial Class Admin_Default
    Inherits System.Web.UI.Page

    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(User.Identity.Name).ProviderUserKey)
    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Try
            lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
            Dim empID As Integer = lstEmployeeAndCompanyID(0)
            Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)
            Using cntx As New PortalModel.PortalEntities
                Dim obj = cntx.Employees.Where(Function(f) f.EmployeeID = empID).ToList().FirstOrDefault()
                If Not obj.JobStatus.ToLower().Trim().Equals("active") Then
                    Response.Redirect("Logout.aspx?isactive=1")
                End If

            End Using
        Catch ex As Exception

        End Try
    End Sub


    
End Class
