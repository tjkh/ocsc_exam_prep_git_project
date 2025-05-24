 var current_page_Array_from_Flutter = [0,0,0,0,0,0,0,0,0,0,0]; //สำหรับรับค่าหน้าที่ทำสุดท้าย ซึ่งเก็บไว้ใน SharePref และส่งมา JS จาก Fluttr

function changeData(myJason){
 // alert("bought already???? " + is_Bought);
//alert("myJason: " + myJason);
 // alert("lastQstnArr inside case=normal: " + lastQstnArr)  // first time will be undefined
 // after displaying first page, lastQstnArr is defined.
console.log("in coming myJason: " + myJason);
//alert("in coming myJason: " + myJason);
  // หาชื่อเมนู และ หน้าสุดท้ายที่ส่งมาจาก Flutter
 console.log("current_page_Array_from_Flutter in changeData: " + current_page_Array_from_Flutter);
console.log("lastQstnArr in changeData: " + lastQstnArr);

if (typeof lastQstnArr === 'undefined') {
console.log("lastQstnArr is undefined. Menu: " + myJason);
   // changePage(1, thisJson, false);
}




 swipeEnabled = true;
console.log("lastQstnArr (ตัวแปร global) ใน changeData: " + lastQstnArr);

switch (myJason) {

case "math_intro_2":
    swipeEnabled = false;  // Set this to true to enable, false to disable
// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_pause.disabled = true;
	btn_reset.disabled = true;
	btn_start.disabled = true;
	resetCountDown();

	document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่ ถ้ามาจากหน้าที่มีเฉลย
    // ไฟล์ html อธิบายวิธีทำ ทั้งไฟล์เอามาใส่ในตัวแปรเลยตรง ๆ ถ้าจะแก้ ให้คัดลอก ไปแก้ใน editPlus เอา \n เพิ่มต่อจาก <br> เพื่อให้ขึ้นบรรทัดใหม่ และเวลาจะเอามาไว้ที่นี่ ให้ตัด \n ออกก่อน
    thisJson = "<!DOCTYPE html><html lang='th'> <head>    <meta charset='UTF-8'>    <meta name='viewport' content='width=device-width, initial-scale=1'>     <link rel='stylesheet' type='text/css' href='my_style.css'>    <link rel='stylesheet' type='text/css' href='symbol_cndtng_exercise.css'>	<style>table {border-collapse: collapse; border-spacing: 0; width: 100%;border: 1px solid #ddd;} tr:nth-child(even) {background-color: #B2BEB5;}  tr:nth-child(odd) {background-color: #A9A9A9;}.fraction {  display: inline-block;  position: relative;  vertical-align: middle;   letter-spacing: 0.001em;  text-align: center;  font-size: 12px;  }.fraction > span {   display: block;   padding: 0.1em;   }.fraction span.fdn {border-top: thin solid black;}.fraction span.bar {display: none;}    body {        font-size: 16px;    }/* ให้เส้นคั่น ห่างจากขอบซ้าย นิดนึง*/ hr{margin-left:30;} .equal-width td { width: 50%; } ol{  padding-left:15px;}/* Second Level */ol ol{  padding-left:17px;}/* Third Level */ol ol ol{  padding-left:18px;}ul{  padding-left:15px;}/* Second Level */ul ul{  padding-left:17px;}/* Third Level */ul ul ul{  padding-left:18px;}</style>		<title>Document</title></style>  <title>how_to</title> </head> <body>แบบฝึกนี้มุ่งเน้น การฝึกทำข้อสอบในเวลาจำกัด ข้อสอบที่นำมาฝึก เป็นข้อสอบเสมือนจริงที่มีผู้เข้าสอบจำมาจากห้องสอบ ซึ่งมีบางส่วนที่ผู้เข้าสอบจำคลาดเคลื่อนไปบ้าง อีกทั้งผู้เขียนยังมีการปรับแต่งเติมให้สมบูรณ์ขึ้น ทั้งตัวคำถามและตัวเลือกคำตอบ ทั้งนี้ ยังสามารถใช้ฝึกทักษะเพื่อเตรียมตัวสอบได้เป็นอย่างดี  <img src='images/happy.png' width='16' height='16'> <br><br> ก่อนทำข้อสอบจับเวลา ท่านควรฝึกทักษะเรื่องต่าง ๆ ในเมนูเสียก่อน เพื่อให้มีความคุ้นเคย ก่อนที่จะลองทำข้อสอบเสมือนจริง จับเวลา<br><br>ท่านควรเตรียมกระดาษ สำหรับสำหรับคิดคำนวณแต่ละข้อ เหมือนกับท่านทำข้อสอบเสมือนจริงในห้องสอบ <br><br> เวลาที่กำหนดให้ทำแต่ละข้อโดยเฉลี่ยคือ ข้อละ 1 นาที 48 วินาที ซึ่งคิดเฉลี่ยจากจำนวนข้อทดสอบและเวลาสอบจริง <br><br>ในการฝึกแม้ว่าจะหมดเวลาแล้ว แต่ท่านสามารถทำข้อนั้นต่อไปได้ <br><br>การจับเวลา โปรแกรมจะจับเวลาโดยอัตโนมัติ เมื่อขึ้นข้อใหม่ <br><br>ถ้าต้องการหยุด ให้กดปุ่ม pause<br><br> สำหรับเรื่องตาราง เป็นข้อสอบเสมือน มีลักษณะการถามเหมือนข้อสอบเสมือนจริง <br><br>ในการทำข้อสอบเสมือนจริง ถ้าข้อไหนใช้เวลามาก ควรเก็บไว้ทำภายหลัง เลือกทำข้อง่าย ที่ใช้เวลาน้อยเสียก่อน<br>  </body></html>";
    show_how_to(1, false, thisJson);  // แสดงหน้าคำอธิบาย
 //   thisJson = "math_intro";
 //   changePage(1, false, thisJson);
    break;

case  "symblCon_2":

// alert("lastQstnArr inside case = symblCon_2: " + lastQstnArr);

console.log("lastQstnArr in case 'symblCon_2' before calling lastQstnArr.find(): " + lastQstnArr);

if (!lastQstnArr) {
  console.warn("lastQstnArr is undefined");
  return;
}

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู normal เพื่อไปยังข้อสุดท้ายที่เคยทำ
// https://stackoverflow.com/questions/4556099/how-do-you-search-an-array-for-a-substring-match
var thisNumDat = lastQstnArr.find(element => element.includes("symblCon_2"));


console.log("thisNumDat case symblCon_2: " + thisNumDat);  // normal_cndtngxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย
		console.log("thisLNumber case symblCon_2: " + thisLNumber);
//		alert("thisLNumber case symblCon_2: " + thisLNumber);
// alert("thisLNumberArr for symblCon_dat_2 to send to changePage: " + thisLNumberArr);
// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;

  	// clear input field
    // document.getElementById('myInput').value = '';
	document.getElementById('showAnswer').style.display ='none';
    //	shuffle(sectmented);

    // เรียงตาม id
    symblCon_dat_2 = symblCon_dat_2.sort((a, b) => {
        if (a.id > b.id) {  // เรียง มาก ไป น้อย ปีล่าสุดปัจจุบัน -> ปีที่ผ่านมาแล้ว
        return -1;
        }
    });

    thisJson = symblCon_dat_2;
 //   alert("thisJson for symblCon_dat_2 to send to changePage: " + myJason);
    current_page = thisLNumber;
    jsonName_id = "exMenu_symblCon_2";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล

    console.log("thisNumDat symblCon:", thisNumDat);
    console.log("thisLNumberArr symblCon:", thisLNumberArr);
    console.log("thisLNumber before parse symblCon:", thisLNumber);


    changePage(thisLNumber, false, thisJson);
    break;


case "serialNum_2":

// alert("lastQstnArr : " + lastQstnArr)

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู fraction
var thisNumDat = lastQstnArr.find(element => element.includes("serialNum_2"));
console.log("thisNumDat case serialNum_2: " + thisNumDat); 

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย
		console.log("thisLNumber case serialNum_2: " + thisLNumber);
	//	alert("thisLNumber case serialNum_2: " + thisLNumber);

  	// clear input field
    // document.getElementById('myInput').value = '';
	// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;
    document.getElementById('showAnswer').style.display ='none';
  //  shuffle(add_increment_base_const_power);

     // เรียงตาม id
      serialNum_dat_2 = serialNum_dat_2.sort((a, b) => {
          if (a.id < b.id) {
          return -1;
          }
      });



    thisJson = serialNum_dat_2;
    current_page = thisLNumber;
    jsonName_id = "exMenu_serialNum_2";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล

console.log("thisNumDat serial:", thisNumDat);
console.log("thisLNumberArr serial:", thisLNumberArr);
console.log("thisLNumber before parse serial:", thisLNumber);

    changePage(thisLNumber, false, thisJson);
    break;
    
case "operate_2":

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู multi_connection
var thisNumDat = lastQstnArr.find(element => element.includes("operate_2"));
// alert("thisNumDat case operate_2: " + thisNumDat);  // multi_connection_cndtngxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

		console.log("thisLNumber case operate_2: " + thisLNumber);
//		alert("thisLNumber case operate_2: " + thisLNumber);

	    document.getElementById('showAnswer').style.display ='none';
       // shuffle(alternate_plus_multiply);

         // เรียงตาม id
           operate_dat_2 = operate_dat_2.sort((a, b) => {
               if (a.id < b.id) {
               return -1;
               }
           });

        thisJson = operate_dat_2;
        current_page = thisLNumber;
        jsonName_id = "exMenu_operate_2";

// alert("operate page send to changePage: " + thisLNumber);
        changePage(thisLNumber, false, thisJson)

    break;


case  "exMenu_mixed_2567":

 // Combine the arrays using the spread operator
  const combinedArray_2 = [...symblCon_dat_2, ...operate_dat_2, ...others_dat_2, ...serialNum_dat_2];

  // Create a copy of the combined array
   const copiedArray_2 = [...combinedArray_2]; // Or combinedArray.slice();

// Function to sort the array randomly
let randomSortedArray_2 = copiedArray_2.sort(() => Math.random() - 0.5);


        thisJson = randomSortedArray_2;
        current_page = 1;  // เริ่มที่ข้อ 1 เพราะมีการสลับข้อ ไม่ต้องจำข้อสุดท้าย
        jsonName_id = "exMenu_mixed_2567";

        console.log("thisNumDat mixed:", thisNumDat);
        console.log("thisLNumberArr mixed:", thisLNumberArr);
        console.log("thisLNumber before parse mixed:", thisLNumber);

        changePage(current_page, false, thisJson)

    break;

// ****************

case "others_2":

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู multi_connection
var thisNumDat = lastQstnArr.find(element => element.includes("others_2"));
// alert("thisNumDat: " + thisNumDat);  // mixed_cndtngxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย
		console.log("thisLNumber case others (2): " + thisLNumber);
//		alert("thisLNumber case others (2): " + thisLNumber);

    // document.getElementById('myInput').value = '';  // ลบที่พิมพ์คำตอบก่อนหน้านี้ ในช่อง input
	document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่


    others_dat_2 = others_dat_2.sort((a, b) => {
          if (a.id < b.id) {
          return -1;
          }
      });

 thisJson = others_dat_2;


//	current_page = 1;  // เริ่มที่หน้า 1
	jsonName_id = "exMenu_others_2";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
    current_page = thisLNumber;
//	 "thisJson: " + thisJson.length);
  //  changePage(1, false, thisJson);  // ส่งข้อมูลไปแสดง หน้า, ยังไม่เริ่มจับเวลา(เพราะเพิ่งเข้ามา), ไฟล์ข้อมูลที่เลือก
    changePage(thisLNumber, false, thisJson);  // ส่งข้อมูลไปแสดง หน้า, ยังไม่เริ่มจับเวลา(เพราะเพิ่งเข้ามา), ไฟล์ข้อมูลที่เลือก
    break;


default:   
    
// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู plus_minus
//var thisNumDat = lastQstnArr.find(element => element.includes("table"));

//var thisLNumberArr = thisNumDat.split(":xyz:");
//        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย
	document.getElementById('showAnswer').style.display ='none';
//    shuffle(staticMultiply_incredmentPlus);
    thisJson = others_dat_2;
    changePage(1, false, thisJson);
   
}
}

