var isPremiumVersion;    // ถ้าใช้บน PC เพราะเรียกจาก Android  ไม่ได้ ค่าที่ส่งเข้ามา คือ  true  หรือ  false
var whereToStart;
var isBought;
var thisLastQNum;
var clickedQstns = ""; // สำหรับเก็บค่า ข้อที่คลิก
var numOfNewQstns = 0 //จำนวนข้อใหม่

var isClicked;   // ถึงตรงนี้ เอาค่า isClicked ไปแยก และเชคว่า ใหม่หรือเปล่า -- ถ้าคลิกแล้ว ก็ถือว่าเก่า

  var x, i, thisID, thisDate, allIDS, allDates, content_of_isNew;
   myContent = "";
   x = document.querySelectorAll(".isNew");
     for (i = 0; i < x.length; i++) {
     	content_of_isNew = x[i].textContent;
		console.log("content_of_isNew: " + i + ". " + content_of_isNew);
        stringContent = content_of_isNew + "abc";  // แต่ละอัน คั่นด้วย "abc"
		console.log("stringContent: " + i + ". " + stringContent);
     	myContent += stringContent;
		console.log("myContent: " + i + ". " + myContent);
 		//  get_isNewClicked.postMessage(myContent);  // รูปแบบ myContent เช่น id1608958161:date1630050149abcid1608958162:date1630050150abc
 }

	let args3 = [myContent];
    console.log("myContent sending to Flutter via is_IsNewClicked: " + myContent);
 window.flutter_inappwebview.callHandler('is_IsNewClicked', ...args3)
    .then(function (result) {
    var isNew_lastQNum;
    var isClicked_orNot = result.newString;
    isNew_lastQNum = isClicked_orNot.split('tjk');
    console.log("from FLUTTER isNew_lastQNum: " +  isNew_lastQNum )
    thisLastQNum = isNew_lastQNum[1];
    console.log("from FLUTTER thisLastQNum: " +  thisLastQNum );
    var htmlModeFromFlutter =  isNew_lastQNum[2];  // get light or dark mode for html from sqlite
    // alert("htmlModeFromFlutter: " + htmlModeFromFlutter);
    setModeDarkOrLight(htmlModeFromFlutter);

     isPremiumVersion =  isNew_lastQNum[3];  // get buy status from sqlite
     console.log("from FLUTTER buyStatus: " +  isPremiumVersion);
    var startAt = document.getElementById(thisLastQNum);  // รับมาจาก Flutter
    // alert ("from FLUTTER isBought: " +  isBought );
    startAt.scrollIntoView();  // scroll ไปที่ข้อสุดท้ายที่ทำ ถ้าเพิ่งเข้ามา จะไปที่ top

    var isNewer;  // สำหรับตรวจสอบวันที่ ในฐานข้อมูล กับในไฟล์ แต่ละข้อ

    var isNewContentFromSQL = isNew_lastQNum[0].split('abc');

    var isNewContentFromFile = document.querySelectorAll(".isNew");  // ไปเอาหัวข้อ ใน <div class = isNew
    // alert("isNewFromFile: " + isNewContentFromFile);

    var isExpired;  // ถ้าเกิน 90 วัน จะไม่แสดงคำว่า NEW
    var this_id;  // id ของข้อสอบ ในข้อที่มี isNew  ( เช่น <div class="isNew">id1608958085:date1645677728</div>)
    var id_from_itemTable;  // สำหรับรับค่า id ของข้อนี้  ส่งมาจาก Flutter  จากตาราง itemTable
    var isNew_from_itemTable;  // สำหรับรับค่า isNew ของข้อนี้  ส่งมาจาก Flutter  จากตาราง itemTable
    var isClicked_from_itemTable; // สำหรับรับค่า คลิกแล้วหรือยัง ของข้อนี้  ส่งมาจาก Flutter  จากตาราง itemTable
    var this_item_date_from_file;  // วันที่ของข้อนี้ จากไฟล์ปัจจุบันที่กำลังเปิดใช้งาน ไม่ใช่จากฐานข้อมูล
    // alert("isNewContentFromSQL: " + isNewContentFromSQL);
    // alert("before loop");

    // alert("isNewContentFromSQL.length: " + isNewContentFromSQL.length + " FILE: " + isNewContentFromFile.length);

    if(isNewContentFromSQL.length = isNewContentFromFile.length){  // หาว่าใหม่หรือเปล่า ทำเฉพาะข้อมูลในฐานข้อมูล เท่ากับ <div class = "isNew"> เท่านั้น
    // ซึ่งปกติก็จะเท่ากัน แต่เผื่อเหนียวเอาไว้

    for (i = 0; i < isNewContentFromSQL.length; i++) {

    this_id = string_between_strings("id",":date",isNewContentFromFile[i].textContent);
    var contentArr = (isNewContentFromFile[i].textContent).split(":date"); // แยกเป็นสองส่วน ส่วนหลังคือ วันที่
    this_item_date_from_file =  contentArr[1];   //จะเอาตรวจว่า เก่ามากว่า 90 วันหรือไม่ ถ้าเกิน ไม่บอกว่าใหม่แล้ว

    // หาว่าเกิน 90 วันจากวันปัจจุบัน หรือไม่
    var currDateTime = Math.round(new Date() / 1000);
    isExpired = Math.round((currDateTime - this_item_date_from_file)/86400);  // 86400 คือ จำนวนวินาทีในหนึ่งวัน - ทำวินาทีเป็นวัน

    from_itemTable = isNewContentFromSQL[i].split("sss");  // จะได้ 3 อย่างคือ id, isNew, isClicked
    id_from_itemTable = from_itemTable[0]; // id จากตาราง itemTable
    isNew_from_itemTable = from_itemTable[1];  // ค่าเป็น "1" หรือ "0"; "1"=ใหม่ "0"=ไม่ใหม่ จาก isNew ในตาราง itemTable
    isClicked_from_itemTable = from_itemTable[2];   // ค่าเป็น "true" หรือ "false"; "true"=คลิกทำข้อสอบข้อนี้แล้ว "false"=ยังไม่ได้คลิกเลือกคำตอบ ข้อมูลมาจาก isClicked ในตาราง itemTable

    // alert(i + ". " + this_id + "\nกี่วันแล้ว: " + isExpired + "\nใหม่หรือเก่า(from DB): " + isNew_from_itemTable + "\nคลิกหรือยัง(from DB): " + isClicked_from_itemTable);
    // alert("isClicked_from_itemTable: " + isClicked_from_itemTable + " i =" + i);

    if (isExpired <=90 && isClicked_from_itemTable == "false" && isNew_from_itemTable == "1"){  // แสดงคำว่า NEW ถ้าไฟล์ที่ส่งขึ้นมายังอยู่ในใน 90 วัน และยังไม่ได้คลิก และเป็นไฟล์ใหม่
          isNewContentFromFile[i].style.backgroundColor = "red";
         isNewContentFromFile[i].textContent = "NEW 65";
         isNewContentFromFile[i].style.display = "block";
    } else{
      //   alert("this id (" + this_id + ")  is old");
         isNewContentFromFile[i].style.display = "none";  // ไม่แสดงอะไร
    }
    //alert("this_id: " + this_id + "\nid From SQL: " + id_from_itemTable + "\ni = " + i);
    }  // end of for (i = 0; i < isNewContentFromSQL.length; i++)
    }  // end of if if(isNewContentFromSQL.length = isNewContentFromFile.length){
    // *************************
    var startAt = document.getElementById(thisLastQNum);
    //startAt.scrollIntoView();
    if (startAt = "top"){  // ถ้าเริ่มใหม่ startAt จะเท่ากับ "top"  -- อันนี้เดาเอา เพราะ startAt.scrollIntoView() ไปหา div id = top ซึ่งไม่มี
    	    document.body.scrollTop = 0;  // เลื่อนไปบนสุด
        document.documentElement.scrollTop = 0;
    }

    })



