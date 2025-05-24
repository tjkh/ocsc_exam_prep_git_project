//var isPremiumVersion = "false";    // ถ้าใช้บน PC เพราะเรียกจาก Android  ไม่ได้ ค่าที่ส่งเข้ามา คือ  true  หรือ  false
 //var isPremiumVersion = Android.getIsFullVersion(); // เรียก method จาก android class ชื่อ JavaScriptInterface    ค่าที่ส่งเข้ามา คือ  true  หรือ  false

// วันนี้เรียนรู้อีกอย่าง เรื่องการรับส่งข้อมูลระหว่าง flutter - javascript
// ประเด็นคือ ต้องอยู่ใน JavascriptChannel เดียวกัน เช่น ไฟล์นี้ full_exam.js
// ส่งข้อมูลไปทาง MessageHandler ก็ต้องสร้างฟังก์ชัน isBuyAndMode เพื่อรับข้อมูล
// จะไปสร้าง is_IsNewClicked เพื่อรับข้อมูลไม่ได้ เพราะอยู่คนละ Channel กัน
// หาอยู่ตั้งนานว่า ผิดตรงไหน เพราะ flutter ไม่บอกว่ามี error เพียงแต่ไม่มีค่าตัวแปรที่ส่งมาให้

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
var is_Bought; // เอาไว้ที่นี่ เพราะเรียกใช้ใน result ด้วย
var is_darkMode; // โหมดมืด-สว่าง เอาไว้ที่นี่ เพราะเรียกใช้ใน result ด้วย
var notBuyMsg; // ป้ายบอกว่า ไม่ตรวจ ใช้เป็นเกณฑ์ในการ ตรวจหรือไม่ตรวจ
var tooltiptext;  // สำหรับเปลี่ยนสีพื้น tooltiptext
var answerMessagePage;  // สำหรับเฉลย ชุดเต็ม 100 ข้อ 3 ชั่วโมง
var contentPage; // // สำหรับเฉลย ชุดเต็ม 100 ข้อ 3 ชั่วโมง
// ***************

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
//


var numOfQuestions = 10;  // เป็น dummy ว่ามีทั่้งหมด 10 ข้อ
var currQstnID = "tbl_q10"; // เป็น dummy ว่าทำไปถึงข้อ 10 แล้ว จะได้แสดงเครื่องหมายถูก ว่า ทำหมดแล้ว
var clickedQstns = "xzcccx11111";

// คือส่งข้อมูลเพื่อส่งไปยัง WillpopScope ซึ่งจะทำงานตอนคลิกปุ่มลูกศรกลับไปยังหน้าที่แล้วที่เข้ามา
// ข้อมูลที่ส่งไป เอาตามรูปแบบของข้อสอบที่เป็นไฟล์ html ซึ่งประกอบไปด้วย
// จำนวนข้อทั้งหมด, ข้อปัจจุบันที่คลิก, ชื่อ id และ วันที่
// ข้อมูลที่จะเอาไปทำ ไอคอน คือ จำนวนข้อทั้งหมด และข้อที่คลิก ซึ่งเป็นชื่อ id โดยที่ Willpop จะแยกเอาเฉพาะตัวเลข
//  ทำข้อที่ 10 จากจำนวนทั้งหมด 10 ข้อ จึงได้ 100% ได้ไอคอนชื่อ p00.png คือ มีเครื่องหมายถูก แสดงว่า เสร็จแล้ว
var msgToSend = numOfQuestions + "xzc" + currQstnID + clickedQstns;

console.log("full exam 01 msgToSend: " + msgToSend);

// แก้ปัญหา Samsung blank screen
//document.getElementById("second_div").scrollIntoView();
//document.getElementById("first_div").scrollIntoView();

// ส่งข้อมูลไป flutter ผ่าน JavascriptChannel ชื่อ messageHandler เพื่อบอกว่า ทำเสร็จแล้ว


 // messageHandler.postMessage(msgToSend);

 console.log(" full exam 01 msgToSend: $msgToSend");

