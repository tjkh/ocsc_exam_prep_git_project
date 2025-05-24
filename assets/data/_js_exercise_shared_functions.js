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


//var numOfQuestions = 10;  // เป็น dummy ว่ามีทั่้งหมด 10 ข้อ
//var currQstnID = "tbl_q10"; // เป็น dummy ว่าทำไปถึงข้อ 10 แล้ว จะได้แสดงเครื่องหมายถูก ว่า ทำหมดแล้ว


var numOfQuestions;  // เป็น dummy ว่ามีทั่้งหมด 10 ข้อ
var currQstnID;   // ทำไปถึงข้อ อะไร แล้ว  "tbl_q" + alreadyDone;
// var currQstnID = "tbl_q" + alreadyDone; // เป็น dummy ว่าทำไปถึงข้อ 10 แล้ว
// var alreadyDone;  // สำหรับเพิ่มข้อที่ทำ เพื่อไปคิดเปอร์เซ็นต์
var totalQsntNum;  // สำหรับหาว่า มีทั้งหมดกี่ข้อ จะได้เอามาต่อที่ currQstnID เป็นข้อสุดท้าย



// ตรงนี้ ต้องดูว่า เมื่อคลิกแสดงคำตอบ เก็บข้อของเมนูนี้-หรือเพิ่มข้อที่ทำให้มากขึ้นอีก 1
// เก็บ จำนวนที่ทำทั้งหมด ได้ โดยเอาที่จากใน Pref ที่หามาแล้ว มารวมกัน
// ถ้าเข้ามาครั้งแรก ยังไม่มี คือเป็น 1 หมด ถือว่ายังไม่ได้ทำ


var clickedQstns = "xzcccx11111";
	var btn_pause = document.getElementById("pause");
	var btn_reset = document.getElementById("reset");
	btn_start = document.getElementById("start");


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
console.log("copyText -- namesToSend: " + namesToSend);

//menuNameToFlutter.postMessage(namesToSend);

let args3 = [namesToSend];
console.log("345 namesToSend args3 to Flutter: " + args3);

 window.flutter_inappwebview.callHandler('menuNameToFlutter', ...args3)
    .then(function (result) {

        }
        );


function isContainValue(val){
    return (val === undefined || val == null || val.length <= 0) ? false : true;
}


// รับข้อมูลมาจาก flutter
function getLastQstnNum(myLastQNum){
console.log("myLastQNum from Flutter - เงื่อนไข: " + myLastQNum);
 //   let thisLNumber = myLastQNum;
  //  console.log("thisNumber from Flutter: " + thisLNumber);

    //    console.log("345 Return is_IsNewClicked - result.newString: ", result.menuName);

        var incoming = myLastQNum;
        console.log("incoming myLastQNum from Flutter - เงื่อนไข: " + incoming);
      //  var incoming = result.menuName;

            lastQstnArr = incoming.split(" "); // แยกออกจากกัน โดยใช้ช่องว่าง เป็นเกณฑ์
           console.log("lastQstnArr from sharePref - เงื่อนไข: " + lastQstnArr);
           console.log("lastQstnArr[1]: " + lastQstnArr[1]);


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

// ส่งข้อมูลไป Flutter พร้อมรับคาที่ส่งเข้ามาทาง messageHandler ด้วย
window.flutter_inappwebview.callHandler('messageHandler', ...args)
.then(function (result) {
// รับค่าที่ส่งเข่ามา
    console.log("isBuyAndMode จาก Flutter to JS via messageHandler: " + result.Message);
    isBuyAndMode(result.Message);
});

}





function show_intro_page(page, isStartTiming, myJason)  //
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

	var itemNum = document.getElementById("item_num");
			itemNum.style.display= 'none';

//	var item_number = document.getElementById("item_num");
 //      item_number.disabled = true;


    var listing_table = document.getElementById("listingTable");
    var page_span = document.getElementById("page");
