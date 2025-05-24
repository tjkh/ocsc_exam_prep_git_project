
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

case "how_to_evaluate":

    swipeEnabled = false;  // Set this to true to enable, false to disable
// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_pause.disabled = true;
	btn_reset.disabled = true;
	btn_start.disabled = true;
	resetCountDown();

	document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่ ถ้ามาจากหน้าที่มีเฉลย
    // ไฟล์ html อธิบายวิธีทำ ทั้งไฟล์เอามาใส่ในตัวแปรเลยตรง ๆ ถ้าจะแก้ ให้คัดลอก ไปแก้ใน editPlus เอา \n เพิ่มต่อจาก <br> เพื่อให้ขึ้นบรรทัดใหม่ และเวลาจะเอามาไว้ที่นี่ ให้ตัด \n ออกก่อน
    thisJson = "<!DOCTYPE html><html lang='th'> <head>    <meta charset='UTF-8'>    <meta name='viewport' content='width=device-width, initial-scale=1'>     <link rel='stylesheet' type='text/css' href='my_style.css'>    <link rel='stylesheet' type='text/css' href='symbol_cndtng_exercise.css'>	<style>table {border-collapse: collapse; border-spacing: 0; width: 100%;border: 1px solid #ddd;} tr:nth-child(even) {background-color: #B2BEB5;}  tr:nth-child(odd) {background-color: #A9A9A9;}.fraction {  display: inline-block;  position: relative;  vertical-align: middle;   letter-spacing: 0.001em;  text-align: center;  font-size: 12px;  }.fraction > span {   display: block;   padding: 0.1em;   }.fraction span.fdn {border-top: thin solid black;}.fraction span.bar {display: none;}    body {        font-size: 16px;    }/* ให้เส้นคั่น ห่างจากขอบซ้าย นิดนึง*/ hr{margin-left:30;} .equal-width td { width: 50%; } ol{  padding-left:15px;}/* Second Level */ol ol{  padding-left:17px;}/* Third Level */ol ol ol{  padding-left:18px;}ul{  padding-left:15px;}/* Second Level */ul ul{  padding-left:17px;}/* Third Level */ul ul ul{  padding-left:18px;}</style>  <title>how_to</title> </head> <body>ขั้นตอนการทำเงื่อนไขสัญลักษณ์(แบบย่อ-สรุป)<br><br><strong>1. จัดรูปแบบ</strong><ol><li>เปลี่ยนเครื่องหมาย &#x22;ไม่&#x22; ให้เป็นเครื่องหมายปกติ<br><div style='margin-right:10px'><table width='100%' border=0><tr><td width='45%'>ไม่มากกว่่า (&#x226F;) </td><td>เป็น</td><td width='45%'>น้อยกว่าหรือเท่ากับ (&#x2264;)</td></tr><tr><td>ไม่น้อยกว่า (&#x226E;) </td><td>เป็น</td><td>มากกว่าหรือเท่ากับ (&#x2265)</td></tr><tr><td>ไม่มากกว่าหรือไม่เท่ากับ(&#x2271;)</td><td>เป็น</td><td>น้อยกว่า(&lt;)</td></tr><tr><td>ไม่น้อยกว่าหรือไม่เท่ากับ(&#x2270;)</td><td>เป็น</td><td>มากกว่า(&gt;)</td></tr><tr><td colspan=3>สำหรับเครื่องหมาย ไม่เท่ากัน (&#x2260;) ไม่ต้องเปลี่ยน แต่ให้เข้าใจไว้ว่า เครื่องหมายไม่เท่ากัน คือ เครื่องหมายมากกว่า หรือ น้อยกว่า อย่างใดอย่างหนึ่ง</td></tr></table></div>หรือ จำแบบง่าย ๆ ว่า ให้กลับหัวลูกศร และถ้ามีเครื่องหมายเท่ากับก็ให้ตัดออก หรือถ้าไม่มีก็ให้เติมเข้าไป</li><li>ถ้ามีเศษส่วน ที่เศษเป็นตัวอักษรและส่วนเป็นตัวเลข ให้กำจัดส่วนออกไป เช่น ถ้ามีเศษส่วนเพียงตัวเดียว ให้เอาส่วนคูณตลอด หรือ ถ้ามีเศษส่วนหลายตัว ให้คูณด้วย ค.ร.น. เป็นต้น หรืออาจจะคงไว้ก็ได้ ถ้าเห็นว่าสามารถใช้ประโยชน์จากเศษส่วนได้ เป็นต้น ตัวอย่าง<div style='margin-right:10px'><table width='100%'><tr>	<td width='45%'>คูณด้วยส่วน<br>2A &gt; <span class='fraction'><span class='fup'>2K</span><span class='bar'>/</span><span class='fdn'>3</span></span>  &gt; Q</td>	<td>เป็น</td>	<td width='45%'>2A &gt; <span class='fraction'><span class='fup'>2K</span><span class='bar'>/</span><span class='fdn'>3</span></span>  &gt; Q<br>คูณด้วย 3 ตลอด<br>(3)2A &gt; <span class='fraction'><span class='fup'>(3)(2K)</span><span class='bar'>/</span><span class='fdn'>3</span></span>  &gt; (3)Q<br>6A &gt; 2K &gt; 3Q</td></tr><tr>	<td width='45%'>คูณด้วย ค.ร.น.<br><span class='fraction'><span class='fup'>2A</span><span class='bar'>/</span><span class='fdn'>6</span></span> &gt; <span class='fraction'><span class='fup'>2K</span><span class='bar'>/</span><span class='fdn'>3</span></span>  &gt; Q</td>	<td>เป็น</td>	<td width='45%'><span class='fraction'><span class='fup'>2A</span><span class='bar'>/</span><span class='fdn'>6</span></span> &gt; <span class='fraction'><span class='fup'>2K</span><span class='bar'>/</span><span class='fdn'>3</span></span>  &gt; Q<br>ค.ร.น. ของ 6 และ 3 คือ 6<br>เอา 6 คูณตลอด<br><span class='fraction'><span class='fup'>(6)2A</span><span class='bar'>/</span><span class='fdn'>6</span></span> &gt; <span class='fraction'><span class='fup'>(6)(2K)</span><span class='bar'>/</span><span class='fdn'>3</span></span>  &gt; (6)Q<br>2A &gt; 4K &gt; 6Q</td></tr></table></div></li><li>ถ้ามีเศษส่วน ที่เศษเป็นตัวเลขและส่วนเป็นตัวอักษร ให้กลับเศษเป็นส่วน ทุกตัว และเปลี่ยนเครื่องหมายเป็นตรงข้าม ถ้ามีเครื่องหมายเท่ากับรวมอยู่ด้วย ให้คงเครื่องหมายเท่ากับไว้ เช่น  <div style='margin-right:10px'><table width='100%'><tr>	<td width='45%'>3 &gt; <span class='fraction'><span class='fup'>2</span><span class='bar'>/</span><span class='fdn'>6B</span></span></td>	<td>เป็น</td>	<td width='45%'><span class='fraction'><span class='fup'>1</span><span class='bar'>/</span><span class='fdn'>3</span></span> &lt; <span class='fraction'><span class='fup'>6B</span><span class='bar'>/</span><span class='fdn'>2</span></span><br>แล้วจึงทำส่วนให้หมดไป โดยใช้ ค.ร.น. คูณตลอด</td></tr><tr>	<td width='45%'>3 &#x2265; <span class='fraction'><span class='fup'>2</span><span class='bar'>/</span><span class='fdn'>6B</span></span></td>	<td>เป็น</td>	<td width='45%'><span class='fraction'><span class='fup'>1</span><span class='bar'>/</span><span class='fdn'>3</span></span> &#x2264; <span class='fraction'><span class='fup'>6B</span><span class='bar'>/</span><span class='fdn'>5</span></span></td></tr></table></div></li><li>บางครั้งอาจจะต้องมีการปรับข้อสรุปของโจทย์ ให้ดูง่ายขึ้น เช่น โจทย์มีเครื่องหมาย &#x22;ไม่&#x22; ซึ่งจะต้องปรับให้เป็นเครื่องหมายปกติ หรือ ปรับเครื่องหมายลบให้เป็น บวก จะได้ดูง่ายขึ้น ทำง่ายขึ้น เช่น<br>2A + E &gt; 6E - 2D<br>อย่างนี้ ควรเอา 2D ไปบวกทั้งสองข้าง เพื่อให้ -2D หมดไป เป็น<br>2A + E + 2D&gt; 6E - 2D + 2D<br>2A + E + 2D&gt; 6E</li><li>ในแต่ละข้อสรุป <strong>ให้ตรวจสอบว่ามีตัวเชื่อม มากกว่า 1 ตัวเชื่อม หรือไม่</strong> และต้องพิสูจน์ความสัมพันธ์ผ่านทุกตัวเชื่อม<br>ถ้าได้ผลตรงกัน ให้สรุปตามนั้น ถ้าผ่านตัวเชื่อมหนึ่งได้ผลไม่แน่ชัด แต่อีกตัวเชื่อมหนึ่ง ได้ผลเป็นอย่างอื่น เช่น A &gt; B ให้สรุปว่า  A &gt; B เช่น<br>เงื่อนไขที่ 1: A &gt; B &gt; C &lt; D<br>เงื่อนไขที่ 2: B &gt; E &gt; D &gt; F<br>ข้อสรุป: A &gt; D<br><br>จาก A ไป D มี 2 เส้นทาง คือ ผ่าน B, C และผ่านตัวเชื่อม D<br>จาก A ไป D  ผ่าน B, C มีผลเป็นไม่แน่ชัด เพราะมีเครื่องหมายสวนทางกัน<br>จาก A ไป D  ผ่าน B (จาก เงื่อนไขที่ 1 ไปเงื่อนไขที่ 2) มีผลเป็น มากกว่า<br>กรณีนี้ ให้สรุปว่า A &gt; D<br><br><br>หรือ ถ้าผ่านตัวเชื่อมหนึ่งได้ผลอย่างหนึ่ง เช่น  A &lt; B  แต่ผ่านอีกตัวเชื่อมหนึ่ง ได้ผลเป็นอย่างอื่น เช่น A &gt; B ให้สรุปว่า ไม่แน่ชัด เพราะมีผลการพิสูจน์ได้มากกว่า 1 อย่าง</ol><strong>2. ยุบรวม</strong><br><p>การยุบรวม ให้ดูที่เครื่องหมาย เวลายุบรวม ให้ใช้เครื่องหมายที่มีความสำคัญสูงกว่า เครื่องหมายเรียงลำดับความสำคัญคือ</p><div style='margin-right:10px'><table width='100%'><tr>	<td style='text-align: center'>ความสำคัญ</td>	<td style='text-align: center'>เครื่องหมาย</td></tr><tr>	<td>ความสำคัญสูงสุด</td>	<td>&gt; และ &lt;</td></tr><tr>	<td>ความสำคัญปานกลาง</td>	<td>&#x2265; และ &#x2264;</td></tr><tr>	<td>ความสำคัญน้อย</td>	<td> = </td></tr><tr>	<td colspan=2>สำหรับเครื่องหมาย  &#x226F; เครื่องหมาย &#x226E; เครื่องหมาย &#x2271; และเครื่องหมาย &#x2270; ให้เปลี่ยนเป็นเครื่องหมายปกติ (ตามข้อ 1) เสียก่อน <br>ส่วนเครื่องหมาย ไม่เท่ากัน (&#x2260;) ไม่มีการยุบรวม ถ้าพบเครื่องหมายนี้อยู่คั่นกลาง คือให้ถือว่าเป็น ไม่แน่ชัด ให้ถือว่าเป็นไฟแดง ห้ามผ่านนั่นเอง</td></tr></table></div>ตัวอย่าง<div style='margin-right:10px'><table width='100%'><tr>	<td width='40%' style='text-align: center'>เงื่อนไข</td>	<td style='text-align: center'>ยุบรวมเป็น</td></tr><tr>	<td>A &gt; B &gt; C &#x2265; D</td>	<td>A &gt; D</td></tr><tr>	<td>A &lt; B &#x2264; C &lt; D</td>	<td>A &lt; D</td></tr><tr>	<td>A &lt; B &#x2264; C = D</td>	<td>A &lt; D</td></tr><tr>	<td>A &gt; B &#x2264; C = D</td>	<td>A &gt; D</td></tr><tr>	<td>A = B &#x2265; C = D</td>	<td>A &#x2265; D</td></tr><tr>	<td>A &#x2264; B &#x2264; C = D</td>	<td>A &#x2264; D</td></tr><tr>	<td>A &gt; B &#x2264; C &lt D</td>	<td>ระหว่าง A และ D เป็น ไม่แน่ชัด (เครื่องหมายสวนทางกัน)</td></tr><tr>	<td>A &gt; B &gt; C &#x2260; D</td>	<td>ระหว่าง A และ D เป็น ไม่แน่ชัด (เจอไฟแดง)</td></tr></table></div><br><strong>3. ตัดสิน จริง-เท็จ-ไม่แน่ชัด</strong><ol>การตัดสิน ให้เอาเครื่องหมายจากผลที่ได้จากการพิสูจน์เงื่อนไข ไปเปรียบเทียบกับเครื่องหมายในข้อสรุปของโจทย์ <br><br><li>เป็นจริง มี 2 กรณี คือ<ul><li>เครื่องหมายของข้อสรุป เหมือนกับ เครื่องหมายในผลการพิสูจน์ <br>ตัวอย่าง<div style='margin-right:10px'><table width='100%'><tr>	<td style='text-align: center'>ข้อสรุป</td>	<td style='text-align: center'>ผลการพิสูจน์เงื่อนไข</td>	<td style='text-align: center'>การตัดสิน</td></tr><tr>	<td>A &gt; C</td>	<td>A &gt; C</td>	<td>เป็นจริง</td></tr><tr>	<td>A &#x2264; B</td>	<td>A &#x2264; B</td>	<td>เป็นจริง</td></tr></table></div></li><li>เครื่องหมายของข้อสรุป <u><strong>ครอบคลุม</strong></u> เครื่องหมายในผลการพิสูจน์ เช่น เครื่องหมาย มากกว่าหรือเท่ากับ (&#x2265;) มี 2 เครื่องหมายคือ เครื่องหมาย มากกว่า (&gt;) และเครื่องหมาย เท่ากับ (=) ถ้าในข้อสรุป เป็นเครื่องหมาย มากกว่าหรือเท่ากับ และเราพิสูจน์เงื่อนไข ได้เครื่องหมาย มากกว่า หรือ เครื่องหมาย เท่ากับ อย่างใดอย่างหนึ่ง ก็ถือว่า เป็นจริง<br>แต่ถ้าไม่ครอบคลุมทั้งหมด จะถือว่า ไม่แน่ชัด เช่น ถ้าในข้อสรุป เป็นเครื่องหมาย มากกว่า (&gt;) และเราพิสูจน์เงื่อนไข ได้เครื่องหมายมากกว่าหรือเท่ากับ (&#x2265;) อย่างนี้ จะได้ผลเป็น ไม่แน่ชัด เพราะ เครื่องหมายในข้อสรุป <u>ไม่ครอบคลุม</u> เครื่องหมาย ของผลการพิสูจน์เงื่อนไขทั้งหมดทุกตัว ครอบคลุมได้เพียงบางตัวเท่านั้น<br>ตัวอย่าง<br><div style='margin-right:10px'><table width='100%'><tr>	<td style='text-align: center'>ข้อสรุป</td>	<td style='text-align: center'>ผลการพิสูจน์เงื่อนไข</td>	<td style='text-align: center'>การตัดสิน</td></tr><tr>	<td>A &#x2265; B</td>	<td>A &gt; B</td>	<td>เป็นจริง</td></tr><tr>	<td>A &#x2265; B</td>	<td>A = B</td>	<td>เป็นจริง</td></tr><tr>	<td>A &#x2264; B</td>	<td>A &lt; B</td>	<td>เป็นจริง</td></tr></table></div></ul><!--  จบหัวข้อย่อย เป็นจริง  --><br><li>เป็นเท็จ<br>	เมื่อเครื่องหมายในข้อสรุป <strong>ไม่เหมือนกับเครื่องหมาย</strong> ในผลการพิสูจน์เงื่อนไข แม้แต่ตัวเดียว คือ ต่างกันโดยสิ้นเชิง<br>ตัวอย่าง<br><div style='margin-right:10px'><table width='100%'><tr>	<td style='text-align: center'>ข้อสรุป</td>	<td style='text-align: center'>ผลการพิสูจน์เงื่อนไข</td>	<td style='text-align: center'>การตัดสิน</td></tr><tr>	<td>A &gt; B</td>	<td>A &lt; B</td>	<td>เป็นเท็จ</td></tr><tr>	<td>A &#x2265; B</td>	<td>A &lt; B</td>	<td>เป็นเท็จ</td></tr><tr>	<td>A &#x2264; B</td>	<td>A &gt; B</td>	<td>เป็นเท็จ</td></tr></table></div></li><br><li>ไม่แน่ชัด <br>คือ อาจจะมากกว่า น้อยกว่า หรือเท่ากัน ก็เป็นไปได้<br>ความไม่แน่ชัด เกิดขึ้นในกรณีต่อไปนี้<ul>	<li>เครื่องหมายในข้อสรุป ไม่ครอบคลุม เครื่องหมายในผลการพิสูจน์เงื่อนไขทั้งหมด คือครอบคลุมได้เพียงบางส่วนเท่านั้น เช่น	<div style='margin-right:10px'><table width='100%'><tr>	<td style='text-align: center; width: 40%'>ข้อสรุป</td>	<td style='text-align: center'>ผลการพิสูจน์เงื่อนไข</td>	<td style='text-align: center; width: 40%'>การตัดสิน</td></tr>	<tr>		<td>A &gt; C</td>		<td>A &#x2265; C</td>		<td>ไม่แน่ชัด<br>เครื่องหมาย มากกว่า ในข้อสรุป คลุมเครื่องหมาย มากกว่าในผลพิสูจน์เงื่อนไข แต่ ไม่ครอบคลุมเครื่องหมายเท่ากับ ในผลพิสูจน์เงื่อนไข จึงครอบคลุมได้เพียงบางส่วนเท่านั้น</td>	</tr>	<tr>		<td>A = C</td>		<td>A &#x2265; C</td>		<td>ไม่แน่ชัด</td>	</tr>	<tr>		<td>A &lt; C</td>		<td>A &#x2264; C</td>		<td>ไม่แน่ชัด</td>	</tr>		<tr>		<td>A &lt; C</td>		<td>A &#x2264; C</td>		<td>ไม่แน่ชัด</td>	</tr>		<tr>		<td>A &#x2264; C</td>		<td>A &#x2265; C</td>		<td>ไม่แน่ชัด</td>	</tr>	</table>	</div>	</li>	<li>มีเครื่องหมายสวนทางกัน </li>	<li>มีเครื่องหมายไม่เท่ากัน</li>	<li>กรณีพบว่า ไม่แน่ชัด ให้ตรวจสอบต่ออีกหน่อยว่า มีตัวเชื่อมอื่นอีกหรือไม่  ถ้าผ่านตัวเชื่อมอีกตัว จะทำให้ทราบข้อเท็จจริงหรือไม่ ถ้าทราบ ก็แสดงว่า ข้อนี้ ไม่ได้ตอบว่า ไม่แน่ชัด นะครับ ให้ตอบตามตัวเชื่อมใหม่ ในระยะหลัง ๆ นี้ มักจะพบบ่อย ในข้อสอบ ก.พ. มากขึ้น</li></ul></li></ol>  <!-- จบหัวข้อ เป็นจริง เป็นเท็จ ไม่แน่ชัด  --> </body></html>";
    show_how_to(1, false, thisJson);  // แสดงหน้าคำอธิบาย
    break;

