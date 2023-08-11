@AbapCatalog.sqlViewName: 'zdev_cds_sales_v' //DDL SQL NAME
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS Sales Order'
define view zdev_cds_sales  //DDL Source
as select from vbak 
{
    key vbeln,
    ernam,
    erdat,
    vbtyp,
    vkorg,
    vtweg,
    spart
}
