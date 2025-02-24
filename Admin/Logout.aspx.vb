
Partial Class Admin_Logout
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        HttpContext.Current.Session.Abandon()
        FormsAuthentication.SignOut()
        If Not IsNothing(Request.QueryString("isactive")) AndAlso Request.QueryString("isactive") = 1 Then
            HttpContext.Current.Response.Redirect("~/Login.aspx?isactive=1")
        Else
            HttpContext.Current.Response.Redirect("~/Login.aspx")
        End If

    End Sub
End Class
