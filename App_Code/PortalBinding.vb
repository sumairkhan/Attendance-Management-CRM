Imports Microsoft.VisualBasic

Public Class PortalBinding

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


#Region "Attendance"
    Public Shared Function fnGetAllAttRecords(cntx As PortalModel.PortalEntities, Optional intCompanyID As Integer? = Nothing, Optional deptID As Integer? = Nothing, Optional empID As Integer? = Nothing, Optional strJobStatus As String = Nothing,
                                              Optional dtFrom As DateTime? = Nothing, Optional dtTo As DateTime? = Nothing, Optional type As Integer? = Nothing, Optional intDevice As Integer? = Nothing, Optional intShiftID As Integer? = Nothing,
                                              Optional strAttStatus As String = Nothing, Optional isHODApproved As Boolean? = Nothing, Optional isHRApproved As Boolean? = Nothing, Optional isOvertime As Boolean? = Nothing,
                                              Optional intVerifyType As Integer? = Nothing, Optional intRecordType As Boolean? = Nothing, Optional boolIsLateArrived As Boolean? = Nothing,
                                              Optional boolIsEarlyGoing As Boolean? = Nothing, Optional strDesignation As String = Nothing,
                                              Optional boolIsExempt As Boolean? = Nothing, Optional intScaleID As Integer? = Nothing,
                                              Optional boolIsRetired As Boolean? = Nothing) As List(Of PortalModel.sp_HR_GetAllAttRecords_Result)
        Dim obj = cntx.sp_HR_GetAllAttRecords(intCompanyID, deptID, empID, strJobStatus, dtFrom, dtTo, type, intDevice, intShiftID, strAttStatus, isHODApproved, isHRApproved, isOvertime, intVerifyType, intRecordType,
                                              boolIsLateArrived, boolIsEarlyGoing, strDesignation, boolIsExempt, intScaleID, boolIsRetired).ToList()
        'If intScaleID IsNot Nothing AndAlso intScaleID > 0 Then
        '    obj = obj.Where(Function(f) f.ScaleID IsNot Nothing AndAlso f.ScaleID = intScaleID).ToList()
        'End If
        Return obj
    End Function


    Public Shared Function fnGetAllAttConsolidate(cntx As PortalModel.PortalEntities, Optional intCompanyID As Integer? = Nothing, Optional deptID As Integer? = Nothing, Optional empID As Integer? = Nothing, Optional strJobStatus As String = Nothing,
                                                  Optional dtFrom As DateTime? = Nothing, Optional dtTo As DateTime? = Nothing,
                                                  Optional intShiftID As Integer? = Nothing, Optional strAttStatus As String = Nothing,
                                                  Optional strDesignation As String = Nothing, Optional boolIsExempt As Boolean? = Nothing,
                                                  Optional intScaleID As Integer? = Nothing, Optional boolIsRetired As Boolean? = Nothing) As List(Of PortalModel.sp_HR_GetAllAttConsolidate_Result)
        Dim obj = cntx.sp_HR_GetAllAttConsolidate(intCompanyID, deptID, empID, strJobStatus, dtFrom, dtTo, intShiftID, strAttStatus, strDesignation, boolIsExempt, intScaleID, boolIsRetired).ToList()
        'If intScaleID IsNot Nothing AndAlso intScaleID > 0 Then
        '    obj = obj.Where(Function(f) f.ScaleID IsNot Nothing AndAlso f.ScaleID = intScaleID).ToList()
        'End If
        Return obj
    End Function
#End Region

End Class
