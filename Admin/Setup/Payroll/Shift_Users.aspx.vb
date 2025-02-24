
Partial Class Admin_Setup_Payroll_Shift_Users
    Inherits System.Web.UI.Page
    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(User.Identity.Name).ProviderUserKey)

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

        Dim haveRights = PortalUtilities.fnHaveRights(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.Employee_Shifts)
        If Not haveRights Then Response.Redirect("~/Admin/default.aspx?returnURL=" & HttpContext.Current.Request.Url.AbsoluteUri)

        'Using cntx As New PortalModel.PortalEntities
        '    lstEmployeeAndCompanyID = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(HttpContext.Current.User.Identity.Name).ProviderUserKey)
        '    Dim intCompanyID As Integer = lstEmployeeAndCompanyID(1)
        '    Dim objEmpRights = cntx.sp_GetPageRightsByEmpAndMenuLinkID(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.Employee_Shifts).Where(Function(f) f.EmpRightID > 0).ToList()

        '    If objEmpRights.Count <= 0 Then
        '        Response.Redirect("~/Admin/")
        '    End If

        'End Using
    End Sub
End Class
