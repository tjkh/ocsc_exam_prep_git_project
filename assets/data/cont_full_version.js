// for Continue Reading in Full Version
//       var isFullVersion = isBought;
       var isBought = document.getElementById("isBought"); // สำหรับทดสอบค่าตัวแปร
       var whereToBegin = document.getElementById("whereToBegin"); // สำหรับทดสอบค่าตัวแปร

       var full = document.getElementById("full_version");
       var fadeout = document.getElementById("fadeout");
       var demo = document.getElementById("demo_version");  // บางไฟล์มี  div ชื่อ demo_version ต้องซ่อน ถ้าซื้อแล้ว

var classRoundedCorner;  // สำหรับเปลี่ยนสีเส้นกรอบ เมื่ออยู่ในโหมดมืด ปกติสีน้ำเงิน พอเป็นโหมดมืด สีน้ำเงินดูจมไป
var classBigBlue;  // สำหรับเปลี่ยนสีตัวหนังสือ เมื่ออยู่ในโหมดมืด ปกติสีน้ำเงินตัวหนา พอเป็นโหมดมืด สีน้ำเงินดูจมไป
var classBigRed;  // สำหรับเปลี่ยนสีตัวหนังสือ เมื่ออยู่ในโหมดมืด ปกติสีแดงตัวหนา พอเป็นโหมดมืด สีแดงดูจมไป
//var linkList = "111";
var linkID;
var lis;
var linkID = document.getElementById('linkList');
if(linkID !== null){
   var lis = document.getElementById('linkList').getElementsByTagName('li');
}

//alert("linkList: " + lis.length % 2);

//myStripeEven = document.querySelectorAll('.stripe :nth-child(even)');  // หาลำดับคี่ ของ คลาส stripe  ถ้าเป็น id ก็ระบุเป็น #stripe
//  for (var i = 0; i < myStripeEven.length; i++) {
//        myStripeEven[i].style.backgroundColor="#818181";
//    }



// ไฟล์ที่เรียกใช้งานนี้ คือไฟล์ html ให้อ่านอย่างเดียวไม่มีการทำข้อสอบ
// เมื่อคลิกมาอ่านแล้ว ถือว่า ทำข้อสอบเสร็จ คือ จะให้ไอคอนหน้าชื่อ แสดงเต็มวง คือ ทำเสร็จ

var numOfQuestions = 10;  // เป็น dummy ว่ามีทั่้งหมด 10 ข้อ
var currQstnID = "tbl_q10"; // เป็น dummy ว่าทำไปถึงข้อ 10 แล้ว จะได้แสดงเครื่องหมายถูก ว่า ทำหมดแล้ว
var clickedQstns = "xzcccx11111";

// คือส่งข้อมูลเพื่อส่งไปยัง WillpopScope ซึ่งจะทำงานตอนคลิกปุ่มลูกศรกลับไปยังหน้าที่แล้วที่เข้ามา
// ข้อมูลที่ส่งไป เอาตามรูปแบบของข้อสอบที่เป็นไฟล์ html ซึ่งประกอบไปด้วย
// จำนวนข้อทั้งหมด, ข้อปัจจุบันที่คลิก, ชื่อ id และ วันที่
// ข้อมูลที่จะเอาไปทำ ไอคอน คือ จำนวนข้อทั้งหมด และข้อที่คลิก ซึ่งเป็นชื่อ id โดยที่ Willpop จะแยกเอาเฉพาะตัวเลข
//  ทำข้อที่ 10 จากจำนวนทั้งหมด 10 ข้อ จึงได้ 100% ได้ไอคอนชื่อ p00.png คือ มีเครื่องหมายถูก แสดงว่า เสร็จแล้ว
var msgToSend = numOfQuestions + "xzc" + currQstnID + clickedQstns;

