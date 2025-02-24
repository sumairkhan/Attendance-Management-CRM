<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/Site.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="Admin_Setup_Departments_Default" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContents" Runat="Server">

<link href="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.common.min.css") %>" rel="stylesheet" type="text/css" />
<link href="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.default.min.css") %>" rel="stylesheet" type="text/css" />

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeading" Runat="Server">
<h1 class="page-title">Departments Management</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContents" Runat="Server">
<div id="example">
    <div id="grid"></div>
</div>

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScriptContents" Runat="Server">
<script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.all.min.js") %>"></script>
<script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/bootbox/bootbox.js") %>"></script>
<script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/js/components/bootbox.js") %>"></script>


<script type="text/javascript">
    $(document).ready(function () {
                        dataSource = new kendo.data.DataSource({
                            transport: {
                                read: {
                                    url: "departments.ashx?action=1",
                                    dataType: "json"
                                },
                                update: {
                                    url: "departments.ashx?action=2",
                                    dataType: "json"
                                },
                                destroy: {
                                    url: "departments.ashx?action=4",
                                    dataType: "json"
                                },
                                create: {
                                    url: "departments.ashx?action=3",
                                    dataType: "json"
                                },
                                parameterMap: function (options, operation) {
                                    if (operation !== "read" && options.models) {
                                        return { models: kendo.stringify(options.models) };
                                    }
                                }
                            },
                            batch: true,
                            //pageSize: 20,
                            requestEnd: function (e) {
                                if (e.type === "update") {
                                    this.read();
                                }
                                if (e.type === "create") {
                                    this.read();
                                }
                            },
                            error: error,
                            schema: {
                                data: "deptlist",
                                errors:"Errors",
                                model: {
                                    id: "DepartmentID",
                                    fields: {
                                        DepartmentID: { editable: false, nullable: true },
                                        Title: { validation: { required: true} }
                                    }
                                }
                            }
                        });

        $("#grid").kendoGrid({
            dataSource: dataSource,
            sortable: true,
        reorderable: true,
            resizable: true,
        filterable: true,
        columnMenu: true,        
        pageable: {
                    refresh: true,
                    pageSizes: true
                },
            height: 550,
            toolbar: ["create"],
            columns: [
                            { field: "Title", title: "Department Name" },
                            //{ command: ["edit", "destroy"], title: "&nbsp;", width: "250px"}],
                            { command: [
                                {name: "edit"},
                                {name: "Delete",  
                                    click: function(e){  
                                        var tr = $(e.target).closest("tr"); //get the row for deletion
                                        var data = this.dataItem(tr); //get the row data so it can be referred later
                                        bootbox.dialog({
                                              message: "Are you sure to delete Department: " + data.Title + "?",
                                              title: "Confirm Delete",
                                              buttons: {
                                                danger: {
                                                  label: "Delete",
                                                  className: "btn-danger",
                                                  callback: function() {
                                                    var grid = $("#grid").data("kendoGrid");
                                                    grid.dataSource.remove(data);
                                                    grid.dataSource.sync();
                                                    grid.refresh();
                                                  }
                                                },
                                                main: {
                                                  label: "Cancel",
                                                  className: "btn-primary",
                                                }
                                              }
                                            });
                                    }                              
                                }
                                ], title: "&nbsp;", width: "250px"}],
            editable: "popup",
            edit: function (e) {
                if (e.model.isNew()) {
                    e.container.kendoWindow("title", "Add")
                }
            },
        });
    });
</script>

<script type="text/javascript">
function error(args) {
        if (args.errors) {
            var grid = $("#grid").data("kendoGrid");
            grid.one("dataBinding", function (ev) {
                ev.preventDefault();
                bootbox.alert(args.errors);
                grid.cancelChanges();
            });
        }
}


</script>


</asp:Content>




