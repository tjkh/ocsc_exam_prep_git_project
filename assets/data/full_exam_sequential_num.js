//var isPremiumVersion = "false";    // ถ้าใช้บน PC เพราะเรียกจาก Android  ไม่ได้ ค่าที่ส่งเข้ามา คือ  true  หรือ  false
 //var isPremiumVersion = Android.getIsFullVersion(); // เรียก method จาก android class ชื่อ JavaScriptInterface    ค่าที่ส่งเข้ามา คือ  true  หรือ  false

// วันนี้เรียนรู้อีกอย่าง เรื่องการรับส่งข้อมูลระหว่าง flutter - javascript
// ประเด็นคือ ต้องอยู่ใน JavascriptChannel เดียวกัน เช่น ไฟล์นี้ full_exam.js
// ส่งข้อมูลไปทาง MessageHandler ก็ต้องสร้างฟังก์ชัน isBuyAndMode เพื่อรับข้อมูล
// จะไปสร้าง is_IsNewClicked เพื่อรับข้อมูลไม่ได้ เพราะอยู่คนละ Channel กัน
// หาอยู่ตั้งนานว่า ผิดตรงไหน เพราะ flutter ไม่บอกว่ามี error เพียงแต่ไม่มีค่าตัวแปรที่ส่งมาให้

// let touchstartX = 0
// let touchendX = 0

// function checkDirection() {
// //  if (touchendX < touchstartX) alert('swiped left!')
// //  if (touchendX > touchstartX) alert('swiped right!')
// if (touchendX < touchstartX){prevPage()}
// if (touchendX > touchstartX){nextPage()}
// }

// document.addEventListener('touchstart', e => {
//   touchstartX = e.changedTouches[0].screenX
// })

// document.addEventListener('touchend', e => {
//   touchendX = e.changedTouches[0].screenX
//   checkDirection()
// })
var htmlMode; // มืดหรือสว่าง  64
var isPremiumVersion;
var correct_qstns = [];
var not_correct = [];
var skipped_qstns = [];
var message;
var count;
var hour=0;
var min=0;
var sec=0;
var myVar = 0;  // for timer setInterval
var is_Bought;
// ***************

var numOfQuestions = 10;  // เป็น dummy ว่ามีทั่้งหมด 10 ข้อ
var currQstnID = "tbl_q10"; // เป็น dummy ว่าทำไปถึงข้อ 10 แล้ว จะได้แสดงเครื่องหมายถูก ว่า ทำหมดแล้ว
var clickedQstns = "xzcccx11111";


var lastQstnArr; // สำหรับเก็บ ข้อสุดท้ายแบบฝึกหัดที่เคยทำ ซึ่งเก็บไว้ใน sharePref

var swipeEnabled = true;  // Set this to true to enable, false to disable

var menuIDs = [];
Array.from(
    document.querySelectorAll('[id^="exMenu_"]'))
    .forEach(function (x) {
    //    copyText += x.text + '\n'
		//copyText += x.name + '\n'
		menuIDs.push(x.id);
    }
);
//alert("copyText: " + copyText);


var namesToSend = menuIDs.toString();

// alert("namesToSend: " + namesToSend);
// console.log("copyText -- namesToSend: " + namesToSend);

//menuNameToFlutter.postMessage(namesToSend);


let args4 = [namesToSend];
console.log("345 namesToSend args3 to Flutter: " + args4);
// send to Flutter
 window.flutter_inappwebview.callHandler('menuNameToFlutter', ...args4 );



// รับข้อมูลมาจาก flutter
function getLastQstnNum(myLastQNum){
console.log("myLastQNum from Flutter: " + myLastQNum);
 //   let thisLNumber = myLastQNum;
  //  console.log("thisNumber from Flutter: " + thisLNumber);

    //    console.log("345 Return is_IsNewClicked - result.newString: ", result.menuName);

        var incoming = myLastQNum;
        console.log("incoming myLastQNum from Flutter: " + incoming);
      //  var incoming = result.menuName;

            lastQstnArr = incoming.split(" "); // แยกออกจากกัน โดยใช้ช่องว่าง เป็นเกณฑ์
           console.log("lastQstnArr from sharePref: " + lastQstnArr);
           console.log("lastQstnArr[2]: " + lastQstnArr[2]);


          // เอาเฉพาะตัวเลขมารวมกัน เพื่อเอาไปคิดเปอร์เซ็นต์ ว่า ทำไปเท่าไรแล้ว

          //แยก แล้วเอาเฉพาะตัวเลข(อยู่ในรูป String)  ที่อยู่หลัง xyz
          var numbers = lastQstnArr.map(function(n){
             return n.split("xyz")[1];
          })

        // เปลี่ยน string เป็นตัวเลข จะได้เอาไปบวกกันได้
        numbers = numbers.map(Number);
        let thisNumFromMap = numbers;
        console.log("zz numbers from map: " + thisNumFromMap);
          // รวมทั้งหมดเข้าด้วยกัน
          var thisSum = numbers.reduce(add, 0); // with initial value to avoid when the array is empty

        function add(accumulator, a) {
            return accumulator + a;
          }

        console.log("zz thisSum: " + thisSum);


        // เลขข้อสุดท้าย ยัง undefined อยู่
        	if(thisSum <= 5){  // เพราะว่า ตอนแรก ยังไม่ได้ทำ เข้ามาใหม่ ๆ กำหนดให้เป็น ข้อ 1 ใน sharePref มี 4 เมนู
        	 alreadyDone = 0;
        	}else{
        	alreadyDone = thisSum;
        	}

            currQstnID = "tbl_q" + alreadyDone;

         console.log("zz currQstnID: " + currQstnID);

        var args = numOfQuestions + "xzc" + currQstnID + clickedQstns;

 //       var msgToSend = numOfQuestions + "xzc" + currQstnID + clickedQstns;
//
//         messageHandler.postMessage(msgToSend);  // ***************************** ย้ายมาจาก 119
//

console.log("zz messege to Flutter via messageHandler: " + args);

// ส่งข้อมูลไป Flutter
window.flutter_inappwebview.callHandler('messageHandler', ...args)
.then(function (result) {
// รับค่าที่ส่งเข่ามา
    console.log("isBuyAndMode จาก Flutter to JS via messageHandler: " + result.Message);
    isBuyAndMode(result.Message);
});

}




// คือส่งข้อมูลเพื่อส่งไปยัง WillpopScope ซึ่งจะทำงานตอนคลิกปุ่มลูกศรกลับไปยังหน้าที่แล้วที่เข้ามา
// ข้อมูลที่ส่งไป เอาตามรูปแบบของข้อสอบที่เป็นไฟล์ html ซึ่งประกอบไปด้วย
// จำนวนข้อทั้งหมด, ข้อปัจจุบันที่คลิก, ชื่อ id และ วันที่
// ข้อมูลที่จะเอาไปทำ ไอคอน คือ จำนวนข้อทั้งหมด และข้อที่คลิก ซึ่งเป็นชื่อ id โดยที่ Willpop จะแยกเอาเฉพาะตัวเลข
//  ทำข้อที่ 10 จากจำนวนทั้งหมด 10 ข้อ จึงได้ 100% ได้ไอคอนชื่อ p00.png คือ มีเครื่องหมายถูก แสดงว่า เสร็จแล้ว
var msgToSend = numOfQuestions + "xzc" + currQstnID + clickedQstns;

//// แก้ปัญหา Samsung blank screen
//document.getElementById("second_div").scrollIntoView();
//document.getElementById("first_div").scrollIntoView();

// ระวังตรงนี้ เวลา copy มาจาก Notebook มันคอมเม้นออก ต้องเอามาใส่ ไม่งั้นไม่รับข้อมูลจาก Flutter
// ส่งข้อมูลไป flutter ผ่าน JavascriptChannel ชื่อ messageHandler เพื่อบอกว่า ทำเสร็จแล้ว
// messageHandler.postMessage(msgToSend);  // *****************************


