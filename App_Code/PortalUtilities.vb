Imports Microsoft.VisualBasic
Imports System.Data.Metadata.Edm
Imports System.Reflection

Public Class PortalUtilities
    Public Shared Function fnEmployeeAndCompanyID(ByVal profileID As Guid) As List(Of Integer)
        Dim lst As New List(Of Integer)
        Using cntx As New PortalModel.PortalEntities
            Dim companyID As Integer = 1
            Dim obj = cntx.Employees.Where(Function(f) f.UserId = profileID).Select(Function(f) New With {f.EmployeeID, f.CompanyID, f.DepartmentID}).ToList().FirstOrDefault()
            lst.Add(obj.EmployeeID)
            'lst.Add(obj.CompanyID)
            lst.Add(companyID)
            lst.Add(obj.DepartmentID)
        End Using
        Return lst
    End Function

    Public Shared Function fnGetURL(ByVal strURL As String, ByVal strURLComplete As String) As String
        'If strURL.Trim.ToLower().Equals("localhost") Then
        '    strURL = "http://" & strURL & ":" & HttpContext.Current.Request.Url.Port & "/Website_ERP_GCS/"
        'ElseIf strURL.Trim.ToLower().Equals("testerp") Then
        '    strURL = "http://" & strURL & "/testerp/"
        'Else
        '    strURL = "http://" & strURL & "/erp/"
        'End If
        'Return strURL
        If strURLComplete.Trim.ToLower().Contains("localhost") Then
            strURL = "http://" & strURL & ":" & HttpContext.Current.Request.Url.Port & "/Website_ERP_GCS/"
        ElseIf strURLComplete.Trim.ToLower().Contains("testerp") Then
            strURL = "http://" & strURL & "/testerp/"
        Else
            strURL = "http://" & strURL & "/erp/"
        End If
        Return strURL
    End Function

    Public Shared Function fnHaveRights(ByVal intEmpID As Integer, ByVal intMenuLink As Integer) As Boolean
        Dim haveRights As Boolean = False

        Using cntx As New PortalModel.PortalEntities
            Dim objEmpLinks = cntx.EmpLinks.Where(Function(f) f.EmpID = intEmpID AndAlso f.MenuLinkID = intMenuLink).ToList().FirstOrDefault()
            If objEmpLinks IsNot Nothing Then haveRights = True
        End Using
        Return haveRights
    End Function

    Public Shared Sub fnCompare(ByVal objOld As Object, ByVal objNew As Object, ByVal intPKID As Integer, ByVal EmployeeID As Integer)
        Try

            Dim strTableName = objOld.GetType().Name
            Dim intTableNameID As Integer = DirectCast([Enum].Parse(GetType(TableNames), strTableName), TableNames)
            Dim cntx As New PortalModel.PortalEntities
            Dim cols = From meta In cntx.MetadataWorkspace.GetItems(DataSpace.CSpace).Where(Function(m) m.BuiltInTypeKind = BuiltInTypeKind.EntityType) From p In TryCast(meta, EntityType).Properties.Where(Function(p) p.DeclaringType.Name = strTableName)


            For Each c In cols
                Try

                    Dim p = c.p
                    Dim n = p.Name
                    Dim t = p.TypeUsage.EdmType.Name

                    Dim infoOld As PropertyInfo = objOld.GetType().GetProperty(n)
                    Dim valueold As String = ""

                    If infoOld.GetValue(objOld, Nothing) IsNot Nothing Then
                        valueold = infoOld.GetValue(objOld, Nothing).ToString()
                    End If

                    Dim infoNew As PropertyInfo = objNew.GetType().GetProperty(n)
                    Dim valueNew As String = ""
                    If infoNew.GetValue(objNew, Nothing) IsNot Nothing Then
                        valueNew = infoNew.GetValue(objNew, Nothing).ToString()
                    End If


                    If fnCompareFieldsValue(valueold, valueNew) Then
                        AddLog(intTableNameID, intPKID, n, valueNew, valueold, EmployeeID)
                    End If
                Catch ex As Exception

                End Try
            Next
        Catch ex As Exception

        End Try
    End Sub


    Public Shared Function fnCompareFieldsValue(ByVal OldValue As String, ByVal NewValue As String) As Boolean
        Dim isChanged As Boolean = False
        If Not OldValue.Trim.ToLower().Equals(NewValue.Trim().ToLower()) Then isChanged = True
        Return isChanged
    End Function


    Public Shared Sub AddLog(ByVal TableNameID As Integer, ByVal TablePKID As Integer, ByVal FieldName As String, ByVal NewValue As String, ByVal OldValue As String, ByVal EmployeeID As Integer)
        Using cntx As New PortalModel.PortalEntities
            Dim objLog As New PortalModel.Logs
            With objLog
                .TableNameID = TableNameID
                .TablePKID = TablePKID
                .FieldName = FieldName
                .OldValue = OldValue
                .NewValue = NewValue
                .EmployeeID = EmployeeID
                .CreatedDate = DateTime.Now
            End With

            cntx.Logs.AddObject(objLog)
            cntx.SaveChanges()

        End Using
    End Sub

    Shared Function UploadFile(ByVal objFile As FileUpload, ByVal FileName As String, ByVal FilePath As String) As String
        Dim FileExtension As String = System.IO.Path.GetExtension(objFile.FileName).ToLower()
        Dim NewFileName As String = FileName & FileExtension
        objFile.SaveAs(FilePath & NewFileName)
        Return NewFileName
    End Function

    Public Shared Function fnGetExtraTime(ByVal totalShiftTime? As TimeSpan, ByVal totalWorkTime? As TimeSpan) As String
        Dim strExtraTime As String = String.Empty
        Dim totalExtraMin? As TimeSpan = Nothing
        If totalShiftTime IsNot Nothing AndAlso totalWorkTime IsNot Nothing Then
            totalExtraMin = totalWorkTime - totalShiftTime
            If totalExtraMin.Value.Hours < 0 OrElse totalExtraMin.Value.Minutes < 0 Then
                strExtraTime = "-" & Math.Abs((totalExtraMin.Value.Days * 24) + totalExtraMin.Value.Hours).ToString("D2") & ":" & Math.Abs(totalExtraMin.Value.Minutes).ToString("D2")
            Else
                strExtraTime = (totalExtraMin.Value.Days * 24) + totalExtraMin.Value.Hours.ToString("D2") & ":" & totalExtraMin.Value.Minutes.ToString("D2")
            End If
        End If
        Return strExtraTime
    End Function

    Public Enum MenuLinks

        ChangePassword = 1
        Profile = 2
        ManageDepartments = 3
        AddEmployees = 4
        ListEmployees = 5
        AddUser = 6
        ListUsers = 7
        ManageRights = 8
        Manage_Shifts = 9
        Employee_Shifts = 10
        Att_Employee_List = 11
        Att_Department_List = 12
        Att_Present_List = 13
        Att_Absent_List = 14
        Att_LateArrival_List = 15
        Att_EarlyGoing_List = 16
        Att_Overtime_List = 17
        Att_Summary = 18
        Att_List = 19
        ManageHolidays = 20
        Apply_Leave = 21
        Leaves_List = 22
        ManageDesignations = 23
        ManageScales = 24
    End Enum

    Public Enum TableNames
        Company = 1
        Departments = 2
        Employees = 3
        EmpRights = 4
        PageRights = 5
        Att_Shifts = 6
        Att_Shifts_Users = 7
        HR_Att_Devices = 8
        HR_Att_Records = 9
    End Enum

    Public Enum AttendanceStatus
        Present = 0
        Absent = 1
        Holiday = 2
    End Enum
End Class