//// แก้ปัญหา Samsung blank screen
//document.getElementById("second_div").scrollIntoView();
//document.getElementById("first_div").scrollIntoView();

 //function is_IsNewClicked(isClicked_orNot) { // รับเข้ามา ทุกข้อ พร้อมทั้งข้อมูลทั้งหมดที่จะใช้ เช่น ซื้อแล้วหรือยัง เป็นต้น
// ค่าที่ส่งเข้ามา คือ id วันที่ และ สถานะว่า ข้อนี้คลิกแล้วหรือยัง -- เปลี่ยนวันที่ เป็น isNew
// โดยมี sss คั่นระหว่าง id และ วันที่ และมี abc คั่นระหว่างชุด
// ต่อด้วย  id ของข้อสุดท้าย ที่ทำก่อนหน้านี้  light/dark mode และ isBought พ่่วงต่อมาด้วย ซึ่งคั่นด้วย "tjk" เช่น
// 50147sss1630050147sssfalseabc501478sss1630050148sssfalseabc501479sss1630050149sssfalseabctjktbl_q5
//  alert ("from FLUTTER: " +  isClicked_orNot );
// แยก id ออก
//alert("isClicked_orNot - from Flutter: isClicked_orNot");

 //}  // end of function


   var x, i, thisID, thisDate, allIDS, allDates, content_of_isNew;
   myContent = "";
   x = document.querySelectorAll(".isNew");
     for (i = 0; i < x.length; i++) {
     content_of_isNew = x[i].textContent;
     //consold.log("content_of_isNew: " + i + ". " + content_of_isNew);

     stringContent = content_of_isNew + "abc";  // แต่ละอัน คั่นด้วย "abc"
     //consold.log("stringContent: " + i + ". " + stringContent);

     myContent += stringContent;
//	 alert ("myContent: " + i + ". " + myContent);
 //  get_isNewClicked.postMessage(myContent);  // รูปแบบ myContent เช่น id1608958161:date1630050149abcid1608958162:date1630050150abc
 }

 args4 = [myContent];
 console.log("myContent sending to Flutter function get_isNewClicked: " + myContent);
