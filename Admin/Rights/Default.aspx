<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/Site.master" AutoEventWireup="false"
    CodeFile="Default.aspx.vb" Inherits="Admin_Rights_Default" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContents" runat="Server">
    <link href="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/select2/select2.css") %>"
        rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="<%= Page.ResolveClientUrl("~/Admin/assets/vendor/jquery-ui/jquery-ui.css") %>" />
    <style>
        .chkInnerLink label {
            vertical-align: middle;
            margin-right: 15px;
            margin-left: 5px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="Server">
    <h1 class="page-title">Manage Rights</h1>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BodyContents" runat="Server">
    <form id="form1" runat="server" class="form-horizontal fv-form fv-form-bootstrap">
        <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:Label ID="lblStatus" runat="server" SkinID="lblRedText"></asp:Label>
                <div class="panel">
                    <div class="panel-body">
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                Select Group:</label>
                            <div class="col-sm-9">
                                <asp:DropDownList runat="server" ID="ddlDept" CssClass="form-control" AutoPostBack="True">
                                </asp:DropDownList>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="col-sm-3 control-label">
                                Select Employee:</label>
                            <div class="col-sm-9">
                                <asp:DropDownList runat="server" ID="ddlEmp" CssClass="form-control" AutoPostBack="True">
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="panel" id="pnlDetails" runat="server" visible="False">
                    <div class="panel-body">
                        <div class="form-group">
                            <div class="col-sm-6">
                                <h4>Available Rights</h4>
                                <asp:GridView ID="grdNonAssignedRights" runat="server" AutoGenerateColumns="False"
                                    CellPadding="5" CssClass="table table-hover table-striped table-bordered" DataKeyNames="MenuLinkID"
                                    Width="100%">
                                    <AlternatingRowStyle CssClass="grdAltRow" />
                                    <Columns>
                                        <asp:TemplateField>
                                            <ItemTemplate>
                                                <asp:CheckBox runat="server" ID="chkLink" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Select Rights">
                                            <ItemTemplate>
                                                <asp:Label ID="lblMenuLinkText" runat="server" Text='<%# Eval("MenuLinkText") %>' />
                                                <%--<br />
                                            &nbsp;&nbsp;&nbsp;&nbsp;
                                            <asp:Repeater runat="server" ID="rptInnerRights">
                                                <HeaderTemplate>
                                                </HeaderTemplate>
                                                <ItemTemplate>
                                                    <asp:HiddenField ID="hdnPageRightID" runat="server" Value='<%# Eval("PageRightID") %>' />
                                                    <asp:CheckBox runat="server" ID="chkInnerLink" Text='<%# Eval("Title") %>' CssClass="chkInnerLink" />
                                                </ItemTemplate>
                                                <FooterTemplate>
                                                </FooterTemplate>
                                            </asp:Repeater>--%>
                                                <asp:GridView ID="grdNonAssignedRightsInner" runat="server" AutoGenerateColumns="False"
                                                    CellPadding="5" CssClass="table table-hover table-striped table-bordered" DataKeyNames="PageRightID"
                                                    Width="100%">
                                                    <AlternatingRowStyle CssClass="grdAltRow" />
                                                    <Columns>
                                                        <asp:TemplateField>
                                                            <ItemTemplate>
                                                                <asp:CheckBox runat="server" ID="chkInnerLink" />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Select Inner Rights">
                                                            <ItemTemplate>
                                                                <asp:HiddenField ID="hdnPageRightID" runat="server" Value='<%# Eval("PageRightID") %>' />
                                                                <asp:Label ID="lblMenuLinkTextInner" runat="server" Text='<%# Eval("Title") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                    <HeaderStyle CssClass="grdHead" />
                                                </asp:GridView>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <%--<asp:BoundField DataField="MenuLinkText" HeaderText="Select Rights">
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" />
                                    </asp:BoundField>--%>
                                    </Columns>
                                    <HeaderStyle CssClass="grdHead" />
                                </asp:GridView>
                            </div>
                            <div class="col-sm-6">
                                <h4>Existing Rights</h4>
                                <asp:GridView ID="grdAssignedRights" runat="server" AutoGenerateColumns="False" CellPadding="5"
                                    CssClass="table table-hover table-striped table-bordered" DataKeyNames="EmpLinkID"
                                    Width="100%">
                                    <AlternatingRowStyle CssClass="grdAltRow" />
                                    <Columns>
                                        <asp:TemplateField HeaderText="Existing Rights">
                                            <ItemTemplate>
                                                <asp:Label ID="lblMenuLinkText" runat="server" Text='<%# Eval("MenuLinkText") %>' />
                                                <asp:HiddenField ID="hdnMenuLinkID" runat="server" Value='<%# Eval("MenuLinkID") %>' />

                                                <asp:GridView ID="grdAssignedRightsInner" runat="server" AutoGenerateColumns="False"
                                                    CellPadding="5" CssClass="table table-hover table-striped table-bordered" DataKeyNames="PageRightID"
                                                    Width="100%">
                                                    <AlternatingRowStyle CssClass="grdAltRow" />
                                                    <Columns>
                                                        <asp:TemplateField>
                                                            <ItemTemplate>
                                                                <asp:CheckBox runat="server" ID="chkInnerLink" />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                        <asp:TemplateField HeaderText="Existing Inner Rights">
                                                            <ItemTemplate>
                                                                <asp:HiddenField ID="hdnPageRightID" runat="server" Value='<%# Eval("PageRightID") %>' />
                                                                <asp:HiddenField ID="hdnEmpRightID" runat="server" Value='<%# Eval("EmpRightID") %>' />
                                                                <asp:Label ID="lblMenuLinkTextInner" runat="server" Text='<%# Eval("Title") %>' />
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                    <HeaderStyle CssClass="grdHead" />
                                                </asp:GridView>


                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <%-- <asp:BoundField DataField="MenuLinkText" HeaderText="Existing Rights">
                                        <HeaderStyle HorizontalAlign="Left" />
                                        <ItemStyle HorizontalAlign="Left" />
                                    </asp:BoundField>--%>
                                        <asp:TemplateField ShowHeader="False">
                                            <ItemTemplate>
                                                <asp:ImageButton ID="ImageButton2" runat="server" CausesValidation="False" CommandName="Delete"
                                                    ImageUrl="~/Admin/images/delete.gif" OnClientClick="javascript:return confirm('Are you sure you want to delete this right?');" />
                                            </ItemTemplate>
                                            <ItemStyle HorizontalAlign="Center" Width="100px" />
                                        </asp:TemplateField>
                                    </Columns>
                                    <HeaderStyle CssClass="grdHead" />
                                </asp:GridView>
                            </div>
                        </div>
                        <div class="form-group text-right">
                            <asp:Label runat="server" ID="lblMsg"></asp:Label>
                            <asp:Button ID="btnSave" runat="server" Text="Update Rights" ValidationGroup="Save" OnClientClick="btnDisabled(this);"
                                CssClass="btn btn-primary" ClientIDMode="Static" />
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FooterScriptContents" runat="Server">
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.all.min.js") %>"></script>
    <script src="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/formvalidation/formValidation.min.js") %>"></script>
    <script src="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/formvalidation/framework/bootstrap.min.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Admin/assets/vendor/jquery-ui/jquery-ui.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/select2/select2.js") %>"></script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            jQuery("#<%=ddlDept.ClientID %>").select2();
            jQuery("#<%=ddlEmp.ClientID %>").select2();
            if (args.get_isPartialLoad()) {
                jQuery("#<%=ddlDept.ClientID %>").select2();
                jQuery("#<%=ddlEmp.ClientID %>").select2();
            }
        }


        function btnDisabled(btn) {
            jQuery(btn).addClass('hide');
        }

    </script>
</asp:Content>
