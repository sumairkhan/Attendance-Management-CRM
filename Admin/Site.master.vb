Partial Class Admin_Site
    Inherits System.Web.UI.MasterPage
    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser.ProviderUserKey)


    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Page.Header.DataBind()
            Dim UserID As Guid = Membership.GetUser.ProviderUserKey

            Using cntx As New PortalModel.PortalEntities
                If Roles.IsUserInRole(HttpContext.Current.User.Identity.Name, "admin") Then
                    Dim objPanels = (From p In cntx.MenuPanels
                                     Order By p.DisplayOrder
                                     Select p.PanelID, p.PanelTitle)
                    rptrMenuPanels.DataSource = objPanels
                    rptrMenuPanels.DataBind()
                Else

                    Dim objPanels = (From el In cntx.EmpLinks
                                    Join emp In cntx.Employees On el.EmpID Equals emp.EmployeeID
                                    Join ml In cntx.MenuLinks On el.MenuLinkID Equals ml.MenuLinkID
                                    Join m In cntx.Menus On ml.MenuID Equals m.MenuID
                                    Join mp In cntx.MenuPanels On mp.PanelID Equals m.PanelID
                                    Where emp.UserId = UserID
                                    Select mp.PanelID, mp.PanelTitle, mp.DisplayOrder).Distinct().OrderBy(Function(f) f.DisplayOrder).ToList()
                    rptrMenuPanels.DataSource = objPanels
                    rptrMenuPanels.DataBind()
                End If



                Dim haveChangePassword = PortalUtilities.fnHaveRights(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.ChangePassword)
                If haveChangePassword Then
                    sideMenuLinkPassword.Visible = True
                    sideMenuDivider.Visible = True
                End If


                Dim haveProfile = PortalUtilities.fnHaveRights(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.Profile)
                If haveProfile Then
                    sideMenuLinkProfile.Visible = True
                    sideMenuDivider.Visible = True
                End If



            End Using

        End If
    End Sub

    Protected Sub rptrMenuPanels_ItemDataBound(sender As Object, e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rptrMenuPanels.ItemDataBound
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim UserID As Guid = Membership.GetUser.ProviderUserKey
            Dim intID As Integer = DataBinder.Eval(e.Item.DataItem, "PanelID")
            Dim rptrMenus As Repeater = e.Item.FindControl("rptrMenus")
            Using cntx As New PortalModel.PortalEntities
                If Roles.IsUserInRole(HttpContext.Current.User.Identity.Name, "admin") Then
                    Dim lblID As Label = e.Item.FindControl("lblID")
                    Dim objMenus = (From m In cntx.Menus Where m.PanelID = lblID.Text
                                    Order By m.DisplayOrder Select m.MenuID, m.MenuTitle)
                    rptrMenus.DataSource = objMenus
                    rptrMenus.DataBind()
                Else
                    Dim objMenus = (From el In cntx.EmpLinks
                                Join emp In cntx.Employees On emp.EmployeeID Equals el.EmpID
                                Join ml In cntx.MenuLinks On el.MenuLinkID Equals ml.MenuLinkID
                                Join m In cntx.Menus On ml.MenuID Equals m.MenuID
                                Where emp.UserId = UserID And m.PanelID = intID
                                Select m.MenuID, m.MenuTitle, m.DisplayOrder).Distinct().OrderBy(Function(f) f.DisplayOrder).ToList()
                    rptrMenus.DataSource = objMenus
                    rptrMenus.DataBind()
                End If

            End Using
        End If
    End Sub

    Protected Sub rptrMenus_ItemDataBound(sender As Object, e As System.Web.UI.WebControls.RepeaterItemEventArgs)
        If e.Item.ItemType = ListItemType.Item Or e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim UserID As Guid = Membership.GetUser.ProviderUserKey
            Dim intID As Integer = DataBinder.Eval(e.Item.DataItem, "MenuID")
            Dim rptrMenuLinks As Repeater = e.Item.FindControl("rptrMenuLinks")
            Using cntx As New PortalModel.PortalEntities
                If Roles.IsUserInRole(HttpContext.Current.User.Identity.Name, "admin") Then
                    Dim lblID As Label = e.Item.FindControl("lblID")
                    Dim objMenuLinks = (From ml In cntx.MenuLinks Where ml.MenuID = lblID.Text
                                        Order By ml.DisplayOrder Select ml.MenuLinkText, ml.PageURL)
                    rptrMenuLinks.DataSource = objMenuLinks
                    rptrMenuLinks.DataBind()
                Else
                    Dim objMenuLinks = (From el In cntx.EmpLinks
                                Join emp In cntx.Employees On emp.EmployeeID Equals el.EmpID
                                Join ml In cntx.MenuLinks On el.MenuLinkID Equals ml.MenuLinkID
                                Join m In cntx.Menus On ml.MenuID Equals m.MenuID
                                Where emp.UserId = UserID And m.MenuID = intID
                                Select ml.MenuLinkText, ml.PageURL, ml.DisplayOrder).Distinct().OrderBy(Function(f) f.DisplayOrder).ToList()

                    rptrMenuLinks.DataSource = objMenuLinks
                    rptrMenuLinks.DataBind()
                End If

            End Using
        End If
    End Sub

End Class

