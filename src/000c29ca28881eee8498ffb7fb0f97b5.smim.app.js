const api_url =
  "http://llrrpp.sap.com:50081/sap/bc/srt/wsdl/flv_10002A111AD1/bndg_url/sap/bc/srt/rfc/sap/zwbs_wb_get_airports/001/zwbs_wb_get_airports/zwbs_wb_get_airports?sap-client=001";

let soap =
  '<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" ' +
  'xmlns:urn="urn:sap-com:document:sap:rfc:functions">' +
  "<soapenv:Header/>" +
  "<soapenv:Body>" +
  "<urn:ZFM_AIRPORT/>" +
  "</soapenv:Body>" +
  "</soapenv:Envelope>";

/*function createRequest(method, url) {
  let xhr = new XMLHttpRequest();
  if ("withCredentials" in xhr) {
    xhr.open(method, url, true);
  } else if (typeof XDomainRequest != "undefined") {
    xhr = new XDomainRequest();
    xhr.open(method, url);
  } else {
    console.log("cors not support");
    alert("cors not supported");
    xhr = null;
  }
  return xhr;
}

let xhr = createRequest("POST", api_url);

if (!xhr) {
  console.log("Error ", xhr);
}
console.log(xhr);
xhr.onload = function (){
    let results = xhr.responseText;
    console.log(results);
}
*/
let action =
  "http://llrrpp.sap.com:50081/sap/bc/srt/rfc/sap/zwbs_wb_get_airports/001/zwbs_wb_get_airports/zwbs_wb_get_airports";
var xmlhttp = new XMLHttpRequest();
xmlhttp.withCredentials = true;

xmlhttp.onreadystatechange = function () {
  if (xmlhttp.readyState == 4) {
    if (xmlhttp.status == 200) {
      console.log(xmlhttp.response);
    }
    if (xmlhttp.status == 404) {
      console.log("ERROR");
    }
  }
};
xmlhttp.open("POST", api_url, false);
xmlhttp.setRequestHeader("SOAPAction", action);
xmlhttp.setRequestHeader("Content-Type", "text/xml");
//xmlhttp.setHeader("Access-Control-Allow-Origin:", "*");
xmlhttp.setRequestHeader("Access-Control-Allow-Origin", "*");
xmlhttp.setRequestHeader("Access-Control-Allow-Origin", "http://llrrpp.sap.com:50081");
xmlhttp.send(soap);
response = xmlhttp.responseXML;
console.log(response);
