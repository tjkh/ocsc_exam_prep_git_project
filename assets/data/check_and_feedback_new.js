// scrollIntoView() ไม่ทำงาน สำหรับ flutter_inappWebBiew
var isPremiumVersion;    // ถ้าใช้บน PC เพราะเรียกจาก Android  ไม่ได้ ค่าที่ส่งเข้ามา คือ  true  หรือ  false
var whereToStart;
var isBought;
var thisLastQNum;
var clickedQstns = ""; // สำหรับเก็บค่า ข้อที่คลิก
var numOfNewQstns = 0 //จำนวนข้อใหม่
var tooltiptext; // สำหรับเปลี่ยนสีพื้นหลัง tooltip เมื่อเป็น dark mode



var isClicked;   // ถึงตรงนี้ เอาค่า isClicked ไปแยก และเชคว่า ใหม่หรือเปล่า -- ถ้าคลิกแล้ว ก็ถือว่าเก่า
// สำหรับแสดงค่าตัวแปรที่ส่งมาจาก flutter เพราะใช้ alert ไม่ได้  ใช้ alert ได้แล้ว
var abc = document.getElementById("abc");  // สำหรับทดสอบค่าตัวแปร
var abcd = document.getElementById("abcd"); // สำหรับทดสอบค่าตัวแปร
var isBought = document.getElementById("isBought"); // สำหรับทดสอบค่าตัวแปร
var whereToBegin = document.getElementById("whereToBegin"); // สำหรับทดสอบค่าตัวแปร
var a1 = document.getElementById("a1"); // สำหรับทดสอบค่าตัวแปร
var a2 = document.getElementById("a2"); // สำหรับทดสอบค่าตัวแปร
var a3 = document.getElementById("a3"); // สำหรับทดสอบค่าตัวแปร
var a4 = document.getElementById("a4"); // สำหรับทดสอบค่าตัวแปร
var a5 = document.getElementById("a5"); // สำหรับทดสอบค่าตัวแปร
var a6 = document.getElementById("a6"); // สำหรับทดสอบค่าตัวแปร

// alert("enter check_and_feedback_new.js");


