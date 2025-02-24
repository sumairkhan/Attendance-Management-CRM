<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/Site.master" AutoEventWireup="false"
    EnableEventValidation="false" CodeFile="ListEmployees.aspx.vb" Inherits="Admin_Employees_ListEmployees" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContents" runat="Server">
    <link rel="stylesheet" href="<%= Page.ResolveClientUrl("~/Admin/assets/vendor/jquery-ui/jquery-ui.css") %>" />
    <link href="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/select2/select2.css") %>"
        rel="stylesheet" type="text/css" />
    <style type="text/css">
        .page-content, .page-header
        {
            background-color: #fff;
        }
        
        .grdHead th
        {
            font-weight: bold;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="PageHeading" runat="Server">
    <h1 class="page-title">
        List Employees</h1>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="BodyContents" runat="Server">
    <form id="form1" runat="server" class="form-horizontal fv-form fv-form-bootstrap">
    <asp:ScriptManager ID="ScriptManager1" runat="server" AsyncPostBackTimeout="5000">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="panel">
                <div class="panel-body">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            Name:</label>
                        <div class="col-sm-2">
                            <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <label class="col-sm-2 control-label">
                            CNIC:</label>
                        <div class="col-sm-2">
                            <asp:TextBox ID="txtCNIC" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <label class="col-sm-2 control-label">
                            Department:</label>
                        <div class="col-sm-2">
                            <asp:DropDownList ID="ddlDept" runat="server" CssClass="form-control">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="clearfix">
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            Code:</label>
                        <div class="col-sm-2">
                            <asp:TextBox ID="txtCode" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <label class="col-sm-2 control-label">
                            Designation:</label>
                        <div class="col-sm-2">
                            <asp:DropDownList ID="ddlDesignation" runat="server" CssClass="form-control">
                            </asp:DropDownList>
                        </div>
                        <label class="col-sm-2 control-label">
                            Scale:</label>
                        <div class="col-sm-2">
                            <asp:DropDownList ID="ddlScale" runat="server" CssClass="form-control">
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="clearfix">
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            Image:</label>
                        <div class="col-sm-2">
                            <asp:DropDownList ID="ddlImage" runat="server" CssClass="form-control">
                                <asp:ListItem Value="" Text="All"></asp:ListItem>
                                <asp:ListItem Value="True" Text="Yes"></asp:ListItem>
                                <asp:ListItem Value="False" Text="No"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <label class="col-sm-2 control-label">
                            Bio-metric:</label>
                        <div class="col-sm-2">
                            <asp:DropDownList ID="ddlBiometric" runat="server" CssClass="form-control">
                                <asp:ListItem Value="" Text="All"></asp:ListItem>
                                <asp:ListItem Value="True" Text="Yes"></asp:ListItem>
                                <asp:ListItem Value="False" Text="No"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <label class="col-sm-2 control-label">
                            Is Att. Exempt:</label>
                        <div class="col-sm-2">
                            <asp:DropDownList ID="ddlExempt" runat="server" CssClass="form-control">
                                <asp:ListItem Value="" Text="All"></asp:ListItem>
                                <asp:ListItem Value="True" Text="Yes"></asp:ListItem>
                                <asp:ListItem Value="False" Text="No"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="clearfix">
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            Gender:</label>
                        <div class="col-sm-2">
                            <asp:DropDownList ID="ddlGender" runat="server" CssClass="form-control">
                                <asp:ListItem Value="" Text="All"></asp:ListItem>
                                <asp:ListItem Value="Male" Text="Male"></asp:ListItem>
                                <asp:ListItem Value="Female" Text="Female"></asp:ListItem>
                                <asp:ListItem Value="Other" Text="Other"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <label class="col-sm-2 control-label">
                            Is Retired:</label>
                        <div class="col-sm-2">
                            <asp:DropDownList ID="ddlIsRetired" runat="server" CssClass="form-control">
                                 <asp:ListItem Value="" Text="All"></asp:ListItem>
                                <asp:ListItem Value="True" Text="Yes"></asp:ListItem>
                                <asp:ListItem Value="False" Text="No"></asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-sm-3">
                            <asp:Button ID="btnShow" runat="server" Text="Show" CssClass="btn btn-primary" ClientIDMode="Static" />
                            <asp:Button ID="btnExport" runat="server" Text="Export To Excel" CssClass="btn" ClientIDMode="Static"
                                Visible="false" />
                            <asp:Button ID="btnExportImgs" runat="server" Text="Export Pictures" CssClass="btn"
                                ClientIDMode="Static" Visible="false" />
                        </div>
                        <div class="col-sm-1">
                            <asp:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1"
                                DisplayAfter="50" DynamicLayout="False">
                                <ProgressTemplate>
                                    <asp:Image ID="Image2" runat="server" ImageUrl="~/Admin/images/loading2_2x.gif" Width="31px" />
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                        </div>
                    </div>
                </div>
            </div>
            <div class="panel" id="pnlDetails" runat="server">
                <div class="panel-body">
                    <asp:Label ID="lblStatus" runat="server" SkinID="lblRedText"></asp:Label>
                    <asp:GridView ID="grd" runat="server" AutoGenerateColumns="False" CellPadding="5"
                        CssClass="table table-hover table-striped table-bordered" DataKeyNames="EmployeeID"
                        Width="100%" Visible="false">
                        <AlternatingRowStyle CssClass="grdAltRow" />
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:HyperLink ID="lnkEditEmployee" runat="server" Target="_blank" NavigateUrl='<%# String.Format("~/Admin/Employees/default.aspx?id={0}&isEdit={1}", Eval("EmployeeID"),"1") %>'>
                                        <asp:Image ID="ImageView" runat="server" ImageUrl="~/Admin/images/edit-ico.gif" BorderWidth="0" />
                                    </asp:HyperLink>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:HyperLink ID="lnkViewEmployee" runat="server" Target="_blank" NavigateUrl='<%# String.Format("~/Admin/Employees/default.aspx?id={0}&isEdit={1}", Eval("EmployeeID"),"0") %>'>
                                        <asp:Image ID="Image1" runat="server" ImageUrl="~/Admin/images/view.gif" BorderWidth="0" />
                                    </asp:HyperLink>
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField ShowHeader="False">
                                <ItemTemplate>
                                    <asp:ImageButton ID="ImageButtonDelete" runat="server" CausesValidation="False" CommandName="Delete"
                                        ImageUrl="~/Admin/images/delete.gif" OnClientClick="javascript:return confirm('Are you sure you want to delete this Employee?');" />
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" Width="100px" />
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="No.">
                                <ItemTemplate>
                                    <%#Container.DataItemIndex+1 %>
                                </ItemTemplate>
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="EmpCode" HeaderText="Code" />
                            <asp:BoundField DataField="FirstName" HeaderText="Name" />
                            <asp:BoundField DataField="CNICNo" HeaderText="CNIC" />
                            <asp:BoundField DataField="DeptTitle" HeaderText="Department" />
                            <asp:BoundField DataField="DesignationTitle" HeaderText="Designation" />
                            <asp:BoundField DataField="ScaleTitle" HeaderText="Scale" />
                            <asp:BoundField DataField="Gender" HeaderText="Gender" />
                            <asp:TemplateField HeaderText="Image" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:Label ID="lblImage" runat="server" Text='<%# IIf(Eval("CamImg") IsNot Nothing, "Yes", "No") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Bio-metric" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:Label ID="lblBioMetric" runat="server" Text='<%# IIf(Eval("BioImg") IsNot Nothing, "Yes", "No") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Is Exempt?" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:Label ID="lblExamptAttendance" runat="server" Text='<%# IIf(Eval("IsExamptAttendance") IsNot Nothing AndAlso Eval("IsExamptAttendance") = True, "Yes", "No") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Is Retired?" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                <ItemTemplate>
                                    <asp:Label ID="lblIsRetired" runat="server" Text='<%# IIf(Eval("IsRetired") IsNot Nothing AndAlso Eval("IsRetired") = True, "Yes", "No") %>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle CssClass="grdHead" Font-Bold="True" />
                    </asp:GridView>
                </div>
            </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnExport" />
        </Triggers>
    </asp:UpdatePanel>
    </form>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="FooterScriptContents" runat="Server">
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Admin/assets/js/components/panel.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl("~/Admin/assets/vendor/jquery-ui/jquery-ui.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/js/components/bootstrap-datepicker.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/select2/select2.js") %>"></script>
    <script type="text/javascript">
        function pageLoad(sender, args) {
            jQuery("#<%=ddlDept.ClientID %>").select2();
            jQuery("#<%=ddlDesignation.ClientID %>").select2();
            jQuery("#<%=ddlScale.ClientID %>").select2();
            if (args.get_isPartialLoad()) {
                jQuery("#<%=ddlDept.ClientID %>").select2();
                jQuery("#<%=ddlDesignation.ClientID %>").select2();
                jQuery("#<%=ddlScale.ClientID %>").select2();

            }
        }
    </script>
</asp:Content>