//get_isNewClicked.postMessage(myContent); // ส่งไป Flutter รูปแบบ myContent เช่น id1608958161:date1630050149abcid1608958162:date1630050150abc
window.flutter_inappwebview.callHandler('get_isNewClicked', ...args4)

  var x, i;
  x = document.querySelectorAll(".isNew");
 // alert("x.length [isNew]: " + x.length);
  for (i = 0; i < x.length; i++) {
 //   x[i].style.backgroundColor = "red";
//	 var content = x[i].textContent;

}
//
function isBuyAndMode(buyAndMode){ // ส่งมาจาก Flutter
var buyAndModeArr = buyAndMode.split("xyz");
var buy = buyAndModeArr[0];
var mode = buyAndModeArr[1];
// alert("buy: " + buy + "\nmode: " + mode);
// ฟังก์ชันนี้ ลอยไว้เฉย ๆ รับค่าที่ส่งมาจาก flutter แต่ไม่ได้ทำอะไร เพราะ ค่าการซื้อ และ โหมดมืด-สว่าง ส่งมาทาง ฟังก์ชัน  is_IsNewClicked()
}


//// แยก id และวันที่
////var content = "id50147:date1630050147";
////document.getElementById("this_content").innerHTML = content;
//var start = "id";
//var end = ":date";
//var startIndex = content.indexOf(start);
//var endIndex = content.indexOf(end);
//var startIndex2 = (endIndex + end.length);
//var qNumId = content.substring(start.length, endIndex);
//// document.getElementById("abc").innerHTML = "qNumId: " + qNumId;
//var qDate = content.substring(startIndex2);
//
//// alert("qDate ข้อ " + i + ": " + qDate);
////document.getElementById("this_date").innerHTML = qDate;
//
//// var clicked = "false"; // ถ้ายังไม่คลิก ให้แสดง
//	var currDateTime = Math.round(new Date() / 1000);
//	var isExpired = Math.round((currDateTime - qDate)/86400);  // 86400 คือ จำนวนวินาทีในหนึ่งวัน - ทำวินาทีเป็นวัน
//// alert("expired: " + isExpired);