function compareDatesOfIsNew(FromSQL, FromFile){
var ab;
// alert("FromFile: " + FromSQL + "\nFromFile : " + FromFile);
//   // แยก id และวันที่ สำหรับ From SQL
fromSqlArr = FromSQL.split("sss");  //fromSqlArr[0] = id, fromSqlArr[1] = date, fromSqlArr[2] = status("true" or "false")   [1]-เปลี่ยนจากวันที่ เป็น isNew แล้ว
//alert("fromSqlArr: " + fromSqlArr[2]);

//   // แยก id และวันที่ สำหรับ FromFile
//   //var content = "id50147:date1630050147";
  var start = "id";
  var end = ":date";
var startIndex = FromFile.indexOf(start);
  var endIndex = FromFile.indexOf(end);
 var startIndex2 = (endIndex + end.length);
  var qNumId_file = FromFile.substring(start.length, endIndex);
  var qDate_file = FromFile.substring(startIndex2);
  var qNumId_file = FromFile.substring(start.length, endIndex);
 // alert("qDate_file: " + qDate_file +"\nfromSqlArr[1]: " + fromSqlArr[1] );
 //alert("(qDate_file > fromSqlArr[1]: " + (qDate_file > fromSqlArr[1]) + " คลิกหรือยัง" + fromSqlArr[2] );
// if (abc !== null) {  // ถ้ามี div ชื่อ abc ให้แสดงค่า ต้องเชคก่อน ไม่งั้น error
// document.getElementById("abc").innerHTML = "qDate_file: " + qDate_file + " - dateSQL: " + fromSqlArr[1] + " คลิกหรือยัง SQL: " + fromSqlArr[2];
 // }
// if (isBought !== null) {
// document.getElementById("isBought").innerHTML = fromSqlArr.toString() + " : " + FromFile.toString();
// }
//  document.getElementById("a4").innerHTML = fromSqlArr[1];

            if((qDate_file > fromSqlArr[1]) && (fromSqlArr[2] == "false")){ // ถ้าวันที่ในไฟล์ที่ส่งเข้ามา มากกว่า วันที่ในฐานข้อมูล และ ยังไม่มีการคลิก
//                // ตรวจสอบต่อไปว่า เกินกว่า 90 วันหรือไม่

            var currDateTime = Math.round(new Date() / 1000);
            var isExpired = Math.round((currDateTime - qDate_file)/86400);  // 86400 คือ จำนวนวินาทีในหนึ่งวัน - ทำวินาทีเป็นวัน
//			alert("isExpired in: " + isExpired + "days");
               if(isExpired < 90){ // ถ้าน้อยกว่า 90 วัน  -- ยังไม่ได้คลิก
					ab = "true";  // NEW -- ยังใหม่อยู่
			   }else{
					ab = "false";  // NOT NEW -- เก่าแล้ว หรือ คลิกแล้ว
			   } // end of  if(isExpired < 90
			}else{ //  if((qDate_file > fromSqlArr[1]) &&
				ab = "false";  // วันที่ในไฟล์ ไม่มากกว่าวันที่ในฐานข้อมูล หรือ คลิกแล้ว
			}  // end of  if((qDate_file > fromSqlArr[1]) && (fromSqlArr[2]
// alert("ab: " + ab);
// document.getElementById("a2").innerHTML = "ab: " + ab;
 // document.getElementById("whereToBegin").innerHTML = "ab: " + ab;

return ab;
}

  var x, i, thisID, thisDate, allIDS, allDates, content_of_isNew;
  var isNew_lastQNum;
  var isClicked_orNot;
   myContent = "";
   x = document.querySelectorAll(".isNew");
     for (i = 0; i < x.length; i++) {
     content_of_isNew = x[i].textContent;
//	  alert ("content_of_isNew: " + i + ". " + content_of_isNew);
          stringContent = content_of_isNew + "abc";  // แต่ละอัน คั่นด้วย "abc"
//	 alert ("stringContent: " + i + ". " + stringContent);
     myContent += stringContent;
//	 alert ("myContent: " + i + ". " + myContent);
 //  get_isNewClicked.postMessage(myContent);  // รูปแบบ myContent เช่น id1608958161:date1630050149abcid1608958162:date1630050150abc
 }


