
Partial Class Login
    Inherits System.Web.UI.Page

    Protected Sub LoginUser_Load(sender As Object, e As System.EventArgs) Handles LoginUser.Load
        If Not IsNothing(Request.QueryString("isactive")) AndAlso Request.QueryString("isactive") = 1 Then
            Dim lbl As Label = LoginUser.FindControl("lblErr")
            lbl.Text = "Invalid User Name or Password"
            lbl.Visible = True
        End If
    End Sub

    Protected Sub LoginUser_LoggedIn(sender As Object, e As System.EventArgs) Handles LoginUser.LoggedIn
        
        
    End Sub


    Protected Sub LoginUser_LoginError(ByVal sender As Object, ByVal e As System.EventArgs) Handles LoginUser.LoginError
        Dim lbl As Label = LoginUser.FindControl("lblErr")
        lbl.Text = "Invalid User Name or Password"
        lbl.Visible = True

    End Sub

End Class
