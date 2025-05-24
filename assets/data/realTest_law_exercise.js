var current_page_Array_from_Flutter = [0,0,0,0,0,0,0,0,0,0,0]; //สำหรับรับค่าหน้าที่ทำสุดท้าย ซึ่งเก็บไว้ใน SharePref และส่งมา JS จาก Fluttr
 

function changeData(myJason){
// alert("bought already???? " + is_Bought);
//alert("myJason: " + myJason);
 // alert("lastQstnArr inside case=normal: " + lastQstnArr)  // first time will be undefined
 // after displaying first page, lastQstnArr is defined.


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

case "realTest_law_exer_intro":


    swipeEnabled = false;  // Set this to true to enable, false to disable
// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_pause.disabled = true;
	btn_reset.disabled = true;
	btn_start.disabled = true;
	resetCountDown();

    document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่ ถ้ามาจากหน้าที่มีเฉลย
    // ไฟล์ html อธิบายวิธีทำ ทั้งไฟล์เอามาใส่ในตัวแปรเลยตรง ๆ ถ้าจะแก้ ให้คัดลอก ไปแก้ใน editPlus เอา \n เพิ่มต่อจาก <br> เพื่อให้ขึ้นบรรทัดใหม่ และเวลาจะเอามาไว้ที่นี่ ให้ตัด \n ออกก่อน
    thisJson = "<!DOCTYPE html><html lang='th'> <head>    <meta charset='UTF-8'>    <meta name='viewport' content='width=device-width, initial-scale=1'>     <link rel='stylesheet' type='text/css' href='my_style.css'>    <link rel='stylesheet' type='text/css' href='symbol_cndtng_exercise.css'>	<style>table {border-collapse: collapse; border-spacing: 0; width: 100%;border: 1px solid #ddd;} tr:nth-child(even) {background-color: #B2BEB5;}  tr:nth-child(odd) {background-color: #A9A9A9;}.fraction {  display: inline-block;  position: relative;  vertical-align: middle;   letter-spacing: 0.001em;  text-align: center;  font-size: 12px;  }.fraction > span {   display: block;   padding: 0.1em;   }.fraction span.fdn {border-top: thin solid black;}.fraction span.bar {display: none;}    body {        font-size: 16px;    }/* ให้เส้นคั่น ห่างจากขอบซ้าย นิดนึง*/ hr{margin-left:30;} .equal-width td { width: 50%; } ol{  padding-left:15px;}/* Second Level */ol ol{  padding-left:17px;}/* Third Level */ol ol ol{  padding-left:18px;}ul{  padding-left:15px;}/* Second Level */ul ul{  padding-left:17px;}/* Third Level */ul ul ul{  padding-left:18px;}</style>		<title>Document</title></style>  <title>how_to</title> </head> <body>แบบฝึกนี้มุ่งเน้น การฝึกทำข้อสอบในเวลาจำกัด เพื่อฝึกประสบการณ์ในสภาพเสมือนจริง ประกอบด้วยข้อสอบตั้งแต่ปี 2563 เป็นต้นมา จนถึงปีปัจจุบัน ข้อสอบที่นำมาฝึก เป็นข้อสอบเสมือนจริงที่มีผู้เข้าสอบจดจำมาจากห้องสอบ ซึ่งมีความคลาดเคลื่อนจากข้อสอบจริงไปบ้าง อีกทั้งยังมีการตกแต่งเติมในข้อคำถามและตัวเลือกเพิ่มเติม เพื่อให้มีความสมบูรณ์ หรือปรับเปลี่ยนไปตามกฎหมายที่เปลี่ยนแปลง เป็นต้น จึงเป็นแต่เพียงเสมือนจริงเท่านั้น<br><br>ข้อสอบแบ่งออกตามลักษณะของกฎหมาย แต่มีเมนูสุดท้าย ที่เป็นการรวมทุกฎหมายปะปนกัน <br><br>เนื่องจากมีข้อสอบจำนวนมาก คิดว่าไม่น่าจะทำเสร็จเพียงครั้งเดียว ดังนั้นจึงมีการจดจำการทำครั้งสุดท้ายเอาไว้ เมื่อเข้ามาฝึกทำต่อ จะได้ทำต่อเนื่องกันไปจากเมื่อครั้งก่อน<br><br>สำหรับเรื่องคะแนน ในส่วนนี้จะไม่เก็บคะแนน เพราะสามารถเลือกคำตอบได้หลายครั้ง ถ้าต้องการทราบผลคะแนน ให้เลือกทำในส่วนสุดท้าย ซึ่งคำนวนคะแนนให้จริง หลังจากกดปุ่มส่งคำตอบแล้วเท่านั้น </body></html>";
    show_how_to(1, false, thisJson);  // แสดงหน้าคำอธิบาย
    break;

case "stateAdmin":
console.log("lastQstnArr in stateAdminl: " + lastQstnArr);
// lastQstnArr คือ idของเมนูทั้งหมดและหน้าที่คลิก คั่นด้วย xyz เช่น exMenu_normal_cndtngxyz0,exMenu_fraction_cndtng ...
// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะid เมนู exMenu_stateAdmin_exer
// https://stackoverflow.com/questions/4556099/how-do-you-search-an-array-for-a-substring-match

var thisNumDat = lastQstnArr.find(element => element.includes("exMenu_stateAdmin_exer"));

console.log("stateAdmin thisNumDat: " + thisNumDat);  // เช่น exMenu_stateAdmin_exerxyz1

var thisLNumberArr = thisNumDat.split(":xyz:"); // ทำ string เป็น list โดยใช้ xyz เป็นตัวแยก
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย
console.log("lastQstnArr from Flutter : " + lastQstnArr);
console.log("thisNumDat แยกจาก lastQstnArr from Flutter - : " + thisNumDat);
console.log("thisLNumber ที่ส่งเข้ามากับ lastQstnArr จาก Flutter  " + thisLNumber);

	// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;
	
    document.getElementById('showAnswer').style.display ='none';
  //  shuffle(add_increment_base_const_power);

	console.log("stateAdmin_dat: " + stateAdmin_dat ); // stateAdmin_dat มีแล้ว ในไฟล์ data-for-realTest_law_exercise.js

     // เรียงตาม id ของตัวแปร ซึ่งมีเลขสุ่มอยู่ด้วย เช่น 25650508_RN4220_00_law_Pang_18 (4220 เป็นเลขสุ่มด้วย Excel)
      stateAdmin_dat = stateAdmin_dat.sort((a, b) => {
          if (a.id < b.id) {
          return -1;
          }
      });

    thisJson = stateAdmin_dat;
    current_page = thisLNumber;
    jsonName_id = "exMenu_stateAdmin_exer";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
    changePage(thisLNumber, false, thisJson);
    break;

// symblCon -> goodGov
case  "goodGov":

// alert("lastQstnArr inside case=normal: " + lastQstnArr)

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู goodGov
// https://stackoverflow.com/questions/4556099/how-do-you-search-an-array-for-a-substring-match
var thisNumDat = lastQstnArr.find(element => element.includes("exMenu_goodGov_law_exer"));
console.log("thisNumDat id ของ เมนู goodGov: " + thisNumDat);  // เช่น exMenu_goodGov_law_exerxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย
    //    alert("thisLNumber: " + thisLNumber);
	console.log("thisLNumber: " + thisLNumber);

// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;

	document.getElementById('showAnswer').style.display ='none';
    //	shuffle(sectmented);

    // เรียงตาม id
    goodGov_dat = goodGov_dat.sort((a, b) => {
        if (a.id < b.id) {
        return -1;
        }
    });

    thisJson = goodGov_dat;
    current_page = thisLNumber;
    jsonName_id = "exMenu_goodGov_law_exer";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
    changePage(thisLNumber, false, thisJson);
    break;

// ************* ถึงตรงนี้ เดี๊ยวค่อยมาต่อ *********************




case  "adminProcedure":

console.log("adminProcedure - lastQstnArr inside adminProcedure: " + lastQstnArr)

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู normal
var thisNumDat = lastQstnArr.find(element => element.includes("exMenu_adminProcedure_law_exer"));
console.log("adminProcedure - thisNumDat: " + thisNumDat);  // normal_cndtngxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย
        console.log("adminProcedure - thisLNumber: " + thisLNumber);

// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ

	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;
	document.getElementById('showAnswer').style.display ='none';
    //	shuffle(sectmented);

    // เรียงตาม id
    adminProcedure_dat = adminProcedure_dat.sort((a, b) => {
 //   goodGov_dat = goodGov_dat.sort((a, b) => {
        if (a.id < b.id) {
        return -1;
        }
    });

    thisJson = adminProcedure_dat;
    current_page = thisLNumber;
    jsonName_id = "exMenu_adminProcedure_law_exer";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
    changePage(thisLNumber, false, thisJson);
    break;


case  "allOfThemLaw":

 console.log("lastQstnArr : " + lastQstnArr)

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู fraction
var thisNumDat = lastQstnArr.find(element => element.includes("exMenu_allOfThemLaw_law_exer"));
//  alert("thisNumDat: " + thisNumDat);  // min_max_cndtngxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย
// alert("thisLNumber: " + thisLNumber);

  	    // clear input field
        // document.getElementById('myInput').value = '';
        	btn_pause.disabled = false;
        	btn_reset.disabled = false;
        	btn_start.disabled = false;
	    document.getElementById('showAnswer').style.display ='none';
 //       shuffle(accumulate);

      // เรียงตาม id
       allOfThemLaw_dat = allOfThemLaw_dat.sort((a, b) => {
           if (a.id < b.id) {
           return -1;
           }
       });

        thisJson = allOfThemLaw_dat;
        current_page = thisLNumber;
        jsonName_id = "exMenu_allOfThemLaw_law_exer";

        changePage(thisLNumber, false, thisJson);

    break;


case "remaining":

// alert("lastQstnArr : " + lastQstnArr)

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู multi_connection
var thisNumDat = lastQstnArr.find(element => element.includes("exMenu_remaining_law_exer"));
// alert("thisNumDat: " + thisNumDat);  // mixed_cndtngxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

    // document.getElementById('myInput').value = '';  // ลบที่พิมพ์คำตอบก่อนหน้านี้ ในช่อง input
	document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่

      // เรียงตาม id
       remaining_dat = remaining_dat.sort((a, b) => {
           if (a.id < b.id) {
           return -1;
           }
       });


 	thisJson = remaining_dat;
    current_page = thisLNumber;
	jsonName_id = "exMenu_remaining_law_exer";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล

    changePage(thisLNumber, false, thisJson);  // ส่งข้อมูลไปแสดง หน้า, ยังไม่เริ่มจับเวลา(เพราะเพิ่งเข้ามา), ไฟล์ข้อมูลที่เลือก


    break;



default:
  	// clear input field
//    // document.getElementById('myInput').value = '';
	document.getElementById('showAnswer').style.display ='none';
	 shuffle(allOfThemLaw_dat);
    thisJson =  allOfThemLaw_dat;
	current_page = 1;
    changePage(1, false, thisJson);
}
}

numOfQuestions = stateAdmin_dat.length + goodGov_dat.length + remaining_dat.length + adminProcedure_dat.length + allOfThemLaw_dat.length;
