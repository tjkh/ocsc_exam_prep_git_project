 var InstantSearch = {

     "highlight": function (container, highlightText)
     {
         var internalHighlighter = function (options)
         {

             var id = {
                 container: "container",
                 tokens: "tokens",
                 all: "all",
                 token: "token",
                 className: "className",
                 sensitiveSearch: "sensitiveSearch"
             },
             tokens = options[id.tokens],
             allClassName = options[id.all][id.className],
             allSensitiveSearch = options[id.all][id.sensitiveSearch];


             function checkAndReplace(node, tokenArr, classNameAll, sensitiveSearchAll)
             {
                 var nodeVal = node.nodeValue, parentNode = node.parentNode,
                     i, j, curToken, myToken, myClassName, mySensitiveSearch,
                     finalClassName, finalSensitiveSearch,
                     foundIndex, begin, matched, end,
                     textNode, span, isFirst;

                 for (i = 0, j = tokenArr.length; i < j; i++)
                 {
                     curToken = tokenArr[i];
                     myToken = curToken[id.token];
                     myClassName = curToken[id.className];
                     mySensitiveSearch = curToken[id.sensitiveSearch];

                     finalClassName = (classNameAll ? myClassName + " " + classNameAll : myClassName);

                     finalSensitiveSearch = (typeof sensitiveSearchAll !== "undefined" ? sensitiveSearchAll : mySensitiveSearch);

                     isFirst = true;
                     while (true)
                     {
                         if (finalSensitiveSearch)
                             foundIndex = nodeVal.indexOf(myToken);
                         else
                             foundIndex = nodeVal.indexOf(myToken);

                         if (foundIndex < 0)
                         {
                             if (isFirst)
                                 break;

                             if (nodeVal)
                             {
                                 textNode = document.createTextNode(nodeVal);
                                 parentNode.insertBefore(textNode, node);
                             } // End if (nodeVal)

                             parentNode.removeChild(node);
                             break;
                         } // End if (foundIndex < 0)

                         isFirst = false;


                         begin = nodeVal.substring(0, foundIndex);
                         matched = nodeVal.substr(foundIndex, myToken.length);

                         if (begin)
                         {
                             textNode = document.createTextNode(begin);
                             parentNode.insertBefore(textNode, node);
                         } // End if (begin)

                         span = document.createElement("span");
                         span.className += finalClassName;
                         span.appendChild(document.createTextNode(matched));
                         parentNode.insertBefore(span, node);

                         nodeVal = nodeVal.substring(foundIndex + myToken.length);
                     } // Whend

                 } // Next i
             }; // End Function checkAndReplace

             function iterator(p)
             {
                 if (p === null) return;

                 var children = Array.prototype.slice.call(p.childNodes), i, cur;

                 if (children.length)
                 {
                     for (i = 0; i < children.length; i++)
                     {
                         cur = children[i];
                         if (cur.nodeType === 3)
                         {
                             checkAndReplace(cur, tokens, allClassName, allSensitiveSearch);
                         }
                         else if (cur.nodeType === 1)
                         {
                             iterator(cur);
                         }
                     }
                 }
             }; // End Function iterator

             iterator(options[id.container]);
         } // End Function highlighter
         ;


         internalHighlighter(
             {
                 container: container
                 , all:
                     {
                         className: "highlighter"
                     }
                 , tokens: [
                     {
                         token: highlightText
                         , className: "highlight"
                         , sensitiveSearch: false
                     }
                 ]
             }
         ); // End Call internalHighlighter

     } // End Function highlight

 };

 function TestTextHighlighting(highlightText)
 {
    // var container = document.getElementById("testDocument");
     var container = document.getElementById("myTable");
   //  alert("text to high-light: " + highlightText);
     InstantSearch.highlight(container, highlightText);
 }

 function mySearchFunction() {
         // .postMessage("removeKB");
            var input, filter, table, tr, td, i, j, cellValue;
            input = document.getElementById("myInput");
          //  hideKeyboard();  // not working
              //          alert ("input value: " + input.value);
            filter = input.value;
            // window.scrollTo(0, 0);
           // input.blur; // remove onScreenKeyboard
            if(filter != ""){// ถ้าเป็น  ""  และเรียก TestTextHighlighting จะทำให้ โปรแกรมไม่ตอบสนอง(แฮง)
            TestTextHighlighting(filter);  // hi-light search word
            };
        //    document.activeElement.blur(); // remove focuse from input field to hide on screen keyboard
        //    filter = input.value.toUpperCase();

            table = document.getElementById("myTable");
            tr = table.getElementsByTagName("tr");
            for (i = 0; i < tr.length; i++) {
                td = tr[i].getElementsByTagName("td");
                if (td) {
                    for (j = 0; j < td.length; j++) {
                        cellValue = td[j].textContent || td[j].innerText;
                    //    if (cellValue.trim().toUpperCase().indexOf(filter) > -1) {
                        if (cellValue.trim().indexOf(filter) > -1) {
                            tr[i].style.display = "";
                            break;
                        } else {
                            tr[i].style.display = "none";
                        }
                    }
                }
            }
        }

