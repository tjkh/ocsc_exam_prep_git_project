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


case "math_intro":
    swipeEnabled = false;  // Set this to true to enable, false to disable


// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_pause.disabled = true;
	btn_reset.disabled = true;
	btn_start.disabled = true;
	resetCountDown();

	document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่ ถ้ามาจากหน้าที่มีเฉลย
    // ไฟล์ html อธิบายวิธีทำ ทั้งไฟล์เอามาใส่ในตัวแปรเลยตรง ๆ ถ้าจะแก้ ให้คัดลอก ไปแก้ใน editPlus เอา \n เพิ่มต่อจาก <br> เพื่อให้ขึ้นบรรทัดใหม่ และเวลาจะเอามาไว้ที่นี่ ให้ตัด \n ออกก่อน
    thisJson = "<!doctype html><html lang='th'> <head>  <meta charset='UTF-8'>  <title>Document</title>  <meta name='viewport' content='width=device-width, initial-scale=1.0'>    <link rel='stylesheet' type='text/css' href='css_general.css'>    <link rel='stylesheet' type='text/css' href='cont_full_version.css'></head> <body> <!-- สำหรับภาพ เวลาหมุนแล้วจะใหญ่เต็มความกว้าง<div class='for_image'><img src='sq_test.png' width='100%'></div>  -->  <div id='top'>&nbsp;</div><strong>ข้อสอบ อุปมาอุปไมย</strong> คือ การหาตัวเลือกที่มีลักษณะความสัมพันธ์คล้ายคลึง หรือเหมือนกับที่โจทย์กำหนดให้มา โดยปกติ ข้อสอบลักษณะนี้ จะมี 5 ข้อ ควรทำเสียก่อน เพราะไม่ยาก และไม่ใช้เวลามาก<br><br><strong><span class='big_blue'>รูปแบบการวิเคราะห์</span></strong><br><br><ol><li>ความสัมพันธ์ภายในคู่ คู่หน้า สัมพันธ์กับ คู่หลัง<br><img style='display: block;  margin-left: auto;  margin-right: auto;  width:100%; max-width:400px;' src='images/metaphor_within_pairs.png'><br><span style='color:red; font-weight:bold;'>ทิศทางความสัมพันธ์เป็นสิ่งสำคัญ</span><br><br>ในการวิเคราะห์ตัวเลือก ต้องดูทิศทางความสัมพันธ์ให้เป็นทิศทางเดียวกันกับสิ่งที่โจทย์กำหนดมาให้ด้วย เช่น<br>เรือ : ท่าเรือ :: &ensp;?&ensp;?<br>1. ชานชาลา : รถไฟ<br>2. เครื่องบิน  : สนามบิน<br>ข้อ 2 ถูก เพราะความสัมพันธ์มีทิศทางเดียวกับสิ่งที่โจทย์กำหนดมากให้</li><li>ความสัมพันธ์ระหว่างคู่ ตัวหน้าคู่แรก สัมพันธ์กับ ตัวหน้าคู่หลัง และตัวหลังคู่แรก สัมพันธ์กับ ตัวหลังคู่หลัง<br><img style='display: block;  margin-left: auto;  margin-right: auto;  width:100%; max-width:400px;' src='images/metaphor_between_pairs.png'><br>ส้ม คล้าย ลองกอง คือ มีเปลือก เนื้อในเป็นกลีบ<br>เงาะ คล้าย ลิ้นจี่ คือ เปลือกนอกสีออกแดง มีเมล็ดใหญ่<br></li></ol><strong><span class='big_blue'>ลักษณะความสัมพันธ์ </span></strong><br><br>1. <span class='big_blue'>แบ่งชนิด อยู่ในหมวดหมู่เดียวกัน หรือประเภทเดียวกัน</span><br><br><div class='rcorners1'>พระธรรม : อักษรกลาง :: _____ : _____<br>1. สมาธิ : โกรธ<br>2. กาย : วาจา<br>3. โลภ : หลง<br>4. พระพุทธ : อักษรต่ำ<br></div><br> ข้อนี้ เป็นการจัดกลุ่ม โดยนำเอาสมาชิกในกลุ่มมาสัมพันธ์กัน คือ <br> พระธรรม จัดอยู่ในกลุ่ม พระรัตนตรัย<br> อักษรกลาง จัดอยู่ในกลุ่ม ไตรยางค์หรืออักษรสามหมู่<br><br> ดังนั้น ส่วนที่จะต้องนำมาเข้าคู่กัน ก็ต้องเป็นสมาชิกของ พระรัตนตรัย และอักษรสามหมู่<br><br> ข้อ 4 จึงเป็นข้อที่ถูกต้อง เพราะ<br> พระพุทธ พระธรรม พระสงฆ์ ประกอบกันเป็น พระรัตนตรัย<br> อักษรสูง อักษรกลาง อักษรต่ำ ประกอบกันเป็น ไตรยางค์ หรือ อักษรสามหมู่<br><br>2. <span class='big_blue'>หมวดหมู่:สมาชิก</span><br><br><div class='rcorners1'>แกรนิต : หิน :: _____ : _____ <br>1. ปลาดุก : น้ำจืด<br>2. แคลเซียม : ธาตุ<br>3. เรือ : ทะเล<br>4. ผงชูรส : เกลือแร่<br></div><br> แกรนิต จัดเป็น หิน ชนิดหนึ่ง<br> แคลเซี่ยม จัดเป็น ธาตุ ชนิดหนึ่ง<br><br>ข้อที่ถูกคือ ข้อ 2<br><br>3. <span class='big_blue'>ความหมายเหมือนกันหรือตรงข้ามกัน</span><br><br><div class='rcorners1'>ขจร : ฟุ้ง :: ใหญ่ : _____<br>1. โต<br>2. ยักษ์<br>3. ขนาด<br>4. ไกล<br></div><br>ข้อนี้จะเห็นว่า ขจร มีความหมายเช่นเดียวกับคำว่า ฟุ้ง เป็นคำที่เรียกว่า คำไวพจน์ คือคำที่มีความหมายเหมือนกันดังนั้น ข้อ 1 จึงเป็นข้อที่ถูก เพราะ ใหญ่ มีความหมายเช่นเดียวกับคำว่า โต<br><br>4. <span class='big_blue'>เป็นเหตุเป็นผลแก่กัน</span><br><br><div class='rcorners1'>วิ่งเร็ว :เหนื่อย :: กินมากไป : _____<br>1. ง่วง<br>2. จุก<br>3. อ้วน<br>4. เรอ<br></div><br> วิ่งเร็ว ผลที่ตามมาคือจะทำให้เหนื่อย เป็นเหตุเป็นผลแก่กัน <br> ดังนั้น กินมากเกินไป ก็จะทำให้จุก เป็นคำตอบที่สัมพันธ์กันมากที่สุด <br><br>5. <span class='big_blue'>เรียงลำดับจากใหญ่ไปเล็ก</span><br><br><div class='rcorners1'>อำเภอ : หมู่บ้าน :: _____ : _____<br>1. จังหวัด : ตำบล <br>2. ปลัดอำเภอ : ผู้ใหญ่บ้าน<br>3. เมือง : เทศบาล<br>4. นายอำเภอ : กำนัน<br></div><br>ข้อนี้ต้องพิจารณาการเรียงลำดับ จากโจทย์ จะเห็นว่า<br><br>อำเภอ &#65515; ตำบล &#65515; หมู่บ้าน<br><br>เมื่อพิจารณา ตัวเลือก จะเห็นว่า<br><br>1. จังหวัด &#65515; อำเภอ &#65515; ตำบล <br>2. ปลัดอำเภอ  &#65515; กำนัน &#65515; ผู้ใหญ่บ้าน<br>3. เมือง : เทศบาล (ข้อนี้ใช้ไม่ได้)<br>4. นายอำเภอ &#65515; ปลัดอำเภอ &#65515; กำนัน<br><br>จะเห็นว่า ข้อ 1 ถูกต้องที่สุด โดยเป็นเขตพื้นที่การปกครองเหมือนกัน และอยู่ห่างกัน 2 ระดับ<br>ข้อ 2 และ ข้อ 4 ก็ห่างกัน 2 ระดับเหมือนกัน แต่ไม่ได้เป็นพื้นที่การปกครอง เหมือนกับโจทย์<br><br>6.<span class='big_blue'>สัมพันธ์ในลักษณะบทบาท หน้าที่ คุณประโยชน์</span><br><br><div class='rcorners1'>เขื่อน : น้ำ _____ : _____ <br>1. คลอง : ฝาย<br>2. ประตู : บ้าน<br>3. โทรศัพท์ : คลื่นเสียง<br>4. สวิตช์ : ไฟฟ้า<br></div><br>เขื่อน สำหรับเปิด-ปิด น้ำ<br>สวิตช์ สำหรับเปิด-ปิด ไฟฟ้า<br><br>ดังนั้น ข้อ 4 จึงถูกต้อง<br><br>7.<span class='big_blue'>จำนวนตัวอักษร</span><br><br><div class='rcorners1'>_____ : ปราบ :: หก : _____<br>1. สี่ : กางเขน<br>2. แปด : สงบ<br>3. สาม : สนิท<br>4. เจ็ด : นาฬิกา<br></div><br>จะเห็นว่า 'ปราบ' มีตัวอักษร สี่ ตัว<br>และ 'กางเขน' มีตัวอักษร หก ตัว<br><br>ดังนั้น ข้อ 1 จึงถูกต้อง<br><br>8. <span class='big_blue'>อื่น ๆ เช่น</span><br><br>- มีลักษณะนามเหมือนกัน เช่น เทียนไข - เกวียน มีลักษณะนามคือ เล่ม เหมือนกัน<br>- ประเทศ : สัญลักษณ์ เช่น แคนาดา:ใบเมเปิ้ล :: ออสเตรเลีย : จิงโจ้<br>- ทำหน้าที่เดียวกัน เช่น ปากกา:กระดาษ :: ชอล์ก:กระดานดำ<br>เป็นต้น<br><strong>เทคนิคการทำข้อสอบอุปมาอุปไมย</strong><br><ol><li><span class='big_blue'>วิเคราะห์ความสัมพันธ์ของโจทย์ที่ให้มา</span>แล้วเปรียบเทียบ ทีละตัวเลือก ว่า ตัวเลือกใดที่มีความสัมพันธ์ทำนองเดียวกับความสัมพันธ์ของโจทย์บ้าง<div class='rcorners1'>มอเตอร์ไซด์ : รถยนต์ :: _____ : _____<br><br>1. คน : ควาย<br>2. จักรยาน : สามล้อถีบ <br>3. เป็ด : ไก่<br>4. รถเข็น : รถบรรทุก<br></div><br>มอเตอร์ไซต์กับรถยนต์ อาจจะมีความสัมพันธ์ได้หลายอย่าง เช่น เป็นยานพาหนะ จำนวนล้อ การขับเคลื่อน ขนาด เป็นต้น<br>เมื่อพิจารณาความสัมพันธ์ของตัวเลือก จะพบว่า<br>1. คน : ควาย อาจจะสัมพันธ์ ในลักษณะ คนกับสัตว์ จำนวนขา ความฉลาด<br>2. จักรยาน : สามล้อถีบ อาจจะสัมพันธ์ในลักษณะ เป็นยานพาหนะ จำนวนล้อ การขับเคลื่อน<br>3. เป็ด : ไก่ อาจจะสัมพันธ์ในลักษณะ สัตว์ชนิดเดียวกัน จำนวนปีก จำนวนขา<br>4. รถเข็น : รถบรรทุก อาจจะสัมพันธ์ในลักษณะ การขับเคลื่อน ความเร็ว เป็นต้น<br><br>เมื่อพิจารณาให้ดี จะเห็นว่า มอเตอร์ไซต์กับรถยนต์ มีความสัมพันธ์ในลักษณะเดียวกับ จักรยาน และ สามล้อถีบ เพราะ เป็นยานพาหนะเหมือนกัน มีลักษณะการขับเคลื่อนเหมือนกัน คือ ใช้เครื่องยนต์ กับใช้แรงคนทั้งคู่<br><br>ข้อนี้ ข้อ 2 จึงถูกต้อง<br></li><li><span class='big_blue'>ดูว่าตัวเลือก</span> มีลักษณะคล้อยตาม หรือตรงข้ามกัน เพื่อตัดตัวเลือกที่ไม่สอดคล้องออกไป เช่น ถ้าโจทย์ให้ความสัมพันธ์ แบบคล้อยตามกัน ก็ไปตัดตัวเลือกที่ตรงข้ามออกไปก่อน ถ้าโจทย์ให้ความสัมพันธ์แบบตรงข้ามมาก็ตัด ตัวเลือกที่คล้อยตามกันออกไปก่อน เพื่อให้เหลือข้อที่จะนำมาพิจารณาน้อยลง <br><br>ตัวอย่าง<br><br><div class='rcorners1'>ก้าวหน้า : ถอยหลัง :: _____ : _____<br>1. ยินดี : ดีใจ <br>2. วิ่ง : เดิน <br>3. เจริญ : เสื่อม <br>4. สนุก : ร่าเริง <br></div><br>โจทย์ให้มามีลักษณะตรงข้ามกัน ดังนั้นตัวเลือกใดที่ คล้อยตามกันหรือไปทิศทางเดียวกันให้ตัดออกไปก่อน เช่น ตัวเลือก ข้อ 1.  ข้อ 2. และ ข้อ 4. ตัดออกได้เลย จึงเหลือเฉพาะข้อ 3 ซึ่งเมื่อพิจารณาแล้ว จะเห็นว่ามีลักษณะสอดคล้องเหมือนกับโจทย์ที่ให้มา คือ มีลักษณะที่ขัดแย้งกัน <br>ข้อนี้ ข้อ 3 จึงเป็นตัวเลือกที่ถูกต้อง<br><br></li><li><span class='big_blue'>หาคำเชื่อม</span>ที่ทำให้โจทย์สองตัวที่ให้มามีความหมาย แล้วนำไปแทนค่ากับตัวเลือกที่ให้มา ถ้าสามารถแทนกันได้ ก็ใช้ได้เลย แต่ถ้าแทนกันได้มากกว่า 1 ตัวเลือก ก็ต้องพิจารณาต่อไปให้ละเอียดมากขึ้น ก็จะได้คำตอบที่ดีที่สุด<br><br>ตัวอย่าง<br><br><div class='rcorners1'>รถยนต์ : พวงมาลัย :: _____ : _____<br>1. ม้า : แส้ <br>2. สุนัข : ปีก <br>3. ปลา : หาง <br>4. เรือ : พังงา<br></div><br>ตอนแรก หาคำเชื่อมที่พอทำให้คำสองคำที่โจทย์ให้มาเสียก่อน เช่น <br><br>รถยนต์ ใช้ พวงมาลัย บังคับเลี้ยว <br><br>จากนั้นลองนำคำเชื่อมไปใช้กับทุกตัวเลือก<br><br><ol><li> ม้า ใช้ แส้ บังคับเลี้ยว<li> สุนัข ใช้ ปีก บังคับเลี้ยว<li> ปลา ใช้ หาง บังคับเลี้ยว<li> เรือ ใช้ พังงา บังคับเลี้ยว</ol><br>จะเห็นว่า ข้อ 1, ข้อ 3 และข้อ 4 เป็นประโยคที่ใช้ได้ แต่เมื่อพิจารณาดูให้มากขึ้นทีละข้อ จะพบว่า<br><br><ol><li> ม้า ใช้ แส้ บังคับเลี้ยว : ก็อาจจะใช่ แต่แส้ใช้เร่งให้ม้าวิ่งเร็วขึ้นมากกว่า</li><li> ปลา ใช้ หาง บังคับเลี้ยว : ถูกต้อง แต่โจทย์พูดถึงยานพาหนะ ปลาเป็นสัตว์น้ำ</li><li> เรือ ใช้ พังงา บังคับเลี้ยว : ถูกต้อง และมีความสัมพันธ์กับโจทย์ มากกว่าข้อ 3 เพราะ เรือ เป็นยานพาหนะเช่นเดียวกับ รถ</li></ol>ข้อนี้ ข้อ 4 จึงถูกต้อง<br><br></li></ol><strong><font color='red'>ตัวอย่างเพิ่มเติม</font></strong><br><br><div class='rcorners1'>อ้อย : น้ำตาล :: _____;_____<br> 1. แป้ง : ขนมปัง <br>2. มะพร้าว : กะทิ <br>3. ดอกไม้ : เกษร <br>4. ไม้กวาด : เกลี้ยง <br></div><br>ตอนแรก หาคำเชื่อมที่ได้ความหมายก่อน<br><br>น้ำตาล ได้มาจาก อ้อย<br><br>เมื่อนำไปใช้กับตัวเลือกทั้งหมด จะได้ว่า<br><br><ol><li>ขนมปัง ได้มาจาก  แป้ง<li>กะทิ ได้มาจาก  มะพร้าว <li>เกษร ได้มาจาก  ดอกไม้<li>เกลี้ยง ได้มาจาก  ไม้กวาด</ol>เมื่อพิจารณาองค์ประกอบอื่นด้วย เช่น กระบวนการได้มา ชนิดหรือประเภท จะเห็นว่า 'กะทิ ได้มาจาก มะพร้าว' มีความสัมพันธ์ใกล้เคียงมากที่สุดกับที่โจทย์กำหนด คือ<br>&nbsp;&nbsp;- ได้มาจากวิธีการบีบ หรือคั้น เหมือนกัน<br>&nbsp;&nbsp;- เป็นประเภทอาหารเหมือนกัน<br><br>ดังนั้น ข้อ 2 จึงถูกที่สุด<br><div class='rcorners1'>นักร้อง : น้ำเสียง :: ดารา :  _____<br><br>1. บทบาท<br>2. มารยาท <br>3. ความฉลาด <br>4. การแต่งกาย <br></div><br>จากตัวอย่างนี้ เราหาความสัมพันธ์ระหว่าง นักร้อง กับ น้ำเสียง จะพบว่า น้ำเสียงคือสิ่งที่สำคัญที่สุดของนักร้อง ถ้าน้ำเสียงดี นักร้องก็จะประสบความสำเร็จ<br><br>ถ้าเป็นดารา สิ่งที่สำคัญที่สุดก็คือ บทบาทการแสดง ตัวเลือกอื่น ๆ เช่น มารยาท ความฉลาด หรือการแต่งกายก็สำคัญ แต่ที่สำคัญที่สุดคือ บทบาท<br><br>ดังนั้น ข้อที่ถูกที่สุด ก็คือ ข้อ 1<br><br><div class='rcorners1'>ศาล : ความยุติธรรม :: _____ : _____<br><br>ก.  ทนายความ  :  ลูกความ<br>ข.  อัยการ  :  โจทก์<br>ค.  วุฒิสภา  :  ส.ส.<br>ง.  รัฐสภา  :  กฎหมาย<br></div><br>ศาล เป็นสถาบัน ที่ให้ “ความยุติธรรม” <br>ตัวเลือกแรกที่เป็นสถาบัน คือ ข้อ 3. วุฒิสภา และ ข้อ 4. รัฐสภา<br><br>ศาลคือสถาบันที่ให้ความยุติธรรม ซึ่งมีความสัมพันธ์เช่นเดียวกับ รัฐสภา ที่ออกกฎหมาย หรือให้กฎหมาย นั่นเอง<br><br>ข้อนี้ ข้อ 4 จึงถูกต้อง<br><br><div class='rcorners1'>รัสเซีย : หมีขาว :: _____ : _____<br><br>1.  แคนาดา  :  นกอินทรีย์<br>2.  สิงค์โปร์  :  ปลาโลมา<br>3.  ออสเตรเลีย  :  จิงโจ้<br>4.  ญี่ปุ่น  :  สิงโต<br></div><br> “หมีขาว” เป็นสัญลักษณ์ของประเทศรัสเซีย<br><br> 'นกอินทรีย์' ไม่ใช่สัญลักษณ์ของ ประเทศแคนาดา สัญลักษณ์ของประเทศแคนาดา คือใบเมเปิ้ล<br><br> 'ปลาโลมา' ไม่ใช่สัญลักษณ์ของ ประเทศสิงคโปร์ สัญลักษณ์ของประเทศสิงคโปร์ คือ  เมอร์ไลออน (Merlion) หมายถึง สิงโตทะเล มีหัวเป็นสิงโต ร่างเป็นปลา ยืนอยู่บนยอดคลื่น<br><br>“จิงโจ้” เป็นสัญลักษณ์ของประเทศออสเตรเลีย <br><br>'สิงโต' ไม่ใช่สัญลักษณ์ของ ประเทศญี่ปุ่น เมื่อพูดถึงญี่ปุ่น ต้องนึกถึง ภูเขาฟูจิ ดอกซากุระ ประตู Tori ชุดกิโมโน เป็นต้น<br><br>ข้อ 3 จึงถูกต้อง<br><br><div class='rcorners1'>เรือยนต์ : พังงา :: _____ : _____<br><br>1.  ม้า  :  บังเหียน<br>2.  เกวียน  :  วัว<br>3.  รถยนต์  :  พวงมาลัย<br>4.  เรือใบ  :  หางเสือ<br><br></div><br>พังงา คืออุปกรณ์ในเรือสำหรับบังคับทิศทางเรือ หรือพวงมาลัยเรือนั่นเอง<br><br>ดังนั้น รถยนต์ กับ พวงมาลัย จึงมีความสัมพันธ์ในลักษณะเดียวกันกับ เรือยนต์และพังงา<br><br>ข้อนี้ ข้อ 3 จึงถูกต้อง<br><br><div class='rcorners1'> กระดานดำ : ชอล์ก :: _____ : _____<br><br>1.  ปากกาเคมี  :  ไวท์บอร์ด<br>2.  กระดาษ  :  ดินสอ<br>3.  ดิสเก็ต :  โปรแกรมเมอร์<br>4.  บทกลอน  :  กวี<br></div><br>กระดานดำ ใช้ ชอล์ก เขียน<br>เช่นเดียวกับ<br>กระดาษ ใช้ ดินสอ เขียน<br><br>ปากกาเคมี ใช้ ไวท์บอร์ด เขียน ไม่ได้  <br>ข้อนี้ยังไม่ถูกเพราะการเรียงลำดับไม่ถูกต้อง<br><br>ข้อนี้ ข้อ 2 ถูกต้อง<br><br><div class='rcorners1'>ไฟฉาย : ลูกเสือ :: _____ : _____<br><br>1.  ตะเกียง  :  ทหาร<br>2.  ประภาคาร  :  เรือเดินทะเล<br>3.  เรดาร์  :  เครื่องบิน<br>4.  ไต้  :  ชาวเขา<br></div><br>ลูกเสือ ใช้ ไฟฉาย สำหรับส่องเดินทางในเวลากลางคืน<br>เช่นเดียวกับ<br>ชาวเขา ใช้ ไต้ สำหรับส่องเดินทาง<br><br>สำหรับทหารนั้น ใช้ตะเกียงสำหรับหน้าที่อื่น ที่ไม่ใช่การนำทาง<br><br>ข้อนี้ ข้อ 4 ถูกต้อง<br></body></html>";
    show_how_to(1, false, thisJson);  // แสดงหน้าคำอธิบาย
