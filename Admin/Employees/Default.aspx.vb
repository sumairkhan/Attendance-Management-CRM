
Partial Class Admin_Employees_Default
    Inherits System.Web.UI.Page
    Dim lstEmployeeAndCompanyID As List(Of Integer) = PortalUtilities.fnEmployeeAndCompanyID(Membership.GetUser.ProviderUserKey)
    Dim FileUploadPath As String = Server.MapPath(ConfigurationManager.AppSettings("FileUploadPath"))

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            Dim haveRights = PortalUtilities.fnHaveRights(lstEmployeeAndCompanyID(0), PortalUtilities.MenuLinks.AddEmployees)
            If Not haveRights Then Response.Redirect("~/Admin/")

            Using cntx As New PortalModel.PortalEntities



                Dim dept = (From d In cntx.Departments Order By d.Title Select d.DepartmentID, d.Title).ToList
                dept = dept.Where(Function(f) Not f.Title.ToLower().Trim().Equals("superadmin")).ToList()

                With ddlDept
                    .DataValueField = "DepartmentID"
                    .DataTextField = "Title"
                    .DataSource = dept
                    .DataBind()
                    .Items.Insert(0, New ListItem("-- Select --", ""))
                End With

                Dim objDesignation = (From d In cntx.HR_Designations Where d.IsDeleted = False Order By d.Title Select d.DesignationID, d.Title).ToList

                With ddlDesignation
                    .DataValueField = "DesignationID"
                    .DataTextField = "Title"
                    .DataSource = objDesignation
                    .DataBind()
                    .Items.Insert(0, New ListItem("-- Select --", ""))
                End With

                Dim objScale = (From d In cntx.HR_Scales Where d.IsDeleted = False Order By d.Title Select d.ScaleID, d.Title).ToList

                With ddlScale
                    .DataValueField = "ScaleID"
                    .DataTextField = "Title"
                    .DataSource = objScale
                    .DataBind()
                    .Items.Insert(0, New ListItem("-- Select --", ""))
                End With

                If Not String.IsNullOrEmpty(Request.QueryString("id")) AndAlso Request.QueryString("id") IsNot Nothing AndAlso IsNumeric(Request.QueryString("id")) AndAlso Request.QueryString("isEdit").Equals("1") Then
                    Dim empID As Integer = Convert.ToInt32(Request.QueryString("id"))
                    Dim objEmp = cntx.Employees.Where(Function(f) f.EmployeeID = empID).ToList().FirstOrDefault()


                    hdnEmployeeID.Value = empID
                    lblHeading.Text = "Edit Employee"
                    GetEmployeeData(cntx, hdnEmployeeID.Value)
                    EditFields()

                ElseIf Not String.IsNullOrEmpty(Request.QueryString("id")) AndAlso Request.QueryString("id") IsNot Nothing AndAlso IsNumeric(Request.QueryString("id")) AndAlso Request.QueryString("isEdit").Equals("0") Then
                    Dim empID As Integer = Convert.ToInt32(Request.QueryString("id"))
                    Dim objEmp = cntx.Employees.Where(Function(f) f.EmployeeID = empID).ToList().FirstOrDefault()

                    hdnEmployeeID.Value = empID
                    lblHeading.Text = "View Employee"
                    GetEmployeeData(cntx, hdnEmployeeID.Value)
                    ViewFields()

                Else
                    lblHeading.Text = "New Employee"
                    EditFields()
                End If
            End Using
        End If
    End Sub

    Private Sub ViewFields()
        txtFirstName.Visible = False
        lblFirstName.Visible = True
        txtCNIC.Visible = False
        lblCNIC.Visible = True
        lblEmpCode.Visible = True
        txtEmpCode.Visible = False
        lblDept.Visible = True
        ddlDept.Visible = False
        btnSave.Visible = False
        lblIsExempt.Visible = True
        divChkExempt.Visible = False
        lblDesignation.Visible = True
        ddlDesignation.Visible = False
        lblScale.Visible = True
        ddlScale.Visible = False
        lblGender.Visible = True
        ddlGender.Visible = False
        lblIsRetired.Visible = True
        divRetired.Visible = False
        lblRemarks.Visible = True
        txtRemarks.Visible = False
    End Sub

    Private Sub EditFields()
        txtFirstName.Visible = True
        lblFirstName.Visible = False
        txtCNIC.Visible = True
        lblCNIC.Visible = False

        lblEmpCode.Visible = False
        txtEmpCode.Visible = True

        lblDept.Visible = False
        ddlDept.Visible = True
        btnSave.Visible = True
        divImg.Visible = False

        lblIsExempt.Visible = False
        divChkExempt.Visible = True

        lblDesignation.Visible = False
        ddlDesignation.Visible = True
        lblScale.Visible = False
        ddlScale.Visible = True

        lblGender.Visible = False
        ddlGender.Visible = True


        lblIsRetired.Visible = False
        divRetired.Visible = True

        lblRemarks.Visible = False
        txtRemarks.Visible = True
    End Sub


    Protected Sub btnSave_Click(sender As Object, e As System.EventArgs) Handles btnSave.Click
        Try
            lblStatus.Text = String.Empty



            Using cntx As New PortalModel.PortalEntities


                Dim empID As Integer = hdnEmployeeID.Value
                Dim isExists As Boolean = False

                If empID > 0 Then
                    Dim emp = cntx.Employees.Where(Function(empl) (empl.IsDeleted Is Nothing OrElse empl.IsDeleted = False) AndAlso empl.EmployeeID <> empID AndAlso (empl.CNICNo.Trim().ToLower().Equals(txtCNIC.Text.Trim().ToLower()) OrElse (empl.EmpCode IsNot Nothing AndAlso empl.EmpCode.Trim().ToLower() = txtEmpCode.Text.Trim()))).ToList().FirstOrDefault()
                    If emp IsNot Nothing Then
                        isExists = True
                    End If
                Else
                    Dim emp = cntx.Employees.Where(Function(empl) (empl.IsDeleted Is Nothing OrElse empl.IsDeleted = False) AndAlso (empl.CNICNo.Trim().ToLower().Equals(txtCNIC.Text.Trim().ToLower()) OrElse (empl.EmpCode IsNot Nothing AndAlso empl.EmpCode.Trim().ToLower() = txtEmpCode.Text.Trim()))).ToList().FirstOrDefault()
                    If emp IsNot Nothing Then
                        isExists = True
                    End If

                End If



                If isExists Then
                    lblStatus.ForeColor = Drawing.Color.Red
                    lblStatus.Text = "CNIC or Code already exist."
                    Exit Sub
                End If




                SaveEmployee(cntx, hdnEmployeeID.Value)
            End Using




            lblStatus.ForeColor = Drawing.Color.DarkGreen
            lblStatus.Text = "Employee Saved Successfully"
        Catch ex As Exception
            lblStatus.ForeColor = Drawing.Color.Red
            lblStatus.Text = ex.Message
        End Try
    End Sub

    Private Sub SaveEmployee(cntx As PortalModel.PortalEntities, ByVal empID As Integer)
        Dim obj As New PortalModel.Employees
        Dim objOld As New PortalModel.Employees
        If empID > 0 Then
            obj = cntx.Employees.Where(Function(f) f.EmployeeID = empID).ToList().FirstOrDefault()
            objOld = New PortalModel.PortalEntities().Employees.Where(Function(f) f.EmployeeID = empID).ToList().FirstOrDefault()
        End If
        With obj
            .FirstName = txtFirstName.Text.Trim
            .CNICNo = txtCNIC.Text.Trim
            .DepartmentID = ddlDept.SelectedValue
            .EmpCode = txtEmpCode.Text.Trim()
            .IsExamptAttendance = chkIsExempt.Checked

            .IsRetired = chkIsRetired.Checked

            .Remarks = txtRemarks.Text.Trim()

            If Not String.IsNullOrEmpty(ddlDesignation.SelectedValue) AndAlso ddlDesignation.SelectedValue > 0 Then
                .DesignationID = ddlDesignation.SelectedValue
                .CurrentDesignation = ddlDesignation.SelectedItem.Text
            End If


            If Not String.IsNullOrEmpty(ddlScale.SelectedValue) AndAlso ddlScale.SelectedValue > 0 Then
                .ScaleID = ddlScale.SelectedValue
            End If


            If Not String.IsNullOrEmpty(ddlGender.SelectedValue) Then
                .Gender = ddlGender.SelectedValue
            End If
        End With

        If empID = 0 Then
            obj.CreatedBy = Membership.GetUser.ProviderUserKey
            obj.IsActive = True
            obj.CreateDate = Date.Now.Date
            obj.CompanyID = lstEmployeeAndCompanyID(1)
            obj.InsertedBy = lstEmployeeAndCompanyID(0)

            'Dim objLastEmp = cntx.Employees.OrderByDescending(Function(f) f.EmployeeID).ToList().FirstOrDefault()
            'If objLastEmp IsNot Nothing AndAlso objLastEmp.EmpCode IsNot Nothing AndAlso Not String.IsNullOrEmpty(objLastEmp.EmpCode) Then
            '    Dim intEmpCode As Integer = Convert.ToInt32(objLastEmp.EmpCode) + 1
            '    obj.EmpCode = intEmpCode
            'Else
            '    obj.EmpCode = 1
            'End If

            cntx.Employees.AddObject(obj)
        End If

        cntx.SaveChanges()

        If empID = 0 Then ClearFields()


        If empID > 0 Then
            Try
                PortalUtilities.fnCompare(CType(objOld, Object), CType(obj, Object), obj.EmployeeID, lstEmployeeAndCompanyID(0))
            Catch ex As Exception

            End Try
        End If
    End Sub

    Private Sub ClearFields()
        hdnEmployeeID.Value = 0
        txtFirstName.Text = String.Empty
        txtCNIC.Text = String.Empty
        txtEmpCode.Text = String.Empty
        ddlDept.SelectedIndex = 0
        chkIsExempt.Checked = False
        ddlDesignation.SelectedIndex = 0
        ddlScale.SelectedIndex = 0
        ddlGender.SelectedIndex = 0
        chkIsRetired.Checked = False
        txtRemarks.Text = String.Empty
    End Sub


    Private Sub GetEmployeeData(cntx As PortalModel.PortalEntities, ByVal empID As Integer)
        Dim objEmployee = cntx.Employees.Where(Function(f) f.EmployeeID = empID AndAlso f.IsActive = True).ToList().FirstOrDefault()
        If objEmployee IsNot Nothing Then
            txtFirstName.Text = objEmployee.FirstName
            lblFirstName.Text = objEmployee.FirstName
            txtCNIC.Text = objEmployee.CNICNo
            lblCNIC.Text = objEmployee.CNICNo
            If objEmployee.EmpCode IsNot Nothing AndAlso Not String.IsNullOrEmpty(objEmployee.EmpCode.Trim()) Then
                txtEmpCode.Text = objEmployee.EmpCode
                lblEmpCode.Text = objEmployee.EmpCode
            End If

            ddlDept.SelectedValue = objEmployee.DepartmentID
            'Dim objDept = cntx.Departments.Where(Function(f) f.DepartmentID = objEmployee.DepartmentID).ToList().FirstOrDefault()
            'lblDept.Text = objDept.Title
            lblDept.Text = ddlDept.SelectedItem.Text

            If objEmployee.IsExamptAttendance IsNot Nothing AndAlso objEmployee.IsExamptAttendance = True Then
                chkIsExempt.Checked = True
                lblIsExempt.Text = "Is Attendance Exempt? Yes"
            Else
                chkIsExempt.Checked = False
                lblIsExempt.Text = "Is Attendance Exempt? No"
            End If




            If objEmployee.IsRetired IsNot Nothing AndAlso objEmployee.IsRetired = True Then
                chkIsRetired.Checked = True
                lblIsRetired.Text = "Is Retired? Yes"
            Else
                chkIsExempt.Checked = False
                lblIsExempt.Text = "Is Retired? No"
            End If

            If objEmployee.DesignationID IsNot Nothing AndAlso objEmployee.DesignationID > 0 Then
                ddlDesignation.SelectedValue = objEmployee.DesignationID
                lblDesignation.Text = ddlDesignation.SelectedItem.Text
            End If



            If objEmployee.ScaleID IsNot Nothing AndAlso objEmployee.ScaleID > 0 Then
                ddlScale.SelectedValue = objEmployee.ScaleID
                lblScale.Text = ddlScale.SelectedItem.Text
            End If


            lblEmpCode.Text = objEmployee.EmpCode

            ddlGender.SelectedValue = objEmployee.Gender
            lblGender.Text = objEmployee.Gender

            lblRemarks.Text = objEmployee.Remarks
            txtRemarks.Text = objEmployee.Remarks

            If objEmployee.BioImg IsNot Nothing OrElse objEmployee.CamImg IsNot Nothing Then
                Try
                    Dim byteEmployeePic As Byte() = Nothing
                    Dim img As String = String.Empty

                    If objEmployee.BioImg IsNot Nothing AndAlso Not String.IsNullOrEmpty(objEmployee.BioImg.ToString()) Then
                        Try
                            byteEmployeePic = objEmployee.BioImg
                            If byteEmployeePic IsNot Nothing AndAlso byteEmployeePic.Length > 0 Then
                                img = Convert.ToBase64String(byteEmployeePic)
                                imgBio.ImageUrl = "data:image;base64," + img
                                imgBio.Visible = True
                            Else
                                imgBio.ImageUrl = String.Empty
                            End If

                        Catch ex As Exception

                        End Try

                    End If

                    Dim byteEmployeePic2 As Byte() = Nothing
                    Dim img2 As String = String.Empty

                    If objEmployee.CamImg IsNot Nothing AndAlso Not String.IsNullOrEmpty(objEmployee.CamImg.ToString()) Then
                        Try
                            byteEmployeePic2 = objEmployee.CamImg
                            If byteEmployeePic2 IsNot Nothing AndAlso byteEmployeePic2.Length > 0 Then
                                img2 = Convert.ToBase64String(byteEmployeePic2)
                                imgCam.ImageUrl = "data:image;base64," + img2
                                imgCam.Visible = True
                            End If

                        Catch ex As Exception

                        End Try
                    Else
                        imgCam.ImageUrl = String.Empty

                    End If
                Catch ex As Exception

                End Try


                divImg.Visible = True
            End If

        End If
    End Sub

End Class