console.log("pxp msgToSend from con_full_version: " + msgToSend );
// alert("msgToSend: " + msgToSend);
// alert("messageToSed: " + msgToSend);
// ส่งข้อมูลไป flutter ผ่าน JavascriptChannel ชื่อ messageHandler เพื่อบอกว่า ทำเสร็จแล้ว
 // messageHandler.postMessage(msgToSend);

 let args = [msgToSend];

 // alert("args: " + args);   // alert OK

 console.log("pxp args from con_full_version: " + args );

  //   ส่ง id ของข้อสอบ ข้อนี้ ไป Flutter  และจำนวนข้อทั้งหมด
 // เพื่อ เอาไปทำรูปหน้าเมนูแสดงความก้าวหน้า และเอาไว้ตอนจะกลับมา จะได้รู้ว่า ข้อสุดท้ายที่ทำ คือข้อไหน
 window.flutter_inappwebview.callHandler('messageHandler', ...args)
     .then(function (result) {
         console.log("345 Return value from Flutter: ", result.Message);

var inComingData = result.Message;
//var inComingData = myDat;
// ข้อมูลที่ส่งมาจาก flutter คือ ซื้อหรือยังและโหมดอะไร คั่นด้วย xyz เป็นลักษณะข้อความ
// เช่น truexyzfalse = ซื้อแล้ว อยู่ในโหมดสว่าง (ตัวแรก -- true=ซื้อแล้ว-เป็นรุ่นเต็ม, false=ยังไม่ได้ซื้อ-เป็นรุ่นจำกัด) (ตัวที่สอง -- true=มืด, false=สว่าง)
var is_Bought;
var isPremium; // ซื้อแล้ว
var is_darkMode;
var htmlMode; // มืดหรือสว่าง

var element = document.body; // สำหรับเปลี่ยนโหมด มืด-สว่าง โดยเปลี่ยนสี background และ ตัวหนังสือ
var hex = ("#00FF00");  // สำหรับเปลี่ยนสีลิงค์

var demo = document.getElementById("demo_version");  // บางไฟล์มี  div ชื่อ demo_version ต้องซ่อน ถ้าซื้อแล้ว
var full = document.getElementById("full_version");
var fadeout = document.getElementById("fadeout");
var scnd_wrds_oftn_cnfsed = document.getElementById("second_page_words_often_confused_page");

// alert("inComingData: " + inComingData);

classRoundedCorner = document.getElementsByClassName('rcorners1');
if (classRoundedCorner.length >= 1) {
    for (var i = 0; i < classRoundedCorner.length; i++){
        classRoundedCorner[i].style.borderColor = '#FDEAB3';
    }
 }
classBigBlue  = document.getElementsByClassName('big_blue');
if (classBigBlue.length >= 1) {
    for (var i = 0; i < classBigBlue.length; i++){
      //  classBigBlue[i].style.color = '#FBD052';
        classBigBlue[i].style.color = '#000000';

    }
}
classBigRed = document.getElementsByClassName('big_red');
if (classBigRed.length >= 1) {
    for (var i = 0; i < classBigRed.length; i++){
        classBigRed[i].style.color = '#FFC300';
    };
};

// แยก การซื้อ และวโหมด ที่ส่งเข้ามา คั่นด้วย xyz
var datArr = inComingData.split("xyz");   //datArr[0] คือ ซื้อแล้วหรือยัง true=ซื้อแล้ว  datArr[1] คือ โหมดมือหรือไม่  true=ใช่โหมดมืด  false=ไม่ใช่โหมดมืด
is_Bought = datArr[0];
is_darkMode = datArr[1];
if (is_darkMode == "true"){
    htmlMode = "dark";
 }else{
         htmlMode = "light";
     }

// alert("isBought: " +  is_Bought );

  // เปิดให้ใช้งานเต็ม สำหรับไฟล์ที่อธิบายหลักการต่าง ๆ
  is_Bought =  "true";

if (is_Bought == "true"){
    isPremium= true
 }else{
     isPremium= false
     }

  if (isPremium == true) {  // รุ่นเต็ม
        if(full !== null){
			full.style.display = 'block';
			} // แสดงข้อมูลเต็มทั้งหมด
			if (demo !== null) {  // ถ้ามี div ชื่อ demo_version
			       demo.style.display = 'none';  // ซ่อน demo
			}
			if(fadeout !== null){
			    fadeout.parentNode.removeChild(fadeout);  // ซ่อนข้อความ "อ่านต่อในรุ่นเต็ม"
	        }

	}else{  // ยังไม่่ได้ซื้อ
	// alert("mode1: " + htmlMode);  // มีอะไรผิด ก่อนหน้านี้ +++++++
	   if(htmlMode == "dark"){
	       if(full !== null){
	           full.backgroundColor = "black";
	           }
		  if(full !== null){
			    full.style.display = 'none'; // ซ่อนข้อมูลบางส่วนเอาไว้
		  }
		   if (demo !== null) {  // ถ้ามี div ชื่อ demo_version
            		demo.style.display = 'block';  // ซ่อน demo
            }
		    if (fadeout !== null) {
			    fadeout.style.display='block';  // แสดงข้อความ "อ่านต่อในรุ่นเต็ม"
		    if((fadeout !== null) && (htmlMode == "dark")){
        		fadeout.style.background = 'none'; // เอา gradient จาก ดำ ไป ขาว ออกไป เพราะพื้นเป็นสีดำ
        		fadeout.style.backgroundColor = '#e5e5e5';
        		fadeout.style.opacity = "0.8";
        		}
		}
	  }   // end of   if (isPremium == true)
	}

// ปรับโหมด มืด-สว่าง
if (htmlMode=="dark"){

// เปลี่ยนสี เส้นคั่นเศษส่วน
var frac_line = document.getElementsByClassName("bottom");
console.log("fraction_line --con_full_version: " + frac_line.length);
    for(i=0; i<frac_line.length; i++) {
      frac_line[i].style.borderTop = "thin solid #FFFFFF";
    }
    element.style.backgroundColor = 'black';
    element.style.color = 'white';
// alert("mode2: " + htmlMode);

// เปลี่ยนสีพื้น orderList สำหรับลิงค์ (ถ้ามี)
//alert("lis: "+ lis);
if(typeof lis !== typeof undefined){
// if(lis !== null){
      for (var i = 0; i < lis.length; i++) {
     // alert("odd-even: " + i % 2);
            if(i % 2 == 0){
                lis[i].style.backgroundColor = '#818181';
            }else{
            lis[i].style.backgroundColor = '#36454F';
            }
      }
}  // end of if(lis !== null)

if (classBigBlue.length >= 1) {
    for (var i = 0; i < classBigBlue.length; i++){
        classBigBlue[i].style.color = '#FBD052'; // สีเหลืองส้มอ่อน
        // classBigBlue[i].style.color = '#000000';
    }
}  // end of if (classBigBlue.length >= 1)

// สำหรับ หน้า คำศัพท์ที่มักใช้ผิด
	 if(scnd_wrds_oftn_cnfsed !== null){
	             scnd_wrds_oftn_cnfsed.style.backgroundColor = "#818181";  // black
	 }

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
  // alert("before tbl elements");
  var tableElements = document.getElementsByTagName("table");
 // alert("tableElements length: " + tableElements.length);
  for(var i = 0; i < tableElements.length; i++){
      var thisTable = tableElements[i] ;
      var rows = thisTable.getElementsByTagName("tr") ;
  		for (var j=0; j<rows.length; j++) {
  		 if (j % 2 == 0){
                rows[j].style.backgroundColor = "#818181";
            }else{
                rows[j].style.backgroundColor = "#6a6a6a ";
  			//	rows[j].style.backgroundColor = "#818181";
  			//	rows[j].style.backgroundColor = "red";
  			}
  		}
  	}

}else{
element.style.backgroundColor = 'white';
element.style.color = 'black';
}

// end of copy---


     })
     .catch(function (error) {
         console.error("345 Error: ", error);
     }
     );   // end of window.flutter_inappwebview.callHandler






