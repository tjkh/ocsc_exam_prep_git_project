function show_hide_explanation(my_div, btn_name, q_num, isFull) {
 var this_div = document.getElementById(my_div);
 var this_button = document.getElementById(btn_name);
  var this_q_num = document.getElementById(q_num);
  var isPremium =  isFull;
 // alert ("isPremium: " + isPremium.value + "    " + my_div);
 // var isPremium = 0;
    if (this_div.style.display !== 'none') {
        this_div.style.display = 'none';
		this_button.value = '\u0E14\u0E39\u0E04\u0E33\u0E2D\u0E18\u0E34\u0E1A\u0E32\u0E22';
		this_button.style.color = 'blue';
		this_q_num.scrollIntoView()
    }
    else {
		  if (isPremium !== '1'){
			  // ถ้าไม่เท่ากับ 1 แสดงว่า เป็นรุ่นจำกัดใช้
			var message = "เฉลยคำตอบของข้อนี้ มีเฉพาะในรุ่นเต็ม (Full Version) เท่านั้น<br> รุ่น Premium ราคาแค่ 199 บาท <br><br>";
			 this_div.innerHTML = message;
		} //if (isPremium !== 1)
        this_div.style.display = 'block';
        this_button.value = '\u0E1B\u0E34\u0E14\u0E04\u0E33\u0E2D\u0E18\u0E34\u0E1A\u0E32\u0E22';
		this_button.style.color = 'red';
    }
};

function checkAns(regn, ans, ans_div, isFull) {
    var radios = document.getElementsByName(regn);
	var answer_div = document.getElementById(ans_div);
    var formValid = false;
	var isPremium = isFull;
//	alert ("isPremium: " + isPremium);
    var i = 0;

if (isPremium !== '1')
  {
	  //alert ("ตรวจและเฉลย เฉพาะในรุ่น Premium เท่านั้น\nรุ่น Premium ราคา 190 บาท เท่านั้น\nซื้อได้ที่ https://www.thongjoon.com")
			var message = "ตรวจคำตอบของข้อนี้ มีเฉพาะในรุ่นเต็ม (Full Version) เท่านั้น<br> รุ่นเต็ม ราคาเพียง 199 บาท <br><br>";
			 answer_div.innerHTML = message;
			answer_div.style.backgroundColor = "#ff6600";
			answer_div.style.color = "#ffffff";
			answer_div.style.display = "block";

  }else{


    while (!formValid && i < radios.length) {
        if (radios[i].checked) {
  formValid = true;

  //check answer
  if(radios[i].value == ans){
	  answer_div.innerHTML = radios[i].value +"   ถูกต้อง";
     answer_div.style.backgroundColor = "yellow";
	 answer_div.style.color = "#339900";
	 answer_div.style.display = "block";
	//playSound_correct();
//  document.getElementById(ans_div).style.display = "block";
 //  document.getElementById("myMessage").innerHTML = radios[i].value +"<br>ถูกต้อง";
 //  modal.style.display = "block";
   //alert(radios[i].value +"\nถูกต้อง"); return false;
  }else{
	 answer_div.innerHTML = radios[i].value +"  ยังไม่ถูก";
	  answer_div.style.backgroundColor = "#ff6600";
	  answer_div.style.color = "#ffffff";
	 answer_div.style.display = "block";
	// playSound_wrong();
   // document.getElementById("myMessage").innerHTML = radios[i].value +"<br>ยังไม่ถูก";
   // modal.style.display = "block";
   //alert(radios[i].value +"\nยังไม่ถูก"); return false;
  }
  }
        i++;        
    }
    if (!formValid) {
document.getElementById(ans_div).innerHTML = "ยังไม่ได้เลือกคำตอบ";
document.getElementById(ans_div).style.backgroundColor = "#ffff99";
document.getElementById(ans_div).style.color = "#000000";

document.getElementById(ans_div).style.display = "block";
//playSound_wrong();
//   document.getElementById("myMessage").innerHTML = "ยังไม่ได้เลือกคำตอบ";
//   modal.style.display = "block";
 }
}  // end of  isPremium
}

function hide_div_feedback(whatDiv) {
    var thisDiv = document.getElementById(whatDiv);
        thisDiv.style.display = 'none';
}