//    alert("xxx buy already? " +  is_Bought + " page: " + page);


 listing_table.innerHTML = myJason;

// page_span.innerHTML = "1/1";
// page_span.style.display = 'none';

//// เวลาจะใช้จริง ให้กำหนดเป็น 6 ก็พอ
 //if((is_Bought == "false") && (page >=200)){
 if((is_Bought == "false") && (page >=10)){
// // alert("xxxx");
  const ans_btn = document.getElementById('showAnswer_btn');
  ans_btn.disabled = true;

 }

}  // end of function show_intro_page


// รับข้อมูลมาจาก flutter
function isBuyAndMode(myDat){
var inComingData = myDat;

var isPremium; // ซื้อแล้ว
var is_darkMode;
// var htmlMode; // มืดหรือสว่าง

var element = document.body; // สำหรับเปลี่ยนโหมด มืด-สว่าง โดยเปลี่ยนสี background และ ตัวหนังสือ
var hex = ("#00FF00");  // สำหรับเปลี่ยนสีลิงค์


// แยก การซื้อ และโหมด ที่ส่งเข้ามา คั่นด้วย xyz
// เรื่องซื้อ ไม่ต้องเชค เพราะกันไว้แล้วว่า ถ้ายังไม่ซื้อ ไม่ให้เข้ามาทำข้อสอบที่นี
datArr = myDat.split("xyz");   //datArr[0] คือ ซื้อแล้วหรือยัง true=ซื้อแล้ว  datArr[1] คือ โหมดมือหรือไม่  true=ใช่โหมดมืด  false=ไม่ใช่โหมดมืด

is_Bought = datArr[0];

console.log("is_Bought in function isBuyAndMode(myDat) " +  is_Bought);


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
//element.style.color = 'yellow';


// เปลี่ยนสี เส้นคั่นเศษส่วน
//var frac_line = document.getElementsByClassName("bottom");
//    for(i=0; i<frac_line.length; i++) {
//      frac_line[i].style.borderTop = "thin solid #FFFFFF";
//    }


// เปลี่ยนสี เส้นคั่นเศษส่วน
var fraction_line = document.getElementsByClassName("bottom");
// var fraction_line =  document.getElementsByClassName("bottom");
 //   if(fraction_line !== null){
 console.log("fraction_line --symbol cndtng ex: " + fraction_line.length);
        for(var i = 0; i < fraction_line.length; i++){
            fraction_line[i].style.borderTop='thin solid #0000FF';
        }

   // }

 // กรอบล้อมรอบ คำถาม
 var tableBorder = document.getElementById("listingTable");
 tableBorder.style.borderColor = "gray";

 // กรอบล้อมรอบ คำตอบ
  var show_Answer = document.getElementById("showAnswer");
  show_Answer.style.borderColor = "gray";

// เส้นคั่น ระหว่าง เศษ และ ส่วน

var frac_line = document.getElementsByClassName('span.bottom');
  for (var i = 0; i < frac_line.length; i++) {
    frac_line[i].style.color = 'white';
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


  var tableElements = document.getElementsByTagName("table");
 // alert("tableElements length: " + tableElements.length);
  for(var i = 0; i < tableElements.length; i++){
      var thisTable = tableElements[i] ;
      var rows = thisTable.getElementsByTagName("tr") ;
  		for (var j=0; j<rows.length; j++) {
  		 if (j % 2 == 0){
                rows[j].style.backgroundColor = "#818181";;
            }else{
                rows[j].style.backgroundColor = "#6a6a6a ";
  			//	rows[j].style.backgroundColor = "#818181";
  			//	rows[j].style.backgroundColor = "red";
  			}
  		}
  	}



}else{  // ถ้าอยู่ในโหมด สว่าง
element.style.backgroundColor = 'white';
element.style.color = 'black';


}
}  // end of  isBuyAndMode(myDat)



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

//  **************** ตรวจถึงตรงนี้ **********


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



