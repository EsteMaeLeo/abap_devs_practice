const btnAirtport = document.querySelector(".getList");

btnAirtport.addEventListener("click", clickList);

function clickList() {
  let wsUrl =
    "http://llrrpp.sap.com:50081/sap/bc/srt/rfc/sap/zwbs_wb_get_airports/001/zwbs_wb_get_airports/zwbs_wb_get_airports";

  let soapMessage2 =
    '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" ' +
    'xmlns:urn="urn:sap-com:document:sap:rfc:functions">' +
    "<soapenv:Header/>" +
    "<soapenv:Body>" +
    "<urn:ZFM_AIRPORT/>" +
    "</soapenv:Body>" +
    "</soapenv:Envelope>";

  $.ajax({
    type: "POST",
    url: wsUrl,
    contentType: 'text/xml; charset="utf-8"',
    dataType: "xml",
    data: soapMessage2,
    Authorization: "Basic " + btoa("SAPWBS:123456"),
    Accept: "*/*",
    success: processSuccess,
    error: processError,
  });

  function processSuccess(data, status, req) {
    alert("success");
    if (status == "success") {
      console.log(req.responseText);
      console.log(req.responseXML);
      let xmlDoc = req.responseXML;
      console.log(xmlDoc);
      airportDetails(xmlDoc);
      alert(req.responseText);
    }
  }

  function airportDetails(xml) {
    let i;
    let table = `<thead>
                      <tr>
                          <th>Code</th>
                          <th>Name</th>
                          <th>Time Zone</th>
                          </thead>
                      </tr>`;

    //get all elements ITEM inside XML
    let item = xml.getElementsByTagName("item");

    // Start to fetch the data by using TagName
    for (i = 0; i < item.length; i++) {
      table +=
        "<tr><td  data-cell='id'>" +
        item[i].getElementsByTagName("ID")[0].childNodes[0].nodeValue +
        "</td><td  data-cell='name'>" +
        item[i].getElementsByTagName("NAME")[0].childNodes[0].nodeValue +
        "</td><td  data-cell='Time zone'>" +
        item[i].getElementsByTagName("TIME_ZONE")[0].childNodes[0].nodeValue;
    }

    // Print the xml data in table form
    document.getElementById("airportList").innerHTML = table;
  }

  function processError(data, status, req) {
    alert(req.responseText + " " + status);
  }
}
