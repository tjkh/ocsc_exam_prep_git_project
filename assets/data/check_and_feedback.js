document.getElementById("second_div").scrollIntoView();
document.getElementById("first_div").scrollIntoView();

function checkAns(regn, ans) {
	
    var radios = document.getElementsByName(regn);
    var formValid = false;

    var i = 0;
    while (!formValid && i < radios.length) {
        if (radios[i].checked) {
		formValid = true;
		//check answer
		if(radios[i].value == ans){
			document.getElementById("myMessage").innerHTML = radios[i].value +"<br>ถูกต้อง";
			modal.style.display = "block";
			//alert(radios[i].value +"\nถูกต้อง"); return false;
		}else{
			document.getElementById("myMessage").innerHTML = radios[i].value +"<br>ยังไม่ถูก";
			modal.style.display = "block";
			//alert(radios[i].value +"\nยังไม่ถูก"); return false;
		}
		}
        i++;        
    }
    if (!formValid) {
			document.getElementById("myMessage").innerHTML = "ยังไม่ได้เลือกคำตอบ";
			modal.style.display = "block";
	}
}