var current_page;  // หน้าปัจจุบัน แต่ละเมนูต้องมาเปลี่ยน ตัวแปรนี้ด้วย เพราะเอาไปใช้กับ ปุ่มต่อไป - กลับ
var records_per_page = 1;
var jsonName_id = ""; // สำหรับเก็บชื่อตัวแปร json เพื่อส่งไปยัง Android เพื่อเก็บลงฐานข้อมูล เวลากลับมาอีกครั้ง จะได้รู้ว่า ทำอะไร ไปถึงข้ออะไร
var thisJson = [];

// from: https://stackoverflow.com/questions/2264072/detect-a-finger-swipe-through-javascript-on-the-iphone-and-android
document.addEventListener('swiped', function(e) {
    console.log(e.target); // the element that was swiped
    console.log(e.detail.dir); // swiped direction
});

document.addEventListener('swiped-left', function(e) {
  //  console.log(e.target); // the element that was swiped
//	alert('swiped left current_page: '+ current_page);
// alert("current_page: " + current_page + "\nnumberOfPages: " + numPages());
	if(current_page == 0){
	        current_page = 1};
	        // alert('swiped left current_page 0+1: '+ current_page);
	nextPage();
});

document.addEventListener('swiped-right', function(e) {
   // console.log(e.target); // the element that was swiped
//	alert('swiped right current_page: '+ current_page);
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
        let this_curr_pge = current_page;
        console.log("resetCountDown if greater than 1 current_page" + this_curr_pge);
        changePage(current_page, true,thisJson);
    }
}

function nextPage()
{
 // alert("current_page in nextPage function: " + current_page + "\nnumberOfPages: " + numPages());
var showIt = document.getElementById("showAnswer");
showIt.style.display = 'none';
//var showMsg = document.getElementById("myMessage");
//showMsg.style.display = 'none';
// countDown(0,00,05)
resetCountDown();
// // document.getElementById('myInput').value = '';

    if (current_page < numPages()) {
        current_page++;
        let this_curr_pge = current_page;
        console.log("current_page++ in nextPage: " + current_page);
        console.log("numPages in nextPage: " + numPages);

        changePage(current_page, true, thisJson);
    }
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

} // end of addBkg()