// let args3 = ["Hello from is_IsNewClicked!"];
let args3 = [myContent];
console.log("aaabbbc args3 send via is_IsNewClicked: " + args3);
//alert("args3: " + args3);

 window.flutter_inappwebview.callHandler('is_IsNewClicked', ...args3)
    .then(function (result) {
	       console.log("aaabbbc 345 Return is_IsNewClicked - result.newString: ", result.newString);
		isClicked_orNot = result.newString;
		isNew_lastQNum = isClicked_orNot.split('tjk');
		console.log("from FLUTTER isNew_lastQNum: " +  isNew_lastQNum );  // โหมด ยังไม่มา ต้องกลับไปหา
thisLastQNum = isNew_lastQNum[1];
console.log("from FLUTTER lastQNum: " +  thisLastQNum );

		var isNew_lastQNum;
        isNew_lastQNum = (result.newString).split('tjk');
        thisLastQNum = isNew_lastQNum[1];

        console.log("345 thisLastQNum: " + thisLastQNum);
  var htmlModeFromFlutter =  isNew_lastQNum[2];  // get light or dark mode for html from sqlite
    console.log("from FLUTTER htmlMode: " +  htmlModeFromFlutter);
  setModeDarkOrLight(htmlModeFromFlutter);

  var isPremiumVersion = isNew_lastQNum[3];
     console.log ("from FLUTTER buyStatus: " +  isPremiumVersion);

     if(thisLastQNum == 'tbl_q0'){  // ใน html เริ่มที่ tbl_q1
        thisLastQNum = 'tbl_q1';
     }

		  var startAt = document.getElementById(thisLastQNum);  // รับมาจาก Flutter

//		  console.log("startAt thisLastQNum: " + startAt);
//         //   document.getElementById("tbl_q5").scrollIntoView();
//
////            document.addEventListener("DOMContentLoaded", function() {
////                document.getElementById("tbl_q5").scrollIntoView();
////            });
//
//console.log("startAt id: " + startAt.getAttribute("id"));
//console.log("startAt className: " + startAt.className);
//
//		//  startAt.scrollIntoView();

		  isBought = isPremiumVersion;

		 console.log ("from FLUTTER isBought: " +  isBought );

		//  startAt.scrollIntoView();  // scroll ไปที่ข้อสุดท้ายที่ทำ ถ้าเพิ่งเข้ามา จะไปที่ top

		  console.log("start at from Flutter is_IsNewClicked: " + thisLastQNum);


// Wait for the page to load and elements to render
setTimeout(function() {
    var startAt = document.getElementById(thisLastQNum);  // Get the element by ID
    if (startAt) {
        console.log("startAt thisLastQNumXXX: " + startAt);
        console.log("startAt idXXX: " + startAt.getAttribute("id"));
        console.log("startAt classNameXXX: " + startAt.className);

        // Use scrollIntoView for smoother scrolling to the element
        startAt.scrollIntoView({ behavior: "smooth", block: "start" });
    } else {
        console.log("Element with id '" + thisLastQNum + "' not found.");
    }
}, 500); // Adjust the delay time (1000ms or 1 second) to make sure content is fully loaded





// scrollIntoView, scrollTo ไม่ทำงานใน flutter-inappwebview
//
//var startAt = document.getElementById(thisLastQNum);  // Get the element by ID
//
//if (startAt) {
//    console.log("startAt thisLastQNumXXX: " + startAt);
//    console.log("startAt idXXX: " + startAt.getAttribute("id"));
//    console.log("startAt classNameXXX: " + startAt.className);
//
//    // Adjust scrolling behavior
//    const offsetTop = startAt.offsetTop;
//    const offsetLeft = startAt.offsetLeft;
//
//    // For browsers that have different behavior for scrollTop
//    document.documentElement.scrollTop = offsetTop;  // For modern browsers
//    document.body.scrollTop = offsetTop;  // For older browsers
//
//    window.scrollTo({
//        top: offsetTop,
//        left: offsetLeft,
//        behavior: "smooth"
//    });
//} else {
//    console.log("Element with id '" + thisLastQNum + "' not found.");
//}
//






  var isNewer;  // สำหรับตรวจสอบวันที่ ในฐานข้อมูล กับในไฟล์ แต่ละข้อ

  console.log("isNew_lastQNum[0] with abc " + isNew_lastQNum[0]);

  // var isNewContentFromSQL = isNew_lastQNum[0].split('abc');
  var isNewContentFromSQL = isNew_lastQNum[0].split('sss');

  console.log("345 isNewContentFromSQL first element: " + isNewContentFromSQL[0]);



// var isNewContentFromFile = document.querySelectorAll(".isNew");  // ไปเอาหัวข้อ ใน <div class = isNew
// var isExpired;  // ถ้าเกิน 90 วัน จะไม่แสดงคำว่า NEW
var isNewContentFromFile = document.querySelectorAll(".isNew");  // ไปเอาหัวข้อ ใน <div class = isNew
var isExpired;  // ถ้าเกิน 90 วัน จะไม่แสดงคำว่า NEW
var this_id;  // id ของข้อสอบ ในข้อที่มี isNew  ( เช่น <div class="isNew">id1608958085:date1645677728</div>)
var id_from_itemTable;  // สำหรับรับค่า id ของข้อนี้  ส่งมาจาก Flutter  จากตาราง itemTable
var isNew_from_itemTable;  // สำหรับรับค่า isNew ของข้อนี้  ส่งมาจาก Flutter  จากตาราง itemTable
var isClicked_from_itemTable; // สำหรับรับค่า คลิกแล้วหรือยัง ของข้อนี้  ส่งมาจาก Flutter  จากตาราง itemTable
var this_item_date_from_file;  // วันที่ของข้อนี้ จากไฟล์ปัจจุบันที่กำลังเปิดใช้งาน ไม่ใช่จากฐานข้อมูล

console.log("เปรียบเทียบจำนวนตาราง จากฐานข้อมูล: " + isNewContentFromSQL.length + "\nจากในไฟล์ html: " + isNewContentFromFile.length);

if(isNewContentFromSQL.length == isNewContentFromFile.length){  // หาว่าใหม่หรือเปล่า ทำเฉพาะข้อมูลในฐานข้อมูล เท่ากับ <div class = "isNew"> เท่านั้น
//// ซึ่งปกติก็จะเท่ากัน แต่เผื่อเหนียวเอาไว้

for (i = 0; i < isNewContentFromSQL.length; i++) {

this_id = string_between_strings("id",":date",isNewContentFromFile[i].textContent);
var contentArr = (isNewContentFromFile[i].textContent).split(":date"); // แยกเป็นสองส่วน ส่วนหลังคือ วันที่
this_item_date_from_file =  contentArr[1];   //จะเอาตรวจว่า เก่ามากว่า 90 วันหรือไม่ ถ้าเกิน ไม่บอกว่าใหม่แล้ว
console.log("item_date_from_file: " + this_item_date_from_file);
//// หาว่าเกิน 90 วันจากวันปัจจุบัน หรือไม่
var currDateTime = Math.round(new Date() / 1000);  // หารด้วย 1000 เพื่อทำ miliSecond เป็น seconds
isExpired = Math.round((currDateTime - this_item_date_from_file)/86400);  // 86400 คือ จำนวนวินาทีในหนึ่งวัน - ทำวินาทีเป็นวัน

from_itemTable = isNewContentFromSQL[i].split("sss");  // จะได้ 3 อย่างคือ id, isNew, isClicked
id_from_itemTable = from_itemTable[0];
isNew_from_itemTable = from_itemTable[1];
isClicked_from_itemTable = from_itemTable[2];



		if (isExpired <=90 && isClicked_from_itemTable == "false"  && isNew_from_itemTable == "1"){  // แสดงคำว่า NEW
      isNewContentFromFile[i].style.backgroundColor = "red";
     isNewContentFromFile[i].textContent = "NEW 65";
     isNewContentFromFile[i].style.display = "block";
} else{
     isNewContentFromFile[i].style.display = "none";  // ไม่แสดงอะไร
}
console.log("this_id: " + this_id + "\nid From SQL: " + id_from_itemTable + "\ni = " + i);
}  // end of for (i = 0; i < isNewContentFromSQL.length; i++)
}else{

    for (i = 0; i < isNewContentFromFile.length; i++) { // ถ้าเกิดไม่เท่ากัน ก็ไม่ต้องแสดง
        isNewContentFromFile[i].style.display = "none";
        console.log("จำนวน tbl_q ไม่เท่ากัน เลย ไม่ต้องแสดงข้อความอะไร ");
    }

} // end of if if(isNewContentFromSQL.length = isNewContentFromFile.length){

		    })