// ปรับใหม่ สำหรับ flutter_inappWebView
// let args3 = ["Hello from is_IsNewClicked!"];
let args3 = [msgToSend];

 window.flutter_inappwebview.callHandler('messageHandler', ...args3)
    .then(function (result) {
        console.log("345 Return is_IsNewClicked - result.newString: ", result.Message);

        var inComingData = result.Message;

        var isPremium; // ซื้อแล้ว
        var is_darkMode;
        // var htmlMode; // มืดหรือสว่าง

        var element = document.body; // สำหรับเปลี่ยนโหมด มืด-สว่าง โดยเปลี่ยนสี background และ ตัวหนังสือ
        var hex = ("#00FF00");  // สำหรับเปลี่ยนสีลิงค์

         // alert("buy already?");

        // แยก การซื้อ และโหมด ที่ส่งเข้ามา คั่นด้วย xyz
        // เรื่องซื้อ ไม่ต้องเชค เพราะกันไว้แล้วว่า ถ้ายังไม่ซื้อ ไม่ให้เข้ามาทำข้อสอบที่นี
        datArr = inComingData.split("xyz");   //datArr[0] คือ ซื้อแล้วหรือยัง true=ซื้อแล้ว  datArr[1] คือ โหมดมือหรือไม่  true=ใช่โหมดมืด  false=ไม่ใช่โหมดมืด

        is_Bought = datArr[0];

        //alert("datArr buy already? " +  is_Bought);


        // ไม่ต้องเชคแล้ว เพราะถ้ายังไม่ซื้อ ไม่ให้เข้ามาที่นี่เลย
        //var demo = document.getElementById("demo_version");  // บางไฟล์มี  div ชื่อ demo_version ต้องซ่อน ถ้าซื้อแล้ว
        //var full = document.getElementById("full_version");
        //var fadeout = document.getElementById("fadeout");

        classRoundedCorner = document.getElementsByClassName('rcorners1');
        if (classRoundedCorner.length >= 1) {
            for (var i = 0; i < classRoundedCorner.length; i++){
                classRoundedCorner[i].style.borderColor = '#FDEAB3';
            };
         };
        classBigBlue  = document.getElementsByClassName('big_blue');
        if (classBigBlue.length >= 1) {
            for (var i = 0; i < classBigBlue.length; i++){
                classBigBlue[i].style.color = '#FBD052';
            };
        };
        classBigRed = document.getElementsByClassName('big_red');
        if (classBigRed.length >= 1) {
            for (var i = 0; i < classBigRed.length; i++){
                classBigRed[i].style.color = '#FFC300';
            };
        };
        //
        //// แยก การซื้อ และโหมด ที่ส่งเข้ามา คั่นด้วย xyz
        //// เรื่องซื้อ ไม่ต้องเชค เพราะกันไว้แล้วว่า ถ้ายังไม่ซื้อ ไม่ให้เข้ามาทำข้อสอบที่นี
        //datArr = myDat.split("xyz");   //datArr[0] คือ ซื้อแล้วหรือยัง true=ซื้อแล้ว  datArr[1] คือ โหมดมือหรือไม่  true=ใช่โหมดมืด  false=ไม่ใช่โหมดมืด
        //
        //is_Bought = datArr[0];
        // alert("buy already?" +  is_Bought);

        // ปรับโหมด มืด-สว่าง
        is_darkMode = datArr[1];

        // alert("is_darkMode \n(true = โหมดมืด, false = โหมดสว่าง) :" + is_darkMode);

        if (is_darkMode == "true"){
            htmlMode = "dark";
         }else{
                 htmlMode = "light";
             }
        // alert("htmlMode: "+ htmlMode);


        if (htmlMode=="dark"){ // ถ้าอยู่ในโหมด มืด
        element.style.backgroundColor = 'black';
        element.style.color = 'white';

         // กรอบล้อมรอบ คำถาม
         var tableBorder = document.getElementById("listingTable");
         tableBorder.style.borderColor = "gray";

         // กรอบล้อมรอบ คำตอบ
          var show_Answer = document.getElementById("showAnswer");
          show_Answer.style.borderColor = "gray";

        // เส้นคั่น ระหว่าง เศษ และ ส่วน

        //var frac_line = document.getElementsByClassName('span.bottom');
        //  for (var i = 0; i < frac_line.length; i++) {
        //    frac_line[i].style.color = 'white';
        //  }
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

        //  เปลี่ยนพื้นหลัง modal-content ที่แสดงผลการทำข้อสอบ
        var modalContent = document.getElementsByClassName("modal-content")[0];
        //  alert("modalContent: " + modalContent);
        modalContent.style.backgroundColor = '#808080';

         // change background color of timer wraper
        var timerWrapper = document.getElementsByClassName("timer_wrapper");
        if (timerWrapper.length >= 1) {
            for (var i = 0; i < timerWrapper.length; i++){
                timerWrapper[i].style.backgroundColor = '#808080';
            };
            // change timer font color from red to white
            var time = document.getElementById("timer");
            time.style.color = '#FFFFFF';
         };
        //  เปลี่ยนสีพื้นตาราง ไม่เสถียร เลยไม่เปลี่ยน แก้เป็นสีน้ำตาลใน css แทน ใช้ทั้งสองโหมด
        // ไม่เสถียร เพราะ ตอน run ครั้งแรก javascript ทำงานก่อน จึงไม่เจอตาราง ต้องเอา javascript ไปไว้ตอนท้าย เพื่อให้ทั้งหน้า load ให้เสร็จเรียบร้อยเสียก่อน
        //// // qstn-div
        var qstn_div = document.getElementsByClassName("qstn-div");
        //   alert("qstn_div length: " + qstn_div.length);
         if (qstn_div.length >= 1) {
             for (var i = 0; i < qstn_div.length; i++){
          //   alert("qstn_div number: " + i);
                 qstn_div[i].style.backgroundColor = '#4f4f4f';
             };
          };



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




        //  // change table row background
        //  var tableElements = document.getElementsByTagName("table");
        //   //    alert("table length: " + tableElements.length);
        //  for(var i = 0; i < tableElements.length; i++){
        //      var thisTable = tableElements[i];
        //      var rows = thisTable.getElementsByTagName("tr") ;
        //  //   alert("rows length: " + rows.length);
        //  		for (var j=0; j<rows.length; j++) {
        //  	//	     alert("what rows: " + j);
        //  		rows[j].style.backgroundColor = "#5f5f5f";
        //        }
        //  	}  // end of for(var i = 0; i < tableElements

        }else{  // ถ้าอยู่ในโหมด สว่าง
        element.style.backgroundColor = 'white';
        element.style.color = 'black';


        }

        });  // end of window.flutter_inappwebview.callHandler

// รับข้อมูลมาจาก flutter
function isBuyAndMode(myDat){
var inComingData = myDat;

var isPremium; // ซื้อแล้ว
var is_darkMode;
// var htmlMode; // มืดหรือสว่าง

var element = document.body; // สำหรับเปลี่ยนโหมด มืด-สว่าง โดยเปลี่ยนสี background และ ตัวหนังสือ
var hex = ("#00FF00");  // สำหรับเปลี่ยนสีลิงค์

 // alert("buy already?");

// แยก การซื้อ และโหมด ที่ส่งเข้ามา คั่นด้วย xyz
// เรื่องซื้อ ไม่ต้องเชค เพราะกันไว้แล้วว่า ถ้ายังไม่ซื้อ ไม่ให้เข้ามาทำข้อสอบที่นี
datArr = myDat.split("xyz");   //datArr[0] คือ ซื้อแล้วหรือยัง true=ซื้อแล้ว  datArr[1] คือ โหมดมือหรือไม่  true=ใช่โหมดมืด  false=ไม่ใช่โหมดมืด

is_Bought = datArr[0];

//alert("datArr buy already? " +  is_Bought);


// ไม่ต้องเชคแล้ว เพราะถ้ายังไม่ซื้อ ไม่ให้เข้ามาที่นี่เลย
//var demo = document.getElementById("demo_version");  // บางไฟล์มี  div ชื่อ demo_version ต้องซ่อน ถ้าซื้อแล้ว
//var full = document.getElementById("full_version");
//var fadeout = document.getElementById("fadeout");

classRoundedCorner = document.getElementsByClassName('rcorners1');
if (classRoundedCorner.length >= 1) {
    for (var i = 0; i < classRoundedCorner.length; i++){
        classRoundedCorner[i].style.borderColor = '#FDEAB3';
    };
 };
classBigBlue  = document.getElementsByClassName('big_blue');
if (classBigBlue.length >= 1) {
    for (var i = 0; i < classBigBlue.length; i++){
        classBigBlue[i].style.color = '#FBD052';
    };
};
classBigRed = document.getElementsByClassName('big_red');
if (classBigRed.length >= 1) {
    for (var i = 0; i < classBigRed.length; i++){
        classBigRed[i].style.color = '#FFC300';
    };
};
//
//// แยก การซื้อ และโหมด ที่ส่งเข้ามา คั่นด้วย xyz
//// เรื่องซื้อ ไม่ต้องเชค เพราะกันไว้แล้วว่า ถ้ายังไม่ซื้อ ไม่ให้เข้ามาทำข้อสอบที่นี
//datArr = myDat.split("xyz");   //datArr[0] คือ ซื้อแล้วหรือยัง true=ซื้อแล้ว  datArr[1] คือ โหมดมือหรือไม่  true=ใช่โหมดมืด  false=ไม่ใช่โหมดมืด
//
//is_Bought = datArr[0];
// alert("buy already?" +  is_Bought);

// ปรับโหมด มืด-สว่าง
is_darkMode = datArr[1];

// alert("is_darkMode \n(true = โหมดมืด, false = โหมดสว่าง) :" + is_darkMode);

if (is_darkMode == "true"){
    htmlMode = "dark";
 }else{
         htmlMode = "light";
     }
// alert("htmlMode: "+ htmlMode);


if (htmlMode=="dark"){ // ถ้าอยู่ในโหมด มืด
element.style.backgroundColor = 'black';
element.style.color = 'white';

 // กรอบล้อมรอบ คำถาม
 var tableBorder = document.getElementById("listingTable");
 tableBorder.style.borderColor = "gray";

 // กรอบล้อมรอบ คำตอบ
  var show_Answer = document.getElementById("showAnswer");
  show_Answer.style.borderColor = "gray";

// เส้นคั่น ระหว่าง เศษ และ ส่วน

//var frac_line = document.getElementsByClassName('span.bottom');
//  for (var i = 0; i < frac_line.length; i++) {
//    frac_line[i].style.color = 'white';
//  }
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

//  เปลี่ยนพื้นหลัง modal-content ที่แสดงผลการทำข้อสอบ
var modalContent = document.getElementsByClassName("modal-content")[0];
//  alert("modalContent: " + modalContent);
modalContent.style.backgroundColor = '#808080';

 // change background color of timer wraper
var timerWrapper = document.getElementsByClassName("timer_wrapper");
if (timerWrapper.length >= 1) {
    for (var i = 0; i < timerWrapper.length; i++){
        timerWrapper[i].style.backgroundColor = '#808080';
    };
    // change timer font color from red to white
    var time = document.getElementById("timer");
    time.style.color = '#FFFFFF';
 };
//  เปลี่ยนสีพื้นตาราง ไม่เสถียร เลยไม่เปลี่ยน แก้เป็นสีน้ำตาลใน css แทน ใช้ทั้งสองโหมด
// ไม่เสถียร เพราะ ตอน run ครั้งแรก javascript ทำงานก่อน จึงไม่เจอตาราง ต้องเอา javascript ไปไว้ตอนท้าย เพื่อให้ทั้งหน้า load ให้เสร็จเรียบร้อยเสียก่อน
//// // qstn-div
var qstn_div = document.getElementsByClassName("qstn-div");
//   alert("qstn_div length: " + qstn_div.length);
 if (qstn_div.length >= 1) {
     for (var i = 0; i < qstn_div.length; i++){
  //   alert("qstn_div number: " + i);
         qstn_div[i].style.backgroundColor = '#4f4f4f';
     };
  };



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




//  // change table row background
//  var tableElements = document.getElementsByTagName("table");
//   //    alert("table length: " + tableElements.length);
//  for(var i = 0; i < tableElements.length; i++){
//      var thisTable = tableElements[i];
//      var rows = thisTable.getElementsByTagName("tr") ;
//  //   alert("rows length: " + rows.length);
//  		for (var j=0; j<rows.length; j++) {
//  	//	     alert("what rows: " + j);
//  		rows[j].style.backgroundColor = "#5f5f5f";
//        }
//  	}  // end of for(var i = 0; i < tableElements

}else{  // ถ้าอยู่ในโหมด สว่าง
element.style.backgroundColor = 'white';
element.style.color = 'black';




}
}  //end of  isBuyAndMode(myDat)