function showItAns()
{
	pauseCountDown();

		//disable answer button
    var shBttn = document.getElementById("showAnswer_btn");
    shBttn.disabled = true;

//var current_page = 1;
//var records_per_page = 1;
//var jsonName = "";

console.log("เรื่อง: " + jsonName_id + "\nหน้าปัจจุบัน: " + current_page + "\nจำนวนข้อทั้งหมด: " + numPages());

var name = jsonName_id;
//alert("jsonName_id in showItAns(): " + name);
console.log("jsonName_id in showItAns(): " + name);
var currQstnNum = current_page;
console.log("currQstnNum or current_page: " + currQstnNum);
var totalNum = numPages();
var exerciseMsg = name+"xzc"+currQstnNum+"xzc"+totalNum;

// numOfQuestions = totalNum
// currQstnID = "tbl_q" + currQstnNum;

console.log("exerciseMsg (เงื่อนไข) from symbol_cndtng_exercise to Flutter: " + exerciseMsg);  // เช่น exMenu_normal_cndtngxzc1xzc38
// ส่งข้อมูลไป Android  ว่าทำเรื่องอะไร ข้อสุดท้ายที่ทำคือข้ออะไร และ เรื่องนี้มีทั้งหมดกี่ข้อ เพื่อเก็บลงฐานข้อมูล

window.flutter_inappwebview.callHandler('exerciseData', ...exerciseMsg);
// exerciseData.postMessage(exerciseMsg);

// ส่งไป Flutter เพื่อปรับวงกลมความก้าวหน้า ********** ของเดิมไม่มีส่งตรงนี้ *****
currQstnID = "tbl_q"+current_page;  // ส่งหน้าปัจจุบัน เพื่อไปคำนวรแสดงว่า ทำได้ประมาณเท่าไรแล้ว ในรูป เช่น tbl_q20
        var args5 = numOfQuestions + "xzc" + currQstnID + clickedQstns;
console.log("zz messege --args5-- to Flutter from เงื่อนไข via messageHandler: " + args5);
// ************ อันนี้ไม่ได้ส่งใน ของเดิม ORG เอาออกไปก่อน ***********
// ส่งข้อมูลไป Flutter พร้อมรับคาที่ส่งเข้ามาทาง messageHandler ด้วย
 window.flutter_inappwebview.callHandler('messageHandler', ...args5)


// ปรับข้อมูล หน้าปัจจุบัน ใน ตัวแปร Array ที่เก็บหน้าปัจจุบันไว้ทั้งหมด ซึ่งจะเอามาใช้ตอนคลิกเมนู ด้วย
// ไม่งั้น ไปเมนูอื่น แล้วกลับมา จะไม่กลับมาหน้าเดิมที่ออกไป

console.log("lastQstnArr เงื่อนไข in showItAns() :" + lastQstnArr);
// หาตำแหน่งของชื่อเมนูนี้ ใน ตัวแปร ที่เก็บข้อสุดท้าย เพื่อจะได้ปรับข้อมูลใหม่ให้เป็นปัจจุบัน เมื่อคลิกปุ่มตรวจ
var thisPos = lastQstnArr.findIndex(element => element.includes(name));

console.log("thisPos เงื่อนไข: " + thisPos);

// ไปเอาข้อมูลเก่ามาเพื่อเปลี่ยน ข้อใหม่แทนข้อเก่า
//ข้อใหม่คือ currQstnNum ที่ได้มาจากการคลิกตรวจ ซึ่งมีการเลื่อนหน้าแล้ว ในตัวแปร current_page

//alert("lastQstnArr: " + lastQstnArr);
//alert("name: " + name);
var thisStringName = lastQstnArr.find(element => element.includes(name));
// alert("thisStringName: " + thisStringName);
console.log("thisStringName inside showItAns(): " + thisStringName);
var thisStringNameArr = thisStringName.split("xyz");
//เอาเฉพาะ ชื่อ
var thisName =  thisStringNameArr[0]; // ตัวที่ 1 คือ ชื่อเมนู

// ปรับใหม่ เปลี่ยนเป็นหน้าปัจจุบัน (ใหม่)
var newStringName = thisName + "xyz" + currQstnNum;

// ปรับข้อมูล ใน lastQstnArr

 console.log("thisStringName เงื่อนไข: " + thisStringName); // e.g., normal_cndtngxyz38

lastQstnArr[thisPos] = newStringName;


// alert("thisNumDat: " + thisNumDat);  // normal_cndtngxyz1


//alert("lastQstnArr: " + lastQstnArr +"\n\nthisStringName: " + thisStringName + "\n\nthisPos: " + thisPos);

// alert("name: " + name + "\ncurrQstnNum: " + currQstnNum);



// var thisNameArr = thisStringName.split("xyz");
 //       thisName =  thisLNumberArr[0]; // ตัวที่ 1 คือ ชื่อเมนู
  //      thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

 // รวมกันเพื่อส่งกลับไปปรับค่าใน  lastQstnArr
// var newCurrItemNum = thisName + "xyz" +


 //แสดงคำตอบ โดยไปเอามาจากใน Json ในตำแหน่งของข้อนี้
    var showIt = document.getElementById("showAnswer");
        if(current_page == 0){  // ตำแหน่ง element ที่ 0 คือหน้าที่ 1
                        // สาเหตุที่เป็น 0 เพราะเข้ามาครั้งแรก จะไม่มีใน SharePref จึงกำหนดให้เป็น 1
            current_page = 1;
        }
      //  let thisListElement = current_page - 1;
       // console.log("showIt เงื่อนไข: " + showIt);
//        console.log("current_page เงื่อนไข: " + current_page);
//        console.log("current_page เงื่อนไข: " + current_page + " element: " + thisListElement);
//        console.log(Number(current_page)-1);

//        console.log("cvb thisJson.length เงื่อนไข: " + thisJson.length);
//        console.log("cvb current_page เงื่อนไข: " + current_page);
//
//        console.log("thisJson[1].answer เงื่อนไข: " + thisJson[1].answer + "<br>");
//        console.log("thisJson[current_page] เงื่อนไข: " + thisJson[current_page-1]);
//        console.log("thisJson[current_page].answer เงื่อนไข: " + thisJson[current_page-1].answer);
//        console.log("thisJson[current_page-1] เงื่อนไข: " + thisJson[current_page-1]);



// ลบ 1 คือให้เริ่มจาก 0 ไม่ใช่จาก 1 เพราะ การนับจำนวน element ใน array เริ่มจาก 1 แต่ list เริ่มจาก 0
//	showIt.innerHTML =  "คำตอบคือ: " + thisJson[current_page-1].answer + "<br>";
	showIt.innerHTML = thisJson[Number(current_page)-1].answer + "<br>";
	showIt.style.display = 'block';
}

