import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Curriculum extends StatelessWidget {
  const Curriculum({required Key? key}) : super(key: key);
  static const htmlData = r"""
  <div style='text-align:center'><strong>หลักสูตรการสอบ ก.พ. (ภาค ก.)</strong>
  <br>(ตามหนังสือของ สำนักงาน ก.พ. ที่ นร ๑๐๐๔/ว ๑๒ ลงวันที่ ๒ กรกฎาคม ๒๕๖๒)</div>
 <p>หลักสูตรประกอบด้วย ๓ วิชาหลัก ดังนี้
<br><br>

๑. <strong>วิชาความสามารถในการคิดวิเคราะห์</strong> (๑๐๐ คะแนน) <br>
เป็นการทดสอบความสามารถในการคิดวิเคราะห์ ครอบคลุมประเด็นดังนี้ 
<p>๑) การคิดวิเคราะห์เชิงภาษา ได้แก่ 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-การใข้ภาษาไทยเพื่อการสื่อสาร 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-ความเข้าใจในการอ่านภาษาไทย 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-การจับใจความสำคัญ 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-การสรุปความ การตึความจากบทความ ข้อความ หรือสถานการณ์ต่าง ๆ
<p>๒) การคิดวิเคราะห์เชิงนามธรรม ได้แก่ 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-การคิดหาความสัมพันธ์เชื่อมโยงคำ ข้อความ หรือรูปภาพ <p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-การหาข้อสรุปอย่างสมเหตสมผลจากข้อความ สัญลักษณ์ รูปภาพ สถานการณ์ หรือแบบจำลองต่าง ๆ และ
<p>๓) การคิดวิเคราะห์เชิงปริมาณ ได้แก่ 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-ความเข้าใจ ความคิดรวบยอด 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-การแก้ปัญหาทางคณิตศาสตร์เบื้องต้น 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-การเปรียบเทียบและวิเคราะห์เชิงปริมาณ 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-การประเมิน ความเพียงพอของข้อมูล<br><br>

<strong>๒. วิชาภาษาอังกฤษ</strong> (๕๐ คะแนน) <br>
เป็นการทดสอบทักษะ ภาษาอังกฤษเพื่อวัดความเข้าใจในหลักการสื่อสาร 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-การใช้ศัพท์ สำนวน โครงสร้างประโยคที่เหมาะสม ทั้งในเชิงความหมาย และบริบท แสดงถึงความสามารถในการสื่อสารที่มีประสิทธิภาพ 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-การวัดความสามารถด้านการอ่าน โดยทดสอบการทำความเข้าใจในสาระของข้อความหรือบทความ 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-การวัดความสามารถ ด้านการเขียนภาษาอังกฤษ ในระดับเบื้องต้น<br><br>

<strong>๓. วิชาความรู้และลักษณะการเป็นข้าราชการที่ดี</strong> (๕๐ คะแนน) <br>
เป็นการทดสอบความรู้ที่เป็นพื้นฐานของการเป็นข้าราชการที่ดี ความรู้ดังกล่าว ได้แก่ 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;๑) ระเบียบบริหารราขการแผ่นดิน 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;๒) หลักการบริหารกิจการบ้านเมืองที่ดี 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;๓) วิธีปฏิบัติราชการทางปกครอง 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;๔) หน้าที่และความรับผิด ในการปฏิบัติหน้าที่ราชการ 
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;๕) ประมวลกฎหมายอาญาความผิดต่อตำแหน่งหน้าที่ราชการ
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;๖) เจตคติและจริยธรรมสำหรับข้าราชการ

<hr>
<div style='text-align:center'><strong>โครงสร้างข้อสอบ
</strong></div><br>
<div style='text-align:center'>เวลา 3 ชั่วโมง 100 ข้อ
</div><br><br>


<strong>วิชาความรู้ความสามารถทั่วไป</strong> 
 จำนวน 50 ข้อ* <br><em><small>(เกณฑ์ผ่าน 60% หรือ 30 ข้อ สำหรับ ป.ตรี หรือ 65% หรือ 33 ข้อ สำหรับ ป.โท)</small></em><br>
<br><strong>คณิตศาสตร์ </strong>
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- อนุกรม (5 ข้อ)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ตาราง  (5 ข้อ)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- คณิตศาสตร์ทั่วไป  (5 ข้อ)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- อุปมาอุปไมย  (5 ข้อ)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- เงื่อนไขสัญลักษณ์  (10 ข้อ)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- เงื่อนไขภาษา  (5 ข้อ)



<br><strong>วิชาภาษาไทย</strong>
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- การเรียงประโยค (5 ข้อ)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ความเข้าใจภาษา (10 ข้อ)<br><br>

<strong>วิชาภาษาอังกฤษ</strong> จำนวน 25 ข้อ*
<br><em><small>(เกณฑ์ผ่าน 50% หรือ 13 ข้อ)</small></em>
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- conversation (5 ข้อ)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- vocaburaly (5 ข้อ)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- structure (5 ข้อ)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- reading (10 ข้อ)<br><br>

<strong>วิชาความรู้และลักษณะการเป็นข้าราชการที่ดี</strong> (กฎหมาย) จำนวน 25 ข้อ* 
<br><em><small>(เกณฑ์ผ่าน 60% หรือ 15 ข้อ)</small></em>
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- พ.ร.บ. บริหารราชการแผ่นดิน (6 ข้อ)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- พ.ร.ฎ. กิจการบ้านเมืองที่ดี (6 ข้อ)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- พ.ร.บ. วิธีปฏิบัติราชการทางปกครอง (6 ข้อ)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- พ.ร.บ.มาตรฐานทางจริยธรรม (3 ข้อ)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- พ.ร.บ.ความรับผิดทางละเมิดของเจ้าหน้าที่ (2 ข้อ)
<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- ประมวลกฎหมายอาญาความผิดต่อตำแหน่งหน้าที่ราชการ (2 ข้อ)<br><br>

*<small><em>เทียบเคียงกับปีที่ผ่าน ๆ มา อาจมีการเปลี่ยนแปลงได้</em></small><br><br>

<strong>คำแนะนำการเตรียมตัวสอบ</strong><br>&nbsp;
<ol>
<li>คณิตศาสตร์ สอบผ่านไม่ยากอย่างที่คิด ทักษะที่ใช้ส่วนใหญ่เป็น บวก ลบ คูณและหาร 
<ul>
<li>คณิตทั่วไป มีเพียง 5 ข้อ เท่านั้น แต่ต้องการความรู้พื้นฐานทางคณิตศาสตร์ ถ้าไม่ค่อยถนัด อย่าไปเสียเวลาเตรียมตัวกับเรื่องนี้มากเกินไป</li>
<li>อุปมาอุปไมย ของตาย ฝึกทำเยอะ ๆ ควรได้คะแนนเต็ม</li>
<li>เรื่อง อนุกรม เงื่อนไขสัญลักษณ์ เงื่อนไขภาษา ไม่ต้องการความรู้พื้นฐานมากนัก ใช้เหตุและผล ประกอบกับ ทักษะ บวก ลบ คูณ หาร สามารถเก็บคะแนนให้ผ่านได้ ควรฝึกทำเยอะ ๆ</li>
<li>เรื่อง operate ที่ผ่านมามีออกข้อเดียว ลองดู ถ้าเห็นง่ายทำเลย ถ้าคิดไม่ออก เก็บไว้ทำทีหลัง อย่าเสียเวลา</li>
</ul>
</li>
<li>ภาษาอังกฤษ เป็นยาหม้อใหญ่ ต้องอาศัยเวลา
<ul>
<li>ไวยากรณ์ หรือ Structure หรือ Grammar น่าจะพอได้ แนะนำให้ศึกษาจากเมนู "สรุป/ทบทวน Grammar"</li>
<li>ดูจากรูปประโยค หรือ คำ แล้วเดาคำตอบได้ เช่น มีคำว่า last, yesterday กริยาต้องเป็นช่อง 2 เป็นต้น</li>
<li>บทสนทนา ส่วนใหญ่คำศัพท์ไม่ยาก </li>
<li>คำศัพท์ในแอพนี้ ค้นหาคำที่เคยออก หรือคำที่พบบ่อย ๆ ได้ </li>
<li>ถ้าเป็นเรื่องให้อ่าน จดหมาย หรือบทสนทนายาว ๆ ส่วนใหญ่จะมีคำศัพท์แปลไว้ให้ ถ้าคำใดมีเส้นประแสดงว่า มีคำแปล สำหรับคำที่ไม่มีเส้นประ สามารถแตะค้างไว้ จะมีเมนูย่อยให้เลือกแปลได้</li>
<li>แต่ทั้งหมดนี้ ต้องฝึกทำเยอะ ๆ</li>
</ul>
</li>
<li>กฎหมาย สอบผ่านได้
<ul>
<li>ส่วนใหญ่มักจะออกวน ๆ ประเด็นซ้ำ ๆ</li>
<li>อ่าน พ.ร.บ. ฉบับเต็มให้เข้าใจ ทำสรุปย่อ จับประเด็นให้ได้</li>
<li>ฝึกทำข้อสอบ และทบทวน</li>

</ul>
</li>

</ol>


<hr>
<strong>เทคนิคการทำข้อสอบ</strong>
<ol>
<li>จัดเตรียมอุปกรณ์การสอบ ให้พร้อม</li>
<li>ทำใจให้สบาย พร้อมทำข้อสอบ</li>
<li>เลือกทำวิชาที่ใช้เวลาน้อยก่อน เช่น<br>กฏหมาย  → ภาษาไทย  → อังกฤษ  → คณิต</li>
<li>ข้อไหนคิดว่ายาก ควรข้ามไปทำข้อที่ง่ายก่อน อย่าเสียเวลากับข้อยาก เมื่อมีเวลาเหลือจึงค่อยกลับมาทำอีกที</li>
<li>เมื่อทำเสร็จแล้ว ควรทบทวนดูอีกครั้ง ใช้เวลาให้เต็มที่</li>
<li>ขอให้สอบผ่านทุกคน</li>
</ol>
<hr>


<br>




""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xFFFFFFFF),
      // ใช้ 0xff เพิ่มเข้าข้างหน้าตัวเลข hex ของสี
      // แทนเครื่องหมาย # เป็นการใช้ hex color code กับ flutter
      appBar: AppBar(
        title: Text(
          'เตรียมสอบ ก.พ. ภาค ก.',
          //  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).primaryColorDark,
            child: Center(
              child: Text(
                'หลักสูตรการสอบ ก.พ. ภาค ก.',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.white70,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Html(data: htmlData),
            ),
          ),
        ],
      ),
    );
  }
}
