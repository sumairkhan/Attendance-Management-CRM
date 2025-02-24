<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/Site.master" AutoEventWireup="false"
    CodeFile="Profile.aspx.vb" Inherits="Admin_Profile" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContents" runat="Server">
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="Server">
    <h1 class="page-title">
        Profile</h1>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BodyContents" runat="Server">
    <form class="form-horizontal fv-form fv-form-bootstrap" id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div class="panel">
        <div class="panel-body">
            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                <ContentTemplate>
                    <div class="form-group">
                        <asp:Label ID="lblStatus" runat="server" SkinID="lblRedText"></asp:Label>
                    </div>
                    <div class="clearfix">
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            First Name:
                        </label>
                        <label class="col-sm-8 control-label" style="text-align: left;">
                            <asp:Label ID="lblFirstName" runat="server" Font-Bold="True"></asp:Label>
                        </label>
                    </div>
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            Last Name:
                        </label>
                        <label class="col-sm-8 control-label" style="text-align: left;">
                            <asp:Label ID="lblLastName" runat="server" Font-Bold="True"></asp:Label>
                        </label>
                    </div>
                    <div class="clearfix">
                    </div>
                    
                    <div class="form-group col-sm-6">
                        <label class="col-sm-4 control-label">
                            Department:
                        </label>
                        <label class="col-sm-8 control-label" style="text-align: left;">
                            <asp:Label ID="lblDepartment" runat="server" Font-Bold="True"></asp:Label>
                            <asp:DropDownList runat="server" ID="ddlDept" CssClass="form-control"></asp:DropDownList>
                        </label>
                    </div>
                   
                    
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    </form>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FooterScriptContents" runat="Server">
    <%--<script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.all.min.js") %>"></script>--%>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Admin/assets/js/components/panel.js") %>"></script>
    <%--<script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Admin/assets/jquery-ui/jquery-ui.js") %>"></script>--%>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Admin/assets/vendor/bootstrap-datepicker/bootstrap-datepicker.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/js/components/bootstrap-datepicker.js") %>"></script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            if (args.get_isPartialLoad()) {

            }
        }
    </script>
</asp:Content>