function show_hide_expl(my_div, btn_name, q_num, isShowExpl, id_for_NEW_label) {

if(id_for_NEW_label==undefined){id_for_NEW_label="11111"};  // บางข้อไม่ได้ส่งมา

// คลิกดูคำอธิบาย ไปปรับค่า isClicked ในตาราง test_item_table ใหเป็น 1
var item_id;  //สำหรับ แสดงคำว่า NEW ถ้าเป็นข้อสอบข้อใหม
	if (typeof id_for_NEW_label === 'undefined') {
		item_id = "xx";
	}else{
		item_id=id_for_NEW_label;
//		Android.updateIsClickItem(item_id);
	}
// alert("item id: "+ item_id);

var isShowExplanation;
	if (typeof isShowExpl === 'undefined') {
		isShowExplanation = "no";
	}else{
		isShowExplanation=isShowExpl;
	}
//var isPremiumVersion = "false";    // ถ้าใช้บน PC เพราะเรียกจาก Android  ไม่ได
 //var isPremiumVersion = Android.getIsFullVersion(); // เรียก method จาก android class ชื่อ JavaScriptInterface

 var this_div = document.getElementById(my_div);
 var this_button = document.getElementById(btn_name);
 var this_q_num = document.getElementById(q_num);
// var isPremiumVersion = document.getElementById("isBought").innerHTML; // div ไม่มี .value attribute ต้องใช้ .innerHTML
// alert("isPremiumVersion: " + isPremiumVersion);
if (isShowExplanation=="no") {  // ถ้าตัวที่ส่งเข้ามาจากข้อสอบ บอกว่า ไม่ให้แสดงคำอธิบาย ต้องเชคต่อว่า เป็นรุ่นอะไร ถ้าเป็นรุ่นเต็ม ก็ให้แสดง ถ้าไม่ใช่ ก็ไม่ให้แสดง
	if (isPremiumVersion == "true"){
			showExplain(this_div, this_button,  this_q_num);      // แสดงคำอธิบาย
}else{  // ถ้าไม่ใช่รุ่นเต็ม ก็บอกว่า แสดงเฉพาะรุ่นเต็มเท่านั้น
	this_div.innerHTML = "&nbsp;&nbsp;ข้อนี้ มีคำอธิบายเฉพาะในรุ่นเต็ม (Full Version) เท่านั้น";
	this_div.style.color = "#000000";
    if (this_div.style.display !== 'none') {
        this_div.style.display = 'none';
		this_button.value = '\u0E14\u0E39\u0E04\u0E33\u0E2D\u0E18\u0E34\u0E1A\u0E32\u0E22';
		this_button.style.color = 'blue';
		this_q_num.scrollIntoView()
    }
    else {
        this_div.style.display = 'block';
        this_button.value = '\u0E1B\u0E34\u0E14\u0E04\u0E33\u0E2D\u0E18\u0E34\u0E1A\u0E32\u0E22';
		this_button.style.color = 'red';
    }

	}  // end of if(isPremium
}else{
			showExplain(this_div, this_button,  this_q_num);      // แสดงคำอธิบาย
} //  end of isShowExplanation



} // end of function

