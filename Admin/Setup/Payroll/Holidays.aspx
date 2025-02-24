<%@ Page Title="" Language="VB" MasterPageFile="~/Admin/Site.master" AutoEventWireup="false"
    CodeFile="Holidays.aspx.vb" Inherits="Admin_Setup_Payroll_Holidays" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeaderContents" runat="Server">
    <link href="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.common.min.css") %>"
        rel="stylesheet" type="text/css" />
    <link href="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.default.min.css") %>"
        rel="stylesheet" type="text/css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageHeading" runat="Server">
    <h1 class="page-title">
        Holidays Management</h1>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="BodyContents" runat="Server">
    <div id="example">
        <div id="grid">
        </div>
    </div>
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="FooterScriptContents" runat="Server">
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/kendo/kendo.all.min.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/vendor/bootbox/bootbox.js") %>"></script>
    <script type="text/javascript" src="<%= Page.ResolveClientUrl ("~/Admin/assets/js/components/bootbox.js") %>"></script>
    <script type="text/javascript">
    $(document).ready(function () {
                        dataSource = new kendo.data.DataSource({
                            transport: {
                                read: {
                                    url: "shifts.ashx?action=5",
                                    dataType: "json"
                                },
                                update: {
                                    url: "shifts.ashx?action=6",
                                    dataType: "json"
                                },
                                destroy: {
                                    url: "shifts.ashx?action=8",
                                    dataType: "json"
                                },
                                create: {
                                    url: "shifts.ashx?action=7",
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
                                data: "list",
                                errors:"Errors",
                                model: {
                                    id: "HolidayID",
                                    fields: {
                                        HolidayID: { editable: false, nullable: true },
                                        Title: { validation: { required: true} },
                                        HolidayDate: { validation: { required: true} }
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
                            { field: "Title", title: "Title" },
                            { field: "HolidayDate", title: "Date", template: "#= HolidayDate==null?'': kendo.toString(kendo.parseDate(HolidayDate, 'yyyy-MM-dd'), 'dd-MMM-yyyy') #" },
                            //{ command: ["edit", "destroy"], title: "&nbsp;", width: "250px"}],
                            { command: [
                                {name: "edit"},
                                {name: "Delete",  
                                    click: function(e){  
                                        var tr = $(e.target).closest("tr"); //get the row for deletion
                                        var data = this.dataItem(tr); //get the row data so it can be referred later
                                        bootbox.dialog({
                                              message: "Are you sure to delete: " + data.Title + "?",
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



                HolidayDate = $("[name=HolidayDate]");
                    $(HolidayDate).kendoDatePicker({
                        //start: "decade",
                        format: "dd-MMM-yyyy"
                    });

                    $(HolidayDate).attr("readonly","readonly");
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
