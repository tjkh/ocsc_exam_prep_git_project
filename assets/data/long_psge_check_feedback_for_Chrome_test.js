var isPremiumVersion;    // ถ้าใช้บน PC เพราะเรียกจาก Android  ไม่ได้ ค่าที่ส่งเข้ามา คือ  true  หรือ  false
var whereToStart;
var isBought;
var thisLastQNum;
var clickedQstns = ""; // สำหรับเก็บค่า ข้อที่คลิก
var numOfNewQstns = 0 //จำนวนข้อใหม่

var isClicked;   // ถึงตรงนี้ เอาค่า isClicked ไปแยก และเชคว่า ใหม่หรือเปล่า -- ถ้าคลิกแล้ว ก็ถือว่าเก่า


//// แก้ปัญหา Samsung blank screen
//document.getElementById("second_div").scrollIntoView();
//document.getElementById("first_div").scrollIntoView();


// เรียกฟังก์ชั่น ที่ flutter evaluate โดยส่งข้อมูลจาก Flutter เข้ามาใน Javascript -- อันนี้สำหรับทดสอบ Javascript ด้วย Google Chrome  ค่าที่ส่งเข้าไป เอามาจาก Flutter - Android Studio 
is_IsNewClicked("1608958085sss1645677725sssfalsetjktoptjklighttjktrue");


 //is_IsNewClicked("xxx yyy zzz aaa");

// document.body.classList.toggle("dark-mode");

//
//function compareDatesOfIsNew(FromSQL, FromFile){
//var ab;
//// alert("FromFile: " + FromSQL + "\nFromFile : " + FromFile);
////   // แยก id และวันที่ สำหรับ From SQL
//fromSqlArr = FromSQL.split("sss");  //fromSqlArr[0] = id, fromSqlArr[1] = date, fromSqlArr[2] = status("true" or "false")   [1]-เปลี่ยนจากวันที่ เป็น isNew แล้ว
////alert("fromSqlArr: " + fromSqlArr[2]);
//
////   // แยก id และวันที่ สำหรับ FromFile
////   //var content = "id50147:date1630050147";
//  var start = "id";
//  var end = ":date";
//var startIndex = FromFile.indexOf(start);
//  var endIndex = FromFile.indexOf(end);
// var startIndex2 = (endIndex + end.length);
//  var qNumId_file = FromFile.substring(start.length, endIndex);
//  var qDate_file = FromFile.substring(startIndex2);
//  var qNumId_file = FromFile.substring(start.length, endIndex);
// // alert("qDate_file: " + qDate_file +"\nfromSqlArr[1]: " + fromSqlArr[1] );
// //alert("(qDate_file > fromSqlArr[1]: " + (qDate_file > fromSqlArr[1]) + " คลิกหรือยัง" + fromSqlArr[2] );
//// document.getElementById("abc").innerHTML = "qDate_file: " + qDate_file + " - dateSQL: " + fromSqlArr[1] + " คลิกหรือยัง SQL: " + fromSqlArr[2];
// document.getElementById("isBought").innerHTML = fromSqlArr.toString() + " : " + FromFile.toString();
////  document.getElementById("a4").innerHTML = fromSqlArr[1];
//
//            if((qDate_file > fromSqlArr[1]) && (fromSqlArr[2] == "false")){ // ถ้าวันที่ในไฟล์ที่ส่งเข้ามา มากกว่า วันที่ในฐานข้อมูล และ ยังไม่มีการคลิก
////                // ตรวจสอบต่อไปว่า เกินกว่า 90 วันหรือไม่
//
//            var currDateTime = Math.round(new Date() / 1000);
//            var isExpired = Math.round((currDateTime - qDate_file)/86400);  // 86400 คือ จำนวนวินาทีในหนึ่งวัน - ทำวินาทีเป็นวัน
////			alert("isExpired in: " + isExpired + "days");
//               if(isExpired < 90){ // ถ้าน้อยกว่า 90 วัน  -- ยังไม่ได้คลิก
//					ab = "true";  // NEW -- ยังใหม่อยู่
//			   }else{
//					ab = "false";  // NOT NEW -- เก่าแล้ว หรือ คลิกแล้ว
//			   } // end of  if(isExpired < 90
//			}else{ //  if((qDate_file > fromSqlArr[1]) &&
//				ab = "false";  // วันที่ในไฟล์ ไม่มากกว่าวันที่ในฐานข้อมูล หรือ คลิกแล้ว
//			}  // end of  if((qDate_file > fromSqlArr[1]) && (fromSqlArr[2]
//// alert("ab: " + ab);
//// document.getElementById("a2").innerHTML = "ab: " + ab;
// // document.getElementById("whereToBegin").innerHTML = "ab: " + ab;
//
//return ab;
//}