// ***********************

function result() {
  var score = 0;
  not_correct.length = 0;
  correct_qstns.length = 0;
  skipped_qstns.length = 0;

	count = 0;

var node_list = document.getElementsByTagName('input');
 var count  = 0;
for (var i = 0; i < node_list.length; i++) {

 // หา node ที่เป็น radio button และที่ถูกเลือกด้วย
 if (node_list[i].type == 'radio' && node_list[i].checked) {
            count++;
        }
    }

var node_quiz = document.getElementsByClassName("quiz");
var this_qstn_score;

var num_of_qstns = node_quiz.length;
for (var i = 0; i < num_of_qstns; i++) {

checkForSkipped("q"+(i+1));

this_qstn_score =parseInt(getSelectedRadioValue("q"+(i+1))) || 0;
score += this_qstn_score;
 }




// จำนวนข้อที่ไม่ได้ทำ
var notChecked = num_of_qstns - count;

if(not_correct.length !== 0)
	{
	/*
	message = "คะแนนของท่าน: " + score + "  คะแนน หรือเท่ากับ  " + parseFloat((score /num_of_qstns)*100).toFixed(2) + " &#37; <br>ข้อที่ทำถูก: " + correct_qstns.toString() + "<br>ข้อที่ทำผิด: " + not_correct.toString();
	*/
	message = "คะแนนของท่าน: " + score + "  คะแนน หรือเท่ากับ  " + parseFloat((score /num_of_qstns)*100).toFixed(2) + " &#37;<br>ข้อที่ทำผิด: " + not_correct.toString();

	}else{
    message = "คะแนนของท่าน: " + score + "  คะแนน หรือเท่ากับ   " + parseFloat((score /num_of_qstns)*100).toFixed(2) + " &#37;"
	};

// ถ้ามีการไม่ทำบางข้อ ให้แสดงข้อมูลใน feedback ด้วย
	if (notChecked > 0)
	{
		message = message + "<br><br>ไม่ได้ทำข้อสอบ จำนวน " + notChecked + " ข้อ ได้แก่ " + skipped_qstns.toString() + "<br><br>ท่านสามารถปิดหน้าจอนี้ เพื่อกลับไปแก้ข้อผิด หรือทำต่อให้ครบ แล้วกดปุ่ม ส่งคำตอบ อีกครั้ง"
	}

// หยุดการจับเวลา
		pauseCountDown();

if (min > 0 && hour == 0)
{
	message = message +"<br><br>ใช้เวลาทำข้อสอบ " + min + " นาที";
}

if (min > 0 && hour > 0)
{
	message = message +"<br><br>ใช้เวลาทำข้อสอบ " + hour + " ช.ม. " + min + " นาที";
}

// แสดง feedback ใน id myMessage ของไฟล์ html ที่เรียกใช้งาน
		document.getElementById("myMessage").innerHTML = message;
		modal.style.display = "block";

//alert (message);

// ป้องกันไม่ให้หน้าจอเลื่อนไปข้างบน
 return false;
}

function checkForSkipped(name){
  var is_skipped=0;

  var radios = document.getElementsByName(name);

 var thisQstn = " ข้อ " + name.substr(1);

    for (var i = 0; i < radios.length; i++) {
			if (radios[i].checked){  //ถ้าไม่มีการเลือกข้อนี้
			is_skipped++; // เก็บข้อมูลข้อที่ข้าม ไม่ได้ทำ
	}	}

   if (is_skipped==0){  //ถ้าไม่มีการเลือกข้อนี้
			skipped_qstns.push(thisQstn); // เก็บข้อมูลข้อที่ข้าม ไม่ได้ทำ
	}
}


function getSelectedRadioValue(name) {
  var radios = document.getElementsByName(name);
  var thisQstn = " ข้อ " + name.substr(1);

  for (var i = 0; i < radios.length; i++) {

    if (radios[i].checked) {
		if(radios[i].value==0){
			// เก็บข้อที่ทำผิดไว้ใน array ชื่อ not_correct เพื่อจะนำไปแสดงใน feedback ด้วย
			not_correct.push(thisQstn);
		}else{
			// เก็บข้อที่ทำถูกไว้ใน array ชื่อ	correct_qstns เพื่อจะนำไปแสดงใน feedback ด้วย
			correct_qstns.push(thisQstn);
		}




      return radios[i].value;
    }

  }
}

/* for sequential numbers */
//
//var current = document.getElementById('default');
//
//  function highlite(el)
//  {
//     if (current != null)
//     {
//         current.className = "";
//     }
//     el.className = "highlite";
//     current = el;
//  }
//


var current_page = 1;
var records_per_page = 1;
var thisJson = [];
var jsonName_id = ""; // สำหรับเก็บชื่อตัวแปร json เพื่อส่งไปยัง Android เพื่อเก็บลงฐานข้อมูล เวลากลับมาอีกครั้ง จะได้รู้ว่า ทำอะไร ไปถึงข้ออะไร

// from: https://stackoverflow.com/questions/2264072/detect-a-finger-swipe-through-javascript-on-the-iphone-and-android
document.addEventListener('swiped', function(e) {
    console.log(e.target); // the element that was swiped
    console.log(e.detail.dir); // swiped direction
});

document.addEventListener('swiped-left', function(e) {
  //  console.log(e.target); // the element that was swiped
//	alert('swiped left!')
	nextPage();
});

document.addEventListener('swiped-right', function(e) {
   // console.log(e.target); // the element that was swiped
	//alert('swiped right!')
	prevPage();
});


var clicks = 0;
var timer, timeout = 350; // time between each click

var doubleClick = function(e) {
  console.log('doubleClick!!');
  goToPage('start', thisJson);
}

var tripleClick = function(e) {
  console.log('tripleClick!!');
  goToPage('end', thisJson);
}

// click timer
document.addEventListener('click', function(e) {
  clearTimeout(timer);
  clicks++;
  var evt = e;
  timer = setTimeout(function() {
    if(clicks==2) doubleClick(evt);
    if(clicks==3) tripleClick(evt);
    clicks = 0;
  }, timeout);
});


//
//document.addEventListener('swiped-up', function(e) {
//		goToPage('end', thisJson);
//});
//
//document.addEventListener('swiped-down', function(e) {
//		goToPage('start', thisJson);
//});
//



//
//var objJsonSimplexx = [
//{number:"111_simple", answer: "111xx"},
//{number:"222", answer: "222xx"},
//{number:"333", answer: "333xx"},
//{number:"444", answer: "xxx"},
//]