// *************** end of send data to Flutter **********



//  **********************************  ORG starts here

function show_hide_t_lngCnvr(my_div, btn_name, q_num, isShowExpl, id_for_NEW_label) {

var item_id;  //สำหรับ แสดงคำว่า NEW ถ้าเป็นข้อสอบข้อใหม
	if (typeof id_for_NEW_label === 'undefined') {
		item_id = "11111";
	}else{
		item_id = id_for_NEW_label;
//		Android.updateIsClickItem(item_id);
	}
	// alert("item id: "+ item_id);
	var isShowExplanation;
	if (typeof isShowExpl == "undefined") {
		isShowExplanation = "no";
	}else{
		isShowExplanation=isShowExpl;
	}

 var this_div = document.getElementById(my_div);
 var this_button = document.getElementById(btn_name);
  var this_q_num = document.getElementById(q_num);

if (isShowExplanation == "no") {  // ถ้าตัวที่ส่งเข้ามาจากข้อสอบ บอกว่า ไม่ให้แสดงคำอธิบาย ต้องเชคต่อว่า เป็นรุ่นอะไร ถ้าเป็นรุ่นเต็ม ก็ให้แสดง ถ้าไม่ใช่ ก็ไม่ให้แสดง
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
				}else {
					this_div.style.display = 'block';
					this_button.value = '\u0E1B\u0E34\u0E14\u0E04\u0E33\u0E2D\u0E18\u0E34\u0E1A\u0E32\u0E22';
					this_button.style.color = 'red';
			 }
	}  // end of if(isPremium
}else{
			showExplain(this_div, this_button,  this_q_num);      // ถ้าตัวที่ส่งเข้ามาจากข้อสอบ ไม่ใช่ no เช่น yes ก็ให้ แสดงคำอธิบาย
} //  end of isShowExplanation

};  // end of function


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