function isBuyAndMode(buyAndMode){ // ส่งมาจาก Flutter
var buyAndModeArr = buyAndMode.split("xyz");
var buy = buyAndModeArr[0];
var mode = buyAndModeArr[1];
//alert("buy: " + buy + "\nmode: " + mode);
// ฟังก์ชันนี้ ลอยไว้เฉย ๆ รับค่าที่ส่งมาจาก flutter แต่ไม่ได้ทำอะไร เพราะ ค่าการซื้อ และ โหมดมืด-สว่าง ส่งมาทาง ฟังก์ชัน  is_IsNewClicked()
}


function showExplain(this_div, this_button,  this_q_num){
    if (this_div.style.display !== 'none') {
        this_div.style.display = 'none';
		this_button.value = '\u0E14\u0E39\u0E04\u0E33\u0E2D\u0E18\u0E34\u0E1A\u0E32\u0E22';
		this_button.style.color = 'blue';
		this_q_num.scrollIntoView()
    }
    else {
        this_div.style.display = 'block';
        this_button.value = '\u0E1B\u0E34\u0E14\u0E04\u0E33\u0E2D\u0E18\u0E34\u0E1A\u0E32\u0E22';
		this_button.style.color = 'red';
    }
};


function show_hide_t_spelling(my_div, btn_name) {
 var this_div = document.getElementById(my_div);
 var this_button = document.getElementById(btn_name);
    if (this_div.style.display !== 'none') {
        this_div.style.display = 'none';
  this_button.value = '\u0E14\u0E39\u0E04\u0E33\u0E2D\u0E18\u0E34\u0E1A\u0E32\u0E22';
  this_button.style.color = 'blue';
    }
    else {
        this_div.style.display = 'block';
        this_button.value = '\u0E1B\u0E34\u0E14\u0E04\u0E33\u0E2D\u0E18\u0E34\u0E1A\u0E32\u0E22';
  this_button.style.color = 'red';
    }
};

