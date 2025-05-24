
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

case "intro_page":

 swipeEnabled = false; // enable swipe
// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_pause.disabled = true;
	btn_reset.disabled = true;
	btn_start.disabled = true;
	resetCountDown();

	document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่ ถ้ามาจากหน้าที่มีเฉลย
    // ไฟล์ html อธิบายวิธีทำ ทั้งไฟล์เอามาใส่ในตัวแปรเลยตรง ๆ ถ้าจะแก้ ให้คัดลอก ไปแก้ใน editPlus เอา \n เพิ่มต่อจาก <br> เพื่อให้ขึ้นบรรทัดใหม่ และเวลาจะเอามาไว้ที่นี่ ให้ตัด \n ออกก่อน

 thisJson ="<!DOCTYPE html><html lang='th'> <head>    <meta charset='UTF-8'>    <meta name='viewport' content='width=device-width, initial-scale=1'>     <link rel='stylesheet' type='text/css' href='my_style.css'> <style>        body {            font-family: sans-serif;			margin: 12px; /* Set default body margin */			        }        .container {		width: 100%;             display: flex;            flex-direction: column;            align-items: center; /* Center horizontally */            margin-bottom: 20px;        }        .text-content {    padding-left: 10px; padding-right: 4px;        text-align: left; /* Align text to the left */            margin-bottom: 10px;            width: 100%; /* Match image container width */        }		        .text-center {				font-size: 20px;            text-align: center; /* Align text to the left */            margin-bottom: 10px;            width: 80%; /* Match image container width */        }        .image-container {            width: 80%;            display: flex;            justify-content: center; /* Center image horizontally */        }        img {            max-width: 100%;            height: auto;        }    </style><title>intro_page</title> </head>  <body> <h3>เทคนิคการทำข้อสอบอนุกรม</h3><div  style='display: inline-block; text-align: left; padding-left: 3px; padding-right: 10px'><ul>   <li>ข้อสอบอนุกรมของก.พ. เป็นข้อสอบที่วัดความความถนัดด้านตัวเลข อนุกรม เป็นเรื่องที่เกี่ยวกับการเพิ่มขึ้นและลดลงของตัวเลข ในรูปแบบต่าง ๆ การฝึกทำข้อสอบมาก ๆ จะทำให้คุ้นเคยกับรูปแบบของอนุกรม และสามารถทำได้อย่างรวดเร็ว</li>      <li>เวลาเป็นเรื่องสำคัญ โจทย์อนุกรมของ ก.พ. จะมีทั้งข้อยาก และข้อง่าย ในการทำข้อสอบจริง ถ้าดูแล้วยังจับรูปแบบไม่ได้ ควรข้ามไปทำข้ออื่นก่อน จะได้ไม่เสียเวลา เมื่อทำข้อสอบข้ออื่น ๆ ที่มั่นใจเสร็จแล้ว จึงค่อยกลับมาคิดอีกที</li>   </ul>   </div> <br><br><br> <div class='text-center'><strong>รูปแบบอนุกรมที่มักจะพบ</strong><br><div style='font-size:12px'>(ดูรายละเอียดเพิ่มในเมนู หลักการทำข้อสอบอนุกรม)</div></div>    <div class='container'>        <div class='text-content'>            <p><h3>เพิ่มลดเท่ากัน</h3></p>            <p>หาได้โดยการตีแฉก ซึ่งจะเห็นว่า มีการเพิ่มขึ้น หรือ ลดลงเท่า ๆ กัน</p>        </div>        <div class='image-container'>            <img src='images/real_1218243036.png' alt='Image 1'>        </div>    </div>    <div class='container'>        <div class='text-content'>            <p><h3>สลับบวกกับคูณ</h3></p>            <p>มีเครื่องทางคณิตศาสตร์สลับกัน ตัวเลขอาจจะเป็นเลขเดียวกัน หรือ เพิ่ม-ลด อย่างมีระบบ</p>        </div>        <div class='image-container'>            <img src='images/real_42408077231.png' alt='Image 2'>        </div>    </div>    <div class='container'>        <div class='text-content'>            <p><h3>เพิ่ม-ลด เลขคู่-เลขคี่</h3></p>            <p>มีการเพิ่มขึ้นหรือลดลง เป็นเลขคู่ หรือ เลขคี่ ซึ่งอาจจะเป็นชุดตัวเลขธรรมดา หรือ เศษส่วน ก็ได้</p>        </div>        <div class='image-container'>            <img src='images/nbr_36111821246.png' alt='Image 2'>        </div>    </div>    <div class='container'>        <div class='text-content'>            <p><h3>แบบกั้นห้อง</h3></p>            <p>มีการแบ่งออกเป็นชุด ๆ อาจจะมีลักษณะสะสม หรือไม่ ก็ได้ มักจะสังเกตเห็นว่า ตัวเลขแต่ละชุดต่างกันอย่างมาก ชัดเจน</p>        </div>        <div class='image-container'>            <img src='images/181620120118122732.png' alt='Image 2'>        </div>    </div>    <div class='container'>        <div class='text-content'>            <p><h3>ยกกำลังคงที่แต่เพิ่มเลขฐาน</h3></p>            <p>ส่วนมากมักจะยกด้วยกำลังสอง หรือสาม ถ้าจำเลขที่ยกกำลังสองหรือสามได้ จะได้เปรียบ เช่น  4, 9, 16, 25, 36, 49, 64 และ 81 เป็นต้น เลขเหล่านี้เป็นเลขยกกำลังสอง คือ 2x2=4; 3x3=9 ...</p>        </div>        <div class='image-container'>            <img src='images/ocsc_ans_01.png' alt='Image 2'>        </div>    </div>    <div class='container'>        <div class='text-content'>            <p><h3>แบบสะสม</h3></p>            <p>มีการเพิ่มขึ้นหรือลดลง โดยใช้ตัวหน้า 2 หรือ 3 ตัว เป็นหลัก เช่น ตัวที่ 1 + ตัวที่ 2 = ตัวที่ 3<br>แบบสะสม ตรวจสอบได้ง่าย ควรตรวจสอบด้วยวิธีนี้ก่อน ก่อนที่จะใช้วิธีการอื่น ๆ</p>        </div>        <div class='image-container'>            <img src='images/nbr_50279.png' alt='Image 2'>        </div>    </div>    <div class='container'>        <div class='text-content'>            <p><h3>คูณแล้วบวก</h3></p>            <p>เป็นวิธีผสม เช่นอาจจะมีการคูณด้วยค่าคงที่ แล้วบวกด้วยค่าคงที่ หรือค่าที่เพิ่มขึ้นอย่างมีระบบ </p>        </div>        <div class='image-container'>            <img src='images/num_51343177.png' alt='Image 2'>        </div>    </div>    <div class='container'>        <div class='text-content'>            <p><h3>เศษส่วน</h3></p>            <p>มีความสัมพันธ์ที่เป็นไปได้หลายลักษณะ เช่น เศษทั้งหมด เป็นอนุกรม 1 ชุด ส่วนทั้งหมด เป็นอนุกรมอีก 1 ชุด หรือ เศษของพจน์หลังคือ เศษและส่วนของพจน์หน้ารวมกัน เป็นต้น</p>        </div>        <div class='image-container'>            <img src='images/real_8984756245.png' alt='Image 2'>        </div>    </div>    <div class='container'>        <div class='text-content'>            <p><h3>การตีแฉก</h3></p>            <p>การตีแฉก เป็นการหาความแตกต่างระหว่างคู่ มักจะใช้ตัวหลังเป็นตัวตั้งแล้วลบด้วยตัวหน้า หลักสำคัญคือเรื่องเครื่องหมายบวก หรือ ลบ การตึแฉกไม่ควรเกิน 3 ชั้น ถ้าฝึกมาก ๆ จนชำนาญ จะเห็นว่า เป็นเรื่องที่ไม่ยากมากนัก</p>        </div>        <div class='image-container'>            <img src='images/272930343743485663.png' alt='Image 2'>        </div>    </div>    <div class='container'>        <div class='text-content'>            <p><h3>วิธีอื่น ๆ</h3></p>            <p>นอกจากวิธีข้างต้นแล้ว ยังมีการผสมผสาน พลิกแพลง อีกหลายอย่าง แต่ทั้งนี้ ถ้าได้มีการฝึกฝน ก็จะสามารถคาดเดาได้ <br>สิ่งสำคัญคือ อย่างไปเสียเวลากับข้อใดข้อหนึ่งมากนัก จะทำให้เสียเวลาทำข้อง่ายไปอย่างน่าเสียดาย ถ้าเห็นว่าข้อใดน่าจะยาก ก็ให้ข้ามไปก่อน เมื่อมีเวลาจึงกลับมาคิดภายหลัง นี่เป็นเทคนิคการทำข้อสอบ ก.พ. ภาค ก. ที่ดี</p>        </div>        <div class='image-container'>            <img src='images/real_112233.png' alt='Image 2'>        </div>    </div></body></html>";    show_intro_page(1, false, thisJson);  // แสดงหน้าคำอธิบาย

  show_how_to(1, false, thisJson);

    break;

