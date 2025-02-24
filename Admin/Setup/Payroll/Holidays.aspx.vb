
Partial Class Admin_Setup_Payroll_Holidays
    Inherits System.Web.UI.Page
    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(User.Identity.Name).ProviderUserKey)

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        Dim haveRights = PortalUtilities.fnHaveRights(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.ManageHolidays)
        If Not haveRights Then Response.Redirect("~/Admin/")
    End Sub
End Class