//ข้อมูล ย้ายไปไฟล์ data-for-sequential_num_exercise.js
//var sectmented = [
//{ number: "6&#160;&#160;&#160;9&#160;&#160;&#160;15&#160;&#160;&#160;16&#160;&#160;&#160;21&#160;&#160;&#160;37&#160;&#160;&#160;5&#160;&#160;&#160;10&#160;&#160;&#160; ......",  answer: "แบบกั้นห้อง ตัว3 = ตัว1+ตัว2<br>ตอบ  15"},
//{ number: "3&#160;&#160;&#160;6&#160;&#160;&#160;9&#160;&#160;&#160;17&#160;&#160;&#160;30&#160;&#160;&#160;47&#160;&#160;&#160;7&#160;&#160;&#160;11&#160;&#160;&#160; ......",  answer: "แบบกั้นห้อง ตัว3 = ตัว1+ตัว2<br>ตอบ  18"},
//{ number: "13&#160;&#160;&#160;7&#160;&#160;&#160;20&#160;&#160;&#160;19&#160;&#160;&#160;20&#160;&#160;&#160;39&#160;&#160;&#160;2&#160;&#160;&#160;5&#160;&#160;&#160; ......",  answer: "แบบกั้นห้อง ตัว3 = ตัว1+ตัว2<br>ตอบ  7"},
//]
//
//var add_increment_base_const_power = [
//{ number: "10&#160;&#160;&#160;14&#160;&#160;&#160;23&#160;&#160;&#160;39&#160;&#160;&#160;64&#160;&#160;&#160;........ ",  answer: "บวกด้วยเลขยกกำลังคงที่ แต่ฐานเพิ่ม ตัวหน้า+2<sup>2</sup>,  +3<sup>2</sup>,+4<sup>2</sup>, ….  <br>ตอบ:  100 "},
//{ number: "12&#160;&#160;&#160;16&#160;&#160;&#160;25&#160;&#160;&#160;41&#160;&#160;&#160;66&#160;&#160;&#160;........ ",  answer: "บวกด้วยเลขยกกำลังคงที่ แต่ฐานเพิ่ม ตัวหน้า+2<sup>2</sup>,  +3<sup>2</sup>,+4<sup>2</sup>, ….  <br>ตอบ:  102 "},
//
//]
//
//var staticMultiply_incredmentPlus = [
//{ number: "2&#160;&#160;&#160;5&#160;&#160;&#160;12&#160;&#160;&#160;27&#160;&#160;&#160;58&#160;&#160;&#160;.....",  answer: "คูณด้วยค่าคงที่ แล้วบวกด้วย 1,2,3,...  <br>ตอบ:      121"},
//{ number: "7&#160;&#160;&#160;15&#160;&#160;&#160;32&#160;&#160;&#160;67&#160;&#160;&#160;170&#160;&#160;&#160;.....",  answer: "คูณด้วยค่าคงที่ แล้วบวกด้วย 1,2,3,...  <br>ตอบ:      415"},
//{ number: "11&#160;&#160;&#160;23&#160;&#160;&#160;48&#160;&#160;&#160;99&#160;&#160;&#160;226&#160;&#160;&#160;.....",  answer: "คูณด้วยค่าคงที่ แล้วบวกด้วย 1,2,3,...  <br>ตอบ:      511"},
//]
//
//var add_substract_odd_even_increment = [
//{ number: "15&#160;&#160;&#160;11&#160;&#160;&#160;5&#160;&#160;&#160;-3&#160;&#160;&#160;-13&#160;&#160;&#160;........ ",  answer: "บวก-ลบ ด้วยเลขคู่-คี่ เช่น +3,+5+7 ….  <br>ตอบ:  -25"},
//{ number: "2&#160;&#160;&#160;3&#160;&#160;&#160;6&#160;&#160;&#160;11&#160;&#160;&#160;18&#160;&#160;&#160;........ ",  answer: "บวก-ลบ ด้วยเลขคู่-คี่ เช่น +3,+5+7 ….  <br>ตอบ:  27 "},
//{ number: "14&#160;&#160;&#160;19&#160;&#160;&#160;26&#160;&#160;&#160;35&#160;&#160;&#160;46&#160;&#160;&#160;........ ",  answer: "บวก-ลบ ด้วยเลขคู่-คี่ เช่น +3,+5+7 ….  <br>ตอบ:  59 "},
//]
//
//alternate_plus_multiply = [
//{ number: "1&#160;&#160;&#160;2&#160;&#160;&#160;4&#160;&#160;&#160;8&#160;&#160;&#160;10&#160;&#160;&#160;20&#160;&#160;&#160;  .....",  answer: "คูณสลับบวก(x2,+2)<br>ตอบ: 22"},
//{ number: "2&#160;&#160;&#160;6&#160;&#160;&#160;8&#160;&#160;&#160;24&#160;&#160;&#160;26&#160;&#160;&#160;78&#160;&#160;&#160;  .....",  answer: "คูณสลับบวก(x3,+2)<br>ตอบ: 80"},
//{ number: "8&#160;&#160;&#160;10&#160;&#160;&#160;20&#160;&#160;&#160;22&#160;&#160;&#160;44&#160;&#160;&#160;46&#160;&#160;&#160;  .....",  answer: "บวกสลับคูณ (+2, x2)<br>ตอบ: 92"},
//{ number: "9&#160;&#160;&#160;12&#160;&#160;&#160;24&#160;&#160;&#160;27&#160;&#160;&#160;54&#160;&#160;&#160;57&#160;&#160;&#160;.....",  answer: "บวกสลับคูณ (+3, x2)<br>ตอบ: 114"},
//]
//
//var fraction = [
//{ number: "<span class='frac'>4<span class='symbol'>/</span><span class='bottom'>5</span></span>&#160;&#160;&#160;<span class='frac'>9<span class='symbol'>/</span><span class='bottom'>13</span></span>&#160;&#160;&#160;<span class='frac'>22<span class='symbol'>/</span><span class='bottom'>31</span></span>&#160;&#160;&#160;<span class='frac'>53<span class='symbol'>/</span><span class='bottom'>75</span></span>&#160;&#160;&#160; ......",  answer: "เศษพจน์หลัง=เศษพจน์หน้า+ส่วนพจน์หน้า ::: ส่วนพจน์หลัง=เศษพจน์หน้า+เศษตัวเอง<br>ตอบ: &#160;&#160;<span class='frac'>128<span class='symbol'>/</span><span class='bottom'>181</span></span>"},
//{ number: "<span class='frac'>5<span class='symbol'>/</span><span class='bottom'>20</span></span>&#160;&#160;&#160;<span class='frac'>1<span class='symbol'>/</span><span class='bottom'>5</span></span>&#160;&#160;&#160;<span class='frac'>5<span class='symbol'>/</span><span class='bottom'>19</span></span>&#160;&#160;&#160;<span class='frac'>2<span class='symbol'>/</span><span class='bottom'>5</span></span>&#160;&#160;&#160;<span class='frac'>5<span class='symbol'>/</span><span class='bottom'>18</span></span>&#160;&#160;&#160;<span class='frac'>3<span class='symbol'>/</span><span class='bottom'>5</span></span>&#160;&#160;&#160; ......",  answer: "มี สองชุด<br>ตอบ: &#160;&#160;<span class='frac'>5<span class='symbol'>/</span><span class='bottom'>17</span></span>"},
//{ number: "<span class='frac'>3<span class='symbol'>/</span><span class='bottom'>6</span></span>&#160;&#160;&#160;<span class='frac'>2<span class='symbol'>/</span><span class='bottom'>1</span></span>&#160;&#160;&#160;<span class='frac'>3<span class='symbol'>/</span><span class='bottom'>6</span></span>&#160;&#160;&#160;<span class='frac'>2<span class='symbol'>/</span><span class='bottom'>2</span></span>&#160;&#160;&#160;<span class='frac'>3<span class='symbol'>/</span><span class='bottom'>6</span></span>&#160;&#160;&#160;<span class='frac'>2<span class='symbol'>/</span><span class='bottom'>3</span></span>&#160;&#160;&#160; ......",  answer: "มี สองชุด<br>ตอบ: &#160;&#160;<span class='frac'>3<span class='symbol'>/</span><span class='bottom'>6</span></span>"},
//]
//
//var extra = [
//{ number: "7&#160;&#160;&#160;14&#160;&#160;&#160;42&#160;&#160;&#160;168&#160;&#160;&#160;.......",  answer: "เพิ่มอย่างมีระบบ 7x2=14, 14x3=42,42x4=168 <br>ข้อสังเกตคือ เลขเพิ่มแบบกระโดด น่าจะมีคูณ<br>คำตอบคือ:&#160;&#160;840"},
//{ number: "2&#160;&#160;&#160;8&#160;&#160;&#160;21&#160;&#160;&#160;48&#160;&#160;&#160;96&#160;&#160;&#160;.......",  answer: "ตีแฉก 3 ครั้ง เพิ่มครั้งละ 7<br>คำตอบคือ:&#160;&#160;172"},
//{ number: "3&#160;&#160;&#160;6&#160;&#160;&#160;11&#160;&#160;&#160;21&#160;&#160;&#160;39&#160;&#160;&#160;68&#160;&#160;&#160;.......",  answer: "ตีแฉก 3 ครั้ง เพิ่มครั้งละ 3<br>คำตอบคือ:&#160;&#160;111"},
//{ number: "5&#160;&#160;&#160;7&#160;&#160;&#160;11&#160;&#160;&#160;21&#160;&#160;&#160;.......",  answer: "ข้อสังเกต เลขมีไม่มากจำนวน ตีแฉกครั้งเดียว ถ้าไม่ได้ต้องเปลี่ยน<br>ตีแฉกแล้ว ได้ 2, 4, 16 แต่ไม่แน่ใจว่า ตัวต่อไปจะเป็น 8 หรือ 6 ก็ได้ ดูแบบยกกำลังดีกว่า ตัวต่อไปคือ 2 ยกกำลัง 8<br><img src='images/571127.png' style='margin: 10px,10px,10px,10px;'<br><br>คำตอบคือ:&#160;&#160;283"},
// ]
//
//var accumulate = [
//{ number: "3&#160;&#160;&#160;5&#160;&#160;&#160;8&#160;&#160;&#160;13&#160;&#160;&#160;21&#160;&#160;&#160;34&#160;&#160;&#160;.......",  answer: "ตัวที่ 1 + 2 = 3 คำตอบคือ:&#160;&#160;55"},
//{ number: "5&#160;&#160;&#160;2&#160;&#160;&#160;7&#160;&#160;&#160;9&#160;&#160;&#160;16&#160;&#160;&#160;25&#160;&#160;&#160;.......",  answer: "ตัวที่ 1 + 2 = 3 คำตอบคือ:&#160;&#160;41"},
//{ number: "20&#160;&#160;&#160;11&#160;&#160;&#160;10&#160;&#160;&#160;41&#160;&#160;&#160;62&#160;&#160;&#160;113&#160;&#160;&#160;.......",  answer: "ตัวที่ 1+2+3 = 4 คำตอบคือ:&#160;&#160;216"},
//{ number: "18&#160;&#160;&#160;2&#160;&#160;&#160;2&#160;&#160;&#160;22&#160;&#160;&#160;26&#160;&#160;&#160;50&#160;&#160;&#160;.......",  answer: "ตัวที่ 1+2+3 = 4 คำตอบคือ:&#160;&#160;98"},
//]
//
//var old_exam = [
//{ number: "20 พ.ย. 65 รอบเช้า<br>49&#160;&#160;&#160;50&#160;&#160;&#160;55&#160;&#160;&#160;64&#160;&#160;&#160;77&#160;&#160;&#160;.......",  answer: "เพิ่มตลอดแต่ไม่มาก<br>ไม่ใช่แบบสะสม<br>ตีแฉก 2 ชั้น จะเห็นเพิ่มครั้งละ 4<br>คำตอบคือ:&#160;&#160;94"},
//{ number: "E-exam รอบ 4 เม.ย. 64<br>7&#160;&#160;&#160;14&#160;&#160;&#160;42&#160;&#160;&#160;168&#160;&#160;&#160;  ......",  answer: "เพิ่มขึ้นมาก ต้องมีคูณแน่นอน เป็นการคูณเพิ่มอย่างมีระบบ คือ x2, x3, x4, x5<br>ตอบ 840"},
//{ number: "ข้อสอบ ก.พ. 63<br>9&#160;&#160;&#160;  10&#160;&#160;&#160;  12&#160;&#160;&#160;  21&#160;&#160;&#160;  ....... ",  answer: "ยกกำลังเพิ่ม - ฐานเพิ่ม <br><img src='images/nbr_9101221.png' style='margin: 10px,10px,10px,10px;'><br><br>"},
//{ number: "ข้อสอบ ก.พ. 63<br><span class='frac'>3<span class='symbol'>/</span><span class='bottom'>5</span></span>&#160;&#160;&#160;<span class='frac'>9<span class='symbol'>/</span><span class='bottom'>7</span></span>&#160;&#160;&#160;<span class='frac'>11<span class='symbol'>/</span><span class='bottom'>13</span></span>&#160;&#160;&#160;<span class='frac'>17<span class='symbol'>/</span><span class='bottom'>15</span></span> ......",  answer: "สลับเศษส่วน - เศษตัวหน้า +4 เป็นส่วนตัวหลัง และ ส่วนตัวหน้า +4 เป็นเศษตัวหลัง<br><img src='images/nbr_391117.png' style='margin: 10px,10px,10px,10px;'><br><br>"},
//
//]
//var pair_diff = [
//{ number: "100&#160;&#160;&#160;98&#160;&#160;&#160;93&#160;&#160;&#160;83&#160;&#160;&#160;66&#160;&#160;&#160;  .....",  answer: "ตีแฉกหาความต่างระหว่างคู่ <br>ตอบ   40"},
//{ number: "123&#160;&#160;&#160;121&#160;&#160;&#160;118&#160;&#160;&#160;113&#160;&#160;&#160;105&#160;&#160;&#160;  .....",  answer: "ตีแฉกหาความต่างระหว่างคู่ <br>ตอบ   93"},
//{ number: "33&#160;&#160;&#160;43&#160;&#160;&#160;54&#160;&#160;&#160;69&#160;&#160;&#160;91&#160;&#160;&#160;123&#160;&#160;&#160;  .....",  answer: "ตีแฉกหาความต่างระหว่างคู่ <br>ตอบ    168"},
//{ number: "1&#160;&#160;&#160;11&#160;&#160;&#160;22&#160;&#160;&#160;35&#160;&#160;&#160;51&#160;&#160;&#160;71&#160;&#160;&#160;  .....",  answer: "ตีแฉกหาความต่างระหว่างคู่ <br>ตอบ    96"},
//{ number: "2&#160;&#160;&#160;12&#160;&#160;&#160;23&#160;&#160;&#160;36&#160;&#160;&#160;52&#160;&#160;&#160;72&#160;&#160;&#160;  .....",  answer: "ตีแฉกหาความต่างระหว่างคู่ <br>ตอบ   97"},
//]
//
////var fraction[
////{ number: "
////&lt;span class=&quote;frac&quote;&gt;4&lt;span class=&quote;symbol&quote;&gt;/&lt;/span>&lt;span class=&quote;bottom&quote;&gt;5&lt;/span&gt;&lt;/span&gt; &#160;&#160;&#160; .....",  answer: "เศษตัว2=เศษหน้า+ส่วนหน้า, ส่วนตัว2=เศษหน้า+เศษตัวเอง<br>ตอบ: &lt;span class='frac'>128&lt;span class='symbol'>/&lt;/span>&lt;span class='bottom'>181&lt;/span>&lt;/span>&#160;&#160;&#160;
////
////]
//
//var objJsonSimple = [
//{ number: "2&#160;&#160;&#160;7&#160;&#160;&#160;12&#160;&#160;&#160;17&#160;&#160;&#160;22&#160;&#160;&#160;.....",  answer: "เพิ่ม-ลด เท่ากัน <br>ตอบ    27"},
//{ number: "3&#160;&#160;&#160;6&#160;&#160;&#160;9&#160;&#160;&#160;12&#160;&#160;&#160;15&#160;&#160;&#160;.....",  answer: "เพิ่ม-ลด เท่ากัน <br>ตอบ    18"},
//{ number: "3&#160;&#160;&#160;6&#160;&#160;&#160;9&#160;&#160;&#160;12&#160;&#160;&#160;15&#160;&#160;&#160;.....",  answer: "เพิ่ม-ลด เท่ากัน <br>ตอบ    18"},
//{ number: "22&#160;&#160;&#160;19&#160;&#160;&#160;16&#160;&#160;&#160;13&#160;&#160;&#160;10&#160;&#160;&#160;.....",  answer: "เพิ่ม-ลด เท่ากัน <br>ตอบ    7"},
//]; // Can be obtained from another source, such as your objJson variable