//

/*
// รับข้อมูลมาจาก flutter
function isBuyAndMode(myDat){
var inComingData = myDat;
// ข้อมูลที่ส่งมาจาก flutter คือ ซื้อหรือยังและโหมดอะไร คั่นด้วย xyz เป็นลักษณะข้อความ
// เช่น truexyzfalse = ซื้อแล้ว อยู่ในโหมดสว่าง (ตัวแรก -- true=ซื้อแล้ว-เป็นรุ่นเต็ม, false=ยังไม่ได้ซื้อ-เป็นรุ่นจำกัด) (ตัวที่สอง -- true=มืด, false=สว่าง)
var is_Bought;
var isPremium; // ซื้อแล้ว
var is_darkMode;
var htmlMode; // มืดหรือสว่าง

var element = document.body; // สำหรับเปลี่ยนโหมด มืด-สว่าง โดยเปลี่ยนสี background และ ตัวหนังสือ
var hex = ("#00FF00");  // สำหรับเปลี่ยนสีลิงค์

var demo = document.getElementById("demo_version");  // บางไฟล์มี  div ชื่อ demo_version ต้องซ่อน ถ้าซื้อแล้ว
var full = document.getElementById("full_version");
var fadeout = document.getElementById("fadeout");
var scnd_wrds_oftn_cnfsed = document.getElementById("second_page_words_often_confused_page");

// alert("inComingData: " + inComingData);

classRoundedCorner = document.getElementsByClassName('rcorners1');
if (classRoundedCorner.length >= 1) {
    for (var i = 0; i < classRoundedCorner.length; i++){
        classRoundedCorner[i].style.borderColor = '#FDEAB3';
    }
 }
classBigBlue  = document.getElementsByClassName('big_blue');
if (classBigBlue.length >= 1) {
    for (var i = 0; i < classBigBlue.length; i++){
      //  classBigBlue[i].style.color = '#FBD052';
        classBigBlue[i].style.color = '#000000';

    }
}
classBigRed = document.getElementsByClassName('big_red');
if (classBigRed.length >= 1) {
    for (var i = 0; i < classBigRed.length; i++){
        classBigRed[i].style.color = '#FFC300';
    };
};

// แยก การซื้อ และวโหมด ที่ส่งเข้ามา คั่นด้วย xyz
var datArr = myDat.split("xyz");   //datArr[0] คือ ซื้อแล้วหรือยัง true=ซื้อแล้ว  datArr[1] คือ โหมดมือหรือไม่  true=ใช่โหมดมืด  false=ไม่ใช่โหมดมืด
is_Bought = datArr[0];
is_darkMode = datArr[1];
if (is_darkMode == "true"){
    htmlMode = "dark";
 }else{
         htmlMode = "light";
     }

// alert("isBought: " +  is_Bought );

  // เปิดให้ใช้งานเต็ม สำหรับไฟล์ที่อธิบายหลักการต่าง ๆ
  is_Bought =  "true";

if (is_Bought == "true"){
    isPremium= true
 }else{
     isPremium= false
     }

  if (isPremium == true) {  // รุ่นเต็ม
        if(full !== null){
			full.style.display = 'block';
			} // แสดงข้อมูลเต็มทั้งหมด
			if (demo !== null) {  // ถ้ามี div ชื่อ demo_version
			       demo.style.display = 'none';  // ซ่อน demo
			}
			if(fadeout !== null){
			    fadeout.parentNode.removeChild(fadeout);  // ซ่อนข้อความ "อ่านต่อในรุ่นเต็ม"
	        }

	}else{  // ยังไม่่ได้ซื้อ
	// alert("mode1: " + htmlMode);  // มีอะไรผิด ก่อนหน้านี้ +++++++
	   if(htmlMode == "dark"){
	       if(full !== null){
	           full.backgroundColor = "black";
	           }
		  if(full !== null){
			    full.style.display = 'none'; // ซ่อนข้อมูลบางส่วนเอาไว้
		  }
		   if (demo !== null) {  // ถ้ามี div ชื่อ demo_version
            		demo.style.display = 'block';  // ซ่อน demo
            }
		    if (fadeout !== null) {
			    fadeout.style.display='block';  // แสดงข้อความ "อ่านต่อในรุ่นเต็ม"
		    if((fadeout !== null) && (htmlMode == "dark")){
        		fadeout.style.background = 'none'; // เอา gradient จาก ดำ ไป ขาว ออกไป เพราะพื้นเป็นสีดำ
        		fadeout.style.backgroundColor = '#e5e5e5';
        		fadeout.style.opacity = "0.8";
        		}
		}
	  }   // end of   if (isPremium == true)
	}

// ปรับโหมด มืด-สว่าง
if (htmlMode=="dark"){

// เปลี่ยนสี เส้นคั่นเศษส่วน
var frac_line = document.getElementsByClassName("bottom");
console.log("fraction_line --con_full_version: " + frac_line.length);
    for(i=0; i<frac_line.length; i++) {
      frac_line[i].style.borderTop = "thin solid #FFFFFF";
    }
    element.style.backgroundColor = 'black';
    element.style.color = 'white';
// alert("mode2: " + htmlMode);

// เปลี่ยนสีพื้น orderList สำหรับลิงค์ (ถ้ามี)
//alert("lis: "+ lis);
if(typeof lis !== typeof undefined){
// if(lis !== null){
      for (var i = 0; i < lis.length; i++) {
     // alert("odd-even: " + i % 2);
            if(i % 2 == 0){
                lis[i].style.backgroundColor = '#818181';
            }else{
            lis[i].style.backgroundColor = '#36454F';
            }
      }
}  // end of if(lis !== null)

if (classBigBlue.length >= 1) {
    for (var i = 0; i < classBigBlue.length; i++){
        classBigBlue[i].style.color = '#FBD052'; // สีเหลืองส้มอ่อน
        // classBigBlue[i].style.color = '#000000';
    }
}  // end of if (classBigBlue.length >= 1)

// สำหรับ หน้า คำศัพท์ที่มักใช้ผิด
	 if(scnd_wrds_oftn_cnfsed !== null){
	             scnd_wrds_oftn_cnfsed.style.backgroundColor = "#818181";  // black
	 }

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
  // alert("before tbl elements");
  var tableElements = document.getElementsByTagName("table");
 // alert("tableElements length: " + tableElements.length);
  for(var i = 0; i < tableElements.length; i++){
      var thisTable = tableElements[i] ;
      var rows = thisTable.getElementsByTagName("tr") ;
  		for (var j=0; j<rows.length; j++) {
  		 if (j % 2 == 0){
                rows[j].style.backgroundColor = "#818181";
            }else{
                rows[j].style.backgroundColor = "#6a6a6a ";
  			//	rows[j].style.backgroundColor = "#818181";
  			//	rows[j].style.backgroundColor = "red";
  			}
  		}
  	}

}else{
element.style.backgroundColor = 'white';
element.style.color = 'black';
}

// end of copy---
}
*/