case  "normal":


console.log("lastQstnArr in normal: " + lastQstnArr);
// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู normal
// https://stackoverflow.com/questions/4556099/how-do-you-search-an-array-for-a-substring-match
var thisNumDat = lastQstnArr.find(element => element.includes("normal"));


console.log("thisNumDat for normal in changeData: " + thisNumDat);  // normal_cndtngxyz1


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
    thisJson = normal_cndtng;
    current_page = thisLNumber;
    jsonName_id = "exMenu_normal_cndtng";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
        changePage(thisLNumber, false, thisJson);


    break;


case "fraction":

// alert("lastQstnArr : " + lastQstnArr)

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู fraction
var thisNumDat = lastQstnArr.find(element => element.includes("fraction"));
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
    thisJson = fraction_cndtng;
    current_page = thisLNumber;
    jsonName_id = "exMenu_fraction_cndtng";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
        changePage(thisLNumber, false, thisJson);
    

    break;

case  "min_max":

// alert("lastQstnArr : " + lastQstnArr)

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู fraction
var thisNumDat = lastQstnArr.find(element => element.includes("min_max"));
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
        thisJson = min_max_cndtng;
        current_page = thisLNumber;
        jsonName_id = "exMenu_min_max_cndtng";

        changePage(thisLNumber, false, thisJson);

    break;