function prevPage()
{
var showIt = document.getElementById("showAnswer");
showIt.style.display = 'none';
//var showMsg = document.getElementById("myMessage");
//showMsg.style.display = 'none';
resetCountDown();
// // document.getElementById('myInput').value = '';
// countDown(0,00,05)
    if (current_page > 1) {
        current_page--;
        changePage(current_page, true,thisJson);
    }
    doFraction(); // จัดการเส้นคั่น เศษส่วน
}

function nextPage()
{
var showIt = document.getElementById("showAnswer");
showIt.style.display = 'none';
//var showMsg = document.getElementById("myMessage");
//showMsg.style.display = 'none';
// countDown(0,00,05)
resetCountDown();
// // document.getElementById('myInput').value = '';
    if (current_page < numPages()) {
        current_page++;
        changePage(current_page, true, thisJson);
    }
    doFraction(); // จัดการเส้นคั่น เศษส่วน
}


function addBkg(what_element){
what_element.classList.add('curr'); // Add class
var thisMenu = document.getElementsByClassName("myMenu");
for (var i = 0; i < thisMenu.length; i++) {
	//alert(thisMenu.item(i).textContent);
	if(what_element.textContent !== thisMenu.item(i).textContent){
		thisMenu.item(i).classList.remove('curr');
	}
  }
/*
if(htmlMode !=="dark"){

var myMenuBkg = document.getElementsByClassName('curr'); // get all elements

console.log("test myMenuBkg not dark : " + myMenuBkg.length);

	for(var i = 0; i < myMenuBkg.length; i++){
	console.log("test myMenuBkg: " + myMenuBkg.length);
		myMenuBkg[i].style.backgroundColor = "#BEC3C6";
	}
}
*/
} // end of addBkg()




