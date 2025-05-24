var not_correct = [];
var message;
var count;

//var numOfQuestions = 10;  // เป็น dummy ว่ามีทั่้งหมด 10 ข้อ
//var currQstnID = "tbl_q10"; // เป็น dummy ว่าทำไปถึงข้อ 10 แล้ว จะได้แสดงเครื่องหมายถูก ว่า ทำหมดแล้ว
//var clickedQstns = "xzcccx11111";
//
//// คือส่งข้อมูลเพื่อส่งไปยัง WillpopScope ซึ่งจะทำงานตอนคลิกปุ่มลูกศรกลับไปยังหน้าที่แล้วที่เข้ามา
//// ข้อมูลที่ส่งไป เอาตามรูปแบบของข้อสอบที่เป็นไฟล์ html ซึ่งประกอบไปด้วย
//// จำนวนข้อทั้งหมด, ข้อปัจจุบันที่คลิก, ชื่อ id และ วันที่
//// ข้อมูลที่จะเอาไปทำ ไอคอน คือ จำนวนข้อทั้งหมด และข้อที่คลิก ซึ่งเป็นชื่อ id โดยที่ Willpop จะแยกเอาเฉพาะตัวเลข
////  ทำข้อที่ 10 จากจำนวนทั้งหมด 10 ข้อ จึงได้ 100% ได้ไอคอนชื่อ p00.png คือ มีเครื่องหมายถูก แสดงว่า เสร็จแล้ว
//var msgToSend = numOfQuestions + "xzc" + currQstnID + clickedQstns;
//
//// ส่งข้อมูลไป flutter ผ่าน JavascriptChannel ชื่อ messageHandler เพื่อบอกว่า ทำเสร็จแล้ว
// messageHandler.postMessage(msgToSend);

// แก้ปัญหา Samsung blank screen
document.getElementById("second_div").scrollIntoView();
document.getElementById("first_div").scrollIntoView();


// รับข้อมูลมาจาก flutter
function isBuyAndMode(myDat){
var inComingData = myDat;
var is_Bought;
var isPremium; // ซื้อแล้ว
var is_darkMode;
var htmlMode; // มืดหรือสว่าง

var element = document.body; // สำหรับเปลี่ยนโหมด มืด-สว่าง โดยเปลี่ยนสี background และ ตัวหนังสือ
var hex = ("#00FF00");  // สำหรับเปลี่ยนสีลิงค์

var demo = document.getElementById("demo_version");  // บางไฟล์มี  div ชื่อ demo_version ต้องซ่อน ถ้าซื้อแล้ว
var full = document.getElementById("full_version");
var fadeout = document.getElementById("fadeout");




// ******************************************************
window.onload = function() {
  check.onclick = result;
}

function result() {


var numOfQuestions = 10;  // เป็น dummy ว่ามีทั่้งหมด 10 ข้อ
var currQstnID = "tbl_q10"; // เป็น dummy ว่าทำไปถึงข้อ 10 แล้ว จะได้แสดงเครื่องหมายถูก ว่า ทำหมดแล้ว
var clickedQstns = "xzcccx11111";

// คือส่งข้อมูลเพื่อส่งไปยัง WillpopScope ซึ่งจะทำงานตอนคลิกปุ่มลูกศรกลับไปยังหน้าที่แล้วที่เข้ามา
// ข้อมูลที่ส่งไป เอาตามรูปแบบของข้อสอบที่เป็นไฟล์ html ซึ่งประกอบไปด้วย
// จำนวนข้อทั้งหมด, ข้อปัจจุบันที่คลิก, ชื่อ id และ วันที่
// ข้อมูลที่จะเอาไปทำ ไอคอน คือ จำนวนข้อทั้งหมด และข้อที่คลิก ซึ่งเป็นชื่อ id โดยที่ Willpop จะแยกเอาเฉพาะตัวเลข
//  ทำข้อที่ 10 จากจำนวนทั้งหมด 10 ข้อ จึงได้ 100% ได้ไอคอนชื่อ p00.png คือ มีเครื่องหมายถูก แสดงว่า เสร็จแล้ว
var msgToSend = numOfQuestions + "xzc" + currQstnID + clickedQstns;

// ส่งข้อมูลไป flutter ผ่าน JavascriptChannel ชื่อ messageHandler เพื่อบอกว่า ทำเสร็จแล้ว
 messageHandler.postMessage(msgToSend);

}
  var score = 0;
  not_correct.length = 0;

	count = 0;

var node_list = document.getElementsByTagName('input');
 
 var count  = 0;
for (var i = 0; i < node_list.length; i++) {
 //   var node = node_list[i];
 
 if (node_list[i].type == 'radio' && node_list[i].checked) {
            count++;
        }

 // alert(count);

    //if (node.getAttribute('type') == 'radio') {
        // do something here with a <input type="text" .../>
        // we alert its value here
     //   alert(node.value);
    }




  score += parseInt(getSelectedRadioValue("q21")) || 0;
  score += parseInt(getSelectedRadioValue("q22")) || 0;
  score += parseInt(getSelectedRadioValue("q23")) || 0;
  score += parseInt(getSelectedRadioValue("q24")) || 0;
  score += parseInt(getSelectedRadioValue("q25")) || 0;
  score += parseInt(getSelectedRadioValue("q26")) || 0;
  score += parseInt(getSelectedRadioValue("q27")) || 0;
  score += parseInt(getSelectedRadioValue("q28")) || 0;
  score += parseInt(getSelectedRadioValue("q29")) || 0;
  score += parseInt(getSelectedRadioValue("q30")) || 0;

var numOfQstns = document.getElementsByClassName("quiz");
//alert (numOfQstns.length);

var notChecked = numOfQstns.length - count;

//alert (numOfQstns.length);

if(not_correct.length !== 0)
	{
	message = "You scored: " + score + "  คิดเป็นร้อยละ  " + parseFloat((score /numOfQstns.length)*100).toFixed(2) + "<br>ข้อที่ทำผิด: " + not_correct.toString();
	}else{
    message = "You scored: " + score + "  คิดเป็นร้อยละ  " + parseFloat((score /numOfQstns.length)*100).toFixed(2)
	};

	if (notChecked > 0)
	{
		message = message + "<br><br>ไม่ได้ทำข้อสอบ จำนวน " + notChecked + " ข้อ" +
		"<br>ท่านสามารถปิดหน้าจอนี้ เพื่อกลับไปทำต่อให้ครบ แล้วกดปุ่ม ส่งคำตอบ อีกครั้ง"
	}



		//var str = parent.document.getElementById('region').innerHTML;
		//document.getElementById("myMessage").innerHTML = str;
		document.getElementById("myMessage").innerHTML = message;
		modal.style.display = "block";

//alert (message);
 // alert("You scored: " + score + " out of 2!" + "\n" + not_correct.toString());
 return false;
}


function getSelectedRadioValue(name) {
  var radios = document.getElementsByName(name);

  for (var i = 0; i < radios.length; i++) {

    if (radios[i].checked) {
		if(radios[i].value==0){
			// add question number in wrong array
			var thisQstn = " ข้อ " + name.substr(1);
			not_correct.push(thisQstn);
		}
      return radios[i].value;
    }

  }
}