//
	case  "multi_connection":

 // alert("lastQstnArr : " + lastQstnArr);

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู multi_connection
var thisNumDat = lastQstnArr.find(element => element.includes("multi_connection"));
// alert("thisNumDat: " + thisNumDat);  // multi_connection_cndtngxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

    //    alert("thisLNumber: " + thisLNumber);


  	// clear input field
    // document.getElementById('myInput').value = '';
	    document.getElementById('showAnswer').style.display ='none';
       // shuffle(alternate_plus_multiply);
        thisJson = multi_connection_cndtng;
        current_page = thisLNumber;
        jsonName_id = "exMenu_multi_connection_cndtng";

        changePage(thisLNumber, false, thisJson)

    break;


case  "plus_minus":

// alert("lastQstnArr : " + lastQstnArr)

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู plus_minus
var thisNumDat = lastQstnArr.find(element => element.includes("plus_minus"));
// alert("thisNumDat: " + thisNumDat);  // plus_minus_cndtngxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย



  	// clear input field
    // document.getElementById('myInput').value = '';
	// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;
	document.getElementById('showAnswer').style.display ='none';
    shuffle(staticMultiply_incredmentPlus);
    thisJson = plus_minus_cndtng;
    current_page = thisLNumber;
    jsonName_id = "exMenu_plus_minus_cndtng";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล

    changePage(thisLNumber, false, thisJson);

    break;