function checkAns(regn, ans, ans_div, isShowAns, id_for_NEW_label, q_id) {


// คลิกเฉลย ไปปรับค่า isClicked ในตาราง test_item_table ใหเป็น 1
var item_id;  //สำหรับ แสดงคำว่า NEW ถ้าเป็นข้อสอบข้อใหม
//
	if (typeof id_for_NEW_label === 'undefined') {
		item_id = "xx";
		clickedQstns = "111111";
	}else{
		item_id=id_for_NEW_label;
		clickedQstns = clickedQstns  + "ccx" + id_for_NEW_label;
	//	Android.updateIsClickItem(item_id);
	}

var totalQstn = (document.getElementsByTagName("input").length)-2;  //  (-2 คือ input ของ modal-body) หาจำนวนข้อทั้งหมด ของข้อสอบชุดดนี้ เพื่อส่งไป Flutter
var numOfQuestions = totalQstn/6;  // each question has 6 input elements (4 choices)   ใน ไฟล์ข้อสอบ ที่เป็น html ให้มีตัวเลือก 4 ตัว ห้ามมี 5 ตัว (ใน xml มี 5 ตัวเลือกได้ เพราะ ตัวที่ 5 ถ้าว่าง ก็จะไม่แสดง)
// alert ("totalQstn: " + totalQstn + "\nnumOfQuestions: " + numOfQuestions);
var currQstnID = q_id;
msgToSend = numOfQuestions + "xzc" + currQstnID + "xzc" + clickedQstns;

console.log("xxab messageToSend to Flutter: " + msgToSend);

// messageHandler.postMessage(msgToSend);  //   ส่ง id ของข้อสอบ ข้อนี้ ไป Flutter  และจำนวนข้อทั้งหมด
   // เพื่อ เอาไปทำรูปหน้าเมนูแสดงความก้าวหน้า และเอาไว้ตอนจะกลับมา จะได้รู้ว่า ข้อสุดท้ายที่ทำ คือข้อไหน


   // --- กำลังปรับ ถึงตรงนี้ -------

   console.log("aaabbbc args3 send via messageHandler: " + msgToSend);

window.flutter_inappwebview.callHandler('messageHandler', ...msgToSend) // ส่งข้อที่คลิก เพื่อไปทำกราฟวงกลม หน้าเมนู
.then(function (result) {
// รับค่าที่ส่งเข่ามา
    console.log("aaabbbc  isBuyAndMode จาก Flutter to JS via messageHandler: " + result.Message);
    isBuyAndMode(result.Message);
});





var formValid = false;
var radios = document.getElementsByName(regn);
var answer_div = document.getElementById(ans_div);
var formValid = false;
// alert("item id: "+ item_id);

// alert("q_id: "+ q_id);
//  var isPremiumVersion = "false";   // ถ้าบน PC ให้เอาอันนี้
var showAns;  // สำหรับแสดงข้อความ  ถ้าเป็นรุ่นยังไม่ซื้อ บอกว่า มีคำอธิบายเฉพาะรุ่นเต็มเท่านั้น
	if (typeof isShowAns === 'undefined') {
		showAns = "no";
	}else{
		showAns = isShowAns;
	}
	if (showAns === "no") {  // ถ้าตัวที่ส่งเข้ามาจากข้อสอบ บอกว่า ไม่ให้แสดง ต้องเชคต่อว่า เป็นรุ่นอะไร ถ้าเป็นรุ่นเต็ม ก็ให้แสดง ถ้าไม่ใช่ ก็ไม่ให้แสดง
	  //  alert ("isPremiumVersion: " + isPremiumVersion);
		if (isPremiumVersion === "true"){
			showAnswer(regn, ans, ans_div);  // ให้แสดงการตรวจทุกข้อ แม้ว่าจะส่ง ไม่ให้แสดงคำตอบเข้ามา
		}else{  // ถ้าไม่ใช่รุ่นเต็ม ก็บอกว่า แสดงเฉพาะรุ่นเต็มเท่านั้น
			document.getElementById(ans_div).innerHTML = "ข้อนี้ มีเฉลยเฉพาะรุ่นเต็ม เท่านั้น";
			document.getElementById(ans_div).style.backgroundColor = "#ffff99";
			//document.getElementById(ans_div).style.color = "#000000";
			 document.getElementById(ans_div).style.color = "red";
			document.getElementById(ans_div).style.display = "block";
		} // end of    if(isPremiumVersion ==  "true"
	}else{  // ถ้าไม่ใช่ "no" `คือให้แสดงคำตอบ
		showAnswer(regn, ans, ans_div);
	}       // end of    if(showAns ==  "no"

//	var currQuestion = regn.split('q').pop(); // เอาเฉพาะตัวที่ถัดจากตัว q
                                               // เพราะค่าที่ส่งเข้ามา หลังตัว q คือ ข้อสอบข้อที่เท่าไร
 //   sendDataToAndroid(currQuestion);

 // ส่ง id ของข้อที่คลิก ไปเก็บใน SQlite เพื่อว่า เวลาเข้ามา ตอนที่ทำไม่เสร็จ จะได้ ทำต่อ
// sendDataToAndroid(q_id);
}  // end of function checkAns

