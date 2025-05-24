
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

case "exponential_revisit":

    swipeEnabled = false;  // Set this to true to enable, false to disable
// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_pause.disabled = true;
	btn_reset.disabled = true;
	btn_start.disabled = true;
	resetCountDown();

	document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่ ถ้ามาจากหน้าที่มีเฉลย
    // ไฟล์ html อธิบายวิธีทำ ทั้งไฟล์เอามาใส่ในตัวแปรเลยตรง ๆ ถ้าจะแก้ ให้คัดลอก ไปแก้ใน editPlus เอา \n เพิ่มต่อจาก <br> เพื่อให้ขึ้นบรรทัดใหม่ และเวลาจะเอามาไว้ที่นี่ ให้ตัด \n ออกก่อน

    thisJson = "<!DOCTYPE html><html lang='th'> <head>    <meta charset='UTF-8'>    <meta name='viewport' content='width=device-width, initial-scale=1'>     <link rel='stylesheet' type='text/css' href='my_style.css'>    <link rel='stylesheet' type='text/css' href='symbol_cndtng_exercise.css'>	<style>table {border-collapse: collapse; border-spacing: 0; width: 100%;border: 1px solid #ddd;} tr:nth-child(even) {background-color: #B2BEB5;}  tr:nth-child(odd) {background-color: #A9A9A9;}.fraction {  display: inline-block;  position: relative;  vertical-align: middle;   letter-spacing: 0.001em;  text-align: center;  font-size: 12px;  }.fraction > span {   display: block;   padding: 0.1em;   }.fraction span.fdn {border-top: thin solid black;}.fraction span.bar {display: none;}    body {        font-size: 16px;    }/* ให้เส้นคั่น ห่างจากขอบซ้าย นิดนึง*/ hr{margin-left:30;} .equal-width td { width: 50%; } ol{  padding-left:15px;}/* Second Level */ol ol{  padding-left:17px;}/* Third Level */ol ol ol{  padding-left:18px;}ul{  padding-left:15px;}/* Second Level */ul ul{  padding-left:17px;}/* Third Level */ul ul ul{  padding-left:18px;}</style>  <title>how_to</title> </head> <body><div id='how_to' style='display: block; text-align: left; margin-top: 15px; padding: 3px'>    <p>        <strong>เลขยกกำลัง</strong> คือการคูณซ้ำ ๆ กัน เช่น<br>        2 <sup>5</sup> = 2 x 2 x 2 x 2 x 2 (สอง คูณกัน 5 ครั้ง)<br>        3 <sup>5</sup> = 3 x 3 x 3 x 3 x 3 (สาม คูณกัน 5 ครั้ง)<br>        ตัวเลขที่เอาไปคูณกัน เราเรียกว่า ฐาน <br>และตัวเลขที่แสดงจำนวนครั้งที่คูณกัน เราเรียกว่า เลขยกกำลัง<br><br>        เวลาอยู่ในห้องสอบ ถ้าจำสูตรเรื่องเลขยกกำลังไม่ได้ ก็ ใช้วิธีกระจาย คูณกันดู แต่ต้องมีเวลาเหลือด้วย เพราะจะใช้เวลาหน่อย<br><br>    <table>        <tr><th><strong>กฎของเลขยกกำลัง</strong></th></tr>        <tr><td>เลขใด ๆ ก็ตามที่ไม่ใช่เลข ศูนย์ เมื่อยกกำลังด้วยเลข ศูนย์ จะมีค่าเท่ากับ 1 เสมอ<br> a<sup>0</sup> = 1 <br><br>ตัวอย่าง<br> 15<sup>0</sup> = 1 <br>            สรุปว่า เลขอะไรก็ตามที่ไม่ใช่เลขศูนย์ ถ้ายกกำลังด้วยเลข 0 จะได้เท่ากับ 1 เสมอ<br>อันนี้ต้องจำให้แม่น</td></tr>  	<tr><td>เลขยกกำลังที่เท่ากันและมีฐานเท่ากัน เลขยกกำลังก็จะเท่ากันด้วย<br>		5<sup>X</sup> = 5<sup>3</sup><br>		X = 3  หรือ<br>		5<sup>X</sup> = 125<br>		จัด 125 ให้อยู่ในรูปเลขยกกำลัง<br>		125 = 5×5×5 = 5<sup>3</sup><br>		ดังนั้น<br>		5<sup>X</sup> = 5<sup>3</sup><br>		X = 3<br>		</td></tr>	<tr><td>เลขยกกำลังที่เท่ากันและมีเลขยกกำลังเท่ากัน เลขฐานก็จะเท่ากันด้วย<br>	X<sup>3</sup> = 5<sup>3</sup><br>		X = 5 หรือ<br>		X<sup>3</sup> = 125<br>		จัด 125 ให้อยู่ในรูปเลขยกกำลัง<br>		125 = 5×5×5 = 5<sup>3</sup><br>		ดังนั้น<br>		X<sup>3</sup> = 5<sup>3</sup><br>		X = 5<br>		</td></tr>		<tr><td>a<sup>-n</sup> = <span class='frac'>1<span class='symbol'>/</span><span class='bottom'>a<sup>n</sup></span></span>            <br>การเปลี่ยนเลขยกกำลังที่ติดลบให้เป็นบวก ทำได้โดยการสลับตำแหน่งของเลขฐาน จากเศษเป็นส่วน หรือ จากส่วนเป็นเศษ  เช่น<br>            a<sup>-n</sup> ทำเลขยกกำลังให้เป็นบวก ได้ <span class='frac'>1<span class='symbol'>/</span><span class='bottom'>a<sup>n</sup></span></span><br>หรือ<br>            <span class='frac'>1<span class='symbol'>/</span><span class='bottom'>a<sup>-n</sup></span></span> ทำเลขยกกำลังให้เป็นบวก ได้ a<sup>n</sup> เป็นต้น            <br>            เลขยกกำลังติดลบ เคยมีออกในข้อสอบ กพ ด้วย            <br><br>ตัวอย่าง<br>จงหาค่าของ <span class='frac'>1<span class='symbol'>/</span><span class='bottom'>2<sup>-3</sup></span></span><br>            วิธีทำ ให้กลับ  เลข 2 จากเศษ เปลียนเครื่องหมายเลขยกกำลัง จาก ลบ เป็นบวก<br>            <span class='frac'>1<span class='symbol'>/</span><span class='bottom'>2<sup>-3</sup></span></span>  =            2<sup>3</sup> = 2 x 2 x 2  = 8 <br><br>            อีกตัวอย่าง<br><br>            จงหาค่าของ 2<sup>-3</sup> <br>            ให้กลับ 2 เป็น เศษ 1 ส่วน 2 และกลับเครื่องหมายเลขยกกำลัง เป็นตรงข้าม จะได้เป็น<br>            2<sup>-3</sup> = <span class='frac'>1<span class='symbol'>/</span><span class='bottom'>2<sup>3</sup></span></span> =            <span class='frac'>1<span class='symbol'>/</span><span class='bottom'>2 x 2 x 2</span></span> =            <span class='frac'>1<span class='symbol'>/</span><span class='bottom'>8</span></span>        </td></tr>        <tr><td><br>ถ้าเลขยกกำลังเป็นเศษส่วน เศษคือเลขชี้กำลังของเลขฐาน และส่วนคือรูทของเลขฐาน เช่น <br><br>            4<sup>1/2</sup></sup> = รูท 2 ของ 4 กำลัง 1 คือ <span style='white-space: nowrap; font-size:larger'>&#8730;<span style='text-decoration:overline;'>&nbsp;4&nbsp;</span></span> =            <span style='white-space: nowrap; font-size:larger'>&#8730;<span style='text-decoration:overline;'>&nbsp;2 x 2 &nbsp;</span></span> = 2<br><br>            64<sup>2/3</sup></sup> = รูท 3 ของ 64 ยกกำลังสอง คือ <span style='white-space: nowrap; font-size:larger'>&#8731;<span style='text-decoration:overline;'>&nbsp;64<sup>2</sup>sup>&nbsp;</span></span> =            <span style='white-space: nowrap; font-size:larger'>&#8731;<span style='text-decoration:overline;'>&nbsp;4<sup>2</sup> x 4<sup>2</sup> x 4<sup>2</sup>&nbsp;</span></span> = 4<sup>2</sup> = 16        </td></tr>        <tr><td>เลขยกกำลังที่มีฐานเดียวกัน เมื่อคูณกัน ให้เอากำลังมาบวกกัน            <br>a<sup>m</sup> x a<sup>n</sup> = a<sup>(m+n)</sup><br>            ข้อสังเกตคือ เลขฐาน ต้องเป็นเลขเดียวกัน เมื่อคูณกัน จึงจะเอากำลังมาบวกกันได้ <br><br>ตัวอย่าง<br>            2 <sup>2</sup> x 2 <sup>3</sup> = 2 <sup>(2 +3)</sup> = 2 <sup>5</sup> = 2 x 2 x 2 x 2 x 2 = 32 </td></tr>        <tr><td>เลขยกกำลังที่มีฐานเดียวกัน เมื่อหารกัน ให้เอากำลังมาลบกัน<br>            <span class='frac'>a<sup>m</sup><span class='symbol'>/</span><span class='bottom'>a<sup>n</sup></span></span> = a<sup>(m-n)</sup> <br>การหารกัน มักจะเขียนในรูปเศษส่วน คือ ส่วนเป็นตัวหารนั่นเอง<br><br>ตัวอย่าง<br>            <span class='frac'>2<sup>5</sup><span class='symbol'>/</span><span class='bottom'>2<sup>3</sup></span></span> = 2<sup>(5-3)</sup> = 2<sup>2</sup> = 2 x 2 = 4<br>        </td></tr>        <tr><td>เลขยกกำลังที่อยู่นอกวงเล็บ สามารถคูณเข้าไปในวงเล็บได้ เช่น <br>(a<sup>m</sup>)<sup>n</sup> = a <sup>(m x n)</sup><br><br>ตัวอย่าง<br>            (2<sup>2</sup>)<sup>3</sup> = 2 <sup>(2 x 3)</sup> =  2 <sup>(6)</sup> = 2 x 2 x 2 x 2 x 2 x 2 = 64        </td></tr>        <tr><td>เลขยกกำลังที่อยู่นอกวงเล็บ สามารถคูณเข้าไปในวงเล็บได้ ถ้าในวงเล็บมีเลขหลายจำนวน ที่คูณกันอยู่ ให้คูณทุกจำนวนด้วย (แต่ถ้าตัวเลขพวกนั้น บวก หรือ ลบ กัน ห้ามคูณกำลังเข้าไปเด็ดขาด) เช่น<br>(a x b)<sup>m</sup> = a<sup>m</sup> x b<sup>m</sup>            <br><br>ตัวอย่าง<br>            (2 x 3)<sup>3</sup> = 2<sup>3</sup> x 3<sup>3</sup> = (2 x 2 x 2) x (3 x 3 x 3) = 8 x 27 = 216 <br><br>            แต่ถ้า a บวกกับ b  หรือ a ลบกับ b และทั้งหมดยกกำลัง m เช่น (a + b)<sup>m</sup> <br> อย่างนี้ กระจายกำลังเข้าไปไม่ได้นะครับ  คือ<br>            (a + b)<sup>m</sup> จะไม่เท่ากับ a<sup>m</sup> + b<sup>m</sup>  นะครับ <br>            ลองคิดเล่น ๆ ดูก็ได้ <br>            (2 + 3)<sup>2</sup> = 5<sup>2</sup> = 5 x 5 = 25 <br>            (2)<sup>2</sup> + (3)<sup>2</sup> = (2 x 2) + (3 x 3) = 4 + 9 = 13<br>        </td></tr>        <tr><td>เลขยกกำลังที่อยู่นอกวงเล็บ สามารถคูณเข้าไปในวงเล็บได้ ถ้าในวงเล็บเป็นเศษส่วน ให้คูณทั้งเศษและส่วน และถ้ามีหลายจำนวนคูณกันอยู่ ก็ให้คูณทุกจำนวนด้วย (แต่ถ้าตัวเลขเศษส่วนพวกนั้น บวก หรือ ลบ กัน ห้ามคูณกำลังเข้าไปเด็ดขาด) เช่น<br>(<span class='frac'>a<span class='symbol'>/</span><span class='bottom'>b</span></span>)<sup>m</sup> = (<span class='frac'>a<sup>m</sup><span class='symbol'>/</span><span class='bottom'>b<sup>m</sup></span></span>)            <br><br>ตัวอย่าง<br> (<span class='frac'>3<span class='symbol'>/</span><span class='bottom'>4</span></span>)<sup>2</sup> = (<span class='frac'>3<sup>2</sup><span class='symbol'>/</span><span class='bottom'>4<sup>2</sup></span></span>)  =            <span class='frac'>3 x 3<span class='symbol'>/</span><span class='bottom'>4 x 4 </span></span> =            <span class='frac'>9<span class='symbol'>/</span><span class='bottom'>16</span></span>        </td></tr>    </table>    <br /><br />    <strong>แนวทางการหาคำตอบ</strong><br>    <ol>        <li>ถ้าเลขตัวชี้ยกกำลัง มีค่าเป็นลบ ให้ทำเป็นบวก เสียก่อน โดยการสลับตำแหน่งของเลขฐาน จาก เศษเป็นส่วน หรือจากส่วนเป็นเศษ ตัวเลขชี้กำลังจะเป็นตรงข้าม คือเป็นบวก นั่นเอง เช่น<br> 3<sup>-2</sup> เปลี่ยนเป็น <span class='frac'>1<span class='symbol'>/</span><span class='bottom'>3<sup>2</sup></span></span></li>        <li><strong>ทำฐานให้เท่ากัน</strong> หลักการคือเมื่อทำฐานทั้งสองข้างได้เท่ากันแล้ว จะได้ว่าเลขชี้กำลังของทั้งสองข้างต้องเท่ากันด้วย        </li>        <li> <strong>ทำเลขชี้กำลังให้เท่ากัน</strong>            <ol>                <li>ถ้าเลขชี้กำลังเท่ากัน แต่เลขฐานไม่เท่ากัน เลขฐานที่มากกว่า ย่อมมีค่ามากกว่า เช่น<br>                    จำนวนใด มีค่ามากกว่า ระหว่าง 3<sup>60</sup> และ  18<sup>20</sup><br>                    จะเห็นว่า เราทำเลขชี้กำลังให้เท่ากันได้ คือ<br>                    3<sup>60</sup> = 3<sup>3 x 20</sup> = (3<sup>3</sup> )<sup>20</sup><br>                    18<sup>20</sup> = 18<sup>1 x 20</sup> = (18<sup>1</sup> )<sup>20</sup><br>                    (3<sup>3</sup>) = 3x3x3 = 27<br>                    (18<sup>1</sup>) = 18<br>                    ดังนั้น 3<sup>60</sup> มากกว่า 18<sup>20</sup>                </li>                <li>เมื่อเลขชี้กำลังทั้งสองข้างเท่ากัน แต่ฐานกลับไม่เท่ากัน จะสรุปได้ว่า เลขชี้กำลัง มีค่าเท่ากับ 0 เพราะ เลขอะไรยกกำลังด้วย 0 จะได้เท่ากับ 1 จึงเท่ากัน เช่น<br>                    จงหาว่า a มีค่าเท่ากับเท่าไร<br>                    24<sup>(a-2)</sup> = 53<sup>(2a-4)</sup><br>                    (2a-4) = 2(a-2)  (ดึงตัวร่วมกันออกมานอกวงเล็บ)<br>                    24<sup>(a-2)</sup> = 53<sup>(2)(a-2)</sup><br>                    24<sup>(a-2)</sup> =( 53<sup>2</sup>)<sup>(a-2)</sup><br>                    ดังนั้น <br>                    a - 2 = 0<br>                    a = 2                </li>            </ol>        </li>    </ol></div>  <!-- end of how to  --> </body></html>";
   show_how_to(1, false, thisJson);  // แสดงหน้าคำอธิบาย
 
 
    break;