function is_IsNewClicked(isClicked_orNot) { // รับเข้ามา ทุกข้อ พร้อมทั้งข้อมูลทั้งหมดที่จะใช้ เช่น ซื้อแล้วหรือยัง เป็นต้น
// ค่าที่ส่งเข้ามา คือ id วันที่ และ สถานะว่า ข้อนี้คลิกแล้วหรือยัง -- เปลี่ยนวันที่ เป็น isNew
// โดยมี sss คั่นระหว่าง id และ วันที่ และมี abc คั่นระหว่างชุด
// ต่อด้วย  id ของข้อสุดท้าย ที่ทำก่อนหน้านี้  light/dark mode และ isBought พ่่วงต่อมาด้วย ซึ่งคั่นด้วย "tjk" เช่น
// 50147sss1630050147sssfalseabc501478sss1630050148sssfalseabc501479sss1630050149sssfalseabctjktbl_q5
//  alert ("from FLUTTER: " +  isClicked_orNot );
// แยก id ออก
var isNew_lastQNum;
isNew_lastQNum = isClicked_orNot.split('tjk');
thisLastQNum = isNew_lastQNum[1];
//  alert ("from FLUTTER lastQNum: " +  thisLastQNum );
htmlMode =  isNew_lastQNum[2];  // get light or dark mode for html from sqlite
isBought =  isNew_lastQNum[3];  // get buy status from sqlite
// isPremiumVersion = isBought;
//  alert ("from FLUTTER buyStatus: " +  isBought);

// ค่า sku ที่ส่งเข้ามา เป็น 0 กับ 1 คือ 0 = false (ยังไม่ได้ซื้อ), true = 1 (ซื้อแล้ว - รุ่นเต็ม)
if(isBought==0){
isPremiumVersion = "false";  // isPremiumVersion เป็นเงื่อนไขการแสดง เฉลย และคำอธิบาย
}else{
isPremiumVersion = "true";
};

// เอาข้อมูลไปแยก เพื่อหาว่า วันที่ใหม่หรือเปล่า ข้อมูลระหว่างชุด คั่นด้วย abc ระหว่างตัว คั่นด้วย sss เช่น
// 50147sss1630050147sssfalseabc501478sss1630050148sssfalseabc501479sss1630050149sssfalseabc
//isNew_for_all = isNew_lastQNum[0].split('abc'); // แต่ละชุด คั่นด้วย abc และย่อย แต่ละตัว คั่นด้วย sss
//document.getElementById("abc").innerHTML = "from FLUTTER: " + isNew_for_all[0];
// ต้องวน และเอาวันที่ออกมาเปรียบเทียบ

// **************************

//document.getElementById("a1").innerHTML = thisLastQNum;
var startAt = document.getElementById(thisLastQNum);  // รับมาจาก Flutter
// alert ("from FLUTTER isBought: " +  isBought );
startAt.scrollIntoView();  // scroll ไปที่ข้อสุดท้ายที่ทำ ถ้าเพิ่งเข้ามา จะไปที่ top

//  alert("start at: " + thisLastQNum);

var isNewer;  // สำหรับตรวจสอบวันที่ ในฐานข้อมูล กับในไฟล์ แต่ละข้อ

var isNewContentFromSQL = isNew_lastQNum[0].split('abc');
//alert("isNewContentFromSQL (isNew_lastQNum[0].split('abc')): " + isNewContentFromSQL);
// แต่ละ element จะได้ idของข้อ, isNew(0 หรือ 1), คลิกหรือยัง(true or false)
// document.getElementById("abc").innerHTML = "from FLUTTER: XXXXXX:" + isNewContentFromSQL;
//   isNewContentFromSQL = isClicked_orNot.split('abc');  // มีส่วนเกิน คือ mode และ buyStatus ต่อท้ายมาด้วย
//alert("isNewContentFromSQL (isClicked_orNot.split('abc')): " + isNewContentFromSQL);

var isNewContentFromFile = document.querySelectorAll(".isNew");  // ไปเอาหัวข้อ ใน <div class = isNew
// document.getElementById("abc").innerHTML = isNewContentFromFile.length + " : " + isNewContentFromSQL.length;
// alert (" num of isNew \n\nfrom Flutter: "+ isNewContentFromSQL.length + " \nfrom File: " + isNewContentFromFile.length);
var ab = " ";
// alert("isNewContentFromSQL: " + isNewContentFromSQL);
 for (i = 0; i < isNewContentFromSQL.length; i++) {

//  alert("เท่ากัน:   " + isNewContentFromSQL.length + " -- " + isNewContentFromFile.length);
 if(isNewContentFromSQL.length == isNewContentFromFile.length){ // ตรวจดูว่า เท่ากันหรือไม่ ถ้าไม่เท่ากัน แสดงว่า มีอะไรผิดพลาดตอนใส่ isNew ในไฟล์ html หรือ ตอนไปทำงานใน flutter ถ้ามีข้อผิดพลาด ก็ให้เป็นวันที่เท่ากันเลย ไม่ต้องแสดงข้อความว่า "ใหม่" ทุกข้อ
//updateIsNewLabel(isNewContentFromSQL[i], isNewContentFromFile[i]);
var isNewer = compareDatesOfIsNew(isNewContentFromSQL[i], isNewContentFromFile[i].textContent);
//fromSqlArr = isNewContentFromSQL[i].split("sss");
//isNewer = fromSqlArr[1]; // fromSqlArr = [idของข้อ, isNew(0หรือ1),ข้อนี้คลิกหรือยัง(trueหรือfalse)] ]

// document.getElementById("abc").innerHTML = "fromSQL: " + isNewContentFromSQL[i] + "fromFile" + isNewContentFromFile[i].textContent) + "isNewer" + isNewer;
// if(isNewer=="1"){isNewer="true"}else{isNewer="false"};
ab = ab + isNewer + " ";
 // document.getElementById("whereToBegin").innerHTML = "ab: " + ab.trim();
 // document.getElementById("whereToBegin").innerHTML = "ab: " + ab;
if (isNewer == "true"){
numOfNewQstns = numOfNewQstns +1;
      isNewContentFromFile[i].style.backgroundColor = "red";
      isNewContentFromFile[i].textContent = "NEW 65";
      isNewContentFromFile[i].style.display = "block";
}else{
      isNewContentFromFile[i].style.display = "none";
} // end of if (isNewer == "true"
}else{
    isNewContentFromFile[i].style.display = "none";
}
}  // end of for (i = 0; i < isNewContentFromSQL.length; i++)

// *************************

var startAt = document.getElementById(thisLastQNum);
//startAt.scrollIntoView();
if (startAt = "top"){  // ถ้าเริ่มใหม่ startAt จะเท่ากับ "top"  -- อันนี้เดาเอา เพราะ startAt.scrollIntoView() ไปหา div id = top ซึ่งไม่มี
	    document.body.scrollTop = 0;  // เลื่อนไปบนสุด
    document.documentElement.scrollTop = 0;
}

if (htmlMode=="dark"){
//document.getElementById("a2").innerHTML = "htmlMode inside yes: " + htmlMode;
document.body.classList.toggle("dark-mode");  // use style in mystyle_show_hide _div.css
var x = document.getElementsByClassName("upper");
for(var i=0; i < x.length; i++) {
  x[i].style.backgroundColor = "black"; // div ที่เป็นเรื่องอ่าน;
}
var y = document.getElementsByClassName("lower");
for(var i=0; i < y.length; i++) {
  y[i].style.backgroundColor = "black"; // div ที่เป็นคำถาม;
}
}else{
//document.getElementById("a2").innerHTML = "htmlMode inside yes: " + htmlMode;
document.body.classList.toggle("light-mode");
var x = document.getElementsByClassName("upper"); // div ที่เป็นเรื่องอ่าน
for(var i=0; i < x.length; i++) {
  x[i].style.backgroundColor = "white"; // div ที่เป็นคำถาม;
}
var y = document.getElementsByClassName("lower"); // div ที่เป็นคำถาม
for(var i=0; i < y.length; i++) {
  y[i].style.backgroundColor = "white"; // div ที่เป็นคำถาม;
}

}

 }  // end of function