function showItAns()
{
// alert("welcome to showItAns()");
console.log("qqq before pauseCountDown()");
	pauseCountDown();
	console.log("qqq after pauseCountDown()");
    var showIt = document.getElementById("showAnswer");
//	showIt.innerHTML =  "คำตอบคือ: " + thisJson[current_page-1].answer + "<br>";
	showIt.innerHTML = thisJson[current_page-1].answer + "<br>";
	showIt.style.display = 'block';
	  doFraction(); // สำหรับเส้นคั่นระหว่างเศษส่วน

	  console.log("เรื่อง: " + jsonName_id + "\nหน้าปัจจุบัน: " + current_page + "\nจำนวนข้อทั้งหมด: " + numPages());

      var name = jsonName_id;
      var currQstnNum = current_page;
      console.log("currQstnNum or current_page: " + currQstnNum);
      var totalNum = numPages();
      var exerciseMsg = name+"xzc"+currQstnNum+"xzc"+totalNum;

      // numOfQuestions = totalNum
      // currQstnID = "tbl_q" + currQstnNum;

      console.log("exerciseMsg from full_exam_sequencial_num to Flutter: " + exerciseMsg);
      // ส่งข้อมูลไป Android  ว่าทำเรื่องอะไร ข้อสุดท้ายที่ทำคือข้ออะไร และ เรื่องนี้มีทั้งหมดกี่ข้อ เพื่อเก็บลงฐานข้อมูล

      window.flutter_inappwebview.callHandler('exerciseData', ...exerciseMsg);

      console.log("ข้อสุดท้าย: " + lastQstnArr);
      // หาตำแหน่งของชื่อเมนูนี้ ใน ตัวแปร ที่เก็บข้อสุดท้าย เพื่อจะได้ปรับข้อมูลใหม่ให้เป็นปัจจุบัน เมื่อคลิกปุ่มตรวจ
     // var thisPos =  .findIndex(element => element.includes(name));




}
//
//// รับข้อมูลมาจาก flutter
//function getLastQstnNum(myLastQNum){
//console.log("myLastQNum from Flutter: " + myLastQNum);
// //   let thisLNumber = myLastQNum;
//  //  console.log("thisNumber from Flutter: " + thisLNumber);
//
//    //    console.log("345 Return is_IsNewClicked - result.newString: ", result.menuName);
//
//        var incoming = myLastQNum;
//        console.log("incoming myLastQNum from Flutter: " + incoming);
//      //  var incoming = result.menuName;
//
//            lastQstnArr = incoming.split(" "); // แยกออกจากกัน โดยใช้ช่องว่าง เป็นเกณฑ์
//           console.log("lastQstnArr from sharePref: " + lastQstnArr);
//           console.log("lastQstnArr[2]: " + lastQstnArr[2]);
//
//
//          // เอาเฉพาะตัวเลขมารวมกัน เพื่อเอาไปคิดเปอร์เซ็นต์ ว่า ทำไปเท่าไรแล้ว
//
//          //แยก แล้วเอาเฉพาะตัวเลข(อยู่ในรูป String)  ที่อยู่หลัง xyz
//          var numbers = lastQstnArr.map(function(n){
//             return n.split("xyz")[1];
//          })
//
//        // เปลี่ยน string เป็นตัวเลข จะได้เอาไปบวกกันได้
//        numbers = numbers.map(Number);
//        let thisNumFromMap = numbers;
//        console.log("zz numbers from map: " + thisNumFromMap);
//          // รวมทั้งหมดเข้าด้วยกัน
//          var thisSum = numbers.reduce(add, 0); // with initial value to avoid when the array is empty
//
//        function add(accumulator, a) {
//            return accumulator + a;
//          }
//
//        console.log("zz thisSum: " + thisSum);
//
//
//        // เลขข้อสุดท้าย ยัง undefined อยู่
//        	if(thisSum <= 5){  // เพราะว่า ตอนแรก ยังไม่ได้ทำ เข้ามาใหม่ ๆ กำหนดให้เป็น ข้อ 1 ใน sharePref มี 4 เมนู
//        	 alreadyDone = 0;
//        	}else{
//        	alreadyDone = thisSum;
//        	}
//
//            currQstnID = "tbl_q" + alreadyDone;
//
//         console.log("zz currQstnID: " + currQstnID);
//
//        var args = numOfQuestions + "xzc" + currQstnID + clickedQstns;
//
// //       var msgToSend = numOfQuestions + "xzc" + currQstnID + clickedQstns;
////
////         messageHandler.postMessage(msgToSend);  // ***************************** ย้ายมาจาก 119
////
//
//console.log("zz messege to Flutter via messageHandler: " + args);
//
//// ส่งข้อมูลไป Flutter
//window.flutter_inappwebview.callHandler('messageHandler', ...args)
//.then(function (result) {
//// รับค่าที่ส่งเข่ามา
//    console.log("isBuyAndMode จาก Flutter to JS via messageHandler: " + result.Message);
//    isBuyAndMode(result.Message);
//});
//
//}


