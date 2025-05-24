
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



 swipeEnabled = true; // enable swipe
console.log("swp swipeEnabled in changeData: " + swipeEnabled);
console.log("current_page in changeData: " + current_page);

switch (myJason) {

case "how_to_page":

 swipeEnabled = false; // enable swipe
// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_pause.disabled = true;
	btn_reset.disabled = true;
	btn_start.disabled = true;
	resetCountDown();

	document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่ ถ้ามาจากหน้าที่มีเฉลย
    // ไฟล์ html อธิบายวิธีทำ ทั้งไฟล์เอามาใส่ในตัวแปรเลยตรง ๆ ถ้าจะแก้ ให้คัดลอก ไปแก้ใน editPlus เอา \n เพิ่มต่อจาก <br> เพื่อให้ขึ้นบรรทัดใหม่ และเวลาจะเอามาไว้ที่นี่ ให้ตัด \n ออกก่อน
   // thisJson ="<!DOCTYPE html><html lang='th'> <head>    <meta charset='UTF-8'>    <meta name='viewport' content='width=device-width, initial-scale=1'>     <link rel='stylesheet' type='text/css' href='my_style.css'> <title>intro_page</title> </head>  <body> <h3>เทคนิคการทำข้อสอบตาราง</h3><div  style='display: inline-block; text-align: left; padding-left: 3px; padding-right: 10px'><ul>   <li>ข้อสอบตารางของก.พ. เป็นข้อสอบที่วัดความความถนัดด้านตัวเลข ตาราง เป็นเรื่องที่เกี่ยวกับการเพิ่มขึ้นและลดลงของตัวเลข ในรูปแบบต่าง ๆ การฝึกทำข้อสอบมาก ๆ จะทำให้คุ้นเคยกับรูปแบบของตาราง และสามารถทำได้อย่างรวดเร็ว</li>      <li>เวลาเป็นเรื่องสำคัญ โจทย์ตารางของ ก.พ. จะมีทั้งข้อยาก และข้อง่าย ในการทำข้อสอบจริง ถ้าดูแล้วยังจับรูปแบบไม่ได้ ควรข้ามไปทำข้ออื่นก่อน จะได้ไม่เสียเวลา เมื่อทำข้อสอบข้ออื่น ๆ ที่มั่นใจเสร็จแล้ว จึงค่อยกลับมาคิดอีกที</li>   </ul>   </div> </body></html>";
  //  thisJson ="<!DOCTYPE html><html lang='th'> <head>    <meta charset='UTF-8'>    <meta name='viewport' content='width=device-width, initial-scale=1'>	<link rel='stylesheet' type='text/css' href='my_style.css'>    <link rel='stylesheet' type='text/css' href='table_exercise.css'>	<style>	 body {        font-size: 18px;    }	.red_box{		  border-style: solid dotted;	  border-color: red;	  border-width: 1px;	  text-align: center;	  padding: 5px;	}	</style>  <title>ตาราง</title> </head> <body>  <div id='how_to' style='display: block; margin-top: 15px; '>    การคำนวนข้อมูลในตาราง    <ol>        <li>หาความแตกต่าง ใช้การลบหาความแตกต่าง ตามปกติ เช่น<br><br>		เช่น ถามว่า การส่งออกข้าวในปี 2565 มากกว่าปี 2564 กี่ล้านตัน<br><br>			<div class='red_box'>การส่งออกข้าวในปี 2565 - การส่งออกข้าวในปี 2564</div>			<br></li><li>				หาร้อยละ จากสูตร<br><br><div class='red_box'>ร้อยละ =&#160;&#160;	<span class='frac'>ต้องหา<span class='symbol'>/</span><span class='bottom'>ตัวเทียบ</span></span> × 100</div><br>เช่น ถามว่า การส่งออกข้าวในปี 2564 คิดเป็นร้อยละเท่าไรของปี 2565 <br><br>			ต้องหา คือ ข้อมูล ปี 2564<br>			ตัวเทียบ คือ ข้อมูล ปี 2565<br><br>            ร้อยละ =&#160;&#160; <span class='frac'>ข้อมูล ปี 2564<span class='symbol'>/</span><span class='bottom'>ข้อมูล ปี 2565</span></span> x 100<br><br></li> <li>หาเพิ่มขึ้นหรือลดลง(การเปลี่ยนแปลง) คิดเป็นกี่เท่า   สูตร<br><br><div class='red_box'>จำนวนเท่า = &#160;&#160;<span class='frac'>ปี ปลาย - ปี ต้น<span class='symbol'>/</span><span class='bottom'>ปี ต้น</span></span> </div><br> เช่น ถามว่า การส่งออกข้าวในปี 2565 เพิ่มขึ้นจาก ปี 2564 กี่เท่า<br><br>ต้องหา คือ ความต่างระหว่าง ปี 2565 กับปี 2564 <br>หรือ ปี 2565 - ปี 2564<br>ตัวเทียบ คือ ปี 2564<br><br><br></li><li>หาอัตราส่วน หรือสัดส่วน ให้ใช้วิธีหาร <br><br>            สูตร<br><br>            <div class='red_box'>อัตราส่วน ปี 2564 : 2565  =&#160;&#160;   <span class='frac'>ปี 2564<span class='symbol'>/</span><span class='bottom'>ปี 2565</span></span></div><br>แล้วทอนเป็นเศษส่วนอย่างต่ำ<br><br>			หรือ<br>			หาอัตราส่วน โดยการเอา ห.ร.ม. (ตัวเลขที่มากที่สุดที่เอาไปหารได้ลงตัว) ไปหาร เช่น<br><br>			20 : 40 : 10<br>			ตัวเลขที่มากที่สุด ที่เอาไปหาร 20, 40 และ 10 ได้ลงตัว (ห.ร.ม.) คือ 10<br>			อัตราส่วนคือ (20 &#xf7; 10) : (40 &#xf7; 10) : (10 &#xf7; 10)<br>2 : 4 : 1<br><br>			</li><li>ให้หาอัตราการเปลี่ยนแปลง( &#9651;% ) การส่งออกข้าวในปี 2565 เพิ่มขึ้นจากปี 2564 คิดเป็นร้อยละเท่าไร<br>ความต่างคือ ปี ปลาย - ปี ต้น<br>ตัวเทียบคือ ปี ต้น<br>ทำเป็นร้อยละ โดยการคูณด้วย 100<br><br>            สูตร<br><br>            <div class='red_box'>อัตราการเปลี่ยนแปลง &#160;=&#160;&#160; <span class='frac'>ปลาย - ต้น<span class='symbol'>/</span><span class='bottom'>ต้น</span></span> x 100</div><br>ข้อสังเกต            <ul style='list-style-type: square;'><li>สูตรนี้เหมือนกับการหาจำนวนเท่า เพียงแต่เพิ่ม คูณด้วย 100 เพราะต้องการหาค่าร้อยละ</li><li>สูตรนี้ สามารถใช้หา ปีต้น หรือปีปลาย ก็ได้ โดยการแทนค่าด้วย อัตราการเปลี่ยนแปลง และ ปีต้น หรือปีปลาย ที่โจทย์ให้มา</li>             <li>บางทีตารางอาจเรียงปีจากน้อยไปหามาก หรือจากมากไปหาน้อย ต้องระวังหาปีต้นและปีปลายให้ถูก (ปีต้น ตัวเลข พ.ศ. จะน้อยกว่า ปีปลาย)</li><li>ค่าที่ได้จากสูตร อาจมีติดลบ ถ้าอัตราติดลบ แสดงว่า ปีปลายทำได้น้อยกว่าปีต้น </li></ul></li>        <li>ให้หาความแตกต่าง โดยให้คิดเป็นร้อยละ เช่น ถามว่า ส่งออกข้าวและมันสำปะหลัง ในเดือน มกราคม ต่างกันร้อยละเท่าไร<br>            การหาความแตกต่างเป็นร้อยละ (Percentage of Difference) มักจะใช้กับการเปรียบเทียบสิ่งของที่ต่างชนิดกัน ไม่ได้พูดถึงการเพิ่มขึ้นหรือลดลง <br><br>            สูตร<br><br><div class='red_box'>            ความต่าง &#160;= &#160;&#160; <span class='frac'>(จำนวนที่ 1)-(จำนวนที่ 2)<span class='symbol'>/</span><span class='bottom'>((จำนวนที่ 1)+(จำนวนที่ 2)) &#xf7; 2</span></span> x 100</div><br>			หมายเหตุ<br>ทั้งสองสูตรข้างบน เราไม่คิดเครื่องหมายของผลลัพธ์ (จำนวนที่ 1 - จำนวนที่ 2) เอาแต่ตัวเลข ไม่เอาเครื่องหมาย<br><br>        </li>        <li>ให้หาค่าเฉลี่ย <br><br>            สูตร<br><br><div class='red_box'>            ค่าเฉลี่ย &#160;= &#160;&#160; <span class='frac'>ผลรวมของทุกปีรวมกัน<span class='symbol'>/</span><span class='bottom'>จำนวนปี</span></span></div><br>			เช่น ถามว่า การส่งออกข้าวในปี 2561 ถึง 2565 เฉลี่ยส่งออกข้าวปีละกี่ล้านตัน<br><br>			<div class='red_box'>ค่าเฉลี่ย = <span class='frac'>ผลผลิต ปี 2561 + ผลผลิต ปี 2562 + ผลผลิต ปี 2563 + ผลผลิต ปี 2564 + ผลผลิต ปี 2565 <span class='symbol'>/</span><span class='bottom'>5</span></span></div><br>        </li>        <li>ให้หาร้อยละการเปลี่ยนแปลงเฉลี่ยรายเดือน หรือ ปี เช่น ถามว่า การส่งออกข้าวในปี 2561 - 2565 เพิ่มขึ้นเฉลี่ยปีละกี่เปอร์เซนต์<br><br>	คิดแบบเร็ว คือ ใช้สูตรการหาอัตราความเปลี่ยนแปลง แต่ให้เอาจำนวนครั้งที่มีการเปลี่ยนแปลง ไปหารด้วยเพื่อเป็นค่าเฉลี่ย ก่อนที่จะคูณด้วย 100 เพื่อทำเป็นเปอร์เซ็นต์<br><br>            สูตร<br><br><div class='red_box'>อัตราการเปลี่ยนแปลงเฉลี่ย &#160;=&#160;&#160; <span class='frac'>ปลาย - ต้น<span class='symbol'>/</span><span class='bottom'>ต้น x (จำนวนครั้งที่เปลี่ยน)</span></span> x 100</div><br>สูตรข้างบน ไม่ได้เอาการเปลี่ยนแปลงแต่ละครั้งมาคิด คิดเฉพาะหัว(ปีต้น)กับท้าย(ปีปลาย)เท่านั้น <br><br>ถ้าจะคิดให้ละเอียด ให้ใช้อีกสูตร คือ<br><br> <div class='red_box'>อัตราการเปลี่ยนแปลงเฉลี่ย  &#160;= &#160;&#160; <span class='frac'>ผลรวมการเปลี่ยนแปลง<span class='symbol'>/</span><span class='bottom'>จำนวนครั้งที่เปลี่ยน</span></span></div><br>    </li>  </ul></li></ol></div> </body></html>";
thisJson ="<!DOCTYPE html><html lang='th'> <head>    <meta charset='UTF-8'>    <meta name='viewport' content='width=device-width, initial-scale=1'>	<link rel='stylesheet' type='text/css' href='my_style.css'>    <link rel='stylesheet' type='text/css' href='table_exercise.css'>	<style>	 body {        font-size: 18px;    }	.red_box{		  border-style: solid dotted;	  border-color: red;	  border-width: 1px;	  text-align: center;	  padding: 5px;	}	</style>  <title>ตาราง</title> </head> <body>  <div id='how_to' style='display: block; margin-top: 15px; '>    การคำนวนข้อมูลในตาราง    <br>ประเด็นหลักที่ควรรู้คือ <span style='color: red'>&#x2605;</span>หาความแตกต่างโดยการลบ <span style='color: red'>&#x2605;</span>หาค่าร้อยละโดยการหารด้วยตัวเทียบแล้วคูณด้วย 100 <span style='color: red'>&#x2605;</span>หาอัตราส่วนโดยการหาร <span style='color: red'>&#x2605;</span>หาค่าเฉลี่ยโดยการหารด้วยจำนวนทั้งหมด <ol>        <li>หาความแตกต่าง ใช้การลบหาความแตกต่าง ตามปกติ เช่น<br><br>		เช่น ถามว่า การส่งออกข้าวในปี 2565 มากกว่าปี 2564 กี่ล้านตัน<br><br>			<div class='red_box'>การส่งออกข้าวในปี 2565 - การส่งออกข้าวในปี 2564</div>			<br></li><li>				หาร้อยละ จากสูตร<br><br><div class='red_box'>ร้อยละ =&#160;&#160;	<span class='frac'>ต้องหา<span class='symbol'>/</span><span class='bottom'>ตัวเทียบ</span></span> × 100</div><br>เช่น ถามว่า การส่งออกข้าวในปี 2564 คิดเป็นร้อยละเท่าไรของปี 2565 <br><br>			ต้องหา คือ ข้อมูล ปี 2564<br>			ตัวเทียบ คือ ข้อมูล ปี 2565<br><br>            ร้อยละ =&#160;&#160; <span class='frac'>ข้อมูล ปี 2564<span class='symbol'>/</span><span class='bottom'>ข้อมูล ปี 2565</span></span> x 100<br><br></li> <li>หาเพิ่มขึ้นหรือลดลง(การเปลี่ยนแปลง) คิดเป็นกี่เท่า   สูตร<br><br><div class='red_box'>จำนวนเท่า = &#160;&#160;<span class='frac'>ปี ปลาย - ปี ต้น<span class='symbol'>/</span><span class='bottom'>ปี ต้น</span></span> </div><br> เช่น ถามว่า การส่งออกข้าวในปี 2565 เพิ่มขึ้นจาก ปี 2564 กี่เท่า<br><br>ต้องหา คือ ความต่างระหว่าง ปี 2565 กับปี 2564 <br>หรือ ปี 2565 - ปี 2564<br>ตัวเทียบ คือ ปี 2564<br><br><br></li><li>หาอัตราส่วน หรือสัดส่วน ให้ใช้วิธีหาร <br><br>            สูตร<br><br>            <div class='red_box'>อัตราส่วน ปี 2564 : 2565  =&#160;&#160;   <span class='frac'>ปี 2564<span class='symbol'>/</span><span class='bottom'>ปี 2565</span></span></div><br>แล้วทอนเป็นเศษส่วนอย่างต่ำ<br><br>			หรือ<br>			หาอัตราส่วน โดยการเอา ห.ร.ม. (ตัวเลขที่มากที่สุดที่เอาไปหารได้ลงตัว) ไปหาร เช่น<br><br>			20 : 40 : 10<br>			ตัวเลขที่มากที่สุด ที่เอาไปหาร 20, 40 และ 10 ได้ลงตัว (ห.ร.ม.) คือ 10<br>			อัตราส่วนคือ (20 &#xf7; 10) : (40 &#xf7; 10) : (10 &#xf7; 10)<br>2 : 4 : 1<br><br>			</li><li>ให้หาอัตราการเปลี่ยนแปลง( &#9651;% ) การส่งออกข้าวในปี 2565 เพิ่มขึ้นจากปี 2564 คิดเป็นร้อยละเท่าไร<br>ความต่างคือ ปี ปลาย - ปี ต้น<br>ตัวเทียบคือ ปี ต้น<br>ทำเป็นร้อยละ โดยการคูณด้วย 100<br><br>            สูตร<br><br>            <div class='red_box'>อัตราการเปลี่ยนแปลง &#160;=&#160;&#160; <span class='frac'>ปลาย - ต้น<span class='symbol'>/</span><span class='bottom'>ต้น</span></span> x 100</div><br>ข้อสังเกต            <ul style='list-style-type: square;'><li>สูตรนี้เหมือนกับการหาจำนวนเท่า เพียงแต่เพิ่ม คูณด้วย 100 เพราะต้องการหาค่าร้อยละ</li><li>สูตรนี้ สามารถใช้หา ปีต้น หรือปีปลาย ก็ได้ โดยการแทนค่าด้วย อัตราการเปลี่ยนแปลง และ ปีต้น หรือปีปลาย ที่โจทย์ให้มา</li>             <li>บางทีตารางอาจเรียงปีจากน้อยไปหามาก หรือจากมากไปหาน้อย ต้องระวังหาปีต้นและปีปลายให้ถูก (ปีต้น ตัวเลข พ.ศ. จะน้อยกว่า ปีปลาย)</li><li>ค่าที่ได้จากสูตร อาจมีติดลบ ถ้าอัตราติดลบ แสดงว่า ปีปลายทำได้น้อยกว่าปีต้น </li></ul></li>        <li>ให้หาความแตกต่าง โดยให้คิดเป็นร้อยละ เช่น ถามว่า ส่งออกข้าวและมันสำปะหลัง ในเดือน มกราคม ต่างกันร้อยละเท่าไร<br>            การหาความแตกต่างเป็นร้อยละ (Percentage of Difference) มักจะใช้กับการเปรียบเทียบสิ่งของที่ต่างชนิดกัน ไม่ได้พูดถึงการเพิ่มขึ้นหรือลดลง <br><br>            สูตร<br><br><div class='red_box'>            ความต่าง &#160;= &#160;&#160; <span class='frac'>(จำนวนที่ 1)-(จำนวนที่ 2)<span class='symbol'>/</span><span class='bottom'>((จำนวนที่ 1)+(จำนวนที่ 2)) &#xf7; 2</span></span> x 100</div><br>			หมายเหตุ<br>ทั้งสองสูตรข้างบน เราไม่คิดเครื่องหมายของผลลัพธ์ (จำนวนที่ 1 - จำนวนที่ 2) เอาแต่ตัวเลข ไม่เอาเครื่องหมาย<br><br>        </li>        <li>ให้หาค่าเฉลี่ย <br><br>            สูตร<br><br><div class='red_box'>            ค่าเฉลี่ย &#160;= &#160;&#160; <span class='frac'>ผลรวมของทุกปีรวมกัน<span class='symbol'>/</span><span class='bottom'>จำนวนปี</span></span></div><br>			เช่น ถามว่า การส่งออกข้าวในปี 2561 ถึง 2565 เฉลี่ยส่งออกข้าวปีละกี่ล้านตัน<br><br>			<div class='red_box'>ค่าเฉลี่ย = <span class='frac'>ผลผลิต ปี 2561 + ผลผลิต ปี 2562 + ผลผลิต ปี 2563 + ผลผลิต ปี 2564 + ผลผลิต ปี 2565 <span class='symbol'>/</span><span class='bottom'>5</span></span></div><br>        </li>        <li>ให้หาร้อยละการเปลี่ยนแปลงเฉลี่ยรายเดือน หรือ ปี เช่น ถามว่า การส่งออกข้าวในปี 2561 - 2565 เพิ่มขึ้นเฉลี่ยปีละกี่เปอร์เซนต์<br><br>	คิดแบบเร็ว คือ ใช้สูตรการหาอัตราความเปลี่ยนแปลง แต่ให้เอาจำนวนครั้งที่มีการเปลี่ยนแปลง ไปหารด้วยเพื่อเป็นค่าเฉลี่ย ก่อนที่จะคูณด้วย 100 เพื่อทำเป็นเปอร์เซ็นต์<br><br>            สูตร<br><br><div class='red_box'>อัตราการเปลี่ยนแปลงเฉลี่ย &#160;=&#160;&#160; <span class='frac'>ปลาย - ต้น<span class='symbol'>/</span><span class='bottom'>ต้น x (จำนวนครั้งที่เปลี่ยน)</span></span> x 100</div><br>สูตรข้างบน ไม่ได้เอาการเปลี่ยนแปลงแต่ละครั้งมาคิด คิดเฉพาะหัว(ปีต้น)กับท้าย(ปีปลาย)เท่านั้น <br><br>ถ้าจะคิดให้ละเอียด ให้ใช้อีกสูตร คือ<br><br> <div class='red_box'>อัตราการเปลี่ยนแปลงเฉลี่ย  &#160;= &#160;&#160; <span class='frac'>ผลรวมการเปลี่ยนแปลง<span class='symbol'>/</span><span class='bottom'>จำนวนครั้งที่เปลี่ยน</span></span></div><br>    </li>  </ul></li></ol></div> </body></html>";    show_intro_page(1, false, thisJson);  // แสดงหน้าคำอธิบาย
    break;

case "order_by_table":  // ทั้งหมด

var thisNumDat = lastQstnArr.find(element => element.includes("order_by_table"));
console.log("thisNumDat for fraction in changeData: " + thisNumDat);  // normal_cndtngxyz1
var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

console.log("lastQstnArr from Flutter - ตาราง: " + lastQstnArr);
console.log("thisNumDat แยกจาก lastQstnArr from Flutter - ตาราง: " + thisNumDat);
console.log("thisLNumber ที่ส่งเข้ามากับ lastQstnArr จาก Flutter - ตาราง: " + thisLNumber);

// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;
  	// clear input field
    // document.getElementById('myInput').value = '';
	document.getElementById('showAnswer').style.display ='none';
    //	shuffle(normal_cndtng);



	current_page = thisLNumber;
	thisJson =  bigTableData;  // ทั้งหมด
	jsonName_id = "exMenu_order_by_table"; // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
    changePage(thisLNumber, false, thisJson);  
    //doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;


case "findPercent_tbl":

console.log("findPercent_tbl: " + lastQstnArr);
   // แยกข้อมูลที่มาจาก Flutter เอาเฉพาะชื่อเมนู
    var thisNumDat = lastQstnArr.find(element => element.includes("findPercent_tbl"));
	var thisLNumberArr = thisNumDat.split(":xyz:");
            thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

  	// clear input field
    // document.getElementById('myInput').value = '';
	// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;  
	document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่
  // shuffle(objJsonSimple);  // เอา list ข้อมูล มาสลับเสียใหม่ 

	    current_page = thisLNumber;
	    thisJson = percent;//
	    jsonName_id = "exMenu_findPercent_tbl";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
        changePage(thisLNumber, false, thisJson);
	//doFraction();

    break;
	
	case  "pcntChange_tbl":

	console.log("pcntChange_tbl (% เพิ่ม-ลด): " + lastQstnArr);

// alert("lastQstnArr : " + lastQstnArr)

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู fraction
 var thisNumDat = lastQstnArr.find(element => element.includes("pcntChange_tbl"));
 console.log("thisNumDat for pcntChange_tbl: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
//
	
    var thisLNumberArr = thisNumDat.split(":xyz:");
    thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย
//
//
//
//
        	btn_pause.disabled = false;
        	btn_reset.disabled = false;
        	btn_start.disabled = false;
	document.getElementById('showAnswer').style.display ='none';
 //  shuffle(accumulate);
	    thisJson = pcntChange; //

	current_page = thisLNumber;
	   jsonName_id = "exMenu_pcntChange_tbl";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
	   
    changePage(thisLNumber, false, thisJson);
    //doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;
//
case  "average_tbl":
    // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
    var thisNumDat = lastQstnArr.find(element => element.includes("average_tbl"));
    console.log("thisNumDat for average_tbl in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    
		var thisLNumberArr = thisNumDat.split(":xyz:");
    thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

//
	// clear input field

 	document.getElementById('showAnswer').style.display ='none';
 //  shuffle(alternate_plus_multiply);
    thisJson = average;  //
	current_page = thisLNumber;
	 jsonName_id = "exMenu_average_tbl";  
	 
    changePage(thisLNumber, false, thisJson)
    //doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;

case "pcntChangeAVG_tbl":  // เฉฃี่ย เพื่ม-ลด
    

     // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
       var thisNumDat = lastQstnArr.find(element => element.includes("pcntChangeAVG_tbl"));
       console.log("thisNumDat for pcntChangeAVG_tbl in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    
	var thisLNumberArr = thisNumDat.split(":xyz:");
    thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

  	// clear input field
    // document.getElementById('myInput').value = '';	
		// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_reset.disabled = false;
	btn_start.disabled = false;
document.getElementById('showAnswer').style.display ='none';
// shuffle(add_increment_base_const_power);
     thisJson = pcntChangeAVG;  //
	current_page = thisLNumber;
	jsonName_id = "exMenu_pcntChangeAVG_tbl"; 
   	changePage(thisLNumber, false, thisJson);
    // doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;

case  "quantity_tbl":
//
//
        // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
          var thisNumDat = lastQstnArr.find(element => element.includes("quantity_tbl"));
          console.log("thisNumDat for quantity_tbl in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    
	var thisLNumberArr = thisNumDat.split(":xyz:");
    thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย


	document.getElementById('showAnswer').style.display ='none'; // ซ่อนเฉลยที่ปรากฎอยู่ 

	// shuffle(add_substract_odd_even_increment);
     thisJson = quantity;  //
	   jsonName_id = "exMenu_quantity_tbl";  
	changePage(thisLNumber, false, thisJson);
    // doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
	break;
	
case  "ratio_tbl":
             var thisNumDat = lastQstnArr.find(element => element.includes("ratio_tbl"));
             console.log("thisNumDat for ratio_tbl in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
			 
    var thisLNumberArr = thisNumDat.split(":xyz:");
    thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย
    
	document.getElementById('showAnswer').style.display ='none'; // ซ่อนเฉลยที่ปรากฎอยู่ 
  // shuffle(staticMultiply_incredmentPlus);
     thisJson = ratio;  //
	 current_page = thisLNumber;
   jsonName_id = "exMenu_ratio_tbl"; 
    changePage(thisLNumber, false, thisJson);
    // doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;

default:
	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;  
	document.getElementById('showAnswer').style.display ='none'; // ซ่อนเฉลย
	// shuffle(objJsonSimple);
    thisJson =  bigTableData;
	current_page = 1;
	 jsonName_id = "exMenu_order_by_table";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
    changePage(1, false, thisJson);
}
}

//numOfQuestions = bigTableData.length;
numOfQuestions = bigTableData.length + ratio.length + percent.length + average.length + quantity.length + pcntChangeAVG.length + pcntChange.length;
console.log(" numOfQuestions - table_exercise: " + numOfQuestions);