//    thisJson = "math_intro";
 //   changePage(1, false, thisJson);
    break;

case "metaphor":
console.log("lastQstnArr : " + lastQstnArr);
var thisNumDat = lastQstnArr.find(element => element.includes("metaphor"));
// alert("thisNumDat: " + thisNumDat);  // fraction_cndtngxyz1
console.log("thisNumDat: " + thisNumDat);  // normal_cndtngxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย
    //    alert("thisLNumber: " + thisLNumber);
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
    //	shuffle(sectmented);

     // เรียงตาม id
      metaphor_dat = metaphor_dat.sort((a, b) => {
           if (a.id > b.id) {  // เรียง มาก ไป น้อย ปีล่าสุดปัจจุบัน -> ปีที่ผ่านมาแล้ว
          return -1;
          }
      });

    thisJson = metaphor_dat;
    console.log("thisJson: " + thisJson);
    current_page = thisLNumber;
    jsonName_id = "metaphor";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
    changePage(thisLNumber, false, thisJson);
    break;

default:   
    
     // เรียงตาม id
      metaphor_dat = metaphor_dat.sort((a, b) => {
          if (a.id < b.id) {
          return -1;
          }
      });
      
    thisJson = metaphor_dat;
    changePage(1, false, thisJson);
   
}
}
