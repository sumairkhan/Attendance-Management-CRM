<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/Site.master" AutoEventWireup="false"
    CodeFile="ApplyLeave.aspx.vb" Inherits="Admin_Leaves_ApplyLeave" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContents" runat="Server">
    <link rel="stylesheet" href="<%= Page.ResolveClientUrl("~/Admin/assets/vendor/jquery-ui/jquery-ui.css") %>" />
    <link href="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/select2/select2.css") %>"
        rel="stylesheet" type="text/css" />
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
        
        .form-group
        {
            margin-right: 0px !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="Server">
    <asp:Label class="page-title h1" runat="server" ID="lblHeading">
        Apply for Leave(s)</asp:Label>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BodyContents" runat="Server">
    <form class="form-horizontal fv-form fv-form-bootstrap" id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div class="panel">
        <div class="panel-body">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <asp:Label ID="lblStatus" runat="server"></asp:Label>
                    <div class="clearfix">
                    </div>
                    <div class="form-group col-md-6">
                        <label class="col-sm-4 control-label">
                            From:</label>
                        <div class="col-sm-8 control-label" style="text-align: left;">
                            <asp:Label ID="lblFromDate" runat="server" Font-Bold="True"></asp:Label>
                            <asp:TextBox ID="txtFromDate" name="txtFromDate" runat="server" data-fv-field="txtFromDate"
                                CssClass="form-control" MaxLength="11" data-plugin="datepicker" data-format="dd-M-yyyy"
                                autocomplete="off" AutoPostBack="True"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtFromDate"
                                ErrorMessage="Required!" ForeColor="Red" ValidationGroup="Save" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-group col-md-6">
                        <label class="col-sm-4 control-label">
                            To:</label>
                        <div class="col-sm-8 control-label" style="text-align: left;">
                            <asp:Label ID="lblToDate" runat="server" Font-Bold="True"></asp:Label>
                            <asp:TextBox ID="txtToDate" name="txtToDate" runat="server" data-fv-field="txtToDate"
                                CssClass="form-control" MaxLength="11" data-plugin="datepicker" data-format="dd-M-yyyy"
                                autocomplete="off" AutoPostBack="True"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtToDate"
                                ErrorMessage="Required!" ForeColor="Red" ValidationGroup="Save" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="clearfix">
                    </div>
                    <div class="form-group col-md-6">
                        <label class="col-sm-4 control-label">
                            Department:</label>
                        <div class="col-sm-8 control-label" style="text-align: left;">
                            <asp:DropDownList runat="server" ID="ddlDept" CssClass="form-control" AutoPostBack="true">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="ddlDept"
                                ErrorMessage="Required!" ForeColor="Red" ValidationGroup="Save" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="form-group col-md-6">
                        <label class="col-sm-4 control-label">
                            Employee:</label>
                        <div class="col-sm-8 control-label" style="text-align: left;">
                            <asp:DropDownList runat="server" ID="ddlEmployee" CssClass="form-control">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlEmployee"
                                ErrorMessage="Required!" ForeColor="Red" ValidationGroup="Save" Display="Dynamic"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <div class="clearfix">
                    </div>
                    <div class="form-group text-center">
                        <asp:HiddenField ID="hdnLeaveID" runat="server" Value="0" />
                        <asp:Button ID="btnSave" runat="server" Text="Save" ValidationGroup="Save" CssClass="btn btn-primary"
                            ClientIDMode="Static" Style="margin: 10px; margin-right: 30px;" />
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    </form>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FooterScriptContents" runat="Server">
    <%--<script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.all.min.js") %>"></script>--%>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/js/components/panel.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Admin/assets/vendor/jquery-ui/jquery-ui.js") %>"></script>
    <%--<script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Admin/assets/vendor/bootstrap-datepicker/bootstrap-datepicker.js") %>"></script>--%>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/js/components/bootstrap-datepicker.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/select2/select2.js") %>"></script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            jQuery("#<%=ddlDept.ClientID %>").select2();
            jQuery("#<%=ddlEmployee.ClientID %>").select2();
            if (args.get_isPartialLoad()) {
                jQuery("#<%=txtFromDate.ClientID %>").datepicker();
                jQuery("#<%=txtToDate.ClientID %>").datepicker();
                jQuery("#<%=ddlDept.ClientID %>").select2();
                jQuery("#<%=ddlEmployee.ClientID %>").select2();
            }
        }


        jQuery(function () {
            jQuery(window).bind('beforeunload', function () {
                return 'Are you sure you want to leave?';
            });
        });

        
    </script>
</asp:Content>
