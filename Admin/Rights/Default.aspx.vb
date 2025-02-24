
Partial Class Admin_Rights_Default
    Inherits System.Web.UI.Page
    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(User.Identity.Name).ProviderUserKey)

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Try
            If Not Page.IsPostBack Then
                Dim haveRights = PortalUtilities.fnHaveRights(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.ManageRights)
                If Not haveRights Then Response.Redirect("~/Admin/")

                Using cntx As New PortalModel.PortalEntities
                    Dim obj = (From d In cntx.Departments
                               Order By d.Title Select d.DepartmentID, d.Title).ToList()

                    Dim strDeptTitle = String.Empty
                    If lstEmployeeAndCompanyID(2) > 0 Then
                        strDeptTitle = obj.Where(Function(f) f.DepartmentID = lstEmployeeAndCompanyID(2)).ToList().FirstOrDefault().Title
                    End If

                    If Not strDeptTitle.Trim().ToLower.Equals("superadmin") Then
                        obj = obj.Where(Function(f) Not f.Title.ToLower().Trim().Equals("superadmin")).ToList()
                    End If

                    With ddlDept
                        .DataValueField = "DepartmentID"
                        .DataTextField = "Title"
                        .DataSource = obj
                        .DataBind()
                        .Items.Insert(0, New ListItem("-- Select Department --", ""))
                    End With
                End Using
            End If
        Catch ex As Exception
            lblStatus.Text = ex.Message
        End Try
    End Sub

    Protected Sub ddlDept_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles ddlDept.SelectedIndexChanged
        Try
            lblStatus.Text = String.Empty
            pnlDetails.Visible = False
            Using cntx As New PortalModel.PortalEntities
                GetEmployees(cntx)
            End Using
        Catch ex As Exception
            pnlDetails.Visible = False
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = ex.Message
            If ex.InnerException IsNot Nothing Then
                lblStatus.Text = lblStatus.Text & "<br />" & ex.InnerException.Message
            End If
        End Try
    End Sub

    Protected Sub GetEmployees(cntx As PortalModel.PortalEntities)
        Dim obj = (From emp In cntx.Employees
                   Where emp.DepartmentID = ddlDept.SelectedValue And (emp.IsDeleted = False Or emp.IsDeleted Is Nothing)
                   Order By emp.FirstName
                   Select emp.EmployeeID, EmpName = emp.FirstName)
        With ddlEmp
            .DataValueField = "EmployeeID"
            .DataTextField = "EmpName"
            .DataSource = obj
            .DataBind()
            .Items.Insert(0, New ListItem("-- Select Employee --", ""))
        End With
    End Sub

    Protected Sub ddlEmp_SelectedIndexChanged(sender As Object, e As System.EventArgs) Handles ddlEmp.SelectedIndexChanged
        Try
            lblStatus.Text = String.Empty
            pnlDetails.Visible = True
            Using cntx As New PortalModel.PortalEntities
                GetRights(cntx)
            End Using
        Catch ex As Exception
            pnlDetails.Visible = False
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = ex.Message
            If ex.InnerException IsNot Nothing Then
                lblStatus.Text = lblStatus.Text & "<br />" & ex.InnerException.Message
            End If
        End Try
    End Sub

    Protected Sub GetRights(cntx As PortalModel.PortalEntities)
        Dim assigned = cntx.sp_GetEmpAssignedRights(ddlEmp.SelectedValue).ToList
        grdAssignedRights.DataSource = assigned
        grdAssignedRights.DataBind()

        Dim nonassigned = cntx.sp_GetEmpNonAssignedRights(ddlEmp.SelectedValue).ToList
        grdNonAssignedRights.DataSource = nonassigned
        grdNonAssignedRights.DataBind()


    End Sub

    Protected Sub btnSave_Click(sender As Object, e As System.EventArgs) Handles btnSave.Click
        Try
            lblStatus.Text = ""
            lblMsg.Text = ""

            Dim intEmpId As Integer = ddlEmp.SelectedValue
            Dim intMenuLinkID As Integer

            Using cntx As New PortalModel.PortalEntities
                For Each row As GridViewRow In grdNonAssignedRights.Rows
                    Dim chk As CheckBox = row.FindControl("chkLink")
                    If chk.Checked = True Then
                        intMenuLinkID = grdNonAssignedRights.DataKeys(row.RowIndex).Value
                        Dim objEmpLinks As New PortalModel.EmpLinks

                        With objEmpLinks
                            .EmpID = intEmpId
                            .MenuLinkID = intMenuLinkID
                        End With
                        cntx.EmpLinks.AddObject(objEmpLinks)

                        'Dim rptInnerRights As Repeater = row.FindControl("rptInnerRights")
                        'For Each rptItem As RepeaterItem In rptInnerRights.Items
                        '    Dim chkInner As CheckBox = rptItem.FindControl("chkInnerLink")
                        '    If chkInner.Checked Then
                        '        Dim objEmpRights As New PortalModel.EmpRights
                        '        Dim intPageRightID As Integer = DirectCast(rptItem.FindControl("hdnPageRightID"), HiddenField).Value
                        '        With objEmpRights
                        '            .EmployeeID = intEmpId
                        '            .PageRightID = intPageRightID
                        '        End With
                        '        cntx.EmpRights.AddObject(objEmpRights)
                        '    End If
                        'Next

                        Dim grdInnerRights As GridView = row.FindControl("grdNonAssignedRightsInner")
                        For Each rptItem In grdInnerRights.Rows
                            Try
                                Dim chkInner As CheckBox = rptItem.FindControl("chkInnerLink")
                                Dim intPageRightID As Integer = DirectCast(rptItem.FindControl("hdnPageRightID"), HiddenField).Value
                                If chkInner.Checked Then
                                    Dim objEmpRights As New PortalModel.EmpRights
                                    With objEmpRights
                                        .EmployeeID = intEmpId
                                        .PageRightID = intPageRightID
                                    End With
                                    cntx.EmpRights.AddObject(objEmpRights)
                                Else
                                    Dim objExisting = cntx.EmpRights.Where(Function(f) f.EmployeeID = intEmpId AndAlso f.PageRightID = intPageRightID).ToList().FirstOrDefault()
                                    If objExisting IsNot Nothing Then
                                        cntx.EmpRights.DeleteObject(objExisting)
                                    End If
                                End If

                            Catch ex As Exception

                            End Try
                        Next

                    End If
                Next


                For Each rowParent As GridViewRow In grdAssignedRights.Rows
                    Dim grdInner As GridView = rowParent.FindControl("grdAssignedRightsInner")
                    Dim MenuLinkID As Integer = DirectCast(rowParent.FindControl("hdnMenuLinkID"), HiddenField).Value

                    For Each row As GridViewRow In grdInner.Rows
                        Dim chkInner As CheckBox = row.FindControl("chkInnerLink")
                        Try
                            Dim intPageRightID As Integer = DirectCast(row.FindControl("hdnPageRightID"), HiddenField).Value
                            Dim objExisting = cntx.EmpRights.Where(Function(f) f.EmployeeID = intEmpId AndAlso f.PageRightID = intPageRightID).ToList().FirstOrDefault()
                            If objExisting IsNot Nothing Then
                                cntx.EmpRights.DeleteObject(objExisting)
                            End If
                            If chkInner.Checked Then
                                Dim objEmpRights As New PortalModel.EmpRights
                                With objEmpRights
                                    .EmployeeID = intEmpId
                                    .PageRightID = intPageRightID
                                End With
                                cntx.EmpRights.AddObject(objEmpRights)
                            End If

                        Catch ex As Exception

                        End Try
                    Next
                Next

                cntx.SaveChanges()
                GetRights(cntx)
                lblMsg.ForeColor = Drawing.Color.DarkGreen
                lblMsg.Text = "Rights updated successfully..."

            End Using

        Catch ex As Exception

        End Try
    End Sub

    Protected Sub grdAssignedRights_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdAssignedRights.RowDataBound
        Try
            Dim intEmpId As Integer = ddlEmp.SelectedValue
            Using cntx As New PortalModel.PortalEntities
                If e.Row.RowType = DataControlRowType.DataRow Then
                    'Dim rptInnerRights As Repeater = e.Row.FindControl("rptInnerRights")
                    Dim grdInnerRights As GridView = e.Row.FindControl("grdAssignedRightsInner")
                    Dim intMenuLinkID As Integer = DirectCast(e.Row.FindControl("hdnMenuLinkID"), HiddenField).Value
                    Dim obj = cntx.sp_GetPageRightsByEmpAndMenuLinkID(intEmpId, intMenuLinkID).ToList()
                    If obj.Count > 0 Then
                        'rptInnerRights.DataSource = obj
                        'rptInnerRights.DataBind()
                        grdInnerRights.DataSource = obj
                        grdInnerRights.DataBind()

                        For Each row As GridViewRow In grdInnerRights.Rows
                            Dim chkInner As CheckBox = row.FindControl("chkInnerLink")
                            Dim hdnEmpRightID As Integer = DirectCast(row.FindControl("hdnEmpRightID"), HiddenField).Value
                            If hdnEmpRightID > 0 Then
                                chkInner.Checked = True
                            Else
                                chkInner.Checked = False
                            End If
                        Next

                    Else
                        'rptInnerRights.DataSource = Nothing
                        'rptInnerRights.DataBind()
                        grdInnerRights.DataSource = Nothing
                        grdInnerRights.DataBind()
                    End If
                End If
            End Using
        Catch ex As Exception

        End Try
    End Sub


    Protected Sub grdAssignedRights_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles grdAssignedRights.RowDeleting
        Using cntx As New PortalModel.PortalEntities
            Dim id As Integer = grdAssignedRights.DataKeys(e.RowIndex).Value
            Dim intEmpId As Integer = ddlEmp.SelectedValue

            lblStatus.Text = String.Empty
            lblMsg.Text = String.Empty

            Try
                'Dim obj = New PortalModel.EmpLinks With {.EmpLinkID = id}
                Dim obj = cntx.EmpLinks.Where(Function(f) f.EmpLinkID = id).ToList().FirstOrDefault()
                Dim intMenuLinkID As Integer = obj.MenuLinkID
                With cntx
                    .EmpLinks.Attach(obj)
                    cntx.EmpLinks.DeleteObject(obj)
                End With

                Dim objInner = cntx.sp_GetPageRightsByEmpAndMenuLinkID(intEmpId, intMenuLinkID).Where(Function(f) f.EmpRightID > 0).ToList()
                For Each o In objInner
                    Dim objEmpRights = cntx.EmpRights.Where(Function(f) f.PageRightID = o.PageRightID).ToList().FirstOrDefault()
                    With cntx
                        .EmpRights.Attach(objEmpRights)
                        cntx.EmpRights.DeleteObject(objEmpRights)
                    End With
                Next

                
                cntx.SaveChanges()
                GetRights(cntx)
                Me.lblStatus.ForeColor = Drawing.Color.DarkGreen
                Me.lblStatus.Text = "Right Deleted Successfully."
                Me.lblMsg.Text = "Right Deleted Successfully."
            Catch ex As Exception
                lblStatus.ForeColor = Drawing.Color.Red
                lblStatus.Text = ex.Message
            End Try
        End Using
    End Sub

    Protected Sub grdNonAssignedRights_RowDataBound(sender As Object, e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles grdNonAssignedRights.RowDataBound
        Try
            Using cntx As New PortalModel.PortalEntities
                If e.Row.RowType = DataControlRowType.DataRow Then
                    'Dim rptInnerRights As Repeater = e.Row.FindControl("rptInnerRights")
                    Dim grdInnerRights As GridView = e.Row.FindControl("grdNonAssignedRightsInner")
                    Dim intMenuLinkID As Integer = grdNonAssignedRights.DataKeys(e.Row.RowIndex).Value
                    Dim obj = cntx.PageRights.Where(Function(f) f.MenuLinkID = intMenuLinkID).ToList()
                    If obj.Count > 0 Then
                        'rptInnerRights.DataSource = obj
                        'rptInnerRights.DataBind()
                        grdInnerRights.DataSource = obj
                        grdInnerRights.DataBind()
                    Else
                        'rptInnerRights.DataSource = Nothing
                        'rptInnerRights.DataBind()
                        grdInnerRights.DataSource = Nothing
                        grdInnerRights.DataBind()
                    End If
                End If
            End Using
        Catch ex As Exception

        End Try
    End Sub
End Class
