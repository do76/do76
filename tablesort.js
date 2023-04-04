var tables = document.querySelectorAll('table');
tables.forEach(function(table) {
  var tableHeaders = table.querySelectorAll('th');
  tableHeaders.forEach(function(header) {
    header.addEventListener('click', function() {
      // determine which column was clicked
      var column = header.cellIndex;
      // determine sort order (ascending or descending)
      var ascending = header.getAttribute('data-order') === 'asc';
      // sort table rows based on column data
      sortTable(table, column, ascending);
      // toggle sort order for next click
      header.setAttribute('data-order', ascending ? 'desc' : 'asc');
    });
  });
});

function sortTable(table, column, ascending) {
  // get table body rows within the clicked table
  var tableRows = table.querySelectorAll('tbody tr');
  // convert rows to array for sorting
  var rowsArray = Array.from(tableRows);
  // sort rows based on column data
  rowsArray.sort(function(rowA, rowB) {
    var dataA = rowA.children[column].textContent;
    var dataB = rowB.children[column].textContent;
    if (!isNaN(dataA) && !isNaN(dataB)) { // if both are numeric values
      dataA = parseFloat(dataA);
      dataB = parseFloat(dataB);
    }
    if (ascending) {
      return dataA < dataB ? -1 : dataA > dataB ? 1 : 0;
    } else {
      return dataA > dataB ? -1 : dataA < dataB ? 1 : 0;
    }
  });
  // append sorted rows to table body within the clicked table
  var tableBody = table.querySelector('tbody');
  tableBody.innerHTML = '';
  rowsArray.forEach(function(row) {
    tableBody.appendChild(row);
  });
}