function hideKeyboard() {
  //this set timeout needed for case when hideKeyborad
  //is called inside of 'onfocus' event handler
  setTimeout(function() {

    //creating temp field
    var field = document.createElement('input');
    field.setAttribute('type', 'text');
    //hiding temp field from peoples eyes
    //-webkit-user-modify is nessesary for Android 4.x
    field.setAttribute('style', 'position:absolute; top: 0px; opacity: 0; -webkit-user-modify: read-write-plaintext-only; left:0px;');
    document.body.appendChild(field);

    //adding onfocus event handler for out temp field
    field.onfocus = function(){
      //this timeout of 200ms is nessasary for Android 2.3.x
      setTimeout(function() {

        field.setAttribute('style', 'display:none;');
        setTimeout(function() {
          document.body.removeChild(field);
          document.body.focus();
        }, 14);

      }, 200);
    };
    //focusing it
    field.focus();

  }, 50);
}


function myReset(){
   //     alert("xxxx xxx")
        var thisInput = document.getElementById("myInput");
        thisInput.value = "";
        document.activeElement.blur();
        mySearchFunction("");
}

window.onbeforeunload = function(){  // ก่อนออก ซ่อน keyboard เสียก่อน
var input = document.getElementById("myInput");
   input.blur();  // ซ่อน keyboard
  return true;
};
// ไฟล์ที่เรียกใช้งานนี้ คือไฟล์ html ให้อ่านอย่างเดียวไม่มีการทำข้อสอบ
// เมื่อคลิกมาอ่านแล้ว ถือว่า ทำข้อสอบเสร็จ คือ จะให้ไอคอนหน้าชื่อ แสดงเต็มวง คือ ทำเสร็จ
var numOfQuestions = 10;  // เป็น dummy ว่ามีทั่้งหมด 10 ข้อ
var currQstnID = "tbl_q10"; // เป็น dummy ว่าทำไปถึงข้อ 10 แล้ว จะได้แสดงเครื่องหมายถูก ว่า ทำหมดแล้ว
var clickedQstns = "xzcccx11111";

// คือส่งข้อมูลเพื่อส่งไปยัง WillpopScope ซึ่งจะทำงานตอนคลิกปุ่มลูกศรกลับไปยังหน้าที่แล้วที่เข้ามา
// ข้อมูลที่ส่งไป เอาตามรูปแบบของข้อสอบที่เป็นไฟล์ html ซึ่งประกอบไปด้วย
// จำนวนข้อทั้งหมด, ข้อปัจจุบันที่คลิก, ชื่อ id และ วันที่
// ข้อมูลที่จะเอาไปทำ ไอคอน คือ จำนวนข้อทั้งหมด และข้อที่คลิก ซึ่งเป็นชื่อ id โดยที่ Willpop จะแยกเอาเฉพาะตัวเลข
//  ทำข้อที่ 10 จากจำนวนทั้งหมด 10 ข้อ จึงได้ 100% ได้ไอคอนชื่อ p00.png คือ มีเครื่องหมายถูก แสดงว่า เสร็จแล้ว
var msgToSend = numOfQuestions + "xzc" + currQstnID + clickedQstns;

// ส่งข้อมูลไป flutter ผ่าน JavascriptChannel ชื่อ messageHandler เพื่อบอกว่า ทำเสร็จแล้ว
 messageHandler.postMessage(msgToSend);
//
// *************************