function hide_div_spelling(whatDiv) {
    var thisDiv = document.getElementById(whatDiv);
        thisDiv.style.display = 'none';
}

function showAnswer(regn, ans, ans_div){

 var radios = document.getElementsByName(regn);
 var answer_div = document.getElementById(ans_div);
var formValid = false;
 var feedback = ['ลองใหม่', 'ลองดูใหม่', 'ลองใหม่อีกครั้ง', 'เกือบถูกแล้ว', 'อุ๊บ...เกือบถูก', 'ลองดูอีกที', 'ลองดูใหม่อีกสักหน','คลิกคำอธิบาย ตรวจสอบดูนะครับ','ทำไมไม่ถูก ลองดู คำอธิบาย'][Math.floor(Math.random() * 9)]
    var i = 0;
    while (!formValid && i < radios.length) {
        if (radios[i].checked) {
			formValid = true;
			 //check answer
			if(radios[i].value == ans){
				answer_div.innerHTML = radios[i].value +"   ถูกต้อง";
				answer_div.style.backgroundColor = "yellow";
				answer_div.style.color = "#339900";
				answer_div.style.display = "block";
		  }else{
				answer_div.innerHTML = radios[i].value +"  ยังไม่ถูก" + " ::   " + feedback;
				answer_div.style.backgroundColor = "#ff6600";
				answer_div.style.color = "#ffffff";
				answer_div.style.display = "block";
		}
  }
        i++;
    }
    if (!formValid) {
document.getElementById(ans_div).innerHTML = "ยังไม่ได้เลือกคำตอบ";
document.getElementById(ans_div).style.backgroundColor = "#ffff99";
document.getElementById(ans_div).style.color = "#000000";

document.getElementById(ans_div).style.display = "block";
//playSound_wrong();
//   document.getElementById("myMessage").innerHTML = "ยังไม่ได้เลือกคำตอบ";
//   modal.style.display = "block";
 }
}