case  "everything_in_json":

var thisNumDat = lastQstnArr.find(element => element.includes("everything_in_json"));


console.log("thisNumDat for everything_in_json in changeData: " + thisNumDat);  // normal_cndtngxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

console.log("lastQstnArr from Flutter - เงื่อนไข: " + lastQstnArr);
console.log("thisNumDat แยกจาก lastQstnArr from Flutter - เงื่อนไข: " + thisNumDat);
console.log("thisLNumber ที่ส่งเข้ามากับ lastQstnArr จาก Flutter - เงื่อนไข: " + thisLNumber);


// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ

	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;
  	// clear input field
    // document.getElementById('myInput').value = '';
	document.getElementById('showAnswer').style.display ='none';
    //	shuffle(normal_cndtng);

	thisJson = myOperate_expnt;
    //thisJson = normal_cndtng;
    current_page = thisLNumber;
    jsonName_id = "exMenu_everything_in_json";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
    changePage(thisLNumber, false, thisJson);

    break;


case "negative_exponent":

// alert("lastQstnArr : " + lastQstnArr)

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู fraction
var thisNumDat = lastQstnArr.find(element => element.includes("negative_exponent"));
// alert("thisNumDat: " + thisNumDat);  // fraction_cndtngxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย


  	// clear input field
    // document.getElementById('myInput').value = '';
	// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;
    document.getElementById('showAnswer').style.display ='none';
  //  shuffle(add_increment_base_const_power);

     thisJson = neg_exp;
    current_page = thisLNumber;
    jsonName_id = "exMenu_negative_exponent";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
    changePage(thisLNumber, false, thisJson);
 
    break;