//
function compareDatesOfIsNew(FromSQL, FromFile){
var ab;
// alert("FromFile: " + FromSQL + "\nFromFile : " + FromFile);
//   // แยก id และวันที่ สำหรับ From SQL
fromSqlArr = FromSQL.split("sss");  //fromSqlArr[0] = id, fromSqlArr[1] = date, fromSqlArr[2] = status("true" or "false")   [1]-เปลี่ยนจากวันที่ เป็น isNew แล้ว
////alert("fromSqlArr: " + fromSqlArr[2]);
//
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
// document.getElementById("abc").innerHTML = "qDate_file: " + qDate_file + " - dateSQL: " + fromSqlArr[1] + " คลิกหรือยัง SQL: " + fromSqlArr[2];
// document.getElementById("isBought").innerHTML = fromSqlArr.toString() + " : " + FromFile.toString();
//  document.getElementById("a4").innerHTML = fromSqlArr[1];

            if((qDate_file > fromSqlArr[1]) && (fromSqlArr[2] == "false")){ // ถ้าวันที่ในไฟล์ที่ส่งเข้ามา มากกว่า วันที่ในฐานข้อมูล และ ยังไม่มีการคลิก
//                // ตรวจสอบต่อไปว่า เกินกว่า 90 วันหรือไม่
//
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
//// alert("ab: " + ab);
//// document.getElementById("a2").innerHTML = "ab: " + ab;
// // document.getElementById("whereToBegin").innerHTML = "ab: " + ab;
//
return ab;
}


// **************************
//
//
//
////******** receieve data from Flutter **********
//function is_IsNewClicked(isClicked_orNot) { // รับเข้ามา ทุกข้อ พร้อมทั้งข้อมูลทั้งหมดที่จะใช้ เช่น ซื้อแล้วหรือยัง เป็นต้น
//// ค่าที่ส่งเข้ามา คือ id วันที่ และ สถานะว่า ข้อนี้คลิกแล้วหรือยัง -- เปลี่ยนวันที่ เป็น isNew
//// โดยมี sss คั่นระหว่าง id และ วันที่ และมี abc คั่นระหว่างชุด
//// ต่อด้วย  id ของข้อสุดท้าย ที่ทำก่อนหน้านี้  light/dark mode และ isBought พ่่วงต่อมาด้วย ซึ่งคั่นด้วย "tjk" เช่น
//// 50147sss1630050147sssfalseabc501478sss1630050148sssfalseabc501479sss1630050149sssfalseabctjktbl_q5
//
//// แยก id ออก
//var isNew_lastQNum;
//isNew_lastQNum = isClicked_orNot.split('tjk');
//thisLastQNum = isNew_lastQNum[1];
//htmlMode =  isNew_lastQNum[2];  // get light or dark mode for html from sqlite
//isBought =  isNew_lastQNum[3];  // get buy status from sqlite
//isPremiumVersion = isBought;
//
//
//document.getElementById("abc").innerHTML = "ข้อสุดท้าย: " + thisLastQNum;
//document.getElementById("isBought").innerHTML = "ซื้อหรือยัง (isBought) : " + isBought;
//document.getElementById("a4").innerHTML = "html mode: " + isNew_lastQNum[2];
//
//
//
//// ค่า sku ในฐานข้อมูล เป็น 0 กับ 1 คือ 0 = false, true = 1
////if(isBought==0){
////isPremiumVersion = "false";  // isPremiumVersion เป็นเงื่อนไขการแสดง เฉลย และคำอธิบาย
////}else{
////isPremiumVersion = "true";
////}
//// เอาข้อมูลไปแยก เพื่อหาว่า วันที่ใหม่หรือเปล่า ข้อมูลระหว่างชุด คั่นด้วย abc ระหว่างตัว คั่นด้วย sss เช่น
//// 50147sss1630050147sssfalseabc501478sss1630050148sssfalseabc501479sss1630050149sssfalseabc
////isNew_for_all = isNew_lastQNum[0].split('abc'); // แต่ละชุด คั่นด้วย abc และย่อย แต่ละตัว คั่นด้วย sss
////document.getElementById("abc").innerHTML = "from FLUTTER: " + isNew_for_all[0];
//// ต้องวน และเอาวันที่ออกมาเปรียบเทียบ
//
//// **************************
//
////document.getElementById("a1").innerHTML = thisLastQNum;
////var startAt = document.getElementById(thisLastQNum);
////startAt.scrollIntoView();
//
//var isNewer;  // สำหรับตรวจสอบวันที่ ในฐานข้อมูล กับในไฟล์ แต่ละข้อ
//
//var isNewContentFromSQL = isNew_lastQNum[0].split('abc');
//// แต่ละ element จะได้ idของข้อ, isNew(0 หรือ 1), คลิกหรือยัง(true or false)
// document.getElementById("abc").innerHTML = "from FLUTTER: XXXXXX:" + isNewContentFromSQL;
////isNewContentFromSQL = isClicked_orNot.split('abc');
//
//// document.getElementById("isBought").innerHTML = "isNewContentFromSQL: " + isNewContentFromSQL;
//
//var isNewContentFromFile = document.querySelectorAll(".isNew");
//// document.getElementById("abc").innerHTML = isNewContentFromFile.length + " : " + isNewContentFromSQL.length;
//
//var ab = " ";
//// alert("isNewContentFromSQL: " + isNewContentFromSQL);
// for (i = 0; i < isNewContentFromSQL.length; i++) {
//
// // alert("เท่ากัน:   " + isNewContentFromSQL.length + " -- " + isNewContentFromFile.length);
// if(isNewContentFromSQL.length == isNewContentFromFile.length){ // ตรวจดูว่า เท่ากันหรือไม่ ถ้าไม่เท่ากัน แสดงว่า มีอะไรผิดพลาดตอนใส่ isNew ในไฟล์ html หรือ ตอนไปทำงานใน flutter ถ้ามีข้อผิดพลาด ก็ให้เป็นวันที่เท่ากันเลย ไม่ต้องแสดงข้อความว่า "ใหม่" ทุกข้อ
//
//// document.getElementById("abc").innerHTML = "yes equal length";
//
//// document.getElementById("abc").innerHTML = "fromFile: " + isNewContentFromFile[i].textContent;
////isNewer = compareDatesOfIsNew(isNewContentFromSQL[i], isNewContentFromFile[i].textContent);
//fromSqlArr = isNewContentFromSQL[i].split("sss");
//isNewer = fromSqlArr[1]; // fromSqlArr = [idของข้อ, isNew(0หรือ1),ข้อนี้คลิกหรือยัง(trueหรือfalse)] ]
//
//// document.getElementById("abc").innerHTML = "fromSQL: " + isNewContentFromSQL[i] + "fromFile" + isNewContentFromFile[i].textContent) + "isNewer" + isNewer;
//if(isNewer=="1"){isNewer="true"}else{isNewer="false"};
//ab = ab + isNewer + " ";
// // document.getElementById("whereToBegin").innerHTML = "ab: " + ab.trim();
//  document.getElementById("whereToBegin").innerHTML = "ab: " + ab;
//if (isNewer == "true"){
//numOfNewQstns = numOfNewQstns +1;
//      isNewContentFromFile[i].style.backgroundColor = "red";
//      isNewContentFromFile[i].textContent = "NEW 65";
//      isNewContentFromFile[i].style.display = "block";
//}else{
//      isNewContentFromFile[i].style.display = "none";
//} // end of if (isNewer == "true"
//}else{
//    isNewContentFromFile[i].style.display = "none";
//}
//    }  // end of for (i = 0; i < isNewContentFromSQL.length; i++)
//// *************************
//
// document.getElementById("abc").innerHTML = "ทดสอบ: ";
//
//// document.getElementById("a1").innerHTML = thisLastQNum;
//var startAt = document.getElementById(thisLastQNum);
//startAt.scrollIntoView();
//
//document.getElementById("a1").innerHTML = "ทดสอบ รับเข้ามาจาก flutter ทั้งหมด: " + isNew_lastQNum;
//// document.getElementById("a2").innerHTML = "htmlMode: " + htmlMode;
//document.getElementById("a3").innerHTML = "isBought: " + isBought;
//document.getElementById("a4").innerHTML = "to start at: " + thisLastQNum;
//if (htmlMode=="dark"){
//document.getElementById("a2").innerHTML = "htmlMode inside yes: " + htmlMode;
//document.body.classList.toggle("dark-mode");  // use style in mystyle_show_hide _div.css
//var x = document.getElementsByClassName("qstn-div").style.backgroundColor = "black"; // ข้อสอบแต่ละข้อ
//}else{
//document.getElementById("a2").innerHTML = "htmlMode inside yes: " + htmlMode;
//document.body.classList.toggle("light-mode");
//var x = document.getElementsByClassName("qstn-div").style.backgroundColor = "white";
//}
//
//document.getElementById("abc").innerHTML = "from FLUTTER: XXXXXX:";
//
////
//////document.getElementById("a1").innerHTML = thisLastQNum;
//////var startAt = document.getElementById(thisLastQNum);
//////startAt.scrollIntoView();
////
////var isNewer;  // สำหรับตรวจสอบวันที่ ในฐานข้อมูล กับในไฟล์ แต่ละข้อ
////
////isNewContentFromSQL = isNew_lastQNum[0].split('abc');
//// document.getElementById("abc").innerHTML = "from FLUTTER: XXXXXX:" + isNewContentFromSQL;
//////isNewContentFromSQL = isClicked_orNot.split('abc');
////
////// document.getElementById("isBought").innerHTML = "isNewContentFromSQL: " + isNewContentFromSQL;
////
////var isNewContentFromFile = document.querySelectorAll(".isNew");
////var ab = " ";
////// alert("isNewContentFromSQL: " + isNewContentFromSQL);
//// for (i = 0; i < isNewContentFromSQL.length; i++) {
////
//// // alert("เท่ากัน:   " + isNewContentFromSQL.length + " -- " + isNewContentFromFile.length);
//// if(isNewContentFromSQL.length == isNewContentFromFile.length){ // ตรวจดูว่า เท่ากันหรือไม่ ถ้าไม่เท่ากัน แสดงว่า มีอะไรผิดพลาดตอนใส่ isNew ในไฟล์ html หรือ ตอนไปทำงานใน flutter ถ้ามีข้อผิดพลาด ก็ให้เป็นวันที่เท่ากันเลย ไม่ต้องแสดงข้อความว่า "ใหม่" ทุกข้อ
////isNewer = compareDatesOfIsNew(isNewContentFromSQL[i], isNewContentFromFile[i].textContent);
////
////ab = ab + isNewer + " ";
//// // document.getElementById("whereToBegin").innerHTML = "ab: " + ab.trim();
////  document.getElementById("whereToBegin").innerHTML = "ab: " + ab;
////if (isNewer == "true"){
////      isNewContentFromFile[i].style.backgroundColor = "red";
////      isNewContentFromFile[i].textContent = "NEW 64";
////      isNewContentFromFile[i].style.display = "block";
////}else{
////      isNewContentFromFile[i].style.display = "none";
////} // end of if (isNewer == "true"
////}else{
////                       isNewContentFromFile[i].style.display = "none";
////}
////    }  // end of for (i = 0; i < isNewContentFromSQL.length; i++)
// }  // end of function
//// *************** end of receieve data from Flutter **********
//
//// *************** send data to Flutter **********
//// ยังไม่ได้ทำ


// *************** end of send data to Flutter **********
function show_hide_LngPsg(my_div, btn_name, q_num, isShowExpl, id_for_NEW_label) {

// คลิกดูคำอธิบาย ไปปรับค่า isClicked ในตาราง test_item_table ใหเป็น 1
var item_id;  //สำหรับ แสดงคำว่า NEW ถ้าเป็นข้อสอบข้อใหม
	if (typeof id_for_NEW_label === 'undefined') {
		item_id = "11111";
	}else{
		item_id=id_for_NEW_label;
//		Android.updateIsClickItem(item_id);
	}
// alert("item id: "+ item_id);
var isShowExplanation;
	if (typeof isShowExpl == "undefined") {
		isShowExplanation = "no";
	}else{
		isShowExplanation=isShowExpl;
	}
// var isPremiumVersion = "no";    // ถ้าใช้บน PC เพราะเรียกจาก Android  ไม่ได
 // var isPremiumVersion = Android.getIsFullVersion(); // เรียก method จาก android class ชื่อ JavaScriptInterface

var isShowExplanation;
	if (typeof isShowExpl == "undefined") {
		isShowExplanation = "no";
	}else{
		isShowExplanation=isShowExpl;
	}

 var this_div = document.getElementById(my_div);
 var this_button = document.getElementById(btn_name);
  var this_q_num = document.getElementById(q_num);

if (isShowExplanation=="no") {  // ถ้าตัวที่ส่งเข้ามาจากข้อสอบ บอกว่า ไม่ให้แสดงคำอธิบาย ต้องเชคต่อว่า เป็นรุ่นอะไร ถ้าเป็นรุ่นเต็ม ก็ให้แสดง ถ้าไม่ใช่ ก็ไม่ให้แสดง
	if (isPremiumVersion == "true"){
			showExplain(this_div, this_button,  this_q_num);      // แสดงคำอธิบาย
}else{  // ถ้าไม่ใช่รุ่นเต็ม ก็บอกว่า แสดงเฉพาะรุ่นเต็มเท่านั้น
	this_div.innerHTML = "&nbsp;&nbsp;ข้อนี้ มีคำอธิบายเฉพาะในรุ่นเต็ม (FULL VERSION) เท่านั้น";
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

// ส่งเลขข้อ ไปที่ Android เพื่อไปเก็บว่าถึง ข้ออะไร ในฟังก์ชันที่เรียก มีการหาจำนวนข้อทั้งหมด และ
// หาชื่อไฟล์ส่งไปพร้อมกัน เพื่อเก็บในฐานข้อมูล SQLite
//var currQstn = q_num.split('_').pop();  // ของเก่า
 // sendDataToAndroid(q_num);  // ส่งไปทั้งหมด ไม่ใช่เฉพาะตัวเลข เพราะจะเอาไปใช้ เวลากลับมาใหม่ ไปที่เดิม

};  // end of function



//id_for_NEW_label

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



function checkAns_Th_LngPsge(regn, ans, ans_div,isShowAns, id_for_NEW_label, qstn_num) {
// document.getElementById("abc").innerHTML = "this is a test. ";
clickedQstns = clickedQstns  + "ccx" + id_for_NEW_label;
var totalQstn = (document.getElementsByTagName("input").length)-2;  //  (-2 คือ input ของ modal-body) หาจำนวนข้อทั้งหมด ของข้อสอบชุดดนี้ เพื่อส่งไป Flutter
var numOfQuestions = totalQstn/6;  // each question has 6 input elements (4 choices)   ใน ไฟล์ข้อสอบ ที่เป็น html ให้มีตัวเลือก 4 ตัว ห้ามมี 5 ตัว (ใน xml มี 5 ตัวเลือกได้ เพราะ ตัวที่ 5 ถ้าว่าง ก็จะไม่แสดง)
//alert ("numOfQuestions: " + numOfQuestions);
var currQstnID = qstn_num;
msgToSend = numOfQuestions + "xzc" + currQstnID + "xzc" + clickedQstns;

// messageHandler.postMessage(msgToSend);  //   ส่ง id ของข้อสอบ ข้อนี้ ไป Flutter  และจำนวนข้อทั้งหมด
   // เพื่อ เอาไปทำรูปหน้าเมนูแสดงความก้าวหน้า และเอาไว้ตอนจะกลับมา จะได้รู้ว่า ข้อสุดท้ายที่ทำ คือข้อไหน



// alert("qstn_num - id ของข้อนี้: " + qstn_num);
// alert("id_for_NEW_label: " + id_for_NEW_label);

// คลิกตรวจคำตอบ ไปปรับค่า isClicked ในตาราง test_item_table ใหเป็น 1
var item_id;  //สำหรับ แสดงคำว่า NEW ถ้าเป็นข้อสอบข้อใหม
    /*
     if(id_for_NEW_label){
    		item_id = id_for_NEW_label;
    		Android.updateIsClickItem(item_id);  // น่าจะไม่ทำงาน เพราะ ในตาราง item_id เป็น integer
    }else{
    item_id = "11111";
    }
	*/

	if (typeof id_for_NEW_label === 'undefined') {
		item_id = "11111";
	}else{
		item_id = id_for_NEW_label;
//		Android.updateIsClickItem(item_id);  // น่าจะไม่ทำงาน เพราะ ในตาราง item_id เป็น integer
	}


// isPremiumVersion;

//  alert("item id: "+ item_id);
//var isPremiumVersion = "no";   // ถ้าใช้บน PC เพราะเรียกจาก Android  ไม่ได้
 // var isPremiumVersion = Android.getIsFullVersion(); // เรียก method จาก android class ชื่อ JavaScriptInterface  // บน android
						// เพื่อเอามาใช้กำหนดให้ไม่แสดงเฉลยและคำอธิบาย ถ้าไม่ใช่ Full version (Premium version)

var radios = document.getElementsByName(regn);
var answer_div = document.getElementById(ans_div);
var formValid = false;
var currQuestion = regn.split('q').pop(); // เอาเฉพาะตัวที่ถัดจากตัว q เพราะค่าที่ส่งเข้ามา หลังตัว q คือ ข้อสอบข้อที่เท่าไร
//  var isPremiumVersion = "no";   // ถ้าบน PC ให้เอาอันนี้
var showAns;
	if (typeof isShowAns === "undefined") {
		showAns = "no";
	}else{
		showAns = isShowAns;
	}


	if (showAns == "no") {  // ถ้าตัวที่ส่งเข้ามาจากข้อสอบ บอกว่า ไม่ให้แสดง ต้องเชคต่อว่า เป็นรุ่นอะไร ถ้าเป็นรุ่นเต็ม ก็ให้แสดง ถ้าไม่ใช่ ก็ไม่ให้แสดง
		if (isPremiumVersion == "true"){
			showAnswer(regn, ans, ans_div);  // ให้แสดงการตรวจทุกข้อ แม้ว่าจะส่ง ไม่ให้แสดงคำตอบเข้ามา
		}else{  // ถ้าไม่ใช่รุ่นเต็ม ก็บอกว่า แสดงเฉพาะรุ่นเต็มเท่านั้น
			document.getElementById(ans_div).innerHTML = "ข้อนี้ มีเฉลยเฉพาะรุ่นเต็ม (FULL VERSION) เท่านั้น";
			document.getElementById(ans_div).style.backgroundColor = "#ffff99";
			//document.getElementById(ans_div).style.color = "#000000";
			 document.getElementById(ans_div).style.color = "red";
			document.getElementById(ans_div).style.display = "block";
		} // end of    if(isPremiumVersion ==  "yes"
	}else{  // ถ้าไม่ใช่ "no" `คือให้แสดงคำตอบ
		showAnswer(regn, ans, ans_div);
	}       // end of    if(showAns ==  "no"
//	sendDataToAndroid(qstn_num);

}  // end of function checkAns

function showAnswer(regn, ans, ans_div) {
    var radios = document.getElementsByName(regn);
	var answer_div = document.getElementById(ans_div);
    var formValid = false;
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
	//playSound_correct();
//  document.getElementById(ans_div).style.display = "block";
 //  document.getElementById("myMessage").innerHTML = radios[i].value +"<br>ถูกต้อง";
 //  modal.style.display = "block";
   //alert(radios[i].value +"\nถูกต้อง"); return false;
  }else{
	 answer_div.innerHTML = radios[i].value +"  ยังไม่ถูก";
	  answer_div.style.backgroundColor = "#ff6600";
	  answer_div.style.color = "#ffffff";
	 answer_div.style.display = "block";
	// playSound_wrong();
   // document.getElementById("myMessage").innerHTML = radios[i].value +"<br>ยังไม่ถูก";
   // modal.style.display = "block";
   //alert(radios[i].value +"\nยังไม่ถูก"); return false;
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

function hide_div_lngPsge(whatDiv) {
    var thisDiv = document.getElementById(whatDiv);
        thisDiv.style.display = 'none';
}
function myResizableDivs() {
  document.getElementById("myPsgeDIV").style.resize = "vertical";
  document.getElementById("myQstnDIV").style.resize = "vertical";
}
//
//function sendDataToAndroid(currQNum){
//
//// alert("sendDataToAndroid- ส่ง id ของข้อสอบไปเก็บ: " + currQNum );
//
//// ฟังก์ชันนี้ ส่งไปยัง Android ทุกครั้ง ที่มีการคลิก คำอธิบาย เพื่อส่งข้อสุดท้ายที่ทำ จะได้เอาไปใช้ทำแถบสีแดง แสดงว่า ชุดนี้ ทำข้อสอบไปถึงไหนแล้ว
//// ส่ง ชื่อไฟล์ เลขข้อที่คลิกซึ่งถือว่าเป็นข้อสุดท้ายที่ทำ และ จำนวนข้อทั้งหมดของไฟล์นี้ ไปที่ Android เพื่อไปเก็บในฐานข้อมูล SQLitevว่าถึง ข้ออะไร
//var fileName = location.pathname.split("/").slice(-1);
//// ข้อที่คลิก ที่ส่งเข้ามา โดยตัดเอาที่ต่อจากเครื่องหมาย _ ในแต่ละ js ต้องตรวจสอบด้วยว่า ค่า q_num ที่ส่งเข้ามา มีเลขข้อหลังจากเครื่องหมาย _ หรือไม่
////const currQstn = q_num.split('_').pop();
//var currQstn = currQNum;
////alert("qnum: " + currQstn);
//var curr_qNum = currQNum;
//var totalQstn = document.getElementsByTagName("input").length;
//numOfQuestions = totalQstn/6;  // each question has 6 input elements (4 choices)
////alert ("numOfQuestions: " + numOfQuestions);
//
//var qstnNumber = curr_qNum.match(/\d+$/);  // เอาเฉพาะตัวเลข ซึ่งเป็นเลขข้อ ผลที่ได้ จะเป็นชนิด Array
//if (qstnNumber) { // ถ้าไม่ใช่ null
//    qstnNumber = qstnNumber[0]; // เอาตัวแรกของ array
//}else{
//    qstnNumber = "1";  // ถ้าเป็น null ให้เป็น 1 จะได้เริ่มใหม่
//}
//
//// alert("qstn number เลขข้อที่ทำ: " + qstnNumber);
//// alert("qstn id ชื่อของข้อ: " + curr_qNum);
//
//// window.Android.saveHtmlProgressionToSQLite("\"" + fileName + "\"", parseInt(currQstn), parseInt(numOfQuestions)); // ต้องใช้ parseInt() เพื่อให้เป็น integer ก่อนส่งไป Android ไม่งั้น กลายเป็น 0 หมด
//window.Android.saveHtmlProgressionToSQLite("\"" + fileName + "\"", parseInt(qstnNumber), parseInt(numOfQuestions)); // ต้องใช้ parseInt() เพื่อให้เป็น integer ก่อนส่งไป Android ไม่งั้น กลายเป็น 0 หมด
//// เอาชื่อ div ของข้อ ไปใส่ตาราง html_last_div_clicked_table เพื่อกลับมา ถ้าทำต่อ จะได้ส่งมาข้อนี้
//window.Android.saveLastDivClickedToSQLite("\"" + fileName + "\"", "\"" + curr_qNum + "\"", parseInt(numOfQuestions)); //
//}





//// function startAt -- not working
//function startAt(thisItem){  // สำหรับจุดเริ่มต้น ถ้าเคยทำมาแล้ว ไปเอาข้อมูลมา แต่ ถ้ายังไม่เคย เริ่มที่ข้อ 1
////alert ("aa: "+ thisItem);
//
//var fileName = location.pathname.split("/").slice(-1);
////alert ("aa: "+ fileName);
//
//
//var start = Android.whereToBegin("\"" + fileName + "\"");
//// alert ("aa: "+ start);
//
////start = 4 ;
//// var thisQnum = thisItem+start; // รับค่า id ของข้อ หน้าตัวเลขข้อ
//var thisQnum = thisItem+start;
////var thisQnum = thisItem+2;
////alert("start at XXX:  " + thisQnum);
//
//document.getElementById(thisQnum).scrollIntoView();
//
//}
//

function manageNewLabel() {

// alert("manageNewLabel function");

/* สำหรับหาเวลา เพื่อใช้เป็น id ของแต่ละข้อที่เพิ่มใหม่ จะได้เอาไปใช้เวลายกเลิกเมื่อมีการคลิก
คัดลอก alert โดยกด Ctrl+C และวางโดย  Ctrl+V เลือกเอาเฉพาะตัวเลข  */

// const timestamp = Math.round(new Date() / 1000);
// alert(timestamp);
//const timestamp2 = Math.round((new Date() / 1000) - (86400*30)); //ถอยหลัง 30 วัน


// สร้างแถบ NEW ที่ข้อใหม่  ถ้ายังไม่ได้คลิก ถ้าคลิกแล้ว ไ่ม่แสดงอะไร
  var x, i;
  x = document.querySelectorAll(".isNew");

 // alert("x.length [isNew]: " + x.length);

  for (i = 0; i < x.length; i++) {
    x[i].style.backgroundColor = "red";
	var content = x[i].textContent;
//	alert(x[i] +"(" + i +") " + x[i]);
//	alert("content: " + content);
	var isClicked = Android.getIsClickedHtml(content); //  เรียก method จาก android class ชื่อ JavaScriptInterface ค่าที่ส่งเข้ามาเป็น Sring คือ  "true"  หรือ  "false" ไม่ใช่ 0 หรือ 1
// alert("isClicked from Android: " + isClicked);
 if(isClicked == "1"){
    var clicked = "true";
 }else{
    var clicked = "false";
 }
//  alert("clicked from JS: " + clicked);
// var clicked = "false"; // ถ้ายังไม่คลิก ให้แสดง
	var currDateTime = Math.round(new Date() / 1000);
	var isExpired = Math.round((currDateTime - content)/86400);  // 86400 คือ จำนวนวินาทีในหนึ่งวัน - ทำวินาทีเป็นวัน
// alert("expired: " + isExpired);
	if (isExpired <=90 && clicked == "false") // ถ้าน้อยกว่า 90 วัน คือ ให้แสดงข้อความว่า NEW อยู่ 90 วัน (เว้นไว้แต่ว่า เคยคลิกเข้ามาดูแล้ว -- ยังไม่ได้ทำ)
//  if (isExpired <=90) // ถ้าน้อยกว่า 90 วัน คือ ให้แสดงข้อความว่า NEW อยู่ 90 วัน (เว้นไว้แต่ว่า เคยคลิกเข้ามาดูแล้ว -- ยังไม่ได้ทำ)

	{
    x[i].textContent = "NEW 65";
    x[i].style.display = "block";
	}else{
    x[i].style.display = "none";
}

 }



// เริ่มใหม่ หรือ ทำต่อ
var fileName = location.pathname.split("/").slice(-1);
// alert("fileName: " + fileName);
//whereToStart = Android.whereToBegin("\"" + fileName + "\""); // ส่งชื่อไฟล์ ไปเอาตำแหน่งเริ่มต้นที่เก็บไว้ใน SQlite
// //  alert("WhereToStart [from Android]: " + whereToStart);
//
//if(whereToStart!=""){  // ถ้าเพิ่งเข้าไฟล์นี้เป็นครั้งแรก จะยังไม่มีการคลิก สิ่งที่ส่งเข้ามาจะเป็น ""
//
//var lastQNum = whereToStart.match(/\d+$/);
////alert("last qNum: " + lastQNum[0]);
//var totalQstn = document.getElementsByTagName("input").length;
//var numOfQuestions = Math.floor(totalQstn/6);  // each question has 6 input elements (4 choices)
//// alert("numOfQuestions " + numOfQuestions);
//
//// ข้อ แรก และ ข้อสุดท้าย ไม่ต้องแสดง
//if((lastQNum[0]>1) && (lastQNum[0]<numOfQuestions)){
//		document.getElementById("myMessage").innerHTML = "ครั้งสุดท้ายท่านทำถึงข้อ " + lastQNum[0] + "<br>ต้องการ เริ่มต้นทำใหม่ หรือ ทำต่อไป";
//		modal.style.display = "block";
//}
//
//// เอา เลขวินาที ที่อยู่ใน <div classs="isNew"></div> ไปใส่ในตารางฐานข้อมูล กำหนด isClicked เป็น 0 ถ้ามีอยู่ในฐานข้อมูลแล้ว ไ่ม่ทำอะไร
//var namesOfItems = ""; // สำหรับเก็บชื่อข้อสอบ เพื่อส่งไปเก็บในฐานข้อมูล
//var x = document.querySelectorAll(".isNew");  // เนื่องจาก ข้อความใน class isNew เป็นตัวเลขวินาที เวลาปัจจุบัน จึงไม่ซ้ำกัน เลยส่งไปที่ Android ให้ใช้
//        //เป็นชื่อสำหรับข้อสอบ
//		// ส่งไปตอนนี้ เอาไปใส่ในฐานข้อมูล sqlite โดยกำหนดให้ isClicked เป็น 0 ไว้ก่อน พอกดปุ่มตรวจ หรือ ดูคำอธิบาย ก็ส่งค่า  1
//		// ไปอัพเดท isClicked อีกที  พอเปิดไฟล์ข้อสอบนี้เข้ามาใหม่ ไปตรวจสอบดู ก็จะได้ไม่แสดงคำว่า NEW
// //var namesOfItems = "";
//// alert("x.length: " + x.length);
// for (i = 0; i < x.length; i++) { // เอาเวลาวินาทีใน isNew ซึ่งจะใข้เป็นชื่อข้อใน sqlite
//                                //  ส่ง array ไป Android ไม่ได้ ต้องทำเป็น String ยาว ๆ ส่งไป แล้วไปแยกเอาทีหลัง
//	var content = x[i].textContent;
//	//alert("(" + i + ")  " +x[i].textContent);
//	namesOfItems += content.concat("|");
//	}
//// alert ("length: " + x.length + " names: " + namesOfItems);
//Android.addHtmlTestItems(namesOfItems);
//
//  }else{  // whereToStart ==""  คือเพิ่งเข้ามา ในฐานข้อมูลยังไม่มีอะไร ให้ไปที่บนสุด
//    document.body.scrollTop = 0;  // เลื่อนไปบนสุด
//    document.documentElement.scrollTop = 0;
//
//
//} // end of if(whereToStart="")

} // end of function


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