//




function changePage(page, isStartTiming, myJason)
{
// alert("page inside function changePage: " + page);
console.log("inside changePage เงื่อนไข - page: " + page + "; menu: " + JSON.stringify(myJason, null, 2));
console.table(myJason); // print out myJason

    swipeEnabled = true;  // Set this to true to enable, false to disable

    var btn_next = document.getElementById("btn_next");
    var btn_prev = document.getElementById("btn_prev");
	var btn_first = document.getElementById("go_first");
	var btn_last = document.getElementById("go_last");
    var listing_table = document.getElementById("listingTable");
    var page_span = document.getElementById("page");
	var itemNum = document.getElementById("item_num");
			itemNum.style.display= 'block';

//	var itm_number = document.getElementById("item_num");
//	if (itm_numbe.disabled = true)
//		{
//			itm.disabled = false;
//		}

	var btn_showAns = document.getElementById("showAnswer_btn");


	//alert("page inside changePage function: " + page);


	if (btn_showAns.disabled == true)
		{
			btn_showAns.disabled = false;
		}
	//	 alert("btn_showAns.disabled? " +  btn_showAns.disabled);
//    alert("xxx buy already? " +  is_Bought + " page: " + page);

// เวลาจะใช้จริง ให้กำหนดเป็น 10 ก็พอ
 //if((is_Bought == "false") && (page >=200)){
 if((is_Bought == "false") && (page >=10)){
 // alert("xxxx");
  const ans_btn = document.getElementById('showAnswer_btn');
  ans_btn.disabled = true;
  var msgForNon = document.getElementById('msgForNon-buyers');
  msgForNon.style.display = 'block';

  }



if (isStartTiming == true)
{
// มีการตั้งเวลา 2 ที่ คือ ที่แรกตอนกดปุ่มเริ่มจับเวลา ซึ่งอยู่ในไฟล์ html
// และตรงนี้ จะทำงานเมื่อเปลี่ยนหน้า หรือเปลี่ยนข้อ จะเริ่มใหม่โดยอัตโนมัติ จะได้ ไม่ต้องกดจับเวลาใหม่ ทุกครั้งที่ขึ้นข้อใหม่
// ระวัง ต้องให้ การตั้งเวลาทั้งสองที่ ตรงกันด้วย
  countDown(0,01,48);  // ตั้งเวลา (ข้อละ) 1 นาที 48 วินาที  ไม่เอาดีกว่า ขึ้นข้อใหม่ ให้กดเริ่ม ไม่เอาอัตโนมัติ

  }
    // Validate page
if (page < 1) page = 1;
if (page > numPages()) page = numPages();

    listing_table.innerHTML = "";

    console.log("thisJson[1].number: " + thisJson[1].number);
    console.log("thisJson.length: " + thisJson.length);
    console.log("records_per_page: " + records_per_page);
    console.log("numPages: " + numPages());

    // listing_table.innerHTML = "<strong>Debug: Listing starts here</strong><hr>";

    console.log("About to enter loop with page = " + page + " and records_per_page = " + records_per_page);


//    console.log("symblCon_dat_2.length = " + symblCon_dat_2.length);
//    thisJson = symblCon_dat_2;
//    console.log("thisJson.length = " + thisJson.length);
//
//    console.log("symblCon_dat_2 has", symblCon_dat_2.length, "items");
//    console.log("symblCon_dat_2 sample:", symblCon_dat_2[0]);
//
//    for (let i = 0; i < thisJson.length; i++) {
//      const item = thisJson[i];
//      if (item && item.number) {
//        console.log("Rendered content:", item.number);
//        // Possibly render to DOM
//      } else {
//        console.log("Skipping item at index", i, ":", item);
//      }
//    }



try {
    for (let i = (page - 1) * records_per_page; i < (page * records_per_page) && i < thisJson.length; i++) {
      console.log("Loop index i = " + i);
      console.log("Rendered content: ", thisJson[i].number);
      listing_table.insertAdjacentHTML("beforeend", thisJson[i].number + "<br>");
    }
    } catch (e) {
      console.error("Error inside loop:", e);
    }

//for (i = (page-1) * records_per_page; i < (page * records_per_page) && i < thisJson.length; i++) {
//       // listing_table.innerHTML += thisJson[i].number  + "<br>";
//       listing_table.insertAdjacentHTML("beforeend", thisJson[i].number + "<br>");
//
//       console.log("Rendered content: ", thisJson[i].number);
//       console.log("Plain text:", listing_table.innerText);
//       console.log("Current listing_table.innerHTML: ", listing_table.innerHTML);
//       console.log(typeof thisJson[i].number); // Should be "string"
//
//    }

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


function show_how_to(page, isStartTiming, myJason)
{
    swipeEnabled = false;  // Set this to true to enable, false to disable
// alert("Entering show_how_to" + myJason);
console.log("Entering show_how_to");
console.log("html: " + myJason);
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

	var itemNum = document.getElementById("item_num");
			itemNum.style.display= 'none';

//	var item_number = document.getElementById("item_num");
 //      item_number.disabled = true;


    var listing_table = document.getElementById("listingTable");
    var page_span = document.getElementById("page");
//    alert("xxx buy already? " +  is_Bought + " page: " + page);


 listing_table.innerHTML = myJason;


// เวลาจะใช้จริง ให้กำหนดเป็น 6 ก็พอ
 //if((is_Bought == "false") && (page >=200)){
 if((is_Bought == "false") && (page >=10)){
 // alert("xxxx");
  const ans_btn = document.getElementById('showAnswer_btn');
  ans_btn.disabled = true;

  }

}  // end of function show_how_to


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
   //         alert("ไม่พบเลขข้อที่ท่านระบุ");
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


function countDown(h, m, s){
// alert("[set time out] h: " + h + " m: " + m + " s: " + s);
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
       console.log("time out at: " + h  +" : " + m  +" : " + s );
       console.log("timer - time out: " + hour +" : " + min +" : " + sec);
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

// console.log("swp swipeEnabled -symbol-con: " + swipeEnabled + "; e.target.getAttribute: " + e.target.getAttribute('data-swipe-ignore'));

        // if the element has data-swipe-ignore="true" we stop listening for swipe events
       // if (e.target.getAttribute('data-swipe-ignore') === 'true') return;

    if (!swipeEnabled || e.target.getAttribute('data-swipe-ignore') === 'true') return;
  //  if (e.target.getAttribute('data-swipe-ignore') === 'true') return;


        startEl = e.target;

        timeDown = Date.now();
        xDown = e.touches[0].clientX;
        yDown = e.touches[0].clientY;
        xDiff = 0;
        yDiff = 0;
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

