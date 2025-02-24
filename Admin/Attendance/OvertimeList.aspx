<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/Site.master" AutoEventWireup="false"
    CodeFile="OvertimeList.aspx.vb" Inherits="Admin_Attendance_OvertimeList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContents" runat="Server">
    <link href="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/bootstrap-datepicker/bootstrap-datepicker.css") %>"
        rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="<%= Page.ResolveClientUrl("~/Admin/assets/vendor/jquery-ui/jquery-ui.css") %>" />
    <link href="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/select2/select2.css") %>"
        rel="stylesheet" type="text/css" />
    <style type="text/css">
        .style2 {
        }

        .style3 {
            width: 193px;
            height: 20px;
        }

        .style4 {
            height: 20px;
        }

        .txtRight {
            text-align: right !important;
        }

        .txtCenter {
            text-align: center !important;
        }

        #tblDetails tr th {
            padding-right: 10px;
        }

        .form-horizontal .control-label {
            text-align: left;
        }

        .grdHead th {
            font-weight: bold;
        }

        .page-content, .page-header {
            background-color: #fff;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="Server">
    <h1 class="page-title">Overtime List</h1>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BodyContents" runat="Server">
    <form class="form-horizontal fv-form fv-form-bootstrap" id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="5000">
        </asp:ScriptManager>
        <div class="panel">
            <div class="panel-body" style="width: 100%;">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <div class="form-group">
                            <asp:Label ID="lblStatus" runat="server" Font-Bold="true"></asp:Label>
                        </div>
                        <div class="clearfix">
                        </div>
                        <div class="form-group col-sm-4">
                            <label class="col-sm-4 control-label" style="padding-right: 0px;">
                                Date From: <span style="color: Red;">*</span></label>
                            <div class="col-sm-8">
                                <asp:TextBox ID="txtDateFrom" name="txtDateFrom" runat="server" data-fv-field="txtDateFrom"
                                    CssClass="form-control" MaxLength="11" data-plugin="datepicker" data-format="dd-M-yyyy"  autocomplete="off"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtDateFrom"
                                    ErrorMessage="Required!" ForeColor="Red" ValidationGroup="Show" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="form-group col-sm-4">
                            <label class="col-sm-4 control-label">
                                Date To: <span style="color: Red;">*</span></label>
                            <div class="col-sm-8">
                                <asp:TextBox ID="txtDateTo" name="txtDateTo" runat="server" data-fv-field="txtDateTo"
                                    CssClass="form-control" MaxLength="11" data-plugin="datepicker" data-format="dd-M-yyyy" autocomplete="off"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtDateTo"
                                    ErrorMessage="Required!" ForeColor="Red" ValidationGroup="Show" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="form-group col-sm-4">
                            <label class="col-sm-4 control-label" style="padding-right: 0px;">
                                Department: <span style="color: Red;">*</span></label>
                            <div class="col-sm-8" style="text-align: left;">
                                <asp:DropDownList runat="server" ID="ddlDept" CssClass="form-control" AutoPostBack="true" Width="100%">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="ddlDept"
                                    ErrorMessage="Required!" ForeColor="Red" ValidationGroup="Show" Display="Dynamic"></asp:RequiredFieldValidator>
                            </div>
                        </div>
                        <div class="clearfix">
                        </div>
                        <div class="form-group col-sm-4">
                            <label class="col-sm-4 control-label" style="padding-right: 0px;">
                                Employee:</label>
                            <div class="col-sm-8" style="text-align: left;">
                                <asp:DropDownList runat="server" ID="ddlEmployee" CssClass="form-control" Width="100%">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="form-group col-sm-4">
                            <label class="col-sm-4 control-label" style="padding-right: 0px;">
                                Shift:</label>
                            <div class="col-sm-8" style="text-align: left;">
                                <asp:DropDownList runat="server" ID="ddlShift" CssClass="form-control" Width="100%">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="form-group col-sm-4">
                            <label class="col-sm-4 control-label" style="padding-right: 0px;">
                                Designation:</label>
                            <div class="col-sm-8" style="text-align: left;">
                                <asp:DropDownList runat="server" ID="ddlDesignation" CssClass="form-control">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="clearfix">
                        </div>

                        <div class="form-group col-sm-4">
                            <label class="col-sm-4 control-label" style="padding-right: 0px;">
                                Scale:</label>
                            <div class="col-sm-8" style="text-align: left;">
                                <asp:DropDownList runat="server" ID="ddlScale" CssClass="form-control">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="form-group col-sm-4">
                            <label class="col-sm-4 control-label" style="padding-right: 0px;">
                                Is Att. Exempt:</label>
                            <div class="col-sm-8" style="text-align: left;">
                                <asp:DropDownList ID="ddlExempt" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="" Text="All"></asp:ListItem>
                                    <asp:ListItem Value="True" Text="Yes"></asp:ListItem>
                                    <asp:ListItem Value="False" Text="No" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        
                        <div class="form-group col-sm-4">
                            <label class="col-sm-4 control-label" style="padding-right: 0px;">
                                Is Retired:</label>
                            <div class="col-sm-8" style="text-align: left;">
                                <asp:DropDownList ID="ddlIsRetired" runat="server" CssClass="form-control">
                                    <asp:ListItem Value="" Text="All"></asp:ListItem>
                                    <asp:ListItem Value="True" Text="Yes"></asp:ListItem>
                                    <asp:ListItem Value="False" Text="No" Selected="True"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="clearfix">
                        </div>


                        <div class="form-group col-sm-6 text-right">
                            <asp:Button ID="btnShow" runat="server" Text="Show" ValidationGroup="Show" CssClass="btn btn-primary"
                                ClientIDMode="Static" />
                        </div>

                        <div class="form-group col-sm-1" style="margin-left: 10px;">
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
                                DisplayAfter="50" DynamicLayout="False">
                                <ProgressTemplate>
                                    <asp:Image ID="prg1" runat="server" ImageUrl="~/Admin/images/loading2_2x.gif" Width="31px" />
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </div>
                        <div class="clearfix">
                        </div>
                        <hr />
                        <br />
                        <div id="divGrid" runat="server" visible="false">

                            <div class="form-group text-left">
                                <asp:Button ID="btnExport" runat="server" Text="Export" CssClass="btn" ClientIDMode="Static" />
                            </div>
                            <div class="clearfix">
                            </div>
                            <div class="row" style="font-size:10px;">
                                <asp:GridView ID="grd" runat="server" AutoGenerateColumns="False" CellPadding="5"
                                    CssClass="table table-hover table-striped table-bordered" DataKeyNames="EmployeeID" Width="100%">
                                    <Columns>
                                        <asp:TemplateField HeaderText="S#">
                                            <ItemTemplate>
                                                <%#Container.DataItemIndex+1 %>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Name">
                                            <ItemTemplate>
                                                <asp:Label ID="lblName" runat="server" Text='<%# Eval("EmpName") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        
                                        <asp:TemplateField HeaderText="Emp Code">
                                            <ItemTemplate>
                                                <asp:Label ID="lblEmpCode" runat="server" Text='<%# Eval("EmpCode") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Deptartment">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDept" runat="server" Text='<%# Eval("DeptTitle") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        
                                        <asp:TemplateField HeaderText="Designation">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDesignationTitle" runat="server" Text='<%# Eval("DesignationTitle") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="BPS">
                                            <ItemTemplate>
                                                <asp:Label ID="lblScaleTitle" runat="server" Text='<%# Eval("ScaleTitle") %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Date">
                                            <ItemTemplate>
                                                <asp:Label ID="lblDate" runat="server" Text='<%# Format(Convert.ToDateTime(Eval("AttDate")).Date, "dd-MMM-yyyy") & " <b>(" & Convert.ToDateTime(Eval("AttDate")).DayOfWeek.ToString() & ")</b>"  %>'></asp:Label>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Time In">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTimeIn" runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>


                                        <asp:TemplateField HeaderText="Time Out">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTimeOut" runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Status">
                                            <ItemTemplate>
                                                <asp:Label ID="lblAttStatus" runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Late Arrival">
                                            <ItemTemplate>
                                                <asp:Label ID="lblLate" runat="server" Text='<%# IIf(Eval("IsLateArrive") IsNot Nothing AndAlso Eval("IsLateArrive").ToString() = "True", "Yes", "No") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Early Going">
                                            <ItemTemplate>
                                                <asp:Label ID="lblEarly" runat="server" Text='<%# IIf(Eval("IsEarlyGoing") IsNot Nothing AndAlso Eval("IsEarlyGoing").ToString() = "True", "Yes", "No") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Shift">
                                            <ItemTemplate>
                                                <asp:Label ID="lblShift" runat="server" Text='<%# Eval("ShiftTitle") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Shift Time In">
                                            <ItemTemplate>
                                                <asp:Label ID="lblShiftTimeIn" runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Shift Time Out">
                                            <ItemTemplate>
                                                <asp:Label ID="lblShiftTimeOut" runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Shift Grace Min">
                                            <ItemTemplate>
                                                <asp:Label ID="lblShiftGraceMin" runat="server" Text='<%# Eval("GraceTimeMinutes") %>'></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>


                                        <asp:TemplateField HeaderText="Total Shift Time">
                                            <ItemTemplate>
                                                <asp:Label ID="lblTotalShiftTime" runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Work Time">
                                            <ItemTemplate>
                                                <asp:Label ID="lblWorkTime" runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>

                                        <asp:TemplateField HeaderText="Extra">
                                            <ItemTemplate>
                                                <asp:Label ID="lblExtraTime" runat="server"></asp:Label>
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center" />
                                            <ItemStyle HorizontalAlign="Center" />
                                        </asp:TemplateField>

                                    </Columns>
                                    <FooterStyle Font-Bold="true" />
                                    <HeaderStyle CssClass="grdHead" Font-Bold="True" />
                                </asp:GridView>
                            </div>


                            <br />
                            <div class="clearfix">
                            </div>
                            <%--<div class="row">
                                <div style="font-style: italic; font-weight: bold; font-size: 12px;">Note: Counting is based on approval of H.O.D. or H.R.</div>
                            </div>--%>
                        </div>
                    </ContentTemplate>
                    <Triggers>
                        <asp:PostBackTrigger ControlID="btnExport" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
        </div>
    </form>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FooterScriptContents" runat="Server">
    <%--<script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.all.min.js") %>"></script>--%>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Admin/assets/js/components/panel.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Admin/assets/vendor/jquery-ui/jquery-ui.js") %>"></script>
    <%--<script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Admin/assets/vendor/bootstrap-datepicker/bootstrap-datepicker.js") %>"></script>--%>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/js/components/bootstrap-datepicker.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/select2/select2.js") %>"></script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            jQuery("#<%=ddlDept.ClientID %>").select2();
            jQuery("#<%=ddlEmployee.ClientID %>").select2();
            jQuery("#<%=ddlShift.ClientID %>").select2();
            jQuery("#<%=ddlDesignation.ClientID %>").select2();
            jQuery("#<%=ddlScale.ClientID %>").select2();

            if (args.get_isPartialLoad()) {
                jQuery("#<%=txtDateFrom.ClientID %>").datepicker();
                jQuery("#<%=txtDateTo.ClientID %>").datepicker();
                jQuery("#<%=ddlDept.ClientID %>").select2();
                jQuery("#<%=ddlEmployee.ClientID %>").select2();
                jQuery("#<%=ddlShift.ClientID %>").select2();
                jQuery("#<%=ddlDesignation.ClientID %>").select2();
                jQuery("#<%=ddlScale.ClientID %>").select2();

            }
        }

    </script>
</asp:Content>
