Imports System.IO

Partial Class Admin_Employees_ListEmployees
    Inherits System.Web.UI.Page
    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser(User.Identity.Name).ProviderUserKey)
    Dim strUserName As String = User.Identity.Name
    Dim strRole As String = System.Threading.Thread.CurrentThread.CurrentCulture.TextInfo.ToTitleCase(Roles.GetRolesForUser(strUserName)(0))

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        Try
            If Not Page.IsPostBack Then
                Dim haveRights = PortalUtilities.fnHaveRights(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.ListEmployees)
                If Not haveRights Then Response.Redirect("~/Admin/")

                Using cntx As New PortalModel.PortalEntities
                    cntx.CommandTimeout = Int32.MaxValue

                    Dim dept = (From d In cntx.Departments Order By d.Title Select d.DepartmentID, d.Title).ToList
                    dept = dept.Where(Function(f) Not f.Title.ToLower().Trim().Equals("superadmin")).ToList()

                    With ddlDept
                        .DataValueField = "DepartmentID"
                        .DataTextField = "Title"
                        .DataSource = dept
                        .DataBind()
                        .Items.Insert(0, New ListItem("-- All --", ""))
                    End With

                    Dim objDesignation = (From d In cntx.HR_Designations Where d.IsDeleted = False Order By d.Title Select d.DesignationID, d.Title).ToList

                    With ddlDesignation
                        .DataValueField = "DesignationID"
                        .DataTextField = "Title"
                        .DataSource = objDesignation
                        .DataBind()
                        .Items.Insert(0, New ListItem("-- All --", ""))
                    End With

                    Dim objScale = (From d In cntx.HR_Scales Where d.IsDeleted = False Order By d.Title Select d.ScaleID, d.Title).ToList

                    With ddlScale
                        .DataValueField = "ScaleID"
                        .DataTextField = "Title"
                        .DataSource = objScale
                        .DataBind()
                        .Items.Insert(0, New ListItem("-- All --", ""))
                    End With

                    'GetEmployees(cntx)

                End Using
            End If
        Catch ex As Exception
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = ex.Message
            If ex.InnerException IsNot Nothing Then
                lblStatus.Text = lblStatus.Text & "<br />" & ex.InnerException.Message
            End If
        End Try
    End Sub

    Protected Sub btnShow_Click(sender As Object, e As System.EventArgs) Handles btnShow.Click
        lblStatus.Text = String.Empty

        btnExport.Visible = False
        btnExportImgs.Visible = False
        grd.Visible = False

        Try
            Using cntx As New PortalModel.PortalEntities
                cntx.CommandTimeout = Int32.MaxValue
                GetEmployees(cntx)
            End Using
        Catch ex As Exception
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = ex.Message
            If ex.InnerException IsNot Nothing Then
                lblStatus.Text = lblStatus.Text & "<br />" & ex.InnerException.Message
            End If
        End Try
    End Sub

    Protected Sub GetEmployees(cntx As PortalModel.PortalEntities)

        'Dim obj = (From emp In cntx.Employees
        '           Join d In cntx.Departments On emp.DepartmentID Equals d.DepartmentID
        '           Where emp.IsDeleted = False Or emp.IsDeleted Is Nothing
        '           Order By emp.FirstName, emp.LastName
        '           Select emp.EmployeeID, emp.FirstName, emp.CNICNo, DeptTitle = d.Title, d.DepartmentID, emp.EmpCode, emp.BioImg, emp.CamImg).ToList()




        'If Not String.IsNullOrEmpty(txtFirstName.Text.Trim) Then
        '    obj = obj.Where(Function(f) f.FirstName.Trim().ToLower().Contains(txtFirstName.Text.Trim().ToLower())).ToList()
        'End If

        'If Not String.IsNullOrEmpty(txtCNIC.Text.Trim) Then
        '    obj = obj.Where(Function(f) f.CNICNo IsNot Nothing AndAlso f.CNICNo.Trim().ToLower().Contains(txtCNIC.Text.Trim().ToLower())).ToList()
        'End If

        'If Not String.IsNullOrEmpty(ddlDept.SelectedValue) AndAlso ddlDept.SelectedValue > 0 Then
        '    obj = obj.Where(Function(f) f.DepartmentID = ddlDept.SelectedValue).ToList()
        'End If


        'If Not String.IsNullOrEmpty(txtCode.Text.Trim) Then
        '    obj = obj.Where(Function(f) f.EmpCode IsNot Nothing AndAlso f.EmpCode.Trim().ToLower().Contains(txtCode.Text.Trim().ToLower())).ToList()
        'End If


        Dim intEmpID As Integer? = Nothing
        Dim intDeptID As Integer? = Nothing
        Dim strEmpName As String = Nothing
        Dim strEmpCNIC As String = Nothing
        Dim strEmpCode As String = Nothing
        Dim isExempt As Boolean? = Nothing
        Dim isRetired As Boolean? = Nothing


        If Not String.IsNullOrEmpty(txtFirstName.Text.Trim) Then
            strEmpName = txtFirstName.Text.Trim()
        End If

        If Not String.IsNullOrEmpty(txtCNIC.Text.Trim) Then
            strEmpCNIC = txtCNIC.Text.Trim()
        End If

        If Not String.IsNullOrEmpty(ddlDept.SelectedValue) AndAlso ddlDept.SelectedValue > 0 Then
            intDeptID = ddlDept.SelectedValue
        End If


        If Not String.IsNullOrEmpty(txtCode.Text.Trim) Then
            strEmpCode = txtCode.Text.Trim()
        End If


        If Not String.IsNullOrEmpty(ddlExempt.SelectedValue) Then
            isExempt = ddlExempt.SelectedValue
        End If

        If Not String.IsNullOrEmpty(ddlIsRetired.SelectedValue) Then
            isRetired = ddlIsRetired.SelectedValue
        End If

        Dim obj = cntx.sp_GetAllEmployees(intEmpID, intDeptID, strEmpName, strEmpCode, strEmpCNIC, isExempt, isRetired).ToList().OrderBy(Function(f) f.FirstName).ToList()

        'Dim obj = (From emp In cntx.sp_GetAllEmployees(intEmpID, intDeptID, strEmpName, strEmpCode, strEmpCNIC, isExempt, isRetired).ToList()
        '           Order By emp.FirstName
        '           Select emp.EmployeeID, emp.FirstName, emp.CNICNo, emp.DeptTitle, emp.EmpCode, emp.DepartmentID, emp.BioImg, emp.BioFingerType,
        '               emp.CamImg, emp.IsExamptAttendance, emp.DesignationID, emp.DesignationTitle, emp.ScaleID, emp.ScaleTitle, emp.Gender, emp.IsRetired).ToList()



        If Not String.IsNullOrEmpty(ddlImage.SelectedValue) Then
            If ddlImage.SelectedValue = True Then
                obj = obj.Where(Function(f) f.CamImg IsNot Nothing).ToList()
            Else
                obj = obj.Where(Function(f) f.CamImg Is Nothing).ToList()
            End If
        End If


        If Not String.IsNullOrEmpty(ddlBiometric.SelectedValue) Then
            If ddlBiometric.SelectedValue = True Then
                obj = obj.Where(Function(f) f.BioImg IsNot Nothing).ToList()
            Else
                obj = obj.Where(Function(f) f.BioImg Is Nothing).ToList()
            End If
        End If



        If Not String.IsNullOrEmpty(ddlDesignation.SelectedValue) AndAlso ddlDesignation.SelectedValue > 0 Then
            obj = obj.Where(Function(f) f.DesignationID IsNot Nothing AndAlso f.DesignationID = ddlDesignation.SelectedValue).ToList()
        End If

        If Not String.IsNullOrEmpty(ddlScale.SelectedValue) AndAlso ddlScale.SelectedValue > 0 Then
            obj = obj.Where(Function(f) f.ScaleID IsNot Nothing AndAlso f.ScaleID = ddlScale.SelectedValue).ToList()
        End If

        If Not String.IsNullOrEmpty(ddlGender.SelectedValue) Then
            obj = obj.Where(Function(f) f.Gender IsNot Nothing AndAlso Not String.IsNullOrEmpty(f.Gender.Trim()) AndAlso f.Gender.Trim().Equals(ddlGender.SelectedValue)).ToList()
        End If

        obj = obj.Where(Function(f) Not f.DeptTitle.ToLower().Trim().Equals("superadmin")).ToList()

        grd.DataSource = obj
        grd.DataBind()
        If obj.Count > 0 Then
            btnExport.Visible = True
            btnExportImgs.Visible = True
            grd.DataSource = obj
            grd.DataBind()
            grd.Visible = True
        Else
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = "0 records found!"
        End If
    End Sub



    Protected Sub grd_RowDeleting(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewDeleteEventArgs) Handles grd.RowDeleting
        Using cntx As New PortalModel.PortalEntities
            cntx.CommandTimeout = Int32.MaxValue
            Dim id As Integer = grd.DataKeys(e.RowIndex).Value
            Try
                Dim obj = New PortalModel.Employees With {.EmployeeID = id}
                With cntx
                    .Employees.Attach(obj)
                    '.Products.DeleteObject(obj)
                    obj.DeletedBy = lstEmployeeAndCompanyID(0)
                    obj.IsDeleted = True
                    .SaveChanges()
                End With
                GetEmployees(cntx)
                Me.lblStatus.ForeColor = Drawing.Color.DarkGreen
                Me.lblStatus.Text = "Employee Deleted Successfully."
            Catch ex As Exception
                lblStatus.ForeColor = Drawing.Color.Red
                lblStatus.Text = "This record is in use and can not be deleted. <br />" & ex.Message
            End Try
        End Using
    End Sub


    Protected Sub btnExport_Click(sender As Object, e As System.EventArgs) Handles btnExport.Click
        Try

            Response.ClearContent()
            Response.Buffer = True
            Response.AddHeader("content-disposition", "attachment;filename=Employees.xls")
            Response.Charset = ""
            Response.ContentType = "application/vnd.ms-excel"

            grd.Columns(0).Visible = False
            grd.Columns(1).Visible = False
            grd.Columns(2).Visible = False




            Using sw As New IO.StringWriter()
                Dim hw As New HtmlTextWriter(sw)



                grd.HeaderRow.BackColor = Drawing.Color.White
                For Each cell As TableCell In grd.HeaderRow.Cells
                    cell.BackColor = grd.HeaderStyle.BackColor
                Next
                For Each row As GridViewRow In grd.Rows
                    row.BackColor = Drawing.Color.White
                    For Each cell As TableCell In row.Cells
                        If row.RowIndex Mod 2 = 0 Then
                            cell.BackColor = grd.AlternatingRowStyle.BackColor
                        Else
                            cell.BackColor = grd.RowStyle.BackColor
                        End If
                        cell.CssClass = "textmode"
                    Next
                Next

                grd.RenderControl(hw)
                'style to format numbers to string
                'Dim style As String = "<style> .textmode { } </style>"
                'Response.Write(style)
                Response.Output.Write(sw.ToString())
                Response.Flush()
                Response.End()
                'HttpContext.Current.Response.Flush() ' Sends all currently buffered output to the client.
                'Response.SuppressContent = True ' Gets or sets a value indicating whether to send HTTP content to the client.
                'HttpContext.Current.ApplicationInstance.CompleteRequest() ' Causes ASP.NET to bypass all events and filtering in the HTTP pipeline chain of execution and directly execute the EndRequest event.

            End Using
        Catch ex As Exception
            lblStatus.Text = ex.Message
        End Try

        grd.Columns(0).Visible = True
        grd.Columns(1).Visible = True
        grd.Columns(2).Visible = True
    End Sub

    Public Overrides Sub VerifyRenderingInServerForm(control As Control)
        Return
    End Sub


    Protected Sub ExportImages(cntx As PortalModel.PortalEntities)
        Dim objList = (From emp In cntx.Employees
                       Join d In cntx.Departments On emp.DepartmentID Equals d.DepartmentID
                       Where emp.IsDeleted = False Or emp.IsDeleted Is Nothing
                       Order By emp.FirstName, emp.LastName
                       Select emp.EmployeeID, emp.FirstName, emp.CNICNo, DeptTitle = d.Title, d.DepartmentID, emp.EmpCode, emp.BioImg, emp.CamImg).ToList()



        If Not String.IsNullOrEmpty(txtFirstName.Text.Trim) Then
            objList = objList.Where(Function(f) f.FirstName.Trim().ToLower().Contains(txtFirstName.Text.Trim().ToLower())).ToList()
        End If

        If Not String.IsNullOrEmpty(txtCNIC.Text.Trim) Then
            objList = objList.Where(Function(f) f.CNICNo IsNot Nothing AndAlso f.CNICNo.Trim().ToLower().Contains(txtCNIC.Text.Trim().ToLower())).ToList()
        End If

        If Not String.IsNullOrEmpty(ddlDept.SelectedValue) AndAlso ddlDept.SelectedValue > 0 Then
            objList = objList.Where(Function(f) f.DepartmentID = ddlDept.SelectedValue).ToList()
        End If


        If Not String.IsNullOrEmpty(txtCode.Text.Trim) Then
            objList = objList.Where(Function(f) f.EmpCode IsNot Nothing AndAlso f.EmpCode.Trim().ToLower().Contains(txtCode.Text.Trim().ToLower())).ToList()
        End If


        If Not String.IsNullOrEmpty(ddlImage.SelectedValue) Then
            If ddlImage.SelectedValue = True Then
                objList = objList.Where(Function(f) f.CamImg IsNot Nothing).ToList()
            Else
                objList = objList.Where(Function(f) f.CamImg Is Nothing).ToList()
            End If
        End If


        If Not String.IsNullOrEmpty(ddlBiometric.SelectedValue) Then
            If ddlBiometric.SelectedValue = True Then
                objList = objList.Where(Function(f) f.BioImg IsNot Nothing).ToList()
            Else
                objList = objList.Where(Function(f) f.BioImg Is Nothing).ToList()
            End If
        End If

        objList = objList.Where(Function(f) Not f.DeptTitle.ToLower().Trim().Equals("superadmin")).ToList()



        If objList.Count > 0 Then
            'For index = 0 To obj.Count - 1
            '    If (obj(index).BioImg IsNot Nothing Or obj(index).CamImg IsNot Nothing) Then
            '        ConvertAndSaveByteToJpg(obj(index).BioImg, obj(index).CamImg, obj(index).EmployeeID, obj(index).EmpCode, obj(index).FirstName)
            '    End If
            'Next

            For Each obj In objList
                If obj.BioImg IsNot Nothing OrElse obj.CamImg IsNot Nothing Then
                    ConvertAndSaveByteToJpg(obj.BioImg, obj.CamImg, obj.EmployeeID, obj.EmpCode, obj.FirstName)
                End If
            Next
            lblStatus.ForeColor = Drawing.Color.Green
            lblStatus.Text = "Pictures exported successfully!"
        Else
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = "0 records found!"
        End If
    End Sub


    Protected Sub ConvertAndSaveByteToJpg(ByVal BioImage As Byte(), ByVal CamImg As Byte(), ByVal EmployeeID As String, ByVal EmpCode As String, ByVal FName As String)
        Dim BioImageFolder As String = Server.MapPath("~/Admin/attachements/Emp_BioMetrics")
        Dim CamImageFolder As String = Server.MapPath("~/Admin/attachements/Emp_Pictures")

        Dim bio_img As System.Drawing.Bitmap
        Dim BioImageFileName As String

        Dim cam_img As System.Drawing.Bitmap
        Dim CamImageFileName As String

        If (BioImage IsNot Nothing) Then
            Using mStreamBio As New MemoryStream(BioImage)
                bio_img = System.Drawing.Image.FromStream(mStreamBio)
                BioImageFileName = BioImageFolder & "\" & EmpCode & "_" & EmployeeID & "_" & FName & ".jpg"
                If Not (System.IO.File.Exists(BioImageFileName)) Then
                    bio_img.Save(BioImageFileName)
                End If
            End Using
        End If


        If (CamImg IsNot Nothing) Then
            Using mStreamCam As New MemoryStream(CamImg)
                cam_img = System.Drawing.Image.FromStream(mStreamCam)
                CamImageFileName = CamImageFolder & "\" & EmpCode & "_" & EmployeeID & "_" & FName & ".jpg"
                If Not (System.IO.File.Exists(CamImageFileName)) Then
                    cam_img.Save(CamImageFileName, System.Drawing.Imaging.ImageFormat.Jpeg)
                End If
            End Using
        End If
    End Sub


    Protected Sub btnExportImgs_Click(sender As Object, e As System.EventArgs) Handles btnExportImgs.Click
        lblStatus.Text = String.Empty
        Try
            Using cntx As New PortalModel.PortalEntities
                cntx.CommandTimeout = Int32.MaxValue
                ExportImages(cntx)
            End Using
        Catch ex As Exception
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = ex.Message
            If ex.InnerException IsNot Nothing Then
                lblStatus.Text = lblStatus.Text & "<br />" & ex.InnerException.Message
            End If
        End Try
    End Sub
End Class