function checkAns_t_lngCnvr(regn, ans, ans_div, isShowAns, id_for_NEW_label, qstn_num) {
clickedQstns = clickedQstns  + "ccx" + id_for_NEW_label;
var totalQstn = (document.getElementsByTagName("input").length);  //  (ไม่ต้อง -2 เพราะไม่มี input ของ modal-body) หาจำนวนข้อทั้งหมด ของข้อสอบชุดดนี้ เพื่อส่งไป Flutter
var numOfQuestions = totalQstn/6;  // each question has 6 input elements (4 choices)   ใน ไฟล์ข้อสอบ ที่เป็น html ให้มีตัวเลือก 4 ตัว ห้ามมี 5 ตัว (ใน xml มี 5 ตัวเลือกได้ เพราะ ตัวที่ 5 ถ้าว่าง ก็จะไม่แสดง)
//alert ("numOfQuestions: " + numOfQuestions);
// alert (" isShowAns from HTML: " +  isShowAns);
var currQstnID = qstn_num;
msgToSend = numOfQuestions + "xzc" + currQstnID + "xzc" + clickedQstns;
// alert("msgToSend: " + msgToSend);
messageHandler.postMessage(msgToSend);  //   ส่ง id ของข้อสอบ ข้อนี้ ไป Flutter  และจำนวนข้อทั้งหมด
   // เพื่อ เอาไปทำรูปหน้าเมนูแสดงความก้าวหน้า และเอาไว้ตอนจะกลับมา จะได้รู้ว่า ข้อสุดท้ายที่ทำ คือข้อไหน


var item_id;  //สำหรับ แสดงคำว่า NEW ถ้าเป็นข้อสอบข้อใหม

	if (typeof id_for_NEW_label === 'undefined') {
		item_id = "11111";
	}else{
		item_id = id_for_NEW_label;
	}


    var radios = document.getElementsByName(regn);
	var answer_div = document.getElementById(ans_div);
    var formValid = false;
var currQuestion = regn.split('q').pop(); // เอาเฉพาะตัวที่ถัดจากตัว q เพราะค่าที่ส่งเข้ามา หลังตัว q คือ ข้อสอบข้อที่เท่าไร
//  var isPremiumVersion = "no";   // ถ้าบน PC ให้เอาอันนี้
var showAns;
	if (typeof isShowAns === 'undefined') {
		showAns = "no";
	}else{
//	  alert ("isShowAns ส่งมากจาก HTML: " + isShowAns);
		showAns = isShowAns;
	}

	if (showAns == "no") {  // ถ้าตัวที่ส่งเข้ามาจากข้อสอบ บอกว่า ไม่ให้แสดง ต้องเชคต่อว่า เป็นรุ่นอะไร ถ้าเป็นรุ่นเต็ม ก็ให้แสดง ถ้าไม่ใช่ ก็ไม่ให้แสดง
 //    alert ("showAns ที่ส่งมาจาก ตัวข้อสอบ: " + showAns);

//    alert ("isPremiumVersion ใน js file: " + isPremiumVersion);
		if (isPremiumVersion == "true"){
			showAnswer(regn, ans, ans_div);  // ให้แสดงการตรวจทุกข้อ แม้ว่าจะส่ง ไม่ให้แสดงคำตอบเข้ามา
		}else{  // ถ้าไม่ใช่รุ่นเต็ม ก็บอกว่า แสดงเฉพาะรุ่นเต็มเท่านั้น
			document.getElementById(ans_div).innerHTML = "ข้อนี้ มีเฉลยเฉพาะรุ่นเต็ม (Full Version) เท่านั้น";
			document.getElementById(ans_div).style.backgroundColor = "#ffff99";
			//document.getElementById(ans_div).style.color = "#000000";
			 document.getElementById(ans_div).style.color = "red";
			document.getElementById(ans_div).style.display = "block";
		} // end of    if(isPremiumVersion ==  "true"
	}else{  // ถ้าไม่ใช่ "no" `คือให้แสดงคำตอบ
		showAnswer(regn, ans, ans_div);
	}       // end of    if(showAns ==  "no"
// sendDataToAndroid(currQuestion);

}  // end of function checkAns

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


function hide_div_lngCnvr(whatDiv) {
    var thisDiv = document.getElementById(whatDiv);
        thisDiv.style.display = 'none';
}


function goCont(){
// เอา "" ออกจาก WhereToStart
// alert("whereToStart [before]: " + whereToStart);
 whereToStart = whereToStart.replace(/['"]+/g, '');
// alert("whereToStart [after]: " + whereToStart);
 document.getElementById(whereToStart).scrollIntoView(); //

 var pssge_div = whereToStart.substring(0, whereToStart.lastIndexOf("_"));  // เอาเฉพาะก่อนหน้าเครื่องหมาย under score "_" ที่เป็นตัวสุดท้าย
//		alert ("pssge_div: " + pssge_div);
 document.getElementById(pssge_div).scrollIntoView();
 modal.style.display = "none";

}
function startOver(){ // ไม่ต้องทำอะไร เพราะตามปกติ เริ่มที่ 1 อยู่แล้ว
		modal.style.display = "none";
}

function string_between_strings(startStr, endStr, str) {
    pos = str.indexOf(startStr) + startStr.length;
    return str.substring(pos, str.indexOf(endStr, pos));
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

// สำหรับ คำแปล
function showTranslation(myText) {
  var popup = document.getElementById(myText);
  popup.classList.toggle("show");
}