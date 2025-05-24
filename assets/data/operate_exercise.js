
var current_page_Array_from_Flutter = [0,0,0,0,0,0,0,0,0,0,0]; //สำหรับรับค่าหน้าที่ทำสุดท้าย ซึ่งเก็บไว้ใน SharePref และส่งมา JS จาก Fluttr


function changeData(myJason){


console.log("enter changeData");






if (typeof lastQstnArr === 'undefined') {
console.log("lastQstnArr is undefined. Menu: " + myJason);

}

 swipeEnabled = true; // enable swipe
console.log("swp swipeEnabled in changeData: " + swipeEnabled);
console.log("current_page in changeData: " + current_page);

switch (myJason) {

case "how_to_page":
console.log("enter changeData -> how to page");
 swipeEnabled = false; // enable swipe
// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_pause.disabled = true;
	btn_reset.disabled = true;
	btn_start.disabled = true;
	resetCountDown();

	document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่ ถ้ามาจากหน้าที่มีเฉลย
    // ไฟล์ html อธิบายวิธีทำ ทั้งไฟล์เอามาใส่ในตัวแปรเลยตรง ๆ ถ้าจะแก้ ให้คัดลอก ไปแก้ใน editPlus เอา \n เพิ่มต่อจาก <br> เพื่อให้ขึ้นบรรทัดใหม่ และเวลาจะเอามาไว้ที่นี่ ให้ตัด \n ออกก่อน

	thisJason = "<!doctype html><html lang='th'><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1'><link rel='stylesheet' type='text/css' href='operate_exercise.css'><link rel='stylesheet' type='text/css' href='my_style.css'><style>        body {            font-size: 18px;}</style>  <title>operate exercise</title> </head> <body> <div style='text-align: left; padding-left: 8px; padding-right: 3px'>       <strong>โอเปอเรต (operate)</strong><br>		เป็นการใช้วิธีการทางคณิตศาสตร์กับตัวเลข 2 จำนวน เพื่อให้ได้คำตอบตามที่กำหนด โดยวิธี บวก ลบ คูณ หาร ยกกำลัง หรืออาจจะมีการใช้การถอดรูท ร่วมด้วย เช่น<br><br>        5 * 2 = 27<br>        เลข 5 ทำอะไร (โอเปอเรต) กับเลข 2 แล้วได้เป็น 27<br>		คำตอบ<br>		(5 - 2) x 9 		หรือสรุปเป็นสูตรได้ว่า<br>		(หน้า - หลัง) คูณด้วย 9<br>		เป็นต้น<br><br>ข้อแนะนำทั่วไปในการหาสูตรคำตอบ<br><br>-ให้ถือว่าตัวเลขหลังหรือ ผลลัพธ์ = คือเป้าหมาย<br>-ให้ เอาเลข หน้าเครื่องหมาย = มา บวก ลบ คูณ หาร กัน เพื่อหาข้อมูลดิบ ที่จะเอามากระทำกัน (บวก ลบ คูณ หาร ยกกำลัง) ให้ได้ เป้าหมาย เพื่อหาสูตร<br><br>ตัวอย่าง<br><br>ถ้า 10 * 6 = 8 และ 4 * 4 = 4 แล้ว  10 * 12 เท่ากับเท่าใด<br><br>          10 * 6 = 8 <br />          เป้าหมายคือ 8<br /><br>        หาข้อมูลดิบ<br>          10 + 6 = 16<br />          10 - 6 = 4<br />          10 x 6 = 60<br />        ยกกำลังไม่ต้องทำ เพราะเป้าหมาย เป็นตัวเลขไม่มาก<br />        หาร ก็ไม่ต้องทำ เพราะ หารไม่ลงตัว<br /><br />          ลองดูข้อมูลดิบกับ เป้าหมาย จะเห็นว่า<br />       ข้อมูลดิบ คือ 16, 4, 60 <br />        ตัวที่ใกล้กับ 8 คือ 16 กับ 4 <br /><br />        ถ้าเอา 2 มาหาร 16 ก็จะได้ 8 <br />        ถ้าเอา 2 มาคูณ 4 ก็จะได้ 8 เหมือนกัน <br /><br />        2 มาจากไหน ก็บอกว่า เป็นตัวเลขที่เอามาเฉย ๆ เพื่อให้ได้ตามเป้าหมาย <br />        ตัวเลขที่ยกมาเฉย ๆ นี่ ตอนหลัง ๆ ก.พ. ชอบเอามาใช้ <br /><br />        ถ้ากรณีนี้ เราจะได้สูตรว่า  <br /> <br />          16 &#xf7; 2 = 8 (หน้า + หลัง แล้วหารด้วย 2 )  --- (สูตร 1)<br />          4 x 2 = 8 (หน้า - หลัง แล้วคูณด้วย 2 )  --- (สูตร 2)<br /><br />          ลองใช้ สูตร 1 กับข้อมูลอีกชุด<br />          4 * 4 = 4<br />          (หน้า + หลัง แล้วหารด้วย 2 )<br />          (4 + 4)  &#xf7; 2 = 4<br /><br />          สูตรที่ 1 ใช้ได้<br /><br />          นำไปหาคำตอบ<br />          10 * 12 = ?<br />          (หน้า + หลัง แล้วหารด้วย 2 )<br />          (10 + 12)  &#xf7; 2 = 11<br /><br />ลองดูอีกตัวอย่าง<br><br>ถ้า 5 * 2 = 27 และ 3 * 6 = -27 แล้ว  2 * 4 = ? เท่ากับเท่าใด<br><br>5 * 2 = 27<br>เป้าหมายคือ 27<br><br>หาข้อมูลดิบ <br> <br>2 + 5 = 7<br>2 - 5 = -3<br>5 - 2 = 3<br>2 x 5 = 10<br>ส่วนหารไม่ต้องเพราะหารไม่ลงตัว<br><br>จากข้อมูลดิบที่ได้ คือ 7,-3, 3 และ  10 เลขที่สามารถทำให้เหมือนเป้าหมาย(27) ได้ง่าย คือ เลข 3 เพราะ<br>เลข 3 ทำให้ได้ 27 ได้ โดย 3 x 9 = 27 หรือ อาจจะยกกำลัง สาม ได้ คือ 3<sup>3</sup> = 27<br><br>เลข 3 ได้มาจาก  เลขตัวหน้า - เลขตัวหลัง <br>จึงสรุปได้ 2 สูตรว่า<br><br>(เลขตัวหน้า - เลขตัวหลัง)<sup>3</sup>  ---- (1)<br>(เลขตัวหน้า - เลขตัวหลัง) x 9  ---- (2)<br><br>ลองเอาสูตร (1) ไปใช้กับตัวเลขอีกชุด คือ<br><br> 3 * 6 = -27<br> (3 - 6)<sup>3</sup> = (-3)(-3)(-3) = -27<br> สรุปว่า สูตรนี้ใช้ได้<br><br>ดังนั้น คำตอบ ของ 2 * 4 = ? คือ <br>(2 - 4)<sup>3</sup> = (-2)(-2)(-2) = -8<br><br>        สรุปโดยหลัก ๆ แล้ว วิธีการหาคำตอบ มักจะหาได้ โดยวิธีต่อไปนี้ คือ        <ol>        <li><strong>เลขตัวหน้า ทำ (operate บวก ลบ คูณ หาร ยกกำลัง หรือ ถอดรูท) กับเลขตัวหลัง</strong> แล้วอาจจะมีการทำ (operate) เพิ่ม คือ อาจจะเอาเลขตัวหน้า หรือตัวหลัง มา บวก ลบ คูณ หาร เพิ่ม หรือ อาจจะเอาเลขอะไรสักตัว (เรียกว่าเป็นค่าคงที่) มา บวก ลบ คูณ หาร หรือ ยกกำลัง อีกที ก็ได้ เช่น <br>            10 * 5 = 20<br>            ตัวหน้า + ตัวหลัง แล้ว เอาตัวหลังมาบวกอีกที <br>            (10 + 5) + 5 = 20<br><br>            10 * 5 = 21<br>            ตัวหน้า + ตัวหลัง แล้ว เอาค่าคงที่มาบวกเพิ่ม คือ เลข 6  <br>            ทำไมจึงต้องเป็นเลข 6 ตรงนี้ ก็ใช้ไหวพริบ หรือความสังเกตเอา ซึ่งจะเห็นว่า 5+10 ได้ 15 ยังขาดอีก 6 ถึงจะเป็น 20 ก็เลยเอาเลข 6 มาบวกอีกที <br>หรือถ้าให้เป็นแบบแผน ก็ต้องว่า เอาผลลัพธ์ที่ได้ ไปเปรียบเทียบกับผลที่โจทย์กำหนดมาให้ <br>            15 * 5 = 20<br>            ตัวหน้า ลบด้วยตัวหลัง และมีทำเพิ่มคือ เอา 2 คูณ<br>            (15 - 5) x 2 = 20<br><br>            8 * 5 = 9 (ข้อสอบเสมือนจริง 62)<br>            ตัวหน้า ลบด้วยตัวหลัง และมีทำเพิ่มคือ เอาผลที่ได้มายกกำลังสอง<br>            (8 - 5) = 3;  3<sup>2</sup> = 9<br>หรือ (8 - 5)<sup>2</sup> =9 <br><br>            3 * 2 = 8<br>            ตัวหลัง ยกกำลังด้วยตัวหน้า<br>            2<sup>3</sup> = 8<br>            แต่ก็ยังมีวิธีการอื่น ๆ ได้อีก เช่น ตัวหน้าคูณด้วย2 แล้วบวกด้วยตัวหลัง เช่น<br>            (3 x 2) + 2 = 8<br>            ส่วนว่า จะใช้วิธีไหน ก็ต้องเอาไปลองกับชุดที่ 2 ดูว่า ได้คำตอบเหมือนที่กำหนดมาให้หรือไม่<br><br>        </li>    <li>    <strong>เลขตัวหน้า (หรือตัวหลัง) ทำ (operate เช่น ยกกำลังสอง หรือคูณด้วยเลขใดเลขหนึ่ง) กับตัวเองก่อน</strong> แล้วจึงไปทำกับตัวหลัง (หรือตัวหน้า) ซึ่งอาจจะมีการทำ (operate) กับตัวเองก่อนหรือไม่ทำก็ได้ แล้วก็อาจจะมีเพิ่มเหมือนในข้อที่แล้ว ตัวอย่าง เช่น <br>    10 * 5 = 25<br>    ตัวหน้าคูณด้วย 2 ก่อน แล้วจึงเอาตัวหลัง มาบวกเพิ่ม<br>    (10 x 2) + 5 = 20<br><br>    5 * 6 = 31<br>    ตัวหน้ายกกำลังสอง แล้วมาบวกกับตัวหลังที่คูณด้วย 2<br>    5<sup>2</sup> + (3 x 2) = 31<br><br>    6 * 5 = 60<br>    ตัวหน้ายกกำลังสอง บวกกับตัวหลังยกกำลังสอง แล้วมีเพิ่มคือ เอา 1 มาลบออก<br>    (6<sup>2</sup> + 5<sup>2</sup>) - 1 = 60<br><br>    36 * 25 = 10<br>    รูท2ของตัวหน้า + รูท2ของตัวหลัง แล้วมีทำเพิ่ม คือ ลบด้วย 1    </li>	<li>ช่วงหลัง ๆ เช่น ในปี 2566 มีการเอาตัวเลขภายนอกเข้ามาเกี่ยวข้องด้วย เช่น <br>	หน้า + หลัง แล้ว บวกเพิ่มอีก 3<br>	หน้า + หลัง แล้ว บวกเพิ่มอีก 5<br>	หน้า - หลัง แล้ว บวกเพิ่มอีก 5<br>	หน้า - หลัง แล้ว ลบออกอีก 2 เป็นต้น<br>	ทั้งนี้ ให้ดูผลที่เราเอา ตัวเลขหน้า และ หลัง มา บวก ลบ คูณ หาร กัน แล้วเปรียบเทียบกับเป้าหมาย เช่น ถ้าขาดอยู่นิดหน่อย อาจจะมีการเอาตัวเลขข้างนอก หรือ ค่าคงที่ มา เกี่ยวข้องด้วย	</li></ol>    <p>ต่อไปนี้ เป็นรูปแบบตัวอย่าง วิธีคิด ในการหาคำตอบ</p>    <ol>        <li>(หน้า + หลัง) + หน้า(หรือหลัง)</li>        <li>(หน้า + หลัง) - หน้า(หรือหลัง)</li>        <li>(หน้า + หลัง) x 2) + หน้า(หรือหลัง)</li>        <li>(หน้า + หลัง) x 2) - หลัง(หรือหลัง)</li>        <li>(หน้า + หลัง) + ค่าคงที่ เช่น 2 หรือ 3 หรือ 4  หรือ ...</li>        <li>(หน้า + หลัง) - ค่าคงที่ เช่น 2 หรือ 3 หรือ 4  หรือ ...</li>        <li>(หน้า x หลัง) + หน้า(หรือหลัง) <br>-- ข้อสังเกตคือ ผลลัพธ์มักจะค่อนข้างมาก และ เลขหน้าหรือหลัง ตัวใดตัวหนึ่งมีค่าไม่มาก เพราะต้องเอาไปคูณกับอีกตัวหนึ่ง</li>        <li>(หน้า x หลัง) - หน้า(หรือหลัง)</li>        <li>(หน้า x ค่าคงที่ เช่น 2 หรือ 3) + หน้า(หรือหลัง) <br>-- ข้อสังเกตคือ ผลลัพธ์มักจะค่อนข้างมาก เพราะมีการคูณ</li>        <li>(หน้า x ค่าคงที่ เช่น 2 หรือ 3) - หน้า(หรือหลัง)</li>        <li>(หน้า x หลัง) + ค่าคงที่ เช่น 2 หรือ 3 หรือ 4  หรือ ...</li>        <li>(หน้า x หลัง) - ค่าคงที่ เช่น 2 หรือ 3 หรือ 4  หรือ ...</li>        <li>(หน้า - หลัง) + หน้า(หรือหลัง) <br>-- ข้อสังเกตคือ เลขตัวหน้าต้องมากกว่าเลขตัวหลัง</li>        <li>(หน้า - หลัง) - หน้า(หรือหลัง) <br>-- ข้อสังเกตคือ เลขตัวหน้าต้องมากกว่าเลขตัวหลัง</li>        <li>(หน้า - หลัง) + ค่าคงที่ เช่น 2 หรือ 3 หรือ 4  หรือ ... <br>-- ข้อสังเกตคือ เลขตัวหน้าต้องมากกว่าเลขตัวหลัง</li>        <li>(หน้า - หลัง) - ค่าคงที่ เช่น 2 หรือ 3 หรือ 4  หรือ ... <br>-- ข้อสังเกตคือ เลขตัวหน้าต้องมากกว่าเลขตัวหลัง</li>        <li>(หน้า)<sup>2</sup> + (หลัง) </br>--ข้อสังเกตคือ ผลลัพธ์จะค่อนข้างมาก</li>        <li>(หน้า)<sup>2</sup> - (หลัง)</li>        <li>(หน้า)<sup>2</sup> x (หลัง) <br>-- ข้อสังเกตคือ ตัวหน้าและตัวหลัง มักจะเป็นเลขไม่มาก ผลลัพธ์จะค่อนข้างมาก</li>        <li>(หน้า) + (หลัง)<sup>2</sup></li>        <li>(หน้า)<sup>2</sup> + (หลัง)<sup>2</sup> <br>-- ข้อสังเกตคือ ผลลัพธ์จะมีค่ามาก</li>        <li>(หน้า + หลัง)<sup>2</sup> <br>-- ข้อสังเกตคือ ผลลัพธ์จะมีค่ามาก</li>        <li>รูท2ของตัวหน้า + ตัวหลัง <br>-- ข้อสังเกตคือ เลขตัวหน้าสามารถถอดรูทได้ เช่น เลข 4, 9, 16, 25, 36, 49, 64, 81, 121 เป็นต้น</li>        <li>ตัวหน้า + รูท2ของตัวหลัง <br>-- ข้อสังเกตคือ ตัวหลังถอดรูทได้</li>        <li>เป็นต้น</li>    </ol></p><br /><br /></div> </div><!-- end of id='page_how_to'  --></body></html> ";

     show_how_to(1, false, thisJason);
    
    break;
case "exercise_1":

var thisNumDat = lastQstnArr.find(element => element.includes("exercise_1"));
console.log("thisNumDat for fraction in changeData: " + thisNumDat);  // normal_cndtngxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

console.log("lastQstnArr from Flutter - โอเปอเรต: " + lastQstnArr);
console.log("thisNumDat แยกจาก lastQstnArr from Flutter - โอเปอเรต: " + thisNumDat);
console.log("thisLNumber ที่ส่งเข้ามากับ lastQstnArr จาก Flutter - โอเปอเรต: " + thisLNumber);


// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ

	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;
	document.getElementById('showAnswer').style.display ='none';


	current_page = thisLNumber;
	thisJson =  operate_exercise_1;  // เศษส่วน
	jsonName_id = "exMenu_exercise_1"; // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
    changePage(thisLNumber, false, thisJson);  
    //doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน

    break;



case "exercise_2":

var thisNumDat = lastQstnArr.find(element => element.includes("exercise_2"));
console.log("thisNumDat for fraction in changeData: " + thisNumDat);  // normal_cndtngxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

console.log("lastQstnArr from Flutter -โอเปอเรต : " + lastQstnArr);
console.log("thisNumDat แยกจาก lastQstnArr from Flutter - โอเปอเรต: " + thisNumDat);
console.log("thisLNumber ที่ส่งเข้ามากับ lastQstnArr จาก Flutter - โอเปอเรต: " + thisLNumber);


// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ

	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;
	document.getElementById('showAnswer').style.display ='none';
	current_page = thisLNumber;
	thisJson =  operate_exercise_2;  // เศษส่วน
	jsonName_id = "exMenu_exercise_2"; // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
    changePage(thisLNumber, false, thisJson);  
    //doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;


case "exercise_all":

var thisNumDat = lastQstnArr.find(element => element.includes("exercise_all"));
console.log("thisNumDat for fraction in changeData: " + thisNumDat);  // normal_cndtngxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

console.log("lastQstnArr from Flutter - โอเปอเรต: " + lastQstnArr);
console.log("thisNumDat แยกจาก lastQstnArr from Flutter - โอเปอเรต: " + thisNumDat);
console.log("thisLNumber ที่ส่งเข้ามากับ lastQstnArr จาก Flutter - โอเปอเรต: " + thisLNumber);


// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ

	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;
	document.getElementById('showAnswer').style.display ='none';
	current_page = thisLNumber;
	thisJson =  myOperateAll;  // เศษส่วน
	jsonName_id = "exMenu_exercise_2"; // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
    changePage(thisLNumber, false, thisJson);  
    //doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;

default:
	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;  
	document.getElementById('showAnswer').style.display ='none'; // ซ่อนเฉลย
	// shuffle(objJsonSimple);
    thisJson =  myOperateAll;
	current_page = 1;
	 jsonName_id = "exMenu_exercise_all";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
    changePage(1, false, thisJson);
}
}

numOfQuestions = (myOperateAll.length + operate_exercise_1.length + operate_exercise_2.length);  // 
console.log("numOfQuestions: " + numOfQuestions);