function sendDataToAndroid(qNum_id){
// ฟังก์ชันนี้ ส่งไปยัง Android ทุกครั้ง ที่มีการคลิก คำอธิบาย เพื่อส่งข้อสุดท้ายที่ทำ จะได้เอาไปใช้ทำแถบสีแดง แสดงว่า ชุดนี้ ทำข้อสอบไปถึงไหนแล้ว
// ส่ง ชื่อไฟล์ เลขข้อที่คลิกซึ่งถือว่าเป็นข้อสุดท้ายที่ทำ และ จำนวนข้อทั้งหมดของไฟล์นี้ ไปที่ Android เพื่อไปเก็บในฐานข้อมูล SQLitevว่าถึง ข้ออะไร
var fileName = location.pathname.split("/").slice(-1);
// ข้อที่คลิก ที่ส่งเข้ามา โดยตัดเอาที่ต่อจากเครื่องหมาย _ ในแต่ละ js ต้องตรวจสอบด้วยว่า ค่า q_num ที่ส่งเข้ามา มีเลขข้อหลังจากเครื่องหมาย _ หรือไม่
// const currQstn = q_num.split('_').pop();
var curr_qNum_id = qNum_id;
//alert("qnum: " + curr_qNum_id);
var totalQstn = document.getElementsByTagName("input").length;
numOfQuestions = totalQstn/6;  // each question has 6 input elements (4 choices)
//alert ("numOfQuestions: " + numOfQuestions);
var qstnNumber = curr_qNum_id.match(/\d+$/);  // เอาเฉพาะตัวเลข ซึ่งเป็นเลขข้อ ผลที่ได้ จะเป็นชนิด Array
if (qstnNumber) { // ถ้าไม่ใช่ null
    qstnNumber = qstnNumber[0]; // เอาตัวแรกของ array
}else{
    qstnNumber = "1";  // ถ้าเป็น null ให้เป็น 1 จะได้เริ่มใหม่
}

// เอาตัวเลขข้อ ไปใส่ในตาราง html_progression_table เพื่อให้แสดงเส้นจำนวนข้อที่ทำแล้ว ในหน้าเมนู
// window.Android.saveHtmlProgressionToSQLite("\"" + fileName + "\"", parseInt(qstnNumber), parseInt(numOfQuestions)); // ต้องใช้ parseInt() เพื่อให้เป็น integer ก่อนส่งไป Android ไม่งั้น กลายเป็น 0 หมด
// เอาชื่อ div ของข้อ ไปใส่ตาราง html_last_div_clicked_table เพื่อกลับมา ถ้าทำต่อ จะได้ส่งมาข้อนี้
// window.Android.saveLastDivClickedToSQLite("\"" + fileName + "\"", "\"" + curr_qNum_id + "\"", parseInt(numOfQuestions)); //
}


function functionAlert(){
		document.getElementById("myMessage").innerHTML = "aljsafd sdf fklj asdfklasd f";
		modal.style.display = "block";
}

function goCont(){
// เอา "" ออกจาก WhereToStart
// alert("whereToStart [before]: " + whereToStart);
 // whereToStart = whereToStart.replace(/['"]+/g, '');
// alert("whereToStart [after]: " + whereToStart);

console.log("whereToStart [after]: " + whereToStart);

 document.getElementById(whereToStart).scrollIntoView(); //
 modal.style.display = "none";
}
function startOver(){ // ไม่ต้องทำอะไร เพราะตามปกติ เริ่มที่ 1 อยู่แล้ว
		modal.style.display = "none";
}


function getIDandDate(isNew){
var content = isNew;
var start = "id";
var end = ":date";
var startIndex = content.indexOf(start);
var endIndex = content.indexOf(end);
var startIndex2 = (endIndex + end.length);
var qNumId = content.substring(start.length, endIndex);
var qDate = content.substring(startIndex2);
return qNumId + "xyz" + qDate;

}


function setModeDarkOrLight(htmlMode){

if (htmlMode=="dark"){
document.body.style.backgroundColor = 'black';
document.body.style.color = 'white';
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
    // change background color of table
  // change table row background
  var tableElements = document.getElementsByTagName("table");
  for(var i = 0; i < tableElements.length; i++){
      var thisTable = tableElements[i] ;
      var rows = thisTable.getElementsByTagName("tr") ;
  		for (var j=0; j<rows.length; j++) {
  				rows[j].style.backgroundColor = "gray";
  		}
  	}
}else{
document.body.style.backgroundColor = 'white';
document.body.style.color = 'black';
}
}  // end of function setModeDarkOrLight

