/*
 * Lowercases all row data for easier querying.
 */
exports.noShoutingPlz = functions.https.onRequest(async (req, res) => {
  const rowData = req.body;
  const { document_name, operation, data, path_params } = rowData.data[0].json;

  rowData.data[0].json.document_id = document_id.toLowerCase();
  rowData.data[0].json.document_name = document_name.toLowerCase();
  rowData.data[0].json.operation = operation.toLowerCase();
  rowData.data[0].json.data = data.toLowerCase();
  rowData.data[0].json.path_params = path_params.toLowerCase();

  return res.json(rowData.data);
});