case "fraction":

var thisNumDat = lastQstnArr.find(element => element.includes("fraction"));


console.log("thisNumDat for fraction in changeData: " + thisNumDat);  // normal_cndtngxyz1

var thisLNumberArr = thisNumDat.split(":xyz:");
        thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

console.log("lastQstnArr from Flutter - อนุกรม: " + lastQstnArr);
console.log("thisNumDat แยกจาก lastQstnArr from Flutter - อนุกรม: " + thisNumDat);
console.log("thisLNumber ที่ส่งเข้ามากับ lastQstnArr จาก Flutter - อนุกรม: " + thisLNumber);


// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ

	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;
  	// clear input field
    // document.getElementById('myInput').value = '';
	document.getElementById('showAnswer').style.display ='none';
    //	shuffle(normal_cndtng);



	current_page = thisLNumber;
	thisJson =  fraction;  // เศษส่วน
	jsonName_id = "exMenu_fraction"; // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
    changePage(thisLNumber, false, thisJson);  
    //doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน

    break;


case "add_substract_equally":

console.log("lastQstnArr in add_substract_equally: " + lastQstnArr);


   // แยกข้อมูลที่มาจาก Flutter เอาเฉพาะชื่อเมนู
    var thisNumDat = lastQstnArr.find(element => element.includes("add_substract_equally"));
 //   console.log("thisNumDat for add_substract_equally in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    
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
	    thisJson =  objJsonSimple;  // เพิ่ม ลด เท่ากัน
	    jsonName_id = "exMenu_add_substract_equally";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
        changePage(thisLNumber, false, thisJson);
	//doFraction();

    break;
	
	case  "accumulate":

	console.log("lastQstnArr in accumulate: " + lastQstnArr);