case  "fraction_expnt":

	console.log("lastQstnArr in accumulate: " + lastQstnArr);

// alert("lastQstnArr : " + lastQstnArr)

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู fraction
var thisNumDat = lastQstnArr.find(element => element.includes("fraction_expnt"));
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
        thisJson = fract_expnt;
        current_page = thisLNumber;
        jsonName_id = "exMenu_fraction_expnt";

        changePage(thisLNumber, false, thisJson);

    break;

	case  "others_expnt":
// alert("lastQstnArr : " + lastQstnArr)

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู multi_connection
var thisNumDat = lastQstnArr.find(element => element.includes("others_expnt"));
// alert("thisNumDat: " + thisNumDat);  // multi_connection_cndtngxyz1
var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย


 	// clear input field
  	    document.getElementById('showAnswer').style.display ='none';
       // shuffle(alternate_plus_multiply);
        thisJson = othrs_expnt;
        current_page = thisLNumber;
        jsonName_id = "exMenu_others_expnt";

        changePage(thisLNumber, false, thisJson)

    break;

default:

	document.getElementById('showAnswer').style.display ='none';
	shuffle(myOperate);
    thisJson =  myOperate;
	current_page = 1;
    changePage(1, false, thisJson);
}
}

numOfQuestions = (myOperate_expnt.length + fract_expnt.length + neg_exp.length + othrs_expnt.length); 
console.log("numOfQuestions: " + numOfQuestions);