// รับข้อมูลมาจาก flutter
function isBuyAndMode(myDat){
var inComingData = myDat;
var is_Bought;
var isPremium; // ซื้อแล้ว
var is_darkMode;
var htmlMode; // มืดหรือสว่าง

var element = document.body; // สำหรับเปลี่ยนโหมด มืด-สว่าง โดยเปลี่ยนสี background และ ตัวหนังสือ
var hex = ("#00FF00");  // สำหรับเปลี่ยนสีลิงค์

var demo = document.getElementById("demo_version");  // บางไฟล์มี  div ชื่อ demo_version ต้องซ่อน ถ้าซื้อแล้ว
var full = document.getElementById("full_version");
var fadeout = document.getElementById("fadeout");

classRoundedCorner = document.getElementsByClassName('rcorners1');
if (classRoundedCorner.length >= 1) {
    for (var i = 0; i < classRoundedCorner.length; i++){
        classRoundedCorner[i].style.borderColor = '#FDEAB3';
    };
 };
classBigBlue  = document.getElementsByClassName('big_blue');
if (classBigBlue.length >= 1) {
    for (var i = 0; i < classBigBlue.length; i++){
        classBigBlue[i].style.color = '#FBD052';
    };
};
classBigRed = document.getElementsByClassName('big_red');
if (classBigRed.length >= 1) {
    for (var i = 0; i < classBigRed.length; i++){
        classBigRed[i].style.color = '#FFC300';
    };
};

//
//if (abc !== null) {  // ถ้ามี div ชื่อ abc ให้แสดงค่า
//	document.getElementById("abc").innerHTML = "Data from FLUTTER: " + inComingData;
//}

// แยก การซื้อ และวโหมด ที่ส่งเข้ามา คั่นด้วย xyz
datArr = myDat.split("xyz");   //datArr[0] คือ ซื้อแล้วหรือยัง true=ซื้อแล้ว  datArr[1] คือ โหมดมือหรือไม่  true=ใช่โหมดมืด  false=ไม่ใช่โหมดมืด
is_Bought = datArr[0];
if (is_Bought == "true"){
    isPremium= true
 }else{
     isPremium= false
     }

  if (isPremium == true) {
            if (full !== null) {
			full.style.display = 'block';  // แสดงข้อมูลเต็มทั้งหมด
			};
			if (demo !== null) {  // ถ้ามี div ชื่อ demo_version
			       demo.style.display = 'none';  // ซ่อน demo
			};
			if (fadeout !== null) {
			 fadeout.parentNode.removeChild(fadeout);  // ซ่อนข้อความ "อ่านต่อในรุ่นเต็ม"
            }
	}else{
	       if (full !== null) {
			full.style.display = 'none'; // ซ่อนข้อมูลบางส่วนเอาไว้
			if (demo !== null) {  // ถ้ามี div ชื่อ demo_version
            		demo.style.display = 'block';  // ซ่อน demo
            }

            // ยก เลิกดีกว่า
		//	fadeout.style.display='block';  // แสดงข้อความ "อ่านต่อในรุ่นเต็ม"
		}  // end of if (full !== null)
	}  // end of  if (isPremium == true)

// ปรับโหมด มืด-สว่าง
is_darkMode = datArr[1];
// alert("is darkMode: " + is_darkMode);
if (is_darkMode == "true"){
    htmlMode = "dark";
 }else{
         htmlMode = "light";
     }
//
//if (a1 !== null) {  // ถ้ามี div ชื่อ abc ให้แสดงค่า
//	document.getElementById("a1").innerHTML = "โหมด มืด-สว่าง: " + htmlMode;
//}

if (htmlMode=="dark"){
element.style.backgroundColor = 'black';
element.style.color = 'white';

var input = document.getElementById("myInput");
if(input){
        input.style.backgroundColor = '#F8F8F8';
}

//var tableText = getElementsByTagName("td");


// ถ้าอยู่ในโหมดมืด เปลี่ยนสีลิงค์ ให้สว่างขึ้น
    var links = document.getElementsByTagName("a");
    if(links !== null){
    for(var i=0;i<links.length;i++)
    {
        if(links[i].href)
        {
            links[i].style.color = hex;
        }
    }
    } // end of if(links !==
    // change background color of table
  // change table row background
  var tableElements = document.getElementsByTagName("table");
  for(var i = 0; i < tableElements.length; i++){
      var thisTable = tableElements[i] ;
      var rows = thisTable.getElementsByTagName("tr") ;
  		for (var j=0; j<rows.length; j++) {
  				rows[j].style.backgroundColor = "gray";
  				var thisRow = rows[j];
  				  var td_text = thisRow.getElementsByTagName("td")
  				  for(var a=0; a < td_text.length; a++){
  				      td_text[a].style.backgroundColor = "#696969";
  				      td_text[a].style.color = "white";
  				  }
  		}
  	}

}else{
element.style.backgroundColor = 'white';
element.style.color = 'black';
}
}