// ส่งข้อมูลไป Flutter พร้อมรับคาที่ส่งเข้ามาทาง messageHandler ด้วย
window.flutter_inappwebview.callHandler('messageHandler', ...msgToSend)
.then(function (result) {
// รับค่าที่ส่งเข่ามา
    console.log("isBuyAndMode จาก Flutter to JS via messageHandler: " + result.Message);
    isBuyAndMode(result.Message);
   // isBuyAndMode(isBuyAndMode);

});




// รับข้อมูลมาจาก flutter
function isBuyAndMode(myDat){
var inComingData = myDat;

console.log("myDat from Flutter: " + inComingData);
// alert ("myDat from Flutter: " + inComingData);
// inComingData is correct

// var is_Bought;
var isPremium; // ซื้อแล้ว
//var is_darkMode;
var htmlMode; // มืดหรือสว่าง

var element = document.body; // สำหรับเปลี่ยนโหมด มืด-สว่าง โดยเปลี่ยนสี background และ ตัวหนังสือ
var hex = ("#00FF00");  // สำหรับเปลี่ยนสีลิงค์ 
notBuyMsg = document.getElementById("ifNotBuy");
contentPage = document.getElementById("content");
tooltiptext  = document.getElementsByClassName("tooltiptext");
answerMessagePage = document.getElementById("showNotAvailable_notBuyVersion");
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

// แยก การซื้อ และโหมด ที่ส่งเข้ามา คั่นด้วย xyz

// เรื่องซื้อ ไม่ต้องเชค เพราะกันไว้แล้วว่า ถ้ายังไม่ซื้อ ไม่ให้เข้ามาทำข้อสอบที่นี
var datArr = inComingData.split("xyz");   //datArr[0] คือ ซื้อแล้วหรือยัง true=ซื้อแล้ว  datArr[1] คือ โหมดมือหรือไม่  true=ใช่โหมดมืด  false=ไม่ใช่โหมดมืด

//ซื้อหรือยัง
is_Bought = datArr[0];

console.log("is buy or not: " + is_Bought);
// alert("is buy or not: " + is_Bought);

console.log("is_Bought: " + is_Bought);

// เปิดให้ใช้ ชุดเต็ม ฟรี ทุกชุด  if uncomment out, will use value from Flutter
//  is_Bought = "true";


// if(notBuyMsg != null){  // คือถ้าไม่มีป้าย notBuyMsg ใน html  ก็ให้ ตรวจ
  // คือจะไม่เข้ามาที่นี่เลย จะไม่มีการ disable ปุ่ม radio ทุกข้อ
  // บางไฟล์ที่จะให้ลองทำ และตรวจ จะไม่มี div ชื่อ ifNotBuy ซึ่งบอกว่า ไม่ตรวจชุดนี้

console.log("before checking is_Bought (if false ไม่ตรวจ) : $is_Bought");
    if (is_Bought == "false"){ //ถ้ามีปุ่มและยังไม่ได้ซื้อ จะแสดงข้อความว่า ชุดนี้ไม่เฉลย

    if(notBuyMsg != null){
        notBuyMsg.style.display = "block";
        for (i=0; i<document.getElementsByTagName('input').length; i++) // disable ปุ่ม radio ทุกข้อ
          {
                //if (document.getElementsByTagName('input')[i].type == 'radio')
                if(document.getElementsByTagName('input')[i].type=='radio')
                {
                    //if (document.getElementsByTagName('input')[i].value=='clean')
                    document.getElementsByTagName('input')[i].disabled = true;
                }
            }
        } // end of notBuyMsg != null
    }else{ //ถ้ามีปุ่ม แต่ซื้อแล้ว ไม่แสดงป้าย ความจริงไม่ต้องมีก็ได้ เพราะ ค่า default คือ ไม่แสดง

 //   alert(" ซื้อแล้ว จะไม่แสดงข้อความ ที่บอกว่า ไม่ตรวจชุดนี้")
        if(notBuyMsg != null){
        notBuyMsg.style.display = "none";
        }

        // สำหรับไฟล์เฉลย จะมีป้ายบอกไม่ตรวจ จะซ่อนเสีย
        if(answerMessagePage != null){
            answerMessagePage.style.display = "none";
        }
        // แสดง เนื้อหาข้อสอบ
        contentPage.style.display = "block";

//        // ทำให้ ปุ่ม radio ทั้งหมด เลือกได้
//                for (i=0; i<document.getElementsByTagName('input').length; i++) // disable ปุ่ม radio ทุกข้อ
//                  {
//                        //if (document.getElementsByTagName('input')[i].type == 'radio')
//                        if(document.getElementsByTagName('input')[i].type=='radio')
//                        {
//                            //if (document.getElementsByTagName('input')[i].value=='clean')
//                            document.getElementsByTagName('input')[i].disabled = false;
//                        }
//                    }
    }
// } // end of notBuyMsg != null

// alert("isBought: " +  is_Bought );
// สำหรับ เฉลยชุดเต็ม

 if(answerMessagePage != null){  // ถ้าเป็นไฟล์เฉลย จะไม่มีกรอบว่าไม่ตรวจ แต่จะมีข้อความแทน
 // alert("ซื้อหรือยัง: " + is_Bought);
           if (is_Bought == "false"){
                //         alert("ยังไม่ได้ซื้อ  เฉลยชุดเต็ม");
                         console.log("answerMessagePage.style.display: " + answerMessagePage.style.display);
                         answerMessagePage.style.display = "block";
                         contentPage.style.display = "none";
           }else{
             //        alert("ซื้อแล้ว  เฉลยชุดเต็ม");
                   console.log("answerMessagePage.style.display: " + answerMessagePage.style.display);
                   answerMessagePage.style.display = "none";
                          // ทำให้ ปุ่ม radio ทั้งหมด เลือกได้
                                   for (i=0; i<document.getElementsByTagName('input').length; i++) // disable ปุ่ม radio ทุกข้อ
                                     {
                                           //if (document.getElementsByTagName('input')[i].type == 'radio')
                                           if(document.getElementsByTagName('input')[i].type=='radio')
                                           {
                                               //if (document.getElementsByTagName('input')[i].value=='clean')
                                               document.getElementsByTagName('input')[i].disabled = false;
                                           }
                                       }
                   contentPage.style.display = "block";
           } // end of   if (is_Bought == "false")
        }  // end of if(answerMessagePage




// ปรับโหมด มืด-สว่าง
is_darkMode = datArr[1];

// alert("is_darkMode \n(true = โหมดมืด, false = โหมดสว่าง) :" + is_darkMode);

if (is_darkMode == "true"){
    htmlMode = "dark";
 }else{
         htmlMode = "light";
     }

if (htmlMode=="dark"){ // ถ้าอยู่ในโหมด มืด
element.style.backgroundColor = 'black';
element.style.color = 'white';
if(notBuyMsg != null){ // บางไฟล์มีป้าย บางไฟล์ไม่มีป้ายเพราะให้ทำและตรวจ จึงต้องเชคก่อน
    // ไม่งั้น error และไม่ทำงาน ทำให้พื้นหลังของแถบนี้ เป็นสีขาว มองไม่เห็นตัวหนังสือ
    notBuyMsg.style.backgroundColor = '#adadc9';  // พื้นหลัง ป้ายบอกว่า ชุดนี้ไม่ตรวจ
}

if(tooltiptext != null){
	if (tooltiptext.length >= 1) {
        for (var i = 0; i < tooltiptext.length; i++){
        tooltiptext[i].style.backgroundColor = '#808588'; // พื้นหลัง tooltip - dark mode
        }; // end of for(var i =
   } // end of tooltip.lenght
} // end of if(tooltip != null){


// สำหรับ ตารางบทสนทนาภาษาอังกฤษ
let paintedClass = document.getElementsByClassName('painted');
if (paintedClass.length >= 1) {
    for (var i = 0; i < paintedClass.length; i++){
        paintedClass[i].style.background = '#4f4f4f';
    };
};


// สำหรับ เส้นขีดคั่นระหว่าง เศษและส่วน
let bottomElement = document.querySelectorAll('.frac span.bottom');
// alert ("bottomElement.length " + bottomElement.length);
if (bottomElement.length >= 1) {
for (var i = 0; i < bottomElement.length; i++){
        bottomElement[i].style.borderTop = '2px solid white';
    };
};  // end of if (bottomElement.length >= 1)

// สำหรับเครื่องหมายถูก ในไฟล์ตรวจ
let checkMarkElement = document.querySelectorAll('.checkMark');
// alert ("checkMarkElement .length " + checkMarkElement .length);
if (checkMarkElement.length >= 1) {
for (var i = 0; i < checkMarkElement.length; i++){
        checkMarkElement[i].style.color = 'yellow';
    };
};  // end of if (bottomElement.length >= 1)



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

// เปลี่ยนสีพื้นหลัง ของ message box ขออภัย
    var msgBoxBkg = document.getElementById("showNotAvailable_notBuyVersion");
    if(msgBoxBkg != null){
     msgBoxBkg.style.backgroundColor = '#808080';
    }



 // change background color of timer wraper
var timerWrapper = document.getElementsByClassName("timer_wrapper");
// alert("timerWrapper.length" + timerWrapper.length);
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
}  // end of  isBuyAndMode(myDat)



// ***********************

function result() {

// เปิดให้ใช้ฟรี
is_Bought = true;

//  alert("is_Bought: " + is_Bought + "\nnotBuyMsg: " + notBuyMsg);
//  alert("is_darkMode: " + is_darkMode);
if(is_Bought == "false" && notBuyMsg != null){ // แม้ว่า จะยังไม่ซื้อ แต่ไม่มีป้ายบอกว่าไม่ตรวจ ก็ให้ตรวจ
// คือจะไม่เข้ามาทำงานที่นี่ คือ จะไม่แสดง feedback

// แสดง feedback ใน id myMessage ของไฟล์ html ที่เรียกใช้งาน
		document.getElementById("myMessage").innerHTML = "มีเฉลยในรุ่นเต็ม นะครับ<br>ถ้าซื้อตอนนี้ สามารถใช้งานได้ทันที";
		modal.style.display = "block";
 return false;
}else{
var score = 0;
var part1Result;  // สำหรับผลการสอบ ความสามารถทั่วไป
var part2Result; // สำหรับผลการสอบ ภาษาอังกฤษ
var part3Result; // สำหรับผลการสอบ ข้าราชการที่ดี
var finalResult; // // สำหรับผลการสอบทั้งหมด
var N = 100; // จำนวนข้อสอบทั้งหมด สำหรับหาข้อที่ข้ามไป ไม่ได้ท

const inputListPart1 = document.getElementById("quiz_general").querySelectorAll('input[type="radio"]:checked');
const part1QstnNumber = document.getElementById("quiz_general").querySelectorAll('.quiz').length;

const inputListPart2 = document.getElementById("quiz_english").querySelectorAll('input[type="radio"]:checked');
const part2QstnNumber = document.getElementById("quiz_english").querySelectorAll('.quiz').length;

const inputListPart3 = document.getElementById("quiz_law").querySelectorAll('input[type="radio"]:checked');
const part3QstnNumber = document.getElementById("quiz_law").querySelectorAll('.quiz').length;

const totalQstnNum = part1QstnNumber + part2QstnNumber + part3QstnNumber;

const answersPart1 = [];
const answersPart2 = [];
const answersPart3 = [];
const correctAnswers = [];
const wrongAnswers =[];
const answeredQuestions = [];
const skippedQuestions = [];

    inputListPart1.forEach(input => {
      const questionNumber = input.name.replace("q", "");
      answeredQuestions.push(questionNumber); // สำหรับข้อที่ไม่ได้ทำ

      const isCorrect = input.value === "1";
	  if (isCorrect) {
      correctAnswers.push(questionNumber);
    }else{
      wrongAnswers.push(questionNumber);
    }
      answersPart1.push({ questionNumber, isCorrect });
    });

    inputListPart2.forEach(input => {
      const questionNumber = input.name.replace("q", "");
      answeredQuestions.push(questionNumber); // สำหรับข้อที่ไม่ได้ทำ
      const isCorrect = input.value === "1";
	  if (isCorrect) {
      correctAnswers.push(questionNumber);
    }else{
		wrongAnswers.push(questionNumber);
    }
      answersPart2.push({ questionNumber, isCorrect });
    });

    inputListPart3.forEach(input => {
      const questionNumber = input.name.replace("q", "");
      answeredQuestions.push(questionNumber); // สำหรับข้อที่ไม่ได้ทำ

      const isCorrect = input.value === "1";
	  	  if (isCorrect) {
      correctAnswers.push(questionNumber);
    }else{
      wrongAnswers.push(questionNumber);
    }
      answersPart3.push({ questionNumber, isCorrect });
    });

// ข้อที่ไม่ได้ทำ คือ เลขข้อที่ไม่มีในรายการที่คลิก radio button
for (let i = 1; i <= N; i++) {
    const questionNumber = i.toString();
    if (!answeredQuestions.includes(questionNumber)) {
      skippedQuestions.push(questionNumber);
    }
  }



    console.log("Part 1 Answers จำนวน:", answersPart1.length);
    console.log("Part 2 Answers จำนวน:", answersPart2.length);
    console.log("Part 3 Answers จำนวน:", answersPart3.length);
    console.log("จำนวนข้อ part 1: " + part1QstnNumber);
    console.log("จำนวนข้อ part 2: " + part2QstnNumber);
    console.log("จำนวนข้อ part 3: " + part3QstnNumber);

    console.log("Correct Answers:", correctAnswers);
	console.log("Wrong Answers:", wrongAnswers);


    const correctPart1 = answersPart1.filter(answer => answer.isCorrect).length;
    const incorrectPart1 = answersPart1.length - correctPart1;
//    const part1PercentCorrect =  Math.round((correctPart1 / part1QstnNumber) * 100);
 const part1PercentCorrect =  ((correctPart1 / part1QstnNumber) * 100).toFixed(2);
// alert("htmlMode: " + htmlMode);
if(part1PercentCorrect >= 65){
        if(is_darkMode == "true"){
            part1Result= "<span style='color: #AAFA42; font-weight: bold'> ป.ตรี, ป.โท: ผ่าน</span>"
        }else{
  		    part1Result= "<span style='color: green; font-weight: bold'> ป.ตรี, ป.โท: ผ่าน</span>"
  		}

  	}else if(part1PercentCorrect >= 60){
  	    if(is_darkMode == "true"){
		    part1Result= "<span style='color: #AAFA42; font-weight: bold'>ป.ตรี: ผ่าน</span> &ensp;<span style='color: #FAA442; font-weight: bold'> ป.โท: ไม่ผ่าน</span>"
	    }else{
	  		part1Result= "<span style='color: green; font-weight: bold'>ป.ตรี: ผ่าน</span> &ensp;<span style='color: red; font-weight: bold'> ป.โท: ไม่ผ่าน</span>"
	    }
	}else {
	//alert("is_darkMode: " + is_darkMode );
	    if(is_darkMode == "true"){
		    part1Result="<span style='color: #FAA442; font-weight: bold'>ป.ตรี, ป.โท: ไม่ผ่าน</span>"
		}else{
			part1Result="<span style='color: red; font-weight: bold'>ป.ตรี, ป.โท: ไม่ผ่าน</span>"
			}
	// }
	};
// ======================================


    const correctPart2 = answersPart2.filter(answer => answer.isCorrect).length;
    const incorrectPart2 = answersPart2.length - correctPart2;
 //   const part2PercentCorrect =  Math.round((correctPart2 / part2QstnNumber) * 100);
    const part2PercentCorrect =  ((correctPart2 / part2QstnNumber) * 100).toFixed(2);
    if(part2PercentCorrect >= 50){
        if(is_darkMode == "true"){
		    part2Result= "<span style='color: #AAFA42; font-weight: bold'>ผ่าน</span>"
        }else{
		    part2Result= "<span style='color: green; font-weight: bold'>ผ่าน</span>"
		}
	}else{
	    if(is_darkMode == "true"){
			part2Result="<span style='color: #FAA442; font-weight: bold'>ไม่ผ่าน</span>"
	    }else{
		    part2Result="<span style='color: red; font-weight: bold'>ไม่ผ่าน</span>"
		}
	};
// ======================================


    const correctPart3 = answersPart3.filter(answer => answer.isCorrect).length;
    const incorrectPart3 = answersPart3.length - correctPart3;
//    const part3PercentCorrect =  Math.round((correctPart3 / part3QstnNumber) * 100);
    const part3PercentCorrect =  ((correctPart3 / part3QstnNumber) * 100).toFixed(2);

    console.log("correctPart3: " + correctPart3);
    console.log("part3QstnNumber: " + part3QstnNumber);
    console.log("part3PercentCorrect: " + part3PercentCorrect);


    if(part3PercentCorrect >= 60){
          if(is_darkMode == "true"){
          		part3Result="<span style='color: #AAFA42; font-weight: bold'>ผ่าน</span>"
          }else{
		        part3Result="<span style='color: green; font-weight: bold'>ผ่าน</span>"
		 }
	}else{
			if(is_darkMode == "true"){
		        part3Result="<span style='color: #FAA442; font-weight: bold'>ไม่ผ่าน</span>"
			}else{
		        part3Result="<span style='color: red; font-weight: bold'>ไม่ผ่าน</span>"
            }
   };
// ======================================


    const totalPercentCorrect = (((correctPart1 + correctPart2 + correctPart3) / totalQstnNum) * 100).toFixed(2);

   if((part1PercentCorrect >= 65) && (part2PercentCorrect >= 50) && (part3PercentCorrect >= 60)){
        if(is_darkMode == "true"){
  		        finalResult = "<span style='color: #AAFA42; font-weight: bold'>ป.ตรี, ป.โท: ผ่าน</span>"
        }else{
		        finalResult = "<span style='color: green; font-weight: bold'>ป.ตรี, ป.โท: ผ่าน</span>"
		}
// ======================================
	}else if((part1PercentCorrect >= 60) && (part2PercentCorrect >= 50) && (part3PercentCorrect >= 60)){
	    if(is_darkMode == "true"){
          		finalResult = "<span style='color: #AAFA42; font-weight: bold'>ป.ตรี: ผ่าน,</span> <span style='color: #FA9742; font-weight: bold'> ป.โท: ไม่ผ่าน</span>"
            }else{
                 finalResult = "<span style='color: green; font-weight: bold'>ป.ตรี: ผ่าน,</span> <span style='color: #FA9742; font-weight: bold'> ป.โท: ไม่ผ่าน</span>"
            }
 // ======================================
	}else{
	    if(is_darkMode == "true"){
	            finalResult = "<span style='color: #FAA442;font-weight: bold'>ป.ตรี, ป.โท: ไม่ผ่าน</span>"
	    }else{
                finalResult = "<span style='color: red;  font-weight: bold'>ป.ตรี, ป.โท: ไม่ผ่าน</span>"
        }
// ======================================
   }

	const totalCorrect = correctPart1 + correctPart2 + correctPart3;

//    const skippedQstns = totalQstnNum - (correctPart1+incorrectPart1+correctPart2+incorrectPart2+correctPart3+incorrectPart3);
	const skippedQstns = skippedQuestions.length;

	var skippedQuestionsInfo;
	if (skippedQstns > 0) // ถ้ามีการข้ามไม่ทำบางข้อ ให้บอกว่าข้อไหนบ้าง
	{
		skippedQuestionsInfo = "<br>ไม่ได้ทำ จำนวน " + skippedQstns + " ข้อ คือ ข้อ " +  skippedQuestions.join(", ");
	}else{
		skippedQuestionsInfo ="";
	}

var correctQuestionsInfo;
if(totalCorrect >= 1){
	correctQuestionsInfo = "<br>ทำถูก: " + totalCorrect + " ข้อ (" + totalPercentCorrect + "%)";
}else{
	correctQuestionsInfo = "<br>ทำถูก 0 ข้อ" ;
}



	var wrongQuestionsInfo;
    const wrongAnsNum = wrongAnswers.length;
     if(wrongAnsNum > 0){
     wrongQuestionsInfo ="<br>ทำผิด " + wrongAnsNum + " ข้อ คือ ข้อ " +  wrongAnswers.join(", ");
     }else{
     wrongQuestionsInfo ="";
     }



/*
    alert("ความสามารถทั่วไป ทำถูก: " + correctPart1 + " ข้อ คิดเป็นร้อยละ " + part1PercentCorrect + "\nการตัดสิน " + part1Result +
      "\n\nภาษาอังกฤษ ทำถูก: " + correctPart2 + " ข้อ คิดเป็นร้อยละ " + part2PercentCorrect + "\nการตัดสิน " + part2Result +
      "\n\nการเป็นข้าราชการที่ดี ทำถูก: " + correctPart3 + " ข้อ คิดเป็นร้อยละ " + part3PercentCorrect + "\nการตัดสิน " + part3Result +

	"\n\nจำนวนข้อทั้งหมด: " + totalQstnNum +
	"\nทำถูกทั้งหมด จำนวน: " + totalCorrect + " ข้อ คิดเป็นร้อยละ: " + totalPercentCorrect +
	"\nข้อที่ทำถูก ได้แก่: " + "ข้อ " + correctAnswers.join(", ข้อ ") +
	"\nข้อที่ทำผิด ได้แก่: " + "ข้อ " + wrongAnswers.join(", ข้อ ") +
	"\nไม่ได้ทำจำนวน: " + skippedQstns + " ข้อ" +
	"\n\nสรุปผลการสอบ: " + finalResult);
*/

message = "<strong>ความสามารถทั่วไป</strong> <br>ทำถูก: " + correctPart1 + " ข้อ (" + part1PercentCorrect +           "%) : " + part1Result +
      "<br><strong>ภาษาอังกฤษ</strong> <br>ทำถูก: " + correctPart2 +  " ข้อ ("  + part2PercentCorrect + "%) : " + part2Result +
      "<br><strong>การเป็นข้าราชการที่ดี</strong> <br>ทำถูก: " + correctPart3 +  " ข้อ (" + part3PercentCorrect +
      "%) : " + part3Result +
	"<br><br>ข้อสอบทั้งหมด " + totalQstnNum + " ข้อ" +
	correctQuestionsInfo +
	wrongQuestionsInfo +
	skippedQuestionsInfo +
	"<br><br>สรุปผลการสอบ: " + finalResult +
	"<br><br><hr><span style = 'font-size: small'>(แตะค้างไว้เพื่อคัดลอกข้อความ)</span>";
  }



/*

  var gen_knowledge_score = 0;
  var english_score = 0;
  var law_score = 0;

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
	message = "คะแนนของท่าน: " + score + "  คะแนน หรือเท่ากับ  " + parseFloat((score /num_of_qstns)*100).toFixed(2) + " &#37;<br>ข้อที่ทำผิด: " + not_correct.toString();

	}else{
    message = "คะแนนของท่าน: " + score + "  คะแนน หรือเท่ากับ   " + parseFloat((score /num_of_qstns)*100).toFixed(2) + " &#37;"
	};

// ถ้ามีการไม่ทำบางข้อ ให้แสดงข้อมูลใน feedback ด้วย
	if (notChecked > 0)
	{
		message = message + "<br><br>ไม่ได้ทำข้อสอบ จำนวน " + notChecked + " ข้อ ได้แก่ " + skipped_qstns.toString() + "<br><br>ท่านสามารถปิดหน้าจอนี้ เพื่อกลับไปแก้ข้อผิด หรือทำต่อให้ครบ แล้วกดปุ่ม ส่งคำตอบ อีกครั้ง"
	}

*/

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
// } // end of if(is_Bought == "false"{

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

			message = "<strong><span color=\"red\">หมดเวลา </span></strong><br>ถ้ายังทำไม่เสร็จ <ol><li>ปิดหน้าจอนี้ แล้วกดปุ่ม \"ตรวจคำตอบ\" เพื่อดูคะแนน</li><li>ปิดหน้าจอนี้แล้วทำต่อให้เสร็จ แล้วกดปุ่ม \"ตรวจคำตอบ\"	</li> <li>อาจจะจับเวลาใหม่ หรือไม่จับเวลา ก็ได้</li></ol>";
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