case "mixed":


// getSymbolCndngExFromPref  // เอาข้อมูลแบบฝึกหัดที่เก็บไว้ใน sharePref
// alert("lastQstnArr: " + lastQstnArr);
// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู multi_connection
var thisNumDat = lastQstnArr.find(element => element.includes("mixed"));
// alert("thisNumDat: " + thisNumDat);  // mixed_cndtngxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

    // document.getElementById('myInput').value = '';  // ลบที่พิมพ์คำตอบก่อนหน้านี้ ในช่อง input
	document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่

// alert("mixed_cndtng: " + mixed_cndtng);
 thisJson = mixed_cndtng;


	current_page = 1;  // เริ่มที่หน้า 1
	jsonName_id = "exMenu_mixed_cndtng";  // ส่งชื่อตัวแปร json_id เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
    current_page = thisLNumber;
//	alert("thisJson: " + thisJson.length);

  //  changePage(1, false, thisJson);  // ส่งข้อมูลไปแสดง หน้า, ยังไม่เริ่มจับเวลา(เพราะเพิ่งเข้ามา), ไฟล์ข้อมูลที่เลือก
    changePage(thisLNumber, false, thisJson);  // ส่งข้อมูลไปแสดง หน้า, ยังไม่เริ่มจับเวลา(เพราะเพิ่งเข้ามา), ไฟล์ข้อมูลที่เลือก


    break;

default:
  	// clear input field
//    // document.getElementById('myInput').value = '';
	document.getElementById('showAnswer').style.display ='none';
	shuffle(objJsonSimple);
    thisJson =  normal_cndtng;
	current_page = 1;
    changePage(1, false, thisJson);
}
}

numOfQuestions = normal_cndtng.length + fraction_cndtng.length + min_max_cndtng.length + multi_connection_cndtng.length + plus_minus_cndtng.length + mixed_cndtng.length;