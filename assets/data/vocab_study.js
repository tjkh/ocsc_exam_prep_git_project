// single column
var isPremiumVersion;

var numOfQuestions = 10;  // เป็น dummy ว่ามีทั่้งหมด 10 ข้อ
var currQstnID = "tbl_q10"; // เป็น dummy ว่าทำไปถึงข้อ 10 แล้ว จะได้แสดงเครื่องหมายถูก ว่า ทำหมดแล้ว
var clickedQstns = "xzcccx11111";

var msgToSend = numOfQuestions + "xzc" + currQstnID + clickedQstns;

// ส่งข้อมูลไป flutter ผ่าน JavascriptChannel ชื่อ messageHandler เพื่อบอกว่า ทำเสร็จแล้ว
 //messageHandler.postMessage(msgToSend);  // webView_flutter
//


 // ส่งข้อมูลไป Flutter พร้อมรับคาที่ส่งเข้ามาทาง messageHandler ด้วย
 window.flutter_inappwebview.callHandler('messageHandler', ...msgToSend)
 .then(function (result) {
 // รับค่าที่ส่งเข่ามา
     console.log("isBuyAndMode จาก Flutter to JS via messageHandler: " + result.Message);
     isBuyAndMode(result.Message);

 });

// รับข้อมูลมาจาก flutter
function isBuyAndMode(myDat){
var inComingData = myDat;

var isPremium; // ซื้อแล้ว
var is_darkMode;
var htmlMode; // มืดหรือสว่าง

var element = document.body; // สำหรับเปลี่ยนโหมด มืด-สว่าง โดยเปลี่ยนสี background และ ตัวหนังสือ
var hex = ("#00FF00");  // สำหรับเปลี่ยนสีลิงค์
var inputBox = document.getElementById("myInput");

 // alert("buy already?");

// แยก การซื้อ และโหมด ที่ส่งเข้ามา คั่นด้วย xyz
// เรื่องซื้อ ไม่ต้องเชค เพราะกันไว้แล้วว่า ถ้ายังไม่ซื้อ ไม่ให้เข้ามาทำข้อสอบที่นี
datArr = myDat.split("xyz");   //datArr[0] คือ ซื้อแล้วหรือยัง true=ซื้อแล้ว  datArr[1] คือ โหมดมือหรือไม่  true=ใช่โหมดมืด  false=ไม่ใช่โหมดมืด

is_Bought = datArr[0];
console.log("myDat - is_Bought: " + is_Bought);  // OK

// ปรับโหมด มืด-สว่าง
is_darkMode = datArr[1];

if (is_darkMode == "true"){
    htmlMode = "dark";
 }else{
         htmlMode = "light";
     }

if (htmlMode=="dark"){ // ถ้าอยู่ในโหมด มืด

element.style.backgroundColor = 'black';
element.style.color = 'white';

// ถ้าอยู่ในโหมดมืด เปลี่ยนสีลิงค์ ให้สว่างขึ้น
    var links = document.getElementsByTagName("a");
    if(links !== null){
    for(var i=0;i<links.length;i++)
    {
        if(links[i].href)
        {
            links[i].style.color = hex;
        }
    }
    } // end of if(links !==

    // เปลี่ยนสีพื้น input
            inputBox.style.backgroundColor = "#ededed ";
            inputBox.style.color = "white"; // ตัวหนังสือ ขาว

    // change background color of table
     var tableElements = document.getElementsByTagName("table");
       if (tableElements.length >= 1) {
      for(var i = 0; i < tableElements.length; i++){
          var thisTable = tableElements[i] ;
          var rows = thisTable.getElementsByTagName("tr") ;
      		for (var j=0; j<rows.length; j++) {
      				rows[j].style.backgroundColor = "gray";
      		}
     		}
      	}
}else{  // ถ้าอยู่ในโหมด สว่าง
element.style.backgroundColor = 'white';
element.style.color = 'black';
inputBox.style.backgroundColor = 'white';
}
}  // end of  isBuyAndMode(myDat)



function createTagAndAppendTo(tag, txt, elem){
  let customTag = document.createElement(tag);
  customTag.textContent = txt;
  elem.append(customTag);
}

function myFunction(evt) {
  // Declare variables
  let input, filter, table, tr, td, i, txtValue;
  let displayTr = [];
  filter = evt.value;
  filter = filter.toLowerCase();
  table = document.getElementById("myTable");
  tr = table.getElementsByTagName("tr");
  let regExp = new RegExp(filter);
  if (!filter) {
    for (let i = 0; i < tr.length; i++) {
      tr[i].style.display = '';
    }
    return;
  }

  // Loop through all table rows, and hide those who don't match the search query
  for (let i = 0; i < tr.length; i++) {
    let trStyle = tr[i].style.display;
    td = tr[i].getElementsByTagName("td");
    for (let j = 0; j < td.length; j++) {

        txtValue = td[j].textContent;
     //   txtValue.toUpperCase();

        let count = (txtValue.match(regExp) || []).length;
        displayTr[i] = displayTr[i] ? displayTr[i] : count;
        if (count !== 0) {

          td[j].innerText = '';
          let strArray = txtValue.split(filter);
          let loopLength = strArray.length - 1;

          for (let i = 0; i < loopLength; i++) {
            createTagAndAppendTo('span', strArray[i], td[j]);
            createTagAndAppendTo('mark', filter, td[j]);
          }
          createTagAndAppendTo('span', strArray[loopLength], td[j]);

        } else {
          let tdStr = td[j].textContent;
          td[j].innerText = '';
          td[j].textContent = tdStr;

        }
      }

    if(displayTr[i] !== 0) {
      tr[i].style.display = '';
    } else {
       tr[i].style.display = 'none';
    }
  }
}

// All column
//var searchBox_3 = document.getElementById("searchBox-3");
//searchBox_3.addEventListener("keyup",function(){
//	var keyword = this.value;
//	keyword = keyword.toUpperCase();
//	var table_3 = document.getElementById("table-3");
//	var all_tr = table_3.getElementsByTagName("tr");
//	for(var i=0; i<all_tr.length; i++){
//			var all_columns = all_tr[i].getElementsByTagName("td");
//		  for(j=0;j<all_columns.length; j++){
//				if(all_columns[j]){
//					var column_value = all_columns[j].textContent || all_columns[j].innerText;
//
//					column_value = column_value.toUpperCase();
//					if(column_value.indexOf(keyword) > -1){
//						all_tr[i].style.display = ""; // show
//						break;
//					}else{
//						all_tr[i].style.display = "none"; // hide
//					}
//				}
//			}
//		}
//})


