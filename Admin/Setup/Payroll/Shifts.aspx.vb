
Partial Class Admin_Setup_Payroll_Shifts
    Inherits System.Web.UI.Page
    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(User.Identity.Name).ProviderUserKey)

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        Dim haveRights = PortalUtilities.fnHaveRights(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.Manage_Shifts)
        If Not haveRights Then Response.Redirect("~/Admin/default.aspx?returnURL=" & HttpContext.Current.Request.Url.AbsoluteUri)
    End Sub
End Class