function changeData(myJason){
var thisNumDat = 1;
var thisNumber;
var thisLNumberArr;
	/*
	const current = 0;
for (var i = 0; i < document.links.length; i++) {
    if (document.links[i].href === document.URL) {
        current = i;
    }
}
*/
// highlite(this);
//document.links[current].className = 'current';

// alert("bought already???? " + is_Bought);
//alert("myJason: " + myJason);

// ปัญหาคือ ตัวแปร lastQstnArr มาไม่ทัน บางทีมี บางทีไม่มี
// alert("aabbcc lastQstnArr: " + lastQstnArr);

swipeEnabled = true;  // Set this to true to enable, false to disable


switch (myJason) {

case "intro_page":

swipeEnabled = false;  // Set this to true to enable, false to disable

	resetCountDown();

	document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่ ถ้ามาจากหน้าที่มีเฉลย
    // ไฟล์ html อธิบายวิธีทำ ทั้งไฟล์เอามาใส่ในตัวแปรเลยตรง ๆ ถ้าจะแก้ ให้คัดลอก ไปแก้ใน editPlus เอา \n เพิ่มต่อจาก <br> เพื่อให้ขึ้นบรรทัดใหม่ และเวลาจะเอามาไว้ที่นี่ ให้ตัด \n ออกก่อน

thisJson ="<!DOCTYPE html><html lang='th'> <head>    <meta charset='UTF-8'>    <meta name='viewport' content='width=device-width, initial-scale=1'>     <link rel='stylesheet' type='text/css' href='my_style.css'> <title>intro_page</title> </head>  <body> <h3>เทคนิคการทำข้อสอบอนุกรม</h3><div  style='display: inline-block; text-align: left; padding-left: 3px; padding-right: 10px'><ul>   <li>ข้อสอบอนุกรมของก.พ. เป็นข้อสอบที่วัดความความถนัดด้านตัวเลข อนุกรม เป็นเรื่องที่เกี่ยวกับการเพิ่มขึ้นและลดลงของตัวเลข ในรูปแบบต่าง ๆ การฝึกทำข้อสอบมาก ๆ จะทำให้คุ้นเคยกับรูปแบบของอนุกรม และสามารถทำได้อย่างรวดเร็ว</li>      <li>เวลาเป็นเรื่องสำคัญ โจทย์อนุกรมของ ก.พ. จะมีทั้งข้อยาก และข้อง่าย ในการทำข้อสอบจริง ถ้าดูแล้วยังจับรูปแบบไม่ได้ ควรข้ามไปทำข้ออื่นก่อน จะได้ไม่เสียเวลา เมื่อทำข้อสอบข้ออื่น ๆ ที่มั่นใจเสร็จแล้ว จึงค่อยกลับมาคิดอีกที</li>   </ul>   </div> </body></html>";
    show_intro_page(1, false, thisJson);  // แสดงหน้าคำอธิบาย
    break;

case "fraction":
console.log("lastQstnArr inside case=fraction: " + lastQstnArr)
    jsonName_id = "exMenu_fraction";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล

    // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()

    thisNumDat = lastQstnArr.find(element => element.includes("fraction"));
    console.log("thisNumDat for เศษส่วน in changeData: " + thisNumDat);  // normal_cndtngxyz1
    thisLNumberArr = thisNumDat.split(":xyz:");
    thisNumber = thisNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

    // document.getElementById('myInput').value = '';  // ลบที่พิมพ์คำตอบก่อนหน้านี้ ในช่อง input
	document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่
  // shuffle(fraction);  // เอา list ข้อมูล มาสลับเสียใหม่ ไม่ให้เรียงลำดับ
   thisJson =  fraction;  // เอาไปใช้ สำหรับให้ฝึก
	//current_page = 1;  // เริ่มที่หน้า 1
    changePage(thisNumber, false, thisJson);  // ส่งข้อมูลไปแสดง หน้า, ยังไม่เริ่มจับเวลา(เพราะเพิ่งเข้ามา), ไฟล์ข้อมูลที่เลือก
//   alert("htmlMode: " + htmlMode); // dark, light
    doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;
case "add_substract_equally":
    jsonName_id = "exMenu_add_substract_equally";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล

    // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
    thisNumDat = lastQstnArr.find(element => element.includes("add_substract_equally"));
    console.log("thisNumDat for add_substract_equally in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    thisNumberArr = thisNumDat.split("xyz");
    thisNumber = thisNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย


    // document.getElementById('myInput').value = '';  // ลบที่พิมพ์คำตอบก่อนหน้านี้ ในช่อง input
	document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่
  // shuffle(objJsonSimple);  // เอา list ข้อมูล มาสลับเสียใหม่ ไม่ให้เรียงลำดับ
   thisJson =  objJsonSimple;  // เอาไปใช้ สำหรับให้ฝึก
	//current_page = 1;  // เริ่มที่หน้า 1
    changePage(thisNumber, false, thisJson);  // ส่งข้อมูลไปแสดง หน้า, ยังไม่เริ่มจับเวลา(เพราะเพิ่งเข้ามา), ไฟล์ข้อมูลที่เลือก
    doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;
case  "accumulate":
   jsonName_id = "exMenu_accumulate";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล

    // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
    thisNumDat = lastQstnArr.find(element => element.includes("accumulate"));
    console.log("thisNumDat for accumulate in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    thisNumberArr = thisNumDat.split("xyz");
    thisNumber = thisNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

  	// clear input field
    // document.getElementById('myInput').value = '';
	document.getElementById('showAnswer').style.display ='none';
 //  shuffle(accumulate);
    thisJson = accumulate;
    changePage(thisNumber, false, thisJson);
    doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;

		case  "alternate_plus_multiply":
		  jsonName_id = "exMenu_alternate_plus_multiply";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล

    // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
    thisNumDat = lastQstnArr.find(element => element.includes("alternate_plus_multiply"));
    console.log("thisNumDat for alternate_plus_multiply in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    thisNumberArr = thisNumDat.split("xyz");
    thisNumber = thisNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

  	// clear input field
    // document.getElementById('myInput').value = '';
	document.getElementById('showAnswer').style.display ='none';
 //  shuffle(alternate_plus_multiply);
    thisJson = alternate_plus_multiply;
    changePage(thisNumber, false, thisJson)
    doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;

case "add_increment_base_const_power":
   jsonName_id = "exMenu_add_increment_base_const_power";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล

     // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
       thisNumDat = lastQstnArr.find(element => element.includes("add_increment_base_const_power"));
       console.log("thisNumDat for add_increment_base_const_power in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    thisNumberArr = thisNumDat.split("xyz");
    thisNumber = thisNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย


  	// clear input field
    // document.getElementById('myInput').value = '';
document.getElementById('showAnswer').style.display ='none';
// shuffle(add_increment_base_const_power);
    thisJson = add_increment_base_const_power;
    changePage(thisNumber, false, thisJson);
    doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;
case  "add_substract_odd_even_increment":
   jsonName_id = "exMenu_add_substract_odd_even_increment";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล

        // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
          var thisNumDat = lastQstnArr.find(element => element.includes("add_substract_odd_even_increment"));
          console.log("thisNumDat for add_substract_odd_even_increment in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    thisNumberArr = thisNumDat.split("xyz");
    thisNumber = thisNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

  	// clear input field
    // document.getElementById('myInput').value = '';
	document.getElementById('showAnswer').style.display ='none';
	// shuffle(add_substract_odd_even_increment);
     thisJson = add_substract_odd_even_increment;
    changePage(thisNumber, false, thisJson);
    doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;
case  "staticMultiply_incredmentPlus":
   jsonName_id = "exMenu_staticMultiply_incredmentPlus";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล

          // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
             thisNumDat = lastQstnArr.find(element => element.includes("staticMultiply_incredmentPlus"));
             console.log("thisNumDat for staticMultiply_incredmentPlus in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    thisNumberArr = thisNumDat.split("xyz");
    thisNumber = thisNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย


  	// clear input field
    // document.getElementById('myInput').value = '';
	document.getElementById('showAnswer').style.display ='none';
  // shuffle(staticMultiply_incredmentPlus);
    thisJson = staticMultiply_incredmentPlus;
   current_page = 1;
    changePage(thisNumber, false, thisJson);
    doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;
case  "sectmented":
   jsonName_id = "exMenu_sectmented";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล

            // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
                thisNumDat = lastQstnArr.find(element => element.includes("sectmented"));
                console.log("thisNumDat for sectmented in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    thisNumberArr = thisNumDat.split("xyz");
    thisNumber = thisNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย


  	// clear input field
    // document.getElementById('myInput').value = '';
	document.getElementById('showAnswer').style.display ='none';
	// shuffle(sectmented);
    thisJson = sectmented;
    changePage(thisNumber, false, thisJson);
    doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;
case  "pair_diff":
   jsonName_id = "exMenu_pair_diff";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล

   // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
   thisNumDat = lastQstnArr.find(element => element.includes("pair_diff"));
   console.log("thisNumDat for pair_diff in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    thisNumberArr = thisNumDat.split("xyz");
    thisNumber = thisNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

  	// clear input field
    // document.getElementById('myInput').value = '';
	document.getElementById('showAnswer').style.display ='none';
//	shuffle(pair_diff);
    thisJson = pair_diff;
    changePage(thisNumber, false, thisJson);
    doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;
case "mixed":
   jsonName_id = "exMenu_mixed";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล

     // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
      thisNumDat = lastQstnArr.find(element => element.includes("mixed"));
      console.log("thisNumDat for mixed in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    thisNumberArr = thisNumDat.split("xyz");
    thisNumber = thisNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

    // document.getElementById('myInput').value = '';  // ลบที่พิมพ์คำตอบก่อนหน้านี้ ในช่อง input
	document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่
const mixedArr = objJsonSimple.concat(accumulate, add_increment_base_const_power, add_substract_odd_even_increment, staticMultiply_incredmentPlus, sectmented, pair_diff, fraction, old_exam, extra);
	console.log("mixed - is_Bought: " + is_Bought);
//	if(is_Bought == true){
//	    shuffle(mixedArr); // เอา list ข้อมูล มาสลับเสียใหม่ ไม่ให้เรียงลำดับ -- เฉพาะที่ซื้อแล้ว
//	}


    thisJson =  mixedArr;  // เอาไปใช้ สำหรับให้ฝึก
	current_page = 1;  // เริ่มที่หน้า 1
    changePage(thisNumber, false, thisJson);  // ส่งข้อมูลไปแสดง หน้า, ยังไม่เริ่มจับเวลา(เพราะเพิ่งเข้ามา), ไฟล์ข้อมูลที่เลือก
    doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;
case  "old_exam":
   jsonName_id = "old_exam";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล

        // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
         thisNumDat = lastQstnArr.find(element => element.includes("old_exam"));
         console.log("thisNumDat for old_exam in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    thisNumberArr = thisNumDat.split("xyz");
    thisNumber = thisNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

  	// clear input field
  //  // document.getElementById('myInput').value = '';
	document.getElementById('showAnswer').style.display ='none';
//	shuffle(old_exam);
    thisJson = old_exam;
    changePage(thisNumber, false, thisJson);
    doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;
default:
  	// clear input field
//    // document.getElementById('myInput').value = '';
	document.getElementById('showAnswer').style.display ='none';
	shuffle(objJsonSimple);
    thisJson =  objJsonSimple;
	current_page = 1;
    changePage(1, false, thisJson);
}
}

function changePage(page, isStartTiming, myJason)
{
    var btn_next = document.getElementById("btn_next");
    var btn_prev = document.getElementById("btn_prev");
	var btn_first = document.getElementById("go_first");
	var btn_last = document.getElementById("go_last");
    var listing_table = document.getElementById("listingTable");
    var page_span = document.getElementById("page");
    var ans_btn = document.getElementById('showAnswer_btn');

//    alert("xxx buy already? " +  is_Bought + " page: " + page);

    swipeEnabled = true;  // Set this to true to enable, false to disable
 //   alert("swipeEnabled: " + swipeEnabled);
    ans_btn.disabled = false;


// เวลาจะใช้จริง ให้กำหนดเป็น 6 ก็พอ
 //if((is_Bought == "false") && (page >=200)){
 if((is_Bought == "false") && (page >=8)){
 // alert("xxxx");
  // const ans_btn = document.getElementById('showAnswer_btn');
  ans_btn.disabled = true;
  var msgForNon = document.getElementById('msgForNon-buyers');
  msgForNon.style.display = 'block';

  }



if (isStartTiming == true)
{
countDown(0,02,0)
}
    // Validate page
if (page < 1) page = 1;
    if (page > numPages()) page = numPages();

    listing_table.innerHTML = "";

//    for (i = (page-1) * records_per_page; i < (page * records_per_page) && i < objJson.length; i++) {
//        listing_table.innerHTML += objJson[i].number  + "<br>";
//    }

	    for (i = (page-1) * records_per_page; i < (page * records_per_page) && i < thisJson.length; i++) {
        listing_table.innerHTML += thisJson[i].number  + "<br>";
    }
    page_span.innerHTML = page + "/" + numPages();

    if (page == 1) {
        btn_prev.disabled = true;
		btn_first.disabled = true;
    } else {
        btn_prev.disabled = false;
		btn_first.disabled = false;
    }

    if (page == numPages()) {
        btn_next.disabled = true;
		btn_last.disabled = true;
    } else {
        btn_next.disabled = false;
		btn_last.disabled = false;
    }
}

function numPages()
{
//    return Math.ceil(objJson.length / records_per_page);
	  return Math.ceil(thisJson.length / records_per_page);
}


function show_intro_page(page, isStartTiming, myJason)
{

swipeEnabled = false;  // Set this to true to enable, false to disable

    var btn_next = document.getElementById("btn_next");
	btn_next.disabled = true;
    var btn_prev = document.getElementById("btn_prev");
	btn_prev.disabled = true;
	var btn_first = document.getElementById("go_first");
	btn_first.disabled = true;
	var btn_last = document.getElementById("go_last");
	btn_last.disabled = true;
	pauseCountDown();

	var btn_showAns = document.getElementById("showAnswer_btn");
	btn_showAns.disabled = true;

//	var itemNum = document.getElementById("item_num");
//			itemNum.style.display= 'none';

//	var item_number = document.getElementById("item_num");
 //      item_number.disabled = true;


    var listing_table = document.getElementById("listingTable");
    var page_span = document.getElementById("page");
//    alert("xxx buy already? " +  is_Bought + " page: " + page);


 listing_table.innerHTML = myJason;

 page_span.innerHTML = "1/1";
// page_span.style.display = 'none';

//// เวลาจะใช้จริง ให้กำหนดเป็น 6 ก็พอ
// //if((is_Bought == "false") && (page >=200)){
// if((is_Bought == "false") && (page >=8)){
// // alert("xxxx");
//  const ans_btn = document.getElementById('showAnswer_btn');
//  ans_btn.disabled = true;
//
//  }

}  // end of function show_intro_page


function goToPage(whatPage){  //สำหรับ ไปหน้าแรก หน้าสุดท้าย หรือหน้าที่ระบุ
var pos;

//    // document.getElementById('myInput').value = '';  // ลบที่พิมพ์คำตอบก่อนหน้านี้ ในช่อง input
   document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่
  // thisJson =  good_govt;  // เอาไปใช้ สำหรับให้ฝึก
   if(whatPage == "start"){
   pos = 1;
   current_page = 1;
   }else if(whatPage == "end"){
   pos = thisJson.length;
   current_page = pos;
   }else if(whatPage == "specify"){
    var goPageNum = document.getElementById("itemToGo").value;
         if((goPageNum > thisJson.length-1)||(goPageNum < 1)){
            alert("ไม่พบเลขข้อที่ท่านระบุ");
    		return;
         }else{
            pos = goPageNum;
            current_page = pos;
            }
       }
  // alert("go Page: " + pos);
	//current_page = 1;  // เริ่มที่หน้า 1
    changePage(pos, false, thisJson);  // ส่งข้อมูลไปแสดง หน้า, ยังไม่เริ่มจับเวลา(เพราะเพิ่งเข้ามา), ไฟล์ข้อมูลที่เลือก
//    break;
     doFraction(); // จัดการเส้นคั่นเศษส่วน
}




/*for timer 
var myVar = 0;*/
//var hour,min,sec;
var isPause=false;
var css_start = "display = inline; position: relative; top: 1px; font-size: 20px; font-weight: bold; min-width: 70px; min-height: 10px;";
var pause_btn = "display = inline; position: relative; top: 1px; font-size: 20px; font-weight: bold; color: red; min-width: 70px; min-height: 10px;";
var css_btns = "display = inline; position: relative; top: 1px; font-size: 20px; font-weight: bold; min-width: 70px; min-height: 10px;";
var css_disp_none = "display:none; position: relative; top: 1px; font-size: 20px; font-weight: bold; min-width: 70px; min-height: 10px;";
var css_row = "position: relative; top: 1px;";


function countDown(h,m,s){

document.getElementById("start").style.cssText = css_disp_none;
document.getElementById("pause").style.cssText = pause_btn;
document.getElementById("reset").style.cssText = css_btns;
// document.getElementById("row").style.cssText = css_row;

if (isPause==false)
{
	hour = 0;
	min=0;
	sec=1;
}

if (hour >= h && min >= m && sec >=0)
{
	hour = 0;
	min=0;
	sec=1;
}

myVar = setInterval(function(){

       document.getElementById("timer").innerHTML = hour +" : " + min +" : " + sec ;
       sec++;
		if(hour == h && min == m && sec == (s+1)){
			document.getElementById("start").style.cssText = css_start;
			document.getElementById("pause").style.cssText = css_disp_none;
			document.getElementById("reset").style.cssText = css_btns;
		//	document.getElementById("row").style.cssText = css_row;

			message = "<strong><font color=\"red\">หมดเวลา </font></strong><br>";
			// แสดง feedback ใน id myMessage ของไฟล์ html ที่เรียกใช้งาน
			document.getElementById("myMessage").innerHTML = message;
			modal.style.display = "block";


			// alert("time's up");

			clearInterval(myVar);
			return;
		}

       if(sec == 60)
       {
         min++;
         //sec = 60;
		 sec = 0;
         if (min == 60)
         {
			 hour++;
			 //min = 60;
			 min = 0;
			 if (hour == h)
			 {
				 hour = h;
				
			 }
            
         }
       }
      },1000);
    }

function shuffle(array) {
  let currentIndex = array.length,  randomIndex;
  // While there remain elements to shuffle.
  while (currentIndex != 0) {
    // Pick a remaining element.
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex--;
    // And swap it with the current element.
    [array[currentIndex], array[randomIndex]] = [
      array[randomIndex], array[currentIndex]];
  }
  return array;
}

function doFraction(){   // สำหรับ เส้นขีดคั่นระหว่าง เศษและส่วน
 // alert ("htmlMode: " + htmlMode);

let bottomElement = document.querySelectorAll('.frac span.bottom');
// alert ("bottomElement.length " + bottomElement.length);


if(htmlMode=='dark'){
if (bottomElement.length >= 1) {
for (var i = 0; i < bottomElement.length; i++){
        bottomElement[i].style.borderTop = '1px solid white';
    };
};  // end of if (bottomElement.length >= 1)

}else{
if (bottomElement.length >= 1) {
for (var i = 0; i < bottomElement.length; i++){
        bottomElement[i].style.borderTop = '1px solid black';
    };
};  // end of if (bottomElement.length >= 1)
}
} // end of doFraction()


	function resetCountDown(){

		document.getElementById("start").style.cssText = css_start;
		document.getElementById("pause").style.cssText = css_disp_none;
		document.getElementById("reset").style.cssText = css_btns;
		/* document.getElementById("row").style.cssText = css_row; */

		isPause=false;
		clearInterval(myVar);
		hour=0;
		min=0;
		sec=0;
		document.getElementById("timer").innerHTML = hour +" : " + min +" : " + sec ;
		return false;
}

	function pauseCountDown(){

		document.getElementById("start").style.cssText = css_start;
		document.getElementById("pause").style.cssText = css_disp_none;
		document.getElementById("reset").style.cssText = css_btns;
	//	document.getElementById("row").style.cssText = css_row;

		isPause=true;
		clearInterval(myVar);
		return false;
}


/*!
 * swiped-events.js - v@version@
 * Pure JavaScript swipe events
 * https://github.com/john-doherty/swiped-events
 * @inspiration https://stackoverflow.com/questions/16348031/disable-scrolling-when-touch-moving-certain-element
 * @author John Doherty <www.johndoherty.info>
 * @license MIT
 */
(function (window, document) {

    'use strict';

    // patch CustomEvent to allow constructor creation (IE/Chrome)
    if (typeof window.CustomEvent !== 'function') {

        window.CustomEvent = function (event, params) {

            params = params || { bubbles: false, cancelable: false, detail: undefined };

            var evt = document.createEvent('CustomEvent');
            evt.initCustomEvent(event, params.bubbles, params.cancelable, params.detail);
            return evt;
        };

        window.CustomEvent.prototype = window.Event.prototype;
    }

    document.addEventListener('touchstart', handleTouchStart, false);
    document.addEventListener('touchmove', handleTouchMove, false);
    document.addEventListener('touchend', handleTouchEnd, false);

    var xDown = null;
    var yDown = null;
    var xDiff = null;
    var yDiff = null;
    var timeDown = null;
    var startEl = null;

    /**
     * Fires swiped event if swipe detected on touchend
     * @param {object} e - browser event object
     * @returns {void}
     */
    function handleTouchEnd(e) {

        // if the user released on a different target, cancel!
        if (startEl !== e.target) return;

        var swipeThreshold = parseInt(getNearestAttribute(startEl, 'data-swipe-threshold', '20'), 10); // default 20px
        var swipeTimeout = parseInt(getNearestAttribute(startEl, 'data-swipe-timeout', '500'), 10);    // default 500ms
        var timeDiff = Date.now() - timeDown;
        var eventType = '';
        var changedTouches = e.changedTouches || e.touches || [];

        if (Math.abs(xDiff) > Math.abs(yDiff)) { // most significant
            if (Math.abs(xDiff) > swipeThreshold && timeDiff < swipeTimeout) {
                if (xDiff > 0) {
                    eventType = 'swiped-left';
                }
                else {
                    eventType = 'swiped-right';
                }
            }
        }
        else if (Math.abs(yDiff) > swipeThreshold && timeDiff < swipeTimeout) {
            if (yDiff > 0) {
                eventType = 'swiped-up';
            }
            else {
                eventType = 'swiped-down';
            }
        }

        if (eventType !== '') {

            var eventData = {
                dir: eventType.replace(/swiped-/, ''),
                touchType: (changedTouches[0] || {}).touchType || 'direct',
                xStart: parseInt(xDown, 10),
                xEnd: parseInt((changedTouches[0] || {}).clientX || -1, 10),
                yStart: parseInt(yDown, 10),
                yEnd: parseInt((changedTouches[0] || {}).clientY || -1, 10)
            };

            // fire `swiped` event event on the element that started the swipe
            startEl.dispatchEvent(new CustomEvent('swiped', { bubbles: true, cancelable: true, detail: eventData }));

            // fire `swiped-dir` event on the element that started the swipe
            startEl.dispatchEvent(new CustomEvent(eventType, { bubbles: true, cancelable: true, detail: eventData }));
        }

        // reset values
        xDown = null;
        yDown = null;
        timeDown = null;
    }

    /**
     * Records current location on touchstart event
     * @param {object} e - browser event object
     * @returns {void}
     */
    function handleTouchStart(e) {

console.log("swipeEnabled in handleTouchStart " + swipeEnabled);
console.log("e.target.getAttribute in handleTouchStart " + e.target.getAttribute('data-swipe-ignore'));
        // If swipe is disabled, do nothing
        if (!swipeEnabled || e.target.getAttribute('data-swipe-ignore') === 'true') return;


        // if the element has data-swipe-ignore="true" we stop listening for swipe events
       // if (e.target.getAttribute('data-swipe-ignore') === 'true') return;

        startEl = e.target;

        timeDown = Date.now();
        xDown = e.touches[0].clientX;
        yDown = e.touches[0].clientY;
        xDiff = 0;
        yDiff = 0;

     //   doFraction(); // จัดการเส้นคั่น เศษส่วน
    }

    /**
     * Records location diff in px on touchmove event
     * @param {object} e - browser event object
     * @returns {void}
     */
    function handleTouchMove(e) {

        if (!xDown || !yDown) return;

        var xUp = e.touches[0].clientX;
        var yUp = e.touches[0].clientY;

        xDiff = xDown - xUp;
        yDiff = yDown - yUp;
    }

    /**
     * Gets attribute off HTML element or nearest parent
     * @param {object} el - HTML element to retrieve attribute from
     * @param {string} attributeName - name of the attribute
     * @param {any} defaultValue - default value to return if no match found
     * @returns {any} attribute value or defaultValue
     */
    function getNearestAttribute(el, attributeName, defaultValue) {

        // walk up the dom tree looking for attributeName
        while (el && el !== document.documentElement) {

            var attributeValue = el.getAttribute(attributeName);

            if (attributeValue) {
                return attributeValue;
            }

            el = el.parentNode;
        }

        return defaultValue;
    }

}(window, document));