// alert("lastQstnArr : " + lastQstnArr)

// แยกข้อมูลที่มาจาก Flutter เอาเฉพาะเมนู fraction
 var thisNumDat = lastQstnArr.find(element => element.includes("accumulate"));
 console.log("thisNumDat for accumulate in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
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
    thisJson = accumulate;
	current_page = thisLNumber;
	   jsonName_id = "exMenu_accumulate";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
	   
    changePage(thisLNumber, false, thisJson);
    //doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;
//
case  "alternate_plus_multiply":



		 
    // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
    var thisNumDat = lastQstnArr.find(element => element.includes("alternate_plus_multiply"));
    console.log("thisNumDat for alternate_plus_multiply in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    
		var thisLNumberArr = thisNumDat.split(":xyz:");
    thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

//
	// clear input field

 	document.getElementById('showAnswer').style.display ='none';
 //  shuffle(alternate_plus_multiply);
    thisJson = alternate_plus_multiply;
	current_page = thisLNumber;
	 jsonName_id = "exMenu_alternate_plus_multiply";  
	 
    changePage(thisLNumber, false, thisJson)
    //doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;

//case  "add_substract_odd_even_increment":
//  	    // clear input field
//        // document.getElementById('myInput').value = '';
//	    document.getElementById('showAnswer').style.display ='none';
//	    shuffle(add_substract_odd_even_increment);
//        thisJson = add_substract_odd_even_increment;
//        changePage(1, false, thisJson);
//    break;
case "add_increment_base_const_power":
    

     // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
       var thisNumDat = lastQstnArr.find(element => element.includes("add_increment_base_const_power"));
       console.log("thisNumDat for add_increment_base_const_power in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    
	var thisLNumberArr = thisNumDat.split(":xyz:");
    thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย



  	// clear input field
    // document.getElementById('myInput').value = '';	
		// ทำให้ปุ่มจับเวลาทำงาน เพราะ disable ตอน อ่านวิธีทำ
	btn_reset.disabled = false;
	btn_start.disabled = false;
document.getElementById('showAnswer').style.display ='none';
// shuffle(add_increment_base_const_power);
    thisJson = add_increment_base_const_power;
	current_page = thisLNumber;
	jsonName_id = "exMenu_add_increment_base_const_power"; 
   	changePage(thisLNumber, false, thisJson);
    // doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;
//case  "pair_diff":
//  	// clear input field
//    // document.getElementById('myInput').value = '';
//	document.getElementById('showAnswer').style.display ='none';
//	shuffle(pair_diff);
//    thisJson = pair_diff;
//    changePage(1, false, thisJson);
//    break;
case  "add_substract_odd_even_increment":
//
//
        // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
          var thisNumDat = lastQstnArr.find(element => element.includes("add_substract_odd_even_increment"));
          console.log("thisNumDat for add_substract_odd_even_increment in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    
	var thisLNumberArr = thisNumDat.split(":xyz:");
    thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย


	document.getElementById('showAnswer').style.display ='none'; // ซ่อนเฉลยที่ปรากฎอยู่ 

	// shuffle(add_substract_odd_even_increment);
     thisJson = add_substract_odd_even_increment;
     current_page = thisLNumber;
	   jsonName_id = "exMenu_add_substract_odd_even_increment";  
	changePage(thisLNumber, false, thisJson);
    // doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน

	
	break;
case  "staticMultiply_incredmentPlus":

console.log("เมนู คูณแล้ว หน้า (current_page):  " + current_page);


          // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
             var thisNumDat = lastQstnArr.find(element => element.includes("staticMultiply_incredmentPlus"));
             console.log("thisNumDat for staticMultiply_incredmentPlus in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
			 
    var thisLNumberArr = thisNumDat.split(":xyz:");
    thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย
    
	document.getElementById('showAnswer').style.display ='none'; // ซ่อนเฉลยที่ปรากฎอยู่ 
  // shuffle(staticMultiply_incredmentPlus);
    thisJson = staticMultiply_incredmentPlus;
   current_page = thisLNumber;
   jsonName_id = "exMenu_staticMultiply_incredmentPlus"; 
    changePage(thisLNumber, false, thisJson);
    // doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน

    break;
case  "sectmented":

            // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
                thisNumDat = lastQstnArr.find(element => element.includes("sectmented"));
                console.log("thisNumDat for sectmented in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    var thisLNumberArr = thisNumDat.split(":xyz:");
    thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย


	document.getElementById('showAnswer').style.display ='none';
	// shuffle(sectmented);
    thisJson = sectmented;
	current_page = thisLNumber;
	jsonName_id = "exMenu_sectmented";  
    changePage(thisLNumber, false, thisJson);
    //doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;
	
case  "pair_diff":
     

   // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
   var thisNumDat = lastQstnArr.find(element => element.includes("pair_diff"));
   console.log("thisNumDat for pair_diff in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    
	var thisLNumberArr = thisNumDat.split(":xyz:");
    thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

	document.getElementById('showAnswer').style.display ='none';
//	shuffle(pair_diff);
    thisJson = pair_diff;
	current_page = thisLNumber;
	jsonName_id = "exMenu_pair_diff"; 
    changePage(thisLNumber, false, thisJson);
    // doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;
	
case "mixed":

     // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
      var thisNumDat = lastQstnArr.find(element => element.includes("mixed"));
      console.log("thisNumDat for mixed in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
	  
    var thisLNumberArr = thisNumDat.split(":xyz:");
    thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย

	document.getElementById('showAnswer').style.display ='none';  // ซ่อนเฉลยที่ปรากฎอยู่
const mixedArr = objJsonSimple.concat(accumulate, add_increment_base_const_power, add_substract_odd_even_increment, staticMultiply_incredmentPlus, sectmented, pair_diff, fraction, old_exam, extra);
	console.log("mixed - is_Bought: " + is_Bought);
//	if(is_Bought == true){
	    shuffle(mixedArr); // เอา list ข้อมูล มาสลับเสียใหม่ ไม่ให้เรียงลำดับ -- เฉพาะที่ซื้อแล้ว
//	}


    thisJson =  mixedArr;  
	//current_page = thisNumber;
	currecnt_page = 1; // เพราะมีการเอาทุกตัวมารวมกันแล้วสลับข้อ จึงให้เริ่มที่ 1 ใหม่ทุกครั้ง เพราะ แต่ละครั้งที่เริ่มใหม่ ข้อจะไม่เหมือนเดิม
	jsonName_id = "exMenu_mixed"; 
    changePage(1, false, thisJson);  // ให้เริ่มที่หน้า 1 เพราะมีการสลับข้อทั้งหมด
    // doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;
case  "old_exam":

        // ไปเอาข้อสุอท้ายของเรื่องนี้ที่เคยทำไว้ ส่งมาจาก Flutter ด้วย getLastQstnNum()
         var thisNumDat = lastQstnArr.find(element => element.includes("old_exam"));
         console.log("thisNumDat for old_exam in changeData: " + thisNumDat);  // ชื่อเมนู ข้อสุดท้ายที่ทำ คั่นด้วย xyz เช่น normal_cndtngxyz1
    
	var thisLNumberArr = thisNumDat.split(":xyz:");
    thisLNumber = thisLNumberArr[1]; // ตัวที่ 2 คือ ข้อสุดท้าย


	document.getElementById('showAnswer').style.display ='none';
//	shuffle(old_exam);
    thisJson = old_exam;
	current_page = thisLNumber;
	jsonName_id = "exMenu_old_exam"; 
    changePage(thisLNumber, false, thisJson);
    // doFraction();  // จัดการเส้นคั่นระหว่างเศษกับส่วน
    break;
default:
	btn_pause.disabled = false;
	btn_reset.disabled = false;
	btn_start.disabled = false;  
	document.getElementById('showAnswer').style.display ='none'; // ซ่อนเฉลย
	// shuffle(objJsonSimple);
    thisJson =  objJsonSimple;
	current_page = 1;
	 jsonName_id = "exMenu_add_substract_equally";  // ส่งชื่อตัวแปร json เพื่อจะได้เอาไปเก็บไว้ใน ฐานข้อมูล
    changePage(1, false, thisJson);
}
}

numOfQuestions = (sectmented.length + add_increment_base_const_power.length + staticMultiply_incredmentPlus.length + add_substract_odd_even_increment.length + alternate_plus_multiply.length + fraction.length + extra.length + accumulate.length + old_exam.length) * 2;  // ที่คูณ 2 เพราะ mixArr เอาทุกอันมารวมกัน แล้วสลับที่ กลายเป็น คละรูปแบบ จึงต้องคูณ 2 เพราะมันเพิ่มอีกเท่าตัว
console.log("numOfQuestions: " + numOfQuestions);

