<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/Site.master" AutoEventWireup="false"
    EnableEventValidation="false" CodeFile="LeavesList.aspx.vb" Inherits="Admin_Leaves_LeavesList" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContents" runat="Server">
    <link href="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/bootstrap-datepicker/bootstrap-datepicker.css") %>"
        rel="stylesheet" type="text/css" />
    <link href="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/select2/select2.css") %>"
        rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="<%= Page.ResolveClientUrl("~/Admin/assets/vendor/jquery-ui/jquery-ui.css") %>" />
    <style type="text/css">
        .style2
        {
        }
        
        .style3
        {
            width: 193px;
            height: 20px;
        }
        
        .style4
        {
            height: 20px;
        }
        
        .txtRight
        {
            text-align: right !important;
        }
        
        .txtCenter
        {
            text-align: center !important;
        }
        
        #tblDetails tr th
        {
            padding-right: 10px;
        }
        
        .form-horizontal .control-label
        {
            text-align: left;
        }
        
        .grdHead th
        {
            font-weight: bold;
        }
        
        .page-content, .page-header
        {
            background-color: #fff;
        }
        
        .divGrid
        {
            font-size: 10px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="Server">
    <h1 class="page-title">
        Leave(s) List</h1>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BodyContents" runat="Server">
    <form class="form-horizontal fv-form fv-form-bootstrap" id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div class="panel">
        <div class="panel-body" style="width: 100%">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="form-group">
                        <asp:Label ID="lblStatus" runat="server" Font-Bold="true"></asp:Label>
                    </div>
                    <div class="clearfix">
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            Date From:</label>
                        <div class="col-sm-8">
                            <asp:TextBox ID="txtDateFrom" name="txtDateFrom" runat="server" data-fv-field="txtDateFrom"
                                CssClass="form-control" MaxLength="11" data-plugin="datepicker" data-format="dd-M-yyyy"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            Date To:</label>
                        <div class="col-sm-8">
                            <asp:TextBox ID="txtDateTo" name="txtDateTo" runat="server" data-fv-field="txtDateTo"
                                CssClass="form-control" MaxLength="11" data-plugin="datepicker" data-format="dd-M-yyyy"></asp:TextBox>
                        </div>
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            Department:</label>
                        <div class="col-sm-8">
                            <asp:DropDownList ID="ddlDept" runat="server" CssClass="form-control" AutoPostBack="true">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="clearfix">
                    </div>
                    <div class="form-group col-sm-4">
                        <label class="col-sm-4 control-label">
                            Employee:</label>
                        <div class="col-sm-8">
                            <asp:DropDownList ID="ddlEmployee" runat="server" CssClass="form-control">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="form-group col-sm-5">
                        <asp:Button ID="btnShow" runat="server" Text="Show" ValidationGroup="Show" CssClass="btn btn-primary"
                            ClientIDMode="Static" />
                    </div>
                    <div class="form-group col-sm-1">
                        <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
                            DisplayAfter="50" DynamicLayout="False">
                            <ProgressTemplate>
                                <asp:Image ID="Image2" runat="server" ImageUrl="~/Admin/images/loading2_2x.gif" Width="31px" />
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </div>
                    <div class="clearfix">
                    </div>
                    <hr />
                    <br />
                    <div class="row divGrid" runat="server" id="divGrid" visible="false">
                        <div class="form-group text-left">
                            <asp:Button ID="btnExport" runat="server" Text="Export" CssClass="btn" ClientIDMode="Static" />
                        </div>
                        <div class="clearfix">
                        </div>
                        <div class="row">
                            <asp:GridView ID="grd" runat="server" AutoGenerateColumns="False" CellPadding="5"
                                CssClass="table table-hover table-striped table-bordered" DataKeyNames="EmployeeLeaveID"
                                Width="100%">
                                <Columns>
                                    <asp:TemplateField HeaderText="S#">
                                        <ItemTemplate>
                                            <%#Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="From Date">
                                        <ItemTemplate>
                                            <asp:Label ID="lblFromDate" runat="server" Text='<%# Eval("FromDate", "{0:dd-MMM-yyyy}") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="To Date">
                                        <ItemTemplate>
                                            <asp:Label ID="lblToDate" runat="server" Text='<%# Eval("ToDate", "{0:dd-MMM-yyyy}") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="EmployeeName" HeaderText="Name" />
                                    <asp:BoundField DataField="DeptTitle" HeaderText="Department" />
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            <asp:HyperLink ID="lnkViewEmployee" runat="server" NavigateUrl='<%# String.Format("~/Admin/Leaves/ApplyLeave.aspx?id={0}", Eval("EmployeeLeaveID")) %>'
                                                Target="_blank">
                                                <asp:Image ID="ImageView" runat="server" ImageUrl="~/Admin/images/view.gif" BorderWidth="0"
                                                    Width="40px" />
                                            </asp:HyperLink>
                                        </ItemTemplate>
                                        <HeaderStyle HorizontalAlign="Center" />
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            <asp:ImageButton ID="ImageButtonDelete" runat="server" CausesValidation="False" CommandName="Delete"
                                                Width="45px" ImageUrl="~/Admin/images/delete.gif" OnClientClick="javascript:return confirm('Are you sure you want to delete this Leave?');" />
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                </Columns>
                                <FooterStyle Font-Bold="true" />
                                <HeaderStyle CssClass="grdHead" Font-Bold="True" />
                            </asp:GridView>
                        </div>
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
            if (args.get_isPartialLoad()) {
                jQuery("#<%=txtDateFrom.ClientID %>").datepicker();
                jQuery("#<%=txtDateTo.ClientID %>").datepicker();
                jQuery("#<%=ddlDept.ClientID %>").select2();
                jQuery("#<%=ddlEmployee.ClientID %>").select2();
            }
        }
    </script>
</asp:Content>
