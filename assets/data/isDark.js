// สำหรับ เปลี่ยนสีพื้นให้เป็นสีดำ ถ้าอยู่ในโหมด มืด เอาไว้ต่อจาก body จะได้เปิดมา ดำเลย

function isBuyAndMode(myDat){
var inComingData = myDat;
// ข้อมูลที่ส่งมาจาก flutter คือ ซื้อหรือยังและโหมดอะไร คั่นด้วย xyz เป็นลักษณะข้อความ
// เช่น truexyzfalse = ซื้อแล้ว อยู่ในโหมดสว่าง (ตัวแรก -- true=ซื้อแล้ว-เป็นรุ่นเต็ม, false=ยังไม่ได้ซื้อ-เป็นรุ่นจำกัด) (ตัวที่สอง -- true=มืด, false=สว่าง)

var is_darkMode;
var htmlMode; // มืดหรือสว่าง

var element = document.body; // สำหรับเปลี่ยนโหมด มืด-สว่าง โดยเปลี่ยนสี background และ ตัวหนังสือ
// alert("inComingData: " + inComingData);


// แยก การซื้อ และวโหมด ที่ส่งเข้ามา คั่นด้วย xyz
datArr = myDat.split("xyz");   //datArr[0] คือ ซื้อแล้วหรือยัง true=ซื้อแล้ว  datArr[1] คือ โหมดมือหรือไม่  true=ใช่โหมดมืด  false=ไม่ใช่โหมดมืด
// ปรับโหมด มืด-สว่าง
is_darkMode = datArr[1];
if (is_darkMode == "true"){
    htmlMode = "dark";
 }else{
         htmlMode = "light";
     }
// alert("mode1: " + htmlMode);  // มีอะไรผิด ก่อนหน้านี้ ++++ไม่ผิด แต่เอา javascript วางไว้เร็วไปหน่อย ยังไม่ทันสร้าง element เลย เรียกใช้งานแล้ว จึงเกิด Error +++
if (htmlMode=="dark"){
element.style.backgroundColor = 'black';
element.style.color = 'white';
}
} // end of function