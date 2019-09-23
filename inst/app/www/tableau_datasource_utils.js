$( document ).ready(function() {
  Shiny.addCustomMessageHandler("fetch_tds_chunked", function(message) {
    var payload; var m = JSON.parse(message);
    tableau.extensions.initializeAsync().then(function(){
      var dsh = tableau.extensions.dashboardContent.dashboard;
      var sht = dsh.worksheets[0];
      sht.applyFilterAsync(m.filter_field[0], m.filter_values, "replace").then(function(){
        sht.getSummaryDataAsync().then(function(x){
          let cols = x.columns.map(function(col){ return col._fieldName });
          let rows = x.data.map(function(row){return row.map(function(col){ return col._value })});
          let df = rows.map(function(row){ let x = {}; cols.forEach(function(col){ x[col] = row[cols.indexOf(col)]}); return x });
          payload = JSON.stringify(df);
          Shiny.setInputValue("read_tds_ui_1-payload:read_tds", payload);
        });
      });
    });
  });
});