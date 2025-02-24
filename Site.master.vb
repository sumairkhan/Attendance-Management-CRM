Partial Class Admin_Site
    Inherits System.Web.UI.MasterPage
  

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Page.Header.DataBind()
            

        End If
    End Sub

 
End Class

